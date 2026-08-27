Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95E27C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 15:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0996B008C; Thu, 27 Aug 2026 11:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787C26B0092; Thu, 27 Aug 2026 11:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F106B0095; Thu, 27 Aug 2026 11:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1716B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:14:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BEB33160455
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:14:48 +0000 (UTC)
X-FDA: 85147396656.22.761A489
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id CAB8620003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:14:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m++v6WxA;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787843686;
	b=0H5i1wXB4aExAN0itQuqGoCOXLcYTvdFiT6YmEVOjNm6xoxJJ5ZcHbru8560KjIuKDJfUJ
	AUaKoOsWoi16MuN8/nNDNUpu6ldHMcnI3Q3FQspLpiFvR7jujyv2B1bJMC3uRa6c1JxyE6
	tSrrYcys3Cxe/nmYQ1ZsW8lDML/9sn0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m++v6WxA;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787843686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grSlt1xNPyLL4tvyZuMrw1Jdk2v1EacQiuP4ozz0DGE=;
	b=Mx1ca4by1MzHjDpUVMJfDdyMI0fPAZ4kYLd9IkTkxKX3IBOu0zizdzIz9uv9zD4WgJwwLr
	Xrp/tBpn1egmUXQpMaw4esPy3bWaVpUYXviE9CKHNH+DH3FXeZlv5GhB6DFE3X/I3dpYDQ
	ff5uiokRijZpQYsS3ZE/lZMumcEFBfE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E5938403E8;
	Thu, 27 Aug 2026 15:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DC11F000E9;
	Thu, 27 Aug 2026 15:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787843685;
	bh=grSlt1xNPyLL4tvyZuMrw1Jdk2v1EacQiuP4ozz0DGE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=m++v6WxA/LOvDEGGypW0SjlIhjyDpeNH4FgOUZVSECUZyEPqIrL3aJzZUCk5HQBio
	 q8miAEer7XWaO7Icx7tSUxgUeD/qmK8XunegrmDOkiO+ywOSXdWOe9lDyvRPSKmw6h
	 6Emxp+rcve0hP/PtpjlutVlCWVdF1hzvxtvnADYdP5Vp2ZXIjrchA2Quj0FNtNbI99
	 rTTEPLM90QSiYOHtBmQbl3scHCARoDWaVwGw3V+xuoxvebbSAuA0L1/oeMYEdbNC4f
	 MbrdOwinoGbZx29qqL1DGdRWrzHcN/Ev1D4fzE1mPC46Pg/2kAacNyKlZhXjJa4b4W
	 nfCknChKM+o9g==
Message-ID: <4ead5df7-f000-4087-83e4-13aae036e0b7@kernel.org>
Date: Thu, 27 Aug 2026 17:14:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate_device: avoid out-of-bounds writes for
 compound folios
To: Hui Su <sh_def@163.com>, akpm@linux-foundation.org, balbirs@nvidia.com
Cc: ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260817120758.669807-3-sh_def@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260817120758.669807-3-sh_def@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CAB8620003
X-Stat-Signature: tnjtqu711kuuktaanj6ma5zp8uezk6g7
X-Rspam-User: 
X-HE-Tag: 1787843686-834200
X-HE-Meta: U2FsdGVkX18zTbXJ4kTVbYzcV+NDdo6xiprs6xZG04BEoEbZbmOOxamCfCs2yr/WwUguoGqF9KKo7RvjxVRe64HZiiag2cXfoefBeH5ST4/Yl5H+iKmVJiU8CLjd0+0p/odtgJo5na5VkoLX9koCyVtkZQxQme9yPRVDQp5X0RsmHeSIHQDuVi7CJJt+AwbnTrRWga7vh5cl+6X5jD/mQXpfuD1IGtcD2ILMa0enGlXpHwRQcAU4QuNr8k6GYVUw+o36ifHYq0iOZ1/i4iQ06eUhG/QKoXUuqbgxX0MyhZ33+SlLL1Px9DQ5gJkXBHcwruqlQY0/3eD3uUyTNsG75xFY4xLoP0sv188iD++lFZTambV/VS1MbdxCOhGwJ4fuEmO4Wj4qNmRLXRozvW60fwjNVucrl0bgX3ZrRWcGluhKFuWAqeOm/YpgdmtrPNmfho9p5IGNNbElvZr9GeDrnKEhhnjN2MW+BDn3SIndNbesozP25LgrPOPsdnKk6hLkE5tgvOKgcK/l019qSMoq7y6TQkHTVSNNrYgfzMK5Dd0S9/P/KV+jvt2oLCWDDWkxh2QMdllzoXKgrarA2EoXDB7BmgGyteSGX00NZDDsuR9vm85i8fRYs4GToK+hVeTvQZXw95OGIyximS9FaZlpNiXtIjPA3LRrt1GAdQIq2SUonTi2avBOxdD2tzOsVrWb9F5ok0vhAhGjc48STwoLEJ0vkFm922Qmeysn6FwK1Jc6tNJ0zwjGJ95UCrdGDr2QB35mKzyrHy9Otv7cflL+3+6/2yUrk+5fzbHg27J8LpnMkU9RRmeODp2V0okLYvQOnuyD5ViZPBrRKr13OS6vsnJSFPvwVHrdy4QsVIf73MuUpCG+yYEqzrxX2YY9a1IaTsisKcZ989lBIBSNcY3/oS5RoP8GaM8CnQ5NYs6Q94zU/hDY7iKqSrletzFp+lyji2SK0Esa+lqhSJAgy8A
 r9+Kk2sY
 Shtfil7kza3HbAQKHBrBFeWb4JwgVLhr9wEBJO4bWCzFhh2bKRW2i7HIlpWbik809X8ScEOxEdFlYJGjVg8NJS89RNsktHhZNwkIHDe4SmmTQ9a7lR2f+A5iaO2m+8Uui3zCBoje7DoV0crMqvpOqw19b0PAfE0Pec1xao2mcj8XqYdQFvYDDxeAhi5MfcelwL89A6RZzlzkyHPsvBeKVh4od4ZZWQUjU1ni8d99L1TlnhwTXJulg+LUBNZ0eiMfYOhbWsHqzuYwID2ACByP9gcU+Lr/qhfSL46V4O8PAxeTs2YkOsmK7dgJs3EmhwJ0DswYIXKeWBTALNDWOzOcOVbD7FUwGdzzvPVDiKZzoMwtezK6K1n/QCoNqG6ktmtDYa0G/j1NSc9WPNtPbOuGkIolzbCUADRHZ3uyNWMk4ZQCH1Snhxk9HuCqFI5zs+r2/xKidkghSm3U/2VQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/17/26 14:08, Hui Su wrote:
> migrate_device_range() and migrate_device_pfns() clear the entries
> following a compound folio so that the PFN arrays retain their
> page-granular representation.
> 
> If a compound folio extends beyond the end of the caller-provided range,
> the loops clear all following folio entries without limiting them to the
> number of slots remaining in the npages-sized array, causing an
> out-of-bounds write.
> 
> Do not proceed with a compound folio if its page-granular representation
> does not fit entirely in the remaining PFN array. If this happens, drop
> any reference and lock acquired for the folio, clear the remaining
> entries, and stop collecting.
> 
> Observed with a KASAN x86 QEMU kernel using the HMM
> migrate_anon_huge_zero selftest. Closing /dev/hmm_dmirror0 after
> migrating an anonymous huge page to device memory exercises:
> 
>   dmirror_fops_release()
>     -> dmirror_device_evict_chunk()
>       -> migrate_device_range()
> 
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Su <sh_def@163.com>
> ---
> Changes in v2:
> - Do not partially represent a compound folio when it does not fit in
>   the remaining PFN array.
> - Drop any reference and lock acquired for that folio, clear the
>   remaining entries, and stop collecting, as suggested by Balbir Singh.
> 
> v1: https://lore.kernel.org/lkml/20260817074350.442493-2-sh_def@163.com/
> 
>  mm/migrate_device.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 908d2d4ec43a..69b8d0660bab 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -1400,6 +1400,15 @@ int migrate_device_range(unsigned long *src_pfns, unsigned long start,
>  
>  		src_pfns[i] = migrate_device_pfn_lock(pfn);
>  		nr = folio_nr_pages(folio);
> +		if (nr > npages - i) {
> +			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
> +				folio_unlock(folio);
> +				folio_put(folio);
> +			}
> +			memset(&src_pfns[i], 0,
> +			       (npages - i) * sizeof(*src_pfns));
> +			break;
> +		}
>  		if (nr > 1) {
>  			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
>  			for (j = 1; j < nr; j++)
> @@ -1434,6 +1443,15 @@ int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
>  
>  		src_pfns[i] = migrate_device_pfn_lock(src_pfns[i]);
>  		nr = folio_nr_pages(folio);
> +		if (nr > npages - i) {
> +			if (src_pfns[i] & MIGRATE_PFN_MIGRATE) {
> +				folio_unlock(folio);
> +				folio_put(folio);
> +			}
> +			memset(&src_pfns[i], 0,
> +			       (npages - i) * sizeof(*src_pfns));
> +			break;
> +		}
>  		if (nr > 1) {
>  			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
>  			for (j = 1; j < nr; j++)

The code duplication here makes me angry. :) And using a memset on one branch but
not on the other is weird.

But is this the right fix or rather what

	https://lore.kernel.org/r/20260805231041.3791771-3-matthew.brost@intel.com 

tried? That fix would also need a cleanup but seems code-wise simpler. A cleanup could look like:

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 762c5cee8fecc..480bf59bc2425 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1419,10 +1419,9 @@ int migrate_device_range(unsigned long *src_pfns, unsigned long start,
        for (pfn = start, i = 0; i < npages; pfn++, i++) {
                struct page *page = pfn_to_page(pfn);
                struct folio *folio = page_folio(page);
-               unsigned int nr = 1;
+               unsigned int nr = min(folio_nr_pages(folio), npages - i);
 
                src_pfns[i] = migrate_device_pfn_lock(pfn);
-               nr = folio_nr_pages(folio);
                if (nr > 1) {
                        src_pfns[i] |= MIGRATE_PFN_COMPOUND;
                        for (j = 1; j < nr; j++)
@@ -1453,10 +1452,9 @@ int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
        for (i = 0; i < npages; i++) {
                struct page *page = pfn_to_page(src_pfns[i]);
                struct folio *folio = page_folio(page);
-               unsigned int nr = 1;
+               unsigned int nr = min(folio_nr_pages(folio), npages - i);
 
                src_pfns[i] = migrate_device_pfn_lock(src_pfns[i]);
-               nr = folio_nr_pages(folio);
                if (nr > 1) {
                        src_pfns[i] |= MIGRATE_PFN_COMPOUND;
                        for (j = 1; j < nr; j++)


And as a further cleanup, we'd better de-duplicate that code and possibly use a
memset for clearing, getting rid of j entirely.



-- 
Cheers,

David

