Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FB01CCD1A7
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72B3E8E0020; Mon, 20 Oct 2025 10:17:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DB5C8E0002; Mon, 20 Oct 2025 10:17:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A39C8E0020; Mon, 20 Oct 2025 10:17:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4305C8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:17:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 762915641D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:17:15 +0000 (UTC)
X-FDA: 84018694830.01.B7D4653
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id F189DC0006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:17:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dd5AQGut;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760969833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfYAKZOWZrksi5qoX4OmGVPw0kd6k84iLxlHCLK7oEE=;
	b=nnM7bKuRLeBFn0CMHsuntdXUgjRrPbPytP5upnD3eD6nAfqY68+LDZV2p3KcSNpgwnjxno
	Vr0JCpd0Vb/qHoR9elbmetmAnvDugd3rXimNX7NHcHk9+BUaNGuqWUjusDXdVnWspN6dYR
	AN0oscoGwQkqiageB5+IGmhDVjsxVs8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dd5AQGut;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760969833; a=rsa-sha256;
	cv=none;
	b=8iwVD4IqtAZgnfkb0ByP5QJEycHnNtPVqamEupFTAbXdpMf4E2X+gcNeTmlxwYA6sbUKcq
	Y6ARn7yA5cNW7HiHleJ6FITKa+/cI2Vqdr96UubNXtgdzWMJHlXa8mYQmRRffLuMJD2WrS
	qzwUu+pCnYfk2eyYX/OuMmG1xrNuZ74=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760969832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jfYAKZOWZrksi5qoX4OmGVPw0kd6k84iLxlHCLK7oEE=;
	b=Dd5AQGutDeRoRx6+zZ+Lb5h0FuynFjHUS5ihPKGAu9B+21m9IZn5j68HPnmIGET9NRL13v
	9YoIOx5Wl7dQ7aVnMVodqWoZRnvyW3TtigaYAh8ZN0GnCYNI1e+BviBCekv2IeSN0/xPT4
	YeA2XpYI+S2fpNf3b/thupqnbqxWUAc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-YCv2wp9TMz64e0kf_Doj8Q-1; Mon, 20 Oct 2025 10:17:09 -0400
X-MC-Unique: YCv2wp9TMz64e0kf_Doj8Q-1
X-Mimecast-MFC-AGG-ID: YCv2wp9TMz64e0kf_Doj8Q_1760969829
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-427027a2095so4972673f8f.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:17:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760969829; x=1761574629;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jfYAKZOWZrksi5qoX4OmGVPw0kd6k84iLxlHCLK7oEE=;
        b=D01Uk/xmbeiOMlArGcYOmu6C/LxcycpL2kzdZW8356pwUiQhjC2UsidiiaUuxiS9WZ
         D8CYQXhLgagUEr81xGA+y3QdBt7uzRKEiXGOxNdzidrd79Nd/z4JGdvtDyYHRUGonoHm
         lWJb9tOktVvPC9pE8ZNzai8HcVpQggoFqd+zu9MeT0/7NEUdBQ4eEM03MXC5WEBqjcpl
         pykNi9MArip7q2/ES0EZauLe1OilHx6EsK+y/u/r1VvIhnE8eGbEg/HswbVckNRDTEBb
         BoeoV/v/Av22ILvwCGtE+kmnpE66yqA0f18CW1ioKkh1YX/Q7nZBh2RsAneqPV9PfORt
         3Cdg==
X-Forwarded-Encrypted: i=1; AJvYcCVFRgitYHTCq01RCFsrDBoyvKMyKIDpF1t4zpKajtsPLYhDIjfz586X85pi28ik6dQ2fKWBll5r8g==@kvack.org
X-Gm-Message-State: AOJu0YwfkgXlZ8Jh2dodhCT0ZoTZigaHUpA4ZsBg7yeXw0BIsHNPxZt+
	EePTlXGfsMD0DvvU46FSmF/qHmBZm0MfKK0kM4E8P5GbakW54ft1bSWM47lS9hGOGJn/+gdS9XO
	BmDL3jWQJH6E8iSxBQvhymUmCpH2m+HLLL30FZCdWY+1o56ZhYcMr
X-Gm-Gg: ASbGncsaYb8o2opnyfMlawxMquFewFPysSRVYnD974dGiUWwfEPcsmWVH1w1r4XHH/P
	L6JytncvlSkmUT3Lxn8s85LMQzcQyfVtpIvaqHLla8uRcMulcf8teypqnbdyhyVbU7TmNXt9ndn
	bicjfHof1QVL0IsbiaRjk52sEL9CtyWfXtf3+RiBbL4n3GOfq0kUwAheyQAPrQ8Ua8/C8G+aWMI
	jWmbpZRKZpBfzS18PUUQT+TAKMb3OX+yMGXnRbj4LkbviqSuqN9uFCPicfdYZKBmat9LVjYZ7O8
	BmL9eUvuDrn6xlca2/bMEoFbM2RJsiVvZ2Oi7qglNqklBZU2xrMPNA0s2KHeAU+FCs93OLhFH3i
	EZDSTdCJQgYTmmuhAbkZCdo0REdp5hvglwsv6JnfxVPJa2VIWF8Me2F9Lj0+B6hVpueFg2pfLRY
	WLIkwUphig29lEQTL7DkWkJ5jJKlI=
X-Received: by 2002:a5d:5c89:0:b0:425:6866:6a9e with SMTP id ffacd0b85a97d-42704ca6ba1mr8775153f8f.0.1760969828678;
        Mon, 20 Oct 2025 07:17:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6OUvLi2k38V0HguToAtdytTARx3HNV77YTxzJsGCen7movSvk2GULYom+MGJGITAx0cpoXg==
X-Received: by 2002:a5d:5c89:0:b0:425:6866:6a9e with SMTP id ffacd0b85a97d-42704ca6ba1mr8775103f8f.0.1760969828192;
        Mon, 20 Oct 2025 07:17:08 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a993sm15520367f8f.24.2025.10.20.07.17.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 07:17:07 -0700 (PDT)
Message-ID: <6fe3562d-49b2-4975-aa86-e139c535ad00@redhat.com>
Date: Mon, 20 Oct 2025 16:17:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm, hugetlb: implement movable_gigantic_pages sysctl
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, osalvador@suse.de
Cc: corbet@lwn.net, muchun.song@linux.dev, akpm@linux-foundation.org,
 hannes@cmpxchg.org, laoar.shao@gmail.com, mclapinski@google.com,
 joel.granados@kernel.org, jack@suse.cz, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
 Michal Hocko <mhocko@suse.com>,
 Alexandru Moise <00moses.alexander00@gmail.com>,
 David Rientjes <rientjes@google.com>
References: <20251009161515.422292-1-gourry@gourry.net>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251009161515.422292-1-gourry@gourry.net>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: z9UCk7W0OpqtLe3uMod94_b1kNfWl0T_yMvycUSnZ7U_1760969829
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F189DC0006
X-Stat-Signature: arrpkb9ofduzage8aqsf76kt99xret6n
X-Rspam-User: 
X-HE-Tag: 1760969832-515578
X-HE-Meta: U2FsdGVkX1+PKMoEft5Co2zj57kO++u9simHpMSoAAL0YbsE3wp0B9CKFCcuv8HgFa+Q2eYOVoMfqrRCnGz/8EdJPicROPc9j1JV6CtJ/YNGRHAdmzFQUlaI7UHA5Q/D6v2Qujy0yemWNz4e2eZ99e6Jo/8WKPQByVMnCkxjpY4h+K/yW1JwECyqVxdYarqjT1m50Lmo4Mq5/zm4/KELr+0Nfq3bFJAhgf8M7ZuGyPvXAH/dlv1PVEQivSWOBjRMfrOe6hujN9wBAGUQtld/fRyU8k8NjNNm77jj51GAs2Bf1FT44lidyxO0sJqULjRws8JoKJqSObZqsK1OdZm34owfOpbpsoEx9hN10P7+qqSxjm47Kku9H1Xo0YENYEBGOoCR9YGaCzI1KsD3lvU3ftp58QXkh8Y3SsS5EHSMtt0J2o13U7R6zTl5YBU+ACT7Stos5OKd4JpKG+ZSC+futTpbm59qca04LMTCPxsM3RFDI84g8KKQw/ki5afgbXjQaoPCUYU75jx9slq7fNWXbeQQhtcrNyUSDXg65kCkK2H1g7nUBWmDOIY6mU3ZYUPyfNUX2hcjS9kdkWrIQNcpu5VbUhIowndhIhBHOGu+oVWztiXJD+1ZLbxN0EyfSrDeQAqftCFR008me4egW0n6NVwC8S02f45iFFDFvaBS9C4c48sEk0fvpVR+UNYf/1NXL2UjbfFYEUL8WxAyVFuYzY1uR4cp0BBGCoC3jOOWvz+Qu+Y17Aaan2YDBPcdj72+9NH+q+0JF7r+we6Ea3O7rCBw1GQDv6hC4kMTmXUIzP/9o8aI8P5DPKBZamJZL2CtfjqHFlCF+zFt5yaKbqE4q24Hl1FnAqMv6YPLFxmgn3jqv2mQE60U+pVsRTd5HFElDiRNbaJ8QuzhDqXpELXEyqvKpaIURogR0U+BCaAEIi9K27NfeEQgz3b4566yCAKlC2SzD3mhmdFabPvbvlA
 Vco0zl9m
 KS5RgOtQmITcRybXkBLvrgZdYOJfyCSNiiPKIcSkYj/JWqX6nGxP0JR4UMwOtj+3loshxKbOs51wvt6RTZzj23Ehrm6AMdNsxIb4wiBkkdpGozaFG9+prBvO53W6GmB/fRSEddWxFrjMxPq6oRbgvUl5OG0dF68i1lGYx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.10.25 18:15, Gregory Price wrote:
> This reintroduces a concept removed by
> commit d6cb41cc44c6 ("mm, hugetlb: remove hugepages_treat_as_movable sysctl")
> 
> This sysctl provides some flexibility between multiple requirements which
> are difficult to square without adding significantly more complexity.
> 
> 1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
> 2) onlining memory in ZONE_MOVABLE to increase reliability of hugepage
>     allocation.
> 
> When the user's intent for ZONE_MOVABLE is to allow more reliable huge
> page allocation (as opposed to enabling hotplugability), disallowing 1GB
> hugepages in this region this region is pointless.  So if hotplug is not
> a requirement, we can loosen the restrictions to allow 1GB gigantic pages
> in ZONE_MOVABLE.
> 
> Since 1GB can be difficult to migrate / has impacts on compaction /
> defragmentation, we don't enable this by default.  However, since there
> are scenarios where gigantic pages are migratable (hugetlb available in
> multiple places), we should allow use of these on zone movable regions.
> 
> Note: Boot-time CMA is not possible for driver-managed hotplug memory,
> as CMA requires the memory to be registered as SystemRAM at boot time.
> 
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Alexandru Moise <00moses.alexander00@gmail.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Link: https://lore.kernel.org/all/20180201193132.Hk7vI_xaU%25akpm@linux-foundation.org/
> ---

I just remembered one thing, maybe Oscar knows what I mean:

At some point we discussed a possible issue when 
alloc_contig_range()/alloc_contig_pages() would try to allocate a 
gigantic folio and would stumble over movable gigantic folios (possibly 
triggering some recursion when trying to move that one? Not sure).

We wanted to avoid having one gigantic folio allocation try to move 
another gigantic folio allocation.

I think your patch would not change anything in that regard: when we 
scan for a suitable range in alloc_contig_pages_noprof() we call 
pfn_range_valid_contig() .

There, we simply give up whenever we spot any PageHuge(), preventing 
this issue.

However, it also means that we won't try moving 2MB folios to free up a 
1GB folio.

That could be supported by allowing for moving hugetlb folios when their 
size is small enough to be served by the buddy, and the size we are 
allocating is larger than the one of these folios.

-- 
Cheers

David / dhildenb


