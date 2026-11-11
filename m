Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2B82606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K9WyqVln
Received: by kanga.kvack.org (Postfix)
	id C9A656B05BD; Wed, 11 Nov 2026 17:02:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C713D6B05BE; Wed, 11 Nov 2026 17:02:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAE7F6B05BF; Wed, 11 Nov 2026 17:02:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5856B05BD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:02:15 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07B6E140411
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:02:15 +0000 (UTC)
X-FDA: 85424212230.05.07ED81D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 53013180009
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:02:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K9WyqVln;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794434533;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cPEjGTG+rpPMqKfliMJkk2awZP8RH5eRyXaCncrkX38=;
	b=NNox8zDjY9m/v5g6pF3Ty2v9H6gxSWPEVR6cnrE1kG9BeNKm6KCJSRhMl+uuAYNtLWk/41
	RW80xjlq+0RFungjlay/R2fDPGiZ47liCPahCYwUzfw+CbYnbODMfnj1AYH+T9lRN5D1R5
	Gn5HiTiIyh84VkNw5e8MAQrgAB0KrGw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794434533;
	b=GRZBNVEyWtMboWaXY5YkhxKXxkAsMtG3jYxXUEKQncYae/szGlyzIuVBayesvgsUT0Tirp
	RpJEPxgp6CoDqNZsY+FlZ+g/S02djd3Z8o4+lQnxVeX1hCAZvZrtx0Dv3dm1+mrY5bj2z9
	cFFIY6DL1QT/pelLRdLZnnwHL/wwjUo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K9WyqVln;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9426B40309;
	Wed, 11 Nov 2026 22:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3371F00A05;
	Wed, 11 Nov 2026 22:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794434532;
	bh=cPEjGTG+rpPMqKfliMJkk2awZP8RH5eRyXaCncrkX38=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K9WyqVlnOVHPVAG9vaTjtNLEqbDr2ly13P+bLZPyab/iKV3I1OhrbeQC8Pe3UegYL
	 yDc4RSMt3yP2QfnNFrXgBlAA8dsB1X8o2adb/HeUuLdr3wmf3IoujRWCUQGpQLxiKs
	 IjrZtY8KtUjyp8ztR25bcjBUQH6iuCcGRSJ7FHIqQUxlUsWW/XcWk02HZuTGF9gmEy
	 3ZGflj1px1ORY1TyVrGktGjIWdiQ8XjTVngHzLg/IFhuem1tBzemwYVLCOhPQglEw0
	 pMlBiLb18cli9TRikwgUi0lN8d6PYnZV9MCniaqib05LHFI6JSBMEZg8x/rz5sxvnB
	 ZnYA5j3e73vbw==
Message-ID: <sashiko-outbox-209732@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 6.12 1/2] mm: replace free hugepage folios after
 migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Bundschuh" <mkbund@amazon.com>
Cc: sashal@kernel.org, linux-mm@kvack.org, david@kernel.org, yangge <yangge1116@126.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Barry Song" <21cnbao@gmail.com>, "David
 Hildenbrand" <david@redhat.com>, "SeongJae Park" <sj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
In-Reply-To: <20261110220006.3259056-2-mkbund@amazon.com>
References: <2026-11-08-1-daily-reply-0005-hugetlb-6-12-v3@kernel.org>
 <20261110220006.3259056-1-mkbund@amazon.com>
 <20261110220006.3259056-2-mkbund@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 22:02:11 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: ke87u17rji5z7quw4qq178z9oumf8knr
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 53013180009
X-Rspam-User: 
X-HE-Tag: 1794434533-900723
X-HE-Meta: U2FsdGVkX1/3vY4WbWET3El7Cgy2AMhUVU4O9mCyj17VokxeX1JAyh80S/q1PMgT9gbafgoAR7C+8ii42W8hpJixuedy5S8PrdxR2FoykVXwYbGr7b6F0Yq5VsWHQNMlw3VQ9Cd/X/+F1JgYdhJu6Qohtuxz99u2NcMp4gwJKHzYAfRPcF9+ds2ELh8Q7FlHh0PJltuPPB0xAcYJ6tKDMF9mp7Ls+aR9Nvh98xRdKiybvPKzGuveJ6UXTCbALwcqLE43prQx4XpVGfUbUXXsYwBvcDs6s7yHcEwqlAF5kTMy+2+nJ1zO2L/hCshmBcNU7tb+e+WuOpjeauU8LduIQSQG+HCYkpE5/hGg8vB5MLCuODX0OFx2tUfdwzhBOKsTxDMVWADBILgSiiXrudCqQ38q6vgJRpPiHPdryET9E4xqX+Iz8TzgsXth/C4fuKLVeesleFIMpO412MhSZ4ONVgjkarjuFB2/zFZAYxaj8HyKQVWi3PXutvj6LzmoJu9mQG9MteUqsd82ZZ4WGu4TkLtao5eHCljBE3Ml+2MvKkCgYdyssh7pIY9MQeLXhiTJTTzLSJVEW9j93JFj/jPvox2JqThbBWcFaTQi6FiGckI3zFKrAgtm3RzJ3CVc3eBWWt46t3Mq1hX4H339x3Q0WH2MCX/OVCo+lvnhbcaO5U0uuU2I7OlEClXMmlewN35sBjDRdZ/bXYWJlP2au0psGUE2Sp1QlLbpAFaid7jRtHo/gd+gScBhO4CQvxiKqPjMzOMGl07a2Vsr2+wQ9vxNgHjZpiupG3M0MJn5kqsiAjQts2bFsPHI0AOZbi4cJhbxr6AYqN4xQQXWt+wSPF0zKVqB+TEPO1YOyZ9yTums+k6IQ+y5/Kam9PUwsHGjTAKeEryVO8V/gCQ1xWnvf5mtAUXlnyNztgUIq+SWbW/S7Crz5MbopOtTSCZiQb2P5OWFYYDYweXZkpmLQs3I2Pm
 kRsKasgz
 nQVJNLzkvQAYhQDcT+/UCMGO1JKBGpu6BkRu46yNKspOCx5NgGIZAhh3bquViQjM8jMvluMpTnlG0l34jWu2SRZxQijBRsSlQnPf4mdb4E/TUJ7neKpEtFEdWjk7MaLoCjEtmi1ysZdivhSfzurcIAztydk2i2u5yLXeB2jlk18uXnbzbF0rNScFcpfkb7t5vlVha52hT9zdvu+rvPQ5Xr9r7glkawhqk87RO1MoUTxe2hqtROe1r4FMbojIwraNBt24sw+oZw5qxAq8GZFdS2zjMsNlEThSej2xtScc3NhCqaySY8fTCaK2s5TrLu2Zq/q4SEdkRGQ5+wHp/xgfLObDHvyzHNQpYOqpcc3JE7o+y7bgCNKAiX1wPBwFJtkUvsWVUWZzH/m6LSvzL7yWqyIcIYfgJqI9Pd5LiP4FlscV6K6gQvZNP36jj6JrezCTdZR8KpBTWqQgrvgeyXCd69IpMDZvMiIk94hDBJ8RXRv9ej5Z6sfIE/R3H9TasGr+D1iczz4mN6PCwNHzWi1+xK2M7R3QNh79fag15amEBBsMdmVZ1WiG+MOZjfthGt0Mae5y8qgJrzYM5bo8mroh1IHOeVfKLPEcS0Ut2aoSzrph+seHATAjtPMRSdyxrRSL+PzM6Hxbby+ukkaGJLVjxoSaKyHiLteABRfBUB9W3+P7scs4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] mm/hugetlb: dequeue_hugetlb_folio_node_exact() skips isolated
  folios
- [Medium] mm/hugetlb: repeated dissolution of undissolved folio in
  replace_free_hugepage_folios()
- [Medium] mm: soft lockup in replace_free_hugepage_folios() on deferred
  HVO folios
--

commit 5faa426035efacd066fe63acf72c80b50a32aaee
Author: yangge <yangge1116@126.com>

mm: replace free hugepage folios after migration

This commit adds replace_free_hugepage_folios() after migration in
alloc_contig_range_noprof() to replace free hugetlb folios in the isolated
range with newly allocated folios, and skips MIGRATE_ISOLATE folios in
dequeue_hugetlb_folio_node_exact().

Link: https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yangge111=
6@126.com
Link: https://lkml.kernel.org/r/1736582300-11364-1-git-send-email-yangge111=
6@126.com

[Severity: High]
In mm/hugetlb.c at line 1354, does skipping is_migrate_isolate_page() in
dequeue_hugetlb_folio_node_exact() break hugetlb reservation accounting whi=
le
isolated free folios remain counted in h->free_huge_pages?

available_huge_pages(h) computes h->free_huge_pages - h->resv_huge_pages and
still counts free folios in MIGRATE_ISOLATE pageblocks as available.  When
offline_pages() or alloc_contig_range_noprof() migrates an in-use hugetlb
folio while unreserved free folios exist in the isolated range and reserved
free folios exist outside it, alloc_hugetlb_folio_nodemask() sees
available_huge_pages(h) > 0, skips the isolated free folios in
dequeue_hugetlb_folio_node_exact(), and consumes a non-isolated free folio
that was backing h->resv_huge_pages, leaving the newly freed source folio on
the freelist inside the isolated range.

In offline_pages(), dissolve_free_hugetlb_folios() then dissolves the earli=
er
isolated folios until h->free_huge_pages drops to h->resv_huge_pages, and
dissolve_free_hugetlb_folio() fails with -EBUSY on the remaining isolated
folio after persistent hugepages have already been dissolved.  Likewise, wh=
en
free folios backing h->resv_huge_pages sit in a MIGRATE_ISOLATE range,
dequeue_hugetlb_folio_vma() in alloc_hugetlb_folio() and
alloc_hugetlb_folio_reserve() skip them; when nr_overcommit_huge_pages is 0
or the hstate is gigantic, alloc_hugetlb_folio() fails with -ENOSPC and
delivers SIGBUS to a process faulting on a reserved mapping.

[Severity: Medium]
In mm/hugetlb.c at lines 3022-3030, can advancing start_pfn by 1 in
replace_free_hugepage_folios() repeatedly call
alloc_and_dissolve_hugetlb_folio() on every tail PFN of an undissolved
compound hugetlb folio?

When old_folio is vmemmap-optimized, remove_hugetlb_folio() leaves PG_huget=
lb
set until __update_and_free_hugetlb_folio() restores its vmemmap.  If
hugetlb_vmemmap_restore_folio() fails under memory pressure,
__update_and_free_hugetlb_folio() puts old_folio back onto the hugetlb
freelist via add_hugetlb_folio(h, folio, true) as a surplus hugepage while
alloc_and_dissolve_hugetlb_folio() still returns 0.  Because start_pfn only
advances by 1, the remaining (1 << huge_page_order(h)) - 1 tail PFNs resolve
to the same old_folio via pfn_folio(start_pfn) and invoke
alloc_and_dissolve_hugetlb_folio() again, allocating extra replacement
hugepages and permanently inflating h->nr_huge_pages and
h->surplus_huge_pages.

If a vmemmap-optimized folio instead has HPG_raw_hwp_unreliable set,
__update_and_free_hugetlb_folio() returns early with PG_hugetlb still set a=
nd
HPG_freed cleared, so the next PFN iteration spins forever on
!folio_test_hugetlb_freed(old_folio) in alloc_and_dissolve_hugetlb_folio().
In addition, if old_folio gains a reference before hugetlb_lock is taken in
alloc_and_dissolve_hugetlb_folio(), isolate_hugetlb() isolates it onto
isolate_list and putback_movable_pages(&isolate_list) immediately puts it
back onto hugepage_activelist without migrating it.

[Severity: Medium]
In mm/page_alloc.c at line 6751, can calling replace_free_hugepage_folios()
before wait_for_freed_hugetlb_folios() in alloc_contig_range_noprof() spin =
on
hugetlb_lock or trigger a soft lockup when HVO is enabled?

When __alloc_contig_migrate_range() migrates an in-use HVO hugetlb folio th=
at
is freed to the buddy system (for example when migrated to a temporary folio
or when surplus hugepages exist on the node), free_huge_folio() leaves
PG_hugetlb set with refcount 0 and HPG_freed cleared, queues the folio on
hpage_freelist, and schedules free_hpage_work.  Because
replace_free_hugepage_folios() runs before test_pages_isolated() calls
wait_for_freed_hugetlb_folios() (even with the later fix in commit
"mm/hugetlb: fix kernel NULL pointer dereference when replacing free hugetlb
folios"), replace_free_hugepage_folios() sees folio_test_hugetlb(folio) and
!folio_ref_count(folio) and calls alloc_and_dissolve_hugetlb_folio().

In alloc_and_dissolve_hugetlb_folio() at line 2901, !folio_test_hugetlb_fre=
ed()
is true, so it loops acquiring and releasing hugetlb_lock with cond_resched=
()
while free_hpage_workfn() sleeps in synchronize_rcu() during vmemmap
restoration.  If the caller is a SCHED_FIFO or SCHED_RR task on the same CPU
where schedule_work(&free_hpage_work) queued the work item, cond_resched()
never yields to the SCHED_NORMAL kworker thread and locks up the CPU.
Calling wait_for_freed_hugetlb_folios() before replace_free_hugepage_folios=
()
would drain hpage_freelist first.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110220006.3259=
056-1-mkbund@amazon.com?part=3D1

