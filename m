Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B899FA0C22
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 03:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 790896B0092; Tue, 14 Apr 2026 23:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7686E6B0093; Tue, 14 Apr 2026 23:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67E3B6B0095; Tue, 14 Apr 2026 23:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 54BE46B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:30:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8EA38C18FE
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:30:47 +0000 (UTC)
X-FDA: 84659363334.12.B0DC098
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id E7F8D10000C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:30:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lLkup+6r;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776223845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxiISHwatfYyBpYrcI5ZkUw+BZUuOyeCx68MCny46Mo=;
	b=TS8rpzWqRfK8Z92D6j/S7pQ/l/FnAe7ZqoPMLNry6bomVt6JEHX+8h5qtWUvDHU/tAamjb
	ZHmQ0TrRJXaLPnQvAvuLR2XFKcIiu55pcEHR4I532VeQWpv778PsAroRGJIDWjOhNEF6hf
	0DXvxgVb/zmMDGxcGDLOmUEjo9gDfJg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776223845; a=rsa-sha256;
	cv=none;
	b=m4NNhqeb0ra/2o8CF+PK0RV0Vd0IFlgl81w0v4PrPh5FMbvmT+eTeF2H4w3BgfHN4GUmxA
	Kd4v7FadLQji6XkOTJi5hbYhuBI6u95OfdxWYAzwDzk2DQjLmcWMpqrr2UGOwaO5xbgLjQ
	4dGyUSgd/+c0LfFpnce9LcitXbteqD8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lLkup+6r;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776223840; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xxiISHwatfYyBpYrcI5ZkUw+BZUuOyeCx68MCny46Mo=;
	b=lLkup+6rYey6AFn5uUNmXparPpj/dmDS0aQCtnv3tLnVn61eavqz8lqX4cOEqxKjsBN5e+DIOPYdS7580++MW0QCu+Rfn6s6VcMIk2FLWWHNSZqUvZJZB/MHSMrZPsH1386bRvJxX21KXxh+OA5rnJJvroXFvLGxpuxekAR51lE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X136NgQ_1776223838;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X136NgQ_1776223838 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 11:30:39 +0800
Message-ID: <1ab805f5-42c0-451d-9a81-0c96c1e2808c@linux.alibaba.com>
Date: Wed, 15 Apr 2026 11:30:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/14] mm/mglru: use the common routine for
 dirty/writeback reactivation
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
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
 <20260413-mglru-reclaim-v5-9-8eaeacbddc44@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260413-mglru-reclaim-v5-9-8eaeacbddc44@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ffxr5zmwjw7mpi4eisi5fgigxcms4iaa
X-Rspamd-Queue-Id: E7F8D10000C
X-Rspam-User: 
X-HE-Tag: 1776223843-271944
X-HE-Meta: U2FsdGVkX1/6riKMimOQoeAu4AM5hpFVfp2UbzQN0AhBrpM2qBkq7nGvu78w+qumZSRZcq08vw/HhaLLlRB3dcWBReMKLw7fXj1SI3I1IRqwPrKGZ2FgMRJwdMbuIrLWsaUdVT5pweZ2t5AB/F6S3lyWz53TrJXYpgS3UhauQL/ugYEPmeQwX1BT/50FpzfIAK4UVN40to7PgtEesAvAalX92GQK5539okK3+TBHIN9nzJ0no28JX12PVYyO09pVnphPNF4I8yGPA/Q4pvIkgB4p6qSygJmi+ogdPUesWpySUhBoW0W2krQv4kL7N815sT0p7IAeNbXt9L0ZT5/AyRTcOg7vmSLA3JqZByVmnl35od7sNOdEBb/dnt5zBnK1tD7dYkX1TGThmoavEPhmyUKxYBd44b+l2G875F4tP2xjfQA/KgjhcuZgUodm+7n3U0uwXBGXgeO9GxIKdLEcJy3mLyR+EAGPzHUqSFf8H3ruLjBGa/AZPEesmJDqRIsGX1RKMqjjkdGwHVOc1BivHpu3GXf+kOrWQvT6hZXd9yzet9YgRyYiI5UKgLabIXdqJmkS89JUOhN39W4pQvLervW4WSUwB3LaVm14/9WLtWEG2vifGVsFleGQp2YI2EMrS8m7Bscr/th4gMx4t9fX/ALL729ntkiIO5MECtk8wFYLqG7q0rn/83tJwv8ob5iLlc43qfyy0zuZmxNFKFtN6Kufaqp5uGbSujcPkYkAP74PytTZJww1xooqRrFhyOswcMLSj8KUv0ii7bPndxlfKXl03LZLjTjKnof3hjtm1JR5Tf5LP42SIC1+RPd9MfqPWVURE9AxTjS22Szalw4cDtS3mHZGBbGXjjsZ8zjeOH9PJWN/zGoqQwuJBX8Skw1OT8GMDGCPHQZA27WWR0pVG8jW5jNuK5Z0h5Stu8XZona/l7dPKYZohWD2jo/1YTcrLCv5d4wOf01+mQVja7r
 IM1N5teo
 fGiZuaTxgqoK+Y8RtGBz9la9ynDDZ2OrrWKq2M6HhKfdEZU1wFYsQm/FCl58lHbRSQR1qduxzmpyuwap48Ax9VdxWMJpthiDQF9uatO+HiDO5J8Ti2uhl6S8RAxKBDVeVNVj34MKyLta4Nk2GVLJ67DRh5wQApci7+Y4YbiY86BMjITegVCGo67kQLsPChNbqQxj9zqsd65krpG2htTjmEtAsyAXiZwUpG4d7rKORDOn1NpJAlHco5zdfPxuV9jVb/iEkB/QXrfyehdOFNHB1wfbOMsjXVQ04uBhgl59BYFzEvzC3ZFYKRVI4n7nhe7G6LYrNbJCLtJEMPh1+u9Tyd21VpcY7eWHrq4DTJXhZSYJZtt0P1khusuxywBIh2ow+P5TTx+NyoCzLORXXKKuIsBpHVUw2h1ElSdCWcMsLI329j11LjCBoRP4cr/e1TH6sBzgW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/13/26 12:48 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Currently MGLRU will move the dirty writeback folios to the second
> oldest gen instead of reactivate them like the classical LRU. This
> might help to reduce the LRU contention as it skipped the isolation.
> But as a result we will see these folios at the LRU tail more frequently
> leading to inefficient reclaim.
> 
> Besides, the dirty / writeback check after isolation in
> shrink_folio_list is more accurate and covers more cases. So instead,
> just drop the special handling for dirty writeback, use the common
> routine and re-activate it like the classical LRU.
> 
> This should in theory improve the scan efficiency. These folios will be
> rotated back to LRU tail once writeback is done so there is no risk of
> hotness inversion. And now each reclaim loop will have a higher
> success rate. This also prepares for unifying the writeback and
> throttling mechanism with classical LRU, we keep these folios far from
> tail so detecting the tail batch will have a similar pattern with
> classical LRU.
> 
> The micro optimization that avoids LRU contention by skipping the
> isolation is gone, which should be fine. Compared to IO and writeback
> cost, the isolation overhead is trivial.
> 
> And using the common routine also keeps the folio's referenced bits
> (tier bits), which could improve metrics in the long term. Also no
> more need to clean reclaim bit as the common routine will make use
> of it.
> 
> Note the common routine updates a few throttling and writeback counters,
> which are not used, and never have been for the MGLRU case. We will
> start making use of these in later commits.
> 
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

 From my testing, I haven't encountered the case I was concerned about 
before[1]. So far, so good.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

[1] 
https://lore.kernel.org/all/703627b8-4c7b-483a-8c5d-379d98400154@linux.alibaba.com/

