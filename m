Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D9F7CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 21:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09A416B0005; Fri, 29 May 2026 17:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072216B0088; Fri, 29 May 2026 17:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC9D96B008A; Fri, 29 May 2026 17:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC2DD6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:29:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77B031C03A9
	for <linux-mm@kvack.org>; Fri, 29 May 2026 21:29:21 +0000 (UTC)
X-FDA: 84821748522.22.3AE468D
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 85BF8120008
	for <linux-mm@kvack.org>; Fri, 29 May 2026 21:29:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Qs/GeC4J";
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780090159; a=rsa-sha256;
	cv=none;
	b=fxvZkCtTQJokSFMCZxtSAyGLNie529Ynwojhrkl5MWIe3k6MRd2ZXEk5zHESBAb1aVnkWJ
	0UKz385E6eIZXSrfkSyFx/oDwpo8mZY3GQWEvuVQXPG/PjULkh5yzc7xnLScc2cY4/CO9r
	XqiptY81CbdTXNVUTNOBVbfqT4HvJ8Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Qs/GeC4J";
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780090159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JywH/3otXdM4lGyU+6UvJoj0eraUl9jHOX9YN/uPgf4=;
	b=XCnXg3zexX/jo3Rpdywc6gVfw2dOGvrxp1A5vPJnTxhM2olDBPdjALsYxf4tIo9xaKo8Ug
	oatX2BHBdh7Osfbxqun8ZhF8wSDqR36q3Fa8oe6OrsAnpiLkW2ZD+aoLFwjSlWhRABjzyQ
	Jmmmv8MBTQAqdn7/8+6JdUxr2c2NvPg=
Date: Fri, 29 May 2026 14:29:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780090157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JywH/3otXdM4lGyU+6UvJoj0eraUl9jHOX9YN/uPgf4=;
	b=Qs/GeC4JcxgJ+DiZ/fwuqRIk0L6jEEntFkyGxQUh81YDcysn1RvUVWpULR5+YQ1oxvpWxH
	Ycwr7h9W7aPgdGFNBrPPcWKHcvUvytW/ca77pWi+IlepBdX+8XfJEO9Y4oyRxDNOWoTbRL
	gRq5HJqKi1tbtKAfk+zT8dkw09KdKRg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v7 03/15] mm/mglru: relocate the LRU scan batch limit to
 callers
Message-ID: <ahncWUAJlPZhNGr8@linux.dev>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
 <20260428-mglru-reclaim-v7-3-02fabb92dc43@tencent.com>
 <ahkmMLW9zIyZJLN7@linux.dev>
 <CAMgjq7DYAyu15Fn6k6A7bozonT+hrV6ZrXL3NTmg7T+DWPj7pA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7DYAyu15Fn6k6A7bozonT+hrV6ZrXL3NTmg7T+DWPj7pA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 85BF8120008
X-Rspamd-Server: rspam03
X-Stat-Signature: e41dh1mihwhd5z9n3gfaqwa9fojnkp7m
X-HE-Tag: 1780090159-937820
X-HE-Meta: U2FsdGVkX1+T+N/d8hhrkcsOrRuXkmhYZyDsOXLrkkvbs8t2bAYnBmthzsSzRSxRrrTVKwKUdpKUTT3wVy0MRJC/thvwEirhsCvgh8I1qkvtFKlxOawnpBwit8CSO2wPKdaKNGVmHMMZ/kEl0G/gcaHTBFbKO1ws8ZE7yBkFK5KIaF7eoHAjIm9QGrPDfMjx8NKV0oaATaYRHtG+8sb/J0KnJ1rZjlvgwvUF99QUocEXNNeMropHH7knGCXyBTIBagahU4GYh61nfjzCQWFuHrGADa9jwD15c5rRA6uFjUvsfwI+uvLlW+m5AQn3F3OMgbD7IMCVzz5g9P5c79tvfZVTsYoNrCS77el1ip/RifwcaqRXpp183UikSmXuv+4dEYsV6P0jg7Z193By1unI8v22WfeRrBAJI/hKHqGQn4eoEnHwZR/cn/elsDLUSIdoM/P+I6LTbMnGfh2o4kiUlSAf5FfJ6pVPBwlHGAwkzb53ZDXtkrcDyYaRAkTiZ2aZnpFY4TbTFI834uoIUGPMwodR9MsdtBpL5a8rLE2sryi3hybcy/w4hS1kyNS6BKyMyNnmYHLTT8xiVuLOLleTeZr8F4V6qipjaINKb9+E7feS+uUlEAcT8WteRw4PZiePnqJ03a1Pcd/pPqHeB7cPZ7YnpgPDN7+Xj8VYLksQPOq2/KBEmK0G45R7pvoEf4sg4kbKa/S3ATJYv+nH1V0ZvbnCXYZHfLEMpd4rAVXB1I6OnT/AjCPR1gdfO4g+VnR/FzkD/LyNqtC3ZUJx1AF/ycuGhkDlWa9Wn6R3dQcsJM6OafIIXZ5o2VmzocyAC4gMBDkiNBIeVFW4Y0rIitEIHhWDHQ+YdDacneLI/h3JxK23n0LAlA+vtfRup1Y5ARYydkuxJoaBUfyNo+OYgH7eS6fIiA3irD1Au4g8JCJDHfnAONpeLpqIjmfhhWOb1+ZH1JtSn+d4SBxHZg9wzkb
 tmsg4WBJ
 m8iUtOQZkpiwldbZoiwUYILB4gWlOI+DvPfR/S6BSJbsLmv8/RGPlOGVlC00NC22Es1U4Kp3Gg2U0PDltW03EuFvpCw1MzahyDcSNZ4rVp83YbhBRRdMCwhYH7cIqFw34EqlER7eKxCbsgLIKdnPm41IRGu1lrVZBqrw60nxoUiUf0n8yRmQU++L7DiMD7Rlt8O6AKAyNHvNuiGfb7Mvs8Z3NYMiIdWQNcomJa4oZErMKK4JVKyAESNkIWQZGEp95xnAtpJyItLFewXsfTvPPGgmigfVb5c0Ym/WqsQwhNppU2UK8zQwsFUetE5ivOszvQ5XY2e0x54+CMBKwaWMMk9YjUrNd62rOpeIvL+QjbJOErdRjMqQNrS6e4OjBZcvjzBWzqGQRreFvPxOaUDA8nmKmUi8uqAG9GIPZzgGlnnNFWi4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 02:01:43PM +0800, Kairui Song wrote:
> On Fri, May 29, 2026 at 1:40 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Tue, Apr 28, 2026 at 02:06:54AM +0800, Kairui Song via B4 Relay wrote:
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Same as active / inactive LRU, MGLRU isolates and scans folios in batches.
> > > The batch split is done hidden deep in the helper, which makes the code
> > > harder to follow.  The helper's arguments are also confusing since callers
> > > usually request more folios than the batch size, so the helper almost
> > > never processes the full requested amount.
> > >
> > > Move the batch splitting into the top loop to make it cleaner, there
> > > should be no behavior change.
> > >
> > > Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> > > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > Reviewed-by: Barry Song <baohua@kernel.org>
> > > Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >  mm/vmscan.c | 16 +++++++++-------
> > >  1 file changed, 9 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 7f011ff4c478..a011733a6392 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -4695,10 +4695,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
> > >       int scanned = 0;
> > >       int isolated = 0;
> > >       int skipped = 0;
> > > -     int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
> > > -     int remaining = scan_batch;
> > > +     unsigned long remaining = nr_to_scan;
> > >       struct lru_gen_folio *lrugen = &lruvec->lrugen;
> > >
> > > +     VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
> >
> > Do we really need a warning here? Also why are we limiting it to MAX_LRU_BATCH?
> > For memcg/proactive reclaim, we can get larger number. What will break if we
> > remove this limitation?
> 
> Hi,
> Isolating a large chunk of folios off the list is usually a bad idea,
> livelock is one concern, besides, concurrent reclaimer won't see them
> anymore, and LRU operations on them will be skipped (eg. roration).
> Under heavy pressure, this could lead to premature OOM because some
> reclaimers will see the LRU as empty. or accuracy loss.

Oh this is the isolation count/limit. CLRU isolates SWAP_CLUSTER_MAX folios at a
time. Any reason why MGLRU does 4096 (on 64-bit machine)?

Later we should evaluate what would be the right isolation count and use same
for both unless there is some inherent reason behind the difference.

> 
> There is a LRU isolate throttle for CLRU, which is missing for MGLRU,

I am not a fan of that specific (too_many_isolated) throttling. In the long term
we should properly throttle the number of direct reclaimers.


