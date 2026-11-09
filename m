Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBB01606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YH+odFKd
Received: by kanga.kvack.org (Postfix)
	id AB0CD6B05B5; Mon,  9 Nov 2026 05:43:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975DE6B05BB; Mon,  9 Nov 2026 05:43:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72BE86B05BC; Mon,  9 Nov 2026 05:43:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 39E236B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:43:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB2A4A0652
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:43:19 +0000 (UTC)
X-FDA: 85415243718.01.AAAD5D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 32372C0004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:43:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YH+odFKd;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794220998;
	b=OfagpdHiQYb9DmeeiZodmLFuo9pmky03+FbXnn2ErNaBTfi+6hxSR/LNp9EQ+Yl1xJqQIf
	DWEEHoiVSLpDdX4Q/ZsXqeWfY9oKYv2lib/G52cuOl1q5nmQjmyzs8uEX8GkYjY6H4dD39
	hZFwVtN5skSYGy83zkd1itPbCasXmUk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YH+odFKd;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794220998;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1saXgw20td4u9tXkFAsQrPKhjku10gdBuo7SrDBnO4=;
	b=5goubehXVOpnRhpzoaEMrEwogCYs/cN8dLViXJxNTnLCfCrOAaxYEc+6aqHK4dpk46G62a
	MPjx2Anry57abfK+bNp+eexYJrw2TuzfbMG8cxFPMO2AMsEUqpC9ovvaGnGqVD2gPmW1C+
	DCld75oMyq5bbsAAkZURgdr0zUTl/Zs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EFEC43AD1;
	Mon,  9 Nov 2026 10:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A271F0089F;
	Mon,  9 Nov 2026 10:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794220997;
	bh=+1saXgw20td4u9tXkFAsQrPKhjku10gdBuo7SrDBnO4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YH+odFKdqd6W0c2J2xZWIDUE+GAJnzwCquxhqBjtbRrf+Mahy8fY1mLG5hO1TUf+2
	 gMlVuiuzAwIv0G9DRLea54bLiUXlZ6+yIhx8w9CYFancgQ7oCz49TiFZZjofT66P78
	 OzOq2VJj7hog6jhdXJbmUOMvptkfW2r6AwIBzpPB2IXD3vG3p1X3qUAT3rIX0L91b7
	 aGp5y04k0gU25hhhPRVm9xS3rjxLGRtOpOy1A/Yp/fShIKKfxmYofoi4Kji6hJVzFV
	 K4CVUlkiJG/DuC5KrUii/OHydC46un4Az1oAhLoNZ+M8wG7M1qZIzqBA1DBM0D8ksg
	 Q8sSmBBOC5h+w==
Message-ID: <sashiko-outbox-204839@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 05/11] mm/hugetlb: drop boot-time HVO handling for
 gigantic folios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Mike
 Rapoport" <rppt@kernel.org>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Muchun Song" <muchun.song@linux.dev>, "James
 Houghton" <jthoughton@google.com>, "Lance Yang" <lance.yang@linux.dev>, "Qi
 Zheng" <qi.zheng@linux.dev>, linux-mm@kvack.org
In-Reply-To: <20261109095807.41547-6-songmuchun@bytedance.com>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
 <20261109095807.41547-6-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 10:43:16 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 32372C0004
X-Stat-Signature: 7shkuzmsi1bo5xkpuzymdsjdnns9t6tg
X-Rspam-User: 
X-HE-Tag: 1794220998-103014
X-HE-Meta: U2FsdGVkX19CuWSjcIBe8vOuIV97ktYlLSm5rTjZrwI4Pt+pPoUv5PTz/VqoACDAqtq//cy4acozfPsVvAg0561WxPfDpM/0fsmkHp7DNV4FUPJY/f7htNQvw30ly0+Hqka1SmYwNUKkS3N7GOtPUpAcqt+Z9Sel+Bw3qIphOketIfIYec33K92bglGiTv885lKk1xAKVaXm7VLDVqKs0dBmfW65HolMs4Syqayr+H9FTBAbBjOyXjLx+VJYrSrWnyyma6OJYcGhKJy7z4uo0XKR3xHoaZtsAjaaJlrTeXr9Ax3Zp9Dqg9A/ujEXdPNldme4LGGLtjLw/3EaFiCxKLKvKd+Aaoc0uCwrYGOsB+6n8eAGTvN+Wejf1GjwZAD/6AirHcNLZi2jR3lWEePW8+cQ25FZaLPWdtzZwYourKQEDT/cedZGTOgqAm331TGqFfBgVCGwCAXAqBtqEEJaDDHWR9Cc2pH4BI0zH6xUWGwm43xNFvPIhW6NyFvw4Aj/u8VpLk7rwoovcYPO/lM+xUy0UI74+dYIEIAVFsRtUiTQxsAhsuVvCjpANTQ3DBLjZfYzLPMSMLfSayEJa/BeR9dIXgPUABhhbIcS3famF1YAx1W6cLH/EhVM1C1Ba/Ednk+zviWP1l3Uu1ejA3pCT38cv1s0KTYbMxoJyE9t+Ci129tUM3BNIrKmO+Qc8byeSkp5sdCXEq8PoTqcqwIWaeewNClw9Qs/Iq84kZKLtMUcfUQ080tlvp+c5q47GIenr4doMCU88nw8XWruOxdjrMP3k6quYiJPdcJXBUsQ3hUBfXLBBJpFjC1i0E//UXqFaguI3t3YRRZyY43/UyyfYrnA+Dr1yCcZKWbsNUGG40GqXdIpVIBe4HOPN7SD9kJgf5QxdHNFqtw75CiKC84jgczCAF74Lq1WPPseiX2+1rhK6/J0oo6iXjTGZz1ezXjmpjluiT29wOt9XturQpp
 RfAL+jip
 56+AGkptd5byYIVzCBJFoCavep2YyvBbOJ+Cqcx83cA2w8VcptH0HihvGbQK3BXfVghIVah+Vp0JD/xOJjXxx+zZIys/lKdzMabRJ8XMYbVvLf9ymMnm8Jj6FZm6Drq0weZXIAwZuGeQ/+X62yiDE7/B6QrB1AGdjZTXM10t3rz++vC7hjVRsFC5cdj24N8Jsp6kEiz9e38KMSekKdCHmLwwnHHqL1lmv62mmQkR25A78Unz49avXcmQNaRu9Lvl+dvntzKsdXz96KqPf84rvCyOAB6VGGeJbFJqlK0Gb/KAVihVyHHkrgtXPfkcDWpuEQJ/16ZbqfTheOmb7ZzWlaaUeWL4LCov12L6aMqsaWVpFQZcErrc0F34ciknF4JbjqA+f9ShChK08hnRQWmU2y3jP+BCIsqIPSHyE4EprWcYp7Y2JwGLdk+Inw+EpwlArBBN7/R7e37+EKo6WsAihhWbFsm3nAE6nbAQtCuA7qCb//dTE6BL8tEfw53/VIGVD/pHz6oup6D23NjenfYjx1Zch8jXatxzBEHlSUoxdv4VktOJXlrGZ39KS28FDBRYUGu9Y4XqjX1Pa6mPVk1j3+37r6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 2 related pre-existing issues it does not
introduce:
- [High] mm/memory-failure: race between hugetlb_update_hwpoison() and
  HVO head remap [1]
- [Critical] mm/hugetlb_vmemmap: race between deferred PMD split flush
  and PTE remap in vmemmap_split_pmd() [2]
--

commit da0d2d6e0b849f9a259d74fcb047aaceb9617411
Author: Muchun Song <muchun.song@linux.dev>

mm/hugetlb: drop boot-time HVO handling for gigantic folios

This commit removes the boot-time bulk vmemmap optimization call and tail
page initialization fallback for gigantic folios, relying instead on the
section-based vmemmap optimization infrastructure during bootmem gathering.

> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index ba8e11e399b24..d73ceeef392eb 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -552,7 +552,6 @@ static int hugetlb_vmemmap_pteify_folio(const struct =
hstate *h, struct folio *fo
>  void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head =
*folio_list)
>  {
>  	struct folio *folio;
> -	unsigned long nr_to_optimize =3D 0;
>  	LIST_HEAD(vmemmap_pages);
>  	unsigned long flags =3D VMEMMAP_DEFER_TLB_FLUSH;

[Severity: High]
This problem wasn't introduced by this patch, but can a concurrent memory
failure race with vmemmap optimization [1] and lose hardware poison
state on a newly allocated hugetlb folio?

After init_new_hugetlb_folio() sets the hugetlb flag on a fresh folio
(for example in prep_and_add_allocated_folios()), both
folio_test_hugetlb_freed() and folio_test_hugetlb_migratable() remain
false while hugetlb_vmemmap_optimize_folios() remaps its vmemmap pages:

CPU0                                  CPU1
hugetlb_vmemmap_optimize_folios()
  __hugetlb_vmemmap_optimize_folio()
    vmemmap_optimize_folio()
      vmemmap_optimize_pte()
        vmemmap_dup_page_from_list()
          copy_page(dst, src)
                                      try_memory_failure_hugetlb()
                                        get_huge_page_for_hwpoison()
                                          // returns MF_HUGETLB_RETRY
                                        // retries with MF_NO_RETRY:
                                        get_huge_page_for_hwpoison()
                                          spin_lock_irq(&hugetlb_lock)
                                          hugetlb_update_hwpoison()
                                            folio_test_set_hwpoison(folio)
                                            llist_add(&raw_hwp->node, head)
                                          spin_unlock_irq(&hugetlb_lock)
        set_pte_at(..., dst, ...)
  flush_tlb_all()
  free_vmemmap_page_list()  <-- old head page freed, hwpoison lost

Because vmemmap_optimize_pte() copies and remaps the head struct page
without synchronizing with hugetlb_lock (and defers the TLB flush across
the batch), hugetlb_update_hwpoison() can write PG_hwpoison and the
raw_hwp_page list entry to the old head struct page after copy_page() has
already finished.  Once the remap and TLB flush complete, the raw_hwp_page
allocation is leaked and the poisoned hugepage is added to the pool
unmarked.

> @@ -560,18 +559,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *=
h, struct list_head *folio_l
>  		return;
> =20
>  	list_for_each_entry(folio, folio_list, lru) {
> -		int ret;
> -
> -		/*
> -		 * Bootmem gigantic folios may already be marked optimized when
> -		 * their vmemmap layout was prepared earlier, so skip them here.
> -		 */
> -		if (folio_test_hugetlb_vmemmap_optimized(folio))
> -			continue;
> -
> -		nr_to_optimize++;
> -
> -		ret =3D hugetlb_vmemmap_pteify_folio(h, folio, flags);
> +		int ret =3D hugetlb_vmemmap_pteify_folio(h, folio, flags);
> =20
>  		/*
>  		 * Splitting the PMD requires allocating a page, thus let's fail
> @@ -583,9 +571,6 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h=
, struct list_head *folio_l
>  			break;
>  	}
> =20
> -	if (!nr_to_optimize)
> -		return;
> -
>  	flush_tlb_all();

[Severity: Critical]
This problem wasn't introduced by this patch, but can deferring the TLB
flush across PMD splits here race with a concurrent single-folio vmemmap
optimization [2] and remap PTEs before the 2MB PMD split is
flushed from the TLB?

A single 2MB vmemmap PMD covers 64 2MB folios.  While
hugetlb_vmemmap_optimize_folios() splits PMDs with VMEMMAP_DEFER_TLB_FLUSH
during bulk pool resize or demotion, a concurrent
hugetlb_vmemmap_optimize_folio() (such as from
alloc_surplus_hugetlb_folio()) can optimize another folio covered by the
same vmemmap PMD:

CPU0                                  CPU1
hugetlb_vmemmap_optimize_folios()
  hugetlb_vmemmap_pteify_folio()
    ...
      vmemmap_split_pmd()
        pmd_populate_kernel()
        // skips TLB flush
                                      hugetlb_vmemmap_optimize_folio()
                                        ...
                                          vmemmap_pmd_entry()
                                            // !pmd_leaf(*pmd), returns 0
                                          vmemmap_optimize_pte()
                                            set_pte_at()
                                        free_vmemmap_page_list()
                                          <-- old vmemmap pages freed with
                                              stale 2MB PMD TLB entry live
  flush_tlb_all()

Because CPU0 has already replaced the leaf PMD under
init_mm.page_table_lock, CPU1 sees !pmd_leaf(*pmd) in vmemmap_pmd_entry()
and proceeds directly to vmemmap_optimize_pte() without a PMD-range TLB
flush.  CPU1 then installs 4KB PTEs pointing to different physical pages,
flushes only its own folio's vmemmap range, and frees the displaced
vmemmap pages while stale 2MB PMD TLB entries remain active, which can
cause overlapping-TLB machine checks or use-after-free writes to the freed
vmemmap pages.

[1] https://sashiko.dev/#/bug/linux-18e93f17-529b-4d84-ba44-a41829f4be64
[2] https://sashiko.dev/#/bug/linux-fbdc3410-a4cf-457e-88e6-684380fbadfe

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109095807.4154=
7-1-songmuchun@bytedance.com?part=3D5

