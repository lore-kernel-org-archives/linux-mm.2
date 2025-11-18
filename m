Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E6F5CED624
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 11:55:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97B406B00A5; Tue, 18 Nov 2025 06:55:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B7A6B00A6; Tue, 18 Nov 2025 06:55:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CC9C6B00B0; Tue, 18 Nov 2025 06:55:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 637286B00A5
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:55:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 083BC13B272
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:55:20 +0000 (UTC)
X-FDA: 84123572400.23.EF19994
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	by imf26.hostedemail.com (Postfix) with ESMTP id 13BA5140004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 11:55:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E5dyZO7T;
	spf=pass (imf26.hostedemail.com: domain of arch0.zheng@gmail.com designates 209.85.214.196 as permitted sender) smtp.mailfrom=arch0.zheng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763466918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9v8UiKRyyvD16t4ENb8APUiQmIzVsGi/FebBj0lOkJ4=;
	b=m51FWvrdm7yNhn6uGhEDXOjto+d4D7N26LNgQolYO0you0f37P6cQYYDM2Smv83wli48BX
	tZA1pYoLnSECLoniO1pTnh0f2+fEx3n2BPMwS0wgn7pKGIHk5QQ9aHlLZ57KT+TpMkS2A3
	7ocuogQiGEmzfm087qG7AV9UzLkx3OM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E5dyZO7T;
	spf=pass (imf26.hostedemail.com: domain of arch0.zheng@gmail.com designates 209.85.214.196 as permitted sender) smtp.mailfrom=arch0.zheng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763466918; a=rsa-sha256;
	cv=none;
	b=CFoJRfYz3BfbTi6fsHSShflGXCqkRuiHfLg9P6t56fx+HHpYdb01JJkTG6pXAT71aHcAn7
	/tTkFdIPrc338M0JBzBj2E+6G1iJGSnyv9Gy+KCSzhIDlnYVnWIiOac7htmop/3Km3aKPB
	uOD9kjmP4zUrzvWv/85LNR5A5+jk6I0=
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-29568d93e87so48598975ad.2
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763466917; x=1764071717; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9v8UiKRyyvD16t4ENb8APUiQmIzVsGi/FebBj0lOkJ4=;
        b=E5dyZO7TCk/whhd1ZpxIgVEMEfdV0O0GHW6CTZI57QZQl3X18qmxvGx2feiNHlHjjY
         bl2r45pD0L1PNQ94MFZvw/UEf8E4E+g3vmz8TL1voqUvPuWQkxB0ZAeI6Xtslz/k/smb
         7gjnZgz/IfUbjkL1NzplfIyhpdwoORiMZvTy8WT/X5CD7bNXIskKrUHbx/OzlXKm5Rtu
         6otx6UO0dTamXRKIfoycEu8XQz4WZZGQNpmrXXzSnToZPzdB5yQVZPXTwF0BPt/AtMFz
         T9dcso8T3fwDeR3LzncqPDufzEbesQKUjshHviG2eyBkXPq8BGapUtsRTFNtONCY1VKR
         wWcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763466917; x=1764071717;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9v8UiKRyyvD16t4ENb8APUiQmIzVsGi/FebBj0lOkJ4=;
        b=g1h8qKqhwkeHmZthSS+I5BdXJ4Tou3MHL9ChgaUaIm2wf+HbNfiteWJv31+CkQv/Ek
         arYFWFAdvW30ivzafGYu+0g8X7MbovIfH4rAwr7g4po0bHMawIbmoGI3GHPFf979Utpz
         6Omw1gKdP4DXRIy1ti4ys7IuiLWBCZZ3RnebbwzyNx/YPnQJnGJ091RUT75OmT2Zjo6n
         Rei8+yi69eU9sgb63TdELLsXu18hPT35koDunOnWwOpB5MtehLXknAhZOLAPBu3k/UZ7
         ZpEUn784DCRwFQB/XMud+0xZTOGkh2LJAvJSVS1Yq8fiOav6ew8YcZp6iNUaLPbatpYr
         mBaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJekfMXBTh0p6NaJtLtiPyWYL4q0fx8CtEv44z/nT37pTDJTG5zGoGwCr/4CyrF1c+/jS1ipb0jw==@kvack.org
X-Gm-Message-State: AOJu0Yxpq+xCTkCx/6xkAoCNhQK+oQ4CO67u2GfG7X9oQPisxC0/vPEl
	txdORXvRQqhaRHr3dHsVuRlYQowkc0ky5EDvgycpc61wPe7vEsr1yL5D
X-Gm-Gg: ASbGncs3F/kl1SpF1JDxhzfd7O8aKrU6QBXCdFYcCpeYh8ABt4Jn25rWDqA5XBELcoZ
	jX/6BhFHOlc5RQiVlJBPhHxrA80z56PGCAHqV3WJ1HzeUdXTjUormcvMs7xZVjlGPUok17abhPL
	ZD2+eibdYnM0cPs3aOgGCedgh+1t9N8sVaiqCwCHrkOUSGHK6luRQBGIaBnsYRZAm5+y0AL9TKp
	2cprvbMWRiQpfjqzTxxFttvq0YfTvlheoQ6DHfW8zRj7z5o26TcB/EyswWkH/xXjHEPv6P0kX0Z
	uX7fCjiXgh0mgV6y3sthDV/OBghFNW02vVpaY6EUUXexhSogeBBG0dwEibFp+Uqg9ZMxsYmkxJe
	uiGk/5XegCZPGGjOxY636GHI/il7lkCyuMdObp/zVCWiquLkDomlaqBi+WerSa8DgalJlYWAUDt
	ZiBSh3xoLY+HPOP31vfBKE8fqEdOH0qpH8X1EAlxJ2JmmcEA==
X-Google-Smtp-Source: AGHT+IGaNSdLxRla9oY02zDdWZQ+dAcjdxohCbg81uqIYBMI/Z6QJtGDDVm6vwOhGnWyaCl6P1ztwQ==
X-Received: by 2002:a17:903:1b2f:b0:295:3f35:a312 with SMTP id d9443c01a7336-2986a6cfeefmr183341175ad.20.1763466916628;
        Tue, 18 Nov 2025 03:55:16 -0800 (PST)
Received: from [10.255.206.79] ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b0d17sm172235585ad.72.2025.11.18.03.55.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Nov 2025 03:55:16 -0800 (PST)
Message-ID: <f7f0ca8d-bca2-4a3e-8c45-85cba1b0ff18@gmail.com>
Date: Tue, 18 Nov 2025 19:53:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] enable PT_RECLAIM on all 64-bit architectures
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, will@kernel.org, aneesh.kumar@kernel.org,
 npiggin@gmail.com, peterz@infradead.org, dev.jain@arm.com,
 akpm@linux-foundation.org, ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
 <83e88171-54cb-4112-a344-f6a7d7f13784@kernel.org>
From: Qi Zheng <arch0.zheng@gmail.com>
In-Reply-To: <83e88171-54cb-4112-a344-f6a7d7f13784@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 13BA5140004
X-Stat-Signature: pgx5zshobo8oji5yymqzekqz1594mj85
X-Rspam-User: 
X-HE-Tag: 1763466917-620663
X-HE-Meta: U2FsdGVkX1/AGDXEzE8MAyZ9J7Sc61jvrlZ3zEkGfLz53o2WI/eH3ZSBTqlueTDu7HQRExobUh2N2tJN+vdbqzCmdnGDFgGscY5yK8qykmp6MKuAk+9bZF45IvnfztR4ewQySpF0s7onHkMkPidWQ0IbHlwKtdvbLhDfTBmj5+axga58BwUuhUxU4xQJyKLnnP8ahr7QGJeaCoOckUVCJ1PGG0218AfMat+5TDv7fB2shIITFuP/AyxMHbpKiv0vd6jh1KHwmEggz087UO14dTWpdsQGhDk/RtVLCqWbOQxwHwsSTQCXcs+zxFdSD0PZ3G9tYTlp7TkUOxqX7nGDZGo4t5ilZefCIDNJaxtfXjsY2jOakBHy38isY7sEx0KMIQKJh3vCc523hkWheO7vWUU97t9Fmvnn89heWXp2QAtJotisxT5xvKxrrH6klYKKPD3JCl1NKL5H72KivWaMZu7pjqdEb0HbylBAB4G5P39Bod5TH3jcgBBoo4AdAPGJn7kBiiPKze52bICtit/9WBbXcY+0jq3Xb6AqjzmTD03c8zSi//49v0BtH6ymiL6hkxANlSxury6wrzAun053HbvZht0Cy5IIN3XSod1G4PEnbMOXsbp84yRwqS85uGcDGF2nhSPUsFbKlBZeqXe8+bnN3g2boW6+Wj2U6SJVimHZrCvIAZcOTKCUQv846G19p2pX4AmOkhsie+p4oQSWuuiNBzmLZSyO5c9uAvIncgUj9mWNPuBWXzldslGRi4ztIUq+ZMv6UGHuCXx7ziCFxC1uigVr5P571hx0v0o5+k2IY209Lm0dNHkrSUDQJm8wbZ5+tyJgqRMmSAbh57r0vNmkBC7pXrc3XhgAriAqoDdHzQZWNPf5V/ljYjuMErHDo24d2BSQjvMOewmgf7H4rm5DlVKM5c6qyvEP29GWWNbojnwQV0/2iR3fduqxg3gySwrWgZP69IJnSdlwL4A
 4mPZ4q3E
 vQQGX8QnWKXBdHjsoAUBnb2d3vDJ8tHkUVK673BbR9gfeKCWdt4XHRe8DtlumulHYn3GUKefUQzUKdMkz9lrB6DieK/J872cwv8MgLoyQw3YzPygDXyeJDAFto4YkuTLHqjMJFk4aqfDY8tlcrY5fpHrKe7D4oJhK2GWRU55JPJm+3QcfxODplgNw3Y/HfSM6VIN9VBhnk7856USHMZiMYFXm7a54LMEzhb3XHfKoIYDNEccpUvLXNlNt5Z2d1Hw9x4kpimsLbSimlQNptvOmlSCZvAuQEs7mz3NbR8PxivFTQdQwpkdkQCLxHKrdPbD45soKGfxEfa16PsGNQqp6ID7NGWlKRZhMBnD0KCqQ9I2i2wGU5pUhRz5ShZf7mJWppryK2dbL2lS+6qaMUaJP6ilH8/MAvMfpOjkfZm09yICXbh9mK8NRe9emHSMDBWe22d8UsC/xybHqgwAQ0wweNjGZeCALvfKIRr40n3LqBhM1VPKEApYXHGC5D/dKZ37xaQ0BSddYBxTC9aZ6c3L0IF2C4jCwljT2agEDgsvTaKPQEVBROLxDCJ12J9HUZbO4V0EwlHcj7DZgvTLYT7Twwi3/5d0yfpwKzKJb9I+gGXjMOs/DE8H5aDkQnl7z1JpNosN6fCcBW4AEBMjpseOmR7+I6TSgkgTkEYee
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/18/25 12:53 AM, David Hildenbrand (Red Hat) wrote:
> On 14.11.25 12:11, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Hi all,
>>
>> This series aims to enable PT_RECLAIM on all 64-bit architectures.
>>
>> On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of 
>> empty PTE
>> page table pages (such as 100GB+). To resolve this problem, we need to 
>> enable
>> PT_RECLAIM, which depends on MMU_GATHER_RCU_TABLE_FREE.
>>
> 
> Makes sense!
> 
>> Therefore, this series first enables MMU_GATHER_RCU_TABLE_FREE on all 
>> 64-bit
>> architectures, and finally makes PT_RECLAIM depend on 
>> MMU_GATHER_RCU_TABLE_FREE
>> && 64BIT. This way, PT_RECLAIM can be enabled by default on all 64-bit
>> architectures.
> 
> Could we then even go ahead and stop making PT_RECLAIM user-selectable?

OK, will change to:

config PT_RECLAIM
	def_bool y
	depends on MMU_GATHER_RCU_TABLE_FREE && MMU && SMP && 64BIT

> 


