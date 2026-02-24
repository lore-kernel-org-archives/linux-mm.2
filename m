Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5526CE9B24D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A308A6B008C; Tue, 24 Feb 2026 06:27:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DE1C6B0092; Tue, 24 Feb 2026 06:27:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0186B0093; Tue, 24 Feb 2026 06:27:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 766616B008C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:27:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F4BFC1F88
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:27:13 +0000 (UTC)
X-FDA: 84479123946.19.57D2FAD
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0660B20008
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:27:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Q57f35vH;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771932431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4wckwVW0b3X1g/PGVWHQbxmb/kww/W4UTrCJT/v/yM=;
	b=8CER7SQplzzeJ5g4au/1r8njSXDYJhkWD8x78u0cs+6xoKwbwmSNdPvGYzFO02+KGOrwdn
	ge60WOaqhPbjTCTB4lfwCQHV3hhmiulrDE/iUh0uT++O1YQNPkGaeroPoHUystAZQFVC1s
	dZl3bGq5gpSK1LiuXvrdtH61GHdAX6k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Q57f35vH;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771932431; a=rsa-sha256;
	cv=none;
	b=PB4tw2vTnqPIKV+CNS695+qz+T2N+99zNRDxdGfArDXBY4UqM0/xQLNZ4lKiov3JkTTdiT
	jeIp6eh+HfWnNZtSW10qegxjtE4klJSFdcaHXXUmNlDMiL58ZE7Q69pd8sFgvfnQGZyZKU
	k8uw878eaXAAbkEYZ6F2CrPIbDbGm6c=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43984d7e49bso557997f8f.2
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771932429; x=1772537229; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e4wckwVW0b3X1g/PGVWHQbxmb/kww/W4UTrCJT/v/yM=;
        b=Q57f35vHoDFNoaXUDIleCz3zvI/onjSZJMbUW3uc5KvlM0f4YCpSh/DsKf2YUawR/q
         MV3gT+X+f0nEVvDuC9nlhBWu8puwGFkRInqdJkVrKOLkEPM3SOBJmPswNNviwnJuUkpl
         V+RN1BuIruI+kZih5G3lyB8dju/WLy8cvDnGKjygWII+2gxe0UoaUyqm4Cg5r41qAnoD
         0SYoo8dhansrVeWofEuRPTzSlPLK/C5uGRncGiaGfnlbyqDFFzhfpQHrIxGTfRVOS5pG
         MxzWGIcz93M6HhPLTGCfiqERhrPOuo8kdo7D8wdbAwnJtteWrEAAP+M56s8bYgscRR3x
         L28Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771932429; x=1772537229;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e4wckwVW0b3X1g/PGVWHQbxmb/kww/W4UTrCJT/v/yM=;
        b=AEcLoGUD62G9nVImoXjtAYgrjyOTS0vzzOKcd9Uqn4+/UbWBOX1WYzcbsioC5spt3E
         /6gsmCZRIFMAm8zRqB2/rq0NKp3o1x1RDHLfD5oEUMksTWzyot4g5TbtAayqToVOhNFi
         bTvwAQ3InBxT7StQkIys24uEg1TiK1myl2/M5Nre8VoFUGg/Y3Np6MMt5+HM9Xy6hRT0
         qMfT4slXMeHWY497ZVb7xgIRpO2MhbQPwJAqp6Uc7k6uUXICKdIyymUQRtyw/d2NtfnM
         QXQg+jGysKIiDJ+1i/5WhUDc7JMdhi9CGpmi/Dw2t8hDHcYTgvkcvVR13122I+MddTuZ
         OaJg==
X-Forwarded-Encrypted: i=1; AJvYcCUPKVc73Cke21/7yJFyyKJUAV3VRO6EiznhHnlV6emAFBFPjhNrBmv1PvbkETEEOEE660KbNX9zZg==@kvack.org
X-Gm-Message-State: AOJu0YwchC+RL63vwNlmwN9ixg4UkOMvj4Rp4m5fkdMzcZa1ySvfDlTm
	CfEs/iqcpGe8qx44sVro/EPSu74p7fPZceojn03LNXMXIAP7q1fPBV1mj2F66rp7rzY=
X-Gm-Gg: ATEYQzyhA/7oFyVKTZ0EDJE6CGbgZ+OpfxuI1eOtJeaATTi/iz5exOlnEoWHRJ9pC6W
	KfxUJHVcxGxTdX/GB+QGb8G7WnUZNPjZsR8XEYb+d+3BHWjN3Q1gF7sQqFzHqG0tdsFqx5xB+1b
	jEWfyNIzYZunP5MK3q8VUl5SEdE8IAYSeSPkRVWyI9VqeTihVYG49wTJz1B4vFGPcJRDEYf23uv
	OEi10VU1KX6H8h1LCoYGWxEWi0HOWfRsULgQKrLff9JJJZW6IUjdX4epKU1GW/5ZrTGMEW9ds8w
	5zIgNO5nDj/EvPA3V/EHwWyQbvGg/pY82FcY0zNwayOUmNeVIHqrfNr6i4SieQsNqxykWRqKj0b
	KwTZBPU4EpxJhS4ZtWX63pCIJCztEKKHQsUqR3NkHBeG8HijIq6fjB0RY782TTxXI7TnCgNb3jp
	1ytmvtoREcLhLZJcVaHVYr8PaNPOpiE8s=
X-Received: by 2002:a05:6000:26cb:b0:439:872f:b496 with SMTP id ffacd0b85a97d-439872fb5b4mr2656294f8f.59.1771932429230;
        Tue, 24 Feb 2026 03:27:09 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d4c977sm27358404f8f.32.2026.02.24.03.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 03:27:08 -0800 (PST)
Date: Tue, 24 Feb 2026 12:27:07 +0100
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>,
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
	Chen Ridong <chenridong@huaweicloud.com>, Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/6] mm/memcontrol: Make memcg limits tier-aware
Message-ID: <aZ2LC0KPF0xsAwAL@tiehlicka>
References: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0660B20008
X-Stat-Signature: bgc37q6urwxn6ffydt4xy4qgtjix317t
X-HE-Tag: 1771932430-66022
X-HE-Meta: U2FsdGVkX1/3Ny7oPuhB2mkJpGL9+mgP9Me3KlDmgl81hqIEEtCVeZ6WCql4jXuCmkCQBNGxDx1lRz8+tJYp/zNAIJZodGX25JeSlB+ju6uiQVbP5nUPI3ji/bpQ9NEQjV4/WXp5VMdpGXxNP8L4KVbecLUpLks43y3suZKY1oJTlSvd6iRqv+QHxbC+dHMYN7yVVXhRYTk4jzX8/MdhjZSFXlSRs3acG4blIc+rL2vxH3HKKShI5oAtyn38X0sSCLUMpUb+bcKIPjdmjVxxVsf1/s9vioBaGud2gzskO8i7u7OJ/9ZjyvFxPMoJay3lJbKnKkBLQfumdAl+09bvDGgdyt+k9iqq0fsH653yab58NdOe1OVMLE/vQ+NjzoDXZk5NO+TXJlZDD78Glly3VNvplGthSg1gtXISIry3ZcwSqNql3XXMU7uRvnyrs+aeBwHigP07l+6F599k3WcQO+Jn8fplzyXmPH/LhPkFdTxDMfFbgmrCnl8Cj1P5G4aXcS89afrDxpgbXwcQO7pkWfiyrDLJZa2K73iB9gcIDm7EPFqyYfBFccZHtcObzknGkCM3U8Yr8HrJb3uy9fY/qtRKFEs0uHgG9pHrA5UDHe1ROb/dr+cWKSZ0ckNBFXkyL5kOFUjOukn8PfbZ0sBXbYrssXplrmkpULvcIiQ8bLaJ/jDeqOVHxe1Dx2d1/N/EEUsyMMfHwWOxBrRzShy9ZfcZ1p4k7jMlWiWNg6TtBT6vcunRa4qFpsDaT9wNn+vUQqkXc48aVPsogD9mQRM9dUditJCDFfKSjOUempTK+/vBMW1/z+O3Q5nTRTYdflMKtB8nvS/ZvUsjfrxPCjjmn6oNR0fVlb15/ZWA723mHKRfLn+Cw7o7zbxuRmLwOizxmpUmHoPdoVkgOykYPax+DpU1iJPzoaSOzguXoJW7Khj7G4Py7tC3u5oOG2PzAMLLJCsVbubAzBhXv+ynnXy
 plGlbrRn
 82NKNFEDVT3cDF5L/6fJ7TDdEfmejTTxMI+o4EX7BXfV8jzCkSuTVQOHWHhLJETW6n31ve9ript/qVyml+wKZO9Gd7vbMcvOkH32negYb7xT21VYcjQBGWfuv6ip+Ja4wobtFEldZJwzWpXkfSlWW0SEKaS0yXW86Z8qkqmR0YCGVEGBGbD52FNg/LoYWLqJL4CFfbREjn447AWlUKy5RufZMNw4pznmWxdVr0N1w8Xw9tKqrQWhHOW9SdT75r40CVmvV0xSje4tLJZ/xnCNG259X+SF4kfbYIv8L+wO+5kwNy5D6uD2qQjOpAkocJCennS40uvoDPyeNY82mavL08DjLUpAPPcI0SNu4PlUPHis7omM8AfrlP9C+HBhOnypxokWTDmTaCMJPeE9rMk52XpysYauJU0QQ311CezZl0DSMOhA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 23-02-26 14:38:23, Joshua Hahn wrote:
> Memory cgroups provide an interface that allow multiple workloads on a
> host to co-exist, and establish both weak and strong memory isolation
> guarantees. For large servers and small embedded systems alike, memcgs
> provide an effective way to provide a baseline quality of service for
> protected workloads.
> 
> This works, because for the most part, all memory is equal (except for
> zram / zswap). Restricting a cgroup's memory footprint restricts how
> much it can hurt other workloads competing for memory. Likewise, setting
> memory.low or memory.min limits can provide weak and strong guarantees
> to the performance of a cgroup.
> 
> However, on systems with tiered memory (e.g. CXL / compressed memory),
> the quality of service guarantees that memcg limits enforced become less
> effective, as memcg has no awareness of the physical location of its
> charged memory. In other words, a workload that is well-behaved within
> its memcg limits may still be hurting the performance of other
> well-behaving workloads on the system by hogging more than its
> "fair share" of toptier memory.

This assumes that the active workingset size of all workloads doesn't
fit into the top tier right? Otherwise promotions would make sure to
that we have the most active memory in the top tier. Is this typical in
real life configurations?

Or do you intend to limit memory consumption on particular tier even
without an external pressure?

> Introduce tier-aware memcg limits, which scale memory.low/high to
> reflect the ratio of toptier:total memory the cgroup has access.
> 
> Take the following scenario as an example:
> On a host with 3:1 toptier:lowtier, say 150G toptier, and 50Glowtier,
> setting a cgroup's limits to:
> 	memory.min:  15G
> 	memory.low:  20G
> 	memory.high: 40G
> 	memory.max:  50G
> 
> Will be enforced at the toptier as:
> 	memory.min:          15G
> 	memory.toptier_low:  15G (20 * 150/200)
> 	memory.toptier_high: 30G (40 * 150/200)
> 	memory.max:          50G

Let's spend some more time with the interface first. You seem to be
focusing only on the top tier with this interface, right? Is this really the
right way to go long term? What makes you believe that we do not really
hit the same issue with other tiers as well? Also do we want/need to
duplicate all the limits for each/top tier? What is the reasoning for
the switch to be runtime sysctl rather than boot-time or cgroup mount
option?

I will likely have more questions but these are immediate ones after
reading the cover. Please note I haven't really looked at the
implementation yet. I really want to understand usecases and interface
first.
-- 
Michal Hocko
SUSE Labs

