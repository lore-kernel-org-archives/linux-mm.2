Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62B18CD98E6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 04:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559366B0088; Fri, 19 Jun 2026 00:44:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509D56B008A; Fri, 19 Jun 2026 00:44:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9026B008C; Fri, 19 Jun 2026 00:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 142266B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:44:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9AFB81A0339
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:44:52 +0000 (UTC)
X-FDA: 84895422024.17.05BF06E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8A4161C000B
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:44:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P9xMpzZA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781844290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZRxrNaXMUb1YLJrXKm9qGVCUVyefQ+jPumrFbXRQBY=;
	b=UDHBsIYLq14RTIwvZIc5Y1o7Vk66q0Zc9tHIhbF+xRffd5Tkg166O4zMDOND+eeD/H+3gz
	JVoW8OLCfsCo5rT0Pp4JGC7KRWQTC6Kuy37cqHsavndO9zMo5htd5MvI2LocZrXgBjmrt7
	uNdRss0ATitNlXsqhALrNzwN6a7Clhs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=P9xMpzZA;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781844290;
	b=6jKzfDBnA1lWlFvljbu8d2KQ3dQ0d3L2Wm8YsAvmuLwVr4qjkqg1++w70sH2tJhBhMRBiy
	kngphPKln07W7gRoZYzzDnN/xk1oy6IswgJsGiozZBbYIYKkXst3hXZ8DV2aNzgz8xHRo0
	/z4POrACfBwlBqf2WnFlo58MnpnAVMQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A894293F;
	Thu, 18 Jun 2026 21:44:44 -0700 (PDT)
Received: from [10.164.148.42] (D3H2TH2F54.blr.arm.com [10.164.148.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F07F53F632;
	Thu, 18 Jun 2026 21:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781844289; bh=ps5ieMGO5BqQTpSXeGILcJmIGXlH2aB1crQD4y2zbKA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=P9xMpzZA3w4Ud4GhNZYAR7rMtLEydQwCTF5BmTXmZvPjLCv1UXfUP8+r8Iq8CbCLQ
	 nRrOkqVf1Wr8M0pq84KEAZLTFtdvS80erxNi0JgM/Kw6LvYGCLadma1qHOiO2oStX9
	 L5zWdZrvA5KAhMLYETPu4C+RFIalR3vIj8I+cxO0=
Message-ID: <7b4f284c-9659-4422-a452-e67dcbfb0140@arm.com>
Date: Fri, 19 Jun 2026 10:14:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] kasan: hw_tags: Add boot option to elide free
 time poisoning
To: Isaac Manjarres <isaacmanjarres@google.com>
Cc: ryabinin.a.a@gmail.com, akpm@linux-foundation.org, corbet@lwn.net,
 glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
 vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, kaleshsingh@google.com, 21cnbao@gmail.com,
 david@kernel.org, will@kernel.org, catalin.marinas@arm.com
References: <20260612044425.763060-1-dev.jain@arm.com>
 <20260612044425.763060-3-dev.jain@arm.com> <aiyi5flNkNNm0pSR@google.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aiyi5flNkNNm0pSR@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8A4161C000B
X-Stat-Signature: sxncr7oq3iw5uoiyd5mr4uxjuh1mozio
X-Rspam-User: 
X-HE-Tag: 1781844290-697287
X-HE-Meta: U2FsdGVkX194p3MfIOAMtSF+BL9VRNhfGo1YLsV4f9+gEe3RQwrM0RXfCabDLrlUHFc5ItlEU16QEzU4Hz4JmXqy8YYw30E8BAHZhU/scjaVQr5MClOMGnRx0XGQdFzKVvgfzYRkWXTabhhYMinPkjAB+33Gj/Bk0QJlFIz50cRewmo5cp9mcxqHq60H5cZLxn/ajNNyoBFtkeaQNPy9+qTvQ4an+SRoi87kY5m5VJqdLrwoMguyEY2HL8hFp33FZ3VX2Fs7wjZZAMp/eRMm+h/zjGkAMHvuIHkwmsbmn8/bEkqkFBEZwsxYy7KbTaBY7j2RJxBByzIZ31zA1KQdNkBcupViup/KEL3WgzrT1JfwGPyHQWCWzl+caNGCZRCfAz+JB2TjR/LICpWMag4vqhINVdb4e/qoNBBT+VAXc1+Q/uEqRJJ4/WmQAQE8MCg5taFDYPzvwwdASp1mPgegilb+xlo8+xufLOuUO3jNddKvpQZpfq1XF6G7QgzOIVSrUwRRjExcGQqcnkzoY9G1DUMJcWpSqlJAi+zq68xOc09lf5VmJqp7vroHz3/pYT1qKA5aD4u5yoTyqT8Kc+CZA4R6jfqX2xg2jVh0hRlDXAhDJsAjon87PvpeeIyjYqPuzvOP0okj5t3Je+ptNa6R7jsbK74Iseom18Cj5x+uDQo12batrI2Em+EVcuaWnWOw7G/xITDjanM7G1lHSy9QeV7Bo3IrXdde2UEGIyKqN7lxpfG7HI8iuFxtaG9bs9IheMeT21nv6sGParYnTU7RGmAb1ZmRbyqsPj1Tkk3ycFy1aKaEjgWkWTB7YySZL0/9egYgB5Dip0ny3qm9EvjgMyZQlFVEr2p5Qcuh0f3QO93tMf0AfztEExWdd8S5Bkb8u0J20fJrN4Pm908rjxqTb1nGTI9WJlhmQcc9wNGuCwI6n/aXBLeBMqzGutwWSsKABhmOV44zsdcAqyxR5yY
 Ve5J6i7M
 hINt/umTz5cULlKMlm8e5VTydNwX3d3jDBNR4eluT0qeiw1JXnqVNXby0k9BfFd9zyoZf8y1/1litrODxXmHeBVZO0kBJBapcDya0u2d4EjDEDMkq8xVXdjjhKOkV2Ne3mxwqtl2Z1zGfcpppV5tc8b4oF/wRGjUFVAdoJqUVt9/6xJkmiuxgpH7ZD410SkOyTruzQHSiKReWcVGYkJhZyvPcsVD0Vx5hrgYHqDF8XZYmMwUC1TIIL1BGtWT0ZZ/FHT2IcYZV1lvrMEhyegvcDObqWvZxAyC9SxC4XTwyoAykK2U1Kg1WGN23xWAzfUYIPmvP2+BbhF2m6KRxFcqZeTDvMlqLQlfRF1Icd1C7ImJEZlo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/06/26 5:53 am, Isaac Manjarres wrote:
> On Fri, Jun 12, 2026 at 04:44:24AM +0000, Dev Jain wrote:
>> diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
>> index fc9169a547662..4fa8abb312faa 100644
>> --- a/mm/kasan/kasan.h
>> +++ b/mm/kasan/kasan.h
>>  #ifdef CONFIG_KASAN_GENERIC
>> @@ -478,6 +489,16 @@ static inline u8 kasan_random_tag(void) { return 0; }
>>  
>>  static inline void kasan_poison(const void *addr, size_t size, u8 value, bool init)
>>  {
>> +	if (kasan_tag_only_on_alloc_enabled()) {
>> +		if ((value != KASAN_SLAB_REDZONE) && (value != KASAN_PAGE_REDZONE)) {
>> +			if (init)
>> +				memset((void *)kasan_reset_tag(addr), 0, size);
>> +			return;
>> +		}
>> +	}
>> +
>> +	value |= 0xF0;
>> +
> 
> I wonder if it would make more sense to have this as:
> 
> if (kasan_tag_only_on_alloc_enabled() && (value == KASAN_SLAB_FREE ||
>     value == KASAN_PAGE_FREE)) {
> 	if (init)
> 		memset((void *)kasan_reset_tag(addr), 0, size);
> 	return;
> }
> 
> That seems a bit clearer to me as to what it is that you're doing, and
> also makes it so that you don't have to do any bit manipulation
> on the value when you're filling in the redzones.

Ah so you mean, we can define KASAN_SLAB_FREE and KASAN_PAGE_FREE to be
different values, leaving KASAN_SLAB_REDZONE and KASAN_PAGE_REDZONE to
be 0xFE, the poison value. Yep I'll do that.
> 
> Thanks,
> Isaac


