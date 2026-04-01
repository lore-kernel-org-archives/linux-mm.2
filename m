Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09AE6D3514B
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 07:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FDD86B0005; Wed,  1 Apr 2026 03:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6870C6B008A; Wed,  1 Apr 2026 03:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E866B0093; Wed,  1 Apr 2026 03:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE116B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:32:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0912E13B85B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:32:39 +0000 (UTC)
X-FDA: 84609169638.19.39B4BA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 437D014000A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:32:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=humF71eb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775028757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nK/oZoLqLWhs4vERutI8f/q4LdD/IXEGNSiR80qnwf0=;
	b=M0JMU4RegXG+u3gkBYsgm+udeJ6ubiL8HaP3rYXka2NOu3ajKPo9ysPkKr/+4zDAA5nHlF
	4jNYfKeW7JTCDVEJBzbT8KciIu6MSMKgt9RujimhZ0NUeqJqR/mxoDtAwgq1H71n20E8DH
	fmqKq4it2rvYD9tv+EkYJESx0RKrjVw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775028757; a=rsa-sha256;
	cv=none;
	b=W64Y6US/QkuSIZeN2cA+WfBjGh35DYcOmlHsYjI8RXHjzm9Y2wW9ji8/xrmcfmjhXCWp6+
	kJAQI0Qb7UPEsDyZSEXdXtls4pOVFZmMNVN1oz7G93cvhPRNBoM9/A/JBW2smNB3yZeN49
	tzsOxU1BmivnFOkcbLL1VGSYa690NFQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=humF71eb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B56B960130;
	Wed,  1 Apr 2026 07:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63542C4CEF7;
	Wed,  1 Apr 2026 07:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775028756;
	bh=Xn630OcqIQHi39xngA8rdVFLMzJ6oRMn/HMdRSOCPls=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=humF71ebabeqOf720kG9Kp3v1uYNN24B/eb+zf0MwE0EGHGt2SYsVKdjAeLFIYQPE
	 JpKTQti9qdA1UD0aJ2wjmmtixB9bFuBuNiNW0fwF3ilqHrSx2t8VLzRyRIbw6bmN2c
	 saJYL9J6ElfuXkNpR6MQZlw5JCLTibOual5FmZzEu5pm/AbinbE1hM/XAFIdXV+6lp
	 ry3tOJfVitrM3Lyzuapcby8OwKWlDVY+ikszsrQmDUWK8FIDdhxWVxq5Q8e1n+TcQb
	 aqgJswJUKR+MLwPFaGtVmpizs2Uk+dbXHjxKIPqVsgEKItt6A0x3cOseQpYN4SmQs0
	 PcSyJjFVX2qNQ==
Message-ID: <e1431688-17ba-4881-9536-b598383ed2d8@kernel.org>
Date: Wed, 1 Apr 2026 09:32:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 0/2] Fix storing in XArray check_split tests
To: Zi Yan <ziy@nvidia.com>
Cc: Ackerley Tng <ackerleytng@google.com>, willy@infradead.org,
 akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, michael.roth@amd.com,
 dev.jain@arm.com, vannapurve@google.com
References: <cover.1771831836.git.ackerleytng@google.com>
 <6ada27e1-8f85-4b85-8c25-bc9207b2624d@kernel.org>
 <87FD20AF-55B6-4129-9AED-E2E854593883@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <87FD20AF-55B6-4129-9AED-E2E854593883@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 437D014000A
X-Stat-Signature: kmzbfc5ahynbw3xe91kui1x9zbh1j1x4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775028757-476251
X-HE-Meta: U2FsdGVkX19N3ubsX+xDwtZbKVa4DQj5ejMhBhGJEnRvWbxvJp26z1PC1eOtQ0hPZ1IPWIVVZ8NtzMGZ+TvJYx4TaPhJmpugct6giMszuEHU22X/ntixlLTy7FdQZo3ZJHy52+8yHkvueACIBqoCTwa6RYvE26dIrg3ulkeSKGRKaQ+Uzq8tNO5eeHQwggQN6BEYK8pxxYHxOTcMjtuM13QDh+v00faM0QNlgnJOE8YorW5uKOw7U1zo9BbIrLMt6OOtW6IkyVdDJoYqpOl5Vp7muqhJBPi+SMh/kfG1/BZVuhBfjNnGzhvNN3EJlrLbjersftc9TDBa/UsBojGWHVYS8/SWUnEtN8xE1GVZ5uo6m9E9diSer5HrM17tcC5boEIUyMlg6OXzkhsKtEfKokSSWXntavvt5SVFxFfZQfUG9jSSNyou6tFC9NCMVjFYJHnsMO7ZZj6mF3hgzoxFGe1Ij3cFEPBTyCaO6mFABZqm15MkAEUViFEm71/5yW74ELUR/Ql85/eUXZGft4Hx8Y7FGROJtHm/tKhYfz/4FWBOrLYkqrT9Y1JMan2z3ElydS3XeepBr5EhuR/UD08QqwtLpZIwtdADhSd64AvsHZZUpRrPnCMrBAJRHnpuAndTOtxim7pCoinze9HRn80gfsQJTrB4b2gayX5V0rLRnxgmh7IFaN10AJ62GjGKfWrVtvgq9XGE8wgkjqpRjc/QSb9aVdn2aS0fYvKr0YeMlSyz8hf1ZEIxZegHeSEheUvdSstroMo0Tv7qrMg0TsHv10Iinip2ARppkZgaKg0On/mxLahzUVlQ4rxDNUSlS8mYmp/Dk3h1f+Ml4zQUyClQ92EXIcEkpTMTd1wFBG+51dqE43yjEvfhk47wOR70wjm/C0xP9YC7BQ5MWE8aQJ1YmBmS8eOQ/M//Pytf7XHyd84pNvWFR+2gEYJWTB/c1h04Qbz8MUZ2Bx2oCjyLu65
 rzwPtAeW
 8VXmB2rL8tKZ4IgoaJr0q8fjWhyS8nP66HX6ERFwE6ztWP755uR3ZoVvlVbFvywr6y24yOyEA6d17WO2R4J74Ci7wjYUunfGjHd0jBJbOJF6Pzh06d7yBqxFtmgzjsAfQJ2l/+G/lPUb7tpdtRLynVa/bfwldkOuSROrJZsUk1VPwjEv3CMYHThpvVpjITxRyZvNkUnHG5D8YUZCY8DUW2Fnmp89FMEsG8Pfjve27K2hZV1PJmStKTFE1HS1PzuL6HqnAU7rguTvSmqdGMlEAwAXAPvkHIVdr08QopomAuFprVFXRZNi5QfKD+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/16/26 17:49, Zi Yan wrote:
> On 16 Mar 2026, at 12:23, David Hildenbrand (Arm) wrote:
> 
>> On 2/23/26 08:34, Ackerley Tng wrote:
>>> Hi,
>>>
>>> I hit an assertion while making some modifications to
>>> lib/test_xarray.c [1] and I believe this is the fix.
>>>
>>> In check_split, the tests split the XArray node and then store values
>>> after the split to verify that splitting worked. While storing and
>>> retrieval works as expected, the node's metadata, specifically
>>> node->nr_values, is not updated correctly.
>>>
>>> This led to the assertion being hit in [1], since the storing process
>>> did not increment node->nr_values sufficiently, while the erasing
>>> process assumed the fully-incremented node->nr_values state.
>>>
>>> Would like to check my understanding on these:
>>>
>>> 1. In the multi-index xarray world, is node->nr_values definitely the
>>>    total number of values *and siblings* in the node?
>>>
>>> 2. IIUC xas_store() has significantly different behavior when entry is
>>>    NULL vs non-NULL: when entry is NULL, xas_store() does not make
>>>    assumptions on the number of siblings and erases all the way till
>>>    the next non-sibling entry. This sounds fair to me, but it's also
>>>    kind of surprising that it is differently handled when entry is
>>>    non-NULL, where xas_store() respects xas->xa_sibs.
>>>
>>> 3. If xas_store() is dependent on its caller to set up xas correctly
>>>    (also sounds fair), then there are places where xas_store() is
>>>    used, like replace_page_cache_folio() or
>>>    migrate_huge_page_move_mapping(), where xas is set up assuming 0
>>>    order pages. Are those buggy?
>>
>> Zi, do you have any familiarity with that code and could help?
> 
> Not much. But I used lib/test_xarray.c to did a test:
> 
> 1. initialize an xarray with order 6 and set entry to 0,
> 
> 2. add a new xas like XA_STATE(xas0, xa, 0);
> 3. xas_store(&xas0, xa_mk_value(32));
> 
> 4. add a new xas like XA_STATE(xas0, xa, 16);
> 5. xas_store(&xas0, xa_mk_value(48));
> 
> The outcome is that xas_store() does not change xarray structure,
> namely the orders are preserved. No issue is present.
> 
> After 2 and 3, the xarray is still order 6, but its 0-63 entries (all order-6)
> are changed from 0 to 32.
> After 4 and 5, the xarray is still order 6, but its 0-63 entries
> are changed from 32 to 48.
> 
> I will need to dig into the code more to explain how xas_store() works.

Zi,

we discussed this topic with Willy in the THP cabal call. I did not get
all the details, do you remember our conclusion?

(I can try getting access to the recording)

-- 
Cheers,

David

