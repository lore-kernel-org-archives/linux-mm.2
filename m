Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40C04C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 11:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19FFE6B0098; Tue, 22 Sep 2026 07:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 153B26B009D; Tue, 22 Sep 2026 07:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01AE16B009E; Tue, 22 Sep 2026 07:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C977B6B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:52:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47FD3A0473
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:52:53 +0000 (UTC)
X-FDA: 85241236626.15.B158E22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 863A1100006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:52:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HY5ld3qY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790077971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FyG4SaTJjRm1vWtLZjh7+Uoyc+0fCOtZ94HDYATcA1Y=;
	b=1ZlPXrgQC5+UzUhQYCqrw3rsRM2ahmJJrytnJucKUjea9QnSCHWx5gjzhLgmgjKr1m796q
	WYE3ih6JvmvFV3zx81mrlyxH1dRxreBvriNv89tSMlsQJwk8V200N9CSpa41chDLQxFq6i
	8AM/n8SarJpoE1+7rkHdti++swEc1bA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HY5ld3qY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790077971;
	b=nhGfxjpTD1FlGVMPDyaJkQTb3SayjZSBY6MWwfs0zNQWUGg83q15g9ajebliAu511b+kvv
	Z5bhKiuqOK07YDejQA5v/6l4WnjhrzGomfIlmpbndO9hJ5CdpcLY8ItS2iDxt/aDzaRXE3
	E63B8Ze/J8yP5hxP6Dgfyua68IlR9HI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE53043459;
	Tue, 22 Sep 2026 11:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE0E1F00899;
	Tue, 22 Sep 2026 11:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790077970;
	bh=FyG4SaTJjRm1vWtLZjh7+Uoyc+0fCOtZ94HDYATcA1Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HY5ld3qY+AFaZntw9W7jL9IulMrRT+EHC0706/1iQYw2hgBdp6Gu0koETl9EGGl8O
	 2qifQbo8NQgXd4oXO5U3gFNoNbMN17gAF0IO7i4MU8tuAuYQ7Ading9rt11bQkC6Z+
	 +Cn1TPZZpmE7xk3ujyvNWNEVgnKXe9/H8TicjMDD26gloUM2NQojLBIJchB8ZTulkt
	 lxV7JW/n+4gMhroRxFq78d4bBERVqufMBRGsQ3yjJmI2uTuwP58hkpOgd6N4gCkC+c
	 CoO0j0z05OlKiuUkIvBTlGsrH7e1rd9tgyksnOLCbFjOcqKaorK2HiCNg9Suj/4Zgd
	 4kW6ppeskt0Jw==
Message-ID: <c4a6d3db-8b57-400d-a377-a7acbf45d3ba@kernel.org>
Date: Tue, 22 Sep 2026 13:52:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking requests
 reserve access
To: Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Cc: Matt Fleming <matt@readmodwrite.com>,
 Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
 abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
 dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
 hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 mhocko@suse.com, ritesh.list@gmail.com, rvvandan@amazon.com,
 stable@vger.kernel.org, surenb@google.com, ziy@nvidia.com
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it> <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <arFBJdYaRx_iJNDA@cmpxchg.org> <arFBWvzXPYrKuIYi@cmpxchg.org>
 <arFFKGrpPwtTkoCi@casper.infradead.org> <arFUPOi6gadAvD3E@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <arFUPOi6gadAvD3E@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ckp98m6mbqt4edept411aws78azrgbc5
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 863A1100006
X-HE-Tag: 1790077971-282077
X-HE-Meta: U2FsdGVkX1/BzNUc5lLSaVISOBrOkQXe426ZMCPh9mB8E+qt6GtqZBKoDR7EDiT+DAsPlCpztLlc2zpg9TXGPg6unb5KXZLgrVFogX2HXsYXSe1BKdueI0fngb+nbcfdDJvnIFM64nmZjFeCfEHmWzgX+bIZHFRNACkjqa8nb6BcqWo3piLU34NEAGOCQnYpFM/uW7p73tKfd6HOj8by+s3lVIrHF5Xwyl1d6IGy/WSwjTHT08Q6TDkZ0K7zqpjgqFQlq+tDmOtOXxQxQ9WTps8BZnVZUDehfRCnEKXM2P8ZNFD4fk/v39sXhZHWfQQffAqZV3XIKbWslS8CX99fcoidK1jZyhmtsHnZrAghDsmLbx231pTAifgQ9jQHOCb8bOTUMnzQtKqpqS0XHb/zDZSI3U1LeclIpFiMbXz2UjcB4sBH5C+I61+QMQHpFq65emy6AIO/feiu3e6YsaxhMQA0H8o0nkl3AbWRcrbA+s1SQ7wafhSIi/Nolc3jsw6qhdA9D1q5mK8Gbkz/UEiqNlKVIC766KnFo5x1jsSFi49XKvIYM01vAdXAcmzSJ83GstyFh67umC26Ak8YHak2OQxoir1DCxUPvXWTvW5HMsY6GksBXK8KL8tIaTVDYktRZtUo/kRmjicPtYKZ9Mvw0GNI4nHPmU8KRWNjiKk8j2ZVzLkSI3wwYWELK84drfzYgo3EEfNB+tdPQL2cgAgZsusKDv/U/kifbv5+Jsx/H43zNGSe+iFMUKh/l1z58XWjRDKL65uVVcD5XDPNjXy2QbOIfb6oUpld1T2TqvnpbJpuHC7cVWTQXANtRlmS8JUUNB7kLPaphC+qBrvyQG1UZCEq0ZkIL98vSSvD0CTTzToWwBIC9l6ta09rKjAEeXnxojh8B/tpgDjBHrQzYh3eOzN0RGsPF8GTPUZpzSmDSLAF0SrBwtOG+ufXSOEmUcjfGi5z9aIlnt0eI3i1zay
 YwSEWqjI
 bkrnqvCJoe4aHQ+b4JWzRPXtRcvvPxly5Z15Y0aMrpsrkNERS+d2tGVi7ta/B5JoP7vVMJuVOgUvRQC0a2+HJKgp76riOzR8TveaXRRCnoEPxZDI5z/bMhvHcsYU2pCnJClS8jM09rHp22vveUaQitSd3vRLOxV8+HeRnWpNUbfBmh3egmQdgNFgdPwvZYY3Cth5HYjGFkE7M8fJ6qRGkEurdyComWOBKWMT9+miO3aKmUfInabazoXznWDRAzFBp4Zy+L2IGLZFDYzSkXfPbk1T+Cqzer+ro+I3k4319OSxP3TJJp4C1gsubwfMMQjzRiRSMTq/tPsE4JNuGOgrTyUNjwmlwYx3Zo6P/8mpu3SPrOu8MfvbjmEBgDtxoR9Um0CHt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/21/26 5:58 PM, Johannes Weiner wrote:
> On Mon, Sep 21, 2026 at 03:54:32PM +0100, Matthew Wilcox wrote:
>> On Mon, Sep 21, 2026 at 10:38:18AM -0400, Johannes Weiner wrote:
>>> +++ b/mm/page_alloc.c
>>> @@ -3246,7 +3246,9 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
>>>  			 * reserves as failing now is worse than failing a
>>>  			 * high-order atomic allocation in the future.
>>>  			 */
>>> -			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
>>> +			if (!page &&
>>> +			    ((alloc_flags & ALLOC_OOM) ||
>>> +			     (alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC))
>>>  				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
>>
>> Would this be slightly neater?
>>
>> static inline bool may_access_reserves(unsigned int alloc_flags)
>> {
>> 	if (alloc_flags & ALLOC_OOM)
>> 		return true;
>> 	if (alloc_flags & (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE)) ==
>> 	    (ALLOC_NON_BLOCK | ALLOC_MIN_RESERVE)
>> 		return true;
>> 	return false;
>> }

I think it should be named e.g. may_access_highatomic_reserves() as
may_access_reserves() is rather generic and would seem to imply an
ALLOC_RESERVES match (see 2/2).

> 
> I tend to be hesitant with single-use abstractions, but no objection
> if people think this is better.

True but single-use ALLOC_MASK_ATOMIC is also not that great, and the
usage makes the code hard to decipher. And see my reply to 2/2.

