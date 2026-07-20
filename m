Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 746B3C44512
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 02:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 458E46B0093; Sun, 19 Jul 2026 22:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E2CB6B0095; Sun, 19 Jul 2026 22:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F756B0096; Sun, 19 Jul 2026 22:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 089026B0093
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 22:28:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60DB5160735
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:28:01 +0000 (UTC)
X-FDA: 85007569962.22.2B8C1AF
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1C49140006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:27:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eNR5XIKw;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784514479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AlNhtQCquztP9G9X9Z8iMtH1eSwOYMw8dTp0ZlM181c=;
	b=5DjSoO9Cdl46sbaItS4zlIAobi4knf7m5D3aumSqINxLxLbR6k9aFwrhJCDPNJ0Gyul0n9
	yhRRTDlQzCO7LJq3lfwGaxyp7C8IawdC7tgnmEzOqaGtsWfMrwmiU85zvBPB0LHIAKNEUg
	dHhgo8ysSiWZx8oE2waPfRahA7nZsRw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eNR5XIKw;
	spf=pass (imf27.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784514479;
	b=6zqXio7crNQSLnxtE+ykAMMO6awv3G7vqeEHQBNvaBvDInr38XUnviLLGuOIjFaLtDtkNK
	gLuRWcUVEsPkgPoD5pqxcD6W+TOg5eJNYB+2AYvzXdt+2000pV0Y6Las0y10/qXPtptCMN
	iLGLFTLtqyxLAom6kSLHczYEe+Tm2j8=
Message-ID: <bb41fe18-71a0-4574-9941-fb30e48bf4c3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784514477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AlNhtQCquztP9G9X9Z8iMtH1eSwOYMw8dTp0ZlM181c=;
	b=eNR5XIKwOUOOp9+tzPCT94JJoXfglAFyTLkEo6lbTOBL7ZmigdZfbK5O+mg/9ghIFh9eBs
	PW6Mv+3DKHv2p3XIvxukoaCbKBlc0/6zNPw7hJrLWoMq27RNj4Bqk5zw9RYzX1dUUVPpi4
	763PxCA35hA5D2IQaHJMS9Q+06zHa3Y=
Date: Mon, 20 Jul 2026 10:27:43 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/4] mm/vmscan: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Ridong Chen <ridong.chen@linux.dev>, akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, david@kernel.org, mhocko@kernel.org,
 shakeel.butt@linux.dev, ljs@kernel.org, kasong@tencent.com,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hezhongkun.hzk@bytedance.com, muchun.song@linux.dev,
 dave@stgolabs.net, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260718095251.82937-1-ridong.chen@linux.dev>
 <20260718095251.82937-2-ridong.chen@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260718095251.82937-2-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1C49140006
X-Stat-Signature: tuy7gsoq8uerwztrocsuc8kudpxori7x
X-HE-Tag: 1784514478-666688
X-HE-Meta: U2FsdGVkX1952NbZPdPcbJFCKn+k/kfjqF5a8xBKzgH8gfRwzjI9VKQkeDp+2ATwu9xycfFvcYZwNwfiUXk5geoVyz4osvKMDePL0w06MznmPnCL/tw8YnnyNxWuV7UU2E1dZhZiRaiGHbfzux5zfJOEC97brymiWSY2VWXbt/RdmiKfjUw4sC4f6Vh8t/bZIoleCXh3n4IJiD6Y4huZ+LpxnxS2RzXN5LzQFOnDvQGWtS5Jp33yyN/sqa4npOUVVIUYrOVpXg2irSwQISu8pKZQR+dMZ19j8GfCAB3/HFtwcZ66yzQzda3/aYFNY63nKEJ+0I37zERZxwqjq8sESqBLx1W5Z+UHsrESUIlRJvKS94VAq/P6vJ86XPaMli3cBNrMDLeSx9vDEAKpaAXXQlZA50uMZuCYTl2c6SxhlUZyLWYzoCrG9nW4EqnbPwclyKgj1lgRa+QR/MEz/k4Yp+oFLGB4kgIbrkwM5pq3UgFC/mTEYveBs9PD3yNtRKs+i/A37Jj21xJ09hU/P3+dNfsRG9n+rfk82CF+p27Xtqpd66/Qp1eIprXR031afwpBstef+0rJleOtNN2CGfTF5k/3vMFBi0ge0jB+7a930Km6qzsrwKKgX2T/dnlOO1NHrUbPsV655ueFGlM1y98rXWiQGFZZBtopNjteIfPZ030VZ284FuB0cflRRllAZSm+CymuzgKgFWZvRVWuEkZXPxgIJUVeuGniYp8n2ktpec699Nvqfa/byMG1RG6Sy927iyGrt19uSdLZZstTwjfoPkOnjB/xIBvjQN5uTOxspJxPEvhOEOBt2IttJHxaeT1T+sByTRuFyvUSfNj4m8qYbebv+g+VT8y35l+psHzJoct/WLdIVKhBMkNL9Nu7D5gcU98tSYrJLo9WAVCp0yA9dFvlXlSrQGfTR8XICbpJJAXpxFux/2MhOpEnrpCpX4MSWwlg7DtntdP+GDYy42S
 QZEfVZFS
 8QflF3T0HLGaEk3gQwurGovLkkQSXIVPJuyEc0QRoLwyg0pCgIPjgkxJ6RW0WrKPzINX9iXtBI8oUuD/gHeJU0tBQq46VyU0tXm/2w1ue1OXk7UOi8NdkD5qxyVBlmtoaSymSVep+GX+OH/OP5lQ4o3inUnIHQzhRT/LEug5Hxke0ZHAW3///m7shwffg1XZCxCrwnODgMaXygsg5RDGxgft6fRKIpTIaXV/ndeqKt55/HunoUuWlO6FMNU6cLuoDjm4oEeFwtOx2BfdsAnxnKMN1reuhuM7ogPHfuk45LTEMw9lAuVx1vz7+aIhSkf6Y7U47
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/18/26 5:52 PM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> As Qi mentioned [1], when swappiness=max (SWAPPINESS_ANON_ONLY) is set,
> the reclaim logic is expected to reclaim anonymous pages exclusively.
> However, due to the current ordering of checks in get_scan_count(),
> file pages may still be evicted if can_reclaim_anon_pages() returns
> false, which contradicts the semantics of SWAPPINESS_ANON_ONLY.
> 
> Reproducer in a cgroup holding 64M of file cache, with no swap configured:
> 
>    Before (file cache is wrongly evicted):
>      # cat memory.stat
>      anon 196608
>      file 67178496
>      pgscan_proactive 0
>      # echo "64M swappiness=max" > memory.reclaim
>      # cat memory.stat
>      anon 208896
>      file 4096                 <- page cache evicted
>      pgsteal_proactive 16400
>      pgscan_proactive 16400
> 
>    After (file cache is left intact):
>      # cat memory.stat
>      anon 200704
>      file 67178496
>      pgscan_proactive 0
>      # echo "64M swappiness=max" > memory.reclaim
>      -bash: echo: write error: Resource temporarily unavailable
>      # cat memory.stat
>      anon 208896
>      file 67178496             <- page cache untouched
>      pgsteal_proactive 0
>      pgscan_proactive 0
> 
> Fix this by bailing out early when SWAPPINESS_ANON_ONLY is set and no
> anonymous pages are reclaimable, before falling back to file reclaim.
> 
> [1] https://lore.kernel.org/cgroups/7ddf3eee-5fe2-45f7-8614-c8936a039e04@linux.dev/
> 
> Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim for only anon reclaim")
> Suggested-by: Qi Zheng <qi.zheng@linux.dev>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>   mm/vmscan.c | 18 +++++++++++-------
>   1 file changed, 11 insertions(+), 7 deletions(-)

Thanks for the fix!

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..d6b383d96a0c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2501,6 +2501,17 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>   	enum scan_balance scan_balance;
>   	enum lru_list lru;
>   
> +	/* Proactive reclaim initiated by userspace for anonymous memory only */
> +	if (swappiness == SWAPPINESS_ANON_ONLY) {
> +		WARN_ON_ONCE(!sc->proactive);
> +		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
> +			memset(nr, 0, sizeof(*nr) * NR_LRU_LISTS);
> +			return;
> +		}
> +		scan_balance = SCAN_ANON;
> +		goto out;
> +	}
> +
>   	/* If we have no swap space, do not bother scanning anon folios. */
>   	if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
>   		scan_balance = SCAN_FILE;
> @@ -2519,13 +2530,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
>   		goto out;
>   	}
>   
> -	/* Proactive reclaim initiated by userspace for anonymous memory only */
> -	if (swappiness == SWAPPINESS_ANON_ONLY) {
> -		WARN_ON_ONCE(!sc->proactive);
> -		scan_balance = SCAN_ANON;
> -		goto out;
> -	}
> -
>   	/*
>   	 * Do not apply any pressure balancing cleverness when the
>   	 * system is close to OOM, scan both anon and file equally


