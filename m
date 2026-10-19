Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0526BCCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 09:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D59956B018D; Mon, 19 Oct 2026 05:43:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0A826B018E; Mon, 19 Oct 2026 05:43:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8EA6B018F; Mon, 19 Oct 2026 05:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9803C6B018D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:43:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EEC21A024B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:43:45 +0000 (UTC)
X-FDA: 85338888810.22.618CA27
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 083EA100005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:43:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kzoGYgAt;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792403024;
	b=zO01Q32C5HkjVBnEQYgL3726flpy15up2NUHnLRNKN8r6rRZ2rdUCXnb7ke4vQtMFzK9+n
	eI/HE+cwyECGz+zIqpHkLQz0NqfTiKm4lfmUaKq1LhsXo5j5zDZCZgXFIwxzeZwipGM5Vk
	cdXQdm/QFTbC9T39fN4FzkGes5DtMH8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kzoGYgAt;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792403024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aP4YlH9yNTX5OhzyVhEqM3gZrkGRzoNW+7w0dUsXbaY=;
	b=41i67LTfbifUeDrHM7zfoaHbWNfGwKjsiH0fmFy99kSCI+QxiM1hbNo38DgLF4W4F1J9he
	vUxE0cpN+n3isn3Z1oGQUM+WTyEXdnqW5oNI5M704yj8wOu7yxRzxfCgaZRHaGQ8+jez1t
	Cuw5xELuEHJh5x+gQTwJQdXjhFZY6Z8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B27381477;
	Mon, 19 Oct 2026 02:43:39 -0700 (PDT)
Received: from [10.164.19.55] (unknown [10.164.19.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2A0C03F7D8;
	Mon, 19 Oct 2026 02:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792403022; bh=wjXWIDX6E9efo9SoSpjdI20BZtWXx7eS+3XUoeg9ZNQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kzoGYgAtae0nazZp7bpP9KyWhmuMn3GVItwvwoGbReeCO+g83J2C/FwjVqg3gdYK5
	 oeHmWsJ7W14jhVHG3L1eZ4ixsojf/Z07R9Z5ntxW8WLBmXhk6N+dGG96jlP7OXeyaG
	 zkAU0KehFADdXdCZubV6ojQ/bgMqg9GYgpeTcezk=
Message-ID: <f4b8c610-abc4-4c0c-8d15-5d2de679a409@arm.com>
Date: Mon, 19 Oct 2026 15:13:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 4/4] mm: compaction: skip unmovable blocks for
 non-costly proactive mTHP compaction
To: Bo Zhang <zhangbo0325@gmail.com>, akpm@linux-foundation.org,
 vbabka@kernel.org, david@kernel.org
Cc: surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com, ljs@kernel.org, liam@infradead.org,
 rppt@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 kasong@tencent.com, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, zhaonanzhe@xiaomi.com,
 lipengfei28@xiaomi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Bo Zhang <zhangbo56@xiaomi.com>
References: <20261001001412.3837085-1-zhangbo56@xiaomi.com>
 <20261001001412.3837085-5-zhangbo56@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261001001412.3837085-5-zhangbo56@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 083EA100005
X-Stat-Signature: shfbzsq767xy1j469ak8a6t5sxgzbudc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1792403023-331661
X-HE-Meta: U2FsdGVkX18KPUaFpTKCx8C7aS2m9fUMeFHjFdOUtBEuKnv/gnDALyoM/0TEohPsSvIwOg9rt5C9AI7lqKf1sGcUMjvBbR+LiQqc9CgwVRfXTmVF9tXGbubhmCN9LfMldzRvX3eG8rudRClRjv+9PykVgi3FuICoa/ckEi2cQC3BHx1nceLMWM3uOg9B/bc0N2JcsfeRyICyNaEyPhk9Tf446LeyGXVkXthv46qzygIwPX3D8IkusxRMF9XNPaqVrBEWRpyThXqB3cOPU07wZUuNihJUZX/iTPlmAGnMqE8FF1TnXhPgwaN6desD3Qs2r14OhtQZAoyHByufomU+YO+7IVn3T53Qw+ke1IQnhNkmRas12RESMsbgdFJZ4DvJNyHbJu27qR7O1yZ+UyJdyT8Nfl3SdhOdwohLqMSrwY1yb/JcKeIq8EVOv2MtTtI7qAcUQNv3vW6jnBEesXWVzWz3RjxC5Rt59CdQYFkyGAaga9YRs7qEHLg5nGQx1OxqIeR2Zz687KMWx++ozKtdP8wGIR5wwvj2JqSAyl6ckCSrbQBztjfiHFK5H/k4TjrRupvtuy+R8T0xLHprQ9shxJTF2rwOe0x5ldCpDCbEKcUMMWXb8ndPnSuom5YptqjRJZD+NCazAU7fZCMbgDIC+fiFqH5YNuJASzEtxHjJmrKWRFmjdsyIaazTIJ5gwdFwsb8vNVUYztnKOkwH7I5FRujnnjDgye+eLmlqn6GGgc5+cWreJKDLH82BRJm9NQZJbH/nM4PyfEfrk0S9BEFdV8fMZWU1Z93wk++XwG0heGN/IFAGJxi/sUlckcF+52D1NlPakC4akQRf6hxveTdVlgL/KAqOsntGNHCWy3ipKok3bRhy7t18SQc9e9PBORKnOaaFbMpDdsZERG6F8iP3JRwXN125L/ID0PCm6ELpis/cA/2uq1H6GNPh12180TW/vYWm/EStM9ElUgDcoKN
 h0sAjQli
 Ixo0U3kTABpyU/jGeeIwI1GWeq85LwXR2YB13S3soCMxGYp5sMbqzdyAuOsow5C4vNC5/2K/p2OjdnbLF+CdmbFrIygPWQaIIXnZGoCOFJqonARdNuM1XI6560gDvMnvWuBGU4raLKMT2ZhLygMPnvI85puj/dUYFKGunmxc5izgQ3S5YDjhzgFmMyk+zhr125ky3yHkrHlBCQywsGChNHnnw8T3RO5FYizUMz5sT1kLOfHPR1OgsVW1tk4iCazc0mnHA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/10/26 5:44 am, Bo Zhang wrote:
> Proactive compaction scans all pageblocks including unmovable/reclaimable
> ones. For non-costly mTHP orders (<= PAGE_ALLOC_COSTLY_ORDER), those blocks
> are dominated by non-migratable kernel allocations (slab, page tables) and
> scanning them wastes cycles: a small order is easily satisfied from movable
> blocks alone, so there is no need to scavenge the few migratable fallback
> pages inside unmovable blocks.
> 
> Costly orders keep scanning all blocks: they are hard to form and benefit
> from any migratable page available, including allocator fallbacks inside
> unmovable blocks.

I think this is a reasonable compromise for now.

> 
> Restrict non-costly proactive compaction to movable/CMA blocks.
> 
> Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
> ---
>  mm/compaction.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index 0ff454ee5604..deddf931d0f2 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1404,10 +1404,19 @@ static bool suitable_migration_source(struct compact_control *cc,
>  							struct page *page)
>  {
>  	int block_mt;
> +	unsigned int order = compact_hpage_order();
> +	bool costly = order > PAGE_ALLOC_COSTLY_ORDER;
>  
>  	if (pageblock_skip_persistent(page))
>  		return false;
>  
> +	if (is_via_compact_memory(cc->order) && !costly) {
> +		block_mt = get_pageblock_migratetype(page);
> +		if (block_mt == MIGRATE_MOVABLE || is_migrate_cma(block_mt))
> +			return true;
> +		return false;
> +	}
> +
>  	/*
>  	 * Background compaction produces blocks for the zone at
>  	 * large, with no particular allocation context. Allow al

