Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96D6DC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7068A6B008A; Fri, 18 Sep 2026 12:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68F916B008C; Fri, 18 Sep 2026 12:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57E3D6B0095; Fri, 18 Sep 2026 12:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3702A6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:46:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C95F4160730
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:46:52 +0000 (UTC)
X-FDA: 85227462264.28.AA9795E
Received: from mta0.migadu.com (out-136.mta0.migadu.com [91.218.175.136])
	by imf03.hostedemail.com (Postfix) with ESMTP id 678C52000F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:46:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DU5Hd2PF;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.136 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789750011;
	b=vz+o5fgzNJYN/TjQtHltSsx/uHCgI5vOLUIoD6X52eZOwEc/3g7FD9jHJFSjKShug6cBwv
	6HFEqJABwcYmznrPB60W8sFt0UkhlUwrdQC0WXxyxyOdQasq5283AbziSbQz9nYIDAq/Iy
	Cwb6V6BEoBso78gZzu44nkfDIw4EFOQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DU5Hd2PF;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.136 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789750011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0q5D1o8tC/54JdIx2k420umm1H93eMZwR9HYNADOWko=;
	b=KbRqSkZ+sq6CQiQ0HvafYaZLPPnVWchxyxeDFbDV8O0Z/SJZJ47lbLEqA2LkgEJHlC/0v3
	yhZ0YRZtQeUTw4OMIp5orXtjqUXAdVcnyIOimkh3ZF+ZliuZdceWCas1ypMKERAg/58PYC
	0UXdwaC+v8Nmi7ObDwkCk7FDAYAR1kw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IcMPsgHLbsL3gesbrTlWcc/a4iLPhjEjxGMLJtdWezE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789750009; v=1; x=1790354809;
 b=DU5Hd2PFEEgYgI4Zxlvb2jgNoeyVj8Eqo0mwELcjvuqpm+Fq+24fpAiK7eCIMcZRDFXa1oKB
 1bwelFiYlOinmryvmNfJ1iv8Y+z92BiV6paJFLmYBkza3xM1MjcOlEYIazjvKBRxOzrXfklbDUB
 ACII3CxPEJp4IAerPrYY0U7Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2886f110b7b1646b;
	Fri, 18 Sep 2026 16:46:48 +0000
X-Mizu-Trace-ID: 2886f110b7b1646b
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 09:46:47 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: bingfangguo@tencent.com
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Bingfang Guo <bfguo@icloud.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] memcg: keep swap charging under RCU protection
Message-ID: <aq1qj7Owhuk2BQsv@linux.dev>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
 <20260918-bingfangguo-memcgid-rework-v1-1-5bbf3220d88f@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-1-5bbf3220d88f@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 678C52000F
X-Stat-Signature: czj49n3hnhzq7wqcry41tih5ctm3q5gq
X-HE-Tag: 1789750010-490967
X-HE-Meta: U2FsdGVkX1/BIF94y2cSbIYMahcsGnfnlRKyFqSJHp2jvxq8oRecgf/hlGjwJDa3ouiW1fT9nsBUuCM+BRFWcPWRI6Z64e5OiK6OpReATBduYZ6ketZr+rXk6A4bamxDvpaD0GDEsE/FTSpi2RSlHJy2arFIHtN0hEH56GMy6bSnqObtlAr/nrBp7yeh5lqZPuYLVYXx3JRhP6GdBXN5XMtped49av2RUJqS2CDoisMuJDCZfJVZXcNLqv7270QEfkWmu1LGibqF2QPu2alrJPMOvZ1+NNr5yYUQuphVFnpeJ8NmNMWoq3mRtE4LkCcAKiX4+neZEHKOlYIcy02LM1tjk6vFq3eJkooPRgq83ekq10CJ71XR75KXzcHJKKLCD0Sre8CniBuuI9nfEURZUkFvBIyX0VcM5Z1Fou9ScsYVXkqtg5kcMxgQlB01Fgur+CN6pPIW4KLPEmWfV8/vZiW+fdpJ4YroRH3GfV3WdehoPSDkVNJQOz/j+GxTUGmSe2zVW/9R9Ka5B8nngJmo/bdeOiAgs8iSKXaMNVJF73XTUZazJqP0v4qYQKIdT0qTlIrN0j6h8m/6vbglrJOJltDH42YCSVE1Eta9KGMpB4GA5J8E6rPbhRyFSS9G+mmV6eY4x0/Nda9LQSF8moYi+mZMBawJ+tWuAb6YeztInrnfkgLh0TW2E9+XvvIQQvfnGQsOH61nJ+CCcXr98K1tJUER1XAF4DpmzYr3SLkz2fVlMj0qq0hoDVEJ5mGl+xvg89e3ihrP65XKBCxhbyFtyE3AVyB+8v9+oGZR2+rzozq3XlOUac7x+phW1bmI/gN1T7U+N+azr8VYhZZscU8I4+ysog42AdCL1T4RzSWA+/Jq4j7y8JnNDyUpxiIPK0xTC51F2BQatqjGODwlIqDUByflHfm+TUZm9sxHAee9y+m90gEtzrNy7IyX0a79JdSFta6yNuvgd8HUZeSWxC1
 d1Iw9KEP
 OTYdLpZUU4hxBtmIdvM0gv+/ysFpZWJFlvJWIqPUoo3P0Xxd3LZW8KFqrAvWb5OCNALvAByc0jK4SUEUp9kudK0fXwmEYSMgh/YgsxkaDwxXkeovDyTyTYkqFpGezkUS+E/0vK2km8SZXEdm2x/tHucLwdToJX9IAnbBtj3+IGzls4nwXKuJ2Rz6VGUde6n9S/47H+HPkVhU3hbBuOBK3Aclqbn5J8s0BYlPIExQyJzYD58z6H4hGfVl/9VVEDMdkIPsUyXFTUM7KqpLx1QeusWdKGT4qlnpXPh03hyFPXYGv3Ek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 05:18:40PM +0800, Bingfang Guo via B4 Relay wrote:
> From: Bingfang Guo <bingfangguo@tencent.com>
> 
> This is a preparatory work for unbinding memcgid from memcg. No
> functional change.
> 
> The swap charging path currently drops its RCU read lock after acquiring
> a private ID reference. This is safe because the ID reference pins the
> memcg's CSS.
> 
> Moving private ID references to objcgs will remove that lifetime
> guarantee. Keep the RCU read lock held while accessing the memcg for
> counter charging, statistics and failure handling. (This matches what
> __memcg1_swapout() already does.).
> 
> Save the private ID before dropping the RCU read lock, and use the saved
> value when recording the swap entry. The swap cluster locking remains
> outside the RCU read-side critical section.
> 
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> ---
>  mm/memcontrol.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 791e536efaebe..72522ec827c9a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5954,6 +5954,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
>  	struct page_counter *counter;
>  	struct mem_cgroup *memcg;
>  	struct obj_cgroup *objcg;
> +	unsigned short private_id;
>  
>  	if (do_memsw_account())
>  		return 0;
> @@ -5973,20 +5974,21 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
>  

If there is one more spin of this patch, I think scoped_guard(rcu) would be more
readable here, so please use that here.

>  	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
>  	/* memcg is pined by memcg ID. */
> -	rcu_read_unlock();
> +	private_id = mem_cgroup_private_id(memcg);
>  
>  	if (!mem_cgroup_is_root(memcg) &&
>  	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
>  		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
>  		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
>  		mem_cgroup_private_id_put(memcg, nr_pages);
> +		rcu_read_unlock();
>  		return -ENOMEM;
>  	}
>  	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
> +	rcu_read_unlock();
>  
>  	ci = swap_cluster_get_and_lock(folio);
> -	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
> -			  mem_cgroup_private_id(memcg));
> +	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, private_id);
>  	swap_cluster_unlock(ci);
>  
>  	return 0;
> 
> -- 
> 2.43.7
> 
> 

