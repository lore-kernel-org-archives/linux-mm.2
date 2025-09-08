Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B87F7CA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 213DD8E000E; Mon,  8 Sep 2025 05:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EB2E8E0001; Mon,  8 Sep 2025 05:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA1C8E000E; Mon,  8 Sep 2025 05:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED38B8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:12:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 997008704E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:12:24 +0000 (UTC)
X-FDA: 83865517008.20.28B7F6A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 31DFF1C000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:12:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Q+F/kAG7";
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757322742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMk5fbLvH1OztzDpgTc6cAL60e6T56EOEU7K8zpDFd8=;
	b=KXG5AaF9nLo9X2zAjlyMZHPviSv5Q76+HpXJdPARgU5LQief8v/+B8t3XgTuuAb1iVEsab
	ckPd2L200fpLG3oT1dazJysUMy4XRpJio3IyidbJX2vKT/rq5kI3NPI3IMz7lKA+zCQ1Gc
	27EqxrdSNaCMI2sk6crS3xPKPzD5VX4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757322742; a=rsa-sha256;
	cv=none;
	b=e0R6xshvLB6lqRpFNb5YJl4K9eXmQZIAur7bxHPvheuH52LzEgtag4hP31krRIqJMiIwl/
	a8JmBOxVXzbemZKjRGwU54ZYobx/vNEWFWiAMa0pEfWDytGp7oIi77Ayrj0DB25YLpcV7d
	DcNhyBP2vt9HhDmax+Eju3P5/cS75s8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Q+F/kAG7";
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757322741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rMk5fbLvH1OztzDpgTc6cAL60e6T56EOEU7K8zpDFd8=;
	b=Q+F/kAG7TvbeZA2bZJ6Ufz51C0ctin60uTLO+rBlkKjBJJAT1J1s3A6h5zGb9qzdKNC/OO
	h3XtX6eGGoiSfwPc9RcLHpx31RIZocP92T2uT4tElmrOkBHrFC4hueaqrVKbubGtNpVyD6
	D3SfJN6ITmrOMQw99wb/ohMOkYewjWc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-jamvsPTdO9C8rY0IBl7uXQ-1; Mon, 08 Sep 2025 05:12:20 -0400
X-MC-Unique: jamvsPTdO9C8rY0IBl7uXQ-1
X-Mimecast-MFC-AGG-ID: jamvsPTdO9C8rY0IBl7uXQ_1757322739
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45ddbfd44aaso17974795e9.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 02:12:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757322739; x=1757927539;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rMk5fbLvH1OztzDpgTc6cAL60e6T56EOEU7K8zpDFd8=;
        b=cAZW7XihmsbiMxXx1eYcBZm4SZbh+5jQvJYB+PjeoL1jqFO8B9CrXLljW/TOny3xte
         6eclJvFp3NuDLM4PhSAnHg51hZ4B7SBnx6qYjMxxk2Ai0rT3mT/5W28ZNNmVK990cJiS
         Dans4bNomjuWtIwK7LJMwcEV4lYlqO5IzC9g761NTd08jaGISeeK/HM9EB6JvKsixJ+S
         umcyxjUZe2rRpZBKCD5NpAngObe6OIylhG5lt7ntwwU0jGynsebuS1FDUKc/YX0Z+XBF
         OwyiJ5gGAdzNUKBl1oBeYJfrnImGgzy7qipz/v4ayaX4wkfXUpLH+WvWnoB0HNfjL92B
         uvhg==
X-Forwarded-Encrypted: i=1; AJvYcCXeKlgf4a8ma9yAanz5XuVi32p/KXsJbgN2kSa/hmYrYtkB0x63oLrjQi6hSXFbX9FkMJcYFuL9ng==@kvack.org
X-Gm-Message-State: AOJu0YyDgXO8M0ZoOIDPSqzYuro02iaO73geTWLfnc1g3HtedsPLhQa4
	GtVm2hFQKXIy8ZgZDE/Pxsc7HfkgvdPkeLwdgjG4nnohm9oyMuu550LrO+iTgqz74JD6DJN4fMU
	4YdT8aiD7HXUhbDGEEmFmLXxYfMOSnoNPUo2jCJoHCdzoDbSLx2fg
X-Gm-Gg: ASbGnctDyZDtGM6nyyRU63P4E54mAtXtKBM6RJ//yOWPu50PMT6odyvBGayxCebwFOS
	LR8jipDmIeNTTDsU9GY0OstiNW8GBW9Tgi3ZWC7SUf7tHONwpCyul23/JHwpQ0/nBKG+NvxqZL3
	IakXV6HDM52v1+8DSdSKiPL6MYXU31H9RK+++iXUq8IEdVpiDTRIa4biSXGFYHMxn98On8Il1Ig
	yqSOTOtyfc4u/N0Ib/bw8ThwuvRaRwg+eQ5Ec20wkxSIn1cwQuXAaM3stpY2YJVG8WK3F6EZ4Li
	274GIbSLQ/vL8zZZ+dY5aPjfH+S6Svde0KarG4ZT65DaALwElkwPrUXP41dM693Fk6AjjNf/fFd
	4Nx/+S2gDpdxguFr/OPMvotzWicFXesDx6/Cfh5eKOdA0GQgU72HxeyijE5MBIOfS
X-Received: by 2002:a05:600c:458d:b0:45d:d50d:c0db with SMTP id 5b1f17b1804b1-45dddea5102mr60116745e9.15.1757322738982;
        Mon, 08 Sep 2025 02:12:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHn5yoWGgQH56O/EPuc4YNcL9NqMqoU7OryUdbi2S7sfF9LQiiebsbct4UzJYQr4SrAhrkn6g==
X-Received: by 2002:a05:600c:458d:b0:45d:d50d:c0db with SMTP id 5b1f17b1804b1-45dddea5102mr60116445e9.15.1757322738535;
        Mon, 08 Sep 2025 02:12:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dda202112sm133425495e9.5.2025.09.08.02.12.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 02:12:18 -0700 (PDT)
Message-ID: <73c8a52c-37c5-45f4-b76e-f15267412242@redhat.com>
Date: Mon, 8 Sep 2025 11:12:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: skip mlocked THPs that are underused early in
 deferred_split_scan()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 usamaarif642@gmail.com, ziy@nvidia.com
References: <20250908090741.61519-1-lance.yang@linux.dev>
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
In-Reply-To: <20250908090741.61519-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2x5ZloPurFz8GB2KsckfA25hGip9Ps6z_XWjKGhz7B0_1757322739
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 31DFF1C000D
X-Stat-Signature: ero8rz4e969wetxboekuzbinxxga3exx
X-HE-Tag: 1757322742-988651
X-HE-Meta: U2FsdGVkX1/njCZg2lG9+luVsv7YDiIBg+aColfEJOYP4SMovXYeGX7SFgqolWZVTa1D5ceRwUUKp2As3jVG2ZyQvL3Y2V1JTubUV7juorAEHMZcUKF030M2X8j+l6eXw0p5zySGKBDFvFD6olfEGlXe4Ky8/dZMElLKL17+KvrNz/Z/wdRCJuSzhUJBaw/AAFgh5IWYfa8y85/uoxkj9oBerjCXHeB8sn1Yu2vCMwPjzb/+ndtq5YVV2zoly2oVTGJtV9KEEIR5r6XF/XqS6koBPzCmsx9EElN4Qul7fadpwoFF/MYEfO04rZ3GWf0r+5+TVGoT7UlybDHCx0BhJ+UxeDy5WgELoIAdxVJSBym0PmpN5vd5yG+P5XDn8/oDbeBs6rFUk7TRqV1hYXCXtkh+ubAYbAvKDzyiQvtascolWhZrhyxUixz90nFtur485o+beoqBCKn4jGrAxvpCA7HFCfYjQ58E04MjS/FxSfTTdJeQ1EdE2AgOgKD5Fqc9Sa3bQBTEvI3wEdBn0CRW4U4B8Z9MjsmBTj1fX/v8FOGEmq5BJvS2lYRO+uq3fvEoN8u6MnB9l3NjlkTtekKySJ+UdNrEk6wdA8yJDiMnbP/mkHtfr+BJ8r8vsFA0yCpd+jrHZAXCs3qCxqGvZPtYtVO7CcMKkmBEarbAUbdnm/ZSQaB9J6oCuuMnmp4dknbjy4ns5efMVW6RgwMyUwVx4dxaXAjz+afXxIptdEKr82nGCVAz5fjYgkf24rhlVPyWe82cS3xMuY7uoAU9mhCKl13Gg/rZrIt9VHsVrHOwWAYJZVW0S6E59WUL3msV3mIt6z2SaStWbabPqruuvHszPJL++0ETw4BKGIptq3ejko7xUURp8eTTphNVs7HwNf/ELzof7642C++NM2QfczVzC4JEOvcQkfZZ2bD1lRt21KFP6uL/FlJIXp4bH8eH44kiaIdcbE4XlkpPKfhANvC
 j6Ky/eKo
 3ZaDyXW3Q77ibEMicSXbdiv7TSsKYaoVrXUiAFXgD7Tmxl3GkXBr4NKZMXomtuLN8qyR407fh7WtOHA6bQABYqSq8YWAFE7XGvHZSLo2Jo1lG1o0eYcfk1CjEk37Iu9+7nk8gCyJbHllcYvq0yoar78pfHkZp3faGgSli504QPmnBQp2RGNBu/NnCetvCKz7hTdyKhb1VZBcMgc0RKHJEa1P6NaULuKP8Gf+u3XgrFKaDSWCr0zNg3cbZOLBX/tkbEJBBIkVwQUQx4TwaIkGCQxK+iMmoSqHdm6+MUKaI0+DmTJGd1QCrEhN5uXsqqWJcIHoKKEC8l/29kYbINTTX5BTd6qmUQiQlk9YttywOpfjZ5qsai/rpGwVqyEAZ3oROJ4/JvmoY6TMbx1VlDGHHZj463a3IGhl9iXNLkz010vZiGhWHNq23U3qGsmXf3Au6hN0rbT0E4Vr8m8uuTCW5Iu5bcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 11:07, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When we stumble over a fully-mapped mlocked THP in the deferred shrinker,
> it does not make sense to try to detect whether it is underused, because
> try_to_map_unused_to_zeropage(), called while splitting the folio, will not
> actually replace any zeroed pages by the shared zeropage.
> 
> Splitting the folio in that case does not make any sense, so let's not even
> scan to check if the folio is underused.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>

Feel free to drop that, I only tweaked you description :)

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


