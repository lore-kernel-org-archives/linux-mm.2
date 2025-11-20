Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F6C7CF64BB
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 05:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58EFC6B0028; Thu, 20 Nov 2025 00:40:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53FB56B0029; Thu, 20 Nov 2025 00:40:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42EBC6B002A; Thu, 20 Nov 2025 00:40:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4736B0028
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:40:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C6C8F16073E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:40:34 +0000 (UTC)
X-FDA: 84129885588.11.316F209
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id CFAE5A0006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:40:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=Y52pV5J2;
	spf=pass (imf15.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763617233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dK/TZoBnuzuAgeT3RH6Vn9CDIGfrgo8wHcMBTPkWjc=;
	b=4NI/9ruwT/NlJcPuKhlnk11MG9lq1wxH/Db3rvrKf6LyjA7acrSAgvNZWWtIXSe1nyo1t2
	1nrcHMDf5p9MD4eBe5PI+n7F11uDo411SMMnV3qeWLyqN8Dqij4ItC/N4GZT2Z8cX5Vmmo
	lVSB/7XR+8eBCHda18qo8uulcP5TPS8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=Y52pV5J2;
	spf=pass (imf15.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763617233; a=rsa-sha256;
	cv=none;
	b=LpjtrlQG4J1ud01O1gM5CqeAosP75NBTMB8RbV/wPzqX95ZIIu3eqsfLbu93FOfS6TWskk
	F0r9PzkBie7F1iyPizxRtnQJPBggub3aKiYqL7Ea93PB6pSEgqlRaCmHL3Hk7Jsytgt617
	CU/huOSAZFmn8TDwnBzbiFmZmEFVZuw=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b75c7cb722aso70808866b.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1763617231; x=1764222031; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7dK/TZoBnuzuAgeT3RH6Vn9CDIGfrgo8wHcMBTPkWjc=;
        b=Y52pV5J2LCz2KUZVcFPUvhkp+Yn/dCpEc9t8jSSVeFxQ0B/82oGL6AfxZllEg7dlsC
         5fL3fsgk/GJlFwrk7X5bZ2ukZv0RCs2qHqJ6LCIVqQUZmy0s3r9zxIAap4d66+i6oVoW
         150GwJq2iXLk6VFLoi/QWGkspVPSh/f01aATxK6JNoIHVebKELcGctlzBj3Hv8qP9WRu
         dz0JAbZlPxzBbTTBZr+0jA0rKEkqN6qsQ1zJU4hZidZXQvOeBKR0RZKY0hPi9ZqLGFsD
         uSVqpS/6Z3t08TbYU1eEkdEBeuWRgXuidsaOMYlDT+IIoWhCdwuF5YsOTxbTQ0FkqDO4
         QR3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763617231; x=1764222031;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7dK/TZoBnuzuAgeT3RH6Vn9CDIGfrgo8wHcMBTPkWjc=;
        b=a3zg7UJsNc4hTz1Jbsr3HxDM0pcFOKLd7VvNGgOnn2M3zSsHdzF42sd5EPJjVas/dM
         uSN0AU/yI6+D97jl+Al4HYBpNyezwVmBOqU7+6NkkN3v39vKHOiM6cboLzIYSzW4DXWM
         Dqef40bJAjeAsnqP/KY6j7y3ddkvx88qgFU6CJ5N40AUzLL8jZSBUZ6biu65pxqA2sES
         9GgV9EVcv9hZAnu9oo+B74kTjXklE+rZGXrNdDnnWPhImaNYHn6IQWkS8shYVljtXDti
         tB23ekXjWwQJhGYZKwLj2btqj/Uc7HgPf6XbMtsF0+XClzZRommrPJIqBZ5A3jgfu0ow
         aavw==
X-Forwarded-Encrypted: i=1; AJvYcCV4fuX3J7bHUzyshKcia74qLeu3HiSSp2FcnW4lpBcz1XV+TmsNrkoCMQC2d2sH/AgviSqhZws1Yg==@kvack.org
X-Gm-Message-State: AOJu0YwfoIJuBXi1zRRmgu/NWxex0JyEUZLDjU3DP+uDWE1WIinv2NYE
	X7l+E6A+tYn6eYMurPn04dztN+/Di4u+4FMWbwt1UgXasp50zPeuKyHqZ/J26dQSrAXXW6yBd0s
	FD7txcsR60vVYBMexg2C0AbkS/FERa1vutX09UdDBNg==
X-Gm-Gg: ASbGncvOPJCRmdSBP2A7xg7Npa0iqqhsrRj2DeD0Zsicz2lXBbQBxQgMtPaohsMrPQt
	URNYIKBodBLXly4Fm8FSHtyBGayqEWMGSJdSGMgK54huYV/SFTRcfFJ9ZAFxRf+Snu/vBcmwPOZ
	hg1WXVI8RXb+EiFf3/t7V8PUsVJVM1dp0nV2pHH5E+1pC9U6tVOfhxNBqn+X+1Gkbzh0kJipAUG
	SGPQbN/l/DPT8vRKPOQqefpJ3UZJsTc9K3KkCNTgxB6UsbQA4RVHMVAVwvCU9QHGgFoEA==
X-Google-Smtp-Source: AGHT+IFd4ZD8LO3gWA0tYoGo49H3rk4bG8UV2Nu8f5cyi48eyODapZFusRvqrzWLi1Ytu9FzHhwORQyO09cagbntAK0=
X-Received: by 2002:a17:907:7f01:b0:b73:70db:49ab with SMTP id
 a640c23a62f3a-b76553fa23bmr176598566b.35.1763617231293; Wed, 19 Nov 2025
 21:40:31 -0800 (PST)
MIME-Version: 1.0
References: <20251119105216.1675608-1-zhangguopeng@kylinos.cn>
 <20251119122758.85610-1-ioworker0@gmail.com> <2c276ed9-626f-4bae-9d42-727dd176ec74@kylinos.cn>
In-Reply-To: <2c276ed9-626f-4bae-9d42-727dd176ec74@kylinos.cn>
From: Leon Huang Fu <leon.huangfu@shopee.com>
Date: Thu, 20 Nov 2025 13:39:53 +0800
X-Gm-Features: AWmQ_bmEoAEKzhLFdmzN3VkYMFPpl9dZhwR3SWWzVK97oW1lQq-769I_C_Td8qw
Message-ID: <CAPV86rqXrf027nLZocq2Acqf5T=YJY2Uj3MD1OrGG7DAUqkxzA@mail.gmail.com>
Subject: Re: [PATCH] selftests: cgroup: make test_memcg_sock robust against
 delayed sock stats
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: Lance Yang <ioworker0@gmail.com>, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, 
	mkoutny@suse.com, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, shuah@kernel.org, tj@kernel.org, 
	Lance Yang <lance.yang@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CFAE5A0006
X-Stat-Signature: ycyrb91wcrwked35pib4nmr5us3srdp5
X-Rspam-User: 
X-HE-Tag: 1763617232-590071
X-HE-Meta: U2FsdGVkX1/R5LOiqe5YFueKiIpyePgOpsWcspGVdyfLLck6wfSRwxb1xGgu/NRfPzoHFSp3Lc8vEoAp0URwAvrq4zXR57RuhOKcia1P6yJLnU4pGGvhm9UO7GfIQl7XqHnyGp4NAfBUXfwmBW/HhYvmqHmhhjYNEJhRG4XR5dkWN1q46osw33nWf+fY4Reuk7yRet24U0Tc96IOVktlxiUFNPUus3L4t+PjNRz4useTKdT6WwqHJAvC9gMSOTfNce2rhe1J3O0VdUjpKi5l6cqKQ2goEwH+W7OVUeQShLqC95xUQoGEnI+DrZVY/y1MfBXzrO3jQ6wrTKddpxbx+QidKeD47mWmpKwpw1rw26tkIZBYUz3wSqAF26rDR/ixDVSqFEtWj70vss6MzmxA6JJCx20p0e9nCv/tv7xPSMYYnKLuWHJQWDb2spSsmGvWQr5/eceshSVDD2abWg1dvqg2qBniv/TifHH8IkGKRm3SocbhGNzLD7/yVRgRVsSne56A8Qd/qnLsNAMFZ/X5dn8EnbRkY3Xs0vwWM15XWT86eHc7Mt1sE/KL/QYoiOXC4nJ0XMCZJpkZg8blcCG8wdy0yVvBo1vMTTaHWAETseCDUYii+FtqmWxHPwOf0xUWH105QI65uXkKoPaxPI82kxfFI9IAWTQeYgDCflg/soiUfqL3oJw6lHRk7UBNr7LTsX57Yoqh3I+fUx44hQ8JMUgXD/gi6pIzOo9Ld7OG/7ghW84cjARJ5ggqzDUrrMAmgj7YaUbuD/PKs8Wn9pxgNhhT+Gyye65ElzuPdaoxqUQ2ex7y88NoKmLBo289hVZybYMJ+QSBMDJj5GkIGZHDtR/mvB8R9xfHOLB92ISho1bmDX3j7WqkDAFsNcQJTGoavZljeWBHjR/3SIAkjmu8J7oPwThOOvxovCXb+lXKDbELRHn45q1+60fQy7vUb42iu+plTZ6eh7tDIKiokA/
 s8zipBPl
 pZZV/hEYds6F652JOMaV0XVIpJohYatM9qRGvdSYRkI0D7V+Y/HpzI0OvVSj4BAi9UYVxr2RDsiyDAEdzhlB4Y0P+1bUZc4V0kEKXTLGTDX3y49Xv9rKgEB5kkRUHm23/2nb6SQS+WPkOI+aaBiNQfswyksKP+VNlP7RzMlhfp+mMRINpnY/zguwbDtRNKUCGzRAGXvXW6pSy5PyBq0g04zrrtd5wNWld5Q6y31pqW/9DwgHqKdlT4U4qLhI5F6I4b8rFg+EREyTlMLdAJSBYErA8aIS2OChCrfNhTOlRm5uw2lL9g232RUOoFISnU8GKJ2VGHtjXNabsMho=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 10:12 AM Guopeng Zhang <zhangguopeng@kylinos.cn> wr=
ote:
>
>
>On 11/19/25 20:27, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>>
>> On Wed, 19 Nov 2025 18:52:16 +0800, Guopeng Zhang wrote:
>>> test_memcg_sock() currently requires that memory.stat's "sock " counter
>>> is exactly zero immediately after the TCP server exits. On a busy syste=
m
>>> this assumption is too strict:
>>>
>>>   - Socket memory may be freed with a small delay (e.g. RCU callbacks).
>>>   - memcg statistics are updated asynchronously via the rstat flushing
>>>     worker, so the "sock " value in memory.stat can stay non-zero for a
>>>     short period of time even after all socket memory has been uncharge=
d.
>>>
>>> As a result, test_memcg_sock() can intermittently fail even though sock=
et
>>> memory accounting is working correctly.
>>>
>>> Make the test more robust by polling memory.stat for the "sock " counte=
r
>>> and allowing it some time to drop to zero instead of checking it only
>>> once. If the counter does not become zero within the timeout, the test
>>> still fails as before.
>>>
>>> On my test system, running test_memcontrol 50 times produced:
>>>
>>>   - Before this patch:  6/50 runs passed.
>>>   - After this patch:  50/50 runs passed.
>Hi Lance,
>
>Thanks a lot for your review and helpful comments!
>>
>>Good catch! Thanks!
>>
>> With more CPU cores, updates may be distributed across cores, making it
>> slower to reach the per-CPU flush threshold, IIUC :)
>>
>Yes, that matches what I=E2=80=99ve seen as well =E2=80=94 on larger syste=
ms it indeed
>takes longer for the stats to converge due to per-CPU distribution and
>the flush threshold.

Me too.

I previously proposed a potential solution to explicitly flush stats via
a new interface, "memory.stat_refresh" [1]. However, improving the
existing flush mechanism would likely be a better long-term direction.

Links:
[1] https://lore.kernel.org/linux-mm/20251110101948.19277-1-leon.huangfu@sh=
opee.com/

Thanks,
Leon

[...]

