Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E90C7CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8268E0005; Mon, 20 Oct 2025 16:17:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AFB08E0002; Mon, 20 Oct 2025 16:17:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6278E0005; Mon, 20 Oct 2025 16:17:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0CB9A8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:17:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BBF9011944C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:17:53 +0000 (UTC)
X-FDA: 84019603626.20.9FCC685
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 721F91A0010
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:17:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RKruVkM7;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760991470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/LsX7IYRgEtN8RM3fhERLxAXUAVS6aaKh4QVGEYl6rU=;
	b=lofZilKf9uwx+WHvYd6Ub+HKYHIqtHWn5Bh39+D45PV+qf4iofVOQA62lWutzFP/462tSx
	9Klucvn1a1C4ZHFotMgJ1Km8eBL3sXsva7jaVBH1fqoOMetDvGyE7cZwSTu5NJkz6tye4V
	AUy5rnMha4wF+bSoiwr9osEHl0pqQ0M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RKruVkM7;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760991470; a=rsa-sha256;
	cv=none;
	b=qEomWLQ+eyHG1Ln2OpBQvvmxjS8gEDi200fc72wkkMRt54b07SAicYC01hLQr4dkZhzwbf
	AFYE//X4z07DQKLHkN/HSvIpupoyvyU3vrHxSRnGpstjZAw6nUWpROuV1ufBnG7WvcKBpe
	tzpju7B4LVrW4xkkpbam/1p+6iYR2Vo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760991469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/LsX7IYRgEtN8RM3fhERLxAXUAVS6aaKh4QVGEYl6rU=;
	b=RKruVkM7GgxQKUf5ENKgj4LPWf6Q+RFOa7Xq2y0/XW/U3O3zyjmTnAsi3T5mnzsm8Dm7Ft
	QIyxwcEdYnm1qQXcEPrNTYUpoaeAOswhZEXE1qtxDG1WExu9j+9fPp5K2owDMpb58C5HTM
	CZr/2CXBYGpXqRRSFEzHdnA3XZ6qtj8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-i5DC56LRN0SOnrU2JHkswg-1; Mon, 20 Oct 2025 16:17:46 -0400
X-MC-Unique: i5DC56LRN0SOnrU2JHkswg-1
X-Mimecast-MFC-AGG-ID: i5DC56LRN0SOnrU2JHkswg_1760991465
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42705afbf19so1857366f8f.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:17:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760991465; x=1761596265;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/LsX7IYRgEtN8RM3fhERLxAXUAVS6aaKh4QVGEYl6rU=;
        b=Uwa6Ybr5vsniY8/w8TLNk2dsvPzVpn2Uor8DXTUl2rclnoHiqs1+lQ+q2GydUeeOEl
         Hm7xwqgvV6iTQv/3IqSasSidI8ixQ6EplJp77qowlZgKjzchU2gknSR2+fofK0Li6utS
         bLNe1uD7cXfVKuNEhGqiXBHp7BVnuUewJfyI/F3dBXj+OkX7atZLQUVY+JuFirGcmjyM
         7fBiQOM8Jcna5Zyegd8Ox4/AoaojkegNjozp9pPwN7uGp2TfsxljQqBDcVUEYwMiOYv4
         VLWQfPUijXpK8tepCYRVDG3QzlqQbOKWGaDxIIDAethUmIBV3BdmHh47bm2/A/9IqOtP
         wjuA==
X-Forwarded-Encrypted: i=1; AJvYcCVqelPTyW5LWKVECVgHHWRLNTZVpXz7OdmdsGPDvF8NLhwNjcZGm9vbOuskH1Mp+GyCc31VsqEXUw==@kvack.org
X-Gm-Message-State: AOJu0YwOFAdcf42zbMNidHoLOAbS3c0ZJ/oxF/y4g6DofY/ToCkonfYp
	AW6goCeRQvPUcj7Eogv26OO7Wysa87jPSkXs8bS/LgPgbPsNZfubasfkv7CqYHGjbb7BzMchtWJ
	3UgVH09nqgpqNUiUzJSg1wND6510Evj1QEP1FyvdjuHqaLf8Jpu5v
X-Gm-Gg: ASbGncvo/VXq6ASERsxv2aN2qh437fM/IqBPbjebAgO3rqO/5zd5WqPMR1dO1cVmnUV
	YtsI9JJMLVKFMkSOUpPygxndz2pZARb9+zocMj6HPsyMtV1oeJjThVj4jt7LAVesqSZgAI/44Or
	KEFK5CeUgDdf0BHRhmDHq6CBB8snPW28RtAEUrN4p19y0ZG4p+zn6Ewxye4u052AREphxucgVp5
	ZEjqA42mPV8J5VdJMkNQGGmCwD7WE3ZUqrjtijvv6KG6MfNyzrsXOjSeyEdcM+dZzW3UEII7I7n
	dj+2EGHZuZb5JGpjdnv5dst5p+tY6/SD2rkFNQgVTd+dLspnQdyGlPn+NUUX+jzBUvkE/uRCRpw
	g+HdzfPSu2QoJc5nd9oTd589bhIvYm6eYAThJCTCYu5N6DrVoNP5a51DRhYhwuNdLpV8t1kKn+H
	+g4Lx0XAV+D2nXPjGvH7ecx4lh/hE=
X-Received: by 2002:a05:6000:22c5:b0:3ee:1368:a921 with SMTP id ffacd0b85a97d-42704bf7238mr11374813f8f.28.1760991465003;
        Mon, 20 Oct 2025 13:17:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEuTyy6a9nphDhsuKGtPLcYJ1/Tp5XQ7o58XrEQGbeb6HrD9v7YC6cKG7PK+8bfVZuFDHicJA==
X-Received: by 2002:a05:6000:22c5:b0:3ee:1368:a921 with SMTP id ffacd0b85a97d-42704bf7238mr11374803f8f.28.1760991464565;
        Mon, 20 Oct 2025 13:17:44 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ce678sm17029551f8f.51.2025.10.20.13.17.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 13:17:44 -0700 (PDT)
Message-ID: <451b72a3-8052-4dfb-84e7-1e97c3388db0@redhat.com>
Date: Mon, 20 Oct 2025 22:17:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
To: Gregory Price <gourry@gourry.net>
Cc: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org
References: <20251020170615.1000819-1-gourry@gourry.net>
 <487730c6-423a-4a03-a668-9b9ff92a5cfb@redhat.com>
 <aPZ0OKx_VnQ4H_w1@gourry-fedora-PF4VCD3F>
 <609E7E01-33A6-4931-AC89-1F4B2944FB64@nvidia.com>
 <272c425a-b191-4eef-af6e-2bca1db7a940@redhat.com>
 <aPaQNYsN_YPDOwQG@gourry-fedora-PF4VCD3F>
 <0d92a675-ab24-4b1c-be71-956f09a9e973@redhat.com>
 <aPaUZm0ZfIEW3gUr@gourry-fedora-PF4VCD3F>
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
In-Reply-To: <aPaUZm0ZfIEW3gUr@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 47JPoXbVnorDqCtXwO_aSVjbqLEQ6cVOpC_caQCwoiE_1760991465
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 721F91A0010
X-Stat-Signature: uqjt5d4yfrxnt5bynhu1jbinbhhsjbyq
X-Rspam-User: 
X-HE-Tag: 1760991470-780997
X-HE-Meta: U2FsdGVkX18RZ0S2P51VDuNO0PiM1AMTSEr+7l8K9fm7T8vWX9zlKf+/OdnUcjh4fQbt0/HsqQHlS+xb3yte4nr28V9L5EjjuX2DdoL+8zruyqqJmEeOd6ZTyDDn/0YxbovG9uzDoEEGkEFWtUzMKGokfaU2yt9L+5K92ZA4/cbZimcnX42ZqiH6JY/ClAbzXvgGQQX43aXflv7MfOWHZ1Aj+CkxPK+YtsYj5xtdi4vzgv1V6PSFdrOt+5PTZdh6wGaCzPbqNHJxa5Lifu+xe0DOMjxDYQofl8FFoNUXFofOk3ZXhpHKTZNbyyzbskK9KWMapDv+OEqKQASOJsc+dTLulHbyNZKpIMmjIwjdukboBCBpgNhgdYtFY5I4jSt245FTbOQUoARu6HrklZ5Ss97CWiehrwGObPJwuGS396CyT3yjYOGjoTBfzElSZUQGOu92f+Ufegmh5Pk/WCvM0LpSdmeMOvgjV3MWJjgp4Eq8tk83NY18SZX8hZCbV3kPKfZtCeTkg09XMIhlz0FSKXiLfJwvB/WpSeu/eE7tBvndL8bsGlLKtWP1CF9Hg9SY3bo2+tZHLfkcHyrP2y6LL7uYaVc8nw9atAv1wDkoeYYfPLW86b2vROkM0KAmy/tk+p6nHqcihgK/rjDXQXmLD+nN0knyBNMHDDQOgn2WlpsCLBTQICz71SrcNYqcTmojQUrkhYTNoVC56RoihhjFTqCIZD8Bf3mB1taCkxFo8+1TqPY4oHhGsiBYllbfNWDOjVQZUSRM2CTC20fWll5fY0wCTWITkKhV7CMQGdirU55zg4yC//3SzktdEivUvk5daNQ26oVP31iNl+//UtxK67HynHBHfVSZXm+jQjUs61r2sLkwOZi29udGfSoiPsnlKF34XE4oMjPQxGw3CwINZqS5pdy3GHgzOAG9xdHM6OMVZluO7Hkjpx1IDFO5/W1k41Ifgjqgii3csxoBSOI
 iA8HwhG4
 QbiXe/Bv2SuAyvbNkSC0RS9+ZcgkTy+EvXX2fkj+s7Dk+FgjIzRVERZiMz+RLvIZFdOA/64M8Pyh3sBRORKyIYkOsnabDlIDner99WZiNJaDThuFsLdR2PCn4W6JonzH3Z2v5ISniDMEbMoq+nTwgAVFZCjuR6kPmBVi+Aqz6p2Gere6Trhti8FYQfJz+JqbdW7UpLIWyb6KXaxD7sDH+nfowFq+umeLXaqELa7ppdwxBfjmu2YO+G7Wu6XZChF2hLVIUfJhio3BN1jJHm2Zqvzc19OOLfCPihFU6303W51VeAzVgZItL5PRW6x9r49qzcC2VLFl/zUcCMP1DsWPRjUk0eOQLYQGRKynhBDDpDMnspvM2iWM2JFyY15/cme45SkWu2ZDES07O08yb/EvgUmwAliyjRdZaR+G9geUTySweXbC3AWhycUtIoPUR6jzmvj058XMoUJzu2ZEj3B0+oVLkFTF84lB8FF3B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 21:58, Gregory Price wrote:
> On Mon, Oct 20, 2025 at 09:46:21PM +0200, David Hildenbrand wrote:
>> On 20.10.25 21:40, Gregory Price wrote:
>>> On Mon, Oct 20, 2025 at 09:18:36PM +0200, David Hildenbrand wrote:
>>>>>
>>>>> Basically, what is the right way of checking a folio order without lock?
>>>>> Should we have a standardized helper function for that?
>>>>
>>>> As raised, snapshot_page() tries to stabilize the folio best it can.
>>>
>>> is snapshot_page() even worth it if we're already racing on flag checks?
>>
>> I think it tries to handle what compound_order() cannot easily handle, as it
>> will retry in case it detects an obvious race.
>>
>>>
>>> i.e. there's already a race condition between
>>>
>>> 	pfn_range_valid_contig(range) -> compaction(range)
>>
>> Can you elaborate how compaction comes into play here? I'm missing the
>> interaction.
>>
>> pfn_range_valid_contig() should be only called by alloc_contig_pages() and
>> not out of compaction context?
>>
> 
> I've been digging through the code a bit, so a quick shot from my notes
> 
> alloc_contig_pages_noprof
>    if (pfn_range_valid_contig(range))        <- check validity
>      __alloc_contig_pages(range)
>        alloc_contig_range_noprof(range)
>          start_isolate_page_range(range)     <- isolate
>          __alloc_contig_migrate_range(range)
>            isolate_migratepages_range(range) <- compact

Oh, that's what you mean with "compact", it's just isolation+migration.

> 
> Seems like all the checks done in pfn_range_valid_contig() already race
> with everything after it anyway since references aren't held?  Any of
> those pages could be freed (get bogus values), but i suppose not
> allocated (given the zone lock is held)?

Yes, it's completely racy.

I was primarily concerned about us calling functions that will 
VM_WARN_ON() etc due to the races; not that they would make us 
accept/jump over a range although we shouldn't.

Of course, regarding the latter, we want to try as good as possible to 
avoid jumping over ranges that we can actually handle.

-- 
Cheers

David / dhildenb


