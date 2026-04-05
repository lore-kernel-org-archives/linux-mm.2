Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0C7DE9D800
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 16:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E9A6B0088; Sun,  5 Apr 2026 12:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD7E6B0089; Sun,  5 Apr 2026 12:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EC5A6B008A; Sun,  5 Apr 2026 12:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7909A6B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:30:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09CB3160AC5
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 16:30:28 +0000 (UTC)
X-FDA: 84625040178.28.4C8D9E3
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id EBBB31C0006
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 16:30:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dzDC4aie;
	spf=pass (imf18.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775406627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LjUD/kLWetoMxCJ3PxzmkFjU0TTr1mOWnhqJ2E1tbHo=;
	b=mdNhbfC7SeNoy3u2F+fDckPV44ZgcaPO/Sw1uteEdwUGOSLtFsLgjahb4xunkj3aPxgxuk
	e7QjQmHE1rltCDrzazfbN2hibH1YNCs9ADwXgUUAo3yiZQ/YY2mMddUzYAJDzN/P8gdo+2
	rem+Az1yVJeQDsLqkqX1aF48MoUWw20=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775406627; a=rsa-sha256;
	cv=none;
	b=HG1qZhTTO+SAlxOJT/fy9QjkVusi/B17yYGFZHoifw+JiPV3nQ0KPillkU2lFGWI7oRJUi
	yIxoeDYOAaDZNSywV/8ZqgSN0yli/1eoADIJjSUbYza3m8S18evg4mJStjlmhxiZZbUl5b
	9KGkzjOsugz1FSmcxfe5aMzbTpZcPdA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dzDC4aie;
	spf=pass (imf18.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <b7af6516-1593-4e2b-9149-fc839e2b88bd@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775406624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LjUD/kLWetoMxCJ3PxzmkFjU0TTr1mOWnhqJ2E1tbHo=;
	b=dzDC4aieMPnCPXwj7TE0O257iG4gwpW1KkFDZSb87AyYWIQFJUNBBSvlCdKGM9ThMJk4Iy
	7CEHbAOQbccjlFxMy1NmWRmj77N1XEtD0WcflqatHKS//m+Zd58m8m2B56dyKEiM3nJ2ml
	XKFcOceEg/l8Hw3+jRJDeZy+2BZcJM4=
Date: Sun, 5 Apr 2026 09:30:17 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v3 2/6] selftests/liveupdate: add helper functions for
 memfd tests
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
 Mike Rapoport <rppt@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Usama Arif
 <usama.arif@linux.dev>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
References: <20260404102452.4091740-1-pratyush@kernel.org>
 <20260404102452.4091740-3-pratyush@kernel.org>
 <c783bc1b-3327-422f-9191-11550513b13c@linux.dev>
 <2vxzecktc13r.fsf@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <2vxzecktc13r.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EBBB31C0006
X-Stat-Signature: n1dwft6kmgjn9kar8adceacqmpjb34c9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775406626-206541
X-HE-Meta: U2FsdGVkX19SeA1T6mqcyt3pNiow8J8A0z8BJZvA604EOmHPb31goh+F/6Zb4/a24Nhsy+WHgtwmqrhVrUCTQiIKgmDsjmUTaE3OalhPEgvyyzKyOqRDYKcapXBCMfmydD+YrNl6Qe/YXwmxjCGs/dE7c818GS23tcdHB309MOsRDiE3K75s/t4gGk724PvtmLfRmyVxICKqdFjLDKd7HY4zYHx+3QQ8ciz6ffs6azNVnLddbD+vMVMxra/GCylrhjE0OuyKp53RPybLMWSssD2EfAJ5zJoq6wpOFRHcBIA+mo8ZPAuCdbPnQa252G8sJSe8fuBzBe4AKqwOk4NNhrUDXLlbkDzm7mrpyu61vt488Si/mONBEBB6EGO/Z4NMHowKdxAd9wXKivPLjutvyGv+3s7jGnvflwy50Jgd9XL790j6s3foaHkYXVM4thVb5iK1RP9oQw2rCH9GExbvsWY6OlnOcwKMS7irJARQPyhuVWg/5Kay2J+f0cu2ayscqk4gkI3pAHcFnQFRVgabA1V/g5x0JG0YOAD61apifhrWTzI/oaAtyUeFHEI/cSwzKEBIlqQvS4zRTeSXXs1VJN1KTnimrJsp8O32M2txiNNwlqQZbdu65/DRtyM/cBriXKveYWcS3fc+jRSaxgg4cZBa4ZzDMB2sJQXPiX9TBh7Yr4BRUskncfVB2c6o0e8H/uXE0RJmpVaW4IPn/0yPZ9HIQx6AUSoAyhqaAq9eQLzkLK3jd+kKMyQp3xwZIIljhY3SHsf0V3exbxia/MAvYD+VfBk7BYfcNb+sGhLa9xG9orIT7dUAvEyRBKfCwZahv8UVTZU7ocQx0j2BUN4PHHf1pgaEyPjvrd8JdgsnGiq7b2Gx5hgUI8ypFeQ9ZbVrjIgIcxGaG7sWYqXx3EBO5ULK8cF+KeKrKVaj3IDXaPbdbB8t0rPfFXHm+xGImVSyVMdb2TbRmlnpSKuqFp8
 hiPV58UP
 ZY94OXf9WOW+gV7ACCa340G/7jzrEH484CDneVUrkmci3nsnKyeJscFnXCmb4ZhbjQN/fFll24DMZQ9bIDNCyf9/ewX9tmZZVQAaY7FFDRMM1oo85V1pZBdG8NOgFekLd0XtIb//MGFWXPZRa8Zz9NBYRD4zhQLuu0huAYEsMPg9eapE+2ghjnUUX6XHbpFSIRqGa5Y62Wm+q6HBHPptWzwaaDm7xQY6JsLKw5bn3WQyJa6SdnrIDQvrHN8+VIFvwOW+IV9UbSAEyks3ETJmCODqr5vWQlVD9s6BB1cDg9hqHizE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/4/5 0:34, Pratyush Yadav 写道:
> On Sat, Apr 04 2026, Zhu Yanjun wrote:
>
>> 在 2026/4/4 3:24, Pratyush Yadav 写道:
>>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>>> Add some helper functions that will be used by memfd tests. This moves
>>> some of the complexity out of the test itself, which results in better
>>> test readability and less code duplication.
>>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
>>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>>> ---
>>>    .../selftests/liveupdate/luo_test_utils.c     | 191 +++++++++++++++++-
>>>    .../selftests/liveupdate/luo_test_utils.h     |  10 +
>>>    2 files changed, 200 insertions(+), 1 deletion(-)
>>> diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c
>>> b/tools/testing/selftests/liveupdate/luo_test_utils.c
>>> index 3c8721c505df..ceb918ef9813 100644
>>> --- a/tools/testing/selftests/liveupdate/luo_test_utils.c
>>> +++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
>>> @@ -1,8 +1,12 @@
>>>    // SPDX-License-Identifier: GPL-2.0-only
>>>      /*
>>> - * Copyright (c) 2025, Google LLC.
>>> + * Copyright (c) 2025-2026, Google LLC.
>>>     * Pasha Tatashin <pasha.tatashin@soleen.com>
>>> + * Pratyush Yadav (Google) <pratyush@kernel.org>
>>> + *
>>> + * Copyright (C) 2025 Amazon.com Inc. or its affiliates.
>>> + * Pratyush Yadav <ptyadav@amazon.de>
>>>     */
>>>      #define _GNU_SOURCE
>>> @@ -20,9 +24,194 @@
>>>    #include <sys/stat.h>
>>>    #include <errno.h>
>>>    #include <stdarg.h>
>>> +#include <sys/vfs.h>
>>> +#include <linux/magic.h>
>>>      #include "luo_test_utils.h"
>>>    +int cwd_is_tmpfs(void)
>>> +{
>>> +	struct statfs buf;
>>> +
>>> +	if (statfs(".", &buf) < 0)
>>> +		return -errno;
>>> +
>>> +	return buf.f_type == TMPFS_MAGIC;
>>> +}
>>> +
>>> +/* Read exactly specified size from fd. Any less results in error. */
>>> +int read_size(int fd, char *buffer, size_t size)
>>> +{
>>> +	size_t remain = size;
>>> +	ssize_t bytes_read;
>>> +
>>> +	while (remain) {
>> while (remain > 0) ?
> I don't think it is needed. bytes_read will always be smaller than or
> equal to remain, so remain will never go below 0 anyway. And while
> (remain) is nicer to read.

If a wrong number is transferred, this makes remain less than 0. Then 
this loop will run again and again.

This while (remain > 0) will avoid this kind of scenario.

ZhuYanjun

>
>>> +		bytes_read = read(fd, buffer, remain);
>>> +		if (bytes_read == 0)
>>> +			return -ENODATA;
>>> +		if (bytes_read < 0) {
>>> +			if (errno == EINTR)
>>> +				continue;
>>> +			else
>>> +				return -errno;
>>> +		}
>>> +
>>> +		remain -= bytes_read;
>>> +		buffer += bytes_read;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
> [...]
>
-- 
Best Regards,
Yanjun.Zhu


