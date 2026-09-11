Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B93B8C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 18:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A176B0092; Fri, 11 Sep 2026 14:01:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F1EE6B0093; Fri, 11 Sep 2026 14:01:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0CC6B0099; Fri, 11 Sep 2026 14:01:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F08596B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:01:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D92E91402FE
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:01:55 +0000 (UTC)
X-FDA: 85202249790.18.7B000C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2C39580004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:01:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NAoHBUUC;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789149714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qhIWTcm0FYDnzyosqjyVmJ5CwqqhLKGSIdHrmte54X4=;
	b=QViXbr04ZOlowM54GmVDaElz66ncaR9JXzpLUJYDOC9Y3Igv2etjRJDfkmv8IWRITGOouw
	F8lBiNhWB9OkDJheq09Kip7aKK4fBLp7KzrbbBOTD7KVvCUz1Ypx6Nf+j3qG39n3/sKolr
	JP84YYzh5FR3ZKWMCryE+g0FrZFeszw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789149714;
	b=N68RoGsh5aMSm87IwZSpk6/CjR+I/2LtvfFfbrG8Es9k0dn2SdiG0gk8Nf9jli3VyOoC6L
	HPNPTZqC8LTeIeqN0eAJEroSz0t5T/qzLhNiB2G3GWnmYVechfDl2eewiLRnsPbQsAuOXF
	nTzrHRPXtlcftgReDt2rSSvyT5+ra/I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NAoHBUUC;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BB7860008;
	Fri, 11 Sep 2026 18:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9287A1F000FF;
	Fri, 11 Sep 2026 18:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789149713;
	bh=qhIWTcm0FYDnzyosqjyVmJ5CwqqhLKGSIdHrmte54X4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NAoHBUUC6iTOhnfEiRIL2ybzUIvjYJUlufJ6P2HXRugjhUvN0oxbF1Rz1J2+UVesd
	 MSwhOvljnoikab8xv4GX4VgZJF3oY+jtQfYnKrlwYz/QhLJpTraFTE/LeyKhiHGpn9
	 xNzwctdLeHSap4lro0YBpoKyHLYc5FumKwa1e4HDWvhGykBEURMyMj6ySXwOEFY7wP
	 idWqFcZgUE01OaMdEebblpkci77+WDc4G4qjLUh9nlqyebO5HzerVaHmIkBOd8NRK4
	 sKqJlmoX4ZelnHyyToErLTLBswdG823/SOgoLLThHRV8K4ZmOWwM3dUWWpOTewDYe4
	 sdSuyGymWGzVQ==
Message-ID: <664b3576-05a9-4c49-99c6-ba0928b25300@kernel.org>
Date: Fri, 11 Sep 2026 20:01:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: consolidate compound folio handling
To: Hui Su <sh_def@163.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Brost <matthew.brost@intel.com>, Balbir Singh
 <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260911061348.2869524-1-sh_def@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260911061348.2869524-1-sh_def@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gnjan3r1dno3wa7qmnqcn1ia6rygxsh4
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C39580004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789149714-492088
X-HE-Meta: U2FsdGVkX18GaSPM9C2E/HrqBBcjYG8T6Khm2QMAZWLYVhm9qMdxQ6s/yGzsDI1mim3E98o/1xDwpZKRl8reE4KloyIFN2SVZXOa2ifuodFSIEXjbPDTeCTdQ8Xuf1UBpYYwT3lpzWitiszaaV5LOuLWt++vlk+O/IfmQBQSmr4TDGBWNPAcLRvDvbG5exba8lS/L6R3hxys24xT7hviRweVggf4yGQI521Koh0YtR5vdReqeXzacESv31WRRw6EP32lp/fIC9ogGgDlHThhvk3ZKcUFm1PBbHoux1j/pFrHMQ1fcHW+Jnhal5EYBMwql+GUuXiZv2R15PhDXlXNJw5M7QuibrHnVTipFuBNRxuhIJwX1pXcjJ6lOubpK0vgOPwELazXRIYRTmtyRHN5/flCmaD2HiDW74x940TqucsnARMiibVhfn2Sxyi05tYReTah7qzL5HeBhFO56GBqhooRFvXN7eCHU+Kpsa5k+6hCGNry7ly95eCeYbWL76lBVE25JT0Eev4BxZGsT1hZw91jbUbOyaXiWGjX9CF3ilLoc8O35wNMF294jfiH4+mwnvwcAnOx8cAw43q6I/nH7kCAw8RBsxP9f+qm1faVs/jNJYkIDQJLOCsJhR+w+5ZKfu1BgRU9D12AuZWCMDNEjNzF+V6lkYOy7xKEj0YHwUn/R0f6u34qKywDgRtmasTqfqDAI4obCWraw8YXj8TopylfRep2sQd8ZZAhqR5YM96Fm6aqmv224+iX0HwzgE6hPT0qXT6YSTOYk1V+xyeZ2+V/B+Vrqcn170a+lpLaBRmdr1ucTTR9sp8eClJYjU/vghfeVMUTNbPyQ692EykhfzGX9yCmgITlnvUXr4AQW8e4CVv33LNQmviQcJtJ6bCUxouYXcKrjfGYpvXzi4GwLiIj7e58xZZFrKKvHixsYAffkMaNWIxM2l1ZocWwQlTaWIoFcfCxpIdA/IuqPda
 NnrslZmy
 TU4t27fo1SsPgKeXZemndgSsDsH269xiiWl8PRYeed2JkC9wo6NXDBkiudppN9T0gD3uwM1F7tqAX8HQm49crQVLG6+Zsq3yF8P9WFNDxxW2OBGl0QVQjOgMfsq6JU9xMGqjJxfWntOhQTx2FAo9M2PeENjaXhDZvuUpCyVfT+aFdPjO55ohqFriCwipUhb9PzkZyUGMlMMGs7/Ms5iRDhnrMlRybhecer+F7q2MxafYe6KyBi9AT2eiTvgy/Xldi8WqtbIoy2z8PfFRnj8QvkPsTrQ46BgiDySg5xy4Gv7Dh3Gcdn+Cf+xCyNlegsoKBBVajhrXEQ5Sz0Opzs76poRRKiJvLRcqtnscW+vN9djra16Srgvr4vng9ErGu/azR2KBBcmIxD4Q5mIz/YEf2zZw9B0sKxV2IJcp4M8Bc8ux4bBs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 08:13, Hui Su wrote:
> Commit dc41e961a269 ("mm/migrate_device: avoid out-of-bounds writes for
> compound folios") added handling for compound folios that do not fit in
> the remaining PFN array.
> 
> migrate_device_range() and migrate_device_pfns() duplicate the logic for
> locking device PFNs, encoding compound folios, and handling this boundary
> condition.
> 
> A compound folio cannot be represented partially for migration. Warn when
> one does not fit in the remaining PFN array, while retaining the existing
> defensive handling: release any lock and reference acquired for the
> current folio, clear the remaining entries, and stop collecting.
> 
> Move the shared collection and encoding logic into a helper so both
> interfaces handle compound folios consistently. Also use memset() for
> the compound-folio tail entries instead of open-coding the clearing loop.
> 
> Document that an encountered compound folio must fit entirely in the
> remaining range or PFN array.
> 
> Link: https://lore.kernel.org/r/c99ca53a-73ef-4a0c-8738-eba1cc89bea2@kernel.org
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Hui Su <sh_def@163.com>
> ---
> Tested on x86_64 with KASAN enabled:
> 
> - Built mm/migrate_device.o and the kernel successfully.
> - Ran the HMM migrate_anon_huge_zero selftest; the private-device case
>   passed.
> - No KASAN report or truncated compound-folio WARN was observed.
> 
>  mm/migrate_device.c | 90 ++++++++++++++++++++++++---------------------
>  1 file changed, 49 insertions(+), 41 deletions(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 009bfa8b212d..c57eadea6565 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1392,6 +1392,39 @@ static unsigned long migrate_device_pfn_lock(unsigned long pfn)
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
> +						 unsigned long pfn,
> +						 unsigned long remaining)

Two tab indent please.

> +{
> +	struct folio *folio = page_folio(pfn_to_page(pfn));
> +	unsigned int nr;
> +
> +	*src_pfn = migrate_device_pfn_lock(pfn);
> +	nr = folio_nr_pages(folio);
> +
> +	if (WARN_ON_ONCE(nr > remaining)) {

Just to be sure: there is no way we can currently validly trigger this, right?

> +		if (*src_pfn & MIGRATE_PFN_MIGRATE) {
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +		memset(src_pfn, 0, remaining * sizeof(*src_pfn));
> +		return 0;
> +	}
> +
> +	if (nr > 1) {
> +		*src_pfn |= MIGRATE_PFN_COMPOUND;
> +		memset(src_pfn + 1, 0, (nr - 1) * sizeof(*src_pfn));
> +	}
> +
> +	return nr;
> +}
Looks much cleaner.

-- 
Cheers,

David

