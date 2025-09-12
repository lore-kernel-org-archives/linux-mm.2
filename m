Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA2BDCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E9356B0006; Fri, 12 Sep 2025 11:51:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19AC46B000D; Fri, 12 Sep 2025 11:51:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0618D6B0011; Fri, 12 Sep 2025 11:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E52AA6B0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:51:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 913D9C08E1
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:51:45 +0000 (UTC)
X-FDA: 83881038570.06.1F6DCC1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 06B8B40008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:51:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UcMw5SUv;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757692303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=evSM+hUM6XOAVnv4pWD+Pp87EHuxINXdM8cowVunr7o=;
	b=gF+XAdsbJGcM2AhRqYsdW8MgPOYYJIJ61yslS+bBZJDu5j9RR6LyVfAGEcn0WIMOrtRxtm
	XO5Qqgef8aZfCeJI40rhtlcA4oq0Uxv6R5ZPmLM9moxpShYYncTzbKhABo+zlL/zz5F4BE
	VXhazVVZvJ08Dwme94gyoLOpYHwTNO4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UcMw5SUv;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757692303; a=rsa-sha256;
	cv=none;
	b=MIhkyNGFF7NB/JaiSWvTppZivP8wQP1Bjbq4ACp3lf/HdbfLOy/CC6a9ADns/f6HMzslrc
	KaUniuUtsdW2WfwcGiuz5Q4NnQr0IzjbN5Awv8lLRhAQ26vglu9PKG5DtM7JTVdQwg9sN8
	Bx9K3O0dpAUzJixR5kuIhhL4Tr1w0SU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757692302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=evSM+hUM6XOAVnv4pWD+Pp87EHuxINXdM8cowVunr7o=;
	b=UcMw5SUvI9wT0spNvE4O6YS4ihll63pjbUUdShE9Jrq3HQp13uH1vkpHWQ0IyudWEglS4n
	y5gSaK+I82LAVOtgSsB8ZP/clAZvuxkFrlJoNMyGGhvgsG2ngQzLExHBcAFm6tRBKvEGQe
	uVR5BQ9v1zDNoo+MYxgwOXIGZw7NBWk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-sewSWSgfPxar5dkYag5r0Q-1; Fri, 12 Sep 2025 11:51:41 -0400
X-MC-Unique: sewSWSgfPxar5dkYag5r0Q-1
X-Mimecast-MFC-AGG-ID: sewSWSgfPxar5dkYag5r0Q_1757692300
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45e037fd142so16247795e9.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:51:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757692300; x=1758297100;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=evSM+hUM6XOAVnv4pWD+Pp87EHuxINXdM8cowVunr7o=;
        b=IjjorOZ9P/TtLfCD5t0X9AOlQ6fPYUebD0tj5zMkWoH0HfSIOb9BzZPz9S92NbXQAI
         9QpAUihvzavkvMjXrX/tF0Xih6FCWFikiBpJ9/VMon8gmx0IEnLaUzylxT18TXbkMnt1
         3i6Cw3IP+1N+wBA932fn0DLWewENSn6s67kEONU9iiS4ng4jftFVs3TVqjua3GkPQfeM
         E2IrOj6tQ8ZZWgur32/hqih6jU7knOvPoDkvju3DmAO0WD6NuKwKFT7Fk0f8wrC6vdOw
         p+jmSSKuZaneSoPHpwhBH5TIosYAm8zCfLtWWgxYh6LC8TG6b/OFjKDZdWL2VZazhPsL
         PVJA==
X-Forwarded-Encrypted: i=1; AJvYcCXZatp4gQjmhuQH6IjCIRQiwMf5qYkqDqA6NGD7eTdQWezCwz2T8il9oFjutxODsFdkfiFcftk9cA==@kvack.org
X-Gm-Message-State: AOJu0YyLOV0q2nsL8Q1dnbVwZQNbdAayo5fDKo1opeYk0rta/U7Z1tFB
	unubkodzKgQnNjSfDe4is07uGIMNZZJJ4QTRgAbaJl5AEAoW6ozv2ag+xDUK2D70vOZYx+NiCaq
	7GzDonzA84BWzZE975VTHM1deg1y6gf3gR5Mf/OjjgR2IHNC79ZG+
X-Gm-Gg: ASbGncuLSeN6gsN3rQT1g9ozFLWeZB98UgHrauRsPimr0ZdxZUa1xeOrZNjmwUZJ42m
	Z6xtwEV2hdGctZQgCtel+ID2mod0vgeLS6/0YDwGS+qEDyggNkkMRNZdJgR9r9Fa4ko8rEmYMKZ
	ZZBn9UIaalIMds7U05CcdSPNLdQuKdgIxuTbbZj1TSu9PypQXPZq7CL8Kq4EbCq1ag4QBep/HJ+
	tYQw6F1Tqv+iYk2+ElFzHDDYnH92cyjrgxi9AD2CcY8B91VQ17MpYPxAZhddm/OtTwMChmlEkyi
	FjoXlVvExHuNd7Pbj4NMyATXLIg9d6udjqm+suUj76/ZfaqAh3VMlRYVF7jfdr7Nn8sh8ZrKDht
	XxWkJ5mpFdGghfx8CJwQDyYVuaYrpYsD1EjFYBTf1F5Gb3u/UTtm/0wxJHE0JhSwfbYQ=
X-Received: by 2002:a05:600c:2251:b0:45d:f7e4:88b4 with SMTP id 5b1f17b1804b1-45f211fee13mr31607425e9.30.1757692299857;
        Fri, 12 Sep 2025 08:51:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFTJ5GavPsbuXit70YFZCDKrkElDxaBYazDmnr1RZ35Woeh3Th8WiB7RfPyeeDQGWEoFz+o1w==
X-Received: by 2002:a05:600c:2251:b0:45d:f7e4:88b4 with SMTP id 5b1f17b1804b1-45f211fee13mr31606965e9.30.1757692299300;
        Fri, 12 Sep 2025 08:51:39 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7ff9f77c4sm647828f8f.27.2025.09.12.08.51.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 08:51:38 -0700 (PDT)
Message-ID: <6c8a85b6-232e-4341-8df1-501b9d73e14e@redhat.com>
Date: Fri, 12 Sep 2025 17:51:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: Kiryl Shutsemau <kas@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nico Pache <npache@redhat.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org,
 hughd@google.com, richard.weiyang@gmail.com, lance.yang@linux.dev,
 vbabka@suse.cz, rppt@kernel.org, jannh@google.com
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com>
 <20250912133701.GA802874@cmpxchg.org>
 <da251159-b39f-467b-a4e3-676aa761c0e8@redhat.com>
 <hcpxpo3xpqcppxlxhmyxkqkqnu4syohhkt5oeyh7qse7kvuwiw@qbhiubf2ubtm>
 <k54teuep6r63gbgivpka32tk47zvzmy5thik2mekl5xpycvead@fth2lv4kuicg>
 <y6ljs2byyzxkxqqxaf37kx5lqpshv47ndejksen2ihrvhcwksc@4r6f4sdtjd3g>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <y6ljs2byyzxkxqqxaf37kx5lqpshv47ndejksen2ihrvhcwksc@4r6f4sdtjd3g>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qBexbReJY4c1rfAlKRW34jbIFD8_g7oQ6HxW94LbP9U_1757692300
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 06B8B40008
X-Rspamd-Server: rspam05
X-Stat-Signature: kyue46f37b8h1hoon6ixzxk3jpgkzhat
X-Rspam-User: 
X-HE-Tag: 1757692302-158867
X-HE-Meta: U2FsdGVkX1/zbH+d7uq2FJONgVetAuRc9Cz957dz9eRckNkhjXD9cU/mX4WWUUcosOWXJInAN/nbH4Pnrhr+Ub+cqwpa+wuWscSX6+o4ZueX0g4vt4XOdKv7GROdF6QLgUP8M4IAVI7nOXLT+5WLDTqTXdb9HlAsNJ3wYLu/3a3CQzqDVOLPmymW7G2OBBpYGl4dSzkdPWaC0JxMsqWfjMlIF1iJ3BI8g+QTNypICfcx8jk9NarsmVEnwNAfu0sYeWPuueZwogGcA74tsiQdhIuUbSpJPUiCj0UXUkJQrxVmALkNWXjgIvO4zNUiZ5CPOjSDZA7DVN0YMB1SBlAvcgit19gQdLpZX0119aZxVgIPAjDsLY7Icqa4rN5YoKlTFGweoG4/Csjo8fiWnr6qErEIvEPpFUyHmVFY6jrIIZUeaVEU//cSFSSvXbS/5QndWEHQfgGSLkx6//J0qAjuYbm6e5lExXZjjWYoXBHa1oYZECVuTtxOxYD7BHbwefJUDPV1yp0I4+5NAk+uqjwLB/USdGkBDCMFAli/AdgZ6ngDbHPsXvGMvkhR+vAyQq8hJQ6ARfoWbphqp0obPLo2X3P92g0wIKKN2pPcFlneZtlW6Tgna9ub4+pkLehVv1vRiX0XzXode961ikTmSch5OURuoUKb6ad9ue7Z2b7znLI2bsnjm9dgRCqURmoBQj0sTqi9ki3SVBXxU1uGhczMSxvc8B7nLfV+BI79hNh3L8WnfTJx+x93y3SneANw/X6qCKUV6MMU0R5t8LskCI1dmW++732QVSeiCE5IZw/kh6osBcwSZwyrijCMT+pE87eFiDPdeVdoG7dKCK/CXCHEOafL7h7j5IdZKaQ3tnPiZnxvBI2cr7t46iNGNdSQ0FGclrppvVXgBJ9Tvrm98c7FfuehFi+qaJxk2MunQgUfz+2SFAn0Yjs1+yQ/Hg0S7IlVw47zMW4hlMVLsK3Hzzc
 9+CKmNDy
 zO+/M1gejbQMw5cr0Urh2akmeKJnLCU3s/Ntgce1QtIWwz7HOI8HdAZv1Kx/loFW+xTaSgS21TpwoBaw6dPyhGMiuKIh0XB4beAe6nrsaAaDu1QnsgCLSFSEZkD1a9RGRBjwnQwTW99cOhUxbI49jl85BA7MTiL+JJMR3V6o4XxrGvYtx9/wQ1DoyvFkT6uNdDVwQpWrHzNZ/oavJu/SKZ7RNjAi1pJ3i/WZ5XmINeylEqHDTd+pKKTIruQr2FWayfZOPpxa+VLW35xDN6rGoJqCXwb+EFfsZgPXy9jHrhvEWGko77WMSZkRc++mDJC0h4PiulAGQV/3RGqDvayWvPPGYLpbmSy1Ez1Jq2dp9E9BHa6Jo9AbQzyVhzFVMyicVigG/UHpPzi91I9J7WuQ1/dXmRib9viE5ZkERJjnXuQgZ0Om8akJFTfVyno91F2ZR6XWVWole2dXvoKRw4yB90zdUjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 17:44, Kiryl Shutsemau wrote:
> On Fri, Sep 12, 2025 at 04:39:02PM +0100, Kiryl Shutsemau wrote:
>>> Shower thought: it might be in these cases especially where the FreeBSD
>>> reservation system comes in handy - best effort allocating a THP, but not
>>> actually mapping it as such until you really _know_ it is hot - and until
>>> then, memory reclaim can just break your THP down if it really needs to.
>>
>> This is just silly. All downsides without benefit until maybe later. And
>> for short-lived processes the "later" never comes.
> 
> The right way out is to get better info on access pattern from hardware.
> For instance, if we move access bit out of page table entry and make it
> independent of the actually mapping size that would give us much better
> view on what actually is going on.

We discussed this a couple of times in the past, the problem is that it 
does not help anybody really if all but a handful piece of hardware 
provides such a features.

Long long long term I agree, short term we cannot really build core 
infrastructure around any of that.

-- 
Cheers

David / dhildenb


