Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D525ACCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 09:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320B08E000C; Mon, 10 Nov 2025 04:53:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1538E0002; Mon, 10 Nov 2025 04:53:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C08F8E000C; Mon, 10 Nov 2025 04:53:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 027FE8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:53:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A988D4CAE0
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:53:38 +0000 (UTC)
X-FDA: 84094235316.08.C9921F3
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id 994F54000B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:53:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D3RYK18b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762768416; a=rsa-sha256;
	cv=none;
	b=POD6UAkYy/l7ckNXDfwkNLrBO0SzuJM5CaO0kxO/dB15jW4aK5oa+xRyYGknvDdjWzyrcW
	BS1UavG6j4KDpuIpcsBq1oR8cfuUedB3UxFIv5qk9g626tW2tJOnVzFNpe4k8AAviULgn7
	fJN890OJ21oXjILk5b43m+VgL6nWS9Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D3RYK18b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of davidhildenbrandkernel@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=davidhildenbrandkernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762768416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FdVTKsm8GAbvPx2SpTGUo+BQ4+zMzWzy9tfx/LEXR4E=;
	b=BQXugKtYVKSEeU/hPG1t8XmmYQ+ozydSoDtXy02Qxd7KNzHNI9nJOKsUOFdUHpL65Cnvdu
	E7fREKe+jSw65Shl98R237zbJJkNnpBVVmyrDYfsxGcdDRPEMBBvKs/7WmgCaJ4RdkSQQP
	FSK/T5wAtLf07SLg4m4IZ9qTGX8azus=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4710a1f9e4cso21425115e9.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762768415; x=1763373215; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FdVTKsm8GAbvPx2SpTGUo+BQ4+zMzWzy9tfx/LEXR4E=;
        b=D3RYK18boHkAqL2T3d59YUh1xxnLqgDUEl6oSQ2iewbqMgtKABjGnppciczOAjxAHp
         6mIvM940zwb0XIsn0N8/l9bTSfbJdsTL0Dko7J6kTC+7OkEdjDPrHmRgXZwRZGB0TbWw
         grBcnXzN9Uxs4RknGVvsbOmR0AFeqWIl0kgab2I1a86AVmJO2QZQThWPpkDZwV1KJQaJ
         kPafcnB0akCU6tPYC9H4Zsk2tkoELnl3q+IIgs/lTcx2F/Lc/RwUf1NUfhXoW4WX/L3n
         5V2jbGciTkTXn9cEUM23Ws+5btHVrRhoOwKs/AN/lt4sfquq53mvdhchtdTnNy49I//e
         8Esg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762768415; x=1763373215;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FdVTKsm8GAbvPx2SpTGUo+BQ4+zMzWzy9tfx/LEXR4E=;
        b=QMX52aG9L720lO4pBsuu1DuxrRqlRE+qtNAbCJVmDDkxWd8j6T3E6fYTG8lfnWY959
         go6XrmDwrrR0DzsqRAlU8UOuKPBuF4HGfGP4jW/oh0+cK+hs5RGc9yNz+5bmrbZcqcGJ
         h//qvLMtQ0wiEGas1ysgFQV0b0Fb1HCFlFZos7RZMrreMJrZhVmY6nlnW0Y7kH+HS75p
         Q39P1NObyo/q6H0TJgDVyxxthFX5u48oba6r/C5B/ng34lIxOos3pwA+eUGa6nGYnS+8
         Y7LOJimIWcUm2S3nIf5MPwQ+neQkcofwIVHYDSvNfAENZdE4yCpd+4Afu46GIv2LBtEz
         svSg==
X-Forwarded-Encrypted: i=1; AJvYcCUWsSYx4bouQ7Fxd0YkgMmjftnepKZtuBM11bhf7LvRx0c4rTM8UCoLCXVhCieD+OhySu+RQ1r7jw==@kvack.org
X-Gm-Message-State: AOJu0YwopLlqAuCmWobYx/UP34BD2fFwmVE4patTbAqwsKauegMbRSBP
	Mm7OxQgXRFnhnBzFI1uwCFLDKfd/gQ0o16UyW1AEAAyuayHNrzyjNcGtvNYNRQ==
X-Gm-Gg: ASbGncvKHgToGLWQ6/hbLi5/CCWtyVZBfgRcPOTvWpjkD07A0rclgtgAVA0Qe9WiM1n
	sShDtH+Zsdy5n1b0B308YOCUb6hemQfixK9iEFcveSgC1Jk/j5i4ekbZ5lGaRk1zxTHeYqEysSD
	fMJxHJu6/oglsxmNZzEIymaLfQTuUyUxyYVDFVr0CtgiARh80pPM4qzL3QzAFzpUjw/rJcIelp1
	Oqj5Vf8fRbr0W1nADuyIr/Y9CWCJgrSMlNTq3vK7GHrMDbakB+s8Avun4eLzYyzzpYR7xtzHfVQ
	NNUgbmfUn22OAGVveK+g0bWAipQCQ7zrRCh0tSRH+dzuV5Qo/E5h8XFPB0BEZWGk3621CwWARlZ
	tLZEPa7gZfpkzpc2LKdzm2ck4imeDpP37urnJQpPdUY7Ul199E06zZg1JNKs9CC8OPODNzrQ2oE
	BVtwlZAwp2GWeKOo2p7nbTGCPPQ+9W+/9mx0SICgGiOrjml6zjIG//YwCZHkO183+p5XYi5S5SW
	hm82aeB45JUo/k1YXcmNjFMRBMh1i/hpQSFGMCuNo8nbcUP0cqohmmca9RR
X-Google-Smtp-Source: AGHT+IGsooEmMcpiBszEC0S29az4N9pDXGOvaoT4Fy0Z8fKUBHepw/QGQNXOLUsDa6Q40qnzLaxOfw==
X-Received: by 2002:a05:6000:26d3:b0:429:d084:d226 with SMTP id ffacd0b85a97d-42b2dc2091fmr5677341f8f.24.1762768414585;
        Mon, 10 Nov 2025 01:53:34 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b303386f1sm12732923f8f.3.2025.11.10.01.53.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Nov 2025 01:53:34 -0800 (PST)
Message-ID: <fbca7868-6f68-4b98-a2f2-e39eb46b7f12@gmail.com>
Date: Mon, 10 Nov 2025 10:53:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: restrict __GFP_ZEROTAGS to HW tagging
 architectures
To: Jan Polensky <japo@linux.ibm.com>, catalin.marinas@arm.com
Cc: akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, will@kernel.org
References: <20251031170133.280742-1-catalin.marinas@arm.com>
 <20251109003613.1461433-1-japo@linux.ibm.com>
 <690ce196-58cb-4252-ab72-967e1e1574cf@gmail.com>
 <aRG05VS-IIxV2y_C@li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com>
From: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Content-Language: en-US
In-Reply-To: <aRG05VS-IIxV2y_C@li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 994F54000B
X-Stat-Signature: yde4zrrs9m7ctniu1u5iwh3orgq6k4hr
X-Rspam-User: 
X-HE-Tag: 1762768416-63463
X-HE-Meta: U2FsdGVkX1+FfAQU/nupGGk62jU0hY4zvWeLIw0LGA4a5nOD8rHF0vINB2t7squX8NstF/DIdj11DzXJZJNCA55wp3+zYZsZln53Cz7furWJ/Ose2WWdqhDW2UzHkKjdr+1v93K/bJg9vvPQxq+2byxAYa7KdNYB1FE1iP6hhgFJsLcmEQutZ1VJGcd9lh/PW/WVBKnQnzEdkIEi5+ee1P41O4InhAged3QOYgE4xrs5SXh1OWINgj6QGAaDRGPWIock+qP1fFUYA/bcvifO/ZFoR0jiQag3Tp6ek8LedAo1XCsJzYLbhGUGm/yHY6Sw89HAKAM+G3iGKS3EJLT8UWMJdYGfoHygtTerrnNLBtibIe5U4rnlHWdYIuVfHf0dBLgbH7zRcUWYVxeZNN+TAE28MmkG3GghcxO54oG+6xFdTPGRJ7VJSAMs7Rc4YiNl6AvcShaNvGfWhxfDWn97XFikp8XiU9A5ve5njWgSHFlCL/Dwvm214U4dTzBX8kZ1/JXufMR3WaozOwbBN+Tg7s1q+KbVwsoQxzHiIM8+QOynRrouP/wloFkhihW0f2cmJ+xIxc55dHe/rugsZttOPpHACcezgaiOpDFPS2OlRS3U2TXibn+45vd5zmMJ4uPI8/oUTZ3NGOFl19RKRt7/RbkdiTLDNkN8sCKlfA4kKv0U3z1zbp5iyf6h4J5/e0tJR/Vfmfuqi3J0xmh/XjLwEKdeejVumyEUQkznmRUZa05DymXtOocQYNmCPFj/bH6X7y/nUplEcpJpf2r40YJwW/Blh25HrmmFO8s0+n3aoaUViAdcfBdyzeofyvPUqtiV4hE+GBDdHpznPFrg8YaJ0Gu+tz4ovLUK2RmrUWW7DyEkPruWiXRZ0aR3SW8wTV6ZBB3gVyBnCkHLNQLUF48zziNxk7CJ1m0USdcG1Z9HJ6zF2LSKZQmCsp2ULU1pveVstp7eNDM8AGbkF6tsOiw
 DTryepON
 6JwhN9mIv9PCXrtkPmbNZp6eeACFSEU9B+JNYDbKvvxsh4Qjvj8smlyxmPX9LRdteEPUt3uWmGqzclPfZH6ENhALJf1h1pTYW4zFBMHkUly1AjzhZ+BhP6hQG6ETSKbxjstDpWCtZINnnOYiU2kRg7m9Amwx8dQAWGHe/puva154a7LBgzVMu57sREswtV5q6kv4WMvU1TzFEvI3gwYiKoV9K7waI2Vzk3JrV/0H9DsP+cWB49p5rpY6EQteWmFcnN8Q/lhIU9XfC+OH67PR/PfUTbK8Wif8N9Et4W4Yodw9GtAuJmwUhKepMevfl4GK1KhUZXpCE2OX9KUGjF5skdMzFjb34eD+6RlqZoWhsNAipC7+16ZrFbmeH6Fq8vk7arq8ghM6MkL97MDDF7MLQOcLryYceRn56nxs5X5NipJNLDn17wf6xpyKBmvRwtZjcqlEXZJF6ArNHKLUsndZjPZPgQEpW/WnSO9JCRIt61ES6vDNya6qeYOZatNwxmp5Ihi6kJ09SWQV4pCGbn+LJrya1duphTGrTZuSO8NqL6xfvD+mIIUtJbcIwkAygg6IVFvolovHbzZxS+4d8k0I4ODhIVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.11.25 10:48, Jan Polensky wrote:
> On Mon, Nov 10, 2025 at 10:09:31AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 09.11.25 01:36, Jan Polensky wrote:
>>> The previous change added __GFP_ZEROTAGS when allocating the huge zero
>>> folio to ensure tag initialization for arm64 with MTE enabled. However,
>>> on s390 this flag is unnecessary and triggers a regression
>>> (observed as a crash during repeated 'dnf makecache').
>>>
>>> Restrict the use of __GFP_ZEROTAGS to architectures that support
>>> hardware memory tagging (currently arm64 with MTE or KASAN HW tags).
>>> This avoids unintended side effects on other platforms.
>>>
>>> Fixes: 1579227fe0f0 ("mm/huge_memory: initialise the tags of the huge zero folio")
>>> Link: https://lore.kernel.org/r/20251031170133.280742-1-catalin.marinas@arm.com
>>> Signed-off-by: Jan Polensky <japo@linux.ibm.com>
>>> ---
>>>    mm/huge_memory.c | 9 +++++----
>>>    1 file changed, 5 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index aae283b00857..0c1794656d7a 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -209,14 +209,15 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>>>
>>>    static bool get_huge_zero_folio(void)
>>>    {
>>> +	gfp_t gfp = (GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE;
>>>    	struct folio *zero_folio;
>>>    retry:
>>>    	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
>>>    		return true;
>>> -
>>> -	zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS) &
>>> -				 ~__GFP_MOVABLE,
>>> -			HPAGE_PMD_ORDER);
>>> +#if IS_ENABLED(CONFIG_KASAN_HW_TAGS) || IS_ENABLED(CONFIG_ARM64_MTE)
>>> +	gfp |= __GFP_ZEROTAGS;
>>> +#endif
>>
>> That looks like the wrong approach. If an architecture does not support
>> __GFP_ZEROTAGS it should not trigger anything. __GFP_ZEROTAGS should be ignored.
>>
>> I think the problem is that post_alloc_hook() does
>>
>> if (zero_tags) {
>> 	/* Initialize both memory and memory tags. */
>> 	for (i = 0; i != 1 << order; ++i)
>> 		tag_clear_highpage(page + i);
>>
>> 	/* Take note that memory was initialized by the loop above. */
>> 	init = false;
>> }
>>
>> And tag_clear_highpage() is a NOP on other architectures.
>>
>> Gah.
>>
>> I wonder if the following would work:
>>
>>
>> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
>> index 65db9349f9053..56b82e116cb79 100644
>> --- a/include/linux/gfp_types.h
>> +++ b/include/linux/gfp_types.h
>> @@ -47,7 +47,9 @@ enum {
>>          ___GFP_HARDWALL_BIT,
>>          ___GFP_THISNODE_BIT,
>>          ___GFP_ACCOUNT_BIT,
>> +#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
>>          ___GFP_ZEROTAGS_BIT,
>> +#endif
>>   #ifdef CONFIG_KASAN_HW_TAGS
>>          ___GFP_SKIP_ZERO_BIT,
>>          ___GFP_SKIP_KASAN_BIT,
>> @@ -85,7 +87,11 @@ enum {
>>   #define ___GFP_HARDWALL                BIT(___GFP_HARDWALL_BIT)
>>   #define ___GFP_THISNODE                BIT(___GFP_THISNODE_BIT)
>>   #define ___GFP_ACCOUNT         BIT(___GFP_ACCOUNT_BIT)
>> +#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
>>   #define ___GFP_ZEROTAGS                BIT(___GFP_ZEROTAGS_BIT)
>> +#else
>> +#define ___GFP_ZEROTAGS                0
>> +#endif
>>   #ifdef CONFIG_KASAN_HW_TAGS
>>   #define ___GFP_SKIP_ZERO       BIT(___GFP_SKIP_ZERO_BIT)
>>   #define ___GFP_SKIP_KASAN      BIT(___GFP_SKIP_KASAN_BIT)
>>
>>
>> Likely we'd have to make __HAVE_ARCH_TAG_CLEAR_HIGHPAGE a proper
>> kconfig option.
>>
>>
>> Then we could turn the default implementation of
>> tag_clear_highpage() into a BUILD_BUG.
>>
> I'd like to suggest to keep the enum untouched and only use the second
> part of your suggestion.

Why? We also do that for CONFIG_KASAN_HW_TAGS, CONFIG_LOCKDEP and 
CONFIG_SLAB_OBJ_EXT.

> Which works by the way for our arch (s390).
> 
>   include/linux/gfp_types.h | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index 65db9349f905..c12d8a601bb3 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -85,7 +85,11 @@ enum {
>   #define ___GFP_HARDWALL        BIT(___GFP_HARDWALL_BIT)
>   #define ___GFP_THISNODE        BIT(___GFP_THISNODE_BIT)
>   #define ___GFP_ACCOUNT     BIT(___GFP_ACCOUNT_BIT)
> +#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
>   #define ___GFP_ZEROTAGS        BIT(___GFP_ZEROTAGS_BIT)
> +#else
> +#define ___GFP_ZEROTAGS        0
> +#endif
>   #ifdef CONFIG_KASAN_HW_TAGS
>   #define ___GFP_SKIP_ZERO   BIT(___GFP_SKIP_ZERO_BIT)
>   #define ___GFP_SKIP_KASAN  BIT(___GFP_SKIP_KASAN_BIT)
> 
> This solution would be sufficient from my side, and I would appreciate a
> quick application if there are no objections.

As raised, to be sure that __HAVE_ARCH_TAG_CLEAR_HIGHPAGE is always seen 
early in that file, it should likely become a CONFIG_ thing.


