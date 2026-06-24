Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FE0ECDB47C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 10:50:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844BC6B008C; Wed, 24 Jun 2026 06:50:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F6266B0092; Wed, 24 Jun 2026 06:50:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C766B0093; Wed, 24 Jun 2026 06:50:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 444566B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:50:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BABB21202F0
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:50:05 +0000 (UTC)
X-FDA: 84914486370.09.6FF5B38
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id DD37040004
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:50:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dodVbHfz;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782298204;
	b=KMNO02XJIHkDXWNNx4cHPQhDlZjR6uDj/t3yPf6m2DnnQWqK8G7A5eCARuoTtyEWfXF1mD
	K4nr7M81zKWIG3u4gL18mNz1z/xg9kCvNs2X6svezuTin5U2oCGe3ym8YBfzqEFf+rPgcq
	64TdDe99dTpCv+8IOj4KVTumxMaV6hc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782298204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mrZgZAxK/d8Sr7imB6CtH4WhUFTzUDkZdoGNYzzUyeY=;
	b=ZZiLR9HC0bz4NvLHdRZioExUfaXh0r44xIhj2we27QegfQVC4NSMTC9zcKhSDi0jxiUxod
	9lb+1pFMlwebf1dy1xxPbJLgi036e58PXG2/LSpXtDiWLwOQMTotGpsSCisjZTCM7vjl/t
	rdQOHeKbzXFS2UpMQxYLcJx2eELZu9Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dodVbHfz;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <923f391a-d760-4d78-92d4-2e765aa226f3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782298201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mrZgZAxK/d8Sr7imB6CtH4WhUFTzUDkZdoGNYzzUyeY=;
	b=dodVbHfzsffqK+xwGay6rvpUQ3RM3hjjHpwBjl0gzpexVQVl7fz+nhe7gKMCPR12z+XqsY
	3LcbU2ZuvnzGOEYepJhj1hTnJwufgOrwpCDeozFjkRStF5eoGRQunfWMM9CRbUzxFR5ijn
	zosh6UlIA51uG5ZxAvPFX59g+Js+aIY=
Date: Wed, 24 Jun 2026 18:49:07 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/shrinker: add NULL checks after rcu_dereference()
 in shrinker bit functions
To: fffsqian@163.com, Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Qingshuang Fu <fuqingshuang@kylinos.cn>
References: <20260624095527.277586-1-fffsqian@163.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260624095527.277586-1-fffsqian@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fdpsrck1g9hpbcdiczxtgb9z3w54y37h
X-Rspam-User: 
X-Rspamd-Queue-Id: DD37040004
X-Rspamd-Server: rspam02
X-HE-Tag: 1782298203-239647
X-HE-Meta: U2FsdGVkX19QuM+qq7XqFGtM8HbfOeHuRMcG4sPYAVrFSMpAOyh25tyHdEu3DAEV3BmqBe6OhUneZjKDTaC+1AmtRRZGSklEJDLUUAbHindWGCKSxJfTNkxce0eFIrhkiCAwmuPVEkXpHdqeqy753hiOT96QRFVPZfKa+XhpzeHoRCt0Q5sy9ubbnYqdnagVz7DTPYs4e7UtS8ExArlF1KcpDRg0nk3FCmdfUo2YP5AKMotRL0sZakM0GIZIh15Etnkwly74N+t0uQ34jidoMyjqG5Jek67QbXLx/3dtZTFQ8NSTmZsBup2JAhKQxxWnhgQhLPndGE4BCaERUKAlFjEUg+BIyuPm1+vAcp3Za2FHhNBFkSBUJ6LMAdB8BmapaDRKlDTzwTfA4G0SFibonU+kBAcAfDaLENi5ZIRQk2g+ys2dL6GmJ+qebmxbhuEu8cynOB7X9PZE18B2GzTF1e5oh5iCn07oN9oqM19HHmOujcpPoEMrY8mH5T4TarK3/TiySFM2t4yg9G7SSM/UBugGmm6V2qs8RF7+/HYrkGXySxCNk9HHD5UVol9gfEibxBfShc0qbfk8FZumVwnS0t2pKjuz52afFNo4ak8U0WKAWupIlyC3DejicrLRDqBHi3Hdjz3N1Ruhq+VHK3AOTPn+qZqt5i+7Xu9CwxKH8LRL+HqTSZfeLBkjaFMRryYigXpkaBImi8+T/wG63UCuWBDDnkpW2cncj4PA99tOPV29kvwgq8HCJ8n5ngjd4roiOMaG2LXBWhRYx6wM9dF0Lc7VL/9QUKE3ZbZ053+1fKnkFys7jxuK5llRZ6scHGYlaymhor1KZlqsMqsejP5SkH32ecIDN+8Ov38Y13vcj+V9PXieRQ+6c3bm9oTmnc+aJAsDSTm7qrj6FpLWiGsb1AJJYlXvivNnIdLbToMHL9X4k7Zl4fBD8VG5afwpOGFBpnBB1iNLbO3aWkqNmmz
 up3rTtLE
 MYNAEURbr96T1yYmPnFOfqKOILacGvNgdVAAY54zh5iFEKR5K8bxFK9GNks/rsEsuKwbQZwzlha60UXYhEvRl1g6mpKBgOVZQG0z+nXw0mAM6AqA1YZ5ugSXvgpisIQb/Knb+ojdQrrfEs4j/fmF7W4t3pbjqyqhomCuFAi36hVK0rfPMGsGKA8Fls+tpJiw7DFiZ+YpH8FQztiOEMgj2pCQ0+uX65vnnVXTHxarEakdkRMgKCxSy8oZh1mVLLF0OgFURkuXWU8HP5YxjSd/o2CiHSi2zAj62a7j51/0YoM6PlXDiRYHFv4piMo+o7kyvapcPBzf1YgzgJkbJIRWwwG5iijg1LeHxxgeGcY4DJxAVeTiAOn6Al+P1Sr+9Ho3Pjn89uiYjGHdz2n41OFb83094X5LOYQCj9Lo0uFWRtLIr55J9J9RbW6HqCAp7gsXRRwNySsIZbyepD8Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Qingshuang,

On 6/24/26 5:55 PM, fffsqian@163.com wrote:
> From: Qingshuang Fu <fuqingshuang@kylinos.cn>
> 
> The functions set_shrinker_bit(), xchg_nr_deferred_memcg(), and
> add_nr_deferred_memcg() access shrinker_info fields immediately
> after rcu_dereference() without checking for NULL.
> 
> This is inconsistent with shrink_slab_memcg() which properly checks
> "if (unlikely(!info)) goto unlock;" before accessing info fields.
> 
> The shrinker_info can be NULL during memcg initialization or after
> shrinker_info expansion failure. Directly accessing info->map_nr_max
> or info->unit[] without NULL validation could cause kernel NULL
> pointer dereference and panic.

Really? Did you actually hit this issue, or are you able to reproduce
it? Or is it just spotted via code inspection?

The callers in all three of these places should guarantee that `info`
can not possibly be NULL. :(

Thanks,
Qi

> 
> Fix this by adding proper NULL checks in all three functions to
> ensure consistent RCU protection and prevent potential crashes in
> the shrinker subsystem.
> 
> Fixes: 307bececcd1205bcb ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Qi Zheng <qi.zheng@linux.dev>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: linux-mm@kvack.org
> Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
> ---
>   mm/shrinker.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 7082d01c8c9d..ecde3cc44459 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -200,6 +200,8 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
>   
>   		rcu_read_lock();
>   		info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
> +		if (unlikely(!info))
> +			goto unlock;
>   		if (!WARN_ON_ONCE(shrinker_id >= info->map_nr_max)) {
>   			struct shrinker_info_unit *unit;
>   
> @@ -208,6 +210,7 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
>   			smp_mb__before_atomic();
>   			set_bit(shrinker_id_to_offset(shrinker_id), unit->map);
>   		}
> +unlock:
>   		rcu_read_unlock();
>   	}
>   }
> @@ -258,6 +261,10 @@ static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
>   
>   	rcu_read_lock();
>   	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
> +	if (unlikely(!info)) {
> +		rcu_read_unlock();
> +		return 0;
> +	}
>   	unit = info->unit[shrinker_id_to_index(shrinker->id)];
>   	nr_deferred = atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)], 0);
>   	rcu_read_unlock();
> @@ -274,6 +281,10 @@ static long add_nr_deferred_memcg(long nr, int nid, struct shrinker *shrinker,
>   
>   	rcu_read_lock();
>   	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
> +	if (unlikely(!info)) {
> +		rcu_read_unlock();
> +		return 0;
> +	}
>   	unit = info->unit[shrinker_id_to_index(shrinker->id)];
>   	nr_deferred =
>   		atomic_long_add_return(nr, &unit->nr_deferred[shrinker_id_to_offset(shrinker->id)]);
> 
> base-commit: 840ef6c78e6a2f694b578ecb9063241c992aaa9e


