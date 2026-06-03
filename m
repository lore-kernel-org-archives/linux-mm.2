Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0AD8CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B556B008A; Wed,  3 Jun 2026 04:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3316B008C; Wed,  3 Jun 2026 04:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308456B0092; Wed,  3 Jun 2026 04:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5B56B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:12:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C1A2A1C1265
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:12:23 +0000 (UTC)
X-FDA: 84837884166.10.FE0B3CB
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id F1EBE4000C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:12:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tYbI7Zs5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780474342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MecJ0uVzzRXlbTL4KZH5TVwx/la2hj8pFOkf+4VUKV4=;
	b=BlVgWun9SrbylyUU8qG8bTz3qv9AkvGK+HP+ODj/8sWnoIMv+rAPFAmCLnoQhfO9b6snD8
	9fpdS8br/HWZswe4OwOFi4hiz1Dvgt2ulFnIwI752Cuq13D2bYTiMhWPzUfTgtjj99cHgF
	WrWXSrj/1vnuhrpcfIJyLp1mk/bWWt8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tYbI7Zs5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780474342;
	b=4iH4/ACdgbaMtPFlKd5g3LEVcOmHVDXd6oOkYsqK2KLHzFoA5oW3/K5onwOJ/iijxPrdxi
	ji7ZUJUxhL9tWOoW+Sm2UAzOGELnNziXKDIlSWUkgm1OOFbj6uJlqfuHsydUZM39xOTLCu
	6uaokgxZQJZgLkO2opU3t9ywhO77nwU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780474339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MecJ0uVzzRXlbTL4KZH5TVwx/la2hj8pFOkf+4VUKV4=;
	b=tYbI7Zs5vfCf4HFLXgDfvqyYtPCniqqLk5Dx8bPee9eBnYw/XRetw6V8GRMn73H8JCBrYL
	04FX96nu5rYOM5QwxcmuuX+ckxPwCU+tv5nmi5P5O2YqQi7A2cRa9M0U7hxTZT96P/UaH4
	V/vdK0+9dfr3QSaXj9rBOiYH0ARkpxA=
From: Lance Yang <lance.yang@linux.dev>
To: luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	ira.weiny@intel.com,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	ljs@kernel.org
Subject: Re: [PATCH v5 14/14] mm: thp: always enable mTHP support
Date: Wed,  3 Jun 2026 16:12:07 +0800
Message-Id: <20260603081207.1375-1-lance.yang@linux.dev>
In-Reply-To: <8781a9a0f115705ee11884ed3184b65a1ce39923.1780066530.git.luizcap@redhat.com>
References: <8781a9a0f115705ee11884ed3184b65a1ce39923.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F1EBE4000C
X-Stat-Signature: 4q4nqni4pua3jac1h977p1peqs3tc7su
X-HE-Tag: 1780474341-944965
X-HE-Meta: U2FsdGVkX18ig4vLJmN9n9sIvYw8BfkeRbY53JxUqtBj2/PUROjVcPNzpDDvwBOVuYTFEnmUl41DTS+yrTAGi3txhWC+UiPtDsZYcILB4CHTZKZ4j9gAk2GiSzft8Z6MduPMD1FfPbous9Jef33EOogHx6garsVZUIi0Q1BfFrVylPrXyBW5MMlKzoF5m0HpB7+x7x1fKKuzLvLE4rqWjnQND8IpanRGPkShpmBmvovaGhNruqnEJ1zao5uzn1BZSfUzH1jv9DeSb7A8yeWVVGQIAkm4SINq7/bNoBqq6cC0t/bw2B1PcuLFQ/iHBhivq83T3yBDwS/BtogKnUw93MmjOjF23mmPzvg4Ok4pRI42bW9XC2KAF7vXb0ax2/12jEbBvoC1fk/2BIl9abfyazLlyxwEKd+C7it3kinb34tUywzPuifo2hmUfDVKzxqMTPKBp5cojDGtVk/Nf23GWKm6gPCNDL+uG1c8strru6H4e5kPw1+Am/6Lc1l9HLrvl0BM5DaRLXKyA6kJqvPpbQbCDEfpQyGyeAns+N0tXBXrRRzX40LIGwdXv/kyZKW6O5ykI1O2krVEaNM7CigO7b16gBk8bxoQ1H2c/9XRXpIjd6Q5WWemJw66SamzpH9Kq1gnVehsYrG/r/4UKrKGx+NzAC18wJc0X9FDE+LooFfHY9hncswi/TM+qtLT93ULUVgqQ46SzkOGP7wzn/JqA6mwf/SkNGk7809OHirftWgrw9+DulWlNJy9tDMrH7HdcdUnJEckD/GmTMWVK6EbqA3e0wlhNDBSrAlsGHzPhiAHZE4mkuA4AMpcep7WS86UBnIKQD0z+3Hp2dIBhTT5QcYEpCng+JS8+5En+wwena8OHsRV3YzExgVXXgjek+lgBNZd0LjSY7fv5bl6tai4es2X8oedHrniguwoz1ZJ1Hhi+X4f5MNChWcCN7V/TFWP+Uv3y0zbKKoIyM9ZjwV
 BZsoHXvd
 DRto5v7yiBRlb/jxMQ3iXLPWBG4Gcs686u7yFhX7WHJuClxod2LMouLt3lrE1wlk8PiGA6V1s9IOy25mDMY2l6mqe1nNkUg2L2mK8VzraZHkieWfDyo/cEIWvs3AE6yXeKrauVH703e4WEk38upgSoWyihP0z2xoq/LX9+kFo0RaccH/SU9/GNtnNl2nfpaztLz6l4YDwbMWF9isEkeb57pOUb+pEOWnACKf7TRArQMtkECU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Would it makes sense to call khugepaged_enter_vma() for anon mTHP faults
as well?

vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
{
[...]
	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
		return VM_FAULT_FALLBACK;
[...]
	khugepaged_enter_vma(vma, vma->vm_flags);
[...]
}

Without PMD leaves, do_huge_pmd_anonymous_page() is not reached. Apart
from MADV_HUGEPAGE, AFAIK, the mm has no chance to enter khugepaged
from the fault side :)

Cheers, Lance

On Fri, May 29, 2026 at 10:55:32AM -0400, Luiz Capitulino wrote:
>If PMD-sized pages are not supported on an architecture (ie. the
>arch implements arch_has_pmd_leaves() and it returns false) then the
>current code disables all THP, including mTHP.
>
>This commit fixes this by allowing mTHP to be always enabled for all
>archs. When PMD-sized pages are not supported, its sysfs entry won't be
>created and their mapping will be disallowed at page-fault time.
>
>Similarly, this commit implements the following changes for shmem in
>shmem_allowable_huge_orders():
>
> - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
>   considered
> - Filter out PMD and PUD orders from allowable orders when
>   PMD-sized pages are not supported by the CPU
>
>Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>---
> mm/huge_memory.c | 25 ++++++++++++++++++++-----
> mm/shmem.c       | 14 +++++++++-----
> 2 files changed, 29 insertions(+), 10 deletions(-)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 32254febe097..059901a8c6cb 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -126,6 +126,15 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> 	else
> 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
> 
>+	if (!pgtable_has_pmd_leaves()) {
>+		/*
>+		 * If the CPU does not support PMD leaves, assume for
>+		 * now that it does not support PUD leaves and disable
>+		 * both folio orders.
>+		 */
>+		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>+	}
>+
> 	orders &= supported_orders;
> 	if (!orders)
> 		return 0;
>@@ -133,7 +142,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
> 	if (!vma->vm_mm)		/* vdso */
> 		return 0;
> 
>-	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
>+	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
> 		return 0;
> 
> 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
>@@ -848,7 +857,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
> 	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
> 	 * constant so we have to do this here.
> 	 */
>-	if (!anon_orders_configured)
>+	if (!anon_orders_configured && pgtable_has_pmd_leaves())
> 		huge_anon_orders_inherit = BIT(PMD_ORDER);
> 
> 	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
>@@ -870,6 +879,15 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
> 	}
> 
> 	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
>+	if (!pgtable_has_pmd_leaves()) {
>+		/*
>+		 * If the CPU does not support PMD leaves, assume for
>+		 * now that it does not support PUD leaves and disable
>+		 * both folio orders.
>+		 */
>+		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
>+	}
>+
> 	order = highest_order(orders);
> 	while (orders) {
> 		thpsize = thpsize_create(order, *hugepage_kobj);
>@@ -969,9 +987,6 @@ static int __init hugepage_init(void)
> 	int err;
> 	struct kobject *hugepage_kobj;
> 
>-	if (!pgtable_has_pmd_leaves())
>-		return -EINVAL;
>-
> 	/*
> 	 * hugepages can't be allocated by the buddy allocator
> 	 */
>diff --git a/mm/shmem.c b/mm/shmem.c
>index 079e299ea789..c15dffd0eb41 100644
>--- a/mm/shmem.c
>+++ b/mm/shmem.c
>@@ -1844,16 +1844,19 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
> 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
> 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
> 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
>-	unsigned int global_orders;
>+	unsigned int global_orders, disabled_orders = 0;
> 
>-	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
>+	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
> 		return 0;
> 
>+	if (!pgtable_has_pmd_leaves())
>+		disabled_orders = BIT(PMD_ORDER);
>+
> 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
> 						  shmem_huge_force, vma, vm_flags);
> 	/* Tmpfs huge pages allocation */
> 	if (!vma || !vma_is_anon_shmem(vma))
>-		return global_orders;
>+		return global_orders & ~disabled_orders;
> 
> 	/*
> 	 * Following the 'deny' semantics of the top level, force the huge
>@@ -1867,7 +1870,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
> 	 * means non-PMD sized THP can not override 'huge' mount option now.
> 	 */
> 	if (shmem_huge == SHMEM_HUGE_FORCE)
>-		return READ_ONCE(huge_shmem_orders_inherit);
>+		return READ_ONCE(huge_shmem_orders_inherit) & ~disabled_orders;
> 
> 	/* Allow mTHP that will be fully within i_size. */
> 	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
>@@ -1878,6 +1881,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
> 	if (global_orders > 0)
> 		mask |= READ_ONCE(huge_shmem_orders_inherit);
> 
>+	mask &= ~disabled_orders;
> 	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
> }
> 
>@@ -5461,7 +5465,7 @@ void __init shmem_init(void)
> 	 * Default to setting PMD-sized THP to inherit the global setting and
> 	 * disable all other multi-size THPs.
> 	 */
>-	if (!shmem_orders_configured)
>+	if (!shmem_orders_configured && pgtable_has_pmd_leaves())
> 		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
> #endif
> 	return;
>-- 
>2.54.0
>
>

