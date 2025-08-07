Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CAB4C87FD2
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 03:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B54E88E0002; Wed,  6 Aug 2025 23:22:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B056F8E0001; Wed,  6 Aug 2025 23:22:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1BAE8E0002; Wed,  6 Aug 2025 23:22:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 903FE8E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:22:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E84BD1DD57F
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 03:22:17 +0000 (UTC)
X-FDA: 83748513114.11.68B7267
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf26.hostedemail.com (Postfix) with ESMTP id F20BC140004
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 03:22:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=gubowen5@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754536936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Do87lLQ2saSYnUjx0i6f4MWfPvwkHXTudvBBz3dQIcg=;
	b=11RYG5WFIgAPO08k2UqKftndFgxaAMBpzqmTvwmLNPvQSN87cowae/TYVrZbaycf088lhh
	rdBDrvwK4pwn2G5kg1pqk9jJgIrZlDVGg6a2D9aSezxdtK7rOh0onpl0DEho2iUNbPdUPH
	TFst6gNOD4Urc/OrVDdDhUJpjPXsvAs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754536936; a=rsa-sha256;
	cv=none;
	b=1AmhSiVBc0qTeS0NFg521WU09YkQlmV9HPYa7Uzz+rnCN9qa7hB4ue0K5SFJeNxCZcZjBn
	Q4OA/rpMzuV9KoHArjUmzWnvoQi648Nwupn/IC7dShq5BqdHLtqUojeZZuVod3mYAarWW/
	YZIvnBMFvuf+kxBPZjewL1hk98FL0G8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of gubowen5@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=gubowen5@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4byC7t67Q6z2RW7C;
	Thu,  7 Aug 2025 11:19:38 +0800 (CST)
Received: from kwepemh100007.china.huawei.com (unknown [7.202.181.92])
	by mail.maildlp.com (Postfix) with ESMTPS id 0B0341A0171;
	Thu,  7 Aug 2025 11:22:11 +0800 (CST)
Received: from [10.67.111.31] (10.67.111.31) by kwepemh100007.china.huawei.com
 (7.202.181.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 7 Aug
 2025 11:22:10 +0800
Message-ID: <6e278baf-c6e4-49ee-9880-6c15a2c1b996@huawei.com>
Date: Thu, 7 Aug 2025 11:22:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix possible deadlock in console_trylock_spinning
To: John Ogness <john.ogness@linutronix.de>, Waiman Long <llong@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, <stable@vger.kernel.org>,
	<linux-mm@kvack.org>, Lu Jialin <lujialin4@huawei.com>, Breno Leitao
	<leitao@debian.org>
References: <20250730094914.566582-1-gubowen5@huawei.com>
 <20250801153303.cee42dcfc94c63fb5026bba0@linux-foundation.org>
 <5ca375cd-4a20-4807-b897-68b289626550@redhat.com>
 <84h5yko44i.fsf@jogness.linutronix.de>
Content-Language: en-US
From: Gu Bowen <gubowen5@huawei.com>
In-Reply-To: <84h5yko44i.fsf@jogness.linutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.31]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemh100007.china.huawei.com (7.202.181.92)
X-Rspamd-Queue-Id: F20BC140004
X-Stat-Signature: f3e4ox51b1ajps1n4peig9rja35cfgky
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754536934-834531
X-HE-Meta: U2FsdGVkX19oPeMR84mHz1C9+ruTmGvome1vZNSK9A/TtAVZ+POxvvv4rDfhPwmKufPGJvKxTU35Nda4xRarcGomt33hdhmspCqOz/utI3nrN94O3Nz1+5byvPCFdQZuHAkkyZXYQUsry2mvpuMZNzU9L5cjxlncNtmFvQemA89QwVpCkUZWHBss+7zhwhF56M9rYRkXgdbFRl5AtarRuZDoeeS6jtZHjnEySVRDXxIBcXm/KHfVrnJ6k3ZIR20ohm0v8UxOLnY0xgqAHlTTaQpebG6Lgxfdj1LaUkw3dAfwEjTMMb7BlHRvwl4MZS3uevNiQnUXHcU1R5v3cKYDi2C+pRyoMKOfAGdGqaUEmYUWsL5g7CZbo/uHxcWnN2oQWeGE3U5brc5+8huLvL20zJ+Lp+RL0fAwuA6KloQux7cz78kjM6Kmn6+dx/cYoy3HD35mbwxxygJjXbsUSW96RIoqPjPi9mot8hGz35LFPfrk/aR/9IieIub3tOCXKoM3GJroUEHxcfebJN3yYA8SRuECmq+4DzYqdRFF9/zG+yhLxBfFNHozmUCEjxfSfNSjFpzQ2fU4F4P4Fjb4bZM3Fn72aaVZjko/JIdEPhHLhJa+TrnAPFCARw9ItpeRpxtvviEna7yc1xXkk0wsxzcNamCJ0z7G7npvPpAflbmlp6CPU8HQpb+iWcz7ZW2U5hUHGFPFhcVSQNkY0ru8vfVVAlybRsAN2fSVr9JDi2SLXBh5RZx8p89RuIxRwR2PkpYm3R87c27gF2mkRywYI0i8M6+fENGa8SKHw69c0nPyNVofYkPs7glabkWw5F9gDww9vZ/oSOPF6oVas2Z3l7rMl4kUUxBwmeSpqaIwvtt6jdC8VXkjuJjAoZ09s91nHrA+MzMiHK90M+f+2izUDEr9mW/5aWB0nT66FXfJKWGYO2DWqSIYxmEdDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/6/2025 11:34 PM, John Ogness wrote:

> 
> printk no longer works like this. There are no special per-CPU
> buffers. As correctly pointed out by Longman, the proper interface is
> printk_deferred_enter()/printk_deferred_exit().
> 
> With the deferred interface, the printk message is still immediately
> stored in the printk ringbuffer (which is lockless) and only the console
> printing itself is deferred.
> 

Hi,
I agree that printk_deferred_enter()/printk_deferred_exit() is a better 
interface, but I noticed that in stable-5.10, the printk safety mode 
still uses a per-CPU buffer to store messages through the 
printk_safe_log_store function.

Additionally, the mainline version has already refactored printk, so 
this issue no longer exists.

