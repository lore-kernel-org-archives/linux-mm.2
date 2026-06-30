Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ECC9C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 08:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 561D66B00B5; Tue, 30 Jun 2026 04:59:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EB506B00F5; Tue, 30 Jun 2026 04:59:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4136B00F7; Tue, 30 Jun 2026 04:59:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0AF2E6B00B5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:59:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8CC91120404
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:59:56 +0000 (UTC)
X-FDA: 84935981592.12.83188E3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6099A140009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:59:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=efH2a60X;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782809994;
	b=DCDLKn9wiQuZSvLlWAGtq9dGn0wf/CuVVx9krGDRK9ipF5U/Zrg5Yh2URLwXaIQiCljZrM
	nXAT0HQgSXCeJmj60xHtgIHP6q3ePwhDQjga6dxrSH444ZRRqNe3mrtJ9Vs7LP3N0U8yfN
	KwshyH8qeexx2cLDiamdRWIdZbqUOCc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782809994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQWLiAj5Np0iB+3CJvrayjt8jX/TQGhX10D46KwJ8ns=;
	b=3sZ3kvKmnN8xf5OohXgfnfJrUj9INvI877R8JRF7vUPTP6iCPuTuozhDRhA4VWz6nfm3SZ
	9g+xBOEHNwag9KoffG4MNIhlbpTLVEY0g8u+DdKEuw2XpknJ/UGbmTJRY2Yq5KEMGYrMa3
	dGqs6gQ9HjA356kww8CVet4bhjUWaD8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=efH2a60X;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E31FD2C1C;
	Tue, 30 Jun 2026 01:59:48 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8055D3F905;
	Tue, 30 Jun 2026 01:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782809993; bh=3AqJp5i7XIK+jRB+gWzzbQTkxN1da8ybVT+nch5RbIk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=efH2a60XTMLqXCin030aJfgiBIrLDjzaEAGTvIuHMIxezgFdlj/vhszDkAoTvyvr9
	 SuuU8ohtWyZDhewEGi60YBBMw8nakSWsmsr+eNWPayC7fveSjZuZlobeLjNTC8V/Ig
	 pA/O46kRhBqwq5NjpKC99EwbVh5wWlc+np71zIeo=
Message-ID: <5d72fce2-5acf-44ce-bf5e-3ee74611c6e5@arm.com>
Date: Tue, 30 Jun 2026 14:29:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: hmm-tests: include linux/mman.h to access
 MADV_COLLAPSE
To: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
References: <20260628143111.36863-1-zenghui.yu@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260628143111.36863-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pu349o95p85hxrf1rg3gnix1p4mk68zp
X-Rspam-User: 
X-Rspamd-Queue-Id: 6099A140009
X-Rspamd-Server: rspam02
X-HE-Tag: 1782809994-82715
X-HE-Meta: U2FsdGVkX19j05yNCrGZDHJQ3R6Oz3AfyKE9APZw0NN8w0lOjPvL2RpOsLOEGxYvKfcHvlPRVizAXz+GUz9Kc3cYUDWl3T7AqhX0nS8UA9m8/CeJipSsMbW8Gvwk2FoZ4PE79xCZDz7komVVKM6Mb7UUTJ3dilmte/jT9izPXRZPm2efDzBz+NkixxXjkw2GBC8cuoo+IWwv4u/F21/qwJcnkje+/jgiWd6AdQGwQJXNGG6l5M86VSLI+M2vfe4IMURHMU8B7Ao27tPH1KhdoLJFPo46z8dCJs6YmD2CTnbf0YvuDbtTq9ZlzHWQJrvtkwHevLvfAyTW0oUCTXIjzrJqAHupiPG6uJfd6vTA/9bgAWnUNaM/X9WyS6IhMAxGxYlcMl7CBBSB53vEG+f6jvzzkCKu3+TAe8GMd/whCF6ksjFDGSfuahfHxfhCn7u8r/GFVwQgUtxCBtJg+BDUQMxIw67qdXNgcvI+XncTLdJUBm/OS+5gRnXX7jOLqC07PWBA3FRxkGXjE4bdyTpkvjTmfcG/Or2HBD5dTweq7bRZreKQzzy4KQxvnbJQ9JWL7/4CCazPtjv0BIInbwt1H6lilvlibbJXd7dvYQrPMLTdaBZrZGoegsBghCiY8vEWofKjCS6sbWbOeUSQi2DK7H352Ys9zNR0y2e0FdgHBu0vcBDpUN0ToJb3NCmn8/2uSrSVF60Z+aiV+HJDPrxcBUHp2Pow97VV5usbNS4xPxDBo2uy77nNgcUXji+yVxUp0DYJhbOU8VTfAiuzeaEZJOhrymilmRfqIock42B5yd51M53vqbOD7IPxELNMa+hYxBy5x234FOqnxjk4jL0eooyvYmz8ivdayyB0Plu3iE7aQIAdqXOpEyzhA+WYOC1G7KIHKx+fsacIeUiGV9ew6TKW6HI6mmtgxorrnjw/epB/p0DhKOraiWuCO8+sIwqk2YYTeocZiTUiRiyczmm
 NBar8M47
 FW3BK8ei9BaEsrPhIj2yBIBuGlRZqqAZgPwkXv/R7+CqmzcJQ/vswuelD6O2r8TIdEzm12PKpnmPhQl4zuBVDHqF1HaX9t035hhyOKuLMHbxj3O6tkfZAAzX3J2tmHldUGVapFd1zg/81VwY8yNz0R9TfdQ/OeSNL3KOaOqfbPx7iOiQLTYHnKFHQvz2OqSWjzRnthGnTmBiMgNjNEhXV8tu7wUpMe1WXdyDGenpmiXj9iPbqOhLed4waOf0f0S9zVbk/JH8oSbHVui1LOK1zNaWQG8JFvLDpb4w8jhgG4VJD5sljvNTKra8sKkM5MvuP0Go8cedCjOcGL1tOEN4n26SHDEwdNZvu+CsEyXkhqyRQwSXS6bWD/iweIXi3v93urJz5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 28/06/26 8:01 pm, Zenghui Yu wrote:
> The following compilation error occurs with an old version of glibc due to
> a recent commit adding MADV_COLLAPSE testing:
> 
>  [root@localhost mm]# getconf GNU_LIBC_VERSION
>  glibc 2.34
>  [root@localhost mm]# make
>    CC       hmm-tests
>  hmm-tests.c: In function 'hmm_migrate_anon_huge_fault':
>  hmm-tests.c:2355:27: error: 'MADV_COLLAPSE' undeclared (first use in this function); did you mean 'MADV_COLD'?
>   2355 |  ret = madvise(map, size, MADV_COLLAPSE);
>        |                           ^~~~~~~~~~~~~
>        |                           MADV_COLD
>  hmm-tests.c:2355:27: note: each undeclared identifier is reported only once for each function it appears in
>  make: *** [../lib.mk:225: /root/code/linux/tools/testing/selftests/mm/hmm-tests] Error 1
> 
> Include linux/mman.h (which provides the definition of MADV_COLLAPSE) to
> fix the build error.
> 
> Fixes: e3d8707358ea ("selftests/mm/hmm-tests: test pagemap reads of PMD device-private entries")
> Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>

>  tools/testing/selftests/mm/hmm-tests.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index e4c49699f3f7..2f2b9879d100 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -23,6 +23,7 @@
>  #include <time.h>
>  #include <pthread.h>
>  #include <limits.h>
> +#include <linux/mman.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
>  #include <sys/mman.h>


