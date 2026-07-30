Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1209C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99BB76B0088; Thu, 30 Jul 2026 04:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C736B008A; Thu, 30 Jul 2026 04:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814666B008C; Thu, 30 Jul 2026 04:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 572A26B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:33:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2AF940939
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:33:58 +0000 (UTC)
X-FDA: 85044780156.20.D0B2C69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0A7AA180008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:33:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U95IUwGo;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785400437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cLj3yqHdJxwAf/kYLp01HRKq4EpVWC61cCjSwrPtQO8=;
	b=gA5t8y4w+KuLWn68ozb6ERiinQCNa9Ub8SzlEeV3qRsLM0NcdYity9Q8QpPatZ/LpK58Vc
	N2pB70FHd4B9Xtco7FMYgr1ytOljBHaSjj8V+cqYkHPnuwnUudDOVqHKrZnxZn3/sZ5ucd
	JyBsL9WGcUlRyJiypFzX+L7Eo0imzWk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785400437;
	b=MgNbu9ss81/YDs82J2zQu02CF0UsI3BwdIWqbJPbkKq4F+5bZ5O1eeX0S55sCyHNouQkZK
	+639KnIhZLTGFacAGkgrhNFu8wso4gjtS3hWzVhOAqkgBukyyyVCErvNOefxd6RKa2B8jn
	x8mNM6ZpSzcTjpQwBZOgO6hzaVJTaHc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U95IUwGo;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D3BEE40DAB;
	Thu, 30 Jul 2026 08:33:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEFC1F000E9;
	Thu, 30 Jul 2026 08:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785400435;
	bh=cLj3yqHdJxwAf/kYLp01HRKq4EpVWC61cCjSwrPtQO8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=U95IUwGovyaV4WQGXtl+G6UkvlVb960QvwpE4JZMSqSKC/EmPueDdrNH1Zskgl8QA
	 qdMBXnqGD2OxQjXfv7d8XKFoGkfEDDk0EQvI/jLcIKrGtHk+kYzWd6uSKVXiaSkc8Z
	 /ErB3LMM8N0Y3stn0AuqhrF09FR/KKyvDwRC1DLBmq2cD7rJeo5zWRsl12s4oJtSFU
	 eeq+dbqN0qBu4GLManypD7a2xQotcf6rWY2X3XLCYiVrOiCx5Lf2e7yAmfq0UNKkv1
	 HCMlAKUls4pwgfVKzANgX15rxDLnLe29ej9jvRX6fYPHGWogAJnN4BKIfUyWinsgXK
	 WoqkgHSEd2FUg==
Message-ID: <004bdc87-8c8e-44f8-93c3-1ae0a47051a9@kernel.org>
Date: Thu, 30 Jul 2026 10:33:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting
 from interacting with KSM
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>, Zi Yan <ziy@nvidia.com>,
 ljs@kernel.org, xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, usamaarif642@gmail.com, yuzhao@google.com,
 aarcange@redhat.com, akpm@linux-foundation.org, chengming.zhou@linux.dev,
 baolin.wang@linux.alibaba.com, liam@infradead.org, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com
References: <18102ABA-0D8E-4DA0-AC30-544E34E445D5@nvidia.com>
 <20260609172719.803537-1-usama.arif@linux.dev>
 <CAA1CXcA84BtQZxOpE0sWgb2ed6y3m0NLKkWD+5MfWS9eF5dqTQ@mail.gmail.com>
 <a464c20c-8b41-4264-b560-497ed91cbaaa@kernel.org>
 <CAA1CXcCsqkV2PrLicY5BnOMp+iJWJxsPn60g_3WXugWQqOFYpg@mail.gmail.com>
 <0b268070-95d2-45bd-aea3-56cefe01dc8c@kernel.org>
 <CAA1CXcCp0z0kw9pQtj55qNGOBJOpfDsrf1GJ+EhGZCfA+dhbKQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcCp0z0kw9pQtj55qNGOBJOpfDsrf1GJ+EhGZCfA+dhbKQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0A7AA180008
X-Stat-Signature: ygaxhzxgtq4qe45eqs3setckopq1tuc3
X-HE-Tag: 1785400436-526653
X-HE-Meta: U2FsdGVkX19R/SiYKnyNsGPOOvEJgF5Z8sEDABongQsHG/lpbC0Agns40Kz7SwqSACHnKVTtHpSGLkF9YcxdsNaPD86odnrHIgEc2QWoPD5tR8cOU5wN5Ccwo715e5hCzEAnJ06yOOqMB5AWDPS53L0xJlvM7JWyUT51bWRXvAsFrjhHXUHM2uHYler4H3rO0UBFLKAkg02NbEfKwWxmgJFzVhzqT04Eirs2oP5PHDFx3yYD/WvDD1Cu7XfAumNtMkMr4BL+P7+OtCGFWK3LPwJuX6JSl6AnBeBVI2qip/cDsHX1asfSN3mmdo3txxjsotOy1zcvF27tbicrANl7denypm0LolctFNeBqs3oXHkOKJwkhRQrA33ulZwvFdmhEkdvVVisOQX1PbmXbxRXmKXxbeFSthlqp/ZD7+U2Qnoz6KqVmgPRXNEzouyMjac6+XhqK4b4FcYJ+Dz4SxngECSxPrDC1/dSfCT2HBbkk+BYUVQuVgURMYeW3beB65wJETOYBmAfYn88nBqgeiPdX9f+SGIEh8kBxl9rnmdrYO622kwnueWG02eku+nOTtl5zB3I/ZE4EC5L3iYCYxDjw72sbAP1GpKJBqzVuofyOVAIpRBAfli5EI73u/NYJpL4F1xMhHEyyo5SiA+R8a8b8uVToHXmmejZc4d4AOOwVfK1QyLO+TxOGUDyxGA6Q9gvxCtERHRTblJy8VG5vnBApkhVWup412HsKZme1EJCRfqAfkk6ii8JzUjyIdEAYlL6fQxaK8lZX6K6lw6CqyjdQfMQIAX/GnXkyfxPAaVIgiq4RQVX9QWxvqQF/IAc3A6ZSuwHRDtaReOesT6s11V29AqVkhkFczkjWkCAfQGsz/1TpG4iyxrmTO1lb0vhurxc4FQ00EBxh0VaoWU9IcKMx0zxdVeRr7tBqlEFr3fZrgSoxd/r3xqdQsUanG1ddcobVj4h8RO6MfUm/tgLiGK
 UZLsUYlr
 tqKA7gNeHMIwtEBwb2X9I2IwNOHToVQop3d5PjtaeVtZMUJQIma8jWyXnMF5fYmL9gCKID0v01OsgmVy5KG6PrExFFz1+qS/wviyVj3yd8sr+4WtcyfH004LNm6iDlV5IP1JTtVseFkyC7/ilQIgsZZr8r08CjAda6gKq7PE+3qo2B100XAsj6uFSjuAcoykyR0iyP4RHXezUs/L/bTA56/OouzHtWmL/Pja1eSqx4ixelFvAgJm2UF7kyFVTGj2XB6qE3No3t6Sk7YW/o+vjiqf86yPkHHBn1ZCREqP69W+Qknrxv9adLqwBvObqABo6ZsOVGfWITGX+qJjpHLrxdl/mPtxrkwX5zcRjFmGwT1jKSiqzSmL8f11uXR/NscYo79TD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 18:54, Nico Pache wrote:
> On Tue, Jul 21, 2026 at 8:02 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 7/20/26 17:28, Nico Pache wrote:
>>> On Wed, Jul 15, 2026 at 3:30 AM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> this series (v1) would be "dont scan VM_MERGEABLE entries when KSM is running"
>>>
>>> It stops all VM_MEREABLE entries from being candidates, while the V2 I
>>> would like to propose goes back to my RFC's alternative solution
>>> a ) "skip zeropage remapping if the split comes from KSM"
>>>
>>> I think (a) is better than V1 as it doesnt indiscriminately target all
>>> VM_MERGEABLE mapping but rather those that are triggering the issue
>>> (the split).
>>
>> Not sure. There could be anything else in the system triggering the split before
>> KSM comes around.
>>
>> So v1 just cleanly separates them, independent who triggers the split.
> 
> Yes but now all VM_MERGEABLEs lose the underutilized shrinker
> independent from weather KSM was the one who triggered it. 

Because KSM takes care of it?

What am I missing?

-- 
Cheers,

David

