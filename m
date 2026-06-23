Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2336CDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 18:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9643F6B0088; Tue, 23 Jun 2026 14:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9154A6B008A; Tue, 23 Jun 2026 14:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8055B6B008C; Tue, 23 Jun 2026 14:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5825E6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:56:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AADAFC277F
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:56:30 +0000 (UTC)
X-FDA: 84912083340.08.7FAFE65
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2F865180012
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:56:21 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782240981;
	b=Dzq5i9QOgn94D0xGJQpQ5e6DvNl2z0rYYlFJUzSwYNqLXPhHu5IfrhWdfumc64n1+OD81y
	fUVkcbdtX2okvfMpryRHoirK3LN7bwqEFWGTsgHsFiRU1PEXioS4zNcDyJWGzf/Vh8150O
	dJFPBE9x02G4/xKqNs0DcPP5Xrlsp34=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782240981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6J+ANK03VaN7rdpDI6tnomDHkaUzerJG7W4wHHMwOJo=;
	b=KM7zY7c5j92ndt1sRXVbg+6ko2smuofpgdtlxDkCTennT8XtKRVcYFvwp4gluqkbj4xJv0
	6jgPlBSskmOoEqcP9JI/c8a0FCCpanApEfJoTpHkzrPdZ8+fyC7jZo8XnUVtVaK7K1TVRQ
	QA1X+3nusGKGu/IZ16f9noS0dUq4rYU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NLAXnrnf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-48d3fe218f7so199817b6e.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782240980; x=1782845780; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6J+ANK03VaN7rdpDI6tnomDHkaUzerJG7W4wHHMwOJo=;
        b=NLAXnrnfiVLuyhHaaXZ+/yBRnlsp1Ugi98FQDqFOkog3CNhv+TKY/3bfoUdjkNjELx
         5MSmZj66/IqKS2WuNJfFqKeVQqQYwAjemKrgNH9IT/pczAFsQTn1U3jzX42aBcLZ3Z8y
         YoT96HYsNsrIsrP0PfnMsenTk3BLPFjqjRR0hx1icvj3UAzQMwo9b72ufsz0H7dmQoy9
         7bY6G1042l28/g38KOhG2Ney3zkcbNO9et3j2i2ASI8bA0ssIdy1KatS8Vyq/jwDIgrO
         kK6cxHBBavS+8XxxB4dBZnH/s+J0ucofXHkf5DTQwiSDcSR9VVQZ0QhCFlGBHynnkwjE
         XYLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782240980; x=1782845780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6J+ANK03VaN7rdpDI6tnomDHkaUzerJG7W4wHHMwOJo=;
        b=PMegFzaBWrLKJU8/oF7NufwfoEYJrFFeKxGWAv8TVR2doV7/lEKq2upK2fepSUbSSo
         rD/opCZWW9BikpS7J8QKJMuOjPPFughB1cDdWD3zzYRb+EGFqH2tayqEXYYuI2Ow7WE0
         tfTVNBOqcF1GIyz6JFfLd8GU+Qonzt+kKUqK1PpCVHlpWuAGoQ0KP10LJYKI9bCkle9Z
         ZouMntx274jJC8JiqxhIe67OQrsvaA8NC1u1lr/21/afn36xhmoS2+keb8trmmPIQhTe
         BgOZrYjgccA/EZ5K4QtzMXqyQIOlBcaUzLjKtnL1Z2FNUL866cZWVVmj+wBlwITncem7
         f+cw==
X-Forwarded-Encrypted: i=1; AFNElJ9zan0TNOWs7/xSwAvzsLnvuejf/hvK9PUfCMOm6GJg/v/3Jj20NKHDCIj8kiSGWz5ZJN3ObMOnJQ==@kvack.org
X-Gm-Message-State: AOJu0YwzUHH8A8yQJYaouwuWGgnAWmfsmeMIsfyMnRQ3qkmXXqh0St6S
	jBIbqbLO0Cl5AZOLiZk1BZkZTzw/M0rfcU5VtjdONj8IaAd6AJQf66/n
X-Gm-Gg: AfdE7cmpGiVJ7cjxzSjMtapz3ydx0rpXUsxc2/XZ9M/XNRJmI3LQyGAiKHSYOs+ds1k
	wHtRHoCIuTf0TPmtPqxD9l9j3qh+GM6WPpS/SyVtParJ21uJ5TtackcB0TK39RwghPzldvcDoRz
	duQvjffaA/iQy0bH7HNXsWWx/vD45LA+E6PaEwC/rLnL9gPRzwgBwUgXC52rBfza/R8NaYBFFw5
	O1accqpg+y+gJiH4Jvj5O69qKIGBAW+jhCp/gfK4YZDKcp7uwY5NC12Iu969tNQ4jPXlAxdawlq
	qya5gglKDlhhn4sJ+GWb/utoVkX0F0YraM3pOMm91Dk94ED8t935y74O9Vm3Nu4jVkl6kr3C5mK
	T/VpsQxQ8p47HG//L8BLh4xOKAe7ItZvuWhG0UptHS/VK6s2s9BjPtEfRxK828K26BY5s/07Dku
	nn1sK3KyrOV9pjjnKp8Gg7e5XnESWIzvEILkKNZk0vuA==
X-Received: by 2002:a05:6808:7008:b0:487:5613:1f with SMTP id 5614622812f47-4907a57addemr445b6e.27.1782240980141;
        Tue, 23 Jun 2026 11:56:20 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:e::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-48aec0e5e53sm6944307b6e.8.2026.06.23.11.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 11:56:19 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <her0gyugyu@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: Re: [PATCH v9 3/6] mm: memcontrol: add interface for swap tier selection
Date: Tue, 23 Jun 2026 11:56:17 -0700
Message-ID: <20260623185618.1488231-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAO9r8zOQQwDxmHGsRw_9k2eu6r=HU_HiXxbB4cbpwhc1GGgHOw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HE-Tag: 1782240981-792812
X-HE-Meta: U2FsdGVkX19DtZtqbcO1YDIqq7EHXLHcJ/ZABuVJGemRxwrU9YdKK1LPTuKWG8PKXP5q1DJHDIiz/o9ZLr6lLauoevlMMVTAMcpqUqGyCoIOCujPgVxrtmcEef53NXWlAmC+0ocfqKkjYShhLvS45D5chRYLDOKR5QVaB5KL8tFkbbR3bCLkkhDxX2K14/KWFVg1fTEXTx5PL+O+m0Tqv1m8ZZLVCrg9Z8vXXzk5x9gmzUtQ+Nml3lgbL1qlABeH3klLKze5lID+T05bC9Wr5bWZN+ATG+3LRmzlVu0snLtrUS1mhLIYQcitihvbSyc+PZxU8t2eZB79WV/2mfSFGiLY0NqT1RRrp6hrbWVeQo+8aN9qp6Nc6S+8cBLqAFJd1UEVeQ1N0HzCW0AlBNQYqnGRoVSKUvrce/wT1T4nPnNRAPIALBhNOwM5KRXHzZb/dEizAoS6yy+a8AJ89mWnp/+W7NxOmrnX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 11:10:32 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> > To get back to the question of how the auto-tuning should work, the
> > main question is to which ratio we scale the swap limits to.
> > Do we set the swap limits proportional to how much swap is present
> > in the system, or how much swap is available to the cgroup?
> >
> > So if we have 3 swap tiers A, B, C, with 50G, 30G, and 20G capacity
> > respectively, how much should a cgroup with swap.max = 10G have if
> > it is limited to tiers A and B?
> >
> > This is what I was getting at earlier when I said we have to calculate
> > different ratios for different cgroups, based on what tiers they have
> > access to.
> 
> That's a good question. I think the case that is particularly
> interesting is whether or not the limits of other tiers should change
> when another tier is disabled/enabled.
> 
> So basically in your example, assuming everything starts as "max",
> when swap.max is set to 10G, the autoscaled limits would be: (tier A,
> 5G), (tier B, 3G), (tier C, 2G). Now the question becomes, if
> userspace sets the limit of tier C to 0, should the limits for tiers A
> and B change?
> 
> On one hand, it's simpler to just keep the autoscaled limits unchanged
> in this case. However, this means that the effective swap limit is now
> 8G, which is not great :/
> 
> The alternative is to recalculate all the limits when one of them
> changes, in which case the limits of A and B would change to 6.25G and
> 3.75G. But I don't know if this will work well if we allow custom
> limits. What happens if the limit of tier C is written as 1 (or 4096)
> instead of 0? It's effectively the same scenario, but the tier is
> technically allowed.

I think the one problem with this is that it becomes quite easy to
accidentally overcommit. As a toy example, if you have 10 workloads and
100G swap (as in the example I gave above), intuitively setting
swap.max = 10G for all 10 workloads shouldn't ever cause any contention
on capacity. But if you start excluding some tiers from some workloads,
you actually get overcommitting on the tiers that can service the
most workloads.

I am not sure how concerning swap overcommit was, but at least in the
memory tiering scenario accidental overcommitting of toptier memory
seemed bad enough that I wanted to avoid the problem entirely.

> The more I think about it, the more I realize it may be best to drop
> the autoscaling thing. I imagine memory tiering might run into similar
> issues too :/

And that's why I didn't include opt-in/opt-out for any of the tiers;
if you have system-wide ratios, there's no need to change the ratios
at all, and as long as the sum of your memory.limit for each workload
is under the total capacity, all tiers will also not be overcommitted.

Now, all of these complications aside, I think we might be overthinking
a bit here : -) The auto-scaling should just provide some sort of
"reasonable" default, the users can always override the per-tier
limits if they are unhappy with the autoscaled values.

In fact, maybe it even makes sense to have sum of swap tier limits >
swap.max.

(I actually recall having a really similar discussion when I was working
on weighted interleave auto-tuning a year ago, on how weights should be
set when switching between manually-set limits and relying on
auto-scaled defaults [1]. I don't think there's a need to follow this
convention, but we should think about what the expected behavior should
be if a user manually sets a limit, but later wants to go back to
auto-scaling limits). 

Anyways, I think these are important questions. Youngjun, Nhat, Shakeel,
any thoughts from you all? : -)

[1] https://lore.kernel.org/all/8734hbiq7j.fsf@DESKTOP-5N7EMDA/

