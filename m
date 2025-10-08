Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52583CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 10:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3CF8E001D; Wed,  8 Oct 2025 06:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5944A8E001C; Wed,  8 Oct 2025 06:14:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA098E001D; Wed,  8 Oct 2025 06:14:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 395948E001C
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 06:14:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E6E401A044D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:14:34 +0000 (UTC)
X-FDA: 83974537668.04.6F4A092
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8F15F40012
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:14:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VHWbC/iS";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759918472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cs9U3hHfPxfmlIM6BVaiwoAYUcpEw8JWQAav9+M27Fw=;
	b=rJNf6lY9bc2oBkC8E548KRh4jol6lvC7147pdembez97knwN64tsRd+McoOysJyBgsMc3/
	TjE4C/frBwVqyqfh2rQSaFZ2Opt2+hD2uygq8SidiYMNt9l2OwGt2CogUOzaSLq509i3/f
	YSv8EskcURl5hClkAV9/Ygo7GPGq1us=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="VHWbC/iS";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759918472; a=rsa-sha256;
	cv=none;
	b=OVvdqtPQN1cYYCXa8rKawWM0WT0u4B1tKqz4WMb57gkk0Lqjo0w9I3vl1/CQZkNdHbRcWq
	WC91o2V5glQBacUizF+6pz9SawNLhdd4w6W9EvTktOeglQDp5VwXn1fCMpy16zu1ZP+y4p
	f0s+1OswbU6p6R+uoehKiEbh7uXb1sw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759918471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cs9U3hHfPxfmlIM6BVaiwoAYUcpEw8JWQAav9+M27Fw=;
	b=VHWbC/iS0ub07P14PIVmmlY7eT+Rhi+SfGIwOXRxsiHanovTVeFasM9gooKvvODbRuQHfF
	vO5/1D+RiPcP4fAMjgu+F7nCW7DSNMGFYiejnhHotsNfknLz6v3VuX1I6U8YeapP9teaVF
	GjGfB8Z9YGgp0c1X8aZWvULYGITWN2U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-C3K0dih9NqaVsn-ugTX90A-1; Wed, 08 Oct 2025 06:14:30 -0400
X-MC-Unique: C3K0dih9NqaVsn-ugTX90A-1
X-Mimecast-MFC-AGG-ID: C3K0dih9NqaVsn-ugTX90A_1759918469
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3efa77de998so4442242f8f.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 03:14:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759918469; x=1760523269;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cs9U3hHfPxfmlIM6BVaiwoAYUcpEw8JWQAav9+M27Fw=;
        b=xVMypyoXcl0b4k+1D8ulJ7O4dyZeHi9/4OaxxpVqW0AxqzRSKJpGoDc3cmHw8tBgg4
         JE7sxAEvVGZZIcFCeUWlBrIPdMUhDAElBgwIOMIMwcwAqyw0blBRh0qMAKKr6GfdFDcn
         Xv7Eo66cHs5QSyMs/YrxrdWcr6JHcsC2so8P0x+sG2yodn5GlFzDpZrejwx7V2ikGsg9
         WitE1M884hSVArpS/XEaR8qQYEYaaNRZiqYlt05KbjXn/K38vvENgrqDwTo0SRMx5l1m
         q/6BLDYaAs7tf0LE0jxvHeFDv3ivZpCQwUqAsOozjybb8lutDgXW6HHtiZyYQ3FUPoWB
         CpWw==
X-Gm-Message-State: AOJu0YycTRmoDVaouFilQ7wcn5JQBDaYxzfgXxlbF2v8xSfVi8/Wheiq
	0IFpmmj8vFSmIcczr0wtTUF32xtjUvpmSPSnPY8Af7CtS3zMi8MW3y9WXFg1Fy/yj1N+7/R8RQu
	JZHqS1iVP3Tusw1kWRipqrd9ouhWu87sHvLgmZPzr8jTgwnyb8rrP
X-Gm-Gg: ASbGncv2/BNdpr3YITJ861i5AJH1C/motmYtlGjFhKYVWTxXdDOokiWkJSy5e7i1jkE
	yke04NBjXfokJTn9+q1r8Q3k/sVuh3CwuvEf8/KIciLqXP0fY55C7kmocQwMAhXA73YnhTgj0cS
	OqWQvIrOZPu5884YyDeNLerIKwPd1CkPPMigF+Vr7hrleDHfzdFIR6rwNLeYflyssirYB8aVlpm
	qrraHyCc3EacSxjdoRjBkZxl9D7yHFgFUOM3Fd/I4r1vzOOwWxf6Xzqd/CwrR7D/IxsndSwVlb2
	JLN8RHGjcsh6wpQr4K4l2XjUUY+5FYkEs2hmzxNvyIHND1NcvMwKiyYz3/sVRq4b6MjFy2zpc/W
	Evq+eWWzH
X-Received: by 2002:a05:6000:43c5:20b0:3ee:15b9:97c4 with SMTP id ffacd0b85a97d-4266e8ddf61mr1442838f8f.52.1759918469363;
        Wed, 08 Oct 2025 03:14:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEF1OH8QUpol5NaCJeKFfOHuuTVHxdXceqeY+FoGelLDM8WoPvzGVLlj3NEGVKasBPrlKen1g==
X-Received: by 2002:a05:6000:43c5:20b0:3ee:15b9:97c4 with SMTP id ffacd0b85a97d-4266e8ddf61mr1442818f8f.52.1759918468937;
        Wed, 08 Oct 2025 03:14:28 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f01a0sm29094354f8f.48.2025.10.08.03.14.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 03:14:28 -0700 (PDT)
Message-ID: <99824e33-bf25-40ef-b969-a48e3b916ad1@redhat.com>
Date: Wed, 8 Oct 2025 12:14:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/compaction: check the range to
 pageblock_pfn_to_page() is within the zone first
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, iamjoonsoo.kim@lge.com
Cc: linux-mm@kvack.org
References: <20251002033140.24462-1-richard.weiyang@gmail.com>
 <20251002033140.24462-2-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251002033140.24462-2-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5jK-oTL_76jHJqJxMIxOm6MRg3GzW8yCzfhtNZxiggU_1759918469
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F15F40012
X-Rspamd-Server: rspam03
X-Stat-Signature: k5heay4d5t4fs6p8esakszctw15xrm38
X-HE-Tag: 1759918472-662992
X-HE-Meta: U2FsdGVkX18l95vs2JpdzLFybaY/ZhWE9ygeUL0uVw6wsxU0oIV8ZnV4aFyJu1a9gUKmP4+qaw6sLCRQOHmqqx7c0G8H3IU70FZO8FiGEBrrGixEZK56W752i4vl/rzSAOVWYGWv2ApEjEE5f8Ff6tBOErYUZ96KAJ4G6QE1vgo/ry8KaoinloYLhjhkp1eIzEs3/ussUTKAC6rwawbiIEI+/2pjlIjfumdr5PTtNZgmkmecoY7BztflS+HMcPoUnXVaD+6uiHZ1Y3gjsFMN9bx0nE2/p6ttTeXYPsBDUX7MNWYONMHyNwTTgSJt33fToLIN5bE9Yaw/oYZkjTDny12SM7NV5zWXgtK67Vn3wxJIH7siXonA6EH0dYSnoHaEgcYFEIMIFtuD8PfAuKjrZhpYsbmrfsBU1Ve6wFrxi+g+0lZVcbJ53Vqu9zUy2vA3RtOD8ctDGYSPXGks9cnzdpiIRO+5+VXJ05/9mSHLFfYZsJPjk362uSOWOQPcqmRWVHuPF72vQyrZclGAzZxYOmlli6qyzIktU9StNzQ6jxWdLFzNyfbpHm/184HHdlSuCKyE1WkHVrbIow2KkH1bAZ4n+x0ToR/X93RUjbL+2qTOBHYVhbmULNlPxndUxz/iYstHw8GVbddzusUtuuUnmCRHi9nkEant+3gX3wV9LoQhJUAh5VHnaiJSm5HQWAWDTHGn5go9PEArWc9vh9r01RHtDuV2rEWNCvHlHcBkNHnfEtGnvT6Y5nqYZEWLhyZjU6LvBs3fu67NB2SIl+BHNLxqTSW9R/9afTAF+RzmA4D9nuaFLbGAwr2BHxEAku6aODxop6sG9kp6rA6Fv2bk4Jjf8+Lb8XSbJssheXYZhghC7HLkbm6zQmGBu18lmX02BNYoNDGlMGPgnIOpimMd5EW+0EsQzS84zUCCeUsnjrTIzTOv4z9Z8g5ewVYaAltpGTCvKoKiTxiFjTJr0Nz
 kVnRgbRj
 6HwdVWjGthQV/zhrUDlR4EHlG6oVKKQQiCCuXPiZe+/q72lKRNa9Wz/RN5STVdo3NzkAPynDc0BiowjPvd5jde1kWcwzrzmQd+PyD4cCORQSL9bz4h4FPcnQr8O/ch3k/tD+binbuPfowGE3qXleO1kJ4JmfLpnLfwnzj8fqdcSgfM6NpB1olawZ0bkjpSO/b8Wr4BWphZPz5w6lR30JQhdpMfYy/aAeqb6lLzG9JejuxWcsh+uQpZ6cjAwrr+QTBqxKs6NGbZ5m8aWX091bRDqpUVm2xt/O8rRBYtm+iO9ODGeFG+O0rMjGF1aqIfPZLnZTZfTuueVk+FFxZSyPFYCaVAGVaX+YUPV4qqZ9Z7SBrPysVb3yinLljN9a4ZMeLP91D4D+g4P1t9Ws2JQs/o51h0ELu1zAOoBK+BwBSKt7f6gGqgVykwQNnQOG91us1Riu241P2klDF8rxvJrr7eJQ9RIoM8knH9uzrAE8OKrATb6IddV9CB0EfHHks213LbaIqSiYQwXIazvSfpwARTwQ1WpQU72RLOJ1Ju6ck+E8X2iQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.10.25 05:31, Wei Yang wrote:
> Function pageblock_pfn_to_page() is introduced by commit 7d49d8868336
> ("mm, compaction: reduce zone checking frequency in the migration scanner"),
> where there is no requirement on start_pfn/end_pfn except they are in
> the same pageblock.
> 
> So at that time, pageblock_pfn_to_page() would be passed with pfn
> without compared with zone boundary.
> 
> But after commit 7cf91a98e607 ("mm/compaction: speed up
> pageblock_pfn_to_page() when zone is contiguous"), pageblock_pfn_to_page()
> would think the range is valid and in the same zone if zone->contiguous,
> even the range doesn't belong to this zone.
> 
> For example, in fast_isolate_freepages(), min_pfn is assigned to
> pageblock_start_pfn() and passed to pageblock_pfn_to_page() without
> checking with zone_start_pfn. And mostly, the end_pfn is not checked
> with zone_end_pfn() before using.
> 
> To make this function robust, check the range is within the zone first.
> 
> Fixes: 7cf91a98e607 ("mm/compaction: speed up pageblock_pfn_to_page() when zone is contiguous")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---
>   mm/internal.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 38607b2821d9..8e1a3819c9f1 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -724,6 +724,9 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
>   static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
>   				unsigned long end_pfn, struct zone *zone)
>   {
> +	if (start_pfn < zone->zone_start_pfn || end_pfn > zone_end_pfn(zone))
> +		return NULL;
> +
>   	if (zone->contiguous)
>   		return pfn_to_page(start_pfn);
>   

fast_isolate_around() adjusts the range to the zone boundaries before 
calling fast_isolate_around().

isolate_migratepages_range(), isolate_freepages_range(), 
isolate_freepages() and isolate_migratepages similarly all seem to take 
the zone range into account as well.

Only fast_isolate_freepages is a bit more tricky. It definitely takes 
the end into account. The start comes from cc->free_pfn but IIRC it's 
always above the zone_start_pfn.

So I wonder -- if we want to add such a check --  whether it should 
instead be a VM_WARN_ON_ONCE()?

-- 
Cheers

David / dhildenb


