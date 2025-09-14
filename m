Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 879FECAC58F
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 08:15:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A33468E0006; Sun, 14 Sep 2025 04:15:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0BD98E0001; Sun, 14 Sep 2025 04:15:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949958E0006; Sun, 14 Sep 2025 04:15:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84ADD8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 04:15:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 642C11A02AF
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:39:53 +0000 (UTC)
X-FDA: 83887056666.15.1E9F308
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 973E7A0004
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:39:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uPLdtK0Y;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757835591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zy0rMvTD99DiIN/7fqVO3cDPxdU5/1ohHPv1dsMlt9Q=;
	b=wpSlkmFYVnRspx3cvwAbFfyEkf4RDNZizRR+i10xkDHqxCWS7tafxIW+Cex6HJNTXX5fvT
	r8bVM2rWeaF0Cgux0OBU+kQhuZMoEm+A6VFP3YmomlPgc03qL1+FCur1EitaVhJYHJ6bGf
	1aR5Hg/+pEjJIKaDg1w3M1B8jNA7994=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757835591; a=rsa-sha256;
	cv=none;
	b=N3pmjMMySpDaOqOtIbM+3tdWaKHT6aO6Q3zse1XKhNFC4VQdPUdU2KLaq6CungIeV/XPgG
	W8Z4mU4Bc24OrnrLKGYjW1YWqQYK54I378LZszQxjqQ4KSjkrzP9dVyd5ZJECgT3IaDpC3
	bR24GRXxZfyoddhVxFEwYs1MK2d1JxM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uPLdtK0Y;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <0beea647-24cd-47ff-9124-1ab88fc43535@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757835589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zy0rMvTD99DiIN/7fqVO3cDPxdU5/1ohHPv1dsMlt9Q=;
	b=uPLdtK0YsAHaLVYa9QTI+V1BLlJ9lJQWQqyYxoMdn2BcGElKs4kXlKefIgPzj/WUCUqNAB
	9g+hYV8MgQGuETgNPeCx12vgRfIxHSLsCtW0y7jfZfeddzPyXYLIipr850jJHpEI9V7OeE
	mY0pDcA6TB6zBv8FwkvzbMfKVuy3bqI=
Date: Sun, 14 Sep 2025 15:39:41 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
 akpm@linux-foundation.org, chengming.zhou@linux.dev, npache@redhat.com,
 ryan.roberts@arm.com, xu.xin16@zte.com.cn, baohua@kernel.org,
 Liam.Howlett@oracle.com, david@redhat.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <ae30fc02-c573-46bc-a5f6-935f256149e2@arm.com>
 <cf5d6ff7-faa4-469e-9e32-b90c75b8194f@linux.dev>
 <463716f5-be12-4d78-9432-779e3f11460c@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <463716f5-be12-4d78-9432-779e3f11460c@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kcx1xrjyf5nxhoczq8uakbhsmfwkx9f4
X-Rspam-User: 
X-Rspamd-Queue-Id: 973E7A0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1757835591-171423
X-HE-Meta: U2FsdGVkX1/VWNdk1/shBqHzZysnxyj18SGC0Q48plQhQdc8l6FP3eNpWasLFCM4OF7ylUvxi87DB7KSGqbVf4F30D8jThbA9Z/tppVyz3MDH9h9C+GhFpQyz97Q8JEusXv+qzWDpEFgMY01Ox4UH9pmY0Q+ZF0y/UzY8t3ueaSS5CeD16voGUpkXFfLo5HiYQmN53ki45TbEOv+BfSe8vi5cixNt3zZh10Ew3c+c4xxf0HjVvAz7GaV7ANdpLwk/+Gssa6SFmPMqoH0/OPftn4ebDOJk6IwDxd1QHrspAo/GMqnSvw1u2/TerrOUAxCVpwpgtbr1g133ytXzmEXSmwZxW/NAOCTSzVlDxZNYdQgMWfrOGOU0BkkFL8/RUrgB6IrpEI4EyqrUDMLAtlHkFU2ZUFZ0uEisUeE89ax2Y0klet8B60ohAxqW6Zo0Q/9NIlofkio1WvjC7N8rMwXvCkpuYdGPESUqwudjf6uKfjtqpgWg509EFwpZmrE6mIJ50k+Z22GwWLFjZ8yoooma2q0YV2olP3//ttYP2fF9vRaxxUnxvPHSMhjT1BOUFdPXXHwaM/nP/h0zdueXnQvYdp77SWUsVC/S/bzA73t9nf3Tg3fujkW+vwxiMz8RPBJIdvLeF7RkDbb8iES/5BFNxV9HjE2Rh2ZlfZs3arbJ7a7gmg2sSWzTNWwFKcdl/zLTJjQKfYXwf1wTo+OkX0TaIfqyfjVtzINlSmMLodxg4RAJ6wvEYB0TQ65hZzjPxxV5IRh21BYi2GlFwp5L/IsxOn5/rZId3+L59CGCfXQh+ms7rc0D3mQA1mS68biKrLut+/3LdQRYIyyxt94vu8BFdCotM16cpzn6/JCKunIt6+dDZp9Zv96qohnCXq9yljwlAqAoJuCklzUZ6KROfDFALfpO7MeyNveOtmO9RAUk9RF183p4Xb0J6EsF5u9XcersJjlIOoBL/fx4zvSYTw
 zGDBLb8J
 p85fFUE3n0dRMNjrgW31SIVpzqt416gP6d0NgNAjZcW5H7S7lupdKpVVDLupmr0AijceEyIq76nLJHT1z4HvOMwuaYhHmGwBjVD5C+xV9EtLA6G27Gtxthjb2UvGvxwqp2b6KOPdc3qwZBfHQvH5GeoiYYpiYicMsL+Z4HFsfTQKRUBBj1RglthoIlZco2521h/SJi6L3kyGvOCmEH1b7yxnF69PGGR6gIodpKauBsVIX3J0RN5eN2UTzTQgpgj5oxqiVFKq/JNPONQpPNNkQgjVqU1eBhvWne7e0wwpZjVswEOaYRutCoaVrOScyx+QusZUwS+6/2aNcpaC5c2vG1Ji7h0iXA1JhA6Gm0mXUUH42ZmXDEZ4zZmaKAzCgtzw0Wgxl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/14 15:29, Dev Jain wrote:
> 
> On 14/09/25 12:33 pm, Lance Yang wrote:
>>
>>
>> On 2025/9/14 14:21, Dev Jain wrote:
>>>
>>> On 14/09/25 5:30 am, Wei Yang wrote:
>>>> When using mm_slot in ksm/khugepaged, there is code snip like:
>>>>
>>>>       slot = mm_slot_lookup(mm_slots_hash, mm);
>>>>       mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>>>       if (mm_slot && ..) {
>>>>       }
>>>>
>>>> This is only valid when mm_slot is the first element of its wrapper
>>>> structure, otherwise a NULL slot would converted to a mm_slot with
>>>> negative value. And current code thinks it is valid and continue.
>>>
>>> Shouldn't you fix the code for the case when you can't find the slot
>>> in the hashtable, i.e slot == NULL? Like, if (!slot) return.
>>
>> Right. For khugepaged specifically, the slot == NULL case in
>> __khugepaged_exit() (only user of mm_slot_lookup) should probably
>> be treated as a kernel BUG for new.
>>
>> But I'm not sure if the same logic applies to KSM ;)
> 
> I haven't seen the KSM analogue, but restricting the position of an element
> 
> in a struct to make the code work should imply that the code is wrong in
> 
> the first place :)

Yep, you're spot on :)

[...]

