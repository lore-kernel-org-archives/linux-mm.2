Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38CEAC44507
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 19:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7336B0095; Wed, 15 Jul 2026 15:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AEE86B0096; Wed, 15 Jul 2026 15:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C6386B0098; Wed, 15 Jul 2026 15:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D43E76B0095
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 15:59:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 657E01202B7
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:59:06 +0000 (UTC)
X-FDA: 84992074692.02.83AFE7A
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 987451A0003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 19:59:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OPq56Wja;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784145544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IV+eVU/BHEvjC83dTcoXEiFif2QrI2TpFVMZfUeCzig=;
	b=nOToQtGnmJsIn2e1xDP8MdSWy/nZry0R8bKx9WKFQlHl0dfOtMw/IM1O1Ro/GIxN9K4InO
	Iui4nSKHhxR/pggERQK570rw6dfJyzMsaIqz9ZAtzS0IofV5+ZPcXZ7mJV2i8UbFzPuD79
	dPZXTF60nFtYYj3a/wkBEvqDpNvRmEs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OPq56Wja;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784145544;
	b=wMosqlIgc9BtHzCVwDL0IQ01/Zc+QG3DxxMl6WMubvR5lT35ZG/oEcTfJ0g7iDdCS3aKwG
	UaEASyQuK5jbAStOcRC6rp0EXR9PYVfgPUH4BsIX4Lu+P4uoaCRSdgH0g1HTwvICg+cUhS
	5wMlSHwNZaRDo34JnKp7HmLZxQfL3mE=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2cacef7d299so2775ad.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784145543; x=1784750343; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IV+eVU/BHEvjC83dTcoXEiFif2QrI2TpFVMZfUeCzig=;
        b=OPq56WjaxaGilRzW/JRoTWEQNS5T/sMwyqUMqmT5hDSHFkzzJLythGEMIGPhlzSqYi
         qsWhOxgCfSbdqKwsEyhG3qL+/tu8bbaPx3ZpvSyZD/BFf5l+PV1OvkF313AW7ZIzCTyW
         R2Vs/1cuU66i6UgRuQown5IaCrWBp6etNjHxGIHWbFfGr8KXbFWqX/XFwF05pSq6pSK6
         JiW4AgfwDK5rj9aWWBxDSERBzpDfJfbMpCT8CmT3SHfr0cP1UWtbNYoD2SUDLDkZZz52
         kGbSWMpNOfunabQ+Yvc1FZGXK6Icc+DJ5RK2iKV5OnRk1hAaQK7N3A3TAJEnM9T+/L46
         xegw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784145543; x=1784750343;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IV+eVU/BHEvjC83dTcoXEiFif2QrI2TpFVMZfUeCzig=;
        b=reqAE3A7P/C8USTmk1+ZZWnuApMdyto5+qQ9rZy9vVKR9IC/tr7s7qAWGCdfhHiYPw
         2iuS5n7jdipG/7RwwSsOKwmaosc0nE2KcuAs8ign5f4+9QED/MbIjGkmf4y/nUJk2fIA
         31Spvxcc8KnHWCUeI2H1sYcpEPG3zbocCtmqXKpVx/avFD488UGxu3AEfOd1XVUHRn9Q
         5afCwCvKjPL0ntYCOWLvb2nQqggVE57yWygO6SPRIOWxTdlQMqfQhp7deK9STVEdFwKb
         HS+apGRhxjVEG04GuZgvc06NJIcgVhQIh/x66W08LyczWnVoCWAbMZ0FusFlKXRR2rxr
         tc6A==
X-Forwarded-Encrypted: i=1; AHgh+RrvpeLSszzcY1wHeVzx0TGkmK7mHyqfmQsCKe1diCmXQ8czCGUUf2x64rbJkf4IDh4XI1anyTT2NQ==@kvack.org
X-Gm-Message-State: AOJu0YxhVCtdrd2uBEHvaTG51biWEa/12p4hD9y6s8OAmDcNmICuSlIt
	ITXaDLBP5wpZBngWeZJRNycwmGA3CSyqi0OsaviS4lXYCd829FEM1RiWxtdqQ2Zn2A==
X-Gm-Gg: AfdE7cl2Nwji00+kwVZNXcjYHSlAEpX27VNYGY1oBMQG2zOv0OOdZBoteISdGUC8iUy
	yXMkWiMVycGjcms1Eyl7V+PCtGokO1OJUndZQ6Tr5HcPlsXcm/aAP72NpvaY8kjnviT5qr34AXd
	qRhZBbzOCN0OuS0h58oj00JvAZnrEJy4WoY0Yme5QCNVcuEJo2mU8Z1bQkXa0zaQzfowhWFhew/
	0Ye9JXYUrffzydLe++GobDKOfBwJRRCpaTb0wjtAAjpEVo4MMyynDMED6No1IUlSh+Ba5mErOwL
	Ms7UyVnZQJ62GgMak3i+H2W0vbfU2oemPZqFGaZWwTgy7Ren0rlIvBRJolMyIlIu2TFT0pPCI9d
	HbYEyXY0aKS0X378n+QBbPV1jSX79VwDil7HVld/Jp6KSNoc1Dk/qUVowgg8kPEab8qk0Ky1Agu
	CD/03zqNJae3H3JFcmCHbp5N4S0u2FkeVYwH86yguF9Se2dnFF7BbIyRZDSsfNOpsJSYILg4fHx
	oDXa8B+hYw=
X-Received: by 2002:a17:903:2b0d:b0:2c6:cbcb:bc72 with SMTP id d9443c01a7336-2cf1abf6570mr468465ad.23.1784145542863;
        Wed, 15 Jul 2026 12:59:02 -0700 (PDT)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e2a06182csm807385a91.0.2026.07.15.12.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 12:59:02 -0700 (PDT)
Date: Wed, 15 Jul 2026 19:58:57 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, 
	Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC PATCH v2 03/10] dma: contiguous: Add API to check if an
 allocation is from CMA
Message-ID: <alfmVTYNgoP1GHQY@google.com>
References: <20260708234854.4044652-1-skhawaja@google.com>
 <20260708234854.4044652-4-skhawaja@google.com>
 <20260715062116.GA21348@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260715062116.GA21348@unreal>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 987451A0003
X-Stat-Signature: 6fkzetdrjd6ap7qmjsmw9ochwtc94nzd
X-HE-Tag: 1784145544-190786
X-HE-Meta: U2FsdGVkX1/0KWC3fBvP05iTCcKDnYvHScXbDRykewlnakYzYhJ4R2NvvcAn6AndVgi9URME3PG1RnGwPU4tfDhLLWzP9ykDXouApnX8oR1ZHdiF/mHV0UVcmeueGdeasIXu4c5JkBwHwJsuo8thweWcxyC2B7k0KraA2rkKHMwpN+7ludjMmWOCeB8NAyq4YeYBcUe9oYZmUTRYRaWjFAuoSkqw/I33UzlIzQwbZicHKLVGSvkRfHAtN6Fy1PMoJxuTtRXsstEtuaDPPgbc00SvVEJGFy+SzIhjojJdIuG1nU5rT4mxZSvlhph2BRamo6Ct3upg8id5CNbLO2dIhOwTJSFB+tD834HP73CpR8em0DXEGJCpLiPbpJYCte/8Y/P6K6omokAgmcQv1i1HTDKFRQkoKLzkutBcg3owj0UcOrEKXUcIYrsuosQh+TXWRjlden4hPpR4qOq1C0dHqRGua7FDAevBbvi3oCHPsOLPdAFNxF3QIBx03sYyXEXA9EMuwBKrS2ubx49aN6786tx+MMOOEB/7aVHFPVu5OgIkqxxYr9yCU+UMEnsSiyTH6jao9GennzZrfcAs1PFUKYczYRe5uuLTv/aGV9yRQtfmY7CQdB8R4Clmkm2U7pwQHh8uZqxV8RaSBTaNAmZtxJGHtZk2O+1OFu69rV3GF4TdZVu+dkHWGups8/844qovK3SFhfIINf4Xa2u/5RxUuHmkdcy/kLfkjxullPQlplViiq0ur2wFWh60UT6kTivxKcfEJyWGu/Io/v7ZhH4mRN/gS3gQ1MGt+qNsng3Th1JFXW8aDMLmo8EDEdvTOxYBj0ohb9cfLLbQlFJwJ3bQFWSSnTSCHL6hegk1qKMPFf2iQgi2R3USQdGoUHCiZEj8JSJsPvIOScORvtVPLQTN8I1ZTM+eO2QWm16kC5doplQI43rCOSjTQEBgY4o+NZ7ofmN2A92jIuEDpybO3KZ
 PlcxCIDH
 BctqCIhNgN2gYoJDIyse21NrgpX4T8Rkj8MJ2Xb21XPLhEy7i/t5gLm+0ILoz/J5S+2fo/tGPUN4CbmFhss6JlhTZgKq/CB5VIMiyrwWDgHHK93oBkwIfhFDjgnVBg/vXI7eoGrs+DuKsCU7t+THABt0GZRBV8OlT/sIkSUpUAC0tZpS7/rk3s7lIQdxbPTsdky/KV8UjYbIGqmKMQ82T9dCkMbi5e4nkVSys+nV0dJvQ0nwLWgLZ/dd5qj+1cckZBpN144y+9XNG+4/oF+wIP3ujhC0YkTVIHVPBOTSGJQK5+5bZ7/zJoT8hbcdTQFiR+tXpxpa6+fbk/QKRi8C/lYiFHx07gnrLdKvCGumoQhfyDwlKP/soDyvtYSbs510LwRy2oG9HIk7xerbkq7o2L1REkbZn3sAf/Sn8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 09:21:16AM +0300, Leon Romanovsky wrote:
>On Wed, Jul 08, 2026 at 11:48:47PM +0000, Samiullah Khawaja wrote:
>> Add an API that uses cma_for_each() to check whether a DMA allocation is
>> from a CMA region.
>>
>> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
>> ---
>>  include/linux/dma-map-ops.h |  6 ++++++
>>  kernel/dma/contiguous.c     | 24 ++++++++++++++++++++++++
>>  2 files changed, 30 insertions(+)
>
><...>
>
>>  #ifdef CONFIG_DMA_DECLARE_COHERENT
>> diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
>> index 03f52bd17120..0b1702bf39ca 100644
>> --- a/kernel/dma/contiguous.c
>> +++ b/kernel/dma/contiguous.c
>> @@ -130,6 +130,30 @@ struct cma *dev_get_cma_area(struct device *dev)
>>  }
>>  EXPORT_SYMBOL_GPL(dev_get_cma_area);
>>
>> +struct dma_cma_check_data {
>> +	phys_addr_t start;
>> +	phys_addr_t end;
>> +};
>
>If this series is retried, use "struct phys_vec" here instead of
>declaring a new structure:
>https://elixir.bootlin.com/linux/v7.1.3/source/include/linux/types.h#L173

Sure this sounds great.
>
>Thanks.

Sami

