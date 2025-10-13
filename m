Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB334CCD18E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 15:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00BFE8E0062; Mon, 13 Oct 2025 11:58:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26278E0009; Mon, 13 Oct 2025 11:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B9C8E0062; Mon, 13 Oct 2025 11:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D346F8E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:58:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1EF0160529
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:58:45 +0000 (UTC)
X-FDA: 83993549010.14.252AF19
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 40EB6C0011
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:58:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HS7BszmO;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760371123; a=rsa-sha256;
	cv=none;
	b=ZC+39w1EDmyEVBKxB3/TeVhgSrpxXuaKxNAAExUp96z00ZLovy4a5JINCnZEI2jINtpfkk
	EZAJTpm0aEkDSLD58Xop+H/dN15BpiLJIpcoITQuqGIqepEbwELaQn05kuNTbWEZbkru45
	ArymPz+X3MlDybIEEqqSvJ1o/DScMDw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HS7BszmO;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760371123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhqVZ82yjs398U7dfgkgEZ9qhoBuSaoyMXHZDglLE5g=;
	b=rdJGghKfP2ObwxA4mcsRMShO6V//G+UV+bsNp2kVBxChGD+h7v3gRGTY2wtfrqr1kwf5w0
	ON/pRn5qxsgmFgBu6Q7QBNMyg6XrBYwW4979QpqL1H7r2CKXvzBgtm6fl5a8aJPOM8lSns
	LDd6G6MJ/LaGtz6hK/AmT5lz7u9yYYU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760371122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mhqVZ82yjs398U7dfgkgEZ9qhoBuSaoyMXHZDglLE5g=;
	b=HS7BszmOMpikNIhvutare2mw8hzmtkkuB+38e6rn0yQBsxt7aYYCO7G4gdySAXBz2q/u1i
	Evuiq4N37J7ifOexOq8NjC4AzRMfp6agnqYIZqV0RhzR1DWUhRRq/XEHmBXQDwY5USY4G0
	Aqq8oKSQDhH+pyQYU2F8b/GkmHEFs94=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-KIlTgmBsO426fPRZFHweug-1; Mon, 13 Oct 2025 11:58:41 -0400
X-MC-Unique: KIlTgmBsO426fPRZFHweug-1
X-Mimecast-MFC-AGG-ID: KIlTgmBsO426fPRZFHweug_1760371120
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3f6b44ab789so2353539f8f.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:58:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760371120; x=1760975920;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mhqVZ82yjs398U7dfgkgEZ9qhoBuSaoyMXHZDglLE5g=;
        b=i/IiZAc2jv/BNt3N50IrmW8y/YqLvD5sFtv6F+0Wqd/+VW8aWyxProlCXZECmzhXki
         harcHNz1crYbDxIDqKUqTunONfwJWUzN08z2Hhw51Ybxj+5Ft1VsQS+sE/3sw4aAGyij
         mCOr4wUmzQ2RwUXU+7hW24Yc5LXnrDgLkFutcTyWThm2fgEhpmpE+HqsUZnaqApXWF97
         vdemcZOzB9CXKOgd4nBf5irK2oQF5KT1jU3UdUtUJ3fHo3ZusxAv/dKxALNh6EF8FjAC
         FnP3TkTXzMLfsLpjwyek1mmfHwHu9JW/rblJTG9HIxQexgO0YUVgkzhpfYYn4+6oze9R
         hLiA==
X-Forwarded-Encrypted: i=1; AJvYcCWX8SrqykbcD3nWNF/XRj/AcLusUf3+ckvARH9f24VpPUP+MA1lc/2PfwH7JliW2arqeN7wesHO2g==@kvack.org
X-Gm-Message-State: AOJu0YxAQ8WM6RsHxqJVO4r4G/uaTm1XAW8PNrNZVQJdkK1EXsUs/N6g
	oY5m46otAdCjNfDGw+0+BevQUK6/EudZ42UtltCen+SbbCDFBnICQMVuba76RKh0OgkFQAnojN6
	Jcwm4JGJS7+OX0lZN08RBPNRyXUXAKFK2nsycXV4RqfE9HTi5VS9l
X-Gm-Gg: ASbGncuOJe3+sesjpqv+UC6kflK93BzmExDBrL6v7IVAyxJuVN0ypFuVxx3pcZ6dVJB
	d57mmBjc7DcH6JKpT8WPb1I8jCoPVFxAeYuysdMggzCqsbRAbXJWLDoMaAbt3UyVfTlH1f+yIwr
	223DVR+4oVx6GTctst1pXn1PGX2kPqffYLB+Z6HzbZ25F7XDhbzzGhIFZgmz4f+B32jpJdPWHXz
	mQXAPDxzO80YcvokdnkFgV5ZWegrZgUipj05qpQ7Zkjq8HmdJd0jznLG9fQF7bXPLsplyZ4o+jZ
	izEFv5/PTBnFnOV1dYEJS2Z2ZoHWS352N1TIjBvB4surHV0sNvBMTJHf0K6Rs3F+j9FHo3rkiez
	LjYY=
X-Received: by 2002:a05:6000:4011:b0:3d4:15a2:11e9 with SMTP id ffacd0b85a97d-4266e8e4788mr13364624f8f.61.1760371120047;
        Mon, 13 Oct 2025 08:58:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHpEGh5CSODRP9iwJYnImy84cskuvwPy1p46x34JkZWhYvauAsZcZW2b8SFU/zfH0oVCBTtWw==
X-Received: by 2002:a05:6000:4011:b0:3d4:15a2:11e9 with SMTP id ffacd0b85a97d-4266e8e4788mr13364600f8f.61.1760371119625;
        Mon, 13 Oct 2025 08:58:39 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb49c4027sm189378435e9.17.2025.10.13.08.58.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 08:58:39 -0700 (PDT)
Message-ID: <c31abe19-f13c-49e7-b305-d899536ce9bb@redhat.com>
Date: Mon, 13 Oct 2025 17:58:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] mm: huge_memory: use prot_numa_skip() for pmd folio
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
 <20251013121536.2373249-4-wangkefeng.wang@huawei.com>
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
In-Reply-To: <20251013121536.2373249-4-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cUR4i-i3CQDgU_xYh-m9WJiP6EWwrtMtzV5y3-G_ru8_1760371120
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: w9nr7q9rftqahempgj4743ihhom6bjd6
X-Rspamd-Queue-Id: 40EB6C0011
X-Rspamd-Server: rspam09
X-HE-Tag: 1760371123-24125
X-HE-Meta: U2FsdGVkX19EtRctu3bS/4PfGXGPXi1QHgPMxWc9F3rhw2hTy2pW6LD7RrWEdT+WSGP5MjJXnb8Om9ZRJdJOLre5DYW2x1/TDpe0QJPHhYlmA24wx7PyHjZ5uCG2meb4P/aME18jkt1/xVz83Gj+DqJc/U40Zy7eRF/a71dbXBlUpBoCuqvp9f1sR8GjwU4Det04XGfQMbtjtj1lQ3hN/I/MAe1M/xKVIax+LxzeQAj5X+d7+nm6CpdTh7zNXmt1NURUvxmV2Nij8HuTtAEQ+e7KHEUofhjEDEagP8Adeyg+sN8awUXppovVHbFwXtUjpBucOwFSEQwBjAV+n7aJif3CCiATvstj1DLalrz1zqcf65XknMM6uV9bHD7oJdewlgzJJJ6SHC/D3u4EgbeA0XyUveJfN7fQDJIL5DLJKi6+p3u3DuWw54wvyMFfC4Q6/OtvngdIxS/POKJOh70LDb1O7xX9XdAkhE6pjHmHNx5S0NU90lTxAW4F/bncuPNwRSW8u8v5WfP22cGgLzikQiLxLYn7X6iysN7DcBxGu0+/9hLV2m314udbPSmDZYGoPKhhVVT03NL8fC9msa3lMNv1iOHF4PPTAFw5KvK33MaXCN8k5V9pYnTEF9LxglUj6lG8ofogBlwr5Ko9/7BwdID9v8Umht76ruAa3Oebumoi4DCTHumQSKaRYFUHc/qbUvIEsxXbqfrZaYSnblcrQ1Omjprgk/w/tpXZ/H21wMMbffclvQdrDa7aChHfsp3m9qmneZqX5ijaADEtcnZJ3GoHHwBSv2/reg35OKEXvM9Fq3EhovY8kxMVpoMpvDLeEfzxae7a2JndUKdAEL0tzV5LlBFb4hMKI//GN+vTo0NRrpWVDnDOKko0nXNSiCZdE65gXD3C8ZGPGN39x7UrveQJqwooRTwSbY+M/pYhHIv5NXtqtSlQR98TRQNmSNjH7iBYYDdwWaPDAEqAGGf
 PFkTqRZO
 Rsw9W5sVRCfpQR6Q+SUf/6ptcVAfOSrJ743DTPhc9NQetxzBQltiRpF2QpyJHc8Mkcwihs74tZvd6ZIloJBCoaFf8pRh3Ww1OO9KPDBqETY/4Qb2dnK1L8rVnl9JA4m64m8sARN4cL/ktVxOhtnL6gHdBMRzFfH2RUnA2zRct2VoSxmaJXVdD/aUzGHKgT09Fg6f7nLsb07vMoxPE8KrB4ztSwHICOLpgZFWZktUNGqfeq51K46EaluD+5B68txmmgAQ5ENZNS4Ttg8vLZJrvKk1z3hSm9hKkYm3OurOtVXS9h3AtdFDnjM6zH7KtpuMTbeAtrxtb3snfq5Uy966S2e2BoCyd8MTL095448JlEiCU1+Rk4EeNb2vsUKuSM+lV/0MK/zxZC9Sjm4RTDb2BMa279DpwMCSA5ovfd/rGw9tIY1Zr7E+5eS/zoIvS7usgGgAOxkab826RjQI2mPkPqzR9lKRl9aXTz3hNCqK5wTrWy8JOlDHgtrnlt06lZPmtetfiMTsSfwH5ExoirbzkmdonPnS3mN90X4GSYtB6CLQ/Gt6G5f+MUJbNABXS54A+xk9H5pzSEtOk+/E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 14:15, Kefeng Wang wrote:
> The prot_numa_skip() checks should be suitable for pmd folio too,
> which helps to avoid unnecessary pmd change and folio migration
> attempts.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   mm/huge_memory.c | 21 +++++++--------------
>   mm/internal.h    |  2 ++
>   mm/mprotect.c    |  2 +-
>   3 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1b81680b4225..feca5a19104a 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2395,8 +2395,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   #endif
>   
>   	if (prot_numa) {
> -		struct folio *folio;
> -		bool toptier;
> +		int target_node = NUMA_NO_NODE;
>   		/*
>   		 * Avoid trapping faults against the zero page. The read-only
>   		 * data is likely to be read-cached on the local CPU and
> @@ -2408,19 +2407,13 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   		if (pmd_protnone(*pmd))
>   			goto unlock;
>   
> -		folio = pmd_folio(*pmd);
> -		toptier = node_is_toptier(folio_nid(folio));
> -		/*
> -		 * Skip scanning top tier node if normal numa
> -		 * balancing is disabled
> -		 */
> -		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
> -		    toptier)
> -			goto unlock;
> +		/* Get target node for single threaded private VMAs */
> +		if (!(vma->vm_flags & VM_SHARED) &&
> +		    atomic_read(&vma->vm_mm->mm_users) == 1)
> +			target_node = numa_node_id();

Wondering if we should move that hunk into prot_numa_skip() as well.

I'd assume numa_node_id() is not particularly expensive?

While at it, I think we should then rename prot_numa_skip() to
prot_numa_skip_folio() or better "folio_skip_prot_numa()", making folio 
the first parameter.

-- 
Cheers

David / dhildenb


