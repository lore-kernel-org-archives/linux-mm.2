Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE2BCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCB1F8E000F; Thu, 28 Aug 2025 05:39:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C53D18E0001; Thu, 28 Aug 2025 05:39:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4778E000F; Thu, 28 Aug 2025 05:39:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98DCE8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:39:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6111D1DEC02
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:42 +0000 (UTC)
X-FDA: 83825669004.15.0564FF4
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf23.hostedemail.com (Postfix) with ESMTP id DBD0E140002
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=k92f1cQt;
	spf=pass (imf23.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756373980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KTZ/VOJbbCjyGaq9AddgILCkPAHpmVIUuRAnTMPHRJE=;
	b=BlQZECUU2tda1m04PeB7YGk82Qel8M2iJsPCPcOS5clDAZtEvJ9wnLfMOEqhrrS8v3Mj+G
	Z6EKo8Su+TbblQBDQVVoK7xoBSVRwovffUBN+LLWNEoSGNjDIX5ivmq9peifWkUSIcrCur
	ylzOJ2z3H+vgMD/blN47AU+yezruIZQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=k92f1cQt;
	spf=pass (imf23.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756373980; a=rsa-sha256;
	cv=none;
	b=kbQnXp6ZB/7d7uZ69d0S/O7IICYBWHdxK3pBJfp/m5Y+DashGyZUX1RGVeOzRGLLsi9R2/
	iIqjp9yZDup7H2PHzD9lo36lyH5V1GbR049OpCqrJGrN23elCaOwK9U2HZHeOE8SzL12Xn
	xTbsJK7tZpFqR+TvrNVDjIBvxp4F8SI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373980; x=1787909980;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KTZ/VOJbbCjyGaq9AddgILCkPAHpmVIUuRAnTMPHRJE=;
  b=k92f1cQtDSwrVndkA7vwNwWEqmh7leO2uRwsQhhU3W2sKC7Ny/q39y5w
   vx9v5Uetq9d+N7O1ogusVA4uCxbScxJUddTZ4PxSS5H9xalJPTzJwRNGs
   yr/g0aTO1CVLOZEZUa4k5GimUPLsstjCXlOfWI03RCKZW+xG9oiXyOP7o
   EfN0qO6UQudxJBYCcMta1RSEc4Iv/mFH6IXVL73+bs5rbtUBobNB/rRVQ
   3SU05XPqD6YVf754hNzgnwbbrp+i7DNUepIvFeP42Oc/ccUE6c7KhYZJ4
   eHCGOH569nRLxbLCyg2/9j5yK3qw4t/x63qYfYfWaphIL97funs/lEuRb
   g==;
X-CSE-ConnectionGUID: u9bjUTy6TKSekmiuaprUTA==
X-CSE-MsgGUID: 8rDPM4y3Rdeb1tmBEIF3eA==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1303834"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:27 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:20173]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.43.161:2525] with esmtp (Farcaster)
 id f5543d0c-1ca4-4856-a828-4fcfa81cf84a; Thu, 28 Aug 2025 09:39:27 +0000 (UTC)
X-Farcaster-Flow-ID: f5543d0c-1ca4-4856-a828-4fcfa81cf84a
Received: from EX19D015EUB002.ant.amazon.com (10.252.51.123) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:24 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB002.ant.amazon.com (10.252.51.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:24 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:24 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Roy, Patrick" <roypat@amazon.co.uk>, "tabba@google.com"
	<tabba@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Subject: [PATCH v5 06/12] KVM: selftests: load elf via bounce buffer
Thread-Topic: [PATCH v5 06/12] KVM: selftests: load elf via bounce buffer
Thread-Index: AQHcF/+j1UnlcgO4tUakgBJ2Lj709w==
Date: Thu, 28 Aug 2025 09:39:24 +0000
Message-ID: <20250828093902.2719-7-roypat@amazon.co.uk>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
In-Reply-To: <20250828093902.2719-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: n1h64dpm1xbhsyfk3i4z3keexy8e8gm3
X-Rspam-User: 
X-Rspamd-Queue-Id: DBD0E140002
X-Rspamd-Server: rspam01
X-HE-Tag: 1756373979-229067
X-HE-Meta: U2FsdGVkX1953iTLy2MRHp5yiY1wVeButHAx1J3tgVfrpY2HyC28ATlkpfP238qhFs0fI0TIYfh2eCNR+d3Yc/2Bziit8U9otBjKkYKDnK87GJ2QFD4Qu8jS2SItxSsW3vrxY7ZFgh4vh6cfugopDNsi3aMn8a2fau9RBMPMPjIFxmU4V6E1L/qv2TkTep4Dea/USqdZVOKkjc7k919WQ0m43DORpME63zBU9HEOKrlsdfR+NyBkJdAHU4HkPFijGBzSeHpj2ggRrNrzYdXYJIfrBtWWH1SxvvoH7T6zBw3VJjA6SODIinEWphYqKJYFd29ot8YX4Sz6Ixy6v5z/vVot7Wep17FZ7yqTQ13iQcluWzyrVAdNKs4HpidSskmOSaMThfnrgiRVcOMnQHT98KIMPcz2KJO4L6T2sM4k5V3VCV64QWoyh/T3ehGiOXnCncp1Cb5bk+M1qs6is3b5dmd2jEH8b/X1YnfjDoiRo1/cFl+wImm6O8VkeAeEUrPmqUoaEjW3chjfNYhVNR7yRR3OWBkFLssnpQZa+zysUta19trxpw5SYEW6xmwmqmBkDC/3FD4gmSMMCZeyzndM+xWqjlycEVEHHX5TF7feNCOMrdHwwHZjdDKpIv+YOcjlvUcabgGfeaNmuv/XRtyuTXU1A2wWXcmkcMxrDnVKpmJMnWEv5umXZssz9CBvVsl7Xra0XJo8n3HSRD9OKZPPPlogOSAfey64eGcTcKN76DPSk+1wc0WEXKJMKrXjCpXH6U8zsHXfwRFdKCOvjdBgcegpAoFUmdUsKV2TZ2fjgOEoFrARX0JKpy2HRDpSklXEoPhmmJ73TyWdWGV2e9bfYCAsOVgt2vHmwkcvcETzpOt6AbW3ohtyjSFt1l7fb6E32aOqei86J/G2OCAsEJ1Nu0mDyPKjde1w7kJKRZYYByHo6bY/ORzaepLB4UG1ftlGaVaOg6y/6Cx1ocJZZP7
 c8ezWGN/
 7s4gg5Yzfmz6ODhtAh6Ge0ycUlMg9VvK29/JjuB2H5zjV3/ZGH0hwr6Vvc9iMlRGkHlcIdntVIT0eE4N3xU0eNjkr7LoxUOPhzllvz7HYonkLSleJQ9EpKyhScF2yVevyqeBWPvF09t1Ht3r42b6uXw3KtnF1yDofqlcguVRCOjTf0k9yyhJT49fBuK2RLj2nLYgJGMQnDakJwqmOiGqbw/KhkEFl9yp9uBwkEXIaUbdPRhMw12uQqHzx5147OsjNBl/WdLu5bo+qsOIuRlqa0+mHMhipmt34/wmGLExJH3yLrRfamzf4VS5on35UDP+nJZlLjcdVtqEj/IfyP+dVMS+P9LAoCfTpiOjyenNDbhBtegF7SBSSN2F32/V6wTXaCK2HKU+w3p3l2krBlIruX1ZR9f68+pcRQRndIZhVNkW46oRlc73vhr8+BTtCguF+fxnWYcFBBFGDKX3Zuxiv8HiFJ6siIi5LF3sJ7suVJyF0j0atGWzHyZd73AumeCxDKaIBqfRJFmHFZ9V/OMXoUo+rbjs1rYJTNj6+kmFwabE7Sl/SHfbsI13xl3Oe/+4K2Q/+VjzfGV35LIaQRCWvkW+R4Gq8+Tbu7nNpUSX3PV4e1piNmMztkA5mRODNrhTDvOk5VtbVTWpxAU0dDIJvBCAAK6DpgSa9v1asnFdj3BdMn4GNuKOdFpxzQA==
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

