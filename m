Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DC22FB5168
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 21:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16F846B0088; Mon,  6 Apr 2026 17:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1211D6B0089; Mon,  6 Apr 2026 17:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 036176B008A; Mon,  6 Apr 2026 17:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E93D86B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 17:58:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E1FD1A051D
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 21:58:58 +0000 (UTC)
X-FDA: 84629496756.09.092F4FA
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 54E2012000D
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 21:58:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=exSdeTDk;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=exSdeTDk;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775512736; a=rsa-sha256;
	cv=none;
	b=rFtbPoBKdffq/TAimHiMqREXDK+Y8wwfYbLmuBtX6WMn8Uqx+u33BEZZ4kBttFjfHkPOSI
	AJboEyHlMkzf1I3b3BHp7aiaTBG89+nBvUfBynPQAr8DTsnQh8XzFpoEIhUJyCUFG2QVR0
	x4PYv6cYVFhuxCz0lbdMsWzkNr5ZHQg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775512736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDKsHzlIK0dErvGTUlDfEuG9BafHGJx5ejTHlmvGSXg=;
	b=kUMEtfHmW5z9RIYIUNiVEgiKMisydXG/zdrg411BjVu8CUD6YWsrzuXpOJjoDoYrDNK+gb
	7ZvwW7VvbxWVtknZhGYRyPIkNM3aXz1C584Y6ywOzG3qBMLeb68b+K+G1tBcLH85fk1+EF
	nxIdZtxyRkJXybuozAjUxf5r4dHrOzE=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8cbc593a67aso453892985a.2
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 14:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1775512735; x=1776117535; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iDKsHzlIK0dErvGTUlDfEuG9BafHGJx5ejTHlmvGSXg=;
        b=exSdeTDk9difhW+6HU64w+2Cm3UCblg37nDc5g3iH7gOQXkSDQiCfhgJyDZUFqwvWF
         S8WvmhLdLhIbFfQFeGwSRVqCP9KxtPSY70tGem0PWQRPaAHKZdyQEDKmg4QoFDUVny3E
         LerPKV8a5Ha19QNZlWTIRqGOFtxd2IikmBRs/LfdDSlpCYJL6A8h/TqTQtyNDITHRz0z
         6HsZobJujhEoid5zxSRQX0iA5YwKLXoJ8PQimsB30NhoW2fnFT9plDpIpPscb/uF3ega
         YHAw/Azy/JBlf7zbOuvnZzCnG3it709izDCVtYlbaZSyYdxFHKP8rMBQiFWzxerXdsy7
         jjAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775512735; x=1776117535;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iDKsHzlIK0dErvGTUlDfEuG9BafHGJx5ejTHlmvGSXg=;
        b=OAkdgrIDP2aX8AxpnHkHWGt9TyLEXhKt2WHHcsUx8HzuttvMi+pseDzgzgrQgV5rcD
         rtjrJoROaZN4mhvU6+mWml/8EbYP/NafabI6Y7RJ1gx3pxEXGr9oC+wGHZdrH+NKU/V+
         dSmQyVZNPDnOlw3UhfTPpSk/SQ5KDfyjzSn0QujIfyHv5wg7RJwR7CpAbIw0tbkGlc3E
         hq8nof5EnVka1Nrz95Xt28xcfQJI7H/11H3Ub1PqrNRHu9bjIjgvEqHPqg/aArXVDWQ/
         K9cLApmu0YVMiIPFXpkBf/tAG+99te4IuMGCIAVaYdyMGovk/gfIOPyuArrM7aa7VkLC
         5nhQ==
X-Gm-Message-State: AOJu0YzXO7ggiPug5mMjPVAekHf3wQDdjMFtQfbCxPwCDZCS1c2VLVns
	xwuQBPoKEuVk5m1SeaBm8RT7dVr6qQiN3DtXFbaRxOzx01d87rJAiiFaLPgJkBqFKTs=
X-Gm-Gg: AeBDietC3e1tLbO94qxLNFXq59wQOt2yZ7yjgFepdL+gJ+9MXfGZEmUmUC8vs6rajEZ
	wqnh4x9RBqsoiifJEO/aA2pddpKYmGcPUh9Lpd9XwjwL7LOXUGVxIS2O8k4pItUbCH+mHD7ZPAN
	vxXmF2wvWt241d4T4ZUdqstTjRTRqQyU/4LNjEpfFpDUM2qFzmiRwL4Fm6yPnhRTP2aaZHXFXCI
	9F9uwcUhddOQxlf9qy9TEX2SzcahNtX7eOzImW5pSixTlOFfEmQ/wFBT+spxJEe8IZYSsbwZSne
	1cNaVp24TR/j/3ern4O7eKi6npxi9rsNKQ37nra/VFZgr8FgcJ+tPUBD48GjnHubjR1LHTgt8F4
	DxTDlo3v/WBOyAM2tnElnY2XfSdPtyA5x5YFnlLj2s0J1LMa7sbWo8xA+qDyZfjIvPrdevNLkUI
	kJ0P9SIYX8ukXYF581xlJ3+7EaN5bsNyRV
X-Received: by 2002:a05:620a:1995:b0:8cf:d7ac:1893 with SMTP id af79cd13be357-8d41db4cb38mr2013184185a.36.1775512735313;
        Mon, 06 Apr 2026 14:58:55 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d2a8c2a453sm1192629685a.47.2026.04.06.14.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 14:58:54 -0700 (PDT)
Date: Mon, 6 Apr 2026 17:58:51 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Frank van der Linden <fvdl@google.com>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] mm: page_alloc: per-cpu pageblock buddy allocator
Message-ID: <adQsm0NX_46ai6tk@cmpxchg.org>
References: <20260403194526.477775-1-hannes@cmpxchg.org>
 <20260403194526.477775-3-hannes@cmpxchg.org>
 <CAPTztWYXT0jHKfMqmUJR7Cu1vU8YPXLkkVY2dPpiEtRQEvdY5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPTztWYXT0jHKfMqmUJR7Cu1vU8YPXLkkVY2dPpiEtRQEvdY5A@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 54E2012000D
X-Stat-Signature: 7r3cscjiho1s1kam5mocer6b9gazddso
X-Rspam-User: 
X-HE-Tag: 1775512736-136901
X-HE-Meta: U2FsdGVkX19lH6YhHm+10jkc2l0t6nuw9NWaIAOtYSBmfuqYPY1n+bbFOebXQcU/tSyuECxyXWuBx2NBywdYnM7a2EvmZQFR2BMpsMTIei7Mmvw0A4SYlJ4NNvCLi2QX9hru1DU64BVnK+5CE+2FwjWlbeEdxFhQhS3uyOhUDritPpafRaCjeHoQWBBF4sjYw1grNGwtmhYv1vKIoGR4cTWPsCO/eIvgaVxSlaKSeHLZF/6qSVSxavjCUCLZHlzHRCy5oJ3umXcZVgh81tLS4KiAcuv2osejP3L6rJYTevQ4WCKc9jTm8LkSFxYs5R2DSJDs5gbWOVZXksNEWsSzO/+56eYm6XSmcFqLiShHKoLnUSSAZ+MLNh+6++R2vSEmF8FGiOvWPkyYmomp6Bju12FnkALa76f9yrl8ed1jQTkTtnXM52D7lVVOlvePOT478FcHnFiQPg6BYbphtbYFXkqG9m4FeykPrjNS4gWl3rwMFrP0m4nbA3InJK+n8onF/3WG8YPs8cKxx9E74Fi/AfPSv1lBVQzq4xlPETKRfuAlC+in+LvIJX8sbxqp9xhxTDBi9ZvtCTTNe0oTNMtoCFQYd9fBNk/WB11xYLbFbdcXoOChdEWWmMT63xC7KdkPcEcgvn2nGbHFFF+nRdIKcfeABALrlNTIn8UvutXbBXVtn6PHODYm3ikaGvi0zB1zSR0iQQUdGDjM8e2TGREWpbaoa9DC5v5V4R1S8wp0hINKBflNdSs59HwblvFykLd+gzGVyhyToBJuK8YCsJQKBnGMx21vmKu2w3OCj5tzLPwY4wl8Fc1k1eDQHQMVLA8tXg+qLXDN1qOKWk2WlCsHi3WSlgJemvBwcJE4E8T28foPXAY4jxZbOJPn1JylkvdhuTVR35GlTOI6njShpAV2XiKNUm6MZn0JS8ojn3y+tzBxETZZgCH5flsNOYxQkIszkvjizV0Tj9pJFkWA2Al
 nYqvrp3F
 5tFrQmsV43MGV7+oTfzwtPDIuJ0qXNu3Zq8d8L24qGjEzVBN6FXfTssMdkWuNGdJWOIJa1HESIjOEOy5/d/sV+JApznPkw09PLGcfjY9RuoOBjjssyIAp/9ssRa6dz3H3IoFR4gqIbkOZ6GaK6dSa1nxb/vQm4Je4yCdwsGH2BwdbCsooiDkw99RODHYJXjsMXbL1XF1DstDspB+DPbyIrAEjKHSjrMtaj5S4qXv5fBzfv/+KYDfc1ACaL5/MKx1HJyfYwzghiPYqLh4750R84/PtaQjnk3Ss8ymIRpT/u2tv7sTlAybfsTDwx+It/yCRtUXIn1cfDtFP4rD3QdZnf+J0OsAaNp7+Qdx2LTzkzD581tmQsmZyXXWHZvl4xlr7vl1blOHwWoO+z9FnoXBjWRDwbDDpmY64A3LyqonIMVaFKCKPv0vc6iKB+CNwFvv6d/7Mje65UOrr2DJlSShpZCdEdvFLwWlxTfgw2vtR0ZMAIMSycqqyNo1uNn82+ZKE1rPaCfiKpb3ZQHM2AfTcYpFgmAGzJO5CzIvxCylkTnVezv56qaQ2QDknhWdRCF1Wl1cM5az2Dvr0h7ESG5y7FCLzTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 06, 2026 at 10:31:02AM -0700, Frank van der Linden wrote:
> On Fri, Apr 3, 2026 at 12:45 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On large machines, zone->lock is a scaling bottleneck for page
> > allocation. Two common patterns drive contention:
> >
> > 1. Affinity violations: pages are allocated on one CPU but freed on
> > another (jemalloc, exit, reclaim). The freeing CPU's PCP drains to
> > zone buddy, and the allocating CPU refills from zone buddy -- both
> > under zone->lock, defeating PCP batching entirely.
> >
> > 2. Concurrent exits: processes tearing down large address spaces
> > simultaneously overwhelm per-CPU PCP capacity, serializing on
> > zone->lock for overflow.
> >
> > Solution
> >
> > Extend the PCP to operate on whole pageblocks with ownership tracking.
> >
> > Each CPU claims pageblocks from the zone buddy and splits them
> > locally. Pages are tagged with their owning CPU, so frees route back
> > to the owner's PCP regardless of which CPU frees. This eliminates
> > affinity violations: the owner CPU's PCP absorbs both allocations and
> > frees for its blocks without touching zone->lock.
> >
> > It also shortens zone->lock hold time during drain and refill
> > cycles. Whole blocks are acquired under zone->lock and then split
> > outside of it. Affinity routing to the owning PCP on free enables
> > buddy merging outside the zone->lock as well; a bottom-up merge pass
> > runs under pcp->lock on drain, freeing larger chunks under zone->lock.
> >
> > PCP refill uses a four-phase approach:
> >
> > Phase 0: recover owned fragments previously drained to zone buddy.
> > Phase 1: claim whole pageblocks from zone buddy.
> > Phase 2: grab sub-pageblock chunks without migratetype stealing.
> > Phase 3: traditional __rmqueue() with migratetype fallback.
> >
> 
> Since the migrate type passed to rmqueue_bulk, where these changes
> are, is the PCP migratetype, this will prefer MIGRATE_MOVABLE more
> than before in the presence of MIGRATE_CMA pageblocks, right?
> 
> Currently, the CMA fallback is done when > 50% of free zone memory is
> MIGRATE_CMA. For a PCP list, this isn't strictly true of course, since
> grabbing a page of the PCP list doesn't do this check, and MIGRATE_CMA
> doesn't have its own PCP list. But since rmqueue_bulk does do it, I'm
> guessing the fallback still mostly adheres to that 50%.
> 
> With this change to rmqueue_bulk, it feels like it would prefer
> MIGRATE_MOVABLE more, since that is the mt passed to it (never
> MIGRATE_CMA), and the fallback is only done if the final phase is
> needed.
> 
> Have you tested this with a zone that has a large amount of CMA in it
> and checked the percentages?

Good catch. Yes, I think there are problems here wrt CMA:

Phase 0 does not recover CMA blocks when movable is requested. That
looks buggy. It should restore both block types.

Phase 1 grabbing whole new blocks actually does use __rmqueue(), so it
gets the CMA fallback.

Phase 2 scans freelists based on requested type. This looks buggy as
well. It should use the logic from the to of __rmqueue() to decide
whether to grab CMA chunks instead.

Phase 3 is the regular __rmqueue() path again, which honors it.

It doesn't look hard to fix, but I'll be sure to test that.

