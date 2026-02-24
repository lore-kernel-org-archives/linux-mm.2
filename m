Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70F6AF4BB65
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:54:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770256B0088; Tue, 24 Feb 2026 12:54:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C6B6B0089; Tue, 24 Feb 2026 12:54:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 625ED6B008A; Tue, 24 Feb 2026 12:54:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0DF6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:54:50 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03D3C1601C5
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:54:49 +0000 (UTC)
X-FDA: 84480100740.01.D7DA259
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2845414000A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:54:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NANhPXCH;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771955688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CS+j2puaAGsOcTjJlK5nBHRn9fQdF++IjhODBwlsIys=;
	b=sud818zK5IyCqMkb9DAWAybyvZDrr7fEdswdh9XI9JtxscY+XwksMrtlZXwp5N8tckqwPv
	his2Ru5pNOmrisbm85YoHzpAeUUvAzQWMKJQg7tKmHfn/NjlDjlA2ghKuQsWLji6tqPnOw
	KTx6nU3uEDdCS3eu7FkF8NaGu7ew9/I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771955688; a=rsa-sha256;
	cv=none;
	b=haFnGx1NzA2EWEvrZFtkTVqqw5aL9A3OU5dsdFg5QLnwAnimzop0UJK93leiy4s/Va1Dkj
	d6sCS8OWx2vw55ufo+X9kvKDDzDozMMKtaUvtogpD9iLuie5qFXufKOJEaggPy/jP17Emi
	KEzpoVj5b3ytzlBckH3xUkeAf8dEO14=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NANhPXCH;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d4c65d772cso5396621a34.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771955687; x=1772560487; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CS+j2puaAGsOcTjJlK5nBHRn9fQdF++IjhODBwlsIys=;
        b=NANhPXCH2fvFQ568MBhkJ+nvDgubxOXi0eIFLkAqmPxXF8gv/G+BY0QLiKwWiZDEiM
         LIv3tnKlbgVYnyx4VypFEA0zwtsN6PJS8061p6VZaHI9NJhm4U8xnDZqi8+WdJlNVADc
         vuqxP7Kfeh0Qo/yt/NCs8uC6YBenKMFR16DnA7TZVjOm/aDuBPp3tp38xfxbJjHNfZPC
         7e5yminl/hWxlelLKnfvgQPWCYi/+Arp0pSF+vakJnenF/nJEFOgie5lGJiV9tEQprC8
         H4ppogrdKUoykOQ0/5sl/qHCWUJ7hPqsl9dXrt9iABRl1FtpHXYSx5DC52WaPYcnRXOG
         DdQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771955687; x=1772560487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CS+j2puaAGsOcTjJlK5nBHRn9fQdF++IjhODBwlsIys=;
        b=Ef6qv6TZMZeFmzA0ONAK35FauAK35sG9fz5IPn+NcQQchrYYcZGLoQOXDHqUtLjPc4
         QEU0MmZ5SlY1chXJ0/BthIM0DwUMq7Pi8y9MWhZnPlZ/kV+9IshtchKAyzgYyt8u/UaZ
         1xr9fZW87mvwIaIajl+Wht7cyfBU23MIKSi9ljiXs1K147rE/E+bPNjUHFRr5atw6pdU
         bGR/l7rVbF41DJ+pwrWjc8mSVq5P8+k6YvePIQN1vmJf66ozJ9CJWCZqKigjVVeyspG7
         4M16xYbjDp/aCvN3ARHkS4rOVDyoJNREA5ZSprLXDraD2w3Z5Dai09y1TXXBVdvHzGkl
         BSAw==
X-Forwarded-Encrypted: i=1; AJvYcCUwq/wIJ+qgmmzR1/YBapBnA5KHT49/3Uxez0sECDIJhJH6uFAH/uGT1GyT3493WKEj36MmBQHMIw==@kvack.org
X-Gm-Message-State: AOJu0YyBkElxRgLEEvG0esQa8AUf1d8bhAvDNkaDmISmkL8UTiLZO+R2
	b2WprsL7QQTKFFfyyt+QyHKQ70KkAUyJhr7X+jsaAF+VO0nw38M9IWt+U34V/w==
X-Gm-Gg: ATEYQzyVQ/DfG094uDbu7CLX+LpTsalrQ/7hIE3ktXO1h/u8lm5de7OU3t4S6Cfp/ek
	iOtuEL8WhyBR+RpsH82ABL8CavcyvSS3Pbycur6F0MwkbMHK9yttLx1EKRdxx+ivfHVh2myMe1r
	N/TKAMsDBtkGx6+QYYJN4C0S9l0rAr8GBxX5+/USeY6meuGp29ifL0Us/C0CUAhmKKvvSnLleQz
	n7JYULJehqvekuGrXpM3yaPoT/Vxxm9zEMQzPUjXj7NINFYGL8dsS7h/DoV1HvUCcMJwzu3UV2G
	2pUoXyeDLgG+nINUiNOk29dQJHzJYWLuXe2GWRtMeUR5b8whUL8O8EsLsbV0gavFn1VmIqy5jSi
	HYmzKTNE3xTJEnLBiyvq47MsRg40oO/ISMsbLVRC9I2ZeGVrZKs3GLAn+qc+IQf13TEAXLdhvEy
	8kF5itCB6p5tLcf0AZMJRfTzY3gSt4A63R
X-Received: by 2002:a05:6808:1b21:b0:45c:9936:10be with SMTP id 5614622812f47-46446387894mr6818660b6e.42.1771949639421;
        Tue, 24 Feb 2026 08:13:59 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4157d2d320fsm10358387fac.11.2026.02.24.08.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 08:13:58 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Gregory Price <gourry@gourry.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kaiyang Zhao <kaiyang2@cs.cmu.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/6] mm/memcontrol: Make memcg limits tier-aware
Date: Tue, 24 Feb 2026 08:13:56 -0800
Message-ID: <20260224161357.2622501-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aZ2LC0KPF0xsAwAL@tiehlicka>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2845414000A
X-Stat-Signature: q6unn6iwa9xnti34uibhriomprkb6mrt
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771955687-609482
X-HE-Meta: U2FsdGVkX18afpk3tQudM2kpbeGzK04ophX1xiRzQKwXpkWboHMqXlgV3T9j/5bUJyMlUxzbGwMaAVUEKgj0OIkDqAJrbdqLqHkIOOGdOHV0RM1S6/US1iJT5K9AQ3T8IyvGPGE1i6wJ9y4N9ERgeKZyl5ibONJohrck6BrHXVg1ka+P+C9lhzv2dUOBI9w9pe3KgBDJfRO4hcRzm7QcE2QV5TL3i6SrlzPiovtQp9gdW85v4ef0rCIWQA+FRKqS9BcTIma05+IaFWMogvGaADRJgebo7ER0S7BAuwkClJUfMB8aV1kSqeyLbnMdTUtzz4cu8LclKwK8JGmEGerCR4IghsJX4TB2fhJiskvse3x7YcOdiqt3rly+TuJI50NUNtFAc4Eqb3mMfht5eTv5y5gjn9gaVUI21H83IputgKCNDuDqrlrpCUrPDBMFzkRJi85uLHu+pA5Vzrfu3dt7juhz8BCcMzxvgrBidaOx7lG1oYynfBegL7n5InMdg946/Xnf6P9RnjmYDnHPKh+sDIjt2jwm4Mms/OvJk9u7p6xG4RyRfxZyccualB28Qnk84fOeBkRxapD4Sqr4IMN3vq4KbyShlAhTcPOiuFGyGQMFVfa5YL68e22vCNVvkSnIIYrPS65pN2QaqMzrfA+vBQ/1vOHA0kYCrUhCeiO3yvPU4GfIRRjSkW//65WmPSRC9bQbYGcBsgJLXWMAD5/TdwAGohJ9N4VB0pnKtVfGLPhQrwJJwqmOBQ8E/ee5nGTZHNhrVzOZSP7Hvyao1/0Pnpo30qDdgQzpSZejzw7G59cRRWZIc4gmaXTV2lZvYwl36saCw2laMPFN9xlXNZt0NqYFDiNPF2tKRes9l+Bb1QU8XbDed4UXQHGCZxQcu6fO6n5CGaBv4k6LXnKXk60ZqklyKrvJmYcb1G1NnwAuo0FA0S4VvWwN9yWaerr0g66cNqH/6QJKGIDWIiQIei6
 x6ZDPAxM
 jNbMyDFmGxdjyhbB2DH8/7g2fD1NRZ/ATP1AdqfAB98DZpjyL7DIqUAwBr4bYMo3cVOmCn1Z6OaK/TkRsGh5srm8cA5xRKFihKSGiJDL086BeZt/oJqyy3finv2c3YrzKEd3kWVrCd8cYz7hA2RRMmkwbR7dD9bXTjYsdgswC2rxzANNhQDFCGhkk/br0/QqG3Wbo8EcA38RALzAJGnga23KlG+7skkl+pQEjDl6pc1bVV/iBdDh9LSX/DTKqgDo1b+4HvaGZFHB6vs7oJyIeuRSau399QvOpBTyCwU8fONooHKVFpGruX/XKpECauj7uItFkvyMBQlxEXoQUOyo2UeSKopTzNeliB1rsSBfbZTLJJY0P8LbkF4mxOtLFNry4f2aSUumCn5kphH5AWmVOn1Vt7JH5Nc6srzx7OhW5v8E+KuSRd30Ov4IYPmUQ5ey2p00aubbNjNfIzmM2aPQXhnrexMLcmZi5EhD29wunOXcIF+P57FRadekzVRgdQjdUWme2gTK3TvhJJbdvGr7yt1j+JK/Bwf6eogUFwfE7q0p8cQp388uoGvHxSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Michal,

I hope that you are doing well! Thank you for taking the time to review my
work and leaving your thoughts.

I wanted to note that I hope to bring this discussion to LSFMMBPF as well,
to discuss what the scope of the project should be, what usecases there
are (as I will note below), how to make this scalable and sustainable
for the future, etc. I'll send out a topic proposal later today. I had
separated the series from the proposal because I imagined that this
series would go through many versions, so it would be helpful to have
the topic as a unified place for pre-conference discussions.

> > Memory cgroups provide an interface that allow multiple workloads on a
> > host to co-exist, and establish both weak and strong memory isolation
> > guarantees. For large servers and small embedded systems alike, memcgs
> > provide an effective way to provide a baseline quality of service for
> > protected workloads.
> > 
> > This works, because for the most part, all memory is equal (except for
> > zram / zswap). Restricting a cgroup's memory footprint restricts how
> > much it can hurt other workloads competing for memory. Likewise, setting
> > memory.low or memory.min limits can provide weak and strong guarantees
> > to the performance of a cgroup.
> > 
> > However, on systems with tiered memory (e.g. CXL / compressed memory),
> > the quality of service guarantees that memcg limits enforced become less
> > effective, as memcg has no awareness of the physical location of its
> > charged memory. In other words, a workload that is well-behaved within
> > its memcg limits may still be hurting the performance of other
> > well-behaving workloads on the system by hogging more than its
> > "fair share" of toptier memory.

I will split up your questions to answer them individually:

> This assumes that the active workingset size of all workloads doesn't
> fit into the top tier right?

Yes, for the scenario above, a workload that is violating its fair share
of toptier memory mostly hurts other workloads if the aggregate working
set size of all workloads exceeds the size of toptier memory.

> Otherwise promotions would make sure to that we have the most active
> memory in the top tier.

This is true. And for a lot of usecases, this is 100% the right thing to do.
However, with this patch I want to encourage a different perspective,
which is to think about things in a per-workload perspective, and not a
per-system perspective.

Having hot memory in high tiers and cold memory in low tiers is only
logical, since we increase the system's throughput and make the most
optimal choices for latency. However, what about systems that care about
objectives other than simply maximizing throughput?

In the original cover letter I offered an example of VM hosting services
that care less about maximizing host-wide throughput, but more on ensuring
a bottomline performance guarantee for all workloads running on the system.
For the users on these services, they don't care that the host their VM is
running on is maximizing throughput; rather, they care that their VM meets
the performance guarantees that their provider promised. If there is no
way to know or enforce which tier of memory their workload lands on, either
the bottomline guarantee becomes very underestimated, or users must deal
with a high variance in performance.

Here's another example: Let's say there is a host with multiple workloads,
each serving queries for a database. The host would like to guarantee the
lowest maximum latency possible, while maximizing the total throughput
of the system. Once again in this situation, without tier-aware memcg
limits the host can maximize throughput, but can only make severely
underestimated promises on the bottom line.

> Is this typical in real life configurations?

I would say so. I think that the two examples above are realistic
scenarios that cloud providers and hyperscalers might face on tiered systems.

> Or do you intend to limit memory consumption on particular tier even
> without an external pressure?

This is a great question, and one that I hope to discuss at LSFMMBPF
to see how people expect an interface like this to work.

Over the past few weeks, I have been discussing this idea during the
Linux Memory Hotness and Promotion biweekly calls with Gregory Price [1].
One of the proposals that we made there (but did not include in this
series) is the idea of "fixed" vs. "opportunistic" reclaim.

Fixed mode is what we have here -- start limiting toptier usage whenever
a workload goes above its fair slice of toptier.
Opportunistic mode would allow workloads to use more toptier memory than
its fair share, but only be restricted when toptier is pressured.

What do you think about these two options? For the stated goal of this
series, which is to help maximize the bottom line for workloads, fair
share seemed to make sense. Implementing opportunistic mode changes
on top of this work would most likely just be another sysctl.

> > Introduce tier-aware memcg limits, which scale memory.low/high to
> > reflect the ratio of toptier:total memory the cgroup has access.
> > 
> > Take the following scenario as an example:
> > On a host with 3:1 toptier:lowtier, say 150G toptier, and 50Glowtier,
> > setting a cgroup's limits to:
> > 	memory.min:  15G
> > 	memory.low:  20G
> > 	memory.high: 40G
> > 	memory.max:  50G
> > 
> > Will be enforced at the toptier as:
> > 	memory.min:          15G
> > 	memory.toptier_low:  15G (20 * 150/200)
> > 	memory.toptier_high: 30G (40 * 150/200)
> > 	memory.max:          50G

I will split up the following points to answer them individually as well:

> Let's spend some more time with the interface first.

That sounds good with me, my goal was to bring this out as an RFC patchset
so folks could look at the code and understand the motivation, and then send
out the LSFMMBPF topic proposal. In retrospect I think I should have done
it in the opposite order. I'm sorry if this caused any confusion.

> You seem to be focusing only on the top tier with this interface, right?
> Is this really the right way to go long term? What makes you believe that
> we do not really hit the same issue with other tiers as well?

Yes, that's right. I'm not sure if this is the right way to go long-term
(say, past the next 5 years). My thinking was that I can stick with doing
this for toptier vs. non-toptier memory for now, and deal with having
3+ tiers in the future, when we start to have systems with that many tiers.
AFAICT two-tiered systems are still ~relatively new, and I don't think
there are a lot of genuine usecases for enforcing mid-tier memory limits
as of now. Of course, I would be excited to learn about these usecases
and work this patchset to support them as well if anybody has them.

> Also do we want/need to duplicate all the limits for each/top tier?

Sorry, I'm not sure that I completely understood this question. Are you
referring to the case where we have multiple nodes in the toptier?
If so, then all of those nodes are treated the same, and don't have
unique limits. Or are you referring to the case where we have multiple
tiers in the toptier? If so, I hope the answer above can answer this too.

> What is the reasoning for the switch to be runtime sysctl rather than
> boot-time or cgroup mount option?

Good point : -) I don't think cgroup mount options are a good idea,
since this would mean that we can have a set of cgroups self-policing
their toptier usage, while another cgroup allocates memory unrestricted.
This would punish the self-policing cgroup and we would lose the benefit
of having a bottomline performance guarantee.

> I will likely have more questions but these are immediate ones after
> reading the cover. Please note I haven't really looked at the
> implementation yet. I really want to understand usecases and interface
> first.

That sounds good to me, thank you again for reviewing this work!
I hope you have a great day : -)
Joshua

[1] https://lore.kernel.org/linux-mm/c8bc2dce-d4ec-c16e-8df4-2624c48cfc06@google.com/

