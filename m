Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBFEBC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19276B008A; Thu, 10 Sep 2026 03:33:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8B06B008C; Thu, 10 Sep 2026 03:33:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB77A6B0092; Thu, 10 Sep 2026 03:33:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98D7B6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:33:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B12A9A0487
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:33:20 +0000 (UTC)
X-FDA: 85197036960.04.A1BAC62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E2DDC140007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:33:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IGTBRL39;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789025598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=czh8IcADH5q+j25/l/hsdYEPqXsQdtzVs9zbnn25Avk=;
	b=gD0sFSaZfn7HIkXv1SZr401LpB8iAb3W0taHipfYoyzUOrOKet9X+qa/Yt5J1znN/dLm+t
	GS5Ee5O4a08YE3ATbxpk54OIBoZgxWQEMndw5JVu43Hwu0TAuJ8ebY4UVofucJxE+DW1Cn
	tj2N2u8DcMBV1QhC+duScbdali1hNG4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789025598;
	b=qLn2u1Dpg2UjER1aTaETl/OnZzUclUYDNqf8H4gEV/tYghbEDGmIpOPe2EYC395XwnHs+Z
	ukhDEw2jszFn28be2+PMFFABdwf2UFC6K4StwP0Vlc0Y1PtS61si801At4LhqWUqmcspUy
	3IIqOgeC+JnaMU+OCpo/50O4mu4t/Ok=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IGTBRL39;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78935600CB;
	Thu, 10 Sep 2026 07:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98C81F000FF;
	Thu, 10 Sep 2026 07:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789025598;
	bh=czh8IcADH5q+j25/l/hsdYEPqXsQdtzVs9zbnn25Avk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IGTBRL399qvUpxmFxt2OFj5h3OTsHkvcF6R9C8EZIxMtupmNmI8IGB+84AWqGb8ZA
	 NMzQMJ1cDzUknYLC+BHFZAcz9DkqOlM5zo/7v/cadMqNurU5ynMEoMZNoXwxpm0u7N
	 Y9h4aOWI/TcI2gz8IqnDLhfSnUPTJCWARQCaIgkl5rH0xZDBHfz93hJAE0JCXuwLG4
	 uQc80RdpyrQMpoqN0c89DNjX+whZEOVw8dX9TsLkF611KDBwRPrTTyahwYWSeTjNp3
	 14akviQhN0dQbBMkm1LJdo6sCWfe6DwH34PiQ6xZudu3HY30JpmPuMMjFSjSlbBm5+
	 9mg2Z2PEQFopA==
Message-ID: <401e3beb-e2c5-4241-831c-005ccfb22e34@kernel.org>
Date: Thu, 10 Sep 2026 09:33:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/3] mm: make persistent huge zero folio read-only
To: Mike Rapoport <rppt@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, usama.arif@linux.dev,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, kas@kernel.org,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 luto@kernel.org, peterz@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260901151818.3191443-1-xueyuan.chen21@gmail.com>
 <20260901151818.3191443-2-xueyuan.chen21@gmail.com>
 <1d5ac9d7-48ce-4fee-b893-f646bade4a86@kernel.org>
 <CA+qSx6yjiXJkQm=hi=F8=_=DU0x_usSuXnL_1yuy0fUU9UU-Zg@mail.gmail.com>
 <d3723be0-46f4-4025-b526-e1bb3cc2cad6@kernel.org>
 <CA+qSx6x2-Md9uVZo+HV0z5CfmGPDzhL482eJNnM2VYVtn_e72w@mail.gmail.com>
 <aqJbFXjU53_D7SoP@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqJbFXjU53_D7SoP@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E2DDC140007
X-Stat-Signature: 3jpwetcxbr54qwbnxtfjxztfg7o6ro3j
X-Rspam-User: 
X-HE-Tag: 1789025598-467989
X-HE-Meta: U2FsdGVkX18ytNzdP5Mi2uhE1qZCNTCYAp0Sca/1vDhFS4VN6D3iztClabLR5ZEAfekN0X5t+F3WlT7dAd5Y6rHMLIMJyEY0WT5ba5am7jt8sHTGeff5+PagkKXmF8b4R+whHAd+z3Tiprrjw/szS21cFY8xjky2Ltk5VLp9IdQd5dPpTobkAPwuRbZNCh8V0R6u5rnfHhrcCAnRp5VcfrV09+1CtyPt10ukGeXO/WLUMNLQk+7iBZ2ZUcheZLwNSnQLattogQLAzuPYWIn5ltyF1JOsCLsJgmVZuUhT2dZKEiXD0tyEKxETAGlSSFk6dWeatLPodWi4yP4HutBhuKRSy91BYBF8CxG+2mdHyVPBVeT2px2CMBIaQHvwxYGrmG1ghZFHbeLaWXjC3N8rAwBKjeDyFO1NWT9UOJcXyO0fG58qY7OV49tEgsx6p9KTtUtlhFexJmazEhYp8e9ugd5qx8YJ82rOZ7eNOKbyebdqvyGGftTQF6X9GegB4y9tX/PMZhWyaXZTCg8t1FdM7X6s1pyEYwseAto6FEzoJ6NpV8Xjgp2o04HCJeYooYkPNM1+3023ENzBw3VJnjSmQgmA57G5FNoG1+yLts7OLqjcsBYv/n+pDegKw2eGYRV/nzDEborbL/+OWqyc7hbbTX8E6xUBIB07Dgmihlx6FdV7WQPIbYOONCj1kSEkeqKKQNjnb/UTReQQMjfkNSbNyl7hTBkxDYomwQwssJsrx7EMW7uhNcjJmc+PcnWdC2e74Yvh5wWzfqC30Q3kBCSD5ttsgtOqjAHScXBZE2CiTtadwfU8147E8PwGi14C+/fon5v6TdoP9exL72ov3eOEttMgdrO6/j5JhRo2p3gVooaR5AU2Ef7gyZkstg0brsmhJBruVJS6ir6n1AA+FQ9ys+dpl60Vx4/aCqxA0n8VSKdOTyHE3INtX0+S76jAs2ytcqeuynQ2JbuPGvNAic9
 t1WXLGWe
 BV1YtWe6EwzZOEMtgwGf6cU7BbndHAblmH/hJW+1tI17QnTzJxgRmBOgUVQo2swRvbu75sNLEcCTbxHMQXcMzpUMuETEb/Y464EOo86QKYrpKxEPAkryQAqTMiet3JpO93E4AL/bJGVBkrCJQSyda8nSDSowk4+iBmzBpD+b6wyNS9jaXZpsW3fRFq6koLjDAdGZlGUoBrHjsyWCnYtJ6urNvdPnYaQFXiczsu3X0GWBQ4re2/7FEm8JTGperEDcsUqp17fD8CH2NGsQZV8LE7rY1FnrnZYiavo56dXeBMh0iStOh934k0L9o8wnTPSrERKkfV5tMY7BVHVSA/q716XVUlhuNvY+fgoVMBUNHm8ncOKPBNcvDDncXJfOwjmkRK8VApLqAYIaK04vVykDwllNYAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 09:24, Mike Rapoport wrote:
> On Thu, Sep 10, 2026 at 02:22:25PM +0800, Xueyuan Chen wrote:
>> On Wed, Sep 9, 2026 at 11:18 PM David Hildenbrand (Arm)
>> <david@kernel.org> wrote:
>>>
>>>
>>> I think getting something consistent for now is the most important thing. :)
>>>
>> Hi David,
>>
>> OK, I'll move the highmem check into set_direct_map_ro().
> 
> Consistent means leaving highmem check in the caller ...
>  
>> Should I also update the x86 set_direct_map_invalid_noflush() and
>> set_direct_map_default_noflush() helpers in this series to skip
>> highmem pages?
> 
> ... or checking it in all set_direct_map functions.
> 
> I'd keep the check in huge_zero_init() in this patchset.

Agreed!

-- 
Cheers,

David

