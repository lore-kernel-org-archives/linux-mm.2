Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37C96CCD184
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 08:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C78B8E0010; Tue,  7 Oct 2025 04:47:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851338E0005; Tue,  7 Oct 2025 04:47:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7188E8E0010; Tue,  7 Oct 2025 04:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 606D18E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 04:47:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1651C13BB81
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:47:52 +0000 (UTC)
X-FDA: 83970690384.24.3A58491
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 88DA780015
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:47:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jQIJiAAv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759826869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TMvEcaAUNKWeuUDEQRfj/CMnuKj7mf5VRb/CtKax4GI=;
	b=oQDV7DJnA/ycI/DDYh09nU2Y7qkze5L/rNGBAQAcM1CqMD2Z2dMpPPq42SUJ2GRkUFWegl
	O9+2anNa4YC7dHLiK2gTRhJTpmare8kJsvYdtYBjqq/3qHDOmVFrsIZG/kzpuU5pRoPiN5
	880rUz0RrNe4FKISb+gj2mmvKTN/TTs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759826869; a=rsa-sha256;
	cv=none;
	b=K2BPM1B/Yn87u1XfaGhD1+d/DSmUw9W864GnE+nQNmtNouJezwU6GnMBpxfiEwaPX9hM6I
	S2SZYFj5+U2v8XMk0GekyJ2zFJ6h1WExzSYa9heG1GWVUOVVVW1jo0hzbUtKMcWQsBAiMD
	yLPzt3xFIQyDKdlUcxsXDVoIaPe5R1M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jQIJiAAv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759826869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TMvEcaAUNKWeuUDEQRfj/CMnuKj7mf5VRb/CtKax4GI=;
	b=jQIJiAAvVFoCuCeHBdQTnDVTBFHabVRVckYpSo5j+0YR1+geNBcgdDjWWDcjqx5pUvb/tE
	hMHlcL/xTOSad3OFnEYvas0q5lUUUzAVIhjWWddVSAF5X7zLCVg6tjoapa5Vlv+1mVC/zH
	4UJHZfTNzsrnu1fVmZbgnnZld+9RuHw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-82jw6F5GPJyeIYaW11_iEg-1; Tue, 07 Oct 2025 04:47:44 -0400
X-MC-Unique: 82jw6F5GPJyeIYaW11_iEg-1
X-Mimecast-MFC-AGG-ID: 82jw6F5GPJyeIYaW11_iEg_1759826863
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e3e177893so32324895e9.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 01:47:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759826863; x=1760431663;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TMvEcaAUNKWeuUDEQRfj/CMnuKj7mf5VRb/CtKax4GI=;
        b=js/p0S5LQeBorohsi19YDzGzp9iV2j1p/HPAyMxgiqwN06aWx/0b3lmRvvgy5OHz9O
         xvef8TKY5XLr6xzXuc6FAswcLO3gnVrOYqhvHYKqKsYGwLk+m7KNeX2wV+3qfPDeat2j
         LsFBO4lI9mSWFJFo/3/Ri/p1zINex6m8sfVpDubqlG5MurWNSTZpSF29qkeIUO/Yxb1e
         V/FTdGnJCWrASn04GqeEF8nLu2HkxBkRD60X0RYguJEACNs4eYnlsmOoHtFKgA4/LB4x
         VVgE6V0TMqIcCmq7lHQTRt6MUm3JVta8LHsXGce7cc2OMp/z2dxs88z48F8iAUpX7nSL
         8TSA==
X-Forwarded-Encrypted: i=1; AJvYcCU43bsoNabnsB+4EdV4/YxtpAjyNKGiK23zzsDmf48kVJihZKQ7A1WZa1zgYsgmierpQW4r+qcm3w==@kvack.org
X-Gm-Message-State: AOJu0YzMd88MvH8i5hDtPw5Zw9yHeEXJsMxzccVreAs50NLaEyN4n/lm
	xdUfoPSQyWD30C7/6ht7dmlngekqMbjUo6llgdsXCSJsbkwJxTU6x+UXg1o9DATXdOhdSPG48Iz
	tLZrkdX7P+QqGLpK3F7cXXt1yIUqWF2SGdVBdWbcfOomukN1jaz2u
X-Gm-Gg: ASbGncvcAqFSZClzq8EG40EHBeymtrIx2zoW5LZiC5Pz5yv6jPRiKAKsTZoEKyIF5Qq
	eDqG8DxXgqRZ7yVq8C+ZzBAbsKpkX2NL3rryJNduvRWZfNYDzgQOrd4wmWXgB33kNFOOFQd4OjZ
	EWUAiLJMIh1pkg02AUQf5n1rLP9I7gCs38bJMkvGGm6Tsg0Dmg65mSoJT0fhPwJz101ynAlzelz
	tiJAts/xbN/oYm4Z6L/iRbwZLK9dXCPZ7SGyQyK8sqeXpq3WeiA26mpEmgmnZ0GtKEAScRGeVp1
	HOgt39SbkZcR2TW2qAW/SCvzDW53V8ejhenXb/cne6E04qcbDp7lLirR1YfMvsJinmpBmZETq1B
	eGazQoqG7
X-Received: by 2002:a05:600c:c4a8:b0:46e:4372:5395 with SMTP id 5b1f17b1804b1-46e711525b0mr99755255e9.25.1759826863349;
        Tue, 07 Oct 2025 01:47:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6E08SlQ39Ofng71i7oQxAmRBZ2Or1fpuhgdUCreDtV6AJiPLu8VnxLfgqcMNCI0Ol3Lrr1Q==
X-Received: by 2002:a05:600c:c4a8:b0:46e:4372:5395 with SMTP id 5b1f17b1804b1-46e711525b0mr99755105e9.25.1759826862923;
        Tue, 07 Oct 2025 01:47:42 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a265f6sm292260605e9.20.2025.10.07.01.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 01:47:42 -0700 (PDT)
Message-ID: <804acafc-2de9-484a-990e-0338fc525862@redhat.com>
Date: Tue, 7 Oct 2025 10:47:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Replace READ_ONCE() with standard page table
 accessors
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20251007063100.2396936-1-anshuman.khandual@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20251007063100.2396936-1-anshuman.khandual@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OkqpldYtHBsqsrCRtcv0wk9-jscr1akfYPGKl4qV6yw_1759826863
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: kne8f7p3crz57bdxkj7h3dhk6oo1f93f
X-Rspam-User: 
X-Rspamd-Queue-Id: 88DA780015
X-HE-Tag: 1759826869-641958
X-HE-Meta: U2FsdGVkX19wZb795n9euRQlar1/kMeU95Rdc/8BsJDjm068mOJEReA3FY+YZCypVsH/sks2MDLhlFuFN2+QsQ6pOP1/txoKdtDoG6Q0f3EM02fLADAeXly5vr7FHv48x/Ik6V/aZOz8v9xxjn1scZkPhcjUstdDGZdoNE4DZ8L3KTKt6fCaul4ejrbrGoePWAeNT2sIfUxRkDRwRBWNkEUKVtK3sjCLkPEo7gMg++zTrQKIqyDSzPWOl1qWr9A8izrL3Ew2MzBOEekrHqq0ihrL8C7D05qNDdaqe8SS71CE1bJ5oFbqoTm6GgNCyuD3nH9gDB7Y4Ygd2qkBdjXoWWbqZsUKR8jFYcPR0Pu+yhuwj6JqS9Cd3VtRmeY48AqIhuiQIr2+c/eyQT1Midx8zcB5qT5/N026AwCOsQ55ZaPab0Bbi0JzN13lJRfy5i63cLSoU15vI46H9zvlL2/NMw7hauM6mSU026L10URTRD07qbIRXsywKuy05FpMYMCD39C7zhGiww/21UMeLYpLnODo4bmmqxTvW+BAcGoD8SmGHOf5U8gZI7AhKhu9HreK/WX3+aN0exhhD9hUKH5qzjJEo/99zqzRfmgeArZC1JFJoRD3RxysplshIgfw24Xtx8GfE6L1YM6q55F+ahHoJaPePUeDv4gXuXe27P0neNSQJj7Y4nX5obAn3NtRBl4k15ST9H2eV/IfF+ilX2S89K0mXQlwjhxZPA/h3/MxgweePcmXV0aXuJ5qkrFk2L8NR/mz/OwwfcEY+kVEVmeSNMv/laxWLz7PcMWetH5g9vfB23cn7UXIoWMkCE51Z+ni1kKjtWYptW7HqAKohR5VpIWWd7H88O3vPEsaJ1C9c+aCj2qGueMSDRXriFI1RxidPq6Hstgpdc3OT7H+jvQT6x3L0hhQQKhnMRJjWOTFTX9rJZ9lR/rVpLOmqkM2NvKGf3C1DnoybDHmkueUr6Q
 s4lYMAYx
 CaJ5gpUXxDkAmgLZRfA3ZKPadFZJQ5xQl8bQH9pSkF0teS1RjbrbXI0xL2kKq1vjLfxWuazOrWCLAEBUeLD5QwLG38feTbc1Q3LzaHmNEDsztGzQoWO7x2wgRYmMOWyS2sK0AFWmEmzcz4wX53rc4kahDzt2+O2ehP2DIJam492RFwHtMQB9o2QNIbrXxP5B0WWCdTuBL3Zwd+H/c4JfdcsbWurQ9/s2Nlhv6Tg9Vbwmru/CSJzUUmc44WlGq1BFRY9f6BYL6T118kTfm1c8EQly9ersdyyEJTErYJeXm4AWLvFjdkDOmuSUoDhKdNmz/TPSU/tWQFxxuELnlYbpwzq6smNIY5Xrai1ZOyE3ZFFNaw4k9Z6MZrTCm2DmsqWYNzYTVfYmoXjOfVor06XVCtYlxkyMR9YEqQlV4VaK7ivBEEjU/9WwXsTfqFTIuu6JmDipT/EUQ9B8Ru20gUOSzxZOGN6dWiw/M05JPEW20liUJy1a2i9RozmXykrGb9dwPuFBAAw1gCIcVbWLdPRYNbshCla/qZvlF6U+IrHPrykABYHO62/Q8Ttd/KRpMNJVKNn1qOw5xzhLLJ3L8NzdEt7dxRwNdGkmhKiy7yBgebvM+19wLVaMVPmfoJ3/cnkFnFErL8cXCf2g0hhwSkaOkEngfF8liMMrb4NXEQjuYEfT6bn/kgwF503ppOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.10.25 08:31, Anshuman Khandual wrote:
> Replace all READ_ONCE() with a standard page table accessors i.e pxdp_get()
> that defaults into READ_ONCE() in cases where platform does not override.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


