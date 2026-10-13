Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28CFACC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 20:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38556B0088; Tue, 13 Oct 2026 16:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0FBC6B008A; Tue, 13 Oct 2026 16:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B29116B008C; Tue, 13 Oct 2026 16:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 858636B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:56:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 230E640249
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:56:18 +0000 (UTC)
X-FDA: 85318810836.16.882315E
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf20.hostedemail.com (Postfix) with ESMTP id 506F51C0003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:56:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gU1xMJlw;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791924976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GmAAfYOVTPwFY/Zg7H8+euLMsz6Hvgkde2NCZqpx35U=;
	b=duqnwn3jLbS6DwuBlJWwaoo4qPaJrjSHfxESvdK3/OM2x8E1QuJtFm8pD4xjOvC2zUbo7q
	8nLwWWtRRPTKly3OcjJETxZ+NWqh/W3a+IYcCWJ9PK6FRx4MDA5Z/HNL5nNYUz8RyOUttT
	HJi3K/vWB8q3sjgnVB2cEzPnQSgfChg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gU1xMJlw;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791924976;
	b=GLZXgPz6Z7XW8j1gDSQxz5hn0L7eIjF6EvleC/e3zEcAoljqBxqtBCU6SPIB3BGBy9OKNd
	fMSDkjuB/5GyTZ1xcu1RfeS6UcLZ6OVflycVkVxw5N+tTyiYSJ+PDY4jtvgYmvf1JfPgwW
	Xk81Y0WZoHt/IlNhzoacrToq5DVIl98=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-919abb3335fso41002526d6.0
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791924975; x=1792529775; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GmAAfYOVTPwFY/Zg7H8+euLMsz6Hvgkde2NCZqpx35U=;
        b=gU1xMJlwug9pFPPHVuQTRcN04U1GkqfOe0OIp9A1Vu7Hck0M+fSoSLX1VNhFn1NOdK
         kMR/iZwwHxaLckX/YGUYyQ5jpSKLpEHPVcLzsfVnGwIwTPYRL15gv94i1ke61HFtIZ7k
         mEVg8BQzFlPG1BlLek/Ca7P6PYGLb1WfiE/5+O91uZih+JnFps1q5GGqY/Azt7nBpXCm
         VFli+GUmggcg95HCPNI9hWUaAP1XLpZ1sqbCgK1qK0PryHxp+TCbIQieuwb+gCgS/Acc
         26Tk4vulzTlWmxnNWOme/4axpIfbseuWHOg4BWZsGq680H1Puolz0aYe3D4HmJCq6oTr
         4LiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791924975; x=1792529775;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GmAAfYOVTPwFY/Zg7H8+euLMsz6Hvgkde2NCZqpx35U=;
        b=x36j4iGBsdyRpN3dNk+4HJaA9GSP1Bxqw3it+5BMFpnGPRtX7BiwsktV91YYhovU5q
         IlhlnNrgMohFCX7mLj2XhQV0v0wX+A1ZH7VBfj1uYl/xSB66io9yWoI2ywX2Y78muvr8
         ScxJhEBSshe3i3w8/4/RNdHpP8ZwzFwlQj+sqW7DvnPHsSmoKBasqFFyiVKZpe70Lc9q
         NXNVdO56HNgcvKx81cciughmrQbD3lh63+Y0GZ0vXMYeXjozg90BFCvIu8D2ffXBtYkh
         E5ZGGCzTCtWcw+ev8efDEArCO18mQcmqI8Apy7DPRpcjZSO0mRBygZm4CBvUWKjnswRo
         CBhA==
X-Forwarded-Encrypted: i=1; AKwUvByyNhLc9sEyohGrcsjP2HZN61Wvuxd600vaxfDBUIdO11acVsVo3WgkiM4CsIg7nzbppZA/m2tjDw==@kvack.org
X-Gm-Message-State: AFq9FYLdtLWsRuSF5vVUuRDjRzx/qyxktIeA8KEf+4PGWEV8XCI9cHyG
	mbIGg2VDPflRY045OJFi4ihnwZ7c+GFCJWESFpjpHRpobgcHReVxKPX0NC1xxRbjAEs=
X-Gm-Gg: AYBFou3JG4hEyitjdFXO95UW8RltkhYzZw86fJ6W5UnBwHzA7DskOf4AK8wRzZDda5I
	Lto6/lROJqxOqMHR5phMzufSOPOlEH2aHbmbyfKPIOUcc0NIQUSsAWWnixuhvFbJrmltFfTtCIF
	yGJqUYHo5i+UKlvHnTcslSM/Wivkb1JKAM0kNOgqUhZ2kzcIuXZaO8ilzmHYbDNqLlP9THcfbfA
	rTzxYgDfIF85Cl3NJ6NIGy3+zgxnouW+QhWnsEgWFwZAYu+lnMX0BzpfqvPEuglgVeji3gVYXAN
	iG66uKIynBYF66LrNWy6RseZQwa3ip2Kmoo5GwLvzXkBr848k82ylymbA7DyhYudXYXRp6t7/cn
	GBZRXg0HM0TB4KPUV/2+TS0g1P1i41Bgwfw2NnJ7+1378lxJPggnPWu3rkEsKRL46xeNBls1u4I
	Mo7z1+SRJwGkiCfjTlMm/xG/SARimXqEgSnwThKoT8sXhIUd76NP1dmUc/3OmLoaLtYMDms10aF
	1WDm9/WB+R0Z8/K3f3ShpJ1sSZnJHvjWc2ImeSH/RFOoihRd5RCUFU=
X-Received: by 2002:a05:620a:46a9:b0:93e:7939:acd0 with SMTP id af79cd13be357-93ebd225b1amr2250843085a.37.1791924975256;
        Tue, 13 Oct 2026 13:56:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef4f497e2sm328770885a.6.2026.10.13.13.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 13:56:14 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:56:13 -0400
From: Gregory Price <gourry@gourry.net>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Minchan Kim <minchan@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, stable@vger.kernel.org, 
	Samarth Narang <samarth.colleges@gmail.com>
Subject: Re: [PATCH] mm/madvise: atomically clear the young bit on THP
 MADV_COLD
Message-ID: <as6ay-X0aXh9SzNM@gourry-fedora-PF4VCD3F>
References: <20261013191719.95502-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013191719.95502-1-pfalcato@suse.de>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 506F51C0003
X-Rspam-User: 
X-Stat-Signature: odez773b7c6asm34mum9rg5d16zw33sg
X-HE-Tag: 1791924976-384452
X-HE-Meta: U2FsdGVkX1+Tmb/rqAwl3mZBMA730eh1UodmD1FG5R+yFC1gCqPbZIgd3Rr7Rw6cmZ0XT9C3PCOwSDiXNMkhMOVO6bZ5ImP0uG8vWgfnuSizsi9QKRp+5Wf9vy22BsonmJewdhLWHjdXYKWVdpAr0POGbbomofd8Py9woy+XAiKKOq6JhgeZwfO6xArUqd1OUEddl56MbzWa7AJ6yn4GIwiuYOuA+gJOENSka15wRVmp5MOMQ8jPxzXhPYlFTe7LDop5RA9Sf4b2s1wljK3fUNI47H+bfb0O/RdL0mggiuKVbu25NziUacwiftr7IYnebqDAEDM141LIwQOMqPj2sS8JUmvl3XMgX2bvdbyJtxcC+0YsRP4M4e89FcGFh0n9eqOEi73teeJH7w8s6zncTn30uxOvRn5JEuwKw20bEhRsEDdxFZhCTz89bHsGoMZsULA3JoZD1OrPYkZvIEDG37WE0BVjPEGKmqiQkox//2Gx99t4f1WCHG7gv8B0DbsSpNXFLhWRpKQu4p6LZXRZg46ifySO5cRTVF3++QiUdrnweKMUlmvPvtLKlYhHRFL+vY6bMMbtmPaO10EJu9EIokgMdyVt60txiWcjS3R65EJ2N7ezW2h46GuwH/NK1S1VQUUdf4MgMM9NY+qNd6DbOwgRZgMhbCsl/yIrR7EwAzOYQsSGIIDrSKICAYLAnNdgqzbAZGfblFgpH2eKA7c0wA2AwmZMuGa8WRprskw1BhlVKHGBmqdfScffsmkebFqxEk1hyiN7Qlh1J2LtYYjNj2c+YjF4gJ0lWrXPymEHbZqciolc+QuxlGZiYfoA3Q/o8Z+nmnC5NJCbAX3Y6yW/lhrgzTN5torljE4iq5r1Coimtmj2lXRY+N7gvw1q7Wh2XVntG7Zp+rHUzegy2fohpS6K2WbkNuHMdyYsTeuPjURKMG1RX+H/0J0FJ2lfps+3JgefzRZZsRbwAI45uot
 0ZmLqUYL
 4gkvmmazODbtYav0ryrrmfSLDcDLXj2WFvCH5kwXd7xnWHoks96UODd5n9YZlGruwvE1vDlDIqqd3gzfKtfmKZC1vkUrgPLAvZlUufTwegJCsMz28q2WTT5jCt9SkjJ+FzuuibPTAmm3ONWQzGpaB+ZofdVkKAVchH4XrebKYyvAowpd1PuLtczRaYwu7gYf+klpjvZOmbxoLeo3Z6qRdAYLryw6TCuBuXs97TQsfcuFY1q3h3K+pzmV9vcHgLQzAmG7jpAma6zMVTLsH5jOOhRCTbkMNfRs7zyAIHDZ+DJzAjzUzzjCAs188hMBLOCAPhF2VMoy3nGEFhD+ixow+HjYkJ4N75+6m8xpdpMN0n0dUNiGR/0GkQn9zWSFfKscunZ3JLRgArpdRUz8lBukOlnIus6ut1umNlb8rxo8kkKRpSN+v738Ce8cCZgmG5/tFwrar2rI2cgIqzG8GqAlZAp4/j7IrUDCadJLGAtl6Yq9CYK/qDcpwulhKtQmh1wwJdryCIKe3GQisfT2uDlVU9EDC+bjJckljC0LsVIif6UnBf5DLXU+5wFbkNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 08:17:19PM +0100, Pedro Falcato wrote:
> As-is, madvise_cold_or_pageout_pte_range() discards the hardware young
> bit by invalidating the PMD, doing pmd_mkold() and subsequently writing
> to the pmd again. However, it does so in a racy manner, looking at a
> possibly-stale snapshot. It's entirely possible that a write elsewhere
> set the hardware D bit, which this logic now loses.
> 
> Fix it by using pmdp_test_and_clear_young(). This is an atomic
> modification of the PMD entry, and thus safe against any possible racing
> writes. As a (nice) side-effect, this elides one non-required TLB flush
> in pmdp_invalidate().
> 
> This bug can interact with the swapping system in complicated ways, leading
> to data loss. For instance, if a folio is marked lazyfree, but was later
> read from, and then MADV_COLD'd while racing a write to that same THP,
> dropping the dirty bit may lead to data loss as reclaim/MADV_PAGEOUT drops
> the "clean" anon folio:
> 
> T0                                T1
> ================================================================
> MADV_FREE(thp)			|
>   folio marked lazyfree		|
> read(thp)			|
>   PMD marked young by hardware	|
> 				| MADV_COLD(thp)
> write(thp)			|   if (pmd_young(pmd)) {
>   PMD marked dirty by hardware	|     set(pmdp, pmd_mkold(pmd));
> MADV_PAGEOUT/reclaim		|
>   dirty bit may or may not be   |
>   set				|
>     reclaim/pageout may drop    |
>     the folio			|
> 
> Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
> Cc: stable@vger.kernel.org
> Reported-by: Samarth Narang <samarth.colleges@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/20261011132227.413217-1-samarth.colleges@gmail.com/
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

The function that keeps on giving (bugs)

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


