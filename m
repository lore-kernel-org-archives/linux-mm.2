Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50503CD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 08:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100816B008A; Sun, 14 Jun 2026 04:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D85F6B0093; Sun, 14 Jun 2026 04:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 014D66B0095; Sun, 14 Jun 2026 04:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E4ACF6B008A
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 04:20:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62F24A062B
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 08:20:16 +0000 (UTC)
X-FDA: 84877820832.08.247AEF2
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf23.hostedemail.com (Postfix) with ESMTP id 518D1140008
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 08:20:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781425214;
	b=Swj4dY+dghP6o+S5wujgeL/HqNj1QHob6cjUPIEnLs3iRh2JbAZR1nIHsDY3Oszsv1MYaH
	lGTtXUW++AAkYOvVIkpWlt4iXi2nGTd74VBptTg0AAA+gTDaFPVc2cSrV97OnqvXaLhMDE
	IGvYTq4dBsEP+8qJnBG0HYIMHHJWZ2s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781425214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MPj49JwpffUdWDL1rpfbzvHmbc1WoBn50aPFnD1u/vs=;
	b=Jyg7k0q/8spbpmhjpZfqpd9LieauX7sYwVrCzp2qN/qfAWg0Kf6wirLp/QCh9LXYNerpZH
	4fEHUXKQmZGAXu/uo5aIlZoomq+EFJYKYC+H2XAjxZ1xWQcXaek2+cY8WCpji/oyX1Niek
	i2XTrlqgMi190GPOWUgJ3idIezZjpxk=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 14 Jun 2026 17:20:09 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sun, 14 Jun 2026 17:20:08 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, chengming.zhou@linux.dev,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	riel@surriel.com, gourry@gourry.net, haowenchao22@gmail.com,
	kernel-team@meta.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/7] mm, swap: Virtual Swap Space (Swap Table
 Edition)
Message-ID: <ai5kOOmR1LPTWs1J@yjaykim-PowerEdge-T330>
References: <20260612193738.2183968-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612193738.2183968-1-nphamcs@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 518D1140008
X-Rspam-User: 
X-Stat-Signature: agcdynixtaqkxypkj9c7zs4sa6ht5t85
X-HE-Tag: 1781425212-940629
X-HE-Meta: U2FsdGVkX1+lqyqytYDcECLrqJ2kHM2CBCxtWtm7xgg5jeDOhfZSNT3hVrsSAoWJy+plVzBrh3YxbX5bnN3Wi+aBvJlV47vtArknz0+IbX65KAWb9PciKwuRRsXnKfLD8oOn5pZ7uVLg/nHdexiBPDRyLiXfai0hmhknze0UKks8El2e6D6TTO9VgryLXJRY9A4LPCIS989ciX57ac65JB4n1dUKT6NawcT9NyPBOhLtt5xlZ2IH8Ui7k26QJYyFgfBY7avw8QH5v2DTCTqWPs2ExOw/v18eV7079Wz8fo8YFTcPISd4muLV+wDicQDC/rNypIifpxn1+3G1VrhWHv9DVSR4+Mcd+ruenF5yGejuOrRrcw+UtuFmsrAz+F5Pyv3GVk6ZIoVKfiLOGofuObHc8udA/imnZAS2ifwsJpXAH8u6e7KElqc7tauKBtHBWm4pickvUzHktZGFuHrfUkzZ+AA30oOvuTGa7LXDqMcwFEup3QwWE+2zji0IMhXTopqyVHgV4q/aLvW/xuITHK7KvlDm2JOR0AS/8EhnfhM9Vggc2WF6PJb5b+pDSaQEgYeRP46bfaHG/KcS45tRWYeV563IYqp0QpuR7Vy6K8MJlHQwcLYOJk5tbk5X+SZUPhNp9VHQhU0gaXnrCwIxcGvgKIFv/bmIEui14Bj+OWS4siZ75uUHM2FBGJkxSFUcMrzGFwan4MrgYr5wMK3HNmLh4EuPZU/qyuPHgGKRRmdNP0/cASI2o0RIuc2ytas162yezJ9tMAS9OCQYRuZu/pAjg+8ITmkRAcMk+BzqjnwRHV9dA/PoGA/C0IbeeSyjm7hHxAHN1WLsv+8m4SohleJZtD3r/lL3xKX3OqDHxBUhzHwSRvn0KOWBvi++PUEWjHsYxFFfrDyVcc96Qu5ch9ICd6wH58Ds95Bk3ZD3oRN5QrZrHs2RPB7YIFR3RTHfrAq+f0sw9+HYSUczmDh
 jGeIJBe4
 MrR1yRIPn5FdkZasujT76gBK8iLjJ62Pxfe4dJFI3HyWWv1+KNI9X/rs3vrJMoozTrHQfdUs+WvhABzbQcWw4YDY6mG5+/Hjyr/q1jGFQbA3gbMPBBtTEo3LDmtjRhYLdHFq9AwZcXYrqDAo45s66oNZwTBqixq0YTv6ysDDaVxI6/bnuZ28i102TbzCFpShaEa4eSuMn3Po7N2ZYV00m5Q7Vw8mCZCPr8KP/Z96KGZHP47LRffrm/rNNLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

...
> * Integration with swap.tier by Youngjun (see [12]). For now, I'm
>   leaning towards opting out the vswap device from swap.tier entirely, and
>   treat it as a special device. Integrating it with swap.tiers will
>   benefit the cases where you want some cgroups to skip vswap for fast
>   swap devices (pmem), whereas other should go through zswap first. But
>   most other use cases, either the overhead of vswap will be acceptable
>   (or not the bottleneck), or we can just disable CONFIG_VSWAP entirely :)
> 
>   Youngjun, may I ask for your thoughts on this?

Hi Nhat,

Tier 1: VSWAP, Tier 2: ZSWAP ...

I don't see any problem applying the desired functionality with the
currently proposed mechanism and interface. With this, a user would be
assigned the default Virtual -> RAM swap tier, and the overall picture
becomes one where swap tiers are composed according to the priority
setting.

A few more thoughts came to mind.

Shakeel also proposed a per-tier max for the swap tier interface.

https://lore.kernel.org/linux-mm/aiw2p5ANjsQUCIHA@linux.dev/

However, for vswap, rather than treating it as a case for limiting the
amount via such a per-tier max, I think the current interface is the
better fit. (But, as Shakeel mentioned, if we only allow the limit
to be set to 0 or max, the usage could end up being the same. I'm still
thinking this part through.)

I have a few other thoughts as well, but I plan to raise those points in
the swap tier discussion thread instead. Please take a look at the
related thread, and let me know if you have any opinions. :)

And I'll share more if other thoughts come to mind

Thanks,
Youngjun Park

