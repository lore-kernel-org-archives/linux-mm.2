Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC409CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22A748E0040; Mon,  1 Sep 2025 11:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA198E0003; Mon,  1 Sep 2025 11:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2038E0040; Mon,  1 Sep 2025 11:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC5FC8E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:50:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A4DD085F2B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:50:22 +0000 (UTC)
X-FDA: 83841118284.24.B215965
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 42EF91C000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:50:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="HQV/e8ih";
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756741820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FFB/nnIls2YEMkJJaENT0MJmgWbxUwVCfeQdW43zAOA=;
	b=HYZUrA+sQ4xhMrzb2Tr0wYxjuUakSdE/VG32lfAaRC3YyRAWg/4z6Lmjshz9DQfEeh+Ef8
	h/V1jjp4MWayNzFKoCKBZ+oC431SfERNFQZljgagpYja6q2XjPYgoS2W1aLgymBh5f0v4S
	AL9QlLvjJLifSiKQ39hQT2G2ohLcwVs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756741820; a=rsa-sha256;
	cv=none;
	b=OS6HK2TKc5JGHPSwAzSZf4zMsc49IVvPf3XDYpfrdtlOyLNfihis0LGuulmM058yxbPvkb
	kfeOdIv4mEpgEHvAY+dxNbx0y+HXMuMADuQVEd1Cnap1v+W/pdUwL13gkA3So/cOsGCzRJ
	n+L5AB4zItk6BIvuU/qYtZm3thqzUB8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="HQV/e8ih";
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756741819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FFB/nnIls2YEMkJJaENT0MJmgWbxUwVCfeQdW43zAOA=;
	b=HQV/e8ihIpmtoue99vrmEZXaeyXqCw1snmmg8TCnaa5df+a06hHyUpZLVk//3QNlm6Dc6P
	ODaVVb6EReEu7cRcJ54neYEgnWMEAzebkLeGSPeO29DQ7E4V9MWHJbxPYjEBwHXXDG25XD
	wVUCMhowPOQWCdMBE6B3rFxaDPG+u24=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-f8MRrjXTNqyUMGEUvj8jDQ-1; Mon, 01 Sep 2025 11:50:18 -0400
X-MC-Unique: f8MRrjXTNqyUMGEUvj8jDQ-1
X-Mimecast-MFC-AGG-ID: f8MRrjXTNqyUMGEUvj8jDQ_1756741817
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b869d3572so6161795e9.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 08:50:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756741817; x=1757346617;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FFB/nnIls2YEMkJJaENT0MJmgWbxUwVCfeQdW43zAOA=;
        b=KVqiMNzQNErP1K9Uu3UASx1ztG2pMK69/rj+Y/34HEeDi34dBFC5PJl76Kcf0Zu2jE
         dRcQBgvwm9GG0kFv4xW6Z4i1kQrBiYGYvK+bxGGzjiQBaWLv/untyvjiywmZu8oPf60z
         VigcWOpO0PDk3HinhmUSOCy56TgFgYfTFavtIVl5kl/xMSj0C3s2nKzkyuqMznCTGOyv
         l3CIsT8yz+4tEXlNkhAe1/5BRJ3nvbhoCuDb5FJpR3xc1I7f/Cad+wkHtMs6IpakElwd
         kiKCWbBaHcm/WV77ZOAKDIliiiLP/in8QzCPzTxa448PCDrzXGTqH9R+YPkQS/eGs2Wn
         wsdA==
X-Forwarded-Encrypted: i=1; AJvYcCWgzIi+TtKDtM+Q0iuultw6DBOaGL5n/XpEfIrP/PQczBfmJ1911vkLX2xdliLTtk0LbJX62SC42A==@kvack.org
X-Gm-Message-State: AOJu0YwbRo6VijjqzYsO1TFaoTICJxQdFHWtc+e38JbFhdr0tclMv72k
	jkszCDt3CStnz4sBcBs34xJY+BxbCexAbu3zExYvzbvCV4YvwGBIqT206T/MjPGls7Ad/IYJLuM
	l+JpByfJDFctsXhN28dRJZjW0iCW0oTX/zUCaeYpbqySOOAlS+lx7
X-Gm-Gg: ASbGncs7Zo7mNHO8wQMtlut546efrGn4KzVvVlRY5S5m9VoieMNnPVjwyxxDGSLRtvS
	ysR8RxzzVAvao5k+iAmD1uPZu8IslC1bfLkRifymSnuwoTmZSbHqOlFLtF9yn0cmGWpuVk1fo4y
	RGTjrM2qtpT8q4G2YxVJ1EvMYzcWplKMczMF+bM/DFWDJqJY21oISLv5UTO2cDPu7PvH4S/xpUD
	GQWRqHEH49paVDa6wvursmjuuow+aynq8bLdP/i9AixRRQymunHRv42MRDp8mYWlKooj+wPS2aA
	9DoMEWD4aSK1rGsn6HPHvywzxhb1TIu6UpyGvZH2DbkMy7pNPI1dfYyZxLZzAjYJ25cxlaPDbTe
	iIX2jbozqvv6m6Xg03+FUNnVq8y5vmUlBZ4htxXMI2QnM2+kS19nsnWl0CajtC3ctgxg=
X-Received: by 2002:a05:6000:420b:b0:3b9:13e4:9693 with SMTP id ffacd0b85a97d-3d1df34f200mr5638084f8f.52.1756741817350;
        Mon, 01 Sep 2025 08:50:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFO+Zpu40u/ZMiH4dKr/oqTQ1iB8aLnxg/PlKUmxEp2nhtKV6CGOLSQt4EQC3AL0E5hRgCpw==
X-Received: by 2002:a05:6000:420b:b0:3b9:13e4:9693 with SMTP id ffacd0b85a97d-3d1df34f200mr5638061f8f.52.1756741816874;
        Mon, 01 Sep 2025 08:50:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33add7f2sm16821687f8f.32.2025.09.01.08.50.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 08:50:16 -0700 (PDT)
Message-ID: <a6f218c7-2caa-48a9-b4ce-4df1fbb288ee@redhat.com>
Date: Mon, 1 Sep 2025 17:50:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/22] slab: Reimplement page_slab()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
References: <20250829154728.3397606-1-willy@infradead.org>
 <20250829154728.3397606-7-willy@infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250829154728.3397606-7-willy@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: v_fg5WPL2R_HfQQ1gpoPvQLmvc9gRwHzo7YQF4NGk2A_1756741817
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 42EF91C000E
X-Stat-Signature: ocjc93io8p483ist4hcxis6n49fsghhy
X-Rspam-User: 
X-HE-Tag: 1756741820-792257
X-HE-Meta: U2FsdGVkX1+19K0Yxw3ngUs6+9wkpa6gk3cY31XOX4VS6zkGuYYpZd/v/7Wmjaa7hE/ctoiScCCNAx1ow2PPHpJVZRI+5GUHkK2c9BpkRNNIwOOPxL8wudtjGcOzkx6hYMZ0VKlkKBKJ2qBUhry1Y1v3hupKxLvo6UBtVAocYxqdhGYQ3jhRFTmNoUMolkB9YxEZHXX/2dopAxzQwjLl3m4iuM0l9HnRCRtRk+RVKPs6rtB27syOnIgcZVsAwwPYWiG9OaFm14k2n8/FfCBF9qUBwRpQ5wIgsRwNjieeB8zE+bj6uHPuR2gKFSF6rbvipbvvh5BudDKrQu20bAj8AwDrEYdqa39z2ywcO08KF8vyfWIS7a4Jf1kk12FDptluAnzy3UuVcsT3eLLh0Z/RZo0UxN3DT/QI9HKeooPVyumSfTPUO23OEXiKJo4qHLV9ZyMRVhGua2b4NL2zVIrGL0LsLkEiBfpjjwD/h5/A5aNBSD3v+Oe57mZWXReOJK+CnXds2Awt9yJxnmceRlYJwT/qXhgYh1FBc+LD+tXmcw2464R7FnXEyEewfevIilZBWVyLGBHwtFFFkoZrBzzB+vqySpocW+9u3SJr81FzHBgfjrymjpHGIlOBNWE65pRHakPKTRStxAafmpcdhfqQ2OZCov8Lq6E0wgouLRt+JVVz3wupVVzsvzBmI7QagwTBtidQlEvP9SZu2oVJuawQFyD2LLr1G7RZIobGhgjVLTI1tDn/DmH18MwemUD/D1dUldGoN2ArkI7hnr5pdzgXo922JXWtG/8XwgXneC+sv1BBbdPO5F0RSA3JtR2WlTrsHHy/0rGlZmzo2/n6k5x4T2+kKx/fVsaxgaQtiUo+DZzzrx90/sNjq3Uz5w9ldYU6Wb/rBiyKf2TTOxXs0L16pf012udqQd1oAII/XA9SsPhUHGeXpEpAmbrXzP2PgMS7CSlzfCuiCWUzKqxJr/0
 LZxY8mMF
 DpgkvopvqJwL5cV7JxgvoVKUolVqgSSYzfUIUw6M4ohEJHR21AiDdTgDfvErjurNke7myZBE42IogCYKf3+wD35NTfdZT+fAxpc1jLzo9UsUuOtOkhypS+R6kW4hlyqqFEJNrRKB4RSKrXXk4TPTieg0J9hTjv8emXIcniyXVbhgmegwqbKI9Amo+m62O6NrQh8f8ggv/IEEHn8M8kc5eCVhI7Mzce27yhcwadEB2w1z59ETfCdeGbiq9AZn60bBFYYKmBWkuNyd7KDyPTdmSg71f/La+lizR66bpgji33J8Wi5XzLU3D5UL0ZNzrBTq/MVFXU0cFD4Ncw+OEV/oGLWVGAxVIOqjoBMifnH0u9WtHcOFkMfRm/4RloNFFBlY+3qwy8qib/2DrDPb/DcjvtLXwKyWuHggo5+iDbChKKBcjuRDSxlTDEDDSLBa5e3N4lcloOJYmUBzTlXyy52eHuJ+zdcBhB96ln/sYNA7vd7RVMenOCNPbc9Bvzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.08.25 17:47, Matthew Wilcox (Oracle) wrote:
> In order to separate slabs from folios, we need to convert from any page
> in a slab to the slab directly without going through a page to folio
> conversion first.  page_slab() is a little different from other memdesc
> converters we have in that it will return NULL if the page is not part
> of a slab.  This will be the normal style for memdesc converters in
> the future.
> 
> kfence was the only user of page_slab(), so adjust it to the new way
> of working.  It will need to be touched again when we separate slab
> from page.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   include/linux/page-flags.h | 14 +-------------
>   mm/kfence/core.c           | 12 ++++++++----
>   mm/slab.h                  | 28 ++++++++++++++++------------
>   3 files changed, 25 insertions(+), 29 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 5ee6ffbdbf83..39ed2f243279 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -1052,19 +1052,7 @@ PAGE_TYPE_OPS(Table, table, pgtable)
>    */
>   PAGE_TYPE_OPS(Guard, guard, guard)
>   
> -FOLIO_TYPE_OPS(slab, slab)
> -
> -/**
> - * PageSlab - Determine if the page belongs to the slab allocator
> - * @page: The page to test.
> - *
> - * Context: Any context.
> - * Return: True for slab pages, false for any other kind of page.
> - */
> -static inline bool PageSlab(const struct page *page)
> -{
> -	return folio_test_slab(page_folio(page));
> -}
> +PAGE_TYPE_OPS(Slab, slab, slab)
>   
>   #ifdef CONFIG_HUGETLB_PAGE
>   FOLIO_TYPE_OPS(hugetlb, hugetlb)
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 0ed3be100963..5fb0f0f8f99a 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -613,12 +613,14 @@ static unsigned long kfence_init_pool(void)
>   	 * enters __slab_free() slow-path.
>   	 */
>   	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
> -		struct slab *slab = page_slab(nth_page(pages, i));
> +		struct page *page = nth_page(pages, i);
> +		struct slab *slab;
>   

There will be a slight collision with nth_page removal that should be 
easy to resolve.

Nothing jumped at me.

-- 
Cheers

David / dhildenb


