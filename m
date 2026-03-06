Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EF57F0183E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 14:09:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 893AB6B0089; Fri,  6 Mar 2026 09:09:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C8A6B008A; Fri,  6 Mar 2026 09:09:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7231A6B008C; Fri,  6 Mar 2026 09:09:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5E70D6B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:09:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F34061A0637
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:09:01 +0000 (UTC)
X-FDA: 84515819682.11.1C2CC19
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf23.hostedemail.com (Postfix) with ESMTP id C957E14000C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:08:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772806140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c0b/w6C4ybBex3m0FqPqxP/RnhSWe+ivj62c37ZNQag=;
	b=xgN8VXZ2eBsRKeIYqf9OU3UD73fc/9QYCdfEgr+TdtqdhYCG+CeyJw+A+WZwgLOm45oMnz
	TuQIeCjNIBe+XFOiSmZSt0sm8MW+vbVeLcBMpWvO7/n6X91TeRqqICfysqVOe51x7ahm63
	GbNV7T7ksGiMpMGOcV27+mfcw3M1miI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772806140; a=rsa-sha256;
	cv=none;
	b=B8Wfq8O8uYjRj1nT+Tqs6qZfc/pDj9sTz5P2vjN+9uAwedRxiwK8ceBvuvGfRCZbADCSUI
	O3/3JYQiuLlMlGrGyJNmtpkGy0XHifupbiOxlzy4If/W25rYrck8qPB5Yqd7vYjNzieCiA
	CCNjlStWbNTrzOitsLS2onPPHiqUrV0=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 6 Mar 2026 23:08:55 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 6 Mar 2026 23:08:55 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH 2/2] mm/swap: add lockdep for si->global_cluster_lock in
 swap_cluster_alloc_table()
Message-ID: <aarf9yLQ5LjNysrH@yjaykim-PowerEdge-T330>
References: <cover.1772797581.git.zhuhui@kylinos.cn>
 <faa574174c297bd870bc7202feef9e7e41ec7d98.1772797581.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faa574174c297bd870bc7202feef9e7e41ec7d98.1772797581.git.zhuhui@kylinos.cn>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C957E14000C
X-Stat-Signature: z8b7sfeb16d8cpya63zazfqh1zbhnsuu
X-Rspam-User: 
X-HE-Tag: 1772806138-132731
X-HE-Meta: U2FsdGVkX1+OwjHQ+5jCrXoSxhV9+pWH6WWFAXYmQcWjzz4OwufXZCFKmnbG3UN34xR0zg8Tri3DNIQHzaUfruR0StT5YkWKv+BNjrSU7GPKoJGCEowh0D99cqIVarnHzImNZno3tgkBwLBHEFuqo809gloZfVF4j4dk9l8GEYTDjfI+o2Zs82J4shUjztr3GwJWz//tXevHdEsL8qZRB4TBW8rQLP2DSoCxVx5ZlAAy8OwxeFrQodDfcl/hRFGCZ/nua0odXYabfYUiQOeC+LIzW09Xylhs/NNmCDue/Fad3Px9FMGDfuZrSze4rI/mnEMIaSTTHteN+fwp2xN38ipub+AoXNacegXyZZ6YLRhng7eoH0YA04q/1+Ro5gwGcCdu8VMaQBfZXa2AgbY7125IT3XPjQBeIk8n0fvi9zY4f1gPp3L4q20NI1+BkQbfnVItMe6aaT1TEoN1cfIZQH2WJxM56AttNmcWptLq2P2G0vHRucRTh+mIJ65tTwElUKK7sQqp3XLT54Y1OagZm7PMCXpY1QzQhoRwltNLkJ2vddqfwXBZw604QF3gykKxMZs41ltqkE1tbzkRIkF9aYz08qjGa7U9FCFNtg+JosyZvE34Bb0dDTpxn11kBWMLrHBmsdJLaSA/NwYSElMlqjzGOhrNGhrbQYsLvZeOnfYEsH84dmMLM/0CFi7BIDsxWzL9VyiNS4qPms/JZVVBlvsc8p+2lOIcX9L5h8CePuXjd8v5+OGtCkNHLgqoYDn+U/7duQiQ+9cXhVLPPD/BEOjiWDY89mcmOhZbSjkzdf6Jux/VH//BkKicqoI2TtC9SlD9Nw0vaoryh/qczSyjLhvKNfrR9jZ7IMreothRy6kCBs0S+BPPnHZNLwlvXHIson7ri+Qk4RnLehLx6AquOvu1MgRZLmZ2RHuJ3CNeMzqm9f65zf3AdAzi4QafkVVQDwtb1/dROVWGT/GZc1+
 rzCouReq
 0ivOW2pBTigOD5UjmoGsyjo+Xczwsdpr3ZXsW+dgAeFmAyojw6TZcUU/G8qmhihWOMcYMx7ClVzQ11hCENlEEjUuFSXN8YWIjCFuUD1tV2XGRlzkSBMBpftgfbnbCCXtOEOfjHp5dwM3VZ5mtGGV7WkgeX2NCTLn+plmU6XK0+4IqV4w2keT9bnOIH01jHQGpd9AJtYNseZRNniD+HTlaJ+EOG9qQakWBOEZVYdZ72jD/F7t0Ai032xUFRT5IwHzMEaTpSwwXPOB5mrk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 07:50:37PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Add a lockdep_assert_held(&si->global_cluster_lock) in
> swap_cluster_alloc_table() for non-SWP_SOLIDSTATE devices.
> 
> The function already requires the caller to hold both ci->lock
> and percpu_swap_cluster.lock.
> And it also necessitates si->global_cluster_lock when the device is not
> SWP_SOLIDSTATE.
> Adding this assertion ensures locking consistency and helps catch
> potential synchronization issues during development.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  mm/swapfile.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 2e8717f84ba3..1400a1585033 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -477,6 +477,8 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
>  	 * Swap allocator uses percpu clusters and holds the local lock.
>  	 */
>  	lockdep_assert_held(&ci->lock);
> +	if (!(si->flags & SWP_SOLIDSTATE))
> +		lockdep_assert_held(&si->global_cluster_lock);
>  	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);

The addition looks fine to me.

If others agree, one minor suggestion: it might be slightly cleaner to
order the lockdep_assert_held() calls to match the actual lock
acquisition order:

        lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
        if (!(si->flags & SWP_SOLIDSTATE))
                lockdep_assert_held(&si->global_cluster_lock);
        lockdep_assert_held(&ci->lock);

No strong opinion on this, just a thought. :)

Best regards,
Youngjun Park
>  	/* The cluster must be free and was just isolated from the free list. */
> -- 
> 2.43.0
> 
> 

