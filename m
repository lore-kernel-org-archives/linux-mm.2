Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3792DCD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 03:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 378716B0088; Mon, 25 May 2026 23:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328C96B008A; Mon, 25 May 2026 23:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6C06B008C; Mon, 25 May 2026 23:06:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A73D6B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:06:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D23371C1041
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:06:22 +0000 (UTC)
X-FDA: 84808082604.26.1AA9E9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4647C10000F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:06:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=UBVtV9mq;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779764781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6yTA3niwkhttvCkwwpXJUgDLki0X86ZyRPiud/VTWNI=;
	b=3OLpFOLsTayhuOLxJj6qMou2E3ARzPRmIs+uUTth9HUOUOWehkYfUUD5AKiemg3eA8/+ix
	vGBo+Q10LJm/tfacjp9I4FxWoqRJI2SIVbOEmUk/EgwHi7kFt4ms9xC4aCcIXrHeCfiKpb
	as629NPgVrFfwn98currXpZIyOr81EY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=UBVtV9mq;
	spf=pass (imf14.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779764781; a=rsa-sha256;
	cv=none;
	b=5v+/K92iwxnH5mmlCSEGZ/3AUAxCpOBJRxttiIcE2v2AGVBk8y9692+AWHDcMRIob0yKb8
	xkgy2t/JBYxxFX/lWkRwiNltalHpDAb+tQ1/j/S7cR0STl26rNJEa+JYNRWT2Nz4MjJJfI
	31cv0hVZoUYzTE04w2h+wvL12WVfjqo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A8728600B0;
	Tue, 26 May 2026 03:06:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839C51F00A3A;
	Tue, 26 May 2026 03:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779764780;
	bh=6yTA3niwkhttvCkwwpXJUgDLki0X86ZyRPiud/VTWNI=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=UBVtV9mqmKcdwQzwwqF60MD2gRVk6VsAOk+ODNyT1Sst9Pl9FMmb9pqCzet6QsHv3
	 YVTQtJd6/2BIVPeFPTxag3XABXwuNXm4C6BEXWWmDhVc84UJqMi+zQF0RjsREuhabc
	 DP2z1c6bOiGGw/vNo2hZWgJ3L3Dwx6BXyDqBeh7ysTtoGt0gb+naI/5816NE0w1DDz
	 fSgH9tDiPzryEtkPk7Xw9el2r+BpIAr0ZPjeQBw8U4R9ftQsFx9zo1y6lHi451jajZ
	 2mTKHXhwXQ11+xhINqJ8CmNYXLWcL78T9GrQgY6G9Z7ebElVAw6lBjNYvt2pmY4aL+
	 RnmkXY3JdCY1A==
Content-Type: multipart/mixed; boundary="===============8971296676859346984=="
MIME-Version: 1.0
Message-Id: <89f1d1be0767b0146b61fdc7faad181e447ca7d669f467fb99d8c5a174430101@mail.kernel.org>
In-Reply-To: <20bdaa33cc19364f5f10208c79ef94fe43bd5ac1.1779760876.git.zhuhui@kylinos.cn>
References: <20bdaa33cc19364f5f10208c79ef94fe43bd5ac1.1779760876.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH bpf-next v7 04/11] libbpf: introduce bpf_map__attach_struct_ops_opts()
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev, ast@kernel.org, daniel@iogearbox.net,
	john.fastabend@gmail.com, andrii@kernel.org, martin.lau@linux.dev,
	eddyz87@gmail.com, memxor@gmail.com, song@kernel.org,
	yonghong.song@linux.dev, jolsa@kernel.org, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, inwardvessel@gmail.com,
	akpm@linux-foundation.org, shuah@kernel.org, davem@davemloft.net,
	kuba@kernel.org, hawk@kernel.org, sdf@fomichev.me,
	kpsingh@kernel.org, chen.dylane@linux.dev, yatsenko@meta.com,
	leon.hwang@linux.dev, a.s.protopopov@gmail.com, ameryhung@gmail.com,
	tklauser@distanz.ch, eyal.birger@gmail.com, rongtao@cestc.cn,
	haoluo@google.com, peterz@infradead.org, ojeda@kernel.org,
	nathan@kernel.org, kees@kernel.org, tj@kernel.org,
	jeffxu@chromium.org, mkoutny@suse.com, kernel@jfarr.cc,
	brauner@kernel.org, rdunlap@infradead.org, brgerst@gmail.com,
	masahiroy@kernel.org, willemb@google.com, kerneljasonxing@gmail.com,
	paul.chaignon@gmail.com, chenridong@huaweicloud.com,
	lance.yang@linux.dev, jiayu@kvack.org, an.chen@linux.dev,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: geliang@kernel.org,baohua@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 26 May 2026 03:06:19 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4647C10000F
X-Stat-Signature: xp9574uhpr7b9pki5yynnh9711ah8aoj
X-HE-Tag: 1779764781-326583
X-HE-Meta: U2FsdGVkX19dCIgV8PhcvzRYEc19m840Jq+06I9q1xoY7bSNsx2McX6qf7pWL0fNA2DtjTCK9giGycy4SNXWDZxr2Nsxx/stxA1mlXURaUFtAoFxst6toTAf5m0sE5dUCeCTzWfUMUHEUFd4iFe3L+Fvzqb4zdVlvJJpXdxPJRhFJ87SV3FVqggqKZOET7ztoPbmhYluR8VKOzRQTxD0rUh0gzNu3vczMV2pdi0w1s/RbsLPrP0Um48bz2OTNcAqcuftFNH7XwHQ8cNU8NGJ6s0YSUouoCsqWHWLRe01G00xacgocQ4by/bfSHb5T41u4vpRo0K/olF/7swD8e4reJ17LZqz8acUwzayN09b3zG07VxYIJkqTmIVgu4iUjLfHGrfc7qVdD5juxI9qZtpbvfvT6bcaKU7t1Bm9Xlr6WwvWPnEvjqH03GuHkOfoLKyfgh8QuRWlrsJ1UIxI1VRsWFqpxeHqd/srjjs8kX0ULWtG5jO7d8ufEwMf1rn7QKztXuGOg1GTWOqLLU+eZN6U5cdsYPpPoSbIDLMcoqTlZEHDDCsMvFQgwkDmu5MFWdZlPojeOrHWdVn8oGgJcVskPER6ThoCQ3DO5IXqPjTrkmTdNn9mCzdOOpVyVhANHdh76D3fbCKB4qIgU1qd7D9jP8YLC+fSLe3WLwe+4pO9YNjst9uNDKewuDoBD3g8JZHMZ0YzD1fFity6PT9neBkkj1mBSggmRx+fo9pIMizbkTuPFHixogYwcRvJJIHrEkEF3Y5w03gBY0kpMYbbOqFogPRQ2Bd27tH5a8nsnqujrS+OSDRYZlAxqgF5q+2hWc+ldzJbeKOfqbcgjls0fYAmNUH+UlXWHpk3i+m7+oi9OWFRyzEg8s6I6kUhKWpH4rjRVCCk6/rZzvPwto6pFfAhQqxKTq2xX0q8D7xVRuOvAHbL5XX321sq0t0LOwRB9kLCk8JuPEW8+piFc5B1gO
 mTcCZZxs
 +1fttlKpvdbXfiduRszAbs6GrERTSAM2xGIRU3Qno0cICDqcxEvAg9H3fk9n/aXuOh9CnElbozgtIQmIkXAMvkyRFYme8UsZWwVnrYtiFjgeRyMgFGSoNXTvqDd65uSB8ChT4HrYRylfZDSb8PyfNdzO8x3+OwHOPSwqj6uUC2V018zJBuYtyqWlz6cN/7U389tBruBu79HpDdTiIAGc6M99KjSDIp+1yBme1Duj279DeyTV/Jkb+9qKH9jMfZI4GXT/SWmH6K0qXSBXhCQmLEZeZc6doYwfz6Lu6BDvksAOh5WSulBSO/Bz9izH8dnXHzPSRCjtWNOH5fPUsRV1RCo/kCxo9r2U6ucqmeZG8TWCfLH9a577mp8v+XILhGJbbgwyktEYpyq6ru3WVBzlrzOop4pdux1imc7Ols2drzKiEWde8pXyGNx2O1zvo14r2kWqVRnQmHjxP4tFk4IlOA86CclUUDOPhuh9wCkHNVKX/saxp4j/DJ1F0oB/7jnpIgHKoa/h16M0TJeq5K55zmBOUWLeeQvx1SCbL1PwQEyvUlLRmFBF0LtBdN0cInewgJuV36Dw5OwiMzmEd2A8AMl8LTLrIJOlYbwD3/brpLIw7fLvajMEwC1WHMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============8971296676859346984==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 1e8688975d16..a1b54da1ded2 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c

[ ... ]

> @@ -13683,11 +13683,18 @@ static int bpf_link__detach_struct_ops(struct bpf_link *link)
>  	return close(link->fd);
>  }
>
> -struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
> +struct bpf_link *bpf_map__attach_struct_ops_opts(const struct bpf_map *map,
> +						 const struct bpf_struct_ops_opts *opts)
>  {
> +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, link_opts);
>  	struct bpf_link_struct_ops *link;
> +	int err, fd, target_fd;
>  	__u32 zero = 0;
> -	int err, fd;
> +
> +	if (!OPTS_VALID(opts, bpf_struct_ops_opts)) {
> +		pr_warn("map '%s': invalid opts\n", map->name);
> +		return libbpf_err_ptr(-EINVAL);
> +	}
>
>  	if (!bpf_map__is_struct_ops(map)) {
>  		pr_warn("map '%s': can't attach non-struct_ops map\n", map->name);

[ ... ]

> @@ -13724,7 +13731,9 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
>  		return &link->link;
>  	}
>
> -	fd = bpf_link_create(map->fd, 0, BPF_STRUCT_OPS, NULL);
> +	link_opts.flags = OPTS_GET(opts, flags, 0);
> +	target_fd = OPTS_GET(opts, target_fd, 0);
> +	fd = bpf_link_create(map->fd, target_fd, BPF_STRUCT_OPS, &link_opts);

The expected_revision field declared in struct bpf_struct_ops_opts is never
read or used. The code only reads flags and target_fd from opts, which could
cause silent data loss if users set expected_revision expecting it to be
honored.

Looking at similar opts structures (bpf_cgroup_opts, bpf_tcx_opts,
bpf_netkit_opts), they all pass expected_revision to bpf_link_create_opts.
Should expected_revision be propagated here as well?

This was raised by bot+bpf-ci@kernel.org in v3:
https://lore.kernel.org/bpf/3af5210f45be4a508e584263a5517781ca762d28d4f6b831b987795662715e61@mail.kernel.org/

>  	if (fd < 0) {
>  		free(link);
>  		return libbpf_err_ptr(fd);

[ ... ]

> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index bba4e8464396..18af178547ad 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -945,6 +945,20 @@ bpf_program__attach_cgroup_opts(const struct bpf_program *prog, int cgroup_fd,
>  struct bpf_map;
>
>  LIBBPF_API struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map);
> +
> +struct bpf_struct_ops_opts {
> +	/* size of this struct, for forward/backward compatibility */
> +	size_t sz;
> +	__u32 flags;
> +	__u32 target_fd;
> +	__u64 expected_revision;
> +	size_t :0;
> +};
> +#define bpf_struct_ops_opts__last_field expected_revision
> +
> +LIBBPF_API struct bpf_link *
> +bpf_map__attach_struct_ops_opts(const struct bpf_map *map,
> +				const struct bpf_struct_ops_opts *opts);
>  LIBBPF_API int bpf_link__update_map(struct bpf_link *link, const struct bpf_map *map);
>
>  struct bpf_iter_attach_opts {

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26429228214
--===============8971296676859346984==--

