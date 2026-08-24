Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC51C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E44D6B008C; Mon, 24 Aug 2026 07:48:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7957E6B0092; Mon, 24 Aug 2026 07:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684506B0095; Mon, 24 Aug 2026 07:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34E446B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:48:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B36CAC04BF
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:47:59 +0000 (UTC)
X-FDA: 85135989078.25.4E765BF
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id 935DC100005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:47:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JYfPNNkU;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787572077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S1OQ+o11GFCuRHAOrkLxBgVaNwncS1WphwbZ+fSPfb4=;
	b=k6l4kD0TseO4Vy0Xh3nl1kB2pKOHF0B6E9fwn+zBSCtSKFHgn70T/BprV3BAYF3duOD4nO
	k+akYGSHNtdK3iC9CjHBF8mNSI0w/aAjIKnW6jAHi64WG9AoeS7Ux5UAnktEf3ncxaNRx3
	qeIqBC9U2T1IabQp9+sVEkZfBuA3Rf8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787572077;
	b=HWmhi2uN8uHn8OLfa6+xvadEHm+w2kBiFJT1nWEZ6kfp636ygxnvTyJpAiqdJrUxwWRrI+
	u7LGBIw6HdXVOlxAWBfoyV++d+EuCAQzwqwrAbLDoEqeZh/F5fKzIm2sxWFGLuefNahBZv
	Kqv8RltFK/dBM04sKTxpvh3g8jqnax8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JYfPNNkU;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-69c600f76ccso5605812a12.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787572076; x=1788176876; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S1OQ+o11GFCuRHAOrkLxBgVaNwncS1WphwbZ+fSPfb4=;
        b=JYfPNNkUZr7s+ybl9w3fcINs6tCk+u1hlUZvQ8tXFCLwKL8c1q6Qlkkq46bn6CZFOm
         8E6FT47sjP5epfcCWjXKBtYd/RrZ4ApiZrRT3N7NPcSetKRGR1H9H2/UxKhfhppu1No4
         qoFzcnwywRdDAFjkysBCbxFpvcuJdTQA1r0/dI3GJ1u60c6Zk95Lr1Rp28+NmG3dvW+T
         d2NMbJ31o0wPUt5yhOy+s7+I1KlPb/JgqjJVywtjaiz73l8BOpCW0KA8GwsVK5ponXHp
         GZmznBe5tatRyztO7ntZMQTSTuQ3Ru+iYC6KjtRvzKZGLmoyswur/HGPlqyFkAXclBWP
         C6cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787572076; x=1788176876;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S1OQ+o11GFCuRHAOrkLxBgVaNwncS1WphwbZ+fSPfb4=;
        b=j+3P0CzNpb21acQyREwt536pQdkWTL/V07W0UtfmC1VkHnaJL7YgXhVWw4Fu0MMFoP
         ICH2rz4cRujpN9ivyo5+oBV3WFk+670+CcSIdDau0Z9JPPSH4oEtE5sNAqaKmlsg3LUX
         Wpk5W69AuPdPciwJ9gAxxEphe0trTgzYfOLkvaz8z93Jc2D3NZ3Pm23x+KrZj15Uk8kH
         vl97cquKxKZqpA8bF59xGPCQNePpfrdCiyjgzyl8VXEaP1vunGfG7y2Od40N6FrkEh8f
         RJC544XQCBmVVJqzXA3mWcD2FPPqp7CzwRVYIgrwbc3eiy9Qday4XhuWswaW8wNouxLv
         n0/w==
X-Forwarded-Encrypted: i=1; AHgh+Rq4NfVP/DM54rBzP4OXT2s23yheDHDZzddUvc6GTRbvv/8+ePfQMJr0HhPYbNCiEr+FswJZzDPWBg==@kvack.org
X-Gm-Message-State: AFuF++myO5T+UQY0YWzvE0TMVY++TyW+rUCmmxs81czP74eCbJ8bc5C1
	mB20UVh5WXZXJ156QaBgYMrCEKi6SrZIJpV5UiLLo9xSTaBeDkuLejEauHXEEiyHQgU=
X-Gm-Gg: AR+sD115+NxoDvnpYLN0j6iDwHdVSlClvB+LWKARYY8zJdB8j2vCnTRsBRz0YDwjvcQ
	f47AuUBeyfcXohptSdeO+m3GgbCM2lspUSY0SjfmbjAz5gOJVyFOwjRGCdXekuwt4i9Y/ON9JHf
	I+2g0zzPdo+4xFCchH28WIPBvW358IkhIrNsBqoOvHp2J1kKlmd1JjgwZwECswOpvcL2/D1fIYE
	sbw77pp2z3PwVXQEqJEZO0VvofDjM/Cci6Q3Vtzx/LXJ5WioyEmdjHZYccJCe6JvMF6px88Rc2h
	C0BrbVYWG2Ys08Ez52rPZqI1pZJpKDD0Pg+Dq2aTIAEhWwuVVCXnWUcIETT2zbTwbLuHSTzj6sX
	cOTGaA4VXj3pQHw6+9XhzBm4+eQorWrr1meos10OIXEppoOMrqBZAhNU0nvi0GydZs0zAURPpEG
	sQYP+isib+88g1uBskUXYYMlPNQRBxZJli+Supic61zp4tgboz6E4IwgxF7Jq9bhOogxErn447T
	HLEH3Jm4iBE
X-Received: by 2002:a05:6402:450f:b0:6a0:a65a:a0c2 with SMTP id 4fb4d7f45d1cf-6a42f1a0226mr29775246a12.7.1787572076095;
        Mon, 24 Aug 2026 04:47:56 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a59e00108asm12355655a12.2.2026.08.24.04.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 04:47:55 -0700 (PDT)
Date: Mon, 24 Aug 2026 13:47:54 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: move LRU size accounting on reparenting instead
 of copying it
Message-ID: <aowvaq5RRDAtIKIY@tiehlicka>
References: <20260822024707.77192-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260822024707.77192-1-shakeel.butt@linux.dev>
X-Rspam-User: 
X-Stat-Signature: 7xi39mg4mzwyaxe5juspxuxsght5yfm4
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 935DC100005
X-HE-Tag: 1787572077-945172
X-HE-Meta: U2FsdGVkX18axFn2JhYoUzpN6lPvgqfE41tPHm/B6Tm9fbNAlqcxlsXtmVv/j+VBqwleaGiwIN1kkamVubub33ki7ZTtHsuc3S4zO95s8PscOIaRWW6tz2IL3zzUjjrcu9N+oeO5tg6SDu2biNyB49sjHAPZxJqIF3z6z/PrhfQ3Ghqqsn7AhNfX++7yBQdYmkpIHpHjXbn3ECz+pQh3ue40jmGfKnrNVThkGtvsYKP9iAmZHvgEzdKQLkRL9j6bp9yYgmljG/dGl/Ietldz7hMoKGJEogQ+JWzhvz50cFdYHNdLAAQm6hH0Hi+Cif2As6DbScn91z2lO1WeOVlVtxe2d0B0su2+5qzNm28f4kWZnx5KBU6l5kN3/Kqf+ULmbYtNKa93kFTmL3NM0lJOWrR8+qVv0MoQYWTQ556s1Hpz7s9In1nA3ewS65JtMpSF9WOUru1UleelDT2bWc35MVBrlzrtdDcYpbQjNtnJk9zSJmFAkhMxe3dWYSPDI6yJu+uV3ekbZpGuWcf0xcKL/hR5ZMORycDJRmYaSy2gUZdaGMFj2ErjzWIkj2eqa/+QfUhO6hvOanD6n+KcyGdmsF5l0z4OTNmYeJqJsxjRepcZrL6+g0hSv80UpFPMdyOnrqNO1q5U1sjCs3EVIuYIWhWoJYRnG5+es5AYvr6YBQoQUI3JglI0rjs6KfGkDblzK+sN5AWttahjOIYCdn9KHbkwnfnc2ExjaCgPrAcDkNo6v3FKXqasyZ1jgnTes2AqsG/1whaw9RBp/+73E1bqg87gTmQJ55BMxHuQ/AOPpgNFIGXaQyuF269eYnGlJ7YyeM7ksCQJC6yf1lZW+5sjCfFYB83lPsQ0ixJ2eQOcdJdbVYxRlUileGwW07nYEgPxn2DbjQQNqGGjhOwi4q7h7O5wLvbA82b10GpcSUMoNHaeL1EiOykDQlGGXOW3pbpMBZJ3bkiZL/6DDGH0+sp
 XYIw9dwE
 zjrjGKiwJLqX7q3v7NFV1zHAmZ6vaGTKCobhj3gMTXaJS4nEMO1pTNyu0C8mcK+Xp3VPz2FdONlbCowDMT84sMHiwTvbe9RrWrGbrTIlxRc97cDdFDspcn4Z2x7bo7Z4SCdaEfCz5VBauA9J3wU7E1jx3aGpLZKabkx4UGy4vaj3RkNF4A2TPfszcs10M1eqx7WklaUX3vtzwZBrEqfrt0SM8bJp5B6QyJ3hwS7hnI68MUEdh+VLbfwDAYx0TrodshweoU8ZQFMr2o8galFzcBYGe575O6dwMuWfRXvnyWFY1JloD29DvPzqorRLzx2JrZsDEv2/dkcP/+PUodVExcaVnV2KQxwP+v/6ufDEViK1q3fhslkiZFTVYUuJxh4lnOIVR2h4nELhp/4PjewIxZjLUbDUt87QMV8GHIpus79evqJtYUDbI6G9cx2rURHflJNA2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 21-08-26 19:47:07, Shakeel Butt wrote:
> When a memory cgroup is offlined its LRU folios are reparented to the
> parent.  lruvec_reparent_lru() splices the child's lists into the
> parent's and credits the parent with the child's per-zone
> lru_zone_size[], but never clears the child's copy, so the size is
> copied rather than moved.  lru_gen_reparent_memcg() does the same for
> MGLRU.
> 
> The parent is left correct, credited with exactly the folios it took
> over.  The stale value sits on the child and nothing will correct it:
> folio->memcg_data now resolves to the parent, so every later
> update_lru_size() for those folios goes there.
> 
> Dying cgroups are not freed immediately and mem_cgroup_iter() still
> walks them, so shrink_lruvec() keeps being called on them.
> get_scan_count() reads the phantom counter through lruvec_lru_size() and
> the scan loop then grinds through nr[] in SWAP_CLUSTER_MAX steps against
> an empty list, for as long as the dead cgroup lives.  Under MGLRU the
> MGLRU scanner runs instead, but count_shadow_nodes() sums all of
> NR_LRU_LISTS through lruvec_lru_size() and over-budgets the shadow node
> limit just the same.
> 
> On one 251 GiB host a sweep of every mz->lru_zone_size[] found 380
> counters describing folios on no list at all: 124777314 pages, 476 GiB,
> 1.89x the machine's RAM, across 57 cgroups.  All were on memcgs with
> CSS_DYING set and CSS_ONLINE clear, and parent/child pairs reported
> byte-identical sizes.
> 
> LRU_UNEVICTABLE needs its size moved too.  Its list is deliberately not
> spliced because lruvec_init() poisons the head - the unevictable LRU is
> imaginary and folios are never threaded on it - but the size is kept by
> lruvec_add_folio()/lruvec_del_folio() and those folios account to the
> parent from here on.
> 
> This depends on commit bf4ade7dbd76 ("memcg: keep folio's objcg same as
> its node") and must not be backported ahead of it.  Without that
> invariant a folio's objcg can belong to another node, so a folio already
> spliced onto the parent's list can still resolve to the child's lruvec
> until the objcg's node is reparented in a later iteration of
> memcg_reparent_objcgs(); clearing the child's counter early then lets
> lruvec_del_folio() underflow it and trip the WARN_ONCE()/VM_BUG_ON() in
> mem_cgroup_update_lru_size().
> 
> Fixes: 07a6e9a2c199 ("mm: vmscan: prepare for reparenting traditional LRU folios")
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Cc: <stable@vger.kernel.org> # After: bf4ade7dbd76: memcg: keep folio's objcg same as its node
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/folio.c  | 9 +++++++++
>  mm/vmscan.c | 5 +++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/mm/folio.c b/mm/folio.c
> index 59c477120b9a..c02dcea9c03c 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -1130,7 +1130,16 @@ static void lruvec_reparent_lru(struct lruvec *child_lruvec,
>  	for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
>  		unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
>  
> +		if (!size)
> +			continue;
> +
> +		/*
> +		 * The folios are accounted to the parent from now on, so the
> +		 * size has to be moved, not just copied. Leaving it behind
> +		 * makes the dying child describe folios it no longer owns.
> +		 */
>  		mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
> +		mem_cgroup_update_lru_size(child_lruvec, lru, zid, -(long)size);
>  	}
>  }
>  
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index fe7f0c52a18c..561eeec5628c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4635,7 +4635,12 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
>  		for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
>  			unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
>  
> +			if (!size)
> +				continue;
> +
> +			/* Move the accounting, do not duplicate it. */
>  			mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
> +			mem_cgroup_update_lru_size(child_lruvec, lru, zid, -(long)size);
>  		}
>  	}
>  }
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

