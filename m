Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32E57C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:55:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E6EC6B009D; Tue,  7 Jul 2026 08:55:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 170346B009E; Tue,  7 Jul 2026 08:55:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0619F6B009F; Tue,  7 Jul 2026 08:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDE866B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:55:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48C921C3953
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:55:37 +0000 (UTC)
X-FDA: 84961977114.03.570D1F0
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 757A740006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:55:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E6rFw4FQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783428935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RocPjRVmhKRX2Gf0pkjPFphj9HwTbw1IGurD0TN9Dxs=;
	b=VxGTtN+92LEuypQx+iKwJ2IgmxHnII+U2Lscunn92g4pLqfMC/3qR8Fe6UyTk9/qx9nMTi
	KvymkGHO0Boubhf/efep52gKi3LxZmRHzWOqdVrRMoLO0WXpfxhuoeQ//Q186ZPVC/LSih
	N1F2qoBX802/srqnFIJkJxK5SEjdQ8o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E6rFw4FQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783428935;
	b=0T6GKmgbyI+4x3urG/AxMKgp+Q21kqFhTZlx7JWPFanrOJPKANrHJm21LxpSv+rBgEdLG2
	wJowM0HXNTukmG13NmVEFWWxtU81XOSWwljBZfyX+gZHwqSQNUIl3vDP12r/HzSeO63iGl
	GI3SBPPjlsR+4j2I1mjJR8THcto7e74=
Date: Tue, 7 Jul 2026 20:55:18 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783428933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RocPjRVmhKRX2Gf0pkjPFphj9HwTbw1IGurD0TN9Dxs=;
	b=E6rFw4FQWw2qdm0dZDuOHLoC/Hs5JB3u6KObSs3b55vka5YGoXTuSiNs71dL24GPbp971w
	N3+3xzREEyYKKSyC4O2ACyNYf1JZw9UyRQSU+uafXAnYOzRnqJwqRYO5U2DswgIZJA58pj
	6YEib/ysaWyxBDeMJr4qYNpnMIgBrYU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, chrisl@kernel.org,
	david@kernel.org, jp.kobryn@linux.dev, kasong@tencent.com,
	liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org,
	mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org,
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com,
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org,
	youngjun.park@lge.com
Subject: Re: [PATCH v3 1/4] mm: avoid unnecessary lru drain for
 wp_can_reuse_anon_folio()
Message-ID: <akz3NnXR2uP9ID2E@MiWiFi-R3L-srv>
References: <20260701235955.36126-1-baohua@kernel.org>
 <20260701235955.36126-2-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701235955.36126-2-baohua@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 757A740006
X-Stat-Signature: nb1q9icaowbzj4njfj19jujjghtct4jk
X-HE-Tag: 1783428935-194462
X-HE-Meta: U2FsdGVkX1+1ewJq2WgNBCXh2UNM/OZ7ZhKatBVEjEJChVDlIgFCs1vrNdFfbxi/al9RGypHOV4GJkOLSNUqwBckQzt3Iaca8ZKswNkOvc81Y2NriUlRXTw9mIc9vz4FjlU5bM7HKL89w6iqZ/lk0U+DskdMod+ds1sAQlzZt6qMahcktLFbvoS2ootzbJQBiHXSfLlND7oVpKoxPXmqqzK7vAErPaNKFgj+1F2gXuRG9HCdLaQUNeSDOiM2safh/Mw7jggwWnJPzRTmZw8NpUyeBqBNhj4Z/fc0mRhb1gMomNhWrd8tLq5+PHnTSCL3ti/g5hCMOEz88B4epmAMnUZeTQupW3Qt7wEenhUUUczjpRosWhEVLLvaSVnZ+1IKZGjdhWh0t8LyVfFOGrlhhyBI+3wrbd+3pWh6LgigAb6t2qwhoQAicMB5+GEZ0V2jt+zrAfoeQcJ4awNiMtP1TxGa/BUkya/XhaL7BHd+hvmuALkmCn+eFnWm9T9S32u1E5zB1vskCUp9dmrVwV+gLzItnyfHB+Jc208nHYqGb6whq7lUwFEyOn0ZwdglxaGXv94kmGUD+x9HrB5FNQnO0RBYXfiKEyVF71OA5uqFgLUnk34M2GbBP+kEVnT1ALSC+7sHy702mnmkfk+/23UnqdLJtYCOS/BPxOh0DC6T0c+L/94bZtuYUm0CHKVmvY0zHY7BLkjwglfGqgsogDalGPcM7TIiP5ws1B7Vrnnrx8TfIIA0/Ivr04nzWSNKEd3uqM1JPihvZzagYCJ/KlteIFR/7Qlmiu9FHByZlBBSeYTx/Wka6aWyDD79QS2LBtguy9Sly2HKxmb6ymHPVcnBDeYOlrHBw0SQjxeXwxZo9eLSUAS84N3pw9ELQlvS1TgWFVnhvciz+01n/zajJaT0TXdEeKvBg0tjkltvl76Y10fxWXPLH+gA8pYeb7AUcdm/E5AHakLlAaCw8qWLM9y
 OYw51FtB
 P/tEUBfbV+vJo1s2qZk4bHOezeSjaicHG9wki1+lR4BcDnJXEiNpcE9sJj594AGvunsfBvM+xu3Xm8NQWaDmDBo/wEzDwo1TKd9q+9wnv5gViygh0dEmYdALHBw42uo3XdgDEMeUB2eOiz5kVXuGiO2Rk8RS9l2ApAOY3Jh1bExokdAbBej5Nd9RPADbPtfNV5NHPfIDbKfQIdUJ+lBL7cVskx6axU47fYOTH6zPwTLdTj0ZVhFth3eUXOVL9HvQwEHu16laOwNo3i+1R0szYSzAX33MHAjZTGP0oGuyYGUUhPpj/cagV+gWErZ3TmvMBHYCY0jthIhqtCh+B213dLzbntQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/02/26 at 07:59am, Barry Song (Xiaomi) wrote:
> There is a case where `folio_ref_count(folio) == 3` and
> `!folio_test_swapcache(folio)`. In that case, both
> `folio_ref_count(folio) > 3` and
> `folio_ref_count(folio) > 1 + folio_test_swapcache(folio)` evaluate
> false, causing an unnecessary local LRU drain.
> 
> During an Ubuntu boot, I observed over 5,000 redundant local LRU
> drains. For a kernel build with a minimal configuration, I observed
> more than 20,000 redundant drains.
> 
> Fix this by checking against: `1 + in_swapcache + in_lrucache`
> instead of hardcoding `folio_ref_count(folio) > 3`.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Kairui Song <kasong@tencent.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/memory.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)

Rechecked, LGTM,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..87da78eb1abd 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4181,6 +4181,9 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
>  static bool wp_can_reuse_anon_folio(struct folio *folio,
>  				    struct vm_area_struct *vma)
>  {
> +	const bool in_lru_cache = !folio_test_lru(folio);
> +	const bool in_swapcache = folio_test_swapcache(folio);
> +
>  	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && folio_test_large(folio))
>  		return __wp_can_reuse_large_anon_folio(folio, vma);
>  
> @@ -4191,15 +4194,16 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
>  	 *
>  	 * KSM doesn't necessarily raise the folio refcount.
>  	 */
> -	if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
> +	if (folio_test_ksm(folio) ||
> +	    folio_ref_count(folio) > 1 + in_lru_cache + in_swapcache)
>  		return false;
> -	if (!folio_test_lru(folio))
> +	if (in_lru_cache)
>  		/*
>  		 * We cannot easily detect+handle references from
>  		 * remote LRU caches or references to LRU folios.
>  		 */
>  		lru_add_drain();
> -	if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
> +	if (folio_ref_count(folio) > 1 + in_swapcache)
>  		return false;
>  	if (!folio_trylock(folio))
>  		return false;
> -- 
> 2.39.3 (Apple Git-146)
> 

