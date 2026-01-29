Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8F8D73E83
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CFE56B0088; Thu, 29 Jan 2026 16:00:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A8086B0089; Thu, 29 Jan 2026 16:00:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DEE66B008A; Thu, 29 Jan 2026 16:00:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7A2656B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:00:26 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFC67D38B9
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:00:25 +0000 (UTC)
X-FDA: 84386219610.02.4ECFBD3
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id DB0E2C0010
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:00:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=csaD1u4M;
	spf=pass (imf22.hostedemail.com: domain of martin.lau@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769720424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TiUXe0NVa0kF6pHW07f/TCaF9Zrsenq0NZUbxUvg1RM=;
	b=Z0MolRTAR42wLs+MoGv2bsNXuRCXMkNBy1MnhTHg86uKSU3chznHqNT9qGnYAl0h5U6xfd
	k/+r7f2zv9F4IOr3gVvvmDUWN9sC/1ELC2aETDEGgXqPPLgL9X9nQZvJ6tgNE5MyFBaKeU
	U190mSTBYRZAAFfmFA+AeXQS7z3je+g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=csaD1u4M;
	spf=pass (imf22.hostedemail.com: domain of martin.lau@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769720424; a=rsa-sha256;
	cv=none;
	b=vR8rLBnckabF2sd8IIBdQYx3ShgCmxiY4lOFPA/wMtp9/xZ+P5klxsiTNSGZqH9QXMVSkr
	toBA7lmepmusHHW9CmOndl632fx1AUmnCsiD751JixINhKxQj5X62BFhakZNKc32IVpWcf
	oGPnm8uAR4aeSZEortNZrS4V/nLPWsQ=
Message-ID: <9483528f-83dd-4a30-9489-cf0fac4de5f7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769720421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TiUXe0NVa0kF6pHW07f/TCaF9Zrsenq0NZUbxUvg1RM=;
	b=csaD1u4MYsjHmIWe956H+UP13R4IH4CaoZsV2DHzoLXw9+Ikq2QV14+phqkKjGLmpV/i8Y
	G4gR+n5y9+2azJ5ifRuKhVCSkUMwiNkHPP+lEi5sHXarFx0qBnM1wfC3EY72pa9LiMQUq/
	TaHFSRDConbjBi9kbFgeBFfPCY7/xZ0=
Date: Thu, 29 Jan 2026 13:00:11 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v3 07/17] mm: introduce BPF OOM struct ops
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Alexei Starovoitov <ast@kernel.org>,
 Matt Bobrowski <mattbobrowski@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, JP Kobryn <inwardvessel@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Suren Baghdasaryan <surenb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>,
 bpf@vger.kernel.org
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
 <20260127024421.494929-8-roman.gushchin@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
Content-Language: en-US
In-Reply-To: <20260127024421.494929-8-roman.gushchin@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: m7gd3sp9ago34qm5oeux9phoi1de3dex
X-Rspamd-Queue-Id: DB0E2C0010
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769720423-730255
X-HE-Meta: U2FsdGVkX1+3KuwSKLspGA20N6B0Rls+9UsrqfiG2DhHYkm48Kf1GjIG39vT2XKER8Vb5Ak0WS/tztRu/ntDxwseb1AHaNBR+yDqVlHydPzt3SIpCOTxCcYIj6VwvT5cnlBpPTjzPG9y35MPJ//WocRTGy7wZ+Sljz3cFeUvYQjzm3Vodl+U4djmaZ/muiUxj8Yf26/hyG6Va+XRJHYH5EkDDUNE+0PhRINRUb/IaUEVrZDBwQ/ZCOH427BnIBeGqmguaB4OcoKySkspK09ACxfKLJYVGnr6l7H4ewfd82YiEPBvzTIHz58E3vZwVHuiNqa/4xZR2tCi4SI4kE+2vD2NQStq3fJfKm1kHDosQgci4Tfa9fqIYWHCYRGfndo6PGES0/fpA93VioIi5y+9cK9MfgiJU3tXtnlWEGG+VQjKZ3FPoYuz4qlkFXsSA8hxQeVOhauJ00D43sxvHFLMmphoFgEeLOaa59J1CFnZxmjXJKkfN4/D24FMSR79sEEXSkeyEKOWrgUsId9Y9shGaVhbHm/naov2D7h76RvCrxyHgEAU8nVTVs6CfY7ANce5HI+jlwvCWkcpBwYU4oe02ke9MmeTe1sR2wGNgr2LZ5tMHktFgH99I3DhquPLR3eLB0yjl7UG+uYcQZ5nlvVZsRmmrJVGIoQFxzEAKqAq68sRa9/c/negaez1qG8g34O2+CyZDiMfiUS9TfGbiSFiDKg4sAiOhplD7RZOa8VoXvxVfMYgjiURN8x458o5k26kyBJyZSdmzsJ3ct/biC34ap79GYUdE99bg7qmARzjaJk5uN4ZkHZHSxepuVwp1LWJ2nGOgodC8YcgXCvj5crlH+VsskIh9MoGqsvX7Qd6tkfBpJfDJOOZIeJ4QG9Pzs3klWxh4TcVng53O+61m3SigoZAo2c/tHF2pQVSyUwv10/yrJLUB56epefkJvCjPsq3w0pqmfiDtLMv2r5CYWQ
 t8Dlg3cF
 tLg3bRhzjLlrMLxz8ga+FZgTQTHOwmjx+Zlu2C1i/NJVn8CLEqMxekgPLCnpHhZIwmZ9UsF9/rh83Ry/OAYXhOHrdavBoENHqSbo3AEp0dYideFYGNMqaDkH2Dcgu/Sxinm1xE2T3lwpPT2qHUr2RjFhiwJy1EwTaR0IAxPDSVApN+L+oxfCQ7SXWXWqHA5WMdmnuii5c84gJ8VeQ1OOAkVYyDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/26/26 6:44 PM, Roman Gushchin wrote:
> +bool bpf_handle_oom(struct oom_control *oc)
> +{
> +	struct bpf_struct_ops_link *st_link;
> +	struct bpf_oom_ops *bpf_oom_ops;
> +	struct mem_cgroup *memcg;
> +	struct bpf_map *map;
> +	int ret = 0;
> +
> +	/*
> +	 * System-wide OOMs are handled by the struct ops attached
> +	 * to the root memory cgroup
> +	 */
> +	memcg = oc->memcg ? oc->memcg : root_mem_cgroup;
> +
> +	rcu_read_lock_trace();
> +
> +	/* Find the nearest bpf_oom_ops traversing the cgroup tree upwards */
> +	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
> +		st_link = rcu_dereference_check(memcg->css.cgroup->bpf.bpf_oom_link,
> +						rcu_read_lock_trace_held());
> +		if (!st_link)
> +			continue;
> +
> +		map = rcu_dereference_check((st_link->map),
> +					    rcu_read_lock_trace_held());
> +		if (!map)
> +			continue;
> +
> +		/* Call BPF OOM handler */
> +		bpf_oom_ops = bpf_struct_ops_data(map);
> +		ret = bpf_ops_handle_oom(bpf_oom_ops, st_link, oc);
> +		if (ret && oc->bpf_memory_freed)
> +			break;
> +		ret = 0;
> +	}
> +
> +	rcu_read_unlock_trace();
> +
> +	return ret && oc->bpf_memory_freed;
> +}
> +

[ ... ]

> +static int bpf_oom_ops_reg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_struct_ops_link *st_link = (struct bpf_struct_ops_link *)link;
> +	struct cgroup *cgrp;
> +
> +	/* The link is not yet fully initialized, but cgroup should be set */
> +	if (!link)
> +		return -EOPNOTSUPP;
> +
> +	cgrp = st_link->cgroup;
> +	if (!cgrp)
> +		return -EINVAL;
> +
> +	if (cmpxchg(&cgrp->bpf.bpf_oom_link, NULL, st_link))
> +		return -EEXIST;
iiuc, this will allow only one oom_ops to be attached to a cgroup. 
Considering oom_ops is the only user of the cgrp->bpf.struct_ops_links 
(added in patch 2), the list should have only one element for now.

Copy some context from the patch 2 commit log.

 > This change doesn't answer the question how bpf programs belonging
 > to these struct ops'es will be executed. It will be done individually
 > for every bpf struct ops which supports this.
 >
 > Please, note that unlike "normal" bpf programs, struct ops'es
 > are not propagated to cgroup sub-trees.

There are NONE, BPF_F_ALLOW_OVERRIDE, and BPF_F_ALLOW_MULTI, which one 
may be closer to the bpf_handle_oom() semantic. If it needs to change 
the ordering (or allow multi) in the future, does it need a new flag or 
the existing BPF_F_xxx flags can be used.


