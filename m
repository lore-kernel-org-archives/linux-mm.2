Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CDEECAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 07:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D679C8E0008; Tue, 23 Sep 2025 03:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3F498E0001; Tue, 23 Sep 2025 03:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54E88E0008; Tue, 23 Sep 2025 03:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B525A8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:48:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4650C1A03B9
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:48:16 +0000 (UTC)
X-FDA: 83919736992.02.6D1B5F3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id CA26E40003
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:48:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iMBwuHw1;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758613694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZUh2vkC0SA2Ctt3d3LzlNvVmbu2mm0LewR8mVwShHqg=;
	b=KilwenOQL8lfEQxa22etISqhXh9cCly8brOlF5/MeSu2Vl8FR2o4zZwLgtTCUbDFXyjOv3
	t2o+P2KVaun38rToNJdfrbZZj86KVaVZZA1ynrgV79YGJ4ZZ4AQAAXuszYZLzUlEi1PI/6
	NOkW3aROSEC8Kp9dNpt0JpZMqHNfQ3w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iMBwuHw1;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758613694; a=rsa-sha256;
	cv=none;
	b=B4OpnB1+GRIdRJ2Sro7nvCakJWhzC1Z5je0LDqeV8P18G/mRbjlwUqVrvoVeazhmcneQNv
	FzDBEMH3d/Z7gHhmlFk5CIIcX9VjJn5n4dxtHkHmnxxtf4MPTtni/Ebr2EHeqIx9kbip+7
	WuYKGMB4SgUdklDF7Ac0jqBCd6AXg4Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758613693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZUh2vkC0SA2Ctt3d3LzlNvVmbu2mm0LewR8mVwShHqg=;
	b=iMBwuHw1goTvFipPVH7A1KXTxDT+RRUaI/CJ+ouGdm3D78b56lHM9wVtcHiFF5ey2wEGFd
	6FsvkieoPk1tksmv+8+IcpUA/IEbniggJfuc00nP5hWXZrpzE75raTw4r/iPgKa5651AuQ
	O05LmsrBXu4xCR66s5x2QGIVJ0ea9/o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-jctz3EoVP5irNPCAy_9vUQ-1; Tue, 23 Sep 2025 03:48:11 -0400
X-MC-Unique: jctz3EoVP5irNPCAy_9vUQ-1
X-Mimecast-MFC-AGG-ID: jctz3EoVP5irNPCAy_9vUQ_1758613690
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ed9557f976so4601000f8f.3
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 00:48:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758613690; x=1759218490;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZUh2vkC0SA2Ctt3d3LzlNvVmbu2mm0LewR8mVwShHqg=;
        b=lCLPCMezrnxsPZQhQDOW2HXcjgpjRpcrPnwwUbG961lRDTC+D1s1nEmXoi8AUxyGMZ
         KUgywP5AJNtSwfR9DEF4oq4hukwj7xniXNncKVc2gPBjfshMFY56m8JhIs4DnY/sl8vF
         eWsae4CRFYAR/wTncHr/IjRvel/f92KYr7XDzXZEP2BN++24s8W1MO+n5v0wckfTVe8w
         n/V5JoBtz6kuT3M3Hkr3Lo28ipH//NQQ4ZX2k+McGWuIWFXvSJ5QFl4MXcN/UBoQdK1y
         5Nn0MyDIARwVSDQe0TY1Ea98mbhjCOOMtLSrsRb0D+foDeZOYCSiB4ABvfzSwvz+5uji
         LNYQ==
X-Forwarded-Encrypted: i=1; AJvYcCXP4PVDcuRrhGwRoOCCDjv9daQ5RXe/N3XxeJ2ncwxkyGFfUQv0NlA7Tw2SpU5+aj/WmHpVOIkrSw==@kvack.org
X-Gm-Message-State: AOJu0YzFVGQ9SRnOD81v+DDR9TcahaqhGMZX2nnvHLqSVADZgFuB4Jq+
	mY6pCWWczXt5TI2soUVcC67E/LvBeW9QDvqTXU1jeFWBcCzSDLGqyF6cF8a3ba/BB6ishvfiyhM
	g49iQk4v+2xmt8W2Tx5nxGatu3OAhBx0k8MGsSVLN3fkb8Ifo5Z4X
X-Gm-Gg: ASbGncugQt0LrQRfNlXapECWy3bW43jheuONv4Ozo/WzMspekfnEIlKTZ2XuYLQZKva
	wGp6LUKBxw5PnsHvsaOcPb5uAZoLRIAjS+q8bMFzU06hmzb1XR8XobxrA3hJvcdcpODx5FTwbYD
	8haS4UA3UBe3OAYKEnQTcgUdMg35LwspSN/DIsNyakjLMZ2l/RNxp7gOcA5O+oAC1ZUDI6w/Onj
	FgedTbY5Bi06yE0VWhr8zuKMjJ6uNHbAvspCKdvtBHt+FNtk1Y4TwLL21rU6UkrS4lWAi7aMqhu
	L1ZwKq1+Axm97Elef8f5aL42pBb62K0wXPsBrhVWlzDVq0fiRTB6GcCTsBdfZtzzNgTTMBA=
X-Received: by 2002:a05:6000:25c8:b0:3e7:1f63:6e7d with SMTP id ffacd0b85a97d-405ccbd6d4cmr1330619f8f.45.1758613689801;
        Tue, 23 Sep 2025 00:48:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOtn/L8v7tY7J9Kag/hNQN/fpxnmJTdL/lqkktLs4zwhBGhytD1o/jrIF1jZkpAtVHYMx0Ow==
X-Received: by 2002:a05:6000:25c8:b0:3e7:1f63:6e7d with SMTP id ffacd0b85a97d-405ccbd6d4cmr1330586f8f.45.1758613689414;
        Tue, 23 Sep 2025 00:48:09 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1fd57.dip0.t-ipconnect.de. [79.241.253.87])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f61703b206sm12603959f8f.6.2025.09.23.00.48.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 00:48:08 -0700 (PDT)
Message-ID: <09284390-5a1a-47e0-9929-0a5ba98c836e@redhat.com>
Date: Tue, 23 Sep 2025 09:48:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: fix alignment for
 alloc_contig_pages_noprof()
To: Anshuman Khandual <anshuman.khandual@arm.com>, Zi Yan <ziy@nvidia.com>,
 Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, Oscar Salvador <osalvador@suse.de>
References: <20250923001943.2479-1-richard.weiyang@gmail.com>
 <3BF1389C-4B8E-4F50-AB0B-F0D96833D387@nvidia.com>
 <5491dfda-862a-4c31-b64f-5339007a5302@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <5491dfda-862a-4c31-b64f-5339007a5302@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IodPGLYtnqrHu68mWNP4hjTN1Ox5pAorvC8eQrwnEFk_1758613690
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CA26E40003
X-Stat-Signature: oncrenmfdxehyoh6cszrrpgzmhsi9wba
X-HE-Tag: 1758613693-259892
X-HE-Meta: U2FsdGVkX1+Y4Ole+BqqurUjMMfAYQPFATobsAAyERT9Qzq5DORML1OYezIYsRttGH12vJCwjQZOGnGH9vaiyvHgWoYlqPo7ols+GfEQQekRQ0c0y7/T/y6GxOENoE+N4r6lm2Nq691KD0tXmPUOJm9zsjbJ10zL6618jwDZPLUKM3tzXQuZcbYsRByMutp5W9Wr4WHLJJw/reP8r9tMWLWEROPu9axbMo3SDHdBjLx6LI6OLu+jk1I6PL5XJjEMWEeEbLcrXJAxqwxDAB1x7l5LuclrJWMaN3Nqk8ha+OSMNMe7SdZVRBoG/+XVtnQlWCzU/bMRDry7IJHMjtVE15Dwp6X8igxkOldaI5yzz9tRq82KGqf3Npw9qYfUt+gSdd0seT2+OA4RiOoATP0HWNHG6uPSJ8YrYhHgFz2lTe3gTW8/8OoHSqG1F2795o7Fbg759ssA+T+o2raqagZ+Pe0B/z5peqhqqiqHla0sUzjOMza0y8pdcIuczRqrRFeb1FCLkc34STBkC80tt86mhIRtNwyZxwUG0GostXpUcFIE3rNw2Oh3nyf5xlcbjQv8d+ZcTjSiOKycucmxx8O9KH2oBkvflKKTHebEaaUi5OPEGp8sf4483i76VnpLZbiNO97kNGBSuOBaR99RUFEXilRsxGSZ70IRGTd+ddmbQPKJgYJgqW+IJH8Z4tUJ4GawDMyDNJQJA3jIwWHAu78mJVsDZpUrP6ux9MDJuFQC7oxXvOQHXRorJi/wE9wGQ/RXC12pKnpxfY7mHpLAMfXIsILK4xXB/uapDSHvf+Rr7Yxn3ryRWeqSE7BX8nLsxVZrJ/TbUksCfpI39ZG//Kce2i0vEilIk1XrSy18do7FY/WFCY1pgygcgjtZ/VHmsCDcc9e/QyE+wfX8mvPSPePx65kpHgJ0WbdhbcNAAFgQI8lXe14hbnfQY83qjREfNi3OGL5wkEt5PPAPRYGJXi1
 AmfpHLM+
 9dKXHSZWif3SktdWE3aofU4p8odCU3SgE2Uc4vxQVqFa9xzEIHjweZaApsLsXbE4cMGMNov1RRK4CBMDbzAOxGiCksSolvGq85KDVGbt4fcwSzYI/bnYfJ1xYhs2c4WhkvEfj+ujPSt/6NPYd1VhagrSMBLp0M+ACQrtIOmg+6WqC2hblO818hdmDVEqudnFf9zaq35d+2QloEQcmJHlBpUi3Uvf/uuKdIxJUY3WOMNVDfvMBKwj/jy5hfvA4bxM5DWvDJvCT9HJ4yBTAU59j2pnQ8S+lJ8pCp4uNMW810AexZJi68gaBJmFzihsit7SnlF9dIF0j/kM7L3t187fkpBM6KXd/N9cvLKtE6fx273X3G/fQtvyoinq/DIp1S6bGbKFy1HKvlDT+3yj0TmVAnFSVubSN3iGoQDi356mQhsBEywZhpav9Yollq2CILcJhi2ovAcKJ+7wYzuQdFsyIsslPOFgyLsiqwPCV2/BROZC349zgLhSWJDrckdlx0riYD4OpowUi1fptACEqBSm4ioHPsfS7fUdJpKxSbG5b13+ePF9eqZgKHciOHUNhLuKJ2EUCVh9NtkMMqDurw1ipB8oSobAlWqzrN9c5Y7L+KMvyz/pjnOEPHXPSlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.09.25 09:06, Anshuman Khandual wrote:
> On 23/09/25 7:16 AM, Zi Yan wrote:
>> On 22 Sep 2025, at 20:19, Wei Yang wrote:
>>
>>> Commit 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
>>> introduced generic method for alloc_contig_pages(). But the alignment
>>> calculation seems wrong.
>>>
>>> Since ALIGN() only accept power of two value, while nr_pages could be
>>> any positive one, the result is not defined.
>>
>> The result would not be any value lower than zone->zone_start_pfn,
>> so the worst case is getting an unaligned PFN range. I guess
>> most of the time nr_pages would be power of 2.
> 
> Agreed.
> 
> Also as Dev had pointed out earlier, this function gives no
> guarantee on alignment of non-power-of-2 requests. Hence I
> don't have a strong opinion either way, but does it really
> qualify for a "Fixes:" tag ?

I'd say if there is nothing to fix, then this patch is not required.

What likely does make sense would be that a non-power-of-2 would be 
aligned to the smallest contained power of 2.

E.g., a 6 MiB request would be aligned to 2 MiB instead of multiples of 
6 MiB.

Not sure what the existing ALIGN would do with that ...

-- 
Cheers

David / dhildenb


