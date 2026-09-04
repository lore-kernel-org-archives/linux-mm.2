Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E476C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 22:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56EED6B008C; Fri,  4 Sep 2026 18:47:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520AA6B0092; Fri,  4 Sep 2026 18:47:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4371B6B0095; Fri,  4 Sep 2026 18:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 209636B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:47:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E657401DC
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:47:31 +0000 (UTC)
X-FDA: 85177567902.21.9BBDF57
Received: from mta1.migadu.com (out-193.mta1.migadu.com [95.215.58.193])
	by imf07.hostedemail.com (Postfix) with ESMTP id 61C8D40003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:47:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uvmke9U0;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.193 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788562049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nkyUrnYDQRydjOT5olSmwa51aJvk4laIuNZNphIU1G0=;
	b=YqluneELseaQtyOVpGKNxT6qeysFapmwkbq8ZkNQp+NczlR2KD8LMki+2cruaXEeUq5ai5
	S5aCCtq1Rzl7WGH5fVzAgMr0MhAchAtqtJFQDAM0oylyX2fwNauGrtIZElPJXThPCx9PEd
	mWM466g518Oj0dO1QwvHkMZH81Xw088=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788562049;
	b=Xj+T8LjxAIOrXl3H+plxvu+G7/IbIrkzK6jNZZpV/eOgK+Mb1reTBOalj58yBK6CuY5VaW
	tbK5WpjoodAO8PLE07lQeS/+mf8VgRuUY5lJ+MXE4EGyUMRzQOUzNJINxp30/Ea8/YukOe
	xBZHoe/N1qv2uSSCj3vXDOND4eJtZZU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uvmke9U0;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.193 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=a9LWtZEwa63QJ3Ja33Gs2KV3YWbCdmNNXpX1BLghxQk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788562047; v=1; x=1789166847;
 b=uvmke9U0SECNi9AL1bXd/PYSoouG969CYCJqT+hKYaz5DTcBTMUrdHVOX81GM3+WfuNPXjfy
 Awh8hWU7jaLEQvJoSGruF6ZiVD5Vb6SvRlskOo/TUheP9q9aCMzVTzNs3ieOmT8i0ydlDrSR2JZ
 pTkfi8F6ygVbUSEZlGd4WLjU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1e87ab9cb44541fb;
	Fri, 04 Sep 2026 22:47:27 +0000
X-Mizu-Trace-ID: 1e87ab9cb44541fb
X-Migadu-Flow: FLOW_OUT
Date: Fri, 4 Sep 2026 15:47:22 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	dev@lankhorst.se, mripard@kernel.org, nat@pixelcluster.dev, tj@kernel.org, 
	mkoutny@suse.com, osalvador@suse.de, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, kernel-team@meta.com
Subject: Re: [PATCH v5 3/7] mm/page_counter: introduce per-page_counter stock
Message-ID: <aptJ5qQfjMB-24WB@linux.dev>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
 <20260831163752.2193337-4-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260831163752.2193337-4-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 61C8D40003
X-Stat-Signature: z1a8irekwpbr8twbt15ihd7dnj3xd81s
X-HE-Tag: 1788562049-776534
X-HE-Meta: U2FsdGVkX19bgnl9wwCfgjIstuc4GEIpQM4Q1W2DZrtcknQ5oSWBk4ZNlrrBwxJ0GNDGMO4krr/XgFnojIdv7zhEHav4iTRZ0NxWafx87ba54H0FtZqTd6FHu+III0ujUbYTl4PRyfaFOMO3LtRNvLwgVSR6XFPA8dX/niRwtE0OBiP+hwFnucITegi9YPKid4mf/SMf/GVgDD+UStShkInhFm/T+/bJaGAcbcMPkfMp1iHBVlflTY/WhK0pa5fS+fuT1Ijn4PH9tlmcDogxBCwCnteUDRlqrfnMjfgVAaTNJeuCYY1O4sNE4kpJSMsWQ+aXI34ylvC5/H+PO+O1H1X1j5HJvJA/Z2E4Pi38wODwEHz1ObmVTWN9Db5RZd6hllhEiV6eb25ijDBMNJedQCG3b00wqzi+4x5QBmebEnKgf8aLe3twMhJtmcrDc5/jlBjrjsyhT5bMx2rOspW8LboV9TTLqFLj7jWE8o6hojQi0N4mU207O0rPkuxNTYIWPf9wql5J0/t4ODEaEsU5QmC4kJc4H2asZR41NJkfAZ5TQm45a6/8i+Zpsr6VMAOYhRIDrxGIeSdT9tzbWzCLuVf6SLUZ65ptmF6yrYD0e7euqGbR+2lRMC0LqfmsFQn/k9m/wzKv0nFmpI5Hb/uLbkGL/Ht4KMZV8jITcNTBUTMawUTBdVNsWWT1Qozndz4i9Hq9V9QLvSu3cGw2RnDMqFVjiuCw+SBkkdsRxTylMqAFPv4zDHy+rM86JQe6MtQPJ6epAkk0jEIc36IYgYYx9CzAZc3nicPaJolYfauilT64yimaeAjVR43KJT6rGseDuMtdIzVRGrHFsRjlqfZZh6TNQmKjd/6ya3Bvx2zmfhHXyyj2AABSdvPX/Ftm80x8HquxNc2smsFAhdnkSxqIVa3Or1jNGgL2QWzoPD6A1DYnMBxiXB95VUXwvT97IjohQ49i1AJMj4wVukndb+E
 DtwrS+fe
 imb8I9VRscgpZrQpOoqFeBSpBSnTkax+bC7T3XEMPlSDUSRyL6QrAEexxx5eBZDg5EKO3+cNlebV0q0ORYkp5eHFxOeSdl9ieSC9wszfFkEgkFCgUHGsRgJIEubjOgkU+sGtbefs1y4s4qgsldnWOT0nEvOwiNmvOTYtv3/qIcVM1CNQXD9CoYetMwZiWPECbkEQ8+TPXj8ObMW+qSF9g8hSWlgqV9R84do2RJuCh4YZsKYI2ft0XgK8NFBXAiQQ+I196wBRcq2d3/IWjMPJGea7QtjxMAjw3qwdGCN2tamfodiaEQJRzK5TfoTh+sEB6nCs6pQwPFG1mpfnSiFT3g8kM/eiqhCq8TI2MN0WBkkYdiKOR0FSG92pD5jwvdA5l/pE+kkVZS/RmJZKwlmJhJK2iatQjA7pbg8IgNChadWWdDovoNdGK52HWj9adPIb4owFQ9VXzoiQhYocTu2PJXHcHdNnbyEZ5ArWdXi4HO/u4Dj3vfTs6dCQ1Bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 09:37:47AM -0700, Joshua Hahn wrote:
> In order to avoid expensive hierarchy walks on every memcg charge and
> limit check, memcontrol uses per-cpu stocks (memcg_stock_pcp) to cache
> pre-charged pages and introduce a fast path to try_charge_memcg.
> 
> However, there are a few quirks with the current implementation that
> can be improved upon.
> 
> First, each memcg_stock_pcp can only cache the charges of 7 memcgs
> (NR_MEMCG_STOCK). When an 8th memcg wants to cache its charge on a CPU,
> a victim memcg is chosen among the 7 cached memcgs and is evicted,
> losing all cached charges.
> 
> Second, stock draining is per-CPU rather than per-memcg. That is,
> when a memcg is under pressure and must retrieve all cached charges,
> it iterates through every CPU and drains the stock charges of all
> present memcgs. This means that one under-pressure memcg evicts the
> caches of all co-cpu-resident memcg stock caches.
> 
> Finally, stock is tightly coupled with memcg, so adding new
> page_counters to memcg is an unscalable operation where only one counter
> gets to use the fastpath.
> 
> We can address all of these concerns by pushing stock caches down to the
> page_counter level, and making each counter responsible for its own
> charge.
> 
> Introduce struct page_counter_stock along with its allocation, free, and
> per-CPU drain helpers.
> 
> No functional change intended.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  include/linux/page_counter.h | 16 +++++++
>  mm/page_counter.c            | 90 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 106 insertions(+)
> 
> diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
> index 89a083f16fbf7..c1fe331f34e7e 100644
> --- a/include/linux/page_counter.h
> +++ b/include/linux/page_counter.h
> @@ -5,8 +5,11 @@
>  #include <linux/atomic.h>
>  #include <linux/cache.h>
>  #include <linux/limits.h>
> +#include <linux/workqueue_types.h>
>  #include <asm/page.h>
>  
> +struct page_counter_stock;
> +
>  struct page_counter {
>  	/*
>  	 * Make sure 'usage' does not share cacheline with any other field in
> @@ -41,6 +44,13 @@ struct page_counter {
>  	unsigned long high;
>  	unsigned long max;
>  	struct page_counter *parent;
> +	struct page_counter_stock __percpu *stock;

On gcc 14.2.1, I get

In file included from mm/page_counter.c:8:
./include/linux/page_counter.h:47:44: error: expected ‘:’, ‘,’, ‘;’, ‘}’ or ‘__attribute__’ before ‘*’ token
   47 |         struct page_counter_stock __percpu *stock;
      |                                            ^

I think you need an appropriate header in this file.

