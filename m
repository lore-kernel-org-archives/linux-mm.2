Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9C09CCD19F
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 17:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2344E8E0006; Mon, 20 Oct 2025 13:24:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5488E0002; Mon, 20 Oct 2025 13:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D40B8E0006; Mon, 20 Oct 2025 13:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EBD718E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:24:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A64801DC9F8
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:24:12 +0000 (UTC)
X-FDA: 84019165944.02.0D76DF4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1F8821C000B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:24:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=izzz8RtE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760981050; a=rsa-sha256;
	cv=none;
	b=hA+QFbMSKWd4uBVCND6dZ24glsfEP+dp/32hlNYm1CK7pLYfUA4hY789R4kTyCzT/Qy6JO
	xJezBHD7aUbYB+AsK0IXt//f0UIrkGUVjvRcgQ/ueLuX49iyjUBYPVcSXKRbcPoUdkzvEq
	72KuPnyQL3mz3Emqd7vHq1MucNbjf6A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=izzz8RtE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760981050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkbmHRpDCxeDNyWG0JbMmVpVwZeYwoVX6o0X4ue/QI4=;
	b=p1ojTdGTLPfCh8oFKBXhaC3r0s0XMS4UrsFhcr4DhQWon9xwBP4blNcsOunHgOFhCyDPdk
	dJ2/z1+GbFXoAp/OrTjDagW6JfJsfhrdKTt1dNI1A0itxVx8GpucLaJR9prEwXv/CAYGem
	KqBLfeNoAtUUrz9C86CRY6zCKT2wls0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760981049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PkbmHRpDCxeDNyWG0JbMmVpVwZeYwoVX6o0X4ue/QI4=;
	b=izzz8RtEMuui9wDZ8EDGQzqfN7CMIZEptM08n0Ut1RKsn1657ri0zpeEh25f1QTZ6RI8Tf
	6QRWD3njsyYeVeBpaYq7ddox+3ih1o189hXJESABFiOcX9VMWjyvakHTYtMIrzXcnZqIJ7
	SNMuc0zln20AhqU6une06oLnB43eEGg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-793pq1UzPsGQJzLckxwY9g-1; Mon, 20 Oct 2025 13:24:08 -0400
X-MC-Unique: 793pq1UzPsGQJzLckxwY9g-1
X-Mimecast-MFC-AGG-ID: 793pq1UzPsGQJzLckxwY9g_1760981047
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4270848ceffso4903157f8f.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:24:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760981047; x=1761585847;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PkbmHRpDCxeDNyWG0JbMmVpVwZeYwoVX6o0X4ue/QI4=;
        b=XIEMuGN0a0oH7RAzEIYoJXQh3Hs/OUuN30YBbgoB2CmwhAWbpl/jerbT5KE7iO97pm
         uaS5Pz3niOnzILhM6e4FM6aCmYcZYgCB6rZPLx4YvTOdLDDHaEHK8gMnCLcEEX4t7yo6
         3v3MQO2rNem6Gh+tgaFU5tjfbSE5e5Mk0lWB5BL7ei6k3iu+9AKnDFnE+KvGkClCjPbk
         /Te+xdvRS3WD8kbJ8065U2QdojPEktKT4GYVVDho0Dt1lXfL//ZnmMnJc50JILeEr63S
         qTPET/Lk6DDUcnB9/w+bWYTTHMZQFzubcWgvTUugsKFuxXMkDErrm0NdXzyUdaChXLN+
         FaDg==
X-Forwarded-Encrypted: i=1; AJvYcCWir35rnoYHN3Xtdi1be+X1xhhC6sAhlcpHp8FmxcSXv1JIPTP6R2nNRejHeJz/YhWYfDv5uWeynw==@kvack.org
X-Gm-Message-State: AOJu0YzMBLtUazyQD0hrhSQ6XVKGNXFf9Cgy3t8U6aDXWjLXie3pfjMG
	QOjI5RKUJUXHXzE75KpdgPPRkqAGEMJ/OuAGILI9103WfIRNeszKxw4Pop0qp/4Nl0u6jKQAwuB
	2SyK+CU0eem68IMp0qpGyGlRK7qmOT/CEPo3TarR+ziFzBir/Wl8+
X-Gm-Gg: ASbGnct0z8QaNwWdqKZcz8IIazRXvX/Wb8Oy7Yw7UF9km43lSeaje9OcNyRu1RMhHtI
	x72CSpFFoQvL2+i2VSp6x6OxgvXLeyYTcx6itar+bLme061plNX4tjkujN3g59bx0kA94HWmn1h
	RWnxxwAMk/WE15CCXwxR+h7clse9dIX6P7Y6y6Gb/VzIAeNDc0R6YaJwD2sPrUw/JLNhHlKsTts
	asZ3S+WBz30ITUiXg9gJn9C2OFTmufCZSDoZxslgGoSUtY108uxxaTzCamxvrFkhKGuNRcRd015
	zc2bI8BipEeMZ2Mm5wIFuyFIOieoBD0PugctL3am9ZSAIWk4d5ng2NwQ24rcaidHQUVhHNzvsRH
	QOg/XP3z97Ymqfp30y9NdDe6QB4VmonGBFm7NDFmjY7XJEdIhYpDEy06xEoUs/Up1tFd8/iuiUp
	zehUmASjH9cQfWEgtVQsIHk+oOCeE=
X-Received: by 2002:a05:6000:26d2:b0:3e6:f91e:fa72 with SMTP id ffacd0b85a97d-42704d83dfdmr8237940f8f.7.1760981046810;
        Mon, 20 Oct 2025 10:24:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtZi7BkIMkMcjZVLDSYdQKUlTpcWMTz2FEi6s+HPJefynVtdLFdvUqgsu8TTNfqXt1CY23BA==
X-Received: by 2002:a05:6000:26d2:b0:3e6:f91e:fa72 with SMTP id ffacd0b85a97d-42704d83dfdmr8237917f8f.7.1760981046415;
        Mon, 20 Oct 2025 10:24:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47154d3843csm154741245e9.11.2025.10.20.10.24.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 10:24:05 -0700 (PDT)
Message-ID: <487730c6-423a-4a03-a668-9b9ff92a5cfb@redhat.com>
Date: Mon, 20 Oct 2025 19:24:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com
References: <20251020170615.1000819-1-gourry@gourry.net>
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
In-Reply-To: <20251020170615.1000819-1-gourry@gourry.net>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s-dRs10A0fZO1HqaGmd-l9ojCvlkJpUixAdQftDce0w_1760981047
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 84xp6tcrdwwymq33jfm9jkg1yamndpob
X-Rspamd-Queue-Id: 1F8821C000B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760981049-40568
X-HE-Meta: U2FsdGVkX1+0rMl2h7oLWyGhImMgCh+P21bPwcYVj1KmBsRV9vMfpld2GKRsZr1JyzdQGo+1WSTl8JG0GkIoBss9f/3vHKwSkEwt6N3o4OpugnotmWHBMjva0nl2SvMiudCdgcxXM6CDEcnLL5wznNbrVhDUx+FfK33n+1ebcIWiVB04uH4IVCCJ6q2KQQCr4v1xuQtDa+Z2p7Y/YpSnlKAZlooDWe13R7vgmBVGuN73BNHV47CujN4NfObtxriQ9coSj6PpDhrNDsQp5OsEdtFuhzeOQlTHnrSnykn23bsFqzqoqlmQMPDzek2XZD8NEuCLPRxwpt2vsfu60Vdm5xiJfwPAFHr056Bxf1ARjh0NDfNP4M2Q/wzOrm9tZ/qLxj7ZIZxP23llyhfEOl/Wu+MTkLq0F9kaJJrRfutfO3Sbcg0eK3/dO70euVpMYgVD7GFCW4ABYKNmhtgMpk+ixXVqSyfQC9u2e8RT8wEaaWmPUrY7tNsSo2FWjft4DtUMuessdPQOkbbJyVHrY3comdC1BVNljd4JiBSE9ZhHGRG8SNDdyM9PzJlcIHYKcd8rTvvpLZJpCCgJxqAdpFNSPow43QH7esLL+lMCwpTlfuVAmmT/EDEJJgVvPDTQMY5jKdg4PALziZQG/ENgAwfwIa16p4znkHdxX9aBAxaBAiWEFI9G64ciD9aKcYd31vwZLqCT11VC9cHzLvecRGWWHe3o70Cs9l/40uRol90hWGYSd1Yy3TmwFpuf/oEr0Cpptz5iyzqCSzCy4jdYcB9o/tFvadkuYVBRWjHhAsthTYWiTy91DnTjtuAVHJ3t5efdrFsn1E6v3gJ8rbG1WYX0OhrRU0NW6tQUE2jeqZkl1SLjBmAj00RVf9KfgHCJFpFhzO4qAjos1Axf+bRkbpWhNUgArgjEhvPmpCnfkW2kAtfiFh6OQ2L93rQxq0rC5aq09Zq5heQ2I5aWCqbIY09
 YsJt7frr
 /RDmW8jyDeaDKDSbOj5Z1TF5H6wsGOq/4UhIcJ0fOKvDTdNzDfksbPP65trVe5p3xdLMZUlzi9Cf5ONkSpmsdJ/I4lprvwMpVVKqj6hZWjpCIwLwhBG5j68vPo8AekUKhyyFwtHJqZ0ec9Jf4FcP60afuKRYG/oTzwDgQ+fG9cnGC4QRpW8ZzQl0KQaFeDa6p8HTnP1dfKg1fGgRiIQ2XkSFCMrTrfXCrZss5TK7aL2CqXJHGWLw4e7hgd7RHWKCaOI9H44++6CT8zRb+gx2BNclfM+Zvzm7AZjl2uAJkYuKpDG54DzZQGcZZET0+eJPGow+SpQFSB60GEooADVrvPg4lRRNxBVcb6d58pCf4cq86a6aypuM+4Lkfkpw+2BvwCsohvJd7QpS6+mCoVIfgM2nSVYtvvgl43uh250PzToWD2AYqvYKA48Yj8PsKZ6Vacsv2tHYkrn186NelI6MlCHcxCdW/J3Ds8P6egtUiCsH9USvz9Q0+bSGZw7Qxnypj6CCQIbqGB5AXw3Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 19:06, Gregory Price wrote:
> We presently skip regions with hugepages entirely when trying to do
> contiguous page allocation.  Instead, if hugepage migration is enabled,
> consider regions with hugepages smaller than the target contiguous
> allocation request as valid targets for allocation.
> 
> Compaction `isolate_migrate_pages_block()` already expects requests
> with hugepages to originate from alloc_contig, and hugetlb code also
> does a migratable check when isolating in `folio_isolate_hugetlb()`.
> 
> We add the migration check here to avoid calling compaction on a
> region if we know migration is not possible at all.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>   mm/page_alloc.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 600d9e981c23..e0760eafe032 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7048,8 +7048,14 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>   		if (PageReserved(page))
>   			return false;
>   
> -		if (PageHuge(page))
> -			return false;
> +		if (PageHuge(page)) {
> +			struct folio *folio = page_folio(page);
> +
> +			/* Don't consider moving same size/larger pages */
> +			if (!folio_test_hugetlb_migratable(folio) ||
> +			    (1 << folio_order(folio) >= nr_pages))

We have folio_nr_pages().

Do we really need the folio_hugetlb_migratable() check?

> +				return false;

This code is completely racy. folio_nr_pages() should be fine AFAIKT (no 
VM_WARN_ON() etc), not sure about folio_test_hugetlb_migratable().

If it becomes a problem we could do a snapshot_page() to take a snapshot 
we can query.

-- 
Cheers

David / dhildenb


