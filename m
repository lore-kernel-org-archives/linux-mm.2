Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82077D19501
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58C76B0005; Mon, 26 Jan 2026 11:41:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10046B0089; Mon, 26 Jan 2026 11:41:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3CE16B008A; Mon, 26 Jan 2026 11:41:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C2E646B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:41:43 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C4401607E4
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:41:43 +0000 (UTC)
X-FDA: 84374681286.24.EEF9E80
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 758FC20002
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:41:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PuemModF;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769445701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OEUrHNK8dWefUqOs00hvfwKIFD0uk17xYeaKpauo658=;
	b=PKldF6y7M4pPduAHZReRH4p1EyM2SSdeVukzid/gHQyoeuNU2n2MN3iuXqk/j1tOGFtlvK
	nVomgKsEnw3saT5VvPh7tNGoPclUM1TP/+JAhI1z5+AmeQNC6sv8BLY5cjzhg9VF5H6/Cz
	9kpWI7oMbCiprFjzIVpkCVJAfrFbCdw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PuemModF;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769445701; a=rsa-sha256;
	cv=none;
	b=DknTUd98EJH46hIciRI607LPhNql/fgYR6AbcKOSdR/8Ee8QWJRFsPQ+HFXXJ9bhhOhLGU
	chMZeqVcuO/PegugaZN5XJ/zBOAkSi/6EGSU3wOSgmTbZy9UzkAR5AVuCqUGnV4wwm9Pwf
	TugR7V3dHIjMCICM+XVW13mpbQ71Sbs=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42fb2314f52so2724092f8f.0
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:41:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769445700; x=1770050500; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OEUrHNK8dWefUqOs00hvfwKIFD0uk17xYeaKpauo658=;
        b=PuemModFzVIEgnzwlk7fq40km48f/IAduo5+PDCtQOy21jcnviBzarquTCWmSroMxr
         b6pfrTbrixSClhg7HMyuPDqP0WZESXQt//SC8bR2sIe4rkoJpQtojt5j8gzyyPo/cnJS
         dvvseW7v5dbgVG/RK8zppgT9QCiBM/Z8KDKtKVkGDqCN8v12bH8kKf/tX+ots1VdbSI0
         dvuS+m2WzmfS+9SFI30z3FM4ycvLXRkW6qrJbIzPWa1ZxB0Yn/x/W9UJJIqHXUDcMU22
         T0qelBK2BbrcCD1k6DSeRLf74d8HVC22cdZLoTpT0Z7YMWTn0/EEez29mwOqC8m64Zzt
         9JWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769445700; x=1770050500;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OEUrHNK8dWefUqOs00hvfwKIFD0uk17xYeaKpauo658=;
        b=mf4Pr61R90s8/UaSQLmbxrm0yHpdPlR40kmXy62Zy8cpztle/fjN4BES9++KWZRAY+
         AYfQKpZpkI067Jy9qHo7JVykUiXqIXPo1geww0Y68ItwSlU5GV6l8RM6XxDidQbji8tv
         WddWpjTxOrF3+tL/miMuCHmqTgw7AuPlG0w8P4wLSQBAissRfhV/7kaALslynWnaSV/k
         kqEOVlk+U6tWPKqfwXEibXt/QUMufWiLMOFHirrjobwD5aV/RdDYeIwGR5v614up3N0S
         vzjIasjDwCdk48hX0AXSIm4dyTSveEmTv2wJyXBGjht6OaxRJAGroI738IbADGP65s8E
         x4KA==
X-Forwarded-Encrypted: i=1; AJvYcCV6MgBCSnYDHSg7dQEppNpvJWXK1P/CAHKwhv8KgHn4fJ4DJCvIH2PB6FUBJZWaWZAO+vytOk/Eow==@kvack.org
X-Gm-Message-State: AOJu0Yy6Bfd8B4blQL1feUyWShW6MDvGgebVgLgJ36MyWN3qbsnU0yJ7
	YqhfnAoIC4x40x9tkGVTSBy/RkXl1eQ0Wery54crIZSr7A/l2QK4dTMhTMDVutRynkI=
X-Gm-Gg: AZuq6aKlHoDn7a/f/96ZQ60ySdH9DwtrFpCT0csK26bFF50J2F07uHpivQ5aP9Om4nT
	3YBemuQwRtQsvl1GuUT6Tr9twfr2tmuiX3MJkE5yogPfEqzup4hfdDyM7/TsZtbA9ZIGDUqY+SC
	H57yiKexdVHsSxvTfIwCfhYDX2kNtkoBU65ttXxi7aJc7GhjBu0zAdElq+UFpEFD0whSoj/ArGA
	0+A2lB3cFRR3HkcRRCeHs4K75HKvs030ohfOSGIHHR1fkBUVcnD4EXJd25XQ8SqM/s5I4T9FLo3
	JsiMU3uxodiVwibUiU3Og1cWMK+ZDNCA5pKLHLbMJvZ4CZrK4bA4hXC9osxOFRTim+4ebAjvBDH
	1ZVdvpbSO7Xq4M7a1w3Dso1PK2ey1P2CiBweehTumUg6ro+z95ri6iPGA/CTnZbY9Cnn3WeIgWH
	JBny3RACx9qDGeYfgvStvMFn+W
X-Received: by 2002:a05:6000:4212:b0:435:95ce:84cd with SMTP id ffacd0b85a97d-435ca39bd3emr10384617f8f.54.1769445699664;
        Mon, 26 Jan 2026 08:41:39 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435b1f74b15sm31194587f8f.35.2026.01.26.08.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 08:41:39 -0800 (PST)
Date: Mon, 26 Jan 2026 17:41:38 +0100
From: Michal Hocko <mhocko@suse.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 03/33] memcg: Prepare to protect against concurrent
 isolated cpuset change
Message-ID: <aXeZQoSHJ9QX7B6W@tiehlicka>
References: <20260125224541.50226-1-frederic@kernel.org>
 <20260125224541.50226-4-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125224541.50226-4-frederic@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 758FC20002
X-Stat-Signature: d4i6sg5ya4etj97aphh9dxkt8b8e385z
X-Rspam-User: 
X-HE-Tag: 1769445701-120398
X-HE-Meta: U2FsdGVkX1/9VU9CFAiLboYyyKR8StHbyQLc6nBqCN7iPTJNvGN50Hd/kSqiT/VXDCyE8s0W5+BIF8K2B0ekeVCXviVTXdxvAfOzNeVMEUBE0a78MJ8WjFo2y2zp1iGSJT6ZBFRBRZWp+Gtn+qJM1CdX5qd9wtlpRCLqYNmu3Vgx6+a3dEeAIWkD2Ixt5RPfC5iHcGfAj9+hXtWxBNOEUWh8mP3esxx9fc947adjPVwE32BmRHu7crKfbq5Pfxe+vfViifnnjfhp8RONwtYrsjDrBqUrHNcR+5s/1lpozLGkCSUOtTlfi/bJn/hVmnbbRIg+HouDDQ7efV+KAf/qJuI8dVX/O8CnFeT3dx54vnn2jPL3brAwniS+zngGPT8dVcc4PktU7Z3dcBRFFNdmcREXXCrVPdi3kr6OENWRozgO9NSQUQBMYaOJ6ASe+nStEt5FwR0shSjWiDT6KSNO6Wj9OhTcBOoFiFWLQF8nK4WHz+yosRboqqJbRpE5J/xwT+I9Z8Fn/8WwC8n+7ygdvzssipuIKm8Bf2OJXZrMeypIpLMJxvhO5bJkHYn80S6WO1oOMRU7nVtkIrUJDcoopsnw1gAKite0c5GQLP+pLAwA6LqQ04iHpoQuIoU/vxm6oua0TX2eQfeEV1Gw4gKyAFOFVy9uwlPRNElwUxrO0fgHBezJVrmqGpZI1Md0FsMS9bl3rf5A5X8XLsFTRMDfh3hnPQEmNSkx5L/F3IY8+Vmj6mVtXO/JH9/qJz0dBb5c8x/zX2HPVHdj75886I+sQFdnOZJXVX2fHbeVTGb95bWXkfmSnEYp965OH1BNhr0vMBj27HG0GnUlUQGwS3smrnnx/ZX1JshDo2u3X5m/H4naB6XqJJgiRdqj42z5ByN7x7/P17P65U+/s5EGSL3VNQhX05U56Py/YVWqwxQ8Ps5Ez3i2DiZRcfOpSq/qwIA5Pgwg8lRgcpxQU7CZNM1
 MaHCR/BH
 SgXGMoZdguyiq8yMZcvs3CZeanKJU/0K0wnaAF4k7MlrLKa+92uUVHJ/sThxIdeOEMeVt5nJyJcXBRszGm1P48nce5u6upJvOlsGklcc1HRndwOoQPesU9ckHlQOmnHORJgu0RD/fI+voq0GWxWmAEG2u/EcQuaxx3fLjebqsVDLT+pL7oDWCzlHdGVOa6x/Sy1Mel3snSFJa5pLRTdqn6fLgIhQUbQX6+QuRRn4UhVLe8QZY4eXYFFq/RMQteZ2h50Gq3qED3UhYDC0ud5gN0UGcEHfZnqMGSxuVpvu4soXa/PFqieGawvGO87EzR6dYfeIKdGZ6UnYuUibYmVY1bMlPDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 25-01-26 23:45:10, Frederic Weisbecker wrote:
> The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
> runtime. In order to synchronize against memcg workqueue to make sure
> that no asynchronous draining is pending or executing on a newly made
> isolated CPU, target and queue a drain work under the same RCU critical
> section.
> 
> Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a memcg
> workqueue flush will also be issued in a further change to make sure
> that no work remains pending after a CPU has been made isolated.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>  mm/memcontrol.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index be810c1fbfc3..2289a0299331 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2003,6 +2003,19 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
>  	return flush;
>  }
>  
> +static void schedule_drain_work(int cpu, struct work_struct *work)
> +{
> +	/*
> +	 * Protect housekeeping cpumask read and work enqueue together
> +	 * in the same RCU critical section so that later cpuset isolated
> +	 * partition update only need to wait for an RCU GP and flush the
> +	 * pending work on newly isolated CPUs.
> +	 */
> +	guard(rcu)();
> +	if (!cpu_is_isolated(cpu))
> +		schedule_work_on(cpu, work);

Shouldn't this in the guarded rcu section?
-- 
Michal Hocko
SUSE Labs

