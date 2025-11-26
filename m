Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44E07D1039A
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 09:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 857016B0024; Wed, 26 Nov 2025 04:56:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82EAC6B0026; Wed, 26 Nov 2025 04:56:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71EEF6B0027; Wed, 26 Nov 2025 04:56:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6786B0024
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 04:56:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 15D114FF8C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:56:43 +0000 (UTC)
X-FDA: 84152303886.01.33B9598
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8B92E14000F
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:56:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GdHsAivm;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764151001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rXIIdpEugFORUd3ePzvOUQQ1Lb7JZu0oX8/oWUbwfo=;
	b=JRL/TUt6xrVWn411drbl/ERl8uQXmld6D6VsMp4m+Sh17z+MqJ4R1H41d7lAg4gwYsVnNj
	txWyqj3h/uhIWg0KOqtv/lD3lQA6zKjkFP0Ftwl3H5cXcFNfuDPToHmAY0p+G4ZCNwy7Co
	jHrvFlCuyoul5E/z9gpBQOtbZVde464=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764151001; a=rsa-sha256;
	cv=none;
	b=rHcx3BRnq+bDHSGGFBR05pNbzC3t8oVNQpcOVEQJxrMPMkguRHjzT/EaZ0rOc5CERE/sQM
	C9cUcsGaAxfjZB03KIDKr8SInLDdFLa9h8E5e++Y/UEOebP+u3O+95N5/zsnWipdJX5qgS
	ab6HRy72VbXxkLckujcowDLgmeMptMA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GdHsAivm;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D3DB76019A;
	Wed, 26 Nov 2025 09:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D20C113D0;
	Wed, 26 Nov 2025 09:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764151000;
	bh=41XEjJVavDVOl4dTQpdEXBQHgHzpx6J2pJkRqHXfIrk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GdHsAivmycdVjGG7EiJcYHPtS392UcyW5xx8cL3+AgKXJz1002rLoU91wlx+tWCuQ
	 gCt3p/+tq2jiyDc0Eo/ugxza3rSor0xF+Kt7uE6xGUqTN3kqv8dT6N5I1Oaorcdk1V
	 jaLUNHjEnYjgmEChNS9Bq6ibtYbPhWBrQ6T4PcHXZ2KUU6uQllloZu2HHwwHW51QhQ
	 hOpTP79nYv0TSTuQeY499d2nEw9J1KvHNoS6b0RVEzmkk5h8BKYlI5gen+9456f8wm
	 u9pF7ibHtrxioX021BFFD7ebLinMrfSvAhAz+AofbdvqXPAAfPlfZSXyx999L7Zooo
	 cjFZfc+lGuu9A==
Message-ID: <71b8c4ab-3f4f-4b45-a9ea-706871463a83@kernel.org>
Date: Wed, 26 Nov 2025 10:56:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] mm/huge_memory: replace can_split_folio() with
 direct refcount calculation
To: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251126035008.1919461-1-ziy@nvidia.com>
 <20251126035008.1919461-3-ziy@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251126035008.1919461-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ih7sb1a6f96ngrxksy7coqw4h3x9f9ye
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8B92E14000F
X-HE-Tag: 1764151001-662915
X-HE-Meta: U2FsdGVkX19CQuUdp82+cBe8IAF5juHchU0abJFugLiAr/1S2EBERfyrl4Q+5hlhj3AS2oh3Uv/kUIN/X0SrwkBadzblpme7FC4q61Q/ASSiUertRPXy/6pxlz5Q5IoHz7KzfGkFNyjQvsDDv/KyOeDncepIZkq0p3v1svrr59yQ+VAK4Z0NfwSa3iI7XZh+CrLF0gypF2Ny1oHAvz/R93HRQAGjrigR7xxmgF9dMFDL1Fr0ByJNo8UBf1phg2FVRmiaZm33zmYfWjjM/FkTbGde2QC2nA1CWuibYEM51SHwUy3c6RCtcmiTgVc23WIThleSSVeIlSm964RRdUSYkccajupjlOHH4LHIQYJi4q1V9Ym4jgx1IjUWIENdNSQgqiW68IeL2tTmXsLOL9sVokCkcmSALqGySbryBpsKa7B11e+yPuoi4de/0/2InooU308jZAdg3WyJFrSLrkd0wg3/zqOgKxRiXDc/kgIki+lOPKU3AO9AwGAYhr3BM9WYWiUaiUbC1aVEtpF40ZzaDGoE8Jr3UpJ0C72t0DyCLTKP9G+JHVlByK+OBlPjktSnYr7ZuqEgGwfs5C79yQAXhyCfTHtWyuppn8a3YaR9t8WIQKPtrJWJ/s5cX9tKFxtcnscpD79GXlur916A4vdB6r45gUr+tyGO+P5tSz1s2UYecaVU1Mvc4vnb4tg4W5aAjHLbUcf+kg+7YnDe55uvDlO3JYnZBO1jygt8i6FyuLi6s4htZCDHUN3E045fWmsOBqy9c0W2qiqSRg2RyZAX2zVVyDDlJ79+wh7cGogeSUT6C/rMig6BKMwW6eFMO+yUm/bNzdaRNwlytv7IF0nuK+EChQ+YR4vDIM4Qj9u17DglE1eDz7KJ0kmmuZJRAGuXbawij4nMDggahntDcKSBaKgxVAWJ+c5jJrz1gHymMvMV3qDILrrTZ1NG+mgZtgG/nyNEHvDhd5wjPhxh3XA
 NrNI+bQM
 v2fIW7lS21JyJ3bS1PtX+kj9rNVLY3rDLUgqyNoY0ifbR7dkOCxUyvTQojUxBkw+BPdil9clkhnQROiU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>   static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
>   					     struct page *split_at, struct xa_state *xas,
>   					     struct address_space *mapping, bool do_lru,
>   					     struct list_head *list, enum split_type split_type,
> -					     pgoff_t end, int *nr_shmem_dropped, int extra_pins)
> +					     pgoff_t end, int *nr_shmem_dropped)
>   {
>   	struct folio *end_folio = folio_next(folio);
>   	struct folio *new_folio, *next;
> @@ -3782,7 +3773,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>   	VM_WARN_ON_ONCE(!mapping && end);
>   	/* Prevent deferred_split_scan() touching ->_refcount */
>   	ds_queue = folio_split_queue_lock(folio);
> -	if (folio_ref_freeze(folio, 1 + extra_pins)) {
> +	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
>   		struct swap_cluster_info *ci = NULL;
>   		struct lruvec *lruvec;
>   		int expected_refs;
> @@ -3853,7 +3844,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>   
>   			zone_device_private_split_cb(folio, new_folio);
>   
> -			expected_refs = folio_expected_ref_count(new_folio) + 1;
> +			expected_refs = folio_cache_ref_count(new_folio) + 1;
>   			folio_ref_unfreeze(new_folio, expected_refs);
>   
>   			if (do_lru)
> @@ -3897,7 +3888,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
>   		 * Otherwise, a parallel folio_try_get() can grab @folio
>   		 * and its caller can see stale page cache entries.
>   		 */
> -		expected_refs = folio_expected_ref_count(folio) + 1;
> +		expected_refs = folio_cache_ref_count(folio) + 1;
>   		folio_ref_unfreeze(folio, expected_refs);

Can we just get rid of the expected_refs variable as well?

Apart from that LGTM, thanks!

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

