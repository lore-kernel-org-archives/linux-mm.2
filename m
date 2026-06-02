Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2102CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 16:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE08B6B0005; Tue,  2 Jun 2026 12:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D917A6B0088; Tue,  2 Jun 2026 12:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80AF6B008C; Tue,  2 Jun 2026 12:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA2626B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:34:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56E39A097C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:34:58 +0000 (UTC)
X-FDA: 84835521876.26.FE919C2
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7531F40011
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:34:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="e99alI/o";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780418096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kfv65sDfPDmPDpEO0E3tjxWYqpXB1G5lz0Quc0XLk54=;
	b=Goikm8RkikV3QrFxY4caJtWeylbxYxlj5NNgqIGiZuBOdTiW+GedMnnuZxihO8otXDHzcL
	FlCXeo+ofiBQaie+SQ2TNskEuuCCoZdXBjM14CLtc2JpAseIbzGmlMrlHzus1ba6lXhjAP
	lEGmRIbLAGsbaH4th1LxOvb6lrZatZM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="e99alI/o";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780418096;
	b=2FxE/951ST/mM475SOf4A/k8D0ENF5W0687GIbYiii/Z5C3vIGaA7Zew3ziy8hjhwA2OMZ
	PyAmGfIM1B7T/H0NN7Ge9AuZbzp8IZilN9tF0V1fpxgMCNgsFOJuybYTM8irmIK0ecnx0j
	GLkLHhCEQRZkNadlvjxI1PNctDoOJBs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780418093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kfv65sDfPDmPDpEO0E3tjxWYqpXB1G5lz0Quc0XLk54=;
	b=e99alI/oamPJv8ECRvV4dpEn6AtfCTtrQLYfTTiheBxLC0V7F4073yDgp+SJ8btK+1Bls+
	489j1GGe0TmK1/VotWwJHV1ZBblOz+AnoFF6aywKWaSeg1yk/EUaSnEX8fmav4ytNOvWDs
	35D+wl50XsMRVVFSKGbug9oWaVNSKEI=
From: Lance Yang <lance.yang@linux.dev>
To: npache@redhat.com
Cc: lance.yang@linux.dev,
	david@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
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
	liam@infradead.org,
	ljs@kernel.org,
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
	zokeefe@google.com,
	usama.arif@linux.dev
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize collapse_huge_page for mTHP collapse
Date: Wed,  3 Jun 2026 00:34:18 +0800
Message-Id: <20260602163418.93877-1-lance.yang@linux.dev>
In-Reply-To: <CAA1CXcD7peS3WHueVgAWhhRrjBO_1b19+Xc0CfZBSO8OwJJKQw@mail.gmail.com>
References: <CAA1CXcD7peS3WHueVgAWhhRrjBO_1b19+Xc0CfZBSO8OwJJKQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7531F40011
X-Stat-Signature: aa6od44yk5buaz9orebpyu1yhzw3piuk
X-Rspam-User: 
X-HE-Tag: 1780418096-159362
X-HE-Meta: U2FsdGVkX19nb7NiP2wVkZi7V3gtQaLBrRDcaR0rBivvRWrLH08KbqtgnJP5kDqAIRBEKAtiDorVsgBrzZiPngY0Q2tI9lycgnXf2ZWyItYFCUR+YBGy/Ivb4JDWJKCygT1EF14cnQwntAeSPka4k6KCdm2Zu8QBday1FWIdWdg+loVycvbAk8byJXyYy2dQpIFcgMMghGum7Zy1hnrQxfPju9SJWIQ2D4c9zz8m1qx7lDjsunwsU25EY+jEkLHfEQ8K8TEP+lH4dZv0BUsjh3UrWnYoQ4ZM4lbaxc8GEH2ELXLy6gXj4T5pUTw/VvscAZ3GB0pI3enjQg/PUsG/rV99SBrvwvbs6WbmA2VhE4SGxvJUdwIffUF+PpwtDCYiD2DRD6FirAY7q0Spuef4uiRB0vgCRQqk8E2/o/OisjDUN6jTuLQQ2T5wuMVaE2swxtv96WLZNzH7U1g6bYjl6ccecxC0x10slqrusZjZx4YN0MHXBmMmrvZvM9Owunlo4ox5edXbrGsFU72jCI5MoJy2upDKLXJ0fJPywQpvHz8QeArVDPun4N3youOMNoYoCL9fEeU/0EMqakBCCGEIQR4DEINKISLbPvcnh9unQ1tId1BSeZxjvnM7QArumWnoLjQcYbbhGzk6Os815zTK6PZyvEnJYEYh2RWz+yzX25S8SOFV3Ktk1yN0b8VRusrEQMyaSbbPnDnov3Y9/JvJ6ClL4x5cJhpFXhaeMSTyVc0L0hy3kwZgZCiUQD1b2j4z0xFL6rQjJPmJ91PVyJu2DuKPwKN+wmY2Wm+tncNnjnaJ5r+45PNFq6uXjtevwOon5h0ruPNBrLmUHvwr1TysYLOo7wIcK9XMY/WgHo70q0CZm+kNiwUQteMrVP0/DNB+qadAMEXMztrLTo1wOEY5Y27Z52q0HbYY3ev7eGyu9eJYXSjYsA9Wi7azZGk0IJvAdr0pLkxudvD4s6hqO4U
 VUBkAJtf
 +QCbIoQ/BCwEMfUQ0Ms/lR1thvn5jfQfVQptfPPtUXkLQdXTNx1QfqG1l0hLzJqIEeEKBZL6A1mCSD7JMmjMVFOPFvaHpuMxXX340NDg7jbhidV+fmmJKONELi/VMKYRQ+NehqH1krmaJrVRU5cFk2bNa8aY/ob6IxjWLxF1KleBcbId8+WqeKl41ISx75f/Vx/bEuFW0sLWMcnXdvQlvqg7C5EGYEJRCtmhM75yrUarbi0qeoyWkqlxvQphtWQg6QJeaEgika3xCzKf5Y/QXG7yccGQ6p+qKQ+PLmi6kJthkdhW8VtZ/gsmo+NwJSuViZm70
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jun 02, 2026 at 09:30:06AM -0600, Nico Pache wrote:
>On Mon, Jun 1, 2026 at 4:48 AM Lance Yang <lance.yang@linux.dev> wrote:
>>
>>
>>
>> On 2026/6/1 18:23, David Hildenbrand (Arm) wrote:
>> > On 6/1/26 11:08, Lance Yang wrote:
>> >>
>> >>
>> >> On 2026/6/1 14:54, David Hildenbrand (Arm) wrote:
>> >>> On 6/1/26 05:28, Lance Yang wrote:
>> >>>>
>> >>>>
>> >>>> Ah, fair point.
>> >>>>
>> >>>> I was mostly worried about arch hooks that walk vma->vm_mm again, rather
>> >>>> than only using the pte pointer passed in. For example, mips does:
>> >>>
>> >>> Right, a re-walk would be the real problem.
>> >>>
>> >>>>
>> >>>>     update_mmu_cache_range()
>> >>>>       -> __update_tlb()
>> >>>>         -> pgd_offset(vma->vm_mm, address)
>> >>>>         -> pte_offset_map(...)
>> >>>>
>> >>>> and __update_tlb() has this assumption:
>> >>>>
>> >>>>          /*
>> >>>>           * update_mmu_cache() is called between pte_offset_map_lock()
>> >>>>           * and pte_unmap_unlock(), so we can assume that ptep is not
>> >>>>           * NULL here: and what should be done below if it were NULL?
>> >>>>           */
>> >>>>
>> >>>> So if khugepaged happens to run with current->active_mm == vma->vm_mm
>> >>>> here, could __update_tlb() hit the none PMD, get NULL from
>> >>>> pte_offset_map(), and then dereference it?
>> >>>
>> >>> Likely yes -- that MIPS code is horrible. And the comment in MIPS code
>> >>> even spells that out. :(
>> >>>
>> >>> Do you know about other code like that, or is MIPS the only one doing a
>> >>> re-walk and crossing fingers?
>> >>>
>> >>>>
>> >>>> Just wanted to raise it since some arch code may still have assumptions
>> >>>> like this, and the always-enable-mTHP work is getting closer ...
>> >>>
>> >>> Right. I assume set_pte_at() couldn't trigger something similar (re-walk) in
>> >>> arch code,
>> >>> because we simply provide the ptep. update_mmu_cache_range() only consumes the
>> >>> pte.
>> >>>
>> >>>>
>> >>>> Probably very very very hard to hit, though :)
>> >>>
>> >>> Delaying update_mmu_cache_range() is nasty, as we'd have to make sure that
>> >>> nobody can interfere in the meantime ... and the PMD lock will not be sufficient.
>> >>>
>> >>> Maybe we could reinstall the page table with the cleared (none) entries while
>> >>> still holding the PTL?
>> >>>
>> >>> Thinking out loud:
>> >>>
>> >>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> >>> index 5ba298d420b7..e39b750b1e6f 100644
>> >>> --- a/mm/khugepaged.c
>> >>> +++ b/mm/khugepaged.c
>> >>> @@ -1413,13 +1413,17 @@ static enum scan_result collapse_huge_page(struct
>> >>> mm_struct *mm, unsigned long s
>> >>>                   map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
>> >>>           } else {
>> >>>                   /*
>> >>> -                * set_ptes is called in map_anon_folio_pte_nopf with the
>> >>> -                * pmd_ptl lock still held; this is safe as the PMD is expected
>> >>> -                * to be none. The pmd entry is then repopulated below.
>> >>> +                * Re-insert the page table with the cleared entries, but
>> >>> +                * hold the PTL, such that no one can mess with the re-installed
>> >>> +                * page table until we updated the temporarily-cleared entries
>> >>> +                * through map_anon_folio_pte_nopf().
>> >>>                    */
>> >>> -               map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /
>> >>> *uffd_wp=*/ false);
>> >>> -               smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
>> >>
>> >> One small thing, I think we should probably keep the smp_wmb(), and just
>> >> move it before the earlier pmd_populate().
>> >>
>> >> IIUC, the ordering we want is still:
>> >>
>> >>    clear old PTEs
>> >>    smp_wmb()
>> >>    pmd_populate()
>> >>
>> >> so another CPU cannot walk through the re-installed PMD and still observe
>> >> the old PTEs, right?
>> >
>> > There is a smp_wmb() in __folio_mark_uptodate(), that should be sufficient?
>>
>> Ah, cool! __folio_mark_uptodate() already does the job :P
>>
>> So yeah, no extra smp_wmb() needed here!
>
>are we sure? that folio_mark_uptodate is done before the PTEs are
>reinstalled. Then we reinstall the PMD right after. Currently
>separated by the smp_wmb().

Reinstalling the PMD first makes the PTE table reachable again, right?

So before pmd_populate(), we only need to order the old PTE clears before
the PTE table is reachable again; __folio_mark_uptodate() already has the
smp_wmb() for that :)

The new PTEs are filled later under the PTL.

Hopefully I didn't miss soemthing :)

>I was copying this from other THP code that performs similar PTE/PMD juggling.
>
>I can remove it, but I'd rather air on the side of caution with this.

Cheers, Lance

