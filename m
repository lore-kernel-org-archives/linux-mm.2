Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36C1DCFD370
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 12:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB2C6B000D; Tue, 25 Nov 2025 07:13:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7923C6B0011; Tue, 25 Nov 2025 07:13:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A75D6B002B; Tue, 25 Nov 2025 07:13:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 593446B000D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:13:06 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A4B91A06E6
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:13:04 +0000 (UTC)
X-FDA: 84149018688.21.899A159
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	by imf20.hostedemail.com (Postfix) with ESMTP id EA54B1C000D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 12:13:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=e+curw0D;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764072782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxJGiJOjFGbJrN6TdFxredys8Cq/gwxxT5DnbpdfeGc=;
	b=yv++DMEwDo2J+sVC9hp5s+oTNKcMXPv3GHmZLx3yKhosgJ6Ur1HTPrXEJwP15WOIrodd0d
	IBH3uxOVTi19lQwJ1g5RXMG97MIxYvtt+M7V317bVoSuHqH9SAZm+gU2lucxcWfCPLpBMy
	BCRfjeJzd9ICU6CbulVAQS98sekZrZ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764072782; a=rsa-sha256;
	cv=none;
	b=39fodw/0IMFBq8Xv22TetsdCC0WeUhyNkTwwrrZGtB8koD4V+22mbYwJ75ZOq4x32sNBfP
	Wxuxiuuo9ulKG+gBomSu+zqhQZ1HeXZ45zbKZIMDPW23gw5J5zwpwlLyL2NZcfYA8/yHQe
	M33/vqajvQp6PEeTAKN4pFjFjNmq33U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=e+curw0D;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-477a219dbcaso49157995e9.3
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 04:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764072780; x=1764677580; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dxJGiJOjFGbJrN6TdFxredys8Cq/gwxxT5DnbpdfeGc=;
        b=e+curw0D1ndv8cD8XdW/+8nSHLF/TqbBmih6eFnn0vw/EZnYmUGbJ9c8liJupVPXJz
         JvRacfUY51eJPK7cJ70qh1dZ1aGlcoERz9E/ERaT8DUwIyssTjEbycI6YqIAZyoXst0y
         zLYXcZ/A6Fha7lA4NCt2DhNDt01Ex7N51sq01W4dKoazlLhPwzZeIyIg4uFsubB5dDnu
         8IXT2VWYjZM8KfKZcsYjrlK21Xcx2JdiNK+KXdCZTt31RAmwW4+NRXefjq+GAIMISMO8
         GTH/+mwmL+drk8wOL0tjjaQyymxGx5OHIpngCVz65CIEHMLeCsPhuKOKC5f8b5aTYqbU
         EKdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764072780; x=1764677580;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dxJGiJOjFGbJrN6TdFxredys8Cq/gwxxT5DnbpdfeGc=;
        b=lwONSEozdXHyOvnBQbWXX0TItVFTEDXFrSvDIFYvKL92vOx6RV+s3uhZaPzhCphK3E
         kb/A8+YGk27alS4GqAbIGuxazYq7rmSPFmE1RqGIctVyjLsdVpfbqxIDLrmNwZfar3sQ
         Kj/IpXVsUqnyVtW358NPe0YCxhp8ykwpLxWaCua+PHUPpLKZOFTEvIlO8cKHGD4mWvCZ
         Fmq1Zi0V1oml7hzgEkbFoWi6UFFTap2ZFPwsdYmDgMugrZ/nyW7GuGefybqTLbVnYBBO
         WRJtAFAqTjgTy6Slpiw1aY6fyTjeTNPgPK+y5VG3lV6AsaF1W178fu8ojyy5LU1eXPYX
         qn+A==
X-Forwarded-Encrypted: i=1; AJvYcCV+QcX1+xjGz+5Sy9Zn6p8LEUiQ8f4xidI2SBKE73MAjKrA8rudXiWglzNymcLCDQz/BaqL3nksrA==@kvack.org
X-Gm-Message-State: AOJu0YxLLA2lrSfoQwz+VL2aBAdcGQBsYW8TnT7uM5FHeBRDrXBmA04C
	2t5iMTy4Bnl2mjAb/OpjRohER2CXlk2rT8qJCFqJ/7WN96Csk243yPdsNlGVH2Gv/eI=
X-Gm-Gg: ASbGncuEqAKUjITb+f/eqsjxm8Jc7gvQDdJ92xeJjGzQYOPuryipb9TSpTz0gsbFx4k
	6HwKqh9aJhMwgFm27/v6W/K3X8bVj21gh5NLy1LPxZp5sYXHedghZYX62zpjiuA4VxJTzaZGn3r
	GNG0GnFsCSkgJ6kheNtDElVPpL7iqFPWuCvW3HU/xiOuNSmyS6VZCgbZHkXfovuFPQZX5qXejEg
	j+Ey0ZnAeZ0cS2wyVlq7MuyQltx3+gsCpFcv8iwXmktSV242tVuC+epTTQiIWhcPEBLye+6S5Wk
	OQ7+Zcz5DErfLfe6W2b4gpu1gD+CHHPvmcsA5z7r6vRzd8YbNjJghg13Mpb2M1PL3p7/9RZePp3
	AOC+OwVJlKXi32j7nLySPFf6KCU4t/OKk4ZC6eA8k8mWT4uB9A8xbwAJaxoVGChxdkF/D9BqSz3
	PASTO6EwUZBS6T48mU8pN7ukAF
X-Google-Smtp-Source: AGHT+IEV2rB8yUe2NCUZIw4moQNsZpTQgAmZgRSSfaXojAIWU3YqaEOZQPUbkzKEE+rrVogbayao5A==
X-Received: by 2002:a05:6000:22ca:b0:42b:30a6:9c10 with SMTP id ffacd0b85a97d-42cc1d22e12mr16592650f8f.56.1764072780019;
        Tue, 25 Nov 2025 04:13:00 -0800 (PST)
Received: from localhost (109-81-29-251.rct.o2.cz. [109.81.29.251])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fa3a81sm34815638f8f.26.2025.11.25.04.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 04:12:59 -0800 (PST)
Date: Tue, 25 Nov 2025 13:12:58 +0100
From: Michal Hocko <mhocko@suse.com>
To: hui.zhu@linux.dev
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>, Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com, Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] Memory Controller eBPF support
Message-ID: <aSWdSlhU3acQ9Rq1@tiehlicka>
References: <cover.1763457705.git.zhuhui@kylinos.cn>
 <87ldk1mmk3.fsf@linux.dev>
 <895f996653b3385e72763d5b35ccd993b07c6125@linux.dev>
 <aR9p8n3VzpNHdPFw@tiehlicka>
 <f5c4c443f8ba855d329a180a6816fc259eb8dfca@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f5c4c443f8ba855d329a180a6816fc259eb8dfca@linux.dev>
X-Stat-Signature: tozwm9oz7dqpj7a9a4jora8756rxgyci
X-Rspam-User: 
X-Rspamd-Queue-Id: EA54B1C000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1764072781-916698
X-HE-Meta: U2FsdGVkX1+ppbR6kY6EJ4BpzA50N699ErZM7vrby1W4bb4Cq04tu5GFaDiciv/zFiiHy5WkhQNSEInPpy+to0HWoEhroa1BxkCxa60Pk0/AQKFMuSy9tJbRJzYP57HfPZ7hXZ1n75zdDM7o8DXUrK0mrzHTmbGjicl1r2rK7P0uc618HAjdKfMZ7srKIyVPzjmDAt5RNKeNrg+NmsGKs2xtM3XmLzpnVKFpac9bcAiSsoaYm7Ar/iH1UtIRfiHhgM1YhlIdSJd+9VM38BMNcXzeEmyVOmiNIujdZ6mR8VL4eFGW8Z7CZ3Ym6SNnT258LKe36LNm+DbJBQ2btj7Xe6MTwO1+cBl24Y4CtVMpScc7GkGHQKwviXZnjsiIyrMt3i/PaqFqOfP5h8YRjc2GkOTM2PUdQe5zFC+4QAPOGvBkdGvQmSO2u6FIOOqlNU8vXN3gj6c95c+edj69M1S4uioIcuJE0766ZoZ9IxudpIlbkkN32FSzld7+97n2rOekFxLhENu4z8QipIwSiFCBcFQ6j0XY1OpcCCUDqA36R5wGfQE+tRRl2xa0Hlq7bKIi1HmVOJr1SfKnNo2xA/5aI/mqFYpGtZ/ffYWIGNuloFysR9vncH/5odCoHML/KuuL2gJ95xpLBJbsL5NUxO02je8TUhxu8cxNmuI3Fjl3B1LpyReosk4G4UhAv89m4HFc0s9oZNjnkzvC69erKRUDy8g4xFEP4JmT6A/kcuS3pRvwnyFdfUuvjLdS7HNpCFwO0Cezj1V0HcOsyN7w+RtDKRNFiwgImkHdFnseN+6ueGYpFW0wgLynt0g9S28lQEbc+CU28A+fQWGw8ab8rZzZ/6O4eE8Agmd8Ol59Bsrncqb6eKZhMBtJ0cFuiGelLF2T4UjxV+kTNGLamHZ+WexUH/N2AAyuGpeUuRwnJA/AcYqr2bO+1NtttbRkoUwCoHvVH9mAbdtIzDs4xnDv93/
 HXgI0/Mu
 Sblq45MBVb6Kjc9C7YieJfLoVD41frPzKmyqTu2TPDVA2Z67Gxj8GyykepAKaPgqjPD0Hfy5hw+emSgE2GW+d5u3l4LlSF0BE3APHirNDC9160O6IQiTRIg1nKDBifoBmYHGZD4fcgx/jdPvPLtQHR6j6LIVQnaTw0CcfiLE/Nn+wOtmHH/PSc7CPXlT97xlS0sSN0aWET1kNUWBwBQxE531zyI3c3dO7KC2mvKwniy/05eLtUKk28wyiVXeALXjYHp0Q2UcUec1mwysXHBWK8jjN4PHNVewPMZl0Uo8P2wR4EpsXQk9Dpcwo1swzzc/4wSgNySPCLJbalqwHtJ8eN99Vt+iCawlDzl9hlugX6LzJCDmigxsjTqcPtZnQXZLWn9XCD2KkkYZ8nvIzY+mujQEDQxigy3L0kBd46uRwcNWDx/Semv+bc3dgFUg5gYYrB46xUZ5HsDoK94ERCUnW7ec6nRMcVSHHWcq9T8jHQuzblYDxcaNlStU2Zcr1dtDQ2ci1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 21-11-25 02:46:31, hui.zhu@linux.dev wrote:
> 2025年11月21日 03:20, "Michal Hocko" <mhocko@suse.com mailto:mhocko@suse.com?to=%22Michal%20Hocko%22%20%3Cmhocko%40suse.com%3E > 写到:
> 
> 
> > 
> > On Thu 20-11-25 09:29:52, hui.zhu@linux.dev wrote:
> > [...]
> > 
> > > 
> > > I generally agree with an idea to use BPF for various memcg-related
> > >  policies, but I'm not sure how specific callbacks can be used in
> > >  practice.
> > >  
> > >  Hi Roman,
> > >  
> > >  Following are some ideas that can use ebpf memcg:
> > >  
> > >  Priority‑Based Reclaim and Limits in Multi‑Tenant Environments:
> > >  On a single machine with multiple tenants / namespaces / containers,
> > >  under memory pressure it’s hard to decide “who should be squeezed first”
> > >  with static policies baked into the kernel.
> > >  Assign a BPF profile to each tenant’s memcg:
> > >  Under high global pressure, BPF can decide:
> > >  Which memcgs’ memory.high should be raised (delaying reclaim),
> > >  Which memcgs should be scanned and reclaimed more aggressively.
> > >  
> > >  Online Profiling / Diagnosing Memory Hotspots:
> > >  A cgroup’s memory keeps growing, but without patching the kernel it’s
> > >  difficult to obtain fine‑grained information.
> > >  Attach BPF to the memcg charge/uncharge path:
> > >  Record large allocations (greater than N KB) with call stacks and
> > >  owning file/module, and send them to user space via a BPF ring buffer.
> > >  Based on sampled data, generate:
> > >  “Top N memory allocation stacks in this container over the last 10 minutes,”
> > >  Reports of which objects / call paths are growing fastest.
> > >  This makes it possible to pinpoint the root cause of host memory
> > >  anomalies without changing application code, which is very useful
> > >  in operations/ops scenarios.
> > >  
> > >  SLO‑Driven Auto Throttling / Scale‑In/Out Signals:
> > >  Use eBPF to observe memory usage slope, frequent reclaim,
> > >  or near‑OOM behavior within a memcg.
> > >  When it decides “OOM is imminent,” instead of just killing/raising
> > >  limits, it can emit a signal to a control‑plane component.
> > >  For example, send an event to a user‑space agent to trigger
> > >  automatic scaling, QPS adjustment, or throttling.
> > >  
> > >  Prevent a cgroup from launching a large‑scale fork+malloc attack:
> > >  BPF checks per‑uid or per‑cgroup allocation behavior over the
> > >  last few seconds during memcg charge.
> > > 
> > AFAIU, these are just very high level ideas rather than anything you are
> > trying to target with this patch series, right?
> > 
> > All I can see is that you add a reclaim hook but it is not really clear
> > to me how feasible it is to actually implement a real memory reclaim
> > strategy this way.
> > 
> > In prinicipal I am not really opposed but the memory reclaim process is
> > rather involved process and I would really like to see there is
> > something real to be done without exporting all the MM code to BPF for
> > any practical use. Is there any POC out there?
> 
> Hi Michal,
> 
> I apologize for not delivering a more substantial POC.
> 
> I was hesitant to add extensive eBPF support to memcg
> because I wasn't certain it aligned with the community's
> vision—and such support would require introducing many
> eBPF hooks into memcg.
> 
> I will add more eBPF hook to memcg and provide a more
> meaningful POC in the next version.

Just to make sure we are on the same page. I am not suggesting we need
more of those hooks. I just want to see how many do we really need in
order to have a sensible eBPF driven reclaim policy which seems to be
the main usecase you want to puruse, right?
-- 
Michal Hocko
SUSE Labs

