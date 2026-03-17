Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BFD0FD8740
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 11:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E5316B0005; Tue, 17 Mar 2026 07:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BCA56B0089; Tue, 17 Mar 2026 07:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2DA6B008A; Tue, 17 Mar 2026 07:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4E86B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:36:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2FCA136099
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:36:27 +0000 (UTC)
X-FDA: 84555352014.30.C824C54
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf30.hostedemail.com (Postfix) with ESMTP id BF5058000F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:36:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dwppiON6;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773747386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VT+l0NoxtCN2POSc30sRXgy/SfJJNPBcPtl6tSMxKRI=;
	b=tXnoIi1venMv47iEM+tkGr85+p3bFPRsYKHVO96WaazjncfvOgHL0p/QCLzhoKi4AH3I/+
	f/TwRaIIxIwSzF6TTBgJ5e4fdqpVMpisKX0AOBsjUxtMBLIVx9F1ErZOPNqGq51DdH2rFZ
	VnFckOSXMj8+8zPANTiGqDi0/pZ78bk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dwppiON6;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773747386; a=rsa-sha256;
	cv=none;
	b=6+VEvDawNi5P27W6MuahNpmi9Y5j4GNkAlRPH1tp/3eI4QNWzIr8r4g8IALMNU1JmBO8o4
	xahs8KqLc0JLbJxXpHeuxSJeBx3jOEsgsF/XRcmzVidvRp/nK2ex7jZW7ipaskzs6xKamr
	ncOEb0RMZ6eLdrAtsl8k2riftesXIAk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773747382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VT+l0NoxtCN2POSc30sRXgy/SfJJNPBcPtl6tSMxKRI=;
	b=dwppiON6++TNajZIhgZNiFzR8/cX90H08HvMApiMyr1F4NW6yiLXBbD+CFIXFPOcDaI5JW
	GKh1yHSxEQUglU/Uao3Gw2tg9/XukokBGXTUVK/YBYZRniXj7kkWL0YKeU5E4OhvSCj0ow
	E84M77Y/Tvyx7cQYrH7ZQTaDJ8iQl3M=
From: Lance Yang <lance.yang@linux.dev>
To: baolin.wang@linux.alibaba.com,
	npache@redhat.com
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com
Subject: Re: [PATCH mm-unstable v15 12/13] mm/khugepaged: run khugepaged for all orders
Date: Tue, 17 Mar 2026 19:36:11 +0800
Message-Id: <20260317113611.94006-1-lance.yang@linux.dev>
In-Reply-To: <20260226032650.234386-1-npache@redhat.com>
References: <20260226032650.234386-1-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: BF5058000F
X-Rspamd-Server: rspam08
X-Stat-Signature: 5p856tgx59kwps5w45gaw8m57rcemwq5
X-HE-Tag: 1773747385-112275
X-HE-Meta: U2FsdGVkX19I93omWnGYF8vx9Dz2PMJVTUJrecUv1If3KzUb+JDNCBMnlhDCXNCIMM1Ieqv6mGv6H5hoNf/92dF8iUPPiQWBPldqUX6SFjANagyTF/7raFu92rJZ61reoi6aAO/Cg7yIz5ch6sbsoJZk/4/fJfLnTXJ9BVjfdZdqW72Hm6ODcud6btxZT0DEGBnHVTkPrc6VmQe4YRJHZpOFAFZPsw2egxzNFz3XCyk26Tb0BPzk12/DYR2fKvVPYcLkYe2HX3TaEIyE7cnKHpF9WQb8AecH9fOwcE7EPQ6GJ8kh5gDgR5z/3S0UPD4EJ406LJk6+YkXJAFqsBqc6IrrnYNKsXahf7BtglTeONCiFjcY16jGcNKpm2XsDbkidZdzaILHM8VsBjVc3e4Sj/s7yrpeQQVDOkp1BItIFt01XuCD5cP8PJ3cWEOz3xea0sNsZwQxLDa/QU0G/XE7dzX51yUp1puhaq3mYMt5EXo3OIIVbPx1tgA3iXDviwhncmimcWi0c6W39LzAOoRiKqRhbTNwECxg9WswqOzHuNgAEby9rpjGE3RPOkEV9e79MAhQd/kp/GRDxKWYxHIXWr9ezeTpR+8VucBldKzCJnp1wgRTOMxULSUqnUTJ1JCsi/Em0+mGezrqUSfzp6BDvHN2V3UeU7+uDaT4XKBKIwjD4tgKrHAU89kt7V6RVVMz5x21xtDR62tx3cVgwVG8Mo1/00iR9E9VK/ehDZvPinK750WKnUPTLiDBrxvEycCbJhuIxY9FsGBDxrYLwvlG9LeOt3VsPzTjai+keI/81cWDRtV+b054Y1OcxDaxngZZ2aFC/Dko8ekGbsxDrL9sDLQs4iqY0yGJDMVFXhk9p1u7nGDAd+ib35N4+2EWoENT7P1DZUwTQvRRXVS20s5S7fUv2NSNriPIIC3NOXk8uDogASM5TERCFHn0Hc3eRaR34gtviGcs9CPW1AtVBwO
 939oDcFy
 pHLlmpwueOiVlFbCovEJhwqCBsnVzmIi28BFF0lGh0tECv4NJIKOi9mUaN9PS3sB5t95fvfA7ToMl1CVPi6mWTVBGNuKwULNe6tVsK0DjU/5JWy5uItFHA51xCWEMbGJyXimNQcm/BgZ9+QroNU0465x9XM+knpymj67HHtc2oSYGRdq29tmG+m7Dh7qa9tZ1g7XCmLxmxzKPFanHApvcBJNtToY8U+sqUb6nM864a2JLynOrxUlwxKulZhHH84wUCNVU4MakRAkIAf3TevU0HKuABrdVg+2yzdKE90A1rWou9PKGjKbmsnB9q2ZHx2SN1E7s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Feb 25, 2026 at 08:26:50PM -0700, Nico Pache wrote:
>From: Baolin Wang <baolin.wang@linux.alibaba.com>
>
>If any order (m)THP is enabled we should allow running khugepaged to
>attempt scanning and collapsing mTHPs. In order for khugepaged to operate
>when only mTHP sizes are specified in sysfs, we must modify the predicate
>function that determines whether it ought to run to do so.
>
>This function is currently called hugepage_pmd_enabled(), this patch
>renames it to hugepage_enabled() and updates the logic to check to
>determine whether any valid orders may exist which would justify
>khugepaged running.
>
>We must also update collapse_allowable_orders() to check all orders if
>the vma is anonymous and the collapse is khugepaged.
>
>After this patch khugepaged mTHP collapse is fully enabled.
>
>Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Signed-off-by: Nico Pache <npache@redhat.com>
>---
> mm/khugepaged.c | 30 ++++++++++++++++++------------
> 1 file changed, 18 insertions(+), 12 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 388d3f2537e2..e8bfcc1d0c9a 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -434,23 +434,23 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
> 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
> }
> 
>-static bool hugepage_pmd_enabled(void)
>+static bool hugepage_enabled(void)
> {
> 	/*
> 	 * We cover the anon, shmem and the file-backed case here; file-backed
> 	 * hugepages, when configured in, are determined by the global control.
>-	 * Anon pmd-sized hugepages are determined by the pmd-size control.
>+	 * Anon hugepages are determined by its per-size mTHP control.
> 	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
> 	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
> 	 */
> 	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> 	    hugepage_global_enabled())
> 		return true;
>-	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
>+	if (READ_ONCE(huge_anon_orders_always))
> 		return true;
>-	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
>+	if (READ_ONCE(huge_anon_orders_madvise))
> 		return true;
>-	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
>+	if (READ_ONCE(huge_anon_orders_inherit) &&
> 	    hugepage_global_enabled())
> 		return true;
> 	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
>@@ -521,8 +521,14 @@ static unsigned int collapse_max_ptes_none(unsigned int order)
> static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
> 			vm_flags_t vm_flags, bool is_khugepaged)
> {
>+	unsigned long orders;
> 	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
>-	unsigned long orders = BIT(HPAGE_PMD_ORDER);
>+
>+	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
>+	if (is_khugepaged && vma_is_anonymous(vma))
>+		orders = THP_ORDERS_ALL_ANON;
>+	else
>+		orders = BIT(HPAGE_PMD_ORDER);
> 
> 	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
> }

IIUC, an anonymous VMA can pass collapse_allowable_orders() even if it
is smaller than 2MB ...

But collapse_scan_mm_slot() still scans only full PMD-sized windows:

		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
		if (khugepaged_scan.address > hend) {
			cc->progress++;
			continue;
		}

and hugepage_vma_revalidate() still requires PMD suitability:

	/* Always check the PMD order to ensure its not shared by another VMA */
	if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
		return SCAN_ADDRESS_RANGE;


>@@ -531,7 +537,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
> 			  vm_flags_t vm_flags)
> {
> 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
>-	    hugepage_pmd_enabled()) {
>+	    hugepage_enabled()) {
> 		if (collapse_allowable_orders(vma, vm_flags, /*is_khugepaged=*/true))
> 			__khugepaged_enter(vma->vm_mm);

I wonder if we should also require at least one PMD-sized scan window
here? Not a big deal, just might be good to tighten the gate a bit :)

Apart from that, LGTM!
Reviewed-by: Lance Yang <lance.yang@linux.dev>

