Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD216CD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 02:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18BC46B0093; Thu, 21 May 2026 22:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C746B0095; Thu, 21 May 2026 22:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 079376B0096; Thu, 21 May 2026 22:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED25C6B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:30:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD3B31C07EF
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:30:58 +0000 (UTC)
X-FDA: 84793478196.04.1F86DFB
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 00B4114000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:30:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uUx+J4o8;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779417057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enZ07UUD/dUvPxdM28XuPg5nVhcBIDCqUxCVn7GaHkI=;
	b=euKo5GVR4ggNAfxdgc7yJJv/XaPOLwZZQC06oUNeRhiVUrDqu8M1ImTUIbeWYOKiCpGLIF
	AerHPzXPnwJ5UYG5seCZIgjLXowUVoqUDHsmp3Fvr61cWXGTD0fZCxb6jGwpnrT8+R883D
	3ZphadBKwGHVaXKcsKn49Q78rLaEe5I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uUx+J4o8;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779417057; a=rsa-sha256;
	cv=none;
	b=EQU1dpJLOBrCNl2PnTY4UOEpXU1VYXllJEMUvEaUilI4C43a7KdWg7e75d3phoE5T2TVFf
	y1Rk3UPnojpBG2B6lFmgXY9ym7nJALPvdX1vY3DtyS9VXf+QgssU5i8z5c6A+lv5l3zeeu
	iV2ZFu/eLEM8lz6dTMO+cTquljo4aDw=
Message-ID: <73ecdf3d-b570-409f-8337-a0cc1b4c6bcf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779417053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=enZ07UUD/dUvPxdM28XuPg5nVhcBIDCqUxCVn7GaHkI=;
	b=uUx+J4o8nnyoKeh/N/7P6AhF3Rw1Uq+7o3h84Q8MltYeqoXUHp0hK4wY2bgSulGOGq3tTC
	OHjClnYtV2KLFy4c5df57NsJPFCYUzvYJB4pu/VvqP0l39sH+UGw55PdPlzvZZXlU1fa1Z
	Rn9sRAnPNPM68hASVmlvM54qT4W9lN0=
Date: Fri, 22 May 2026 10:30:33 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/4] memcg: int16_t for cached slab stats
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Harry Yoo <harry@kernel.org>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
 <20260522011908.1669332-4-shakeel.butt@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260522011908.1669332-4-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: d7r464x9ksaem5mbz4pye9exu7oz5wu3
X-Rspamd-Queue-Id: 00B4114000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779417056-868107
X-HE-Meta: U2FsdGVkX1/aneldqSQvAAdXX05LS6lv8bfgLBGo9HzROES4HgyiET8WLqMBLrG7qfx+nXOitlOqLHzXDBQBO/gP/G/uVMwsrAXkbWGYmO2Y1VE1KWNlB4xGsdau6XMDksblfFRezOpdb11NZhTYKJS9BHwyXjQCsC4qgLN/0usO80e5gBtvp1R8X7dPh51pkg1QpXyHFfokA4Y8tA9+qzM9Mhu5f3OvmB9jpzSRmvsviKt9H7CqC5/UDtWhobPNwTFEboy7PAlhIP8mw0SH6wwBTBtxyzOsPpf3C3bj3r17LQoGnUyzBOmfplBM6nXsay4rSES1P0uKQOdXkVo0U3KOSTc37SOkh83o2fevf5RCU2f0qVcAUogAbwqaCIFaSRfldZ/Yb2F5G0jHc0HPVMZKCZgISV6lgQ8sQt2K1DxJi8i8MGCeU5wOutWl/FZyqhakSbSiDrI4KRBhhnwrnXguWHxLMCTR7FYlAGgjQmVQZD5sIHTVbf/xaNGF6lwZCDkAqkg15Ck+tJCN2uYKawXVwsHeVgLvvIotK92QkcTWriUlgS3Nta7NQAiMYiboRCTIRjb7Ey51B9xZhqg1bUZKlxzfrWdvAXj/QmX6393J7ZMJ7jLxWaH9Sk6kZDKNhLp2w7nMrKIup2tgU3t/vB2tIP8SsBQjUpBEZyhSio0tWGNJe1uvDwEmHsf4GJAu3U4IubzD8IABhBo7gRqwlIayZQwh2FTpvAA0QjhQdtsTkfQyK6cTRX4VvHU9zpNnVidpeRjkHEHDQePxD2qKzzJ3ytGrVflZ7B7Ojjwj3JVBZUatx2ivjKIT08eUbFgQFKfIVtdPns+pKtpxUeaF6UZuIFahirTNy5sPvsKOfMB0DHra//uzA0he4fZZ99Wv1O7tfSoedr5pPDXQOlE+bB48HUrziGYbT7+A6hfelnIW/VXiiOKd+UuONe5odx0cWK1z4mPabqs7LA8Co9I
 q42Wym2B
 IxWXfqzj5PQX2KPCJrJS9K1f00+iA/UA2CUnsnda/oRRTjB8aCiKFVQin24TrLE9WEp/4Xp2qUr9ZFF14dyYzvoGzwZb1Ru9KiSTzqWl/kvfNDoBjxgGFzZ3uLB4wZWzxKUGZiPzy3pQr2L7+riMhmrz8PMoI2/A/gf9pCYXfTi9dcUtLwRzKjSs5V1V0JcdrWsZWw1UKVWkBnWnL5rexTH8mhdAE0/bJHyM2zFD17rvOVobjIbZ1sqJ7Lsh4+jOqR8ND6QwnSOcj4MoW1Nk9uuBE2ooFEH+OtpTYO+ql1kgZO5OVEhvRj6C+jVMME43gFiG2ATA9w+/lVRlfHMU+WlLsJAU6SELrBchNLaD2uboGgTotQ/UVFkR0rA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/22/26 9:19 AM, Shakeel Butt wrote:
> Currently struct obj_stock_pcp stores cached slab stats in 'int' which
> is 4 bytes per counter on 64-bit machines. Switch them to int16_t to
> shrink the cached metadata.
> 
> The existing PAGE_SIZE flush in __account_obj_stock() bounds *bytes at
> PAGE_SIZE on 4KiB and 16KiB page archs, well within int16_t. On 64KiB
> pages PAGE_SIZE is well above S16_MAX so that flush never fires, and a
> sufficiently long run of accumulations would overflow the cache. Add
> an explicit S16_MAX guard before each add: when the next add would
> push abs(*bytes) past S16_MAX, fold the cached value into @nr and
> flush directly via mod_objcg_mlstate() before the accumulation.
> 
> Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
> Tested-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
> 
> Changes since v2:
> - Collected tags
> 
>   mm/memcontrol.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks!


