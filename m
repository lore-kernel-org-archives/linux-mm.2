Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B9D1CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 11:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8495F8E013B; Wed, 27 Aug 2025 07:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FA258E0105; Wed, 27 Aug 2025 07:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E8668E013B; Wed, 27 Aug 2025 07:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D41F8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:30:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 036901DE276
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:30:46 +0000 (UTC)
X-FDA: 83822320134.14.6C22F33
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 78C068000C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:30:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OJzWLEdT;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756294244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e1LCbRKHwQVAlu2xDdlOU2DidfG5wmj6ezym1LNVC8I=;
	b=ur3OXYbBxntb3ln+qb8X5h7dHk6OkAasuzB/splNxzs3223dmZwv0XdVE5etSY2Oc+MUfY
	sa1SQZ+Z0Muki89igfUEcdv5/LgdvJo86ZMa59gDWWtvUdPnzWcHIkGV15i+4fU627OWkr
	C247GsRw8ThSTKVMDYPWD2lVNUJ2oJE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OJzWLEdT;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756294244; a=rsa-sha256;
	cv=none;
	b=DVbFsHK+0A6P11GvIYARqjBnu9Y9VQ+y2IgdmfG+7cA0X1G1yzyDOUfXy5seWaNwfFyMR8
	kyBx1RAb+pSZzQDeVstQsTrUNkPk3C9yVc1xPmjuuLwxmeZZzBoKFLsivIczji7sMvteHX
	/jV8nmEPpzuPM7Dh5jurVvgoSTJCxbY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756294243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=e1LCbRKHwQVAlu2xDdlOU2DidfG5wmj6ezym1LNVC8I=;
	b=OJzWLEdTP2D/1VadhrNXXNiOxKyktJLhAFNvyX0OwR545xcS7oB/R9Dh7DG6CoX5vuILmp
	2+/0SHG6Y5wApkTvip4BVaoQz33QCEojKyVZb0qYBq4zxPX7BOthO6PfCpWbo5KkS7KAe0
	0vjIDaLLD1I7GSg/zChXSWfRkQb/G24=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-r1cvoqDxODuplRrYwLB5NQ-1; Wed, 27 Aug 2025 07:30:42 -0400
X-MC-Unique: r1cvoqDxODuplRrYwLB5NQ-1
X-Mimecast-MFC-AGG-ID: r1cvoqDxODuplRrYwLB5NQ_1756294242
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4b2dab82f70so73579521cf.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756294242; x=1756899042;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e1LCbRKHwQVAlu2xDdlOU2DidfG5wmj6ezym1LNVC8I=;
        b=o19nn2j0fbdoUgjxmcs9cKddeYmMNfv09KK706ury8JK9ufJYDqXT0++VAZmbC8V7b
         0mSrTz9kfoNsa9ygmlmAfgpoTcCHXjJiA1M2g7s6NlcFdEzPu79NFqkz2RgNve4JVBFC
         XYMr7G2PEfGKu80ZOC4jxXAIbfKBAxBhTWJdGOCzlC8UymqJZvQkZ7/5HF1EqXqde5Vg
         Ou21NtQRns/QLaJV/iKmUuJafUSWC+0M9J/sU7+ApUq9weohjVNYYB5kkyaOkbERT3Pf
         8vQ6EdbGJxofW7lNoqwX1rK5oH8+KL7CKm81HmKyN0uuoWh0ylBRFMi7ClZqzGkPWP31
         Cvyw==
X-Gm-Message-State: AOJu0YzuDV3d4QTq8PwWkbNCRT72jp2jgA4RbbhqurBhYwFnP1IWCNaf
	4BkHuSHdCPvCm0AyE4PinDZZcLFkR/RDnWYWAtlg+FFWZ+lpZcifybAnQ8/pjxNWn8Er8rfdgTT
	wqygGhDO/hykCOteugkjiWVJcekKoH633BE20b96R62GHDvfcsTkaOhuzw1ZigjdUYA==
X-Gm-Gg: ASbGncsrgbDG0szhx1j2BVB4lYPYXOgpCTtuRhrDclqb6demCmq7NUS6VYlWeEPnlbJ
	LedOH6MTrBCq+p1VaRXSqFxJRsPEX2tCpzTMDxaNkkYdPxTiEJJyWFYbf2VttHHsOQbA6YNYP4M
	QRSRhZ++ajzB9kggkVVdMx1Z2R9jsFrmHgWDhS9sopB5F/Wh5CTwDQBH13JpPjQ9paTeDhdWnmx
	LxarMi3T676DzPzrH6m0leGN+xo902kFNm9Mf3ndNnpeTEI1cB2YCIT62Vfu/KYwqSgz55BCqiD
	3PbYt8iX++6v8WXocT1yFTKihPkplCCoD6qgEQPNsLb1AIv47W9Y/mxWSBPsMQ==
X-Received: by 2002:ac8:7dd5:0:b0:4af:236d:29c0 with SMTP id d75a77b69052e-4b2aaa599c6mr195667531cf.36.1756294241705;
        Wed, 27 Aug 2025 04:30:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG53ez81I4sWyzPrIC3syTrt7sayA+ehWgZf49bSq1QVNZK1AETDzjP7uOetG52mvWoAJVYiA==
X-Received: by 2002:ac8:7dd5:0:b0:4af:236d:29c0 with SMTP id d75a77b69052e-4b2aaa599c6mr195666981cf.36.1756294241125;
        Wed, 27 Aug 2025 04:30:41 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8e1e397sm90751491cf.43.2025.08.27.04.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 04:30:40 -0700 (PDT)
Message-ID: <26001d9e-1ecb-4013-9c28-e1c50ca09142@redhat.com>
Date: Wed, 27 Aug 2025 13:30:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 2/2] mm/pageblock-flags: remove
 PB_migratetype_bits/PB_migrate_end
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, vbabka@suse.cz
Cc: linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>
References: <20250827070105.16864-1-richard.weiyang@gmail.com>
 <20250827070105.16864-3-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250827070105.16864-3-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BC-bjK_ui_rf1iCRkbWhp5pA7UMhTfzIl38gCnlZSZA_1756294242
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 78C068000C
X-Stat-Signature: aku3azxfh1fazxkrzo9rioiq4k7h45oo
X-Rspam-User: 
X-HE-Tag: 1756294244-293583
X-HE-Meta: U2FsdGVkX18aXzrBxgSFyYlYKiRpbi5JvxDIX8VneN6SHvShPACW5kC6hE7Rb4N0nQgpQecOXS7Go+ug83P8JZwXTy8Gp6MHdW/7H4KmCF8cg4RsEnq1Q9N7yTMqK10HAAA1unnqNYf8GHsUgIcQrfyBrum2FELVV6eSAudJGJUdD5diImkBcDjBV2JZLwi9sFCc4TFxbWtKf6bBgzwZGx1FPeBaEQdARIS++TyBHENL++i11zygjrQnVUXIKXCD8BhlyHPoSAszNKnM8+KtPUqQQRZehiTekOIIS5mfn2AqYRwBPt9T34h3HPcZv82xKkt9nwrx+1lV/oZQgYHXfdgdbGHKzxB4AfD9emKKg0Twg8PDJPYEQU62soFvragWuhuxhq2caYAzoPT0Eo0K/r5rsEpYc4XRUokTFFnBiOW4qxpThVEEpR0sCyKSzRSabLPkMfjZu/dT4SuyJGE7dpsK66iCKtP7mWCYGRlBf6MJNGIUHeD6znev2BMJktrMUfS61354KO3VJuwt5b4GOXP5372lElEBSpoUVHTBNnzthW6p7QnutBv1hQnlQU/mQu4r6zD5l3HEcvMIH4CL25K796Z++pT8FITTIZeLZ8z6JmoRz658mRdJJudx+sepShr/ILs6XErdMWRabF3BkKku03K7fP3jg+moAS11P/ObmA+9tcBpgwtT8wg+0funi2vgMWxNBwyP3gKQPUVibEklsW0D7cHg/0t3JCiKBNcmwF3qAQgKk9yeaF9RPsP2SFRzHAdONjaa5N+x8THgii+SaZdX6CBlDggBq8sTuAwLGIWOkbPtc7OxzrdHQQjZUxGFIdKGRMwFGCi7bm9WV3xa8PVLY+pxYiFl7hv9crNkalwj+DebJLAMSC6SDK1oWnKHjjeMvcZq1VKzPFjjbwMFl8TxvrJxGhhliv5eLXQdiBas/RTx7fImNydJSzPlMJYZjJamd15EnCqEp6F
 +oK4Jm1O
 hm2dgwR2vvjkZnVhc+2vbG8I4jY3fG4nr/SyPzPoKVp+CN/2CTY8dvodcb0+53u4uqTa9Y3wXSEraMb/7nvliKyldZ9KIsfv8gK0vQx/iDSoSDUmTZ/hgtBTIbxVIAgHWlQqpavtB2MT1t7nH+AOtXCVX0yRqLbZFTIqWP5dWDOcSUew3FlASXJ63ZVI4N4dnYlmherFGzurcSaGpFi+bp10z2isOBdybOdzmz1yJ387YVZWCu4PjvHmTQLF5Pi71mzDguzD5vo+VdSeSLeT2rRsIaaurFvuFdyYCYxRDQG1cDHqG44PDYs9LTqRlTro7xMWalYjqLrdxPjCbQLoIFbn+ke7TQt7Pd9U7HrSBqFrsgsZNywiwsG+MlzV5xXOxwGyibUBLSEtmV281KHs3S2grxk97wAmjaqIVzK5xf3yQb+Mj9NAqk2cFNd1z0KPi28o0Sx2S83imhe6xm8J8A9SyGQxmpNjRryinJ9F1adYjy7RyoEVVaYNU1bqV9AQl+oRPrbBssg2jRp2NZRhBOLe9QwCS//n4KxX/43v9DSGYyIyOtTwMhZGB1v8PamT+vQjMpGUf2VjDJiqCciX76K6Fmcz9I2hLb9WHl6ClUHSWIs6Dck0ejGILXrbRedFgEwW2iZF1XAhHVLyphbT/jiK/JiQYz23QOPXy698mxTT0wUMiuvjCe4QJMuBNo3nLyR6b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 09:01, Wei Yang wrote:
> enum pageblock_bits defines the meaning of pageblock bits. Currently
> PB_migratetype_bits says the lowest 3 bits represents migratetype and
> PB_migrate_end/MIGRATETYPE_MASK's definition rely on it with magical
> computation.
> 
> Remove the definition of PB_migratetype_bits/PB_migrate_end. Use
> PB_migrate_[0|1|2] to represent lowest bits for migratetype. Then we can
> simplify related definition.
> 
> Also, MIGRATETYPE_AND_ISO_MASK is MIGRATETYPE_MASK add isolation bit.
> Use MIGRATETYPE_MASK in the definition of MIGRATETYPE_AND_ISO_MASK looks
> cleaner.
> 
> No functional change intended.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: David Hildenbrand <david@redhat.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


