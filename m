Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CBCECD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 15:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1166B00D2; Tue, 26 May 2026 11:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A1CD6B00D4; Tue, 26 May 2026 11:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF016B00D5; Tue, 26 May 2026 11:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CCB46B00D2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:07:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 143121C1265
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:07:53 +0000 (UTC)
X-FDA: 84809900826.29.CCB48F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6FA2140016
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:07:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GTAatHrP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779808071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6SqJFKinbEr7svW1dQW6jTP27boWm+szW3qKbXBVvW4=;
	b=77PNUWVEZ305yMAqZex6BQc8CVagpiL2zTC7CMFIVjXEhHUxQMZBM8tVyF+nDHXxHAqf9v
	IJhVvogKcOaHGcrDC3pnsxs5tGqOhJ/iBjuP0hhDc7A2AluFUzGu/Q1zVqwTWE5fGry1Vv
	pgQDWXpcO9erJ5m9jR+MpZy61Lw6rBw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GTAatHrP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779808071; a=rsa-sha256;
	cv=none;
	b=DKhuGcQwf7HZRQDirMfOlT6sj6BluNODD6dI8l7/fTff9b9q3X23m4gBCqfYzAsofMB4f6
	35v6MQzYMo+o4qFzPHKUflkgG0Ye8qHVnrSdlRYlDizSd41OlzOnmEhWnPXhbBzNIkox9N
	XL2GbyuN30gHlpnP44fAEbeIDHUlWGc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0E4760123;
	Tue, 26 May 2026 15:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65CC1F00A3A;
	Tue, 26 May 2026 15:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779808070;
	bh=6SqJFKinbEr7svW1dQW6jTP27boWm+szW3qKbXBVvW4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GTAatHrP3iJIl9JT988fS1WFiaKoTnRfabeWG/y+gaP4r6qd54u9cbUuWHelFzedy
	 Erzg6WtrjXYY0epwNZBtAJ9DfB4HJ1857jYJe2pdJE73MObjjqCDlw1AGC78+4p4bk
	 XRvtB27ml/610OAsdiNt/yOKJlEVeX9orF20AumHj84pSol8hcRo1jxS4gaFxBByf2
	 yV39DOZuSt/wKLMVAt+/Pq/2WVZ6M6YmcaNzzi5dtYChYFm7c1olo1ngYtLLKZ3oyG
	 b6g5N9PQuzO90foJu6ndG+tykKwHk2L/y8Zk5U+1MyR9ORt9wePLJWXV+XXzcpgOQK
	 wWd2PFP91pshg==
Date: Tue, 26 May 2026 16:07:45 +0100
From: Will Deacon <will@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vishal Moola <vishal.moola@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, david@kernel.org
Subject: Re: [PATCH] arm64: mm: call pagetable dtor when freeing hot-removed
 page tables
Message-ID: <ahW3QYiYjjVB4Knv@willie-the-truck>
References: <20260521032730.2104017-1-apopple@nvidia.com>
 <20260521153130.d7d5cd060f7522f894252333@linux-foundation.org>
 <ahACfQ6kCfONqz5h@arm.com>
 <ahAjudlB32VbkKbG@fedora>
 <92450154-e1ab-46e4-b23d-eaa59c9cdd3b@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92450154-e1ab-46e4-b23d-eaa59c9cdd3b@arm.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6FA2140016
X-Stat-Signature: 5pq7zsspy1d59facmeu61bdyp49u3njg
X-Rspam-User: 
X-HE-Tag: 1779808071-200078
X-HE-Meta: U2FsdGVkX1+27cRt/35TaTy1rzTUCnhAKLEsVZ6tdoYFRHZwiVaJoTSaa6e6kWXxofQ9LjCKSjxVggiAOfuhN0yH8rEui6+4/bgePjs5VPKwqLwIOouKUS/dgWogTM8xmgAFPE8buM7lb8ievLMKvCWJrk6q8PajSHo2OhPBCPHw9XMNZNxRNh6/Yfz+Bux98sP8ukdcS42dMjMLviyvjKFChAQIQi26kadByBt9OIWe2R3c+LqXlscT4srXwJnyT726Vu10R4qviAOTeOocaI6zBK3VyjxDc1Q0EXBj8HkWvc3OJ0qK+6YHMK0fuVQnhMcVbfps40U81C5CIFqY6Z5vzI3/Ycv7N2kc43rr/OuYiUhyEAFttg3kF99GOZkdjIem7BjhDP5C8JCLz5yOjaCOGh7pOUbjHWwtdDc6mEFVCv3tdRrIKg/c2tDVD2b84KHD6E2x46gCX35S4LQAF0QK28/cBhVaaimXeO6H7HiFbIchutGSw2ZOFoL0ndsjwF5M0w+PjC/zuu+wTy9HIdTEtfklP3t50uBZ3xCmXWxvw6T94lQlUG48snnYCoBIzC6DL/hzmGQt33Xo/R5z59PDSY1eVJYs1PWmqgDDeGep0z2f6IKQHmi6hUwE+m//wP4G2JeHPHqTSI3dVAtPYf2wLq4T++ebbMOPV5e0jHz+XbILfHKCTYh6+l7tc/DvkpP+HrUqh22Arf05vsAFLE8X6J+59UwTvfJnWEkm91BRPoNsFhJ2xen/+W0jpN3qdgFUWNVxnO2dyZPEb51EGG0aSa6plzgDK3w3eEHK4Cy6270dPRGczoCl1lmecbiiSbVPqJ/KELVTsxSZs5je+mJbyCdYUniBiN1hTun8lSfLPTTmDTENmKYPLaA9vZxhvfoc8wPsxgwmNzbYIowJGFzrBKa3YG20+1GbBEGOgNK4fr/W6B00Wy0waimzlRBitV0ROZD7xlWeCOVHC17
 L+I+6qDJ
 +17rPH4Ud2UZcNKp/JNCjoBUs7eepp8Kw+DPuoH6YMQ3YFBXOo6hG0TUalYkLtY/xKp9OB6+RSj4AtW94Lbfy2pAiQrMGWZ7aKjSAuBBCLgqE8O59zww0nio5haiZo4w/sKYfxlWRGAAXpA1A4MMmSy17Ke7bQIj8DF/44h74JIrHljOr8NeB8CWYklkMA+4o6rp6LGTJ5Me89r+bnqkgsck3ik1/PqbAVfMjLtiSdgayvOti1Tbdz7boUiRP74mB/E+Ub8IpUV/edJcpaa0zl3mTWs/jz7sI0ABYolRvVJLaajoTpF5PYz/YqQmHDfPV3f0k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 01:54:00PM +0200, Kevin Brodsky wrote:
> On 22/05/2026 11:36, Vishal Moola wrote:
> >> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> >> index 4c8959153ac4..9d42cbddce27 100644
> >> --- a/arch/arm64/mm/mmu.c
> >> +++ b/arch/arm64/mm/mmu.c
> >> @@ -1441,6 +1441,9 @@ static void free_hotplug_page_range(struct page *page, size_t size,
> >>  
> >>  static void free_hotplug_pgtable_page(struct page *page)
> >>  {
> >> +	if (folio_test_pgtable(page_folio(page)))
> > This should work.
> >
> >> +		pagetable_dtor(page_ptdesc(page));
> >> +
> >>  	free_hotplug_page_range(page, PAGE_SIZE, NULL);
> > In the case we presumably have a page table page (ptdesc) at this
> > point, we should really be freeing it with pagetable_free() as well.
> 
> Agreed, I think this is the right thing to do, something like:
> 
> if (folio_test_pgtable(page_folio(page)))
> pagetable_dtor_free(page_ptdesc(page)); else
> free_hotplug_page_range(page, PAGE_SIZE, NULL);
> 
> 
> Strangely enough x86 calls pagetable_free() in both cases.
> 
> My series protecting page tables with pkeys has a patch [1] to get
> vmemmap to allocate page tables with pagetable_alloc(). The diff above
> will require pagetable_*_ctor() to be called as well, but I think that's
> the right thing to do anyway. That could be posted as a separate series,
> but I'm hesitant due to the lack of NUMA awareness in pagetable_alloc().

I agree that calling the ctor()/dtor() functions consistently is the
cleanest approach and that will need something like your patch to call
the constructor from vmemmap_alloc_block_zero(). Trying to elide these
calls for the page-table pages used to map the altmap just feels odd to
me, as there isn't anything particularly special about them afaik.

Will

