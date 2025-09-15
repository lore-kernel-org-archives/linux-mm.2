Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7006FCAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0B68E000B; Mon, 15 Sep 2025 06:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C61388E0001; Mon, 15 Sep 2025 06:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4F768E000B; Mon, 15 Sep 2025 06:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A032B8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:26:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4719A1A056B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:26:07 +0000 (UTC)
X-FDA: 83891104374.06.5F09A74
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id DE9251A000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:26:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FN6rJGQ+;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757931965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LuOSdM7sr2GcJV/vZB5X+Ju1uYPsXPA3FO1S8oXCojA=;
	b=BLgqsLFAvtuicQEx9jqjUo+c8u5UrU3aP+PyKbe0IpxwM53kqRPGuSdiDlXb/PIvzYfHnP
	u7xJyRtLrZheZjBrdIof8AVOtFpSnGqr/GzF8anYBKULYwgLI3VH9y/H0OeWK0+idmqSjJ
	EAq49oKSLZNMiUWfK9j3co3vkACjGhU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757931965; a=rsa-sha256;
	cv=none;
	b=hysbN5jwlAPnIlwR5r4trAzMja6m8B4LPtoDtH2LPMu2U3OcdAMbaf/hL3J9B3eYXmECUS
	olpzuPrwVeMDDcBls79ZWOrhjAnvQ42cUXDPl0KcwDaMQNB/gW1jbSFI2RRRGGFm3j2lKz
	TnOVLvLkeRABU4TdM82z8g31/8odvXI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FN6rJGQ+;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757931964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LuOSdM7sr2GcJV/vZB5X+Ju1uYPsXPA3FO1S8oXCojA=;
	b=FN6rJGQ++0xyxk8NhGImzebP5PPZV+hZLON8yaw/oHHdwMV7mdlg4xeB8rtHERgi+qSALx
	M20pF77RyV22NeRMfieErTUP5oENCO4QHziO1AQaxOvyUmX5D44NWG5glOnbhAr2JNIm/X
	z9Nphc3Dvd/KfncGJi/XVpMCgoyHUW8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-CTGkaDDENQyrZ0cWhYi8zg-1; Mon, 15 Sep 2025 06:26:02 -0400
X-MC-Unique: CTGkaDDENQyrZ0cWhYi8zg-1
X-Mimecast-MFC-AGG-ID: CTGkaDDENQyrZ0cWhYi8zg_1757931962
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45cb604427fso23948595e9.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:26:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757931962; x=1758536762;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LuOSdM7sr2GcJV/vZB5X+Ju1uYPsXPA3FO1S8oXCojA=;
        b=RAN8F2Z9NhoEgLd11GGU22mzrQzFmt7TLZNAWSndgj/kAS7rCrg1YPGPMHzSNnxHug
         1utw9bVaYJHfohFuYDxmgs4NMCQAMJqkSS4sAe1s1HxGcr9azJA3Bi2F4wRa8J+LpBU6
         3nY//xes4ZBE0kLOV1Dr65CgLPrO7nH5TKknkDP2O7dqRdZsx8aywIY2iNLQH0ZPdIhF
         gIdvgfop2Z7MuXdKydZMY0IoSCGw/AhaO8oo5rdej2wqaMN2tTxR1nDMxDSLf8F9Vrhf
         PXlMg2Ht8LWFr493+wNe5D15G8yuNNOlzeN0uj7zvTfYB6C+dHK21m1svlMl4mHMx3y7
         44HA==
X-Forwarded-Encrypted: i=1; AJvYcCXW55xgqq6ZLSTdNBgkAXwA7xwTYoFU0BGnPOUN6Dd0FTEq2boGBwH6CZ+2g1JET9GJTlBuafuTAQ==@kvack.org
X-Gm-Message-State: AOJu0YwIzBuqqKMzPtTBqSMt6c746o62CHKGA0HniU7EOYp71Q+vqukJ
	vy3wAxgC1XOzcnI5h4evl4qdqwOWEv9JzFKAY4y3ODZ/zK5ccHie/cA7FNp3w98c7OIcgUcIrRg
	ZYVMo3l1UZ9ts/Y4/4PcTjxWmg4gb9AOtPnHQBGLosN62i//CEKMA
X-Gm-Gg: ASbGncu2SleqM/L7Tsgft5UWqj7j20Lcxgowf8L1XCGYdquruy2P0TaCfnUWfJ/NMIh
	DWHotLRFV+RKSD7geOq9IWHrap2cued7nTdq78jHKM5s4189CSZ5+yjjg+CCUexK/NNBPWGO0Ez
	w69JDDzpjli8avd8JPOXaWfHqLekBoVoFGoWvD3zyxSgbwh0c7qkhpJL4WjXgsc90MqO7SltivA
	WhoxBcYGv0Xa52UDivsF2r5uslCBwjjL4uo2VIBo+fxWSfYyRsYnYP+WCytpdGpR9tGtIfoJUG1
	hGjRnwkydm9TW5x1IupYNHlw3Mc1MeQ+ihA7Y0hIFvnG+8A52YLCCN5KhF8C5BN+OjzZHszhc8g
	kZqUZ9n0PJ+pMFuxmpmXezMAzm9FheBAaGwICy+EtJFa6sQGOEZw/8azWDo2V/EEJ0RU=
X-Received: by 2002:a05:6000:26c5:b0:3e7:6197:9947 with SMTP id ffacd0b85a97d-3e765a2675fmr9795887f8f.53.1757931961431;
        Mon, 15 Sep 2025 03:26:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEITkGGGz76cys5swmSEelvVvlXnf7rFrqKHK6hXOsBMYdCsiJrRwiLPBM7GrXfuGS8fKwr2Q==
X-Received: by 2002:a05:6000:26c5:b0:3e7:6197:9947 with SMTP id ffacd0b85a97d-3e765a2675fmr9795840f8f.53.1757931960953;
        Mon, 15 Sep 2025 03:26:00 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd? (p200300d82f18f900e0ae65d58bf88cfd.dip0.t-ipconnect.de. [2003:d8:2f18:f900:e0ae:65d5:8bf8:8cfd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037c4490sm172678095e9.19.2025.09.15.03.25.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 03:25:59 -0700 (PDT)
Message-ID: <78d75263-e0ab-4dcd-ae97-5c5c9bb10193@redhat.com>
Date: Mon, 15 Sep 2025 12:25:54 +0200
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
 <43f42d9d-f814-4b54-91a6-3073f7c7cedf@redhat.com>
 <ab8c2e03-53fb-402c-a674-c2c6ab11f54e@redhat.com>
 <rapl4xr55zv2nq3jh5ulk4wvfyxa2kmbnnb4uram6q43y4cbwn@dv5m52ocyqne>
 <80c50bf4-27b1-483c-9977-2519369c2630@redhat.com>
 <7ri4u7uxsv6elyohqiq2w5oxv4yhk2tyniwglfxtiueiyofb3n@l4exlmlf5ty4>
 <59641180-a0d9-400c-aaeb-0c9e93954bf5@redhat.com>
 <c5bcecb8-13e7-4db5-849e-2120c69b2af5@lucifer.local>
 <ed784d6c-6c2a-4e0b-ad2f-e953bf310ce8@redhat.com>
 <dcfc7e27-d3c8-4fd0-8b7b-ce8f5051d597@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <dcfc7e27-d3c8-4fd0-8b7b-ce8f5051d597@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tTHhrA2xy1SVBV32XXRy0sgWbKcA-6ZHPjIaJvbuGCI_1757931962
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE9251A000C
X-Stat-Signature: uiaw6ooprnkoby7bbur3u1e9p8nfou6i
X-Rspam-User: 
X-HE-Tag: 1757931964-760197
X-HE-Meta: U2FsdGVkX1/Ujlcn89mgLtpwSY4TbIbTIW/2bF+ECrfQqMx6S6Da2LttLipfUhDb/9fYR1tTPoyT7EKrfGCk5pz1Oxn1toFBrbkCZH5rUA4S4wgM+K12L09ZC3lnMqrlvYacBke/9/+Ozy+05QyeDlbMtacDLUB2RIDwoulMq+jDi+mBC+1C6+ng0SE/PKWOPn2+/XJkDimNelMEgiBqiDQDqLOmbPYwPcFlFLH7faTJrt06EcCt1CxGbdyAjUFLbhFOIqNM2OvmoniUfnwYr4SZ2f8VW2wbpPKoTGS74y9XQhQEpJWkebC1ltldDKfaxhgAevhx49EGV4PbPB/slcJTQsCkcVp+THiqTCgsve5o9Nr5t9syVQw7lV581kwkQXyjJu09PKk0XdoIN00hhb+BCkT8ZiDuYiNUyfF4zqWjphN5aUyzVvvaKL6fAhbWBVTtaCgvAbdvGX7EcDd0f5VLNxuQA49F6hMZgtyWAIMMk/R299jat6KLVupvkIa6IjI6PKyZ+36tuv/X0ckTKTy3SyeHh7fB1/iBCaMwOGNkw9YIyOtjCWB0JEe5jXYPuedQ672K6hfjfsfqw7RCI1qfEa58YJJygC9d90izQ7Fa3MyDmFLCJstjYjEF6pn7chBbTb/JFSqi0nkD+XCZKDAKD5TJbcaG4Jt1N2I+9B9/OU6Ql8bt0HqH9QVHmHo/5EJU80HYBOwx7vHin80DFYm33D/Bp9QFYik7LJztvqWEfzV7jyMqGL/J6KsAOqAjben8KPHXhzRIRNEwkANOm6HkkW+p4Ey53oXEEGeOKEPv2nLSCax2fPNB/Y1VhUU7dqNYS7LXVbIryvg/P+djeOcQpm5LdFen3SV9/Ba9vzZwGDvSDsJkGElXluIKcxJU83KeKt9TOfnImCNuqzM1i0AMiQtd7BJCIK3BybhTzcdtYDQu0E049pvoX6DRSQXND9V4k+utFSH7V4mCA3e
 MT2Y5JAa
 GfrCNiv8eE5jtU7bsDqE7h9DkzizlRoWIhDwIPO9zjq73lfLDKWIJUzlr1eYVZnNkMTuYd/dQNDgsDTrwhUvO+VAA+J+Uc+0rKHNuJsr0lDknMZx/VwJYWTVMurtOXUir6NU/d3TDVLZiUyJU5ktmYLBUm2HiA01wS/5TDqxXHunWaVINlXr0hPKfwTjLhKFnGZ7L08tGC96tVI0cxE/i9g2DOy7N0Buq9JfEf130VgUAWF7v6ydU/PHvwdMSH6CTSmtm9tNuGJoT1/DEshrAAjI902BrGt0ANjU0mkXO+c2jh1+O4koBNsDbfRR5hX6sS3xebpKBhqBUu6nO0vpEyO0wsmKXr0oCuZkrCSx3iKuUu3fVNf2JJu7gSCjBoNMJdBq63eNmE/8O4WNOYZMTjx+uC94DbA9c2KQyJUzRTddY52rNOtmWJq6BPGWe8x60v+ZOuljISs9I7jxeS+ojljgALuqYNSJLCAfJybxJ81rWBlEHc00NEVmiaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>> I would just say "The kernel might decide to use a more conservative approach
>> when collapsing smaller THPs" etc.
>>
>>
>> Thoughts?
> 
> Well I've sort of reviewed oppositely there :) well at least that it needs to be
> a hell of a lot clearer (I find that comment really compressed and I just don't
> really understand it).

Right. I think these are just details we should hide from the user. And 
in particular, not over-document it so we can more easily change 
semantics later.

> 
> I guess I didn't think about people reading that and relying on it, so maybe we
> could alternatively make that succinct.
> 
> But I think it'd be better to say something like "mTHP collapse cannot currently
> correctly function with half or more of the PTE entries empty, so we cap at just
> below this level" in this case.

IMHO we should just say that the value might be reduced for internal 
purposes and that this behavior might change in the future would likely 
be good enough.

-- 
Cheers

David / dhildenb


