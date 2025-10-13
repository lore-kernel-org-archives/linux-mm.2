Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9082CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 04:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07B9D8E0008; Mon, 13 Oct 2025 00:43:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053298E0002; Mon, 13 Oct 2025 00:43:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1C98E0008; Mon, 13 Oct 2025 00:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC5C28E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 00:43:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2ACEC160262
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:43:00 +0000 (UTC)
X-FDA: 83991846120.24.A987E3F
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3849E140002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:42:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FdBkcPvM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760330578; a=rsa-sha256;
	cv=none;
	b=nD5Jo1+8zXr9VHuExjeceti1wjrppUQ4qlx9hEHYZ7SB5kE9IZSxHBaVaiA8bxhJnFQDgX
	seQIllsdTvALsTa1Aeyf2GcyyILtb6sgpFcYY6z3eHoumsl8emZeGp/d6jJUHugEG3n8T7
	Bwc/KqVZxc9aauffBy9hmwfTM0XfAzk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FdBkcPvM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760330578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ymR7QfQsF87bu4c+bQc9EVZLMVmDMUhrDS31dRLbS4=;
	b=I87ebHsIXTfhWjfAZ7Hhc+v/ZsYzOHl6cN/Sg0wDcMB2oERFhY1RxorJ6ohclKOgrxUjV7
	PFcPDhvk5L44Z2RdBCyEU/Rr8aLN/3/2JgjDHfGubarj49LIQSAxz1yhRCx6kA9Uc17SOe
	wAqrKuUzrdotL4s/Yi9Q9Eje1bSb2BM=
Message-ID: <f12dfacb-05dd-4b22-90eb-fcc1a8ed552b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760330576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8ymR7QfQsF87bu4c+bQc9EVZLMVmDMUhrDS31dRLbS4=;
	b=FdBkcPvMmknwE4VwbFFFviJ83DTLQvoTOVrIKCsCw+mSzfMSPz972QNOYpoY6cZzHFDtvA
	NhK45tz5y1KoFne5MX7p3OWdYXGc0yKGiPUZrRDp/Uh2GaqB1Dr+TSQNkaBPHLh+AhfsTV
	JkyMCfHDF4O277B9ZavDsERWR+FeUIs=
Date: Mon, 13 Oct 2025 12:42:44 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC 1/1] mm/ksm: Add recovery mechanism for memory
 failures
Content-Language: en-US
To: Miaohe Lin <linmiaohe@huawei.com>, qiuxu.zhuo@intel.com
Cc: Longlong Xia <xialonglong2025@163.com>, nao.horiguchi@gmail.com,
 akpm@linux-foundation.org, wangkefeng.wang@huawei.com, xu.xin16@zte.com.cn,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Longlong Xia <xialonglong@kylinos.cn>, david@redhat.com
References: <20251009070045.2011920-1-xialonglong2025@163.com>
 <20251009070045.2011920-2-xialonglong2025@163.com>
 <CABzRoyYfx0QPgGG4WYEYmT8-J10ToRCUStd3tWC0CtT_D8ctiQ@mail.gmail.com>
 <CABzRoyYK38imLh6zN2DZKPRyQrJkKyvpswqJAsWzEeECtOxaMA@mail.gmail.com>
 <55370eb6-9798-0f46-2301-d5f66528411b@huawei.com>
 <077882e3-f69f-44f3-aa74-b325721beb42@linux.dev>
 <839b72b8-55dc-4f4e-b1da-6f24ecf9446f@huawei.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <839b72b8-55dc-4f4e-b1da-6f24ecf9446f@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3849E140002
X-Stat-Signature: p4dkhc5nmeyzjuzn8wx6cxg1sg78tp3c
X-HE-Tag: 1760330578-229710
X-HE-Meta: U2FsdGVkX1+ejENYx13DvJkHpN/0hRXEXAyNNkcS+ioqPLxLLc/qyBsPsM5ZzWQqhH666Sd4KIo2Ew1DtPCCr3PY4EPrDSVhJQ/nyHDd+r7dv5y5fK5Q7uR0NEBtulHGg2fO1//G40xQ4+0pQ1RtoLp7pUomSGQRtOobl5UbQ+Mm1P3Twld2nK+9gRv3kgxlVzIrKkX72p9nSgoHqVPve/ViIexqul2GZvHHRGJX05LDaX9jzstmahBPYUPkdHMLReF0jI2U7X+j6MukIqRtjl4qRdzs+ZszDJ16XFymjLrytGXa35KTbIU/ueHMKM6OJiXeKLPNmzHqQWEEM3oC5LWEAIu5272Xgi/9NG6Ah2rb6BB9w1Os4YJM91WG0YtnucV2QDuw6GY14xk0tckfmXv74jeVhNzhdJ6EUervvIsbAEos6R1eoJkLL7yBrrAeUv+KpRYKKos+MjoAdL22j4fyH2l4CSRMllDVVGqb1eNlUuXUF97YGEG6aVwcZeAoURIlUtcb9KMe50JAgG3RxsZruqEU2QEmhGsDp5mSKYT9LN4y3z0MAIKzL4HxB8eqJY1SCMwFgaoEuRyPDtLjAgPb++LVoDuUjHMoXgau5jWxuOwo5DZiGoKxKDsmku3cI7FkWRE4GJGJzxrLcU74aiyffgC3k73fxgl0z9z16o3Qrt4rwhbM/Vx6rMjBGmQK6704cyve2L0vBPDvPgXUYjYkB7Z9Yqas73YoClcijFktyCH5eqDKCLZXtv4dYdejJk2ctA1bYdqIcKJ/uQEvjgohWnesnTApqouamSVU+GS8Lo6FT2W8LKVnD3b/T6TNAlvBy4q8e+xZfmbJlisF/cauHM+1PhJZ0LIMNfxIA+9jfnCcBl6V3WbgBEWKNn+38tsvBt/F9hwadu+MKqno8yZ8LYlTTc2euHpHE+FrRX+O4ylTLxnVAf1iAJ7QdbkbXeFXNO2Rw10h86xR8Am
 Bq0Q4T5X
 +0z+ziAM/72U/t5/kShHGjcm5CQECtrEw/uLGTgEChMUuZL/obOMGTnBtfnlLxpTOHhsbxbd1dMzYXzs9AutLjDQOq+hGGS3AIX7EhtQfNXX6Z78JFGiVzOzjsDvqSziVwfZFyWQ35UihBOVB8QwFoREwXmnR7i2AKnpzN1OQGHrymRJNAWM8P+UjRK6Ws8V6tNVJQrt8NsJmY6etT09gntghjoDkzzQ6tEkCeddIBiUB5zXnMrCExtRdRr/Fo5yhjVK1Hx3jONLBNT4+SBCxKisK+Mx3cn/bhg7bLM6J12AghuMXxwYHFO4hpkWI2EuAhQ7oAPQWF9AlZEDb5xTgxVdtTfqDUlnVrAzw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/13 11:39, Miaohe Lin wrote:
> On 2025/10/11 17:38, Lance Yang wrote:
>>
>>
>> On 2025/10/11 17:23, Miaohe Lin wrote:
>>> On 2025/10/11 15:52, Lance Yang wrote:
>>>> @Miaohe
>>>>
>>>> I'd like to raise a concern about a potential hardware failure :)
>>>
>>> Thanks for your thought.
>>>
>>>>
>>>> My tests show that if the shared zeropage (or huge zeropage) gets marked
>>>> with HWpoison, the kernel continues to install it for new mappings.
>>>> Surprisingly, it does not kill the accessing process ...
>>>
>>> Have you investigated the cause? If user space writes to shared zeropage,
>>> it will trigger COW and a new page will be installed. After that, reading
>>> the newly allocated page won't trigger memory error. In this scene, it does
>>> not kill the accessing process.
>>
>> Not write just read :)
>>
>>>
>>>>
>>>> The concern is, once the page is no longer zero-filled due to the hardware
>>>> failure, what will happen? Would this lead to silent data corruption for
>>>> applications that expect to read zeros?
>>>
>>> IMHO, once the page is no longer zero-filled due to the hardware failure, later
>>> any read will trigger memory error and memory_failure should handle that.
>>
>> I've only tested injecting an error on the shared zeropage using corrupt-pfn:
>>
>> echo $PFN > /sys/kernel/debug/hwpoison/corrupt-pfn
>>
>> But no memory error was triggered on a subsequent read ...
> 
> It's because corrupt-pfn only provides a software error injection mechanism.
> If you want to trigger memory error on read, you need use hardware error injection
> mechanism e.g.APEI Error INJection [1].
> 
> [1] https://www.kernel.org/doc/html/v5.8/firmware-guide/acpi/apei/einj.html

Nice! You're right, thanks for pointing that out!

I'm not very familiar with hardware error injection. Fortunately, Qiuxu 
is looking
into that and running some tests on the shared zeropage.

Well, I think he will follow up with his findings ;p

Cheers,
Lance


