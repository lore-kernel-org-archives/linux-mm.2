Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C4DECAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 14:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F022F8E0029; Wed, 17 Sep 2025 10:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED9BB8E0003; Wed, 17 Sep 2025 10:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF408E0029; Wed, 17 Sep 2025 10:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB6828E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:26:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 814DBC0577
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:26:14 +0000 (UTC)
X-FDA: 83898967068.14.2222FF2
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id A3C4E4000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 14:26:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=KCGzWI84;
	spf=pass (imf11.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.53 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758119172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10t2Z6sgnABIAwDZkTB26QdFfX0ldYEILJpBIALC4NU=;
	b=sY0cmPJa01wzBO1LrvAUa7KF71oPYrQEy5w/ynssp9qszUTJ28AvfHG0/YtJRnP80P6SCS
	1MmaOQuvlqbxTFx64ylIFKeZwDy4m9f3ftUgTVlDPfVJdwbSmYseGEOgGWVTjhvNTzpj7D
	UOEyG026d6prJ/ON/Tnmxmqur/GqHgw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758119172; a=rsa-sha256;
	cv=none;
	b=X1MhxtXZqvHs5tx6kznB8Af69QEC4pyzTCQFJLZmeIWgukJ7h0Br1Lcw50ABh6W9m44MoC
	+aZjz1g+O1XyPfPlilBlBFv0Qr36PL/fsbV04+MB6hzUixu6Jbh3c2ReoXCDyQByAVsmPq
	mUjzMiy6KPPUOrHoqovpqixQfRdSFvU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=KCGzWI84;
	spf=pass (imf11.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.218.53 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b0473327e70so546563066b.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758119171; x=1758723971; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=10t2Z6sgnABIAwDZkTB26QdFfX0ldYEILJpBIALC4NU=;
        b=KCGzWI84/PCatfyaGVpN3tVDeCX9LDoBdRmC+Vg2MRIulRTi5coznHHoYh05VGrwfs
         yK+QZeWZiV5THABMH0EC7JJAgomIuFuqOOf/Ky033MhJstTtOfyk/HSWvF8CEqPzxVvg
         QAW5pDCKH4iVgyCizmJiVPTxRdqPTgF3N7NhqOY2L5WMe6Xrs8n0NNairjsMNMTg/iBT
         iP920ObePETxwFhIcp4XwBTSGx1t+LCjaamLIg6D6yvF1fFyU1dSCn5uSW7uhszUhrQJ
         /6pQTJJ9G7D8siv1A+exbQx0xLRMaQLbHrv6f0bDJg9bOseChTM1JiseNZsMfgs6ySeq
         hFzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758119171; x=1758723971;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=10t2Z6sgnABIAwDZkTB26QdFfX0ldYEILJpBIALC4NU=;
        b=NUGmUdYSO/wuz2V2RwnBJZINAUTohAggn6Nnz5k/eUh7cTAQT9YPaUQyTuDml4c1S0
         Y9H5H9LzrUip8Z3fZJEAPDvPps/Y3zLey17Z86S/aTmRRflbVdm700hrPp68kdqwYlrx
         no+NKgKexiHQRGccghMPII3EKxdpAmeaMgGFfNm5KtgqA4zs4jtGGdje4UCsF6CTvlwQ
         jf531uLptGsSA3lIjnw/5i7vTt+bGJMFAToTKuETUt1CPpq+6/AnKoNHsNQ+gCbLCZAv
         fJhTRW/TQGdQ5Q0hfKVuDyf1fYiiMo/MgzYv0ncaHMx5G/T/D+GWPhl0mls9DEXGRCjh
         jy6w==
X-Forwarded-Encrypted: i=1; AJvYcCUoi/A/gEJts+wTUmc2VSbB2zjKgC8wXvBiFSxGtug4QUEaJH3OPNq4fFmMx4oJwQEq/immav9Oaw==@kvack.org
X-Gm-Message-State: AOJu0YzgBODiZAQkFax4QR9xjKHB6vpfm4nm4DRCLHMe92wn98Mhb7f0
	W66IFGsBmFxTBYlcfbMaiU9lPGNlPSER5kxhnpGjL1oHMpAB0F3csmU3VY8LHO3hptk=
X-Gm-Gg: ASbGncvv4U0MXoUWy1GBPsuFPNdLNvIRjSbTdRhlRMNXChvij+/nOECX6jmtuZ1dICG
	rIdWru1G2Bl/iyJ89E8SQkTcn4BoO0G9tNHnKfC0HNwP0IcTR8pEJyXSiyUIbi9RRC1h4zrOfQR
	2Y9Kkr8jPhGkX1zVCznj7oV8ObMLO5caGHmRd5MQrcNvInEO7u/gI+JaNGTXKGbCx7RzbNjQ5yT
	FYyA1lZIIlVAjo9cVDuQ1+Ymt5ddC5YnpJmSzW6qhmienfEE2jbMBBW80U4eYV84kN1tRyApyL9
	FIJm37GlylZOJC7dm1mNJnfTKzCyCGjjHwD5oLc6p6OeObqikHlDyKFvloDeHJZ61b937cgVBLS
	xF050NQ6xFv4RHz3NfKV0ShBzd8xgHbR79Qp0aQ0ULmQ=
X-Google-Smtp-Source: AGHT+IEaxm2Ezs6X9pAGeZTfGiDeZKKFcv9jYxAWmPiRXScidoOV/iqJhV2uKVKOhqCyY8zfonbwMA==
X-Received: by 2002:a17:907:970e:b0:afe:c2e7:3705 with SMTP id a640c23a62f3a-b1bb2d0f4fdmr263147466b.22.1758119170855;
        Wed, 17 Sep 2025 07:26:10 -0700 (PDT)
Received: from [172.20.10.3] ([109.166.135.151])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07b3347b90sm1356906866b.109.2025.09.17.07.26.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 07:26:10 -0700 (PDT)
Message-ID: <b8a0586e-a79a-4e14-87d8-ee156436d1b0@linaro.org>
Date: Wed, 17 Sep 2025 17:26:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v3 09/16] genirq/irqdesc: Have nr_irqs as non-static
To: Thomas Gleixner <tglx@linutronix.de>, David Hildenbrand
 <david@redhat.com>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250912150855.2901211-10-eugen.hristev@linaro.org> <87cy7q9k8y.ffs@tglx>
 <87a52u9jyl.ffs@tglx> <8df2cf28-c15e-4692-a127-6a5c966a965e@linaro.org>
 <2bd45749-e483-45ea-9c55-74c5ba15b012@redhat.com> <87v7lh891c.ffs@tglx>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <87v7lh891c.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bhyb8tpx1k8hpfcehduq5mfnagdst9rn
X-Rspam-User: 
X-Rspamd-Queue-Id: A3C4E4000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1758119172-956934
X-HE-Meta: U2FsdGVkX1+Gq85im44cUW9PdwKCyOkF80QejpJ8FJgsslj4s8J2vpFQY5/FvsiiYsBurCSNQLZLpYPMHUsoYGFtAoYGwfZ3dD076qrRLb26DF0X2I+tW3PhHLd/i+hmC1CSg2sm6wNr4NOFC5GlGXngvEZ9hHMed/gOpmTxUxqgT4VMz3mCGhB62gUjxXiczyTriuykTfFoautmLg6cH4zCrktRvPg3+f4Re7ioUcoKl2KTb7i91NuhulCZk5C7zrykfR1flEZBa+jpuOova7Ju8asffWzXM9O/Kx9xJ4LxOlbCS0kSIqWLDZ8SkgW+3lat3bhrBqncTkZx3Bdij6KXrTyOhQtCB1qgtENEmcEdX9k/tu2oXBRI20iPfJYS+HO8fDf+mXfDBo2rCBA4ziPoNZ6qlP105lGVWf/GeeD+igvC547mYFj3pwTjmzFHYAYrmBE6tnxAhmqXsBRzmvMpAmRgIMsFigD1dOrBXAq/uCJkXAiPAv4g7Kwykwx1bwoAr2p2j6jQJM/xLh+0OHgaQ0tswvS6TqFwGbR8bArIvKpTkjvndnOZ4BsgrKWqvAbbHn9BGGsX030s3Nx9jWHPlYHGSZgo0Ca6JOgdcmAiKo0fT7F45DjXdgDmvz8c5eMiS6Wb3znJs0a4Eo972OQcwv4TV+mRg6JmlapmFo7zxqJzdkVZXF0b1tPLesxCmauRg0qq6OqXiXWfeKEkDCM9T0GBII7Bb0VlhrSLziGt5WlIJgYBU4T3siqmT9D883zUBXbU/Vnjf1sRBNPKxyzq1zUsiYL8xJEF4nwkKyEI/QVCnuzz1gqpG9/zoDdngwbLVKjBpDTUMYtQRmD/fmikwAtQS0DoKbIrV8xgBxY80fIiMfU7FzvBFImMLRwZ4QGR10LpHyeWWY3gq9vKzSA/fTvIyk2jdOydvWVLfN39Rjs8ODcxredOnWEy4QWxK2hAzZ1HM6JZ/M/9RfT
 vkg+kLKo
 TohUXeadp9lkKX+FP/8T6CPVuXjUBhJ6Yxvjgf963E3zT/B45XeAs5dnsFKNXlpWs8Ub9yge5BwZ6jcq1JlZ4elAVQxnWJNK6/w8G0mRbqF4UmWzk+SR88RJu5Rv9UwBPZUtdEdlNB7e1KPtJqO0QMiSo8KlvmsUAn+z7eoRKAw5bfgQyDm3OzWCBlQmTeGD/JLBx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/17/25 17:10, Thomas Gleixner wrote:
> On Wed, Sep 17 2025 at 09:16, David Hildenbrand wrote:
>> On 17.09.25 07:43, Eugen Hristev wrote:
>>> On 9/17/25 00:16, Thomas Gleixner wrote:
>>>> I pointed you to a solution for that and just because David does not
>>>> like it means that it's acceptable to fiddle in subsystems and expose
>>>> their carefully localized variables.
>>
>> It would have been great if we could have had that discussion in the 
>> previous thread.
> 
> Sorry. I was busy with other stuff and did not pay attention to that
> discussion.
> 
>> Some other subsystem wants to have access to this information. I agree 
>> that exposing these variables as r/w globally is not ideal.
> 
> It's a nono in this case. We had bugs (long ago) where people fiddled
> with this stuff (I assume accidentally for my mental sanity sake) and
> caused really nasty to debug issues. C is a horrible language to
> encapsulate stuff properly as we all know.
> 
>> I raised the alternative of exposing areas or other information through 
>> simple helper functions that kmemdump can just use to compose whatever 
>> it needs to compose.
>>
>> Do we really need that .section thingy?
> 
> The section thing is simple and straight forward as it just puts the
> annotated stuff into the section along with size and id and I definitely
> find that more palatable, than sprinkling random functions all over the
> place to register stuff.

+1 from my side.

> 
> Sure, you can achieve the same thing with an accessor function. In case
> of nr_irqs there is already one: irq_get_nr_irqs(), but for places which

Not really. I cannot use this accessory function because it returns the
<value> of nr_irqs. To have this working with a debug tool, I need to
dump the actual memory where nr_irqs reside. This is because any debug
tool will not call any function or code, rather look in the dump where
is the variable to find its value. And nr_irqs is not in the coredump
image if it's not registered itself into kmemdump.
So to make it work, the accessory would have to return a pointer to
nr_irqs. Which is wrong. Returning a pointer to a static, outside of the
subsystem, is not right from my point of view.

> do not expose the information already for real functional reasons adding
> such helpers just for this coredump muck is really worse than having a
> clearly descriptive and obvious annotation which results in the section
> build.
> 
> The charm of sections is that they don't neither extra code nor stubs or
> ifdeffery when a certain subsystem is disabled and therefore no
> information available.
> 
> I'm not insisting on sections, but having a table of 2k instead of
> hundred functions, stubs and whatever is definitely a win to me.
> 
> Thanks,
> 
>         tglx


