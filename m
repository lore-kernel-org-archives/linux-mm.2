Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F7960A2602
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZiNSqQc3
Received: by kanga.kvack.org (Postfix)
	id 2B5FC6B05B0; Wed, 11 Nov 2026 03:52:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D486B05B3; Wed, 11 Nov 2026 03:52:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A3836B05B4; Wed, 11 Nov 2026 03:52:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1EFE6B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:52:07 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6AEBA80237
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:52:06 +0000 (UTC)
X-FDA: 85422221052.25.EFA4338
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A29C340008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:52:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZiNSqQc3;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794387124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8wykzOLysom3LTHkeGjf5Ujqz1G4Lprntggj7dNVM8M=;
	b=FwZh0JAjLmuUfDZ3YBz/6cDYCjNSk9x/bBmQgaanoN9mhpccqmsf8wjhpjS6q5KS2u+A+w
	MeAjK+6FbRcGs6KRKZLx9v0VSptIcoa0QEOKXqK75BM6ZcKCuwLpbuHNx24EYpUiSXSedG
	hH78O5ZWRreOIPe67RC+S+rCaRcgeg0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794387124;
	b=nZjaKx2UTN50GxN3C+tp+dqxgwyvhIxzqCcLPS1xdaVYupJGmoLxLorXC3dCp03Dy0Dg7Q
	gW+m0WKku9bVhPPHe90BixEf7A/y/tvbFZ+XvWQuvV8231UTMMtGo3yNXsngAghcQCeNhY
	F1BLfqEbuTU77feRk8iu2U4ClVb43Qg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZiNSqQc3;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FF6D62B8A;
	Wed, 11 Nov 2026 08:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FED1F00A05;
	Wed, 11 Nov 2026 08:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794387123;
	bh=8wykzOLysom3LTHkeGjf5Ujqz1G4Lprntggj7dNVM8M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZiNSqQc3q0uXnP+UR3P36A+j16smTNGEgv+gYmabH1FD6aLSBgfHattI13N0UN60s
	 Ouu0/c8Vee0m7hekIjk1kQmN6z6N9DX/73eOJZN9NPHOuy+jWUUWlHN8toTGHwQ4jt
	 pDMTIBJp9eEwgYlTUGZfNOI7mfZ3K5YE93E3wCWh1n97n8etmCPEp5yErjqtOGl71a
	 xl/lQ31UYkzK5geBYG5GNJvqc1BijH9xe+0wBI9EuqpBHlvbp/UdswQgKddfmcAWz6
	 HJANkx9bos4slWEhPO9GfQdzYBSQK1GOdR8Qk2M4DWwr6xxf596kw4zFoAlMy5bLp4
	 PQR0ydYpB/PWQ==
Message-ID: <86bc9747-ad4b-4471-b507-dafe3b3cdb91@kernel.org>
Date: Wed, 11 Nov 2026 09:51:59 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/compaction: Mark concurrent compact_considered
 accesses
Content-Language: en-US
To: Zhu Jun <zhujun2@cmss.chinamobile.com>, akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, ziy@nvidia.com, rostedt@goodmis.org,
 mhiramat@kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+212c2d1f47994035cf7f@syzkaller.appspotmail.com
References: <20261111084205.80997-1-zhujun2@cmss.chinamobile.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261111084205.80997-1-zhujun2@cmss.chinamobile.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 67dam56emxtyww9wykqkshe478i5pzwr
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: A29C340008
X-Rspam-User: 
X-HE-Tag: 1794387124-446576
X-HE-Meta: U2FsdGVkX1+VK/bs+/aXgz1CusuNuU2SvCGzMhC8pLajEt7HCG8RznEfeFvSV9fWvciJQUxOeOnEfarG1wcfOWeMpUnqt+4DFpKEzTfwQiRQwLH0+Sy6e1Fe/txM789OBfZ08f2sdTZq4kHO4wr/KFfqS91s03WHQBhaCjx0WaD7BsO8PrwYQtyiHVYJNnC3KIwoUOyeyW2XV/U0UqBO623r8tgnKwfZRjS7LqRWmGhimXczWBOCJLo2clls01zBkaZWhxVATEAR1XiS4776QHjY1P4+boMhTIjkXUiehvyYppeEPz1PE/Hz86pk2N7biYHxXENMGQOYcab240lrMwHiyVeZcwe5ZtEloQk3S9fimWrCrLVkXEMvUGnuRGkV5alU1Z0tqCriLbAZjeY7b6EQFtyoLQJr82O8Kdcekl+ym+4tWusdFGt8VMx0pRz1aZIWxVhAZtrlaa2a2fsYMjUJUuT3gJ45v9WhXAsYjx8lB5cs74YhWar9wv87+Nobneo9B2mGRRxEtjZJWazrFagfoSYeZ6WjBZnJa0uzvnjLBLk3+gKDDHWz5yXCX89SVSuzYFmInyYCvftZFejB4nv2xj+r0LVK5GCetckyEP6YM93lAsoRmPWF11tJzHG5NBJMpb0SUXQHhceci/6nMjT5VBtRY7qdxLNyvn9rZ8NpK5v7gTrkpaSX1K0CKmkpUcACc2giX5bAGy55TBkZk6NmDyQBax1cRg3WFpxVLDy+aRiLh4Vbv/JjjIX8mvCIjDQrhElJ4DuN6o6hKz9p544YQaHu6m9WfJNzfIQPryPniHjP7S7EnSGh4XOc7IDRWuNXPh0yYMSdoOky5aS/H1EW48YsfCHgFilppTIA3L62K1wBYh0yp95Ah1h26w2JptGQngWJ3o+OycAwqFKxEWUKqiogWhNQl3xpMubKVKgd21A5UNEkAPxrPd9quYpVdtQ7/8aD2wclc882ngu
 nXjFrgwY
 Kum36QzVnIjZiWaFOnF4n4vsBeo/g2xYWjLGXznRYv5uq7EqdwzRAylRVV+AS/FBMw5m1tyNprEVC2OwimOJBg9FVt8EhOgeHw110IX4TMwIKv5xr8shPEJf9p+bKYkDloJwbwvhhBOocnOm16VtkYidJpWfpLqWGaaxW2GzfThmXPHG74tri1uNXruOqkL/Lynto8t07PtYZUmwVK0JrfA4SUff0QRKl5m6mfAqzdGgRR9mQABvLWn85ZMm3tRoGAnVc8auAUpoSW0Dbhc3ytPuRBuACD4x20Uhu/kjBOvBWH59EUcJTaLEpHJWSy8Nq1AfiYmqVi06lqAgePCo7UpDL+9/3o+kxgaKbUp2YSukDbxDa3uBgI674mID29VJzrKyc/CFiv/+EyI9yjQdzdg/CyyfuFIEgEOSe4zGzLlWBCkmktYrhFKhrAffPZJiQrG4GaF4rpiL8ZXo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 09:42, Zhu Jun wrote:
> Direct compaction and kcompactd update compact_considered without a
> common lock. KCSAN reports the plain increment racing with a reset.
> This counter is an approximate backoff heuristic and already permits
> concurrent increments to be lost.
> 
> Use a local snapshot for the saturating increment and mark all shared
> loads and stores, including the tracepoint snapshot. Preserve the
> existing saturation limit and deferral decisions.
> 
> Fixes: 4f92e2586b43 ("mm: compaction: defer compaction using an exponential backoff when compaction fails")
> Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>

Shouldn't KCSAN be suppressed by data_race() and not READ_ONCE/WRITE_ONCE?

> ---
>  include/trace/events/compaction.h |  2 +-
>  mm/compaction.c                   | 15 ++++++++-------
>  2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/include/trace/events/compaction.h b/include/trace/events/compaction.h
> index d05759d18538..42303a4835f5 100644
> --- a/include/trace/events/compaction.h
> +++ b/include/trace/events/compaction.h
> @@ -255,7 +255,7 @@ DECLARE_EVENT_CLASS(mm_compaction_defer_template,
>  		__entry->nid = zone_to_nid(zone);
>  		__entry->idx = zone_idx(zone);
>  		__entry->order = order;
> -		__entry->considered = zone->compact_considered;
> +		__entry->considered = READ_ONCE(zone->compact_considered);
>  		__entry->defer_shift = zone->compact_defer_shift;
>  		__entry->order_failed = zone->compact_order_failed;
>  	),
> diff --git a/mm/compaction.c b/mm/compaction.c
> index f1b2060eb201..04b93d3545af 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -126,7 +126,7 @@ static unsigned long release_free_list(struct list_head *freepages)
>   */
>  static void defer_compaction(struct zone *zone, int order)
>  {
> -	zone->compact_considered = 0;
> +	WRITE_ONCE(zone->compact_considered, 0);
>  	zone->compact_defer_shift++;
>  
>  	if (order < zone->compact_order_failed)
> @@ -142,15 +142,16 @@ static void defer_compaction(struct zone *zone, int order)
>  static bool compaction_deferred(struct zone *zone, int order)
>  {
>  	unsigned long defer_limit = 1UL << zone->compact_defer_shift;
> +	unsigned long considered;
>  
>  	if (order < zone->compact_order_failed)
>  		return false;
>  
> -	/* Avoid possible overflow */
> -	if (++zone->compact_considered >= defer_limit) {
> -		zone->compact_considered = defer_limit;
> +	/* This is a heuristic; concurrent updates may be lost. */
> +	considered = READ_ONCE(zone->compact_considered) + 1;
> +	WRITE_ONCE(zone->compact_considered, min(considered, defer_limit));
> +	if (considered >= defer_limit)
>  		return false;
> -	}
>  
>  	trace_mm_compaction_deferred(zone, order);
>  
> @@ -166,7 +167,7 @@ void compaction_defer_reset(struct zone *zone, int order,
>  		bool alloc_success)
>  {
>  	if (alloc_success) {
> -		zone->compact_considered = 0;
> +		WRITE_ONCE(zone->compact_considered, 0);
>  		zone->compact_defer_shift = 0;
>  	}
>  	if (order >= zone->compact_order_failed)
> @@ -182,7 +183,7 @@ static bool compaction_restarting(struct zone *zone, int order)
>  		return false;
>  
>  	return zone->compact_defer_shift == COMPACT_MAX_DEFER_SHIFT &&
> -		zone->compact_considered >= 1UL << zone->compact_defer_shift;
> +		READ_ONCE(zone->compact_considered) >= 1UL << zone->compact_defer_shift;
>  }
>  
>  /* Returns true if the pageblock should be scanned for pages to isolate. */


