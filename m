Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBFAACD98D2
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 02:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90726B0005; Fri, 12 Jun 2026 22:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1A4A6B008A; Fri, 12 Jun 2026 22:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09516B008C; Fri, 12 Jun 2026 22:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4866B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 22:58:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B1808D004
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 02:58:18 +0000 (UTC)
X-FDA: 84873380676.17.A2914B1
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id 12A58C0002
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 02:58:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rOmPc/en";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781319496;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uAwjbx7OhsFF8Ofl6FEk1ESuaIwcoPlh2QD/QcmNLDg=;
	b=jGEy+hn0rve6XapUGgNiVPJAFvvfYzG8IclE4xTPpv0fO0ZDi8ZAdKN6jQ5mXRp0db7QIt
	2VhT/soMaeKvVZnGXlDIkPoSmZLCugYhk1PiePbgkX2a2lFyaqCeZVEOy55zjcivuyUR4m
	ygI93iIpUJ81AF2Mvt7ivypofZR2tEc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rOmPc/en";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781319496;
	b=6K+hggOIuyb1+guaVG2K3rt1xgQ2WTJJzDU+aZqBj882FSNMJ9CoshURvxOiLzJtzldp4N
	/70NggLKzB4ngGGLhdriwFtVb8TCaxG5JCIQdiPCqO4x66OmPLKhBuuVmSv+pIs1rByL0M
	2gaEfa/RHxxQfAFVyTiQUwwRX0eDHc4=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bec43ee8ff0so223788466b.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781319494; x=1781924294; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uAwjbx7OhsFF8Ofl6FEk1ESuaIwcoPlh2QD/QcmNLDg=;
        b=rOmPc/enZTZy8sX1qxUnkjFK1Jc08GQRrnSKeRiNu2KeqS9xE6CtIwkrPiktzN1AaG
         gXUph9ipoGeNQH1ANFliIxIubnVAJsUxurh1XWmQcmLsUgbWRIDf/G6B3rY5quZRWfIG
         3U0qLXciu7bGarhrq+KP4/PxFzAciRKs0tkHxmx2p2ljaX9pJ4CcImIR25XavHOK0W2J
         sadhSHRoHlhYebiyVC/v21WljDrCH7mg1DJLXw55MjPicp++dVXc16SyJzJfhmlfH0IZ
         YLEi6FDJX/niyoYCDuYZxOUb4NlDMa//2X4Dy6XoBS6GWOalQLnuXYXcqSHUz9FlbbDs
         sGNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781319494; x=1781924294;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uAwjbx7OhsFF8Ofl6FEk1ESuaIwcoPlh2QD/QcmNLDg=;
        b=drHLCe7n1cxAeiQzM0/SSP2TwJavM3rXBD4QajXux7/nx5aVTbPjtN4Xupz0OqqukZ
         g1Hx+rzcegcVVCrGMTFThAQ1RWZf13yapsNiSTLneml6ntL5jThf3iQp/mewmu0fsAja
         Mw/0nkwbVijWDmUbJ5Rc5YPf0WbysQ+plU6gKVu1SKYB7MwY2XiEMIyVPoBHx7+9QfXN
         uN72EzmHDd+LAMbkhUGH5+0vu0y26HQLcFwdH4qFjsqnEtYYFluwPQC/R7JWGx2xzjR3
         1/NFpEAFyYJDnsuWo8snumbHRrF5cgiWbINSwbD/DxB256XW2iONQbXk+8VwZBdvuKqV
         Ul2g==
X-Forwarded-Encrypted: i=1; AFNElJ/4W+driKd0JVZX6+ts/PwRMBh3hjPmsg3FY/Lt4IoC0I8p9zUDsHgevE1mPLUDhvcn/cQxxSZtow==@kvack.org
X-Gm-Message-State: AOJu0Yxlpqv/XKyA8I5nl9GXQfQyqv4esj2EO4AIhyTUEioqyXdVRkcY
	1fV3r7rrY2Juz+5Qxu1xudhN1t8nAU5tsaHRYi3u/o+Qq4nbT7wvbLR8
X-Gm-Gg: Acq92OEc+t2JE3mrgqcpCJy1cebn2SvohY57/A+0bYKaGUUMId68ZmN8ZeGZs+HqAte
	9qoa/UfClOF/R/j8CUv3sqMXCFvFUgZqXNe9+0b+BVwWNhrMj9YMg7+3EdOBLGZITyLep070i4A
	60rGycAevCCBCk9jRzRU1ET/z1bpsQhnhROfp+vnFb4ChWCk2LdmdktcwCbdeIfd7AAVeRskm9d
	KFVygzk0yvtYp2icMn1kTw7gQMs2DUMDGxSbxrw0ll6O1l6rmcHknzxI1IONBKuv1keOAu6DoQ9
	ScjouGlYF75sSoiWSYS0k26zRwV96oSiSSK2NtDRc5P3BX3QbR5G1Nf1OoTg5yD3q+4vA9R/fn9
	HNKKNwKkX+/z1dIxdWQWf4RNB4GUReWG+pelpGz5e7cmgEd7cT16P8/6TH3f5l/cNZjv+rahz8C
	eVG2hz6PQuDEBIwvsczUFohw==
X-Received: by 2002:a17:907:7f94:b0:beb:d461:7b09 with SMTP id a640c23a62f3a-bfe29927242mr210429066b.11.1781319494163;
        Fri, 12 Jun 2026 19:58:14 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb44208f8sm179835166b.10.2026.06.12.19.58.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Jun 2026 19:58:12 -0700 (PDT)
Date: Sat, 13 Jun 2026 02:58:11 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	shakeel.butt@linux.dev, mhocko@kernel.org, david@fromorbit.com,
	roman.gushchin@linux.dev, muchun.song@linux.dev, qi.zheng@linux.dev,
	yosry.ahmed@linux.dev, ziy@nvidia.com, liam@infradead.org,
	usama.arif@linux.dev, kas@kernel.org, vbabka@kernel.org,
	ryncsn@gmail.com, zaslonko@linux.ibm.com, gor@linux.ibm.com,
	wangkefeng.wang@huawei.com, baolin.wang@linux.alibaba.com,
	baohua@kernel.org, dev.jain@arm.com, npache@redhat.com,
	ryan.roberts@arm.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/thp: clear deferred split shrinker bits when
 queues drain
Message-ID: <20260613025811.z6xfm2xg7r6bgdea@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260602043453.67597-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602043453.67597-1-lance.yang@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: fzmfaeb7drhhbe1isjm93ubbkekrcgfa
X-Rspamd-Queue-Id: 12A58C0002
X-HE-Tag: 1781319495-548126
X-HE-Meta: U2FsdGVkX1+gxeLqgRuoNPzAjCt33AEIN1HwFzC6RMIIQ1D/i9tN2OqtqgW4RugzcKqDuoQwbRr+JRtaNGsxBiECaVIqQi+rEBp2O0s7gVqMFoU9YiwSSjodjveOaKGhRZotl/LkW3Rx1P0l7RU9ZsnLnHW4AMHvg81dfilMtT17QeYquRcfboByoZwy/eHccqwZVXmpKDYtoscemw0YFPpdJR1pZSQSOaHnh1HnRieVkxOAZdyFUzEGVs0IE4YbxHAaWiyK1KBVLpL3bKC4d1yYE2A4FV3l+bhyA8OD6UrE7zl4PSt4GQEJUzmpk8wTwRO3VWZfdTHaAqPmEvBdGGW/9+K25t1d52x/HkIm3ANWCKiOFhEm9xkK1477VlqBhwS8ndy4X1ISNS1Ctjs/50wiSwQEh3DbU12Og/CyqLxNm+IeTyDGPCNap4R/YJzA6AFMiHFl19Fa+41OnLHWo7E9GO54oUwoOz3EamxGuB8mdN+gIr4W3vpatwS+54gTF8nIxtfKsa1bM1nTPViAZKvIFRA1TDpw5/kWNCrDiSL+d3TPmaobcjxN4fdVLjUU7GYqSx9V2U3A+FCn05A3QaTPJ+RCiO8ezQGsPT+IkTUmP42qm+maRIjFUddk0y/fMCESbCtG9yVdAZ2ypuwh2GwOkx8qTkqx/EuQYi8F/62lYAfYB+0co8PyFwbDbgqL/LlK3lRQAILZnZfoBxS8dee5ok3FaZ3mnXy1f1vBQwcP5rBUe4n7DvkK7eu57MEYXAUpxsofi2UgMMaW8/qsJn29eI/vR4uz5GHPsNUMyBSpnk0vuQVCGzKZTyBnf9PAtKj4dGtFiKSgMtlssC+aWG/kjKZpRBDshtnWzv8lmuzeAjTH50GQjo2WyLzevkMUmVd6NNsn6hfCLFv5NjTkGX3XnuduZguU4u3tMPVynZJzfEMy21JpzM4G84RSgs+niwqAT2FuGYL7M6Gbf3b
 ohtLEFrl
 IxPHMyIGJJVRkP2+jFjyssQsCTKZ8cHd/n4jMrbKJ1iR6RQnSTVJtoM3PYNiI07PI+d9NuD3DX6MoIU1WK8huEHBLWl3iriRAODzf0U3F+mFrCYgHGO0W38zRnFBRplACOLczTSwCwEryJK3xBgndvEdb4PzLAyVkv28SIv9Sn3bKY86UCPa8GtBmnQtElI7fCV7bvjusfXWX4SogPukIsTsnYqSU+DhWtKpo7Ex3IKtC1Tj0SGDUvWZl6mlZwJayKmIqHOoZeaCv8h53jN48Ltf3gErCItiUq/s1kRFuLOrSXJYrOt7Y+bYOpdM7jkT7+EcseDERtyDNnb3Yfm2MXm3B1sc+Aa7Vg9moUgZJiaYdAuu1CS6853k02q9rMiacmTL7oOdifzaERX8fKjwARnUmLSHNY66OMU5iMOsNftETqRqsqY2a95XOJqO9Y5u4tYP1/KxtZ+Yb3r8luSz7lUZbvcKgcrK0YII4j1lcFwH0At5mtiWcRwMdfXSmDaTWf6UCVysUkoXAuip/fLMkoVpxAJ62UoodW/iX/R+0/H5bpsVo10XAGjzRPKc5uiwe30qh6mVpg0QWPF4EMhDbnNZyx7jy3EmTEMzOJ8Nez7vJ7JUzxt1ppQJ11gqe7fxqGoc96npjpPk+l+A0427aKuinEHIi0RFtvTIX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 12:34:53PM +0800, Lance Yang wrote:
>From: Lance Yang <lance.yang@linux.dev>
>
>deferred_split_count() returns the raw list_lru count. When the per-memcg,
>per-node list is empty, that count is 0.
>
>That skips scanning, but it does not tell memcg reclaim that the shrinker
>is empty. shrink_slab_memcg() only clears the memcg shrinker bit when the
>count callback reports SHRINK_EMPTY.
>
>Return SHRINK_EMPTY for an empty deferred split list, so the bit can be
>cleared once the queue has drained.
>
>Signed-off-by: Lance Yang <lance.yang@linux.dev>
>---
> mm/huge_memory.c | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 72f6caf0fec6..62d598290c3b 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -4397,7 +4397,10 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
> static unsigned long deferred_split_count(struct shrinker *shrink,
> 		struct shrink_control *sc)
> {
>-	return list_lru_shrink_count(&deferred_split_lru, sc);
>+	unsigned long count;
>+
>+	count = list_lru_shrink_count(&deferred_split_lru, sc);
>+	return count ?: SHRINK_EMPTY;
> }

Looks you are right, thanks.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

> 
> static bool thp_underused(struct folio *folio)
>-- 
>2.49.0
>

-- 
Wei Yang
Help you, Help me

