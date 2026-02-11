Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06E1EEB596B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 06:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DAA46B0005; Wed, 11 Feb 2026 01:59:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1888F6B0089; Wed, 11 Feb 2026 01:59:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A5D6B008A; Wed, 11 Feb 2026 01:59:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA98F6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:59:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8D3AD13A00C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 06:59:20 +0000 (UTC)
X-FDA: 84431274480.14.32182B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id EE8A2120002
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 06:59:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=daQmtwYN;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770793159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tBn5n8aPka9wCgKnvtKbuQYSjFuoDfCpO8DWt0KUg7k=;
	b=DQM/x01fZ6SytVskkVV+txW8YCULUdpPf+GivkUgjKmIs6lkjelSc/s4gWen5yCDrjjP+k
	1/emnqQYXVyEadjyj2VLvqvHe1Z2+IAGU9pOGF7n1hUxFbpXX7xO1KcE+LqDkmFZFQkpyI
	A0lt1d2xleMC/jIctE5wrN54ll+bMw4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=daQmtwYN;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770793159; a=rsa-sha256;
	cv=none;
	b=3zEhSGnELVmUt25So7ygXL9nLXzNPH3m90wVnP5fEf4VJkg2wTc7ZSh/OI5sUxg77EFUmh
	XB1GE0+mE4HCpqjWN248Rh2OXoIxi8mNlQaG7kMt01gvqbvocIhjJU8JWrGblbnEV+ApJK
	H4m6/t/CHTTWzg1MQpRA6ny8Lm06uTo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51A2160018;
	Wed, 11 Feb 2026 06:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49C2C4CEF7;
	Wed, 11 Feb 2026 06:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770793158;
	bh=rclUdVW+gYi3vSJidp7DNr34hFtP2+tfLi6yHa+zmwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=daQmtwYNuAqsJUQHTDrvZf8/bIzvWnDmzifjZW+ZzMtug3jXXhRvaLh80p9eTEzbg
	 gSi45aZxI7ri98rUSaNBG3V5PTuWrFX3fXlwShfB8izNeU2KaFL9J59yNFSwvIG4Vw
	 zCX3/K37sX4uyf3E1fdCufQpZxkZ21jQ8te37SNJjKca+j8A2aWrED46May48oxVAL
	 EGbJbMOb2ka1cPlTF5yLQ/6A8pJAlggweOaWQFrWBz/GP3gS3lXlogcP9yOGsNyNL2
	 InEfiGmU1pexSBueCYTgJzsufV7gJVwg5Ms1fY0xWnsVICq//9/Nn4zh8BQNnyfWfT
	 KyUIvZIga8lwQ==
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
Date: Tue, 10 Feb 2026 22:59:12 -0800
Message-ID: <20260211065914.68174-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202145650.1795854-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EE8A2120002
X-Stat-Signature: 8fxhwagx54ie9rgo9cxfz54mowob9mhd
X-Rspam-User: 
X-HE-Tag: 1770793158-663743
X-HE-Meta: U2FsdGVkX1/KfQF0b1iLKMl/ChIU7TuQCzCaGOxgCFrlVhEP/nLjgUeJYEhbrE2Cm/A+v/OS1YgTFUkhXdTxl/pUK1pudx++9SZQ1k0VQ+lECzbzM8xHvlki0QvvUWF6OmPBm9sBFQm//VIhx8BwpU+sYxAwK1iv3Y1oc/+ZB9U+kD1dNLWOKr3UYW1BR79k1FMsZDjP8bWRr9sR6SIPyL41KILL6JtK7BFL3d49oiyOO59UsDDsiJlFclsCa4DWGMOPE3frw90wqfthNS5AsRt3ElyWga4E52Irp5W2BNRc857a4l24c4/nWsy6qr1Mr7p+8i0aIVl7JzRV1w5D0waT4ph6OWSLhNCa0Uj44q9PTtib4rUWfiTQlCqrlAECMdIgrFR0adAnQKSfSGsPa+84IqYmZc1FN69PU3/OHF2fqIvvXUMkyo3wAuCiK25hgquK+gwem0N8HPHgSpBFLCicxiQZvuDWgW1b6YSvx7JpOsI+JOdbOiBNgjP6WMVNpAsYA6P5Dxlm4ffxu5i6RvsQz8YmlAGXzviT8awYTGcHQNITY+KeDSyMOEJjQunBCXcR5Y0BacxJ3sDaFVhvvaOIyXAa6tR+zyaLkq3jv5Cm0XsYRGrRgs4vEFaoFKuok4IEwiGVVXVYspIlFmSxA/zFrWxUaAwlTxUSUJJp8qpiKN+S7XCxtjfblGJKhK8XJJA9Uxt9vGICs2UXN8diFQK03W7ZFmnc9hnxzf2cNEdhcXpo6GgJD7mYUY20lYN2vaSxFLmO1aQNDOaQfvgpVhNm9uBkFZJ4WNrq0vCxdrEPsd2W4xCmvUyJWjR1J1g6l6Qu/Biayl/kTO+RLJ3YrGhts70mKe6dvoEGr+CqmjDcKNkxoSiClHUgpNlNJm2MF+dtfUCflptFhSZhhPFoMzTIpwbnxIm23HCIZiQp5jRo8C8zPMh8y9ys0u5Mr9DcqouwZXr85UxBXeP+MFE
 5xtcB/ks
 6ngnpUdsNt/MPl/PKb07MVbH38ojp6D6tMIzWkAmQZWG0oq1w8ET/BbEHvhJmpCuxVR5L8bMs7OvCFcyabY3Ap/ChxxRAc3KXUCKw2oWnD1YLSUhojz/x6qv6MvE71Z8bxy9WzRX5Jw7YgrHnWNmezcFVir4m9p4uCnCsMGsSWapYpdCugftprAvxItxJJNPvyysn1g/yBlNyrfZB0QFHEf3ULMEAqBfQtiGCw5MFOJNKjlXb9UPInd6ZzMdbppcJPzZrsmhehJ4MWE9UTtAA/4tgKYeeGu6ShubK49Z6AzJ86k7pKm2TJjAYuJPdIihvzP64I6yoMDhqR+Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
> 
> In each kdamond, we start with a high min_access value. Our goal is to find the
> "maximum" min_access value at which point the DAMON action is applied. In each
> cycle, if no action is applied, we lower the min_access.
> 
> Regarding the action, we introduce a new action: DAMOS_COLLAPSE. This allows us
> collapse synchronously and avoid polluting khugepaged and other parts of the MM
> subsystem with DAMON stuff. DAMOS_HUGEPAGE eventually calls hugepage_madvise,
> which needs the correct vm_flags_t set.
> 
> Benchmark
> -----------
> 
> Asier Gutierrez (4):
>    mm/damon: Generic context creation for modules
>    mm/damon: Support for synchrounous huge pages collapse
>    mm/damon: New module with hot application detection
>    documentation/mm/damon: Documentation for the dynamic_hugepages 
> module
> 
>  .../mm/damon/dynamic_hugepages.rst (new)      | 173 ++++++
>  include/linux/damon.h                         |   1 +
>  mm/damon/Kconfig                              |   7 +
>  mm/damon/Makefile                             |   1 +
>  mm/damon/dynamic_hugepages.c (new)            | 579 ++++++++++++++++++
>  mm/damon/lru_sort.c                           |   6 +-
>  mm/damon/modules-common.c                     |   7 +-
>  mm/damon/modules-common.h                     |   5 +-
>  mm/damon/reclaim.c                            |   5 +-
>  mm/damon/vaddr.c                              |   3 +
>  10 files changed, 778 insertions(+), 9 deletions(-)
>  create mode 100644 Documentation/admin-guide/mm/damon/dynamic_hugepages.rst
>  create mode 100644 mm/damon/dynamic_hugepages.c

By the way, I proposed [1] an LSF/MM/BPF session for access-aware THP today.  I
also mentioned this patch series on the proposal as one of potential discussion
topics, and Cc-ed Asier.

I just wanted to make sure that the proposal is never a sort of implicit
request to hold the progress of this patch series.  Please continue discussions
and revisioning of this patch series regardless of the proposed LSF/MM/BPF
session.

[1] https://lore.kernel.org/20260211050729.69719-1-sj@kernel.org


Thanks,
SJ

[...]

