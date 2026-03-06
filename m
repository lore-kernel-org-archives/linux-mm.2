Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F102DF01835
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 13:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B276B0005; Fri,  6 Mar 2026 08:49:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E736B0089; Fri,  6 Mar 2026 08:49:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05CF56B008A; Fri,  6 Mar 2026 08:49:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E455C6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:49:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4612459635
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:49:39 +0000 (UTC)
X-FDA: 84515770878.27.4DA264C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id F13A440006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:49:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oxRUEyPD;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772804977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zi/nqIfVyXxnBQRM2TtiweIEfCQTzTkY3lXA/nq98hY=;
	b=WS46FOtbzmmR5WrCzuNVgnB9KVVeuMFvGEvV50ZUy4nffAysOd2mPMN4xNAWW+UUi3I56r
	C/ooAz5QJWn5reIpoMudHRE17oPTGJet7TdSyI20TawKmxOaPYpkS+IF1UNpA0HwGFbyNV
	OEu28OoYVxi2rTnhAp74sIm2i0vpxnk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oxRUEyPD;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772804977; a=rsa-sha256;
	cv=none;
	b=QaC/L4yMHs78atF3wrOSvY0bNXsf+QARQIuRLQo5rpBNgnZxTD8d2r/gS8tzXQ2eeafBF1
	xz2lTWEj/UN5Yu2SIBZudOvVcRXVZCLAeuUR29fzEJMSTIdWfzELHve8sSQji7OWHpRV37
	F9TK4Q7HOO6RhU/1bj2fBVI9gSNiNa8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C63F140234;
	Fri,  6 Mar 2026 13:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B110C4CEF7;
	Fri,  6 Mar 2026 13:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772804975;
	bh=irOuPnqtfg3b/SaxHjIDOK3emq7XQZuod4JIYQGwsI0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oxRUEyPDum7HCDI0i9m+D1kN2UUcv7bGDNu06MEpelNeSK0caUq6J8rXGgksSmgj9
	 QJfRAQ7UULSbl2fn/6qyoLO6VSkYg1jcOMl3oqLnLlFguufUHVdjaQxHByMwCDQaFp
	 /OUWbTzGykXwFIZ5eH5t95j1oB+pMiEiCZcTS/o9hF2PhaXmZpSRP2ldfQVucIklG/
	 o9U+SiDeEyD8vihv4rjvxPdvUpYrhnpER2Eu8UQ331kd/HUTYgrlsXNIeTmiWLvMQO
	 Ro6cA1l3zdgawtAikWWHNqtBPPlYKTT/g5q53yFc6LO1xVvpO80OgxbgtqWKdf3BqX
	 SDg6nKcbSa6pw==
Message-ID: <ab22e50d-3af0-4acd-9d7a-a0e86d0c4fbe@kernel.org>
Date: Fri, 6 Mar 2026 14:49:27 +0100
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F13A440006
X-Stat-Signature: qxau7psdy3u5ccm3kthxz4a4yd1zzocf
X-Rspam-User: 
X-HE-Tag: 1772804976-207260
X-HE-Meta: U2FsdGVkX1/XLS81EhxhGOAUvxiw/KRXeSVlqWRHe20tSBWI4PlY3Kt/G4Nv5vQfwf9ylar92dr5y6XA0sbls8ZkjUp8YHUnrx5hxv5kvz45MBpvwhPIAr5m5cf5zP5oYsFlHCAR6Wtov4H27YfwK/NtP/hQfAyVKz2YRUPIStKYPchmVkGgdpcLbpd6fKw7MMi1lEgn3+khsaeSdqaDfKrX/U/6ubNo2PqNVUCBaDvUTTvQrGyd3Tqn9QM2eKgMnxIOqmyNmRw/yUvajZYunOaB56vBTM+/nepmmzNph7l1dyA+T6/dSLd09CDlo1A9N4HGrBAGCpMg1gbF4pnGFZ5Y+5GMC4QEH7Od54mLUmANdz6U9F++GEmrHWbBta8CjLb+Dr2mi9OR5c7Ii15GUjD+pwsq6kgpiL6vw1NJ7j3ogjgPAjS40ouprl2IYDTFzIKIirbqLI+Qa2xDTkEZtsq8ZIZZDR9j5tFBz1ivJuLMRBPkbZsGKT570gjmk9omSJVBlIifoTYJ99HjTFN2DNbdmP/SuJp3pwDvhQ7hsYlm8pZR2fpzCB7i0CNoWH7+PyDflG2i360yILatHSWkN2iHYQlvOa/uLLYbEOINXGrUZ+oNJ82RM5ivaQK6wmJYz29phINRQIf7CckciMwA5guEX8J4uE7LVlu/6pBNXlEKKOqZjAYXhEY2jMGXcbk0ANc1+rIbYt5rjPB3zmJbz+vgMNJZYDpJRMPWF1g9dImuByMetsJBO5vTndUFROUtVlwSbtbjVIdAnVhVCUKYUqBX/dFb7h3bAgra8y8SN+4C6cl8Kej7e0XYlwbDFBOSSTmc7K+CAle9YGKyny5FBjfKjqI8U9o7hM/TK2e1z50eIAJMB/GsntrIqVRcOpOiumHNwX4vwevGFAKa3BipsM7sER25R8bT/FznnUTKPO4gznsblxhEZmPGhKoTU4Oz4Tm3sAvRcb6YFld1IS5
 vejEGG5D
 LdcH2v4g0L3vdTUBTvM2Vbe8qJ1d7KYkF9h1UA+w6p8BWHH0mEMGUksc9Nl3WUkgh+MB8Se4MqhRYDY2bLtaBvQNqaqMNg2WrcWsCXcSxUg7FEM8ZfYCTNkKGeF0SIHuiLr2kRB4KDS0xcwsWfnRCvxmwzkLqcWkhW7uK6ZW+jYHwi49ZuRprKsjZJnUcQXoLhVqdgJEgTHEaqW2anmW5G59A3uc+HQ2PTGU/bf2Wiehd9VKavBI2tZO6KQrGoNy8DTxaNKTvwQ24NXxolU+q0iu7EuEHvKgGsnKYRcjKSwU+Bu1472tkNliHpxLibRZUH8mQB8540gMv9DRGbNwi5/MKPbJXJf9/5GHeXRhkXjDFjhc3c9LmD2EZ8l5+95GsJmx1hL/rfj78ZTc=
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

Doesn't that mean that you will readd any large folios, even if already
previously taken off the list after scanning?

So I am not sure if your "if the source was a large folio that was on
the queue." comment is accurate?

-- 
Cheers,

David

