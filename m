Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01441109E556
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 07:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 641396B0088; Thu, 26 Mar 2026 03:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618DB6B0089; Thu, 26 Mar 2026 03:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5463F6B008C; Thu, 26 Mar 2026 03:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4215C6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:31:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 181501B92CF
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:31:54 +0000 (UTC)
X-FDA: 84587394948.16.EFA4272
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf04.hostedemail.com (Postfix) with ESMTP id E684240006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:31:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xClEX6AI;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774510311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SlrYYEPTUwcgSKk4qDq+lYdB7FJlgZsayA6Icmo5ezM=;
	b=VNXebZnnzSjWaStBljoP0xFiPCBA8pHsnd5ELpbcbT2zZBZcH5AGQ1nSk3cmS8Hsvx5csQ
	6RASHJEoXu+fNjC6qZxh+Kv/lMDuHz9BPkdMbLSbURasmrC3on1HwfPqt3iWzTI/wCctiF
	ratN3Q+lPmTea7hXkqeNK73zsX0ahg8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xClEX6AI;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774510312; a=rsa-sha256;
	cv=none;
	b=OwArx4MgwhpcUCSgLfxmaIVxWKASQkdrETcPJT/rF8QXLSujQQSyjgU5SjkmS4FJMHXHt0
	zJojZ6RYAdV6QBGM5GpmYyPxjj1ned3yC1X0iTkVfJ933r/GsoIGx1UOiD51IawJ3hZJ42
	gHUDWpxolbWSRpifxGd3TctjCDPS0sQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774510306; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=SlrYYEPTUwcgSKk4qDq+lYdB7FJlgZsayA6Icmo5ezM=;
	b=xClEX6AIZg72Q/qH1Tph13X1lHg6vq7UukBYz1LijFfOP3Btz7cguJCu3e5l6pJ09rwjU0iAHM6Ln2X4R3lEgsANaY4pKGYyxPb5oFqF0CO757eRF6MWBjLhT5kG63iHUx9b2gpnaAHnK7hhKHJ22kgO/QPl1vt74Xkd+Tyj0RA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=24;SR=0;TI=SMTPD_---0X.kcP21_1774510304;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.kcP21_1774510304 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Mar 2026 15:31:45 +0800
Message-ID: <e85b2d1e-45c9-404a-b973-119061d3f230@linux.alibaba.com>
Date: Thu, 26 Mar 2026 15:31:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/8] mm/mglru: restructure the reclaim loop
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-3-2c46f9eb0508@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260318-mglru-reclaim-v1-3-2c46f9eb0508@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E684240006
X-Stat-Signature: fzz7d5hiqpmekxhthoet9tntm85csq7j
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774510310-872100
X-HE-Meta: U2FsdGVkX19O7WDg/qdShJn1xPmhY40YOlT/iuCJ71TBM6yfs4rOsRIoOcH/mDYOU4Y5USnEY/UMyRZ0QF/zT66odwcvWq73NRaUtTZRzdoRjJ0w7tzTDhF/XT3qMnExd225GcqNNZ4jPrgeGazQXfpQP//L6RCF8deJitKKYbecfITR8E4EtXR0iSr/t7mq75uD9CZZ6n1lEo8Nri3H5uDLJZGfaxZi76605R6YqQszowHda7FxYmbS4SKhL7lxW4l8H79e+0Hy7R4QrPzeWqd+9Ccfb+T/GA9Jh9KAU7aRKP+RGlco68oY48Zv3qrrv+h0NtKWoy7PaRphG2QZZ32atdOPU0ipCQVDdQHeQ87sbF/C+D60wN1xU7r5tX2g/eoaD91KaagALbZt1EMmD46IaEDh0LIZ1rHUxM8p0VPw9ubxQwmE3obNs5/g1sbInRm1B6BrtphRWLmI/Qu99uHiLXT13hK8Hh+ktIs22dPXpjZzdlg2/mX8GbEKBS6U9bP0QyfIzwEM+jVLhBUNhPvYn2HgRz9Y1DspWwMAAGPvWQFRDucp/zuyvSkiSMwwsf2PaLVhVYVA8GIfDirOciQIZuKl0BqeljdCAuzy3E8pFQ5XY3XrraXVYt0eWzkqFjpxCrPFoFdCKGTlHkdJjaT2yaS6ljD4oSGTAhmvTU7GhHeAhl81jRy89rWgLhvNV/27l01zJyRT22VN4r5+pMAqgSy4XRs0zaSEfVQNh2UmXXRJA1g1qvWqeUr3tV03pSWqwoer+B0ttyohVykgp7Ih4oGrOlamhHxn1gDh9AE17l+ql3zaTvlXSFHSpMqs5VLqrDgxr5srDv1x8rHpctns2hligovbkv5FHlQDU9i2mV2d7iEZ6ZtESJu6JpTWFRc5e6/HbeP7jOK0aHMHWUj0Uu8C0Wd2VuMupOTUbP4iECRJ7CK054NHnPjq5xggHyfhOWu8Zr85cdDvV9I
 IExWXU9+
 IkZUlF9SJ4ZVgWRNqGf1zoSD0L/JQuO6t7ReXii/fAt9n7gjITUkA2S+/FJX9c0yxzcHlBjxaeEasnrPqV8zez/zy+R4VUnQgTtyn8qQqqBK8cxhLPV71hn2RDC/7kyFSDznMPNuwPLNq6YmvMbIFH//Gxilo+rShmdh9DpAbtEJtcDrciv5nD/84uLw+4LLkPE2CywITV69xcUr9qnhK663FCUE6yWumj/niwuF0PuGKkjkL/aSDXeewLnH0DRjyLfcMaf63l503ZoHcBfVyEojgmf85vcKMIMoF/LUXeLEGoUAufZABtEoBrrD4DJOogfoNR6fZ1zWaV24b9kMH/wYz2oqsBltrdJNY5teVHqOHujiOHsHFk0dWqPx2pLGeznPiF2jKthTdkiZKGHnWbxaG0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/18/26 3:08 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The current loop will calculate the scan number on each iteration. The
> number of folios to scan is based on the LRU length, with some unclear
> behaviors, eg, it only shifts the scan number by reclaim priority at the
> default priority, and it couples the number calculation with aging and
> rotation.
> 
> Adjust, simplify it, and decouple aging and rotation. Just calculate the
> scan number for once at the beginning of the reclaim, always respect the
> reclaim priority, and make the aging and rotation more explicit.
> 
> This slightly changes how offline memcg aging works: previously, offline
> memcg wouldn't be aged unless it didn't have any evictable folios. Now,
> we might age it if it has only 3 generations and the reclaim priority is
> less than DEF_PRIORITY, which should be fine. On one hand, offline memcg
> might still hold long-term folios, and in fact, a long-existing offline
> memcg must be pinned by some long-term folios like shmem. These folios
> might be used by other memcg, so aging them as ordinary memcg doesn't
> seem wrong. And besides, aging enables further reclaim of an offlined
> memcg, which will certainly happen if we keep shrinking it. And offline
> memcg might soon be no longer an issue once reparenting is all ready.
> 
> Overall, the memcg LRU rotation, as described in mmzone.h,
> remains the same.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Overall, I really like the code cleanup here, and it makes the code much 
more readable. Thanks for your work.

However, one concern is that you've mixed some functional changes (such 
as the offline memcg aging and shifting the scan number by reclaim 
priority) into these cleanups. This makes the commit difficult to 
review, though I think the functional changes make sense to me.

Can we split this up? That means you can send the cleanups as a separate 
patch first, followed by the functional changes in the following patches 
with an explanation of their impact. Then reviewers can focus on 
discussing the functional changes.

