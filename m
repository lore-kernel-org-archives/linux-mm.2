Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B40BC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 17:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C96208E00A6; Thu, 24 Jul 2025 13:57:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44EC8E007C; Thu, 24 Jul 2025 13:57:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0D828E00A6; Thu, 24 Jul 2025 13:57:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F27D8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:57:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 238CC140479
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:57:32 +0000 (UTC)
X-FDA: 83699915544.29.D5AB46F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 81734160011
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 17:57:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=agjxWxcD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753379849; a=rsa-sha256;
	cv=none;
	b=bIYZgn0eePjGIptQNRqKwizNYYxadIKo9khYY+mrg+cHgLSZH2yxebyRZCslnRKQ24VSKz
	NKq6qGWoC8Ecu5j9gBIVdfbo+W1QgnZaaKifGgBaETI27A2Xb6EUjFQfyEGQWJO0f8E8AK
	b6382VR69LbGJD2zzMKs9sHiSLRZ+40=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=agjxWxcD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753379849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wRK9xapkpxiG3ok3o7+uMUAIEIufkkbPdChBgAqvuRU=;
	b=5iYGjumdq8L4pLphAiX9ydr62zIzTJ93u5Tm62w39rBkrspKCOP4hgQA4H8sut7GGW2WXW
	aY7IPQKoZ4mjMdXeOKRRWxJtWquTbBP0VuZRGeYWOY1INqtCykf2lBbY1m7mDMEaW4VuRQ
	J1WBgH1+0VQE8sLiNUxoFMOEgQcuEJQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753379847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wRK9xapkpxiG3ok3o7+uMUAIEIufkkbPdChBgAqvuRU=;
	b=agjxWxcDZPl9bCXAieIoa24SH9T9omtK7KHP/jpMKE9cLSeG5kgswsK0bHjMrysD7boPy9
	5lnaSqW2JVjOX1QnWk0ACDJ9BYJaW1y8YodBDfRhg+l4dwv8J/ryJGpNIriBQ9pAh1w1v8
	ebBtsZXASFxBwwZHx0TQcYK9t6WrgTw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-uTDDFcKwNRm-U18VwmHYVQ-1; Thu, 24 Jul 2025 13:57:26 -0400
X-MC-Unique: uTDDFcKwNRm-U18VwmHYVQ-1
X-Mimecast-MFC-AGG-ID: uTDDFcKwNRm-U18VwmHYVQ_1753379845
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-456267c79deso3925525e9.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:57:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753379845; x=1753984645;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wRK9xapkpxiG3ok3o7+uMUAIEIufkkbPdChBgAqvuRU=;
        b=wXbdT2djPweP1lVObzWxREJSUQ0Z7U4cML+JopYd2zYuubocV2hgcrA7JCg3I9EQ2P
         KXbHx9mhPt7JZzHIOhRm6Gd7lnLLkrUv9GP2OSb/e9jkEckmf1gjCdmT1SxmYiPVqYob
         Ol57kwtmQlMRRwfffB1Nx43fMI+TQXjCZob7BIv3mEUrNd59vwN6tz9C/8HzzIzmm/lr
         byZKkZCN1IoF91BMVaod8KzJiW2r8mp4YpcLanKEmZEdotAeX4x5aFFcEabsWS85GW/W
         NsCCgdn79C0jN2nyPD/8XPEWqkOWqlMtZ40u25gwtyQHL9y11baVv/c6dQHxJwx+0GsG
         Lkyw==
X-Forwarded-Encrypted: i=1; AJvYcCXm2+pbacyulmQzeWdw7JM2cbI9msDCZFJKL4MYK/qeVNlqe2eh3pV55V9rCNnpx/TRK82p7YaUmw==@kvack.org
X-Gm-Message-State: AOJu0YwgQ4/Bi9eRHaf3sf3aFe8HqMjYH7b77ixPnj5Rapgh7Tm/RW3R
	ESUNtjcyMa+2AM/CU2e15PMESBJPudyvdt3L6aFGKWzYygwVlb/9ATjXZ3FGEKMwKM3jw95hKIB
	EoFgboVaW44NrN6lwMY3PVAuYCcCzwbia/NvC0+qG4Wm38k7+7JAH
X-Gm-Gg: ASbGncsoxahrzkLrrgH2p9M7VckBM8YlPIugoC4wSKl7gMhiTe9/Qq6y0ZjAU4ri4co
	SnSvvG9CSALyxjL435dDrKajkv4qnBu7mbsgCSHnX8S7HXPJVZ6D4xiKDXuAZgToRkl3idLY30R
	d1m6/WafvDdr7V1a9HIlftbgUotfaFYxR21JEZJtuDvkrSJRMvleIbaaNjMyaMovawuMyRIjKff
	kPo6faY9yAb2YOu4hSpT5sTZLv+Q4fFITnM/IzSG6qFvrLa28yH5ZdfDtgpB10iUbKDmt/5CXQo
	5PCzPc6Yo5hxj84Ii4HVQQ/6UYwONfdrj2lBzS+JcOjCNYXeR7eXMfjlCHyo3XZRG7l6TSDu7Lw
	Oo3UfGZ9r73n8EE/DSwwt0weH9Yw8KwkQ9+2ukQLdRikTiMDC0t0PWqKMPTE4bbBNjgQ=
X-Received: by 2002:a05:600c:4746:b0:456:d1c:ef38 with SMTP id 5b1f17b1804b1-45868d65ee7mr64291485e9.24.1753379844703;
        Thu, 24 Jul 2025 10:57:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzfjOdTZiPpdFAYtJlwTpGspMWGFs2Qa3+f5r9W+Fx2Z2Mo43vNq9jgGwIN7O1JQ1Gg1XRvg==
X-Received: by 2002:a05:600c:4746:b0:456:d1c:ef38 with SMTP id 5b1f17b1804b1-45868d65ee7mr64291235e9.24.1753379844177;
        Thu, 24 Jul 2025 10:57:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f01:5500:ba83:3fd7:6836:62f6? (p200300d82f015500ba833fd7683662f6.dip0.t-ipconnect.de. [2003:d8:2f01:5500:ba83:3fd7:6836:62f6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458705ce685sm26933245e9.30.2025.07.24.10.57.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jul 2025 10:57:23 -0700 (PDT)
Message-ID: <0a70058f-e2fa-4f83-ace5-f58df589ac46@redhat.com>
Date: Thu, 24 Jul 2025 19:57:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] khugepaged: Optimize
 __collapse_huge_page_copy_succeeded() by PTE batching
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250724052301.23844-1-dev.jain@arm.com>
 <20250724052301.23844-3-dev.jain@arm.com>
 <83c00fa9-37a3-4024-b3d1-20e7749b06c9@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <83c00fa9-37a3-4024-b3d1-20e7749b06c9@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sInrM4xfhVw7zY_8zcvJyZVpyK2NBw0q6bmBeRVztCk_1753379845
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 81734160011
X-Stat-Signature: o9up5yhhocy3fdaa9kygtctgfzupr97m
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753379849-263969
X-HE-Meta: U2FsdGVkX18dFaEgVaV8euFhgyYp/D61XXenBOgP6cE3ChMf2iqqCgFsc7dyp+Xea859DF30MZjfwoIqfq3BKs56j/cv5h9lkjBvyaKE4IilSfxhL4YX4MZPo1M3IUuvGK1m/RJS5i4qPyG9XY2OmvrphH4BOGJvXhNNLYK9S9zXt2dn4mm/euEmPb3SmOcLivFWzKnWEtjnbI16UID0USZog2UJodDI3bAkM0fD7T22YcnmMt4tVx2Hpl2wwyREAlqspbKxs3CplnWKZ5iR+o43IaXyVRe0plw8pTYYt3hQddtrS89yEUFRy/3gAbjrKPlN1SJ3USn9IU1wQFpNLOi8REhgJZi+le6ARpRygGXEQUewTi0VVsI4SxMdAzs2T7h7gFBZLafq3L19SVyBBK2+ZM1iLBUJv0My7hXm90frTOvKqZphBjp3AmfYvrwOkR+tR7V/hK07i2MIQFrolXqWKX/ttCIX19ci7QEZXxVvK+heM2efdL7l9tYeepsFtgkPn7iyOxxIjRRPzDtSmcF7oaXozavaIihiBVxRQmNu9CJ3I0jOWXs3ssefKBuFArMKGrk3m5fAowxSLtWHchiofFiqkZGLoHWx34Af0Reepj8w48Qp4KaSX4iXQ0Tmw5YijZavwFaOri6QhXzAIEUqoyHfeojlCr/o1ZNbqhBqqjP9C5dh1CDKix8TgDrZ5mTiXmpaWCvripxQJZ5RXzUsdVDhnAeG7vj2LDb1phC2N5AEKq1Qf/+VSzdLap414rn+iF4oAfTbGTH7EJusNgKkeQjYZcaXEJ2e5TqQv0Eac93X8ng9Zg2GQRbyf/zZFshjQhQilIsodXF+zwZto3SeSYWALCzTCql89zpTn7khtmTQdlfW54m4WFkJV79iBUwFFjzBv9RCQcKLDrPNefElBxZp41sU/jEf0+kecWpPgb/c1EwYky6/vWOmlqUbLEWx+swqaTDU/xi0n5U
 ldlviXf+
 p3Cg1AtJlGXtpGeUhnCO3J9jpD47JIg1dQZoTXUhcTzNKA8lDGNT8g+jEt0W1GMEmAKmYjfjPV6uuvgcZl9IwX8cJU4Ov1rNoQRwj7jyrYG1+niEtmXYdiz8GFyp0EqibcOyV3D0vZOD4kD/o9chLdBdSIvofGHhUT84bJC8jyi8pS+q1eCQJxxxqV4+te5NnPFiuw6NlxAAs/7yHzV6jmlVMsx21aKrVaWaUJ9QXjBR28gVgFS/06vv4mWuRNLFe7Yo3pGAozxfj/WmgfwucCqUpxFBmge0N05Z0LGT1s1x0/wGWFQa1SX77uzSPD2LW6nIsvq8c7lWunafxsnO/wE0iFKeJbRGhQxXJeFNOsjJSPH7/yqd+VW/4zX5AmI2lmpjwOoOBMwZ5mLfPiMpoXyq/Br05w7EdPWm2lZXA1YZXYdFBh/Q6Ugmc7tBCC+xeQNog7qx7dH0EoTX5K7U1K6vh5xklwqJj3Xk/wB62hnauUaoNSmU1WoaNyJFyuqdXUr26
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> +			if (folio_test_large(src)) {
>> +				unsigned int max_nr_ptes = (end - address) >> PAGE_SHIFT;
>> +
>> +				nr_ptes = folio_pte_batch(src, _pte, pteval, max_nr_ptes);
>> +			} else {
>>   				release_pte_folio(src);
>> +			}
>> +
>>   			/*
>>   			 * ptl mostly unnecessary, but preempt has to
>>   			 * be disabled to update the per-cpu stats
>>   			 * inside folio_remove_rmap_pte().
>>   			 */
>>   			spin_lock(ptl);
>> -			ptep_clear(vma->vm_mm, address, _pte);
>> -			folio_remove_rmap_pte(src, src_page, vma);
>> +			clear_ptes(vma->vm_mm, address, _pte, nr_ptes);
>> +			folio_remove_rmap_ptes(src, src_page, nr_ptes, vma);
>>   			spin_unlock(ptl);
>> -			free_folio_and_swap_cache(src);
>> +			free_swap_cache(src);
>> +			folio_put_refs(src, nr_ptes);
> 
> Hm one thing here though is the free_folio_and_swap_cache() does:
> 
>          free_swap_cache(folio);
>          if (!is_huge_zero_folio(folio))
>                  folio_put(folio);
> 
> Whereas here you unconditionally reduce the reference count. Might this
> cause issues with the shrinker version of the huge zero folio?
> 
> Should this be:
> 
>                          if (!is_huge_zero_folio(src))
>                                  folio_put_refs(src, nr_ptes);
> 
> Or do we otherwise avoid issues with this?

(resending my reply)

The huge zero folio is never PTE-mapped.

-- 
Cheers,

David / dhildenb


