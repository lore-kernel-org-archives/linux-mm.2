Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 730CCFF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFF346B0088; Wed, 29 Apr 2026 09:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAFD66B008A; Wed, 29 Apr 2026 09:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F336B008C; Wed, 29 Apr 2026 09:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 92DC26B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:03:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 302991C01D9
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:03:18 +0000 (UTC)
X-FDA: 84711609276.05.CDA6028
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5DDA9C0026
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:03:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eJnojmWi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3kgHyaQsKCLMchhgphgdTgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--joonwonkang.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3kgHyaQsKCLMchhgphgdTgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--joonwonkang.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777467796; a=rsa-sha256;
	cv=none;
	b=4UQhoTKYDsq31VzZarb/iNZK4iB5cJeMRhEsqSVxUmd/S04yW/JFYsUqtjORrsCBkmJbCe
	4tQebZ8uOgFEgOiGcepfqEB/D3it8IEWA57x9hzPyPHJPpECnzBPnmlBfsfIQhfcv2oQEa
	FqiQyiClHyi7WFLXOq6R6GCgQX0j6zI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eJnojmWi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3kgHyaQsKCLMchhgphgdTgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--joonwonkang.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3kgHyaQsKCLMchhgphgdTgZZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--joonwonkang.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777467796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lBkLeOGUAHoVLnjz8sOE6ZNCHGSpvXGjgM37tA68iII=;
	b=N+neqWjYPJEXQEwiWsRqxwVKEVR3YdiytiX9a9gm6APmD+XEPNCUcLnZn+RuiDobxHs38C
	L4i3CeJMsqkLyz3dSS2MdABpoEn4qBjPlFx5VKyEPxMuCdHTUiNWT1Gkc4Ny44Ie/Am9Xd
	vOIDQGTZj2ML3Lp3BQPZqLCDY+cuJPY=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c7948640854so6602388a12.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777467795; x=1778072595; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lBkLeOGUAHoVLnjz8sOE6ZNCHGSpvXGjgM37tA68iII=;
        b=eJnojmWiNbNZ1DpqdRISffgENGldq52s6YDQX3JDxX4XU1faEg48kE2bD/d+ncFceu
         /x3SkmkaI7rP+q1YVA7BmVePVQyFCZl9IHK12mOBKCo7ErxKDY9KsnCJd8VuKTFonGnm
         LwENVR2Fynq5IKC3Q2VqOEKy1ytXWi6IobXfx0zJ8QN6fUhJ/cz3oENPXEPjZxZ0bCG3
         3+hmNZQFRplvEymt+cful1F9hS61Orn2/OfgFVLNkS+TmZG8aux6AXNviMc+h7LkS+B2
         V5YrSimvqFxYPcgQA1dqf/GBlSw5c07Pv9unFKcARqycPQP9gdxIMzPgNY5oCh2aaFbF
         9sKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777467795; x=1778072595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lBkLeOGUAHoVLnjz8sOE6ZNCHGSpvXGjgM37tA68iII=;
        b=r8u72+gdG/Ih5AAQGsLwTvoZTN8qaFFcj38HjK4xY1qCx09kGdUTOwujP3laYrfr1C
         nvKCTjbr03D0rkLwvdosjlrMiLbXGJ4camUzMj5EisXnXhPZRJR8NRa/krnAndy9P+dp
         GEBJq8pZd3xXvIiK34/Wn3oMUHN0OTzLZpaWYZUWZ6n+0pedbeGsh1c/SqWbV4O6mU7/
         /vIksmsQGSSc7eg5X+r5i0yjor1bR2Y7z45riU1/g8LOA+OqtoEKFPLaP4qzB6TuKHDc
         R5tcZJzmzTDcBkzUxdbgHSM+9QMan75C97hdxuQxYTdcvFczw2JdbDS/SWAsx+FUb+Py
         u2/Q==
X-Forwarded-Encrypted: i=1; AFNElJ+2706g9+BxXCJRzoATZiM6MQPWUAzF2Z5lc+65nmsb2OEENochffUx6qmLL5QBayFOzVg5RF2C8A==@kvack.org
X-Gm-Message-State: AOJu0YwUpBS1QzMEuhAYcUYC0z1L4rc0j5EWKSCiWCDCAe7zZ+MlKf5n
	P1BeYc1t27GrftfxNaI4sQ33Q+6qImKAdl8B8n5jTin27QYfhg5pqCGr/6GxbcZ/q//J1hY/t54
	FHtNuWrWZZFCSfYq5diCs1VZyZA==
X-Received: from pgll67.prod.google.com ([2002:a63:2546:0:b0:c6d:c043:2cb4])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7350:b0:3a2:d316:de52 with SMTP id adf61e73a8af0-3a3af54183fmr4098929637.31.1777467794680;
 Wed, 29 Apr 2026 06:03:14 -0700 (PDT)
Date: Wed, 29 Apr 2026 13:03:13 +0000
In-Reply-To: <aegIOh-cC03ZNRPh@palisades.local>
Mime-Version: 1.0
References: <aegIOh-cC03ZNRPh@palisades.local>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260429130313.2318006-1-joonwonkang@google.com>
Subject: Re: [PATCH v3 2/3] percpu: Do not trust hint starts when they are not set
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org
Cc: akpm@linux-foundation.org, cl@gentwo.org, dodam@google.com, 
	joonwonkang@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: fatdsg8qi8zhdbhcq5zj4abhf1dbmpf3
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DDA9C0026
X-Rspamd-Server: rspam07
X-HE-Tag: 1777467796-590017
X-HE-Meta: U2FsdGVkX187t2tGRpdi39SlPJnGXs+g08GfOS9VQO53rfFlv2hKPyk4VmldUXjHU26M8pDx6bUsUZ6duuzk+hP05xfy2Kn5EXJ03/Zmczm7HxP87sB6C7/SbT9glqP8xVeSPq4umP5w4nPCducBf1iilcJnxkmBQaOG7kTxdyX13mevH7kmNl2zoa+gcsIwunQk1utlq8k6iJROA5RL8x9naU+aM9yBxKdLKbj8PEJhKn0QB2CidJ0O1IZyVoMnnHQv2K1ThgAJwvQ/wf0U6PmiyCiGTCqKpvwLYvD0p3/oqRGP7kqGwNTZr7kwB2JX4jKwHK8ZLfAQ+oesyev3RYF9OrbHLON30JkRsZDSoEZKqlEId933h3YXoy8x2j6rzXUa1jjYZ/KBBRODEN4ifsgK+CkTKC2nU/trqc1egm9nOGXXTUDD/gmQ+p+WGKEJtLmEQWKhs5psG6PY9M9oTJY3qkPHTf48KD1elxnJYvlXQhZebd/dMwdTGLUOwkP/7BcB3kPGIbX+mZ3PuKhNVxJpFnvIiUcENjopr4QgbPD0AXLCsnrfboKm9minZRjTs3B7POKG6fwkAJgkzp1/OZrah2WhuG186+Yel7ZSCrEROWQ2+x097plF5QzEzL7k52zs7l8gG5bJeDHZpmA0Yhax4jxUSswbYdUUhGMmOQJQKohSVgQy5mIcZM1CDWiY00ilxn479TitglJJ3jUQmrwAiy46SVH/+ecOGNQsgYLdyyXUvnV+hGrNnaoZLOtKDYApKTZHthSgsBVXaW0Wqgx/N1v3TXeBWme0VIMH3G4bEzn+RFxojdi2j4qhSdAKU3s07abT4g1C1B/184fnq01OYovNZoHmoXN08sJl2lugvQLkfn+JE8xBQZ1ZmkzNgGvGvLxh27Ru86roMZh+ivhGRLZeMO8hvv6Vz3hyCG9eWTR/o0SELsTAQ71vCN/dReNc51w8NhV2Q4IyXbx
 D6kQRG7s
 QM9+Pt6gGj2Ep2KrGZfoLdewrQ+gGcMk1m5z6MJhp9M/CEa4yM0ZTayAYbMy6qobIZ2Tzg5vFSKN2fmrjWQfJB6HPOEN+O2mTM0gyK8Wa5pvbwV6y1F6NhRNUna1WG/mEoqJfo7pZHGES/dRtnvlYoF0M2pJcJYP/rLDHXdrQjSXBXdP8dn+Ae/6SOC3hig6emP+HIMixpn1Klq08BRhy/fjRaAB883taxG1RtTs7YZVlwyYunkYlKzpaxH+4aFhxC2uxzgCufDW22wev0YiK30tu9SCXeVPv4OSkxv/4OYpXKz1ew/Vw2xjXE3PRFyn3RSrreOegYBI2OKJXPuEATPUtxRryN49bwssrzrfLnZfYwtf3508LFOc4nlFMS0na3jH52T8Cd7ZJRRpEHoUhX9OO/WFfQE/KkuDAW415lugr8b3dLU2NMTBNaG3vPEKjgRLM9+qdtFVz3boVTw3b3qsbR+AaMiRAc071IwMkIsdQ03bV4JXyIXZkPrD1ffqzR3L2ZbNVTdQoTtRvkH0DRhx5KYtkVVh5lhLyx4w9Vp9S+xC+Wdv9yQErM7dr+mqZwMuE1eVFRLVUu1wvKcWOiy1X4PXB3g4B2r4P+kOHA7ghZk3lRWvlXnDOkigPsGcKkeBtYJv7bR47bkx4ZQmpZj/Uie/KJrMQ9IrnvTT/n6JNutHdallqSMXLv+hyMNVZjbPn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, I am sorry for the late response. I was occupied by other issues lately.

> On Fri, Apr 10, 2026 at 05:44:16PM +0000, Joonwon Kang wrote:
> > contig_hint_start can be trusted outside the hint update function since
> > it will be updated everytime contig_hint is broken. On the other hand,
> > scan_hint_start might still be invalid anywhere in the code due to the
> > broken scan_hint not being updated promptly. If those starts are trusted
> > when they are not set, it could lead to false invalidation or update of
> > the hints.
> > 
> > Signed-off-by: Joonwon Kang <joonwonkang@google.com>
> > ---
> > v3: Initial version.
> > 
> >  mm/percpu.c | 15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mm/percpu.c b/mm/percpu.c
> > index 3ecd86096641..f16533ed4a49 100644
> > --- a/mm/percpu.c
> > +++ b/mm/percpu.c
> > @@ -638,6 +638,13 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
> >  	if (end == block->nr_bits)
> >  		block->right_free = contig;
> >  
> > +	if (block->contig_hint == 0) {
> > +		block->contig_hint = contig;
> > +		block->contig_hint_start = start;
> > +		block->scan_hint = 0;
> > +		return;
> > +	}
> > +
> 
> This change isn't described in the commit log. I'd prefer to clean up
> the logic below than adding this additional if empty case.
> 

Oh, by the commit message I meant indirectly that contig_scan_hint should
not be trusted inside this hint update function while it can be outside.
Let me clean up the logic below instead of changing the commit message.
Since the control flow will always reach the first if-block below when
contig_hint is zero, it should be simple enough. Thanks!

> >  	if (contig > block->contig_hint) {
> >  		/* promote the old contig_hint to be the new scan_hint */
> >  		if (start > block->contig_hint_start) {
> > @@ -845,7 +852,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
> >  					PCPU_BITMAP_BLOCK_BITS,
> >  					s_off + bits);
> >  
> > -	if (pcpu_region_overlap(s_block->scan_hint_start,
> > +	if (s_block->scan_hint &&
> > +	    pcpu_region_overlap(s_block->scan_hint_start,
> >  				s_block->scan_hint_start + s_block->scan_hint,
> >  				s_off,
> >  				s_off + bits))
> > @@ -889,7 +897,7 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
> >  			/* reset the block */
> >  			e_block++;
> >  		} else {
> > -			if (e_off > e_block->scan_hint_start)
> > +			if (e_block->scan_hint && e_off > e_block->scan_hint_start)
> >  				e_block->scan_hint = 0;
> >  
> >  			e_block->left_free = 0;
> > @@ -922,7 +930,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
> >  	if (nr_empty_pages)
> >  		pcpu_update_empty_pages(chunk, -nr_empty_pages);
> >  
> > -	if (pcpu_region_overlap(chunk_md->scan_hint_start,
> > +	if (chunk_md->scan_hint &&
> > +	    pcpu_region_overlap(chunk_md->scan_hint_start,
> >  				chunk_md->scan_hint_start +
> >  				chunk_md->scan_hint,
> >  				bit_off,
> > -- 
> > 2.53.0.1213.gd9a14994de-goog
> > 

