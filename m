Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2399606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Lps8hBf3
Received: by kanga.kvack.org (Postfix)
	id 9644D6B05B1; Wed, 18 Nov 2026 11:06:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93A976B05B8; Wed, 18 Nov 2026 11:06:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 877166B05B9; Wed, 18 Nov 2026 11:06:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F1776B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:06:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8F7BB1C3C60
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:06:37 +0000 (UTC)
X-FDA: 85448717634.19.9676A8F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id D03B11C0009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:06:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Lps8hBf3;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795017996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xTCU+RoK1YPlyX0Acm2jpVyoheKI6U5GNoIs3mZD/FU=;
	b=jFZjtl9DBIDQd9bIX/7TGZ7qL51IzwD9ZxzxNXkCUu8QI7LIttLlmJBV4C8rX8ZZ8QUOQo
	H5Y1Me2z25gWPOLCVvWfUSCr4XRC0zsRMNrfQ3yFcMHAKkxLyciORWgpMC+RMeBFVTXCMw
	OJvNnfq42MldKPVH7qStJNyPixaYteg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Lps8hBf3;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795017996;
	b=S+prINYBg6u7aYLUncElUcFWMH2qqtbNyHVTd/WPGCeeGplIykTSKMnyem6jHvHli7KW2R
	cvt58AeS8C4w6Gk7wqmnRrAfRuQm9r1CJvf+BVrQ+8MdAvrZTWyxMzNR4V1IiRhonSYJTx
	NjaDbry4WjAm41fQF8hdFhkaVuCnytk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E428C339;
	Wed, 18 Nov 2026 08:06:31 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C9C3B3F673;
	Wed, 18 Nov 2026 08:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795017994; bh=MP+B+gRf4KcD50ABMTgIEP0ELDxT6FWXcXxgwQFXDHI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Lps8hBf3xR3dtzY/3UFzglc9UPB0HaBODeW9ds8xMelngDfVKsey6Ae2d9lnvbuz0
	 y5auJ8Q3w1PoXP5W3ueeIaFLOLB/+31P5TAdKEclcuV+s9axHrxBY5Iwi93zgbAiLQ
	 Gw4dAyU0monCTipOJYTL3fw6qimV6iSa+CL6Kql8=
Date: Wed, 18 Nov 2026 16:06:29 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+527fed49e5b988882c9a@syzkaller.appspotmail.com,
	Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH] mm/slub: don't let kmemleak report rcu sheaves
Message-ID: <av3NBYxYXyYk_tjS@arm.com>
References: <20261113151837.123795-1-ngocthang2710.1999@gmail.com>
 <0e626675-c6f9-40d7-a4ae-de069154ada2@kernel.org>
 <avzduIJralOKBgxK@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avzduIJralOKBgxK@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D03B11C0009
X-Stat-Signature: tbmziject51zfttyucuw8cwnswb558b4
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795017995-526317
X-HE-Meta: U2FsdGVkX19p3bk6GWcGnUX7UIEa9+2jxeyUgTxSZjhYghR77bkuVyfnomtk4Z/dZjyJpdlCI+5GnIQm4zx+buembzl0Apv1B5zq/iJyXutc4neZM3TR/AZd6L1M30Zl2+tKUEdf9AC3wwT65XdQJE02xPbQiJHolepbZqYkGAVyGQe72PovXAOV/utQFsQN6nUJ2yZzr8xSHnSVtWsTx9+uvDw/OanLcAv46VR4hD+AZo7zRl7LlvqvcqUWmU6Q9VDTn5aM2nRhHZ6LJi0tgY0FQbx3GgDhGpA9yNiA6UM+lKSdoQSNeC3T2TJD2RN5wT4a3XeiDz5pYQcj/6gY8VNVmhFKJT5HJW9hzStcTn88ffRVga9FADkCtB7IHc5ZbmKHK3vhxxD3qSx3gYGNvHeXVa4G7fXg4VHvR9411U2vK9Ejek/ENa1BG/6zCCtE+kDR4DKTrfpJnBxiGcHmAPgUnSDkscORXmZcXY2bYn2xA208XSF4nn37Q/ThT2Eqky4TbdISCAslY0X5UC2WNEk+FY/FYcQPpdoxwqBpqmadjKHn6aqwrBfAQHqpmnUlQbMb0AaAD6QinEawUI6eEIeJRsWSeHAWdrkYqGuyj/xNxH5V274qteZO/EmI5uk+lPD4W3FqeAArUC2aRRyMEC6K5SIgUi4ZJLiMLkr3vSqz2TaMSUVHvk1nSOQUR0l1gfVcrj9c1bQgp8WVDR6BNDfY4MMu4aMpg3lzOhMF22HuQQ7cmBFw9Y/bVgK9NxsIglCpZ3sziSB4BEMLDbTxQk6rT2wsvrnicLa5HkE6d5SXfax/2QkezlAqnDOHJfloKjtr6pbhuvjmOvxZkSd8KbiNb+nkpYE0SC/z9sUZXyN+Zcezkc350dx8oADFGfpoJRKu5g6mBK+B0LSyKpD89YLIE+heQXkNhsEaSkvhsXZo9MNYVornsC+h99qKo8+y/7qVvpUcees7cP4BO/B
 T4RAfsz5
 gHr2WoI18eo/yrOoh8dbWV8gIS7WTyspGlrIfB7yn012q37Ljb8XzPRZZCLHsI58+jPo2hNwm4bFzOp5IP5mDMlTwQhH4iDsQrMe1Y6NMRawdUitFgQadlg/J1q/MaT8rrrxh4+Ac3F44n+xxQpTBc7RqmS1zMLuv1d8WdSnfJdqa1XezJI1clVV9cZoW2/0Moe9VMWp1mJRmyLnXvsmCP5JwuX1hJ3LeyE9w6/CQyzki0bFYDRRastHgvhQbi60t/oQXToWjl6O9rJprH1mPoyVioZIEhjlF6LwVzwdqiDZBZStr1mSVhTn2WFjdzP1lWzoTkaVN3IraBjVmfz3M4Kg9WaPJ2Ukrc26khcpriRObrAA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:05:28PM +0000, Catalin Marinas wrote:
> After some back and forth with claude, I think there are a couple of
> places where kmemleak fails to track. Since commit 9aec2fb0fd5e ("slab:
> allocate frozen pages"), kmemleak no longer scans the slab structures in
> scan_zone_pages(). We could do something like below:
> 
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 20c0eb41c873..47446af5fc9f 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -1875,9 +1875,13 @@ static int scan_zone_pages(struct zone *zone)
>  		if (!(pfn & 63))
>  			cond_resched_tasks_rcu_qs();
>  
> -		/* only scan in-use pages belonging to this zone */
> +		/*
> +		 * Only scan in-use pages belonging to this zone. Slab pages
> +		 * are frozen (zero refcount) but struct slab holds pointers
> +		 * such as the rcu_head of a slab pending rcu_free_slab().
> +		 */
>  		if (page && (page_zone(page) != zone ||
> -			     page_count(page) == 0))
> +			     (page_count(page) == 0 && !PageSlab(page))))
>  			page = NULL;
>  
>  		if (page && first && page == last + 1 &&
> 
> 
> I don't think this is specific to sheaves, SLAB_TYPESAFE_BY_RCU may have
> a similar problem, though I don't remember to have seen such reports
> yet. It should be covered by the above.

This still leaves a hole. Scanning the slab descriptor recovers the link
through slab->rcu_head.next, but the preceding callback can also be
free_object_rcu() whose rcu_head is embedded in a kmemleak metadata
object allocated from a SLAB_NOLEAKTRACE cache. This would break the
chain.

So I think we should keep the original kmemleak_not_leak() patch at
allocation.

> However, this only fixes the links through struct slab. The rcu list can
> also go through a sheaf allocated with kmalloc_nolock(), which kmemleak
> doesn't track. Any callback queued after it is missed (together with the
> objects queued in that sheaf that may come from ordinary kfree_rcu()).
> When kmemleak is enabled, could we simply avoid allocating sheaves with
> kmalloc_nolock(), i.e.:
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 45e077c7526c..13b8e57d6dae 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6278,6 +6278,14 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
> 
>  		local_unlock(&s->cpu_sheaves->lock);
> 
> +		/*
> +		 * A sheaf allocated with kmalloc_nolock() is not tracked by
> +		 * kmemleak, so neither its objects nor the rcu callback queued
> +		 * after it would be scanned. Fall back to defer_kfree_rcu().
> +		 */
> +		if (IS_ENABLED(CONFIG_DEBUG_KMEMLEAK) && !allow_spin)
> +			goto fail;
> +
>  		/* Don't wake up kswapd, it will cause deadlock under pi_lock */
>  		empty = alloc_empty_sheaf(s, __GFP_NOWARN, alloc_flags);
>  

For the objects queued in a sheaf, rather than the !allow_spin fallback
above, it's simpler to move the kmemleak_ignore() call in
kvfree_call_rcu() before kfree_rcu_sheaf(), so they are treated the same
as on the non-sheaf path. kfree_rcu_nolock() currently only has a kunit
user, freeing kmalloc_nolock() objects that kmemleak doesn't track
anyway.

So this second hunk isn't needed either.

To Vlastimil's earlier point, kmemleak could follow these rcu chains
instead of relying on kmemleak_not_leak(). However, with chain breaks at
any _nolock or SLAB_NOLEAKTRACE object (including kmemleak's own
metadata) and walking the rcu callback lists directly means digging
into rcu internals. The annotation is easier to maintain.

(got lost in all the slub code, it was much simpler 17 years ago when we
merged kmemleak ;))

-- 
Catalin

