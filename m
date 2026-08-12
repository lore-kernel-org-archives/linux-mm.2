Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BE36C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 190996B0122; Wed, 12 Aug 2026 06:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169A16B0123; Wed, 12 Aug 2026 06:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 081736B0124; Wed, 12 Aug 2026 06:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7EE76B0122
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:45:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6227B16028F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:45:44 +0000 (UTC)
X-FDA: 85092286608.06.5A78FEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id C3FED40002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:45:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GlgD36p3;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786531542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jZ6wkNedTUfJCXrV76nCCr0yC0b1EaP+oUbDdDQRYo=;
	b=XxgoX5HER2+l/rzjww4DJngYrN+VDbRwscGniLQp5RWcb0+m5AolDd4OubYlunYzeLjF2l
	6RdYyEW5JsxeAQ5xPLfEAex7n37sWS4YGhQuKdIZ0ny7507IdCyrqETiSk9SztfnZb/Mfp
	qSADrE9dvX02/VMTSCkyj/OyL9muDeo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GlgD36p3;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786531542;
	b=naxJOO144FjNJ2xNehQqCger6BFyaWPPFXflsGhZSTpgDBRYoOu4uZqTxyrhUqsK5V5x5c
	PZ4+zsksbJT3fARmlzsyh07PQ25j82OAFsT+Gx5HH/KIDKWHojow9FBSM3uWR4NEW6ed+1
	5SosWkbVL74yO5d0AKV/Idm+iLTQE24=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21F4243716;
	Wed, 12 Aug 2026 10:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3281F000E9;
	Wed, 12 Aug 2026 10:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786531541;
	bh=3jZ6wkNedTUfJCXrV76nCCr0yC0b1EaP+oUbDdDQRYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GlgD36p3Ivo9rrgWpuswy69jInboKQ6Tv/dl2rmNw19xEJwbo+U4ok9R0u8rkgW7w
	 rtWIG5tkFLIAZu3BOyKCKTZa08xbrhH73H3hu+58haHrluohur4JnvJlfRnBWV7/40
	 jI1uHb5m/gSPdKD4G/FlCbyr8DyXbT+8gG0ZLKSg38zeHqADAiSAt1bZX0xbuJoUUi
	 9Et4qRIbfh++CgxTv0+GeXANdeUau9lmIsBKECxkY54rn9Xddwqk1FLOvVjOdxeo10
	 xuVpsAV/Cs3T9pToBKfAM2lLW5j7FjLhjZFBicyE6FED6eu/SjSXpHGVftvOA5QW7Z
	 evyedK+1tcHbw==
Date: Wed, 12 Aug 2026 13:45:30 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, linmiaohe@huawei.com,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, nao.horiguchi@gmail.com, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, gourry@gourry.net, tony.luck@intel.com,
	bp@alien8.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	liaohua4@huawei.com, lilinjie8@huawei.com
Subject: Re: [PATCH] mm/Kconfig: allow user to select MIGRATION if
 MEMORY_FAILURE is enabled
Message-ID: <anxOypktGGq_9PZw@kernel.org>
References: <20260812091644.224299-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812091644.224299-1-xieyuanbin1@huawei.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C3FED40002
X-Stat-Signature: budiag65azkjmjn9bm18mown1ez61qmn
X-Rspam-User: 
X-HE-Tag: 1786531542-978545
X-HE-Meta: U2FsdGVkX18smNql3WIkv4b654SH98wgk0tAfgT4DmTnnkFlLc63SdNTGlVXvJTfAbgRAPnq33Yrmtj91mLB1VdGWsOjXoqYJ4gLm+WeWv9ChwJZl3rbPBhPIirCaVf6aUsy5Rh+funFk9EzqhERoDzOi49GYFyf954vCpmILRT4CuY06IjavJnQtDArI+5dmk92bIVvPHllU/0nvmdSg/73So/wvX45rJkMofMZVg9w2BElzwnltUO85IHETt6kLzZUp+JQ/5qUJ5IBxkRmwbQ+KX79bgQj8yU/dXJ+I162tf8GI/ZHalfkMRkWsM7V66Oq5UQGOzLYHHhc6sruRysUIdXMihdzcmHFlTjcWHE6xEmKJb1fQX5dhfEtdQ0OTEulrU5Fr7EZne/njQUKVa0sBYFEn6R2wqaN3jK/ckAT8nIOMvU5SRISKzv5T0RA0jaDN1iURYast7wkjhIkpzSPgav/oc4z/Yt4pMtsz2pjYIrXLEiIc3z8Le5zPQdhEFjm1TPxURaaiy5HpF+M0o6iQMhCCLauUyeHfTLApb4sXKg+1CvOBDzLaZYVCZ1w7tRStUVvchJCcaYqOqJyITIwmgjQTzS0Hw3T+328yULIA1PJ2CeXGuCmlVxHcslahflWhIoGPMGANle/hwPXsrURQ6CVr5ylWQ8wWPUfv47tyTjVA113y9CKAKByymjmzGjVR6QD6QX3vxC7fqIcfB0VZgRcMXWtw5Rie52BaF7M4iTOgcddp9ZfnwIWTIudhKHK4Z4t7cOTteJSQnqIjK7dmjQSsrye0Rw1xhY8rXrukBO/XhZmGTKT0Xgl5yXvjCs47mJYHOBb5IHMfA6XzryfLzF7zRaAQLdxXoTxoqlQxFx7jnrhi52XEKuWhY52qbxcVS7i68f1o5GSHBj8EdwqNL0nE2QeSUKMb1D81qrrI4MtqVB6vVP5hQPamZD7mgmAyCr/U1rGaXvzga7
 eJZGUn0f
 7i/tWYgLGJmwMZjff4muKcT2ETMHgiKvsP3rITx8N9NUCnyLhII8nO/SFYceM4K6eHl99EeqJ/HPTqAYopvL/a1vdIwdlF1RYnX2HZ2ycvNX41YxvM9dAj96RkvQMWHEhZOWejbPLwAQTqHuF0qWi71dgQ6iGtlJ4c0MmcfCHi+AeWEkJP9ohMv189AWYH6sjvcRgykmduuQ3MifKGE5oRyGQI90c3HoVEb06ddSlKn90rlhWlOuWRjQquvGhcu46ruiUee6lHzdK0a6p3Tpo1Sjj6Z6+qu5iw3ZFvB+QAf0NZzMDZepjJW1AOX7H7RR+yrbh11/m7iZOZBGUJH5/3t3NI9vKsq7v3QC8NRLi+3DH0tey4sVApgunrbtXCXFOUXd8IcBqpoA6iI6SO2O/RoEgfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Wed, Aug 12, 2026 at 05:16:44PM +0800, Xie Yuanbin wrote:
> Currently, memory-failure can be enabled without migration. However,
> migration cannot be selected by user when memory-failure is enabled.
> 
> Migration is very useful for soft_offline_page(), which may be triggered
> by correctable memory errors. Most of the anonymous or file-mapping
> faulty pages can be migrated to other healthy pages.
> 
> Allow user to select MIGRATION if MEMORY_FAILURE is enabled.
> Also, select MIGRATION by default if MEMORY_FAILURE is enabled.

Do we want to make users decide if they need MIGRATION when MEMORY_FAILURE
is enabled?

Just make MEMORY_FAILURE select MIGRATION.
 
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
> ---
>  mm/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 8a24c130d008..b4c217383b51 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -682,7 +682,8 @@ config NUMA_MIGRATION
>  	  demotion for memory tiering.
>  
>  config MIGRATION
> -	bool
> +	bool "Enable page migration" if MEMORY_FAILURE	
> +	default y if MEMORY_FAILURE
>  	depends on MMU
>  
>  config DEVICE_MIGRATION
> -- 
> 2.55.0
> 

-- 
Sincerely yours,
Mike.

