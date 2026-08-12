Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4505AC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 23:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FBF6B0179; Wed, 12 Aug 2026 19:46:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D0836B0182; Wed, 12 Aug 2026 19:46:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F01816B0184; Wed, 12 Aug 2026 19:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C489F6B0179
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:46:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F6FC160478
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:46:19 +0000 (UTC)
X-FDA: 85094253678.07.7CBC297
Received: from mta0.migadu.com (out-16.mta0.migadu.com [91.218.175.16])
	by imf23.hostedemail.com (Postfix) with ESMTP id F0360140005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:46:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pjReRsjU;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.16 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786578377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vxBH6Yw1jzGIgpGxwTg61Xu1HIIQyFKAXsqc4GMuFTM=;
	b=LVNPxhhiqpPWRVsshM7ajFqit/9Sc1v23nVtpqTeQnfg3Mqqqm/Zey1s0Ow2zD13J/COt8
	xzAFbxa045wASVastNitENpeFTJABEsfIvEeItA+kVm5cB/LqyTig+UXdaVYADlE1IZ9pj
	apSFBIm4QJ5+VpQKPyw3PQcRqRzO5Yw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786578377;
	b=rV23LmZAstEyyUV9A3zlk6mwNThgA/XeYipF5rdBXeo7HAq8LpIUfRL4fWnrsr+tsJQM1L
	8pRfyYY9/u3WSFUD8R3jQnrCr4LLJ+3uOtB/UBTk4dYiA8/H7R5/X2a7GZAyWGnknicqSR
	7DwdKeIVqHAXtPVlvBMzHjDWFFrZloc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pjReRsjU;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.16 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Suug6ZlLMRpt7AO3wExksttzRhjDowxSc/U7ICXnYsU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786578375; v=1; x=1787183175;
 b=pjReRsjUK7CyUIS/VWoH+vfERRzp+sncklUeXxXGg039MQaOLBKWvmxHiWiIB9PpQk7B6M7o
 rUFReJpRTI1SB1NQnLvEAQTtd9cNR4zi3cXXj5vMCA5K96QLQc5l+UiL37kw+K544UKsO0vaCGW
 rlJereWzZsS0ManoIwk1Vya8=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:a::)
	by smtp.migadu.com with ESMTPS id cf2368f0b44ab78b;
	Wed, 12 Aug 2026 23:46:15 +0000
X-Migadu-Flow: FLOW_OUT
Date: Wed, 12 Aug 2026 16:46:09 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Ridong <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cui.tao@linux.dev, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 1/2] memcg: acquire peaks_lock when reading memory.peak
Message-ID: <an0Fp5HVk4xVtrSk@linux.dev>
References: <20260807090000.1532495-1-ridong.chen@linux.dev>
 <20260807090000.1532495-2-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807090000.1532495-2-ridong.chen@linux.dev>
X-Rspam-User: 
X-Stat-Signature: hbiwwrnfz5h4dr49xuazwms8eqzaw6oo
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F0360140005
X-HE-Tag: 1786578376-296477
X-HE-Meta: U2FsdGVkX1+d97Nb3YzNRXoccTQ9ni/VjXp+oRPbgu0DNiL1UFHHr6fYPMkSE1jIqjO+ohFWbEPzi/ZGdb7/sHpTfCQZZA/jjMUiN57eLbRB35qh79DzuP/vG+WbBdf5c8bVEnPKzbv7PtgJIpHCiTG5VMaMisu6c01JE1aT/+YvSd1MG5lEWq9u9p2/GDL9Wt4SGt4S8ZJzVKddCMU3W1ABN/azvA1eKZe4mLmBod0bDSPyNHBplWLLixJwEvo4fSuwUn7Q4+qtyVAXOrvEpAe8GY4WAX7QgQ9MpPUOYlwfNnyfBqQSjMmnmKhp6uTN71AV2UxseSs19eSbvWMY/FhHWNyBeBh+76DyKDw+iB4sVSFmDQtaMlj02WhwHmK36maDIfBnS9VI1SFQakG7Zjt3qs9j1pmmO9LA8Id5xYhDdSQJVdE5KdsubG+e7VAle3WEjV7lVD6w6t9VxlFEq7we+Z4xXzyoMF938Qre6IEZNOEGHc+D0OISnTBPa1J4KJ42pduGz9PieYv65B4+Oh/DBV8JmrreUfWz2sTP3PbtdcUwOmckqWEnAs1kWR9F8B0qyTSL6ypKuW4YuWBDBCvzlUXbBjDGSmyndZ+juvbqRXpgJI97q0nRYlaEA5yrmNXmJKLOu1lxE2LAZOZ/PVYFlmPJS3hu8bnQo0rs42nWW5HvSUWf8EOTHplVANfGcs+ipt2QrAQGZlEVByjuM7dj2NNQlw4DlEATDTusbcO8lF236G6ECo01xS2sfOb2yYsOVVbsvxOdJ1ZqFFGzpodc1537cCkELGck3fD7nFLW9WhaDRjzDIpafRsAcZLlJXshpa9wg880FEC2v2wD1RUC+nfQZsw09neWGneuIlQzx3D8kSaBLzVlBIAFRc3MCi0KY75WTG22yMhLSEKdml/4APZBGNgrUh1/EF3aT4Eqks6MNoHeB/V+msPQrcLemsYwdXD7ZeiNbsutr4X
 ZIOKKy7h
 T89ayoGPtYfz3clMXKjx8ZMckIuPhNM8oyBb+c3yzYQYDEKsf+pUA8patjzU0rUJrIMMDeQ/PDd6rBZEH4+Me5yGRy+8qzc+wek437yf/wFC12xezkGwXD+rtkjGVwGGjjqGA5IX0w8j+cDQug+C5WyV8FUpj4Syp4qACsziscKRJxdBRQVfR4S0hw+IhM+akS4b6Vw4HV6gWEsQPROY7rn5TQg6bwFHWUsdjVRbo4bO+NJ5gXsGuTsX2CIfUGcQv4jtX5mINQZcd/jbfndD+KRXQKmKxd13dBaee92uq3u8bSec7Dw1ML6iBLRVnwtVI0G9mxHHlrLujnvNEZ31BwYSY50bV44qZjgxJKrTyMgnFUu/bVUlf9HRvrBXhtGEbdnhbJFns8mIs2ahNjFdhbqMLt4PNYIvHFbSFRTrAM2VaXg2XhW2Rl3W6T6Xd20dMWfV2s1l23SSI9sIa71BkhLvs/alGkY1I5woo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 04:59:59PM +0800, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Sashiko reported that a reader can transiently observe a lower peak
> within a race window [1]. peak_show() returns
> max(local_watermark, ofp->value), but peak_write() updates those two
> under peaks_lock while the reader takes no lock. The interleaving is:
> 
>   writer (reset on fd A)                 reader (fd B)
>   ----------------------                 -------------
>   usage = page_counter_read(pc)
>   WRITE_ONCE(local_watermark, usage)
>   // watermark lowered to usage
>                                          lw  = READ_ONCE(local_watermark)
>                                          // sees the lowered usage
>                                          val = READ_ONCE(ofp->value)
>                                          // B's value not updated yet
>                                          return max(lw, val)
>                                          // both low -> low peak
>   WRITE_ONCE(peer_ctx->value, usage)
>   // B updated, but too late
> 
> Fix it by acquiring peaks_lock when reading the peak, so the reader sees
> a consistent snapshot of local_watermark and the per-fd values. The same
> race applies to memory.swap.peak, which shares peaks_lock and the
> peak_write() path, so take the lock there as well.
> 
> [1] https://sashiko.dev/#/patchset/20260730115314.1069089-1-ridong.chen@linux.dev?part=1
> Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

