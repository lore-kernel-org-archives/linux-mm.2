Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93DEB606D80C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 22:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OHyZ8wfv
Received: by kanga.kvack.org (Postfix)
	id B8AD76B05B2; Tue,  3 Nov 2026 17:15:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23726B05B3; Tue,  3 Nov 2026 17:15:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60C96B05B4; Tue,  3 Nov 2026 17:15:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1CE6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:15:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17D51140559
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:15:38 +0000 (UTC)
X-FDA: 85395215556.06.8BD09FB
Received: from mta1.migadu.com (out-68.mta1.migadu.com [95.215.58.68])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9A45320002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:15:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OHyZ8wfv;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.68 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793744136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kD7/oy0hwypJ7ExrCRAHj2lx8lfZCGu4dTxOJHdadCo=;
	b=kX6uZYCn73GmohiGT7GAHbyKIrtBMt95TOuloLw7xkWPxifgtG5drEf3jLdXKHWCv8Ljwd
	10pn59/biZMReuBvzUBxfnCMxUWat1r2nkWeQbgLFX0Y/vD4xvPDySBZCUFmv1a/Eze9sJ
	chwyulUsqR5rZoozvE9J1ZHuqtR2jZI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793744136;
	b=mUkfPqulpGQZaQlqcJSsuugLTwQh50c2aVv5FTl8tpm9ybgZzZ9iYtV8F0WoTEBfXPyPvn
	kXEhyhESv0S3UzmQzHYV5brM96ZrL1/kRjwObVxPPNdswHKm4ybcFj/4QspNTEs10aTbx5
	fB7v0VxWCsc3Ehsyt45RdobGsAQZvKc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OHyZ8wfv;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.68 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ChNZRk0P4lxxnb8LDGMNOEFjpiuyh542QVx5CS9sNoE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793744134; v=1; x=1794348934;
 b=OHyZ8wfvCS0rj/TuDPJ4pJpEb5DsSryKDlOrCVxHlwF/s9cJO6p3D/+EYEsFJMd45ar+JAB9
 oI03uL3Uj6KKcH5HQ9uN6+u5pxoAYeh7GDhN3n1zSQhp2j1Jy5Y+cVPXvW8RkbX+BKVHaZ7Vcmn
 5eNK7mCCde11A3UjEHbknMlU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id bb106b05d82ea302;
	Tue, 03 Nov 2026 22:15:33 +0000
X-Mizu-Trace-ID: bb106b05d82ea302
X-Migadu-Flow: FLOW_OUT
Message-ID: <989ed3cb-7d71-4064-bb6d-7379a926188d@linux.dev>
Date: Tue, 3 Nov 2026 22:15:32 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] mm/huge_memory: don't queue folios when underused
 splitting is inactive
To: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org
Cc: baohua@kernel.org, hannes@cmpxchg.org, kas@kernel.org, alex@ghiti.fr,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-3-joannelkoong@gmail.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20261103212004.1356327-3-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 8b1gxsmbkyd7xp37sxwrgq3g4wb73i85
X-Rspamd-Queue-Id: 9A45320002
X-Rspam-User: 
X-HE-Tag: 1793744135-661037
X-HE-Meta: U2FsdGVkX19WPbm3O5d0TFYXqRY38Cet80bfwF3Az03nERKWC4H+RQJKqD2gf+TWi8kJ4XNPLXtzq/RYliZ8EuPAaVVyGySSzu2jqVaJGzsnhJcd1hxtyW4Nn1yEVPsVt/nx606VUkJmQB2+y/E5w9GKyYMIQvRj7u3xS3dEYEW14v2dq9dAgC+1+IHsT8kT+Ov6ADT3UoXZc3LMrmNVVSDpJtOxaXzMZ8WgZwbEt8d2qOvFEWIsdQ61tKyMlgUD41rfPu0KbroLGfbE7yfFl4u4mw4JVqCc1kQ8qJR8QGw4nZbYox03rJKTeGiMtAkgzeVvDVA/4G+r3E5EXkiWF6+qm7o1q4kWy48bpct14KXNpfpt8jeacAaQ24OyfXCLP2T2iPhLGjS8MOj5gXU9XYQXx7+zYHoO2Kr5JBJd+JJf7i+b7WlsdaSDbkEuDMEGjOXipcUC1Yzp5fYA5mGx3WEhQK0B19jY9uyyMgCIZwTj2d/qDWpLxYXVDUtRLhO/6uLUHlzEhAwvtbbEYM4T8G2BOnKkxERKV13nPxZ8cUMDeZW5WrsycrXWZAWUvoQUQ2M4Oxp0crV//nMrUATYKkI9qjkx+YApU4rn6ye9R8+fGQk/20G4aQh2wXm3Bk+Gx5sjnu1+RYL2ViACmTWci9WcyEdbfJK1jd2lLUXNNpGje+VdTQLBU53k+WTVQ66+v+coUqMvqjVPd+WkKm2mT5hCl+JAA7LBK0PvP2oigLnKx834KaElFXX1V5WM8QxVAb0FluxSPkAFFOK543mdMtFDxP2VWqCo6hGvbZIbzIg1V4r350ZssabpQgtS4FdjqiPwZzIFpfFXB5XGC21l1jaF9N+jSjG/zdsppqx7it9doFW8Qo408He3ooDI7LLCdrtwimY9G6TjwyAgbTBnTqRemdZE0ZUTq4/KjDnfnTPZnKr4bmVHyhub7o3XjGlOdvNMd3i87I7YKdAStvb
 5hRkhXC3
 b4KzylnEtW+wb7zlj6rWhVjUapACN0JDK1yG8dstPUAS3XwzYZJ1Vdqp5hIT0mlGlyGASIGp2j+bUO/KGUXw4sbWM1HAg4q/svjOmQkT6v6/x2Uq4vQbcUgOynTIvZTo9ZCjVMTUWIqdORMUSvHfG3nb80omfkpnUls1VD7pH9b25pUmrTV4gRtSmZ+QnVYoo5xWUiWw25feFZcDUT1Sz84KjKfUwRDt5ZyHbU6qKUq0JAVo48DF3xHpvHH+6HNaYEUBXr7pblcayN/Q6RfeGqQassh0glJPkH/310ckiC6m1HHZ63wbK/9Y2v3q/tWM2Rvc0NPMMh3eHUdHi8w2WOwzZ74FUOk+CuJb84+VbLnI7Tf2g/XLsKnoPI8Tm0S7WKeUtTuT26jvyKBA+htEElSvQ7Fn98Ac7K1mhrmWlBgXspTU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 03/11/2026 21:20, Joanne Koong wrote:
> Every anonymous PMD-sized folio is put on the deferred split queue when
> it is first mapped, so that the shrinker can find it under memory
> pressure and split it if it turns out to be mostly zero-filled.
> 
> With the default khugepaged/max_ptes_none this is wasted work. The
> default is HPAGE_PMD_NR - 1, which tells thp_underused() that any number
> of zero-filled pages is tolerable, which means the shrinker will never
> split any of these folios for being underused. They take the list_lru
> lock at fault time, inflate the object count the shrinker reports, and
> are then walked and dropped when they're first scanned.
> 
> Skip the queueing when khugepaged/max_ptes_none is at its maximum, and
> factor that check out into thp_underused_never() so that
> deferred_split_folio() and thp_underused() share it. Since the default
> is the maximum, out of the box no folio is queued for underused
> splitting at all, PMD-sized ones included. Partially mapped folios are
> still queued as before.
> 
> This also matters for a subsequent patch that adds anonymous mTHP folios
> to the deferred split list, as it keeps systems running the default from
> paying for that on every anonymous fault.
> 
> Please note that the queue has always been best-effort. A folio that was
> queued before khugepaged/max_ptes_none is lowered gets dropped from the
> queue by the first scan that finds it's not underused, so changing the
> sysctl has never retroactively applied to folios that were already
> scanned. Requeueing eligible folios when the sysctl changes will be
> addressed in a separate patch.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---

This sounds reasonable. In production, as far as I know from speaking with folks
in conferences, no one changes the value during application runtime
(atleast this is true in meta). Its usually only changed before the workload
starts (or just at boot time).

Acked-by: Usama Arif <usama.arif@linux.dev>

>  mm/huge_memory.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 3720c12bdb0d..903bbe972011 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4564,6 +4564,15 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
>  	return unqueued;	/* useful for debug warnings */
>  }
>  
> +/*
> + * At the sysctl maximum the user tolerates any number of zero-filled pages,
> + * so no folio is ever underused.
> + */
> +static bool thp_underused_never(unsigned long max_ptes_none)
> +{
> +	return max_ptes_none == HPAGE_PMD_NR - 1;
> +}
> +
>  /* partially_mapped=false won't clear PG_partially_mapped folio flag */
>  void deferred_split_folio(struct folio *folio, bool partially_mapped)
>  {
> @@ -4579,8 +4588,17 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>  	if (folio_order(folio) <= 1)
>  		return;
>  
> -	if (!partially_mapped && !split_underused_thp)
> -		return;
> +	if (!partially_mapped) {
> +		if (!split_underused_thp)
> +			return;
> +		/*
> +		 * Nothing will ever split this folio for being underused, so
> +		 * keep it off the queue entirely rather than paying for the
> +		 * list_lru lock here and a shrinker scan later.
> +		 */
> +		if (thp_underused_never(khugepaged_max_ptes_none))
> +			return;
> +	}
>  
>  	/*
>  	 * Exclude swapcache: originally to avoid a corrupt deferred split
> @@ -4630,7 +4648,7 @@ static bool thp_underused(struct folio *folio)
>  	unsigned long max_ptes_none = khugepaged_max_ptes_none;
>  	unsigned long i;
>  
> -	if (max_ptes_none == HPAGE_PMD_NR - 1)
> +	if (thp_underused_never(max_ptes_none))
>  		return false;
>  
>  	if (folio_contain_hwpoisoned_page(folio))


