Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCFCCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D21608E002C; Wed, 24 Sep 2025 11:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCFE28E000F; Wed, 24 Sep 2025 11:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0078E002C; Wed, 24 Sep 2025 11:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71DFE8E002D
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:22:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3ED821608D0
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:22:58 +0000 (UTC)
X-FDA: 83924511636.07.41D013D
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf28.hostedemail.com (Postfix) with ESMTP id EBC5EC000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:22:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="rLlFR/XH";
	spf=pass (imf28.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758727376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fwuOn8KmcONpor6475z4a6iAc6NYodWwaYYzOF3e0Lo=;
	b=h8hgj+9u1w6j4B4a1KRXa11So/mg0b18eYDVYxGkpHu22dDQgpGRP9D9+A1uSLpyNPvgGS
	8mPElPKffxsmE8/rdvYRPaFZWmQLqvMOLEw//9DSpN8K6r5el7glwpkM+6nUhL4Dq3qOeu
	ucvb4mw+a2AxHZ0+EzCPxIPlzr7UyrY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758727376; a=rsa-sha256;
	cv=none;
	b=lVut6rLvAKR5U3LbzBoE0lrY4DqQ7kGuCfagxqzBsVvGEKoeZ8Ppd5T9TEtxD5QRsk4WGS
	ANxv4Ypoxf5mcfdGFH1zEySbhxX5ahvejLlgpfNKtQHiRwQnIEH7Zf3MFGn7lf0dz8S3H6
	6E6d3oRB1NLMA3Cl63+/yEQKVVcNHBY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="rLlFR/XH";
	spf=pass (imf28.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1758727376; x=1790263376;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=fwuOn8KmcONpor6475z4a6iAc6NYodWwaYYzOF3e0Lo=;
  b=rLlFR/XHPI4BzghRfR1Li1oa/dqHegB1akTPRPrIRFJJoopQ2Eg9F+m7
   PerrQwhpoLFk3dQPsespATE2XidbTjTYpJaAC7dY6b9MHN1JhwTxffPNB
   g6hJYy/XmdE4+NdlwB29HOfjiuAMwRQCaP0cCKAGzsdVlC+q5bLEUO0iS
   f1Cpm88gaZuTNPKe2/gf4VDLg+c8FY2tTfH9tCraSYIOp+GLYlcEF9/RK
   5eYTHlstOS3VAYAykcGkuB3ziI2t3nS6PyvwjtYkwYd78JNC4Q50xjP9f
   WmeAEToxZPSOQHyEEU30zRKYlEEfPITfON/xTBXeRImi2J8O4OdcHijKz
   Q==;
X-CSE-ConnectionGUID: 3KcrWpitTni7ZUwFEhmFwg==
X-CSE-MsgGUID: sideuYNXSLqtDf7iOO0d8A==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2515601"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 15:22:43 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:12793]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.33.43:2525] with esmtp (Farcaster)
 id 05b828f8-2645-4858-a369-d7e3edfeaf1d; Wed, 24 Sep 2025 15:22:43 +0000 (UTC)
X-Farcaster-Flow-ID: 05b828f8-2645-4858-a369-d7e3edfeaf1d
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:43 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:42 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Wed, 24 Sep 2025 15:22:42 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
CC: "Roy, Patrick" <roypat@amazon.co.uk>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org"
	<luto@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"willy@infradead.org" <willy@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "song@kernel.org"
	<song@kernel.org>, "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org"
	<ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev"
	<martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
	<kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com"
	<peterx@redhat.com>, "jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "shuah@kernel.org" <shuah@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "Cali,
 Marco" <xmarcalx@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"Thomson, Jack" <jackabt@amazon.co.uk>, "derekmn@amazon.co.uk"
	<derekmn@amazon.co.uk>, "tabba@google.com" <tabba@google.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>
Subject: [PATCH v7 07/12] KVM: selftests: load elf via bounce buffer
Thread-Topic: [PATCH v7 07/12] KVM: selftests: load elf via bounce buffer
Thread-Index: AQHcLWcSEuY/WJjA/kiX+WaVyFi9Ig==
Date: Wed, 24 Sep 2025 15:22:42 +0000
Message-ID: <20250924152214.7292-4-roypat@amazon.co.uk>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
In-Reply-To: <20250924152214.7292-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EBC5EC000A
X-Stat-Signature: igyayqdjtj6tokpbtdejrhpm67jigr9p
X-Rspam-User: 
X-HE-Tag: 1758727375-360869
X-HE-Meta: U2FsdGVkX19VZ+rCpM0j5EygROOFlNzv/em+cO6E1t70DWdQGMFCpeIGYIwwZhf5J6zFkmj5hzjHt4DNFMPjojq/5L59u2vUpU6nC447T4NVIkmDA9ideRTHIK9t6DgDHct6BDVBrQ2L4qw04liHcJ1jvv4RUl2kRBjruNJKhRs8qlfz74qFUbe+cYUgIiHBId3fOwPnGX6GmWbPJdNp9AdHe8CLtzicN1xSICF0zkhakTajG2eyVe2Wxdsplhrq1TDcUN1mGbTPvIfjplv+Fx8vZt9QCAY9YVYozdawzB4qBmyy6jRyDHzSM7eyNVBFy9bJZmviP6Du0teczzChdxhumvAI45KIV5122CVvwhLYOtNVDMX7XwSYzVvm8qCk6Ds02MGhYiQZsmNdBtSF+HsyIs3y8CX1gzesvJi9H/bucrH7TNxIHvJFmS8iv1/A2Kamg07MsJS72/j/gk/dn+ed57rZrqX+JWSDsBm2qR9iqAOL3yWnDSQzpH9MM6GtQafqm+G4LYhZfxbW/bssYOmHKmOLHAsRFfs07p5ABcbOpbdp9fD/j1HATxGPONPNCZFuxAhaXTV7E1Zq83P1OIPTQf3bz4BvchA9Ji4atTNs8hcJILcqisFrokNGpKjd+rWXjv7ueAGYle7KHpUHgQEGuuxZDYi8pfA4QxixejRhIttUwSX53cwsvX8uvZXEgwTLUBLSHD4wH0k9kmYNZdzbxw0gL8mo4tHs4lbgGTT9Eb2YgSDEyYd93BQ9PgMcCzOhWe8jX/jQswWUsxxkbrRYVf5MdrjlhYSJWjTyzcK2GBcIhC2EyGUb608i6cc++I8BDkjGWdMUSyuGGmBXkFbIMPmDffWhcXRVk0aaZi2zNPfl/sOXtyrbn5j4EYoRa3YOU3lExzJFiT46vEE0zibSQDK/fwX/7lseQM25u3W6g8JcUkNN3uGV7aSGMSq8Ac8KNm940GxbO3Dp6pC
 L1GsgzUa
 ProHbfbaFdEJtTCsMXo18oU6VPyokA4kAdOjQ3BilRdUAMszrmCsgcvqPJG9cz1RFQyDUDHFVBhtrNdSwY0LlcQemjzIUReZOHZOnNl6r7UI6+1gWpRJFsglcshZStdnhkOZBNylt2HsRhTYGQaSAFd/kXZ/6OU561Q90V9RGiK5IfxHVUmHyerBb2uoAyw6ZE48kIgakXWCx84W9tWjz2/tWGVf0PTL+EDaE7r22XXarLQQNpnE9PQUQZQRzaRyBMMrAM+0ybLnS/sgGYAofBGWvTl0HjIvtmZKPohhBON3xkNMRfUsZIU4bNhtUwt4+rvRtpXxGSz0q9sZXpfP1uleR8k/NBaXvqrtctueUT4YZVj+m+orVlQmp8ZcZwOJVaWaG
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
2.51.0=0A=
=0A=

