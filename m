Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AB3C10FCACE
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 20:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE9776B0088; Wed,  1 Apr 2026 16:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9A216B0089; Wed,  1 Apr 2026 16:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6C16B008A; Wed,  1 Apr 2026 16:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB44A6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:32:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76FAAC0E36
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:32:56 +0000 (UTC)
X-FDA: 84611135952.01.3D6EE68
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8C69540009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:32:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=leaPaYSm;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=leaPaYSm;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775075574; a=rsa-sha256;
	cv=none;
	b=P9tKs/GPxJJE+soqZQ3HzrxOFCeOYfsIi5iQXQngtCFcv6J/NrXZEwmc+ORN/S04m/0Esy
	+Gwtpe9cu5sMp+vWvFTpe2JOHaHi+ftPyzHazIE2TK2qhtzaYb5Ot+h6dpzTz4Ax0pM+Zb
	k4p22RQlvx0hnAwGYbKRKpi0E1a2m6I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775075574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vg1qGD3qx7K/fSuaArorcBrvxHQxJiEvWr7E5KZsN8E=;
	b=FzjnZQjUlNgN2/XUqZHwCWEyOrDto4pwEms7l3X7QPewO785l+P7iK6ziur/UVjj0Xnfsp
	ZGtZbtWbbeHQiDrBojTcaQsycyPA0atew3892R89/ntZnB0vy1wJzYG9XwrGDwDDYMMau8
	W+xGyo64C0/5h1t7GYCjqgHblRXbPrg=
Date: Wed, 1 Apr 2026 13:32:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775075570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vg1qGD3qx7K/fSuaArorcBrvxHQxJiEvWr7E5KZsN8E=;
	b=leaPaYSmz2vEv7lc5Zpx3vd5Mj5O90XGj/bgb5NLS7Vsc6IlyA6siBBXKVwDqmwFnqM3n8
	hXRfpcplhXCi/uc+53US1FqFRZw0P1svlG+IK9k8FHU0phLg6arC/Iom52z0Kh63anYDQ5
	C6J6s31IId36Tvi+MQ1hq+BDBUDEaOQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, zhengqi.arch@bytedance.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, ljs@kernel.org, baohua@kernel.org, 
	kasong@tencent.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1 for
 MGLRU
Message-ID: <ac18iLvF-nNtxk1-@linux.dev>
References: <3445af0f09e8ca945492e052e82594f8c4f2e2f6.1774606060.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3445af0f09e8ca945492e052e82594f8c4f2e2f6.1774606060.git.baolin.wang@linux.alibaba.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8C69540009
X-Stat-Signature: 4eih61a1ks3dsoakxy6z9nqaybzmhw6w
X-Rspam-User: 
X-HE-Tag: 1775075574-341275
X-HE-Meta: U2FsdGVkX1+2JqzokBjGDUpjlbtLDplXvjQ8Q9pdUM9IGWC/cLoXrvG7vd5SDLcykiHWxu0we6I+1thD+EkJR6KasQwUTgd33KuRgcM9ARs+uwC0qbm/c2CyAaxfUNOGI3pjDBQUdVicWznQOJIApRPbxeW5NPRLT+fa0hShvAXZmKmlEK3MGcybAIQKOn2MLwYoAwR96KDXBlUK/mBgEzoDMGA/PEuYLhhvDqPKGHuj+hB0hY4uLX+zMaOwWPwB3OExw3jv2A4iIM1ILnEFgIUmOw1tOcXY/mR0BWVZCQp5sT3jv8yY9LZkr35MscJh2atR54rIQ/WxJe/Qq7d7F8qdl7/2tIorYtvb4uE65QkqHgLGwOaYGZsQ7LjWuAFcwMRAat2uydnFX7BfkUpfdfWm3/nFpeDVsHwXIAf2n5CVduQq8VrCEHBzRSfqhg1Y9T0eJ/DR++abEJ92pnxR16orHfK6uDx54KLvZxqQ+zQBbG81/h7abMi+VPLuYeb+ujd117ZTTw+Hq9DTf5pGMXC4N/bVZCYpNbxIAKa8YSmoKW5u5vPP5CeYytdVFPx11HeUYfXuBOyQOybDey0Cr7vbqn53KgEBjNpJH2hTm88c0EUJXqmfeRp0ylIHLbSnw50gcs07E5Qje+K1J63z+BKNhnWm+3mbYJO0SQwDImhZn1tEdjurbsQcOAtUF38YY1jTuiOpu5bY3rK+hiHxVWpEAQzTuSowu7KkDu3QLAeTnxJvzGTie0OuG1hTELDsPR76Ef/j5Y8JB3XvAUiia/XKG4RXd8MeVYkevN7bhVq/wAe7JyspKCcdid9NlL9WOIdXkkmMfyFn6BX8CgS1kq3xn/gaQeUh0ykypgem9F+OLdcS8BLJeJ2ZnqMdj256la+Yr0soXvkiZ83VWF+VFGt6WAiw9zpYpr90HFZfW3IjZQ2b8vgp2PXAOmRck2HQNajNXA00sSh24wG2ggH
 LnNZgpW1
 cr2+QInz3FjCilRToyRYa3urw5SD+D0562b0eDOAGTv5YxgnIJKLGRBsbzXEBxXnYkp4GLQD7uJ9i9iDYGQa3RreESd45Q1J3AmcPGbWfwACAucxpX+e8XgMu4VTWJUjOYM9lpgf6hTjwzDjGDRz/eEdvdJOeM1KSyvQuFHszays3Ch/h/OdQaeRZ+L6GSSojI7Tdg3XK6ZFMj0xBV0LrkETMh+F/doUW/yaqeOcbOGz26A41cOxDy4Okk7PmTwitXMvApvhK3+srJN6JTe8e6yJO0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 06:21:08PM +0800, Baolin Wang wrote:
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
> Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Changes from RFC:
>  - Add the Fixes tag.
>  - Add reviewed tag from Barry and Kairui. Thanks.
> ---
>  mm/vmscan.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 46657d2cef42..b5fdad1444af 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5036,9 +5036,24 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  	 * If too many file cache in the coldest generation can't be evicted
>  	 * due to being dirty, wake up the flusher.
>  	 */
> -	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken)
> +	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
> +		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> +
>  		wakeup_flusher_threads(WB_REASON_VMSCAN);
>  
> +		/*
> +		 * For cgroupv1 dirty throttling is achieved by waking up
> +		 * the kernel flusher here and later waiting on folios
> +		 * which are in writeback to finish (see shrink_folio_list()).
> +		 *
> +		 * Flusher may not be able to issue writeback quickly
> +		 * enough for cgroupv1 writeback throttling to work
> +		 * on a large system.
> +		 */
> +		if (!writeback_throttling_sane(sc))
> +			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);

This seems fine but note that this throttling is not really the same as the
throttling happening for traditional LRU. In traditional LRU, the kernel may
throttle much more due to throttling check happening at each batch within
shrink_inactive_list() while here the check is happening after full scan for the
given memcg's lruvec. So, throttling can be much more aggressive for traditional
LRU.

This is v1 only and I don't care much but what is stopping you from moving away
from v1?

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


