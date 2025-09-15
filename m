Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CFFDCAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79828E001B; Mon, 15 Sep 2025 06:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29008E0001; Mon, 15 Sep 2025 06:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1558E001B; Mon, 15 Sep 2025 06:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 981468E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:53:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5CE7A597F1
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:53:02 +0000 (UTC)
X-FDA: 83891172204.12.51A2AF6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id F0F47C000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:52:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YJhGjXZX;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757933580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8IZ/fCnKmY0nl3IaYCWlZU5tdy+pNMKr/indmXUVlYc=;
	b=T7fHqvVbxtL0c78h1U4rBpAcknNJq1AeSHyLf0/a6TTng/eWtZoqN0pKjs969w7v0FJ9BC
	wf2gD2yE4lCwigDVFx2qrW7+BZphksO9EPIt3qlVOcc+NJKXxCsJL2o8CT1L5DaUCe7XnL
	kVUMMyKfgLchadg7iOQFjGbeyIsiJp8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757933580; a=rsa-sha256;
	cv=none;
	b=JHsjoJCLqntw8qhb/HI7CwGWKkyiZKjFGE0iQZ7Hz4mfsLdkl9GK8tnmbCLb9K1po31Z+e
	XL9f32mWcnwUeUL+FofhuVTYJpMOeWhqc6GqyIDeP244ApZh8UL+qLqskPCl5FLCQ5h1bu
	lUu32OqmAndig/jvXw7vAAyFYx+j7FU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YJhGjXZX;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757933579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8IZ/fCnKmY0nl3IaYCWlZU5tdy+pNMKr/indmXUVlYc=;
	b=YJhGjXZXENepyrrqS9RrWHDqd1ayykIfblwYDZUoqX+ARL0Jb8Xw4Mz56k7FpO+8f58rL+
	vW34nmb2Zjeh2Crsn6KBKZ7ESdOCvLKiOOFsKg+qEYyxWHCh99zegNrtWqMH9eLd5rUWKY
	7BLkbxDJ6I459K3/H0zyZrWVCVzyYSY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-qUOgi6fwNDCHbJUkpy6dhg-1; Mon, 15 Sep 2025 06:52:58 -0400
X-MC-Unique: qUOgi6fwNDCHbJUkpy6dhg-1
X-Mimecast-MFC-AGG-ID: qUOgi6fwNDCHbJUkpy6dhg_1757933577
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45de27bf706so21132405e9.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:52:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757933577; x=1758538377;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8IZ/fCnKmY0nl3IaYCWlZU5tdy+pNMKr/indmXUVlYc=;
        b=QPWq+NFRzG+tv+iW8l8R8BA7epi0K/9rbwNJaYjSSl8giEhYTj2z3CdEV3IdBgapQo
         g+aVQcXv8gBZgfQWYf1u1z4JpDTz5gIcvtVlj0q4bFryg9B6yTheacZlVMugXdSYy8lE
         1vEs8Hus5p5ABeZlhsrpu+MbUP6hvjrqsXrNwPH6ZXMA0E3XKUg8JhKrHGzEp1z072ix
         MrSqf46VWyfopJKyOftm2VklF6eXpuuHGhT+FWUzlNCwwzOFEaxDniCYFCHvPv4/gJiJ
         pZ83AC24KiK402li8al2+KrDSNTBq7TO+H30RMTj6qqM75hikjaN2LHZqDrZ7aW2IqJH
         Zs9A==
X-Forwarded-Encrypted: i=1; AJvYcCX9U1NyIYbicx8mzrIi7lrGnKB3VAhZA+UIPci/HwdkLzJAP4VAAk3hnhWBHnGWPjXMsScJ0hRhGA==@kvack.org
X-Gm-Message-State: AOJu0Yy2wHg1hzcIIJhvI4nDu3vnXZqnI9e7CxIddgDR0A6joW0zlTOl
	aKQ/AS0Z000cbn1Uz368K4jGhwLZFnsNeexxGWL+SDUVifgE3TNpgpL+GNTQqVoADE5iAKIYy5b
	D7qeaZdF1NElcuGdw2h6qCr5cqdoTbiwMuYDVWi51+Nh6W3QIrteY
X-Gm-Gg: ASbGncthyWhm9gnTjPssD8POl2yY6frzn/T9Wv6PNoKT1sDbV8sqLGgFQzYlXi8DXaJ
	V/p7pY7ASPFuJ8aCcRGfmAJg8EzIFumUCIgDYB7WUlY4osvotmUhFrrfhcNyHxODiXf3OekqoAn
	mgrlQKR5y2O3G1ElPt2ad6dLijKs89NN3swnZZ6Wzt1A0ayYGtQZhwI4yGIqYt8QTp5np7MYryF
	b7GMPxxohbCmTX+rOSYmXCRNPkkhAYWZ89TZGEnTlqeupZJAfmEazK354wnS0x9WBYZZ417TO8E
	1OeKVIPrMAP38OLsxlbwxIP8kJvsZFVeIfugWdbWR+QDND3k8LT9DDkz2QFXv4cawqsltiy/0VO
	E2m7Ayo9CNMiY1f92ACuzQeGtutN0YLQnorG8hWNOdcf75Db386JeSaMVwjCdDCujS5A=
X-Received: by 2002:a05:6000:2407:b0:3e3:24c3:6d71 with SMTP id ffacd0b85a97d-3e76559415fmr9014790f8f.1.1757933576783;
        Mon, 15 Sep 2025 03:52:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHbeCuXCM3MacBpQLLM64+/8kob0b8h05x9uuPuWhG7w3KYsjV9dZCY9Huw5igh7RtX93+uBQ==
X-Received: by 2002:a05:6000:2407:b0:3e3:24c3:6d71 with SMTP id ffacd0b85a97d-3e76559415fmr9014762f8f.1.1757933576342;
        Mon, 15 Sep 2025 03:52:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0156b0a8sm175910915e9.3.2025.09.15.03.52.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 03:52:55 -0700 (PDT)
Message-ID: <de3f5502-ef81-4f44-96a9-995e512301a3@redhat.com>
Date: Mon, 15 Sep 2025 12:52:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5>
 <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
 <2c5328ee-fb6e-45cf-a151-868cc8e7ff97@lucifer.local>
 <4508810d-7645-4f57-a0c5-2ee9f44206fc@lucifer.local>
 <34754ca4-fced-4a3c-8ff8-c00967d487de@redhat.com>
 <92352257-5be4-4aaa-b97f-c4e879ac6959@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <92352257-5be4-4aaa-b97f-c4e879ac6959@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xQ2QslFb9u14fqUXEGq7jFhVQN3N0Jmhp0xEAUct9gE_1757933577
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dsfdso5m8k75hpg9rrtzzgoihz4au9cc
X-Rspam-User: 
X-Rspamd-Queue-Id: F0F47C000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1757933579-218664
X-HE-Meta: U2FsdGVkX19uZK5b5n5kTOA4av79wQunvTsZW9Y8IQ8aUYclJSmA7o7gr1guxoDRfAK3tdzbkOQpZUvs9aicNlvMsncwf1kfSFbo0EmyOu/BDsRueWH+5VCCluUAqlHjSZNaYgLx4fAgBrsHN0KHvrD9LtF4X1GuiBTlzZMz6e5uOZGhz7DK/rd1a3YG5FielAL5y28Ski0ga0CZxTFhKp3Q0efD2bFODOHO6ixcricB6iBU6l8+EWmnEC1PAMr13DXVfIgSNsq3uU1uYnqbdrbP7gHeYHrnMeEOr5yt3TWFOGm8SMaCqZOArzdaGiVJ+g7lou7sQeD4vjbnw+EqWV0H7b9jvaj5NC0xkX7QhSRGAAdBeWOyn8kKq8hVM2n1HCE75d6tR76QeA/3GvXJGz/vEdoXuT0cE+rJXG7cYilMb2XeKus75WPVWlJjta1jVnj1Ilp+y6fdO+GIxnVqHfKkhImagKwgnBPgzGurv6JeIYx1/i4KG3NKt7eqvdvaiLx8DYXRgLI+YyOFqK2XROIspq4rDqIiDDFp4rHY5tID4VZSfYaRr0oHRZ0LqOxXsMZf24shRbtbfVdbz7u7Ofr5hPoducjyb5rgbxJGoC212ANpWbOBG3TPJ4O6W5bmc7m6L8ZC7mXm1sUknUFCKHUh8XKw549kZ6YLMFCCNjCrcDkmqxlHflrLq5Jn23o0QN/3l8NVw2a7BsJxjuGmdyM73F/5Mity+JFLLKg+6bXYyJZxYkKj7ywa1B3Py7aMjNEMW1EBN7BSbDIJZTLDrTfHi8BZr9WJNjDAQClWGceLPHdNFhPOOFt++53rS2F9oTz3P18J0Y+Q4sn+0DvuqfZ9xc0OCaFnJukZYV4ZQkC9l5xLLaOKyCSvHsq4S5NegKNP1/K0WjUZ6r76I2pgxOi0zJ9nmYeEQX2I5v5PYedhW9eIPd7qViRvRmu7qwsQ/aYEWBTQgGLQR0l36WA
 0FiYjj7e
 wl5AspVzkTPnNoiI265CgXeLgU6oRUljvi9P/KietCnbCcfN6IDCb8MSWOAd7HbVQb3PkS1oY2ocJXgEmQdAKK0C075wtbXzrgiYQOfxpTxzszHyz1n5jxH1XC7FYhd/45V1GFZ6mtHsJjP1VNt6227Ok121LQP2prHY79Ty7hPFD31cs/rHf5GrqHO/RQ+ftjkwk5SOBBUAfWFE0QKGl/1IZAce+NU60oj2XprUQDAuUEtaEa+G27bK4lVnFYLn7hevuYTwsoFRnfha0HI0Toz77Iy6jwC0eYG6CToNpReN/fNvrfhpV1GbRjKblo2pXO2jsAbNgbWxVGbuel8YKybC6a3/QoQlw7uQnTatCj4r2mSz3AvuHgbjHfvUe5PzahQ9eyZtIZ2AvEVvVeJueDFLisMcdP9ZIHRp7h75++XCIGRHA3ys8cZQoQI3tUt759bc4X6qggfZX8c4S7Gq3gVsnAzogsoYD5Tgb/IEtt1kl9x6cCSPtC1VcMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.09.25 12:48, Lorenzo Stoakes wrote:
> On Mon, Sep 15, 2025 at 12:44:34PM +0200, David Hildenbrand wrote:
>>>>> Mapping that to actual THP sizes (#pages in a thp) on an arch will be easy.
>>>>
>>>> And at different mTHP levels too right?
>>>>
>>>
>>> Another point here, since we have to keep:
>>>
>>> /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none
>>>
>>> Around, and users will try to set values there, presumably we will now add:
>>>
>>> /sys/kernel/mm/transparent_hugepage/khugepaged/eagerness
>>>
>>> How will we map <-> the two tunables?
>>
>> Well, the easy case if someone updates eagerness, then we simply et it to
>> whatever magic value we compute and document.
>>
>> The other direction is more problematic, likely we'll simply warn and do
>> something reasonable (map it to whatever eagerness scale is closest or
>> simply indicate it as "-1" -- user intervened or sth like that)
> 
> I don't love the idea of a -1 situation, as that's going to create some
> confusion.

swapiness also has a "max" parameter, so we could just say "override" /" 
disabled" / whatever?

-- 
Cheers

David / dhildenb


