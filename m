Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A10F106B503
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 11:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FD0F6B0093; Wed, 25 Mar 2026 07:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D44A6B00A2; Wed, 25 Mar 2026 07:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6113F6B00A3; Wed, 25 Mar 2026 07:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4FB1B6B0093
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:55:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EEE8F13BCA1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:55:23 +0000 (UTC)
X-FDA: 84584430126.16.A57483C
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf04.hostedemail.com (Postfix) with ESMTP id 05CEB40002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:55:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ygL00GDI;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ygL00GDI;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774439722; a=rsa-sha256;
	cv=none;
	b=XTrdQq323x3ubISdxRhqJqfS7psz9v0r68UGlr/riSapeIc9hynOUEwLRoBM1aqkVhG4Z5
	Jq46zcc13urwYyN1yBLEhS82DPvBz+z85eWsvCeylf18ChtZMq8SbZyAN+fC1W702BogM9
	ZRhyMbSR8RUj0fgoKBMFC9xwqycGO+8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774439722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFydIvyPqRQVlTUEuEBJ9uTkhy12OC6V5ZYB4S4SRps=;
	b=cIQ6QJTn6l1vveqYqKmz6mRzFrdJFjtDyj6SyMq0YRK3l70u/YlUhmY7X0yCvzOzFAsXoQ
	jFS1s58/dRgYOZZ6wI7nbCIYVTl4/fCrGJQIqn+DGw91pqqejwgFpXEnN5b0z0pEGHo5Xv
	lMEGmbzThpp/w++AMmra/nyItUEYP+I=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774439718; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NFydIvyPqRQVlTUEuEBJ9uTkhy12OC6V5ZYB4S4SRps=;
	b=ygL00GDIPoWKHZIp5/ZgWf4zd/MJ+h7T6rRddu+HCePyhEH+GB8fQXmPuIcrrATmLZS/94IJeFSXPioIY3Nn2+YqkbijKmayAWE7dVZL/eklrHQBF3OCoVkNoh5kWcpPDBqegroimj3sU2DqMH3mPRu+MRj/OvU0KcmkGMBg7v8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X.hciev_1774439716;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.hciev_1774439716 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 25 Mar 2026 19:55:17 +0800
Message-ID: <67144c1a-1b63-4def-9471-59173cc4153e@linux.alibaba.com>
Date: Wed, 25 Mar 2026 19:55:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1
 for MGLRU
To: akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: david@kernel.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, baohua@kernel.org, kasong@tencent.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
References: <bf40a20cd93b6c21f10db95657928fdae185e843.1774438978.git.baolin.wang@linux.alibaba.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <bf40a20cd93b6c21f10db95657928fdae185e843.1774438978.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 05CEB40002
X-Stat-Signature: xd4p4s77xqotzwci9q7gfnkoh3r6pww7
X-Rspam-User: 
X-HE-Tag: 1774439721-765627
X-HE-Meta: U2FsdGVkX18W29uJv6qbFpsXkAZll40ldI+ZcKDmuFAD92sh58xQ4MR8jtOf9WNbTW+55JuKp0xCjlXUKUkd9+kD89pzMPiFgSwoNDvDlJHWl1ShpMLHcaoYI+H0AfOSVVmLKC6vCojuzKmIruIcywBAOu0hbrAdtPnlMe1zDLJkEdTMW/Rk8HOTp1Qawe613VMGu9jT6FReeUjCWTR7vmaHmeYod7ldrhGKRxeqLwazX6ZSVmY10j9aFpyiIiqte2Owzi4Hb60aKhPse90+iITCETWHAeudfK0zJPyxdtUMm6z+HPuOOySh5TZOzp3yf4ACDvxCTt3YyZDQAbA7apLT1HEw4pXnFmatUozphjTA+9pMO4E2VKTz1cTSTM/xvfmbW1Gv8Rh9tPz1nPHTmz7Gr95/MugsPZ754/aRAo88+IKey3qJkyiLv6yu/5isyO0tS2Ltr6D+9VowHuyjBK9MMaNp4WIGuuDD6B54xUcCtBbeAtRMIRsK2WEUKrAuIADw5ek3CMaF2lWZa5C7Ou0PIFC0e2bM5hAucrl/ukpe442luVn8pd/n91FblpxU6q71x/M4rNnE+YldrwkULip9MqEkrgkmtt+wq39weCiDlgvcrxMpeG2fOhSfmKkCwy8/PvxdR51IMKCTndECG4WDgOPIO4Z5JWFPw7g/MOiytFhAS8UDFr+epFfJgpf0DfHiqgzLCEOpxoUdL0/X9aDcQtq1teXL8nPUCOOwkAu1ajYt3kANe/MeD9rhmMf7/omOhHeeAgkP5u7FThagmMkwsurxnGXEHYLF/MvuYek9dDxzJ6/NjBia+0BFOsbzeIonV8XbQ8ph92qEN7O4++z/cAAO95+Dk92GXf+fRDAUSKj0f8Szm45zn+szE5fwq3pipAck38xl5f0WK4vG5kakQFWTRWnX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CC Lorenzo.

(Sorry, Lorenzo. I switched to use your new email address, but forgot to 
CC you.)

On 3/25/26 7:50 PM, Baolin Wang wrote:
> The balance_dirty_pages() won't do the dirty folios throttling on cgroupv1.
> See commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
> on traditional hierarchies").
> 
> Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
> longer attempt to write back filesystem folios through reclaim.
> 
> On large memory systems, the flusher may not be able to write back quickly
> enough. Consequently, MGLRU will encounter many folios that are already
> under writeback. Since we cannot reclaim these dirty folios, the system
> may run out of memory and trigger the OOM killer.
> 
> Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
> which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
> pages throttling on cgroup v1"), to avoid unnecessary OOM.
> 
> The following test program can easily reproduce the OOM issue. With this patch
> applied, the test passes successfully.
> 
> $mkdir /sys/fs/cgroup/memory/test
> $echo 256M > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
> $echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
> $dd if=/dev/zero of=/mnt/data.bin bs=1M count=800
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   mm/vmscan.c | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 33287ba4a500..a9648269fae8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5036,9 +5036,20 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>   	 * If too many file cache in the coldest generation can't be evicted
>   	 * due to being dirty, wake up the flusher.
>   	 */
> -	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken)
> +	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
> +		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> +
>   		wakeup_flusher_threads(WB_REASON_VMSCAN);
>   
> +		/*
> +		 * For cgroupv1 dirty throttling is achieved by waking up
> +		 * the kernel flusher here and later waiting on folios
> +		 * which are in writeback to finish (see shrink_folio_list()).
> +		 */
> +		if (!writeback_throttling_sane(sc))
> +			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
> +	}
> +
>   	/* whether this lruvec should be rotated */
>   	return nr_to_scan < 0;
>   }


