Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FF94CD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 05:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B0396B0005; Sat, 30 May 2026 01:48:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 366006B0088; Sat, 30 May 2026 01:48:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275B26B008A; Sat, 30 May 2026 01:48:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 169C06B0005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:48:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 21BDD161675
	for <linux-mm@kvack.org>; Sat, 30 May 2026 05:48:19 +0000 (UTC)
X-FDA: 84823005918.02.DA6CDAC
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1F2FC40002
	for <linux-mm@kvack.org>; Sat, 30 May 2026 05:48:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aaER4iwQ;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780120097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0hcBhYnTviqnkqr5x+aj/JEW43JSHVchdPdrSidMsHk=;
	b=5nNn2mKVynac7bRP1SafdEyawTx2yxI9Hby8407smH6rrKWPiJfB7h8SflNwW7hn/lvrgJ
	IRXs71w84IICUvK2FESBeAfJXdZpHPV/iJeWaoDqY6gA8AbRpIaM872e9xOjCRddSO7plT
	eAMQNqM3tMUE17NDMUqmi2Nu5atTdQE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aaER4iwQ;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780120097; a=rsa-sha256;
	cv=none;
	b=A+AKcpEl2PwQI6ZSwJmeB33OMBF7svfELc0Z+cZnJmXXFcgPE8niccl5Pf7rD32BdnfFQh
	rTLSSsAMc5uYtZr6xWK6JUAUXXSpZawfgsXBRP2n7Yd+/fi4ucPMKzu35wbbrLKET3QizU
	ligdZLQgySDWWM+HaBQWAgqkNFUDwVg=
Date: Fri, 29 May 2026 22:48:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780120094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0hcBhYnTviqnkqr5x+aj/JEW43JSHVchdPdrSidMsHk=;
	b=aaER4iwQJoxVjwTXYGLtqEzwlBJ8D/J95+cCIEhME5nkyVSDz87+CDxL2QA6/raZy45t2R
	QCNJvK8IL0oMrL9WWrwXPgk5psjjLMPmlQeiHkhA4yvwPE6yYrdRoG4SBtIzAVbdnGC0s1
	vQCDUF8tPP+geC2IJZ9AQ1XwJotBLcI=
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
Subject: Re: [PATCH v7 04/15] mm/mglru: restructure the reclaim loop
Message-ID: <ahp5UEnswEZkU8j2@linux.dev>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
 <20260428-mglru-reclaim-v7-4-02fabb92dc43@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428-mglru-reclaim-v7-4-02fabb92dc43@tencent.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1F2FC40002
X-Stat-Signature: htnbwieafq6fg3sjw7srs3opq7sqesob
X-HE-Tag: 1780120096-95138
X-HE-Meta: U2FsdGVkX19wum78iA2oGnKv6cTohcudn/cIrVIGkh54Hrge8t4o8JmYUaFnQ9DD9sIjFi0Tg0135yS9FOyFIxKWPsjDfyIt1xaBvz3ZgU9S71GyjPrXAwPHBQdE/KvEUPzWnDaAn8p+znJcAbN0BZVL+kv9ZAI3z1DHZFHjCyL12i99QR/L9A63GibdTCfShHLwWoIzlF9obT90+cYUw/hTAu0v/2lK/AJUU5nHM4vMlJi7m4m1AZlTV3HgMxP3GaMKlBQe3pZQO73lq6tNXIxU4uhtZfqs7kO2dE7GcC/J/DK359G8BXNjW4UTY7JCEgEBV9T7GSMiFcwGLmt/sWJeaXRBnJ8CkGMpCkwrkVe6zZCrjhIaqCLCDWTJXCJqskNERO9eXsOGS9Lz2s0Fy+ER/Rr9jNzJXHjgzlLm4SbaejszR4BxOtVT277SXgPVlMIBQH4tEmEIqjtaiDbGLKENIby7ME2SPfcLTCWQE+RxaQcHckRk4WV2cIv2C5zmLS+48EbfkEoNsOJ49dXNjKindglAB1I0kuM/qyQ9c95WSnl9ZPgwbjlkj/1l52mN6BFPbox4qXzwuWfeVfixHoLwx0Qv3AWmbF8bDWGGSTIlqwopk26F1EnhYLomZthhbINon1oSDoO+jPuj9LBPJko1dxHRkKOzhrGp+BEkptABSOk0KfgbLiaQr8SIZavDRq2Z9pECfj8gjSksboKrNTsPC5+rUeYTQAgm6fk/bzpjqO+drkPcZHrfYvYlNVv1ZYS8YjZ6/H9dFIBwn/vhDElfpqTOCUm/7kqHW3LKsy4/+Hq3M2XQlKmzO5eL5qBFvxmBSDKibVhEznBKvdhHZ7Bu8fiHK6tx365OlY+SWxc7S+TSa4/3xg5osSiduAkofyr1YAncDw+8zUpc4SIBGlHF/4l7/le/I3in+9KPSLaIYyjW5xa039uZ6cPEGkS3ocxFfHMFZ7Dh+PbigK6
 fbUtW+iV
 WXJ6QychxTyR8I1IQf7IzBIkPQFpXzHvFZjm6KG3U0K5MBsxjC1kbYpWGDbeKyA/ow/vmbCNfVGkZxTzgZ5FPfjkRhL3JjPWmjwLzjpN3ZhwU2kG7Eru9+v08JngROpI4Wye91wzsTLCwIPMuLDOKDsUkHsLPrm0vGuRw2T0CpprS7sKe82nBP/cFjH2HwA85/QOZGzDGrqAIoAuB2Aug2iW5HsAto8hdMp18orEFPiWuvLxRbnSFgjlYrCTraEfPYIyec3roevxpa53fI7LfzegQtCYy1J2M866xlBv/ATf9Fk5YZ0GPwQPVDT5J5rYemsz8lJ1A/oBl41Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 02:06:55AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The current loop will calculate the scan number on each iteration.  The
> number of folios to scan is based on the LRU length, with some unclear
> behaviors, e.g, the scan number is only shifted by reclaim priority when
> aging is not needed or when at the default priority, and it couples the
> number calculation with aging and rotation.
> 
> Adjust, simplify it, and decouple aging and rotation.  Just calculate the
> scan number for once at the beginning of the reclaim, always respect the
> reclaim priority, and make the aging and rotation more explicit.
> 
> This slightly changes how aging and offline memcg reclaim works:
> Previously, aging was skipped at DEF_PRIORITY even when eviction was no
> longer possible, so the reclaimer wasted an iteration until the priority
> escalated.  Now aging runs immediately whenever it is needed to make
> progress; the DEF_PRIORITY skip only applies when eviction is still
> viable.  This may avoid wasted iterations that over-reclaim slab and break
> reclaim balance in multi-cgroup setups.
> 
> Similar for offline memcg.  Previously, offline memcg wouldn't be aged
> unless it didn't have any evictable folios.  Now, we might age it if it
> has only 3 generations, which should be fine.  On one hand, offline memcg
> might still hold long-term folios, and in fact, a long-existing offline
> memcg must be pinned by some long-term folios like shmem.  These folios
> might be used by other memcg, so aging them as ordinary memcg seems
> correct.  Besides, aging enables further reclaim of an offlined memcg,
> which will certainly happen if we keep shrinking it.  And offline memcg
> might soon be no longer an issue with reparenting.

After the lru folios reparenting, we should not be seeing folios remaining on
offlined memcg LRUs. So, the above para can be removed.

> 
> Overall, the memcg LRU rotation, as described in mmzone.h, remains the
> same.
> 
> Note that because the scan budget is now pinned at loop entry, tiny
> lruvec might skip this reclaim pass, also skipping aging, which could be
> beneficial as aging is not helpful since it will still be un-reclaimable
> after aging. Reclaim will go on as usual once priority escalates.
> 
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


