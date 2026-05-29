Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BC00CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 05:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C96A56B0005; Fri, 29 May 2026 01:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6D646B008C; Fri, 29 May 2026 01:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9FF6B0092; Fri, 29 May 2026 01:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9A0F6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:40:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A7FC1409E0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:40:40 +0000 (UTC)
X-FDA: 84819357840.01.A6FECDB
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id AFA1B160005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:40:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UWlwYTRE;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780033238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9k5Umt41qtvFiKFxTrVVX77y/ltXOpVZkfW/FZIPj0=;
	b=y2kqdo6AQBj2U30fpPXjCf4fjgnbj8uTPfKZOx8kb4/aLdnyEoinokfIZYciAqPQuDRq+v
	R9H9k5p3o1LpJTBU45bfrHtcdmdX6YqjnRMxS736jokWqv9vkKHo4CjLKB5tHeqhgZLjlE
	NM8SwoygNr4kGw/EFAhBLsa75IY6LpI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UWlwYTRE;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780033238; a=rsa-sha256;
	cv=none;
	b=k0vyWJsxYePTCkeZ0ahrpq0EKfEQpMo3BU241EnMD4e2OpbyNU7R/YXn5Y5GhNaDl7D9jp
	Nc4YtQJF1A3KtNsmFekqGaov77aSOQS+KgRFJPO0hrSyclYEN61iaeufsz5SEKEUYqgL2R
	PYAP1N2U5F6AIbEzAR48mKPfAMz5s5s=
Date: Thu, 28 May 2026 22:40:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780033236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I9k5Umt41qtvFiKFxTrVVX77y/ltXOpVZkfW/FZIPj0=;
	b=UWlwYTRE0/x6m/CR/SZfiXfbDUOpdJQibgneeaVq0GpBRdvCLHXbVkYGfnQdLAvVaasCYN
	aoHf7j4UFEqaBU9HWGZqYIB4P7KdKHf5AMQwmqlg8lfAv2TIQrNj6zwmwlWa3KHoRB6lJN
	2jUNfe8SSNYF8Vz68ocFemd5tI6+AnA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
	Kairui Song <ryncsn@gmail.com>, Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v7 03/15] mm/mglru: relocate the LRU scan batch limit to
 callers
Message-ID: <ahkmMLW9zIyZJLN7@linux.dev>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
 <20260428-mglru-reclaim-v7-3-02fabb92dc43@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428-mglru-reclaim-v7-3-02fabb92dc43@tencent.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AFA1B160005
X-Stat-Signature: xiqq7ja4p3tdfka6g5n13x8cxz8sja4u
X-HE-Tag: 1780033238-398789
X-HE-Meta: U2FsdGVkX1/v4haIQQXnOrHWDezIlyHvEEsZK/a7QDTbFAZ9V3aXtG4MZpPaZlDmpgx7arURnH9p+WrxnYjbowt7zlrQfA6Duj/k3IRXLMC2NnZmWcNqdhraFEU2QmIgIG45mqAJ7wxkahQY55Ky/3kKPGu0Rtq+N2r+kG9iuOMl8Kq0qx4V9AqZHUiBwpoBmUve07AyOrh22EJKEIyfMSWnBWx3/68SNkBP0bQ+At1ma1RYHYYd3hfD6JTsUIzfuVU9IJMTbg5lPmi60wbC8kEQgfg31S8KKVGNSfVMQhUFALYSgk1Mv15yDPiislzqI+Yk7HGxlV3Vih3XSleD8n4aMfiHDRTcoPfsdWg9tX2A/OakH11ZmObIbIyXw0rLXNqwh2jmzr+YkxlaNNUUGXmfhOiEy/MH2snaJiNwbgK76Qlp4436C07+hI64fNXc3J/et7oBItadfMOHXQJ6YtLe6VP099i2PZfT2oyBxlX87OPlhrNZarMfAq+rX9kiKEQmF2obvn4Yxr+etObooZY6lXeL0Zz6hT3qMTjYN5LBgrlxpdIUtsblakMlaZHM4Id4pE6e+PHEZA9USj6o49Bv9oMqzVGIw+2xnmjf5DN5tsrtC9Bgwf5AuetEV2eqlLAKKqkF8vOA9IpG+ZmTPUuTGvd5jKTu+8MYZcQMHqPhlJSzHW5u4TlmFkZntvKORZY9KaeA1Jovi6YQCRoMog8ufE9x9ok6H1b+oAqlECURCytSjt+bVDWO1NXszmQONjAgsz4TeLbJ1w0u3265Cw25g+is5XNbv/kVUoo3mDj9LPJe0rkz27kD83TnEdGyRuQh/t8hVC4nXpxn8JrtgZm36+y6Xco9jY4w+NDBnuWqL6x0ZBlClt+blWleHdWkRjgw/0VOcklAwz+MKH3G+GBeKWVrJPL2iZMNWvuq3EBFgxWt8D6/I6B9lwETaKGEPSPk7LICUiyWh+FGp/E
 6mAg1uVd
 gCiUTRxyXGsRmxsAsDHxELOOthGj8c94ak8RBj47SC+/jNUWBSWb0qFBLoSExihmSpjKh1h78FaG/0K2GKMcJCR1iMgqq8o9WYVwGkts7uEJu5aQoyZdLqKwA2/scv8ZegsdgsSbIy2nPvrIIfysw2gfvfJjjXhHePz2C9THE7yYHwzNCfE7EvWxjs/cPd5mC/3LFM5wf9DAOtAjtklU0+A0tXbsLEuFdbSgDJGoMHjH3E8jgv3v17Ty4+NKZGW70/DOGMau5lgkl69bgHB99WnRTiCAgfCqQ89rajGigyNe90PnCxN8HGURRDhPDuOUrhT4lVeutssoGS/xS7I3l7WvTF0tkM2/0ED6vXJfiJ0nuJGdDN/tXx9h0U1NED27ERSGGpynmm1eLsSMa/+melcxF4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 02:06:54AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Same as active / inactive LRU, MGLRU isolates and scans folios in batches.
> The batch split is done hidden deep in the helper, which makes the code
> harder to follow.  The helper's arguments are also confusing since callers
> usually request more folios than the batch size, so the helper almost
> never processes the full requested amount.
> 
> Move the batch splitting into the top loop to make it cleaner, there
> should be no behavior change.
> 
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7f011ff4c478..a011733a6392 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4695,10 +4695,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	int scanned = 0;
>  	int isolated = 0;
>  	int skipped = 0;
> -	int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
> -	int remaining = scan_batch;
> +	unsigned long remaining = nr_to_scan;
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>  
> +	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);

Do we really need a warning here? Also why are we limiting it to MAX_LRU_BATCH?
For memcg/proactive reclaim, we can get larger number. What will break if we
remove this limitation?

Anyways, these questions are orthogonal to the patch, so:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


