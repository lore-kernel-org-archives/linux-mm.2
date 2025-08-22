Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 069F2CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 06:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2BEF6B002D; Fri, 22 Aug 2025 02:18:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A039E6B002E; Fri, 22 Aug 2025 02:18:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2636B002F; Fri, 22 Aug 2025 02:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D53C6B002D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 02:18:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA71FBA6F9
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:18:49 +0000 (UTC)
X-FDA: 83803389978.30.D39F4DF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8CF3680004
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:18:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OkzQtCvu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755843527; a=rsa-sha256;
	cv=none;
	b=pN8ytDYT7Rn+O2T9Hf2QJE6W3pQzJPjHmYdZn4On3u2lmytUguSsUuHo1FS5+6fMp8K30c
	BCbE87xTAngjixgNkiMiBWECDW6uCfhinJsGVn38dvWcssYVFTvcih8aDfIrwIf/5iRwNu
	0Ok3ODKEqLc6CTyjDIO3iMphtWDGUZs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OkzQtCvu;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755843527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=niXcAgzmbCLTQjKBYxU2ktBBprjtNy5MGdyac9sGLRc=;
	b=tSAUuOdtmI9niAqTDFQJLK5ERzI4YrvX95/ZKjfffukK5gO2oDbGamO3CBx9l3+jA3oZ7K
	LolLuESn/ZcEwa+q+3TioEL6iKB3/EIMNAGnP4TziuzaqOJsAIzRd+oxONT9uC2gMzJUK5
	AZkXlUo0nBqn2PRD9fLGBDl1gpgZR7w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755843527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=niXcAgzmbCLTQjKBYxU2ktBBprjtNy5MGdyac9sGLRc=;
	b=OkzQtCvu9K0jp5DStkMTdwMA41eVci/U5ckfSs6Qy3WNZ1I0HE989EckcUIH9KSIF0R/Yh
	baOXVdPAZU9+LBdZ62c3QXJXS1JSk+N5QQY6jXOfFX+gKhIKnV7HNP3lzC3ysQgeGfZQ7c
	GvLABDi6HOkPsA2Ep9awNdNGhYAdnEs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-jFtBsjSRPIiTCvxuXEdhaA-1; Fri, 22 Aug 2025 02:18:45 -0400
X-MC-Unique: jFtBsjSRPIiTCvxuXEdhaA-1
X-Mimecast-MFC-AGG-ID: jFtBsjSRPIiTCvxuXEdhaA_1755843524
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0cfbafso9826695e9.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 23:18:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755843524; x=1756448324;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=niXcAgzmbCLTQjKBYxU2ktBBprjtNy5MGdyac9sGLRc=;
        b=eYWL6f7tPKlndZPMeUjsop/BEFtDNa39atoqwUQ5wzCZVd6roXCBcSlc2CXnlxvlU6
         quqrKDoBCkCmZwEMWYq3WDKdvUwK1POGKtoFUXma3VimkgisIumIu2agm8be+VDbMJME
         exwMu5aXfhLFdqO7B8D01m8FdKN7bvnAwr/Iz66flxIYGWSTYunxpcpk5T4IEfPjRNBM
         AnmIIJiPwowfpZlGV9a7rLnwZjGr9OWJP/SLb7otMTQKvS0EiNBizN4QTsSaC2K+xb8C
         ue6ZK6Gp5n6qbT/5S88ATq2FiNkX9Z8TOgheLvFSOYaYfAqcf6HzwS/pOvWBysAp0dx+
         mfIQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6pKKMhbOdtNwhggTJHRWu1EoGDVsnZRiRdYZAC+k+Q3LOefahiN++I0kPSBXqUgQvERlmt30zjw==@kvack.org
X-Gm-Message-State: AOJu0YzpcupMH0A5DPdkFcEbVUo/w/qFzLNPGBwZzBeLkssXuNnF63wA
	B0WIiNX4VWh+PiUSoCdkQVibRP4nAtwrMtWEZ65Imm53ejfkcqWpn5+fsZqG1ruJUOzzzfvXOmT
	7GL2t64dTQZO81I+ONwdr4bN0hbIZ9mTC+xCxEvmhutGbiI4Uh72L
X-Gm-Gg: ASbGncsP0bUbjBgQ26DyH2CRQEQCFViYj9uSL4CVYe3LHF49SBsuj3MvguuInxZRjHX
	NkS/yjonO7xXDLPyunCKb1Qrmy2aRvxlwlFSI87GJRnOQNPyN6O1daLh08ma6ZqIuMkJWQ309Kw
	Ar+2uz5Vc9VaBEbQQ2pKUL14p81rgkq84DV8wFOw24MrpwgjYtB/KpdNQd/Fm/jMHaZHeRUmcCD
	UK1H66Gxl9JcbDxWdF+ZE2V1JGm8V5uY2W/L1dH2xj43NFlTV9h3jZjQckZhdBHgZPA5XXWtpLS
	0Sv/Vw2p08pKP+01AAeRYTsLev8vNbC5Mmrzr0FD8Z4UYeawan95+YgF4XLVrFN1nbELLQ==
X-Received: by 2002:a05:600c:4e8c:b0:456:1ac8:cace with SMTP id 5b1f17b1804b1-45b5179e7e8mr12435745e9.12.1755843523915;
        Thu, 21 Aug 2025 23:18:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdnIqi4Hq3cqdHCtXLM1BskgbP/iNxi6JCTe3b4/5WxUiRcTB1IoXLbvfQ3J7NKdKWtFg41A==
X-Received: by 2002:a05:600c:4e8c:b0:456:1ac8:cace with SMTP id 5b1f17b1804b1-45b5179e7e8mr12435175e9.12.1755843523431;
        Thu, 21 Aug 2025 23:18:43 -0700 (PDT)
Received: from [192.168.3.141] (p4ff1f25c.dip0.t-ipconnect.de. [79.241.242.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b50d62991sm24078285e9.0.2025.08.21.23.18.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 23:18:42 -0700 (PDT)
Message-ID: <6bff5a45-8e52-4a5d-81cb-63a7331d7d0b@redhat.com>
Date: Fri, 22 Aug 2025 08:18:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 24/35] ata: libata-eh: drop nth_page() usage within SG
 entry
To: Damien Le Moal <dlemoal@kernel.org>, linux-kernel@vger.kernel.org
Cc: Niklas Cassel <cassel@kernel.org>, Alexander Potapenko
 <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-25-david@redhat.com>
 <3812ed9e-2a47-4c1c-bd69-f37768e62ad3@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3812ed9e-2a47-4c1c-bd69-f37768e62ad3@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KMA-GWzRJSomNY8kQoBOpBSSFco_1IaF0ctVBGF_3Ik_1755843524
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8CF3680004
X-Stat-Signature: wnif57thgedbc9tbcxydbf5kdroo1yxo
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755843527-993639
X-HE-Meta: U2FsdGVkX1/IkooezdtkQoyR8NCnomTSGCA6DjBYJoXWQDgpoqAzdeXX38aSQThrGY1+Wbnaf9xuk1lFshMxKKbLYLUQ1MtQSqHvBcTJIZT7eqyK3rM42dhaabNHJPKJp1B6js8JTHxNWvTXJCJfkrLiqWA+ir8MBfVwfJAK2O4gng8ln4ya6AVf65xFV0LJ47D7vQiCb6ciT6Sgii2G1Zp/fsaCohG24bFNebbwk5nRTuQePBupQpL10ZBPrmTeqy1VHWlPQkEmgsEA0hRUTUOPJfjQ05mnkg6vWIHBKkpTtYjfsxRzk8qnUAIB3nXtYsLHXeGt9SSUNiy+Hlhq8vsjghr+wClaYGx+oJBfhOV0Ht49ebC6TFB7xdzOrrg+i95Uta047CS4uD3vi6FuweRnSQSsTvuhhIsMdMWvGVleCHAMTFSHj/yMvPMmyQ4wEopG2DmIucwuAWwB9fjZxVisgdBYh3A6S6qfSgGN29zWQEqnU50maqFDAdvNdwvjDxmpD6cmnXX16n83Ff/dwYG6yZpvqFUd8J0ovVjvrP/OjMrE8w+1PW6jHrlo3GOU9zzBWQk3dbylvBQQB98FMoHCVp/D/m8w7cr3x6sANIi2Gj1sCdXMga3lFKvox3UatBPkID5ObfHTkqlUBAGPPdi7QuaCYUj4t33sln7eemy16/dy161vO1z4+Bi7abW3mry48nVThv9Jxleo+b/XwE3bFnamXC9F8C5HC+5Yw/IleBwhO27N2d7lDjxokDnDPc4F5Wk5FPY9osgLJPIaMPha8AAnYRiCdimriWTtZxUD3Oq2bV3b95upt3LIqHOx99EDluZwuLD0xQuj88jXKjHT7M8YWOIZjgrtye07i3wfYeRfb3nY8+HeUmnjEGMVO5KwGHhLnOibnb2NZU+P8mEW7gbRgIjfTIwODyJAI/oIjK3TXa5xjANxtI5x/aobpmNU7Kl4Ymab3ofPejg
 WYD6HH3K
 Eec7jpQKBD9OT1QdE5cLkJDIt0sk/PkovoACFlC+Rah+iRMQSsyE9dVXLheMxiCRMJawarqhcxzNTC6Z5HfXVGGrcag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.08.25 03:59, Damien Le Moal wrote:
> On 8/22/25 05:06, David Hildenbrand wrote:
>> It's no longer required to use nth_page() when iterating pages within a
>> single SG entry, so let's drop the nth_page() usage.
>>
>> Cc: Damien Le Moal <dlemoal@kernel.org>
>> Cc: Niklas Cassel <cassel@kernel.org>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   drivers/ata/libata-sff.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
>> index 7fc407255eb46..9f5d0f9f6d686 100644
>> --- a/drivers/ata/libata-sff.c
>> +++ b/drivers/ata/libata-sff.c
>> @@ -614,7 +614,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
>>   	offset = qc->cursg->offset + qc->cursg_ofs;
>>   
>>   	/* get the current page and offset */
>> -	page = nth_page(page, (offset >> PAGE_SHIFT));
>> +	page += offset / PAGE_SHIFT;
> 
> Shouldn't this be "offset >> PAGE_SHIFT" ?

Thanks for taking a look!

Yeah, I already reverted back to "offset >> PAGE_SHIFT" after Linus 
mentioned in another mail in this thread that ">> PAGE_SHIFT" is 
generally preferred because the compiler cannot optimize as much if 
offset would be a signed variable.

So the next version will have the shift again.

-- 
Cheers

David / dhildenb


