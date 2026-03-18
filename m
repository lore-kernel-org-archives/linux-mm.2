Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 803881077612
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 19:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C505F6B02F6; Wed, 18 Mar 2026 15:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD9C66B02F8; Wed, 18 Mar 2026 15:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2366B02F9; Wed, 18 Mar 2026 15:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92D8E6B02F6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:50:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3919C56902
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:50:28 +0000 (UTC)
X-FDA: 84560225736.24.3ECC597
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3DBDB80009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:50:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gny0QsGa;
	spf=pass (imf02.hostedemail.com: domain of groeck7@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=groeck7@gmail.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773863426;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Resi8n+oQ1vXGyEjFOBn4ZBz6ktHZ1vnUrgtEXoKXe8=;
	b=pFmYtC2fPpVV4O7yKL4BqTSLORbGt+K5/Qmow3zl4TkPdfQfNDWabvymIG73o3a8tGLLBK
	yryLERtzFT2jWi2Y8GB1CxiCXRVR4SczeC11Pm4XH0qjyIRonqB7L79hopBp2G0/YC3ANg
	ecFcUlNUk31e/x5utNnyit6ZuSfSWKg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gny0QsGa;
	spf=pass (imf02.hostedemail.com: domain of groeck7@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=groeck7@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773863426; a=rsa-sha256;
	cv=none;
	b=UKjE+01+jQk21j2aEC0SANjqNkKkuPe5TX2AWUPekC+Qy6CEQ+kmUn1kLfp7OPg+qhtiiM
	qYeIavh/1zWXG1XCHo1wWW/wD4uNEzUobi8NnbmN12S36voZlF6Dc4xO1ajlB0mdIkh6AA
	T0gKtg96o0Cr67ycJRYg/aQHnbyBqO4=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3567e2b4159so228476a91.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773863425; x=1774468225; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=Resi8n+oQ1vXGyEjFOBn4ZBz6ktHZ1vnUrgtEXoKXe8=;
        b=Gny0QsGaDpnWBX81f0sZh36FXY1Tglg6PDWaGZvwRobVwU4U43G4CmJqZgJIkhvYaH
         Jpzyyfln+f2dquNpoB3J7Y0jPbJU7Tf2Hm5fVq7UGESsHsVj/Nr/35DETOoVVv8x98rG
         mNKq7Bes6y0TdBXTmN0/m4IJFdO2nzsvfmYuLnFUi4wrT6Bc2J/oAxReepqGkknVZ2jM
         lAlJzTHllNZjWbMKuBAkcstQHO24i9Hms7iX3J+D8qWhkzx6FgNOj9RZxe8t1uJmMnRB
         Rf5D/1tV945+8/klQWPeGqFqvLpqdJm5K4LUt0sVllN1bp6YLmsItdj6fb7/odgo/SF+
         rCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773863425; x=1774468225;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Resi8n+oQ1vXGyEjFOBn4ZBz6ktHZ1vnUrgtEXoKXe8=;
        b=qU8nPZ8nZAftu8528RJdCPrQLwG7eUkc4iFgSHZY7iBdTfCDLA0bcOPcvECL4vy1YS
         nJjg3OMxgMDWmkUKh0Kb6IPt0YlQ/QAQfJK1Z1mG7NB26EDoPVctN6bPQ8CDokVlAshA
         jYwmpV4zVUlobcToqmgPncYIibyBNlePXLcgILZbyh8B4DUxu4gr9p3M5HGrqm3FwPBa
         ond08vEQb/jeNDtQK7zXrHHjKy5wvxBAmXc72dUw3oKrunTlklBGw48LB0f8TNst93oV
         zRGT9pPafGDzb1tssemhPQ9JOhVRY7femjJSEEpt+X8KDUjBx517V1q4Fb87RkpGHB/3
         c1qA==
X-Forwarded-Encrypted: i=1; AJvYcCWP5qrAWHN0nsUGNnW12uOCpXGKvUbiujiuHf41OQlZxmTZhKkFmDY6JfwjS+WIsdbDGSQKe+ru0Q==@kvack.org
X-Gm-Message-State: AOJu0YyoNLve9GECNKzeXRhN2kSNCKkrB3P+XLRzDgKF1rgT6TTbC/Hi
	rp/HD+PapzPH/TG6VVO49DC4QWMB92h1fr9x5IlRl9Vf8rEcPbT36f9Q
X-Gm-Gg: ATEYQzwsaZrwSlKb8mruXlkfbeouNBOJU/xsUfispVd7F4WQrHnuwtV7Y00pxIRp62t
	W4jHJ67AuZBAj1pxR4GD/w93XsuFCUwOC8a80Z3af/n4JSUXBGnZXoqBCdNoP0VUEA2Qzji4uqc
	MN6jdQhbt9HRP3qF+oQKpHuGCDAwMcvCGJTo6jYxb2Ed0nCTH8iqrs6n9B5MKeJfwJbKb8Mqc5x
	tbR8ElNmE2iAbZPUDsOvGpcUk4FAHuYQmGPtadXYSEyE2pWpNp22kNSi7uS5UodmcNxkEpwhEzD
	T6U9QUnAYc7RBAwSQAJj+jdWeCKWaQ11uxzcklVv4DlibZYz3om0m7JD/BbS0gDrtqHeryqs86B
	gD0fkbIlSHhMWU8j9ssraOycfFJd/u1UQt0xS+7Y1ZBqmqppKp8F+elz82nT27I+9Tx7bLX1SZd
	sGwKp7sZgf6ZQ3N0Y4OPZNuVqyTMRmpJGe97BTw1oX1dz4FT16D3bXoWD+48y8Vu63u5MLPInEf
	DEF2srJb6E=
X-Received: by 2002:a17:90a:d604:b0:359:ff8a:ee5a with SMTP id 98e67ed59e1d1-35bb9e51090mr4450775a91.12.1773863424940;
        Wed, 18 Mar 2026 12:50:24 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bc618be0fsm409804a91.0.2026.03.18.12.50.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 12:50:24 -0700 (PDT)
Message-ID: <cce7a4aa-0786-4c55-afcd-4816f977806a@roeck-us.net>
Date: Wed, 18 Mar 2026 12:50:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] exec: Add KUnit test for bprm_stack_limits()
To: Kees Cook <kees@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>,
 Justin Stitt <justinstitt@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20240520021337.work.198-kees@kernel.org>
 <20240520021615.741800-1-keescook@chromium.org>
 <a3e9b1c2-40c1-45df-9fa2-14ee6a7b3fe2@roeck-us.net>
 <202603181132.507C829A9@keescook>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <202603181132.507C829A9@keescook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3DBDB80009
X-Stat-Signature: 6sf6yjz8f37m94us3mwr4uy8zp9yuhon
X-Rspam-User: 
X-HE-Tag: 1773863426-547341
X-HE-Meta: U2FsdGVkX1/yVnVJNPx7Kfn8FduLOUjzvDzCvnhBNu9bXf+FhwIPtlqvbdKpK+zQBaRJXA/Ervm3XyZbdiAvVJkjXdQH0vyDaBXwvmNtbdxOTPXbZfMkwBZtt5BHucgTVm+568fH/nbDYJGWzeSS9yCkRkdCr9YM7/Fjz2/FWJsNjvQGzs8MWkjhHqdHiOI22bwrHBdbb8Nu0oZxiK+Y+LWKPJnx1eav9ky7nITh+edOjqZ1Ub6DJG3fIQnVS6z9R2VdH8pSOEWSh3er2Qhr5jGiZprP9rwc3jucb6fpVvd4liaHkOgsDcSHajQaceZRuhQHRNWKT6TxaC0VoNoNUN/8q+D72HCIhu7wK0/i+rLwuQopk5bEvatc4Yp7GI/wye9tpdhSG9FyLHMzxPIsb2jlqxBwjFRrfegeXYPx19SsaGfeHCnafsZnx+N5Tz8qElihtHFhpD8hRPzudx08Z0/r2SX1bRnos96vmUDNL4DMGdTDABkK0GwOEuc4LBaJHHSRKxG723BfEnHMreSIVbP6JZtHrWVc2b4Q407eD6KL6m0GhzFxqcyN0aLRwjikHuelWDirJr1hkwZlkOI/Y9o3vi/CC304JlrqSiGGekQ7fJ2xH1AEITIEjqkUKhv3wHC7pjUwELQosC7fmxHhPJrW4PG11OUJm2wKR0NDdPamrNps+ESR6O0KQFgKBQjf6OdYrw588yPisQ8TvhBcCKaxvQC2fnxelSr3Kf03dc4GydgwFRQ+lRTHIpbU+T/zMLjTTEEl5cu898rz+TXAsfTb1vMMLdAPSrY3tzuyulQXTurPEjNmiKE/HbhISw6jBTeqIDwKqsBgvUAywYofdp98YNAhVtvdSRWgRQRGjrv33C0tRuQzmVP9dJUNpb1nZmtA+uhZiCiZRwW+ioqEd5zI2OUuFYr8epQBcupD7EVNjCGkTlgIISejET4GN9Fh0ZmtCtzIj6QTJbKe2s1
 H9nmDOkK
 raOfWWr8BtHQ5JkoAJWuh7oiD8Dpcy/Uwh2639zDRjYfCJ6L0TvKwG0W1SmODx8k3KIZtL3ewH2yQwTyDtaz4vTQwidWRhJA9WE2SfQJJtZ0tkRfDBRVqHHCGqiPUpf6ZyrvO47/Pe8Vvsz0xSSJfQbkGbS9q2/NGA7vdg20IJkNdXyN2GZsy1VMAHc77u4rHvDECsXsvWo8P5GOnttS/KEmkcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 11:33, Kees Cook wrote:
> On Mon, Mar 16, 2026 at 12:16:58PM -0700, Guenter Roeck wrote:
>> Hi,
>>
>> On Sun, May 19, 2024 at 07:16:11PM -0700, Kees Cook wrote:
>>> Since bprm_stack_limits() operates with very limited side-effects, add
>>> it as the first exec.c KUnit test. Add to Kconfig and adjust MAINTAINERS
>>> file to include it.
>>>
>>> Tested on 64-bit UML:
>>> $ tools/testing/kunit/kunit.py run exec
>>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>> Cc: Eric Biederman <ebiederm@xmission.com>
>>> Cc: Justin Stitt <justinstitt@google.com>
>>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>>> Cc: Christian Brauner <brauner@kernel.org>
>>> Cc: Jan Kara <jack@suse.cz>
>>> Cc: linux-fsdevel@vger.kernel.org
>>> Cc: linux-mm@kvack.org
>>> ---
>> ...
>>> +++ b/fs/exec.c
>> ...
>>> +	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
>>> +	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * (_STK_LIM / 4 *  + sizeof(void *)),
>>                                                                     ^^^^^^
>>
>> Google's experimental AI review agent tagged the above change as syntactically wrong.
>> How does this even compile ?
> 
> Wow. I have no idea how this ever built either. I will get it fixed.
> 
I ended up writing a test program.

#define TESTVAL 10
...
long int x = TESTVAL / 4 * + sizeof(void *);

does build, as does

long int x = TESTVAL / 4 * - sizeof(void *);

or even

long int x = TESTVAL / 4 * 3 - - sizeof(void *);

long int x = TESTVAL / 4 * - - sizeof(void *);

It doesn't even have problems with

long int x = TESTVAL / 4 * - - + - + - sizeof(void *);

Weird. Looks like the compiler takes the "+" or "-" as sign value,
not as operator, and once can have as many of those as one desires.

Guenter


