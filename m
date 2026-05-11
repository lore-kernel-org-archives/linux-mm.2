Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A39F3CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94716B009D; Mon, 11 May 2026 10:27:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6BA46B009E; Mon, 11 May 2026 10:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7E66B00B8; Mon, 11 May 2026 10:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CBAF56B009D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:27:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 669D9C032C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:27:54 +0000 (UTC)
X-FDA: 84755368068.07.691BB70
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 438D8180002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:27:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gZZCDVeO;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778509672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/9AQUhUatyLnDe5uIdhOnIgduBxT6hJS5BrKvyhjsk=;
	b=tXB7/6FrrU/IRwTUil9VxisaajH+AaMBBc3fKwBH6edtA0P2vJ7pwJKaIBZSzy+UqEdlYN
	vt/0A1e0rNwiyOMSM3SVZiS9suJ+D/WI4/Y1CTxUc2Q/jB2rdOAm59jVZZ0nXudtV4ii7L
	yB5M/81YA3Be496BVmgXwFfzpdms7k0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gZZCDVeO;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778509672; a=rsa-sha256;
	cv=none;
	b=YFrF1DNg8qz9S6k1Ntk0QqZViBnxsv45Sv7/2avol+976MHoX8GB6v0qijwS0DhtMjLy81
	M14kEvzsK80DHyaIC0EDNmmS9xh7/mQEZMObXPWGvJ1Tt69wr/wgviZizRXQOIQHGyQk0v
	z/7NFhczi9DOFeUW7ePn6w1P3yzxTkA=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50fae4d1f85so51755991cf.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 07:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778509671; x=1779114471; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R/9AQUhUatyLnDe5uIdhOnIgduBxT6hJS5BrKvyhjsk=;
        b=gZZCDVeOE6GmmaaxkgY+bjKIvHelqWgEvniU+B7P7tcmL8b4nQl0A3PH+QEyhgiTlG
         SxnQvYTPlcEpNzZaTb6bpjQaQ821oP4zhgv8L6dlOCVxiy4Y2Klti+bPFp9Oy+LYzkAW
         npNVFFdvi+HQa2OwgHvErOFbLxm6KMcPosQZfk7iXDxkMAUbMMaFNFAxyMzCjM0KHSdt
         8K/VHXw1bT0rVJyHZQCRFUDMxHKERz+xJ3QotM3eAV8PvwkZbp4FVSRLQ2SVtvT2gV5i
         av1uErsRMbsuYdT17774CdFcnrdniASyeAzDDcYLT4PxWbXtkxU7D4i9Iy2/WtdMM2Lj
         y6SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778509671; x=1779114471;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R/9AQUhUatyLnDe5uIdhOnIgduBxT6hJS5BrKvyhjsk=;
        b=nFBG+Hpfb6DH+yqzIgYOJy2m3yeeXC9LcKo0PeQdTjzjy2T2KO3sr3X15uNXiz1psg
         df3+gnl5nDBR0xpNWZyqlArKQ/34Y8URwr8oc9X163+V3K+Iy31QS0typOoPOPUgKfwO
         rpoWdHMspCictfKTMOHAtpJaDCy+ymS8SU4lqwUjKBvxKGwpKDtF6xbBsArQW9NEvRRe
         phOl5BkaRrl9vKMk5Qkwx8EKnSImVRqRiAi1/vcpWBp5sZ+tK49gVVT+HGvhszNSMy6F
         TEYd+Nn45bgDzjoQlgWm6xxXKAqKtabNoQ2JIw8RdXNMWrMit7qnjEE72SzG8waeeAGb
         Om8A==
X-Forwarded-Encrypted: i=1; AFNElJ/27vq1jf08nlVwfYRP0v8iBYD2w4bPoIb/rMiNlYJtAWOCA+fTR6owzGQzlhIBb0XVSjIIdBv3VA==@kvack.org
X-Gm-Message-State: AOJu0YyKFu2NN+phHGTK5Eukuu2/7T9UROAVJ6aZI2akwvo44ecK7sWO
	ihdgMk7nQ5PIwcz9fo6HE+vo+O1L28aQtu9k79dgm/UfzqxxDWlg0N3CAqF2WxVkDOE=
X-Gm-Gg: Acq92OHBl858VOiIXyuyZ8NxO7o+8zC6vqXo3K1eMlho+OOTslgjGtsQxcxHhhkL7jh
	cnXlHVvn9UC0mzuDu31kgAR2RPwatx6s93JuTSEL6BzY0ADRGV3CxAN8XVC0iDIoE/5W2K08IAC
	2dm2D3dDtTN2Fb3JTZu2PAYdtFOHwGs2jTxCTVb2t3ikC2Z9cCo6hCTOYJ1/UNip3NNDoMYsqkb
	x0eYyeuG5nUktf8UMCCt89mb9YAlbiZ/ZsGug0qBrQxXS0hy0ByqCXmjTZXxd3mn98MmFwvsVpF
	F5tb9D5Whu7FGklWDgjQV3nzdCtQ8hAGRACuJEv0EzGSXwAYzdcHVVjW4Z4jy4OFP9iY1bZEJp9
	fk7HYrCALOepSnHiqen1TdC1+2Kthe3ABPLtLC1iJWyKipA8a+L9uygUbIJda4KENa2L46PpdD3
	axsbFVPaQTZ8mlaybsWqMnzqeI0l4GvL/YN911ggEGfVcTmb7vSFPT7uRfPI5Yuiwqf/vPx1XeU
	OsEHb5CHzz6
X-Received: by 2002:a05:622a:1907:b0:50d:af3a:d8ed with SMTP id d75a77b69052e-51461fcd2dcmr347757881cf.41.1778509671015;
        Mon, 11 May 2026 07:27:51 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5148e82579fsm89645911cf.24.2026.05.11.07.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 07:27:50 -0700 (PDT)
Date: Mon, 11 May 2026 10:27:46 -0400
From: Gregory Price <gourry@gourry.net>
To: Bharata B Rao <bharata@amd.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Jonathan.Cameron@huawei.com,
	dave.hansen@intel.com, mgorman@techsingularity.net,
	mingo@redhat.com, peterz@infradead.org, raghavendra.kt@amd.com,
	riel@surriel.com, rientjes@google.com, sj@kernel.org,
	weixugc@google.com, ying.huang@linux.alibaba.com, ziy@nvidia.com,
	dave@stgolabs.net, nifan.cxl@gmail.com, xuezhengchu@huawei.com,
	yiannis@zptcorp.com, akpm@linux-foundation.org, david@kernel.org,
	byungchul@sk.com, kinseyho@google.com, joshua.hahnjy@gmail.com,
	yuanchu@google.com, balbirs@nvidia.com, alok.rathore@samsung.com,
	shivankg@amd.com, donettom@linux.ibm.com
Subject: Re: [PATCH v7 0/7] mm: Hot page tracking and promotion infrastructure
Message-ID: <agHnYo_yvyXHBtTJ@gourry-fedora-PF4VCD3F>
References: <20260504060924.344313-1-bharata@amd.com>
 <afkDNR9yVRjire4T@casper.infradead.org>
 <aftcuvXzHSywFL8g@gourry-fedora-PF4VCD3F>
 <c2b63544-d5da-4fc8-88cc-487de0a9a71e@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2b63544-d5da-4fc8-88cc-487de0a9a71e@amd.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 438D8180002
X-Rspam-User: 
X-Stat-Signature: heaxg8eh1qb1nrbrd8byzy9iawti3qgy
X-HE-Tag: 1778509672-508421
X-HE-Meta: U2FsdGVkX18tzB85Hdmzu4fSEgTjCusjzMWRJNhICdSjs2i1jQAD40INaQ8/qRoiuxPo1Qy+0b19xZj6et6Qc3eDthzGSlct2bRhS8O0LFg/u8s4xHRUIjO1tp9R/a5/CsbSVO6EUTTZQcM86usHZw7AUH/aQgu8DmojIL0HdAeDycrH2o9SukyZs0kT4vjOdRZYDKwqyiySbd2muvLHyucFgYUIg/3eRshj46rA2TSJPEkQUdROIlN9RJ6y8T+PeMfhseH0vNKoJK2DYPivdyh8w/dcwBeN/EfOImQENDAtRgGKWdAXDnFF5mtQ9j32fHeEXVjCxbGEq1DO0C+ZMUzgC9zM9xm7KsuK9hBEP18k4c0blQn5sme3jd+3auI/YOpBA3UHEoZDihITZZjQCKl/B57xQo8QDybArI1fZMvwCwwhb41w+6p8u2rws1B3lk/mO9XYTmgUpXB6Xiy9pP8S1DoXm08xBU0E1V319lFnXgwqsJKNjAmIgvrnXYOlHvDr3q6vU9z04t4+oqTjHvM95ndpaezvOwp8lQNLYCRXt+KquRdUGThcBEBk9lt/ACC9yrA+AY4pFzjLot7odBbWFNARH8DcURGTHlGDWDEYj1MkLapthC/06HtbYezgG0VcAkh0bnsRlhhaxc3tV3yoONkJ4eIhDl/STrYk4tOaB7aZdu8hkkH3fpeSBnLRzFfYEOjDM7rz0Lo6RBD/GWiDs2dFRG1BJzc4g1qt+81WbovGKLDY30TOlr0P6mLpRIO5VBJwl4N7kUQkSFL1dR1haH/ecE7ghdJRIeOvr1cCXOr7onrePDNyhbvGRG7jxuJDBex8m3u2BLzm4xLKJXyDEzKx+BwarXITCKtEfbjM4vGwpEUI4x0Tg5WlhH8G6y0K3GXxVdgavyQrKpRXq3/4wzWIBnMeApDoARBWjA2V39z68CKp1ctSNzy6Gogt/+egpBUlmwKrPzltlvn
 rWTavjAe
 1SyEscrL0FFgAB1kENItZIQJWiIiprskNcrAxx7CjXoxQhwUy7jf4jfOjE2DcWKDrlG6xtG+kkI0cD6OEfgIW0lEOTPxdBGKgiSq7dYND4J+ElcY/mXLPrVKEHKQ8ao6/ThLwk+3lvqCza1YUoFxeQpXEFLsEtHInen9P/JC3Z+SFefctaRqG+QdyUn4m8B6/MpovvYs5gZmUsDgZ/XoQirIEte6ppu81rTvHFHbYT7UPp/iAZLqTTCqLK2YQgxLdcdYx5dBNrQwxlgO/YYqCQzg0f7csrO/wjGO+2hURYZNbgVcPX24NoFuLbAW3rhj0H9wsUJH76TOTGYdFipBc2I0zwAd9/ekI0q7nmvB7N0ZXn2RSStJFePNVKhbT2yIFtDofKQaM/hiLhF6rqWJYJyDmDgiepxgw9MMh27Z7fFA7MQCJVKp3R16Ykoo3h2qGYVjBDDoR39s1y+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 03:32:20PM +0530, Bharata B Rao wrote:
> 
> 
> On 06-May-26 8:52 PM, Gregory Price wrote:
> > On Mon, May 04, 2026 at 09:36:05PM +0100, Matthew Wilcox wrote:
> >> On Mon, May 04, 2026 at 11:39:17AM +0530, Bharata B Rao wrote:
> >>> This is v7 of pghot, a hot-page tracking and promotion subsystem. The
> >>
> >> I continue to think we should not do this.
> > 
> > My only pushback on the general "we should not do this" is that we need
> > something to counter-balance the demotion bit in vmscan.c, and the
> > current implementation (prot_none faults) is rather :[
> 
> So you are saying pghot subsystem currently does hot page detection and
> promotion only, which is fine. But the current implementation of demotion is not
> very optimal and hence we should spend effort in fine-tuning demotion first?
>

I'm saying because of demotion and fallbacks, we need a mechanism to
handle promotions.  I'm not convinced a hotness will extend to coldness
- at least any better than LRU/MGLRU.

> In this series itself I have shown via benchmark numbers that for over-committed
> cases (involving both demotion and promotion), the workload isn't really showing
> real benefit due to demotion and promotion. Are you specifically referring to
> this problem?
> 

If over-committed means over-subscribed hot-tier (more hot memory than
available top tier memory), then yeah that result is intuitive.  I
haven't pointed to any specific issue, as of yet, still taking time to
consider some of the results.

> 
> Can you provide more context about the LRU inversion problem?
> 

I've been tracking some data around shrink_folio_list and
alloc_migrate_folio behavior when a low tier node is full.

The result is we end up just swapping memory from high tier straight to
swap and skip demotion, resulting in a bunch of file and anon refaults.

Hardware: Single Socket, 768GB DRAM, 256GB CXL Expander

In this workload, we see swap usage after the full 1TB of memory is
utilized, and as a result we see swap spillage.

second_chance = second alloc attempt in alloc_migrate_folio succeeds
swap_fallback = second chance fails, we swap directly from top tier

Sample data:

pgdemote_kswapd           333052779
pgdemote_direct          3181480482
pgdemote_second_chance     31017629
pgdemote_swap_fallback    335759535
workingset_refault_anon    30106868
workingset_refault_file  2343035341

(note here: swap fallback is number of occurances, while the others are
 number of pages.  As a result, the actual number of swapped pages is
 likely much closer to the pgdemote_direct number)

As a result:  LRU is just broken on CXL systems, LRU inverts by design.

In a sane world we would just see the second tier as an extention of the
LRU, but that doesn't necessarily mean we can gleen hotness data from it
(it's still largely a coldness tracking mechanism).

I have patches I haven't RFC'd yet that try to address this, but I need
more time to test it.

I don't think this is something to address with PGHot.

---

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 112983b42559..ccdd698c5937 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1043,7 +1043,10 @@ struct folio *alloc_migrate_folio(struct folio *src, unsigned long private)
        mtc->gfp_mask &= ~__GFP_THISNODE;
        mtc->nmask = allowed_mask;

-       return alloc_migration_target(src, (unsigned long)mtc);
+       dst = alloc_migration_target(src, (unsigned long)mtc);
+       if (dst)
+               count_vm_events(PGDEMOTE_SECOND_CHANCE, folio_nr_pages(src));
+       return dst;
 }

 /*
@@ -1616,6 +1619,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
        /* Folios that could not be demoted are still in @demote_folios */
        if (!list_empty(&demote_folios)) {
                /* Folios which weren't demoted go back on @folio_list */
+               if (!sc->proactive)
+                       count_vm_event(PGDEMOTE_SWAP_FALLBACK);
                list_splice_init(&demote_folios, folio_list);

                /*


