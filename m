Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA49BCCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 17:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15B7B8E0006; Mon, 20 Oct 2025 13:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10BC08E0002; Mon, 20 Oct 2025 13:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15DD8E0006; Mon, 20 Oct 2025 13:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC9348E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:34:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65E121A0265
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:34:59 +0000 (UTC)
X-FDA: 84019193118.13.F155481
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id DD9AF40017
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:34:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e79BBBex;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760981697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3DedA4x233js/mfbScs6FBdUFi20blXzKiq9/Dz4VJU=;
	b=SEqSCzBqoYKuxEHRo6+E9Aoi9t7x0FZ38g8LukpMah/aEbL7c8uqhm+mDd6eVFGRfMWEvb
	iIedh0qKYBHqoeq2ITukGzs6CMV3MWDSzEc15BqM2QQASewhNL9agDab7zFEjxn18dL9S4
	RSIrQNapgYFIAed6lg7KJUuO6A1QeTk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e79BBBex;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760981697; a=rsa-sha256;
	cv=none;
	b=aZBuOsgOHT2ry4uHAkLkR/3o/nU6byrO0aSTqZhuzR8weBHhK3pi+kUk96C8k1RUnU59gX
	o2k/t0KC2bRHcQmoasV0dOw/k4RJ8wknpDbns9MQ/Jb8eyq2KFz/Pl9//cecfKKP7W+2yd
	HcHiK6vjgWM9ejfYY7S+6JB48PLdnOQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760981696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3DedA4x233js/mfbScs6FBdUFi20blXzKiq9/Dz4VJU=;
	b=e79BBBextWa+sARHAKGGTdbbj7vVxhk+ijtMndk5pGFgV+AP0/004cPJmVVtKIIrCj7git
	pDws0UlVtyG1ChzBkYvXTsE4etz6kbKhxyfLH5ssMwbZVKg95eP3FcEHDFUCojDdef/eRY
	MxilJLmUN05oJOWQmc2mqAmuNi7REI4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-xdceouNCNlaSD_SFLdJCLw-1; Mon, 20 Oct 2025 13:34:55 -0400
X-MC-Unique: xdceouNCNlaSD_SFLdJCLw-1
X-Mimecast-MFC-AGG-ID: xdceouNCNlaSD_SFLdJCLw_1760981694
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47113dfdd20so14660475e9.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:34:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760981694; x=1761586494;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3DedA4x233js/mfbScs6FBdUFi20blXzKiq9/Dz4VJU=;
        b=BFl8oRi5UA2aly0ClAuAeyIAAEBea8c6dvppoqLUVOGXfOEKHzUo3qJUq1Mihv6sEN
         2F6B7i5ZBjIVkPrlEouaIsQV5bWzeKO4R2H1gNBPBaw6HfpvMUE4u2m6eGd/nEagbepR
         vIOu1ALymoX5sIWUB894x3b8rbfZDc6gylTiOkxlFZAKF9qAYwxxhwSjEhiMKP6/X95s
         B42DTA9JHjUlDsja6nTdZdUw2JiPskEVk3Oe/cLOxMTbeydykcxS9Qsr353PdCfKuCAw
         A3Ke/YU5xAtA1BrhkuRdWmddx4y30al21FISB7IbaWLtwFBTL3bHgHRy/U5+rbXiAiR3
         fEFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOdfdFc2h0NZA6iPHHqR2dpshoSrwK16wUJrGZxAh2RDBRS8ms6A8dy53rz+QSgAdQlzbfkSLaXg==@kvack.org
X-Gm-Message-State: AOJu0YyKz3pZKOS59+Q9sTgDNkXccY7SPEXcp3Hx2JnwYrzQcaaHmaEc
	80cB52+Qqk2UXlE0Gm0vrYx0Fh/2C81iNa4c2Hr8sgSv5xAO6wWAmeGYAZ82yQXEciF45wWKZew
	z+/Bud6mtmPjqTxgODnIV0rYUGfyQnf6juMluZJXFUs68fj0++S+riR2UhmS4
X-Gm-Gg: ASbGncvMYVDFXNUUxQfw2eee7BEKyKsJK5QiPZUQCfdNFc69UaifE6NuOQg/DiF/WyS
	T1odm3MQS65oAgIGkGW+E/VP73dnc35e2PDnUt7LiE3u4P3vkLJ79ADryOR1ChXLgplg//75RFS
	Y3vuLmlnFi6bUP/2cJ5hjEVaR6OY4S+I538ssFV9Xo1I08vuIHQjMhtM9NH4RZAOHALLPXUOqCd
	J/LtXNfhmKtY6F7CHOg5+oiPTqjcqrHvQCOgSVI/pKWqbeCVBneuruYgpucyimogY0RlJFX8Pw4
	wVWhhDnxAS+xNqhq/fDVLGzlKzQc+H/4AVH1sey41oyMAPaPZvl7UUCs/DAGUJrPUJ+DHG1pZFk
	JPkgkM8Of625902WkjXloUlUzw3dXprci03WVDlHNcoT4SIhTEmG5HJGlc4BKRrsEVdtXQkA4zN
	IYY0+Dqbjy0xDplPcLBoCWxsu5PwI=
X-Received: by 2002:a05:600c:198d:b0:46e:3c29:ce9d with SMTP id 5b1f17b1804b1-4711791c57bmr115399415e9.32.1760981693729;
        Mon, 20 Oct 2025 10:34:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFMRgGr7W0ZmdKCTDPEbxYDVR1waVTXwxskuSaTNcF6k7t00p988NktRqmuEG5iGV3upI2Sw==
X-Received: by 2002:a05:600c:198d:b0:46e:3c29:ce9d with SMTP id 5b1f17b1804b1-4711791c57bmr115399145e9.32.1760981693338;
        Mon, 20 Oct 2025 10:34:53 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47494b365adsm545305e9.6.2025.10.20.10.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 10:34:52 -0700 (PDT)
Message-ID: <5ff1ee06-375b-4d5b-b513-7b8cab4e8139@redhat.com>
Date: Mon, 20 Oct 2025 19:34:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-4-wangkefeng.wang@huawei.com>
 <335895bc-c2ef-4ee1-a423-06c673a67147@lucifer.local>
 <1a97f0e2-fc97-4257-8540-cff06a789e32@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <1a97f0e2-fc97-4257-8540-cff06a789e32@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Duc2cYruAtD0rpONuNRrcXuWsCVzMqUYaQe-XBj8quQ_1760981694
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nqta5ye7u7z4c35etr7pojusqoadn4q3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DD9AF40017
X-HE-Tag: 1760981696-211669
X-HE-Meta: U2FsdGVkX1+Or0eKwLwv4UXZ4mNuzlpWV8qWk0zYBisjuJ6261ZUDyOvyJs6tX8Zhr7j59pyacW9cv4OgiGHc0CK82U3bY0qhFv777dAJUdf8uoFeQi8mdU+eIGBjyQ3r9UbrCvoyBMc89hhhrTVGFp713C0qr+NoB1lrNyguZwu2TpR/cfTHOKsSY6OGep4ZaHtGuF06Epjjmj6+nt8bRI5qt8ZRy3cUFedUGlvt3L0DIhVpNOugRJccmq2JChTB6Zo8n7B8dwEdiGLLM46h43Ux4/mz6F4N9pFumwszjHLsqLuwZCRA95xzg1jewXtwus++MO04s8T17XMgZQTqXOSrIbQrK6dnKYu28r1dGw1DLy7v0nbXlGeYX54jXfdp4dNH8yKFIfRRN7EALwPBb0eBC0HPuh0a07Bkfvazb92djGscsJD8a0wMUY5MCnn51j3xVbBO8HpOSvz6WREY8k64xmTAOUCjcWpUBeTBH7bHjoCMqxSmDHoBTLFRqeeoYoYCWYCXiSAvdvTsu6ARt9QCT+B82SOAg8npNAkPXsCncnKksSqNg7BMJrzTXNtT7lup5sf2BGf90IMztCWcqi04oiGXGaFNJriRz/km/lY2mrBw6wZuh6f4tj+Bi3LlSFsP80ONZFvV8yhbdkEFnLj4Hf06MuYiC/t6oI5ToFcB8DU2gOcvhikwRyxN4fhjT/HCJA7R8bJ6U9LyYkTGS6GcnyFa5xZhQZ6+2sM5DX/aRZXU2EA8WH0oBn/JVrxMVpOSF8bDBzWBGg8lfRlu7F2wZL6w8z73cu1QOxvNdWNsYMnjq/WEA50OVUggJfmp1NDOqdU8mi/mJJS3WCRwXYSV/5XXOqruC+5dv2tEaagrn3Jtl+73i1oYyE5h3eoJXdWrOpR+S3e1fIZUW8+ZFEgWHNmG+fpVH9trnMK0jw2IiqA/9hkVTqR7yXe7TGwRvvr/hcjsoijLpOPPdx
 +kfZ7XCR
 eL+ovA6yi7mBRIDoaWe7mKZbr98BishMdzTq9gvIUrF7wwW+B5IA1z0Iu48CA5h6D69quohzH36tKx1Z2ojnOTYQTzPbWaDyuk0/m/RPnDEfy5rHduMQqtJ67jBc6AY9/2oN3dluUIn5PHjrm1A/6C88ZM2FOLeYqi2N+c8ble2sv6a+tY7cDb1O0nyPXLA/tOOj0t6MksfGDP4vc7Q/7rgdsJFIuRgJmptPx/Fnox2TwssQTFDU6A4UIntNKljJ+VbdP8KrC+IkLg5IIvKGogRYdwhmowh5ZDd4ZSSOInk6Sq/ne94lkxd3WtOjUIQqlQY8vSQLlQg5cdKkgENR2ADBMvqFuDpR0VdLugrrCKZMPJ5ey9U/eab9IU56osy8cmgC5KuAkB2BkhnzQHI+pC/S/J0ebwA6h6SJImttbzX8UxLC+VOIcCDc082jBSvFJzr1gKor5h8Q52/d67GA1ImNUyH5BeOURM2bV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 17:14, Kefeng Wang wrote:
> 
> 
> On 2025/10/20 21:10, Lorenzo Stoakes wrote:
>> On Mon, Oct 20, 2025 at 02:18:44PM +0800, Kefeng Wang wrote:
>>> The prot_numa_skip() naming is not good since it updates the folio
>>> access time except checking whether to skip prot NUMA, so rename it
>>> to folio_needs_prot_numa(), and cleanup it a bit, remove ret by
>>
>> Hmm not sure 'folio_needs_prot_numa()' is any better in terms of indicating
>> that you're updating the access time to be honest.
>>
>> Also it seems to suggest that you're determining whether a mapping of the
>> folio should be made a NUMA hint by the folio alone rather than the reality
>> that the mapping is being considered for NUMA hinting and you're checking
>> to see if you actually have to do it.

... because the folio doesn't need prot_none protection for NUMA hitning? :)

>>
>> prot_numa_hint_needed() seems better to me?
>>
>> folio_xxx() stuff all seems to be derived from the folio alone.
> 
> Naming is hard, David suggested it with folio_ prefix in v2,
> the most check are derived from folio, but I could update it if
> we like the new prot_numa_hint_needed().

I prefer what we have here, but I will not fight for it.

-- 
Cheers

David / dhildenb


