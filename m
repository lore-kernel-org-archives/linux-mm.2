Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C51C0606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 15:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LSgGPf0o
Received: by kanga.kvack.org (Postfix)
	id DBB8C6B05B1; Fri, 20 Nov 2026 10:35:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6C476B05B2; Fri, 20 Nov 2026 10:35:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9526B05B3; Fri, 20 Nov 2026 10:35:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3CDC6B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:35:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42492160FC8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:35:06 +0000 (UTC)
X-FDA: 85455895812.12.F259379
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9A9E040003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 15:35:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LSgGPf0o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795188904;
	b=Eg2k7cnaXeQcqyLXRfJayaEPjfJE7xIR4VXuzUa+/J25P/a5Ux3pUyJStdtBQGUTpmnvSR
	UmGlsB+JX975zNXWmJWUmnYJMagW1123EH7Y6Yh8n/8sp4V3aSR1KLDwR+vAtJKBKDMD+H
	Ns7jkeHpyIDamzkFBBMvkTEoYNPYTYw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795188904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JSOR2zLnD451En4fHV4lWcfu2c4ywdgSX1FC2ITuFNY=;
	b=v3v9T/1SbMSLCDFGwunO20tTYcFN/MnU5o+NrwyLBv+g4ess99AR6yMrVnBVL9kiRXU+FM
	PW6BMdUnXBzsL2smk73EDNb/5GEx999VOx9uSBQPBi2t/0abxoEDEd0zmjTBOM8QEs17gu
	acHc8i3C99rLlB6PoxPKmI/a9LL31bI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LSgGPf0o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CCD261F52;
	Fri, 20 Nov 2026 15:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D0C1F000D1;
	Fri, 20 Nov 2026 15:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795188903;
	bh=JSOR2zLnD451En4fHV4lWcfu2c4ywdgSX1FC2ITuFNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LSgGPf0oTWQ3yv9VLQ7g2jN3JT+q2sdZtsvBnJLmRxUh241Xp9mrIjyvuzOMaZdDD
	 OM+PWA6RoqjwUMtwqGcXnh8Hf9rVmwx3dxJlV8k3aTLAFc0cNDj/lBXBYAhF8NQd/g
	 dvOP7DcyoMKoCwYN5JoLPR2OD5POi7eCEVtH38ypYNpxFgo4zt57yZ54P5Ig8H+fu+
	 RAw7hL9YjZM3rKgJSLX4GokUtphYJG8AocHGVRd/S9Fc+6P/7424YuaExsXQpJ2N7S
	 IZ8ZWKRCiLP8XgDzw6hrJruNlM6UW6RSzjkNjlDqCp+FwNrl8W8MZmM3MMtodwO0UK
	 FPXuLeYSwZv7g==
Date: Fri, 20 Nov 2026 15:34:58 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: david@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com
Subject: Re: [PATCH 1/3] mm: factor out common softleaf offset PTE batch
 scanning
Message-ID: <awBnU0jVXCS2hj1S@gremlin>
References: <20261120032949.2036731-1-chenwandun1@gmail.com>
 <20261120032949.2036731-2-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120032949.2036731-2-chenwandun1@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9A9E040003
X-Stat-Signature: nh4f9gdd559rqk3iymz8hb536951mkrs
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795188904-637416
X-HE-Meta: U2FsdGVkX1/SNJ9PkEWPttF9St+mv1Nh60TEppW7SSFd/5BRvnXAQtoOdiJfA0bFxU1laUZDBnQwNjeLNBuW6yaypm7jerQdjX0tj3PeELhTri7gioFrTe+69ykmS1/zvVBGI3ycPPzTW8FhbX/FO+dVPaN3Q8alWnb5IVIxoZ0/tNo1iGnyiisC00l5Bslc1fTFHNuuqoUQzxe3NvE6Mx9uho9U/0bv4l2F6LeEjduneQHwmTeXPUVPER8NDLriut2Pp8qAz4NnYEJ8AvD2hoAuxxEsPEhg8p0N2XicsRG+kVf4KColo94Zl3TuV8pQ0CCHkoGJm80MWnobhHzDL1wn9zQeoogRdXqElzMu4E/p/feNqcxV+tpUTwlZCJ74WXOr7qQgw0NKfAgaaKxis7GrfctAmRvdoq2ONMVlFleZgDXGopvpHSaOnNUnyRxstKQKGhhh+t5PiO52be+ffTCbHPE4RUqUenKj+zW6cOmiZIl/RdZHrAYBdsqGZ9ZHT4PZAuc0FbbqO3znAPRy93XfAg1k8hCA787MTIihD9kDp05KSihBlS2tTA+m9EwK89WKvucOnXRRZLGoSbl4NA6v053vDXCyfQCN+crVa8I+t+sOEg7veyUE08Q2lZ+KcLlMFzAetEUstwavi/Ev1LSFWALb0iZCBYMoX+EALkz0zv8q5E47iOZ5lT6gYYOq2eK/Cip6mv4K18teKLDWxqcuIO4Z90RIC9I5TvxoXLsXYOzSsHLyDE9p4d4KokjCmk6jQ3oUOgxONkBVyUfFSuhzGLrcxOww7ehsTsNqKoqUbHs7TLti6Auza9PXDN+7Pdgc2tHH1yzpkHEGmHjUiDNQT0oQmW2LPXpjHVEVZ6uuf+hPDFzibWuUDYVuiKMybRBtZne25F5LLaAHIr5UlEisVfFV3N2TxHydkLCWIj3lfXumXTwphWV7VbwJRc0hDljM5iDzw5XnUy4pSef
 apyQmlGr
 TcGxqgS0w4ujN8Zr7hZk5BoZELgQL0x5qb7IWSPMwzhlksLytlrEZgIzwGCflXPn7xORfYThcR45+nkwN0XI6nfXnaHFOl4BI3I276pMzfO/CCjSS1Hlu7ekNHznWD87RIg6GVV/RAJX/fJ61VDXlC5If/0/Lc1DR4MHPtPaYgccasJzHkbNhLEkccE5b2nGWFUtVmsOtg5WBz96LX91BHEQeINwdcWKRughx09flg2RJZmuPZBlLJSAQLR3YOXZX68u75xr4Vf2IxoLLdNj41G39OQ2ml1xGxwNUS0YvIbhydWarxafU8NXiudHvV8YrYa1KT3j3CELf3c0QpvX808Oy1mMDXwDgNnp1PDQFMILcNarL9//mCUhh0xPQev2qDFR+/v95blRfz4PZ44h9+3y8Yf3ivUdWvnhfPE0XLEkkEdRr51IbqqsdrHsqz9vuAtNWj70sY4Nwu7+hSa1pnJYdI3i3KenCz87/Sj33AaQLb5Q1o2mvLeswVzdSVfnFi4gP2huJALI2QgSEN00vEjf1QYGierHNIRoWvjrvz8saAiSdVC7sf6n5tf/CBBmj3eR58IR4eghwEr5IHNcNyXM8HQKCxF4JQXf8e+V9UzYSIUc4bnoODbl3vqQv1h9fgKjnR0UXjFUQTjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 11:29:47AM +0800, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
>
> Extract the consecutive-offset scan from swap_pte_batch() into
> __softleaf_pte_batch() to prepare for migration PTE batching in a
> subsequent patch.
>
> No functional change.
>
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> ---
>  mm/internal.h | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 3a1643afedc0..9f78c12882cb 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -512,29 +512,26 @@ static inline pte_t pte_next_swp_offset(pte_t pte)
>  }
>
>  /**
> - * swap_pte_batch - detect a PTE batch for a set of contiguous swap entries
> + * __softleaf_pte_batch - detect a PTE batch for contiguous softleaf entries
>   * @start_ptep: Page table pointer for the first entry.
>   * @max_nr: The maximum number of table entries to consider.
>   * @pte: Page table entry for the first entry.
>   *
> - * Detect a batch of contiguous swap entries: consecutive (non-present) PTEs
> - * containing swap entries all with consecutive offsets and targeting the same
> - * swap type, all with matching swp pte bits.
> + * Detect a batch of contiguous swap or migration entries: consecutive

You mean softleaf entries?

> + * (non-present) PTEs with consecutive offsets/PFNs and the same entry type,
> + * all with matching swp pte bits.

Maybe 'softleaf bits'? Ah I wish I finished the softleaf conversion properly :P

>   *
>   * max_nr must be at least one and must be limited by the caller so scanning
>   * cannot exceed a single page table.
>   *
>   * Return: the number of table entries in the batch.
>   */
> -static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
> +static inline int __softleaf_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
>  {
>  	pte_t expected_pte = pte_next_swp_offset(pte);
>  	const pte_t *end_ptep = start_ptep + max_nr;
>  	pte_t *ptep = start_ptep + 1;
>
> -	VM_WARN_ON(max_nr < 1);
> -	VM_WARN_ON(!softleaf_is_swap(softleaf_from_pte(pte)));
> -
>  	while (ptep < end_ptep) {
>  		pte = ptep_get(ptep);
>
> @@ -546,6 +543,15 @@ static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
>
>  	return ptep - start_ptep;
>  }
> +
> +static inline int swap_pte_batch(pte_t *start_ptep, int max_nr, pte_t pte)
> +{
> +	VM_WARN_ON(max_nr < 1);

I wonder if max_nr should be nr. Or is it a maximum range to examine I guess?

> +	VM_WARN_ON(!softleaf_is_swap(softleaf_from_pte(pte)));

Since you're getting a softleaf_t here...

> +
> +	return __softleaf_pte_batch(start_ptep, max_nr, pte);

...Does the batching need the full PTE or can you just pass the entry?

> +}
> +
>  #endif /* CONFIG_MMU */
>
>  void __acct_reclaim_writeback(pg_data_t *pgdat, struct folio *folio,
> --
> 2.43.0
>

--
Cheers, Lorenzo

