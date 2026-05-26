Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CD6ECD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 15:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42F996B00CF; Tue, 26 May 2026 11:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407C86B00D1; Tue, 26 May 2026 11:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345776B00D3; Tue, 26 May 2026 11:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22ED96B00CF
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:33:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF9031401D8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:33:49 +0000 (UTC)
X-FDA: 84809966178.23.DDF39CE
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id C5504C0004
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:33:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xi7XAV3l;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779809628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHV2IZakIJ6ChTDpKQtKC37v7LOZC1b1R6tmDq4OICA=;
	b=lqzn9iSCw9ifX+MZkJStGX8BzqWCfNJulzwj8XfpdQ1nXMdGFUQZhKll3DvgfjUvOLzo73
	oV0XhI34aP2IXv8pMtQNZAkOvx1l5hhv6FI/H1oswsHwEM5SkZ1/BhNc1R0sQwou9S5ph2
	N7sjnNfzg+DWXBs2rBaGw7Amyf8YDDg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xi7XAV3l;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779809628; a=rsa-sha256;
	cv=none;
	b=3Iogz/+mIipJD4dN+klb65Qinr704SZ5VS1WmA6in5+GG9YUgEwiEpDwp6f6XWAwQnli5v
	jmqpCHI62Q9+Wz1erIpWptJxb4mA7IKOuDthPJXupgTEeTHGCbrvHDu37Haeo2d3mwoiPw
	YC7ptlMcrbb4kT1xBVg31DuBxvQgJ5k=
Date: Tue, 26 May 2026 23:33:37 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779809625;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NHV2IZakIJ6ChTDpKQtKC37v7LOZC1b1R6tmDq4OICA=;
	b=Xi7XAV3lh9hYv2hFye5tI8gAsLnnSPo2uW/9r0tMSCh/Kd9CO/NqZYX0/zQtQch+Xf02+m
	tDdsa0IFcReKI/y+7D2fLOL7nESYfktQq5z/ewCd8n800Ht2D8N5M9LUyimL08QfnFdF8c
	GNqblj8Rv4P4X1DQvrp+bSOcQg+AKXk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v6 3/4] mm: memcontrol: add interfaces for swap tier
 selection
Message-ID: <ahW9UQH93jBT_VaD@MiWiFi-R3L-srv>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-4-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421055323.940344-4-youngjun.park@lge.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C5504C0004
X-Stat-Signature: 7ooqfqed3wjqa96g5cqieqeoot9hspd4
X-Rspam-User: 
X-HE-Tag: 1779809627-585551
X-HE-Meta: U2FsdGVkX1+GCbR56d2m0xk4IkEENELsPIw/kOZmCUGBqzrZhDn7xNpALKZ7NWMxscTGd3/U6bUTQcb1VtCcLc7Tra1jua9QmRpmbEAMbYoKVOmrL5FybYDz31K6V6zW1PmQEysE7XtiOGEE9oExitOzunOxm3s1ituxKbCcWTRtMmQ5Wdz5qpRJiu7MNbMciymMXVwUnaN0BTeWXQ9g8UdgxCFSKBv2RQYMrXlrB6DP527HJPtYvyLHEqqzP3+b+p9Gc9072Nc+M/fv56WvoE8vgk2jPh8xmuyQLyhpssrR5T3F7yfZ1ape2nIbiKZou+YXszr8e1PcRbgbR6vUCYjQTLSorJMS7n47VyeAc43IUGUx+hB1/3yluNJj/dOxRQ15N4/E9L5UZAgppZAPmisvvtAqAmVstcOSouNVehuane3Hu5oQQfydbVidpugVoJ+osRSwLL4rwSirMJLYorKq0zRi/FW2Xv3UzKVsa/bockAqT2lZC0OtCLgQt2jhT/vJeXwuEL/s+Hp1vLIHsTHHz2ChxHAq7KT7eoh5utsDw7RXrwlu7t1ala0YTi/R8Vt24cgwkImVQKWsghzpMqctv2hfyX9b9ie7SRhSpS770YIz6szAh4cf2lKqPyReyEBCk31Ru9+HW3Ivua7zX981rOZmEHeOwJ3keyTIg6aieDeVdMXyDKJP2eiFLl5jGo8pxkS2CKr00bqy5eATa6QhuDxD/bzwR8x9YZfpGC+GDyUXjodrPKE9jyNZ5E3VNU/kMD46zRKw+86E+dKLpcStrtkfUvTwiPox2Q87Syu408KSZE03PPLv7vIW7zep0pBx6+3yxJNHdGCVkfO1Vl5U2O9nWeHjTyV3xl/lP+9WFFjTsMYqw5+lY78KCcfGTuelATv+/Xh4Et4zkKsOm1+YRxvjk1yUvC0UrWHDYDO4KOif7XcDKgCSJ8ZdRMhf32TuDn4cB+Nv+Hp9t2G
 T7CPcB1+
 7z8fTF9pRDh4xRXSI6gRggVMf3EzygM94RThLsTmsArrfNJuMe9Z3QM8kyBervjFkMGR/ZoclukKWae1PIfI2tAyvC1fwQsEN9NOIHL2DQjTjqUhaKBd2bHAvX/NtcG4I3gRjNEgDpCAdRep/5J9wWSYNN0tAkuRm+ixzsrCZKjBsu2Kfpkb0leLKpey3Q+yIW5JLXGwENp/zPxgwK1nep8wJ0Lr/wIed4YYHSw2UOVpwTytlBluU5MUrNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/21/26 at 02:53pm, Youngjun Park wrote:
...snip...
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c3d98ab41f1f..0f67572e5e3e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -68,6 +68,7 @@
>  #include <net/ip.h>
>  #include "slab.h"
>  #include "memcontrol-v1.h"
> +#include "swap_tier.h"
>  
>  #include <linux/uaccess.h>
>  
> @@ -4130,6 +4131,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  	refcount_set(&memcg->id.ref, 1);
>  	css_get(css);
>  
> +	swap_tiers_memcg_inherit_mask(memcg);
> +
>  	/*
>  	 * Ensure mem_cgroup_from_private_id() works once we're fully online.
>  	 *
> @@ -5667,6 +5670,88 @@ static int swap_events_show(struct seq_file *m, void *v)
>  	return 0;
>  }
>  
> +static int swap_tier_show(struct seq_file *m, void *v)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
> +
> +	swap_tiers_mask_show(m, READ_ONCE(memcg->tier_mask));
> +	return 0;
> +}
> +
> +static ssize_t swap_tier_write(struct kernfs_open_file *of,
> +				char *buf, size_t nbytes, loff_t off)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
> +	char *pos, *token;
> +	int ret = 0;
> +	int original_mask = 0;
> +
> +	pos = strstrip(buf);
> +
> +	spin_lock(&swap_tier_lock);
> +	if (!*pos) {
> +		WRITE_ONCE(memcg->tier_mask, TIER_ALL_MASK);
> +		goto sync;
> +	}
> +
> +	original_mask = memcg->tier_mask;
> +
> +	while ((token = strsep(&pos, " \t\n")) != NULL) {
> +		int mask;
> +
> +		if (!*token)
> +			continue;
> +
> +		if (token[0] != '-' && token[0] != '+') {
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +
> +		mask = swap_tiers_mask_lookup(token+1);
> +		if (!mask) {
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +
> +		/*
> +		 * if child already set, cannot add that tiers for hierarch mismatching.
> +		 * parent compatible, child must respect parent selected swap device.
> +		 */

This paragraph of code comment sounds a little unnatural. We are writing
it into memcg, the child memcg is handled in
swap_tiers_memcg_sync_mask(), isn't it? I don't get the 2nd sentence.
Could you help explain?

> +		switch (token[0]) {
> +		case '-':
> +			WRITE_ONCE(memcg->tier_mask,
> +				   memcg->tier_mask & ~mask);
> +			break;
> +		case '+':
> +			WRITE_ONCE(memcg->tier_mask,
> +				   memcg->tier_mask | mask);
> +			break;
> +		default:
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		if (ret)
> +			goto err;
> +	}
> +
> +sync:
> +	swap_tiers_memcg_sync_mask(memcg);
> +err:
> +	if (ret)
> +		WRITE_ONCE(memcg->tier_mask, original_mask);
> +	spin_unlock(&swap_tier_lock);
> +	return ret ? ret : nbytes;
> +}
> +
...snip...

