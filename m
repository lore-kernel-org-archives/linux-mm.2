Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A403CD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 18:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EB276B0005; Thu,  4 Jun 2026 14:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C496B0088; Thu,  4 Jun 2026 14:13:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C0916B008A; Thu,  4 Jun 2026 14:13:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF626B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:13:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD1D18C84D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 18:13:14 +0000 (UTC)
X-FDA: 84843027108.21.5DD38EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 21D7C4000B
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 18:13:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="V/XV3iVQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780596793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h9siRJLal0UIGuKxUNFIYMAX2s/cZPxHkMdng7Hug/w=;
	b=Q7Af78ydeOmeEO3Ke6RpGGOGAD2wBDmarl8+tSuMWCFCpcKZPHxtHAAXXTTmzSSQMyXFIi
	7F0UeBmHDDNdMiIv1DqqBaxa72ap6PJFgtrUwCOF70VRUO+U+bUO3UdEwb/G70ZEJofY5F
	kwkNgLFvJEOLeuxVk5iaAQGFrNJ8E34=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="V/XV3iVQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780596793;
	b=Ewhblf4qUa4DZy5wY33RGD6TtYRdvmmBr6VN4Fi3gfVbF9KhkVUog1454DmwvmSZLmlWyM
	VfTEU+xRFFSFoXnfjiDLxE7rTC4V3nGcdjWYvTxtcP44TKc9j9l5Cd0fZ+UHPFF4MbEzQH
	6Vve+y2X5xo/WwX9Rao8oL0mFBWsMdQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B881E40A7B;
	Thu,  4 Jun 2026 18:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AA21F00893;
	Thu,  4 Jun 2026 18:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780596791;
	bh=h9siRJLal0UIGuKxUNFIYMAX2s/cZPxHkMdng7Hug/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V/XV3iVQ4PRKNVCvTu15YxKWSS8z2rg9Z5nKNSe0DJ+dG1R0b21v8OhFQ4xjYmiv5
	 WoLCGhlsrNR38uXgEgJvbBjPqBWzfmmFlsf/sdlzB1Ofqr5TAsYQwvF3CDdBLgoakl
	 aOe9tkeCuQRFp1PjFSSIuqO/tybLyiWr2qyQMufO+BTAwWqzMb6nGcNHiaeEPBnRvn
	 rgf8y0PSub1b3PAkTQEjcsGxF5s6Z/W+/p7EOceykOuqrmXTRI+Kz9LIInpTzzKysG
	 chLeb1cJbQD6EMoAlGWIOEqSOuUodSfhLmmXLR1XUTUezVeiZ+Ze23Sp4berUW2oCt
	 0eR/Zhg2EC1UA==
Date: Thu, 4 Jun 2026 19:12:56 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	liam@infradead.org, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com, 
	usama.arif@linux.dev
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
Message-ID: <aiG_-lP_HfxWXB4G@lucifer>
References: <2024af56-5e99-4799-a586-e9ba756cecb9@kernel.org>
 <20260601032804.96122-1-lance.yang@linux.dev>
 <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
 <616de1a8-1cfd-40b8-b04f-7b324be40bfd@linux.dev>
 <6b11bf0a-769c-4ef2-ac6f-2af38200a6bc@kernel.org>
 <baa0a462-46e0-44ab-b583-c722ad253afe@linux.dev>
 <06d9b665-945f-4967-9ed9-b06514478996@kernel.org>
 <CAA1CXcAeEGOsqp-ywAQ7GMYQzXEeco-rUxUkk2hEF69HybC4=w@mail.gmail.com>
 <CAA1CXcBSPVG4CJFCBDvbuodcJ_7eXoDQTpK0ZN0HEhkDPi-DEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcBSPVG4CJFCBDvbuodcJ_7eXoDQTpK0ZN0HEhkDPi-DEw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 21D7C4000B
X-Stat-Signature: ts1z8fjrjin59tn7w5hz36pq84y5fk6y
X-HE-Tag: 1780596793-599207
X-HE-Meta: U2FsdGVkX19kFUg9fGCxYRuZpsoHTkQO6srIuP/TTdldQyAa2c1d1xwoGSjs7QHmMHhEizm6dwSJpdQ04wJy5PHdBc5t3XNafA5Fb8SetAJs/ydszsXlB/C/PwgPNOFuFMLLXdsYghMh5QrPLd1tUr0VWhj0BnBq3GEJVH9BijZFHOlbpF3EtUShAttNoU72MLHPu1BfG7mMIjkboDyKeSuLIlFxe3POoj8+gRM1emblrWmg7yWJ9DETCQ6OdQ9Nr7YHcOXp5HfjfQaiEjPTQEcXGghKXbbpsEYpDPhgHwyJwLZy3dTFvfXDEAddRsmHKQrKamq8nvOLZLm4M8nPCSrmseWvQ0l+PxV8f+SdJGZjb8ln88ABR2YjB4eXmJ5ExI3Iq5Ub3BzrULzjEW8ZIhaUkVb0LZMr3s8JvCJj/9JGxqwpuQsObuPwjJRtQXpZJIUSf0bwtEqMKwXRHJ4MkgllNojwLlj5dwZP9aTlRabMioGqOWUQzdPv24VRakHCVudHBFLPC4lFt4yvg6oyeX8MD4bbT4BcBju8lW8tPetqw1uHCwmvkL5/KVvo9bHvlX4FvOdXQTbicTbmc1VUWrD0jN53G+Y2zF70j1+nRsLb14GHvR2ZA7GTkkXwwU0uaRUG+xJj4vOai7AZGzXx7UI3hJMjQeGbS8m8A/vMS0sWIrv9LLy2+AgRkfkDvirU72/ubUeMv3N671R5St4YaLJGjqITafQ9v0uK4WkmUYh1mZZwhAx4aWpx2lwzlWlzxvdT7ItF/iSD34fWoP4oGoNmprYfZbV8ntagg5rQoLOGKmEvP4qNqJ2wy93YPdpovNM6CchhMUQ/J6fFA5R9rSqaPbV0iwfUBZj0gm5oDYnTasTLwP1I3GbwbPS+PPcmDUUaM8GnNFtANKCVROQE5vZo/epEywX6auU5yoXf3cgFKlY/IJ4J4vMQlGCN82bXcNvtv3FPvEVCjp0fpVG
 UzzhWS39
 RizEGASoqRfqOfduAO42YCi++S5/yLRcHeVjPSWN0yqSW8MjVsVhGvEK95sII4pyd/ODAzAJihn7C2duEZB/tkvrMuceXJJtI/vLRq5tKZ6P3M/mhPdkrw3iKzh7SFPQ820nsTIH6wSg+PUwMn9IXENnf/rdTCuk5Ftan2mGrzFv2er1SWec+flB5WG15k6THHMOnaNdMCUD8zlWMElBYXHMzOti2GEvwU3x/gp3PqDPoToVaUAw7xhu0Iwyc6gRCvQA7N3BUdiuxzmJVzciLw3ZA5uSn/jFFUZgCiuG4hJFV2RU2QeCT7rCPKgrZEhQ6Y5aGzKY/xm/N1LrBrt7ne9S67nZxTgwkzTnWp4SXYrvuY9qHjIV8pz7x2zv+L7phke5mIJUfcz26Wb4OmpKxCJIekAPrDqNH5eEiYQFmbCJG5DcwIA0KyZOnM1uNKawZBW5b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 11:04:35AM -0600, Nico Pache wrote:
> On Mon, Jun 1, 2026 at 9:00 AM Nico Pache <npache@redhat.com> wrote:
> >
> > On Mon, Jun 1, 2026 at 5:14 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
> > >
> > > On 6/1/26 12:47, Lance Yang wrote:
> > > >
> > > >
> > > > On 2026/6/1 18:23, David Hildenbrand (Arm) wrote:
> > > >> On 6/1/26 11:08, Lance Yang wrote:
> > > >>>
> > > >>>
> > > >>>
> > > >>> One small thing, I think we should probably keep the smp_wmb(), and just
> > > >>> move it before the earlier pmd_populate().
> > > >>>
> > > >>> IIUC, the ordering we want is still:
> > > >>>
> > > >>>    clear old PTEs
> > > >>>    smp_wmb()
> > > >>>    pmd_populate()
> > > >>>
> > > >>> so another CPU cannot walk through the re-installed PMD and still observe
> > > >>> the old PTEs, right?
> > > >>
> > > >> There is a smp_wmb() in __folio_mark_uptodate(), that should be sufficient?
> > > >
> > > > Ah, cool! __folio_mark_uptodate() already does the job :P
> > > >
> > > > So yeah, no extra smp_wmb() needed here!
> > >
> > > Yeah. BTW, I think we'd need a spin_lock_nested(), so @Nico, treat my code as a
> > > draft.
> >
> > Okay, I read the above and did some investigating.
> >
> > I will try to implement and verify the changes you suggested :)
>
> I've implemented something slightly different actually and I *think* its better!
>
> } else {
>        /* this is map_anon_folio_pte_nopf with no mmu update */
>         __map_anon_folio_pte_nopf(folio, pte, vma, start_addr,
>                       /*uffd_wp=*/ false);
>        smp_wmb();
>         pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>         /*
>          * Some architectures (e.g. MIPS) walk the live page table in
>          * their implementation. update_mmu_cache_range() must be called
>          * with a valid page table hierarchy and the PTE lock held.
>          * Acquire it nested inside pmd_ptl when they are distinct locks.
>          */
>         if (pte_ptl != pmd_ptl)
>             spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);
>         update_mmu_cache_range(NULL, vma, start_addr, pte, nr_pages);
>         if (pte_ptl != pmd_ptl)
>             spin_unlock(pte_ptl);
>     }
> spin_unlock(pmd_ptl);
>
> The logic here is that when the PMD becomes visible, PTEs are already
> populated (no possibility of spurious faults on local CPU)
>
> the SMP_WMB makes sure of the above
>
> And the pmd is installed with the pte and pmd lock both held through
> the mmu_cache update.
>
> This follows the conventions used in pmd_install() and clears the
> potential for local CPU faults hitting cleared PTE entries.
>
> I think both approaches are correct but this prevents any possibility
> of my first point. although mmap_write_lock prevents this too.
>
> Let me know what you think. I can revert to your implementation but
> this is what I tested.

Yeah let's go with the original implementation please :)

Thanks!

>
> Cheers,
> -- Nico
>
> >
> > Or an even crazier idea... what if we ensure MIPS checks for PMD_none
> > before walking a PTE table?
> >
> > -- Nico
> >
> > >
> > > --
> > > Cheers,
> > >
> > > David
> > >
>

Cheers, Lorenzo

