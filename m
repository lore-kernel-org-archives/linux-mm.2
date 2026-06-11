Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AE73CD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 18:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6F76B0005; Thu, 11 Jun 2026 14:17:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877996B0088; Thu, 11 Jun 2026 14:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78CE56B008C; Thu, 11 Jun 2026 14:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 667D66B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:17:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62765C27E7
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:17:58 +0000 (UTC)
X-FDA: 84868440636.05.D9FA82A
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 02ACE160014
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:17:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f707A22u;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781201876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJahH7bi7p54My4ngEqhVqPUzIy3QVfHqPFP00P3Ubc=;
	b=opcUCcIiSaxI0DIMu9T7ippaTLpnGC0IJ6lWXULuPJmHTpyYxRi9j/iXk5QwImVQtyPdbE
	Ibt0LWuww/D66gdxEb73n3IA0vLyjzRGY2H/wmzQPbdFMkDIZjOHntzKULl9GCWLvJjNQj
	pH22ssKm1p1J+TpH93MSWi+vzzua868=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f707A22u;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781201876;
	b=swF5vDUt8XhAFx0aWeZZP96ZmZeIUidD5Q91W9RSMRByOTUX57G24vN3I5nLQYiqw+p8zI
	zk31VjO1W805UDoTms1uEUx7KP9TBJNdnK3iuYTRGL3/iKPzNvrs7bNV3uofbckCJmddkZ
	BpYLfpZsECIKxnz+WXEXph85Bj/wvds=
Date: Thu, 11 Jun 2026 11:17:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781201874;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kJahH7bi7p54My4ngEqhVqPUzIy3QVfHqPFP00P3Ubc=;
	b=f707A22u/gqQWW76SSYWqEFLd5gh415tfmwesriF5tQHagCkqWl/hcr5JQQsfG/74tRZdB
	ca8puMAQwZNDUgjvWsSjduUQguens3Yh1zFacyu8C2VdshUuoN9n04IALTKFSb2zuDHg2y
	3FlMhf6eiALduNaNbAUkX+wR0iqkqTo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, jp.kobryn@linux.dev, usama.arif@linux.dev
Subject: Re: [RFC PATCH 1/3] mm: avoid unnecessary lru drain for
 wp_can_reuse_anon_folio()
Message-ID: <air7FCRQneIPiJ5l@linux.dev>
References: <20260611105124.98668-1-baohua@kernel.org>
 <20260611105124.98668-2-baohua@kernel.org>
 <air47cqcLUwI4D9X@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <air47cqcLUwI4D9X@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: cbhbygj8kdz61qzy1kfwa84p4a738azw
X-Rspamd-Queue-Id: 02ACE160014
X-HE-Tag: 1781201875-980600
X-HE-Meta: U2FsdGVkX1+G1BiQTywSWwDSXuYsSiJpUtEwQhH21e58vH8sC3n5nTzjZYoiu2sLNXdNzS/5ymeHTpRPo+r1Zw0ol74iZ2LL3uLwVKOZFbB/HCms6uBh4nx+KAj/z8k1vXmda2WnYnoGKUcEU8gg8kEGMw1z1M9Fk5ScQBduScjp5bVlWa5skIFf6YM1IlXker02/vIlgyJ9RPW6C42+0WVeo0HzEix3c/22U14ov+mp27H977U9+2o7AGPTvck8yEFJJx5igRI8Sux8O8KaZjbvt6KNc6L2H31E6a4tyQDPacEqsDbLzMD8JjS10X6I6ISCWzpgNfamFtXDblGGaQ9u9WWAdUijbHF7IqR0wGYCIlHl+Vp9qB6/SsB+ZDfIKqPQ8IBZHEjjE94txBh+Xy796I/cWearx8zHHioDPSHUAvRZ0hel4T1w9D47z8neHnVoCHcivMjUNqbI0dsixOXgY30fG8yXzICNJwqM/dvg6H82sWkNIUfyNOKFMFDW4o6jwBdscYvCvMRE1PxfyPHuBfxfeobRn2zObJmjBuoITGyjqmRUtQ/Wcy/KEBVJ/G3Xf7sI6FTOEzFSb8uAJYAmyT3++aNRjfK1UCMWb/NNuSEaIo2g+bLV/uL9EP/V8kUFaM2WYm0ObcdJI1a9svaA1jvdFSL1C7uShGhopd1admg4XvcDuqCRKv4SP2Cr9AMUfJETmaZgf+VxPLdTcQjdlvgSU4y4i+/5JFWGLUb+tLC/VvsRPWLwUVg975ooJjdk1G+QQtIJy90Rl0cVB7CdMLTGRsOLAJfhIvk+46Vu4PYLzZYo6CisM4ZZ0NWeOLL4i37739DHV0ENaNrh2j39uH4xSmu5TJpbg5l/A/T6JxytNMXmalYF4eM5AOTQ4gykQne7NFw7giMPH2fhrO15NyoXAbbpKRuaN3bWDnORWY/NBhIhCMpD3r5Tqp1XSbIrN77GzEIqf9y9kRd
 sJDoTCDP
 FFqWy1Nm9QSZtqSkmyIH7PiF8vo+ow0Fsn00cyBjDhJ3Uk53+MD7JDfDuTea3fXxPkhtgmZiu7O6JOdcTl6a+g87OTkpOnQgjKbiqyr23X7bHmzLbLXl9kBFUZ3sI++imBVGELz5+6hGVysixVI4Mj8WcSDnr7FIOJtWNvsHpKERt+uAQqT2QUY1wGgYf1iU8tidGZVCqg4ON6YmfrVC/mTSymqBtlYm2xyMC0NXRQf8y39Zb7xlkmZFSKCASDiQmHGuyzb7i6pNQXnT5YnTlKmLgEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 11:09:43AM -0700, Shakeel Butt wrote:
> On Thu, Jun 11, 2026 at 06:51:22PM +0800, Barry Song (Xiaomi) wrote:
> > We always unconditionally drain the LRU before retrying anon folio
> > reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
> > are in lru_cache, and use the refcount to avoid many unnecessary LRU
> > drains.
> > 
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/memory.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 56be920c56d7..487a34377a7b 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
> >  	 */
> >  	if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
> >  		return false;
> > -	if (!folio_test_lru(folio))
> > +	if (!folio_test_lru(folio)) {
> > +		/*
> > +		 * Assume folio is on lru_cache and holds a cache reference.
> > +		 */
> > +		if (folio_ref_count(folio) > 2 + folio_test_swapcache(folio))
> > +			return false;
> 
> In your experiments, how much amount of drains were reduced due to this specific
> check?
> 
> I wonder if that data can motivate to introduce lru_add_drain_folio(folio) which
> only drains if the given folio is in the local lru_add cache.

Actually if we can peek into lru_add cache and folio_ref_count(folio) is exactly
equal to (2 + folio_test_swapcache(folio)) and folio is not on LRU then we can
just reuse folio if it is in lru_add cache without draining, right?

> 
> >  		/*
> >  		 * We cannot easily detect+handle references from
> >  		 * remote LRU caches or references to LRU folios.
> >  		 */
> >  		lru_add_drain();
> > +	}
> >  	if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
> >  		return false;
> >  	if (!folio_trylock(folio))
> > -- 
> > 2.39.3 (Apple Git-146)
> > 

