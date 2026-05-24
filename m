Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC855CD5BB8
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 03:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3E9B6B0092; Sat, 23 May 2026 23:17:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16886B0095; Sat, 23 May 2026 23:17:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2DEA6B0096; Sat, 23 May 2026 23:17:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0A556B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 23:17:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6599E92E9B
	for <linux-mm@kvack.org>; Sun, 24 May 2026 03:17:36 +0000 (UTC)
X-FDA: 84800853312.05.F973C87
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf07.hostedemail.com (Postfix) with ESMTP id E005E40009
	for <linux-mm@kvack.org>; Sun, 24 May 2026 03:17:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="ibquG/4i";
	spf=pass (imf07.hostedemail.com: domain of wsw9603@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=wsw9603@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779592654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0VfTFbLd7nIbvJMxnmz75Fll57iwIRs2X4jpCHwQOQ=;
	b=QM/i3pdkT/woGpUWBPkxQ1EXegk5xXOcIy1FyfqWMDsIHEZ0kylDhQo3106lnU9TugNoB8
	OxPuzhpm0mYnGi8/IS7pjchkXmHcHetYZxZM22QMrvNiA0aHBNCbVNhXoFwM0dOOBdyeFw
	2J70ZJd0CEj/xVwI6FHEY29iYpxExjI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="ibquG/4i";
	spf=pass (imf07.hostedemail.com: domain of wsw9603@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=wsw9603@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779592654; a=rsa-sha256;
	cv=none;
	b=hByYOs6fR/S5fSaJ7oupJGnao/5u+YhA62CbKKZYSE7lWKNf8ha65Ans0WUbt8DWzdsXDB
	n5FZCWmTjIR2LKp84BPiHje3/rdV06DUvuvf26TzNoIyWtrIPQlhFF8+36QSN3QX4kZVBg
	frNyzHy0Hdpc8j2+ezr1lxiD9oUMhyA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=b0VfTFbLd7nIbvJMxnmz75Fll57iwIRs2X4jpCHwQOQ=;
	b=ibquG/4iE35dkPfmWRK9MLyFiIMpYWOb8F1vc63MIMmpelonu50hvDadtXFx/J
	/zPNrBxykEFSWqV7yZb381IlZjWB039saw59GTCtJrHb8JnRuv5escdXjr0tro+Q
	mV6QjRhDD3jzXgY8gkzIHK6O9kGgKf9Tzw6v6X76ctvTk=
Received: from [10.17.219.236] (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wDHXXi+bRJqbXQADA--.20870S2;
	Sun, 24 May 2026 11:17:19 +0800 (CST)
Message-ID: <9ab33234-34ec-473f-83ea-e5607b18b36f@163.com>
Date: Sun, 24 May 2026 11:17:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kasan/test: only do kmalloc_double_kzfree for generic
 mode
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260517071713.353579-1-wsw9603@163.com>
 <CA+fCnZcKwsY=QugBgPAV3GzU51oy5=Q8qGXXzOQAXW=M899umQ@mail.gmail.com>
Content-Language: en-US
From: wangwensheng <wsw9603@163.com>
In-Reply-To: <CA+fCnZcKwsY=QugBgPAV3GzU51oy5=Q8qGXXzOQAXW=M899umQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHXXi+bRJqbXQADA--.20870S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw1fCrykKr4fGr13Jry7KFg_yoW8tr1Dpr
	Z5tFy8AF4ktr1I93WUJF4q9348Aa97KF10qFyavwsY9Fy3G3WfKFn29ryqqFW8ur48ZF40
	y3Z0yry3Xwn8Z3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zR_HUkUUUUU=
X-Originating-IP: [223.93.186.229]
X-CM-SenderInfo: pzvzmliqt6il2tof0z/xtbC3QCqsmoSbcCQbgAA3u
X-Rspamd-Queue-Id: E005E40009
X-Stat-Signature: rauq4fg96jpiziguc5hjomgqnmbebys5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779592651-769506
X-HE-Meta: U2FsdGVkX1+pioPdq6pDHc5KVOqBnOvCJBbSzj9Dmx7umP/xakV+gUobB/x86S6eNu7ncKnAJgBGJEXTDvGSrWiKx7LWgksDSyMZYAoa1wAMJ/Szjxgq1RyKbF+r82ymczLhvs0MT2BrGvvHZT2gO1jqiD0qodCBqnGuQG9/0aDuuGG8OuymMZ+lnaR/jTeIy7UGGzTXzqBZ3Kdjb4w9+rWeWpyr2ksFVX7lMTO5DCDw2iufDSm93BqAuk4gxsWLUx79uo3gKQQ4ac3GX1A3AdYPmq01fyrIVZHuch9qxNJqYvauisqAxhVRHb2XoOXVtKFZnKXDBjkN/pes0XDQ8dZwvWjaNy0T30qHWqrpFaoTV5BEUnHMpPiLjpTJVYjOijNfqyvBl2dbl0QOufRBd7EVkoZKVP7y1R6+kFDcqk1NobU5aNQO5Ieyyb/YUBPTMo9iWCEAvDW+QuFuqdKRsfCnRuSILH/Gqc5TJ0JkrLmFzfkYnWflDMhy/jBDJLWN5f33kPAfqnK252q9aYf7Rx9YRcMSqBQfKIqXWo6Uud7WI9z0SfC4SwGUl7atctlatzxq+SmfBIc5yheCWHaKbXWfFfNZBjJolXrrFTwDzzBNsexZkGI8jEmvkhkO1BsNfbt6sK0T7QzSPdNNuicP3u+9pfObQwugf4jzqwx0E7AnrQKWv9ciPSsEoeiXMeJDtmnWKR1L/8wrzT8mr8d1He+R5vZQ39HO8Smp5coou35TwZgkBZ47bnl5gFbdYCPrMK5kml1JmofS3XgueDst+wjXgV/+POXq+dnhGVM3kI7vH5U78CSS+TtVxU8HaYF9Mom17nulD7E+7Q+UL6gO6ffg9fuV9oOkvcC5CZO6x7aJXlC2D0/TdSrxFd9g0ewFdzd6/4+AtzHniVbCtri6XPrbOIvhDEvYiqk8TKG7EM6lifGQhQINJXsU5W8xO6m07Wfimju7d9EqoCxhSSp
 tJYynda+
 4nqpI0WkAIBWMg5WcnJPzw/tFLVnImCFWV5duKNEWgoXWkXvP3cojf4dBLq700wp9mkIeNfWUKvsLs68RvnUYaa9qLVoeLkKfiTnPCSLUujGjdchzPPQ9aMXDAB/5n6D02AukE9qv5Gqt6eFjY7hhf8RGTi3d2GpN7SddcFZL9lAdO/BrHoxchsUML0QW+d3hIwaD0V2sAQZW8UFtfwG+ME0iEuwVfl2+PRNu/Infv7hXyaRNntMsMnnKmCVKgrHVWaKbFacgYSGhUfRnYof2mBUc0FxHYJCusPDKf8qYAvjoTyKbhdnLnhfZDD3DByOQ/GHSa70ReEza+kj8V5v5JZkZldhzooCgbBTkAcZ2azP3/TTrhob7TQpYgkeCveh6geNTt4xPeO5JG8298V9Zy/WIi0BTT/6FGh5fPdyjV5dNc8qzd09FIVw6Xn+1llPOnKxpvTNM5seAwF+FyEi6wsDEVFNKVbXE3eZJlLoNpZ2Nihy8M8KElcOs9Qp2JQn94d8ZGPYHSZHCb7IwU4xxdAx2zvBpoJTxS8UKSfmwUxy6g02E7qsVtelvAxb92YIgi9KmpsVyRQogxcdzdw8C7tMFJzoeEOLcREhqqLrEpkZWvkA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 5/21/26 02:19, Andrey Konovalov wrote:
> On Sun, May 17, 2026 at 9:17 AM Wang Wensheng <wsw9603@163.com> wrote:
>> kmalloc_double_kzfree() would corrupt kernel memory when the just
>> freed memory were allocated by another thread before the second
>> call to kfree_sensitive().
>>
>> This could not happen in GENERIC mode as it uses quarantine.
> Quite unfortunate to disable this test for HW_TAGS, but I don't see an
> easy way to resolve the issue otherwise.
>
>> Signed-off-by: Wang Wensheng <wsw9603@163.com>
>> ---
>>   mm/kasan/kasan_test_c.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
>> index 32d06cbf6a31..02e43ccc9f21 100644
>> --- a/mm/kasan/kasan_test_c.c
>> +++ b/mm/kasan/kasan_test_c.c
>> @@ -874,6 +874,12 @@ static void kmalloc_double_kzfree(struct kunit *test)
>>          char *ptr;
>>          size_t size = 16;
>>
>> +       /*
>> +        * Only generic KASAN uses quarantine, which could prevent the just freed
>> +        * memory from being allocated soon.
>> +        */
> Let's reword this to:
>
> With the tag-based KASAN modes, if the memory happens to be
> reallocated between the two frees and the new allocation tag happens
> to match the old one, the second free will cause a memory corruption.
> Resolving https://bugzilla.kernel.org/show_bug.cgi?id=212177 would
> help to deal with this. With Generic KASAN, it's effectively
> impossible for the memory to get reallocated due to the quarantine.
>
Thanks for your nice comment. I have sent a second version.
>> +       KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
>> +
>>          ptr = kmalloc(size, GFP_KERNEL);
>>          KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>>
>> --
>> 2.43.0
>>
>> --
>> You received this message because you are subscribed to the Google Groups "kasan-dev" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to kasan-dev+unsubscribe@googlegroups.com.
>> To view this discussion visit https://groups.google.com/d/msgid/kasan-dev/20260517071713.353579-1-wsw9603%40163.com.
> With the comment rewording:
>
> Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>


