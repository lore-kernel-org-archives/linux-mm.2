Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D052FCAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 12:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7F548E0007; Tue, 23 Sep 2025 08:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F678E0001; Tue, 23 Sep 2025 08:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1EC68E0007; Tue, 23 Sep 2025 08:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 870FF8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:51:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5042B9C00
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 12:51:40 +0000 (UTC)
X-FDA: 83920501560.20.06F784E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 34398A0010
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 12:51:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758631899; a=rsa-sha256;
	cv=none;
	b=mT4MdwuAPtkYE3+LLlxjTfVs/ZUw9cxVy9+XBsuvWc0g1xSBnDHF8FQ+6qAmEI0IaIy36N
	DBoGEV4dh2VxWNa1y5PJYrEHyh/6rm1+Yh9Z9PKbTdFHG0M6YZwzGFf2XIvId0qpPMY3s+
	FUMsciQEjGtVp61vO3fznWtiBENSyH8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758631899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zbMyxGJKnCifDzYMlTNsZNz35I2L39o9GdGpyX8yzLI=;
	b=I56r3bd5nkSl/VO6jWwNKetFXCzUmZuCsUV3sKv2FyXQWksJrEDgfLQNlLGIfql4it1xo8
	vVqOO5O1OUzI/06spuF/rPWrTmdD+5Dm/zSmgsLPtET/3rW2l7KsZJH6I8RcrsLHOsZdUK
	xROBC5QhHc3ZecdbtxCzUiKokyQ/Arg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 207C26027E;
	Tue, 23 Sep 2025 12:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A7AC4CEF5;
	Tue, 23 Sep 2025 12:51:30 +0000 (UTC)
Date: Tue, 23 Sep 2025 13:51:27 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, usamaarif642@gmail.com,
	yuzhao@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	baohua@kernel.org, voidice@gmail.com, Liam.Howlett@oracle.com,
	cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
	kaleshsingh@google.com, npache@redhat.com, riel@surriel.com,
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com,
	dev.jain@arm.com, ryncsn@gmail.com, shakeel.butt@linux.dev,
	surenb@google.com, hughd@google.com, willy@infradead.org,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, qun-wei.lin@mediatek.com,
	Andrew.Yang@mediatek.com, casper.li@mediatek.com,
	chinwen.chang@mediatek.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-mm@kvack.org, ioworker0@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
Message-ID: <aNKXz3B7iIIv7LxK@arm.com>
References: <20250922021458.68123-1-lance.yang@linux.dev>
 <aNGGUXLCn_bWlne5@arm.com>
 <a3412715-6d9d-4809-9588-ba08da450d16@redhat.com>
 <aNKJ5glToE4hMhWA@arm.com>
 <8bf8302a-6aba-4f7e-8356-a933bcf9e4a1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bf8302a-6aba-4f7e-8356-a933bcf9e4a1@redhat.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 34398A0010
X-Stat-Signature: 3asw9yj7e63fpc9kfzpi8fce7tx6xbod
X-Rspam-User: 
X-HE-Tag: 1758631899-279531
X-HE-Meta: U2FsdGVkX1+uXGADOdbPPzouvKLRZpBZ78XC3+pTioWHm8vbcpK2uRKvKoUBU2CLxnR9J0jQsFNFOgTrT498Xqm7SwO9D9qW4KwBsPfmyihNiPrcehqNElEc9uS24v2J2OCfH4GXvMQpJhzFvSNWqIOp4ol4hfApIc2mjk4P6ad5hzZE+qm4p0rM9BHmvxzO5YaqGDrnRfk9yFDDY3pyfwxbfJEfsSwDMEZ9qDKZgxlKAjeyeYwVdAF/yzdU5As259y4pu+AXzv0ck4dQ0QlS+54e7dZpFbioec+9fuw5MYIaFNf7KchoN+ReX7kdLgFegbOl74Y1YoQnMX09GrstqzxRLo91tcRtjWpg4KttqtYdtgOszPQwEtp7nTGobDliApnrzW/3BDFZU9ZcupEVgarvJlM9n1tm7BFzfxIWFY8pXD7Fu9bPaX4ppn/4OVil2kzBV68BJhMbCyiFLN2LhpDjvZzkIyKz6XdrrwFzLy77nRE/SbHFC/p8k1OaOlYGGWYrmlgto7Ghn2pbEk/rSECuUdCIyM/zdjpgYKVyEeGx+NAALKR1hGTsZCyjTkv58/vyYwd3v1G0t5db8cUGej1L72uB1ErQtwQgIrd31xQqTk+sDwNxBvW59ISO2J1zreuI9+JgWCi4t2UkwY0kwe5loOVUHHEwGW+7IL1ysqzbwOMulcqu9HaL+4UE4+aPvlrGn7ipDfZA7vWb2owdb2w/MTtHicqcyoGOBjUW/KGHQvRnOigyqvrDDb9LD2Ryr3FMRIK9THL/PvvPdFbDPCuIMWgB9NQIVBOfl4tfPqXjEvSZ6v0AGSxZbE+A1JNoixl4YVW1JbfIQaSqzidDGx3Pe5PaQWJcDabTGXFFIITDNw7QmvLNUQ7d7OmrBJ0qEXgDrHt02uiWLQOXb3veZfuTohozPLCIXhuQg1RKG/6dEnnTjLzTKcifu6QaklgiCJHMjG6oFFY1Ge486s
 APdcF0s6
 /HiP/mszIUSMDUCLs/6zsjwatvAKoiSmN1rtdI0Iekg2Su3SV0UrCw5fT0lwezsNG3PmUIzw8PQ2Scb6iHqglkPqb/HXSVGBu7K0aHTUnEJOHtlMTztgP7Z9QUu1FB0jC6X6pSFOu8hIblstm2PpVP7Upfkayf+GbCjM59E1sJE7pE2Jeqvn1doKIH9Ef/zgus+rNO8csViGTiBeLbO8fDN5rsx17SvzEKF7cRtcviIjspLo0uuLLNvP1bOh1IP3pi2NbE75VhQ0UlQ5sbRVwMQdjYJFzoPZGWB88arMyHqllSESQ80LdtHOZQ2J2TP7wxCGJqCV2Oz+ztPzSWBvRVBdsMn0YtJPBFvxYl2LPtGFjps/GdbS86eSfsDGoS7FuCmFu6OTHQNe8DqiNLPWynkcVN3rm6K1avuOx7JcaLOcE2Pr4IUzK1eVMxQSpQjIDz2Kjq229JpBH2lL2d2ljDg68q+BvHczq2CSkPQYfw1KQwn3RTswcL+TpCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 02:00:01PM +0200, David Hildenbrand wrote:
> On 23.09.25 13:52, Catalin Marinas wrote:
> > I just realised that on arm64 with MTE we won't get any merging with the
> > zero page even if the user page isn't mapped with PROT_MTE. In
> > cpu_enable_mte() we zero the tags in the zero page and set
> > PG_mte_tagged. The reason is that we want to use the zero page with
> > PROT_MTE mappings (until tag setting causes CoW). Hmm, the arm64
> > memcmp_pages() messed up KSM merging with the zero page even before this
> > patch.
> > 
> > The MTE tag setting evolved a bit over time with some locking using PG_*
> > flags to avoid a set_pte_at() race trying to initialise the tags on the
> > same page. We also moved the swap restoring to arch_swap_restore()
> > rather than the set_pte_at() path. So it is safe now to merge with the
> > zero page if the other page isn't tagged. A subsequent set_pte_at()
> > attempting to clear the tags would notice that the zero page is already
> > tagged.
> > 
> > We could go a step further and add tag comparison (I had some code
> > around) but I think the quick fix is to just not treat the zero page as
> > tagged.
> 
> I assume any tag changes would result in CoW.

Yes.

> It would be interesting to know if there are use cases with VMs or other
> workloads where that could be beneficial with KSM.

With VMs, if MTE is allowed in the guest, we currently treat any VM page
as tagged. In the initial version of the MTE spec, we did not have any
fine-rained control at the stage 2 page table over whether MTE is in use
by the guest (just a big knob in a control register). We later got
FEAT_MTE_PERM which allows stage 2 to trap tag accesses in a VM on a
page by page basis, though we haven't added KVM support for it yet.

If we add full tag comparison, VMs may be able to share more pages. For
example, code pages are never tagged in a VM but the hypervisor doesn't
know this, so it just avoids sharing. I posted tag comparison some years
ago but dropped it eventually to keep things simple:

https://lore.kernel.org/all/20200421142603.3894-9-catalin.marinas@arm.com/

However, it needs a bit of tidying up since at the time we assumed
everything was tagged. I can respin the above (on top of the fix below),
though I don't see many vendors rushing to deploy MTE in a multi-VM
scenario (Android + pKVM maybe but not sure they enable KSM due to power
constraints).

> > diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> > index e5e773844889..72a1dfc54659 100644
> > --- a/arch/arm64/kernel/mte.c
> > +++ b/arch/arm64/kernel/mte.c
> > @@ -73,6 +73,8 @@ int memcmp_pages(struct page *page1, struct page *page2)
> >   {
> >   	char *addr1, *addr2;
> >   	int ret;
> > +	bool page1_tagged = page_mte_tagged(page1) && !is_zero_page(page1);
> > +	bool page2_tagged = page_mte_tagged(page2) && !is_zero_page(page2);
> >   	addr1 = page_address(page1);
> >   	addr2 = page_address(page2);
> > @@ -83,11 +85,10 @@ int memcmp_pages(struct page *page1, struct page *page2)
> >   	/*
> >   	 * If the page content is identical but at least one of the pages is
> > -	 * tagged, return non-zero to avoid KSM merging. If only one of the
> > -	 * pages is tagged, __set_ptes() may zero or change the tags of the
> > -	 * other page via mte_sync_tags().
> > +	 * tagged, return non-zero to avoid KSM merging. Ignore the zero page
> > +	 * since it is always tagged with the tags cleared.
> >   	 */
> > -	if (page_mte_tagged(page1) || page_mte_tagged(page2))
> > +	if (page1_tagged || page2_tagged)
> >   		return addr1 != addr2;
> 
> That looks reasonable to me.
> 
> @Lance as you had a test setup, could you give this a try as well with KSM
> shared zeropage deduplication enabled whether it now works as expected as
> well?

Thanks!

> Then, this should likely be an independent fix.

Yes, I'll add a proper commit message. We could do a cc stable, though
it's more of an optimisation.

-- 
Catalin

