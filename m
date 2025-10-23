Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D31FCCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 15:45:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 973708E0005; Thu, 23 Oct 2025 11:45:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94B3C8E0002; Thu, 23 Oct 2025 11:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860528E0005; Thu, 23 Oct 2025 11:45:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 748038E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:45:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A89D13C165
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:45:49 +0000 (UTC)
X-FDA: 84029804418.15.66109B9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8A939180012
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:45:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XxPW51e9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761234346; a=rsa-sha256;
	cv=none;
	b=d063/ErczWt9mtDmFC359Quvz9iQmeuJT79xVv+omcbMBwaPy/3sJYDjzo0EDAXJA1D1tH
	IPUsxGX4UYTthA37lAIvBVgWtoNJV/TYKZTBz+li9M02bj/YeWuTnljCFw8URzkU+/xF5J
	ksz4gyi8iElbekI1YGFNgwX1zGqEkS8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XxPW51e9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of vschneid@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vschneid@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761234346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50SfSxS4nKgs8hxb+bOC3hzEIaH0AgAoPcaR+jSb2yk=;
	b=jqB0VjA51qT1OPd/muBhI5Kjkz98zHYHPI9wdR50rkZeJ1nCWzNE1f3dmdLMkM4hPNuZFh
	83yEghGyR6EGebouvpSd5JExOch5JgD3+60bPUeRV1lUAlYduIiXqjeLUCoXfz6eOJbLrY
	EPap5tUDd5WBmNYlizFVS7FMWRVsiZM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761234345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=50SfSxS4nKgs8hxb+bOC3hzEIaH0AgAoPcaR+jSb2yk=;
	b=XxPW51e91+UKRec3aRTDz3TEGRt0gPYkHgSt/6l6h5HIu+wgrWd5Rdop6Iq/EtB85EE8MJ
	pOj1sMi0dfvfV09IRgG+1QYhsgfKcWZh/YcH/E6q7H34oTMR8WIUdhsVVCtCxYMWtvCkz/
	ZHrmBWqLefVYWy0etwQQ5PJje6rh230=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-2n97iGhEOgi6_yb_HAZMew-1; Thu, 23 Oct 2025 11:45:44 -0400
X-MC-Unique: 2n97iGhEOgi6_yb_HAZMew-1
X-Mimecast-MFC-AGG-ID: 2n97iGhEOgi6_yb_HAZMew_1761234343
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4710d174c31so11895555e9.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 08:45:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761234343; x=1761839143;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=50SfSxS4nKgs8hxb+bOC3hzEIaH0AgAoPcaR+jSb2yk=;
        b=iJeG94aFDMXJhGtaEk2Y2xUeIV8Rm+xYGPHysT/HBdA9y5SUqIu5kTAxfE7pwhZE6R
         R4ZvQW7wsuaHx+lNUmFObV6X6RFatvvm+hGXOaebenC5pOMN0wY+IL21obdGh/5kPlUs
         ltCjkpUtrj+6CymeWkzGEYfOLcO3ofMGawyzHJV7da+H51pE6c0qmiUUP64w3KNw3PF7
         fIanYYDT9EmUfl5YiOsstTkLhYIQs/PV277L4+vzjz8mFOyIXfBj9nkTnHtSr8rg/KV8
         I4NA+/20TaBUInaM/qNzhV8U86P+iHnxqJkjSgmA5Xt+hBmmnkimI3pPOOA8W91t8iuh
         C9Hw==
X-Forwarded-Encrypted: i=1; AJvYcCVyAotcJw/HDF2I0ukMl6lCKRIvN1T1pgSs81XpBpJW8GuL6yqiQ5uNX4s7UZY5TlR8Pb6vNyTDag==@kvack.org
X-Gm-Message-State: AOJu0YygqSTsgAdkCIqpeiZNXb8ERKrwH+KZ3bfbR/dBziIVkUTx70nh
	AWXxFMc2EY5RF/to1ZtqypSAtgN924ZkgrV6k/J6ksV+My1MRhG+GHax9D66bM2ci5nbRhOrrj2
	zZxmspUw9dVpxHJ5jy4iFPy/FsOkDb7fBh6pX7nR/XX4Gd6pYB0XY
X-Gm-Gg: ASbGncve/JxFjz8Ogk5APZX2Len3p6k57Kb+ovOx69idRSu9JQHxnNjfFUuCmrwbug5
	PZjH4s78Uz6KIr2xZUu/ASZeBva2ECA6YWmqhKsk9Xj333xfsAesYSxZnrMl46plnpgK8vcKiuP
	LDW1jWcOA44ytBTlUVaPOzMBqUBpNsEbjNv0V9z6On1h4OPRfZCQI9CZ3+gtpBVIaFH5AdGDV5t
	mPmWUvL8mWQwpGc8DwSmBvvpXnHd0F6TwHn9Fq2q263GvbFASIiFVQtBEoOcf/NHH3Y3Z55BRQH
	1HaFwMbeQlX05zFPYiO9z5+BPr1Shi5quSjBKoAz4xQkQmS8/hQExNC9eJZoGS46kiicNLzjD21
	hjfFWZIbbFgCSijDK+ffHcfDda+fGH0bFAvFwmoDauYJn499sktHb2KOs1zH1
X-Received: by 2002:a05:600c:548a:b0:46e:6d5f:f68 with SMTP id 5b1f17b1804b1-4711787a2cdmr173963875e9.12.1761234342957;
        Thu, 23 Oct 2025 08:45:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENvjJfnRqlEPVbQJG/5+2SRFe/+XvUSWY4e9vS8wIYZ+gnFtpWxD3L8rMa8r5ek+Ptfbuv2w==
X-Received: by 2002:a05:600c:548a:b0:46e:6d5f:f68 with SMTP id 5b1f17b1804b1-4711787a2cdmr173963305e9.12.1761234342435;
        Thu, 23 Oct 2025 08:45:42 -0700 (PDT)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-135-146.abo.bbox.fr. [213.44.135.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475cad4c81dsm44883515e9.0.2025.10.23.08.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 08:45:41 -0700 (PDT)
From: Valentin Schneider <vschneid@redhat.com>
To: Frederic Weisbecker <frederic@kernel.org>, LKML
 <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>, Michal =?utf-8?Q?Koutn?=
 =?utf-8?Q?=C3=BD?=
 <mkoutny@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Bjorn
 Helgaas <bhelgaas@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Danilo Krummrich <dakr@kernel.org>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Gabriele Monaco
 <gmonaco@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>, Jens
 Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Lai
 Jiangshan <jiangshanlai@gmail.com>, Marco Crivellari
 <marco.crivellari@suse.com>, Michal Hocko <mhocko@suse.com>, Muchun Song
 <muchun.song@linux.dev>, Paolo Abeni <pabeni@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Phil Auld <pauld@redhat.com>, "Rafael J . Wysocki"
 <rafael@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Simon Horman <horms@kernel.org>, Tejun Heo
 <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka
 <vbabka@suse.cz>, Waiman Long <longman@redhat.com>, Will Deacon
 <will@kernel.org>, cgroups@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 05/33] sched/isolation: Save boot defined domain flags
In-Reply-To: <20251013203146.10162-6-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-6-frederic@kernel.org>
Date: Thu, 23 Oct 2025 17:45:40 +0200
Message-ID: <xhsmhecqtoc4b.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9-ILntWLACA8KXlAMk5RkmzTdmwf-8LRLKzHYDHXQIk_1761234343
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Stat-Signature: n89m7zaz9jft8y6rrbf3b7rzy97tq7y1
X-Rspamd-Queue-Id: 8A939180012
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761234346-682739
X-HE-Meta: U2FsdGVkX18ElZos6gSWmjDQkmoUFc/wwAiMMNniHpaPREir/6MTMJG2EZnTI+BvXX5svF7vEUpUzjBsZW9rQQugpumMrCs3l2mY/uElU7fj7SuZLoCkd9GNi4W1BFzJkny4e7Cmjl+k/cX9oe7DRkTujBxc/gO8jfioDVVSl7IHF8g+67q6y6HwIyx3dwFnl9Cd66zxakX5WXY2zBCbH1hae4p06Kub7WvRDF8YceTTgi6sBwXOlOf5qCIN71LO43D8Oq2BIvyukhdDttbEMQPjxHehTR/DY8JYwsMTUOi/f0pFEgSBGRWh7BOIFrt6iaf12WgdD3jOqlLpFNpXHPM4NRi/kyfsCGBUReNbZz0TnPmcyta/iHAmvzHFN2Ap/z6m8cZmB3WjehfrYxD+WpOj/exUUkW38QDg9UOntUaaVEXNCB4+XlHNrFR6xOlpkDgpR3wJPxhmypTbK4iZpVPUri6f/tX6n5Tds3CGnBIkfOKbi1TqDtQmqYSSmsSHUv5uQ7nUQpIUU2NHXOPLidGFPPTpvDmV4sDa9jlkEHgflhwzKlB627pvlph2EVd+Flt8Rl1u1dP8SxA0r5RlKDDWg4iO87HjAAkzGms//S+efRgOB8AYcbP2zr3eml2rxQcf1zKg54lvg6wC7mjzDg5qKKwD5oLgZOI2HjPDaYo7V1U/1zAHsdZHJRQbY4kUgljbgNoIEw3QbuI6wsSNbX1qbcwhpa0LZNqqJWbpItqiKWRH1+1JmjtAiAhsoEFEMA42MZjRPJ+P/4GArDo8iocRtoNpAZSCqFgYfiWLQsx9OHhMsbAa+bG2EHp1LomLNdIytGk+I3HpvyO1F8lYC7Knf3un2u0jQE89oXQmt0RNeM8Cz70wwdYBfPxIeY3Nh5l/Py1qPoFS+sksoEyO5aTjAndKaI2q5mFoFSiyNAieRDIuSCwvNhPXBnE4AGBbXBqM3y+uNxUOuQqHcvj
 t31Al2BX
 sNnIcY9XWTnCFd763bZYOIL3T7+SdMX0G2plwSM+6+9lqtX4H4J8lLN78H/hM80wDzw7tVWacmlXMV4350A8uZlHgTy5roHsv9mqb6zaIf1gHLXuhn33z0anE4iMWNDBPN5faq9ObzG/OdVU22S/ecKeEih7mJt3Ek9Qsonn/ZtyMj/RTlt54JJA1mWyK7Po12q0FX/L8PQbC2sKS8JN6bCZNVIqSMzc5yHdsAsIp3VIR5IMgLevVpog2k6qV8i6ECI+cGTZKN5SsS5rNOsL6kK696Bg3QQ1uD7Lc1c3uHLkAV9edbPTucjrCuRsrhEiQYdhE/3YyxkLCO3a08r5C2Cf2tEf/OOI1LnDXYYM6Yb5vCpEp6Oqf3RI12fVNOEbQe+hx1u1toOMQV4fTbdOkdQrkUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13/10/25 22:31, Frederic Weisbecker wrote:
> HK_TYPE_DOMAIN will soon integrate not only boot defined isolcpus= CPUs
> but also cpuset isolated partitions.
>
> Housekeeping still needs a way to record what was initially passed
> to isolcpus= in order to keep these CPUs isolated after a cpuset
> isolated partition is modified or destroyed while containing some of
> them.
>
> Create a new HK_TYPE_DOMAIN_BOOT to keep track of those.
>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> Reviewed-by: Phil Auld <pauld@redhat.com>
> ---
>  include/linux/sched/isolation.h | 1 +
>  kernel/sched/isolation.c        | 5 +++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index d8501f4709b5..da22b038942a 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -7,6 +7,7 @@
>  #include <linux/tick.h>
>
>  enum hk_type {
> +	HK_TYPE_DOMAIN_BOOT,
>       HK_TYPE_DOMAIN,
>       HK_TYPE_MANAGED_IRQ,
>       HK_TYPE_KERNEL_NOISE,
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index a4cf17b1fab0..8690fb705089 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -11,6 +11,7 @@
>  #include "sched.h"
>
>  enum hk_flags {
> +	HK_FLAG_DOMAIN_BOOT	= BIT(HK_TYPE_DOMAIN_BOOT),
>       HK_FLAG_DOMAIN		= BIT(HK_TYPE_DOMAIN),
>       HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
>       HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
> @@ -216,7 +217,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
>
>               if (!strncmp(str, "domain,", 7)) {
>                       str += 7;
> -			flags |= HK_FLAG_DOMAIN;
> +			flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;
>                       continue;
>               }
>
> @@ -246,7 +247,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
>
>       /* Default behaviour for isolcpus without flags */
>       if (!flags)
> -		flags |= HK_FLAG_DOMAIN;
> +		flags |= HK_FLAG_DOMAIN | HK_FLAG_DOMAIN_BOOT;

I got stupidly confused by the cpumask_andnot() used later on since these
are housekeeping cpumasks and not isolated ones; AFAICT HK_FLAG_DOMAIN_BOOT
is meant to be a superset of HK_FLAG_DOMAIN - or, put in a way my brain
comprehends, NOT(HK_FLAG_DOMAIN) (i.e. runtime isolated cpumask) is a
superset of NOT(HK_FLAG_DOMAIN_BOOT) (i.e. boottime isolated cpumask),
thus the final shape of cpu_is_isolated() makes sense:

  static inline bool cpu_is_isolated(int cpu)
  {
          return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN);
  }

Could we document that to make it a bit more explicit? Maybe something like

  enum hk_type {
        /* Set at boot-time via the isolcpus= cmdline argument */
        HK_TYPE_DOMAIN_BOOT,
        /*
         * Updated at runtime via isolated cpusets; strict subset of
         * HK_TYPE_DOMAIN_BOOT as it accounts for boot-time isolated CPUs.
         */
        HK_TYPE_DOMAIN,
        ...
  }


