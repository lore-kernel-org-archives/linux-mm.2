Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 152F5C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 02:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F27C46B0088; Fri, 26 Jun 2026 22:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFF066B008A; Fri, 26 Jun 2026 22:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3BDF6B0092; Fri, 26 Jun 2026 22:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2FB16B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 22:51:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 48C1B1C344B
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 02:51:47 +0000 (UTC)
X-FDA: 84924167454.08.7FD3673
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf26.hostedemail.com (Postfix) with ESMTP id 51DED140008
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 02:51:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HzaW6oQX;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782528705;
	b=SPNM/dJ/4uZtDojeiACFOIuh0lw8V5D9YqNxKU+tm+E9iRYAFI767rem1WAyV1wTQAnmjU
	Fiy7oY3EUHznoBzPZ5vUt33UkGDzBEXiaNZd3ug5DwuASDRFcKg2PGoStvQbQS2zJWwo3r
	PZOJj/z17qKvkrRqTjhBXvtKWBMfB3Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782528705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDYcE5MsrZIKnRWtwXNcAj7rSHtaafqGAtwFoyTEBR0=;
	b=UYD69YBWupIsVBsQEe7QWApXYPS5qs7Q3mxg6ymePxSA8shIuhSSDKJAb/d93ZTZOBy62m
	E3A6wlkka/qqKNaRNIx4EysT/SuMliL12STD8Nh/83VL4bfJiEqfLmrEogwL8NULjOWu8Q
	QCXUX4s6L0I4KiFGARO9X7ONk0ileow=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HzaW6oQX;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <99fa03d6-9869-476b-a605-1ab27f13c369@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782528703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BDYcE5MsrZIKnRWtwXNcAj7rSHtaafqGAtwFoyTEBR0=;
	b=HzaW6oQXohR6/maYtwI7n7BvwwmvGnJO/N1eUnnHpEXBW5Qyuo2NPtrEUtsoS3CdlTRLdA
	W2uQQ113xI/zkQsAapMbuuBudKju88XP5F5ATruxgFSHRV7RlHKH5eXdgp6KH18X2+iC2/
	sy6HTHxPVGhRdLHcutYJKoJJp9tpMuQ=
Date: Sat, 27 Jun 2026 10:51:27 +0800
MIME-Version: 1.0
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private PMD
 handling
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: david@kernel.org, akpm@linux-foundation.org, ljs@kernel.org,
 riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, ziy@nvidia.com, sj@kernel.org, balbirs@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <d060cadd-34f8-42da-b7f7-c8d295050436@kernel.org>
 <20260626132728.77436-1-lance.yang@linux.dev>
 <20260627003813.ktpya35fx5doaz36@master>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260627003813.ktpya35fx5doaz36@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 51DED140008
X-Stat-Signature: fy1udq7eb3kqza4k4qhmkxi4ifn157at
X-HE-Tag: 1782528705-943746
X-HE-Meta: U2FsdGVkX1/6frEoTQPpY1dIVsTJz6iGPNIgfPD9541jKuCvf1aOjGQtSxjM6ZN5mhvNYprkuXFNPHnYRs2TAPmVfaUuEInhFuI96F3mrxNuZ9YWmg2ZS1+w62E2H7ERQk13tP03eomWxmQLe/emQtxXKsNwMEbnfolIZo17rsysLDnFRalfQXmQDG/7F3IPtS5FIF7lkTVdHpow1Ax4+di5l1F+sLY85BK+V6vfTmNWBLm7bcFnsFf3y42T2T+DVnmdNLmwBr37ChOTl8x98O0r4vqR6RSz+hq6tsBteLpS7XtLgKC/BbcTGtCrZ+3h7g84uBZWvL6gcZ6II/nmnGh7yEHu536HI8oddggY/dGbFzWdYiDnr29gSKnTIr6OX7XS/Gsn5axpTwJDt+fhW7+7hJHgX0eMlDJZf7N3IbJgXUg2WOCj+2xPqDz8ZfaOlOuMqfDYxz3AN9Gwmx5M7bJCmjIK2Yvp83BtLcmVYKj0AxHfGeBoiTL4EdiAV2aK/+rBtZQnWWWT/WzFpLUSXE0Y9umUr+tRluAUk7lh7arxoU/i8WbxHr8kTVC1Y2mq4GbnYqKS//CwKdcplqcxBKNdkflIFphNZP6UZBl3JYMuqAEJhdbcRooIXMIFhEuV5XU+tcma8i1KZTnR9U9onR0ebGZvVtBNhLm8sUPwtrVQ1uQ95z6EBoKyprxG9p3cnqTgYFsmAhfwje/0+dIL7a/IcEkLSqDdiWtfIT1tAjbgyU4op2cOkolsO69ugZYNckrRiSG8iuBdcDryFNuxHPvCebha7PRppoUsfgmugkO8GtoIWAQKgL3ixNqZqUVMU1sdPvfbzNCn/rH4fT/4dKfFHx6LB92xHqXk9hdIyQ/EjVR1Tl28z40yKjVurdCQ5qAzlcaSq+Y7uNv2u7KD5+h/Z+vFqY+sCqE6umMkqsmQwtuOWFgf3EzrnuAFWyrVU4wwnRvy7rEkaUdIqwM
 Bo3FWaq0
 jcz92jGsmsc/DX2fSB5uF5O4rYN1MCjUAkj8Qh1HXJkWzlR+wz9qU+w0qnjnsy6J+/coKbjotioLN4WZGZR+cqotA2l/ZmiRfiJHtV4zhythxohiiUtVdHxheVWO0j5WtaUzRaTsm0MKNnZpOzbFaanZgIugsRWwjQtEKhJEBl6+mQg63O7Xvvmfa/Lm2LjiEbyKXSp4x91B4C0B8l0Yf0BrdufR1BuVSosPFMwGY28Nixqhb8r/EHMZgs5PcNx9TkmBf2uGCuOeBuIRSO8mpmc2ZDyeovWAhz5i+AjI24YVz9mEnfphCCM/6ynX4pmF9U0H1wbgtdnN9efk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/27 08:38, Wei Yang wrote:
[...]
>>
>> Might be good with this on top:
>>
>> ---8<---
>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>> index cfa1230c87bb..8b7c062bd81d 100644
>> --- a/mm/page_vma_mapped.c
>> +++ b/mm/page_vma_mapped.c
>> @@ -281,7 +281,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>> 					return not_found(pvmw);
>> 				return true;
>> 			}
>> -			/* THP pmd was split under us: handle on pte level */
>> +			/* THP/device-private pmd was split under us: handle on pte level */
> 
> As the comment in commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
> support device-private entries") says:
> 
>    Add device-private THP support...
> 
> Per my understanding, we first already setup mapping and "migrate" to device
> memory. This looks a kind of place holder.
> 
> Not familiar with this. Just want to clarify, we want to treat device-private
> pmd as some sort of THP or not?

Not a regular THP, obviously. Just the PMD-sized device-private entry case.

It can be split under us too; see commit 146287290023 ("mm/huge_memory:
implement device-private THP splitting").

Nothing deeper meant here. After taking PTL, if that PMD-sized entry
is gone, just drop to the PTE walk.

> 
>> 			spin_unlock(pvmw->ptl);
>> 			pvmw->ptl = NULL;
>> 		} else if (!pmd_present(pmde)) {
>> --


