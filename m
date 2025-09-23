Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FD9CCAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 18:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6767B8E0019; Tue, 23 Sep 2025 14:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6274D8E0001; Tue, 23 Sep 2025 14:02:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EEF38E0019; Tue, 23 Sep 2025 14:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 367F88E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 14:02:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9F88C0132
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 18:02:53 +0000 (UTC)
X-FDA: 83921285826.23.E212E83
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id E55B41A0011
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 18:02:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i7ypuDBY;
	spf=pass (imf19.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758650572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+tqvwE+E0cZ1fEaxr5t2bL8HNbMuR4y65gYrn4JYKo=;
	b=pHMCddknwoM8OfEH+THjctT2IDNsFU1ZO5NZjBgtZxA4K87Ayy8zZsteNuGu196hgbnvXg
	cy1YzUJPZIgBPC1Fr15FY5zs/h1XHyk9z+uTxHClOnoW3cGdoQU6fsL4wMfqyC2V9yojOa
	f1iI8VRq08myRT4NOFMsIucyRtYJBCg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i7ypuDBY;
	spf=pass (imf19.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758650572; a=rsa-sha256;
	cv=none;
	b=U1mT3D8vn/uWVS88BI9bX9FtN6Esw3WmiedOzups4034bUVW5ygaILuhg8z4NICk+KvXCr
	vnDzbXc+ctv14YMz5fe0bAlURHdds++uTralTuq83oWr03bqfnheu4WbOx1zwEydh9FJpS
	f7Er4NpLf+s3wFOW+uBfYxjNybPqy90=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-26d0fbe238bso34396315ad.3
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758650571; x=1759255371; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i+tqvwE+E0cZ1fEaxr5t2bL8HNbMuR4y65gYrn4JYKo=;
        b=i7ypuDBYM1OkkUt4L5NGhz6PhDajDTYVUsx5IA0QWUAa8A2EQFk6vxdill1qLhkZ4J
         VOgtDmVM+BJpA9ruiZi8663QDQyLUk48tbCJibRlR/hkzg114j1IPVMjfpqvWI2THBfT
         T0F5FY1rqMrW5tU2NGBlbM608azxYP+O/pzUFeImTSn71zr2FMNjGf59H09dFItgNhSZ
         nfJXPqAPt2qwxNSSADLFZ9yrxpNgZSf64qmQVATM4lScGryZDuouCITnEMcf4E3QzFpY
         L8ksrvl3qcLijoxN/emTznqk7tdsct5/iiL0Q3YHMMYbu+IJxMFyYNU5UwkaSOlCeXFF
         s+dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758650571; x=1759255371;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i+tqvwE+E0cZ1fEaxr5t2bL8HNbMuR4y65gYrn4JYKo=;
        b=QIgLCX9I4bJh/U/09mbj7yVQW0kFktJ+nPUM5qgYZiOBKJVAg/qM6tmXJCsIK0V/rl
         jOERgZidQBegRiGldrZcU9BZEdY/g5bQ7eR3sLFh2VU4c4ZOWgx9prNw6/Usg38Dq/os
         szH1v4FnEQvyAoC3XxbTJW9fjjSXa4VDzVXhMSV92JpC3y5yOSWdzbICRJ6AtQR7Gzia
         UqcnC/0LLZN/aPEItAB60ydptnw1a2Gj/zJ7O2Cry3s4dzwtKPzjjfuEeVO596Kjw0ul
         JHlh+IYJqTXL+vLnmF76FHsGZBVPh8WlfwbfVWjpgTryjzMKdxZRmFbURE2QPKgrjT61
         AH/w==
X-Forwarded-Encrypted: i=1; AJvYcCWBJ93frJS+EuB6fHPBH6XaXZ6qT7BHSEtWqdDk+kaw1pF4cBfXT89cGCgxU5XUqW1BzDGEdj7RLA==@kvack.org
X-Gm-Message-State: AOJu0YyPHCb7NaYYQXEC63c+FJIti3telCKokqnrTN6UW/bglivNix0/
	CI5OsK+IQv7aH1NjF4VT9REH74FFTJzWQgk2NdZiXzhkiBMq2hEKZtA7
X-Gm-Gg: ASbGncsInT8MD4AGmcp5AvTvuxXWrwKWYPr7uGDCroUijxNFxfuMIq/M+OskIJtJW+L
	wlx5u0mEAjHyDw6N62T++1eqDV2nEtH5GyHWX1Du6bHFXXYOq5G4zvBKYlI1jwZ3MC1JQBcHpYr
	bkAHpL2Ves0zW0x/0R2UcgHNMB+WUrtPBDytAxLaczZL3SphspvZ541Oder5IP7OaBPNSm7O2zC
	PcJZnwGDi4810HcJ/P6brK/64wfdvHlvC5mp1M3AbKnVGSQO6jsBv6687eVVXIBLCzixHnBTIMU
	AIgLhEixEVF5wRZsTqEVGJhNA+bWec9pIYtapvnQ3Lc8QnSnPIKsIDxUBv2EPDDPBumnNWc8Mno
	E1J7nRJmC8HVsazfNNgnBDXVu5H5BaOXR
X-Google-Smtp-Source: AGHT+IFUlOckCHI+KwnlDW4tzUdg15UTb2EGkiOLw73qogkO+0zulqJJ9EPdzpVIEp7UN6ZvkshONw==
X-Received: by 2002:a17:903:37d0:b0:25f:9682:74ae with SMTP id d9443c01a7336-27cc5a09d62mr39648005ad.29.1758650570586;
        Tue, 23 Sep 2025 11:02:50 -0700 (PDT)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269800541adsm168967475ad.4.2025.09.23.11.02.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 11:02:49 -0700 (PDT)
Message-ID: <01fdd968-8b82-4777-88c3-e1dc0c81e9bc@gmail.com>
Date: Tue, 23 Sep 2025 11:02:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] memcg: introduce kfuncs for fetching memcg stats
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: mkoutny@suse.com, yosryahmed@google.com, hannes@cmpxchg.org,
 tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, kernel-team@meta.com, linux-mm@kvack.org,
 bpf@vger.kernel.org
References: <20250920015526.246554-1-inwardvessel@gmail.com>
 <ky2yjg6qrqf6hqych7v3usphpcgpcemsmfrb5ephc7bdzxo57b@6cxnzxap3bsc>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <ky2yjg6qrqf6hqych7v3usphpcgpcemsmfrb5ephc7bdzxo57b@6cxnzxap3bsc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E55B41A0011
X-Stat-Signature: dfc74runsbuaue3hoygctzrphyzpucdq
X-HE-Tag: 1758650571-939334
X-HE-Meta: U2FsdGVkX1/O94r+Ur6vRp7m6ONCEmf8W9THkQWF3lUduzjpgSpceFF98zLvDY9teUWDUDRcrvFvOzNQ/TbPdBhsiAACyKxoVhvfMo4PaCaYRQHRZOGLstD10ELhyl+U73ixwno3r/Dh481QV0G8k2Myi39AN4BYq8fpb4j8qxoFc8QSJMWdqz7EqKukPbji8PYi+B/kXHNkYCkDWSLocs3xs2K7tZeho29Aj/43B9MN4BypwlH8yMiO9TxEszc7PkXSR7+1LxOQMbhHIXCmFPpl+P9zFRVC11fCz7TDWy3VVHkcFLYREz/z0/HaZANAiEyqjZ3hWbSlifRBIhYsWyXGDSqkvBMKHX3vXcsIQieEoEXAKJNiZmIqBFdatZ3akrs93KnBGABdf+V+Huo7jXbRDI4oiZZLilVVqio81KF65YviYtTabjGbz5aGFdV1xQYV0JmqKr+FXdSjOnSyBBxRO4xcLa3+Udu+lAh62YQM4HVBjegGU+xmLt9rje6IzwKMWbhEczWE0Cq3obPcJYKh3WjYpSY8fv/0HIaP5R5UhQF3EXUx+bvecFHPgdojsCKp7LWzgl1sdza3pRuxI9WCaIJxo7eaNHxUW2qb96jcH2Uvi/UkGIlCafaMOxhM3w4v4BLJc3P2jSssie8jQGxh2uXzFUjUGiPS9PAC3LscwAboMJLFHGw1Bo9STjSmOswL9T7xYHYp4jLPreCV5FjnOxDAuDJ6Wx/nDx70oLEU3ndz261gDlS/4sMVSBQ1q+Ex4HlE6mxThBtZkHaCfuNmezkMzAEBqXJ/JsDUOUSrlCQS4je7iWFYxkbgadOIP8Ftw/bTKSQmyXs8xwEtQyRbXGVI7aXqEfGS33PWvN3xnpVOlO6OHMZmYXSusOl46s/64QQUQcvsfwZXvgP+NhLPtuIStglSCGMwrHHj9wimMThEr86cR/FPKtn63+HajfEQr7k2nO4OBNOw1Zm
 uNvH61M2
 5QSvNNkVYHvd4qh1TE9BuODzQ508xu68yyODYgNJxwh2ROWOpWs1Cjp/s5NuFk02bruOzzUZQ+UoWxVbgfHzRSFIXrlbuxJj+L/XO/jIzFhrJEt4Itwi54bSJRzkWLDn1z9uJoaYkDqdPFcfAvD/mE6j4W9ixFZyHSLzREYxOrKr1hRrGcz3YApt713QlrUhjuFTulpH9U85l60oHlGWyp8RrTNXNVkfT1kFuaq1qJnaxQDNANFR8pbjiYJgT1ww1NRomsO79gHc72+IlxIbOEhxaH6e6xQ/s1UpzhKUi5F8F2C2FF92YBkLLwC5vdjk+7qxJi72Ey8jcSDmDvKhk+fh+93DoAezVoG+/GsLLCYZHwHQu3B75e+b5dvmIh6hmLkKPoet3qF4B5HaY+P3WYmzldIKAlSWDwSzwIfdrjWRA1LL+PXTmNF//SKe+avyAKdHzGQ2SI137ZuP0Wq0/SPj4hA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/19/25 10:17 PM, Shakeel Butt wrote:
> +linux-mm, bpf
> 
> Hi JP,
> 
> On Fri, Sep 19, 2025 at 06:55:26PM -0700, JP Kobryn wrote:
>> The kernel has to perform a significant amount of the work when a user mode
>> program reads the memory.stat file of a cgroup. Aside from flushing stats,
>> there is overhead in the string formatting that is done for each stat. Some
>> perf data is shown below from a program that reads memory.stat 1M times:
>>
>> 26.75%  a.out [kernel.kallsyms] [k] vsnprintf
>> 19.88%  a.out [kernel.kallsyms] [k] format_decode
>> 12.11%  a.out [kernel.kallsyms] [k] number
>> 11.72%  a.out [kernel.kallsyms] [k] string
>>   8.46%  a.out [kernel.kallsyms] [k] strlen
>>   4.22%  a.out [kernel.kallsyms] [k] seq_buf_printf
>>   2.79%  a.out [kernel.kallsyms] [k] memory_stat_format
>>   1.49%  a.out [kernel.kallsyms] [k] put_dec_trunc8
>>   1.45%  a.out [kernel.kallsyms] [k] widen_string
>>   1.01%  a.out [kernel.kallsyms] [k] memcpy_orig
>>
>> As an alternative to reading memory.stat, introduce new kfuncs to allow
>> fetching specific memcg stats from within bpf iter/cgroup-based programs.
>> Reading stats in this manner avoids the overhead of the string formatting
>> shown above.
>>
>> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
> 
> Thanks for this but I feel like you are drastically under-selling the
> potential of this work. This will not just reduce the cost of reading
> stats but will also provide a lot of flexibility.
> 
> Large infra owners which use cgroup, spent a lot of compute on reading
> stats (I know about Google & Meta) and even small optimizations becomes
> significant at the fleet level.
> 
> Your perf profile is focusing only on kernel but I can see similar
> operation in the userspace (i.e. from string to binary format) would be
> happening in the real world workloads. I imagine with bpf we can
> directly pass binary data to userspace or we can do custom serialization
> (like protobuf or thrift) in the bpf program directly.
> 
> Beside string formatting, I think you should have seen open()/close() as
> well in your perf profile. In your microbenchmark, did you read
> memory.stat 1M times with the same fd and use lseek(0) between the reads
> or did you open(), read() & close(). If you had done later one, then
> open/close would be visible in the perf data as well. I know Google
> implemented fd caching in their userspacecontainer library to reduce
> their open/close cost. I imagine with this approach, we can avoid this
> cost as well.

In the test program, I opened once and used lseek() at the end of each
iteration. It's a good point though about user programs typically
opening and closing. I'll adjust the test program to resemble that
action.

> 
> In terms of flexibility, I can see userspace can get the stats which it
> needs rather than getting all the stats. In addition, userspace can
> avoid flushing stats based on the fact that system is flushing the stats
> every 2 seconds.

That's true. The kfunc for flushing is made available but not required.

> 
> In your next version, please also include the sample bpf which uses
> these kfuncs and also include the performance comparison between this
> approach and the traditional reading memory.stat approach.

Thanks for the good input. Will do.


