Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B57CCC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8979F6B008A; Mon, 13 Jul 2026 07:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F5F6B008C; Mon, 13 Jul 2026 07:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7881E6B0092; Mon, 13 Jul 2026 07:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51A036B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:28:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BE31C14010E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:28:09 +0000 (UTC)
X-FDA: 84983529498.11.55A0FCD
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id A3CAD4000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:28:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=oD5iBvsk;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783942088;
	b=Q2mSCAKfvUkd7/MVsHuCKItQ+imd0TIxj+Jh848fDfDaQyLDXvDwMEIK/FFBzOUz5W9H7s
	Cx5g4vn9z7rwjSqYxqANS7ta833rcbvEE0ykAIxRTY2qYo3u10EvF8C8He2n3gWDlTTIJB
	lNJWDB3EVnoCj5PjNQnDZGB5kCB94TQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=oD5iBvsk;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.54 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783942088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8NaKZPLB2MbLryks2UXn+vW7Ic/yS2EZxUfavZtTHM=;
	b=CBOFq52R/dfAcEb+5m/+Lt7OR9jkryfbrgxSq2cDN50N0WYUcfUSyuqrz1Oz6WQ/2t9f8y
	bfgukWMk2S79sfb99Flvrgame/4XzGl7uXA9kueBxvVgefCRSJuK0WNUTVLsi5KDQezAbv
	E0TpuKUlzZQ6UzdRQc+9l/MkekSnzk0=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493ba701891so28399435e9.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783942086; x=1784546886; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y8NaKZPLB2MbLryks2UXn+vW7Ic/yS2EZxUfavZtTHM=;
        b=oD5iBvskwCAKrGBScTVlpT5VQYdzw01HbAr5UzuZe9KVzKrjeGorwl8CGIj0tRFGOF
         gjcQ1BWQemDdjbFdxim+QWfLQiXZKDpH01CkEBtUslnopWVxOsXe0AsTpWtLeOtBivul
         Nh8Ajm2tX3nXq7iEhoUmxRTnP0ZSsA88JN0VlpuiQ9dBGzerm8Z0YyzHp9/TPJ3IxEo+
         ievM6Ct/yNIOvUncZjJjwDpMspZ8nkgZ5a0wmWn1gbkf9GNr2IaF5MJYIT3f37dmQK7e
         jcf/fRHVpeSk2G36ZA8/CxtCM4OqBsz2zTKi9ph9kbXT+KXSpRg6Fur+8TSAiwVCOe5D
         zRUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783942086; x=1784546886;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y8NaKZPLB2MbLryks2UXn+vW7Ic/yS2EZxUfavZtTHM=;
        b=jJtWf9Xz2ezVoECTqlkigGuhhG9D/B48PXs3CXFSFySl4sc8+ZDD+mhkIfjn2BmBkm
         PdVeLCVC1D54lNzRxATonj7dq9pt5Erz1oH4iG1mqnNAid+FDcjP0OsFme8xLey/lR6K
         3ncEtrqEsr+npAwRWdE94bGT7b6q/BnIcQKxhH+kdlYpG6x3s2szG9x5jSLkfsntdBX6
         TBKn9mDJgoUddPJLsZ/YAdyGsfZvl1bD9jBctAxUu9LlUHWqbqWZrB17VFSvafs8D5GM
         1PemziZmeJbMgjitwzamKy40Ul3KGi4A8njr6UIXQE29b37qKKE2tyS27iEKDyaVgRjv
         AuLw==
X-Forwarded-Encrypted: i=1; AHgh+RrfHEQnk5Qzn8xdD/qpVbEdgJm/+b+IA4atejTgcczbRJcsVguCarqaLxHOHQU1BOBq10HRI/1//Q==@kvack.org
X-Gm-Message-State: AOJu0YwUS7XDlqOgN+pYewEzbL6/39SoHy0iAfyr6xzmA1zTOuLDylZw
	0NC7FRddSwbVqg3JOJgQ7dW5P7Y+x/ZHETdoJHL7mGfNyZNSx7hqc4ige40WpK/PeJA=
X-Gm-Gg: AfdE7ckLNxpv9CPUGdY2diZTKzZr+aNgB9dX6FqVt9/PDSGXWr/VmuMHqSpHo+/6ORe
	LxBZeB2kNGyt+4fAs00aBk/sZIIfnaVY3Og0WnJSqhCmM/8gIyGvWLmNj8jhMEVuHLv9zPjh9jl
	hjz+SlkGev7Cg/tWvk21N503Js/a3iKsbnuu5G2gNXhNLU5PATIkej0WcbsOF68JBhuSbKM+4bt
	r9PigSEKje+yFV8sn6gnOh7gXMm2ucqDNeCdSlN9cBYQ9yupQUEeaFVALziOtoxHsdY8iA5sX7y
	pZhxkPBa0KcRKmqqIZDDmU7ztLk6DoiFU4n37mi3JF1KeIIIEpHqfUy7PFC+3Tfa8D0QBbE06fn
	/zuwvKtCqBiGtr6ex1uYNtFZL0pZAJ4yrop0q+Nyk30TNnDRISdfp9G4TC9Jp+/2x3SAQ936QFi
	tn+bYO6nMNxw==
X-Received: by 2002:a05:600c:5489:b0:493:e97c:216e with SMTP id 5b1f17b1804b1-493f8851d4emr87837105e9.39.1783942086092;
        Mon, 13 Jul 2026 04:28:06 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0a55be4sm79986910f8f.31.2026.07.13.04.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 04:28:05 -0700 (PDT)
Date: Mon, 13 Jul 2026 07:28:03 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@kernel.org>,
	Barry Song <baohua@kernel.org>, Yuanchu Xie <yuanchu@google.com>,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH 2/2] mm: vmscan: fix node reclaim ignoring swappiness
 parameter
Message-ID: <20260713112803.GF276793@cmpxchg.org>
References: <20260711091157.306070-1-ridong.chen@linux.dev>
 <20260711091157.306070-3-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260711091157.306070-3-ridong.chen@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A3CAD4000A
X-Stat-Signature: cdf5nyxhrq1cc6q5gj3muxbyum6gp9au
X-HE-Tag: 1783942087-155713
X-HE-Meta: U2FsdGVkX1+cfatOFDXYJruZiYUBpfbKeImS3szO2JTvdHHfqvVSfd7NMjYwOeboPK+Wt381CJbPBPh8jwFoJ9yGiO6HvgngbdfjaTrXAQ4JlFERQDZOcL6S5+VK8S3RgfXOavzAYBFgxpVjkYIAihPYnepto/jsfXo8ZB+0Su5N9Su+kdwjdhBg7fyoM59F8b2YwQuizwFkIMygDzGlrbP+6gqa0UsYCvvSTfuXcxGYoUx5GhsD79mU5syRoq49gTJk9dC6v11/jSx0PoAS+0FqDZ/Y+L3G/YuF5Kwf0KOQNDGwmRFXgeJTomCRiUOiyXAuSk05rJNUh9WCezeU7mrj90ZomAxBpTa0UHJ+9gjMOjkddd7/ckax65U+BEpWHD/RL7iGBVPXig5sL4TymQim+6DmbT2lTAl14mhxqCu/sm1ip2zaCRrb83Ww/Q1RfmpqzSOCtwGgOQFRjHnm0jvh9U68Hixg0jsYV293JH5cGc8Rtb6pLal+cyiYXAgP+IUpxuGjw/AiudiS7L+dfgJh9A2vBz7pfP4o59AaY1rVAH9TIUhEJweJn9zf/pf0OTwvQ0ETw4xtQCI1fVgBHdCxVcd1qH3KQ2GylwG68kLrs91KdlEORDQga+DVJheVBqL8uRt8aSF5IOYhuQOyAUawqul/22M0I76+wofx/MLAVGlnZSHxuCeK+d7DYmORCZDDTrN7aZfZZUjJeSdZplHt0UfzFm7zEQyh0lnHdCA7YVQsXi1EwDQBnyaw4uOh5dr93/Cs+1gF1D5FZYpxkzAOwVrui+Y6ZZym76RF/jkmaprbbsG+EN1gpa4HuiwzF53r/nlkiLlugQnKzVqzkXsGRMVW5lb4GrhSL1o2iV4YpAc2lhTjER2QC4Lp9b2a2EGnqlQpvGSzCeI1FI6pLv+cPVNr1iNz25w3AiIsK/FhEmkF2fdK6wjq2aRhyNAzjj/4l8T5avyMvXuND/K
 RNL9VB0m
 nRPjNhAaoYzgW2KfTYXS7EK3YrpoW/vwYqoC7kZinacyT5hMaThozJWtYg/vvzMr8dYqPchAkzKiCK1/3DnvlawLsr5AWvX4bp1JBNrxnJoIT9pYhpi9/LsIgQSGCBcMe9Ym1KwPTo/F3JTWqdbWGlyPueZjLFOSKi5b2HoKZUeAt22PwpmoSEkXbe5ouWEo+mQGpHu/5Dwehv1SaryDAFL3vYWKFifLexzy0feVobPkipjW5UQsazM7QhEQ+QTpT8m/hnWRoCBHI7Y5aN06rjp37cDdjx7hwY1csPOR4jXi+JMFhX6H6P3NhCQd0Ge5FMn+nEAOa96kDm8+3aXlYBGXgh03McbjJoM7Cd39LlrBLldsPdeCndSBIEPD1zwlQXRF4peRlDO6AQsJcN4dBSC8D4D89zTREdpbnkBSv9VdwLuL+f5J7OsL5d9vAeXfA0FzS7yP9Ducyi+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 11, 2026 at 05:11:57PM +0800, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> sc_swappiness() had two separate definitions depending on
> CONFIG_MEMCG. The !CONFIG_MEMCG variant simply returned
> vm_swappiness, ignoring the proactive_swappiness value passed
> through scan_control. This caused the swappiness parameter
> written to /sys/devices/system/node/nodeX/reclaim to have no
> effect when CONFIG_MEMCG is disabled.
> 
> Fix this by consolidating sc_swappiness() into a single definition
> that checks sc->proactive_swappiness first, then falls back to
> mem_cgroup_swappiness() which already handles both CONFIG_MEMCG
> and !CONFIG_MEMCG.
> 
> Before fix (swappiness=max ignored, mostly file pages reclaimed):
> 
>     # cat /proc/sys/vm/swappiness
>     60
>     # cat /proc/vmstat | grep pgsteal
>     pgsteal_kswapd 0
>     pgsteal_direct 0
>     pgsteal_khugepaged 0
>     pgsteal_proactive 1840
>     pgsteal_anon 25
>     pgsteal_file 1815
>     # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
>     # cat /proc/vmstat | grep pgsteal
>     pgsteal_kswapd 0
>     pgsteal_direct 0
>     pgsteal_khugepaged 0
>     pgsteal_proactive 18013
>     pgsteal_anon 337
>     pgsteal_file 17676
> 
> After fix (swappiness=max honored, anon pages reclaimed as expected):
> 
>     # cat /proc/vmstat | grep pgsteal
>     pgsteal_kswapd 0
>     pgsteal_direct 0
>     pgsteal_khugepaged 0
>     pgsteal_proactive 0
>     pgsteal_anon 0
>     pgsteal_file 0
>     # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
>     # cat /proc/vmstat | grep pgsteal
>     pgsteal_kswapd 0
>     pgsteal_direct 0
>     pgsteal_khugepaged 0
>     pgsteal_proactive 16283
>     pgsteal_anon 16283
>     pgsteal_file 0
> 
> Fixes: 68cd9050d871 ("mm: add swappiness= arg to memory.reclaim")
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

I would put Fixes: b980077899ea ("mm: introduce per-node proactive
reclaim interface") instead. It wasn't a bug before that.

Probably warrants a stable CC for 6.16 as well since this is pretty
user-visible breakage.

