Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 392E1CCF9EB
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 00:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99D4F8E01A1; Wed, 29 Oct 2025 20:21:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974EB8E0106; Wed, 29 Oct 2025 20:21:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1568E01A1; Wed, 29 Oct 2025 20:21:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1348E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 20:21:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3140B4A209
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:21:18 +0000 (UTC)
X-FDA: 84052876236.22.5B72C8A
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 141A440005
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 00:21:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ou6lXpME;
	spf=pass (imf27.hostedemail.com: domain of martin.lau@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761783676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=83mMGh350mPzHP98dPD6s3KeImQJSZE2GZvMHCWiYug=;
	b=28nn3gVyvfJ6GJlHmVRnlQ8jbh4VTSmdIVx6n/0rUHpbfDvvFH7tnjubNPf3x30Z1QiY+K
	F0bUphY6Go/AFTCMI30MvFrsA5WpAg8CKJuNOVAbSS37wd6SNxc6yLb0Pi83k5sukecxEk
	WMb4FKeaKn0YMTzBFjBP2mhsoNokEks=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ou6lXpME;
	spf=pass (imf27.hostedemail.com: domain of martin.lau@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761783676; a=rsa-sha256;
	cv=none;
	b=NPV3IAth5UvFO9JtMgrDmcLuRktPt81cJN5TSP16m7LpVCriCiA/L5yIEwnPPxxde4IpAX
	kM+KqpxM6p4QhicJc9lNK78IPopipYFBQXf3qNq/euP8nxefZxxhWuWLi78GMrM7X6E+/H
	6n+A7snhH4Fu5yZh3zMSuH5QE4FlKPQ=
Message-ID: <e8110233-0028-48e3-8850-fcf1ba528ca6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761783673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=83mMGh350mPzHP98dPD6s3KeImQJSZE2GZvMHCWiYug=;
	b=Ou6lXpMEg6AqmuZ/ORasDA2Z1gZfMXc150P3f6XPtSgAvMkorNWutkS0E81mOft92TJwJh
	/NS+uKNqJfSaDkGHSPBzE22BT7+2t9s3Xaig7fF7dcWqRm3evUFCCu9Gk1sDvVgTt+3WpF
	+KoSrppdvxU88J3q0sanTF0tbwaKSmk=
Date: Wed, 29 Oct 2025 17:20:59 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2 06/23] mm: introduce BPF struct ops for OOM handling
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Andrii Nakryiko <andrii@kernel.org>, JP Kobryn <inwardvessel@gmail.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org,
 Martin KaFai Lau <martin.lau@kernel.org>, Song Liu <song@kernel.org>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Tejun Heo <tj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-7-roman.gushchin@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20251027231727.472628-7-roman.gushchin@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 141A440005
X-Stat-Signature: 3cn4bzymhseuc8x11y4u41rxp5c6pws3
X-Rspam-User: 
X-HE-Tag: 1761783675-388918
X-HE-Meta: U2FsdGVkX1/WeJxp7Cawc670XdhID/lPrUPaqbsG9yXYSfF/KETfn0JCAZouoFHt2Z5Anu66H8Yrkmsda9PBqjjvaeOXBBgmpHIUU+EbOnG2OgUl9DlqzypJryKrFG5vu7RSyHwC43HiJ5wltaU8FMAE+QQOv8dUtZJ4FazgYgHIr1SdK6CzBDqLhn2hxw9GOHgC04bj4QngL4GizCLaKbgJoyMcRwPwfuH6D3WD++vOTWS+z/GWh50RezxgQ4Ci7W3As9vp/5dPgq6xC0mtRqpZ9ZCoM0Jr4r5qfybkGb0Q8DrQawvJJzTCtzhRxrBVb0uqI/WIhargSCecPYAzY//Xzo3Q2FIZAwx4DmmredFsEXxiJ4j5iJwoDcq2xOYF0+i7TSk/SMls8/Wqko9wAfRjIVcMItj3qn9Exo8/4j+EKuVMRZv9t2/G2wTeBCzSzyIWVT6aUKd9ay+EBswRnH9YhlozqetJ50ISWLpKPinoITfcY2JiNsGbE9dffaQDlRhQojn8ttY4Mo0sfUaBezEpyc7T6vPpgUYBhPTUfsDtW/Qh44/Re/ts41/E05odqB+umUP2pH7yeQj59cnpvFPXErZfRAXkT7m7ZeZI4j106ZIGw8IrX/ILrGo4sF4SwyF/8xA8JnyWJo3OTjvzJVJNyGgPl1RGpNty1ccgQ2c0ARWAK9c8T5XUSUCUaKL24ccTMwjKrM8UvTwHPC1A7lrRN+tBy0LZmNpumNrPpeCaw/V9xd9D7vocLCAG3qyEMBDF5c4EQM4Y8Kl7BfmioIWBsYylEuDYI2Ea2em7NLyokOhquMYJaFeZI7szOkP6T7oQB7nlT9hXj587qm2htBu3b3TPuM7UNTts5W2xOMBSr3U71bJsUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/27/25 4:17 PM, Roman Gushchin wrote:
> diff --git a/include/linux/bpf_oom.h b/include/linux/bpf_oom.h
> new file mode 100644
> index 000000000000..18c32a5a068b
> --- /dev/null
> +++ b/include/linux/bpf_oom.h
> @@ -0,0 +1,74 @@
> +/* SPDX-License-Identifier: GPL-2.0+ */
> +
> +#ifndef __BPF_OOM_H
> +#define __BPF_OOM_H
> +
> +struct oom_control;
> +
> +#define BPF_OOM_NAME_MAX_LEN 64
> +
> +struct bpf_oom_ctx {
> +	/*
> +	 * If bpf_oom_ops is attached to a cgroup, id of this cgroup.
> +	 * 0 otherwise.
> +	 */
> +	u64 cgroup_id;
> +};

A function argument can be added to the ops (e.g. handle_out_of_memory) 
in the future. afaict, I don't see it will disrupt the existing bpf prog 
as long as it does not change the ordering of the existing arguments.

If it goes down the 'struct bpf_oom_ctx" abstraction path, all future 
new members of the 'struct bpf_oom_ctx' will need to be initialized even 
they may not be useful for most of the existing ops.

For networking use case, I am quite sure the wrapping is unnecessary. I 
will leave it as fruit of thoughts here for this use case.

> +static int bpf_oom_ops_reg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_struct_ops_link *ops_link = container_of(link, struct bpf_struct_ops_link, link);

link could be NULL here. "return -EOPNOTSUPP" for the legacy kdata reg 
that does not use the link api.

In the future, we should enforce link must be used in the 
bpf_struct_ops.c except for a few of the existing struct_ops kernel users.

> +	struct bpf_oom_ops **bpf_oom_ops_ptr = NULL;
> +	struct bpf_oom_ops *bpf_oom_ops = kdata;
> +	struct mem_cgroup *memcg = NULL;
> +	int err = 0;
> +
> +	if (IS_ENABLED(CONFIG_MEMCG) && ops_link->cgroup_id) {
> +		/* Attach to a memory cgroup? */
> +		memcg = mem_cgroup_get_from_ino(ops_link->cgroup_id);
> +		if (IS_ERR_OR_NULL(memcg))
> +			return PTR_ERR(memcg);
> +		bpf_oom_ops_ptr = bpf_oom_memcg_ops_ptr(memcg);
> +	} else {
> +		/* System-wide OOM handler */
> +		bpf_oom_ops_ptr = &system_bpf_oom;
> +	}
> +
> +	/* Another struct ops attached? */
> +	if (READ_ONCE(*bpf_oom_ops_ptr)) {
> +		err = -EBUSY;
> +		goto exit;
> +	}
> +
> +	/* Expose bpf_oom_ops structure */
> +	WRITE_ONCE(*bpf_oom_ops_ptr, bpf_oom_ops);
> +exit:
> +	mem_cgroup_put(memcg);
> +	return err;
> +}
> +
> +static void bpf_oom_ops_unreg(void *kdata, struct bpf_link *link)
> +{
> +	struct bpf_struct_ops_link *ops_link = container_of(link, struct bpf_struct_ops_link, link);
> +	struct bpf_oom_ops **bpf_oom_ops_ptr = NULL;
> +	struct bpf_oom_ops *bpf_oom_ops = kdata;
> +	struct mem_cgroup *memcg = NULL;
> +
> +	if (IS_ENABLED(CONFIG_MEMCG) && ops_link->cgroup_id) {
> +		/* Detach from a memory cgroup? */
> +		memcg = mem_cgroup_get_from_ino(ops_link->cgroup_id);
> +		if (IS_ERR_OR_NULL(memcg))
> +			goto exit;
> +		bpf_oom_ops_ptr = bpf_oom_memcg_ops_ptr(memcg);
> +	} else {
> +		/* System-wide OOM handler */
> +		bpf_oom_ops_ptr = &system_bpf_oom;
> +	}
> +
> +	/* Hide bpf_oom_ops from new callers */
> +	if (!WARN_ON(READ_ONCE(*bpf_oom_ops_ptr) != bpf_oom_ops))
> +		WRITE_ONCE(*bpf_oom_ops_ptr, NULL);
> +
> +	mem_cgroup_put(memcg);
> +
> +exit:
> +	/* Release bpf_oom_ops after a srcu grace period */
> +	synchronize_srcu(&bpf_oom_srcu);
> +}
> +
> +#ifdef CONFIG_MEMCG
> +void bpf_oom_memcg_offline(struct mem_cgroup *memcg)

Is it when the memcg/cgroup is going away? I think it should also call 
bpf_struct_ops_map_link_detach (through link->ops->detach [1]). It will 
notify the user space which may poll on the link fd. This will also call 
the bpf_oom_ops_unreg above.

[1] 
https://lore.kernel.org/all/20240530065946.979330-7-thinker.li@gmail.com/

> +{
> +	struct bpf_oom_ops *bpf_oom_ops;
> +	struct bpf_oom_ctx exec_ctx;
> +	u64 cgrp_id;
> +	int idx;
> +
> +	/* All bpf_oom_ops structures are protected using bpf_oom_srcu */
> +	idx = srcu_read_lock(&bpf_oom_srcu);
> +
> +	bpf_oom_ops = READ_ONCE(memcg->bpf_oom);
> +	WRITE_ONCE(memcg->bpf_oom, NULL);
> +
> +	if (bpf_oom_ops && bpf_oom_ops->handle_cgroup_offline) {
> +		cgrp_id = cgroup_id(memcg->css.cgroup);
> +		exec_ctx.cgroup_id = cgrp_id;
> +		bpf_oom_ops->handle_cgroup_offline(&exec_ctx, cgrp_id);
> +	}
> +
> +	srcu_read_unlock(&bpf_oom_srcu, idx);
> +}



