Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA657FC590A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 08:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2586B0088; Thu, 26 Feb 2026 03:04:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46D3B6B0089; Thu, 26 Feb 2026 03:04:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31ACF6B008A; Thu, 26 Feb 2026 03:04:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1EACA6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:04:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A30F85BF08
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:04:48 +0000 (UTC)
X-FDA: 84485871456.05.91D37E5
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	by imf08.hostedemail.com (Postfix) with ESMTP id 74400160003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:04:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fsu+vlRc;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772093086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uS1xoFC20rI9dVkbD9ZqhHqbX9OMzBeyOLocK+DjeUM=;
	b=OxVP4WMSrq7XhJqU/BjD7gS1P0SKHchx50T8ciZTjPfBWt4oVplVoqag37MIkzb9/m1SMZ
	/XEdcDjV8XfkoFwK5GiQHgmXAw+T8NF/TgsrY2/6z10aex+1uNHNtfriJy17LmfbCTNBPD
	x/1PqxnJmfk9vKuh9pdYGaLlX926kA0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fsu+vlRc;
	spf=pass (imf08.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772093086; a=rsa-sha256;
	cv=none;
	b=wuKlyN2f8CQ7ts7qFDF1TucqKg2I68eHe63si822k/2yHdTzuQQzBvVR+/srB90zQl3HCl
	eEx/kWECMpFWiq02qREj/3aqrvFCBiPdXO0+mKinxGWAkWHJIRl4x7sRPJgrj3yCOXXXkR
	8wP4lpOZjsxftgZ94684pVn0NUponAI=
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-48372efa020so4259325e9.2
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772093085; x=1772697885; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uS1xoFC20rI9dVkbD9ZqhHqbX9OMzBeyOLocK+DjeUM=;
        b=fsu+vlRc8R7/irdqdl1trHcAuMWXMN6R9Wh/I6efah8rZL3psHsXbGwtcAsSdIZPSE
         aUISIiGmsqTdHfJ1uAxs9xD3fkcGerj3mv/MgoVmS80tpoOvJqlai/Jbk9goFJA37Eiw
         nt4g+02Qa09U0d13AIlth4U1cVl7uufc6DBAiaQbaAKvbWon+lIwgEfXrI5gclMA5sAv
         DShWFu6ue2p1Gmg1f0hAjaQuc3DTOp5rLio9wFB0MN+x/BzbQd1Lr+yVgGgiGKfIq/Xl
         e22bXDt30eHzqdGdTdHMp1aqzlidhjAramkVZm+yRVdHTNHIYm8uTgDUzI2MNPkMh7SU
         D9Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772093085; x=1772697885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uS1xoFC20rI9dVkbD9ZqhHqbX9OMzBeyOLocK+DjeUM=;
        b=C51nk1c4m3HO7hsfyEhZjoZVO0QXDjIqu9q263ZzaSD9lVQmpMBFSRXokcGAaOzzTm
         rWDNpJgF6VETJfI+XN+DlF1uqvnUbgYm/2kUrPssIsxhX8OZRXcCrWDHuH3jlJYFI2oR
         vLJ1XHipciwPuggTzuFOqEJ1Ez2OR7vPT3TcL11mm7m8ODS+1jicCG3iIrn1+obuI21e
         nFCcP1TemKqMEWkDyqQ0SVKLm+Bm4RvS7/YP2wAoj/WGkGSpgcNPBt3zO/4NXPwAxEs3
         b0xdFJxufZHAo5JpmPwAPuEOmZvOMrAB8nRlq0Rtlr7CR/O3hOhQuQ0meORajOEgpTSu
         GqDw==
X-Forwarded-Encrypted: i=1; AJvYcCV9NcxMpEwodfASFrBH6oXhiD808poDx7C7KftkvoVboyo5JEKVUjTyzo/dch2UjAzjOQwhBfH2Aw==@kvack.org
X-Gm-Message-State: AOJu0Yy/ZwnZnSzjEwiDDb47KSS3LCtDkK889TWvWjZGsy0WNJXFCcwH
	GNVLj/CbdMcqGV1P3JeVAKqiO3S3yrBk51yVOJW69qAu+0Rmb3JhRYGB8ZnwSVo6YYM=
X-Gm-Gg: ATEYQzx3mfcSdOM3LBgGoWQNLPtLaP62lSfHcnQQu1liKTVhF6EeiO0keHNwHvxGL6Y
	WmPQrpAHmRFfPJjGXGCe65ra2wWX5TdDn3rqAVw6j7a95JoXKHKlA0PcoVOquYMNXOd0NemEWB9
	iUieBigj9cEjHau1QRETIwReov/cg3+x+PpjptO0eSXjudtExKovRyGtb5kz3qa3yH3/5bkDbqd
	QiF8a3/UCEMrroynuKpGxbXEZdhTHqq5DX69vqHBnis5VLC2XonrRlg8TTQ/Hup3QXuS4FLqjtq
	hza1eHTfp3waqeRmOtD6i5/FQVCGPylHnkVrlVA9rp8e9/bwQy6UOk5exPbE4wYam59QmIZ43Lh
	LDPTaDUak8ZSSM3WVkcs95JpdoA1TIcczIVHRhVUK+t8cMOqhaMnoq5vdupcbaZVVRSzgbjOxtc
	otXw6KLL0JlH5V0wUgglgqRwNWMhI6wCauPQ==
X-Received: by 2002:a05:600c:c165:b0:47e:e952:86c9 with SMTP id 5b1f17b1804b1-483c2128cc2mr56475735e9.0.1772093084653;
        Thu, 26 Feb 2026 00:04:44 -0800 (PST)
Received: from localhost (109-81-17-39.rct.o2.cz. [109.81.17.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfccd7b6sm29626545e9.24.2026.02.26.00.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 00:04:44 -0800 (PST)
Date: Thu, 26 Feb 2026 09:04:43 +0100
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
Message-ID: <aZ_-m7vSUPrzDj4n@tiehlicka>
References: <aZ2LC0KPF0xsAwAL@tiehlicka>
 <20260224161357.2622501-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224161357.2622501-1-joshua.hahnjy@gmail.com>
X-Stat-Signature: nbci7p6hs6ipufcdfuztxigtcjjt5tp1
X-Rspam-User: 
X-Rspamd-Queue-Id: 74400160003
X-Rspamd-Server: rspam01
X-HE-Tag: 1772093086-833499
X-HE-Meta: U2FsdGVkX1+kXwoe76mU18ppGfLGXtCZINLQ8fwK2gsFe428k8J9RhF4cUEpVoKc7f7mUfjCMNV/qLSBMRmRvN/ngzczS9lwNBvSrd+W8LJ8IOJJfYupaWCtv47lQZkXPcWEDfJYkhMTOEsD2cgm4cGFM+ON7RzKHWKZF22b8KxHRT92yTvD2reczBSL+ViUOd0u5ir4zLYuNXtOg5nvH3AnYl2GpOdJWMmXrwxs07vdcXj58WeiIeo630lMzkUYpQejTOeo4CboW2jfgKk5rxUu6W2zfai22URar2U4bT4kc4fv0JqF5B/yqnBLgAQou/mLpwbswXVw2xt+vD+C0YhdhpMLF/FrhDKyZ/LW5ubwXtGXeYAFLXAo+G7CyRTqmS2BsQPzH295cnhMMQj6Z0O+9pKi0lCiNsddsKd0HncQyCb/rGP194z/FHai2EtQtosDsj/2+r4zaj4ELLC/41ZDaYw8ZkJn3JYg7zFcy7I0lH1jRirr33AiKilqFf3xhAHkuFKsfIa+Towsi55KvSuYSEze9Fb2Uj3se41BKbZRgykTIdnV5OimqXzFhrn0wT5gYikFCpC44QsVGluv4grqguEnKfDYuT6/eMHhQc5GWRKEqHhbu8asAO9uL8bjFCBBt8tlqxeNzYEGSKYuedW3DHAuDsz2BJ348P89vYEyVEbk7gze/6rfUfm261d/luGoPx0zZWJWp2SAnrRGoTgsRHU9SPIs3DeYeE4UiGwaELWlnmkXptzxhGBsPnNUJmIGMM+MdOxKrC3MRhbBskm0MfuMFdGwOZNVSdrGqsKJo5M9dc+HSbo4sBtx9XaT5IAhzEWiHmNykXWQHLOdl/QJpdjn95M26BGuQ5S9WDKde7hOQSweSHL+l2EN5eVFYjgcDHPpm7OpKbO3B2x5gXVP9V/shsxD1vpJPJWoguNHrb/jCz37XfQN0xndqGyHRoLw0V6DtMelNQiWsRY
 /8yyRYSO
 BNqOWRyZRnq3gzRGL6CP4bPWey7QSTbQ4Hvg1Y1MM55KOOB32f2QkM7ipICKaOfXIbPOkpvxyLZNIWp8HAh206vmlcefNGKkSaVH7JJtK7vwO2ddnHkTZi54r55LxL5gW2cVQTbj7j6rZmxbwuSoE1R0I1CzxDua68E3OfINdzEnWEci4Fkp58WIMOkbcv7w7qh8ePmv8adnFhpMyu+6K3+hKS5izS9YTN0+QzxPsB25Tb7jqD+0UY3/MwjdQDRNazSkg+a29fzwKgCmAI5cwrUXcu/ExBUk5K3mLUBPABkqp0LmUA0XrG2Sa4HFfdeFvICBSlFIRai9wwXEE1Fxszu5tNL7ntEaDdz9ZCIhW8RH4VOR9s7kX6kEaxvyVwFn/DivYFi3YuClgAoKru2/iuc4vv2wCQOcRL05J9g7RVCzwtu299d/2r3W+3G+3lu8qLyWKCi0JsMlm3hVyxpLfEn72aDOve3zwtnTsAhkGYygtuOF3WVNSosfdb1oHVTz4IQvKCACz6U5Df/Q6zFq5uyBRM82WJqgPguSKLmZ71WkI5qbvSkcDOrqtog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 24-02-26 08:13:56, Joshua Hahn wrote:
> Hello Michal,
> 
> I hope that you are doing well! Thank you for taking the time to review my
> work and leaving your thoughts.
> 
> I wanted to note that I hope to bring this discussion to LSFMMBPF as well,
> to discuss what the scope of the project should be, what usecases there
> are (as I will note below), how to make this scalable and sustainable
> for the future, etc. I'll send out a topic proposal later today. I had
> separated the series from the proposal because I imagined that this
> series would go through many versions, so it would be helpful to have
> the topic as a unified place for pre-conference discussions.

yes, this is a really good topic to bring to LSFMMBPF. I will not be
attending this year unfortunately but I will keep watching progress on
the this. I am really sure there will be people in the room that can
help with the discussion.

> > > Memory cgroups provide an interface that allow multiple workloads on a
> > > host to co-exist, and establish both weak and strong memory isolation
> > > guarantees. For large servers and small embedded systems alike, memcgs
> > > provide an effective way to provide a baseline quality of service for
> > > protected workloads.
> > > 
> > > This works, because for the most part, all memory is equal (except for
> > > zram / zswap). Restricting a cgroup's memory footprint restricts how
> > > much it can hurt other workloads competing for memory. Likewise, setting
> > > memory.low or memory.min limits can provide weak and strong guarantees
> > > to the performance of a cgroup.
> > > 
> > > However, on systems with tiered memory (e.g. CXL / compressed memory),
> > > the quality of service guarantees that memcg limits enforced become less
> > > effective, as memcg has no awareness of the physical location of its
> > > charged memory. In other words, a workload that is well-behaved within
> > > its memcg limits may still be hurting the performance of other
> > > well-behaving workloads on the system by hogging more than its
> > > "fair share" of toptier memory.
> 
> I will split up your questions to answer them individually:
> 
> > This assumes that the active workingset size of all workloads doesn't
> > fit into the top tier right?
> 
> Yes, for the scenario above, a workload that is violating its fair share
> of toptier memory mostly hurts other workloads if the aggregate working
> set size of all workloads exceeds the size of toptier memory.

I think it would be good to provide some more insight into how this is
supposed to work exactly. If the real working set size doesn't fit into
the top tier then I suspect we can expect quite a lot of disruption by
constant promotions and demotions, right. I guess what you would like to
achieve is to stop those from happening right? If that is the case then
how exactly do you envision to configure the workload. Do you cap the
each workload with max/high limits? Or do you want to rely on the
low/min limits to protect workloads you care about. Or both? How does
that play with promotion side of things.

> > Otherwise promotions would make sure to that we have the most active
> > memory in the top tier.
> 
> This is true. And for a lot of usecases, this is 100% the right thing to do.
> However, with this patch I want to encourage a different perspective,
> which is to think about things in a per-workload perspective, and not a
> per-system perspective.
> 
> Having hot memory in high tiers and cold memory in low tiers is only
> logical, since we increase the system's throughput and make the most
> optimal choices for latency. However, what about systems that care about
> objectives other than simply maximizing throughput?
> 
> In the original cover letter I offered an example of VM hosting services
> that care less about maximizing host-wide throughput, but more on ensuring
> a bottomline performance guarantee for all workloads running on the system.
> For the users on these services, they don't care that the host their VM is
> running on is maximizing throughput; rather, they care that their VM meets
> the performance guarantees that their provider promised. If there is no
> way to know or enforce which tier of memory their workload lands on, either
> the bottomline guarantee becomes very underestimated, or users must deal
> with a high variance in performance.
> 
> Here's another example: Let's say there is a host with multiple workloads,
> each serving queries for a database. The host would like to guarantee the
> lowest maximum latency possible, while maximizing the total throughput
> of the system. Once again in this situation, without tier-aware memcg
> limits the host can maximize throughput, but can only make severely
> underestimated promises on the bottom line.

Thanks useful examples. And it would be really great to provide an
example of intended configuration (no specific numbers but something to
demonstrate the intention). Because this will not be just about limits,
right. It would require more tweaks to the system - at least numa
balancing (promotions) to be controlled in some way AFAICS.

> > Is this typical in real life configurations?
> 
> I would say so. I think that the two examples above are realistic
> scenarios that cloud providers and hyperscalers might face on tiered systems.
> 
> > Or do you intend to limit memory consumption on particular tier even
> > without an external pressure?
> 
> This is a great question, and one that I hope to discuss at LSFMMBPF
> to see how people expect an interface like this to work.
> 
> Over the past few weeks, I have been discussing this idea during the
> Linux Memory Hotness and Promotion biweekly calls with Gregory Price [1].
> One of the proposals that we made there (but did not include in this
> series) is the idea of "fixed" vs. "opportunistic" reclaim.
> 
> Fixed mode is what we have here -- start limiting toptier usage whenever
> a workload goes above its fair slice of toptier.
> Opportunistic mode would allow workloads to use more toptier memory than
> its fair share, but only be restricted when toptier is pressured.
> 
> What do you think about these two options? For the stated goal of this
> series, which is to help maximize the bottom line for workloads, fair
> share seemed to make sense. Implementing opportunistic mode changes
> on top of this work would most likely just be another sysctl.

To me it would sounds like the distinction between max/high vs. low/min
reclaim.

[...]
> > You seem to be focusing only on the top tier with this interface, right?
> > Is this really the right way to go long term? What makes you believe that
> > we do not really hit the same issue with other tiers as well?
> 
> Yes, that's right. I'm not sure if this is the right way to go long-term
> (say, past the next 5 years). My thinking was that I can stick with doing
> this for toptier vs. non-toptier memory for now, and deal with having
> 3+ tiers in the future, when we start to have systems with that many tiers.
> AFAICT two-tiered systems are still ~relatively new, and I don't think
> there are a lot of genuine usecases for enforcing mid-tier memory limits
> as of now. Of course, I would be excited to learn about these usecases
> and work this patchset to support them as well if anybody has them.

I guess a more fundamental question is whether this need to replicate
all limits for tiers or whether we can get an extension that would
control tier behavior for existing ones. In other words can we define
which proportion of the max/high resp. low/min limits are reserved for
each tier? Is that feasible? I do not have answer to that myself at this
stage TBH.

[...]
> > What is the reasoning for the switch to be runtime sysctl rather than
> > boot-time or cgroup mount option?
> 
> Good point : -) I don't think cgroup mount options are a good idea,
> since this would mean that we can have a set of cgroups self-policing
> their toptier usage, while another cgroup allocates memory unrestricted.
> This would punish the self-policing cgroup and we would lose the benefit
> of having a bottomline performance guarantee.

I do not follow. cgroup mount option would apply to all cgroups. In
sense whatever is achievable by sysctl should apply to kernel cmdline or
mount option. The question is what is the best fit AFAICS.
 
> > I will likely have more questions but these are immediate ones after
> > reading the cover. Please note I haven't really looked at the
> > implementation yet. I really want to understand usecases and interface
> > first.
> 
> That sounds good to me, thank you again for reviewing this work!
> I hope you have a great day : -)
> Joshua
> 
> [1] https://lore.kernel.org/linux-mm/c8bc2dce-d4ec-c16e-8df4-2624c48cfc06@google.com/

-- 
Michal Hocko
SUSE Labs

