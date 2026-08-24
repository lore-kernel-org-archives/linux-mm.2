Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BF8C5DF8C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 01:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D14BC6B008C; Sun, 23 Aug 2026 21:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5406B0092; Sun, 23 Aug 2026 21:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB2F6B0095; Sun, 23 Aug 2026 21:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A02E66B008C
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 21:21:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 224981C1955
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 01:21:10 +0000 (UTC)
X-FDA: 85134409500.18.ECDE425
Received: from mta1.migadu.com (out-167.mta1.migadu.com [95.215.58.167])
	by imf31.hostedemail.com (Postfix) with ESMTP id DBB9220002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 01:21:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pvt/GwiD";
	spf=pass (imf31.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.167 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787534468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Theh4T6Add59pX0LhPMTUYA2qQOPQmed+/gpl62hHA8=;
	b=PGq0ISvDKpPlbDQf/e5xnqNy0KxhhxV8Jrhir851Mn0A4zH7iIrAuqtdQvoSwWQ11Qg2jL
	EgYdiLTm8HyL3IhvX1sDSZnj1iCZkxDlDqASJJMTgbLaUwzbtcQ3NQ3bs9pq9qkQ4t5ijX
	/eRsV2GwZO4o2J+DjrQwX9Gl8P2A5kQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pvt/GwiD";
	spf=pass (imf31.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.167 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787534468;
	b=JbuOSHjiEoONO+V90qVx/Wy52nPAQd1O29yOkAqlkswU+zy4qfUnQuG7lPmvJkJsntFI9i
	LbPCVsFDAF+av1tayALNj5VuMxPjcVA8FakKju7dLc5pDLX5foWyX/GpBunMZdrEhmzBo9
	uGn2OicUyn4w8k8yVTRauWJ0xQH4Xt4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tHKh+slTFpiPiOoeSf2ClsDax09mea19PvArh25qvpg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787534466; v=1; x=1788139266;
 b=pvt/GwiDwjQIAl37VQnFXqgB6pOgfN0uLdnNkkNRyinTZ/AHQ8mzanaTQYhc5l+5kg/dd2qo
 urRE7IHmrpePIs8wZmy6kJyqRqfM1/oiGRmMne6j6uqRmGXWU4ifxU9hZy+/k9YNbjzObZJI+8x
 UvW1x1SodL6jdwQYtaJUvbwM=
X-Envelope-To: linux-mm@kvack.org
Received: from [192.168.109.123] (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 545dad8447bb8b3c;
	Mon, 24 Aug 2026 01:20:56 +0000
X-Mizu-Trace-ID: 545dad8447bb8b3c
X-Migadu-Flow: FLOW_OUT
Message-ID: <83a8c88a-54a6-4ebf-a5b4-a44e1d06a7d9@linux.dev>
Date: Mon, 24 Aug 2026 09:20:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Alexander Graf <graf@amazon.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Hongfu Li <lihongfu@kylinos.cn>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memblock: simplify reserve_mem_init error handling
To: Mike Rapoport <rppt@kernel.org>, Sang-Heon Jeon <ekffu200098@gmail.com>
References: <20260821033230.55210-1-hongfu.li@linux.dev>
 <20260822032327.3548986-1-ekffu200098@gmail.com>
 <aosD9E8ntZF1RLxz@kernel.org>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <aosD9E8ntZF1RLxz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rzkarti5b5s8erm1uhaey5pntkwtn9ig
X-Rspamd-Queue-Id: DBB9220002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787534467-968724
X-HE-Meta: U2FsdGVkX18xyDXqDKnYNnANaB0kmAP25Q2TCCOvHhkYcCDccXZVlipRXENoMwypX9iHE1TAvwVtoMgl5wDUxrm7mJlBn/SSS6IRqFM7joyYktgC36LqhM0cyk3P8s6IP9JPqtvT5X8IufhnDQlLQlqJEG9rSDe8ljrCw7GFg5sR6H9GNV9S9wb+I7/1yhsu1oTiW8LrMf9vaEkI/JuWE/iVLpuhw/1s0KTIJGNIMhM5+WVBnO+A613mnLpGrvhQBqKiY4LCX2EgvkYSdqf+qnRZw963Ae6t/9MNsSPk5ZTUjmjVaru2eOS+58LeW/AX346KLzTYdnFeelpVM7JOGQ1hR9PsEySwnBGjzjym1RGEPoQOJlUndzPhK+BUyg11/pSWqZw3wcxkWv3hhUhwh+DQzdzYmOdSlcVQfftrM10B3ywql3TkskozEjiku/g5brUPlAMq8MO/gwy4docQypvNOcHL0g3atqYrzfKA+ijZRAmxAYUGIASRqW58erNf7F28XUtoXxbTSajJ6rms/JfLkphXNR1u/+QuaEBQZ7S9aPb4cLuWrjUAVRtuTeABZfi3Ih86OelOBqwa5NmuT8IoiGOH/H7X0g99Ezexi7uyVLGB+r83VyUIslzPSK/BKkJZpspJ0URmSBSKbxtUyDWJHBNdOqd1290yVWC0ZZVaZ7H2Unc0wk6+obWDbEfJJIxRbJwi3oMgOYiStp08bJzdVfH2A3KwjGZv9p0vQjhetLr30taUxKtoqS4HR6aN2sOyDgnh/0FI/34M522HNG/bSAUailxcbNYS0JJZr4nBYEt9wd0h2WCUPFcfRoVwuizGZ5HGZ6hkE8hJ+pjkkkIwiTSDU9mj0WL2cWbLFZMNiIZvkyJJZgLMXdhQQHXspp6jB5eg4Y8sUN7zhNgBtFzwvZyufq3wRugiO+GBwWExf1lUCUU1fU6GK3DiMCHcxC/2uYgIHHEEqXp7A8M
 6msijp/U
 t+GzORhUjcAsHeU47VbLxkvVP/d+NZQGf7K4U6LeVlk1dRFrc5O+GgODwKyQgFt8vXBFQ3I0OuZFCDrQw4UwlG8Jg4yXEmOc4juFsQjvg2p7DAQhMA4qhGERcxKsntvepf7sqqMyL+eNTzBn4QmjufEDOCsMucnyZ3Bs5TocZfUt/VTb2zWzrZz4qSIkkag/S7EIcQfIKNbiTecYmdlniJcScQGJonlhI66kt2AaonNtZPrrUEB+lqdAG6YAzyjketIfqD3y32uyQ+otG7HK9pq2pp+vTlHWrNl5BIjn5/1+1Zj82c8/9ZdEyXGv+bWy3MVX0DESEN/Rx2wXPsb2wvvdx6MsGvjFek5Jpzc7PpxTvOqFwszot8DE2t51EunBqfeco7aHsCvkTNiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/23/26 10:30 PM, Mike Rapoport wrote:
> On Sat, Aug 22, 2026 at 12:23:23PM +0900, Sang-Heon Jeon wrote:
>> On Fri, Aug 21, 2026 at 11:32:30AM +0800, Hongfu Li wrote:
>>> Return prepare_kho_fdt() directly instead of assigning to a local and
>>> returning it on both success and failure paths.
>> Thanks for the patch, but the same change was already posted [1].
>> As mentioned in the cover letter, I can send it as a separate patch
>> if needed.
> Please send it as as separate patch, as Mark requested.
>
> Hongfu, I'm planning take that one because he was the first.

OK, understood. I withdraw this patch. Thanks.

>> [1] https://lore.kernel.org/all/20260723184538.3888637-37-ekffu200098@gmail.com/
>>
>> Best Regards,
>> Sang-Heon Jeon

-- 
Best regards,
Hongfu


