Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35575D25938
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 05:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11B1C6B0088; Tue, 27 Jan 2026 00:49:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2F76B0089; Tue, 27 Jan 2026 00:49:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2DFE6B008A; Tue, 27 Jan 2026 00:49:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE0FA6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:49:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AD6CFBCF43
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:49:57 +0000 (UTC)
X-FDA: 84376667634.29.CE27737
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id BE632A0008
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 05:49:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DSPH1Vsm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769492995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9HzgsJ827sC2LhFGy7sDRVcx3B1Tf/7PzhkQBFCLMF0=;
	b=KP3b4PY/vwPEntrHobv2Hcb0i7m9y6FGvOQuiuHMPTIn29J1rcBny90qd7JTehj0lxnAVC
	LMBOHdpYqiBp0XbP6u6WVV6YHqtxv3kPJZI793PWFytyi5spkazEGlIlSN7bykrtkhiWH/
	CQgU5BtY1LOT4s3cyEwmxOYWhC1grpg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769492995; a=rsa-sha256;
	cv=pass;
	b=mTUjI381G8BUoKo3LiKgfxDP/9MS+Jpo4rHGJWNSuxhoqorR5A32bvfO+zi2gJbsssoV4x
	84zHLIwiz+gLKQehMSjnlzNUgM6NsRhs7dd2F6E3zqDzDDV5VEbLpBbAKWDqandRJmk0rq
	u85RBx7eUKcQUlQc9VW4XkxFaTFGFZg=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DSPH1Vsm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-7947072d0f6so9989127b3.1
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:49:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769492995; cv=none;
        d=google.com; s=arc-20240605;
        b=NMhturPu18O6yuHFheHF2klkgZzU3O101GuudPQtDvnzl8TjvdV8Rbx0oJAqZQbOou
         L1Q8t3WMzDCbww8CdGVlal0d4phvDGSqywFuGN21W3sFjkqosDJUyAwVnl7BsvnyInea
         QFZgVomApsafXeCOIOUwgP5x6vjJC5n0zzJfybjp7kbAyvJlvcgjhd23KGdPSs8UexQR
         m8eSzIwi1rPQ9ic9sfDOjNKC+BzLbEPgkoQ7u4cYepE0MVeXrdWFIVW23MgPxbX5A/jq
         PaLWKrSGKD/Lj0zvdWFZsfanB39UXDbDGM7TSraOcw6aczgZdMftEYp32PZcQjj12U4y
         NQtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9HzgsJ827sC2LhFGy7sDRVcx3B1Tf/7PzhkQBFCLMF0=;
        fh=zTwlveP8z0vJ/CcFH0GzrT5GNvte03taYOnb6yT046E=;
        b=HN4030wNG+MuEJp+HBt4Ison9pRnQIbBXyBfGeoyWrFIsrK7rKZFa70WLeLxRp2NF1
         jkL2U4W3YWvrrmTd7WdHRVH+RhUnYUluqZFV5G6+j0MjWvJx70Y2cFnaicL3S+pcc5ob
         reXvoARSAErZm+Rat5yoHYbC38aOQ80wQVmMsNUKTMHb4ZamHYrskAs+3h17i3TB6dbg
         tVaWgMLcm1ReKCC/iwS8hmfHGZNl/BE0B6f/YK4818SwHKWLk0fUBFUenYubUMs+Gsop
         1XqJKTjzzLzJuwfDiIPwEzl4UemwQJYGjoI8TLervaZPcSHYkRjF9SzpIAJsW0zFReAW
         AmMw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769492995; x=1770097795; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9HzgsJ827sC2LhFGy7sDRVcx3B1Tf/7PzhkQBFCLMF0=;
        b=DSPH1VsmwPzUc5zsehp76ZmSeEAv8x5WknVch078RnpNT6TjwtEYZ+FzR+ROMS2YaT
         kPstbSKjNF9c03JxIIfJQrbwBN1Ro2+NfnjfBwYAi+dMZ+qKKZ9X4W1wnpwzfb9FjNRI
         3UnIDRRBk6Rth5lsGzq30j/NdzcOWBIBZbYXK47jpsr9NQNZE9/0RUAvq2Q3g37R1lyZ
         QFWES6hQlvXqf+/7Pg50dpmZpVTzubd9giZpZ3s7d+t2XsGqVISsG7FAGxI1IuvrqImH
         n6Hdz1lqIKxKZvkhJnAVLEQKuA2kbepcjlkSuYotwfBiTimhCQTCsmKFQfgebIqQ3Jor
         t+WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769492995; x=1770097795;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9HzgsJ827sC2LhFGy7sDRVcx3B1Tf/7PzhkQBFCLMF0=;
        b=CIQmpNgnlOpG1pMc3xoMBo+jeEM7Hyh6ajE8yM+4ZVTtIBDih3N7Ens7kII2wQtrcu
         oPbuKxHN8snq3+VbQjmuB+CPOdRKAVxV8+D9JNkuO5cE4KvUUm/79WgJ5UQxr1M0O91/
         r1R2gnn0Bb8XsRFxp1V3UQxhKozLnkFUDTmqHiqTFOAyrOOZkpCzXegv5Uv1H1h+aVmT
         vNleiOb/W4vCKCeQwrEqr9JH18dcZe4uBjq/kGcm77X8/ofFVB+uBzTexFodDAzxANY7
         9AI5/8NhV7RQoi/nZarii9casHWYRCTtzk4KdYtec3oJCUIOUOVRBnJbYrgVr59WHvtF
         H9zA==
X-Forwarded-Encrypted: i=1; AJvYcCVaNvkpTEiS4YHlt/2jlunGJEuhio2VCE5KLGdUdo4QmfcToREItSDORBbLHZufn03xKSmQA3KUSg==@kvack.org
X-Gm-Message-State: AOJu0YyZhmWhf6lSMwiUWd3UYpCo82Nu9AD9QtxK7N2f3XT3Z1diRjGu
	D3K6TYGXc8CPRs/hrrsFcLCXHRGH6gzf7QhpboqFW+FEXj0F7rMqZiRRvSscObnM2M1XXpccpPR
	wj/vakwYo94XenQWCfrVPnFJe23yjTv8=
X-Gm-Gg: AZuq6aKsLFUkqkyYeR1TjGH4yhBhxaEfiWyjai9wMv42mGeaEDGglVEu+hHhYOcfRBC
	+rr5D4J69+6C+lwXT7m/llQt4BRBoaP5kA7dUf0yjAiRJkzBiWOGYe74YFej6/JrqiF634valji
	ipQJe5MR+k5lAKwkeQNbV9xnbTQIWEtlIuvGdsSuyl2tiCxBbVDYZ5FUORF1yVglx4jksc2bbYS
	1VTwIwKI42BOfjEzXZZkUcV6xlFC07RYKwXzF+cyJpBaCPrixOuNP0rUcWry60uvLIzA/ul
X-Received: by 2002:a05:690c:c4fa:b0:78c:32fc:d3c8 with SMTP id
 00721157ae682-7947ac9b9d8mr3193427b3.61.1769492994629; Mon, 26 Jan 2026
 21:49:54 -0800 (PST)
MIME-Version: 1.0
References: <20260127024421.494929-1-roman.gushchin@linux.dev> <20260127024421.494929-3-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-3-roman.gushchin@linux.dev>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 27 Jan 2026 13:49:18 +0800
X-Gm-Features: AZwV_Qj3kyuk2DA9gge5_s9cvrRhNp_WPMd2pfEpoGaEHp1boZC6Dh8UH00fl4U
Message-ID: <CALOAHbDXmgi=yeB1c2zzQ7-Lz2+MEZvtbxQp1=mWXMJSsg3sgQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 02/17] bpf: allow attaching struct_ops to cgroups
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Michal Hocko <mhocko@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Matt Bobrowski <mattbobrowski@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BE632A0008
X-Stat-Signature: 8yekjxgorrpwkabgcuhobxm5q3o6wo1p
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769492995-981168
X-HE-Meta: U2FsdGVkX19joFx77jnxI3Ii8G5QYgkmncRILId4aHbl3tewSgr8fWVkZ28M7MVNiSiAv/fiLLQoMWNGBAZZRq+sH5aZ2imZKZjnrlT47qGNoYR1YatvCKCEowhxNpMEEy7po9399VzmGrSR/peL6CPjz5jKXEm85eVdhHQlBEKrJYY2i83UJQOu2svVUVustLVsS8VHMRLXbrmOoOFGVU9ZlElOYc8XYO/hHdu1NEXjONGiJkGsBqNB1zqg3/VVXmr9NceJ90R1B7kSO1Hqcn00aUl/7wG2mNp26n0MWFpp6Z5Par6rcS5YXrHvidDfDUd21OslYUwtyn4zP/SCpv6BzXI942wuh2ot3Xt4bTv7wzQpIZtHZTv00ge5BX/ctLYeIW1Ido7zipU+MrC4DvBWQHbQO+IWoC+j8T828tiEWfQz5lNbBka010SNzmiGpBVoR1N5mrIP0pqX1UIZ/w30FJX5ccETWf7BT0N9qiKgBp1pYk72AtfD17nEnd8DoYF53V8Lkq8wJGz4W1QjvCtKCnVCov+APTQ5CCPzkre8G/1cuPQJcFzT4Uvu36lkJ+vNnLFD/KFEnJ5ylqEfvdsYSUmcDy0hiSuGuRE9V0+dcb/wb+RX8vLlUOImPuVKkaktT++D7KoHVnu0PDBxEehnw2X+vtmbe/Q6iwkOj7SXGCm0EQ7R/JjvYRRVOOvoxSYf761fN7GpozxxDZTvePSbG0E1fdB8bmYVlvaSm0yKbOIu5b7pQx8My8wCU5Lwl+l9wxPyaJUvM6jLRWVnXG1eGKM00ueSueZv/pBE6DTdqOChWYEbPvPdEL7VG7mEsnI2RCqZksTaZrTSG6OzWqpA/09h4pmdVKYN0kZ+1FdLRIRdme0jU8SozP35YBXOuy2iucvyXuH+jqHqzgflgikgoR7HNRo0NtLjfHg0EjnUDnpYltg0intyBo9XVqcIrnwW/0btx7drdAIVSE1
 8Ad4PDGm
 3Y9YgM/O9UFO+aw5WkVGYjXrGFgx9O1i3tQ/AULaBadD9Fp5lUn5J/u1aBlnKwtDO/Rf3dCUhT6io5zEhwr4x8p6JG3iSaOwTZRu81SP2WdoLXHpGUm7/yw3sFP6IIfGmvEz6BaFT13C5z7GCwz0S9/nIafh7EvkpBny645DW9151VMC0w0qs1qVi3T7kYYw646zlYv/MYM+nBTt8dmMtlIkvOPb/m21oVOfLd4+ZjqXfBmvTXpfdJ9ZTTkw4P3FdnBVPufuwQidTFvgvLlO8k7qbNeKhcetyeg62Elv6On8e77V4YbYIpIDs5rXLd7OostzwWc7suBSnP3IcEg9APp/83J4fk9SxhVC/Y9tQi/35S7SS+cQB6C1z9kvlDGrK5J23m4ZSr6ytodBrfO3K/adkGAdlC0SjWsAvPr5Sm852cTgU2Fea1Tb4298DPmW2ohyhLDx2S5KBT4XIBnlyXWL8dKQ2XMMavKEhwpiP6E7J1JX8mVXnCG8kIYnhUw6QLQG/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 10:47=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> Introduce an ability to attach bpf struct_ops'es to cgroups.
>
> From user's standpoint it works in the following way:
> a user passes a BPF_F_CGROUP_FD flag and specifies the target cgroup

Since both fdinfo and link_info show the cgroup ID, why not use
BPF_F_CGROUP_ID for better alignment?

> fd while creating a struct_ops link. As the result, the bpf struct_ops
> link will be created and attached to a cgroup.
>
> The cgroup.bpf structure maintains a list of attached struct ops links.
> If the cgroup is getting deleted, attached struct ops'es are getting
> auto-detached and the userspace program gets a notification.
>
> This change doesn't answer the question how bpf programs belonging
> to these struct ops'es will be executed. It will be done individually
> for every bpf struct ops which supports this.
>
> Please, note that unlike "normal" bpf programs, struct ops'es
> are not propagated to cgroup sub-trees.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  include/linux/bpf-cgroup-defs.h |  3 ++
>  include/linux/bpf-cgroup.h      | 16 +++++++++
>  include/linux/bpf.h             |  3 ++
>  include/uapi/linux/bpf.h        |  3 ++
>  kernel/bpf/bpf_struct_ops.c     | 59 ++++++++++++++++++++++++++++++---
>  kernel/bpf/cgroup.c             | 46 +++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h  |  1 +
>  7 files changed, 127 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-d=
efs.h
> index c9e6b26abab6..6c5e37190dad 100644
> --- a/include/linux/bpf-cgroup-defs.h
> +++ b/include/linux/bpf-cgroup-defs.h
> @@ -71,6 +71,9 @@ struct cgroup_bpf {
>         /* temp storage for effective prog array used by prog_attach/deta=
ch */
>         struct bpf_prog_array *inactive;
>
> +       /* list of bpf struct ops links */
> +       struct list_head struct_ops_links;
> +
>         /* reference counter used to detach bpf programs after cgroup rem=
oval */
>         struct percpu_ref refcnt;
>
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 2f535331f926..a6c327257006 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -423,6 +423,11 @@ int cgroup_bpf_link_attach(const union bpf_attr *att=
r, struct bpf_prog *prog);
>  int cgroup_bpf_prog_query(const union bpf_attr *attr,
>                           union bpf_attr __user *uattr);
>
> +int cgroup_bpf_attach_struct_ops(struct cgroup *cgrp,
> +                                struct bpf_struct_ops_link *link);
> +void cgroup_bpf_detach_struct_ops(struct cgroup *cgrp,
> +                                 struct bpf_struct_ops_link *link);
> +
>  const struct bpf_func_proto *
>  cgroup_common_func_proto(enum bpf_func_id func_id, const struct bpf_prog=
 *prog);
>  #else
> @@ -451,6 +456,17 @@ static inline int cgroup_bpf_link_attach(const union=
 bpf_attr *attr,
>         return -EINVAL;
>  }
>
> +static inline int cgroup_bpf_attach_struct_ops(struct cgroup *cgrp,
> +                                              struct bpf_struct_ops_link=
 *link)
> +{
> +       return -EINVAL;
> +}
> +
> +static inline void cgroup_bpf_detach_struct_ops(struct cgroup *cgrp,
> +                                               struct bpf_struct_ops_lin=
k *link)
> +{
> +}
> +
>  static inline int cgroup_bpf_prog_query(const union bpf_attr *attr,
>                                         union bpf_attr __user *uattr)
>  {
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 899dd911dc82..391888eb257c 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1894,6 +1894,9 @@ struct bpf_raw_tp_link {
>  struct bpf_struct_ops_link {
>         struct bpf_link link;
>         struct bpf_map __rcu *map;
> +       struct cgroup *cgroup;
> +       bool cgroup_removed;
> +       struct list_head list;

We may need to support other structs in the future.
Could we implement a more generic solution, such as:

           int type;  // cgroup, task, etc
           void *private;  // ptr to type-specific data

--=20
Regards
Yafang

