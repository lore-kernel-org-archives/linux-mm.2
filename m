Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 358BCD33994
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 16:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84E4E6B018D; Fri,  5 Dec 2025 11:59:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FEF26B018F; Fri,  5 Dec 2025 11:59:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679626B0190; Fri,  5 Dec 2025 11:59:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC806B018D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 11:59:22 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1C324B7701
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:59:22 +0000 (UTC)
X-FDA: 84186028164.13.4ADA0F6
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	by imf15.hostedemail.com (Postfix) with ESMTP id 93638A0022
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:59:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=cLDCa7TY;
	spf=pass (imf15.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764953959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CWGOx1LJU1Lp2rVsMU/Gh8xhbQtWU2hA9WJ9kcqa2lY=;
	b=wbDgOVFv+MrS5qz+eZ3f/Lr0ciqZiBW32hrDcTyzailxwi2yOx3oOCJwqtRQhj/zkBsvIG
	bLXAvaLYw3js1rh6nGvJsweP8OnTLXpjWP0t+08k7vy6OMUNgxnhzcUNWH+cyFjSIHEbKN
	R+arfIPTrV7yJbP235mnwoIc/gxzRMo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764953959; a=rsa-sha256;
	cv=none;
	b=CXpVuqEIZywpOa8lThEEd2EgISY66ANPGduv2rnnmA0hABM3/AsAWPnrXWXu3E8vJhnUNW
	N8kFxB3DOdjB3gZhZPyILaIqUEuqC6KMOHfjvWA2yOPrVyKf5luDOPzRFHs6NX8LMfiE0K
	9E5I7nlv2PteX8vKZnLB+GJ+/czV8Do=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=cLDCa7TY;
	spf=pass (imf15.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1764953959; x=1796489959;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CWGOx1LJU1Lp2rVsMU/Gh8xhbQtWU2hA9WJ9kcqa2lY=;
  b=cLDCa7TYYD3PGU+HhAAEY4cDfxeeHz5KdBM+xPIYefZ4VAJ64wn/mV08
   3PNwJ1rXImSbPXf5StMc6K5r0LnqglWCAoK22ppaGv7uuTgywcUpi01O1
   zdDOL6ezEsh/hd6/97IMgTcLC0VuX2hf0fIk6KMvYbCma0bqpoGtDn5uo
   gyrB0xwln5F90MbITJYm/Q4HToW2sZ7TXzlRxOAoEDvXJGFefzCsUO8FM
   m/C9rdfg9aTwaETbJn1XhgcuJL7DoMHiVYbAit96MX092Wzk7U7CNFQgH
   vIVbW/HQAemKoauAgm5O9FpKdqueNuR+v6YIv5jF3gycov3HQdaQvoOYT
   Q==;
X-CSE-ConnectionGUID: CA8/vzSqQKyCPtR3yMet3A==
X-CSE-MsgGUID: 8BJPWskwRySewdUd9tj6Rw==
X-IronPort-AV: E=Sophos;i="6.20,252,1758585600"; 
   d="scan'208";a="6191229"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 16:59:19 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:10319]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.37.108:2525] with esmtp (Farcaster)
 id 90fbd84d-f4a1-4839-8024-b62656e1a5de; Fri, 5 Dec 2025 16:59:18 +0000 (UTC)
X-Farcaster-Flow-ID: 90fbd84d-f4a1-4839-8024-b62656e1a5de
Received: from EX19D005EUB004.ant.amazon.com (10.252.51.126) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:59:18 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB004.ant.amazon.com (10.252.51.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:59:17 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.029; Fri, 5 Dec 2025 16:59:17 +0000
From: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org"
	<luto@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"willy@infradead.org" <willy@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
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
	"pfalcato@suse.de" <pfalcato@suse.de>, "shuah@kernel.org" <shuah@kernel.org>,
	"riel@surriel.com" <riel@surriel.com>, "baohua@kernel.org"
	<baohua@kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"jgross@suse.com" <jgross@suse.com>, "yu-cheng.yu@intel.com"
	<yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com"
	<coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "isaku.yamahata@intel.com"
	<isaku.yamahata@intel.com>, "jmattson@google.com" <jmattson@google.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "vannapurve@google.com"
	<vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>,
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev"
	<patrick.roy@linux.dev>, "Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri,
 Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>
Subject: [PATCH v8 08/13] KVM: selftests: load elf via bounce buffer
Thread-Topic: [PATCH v8 08/13] KVM: selftests: load elf via bounce buffer
Thread-Index: AQHcZgh+ROJLYEtTXUy85DKC2famHw==
Date: Fri, 5 Dec 2025 16:59:17 +0000
Message-ID: <20251205165743.9341-9-kalyazin@amazon.com>
References: <20251205165743.9341-1-kalyazin@amazon.com>
In-Reply-To: <20251205165743.9341-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Queue-Id: 93638A0022
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: dfwuq6rws8tjt5fagaxrorjfkihu1h4b
X-HE-Tag: 1764953959-480789
X-HE-Meta: U2FsdGVkX1+TQR+lMMn5g/MOmVGykD8vIcqmqy0jgs+yPxRjLvAQQ4f3tPhmWm7Irdw0O2RQq9sZVKWtDEQirGPAVt5opOrqWz7wHfwC6dFCXpFbeWZl2WJimDdUcE3ZspQlzMNsrnrJAd9Fd7cYSzoLg4Y0Z2YW9BVlBVh7qyc0vwc2LhAV4wWjTLKS9J18qJgAl8htqFKNF/3iRTV4e2RhO2sEMRO6JNWQR0MS7SEh4ERadB/8I2un58cltWX4RL6l7+CJ0VRbecUjoeqkHkCK59SH+p+W9O0hq3Kc1vOeX7kBTEH2HoOyvGgCgePdxNeeqKA/NGWXWLTFpicusnSyk45qqdyxVV52pA2GbwL5VTSKJtyAkAt2jNbq9/Jn0AGOneuVuflsm4kklKLHIPy1GxtrTR32Gg1e6Re86XvIWwa3x88rOwY4oY0e3J/K9zzDW7vpvciO3CrI9hBUNiEFAIi9Bo3uZjuB4Fhtg/HaLrksFqIHd+tLOBSZMDTyJ/b+aQeSNtbsHlzRQ7oOxHKf1KpPqcRi5Nd6eyLjyLNx9DN2+wfZkr6yppeqyBXaMOLnpIjGB2H1JDIFsUvwn3PWySNQCChRFj30rzK7k8i87c9ZFXpiC5wfh2LgUTZvh3NVXboI/MeMEw84i/YznpQF1ueNpTt1qWredZA8B8IgnZfXFkqU1lXa+0wq5q7X8fZhDqTpvR6srtEK4rl1+oUezijXe1750FjzxdE49+JNRm68AiRMEKo8+jBJYOLLGhjldc7eWQHIPN82Qc4GAGYE2Lbq+hywNq+oGPoPCttryUICAYFU7Qg/fickNZTpv9rmF6H6oqJJ92aAn+ig97w//HjsxFxeO1ioT0O+Ve6xu2B8NQhEXrl8sosw9jWTfHAnLrYo3LeBhORPbsMHGljXhLivkAZN+gSZ10kUE2k4ex/y74IQVHtCPaFSMhUyEvU6NDr/iAcocgTYdZ7
 0jDhDrow
 ILjSOxPFbKwbLHdW3znqPO9L2JGoWGY5pkDJfHSeuke5ujVhvjMVzb8o0BCVgtEkN2z2mCLYK4kV9a9hvzQPTjdlQK4RMjLbVYgMa96cubu0YIRxAsCwO899/lGg+s7MuIjQgQiH8IpCgmILmN4iHXePqR3LSg3HuO9vp3KA8HW7qVDoKQLeq4El6rvzJOtE5Cr4GABpAxq2Nrt+R9lV3LQ4diFB4L8fnMHMp82y92/OczlZN6OTutBtjVRIoTnQMseF9VZECEXcoPwVmNWNaKeKOuFJVvmvBgrv8MZLnfV3vrBlRriXgQXRiABOAvZHDousmQnBFFNb+9EKAFJqOKnq3MV0u89wx63xuZJCfGdBm5m9pBIAfPg0M8X66qP7QVZ2wqYVpij/vik2t1dpAT73Kxe4MGov8Dassk4JZeP7C8j57/SEtTpx1ySfw9BVPlKyaNTyayuf0WCH+yrxXsWgI5FpyeLr3CjeEBRG+ubsO5x/tQREEJ9+dDIjk97LnFHHgGlMIELLwieBW8rxo2CfNlV5rVm1DDRtyHleJC8VvK9fvrbGe1NKP5/rZ8z6cyAUr584hNV5KHVowJNCk1AIdaYouW2ZSBlx81AMvsF9z1uv8g1TKj7ghiaCQ/U+dJgcsd9nNl8TEPl3xDzmiCuz/de7y+x2Ai5D2boHTNaBEKXwgqhheTWIh0Teds/4kOHIi9hi5gdn3FLo2rZzeFFHAChbIQTNl1sCr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
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

