Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30083CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 17:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88D688E001A; Mon, 20 Oct 2025 13:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865158E0002; Mon, 20 Oct 2025 13:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B258E001A; Mon, 20 Oct 2025 13:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68D1D8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:14:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8FAB140221
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:14:46 +0000 (UTC)
X-FDA: 84019142172.26.BB95C88
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 61CCD140011
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:14:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NQYLto2c;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760980484; a=rsa-sha256;
	cv=none;
	b=snTsPjXr+JWMiSALgq+hEjISSKcno1YECPLcFw/geJPmG+CMhQLJ6ZZfAGkBH7XkXpvXlZ
	iq8uvyblvgivoXLx9IW3YyfWCNVjETtHk8kI7s6/PgQCOsEYLhQI9aOAtMIu1xBnPWCDTQ
	59qipHzsTjFinMSNTB7pdT4NDPELfpk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NQYLto2c;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760980484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOo8sSkjO6IqXwpAf6xmw20vCIDM4jZaCqO0cufoDbU=;
	b=P4UKPNRU5kNjD9oy3h22DJZC/u4VZXcsk/z616uOWnhTFr72U55/4J8gc7y3ZIU1pQKKW9
	eEdNIVMcWUTQ0b0pNdzNyhRO3WJrreK7P7tqEWBPdp9kEObLMgLO8jWQzxqOSSN0DdW9Vq
	gHtG1y4noc19SPV9DaQWjN74Jjp23a8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760980483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jOo8sSkjO6IqXwpAf6xmw20vCIDM4jZaCqO0cufoDbU=;
	b=NQYLto2c7olaAYAO45GpqxUpnvRhZq0mE7ltTW3JZ6uR/b0zcU6g8FmgJsYmeISA9E0JIS
	ztpkcjlpczRsNQhgqFm4xFabzTrGFltS97tV97d5/HsPj163Dud9/Zf15KP6AW7m9Z1P9q
	1wt65/ojynXAsbJlwCqT2nZStfvLe3Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-ZTJwbCQYNIOh8FKfi6XR6g-1; Mon, 20 Oct 2025 13:14:42 -0400
X-MC-Unique: ZTJwbCQYNIOh8FKfi6XR6g-1
X-Mimecast-MFC-AGG-ID: ZTJwbCQYNIOh8FKfi6XR6g_1760980481
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47113dcc15dso33935005e9.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:14:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760980481; x=1761585281;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jOo8sSkjO6IqXwpAf6xmw20vCIDM4jZaCqO0cufoDbU=;
        b=HQI6aq41satSWMIDuKSqNiXUI+ZZ+GXBFMMGA9LTXp42YVWS/84joHTjcNyIT7MANI
         Z5sYIyD89R/LxQgnVkU7KRFO6lEX/VsTwXecdIPC/V5PSrFNOTP6yTgO1pWCgzZQ+6Lq
         tA0wp4tyKxghO9r2VGPXAvrT34M9grnWckk9+4LaaJ9mrJXvaAeS2g1jbR87f5cRVjt5
         BTz7BkxHL7TT9JOXWe0WNf/OOBCOsONPoRdC5q1aIk2tB81L/fgpUTWoqyb3UZHnnFmp
         Dovm8CeuEXfoE/e+Q/s3ionUX+7Hea5eWb3Km1pFSdxKUj8W3OmlWJnKW14Ejw0uyH/c
         yyNw==
X-Forwarded-Encrypted: i=1; AJvYcCUZ2XYs+3m7TIZst61pYZA3Q+k27oQy3sKq7Vmcw0x993BHtHhrt2ChUtqDdRJMCARj/8gqAh9c9A==@kvack.org
X-Gm-Message-State: AOJu0Yx7fVvFfw8AdWpdx38g/o59FfAhKfkiAa7cYMBUFRUNnVx29jSr
	KpbYYqlGM7N6R1hN+rsFAdLB7dZAA8i2zpsGU+h8WjVdL3PEx9cBlM+B72r/Xtjpk56+/px6k1x
	XfxkDI+v6FWmihYGwrbVlN6SQEN37mZ/Xo8Q1Lk+hnKIJz/niBluB
X-Gm-Gg: ASbGncvMUaK2LAyvGl9Ui1BUa8PYejU/QW1raj6dAI2k6eCjFhRH3H3+zwiTsgQEIS0
	/ABbqH39ZXPAoqKFoEPdS0A3Zu/a/4+ZY3eYrVHBpvsiLKt9bqAeCZLuoZZ21YQWF0He8m7E6Gp
	8PIzc3FBgW7JFUbH5Fytg1ElML7ZK7jfJylVaHkxTK5JeNrXXK8Ev6OR6XKJGDC6YNXwR3mIFHH
	LT5o+16/TYmKbpuHin5/FSW/s8IfPhxpEZ5VfLa911sbcCvGJEPG5nWh9S/KljRbZNsFvjRulA7
	Ugi6plgRPB3U+UsG5yuCrIJdryuOwztsTR4u8yZnRt6XHoEKcr3Kg5BKhcZu0GMiYzqVWn6iuZ+
	i5H3JDktWwAhsdwzydrWZu8FLTUzzq/bnJ9XeTxcspqYkYQs59zfwGo5QooMfKw3NfqzfUSWybe
	hYfR/J0l2nca76RbYWlC/fAxH/S7w=
X-Received: by 2002:a05:600c:a14:b0:471:15bb:ad7b with SMTP id 5b1f17b1804b1-4711786d60fmr114510775e9.6.1760980481114;
        Mon, 20 Oct 2025 10:14:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8NRNx4nYPhA+W0IOT6snNINaoL5GUqLW2Ls3PoZCFthWEPF4dmZ6SAwarpD3VHDiHrF7rzQ==
X-Received: by 2002:a05:600c:a14:b0:471:15bb:ad7b with SMTP id 5b1f17b1804b1-4711786d60fmr114510565e9.6.1760980480656;
        Mon, 20 Oct 2025 10:14:40 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144b5c29sm241641755e9.12.2025.10.20.10.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 10:14:40 -0700 (PDT)
Message-ID: <81fc5322-6ab4-4830-9b2e-15d834b461c2@redhat.com>
Date: Mon, 20 Oct 2025 19:14:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: guard is_zero_pfn() calls
 with pte_present()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Wei Yang <richard.weiyang@gmail.com>
References: <20251020151111.53561-1-lance.yang@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251020151111.53561-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HGn0gNF44BvqQf-2wYORyR37bw7f8gGjpaBzOLbfxQI_1760980481
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 61CCD140011
X-Stat-Signature: m9tsdbd86bjr3pyeknesdgefd4yc599h
X-HE-Tag: 1760980484-748750
X-HE-Meta: U2FsdGVkX19PZldjuBwoVPRP+kdYi93gCQ20nZ+gpiqmc7c/BBtaFjbrwfo+5qK0Wg62yF1ZCguQSVh3uhJACx3NeP1EFXLNMNN63kUbJ6LCLV6ZI14z/VP703J5J8J1MyJwyDnWjV3iyHNKN36SK2gd7NFKHkho1rN6xpamGBeYt/P82neSoonJgvel6oEuydO+NohMXcpf2m7ox5ws+9LiVM7sEzg55M+b61v4KENPulPmWZVB8C+Iruike3RDFf7vN6Eifv0T52yOyrzB5lABflynZShVnN/EKqQ0O1bE20HtiL8JAMUE/mgIVv2N6GtWUjcF/Agf2530hHUeDwgZzrKSQ5BMESrpIX8PYoARoPNd76lshtPkie1o7tWZ5pmCsDeJULp/WTSvzQf5dcQxO8paR3nNEcARF7h5HTLQcD7qTvFt1vM+UV6+Tgeae8n6fNzxcyU4C27YgGuF12g/Ajgko1OydxFjevziqLRzdcfoIh6aD5BPgCnhZpyIIdddspGtuj24LUApUFmOp193S6HaNHhmrTrRH8Iq1Glw6d8qGdmxF1pBHs3FoAj/LYKb0RPZsc9Ea0pObwG+NqOiv3VRy00lWMBq2QmsLG/FGGWDNdn+hE13Ec7J/PoVqbfe7wJpBD98C1AXygrsJhYEMtjmcIPSANoZu/WW+SC59wf2J6wJAs9ul2iZCDnS/LaIyGq9vWgOqaSnmba3nuotblbrEVtpEvMsDN1Avt3lDavkO/LhXDJXatlSYRGDemHNBss+QAt4Yc1AkaA9vzBl7Y1BvaPU04f8OwGHe5zxTbjR5wMfVRXn/XtJS8jfjW3PdfL9dWLnwT9p6yjC7Qs+XzZY2qaTRoQqPV3JeM5X5KDFujUZvUac5E3YkOgB1VPXwGZqR/d72IiLcwbZNkoUpedOa4QrVn8Ecm534aYKSZsfE/BaB5D1eSspsHtwd9GazaSIFr1CrMf1SWS
 JgpXPBf1
 7jQT8a0krdw0hA1TzGsK9TmQVvKpwaFVU0I5mbw2oFQq+tpySdA0Vg8yKuxJD5sW0eLZT3gHkZMuixBTTDGZv37vQcXQJ0OftVTlta4YS5NUyLM9edYmJu0tOeeC+j2KnFOsd31OZLh5eDDSJniiiEYGYTYVEU+5IGfUDrdJGdeDDKrslK1YUHqMLOFZD6B+U8eVUyTjsIx82/ivja2d29MqpodIOIEv7e5oEdfDpAQjsm0CcdPfz6qrUGCKIxI70seH2R2jY9ZX/xkkCLLr23xGjDQA/PD2/PHcEvVHNmBQKQ/nvKXdpVPbli0OhTkWpnlqHwRfiBPICvZLwSA5TdGONp2l3zdlxB28CMvHE48FxPw+gPyH5b4ZuCtdfp7KGOJ+3/IIdaoRvDZlxwrAlPvbCi+5evw0mp5o0tpxIiWthQXyFtj1xJ236i7QrSHpuA3JW6nRWltHHKll6BvgzUW+H12LuWzCpP0xXR9i1pxKF3nr65wkqLjv/ELtfLIAJ4YZr2vswG9LC18AqFfbLbrH7P+cH0a6pbHx0diVPeFdbHKSePl91/YRLakfzQJyp+fyahk6F6rZxtG805puvh7Gp3QIC4tOSwKRZBtb+e9nJ+qAZ1Nt5rHL4gYPYbzk50HD6z84Yx+UF4jU36J1Rd8NGkQT4ijiZUfTp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 17:11, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> A non-present entry, like a swap PTE, contains completely different data
> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
> non-present entry, it will spit out a junk PFN.
> 
> What if that junk PFN happens to match the zeropage's PFN by sheer
> chance? While really unlikely, this would be really bad if it did.
> 
> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
> in khugepaged.c are properly guarded by a pte_present() check.
> 
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Nico Pache <npache@redhat.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

Works for me!

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


