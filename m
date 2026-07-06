Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1471AC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:28:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA91E6B0114; Mon,  6 Jul 2026 05:28:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E805E6B0115; Mon,  6 Jul 2026 05:28:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70296B011E; Mon,  6 Jul 2026 05:28:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC1DC6B0114
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:28:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F59BC18D2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:28:49 +0000 (UTC)
X-FDA: 84957827178.11.256B1CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 448CE40006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:28:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aTX/b9Aq";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783330127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ykmRiWDKTp2R+YxHFgJA9FK7yNNqd/m2WhIWK5jQ4M=;
	b=U68rreHIDHmbAWVtY5TYSJzNnozHZkJ3o5wzYid3mIA6iYfMyiLdWM+KOPMzASRE6Se2NJ
	Wec99LBpD4AFrB0Qzz0/HUR/LN7ba3m0E7VpjGBn4WfWeyk/vEx+5Zsx52sQJ2WtrSOxHR
	FhTxHI2xJb7oq+Pz5adkHLIsmIinzPc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aTX/b9Aq";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783330127;
	b=i78CS/17MGOBDDPSmdXWyiHNciVKoQniWq2eQPbbcvhb/xtasQLq4V3nSYY8sXDRZV4t4+
	gItGDWsBKodeuX6evueptJHpebVV4rIMwHBTDRsZy2gTT7GbLFvDhzEtpuq9QLs1hvK94t
	sEtigKcIw4UmOqK8jl34PZuAPZKzJb4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2590F4179C;
	Mon,  6 Jul 2026 09:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2499C1F000E9;
	Mon,  6 Jul 2026 09:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783330126;
	bh=2ykmRiWDKTp2R+YxHFgJA9FK7yNNqd/m2WhIWK5jQ4M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aTX/b9AqMBPNIHYQA0JWD6mfBRbjzUHqE35rHF6/sWcUdn9xaQ1gbz0zeet486ZM9
	 h2QYa0intcMVSFbRL1P6t9/l6sf8tWTlyaehW8UngsmHtJsZcF823qKtyClafnxPea
	 FPd1GIJykmRjeCBZhPR3yZ8JbqAY0IVD9sBamLftlgvmEQtsJffp3b0quTVIemvGnN
	 bPKdMgX7OHpAjzTDUShGJY026rp73kT0TCLIdEusLZctlSnNAGu6RMWbQeDuc9OOgm
	 ugf1nHWDvuz0cJfFoTNT5mD77oXxMj3w1uAaPZeL5JOQ0nW07J3uFaswFjdAp+XzmT
	 0xeV5UpEFjsNA==
Message-ID: <436863f8-5840-4c3f-82ec-c55b46fb9969@kernel.org>
Date: Mon, 6 Jul 2026 11:28:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 1/5] selftests/mm: move pkey selftest helpers to
 pkey_util.c
To: Hongfu Li <lihongfu@kylinos.cn>, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, jhubbard@nvidia.com, joey.gouly@arm.com,
 keith.lucas@oracle.com, kevin.brodsky@arm.com, usama.anjum@collabora.com,
 yury.khrustalev@arm.com, zwisler@google.com, hongfu.li@linux.dev
References: <20260702062332.911786-1-lihongfu@kylinos.cn>
 <20260702062332.911786-2-lihongfu@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260702062332.911786-2-lihongfu@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 448CE40006
X-Stat-Signature: ygi1spacdbupam5ogrywy9knaftrzrzo
X-HE-Tag: 1783330127-525451
X-HE-Meta: U2FsdGVkX1/mRcGNMBiapR/4XEC602wE+MP+dJHbQq6mk2i5B3E8EzE/DUgTHrS3rqfUMjwS7tlbD5IxBLwkqMExkYgceYlAHbyoXi97Fq+fdSnF3X//DSpgxJt6rUB0bzCF9A3JC6YHxsojS9SOMADfF57wwGkwEp4jq4fUmIoJVmlDdTTa/2Yk7TNF3JWhfrxz9i2xnx9oCJ8J9jpW7NVb4QHi94r5+zCFfa5D3kgJSrfe34gSUVvWMQjVIGm0d+EF19MeHj8fMma3ofo6abhSmYC1w/++9NOUOfv64ty5PXdTcCK7GmqfIcfjOPBnKfbu0vWllgHrzjWpovnuYch99X5YwR3bMizQDI3dqVxa84ORV/cN+hftjFIv9gDZpTIAaGFdNIs6lq3t9ysNDnr46bj9GDnj5PSCLeA6oEPhA8dpoBRbXQOAjFr4KmYkWlq3oDxPY4zE9E/eQyd82aKxz/GikTtf2sgXKCRaFD/AoXS5fbkxptD39TU9t0J46/0iaGNDlQB0axIrLedV6ClCkWhvqO+0gr9d8bc7zJuO5qjsasloNK4RH9xvTBIUhaeQjp88TTS5oRS4WYDtcycBuZiOP8+pdTLS/tD1efKGAi9OCqnLq2r/aGd6LcGiixmNef1ATNzSOTb0xU37rGqqBy9OzhYae3KeQDpA31jPE+rP3sm10XcWb72q6h8dORx/YoL0s3WNzdcCB4hDAKkguIhWl9iRlmZM2vj7A/po4Fy49FxG5YyYGOREcCFGqRLTlktN1oUe7TQHpxkZ6ObJHdqgDeDn+r4rC0umNtPsu3VkCuDLE2ghzvRoAKS0RHRW151e/q2P3xUAQcs5MMSdfIIV+bpJw/gV8VsbiBm8C/d14aETB6zHph9pOEVtB528Rp0ngMYpaZpC+zgNmfi4oFWtl7UrgZB+d5q5+0FS0HGd9BFGStFpU4IkhWT3GcMdxnziIgDiXq0r/Ys
 nVPIhOvX
 jZDccSWvWxJ1WzoM32AZIAptaf40V3ybw05Mnb4XMsX/UtdrsSXHlZMzXe/6PCVkpUbpb2hwn9QWlq339SOQZNcCQwVtD66LRI8cHoej9rsEdZPZ6hXgYGCYhH8R3tU4/9AKSvkuswBRLhBSDRjyhJOPM2mXp6EQcSplaqaXwQ+VUi3a8DG3aLEAgt57g7SAO1excpvmNiIizHb++gtgSwZKiDb2kb0iga6HgOcHraW6m887gD5oGKDy6/rZKC4L7I24DjnDjnyTM6WPtl8V54WR2XUwII5JwU7NVzYK5iBxMARLAqmibdcuN7ZJgXeVZQeycnFzMZSXKMszvJAS42oygokjCd23dVVuOx6d9fqPA0FgH3TJ52cbOYV+jGvYNQjMHHy8vqirQwx6cQ4xQPMldj+JGXDe3Geh5h2xbaIggRA1TP9U8opuhe9yh0qf+t4/a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/2/26 08:23, Hongfu Li wrote:
> Move pkey selftest debugging helpers into shared code so both pkey
> selftests can use the same tracing and abort-hook logic. Also fix
> cat_into_file() to print file, not str, in the open() failure message.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>
> Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Tested-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  tools/testing/selftests/mm/pkey-helpers.h    |  4 +-
>  tools/testing/selftests/mm/pkey_util.c       | 90 ++++++++++++++++++++
>  tools/testing/selftests/mm/protection_keys.c | 87 -------------------
>  3 files changed, 93 insertions(+), 88 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
> index 2c377f4e9df1..46a8a1878dc1 100644
> --- a/tools/testing/selftests/mm/pkey-helpers.h
> +++ b/tools/testing/selftests/mm/pkey-helpers.h
> @@ -68,7 +68,9 @@ static inline void sigsafe_printf(const char *format, ...)
>  #define dprintf3(args...) dprintf_level(3, args)
>  #define dprintf4(args...) dprintf_level(4, args)
>  
> -extern void abort_hooks(void);
> +void tracing_on(void);
> +void tracing_off(void);
> +void abort_hooks(void);
>  #define pkey_assert(condition) do {		\
>  	if (!(condition)) {			\
>  		dprintf0("# assert() at %s::%d test_nr: %d iteration: %d\n", \
> diff --git a/tools/testing/selftests/mm/pkey_util.c b/tools/testing/selftests/mm/pkey_util.c
> index 255b332f7a08..fbef3cd45447 100644
> --- a/tools/testing/selftests/mm/pkey_util.c
> +++ b/tools/testing/selftests/mm/pkey_util.c
> @@ -2,9 +2,99 @@
>  #define __SANE_USERSPACE_TYPES__
>  #include <sys/syscall.h>
>  #include <unistd.h>
> +#include <fcntl.h>
> +#include <stdio.h>
> +#include <string.h>
>  
>  #include "pkey-helpers.h"
>  
> +int iteration_nr = 1;
> +int test_nr;
> +int dprint_in_signal;
> +
> +#if CONTROL_TRACING > 0

Who sets that CONTROL_TRACING? And if it's nobody, why are we dragging this along?

-- 
Cheers,

David

