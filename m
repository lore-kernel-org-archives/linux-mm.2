Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CF59CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 12:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A69A8E0066; Mon,  3 Nov 2025 07:16:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 757188E002A; Mon,  3 Nov 2025 07:16:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E418E0066; Mon,  3 Nov 2025 07:16:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6318E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:16:07 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 010124AF1F
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:16:06 +0000 (UTC)
X-FDA: 84069192774.15.0743B25
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4966D20005
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:16:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a4rMtue2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762172164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WsMXCh+iFFtzPSIRTCb9422M4w3M6JOwaIkWBJ3l9zg=;
	b=8mCmDGOM9G1QuMTNaw/4rwGpYYQgvBJa+Gax0V97O+aIKfgCPXwMIbFjb72tzGMqap7wNi
	aYw5qVAJPjCPcsM9J6d6BymglbZCKmdiunlQ7J97KQ6WyejoOGL7VxBy/VTt5x8yKS0Oj2
	eNjusYvcKnmJoAD6akIEyBMvD3cCVgE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=a4rMtue2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762172164; a=rsa-sha256;
	cv=none;
	b=NHPho2bmQWNnKqubHGx6dKehenmfBVVcu/sa3rYYjHmUyFgnpC8FKIO682gorYsDaZ/fbI
	cm0Ec0nhjR1sBj6R1tCNZNlPPyx/Mtjmasi6xvun2aT8A+aXRbjPJk4aCey0V01gFC3SsR
	AG1/UKMjbMpvQYGPT2oL987Z9tkSHdA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762172163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WsMXCh+iFFtzPSIRTCb9422M4w3M6JOwaIkWBJ3l9zg=;
	b=a4rMtue284uW/gLTziL0EVrN3BkKQutAtAKn1QKE9sXcl8ONNM8PL1kuDZIf4M2V86DODy
	paWlcbIQLayRgp1ZtjVHIo6Xp5VFB8jIdoQva9yWazsN1Lob5uEJici8J6Rsi7E/xGOinm
	GXUGxBVE9khDn4eWmb0Z7uIU0Lo0tlg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-OnesunMQMKKg4cOEQIu0Yg-1; Mon, 03 Nov 2025 07:16:02 -0500
X-MC-Unique: OnesunMQMKKg4cOEQIu0Yg-1
X-Mimecast-MFC-AGG-ID: OnesunMQMKKg4cOEQIu0Yg_1762172161
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4710d174c31so47568345e9.0
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 04:16:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762172161; x=1762776961;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WsMXCh+iFFtzPSIRTCb9422M4w3M6JOwaIkWBJ3l9zg=;
        b=PGtlFRtbGp9Nj0h50BbZKMTSeAB6n7qowZN0dRPvfABOOor8FSJcNd98rcNAm/YCea
         EJjd7RmGhluP5lMNyZThPITnlz67fAdCeg6vlxPctfRQFE2FXxTH4o8/kL+eYG41/M0x
         0PKJEI0IIZebMPeKeuf/vmY21aqiBB8jLX/CsClT4NouGhi2ZIuxl9ky8XLVA+66Ka37
         OnSbMferZHSZ1WLBA/+dMrxODC5LzU2IkQIyHEX9Xw0VixWrp7E8E8/+P1puh+e6PdWW
         iZWRJ+uyORANBJSCxtgVslFGHl9rSt/zDAnum7JrP5bqg1viJYVcnEHah50VAR1cJ8Bm
         j4oA==
X-Forwarded-Encrypted: i=1; AJvYcCVPz4DCBT4qMPCnSNjNTCTnrgtVgZVjCWz/wYQDo386lg2PF7t1J6SAIOUa4W7P/nX0hQUuBVDtrg==@kvack.org
X-Gm-Message-State: AOJu0Yw0vozHWwgLmweKaB+v0qTT72rrbRW8wt4HOiypdFXgDOMGh+H7
	iXORHe9XcNpbUlBwA0+11GEsa7aQQ3lbcQYwvNE28Qh9UIowyQgK2FjSJZ382SO1seRYKkcrUTI
	jRtmZrMGiGaWjSWjoCURZv8Nu/DrrXY+1XjfW9mRFaNugUhR9eXIl
X-Gm-Gg: ASbGncussX674ekneP4uCoJiuzdUSPUZalo0jneS9URMLKcuyaeO7WBp9gizWcOYTrC
	UjMur6lsX+4A0ha0f8XBctdpHOjiYh4TMI+Ih78iU4bwG9I3l8wfXCSkCBA0WsDn45HPj1JKtg7
	pyAImEZjtcMlfRgfnu42MzWxKoGNM+atm9nVCCC+ejBoZLZ0oTCsfNJals/Ua5psExV0uAgYfJC
	jIQBCgDIwQEupNZoIkDXIBvgHwRWcxwAyfOaEqdGF1bsEACRwaYrM/cxGxBTDSVklcr9jw5y95M
	OVSLTvNhoxvID5yQrsNXKroZor1nXfek4qVdIBJxHdB+1lEVNWyNQ5mKeJF47xF5/0Yjfs3zi3y
	wuXPZF8ti7S90McDd67YihpfQ82maSZK9lvgiDPa/1TEXrqbdm+Tpuaj0LEA3NnVFetRGAjBHK9
	oacGnm8zGyLRYGfdJnauKLk8Bctkc=
X-Received: by 2002:a5d:64e8:0:b0:429:8a40:e995 with SMTP id ffacd0b85a97d-429bd6ece4bmr12949815f8f.61.1762172161226;
        Mon, 03 Nov 2025 04:16:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHJz3FBKsr18wkuyol1fzdxNXOP0NzjA4OuIx2R32uJMWanPs2oQny9N+V7osFONlxQu55C5Q==
X-Received: by 2002:a5d:64e8:0:b0:429:8a40:e995 with SMTP id ffacd0b85a97d-429bd6ece4bmr12949761f8f.61.1762172160704;
        Mon, 03 Nov 2025 04:16:00 -0800 (PST)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429c13eaee6sm19776225f8f.33.2025.11.03.04.15.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 04:16:00 -0800 (PST)
Message-ID: <341ff738-255f-41c7-8b23-48aac4cf51e3@redhat.com>
Date: Mon, 3 Nov 2025 13:15:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/memory-failure: remove the selection of RAS
To: Xie Yuanbin <xieyuanbin1@huawei.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
 luto@kernel.org, peterz@infradead.org, tony.luck@intel.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-edac@vger.kernel.org, will@kernel.org, liaohua4@huawei.com,
 lilinjie8@huawei.com
References: <20251103033536.52234-1-xieyuanbin1@huawei.com>
 <20251103033536.52234-2-xieyuanbin1@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251103033536.52234-2-xieyuanbin1@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QR-hdwyFR5TGNDV218HbNJBW9YwRsqFfXJwcdglD9-Y_1762172161
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4966D20005
X-Rspamd-Server: rspam03
X-Stat-Signature: iqmbmz8u5xwhnr8uk95rs1bb4tk5nw8o
X-HE-Tag: 1762172164-285853
X-HE-Meta: U2FsdGVkX18mHGdybQocHx9WleUMLE0IjO/f6B/JQK2NK+eLhn2ZIU+vjYTlL3KsZEe/m0wh+sb0eD9lTeEoFdYnwfdBa5ScBcLAiys/KQ4dl/FVOyECkt1R5hng04RmQ0lZ6t+kx8R+Pl7dAO5onY7GVng3dsPXGaVZRwWIV15cnvKN+ebLNQQB+89r6XP8ZhcQDobxa12JHNLbP5UfhnDwgi16KABoStnQ0SWrOYaSAb33N/UZGghPcvU8VmlrdewZ3eCqgDtZ0eACoPiD2z3j3/Ef8xCc5IEzeH/qTXfshPhMJegdD6TbonKifc4OC/jDOLVDBJorSR+od9sH+B+RzoEXyUJQMr5RAnQp/z25caIoxXKU0C+DZsgmu/8oatym8rJ+JDv4z6p5MfdhVA8jk0TWGCh7X3xoQnnKmPCIWcOGpUUnnJgcZ2HZ0Xtbsa61BSleVI4E0EVy4c2hxhbkEWzf4uSjpY+Y+oy4a3AO9mxKMrkUDECFahiK+tHDQGM5oIu0SXdtClQEMmLkR/ZfKZxmnuK1+1b3hW9CgBHcIT63fVuRsdTjEhmoQBgRr7MUt1J3OvST1PksM7+QenikX4wSr0Q83YRdR899IhMD3BELhNzMVjt5YeHjN2nX7lVKiK+yFvsBMiM2ZfGS0Dyl6uDgeAdT05hoOX0yx1oovYyGyC1doKdPK9kDpNafKoPRio0SDPbu6ZhbsLHNoi+ACJ94ZV0IEEjVPynPB/m17gcbIhmcEztLbUbccIbE198ReoV4d0K+Dp6GT6ot63pI0abTUiHD7MLOcpwtTwLJd0Qu15kHBp8Q314Yh3fDQILBXpeJ18fP4Y2pXnlLjPKca8psv09vuZUuMyVG3mwoxAYvsnHDCP6uzZGYUmQqCku7X62ipaLadHYLkNHhL3gGWr9jHaOSFTNgGj6ONFwBwlAl4HVPUF6HWBAaY1JyEgl+39cJkNxk6uQH/f+
 UEDCcBq1
 FxxuOl/MbSXI8BAz18KwSmjhiv7N5fM/Q24bpFBv8jJjWaA+SZk+6yknb7gAseygXfyxYaIVwyuiwuoLkncjBqmlMjgseBQNKjyg3L60Vy+HzzJ2PMPuQSU4khVICSkO8QBuiwB+5p6C5oShdxNWU3P/tJA8g6KmQ8yAAR4VelIWAIVpEtNP2hdU/rHLFca0ovu55zZKU4SSKfUkMLtWd0pH2+Y4rcDqwuDh4au6ycHADbMDjZn+fn6vK8Z5KDRVQRfUb7sK8v0T5rOMQsae31kEd114joLJonBNRfit54ESUoEQ2GgnxIata3lRcl6XslklJIVWRcxrjeebuQnH6a3Qi0oac2fO0Hg5ANqf126Lsjwv6IpNZshkNvJZzA3BAtQEOZe/vkEVzerGH3PwzOG4ubQ5WA5IKAbyBFQQ9MTzcSfy4WzMOPGoP3ao47Q9bW6G21T+4XjzPMjChT9DNMhfn2hM5cWfUecXURsuYkUO5SvLpIpahlVq9BZhtQp6tvz7/gKWNm+FojYB6u7s2+yLGIg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.11.25 04:35, Xie Yuanbin wrote:
> The commit 97f0b13452198290799f ("tracing: add trace event for
> memory-failure") introduces the selection of RAS in memory-failure.
> This commit is just a tracing feature; in reality, there is no dependency
> between memory-failure and RAS. RAS increases the size of the bzImage
> image by 8k, which is very valuable for embedded devices.
> 
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
> ---
>   mm/Kconfig          | 1 -
>   mm/memory-failure.c | 2 ++
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index a5a90b169435..c3a8e0ba1ac1 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -738,11 +738,10 @@ config ARCH_SUPPORTS_MEMORY_FAILURE
>   
>   config MEMORY_FAILURE
>   	depends on MMU
>   	depends on ARCH_SUPPORTS_MEMORY_FAILURE
>   	bool "Enable recovery from hardware memory errors"
> -	select RAS
>   	help
>   	  Enables code to recover from some memory failures on systems
>   	  with MCA recovery. This allows a system to continue running
>   	  even when some of its memory has uncorrected errors. This requires
>   	  special hardware support and typically ECC memory.
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index f698df156bf8..baf2bd79b2fb 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1276,11 +1276,13 @@ static void update_per_node_mf_stats(unsigned long pfn,
>    * setting PG_dirty outside page lock. See also comment above set_page_dirty().
>    */
>   static int action_result(unsigned long pfn, enum mf_action_page_type type,
>   			 enum mf_result result)
>   {
> +#ifdef CONFIG_RAS
>   	trace_memory_failure_event(pfn, type, result);
> +#endif
>   
>   	if (type != MF_MSG_ALREADY_POISONED) {
>   		num_poisoned_pages_inc(pfn);
>   		update_per_node_mf_stats(pfn, result);
>   	}

I rather wonder whether the memory-tracing code should live in a 
memory-failure.h instead.

-- 
Cheers

David / dhildenb


