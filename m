Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 650E4CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FDA46B0093; Thu, 11 Jun 2026 09:57:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AEFC6B0095; Thu, 11 Jun 2026 09:57:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C49D6B0096; Thu, 11 Jun 2026 09:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5636B0093
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:57:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28224163F9E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:57:44 +0000 (UTC)
X-FDA: 84867784848.27.1A60969
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id E2D67140011
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:57:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=epd8d+AQ;
	spf=pass (imf26.hostedemail.com: domain of ptesarik@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781186262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELiU8L1X2MD/8T2htcnXW//tl1+DcLq0oF7UnsGSTfA=;
	b=u1uaAMVCVrSxciKyPyKY3CY38yGcPEKWAvgzsJpmxgHbNckikBj3z8Vu9qJa5cJgrmX1gx
	UzfD1LYq/mLwWZlvIxiFJt3cKDNYZJ26Uz6VnsLWQZx9bjm6ewP8QZBM5XQ1NhDJBsN5in
	tH6A/K0fDUNw2S8M+6DOiGKe7l2QwXw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=epd8d+AQ;
	spf=pass (imf26.hostedemail.com: domain of ptesarik@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=ptesarik@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781186262;
	b=SjILr69xk2BiQ472HfKoD7LL0a0RfnuSs1BndWEgrmT/+r5QWFhEPqjCs0XvhE5zY+gUvG
	XUNKGKHwdflUGFMURBCxGxaovnmNTddhZvGr7+H2LNc18MvoqgJjI/Irpaf267b87x2BUR
	lGTCHQyDLb1lZLIALKecyVvX7Bfixfw=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-490a7629453so6959215e9.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781186260; x=1781791060; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ELiU8L1X2MD/8T2htcnXW//tl1+DcLq0oF7UnsGSTfA=;
        b=epd8d+AQ8bMxXvxzX3EGPvCj4eO4WBSvXYK/ea2TRR6C2pHa0e1on9G/8EHwxwnYPD
         Syxs3VaZt2D8dNBZPQkpx1wdx8ry4lj7SmREN9sh17Tynes6qSU98PJbNRhY+yScpXN6
         2BWN6mK/EngmrhAjNyjBMzJiGWXVXej/LpuSpQt36d1JHaKCDQdNC53yrA8PvURXusAI
         jN7k1tYQM6S+Q423KEug584yfw8Ag/RIzvN65znyTnvINLug01IiK9v2IO47Svkmoa4z
         Vqqaq4Z0xSGTmPazDtjfC4spdAF3NXLSELHhMCkNmdNANhsfqeOKFd1hb9fAQer/p35C
         2R6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781186260; x=1781791060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ELiU8L1X2MD/8T2htcnXW//tl1+DcLq0oF7UnsGSTfA=;
        b=XB7zNEKDpIvuDGPx+q23SUWINtb8XtkejFRDHyj6uQSYW+ZPbCHimBnL1VZapva8Z2
         JYCmhTHYsyDIAlq/59tYiVSXsSCBJqDDfz62eDKepNyGS3/1m082TaKUfuBVTarEXTWs
         J7psieBQb/aZ7cJ9RRMIsT0egn4NfJi7L8Itfy5UtoT8FofIwMBk4uxVQGVOAewwLPih
         fLV6Wrat23kC1RZvxtU+C2xVLOPfRUU+IVwUTW86A4+h3EPoIsfQnHloRkoDiMFJToRx
         jWBW8hmCqFo+rB45IRwiJ5EFNadfOykdY8AODMsB9KbW/WUYX6LKMUReboHMkm6uj6Ea
         HXRw==
X-Forwarded-Encrypted: i=1; AFNElJ94GYboV0vgpPd3HE6jP5f/nteeQytY3qKyUCxteMNrsW5dowuZsiiXFn8dpX6N8YPDCAMG7uxB2g==@kvack.org
X-Gm-Message-State: AOJu0YyIXtJgrylic71FC7BMwFeY3qFji0Msu2ayD6MHfJ5YD/9obP3S
	WoyzIJHGEVmSlVHN/BeLPnsrtW1X8gkPskjcSEr+odytLPDIXP+qlsiQphoveCfQAB4=
X-Gm-Gg: Acq92OHMgLP8M4Z3NMiZ80EGL5xHoosxUPjnGnwFRrD30lat8eQBXAdYau4KvQFVbfJ
	V5AfmyZ3SFu18B777s7blGA/HK3HGh6En68/nVBOjm8XXVwzjRC/C8USmIqkcVFH7J+ZHQqzcDb
	kujCekU5c3qkZGOezVNIdyNNEBS867GcmN0V0toPOzY2QWonty8Tk+DKs2VLxKJbpTMPOyYrDGl
	xKrOL95H8GMW5H+GQ2eET6SIXGqq+0hMMU5uzLtTBO2TftO+/V2O2Ii6gBoqxxdXoYdb+Ajn+zm
	RHdxlU/b4SEXknen/7wI0Ht+JfVENuTvK8lLsBeNujlQzfWjOyPPvSx1Oy5cDZzACG9G5tquQXk
	2wEZrim8Rwc1OZ7aUA7BJh/rqNr0Y7eW4CL0HrpQOpcur6jNSFXRMYDekV59F6CHK2wBNMgkCjI
	u3Jhi5NJ7eh3OHVwMx06hZ77V97/r3cSo5y/lNBWIBEfUd69sJlpaRYxW3X0orsmOvDZ/7YeAUy
	qcsK+DrwwNWbOO4wT+Pw0MLHCE=
X-Received: by 2002:a7b:c04b:0:b0:490:b71f:2eb with SMTP id 5b1f17b1804b1-490e5612c5dmr13380695e9.7.1781186260306;
        Thu, 11 Jun 2026 06:57:40 -0700 (PDT)
Received: from mordecai (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2c907ddsm67156685e9.6.2026.06.11.06.57.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 06:57:39 -0700 (PDT)
Date: Thu, 11 Jun 2026 15:57:36 +0200
From: Petr Tesarik <ptesarik@suse.com>
To: "Brendan Jackman" <brendan.jackman@linux.dev>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, <linux-mm@kvack.org>, "Brendan Jackman"
 <jackmanb@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan"
 <ziy@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] mm: remove NODE_RECLAIM_xxx macros
Message-ID: <20260611155736.72613cf5@mordecai>
In-Reply-To: <DJ69AE1CHPJC.3H4BPJUL9YYOV@linux.dev>
References: <20260611124501.1465806-1-ptesarik@suse.com>
	<DJ69AE1CHPJC.3H4BPJUL9YYOV@linux.dev>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E2D67140011
X-Stat-Signature: 9c1zirzaddgeaehbmniz6pdk7nfes9dc
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781186261-931806
X-HE-Meta: U2FsdGVkX18+61Ms92ht7KJjNGiqFAclxXQMfdHd/Be/8U2oSigjrIcJ5t3rDuTpeclgkSUdbxaOZu3EYg2VhblQOcLvggpQy3YIgeGp6/Xh3GHTkjoaSYQSyxLzLyvuvD+FbTgcbjVczTkZFpoZrSkh7Foy1LETGbWwSfaxSEg8x+gi8RuH6uripw3HW0cFVWLihzcBqIIxDM+l+hnyjLCg8mumAsUK5gtn5bYv+Ufj6aTBsZybaXEl4UUAQ+pISU57GR4CnrlZMV65a5W9o/00JskdLGuD892LLb02ZAcGrCa+tWG8rnWYJiQPGP/AS4ny+WXE0vkHSiADwrAPEty0RN1glA82alIs3i28tQ5r/weepG5Iythi59iFSL6jrmstj9kfxOJhtbpWOdyhED4jeQ5ighfBaRZcI/nLTv9gV2xgxDH8RDNG8lJa1nx5auvonvx8SlorCsWPh0BfElbfnrehxqQ6SVcOeCA8ZWdSEIffW4UKvSKrd0q5UURQFBwVrCojXh0j7VMNADqN9jOq6d5BeepIVtXzvEFl6WbucUXFxlGiP6AdLUlDCYy5AmqxL3ku40uArKrJwpEoyPzw6cW4kk8gzEfjcKgDuhrHX8jvIVtvO09pJKF91zx8myPzriQs2FbAKYN52SiqRHpwq78DyElO6bG5PjBhfCSy1vcX1tTb2ygmI+tEf/j6mmMdW6WqHEowBMl8NiwvVLPP1JR/auF7U/L4VWsSubh3rxsmLxDsoExNDYr0tuqGMXIQVayeRxr3eSkwIMEu6hXDjgXkR47Sr6aT/AfA7mmHI6Z0JcdP9B7db+/VCsIWIOrBUJgJpL3QxseUiIlS1eNtgS0pKpuot1OqWxaZ8krcZV3yS8VeKYDhHByCNDNoRX376WHK0eRi2e1l/YMl1E0PFxqf3FqXrytr0JErKhG2OzHYoIgH1uNYEywFgMuujBDLgu/E1SnHlSuhvk6
 uLGMpHbP
 2sNY+F5klHJhmej3yuEbav//SSKaA1h27nkpt8FaEWoaSv8odLbhdjW3SeZiG2m8gcc4G7HpyB0ZQQo9brnPJcN8hsyAnHKx8yBeVcyv2GLzL9EZg6QYToeD7n70Iu25uQe4FApn1ZOnxLiuGoSVKqeaiRFRy/oKppM4PSqWUBNL2Mzv5r8lOsdX7XannwLAGSf1BMqNfPmCMfK/U/76WXrVU8CdynrddTQBymShqQWGMkyLT2lcKONt2zZR1r71wXWWlKS9qLHXGB4y6L5zv7za9NMuM/COFJWVTJmY9gWNNVWImcug0hBGINzbXezyw4KZPjRUVstOPImllQOzqbppUMZcecTYzyQw5eVI6TuxqX6iFvrE10VnhJ1dgoJpjtjT19/m/qmPeH39q/QjbkqY04OZzVzJcwGLlivmAXWJozn1VRbpP54inmrHj4wDd3Q1Mn+Ii76UeQkA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Jun 2026 13:32:04 +0000
"Brendan Jackman" <brendan.jackman@linux.dev> wrote:

> On Thu Jun 11, 2026 at 12:45 PM UTC, Petr Tesarik wrote:
> > Change node_reclaim() to return a bool indicating whether any
> > pages have been reclaimed, because that's the only information
> > needed by the only caller, get_page_from_freelist().
> >
> > Originally, I wanted to convert the preprocessor macros to an
> > enum, but I couldn't find any explicit use of NODE_RECLAIM_SOME
> > and NODE_RECLAIM_SUCCESS. That's because they are typecast from
> > a bool.   
> 
> I'm slightly confused by the "typecast from a bool" thing - nr_reclaim
> returns nr_reclaimed and then node_reclaim()'s caller gets that value
> directly - is that what you're referring to?

My fault. Without my patch, the return value is calculated as follows:

ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >= nr_pages

The result type of a relational operator is an int, not a bool; and
since I'm introducing a bool type elsewhere, no wonder you are confused.

I can improve the commit message in a v2 if necessay.

> > This seemed a bit fragile,   
> 
> .. Which, yeah, is awkward, thanks for fixing it.

No problem.

Petr T

> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 3f3ff25e561ac..64f6b649eeac1 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -7786,9 +7786,9 @@ static unsigned long __node_reclaim(struct
> > pglist_data *pgdat, gfp_t gfp_mask, return sc->nr_reclaimed;
> >  }
> >  
> > -int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
> > unsigned int order) +bool node_reclaim(struct pglist_data *pgdat,
> > gfp_t gfp_mask, unsigned int order)  
> 
> I really dislike returning bools with no obvious polarity. Personally
> I would keep NODE_RECLAIM_*, (optionally convert to an enum), move the
> comments to the definition of the NODE_RECLAIM_ thingies instead of
> get_page_from_freelist(), and fix node_reclaim() to return
> NODE_RECLAIM_{SUCCESS,SOME} expliticly.
> 
> I realise this philosophy is not favourable to concision though, I
> won't die on that hill but could we at least get a comment on
> node_reclaim()'s defintion...
> 
> 
> > -			ret = node_reclaim(zone->zone_pgdat,
> > gfp_mask, order);
> > -			switch (ret) {
> > -			case NODE_RECLAIM_NOSCAN:
> > -				/* did not scan */
> > -				continue;
> > -			case NODE_RECLAIM_FULL:
> > -				/* scanned but unreclaimable */
> > +			if (!node_reclaim(zone->zone_pgdat,
> > gfp_mask, order)) continue;
> > -			default:
> > -				/* did we reclaim enough */
> > -				if (zone_watermark_ok(zone, order,
> > mark,
> > -					ac->highest_zoneidx,
> > alloc_flags))
> > -					goto try_this_zone;
> >  
> > +			/* did we reclaim enough */
> > +			if (!zone_watermark_ok(zone, order, mark,
> > +
> > ac->highest_zoneidx, alloc_flags)) continue;
> > -			}
> >  		}  
> 
> ... or keep the intermediate variable and do:
> 
> 	bool reclaimed_some = node_reclaim(...):
> 
> Since then the variable name at least tells you what you're looking at
> without needing to jump into the function implementation.


