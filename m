Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8623F01835
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 13:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C9FA6B0089; Fri,  6 Mar 2026 08:51:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377A76B008A; Fri,  6 Mar 2026 08:51:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 259406B008C; Fri,  6 Mar 2026 08:51:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15C8D6B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:51:29 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A81A8C1D41
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:51:28 +0000 (UTC)
X-FDA: 84515775456.18.7F64ED1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id CFFE240013
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:51:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=olDGrSHo;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772805087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DAH6Upu8Ck9Fign/0PlxaF57ypAD/KU3urirCydaJMs=;
	b=NgIwc/7OH8dlPvI1rMT2e6+NwsTg5vft1MJQ+V0PNtDLZ6vrHssFfc4p5aNFSebun3uP6s
	MHIikGOtuX25uRS8zWjdsyJGfuwP4y3oKV60J1qx9F5649OIPjCpZBbxIHUgH5mL3PHZgH
	63gf8NeHTA1nklTFAYsCAvmKnxmiHGI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=olDGrSHo;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772805087; a=rsa-sha256;
	cv=none;
	b=rw2Jov7JOSIL0bcRWWuJOXXZVerOagwwxv5p0abshm3leNbeAH/+8iTgVDZtQjT4+Dsr/e
	UQIDRxvm/4rtS+jYdx7oHAKuNkqrU1nckudPHNY6SlX/2aw4tYf1sbKFyV+ZpHPAqXNoSD
	cDEGvwVJSYoY0XPqnNo7uJEP0NedE+0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DCBC540234;
	Fri,  6 Mar 2026 13:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D36EC4CEF7;
	Fri,  6 Mar 2026 13:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772805085;
	bh=7RBqYcR2ikcPrdrJ3ktRl7uN+Go6X/fHUgtHA/HqlUo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=olDGrSHoZxTa/sqjxUa1qieNAdDrlVRkMgYXIuY7X/1O+Cik9Lje5jim/kM6bxyq8
	 eXYV43EoaAI+x1hBvbNFSa1YIGEpd5/MhQw5v/BC63BQTgWyhfJH40L/HIpqdMYbI4
	 dXWHw/OjaXloYQ9ARACOfN8hO+FTWX4StOcfNl7kduWUm4+kA2hPNXKW95sxUvJdIv
	 jiwqEy/yNNgRJLQG5XRW8nRj/AFzf0h0w+jhMLaJ/skjuzjUDhtjz629jh/s+m6wuq
	 mPlBtha9jfTpjS5/ezErsC176oDum/COOGaHtk1kg1PhfYLmbsIDD9pfZPqIEcwt5M
	 iGhFzUeVMmmDA==
Message-ID: <3ed67a98-42a6-40fa-a7d8-a1a264f6151d@kernel.org>
Date: Fri, 6 Mar 2026 14:51:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: migrate: requeue destination folio on deferred split
 queue
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 ziy@nvidia.com, linux-mm@kvack.org
Cc: matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260306133556.2051251-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260306133556.2051251-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: iab5s5uqsf38mqqrmt8iqmozmnk7xf45
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: CFFE240013
X-HE-Tag: 1772805086-201352
X-HE-Meta: U2FsdGVkX1+RHVlY/D5vvTyfdAGtwfsp4zPk/Vtjw03Ckgim9eaH8SJpVdNLjnmQub8ndEYOeF+7CqB2jfAj+nbZwSUjKLYr0630FQ4A2Tm+pxPb4xCdEI0McgJeKusvyZWsTDs8/Ad29RuyP4SSCxR3FL9WBw0jMxDoRMLOofie3AMoX63p6P8JcMkbiyix7TySPftWlWkNMPyeyLR60F7WzwKcywduqw8UPJcaHFpPK3Ohe0/rDqLnJ3MNWjYA6H8UXk7zZq8n6EUCkclm01sWaXso4THl1dB7EqohJg195sBIUDcslqoy1lbCT3Yh3YhV/UHmLuS/vGDMFyfI6g3S45kcQlZthg0RrLfH410bUW4I8FMN4+2B1bYpn+ApuIVxNpDYexTKzbjltWe5PA7PuEg34m1MfW9YgZdM/PDdnt6O2vUAXLBj/9lJQDK3xwM1HX6c7OvXHFa+Lp/U9FsjYKJXnRPELSyhZy5C18RScYrAdtUKuQqbHIrLnth5hjsYZJOfrKBolpQg2UCUjIjMRs9KDH0+rMz6xm6ov6ef3mw4QR8yv/26GRvfnoEF/09/vBijINzJHiicKoMXQnw4jaV0l70rKTxyt7JZAaf4g0zIlg3eA+4zV4RxqpWbZssww0GTgEje9MCgZ5+7cgW5BHyBCy0EAajdN2i3gp3oMPLQUkqeob2Ip4lEXY2yLqCE2JdddJ2MQDQLf7uzumsEqeu8o1fW+1HIw6bI8IzWBoikQMT5ZpTHdQG2j+DPEW0aNE7E3fnddk3SJE0hP4GtDYMimus8wI+I73kfUCTmpiyQ+KkkQdClNWvZWHKNTCKPD+cssNtJE2fEuhy5Tedsg1NsOA/5aO6mODwZjn9EXmE4YTMBEAmRjYesS0EQRfdsl1WJxQp7GHm5tNH4HQ9EK78v3T+oXMlC++iUg9pCfxyzixnt49VFBIdWgngxWzv7+E28ihIe2WM55IO
 4an3Q9ZU
 uxrO6O8VDX41JnD5NODuGjDxsREnML8eV+yLkeaR6wWBdkq9ytljoYkRV2fSyAVcm8DoGscvuJgv5CIvomfS2IU3OoiSrvG161wr8ZvVeFhQbW8WVW//n/lJ5S0tf3wUSElM7wWjCQCYiPgVHf5lvGbkvDPn4rVLCj3R/fJYhOKBTNC1xLiYex2lF939RrGjpJBBzeOXR9h65oDhf3eGBJRj8ulywvv+dgpIlgXRWHqnPS7J2yjm5Ms+xim1Ozjvf60fZCRW582sRLylHK3EzsB5Jywnlv/foccnMcIIC4kjuJtVOfC1U0009WT8NnNMcURrUsXR0vNZCIPgWyU6QFZxSCIgopnMsJsod7pDm2dBTWKfb3MAkBeYC2uSfyYZT/MqT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 14:35, Usama Arif wrote:
> During folio migration, __folio_migrate_mapping() removes the source
> folio from the deferred split queue, but the destination folio is never
> re-queued.  This causes underutilized THPs to escape the shrinker after
> NUMA migration, since they silently drop off the deferred split list.
> 
> Fix this by calling deferred_split_folio() on the destination folio
> after a successful migration, for large rmappable folios.
> 
> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
> Fixes: dafff3f4c850 ("mm: split underused THPs")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/migrate.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ece77ccb2ec0..98d0a594f7b7 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1393,6 +1393,17 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  	if (old_page_state & PAGE_WAS_MAPPED)
>  		remove_migration_ptes(src, dst, 0);
>  
> +	/*
> +	 * Requeue the destination folio on the deferred split queue if
> +	 * the source was a large folio that was on the queue. Without
> +	 * this, NUMA migration causes underutilized THPs to escape
> +	 * the shrinker since the source is unqueued in
> +	 * __folio_migrate_mapping() and the destination is never
> +	 * re-queued.
> +	 */
> +	if (folio_test_large(dst) && folio_test_large_rmappable(dst))
> +		deferred_split_folio(dst, false);

Also, should you be checking for anon and non-device folios?

-- 
Cheers,

David

