Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B9F8C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 20:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33E1C6B008C; Wed, 16 Sep 2026 16:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316466B0092; Wed, 16 Sep 2026 16:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25A696B0093; Wed, 16 Sep 2026 16:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0988B6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:04:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2798F12013B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:04:47 +0000 (UTC)
X-FDA: 85220703414.01.EA76459
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0ABCB8000E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 20:04:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=A5K6tlec;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.140 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789589085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYBE6fjhCC90VNWvARTLSCkVoVvNv7gfJ6w8/9LQtiY=;
	b=qFPq1t+8zB3LzRUqQmXaRdliod1lqcqxLwiE5m5sIjVQ/kh1KeQ02lDy9SgWozDHaNuEeZ
	qxtfaBsC02ZurLqcCeZ6jNMWV6TwDehyihmX9nOjoSUix3jKHo4WeNLFwrNwnDq2WbwCao
	iP2eSMASJTQc5htJX6r7xkMK0hClNbg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=A5K6tlec;
	spf=pass (imf30.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.140 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789589085;
	b=0kbst8vJOSrORt6kuHv12RVdn779jJ52g0/qrDMMbtS3ZyiD/nVF7D5mRbWml7nGNnAtSO
	ErROtISqwk2lNChyH5Gw5NKZ+tblLMbFaVOVsh84HDeARC+PuRs2RK8Tft+afLi9IOdQjk
	5rBZSg5qByDwmaH6e0ULQXTiDzet8j8=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-910531ea7feso532776d6.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789589084; x=1790193884; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LYBE6fjhCC90VNWvARTLSCkVoVvNv7gfJ6w8/9LQtiY=;
        b=A5K6tlecLmn7xZEtKhJNtWFop5FUQnIpMegirIbb5uiiDKnled6eqIKrt9wvFXW8Qa
         hj8LBFvZYLVTtN0xVbtw7xbkkCbhKshFN8LhQ7x8xkCz5gOt5lROVq6Ew/Yfx56dPu4X
         hCiTfgi+AE1cHOf8wUTscF4v3h4u27dTz3kryzYf2VLjYgitrb5eQ3H29MSja9m5G8H2
         pezHdqGhktjNiiCh7kR+8cEQccODbHUh5GuAt4PGGm0p/y350Cln0XZrWZb5reVNxSaG
         Wrbyy4I3W8l93neJpWxJFvH91COVSNG3znXu3iJJ99uqBk67Yo6yGcKdIOSEgjbv5/h7
         OQBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789589084; x=1790193884;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LYBE6fjhCC90VNWvARTLSCkVoVvNv7gfJ6w8/9LQtiY=;
        b=mF5TNeL80KLp6EpDmEbSgpWhODrM7eZHW9MjW0FRBGb4Ai2w9pnnYaoAmNeg2RpXC7
         uQwP5B7lyAt/8TJsW3UAN1HIWoVbfX57B2cIUCbYHkcxIycWNUQ6d50p6v1W37upl9io
         cFtZQS+wII18W8dvh1umggVr0IpTl0DeByYZ5jDtzlEx4JO+uXABYh6zgoBZUNcmynkM
         u3XHJh+y2krhHBjyVPnfRCj6VBRRMLo8yoyX9IJoU4wxjBf2IIlec72ClvtW57tWwra5
         kAuh3+jEt4aAGiFb5R8NNbSjIt0eOBWH6UaheFkmwRPZe06hvBiOK4fi52cKEkH0dr1j
         xD9A==
X-Forwarded-Encrypted: i=1; AKwUvBzAmQBYQ/jDEFtojr0j7jvOWygQ83eauvibXGa8xxi9SXoz6TBz5wT6SqK3NSXG6m7gPiudTIC39A==@kvack.org
X-Gm-Message-State: AFuF++n0sVA5bd8A7pnRM24HxlEGE9uwFEpWjz66cal1LsI3MviNuFu1
	l+5hrTS5bvyicw8Ez7SCFOy9kZdWe0xnWEbwxgRGu3gxkJyZ5bLz8Tsl+o2QxLZOXpo=
X-Gm-Gg: AYBFou15rRaAmW+e9AkQqYH1wbvQtLngP7CnozGvjs8OHbioegK01f5YZDIVA5FgfpG
	Lf7BhShM0bcDAJtH38jDfLvgQLoEWtLdf9MpvYZOME6FGymsufxNd3dWRfBf2RkRqur6oVYIdCi
	oGps8jZ115JF+qjAoBLmxDkgKE572frISsWYX8SWd+pg+PuibrGc3S5d6h0q8G07ktbTTkj5rZS
	fl7ncr+IPfRdlJm8CBo+pkkRxwIhZLQSJY4jRzUg56PlDkHHYE8ORmrKtCGNPSYm4odivupdIsz
	E+IWNmlxH3cHPM1Y6W4/o8lhhOa/5YyYbaPhixug40+FekZs0fzJZOMZPOcyMfKgh9+oJyA6UVW
	jl1VV8GPS3eHV2eu5kEI6ToqCugzS0Vgz0XK1Jno//CxXrl+pgfvHh37S5nFEwq3PR9RBkzlDWe
	scW8DMbVHeyQpNEfAa1m9jhPb0xaSpKWCVNc1zWRBKsl9iz+dlBaU6Yj/JnzZztZ6bWUDQOA==
X-Received: by 2002:a05:6214:404:b0:8fd:d5a7:f970 with SMTP id 6a1803df08f44-9123d754226mr75992146d6.11.1789589079282;
        Wed, 16 Sep 2026 13:04:39 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:1f35:22b6:fe30:2a34])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123be946f0sm33219756d6.27.2026.09.16.13.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 13:04:38 -0700 (PDT)
Date: Wed, 16 Sep 2026 16:04:34 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
	yosry@kernel.org, joshua.hahnjy@gmail.com, taejoon.song@lge.com,
	her0gyugyu@gmail.com, lianux.mm@gmail.com
Subject: Re: [RFC PATCH v11 0/4] mm/swap: priority-based swap tiers with
 per-cgroup selection
Message-ID: <20260916200434.GA5784@cmpxchg.org>
References: <20260916183437.2946306-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916183437.2946306-1-youngjun.park@lge.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0ABCB8000E
X-Stat-Signature: uadccs97gntzxwhrcehuia6ttdtrrabo
X-Rspam-User: 
X-HE-Tag: 1789589084-652862
X-HE-Meta: U2FsdGVkX1+vz+B75GGPsPe3vcfyZH2RHqir/JrO3ipryIUYi2W6GMR7BV2HoWAgoB74jBmIFbjTpfdxj5aQ/jpgXi+Fj0xrnZwY/F7HJoS9AExuUdT48lAo8xPLi6FFeV9z+I3vunVThjqcxbldhkE7L3RX/Qi/o15ZcamVloJFE/dTGhW6abmB/bIIukb3c8aV/Dal8xdOJnsRVUfSUQLKmKEE4m5efXd4YnoEreljuEsSSATOucWFVdkQKKJK2u14GHuX23sZKrPfERhT3VirWUYxBD5jzbkNi5iWMlWL3rAJLidEbqEiZpswTBN1w1Pv8RPg+RGNWSbmX7WDkmZ8Hm4hYiA3SAgKg8vXuHljPrxv8QcMQxmeVPhCb4crXbAB3/sG3FaZiq7VlO071XvwQs1PWfEqWJVZEAug1PYSEtwLZf8QYhXSdLox71mLVinH7NuODPxTzFlvZCp1mWG0tSqheIReS9vNSMhIEal29RzA16LeA2PXSUycqRoUvlpwXBbwLAMNz79cl2eTZJa0lQvIo/iVpHT1Pt+pipFUa7j5taykRrGPeIPbtFKEQExd7JcoLRd3gu158H1DcOGzTeS33hbnHml+gJHZLNlT4zFa9eV7nz4th8TXcJEoq/UuTRS9D5BQNffSLgVbjvWO/6kSSekfpVQwmdtixiAckLw1mo+MT3AsXCHz26+ExNj7TgAirx3Jc3vNCKWkSrVsG/1EEBVPg3KmWEk/CskIkavO9z7OyTOLu4+pNwuteRrx/eaysZ7qJhKOFfropRls6FHgf/G6SxYIgsVfN/YLdU0yqMsYm56JocTEX98AkkpawnfgPKq/yjpo+/xVehnkOW/B4iumrm6Bedlpx59uRY9XpyENycH8Z9dWQKZUwl7Djh68R4Np6bQqU99atu+hkkMjQBGJkFZOxf7HuaZDNV67wk5s60fBtXgI356R24vxZGQ9oeoWxKa1ChQ
 rmbE+Lmi
 8vCGf5uZhvGZ0Al+aW29mrSnB4gCBhLRntz3CHt3IBDXHg/7PMGPLrDxr4Pk9zWjH3U7noLt2TBJC0xuf3NCMlYgtOEEWoFuUajWFqyFv8qWqsri7/1UmUliZ+ZYJCXgIzXSQfYrb9CtTVLSzWzZHfFXUcqQ0icMTf4BTXLNZoLc27g5JezcUxMPuj7O3DB0ZyeNpaK1D0X5qowVI1cVqH4pmMJxG9uzRGzw+W4yHkDAm1z17IQyWjc2J+y47vS1o1GZCAPknVUrjBgIhTk64kltxin32r7nkcPAIil/a9HwcX4sPsJFmSyE7b+m9CM2hZ/IMJbIpGybGCTEZzDvtmiqSI7FjW8rZzrBjcawNNB8cg9Ev1f+WdaaRPi9+lwRcfa6kiOf8Xk/2Jw5wb1X4PeYHtg8lHiSq3JrFV+4GrAmDbW522y/QewBk3xzKY88jFMEz07OVE8xF9CCVeBFdlHU4wZ8lwbUPON0S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 03:34:33AM +0900, Youngjun Park wrote:
> Per-cgroup swap in debugfs
> ==========================
> 
> Patches 3 and 4 let a memory cgroup choose its tiers through debugfs.
> 
>   # swapon -p 100 /dev/nvme0n1p2
>   # swapon -p 50 /dev/sdb2
>   # cat /sys/kernel/debug/swap/tiers
>   Idx   Prio
>   0     100
>   1     50
>   # echo "/batch 0x2" > /sys/kernel/debug/swap/memcg_tiers
> 
> Bit i of the mask is tier i, so /batch swaps only to sdb2. A tier keeps
> its index for its lifetime, so the mask keeps selecting the same tier
> across swapon and swapoff.

Can the cgroup be given a priority limit? That would have pretty
obvious inheritance semantics:

root
`- batch (memory.swap.prio.max = 20)
   `- task (memory.swap.prio.max = max)
   `- logs (memory.swap.prio.max = 10)
`- interactive (memory.swap.prio.max = max)
   `- task (memory.swap.prio.max)

