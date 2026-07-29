Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 326CEC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BBA66B0092; Wed, 29 Jul 2026 10:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06C6D6B009F; Wed, 29 Jul 2026 10:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9DC46B00A3; Wed, 29 Jul 2026 10:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCB916B0092
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:27:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A141112069E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:10:09 +0000 (UTC)
X-FDA: 85041847338.05.73B5201
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id C5A63180010
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:10:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g1T5ekvL;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785330608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zWBDvpD2lxRj16Xz0kQcWw+PNFk2I/UmPNdP3Qw4xio=;
	b=DewRYJz+K6IyeAz1zqogR+zVmCslh+QbS6X2Osc5Cq2wevsKXnR5F4u+CyMsfaY7nRLhb7
	CrNmUGmpXz0jXZNjDcxZIBdmqaBLnBnwNxTLi0sZ7dBtNBrbFKqX5FT3BXpCrnSoBlHpBY
	6uGYYMcK5MFQ3678vfI6D6ZD1dJsGdA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g1T5ekvL;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785330608;
	b=CMUIP5WKcfJb65k5ig49tYJ6+jYPIJh3cq4YugXSJaDHaJSXkibfnWfGI9oOpwlXiP0uT6
	d7YibxyBLWNQYgg8n3Sez/OEq/63in7xdjAwQoRHP+hKo7QEwXjfhSV6sQoj3towVfltVl
	7wY0gOyGTTxpNDo4DoTbSgZNYUCXzT4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785330605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zWBDvpD2lxRj16Xz0kQcWw+PNFk2I/UmPNdP3Qw4xio=;
	b=g1T5ekvL+CSLqzeTNQQxWvE4/zmkHJt0Mb5cOMd9Diyx7nToR43X1gbDbceFRU7SOZN6DD
	/pBPtCM80ZwPuhy+9SuYkSqLCZhC6uLs3i9AEDYx/YwS5VSNJTMBE4SSiOir+4aOsU7MMX
	7SLA5RnDMbWlS7aY1Mu+s45qlXYF5GQ=
From: Usama Arif <usama.arif@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rientjes@google.com,
	kernel-team@meta.com
Subject: Re: [PATCH v5 2/3] mm/vmscan: add pgrotate_anon and pgrotate_file vmstat counters
Date: Wed, 29 Jul 2026 06:09:57 -0700
Message-ID: <20260729130958.3728209-1-usama.arif@linux.dev>
In-Reply-To: <20260727162550.2032-3-usama.arif@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C5A63180010
X-Rspam-User: 
X-Stat-Signature: twtxc4fainr1c31678wthnhfizixjskc
X-Rspamd-Server: rspam04
X-HE-Tag: 1785330607-768429
X-HE-Meta: U2FsdGVkX1/cCUmAkhN476fW/n8u4y+6DS9sn+u3pA+qvW0BSbgeCcHPRVElOnU3YpU9Al1DmOrNbRkDDdgsfA/KGazGvjL10LKpbhkyNYTR11tmYddVbZ21BvvjlSmK0NCxvpBS2SVwovMRax6LrtucYQwiQMdKW/cPO60JYMxEYIvFr4baFRakGxQu0Q47eji+3mqP+TY8gslHyS7Rt6DZaGX3BGjUYG3F6or4tAgpzqX4IfiOUUcqGsUP/ZO3DkKTPecqKfZHmNN0QowXZQRkg4u9Qwc8ke8cWKHl3RAnWQelxUzmIuVR7bilruSEzNOgpQb4nIAzYRcomOwpGgj+AC27mox22TvVqgN91wfAleFuzBniwf712stOwHZBiF/6sEv08TsCjOvhtDwhiW9xAgKMD5qzqDbYW+VjKCONrogs8PdaTuR7RkdeN2QQh1RriWwnYH76XwyjwePeuj3y6uC85txDIqxG54PB7q6MBERVtP0tF1hh+1lePC8vxL2zf/mgD8M/0UX0jx47TNXBDV94MEfcCFxv23Zfk7+ZS8xNzPLQC7xfPISuUUfHbc479TLx4CvwjWgkEV+e/AArI47hdV4A5jcYvrt9ID1hamjN2xZrh4RnXGygWAppiOYcVYHDA97BT8DULv/NTIS2d7GHsqUBvOfAQbRF7rnyaoKgDnGio1rUAZOqYLUPDTQpKwyxb86O38PWpHbjJYJV5pnOdnZUNSJdqh4S5bIiYY0h1WgpgqxEZ5r5x48EFfv5XOmkTh+o9pXt/+ImtN9zjtSwvRzJtwpMrwbEjgm3mSeRoSMRpnFmUrgTyajI3MZ7VTFC2o/Gimp5p0/4OgkN9k33S7FNy9IDqYd7IlzPIjKN0ZPwbFZPs40aAolvnFyyjDyiJdV1P5lyt0PlGO3C8Xmpi/mtQyMqtFWbj09j46mxxzO2yB1xVknT2x876MFkna0VfAhxaMSvYvR
 YJFdFXKn
 2Y9Cf9hXGnAAuxgca3KV1PlG8aqGENW6ZangEIYdjrX0pL4hGtWE802H9j+mlHu8pRafpWavdQIGXgztDxb6myiLJbgGoPoiHu93frAbB7uTcbAm3cciw9lazaLIyh/GNxGJQ5V1jRNKw+ZkxjqRa9ihxkZfFf0IbjZ55tamfQ/d76cWY5nmb+EEfwtmjnMosJUmtII4fifCvkbrUqwIbxxEP0hu5MNX/HYb1grbnYgEBfSL2DkAtDmXHmUBuUM5nmCs7CpkHECccqC1LWTwMqpMagRqADh4KDmtsdlN7zTmP0AXwwxt41m1+zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Jul 2026 09:23:24 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> Reclaim can spend substantial work on an LRU type without immediately
> reclaiming or demoting a corresponding amount of memory. Record this
> work in PGROTATE_ANON and PGROTATE_FILE.
> 
> For classic LRU reclaim:
> 
>   - Inactive-list reclaim adds nr_scanned - nr_reclaimed to the
>     corresponding anon/file counter when isolation succeeds.
>   - Active-list reclaim adds referenced executable file folios that
>     are retained on the active list to PGROTATE_FILE. Active anon
>     reclaim does not contribute this component.
> 
> For MGLRU, add the number of initially isolated pages that remain
> unreclaimed after both the initial and retry passes to the counter for
> the selected anon/file type.
> 
> These counters are distinct from the existing pgrotated vm event.
> pgrotated records an actual move to the inactive-list tail, primarily
> after reclaim-marked writeback completes or failed invalidation leaves
> a folio for accelerated reclaim. PGROTATE_ANON and PGROTATE_FILE
> measure reclaim cost and do not imply that a folio moved to an LRU tail.
> 
> A subsequent patch will consume these counters for anon/file scan
> balancing.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  include/linux/mmzone.h |  2 ++
>  mm/memcontrol.c        |  2 ++
>  mm/vmscan.c            | 14 +++++++++++++-
>  mm/vmstat.c            |  2 ++
>  4 files changed, 19 insertions(+), 1 deletion(-)
>

I do think the sashiko reviews in [1] about MGLRU are not correct.

I am going to ignore those unless the MGLRU maintainers think its an issue.

[1] https://sashiko.dev/#/patchset/20260727162550.2032-1-usama.arif%40linux.dev 

