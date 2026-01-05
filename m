Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B74F7C79F9D
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 15:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26A2E6B016C; Mon,  5 Jan 2026 10:54:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2172D6B016F; Mon,  5 Jan 2026 10:54:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119FA6B0170; Mon,  5 Jan 2026 10:54:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00DD26B016C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:54:43 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AC42288E97
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:54:43 +0000 (UTC)
X-FDA: 84298358046.19.FDE7146
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id C185140003
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:54:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kk+1N5Ns;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767628481; a=rsa-sha256;
	cv=none;
	b=BSTLkdO/6LrvM2shFM2dcYnzt4bJJgk1hcRgeeFVYUtRDTaVcWwWuCz4liBnF3bzN9nC5l
	aUyK+GFVYig7N3twxK70ADLDwLn+jpxqhl60nq8oGmG9donJMXgbzT3MLTe/WFFZ0PLCeA
	2uSxkcfNpt4KmcLU9BV2ZlMto/pzNcU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kk+1N5Ns;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767628481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WqeiK1L0ygc2pzqeCiF6H1L5F3hBzQyLyjzKsWaL6zQ=;
	b=5/HoF4QusEM646OYLFR94LQ/9NGTnkD6N/1vX3DpD5GPufijl1hfgtu2b/SCOi7i3bIKUP
	n5S+i+3qP6WW8PhK4R8ezFaYSpIJhFIrJ/B15+Ym+GcJum2F7s5YC1Sdj4iu6Nf+gg+w4C
	hJsEiJznTtPCZTpsVZtJRTvV7foIy8s=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8b2d7c38352so195213485a.0
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 07:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767628481; x=1768233281; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WqeiK1L0ygc2pzqeCiF6H1L5F3hBzQyLyjzKsWaL6zQ=;
        b=kk+1N5NsC2RzEiw6MuzHXNvxFLKu0dtKjtXa65Df8d9tXgALQc5rvAbAoEMOXi4wmj
         53IR4bXov3UpPLfG27O7+dxARWskANo0Lwjz920qW3JbM5G8eNiqCBtkPsTy4+frACwz
         7RIV7I8KGv3AV7OFrBawcjbmAFfEkT2Kyt2cFCzjmjGX0CzruKbw/os2PQ4KC77BdoHU
         rBKbtpg2+R/ArtpUox7VAyGvkp59U/HyeNlaVFnLRocceThcOqDqaIsPwSMIoogHYjq0
         jg3c4OqlVFXbtJK39qYKy/aytERzkQzwERT6ziBZAXIryvElwFV+5HPsixmmnwhYnepc
         nRUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767628481; x=1768233281;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WqeiK1L0ygc2pzqeCiF6H1L5F3hBzQyLyjzKsWaL6zQ=;
        b=fMkler8WLWtMGd8uv9IfRf+YKmLUCVBMJ8M+JJLKv0/khs7NNQLeHPo1TmK/0+G7Bq
         FRbLdeZWGAypSFedalGIPdagvFxIED0V9qM+EtsIqTgZK2deO1lE3hA7tAAA1yhtzl0u
         HJg0k7Gt67m9vFAlVPlwVzmQSYOFt4bIdM2YfWkTx/xcsQEnL+T4ywQjK4Mq8VZ3wffQ
         3OXswBQCxlDrmeJu/kTSAforcpGZZenZd/BsFi2PDPQb3aS8oP0ben2nNQvpybQUcudj
         vyAYPMaSGYTfWskKuRZh+tsVE82YL0Ta9dTjYrMmfSfpGnYjhnUYiBUkt1ajum/qHdhY
         vpHQ==
X-Gm-Message-State: AOJu0Yzh8Ky80pIw/4VaPYgKY3hma/vg/y8m6+PEuBIazS1OI1otdPnS
	6mMIJ4a5jlOuspNjJlS592YEGAvtZzJ3VsX0ztVe5nILk1hBMnT40azR6FBFtkRa2oY=
X-Gm-Gg: AY/fxX4AlpESiUl4ojU+QSS8bBaW94jy1KHQtS1Sy2E0lGrDPbqoc7LTVsSaT7wFZFs
	RkBqp+a0JLc58HDQkGuUZ8grjNLxhkgDNLWBsokdtAIQwGQjyzT9AwiOtteZb5Bt9Pjvf/l/PyQ
	jTyVSENPQGMmBVXkWbWqXVeAneliXnc3umvd51Vi2zo5It7K2xzus9CE6mCdrjeeD4hCSG3eGCp
	BdTadn67AyQNuTlNCv4y6FjZuMcFfFTpPrbVs/4R3r6ia1c0vyZkpitDc4Ape6evq+rBtXiAfmD
	dARYJk3qajdd97FoCZrju+8klbNF2SfyWQnhFmk1/zhPzF4SPqBpDTYlLhRDOBZFuCgnFroEdiI
	darvFxeRoHeUplAGWjJ94cn6DeDjhOfCDKjydOi8t+2KgsOqscLeyahrXYaqBM7F4TnRBOFkx2O
	yvaSjbmiXHSGH45qiuOapm9BOUxKTesZ7s3/zcVMJS7SFjNhAbQ+G9xieAkMWwB4zoaqksJA==
X-Google-Smtp-Source: AGHT+IFjadPoIlIw6SGjI59tZCwclSAcWIXhM7W6liSGa0PXOk8e+eEyYSDeMbDYFUQqM4JsPhO5iA==
X-Received: by 2002:a05:620a:44ce:b0:89f:cc73:386 with SMTP id af79cd13be357-8c356acd43dmr1062406285a.13.1767628480647;
        Mon, 05 Jan 2026 07:54:40 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37ea0f713sm5250085a.15.2026.01.05.07.54.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 07:54:40 -0800 (PST)
Date: Mon, 5 Jan 2026 10:54:05 -0500
From: Gregory Price <gourry@gourry.net>
To: Bing Jiao <bingjiao@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, longman@redhat.com, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, tj@kernel.org, mkoutny@suse.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com,
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com,
	cgroups@vger.kernel.org
Subject: Re: [PATCH v5] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-ID: <aVvenfzgCU9uKJN8@gourry-fedora-PF4VCD3F>
References: <20260104085439.4076810-1-bingjiao@google.com>
 <20260105050203.328095-1-bingjiao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105050203.328095-1-bingjiao@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C185140003
X-Rspamd-Server: rspam10
X-Stat-Signature: sacagm4c13856exh13dyru4dmrrqf1uo
X-HE-Tag: 1767628481-834443
X-HE-Meta: U2FsdGVkX19jFyznRLdhXIy7OkSi6Sx1rF541216HU348mOO7rbVynIz+jRY00vxh+G4L+N4ogVbHM6wsIM3prmfbnGU73JRJeBxqbMah3nrQui3GdFbFn3U/WApIJSo/DYH5w5h4vruEGufTfpqQtGXgbOO3NCEZy1c/cI1eS7Nxtq+btlSNInZPnx/mo/hlrfvKyCnZtAExSz05ueDjyDrl3M9S2qeeT8nQQqU3JAtjEQX2qTjffdOuzun4ZzajAGeJWV11eUfajvs+4bGL3cr2N04gNatIuihUFeoO/Qtjx2akTr8ZpZBQ5sXG7zcRzkS5cAVkbyCbt0dlCnohBdxaZ23kqHv1o8OfyLBjFFgP/9zWK3fWDV6Dd+k67zQN82t0fSp6Rlnz4WkYCnSyW1wPaMavbB/zp1QD/Fy1//YeUWUkHZWMIOyf8QJT0l4TiogKOu0qyOICA3jP+2aXVI5KOl5i8dlaB5RtCXd7FBorPYGk3Fr27lK9I0Wwl1X2FlqvslD4kjX0IW+GdIuK5cAD1aPnIVA2adDhJk9UX6g/W9n/WyicNzpC2a1OfJEuJUertkUOuBS4IG2nZINgJvP+c5Bs3R8AWd4v43OBsdurUb/qt1PB2fVygifwtc5GC4qKjxpNJwzFDzISNjNXFw9lYgr0M8qIt7TeP2YoZe8pXt45BT966TCEx4n/JbvZAa60HLTmMmE4RXeQWam74Bl+kNS5OVo6tRt4xYjlRRrnl/wxr6/9n89LvgM83JDiNZXMwRVHPJxL4llqPdrK18xWXGG/b5DFcTw+yZuvSwU0VEfmkh+xpMX4mw15oj/exo297BD5pDh1msBTltUr/jgxJCdxLqj/EOv6ySWf0ahDRjxI/+fzCre5bmYzpXA7tunsZ5MlpOaC8D/RNtZyYQ+6oDaw/UFAmZYoJtAmRarNYBc1Ej4xYtmvrumtZLOZoF43/oJUdvtRWAixkE
 mJTjJzNH
 TQxDPxK7P/FzyMjJuBf8td50FquK4nzZ6ppsjkaTG8kV2AiFm84hkk2qv9ptTk7udZRC/9pWvW5eJXF1GR1iukWBx+IGXM1vX8aQksaCi7uZ1uC26L52OBOAOFTC+qXHoUbxwa6UuPHu0avu4CfdE9R6VEeL/7a539TSqdgjXCHK0/EBbfrbLwjDpiyWS8iTaUdgjiVRovqVl6Y6//grjIWMGaJV9Rr2bmdcUygFaULt6IxkN+cHW0ycXe519rTL6h4wSR8BQcsBKBt4LUBgSgbqKsmUdvdtbrpwpA510Noe9JAaUZoaFmyEGGk/DJU2PXbiNFpCVdxjFy7M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 05:01:52AM +0000, Bing Jiao wrote:
... snip ...
> +/**
> + * cpuset_nodes_allowed - return mems_allowed mask from a cgroup cpuset.
> + * @cgroup: pointer to struct cgroup.
> + * @mask: pointer to struct nodemask_t to be returned.
> + *
> + * Returns mems_allowed mask from a cgroup cpuset if it is cgroup v2 and
> + * has cpuset subsys. Otherwise, returns node_states[N_MEMORY].
> + *
> + * Returned @mask may be empty, and nodes in @mask are not guaranteed
> + * to be online.
> + **/
> +void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
> +void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
>  {
... snip ...
>  	/*
>  	 * Normally, accessing effective_mems would require the cpuset_mutex
> -	 * or callback_lock - but node_isset is atomic and the reference
> +	 * or callback_lock - but not doing so is acceptable and the reference


"node_isset is atomic" is an argument that not taking cpuset_mutex is
acceptable since it's a singular operation against a nodemask (one bit
it checked) - and therefore for a moment in time the node is either
allowed or not (and we make no absolute guarantee of corrected when this
race occurs, we just note that we're corrected).

nodes_copy is not atomic, and in fact this can result in returning an
empty nodemask if cs->effective_mems is being recalculated at the time
this copy occurs.

Rather than just saying "not doing so is acceptable" - can you please
change this comment to explain the implications of not acquiring the
mutex a little more clearly?

Example:
```
We do not acquire cpuset_mutex during this check because the correctness
of this information is stale immediately after the query anyway - this
saves lock contention in exchange for racing against mems_allowed rebinds.

As a result, @mask may be empty because cs->effective_mems can be rebound
during this call.  Callers must check the mask for validity on return.
```

The rest of the comments in the function explains a about this, but I
think with this update the comments need a little more rework.

~Gregory

