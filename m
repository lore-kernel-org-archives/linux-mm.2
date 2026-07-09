Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DF5FC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 808086B008C; Thu,  9 Jul 2026 06:19:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791F96B0092; Thu,  9 Jul 2026 06:19:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659876B0093; Thu,  9 Jul 2026 06:19:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 410686B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:19:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C86BDA03CC
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:19:39 +0000 (UTC)
X-FDA: 84968841678.18.9D1C04B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 001F38000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:19:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1llT9JS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783592378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ML/L3RG9vzghElHfVhk6hdaO8zJ0w3JzlZA2K+G9Qa4=;
	b=ZPL91EHUD2s43VPIZXhLKXT3zt6Wug6t0AIUjXVbBMuka8OdKD1+JO2yUN99b14+JnxIFQ
	XO5F7v5Q1JPcZAaAffQ9ObpXSBVkIJ4cZZMZJw7RQflKMaq8X/IB47Iw6d9yt2a1rG/SZm
	3k1Bw0my+cStunu+5wPhDGHSeT/lPIo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q1llT9JS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783592378;
	b=tibFx3Dm/k5TFPSoZ3SsZQNOKCZb08L/T0NS9tSbmh6Z0Bfs249Qj7qSLxS/OsE92b81kC
	FvMZgijJYx/SpVEYLqEIV7uln5CPFgaxHkSav06TTTZ9WeYBQCq7hYS0Znzy828OrVENn8
	gMkiDqp8LaSoSXue56LK/yQHjBzYh54=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A748436FC;
	Thu,  9 Jul 2026 10:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CB51F000E9;
	Thu,  9 Jul 2026 10:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783592377;
	bh=ML/L3RG9vzghElHfVhk6hdaO8zJ0w3JzlZA2K+G9Qa4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q1llT9JSAyfvy6CoqoHafjDYCbFjdX7VbJkD70OtQZMjidgCNM34p1ZckuXe5q204
	 IJOSlM2sSH2S/v9wI4h0aswqaj3WkJ6hY4bJYjtzdoeQ8lOCnVLfeswLov0+LtJtfV
	 uaKeVfKOFNVHl6GkTDWpOtykrQhE+5v0YbnNa1txmTDtNOjKY9tGM0ZaaRbpkCA4QP
	 HqGUTS3Yp2B/zQULfepH6HyT8aBc05nP6nsa9srCR5lDJEmlA4O/a4VejQAV3Lrott
	 H559BWmo59LEWcMxiB5cJPL8cxc+7WFbjkZnvpLWNaYG8HZRdpSpOfoOUWq9hW5UrI
	 36lAWOUyzCPSQ==
Message-ID: <f59dc8c8-d2e2-47d0-9f26-f2efb23379a8@kernel.org>
Date: Thu, 9 Jul 2026 12:19:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org, usama.arif@linux.dev,
 hughd@google.com, willy@infradead.org, ryan.roberts@arm.com,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <ak9Qe1G7Rv3HF6ZR@ashevche-desk.local>
 <dfa83e42-4f27-4c38-8796-b64a791788d9@kernel.org>
 <ak9zcbG_WvLpCCzj@ashevche-desk.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ak9zcbG_WvLpCCzj@ashevche-desk.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7cuaribymf5s1bdssxib17xwyt41qieu
X-Rspamd-Queue-Id: 001F38000A
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783592377-819398
X-HE-Meta: U2FsdGVkX1/4K1uY3Nv6uFDbJ+fCxMLbaydcCEp5L7lO6EETT8463Vi7d0kcKSasBcKpIA7yyIOLysGBL7bPMCfe+J5I+7MFHrnKj9S2/ELYzp8mu0TBtJFt+alYjAe19hIOkdReve6abia8ptTHMrzu+rZD0mrVVegs6gAUMEYC9w4ENfmHLDtk0L42gN95MYSvku7Zh5HNawDK7nZomVylXo2TYSqn4IbKZUY5KEUArIYkPXS0F13HPAOqR3+g0nWOymA5LfWaIRNi4meQvTW6J8trVtZpHdDmQJVe0stB9omr7Pql95Vf/L5O7RJ8fXTgdK6zm17FJ/uud+t9JDO7wmdFsgx/WfujDYE/J6jgQ63PiSlqzqjoS2aqsQLzKIza2qtofQZvG7xTag2qvmT5hfb9+oTr17gDIIcdbEBTFc4wVrwxaL0lMc48NuPicfouxRpwoMcqeIAyrnoD2T2iUjaILRv1gwEodPibvX0zEnQMrTIbY9IVRz0hf8FqAOaI9+1rW7T5UpqsPtnNblwtc6hTWW2TxAlitekKU+YdMl/aS0JFTKn/LRYxoEzto3Oh7UtyU+DULf+mq3MZt2quxmq+f0r2twZ+d/VOaC6/qab9m42yl/0geGGWpHvORsdWi2yiVjy4n5t3wBJWyrhQeoOJBMNfFUnsMeeImrLsAuDvdEtFEgonJJB9K9eD1L2JkQewpact0OhEZ7jFhcCwNx5cICO4ptJD/VhZc1ebzAaDbbBUNAxQbhzWtAZALacdobniod1eDnK6E+nSlB7s2BJnDxLAHCKqk3HwUUzeI26B29PudC6dfjqBUKSbKN8EP+EKjpj+iSHTCHgBg4BHLn5twrqgkZhAtbE8bY0ZPyg5pJEz8HVDSzQRXbOxdHH5qmvdBgO73iOcEUbe+cia1YWUHBIp9LxNik13J5OIWpowWgDDs1D0CATzAZe/XypzhFDhTc+W6s7jo0Z
 ci4yZthq
 NB1CucKY63ANMIQIIrX5qHeWVRXhiYI71JNeAaSuTA4pi/RN97KyH9Tozdf6JTojysmxUUUGREpiwDC0RRLdJv7IYS/1n7U47UPWUYYofpeyRUO/hYZMWHIrBbtoHHYN9L9yQkAc4diT25I68k2Oec3skBovfEgyFLknY3L+Cw9lRR2BQF/WmAFoXQ9NmLd+B8nVFiA2Pv3EgqXTJnmQUB7SvAyWqcsasAnkGCSRbN3dt/i/pRMLZ71InZL94pm56K0xO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 12:09, Andy Shevchenko wrote:
> On Thu, Jul 09, 2026 at 11:12:58AM +0200, David Hildenbrand (Arm) wrote:
>> On 7/9/26 09:40, Andy Shevchenko wrote:
> 
>>>
>>> FWIW, you may move these to be after...
>>
>> We generally don't handle it like that in MM. Maybe one day we'll switch over
>> and document it accordingly.
>>
>> For now, having selected patches doing this differently is not any helpful.
> 
> Can you elaborate "differently"? Except a big noise and churn in the commit message
> I do not see any benefit of doing the "old" way. Lately I saw some patch-bot messages
> from Andrew, I assume he updates his scripts towards newer tooling, which may be
> a good sign that the (good) changes are still possible.

Take a look at the patches that go upstream from Andrew, where he still adds
additional Cc above his SOB.

We're planning a transition to a different mm model, as Andrew prepares for his
(partial :) ) retirement. We can discuss such things once the time has come, and
come to an agreement within the MM community.

This is not the time to have this discussion again, let's focus on the details
of the patch here, please.

> 
> [...]
> 
>>>
>>> The above is quite duplicative with what we have in lib/vsprintf.c. Have you considered
>>> using something from there instead? (Yes, it might require some functions to be wrapped
>>> or dropped from static.)
>>
>> Which part in particular do you have in mind?
>>
>> num_to_str() does not apply due to the u128.
>>
>> We could have u128 variant that we would only provide with __SIZEOF_INT128__
>>
>> int num128_to_str(char *buf, int size, u128 num, unsigned int width)
>>
>> And then have the code pass the value instead of a pointer to the value. A bit
>> tricky to handle this based on conditional __SIZEOF_INT128__ support, but could
>> be done.
>>
>> Not sure if that is really what we want here, though. ptval_bytes_to_hex_str()
>> is pretty ... simple :)
>>
>> I didn't immediately spot a replacement for PTVAL_STR_MAX.
> 
> I referred mostly to special_hex_number().

Only the .field_width = 2 + 2 * (size) in special_hex_spec() seems a bit related
(although different, because we don't want the leading 0x).

Like Petr says, I don't immediately see how this can easily be reused, but maybe
there is a way @Anshuman, @Petr

-- 
Cheers,

David

