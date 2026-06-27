Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53346C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 02:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B496B0088; Fri, 26 Jun 2026 22:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023766B008A; Fri, 26 Jun 2026 22:44:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7B7E6B0092; Fri, 26 Jun 2026 22:44:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C06486B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 22:44:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2AF071C2E77
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 02:44:24 +0000 (UTC)
X-FDA: 84924148848.18.4B57B7E
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id EC7EC20002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 02:44:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EUiBNUdO;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782528262;
	b=FgJPQ9oTWqlNwvzYaBQxnI0tnX3AI4FElhCLqCd0HZtK1WhRzlnVYCx/YfV2MSVLJ47vVd
	Pl2MWpUJB8lo7xEatdI1uf430ZAqtFHgVv9D4+ckzlCEMuqqddJSktHJH0n5acMBWartNc
	a8JIWxOhWoJFj1UBpVNe0IPioNGGYhM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782528262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q4KPW4hH3D8r4gcyvgnmYX50L3+RdAFR9wgu/2J4vTs=;
	b=E9sIMfiXkSmBGgG2sEDj4kvz7YyXuzCNwIpTOFhojYdt1vnKaCy5V/S5BGxs4yk0/kEBK9
	hZ/k/tqbxhrM5ly3obQcZJIE6i5tn8HAgoFZRRdS3wrrXFyc/mC7ZCH34OOkkNIbE8cA4r
	eD/6M4Lr/YrvldfRT3/3CJXoiemWrmA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EUiBNUdO;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 26 Jun 2026 19:44:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782528256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q4KPW4hH3D8r4gcyvgnmYX50L3+RdAFR9wgu/2J4vTs=;
	b=EUiBNUdOMI15HmF9eakHwkBkurQNCxW1mvBDj8rMqv/u9hizN1qwgLP1xY9GlHCuA4zeot
	VbIaVwqElV+XXVL5jQIF1B6Ih9fnXSpt2hCh4Q1+a80CTJI7s5n6pH2csjeGEkwMDAgxGl
	C5cnRiYOqGLUCT21eTcvNo6D8FZZw6Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, baoquan.he@linux.dev, chrisl@kernel.org, jp.kobryn@linux.dev, 
	kasong@tencent.com, liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, shikemeng@huaweicloud.com, 
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, youngjun.park@lge.com
Subject: Re: [PATCH v2 1/4] mm: avoid unnecessary lru drain for
 wp_can_reuse_anon_folio()
Message-ID: <aj83c5ix_YCFMU-M@linux.dev>
References: <20260623231635.43086-1-baohua@kernel.org>
 <20260623231635.43086-2-baohua@kernel.org>
 <bf2bbffa-dc68-4a3e-a8e6-1ad57c10255b@kernel.org>
 <CAGsJ_4wJ-2JFY4+ADf-Bn2PrbpvOnWeVwZY3unKnB=TZ71-hzQ@mail.gmail.com>
 <c4718e32-2baa-4dee-873c-7ab99f21ca4e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c4718e32-2baa-4dee-873c-7ab99f21ca4e@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: raze4kcb4dafqc8yoe1yxka36fok7r4z
X-Rspam-User: 
X-Rspamd-Queue-Id: EC7EC20002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782528260-937112
X-HE-Meta: U2FsdGVkX18ge8tHgW1J1lVJALLdtAkN2phEccmvd2Z60URoHfd/x4qFcbO424eQEHBrI4N7Ueo+01Ru/wdnjSmibJK1w8S2MOo9vubHbkOqgvwNVrCrlJwm2kD1fQirl3SpE6shaXaZku4bymkGIoaaUglnXTl324+Uy/dGdpXqTdrTOBvWyDHv5dgXmlEsp1/mikKgzJCbhl8poPo60KtYvRlaaZDhYwOoGnK2YufSh3jAZjFl865Ui5XLcoeQnwg3CdvrzPaiWWIhux0l771pCx/NkoebQEGcqPt8lc5KwnCvD41Ro6qM1W8GF66kuOnSuiiOr8oobkmDMestwmN4355EjGZC1v9zQi8/mhfyONiweqdyUeHt7r5Z00aF5XpamvoXfTlv16jr2S7RR9IJBhoFPuomMnvMWf96BMDWbqGsJt6/lD2YTMG7JGMlsSGCO4EoFwp6v99XSYuPOfkq7wL+uhTC2hv5mhnjivjTE/u5yOC2SpLH5OIg6yf155WffPyCcs8sB0oDfPgd71RVdcGYj0yN3NYMWZc3mhL3wpL9zkMiaCT4kzRwKLDMOImHyqngWtxdHjBDkevyF2fpDlkHH3PEOcYcCGFR6cL+PzfO7uPPDSLuDpwkhjjKzZ4yf16suEUg4Q8niKldlrnzJ2Zy2cpc2cYVIpCTlhchBr+qOOC4H/FyBVOQWKOqYRC6b2R28wXoYDIwesKTZtU8dOzPCZOKQeFlnfuu/5kTy4uZtxCy7MQo5zZjcK65GOHFD44/uqfeNO7SzhQA4t/N7YCcxIm4cqpI1J1jPdMbyCk+bEMm3ik71HpPEOidCB8gznqAS3kIw9gJiNvoDGBbUeHX+sG+b8vQAogo2Al2xjoAgJCUqDphY/iKkAxF8TPPQbeZZte01sv6uUITsw3lV7MpIBUJQ96y/KumkNRdMjTyyhrnghG3byOxPBa/TFqv6ki0QuYIwBhlEi7
 kRshsCnd
 977eBmv+Ul7oBvYYixvpX8ceMGGlVLMdrVHkeZUeShFBZqObjt9v238WU+MU07iNCMRv471/J2MHLf6xSTcv7kv/oRlPB1zgjTh//VpvNjqiptVA4Z5m/AKntaJdp4im6RMGg78DzGqAdIfDjeJTAV+G7X9RhmER1683ocaKbGNfLEPvCZR1g1zpRu0+pWDSkIAuy3tt/QAZahDmaO+VEQcYG4Lf/32GbPgZBrmq/g1qgNsrgO0dvOhWxR4PpsdlliTlLXry9cAN/bZdzpGtyHVDUOVQPZdNZKATwWXrcq9hrDXUg82XLSuWxCYS1nxv6FLeBuhyqhqetXeCXyw3CLXkRCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 06:25:48PM +0200, David Hildenbrand (Arm) wrote:
> On 6/24/26 23:04, Barry Song wrote:
> > On Wed, Jun 24, 2026 at 11:02 PM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 6/24/26 01:16, Barry Song (Xiaomi) wrote:
> >>> We always unconditionally drain the LRU before retrying anon folio
> >>> reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
> >>> are in lru_cache, and use the refcount to avoid many unnecessary LRU
> >>> drains.
> >>>
> >>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> >>> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> >>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> >>> ---
> >>>  mm/memory.c | 8 +++++++-
> >>>  1 file changed, 7 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/mm/memory.c b/mm/memory.c
> >>> index ff338c2abe92..f6848f4234a6 100644
> >>> --- a/mm/memory.c
> >>> +++ b/mm/memory.c
> >>> @@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
> >>>        */
> >>>       if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
> >>>               return false;
> >>> -     if (!folio_test_lru(folio))
> >>> +     if (!folio_test_lru(folio)) {
> >>> +             /*
> >>> +              * Assume folio is on lru_cache and holds a cache reference.
> >>> +              */
> >>> +             if (folio_ref_count(folio) > 2 + folio_test_swapcache(folio))
> >>> +                     return false;
> >>
> >> I'm not keen on making this function even uglier, so no, not like that.
> >>
> >> We have the earlier "folio_ref_count(folio) > 3" check.
> >>
> >> In which scenarios can you trigger this such that we would care?
> >>
> >> If the answer is "I don't know" there is no reason for a change.
> > 
> > As I replied to Shakeel in the v1 discussion [1], this can avoid a
> > large number of drains, both during Ubuntu boot and under normal
> > workloads:
> > 
> > "I booted the system into Ubuntu, and after
> 
> is this with this patch only?
> 
> > 
> > boot completed I observed:
> > 
> > wp_reuse_skipped_drain: 5542
> > do_swap_skipped_drain: 0
> > 
> > Then I built the kernel in a 1GB memcg using zRAM swap, and observed:
> > 
> > wp_reuse_skipped_drain: 25017
> > do_swap_skipped_drain: 43595
> 
> This is all data that belongs into this patch description, not hidden
> somewhere on the internet :)

I asked the same i.e. to include this information in the commit message [1].

[1] https://lore.kernel.org/linux-mm/ajK4N2zK3sPZFQuf@linux.dev/

> 
> 
> And why do we care about local draining? This is not a drain-all.

Let me take a stab at it. Local draining can potentially make the lru cache's
batching ineffective. The whole reason for lru caches is to batch the lru
operations to keep the lru lock contention low but if we keep draining
prematurely we will continue to make lru lock contention worse. This is
particularly bad for workloads which chrun a lot of LRU pages through
allocation, free and/or reclaim.



