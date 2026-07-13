Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DE50C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 10:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34AA76B0005; Mon, 13 Jul 2026 06:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB706B0088; Mon, 13 Jul 2026 06:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212056B008A; Mon, 13 Jul 2026 06:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F07E96B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:22:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 80F1C94107
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:22:46 +0000 (UTC)
X-FDA: 84983364732.16.5EB91B2
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 415A7C0009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:22:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h9p5lrWo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783938165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hRcZAfhs+kHcVySJuPzxTTfP2MnAcNBGTb9R86cF3qs=;
	b=oiLsxuVPxrmDjENHchHsVXovdtxWZPPdutHk+yegAVS+9zAGn2oSh+4q4Ahl1CQQR2S66J
	clTRz38IeWJftpmj+9I3L1xZDUHdHFHrJxp4aa3gjddbygUCO/HKeSXqOBOMcg6YApQj2y
	+di/kGabsN1doSK1d8EyhiJuH6BSGcU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h9p5lrWo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of cui.tao@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=cui.tao@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783938165;
	b=rhyTvHWu964jDn36jG2HQdvSsA4K+YsO17MgLuumnIllIIVaMi9NrdU+4Rb54RSo/hZhD9
	nY6cCEnDDBBmeCqVDnV06O1j9x2bEedSAzzF5rqY2DLdTTyuYM7esU15pIqjHVrjCfMVKm
	SIEbEAm3BcjVF+yC0BGtPX0Njux6D/0=
Message-ID: <99977527-c2d7-4c70-8d92-03c306d3ec36@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783938158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hRcZAfhs+kHcVySJuPzxTTfP2MnAcNBGTb9R86cF3qs=;
	b=h9p5lrWoV13zy8DGeLR6b7gi3acso++iVPQs8D7wNMi/Ih6KYYfFJUmgfgkfEv8+XFNcc1
	OZcCWSmr4yLy1eth1NIjkqg0xOwrOFEP2ALqZBlkt2ef+WIhGVktu0vDSCRWZIfGJhWt9F
	7txsaIItmeJFSUeYUgQWdBIa6aEa09k=
Date: Mon, 13 Jul 2026 18:22:28 +0800
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Alexandre Ghiti <alex@ghiti.fr>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: update state_local when flushing NMI
 stats
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>
References: <20260713085053.2916813-1-guopeng.zhang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260713085053.2916813-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 415A7C0009
X-Stat-Signature: 3asm8g65fkyk91use3qmtsi1kaiec4ab
X-HE-Tag: 1783938162-972598
X-HE-Meta: U2FsdGVkX18fbo4QbsyN6eJfuuQ9RLxwUeiGdSK/8F1P8pXKDEDqSQ0isLjQhucyHOmcetJ+cPnuBkXv1HDQA7SmGPmXpHMzRFvo6ciwL7xVbkOni1b9g22+if9ldh4e9s1CGfU/lgLFL8aLgDbmKbZ3aOli6yMU4MNi9Kb5rG6epk0XQhKN9UHfzSefX2b6IKDrrFagAR6du09M5AgktL4I4zDZln0KT0AV9w6k15Q+MYLQMJlZ1M2nL+0c1psHz6zNnFue5fklpa4HL1ep488tWlvo0LxMwKGaewGNUxHakV0HQ68IVw0X+Bk0vHmmeCWUWAvMpjYDUxF7gbUWq29dmGk44Dz20NjWlEcMvJRIC0z4EZVucpPgSUFk7RwMdFcFA6EUhKSgLHTrFPd/Z3hKWvsQufa2MlzYNyx6mqbKrHBSG3n5rJ8WD7bvh9cb8o59G2//eNfsqY6ymV8AsqfH/1rtgjJlCykvR3NLtCSPE7JL9dHvtF5Wiquk1eBAgEmr6XUTracu0Z+J1dcRGrj5/QFoMAyCFfYUAJajwFyjZOBbX/4uKQqd0W89JmoDhuNCSwLFKUlLq8ujNYjGp7euab+9QhoFoeCWMP65zL1EdSTiGz0BsRcSPkAyhSqAf/qIGN360IGeoRyCIOa7zdUFKv9Z2a681T4otL7GX0Wiw8PO3Sft4FMS2n06xZNObhFoRamidjUCronQAlyjOYEc8K2nXeOiaL8LKWOfUSt8QGTJY7K8sPgOdkGU4+WQP1Wdw4BNEq9aC88qbsVHlMZKkERsQKy9RzRpsXQKP5T2QsECK3e8JVeo9jjLcEFUnXh2PGWlm2e9iF7xEZqoxY7eJy0Glf/Y8Bil7PSrhK4+bFbe9lm4HqWEYATOFs57oIKICZGtdNT91Z3RkiuE2AGJ6grQSxvzQzPgoZyQTU0mceYnIrny/w+Is2eXzDWw9qltpZoquK8RRxraGoB
 Mfe428UX
 +UZrt7TyZ02Xcjm4/tnY1O4gdA6Jjbpz3W3Swft73E9pHvAPAklajE1/OOvxODrdX5wW75Sf3dMzyNn8uMWoYM3KfXNfX25uAF0CXURh4nTQs8YFQ1mbFmciE8kpkrlVxgX7WZGasIc0xwEqYMfWwPRHGw6lT/Uyz83QC3Mz4aULZcJRE71m5FLb4z5nJeg6SYa3R2F/7oIyYjwZVSLjwioO67jz2Ng2QJ/RgRJ0GH+wCNchJGAaVCtLCh0ASFVz6geacJ4qedFC0u8imigAfAMWVgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/13 16:50, Guopeng Zhang 写道:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> flush_nmi_stats() updates state[] for kmem and slab counters but leaves
> the corresponding state_local[] counters unchanged. Local kmem and
> slab statistics therefore miss updates collected through the NMI-safe
> atomic path.
> 
> Update state_local[] together with state[].
> 
> Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>  mm/memcontrol.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 22f55aeb94f3..02599b8b6bd5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4443,6 +4443,7 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
>  		int index = memcg_stats_index(MEMCG_KMEM);
>  
>  		memcg->vmstats->state[index] += kmem;
> +		memcg->vmstats->state_local[index] += kmem;
>  		if (parent)
>  			parent->vmstats->state_pending[index] += kmem;
>  	}
> @@ -4460,9 +4461,11 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
>  			int index = memcg_stats_index(NR_SLAB_RECLAIMABLE_B);
>  
>  			lstats->state[index] += slab;
> +			lstats->state_local[index] += slab;
>  			if (plstats)
>  				plstats->state_pending[index] += slab;
>  			memcg->vmstats->state[index] += slab;
> +			memcg->vmstats->state_local[index] += slab;
>  			if (parent)
>  				parent->vmstats->state_pending[index] += slab;
>  		}
> @@ -4471,9 +4474,11 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
>  			int index = memcg_stats_index(NR_SLAB_UNRECLAIMABLE_B);
>  
>  			lstats->state[index] += slab;
> +			lstats->state_local[index] += slab;
>  			if (plstats)
>  				plstats->state_pending[index] += slab;
>  			memcg->vmstats->state[index] += slab;
> +			memcg->vmstats->state_local[index] += slab;
>  			if (parent)
>  				parent->vmstats->state_pending[index] += slab;
>  		}

Looks correct — state_local[] mirrors state[] for this cgroup's own NMI-accounted kmem/slab charges, and pending→local is properly left untouched.

Acked-by: Tao Cui <cuitao@kylinos.cn>

