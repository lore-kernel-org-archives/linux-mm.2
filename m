Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4255ACD6E56
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 02:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A125E6B04AF; Mon,  1 Jun 2026 22:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2E76B04B4; Mon,  1 Jun 2026 22:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8096B04B8; Mon,  1 Jun 2026 22:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4506B04AF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 22:45:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C765C28B1
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:45:24 +0000 (UTC)
X-FDA: 84833431368.16.45969A5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf04.hostedemail.com (Postfix) with ESMTP id 53D1440008
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:45:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FbloPyae;
	spf=pass (imf04.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780368322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4l3sxPyNqy0QPpGCpRZyDuuve5DBS6sEz0m5Ij5f8yo=;
	b=CptuNADwlvJvJkFjGWabagf0dIKlwY0b0BGglKvBe9X2C8xHegcR44bGFrHwLIjD0RoT/7
	e/W2/L2qC36U7UMnXa8/snhR4bbTt/4/4MnOFemb1225xYLn4AF4Zq1Od+rlfDVVN25o4H
	O2lCP4Mp3iTgDdjUKY1TDKxwfvEPIRU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FbloPyae;
	spf=pass (imf04.hostedemail.com: domain of chizhiling@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780368322;
	b=RHY2ZZ94aB2/ZVA2Z1kEMYzIAJPneg+5TaqMhbO+2wIRQCThwFu2XeOn4rL9QOQcAt8R03
	dozNObToH3tOS+3xPpYqOVvcMHwbg7fX9a+qpH46V6JSOP7dKzT3rhIRBe4W5KKqKV3xZ0
	Ehvi5rkYrjDw0myHR+1zcLLIjQYsmkU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=4l3sxPyNqy0QPpGCpRZyDuuve5DBS6sEz0m5Ij5f8yo=;
	b=FbloPyaeuuIf5ZJsXIXWGwWb2a0IrsO3Zo4jtoxeHrdijrXA1yIS3pLxP6akBO
	2JL6u8BoG5VDVwNeF0fZrCh/27sIiudeLkN7WX/wPMmN9tE+Ek/xTlHDj1LcOZcl
	2KLZopY/c3ANFqutM1TxbuC7wN2JitJBvInYD4dJ0xsEw=
Received: from [10.42.20.201] (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3v6uqQx5qSumtAw--.4601S2;
	Tue, 02 Jun 2026 10:45:00 +0800 (CST)
Message-ID: <e9ceb5fb-f052-4433-8124-2625bfc393a0@163.com>
Date: Tue, 2 Jun 2026 10:44:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] mm/shmem: optimize read with reduced xarray
 lookups and folio batching
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Chi Zhiling <chizhiling@kylinos.cn>
References: <20260601055704.167436-1-chizhiling@163.com>
 <20260601174349.e521b96acac805ac3d9bfbbb@linux-foundation.org>
Content-Language: en-US
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <20260601174349.e521b96acac805ac3d9bfbbb@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wD3v6uqQx5qSumtAw--.4601S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAF4DCF15tFyDtr1fAF4ktFb_yoW5GFWkpr
	yfWF1ftrW3J3yfAr92kw18KF1xtr95JF1UXFn5trZ7XF1FywnIg3WfGr48GrZrCFyDuw1U
	XFyUJ3s2yr45t37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U6E_iUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC9wweu2oeQ6wMHQAA3U
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 53D1440008
X-Stat-Signature: ioj97mwm5t8jtq8dax5sbu3cy8bgz483
X-Rspam-User: 
X-HE-Tag: 1780368320-548599
X-HE-Meta: U2FsdGVkX1+gMKQ90465RQvhcluPiONzALLhVO7z0CY0QM18XEdCOiye75IlQUbmF1L3fR+GOvOtnsHxM+9NhW+aIrykF7/cWIv3bVxAs19Y7M9sYYLwB4/lzbskZ0mJMKIs9sSfafvIwJMdW6rzJQXIOv1q1dfvlPkCd1BHijSDIU2cD1uY1Z9+q8TJtdTkbaupUnpEsH5XawKNOcLdRrnMjYkIB6RBDt8VxbY/P40yFtkzNmskO5v56QIPp9tTu67BV5LbDCWoNPajiLjwEdbI8cLXlfgmT1AnQAz/YPGF0Ez/BdnSMSMY6D9oJwrqGA9Fa+hhc6iECCsQuVTy1JrYRt4863r7e+uSs7UfKk3oYrozeCr3sQ59xQ6i3LahS9ApGRp1QIhwM8OOe6qfeeMTCSL/q0Ug9/aWTAvA6c7ADUPJVFzFLRKWT15WPzLQn1+NHiiVZ6xdlV+yaW1Lse87U7bsqRFjAlNaSQu4baBiDjFPOZwNfKZAc3rNInJ2V5B+whkvQZM5AQ5LywfJrCyjNm/cK4lioXOoJlfVBgWXCwJ6zWNhB07+3t5xBWcuPWha9uQDyDDkuV5H2Pg2SBVwPopbkaXXAi8ww0SXgvSXVpR+xEJiUg1JQLmenwb+KhbbcbFcb5d8fuKDpkMBjPaHP7xCAorFPLixqDByTSPh4cPp9HTCXRxcUQ/AiH0n4a8hwsAx8F9gc0pqtRSZ8UMCQxkkvZuFbPptV2tPgpm+bS/FNkGuAQQLXIe8p6AztofczgglqXNh2SQu+WKtqVZqlxhKQP+Tc17Qa44Ub0BNR2bEHjtD4RHQxaaSmT3Gh2nOOSbjcCRFm6/J4FCnfBcIBtOo48zdZNu1xkQBaPlz73HW4CV5L5PoX9w2Z0WgW0NaNvqfGpTZ/Z5aML3ePj2LryAWTq5ZT3P2Pt3vOhxRUSb3dXAH3YNgVBjebvuFLHhhQ7qqhsvfUDy4VKt
 Y6B8MBGh
 LliExZjQh0JJf7E8j9b/3G9TbM8i61gGYWJcIaAgTpnujuU2Qy7+zuNGAJO9hOyNCNuUY0UAWSoor2YWQgxIgI5foLy7eySmN8SL3b+58Z1xHAJUehq6hKxjhIWTsaN+FZ4uvXlDpLIVezM8KN6ol0pH5c1SHuRZSsP/dKK6vhfpPVRDXE4BJxQF274dP17+4tJohJOAtrkp7x3EH+lGUcpk3i/5fgMS5unTIvyGzciyCheI8O6dPKsJRwtqwCARYilbuCroZXKS3UeAtYVEcx7oEcGYG3E7sxU/fZgmx4t+azzf82t4E1MAREBzdGoM+bka3B75WqymnpzdRmJtHwGFAfJcEC36jz2hXWuF3UsUSVRuCVWyWOjOEV8HSHHXBjJtAzdHYSwHRpbLvC1Ff+fCBu8LJvKSmUI4DVyLMoEBQuTFUMT0yeiXfjAE9e/0VvPosHnvNBZBLhbEiRDTCfSQZBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 08:43, Andrew Morton wrote:
> On Mon,  1 Jun 2026 13:56:59 +0800 Chi Zhiling <chizhiling@163.com> wrote:
> 
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> This series improves shmem read performance by implementing folio
>> batching in the read path and reducing unnecessary xarray lookups.
>>
>> Performance Results:
>>
>> fio --ioengine=sync --rw=read --bs=$1 --size=1G --runtime=180 --time_based --group_reporting --name=seq_read_test --filename=testfile
>>
>> | THP disabled in tmpfs  | v7.1-rc5     | v7.1-rc5 + fbatch | Improvement |
>> | ---------------------- | ------------ | ----------------- | ----------- |
>> | 1M + normal file       | bw=11.5GiB/s | bw=12.7GiB/s      | +10.4%      |
>> | 64k + normal file      | bw=11.0GiB/s | bw=12.3GiB/s      | +11.8%      |
>> | 4k + normal file       | bw=3826MiB/s | bw=3849MiB/s      | +0.6%       |
>> | 1M + fallocated file   | bw=23.8GiB/s | bw=28.6GiB/s      | +20.2%      |
>> | 64k + fallocated file  | bw=22.5GiB/s | bw=27.3GiB/s      | +21.3%      |
>> | 4k + fallocated file   | bw=4655MiB/s | bw=4680MiB/s      | +0.5%       |
>> | 1M + hole              | bw=24.2GiB/s | bw=28.6GiB/s      | +18.2%      |
>> | 64k + hole             | bw=22.6GiB/s | bw=27.6GiB/s      | +22.1%      |
>> | 4k + hole              | bw=4652MiB/s | bw=4489MiB/s      | -3.5%       |
>>
>>
>> | THP enabled in tmpfs  | v7.1-rc5     | v7.1-rc5 + fbatch | Improvement |
>> | --------------------- | ------------ | ----------------- | ----------- |
>> | 1M + normal file      | bw=13.7GiB/s | bw=13.9GiB/s      | +1.4%       |
>> | 64k + normal file     | bw=13.5GiB/s | bw=13.5GiB/s      | +0.0%       |
>> | 4k + normal file      | bw=3833MiB/s | bw=3859MiB/s      | +0.7%       |
>> | 1M + fallocated file  | bw=24.9GiB/s | bw=34.2GiB/s      | +37.3%      |
>> | 64k + fallocated file | bw=23.0GiB/s | bw=31.4GiB/s      | +36.5%      |
>> | 4k + fallocated file  | bw=4710MiB/s | bw=4655MiB/s      | -1.2%       |
>> | 1M + hole             | bw=24.3GiB/s | bw=34.5GiB/s      | +42.0%      |
>> | 64k + hole            | bw=23.5GiB/s | bw=31.1GiB/s      | +32.3%      |
>> | 4k + hole             | bw=4690MiB/s | bw=4647MiB/s      | -0.9%       |
>>
> 
> That looks nice.
> 
> Microbenchmarks are useful, but are you able to help us understand how
> much benefit our users might see in real-world workloads?

Hi, Andrew

I don't have real-world performance data yet. I'm working on this simply 
because the patch shows decent gains in microbenchmarks. Even with THP 
enabled, it can still reduce some unnecessary overhead.

> 
> I'll take no action at this time - it's late in the cycle and reviewers
> have yet to participate.

Yes, it's unlikely to land in 7.2, and I still need to resolve some 
performance regressions.

> 
> AI review flagged a few possible issues, so please take a look:
> 	https://sashiko.dev/#/patchset/20260601055704.167436-1-chizhiling@163.com

Okay, I will take a close look.


Thanks!


