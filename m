Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB0A7CD98E6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 05:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505996B0088; Fri, 19 Jun 2026 01:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B6686B008A; Fri, 19 Jun 2026 01:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CC2A6B008C; Fri, 19 Jun 2026 01:17:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 11E686B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:17:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 779E0A035D
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 05:17:36 +0000 (UTC)
X-FDA: 84895504512.04.47D4137
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8042A140003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 05:17:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jbC5I6eQ;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781846254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5bCXodPHqNgsofT7Pcf+Vb8635LLVTlUVg6eKsgs7g=;
	b=z7VfBXHK3F+h+ydtL/BSdIa9E6v9GENDuoV7xTQaSDI3h0Do9i2lz2tXSGhzq89k4vr+Kr
	C2QdQgscuPPjAz8WPavYet+DzTNwPOuaiehjQfZ0Jy8Iuv9uKJ4wPtL4GeZ7aTmWIyXz2/
	Vq3zjpBvSx8Vyn7Va3ojoE2RxOzDEl0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jbC5I6eQ;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781846254;
	b=dH7/MzOeWeoGBKC8a5IOnTizBmyWV3QNzFNAuqqsZp3Wrkd8RvWk0f/wmyJKv6RP1MDKz5
	c1DBgNUc9+982qjbq5UCwRm7fm4MsoPFDtsuwGWv+ZEHaM1THxkAaTdn9Hf6OjbIf4ZtPl
	3UIP4jioCxtFu8mcNqCX1iC16dJQpI8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E76614AAB;
	Thu, 18 Jun 2026 22:17:28 -0700 (PDT)
Received: from [10.164.148.42] (D3H2TH2F54.blr.arm.com [10.164.148.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BD7B3F763;
	Thu, 18 Jun 2026 22:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781846253; bh=UThYL4n3yi6FB/4PoyNwX/qX7QaXgn7Gb48t1iB6IKM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jbC5I6eQoGomv8iGJRU8jQqKcwcUpT/e7lp0AiVrdoygvnUoDpQjvVmjGorL3UAXP
	 w1GwO3Kp0D5vrukU9KyYZFT9t245gW6WCyFF1N0+HiO3wjEiGOqU+ePMrs++JmKKeZ
	 W8b3YrHwfkgim0X3khHlwDzSR8867W8+SDC7NVR4=
Message-ID: <5173a464-5f2c-431c-a3e3-16356f8cb873@arm.com>
Date: Fri, 19 Jun 2026 10:47:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
To: Ryan Roberts <ryan.roberts@arm.com>, ryabinin.a.a@gmail.com,
 akpm@linux-foundation.org, corbet@lwn.net
Cc: glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
 vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, anshuman.khandual@arm.com,
 kaleshsingh@google.com, 21cnbao@gmail.com, david@kernel.org,
 will@kernel.org, catalin.marinas@arm.com
References: <20260612044425.763060-1-dev.jain@arm.com>
 <dbc2800f-7880-486f-831c-ec9b6cedc005@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <dbc2800f-7880-486f-831c-ec9b6cedc005@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8042A140003
X-Rspam-User: 
X-Stat-Signature: 9xgope58yrjpfx7ec9rhjnjp6pq45crt
X-HE-Tag: 1781846254-860391
X-HE-Meta: U2FsdGVkX1/LFhOSdhv+mOEMQcCM4T4rHnO/pSTq6/cLq/YR7LTgixKs+kLl0Y2kwPbEnMUPJ0trkmLBspzHbIdh7w95A0AgTm2TvbR12qSyoRmCM+IGI6W1OYZobKK0K4OLTtbIjxBLpRQ1y1zSHZvk03VPd6pA4opJt6pXNVZUpW4DbDs97jsYYBP52h0fOI+/WqkIo79ylww27iKDnQxpdPQEsZliKcyRmWAlRR+OVff7Swx0lg51Ikj+iTJcWFJgxzfC05UETfLk3NumtmRRKrKEPUmf+lI1vyhygf4DBK187UD9OXqclBCv13Hnh1WLAVt9g/k7c3CA+WMxTiPyknwUxTC9In3u1821QRk7bq9VsOlpRYulxJ7Ce1N9WwiMwnIl3K2LZfGNGMofiQDMkOutEswKrgY85aTPgyZhhA4mo531T9l5t616GAz8LErQ27vSBviuM2IPBZBwQ264Ijwe3ER20xKmSvJRxg542GZ6WWWch4rly7t9qnS+nMaHX4x4SXV2xULdw2z6l1wT0GAHmdZR4bcne5MFQpscI269QSYGPnDWIk7wTFfIKqdEGEruKVrR9OBw9xiZeIzS8JYDCAGrcrNCViiCh/w/UcFyV3x7dSAKD4yfgVMkCnRCFr2aqkd96AxB3BDzGscbFdc03v/JZ6ATebMC1EbGr1j84Mo7VEMYJnWJdv4apH+Rdi0a5OANesFxk1hl0LhhfpeeVnihKoaS4PJhJ18a4tPf0pWxdCka1H2B5PIx+SWwaonAEXBUwmqEJgTq48KkcbjTnTah1Y0o01Y3D6G3IV/b+z2Yblyza4ZnZUOCNWndsr4ClGnny+LR4ST7WrpeZnqh4cMa5G3q1vIp6nPljV8ZP4C4ssxvLUpppYg5y8/3XUoFzMDuhWeH6EAvmnAJygpUR/FkIXmSB0c4vIkTVq18QypLqJ+kYP0Yeubn/VhyB2gwfJMxBLL13L1
 l9vIdeaB
 GXH7lSFutT9I4yokZu8crZoX12VMmQfGLjwJOmnZwRyqFQNZEZhS6uCQQlgYp0EtqXIWWO/721xCAaJd5yLbZOgBVuRj+IBOLjZPDVMuWOqTOxBiH6MOY3zqtBViUXKfo4WS6FYF3Ih8Qm96v1Xo9vSpc5x4DHXT8a1BDGYi2IBUAso7FLAHPIdj+YJ61RcoSQDyrzGPzBLRgcn3KWpUGKEwMR+5imdrreT6f4YObn4TomFnJmqgq6ICOXo518TzXzNnnVvvBzpSnC7K3GfFSBdPz3nsyDKAJKi3vVeFL6itFg0fQCNoCnwKv+uvX0f7uNQIbhic5oEE8kNss5m8Ck+Y/Xe9MuSXB8FkJiEETlbFrKqc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/06/26 7:18 pm, Ryan Roberts wrote:
> On 12/06/2026 05:44, Dev Jain wrote:
>> Introduce a boot option to tag only at allocation time of the objects. This
>> reduces KASAN MTE overhead, the tradeoff being reduced ability of
>> catching bugs.
>>
>> Now, when a memory object will be freed, it will retain the random tag it
>> had at allocation time. This compromises on catching UAF bugs, till the
>> time the object is not reallocated, at which point it will have a new
>> random tag.
>>
>> Hence, not catching "use-after-free-before-reallocation" and not catching
>> "double-free" will be the compromise for reduced KASAN overhead.
> 
> Does standard KASAN with HW_TAGS really detect double-free? How does it do that?
> I could imagine it testing the tags of memory being freed to see if they are set
> to the poison tag, but that would lead to false positives for the GFP_SKIP_KASAN
> case, surely?

Should have mentioned, the double-free check is only for slab objects, see
__kasan_slab_pre_free. So we won't be able to catch double-free here.

> 
> If I'm right, then the only downgrade this new mode causes is that if
> freed-but-not-yet-reallocated memory is accessed via it's dangling pointer, then
> that bad access is not detected. I think that would be benign in all the cases I
> can think of, so while it would be a problem for a debugging use case, it would
> unlikely be a problem for security enforcement?

Okay so you are saying that we won't catch the bug, but there is no security problem
because the dangling pointer is accessing memory which isn't in use by anyone else.


> 
> Thanks,
> Ryan
> 
> 
>>
>> This is an RFC because we are not clear about the performance benefit.
>>
>> Android folks, please help with testing!
>>
>> ---
>> Applies on Linus master (9716c086c8e8).
>>
>> Dev Jain (2):
>>   kasan: hw_tags: Use KASAN_PAGE_REDZONE for vmalloc redzoning
>>   kasan: hw_tags: Add boot option to elide free time poisoning
>>
>>  Documentation/dev-tools/kasan.rst |  4 +++
>>  mm/kasan/hw_tags.c                | 45 +++++++++++++++++++++++++++++--
>>  mm/kasan/kasan.h                  | 23 +++++++++++++++-
>>  3 files changed, 69 insertions(+), 3 deletions(-)
>>
> 


