Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC323CD4F3E
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 05:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22A396B0023; Thu, 20 Nov 2025 00:36:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200A66B0024; Thu, 20 Nov 2025 00:36:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E7B6B0026; Thu, 20 Nov 2025 00:36:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 00BC26B0024
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:36:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3E12C06F8
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:36:19 +0000 (UTC)
X-FDA: 84129874878.08.669D75F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf14.hostedemail.com (Postfix) with ESMTP id C3DBE100004
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:36:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z4iVZK7L;
	spf=pass (imf14.hostedemail.com: domain of vivek.kasireddy@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=vivek.kasireddy@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763616978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qabJ+FfYjgTHfqHaJgR4Lx8YLTjsdhvhkxdVtN2zHCs=;
	b=vJdR5ycJOMT3oZPLw6JmhqYxD/xe6ErPLMl3PXlL/ci0I3mXVDAEs1xpj7FO7XqHMKSobk
	Fi0GQm0YaBlBOUv3OoX/d1KvvJ8amCWJdNZ9Oijl7D3f8o6ZYA+rWIoN9aI8WK5iCceSRA
	JGFXCTbQafn7fjrX6AIol61FCt71DQU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763616978; a=rsa-sha256;
	cv=none;
	b=OQ8D6x0DqGFS1LlaMMFfmbIqc0YEOvkNpZ3mYHPPxR9byGGrKUlClFRlfpXy30bNnYs2ri
	WQcG9Ni/Xzn4XMrhZt+kSDePoXpLBeSVif3Lcz2ENiZReu+I8koJporXa7iufs6Q1b+xgF
	sBSiaCRh5HR7KwSFtFJc2A0y6pPCKyg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z4iVZK7L;
	spf=pass (imf14.hostedemail.com: domain of vivek.kasireddy@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=vivek.kasireddy@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763616977; x=1795152977;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1agdrt6gyrQfMVbC9VsUzl4p/5UcxPOYPtsUDkYyORc=;
  b=Z4iVZK7LcUUJl3tkirwDk3QptjO8aSWxdzp6SSpS7Eu0PLG7g1MhKn/j
   tNFgIPh4oVQlLybIbsLVpqcqH1XVrHT2foyd48U8VxVf0twoN6HoKm8AZ
   tWDlNac4hXE5HygtAh0rJfI24t+k3tdL4y+cLWSmDnybNduL3OhlTfVuk
   MWVO4msBTx0Qj7Wk5dby38fHTUnC8hCzhIvR+r+7cl0YFfUTzduQcLBVm
   MiBUiBq/VWctLlYOrQNzSXn+nWJGc43AK7BySPKcFzzREKpxBJspHIqYM
   M57UMDDjuV8hKHkHMvkc4Ou0l78dpXCWGmm5/lxeJITXi/Mm+yJPEnwfM
   w==;
X-CSE-ConnectionGUID: JoalnO0BRKOeazebDj3qfA==
X-CSE-MsgGUID: qHbcOLC/Q3iXhb63yYrrJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="77032314"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="77032314"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 21:36:15 -0800
X-CSE-ConnectionGUID: UMKvHXeKRsOukt/8R4+kyw==
X-CSE-MsgGUID: ocuC/Vc+TuqPC9RAKEvpjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="196387444"
Received: from vkasired-desk2.fm.intel.com ([10.105.128.132])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 21:36:15 -0800
From: Vivek Kasireddy <vivek.kasireddy@intel.com>
To: linux-mm@kvack.org
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: [PATCH] mm/mremap: allow VMAs with VM_DONTEXPAND|VM_PFNMAP when creating new mapping
Date: Wed, 19 Nov 2025 21:35:46 -0800
Message-ID: <20251120053546.2885836-1-vivek.kasireddy@intel.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: C3DBE100004
X-Stat-Signature: 9az7nyqbrrbfcqcyqujtdm5doobnmqd5
X-HE-Tag: 1763616976-398618
X-HE-Meta: U2FsdGVkX19Pg/mC1+67GEtR2pbP/DYGrMDEOTB0LwGBmqJUag6mjQkVvevSrr0Hjt4AUemOY/jOVv4URqGhc8hkhmXQmfWkYZVVwMJM+wEyBDWB0mz2wALWdAfuOSgZ1YLURELr8TJO29lCO85Yr0giDn6rJZq96ZRRQG6x0uqe39GXlzIfqFrwzreQCfnmkZU8Rn8bU3rXhvv7hoJuEPv9OJZV2+2qnCTCoXJvuqFDUnmZqQVJp8SzLag+xTyTSrcNFQFodt9+CNL/klSBvqMTNsP71pi1etYT27WCLiloXv4rOPZHSH0pWVacVUtK7uAb40lt0aw5fXFQMF+cWD/imAq5M2lX2GA4KPVAadW7BH4z/jq79XBOMJ3vi05sSXcGb6IskOJJ61uaHlJA7YKj5HVbJLNBcBLIREnoJ+3XhZ5GmBMxiaj4+WQcArrnBAHnfZ5q3E28tdsy+cHYK8T5ZYR/zo29KMTfmhYOjBINcT+avnch5w56XJ5HBZGjPH2i3iHla+l1PZby1e1XtcwBM10fZc+1QKNZQ8qTA3+2s0KR/KIPTqQ/mP+t0/5bLJ5YUYSGnhA1SKf3uY3rjxh3v7DiL32ZCAU3Vly+WlzfOEmnP293mUt8waTa4xtHm0+GRxpy9+GrAB9bKx5P/G9zKwqx4ehvd07ExNtbLKbOcQwNBMukRu5+dbEOgOvqRwsvNkS59VGhyxi1DeQkjPU9NntWRyzGBqmKRIt2JXkRsb9DqQV40WjvVzOKVrQ8kg+HnPZJF0noSB/LiPFtrARYkC12aPb2DsIw+tMtL2QNvBlfLcHyKQfMiToj0ndDrSzhJUEb34Xxd9O4e4aYR7VMyz3wWkok+89V7WG+lSegNxP2SY8RHxY5U96iiBEj9FRJ30jrDEKIoZfFz1bboPTadVrHDqyWUzd5X3YVCfgCTm0onDT4A1PeSKDoKa3f2Y1wfKHlrwsyYTwZxau
 IR/IuXDc
 0mQe5qxH88D/u74m69kAxC1IV/kX83Q3uQQj0sK4p6jlY4IY3EknkBUJHe76zZvBYHGgMMmiEdUmf4sNrj2C3F6AmUosBmF4nv8mxFii3M6eZ9sfCr9uAXsttQT+T7lcSf4Pozrluj40WKornS88wInLi5L3lLbvVSHp+B5UDy6dDAY+G2Zjv+WBce9DT7kPxnVvr5NDsHMyuq6QicA3QslVnf3Qm1BRqF/tyvHL2F0CpDOEum8R5DqcDtI6G3pEhuyBkZJ/c+sidYLFXjANknpBmOP0E3AsNSVS0rZbSu4AoLfgc52qRGyb1Ghz2d0wyUjEc5dQvsY/Wjs4/KLDWeyvMB7c+6gWivV3+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When mremap is used to create a new mapping, we should not return
-EFAULT for VMAs with VM_DONTEXPAND or VM_PFNMAP flags set because
the old VMA would neither be expanded nor shrunk in this case. This
is particularly useful when trying to create a new VMA using other
existing VMAs that have these flags set, such as the ones associated
with VFIO devices.

Specifically, there are use-cases where a VMM such as Qemu would
want to map a non-contiguous buffer associated with a VFIO device
in the following way:

    void *start, *cur;
    int i;

    start = mmap(NULL, size, PROT_NONE, MAP_SHARED, -1, 0);
    if (start == MAP_FAILED) {
        return start;
    }

    cur = start;
    for (i = 0; i < iov_cnt; i++) {
         if (mremap(iov[i].iov_base, 0, iov[i].iov_len,
             MREMAP_FIXED | MREMAP_MAYMOVE, cur) == MAP_FAILED) {
             goto err;
         }
         cur += iov[i].iov_len;
    }
    return start;

The above code currently works when mapping buffers backed by
shmem (memfd) but fails with -EFAULT when mapping VFIO backed
buffers because the VMAs associated with iov[i].iov_base addresses
have VM_DONTEXPAND and VM_PFNMAP flags set. Therefore, fix this
issue by not returning -EFAULT when a new mapping is being created.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
---
 mm/mremap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index fdb0485ede74..d3868d941f72 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1736,7 +1736,8 @@ static int check_prep_vma(struct vma_remap_struct *vrm)
 	if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)
 		return -EINVAL;
 
-	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
+	if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP) &&
+	    !vrm_implies_new_addr(vrm))
 		return -EFAULT;
 
 	if (!mlock_future_ok(mm, vma->vm_flags, vrm->delta))
-- 
2.50.1


