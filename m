Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D689FC98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 09:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 032266B00A4; Sat, 26 Sep 2026 05:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24DE6B00A5; Sat, 26 Sep 2026 05:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62036B00A6; Sat, 26 Sep 2026 05:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B051C6B00A4
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 05:30:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3A4F81206E2
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:30:59 +0000 (UTC)
X-FDA: 85255394238.27.9570A42
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf20.hostedemail.com (Postfix) with ESMTP id 879561C0004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 09:30:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kzL1QS5E;
	spf=pass (imf20.hostedemail.com: domain of 3z5C3agkKCCwbIZcVaIPcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3z5C3agkKCCwbIZcVaIPcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790415057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qPPM7SXCBhuzMJBn4w/Iue6D6iAI4Dgq9juqp97Dizc=;
	b=tsIYD09DDhBBmXk+qgSMpbjo+VK3Wcd4BX1ZV+dTLMQsqS4Spydqbm9L+2X6nfzAkF8aT5
	wQsaHKGmDMHY0y9NuvoXOw/FgEwzTgM7xPYViMPlOfbjF3TPT3ectRicPWIXnbDEexd4S8
	Rd6dcssvalC0HNygVxsLh7CaiXkxyVQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kzL1QS5E;
	spf=pass (imf20.hostedemail.com: domain of 3z5C3agkKCCwbIZcVaIPcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--tarunsahu.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3z5C3agkKCCwbIZcVaIPcOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790415057;
	b=TZQM9qEgj4lmd8LKwPptN6yDbU/5VUfXhpG29E4AbVI7WEQaJwE/awCztmyWj9XA5LVJTP
	By5SBTHHT2dj9b/9Czi/BAWInglcooNpyD1BRqIugzcZg1Sm2Y39nalCFauqGD7pqiCOge
	3c/N+CRyG8ErpGoebJ47DXG3mUzTWK0=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c294442d71dso185339566b.2
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 02:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790415056; x=1791019856; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qPPM7SXCBhuzMJBn4w/Iue6D6iAI4Dgq9juqp97Dizc=;
        b=kzL1QS5EA/wKbNwM+WZbuy9LP02wDNP4FvDX9uZpJ3zhySrD15dd7ZVoElorNEmyaF
         4bOfBurQmLc2wd1R7lqyGRKSgDHCBUtCBluJ6UYVWgLvAbMCWcNof8n+oeF/ojj6Etjo
         IcVfyJEphUEMtxQVoFViq6ZC9LvYCOnW0l3h0a6p9DyKChv56ulYsKu1uq459FHvxBrL
         xWumpLzEKo/36P9P/gLhwGjkwR9iYX23pIUqIU3wYJ235+bFFmgY1BMguPLyq+galoCH
         hpYbzdM5MUqNc5ohk3uU8kXHh3vjf8hdgcyGrC5lo/pWUX2DIQqhwOpYMll4tCKsThVP
         W9wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790415056; x=1791019856;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qPPM7SXCBhuzMJBn4w/Iue6D6iAI4Dgq9juqp97Dizc=;
        b=rUFmcoWbFl2GIxLs16B+L86LKjsg6Zqj81HHd1x03Waj4HjNJfLqAszJ9nyHwKrzXU
         XeyWQBQdpuIYKcCYpMf0U8x1H7Y5ikbQHv51xm0hPwmbPABaJA3mVatO2IooY7QLHavu
         jImr1HNni7ExrF8qgQAWxzhmV+ki2ABDsy+QLfVNGQGetep0Smjc2XpgRu3ZbQBgerF7
         2nEtrs7j8uDFYIt1WONgSxWPvJzUFzq8XkNtWGr9bWkyqZmJEtSzyuyWVVEQfhVuo3fk
         N3tFI7MxzZSGZKUftJHwwOFrrRvV6ANbLf20GwEqIs5uPp3wmbxgl0cyanhotAFaNqZw
         0+6Q==
X-Forwarded-Encrypted: i=1; AKwUvByU7sN62l1kVjjPDJrnp8+6XXqI9c4Z18WZz10uiIpzajxbGWgs23gVa4svyOYTj88STcz+kUzRwQ==@kvack.org
X-Gm-Message-State: AFuF++m708QBT0U5Ohve+7SbBWlI+INbyihaX7oUKOUbgRj8+OywXcBL
	hyQTVCHcXvBTrZVA73lbyUpa1ZnAhdwGci82M/0ruAW9y+qMGofD6zsnxn/JK4EEFTrqY17IK3J
	UjgtYVlmiOzx6ypcoFA==
X-Received: from ejiv7.prod.google.com ([2002:a17:906:2f07:b0:c2a:bb40:5656])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3f19:b0:c29:3c21:ee69 with SMTP id a640c23a62f3a-c2ae9f3157dmr395838166b.23.1790415055784;
 Sat, 26 Sep 2026 02:30:55 -0700 (PDT)
Date: Sat, 26 Sep 2026 09:30:55 +0000
In-Reply-To: <2vxzwlsj5r83.fsf@kernel.org>
Mime-Version: 1.0
References: <20260918002239.4024231-1-tarunsahu@google.com> <2vxzwlsj5r83.fsf@kernel.org>
Message-ID: <9huzh5jcnyuo.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v2 1/2] memblock: drop for_each_memblock_type() and open
 code its users
From: tarunsahu@google.com
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	dmatlack@google.com, Mike Rapoport <rppt@kernel.org>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, dev.jain@arm.com, 
	Pratyush Yadav <pratyush@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 879561C0004
X-Stat-Signature: qtmy8ipqz7zifdu66owr54fdqy9kfpbg
X-HE-Tag: 1790415057-287199
X-HE-Meta: U2FsdGVkX19YBeLn58TRDF7MBC9oEJZTCr9G0pGJwjZjC2ZaKeLb/Q1zW2l2OrqblvlEUjd0RShO9C1ybdin8qh1vIvGFKb9t+3OQoTcbgDCS83UFBxggAzLiOz6b/QUKTyD2EKy60UjqldBeEwc9LOk2a1m5cgwNx9u+B4Rigrb+pfeBQoc7g9Lr/0PNxARnflDQIkpTbQZyqux9OUBHARd4uCLcakty07cmUOYU+Ce5vt+XcfnvlBY6UxSjgFhFDH68391G7SokfrNLMv7OgCaEXm80JLF/S/EGR9Vr/wg747ma0UiSFM8N0k30IV/OaC0lkR7IGyxo/5NhjjB5bTFf+ckL2lV8pD9/Kf07WJw9TbRwPVyCHWaUNBgPJkuyL8FKcdlW+gXc8u0hYvPXoSZAeNe6qZ1KzAYo8KzfZYcI+3W1a1ESKC4W0wC4BzwhMDGjJl0KW4JnM4U+ZJHjWP4rntrthAV+YcsqtgLUFjW6TCojqgsnwzKLQZIuAWMIfL18nSkDQTKDGXs3c1anPk073Ib4J7wLvDFUkMyHdHpB5ewKxGXxxoNMa5eEc/8uoFCidHgB/AfUagYCCYbRZeB+W0bH5TI482Y8fbfnIjN4yp8qKCxRyqsaJm3w/wA5Z05Jf5pBfu6G+KWErCaqRmjicOBcGCrJSL+KbMT7oIwcuG2ePJZ2YmmflEPoQVuL1S9m5cPijw7UpP5l1wm2c0DhFA9m5wBkmmQgHznydJ+xy8IsR4HZobaYhIs70fzEXy9wPYZS/lloKCIljjxsltexAKqdyX+K0HgVBynlfeacWZN1ivtjCS9ji2ZlkFqeEPPG+QJ3Q2q1RJSXmqHqZcc5531OLYoD0QFcTo1NvhvOvSlFZSmeRKCwGOVJYifxoxDj9nZ5DIMowbScqZrXswz12RS8/VCC67kjGtrEfjqxxeye+Kaefb+o4QnoCegA4AkhboxOveH91bWiOE
 tHkeLZS+
 uHjhZ/BKqYWnZC6o1TjeFO1aIfg/KPH5FQABp6EkcHItmTPMeprytzpiPXLBzVV6uQf4ZsBr4MPe5/f9fRyi7olaRnRKjjGpnqC+QZvn8QZhxWcdmk21z+gDXM2RGI/3G3oO3OfoivoZuJ4UFB34sxr3IIcTZhwl0QtF5FUrQWbdhJP5nZyNAQVDRVFwbkfV+b3RVfi+JaQwXv2BybH061j60aNnS+SP+ion9yxk5KFHMOSOw9iuiWrVMC+2Y30K48jJcqj7yxsCssataic0zuBoob57sctbJNk55atSQuxYh96anjs8a4plEu4Y61Ysf9LSS0u7sBI4rtc3Zy11pTu1GCYfiIeqIdb7Cxxm3vmSquwMr7wXAAr13liLVMy8ZwUjA3SdtIcuvj0c+PEnPT1fbJy7g2d5RFW2AAuXz8coGq3WiKky0ziy+kyrPd3PlyXJCO2AcMAaP+IJtn2U39aTSWw0uJdGicrpNQyRzZ/I9ybtIw30K644tZDVJZDND855o960pzKJEZgxuAZ1P7D0YJe/hW8EcMpunSn10hMnDk8IXw6SMl6tywzDmR+ymgzLVJh14sZUtU0Nk33X84qkQfhWnMq3OU+G222T+3aVi5y898Y6Ym2voYbpH6qddqS5O+epgQ5WrBsxxvA10rfc48A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pratyush Yadav <pratyush@kernel.org> writes:

> On Fri, Sep 18 2026, Tarun Sahu wrote:
>
>> for_each_memblock_type() always starts the iteration at index 0 and its
>> body is a trivial 'for' loop, so it hides very little. It also gets in
>> the way of iterating from an arbitrary index, which the next patch
>> needs.
>>
>> Remove the macro and open code its three users: memblock_add_range(),
>> memblock_isolate_range() and memblock_dump(). While at it, move the
>> region pointer into the loop body scope.
>>
>> No functional change.
>>
>> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> ---
>>  mm/memblock.c | 14 ++++++--------
>>  1 file changed, 6 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index 9ce86349a29f..5aae75d34dec 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -155,11 +155,6 @@ struct memblock_type physmem = {
>>   */
>>  static __refdata struct memblock_type *memblock_memory = &memblock.memory;
>>  
>> -#define for_each_memblock_type(i, memblock_type, rgn)			\
>> -	for (i = 0, rgn = &memblock_type->regions[0];			\
>> -	     i < memblock_type->cnt;					\
>> -	     i++, rgn = &memblock_type->regions[i])
>> -
>>  #define memblock_dbg(fmt, ...)						\
>>  	do {								\
>>  		if (memblock_debug)					\
>> @@ -651,7 +646,8 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>>  	base = obase;
>>  	nr_new = 0;
>>  
>> -	for_each_memblock_type(idx, type, rgn) {
>> +	for (idx = 0; idx < type->cnt; idx++) {
>> +		rgn = &type->regions[idx];
>
> Nit: this is really odd to read. You assign rgn and then declare rbase
> and rend. Doesn't checkpatch complain?

I kept it there to minimize the changes in the patch as the variable was
already defined there. and unfortunately, checkpatch did not throw any error.

Regrardless, Good idea. I updated in v3 here:
https://lore.kernel.org/all/20260926092448.4090401-1-tarunsahu@google.com/

>
> Regardless, I reckon it would be a lot nicer to read of you move the
> declaration of rgn into the loop. Same for the others below.
>
> LGTM otherwise, so after fixing this up, feel free to add:
>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Done! Thanks for reviewing it.

>
>>  		phys_addr_t rbase = rgn->base;
>>  		phys_addr_t rend = rbase + rgn->size;
>>  
>> @@ -827,7 +823,8 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>>  		if (memblock_double_array(type, base, size) < 0)
>>  			return -ENOMEM;
>>  
>> -	for_each_memblock_type(idx, type, rgn) {
>> +	for (idx = 0; idx < type->cnt; idx++) {
>> +		rgn = &type->regions[idx];
>>  		phys_addr_t rbase = rgn->base;
>>  		phys_addr_t rend = rbase + rgn->size;
>>  
>> @@ -2198,7 +2195,8 @@ static void __init_memblock memblock_dump(struct memblock_type *type)
>>  
>>  	pr_info(" %s.cnt  = 0x%lx\n", type->name, type->cnt);
>>  
>> -	for_each_memblock_type(idx, type, rgn) {
>> +	for (idx = 0; idx < type->cnt; idx++) {
>> +		rgn = &type->regions[idx];
>>  		char nid_buf[32] = "";
>>  
>>  		base = rgn->base;
>
> -- 
> Regards,
> Pratyush Yadav

