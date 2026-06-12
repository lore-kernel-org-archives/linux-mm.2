Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E224CD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 01:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75D2F6B0005; Thu, 11 Jun 2026 21:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70E3F6B0088; Thu, 11 Jun 2026 21:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64AEF6B008C; Thu, 11 Jun 2026 21:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 55D346B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:08:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0469F12097F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:08:20 +0000 (UTC)
X-FDA: 84869474802.07.DB1005F
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 22BDD40005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:08:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l6fVwl9E;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781226499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZGr2v2BJyY5UICB7KiBteFIFz1E2P9OucbubOQfFQm0=;
	b=BmO0GFrqh7lcgWoQZE5KE66Xsd/nR+P4sxacwteZotzUSEowoPOvh8zebvSc7Q912g5y/R
	m4fzrNsCt0zWN2CpKobM7L+WqW+0eGnJF37hxVKBBdIQJMGlQIE6WdXxI+ZBJ+Z3A+KUoj
	gLf09IkHv5eGPtbZa+S7CraO5sftOjs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781226499;
	b=zf/pd/QuhGhzEekvgcTZ8T4oPvep3yT3jQYt+i/rT0AiIjJ8RRNApJSl3cQnyIngPkIb/7
	dEHnL2h1EVM1VA8nhB8WZP6WkTyrVBPphxzVYi/40rb3lVFyia51h6K2hYlSUsXlSgmg1P
	unkB+KccZPD/k1iQ8JFpmPP7OKLJ47Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l6fVwl9E;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 12 Jun 2026 09:08:09 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781226496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZGr2v2BJyY5UICB7KiBteFIFz1E2P9OucbubOQfFQm0=;
	b=l6fVwl9Ey051O4rVxfWBe+5o8epL5Px2k2IEkV9ILwV5bRkeWeue5g/nsNo6wq+3b9qbg8
	KwoEnEdJR07eKzDr4iBOcZbRsywGRzi6f2LRJo1zTZ+Gaj0U5KDtao8VLtQ+Cc4ZBc6nHG
	d8j1FORR+1dxgHgQgF7JC90AOB0T8II=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, youngjun.park@lge.com, jp.kobryn@linux.dev,
	usama.arif@linux.dev
Subject: Re: [RFC PATCH 1/3] mm: avoid unnecessary lru drain for
 wp_can_reuse_anon_folio()
Message-ID: <aitb-XwJ0gRiOqPW@MiWiFi-R3L-srv>
References: <20260611105124.98668-1-baohua@kernel.org>
 <20260611105124.98668-2-baohua@kernel.org>
 <air47cqcLUwI4D9X@linux.dev>
 <air7FCRQneIPiJ5l@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <air7FCRQneIPiJ5l@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 22BDD40005
X-Rspam-User: 
X-Stat-Signature: n53t4nww3uwcfz7a4ccfkm1pjq8jw74g
X-Rspamd-Server: rspam08
X-HE-Tag: 1781226498-827323
X-HE-Meta: U2FsdGVkX19UweN7x+FiV9uObidNKmUDQhapjjgFgPeeMbHAIitMMvb6rih9W9hlCzywocqmAILnEuoAG0fFTGFKueRpTf0D3eiu8kDwAExnAu0e6i5mZOZqgpEUMjUt5S/IGXOO12x7IlZuK+ooiydL7zjv4xzGc3ap1cjVujvQyvla2l8BTPF9DDra9Cbs6AWCDFUKIJsKfgM6/mDJCzUZIKtSyEYz93GqHr6clfXFvpYVPsv1tYFQ9026XUh4gnnevfHr2g2TkNZxe+fmGh617smm7kW0UDRQc3hqAlUbaezYT0uXc3gYbfmUv/dIcYzUwB0ytgUzNVqjKxiXpNd11mRfjf3+zAVu3xoREnJC6xZfSD6X4nXB1VSg7wBDYwjDrQ1C+lkuRTwKFYfdXfgJHXV5VoSoC+qhz87mDkauDE2Ilf/3V1Ck992gfkmtCJ7AecIV6EyV5lwUFAwpCpihnXT146HZsyqNj5J0XZEaOEbCnpgQqSpLWNRVjWufGIFsq4deOqd7GjGhOD9r0VJ7ie6TRWP03alksLXPs4sCVJPFXJWYOn3otBQDDt404ClZw0XeBRgSJAymI0CUZGz2btzk6EvPmDd40aYGoPZzfSKYimHDDuKy17p8mpmhgX/7onl1qTs860NoLzheSdhP9E/6T2D5mQraDbcuuIaEXGT/J+wdYv1LGiteR67bNLa0kHbTOopUOzcCPQArj1lC6ibq8yAZWb/0QQ+40WOwfyhTYRF/F9cnGs8zni/r3AvRkxVlZgSOtKbrZwG//a8XkA7p+BkHLUS/z2CltpesJry4qEgJKGh4jFtluxIOPTLy1Z95nQfXB4lLPUtbODthtUOXZc3ByDi6+OPeqJSc2mWBC/++KRyvAIaRFaGInT+sfYLRlNSy++VGr6kQrgjGAU7PjBwGUnrpVo1M03AcLVkLZjyrccZMjrLTFmsR1FZqIZ19BTK0BvkxClk
 2CFWuHDF
 dnHDRF/AXR2WCbA8SYaYBjZpwTPdCkQFBrnXJQ7MekIQ/1yWM6FQyRvH955jpQ6G5Tay7s5I6I1Rx3G7j7MiH3jnZVfl0b0nZr8Yx9D+uy7ZuwHNGa4FbLmbfs7Y6LfOJcyGSspLsd2N2263/IzWh2xdLFtdvfAIYYiFfDujLwGTUpAFmBEbBxwWnEXTICef7qSUJFXVGVbky5ChnCVRgPTKoEPUcRJ6Y53rg2sv/GMTqBTPojERen3FGczH8FMZ5r1xZIsPJa1xqyDx6QLyi/UASeaR0ZKEXMB2qavJOhLofuSb4wzofY/Jid78SQ9tTQUoB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/11/26 at 11:17am, Shakeel Butt wrote:
> On Thu, Jun 11, 2026 at 11:09:43AM -0700, Shakeel Butt wrote:
> > On Thu, Jun 11, 2026 at 06:51:22PM +0800, Barry Song (Xiaomi) wrote:
> > > We always unconditionally drain the LRU before retrying anon folio
> > > reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
> > > are in lru_cache, and use the refcount to avoid many unnecessary LRU
> > > drains.
> > > 
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > ---
> > >  mm/memory.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 56be920c56d7..487a34377a7b 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
> > >  	 */
> > >  	if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
> > >  		return false;
> > > -	if (!folio_test_lru(folio))
> > > +	if (!folio_test_lru(folio)) {
> > > +		/*
> > > +		 * Assume folio is on lru_cache and holds a cache reference.
> > > +		 */
> > > +		if (folio_ref_count(folio) > 2 + folio_test_swapcache(folio))
> > > +			return false;
> > 
> > In your experiments, how much amount of drains were reduced due to this specific
> > check?
> > 
> > I wonder if that data can motivate to introduce lru_add_drain_folio(folio) which
> > only drains if the given folio is in the local lru_add cache.
> 
> Actually if we can peek into lru_add cache and folio_ref_count(folio) is exactly
> equal to (2 + folio_test_swapcache(folio)) and folio is not on LRU then we can
> just reuse folio if it is in lru_add cache without draining, right?

Sounds more reasonable if we can only touch the wanted folio if it
exists in pvec. Believe it can improve efficiency more than the
current patch.

> 
> > 
> > >  		/*
> > >  		 * We cannot easily detect+handle references from
> > >  		 * remote LRU caches or references to LRU folios.
> > >  		 */
> > >  		lru_add_drain();
> > > +	}
> > >  	if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
> > >  		return false;
> > >  	if (!folio_trylock(folio))
> > > -- 
> > > 2.39.3 (Apple Git-146)
> > > 

