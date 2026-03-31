Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE48FF60EE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96DE76B008C; Tue, 31 Mar 2026 05:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945C06B0095; Tue, 31 Mar 2026 05:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882C56B0096; Tue, 31 Mar 2026 05:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 757846B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:24:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E1A5140C2A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:24:49 +0000 (UTC)
X-FDA: 84605823498.04.0A675A0
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 598EE100002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:24:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=skUgykUF;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774949087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H4lt0+h7SS3ec9sDgVEZvfQciy8Kbtp9kBHjHsNR7ik=;
	b=ugDo9OjKhIcEsQTfanwVZ5R/RXy1t8C5XIvKlrLGBPbd6a717ivxpOVE7sgVdaAMNOmH5u
	kPGH/ZJt7oOFtO1BVE8MiEJCVQRBCqS2ntCDnYTwIJJ0epKBs0rd4TBBPHm97K2/sEwHhQ
	XvygCiUc/0hOwLvz/UUqDhd6lG6d3jI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=skUgykUF;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774949087; a=rsa-sha256;
	cv=none;
	b=rJTCywiLUNUrQFcd/doEsCzmRHl7esmy49/48iOm6Aj4xZds5KiIVXOicfrQ37P4gtNDDj
	OdKOGYW82erU1Gz34n9q+lrDX1CDXRGT1ZOySSge3mzenQOEokYb1Hb+eaFBJvHYDmx/sZ
	HTw6/qqyXJYsZvI7Sp44tTynd73wQag=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774949082; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=H4lt0+h7SS3ec9sDgVEZvfQciy8Kbtp9kBHjHsNR7ik=;
	b=skUgykUFH9+WXWkRLGh0NbtTVQJRz8NE45RipgsYYx/OhmD6WhfJrf65uCdbs4E2VU4JGm622LOHfPJWlaJJm8D8FIdGlNozeeBQGsYrKCjT0axLbAB5j+Gx16mzSnYu09mPDWVErp78x0Ziar7zWIIBeD0wj1NanDuENQOkNbA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0X03xUAI_1774949080;
Received: from 30.74.144.129(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X03xUAI_1774949080 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 31 Mar 2026 17:24:41 +0800
Message-ID: <052ae271-509c-42c3-877e-ac8822b314e5@linux.alibaba.com>
Date: Tue, 31 Mar 2026 17:24:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/12] mm/vmscan: unify writeback reclaim statistic and
 throttling
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>,
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-12-b53a3678513c@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260329-mglru-reclaim-v2-12-b53a3678513c@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 598EE100002
X-Stat-Signature: gxyzhzx6u6ddafiudxjxihbx4kjhiwuu
X-Rspam-User: 
X-HE-Tag: 1774949085-256226
X-HE-Meta: U2FsdGVkX1/p/lxKIN7OFZf98TOg5zipB2V9kO72Xt4sUy01RjOmGE6jwHvzL+46fI4lt72yBdmrv2+0qsyeAqPlWANYKV/Rf6708TRgh4T6rsE3wKg468wreV+1RLmVkJEVSFqyWg1iCEsaunzMsWOsLkNSe54QpYRnrXRwvvZ/I2CFiCmqr4KmQ9cBsW5LfGATUqGF9AgLW583D6KX3DPAfSTk6GQ/h9vza9Xf7T1mkrpeQ4hcj/6XyvpCe7/DKbIa33ityHIgPMUL84eyVAXw5eXlfS+R6t03nYuWQWpjD7V6Yh+dBpAGNhGZZPztrlUZ+ajYMivhJeqAI8NktteUn1Jkcnmy548/RcfH/i+4HMtBspTCJfJVQ0WnPpro0FiROYAsiJS5XeC3+8zQBuxV9hLu2a4wtOQfEuhCK4Q6BXwCFcQXv49nHSyqsf0NeQBnnBnfwn+9Devgb6QOW1tJGvPLCYYqfQ50GS+QlLspYpuGS4M0DlnWEyNrk0/QzXTvEx9Nw8L2CVcDRx/iigoSMp9TggNmWVTOlGloxo5i4Bixcd1Q9FsS85WN9qrJyLjH5edR/R3Zcv8/DH/+RKgEiJgtIHkkcLV5JCc8bL19ZYmCB/UWs4oOGW96bqAVNudvpJT70wTTapspWcR6Orf8SQW9/mM9nSmbydgISs5TTKEuLLVKYwWFJSXGU7bvYUDVtES1+ccE5oyYXFH0cLuTXi0+kVheVpA9D/yeLua6usjuM7kq6RAsH+7ecO2BcfO2ilnlGENgbFL2AXKIio/30jx3rAOPHGHRjoI8mX5LtIONtyHVt2qRriZnzYKQ7qsW+GajEVQob7C9YdEjUoKosS1IEEaQ4XguXyBSCuB3VPyjitutS92H2q4vd12+uC60Hi/HlSiQr7VYfmx18Yt3pg8EIsXvM2wA+BL2jPTCAF2prI9E5YbWBq/Jpen18XTpEV1O5VAp1fzoEel
 74496a97
 bV2cgdlYmCAC7JqRH8zz4kT9I5hnfoecQgCjEXewkhz99IDjVdg5rh86wEs8u3Q5bUNb8mU8+Y/Cs3Yf2V+2bdOgWwq767Lwfvk7EumcJd4sNzKOSkVjecXrRIEdle+T2tZSKi76+kulMU75FLo5uaftQyXaz1fgNA3cNoV3Z4XxCnUn5aN0kX/uH3GZGKEHK70Cl0FzTowm82mIcFR7jCRXOFjr7ysZWBsE1O39uEHySQfthlCdsMLpqKXLhwt6P/sTbF2zdzfcn6p2D5hPWrQOrxRDl7qdtURHExiEgEUQLlZkBEhC/YZrzDh47xCn/kt4GnFEknSsQy9uR2ThF/h5RapgEOHeKEITvkauRonL4N7thA8t6SBNXUa584TxCKqBDPfujILQWKyZSwMC+9H4xHigpj+tOH4EYuvyOHmdh1fZN3rVGqWlf1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/29/26 3:52 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Currently MGLRU and non-MGLRU handle the reclaim statistic and
> writeback handling very differently, especially throttling.
> Basically MGLRU just ignored the throttling part.
> 
> Let's just unify this part, use a helper to deduplicate the code
> so both setups will share the same behavior. Also remove the
> folio_clear_reclaim in isolate_folio which was actively invalidating
> the congestion control. PG_reclaim is now handled by shrink_folio_list,
> keeping it in isolate_folio is not helpful.
> 
> Test using following reproducer using bash:
> 
>    echo "Setup a slow device using dm delay"
>    dd if=/dev/zero of=/var/tmp/backing bs=1M count=2048
>    LOOP=$(losetup --show -f /var/tmp/backing)
>    mkfs.ext4 -q $LOOP
>    echo "0 $(blockdev --getsz $LOOP) delay $LOOP 0 0 $LOOP 0 1000" | \
>        dmsetup create slow_dev
>    mkdir -p /mnt/slow && mount /dev/mapper/slow_dev /mnt/slow
> 
>    echo "Start writeback pressure"
>    sync && echo 3 > /proc/sys/vm/drop_caches
>    mkdir /sys/fs/cgroup/test_wb
>    echo 128M > /sys/fs/cgroup/test_wb/memory.max
>    (echo $BASHPID > /sys/fs/cgroup/test_wb/cgroup.procs && \
>        dd if=/dev/zero of=/mnt/slow/testfile bs=1M count=192)
> 
>    echo "Clean up"
>    echo "0 $(blockdev --getsz $LOOP) error" | dmsetup load slow_dev
>    dmsetup resume slow_dev
>    umount -l /mnt/slow && sync
>    dmsetup remove slow_dev
> 
> Before this commit, `dd` will get OOM killed immediately if
> MGLRU is enabled. Classic LRU is fine.
> 
> After this commit, congestion control is now effective and no more
> spin on LRU or premature OOM.
> 
> Stress test on other workloads also looking good.
> 
> Suggested-by: Chen Ridong <chenridong@huaweicloud.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   mm/vmscan.c | 93 +++++++++++++++++++++++++++----------------------------------
>   1 file changed, 41 insertions(+), 52 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 1783da54ada1..83c8fdf8fdc4 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1942,6 +1942,44 @@ static int current_may_throttle(void)
>   	return !(current->flags & PF_LOCAL_THROTTLE);
>   }
>   
> +static void handle_reclaim_writeback(unsigned long nr_taken,
> +				     struct pglist_data *pgdat,
> +				     struct scan_control *sc,
> +				     struct reclaim_stat *stat)
> +{
> +	/*
> +	 * If dirty folios are scanned that are not queued for IO, it
> +	 * implies that flushers are not doing their job. This can
> +	 * happen when memory pressure pushes dirty folios to the end of
> +	 * the LRU before the dirty limits are breached and the dirty
> +	 * data has expired. It can also happen when the proportion of
> +	 * dirty folios grows not through writes but through memory
> +	 * pressure reclaiming all the clean cache. And in some cases,
> +	 * the flushers simply cannot keep up with the allocation
> +	 * rate. Nudge the flusher threads in case they are asleep.
> +	 */
> +	if (stat->nr_unqueued_dirty == nr_taken && nr_taken) {
> +		wakeup_flusher_threads(WB_REASON_VMSCAN);
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
> +	}
> +
> +	sc->nr.dirty += stat->nr_dirty;
> +	sc->nr.congested += stat->nr_congested;
> +	sc->nr.writeback += stat->nr_writeback;
> +	sc->nr.immediate += stat->nr_immediate;
> +	sc->nr.taken += nr_taken;
> +}
> +
>   /*
>    * shrink_inactive_list() is a helper for shrink_node().  It returns the number
>    * of reclaimed pages
> @@ -2005,39 +2043,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>   	lruvec_lock_irq(lruvec);
>   	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
>   					nr_scanned - nr_reclaimed);
> -
> -	/*
> -	 * If dirty folios are scanned that are not queued for IO, it
> -	 * implies that flushers are not doing their job. This can
> -	 * happen when memory pressure pushes dirty folios to the end of
> -	 * the LRU before the dirty limits are breached and the dirty
> -	 * data has expired. It can also happen when the proportion of
> -	 * dirty folios grows not through writes but through memory
> -	 * pressure reclaiming all the clean cache. And in some cases,
> -	 * the flushers simply cannot keep up with the allocation
> -	 * rate. Nudge the flusher threads in case they are asleep.
> -	 */
> -	if (stat.nr_unqueued_dirty == nr_taken) {
> -		wakeup_flusher_threads(WB_REASON_VMSCAN);
> -		/*
> -		 * For cgroupv1 dirty throttling is achieved by waking up
> -		 * the kernel flusher here and later waiting on folios
> -		 * which are in writeback to finish (see shrink_folio_list()).
> -		 *
> -		 * Flusher may not be able to issue writeback quickly
> -		 * enough for cgroupv1 writeback throttling to work
> -		 * on a large system.
> -		 */
> -		if (!writeback_throttling_sane(sc))
> -			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
> -	}
> -
> -	sc->nr.dirty += stat.nr_dirty;
> -	sc->nr.congested += stat.nr_congested;
> -	sc->nr.writeback += stat.nr_writeback;
> -	sc->nr.immediate += stat.nr_immediate;
> -	sc->nr.taken += nr_taken;
> -
> +	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
>   	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
>   			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
>   	return nr_reclaimed;
> @@ -4651,9 +4657,6 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
>   	if (!folio_test_referenced(folio))
>   		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
>   
> -	/* for shrink_folio_list() */
> -	folio_clear_reclaim(folio);

IMO, Moving this change into patch 8 would make more sense. Otherwise LGTM.

