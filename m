Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72835C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 696766B01FE; Thu, 13 Aug 2026 04:27:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647726B0200; Thu, 13 Aug 2026 04:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584C26B0201; Thu, 13 Aug 2026 04:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 349976B01FE
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:27:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AEB8D80575
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:27:40 +0000 (UTC)
X-FDA: 85095567480.14.55C448E
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id D13C7180003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:27:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GKMnLKRB;
	spf=pass (imf06.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786609658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9K1rmCOf2/ZVat80yjoIGMbcH4J2enbzgcI1jz4HLNM=;
	b=8hghpmPIc1FyRtspgIJGsF7hAXpaeQPYqdJDTd4nN8CPca1V2LDtS5l8ySV89EPf41G720
	JuTTUPICqfGbIbiWtLqC6pYE7APxpQ1gXDHOsnegckJim3NPsCNX8BgXjQitK8pHJSsZMT
	nw/Z8v5+suWmgKt3I/1dSDzaDYnB1Tg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786609658;
	b=2hSltfMi2Y0jJzNwyn5iR5ROL0/kWPezz7CbYUgv8S5bx+mAk/PWn6Ytq0W6jce0bvd5VT
	1GVjH9rrDcMBSbD0Y0AfrA3INhKsarwh0KBaynNWlZxtOsdEXOA199qR8JkKIsN5+sb1Ql
	63xj5kIq5BnekGUiguyIoTBfamScGQs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GKMnLKRB;
	spf=pass (imf06.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47db714766aso384916f8f.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609657; x=1787214457; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9K1rmCOf2/ZVat80yjoIGMbcH4J2enbzgcI1jz4HLNM=;
        b=GKMnLKRBICPJE5C5AaMDNwpUD4fyPj9wHO3/OKQhtLa+mQH3WR2ibWv9TvP3icxn6Z
         dCU4ez+wuTUIEjl746rUtMu0plKvtxEP7zQyFbBi53iQQlQU5jHUOiC/h3JuqP+McSro
         DliTz3hFvb8ApxeBAXqIlzF3WBJn/Z9vxkhTR4DpF00UL+0btwd05q65ivyBGzxVhhRF
         RTap/BLVHhjQg4LHBFh4hKhUBEcZ8KhvlMgpdfi0LSrvzx56tefbSRa8McEJioVzG+TG
         JTMvLJXAhJfnoskIsfKJnUr1QaOR/GXVh+448PB2S+ax/uQlGOYZ/LJDm+qklhVjDj46
         TkOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609657; x=1787214457;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9K1rmCOf2/ZVat80yjoIGMbcH4J2enbzgcI1jz4HLNM=;
        b=hsaqlcuyVJdxKIJ7r1xBRERQjGn0ChPjmEXyQuHbwXK2fD81i4DTXAi0TvHWq6IFHC
         wKRrfyng1oC7g8cJIp6/s+aZ+mqnpG40uZD/zIJp+ahutwcrq2gKtveg/6dLO+4dSNE5
         ZFb9Mv/VP6/hFjquTYI7MfoRZ2LFLBfCXO+eL9IclgpAB4GT/Qz7BmhIvOttGgLVn9MI
         E1yqxRs7zU0V/25X7yWwKps86S3GxQ/+h5UzRugfXl1a8DAwIS/PXTiQ3Te+emg4sajx
         8BjmbRuwqxHNC4Aw2BE1lKK6Xn211ccexpn2kWMTkUmsPpHfhBeS5MPHW0pTadURjUVT
         oc2Q==
X-Forwarded-Encrypted: i=1; AHgh+RryKVgoeKpek6caMlzKNEcqbF7HOkb4u/qbR/qmI1ti7ALiMGe2oDZyIFsaQvR3v3NJBkrk5bRCGA==@kvack.org
X-Gm-Message-State: AOJu0YxUJNY0SyoV+V/DDuepE1qV/KGKf4d+YIWgJ0ORxUAZkSQEAGOk
	qN/2zBd5GchVYd0lQqYd2rFEANCJSdcickVVzYPwtoguqTF8/DIlV21m8UQH+Onn+xQ=
X-Gm-Gg: AR+sD12rmZAPPgy/mSE4OFCBQuEeus0yTShe+KMuKALOuwjd/0mI+soom0IXPwrdDcS
	lqvjhHbZ1RX8RnTngozskblhIHeFeS7xWcmO542cICRYk1qdce3YZNG4dDirx/wlH4lUCh5+FQ/
	Z4i/IMVkZiZyCurOa1fBlDoG1YsnInB8R8hyIS9s/0aKlTMnM3ra8wAYwhJ5c9kOyaaIMXIukEU
	Y24chGsqiLPzzgW085JbOdDcqVB9/vUlxjn1Mosmdpk/ESs3MRL2ohlg1i0/XyiXiH8ccXs7tcg
	FzE18OO6Yw0mS1eGTiFCcThCNAvEiqN23zCP+Vj3mDEzqDqX9t/BImh8VdYhfzDM5QAiXieWLT6
	pnNBHzQWlTKbDszlEZ6U/zPF1t2MgOTIihh6sV8GYcp+qQlwzP2pOjEcJ+T/6NEAHdJtI7nxkZ2
	5IDAMfWNYAvHlhf4Ys1IHmIjE9nZm6eX+Y2FnovADn/Qw1MQHY90/0g52u7OeqSuUoqhKNGB1+B
	Ga5
X-Received: by 2002:a05:6000:61e:b0:47f:8603:a879 with SMTP id ffacd0b85a97d-4815a5e20a2mr4317178f8f.11.1786609657483;
        Thu, 13 Aug 2026 01:27:37 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5c2769sm4395482f8f.36.2026.08.13.01.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:27:36 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:27:35 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] memcg: remove the per-node soft limit tree fields
Message-ID: <an1_96llTS_zbmxp@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-8-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-8-shakeel.butt@linux.dev>
X-Rspam-User: 
X-Stat-Signature: k48i4ia1ca8pcy765jybhh6r7u4ydtc4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D13C7180003
X-HE-Tag: 1786609658-32798
X-HE-Meta: U2FsdGVkX19ozbzaAbwwZdpBPZpJCdr0SJKUQiFB/c2lbEkk+kLMsE3AUzvTyW82ItuymxeokIl8Oc7qibvb21PFSqJqRY7WiRZ+sbuXpBRM6kAxST8UJhuHy7x6GZjuZ/sLErYWHipGy6CJoQHD8vuhF2+oKD8rCxPtFvApKQ6uABnuOxbDUb+MrldhG8BK4igoTcoFI9a+HC0MF74qKyrlOtkrYZKLEeQqRMhfvGg7eMGP+mis/zN4FZaDmdnu7StEgMfk51a2W6hWnW1FiEgUC+Fp/inDmJ4FXn0a/CFiAHlqAyp/6Zq9IzFoJMGkZDLUAxsdUefiShqFIlhr7HlrcCZTTf8QV3AvfKyua9vSXEG3mHHjcLt4cHAdfJxHEuq9js611brmRv1ZwbuWUhFNtET8oqE+jDjo526Sp3EGfpEZkh8tx89QT4oKdamDDU/uUSpYXfskase6j0OLw35dWnyIfaA6d906khZydJiQ5nf0s3Jwmio6jj8rbjvUH2g18W3f3AcMvgQrwXaqmsQIwuZApQsKmISb7wqzZXb95EKjfz83nlQZi0dGFd/I29Zl8Y3aQLcd/KXybbQMAgbn7i0QQcK3CDKuuUo1Kbr+XWhv1hQTbfxEs2jN0+1hPpzKtP+loBtcpIMOivGJi1BQAC8P34tuYeR7649+nK6vbqt50rz8OLp1ZKmlmH2EGFRgSEPaHZO4xlsteCAu5hSJKVSVn5DYjHjEeeY5VmpUstOw2WPdM1S4LTLwHskQM4HBWFjEeYvl+CPrr0fmv1X0TDDI5G5rsRoCOo1yZghlXC0Paf5sgli4WHUUYu7kn55IjyHTqfuvs8Fdye6T91Q9MbTLUvXlFJSafUQN9LAR97bC27641MzuGYpLdCtojNRAA63KQkyLCQW4So4mkGPiapxUmu6N7z5HpjupJRTLiil+EoCGr0U1ajPG90NxHf7+BzZloPwf+SrWgT2
 8WLpR2DM
 sezqhQYxK1zPMbmGMFyFFMNRy1S7NOjKKPX3EQIOA9UEsxwvYnlya0w4WNKKOicOppwVd9zDcKMySunEGm40punCXoVO6w2tPdzOrB7mhf1OFm3bpoDGwMTvskw4x1FfPY5vvShKCrJ1sD7PYxH4zQ8DIApaWw6R/n8PWIK2NFDYot3sg2gb91J8Fa1vbltBFAYZkCOav4sXgpSwVU1VO4Tn/az/O7xBa6Bgh9UeicMzd8nSTh/xhGN1PcNThHeuBo1o09old2ib7z8shN7S4g0xsh/cFI5WLs9XjUq9K2buJa7nTd3mAKKqpzBoxcW3ggo9Bp1sBOchtALU03MEQEG2nlJQIHo2mFRfrlmRfObstB716iXzjIBXNCM39SW+QlnclT6OffEyc4L/zEggslZnaUcSHs0+XuMTH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-08-26 13:32:01, Shakeel Butt wrote:
> tree_node, usage_in_excess and on_tree only existed for the soft limit
> rbtree. They also doubled as the buffer between the read-mostly head of
> struct mem_cgroup_per_node and its update-often tail, so replace them
> with the explicit padding that CONFIG_MEMCG_V1=n already used.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/linux/memcontrol.h | 13 -------------
>  1 file changed, 13 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7b02f1b3bb88..ce24e04967d8 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -95,20 +95,7 @@ struct mem_cgroup_per_node {
>  	struct lruvec_stats			*lruvec_stats;
>  	struct shrinker_info __rcu	*shrinker_info;
>  
> -#ifdef CONFIG_MEMCG_V1
> -	/*
> -	 * Memcg-v1 only stuff in middle as buffer between read mostly fields
> -	 * and update often fields to avoid false sharing. If v1 stuff is
> -	 * not present, an explicit padding is needed.
> -	 */
> -
> -	struct rb_node		tree_node;	/* RB tree node */
> -	unsigned long		usage_in_excess;/* Set to the value by which */
> -						/* the soft limit is exceeded*/
> -	bool			on_tree;
> -#else
>  	CACHELINE_PADDING(_pad1_);
> -#endif
>  
>  	/* Fields which get updated often at the end. */
>  	struct lruvec		lruvec;
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

