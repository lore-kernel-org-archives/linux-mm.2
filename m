Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83475CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 07:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98B96B000C; Thu, 27 Nov 2025 02:22:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6F9B6B000D; Thu, 27 Nov 2025 02:22:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AACCC6B000E; Thu, 27 Nov 2025 02:22:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9CEA16B000C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:22:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5AEF01A08DE
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:22:35 +0000 (UTC)
X-FDA: 84155544270.27.68F5779
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A553D20002
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:22:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ummURYfV;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764228153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JyOSYaV3HR0mOQ5qViRcqrRjylJ9Jp4NimNB5sCSqeg=;
	b=C1Pmf6+6p8+U9IyP1y3Eyk4XvmkruRzimvD4oNcFWJyT76pWy0UiOK1cQadpep5PK2xxGP
	KagQ0/dMaqCArR64Egae70aSZ4ws57+vs3CPeKj8UCxLUPQj/f9nwyqJhVh6+GDOq6VH1W
	hWGmBUy64baEhIeZZ+p1haNauZXI+48=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764228153; a=rsa-sha256;
	cv=none;
	b=wP0kgXSk7p2TlCazLepvcLx8xsdKhqIOYXN9gK4HR2/LjCFkvuJLa7xfbrLD/jCWGYoNSp
	sxeWp2sHdrG2rNwAygz171fwlGGKsljsEWeTKa+yhr4uys6zo9S5400YDruMIb6QcKK7sr
	7c86wGgNIqS6CL5FBDTPjb7T4VZ7kKw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ummURYfV;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B93840AE1;
	Thu, 27 Nov 2025 07:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71AEC4CEF8;
	Thu, 27 Nov 2025 07:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764228152;
	bh=x8BcIIqFuWD6WHZY0VO8gn7f0HPzdptjriFq9pm1ItU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ummURYfVpxCLKtAUdQ+TGYGwj1A9UcKwNVl4FvUJVYRsnA6O5v0QuoE+Z9+TAKJ+8
	 RhvE965NbhnNQVr7W8HvkWKh/+EqcdMhdtIAjogeQvaEVf2IWieJrXGIk0kVKbnmmi
	 X1/ahU/8LDhwzrRBifuiFE0fs+XW5icTw3zDi/S5jjgj5Dk2OkOmIGWpRwaSJugNai
	 on5Zl6o1nReCCCx3UQ1xkjYdCaYPG/0SJ+TMfdy4a6ZVA2T2N7B76Fg4T1NmOnyBQx
	 mCskWO9lwvLAsEG2GovCQQLJAnHqPEql2bd/mx0uGazy4rBGW+n/zalod/ZmU907l1
	 A+8z9aT7cA2ig==
Message-ID: <2fffc8d4-6cb9-45bc-99bb-b87f580aec42@kernel.org>
Date: Thu, 27 Nov 2025 08:22:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: use end_folio to terminate anonymous
 folio remapping
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251127022436.20734-1-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251127022436.20734-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A553D20002
X-Stat-Signature: hxptcgbuwkjt3c43oa84uy7i3fued5z9
X-HE-Tag: 1764228153-567176
X-HE-Meta: U2FsdGVkX19JY01q/7uVV895OQB/5aoD0oue4AtO2Ixivl+zN/xeH5fE5lBMs7VEU7anF6JsTCQ2ZQ4A4KEetCtoPXW5CNf5Ti4/SrrHC+s33cEeU16Sx4YHH+kmFZ+qGikNPBXml301eQalXprKZ/SuyJ+oUYy0ZLpysvOzcL1tH2E5GUX4r0RjRf/ox8ACpkexoXR5GW5vu0hvNm3lkxtWDtQAkzwysWUhw1aLS7p5fq2wNWDfDRL5FotetI2rm0R/w6VrkFTzCtLNkcerB76qoDD8cIOw2zIp7exrVsOQBeEpDoWksIZOcWec0fq2+PrarP98yLFfXLGEUfZKumDXMDY5FeccR1+7qiXq9ptOgk6Ebs5WCVOG6X2J8GIpreyAnNutZK1l2u7TmIFn+PYYX1jktCEYpkqvK7LrGs1IcJMnJvtyZTq/lOKtuuLPXfyKPRUKWXSN6Vq3Y7TRA7eFIXipNjrZw4VGD+OvZRtlEwlM/pVAqbo9fYfrYXw1O5dz9pKZmQvEPdjHiaf+m6Ie0S77GjZ4e3/16NHUYBZJAgeL2t3KCRWmahLWYiHyNDf5Egrir1sgJEuCUE3PYuxjmIyx60MkMtje9tr92zd7htKUAQnkHQ0J60+FI/Zvzglm1PL2fYZOt2bOVzZ6sQ+RHCwNOqMp+4/fhUls8OfbcsVvLQ8LTFlPhK7qIUmnpMkVqFlkOK945DYq5X5tI8/T3FPL1d2AQZzvAcOkyCjR0x9TY2Qjvg5FiKIykpYqA5h0y17drZwW5aJ34wO7W8UCtn92Ae50wcSqQZE+s1uGEbXM7DusKKUcMqHAE0cB1taV8jgT7PGs3mXFwul365FXdVShIkHLQLdCakDD/hZbofOkYXskoFJhq5nhHGvN8hUzlTVyGN3HtlFBhzaXyGldDNp1xuOU2rQqXMpB/OU0hBPGWB6weChAls5aN3uFcOaO2wWzZweufVl5WNs
 Zv5cia1X
 c+TZKqgL+nhmK257nwD0Kbymb458qN2ePlHmcKE2valu0lrcZbUpPxNjqZsMA9rP4UWz4iKSF9d3sYYFSEYsLZIVNkbN6zsXAXsrAZo3S0k8IDhtaoGTVlT3BQjCQnbTZ+X+YOPI+q/I2neg0Y28WIyfSdYnmqoJeiilSKbrkjn4JT4oVYEPlMRKnGU4uu4mNH0LOiJIcLYeHn2lqUf13GawTcGVS8jSjtDMCdY7RUqvfMxFg/8DKBCm+lywf59aNaU0T7FazJB+Y7nTENgxkaeRFMaxHKHDw4z4tp2rs1IgiOPHvuJiMjVq9Dtm5OITCkrqiXLSS78fucI1Zu6o4ZzWYq+vOS0Ty95PKKde6oqJWzh3IBurSXktoIVnY72UgmtLk3P6xafUYEnc2yyYni6p5FRCWZvJJdTCtJsPmU1Epze4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 03:24, Wei Yang wrote:
> After splitting a large folio, it is necessary to remap the resulting
> anonymous folios.
> 
> The current implementation determines the end of the remapping process
> by counting the number of pages that have been processed.
> 
> Since the final folio in the sequence, end_folio, is already known and
> tracked, this commit refactors the remapping loop to leverage end_folio
> as the termination marker.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> ---
>   mm/huge_memory.c | 14 ++++----------
>   1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 553bfa961fce..afc7b2f91e99 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3414,20 +3414,14 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>   	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
>   }
>   
> -static void remap_page(struct folio *folio, unsigned long nr, int flags)
> +static void remap_page(struct folio *folio, struct folio *end_folio, int flags)
>   {
> -	int i = 0;
> -
>   	/* If unmap_folio() uses try_to_migrate() on file, remove this check */
>   	if (!folio_test_anon(folio))
>   		return;
> -	for (;;) {
> +	do {
>   		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
> -		i += folio_nr_pages(folio);
> -		if (i >= nr)
> -			break;
> -		folio = folio_next(folio);
> -	}
> +	} while ((folio = folio_next(folio)) != end_folio);

Rather ugly.

Nothing lost by just keeping "folio = folio_next(folio);" in the loop 
and focusing on what your patch documents.

But as Lorenzo said, the time for such cleanups is after most of the 
current stuff was merged in the upcoming merge window.

-- 
Cheers

David

