Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F85BC5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 15:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24DEF6B008A; Wed, 19 Aug 2026 11:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 226CD6B0093; Wed, 19 Aug 2026 11:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163816B0095; Wed, 19 Aug 2026 11:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0F0B6B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 11:30:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C38C1602AD
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:30:58 +0000 (UTC)
X-FDA: 85118406996.07.6B326D2
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9DFC8180003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:30:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bkF3DWDT;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787153456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=73Guz/TIbEzOujSIckuYru9856ZGn+H/xGETeqkPBLw=;
	b=mk8cUED9y17jx6wo/ucBPPKeAsTFQZQm8o9MZn+3G7FhQVt4FECgbG06nL2eTvz5ud/lry
	Q0yXv8P/szOn4DzysR0Mb7YyUfcwp2NTggqtp3TzucfCaYVigD0IjTD+lHWjKeIkBLZdV5
	jqOvFsIlWkb7ThhNSIuQcAd1aYC8HGE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bkF3DWDT;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787153456;
	b=22A+CJeGnMZrNwpFgDsU8Ch9ndaOLDDt7y5tLsQdVHNNLaDEmihF5Rew06XSv5N2dRzyvZ
	L1FHv7FyLqWP6Etlj/VJ3DoDlcFMdwl5nC0DFecnLBo5LbYEA/kmNYnH2XoiLe3dEYXvn1
	lu7OAsX5U7+vEcueiNvNai247UegYVE=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8ff20870ac7so11704946d6.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787153455; x=1787758255; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=73Guz/TIbEzOujSIckuYru9856ZGn+H/xGETeqkPBLw=;
        b=bkF3DWDTQkXAL0SClFBdujazzqTaFkg7/aGT/j3m84yPpPZbzDYwegPvhjRrWF9n0s
         XHMhYFVUTnnLFab4PRMA3VcZLPw1M8/8ZhMq0A656c0jASvKIAWEbLp2dX/nUxcIIGsA
         257vGj5kegs14hDGcgwkrh2FqoCzaUcBIS/sBmPSMh7DdpgPKGlwgGqnSaITUsy/6K/p
         587R/7tmOjiYRsPMTWG75xnMYIfkcVaj13cdrnQqAu0qH8iNHINIONQzohjGpmNeV+sY
         qad9JVq2YuHWIKcb4lJOGe0nZUdQAL1v6dc9OtwJsLfogeiPPo01XhKU358hoxe9N8FC
         XUEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787153455; x=1787758255;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=73Guz/TIbEzOujSIckuYru9856ZGn+H/xGETeqkPBLw=;
        b=VdEOqHazgRhK2qRCP4xyxr+6h05oC4x7AeAlJbV5nwqkljkHLzywEQVx269fi+pglt
         5rVHS7xW8UBpHB0kDs3XrHM36Mx7Q4GjGMbAytPv6daZAKfDdrs7CtOJa+Ep7HjtU+ns
         ilIXyHx9SLhzMY/BETdVhy8PKtrvs5IgsQvvbLlUXPZ4dqbeTzOYBBYtmK+kgvd8MQvk
         KYbxm52zPL8CYWekaEBek/AqAVKuqtQRt+C/btecTmJtSgrm5Bqi5tPWD1ykRIpJ5Izc
         mPpmXNgojKGlFFyFLDxBPfgbmzB7WaDnNmFlwwIYmUqq/MADrRomhu0joA4qBReCZVtO
         YUNA==
X-Forwarded-Encrypted: i=1; AHgh+RrZNEhqtrW8y//2Dnn7cb3hEdRm2a5ghnBnPgbTJoU1qSbu/0xX1l2gTk5mzMEc3mIvJTqPm7ERtA==@kvack.org
X-Gm-Message-State: AFuF++m1Ty681ZW979dpBdjY9r2PLLzNP5Zwdaie7Lj51jUFK7uKi/K3
	xvTR5IEp5n/4IcFLb1mvWbrbdGody/U9gD2srP7zYtdJa+lulHYbq2sdtYhWmw52LpM=
X-Gm-Gg: AR+sD10AseDD2SRToy5w22OGu9Noi3SVnq1EGzbSis0C9NLefl3dP77pFbq0LlhMZTN
	PDHdBvElczEtJT05z2Ykgk6Mozae1f6L45RVPQPD3KrRAH0Bk+O6cBA9za8V4E3PoyeEeTVC8Rh
	6vG+O630v7reBCF+ib4f/ksQLEwqV+aA1/YDRwiwjZ+uFgHQCMX7YnC+HU4KF82Lo4vAeNTszDS
	ELdda5LJTE2S6U+O17dYbZte9cOUvksNlURXKDEbxz9tFo82c8sHTFtW4oz4YIo7Sxgsd6bouSo
	fxX/YoCt9aY8sGuGrEYvo+9ZFEEoT2Qre4ZWEKgat1JQvppF4vzY00XMyEHgVNztFvcV32z64LX
	D2TXdt9irlG6LTo9kOWJTxn5FqVAkVlnu/RL8GhJsPJN7YHzjflgKv4tbddLoZ2j3xkGAcJPZur
	rCgbiVormbaLGFf1O0qebGj6UWRdjaQEKHrQX3X4iYRywN/rQkf5oYe+viGzMWLB8gceD987bwt
	OUCjq/gP+8u0wHpBBuSE1J0lTToZJR078PMpdGu6cLTsOkcShYv9FNS
X-Received: by 2002:a05:6214:3217:b0:908:9045:217a with SMTP id 6a1803df08f44-90c5eaec0d3mr57812636d6.29.1787153455181;
        Wed, 19 Aug 2026 08:30:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5f2905d6sm16697626d6.29.2026.08.19.08.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 08:30:54 -0700 (PDT)
Date: Wed, 19 Aug 2026 11:30:53 -0400
From: Gregory Price <gourry@gourry.net>
To: liuqiqi@kylinos.cn
Cc: joshua.hahnjy@gmail.com, mhocko@suse.com, shakeel.butt@linux.dev, 
	linux-mm@kvack.org, tj@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] mm/memcontrol: introduce per-tier memory
 accounting and control
Message-ID: <aoW9roOicxJoCKCP@gourry-fedora-PF4VCD3F>
References: <20260818154954.805958-1-joshua.hahnjy@gmail.com>
 <20260819132211.366064-1-liuqiqi@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819132211.366064-1-liuqiqi@kylinos.cn>
X-Rspamd-Queue-Id: 9DFC8180003
X-Stat-Signature: xqgci8t8bmpfr5nu5y3wtw6ewnuxn7qf
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787153456-827977
X-HE-Meta: U2FsdGVkX1/dCNKaZEzUnfamKjKdF1o/gwumN69QAS3AZQfPQjj8Zx0Vpl3OdVr3wEdB6MsQL8m/64h8jMHXqGJpJ4huBtwn1J2UmF6SCFH6tOrz+BsOsqfATwLlAvBznnK+hG4wyHx3hMP1mROsbV/AjvQOz87fs0RNBo76XTDsoQot2brQIjsphrIsU0Ljr1bt34Ti3iQI4141JKqNEe5MmF5LnxaRFDZauDOyFUNeI+0h5wGpuyjJWrTMVeXjkuBmBO4HVJ6b3pU3pzpVZMKB6neEeFajwCyQ51lvscbfrvb0N1CnkVeE37+xxm7xYPPcYLuQIAofvpdeXPBqOsXLVPESVeV3Vru7pzsql474yYl2hz4H43xkRwoZ+gSWnu0tCzNczdkSzDxj2dlpG70KvzzFO8RaibHSp0wfXg+WFqtmw0P30d7pgnrxc9ktLSqZZVdBRSxuHhduwbbhsQmqIQZ3yyKrO2u5Nys8IoS9FivX/DMyVaVOrWtRzCIxbVSizJjJc+aJOvrxxkvezULhx6Sz7l6YzrRuiasw3QzhgQEPslySWDqne3YWEprhKU6F9f5EAIWc68FqqoTOBJd+jEpe7Iur8FeChXw4O73POYD0kWxugRs10/4/7fJQtwln7EKrmx9uHOWIW+psnltdlmG3Ex4GTwZnR1VJS8pTUGJZ2P+uAI7VsVRR7Gfre4qXFrWsa4ZeldxKFbT3/3kQNE/iexwljLTAXWpNWBwd9AcHg3j0ytbOM9IdtfR8Z+KMW6EbzMMMpl443p60l2byLDJ49gGHed8qPOQFrHVElGI3/YpMm5Lzyfgg0B2tGh/DU9KEQ3Pjo6PGXYJz8t3BOHWDiQSQYVC+/ZLFQ9Qep0RETN4TNaZ+bUQ8w7GtGHIeDSLdH/lpJR93stSoplXrB7B098zGJ2Rck7xrqMBJArq/8aR9muOAcETaDAIpTBJQ3+dtJPaK91bqr1g
 bgJUJorP
 PFKs2XG9UUKk2Cf3ZaZxuxlDot90BLE7zhPb7PsXMg2wTP1+V4XLEfyLRctLUR2jeb/sK4ZL8vsyNolywSDwq087+QNDoCwLkDOPBY7OApG+kZIlGr+YboJo7510bVXAmC6z8ipcHdLpC/5hcx5Q3YVx49ZG/MHCQQn00ekcsROU+K78o0HMd6THeEoAWj8vL0+z3DKK1HPkxCIxOVxvnjJmpO9rF8vUKux9rEyeRI03gkWUKbd2xKf/GvNW2lHfGavLAjbC8cnEPokWMLcV5rW5RGJIMwxH/BtZJODLSHRzU6pS4mkUMlK20npeDLIttASbe5dMF2Irdh6x99k1nluC5H3Sjze8b+l2ja+6Tmvl6M8ShfpZCv7qiXx1wOlxSWK1Bz2Q/cS8XCfafNhEOmNkUswyWvYKLKF7RcJGnvTyAQJw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 09:22:11PM +0800, liuqiqi@kylinos.cn wrote:
> From: Qiqi Liu <liuqiqi@kylinos.cn>
> 
> Hi all,

Hi! Thank you for following up.  A few things.

> 
> Thank you all for your replies. I am not very familiar with the
> community's workflow and should have reviewed the mailing list
> archives and existing implementations more carefully. I sincerely
> apologize for any inconvenience this may have caused.
> 

Less of an inconvience, we want to save you time as much as we want to
save the larger community's time.  Having multiple interested parties
vet common work - rather than propose differing solutions - does that.

Welcome to the discussion, glad to have more eyes on the problem!

Hopefully I can provide some context on the history here, since I've
been working with Joshua for a while on this in the background.

> My work is based on
> https://lore.kernel.org/all/20260528134212.240492-1-liuqiqi@kylinos.cn/

On this patch, It's not clear why an RCU-protected pointer is
unsuitable.  RCU is hot-path safe, it's just not stable nor
sleep-safe, which should be sufficient for any operation which
may be looking up this particular mapping.

These values are not expected to be aggressively written to, so RCU
essentially becomes a NOP on the reader side - it's extremely cheap.

More ideologically - adding a cached value of an RCU protected value
is somewhat anti-thetical to the entire purpose of using RCU in the
first place - it creates more footguns than it solves.

That aside, getting to the tier-aware memcg limits...

> aiming to develop memory tiering limits for cgroups. During
> development, I referenced Joshua's v2, but failed to notice that
> v3 had already been posted when I submitted my series.
> 
> I have studied Joshua's v3, and our core mechanisms are largely
> consistent. However, there are two differences:
> 
> 1. Read/write per-tier interface (memory.tier): each cgroup
>    tracks its memory usage by tier (e.g., DRAM, CXL), exposed
>    via a new memory.tier control file. This file reports
>    per-tier usage and accepts per-tier high (soft limit) and
>    max (hard limit) settings. By default, these limits are
>    automatically derived from memory.high/max based on each
>    tier's capacity ratio, but manual overrides are supported,
>    allowing administrators to constrain specific tiers on a
>    per-cgroup basis.
> 

There's two levels of operation we need to think about here:

1) What the kernel does by default without tuning
2) What the kernel enables admins to tune

If we don't have a cogent story around how #1 should occur for
this feature - then every knob you expose for #2 is just creating
a mess of tunables no one can possibly understand (let alone maintain).

That's why Joshua's series has no tunable knobs - any such knob is
simply unwarranted at this point.  (This decision was born from both
on-list and in-person feedback).

>    Its advantages are:
>    - It can express allocations that fixed capacity ratios
>      cannot.

Which should come from a use case born out of demonstrating fixed ratios
are actually insufficient and cannot be made to self-tune.

But we don't even have those yet.

>    - Latency-sensitive tenants can be given a larger share of
>      the fast tier.
>    - High-capacity tenants can have their soft limits removed
>      for the slow tier.
> 

These are the same issue as the first bullet, just differently shaped.

>    Whether or not to constrain a specific tier should be a
>    decision made by the administrator on a per-cgroup basis.

This is an opinion, not a fact, and should be based on data that
demonstrates the kernel is incapable of making the (or a) "right"
decision in a sufficiently common scenario.

> When the fast tier cannot accommodate the working sets of all
> workloads, it should be the administrator's scheduling decision to
> determine fast-tier allocations.

There's basically 3 use-cases that have been collected that I've seen
which tier-aware memcg looks to address:


1) Self-policed fairness

   Stiff per-tier limits that cgroups impose on themselves.
   i.e. proactively applying tier(memory.high/max) to ensure no
   container's tier(memory.min) is ever violated.

   This creates reduced variance in exchange for lower throughput.

   This is paradigm essentially does not exist today except via
   cpuset.mems (e.g. putting everything for a task on CXL). This
   is intended for things that want stronger QoS controls.

2) Opportunistic fairness

   While there is sufficient space on a higher tier, cgroups should
   be allowed to "over-use" the upper tier opportunistically to maximize
   thoughput - but when someone's tier(memory.min) is violated because
   another container is over-using, we nudge everyone toward fairness.

   This creates higher throughput in exchange for increase variance.

   This is milder modification to the existing global opportunistic
   behavior.  Think of it like trying to apply a soft memory QoS.

   It's unclear whether this actually has value, but can probably
   be accomplished via existing min/high/max, rather than needing new
   sysfs toggles.

3) Per-cgroup adjustable tier limits.

   A scheduler knows something about the workloads it wants to
   have custom tier limits per-workload.

   This should be seen as an evolution born out of finding where
   1 and 2 are insufficient.  It's putting the cart before the horse
   to go directly to this point.

   Very few of us are convinced such complexity is actually warranted,
   especially because the simpler (and less ABI-permanent) #1 and #2
   haven't even been fully explored.

> As Shakeel suggested, and given that Joshua's v3 already
> contains the core mechanism, I am dropping my current
> standalone patchset. I would like to ask if Joshua would be
> willing to collaborate with me on this, treating memory.tier
> as an extension to the patch series and proposing it as
> follow-up patches based on v3.
> 

Joshua can speak for himself, but more eyes and testing and data is
always welcome.

~Gregory

