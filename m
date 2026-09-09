Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A938C79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DB1F6B009B; Wed,  9 Sep 2026 13:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28CBE6B009D; Wed,  9 Sep 2026 13:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17BD66B009E; Wed,  9 Sep 2026 13:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E396D6B009B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:39:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56D371A02CF
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:39:32 +0000 (UTC)
X-FDA: 85194935784.24.37FF7F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 788A08000F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:39:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MD1sgUCp;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788975570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lckkvQ96etQRK/jiBHaJOZl8yzGvIy0G7bi8kXAAjKE=;
	b=KBWcETdk64y9xM3x/U8Qx7Zc7n8+dm9e1ZXYsqKuE6HemBLZ4fiNbGVFkcJ0oH3KUhGktd
	4wpbNMYPkHPC1pV8en55va1bNaUGfVzQVkOZSxss9qGP5r4cetXDnpwRnbtZ8XtaiiBzrn
	BJ00bvODQwWraA/WPnRkcaN95AVbtDo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788975570;
	b=hLO3STWFZmFGFNXq6Jt4enSU9DhWxWxuUvYpAlvdQO5T2D7xMifNjlmWBhYAM6VdqvOHOO
	JdA1DBuXKs34K/bVFMM8PjOuPc8QWzQPk5FB7hgJ00GdlUL7TT15uoH0No5CRGZkBIO/ZP
	hC+pKa10FKPRw4qpxx77qIDbJQAjLwk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MD1sgUCp;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92F5040357;
	Wed,  9 Sep 2026 17:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528591F000FF;
	Wed,  9 Sep 2026 17:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788975569;
	bh=lckkvQ96etQRK/jiBHaJOZl8yzGvIy0G7bi8kXAAjKE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MD1sgUCp7ahRANqwb9B3UoldMvPtufo5A6BpPQYcYs/ujUC6lNKBpgfTf5cncrxx+
	 M7FZaCSNNmJLs6zuogEfmbn/2Tf5sbkMkvfeMEElL4soC4xOiyUU67o0inDM/ffssf
	 mUtENC1EA/a8YRubyznqR+NQhKXWUItgYr3KK+hTSQ2S3LPewGll3v/F20ErJaOAd5
	 53hbLnDjPCFl0h69kxMTQO9kEI0PjYkcH7TZ2Etjcc0q7axb1ilAEkydilez/s93cz
	 2WTEfJvfPU/1wFekPc94lQVAU9ym0sYYPTX5HSWyjI/2tCJtJq6eeVFGSXHL8Tveo7
	 vBGtc/2uJj5/w==
Message-ID: <f2aa85c7-e4db-4b2a-9927-5869458171d7@kernel.org>
Date: Wed, 9 Sep 2026 19:39:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/17] mm/huge_memory: consolidate irq and locking for
 folio split
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, "Kiryl Shutsemau (Meta)"
 <kas@kernel.org>, Shivam Kalra <shivamkalra98@zohomail.in>,
 Kairui Song <ryncsn@gmail.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
 <20260908-swap-thp-cleanup-v4-6-b532a3f20e71@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260908-swap-thp-cleanup-v4-6-b532a3f20e71@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: n4ufeqxrf5boqy86dh5mfi4uwuqgua14
X-Rspamd-Queue-Id: 788A08000F
X-HE-Tag: 1788975570-934798
X-HE-Meta: U2FsdGVkX18xw6GTsTSxVrsYQ8MhVSucIoQBwPffJzL+6Lt+4nihnCzPLGCeSvb4GVZvWWCbVvr7TF3f9LAzPKRwqaWpJn1ubjU87/ZinPk9M16VGGeOLxVGresJk+cZhtLtU4sJOC/pLA2AWB6jjguEcBp0FnFzRkQRtpdzoUA+XT4S0hSw6susgbAH5ZWaAYkM2IUHhpSxYAAk5BKV7wCFhG6XLmyCldNUAhqGXDSeaIVfb98DGQfyIkTYkZDvY891dtcodH+1F4KuzmSgI5ZE8inmuv2zaer4sqDUE1QHkoumPYS93vdeK0sBcs59XQzwDEv2wrcFEBVgpOGi7ZKkJjQnPFDxIOyp8Xp/HJOg3QxKZ3vz7x43BW06l0ygOk4Hhp6Bdus1h5pPWy84aKinJTMlZGEb0ESevueIFQYBXDkHrBZhATSh8UV+2KucNFvXvbN67b1lPnd6mH3ACtJU8VKuVAfK4akldy0ZkUBx9B/74Q3dNrDi6oTwPIJHp2sPQo6oZgu/D01ex+INSgN/GOi8STS+R68pHjPyEjVVR8ZA+VTa/+9tYN/axOjd36ZOGrf6i6xXiroFooW/5miJBbyatbQMe/IuENJ1khefWfW8JNDwicJtBXzFra0hiLXYWzXSLvJyTzTVREV/+3PFxb22IUlRzl1Nkey9qbe6DCM+NiKZGt8rH0CkkgVeBGNzECxOr5om/I/5k5mSnA00pfrXQdNfFY829Y+JV3kFlIHpoj+spSdEi572IGzRxMgKn84ctlqLew6d5drygG25Abfc0oOncVujTCd65JGzI7wGakDOj8vEmF9T006kAmG73NVuvsL3C+n/xbgGcBY/mV6Nry6oPTBoPAjLXcHSHHSA+QSwXOzhc33CmGqwAVgE1MyVKxq5plJeS/0pZu8zQdeM4V+VQWtnVyT7f7dUW7F81vn3ekAuSlp2Dfz81Ep3ulGb26xPjz+PDbx
 iPzbW0Hq
 w36FEnGAHYP1V7UdX1BRPeWN8EbfNB2fWWDqnV/wGY1+xSK1n46aZfhTpGhYsuJUX19LnuuDRSPDQ4Mb44rKneLLPepj5ifToBNM4I+Sv+qddEoRffohxEdys2wZY0v27qbcZUyhkepleH8ednMW3NgNrZJzZ0JFZl6OG4mHvSy6LkQvmabAvwAjB6XcLOpfENfTr/7cnyXYqNZ3MW11RWkJCniFXatV0KmLctnALtjYL0AJ58L2cMKfgkeuvq1oOo3rfxwaQQ6kqCwNioio/v0XpeAL8vekbeAWM6gqU7bHahyLurDiAoUuhPlVIBHti9nuILdy4N0qviGVJNlPlUlPPSZXDCpKokkiSOJpO2STWJknrgS4ap6TPe7gUzXplIhQzjUeq9rE8ukw7PiIXLepYBuRLVtF99L5IModf32Jd7nKeZwxm/x9SLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 20:12, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Let each split helper handle its own locking instead of relying on
> the caller, so both helpers manage their own irq and locking state.
> This lets __folio_split() drop its local irq handling and fail label,
> preparing for further cleanup.
> 
> The file path now uses xas_lock_irq() instead of local_irq_disable()
> with xas_lock(). The two are equivalent on non-RT, and
> TRANSPARENT_HUGEPAGE cannot be enabled on RT anyway. This conversion
> also buys consistency: every other place in mm/ that freezes a folio
> while it is still reachable through the page cache already takes the
> lock this way. This was actually the last plain xas_lock() on
> mapping->i_pages left in mm. If we are going to support RT, spinning
> on frozen folio refs could be a problem, but it already exists in
> many places and should be fixed generically.
> 
> The anon helper keeps a single local_irq_disable() as before, because
> it has to cover several plain spinlocks at once.
> 
> The dropped xas_reset() was a no-op as the xa_state is not walked
> before the xas_load() under the lock.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

[...]

>  	if (nr_shmem_dropped)
>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
> @@ -4390,8 +4391,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   */
>  int folio_split_unmapped(struct folio *folio, unsigned int new_order)
>  {
> -	int ret = 0;
> -
>  	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>  	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
> @@ -4400,11 +4399,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
>  	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
>  		return -EAGAIN;
>  
> -	local_irq_disable();
> -	ret = __folio_freeze_split_anon(folio, new_order, &folio->page,
> -					false, NULL, SPLIT_TYPE_UNIFORM);
> -	local_irq_enable();
> -	return ret;
> +	return __folio_freeze_split_anon(folio, new_order, &folio->page,
> +					 false, NULL, SPLIT_TYPE_UNIFORM);

Yeah, that bit looks especially nice.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

