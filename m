Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B250C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 20:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14B396B007B; Thu, 30 Jul 2026 16:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FCA36B008A; Thu, 30 Jul 2026 16:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F06736B008C; Thu, 30 Jul 2026 16:59:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA6386B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:59:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B5FD4028C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:59:25 +0000 (UTC)
X-FDA: 85046658690.16.6B89DBA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id AED9014000C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:59:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b4VDYtZs;
	spf=pass (imf26.hostedemail.com: domain of "SRS0=sCS2=FY=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=sCS2=FY=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785445163;
	b=yACsRaX8CZGLQ7IvtrlPIGY1CkHpsbZJMKX4yzEGLBTp+UiJ3pe6d/eDGY94b9Jux7N8U/
	YQFPDmer2v8EDoNx1LyE6pJ14P+/1hxP1fQ2twjLSSRjb/MHdpc32xaSXpibgI1zB94CU1
	O+X2E47zm5zfgCfsPVohUgkL8KVegK0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b4VDYtZs;
	spf=pass (imf26.hostedemail.com: domain of "SRS0=sCS2=FY=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.105.4.254 as permitted sender) smtp.mailfrom="SRS0=sCS2=FY=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785445163;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TdKteJ2Ppi5Qmu1+gV5giVne/pmuTopgGWMGEUu1j1E=;
	b=CDbSIrcBO6hiM89YtNrEWH36MJ3jHtmPbuvdI+vv7GeyYDmH6hwqVKDvmd7rG5TIuE+K+f
	igwOTCI2ZGCWNstOeaJTAtiH7+T4tgr7oUljYvHUjRVLwoNVQW9IUliR6mn6cg3NyxH70W
	hel9XhIa9wOi7/H9gSu1mAqlMPwsmAw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 446DE6001D;
	Thu, 30 Jul 2026 20:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0D61F000E9;
	Thu, 30 Jul 2026 20:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785445163;
	bh=TdKteJ2Ppi5Qmu1+gV5giVne/pmuTopgGWMGEUu1j1E=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=b4VDYtZs2WOhpYQMRq2262d6mVq2UU9G8CF/txykgF8rdH8yJTgx1YwDdpOkrEday
	 glvAEialobwOZKV/W+Lc/MpBeUy/EGRUS7A7m7Ima9Mv2qQkNO3TECwfbKry0tH0BR
	 Z7ONFGjUj/Qe+9QCT4VlMOG2DBGYl2xeEBVpygf8e99q6bgm0B/2llfy01A9uSNeff
	 6AGdSjk/iieBUKz5PYINHFGz+5qPDKy55GQ7N0iGtXJFMo5P8nkH5HYMVk7fTlCMvs
	 mUt6rkh7jL8DzFdCLnQF2Yofr836IcAdVNVW+1zEjPx5IFR4B64gk4+KlW+RBXD7Uh
	 Cg8eRYY8WGFKw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id A053FCE0B67; Thu, 30 Jul 2026 13:59:22 -0700 (PDT)
Date: Thu, 30 Jul 2026 13:59:22 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Uladzislau Rezki <urezki@gmail.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	rcu@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: stop exporting kvfree_rcu_barrier[_on_cache]()
Message-ID: <d2cd0e92-930f-44e4-96e5-67b751419a1c@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260730-unexport-barriers-v1-1-852f6641abe9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-unexport-barriers-v1-1-852f6641abe9@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AED9014000C
X-Stat-Signature: 1hrxtra73kn71brc9unnux47paw6ggww
X-Rspam-User: 
X-HE-Tag: 1785445163-840713
X-HE-Meta: U2FsdGVkX1/RvB1MDWtmkZykhWIYsZRX5qGVGEnKQOiR943Xf3aqdcTNB5IJ0oRRuFi++VyrDFxh2pcOxSqR4ONCIjplrkmlFwT/CU4nz9WB2sHX7aoiBVctkh6I8Q5ate7WJdYoFiU5SJ2RLQQgpd0BfYb4jQFI9HBwGCdELkdLppmunWyWxz6ccbB4sEsJ1YfXINk0hShAc0T8Z1NOckeNn4hETUVga+0Dp7u2DR9t4EM7KV6Ay1WrWzRN+aswAG2FRkeOkELAW5Lo5jIqCMJKS/X822I3AdresfFEjeE4pTPg8nkR4NLqJsgSY4xEYVNOt5my4oiovGoBrKFxhk/DiR7V+VH+QlH3f38kxTWjkvYbETxPne69xqpd4AWw7YciMcMUd9jPNKPuj0Wv8EZlkuiaSF0oiec0xixrOiHnwd438iZrSHdySFb/NjNQCExEfdNF4pLaRYDkT0I5wmIc0u7qWoXoRoHRKJg2irj2ewoZsxTfgNo3nvh+nYQcJn8rL0Qupuj/QD4rftEHMDoHfLvTlFp48DVTgxq+1d0UVSZCTKk38SIJirEfnvd5L96hfli2g9846jdZBcEe+LGMdYBgL70p+GtCoehgSscNqSnEpt48CbzdcYC5W3ty167bynMtXdsTe1dTj7KfjnHmp0ZchC96N0St0v/odJ4XIsqmu2k0hekV0wW5wv1jQFhwgg1UPb9ECXehakzlf7fCoslOmJmwo4Vz1ZW/ePHvTk7DrKZpGarFOCvW+H4TE3s9r+PXoLNzt/n2UTctuZgZHrttbVMqQ/vjfDB+svcuR82Ei/lJVGtdom1ZWGx8bRQnS7dye2K5ebG/W71S9E0G+ecKyjPri0ZISJ7RzBPhsFJRw+y7tvE0bgpN3K/ExA1/VtG7wTw+v9OO0X2o28j2hSmt3JB21Ht2UnNBRvz9Ldk23EK+C+1Nu/9cZdIwHiibusOGPtrXHF1q3zt
 XmcAj0B9
 8BhpRq5iTvsy3//f+sfWjHgnLm3s3Yh0G+50pNdEdNBJ2lmi6ZCDEXSuPYONJrPVaNBjOSLW9TLUg4WoVSJr3mWyPdbjIfyVLasbUXanw5xAH9AIla1Tjd30OK13Ryd3ri3oq+eWPTpgRq5FcKsHlMDi5wMGJ6nwakVRdZn4LLHIboYpNRmhIf1Yuk2PFFx/DZCn2Txg5E/x4Ar5cOYrPB17AvI4MUjCyNK8y+AAF94/9D+LXEtTuPeLfA9SCV+HXPwsu/tcMgCJ0y0khQNCwBnCpFpxo8TCCYHbKr2J5YbT9I1e9Kj0wew/NTq2sJR/zCERDyBbKZ6IfuHnBE442dmVKnlU1iWmRZD92pTkZFCdPtEvK8DWHQLPUaey6e089v/8GM60QVW+q5wZZ+843L7XQr3x+IjKHfhrgKe7A88MhchUzA2p/cHU/yeHhHJcVViuDmweJNexAU1WkAh/O1TW5VTlf79R0comX5eIIsjv7jRXS2+gTQ6ILyEO6WE4wHwULy4UNikhs4OBcQvi6tFVbi4DgKnduCZu/pao1o2/NC9pgDD968Wk4ZyGBxh8tGtIOT3NRcR7DWD3Vart4kx64C7r13gANZz68s+UMsLD+mxyDPOnhQfHQBODK1oYhM3fhn0geeR8iJQuxm4gNbfeXuZ7iv2bkOCQjMRdP6oI+K80bFIwu4xrA2Qb9+LgAFGwk7+EAMZqeNqJvuRV2H6QkEVM+YyszbgIw0xLC/mEbaS2FRKwEDMHo6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 04:32:46PM +0200, Vlastimil Babka (SUSE) wrote:
> No module code calls these functions directly. Seems it was always the
> case. Remove the exports.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: Paul E. McKenney <paulmck@kernel.org>

Which reminds me...  Are you guys interested in taking the kfree_rcu()
test code from kernel/rcu/rcuscale.c?  See for example the kfree_rcu_test
module parameter.

							Thanx, Paul

> ---
> Based on slab/for-7.3/kfree_rcu_nolock
> ---
>  mm/slab_common.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 6750dfa27367..cd155ffc2762 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1329,14 +1329,12 @@ void kvfree_rcu_barrier(void)
>  	deferred_work_barrier();
>  	rcu_barrier();
>  }
> -EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
>  
>  void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
>  {
>  	deferred_work_barrier();
>  	rcu_barrier();
>  }
> -EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
>  
>  void __init kvfree_rcu_init(void)
>  {
> @@ -2163,7 +2161,6 @@ void kvfree_rcu_barrier(void)
>  	flush_all_rcu_sheaves();
>  	__kvfree_rcu_barrier();
>  }
> -EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
>  
>  /**
>   * kvfree_rcu_barrier_on_cache - Wait for in-flight kvfree_rcu() calls on a
> @@ -2186,7 +2183,6 @@ void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
>  	rcu_barrier();
>  	__kvfree_rcu_barrier();
>  }
> -EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
>  
>  static unsigned long
>  kfree_rcu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
> 
> ---
> base-commit: b01f6ed9ff0c4581fc669044fa5b82a93b4ef144
> change-id: 20260730-unexport-barriers-439b3f69f791
> 
> 

