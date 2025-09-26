Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26FCFCAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 16:57:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88E578E0005; Fri, 26 Sep 2025 12:57:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864B48E0001; Fri, 26 Sep 2025 12:57:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1678E0005; Fri, 26 Sep 2025 12:57:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 691D88E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:57:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14C3011AB85
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:57:21 +0000 (UTC)
X-FDA: 83932007082.29.1AA98B9
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2284440005
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:57:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=k9tr9daR;
	spf=pass (imf11.hostedemail.com: domain of 37cXWaAgKCCIH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=37cXWaAgKCCIH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758905839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Ju6gxyxgWTxjvMZdx3ZtN+Zpu8mTYwaY+/0NZYuLlA=;
	b=GMPG3OrpQHxS2sUqtjbRM479lsQN9ilFTBD0Xt8wxZQ3hlJLnjZJKVx5JY9zz6qkFewvtS
	mw8B1n0Buzbd77LrL4c6TiOu5CFkwfvAwW2zrXJOtFjOF7ove3ZHR7Vf7KlSSotokDI3XA
	GfrbxOTWg+9kLPw5IVBCZ0FlQGe3hTc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758905839; a=rsa-sha256;
	cv=none;
	b=Xo180dXGRD6kUga8cIV2BNCAvKpvC/qGrdeg0edFGpzYuFaVWgik1zHe6ZRzaPNXn5yUSN
	dFaBLI0ib1P/ydr2zrHcWNMF/8qxFIjrcQZvO0FurlVj0ox3794cdgo8QqYFKhZO58rGlr
	3mfZcvg8v8/0kBhLs1kcac76f33RFz0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=k9tr9daR;
	spf=pass (imf11.hostedemail.com: domain of 37cXWaAgKCCIH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=37cXWaAgKCCIH8AIK8L9EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b2e74dd6b42so203675066b.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758905837; x=1759510637; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Ju6gxyxgWTxjvMZdx3ZtN+Zpu8mTYwaY+/0NZYuLlA=;
        b=k9tr9daRH25QJoTbNXdYOz4BEhIqWsN1USllX35WhZSn7N7Mk3uQn5ATNpuH1OO9ku
         m7sFtLTEbP557TsRwdLzFpVDhfRVpMOMabb5XKT8LV9cUfwTVgsLClGXvJ6dIkjkLRDf
         GCK7G4+X3WyIlSxhcK79kt9AuMMM394brUAtC8uKcgJhqQn6kzDn7SFrdXUZX3C5DN4Z
         /Zu5udUkmG79ToHIUdwa+eHEM3b/t5xJVmhJzsxt2QHXdgGfFsjfvnG5wXpzHocgqZzw
         Eq/N2UMbrs45St44trrojIwmo1CV1CULfSVj0PlrzhtkA4UfO5JKuZJr3qEX5G9tmgz0
         47Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758905837; x=1759510637;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Ju6gxyxgWTxjvMZdx3ZtN+Zpu8mTYwaY+/0NZYuLlA=;
        b=KrPq/zEqJLdgmlahLaUKymakzmmT+DdnOO8upGQueHsNiOksAQ/XefX4wJoN3bBaCw
         zi/33IBOcQaT04NLi+skAQmhxvrQ+TJbv+kikmQJiLm0RkUDzsO7KYYQppEj8SLgXUXt
         Wlk6Y+bIdWrszrkQU49tI9OOT9fApq+xAQ0HjWG2CNWEve1tnq7Smg3GImtBUa0FerSe
         mRLPNiYsy9LkrcKEQywYDfIb2J7B2BR2lM81SRQrdzsYOtWW3FW8mtgqt91VjsrGCkdd
         GEo1WiOpZYG0AuvcVK8ptZ+hMzua2WpMDGaK44kwLojqsaBxlLzqb9AnjBXMO/w6Fmyq
         fHtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcNOYPs5sRVmAo9gvsdLByWE2m5L4n84+xX4xV5LrG27vL2Ijv7yBGTjusbuECrfPTi5mdwhTsnw==@kvack.org
X-Gm-Message-State: AOJu0Ywt11xHh7ckWhVrQAkgwCN1q34buAYGc2aX+Ohiq9ezp7lp20EI
	ARkXhwKLEBmNSlOEb+5jkltu1tcSWRFJ23HsQfEpLf+ULKYBpQDD1V9Y0b+8GoqPc9SvrD3wCMX
	T9NolOdbyxR6JvA==
X-Google-Smtp-Source: AGHT+IHEEKUcEgkinB8RkGOvRf0Mn+ZhFXgTH/LXZ/sF89QqfcyjXF3T4sban7Iur9CoxJ2skTB0kgdlTLmCjg==
X-Received: from edqk11.prod.google.com ([2002:aa7:c38b:0:b0:629:211a:d085])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7b9e:b0:b0c:b51b:81f6 with SMTP id a640c23a62f3a-b34bb50f1dcmr907955266b.43.1758905837402;
 Fri, 26 Sep 2025 09:57:17 -0700 (PDT)
Date: Fri, 26 Sep 2025 16:57:16 +0000
In-Reply-To: <20250926154834.2327823-1-joshua.hahnjy@gmail.com>
Mime-Version: 1.0
References: <DD2SCJF0CLN5.1824PA58HFFZF@google.com> <20250926154834.2327823-1-joshua.hahnjy@gmail.com>
X-Mailer: aerc 0.20.1
Message-ID: <DD2W2YFEPC3L.250WBJ4E5EM4K@google.com>
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in drain_pages_zone
From: Brendan Jackman <jackmanb@google.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chris Mason <clm@fb.com>, Kiryl Shutsemau <kirill@shutemov.name>, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <kernel-team@meta.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2284440005
X-Stat-Signature: 55k69eqc3g1p1tjad8jaz7nykrxzzgw6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758905838-115854
X-HE-Meta: U2FsdGVkX18UYrrgHdOKLlbA+KDrZDTn+et9MlfZOEOu1Iminmhqg8US4tJdku9Z2jzl9dlP3UUsF51RgC1ACMR97l5OxG9fFoRpjgSFZ0jFgjr8CTQMBXT1Jn+jeH+dka8DM371pXNLSyDuNBITJeNQEBn4aDGeM0uglxUxU+vbVGU0Pcn7rj+/dZ6KvOPw00bv4TVjKtQ/CyQrvweFfKZ/pPfGFqeLEtMJSn+hwh8mv8w4O/3kSOt5YY6mTvaMEOrha7O9tlz8ApHXP4xdYHZ/YkqDc0joWLfSIQBHlvWaYehsvpR6h55vKm94HrcUnhddLe/8MzrofqkFRJwcN6qvNS7o91iP9wABOXtqVOBJF3qs3r1e3mx8mMAHHfAIYRXZ5dRRsU2hv5ExFWYOSglX3PEdQCtqfQX4U4nyFgBdsFwuuqxjkM4L8+HRrNHMB7zjOiMBdyR/YLNtbZmoXXMbMFdTVsnIjuoyqJTKpjgTHBRoXx23EeUyJdaLQiRbsBOCIuK0134Dj8QfjlRUpyoyawl4R5J16UI4w/9XqJbbPNAth9KYjTam2pB0LfFCFIBwji0WMg/r4ex8OgcSgitc1cjdhuR51nZCIvm5rab1P3EETC8wzt6nV2FFTCXwqrA4+S3tOoEisvUGkXXZvaR7k7nNI+3sUeOkFRxNkj+hDjSOsXsad1jD2rIbEyGOa3M21KS0PO77w37MgRwe/sGDq/olWYnGo1tpYcJDD4uku3Kmu92Zfj2pdkIryrUii7W57eKUzencu+IfUgelXdi/KhKO/yW4WikO14/CjPmXDMKdSKBRtECHUYjyDPBrT19hRIufdzjbX+YMc4RQFiGnyYlYdUmBc4Ax4wxAFlzAjJKR7w2kak3CBAvAk7wSbUuOTo+lrawspYeeZjqxdX1WCz4XF+I2LDVup74DBebot9CMY4p2P4tq8vq0MZApKiDYQyQfdd3JOR+kW8M
 aaLrwUuu
 bFfJg/67DPlrHLTnYw8WZf1XpSOOxVOzow/niwLrxZNhV3wbxpTKUH0LGSTy1V3acUUWD7Orgn4tjkeLZ4fHx9siLsnrOB5T05wDPd8YV1XjWOzx8jsUaw2zanTUjzqZD9vvpX7dE0t3b9ASFkJA//4qkDZB1tiHd3rgv/9RgFucyQMWxU5Z4Na5qPynYHSgrh1qCFu/XdDyqLXxIry7ZvzRvfUBkWc+cIIqi3jdVszGkiJCk9/dLlZZIlFGDXdeU2yHpQCGjHCsmBXK+SZUWyeQYN8M6PEUQZLHGEgyCinkXXMantiEsuUF71PGqek7LvoXnCoKL8tPu3Zpcu+dpnq8MJOvNE823aZjHZpvGyjkvd222VArmxZLVN1VsffvZECPr+/6ljjQOBNrhqIZmV5Ynb28ny6VMC9xeL3xYpyCqXuNsmiX/nN7u0A0oQJyTIjkXLDOM2AjAoqbckIbamLpouYkStr+mh2m5FRs1Ps+DJkmnj3ffV4+SgyvYBy4t7Vrsj3wsuPrW1hkQOtNjfW1PU0gxQV9M18Gw/IaPWcITQEMuv3mjGuMXUMgRvasWFMRksIyZyGRJDtCRw/mjLJRyt8vx8lpD0PIMQ3F/dNRCrNdS9wDDYVfKiU3GBTVz+L09+rIOwNZK64o2FfWVPY5NUbvKKmzqialD8YNTTzANh6t/Oe5lJ1RvgJ59LcwY+VCM8Pi8S/1pfxsNYR6av21E4c87qp8dXynVumhbKHOvzfE55BQyL+RhGNBa5LIm7oDO9vty39FxtTcc9iZHcaTcPQukJ9k41/mE6B9xAjYUMQ4nxI3JYioJ2Z8j558Uxzwj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 26, 2025 at 3:48 PM UTC, Joshua Hahn wrote:
> On Fri, 26 Sep 2025 14:01:43 +0000 Brendan Jackman <jackmanb@google.com> wrote:
>> Hey Joshua, do you know why pcp->batch is a factor here at all? Until
>> now I never really noticed it. I thought that this field was a kinda
>> dynamic auto-tuning where we try to make the pcplists a more aggressive
>> cache when they're being used a lot and then shrink them down when the
>> allocator is under less load. But I don't have a good intuition for why
>> that's relevant to drain_pages_zone(). Something to do with the amount
>> of lock contention we expect?
>
> From my understanding, pcp->batch is a value that can be used to batch
> both allocation and freeing operations. For instance, drain_zone_pages
> uses pcp->batch to ensure that we don't free too many pages at once,
> which would lead to things like lock contention (I will address the
> similarity between drain_zone_pages and drain_pages_zone at the end).
>
> As for the purpose of batch and how its value is determined, I got my
> understanding from this comment in zone_batchsize:
>
> 	 * ... The batch
> 	 * size is striking a balance between allocation latency
> 	 * and zone lock contention.
>
> And based on this comment, I think a symmetric argument can be made for
> freeing by just s/allocation latency/freeing latency above. My understanding
> was that if we are allocating at a higher factor, we should also be freeing
> at a higher factor to clean up those allocations faster as well, and it seems
> like this is reflected in decay_pcp_high, where a higher batch means we
> lower pcp->high to try and free up more pages.

Hmm thanks, now I'm reading it again I think I was not clear in my head
on how ->batch is used. It's more like a kinda static "batchiness"
parameter that informs the dynamic scaling stuff rather than being an
output of it, in that context it's less surprising that the drain code
cares about it.

> Please let me know if my understanding of this area is incorrect here!
>  
>> Unless I'm just being stupid here, maybe a chance to add commentary.
>
> I can definitely add some more context in the next version for this patch.
> Actually, you are right -- reading back in my patch description, I've
> motivated why we want batching, but not why pcp->batch is a good candidate
> for this value. I'll definitely go back and clean it up!
>
>> >
>> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>> > ---
>> >  mm/page_alloc.c | 3 +--
>> >  1 file changed, 1 insertion(+), 2 deletions(-)
>> >
>> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> > index 77e7d9a5f149..b861b647f184 100644
>> > --- a/mm/page_alloc.c
>> > +++ b/mm/page_alloc.c
>> > @@ -2623,8 +2623,7 @@ static void drain_pages_zone(unsigned int cpu, struct zone *zone)
>> >  		spin_lock(&pcp->lock);
>> >  		count = pcp->count;
>> >  		if (count) {
>> > -			int to_drain = min(count,
>> > -				pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX);
>> > +			int to_drain = min(count, pcp->batch);
>> 
>> We actually don't need the min() here as free_pcppages_bulk() does that
>> anyway. Not really related to the commit but maybe worth tidying that
>> up.
>
> Please correct me if I am missing something, but I think we still need the
> min() here, since it takes the min of count and pcp->batch, while the
> min in free_pcppages_bulk takes the min of the above result and pcp->count.

Hold on, what's the difference between count and pcp->count here?

> From what I can understand, the goal of the min() in free_pcppages_bulk
> is to ensure that we don't try to free more pages than exist in the pcp
> (hence the min with count), while the goal of my min() is to not free
> too many pages at once.

Yeah, I think we're in agreement about the intent, it's just that one of
us is misreading the code (and I think it might be me, I will probably
be more certain on Monday!).

