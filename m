Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62145CCA476
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 12:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B34C8E0008; Sat, 11 Oct 2025 08:58:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 464BD8E0005; Sat, 11 Oct 2025 08:58:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37AC28E0008; Sat, 11 Oct 2025 08:58:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2022D8E0005
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 08:58:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89AEF13B4BC
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 12:58:05 +0000 (UTC)
X-FDA: 83985836130.30.BFECD15
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 687112000D
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 12:58:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=awgSJglI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760187483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LI0ebVFo/IUV6FiZoBk7dM1G5eL/sv9Wz3HHgolsQNA=;
	b=GoncPVP4Npitq/hCYg4+kSLZ3NoI17xS4/rHxEFdb3SQxrhWUxCliDwtcW2oIQbhryVNNu
	Bu0ffd09AujChpfgbSP1eyFJqARV+GBQ7/icVK7oZtWOuknesH5d5fsK8zJ3MuklqcEr7e
	LlN22/ery7ejnKZH8PXEBio6ZQotEEk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760187483; a=rsa-sha256;
	cv=none;
	b=G0KGOFKcacYJvmWt33w2OVRLgX97x5pGaHSrw734+BE9YrrTvEZ707LmN7xwIzepZgMGOy
	QWfozJtf/djCZcguC6kFMrIh2MO/Sgtuf2MbRTtBwtd0yn5wXQVJmN/M9s8g/YcFIBu2Fc
	q8N9Hn5AjgVaO5lAuxsOtjw0yGQNwy8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=awgSJglI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <3954ac60-e818-42a0-b114-c2a09d34572b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760187481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LI0ebVFo/IUV6FiZoBk7dM1G5eL/sv9Wz3HHgolsQNA=;
	b=awgSJglISvkYKaa2u26ASTX6O+M9NeM5gMIRbMNxNe7W8d0sIawfQtlDrulh+uSezLqxf6
	3z3u8QfOecJBC9sm2cdNp6tubyzDINOzFT9g1KltE5C43Lx2XY+ucbxL8omDwCM9deCX61
	i+jYigqjvm8R1wYe/gx02vm5XwIJJ5c=
Date: Sat, 11 Oct 2025 20:57:54 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC 1/1] mm/ksm: Add recovery mechanism for memory
 failures
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
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
In-Reply-To: <077882e3-f69f-44f3-aa74-b325721beb42@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: acwodb9pnqwxqgkebiqj9p5mq8t1auwx
X-Rspam-User: 
X-Rspamd-Queue-Id: 687112000D
X-HE-Tag: 1760187483-314038
X-HE-Meta: U2FsdGVkX18mX7lo+kYiHOKtVCPc1cn+DDmJ8LyJApnsOmp6y1qehvN51Qqh7avIMBfPFqHWgItUEb0C5CmLUUx1ZoRtppAYrUvRosHXJvsDsPwaCA2fbft5OBMzpyK8GPMLpJdDbW9yrCUx9mCpv2B2eVge9xoHuJ5ZaoIoKxWdGzupvKRFpCbRbCPA0hhDDD1VUi+NH3YEJ/jAeyK3nWqJMCr38hxoxncKJYpqxGWDc4FrvOrLu7Eoc3u4raoNxU+Wk4dUfJyg4OjSdfDz3rymH5uzK8oqMRI11If3aVh+sxtYAe3QsaN/fiIIapSkRqWtEnkChUyQj2lHE8H4p6BqtO9SFUCz8VdtgFSDDrQ1TwL3CvB25OAVrbwtb41D8uQ0Nu9NgtRXo25BQcSJFZgol8qppHwfJ0MbLpGKiDAzUeV058+XynB2IMVahVOjp6e2/EotnrIiEGeQJSvqfrFncJJSQsYyB1KZcD41/wMeAraVTNcoZ9WdwZQ3uNIpDOjLR9eZwEburqyOtVKj+/7BlxbYQwlEbZSslav4qlhFbIKfGF3KYWEru19WTTEjbaQ1MhbgUUJaIqh/LWbWDzzwTHKPkhkM5iQxqT/U2aaQnDfOEcvKJ10Fw9chHLrkad7HioxHEH9Z4De1yPI7Kv6fM9cKHiZSYDlUE7b0ZkLXd/xC4ncjme6khBcTzkjjOW4liFglFl6pWTotzOtymKgmaecik5tImAuqKI9sH+QJH/0PukYujSLze4Iduf8QZelkCGmkw99kpfaCDrv0/OqjXvoq+koDRiUNPO9us+UDLN3/fY/5xGhJpzSjd9C3lLkASgAKGhr/v/CL8AQUpIM3V30k3cap/mmf+qg+mAsCWJUWa3oUMaHWjvB/d4QCIzKzz+N8fFTt3UFyZ8VMLDBK3a8Obp3F57grvdqzgjEuO/+6INJS6qmzlCrMU3YfOL0gofUkdcpDAOsqb6S
 R9Vyfc7I
 3+3O3OXLpPnyxTQwADQLggjFSnXOMG0DDsZNxYjzKdVBWoZItK1NkQi9jOmwHbz4+LZiiDvA7o3SbWDxuYEQKDMP9H4+UUfVIzHk43mzA2785xGqtoHdpF1jJUQ/PHnY1L7+qlSu+msfh92M/oKS3c/a1mTvTUqbIzzq8UQ+9ke0YDD3yzRGMV+JUhXeAmLFKHoV/v34kmNPoagq6tjKNiX6Z/kXwj9Hf+P/K5CDWl/RBIs6oDOkvjS6LBgNfzMpYO4EQtSYX/6Hbd26CCCzkORTABQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc Qiuxu

On 2025/10/11 17:38, Lance Yang wrote:
> 
> 
> On 2025/10/11 17:23, Miaohe Lin wrote:
>> On 2025/10/11 15:52, Lance Yang wrote:
>>> @Miaohe
>>>
>>> I'd like to raise a concern about a potential hardware failure :)
>>
>> Thanks for your thought.
>>
>>>
>>> My tests show that if the shared zeropage (or huge zeropage) gets marked
>>> with HWpoison, the kernel continues to install it for new mappings.
>>> Surprisingly, it does not kill the accessing process ...
>>
>> Have you investigated the cause? If user space writes to shared zeropage,
>> it will trigger COW and a new page will be installed. After that, reading
>> the newly allocated page won't trigger memory error. In this scene, it 
>> does
>> not kill the accessing process.
> 
> Not write just read :)
> 
>>
>>>
>>> The concern is, once the page is no longer zero-filled due to the 
>>> hardware
>>> failure, what will happen? Would this lead to silent data corruption for
>>> applications that expect to read zeros?
>>
>> IMHO, once the page is no longer zero-filled due to the hardware 
>> failure, later
>> any read will trigger memory error and memory_failure should handle that.
> 
> I've only tested injecting an error on the shared zeropage using 
> corrupt-pfn:
> 
> echo $PFN > /sys/kernel/debug/hwpoison/corrupt-pfn
> 
> But no memory error was triggered on a subsequent read ...
> 
> Anyway, I'm trying to explore other ways to simulate hardware failure :)
> 
> Thanks,
> Lance
> 


