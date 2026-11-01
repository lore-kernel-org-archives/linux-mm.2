Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9902E606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 06:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jgkhxIjw
Received: by kanga.kvack.org (Postfix)
	id B4E416B05B4; Sun,  1 Nov 2026 01:52:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFEB36B05B5; Sun,  1 Nov 2026 01:52:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ED736B05B6; Sun,  1 Nov 2026 01:52:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 794296B05B4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 01:52:56 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 09ACF40928
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 06:52:56 +0000 (UTC)
X-FDA: 85385632752.06.4733EDC
Received: from mta1.migadu.com (out-221.mta1.migadu.com [95.215.58.221])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0B68680002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 06:52:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jgkhxIjw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.221 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793515974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QQnXHU+A/njXkjBuQ9/DcvI7LMxW5xBgeBSnAXxJXAg=;
	b=c4OlCQTxKw4g5SD38umxxJHjWXHS6hxldwmiHfLlkrc6vVEDfTCvdlvF8Mgrz5VOYVPIlh
	xd3/4HF1jTRlip0ZhvpCOONmRXidgPgLaHKMHhf/yIErEIcKM4iPuwUjAWaHxY5kd1x2t7
	DNaQ5uPatBta2MkJXCDNENbJ+zhFj9k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jgkhxIjw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.221 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793515974;
	b=c36MQAbSJGrieUlT/zKCTBwYjT3Gku8x8XMintf00En4EmgFxbtvbmcPumAjy5E3pSLk3C
	EiyQoWlqM2ffzBCOpBU9LhnqxI4MwmOyAdW2/+oYJW1QsTKHOnLqLmdsEptrESvdvv4UZa
	Lbkpqmk/0zo4Gncu4DvLoql9AWK7QsQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VNtaAOoW+YeNbOlKOGrgoF4I4ASqQptOoiNDDPoXrXo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793515971; v=1; x=1794120771;
 b=jgkhxIjwuZRRahGL2BMMkycOLfXl6DIniXg5zLsaqY5Er8DlRUuNnzs0pNBTvC+fER5gYQJW
 zGmFxwEBqEVH4st68jkAxG5CB8/qwU8GcbAbt/jKfD8MUAndYMBvaZX+MPTIpxYB7j7tsdEa8mh
 osp1qX5b+KhjKZlHUUCicsOE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c012510bd8f1245e;
	Sun, 01 Nov 2026 06:52:50 +0000
X-Mizu-Trace-ID: c012510bd8f1245e
X-Migadu-Flow: FLOW_OUT
Message-ID: <c643b1f6-2b00-42f0-94c1-d65eccede5bc@linux.dev>
Date: Sun, 1 Nov 2026 14:52:45 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/12] mm: hugetlb_vmemmap: rename vmemmap_remap_pte() to
 vmemmap_optimize_pte()
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, James Houghton
 <jthoughton@google.com>, David Hildenbrand <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
 <20261020115824.823278-5-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261020115824.823278-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0B68680002
X-Stat-Signature: 1s3ddee4uhsg7zc98wob6ycakrd6ccft
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793515973-458470
X-HE-Meta: U2FsdGVkX18d2R3AcAPSP7B/nZ6FnWfxOdut8/BJnxlqqsRzDw010WNlk/RCXP7fnvQG/bBlTQ6M6LDpFzIbaq2yc3uZVdUYoJr7Nb58zsJC/rXFTKgIfN5oT5BptlvXcd+KgmCRs5LBvmPoLKq4BNlaxrHi2zSDp7Y8tNThzuq3Qcq5AMoXJgWGF0oQir4OgoKeCzZWYxoF1a5qB71dHUZNOXt0+2yDZmU9BKUd8W58cy5E9mYbDA2hZMHay0n/JY0WLub6KZkVIw2eqLj0tbwFhETBJNUTI8Y5nmRcr8z1ynD7VbhVIGMVuuzJj7vXqxCk4FZqEy36t3Fd7cQ7WxXdizlrQFLRDIyIPTeOv7X/buJlA34LR10Kw+xvOYMEZd7daeDFrygMcu9qVWHUnLudWsZQuuy2ylzWocPLxAtVnyx6GVUCrrX3anCbeRz2+NNmQ59rPqrVHlt7xMRA0UIxdmVHYpoMvMjL+AD66EGu8ANHRrrYpatoOg5DwXsm9+wWw4JxIgOljEgj/Sf/ONof9hPHQVvvwHCDZerwbHer+V/umWhu39xh0I4QvdR/Cqk9x6IowEYeG5o+gK49BX5aXhd98hlBzMoiWekC8JwdYKY1j4ZS256JwO/p6fp2LZOjBSrMJe04xUmPEVH0YqMPC3no0Aq6lvIp/ZFTwGGlz24k9logvZTidDon86RNht+QYlCWXVRACq6oG3KSgi53QMQ4DLNpiK8tyEr9i0+Ou9F9VJkYDrQ4xbNdjeMVOtDKl3kNoMdQnm3UxBDdVzaa63s8aJkIYWcG3pkE/eCpVhzQ/WPb3YLg9SFsyLNPnHC03R14fn2E8gZanZtZi1Eq/IFhblWo4yAoIXt5LYDnNo4uMHFqPUH62E63B+lH//4wTvDRbVCjAp4JmPz7QiclW8LjIXU6RS3UHhgr29scU6ADGtKuFNUBpQypjqvLekJqGFkff+9g3xSiOEZ
 n2b80uQr
 HpgjDNET6qhMTwzkVpUA624t3Ys8cxsm02sJyBgLVaQsdmGuZQy1GQhpPRZ1EabycKmR3fEcSU1LcGVdWCvthIsLITEYhHSjBLk1pSSbMkv7tF7Ql1vdCWH4zR7E7Jfc15ekpW5UD/gaoG1Q/SCSMjHMSpbhQWaRFswbJt0LF4zNRqhSfLQWXaAO0tEkAlLgSraoxAM0jqc3fEZmnWqlmtOIFHYFdnLyAI35ftU447RKTN0htu7oh7XPf9vFD9nDhzJBFmDBpFL92gr0aq9I0td5u3STjaeHfbgGVOl3AsVVPvhHYVaARL0sRLpSRtmJNLlAvk2UdKWnXiRnTAB6pBPD/gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/26 7:58 PM, Muchun Song wrote:
> Both optimization and restoration update vmemmap PTEs by remapping them,
> so "remap" does not identify the callback's role.  Use "optimize" for the
> optimization callback to match "restore" and make the two directions
> explicit and consistent.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/hugetlb_vmemmap.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


