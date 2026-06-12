Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3B2ACD98C7
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 01:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7305B6B0005; Thu, 11 Jun 2026 21:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708626B0088; Thu, 11 Jun 2026 21:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6448B6B008C; Thu, 11 Jun 2026 21:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53A7F6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:57:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D80721C2D92
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:57:56 +0000 (UTC)
X-FDA: 84869599752.28.BF8C961
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id E26501C000F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:57:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eLN28x5A;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781229475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/skfuVKSxbkG2SDfb0qNhS3YER2w4ultlVQGZi0Tbus=;
	b=uPb4rXrPlbSNveQWM9TyNpj0nWJiDFVF+PIBqBCjshKIjV+VrHNaZxOi2pn/zNC2p6HIPX
	v/wMmr8pNHUW9yVCy+W3goZX6dUHZ9N5O4r23jIB5FWzAQakkLrcs+9hgczUypyJvHQvPH
	ASBbbH8GST2p7HqVx6euvT7ReiXCggk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eLN28x5A;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781229475;
	b=GSxIcF8CHmF3xZHHPMeXgf7flzGcijjJo01ZstGsyyr4Glv5ka58QzFfKGgdBBRNg6wPnO
	S0h0ZsHA2pWtdGLMgKFsD3HmzMonNGXeRTOJBsq0HXkKiIxspM7ZSCSbkopu7XCNWqUnXm
	q5rsUK7n36Yk8SQWFGLaaEKHDM5Ask4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B6BD43EA6
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63021F0155B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781229473;
	bh=/skfuVKSxbkG2SDfb0qNhS3YER2w4ultlVQGZi0Tbus=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eLN28x5AoDg4tuwsQWArwOFMO/MSSEgvVqK6JPQlRWYaZqf5T9IcfTLJrrDPXmqAC
	 I4DJBZAIRDEHWfJ3BYGFUD2Bw5z7yJWEP5PSA2Qogk2jONh0+6dVuOMK59VW1Q463r
	 xKu53SDG9DmiIeEY6R8wvikw3OMPOassAvmL6BAI68RiPQa6LhrQZfMXgktFOTANyA
	 CENU4y6xsrBkr0I7iKerhcKoBkjxE4Ck9g+aAxe+FC1jO/TpIf+pHT22e8JHFWw/q5
	 dkN0Mdn2o1bV57eVRAujpg1McpiRo2zbTxipt7lPq8LTL6sfq/bAHfkGijMpE3cSXL
	 chAy4Q0K2L0PA==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-9157b94a07aso48809585a.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:57:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8vFuW3XpWTaOJvfZwLcHq4ziU8Byrp9CUZkpaU3EW2Wg7MIG8aBmJ/yLsNC0NWdmVy4JKAGGDstQ==@kvack.org
X-Gm-Message-State: AOJu0Yz1oXxBeS2Pd1tEQNmIS052wdciOUXT1ZZczzskKTttMhcVvoEV
	RufzF4vk5JBuaVwNPNxWxSR0A4M23PNxmqja2dUOwirwhx8W5bJQRJgoR/trhF4zMcqm9pCH5uB
	vExD42IkwJzJSZPbypJEn+o6QV9CtfSo=
X-Received: by 2002:a05:620a:371a:b0:914:7e9a:2716 with SMTP id
 af79cd13be357-9161bd15d74mr94748485a.38.1781229473239; Thu, 11 Jun 2026
 18:57:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260611105124.98668-1-baohua@kernel.org> <20260611105124.98668-2-baohua@kernel.org>
 <air47cqcLUwI4D9X@linux.dev> <air7FCRQneIPiJ5l@linux.dev> <aitb-XwJ0gRiOqPW@MiWiFi-R3L-srv>
In-Reply-To: <aitb-XwJ0gRiOqPW@MiWiFi-R3L-srv>
From: Barry Song <baohua@kernel.org>
Date: Fri, 12 Jun 2026 09:57:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yFgcvpTAZ_YV73+U=BEnOiSxaFtGNFpbf0DWBkVcOQ3Q@mail.gmail.com>
X-Gm-Features: AVVi8Ccf85LDVHORUp3k3w4g8LmEQLGA-zF2jAliVwzkNRmZ5VToIb8FUCN1_Iw
Message-ID: <CAGsJ_4yFgcvpTAZ_YV73+U=BEnOiSxaFtGNFpbf0DWBkVcOQ3Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
To: Baoquan He <baoquan.he@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, youngjun.park@lge.com, 
	jp.kobryn@linux.dev, usama.arif@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E26501C000F
X-Stat-Signature: r3k4dxgyws338jb9jcdn6bjkqtcj9ch5
X-Rspam-User: 
X-HE-Tag: 1781229474-207050
X-HE-Meta: U2FsdGVkX1+k+Y9e69Lmgf1jW044mwcKzftJavjevXENzozMwKhr7uVI1649T6YTx09yoTZOQ97pEdRCExm6Jl6Pl8oE5SvyN/AQHGvGNgiul6rSWW9ua1AuyminsnPmwhHg2qtkz6Qe0RD9EBsemxkAReI0ZcFaXBYYoIkIZc19G19TvNulFv2tGAoymWaN9JSYdtMoTxvjLIzW8hOV80Bzjl9xr9IFl2qwDWxrl38hxo49rI8SimIe8p81BsEnL/+19GGjWZ/I33a4URCzGc/rxjVQYFgHuKMdXzZVExALvCfBrxBiIwCelaD3LNxBjBjA77Mglntn4TC3+4eqfr2edClsto1IEppEucB1/nhFzXftnwQ0mQ/OaGh5XDBYMp1U3RoU44hewVdYVrTGJQYkF7pjmHKLZIYNXXkMxMXxhN7cNNI3gFv651qJyhS02AI5qOg1c4P/vXwQXd/hJtsHDVdw0sD4+zIhYVOdQkD2j5JwSJI+vKgrA+7kyZL1cap1XfygbKzU4JirXaQHXSscSuaKvs7U3yblrR+WhR/WV3c3E9hdGjIz8cmKfJK1iI+OYU0qg8oUkOlb54aypwLz4fX0bND1Ac0ZoS7UFU/p7xTDsmQjfiAijGLs9NWoyao/I7xSRI9iOzk8deEYGst1mtUoo0BIZxQTWxyvSfacOUMVZIJawJPIrCKXo144HvHrXwsjaVXXAfpQa4OkkTazjjzsV+s9NuLuscTP7YSBSqHqDpugd7EJOwaM46jD2Den4RwD/VASamuuih4bT10nGyIxzYZ+J3G9TuVNN6KSfkarwpiAw0t+JVZ+pl/T5lnkZZ51g9jmGLySBXNVX6175x/R2YGGhwXD6k+12h3j1urbbVh7r3cWNAcDXJ0C3ixGDKpejmPXof9H9LL2magF+N+4veWDK9nSlQB5mhYbWWHPSd21tRcSbK61siyrg/y3UyjrR1uV5SYZtky
 n+DtEl04
 InLS+okFOHGalQ3SG7qK+cFnCrS8RaZIJUjQj9ra3sv0/lFS0GGAsdHlfVLvez9r7SDySLxsvNIXmvWgtAZZB1x8LVb4DWgNe0BbzDXc882P7+TqeVcaZZxj8lIcroWrl3xApyh+gFgN1C33eFNhJOn131o3RqCsUyMay+QBnXgosAI9pWZKhA9NMAgGJq6xkGbC7FXAKFsa5Cs3MpsmL9waFas6Zi/Vp69qpx3hBrOkeZWrXm3NbYFOOa5jOI0y3iw5RRwE3HmIumlDbmkBAB6iuEbHvgqj99v3OMSEAQEB5O/WmMhNKosaG4F2z0VHWyy+ArDoXtRUCwAsdwF8y5g5+nbBHE7AcddD8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 9:08=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> On 06/11/26 at 11:17am, Shakeel Butt wrote:
> > On Thu, Jun 11, 2026 at 11:09:43AM -0700, Shakeel Butt wrote:
> > > On Thu, Jun 11, 2026 at 06:51:22PM +0800, Barry Song (Xiaomi) wrote:
> > > > We always unconditionally drain the LRU before retrying anon folio
> > > > reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folio=
s
> > > > are in lru_cache, and use the refcount to avoid many unnecessary LR=
U
> > > > drains.
> > > >
> > > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > > ---
> > > >  mm/memory.c | 8 +++++++-
> > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/mm/memory.c b/mm/memory.c
> > > > index 56be920c56d7..487a34377a7b 100644
> > > > --- a/mm/memory.c
> > > > +++ b/mm/memory.c
> > > > @@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct =
folio *folio,
> > > >    */
> > > >   if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
> > > >           return false;
> > > > - if (!folio_test_lru(folio))
> > > > + if (!folio_test_lru(folio)) {
> > > > +         /*
> > > > +          * Assume folio is on lru_cache and holds a cache referen=
ce.
> > > > +          */
> > > > +         if (folio_ref_count(folio) > 2 + folio_test_swapcache(fol=
io))
> > > > +                 return false;
> > >
> > > In your experiments, how much amount of drains were reduced due to th=
is specific
> > > check?
> > >
> > > I wonder if that data can motivate to introduce lru_add_drain_folio(f=
olio) which
> > > only drains if the given folio is in the local lru_add cache.
> >
> > Actually if we can peek into lru_add cache and folio_ref_count(folio) i=
s exactly
> > equal to (2 + folio_test_swapcache(folio)) and folio is not on LRU then=
 we can
> > just reuse folio if it is in lru_add cache without draining, right?
>
> Sounds more reasonable if we can only touch the wanted folio if it
> exists in pvec. Believe it can improve efficiency more than the
> current patch.
>

Technically yes, but in practice it seems quite hard. As I explained
to Shakeel, we don't have an easy way to determine whether a folio is
sitting in the lru_cache. !folio_test_lru(folio) only tells us that
the folio may either have been removed from the LRU or still be
sitting in the lru_cache; it does not distinguish between the two.
Unless we want to scan the lru_cache to look up the folio, we may need
a dedicated folio flag, similar to PG_lru, to indicate lru_cache
membership -
I guess people would be quite unhappy about adding a new flag?

On the other hand, the folio may be sitting in the lru_cache of
another CPU, which the current drain cannot flush. As things stand
today, the drain only succeeds if the folio happens to be queued on
the current CPU's lru_cache, giving it roughly a 1/nr_cpus chance of
working. drain_all would clearly be too expensive to avoid.

So another possibility is to drop this drain as well. The folio can
be released later, at the cost of missing some opportunities for
reuse.

Best Regards
Barry

