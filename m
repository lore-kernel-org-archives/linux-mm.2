Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AED9CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 07:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 606D18E000F; Mon,  6 Oct 2025 03:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7298E0002; Mon,  6 Oct 2025 03:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A59B8E000F; Mon,  6 Oct 2025 03:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 398898E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 03:00:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C25361404EA
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 07:00:46 +0000 (UTC)
X-FDA: 83966791692.14.7458FCC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8AF10120011
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 07:00:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VDSPMTDM;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759734044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FaGnOp3nPx7VlCT4vqkGBWd8zmqUqA0DpAI85zD6jQc=;
	b=ekGJ2uHdSSe+OakUivzsrDm6FdWyQ8ETneab64jM6eGFw0d2ZDhoh2a2gmsVWn17VrQL5S
	XoL7SpEUCM6eeGCFtZ8NSDYrT4ojV1ijSZgOno5rbr8NpoURwGRXqcF/W1/RMsQ4/xSDnE
	OKL1zKE8rSG51NTrB1ccFn+TdaNyPEo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VDSPMTDM;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759734044; a=rsa-sha256;
	cv=none;
	b=KecyiyHKr/5bYT9Jw4UQtqjqJY8/VxJhPQ7UUFHgl6LbXB97eztMCiAoLqFK5pMd2uKcK2
	IFjxhFBXLYvsm31iSb5sCjsJRR79KzbWx8x7Y1FUofzo4MoMzb41sJVGdBWtGRGKN/yuFi
	dEzPVooEV+o1jAwqW6AgD9wkVwLFAtI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759734043;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=FaGnOp3nPx7VlCT4vqkGBWd8zmqUqA0DpAI85zD6jQc=;
	b=VDSPMTDMFdcjMGIsjL7Z3KBA1/yGxpmUPn/rl31/lJpOcXzUCQepCd86kBcU+u+D5osOWY
	1LBKm8BewYpNV9wRyoaXylWxoKD6ejlRhb51597aFMdjb303i+140lYL+Rbi8PLbtO8UMs
	LNkmQt/Zpj0Ke1pHGAgW7Vm2vNRInCo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-vMLkHqGwOnOvn6lIPlazCw-1; Mon, 06 Oct 2025 03:00:42 -0400
X-MC-Unique: vMLkHqGwOnOvn6lIPlazCw-1
X-Mimecast-MFC-AGG-ID: vMLkHqGwOnOvn6lIPlazCw_1759734041
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ece14b9231so2426083f8f.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 00:00:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759734041; x=1760338841;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FaGnOp3nPx7VlCT4vqkGBWd8zmqUqA0DpAI85zD6jQc=;
        b=t9P2MHZV37ccTPjP6sIs23ZDdT0L2fQQ/79yd8TeHscfvNKmkSUETAAA7g5eleMQsA
         IKlv0P2doXKeV+7mv3doeyuud4NFdANHsr7lift7jpa8YdFTO+J+mWZARWzKufjtxT2I
         WTpvVPd05BpKeexEIIMZTHU3ktYP/bxZBx41yIfPKCvew18lse9oLn4YPIk2VkJZ2yLY
         JuUqymdzkd/MlAv+CFtvkb5mtlCxIT/GPk1kyPLJUGGWJWgu79w8KZIn4/P7SKNGfMKZ
         CCHGbaoUyIHLotXwDMAWYMCE0Kr6l6sywdl8RsG4Ye3F8oF0S56pkcxRevkCWa4mvApT
         ehcg==
X-Forwarded-Encrypted: i=1; AJvYcCWQC+5Mjkrufu8kQhJD42phwHxl1GH3nD43X8aP8/V31r3foZvl8k9vgvm4wkHBJ8/zSv2MovWAIg==@kvack.org
X-Gm-Message-State: AOJu0YyaEeDJpMMj/yAaB4LKPds9T0dwSh5BPM94/OOh9+9Hx2K3udzm
	tYKCj5YWEiB/T7WCW7idC2K9l73o8Kcvww0FvQD21QO0Xa/PxJ+HHsHodOSczcjd4ObK1WatoDE
	cgLRMIKwBzqgNOx01H9ml2bDKIESHGeRVYT37W7jlpPhW8Ed1dUhp17+fDVd+
X-Gm-Gg: ASbGncv0xi0BN6vOSHsUTkTKn527HBuXh8eQzvJPUl7UhnnN4lPs7eLae90acwzKr3c
	ICayoAZ1kVJj6EC+XHwYd4AKD7+K95VjBwiaNf9bwPlV+f8oN43eeu2SFGKKUGgcxBkpGW3x/fB
	7qPI1EEkdqH0muVPbFbPwBwbE09PM7MMHxzD9eu8ApUkbiznSkSBfg5OMPcNS1Pnw+gyTo3d5SZ
	x8YX/nYpHssBmqJu0XJgpMdjPjPtbcOXftNigovg8uZqbB5S7Z3BzxOKgrhv95qP7keWZdLIcUm
	1L4K2Fnc7rel6WO2mkkixHa30TMinxf5a8DEsomzKOaEf4D3OtM/FF96B78Ot5oRRrYF2NJ+4bh
	Cg6htLOUs
X-Received: by 2002:a05:6000:2583:b0:3ec:dd12:54d3 with SMTP id ffacd0b85a97d-42567176351mr6653603f8f.35.1759734041254;
        Mon, 06 Oct 2025 00:00:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJyRXVvWp7lKh4Mm+unXiZ6Z1ChboFVCaXHpiuwIGkUUAOEzvDQCLfW7UG3JyfvMv7UXnJ9A==
X-Received: by 2002:a05:6000:2583:b0:3ec:dd12:54d3 with SMTP id ffacd0b85a97d-42567176351mr6653575f8f.35.1759734040777;
        Mon, 06 Oct 2025 00:00:40 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4256866060fsm14171223f8f.14.2025.10.06.00.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 00:00:40 -0700 (PDT)
Message-ID: <65f4f0ab-e6ce-4419-9eff-c82befb6278a@redhat.com>
Date: Mon, 6 Oct 2025 09:00:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/dirty: Replace READ_ONCE() with pudp_get()
To: Lance Yang <lance.yang@linux.dev>,
 Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20251006055214.1845342-1-anshuman.khandual@arm.com>
 <4b513d32-7795-4998-98df-d398c3d5462a@arm.com>
 <1c948262-e201-4473-b156-8b90fedc9ce7@arm.com>
 <CABzRoya4kGWCFL95B2NEoLk4Qk9c3Vs1694NSWPFhiQiFHyomg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CABzRoya4kGWCFL95B2NEoLk4Qk9c3Vs1694NSWPFhiQiFHyomg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BIrnS86sZwKj33Oyo_xdDvcKbXcSEDGEJNsMDymFYzk_1759734041
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8AF10120011
X-Stat-Signature: 7nbhbf3f8ptpokqmee5gbnttagmpks3s
X-HE-Tag: 1759734044-407791
X-HE-Meta: U2FsdGVkX1/qkz/R01oya/zNj3tB22d5qSjUmmmpenR4W+pyw9v8g3tJGuaddeiBpAcAg+FIfzBTPsyWZsY7qcGUOVXX+f1UXFRAW1lzhabNi9D1p81NgsVkxbjvsYvhP0hTBtcHSDczgs+bhKKil1WDUsGLGo0smy+K/1GT7jtSCJ74DAHf66ulKAUp+X9/vTUcDutvhenqkXTCSyBrTU6JzHtFDyXGJnlSsl9OKTLxRXQQj3Ul+8WL8PB2lMPRHMtfQS034yl9xvb4nzqbfE42VeaIBuJ/E+mwOXmZLZ+elDhTYB2m0ukLM1fksC4X00KtMRnKvLpBc9cQxBEjcps8ju3puoDtMbSnNNvrAXidEBIeOsBRUsIAO5ykW23BEO9u3/ZIii4TzuN55GXZWrUUm8qLQ3QX71DbDvb0UYA3IOS0Ci9FUE52VFPKVzvAdvsFXD9mVpQzPfxTdM/F/cBXRl+e5rwKmHpjuxDuzwnIWgkAZHI/5N87YMn0BA7H8ppvUZUXQEXsHY14dRdX0DPOrmW4nyRGJymDKV5Um7QPwWYp9qWEnmBbKGkBUd89Hp6++im8nmV/ln4/m9Nok3uHrzoNKErc7TF1TLZ27qmh94hnuHGZEFmz9G49rpdyoNzrdsSSQhUIY940AFwQxoolXnwAAiDMueSZeUGvuoNeKPlINtjYuDZXu0tFtjyNia3g7hhQeOf4O96HD8X94GpkwoSOn2+ft5Y48DeBTwwsBlfbZo5b/ZY79i0ILJOWxMGWUTjFf0xPWGMlGTKEgCyQPZLavyP4a1lLAOr8V6qFkutNS51stI+bcGfy0SkS5ipJj8IW6kjZdDSv/VYsD/Slpbku7pfuhfHURJNdF9pSFJmHE/eUyy+Z+d/6I87IsPr+z3U/UVIEX4iXCBWBxjwG7Oo1r01HKYZ3nwIMRRvtN8zp+9Oq1G7lkT7oFdUUcL3GHlJ9H84Gdrly7Vq
 F+FtkYaQ
 HgLdElhhWZP70P3+LQ92I4V/UoGey9yBP8AVv7wpZZhB82B9Une30Jx1jMqPV8xG1jwTfWe62/FXBfafCwGgAZJ9gY+lEzNGVHojyiwoap5qyxdppkdwe70VdsdDLJENYSbyk67zpICoNBPxk540fkgBHQgoz1/y7p/wB908IbD1fVrjWkJOfaLx3gBNgIXqfePmfixnAUWFx7yz6Oxjr18KDZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.10.25 08:48, Lance Yang wrote:
> On Mon, Oct 6, 2025 at 2:28 PM Anshuman Khandual
> <anshuman.khandual@arm.com> wrote:
>>
>>
>>
>> On 06/10/25 11:37 AM, Dev Jain wrote:
>>>
>>> On 06/10/25 11:22 am, Anshuman Khandual wrote:
>>>> Replace READ_ONCE() with a standard page table accessor i.e pudp_get() that
>>>> anyways defaults into READ_ONCE() in cases where platform does not override
> 
> Nice cleanup!
> 
>>>>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>> Cc: linux-mm@kvack.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>>> ---
>>>>    mm/mapping_dirty_helpers.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/mapping_dirty_helpers.c b/mm/mapping_dirty_helpers.c
>>>> index c193de6cb23a..737c407f4081 100644
>>>> --- a/mm/mapping_dirty_helpers.c
>>>> +++ b/mm/mapping_dirty_helpers.c
>>>> @@ -149,7 +149,7 @@ static int wp_clean_pud_entry(pud_t *pud, unsigned long addr, unsigned long end,
>>>>                      struct mm_walk *walk)
>>>>    {
>>>>    #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
>>>> -    pud_t pudval = READ_ONCE(*pud);
>>>> +    pud_t pudval = pudp_get(pud);
>>>>          /* Do not split a huge pud */
>>>>        if (pud_trans_huge(pudval)) {
>>>
>>> Talking about mm, why not also make changes for these READ_ONCE accesses
>>> in gup, hmm, memory, mprotect, sparse-vmemmap?
> 
> Yep, I agree with Dev on that one. Because the change is assumed to be a
> no-op on all architectures for now, right?
> 
>>>
>>
>> Right, could replace all mm/ READ_ONCE() for pxdp pointers with the pgtable helpers
>> but that will create too much code churn in a single patch. Thought of doing these
>> replacements per file will be much more contained which is easy both for review and
>> testing.
> 
> Emm... as pointed out by Dev, it would get the entire cleanup done in one
> go, avoiding the churn of multiple small patches ;)

I think I'd prefer smaller patches here. For example, the discussion on 
the debug PT stuff was quite helpful and probably would just have fallen 
through the cracks when blindly replacing all READ_ONCE.

Having that said, combining some simple cases across multiple files does 
not sound too bad either.

-- 
Cheers

David / dhildenb


