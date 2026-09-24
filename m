Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88CF2C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 21:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72C326B0088; Thu, 24 Sep 2026 17:19:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704076B008A; Thu, 24 Sep 2026 17:19:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640C76B008C; Thu, 24 Sep 2026 17:19:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 438966B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:19:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0629A0439
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:19:12 +0000 (UTC)
X-FDA: 85249921344.12.02CE007
Received: from mta1.migadu.com (out-67.mta1.migadu.com [95.215.58.67])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3E49380005
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:19:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u4brnE0F;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.67 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790284751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W3KWs+GfP33gfAN6xlUKjik7a9zFv4BKje+Srwlgmkk=;
	b=eHifoSbHBrz3JErzuS16zT8i9HMago4CNXe7FXzO39Oi11S2v34SbN8cRQTpIO4+7vXMkt
	PKM5JD2mbOiLM1LYWr/gEQtfWQfHb99mI9NG2wSA7/ljBxUdszFzSfwBmuUZvAkqL7AAhD
	UAstFtM0fFR9wvze3LNB8kEVb1VGKgk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u4brnE0F;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.67 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790284751;
	b=LACDb0HMKs8NMwSaTjruD0V0+aHaoUc93rglWW82CjoliJw5ims8E1yeWNMT6ZRcFRAmVF
	n+HpzTWkYtfsRaLWilcKCATKONRcc6avzZ0IioXuEnJZWU3geJM8NgMtsXJrp9c/4/pUGk
	zpnMXVsdzQ390SVurDWZWMIAS7iivBY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mU5oJrgH1sYUjWonRB98Yad1omw/P5Tdsx9/iTNI1j0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790284746; v=1; x=1790889546;
 b=u4brnE0F1411IWpvTlPuKrmb+pPcXKQAcZcbVyFNSaPhlH7xA6yjcjVwGCK9iTlyyLrmu5OM
 GeMZ7BW5QY2OYrigXc1iTUf0IP4j9GWGb4sEcvhcARFhE3qMbI/YKf6SbM9fVrv8z9zfkBynsPZ
 bcJswsyvHNLV3jNCSgLDV9OM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 840ded800c29f88f;
	Thu, 24 Sep 2026 21:19:06 +0000
X-Mizu-Trace-ID: 840ded800c29f88f
X-Migadu-Flow: FLOW_OUT
Date: Thu, 24 Sep 2026 14:19:04 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: JP Kobryn <jp.kobryn@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Michal Koutny <mkoutny@suse.com>, 
	Amery Hung <ameryhung@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, Donet Tom <donettom@linux.ibm.com>, 
	Greg Thelen <gthelen@google.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] memcg_ext: allow BPF to defer memory.high
 enforcement
Message-ID: <arWTPMEm5C9tFeGc@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <20260921192559.2619635-4-shakeel.butt@linux.dev>
 <c8b8504c-8e54-479f-a372-3d2755edaf88@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8b8504c-8e54-479f-a372-3d2755edaf88@linux.dev>
X-Rspamd-Queue-Id: 3E49380005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: nh7qsi9ihggf6b13pzt5dqysubayy1id
X-HE-Tag: 1790284748-155560
X-HE-Meta: U2FsdGVkX1+mIJUqVD1XN8XqL9KUrbP3SC5mEcNbLn/yc7J8TfV81pjtOtrss3e5NF7HiVD6TLClN2krhDD6ILzb7iVTAsbCRtc4JQc/DdE+CTLodSx6GwmUzPJj5P9r8EV0y+NdQyDAujcrEOdVgMzP+zWiAjdhmBIRbRfQUqxZ3E24GK1vIaeOtX6VPTXWztODIzYjfQ2HMEjoL4O07bWpFOsRF4FRERV0xiu+m/Tg0ClXDtv064NddqGaWHzB7IQBwgh/fPkMzFC0syJVMvu2Ea2EBRfQGZOLZN+0Ry2iH5kCe5eezzhAXw5OCsQpiSsrc/s2vAis5T35qGQXn4GhISrNNoieZLAVnAyk5qCtwXetVTg57X6/lqpTyH2jv/JMX7eO11KeTZ6gmntptjJrdBeK3+6nBBYg8sw6ey/z+7eEoaFg4swllxJORJmG1h7wdmoqEeGd2wfc/1JQz/aKV6Wv7TX5+cDpnftoZcSy4isILxJezLWPba9U2bayHVpM6lDrdfr105QBZAOOAjsRhI5v1cB+Bvol2WLf/I3V5xFWlc+eYqJDE81D34cFPqazeicgsx2l3rQVnYHINitZ5UTijXTp/y2tTQ0dkGlSGyDihzo+qY/xjUZOxHZzN9YgyFRSqSP8buutPhwSFvpYvnHIGPnKbooGgBkHV327fs/L894Ti1sd/wAdqjHEqc/HCS8AHouUCKRBVE4zh3KSSvSLYdmkVsCcJl8EBJqzq0NryLMcnQIL8Gpj+U5VZtHo3D1TO+oDNj2t95XLR5OxN3N74B2JSoJXAqp2WqGUBZDSJblsRgRekPNGQAeSWYPbA2B6yLFUNqYsik5XwlwSzpTgYsA+lYKJqh/MiQOYzfRcphRQP27XH69fX5CS2FVV4yiO60lcYK8NQKT9H68tKk+SXkmor9QUznGrY7SzHbrTT8s0jWccw2h+GHHde7biRoc1DeEodIF7pHH
 57LVQNxP
 Szak10CyXC+9nEsP1Vv3oHyn72YC8TWAm1TxZUSdfom08VIXb0OAtWSI+exrslej0gv8bVdFlTYS0KcXYCyxD3scAWHo/n0axA6qWRGyEf72vDK4TEPeecqjOEhVvfbtSKQ+6cu3pySE+HGb5d/5HRT6YPedT0H8iSX9BGBaPMf8DYwtz0go/P7AQnOZj/XPhraxIq33keqkzUzpGhwAtC/+1FFfgE38lbReBphTEJem9HsXuvKRYP/UJrIqk/cnl5ZJCv4yjr8J7Lxu1i7KDu4JGMuTFydRmUfhAi0Xeeim2wsbDluNGqfyWjvrHuFpGYL3JuX4sTia4hQGNvJ7VJsLIlYDWEZj/mtpNXzekFrays1aAOS7Lt2813/cGTRa2Fzb9GqR4yokMQ1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 01:14:59PM -0700, JP Kobryn wrote:
[...]
> > +static void bpf_memcg_ctx_init(struct bpf_memcg_ctx *ctx,
> > +			       struct mem_cgroup *memcg,
> > +			       struct mem_cgroup *over_limit, gfp_t gfp_mask)
> > +{
> > +	ctx->memcg = memcg;
> > +	ctx->memcg_over_limit = over_limit;
> > +	ctx->task = current;
> > +	ctx->cgroup_id = cgroup_id(memcg->css.cgroup);
> > +	ctx->over_limit_cgroup_id = over_limit ?
> > +		cgroup_id(over_limit->css.cgroup) : 0;
> > +	ctx->nr_pages_over_high = current->memcg_nr_pages_over_high;
> > +	ctx->gfp_flags = (__force u32)gfp_mask;
> > +}
> > +
> > +u32 bpf_memcg_high_policy(struct mem_cgroup *memcg,
> > +			  struct mem_cgroup *over_limit, gfp_t gfp_mask)
> > +{
> > +	const struct bpf_prog_array_item *item;
> > +	const struct bpf_memcg_ops *ops;
> > +	struct bpf_memcg_ctx ctx;
> > +	u32 acc = BPF_MEMCG_HIGH_NO_OPINION;
> > +	struct cgroup *cgrp;
> > +
> > +	if (!cgroup_bpf_enabled(CGROUP_MEMCG_OPS))
> > +		return acc;
> > +
> > +	/*
> > +	 * Only the default hierarchy has a cgroup_bpf, and the static key is
> > +	 * global, so one policy anywhere turns this on for v1 memcgs too.  A
> > +	 * v1 memcg still cannot get here, because memory.high and swap.high
> > +	 * are both v2-only and so it never builds the debt that leads to this
> > +	 * call.  A hook on a path v1 can reach needs its own cgroup_on_dfl()
> > +	 * test: a v1 cgroup has no effective array and an uninitialised
> > +	 * cgrp->bpf.refcnt.
> > +	 */
> > +	cgrp = memcg->css.cgroup;
> > +
> > +	/*
> > +	 * A program can allocate and re-enter the charge path.  Skip the
> > +	 * nested call.  This guards the callbacks only.
> > +	 */
> > +	if (current->in_bpf_memcg)
> > +		return acc;
> > +	current->in_bpf_memcg = 1;
> > +
> > +	rcu_read_lock_dont_migrate();
> > +
> > +	/*
> > +	 * A memcg outlives its cgroup while it has charges, and
> > +	 * cgroup_bpf_release() frees the arrays when the cgroup goes.
> > +	 */
> > +	if (!cgroup_bpf_tryget_live(cgrp))
> > +		goto out;
> > +
> > +	bpf_memcg_ctx_init(&ctx, memcg, over_limit, gfp_mask);
> > +
> > +	bpf_cgroup_struct_ops_foreach(ops, item, cgrp, CGROUP_MEMCG_OPS) {
> > +		if (ops->high_policy)
> > +			acc |= ops->high_policy(&ctx) &
> > +			       BPF_MEMCG_HIGH_VALID_MASK;
> > +	}
> 
> If I'm reading correctly, the gfp_mask at this point doesn't account for
> task restrictions, so the BPF program may see __GFP_FS, __GFP_IO, etc
> which may later be cleared when setting up the scan_control instance.

I am passing the same gfp_mask which has been passed to try_charge_memcg(), so
it should be same as what reclaim_high (reclaim internal) sees.

