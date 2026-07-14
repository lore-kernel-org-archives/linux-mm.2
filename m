Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F350BC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 06:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4AC6B008A; Tue, 14 Jul 2026 02:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 175D96B008C; Tue, 14 Jul 2026 02:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08CD26B0092; Tue, 14 Jul 2026 02:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C38946B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:29:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 469AE1C0217
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:29:38 +0000 (UTC)
X-FDA: 84986406036.06.2B58EF5
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8CA5D40004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:29:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=faOof4Y9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784010576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=0NRVclgAStw8tC9C+ky0P+3DJf76U2sdBBGVotBh8Wg=;
	b=B59V5KkYDYcc+pulvMSzocRhKQScogfclSlF/ueI6SAdMBynQJXwcTrZxDWFHDfQobV84v
	fEWd9HX/2Z+Wu+RHCaZm2GHjeVb0BZAbK0VFnAyISP3nqcpvnlrpHdDZkSn1iFlBBICUmc
	zCXjTIvILjm+moFxOrSmeoAuLJRhrHc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=faOof4Y9;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784010576;
	b=dW/HZfgntsKeVjPTGwl1lP2EXJLIUNaQDvzO8AGMXjKGmJe7BRlX9I6tZc9/M2zq8eOn4H
	XGP+tE4fAJs0XgQJwZoYpwm9E3hCH6bbdynH2/y4fbgonczQiwoxRlUUppNKumHr6MgXO4
	hvboBKAzdFbx0FVxv80mKaAFpwn1RdQ=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cacf197759so8961455ad.2
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 23:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784010575; x=1784615375; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=0NRVclgAStw8tC9C+ky0P+3DJf76U2sdBBGVotBh8Wg=;
        b=faOof4Y9lYW+1ZYzTeCVYldYn1u3CpxrAu0ivV7znnAN4KVznbKKBwOmoASEr9d6Ag
         TL7JumsOk5f7WnDHMNqO1fRSdcQop6AiVo36KIGY1a6gea8tYPjYB6qI9FocFNCacIrg
         aF4Fmka36lLx/Ts8cIZkAJTVKXcEsBi+qcAytDja3ljKUhTy6mCAA6wElWuu3cMvKI6Y
         p3TbDcD6IEMos4XPpEbIwf0pr51xILiqM4W5LJdcLRvqDUDM3FwcDejaOABeKpO3c53+
         6RTXwMMIVxjSbemKPspOGFesBmzmfl7apscJh8OuW9aAoa3pu8eTZFF0pXrpKGSFMsml
         mEvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784010575; x=1784615375;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0NRVclgAStw8tC9C+ky0P+3DJf76U2sdBBGVotBh8Wg=;
        b=R6Rn7pc5d57c92b/BQv30Dmn5K8IBp3oSdPcC/sUCY/FzEKvInb7bZuhZS/eihfn2n
         vq7wJF4x+gxMc8nv0JuMDAga5Gl/vvLHEA43bM2BiwoWp/YSnZYRtz5q+u2it2kLDzJq
         GmpYRHzeBZNdAZ/FJ6ojdJ/xApVMJUA2uiV2IBYwW8qEMyqx07jYHyLu11YKgQn7laC8
         2/5m4RV/5ZFWhDfoWjs2zA/3uYMkOzucZXW5fqt2/3SZl0kPru3khb7dFH0xzSfQgz/6
         S4eTElXqBk+7nHyEyhGYroOu1eDEyv0iJ0V1PpQEBv1IJZdqdDEFM0yHj/MKsxE5IUkI
         QbrA==
X-Forwarded-Encrypted: i=1; AHgh+RolILD1TSBed161olbHrGkJRPpmiMLzZKANjtxVcNyVv+RIMrMhpZrtlcyATGJWyqTaeLu2lZvIxQ==@kvack.org
X-Gm-Message-State: AOJu0Yy72kATaGzsqtTeIpr5Ih7wRpVQboXsn/1hfjRbpueTCyLBiJy3
	SxQGBejIlgnxpXrG3pIyLsEHYJPegHUibKsXhtbgCYYoQY9S2pqecarS
X-Gm-Gg: AfdE7ck/crT9BY2OSLjfHNF2kV1h4CP5grvpaobjPq84QiHj189ckXR/QvtHSbFZa7+
	aQClYa2dLlr/scFZ+iGZPJN8ltMa+rdD8VrhSSf1PoKQnNy4IVtogFO1Ieo3jXsOo93LlInHYLt
	x9sWyQq512VYxA9tn8uCmYWSzgWY+X2rGCugjtXZfktFiwSszR0BsxUfqVrrNZXza3gJ6ytQA5q
	io/M1uYX3WGTPVp/lWlcQnuhtUOgO7YhWRLtZdS+ke+l6SotesIeqBIU2FVQJmH+sSv+l84fLaH
	ufMvocKI6ixq1EcNyGUnlCwZwX1JsMv2Jy0y+tzTkrk85bLzksnytRWteGVCUKMMT3dv2iXuZ2C
	5DVwKLj2tFaF1ax+m6SEQB+W8WmiTm3b9Sam/N7YMWjI+SHG73RWFUtc9hk1FKwy6HcXoj56xc2
	YRBYPlNGtVJPw=
X-Received: by 2002:a05:6a21:7018:b0:3bf:6edd:4dfb with SMTP id adf61e73a8af0-3c110009c5bmr11912286637.5.1784010575481;
        Mon, 13 Jul 2026 23:29:35 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-311935fd091sm54624064eec.24.2026.07.13.23.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 23:29:32 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, kernel-team@meta.com, Donet Tom <donettom@linux.ibm.com>
Subject: Re: [PATCH] mm/memory-tiers: cache top tier nodes
In-Reply-To: <20260706204507.98522-1-joshua.hahnjy@gmail.com>
Date: Tue, 14 Jul 2026 10:17:00 +0530
Message-ID: <ech6uqij.ritesh.list@gmail.com>
References: <20260706204507.98522-1-joshua.hahnjy@gmail.com>
X-Stat-Signature: pbfgfxwknugxctdp5ffjmuaq576zz1rd
X-Rspamd-Queue-Id: 8CA5D40004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784010576-352226
X-HE-Meta: U2FsdGVkX1+ieSWimXts6AaDrMR8mW79Pg6g8sr5dDdO9RkUrQmIEXWra863Jpvy6/vndLegyWFD9EWtqjPw2OBCJ5YPYavLhPxD9dKzg3MJUs+oWRCBdoQpdTFIN2vujQmQSYPuFw7G5KYWgaFaFTZeUlWZkiHAm3hweFFCpW4+L0cZahHP/mAhydYHRACqLlTb8lDgk7ov6cRrlsaZIbWbBGUOb81lt3Oz1w+v2n2szlB352POekUK9KIcURRObfW/iovlp3xr6Jj4gF4dus/BfrL63CPi8P9xqtvoOAAb9uA5E9ScdTLx7l2fTysXMV8tOhxk9IsVu4ngJBMjj57K+PnMeGkT7QDGIwg8GicvScsV19nixKtN/6uqRKwK9mhBJJBPjBAyWyJrr7OwF5PmSuMTe/ugzSXzB+k9y2F4SWLAF1QkFhCaNTfDeb9Ce8Whi5Hew6b0e6yxKoQRFLYjFfkH7WKV3cH7ClpLHdUYlNgfN21T8f6TPhkiA5GO6l2V4WvA51QcEmRn/AlGO2qgCTYZweFNCG896dLbXSv75Su0BV+jr8rSIaxyq1K8pJSIDhVbJNl82W0LAUgClACmf7EtIehslPdLO0EDJDHwlckzADBoA6t2C24GPKFHcjQoP0Waw8JB5lnCoatSFpsbiAuD3+cb42ZYMPQF60+ku0DYZ4PaaJLbNXBJCn4nMMqr4o8phnmGj/E+3htV2wfsfLpBjB7ni/3tQyLTkebx7rJJKKnCDABjrSkx4DS6c/UF5Ufylel5qxY+qNeu6tMSIEZuaX1RVFK1NRcyDUDZXOma1FxX0RsJu1xQlMEJewrwIrtFd7mrOmA4PfRHnpvRK+b3BXiLHhAnFn4jC8n9blaFbyhsumNq6Rl++V4tw3jaoWRjv0JBOd7pvqvCkbetxufIDOMIVyP0ztBe9S7itHg51UTeQLl9mZOldFkjLO3glk1/RYvWfkbVrId
 aPoqFfwm
 0KyHzINT0Kht9q7N0ueNlpWQAdt+EzrPjcXdL9dXfnBK7ZdGfoi9Oy3c12dFMsCh4FyYrh0k3zmooXOrzLn5cflGCQhVTuJQutdHvdNVRYt8EtLz/4b6OfFSvH29aD/IXIDeMEq+GQ4EKH/CZdwPBI9Mzls8zcNwIgqLUpovC8FmVRxxzYiQZyx8vMzT6Obncqex5YpbRnDR/HT5K26k953K4cNzv1kNjvmNGahTrT2pdmBRtzKhc6xMnNfdmg24t5nSNZVXrX0qTVbqK3mPjE+lV3YYLw9A5fxz7RjItNGax5egRUfgYneSwOZOoP2hpX2XH8dSgToUzPZgcLMS0Ub5OBw6Xp5sn6Rt15Z8dIxRUcJa4H/YAOOP+6Hg8mOh9MoHtgjyuB6RRr5IIzsKREBk2mtigUQz19J9mZ9N4U1QiKDdbD0VOdI8yQ0TFrob0RZ/hoC1/xB5aWjwuhSPTzWvuWj5ehdTvn6pdDh+O80qQhOIiRgiYHS+qAaEviQMRuAmwtGt/4JUd9Z4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> node_is_toptier() is called in a few hot paths: task_numa_fault(),
> should_numa_migrate_memory(), folio_migrate_flags(), etc. Each call
> takes an RCU read section and performs the tier distance check again.
>
> Tieredness for all nodes only changes on memory node hotplugs. Instead
> of recomputing toptier nodes inside each of the hot paths above, compute
> it only on memory node hotplug events and cache the results.
>

Did we observe this function "node_is_toptier()" in any of the perf
reports? How much perf benefit we see with this, if at all?
It will be worth adding that info to the commit msg.


> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/memory-tiers.c | 36 ++++++++++--------------------------
>  1 file changed, 10 insertions(+), 26 deletions(-)
>
> diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
> index 54851d8a195b0..2e6e02ec1fce4 100644
> --- a/mm/memory-tiers.c
> +++ b/mm/memory-tiers.c
> @@ -71,6 +71,7 @@ bool folio_use_access_time(struct folio *folio)
>  
>  #ifdef CONFIG_NUMA_MIGRATION
>  static int top_tier_adistance;
> +static nodemask_t toptier_nodes __read_mostly = NODE_MASK_ALL;
>  /*
>   * node_demotion[] examples:
>   *
> @@ -276,27 +277,7 @@ static struct memory_tier *__node_get_memory_tier(int node)
>  #ifdef CONFIG_NUMA_MIGRATION
>  bool node_is_toptier(int node)
>  {
> -	bool toptier;
> -	pg_data_t *pgdat;
> -	struct memory_tier *memtier;
> -
> -	pgdat = NODE_DATA(node);
> -	if (!pgdat)
> -		return false;
> -
> -	rcu_read_lock();
> -	memtier = rcu_dereference(pgdat->memtier);
> -	if (!memtier) {
> -		toptier = true;
> -		goto out;
> -	}
> -	if (memtier->adistance_start <= top_tier_adistance)
> -		toptier = true;
> -	else
> -		toptier = false;
> -out:
> -	rcu_read_unlock();
> -	return toptier;
> +	return node_isset(node, toptier_nodes);
>  }
>  
>  void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
> @@ -497,19 +478,22 @@ static void establish_demotion_targets(void)
>  		}
>  	}
>  	/*
> -	 * Now build the lower_tier mask for each node collecting node mask from
> -	 * all memory tier below it. This allows us to fallback demotion page
> -	 * allocation to a set of nodes that is closer the above selected
> -	 * preferred node.
> +	 * A node stays toptier unless it belongs to a tier below
> +	 * top_tier_adistance, while each tier's lower_tier_mask collects the
> +	 * nodes of every tier below it so demotion page allocation can fall
> +	 * back to nodes closer to the selected preferred node.
>  	 */
> +	toptier_nodes = node_states[N_MEMORY];
>  	lower_tier = node_states[N_MEMORY];
>  	list_for_each_entry(memtier, &memory_tiers, list) {
> +		tier_nodes = get_memtier_nodemask(memtier);
> +		if (memtier->adistance_start > top_tier_adistance)
> +			nodes_andnot(toptier_nodes, toptier_nodes, tier_nodes);

I looked into this and I don't see any major issue with this patch.

However few things worth checking are:
1. From what I understood say if we add a pmem node as system ram, then
due to the above logic, it will go through these transition states..
    0 -> 1 -> 0
This is because we update toptier_nodes to nodes_state[N_MEMORY], which
means, pmem's nid becomes top tier and then we quickly transition that
back to lower tier by clearing the mask.

Instead maybe updating toptier_nodes in one shot at the end would avoid
this intermediate state.

2. Also IIRC, after the nid is online, numa balancing for tiered memory
can always work. And we store different values (I guess in
folio->flags), depending upon whether the nid is toptier v/s lower tier.
(_last_cpupid v/s folio last access time). It's worth checking that path
once.
...So, I looked at it and I think the same transient discripancy (of
whether the node is toptier or lower tier) is true even with the
original code. So I don't think that it should be an issue.


-ritesh

>  		/*
>  		 * Keep removing current tier from lower_tier nodes,
>  		 * This will remove all nodes in current and above
>  		 * memory tier from the lower_tier mask.
>  		 */
> -		tier_nodes = get_memtier_nodemask(memtier);
>  		nodes_andnot(lower_tier, lower_tier, tier_nodes);
>  		memtier->lower_tier_mask = lower_tier;
>  	}
> -- 
> 2.53.0-Meta

