Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97DC3CA5FC1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 08:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57D9C6B0088; Wed, 30 Sep 2026 04:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52E546B008A; Wed, 30 Sep 2026 04:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41CDD6B008C; Wed, 30 Sep 2026 04:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1B65D6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:34:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95A8A120736
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:34:10 +0000 (UTC)
X-FDA: 85269766260.20.D91165D
Received: from mail-ed2-f32.google.com (mail-ed2-f32.google.com [74.125.228.96])
	by imf24.hostedemail.com (Postfix) with ESMTP id ACEFB180006
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:34:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gt07SHc6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.96 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790757248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQBLg1lOxnEKgr89MFlKuWhU+DKGispKKqyorNYQTaM=;
	b=RUaG6+V+8MNfHAtABtVYBsenPGJUUmzN495W1eL2+brUX0DwrJgTM+K9+bf/gYLexlRmtD
	IEcfS4eBOBYp928ki4uTieUT8k0RKyw3mEoUZR1DIRCZckjEIyAnuzoMkK3gZzym84rFiS
	ZHCnmnYQcO1e7L3y9CK3pYv0J0Jnj/c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gt07SHc6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.96 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790757248;
	b=N72Vpp3FmlDuTzSeURdigBQOUYQ5XG8hyj4Jwamo3CjpMNjL1mTtt17OuLrAIi0dL5gvKx
	WaZNP14jtQhLt+VY9nRIORNh6g2+2XG/UVSrrwm2LJYYA6OSeBYaEsU6hHZNfkidzyhwAk
	8SzDjvkjzzNQ+1L8Yop94GJpbQunJgE=
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6acb6b726b5so2516987a12.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 01:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790757247; x=1791362047; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uQBLg1lOxnEKgr89MFlKuWhU+DKGispKKqyorNYQTaM=;
        b=gt07SHc65aiJockzaBKtRo2SJHAoLw3SIeINFEJFt1ZJvLdB28y8k5e8Aet/23wKts
         6WFX5sYJk5SUQYKruRXqlQWjwpNRv6jfHTseMsmS3ccI944pX5I/FpGOpWLV5Akwyc2w
         GddD5WfXb/LsXy/C5mTgeG6TiCfBGHmoVFX5AdiKRX1Phb99F7pPyJ6WoOXGqHZ1Gz0g
         lpSTXF7VHWwqf5nIfgsCS3Ppvk6QMjNRuG7wNmyJXe2tp5x5d0RRLKe9rLPTjqPBszRb
         r/AQKSECIrFKFzxx9WIFQhVp2QF/qdpfJYcVNHh+aPmAewPETtZUjy8pIp/HuJyuM8VZ
         yM+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790757247; x=1791362047;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=uQBLg1lOxnEKgr89MFlKuWhU+DKGispKKqyorNYQTaM=;
        b=sfJw1JogFkK7nktsdFj8utnxsew4PZRnWP8XuLXp88n+apYUx88KfeCeFA1V0B7AVD
         ijVPIv5sTMxaIfZbRKU+AxSj/+SVOC5EIg6+vG9k/Qm4uQezAvgfATPtUkDfWi2sCAYs
         sUNKpzL7ehQXPuXG0Xs1LZw/UkSG7RkkWTwOcIkrvlgnHCxitCnrwdxsIqOSHDKM+48h
         Qo9aZtm2YaTdAZY2sjDpT7RPwpF2HJjn60I6lhl7OQ4ggciMsdNLdI+sc18lIL9HNrnc
         XmAgfF5Jdq+a18PmQBb0ySsZGnaUa4qjvPUWMFUUkeGizjT4ww+hHhVrZ9l6t87a/K94
         aWcg==
X-Forwarded-Encrypted: i=1; AKwUvBzfnKm8POtHQru41DXl2lKzCzUlCHLwATSG73apzC0B3ct/8Rpc4AC7xp+w1TY5Ea4y7bhxHLDdKg==@kvack.org
X-Gm-Message-State: AFq9FYL6SwAw35bU3k2nJfsEVwlN9WqfX2SwkSluz7QovYxW2YJpkQaq
	EoMDbwLoWKOPI6mJEiDIZhu+EK9sQ3lk2QUgdvKuDx5UFQp4WMdxTMyr
X-Gm-Gg: AYBFou3tJF5zIWbPJwv+FMgePEViPZXUv5EUoilZwbRAizxUuNYFUgMGU/rEqPXhHgR
	sJazqedtpQ8z1Hr+Y5Sr2Sb/abuBUS0bW3pUK2NCUJmNVdHSz1Z2QZkMaSs0nn1LLZv2TSTDWRK
	YkN4cSQp2c9iPxVRpGi4IpxoLr+KRPvBmQQborlBznQ5OWcJl3gGdyga9YfWlFfqxO+xuNWq5mv
	AYncXs15XaVIdvSObl4RShfA6rwEazwUe6QIKTETJnyM1YgekaNVDoR/vEgTl0cX1482yX65CEb
	w5NGlOBCpHU5aY5umThtECqgqs+IfDYaw8RmNFNDWQHnvx3ZMqNdGm1FfJYdClo8tBRTsRDXT75
	mOVqcBH0RCZH/A0aVYNDAGI6ZQRKicabhsxgQl1MQZUo5d6IO+AI7WL4m7634D2sA3yAxTeip5/
	EDmSA4aBpo6a76stR3ZbweoqjNTDHE/90j/gBF
X-Received: by 2002:a17:907:3f18:b0:c2d:d89d:346a with SMTP id a640c23a62f3a-c2e23663b74mr51705266b.3.1790757246934;
        Wed, 30 Sep 2026 01:34:06 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e22fa41e8sm27570366b.55.2026.09.30.01.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 01:34:06 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Wed, 30 Sep 2026 10:34:03 +0200
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
	kasan-dev@googlegroups.com
Subject: Re: [PATCH v11 0/7] alloc_tag and module codetag section fixes
Message-ID: <arzJez4VNWEVnXiF@milan>
References: <20260929082014.160587-1-hao.ge@linux.dev>
 <20260929134401.a1a385ff4369661f879b5d2f@linux-foundation.org>
 <CAJuCfpFRW3uNUW_VrjpOfLwS1LBHqGEpqK3yBTPSpGOORY5jiQ@mail.gmail.com>
 <fc4f3d08-393f-43ed-934b-e7e1ba6d0137@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fc4f3d08-393f-43ed-934b-e7e1ba6d0137@linux.dev>
X-Rspam-User: 
X-Stat-Signature: c7c15p8cyi8qrnm9j5iiszhmqmcd9cdi
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ACEFB180006
X-HE-Tag: 1790757248-657453
X-HE-Meta: U2FsdGVkX1+NMA99dDkU6Z1V0j55L0/22uxWOonslDe87Eno54nCrQxxyk7wCT8W+uZd/mZmzGbZCxOLGyXpKNMw4lm8JAMrp4TjymclnsfVEOaB++ZQ1Eph2XVbqJIdXkTvmBhnmnh3YWEufr1WcPud/JLbuQN17A8xinfpzYAnRUKw+SScVifBmNFzyXN5t1/1fgBmzeLdpqm4k7Z8B+rfYd2Z0DmbXoqtqE4nH3WPdrt2mb9UBsTa+ePNPqQgnlHGJIjBr+qjytt+RRdAEHNM4QCiUYIZOpuePwhqOOP1rRBPWwZhgSIjmyfAFMPhyNLoAdOkG/NCeoMc18HkluS5fig1d3R/PHDTL5h35ELUdXzPnO5sWwTPmi2xMrjjip2HP+0f5+4FPboIXSUVwBj+0/eLIwLtN2OwIZSUfoLlCH+DmP8v1W39F3pqscpALVerUjNj08w2+kf6gWf7Yy4sq8DLrRPUJwqkFu0UOhGBY9NdbBKdWpJlzr8s4F33MSZwzytQeEAHxyGzR+bMVv4OWwI8A8uL+swwdLhY2OanbsyYLYpsZATbvhTCCDL4246pnabQLdL3IjGGVarDkSLCUBhP+soGZ/oha4+g+/vUzvEmTY0/zD4k/i5UU7L8Fr8dl+YzsdCPHudeLi8fRMvAMS+Icv+jmXZWRH8FKoIvmH2zLH6PkjrN7EXdbvH6VCneSJPR0vK8vRQQDAnR3DJ28Bol/KZg3eMRshV6GQSgYyeoQ085iA38GrzaIBiU/3tgpCWxtzDg4WRFGf6ZI0zrNTHz/J+HTe7f53KVHfZzqX8IhIcBKDVShq0CWtN7MTgEX6T+t4C4vkyJIzFJJL+iRpS2gL/RMM8R8h5XK8NRZoWpxCb6dVeUGrzF+uozlzUMswCfwoGn4vBHihO5nG4f5iMWXDNrDObxCSMI/7MF1Rw42nWk5ldJs1dbMyBq4Hv+aEKpsplWNlfm68X
 10HYqsin
 RNSXzyjWpbA/SUpPvRU5INLaZgpuexSCy47vqh7UDOpt8pIUGqa88LMVYHHyPz8A/54TZUMoOYDNump+mqqwnBAr2+A2KLXAKbpzh6D8/j5aAQY2jOMSOaDAi/PMLuP+g4+f2aCLH0jc746v7sUvJcquQUEAyiw9B8JgrhsYVFC4jLFF88obChxGnfVGV6tZTNfr/biZMouQ0/BTb0B0y7kYTkyU/STxwtQGV1TbXb67tONgWN3YjjS/VxyCEgAbvLT24aoxHvH6ytT1Ys9GEeDiZeu7CQ0Ee2mCz5FOLO6Jrxou28Lb6DAtzON83kCJofpG9Qgw1m83h4AP6bjdmrDH4xEjNJiRDUyIVpzeXbfpdFeLgRO7xb/EMTtMQV8zqaLzMC2FBsJ/cMV6iYPOtje0fQbibIKhuW0L8wmhZfwHcFrFM0TZvA1x4zrcmDDL900TVcoYNNCeVuxdGu+7Q2KrIeFunPqAspJqC7eHqzwmt/fTh2MY0lea85fON8YknKCjDj/7swBBnfhbg2QSgol/WkmAjo9dby59YM+ouFD9AbHdJKcCYfGZJFpIwDJzYYkA7WgeqHGsQmRbuohI7aGH6D2cYJ9MtrZIbkC1b1wpXpiXgIW3KOT1QtL/TaUmKRsa4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 11:26:41AM +0800, Hao Ge wrote:
> Hi Suren and Andrew
> 
> 
> On 2026/9/30 10:39, Suren Baghdasaryan wrote:
> > On Tue, Sep 29, 2026 at 8:44 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >>
> >> On Tue, 29 Sep 2026 16:20:07 +0800 Hao Ge <hao.ge@linux.dev> wrote:
> >>
> >>> With profiling toggled off, the overflow check in
> >>> reserve_module_tags() did not run, a module could load with more
> >>> tags than the page flags can address, and re-enabling profiling
> >>> then silently corrupted /proc/allocinfo. On overflow the fix shuts
> >>> profiling down, releases the reservation and returns -EAGAIN, and
> >>> the codetag section lands as regular module data in the same load,
> >>> so the module loads without profiling.
> >>>
> >>> Review of the earlier series by Sashiko turned up more problems.
> >>>
> >>> One is a race. layout_sections() and move_module() both asked
> >>> codetag_needs_module_section() where a codetag section goes, and
> >>> mem_profiling_support can change between the two calls, for instance
> >>> when another module load overflows the tag index and shuts profiling
> >>> down. move_module() then copied the codetag section to offset 0 of
> >>> its regular destination and clobbered the first section placed in
> >>> that region.
> >>>
> >>> v7 reworks where codetag sections are allocated, on a prototype by
> >>> Petr Pavlu [1]. The allocation runs before layout_sections() and the
> >>> placement is decided in one step, so nothing re-asks the question
> >>> and the race is gone. The retry is gone too, on -EAGAIN the section
> >>> is laid out as regular module data right in the same load.
> >>
> >> Thanks.
> >>
> >> Seven patches, all cc:stable.  Why is a backport proposed?
> >> Documentation/process/stable-kernel-rules.rst gives guidelines - does
> >> this series meet them?  Does Suren have thoughts?
> 
> Thanks, I've just gone through this carefully.
> 
> > 
> > I think vmalloc fix in patch#2 should be posted separately and clearly
> > quialifies for backporting as if fixes issues Hao found at [1].
> 
> Agreed. Patch #2 was added to this patch series because vm_module_tags_populate
> suffers from the same issue. If we want to be more conservative, I'd prefer to keep
> vm_module_tags_populate as it was in V10:
> https://lore.kernel.org/all/20260915070001.113559-3-hao.ge@linux.dev/
> 
> Then we can submit a fix for __GFP_NOFAIL retry loop in __vmalloc_area_node() as a hotfix together
> with our new patch #2. While at it, we can also check if there are any unnecessary calls to
> vunmap_range family functions that can be cleaned up now that patch #2 is applied.
> 
Yep, this should be a separate fix for vmalloc.

--
Uladzislau Rezki

