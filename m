Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3767CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5AC88E000F; Fri, 26 Sep 2025 11:48:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32218E0001; Fri, 26 Sep 2025 11:48:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47EB8E000F; Fri, 26 Sep 2025 11:48:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BF3328E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:48:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 79FE7160707
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:48:39 +0000 (UTC)
X-FDA: 83931833958.18.28B4DE2
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8AF2280006
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:48:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NVFYcc9u;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758901717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESIjBxRBQaFXab+YuRgwHn4pBu5p/ZSufLb4LCbBcAs=;
	b=QRUTZawnaiOU3Lo67lPXO2bWytIRlZVQUWnr4E+yqsHZB3cbu45uqMzbXzwg1X4fXAfF6R
	iZFJSQLKpgRBWGqSpJxK6ChOO8lLdjC/PTrpQ+PV9tZSLdD2sMnLT77/pRKv2ixE8C2U38
	q6KQGfcDR/ZSh5OKYi2afOaUNReAn30=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NVFYcc9u;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758901717; a=rsa-sha256;
	cv=none;
	b=gkJMJ5bjSMlFGXE2zKRfiL6duiBcW1dwKWDYh/cN6szowPuIMoX7KdC+Der8A/Fi9KzjlX
	WMTdUQfBOM5hyiMTO2SUN47ptwo+F48hMu/LW3OxbuqaVqMeqKx25/OHlcvW4l3rdOtDGo
	5W1TMji7KE1OCiy9VNBAfuQbPwVekWY=
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-635349b6fe6so1070657d50.2
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758901716; x=1759506516; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ESIjBxRBQaFXab+YuRgwHn4pBu5p/ZSufLb4LCbBcAs=;
        b=NVFYcc9uQIC+6ESfTWVnQvCzMbbKPbOq3nqKvE/Y08RQ5H6iQyIA5xC9EhDmgSumEv
         C/Js7jP06tTYN3tD1MiekDMGtwOtUkbhkajQTmZWbLgCw9FEF2UkHSEUxM5l+lcMRv+m
         GVjanRiiXXuv5mlqG4YujFNpX3ttaPuZ8LdqW3y3VXsaK0Kag+xzUZpXfiF8NQpXMFlG
         CXwIuLmT+eDT4b+LxAsZGbi1yytuNGUwYmTh+pC3s8/kmXefgJkbZpCT3+DPlUtpUlD6
         SjbmYetJYeFCxxtHuQhuiqdFCxWv/PsfiuwpfeHQR4pIFqC0TX/cF5n0v8nPJ/ukl2mf
         ihRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758901716; x=1759506516;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ESIjBxRBQaFXab+YuRgwHn4pBu5p/ZSufLb4LCbBcAs=;
        b=udz+ilvKL1zsj9vs0tiaLH7IA3ly2SJ7NUKkOTsEJaUYAmbIyIx0P7NeVEYboMfePf
         L3ZSP11/XNAtCgoHDCESZV2cGyR4YJVfjehKUrDiz5+PvNzJBwcZeEZ0H6VAOJO2MXWB
         U6Nm1db9Fkz+yQI5wM0g46WFSd2qcRsUOhgomWKzX9wNjTsRReVFR0XdKY6S0EXfs4lx
         n0c0OlvCzMAbnLMRbrLwTXxI6fu0ypjfzPlWxX7MfJ9pxCvK7IrpHJRlmbmNa1Gm4VTE
         +6ixNjaLn3lnrq5e1rbY0zbzb23OzvtVTrtKovpSVfSkVwzhthKCKPSn6I8FlzF0wI8U
         keHg==
X-Forwarded-Encrypted: i=1; AJvYcCWzLBBywEFA6gDRJm9yqch51qjqXrKuF0aK/6nMiEvmd9An74ZVFUOFrwhlvZ0+VelNiofvW0nxPw==@kvack.org
X-Gm-Message-State: AOJu0YyssMnFgE5Geu9Ev72xrnD3cAvJXHAwPUUx9lzf2RXFIBekNHtk
	TL4uEeJLkRjCog5nbJuQmHo6bUNd64lCQgSuWEZo28WjKL7leNFEEsx1
X-Gm-Gg: ASbGncsW97H4XpcHdX0uXlaDwFJFq2VD3l770lRBM20NFTLMUzeTi30kBfECxxvwYpD
	zV7We3zBZS6Z0OKEJ7PfOtqgjDX8iFGy1wg3ex8PiHD7S0Iqmjjgbq994Mj5Ea/WYc15vKFb+xY
	w+Pj/Gx9CX88FXO5LjFU/sfagiJqDQrFDs4RqpSVyBSzRmx8xev2Bt7b4+vqCqtilKXNx/JenbK
	Z2z5KBVBCbJpxvhIdTeA85Vcl/QbzK3JsAfF2AN1+8qwGMlXo9wprCpGh5Rpve3XkYWIH2qBoBB
	yU0dyJ6WeteokntkPcEdfsA53uGgLaPi/AvONF2eXScvuN+Q2puycJLGMvSRWLkHpNFa/OgdxlE
	ohvlJauGiVgxrkArKNh5Ul6nFWmGCAf4eaJI0pnQoG2BfZOKbdLBjqCvMggOeJ3UW
X-Google-Smtp-Source: AGHT+IH5v5oEleHS+hhobpT1fPu/dGJzQLGt0YwAygbvnJZKb6RzhqZPSdR0+T1YCZa1xLc53b6QBw==
X-Received: by 2002:a05:690e:1590:10b0:636:1fef:e725 with SMTP id 956f58d0204a3-6361fefea7cmr5781546d50.2.1758901716427;
        Fri, 26 Sep 2025 08:48:36 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:11::])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-eb383929a6asm1447970276.16.2025.09.26.08.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 08:48:35 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in drain_pages_zone
Date: Fri, 26 Sep 2025 08:48:33 -0700
Message-ID: <20250926154834.2327823-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <DD2SCJF0CLN5.1824PA58HFFZF@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sxipbprzghwh9uk4yp1j46z9swhrrph6
X-Rspam-User: 
X-Rspamd-Queue-Id: 8AF2280006
X-Rspamd-Server: rspam04
X-HE-Tag: 1758901717-513834
X-HE-Meta: U2FsdGVkX198If561/OxvwKHADyTBVc9zKEkl/UsoX703gogsr5eJ41PixFUSZIfua2II9x2a36Hns10j680+Oc521xaS/fn6T/kpDWcZ0lalq5ukvccw98tIQ/2ZiIADaNzw9035mccti4A2v6zSyWF6eBzPkNdXFa4SAmO6rK2m2s4qSIV0UCQh9PknQMWZGuRgH+csYx7TUQtG4/szy2vIll9HApAANFJlB2eOY4sVXHg7D6QHhd2l1J6sn36Z0aBWxlndU2Z6dtfEHzXakScqhXwd70k1dkjJORh4gXf9f7z8SST6q8uBlCsoDZAmtP/ko5b3WZGoL64OcFJdMdyYGNePMZxo0gifhUa+62NSXomyrmMaTGstj6P8wZz2oTqJepB9fjZ7bkKrqWQ+OPTS7N0mJXnvVdRrUx8z3uDyfWAaJ9L8Ekz/3nGroK2M7tbwvDboN3OIah8K0zNOBUB/1JhySsaTY4aGEJMx9lDtZJfjkCuTnozbivZ/p0ul2xlJednk8lGJVurxt1bUNaIZ4nrrJ18LQ1lrcWtTRIVJ8sL0cKuZd+BqpUI/0XWgJYWyJ+PX4np0+YMnw/e6HCNa58MyTB5OLAkwoFpZ+2J6SEeSJTNVF1Kazi/7wAHPe9mJhCHIJez0isyiV1/gfDgIR0ye4K4TKbmRuLAnvqpXh/9EyU68P0658SwT10RzkAuFa0zk8EXcn+M9YFlTKqTP9tG1VebEKwryq9ZC7FSlHiKZrXwN2FCkxP2D3FZDVDCdKQDrIdRY8xi+2TQcmz8lrJhBGAYmG0sndmgQjxTVb5bsjaM5G0vkhGoBoG2Kc993I5GNW3CWyVU8v2EehrjH5f0RAZQo5CxTqgNH6ZUXxyXnzWu1S5IPGpmyna7J/Ug+aQTpxOVO4O52lyZN6w/rQHdVS1r4sPsVsqnpA1t7RFGXwdijZkPul+so0kOLE0X8jxSV+5IbnhUw8I
 M2h6tdbU
 sUx+wXMt+o6pCjMxpktgsI63yRIS9oiqu3RjIMTPAtSj8O5+SZspajqeBQa0Iz85isOZsZ42mbWg+zdqfl01EBYL5ZddENJ8Ga3Bt+7YD3S73oc1skP3riKfMwz1AWtdY3E+4+qcJwmlLrAToY+QfW0UosHe68S3rO+cem0hug0G+qfPZXQ/AMHhwVtWJsjvQJmMiGuheWLUobxukuxGUVFkbjZoK7dOaj64y4debw4RiOOwhRMbkgj1rKVpZAO7AFcLYBA3CatcjmzFk/ty8XsRLpS6sYvUNfU3ZPMcQX2gQeBr1TYdEb2GAex+lQiDSfIZ6W/d434ZV9W7vCYuctZHnR4mZib3n3liQgdTyo5teXfhB2+7uXALElkwYi7a6BTZAgsNrX6naHoqY1BZvMz6+eF096g/pjLv4H27xvmXZhE9XgUr+e+7Jg6T1emzGI/I7zGXWuCTmPx9Of2u5EUfMpCnrnogB6GcJxOLgYTbm8bwN/GFWh7plyA0K/S1ydfx+KRRaoTZ4qw1FjNka39yyHPhMa5aZUFlGJR5HmG9LdD0BeVjskz3ZhsA+gvMp6WoP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Sep 2025 14:01:43 +0000 Brendan Jackman <jackmanb@google.com> wrote:

> On Wed Sep 24, 2025 at 8:44 PM UTC, Joshua Hahn wrote:
> > drain_pages_zone completely drains a zone of its pcp free pages by
> > repeatedly calling free_pcppages_bulk until pcp->count reaches 0.
> > In this loop, it already performs batched calls to ensure that
> > free_pcppages_bulk isn't called to free too many pages at once, and
> > relinquishes & reacquires the lock between each call to prevent
> > lock starvation from other processes.
> >
> > However, the current batching does not prevent lock starvation. The
> > current implementation creates batches of
> > pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX, which has been seen in
> > Meta workloads to be up to 64 << 5 == 2048 pages.
> >
> > While it is true that CONFIG_PCP_BATCH_SCALE_MAX is a config and
> > indeed can be adjusted by the system admin to be any number from
> > 0 to 6, it's default value of 5 is still too high to be reasonable for
> > any system.
> >
> > Instead, let's create batches of pcp->batch pages, which gives a more
> > reasonable 64 pages per call to free_pcppages_bulk. This gives other
> > processes a chance to grab the lock and prevents starvation. Each
> > individual call to drain_pages_zone may take longer, but we avoid the
> > worst case scenario of completely starving out other system-critical
> > threads from acquiring the pcp lock while 2048 pages are freed
> > one-by-one.

Hello Brendan, thank you for your review!

> Hey Joshua, do you know why pcp->batch is a factor here at all? Until
> now I never really noticed it. I thought that this field was a kinda
> dynamic auto-tuning where we try to make the pcplists a more aggressive
> cache when they're being used a lot and then shrink them down when the
> allocator is under less load. But I don't have a good intuition for why
> that's relevant to drain_pages_zone(). Something to do with the amount
> of lock contention we expect?

From my understanding, pcp->batch is a value that can be used to batch
both allocation and freeing operations. For instance, drain_zone_pages
uses pcp->batch to ensure that we don't free too many pages at once,
which would lead to things like lock contention (I will address the
similarity between drain_zone_pages and drain_pages_zone at the end).

As for the purpose of batch and how its value is determined, I got my
understanding from this comment in zone_batchsize:

	 * ... The batch
	 * size is striking a balance between allocation latency
	 * and zone lock contention.

And based on this comment, I think a symmetric argument can be made for
freeing by just s/allocation latency/freeing latency above. My understanding
was that if we are allocating at a higher factor, we should also be freeing
at a higher factor to clean up those allocations faster as well, and it seems
like this is reflected in decay_pcp_high, where a higher batch means we
lower pcp->high to try and free up more pages.

Please let me know if my understanding of this area is incorrect here!
 
> Unless I'm just being stupid here, maybe a chance to add commentary.

I can definitely add some more context in the next version for this patch.
Actually, you are right -- reading back in my patch description, I've
motivated why we want batching, but not why pcp->batch is a good candidate
for this value. I'll definitely go back and clean it up!

> >
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  mm/page_alloc.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 77e7d9a5f149..b861b647f184 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2623,8 +2623,7 @@ static void drain_pages_zone(unsigned int cpu, struct zone *zone)
> >  		spin_lock(&pcp->lock);
> >  		count = pcp->count;
> >  		if (count) {
> > -			int to_drain = min(count,
> > -				pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX);
> > +			int to_drain = min(count, pcp->batch);
> 
> We actually don't need the min() here as free_pcppages_bulk() does that
> anyway. Not really related to the commit but maybe worth tidying that
> up.

Please correct me if I am missing something, but I think we still need the
min() here, since it takes the min of count and pcp->batch, while the
min in free_pcppages_bulk takes the min of the above result and pcp->count.
From what I can understand, the goal of the min() in free_pcppages_bulk
is to ensure that we don't try to free more pages than exist in the pcp
(hence the min with count), while the goal of my min() is to not free
too many pages at once.

> Also, it seems if we drop the BATCH_SCALE_MAX logic the inside of the
> loop is now very similar to drain_zone_pages(), maybe time to have them
> share some code and avoid the confusing name overlap? drain_zone_pages()
> reads pcp->count without the lock or READ_ONCE() though, I assume that's
> coming from an assumption that pcp is owned by the current CPU and
> that's the only one that modifies it? Even if that's accurate it seems
> like an unnecessary optimisation to me.

This makes a lot of sense to me. To be honest, I had a lot of confusion
as to why these functions were different as well, so combining these
two functions into one definitely sonds like a great change.

I'll make these revisions in the next version. Thank you for your valuable
feedback, this was very helpful! I hope you have a great day : -)
Joshua

