Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D246C5DF6E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 13:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60BE26B0825; Sun, 16 Aug 2026 09:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BCA56B0827; Sun, 16 Aug 2026 09:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2366B0828; Sun, 16 Aug 2026 09:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1786B0825
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:42:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0341C0532
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 13:42:19 +0000 (UTC)
X-FDA: 85107246798.24.DAAA356
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.76.78.106])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5D7EF40003
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 13:42:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of dzm91@hust.edu.cn designates 13.76.78.106 as permitted sender) smtp.mailfrom=dzm91@hust.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786887738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qNZXuREc0Kiz9gXcG/d+OI/6mUnNPlZ0ioXHQ2B3RTM=;
	b=H8O96WOpj16StosmZWvtUMFL2u0r9o/s+IOl72phZXcNybYlP1/E1LCcbURMaOwqRA87JM
	Z/YqikQB8SCRcymjy3Up+Ho8/7+bOVDBCDxR8l2xOj9maC7I6uEqLPLhiU8DroLpWcn+Hq
	XILADgJjJKv4nbocDZjO2nPEjYNfEjY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786887738;
	b=gWNh+Tl0caCSAEbRp8T8pk57JFDrCuWwGEjg8z7WYizMeyLtJjuhB6LKFmVG5ZX33hlHHl
	Em3OG65IaONE9pGoK76Y7LIW8nSVsjfpT8Om/8xFciuaWSgSMq59oTfvkFNZqwx7uLsVvk
	rPdj8NjHq6UGPFsKEab05N61fXt8/9o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of dzm91@hust.edu.cn designates 13.76.78.106 as permitted sender) smtp.mailfrom=dzm91@hust.edu.cn
Received: from hust.edu.cn (unknown [172.16.0.52])
	by app1 (Coremail) with SMTP id HgEQrAAHLaL4vYFqm7F4Aw--.4588S2;
	Sun, 16 Aug 2026 21:41:12 +0800 (CST)
Received: from [198.18.0.1] (unknown [58.19.0.248])
	by gateway (Coremail) with SMTP id _____wD3cc72vYFqvdFFAQ--.16793S2;
	Sun, 16 Aug 2026 21:41:11 +0800 (CST)
Message-ID: <3ea1fd37-848c-4581-ac1d-c95f9fb5c672@hust.edu.cn>
Date: Sun, 16 Aug 2026 21:41:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] docs/zh_CN: update DAMON documentation translation
To: Doehyun Baek <doehyunbaek@gmail.com>, Alex Shi <alexs@kernel.org>,
 Yanteng Si <si.yanteng@linux.dev>
Cc: SJ Park <sj@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260812065914.3071433-1-doehyunbaek@gmail.com>
From: Dongliang Mu <dzm91@hust.edu.cn>
In-Reply-To: <20260812065914.3071433-1-doehyunbaek@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:HgEQrAAHLaL4vYFqm7F4Aw--.4588S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFyfGFWUKr17Kry7GrWkCrg_yoW8Zr17p3
	Z7KF93uas7tr13Zr1fGFWUJF1rAF48W3s5Ga4ftwnayFs5t340gr1UKryUt3yDXrWfJF13
	ZF4FkrW7uayUArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBYb7Iv0xC_Cr1lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
	v20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM28EF7xvwVC2
	z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2vYz4IE04k24V
	AvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj64x0Y40En7xvr7AKxVW8Jr0_Cr1UMcIj6x8Erc
	xFaVAv8VW8uFyUJr1UMcIj6xkF7I0En7xvr7AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvEwIxGrwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26r4fZr
	1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWxJVW8Jr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0yrW7UUUUU==
X-CM-SenderInfo: asqsiiirqrkko6kx23oohg3hdfq/
X-Rspam-User: 
X-Stat-Signature: m9t5i9cqq5xa54nd5t7w3i6dfwzocffy
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5D7EF40003
X-HE-Tag: 1786887735-469874
X-HE-Meta: U2FsdGVkX1+Lf3R3osV+fHu0j/hVTsGj8tNxZZ+EgPeUW69vV5T3E0DPArnX6D0aDWzSEMZo0SkLGM7mYlGAffPAg7bSOUjm8XyYlQAcmDzRTWsihda9wHmjtIuHJ5vTNagg3UKigsNcQL9KYMGKU8iATyYb+EeFCAGwI1t+FE4G1Nn9Rs9o2ROao4KSLiIO7qzFCBy64zPhWbX2Ra7aPoDZ5dycEse/P1O1xdm3In5+KBjkgTEXkv263IsLCO8LFVwtH6d0YenpMaJuG0J7nUKSutk/ADIthbL5G4RurQLfiUzCRXuJ0WgL5+g7jwzvwsgblbgiCzbkWcIioDU9gOyzVh3RP6ki2sYzAlXyY/NsWYjVV1wNocRc57kt+IbsXKlg7AcLDjDxzz7L1wcAT2tTxgr7FhF4OMrEjDJn/Say61OI87U2Ek9GbFHbwI15QFN624Sxx0xymwUF4xjC7aGkl0OG4pzWxX1ch5BcnfbsV5X45xKrvyZusO76iczfJDRAqiNlyoNuUiWpQN9gtUCrnR8ZGbGg5P3GbEdOWTOZw8hAS77BCRbzifsHkIoqTURXLUj73tmTPWqbZoFZ8DCEfs+4H2WqVK70IhqBZT/QpesltL/C6RbCw+yLnILmagbkXA4hH01T/SPHoguhsBk2rlwpcrYFXnFiU3qeK/9epBCwFohnQC3in6h1xrqUoEsUL9K6qMHVSZVG5/KERs/gspWA5/c1uRuKlwngJdsgvOpf/xnVJEDFd2xorMR9jxQb5KL6SIUSOhaomwyE/7to74VYnaHcmMhlWky7gn+VDc+4IoPUDb6CwRKKf70ztyxdL5UqD0t33+mhGlqU9wsCYuQBQZbYTp7AFMLKO0wvs1JDJwK6SOTwyX4j/aOARRB0uhS/vp84qO4EZqmGTiJRMYcmfFDmVokpZxg8GXnYni2bhmFYebKk99zq98hzN3j8J1wh2k3GDp2kZ86
 E4FJFq3T
 9egrz+aeq7SSl30RMRHPGl/7KFyZst5cpddxdMETNCWkF/MeYxAZoBbwpFvvaU+ZbkKzs8Xrvahc9KcrtLYqWwH1RlET3apOXm9aluSmN/wqIIUWONDeZMQE16AeNfF53/oYaim5ojngGIFdORaNXkVNDQKvBiZYGKQxO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/12/26 2:59 PM, Doehyun Baek wrote:
> Bring the Chinese DAMON documentation translations up to date.  Update the
> DAMON design and administration-guide translations, and add the DAMON_STAT
> usage translation.
>
> Changes from v6:
> - Clarify the DAMOS quota goal descriptions for the optional ``nid`` and
>    ``path`` parameters.
> - Improve the translation of "offload" and fix the duplicated character in
>    the non-access-pattern filter description.
> - Consistently translate "tracepoint" as "跟踪点" throughout the series.
> - Consistently use "监测上下文" and "聚集间隔" for DAMON terms.
在每个
``
聚合间隔
``
过去后
应改为：
在每个
``
聚集间隔
``
过去后
Please search this term in the zh_CN/mm/damon/design.rst. There is still 
one
``
聚合间隔
``
left in the documentation.
Dongliang Mu
>
> The changes were suggested and clarified by Dongliang Mu.
>
> Doehyun Baek (7):
>    docs/zh_CN: update DAMON design translation
>    docs/zh_CN: add DAMON_STAT usage translation
>    docs/zh_CN: update DAMON index translation
>    docs/zh_CN: update DAMON start translation
>    docs/zh_CN: update DAMON usage translation
>    docs/zh_CN: update DAMON reclaim translation
>    docs/zh_CN: update DAMON LRU sort translation
>
>   .../zh_CN/admin-guide/mm/damon/index.rst      |  15 +-
>   .../zh_CN/admin-guide/mm/damon/lru_sort.rst   |  68 +-
>   .../zh_CN/admin-guide/mm/damon/reclaim.rst    |  82 ++-
>   .../zh_CN/admin-guide/mm/damon/start.rst      |  63 +-
>   .../zh_CN/admin-guide/mm/damon/stat.rst       |  94 +++
>   .../zh_CN/admin-guide/mm/damon/usage.rst      | 523 +++++++++++---
>   .../translations/zh_CN/mm/damon/design.rst    | 667 +++++++++++++++++-
>   7 files changed, 1346 insertions(+), 166 deletions(-)
>   create mode 100644 Documentation/translations/zh_CN/admin-guide/mm/damon/stat.rst
>
>
> base-commit: db6ed2a3d31068ca5577466591b2521dee0508ca


