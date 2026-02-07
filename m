Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CE26EE0AEC
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 22:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C74386B0088; Sat,  7 Feb 2026 17:50:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C228A6B0089; Sat,  7 Feb 2026 17:50:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20BE6B008A; Sat,  7 Feb 2026 17:50:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED006B0088
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:50:54 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B75F58951
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:50:54 +0000 (UTC)
X-FDA: 84419157228.20.E7E8A93
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 463774000A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 22:50:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L7o8XyUz;
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770504652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=guTUZAnKzmLJTo83FGB09sw8SSRh07aMEfZkMVMbC+c=;
	b=GXtVAcJ1dRLk2vT4/SxQBqsJaIk2BYEHRlFHCMsGTc+uUp1nyAtn4S9SmlFUwdnlEiwWTu
	B4DwtpGk4eSfP4HOGgj6ll7oQYm9TLQiCnwcVcL/SNiBp+MvegHVxQDNeT6BPWttG5SJro
	vz9T+kuQYcTWqQddh5slwBUik2FWRgM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L7o8XyUz;
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770504652; a=rsa-sha256;
	cv=none;
	b=ck+UbyWLRNEtqUFsW7fC2almEWUYrX7zqpv0N6Q9MCPckhgGbyVTWEazTcbAnhW/OTsdRL
	0rtNqosDoe5IW5nCtqJyc/HWAVgvbBR4Xt8mmcdHD3nO1PHGM9HvY5VAuyeMYY9Da+7h3D
	BWrRjfQj/rkD51iJpFQbRTBOhFS2ZaA=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-482f2599980so39142005e9.0
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 14:50:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770504651; x=1771109451; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=guTUZAnKzmLJTo83FGB09sw8SSRh07aMEfZkMVMbC+c=;
        b=L7o8XyUzKiaoKioOv+6nnZgg7x93LuN3XiVeO2qJqcad6G1uF/wPZ3O9Ksc6r3sn3X
         ND3y6QTFiaUBQgHstffE7m5rmagIkjMddycrOOpRbJazfqc8EG7Y57ArvTOiP6rRuTDG
         PjWK8Ic9K51sWo9wR3wmy7LoBFfmRNvzsiSobyv/32DEavT1h7twPHL1F3fv122EUuue
         6WGGjeq3/NbcJ8d/tJ47qOkcxISRMmhFa+5OkYDbBH/N7lQADeITKhoYpyBQF0bQilD2
         y85CeimX/ADuK+HwOF5lO5RwYdzeGs0upnDxDT2P0bMXVNx++ZtTnk1I5k+1aOVXsLg6
         dNLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770504651; x=1771109451;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=guTUZAnKzmLJTo83FGB09sw8SSRh07aMEfZkMVMbC+c=;
        b=oHOxeW/8489v4ExQwx4b+g/NC8wU1cpkEpc9U+n2ASGkJ/YqlVftvRynoKCR+dqSCE
         eDUNsKwGcTBmANpaS9VTD2BKUmPlPPMv0muJzAgMR9qYM6RZphEoyVOOPP+aoHPpjqvc
         XjLApHpeK1RL4f4kIjDDDX4nht9CtR6vPwOnfukK1yeLn60Atg/AElUR6S/qB1+1vh27
         Hk26oOl/aOzx2ENo3DIfLRqfkihQfUibxy0DRZNPQgC0Tg6KKzrzF47VbzLXtwQLzRLC
         wBMRHq86QO7b04Zlb1Fupj9adWPxZxf0XcqRu5+mo9KDxSuiyLkfWw/aI3XzLC5jJ/8V
         SdLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSX3QpqVL5HzRBBZVuQNMLhTiazxHAS2SVTOeunbzanwidvhe7fMjVA2fuJoyZwk198xT+TjRjfA==@kvack.org
X-Gm-Message-State: AOJu0YyyNVF2ZRPiTPKqhaJuhvt2fDtywVQDUmkvSZEU+Z5+rPlug2jY
	6sheFF7VM2ZwRRokj+hgfyaVLnR+WJInOSYsUgF2p2FcOZge67xNBsRY
X-Gm-Gg: AZuq6aLIiK7V19//31oO0CsH8SyG++xmTdKqUzZbXy8dZRCS0YOATcPgSgNy+4J42Xo
	1mPS8hV8Bl1ombcNGoOaWrx+0w3ihbNqimmVg62D0AqAxPIl7AbQTLs9butATVCstSQrVhOyGU+
	KmXF8lfDVmYlqazf7IrgWLlkt5o9ctjmGasYE2sm36B0SpKlaJbubmDAsNtYqSG/eaDv39SBZjj
	M4/u1lTlSzhzIW20FbWOx8+9CCTE4ZVjZy3IRF+VR3CW7gjtTWV3kx+8xP43ScdOfgU74WkEo5+
	2xyeLKGLzqzxk/W8dXAqU4veTnCrpuydhHZj5ungBNFI3P3UCuVjjpvxTwgyR781HJqBlewdY1J
	I4/ggCPXsXfwQ20ygNZytpiw/+TU5viS0fbWnzcYi/LIhCr3eirffhwNCf07eubMlCsd9KriIzU
	S6ASRvs0prjEAuNpMEbvUL2+F7yc16VCmWAWPYlTagBQ/Gdz27LCsANA2rD311aosEOt+eR/Huc
	+O3Bmv+4ZuVJbg=
X-Received: by 2002:a05:600c:3f08:b0:477:a246:8398 with SMTP id 5b1f17b1804b1-483201dcfc4mr103983235e9.2.1770504650500;
        Sat, 07 Feb 2026 14:50:50 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e752:9400:18cf:c773:ee86:c436? ([2a02:6b6f:e752:9400:18cf:c773:ee86:c436])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4362972fc1bsm16866971f8f.28.2026.02.07.14.50.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Feb 2026 14:50:48 -0800 (PST)
Message-ID: <110aedf7-9f31-4552-b772-395433d7bdb3@gmail.com>
Date: Sat, 7 Feb 2026 22:50:47 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 11/17] mm/hugetlb: Remove fake head pages
Content-Language: en-GB
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-12-kas@kernel.org>
 <907ff793-9b02-4a22-a85e-2873246f6402@gmail.com>
 <412359f2-ecfb-498a-9717-f0a442abd3f7@kernel.org>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <412359f2-ecfb-498a-9717-f0a442abd3f7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 463774000A
X-Stat-Signature: 5bosshynqpsrbhki7iajuojqggbmqm4b
X-Rspam-User: 
X-HE-Tag: 1770504652-233598
X-HE-Meta: U2FsdGVkX1+UC9BjdXO7d6BYZs/YpD4bxaCOKQha83/SRASKK1j1351KQ0w4y2tHgSppfruR4xIyAcCdr+HSKNbCk0D8xQ0AjIFAOj9PI3uBQRDfY8oIfkBu3bxcw63vF5xdBmvWwTt7SQ8+WjXW2R9ecBsy7QPpx0RrG7MwsP+RbxDVtR1MBmEXYMjrs36KS6JHlVkDLzaWj4m6S5bJ1MG7xLzKrSCR/QwQrOzH7IzvsW5BneEqiOhiNBe6XJPcQyjv7GHFfN1SK6Dfwl84tfMaEVToqrZTtZtx+cVzca3I9oThn5LSJpt7lzbihJEldUje4xbZQJTySamz0xdI3xIO0+7eidMEJHnuWUU6g/FVvTFi+6qkvI6rzFhSLCI3uzoPb1Rbh2p6E52Kcit5KMQn4McshhPYT27/T554T6oW4itRQl4GALtl2nt8EQvA9st08B0DLMO34+vUTkvGSCnqqb5Xbhe3QCxO4KkeRTUdmfeRdtGaIWY9nsKG3X4NKIRSOdCUMKqxdEGTHlTEypN2FIOoac7oE3QC4xZpnSR3k6iS9gug8qh17PfbWQYa+99sFnYHE44GaqxXO3TQcsrHcCwE9uwtlLEVzfLotNX9I/KvHyrvKBmbjwzOQea0BR9/ff06FJR0LQK+gLi0XggJQrcAkxVSRVMguCWahmOzqw0JSjgaZGMCx2IkDoyEVb1HhvnTCB2qMEJ78J1xEiddC24JL2tOMFSFOv+OfdB80v9lEEM4nczBnw8umme4/NUnIkOfWbgWt2IznqZZFjdv7An2iNrf4Q4nsBTK9AD0CFsDMTBqG+vk47VvwhG69Dofk5/CFg0QJDc/b0eEVVZqinYwdgB+c6cRAlE26mHablZd6T4t0K3u2AJuYyvX+ONHGhiiEvnoOK07uAg3LZpz7MneiSl5WJs0a9je96kpZYtAVfGdREh5yPfY5SdYZngk64YKJuEbDeLfXfU
 LRZ7kGGS
 1joc8V37D+MueCJDuZ5Nq7YAvgWMkfWzMydmoP46UqiIINRKhs5E1THQE3iKq4QBrFWZhJXT/MSWm++VZUIOqF5+lznYkzXBH0lkHISlcZK7r8oqPDcm8CRlAYGDNPirpNb+XyxpFqK3VlS0nw8nKioxvnZdgQjDXTSzKbj6IyAIpNqqh3gNiNsRiW7N6aaGXsJ9uJFFncZEWdLnj1Xnw5Hv3Yl/d+VQvs7aILGMOE8N/b7HSvl84Elrrw+UiEfmi2fwmAK/ynbi/znFWQslsX5rOuOsslxTUQBIAake95dLBXg7FwnZFz5A2gtLR4F4dLlp9ARR7FlcRN6iNLVU2HmrIPEJkB6ob/wquC9irhV9M8zM25/ku4zI0yZPnTOTkVmpx3YqHFwluZH9OscdEYA71VlkU4owQXUGa2nwN5cj9x86bx2rQ3c008C8JVsJDg4M3VSQDCvNr2VXCsI8tArcUtuhYihMnyfbW3o9zEmIBFSdC5kSxBO9AZzIDUa/yTDWeGBrFU/9ZiwQkdIBRsgC3AXFXhcOhXTnp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/02/2026 21:25, David Hildenbrand (Arm) wrote:
> On 2/7/26 21:16, Usama Arif wrote:
>>
>>> +
>>>   int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
>>>                          int node, unsigned long headsize)
>>>   {
>>> +    unsigned long maddr, len, tail_pfn;
>>> +    unsigned int order;
>>>       pte_t *pte;
>>> -    unsigned long maddr;
>>> +
>>> +    len = end - addr;
>>> +    order = ilog2(len * sizeof(struct page) / PAGE_SIZE);
>>
>>
>> This doesnt work for ARM. For len = 32 (2MB contiguous-PTE hugetlb on arm64):
>> ilog2(32 * 64 / 65536) = ilog2(2048 / 65536) = ilog2(0) which is undefined.
> 
> HVO should not be possible for that size, and we should never reach that point, no?
> 
> Remember that for HVO, the metadata must span at least two pages.
> 

Ah yeah thats right, ignore me. Its also checked in hugetlb_vmemmap_optimizable_size,
so its all good.

