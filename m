Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21635CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:17:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2BC38E0017; Fri, 12 Sep 2025 05:17:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 966198E0016; Fri, 12 Sep 2025 05:17:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8083E8E0017; Fri, 12 Sep 2025 05:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62D258E0016
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:17:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F30511AB77
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:17:54 +0000 (UTC)
X-FDA: 83880046068.01.27E51B8
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6C6F1180003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:17:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=KyjAe7kB;
	spf=pass (imf24.hostedemail.com: domain of "prvs=343957b79=roypat@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757668671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KTZ/VOJbbCjyGaq9AddgILCkPAHpmVIUuRAnTMPHRJE=;
	b=JtSlRVxJ7dDyJi2r+bHNOD3z6umVOQ6cOr4zS64Jt4JTIyx/0wyZxaMu3/7CW232Q3XEX+
	nKqtbyxeD6QwqpJjANk9CQEoztpHqw6vw1KQ6D5GH/pREL2xC7Q5nZ36fKidEN8HXgU8Xv
	syEUJHkc+eODr6bfTWDo6NoqWcNeRF0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=KyjAe7kB;
	spf=pass (imf24.hostedemail.com: domain of "prvs=343957b79=roypat@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757668671; a=rsa-sha256;
	cv=none;
	b=XuO0wg3Si+CBvuQ4+hoDd98OPe81bADgQe1jmTceoZk38tVqHV6qi/PgSqAy8S/4Is4prX
	zXKO935bFerhET6API7umPeNDgQfhArp7Oed19p3DVIY80l3p2Xya+ovBFo1Y7307EOkLj
	sPP05K2zGS81yXCudA8DUwU3B5IkSnk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1757668671; x=1789204671;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=KTZ/VOJbbCjyGaq9AddgILCkPAHpmVIUuRAnTMPHRJE=;
  b=KyjAe7kBd0ik7HQmLa3oMKMI44nvG05vWYbjSQAJM4A2TLlNGTy69yeR
   xZNF4ENLlH0IaQyiwyku39vwMjPEPT+h3/FG7Y24qFSFxEx0Wnnc++IAv
   6CjBSRkVxCGg8kygE1+NDWP2PbV2adLtJQ23dfLi3cQDWIuYq94zV3G3B
   6JacNwHTacnoVx2qW9cXp/S2GYvFj/O1TJx/rDenUjViOKksqIyfQCsXS
   G+dDZYsx9v7hDWiW4yo7ONqwTHC1QkI04mepKlSFT2ov9NECGBD8lGMiJ
   3IzJ6MH2DHCeLSVSC4tbC6gCrrJJbtalK2wmQxWKMjgNpjp6+4IVnjjcO
   w==;
X-CSE-ConnectionGUID: QEXct2vdTta8TMzv4Ngyng==
X-CSE-MsgGUID: jfWOQOMCT/uSRNaEor6nYA==
X-IronPort-AV: E=Sophos;i="6.18,259,1751241600"; 
   d="scan'208";a="2007537"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 09:17:41 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:27364]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.20.211:2525] with esmtp (Farcaster)
 id 5628c97f-0538-4e01-83c3-9a2b6facd620; Fri, 12 Sep 2025 09:17:41 +0000 (UTC)
X-Farcaster-Flow-ID: 5628c97f-0538-4e01-83c3-9a2b6facd620
Received: from EX19D015EUB002.ant.amazon.com (10.252.51.123) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:40 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB002.ant.amazon.com (10.252.51.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:39 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Fri, 12 Sep 2025 09:17:39 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
CC: "Thomson, Jack" <jackabt@amazon.co.uk>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "willy@infradead.org" <willy@infradead.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "kernel@xen0n.name"
	<kernel@xen0n.name>, "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "aou@eecs.berkeley.edu"
	<aou@eecs.berkeley.edu>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "gor@linux.ibm.com"
	<gor@linux.ibm.com>, "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "trondmy@kernel.org" <trondmy@kernel.org>, "anna@kernel.org"
	<anna@kernel.org>, "hubcap@omnibond.com" <hubcap@omnibond.com>,
	"martin@omnibond.com" <martin@omnibond.com>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "brauner@kernel.org" <brauner@kernel.org>,
	"jack@suse.cz" <jack@suse.cz>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org"
	<ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev"
	<martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>,
	"song@kernel.org" <song@kernel.org>, "yonghong.song@linux.dev"
	<yonghong.song@linux.dev>, "john.fastabend@gmail.com"
	<john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>,
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com"
	<peterx@redhat.com>, "jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "yuanchu@google.com" <yuanchu@google.com>,
	"weixugc@google.com" <weixugc@google.com>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "zhengqi.arch@bytedance.com"
	<zhengqi.arch@bytedance.com>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "shuah@kernel.org" <shuah@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "linux-nfs@vger.kernel.org"
	<linux-nfs@vger.kernel.org>, "devel@lists.orangefs.org"
	<devel@lists.orangefs.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: [PATCH v6 06/11] KVM: selftests: load elf via bounce buffer
Thread-Topic: [PATCH v6 06/11] KVM: selftests: load elf via bounce buffer
Thread-Index: AQHcI8YWbSkdpV9N8kuaL7J+KZ9Yaw==
Date: Fri, 12 Sep 2025 09:17:39 +0000
Message-ID: <20250912091708.17502-7-roypat@amazon.co.uk>
References: <20250912091708.17502-1-roypat@amazon.co.uk>
In-Reply-To: <20250912091708.17502-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: z4hi9jxfwgswjwazwkj7x8qh3jx9qoks
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C6F1180003
X-Rspamd-Server: rspam04
X-HE-Tag: 1757668671-429377
X-HE-Meta: U2FsdGVkX19JrRPZtsPDE9IlzF9Jz08VPTOehqT71gxf+61jpRHB21tehZ/+qX5FJjvgsNtk+UY6Apov1D0VWw/thxIe6lNIKyUmrAabaMbRIOZ0FXobjd5KjIhmsIAMwjrygjUX+MfOdHATZWTkxrTjKkbn2J074sPxeRmn4RmVsWYVCgQPDmJHloGzObEjmaK6tbWJbh+4jL0C/DN1Bjrchf44ruXzuSjlp1lEIccoMcmFaMzk8D5HlAvWsl9jW6MJtFSWVOoK6bdBR85YjaI+y3ZZsOg4d0Ckt78/0IF13i6A9btYBhsnrARlXpqEX1YbkL/ZiHs+WFPSjDOprOo49mV779t/TN7GC9QLETEZzs+JaQPy8VwjwJpHoWoYOCDxNvWt8kK7C2H9DHMfBHnslxuJikhKxLI1OAf4zO2lGeIJ+zgRk1o+gezDPGnWNpRx2CvXP2J8UDXYYbA0PSO53dq9cncMT3wgHi4doZG4Pi1tTm9YZdQqRwFKGtRSXSNNUaYLzITQeqTpMQwgNVYYG34opt/zhri630Q1K+ZiD+J1ah5xBGUf+gJXiTSjGfzBNyTyQTyvaIflUOmZA0sN9c734Wm0ITHM/rL8mehGjYFXv6SMeiwlOHBH0hVkZNAgQJbFRSv2QOjqjDI0eHpreAedHWw4xNHIG3OLclAjKB5X8SkJILeWsI/WwEcuDPCCZfQS8wSz5e6huGWEHveC5+TnilcVr7YSJ9PBA5DcZ920Pl/iIPvamFObtd//DrVsw5nB+P48i+gMEsQvv7/b5pkmxOjzfrECjK/6l6x8WVbqIu+Cjubtds99hl/w2EyNcvr4N1/4wAw3LC9e0KPSWKqspxqVHAZBWwKkM73T1gwBG+pkb0TAOmGzWq7Xhfi49glHdGQQAvJSo7mklToPjmq58Cu4Bkrsvydp9q1SipkSkdPCEqr5uNADQOHzu6vkdr3rTp85guy2ins
 K0X4R0LX
 3yuDYtL/qubdex7mtA+d7lHnfBpJIPEFIxQn1SWAI9OgjIJ8gy2jdiK1EufnKLOe4C8TulSw45G5Z4hJ4feBb9lWbEoqN01FFSYdQFzPJTyHjZGlPFcFftWy7Cr9Ia6E9v4qhjBuo+NZ6VPbOYaQPs6Lo7xlhSPJUF4UKXRD/QR4Fj/j2d++W0o2TCofbua5I/ykZrY6cM9nONBDVSW5D+DKoud6EHVslpfg18CYg/d/BXaJAc47TR2t5XdduBIt2L8VCV9crrM2w/vZAYuvoF9KazPcv2dHxiNk4dqJVCy/1sWnwuGZKVZaO/kedfTRQQ+O3S+b6DyeGkAxVOK1ay1fPIV4urrRaVmq7XTzle60D7fqmBddWid9ORWl374b75gsXXCyf18oRtC17TWER/eYFJ0Oab6Lj1XjogIakiYeJoqqrgZOYZXZxtXjURYDxDYk3AOC7fcHMYGODRa8CPnlfKFvNNwR45n32fZ3/G8wRTcuXWDTcFALSJPZ8kplQ4PYt6gTsCEKy0wJwJFsa7FnBxc4DS3F3yUpW1EahW+PNVwEqU5iMRRHFiPWNnAHYdbRAFBsGSW9KmpJH6tXTSh8sRTjTm/dCl3INkwNGBkJbHWR2TqBvqRBl58YU0wP2XZM+YDXCkDyqUxCCRx3FmCqLr7iRUTzSz9EibH0VTVOceYvFmUvIeqhIb3eF+KTfi2eN13t+0y8NHMFFMX3nOfFI2plCUTxTPZdogl3+ZnAlr5iYOtwfQnwVifYhRa4UdN8njll8+S/rR3QkzzCQ49CSb4wkNUdwmpukqwtfWPXfFZFvxAr0jgfk3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If guest memory is backed using a VMA that does not allow GUP (e.g. a=0A=
userspace mapping of guest_memfd when the fd was allocated using=0A=
KVM_GMEM_NO_DIRECT_MAP), then directly loading the test ELF binary into=0A=
it via read(2) potentially does not work. To nevertheless support=0A=
loading binaries in this cases, do the read(2) syscall using a bounce=0A=
buffer, and then memcpy from the bounce buffer into guest memory.=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 .../testing/selftests/kvm/include/test_util.h |  1 +=0A=
 tools/testing/selftests/kvm/lib/elf.c         |  8 +++----=0A=
 tools/testing/selftests/kvm/lib/io.c          | 23 +++++++++++++++++++=0A=
 3 files changed, 28 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testin=
g/selftests/kvm/include/test_util.h=0A=
index c6ef895fbd9a..0409b7b96c94 100644=0A=
--- a/tools/testing/selftests/kvm/include/test_util.h=0A=
+++ b/tools/testing/selftests/kvm/include/test_util.h=0A=
@@ -46,6 +46,7 @@ do {								\=0A=
 =0A=
 ssize_t test_write(int fd, const void *buf, size_t count);=0A=
 ssize_t test_read(int fd, void *buf, size_t count);=0A=
+ssize_t test_read_bounce(int fd, void *buf, size_t count);=0A=
 int test_seq_read(const char *path, char **bufp, size_t *sizep);=0A=
 =0A=
 void __printf(5, 6) test_assert(bool exp, const char *exp_str,=0A=
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftest=
s/kvm/lib/elf.c=0A=
index f34d926d9735..e829fbe0a11e 100644=0A=
--- a/tools/testing/selftests/kvm/lib/elf.c=0A=
+++ b/tools/testing/selftests/kvm/lib/elf.c=0A=
@@ -31,7 +31,7 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *=
hdrp)=0A=
 	 * the real size of the ELF header.=0A=
 	 */=0A=
 	unsigned char ident[EI_NIDENT];=0A=
-	test_read(fd, ident, sizeof(ident));=0A=
+	test_read_bounce(fd, ident, sizeof(ident));=0A=
 	TEST_ASSERT((ident[EI_MAG0] =3D=3D ELFMAG0) && (ident[EI_MAG1] =3D=3D ELF=
MAG1)=0A=
 		&& (ident[EI_MAG2] =3D=3D ELFMAG2) && (ident[EI_MAG3] =3D=3D ELFMAG3),=
=0A=
 		"ELF MAGIC Mismatch,\n"=0A=
@@ -79,7 +79,7 @@ static void elfhdr_get(const char *filename, Elf64_Ehdr *=
hdrp)=0A=
 	offset_rv =3D lseek(fd, 0, SEEK_SET);=0A=
 	TEST_ASSERT(offset_rv =3D=3D 0, "Seek to ELF header failed,\n"=0A=
 		"  rv: %zi expected: %i", offset_rv, 0);=0A=
-	test_read(fd, hdrp, sizeof(*hdrp));=0A=
+	test_read_bounce(fd, hdrp, sizeof(*hdrp));=0A=
 	TEST_ASSERT(hdrp->e_phentsize =3D=3D sizeof(Elf64_Phdr),=0A=
 		"Unexpected physical header size,\n"=0A=
 		"  hdrp->e_phentsize: %x\n"=0A=
@@ -146,7 +146,7 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *fil=
ename)=0A=
 =0A=
 		/* Read in the program header. */=0A=
 		Elf64_Phdr phdr;=0A=
-		test_read(fd, &phdr, sizeof(phdr));=0A=
+		test_read_bounce(fd, &phdr, sizeof(phdr));=0A=
 =0A=
 		/* Skip if this header doesn't describe a loadable segment. */=0A=
 		if (phdr.p_type !=3D PT_LOAD)=0A=
@@ -187,7 +187,7 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *fil=
ename)=0A=
 				"  expected: 0x%jx",=0A=
 				n1, errno, (intmax_t) offset_rv,=0A=
 				(intmax_t) phdr.p_offset);=0A=
-			test_read(fd, addr_gva2hva(vm, phdr.p_vaddr),=0A=
+			test_read_bounce(fd, addr_gva2hva(vm, phdr.p_vaddr),=0A=
 				phdr.p_filesz);=0A=
 		}=0A=
 	}=0A=
diff --git a/tools/testing/selftests/kvm/lib/io.c b/tools/testing/selftests=
/kvm/lib/io.c=0A=
index fedb2a741f0b..74419becc8bc 100644=0A=
--- a/tools/testing/selftests/kvm/lib/io.c=0A=
+++ b/tools/testing/selftests/kvm/lib/io.c=0A=
@@ -155,3 +155,26 @@ ssize_t test_read(int fd, void *buf, size_t count)=0A=
 =0A=
 	return num_read;=0A=
 }=0A=
+=0A=
+/* Test read via intermediary buffer=0A=
+ *=0A=
+ * Same as test_read, except read(2)s happen into a bounce buffer that is =
memcpy'd=0A=
+ * to buf. For use with buffers that cannot be GUP'd (e.g. guest_memfd VMA=
s if=0A=
+ * guest_memfd was created with GUEST_MEMFD_FLAG_NO_DIRECT_MAP).=0A=
+ */=0A=
+ssize_t test_read_bounce(int fd, void *buf, size_t count)=0A=
+{=0A=
+	void *bounce_buffer;=0A=
+	ssize_t num_read;=0A=
+=0A=
+	TEST_ASSERT(count >=3D 0, "Unexpected count, count: %li", count);=0A=
+=0A=
+	bounce_buffer =3D malloc(count);=0A=
+	TEST_ASSERT(bounce_buffer !=3D NULL, "Failed to allocate bounce buffer");=
=0A=
+=0A=
+	num_read =3D test_read(fd, bounce_buffer, count);=0A=
+	memcpy(buf, bounce_buffer, num_read);=0A=
+	free(bounce_buffer);=0A=
+=0A=
+	return num_read;=0A=
+}=0A=
-- =0A=
2.50.1=0A=
=0A=

