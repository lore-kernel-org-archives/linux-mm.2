Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39518C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 17:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B8126B008A; Thu, 30 Jul 2026 13:48:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1697F6B008C; Thu, 30 Jul 2026 13:48:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A6FB6B0092; Thu, 30 Jul 2026 13:48:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD6D56B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:48:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6191DA107E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:48:54 +0000 (UTC)
X-FDA: 85046178588.29.1E61FE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 697311A0002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:48:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k7dLH5Db;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785433732;
	b=ijIfdTuOb/U5bY/qnM5snI2jyydnXMu19VHjTMNISbBxiG0f/pZ9qOyoKMAq+bW0S5V91P
	MaKl6J102G9VnsNKgET4J37jLzcDhgELxKXJVQXf+Wrh9srNYe+RISHTx9izQ21zZOvvLm
	3JgeEnZP3nfv6X1CH4210R7Wy9/gaWg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k7dLH5Db;
	spf=pass (imf19.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785433732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hYmo7tONz+VGeYe0ElvsPHUXuAXotmKlny3soYpHBOc=;
	b=YvmedtnHQXhvnjmY7wL5lZ+QLBui7jLJwUaUIYLoFbBxsgjCQGauYv6EY5aP1Q4StaIwNp
	gJG8EoOMycruiur8VnvPg6sKHjEp+h7qxo9CMs20x8SKrKnLl5gHnSFlpypek5r3J9BFcb
	SfHc1Qsg7eEQtzsJutRIVfq0Tqko2XY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7950A44DB3
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBCF1F00ADE
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 17:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785433731;
	bh=hYmo7tONz+VGeYe0ElvsPHUXuAXotmKlny3soYpHBOc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=k7dLH5DbVxqWwLhAx4OLroBu8CXze3g/r36AxmzpPI+egB93RyFRBAHT3woRKV537
	 UtNwUpoiPK9BheIrwptTFlNZItz8Xhwa2o2kDsDovhdEH/qdK1s/JXRqX9T1inGmHP
	 nUY6dk7zLKvbFsXJ1OOcsi6DWCXmZ5l3Hm2uGYoD+RGVbOk4NoDWrIZ4r/jzcRP7ml
	 vL9YbHajbDEYVW4ydAa9ou8KfxDbIYRQl/txEIbayFpZuKLjKqrRf9NHhl6TTKmpeK
	 qlUiO4Uq/+tAY/g6/S9sWyk3HvyoUcpqotaVCTkUuQ1uDTZhvdjzqmPDudrTZSM2Gv
	 HUnsz7Ml8vWHg==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c15f47e6297so3563566b.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:48:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rrw7uWHpDVADbsB5FDmfZ+RFxxt6TlRFeY+60G0Pj6R206baxHm5szxNAwnRnbKd05i4sU2S2u+Ow==@kvack.org
X-Gm-Message-State: AOJu0YysyrT/L8HKBmrMW1P85O/OplEyVuG/TTwbRuHMnWusdHi12cuF
	7/SAW5wo3yT5/N5+O3MS9lFoOxmNnZcjH7ZMimmaaW6DFPGDmA3f8S2cHNzFM+DFfP+ub3vCcGm
	KhJTba4dwCY3wyz8QChM5CcvdrkmqzsA=
X-Received: by 2002:a17:907:d78a:b0:c15:c257:9d54 with SMTP id
 a640c23a62f3a-c1fa5858583mr175709366b.62.1785433730181; Thu, 30 Jul 2026
 10:48:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260729084206.77793-1-jiahao.kernel@gmail.com>
 <20260729084206.77793-2-jiahao.kernel@gmail.com> <20260729155858.c7aabff48166a9bca4d68ac3@linux-foundation.org>
 <CAO9r8zNhBCghP8T_98z2p==Cfs_=kamcRN_3ROxaj3R8PN2Qvw@mail.gmail.com> <c4c95102-72e2-a44f-f16e-4134ba6bb060@gmail.com>
In-Reply-To: <c4c95102-72e2-a44f-f16e-4134ba6bb060@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 30 Jul 2026 10:48:38 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOSTYC3D_2CxapgvXGaZRUdnGetPGz2XgdUO8OygfuEiw@mail.gmail.com>
X-Gm-Features: AUfX_myEtCNdQrULfrezj6dXoutnBvSotAqAHE8SqHPmGyOxN3RP0QklBzi96nI
Message-ID: <CAO9r8zOSTYC3D_2CxapgvXGaZRUdnGetPGz2XgdUO8OygfuEiw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm/zswap: Fix global shrinker when memory cgroup
 is disabled
To: Hao Jia <jiahao.kernel@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org, shakeel.butt@linux.dev, 
	mhocko@kernel.org, mkoutny@suse.com, chengming.zhou@linux.dev, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 58muww19dsycjmaurx6pheq5ntsbgwmm
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 697311A0002
X-Rspam-User: 
X-HE-Tag: 1785433732-150764
X-HE-Meta: U2FsdGVkX19aJ6jqYJngcM06YTSE3N3F/fv7Hwb0YimI65Aeghi+UHJwSB0M7quXuyDhRMGvvRWmfsBif1rBjn109WwIq5WjBCb/O06QkZmZEk5d2+7FU1N1QLXYQ66XegQGv40LOazLQCcqqkaQU7BRqStDRkZNW9GFWKRQCIJTxQGgW0IB/XYRYbjNXtRpN7m8Nx+y//YMMFpfnZVXbxttH0vx7ZQ9rCWwxZc0Vqh2gKi6VqZT9riXzdQPHFjRLUBwKIiaE8Eg815Frh2hDYxVv3remHibyNfrTzMlJP8fJxr2TdeDJ7zhg8I29C6t2xaeywOcvjEx6iQy8STpiCVENtI+PiMmkpJlz47gcWmrbix9LCrUn74+WXZSckD0yAwxGO9IQLl+KmTGVIhf18d3fUZpOZQWSZlTl+NWhHwgKsxnvccCrtCEJJwKTldAyas0WbnAW/i7NJFBJCvQN9DXf/YFXTWk/NVyp1Xs9epta3tHTCybYQW2vSY4T9uk9ltq+RSqlvBMjIIdByzha+P+l2SakAPGSEqx2gZbA/RN4MfnIs7JjvBhWME8n6nLGUQH4PncETOIDJCQmjiegDdup4/w4idXiZVWrMSBI68Ds+4SA8NpNTsNcst3c2ow97m0S7VIkHxcCCRVO+2qSSGhop162YHjkalG0j6Mhjcw7onHI13UKYa6wrk4Wbu4KeWxDnFsvWYYCEwi3kb67rFt1YQrQEgM60do8Iwg1WZHV/XvAojQdtOa39JbZYcOEyZMslDPVvYwZKaNeb5qjy2f7TjqRnEL+WE1o6zUJxsezS5UOfGFPhwdQ2PqpaoprDgUMbYpvYKsbJo+jk57fnB8jkx9qHO2j8PhCUgxicM9ip5xM8AXgULhauahpXymOKLhKDQgYlwZklYklMP2ndiTBScc8wjeLgen3R1nrHw57wxIWHUoONg443akXVTb8ZKEc9gFuphUKd7l+XZ
 704/XYi1
 ferITZFYWDVNiWu720cHy/vyJaQHGNgyQONL1h9A2YbqwuZdSJSTvAidNrSHLLUjg6pEu9DP6VDwSy7jY4V7uFMzA5buFMirrIOta4yVztZuVbelxHEgpcmaoeqkqFD+iMAtOjfvbjR2K3iY9oPMoNjOqhzJ46wqjeVkiATP2maAuXOgCx6TfyH898cboLaQi07yhtHt2GyATz0if6/Cx2r8Na4u74eRtcn/M9pZPTSYlelx3HHJzXOL1zMn3O5vNb/clzUdzU+zf4WoqxDW5mByW7PWE2FIV68tXlBmiYvpfIa4+8dIpYtOhPZzR7NIWsV4m+panIqaKdbs6jq9uO5ckOz7DxWnEXoj74/fRqVU8pNIx114yUsoutPOr3KKdnutUAYOe4SURFJYExHO9XBRZM9TxrVVNZ/NkXDaLIY/B5d2GWP72RrmdBdFNZPYMkqzN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Yeah, it isn't. Probably we should drop "Closes". I assume Hao added
> > it because checkpatch annoyingly complains if you add "Reported-by"
> > without "Closes", so Hao just linked to the thread where I pointed out
> > the bug.
>
> Yeah, checkpatch will complain if it's missing.

We often ignore checkpatch if it's unreasonable.

> >> AI review asked a couple of questions:
> >>          https://sashiko.dev/#/patchset/20260729084206.77793-1-jiahao.=
kernel@gmail.com
> >
> > The review on patch #1 is something theoretical, we discussed it at
> > length in previous versions.
> >
> > For patch #2:
> >
> >> Does this batching logic break NUMA fairness?
> >>
> >> Because for_each_node_state() always starts from the lowest node
> >> ID and breaks when the scan budget is exhausted, subsequent
> >> calls to shrink_memcg() will restart at the lowest node ID again.
> >>
> >> If the lowest node (typically Node 0) consistently has enough
> >> items to exhaust the scan budget, wouldn't we exclusively evict
> >> pages from it while ignoring older pages on other nodes? Could
> >> this cause LRU inversion across nodes, keeping older pages in
> >> memory on Node 1 while hot pages on Node 0 are evicted?
> >
> > Yes, unfairness is possible.
> >
> > For global shrinking, it's probably not an issue. We reclaim until we
> > hit the acceptance threshold and it's very unlikely this will happen
> > before iterating all nodes (given that the batch size is 32 pages).
> > However, with the shrink_memcg() path, we only reclaim one batch, so
> > there's a chance we'll always reclaim it from node 0.
> >
> > Maybe we should just drop the early bailout and accept potentially
> > doing more writeback than needed. Hao, WDYT?
> >
> If we scan and attempt to write back SWAP_CLUSTER_MAX zswap entries per
> node, it might lead to excessive writeback on machines with many NUMA
> nodes. Furthermore, I'm concerned about introducing higher latency in
> synchronous shrink paths like zswap_store()=E2=80=94especially on systems=
 with a
> large number of NUMA nodes, where it could end up writing back hundreds
> of pages in a single call.
>
> Maybe we could do something like this instead? That way, in the
> worst-case scenario, it falls back to the baseline behavior without
> introducing any extra latency risks.

This basically errs on the side of honouring the batch size
(under-reclaim) instead of doing more writeback, right?

I think I prefer erring on the side of doing more writeback, as it
would ultimately result in less LRU inversion, and we are already
doing writeback proactively during reclaim through the shrinker.

The other option we can explore is keeping the existing logic with the
bailout, but start iterating the nodes at the folio's node in the
zswap_store() path. Basically pass an nid to shrink_memcg() and always
start there. This will avoid always reclaiming from node 0, and the
node of the folio being stored is more likely to be under pressure and
need the writeback. I am not sure how complex this would be and
whether it's worth doing.

Johannes, Nhats, any thoughts on this?

>
>   static int shrink_memcg(struct mem_cgroup *memcg)
>   {
> -       int nid, shrunk =3D 0, scanned =3D 0;
> +       unsigned long node_batch, scanned =3D 0;
> +       int nid, shrunk =3D 0;
>
>          if (!mem_cgroup_zswap_writeback_enabled(memcg))
>                  return -ENOENT;
> @@ -1289,14 +1313,26 @@ static int shrink_memcg(struct mem_cgroup *memcg)
>          if (memcg && !mem_cgroup_online(memcg))
>                  return -ENOENT;
>
> +       node_batch =3D max(1UL, SWAP_CLUSTER_MAX /
> num_node_state(N_NORMAL_MEMORY));
>          for_each_node_state(nid, N_NORMAL_MEMORY) {
> -               unsigned long nr_to_walk =3D 1;
> +               unsigned long nr_to_walk, budget;
> +
> +               /*
> +                * Cap the scan at the per-node LRU length so each entry =
is
> +                * scanned at most once per call.
> +                */
> +               budget =3D min(node_batch,
> +                            list_lru_count_one(&zswap_list_lru, nid,
> memcg));
> +               if (!budget)
> +                       continue;
>
> +               nr_to_walk =3D budget;
>                  shrunk +=3D list_lru_walk_one(&zswap_list_lru, nid, memc=
g,
>                                              &shrink_memcg_cb, NULL,
> &nr_to_walk);
> -               scanned +=3D 1 - nr_to_walk;
> +               scanned +=3D budget - nr_to_walk;
>          }
>
> +       /* Nothing was scanned: every LRU under @memcg was empty. */
>          if (!scanned)
>                  return -ENOENT;
>
> Thanks,
> Hao
> > If you respin, please also drop the batch size argument to
> > shrink_memcg() as it's now always SWAP_CLUSTER_MAX.

