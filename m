Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 235F3D39403
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 09:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16FCD6B0088; Thu,  2 Apr 2026 05:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 121126B0089; Thu,  2 Apr 2026 05:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00F676B008A; Thu,  2 Apr 2026 05:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3E766B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:27:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 459048C05C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:27:13 +0000 (UTC)
X-FDA: 84613087146.13.814B39F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id D5F4F40014
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:27:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="WxcNR/jT";
	spf=pass (imf07.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775122031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36+ATcVryHEsHCfEL0i5GnGjSCxjk7f9m5BZERXBqcg=;
	b=Fy9xwuwgBCNbpmbUo/H8FVRc/b7/FH8X2sW1wxGm40rcBKlKOU6t3W9bgiIICP+e+mtKWN
	QJiSAvJhojglSQld2uT4xZX0AWBKblwIwttX/yeBRgtk6NkfMJMrrH/suFwL4u4LWTQF3x
	3KmAUZC9pz7y8ITCTwzl56dQZz578Kg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775122031; a=rsa-sha256;
	cv=none;
	b=Yo3g3cB/um0lcRnCis6BBVxRjg21xMuBIeoX9nbVnkRFJYImdMV60EDQywgtBsCo958St1
	WgGb4YmRF9mRWC6VBb95mak9D/oK3ostaNJqEXEIG23GAVXi8uFyYhXuj40zPseaW8EFYz
	yn407t4ZY3Lualc5AAr3Dn+6GJ2204o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="WxcNR/jT";
	spf=pass (imf07.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775122030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=36+ATcVryHEsHCfEL0i5GnGjSCxjk7f9m5BZERXBqcg=;
	b=WxcNR/jTpy8FNj3+m3kIgzNB1kOzMLYe0bTrsZTpfy2RpPXaqdvhaOhjhIVfNV/iGMzI9P
	VdKpbqKYmDZ3SQ9H+0Q7h6m56zoh2MGbKhTmQhqD9ctVa+FwWM5RwthGMmweWVXxNPqH5Z
	Zodjx1FueDTYs6Gx+24wIA0xJ3kRWDE=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-DkJBHl5BOnqhW-HyDXDLug-1; Thu, 02 Apr 2026 05:27:08 -0400
X-MC-Unique: DkJBHl5BOnqhW-HyDXDLug-1
X-Mimecast-MFC-AGG-ID: DkJBHl5BOnqhW-HyDXDLug_1775122028
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3595485abbbso959591a91.2
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 02:27:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775122028; x=1775726828;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=36+ATcVryHEsHCfEL0i5GnGjSCxjk7f9m5BZERXBqcg=;
        b=OUAwJ87rvp6j9g/+HORM2gk4KquoWzJmTDeGuqjDVmAOK8UkR/V+AWTP+OQb/95mEl
         5Irm3CyaiHQE6BQHuwFfnKasFr8iBWNE3yGWwyVX0aLyw4PDsBcfu5OSZom4g/2WUXMY
         jfsQN6xZe2rIV6dTlfkLXCE7xLn1wAZU3orMVZS2e6HYGSx2Qay1hZ+wvMsquU/Zowem
         QaAYjxSVlelRu8qp+wYkfsWYD5QbwWxbU6LqKoLx+eqkvY8C9FeLOO1eMaTFmyR5gJFU
         hXltcKmgnSDH3OI34QRwfrMrQBT8F0qNwcI/PEHaeIPmXgkuJHLgLE5LHqwqcyMb/oMA
         KnhA==
X-Forwarded-Encrypted: i=1; AJvYcCVsXVuOb2G/084y8eJssX/rejvfDEf8tFpHscLoA00P39gKkQzRnod6XVc3G2VYiRHl2QN5K8LUCw==@kvack.org
X-Gm-Message-State: AOJu0YzuECNWNvw4WoIicaNkCZ8WU1+6QGtNfjoxHsT1PKL3RDrvij49
	xaJU8I3FKYKXnXVChdip+eNQRJcTrV7FLDhFsWNZR0pgS+4EfZmG/nQ3CyTHqPO47im6BJQe5Rm
	tPIC2tEpr1+x21l9GQ2p3g5OnhAt7JLSct5/yIugUp5p7jWP1a322
X-Gm-Gg: AeBDietAjB6pqk9P+wl94gYEupqUYQys4ZTVc1bbtMEmYlgzlb09Z9heRyjeH9IBxzf
	mGB9UIieGOiAf/ZZ+w16gq+E8L6LF/1fOmgrso4SUG/8F8jZLC/yrdR/+TOAY/1W0bJGrvGPVNK
	uNlrG/iTvSDh9PGm0OBTVREublMSZ/dzBI58DRQ2r5uhtn9gXT/4yzmbPURyVj2SiZj1zupnfFY
	ykJnV3Ym4YLyxRCoNuQBFlU4jJyJSKyvra6Ghq6eD22O+3DpO33hlQQam70zqhzvEnSAGPgb1VK
	4MyxmmZFBcnupiKVplWLuEiZ+SkTm65IZ72ByE8LIyX4pxJYKt70AxNO9kN5pMEJXw2pFvmOlax
	r3Exp6XpH+nTAz+VVMQ==
X-Received: by 2002:a17:90b:3947:b0:35b:e566:15a6 with SMTP id 98e67ed59e1d1-35dc6f4f018mr6646521a91.28.1775122027797;
        Thu, 02 Apr 2026 02:27:07 -0700 (PDT)
X-Received: by 2002:a17:90b:3947:b0:35b:e566:15a6 with SMTP id 98e67ed59e1d1-35dc6f4f018mr6646481a91.28.1775122027294;
        Thu, 02 Apr 2026 02:27:07 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27477736dsm22344875ad.24.2026.04.02.02.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 02:27:06 -0700 (PDT)
Date: Thu, 2 Apr 2026 17:27:04 +0800
From: Li Wang <liwang@redhat.com>
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Li Wang <liwan@redhat.com>
Subject: Re: [PATCH v2 1/7] memcg: Scale up vmstats flush threshold with
 int_sqrt(nr_cpus+2)
Message-ID: <ac42aIDVaGim5moO@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
 <20260320204241.1613861-2-longman@redhat.com>
 <n6mhkjsxsami3qmczkdh57eep4lmcgbtyl7ox3ajzveke44yf6@m4bjevvsr47k>
MIME-Version: 1.0
In-Reply-To: <n6mhkjsxsami3qmczkdh57eep4lmcgbtyl7ox3ajzveke44yf6@m4bjevvsr47k>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8lziRUI9c63K67Q7f-yyeRbBj9AQ9Uf8b-srxr2umyM_1775122028
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D5F4F40014
X-Stat-Signature: m7s3f3xcimqq67qkuozxw8nka77pdaxs
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775122030-664944
X-HE-Meta: U2FsdGVkX1/9Pa2TQ4WeFrvdHCA4vxvB7e89AYDH2fHqhnX4W2RYyf25zf4j1ZDon6j6R7h2c2mxjXCmUA03N6uogZKI/lqmgTTZHWHhfnnKMh61ar8H1Yc4hBVvtayMfMIrBafOd6SSELCUU8mCgfkVcaUTgRh6/tmQDAx8u6k6WITAIGmaY6da/8TS4fMPrh704pYNsa3CWcQJJO5uasSMqiM2xPVWXo+i3hK4h1R1wgSssp5fO5O7na2qtv38hixnigiWQqK3G9OEEB9ruzLunz36auktT2eCYPL9iTLUa3P4WeJOJEeJ3RjJzxUy1Kagj087Xpq0IBvp56expS0vyrU/sYa0weNerE9vIfedgWaj0y6PFB4Vp+dQ05JlhOrXIYJISHf0ptkxS2cQ4FfVVD5VBZgvNfZRoignaOn9IXCJtMI6Pxb/RT8bGOoCEoIPgFJZ//YGuQCJKNQ0gZO0322lUo6Bzpgu7hXQBNKyUvFYXX7y3Grca9CR7Qe81L3+zSsEGFH5C71qTNzXGrlPkDU/Ecztl2YTjJI/0I1X5VerstawmM+NYIejWHiAmQRCGpGdT6ohgZ10lLzvfGdYXBxiYYSLeWdLhmi2PmYLU5QKps36niiOd2ChmNSi0mm6kuludBfYsv+ry2DU2YhMOZkXQ8F3fSD3uFAUG7lg29oG2swLcTX0ii1cmZG/kIkGYpYXYPeqJYQ9+qTQFKmU10cYw5tjUjhEq1f0Gxtkswz6UhKeZXWxKUwK/NtxfscUB5SuJO/giuesJaTgWzm3/ALlgYln+nizdQiE/pxhOfJJHDu9pep93ckvksssKYdbOBmNUOjLio1F59hxWlzt/JkagsQ3lpSTeafgNgmgUCVO+8T+ezmeuIIuYaq3nhPIRrPOBK4Y5UVa3btfU8HB6R4t61KfaJDA25WJxxkkKbnPxXl7aOU8ob/saVws2HuQeQIyr1xeU3wcduQ
 sJ01VBbX
 MVhyskHo4hWLWG8Wztn0bi8NKdK3aKGlzUNsPKXJ7mJK1kdSY+rGvzVYY+nUfxfgMhop+QSbwPMZSD/Lc7pKOG6z8V7JZRSpYjr9DRIRj8ioWIusJeEJbr0qtVHELNulV6q0JVucro0VE9AsmoOSSMRXGOdCHLWg4CqzTXEkyxfMoj4SuTwVytwitgLWEvWIw1jZCWyFBBGXg5o9OiqLBcl+gasETtmi0oZ0duYdHYEt5lOvOaToZidBV0Wbvsdz5aBDPew5Zly0tcIFaeyNoA1h1l72sZkli8FXoKTWIPk5TWlasF2/ZoY45oIwHLkL0WLcJWuR82JaxvKseuxyi6L81GT9I06p6Cn1OHR+quRTGk1yj30aoINjQRVyChZsVUEpSFhw7Ub/cr/sM9LZhowebkBBZwr4FIdjSFqxBBIQZBpEl6HBQDjyHIOfcBriD6/7/biHRzDlQFjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

> Hello Waiman and Li.
> ...
> The explanation seems [1] to just pick a function because log seemed too
> slow.
> 
> (We should add a BPF hook to calculate the threshold. Haha, Date:)
> 
> The threshold has twofold role: to bound error and to preserve some
> performance thanks to laziness and these two go against each other when
> determining the threshold. The reasoning for linear scaling is that
> _each_ CPU contributes some updates so that preserves the laziness.
> Whereas error capping would hint to no dependency on nr_cpus.
> 
> My idea is that a job associated to a selected memcg doesn't necessarily
> run on _all_ CPUs of (such big) machines but effectively cause updates
> on J CPUs. (Either they're artificially constrained or they simply are
> not-so-parallel jobs.) 

> Hence the threshold should be based on that J and not actual nr_cpus.

I completely agree on this point.

> Now the question is what is expected (CPU) size of a job and for that
> I'd would consider a distribution like:
> - 1 job of size nr_cpus, // you'd overcommit your machine with bigger job
> - 2 jobs of size nr_cpus/2,
> - 3 jobs of size nr_cpus/3,
> - ...
> - nr_cpus jobs of size 1. // you'd underutilize the machine with fewer
> 
> Note this is quite naïve and arbitrary deliberation of mine but it
> results in something like Pareto distribution which is IMO quite
> reasonable. With (only) that assumption, I can estimate the average size
> of jobs like
> 	nr_cpus / (log(nr_cpus) + 1)
> (it's natural logarithm from harmonic series and +1 is from that
> approximation too, it comes handy also on UP)
> 
> 	log(x) = ilog2(x) * log(2)/log(e) ~ ilog2(x) * 0.69
> 	log(x) ~ 45426 * ilog2(x) / 65536
> 
> or 
> 	65536*nr_cpus / (45426 * ilog2(nr_cpus) + 65536)
> 
> 
> with kernel functions:
> 	var1 = 65536*nr_cpus / (45426 * ilog2(nr_cpus) + 65536)
> 	var2 = DIV_ROUND_UP(65536*nr_cpus, 45426 * ilog2(nr_cpus) + 65536)
> 	var3 = roundup_pow_of_two(var2)
> 
> I hope I don't need to present any more numbers at this moment because
> the parameter derivation is backed by solid theory ;-) [*]
> [*]

It is a elegant method but still not based on the J CPUs.

As you capture the core tension: bounding error wants the threshold
as small as possible, while preserving laziness wants it as large as
possible. Any scheme is a compromise between the two.

But there has several practical issues:

The threshold formula is system-wide, while each memcg has its own counter,
they all evaluate against the same MEMCG_CHARGE_BATCH * f(nr_cpu_ids),
with no awareness of how many CPUs are actually active for that particular
memcg. Small tasks with J=2 coexist with large services where J approaches
nr_cpus, yet they all face the same threshold. The ln-harmonic formula
optimizes for the average J, but workloads that most critically need
accurate memory.stat are precisely those spanning many CPUs, well above
average.

Moreover, the "average J" estimate assumes tasks are uniformly distributed
across CPUs, which rarely holds in practice with cpuset constraints, NUMA
affinity, and nested cgroup hierarchies. And even accepting that estimate,
the data shows ln-harmonic still yields 237MB of error at 2048 CPUs with
64K pages — still large enough to cause selftest failures.

In short: the theoretical analysis is sound, but the conclusion conflates
average case with worst case. Under the constraint of a single global
threshold, sqrt remains the more robust choice.

In future, if the J-sensory threshold per-memcg can be achieved, then your
ln-harmonic method is the most ideal formula.

To compare the three methods (linear, sqrt, ln-harmonic):

4K page size (BATCH=64):

  CPUs   linear   sqrt     ln-var3
  --------------------------------
  1      256KB    256KB     256KB
  2      512KB    512KB     512KB
  4      1MB      512KB     512KB
  8      2MB      768KB     1MB
  16     4MB      1MB       2MB
  32     8MB      1.25MB    2MB
  64     16MB     2MB       4MB
  128    32MB     2.75MB    8MB
  256    64MB     4MB       16MB
  512    128MB    5.5MB     32MB
  1024   256MB    8MB       64MB
  2048   512MB    11.25MB   64MB

64K page size (BATCH=16):

  CPUs   linear   sqrt     ln-var3
  --------------------------------
  1      1MB      1MB      1MB
  2      2MB      2MB      2MB
  4      4MB      2MB      2MB
  8      8MB      3MB      4MB
  16     16MB     4MB      8MB
  32     32MB     5MB      8MB
  64     64MB     8MB      16MB
  128    128MB    11MB     32MB
  256    256MB    16MB     64MB
  512    512MB    22MB     128MB
  1024   1GB      32MB     256MB
  2048   2GB      45MB     256MB

-- 
Regards,
Li Wang


