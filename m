Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7838FCAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 09:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D63E68E000C; Thu, 25 Sep 2025 05:36:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3BE38E0001; Thu, 25 Sep 2025 05:36:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C51458E000C; Thu, 25 Sep 2025 05:36:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B31458E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:36:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F134C03DF
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:36:05 +0000 (UTC)
X-FDA: 83927266290.03.4EDC87E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 420D0140004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:36:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DsFMyDV7;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758792963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lz5XqgLieGa5kPYuyBSPmLcQDdwjnERNeY6u4Iov4Uc=;
	b=ckKQgzlqIIHKQ6ZkVYXZfFLhZCysgM4hDXktmbiQFl+/qr7RxTR/uJT3OBFtE1KxRjycmr
	eIf2WCVdztyhaBzWZWWOOmBrZF8UnLrMe4y6yuwKy6xRlK9DR2Js4bxjslRcqJT/hYa+AI
	Cm3tQdJUkjnnKEqDvxuqoIsfo9OsXpg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758792963; a=rsa-sha256;
	cv=none;
	b=G2L5r/SaMiaQRqIwevszw9xfxnwzNviaLImwELsGxp43LPSCUAgasbu2H2g2vHk9LtQDUy
	ZQWhamDa9UC9N3d6c+Bnix9pe1BzNJJVyAzG/x0FjoJ6Q64v+pazyKAAU3DbhvzKCwVVak
	/Q1gTmavV4HZppoQDxDhEwMkFL6PMqY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DsFMyDV7;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758792962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Lz5XqgLieGa5kPYuyBSPmLcQDdwjnERNeY6u4Iov4Uc=;
	b=DsFMyDV75yq7M2BiYQlUzaUEAMHcQkjcKklR9siatTTgVipEKM4sq5SUESfTdUafLGBnzN
	TmN5IUhVzW9YKnUsam0TQhcQkZzDKRxSORzL4YiqntyBdtC9CXaLjJgD3oL0V/Tw80s0/y
	qDIVpgVmNlWfm9TNyLztK+cU68Tw+l4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-oNB-JuifMHq4DHmgudlqRQ-1; Thu, 25 Sep 2025 05:22:30 -0400
X-MC-Unique: oNB-JuifMHq4DHmgudlqRQ-1
X-Mimecast-MFC-AGG-ID: oNB-JuifMHq4DHmgudlqRQ_1758792149
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45f2a1660fcso6279915e9.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:22:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758792149; x=1759396949;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lz5XqgLieGa5kPYuyBSPmLcQDdwjnERNeY6u4Iov4Uc=;
        b=e7FX7xrXBM/Ea3Xjaw7U+ZaYn0v6P4QQGlX47JZaVN6QunLtIFv0gpXl7w+ajxzw7h
         aI0nJ1fxik9xGb1e9hTFvqR3PcinoqjlwyjDnaeLPIchsyBTnbSs3TdBX4/D5c9PH8PZ
         Ytuk0yf+1WpOT7lUR4PajgB8QJyDUPjO2+44iHeEBDT7jEBEyFuugMrs8Bf834mkQkj/
         KrUGUCPvXpo9luG1LWtx/pxNTCnPMen/BzILLVGzFwu2VXVfCeJkZpoMQ+q2Yy/i9yVj
         v8DIrEBFPx7QeoJ1StG1TupAicKF8sINCqhC8o8WgiHv1VED+FipVGwiA2QHShpB4omp
         Mkyw==
X-Forwarded-Encrypted: i=1; AJvYcCWJZx75Bq4RlZzIAJocHFUbXPOlU+AzAE8LH0P/054YBVdv8PIl/v0vxKkv5WhZWNpE8WGODHVWPA==@kvack.org
X-Gm-Message-State: AOJu0YzXvylF2ou2IIAfQwzXabswHYM2o8p10EqxA1kYCCBXyIdPr5+S
	3F7silCM6KlYdXw+FbqB6+1dN7KCMb2kTNXeBfzKM/TjjdsIV4kV7F9Q3brZdugXR7Qvy4e8ibY
	OubyWf+MBXxipVY0kZn6GYu5S0HBX0Sv4Z2TYTgYcu8MR36OasxYR
X-Gm-Gg: ASbGnctz9Dvdg7npGmPitb/j3YEaPsrPAakG/ii8RnBTIxkrLqRC13+cIW1Kdgf/5L7
	4uJ59WpUNp5k9sVOOZk4UKUpwmCnedPbSxTwFPORJSi8NE1Xc27lyL9tf2mXG8Z6EPHkgo6MFSY
	5zbXpaY1VHbC4+Q9GZ5n6ixLYYhje9oRLvyHuz+EccVXaaeBqz2QStH2P9OXjHFcLYHJZOV7qH1
	1qsDnWQy2wsJSk6THMgCLO7u2pM2EL/c5glcqdpu3ILLD/FmkGtqcrB8WGUa8rGg6XKd5xsTe5D
	bBxAMq1Ztu+Vlm5TdJBJ5Ls5HC0W+uhcA+KaTOS6n4RVOxngw2vqGxnjXzyUwB/h5xurupo0n4b
	kCHF5rAuxy9dqmHy4tuFXwpfDWNjM4w7b6RqbekrYuiz1OwhpX9pSeXoGOdCRGOaGXsOI
X-Received: by 2002:a05:600c:630e:b0:45d:e110:e673 with SMTP id 5b1f17b1804b1-46e32cc3d4emr21881565e9.4.1758792148806;
        Thu, 25 Sep 2025 02:22:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtcWngfqBV8I5lWmVC3WvHXNC5OJ5evoFvRFB/sf8EeGvnzyztU5ApVDdsoIWkbS0A2yZDSA==
X-Received: by 2002:a05:600c:630e:b0:45d:e110:e673 with SMTP id 5b1f17b1804b1-46e32cc3d4emr21881265e9.4.1758792148313;
        Thu, 25 Sep 2025 02:22:28 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab31f1dsm68495705e9.13.2025.09.25.02.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 02:22:27 -0700 (PDT)
Message-ID: <d2f51ba5-1f3e-4a72-89ab-23a11059d971@redhat.com>
Date: Thu, 25 Sep 2025 11:22:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: fix alignment for
 alloc_contig_pages_noprof()
To: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>, Anshuman Khandual <anshuman.khandual@arm.com>,
 Dev Jain <dev.jain@arm.com>, Wei Yang <richard.weiyang@gmail.com>,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>
References: <20250923001943.2479-1-richard.weiyang@gmail.com>
 <3BF1389C-4B8E-4F50-AB0B-F0D96833D387@nvidia.com>
 <5491dfda-862a-4c31-b64f-5339007a5302@arm.com>
 <09284390-5a1a-47e0-9929-0a5ba98c836e@redhat.com>
 <760C8EBD-9201-4680-8B9B-CAD7641A81C4@nvidia.com>
 <aNPW4Ynrxyn23Ko8@tiehlicka>
 <81a827ce-24f7-4038-bca7-c96dc558cb38@redhat.com>
 <aNPdkABVUvJESoqm@tiehlicka>
 <d21d6cf4-404c-4a28-aab3-03974eaf806f@redhat.com>
 <aNT5y8k3ZDHbQzyN@tiehlicka>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNT5y8k3ZDHbQzyN@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Eg__mXFXBH6CEqSFkgIm2OQ41xtRpumXzuQLwJKSDPI_1758792149
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 420D0140004
X-Stat-Signature: wtzbuexbknor7ybh5aeqhqpcz39ok39f
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758792963-562013
X-HE-Meta: U2FsdGVkX18d/52OaoXGBKFhS3EeZkRYE4va2ZkeT0sdqYAZ4WFyxMhEDkqS4XTU6gfmJ6hOpo6/864pr1qemLyzcMcQbtxUvWEZ5spN+VPXuSYsPS+/Y05IEg/7Er2yOUsOPilQlLd6w5dsXddH53V9XI9aslYtDQaboeP0eK78QZwEKwPkusbLphTxgWKFtBBszUZlbTIcPhwpnDHpYfj2xC/KdsIeCTN1xAwYuDQpWlVKf8bPo/ZLMCr6QbJxMqRKE870VhhKANJZwOT/yzCLwGVhOximnZe+Dz27GwziVWIZ07CSi98W+hTVu8rXL/WG2mAzUlGBEAaRSZxjkZhdGqUJ8BmxNl1lFLWsp01oDNjaYxf8XFSHoTaVibFjIt4LYc5QJDroo6W/aBb1lWsIBB8rr7IF7zUSqkB869Gyf6bVY+IO5gW5q7j7vzX52Mk3Ely4IFQH5K+0yc4QAWtlS9uH6wKN0DtNC6WU1IJUs30pbFD++hWFS/kNM5I2om7qEU+cfg+HK6RzXFI4bojBjcMYMejUgoupf7Kv8G2Up3XDHYg+wV6BewpbYzgtCqmdr6IEtzttm4BwWNLshmNDwFl/6QNKbSLE2gMJJR0t9aBiw+sONHZosF+iurY8FENSP/wnCvGbwAinBzhAt7KFNKj3R1u8Vyj/ELGLZGO4dkYGxgXLDm4xng7dOBh9UvK3rqZBqfvdZxFuvs+11rIa6fA8aPOk/T7Ee+c9Fa3WtisJlzsUjsgKFmJ5v6AkUrtVNTjjRL4/WX6gXRND04G0f/0R2AnTN+ISqIjNSrOuc9b6W19SNpFHYbeoptQzSeUUI2P6U+u67b3l7/RdmcPVof6ggWyQLFi2dXYu3rmUFbgrr3RPC6wyK4AVO8TFDBVvE/2daYiFXbzNxaYPV0x4zh0uJ7lmVrV3We1r/lIpbvlxRfvhpOqtB/9GDAUmt/jzcQH59+k5eP3kYpI
 Px0KRdJy
 t/gWaOn4oS29xI5B47IJoZED63AtthKyPeA/sqVfmVQgn+Fm+ERI0hCZEDzN7eDVAkt8iJCPgS+r3gAnC0Ea7wwDay88R0kJGTctcq589ciXzQv6MZkw251TS+5EoaD5HLhUxCvColZ3JGWIibXO0iRZ0faN24AZDjJFY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 10:14, Michal Hocko wrote:
> On Wed 24-09-25 14:19:37, David Hildenbrand wrote:
>> On 24.09.25 14:01, Michal Hocko wrote:
> [...]
>>> I thought we have concluded that there is no user expecting a specific
>>> alignment. Or have I misunderstood that?
>>
>> We concluded that for users that don't pass in non-power-2 requests.
> 
> Ok, my misreading of the discussion then.
> 
>> hugetlb->folio_alloc_gigantic()->alloc_contig_pages_noprof() certainly
>> expects a suitable alignment :)
> 
> True that.
> 
> So effectivelly there is nothing to be done here right. Those that
> provide power-two requests will get what they have been getting and
> those non-existent others

I think kfence might be doing a non-power-of-two allocation. TDX maybe 
as well.

But neither seems to depend on some alignment, so all good.

> will get whatever as we do not provide any
> guarantee in that case. Maybe something we could add as a comment.

We currently have

"The allocated memory is always aligned to a page boundary. If nr_pages 
is a power of two, then allocated range is also guaranteed to be aligned 
to same nr_pages (e.g. 1GB request would be aligned to 1GB)."

What would be your suggestion?

-- 
Cheers

David / dhildenb


