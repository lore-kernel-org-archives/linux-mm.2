Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27007CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 06:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E4416B0088; Wed,  3 Jun 2026 02:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 594D46B008A; Wed,  3 Jun 2026 02:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 483D36B008C; Wed,  3 Jun 2026 02:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33AF76B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:47:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA9DA8CC9C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:47:36 +0000 (UTC)
X-FDA: 84837670512.06.6D30DE0
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf17.hostedemail.com (Postfix) with ESMTP id EDBD840007
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:47:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pnzyC1VC;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780469255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fG460Au1r5X+33h0udr5rOAg0hvw4xrT6AgQ0be3hrg=;
	b=T1qEHji/ZFpVpaRoUw2EVBM4HqQLzQGFltVXDkAkh3tY7toVLGwXfl6Fi8X6vjYUIQQlSI
	UA0cHiBgFgFn0AeYCR0KNr8MO10uDQSC+2MKcilRazjmy18Vf5Hev4hsqJwnxmfdF9+v4s
	RjfevITNKUvNA9YHDfqysK5bCXrIN/g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pnzyC1VC;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780469255;
	b=z0zV5sa3Qy1ULjZN6JgvR2JnN/sjOx9kE1hVGyy04lH58i07mh6eAcoNAAbG94rNGyZEDO
	/lNUXsMKtKY0gRgmMZD91P7V0wyisdHm9h4wOX6q0DR2g7SdKDeMKGKKWeYz4XuJoXywBh
	7i6M6yBYNKuM8XDFA9rwo4TRk1emN5c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780469250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fG460Au1r5X+33h0udr5rOAg0hvw4xrT6AgQ0be3hrg=;
	b=pnzyC1VCcfMNRhpk8nQ/hEtSY0th6Zxz9xNV4qeWdETXikZiiGiwjFdAoiTqCDKavz/TbI
	FlINjUfvALJuj7nED+vD2bBkIGvx2So0fPklQ0jaJolXXxZ0P+LobeDeWyW9POPAJC1Qwb
	kSJEWDkxETBCTSiFAO1TbCQK5fe3idU=
From: Lance Yang <lance.yang@linux.dev>
To: luizcap@redhat.com,
	baolin.wang@linux.alibaba.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
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
Date: Wed,  3 Jun 2026 14:47:18 +0800
Message-Id: <20260603064718.81699-1-lance.yang@linux.dev>
In-Reply-To: <8781a9a0f115705ee11884ed3184b65a1ce39923.1780066530.git.luizcap@redhat.com>
References: <8781a9a0f115705ee11884ed3184b65a1ce39923.1780066530.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EDBD840007
X-Stat-Signature: 7pnfp77riimfhfttj6yfx3xtcsn4655f
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780469252-853944
X-HE-Meta: U2FsdGVkX19SMJrpGQJg/wuSMmJhapDDaKxDxhRijVapccfDMAluzDk6yhVVUcpsrH3GQv+2avX+EzCn72JewCHzubCo8VLlFWBQ7i2QOJST8+vhf0Tqx4FwMyun6EijQ/AOAJZtTz23SRbvIMZTpFoVSQo8gVH9+/+DFOdt/4Tp/gUuWe+ITZWtlKcDbjFISpOqBzMqtCHvFMqAX08UYTcge3WotWSj0jIBJiB/WhCcz3nHb7FBFNLKy2SBlGGpDxXplfQEBRVw97/8PdE4FYtjYf6p5n1l6PgxFW81fdma8+J17wRZNDqq4pmjwTX/J5AFtlcx7bNFKPkWnsqeG6StgM9Aj1/vEijHflFk+Thd5o8cMFlXSVfXoTmk/0VjwHlmJw+dCFiViMlNLxPNIYJ1x1WC9uPdV5qkHdO/7L7Pvs0TY3fkXB3B1pyi2yAv5xLV2lLpaaeH3RI/lIaxJGXdPoPlCqovExe42WPdSE2SkRKhtNazCARCGO7d2dmaMbycBvNYoeFCG8idQx7UIbc5iumkYKrm+AQ6gIpIze9sshvVC3FWpLUQodBNyjbi4Z2Z07t4SUg/VmM+I4Zx4yTmOvtl/XCLg6yKECvx0K0lIL/aPvmyp/qyyHaAuMmiVKmQDlQ9G8lm3PElbw6IO0arsXxfZ4RXNWQEiy89o1Dd8c5E76Wm6NKWvG6Yif1JPR5mEMn4xITGZgQ8zhJmW672sFIR6vJJhXhambzSlNuV8elJW+N0IOPOeU/0cPTt60zxVwrQU6+lNYCTKvYsj5GWEn9VpfPzfE7iyK7EcNWEgWTJ6l0XGcSTFs5tp/GHRWfbdLYpdaj4FcX3XedbQzRtZokxFKAIuawcrw/VxmHbcaLPwT+nqT5owbWE2hhid3UoqJqMTcIhUAaEzzQ1RMHyaHdtvpwY/42WMQPzPR9nCfUsDprNfw7OVGFwp1cZ3hwIXQKRDehYWhK0ORX
 lQY99rEI
 Vy35ROc8NX2JAHvqeMMXjkjNLnwa7VAZw34X3v4dA5rkECoBW3tXOdnaT2JEhYDC9wtztn2UzK6Z6UnYi5wQitJAhBGvJZQmf7h+P8yw1YQcbyePwkZC+5/xTLIh0XEzzVX2X5T2Vnsg9vKqRPZrM7Hhm0ojJ5r/wHs1yvvfqCqI8Lg2/HxKnOTTCJ/xzdZ6MusO6s0xDzKR/IfKPcHpaf0mW/ewmxMY1hSMKegZFG+3Pxos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Luiz,

SHMEM_HUGE_FORCE still assumes PMD order in a few places.

Is that expected?

shmem_init() only sets the default inherit mask when PMD leaves are
available.

	if (!shmem_orders_configured && pgtable_has_pmd_leaves())
		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);

But shmem_parse_huge() rejects "force" unless the mask is exactly PMD
order.

	if (huge == SHMEM_HUGE_FORCE &&
	    huge_shmem_orders_inherit != BIT(HPAGE_PMD_ORDER))
		return -EINVAL;

Even if "force" is selected, shmem_huge_global_enabled() still return
only PMD order.

	if (shmem_huge_force || shmem_huge == SHMEM_HUGE_FORCE)
		return maybe_pmd_order;

and shmem_allowable_huge_orders() mask it out.

	if (!pgtable_has_pmd_leaves())
		disabled_orders = BIT(PMD_ORDER);

	if (!vma || !vma_is_anon_shmem(vma))
		return global_orders & ~disabled_orders;

For anon shmem, it can also return 0 for same reason.

	if (shmem_huge == SHMEM_HUGE_FORCE)
		return READ_ONCE(huge_shmem_orders_inherit) & ~disabled_orders;

Should SHMEM_HUGE_FORCE use the available mTHP orders below PMD when
pgtable_has_pmd_leaves() is false?

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

