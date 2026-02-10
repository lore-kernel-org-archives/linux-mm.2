Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FA50EA811A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 14:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C1646B0088; Tue, 10 Feb 2026 09:01:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081FD6B0089; Tue, 10 Feb 2026 09:01:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85A76B008A; Tue, 10 Feb 2026 09:01:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D544E6B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:01:16 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E52088C9A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:01:16 +0000 (UTC)
X-FDA: 84428708952.20.EB8A351
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5E3B010000E
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 14:01:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LjjHk5dd;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770732074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FnxXnVFI1K0nd8Coyw5JESfQAuts9vipw7Dj/0GRW4=;
	b=lfxOm2JfH2BGmb8DP7lSyy1dQCbae+vOL+VZ6+fNR7vOzUNy3xGSMjpfaxH5xr2p7/LMJ0
	RCAci6yTKVfFFpmIZbUTDVLOGTN5excXBWpaPG6fuGn29ELxIKvjzs+t8Judg67TU02N3M
	b1zk4AEye43OefaeOnii/HeBaVCpmRM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770732074; a=rsa-sha256;
	cv=none;
	b=8PulI7rKm/qnqRa2Pqpb9IMMHQGEtu04pjEdTd34vE51K2Zy6zrDswf7VxWyk4nNcZtgXd
	FXSDjIRjAXklArFqayURo1jlQk7CTLtPqt3g5uJjjVvDIw+EYcLZBbTpVT50xHaVSSQqAm
	AnxdcFiZvNVmLABtA99dBBhPhJEjQdw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LjjHk5dd;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43767807da6so629029f8f.2
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 06:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770732073; x=1771336873; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9FnxXnVFI1K0nd8Coyw5JESfQAuts9vipw7Dj/0GRW4=;
        b=LjjHk5ddC2cG3lVTRqjaL8MerL4tKf1AwZ1mFTZrqdTtJEMHewFX6GolHlBd0XhXIT
         MBrpQ77YC3nKK645jrXq9O/V1t1hbaX6d3p5DDvJSkPyj+b5zFIFvxr9jDGEMNXAMpRX
         pCZeFPGcT7kvAIlZT6o3IMPojFq1MA5oE0Jrx6JGR8gXiJs4peGOQoMKLq8mE352g0IS
         JCPESZSBxzOKqKu1o1k0mtK80T1H2JXTKgchoaVLOoL93pWGVZnxFBXJT3QKgBzQxsVt
         fc5b/WUCSdQOSEOChOTzaaw7m6ZxBs1uL/fu//HO9zY/19+z2u7OcwMvfY/SdyXUkSU7
         unzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770732073; x=1771336873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9FnxXnVFI1K0nd8Coyw5JESfQAuts9vipw7Dj/0GRW4=;
        b=uxoseo8hLSTcOULnmGrRMHScYrhxVCYuOHAv+QTDysSqtrBjODPv9N8/IQU4lKXmXT
         tO5DTTTm5VLvqghxz0Zd9uC/NegKJ/k3ayNXYfQz6lOG7fQKGAspvBVmlGOoHAdlAlYs
         Qcoz4S2iKZ86B876ZmQpdyq+dZqI+TMM0bKMiaxAePiUYdFvmax7q67iwvwjCg4fCqlg
         gSCqeVdToSODb4hDIWko/wB9e9BkgKgb8YcR9XmcMagN19JyDPHI8ay5jyeXtGy66KiY
         EsLJkC0/cWc5CVxWI6sBjAoNSUmx9uLWj1uJSZz8X10UhtA9W3RHjBAU2y9tpti2+d0a
         HeuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUtvmXwIjaF7d8RPXDd+W9XK8MaZUMi/TS6UKVteNKombpLI0fFbueA5aU2OPFB+AMzbGmpxIdybw==@kvack.org
X-Gm-Message-State: AOJu0YwfYo/DtkK72usM4Ot/SVHK+/MsT2I/uo5y8lfvx6w3SMKkTRxC
	JCQtRKisxGMNXA+s7SbHdElBqYDdTEQnYA71QZaxuMNnXid65t0ZCJhu7qbrGfL+9Mg=
X-Gm-Gg: AZuq6aI2zwbv+1BOE7c33GdoAyvJhH1oZz506TZq6lgqLDNESJ5+jpIUUjAUc4T2OFy
	hgUibKmSy0/UuA5DIyqAj+scbTOFXIWiJsQuueTPTz8KXA2b6Iv8oys72+22iONiR5Hcm+XAQWA
	Zv5rbsgVtZl+ftjp80gHbghGP+OYtdZioh9N2cYDUsiK05vbvZidKAD0O3e3mpBjP4VpflOvjOW
	6dsmRm4TMVNEl4d0TBrJrrVWLqq1sM4Q19ExhERSzlbTmQIYu5FmT1qQvz8xeEywVWzliX9tYiS
	h9vzs+95492/yr7zbHjNn91A+opRhZt20tH24N0TLpr1zA/yjPoxtC1B9dGe0DNA+jn11UZ5nXQ
	FDHW4MJ40ROd3q2j5lxFYzy/ZazngYf8Gxrx2u42uiELXvZ0uUkPvYMopaYV+r/DU6xT4NK3a3l
	34SN3/gSufJWvG8XU+UXHAGMTU16+nd1/LuVIr
X-Received: by 2002:a05:6000:2382:b0:437:678a:5921 with SMTP id ffacd0b85a97d-437678a5b00mr12105418f8f.1.1770732072461;
        Tue, 10 Feb 2026 06:01:12 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-436296bd4a1sm34344330f8f.17.2026.02.10.06.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 06:01:12 -0800 (PST)
Date: Tue, 10 Feb 2026 15:01:10 +0100
From: Michal Hocko <mhocko@suse.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aYs6Ju2G4bm6_tl2@tiehlicka>
References: <20260206143430.021026873@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206143430.021026873@redhat.com>
X-Rspamd-Queue-Id: 5E3B010000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: u1sk3ks1sgexoin7tthhyahae6exe1hq
X-HE-Tag: 1770732074-967650
X-HE-Meta: U2FsdGVkX18YP53xg11gu433wYqPln9eUVE1nQxnPkqaI+0fNIMibNFTrzB2eG5HDOQrXD5JIGnZ27oFb3dwkrZXgP8Rz9RHXRaRB2U77h3dywNuiZZC83NpkLm+XFuhVb/nKOuxU7acC5CgG1Bas70QjNKBclIvXOJFrT+pLizsFJwhef3Hh+ul6J7BzBngo+YtMCTfqBS7RkTyVEaKZ7BYJSIus3B39WoSOp516bdfjc2Df+SqcRU0ZTKOUH67xdtjbfjz+8hBP8tpS8N86zekIdOjJJ6frsRTLgWYrFACzN62N68F7CnDillFACJ8XLUnvmv20xHvp95OHeebN7nJDM+UNLq+HxZ4w/p26NWtsgqkGn0NXXegNY5M8xQyYR4eWtoa9HZ1m+ZSuEQD1cpDmfSVEZv3QKGqn2fh2pxIJLtfDvcwlWw76YlFt4iW++O0kNBAZq/dqMEkewQQTIU20XPF8+swTvGcEPUn7QoAtKJGAiN6NwN9oV2XqYOC+q7/FTqlVkB+MMYX7o7KzUGHcnGznsQv+3G30+4yOTfmd+nVN0Hw9em2z4eicgOfRHsBhB+DiauqtEHTSHfG7EzLbfgmdCmafmIBXcjf7EpEgQhNjLCKf+58e8n4uWTCNhoMr80IQUbl5fCzLv6jbHJcuct6VI4gCFus5LL4hOlQy87dYZMEU/0ft0qsmralSoQJdRnnwpHX7MFgIhuZkzkZMvHXv7nTrcCngiuLsMUsXR1iUsAEDuEoUYv2kBfo/cuvAU3OizVMxUAghYOsrdqsacTonVVlbKkNeMhXrvCnPidfLOAqJdNyVJ7lyKixe0d93rI7dLkWMOS3P0BGhjRVsVQUWcvFRv5q2bNqRE6qhApyQfhlwjx1f5UDzNV0mOv2TSTU6l/Xv3mOHs6nZ9Av8PjaoZlDqnVg+y44gB8SFxi2BA4DRZzA7QoM42MCyGCzcohrDOwFoYHI8nn
 5gRUxJKd
 PVXMw2N7eLnq/5+azwpQ+ZL2+4L+SycG1fKTqEHG+r4Gwaq3Z+YRY7IsVFyZvlS8CD/w9J8tRVeKzL/3jfM6pq63hE/TeXr563emh4N/4ixK5pmW9WszgYl8g9NwAm0dgcfoynEhvpJ+mstiqhturJPAZ8T80o1rFaBTLK8XQDRHrlq3mio9mdhLxI+wmvI5oi1Wvch0skvbjq6QBkGmR8rNmoJGVwYM6CttyFODxVtPi1mhdJ6Ap0y0WMiRDw9J/t33PuwGg+buOz9Zq8G20uQ2B6480QfqARa1uKxMEqk1tI1VDwtc6XmI+7z9xH5ImxuUmcKJv7/x7pX6vg+lIgbuJc9YUrHhFmqzABCEakFBC+ME6Hn6Z/NlhNnfdnOcgSdYuxq40kOrNbrnoh5m1eHxCTBbtW81raghRXjnYX1IcH8c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 06-02-26 11:34:30, Marcelo Tosatti wrote:
> The problem:
> Some places in the kernel implement a parallel programming strategy
> consisting on local_locks() for most of the work, and some rare remote
> operations are scheduled on target cpu. This keeps cache bouncing low since
> cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> kernels, even though the very few remote operations will be expensive due
> to scheduling overhead.
> 
> On the other hand, for RT workloads this can represent a problem: getting
> an important workload scheduled out to deal with remote requests is
> sure to introduce unexpected deadline misses.
> 
> The idea:
> Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.
> In this case, instead of scheduling work on a remote cpu, it should
> be safe to grab that remote cpu's per-cpu spinlock and run the required
> work locally. That major cost, which is un/locking in every local function,
> already happens in PREEMPT_RT.
> 
> Also, there is no need to worry about extra cache bouncing:
> The cacheline invalidation already happens due to schedule_work_on().
> 
> This will avoid schedule_work_on(), and thus avoid scheduling-out an
> RT workload.
> 
> Proposed solution:
> A new interface called Queue PerCPU Work (QPW), which should replace
> Work Queue in the above mentioned use case.
> 
> If PREEMPT_RT=n this interfaces just wraps the current
> local_locks + WorkQueue behavior, so no expected change in runtime.
> 
> If PREEMPT_RT=y, or CONFIG_QPW=y, queue_percpu_work_on(cpu,...) will
> lock that cpu's per-cpu structure and perform work on it locally. 
> This is possible because on functions that can be used for performing
> remote work on remote per-cpu structures, the local_lock (which is already
> a this_cpu spinlock()), will be replaced by a qpw_spinlock(), which
> is able to get the per_cpu spinlock() for the cpu passed as parameter.

What about !PREEMPT_RT? We have people running isolated workloads and
these sorts of pcp disruptions are really unwelcome as well. They do not
have requirements as strong as RT workloads but the underlying
fundamental problem is the same. Frederic (now CCed) is working on
moving those pcp book keeping activities to be executed to the return to
the userspace which should be taking care of both RT and non-RT
configurations AFAICS.

-- 
Michal Hocko
SUSE Labs

