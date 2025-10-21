Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01A99CCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08F118E0017; Tue, 21 Oct 2025 08:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0668A8E0002; Tue, 21 Oct 2025 08:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E97088E0017; Tue, 21 Oct 2025 08:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D992A8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:33:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DB131DFF66
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:33:49 +0000 (UTC)
X-FDA: 84022062978.13.015AF62
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id BF316180010
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:33:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MB+FJMm9;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761050027; a=rsa-sha256;
	cv=none;
	b=efKduddtiATxE7OhulpfYkbEYGxmgtlsBqRaOI+jF8NCiVP9EXN/4LbEmiZ5PXNRqxr/QG
	PSdzwk18Y/8HVP4CjWXgYXMiCkXMd3OM2ejUOUojasVkVOMLyKBmhcpPZIRBVAlj2HV7GV
	+p5Fi+pYYlwym+fYOGE2Z2ZNTVu6b/g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MB+FJMm9;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761050027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfqnXu+UHWjME7EnozBlaXknDB7yHQ4Xn7QOHKbDIt8=;
	b=5/oR0YYulwlcpAbXE+cQCqa+aDmChHHHKEQRzwi9ANek4T+KdT6v5WfcdH3Y04aT/zYTBB
	XRC5W4g/gxS3baWakaLciRY/44+tNEJ/3mipokzRHJ0wT6qB3DQHHekNPubT8SKaeaaLMO
	/gniyQyYC/4E477VSV0OiM8sg86yje0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761050026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MfqnXu+UHWjME7EnozBlaXknDB7yHQ4Xn7QOHKbDIt8=;
	b=MB+FJMm9AYnDVnh4BAfZi0pZBI+RSLiwwfizJJhhhZIsxpo7gpkTPzBqBTACIYILGrgWyK
	y2pEzYftSZJBMEf+qNfCYOUUS95rsbee/gHCECjPaqezcFRwX7iRlUs5OHYEClZi7aYFDq
	wB9ZEtLUqjRNb/ndAFkqV7SYhpf3Gss=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-yDV-QsJCOtC70MSG_3RJRg-1; Tue, 21 Oct 2025 08:33:42 -0400
X-MC-Unique: yDV-QsJCOtC70MSG_3RJRg-1
X-Mimecast-MFC-AGG-ID: yDV-QsJCOtC70MSG_3RJRg_1761050021
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-471148ad64aso22932105e9.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:33:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761050021; x=1761654821;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MfqnXu+UHWjME7EnozBlaXknDB7yHQ4Xn7QOHKbDIt8=;
        b=s5JRFmzB+saBTCxONjz9MH3HQr/3ygR2tormp0ZR2BPnGYaAs3ylLekD55bN3oY57j
         gJO4nH53nWL9+CHpEO1CvHJAe2IUyfRCBSm79kTWH+LcYs/nv7idvIcjGWliohk+GvbF
         0ltv9dnkfrK5vwnr1pacl6G2WR0ifPpiVE1wDLwhs0O6+1g1P/6fL0zyeK4k83e00UPt
         MXHxX0v6JPKIgHK79LOiIlenOB3z3waMrnwPunb8LdPBs0tjMdeDbdG1KiiCv6Vc6b2/
         p8T3/i8SEWGSSDDKGqVF9lfGtSS8kQpNH7AjUDuhxDATOv3pwpK/iPHDTc214QehvrUn
         eBnA==
X-Forwarded-Encrypted: i=1; AJvYcCVFmZXkQD/4qF2YMDJ5t9zA9b3p8VWPhPnV3Bl8CDVSZLmpicqkItTfxh9E0Sx3jL6bEFCNx0foVQ==@kvack.org
X-Gm-Message-State: AOJu0YyAOqlZcVkfhcYT2k3aEhb2W5IKzH33JZreZN7PDVju4Rydiwkv
	JVbymgO4jCKvP1DH79n2gu+RYsB80KXI2y73JcyNC8cdVwLDphZBkAnlazvzCP7/NiY2TOqXm4W
	SVXRlmwwV18hndUfr9rJhleatMfVky1xtyUZ/e3d0Inumnow6Ks5Q
X-Gm-Gg: ASbGnctUNKrzI/Y6jBesT5eR0xj/0TEPkhimTIsPRYMaL51avlZfhw5+3EhJWey+OAS
	45CBZ1U/CVLad1k1N0la7w2krSV01yUvEIhuoKUYO2X35HvZJ/UzW5WdGd2Qz9OJf/5OcRDu+3M
	htM1kiqM6HQLt03xp3a95eQwbXdalsWEnH02dq435EHhXhMEmtLMRS0zVzkxeyFpMzpOYV1po0h
	fQgS6z8km7sgVlHpayVqpzJKSaIWqyUu9tqhKR7epc7R6j9rkEI2KM485IZQDlMQBECefqR0qvV
	17ocka/EeVxOsgkgh8HCz8lLYm9izzMiiWiqplhuj04ZgQTvCc3UNKNKQNIXSizCvhReym54e1D
	q5pOPmg1+Gzr1QK5aF544PRD3Se3y/X15W6tTjrbtNA40YkMycXGnGAEUIU8jb8ietS0AdjTADJ
	kqqM9bnwoGvws7vmXXj2hsTV8kEfE=
X-Received: by 2002:a05:6000:3105:b0:427:64c:daaa with SMTP id ffacd0b85a97d-427064cdaecmr11439612f8f.44.1761050021487;
        Tue, 21 Oct 2025 05:33:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbCiQc+vS9vXSdPHPSKOQwG7mGLzY805GtcC7o+CtuZ741gU2aVh1wRQDPgu9lruJSTs/eTQ==
X-Received: by 2002:a05:6000:3105:b0:427:64c:daaa with SMTP id ffacd0b85a97d-427064cdaecmr11439582f8f.44.1761050021055;
        Tue, 21 Oct 2025 05:33:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00b9853sm20072238f8f.33.2025.10.21.05.33.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 05:33:40 -0700 (PDT)
Message-ID: <fb51f195-b4d1-4bf4-84cf-87d433f8ac86@redhat.com>
Date: Tue, 21 Oct 2025 14:33:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/truncate: Unmap large folio on split failure
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kiryl Shutsemau <kas@kernel.org>
References: <20251021063509.1101728-1-kirill@shutemov.name>
 <20251021063509.1101728-2-kirill@shutemov.name>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251021063509.1101728-2-kirill@shutemov.name>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mGX77945l3wgaY_Wg_pUF5Xe2GxgqJRZSGJqMFBp1vE_1761050021
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: z91hzz3hjn8jpyma3j49u71m63bxt53m
X-Rspamd-Queue-Id: BF316180010
X-Rspamd-Server: rspam09
X-HE-Tag: 1761050026-800516
X-HE-Meta: U2FsdGVkX188n8ah0tosCqM6pX2D0sSy9GjxxHgVBD4maDs90+wcJTQZzt/1h7MJ/A1Y1rk+u7nE8du7j1/2Xkk1HrR72+dXHXZcszfz4HZz/mcE/YjGx8CNxnPhxxIQl29Ltd6OUqkEOw0aBF7hJ5FiOlPvONyizMVuG+UV5+ObFwHkRQblCaiWwwi7TnZPEjXQIIlvNhpS1qg4W4hG9wd2A9QQa0GMc5Es6Y630sjuKdcWIPlpOIfiPelE7EZXOE65u49FlGGUz0xa6X1dAhLvVy56Ang34I2EZnzb6z5Y2CUAK6bnE4BvAhKzL7b4BNhXtvdv7H3xGRJNIPDT/bP8aK29/jDD48e1UjQy9ePNdiyvkCK8puK6lDBYkAL+ynDrbZhIcy9ixH3XvX/h/i+lLQLb9EvQe3kk3VQFmzB2JOCwcdgBbkF6LTbbVDhQjFcNLx1oHT/NuE9Uv6piqUbspawM1E4FHaHnpfOgeXPt8QhBN6qG+VYzj1xWeU1EY3+1DB8dytP53bGhheNGW6OYLVYOtYEu9v+5tOzW6W2nYlm4SLZwVj1TaQKMKbcYtrjyqCe5Xj0v6E9jccp5DWbIloNcd4ekoqkYfJlA45ydSPpsslwBHJ/Gi9zhrcn5Y4sHR2GMfeZVaR24TWSQmNpj5JfMaQ/D51XO07EuBV2LKXCMf+iAyQyOwjpPMtygpuUmMP0tnPsVZwt0cdXNrPA9i0iaJos8gw+JWS6b4g5o97twmJkmpQVbzeOK+QRioKTfMEGMs/IG9JEiDEqAIbvnDQ7yi7GRsXEoT5rzpsrSoxoRJJh6g4RdgcuyVZTUpOf1AwcyztujduRffxfafEFB3tQED62apK2kPz5gZLiHDOFJ2eoYKmb0mE0m0Zxh9SU7pwIhKiFpVl6IPkOLOjZbFt3wZ5fvZvyk0qlYKwA9EPzI4izJa0wK3iMOVaqsOLuFN2da9kz2yvkMai8
 51K4iVjp
 pxKMUjt/JrjFTFJsGVYByQHf/icGI40JGhv9zw4Ftc6+cuFV0hovf44XbzFmTs3SsyoR2MsZi/JNmP6g0Sm4AcjgF1y3BdfLmLMVC9WylnwX/ofl8NqaWMeTABgi7NU/7PVaj+O49KuyVTBqCfAAeUPf7NRY28jfXlujntJRZCgzjb2FZmejTlN1plzz0vSE7XgxQszT+pSPOEfaVSuMVeiux9pblY9lumPTcPzRen/47I5pWqbAK1eQ5gJxoboeMghlMWRGB0Kme3Ilk6i5y9bSJej/yh5SRiZ/YNP9cu6FxGn0v+IYmCLH/5HyS7qGxR4LBu4rGdmJzRyBikzgGb+MuzVvtjEHDrFnewSXpjuTssR033Gp89Hg5iz//SWBBRClgzIKja5B2jvkj4PLKumG4lVGYylg6+ID6koz74qyk19xVgjyHbSuZh7SAudiXZs51HCBg7qVYV8oVLDclfXlOQTSwMMkt+AoBW6pjp1/+DrThwd41XDPmQanc/JLPC9eOUgR1hgCf5wtnswP4UvZzeboY8EOo26N8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 08:35, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> supposed to generate SIGBUS.
> 
> This behavior might not be respected on truncation.
> 
> During truncation, the kernel splits a large folio in order to reclaim
> memory. As a side effect, it unmaps the folio and destroys PMD mappings
> of the folio. The folio will be refaulted as PTEs and SIGBUS semantics
> are preserved.
> 
> However, if the split fails, PMD mappings are preserved and the user
> will not receive SIGBUS on any accesses within the PMD.
> 
> Unmap the folio on split failure. It will lead to refault as PTEs and
> preserve SIGBUS semantics.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>   mm/truncate.c | 29 ++++++++++++++++++++++++++---
>   1 file changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 91eb92a5ce4f..cdb698b5f7fa 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -177,6 +177,28 @@ int truncate_inode_folio(struct address_space *mapping, struct folio *folio)
>   	return 0;
>   }
>   
> +static int try_folio_split_or_unmap(struct folio *folio, struct page *split_at)
> +{
> +	enum ttu_flags ttu_flags =
> +		TTU_RMAP_LOCKED |
> +		TTU_SYNC |
> +		TTU_BATCH_FLUSH |

I recall that this flag interacts with try_to_unmap_flush() / 
try_to_unmap_flush_dirty().

See unmap_folio() as one example.

If so, aren't we missing such a call or is the flush implied already 
somehow?

> +		TTU_SPLIT_HUGE_PMD |
> +		TTU_IGNORE_MLOCK;
> +	int ret;
> +
> +	ret = try_folio_split(folio, split_at, NULL);
> +
> +	/*
> +	 * If the split fails, unmap the folio, so it will be refaulted
> +	 * with PTEs to respect SIGBUS semantics.
> +	 */
> +	if (ret)
> +		try_to_unmap(folio, ttu_flags);

Just wondering: do we want to check whether the folio is now actually 
completely unmapped through !folio_mapped() and try to handle if it 
isn't (maybe just warn? Don't know)

We usually check after try_to_unmap() whether we actually found all 
mappings (see unmap_poisoned_folio()). I recall some corner cases where 
unmapping could fail, but I don't remember whether that's specific to 
anonymous pages only.

> +
> +	return ret;
> +}
> +
>   /*
>    * Handle partial folios.  The folio may be entirely within the
>    * range if a split has raced with us.  If not, we zero the part of the
> @@ -224,7 +246,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>   		return true;
>   
>   	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
> -	if (!try_folio_split(folio, split_at, NULL)) {
> +	if (!try_folio_split_or_unmap(folio, split_at)) {
>   		/*
>   		 * try to split at offset + length to make sure folios within
>   		 * the range can be dropped, especially to avoid memory waste
> @@ -249,12 +271,13 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>   			goto out;
>   
>   		/*
> +		 * Split the folio.

I'd drop that. It's not particularly helpful given that we call 
try_folio_split_or_unmap() and mention further above "try to split at 
offset".

Nothing else jumped at me!

-- 
Cheers

David / dhildenb


