Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B71D2CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 16:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4046B008C; Fri, 16 Oct 2026 12:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7D7D6B0092; Fri, 16 Oct 2026 12:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6BE96B0095; Fri, 16 Oct 2026 12:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 85FDE6B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:19:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 258F2A04EA
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:19:39 +0000 (UTC)
X-FDA: 85329000078.11.228A45A
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3D7EE40004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:19:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Nd8pEUB8;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792167577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sknvcXuzW07rbGsF6fwWjmew1+2afMy70Rv4vHSfSpA=;
	b=DykJkxdZAZppNeU73JI0caqpHxmRLmJZr+2z2tly8siWRGJHf4Q6dWeo74Jb8xSRlgFhSv
	GRAzRapj4EnttxeEKDygZnaud9x1I9AuiP/BSSrTh8eIPiY4e4PMcVquZcKQwJzQbibOEF
	kllWwNbh4gFg8RpFGIrLBEDjF+tGjNc=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Nd8pEUB8;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792167577;
	b=Waz+Uef6HNs8snHe1i9tGh5ZQ+kePZmX9/qm9NZJ4Y436QLyLuqwtMtOVx/HHjNebgTfNc
	JiPM+IeHFpztSrEcw3VyxQYw5lac0RvaLeYgYr3+1bZgcG6WVBcUWsQ5AwsEzJ5/iLYlSC
	saZH4VIInVOocOHvU57gWCcC6+d3s9U=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49fbb2acc90so1298345e9.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:19:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792167576; cv=none;
        d=google.com; s=arc-20260327;
        b=hN5fZN+35AbLFJHEWjOfOBgTAFpPm8nSZCvBo4NmKieeP362MvxMY9rwv5XFcVcM7q
         s5J0xvhY1SmezW3q5VPw1W35XHfRo0DxgNXKGDVKPoaqCVZPb1MBKkBc6wnxdearuy7V
         T+K3+k6P7fTm1Rkh2LPlmKuJ8iqEwOWynZn5ksQ3Kbp0G79RtSRITLo1CAlv8su7NTgV
         jRTJh0+157LVWxPW3mf77S+o2ekaCKECntAvFGFF4dyvHx0AW+SjpCbVcJUEVXQ6oA7R
         n4GI3jkPjUXIRK4ndr8lFPigM+93+gNbt+CS7Cmz579LKsJDNUW8o/oGLC3MvOx/CypJ
         cM0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sknvcXuzW07rbGsF6fwWjmew1+2afMy70Rv4vHSfSpA=;
        fh=7U47J9EzYgTBK22yVQyHLfa7mVUhzHCNmqfivOCopTw=;
        b=XlnNRRKGwLrmV1J9UkKJO+8puBU5FdPNZl+zWQFX8j7Z66RRWgQqanllIcM5cZ8uOA
         bPCq3tIV5whyHW41udpfA0EraRHtiQ9bfLKHWms7mcyibZ6uE+pN06UwmaD2aI03jqy7
         zdGy1gIxVQ8rhBXhkspDls8/SviEorbdvjhSzmADz4vShX8cRGm4CUWQSAzNjX2irLj7
         /WwYQpYnD7eiBgdNwOqYQcJx7bS7fTtB8rLFZg+4oOZqW3Liw1BQhI7VAF3x66nwx2Fo
         nxGsQyirxeQBlqE9NXTJdo9lraqiXUvb9nTPri0gyqr2u4U3tbIjEODFZnDrP6joeF6q
         bbeg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792167576; x=1792772376; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sknvcXuzW07rbGsF6fwWjmew1+2afMy70Rv4vHSfSpA=;
        b=Nd8pEUB8JTnYy0Qn2gea5u1f2pw8Nzy2VCPPdLvidlMEgpmvyr4i1FBq1mdFlCssYw
         dLxeJVVyMT0Mo7eoUp81f/UmOWfU0wWCPesFS1vtG05sHWj0tUj88BTaw+RKlEliR7Ol
         PD+ZYIN3fjHRrbYn76vVjcmpQd07s0aHmENMcwWR8hkvs6pH0IA+QjEJ4tzXGcqZVjO9
         qSYLhv5CW+cpofY9gIPzHnrqKdLCv0/L3NPMnxHIUYfi2OMkGrdckzCOjHwcwxbeYfwd
         Wtk4ZdgIdLV8BUOKvvrhEYFXJMdQnnrNqgPFhw0dUGDklABpnamRAdkRRZcHswy/MSkP
         4WAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792167576; x=1792772376;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sknvcXuzW07rbGsF6fwWjmew1+2afMy70Rv4vHSfSpA=;
        b=rYUxHV7uRiN2+RZpIBWoPgS3aUXv4BlW0ic35+gi2c8+0lmoix7/1dH6AuC79wo3HI
         xBTtkdT+Y4B8zbEeI5L5lDWeeAYwVoPXkh/iQ/h9TDZq4rBGxlkqJ3cC3jbruEnV3/VH
         zYB0R6lD4x7kA5mP05W5WSqsnPrGfszcRX+pVGQFj8T2rfpOp+o/hVYrkIAG0AWWnk1J
         ydx9MsL+uXJYGaOG4oofj58bnB4cZG/lpIVMsFPxLGkAYroejefxuoeQYcGesJRQilT3
         Ffcr71ca1xuuI4QwluLi9A0rgM2+it4q4fiMlMMszFiChNi4kq3NXv2dVcbF9mXjnUP/
         pu3A==
X-Forwarded-Encrypted: i=1; AKwUvBzVvR8o2V3IgDb3DSBwjjyJ2QWMgxendU+m9YXFShum0CWCaweu84fYWk38owwjFJj9arGHOjr5rg==@kvack.org
X-Gm-Message-State: AFq9FYK1RXtOu8CRfuX3M00+KM6ZhwCflR5Z/cjirUys2+wN5ZLQhuiV
	Tn/PK1FGDrDxEDCS4bWeWKkQi0s7kAR6tswk89cXmy49NtoyslsvPtjOohNGadsxnox17YeDeYV
	11fY3CZGr9rpfPLsNfSNr8rixgji9VaY=
X-Gm-Gg: AYBFou0XAc/dFU2F1zLI0J6PrL7tgj4F6zJ7s7DcppLae96gYD1/+EbDMlgMR2QQs06
	T/HYGrzMaENLSw8vr5M7QLx4200xYCdYkTfY//6zFqf8nhZW6LpnRTxYk/kvLxUmPNuzBdAl41m
	JGPRS3KNZUqGpfbGcl7JwWPFcJCX8uHPJIeZetjJY1fK71pEVXmMyTQ8HYPxYfu3sEh3LIzIbxN
	8i8GUyaVwniFvKHlfc1R8POSSObKfTirPnzxli2kKfiFLp/JOySyf5+FU3WKtbROXpI7TMLIsPG
	dfObeZXMoVq6LWMjzRlX7TXFl9L1q8jlSsJUYsZk1HqwBsGPU01eoEShs4vHuHvnryYAwhWOYkl
	DmxHzegDHF3hb+ANZz0Yxiaf3xLTd6Hg832D+KCJ/16U6hJRJXzP+WUC4BIL6BSB9j8dFkYE=
X-Received: by 2002:a05:600c:8219:b0:4a0:108:3b48 with SMTP id
 5b1f17b1804b1-4a1d760746amr7046915e9.7.1792167575523; Fri, 16 Oct 2026
 09:19:35 -0700 (PDT)
MIME-Version: 1.0
References: <20261007153915.53429-1-alex@ghiti.fr>
In-Reply-To: <20261007153915.53429-1-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 16 Oct 2026 09:19:24 -0700
X-Gm-Features: AclHuK_qydqamMBdCBeNyLTJ-3vLIcUmGK3v6Myyg5hV89s6EoTGIQhr4IJjhWo
Message-ID: <CAKEwX=M6G3NPOrGJg7Sz68BDSjzrF4R-tTjcX07L9oZ0GK4Upw@mail.gmail.com>
Subject: Re: [PATCH v3] mm: bypass swap readahead for zswap
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, yosry@kernel.org, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	chengming.zhou@linux.dev, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, kasong@tencent.com, ryncsn@gmail.com, chrisl@kernel.org, 
	baohua@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3D7EE40004
X-Stat-Signature: kmfi579h9j8yuwkkqfrm41gphimn5hcf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792167577-494105
X-HE-Meta: U2FsdGVkX1+zfi0Zy5tUNHTmY0vVi9htaCsXfunGYd2LzXBcUBLur92ZQ0+hyq9P9mZ1tFoi6J2CzgCiKqU3Z2IKf59PHCE0+EnTMXtUgS5oCSiAnum+KhtrjfE3iyT5LlDtq3d552JrDQJSFSKFu+mkyknigG35RF8SMawJCMe+YZLc07ZSj1+YDWUHXxepdVZxHEzh+vw7yf5VNwj5C3edFL/5U3Pg8XbIXnes02SkarUw8aXn/BVXzNk84hRdkW22w7SsczDEEWyolgi2ygr/6HRF0LKqq+LaRKLVFDuCa1EoPRCmzp12iwD7rkSV2Ld+pcSDiipr3Al9Klu97pGktNdRiGKKsyQTZi6plhoHgRLgAIjgwjqQgaTkmrNq5rlu1+dnzFzg3NbBQNQHYideQv6+trU7AwfGhp8bL2Dng5wtzek6x5L7cEPtlLg1+HYy8QYuWx88yCKsa8XaaHV2AtvDJG5wMqIb4VBHByci+snasMRJgT9O52mTlO/96KdALRTplfjBCl3aPPO/5owtb8Uo2EeJG59IS7I8QhrbmIt4QJ0zt4VAorayHtt9rgi+3bdE6plOjX3SlSkXUjKS8wZMB4p/uL178bzQ+UYAdWyqXXWiLnb6Rjvt7BEXD2BetPPNanBj7UIupICXg+9KMnp1kHj/1q3vfG7GvWDvm3P5u3rKT4+YCfGu8I6EYfQkSk1Z6Lsa8yPhV74ux5Kcmqhm5AGP1u9VynFvxrkHVVgaWbmTOPuue6MYieETJQgF99DjQmY8BffUabsFBH/XF9ybzNFKJsL+quxLPTCevP4/lFW9nXo8+oAlxfFGQf9Lh84Di7HnqOwK+IS++AgUgre7x9TJv6iLlCyRzDjSMIW2mQqlZW8vPw0GjCfThpLmOXdZPDQe83jR2A7JHvceqCZyY2miJSkyRt7dKh4jGqBsDgFkWaK457b1pYkeswzvoKf9t6YcbHzHKpK
 DlS6KbkD
 nh5MFEP6QV6sT0JMM8qtd/ya6zdWcgvN5PHT/bQhjTjwWuU4FXHwEiJBK2ACct4kF7fBw7Cs5215DbLRQo6VpxcOQvJGEKW6z1q8mJa9QmbZZNsMdeGy8GDJaUq+Vn6EramiMDcsBt6G1utS1fscx7nwjiCFGbbxZ43lxFhdgCf9yTUE2GCSCBFZRFeRup+WdEDq9xqoQ/PtVrEffKkELUxEhJN5eLzXJ3st/TJ8MrwXq0QDpUZRf6mtLVszNEUZKwFH/YMWT1L7DrSYfBWky6cP4+Q8MpF5IwlJri+Bghzc/d/ES802q8gG6b7oLlR4CjXEP41FxFC8bPz9vVfioFJYXBiap3Ejd+RcDe5aEZLfFgPda4Sqd2J3fPphUD376EMiSgo0RcxXqyews44sIFJTxZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 7, 2026 at 8:39=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wrot=
e:
>
> Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
> device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahead.
>
> zswap is the same kind of in-memory, synchronous backend as zram, not a
> swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
> swapin_readahead().
>
> Here are the results from bypassing readahead for zswap too: it was
> measured with a kernel build (make -j16) in a memcg, zswap=3Dzstd, shrink=
er
> off, on Sapphire Rapids and 3 iterations.

Would there be regression with shrinker on, when we have mixed zswap
and disk swap backends?

>
>   768M memcg (sustained swap thrash):
>     metric                 mm-new    + bypass    delta
>     build time (s)          405.0       341.7    -15.6%
>     zswap-in (GB)            79.5        53.0     -33%
>     zswap-out (GB)          144.8       115.6     -20%
>     swap readahead (pages)  6.79M       0.45M     -93%
>     swap_ra hit (%)          72.1        89.9     +18pp
>
>   1G memcg (light pressure, build not memory-bound):
>     metric                 mm-new    + bypass    delta
>     build time (s)          177.7       176.0    ~same (no regression)
>     zswap-in (GB)            10.2         7.5     -26%
>     zswap-out (GB)           27.7        25.1      -9%
>     swap readahead (pages)  1.07M       0.08M     -93%
>     swap_ra hit (%)          68.6        87.2     +19pp
>
> Similar gains were observed on an AMD EPYC 7D13 host.
>
> The gain is from no longer prefetching pages that are pointless for an
> in-memory backend: readahead inflates anon residency and thrashes the
> page cache (file pages get evicted and re-read), lengthens each fault by
> synchronously (de)compressing a cluster of neighbours, and adds
> compression traffic when those extra pages are reclaimed.
>
> Bypassing swap readahead for zswap therefore makes sense.
>
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

Code looks solid to me otherwise! Nice job.

