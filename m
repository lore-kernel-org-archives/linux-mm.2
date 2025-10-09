Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B59D4CCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 19:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAA638E005A; Thu,  9 Oct 2025 15:03:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81BC8E0002; Thu,  9 Oct 2025 15:03:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D703B8E005A; Thu,  9 Oct 2025 15:03:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C67EE8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:03:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9306CBCCB6
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:03:40 +0000 (UTC)
X-FDA: 83979499800.18.9CCC0EB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id F2A2D4000D
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 19:03:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LzY8HEM6;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760036618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/ssIfgtDfZ/vZQpJbYy04kO6t4txkot0+r1aHEyw0s=;
	b=eYMKts4eTE5BY5dkQA2YENWUKONlU308XVWNR9Tq7A0uHLtM5DQawqX0fKfv1YMFVVcH6F
	yFpyZ7KgOzs2H4xK4GmimHUXimC8rZa9TJ2PW35RyAoHdLgMtKsALk531VK7x1KSHyIlxp
	75G7IxUIJOBzBu8YkcD9Bbb4HvzDWEA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LzY8HEM6;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760036618; a=rsa-sha256;
	cv=none;
	b=t2TLwPKCufhzx2CERTtK6X7UsKYv+g3ch5m5Zc9llsYCegmNqPWWIuwMMBwdxVP97gpGha
	74YCl9XZlT+IvvBMl1cNbTR8ycJ/rnVQU9CUrGhSZTiO+JvCOAwcYSOHhEIffSIg8bbAts
	mmo83NVsCHNVZ8uSut5H+c3TPDH1YIk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760036617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=v/ssIfgtDfZ/vZQpJbYy04kO6t4txkot0+r1aHEyw0s=;
	b=LzY8HEM657UM8F5BhNcwW9BNcNr/dhsiuPlzXajZEngN4NyYsYGu61502QupZMvM+8u393
	1wUjxM8dmPJX8lECSusVvCs34IGiCF63FQSmflhiGv4Kcl24ZJ7GnUPW6sTKWHXL3fzu/K
	5RuMQb7qXILBs7PIsnDl2Fp/3NnDeAk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-151-tBZufaDHN32p-J0RxUSoFw-1; Thu, 09 Oct 2025 15:03:36 -0400
X-MC-Unique: tBZufaDHN32p-J0RxUSoFw-1
X-Mimecast-MFC-AGG-ID: tBZufaDHN32p-J0RxUSoFw_1760036615
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e35baddc1so12490085e9.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 12:03:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760036615; x=1760641415;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v/ssIfgtDfZ/vZQpJbYy04kO6t4txkot0+r1aHEyw0s=;
        b=HmHPg11IUtZq1EkO8KrAYe8fhAn+cTtytxOowY3G2Fy+S5eHWd5KgT/Ju9t496jZMg
         OVulBZSoZqQUDSHGq7yeEDiCcN/CKgVNtddiwo8QXLYBXwObm/BAJPL0ci67CyY0DoFb
         5BZWtDqHEiF3BTC4klRlMrKCSIhmhyaQXQ+yCVq7A9m5zzn8g8JpEhietebjjEUD2BEO
         gi2/D+eYrsnrKjpkfihH3KsLiDFiTHR51b1GrPoP+Xqig4H4Uhp/yJafFUksssLSmXjX
         OI4Ws6PM5Xq2Ki1/xOA1frUU4CZjR7mPpTw1Q4DqC2wtsSAbKqPWx2vTC9mkVOKTE8Pb
         aMPg==
X-Forwarded-Encrypted: i=1; AJvYcCUNMC5tvGmS6RBf44+uyOpwXDjBVlFX0Q+WfSBRgjdOU0ISVDBYe3Rj73cZNbABDfFIv069Cq3WRg==@kvack.org
X-Gm-Message-State: AOJu0Yx3xl4H2OKExlrMT0caN4nem6BO3fWckegJJjy21MVwOJX1nt7d
	FpSjqdDsfAuE5eeyco2Hxl9s45b9qC36kcsaLuMkIMfFPDK1DbpiZkc8hA0jYVyHnQWYQXk0RRq
	nhrqEBBeKSqo05btAO+ENHR9cuCgRMPPHBdTmvTVo7rbL688jqG/NI4xLVwbe
X-Gm-Gg: ASbGncsRe0rQbJHyypVgK6G1Zn4bSr4FUOz43wOw1BsG2Ew1DFsqGr28o0kAnNEXuzY
	mr9Kn/YI9hmpKGr0TozDcxwvMthq4M7nlfRcE4p54i+zIussMjjucLtST1LowirRNDevpLgt0Gs
	PxSKMd26B3zkukUg1KXD1Dm/oZLj2IjoDp46RK77T2iNTZSoLtBXzJ/CXsADMEiKL6EQPseEH45
	y68XPC6IUfxgr6oshK/xLlmONrWoJAGkB4j1sgQunmtYgw98ldgWpYRH0DxAOxqyh5EKA08Jhfe
	YFTHS9g+FjsGc8wNR1jpywiUvevOzxvNN5TzfLGDcpGsrpjHe1/HSHAkxjNcaFaL6ovBiGSQz4G
	85oGWRdpP
X-Received: by 2002:a05:600c:6287:b0:46f:b42e:edcd with SMTP id 5b1f17b1804b1-46fb42eee07mr11006335e9.38.1760036614783;
        Thu, 09 Oct 2025 12:03:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFKJxh6vFQ36gJauYPkq/a3ScSVmIoEQBpQlpefqbtkRe6rn2htikCoXY1hIWlxMFsl+Gqqiw==
X-Received: by 2002:a05:600c:6287:b0:46f:b42e:edcd with SMTP id 5b1f17b1804b1-46fb42eee07mr11006155e9.38.1760036614381;
        Thu, 09 Oct 2025 12:03:34 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5cfe4esm352054f8f.26.2025.10.09.12.03.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 12:03:33 -0700 (PDT)
Message-ID: <da27231d-e8dc-41f1-b5bd-e32b5eed52f3@redhat.com>
Date: Thu, 9 Oct 2025 21:03:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm/memory_hotplug: Remove
 MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers
To: Sumanth Korikkar <sumanthk@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 linux-s390 <linux-s390@vger.kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <20251009131839.3739108-1-sumanthk@linux.ibm.com>
 <20251009131839.3739108-5-sumanthk@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251009131839.3739108-5-sumanthk@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UFiqLEcj2UWbXMAImL2M3XdDuAy991ic65bZjv5IyQw_1760036615
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F2A2D4000D
X-Stat-Signature: 3a1suhi7ab3uhr1pawg3zmnhs6ezpj7b
X-Rspam-User: 
X-HE-Tag: 1760036617-391591
X-HE-Meta: U2FsdGVkX19eBU6yCPesAzIo7onvgcHMs/vIrh9qo7kumzpnXCkhHRgz07Rc/k25jDcEnJFZtwxyM02dDOmrtpkUv+W05VbHs83um88J94tMVKhgGwFnnBwaRZVmfC0Z3epOUQ0CseAAe0idCvMifnS6AgShZH7b2eyyZlwWJci/bL7mJH6QOUXNvDWWfFLFUAZAh1n3sN1Z3qwm2SnVW1yWBwupE+dIhAIqA8/cnOTRdnfiwiRzjdaU9GhEUdllvK+/bPl2UH1NaIw8sn+KJU2MQLfNRQThJkaZfawoB6s4CMlm94EVv4GEAd7/Uodv5Vs0qUajv6Twv2d7Cgf5NwIIxDgpTaReGWiwfYMDikl7qqcV4NYHs7jxvrYa6715Veu2UYjh8XqLvJhYBO2kVVmSE0a8CMczcfgplQ/C6AsMJj2+iNBXTfBnetDfIhqH0eeBe589A0VXJMBkPQ/+gh5FQylp3nR7gPQIuytx0zqh5rrx3oAAujiR3tUKQxEsbjLUQZlEQKNnWdUt6DQsDI8BzzsxeQJgB5XRyLvsxLk6WIrXHXz/eUNEnhiuLbm3cp7GoJbuEGj2kgkFNdu5h2v+p2OMqsjCfNyX2kxjmI1FNOVj4wZf31eiq4xzfdPpHMMRWx0s7XQKpXuWFmDOuSJ9cZdkKp4xxZ+Lue4Q8dGemDOrV2hKONqmbCp7wMPjKeZIxcJYj6KrtMnAjZfegICnUEhdEy8bG0fGf+VuX2N5d9oPWQhQ2TE2xG6VtXZXlnfxBSfwGzXkCXhXKRMlSbFbb4rxq9h7A8Xhy+rmURiBPEaiG3ANzK9Y39JJ/k0ztBscdvjI8TqHT6faJ0Tha2AHVA5v3LEzp58zZyRIyGrEFnPMLYf5jnFvlOKMde/AI6Kq+LI9sFWk1tP5wAPWpPYjePSo7m+5lgh+LdSXvPhgUIGtu2Dy1pGOqU8ghhTvE6OMCFd2oisU/gCMgc6
 psqzY3bV
 ciec3SkBwxdOIUw+NdgqcYEjHF6PeP95b2h2MtwhsAe8MPJJDDyGayUXYBo+lqUy3Y8XFo2o2v2m5lFgeYdyQDKyKI6ZL2uqylnAI9qf1q/V1W0p8ujJwWBq/0Zh1giP1DLqZSzK82nThE0kx8Oz2eP+wy8c4qbqlcuen+PNwMPydWTNYvwpQWqDUSulHZorTb9/adrolD66ynWAX10qt4swYk/hSK7N1x8z1CWolv+ADIl1wNDaExwGRKuriAZQMjNKIi/owf0GFNFerfMg8OsMwKpQCVjg6izqhUNfpj6QowTOpkB3hTVjgWXtyjem5Zdme+AgFt69TeUQRwovTENKiK57CSPmNqM8pxxbuFXJiycn/Znq04ZfxgCuuG6NlQlwiOFCJXCHKFxEJcvZ6ssy1EruqdK04HPdUugqAOTaTasUbDIhWGwbPFIpAxsbdzDZNHb+VhSFYgefosoW3TmOxGhU4ei5QlED8W/NPzRMo4wod5kuHUmwdogtU6IGmOZ1ceu0ktXWaUsDX+b//amQE5rul1IR1QcN9FjPjEXRmkwNe9JR/Kw0pOQDDx5vGfxkJxdD+mr7oe3WnWa0k9OaFrpWEQ6pHq+OcrGBGl13cqLqqAKmw5SWfa3NRYPx+8LDvFXOQmpH+hMmaDXwhAvgkVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.10.25 15:18, Sumanth Korikkar wrote:
> MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE memory notifiers were introduced
> to prepare the transition of memory to and from a physically accessible
> state. This enhancement was crucial for implementing the "memmap on memory"
> feature for s390.
> 
> With introduction of dynamic (de)configuration of hotpluggable memory,
> memory can be brought to accessible state before add_memory(). Memory
> can be brought to inaccessible state before remove_memory(). Hence,
> there is no need of MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE memory
> notifiers anymore.
> 
> This basically reverts commit
> c5f1e2d18909 ("mm/memory_hotplug: introduce MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers")
> Additionally, apply minor adjustments to the function parameters of
> move_pfn_range_to_zone() and mhp_supports_memmap_on_memory() to ensure
> compatibility with the latest branch.
> 
> Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


