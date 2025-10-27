Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8093CCCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:48:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF682800C5; Mon, 27 Oct 2025 19:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE5D8009B; Mon, 27 Oct 2025 19:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD53800C5; Mon, 27 Oct 2025 19:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BCBD58009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:48:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70D37B73DA
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:48:15 +0000 (UTC)
X-FDA: 84045535350.20.4DE179B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C6E95180009
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:48:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Us920hjK;
	spf=pass (imf24.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761608894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3zmrhiFiQ7qjWwnFusxKl6//2UBddoXjd5h5h5lck3Q=;
	b=tU6DrA1i8+mJvHe4m60h3vqYvy+L61ybz9qlwGhhgQ2exNNkl9oSAJKURSQrDDgyQ/OCVX
	grIk+e7T0AHfYiWuGhF9OSj7xLmh7ej+smpbAmldaUrWev+nPx0gr3W+r62ml1olZl6TvH
	ylgnoiEAhzFFykq5ctY1yv/VoXkhTGU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Us920hjK;
	spf=pass (imf24.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761608894; a=rsa-sha256;
	cv=none;
	b=1SQuAb08aRQbxsdW9GJVu838Q4A95rEg5AnXYMtXuNL8RHanAB6fdatYWQEe7lSTTyPkdX
	wD/641w6kM8gT1TNZ+aRLj7P29l9h2ASoTCxYFpSk5tHKH0PXk6mS6jzIUjNpvrqZOhfRJ
	tu0zyCp1OARc65IJeogjUb1IJrASVcA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4F8D445F3;
	Mon, 27 Oct 2025 23:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7699C4CEFB;
	Mon, 27 Oct 2025 23:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761608892;
	bh=d+Afd6qG0+omy8Xr9NEfKvzByVvSsVWsm6DaVrUnLfQ=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=Us920hjKG70fHpLMNB7lfpxLhKSXliu5ThF5h0imbY7NeLbqGUHc4lJYIOuldiwYv
	 Lew7/A5ljSRJN840oMsKIEKiJRt+LFWXTOnKEzKfc74pj6HCo+OYso4pmh4jXI9Fcl
	 G+eDHDi1HNYzKLf+nXO8CCoY+hw8k+AeGlmb6ORzqEUwtMxW8IOv3uIds/XxDk1i76
	 QMMGvVjD3zliwXY18GBCXaonuC1so0l56kT2D/2QAm9dGpxqSwPUUSTggPBR5fd8YU
	 gw5HmmZJPKQ+HIcUQoPa3m0+MwcFwm6b8MBNThX7jCOvLOeeMNXm7VqKx41p/ER0Cc
	 KWrPX/d/OjzpQ==
Content-Type: multipart/mixed; boundary="===============6095985643008399195=="
MIME-Version: 1.0
Message-Id: <5e97ecea6574f100385cb21507076c6efb2667eb9def24f322306be038e98165@mail.kernel.org>
In-Reply-To: <20251027232206.473085-6-roman.gushchin@linux.dev>
References: <20251027232206.473085-6-roman.gushchin@linux.dev>
Subject: Re: [PATCH v2 16/23] libbpf: introduce bpf_map__attach_struct_ops_opts()
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,ast@kernel.org,surenb@google.com,mhocko@kernel.org,shakeel.butt@linux.dev,hannes@cmpxchg.org,andrii@kernel.org,inwardvessel@gmail.com,linux-mm@kvack.org,cgroups@vger.kernel.org,bpf@vger.kernel.org,martin.lau@kernel.org,song@kernel.org,memxor@gmail.com,tj@kernel.org,roman.gushchin@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 27 Oct 2025 23:48:10 +0000 (UTC)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C6E95180009
X-Stat-Signature: pfy8q44ne9ex3kjrdt9idew1iki6jq35
X-Rspam-User: 
X-HE-Tag: 1761608893-499256
X-HE-Meta: U2FsdGVkX1/Cs6bG/pMKfMi49NK6XnatQS65E2GYCNeUakgtxFKnXDgkXjECQV1Fm2fBEyVUHPIdvsO+y5yYyiTINY1ZgGrjSI7b0GmJ91/obucD5KaHutcyit4VqwdY3UR70j4BkQP9mWjPCckd+qhJm5PLdmJKHN6hOFTivl43RgiXajMErV4+qHh/32m31xcry1y19+x7XNGQkQOVmCnD5bQ3FO0952ZnzMjZkKe1mmNhXCSRXztfDnnCbr3l7AbCwctCLUbOv8HLhyXQLegMwT9gaP0v2SlKGWAIr8jZJWHa4CjqPDndZFsCn298OVoWi97lum52d/u0uTf7uM3ykBMRmoUW3mukPcXYtsMgx8xitHAhVEeI58ARpaMP9VOWJK6LnTyx8Upt6jdR43UUUpTROPJV9uzc58PmbjaigzAx78vWt8ylR3bA5HRra7ojZwotX3IvYavZpowZK+5ytYP6lKf1IK6Jcz2rJkTUwowCCga2i5g4ngrMCJ33TbGiH9RLT9/AxAJpUusu5Rr9+nTpmNZrjVr4SdZlFDnJ8qP34AY3I9inrhd03V5nMAEUz1wDm8GcsPNcrs5CncmNU9eRt12mstWmnsALi1+NK36yaLSCNBFVy3htm3bKfE+hs0XK1sLM2lP3F83BRXPUFA1FCBMbpyW47u9lnNI7V3Ax1W9gdFRVlxZSpr5Uc0YriLvt0Ys3yJAuh932bGvAoP9x8+cr1iRDJHl2G5wiITHtgHLHg18okSHCkQAKazAgSkMGPSFJtJkGmVrjwL1LcW2wpiBUP6NbUU8/7JJI3qPOZzh3LOioLHxm/YsUOD0drNPl+gHIyIYdlywtGOdlqN47McZaH7aohsc07BQj4UlcZsPwNVmGryp259PR224+jYiFhnh6yYpGmNtejW4SIQliUrv1elqSeBfxPJSgZXXtRabTb0c+vuCH5aAUX4voD+mkva/2UO0OG6v
 DUaQU5G0
 2WEPKl8UlCmvWPE5tsj/lCFN2yy6H5tTqRk3Y5o9hViwW9zhpww+yYZon4RjBrsDEj+ddOrya2QPcUnS1D9c4HiUbuS0z34oP3ITNMbO0+zJibWLJaMihElERB3orFP9rowfpFxxH7ZHvd+p0vAxoRBtnMuLQXT3InQPVQpDCOg3PbtZBpRqPXhwLNoZ8LcM+BBnuiI4KbFS1htYYTa+zbW3PIUo0uClJ2VrucusYTcT2h1BZ1/wyvNadTAS40UmX221TI+hUto8/jqdkx4UGmx3ptgFaLGpvvGBC+cPmqR1ZyvO9D4O45bvAV8XMQ3ypD3+7d2Ec4NVlfo1UisJkf6dPGC6HGv6kVt2mNExA822vXOMcX+jU8L2TKjGA2htPRBuuq2OdDwUcXLALyj3Vwi6eBfVjH25J8+GJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============6095985643008399195==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


```
commit b58d54ed56054e3a550e02c324982feb20a2671e
Author: Roman Gushchin <roman.gushchin@linux.dev>

libbpf: introduce bpf_map__attach_struct_ops_opts()

This commit introduces a new API function that extends the existing
bpf_map__attach_struct_ops() to accept additional options, specifically
allowing attachment of struct_ops maps to cgroups via a relative_fd.

> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index b90574f39..be56a5dee 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -13196,12 +13196,19 @@ static int bpf_link__detach_struct_ops(struct bpf_link *link)
>  	return close(link->fd);
>  }
>
> -struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
> +struct bpf_link *bpf_map__attach_struct_ops_opts(const struct bpf_map *map,
> +						 const struct bpf_struct_ops_opts *opts)
>  {
> +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, link_opts);
>  	struct bpf_link_struct_ops *link;
>  	__u32 zero = 0;
>  	int err, fd;
>
> +	if (!OPTS_VALID(opts, bpf_struct_ops_opts)) {
> +		pr_warn("map '%s': invalid opts\n", map->name);
> +		return libbpf_err_ptr(-EINVAL);
> +	}
> +
>  	if (!bpf_map__is_struct_ops(map)) {
>  		pr_warn("map '%s': can't attach non-struct_ops map\n", map->name);
>  		return libbpf_err_ptr(-EINVAL);

[ ... ]

>  	link = calloc(1, sizeof(*link));
>  	if (!link)
>  		return libbpf_err_ptr(-EINVAL);

Should this return -ENOMEM instead of -EINVAL? All other calloc failures
in libbpf.c return -ENOMEM (see lines 11006, 11802, 12288, 12746, 12829,
12891, 13089, 13129 in the same file).

[ ... ]

> -	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, NULL);
> +	link_opts.cgroup.relative_fd = OPTS_GET(opts, relative_fd, 0);
> +
> +	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, &link_opts);

Is the expected_revision field being propagated correctly? The new
bpf_struct_ops_opts structure includes an expected_revision field
(see libbpf.h), and bpf_link_create() with BPF_STRUCT_OPS reads
opts->cgroup.expected_revision (see bpf.c line 889), but this code only
sets relative_fd in link_opts. Should it also include:

    link_opts.cgroup.expected_revision = OPTS_GET(opts, expected_revision, 0);

> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 5118d0a90..dc8489871 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -922,6 +922,20 @@ bpf_program__attach_cgroup_opts(const struct bpf_program *prog, int cgroup_fd,
>  struct bpf_map;
>
>  LIBBPF_API struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map);
> +
> +struct bpf_struct_ops_opts {
> +	/* size of this struct, for forward/backward compatibility */
> +	size_t sz;
> +	__u32 flags;
> +	__u32 relative_fd;
> +	__u64 expected_revision;
> +	size_t :0;
> +};
> +#define bpf_struct_ops_opts__last_field expected_revision
> +
> +LIBBPF_API struct bpf_link *
> +bpf_map__attach_struct_ops_opts(const struct bpf_map *map,
> +				const struct bpf_struct_ops_opts *opts);

[ ... ]


```

---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

In-Reply-To-Subject: `libbpf: introduce bpf_map__attach_struct_ops_opts()`
CI run summary: https://github.com/kernel-patches/bpf/actions/runs/18859027430

--===============6095985643008399195==--

