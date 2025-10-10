Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47D66CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792198E0022; Fri, 10 Oct 2025 11:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769F68E0003; Fri, 10 Oct 2025 11:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A65C8E0022; Fri, 10 Oct 2025 11:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B6408E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:14:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EAA0E140382
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:14:04 +0000 (UTC)
X-FDA: 83982550008.17.9CEEEE1
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id 45B14100013
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:14:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=krGdNEuD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760109243; a=rsa-sha256;
	cv=none;
	b=hM/heke07tsPuQwgVSIcCeF6SIdrjgc9NR0wq6r+2E4kMFuB9T/9l+J2uhOwTrS8uR7BMQ
	Y5d3qhMPmOZAWJ9FxEOp0Nfy8byTNPqa5NuBSFt8uYlhrAORz9xukjp0b7keKaUlPbqrDp
	oYAAefrQ3eEyIrxWQG+5BrHta7ZhNpc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=krGdNEuD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760109243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tu3w7uzl84l8Ft0YZbH5YNQMm501F7O/lzUqK1Lwx90=;
	b=0Wvd63ykFMot8WmbXvVRG2dyZlxzAWC8t0V10X1qgPS8wSoqnNXUv8wXWp6OwDbomFiuW8
	ag3sxMbk+dtnxQWP7L1+An/8ybmJJ/biSu6SFBqzBysfFh9CaAVyr6DSnzOVqU12b6MQBp
	WKUox4/Z4gtcILNLjD99RRzHN1ofp6o=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-74f6974175dso23104997b3.3
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760109242; x=1760714042; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tu3w7uzl84l8Ft0YZbH5YNQMm501F7O/lzUqK1Lwx90=;
        b=krGdNEuDiOuWWtwGa10t0Zdgps7VoQOgLLzYkeOitbq/uH8XpcgDtPdoEseJQAWHOh
         H0fd4uLL2Ri3Yv/DpkALE15Mj+dJHaj1gPchpD7NfNSmYC2isfUyQfkPQ4FhNngLHOaO
         RJ9nPW7TpmauSiqfAG9KE4bpbZGhbcVijO/KpdJHXDeZi+FrY/xDwhG9mQF3GfSX3qiG
         qEtYOCxy33bjB48N4/06ii5jCqed7wfEzTzEmmK1ZNPyDQJI+bvFW62JlzleZ6py+/T0
         WA1Lxs6W2vXg34EjOD/C1xCE2QfIf1UpEYd2AKMXHGCvYRtn7wg1cdZJEHsWP3GJbcIg
         RlJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760109242; x=1760714042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tu3w7uzl84l8Ft0YZbH5YNQMm501F7O/lzUqK1Lwx90=;
        b=srJ1DVB3/zRhii6VpE4gwMrnIjzmhyROM/mCetuaSJ9WB+ZFa8A4PLazrph6D63/O+
         IjDFfdr1arCT9qbPxGZsMwfPdYM66aO0hq5yoBgQpE85mkNeWRzpPkrC2/4OyNe8aqtg
         4GSy2K1CD466tfbks6iVDaqHraFwNn9kEseYuXtiZ86YnKHaIWIW4qLwFVCSTmlOYGrL
         WXJ5xI7NG/FW/esbsrnWd/Mn1K2IDWJgTkOf8YO2/ub4Z+uQRpvBLRLUmN9mpv/uwYaz
         QOkVorK0Oo666HGt3q9BH9iL6aBDkHMqJmA/eIp+AGQKiTm3vCWVJKoTCr4TCSwZmQPf
         jHCg==
X-Forwarded-Encrypted: i=1; AJvYcCXTTz0nfpqYhi/S4PmgLtysVg+Lp5nAHrATOlO+RVIqUWHZpg9MV5CHZw4Jc5Reb1/F6KrSKt4Nsg==@kvack.org
X-Gm-Message-State: AOJu0YzxsfGF+RfMSuOBpCbcqN8Y/f+RyQVfSGB+lPauMVtRatBouc6r
	lmpLzsNsHVjRmKmtrELBQCd/zl8+Di3mS17CeNeSddsl3oSRaNnK1upy
X-Gm-Gg: ASbGncsACxgI4hFat3usAQuiZYx8Gq7fJlyVEyn4PbGg1BKxS8V29c9HEQ+xHLJw/CF
	zShVrt3ObeLfmX+u0PpDOrSF3Q9am9yyS9c+cRKZkYLHDIU7WzSTvxyZQpZAiHfE2M0KTnq6g+4
	bc6mOwery6DmhYrsppB4fiEcxqYhd20OSbmHLOALTnrlsGDJBQv2iA2m7GTc7QFlJhe6nhR9pQ9
	aTmfuWbzDSZ8faxW9KFegdsXJRf0l1+/AVymzFOPOOQONWflS7DqiAr7Stc8MBtceEX1eEsXpsp
	Caxd8zgms70mQ1sl+JlwFr1XP13q9/iw8d4lHx5gIytJ4TZCTrTPr7fAuF3XOFbS+ovnjQjobkv
	nKrLQhewkE2GEmerrFUK9oFwXoWHHrAqF6H+puBI43bb3vxSsctygCj9Ned7CBuKklFa3CI8iJG
	DdF1tZqOdJA6GkEsbbPA==
X-Google-Smtp-Source: AGHT+IGl9qnBMei/PCnRuefDn/nGk1brpz0LjP5GS9OBntxd0TvfpQuY0J02WWnj0+QmTUzyq7Q1Zg==
X-Received: by 2002:a05:690c:a083:10b0:781:64f:2b3e with SMTP id 00721157ae682-781064f390dmr37402917b3.64.1760109242149;
        Fri, 10 Oct 2025 08:14:02 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:7::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-781071fa127sm6387437b3.37.2025.10.10.08.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 08:14:01 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 3/3] mm/page_alloc: Batch page freeing in free_frozen_page_commit
Date: Fri, 10 Oct 2025 08:13:59 -0700
Message-ID: <20251010151400.1925642-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <c48ae6d5-3a04-4c32-8084-33d2e10d8d2e@suse.cz>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 45B14100013
X-Stat-Signature: sokbhobd83eeraqr737eqzcbg6b8kegs
X-HE-Tag: 1760109243-2008
X-HE-Meta: U2FsdGVkX1/rTr/29trdlfoVU+i7MhgBj4iNktxdUcvmoyq9NKB5pGa++BL2FrvPThsRJND29WA2n6UTge4sAEHm6MnjjrRwwwuJRWi7uoqpJpsemD1UXHu9XoNkyAdAGFT9dWoCwYifyAn1/GJY7oBOOpe/RYPyl+GASNXo2tfQWQPYMEwk9D1wfJsMwOUCpiDXYDI48dyskFh0+Vv01Xb4EhYdyBKHpYqvYyIj/ZyxCEhTo7/W2+fi8hU1lpTPJqo35WoPThJE80zejnVea7wW5zfq5RUeseJNRaTNymu4LR9aPfyI4G3n1qytY7ybbVXQ2xYlQ9+TTEOZ63mqV6vG1dqLZv+/k5ohoA1qVi/oKEvVCzftZVCvhWhSEj9Lut1ijzoHRZO7KtJNfImRXHHQNXGptwWPtEZk4iMdXTuKmsRTjEimB2kmb+Fg6T3Uilvsyp/CwvqrTuGRGSSEYMVqNCKoxkALO+JestaLut554yx1rjovpaOouf/c6NMd1XzY36i/vCgZqBNv4F+eZw+v/HsVOXzOxJyT98cJckla9BD1E24i66mIF/8xdA5pPmKfecE5ySAvtAnL+HPkkkxRspTtptR9N/SdZ721C6W4XDmfjlnAUMzlKss/VZfrkduTweKg35c0g0NZvjMURZwTBGqzHzi0HXElBniRX87Yuw0gUIqC7L9SpgwKIR2HjNIYihqnt1KlJUb9uYcYUSg5/ubhY84ffiFE2UyB4x7JvfzJ30PkzSBlQz79793JOYXqsN1+l/7T+a5UrAQTmyucbhtqdRVx5ilegi1TAuKKkjlKUtIL8rA5fR+ZhKO27oLJZfSM1Aap3GwyELstYKvsnLYOfly79kIUA+Iy1Nua/6PSJ/MNt/C0pZcS9rDd5gQm6kXPq0y1AoDmctZ/eziqPoXZFQW7Kd+PjodZClAIaJV4Cm3gYYCNfNvEkJZq9XTxFE/U0CRf6X2NInO
 XdrfyTyW
 SdJ8nuHpMyuwoxHYCKAQhiyqEk+2Wh6eH2Xjd1p1OzioRy1LhZHRb4ydjuDzDQ45+czCL+3HzwNZ5rOJRGlkD4f+ZaKG2+DueP1oIoTye43PVaUVNGwyQ6bk94MW2yT04gvr8JRoLDC+d3sCxKvN2rKGpiC+6Ipe7GKWn+qP0b45CIU2WwVi0fPY4Bg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Oct 2025 15:37:23 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

[...snip...]

> >  	high = nr_pcp_high(pcp, zone, batch, free_high);
> >  	if (pcp->count < high)
> > -		return;
> > +		return true;
> > +
> > +	to_free = nr_pcp_free(pcp, batch, high, free_high);
> > +	if (to_free == 0)
> > +		return true;
> >  
> > -	free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
> > -			   pcp, pindex);
> > +free_batch:
> > +	to_free_batched = min(to_free, batch);
> > +	free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
> >  	if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&

Hello Vlastimil, thank you for your review!

> We could do this handling once after all batches. But maybe it's better to
> act as soon as it becomes true, and checking once ber batch isn't measurably
> slower, dunno.

My thinking was that if we are to release the pcp and zone lock and another
task remotely inspects this pcp in the middle of the loop, I would want the
ZONE_BELOW_HIGH bit to reflect the correct state of the pcp, as opposed to
doing it once at the end.

> >  	    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
> >  			      ZONE_MOVABLE, 0)) {
> > @@ -2887,6 +2901,35 @@ static void free_frozen_page_commit(struct zone *zone,
> >  		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
> >  			atomic_set(&pgdat->kswapd_failures, 0);
> >  	}
> > +	high = nr_pcp_high(pcp, zone, batch, free_high);
> 
> It's not clear why we recalculate this. Ah I see, the calculation involves a
> ZONE_BELOW_HIGH check which we might have changed above. So as a result ths
> patch isn't a straightforward "we free the same amount of pages but in
> smaller batches" but something different (and I'm not immediately sure what
> exactly).

Yes! So nr_pcp_high will check if we are now below high, and see what the
new high should be, and see if we need to free some more pages. My goal was
to prevent having to call free_frozen_page_commit again in the future once
we realize that there are still pages yet to be freed, and handle that case
within this loop as if it was what we originally decided to free.

> I think it's an argument for doing the ZONE_BELOW_HIGH test above just once
> in the end, and not recalculating "high" here. I'd just stick to the
> "to_free" calculated uprofront and decreasing it by "to_free_batched" each
> round.

Yes, this makes sense to me. The last sentence in my paragraph above seems
a little sneaky in doing more work than it originally was called to do, so
I do agree that we should do the ZONE_BELOW_HIGH check once, and also
calculate how many pages to free at once in the beginning.

> We should maybe also check that pcp->count went to 0 and bail out so we
> don't make useless iterations in rare cases when someone else drains the pcp
> between our batches (free_pcppages_bulk() protects itself from passing too
> high "count" so it would be just some wasted cpu otherwise, not a disaster).

Hopefully the check below is enough to handle this race case. When it
determines whether to iterate through in the loop again, we check that
to_free > 0 && pcp->count >= high, so if someone else were to drain the
drain the pcp->count, it would go under high (I don't think it's possible
for high to become negative here) it would break this check and prevent
another iteration. 

> > +	to_free -= to_free_batched;
> > +	if (pcp->count >= high) {
> > +		pcp_spin_unlock(pcp);
> > +		pcp_trylock_finish(*UP_flags);
> > +
> > +		pcp_trylock_prepare(*UP_flags);
> > +		pcp = pcp_spin_trylock(zone->per_cpu_pageset);
> > +		if (!pcp) {
> > +			pcp_trylock_finish(*UP_flags);
> > +			return false;
> > +		}
> > +
> > +		/*
> > +		 * Check if this thread has been migrated to a different
> > +		 * CPU. If that is the case, give up and indicate that
> > +		 * the pcp is returned in an unlocked state.
> > +		 */
> > +		if (smp_processor_id() != cpu) {
> 
> We could have remembered the old pcp pointer and compare that instead of
> doing smp_processor_id(), although that should also work.

I think that would have also worked. To be completely honest, I wasn't
sure if there was some pcp stuff inside that would change the pointer,
so just went with using the CPU int instead. 

> > +			pcp_spin_unlock(pcp);
> > +			pcp_trylock_finish(*UP_flags);
> > +			return false;
> > +		}
> > +	}
> > +
> > +	if (to_free > 0 && pcp->count >= high)

           Check is here:  ^^^^^^^^^^^^^^^^^^

> > +		goto free_batch;
> > +
> > +	return true;
> >  }
> >  
> >  /*
> > @@ -2934,7 +2977,9 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
> >  	pcp_trylock_prepare(UP_flags);
> >  	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
> >  	if (pcp) {
> > -		free_frozen_page_commit(zone, pcp, page, migratetype, order, fpi_flags);
> > +		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
> > +						order, fpi_flags, &UP_flags))
> > +			return;
> >  		pcp_spin_unlock(pcp);
> >  	} else {
> >  		free_one_page(zone, page, pfn, order, fpi_flags);
> > @@ -3034,8 +3079,11 @@ void free_unref_folios(struct folio_batch *folios)
> >  			migratetype = MIGRATE_MOVABLE;
> >  
> >  		trace_mm_page_free_batched(&folio->page);
> > -		free_frozen_page_commit(zone, pcp, &folio->page, migratetype,
> > -					order, FPI_NONE);
> > +		if (!free_frozen_page_commit(zone, pcp, &folio->page,
> > +				migratetype, order, FPI_NONE, &UP_flags)) {
> > +			pcp = NULL;
> > +			locked_zone = NULL;
> > +		}
> >  	}
> >  
> >  	if (pcp) {

Thank you again for your review, Vlastimil. I agree with all of your
feedback, so I will make those changes (as well as the commit message
change for patch 2/3) and submit a new version. I hope you have a great day!
Joshua

