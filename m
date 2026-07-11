Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EBE2C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 05:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 709D96B0005; Sat, 11 Jul 2026 01:32:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693EC6B0088; Sat, 11 Jul 2026 01:32:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55BB56B008A; Sat, 11 Jul 2026 01:32:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 313BA6B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 01:32:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB5DD4064C
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:32:24 +0000 (UTC)
X-FDA: 84975375408.05.71C0E94
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf05.hostedemail.com (Postfix) with ESMTP id D5808100005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:32:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=deige75K;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783747943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5NmJY2iw9mr7LiD+wBGyisuFVRNUZ+aiJ7vkuUhCAE=;
	b=Xo8TyscrdAXZzSn7u/A53U5K4CmS+ya/Ifobq3YfnDJB4fs6COkg9nkLrE7LNgOzfvUM30
	u21YbPJlwOA7XNR8+/Wkuzv8wLx1sMcleJ5rUwiyouHgSwhptAQU7lk5PaRSoElid7C9+2
	bc9fQKMOP6fdr029q7Lo3kWbOMHV4wU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=deige75K;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783747943;
	b=MkVg5NqTxZVOmrcPXQzHgbCoQErgO/lKxv4oQDTIhxe6KkzOsIzFGwF+8ohSTkhj4RVX0J
	chTxq6gVSYxXH7MCx6Dvl0hSuB6AY0bernaicjSjWtEfSM0peCvt+FYan2NehK+/lbALPE
	9lkh9ud+ok3iTE1+Nlh/kcENCkpWrUo=
Message-ID: <ab1bdfa0-7382-4d26-a65d-68eb172eb84a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783747940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G5NmJY2iw9mr7LiD+wBGyisuFVRNUZ+aiJ7vkuUhCAE=;
	b=deige75KcMd91XGDV/xznNzEracNWg8yXfEIAK9/OOOe8uqF1uoLyRtIg5SSGFwX2AQ8jc
	WqXflyjQsmlcZq67w+XQRJVVFQ4k2yAoCA5Pj3Ag6IHox67Nho1Z+EK2liTxHbD25RhjwS
	8hKFh1eTpSfmQhoXQoLcCR3KpQ6sEZA=
Date: Sat, 11 Jul 2026 13:31:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: shrinker: Fix double-free in alloc_shrinker_info
 error path
To: Hongling Zeng <zenghongling@kylinos.cn>, akpm@linux-foundation.org,
 david@fromorbit.com, roman.gushchin@linux.dev, muchun.song@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhongling0719@126.com,
 stable@vger.kernel.org
References: <20260711041954.95749-1-zenghongling@kylinos.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260711041954.95749-1-zenghongling@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D5808100005
X-Stat-Signature: 4t1eorwitf31kuqfptztf4syzw6zk1yp
X-HE-Tag: 1783747942-131605
X-HE-Meta: U2FsdGVkX19u/AWsgUbVlXSq1WKRcvU7bqlf7RAAEZw/18b0qsb9WWO8hvNKFzQtik+Xa3Z17fCwhisbA3bMxqeDoTvprCXVSSSOrY3Mkj5Pk6wJy28FhuEFQPrFUGt0ChCFeSdaFIthgMBpf9BiuFRvbr7mKK4HVvKKIzSZPngh4amEm9RFMtOn5ex0+Gur2UE/8bgg/O3QVnqO8dCkclW/nIOrFCx+xtD3rLD0XPuVsmD/o7igtQ/t7cZHO1YG63NLN7lEtkC5v5+0QiDXCbadDwF1UlijfYiAwzSFhLOXnOSHvT9TWiZcNkBmjrY+qjc9PrH03OyUWxmExOziLBeQ3phJL3yJk3ThKe5vjzbTLXqzyb8B+1bfDRhEBtQC3LczHkH8fyeItHjcYKwRHWrCyMYrOLzSfi9bMipiFLsM7Tkf/HvTbIYJigrGi6MuEttcZ9bM2ghKt0qnS2YsbjyhBVgkQQ7pMDcnTZAUE1y3L9k/PIh35tYIEVk9X5OxBeTuvLZZrPOCFfGRpZ3f/xdUKnwfcqjhAsVs4l51b6toNWnTVtVZhnMZPi6pAVhxteJFne9XrDACJJ2kHetIIAY3Lsews4EJbaK0Vi1QYiqpk9nTMa1zryfkweViATkuoWhVrHtykW7h5709sXdjSqhaUiiGT3lfmWOzpR5mrTvL++chPvc5vtfC2ccKCfxGKlO9AwjTprrxJ2oA3DayarZLPT0MKcNbh/H7xu+6j5CahoZQc5MrtNx/IqGpfwY6uu50uT6lb9K+1jCQmfa76CB3lH25co849GgrS/CTD2yX4DaZqeF308GrGzF9ihAImSxo0UE1uVaP1A+jWv38pCLH2GFJGVkj89jNfWmDBwsxXiGoa0oTxHWSAOe3GTZqDHsOYArWbac/Fg8moSz1vzZBWHZ3hYgaWWuxSVrgg6y1424W6H8wP0CpEXJ6Ijs9PPpqq6hXRNEzJyTnHRm
 v0RQg0QO
 DoIu42AIbyN7YbnlR2OCoPliC6hNkz93INaavf/T+zqXId3PSwJtARK6DdlZBPsSQnFdNU9vLJlUczhg84y215uPwQlvMbaJq0zrk6I1f9qDq9cjxq/avpnGajUiENLAyyoWO0s+WOb6UkW3X7bawBOO/9ShYa/zdLaWqobhJU/2KhBh8pdBQk+pgfsk2LL49xqzZswqpci/yZPxRwk/6BXwNc/tEFAHPFU88mqhE9+Xbf5TEMpoqGHgtqGGUNjl0wS8RGcRKDjHXbD/vdNjPt1EAMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hongling,

On 7/11/26 12:19 PM, Hongling Zeng wrote:
> In alloc_shrinker_info(), when shrinker_unit_alloc() fails for a node,
> the error handler calls free_shrinker_info() which iterates over ALL
> nodes and tries to free their shrinker_info. For the failed node,
> rcu_assign_pointer() was skipped, so its shrinker_info still points
> to old data. This causes double-free of valid shrinker_info structures.

No, it will be NULL, not old data. Therefore, the double-free you
mentioned doesn't exist. Before sending the fix, please verify the
problem exists and your fix actually works.

And as a reminder, please don't repeatedly send identical patches:

1. 
https://lore.kernel.org/all/20260711041509.92926-1-zenghongling@kylinos.cn/
2. 
https://lore.kernel.org/all/20260711041823.95135-1-zenghongling@kylinos.cn/
3. 
https://lore.kernel.org/all/20260711041954.95749-1-zenghongling@kylinos.cn/

One last thing, please make sure to base your changes on the latest
tree.

Thanks,
Qi

> 
> Fix by tracking which node failed and only freeing shrinker_info
> structures that were successfully assigned via rcu_assign_pointer()
> in this call. Failed/unhandled nodes are left untouched.
> 
> Fixes: 15e8156713cc ("mm: shrinker: avoid memleak in alloc_shrinker_info")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> ---
>   mm/shrinker.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 7082d01c8c9d..92c6cb455fc9 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -78,6 +78,7 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
>   {
>   	int nid, ret = 0;
>   	int array_size = 0;
> +	int failed_nid;
>   
>   	mutex_lock(&shrinker_mutex);
>   	array_size = shrinker_unit_size(shrinker_nr_max);
> @@ -98,8 +99,18 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
>   	return ret;
>   
>   err:
> +	failed_nid = nid;
> +	for_each_node(nid) {
> +		struct shrinker_info *info;
> +
> +		if (nid >= failed_nid)
> +			break;
> +		info = shrinker_info_protected(memcg, nid);
> +		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, NULL);
> +		shrinker_unit_free(info, 0);
> +		kvfree(info);
> +	}
>   	mutex_unlock(&shrinker_mutex);
> -	free_shrinker_info(memcg);
>   	return -ENOMEM;
>   }
>   


