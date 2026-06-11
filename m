Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BCC4CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 442976B0095; Thu, 11 Jun 2026 07:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F4086B0096; Thu, 11 Jun 2026 07:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E30B6B0099; Thu, 11 Jun 2026 07:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1093A6B0095
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:32:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 942C6405F2
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:32:10 +0000 (UTC)
X-FDA: 84867418020.30.F21294A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id CCF3440011
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:32:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJYjJvRp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781177528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4xTgTbhBDpE6VEa4/wt6KZD5I+oX8VuV/K3HmDwrD/Y=;
	b=IrjJtpxw3MCedwaF08HyB3zDtt/JAWyCalunM7AxX6MTjvqjIP58KxbLZynJsn0f3ENz9P
	1nfrq8SvWXGHA1U9mUmhydsr27UnYWYfbLvslibt2Y1KfyAZ0SLFsv6qwn83TgPOmWC8ZJ
	giGiakmz+GnEBxDCPZCuOnBYa6VzQVU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJYjJvRp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781177528;
	b=5RosoYKiyeOyNJhoc5OTGOcWEn3iobMbrv7v7khRKRRgbkJFPlVquZeHG3/LwRBqWEsspc
	bBtwsMYKM/c2CDWJZAu8S4zq967Yur/KMrBMwNL11f+w4MfBnqfcBlN8YhIil3sofou/Kn
	OnAytFRmIz+bWeI9+7HJ9S6B95H/p3w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C7E260052;
	Thu, 11 Jun 2026 11:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72AE1F00893;
	Thu, 11 Jun 2026 11:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781177528;
	bh=4xTgTbhBDpE6VEa4/wt6KZD5I+oX8VuV/K3HmDwrD/Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PJYjJvRpjJy3Mi9CZIoy5gpn2D0kCw24xmCwJtmkGuON6KegMYfAROnmP+6+09BnD
	 ZMLtTn6IW67urY7nAPp3UnuweZxA7y+WD8XR0/rwj3zWkttEgAZ9uelY0vEP+y1YIr
	 sKB2X6wM/OOm+CdyueVjYiZAg+3Va+QJoFCjy0yBYRi4UPdnnhMUMDjf/sAss8iiMj
	 53fspT7IZhycoDRFv8oYeUMpACgLPMrpBr/Xu8XHH5IjW4PQkATib5Cd+1wlyf9lPW
	 b6rbg2pOyluMo5n3m/uecscaAaHUUTZ7KHoN77qPgYZ7J+pz8wjmhx3OQwZ/d7wUoN
	 CJkSQ+9RZ7Rhg==
Message-ID: <e9d77384-fda3-4557-841e-9e5242938838@kernel.org>
Date: Thu, 11 Jun 2026 13:32:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 3/3] mm: Replace pgtable entry prints with new format
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Petr Mladek
 <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>
References: <20260610043545.3725735-1-anshuman.khandual@arm.com>
 <20260610043545.3725735-4-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260610043545.3725735-4-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CCF3440011
X-Stat-Signature: nn7oeeuchpq7myqurnqk5tp8dkz67m8b
X-HE-Tag: 1781177528-442000
X-HE-Meta: U2FsdGVkX1/g1iB7aVyLVtB9Ri4Rj1lQiGhfR8r7VLFDPOxhTK4m0ONuCUm5OkOgh6mJWA6IMSRyJu82M6NVcKi2GmnR+klvFHC+UvhV+9tEQZdX+Bo++G+qB9EgMl0RBjzy/tgYF66n6hzKdjfZ9J4yex/ba6Wh0p6YSs73swGCMV/5DLMVBUWFsRg3uEnCV/0Sog5WqRVZBaDxQ3zP0KMNHD0O2IJBKZB2aT5AGr8/5Ow0zdtsRBEONYzx/1iqOxdl6SgvMQDeJkVRcNM7V2A7dQwPa6fqFgzmiP4hvYubA8PbzRW1K9xhwGZaNRAltdt7QraI2bjd9mrTZkQt9qdxPbecrcOQBueU2XtAp/x34upc/IrVbFQpkRSj4EK3IE8qCFYTpM/XsU3/IdDBtHvuXrfLebasHsg0czqTw9594UrTmZzqXcovw81qaKlw7MOuCCybhQzsAm0uF91PLcgdFEVBRRhIySbZWQVAvdPZwD19W9snQ9cumAM8MO6SrJ5XOJmP73cLUOvoFXrcPz9lmM89izRQtrYrxJElr1+cSwZLFTQByyK8OnxxpLAd3alxHLiLWHuYF1jhEsm85JtC5tavjOae9Xv1DkAB53qnqsAthJzhDt7QJXIdMTnNumHAKPsE1yrwjUmgwFVLTXAXDIAq4uzKE/cZUeezYS8Sgufwer1skkt38VKYCog7rJ0ZkHXipH7jnSjeIOb98pjVICbgD6Y3eAFC6pKXRT547gkFJF5LUBFKModHcl1GdT83vSTz6UBSUHLDwqkHmyZynEFhlZcDlrrxJnvSuiQ5pbfzByxL12OGmHX1a0e85tlFiPB10540qr5f1KbBamGe1+bu4Y+0QrqwphF5gYz+ruFXVTdFJUs/M9s2S6DTmkl8KNAS6rtC2vEEsiJglNA11subMq81VM2ZfC3OWXKmb1MKDuyv9kFUQ75cKXGOCTftYr3yGDf+LTvfX9A
 oVQA2uBv
 kNmBjkLuK4MrQZJlc/nNwwpPLhdhzwtZ9qovgfR0lBvGMjdfjtuO+qhsX52YMljYPTj9Ew4R2dKIeetMAwm9LB8tlvi7Y3KOkjAuRqQYMaxyROu69MLYBaNhQDjDPJ4iVBJyQfSpHFU49G4o0eJHLlyLciGQzAdQ8gQVp+yORRdXJ+CemeiPFm463s8qZuTfG4Fuwz9nEjq2wEiLmXsI+eZTa3zx7iM7TyQJIuLgOqGcOusw1ZZjFIUwpkjVdGgY4jriwsnTDcJCamUJ/kYY4Fp38iMuyIO9n97C2qxpe+TlVDn2H7jb1X6298Abwuew8IpwxgKfWjYwJS4IW6zaC0E03mOr/ymTd19naovF5IvpuOZgRkrd1doR+0UlZVzCorBAlroDLliEj0ko3Iuh+hvy7W4WXCIn+rO3pu3si0lubHqiMYs2DMqPxcbcGwhHdMNOylmjHGUOS2CU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 06:35, Anshuman Khandual wrote:
> Replace all existing pgtable entry prints with recently added new format in
> __print_bad_page_map_pgtable().
> 
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> 
>  mm/memory.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 86a973119bd4..8a25790f7c24 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -521,7 +521,6 @@ static bool is_bad_page_map_ratelimited(void)
>  
>  static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
>  {
> -	unsigned long long pgdv, p4dv, pudv, pmdv;
>  	p4d_t p4d, *p4dp;
>  	pud_t pud, *pudp;
>  	pmd_t pmd, *pmdp;
> @@ -532,34 +531,30 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>  	 * see locking requirements for print_bad_page_map().
>  	 */
>  	pgdp = pgd_offset(mm, addr);
> -	pgdv = pgd_val(*pgdp);
>  
>  	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
> -		pr_alert("pgd:%08llx\n", pgdv);
> +		pr_alert("pgd:%ppgd\n", pgdp);
>  		return;
>  	}
>  
>  	p4dp = p4d_offset(pgdp, addr);
>  	p4d = p4dp_get(p4dp);
> -	p4dv = p4d_val(p4d);
>  
>  	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
> -		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
> +		pr_alert("pgd:%ppgd p4d:%pp4d\n", pgdp, p4dp);
>  		return;
>  	}
>  
>  	pudp = pud_offset(p4dp, addr);
>  	pud = pudp_get(pudp);
> -	pudv = pud_val(pud);
>  
>  	if (!pud_present(pud) || pud_leaf(pud)) {
> -		pr_alert("pgd:%08llx p4d:%08llx pud:%08llx\n", pgdv, p4dv, pudv);
> +		pr_alert("pgd:%ppgd p4d:%pp4d pud:%ppud\n", pgdp, p4dp, pudp);
>  		return;
>  	}
>  
>  	pmdp = pmd_offset(pudp, addr);
>  	pmd = pmdp_get(pmdp);
> -	pmdv = pmd_val(pmd);
>  
>  	/*
>  	 * Dumping the PTE would be nice, but it's tricky with CONFIG_HIGHPTE,
> @@ -567,8 +562,8 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>  	 * doing another map would be bad. print_bad_page_map() should
>  	 * already take care of printing the PTE.
>  	 */
> -	pr_alert("pgd:%08llx p4d:%08llx pud:%08llx pmd:%08llx\n", pgdv,
> -		 p4dv, pudv, pmdv);
> +	pr_alert("pgd:%ppgd p4d:%pp4d pud:%ppud pmd:%ppmd\n", pgdp,
> +		 p4dp, pudp, pmdp);
>  }
>  
>  /*

I like that! I guess having per-level format identifiers is the right approach
given that we have per-level types.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David

