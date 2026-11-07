Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E669C606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EqOXJGGk
Received: by kanga.kvack.org (Postfix)
	id 0B7916B05B0; Sat,  7 Nov 2026 17:11:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08DDA6B05B2; Sat,  7 Nov 2026 17:11:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE56F6B05B7; Sat,  7 Nov 2026 17:11:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB0C56B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:11:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3405B403F3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:11:25 +0000 (UTC)
X-FDA: 85409720130.15.FFE4A1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 77B1214000B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:11:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EqOXJGGk;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794089483;
	b=uWwITY6jnApykTliotyQsnWQPj4SVaNYKIVNgsrUUF1Q+r7Pvn+Vo7eA/abMkXnslNRz+d
	v8yhEhawIdELZFDJCoUy5h2p6JZAQ2l7WBLg6GAR+0Gk9dNjG4od6cESpHbdu/2VSA4JNE
	ophzD2VEPs2vVAKuNFJuilbA69DMGtw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EqOXJGGk;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794089483;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+FBVYuF8b/t+qP74WSzlKO7BGhetklLph3sZx1KGrA=;
	b=OVbAsI5iLHJj9vqaRsJ+QUF1coJPCSfdU11y4l3JYVTNCC7AX+NsvBSIZ00C6PnHC8Irmc
	wh1/MKc0dkWFySIAuJzP1CM0cMJcvwBY7m9Fs0YxFzNH9WpU6B5S6yuL+Bdb+QS0bqQsPg
	YFSfEu1CIMH4vUc70Q/RBtvqpIKNFSE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 973D540464;
	Sat,  7 Nov 2026 22:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE151F0089F;
	Sat,  7 Nov 2026 22:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794089482;
	bh=A+FBVYuF8b/t+qP74WSzlKO7BGhetklLph3sZx1KGrA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EqOXJGGklrnwQ6j/mWj8FH6s+9bga5msDHBMqzGwY10bnakIBEVPc71jPrxGkbzd7
	 2+NGVBsNykYansOk+U7f/b9gGgTzKoD+zWr+0gf6hr4jLOW0LNk/Rj3x/TmY1YCIM8
	 xG25qkY/aretbUGG9cvWsNpcZCo9hPOfu3aT5UMT45f1oFGJPgCVeLB0EuV9ZgzT4l
	 PXyhmheoxad+psATiJWgJtCSZhFDwWuAYXn7YcoFed3/XiBsmke0LpmHhiSnHkwQ69
	 9YjPqjKvTaEZwkKR78ghRC82FUsm+3Xgyz1lL6VlpCur7G5Q0DfvgvSOsnXK2oX6Fo
	 MWwkcS8cG5fnA==
Message-ID: <sashiko-outbox-203358@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 6.12 1/2] mm: replace free hugepage folios after
 migration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mark Bundschuh" <mkbund@amazon.com>
Cc: sashal@kernel.org, linux-mm@kvack.org, david@kernel.org, yangge <yangge1116@126.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Barry Song" <21cnbao@gmail.com>, "David
 Hildenbrand" <david@redhat.com>, "SeongJae Park" <sj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
In-Reply-To: <20261106220835.2878368-2-mkbund@amazon.com>
References: <20261105070442.3101877-1-mkbund@amazon.com>
 <20261106220835.2878368-1-mkbund@amazon.com>
 <20261106220835.2878368-2-mkbund@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 22:11:21 +0000
X-Stat-Signature: tj6dutxa65bg6fjiyypqz7bfobwax57k
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 77B1214000B
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794089483-837098
X-HE-Meta: U2FsdGVkX1+wLNspgALAJ6ThXzWRDKKkboHK/YxotYXoMz3il3xi0u67JGjFzobmsqIqTJSbgzwaVenOcjmQjkm3x6cepEnW0M3dHmdTs4FSiMx6QvpGazVX/KLcQVr6CL3lGYjHBYdA78WhUV8bJcmrSxcL4dFd+UkZDBBSV/NoXfaegOZf89oUiYHLZRUQuDBr/CWrxlNYmQ7Ma0B4uDD2GkEwzDCT+sPwjX7fpm+1+6KvVdQcRDzuQM4ef+RbdeSB2ii1ZwL1C2bv6MeBESBmy5f+abSjaExWAMkIDoDpxvDGQrbiPtfeBLnCMKqZCGqQECxdyTuLOPhFx57u8MP6EB9kGJq9AMf9p4wD3v9pXNgBE+Mu2eKXdzy9VSALYo8enxdhJKjyYeiKBxHYEP9/gbJ+HpNfICzdMA6ykPFl//6zp0zmZYTyOuPBxhZwqtuBMA7nSOMtVG+eBRdwBdLppS/cVM8+NdAbYRR9esZRMDi4CYjVr/Uxg2MBo9ZiYtISpojJX0v/fs3oVzkc3UEOZKYqMkkt1wC2Jl+MNZYbwzxORio63kc/Hpaznzhv1gtjf4dj5HDWceOmskp5y+Zrx+K6oZI1znZvhlGnz6dkJLXMDywU1fEFUhYWHHbKWSPLff83i0mziPnCMaHrOMgmi1/04oTerVAvH9BV8uCY++nHD4eW8S7xryrM7oikHkTGyQkpz49oBtZXDQiDKdZ35eZ7NmvXY7bJ3DgZGVmlw6UW1OVo0u6nLk4hJeSjU0KWmQY+Y7Gi28/R5I726W6aw4Lf5F8dBw73WLOld1zBIjeaQvCWnBKAKTy9b3muiAp/IMbZKuQizO8AjJOmMjtnE0OR5HTm9UjLadF2MrD21csDnUWri6lxcT57iaT2/+Cy+YfRUmWSmprIxyiDyauPKtwhNhmc4v9pvVsBW6SQgZ+MB7BA7kOI3fd8hAabBXiQkf9qOr4nD0zmKm4
 I7NW20bd
 uQQDzIMvkZu9QmczWb/0C4rXUZxb6bxPkal92quKbHsrwpIN8HxxMAKfnmgWxi3qbgORLiBqkt2038G+ShmJHb4N6bt66sS4D/7sSgHYIQQArpr/62l0uF1v87x0+0HiXfZx8tG31BTYVxmcY9FAnG+p+j3nL6J+2hs2oWBqkUm/dAWKSIGdIerGzgLoKdR6wRbVmlUNSb6KK7tUuDVMn0EQulfomg5cU9CsayPjjs7zEPWOyfmZ9D+fSYkpQ9OzwKsXQE2Alr+aqmcQyrdCF03102Jnm4K+FQUQWlAYzwN9uX7iYc9h1Fv1wuuYJH5gcdju97sWc8kBeL2TNHX799Pqizn8tU9Dk1vrl17gjt+R7JZV1YjQp95hlUAlOfOK3MFCThnAQVP8GNB17jEiYIa+0lPIyEBuIO3IALS8/8i10H3jD3tZhPK2wZrpzvlJBjrw4Q1mBlEWlEA83Z5kpyu2F5eHbKudMH+vWjYK8y8XtLdvOD30v6mevZklNKTfyHk/2MGdtntEIMauT/bRG+rOPRpgLHc6YfXqB3GfxHvehrbl7TEqSGeiOFr/fJSGdfcKeOy9xbucC3UeWf8HP8eSsb3h8PVPRNZlUuI5YF+aw9Apzz24tLkVgpDVx2pfSVwhTKmDlF5Iskvhbsi/9Zqp6hQYcLKR12MoE
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
- [Medium] mm: soft lockup in replace_free_hugepage_folios() on deferred
  HVO folios
- [Medium] mm/hugetlb: repeated dissolution of undissolved folio in
  replace_free_hugepage_folios()
--

commit 10e41795aa4490543b53bcfb3054aebb335f7640
Author: yangge <yangge1116@126.com>

mm: replace free hugepage folios after migration

This commit skips isolated free hugetlb folios during hugetlb pool
allocation and introduces replace_free_hugepage_folios() so free hugetlb
folios left behind after migration in alloc_contig_range_noprof() are
replaced and released to the buddy allocator.

Link: https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yangge111=
6@126.com
Link: https://lkml.kernel.org/r/1736582300-11364-1-git-send-email-yangge111=
6@126.com

[Severity: High]
In mm/hugetlb.c at line 1354, does skipping MIGRATE_ISOLATE folios in
dequeue_hugetlb_folio_node_exact() break hugetlb reservation accounting
because those folios remain counted in h->free_huge_pages and
available_huge_pages(h)?

When free hugetlb folios sit in an isolated range, available_huge_pages(h)
still counts them as unreserved excess.  During migration in
alloc_hugetlb_folio_nodemask() (line 2441), dequeue_hugetlb_folio_node_exac=
t()
skips the isolated free folios and instead dequeues non-isolated free
folios that were backing h->resv_huge_pages, leaving the freed old folio
queued in the isolated range.  In offline_pages(), a subsequent call to
dissolve_free_hugetlb_folios() dissolves the initial unreserved folios
until available_huge_pages(h) reaches 0 and then fails with -EBUSY in
dissolve_free_hugetlb_folio() (line 2230) after persistent hugepages have
already been dissolved.

In addition, when a task faults on a mapping with a valid reservation in
alloc_hugetlb_folio() (line 3105) while the free folios backing
h->resv_huge_pages are in a MIGRATE_ISOLATE pageblock,
dequeue_hugetlb_folio_vma() returns NULL and falls back to surplus
allocation, which fails with -ENOSPC (delivering SIGBUS) when overcommit
is disabled or the hstate is gigantic.

[Severity: Medium]
In mm/hugetlb.c at line 3022, can replace_free_hugepage_folios() loop on
 every tail PFN of the same hugetlb folio if
__update_and_free_hugetlb_folio() does not dissolve it into buddy pages?

After alloc_and_dissolve_hugetlb_folio() returns 0,
replace_free_hugepage_folios() advances start_pfn by 1 rather than
skipping the rest of the hugetlb folio.  When old_folio is
vmemmap-optimized and hugetlb_vmemmap_restore_folio() fails in
__update_and_free_hugetlb_folio() (line 1689), old_folio is put back on
the hugetlb freelist as a surplus compound folio via
add_hugetlb_folio(h, folio, true).  The subsequent tail PFNs resolve back
to the same old_folio via pfn_folio(start_pfn) and call
alloc_and_dissolve_hugetlb_folio() again, allocating extra replacement
hugepages and permanently inflating h->nr_huge_pages and
h->surplus_huge_pages.  Similarly, if an HVO folio has
HPG_raw_hwp_unreliable set (line 1681), __update_and_free_hugetlb_folio()
returns early with PG_hugetlb still set and HPG_freed clear, causing the
next PFN iteration to spin indefinitely in the
!folio_test_hugetlb_freed(old_folio) retry loop in
alloc_and_dissolve_hugetlb_folio() (line 2901).

[Severity: Medium]
In mm/page_alloc.c at line 6741, should alloc_contig_range_noprof() call
wait_for_freed_hugetlb_folios() before replace_free_hugepage_folios(start,
end)?

When HugeTLB vmemmap optimization (HVO) is enabled and
__alloc_contig_migrate_range() migrates an in-use hugetlb folio that is
freed to the buddy allocator (for example, when migrated to a temporary
folio or when surplus pages exist on the node),
update_and_free_hugetlb_folio() queues the old folio onto hpage_freelist
for free_hpage_work with PG_hugetlb still set, refcount 0, and HPG_freed
clear.  Because wait_for_freed_hugetlb_folios() is only called later in
test_pages_isolated() (mm/page_isolation.c, line 622),
replace_free_hugepage_folios() (mm/hugetlb.c, line 3022) passes that
deferred-free folio to alloc_and_dissolve_hugetlb_folio() (line 2901),
which busy-spins on !folio_test_hugetlb_freed(old_folio) taking and
dropping hugetlb_lock while free_hpage_workfn() sleeps in
synchronize_rcu(), and triggers a soft lockup if the caller is a
SCHED_FIFO or SCHED_RR task on the CPU where free_hpage_work was queued.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106220835.2878=
368-1-mkbund@amazon.com?part=3D1

