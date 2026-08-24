Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79DF0C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 956516B008C; Mon, 24 Aug 2026 03:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92E0B6B0092; Mon, 24 Aug 2026 03:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8C76B0095; Mon, 24 Aug 2026 03:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B43C6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:22:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB15512044D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:22:24 +0000 (UTC)
X-FDA: 85135319808.26.8588DA5
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id E04841C0006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:22:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jJPb7wJ2;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787556141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpRmk6TT1hToBXTvKj7HZNsfvh/PfrqnzaVGpFG3TYI=;
	b=Xs8aCtnXEDRA1SnKwx4zwhKryEEaZFPlymErhQi482vp8CVMwnd0ILsQ7OYEygNWrlQ9lJ
	FjrqiBKuDJVeYCgRCanO5ZwHNpdntazgCcjz+P/SdFfH697q9InwUabD3aWSQHgD5nP+fn
	knGaxFZ8Zj+4W0mcNRur4HWZ+TtniK8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jJPb7wJ2;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787556141;
	b=X/lh0DFhlEFjQiJ/oIKXwKx/zMcdrJZZQo09HgzDahgQmyDvjI5TFXbhETGD73ucBdHhXX
	yfyKny66kPT8171LcnNnLflpJGbIbyf7ncE5dCKx+al8D3jk2pjSYqaU5CDFMvjtEbfJmw
	oDTmFpwPz6NvqmgJ+//VNlgh5xWEusY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787556135; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wpRmk6TT1hToBXTvKj7HZNsfvh/PfrqnzaVGpFG3TYI=;
	b=jJPb7wJ2ZMDDxopNKIlzhrqR9ocTazwM5znf7z+giJP+OboGWWKqo4TQJJNWyO1juPIkvlWMkIC35GNc8HnenpkQKcFZvgkTqXO2X1LTQo6I2b2AIga/E0HbBOdnmoX0ThnXszRuOFKsRdo8RFNKg8k+3rg1twDLqVBrK9yPV40=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0X9U07yk_1787556133;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9U07yk_1787556133 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 24 Aug 2026 15:22:14 +0800
Message-ID: <7e897a4e-2075-485a-8cc5-5bb928fba437@linux.alibaba.com>
Date: Mon, 24 Aug 2026 15:22:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm/mglru: clean up isolate_folios and scan_folios for
 readability and clarity
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baoquan.he@linux.dev, chenridong@xiaomi.com,
 david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
 lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com
References: <20260820045603.68809-1-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260820045603.68809-1-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E04841C0006
X-Stat-Signature: ou5ctc5k816imfqydosjk3c3pt3315r4
X-Rspam-User: 
X-HE-Tag: 1787556140-852452
X-HE-Meta: U2FsdGVkX18D5Oyh5gZn+zQltvHqZVs4AzD5x9cDSPTmevWpfeyxvbPeMxOpHKF0zLoj2D/rczLQ/rm5FLagjGArdOQSExJM4PyrTXFC23Y8Kkr6LYUm+WT4DCpemCrFc/1OInRI5W5y3bbeE1bRsmKT/K26r+5vEQiujmSgBHazWe9b8RXBz6dm8WPdDQKsTC/uimlv61YvZncqjPPUoNNyKyLo4uGmlXiQCx63RXlO8Ma8/ezIe/RFGlT7ChGhiCXplAGVrQpZpCKNf96dTUg5DsEz6uXnslKtB9XAOJwb97e1NuHW1E8diIH+3bqnnBp+hBtQHvLLJ/qQ2qafZhyHASV9gS23O+EFKxIaBzHtdO4EWp6RE63z+icoX5q516PiBwhkYQ9l58n1UfyWYKO9fpfs+fCBdiQTBcv12dYpg3hUHPlfzIdIrgBxKC66aV1i6a3BkqT8T2eCNZIHvHdXicF/Ez0mukA9o0xRcLLrkJCRmucXtXOfzhFlc3fcQaBJhNw23ocx4oUO72tDIQ1Epr+guTriFBRVaa++f8wk9iU7+4wTzPzGwcmi/imhiNWTfacPR8pxOEyb/d9eRw9Z7XT9b45RS545j4zQrZvYJjoTaC54iioBXECiVeq2q+uXAbDOqzXp6SsBISDgAGj5gagBOz9ZeEk9PhGJI+iIQCdDkvrO86ZE9IpIA52Z1iK+tg3wIMDtHQ4SB0rdWoMn1oSa18YvtLNBBD2nrFDisG72dFZVpK+QBGEAtiT7XZt8wQYW6NIkOlj9N1TOCkHGtJykRfA/Kxs/DkJg3Ezn4wTdzsoPhIXtnuWj1DXs6n/qUkmnSv1Ejf6f+x0NL0T9KHVw9ZuMQ3fmAmjPpiQ269shfqrjldR4gCbYIk3/7lUBGDpK1Y4Wh4YjFJgO3ncKeMEP1VM/eqRI4RAspE/hdoKEt5oXIG987kK81c2Ib0OG1m7hYlaPGU+0E7Y
 rE3FhrbH
 9fvNDpPHv15Y2E8h62dOwv5SahO1Z6pagS5gRHjWq4LyXoB9e4SsZ+TSTHpvC6sw5wS4Stl99vaP9/e4pMyU/gIXNvtHMFJr96RddxEm0zJjWuzqiKXxyuF4xEymYIEV2VL7aXwGIBWIh823eQ9Y2yyuTHQoHUgO51n2D5TvW7gVzONwEzfTTuNbD5wqOJm9wViWx/s1bmydIKmnfIpyVpGE/7vicBa1n9gsEbjf1FrkfjdXKEAHoj+j5c9KGvAGZJEty8yE2GdAUPyyqSWLseL8dwfpS9hm9OvxNG2PFl0kl0HOMROlJn84cCZLoveSYOFRxy/0Ep/XvX5OHa/NrIo8/wt4aoIMxDcfWDGrMk3XQtUCXS0iNIuianGJo4M7x7V+6eMzktJz4eYEKLuil3+kT3nGrD35CbNnT4kZYqSBiPxNcWN7NtmyOOkZIKLPIIvy5w7KoivdHc4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/20/26 12:56 PM, Barry Song (Xiaomi) wrote:
> This is a cleanup series split out from the MGLRU swappiness series [1],
> with the cleanup changes separated to make them easier to review.
> 
> Right now, isolate_folios() is quite difficult to follow:
> 
> 1. It uses for_each_evictable_type(i, swappiness) to iterate over the
> types, but i is not actually used as the type within the loop body.
> 
> 2. It uses scanned == 0 to detect whether the current reclaim type is
> exhausted, but this is not an accurate indication.
> 
> 3. It has an internal retry when no folios can be isolated after scanning
> some folios, but the retry is implemented in a way nobody can understand.
> 
> This patchset makes these behaviors explicit and much easier to follow.
> 
> Run kernel builds for several rounds in a 1 GB memcg and take the
> average build time. The patchset shows almost no performance impact,
> with a very small improvement that could simply be noise:

Just FYI:

I tested this patchset with a 3G memcg limit and a 10G zram device, 
running 'make -j32' to build kernel on my 32-core Arm machines, and got 
some performance improvement for ths sys time:
	w/o patch	w/patch
sys	1845s		1570s

>                  w/o patch   w/patch      Delta
> 
> real             109.149    108.990     -0.15%
> sys              223.213    222.592     -0.28%
> 
> pgscan_file      498,208    486,994     -2.25%
> refault_file     262,696    254,688     -3.05%
> 
> Thanks very much to Baolin and Lian for their previous reviews of the
> original RFC patchset for this part.
> 
> [1] https://lore.kernel.org/linux-mm/20260812121658.69965-1-baohua@kernel.org/
> 
> Barry Song (Xiaomi) (2):
>    mm/mglru: improve scan_folios() exhaustion detection
>    mm/mglru: retry the same type once if isolation fails due to races
> 
> Ridong Chen (1):
>    mm/mglru: improve readability of isolate_folios()
> 
>   mm/vmscan.c | 78 ++++++++++++++++++++++++++++++++++++-----------------
>   1 file changed, 54 insertions(+), 24 deletions(-)
> 


