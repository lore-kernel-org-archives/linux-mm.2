Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28A95E7FDE0
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 01:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5642A6B008C; Mon,  2 Feb 2026 20:10:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDF86B0092; Mon,  2 Feb 2026 20:10:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0F36B0093; Mon,  2 Feb 2026 20:10:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6636B008C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 20:10:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D0EA1D26B5
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 01:10:30 +0000 (UTC)
X-FDA: 84401365020.25.A1FAFFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 17FC2180009
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 01:10:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z+dANVh7;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770081029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ox0wdPW1OEKiwpdSLyy318xB6kSU5dBL59Z3OmH9uos=;
	b=Ih2jEehhUfdRzWDtynTNCOU1FaZEErqhg5hOjWyFVg0PhoDFACzFD/3RBv3aUCoRxpB+Fh
	+ffK/ZLw45YxZEn7vVmc1p2rEg5PzCOPkh9+Uf8NetHUuFkNd+O1kCCNKLpsjsJDmHCXqw
	SBxq6IoSG8/G+PGRUuD8N+CJsvSZXHs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z+dANVh7;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770081029; a=rsa-sha256;
	cv=none;
	b=Wmj2Ay+RdFBEq2P2iZiAiAHyzFQl/XMeafYD/Bj0NbS0Y5bZX6GU5HwtU8yH3PSKEAgP0d
	rq7Pnf/ekahm4HPZ+9WfZ5tLKSqxYA7UdErTuEdVIRer8xzW2tj749yIo/BZjPvSWM/jdX
	p/b75ELFwg3fguUSnMTnezR6ykFyndY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 227E040039;
	Tue,  3 Feb 2026 01:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7DCC116C6;
	Tue,  3 Feb 2026 01:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770081028;
	bh=2RdGROADSPTSvf3X10eeb10ai2q30UTfJxWuJZcpIQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+dANVh79IpjEyJWVw4SFY4tpnPUi5xOFeNj1mlrutVwGsO3kpQU4Dwwu5YPe83s0
	 aWF4VkGemt44wPVPT1dqtfx5v48zlbW+F7e5EEMNk9JIhrohZ7BTh5VNtIZ/PKdKsm
	 Ogpgr3fgg6jfWs02boTMG39Sn7uCO7P4tL2Qqu1XzAIglQpHArKQuNloKOKRR1+tUZ
	 6YsllF7p9xoO0A9twY5PMtWIftKfhwKTUccK608QLpbYt5Rqst8tw/mkcxClKYgCjk
	 V2RyhlHNDnv17B/CrRjiNQOdO/7JcZqq3/la1xVetqfYw8XglJN/ZQOtd0++TFImja
	 /Aw7XNVQGivCg==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/4] mm/damon: Support hot application detections
Date: Mon,  2 Feb 2026 17:10:18 -0800
Message-ID: <20260203011020.67357-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202145650.1795854-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jaxwtdejkrnwmtz76zxobmf53jbuspcn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 17FC2180009
X-HE-Tag: 1770081028-88692
X-HE-Meta: U2FsdGVkX19clhGaxJPJHNaTJH0HyfxmGJiYAV+Vhnng2Mf4kjtIHbY8pIvAFDW9CF55RAz4fKRQn9t8iQCIILRWIWrvPj6YVlHFgDzTpprZSXGNMCpjC30Ojwyn1QfeN9iiCovKGebVrqzxkkjoSamRwl9a6ojhCTegvNCl26f6d5G7a6O91Is3DApJQV5cb45dzNIiURlrlV3+2U4akoxtHSijFPJwiPEuycqXOc1ImUWasxw6oIKd9NBby8cu4Pyt0C29vTixxYF7YkkJPUWfhQhxMXsIB5Gu28qpMFby6I+mRY0XLOiPr1RIjvX3mQTN5scqhX0+Gs2sctluY0DL1gVn8lkaNz6np6Mig0NoDjEq2LiCGfDotOGmACpZ5/oMkUkBdEWWVqTsyzFy8cYRuTnExqNIZ7g33ENgJKWuQ4kre8FicsYOXNhtaztW+Z9niwJzX7ELMQfLqugPYVn/SaPX74n6E8mL9AVF9FiPKRLytLGFNZ6WV6nA5e9vQKDn9qjmvPVV9Ww9qopwHrFC7zwU33KxkVM3axF3AmqTK9xOfINGzkpXZb6i9CzqCsfleDbLxP9MWxCeOqNhgsqocHj6PZivseOWRajJKwCt7CxBYdnj7dBAOWHGs2AXJa2eKwvlM54rgGPs2xhtwapqgJnsl9rBnmmJVQr1lanQ21HvncVQrkqhPRLNdTj7RSNd1Qk81iZ4SJ0ubUKcSgtUcVMWUJnqoamxwd03rcDIPdjgPHxGZOl0KKtc4qW+sfBOj5t25ZBiCZaVL0jeQvV9AontqSXrWBWj/3VIh8KuC3AlEYWgHinuA1wuIB5HeExDRjgBj8j7GsHGgRAPD0AwSNwfkahOXNyyvRMLhzqXVHn5cnTzfRWud7B1pFrGgW/cXGX9OgqzVbc29A4Y8Qb6Da8/UB7DX7Mn3HANSRVwVvSs9NKSsJ8eVTJljJ54m+K0bQHCiVa93HfFS4i
 gllyDyCo
 WoRV26+U1Q7y7WqOCE9TgnPI6go04ks1S6TDosRl/TmHJGXjeXuLsrX187o0LLz58UjyH5CMi9tvSZk3lYKPcEA0TWw7DnrH/ZXmnkaoy5K5n1AWpAQrII4JvlcmmgoFv8HWd8vnEEpesKJ8Dc69NQxxQlM9dINCxke8ZPDI+n0IGtM8rBMF1V4EovBQ7dtJ4oR8jLVpvFnTof38vevmGpKpdWM9TzF2eR1nFweJwbCoUk6kCI3CPFCrKnDbFRb8ELNChgnv1ZYnk4q9xT+6PMNJpU3yDkt7sY1PkyovSm2QkTP1WuXEV1amdW2jkPPlNVx1W29HTaBJxr9XXnRBIUQFHWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Asier,


Thank you for sharing this nice RFC patch series!

On Mon, 2 Feb 2026 14:56:45 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Overview
> ----------
> 
> This patch set introduces a new dynamic mechanism for detecting hot applications
> and hot regions in those applications.
> 
> Motivation
> -----------
> 
> Currently DAMON requires the system administrator to provide information about
> which application needs to be monitored and all the parameters. Ideally this
> should be done automatically, with minimal intervention from the system
> administrator.
> 
> 
> Since TLB is a bottleneck for many systems, a way to optimize TLB misses (or
> hits) is to use huge pages. Unfortunately, using "always" in THP leads to memory
> fragmentation and memory waste. For this reason, most application guides and
> system administrators suggest to disable THP.
> 
> We would like to detect: 1. which applications are hot in the system and 2.
> which memory regions are hot in order to collapse those regions.
> 
> 
> Solution
> -----------
> 
>      ┌────────────┐           ┌────────────┐
>      │Damon_module│           │Task_monitor│
>      └──────┬─────┘           └──────┬─────┘
>             │         start          │
>             │───────────────────────>│
>             │                        │
>             │                        │────┐
>             │                        │    │ calculate task load
>             │                        │<───┘
>             │                        │
>             │                        │────┐
>             │                        │    │ sort tasks
>             │                        │<───┘
>             │                        │
>             │                        │────┐
>             │                        │    │ start kdamond for top 3 tasks
>             │                        │<───┘
>      ┌──────┴─────┐           ┌──────┴─────┐
>      │Damon_module│           │Task_monitor│
>      └────────────┘           └────────────┘
> 
> 
> We calculate the task load base on the sum of all the utime for all the threads
> in a given task. Once we get total utime, we use the exponential load average
> provided by calc_load. The tasks that become cold, the kdamond will be stopped
> for them.

Sounds interesting, and this high level idea makes sense to me. :)

I'd like to further learn a few things.  Is there a reason to think the top 3
tasks are enough number of tasks?  Also, what if a region was hot and
successfully promoted to use huge pages, but later be cold?  Should we also
have a DAMOS scheme for splitting such no-more-hot huge pages?

> 
> In each kdamond, we start with a high min_access value. Our goal is to find the
> "maximum" min_access value at which point the DAMON action is applied. In each
> cycle, if no action is applied, we lower the min_access.

Sounds like a nice auto-tuning.  And we have DAMOS quota goal for that kind of
auto-tuning.  Have you considered using that?

> 
> Regarding the action, we introduce a new action: DAMOS_COLLAPSE. This allows us
> collapse synchronously and avoid polluting khugepaged and other parts of the MM
> subsystem with DAMON stuff. DAMOS_HUGEPAGE eventually calls hugepage_madvise,
> which needs the correct vm_flags_t set.
> 
> Benchmark
> -----------

Seems you forgot writing this section up.  Or, you don't have benchmark results
yet, but only mistakenly wrote the above section header?  Either is fine, as
this is just an RFC.  Nevertheless, test results and your expected use case of
this patch series will be very helpful.


Thanks,
SJ

[...]

