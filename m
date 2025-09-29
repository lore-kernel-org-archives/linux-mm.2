Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45AA1CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 11:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 785828E0018; Mon, 29 Sep 2025 07:27:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7362C8E0002; Mon, 29 Sep 2025 07:27:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 624CF8E0018; Mon, 29 Sep 2025 07:27:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 518188E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:27:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F232257021
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:27:33 +0000 (UTC)
X-FDA: 83942062386.21.C318CB8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 90A3FA0008
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:27:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZAks20Wj;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759145251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bUzzR4h35LcYPP/dUTPoniliXa+mo6qwLfSHPwhOPz0=;
	b=OSo5Pfdrho8+zlcbgaeHBeoQNFNAbv5NJsz4zV05hTyDf1ClaSx9MhxEdlU8MoedLtadAw
	TMlrPLkjLq0B3h0l63RL59dwpNq7euNMtXFdnmrftrXfoSdFkbihjO/AZgetXfGc+rNc+s
	hRq4aw92E32OZJ6Bb6kg2/UlyuOMw1w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZAks20Wj;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759145251; a=rsa-sha256;
	cv=none;
	b=kN0KShp3Kqq4OsnWUzuuvMUySuEpPjsYTItdo9rbN46vWgwVw+3A0npdkkYQHGr1jj1R4D
	fEULsA8zhNBqqOSd3jSZmxjSEWGzraSdYmZWZF9ttcbqxVEtPpVeHqpVOmChebyXnhU5Vj
	xEEOHkhpYRpor63rSBPcfey7fxoDUZ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759145250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bUzzR4h35LcYPP/dUTPoniliXa+mo6qwLfSHPwhOPz0=;
	b=ZAks20Wjcpy046FEICo0DNOth0aoL++Yeq+xlgFVh6Q3rQlBHzhssqTaoF9Y6lBa+O7Zvp
	NRvD0nRe5RuzUf7VzZ1xNoAkfye1VGp3vNnsf2qNWZdWaJiH7fmR9GObsCwbTTymVPtt4P
	1yhF68L5gpL46j/Xabq5Xtizv/c7jFw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-a7QIup-wN8-pAbqrau0Wkw-1; Mon, 29 Sep 2025 07:27:29 -0400
X-MC-Unique: a7QIup-wN8-pAbqrau0Wkw-1
X-Mimecast-MFC-AGG-ID: a7QIup-wN8-pAbqrau0Wkw_1759145248
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3f4fbdf144dso2762191f8f.2
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 04:27:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759145248; x=1759750048;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bUzzR4h35LcYPP/dUTPoniliXa+mo6qwLfSHPwhOPz0=;
        b=sdYs/wXMgc53fNQjlL2fI9G1R8QmdhSiz7McHlEP92PDNOdSnVGy+GnkvPUlCAhmdJ
         91Xr6ekypxustHx0rZe3HiiwbXrn/L+fIU4rOFAb7qXcexQKIw2U2y1ZNPTFiOJNSfHF
         aoXS3IpbkpJY5aWTuErkvvjvG10/zoupHHLF6MgA/iR5vdWjUk7wEauRrplMXD1SLSGK
         79rioRJgOEgXcKG2fuNdAP8WQaFZ2gYZee9vvaOwXFwaJgWbGVz2bRZ9OLUz9adKFgFO
         23pGodGXw5gymMNSwJr03qFWhpMvuGz5N2kBpqaxnff5Y5QPtwHHzkICZgKwC5AwdeIV
         2tCg==
X-Forwarded-Encrypted: i=1; AJvYcCWyRQU19xB3SteAcuV1jaWtSfd04tH0ymr29LmlB7pW25UNXyR9Fp67hyzaxHB21zLFxVOd6Y9isg==@kvack.org
X-Gm-Message-State: AOJu0Yyzbsj4PbIflLOMepvL1N5NQVPao1WHnjNRlamOUS8cJMG55PSN
	gs47GMIOZoyHtojU+AGHwrCke2a11BV9K8n62zT8PwlIEAPaw+nWheEZho2pK/1rrO8CO14U0Ul
	andvB+LIV8mUslWRdALZ3XES16ek6Pac6HAA4rd2yCbdiUOUVH7GF
X-Gm-Gg: ASbGncvegX7M5AwpKKrlD50xW84YBrmx+Ir4oUSzD5VKrolQZAybUlTU7ZTh/+ZhTdO
	Xx92pRBAeLpi3hpB102m2+uuBewe6oJEMNSdAABPjLbeubz0J9FRQC8LD69OFwwYciuiUpZqfV7
	KN+gj2fo2ruNvElDkihHz2O3/WMk7lNUi4Mzg0+2qwjBlOhXDF8cuZvEsdaYr0Cuq4xgcj+AL1U
	67s/WrDMb7pGld+8J9aj3CfVtQpq7blVYJwu3kA9NOBf90AS2o9uPOSwU9NFVgGn0DBnOvo/nXA
	NTbHV7xDaV1NHDAIFZV1asH4PyP7JJvlgaxGvb1dEMlnA+DpoMw/WyanKShw0IRi33jSYIuV2zh
	p1Lx4LJRK+3MQDmC9tGrZQ8HS6KKrU7FBJVSoC8KHGkIC0MypQWWA1PmnuTerLBDPnhh8
X-Received: by 2002:a05:6000:2381:b0:3ee:1461:166c with SMTP id ffacd0b85a97d-40e497c34b8mr16195946f8f.5.1759145248181;
        Mon, 29 Sep 2025 04:27:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/tA9KRR768hrK7BG/BIDGLCJ0HvflPjA0QZhOedUiyGROdESFV5RXXJc4fB7bwIlLev1Qyg==
X-Received: by 2002:a05:6000:2381:b0:3ee:1461:166c with SMTP id ffacd0b85a97d-40e497c34b8mr16195914f8f.5.1759145247758;
        Mon, 29 Sep 2025 04:27:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f39:1500:c90f:7794:3c33:4164? (p200300d82f391500c90f77943c334164.dip0.t-ipconnect.de. [2003:d8:2f39:1500:c90f:7794:3c33:4164])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72face8sm18055901f8f.5.2025.09.29.04.27.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 04:27:27 -0700 (PDT)
Message-ID: <ef3ebfb1-83f0-4a3e-a8a0-ac0ba729aae5@redhat.com>
Date: Mon, 29 Sep 2025 13:27:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/thp: Drop follow_devmap_pmd() default stub
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250929104643.1100421-1-anshuman.khandual@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250929104643.1100421-1-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2hm4ugZOF-KbnaOmG-oFWBRifii8uGkBpXOZKMsRQjI_1759145248
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 90A3FA0008
X-Stat-Signature: pjx3matoxd4frxy7a8csjt4zf6dpszw6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759145251-490794
X-HE-Meta: U2FsdGVkX1+F5q4pfiQJ3k2zhiV4y2qLMk17Lag4aXnGOE5rIUCT/dD+UtdW33sTOobIg6jYPt013BNltO/4FW+/+67vFe4vobtb0/rKMg8UelLLKvD6qtaohcTuWZNKcNbXZKwZ8yiyuKHRNuclf49v/UFBM9CLLkuimAo8klbwJLB4WJxf6TmB1IAq7DzDN8pD6Lr28OdjofpfRUpYb988smCvjrGy8veAuvDEho8NjuRHbNdCShOOqMP5tj8uFz4Dm0nMqWKZcjjIfAjtuIn75Zu1iBNLTmmuMn098PgYceoj3nc3i1Qkh4WLF8ir92/qy3RA+LiDdZkaVnmBgFVcNTGXgWxIWv93/trO8z53bODDn9Ey+y2t3OfIZZd0/f2bd7vztEBWljCj8UNeHr9PpGaQH9aajsEDMqew7+vrcYruPYiwpqThabN6srz/eYSMXBewTYNg22LXYV9Z07fr4GYDV8kPrAYrgqeunVobHST2IpHpCxR+7kEEQiuT2QrMio2aZ2oLjwCsQ/3EC1ItZZJhY/KZDNP4mGjuVwFtLP/aWjS09y49K50tK71/R60VwmiDPlNDBp9GIUWGiWzYrcl0iJ5rjg6YFuJYP5sMnQT+HhkGiB2SAfwLJSzhTvBQbe/GY+rPOdX19aqRJ35cLZLZdnv1XHiViTLWxtElTU59vPLFJdUtxTR62Gd7eTYquBbD2El5dLYHOgFEQqGwf0tgDdd64fCfoVhO3KMgD+DC5NP0Kgp05Bm29dMIOYgdxR7j/E/D1JTIHkAAE0wadO2DdveBJswd1RBSuvH0M2lqTmgrDFRozFjnf0cvF8TGDRPfqJwSOxdWcdMP95AMrkt467fYRfVNIRVzRpGVqlH5qx1H0GFXe18w6j1URnMfBqPfgLRtmqAF09BZtPnF+z98KUBaQzV9GZdNme7AvOgo+NIJ/9CFvXbJ00gCUhfPjKHjV6ZLmQ8kWSY
 rEyRNDDN
 KzMrqKP7vjWehqvOIlo7QF7zG0+9o2IWeypBtb1V/vPQ8yZ769ZRkm/A2sL1X0/qSwdM68o+HZnhrRfZE9eSl4y716icFmTMCsnLlnXCauvaSvMUvYofz5bhPsIDFbcDspHHsP1S/4yFnxT+YoR9bZxoWBSqMnDAYOafCKtqBb6mWrCxs0Fm76pjNn6Kn54hzbWM3l4PMNjwqu4RVGV1L16w8WbPv/IJVYIpTZupyVfA4UKJkQcr7W8tLFfvQzf5C5vbeCsORjvsW7n3OSnRaFrH9Cz6mwFL2iakR5KUClbqm3OHqI1BQpFrhvWLUId/v4OKuSS3lCGvWqURQM9+htFLAC7tSJl1A6j0a55miwZ0p1mA7vfx8QI4d93jCWCBu33QSk6Ya05BTEWK/NPMLqmQch5uUZ59JGIl2n1jreVQ8RzyGQDwr6ojlMAyOKdqSJy+T2Wlg+kYOS35k7RsL5TprXERSnRbg7Bfexp2i4e+YSml5RUqDXXPZs+E6KNKSvctpjwcbXNiLucCKK6cokeZItMkzWlEggVLlTouAT+a3Xqbc+iTypwywJnv1iO6AGuwhbHWX8mer87KXsPpoB55qybiqdkIJrL6e0aFeCCHPJnI8fSBNrPu28JIvb7Gy+X54WarW8tG4gen722YIF1nRzYYZh67gycpBSTMZyWBTjhSNwcwUx06TkVyAMv7TFSqAwKPeCy3dFaG/oCCUuwg6iesjCJ4BBy+RUqHsxQaOwh8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.09.25 12:46, Anshuman Khandual wrote:
> follow_devmap_pmd() has already been dropped by the commit fd2825b0760a
> ("mm/gup: remove pXX_devmap usage from get_user_pages()"). The fallback
> stub in the header which is now redundant, can be dropped off as well.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>   include/linux/huge_mm.h | 6 ------
>   1 file changed, 6 deletions(-)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 7748489fde1b..96ce0ca54e49 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -652,12 +652,6 @@ static inline void mm_put_huge_zero_folio(struct mm_struct *mm)
>   	return;
>   }
>   
> -static inline struct page *follow_devmap_pmd(struct vm_area_struct *vma,
> -	unsigned long addr, pmd_t *pmd, int flags, struct dev_pagemap **pgmap)
> -{
> -	return NULL;
> -}
> -
>   static inline bool thp_migration_supported(void)
>   {
>   	return false;

Acked-by: David Hildenbrand <david@redhat.com>

Documentation/mm/arch_pgtable_helpers.rst still mention devmap helpers, 
want to clean that up as well?

-- 
Cheers

David / dhildenb


