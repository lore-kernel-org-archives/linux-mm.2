Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C739C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 17:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE4656B0088; Tue, 15 Sep 2026 13:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E952D6B008C; Tue, 15 Sep 2026 13:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84CE6B0092; Tue, 15 Sep 2026 13:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2AF26B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:00:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8858A58CC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:00:36 +0000 (UTC)
X-FDA: 85216610472.18.84BF01D
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0BCCAC0009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:00:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Sjxs3Z1A;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789491635;
	b=Gv7msPr9RO4wmRuWtIKQenlFkGDba8gFHW3noPoH7egcttW4JKeJhksww5aVvofEwo4wsO
	0oGeyPxNqXbFbV/nw3TfPEmVcu/fMAwq7GLFZcHh1e1F90i2w0Aprd+C0EV8z0ovnzaOrT
	Er/pS6LKga9BUfGeFmIJECF2QJ6rSvQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Sjxs3Z1A;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789491635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7OHDMKW8AHHfxeSwNE6rmRPVcZ+sv/FI4h4eXB3h1kY=;
	b=fU7td93wdTabt9KXQmU0VMjK+0P8QwLxKgKmmYme2cR9k3rVKagcAu77Ma9bIb30c+LaC/
	/w5XN4hn/HqLGxt2le/QZ8HFIJV7iMZ2A7/d/Fpqfex6jccSFhPpmYwyUw5ngzEjZhiisJ
	FWOwcxxAbdC+sI++ukkZAhViFe18COc=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfcb5cb3so41355536d6.3
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789491634; x=1790096434; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7OHDMKW8AHHfxeSwNE6rmRPVcZ+sv/FI4h4eXB3h1kY=;
        b=Sjxs3Z1A9OLr7NTjQvljQ5I0fEHWQfCky7NOi62R137itcJb60bt0EH+FE/HiAk25B
         RFkcYV648S0GuddxCAJhMT+V7BQMBX53YT6U420K8vfMUZKGAHB42CrKrBnECiHGvuc2
         mOvzdxagpwiLRrzGqa/+9IUj32iM0OZyYd6m8l8SJWmTSYqFWjESHlN92JTPPOCg+yO2
         9nS/LsUZ4t/CNxEZ8ETsGKYUuey7NNf7wiX6AoMPkjIPuXKsjEzI2qYO3IEmw0z6shF6
         UplUaB9UCVYr/PtQJMGKtSxDQYJhJJAIaenRrqGayfWbtA1oa0oBVqQ90eBX8map5bEf
         kpoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789491634; x=1790096434;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7OHDMKW8AHHfxeSwNE6rmRPVcZ+sv/FI4h4eXB3h1kY=;
        b=15fElCe9UkixPMw3RGqCDg2ZtbMji2YdJM6VZdQ1XlHzkGny8q9rwkASO6yYCGGaPF
         75CI3qHfcfwb29i+9EiyeIuyV2Cg3bGEhI9SExyuSiwmmf6dkIUKdcvFya3J9ymUOYmP
         Om9oxKjNBoKSFbOrDHYsF3r4eI95idX3e0CCAMTjmd+SyqajlsHkhbaf1ys0AMDcENBN
         Z619nyLeOCf41PSjnZIPpCM7f6f1Hxl7cuUsgbAPTmzKO0S5SzUpCKZe6uHzMoBhDwmf
         XUQutRfYpA4D9jwe8x0VEtea+cyh8F3tDGwWaIOLm0FGCF9qLhRYsJh7i12AQ06rZXgd
         I5AA==
X-Gm-Message-State: AFuF++mMJN88mVKF6HWGYBmIFKX3Ii/cn0qlfeWi7giHqoujEjWUVgUT
	j1z09m75RlLT0W23RJQ5y5bqF37FnHWykoC8qJovBWtxVOWya7Ugc9qmJVINHjOy4AA=
X-Gm-Gg: AYBFou0RNfHSC86l6fN8OL6hGg3FlGaCLPe58YusYF6yoi3HH7tq1LPzB4Qil0ucc12
	PQxBIvbSMlJSVwzYvofqoAtVtfIBjLcpQ032Tn2FrIJgU6CngNK3aAiU2a1sYbBdGFKo7gtcoc5
	y3DAsmJFLlH2CMkAmdXlU0b+OmmslY6CBCZZ3Tp6G1oR8y2/1CeaahN6j0nMJrzw+1v4BDwMbIL
	9QmiyGRzrP2avbPV06tGlSzwyhmEBbenffQJCbAczUjOFIBMaqGVVdZpWxcNesFX5sOH6x3xUUr
	BxR4L0tcIeHAznbtjIzPmzTRvwq38vuQnn2fY123aAO/gxCju0sU/n+N71v6LO6iHKyZOMVI/zq
	EdX/SEnxVb6tWaercRNPRqxbOoxTq6J1ALEsn0BUfZi9xtL40X1I9URzuYI7dpKFO/pRn/v3Ris
	DmnRQgf4flhA6NZBTaodcXdOBtKGUoTDleFF95LNyAIVKPdn0gdBuSSBCJJ4mQZBgPuG6SjwZtH
	k/5DDFCGG6Mkha6LLr++tTXHZSC4ag8Z2XD/rfLQV6rEDF017sfhNg=
X-Received: by 2002:a05:6214:2e47:b0:910:345a:f453 with SMTP id 6a1803df08f44-9122e65cc6dmr128613806d6.36.1789491633607;
        Tue, 15 Sep 2026 10:00:33 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123bed0aaesm2890416d6.41.2026.09.15.10.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 10:00:33 -0700 (PDT)
Date: Tue, 15 Sep 2026 13:00:31 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, wangjiexun@tinylab.org, sashiko-bot <sashiko-bot@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Message-ID: <aqlzzwLOVT79Ti_7@gourry-fedora-PF4VCD3F>
References: <20260912110832.3203902-1-gourry@gourry.net>
 <aqloB0zm3RjJ47m1@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqloB0zm3RjJ47m1@gremlin>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0BCCAC0009
X-Stat-Signature: 8ehrwrsgd6q9wxxtr63suhp8d8hyb1j8
X-HE-Tag: 1789491634-994261
X-HE-Meta: U2FsdGVkX197Acujn3cXfh95zSaTPh1X5rP1CpuJVUBBcrHmdDP8baDl1J++GyBWsFZK/g4ro9yiRfbr3BQBKqhiHrtRoUSA6QpWDqGQrs04kqBsNB1b2Jw1BjaE0vnOOELz8R4mbWd+PBVXl+kYM+Rx8sYwckpt5qnvwrSdIOt1oj715+u1I7aKAWTL8G0wf49LiiwomKANg8sUK2YvI5VDE+lbP50vgpyVpChjZW525WvZJnfIIS0nWp8JAEKFNuYWjKtRFbQIBHTqhc+7F4L0blw67Amq9uQEe4yi9kFTWc+EukjYRknWI54/cqiCefcj/PuA5QQMBvJZ56ChPV07lfrJKkqgtyq1X7AZ8wqPQWJAE/lXtY5KE4MPf1L/YcIVAoBZCVtU4NVJDkcmSNtcmystCEaK0hxj23tt7hyFhpkYRnsaGHMdj5cMWAAQlogbLA7sI2w1wIEGnYTxXrokVN4R0L2VAdd6uzhNAx/WmclNcaL3W1EClBAcpK713T4Xq1ZwTu2neyb9H4BdniM6r3/2vX/q+UTXCgQOwBrw1y8PQJXsplyvVkmpa3vdIMWRp0vi+R1/VR9c3PdhZSfo2BQaYClz7VEL+C6azXj+C1L/RYamM73WGnFbeqeNOvIBNvhw+9D5Gn0oHCbMUzarolNGzGw0qJwvyWwdx3ENIfFDRcH++v4BdZbHOX+8XVD9c22Urxv9HjmzJ+J9kr+jzTnwuZQ8S/HCvlCA99iSlWTdbj/pifpI/ntgBljwV5F0TI5VgrS0Vceqk7lllb7uc2/VR/uQHr4HAWZtxOBPwY3eZzuKcXTr8wP3Rs/sZprYbO8OhgAE2DE/DvsXsD/DwnRLhYodCd7oulqITidHPO0xpltdb7e5n1/xtYmMRzxjpOM//YYPkDZ7wgjtCTSglcofIJLJMob9TcZQP1mKYxPAOSugY+xViwHd3olWe1qYy1i67AJTW3R1MSx
 G0Cxprll
 fn8ph8I+XZxsN2zSmj97+9eQXpnR3Et32Zc9KrhTRdvn4MXEO1xklxwzsxTbZI/I68ulbaoPJYMdGY2IbGWbAtRH9ZEGZJEhbxkyCaPQaNkDpwLg8KmHjNI9490YzTg5JSuXghWaq2uDdi4nmwkNF6+lkPzx0yKbQL5QX+A0eZgW8JVHkiAOKT/VenZ9cJgHgSmenS96ryIcpbDsls86ldNmtfLYccOgY9YqmoyL6HhOaOa9e8BMQrIQHo4wPwgIje/CcxnjzZU4tkzmyK7kxcapGJqjC178AEY6oiqjJhzSlLI4n8EnHEcNsLkoVjnhIqVoRedWpHTx8Www524A/pBgLTwtYwisqopgTMCsiQvhfnV0wwXVPv+OpZ/xELiOJtcf2hrBZE/zp9RhdulmAkS7r30Oh//E++sNk9iy4FAMTDaoOQh0zudYpC7+a+wALCH0R/QcavXRXOg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 04:55:47PM +0100, Lorenzo Stoakes (ARM) wrote:
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 574aa2bb7c7e..ba5a3d77241a 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -464,7 +464,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
> 
> This function is truly some of the absolute worst code I've read in
> mm. Shocking.
>

relevant meme: https://i.imgur.com/W0N40BK.png

No argument here. This function in particular is really horrendous.

I think i'm now 4 or 5 stacks deep on the "Thanks for fixing a bug, but
while reviewing your fix sashiko found yet another CVE-worthy bug".

I'm convinced (like you below) madvise needs some attention.

> >  restart:
> >  	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
> >  	if (!start_pte)
> > -		return 0;
> > +		goto out;
> >  	flush_tlb_batched_pending(mm);
> >  	lazy_mmu_mode_enable();
> >  	for (; addr < end; pte += nr, addr += nr * PAGE_SIZE) {
> > @@ -568,6 +568,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
> >  			folio_deactivate(folio);
> >  	}
> >
> > +out:
> 
> Seems odd to put this here for a condition that explicitly guarantees
> !start_pte? It should be before the if (pageout) reclaim_pages(...);
> surely?
> 

I wanted to prevent any future use of the label from skipping the
start_pte check.  The function is so bad I was err'ing on the side
of being a bit defensive without making it worse.

I suppose reasonable to say the goto is worse.

> I honestly wonder whether, rather than adding yet another label/goto into this
> absolute bloody mess, whether we should just live with a bit of duplication and do:
> 
> 	if (!start_pte) {
> 		if (pageout)
> 			reclaim_pages(&folio_list);
> 		return 0;
> 	}
> 
> I actually think that'd be clearer at this point than throwing in some more
> indirection.
> 

I'll spin a v2.

> That's for the backport but somebody needs to rework this entire bloody
> function going forwards...

The longer I look at madvise, the more I think it is a wart on mm/
as-written.  A userland-driven page table walker that requires all
the special-casing of Yooj Pages, zone device, swap, soft leafs, a
bunch of tlb flushing 5-tabs deep...

Scary surface.

I've been trying to think about how we might make this more reasonable,
but generalizing the different walkers across mm is pretty hard.

~Gregory

