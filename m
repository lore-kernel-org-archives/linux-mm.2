Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 819EFCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4FA18E0007; Wed, 24 Sep 2025 05:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A278C8E0001; Wed, 24 Sep 2025 05:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 915EC8E0007; Wed, 24 Sep 2025 05:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7983E8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:13:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2478B59E83
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:13:29 +0000 (UTC)
X-FDA: 83923580538.17.8457D7E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id DC635120003
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:13:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xs2Tag4Q;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758705206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zX11camkE4Hg4H4xV/n8C7NJAv/AAjeZxxkMV/ADChc=;
	b=fHwKZSMwlgjZkjMOmj2vqNJFB81Y0hcfvNc8sHXzQBkHgEol933MGltmSJEoQN94HzWTq5
	X16LSb/XElNabdDYmc+Q1f4TXLbWdjeMHYkHu5iTe6ymCr0KuFs2xMr5j05u8YcOEWgyTa
	Jgotcmy8iBDQ+N0WjjTjuWx/rtbpjOQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xs2Tag4Q;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758705206; a=rsa-sha256;
	cv=none;
	b=5qiz1aS/rBRnbLThXLMYvk5wUeLA5IGYIyERy3do2EgW0rewepPhe9GWOvu1R7Ep4mCmB4
	jrRrIMbJl9WwFqR5QrXhUDeHiVVahODKsbq+7hMvm5B7mmTn2aK3/raRMFe6BOhZSXxi8G
	uTTO1ZnYahMMkC1tnNbnlmIuCO4qIhE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758705205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zX11camkE4Hg4H4xV/n8C7NJAv/AAjeZxxkMV/ADChc=;
	b=Xs2Tag4QD8TmRy931UMYvcPJRGbk8sGSu7ZtPZBVi0UCNrhUCbWC0c33OaNrjKoPMcFOvo
	l6c+o1ipqTJgLWJNoNfE1n1WnAPZNBD+1PwdbKXN5djVxkoBFYhDR0h3b6UBfOY3Xtwip7
	2XyCN9gWcJqBQUnLMGrxDb4nKGam9zE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-9p9MjKwCPZq0Kx9BFkZ4MQ-1; Wed, 24 Sep 2025 05:13:24 -0400
X-MC-Unique: 9p9MjKwCPZq0Kx9BFkZ4MQ-1
X-Mimecast-MFC-AGG-ID: 9p9MjKwCPZq0Kx9BFkZ4MQ_1758705203
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso4273425f8f.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:13:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758705203; x=1759310003;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zX11camkE4Hg4H4xV/n8C7NJAv/AAjeZxxkMV/ADChc=;
        b=VhEr4EeHrARl5Z5rA1qvVvzxKK8AJnrkuKcnZSEsAFrHMTuNyWl6MejCbfLfMeC/yZ
         SoE/j0KRuQgPnE4AoUIW+E4/AZruzfjFkTlWC8NDG/AbMByZ/X8aW550lonUBk3vNQKB
         rm8kJznqVmfoF8EC3Lsfq/rnky7+oWLRzklnxxiui1CQ+1ScFf+0YxNRSyV+AjKShvgq
         5tjU+/k06n9PBN77nZEsM/tykd7Jj7bntH8WA+VJHmxRkzfzM7reX3WmejMHfW8OBcof
         FBmXESW61ARCqZ7Stf9MBAnKAGQjrKp9Ryo/FGqBzgCvYqniOZ1UM+cI4BH97CGFSvlB
         XG/w==
X-Forwarded-Encrypted: i=1; AJvYcCUsTVfckI57I/sYyu27OZEBCSWL6+UAaTyS2Tuv9DCZ7l16y1bhtVjgfk9Lx2XvALp1aEqQu+YdwA==@kvack.org
X-Gm-Message-State: AOJu0YxbJnY5g566uQt1R8nz5prQ4dS02FCq2PubfhyU5yk0tBsh7P34
	scovM8ze/MrJ3Xn6qjD7UVRZnPuay3fQbgRev+XOYGZ/NWtvyt06EqQ2ri3TcQw8Q4nF0xxwyjf
	zjfyoO+5+VZOpxVsDyjukGJjAadyJQfPBOVErg1zJCY9mILnVykHe
X-Gm-Gg: ASbGncs9eEI5W4b4ep7AeZBCPr1dkrK4+nBkXTdl6UnwYK01ONcJeUL53lLWKBCOC2w
	F6i2dQr0wJapr8YnRIkLFL+1EjvvEZCfEznzzQMKYZwbbeNhkLMBYpUu/CcNcv2k+z/lfDSMb02
	jU355oJ8Aqr0p3EJCLaysxmnaaVZ6s9g8MtrqRv2ZitRmlCrIkOq8x03vZNFAOEOeoENUgPpIa1
	vaqjbFpeKn3/rWT+HK+jObV3d2XfvBCbwyj2u1lRzj5ritc3MkYnQj/7+30G/UQKejjmnNTkT+4
	WolJ1onrPjUQU3qy2F93zpeSR+h39fZ64j+N2wtUNR/djlGQZSiwn/RkN6YFoaopf5vp/8+nSSj
	RpFNwj1/QL+I/LHD83VlztvvYRhurjLitWZYgeeTG0yA/BP1GooOECasEWQ7ZGXJtyA==
X-Received: by 2002:a5d:5f83:0:b0:405:3028:1bf0 with SMTP id ffacd0b85a97d-405c3e2784emr5360090f8f.10.1758705202464;
        Wed, 24 Sep 2025 02:13:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBZFEPN12p6SWA1LtLwcoBT+0w/wHU0RQBUXQwTIxfVpyQEni4vEmdES/G/ydEaBnhiqp96A==
X-Received: by 2002:a5d:5f83:0:b0:405:3028:1bf0 with SMTP id ffacd0b85a97d-405c3e2784emr5360028f8f.10.1758705201838;
        Wed, 24 Sep 2025 02:13:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee15bfab67sm23593007f8f.43.2025.09.24.02.13.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 02:13:21 -0700 (PDT)
Message-ID: <17dabd83-0849-44c9-b4a2-196af60d9676@redhat.com>
Date: Wed, 24 Sep 2025 11:13:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
To: Catalin Marinas <catalin.marinas@arm.com>,
 Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 usamaarif642@gmail.com, yuzhao@google.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, voidice@gmail.com,
 Liam.Howlett@oracle.com, cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
 kaleshsingh@google.com, npache@redhat.com, riel@surriel.com,
 roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com,
 dev.jain@arm.com, ryncsn@gmail.com, shakeel.butt@linux.dev,
 surenb@google.com, hughd@google.com, willy@infradead.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, qun-wei.lin@mediatek.com, Andrew.Yang@mediatek.com,
 casper.li@mediatek.com, chinwen.chang@mediatek.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-mm@kvack.org, ioworker0@gmail.com,
 stable@vger.kernel.org
References: <20250922021458.68123-1-lance.yang@linux.dev>
 <aNGGUXLCn_bWlne5@arm.com> <a3412715-6d9d-4809-9588-ba08da450d16@redhat.com>
 <aNKJ5glToE4hMhWA@arm.com> <aNLHexcNI53HQ46A@arm.com>
 <f2fe9c01-2a8d-4de9-abd5-dbb86d15a37b@linux.dev> <aNOwuKmbAaMaEMb7@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNOwuKmbAaMaEMb7@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TE3UIIMzYTyj68mlFOPziZnGIV-U2mtt0OIATz8xDMc_1758705203
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DC635120003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: p5aeda7o8do5i7r7bjf5bp8gjrnu4yog
X-HE-Tag: 1758705205-800572
X-HE-Meta: U2FsdGVkX1/tILCrAXYeDVdIsnHGH1QCaLThvqww0FOTkN14yUQbq0ouuZMKhIJum9WX7vkJwDSD3WWSxZif79fl6AmA4hA6gJFoxLGCCyxC3LnrIMBBPkuiilNdaVvaYDAnbf7zDSeRdWEePEJ+mx+RxmsAeBlgySYPgYYNbjOFVcIt0Vh8HADph7HCfsgkLYl6G6uyZxJ34q9yoqxb/CQ7DdBt0D6JN31/flB1oOwLq7YJU/uPVWYy9A3QTwTSLu5Kii7ipKqGSzgwcbctFapb/KVRrEvW9h8lGj/SV+b1kBSZkWvARvv4sEb0ghjBoY9CrLOfOND1nGF/G06tNxXGNYeNuxOyDZ3WLwfpfkf41A0iJBkUXyppTMo8+tFREFf5toQWgKnjdf6GBuB39CbUhqfPVq2cxX13I0m4qg8WkKmJ+TGIatgLdyXMC6CzjCP6IFrpzWFKuEr0+I1zhdzkTZtbefb3knIxPw0BFKgo4YZ1JniIdcOKa6WBal9wmNWuIZlxWv8CbLvbi8rHU7y0FRNHRRpGnQJcmkngCsbj02ZCU0x98aioVrVBoB1Ib7ekW0DJ9k6UXucpx3bf5kELj1A5vdOtZAUxxOdKjoB+Jnt+5c21K2fsxSMcetBRhIWDYb6PxlQ6Ht86Hk2vBaz7Zn3Kd8kEkGAJfiVLa/2JsWQfL4PZ6eo9vOt9vofi/PsyELrbzAV6V8s6ghwpHZfT0W1b7bBLX3FSULlVZH5fiRTMh55ESj5uw/49ChWzkLB8xIVIbOZYAI564cT2I8JMK7JAJWVcagGZ0yTdwE3XlN9eYiX5LSfJ5UvVic/XtxXKC+P7RujjPIdGXJ1c5nKHYIgVCyZMKEINS9bWNrEiTFrnZl39lWnoWsM42Wq7x4SN9mWRKtbubhsPRpBXlDCaIv5zllryIGZXH7aoPzyHfBEYoR1hVVou+n1qvqHDa5756VNNjm2PRTldde/
 xBKKWMTA
 Uv0dZ3ohtHJlouLjBERGteVReaqJsSR/d327drNF8+Z73wpbKBzaH3qOhDOL7L0NzmbnNdTyArUZ9PJSdXT7cz5EiJg5E0Xz7B+ExMuchFTh89J0V0YxGSizfz6Fiu/UlHxKnp7Xkq5ZvSYXXHlNr/1TIuyPJTITAz1QRiE1T0PJ1gnf1qrx7WxOe4VSAyyHr8n4zShgogTN7i1+e9T2ZGnN7DDNBG5fOtTgsMlxmXC5cdbu5tRaluValakFId5i15jOQwTHtuPr5BQcmiI3zSbYSMzRqqKnQM9paJErWeuCQ8/ShDATxi7TaXak3Y1hjyoNsmOkuRYTgIPSjUHfUEJ/wPk39XThxzQdGcTllVU7OR88yOtLXXMer2vGve0zCjXFig2cdrq273pInad2IrdfzqK//RcR0UYIcGm82K0p4g/Vam/8tLrj/d8y4MPmaKV/PrjIwB7Z37YcaQpxyztl3cG65ej1/z2oT5sxCwu8v0eJlfuEYmPcVAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 10:50, Catalin Marinas wrote:
> On Wed, Sep 24, 2025 at 10:49:27AM +0800, Lance Yang wrote:
>> On 2025/9/24 00:14, Catalin Marinas wrote:
>>> So alternative patch that also fixes the deferred struct page init (on
>>> the assumptions that the zero page is always mapped as pte_special():
>>
>> I can confirm that this alternative patch also works correctly; my tests
>> for MTE all pass ;)
> 
> Thanks Lance for testing. I'll post one of the variants today.
> 
>> This looks like a better fix since it solves the boot hang issue too.
> 
> In principle, yes, until I tracked down why I changed it in the first
> place - 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to
> the zero page"). ptrace() can read tags from PROT_MTE mappings and we
> want to allow reading zeroes as well if the page points to the zero
> page. Not flagging the page as PG_mte_tagged caused issues.
> 
> I can change the logic in the ptrace() code, I just need to figure out
> what happens to the huge zero page. Ideally we should treat both in the
> same way but, AFAICT, we don't use pmd_mkspecial() on the huge zero
> page, so it gets flagged with PG_mte_tagged.

I changed that recently :) The huge zero folio will now always have 
pmd_special() set.

-- 
Cheers

David / dhildenb


