Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC8AE6BF3C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 23:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCD9E6B0088; Fri, 30 Jan 2026 18:29:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C638B6B0089; Fri, 30 Jan 2026 18:29:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6F5B6B008A; Fri, 30 Jan 2026 18:29:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A359B6B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 18:29:45 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 58CBAD4CEF
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 23:29:45 +0000 (UTC)
X-FDA: 84390224730.06.628D249
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6549F4000B
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 23:29:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TjWkndFH;
	spf=pass (imf12.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769815783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QysXvGg4/WNW7ja6nSUtrR5V1p3ZPUnXLANtyVmNAWk=;
	b=ZX32V9y3h9yUrw1003J1eZgiqHGPdQVazPFE8CbDH0mSpTc/ZSEEMGEsOK6AVk14dZa/Xc
	6bffbF8j76vJOpZnJnVwMqWfzM5eKxJQNy5qPiYYWoe0M9YRy9HXvkxQbFEDnl2/Dp49jh
	LmZtGhcD/q+zzTvu+ePlWkEKPW+mvxw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TjWkndFH;
	spf=pass (imf12.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769815783; a=rsa-sha256;
	cv=none;
	b=ygr/qT2A9i6tp3iPqsUkuPXmKf7P2VXyb6arwM9kIz7RRbF4eObBpE+TEL6qITYnNyOuPl
	aEtP/sjBrCuDHqVS1Zz0TaY+bbwLstTjOF/zapdo8EhTUXm+eRQWpuFEQ5Ju9rc4fXba/e
	BG9FO54jFLCYsALkdD8o0zwptiEuxKw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769815780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QysXvGg4/WNW7ja6nSUtrR5V1p3ZPUnXLANtyVmNAWk=;
	b=TjWkndFHiWZPZypvlOjbUssQQgegJB0Nfm3nOT80hMMy13dBfusfFGYnpRGONiSv1yN0lD
	SOewWKlHjvaWx49VelxWNXVO0qyWnB64CoFNizdUo2Hn6h8EvksuLB79egcpIPIddpryBk
	TDn/BX27H7dQGZR92+4SXjhPN1cdBEI=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>,  Alexei Starovoitov <ast@kernel.org>,
  Matt Bobrowski <mattbobrowski@google.com>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  JP Kobryn <inwardvessel@gmail.com>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,  Suren Baghdasaryan
 <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 07/17] mm: introduce BPF OOM struct ops
In-Reply-To: <9483528f-83dd-4a30-9489-cf0fac4de5f7@linux.dev> (Martin KaFai
	Lau's message of "Thu, 29 Jan 2026 13:00:11 -0800")
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
	<20260127024421.494929-8-roman.gushchin@linux.dev>
	<9483528f-83dd-4a30-9489-cf0fac4de5f7@linux.dev>
Date: Fri, 30 Jan 2026 15:29:31 -0800
Message-ID: <87qzr6znl0.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6549F4000B
X-Stat-Signature: fjguod5kdgutrqw3qsnw56bgmq5mu3sy
X-Rspam-User: 
X-HE-Tag: 1769815783-342351
X-HE-Meta: U2FsdGVkX1+51rC1mcBeCq57JhvVrxhsQ0laqufNmYIVDGGIhgr1WnFX5AU6dJEJ2+f0RuOa9cm0a1L5LM9MGB2AMuAxeBbZAE7dJUwmNJbaNg2vcMdTbwZmqqs5NkjwcPmdvGM+2JCQyAnexmvIYy0hE4+81XmVdwfoFzVvhxJtLxxE/F5SGLX6Ad2Ep2eo2pbMuErOfOk+mfSYSdJN6GtDU69/uB7sACif8FxwEhOL1G8boZPKoip2eQOZKVQ2ZdS5Sn7RPEGfz1+44EuLHVjqSbxBx/Ziti1bLFOVwV1qup0cakSJjLJ+VB3Nmkw4iVWyt5hreqWytSZcY2alquazuff0hbmFaECfJZSawE9jBrZilAY0ZrOVoIcFSryeto7UhXVhzFiDz5VfZS8S7/fAQinb8Ihuq2nOxRDW4RnwfCv5fuTC8cR0cRoYqdXltrTKP+Ju07IINKJXx4c7N5MCCjIbtP+6ayYBw7y8hI1GFHt5QJX9aB3Zpnp4AJFA2DX1EKw7hBI6dfy4p2zg+wz1wx6a4HBpqrgThZ5fF0Xa9jOX/BPitEEH1i6nzUr3iwh+SigSjiNmiAGZcuc8zXsB2w9Q/T//HU023HpiZrWD3hO3mf/466U1hRtNeOtwj+F0rci7wr218bRB3SGhvpR4rBHCboEOe4By1ZDxWpZUF97uTrVZMK++wVekCWws/fXfgAVzUkDjdzaxvJ5NS09UeIBiH+lSYzDbcSX6CYik2CTYNIZsQQnbJeT+sTZLTAy+l7b5yDitHOYq5ypa9YXrGhKEzog0meA29mausOH9ACs/VvecUhfaduf1R+6/vXocLiyvdM+h5gJyt/6WSHj9ZKRweZUfAuU7wHa5R8xMaBtWdOTW0sdhjiwiCmdd7Ylcl0USIdr2QEqPuMtru7uDaYmBr5YKFIcr42DKLj1LifEj/OBjSZ112TK5WhNrSNw9nysu7X1cvFle1M8
 QQBoUFzz
 vSEedohkIv65TNd0TNZ+W2aDmLqmIh1gH/PAzJVKuqFayMokw+ClegCtd++7QuNuntGhdABmweLU4REVrsrw79/r4KRI8uBWVZ6GiIKEt2unmTCkj1lOAjk9KYcaz3q9rg40Z8Nj+m2Mme4fTaPi7z2rfQiczDo79JrmN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Martin KaFai Lau <martin.lau@linux.dev> writes:

> On 1/26/26 6:44 PM, Roman Gushchin wrote:
>> +bool bpf_handle_oom(struct oom_control *oc)
>> +{
>> +	struct bpf_struct_ops_link *st_link;
>> +	struct bpf_oom_ops *bpf_oom_ops;
>> +	struct mem_cgroup *memcg;
>> +	struct bpf_map *map;
>> +	int ret = 0;
>> +
>> +	/*
>> +	 * System-wide OOMs are handled by the struct ops attached
>> +	 * to the root memory cgroup
>> +	 */
>> +	memcg = oc->memcg ? oc->memcg : root_mem_cgroup;
>> +
>> +	rcu_read_lock_trace();
>> +
>> +	/* Find the nearest bpf_oom_ops traversing the cgroup tree upwards */
>> +	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
>> +		st_link = rcu_dereference_check(memcg->css.cgroup->bpf.bpf_oom_link,
>> +						rcu_read_lock_trace_held());
>> +		if (!st_link)
>> +			continue;
>> +
>> +		map = rcu_dereference_check((st_link->map),
>> +					    rcu_read_lock_trace_held());
>> +		if (!map)
>> +			continue;
>> +
>> +		/* Call BPF OOM handler */
>> +		bpf_oom_ops = bpf_struct_ops_data(map);
>> +		ret = bpf_ops_handle_oom(bpf_oom_ops, st_link, oc);
>> +		if (ret && oc->bpf_memory_freed)
>> +			break;
>> +		ret = 0;
>> +	}
>> +
>> +	rcu_read_unlock_trace();
>> +
>> +	return ret && oc->bpf_memory_freed;
>> +}
>> +
>
> [ ... ]
>
>> +static int bpf_oom_ops_reg(void *kdata, struct bpf_link *link)
>> +{
>> +	struct bpf_struct_ops_link *st_link = (struct bpf_struct_ops_link *)link;
>> +	struct cgroup *cgrp;
>> +
>> +	/* The link is not yet fully initialized, but cgroup should be set */
>> +	if (!link)
>> +		return -EOPNOTSUPP;
>> +
>> +	cgrp = st_link->cgroup;
>> +	if (!cgrp)
>> +		return -EINVAL;
>> +
>> +	if (cmpxchg(&cgrp->bpf.bpf_oom_link, NULL, st_link))
>> +		return -EEXIST;
> iiuc, this will allow only one oom_ops to be attached to a
> cgroup. Considering oom_ops is the only user of the
> cgrp->bpf.struct_ops_links (added in patch 2), the list should have
> only one element for now.
>
> Copy some context from the patch 2 commit log.

Hi Martin!

Sorry, I'm not quite sure what do you mean, can you please elaborate
more?

We decided (in conversations at LPC) that 1 bpf oom policy for
memcg is good for now (with a potential to extend in the future, if
there will be use cases). But it seems like there is a lot of interest
to attach struct ops'es to cgroups (there are already a couple of
patchsets posted based on my earlier v2 patches), so I tried to make the
bpf link mechanics suitable for multiple use cases from scratch.

Did I answer your question?

>
>> This change doesn't answer the question how bpf programs belonging
>> to these struct ops'es will be executed. It will be done individually
>> for every bpf struct ops which supports this.
>>
>> Please, note that unlike "normal" bpf programs, struct ops'es
>> are not propagated to cgroup sub-trees.
>
> There are NONE, BPF_F_ALLOW_OVERRIDE, and BPF_F_ALLOW_MULTI, which one
> may be closer to the bpf_handle_oom() semantic. If it needs to change
> the ordering (or allow multi) in the future, does it need a new flag
> or the existing BPF_F_xxx flags can be used.

I hope that existing flags can be used, but also I'm not sure we ever
would need multiple oom handlers per cgroup. Do you have any specific
concerns here?

Thanks!

