Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B687C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 15:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADD0C6B00AE; Wed,  1 Jul 2026 11:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB51A6B00AF; Wed,  1 Jul 2026 11:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CCF16B00B0; Wed,  1 Jul 2026 11:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6255A6B00AE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:05:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BEE8DA03B3
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:05:56 +0000 (UTC)
X-FDA: 84940532712.15.4ED2C19
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id E2A8AA000E
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:05:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hLzr7ges;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782918355;
	b=RhFiITehQSpUNE9AVNRG8nvi5SmlgjJmuvrFdFnWhV5Wko7ZYdf+ZLfcqVOe2jTNIWGt9t
	Hy9IdV3R0Iu1eDUjntHZ5qXfatTS2SJvoPahc53OxksVQI5e7T6qY05o4EcM1BjT0xyq3z
	b0CXFv/LILsWrtnCT00ilPk9DFpkJgw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782918355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wpcsb0+VdxshQ15XkMHrH6lVO/I8qddArljRZWvFEt8=;
	b=2YWnklRCz98BDcId16w+j+3bPCb9egVq08lhSY/pQtADFGA1swnoH5daM0V5BrKkPgvEqF
	2++7HHfg/gYhPoV0Stm4QGef5c9qN52h11xbLyyTCKf3m979Y63CX5n/5GVvyB6YXYMtbT
	Z3wZSG9nqLsgXEzYozyGfCImCVqx/W4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hLzr7ges;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7fe36f1be74so11199257b3.2
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 08:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782918354; x=1783523154; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wpcsb0+VdxshQ15XkMHrH6lVO/I8qddArljRZWvFEt8=;
        b=hLzr7geslxQuLEnOfk72DmSjuQiH6FiStrkWgW7WKUGuZaKUZ+QqrzUvvmA41F50gE
         DbhMfVAS7eWzSdIMWsLVGWOOce529NCUi+lT22eEVsx5hTtq6PFjAQJ4QrhG7HJvccde
         QP522+OS5C4Xd9Ycg5PP69Xxd98BibbJ7KWeQa7vn2mxVse4ZR3JntK6e5+xvy67NORR
         MPfyCyNuZdW3dor0Vig+yqoxHO+FED4bk2cynyXK1z9tGLKCD4IiVq3+7Dm07bDF95jj
         GKmSuXZD/L4N6H9pzU2ROGVmMQZL47+TCj/kE3Pj9dMkh3y34KcfsAnCOMBrpgBzbQ/S
         0Axg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782918354; x=1783523154;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wpcsb0+VdxshQ15XkMHrH6lVO/I8qddArljRZWvFEt8=;
        b=flxqIhZKIigkeJjEGUUixAOaePOWmRVR/fDmJEEjjr3FtAJPQH/xnufuQUep3R3+H3
         Nh3ZL9WAJzONPu1LYYR9IgUkH9P135wxDdl0vKRbjgD0pi3JDNCgLI3iWqbvxYN7qpeX
         6vCusID/ozMt0VcDszbmLcETvH3AbBWie4LU8f9qbOEzqOo7ijlM3Ya5NwzrnangXoYM
         FmOMW9Qphw6ixos/zI8X90a2dDl8ux2v70T3SwECvGLYwp4lTHeUbQuGWaiR5mYhYnwj
         pKBa6a5eMlplh36fa2AF7JyYfsPcgXjErviT9zzhQMbG1HejuPgGOT1yct6zgexVboMT
         xJJg==
X-Gm-Message-State: AOJu0YycuVArUt9Mhq4ZWM5IBCZF8DpSt3LG7ACw45HK9wYmybV0OMTf
	iXadqEjLaHQ8YAXgMDuhWEzMv0MijgtjCZOCzayf9h4SV44Pe05c2LkLV04hvjzipHQ=
X-Gm-Gg: AfdE7cn79vHrRkAGr+tnjTRMaOPu+4mjPUa6xUEB8k4ksam0SG+wluognISC+uz8uyA
	QgG1xNOH/yGu5LwFFXE0PbniFaERwU1clR9qaxbyQUP8nQcRRGQgMYcmlhpNS0ofE4Tpcp2ECAB
	uqGpEf4pUatUiOM8qIZH+dgowcV6ARzqxZtJq9SYnxI8r5PA+Z5KaEZq0b2zFn6TczV/B+QiX37
	Ie9kYDddUWYcs9u3Tq6zhDN9fYFhgOyjx9ovD0f5hnC93tQhWJvVWK+6HsOoJnaTNE966hCYHqd
	P2m/EPcOrCa8Se6GCDeMjzsT80VNpBNfG+RwS1HZz6SvSkBItzdSQweRoT5KrG9Jw06QcJXKXWd
	1DZsx/IOZttRxTAH9t9unHXBohGvpQCt0xL1pP5FwQtaW80e1kjYcCgYbdNbEg20xX6wW4fqVb/
	F53piuGek9BzXR0y8YsIDBMx3ZXLomiCVGUueOcw4k5wQk6QKib7iAL9/wFJysxFuDW6x+
X-Received: by 2002:a05:690c:6906:b0:80b:968:29ff with SMTP id 00721157ae682-812eb86e8ecmr20804517b3.53.1782918353875;
        Wed, 01 Jul 2026 08:05:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f3611d783bsm23143586d6.28.2026.07.01.08.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 08:05:53 -0700 (PDT)
Date: Wed, 1 Jul 2026 11:05:48 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, kernel-team@meta.com, osalvador@suse.de,
	akpm@linux-foundation.org, rppt@kernel.org,
	mgorman@techsingularity.net, hannes@cmpxchg.org, vbabka@kernel.org
Subject: Re: [PATCH] mm/mm_init: handle alloc_percpu failure in
 free_area_init_core_hotplug
Message-ID: <akUszCySPFA7IRlb@gourry-fedora-PF4VCD3F>
References: <20260630214039.2263562-1-gourry@gourry.net>
 <b8baae33-d551-40fe-abb5-287f3711dd80@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8baae33-d551-40fe-abb5-287f3711dd80@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E2A8AA000E
X-Stat-Signature: ccqenkh9nj1h9bstmmanw7gz5xp5m7sw
X-HE-Tag: 1782918354-636544
X-HE-Meta: U2FsdGVkX1/S8W0glgaiAd2EZ9UDT2cku2kQGZn47HZwqfw3ZghnUF7QpE3Vtcl7auaLMOsdVqhaFIbt0ElaB8zPalJvbPURaI5snqxDUy1iomeZsD/WsQ9uw/31V2InsVZ1YcH+Q7zsvsDZSybkvC/zMWXWl0Qn8qRtO3xdpIzuguVvKZ3TYoGN58wme8FaRLXBPiLnfH6wbdM4n24MPvdlyv1++wqsC8yRswM18MUHmLzeA0qu9Sw+Hdv0F7u/T9J9S8/2+lJKK/5VZVwnxiGujTAG/yNVK3xKKQ2DSJbB8ei4QsIgSGUAiUzxiXw7s7OEq/nOcfCUTu5EY0eFb2HGHL6xWa4Rahd4lGmR4v4AFcWNCNzfCMIB6k7oT+X0KsT1CZJ5b9YT4nzXkmLHVMvXHVfx1gE+Zb3p7+0Ksw9kpAwxFOxQBL94qeQRz5TEGaBdlZVVrSw4lcR2eeHTHkhRYlHlYl9wUopzSI31bbtdo0ReNUhUYBsQm4mP1oU7NwlPNlLv4+ugXM5FFNP3E93apBrX2S3kf4vVx6GmTnv/VQ4FFB6A8TU5zmoPk2yFU8fyLZ31TDvx7CB/qv/oN8E8aS96yJoXKNeDg4XEYGkNPT9I2WQB7pzwJnjHe8GHb+H8K5648fp8XdjC3AX8anes9mPhVF1fHVfqYH+JL6hFqXx2xwSwk7wrm3ZtjVpZE7zk0msBa+rsw4LT5UZMbapQP9qp9mmpQo3ffGUOGfXqKVh4oXXHb+vEJIyFevyVH4IJ/HJyjjz0ZzpgujfpIMFUSKm+0pQxzafsG5vm14u9KyK7nqBmpHmi5FrNEGkbYP8hCJw+UpEHXEg5xAS9L/1ZM7ifkuUrwU9IiHJK2lwNI+bkSnAy07pD5qIRCwZsn+hehNCxiVhr4eVHKUGMN/FTZM4hFZNE+YkjE3cXJUXk9ShXpEpl7gmom0ij47uqVDBUqWVBekcHTO8zA6+
 v7aUMr8X
 squRT5rPM38BqDo5IvRUjaQe7vKL+ycFxo/o/KpEm0TW61zQ5uaq7hUBF1qZt8Xa9WhVTRVc2TTjVJ2eYdP3F8IxL5EX7twOgMZbukfNhDKD3UEeRJdnJbIwKrtBUCM27BoKePPCNC4oNFoE4U/t+dvpCFAxeR2gN6669vrmxRmlsLthVwamfommlM5ldnK/xSlNNKSQ/vLNC1Kyy/w9dCssWzxyg0MJNOWqG6In80bGxDslvR/+Jv9kXTZEZlp9BnRCd80p5DFrjASUyzEMMUHOykqid+qPfWD+5/2H0XDIDX5/iMs99EtTiOg6EozLU4NgTY5U8vCAalkSvnbqIze2Cj/PeI740msQ4RXWVL54yNRFFrL6a45jqwBDs+8vJSHXo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 10:35:41AM +0200, David Hildenbrand (Arm) wrote:
> 
> >  	 * The node we allocated has no zone fallback lists. For avoiding
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index 306ea5c13f54..37fd64ce144d 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -1536,7 +1536,7 @@ void __init set_pageblock_order(void)
> >   * NOTE: this function is only called during memory hotplug
> >   */
> >  #ifdef CONFIG_MEMORY_HOTPLUG
> > -void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
> > +int __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
> >  {
> >  	int nid = pgdat->node_id;
> >  	enum zone_type z;
> > @@ -1544,8 +1544,14 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
> >  
> >  	pgdat_init_internals(pgdat);
> >  
> > -	if (pgdat->per_cpu_nodestats == &boot_nodestats)
> > -		pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
> > +	if (pgdat->per_cpu_nodestats == &boot_nodestats) {
> > +		struct per_cpu_nodestat __percpu *p;
> > +
> > +		p = alloc_percpu(struct per_cpu_nodestat);
> > +		if (!p)
> > +			return -ENOMEM;
> > +		pgdat->per_cpu_nodestats = p;
> 
> Is there a need for the temporary variable?
> 

at start:
    pgdat->per_cpu_nodestats = &boot_nodestats 

So need a tmp to do the swap/revert/etc

> Also how to handle cleanup on error? Or why can we skip cleanup? (what happens
> if we get another call to __try_online_node()  later?)
> 

-ENOMEM ->
    hotadd_init_pgdat -> NULL
        __try_online_node -> -ENOMEM
	    pr_err("Cannot online node %d due to NULL pgdat\n", nid);
	    try_online_node -> -ENOMEM
	        __add_memory_resource  ->  error_memblock_remove:

Basically we're left exactly where we were before we made the attempt.

Another call should work just fine after a bunch of dmesg spew.

If this happens during boot via add_memory then something else is
horribly horribly wrong and we'll at least get some debug info instead
of null deref.

~Gregory

