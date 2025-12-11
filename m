Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52A95D43352
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 20:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BE2D6B0005; Thu, 11 Dec 2025 15:34:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96D3F6B0006; Thu, 11 Dec 2025 15:34:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883126B0007; Thu, 11 Dec 2025 15:34:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 780886B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:34:47 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1EC4134B1E
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:34:46 +0000 (UTC)
X-FDA: 84208343772.21.B9B5645
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id BEAC8180013
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 20:34:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="UU7Gb/3T";
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765485285; a=rsa-sha256;
	cv=none;
	b=aMoDYdIi1Gd+Jsz4XwLC0Zia0jI+N3LzkjIwHow3OhZ8Kt91xK4v8G9gKQ7rD/vReLv9ge
	ePgGdYi4dYPWHX4Er7ZGaGNKk7j5lzkKh9NSx2GMcqX8qFy7j1ivZg+Raz7EpJpUkpDwDL
	XQqBWqlrf9U5Ae4cR/h1oohkfJxizQw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="UU7Gb/3T";
	spf=pass (imf16.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765485285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sj4vHGFrdxNlGMAy6JePR4Eq8e6doCTvskR5SsEgWyY=;
	b=G7zoUxwYJblQvhHR4kQUtXfVdI3vejtMimeW1eprckG4T6YuVkXWgx1rViAivaxgTxYOL/
	kTrgoxoqAS/C7B8p2pha0MAc2aMkeOcr4a3JjyBeCTFEidaMpO+xY5X+U0ogj0EgpH84OH
	jJx0zcRqeVALxUg3/SVBCqwkTLb0Eu8=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4779cb0a33fso6852885e9.0
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765485283; x=1766090083; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sj4vHGFrdxNlGMAy6JePR4Eq8e6doCTvskR5SsEgWyY=;
        b=UU7Gb/3TtmKY00iTjew0kfQntF8DSRaTMoqxojfwrYCIG4kFkIe/nniFPs7QKj/fp/
         GiFjv/fIYMS1gqPbIJuw0VM7CZY/NcjCm5F5HuYp+acTRq+R4ZBdiPjd/jBdPDLUysFP
         5PiTS4X1A19D7KM17jSCr30Vn6U4esCMJlcOGDBEvVoHoOB8yDoqkN1tg/8oa1LrMuI1
         YNlEaHvzzkqdKl+F6mTEFgYBigY2N7um5i0X6a500MArK2NicOTbfkOYV8pHpmJt0xPe
         Cmxi80QtaHXduORr9HCEGviVjCKSXZfZzdgjGxZ2S8lni4bpIcSv2YMH7r/YkELK5jQ+
         vJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765485283; x=1766090083;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sj4vHGFrdxNlGMAy6JePR4Eq8e6doCTvskR5SsEgWyY=;
        b=oY9aArWyMDBjG/xHdk1MuD6SRWqL+rYEllwCNqbY/puyX1UVssiL8OYsao+kkbNnkS
         5AkwMm1Z1iwbzm8/AdRN8rbcPKhtmQ3deKgGhQooNjs246rGhE/3BG6/Qyfwv8J/CiEt
         T7r7mP4xHK4sVgC6JMasFt09q9ati4XTma+cq8ttN4iDmToVlik2Sasv8FRsNJnbCQ/n
         CM4kaAnJ2drdZ/IqLQEwXtDufxSNqzwtjAItAHHEY0iYtHEXLcueIcmGv1OHdVcLIyrH
         XrPQ861cYtsnzwoPIc+4H3jaOBe1XCgkXjczvz7V2xsjUh9Orr2VCvmCQD/94hI22jqz
         L+rg==
X-Forwarded-Encrypted: i=1; AJvYcCX9UVoOGPCIP9Q9LqVXSoFi3Q+nqPQzchgpbGVhACyYjoWE+A8jDjUzjttUcO2FVmYSr/wF1yfYoQ==@kvack.org
X-Gm-Message-State: AOJu0YzvFStVhems/M83viNFd0dG2OpoJKKWYi8ZkywJXk+kTmDOvFW7
	s+RHF588W3lQbdPRfBgTuiLsZFtQFOk7l8uGfzkiwBvzu6b8KU7nRMtJbf0eSp8v/pc=
X-Gm-Gg: AY/fxX7RrLmOCxm7hCsuiG6To854VLzOuBIOK+AuFEg1sKKGkcl8oWoU3coqVY9D5hr
	7eoZr3O9+grsKRxiXj0oack7hZoXeXGDLhyntCQlPJDdACu0C6+SZ4L6b4bRetR5BkS5fhmi3Ob
	REEDVeV53pAsGCw6uVQObnmEODOrRyrqJG6KmPwVJgoOfY6VVCb2wiN/RYCiJrVUiYOauyQmuMG
	viOZzniktyvPf/yT0B85UR+grx4YbPEz6ji9MjMa0HG3QyBc0pVoze9xWE0mtoOcMvjxvywGMUO
	VhkPQBwGpXypIb69g5Un9LSDafo3qHbs6RTURb03HUuKtjGqWe/ke0KJ4ubLeC8BzcWNWGXeO/s
	Q7fUG/uD8uOYKlbaNvbHd39sQG9MOj8CmSybFpnNptQecaPd8xxxPc3QMHd4HIDDsu9c5ZJnPLE
	R/R72Vnxdh9EfhzOTLwpR3zA==
X-Google-Smtp-Source: AGHT+IGyx2iUEQnz32pJ0VXihoWHyouksjWFx6kE0ID4txQnGC+oPIJuwT05P62l3LSn8EVKRr02yw==
X-Received: by 2002:a05:600c:5286:b0:477:5af7:6fa with SMTP id 5b1f17b1804b1-47a838586abmr68725905e9.32.1765485283077;
        Thu, 11 Dec 2025 12:34:43 -0800 (PST)
Received: from localhost (109-81-21-76.rct.o2.cz. [109.81.21.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a89f1e947sm61877585e9.3.2025.12.11.12.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 12:34:42 -0800 (PST)
Date: Thu, 11 Dec 2025 21:34:41 +0100
From: Michal Hocko <mhocko@suse.com>
To: Yang Xin <yx.0xffff@gmail.com>
Cc: akpm@linux-foundation.org, rientjes@google.com, shakeel.butt@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Yang Xin <redleaf@linux.alibaba.com>
Subject: Re: [PATCH] mm/oom_kill: add sysctl_oom_dump_stack to control kernel
 stack dumping on OOM
Message-ID: <aTsq4WPlrdrk6ztQ@tiehlicka>
References: <20251211202433.4495-1-redleaf@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211202433.4495-1-redleaf@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: BEAC8180013
X-Rspamd-Server: rspam04
X-Stat-Signature: kuf3jukgpduafg81tj158eq1j9uunjhx
X-HE-Tag: 1765485284-603966
X-HE-Meta: U2FsdGVkX1+NfQ9BfcEqPhzHbCBNohhQdZuNsKC46OhI+okW1GjeUnC9AnbABUTxEA2yWAfepqdElo58VnmwnexNWJAODb3yidKLlYmdFBhUFV2IBD7jpONb/5TlOWZUIZZ1Ga+VfjS0UMGTdOF4f3lDISugzlDLfz7lXJsrNr+09cZOai4ooazhjJdUA11FNWeZaYXO5ObTjkdezjSBtlwhRbK82IWlBw2fCrak5fSEp0ZEFn4cMZtK4C4ri7yiSIrKx9itT7moNTHxjT2r6EEVVVn4YEwujLJ5WTj+ibSPe/1oHzs5fZhWPvW9YAQrXM8VLbNIB41E9MBDUGAB399Qp1WAwU9MUX4WQp7rS/y1ztn/T7OEtkssFlHid5HBPUDs66FeU3t5N+tlHYX0B/3x+7uBFdgia4AyEPcDsuJ7WBaOW9N4pzC2aWwy9MOccstzV3tvSgzmi5saVlV4jqlfMc6t1nFOMaPjcU7suNHMRxqZZTloCciU5w/ShbR6TkPqFtOnirrt0lgbnPSKOBWPCraZQDxqHcp24OojBzuhsicjVxdOT0qNhBo8m7WR3ZCJYWZvqJ08VPAPrYiJLU3WhiDwtL7naly+pn6hAWIF7y2UOqSyRyZx8vSEhlCicGf9bLTzGlcDP5IHA9vD6gkyA09ojoxBAzgZ3GTc80wy4nRyHJlkQfCFl019rNkKcBS0gADi4Z17n8yBlkAzH9p19pz/V/f47CFGijhmxmKrcq9kcIp0ecpQFfX49PFfCZDWJugA67qhHt8k2QCLwMeQEyxQtC1U8Z/L+pG3Heft/JGW32881vHKGjGhhGArJf8ArR4cwDzf5guetrh4XDZVsyIb/+xO01SuEvl+hJ16+bVnKmFH79oaUoLk77jDWAVObIn2rsyBWWQEwvY87u0W2f5Uj50ZioJ61HueJUXysvidVe7bH9xZB9nQWnfdytDOODNdxKNwbiqD286
 15sg16IQ
 YSyB8A8GcWDXreRqNG8MUM7XH9HBhYC7nGFWxuNSjs0pt5rEL4PwsLKHFoFUUvOPIC3gniWoA3T3HFlZHhYfqseS8N4kSpZyQDV6xsFu5XsNBQcWOcLhZoFJU/5yCcevXSmSkcy7bzrGOljX8jQFv380sm0ryo6n32fITTVkqSOCfs9w1rVjXl4qOhciL5p8buvk/yrriSDhQCUKpkrCa6IE0C9wp+T7tvfDlyEPRaJAva0ouVtCSQ2m7lHL667nUJZLoYrFZxgCX/bMdTV4s5yv2jYOI9W/IrOB2XU2VbM59yEovWZsBzHSPucl41zfuavjIVQSd405neU3WekFYtMwuQQ56l5tHMtAC64V5oZ7Ee1O6rwPOghY2LEBNafewUnedd4YGkJrV9cUXRAhYAM2/XlR/DNuacpVk5vgIspFhHxWmAnFyau1VDuR8pfcGi9ZeppTFNnwmRvGpkI9ifsR+SS4XciOEKc47LEmkONXQXaf1p0myUP1UUXNDFQdxMaKRMlJSsAkYMeJWr+5HKgvsn/hKG412e00/Z+QuAyzdrTb/etfLYj6BQEs+83QXGpOoIW9dNB7gZ6o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 12-12-25 04:24:33, Yang Xin wrote:
>     Most OOM kills triggered by user-space processes produce kernel stack
>     traces that are not helpful for diagnosing the root cause. These traces
>     usually just show the page fault handler or system call entry.
> 
>     Furthermore, dump_stack() can be expensive. It often runs with
>     interrupts disabled or holds the console lock for a long time,
>     potentially causing system latencies and preventing the system from
>     responding to other events.
> 
>     This patch adds a new sysctl vm.oom_dump_stack to control this
>     behavior. Writing '0' to /proc/sys/vm/oom_dump_stack suppresses the
>     kernel stack dump during OOM kills, while '1' (the default) preserves
>     the existing behavior.

While I fundamentally do not object to ways to suppress stacks traces
for OOM I would really like to hear more what kind of overhead we are
talking about here (stack traces are reported for tracing and other low
latency situations) and why does this matter for as cold of a path as
OOM is.

Also we are getting way too many of these sysctls. Maybe it is time to
look for a more customizable way to configure oom output that doesn't
require sysctl per output feature.

> Signed-off-by: Yang Xin <redleaf@linux.alibaba.com>
> ---
>  mm/oom_kill.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5eb11fbba704..a51dbd2e6912 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -56,6 +56,7 @@
>  static int sysctl_panic_on_oom;
>  static int sysctl_oom_kill_allocating_task;
>  static int sysctl_oom_dump_tasks = 1;
> +static int sysctl_oom_dump_stack = 1;
>  
>  /*
>   * Serializes oom killer invocations (out_of_memory()) from all contexts to
> @@ -464,7 +465,9 @@ static void dump_header(struct oom_control *oc)
>  	if (!IS_ENABLED(CONFIG_COMPACTION) && oc->order)
>  		pr_warn("COMPACTION is disabled!!!\n");
>  
> -	dump_stack();
> +	if (sysctl_oom_dump_stack)
> +		dump_stack();
> +
>  	if (is_memcg_oom(oc))
>  		mem_cgroup_print_oom_meminfo(oc->memcg);
>  	else {
> @@ -736,6 +739,13 @@ static const struct ctl_table vm_oom_kill_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec,
>  	},
> +	{
> +                .procname       = "oom_dump_stack",
> +                .data           = &sysctl_oom_dump_stack,
> +                .maxlen         = sizeof(sysctl_oom_dump_stack),
> +                .mode           = 0644,
> +                .proc_handler   = proc_dointvec,
> +        },
>  };
>  #endif
>  
> -- 
> 2.30.2
> 

-- 
Michal Hocko
SUSE Labs

