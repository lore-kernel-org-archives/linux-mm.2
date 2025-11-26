Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58A6DD10372
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 02:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B206B000C; Tue, 25 Nov 2025 21:49:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB336B000D; Tue, 25 Nov 2025 21:49:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BA116B000E; Tue, 25 Nov 2025 21:49:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 566796B000C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 21:49:44 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02533C0822
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 02:49:43 +0000 (UTC)
X-FDA: 84151227888.26.DCF786A
Received: from sg-1-100.ptr.blmpb.com (sg-1-100.ptr.blmpb.com [118.26.132.100])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5116D40014
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 02:49:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=BrbkkfWY;
	spf=pass (imf04.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764125382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UnzWgwkKcFm0gU3oBGsqS8ePUelMPsY6QLSmu1dv/sA=;
	b=yFjAJzfyV1MrxRUoEGMsqnEkgwE+ZstYHly6IglJZDaVTcqjZLu3o8F/s/MvZrMj1N4Mdq
	f5mYe0ciH3S3yBdkUVJWDVsUPuJiIrM/bQ9rzOqmqiE6N7Z6aZcGNWj1XzHf6yPXkmKgAI
	bv9jQI8lWUHq99R5xvQ/7j0e6FAOaaA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764125382; a=rsa-sha256;
	cv=none;
	b=IJE9PSGZkQQwTrGEAKEQScSSEzdb5kdtOOsHRsBroJ/YE0TEQmYG4Q6RuF/KlWXMw/3GZy
	gDfYZgWYgPXI9RXcKM/avyhyqxjIDgheDMhdiAr6LjAUabVqj/hpy5JJERuHBj5NUPH/U3
	JsWNKdaweZsO/OivNdUyuya+X2DytRw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=BrbkkfWY;
	spf=pass (imf04.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 118.26.132.100 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1764125374; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=UnzWgwkKcFm0gU3oBGsqS8ePUelMPsY6QLSmu1dv/sA=;
 b=BrbkkfWYa2fAd1HS0Q5g0vSA5Cz9j0XaeL7CLGQmDmeWDNj1w04DEQBhwnUrkXbAXLA41J
 PVfDBoFMDY2i2VWLVR258v1abbzud35z1qjLN3VF5sc1awCCHMf5nmUTPGR5S0SoY/EvUn
 eFx3VrU1OoMyDNssGzl5o8qjeUJgmxjcECg1qS3K+DTEUlPut1eeMMPA61BPuQbnrKfEYx
 UFGd2Vt2Tu/tPfjVLA84mxsPbiAo7vDXFLJv6f1dYvKC7nsXKnbSejRyxHbk+c4Y0IVkv7
 mR/d+HIp2sSxxKXzcsBslCGc3qtmTiuwTTxNGCdnXJFNq49vbGPKYDciUPG4cA==
Subject: Re: [PATCH -next] memcg: Remove inc/dec_lruvec_kmem_state helpers
References: <20251126020435.1511637-1-chenridong@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+269266abc+c2e4b8+kvack.org+zhengqi.arch@bytedance.com>
To: "Chen Ridong" <chenridong@huaweicloud.com>, <hannes@cmpxchg.org>, 
	<mhocko@kernel.org>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <muchun.song@linux.dev>, 
	<akpm@linux-foundation.org>, <david@kernel.org>, 
	<lorenzo.stoakes@oracle.com>, <axelrasmussen@google.com>, 
	<yuanchu@google.com>, <weixugc@google.com>
Date: Wed, 26 Nov 2025 10:49:14 +0800
Mime-Version: 1.0
X-Original-From: Qi Zheng <zhengqi.arch@bytedance.com>
Message-Id: <e8d2c5b3-eee2-46fd-9d67-422428bd8bf5@bytedance.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <20251126020435.1511637-1-chenridong@huaweicloud.com>
Cc: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, <lujialin4@huawei.com>, 
	<chenridong@huawei.com>
From: "Qi Zheng" <zhengqi.arch@bytedance.com>
User-Agent: Mozilla Thunderbird
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5116D40014
X-Stat-Signature: 3nn6ywjz6y87qseryn5p3w6gc68tg8js
X-Rspam-User: 
X-HE-Tag: 1764125380-827628
X-HE-Meta: U2FsdGVkX1+R1FOoa5kDlEYxrDx0s8ZW9DeR2hPpbAwh/uPg3/lqEPaidToOsPceH4vRUIvMZdTbXTbICjb753UbhwlXeWUKWjTPIghs+u5dA6pGsCtUnWrKqg5njcgRFUZT7DaP6GK25NWTngRa3j6c7TWEi0dFrAXXEqQQfEB2sUzRuYg4V+im/v9AKjzFIK7RgLYowxKexEo12uKQqjsY8Ltk0jc60JGykBmgAiyR7SRsIqhyyToDYRFKxGXDEQameREQ/11GTdUMapsUcSiFttH2p284avjULxgghcg7lYIMRzgWmHAYrYolw/rleH+LxXEoQLSY5C9vvyahHJhtsKpXQfeACoMZ0qnLzrMW5IUVs2dqyECtbRq7qLKRoeBgpxNathuPapXSfHgHmCmGQE3YnZUj676KCq17txJQwsMOr4cOGyd5jemW+LF3vqKqr67EMQp4lf8fB1mFG/d4J7P+3vk6DiDwFYi8X3ktVpofgiy6SykbF2rjAPU+Lz9TNRp31UX+oAdD5oWrWg5nbhp/+KlJl6mDPZTobO5NgpSnWfKt+DHGD/KWRjwu3K050UnWwdx8z30HJ0dJxNKyyDSFQ/XxWujRNo5ojiUZezHOTN63B/+WDvWInkJZjo1eVTkDrzET50Qr2XiDpZAIO/g0E6L38jYG7OiJm7Dv/czHLBgKwDJ10kjtO04eZwBT9EaSigO6XzbkucgBvr9Ca8t7zS7c/GSMKu+sjDSBfbSm4TtqNBR3CEF0yfdwz/6IzoUPt09ZfLdIsESbVCOS5xgscrUhUlCJyfvLFNXpgPoSPr0DcvIpCULlD0JYvuKA+ZGJVvXPlksvqh+3YF2PvmPdhVB302Fpj5RjktqnZYYMsFRKxdLOcvO+oBirE7aackErEvUHt6DqP9//UEFEuitM2S+Hl3ES/c/CrLhsdi0Izi6qoO1/OWr/PJ/FOOMAiJAxZJNIFoOe10Z
 hYKPSglr
 pTrZ/erFq58MnRZYf4GWs3pMDCfqCbPNvsVG97m6SgNa644G+8yeju5HTBHdUrXIHuFCG4N6P8YJjYNfDYayKzt34oBBciTPwVizyZPYJqo+VRsdup1Gen4JETV2TDHxU5Br9+qYKsfDjLajzWH8kyBNhr1X2lGe7bjuThwE6apv+JeW1GrH/4bKA9TjNciMaBBPfm73EX6UR/jFR4RiVvu+ak4wQR/8+8+DpZ/2upY0RaRGJrrwGqDhU2ZoTAgAWysSQ9UzcyG1Bo/RIVKspKFCFxfTSdaDaqyYBDE4MeS0bDasGTDWFeaM/wWgJ3/fJ7soP0xUCBU35PZsfjQIo7JZoZyMVta6stixVZWbsCBJrfW0IIFZAXRW0qrw4qs1nCsuemjUPZ1Q+ArD4FCIfem9/ww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 10:04 AM, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The dec_lruvec_kmem_state helper is unused by any caller and can be safely
> removed. Meanwhile, the inc_lruvec_kmem_state helper is only referenced by
> shadow_lru_isolate, retaining these two helpers is unnecessary. This patch
> removes both helper functions to eliminate redundant code.

Make sense.

Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>

> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> ---
>   include/linux/memcontrol.h | 10 ----------
>   mm/workingset.c            |  2 +-
>   2 files changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index d35390f9892a..0651865a4564 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1452,16 +1452,6 @@ struct slabobj_ext {
>   #endif
>   } __aligned(8);
>   
> -static inline void inc_lruvec_kmem_state(void *p, enum node_stat_item idx)
> -{
> -	mod_lruvec_kmem_state(p, idx, 1);
> -}
> -
> -static inline void dec_lruvec_kmem_state(void *p, enum node_stat_item idx)
> -{
> -	mod_lruvec_kmem_state(p, idx, -1);
> -}
> -
>   static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
>   {
>   	struct mem_cgroup *memcg;
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 892f6fe94ea9..e9f05634747a 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -749,7 +749,7 @@ static enum lru_status shadow_lru_isolate(struct list_head *item,
>   	if (WARN_ON_ONCE(node->count != node->nr_values))
>   		goto out_invalid;
>   	xa_delete_node(node, workingset_update_node);
> -	inc_lruvec_kmem_state(node, WORKINGSET_NODERECLAIM);
> +	mod_lruvec_kmem_state(node, WORKINGSET_NODERECLAIM, 1);
>   
>   out_invalid:
>   	xa_unlock_irq(&mapping->i_pages);

