Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A0F5C9830C
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 13:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 401956B0099; Wed, 23 Sep 2026 09:49:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B1536B009B; Wed, 23 Sep 2026 09:49:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C9706B009D; Wed, 23 Sep 2026 09:49:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA05C6B0099
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:49:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 852F016082C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:49:38 +0000 (UTC)
X-FDA: 85245159636.27.58060D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B379EC000C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:49:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MbQYG4T+;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790171376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMEn8rMByxkBYSiMmrnZBaoksE1XA7duT9/L5oZzD14=;
	b=5nIGG0sXp6NbpNWSuev2m+C5Lsn+87Q/koqPHl0V/TuUWBMTGP7WcgRl9tEI5vTW7s+qLE
	wHsnsEnmPRhg9I/AXabIq7Op+HR4tZwg5cNuAXst2qPnBtdzJaCm7ZYuzH10yeltimT1i8
	QxWKiB/TEj9olYdNZIJ5hQ2jdwMNPCA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790171376;
	b=x4OFQ7RwumlqNsCuYCgQnHBQGPlaf5oYGywzpMREUihUJWYQbQowZaSJL9euqCjkLlMcDq
	JrFDEaYCxox9Qr86VISStuIEI96NHMmMos3KziSFKdGoaMOWeXCgMi92BSKrxR3vNsU18G
	Lw41m1zwYy5gJiG10un+3mtet0POZEo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MbQYG4T+;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E447C40AB8;
	Wed, 23 Sep 2026 13:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4771F000FF;
	Wed, 23 Sep 2026 13:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790171375;
	bh=GMEn8rMByxkBYSiMmrnZBaoksE1XA7duT9/L5oZzD14=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MbQYG4T+HrUcgGCJB8Mr03WSESTKYUFJ+qZJSTPAvzfVoBtgEeSK+dmKLTgClqmu3
	 Br9W2bQAi2zTh5qhSrSzPZ/4/LthoT+d2d0HCfgeGBe8fCLqVuhUsF+T40JocKxYBA
	 qq4U7Ch/Dng+qFOv7tZUfMZalopkfx2AzXal8G1hyqz7m5WHU4Zf6voNZWLLmFSiTr
	 e11LREhFwp7RHVy01ngL6IiRJ55rj89LCM6NmoVpAg2g12j/v5JnGFMjHN64n0frFA
	 CzXv0dX+0NwVq9yUbT5cdkIew2c1xUy8lJF9pKHn6ThLoEJf1PJ/A7iItNkTaSGiXe
	 O/cD+MI1FqhYA==
Message-ID: <60634ab5-3fcc-42fb-8722-4ba6771acfda@kernel.org>
Date: Wed, 23 Sep 2026 15:49:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/migrate_device: consolidate compound folio handling
To: Hui Su <sh_def@163.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbirs@nvidia.com>, Matthew Brost
 <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260923112041.2103427-1-sh_def@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260923112041.2103427-1-sh_def@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B379EC000C
X-Stat-Signature: 6w43nq9agxpq9s4dz6gpq3hxn7gcwnh6
X-Rspam-User: 
X-HE-Tag: 1790171376-349613
X-HE-Meta: U2FsdGVkX185lUVPzOeo8fSt2RyFktFizSMh8XYo2iV1yWuJTkBY4G0rx2TJpNu+ngPysf9VajY/Pzon3Gz+zU1dIUPEykA8g9qF3PUDqBNTWQwGCSZHKIOaos20b7SaKMFdNlHqfaErzbMeS3PFJfSKoGd+CozGym5h9YAcEIO1sdZB6sH3mE8nGj2Oll9Ad3W2QBzUY52gCI+xo3UPJJdlKrOkP/8eX6lDz0JzZVgzithV5RUoyB7Kr7QosobJ+Pd69qGq4bebRFJkab6FulhrfKE0At36coOWZnznwtotvWTBAw8W2lZlbYdZGKt+S4XKPJL9Xn3PIkaCv/rbwzXwD2fr6gE0HKuIX8kQuyFOW8CA0mvWc70rfpMdrejhue52mPQlHj3Tzez5cHD1GvHSOcBtR3hh15xWrtTpoGY+bvPo5erG6uYsXnerNdJX238Y5sdZ1jqZy+OebG8vgpDdiWs/DULP/hYXkjA5VYcR5y3VpZO1XcVFxBTIOG4i11XQpXEHGoEifWBvir6VzYVl/Jn66i21hiWIoK1D+xCBrkN4gQzpFPtR2WdZgYzP/jgrGhuK1OdE3h5a5czr7AReDfQZBcObCelgTiJvEcbL5RYOCACGOtjZ9JSavDpRMannhwgFVIwXQSEPkFG/zuTddIO1xclObg+6wWCG3EaKqW4rvY4+Pg64h098np/txT+GbYuUORhK5k00voHOH8aqVJ1qXRk1lteyTxMB24OEBlE2kxTFaFI4h2F9ZzJCVAC8zDM/S0WLbNE3CUib0X2o+Nr9Npf4bo1tJprLYIF8gdhmbaWajs8Z804C064MECSjfLcyt5a0+i83MFzqO2K3nm18Mw/S4zTXPeswqVohxi6po5XNk4eyfukjWtahlBqAVj9USLXb+6mOSP1/7vO/ckrfIT6Kqc5suZAbhLUfkf6DLa5q8Fg7PEcavZjA08XU8Fwduo5bPvhAHnj
 0P4hwMn3
 NTxriskQ5LZKCBFpLBMLLoy8N9edERUW6U2ms6qg+6NIi1SbAQuG8x9X3x0PlNdhrT8osGoBUK9cG8yZxCq+qqOZexqUvZvFXpEymrS7TRN0qa8S9apopFqDPrhgUG1ecdLBwY4ya41X0JkojmHP7XkT4YrF7uBZKEXA9fUdXr7He9ss/eWnvzkHVpsgfsewRAign0QF2b3Cw1DiOZ91sCbofSq4U5bSmu9J5gcxLWEC8o/Bczutx6/wzSE7dMiDMMDeKvG5APwB9rnLkbXj9WaHhjazQu4XVqpcFCarCKEWPRNSYlY1SmJjbJHt92GMVXYq1Mg2ek+OOwR22mC8MxONwQbPGKpbdWSbqnFeKGbffhhfEzfWzJdJyrvGcnLkqwrNnkOPkhOMH+ZuOisNpK9QfhqcGdQXpyJeGB+1/NnvGw2JMYcOKOfwPz3GzueAWcKkQwmuj3gcE89c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 13:20, Hui Su wrote:
> Commit dc41e961a269 ("mm/migrate_device: avoid out-of-bounds writes for
> compound folios") added handling for compound folios that do not fit in
> the remaining PFN array.
> 
> migrate_device_range() and migrate_device_pfns() duplicate the logic for
> locking device PFNs, encoding compound folios, and handling this boundary
> condition.
> 
> A compound folio cannot be represented partially for migration. Use
> VM_WARN_ON_ONCE() when one does not fit in the remaining PFN array, while
> retaining the existing defensive handling: release any lock and reference
> acquired for the current folio, clear the remaining entries, and stop
> collecting.
> 
> Move the shared collection and encoding logic into a helper so both
> interfaces handle compound folios consistently. Also use memset() for the
> compound-folio tail entries instead of open-coding the clearing loop.
> 
> If locking a folio fails, leave its source entry zero while still consuming
> and clearing the slots belonging to the whole folio. This prevents a tail
> page from being treated as a new source PFN by the caller's next iteration.
> 
> Document that an encountered compound folio must fit entirely in the
> remaining range or PFN array.
> 
> Link: https://lore.kernel.org/r/c99ca53a-73ef-4a0c-8738-eba1cc89bea2@kernel.org
> Suggested-by: David Hildenbrand <david@kernel.org>
> Acked-by: Balbir Singh <balbirs@nvidia.com>
> Signed-off-by: Hui Su <sh_def@163.com>
> ---
> 
> Changes in v3:
> - Keep the source entry zero when migrate_device_pfn_lock() fails instead
>   of setting MIGRATE_PFN_COMPOUND, while still consuming and clearing all
>   slots belonging to the compound folio.
> - Use VM_WARN_ON_ONCE() for the truncated compound-folio invariant while
>   keeping the defensive clear-and-stop path independent of CONFIG_DEBUG_VM,
>   as suggested by Balbir Singh.
> 
> Changes in v2:
> - Fix the helper parameter indentation and keep the declaration to two
>   lines, as suggested by David Hildenbrand.
> 
>  mm/migrate_device.c | 91 +++++++++++++++++++++++++--------------------
>  1 file changed, 50 insertions(+), 41 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 009bfa8b212d..68b787bdc8be 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1392,6 +1392,40 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
>  	return migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
>  }
>  
> +/*
> + * Collect a device folio into the page-granular PFN array.
> + *
> + * Return the number of entries consumed, or 0 if the folio does not fit in
> + * the remaining array.
> + */
> +static unsigned int migrate_device_collect_folio(unsigned long *src_pfn,
> +		unsigned long pfn, unsigned long remaining)
> +{
> +	struct folio *folio = page_folio(pfn_to_page(pfn));
> +	unsigned int nr;
> +
> +	*src_pfn = migrate_device_pfn_lock(pfn);

Let's rant about migrate_device_pfn_lock().

It looks up a folio (which we do as well !?) to then get+lock that folio, but
doesn't tell us about the folio, but we're supposed to magically unlock and put
that folio on the backout path?.

And if it fails (e.g., folio_get_nontail_page() failed) we simply go ahead and
work on that folio (folio_nr_pages() etc)?

What?!

Now that we have a single caller of migrate_device_pfn_lock(), can we please get
rid of this abomination and figure out what to do when migrate_device_pfn_lock()
would have returned 0?


> +	nr = folio_nr_pages(folio);
> +
> +	VM_WARN_ON_ONCE(nr > remaining);
> +	if (nr > remaining) {

It's odd to add recovery paths for something that is mostly an internal
assertion. The pattern is odd.

I'd either

if (WARN_ON_ONCE(nr > remaining)) {
	...
}

Or only do the VM_WARN_ON_ONCE() and drop recovery, expecting this to be found
early during testing.


> +		if (*src_pfn & MIGRATE_PFN_MIGRATE) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +		memset(src_pfn, 0, remaining * sizeof(*src_pfn));
> +		return 0;
> +	}
> +
> +	if (nr > 1) {
> +		if (*src_pfn)
> +			*src_pfn |= MIGRATE_PFN_COMPOUND;
> +		memset(src_pfn + 1, 0, (nr - 1) * sizeof(*src_pfn));
> +	}
> +
> +	return nr;
> +}

-- 
Cheers,

David

