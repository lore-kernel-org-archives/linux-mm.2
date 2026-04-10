Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81C1EF459F4
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6F8A6B0089; Fri, 10 Apr 2026 11:19:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45CC6B00AD; Fri, 10 Apr 2026 11:19:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CED166B00AF; Fri, 10 Apr 2026 11:19:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE58B6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:19:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 70C178AF92
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:19:50 +0000 (UTC)
X-FDA: 84643006140.20.C27416D
Received: from iad-out-004.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-004.esa.us-east-1.outbound.mail-perimeter.amazon.com [18.207.52.234])
	by imf01.hostedemail.com (Postfix) with ESMTP id 17A884000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:19:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=f26tJkJR;
	spf=pass (imf01.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 18.207.52.234 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834388; a=rsa-sha256;
	cv=none;
	b=QdJLhdZsq20uHWHl/EOiFR28RGWbs3C4WHbSgdScbdn+tq2dwy+ivvXTYV5/sl+NXLjHsg
	DBKQT6X14qkSgmbTTwgxz8EaVmlAHe+QRj8q1M1mNZbiIz1/Yriq3qIJx3NmBR94zYIuqe
	8UyjUe40xlgrFXsDzuzJRCO042MGH4s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9AZvXIS6OPz4VC6vnroXL89T6Mz/5fVsIMVdDbwGEXY=;
	b=5AnzESzkGT8vjsdQm0qnhOtevvqwbb000+hox2TvqhAvp2R7czcrdW6ZPlr1USzmGRqaf4
	vgy8POCa6g5Te5XCz0OfNHGe9LD7jQBn4DfsVYUuOIHEFV/RTQlA9Coidq8v4UzGdD/riu
	QP2+YX9i4jwZQency3HtWfktU/eMTis=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=f26tJkJR;
	spf=pass (imf01.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 18.207.52.234 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1775834388; x=1807370388;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9AZvXIS6OPz4VC6vnroXL89T6Mz/5fVsIMVdDbwGEXY=;
  b=f26tJkJR10xzQb4X9hPVwhBkSOhgNXX0BzIyhtosoSejiOwUTKUmVB8W
   g+qHVSU7I17GvteebaJXw//H/dEOzjvvgfQPfnOyu5KuNb/JbvVISuBlS
   Q9F6yRw2IUQ2BHaUpFs63iGJI2E5MDG+2L440MSLutbLKS/o2sh/1vmjn
   LPH1MfZEcxkMXUOMzbbAIzZZwjgOMhNeczulBy730+gOmPeD649oJHWF2
   6SHszkFzocpErpeCHckjGv6FZEfidZHEf6JzMadF3jSbdG36AXTaURBgv
   iDxzrP9qjV4Uu7NUCNea0IatuliTnD0HWrqdzv9BWKrs4Yb3s+HClc+g+
   g==;
X-CSE-ConnectionGUID: M26goA0tSKCt61n1t5miEQ==
X-CSE-MsgGUID: p4vxgQEbS2yNHnJ+fQDUIw==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15970710"
Received: from ip-10-4-3-150.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.3.150])
  by internal-iad-out-004.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:19:47 +0000
Received: from EX19MTAUEA002.ant.amazon.com [52.94.133.129:2788]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.3.180:2525] with esmtp (Farcaster)
 id df850dd8-e5f5-43bf-9a52-e7ef1a4bcb2b; Fri, 10 Apr 2026 15:19:46 +0000 (UTC)
X-Farcaster-Flow-ID: df850dd8-e5f5-43bf-9a52-e7ef1a4bcb2b
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19MTAUEA002.ant.amazon.com (10.252.134.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:19:46 +0000
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19D027UEC003.ant.amazon.com (10.252.137.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:19:46 +0000
Received: from EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d]) by
 EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d%3]) with mapi id
 15.02.2562.037; Fri, 10 Apr 2026 15:19:46 +0000
From: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org"
	<willy@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net"
	<daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com"
	<eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
	<kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org"
	<jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "riel@surriel.com"
	<riel@surriel.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"jgross@suse.com" <jgross@suse.com>, "yu-cheng.yu@intel.com"
	<yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com"
	<coxu@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com"
	<ajones@ventanamicro.com>, "maobibo@loongson.cn" <maobibo@loongson.cn>,
	"tabba@google.com" <tabba@google.com>, "prsampat@amd.com" <prsampat@amd.com>,
	"wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>,
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com"
	<agordeev@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "borntraeger@linux.ibm.com"
	<borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "palmer@dabbelt.com"
	<palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "thuth@redhat.com"
	<thuth@redhat.com>, "yang@os.amperecomputing.com"
	<yang@os.amperecomputing.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "urezki@gmail.com" <urezki@gmail.com>,
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, "lenb@kernel.org"
	<lenb@kernel.org>, "pavel@kernel.org" <pavel@kernel.org>, "rafael@kernel.org"
	<rafael@kernel.org>, "yangyicong@hisilicon.com" <yangyicong@hisilicon.com>,
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
	<jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro"
	<itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>, "Kalyazin,
 Nikita" <kalyazin@amazon.co.uk>
Subject: [PATCH v12 11/16] KVM: selftests: load elf via bounce buffer
Thread-Topic: [PATCH v12 11/16] KVM: selftests: load elf via bounce buffer
Thread-Index: AQHcyP12vfUteAUrQUiofzOtFzvBBQ==
Date: Fri, 10 Apr 2026 15:19:46 +0000
Message-ID: <20260410151746.61150-12-kalyazin@amazon.com>
References: <20260410151746.61150-1-kalyazin@amazon.com>
In-Reply-To: <20260410151746.61150-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 17A884000A
X-Stat-Signature: 3eayycd4q8pyzdb6czt15a5eyyt9yhr8
X-HE-Tag: 1775834387-860801
X-HE-Meta: U2FsdGVkX1+nsqDYdam3aYJWR+QubG6lw3s+FDOz4rFhU5SlaP6OaZGwaAANqxzeubjJ8waSaiw53gR1QaHnV4chKiiL+aYkadw+huW9+CSdUBALYzsvnu5CbNtKV+Plx2nZrwAuCaUH1z32wixFaDi8IcLm7x2M9JWCo3GVhgWoDvGfRnv+hDi/qCIG14Y9heVSLLMVGDDEYCh4TyfGFQ5x5S3pgRlVjXmBvdOfVdALn8s1bRTEmpCPbBMcY/3t+xZOLYM0Nfn0Wkq/X5bYxFfhxlpbfOBIhczGquk999sX9gGejb4CFEobvoIJMmXHhLXyTqQuhMAlJ2uxP7AMCvVKXmHdJ0kQAn7oiqJQMoii54Jt9pKttiPzb33KSWz4gGcrck4sXWpE0/BLkOd/AporxJlmiLaIpCdiw73lctuN6CwmCLNd7xprSNyGi9Q2eBu0U505bqmoy0ao6EjGxhhcYFfB2PEza+KJN8B07n3WFueXtxzV3vy1MGkQf3QO31ATkokm6KxlLDjQZ/q/4/2XPahB5HX3ETKN9bREqrOB40eG4gKgfX2KyrOmby0lUKrLDpvlV0HaPx6aW/BBvL3Sm+QUE5Ky2yw8t45ZoVPdhNsBrtuVsIP2azZo74w4C8eS5o4XL0qiLmkRZZAdRDjMQ4TiJtMARg+G/rSALOLaglIDY9+yNkAlrQU17SR4FdYHNQC2xnsYWFuxNqaPbbxpzlWhJOZcugC797sdRv6rEesbxtYi/qWpC30ueWKQJEELpr0L8fW1uNld7qaIiDuCxldpL2Ir8Sskbi9HRwwaF01OuiU5YszRi3WUzy2c3fn9/bRdY3vJgXZMH6RZ5yJ2+x1D0EYp4ZRILGivjxoZxVfjmvMzXY/YwlZSCpRUedb99M3PMXCVYd5DBTa8PQAI3qHB0eoInNeJdTUDTmOXXK54v9NyqgkrqeP9RIJKJVWanPmHSICsd1SDuDx
 ibS5hRKc
 /P4/GiJKrVvr2PGP5aLiqNTrFjFuhEuGUmY/UFhiXqU30WfPQnG+FrYJ8xNXhA5ThwtejL7x0+5kyyKyNVKdmw63piaae81ZmTOcUicS7PRARHJsAmFzCNIl+SGytvOZdExx9OLbuxKgBodG85l0jY/WDzA0lc3UtPjRWyVwC6fNdtJ0TaTEb+4j7LKevHNlRnfj18v3wD6oKYo62SH2NUnEPoKMfZle1m0bGsWu0E1bNotP8SVtgiIVWb264FQkgzUaiybAoJNSpM+IP1CdXrEJsgNxFalAQ0I5wlix66cd+krfHRwh0kdTZtmOGcFeUEJbxVOCXwt0pQZcROF4aa3gg9eVMBXZbCfVtDOXEIg+XWkOaLHORVu/GPTb19HuUqsQAbmCjhPV4apeERXD2aoBcwBDdmunT6tZRudSY/n/S/hdmHWVE9x2aFiEWWF2GHAVBZ/diC/p0OwEWpy2ADCIwvmL1QCAqqwNhVb6hWi7UCfx4yrHDZV/YzlD79ZPsFqNg4gdCJ87iN1zJ27XS4Kia/XOEXx77it8/nGPmHXRJENiN+egxMnJIyFIbxGraIwJ4t9Wuhh5ghZqDZ/tp/bGGAxNobzbrcr478pWeU2xz6EvJNImnfMl9HytGvkOF2sfEIjmtOZP6UBFJhftBdAUOKzp0ja6bpobpB5SBJ/fs20P1ti8Mf+8kQ5Bd+1NM0GyY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
If guest memory is backed using a VMA that does not allow GUP (e.g. a=0A=
userspace mapping of guest_memfd when the fd was allocated using=0A=
GUEST_MEMFD_FLAG_NO_DIRECT_MAP), then directly loading the test ELF=0A=
binary into it via read(2) potentially does not work. To nevertheless=0A=
support loading binaries in this cases, do the read(2) syscall using a=0A=
bounce buffer, and then memcpy from the bounce buffer into guest memory.=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>=0A=
---=0A=
 .../testing/selftests/kvm/include/test_util.h |  1 +=0A=
 tools/testing/selftests/kvm/lib/elf.c         |  8 +++----=0A=
 tools/testing/selftests/kvm/lib/io.c          | 23 +++++++++++++++++++=0A=
 3 files changed, 28 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testin=
g/selftests/kvm/include/test_util.h=0A=
index b4872ba8ed12..8140e59b59e5 100644=0A=
--- a/tools/testing/selftests/kvm/include/test_util.h=0A=
+++ b/tools/testing/selftests/kvm/include/test_util.h=0A=
@@ -48,6 +48,7 @@ do {								\=0A=
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
index fedb2a741f0b..60613dce6cfd 100644=0A=
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
+	TEST_ASSERT(count > 0, "Unexpected count, count: %zu", count);=0A=
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

