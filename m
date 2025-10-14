Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 925C8CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7E988E012E; Tue, 14 Oct 2025 10:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F288E010A; Tue, 14 Oct 2025 10:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6A98E012E; Tue, 14 Oct 2025 10:30:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7F858E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:30:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4660913BF6D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:30:02 +0000 (UTC)
X-FDA: 83996954244.14.877F165
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 01503C0010
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:29:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h9n0TVXA;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760452200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFKPyi7QTrUFRgjRxc+KcY0otJ1gluh+WRQjU9bwR/w=;
	b=wubp3hUTbp5XEOzQsqVEM9IFh/DTEAs1gaWqR8YvUVBfiRgz/LYE2lTeQu6kODDF5KQIRw
	LyOJwXjZdd27BQEkRkz6OdxyZ8pudc+KhMCk8hbPOGXqPvwQja2Rx4LfYw5an0e2QvpvJ5
	yUlBGRN/djwXj5CxXy57JKmoVEB3hE8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h9n0TVXA;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760452200; a=rsa-sha256;
	cv=none;
	b=Bm4tYPwCrscDmuACRvlimafDPMhI3xv0Z/U7YSZVZFpoh5orlJ1cLyNJmwvaEQRCfX6CIi
	1VaCYFufbNRVEdXAvBCRT/6JoAV7YkTb36/yPAIEd8P/Mo+qLRjvNmnfqcTGVj6DYF+0qz
	7nmg9/2VzYah54W8MSdCNV5UbMaE0bY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760452199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UFKPyi7QTrUFRgjRxc+KcY0otJ1gluh+WRQjU9bwR/w=;
	b=h9n0TVXAJ0ViSshDUccEVJo42hTx+fSfom8GCsNmOZ70PcN+yhU9EibjUPciQndjaCRlrt
	ZUmC90hxbIFDqsXIIUKd+0wFhdhWwh5nIOVMY0d3evKUi6uk9Vdn5fGuz85iYgnw1BcKEE
	xHfo3E66oqpypjXvPbjURAgXqFcUuFs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-571-PXsVmP8MPxW38119Bs6nWw-1; Tue, 14 Oct 2025 10:29:56 -0400
X-MC-Unique: PXsVmP8MPxW38119Bs6nWw-1
X-Mimecast-MFC-AGG-ID: PXsVmP8MPxW38119Bs6nWw_1760452195
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3f384f10762so4675985f8f.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:29:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760452195; x=1761056995;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UFKPyi7QTrUFRgjRxc+KcY0otJ1gluh+WRQjU9bwR/w=;
        b=iiwWtNKQFk2g2NRQ8Jn7cj8bBQWOG2FOZkNaC6FY8wg03/pC2mZD4C76iAZyODNyH6
         YvvoCSCn7VzbKymXP/eTuCn0jNncskFWI6AdCU1xIkASfOlRWGPKJiqKvH5ODYiC67WU
         5d8qStYJjSYTj1rQ0HAujdYgd3g9sSowMC4xyg8cR63P0ZcisL3N1M7a0S2c5O5fCwr2
         tweN5tk+Gx0xABVnsI0ROV7x7OwRQ9Jtb7C7aPajmtx0KvQfY1Hu7MBIt1u4lSO6beGS
         6nO0PoZghaOY7Kt0MLmSiv5jo/QE0MrSUW6/l8dm7ZLp12dpXs8s1e+MIIxEW8TTUgB2
         sADg==
X-Forwarded-Encrypted: i=1; AJvYcCVTa75mgWPjuC8eYRobqONLLQGQSeyfySaT9BZQorP2U+1M3KpcWl8HrJIa7v0JaOTVqWj5/agURA==@kvack.org
X-Gm-Message-State: AOJu0Yw+g3Zg+ur8BzizvS3Wox16bBI+TWE96c1ZJIYH3OJu9933StBQ
	ns8Wx7bkSv+7A3A64NiPLUDiEWpvestjazY5hg4BaXVNZ1y8nhX5Q6ndztT6qJjqF+5nwPRYafO
	n7aylxgMPaed4ScXpiICEcqkNlIVVlavpkr9HQP5O7h/bYZKZUHWN
X-Gm-Gg: ASbGncvKnqSoIGfa18zD/d9etuWSIhIL8IgOb5EVNqiNLN2B4F8BTTglfkYTcnnqxge
	2ygv1sRHkxOiDJyt2Z/S2ROqTH8g8DOQy0+35PSf5cvGfJQUuT5dU6VAuNcm5ld7rCRwEvfnBGg
	6OmnB0PqV6pYMsCLudyyCNl+VfLfnyDuwElbHVk6HkCzN9biyXYzNQtVY1xgjmMsmEtDFUXy6VQ
	PCiira8/PrNwJHtcasHKlMj5oaGCmGD+C6AxeBF4fdhcc7XGvWfAbIadAgNLXcZ1g7bXSyiE3mT
	XqBS8oZojb+JvlBDYDho+bqYZqShikiXMDTtlJmsGBxkme0ee7O9tRUDJhI8wL6XXqOzgPkoJA=
	=
X-Received: by 2002:a5d:5c8a:0:b0:425:8125:ac79 with SMTP id ffacd0b85a97d-42666ab97f0mr16064628f8f.25.1760452194824;
        Tue, 14 Oct 2025 07:29:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFCs5Uq2bjb6FBvbszcIDA1BGaWI1fo3lzZMSqgsmNNAwQgGoq2mX9mDWZ9CeSdVoO8ANTMQ==
X-Received: by 2002:a5d:5c8a:0:b0:425:8125:ac79 with SMTP id ffacd0b85a97d-42666ab97f0mr16064596f8f.25.1760452194295;
        Tue, 14 Oct 2025 07:29:54 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab3cd658sm159792605e9.1.2025.10.14.07.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 07:29:53 -0700 (PDT)
Message-ID: <83d15ab9-55bf-4cd8-8b3c-007253dfc175@redhat.com>
Date: Tue, 14 Oct 2025 16:29:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] mm: prevent poison consumption when splitting THP
To: Qiuxu Zhuo <qiuxu.zhuo@intel.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, linmiaohe@huawei.com, tony.luck@intel.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, nao.horiguchi@gmail.com, farrah.chen@intel.com,
 jiaqiyan@google.com, lance.yang@linux.dev, richard.weiyang@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
 <20251014141935.1878315-1-qiuxu.zhuo@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251014141935.1878315-1-qiuxu.zhuo@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cYuj4_59Sob-WL3e5DowW6daQX4ybotpPfsf4kez5xY_1760452195
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jtq6qzqjif4st8o8cosx5cg9kfy5y559
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 01503C0010
X-HE-Tag: 1760452199-733615
X-HE-Meta: U2FsdGVkX1+dZYRy6XynvEhy1233Al10JFiA9cLxRed7f7Vs/mbqzFRI0W0Gi6wwV0n2HuLMR+w8tEF0zHzgkmccc02/06G4kn8xvX5wRKbCVHgiN/Af3YIvkgGh2cjohHKrMTdM4QRLh3v7qRTUeptwjsb/aCiuHQTWbCZZQVscKFKIWUp1QiwrOpupVaDDjOjZWZ0jV++gv7cotzjmZpsedPxlWyoKAjF3aSg8K5pbNe2/uMkPO7Vi4T4YDTzN8XnwWhE2MoNhHf6f/uJfZu1kQxScyCEvfjYFnOicR9OiLXTsv4Xv78vnNmqAo4fanyii/HaqV/20+k4Utev3HyQZLbwb/p7Twvl5pKKWIAxBtv7H458ADEu5/8HIVleZ6RI/mE8mb8zPhL2YXUVBS/sSg2mSDSWsCFNQAwIbwZJW53dnemE3uo4pj2pjrm0EXfQeYfXq6Q/9DNCwQkb4lAWfI49WvRyFFWhQM04k2Wex5wLqL87w5Dj8Jf2uLIvPlT1KnHvMhruEU/a7K+I5xtDafyFbh9/qAucxditvPqrssZnu+XRr8vAnaQoj86FTZ7Bp+NDI1hTAxaBUZqcrRcZchmD55HYp+YUJA+7Hx5UwLcSEQ1NaGP8KHv6MpqqjMZmxV9sLMhPCWvufrDaGU1nZi5UCBb+rtgZKbo+RbTrO4Wpx4g8brZt/ZSpcyl+SlFMWtFMrzeRSe0tKBEVt9e437HFRCYdJE+8IXrfYpVcC3WRmNQqfTThIKSH09FXXiqyUuxBbLLSoKR1YI8pWRobVXJDOwWP0eid3YxE0orl4JniIKMqAl2WGUuo94LiGEAhHgJIw2Vo5cmA1e2HUfK4gVK5bHdkSl88Si3uG5Cs+xpp80lqKaSo6hSltXvQNMUQGQmeQVQJj1LLfj2UBKrANY1lSTzmJZC1wjLMA9rMnumVyNHFvlNdUxQweRX7kgJz9h2c6Mdmpi4sZZcb
 Bew7RUdg
 ZNEZ2m/JiQXyqegTP36IMuCiAGkXgshmgNS8xrAD+esHIzUsX/jtwCN9EKh/ltzife2ObbBpRDoq1lyryL03cLR8P7YC1VqOpI5alg02eht65r+JP40P0YNjQbnshqC29dOUl0lGyULfvn4+Q+0TY/f12Mn/zzmgnRG6JRU8/7D+uBpRjr5WnyVqMxATY5wuV4MQdnOvE40OCy6c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.10.25 16:19, Qiuxu Zhuo wrote:
> When performing memory error injection on a THP (Transparent Huge Page)
> mapped to userspace on an x86 server, the kernel panics with the following
> trace. The expected behavior is to terminate the affected process instead
> of panicking the kernel, as the x86 Machine Check code can recover from an
> in-userspace #MC.
> 
>    mce: [Hardware Error]: CPU 0: Machine Check Exception: f Bank 3: bd80000000070134
>    mce: [Hardware Error]: RIP 10:<ffffffff8372f8bc> {memchr_inv+0x4c/0xf0}
>    mce: [Hardware Error]: TSC afff7bbff88a ADDR 1d301b000 MISC 80 PPIN 1e741e77539027db
>    mce: [Hardware Error]: PROCESSOR 0:d06d0 TIME 1758093249 SOCKET 0 APIC 0 microcode 80000320
>    mce: [Hardware Error]: Run the above through 'mcelog --ascii'
>    mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
>    Kernel panic - not syncing: Fatal local machine check
> 
> The root cause of this panic is that handling a memory failure triggered by
> an in-userspace #MC necessitates splitting the THP. The splitting process
> employs a mechanism, implemented in try_to_map_unused_to_zeropage(), which
> reads the sub-pages of the THP to identify zero-filled pages. However,
> reading the sub-pages results in a second in-kernel #MC, occurring before
> the initial memory_failure() completes, ultimately leading to a kernel
> panic. See the kernel panic call trace on the two #MCs.
> 
>    First Machine Check occurs // [1]
>      memory_failure()         // [2]
>        try_to_split_thp_page()
>          split_huge_page()
>            split_huge_page_to_list_to_order()
>              __folio_split()  // [3]
>                remap_page()
>                  remove_migration_ptes()
>                    remove_migration_pte()
>                      try_to_map_unused_to_zeropage()  // [4]
>                        memchr_inv()                   // [5]
>                          Second Machine Check occurs  // [6]
>                            Kernel panic
> 
> [1] Triggered by accessing a hardware-poisoned THP in userspace, which is
>      typically recoverable by terminating the affected process.
> 
> [2] Call folio_set_has_hwpoisoned() before try_to_split_thp_page().
> 
> [3] Pass the RMP_USE_SHARED_ZEROPAGE remap flag to remap_page().
> 
> [4] Try to map the unused THP to zeropage.
> 
> [5] Re-access sub-pages of the hw-poisoned THP in the kernel.
> 
> [6] Triggered in-kernel, leading to a panic kernel.
> 
> In Step[2], memory_failure() sets the poisoned flag on the sub-page of the
> THP by TestSetPageHWPoison() before calling try_to_split_thp_page().
> 
> As suggested by David Hildenbrand, fix this panic by not accessing to the
> poisoned sub-page of the THP during zeropage identification, while
> continuing to scan unaffected sub-pages of the THP for possible zeropage
> mapping. This prevents a second in-kernel #MC that would cause kernel
> panic in Step[4].
> 
> [ Credits to Andrew Zaborowski <andrew.zaborowski@intel.com> for his
>    original fix that prevents passing the RMP_USE_SHARED_ZEROPAGE flag
>    to remap_page() in Step[3] if the THP has the has_hwpoisoned flag set,
>    avoiding access to the entire THP for zero-page identification. ]

Two smaller things:

(a) Sub-page is the wrong terminology. We simply call it "page in a 
THP". So consider changing multiple occurrence above.

(b) You should probably trim the credits to something simple like

	"Thanks to Andrew Zaborowski for his initial work on fixing
          this issue."

removing the brackets. If you want, you could then link to one of the 
submissions from him. The details how he would have fixed it are not 
really relevant to be had in this patch.

LGTM, thanks

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


