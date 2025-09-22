Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6BA7CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 13:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E963C8E0010; Mon, 22 Sep 2025 09:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6DF48E0001; Mon, 22 Sep 2025 09:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C5D8E0010; Mon, 22 Sep 2025 09:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C17CF8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:28:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C76C1DF19F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:28:40 +0000 (UTC)
X-FDA: 83916966000.10.DB0449A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id E7D81100009
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:28:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U58TrKYX;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758547718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aYZWMnhb35FhQXu/jflhyxq7LXLIaeDmYd2DKd9poi0=;
	b=naKrcLjwJBIbYusHgc4DVbhOySKHIBC082IzDYtGvMQB5chiP5U9b9SXmIEBrT0BKMwzEd
	bVrJ7fqwgHXrC3YIMZbIpTf03ltIYo/biXMCseLI5Pdqsaa0dV74J4nrZ5pKD1/10UULaJ
	yJG2WvqCpRhn1KaTcjyUA08CNQr6UOQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U58TrKYX;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758547718; a=rsa-sha256;
	cv=none;
	b=D/V0K2N5FVeaZjyi/vXxmBRBC85okfrY/NDDLIgqo3oeOZ5lbdbVsKeCSGTCbzO1q45IED
	Bvw+YdIbMxXKF5JVoQRHTARKJ/+6TXYeDFbG/HPUAfJHnBw28vg389qmEWuK5CnLvsz2ds
	PUFbu+lWsDl9L8rcQhkeY1ekAPRWijo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758547717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aYZWMnhb35FhQXu/jflhyxq7LXLIaeDmYd2DKd9poi0=;
	b=U58TrKYX8MpS5W73Ymwl6EVM+olfqzLdxqCWwzbieGC6kM5SWDuDh27fAmmEFLn3s2bXnw
	ZU3/0e5BLhomX5jNsARuETCjk9TGrwVpN3bZ45GSmWTW3p/9+TPIXceFqWQDjzb2QRmDYj
	o+uYK52sl9GRZDWftgDeEbUzjOoGZH8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-nc-4LyImNsqjcMzvt0rFLg-1; Mon, 22 Sep 2025 09:28:35 -0400
X-MC-Unique: nc-4LyImNsqjcMzvt0rFLg-1
X-Mimecast-MFC-AGG-ID: nc-4LyImNsqjcMzvt0rFLg_1758547715
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso3120705f8f.0
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:28:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758547715; x=1759152515;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aYZWMnhb35FhQXu/jflhyxq7LXLIaeDmYd2DKd9poi0=;
        b=U4fb53db7OxFZ5ugfF2aH+7c4GCupzb3EBdCk78SvYDHFZW2yP3bNSRaUMl51uDL2b
         xQ70LOs9toKe5KRP11xg57k9OJDy2LtMQ9O/EQkW3EvCKZH8LMDA2ZwpC2NhG7WWLCRk
         IpNfq2HmbngdHJkQeXzHmgA5tlaEtvPp0CBG86ctRLpmJXRxbJ46hMXPtixg7cii4NRw
         TiknrogAgj6Uuh6gFAqcxH1RDDtxNubNrJ/YYlbQTDQiDUkVcrxgK+yurpk1+h5gYzRk
         ltC8k7RIY5izsUxM5Ekf+QiFTS65Mw/zizPDHNMYDubjBzbX3cl3cAd2ZWWrCkf/3HLW
         Kdhg==
X-Forwarded-Encrypted: i=1; AJvYcCXd2kzJyrJMDLeq8AKMqVumkpcuvaLOLaeYWpJO418hLP6iy8AkZjiTYcjjKuPEbnsLjvdaEw6LxQ==@kvack.org
X-Gm-Message-State: AOJu0YxxBojud/BpwhihUDnrXzKRv9Ln7qqblqTZC4FhgW06/j+sEzb+
	IFYroW2gDEMNPbJh+ks07m/JqDQ45NAVeDKcbGzUxY9EUpa4V6UOc/GDni7oyeDvIv18YmoKnl2
	gPQI5Xv5ZHiMHMfV1xFGugog68ru+BFK2sF+B1K34fof3/E4ldrUx
X-Gm-Gg: ASbGncu+3Zj34m6WKhqFXpGOyw7No88uOn0+GRDwO5U/Fw6dJS6gpmsjPoWZ676M0xb
	N+gnX7OPtiK2QGF+fD1z2fKe6SPsj+KF6rl7cpoGn1JreWpHMbv9GUoOPl9koDJQ5L9zY7EH3f6
	LFWRqW0SNVnNz1zunt5BO0jjnEn0c6+C1eyx/JDeY5sHTSGJDw+Znsn6RScnXrdhf64dcQcgwnP
	QZRTnGAuRYP5BpZogEckSzcV4enE0rqGezLwQ8ENg8nAp98SobgghTR0Rlxn0yr4nuaSswOHYe8
	r4CJAvxwycrdGTrahO9utmMJB37x1sybIIiVRtNOXc9fCZhD4ElU1lCdsgblPZ9rUikP7BzKEyV
	KXXGmDJjTRPMmjynCyQzQA2tkM+xu2ops5tehN7TmhzdkxxmXtU+8mkFpOyqfSc4=
X-Received: by 2002:a05:6000:1841:b0:3f9:1571:fe04 with SMTP id ffacd0b85a97d-3f9157202f7mr5192612f8f.48.1758547714625;
        Mon, 22 Sep 2025 06:28:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTq7TNLXTdeCI5C+N0Ui/sJn9FsQ+D8L4dfcxOUgyhmHo+i/Z2Iz4/nBkT1/rxNioSHNwt9g==
X-Received: by 2002:a05:6000:1841:b0:3f9:1571:fe04 with SMTP id ffacd0b85a97d-3f9157202f7mr5192579f8f.48.1758547714140;
        Mon, 22 Sep 2025 06:28:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2a:e200:f98f:8d71:83f:f88? (p200300d82f2ae200f98f8d71083f0f88.dip0.t-ipconnect.de. [2003:d8:2f2a:e200:f98f:8d71:83f:f88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46d647858fdsm18830495e9.5.2025.09.22.06.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 06:28:33 -0700 (PDT)
Message-ID: <fb5bbaae-15bd-43c7-afbe-84a951f97044@redhat.com>
Date: Mon, 22 Sep 2025 15:28:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: use [pmd|pte]_addr for better reading
To: Wei Yang <richard.weiyang@gmail.com>, Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org
References: <20250920005416.5865-1-richard.weiyang@gmail.com>
 <4fb37530-3826-4ff5-ad7a-dc9dac4937de@arm.com>
 <20250920090228.lovkrpwj23bqdamj@master>
 <93095f34-d7ac-40c7-87c7-60d2c64d4800@arm.com>
 <20250922081226.hsglokm74lh2eng6@master>
 <89afa6d6-0a02-4825-8923-3752397b38dc@redhat.com>
 <433cba08-e33f-43ba-bccc-a2b1f2b1cd50@arm.com>
 <20250922130255.lbrrbrr54iwso42i@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250922130255.lbrrbrr54iwso42i@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: g4vjaPj6L74hQqHNTJtzRePO6kXjovOjljbGOn_mbYQ_1758547715
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E7D81100009
X-Stat-Signature: x9uitod3jtcc7dz8d14pr9bsz9ygjnrc
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758547717-959789
X-HE-Meta: U2FsdGVkX1/tzt55QjKLkt197G/gyyYrxtTSrEjQdzZx7HRvTUBphAajJ/bzjC17sSDl4CE0N6S3XBAO56bXW16pfOozSciIwRck2UVqMe8HBhtTN04SI2Vwx3hzapTAo91bSPePI2mmfVUzXbDEaw6KhscJqHOOZ/CcEgUoxkwCRzCFtU/IeyXcJjp6ivu6QtuJPQyiGVQGpNxK35NgeaJnN4gg5l6SO56VAlYcnyJySnaaaqVXeuf418A53Pwkg4eymI8RVkbdLzvl2iEVgNDowyKS/JrzfTVpFidhGar+WcqvTGiKSI5RNPcOws4PEfaZg2HpTX2ZyVGoLiqrJWd8aPMqsZF+OD93wZb9aJKHByggN/y0OOSU4K7gecrtrTttfI5ZR9UPxtam58C2LgLoZujlm+QjcI6gh3tFFSTaYNDAI/xFWJf0dhmLTNpPWACVLyzz7PAu6aI4PvuN/QPu4Hw4Iu37oiYDgWR+zAMZbp0dsZRHzGkNz3cEVAl8PycGuZzdcF8JOkcEP+WX5Rb73gcFGKadeYqaSoGBxA4Xhs+88v7xtnST+SD9zP5BXuJLDc55ev8+6qE88RVSmFlFQ2xZ5reHNCa0U29DlzO+2uxseVdX7LEsXEWaNb2jVoCIuZRjnho0RfuAsMA8puHw48/TkF8Nt43wIq34IdeXBxRCmPswiALfECJs/yywxZ66Fb7yofDrIolH4di7GOIIxjbfve/b9hpXnpnnv21zgvLMIwRa/QYn1mh+BV8KkQC8srQGVPSJFyVqSjKJhjBwjaTqt05sML+fLibiCor0gF1CGW4kpISlhlOhB9UO8yspxSVOH7Qm8SFfFkxnO5ntdiY5JbTKVdNRYnwAfuslP2N80EDtlafIyxLs7Rg/JJyBqEQIg2XMOkA5HwiiFF65vmezRPcnjFVBEH6MOwsCiU6r6e/E/RK/Tfqm8l3Qt8kgDhSYQSnCFq9Yo3L
 vn7IkqgP
 xyg1XHzhjAg5v3wOqHeBH5wIUGnTmMqHLf5j8t1XKh957p5NbaK7sIPclecDBfu43IB21KJkCfHyXXyxIGP7j5/e5iv5YAOaoEh6pUTv4XwFBlUPmxz1Vf8SM+2lv4X6OSJq+cqPWn4RoLD2hxZnMid0fYA3RxqAfiasF6YW1zJKB0eiPQx2HhHI8OkN0nvFtX42bt2ob46hIvxi0vxOnXcZYFAkqKQzVjLUNqzL/7yU0jPDZLYD9KpJ+FlIbheV26sJ6+xPT7xW2ZmSM6JFgHn1tl0HS6lh6ybanvn+BS068o1fOiEO/oLgBLbnmYjqmGvSLx3RaorqAZVX4EpJtv4EbchQ6l7PxVEoEVnJsBMJIbv9PuxlJQXHsW/GWen4MqmBVMrBkfEJqiXTI1NNhwEvlDt6jRHWvzKmMv9Kyqb1e6h9DiEJkXThYbnG2ZwDkfACkH+jRKFE8Y23ys0/mO3KxpURpbFWqyn6sDgMMmG78HLqNaoEzU7+gjn8zO4us/9SZ1YE9wA9BkeUkvsnjz97pdqUhpIVQ0KfrLPXLfhTn96lTgkqDbTQ4MBeamrRLsVIH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.09.25 15:02, Wei Yang wrote:
> On Mon, Sep 22, 2025 at 01:56:54PM +0530, Dev Jain wrote:
> [...]
>>>>>
>>>>
>>>> Take another look into the code.
>>>>
>>>> The change touch three functions:
>>>>
>>>>     __collapse_huge_page_isolate()
>>>>     __collapse_huge_page_swapin()
>>>>     hpage_collapse_scan_pmd()
>>>>
>>>> Use pmd_addr/pte_addr look reasonable for hpage_collapse_scan_pmd().
>>>> And haddr/addr would be suitable for the other two.
>>>
>>> haddr vs. addr is just nasty.
>>>
>>> Can we call the aligned one "aligned_addr" or something like that?
>>
>> This works. Let us use aligned_addr/addr everywhere then.
>>
> 
> Including hpage_collapse_scan_pmd()?

Yes. Anything is better than what we have right now :)

If we just want to express "this is the start of the new THP", simply
"start_addr" might also do?

-- 
Cheers

David / dhildenb


