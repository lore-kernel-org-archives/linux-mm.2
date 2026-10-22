Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A6F5606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lFiWcrUI
Received: by kanga.kvack.org (Postfix)
	id 995636B02FC; Thu, 22 Oct 2026 19:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87B3E6B02F8; Thu, 22 Oct 2026 19:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 658916B0301; Thu, 22 Oct 2026 19:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6586B02F8
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 827101A034C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:25 +0000 (UTC)
X-FDA: 85351853370.22.B28ED48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 68FDC4000B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lFiWcrUI;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711703;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aB8+j9B9rOi2goIvl66WjEN0Kr+n4FfUHBUuzxrcyGg=;
	b=eElXrzwtsIwLC4GtdQAzCxmpMr55uBLZ/zv8nT6Vz+dQyS10BDO78UmYcAOh6sfpsWrshl
	dNWydiImAMtJUuX89TsNDGYLVVUGrr9xrUN48vjN6tNUMrfz6b6nl1MBf5XxDEsDmvcukn
	5CKPw55l0t8oIwdM39FBi3XuNsSYcZ0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711703;
	b=yuu/ObeJdY9XgXrMD1e5bB2LJWzded9S1ShZHfnjw07a0173qoQmXLbA2Bfe9uxOl1AXE0
	1M2iN3ZUIuPIDx3H9ZFvoePv7vlfZ00JKJChDDpGHQOYUMzbF8rUDdPsmRXEAl2o0iXTLl
	BwSmUE1poltpk4lqnNyVxQSThlhDeDg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lFiWcrUI;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C56474485D;
	Thu, 22 Oct 2026 23:28:17 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711697;
	b=dVI75+fEAEU+6IVnA3jda9pavEvFMpnYNHGqYpSrU4rtL91+kyhmqmxJ3IikDvbqMGke
	 sVwdAlD6u+eDi/DHIaS+1/1MpcWL74Z6XS3ywDnWZfjd8X+NcTzeLm81oDJiLDxWjB7P7
	 6KXSDQ4PP4bOIO8ldsUeYoz3STFwNqkkEhCyqb72m9x2rhcFqnHMYCUX2hLOA7u4f41a7
	 Y+VVTMN8/ubC1A9dcBjic+TGXxnsCYhf+Pzf2YqhP2n7SKUC1hsJ16E9HnjGdBN5quiKG
	 Gdp3taXOF8D13jXMsFKQsI4EmxidE6JHOHJpnAJKNAxT9JT0xpuqgaSHUUJ/CJVeVjg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711697;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=aB8+j9B9rOi2goIvl66WjEN0Kr+n4FfUHBUuzxrcyGg=;
	b=lO8jWnTdg2yGBzG1cYiI6dFHlcvXqny//rHg8F0OCjsoFDOA06McZZED6OOmBQBowuIJ
	 jt8QCpcn7aXUKeVV7Ps8ojTP302xa7c6H6FHTXA3jcfGqbA4mBbCKOsl/KE/fBD51sJfi
	 ivSCACVG+YaoXITNybr+haNU2DZnSeuUVf4s9gFDKVpuumI3Xd4wAn+07IkJ4VKcOOkdY
	 vfTvEWeaWyhClCtQGRRMkBy5y0pAJnDLwUAi70PeSeoHRS1mCDgF8y9V9IOhjF2B7TDK8
	 dn7f8AlW+xykZ4nzcEBsA5+bsw5DeFeKkp6vXfMQDw1alx/bu8qxIgEJb1TGj+lHM6g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BF8D91F01190;
	Thu, 22 Oct 2026 23:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711697;
	bh=aB8+j9B9rOi2goIvl66WjEN0Kr+n4FfUHBUuzxrcyGg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=lFiWcrUICzTQLBdVd17MJXIUiXdRXOplomn++FzAilPPV1xm1G4JqriXtmUiJoVNa
	 8A1zVdlfxAHrIDedQnaY6i3oGmL0hKSMk9DTJjaqbGkiZL+TFQWX1F0f2OWysl1ETA
	 mO1w6yyypEFbvIUA2EfTzd+L1VACc3KcfzSqAOrAoWcauePuRIEa/G0wpNPgt+vnP3
	 WkstdG5SaCqfxWi9uW+2JXr6IEyE6Tt1SVaNwPY83nD22ZDCbZ+JQNR3/hsE39m6Up
	 1794et8OcBvGmy5KdrU6qJodE//Rtlq5C785fA1j/LpccBY4hchUD99w5zmSVSe9jX
	 FpRQp6g8cDnKQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 82107420AC;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:58 -0700
Subject: [PATCH RFC v2 26/50] samples/kvm: Remove fixed address and length
 module parameters
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-26-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
In-Reply-To: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
To: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Alexey Kardashevskiy <aik@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Ashish Kalra <ashish.kalra@amd.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Brauner <brauner@kernel.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Connor Williamson <connordw@amazon.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
 David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
 Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, Fred Griffoul <griffoul@gmail.com>, 
 Gregory Price <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, 
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, 
 James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Jianxiong Gao <jxgao@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
 John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
 Justin Stitt <justinstitt@google.com>, Kevin Tian <kevin.tian@intel.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Robin Murphy <robin.murphy@arm.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
 Steffen Eiden <seiden@linux.ibm.com>, Steven Price <steven.price@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
 Vishal Annapurve <vannapurve@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
 Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=4776;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ZvgRlCQoX8aAOrmBNmY778ViCyt2HTQ8fDZpwcewiX8=;
 b=hMQxwei6fo+VWEPARf94RDMkjPiXa+ZvJwZ4AhdrwKCCaWXn8vnLqltUKdpAyZOGn4NdnyfGr
 LnjlZ8YhxflCPm+xo9J+Bmw3RSJruFNHUioJ+FO3GfZblRoOKJxiBWk
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 68FDC4000B
X-Stat-Signature: xqkqdpap8mw9nkoon4yu5h8bif6yjehu
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711703-768252
X-HE-Meta: U2FsdGVkX19air8iVlcQp75Kj3SpLsrP7kd6ZxCYoQm26V9yrrKBPK68/+9+urJuBlCbaHH+p7ZDM1b80xd8mBER4Y6S2zvakvxh+OtXzIGpnSrzACvv1BQ6ng9pGaM8uKI9KR3J3ugZ780jPDQ6kC5SrBYhDa5FlQuvfqQglaMxAXorr2gOqz2JR29/qHcTSO0LCekFD1JmaMyG9EDbbKwnowV/s5OvDSUEMXmTsUqNAzb5ZcjYyoQTm3fRGHfbhiJKLpmV+uJ7W2JmHe+y9edXt0zU4kstqYhIXhnzzIOowp4bisufioh4361ReXMcYcDedtjMM5JTLS7OVXgWrQV1VbnKzhG9Yv/iQQ3VMGjTklL/YZoetGu2PhQBpal11afp9dnZ297dESgqEzpwyedCLdyTd06oU0zOQI5pWaJirwJ56Ojrk+h9gkknQ1MUyh/udurFDfG0226myiV8vgmuGnfJp748odmnvNB7SCqW9tQi9+b2wEFV9fXZwCjNoQJ3/MDUOMY5uR0htOxzxZm5Oitqs0r1u1hhL1vv5XYMKi0R/HrgUz5u3rwxCoV5AYETdCBQv/NKSI81GAfNCKFkIcJ9zksNIodP+n917ffpaJBYerrFYSElOJx4S4WyAdx6WMz41X/it4Xw0o94l2RMlJ/RTbqk8Wso9rvbyvBBHTF+Qw2CRumj1Lfh+OmurlHgAbjipncHNriXg7Ch8RF2JSnYuz3v6waj/h0QmfCOhV2L3x87xlWlulyYk9QE8TZQGjsHggXc4EQ+37bgpcjzmL9t1S+C/MEpTNv20ReDEcI69U8ASnpz927iGgVGIa94QUDIem65YrUgtJolt5WqKTjqvxip9xn0jiQ4w9r5or5/FfFWdtmSJ4QPulunvQXyRu/Im3u9OUv4iHQbgvJe3PLNmCk/Yv64ldjhARvsxWEEV/lT5NPwqw1PaGRcuqqidnJ+oAx+EUiIIxr
 DsSfoT8s
 R2EkeHXms8XsOlupo2i36Al5Iamt3qIUr1pIc5IRvX0Wi2+86Ezf1ZhGV0uiE5j3sjsdUNEtRBqByTQfQpCI9z0OQSfAxeBw6ZpZVxV6CHYAUx9+QXoZpD8CTESGbvGnn/w2JWaTZSldUJWnCpB9IvlpQz67E4zrn/QEQXALuJ3hgMiO8KKyXZhYIoHp9pibtiMnDUi8V1cvic525PHJyXqHVKFnaA2i3HZ9MohVK7t/dIV7CJDVALVAXdW3x7php8A6Yt53qHjE6Ex/I4VwWjU2UE5I1mGkhPp9DOSjtE1BrB+paroWf7pGKbRYk9ZUuN2YMsuG+yaMmX7kYVvqCX0a4MvHvBbgF/SHk83NLVtNHdrp6ZrA1B3gVdsbfJoFtGEANTnInTXmrtW48/aqA23tUoupVAHzo27UY0BvEAoRSsURJKLKjKnG7BH3Z1ybZnBJswDsqhxDXRsXtv4kmNCaKzj0njcDitCMrcWsBBWAwp19JZ0equWMixpcV7xqx4bcyPsHTVyKcMvdVCHAcq/Au90Ym5wgAQhuY2ttCMV3wam8VTImm6dpXsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Remove the addr and len module parameters from the sample memory
provider.

The prototype doesn't require pre-carved out memory ranges, since
MPS_NEW_CHILD already allows carving out memory on the fly. Being able to
carve out memory on the fly makes testing easier.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 samples/Kconfig                   | 12 +++------
 samples/kvm/mem_provider_sample.c | 53 +++++++++------------------------------
 2 files changed, 15 insertions(+), 50 deletions(-)

diff --git a/samples/Kconfig b/samples/Kconfig
index 3c870bca076af..a06eafb5d7ba4 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -331,15 +331,9 @@ config SAMPLE_KVM_MEM_PROVIDER
 	depends on MEM_PROVIDER && CONTIG_ALLOC && X86_64 && m
 	help
 	  This builds a sample memory provider (include/linux/mem_provider.h).
-	  Its files can back a guest_memfd and be mapped by iommufd.  Loaded
-	  with addr= and len=, it lends a fixed physical range that has no
-	  struct page, for example memory hidden with memmap= on the command
-	  line.  Without them, it allocates a contiguous region with
-	  alloc_contig_pages().
-
-	  It shows how a memory owner moves pages between VMs, takes them
-	  back or makes them read only, and how guest_memfd and iommufd
-	  follow each change.
+	  Its files can back a guest_memfd and be mapped by iommufd.
+	  It allocates a contiguous region with alloc_contig_pages()
+	  and carves out child provider files on the fly.
 
 	  If unsure, say N.
 
diff --git a/samples/kvm/mem_provider_sample.c b/samples/kvm/mem_provider_sample.c
index f7ecb2ea1d75d..574c712a11389 100644
--- a/samples/kvm/mem_provider_sample.c
+++ b/samples/kvm/mem_provider_sample.c
@@ -8,17 +8,9 @@
  * guest's devices.  The module calls neither KVM nor iommufd: it answers
  * "what is page N" and revokes a range when the answer changes.
  *
- * The region is either:
- *
- *  - a fixed range given with addr= and len=, which has no struct page, for
- *    example memory hidden from the kernel with memmap= on the command line;
- *  - or, without those parameters, a range from alloc_contig_pages().
- *
  * The control device /dev/mem_provider_sample creates provider files.
- * SETUP makes one file over the whole region.  NEW_CHILD carves part of the
- * region into a child file, and MOVE, DONATE and RECLAIM change which child
- * has which page.  A page can also be taken away or made read only.  See
- * mem_provider_sample.h.
+ * NEW_CHILD carves part of the region into a child file. A page can also
+ * be taken away. See mem_provider_sample.h.
  *
  * Confidential VMs are not supported.
  */
@@ -38,15 +30,6 @@
 
 #include "mem_provider_sample.h"
 
-static unsigned long long addr;
-module_param(addr, ullong, 0444);
-MODULE_PARM_DESC(addr,
-		 "Physical base of a region with no struct page (optional)");
-
-static unsigned long long len;
-module_param(len, ullong, 0444);
-MODULE_PARM_DESC(len, "Size in bytes of that region (optional)");
-
 /*
  * One provider file.
  *
@@ -314,32 +297,26 @@ static struct page *mps_alloc_region(unsigned long npages)
 
 /* ---- Root and children -------------------------------------------------- */
 
-/* Create the root on the first NEW_CHILD, from addr=/len= or of @size. */
+/* Create the root on the first NEW_CHILD of @size. */
 static int mps_root_ensure(u64 size)
 {
-	struct page *pages = NULL;
+	struct page *pages;
 	unsigned long npages;
 
 	lockdep_assert_held(&mps_root.lock);
 	if (mps_root.npages)
 		return 0;
 
-	if (addr && len) {
-		mps_root.base_pfn = addr >> PAGE_SHIFT;
-		npages = len >> PAGE_SHIFT;
-	} else {
-		if (!size || !PAGE_ALIGNED(size))
-			return -EINVAL;
-		npages = size >> PAGE_SHIFT;
-		pages = mps_alloc_region(npages);
-		if (!pages)
-			return -ENOMEM;
-		mps_root.base_pfn = page_to_pfn(pages);
-	}
+	if (!size || !PAGE_ALIGNED(size))
+		return -EINVAL;
+	npages = size >> PAGE_SHIFT;
+	pages = mps_alloc_region(npages);
+	if (!pages)
+		return -ENOMEM;
+	mps_root.base_pfn = page_to_pfn(pages);
 	mps_root.allocated = bitmap_zalloc(npages, GFP_KERNEL);
 	if (!mps_root.allocated) {
-		if (pages)
-			free_contig_range(page_to_pfn(pages), npages);
+		free_contig_range(page_to_pfn(pages), npages);
 		return -ENOMEM;
 	}
 	mps_root.cma_pages = pages;
@@ -489,12 +466,6 @@ static int __init mps_init(void)
 {
 	int ret;
 
-	if ((addr || len) &&
-	    (!addr || !len || !PAGE_ALIGNED(addr) || !PAGE_ALIGNED(len))) {
-		pr_err("mem_provider_sample: addr= and len= must both be set and page aligned\n");
-		return -EINVAL;
-	}
-
 	mutex_init(&mps_root.lock);
 	INIT_LIST_HEAD(&mps_root.children);
 

-- 
2.56.0.257.gf7497c7d27-goog



