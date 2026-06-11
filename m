Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC4DBCD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0875B6B0005; Wed, 10 Jun 2026 23:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037F16B0088; Wed, 10 Jun 2026 23:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90496B008C; Wed, 10 Jun 2026 23:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBFAD6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:30:55 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78F87140455
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:30:55 +0000 (UTC)
X-FDA: 84866205270.13.FC5199F
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5FE1E18000B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:30:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T0e3A5jt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781148653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9SeiToel+JcVkBJgaJtw5RlW+she1/Q3FYqXZbcv14=;
	b=XTRaS6GBYidc49tPlxmv/EDGUBPhBiq1tP4dRHsS6VQcYRV9Iptu8/rPiArC+qIOzuHtmi
	7D7ZQOwgeelRN14rg+EO/Ew7FCss7l3eSxlrRTsBFmx9qaFXeuFIIyMhAKQ/38/j5Il0GD
	nmrOhQRXW8vUQsMQKDuHY9sDrlt2Fcs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T0e3A5jt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781148653;
	b=WHrWIAe0BTFyeok8hEZWWm6Zs3AWx+JfT3J5++lz69i87ByODG9/+KHEwt6ZUe7yNmpUvW
	PJNuWTy5uG0qkTxLe7Tz5oOmQkurGZO/QufuOXQ+rd+dAJs1pRQJ9Zv7lZ8rjuUF34nKHx
	LLAKOw/7EBrbvQ95WePVXft2CAcLqMQ=
Message-ID: <5426c88f-0c4a-459f-b9f6-f0677508d4af@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781148651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f9SeiToel+JcVkBJgaJtw5RlW+she1/Q3FYqXZbcv14=;
	b=T0e3A5jt2c1L1T+ln+V5jQZGkVp4n1FMK9QZi2JKXVrPUPCnqS/5e9EJ9R1059mESIxoOM
	0CbMR+LA5dPe+Kd81W299AHs6nRWSGgQonMrDx5VTgnXKdr9lepBDcBqdv2wS529g8JJV5
	nxNiJPfOHqOx1HQrgjgaKAk7GRc9gt8=
Date: Thu, 11 Jun 2026 11:30:17 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/shrinker: do not hold RCU lock in
 shrinker_debugfs_count_show()
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Meta kernel team
 <kernel-team@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Zenghui Yu <zenghui.yu@linux.dev>, Nhat Pham <nphamcs@gmail.com>
References: <20260610232048.62930-1-shakeel.butt@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260610232048.62930-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5FE1E18000B
X-Rspam-User: 
X-Stat-Signature: kjf765mmuaasz69arop4pihjroa4ocms
X-Rspamd-Server: rspam09
X-HE-Tag: 1781148653-430821
X-HE-Meta: U2FsdGVkX1/vGvrVUq61pe+ZTvVuiNObjgZQsZpGG1w3Oif41FqEeDVwR6+h2/QXXD6NNFBSbrCHcs/6CIMxwkYkNBW6SQ3OCTiv7uCD2lIoux6CT9yrLcBceP4QGoOK7fM2NOV8U+3iGlMLi3DrpYshEwhjLGJaH6+NTJqwYajiVLVCHoOhEgmwRQ744nRf9wUxJAf91y5SeVffK+amLRqavWQHbeAu+J/rM/ZEmaFiCBpswo5d4K5cf+h8ZvfWrkyopECjOQnQVzXWRBrapOKe6VRhnUlWYbTGChVwAYjMjL5+shuo3E0d32UO282T81k9zgCP1UxsYHiSE0yxPbQqKqFWujpkRInsOi8yf0bhnWmEU11MUeBWvOhqBP01ur0QkQpLKTpbwR1mVWnUMNHgHi9gfSLazdpjOZYIgYDvAljRODwL1A+oNcRPxeF1rTpFJrf25/kHJlTI4/1EUVMVawbsYN9MFYddDERFf1DDl6mDM1+OG3LFTnCH/AgI+9JBQ0LgS5mpQpqoZVKEvJAOZtj3olTMF9uuQfXM7K87vsHt59Py8ijGorrRx7P08/80RNyYJozB/Jk10bviiRp20sEekaigCOkUZLnLni2JPZqpVdg3w16EVg4c9u4G/vUi66ngDCsL1mxqjDFgcRmEdayES44iU4GorNpOIfRkD/SgTTd9qX6H9h+3Ir9P1KV0yeQwAa/0Sr5B6fcv681ettj8iPWLeQQFZAwYLj5fC0JDbEbQXkYsYZgKqrFfuSnZ86tIOJQF0oJlYVruUjLiLb/hpOvs4LPH1FuwBa2SAweBOiGBCw6I/Hsxs+B5Nf7vQv6o9v8s3gcGLJ8IdrbqjwT+bZxv3VrO83eS2iIqesI+YbONus5X//vkRGmKWSFb+giZSL4v6KyTHsNHZDymdo0QLjB+FMT9wkO8s1WI74HKGmA7g5VBjz95tayjwKMLin68vy5LV8kV2Tz
 26b2bWOJ
 wM+63NPYhVmuDBf/gV7nbVF5T+EXb6aMCslIqWaGL+d/1NQMm5kAzzu3sjgpwprtj9bR7/nbKdAkuPduMOanmylkNYqd+rBZdT9LwvelO3AFIVw9QaaprZC/n8T7JMLfZ+WhyeEh807QWQELVUkDKoAK0/GJoeiQqRO3soEPiWaAQLgoygXUEGyQ77SSz2dq+1wh5WRgBgfz++5K+kGXrMy1xPpxu+X8R5DJtxpIVsW++LJ0o5HnPkSIWteYlGAdE/KpGsV6In6vo2nP2MFignKk2VvNDXRdR/ykYr8dSZPdHLbc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/11/26 7:20 AM, Shakeel Butt wrote:
> Reading the debugfs "count" file of a memcg-aware shrinker can sleep
> inside an RCU read-side critical section:
> 
>    BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
>    RCU nest depth: 1, expected: 0
>     css_rstat_flush
>     mem_cgroup_flush_stats
>     zswap_shrinker_count
>     shrinker_debugfs_count_show
> 
> shrinker_debugfs_count_show() invokes the ->count_objects() callback
> under rcu_read_lock(). The zswap callback flushes memcg stats via
> css_rstat_flush(), which may sleep, so it must not run under RCU.
> 
> The RCU lock is not needed here. mem_cgroup_iter() takes RCU internally
> and returns a memcg holding a css reference (dropped on the next
> iteration or by mem_cgroup_iter_break()), so the memcg stays alive
> without it. The shrinker is kept alive by the open debugfs file:
> shrinker_free() removes the debugfs entries via
> debugfs_remove_recursive(), which waits for in-flight readers to drain,
> before call_rcu(..., shrinker_free_rcu_cb). The sibling "scan" handler
> already invokes the sleeping ->scan_objects() callback with no RCU
> section.
> 
> Drop the rcu_read_lock()/rcu_read_unlock().
> 
> Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for memory shrinkers")
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Closes: https://lore.kernel.org/all/c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev/
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>   mm/shrinker_debug.c | 4 ----
>   1 file changed, 4 deletions(-)
> 

LGTM, so:

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks!

