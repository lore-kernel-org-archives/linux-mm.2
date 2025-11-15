Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25B00CEBF80
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 19:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81E078E000B; Sat, 15 Nov 2025 14:27:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CEBE8E0007; Sat, 15 Nov 2025 14:27:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BD7F8E000B; Sat, 15 Nov 2025 14:27:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5498C8E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 14:27:11 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E026EBB9D1
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 19:27:10 +0000 (UTC)
X-FDA: 84113824620.24.CDD5E30
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 070714000A
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 19:27:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UW4346lT;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763234829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tL1st+LPzSORFHxjjvUUas/B2xSYAdjy0OmiDtjidDo=;
	b=EYQErlP78y0V39KSI3OZwJ8JQ0d3V1qJInDxM4hgR+uObfe+WPKBaJvxfjEs6OOLTiOjwm
	KXkL3XV++9MypS2WmkrraDQlnTYEgVJ3aLkqDCwy2ZIqA2sR0VOySs0Ug8Y4ksE31eBZM4
	cD5ccnW8mFeBqxflDjRZH5dVx7MRe4s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UW4346lT;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763234829; a=rsa-sha256;
	cv=none;
	b=4BLbKMdXy9ahAFbrqDtZmysubUNA9IUvYdKg0K7DMo5kUj3X2Dc4qWngLn607gh0Tkv64I
	Yd3dwEEZnGreOpmIeKCoKdPTFUHnqf+rBpDrXfwUTNH83dMTdBksXRL0YQid8MDoczPl1c
	rcsHEy+qhTuqTnbCv0ruzO9cYNpJafU=
Date: Sat, 15 Nov 2025 11:27:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763234827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tL1st+LPzSORFHxjjvUUas/B2xSYAdjy0OmiDtjidDo=;
	b=UW4346lTXgp48lzzmTtizHyxMFKJBsoH9YYSsoWJEV7pbt/sEdsu+NAlTnXmgfqLpf9CTZ
	S3PRTMjrzHV5FkpFeeTWlcSYuYwa0czrbgw8sFmvGnFFQ6e2myg26QzqXK3VHElOV+zs02
	0C2T/2uFylsPFUYbJyVUUJCQx94d5Gk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Qi Zheng <qi.zheng@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH 0/4] memcg: cleanup the memcg stats interfaces
Message-ID: <wwuzmneum26ddbf43kquy6u5rynbtwsphkp7xlp4ktnznxmn54@dmxb54xxhgah>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110232008.1352063-1-shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 070714000A
X-Stat-Signature: xf5r5a4izjtsexct118kosbybaqzd595
X-Rspam-User: 
X-HE-Tag: 1763234828-715140
X-HE-Meta: U2FsdGVkX1+1JyRynecZ7o56PwXsMtasCEADM1EZcdsAEVZqBU23cZldbfhsV0XLFtKE3mF1eUJ7CgaM3uH919o4mMRLS0SHhZQn33HFFmIJiWYU52buiJEtM1fAT3FuapXdANpI8Pi0CwkvJM5KioXaJLsxSr5QEWf8DWJiAJnxYKc8EJB1Pgrn4rRqmDBAlZmh3gbjXJXlZh8Wby1dvhH2dgCd1tBqGlRBxfTSoxiu/GUDkzkGU7JnhQYTH6JF52NkLH4pl4Ys53m9D/Z/IcoN8FXJGTYUI18VcIR0iEOaSU2DnymHJQy3WMb9bfMv4qvukZx8ecwi3/Z+s9Cd7PeWvgvLTBy9p+gGrfneHhbmOtf8qL7ScS4N0GM9OiJxiW8NHYSvC3+6mG8RPdQBTHI3Bgob5eXXMs574YW9PprpghHmri6ohChvLaK6KWOxU44LFN314XWiW8ZUweINWFxDUI/WJX4TbQPfnkdbu54T0Js5D94Aj0lLpw07dtjGjaHets32Ico2KXKUyCKpMgoEX4+JfJjq28FdWNslurWDRTgYua3wHNugiB8gGlnN6RIW8ku+J0jzJ5HqzlOp2QoNN6JCNxazVEhbmcD8WhnnNEWLPuGZvqrg5GJ/ZqJstWmSVIouKfTsSZnZOMzLMJCR/j9aCLVI6cKt+3tx8g3mq/EV1cTQVL/1GBsHtQSiPWTQxRToAOYyduXUlvIt0S2JN405b/25ZhWPWmDgxKz/g94Da8DP5Yeizv/wS4O6iae97AuzPbIjd1vfb8tmUlux9oqfJXCAVQnnk9Qs1JG4rh807GvjwPJXTtUGkhf681Ocdc9HT4b8/NyJQjAwWbiITldWjPAMlvDuVFJZlXMsRnZs6IR6QMkrBias+uldJSqSh7fA1Ck4mCO5Xy5n57SBScmE9FqaUKehLFkhhVxfDXJ88r9X6Jqq2ALNVEuz4u9DbhFsGeAxCHyqw7Y
 7xNQUpBF
 AvSOaD9rjL3fhnxC6SYmltUx4nn8QFlI77PAM44cCn6N4NyjESBWktfh+8AIukTd/9fagaVMPblVd1fEl7hH1t/blnp0fLLTyhPxdtyxs9gswqY4LMx0Dyvq6Uld4MQ/IRvqI3Ejv/4pO4bEzr+9hVnTRwmqbkgjyvcci3Ll5NvIROVW0flpC9j133qeH5y3hQMLWsWIXFSZodpc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew, can you please pick this series as it is ready for wider
testing.

thanks,
Shakeel

On Mon, Nov 10, 2025 at 03:20:04PM -0800, Shakeel Butt wrote:
> The memcg stats are safe against irq (and nmi) context and thus does not
> require disabling irqs. However for some stats which are also maintained
> at node level, it is using irq unsafe interface and thus requiring the
> users to still disables irqs or use interfaces which explicitly disables
> irqs. Let's move memcg code to use irq safe node level stats function
> which is already optimized for architectures with HAVE_CMPXCHG_LOCAL
> (all major ones), so there will not be any performance penalty for its
> usage.
> 
> Shakeel Butt (4):
>   memcg: use mod_node_page_state to update stats
>   memcg: remove __mod_lruvec_kmem_state
>   memcg: remove __mod_lruvec_state
>   memcg: remove __lruvec_stat_mod_folio
> 
>  include/linux/memcontrol.h | 28 ++++------------------
>  include/linux/mm_inline.h  |  2 +-
>  include/linux/vmstat.h     | 48 ++------------------------------------
>  mm/filemap.c               | 20 ++++++++--------
>  mm/huge_memory.c           |  4 ++--
>  mm/khugepaged.c            |  8 +++----
>  mm/memcontrol.c            | 20 ++++++++--------
>  mm/migrate.c               | 20 ++++++++--------
>  mm/page-writeback.c        |  2 +-
>  mm/rmap.c                  |  4 ++--
>  mm/shmem.c                 |  6 ++---
>  mm/vmscan.c                |  4 ++--
>  mm/workingset.c            |  2 +-
>  13 files changed, 53 insertions(+), 115 deletions(-)
> 
> -- 
> 2.47.3
> 

