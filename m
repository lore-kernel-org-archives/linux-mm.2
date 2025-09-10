Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3BB5CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:18:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E769D6B000E; Wed, 10 Sep 2025 01:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4EB06B0011; Wed, 10 Sep 2025 01:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D648D6B0012; Wed, 10 Sep 2025 01:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3EB66B000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:18:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D20286E6C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:18:21 +0000 (UTC)
X-FDA: 83872184802.04.A4D72F1
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf18.hostedemail.com (Postfix) with ESMTP id 294391C0007
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:18:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ADSDnES+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757481497; a=rsa-sha256;
	cv=none;
	b=T/Yoo3FlEj0HCtHG17jzYNXsZlhXeBTjubJn+ImC3tdxztxzMYu+8JtX3gV3fcrFRJkzsO
	PqleWSSDtovVVThz3a64c1/r6M++Gag3V0eAt6xfYC0EVmM68QGrdGpyiukNZEbUWNekF8
	6AHU4jr5nynzH0dJ7v0kdhy/GjSEUKo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ADSDnES+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757481497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVZb3Wv5DjHV/fPWzvQeRpiAZuaKt+I3hkiJK9us3y4=;
	b=k2+ty0VZHfUsQjPH2STQ4ZE+iQAtGA5ROpiydifdDojaWyKRaNRUtAZzJBBzZzR4keH+yo
	ortscYLv5ZM0Zb2tTWXaB7ElcxJIlGLtsyWLNC2lF6QNCEOmQzilIFGio60AboGUJj6A8Y
	PhayBvWtHFtC9DdmhAu3mvRvP4SleyU=
Date: Tue, 9 Sep 2025 22:18:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757481495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cVZb3Wv5DjHV/fPWzvQeRpiAZuaKt+I3hkiJK9us3y4=;
	b=ADSDnES+dA9YiAsLR1cETJqGS3IXOSFpFZeD+BtrcZyZnqzeTZdv6YG3+hIiUmB2GEOZts
	9XAfth4nQDb468IXHg64fzok3xtKvEINhKb8+PypbZBLxAKH2AzYWDt5E36un+tU1uDHKR
	71IfSwkaYr/DAutTh7Nm5nRUBRfQg9Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, 
	hannes@cmpxchg.org, usamaarif642@gmail.com, rientjes@google.com, 
	roman.gushchin@linux.dev, harry.yoo@oracle.com, 00107082@163.com, 
	pasha.tatashin@soleen.com, souravpanda@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
Message-ID: <hp7kdpo4wqlyge2mjivfieibcfxu2jxestrqfwll27v4gsoqja@stvbcth6zc5v>
References: <20250909234942.1104356-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909234942.1104356-1-surenb@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 294391C0007
X-Stat-Signature: kr3hq89ixway5eifguo5711ypdghkbth
X-Rspam-User: 
X-HE-Tag: 1757481496-104066
X-HE-Meta: U2FsdGVkX186wNn3Gi8q7RHkYTeajBtYidvEVNV6kjhnAYgcjXNVh9gffbCN3pWjPNl8XJ2Ok6/GMEGS7TgwsnZO4frrS5WZ5t57Kve82DWP0JQKlks8+sA2p8z/sd16GgXSBABUJH2jcFwQ3HP5HOEaxcNJVEeg9uOjm3NaLJDbb1JVc+ozTajRhLS9nRjJB9JLJx4RvQmU1oVlgNW26QBzhGGg4udC+dsbe6sZxvPyiQcCkznyIxhe6w04Xy8QRsktLQidpeeHK431dGuIH2xgpeDE8GTSG/xaccDaeRfOAyDFHVB1xPkTh0G6fewt/ql+wdrharp9aF18NFvyq72WHhqzdq0VgQxMcO4JOUV6piwtuXzT/uyrEJNN7nsBH4p86DDCbA1Fj3sPLwu+ItofjaVA8lvSKmY6149ev+nYBB9Mao5T6126eZ1QKvRN9qXdGOJHpfQYrpAGQlNFzzXP0e8RCCIBE6iJ5frGqt2WtRDndK0TGXcAg7RYqvy7I1RP0LK9JJadYSEhCfuX/Jxf0LrAjTVO9LHnOthzKZjBmCfbo9mPOns7DI4e7rhdQhmu5fbOIfCjmnjieDoePQtdWsjaW9H9nBezts6c2teVdPBKJKfX/TyDyPL8fzhUhDj/nQnCfH3doRGWJ8pttbo/lR7wvT3mrmyip7fWK6ZR5oRVfBEKDeJiNZS2nS688iWHAck+Ab/HieFoRP3/NwJQznDkMAYVZfzr0spF0OQAfHQfOgzA4KKqKsl8eJ4yvfjNeKDxbQ8a+ik7Xh7t0cQf7Ax5W/jC9jMy7hO+92koFUHp8m6jioqwZFDa/jIQ8y29AGIb61JHsb84VKnOMVs0FKcSycQcLwWk6gtPzDHvv5cxWvDmxP0978lL3IXtPeJXp1CoSYjfVAkgFXQ6m1AHZWzsCjXmlPUtjGhptxbglaSHSyzBXLIaiOjSPou0z5/h5P4Hiiao5GLHpAG
 gj8PrDs3
 tyngrLrML729AIcytIelKnyhz8YKUjY65+7eD3LzI2cx/ndluJZWf7NlSnd8gkZUH8tgyEhQeCb3O+I+vaCLSdgKI6p4s4UgZ89FcLQT+31XvkS7T5vbq8CfRz712+hhMqU2vpzJ9r16dW+fvRGu/WLEtjzPLhBDuH7Ktj8ZXh/+UtUb8Tew+UWjtqd9bXq94cI3OLcscuJohjmDX+FIPrEJuBA1/ql5+OQBpqONUkZSYtE273rybv2LKpmS8CnynrjOTKJnBs4OwSPap3KnsBPLXh4yUkM0bTn1ZbzHHGA3znBR9NllwOjij9xjBV+RayintXkoTeIR+RQCTDV/tcfUIfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 04:49:42PM -0700, Suren Baghdasaryan wrote:
> While rare, memory allocation profiling can contain inaccurate counters
> if slab object extension vector allocation fails. That allocation might
> succeed later but prior to that, slab allocations that would have used
> that object extension vector will not be accounted for. To indicate
> incorrect counters, mark them with an asterisk in the /proc/allocinfo
> output.
> Bump up /proc/allocinfo version to reflect change in the file format.
> 
> Example output with invalid counters:
> allocinfo - version: 2.0
>            0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes
>            0        0 arch/x86/kernel/alternative.c:2090 func:alternatives_smp_module_add
>           0*       0* arch/x86/kernel/alternative.c:127 func:__its_alloc
>            0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_set
>            0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_realloc
>            0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enable_hybrid_capacity_scale
>            0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:init_amd_l3_attrs
>       49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
>        32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_pool_create
>            0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_threshold_create_device
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

