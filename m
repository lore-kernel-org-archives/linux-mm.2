Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37AE2C531F9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 09:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23CAC6B007B; Sun, 26 Jul 2026 05:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EDB06B0088; Sun, 26 Jul 2026 05:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 107296B008A; Sun, 26 Jul 2026 05:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF19E6B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 05:11:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68C8AC040F
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 09:11:09 +0000 (UTC)
X-FDA: 85030358658.20.FE28154
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7BEBE40005
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 09:11:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AuXDgXiD;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785057067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICOJwuSDvuHi9URQG65TdcLtMh67S626va+a/RQ8YeI=;
	b=h+p02Y0WWnEglsKJARuogvHNym6gCVO8EdGz9Tu9VzdPyVE8LN/raxTxICG/OdWIuoiKJi
	2n+FQmuYwORV+5Ogr6CqTM61Y7HsZOyutq/jAi0qu34lTqyFCZtLxHG2lDDeb4qaipRzbE
	rQ+MEXSZQe5ZtbPnuEuoCw3k0Yy86Os=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785057067;
	b=1OzaCeCg2ToY1CnBHyul9zTUeXcgdyXoFwSC0OGsZFBfb9XVff5gLXM8XLwKAoMsccth2B
	23K+iaaZgaSHBae6v6+Vr1PQafR+Gn/BV/Jt/9RZ5tU7VFB7IflJ6XE1twnmjBi3M35GTT
	WjHr14KG+ZciTL7IqkoTEYXpKw98IVI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AuXDgXiD;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A8452F;
	Sun, 26 Jul 2026 02:11:02 -0700 (PDT)
Received: from [10.164.11.0] (unknown [10.164.11.0])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E95443F9AB;
	Sun, 26 Jul 2026 02:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785057066; bh=W9hN+Hjprkh7hB1ShaJYeWbFQzeyeWs59WNhDGKcnXE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AuXDgXiDoyVrBC5JrhEuQsaqUDh9/48zErLZQxIA82cxV+RSfYsEOVClCu6slrQJt
	 VGOMgszc9vYffiaH7TeimUlbGlwTPS99Frnomrlgm2Ooagv6ietgC0KpLAlx+uW+0l
	 LXbXpj7Q2Tm8mRWqD7VP/6qU6c+CsAKq6pJeKr04=
Message-ID: <0f337417-2fdb-4f78-b98c-0571c16ca210@arm.com>
Date: Sun, 26 Jul 2026 14:40:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] Optimize anonymous swapbacked large folio unmapping
To: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260723070905.3422276-1-dev.jain@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260723070905.3422276-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7BEBE40005
X-Stat-Signature: dmwwzhbgoa1r3diszutue7ckofitrarg
X-Rspam-User: 
X-HE-Tag: 1785057067-593117
X-HE-Meta: U2FsdGVkX1/Zh9AALUMaMhvgy/jPJdiC0BcT0g05BdgA8J8ExPCUWwHeP+IvgYp/v9jhcVW/97hg/HkyNLdH/8v58YlALV2jlWtBvJKKU36nkZKzVu2//3g5Cb3ihGmnKrVYWjXnfR22BGxh3LDB7X78KtClwPZjcGagvdCvrPga3wJCOlNbc6y/SoyT/JoVI+bhd9OOYNwOREdylZ+4IN0RyCf0tULj0Efaw9Gw8I7/yza+AM9uRen48+Xlo0NtNY9YiMKNY99XGDJiaS3gM2hDhUSYmvSHFXe25ZNT7MSFtcv3gbWVbcUHGB+A8STQ769zrwIHz9hyPYbe+shZ/NlKgtTR9D7Vq/Vx11uB+KNnTaU0hkkZMjTr6ePxa5E0l3HqE4k47YJr/YW7L7POFR0Y1X/dHxDRnaGfQ6LkdF/u68iQY0+MIOLkHxnT04Z5LjnPJyhV5yKiqwYvUq6f9atA1W2nvLQTei1ZgQZILcv0KL9qu9b1HxyqWpt8Jw0B4wHk9aqTfIa93MDJqCWxXKC1SB26vUQ24rf/4jHvFkKSj1RekD6qfBzgMjO+CURHMaUCNO1bnOG0B0iCipxFpIoScbocitUSYaRBZkKrsJXyCs8UY+URc0IerRqK5I5EPPAAimVbkXl/UyNjddIfaTlChuDbLAfBwYNxF6xCmi4d66Y6WjPDTQxGZGSlG0vv3WNkmxg9mY4/32V5w7lg+S8UiTaIxUjrzmKUVR2bFcC0PUDLYkbNfpopTd9TtTk65eqA3u6bJFdEjjARUOZhTKltjBHEiYqMrCpFjf6u+jyDn0oR7tGMTCIBqiUH7aXjZW+GXHFd2yeRmunleD0yR+Y97l5Q5yBF4Jqv7tZkgdHP578rK6bZkgsTky7DM/w6Fj7vHJ0VvPU9CH31mK53529g35EK1VgVAQHVWpxTFp+JVcLhSVRNWYLhrRaXJZutn+HLa5hK/wmdtIZSq/j
 kM1u0Ohg
 8UZGFF6IUZ3QaCa5nn8FyHIE+5I4Ai84rH9fhmKVPefa1WJpKNOkN2h4UHxi8UGu+sdD3FZJ13/2j7dHuMDaeAhR3MuZuBLqWFKq+5gRTX1ui2T7xDlcfnWojMM4afUhEeU6dYD/2ezLl7tJEh1XPy7OhLScXtPwO8liJcKzDrBkSRIMUwZa/hk62v2xMMOos/LQuAEr4oH7rDIvuIdbev1mT8bo10UzqiU2iEemlPYmQO3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/07/26 12:38 pm, Dev Jain wrote:
> Speed up unmapping of anonymous swapbacked large folios by clearing
> the ptes, and setting swap ptes, in one go.
> 
> The following benchmark (stolen from Barry) is used to measure the
> time taken to swapout 256M worth of memory backed by 64K large folios:
> 
>  #define _GNU_SOURCE
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <sys/mman.h>
>  #include <string.h>
>  #include <time.h>
>  #include <unistd.h>
>  #include <errno.h>
> 
>  #define SIZE_MB 256
>  #define SIZE_BYTES (SIZE_MB * 1024 * 1024)
> 
>  int main() {
>      void *addr = mmap(NULL, SIZE_BYTES, PROT_READ | PROT_WRITE,
>                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>      if (addr == MAP_FAILED) {
>          perror("mmap failed");
>          return 1;
>      }
> 
>      memset(addr, 0, SIZE_BYTES);
> 
>      struct timespec start, end;
>      clock_gettime(CLOCK_MONOTONIC, &start);
> 
>      if (madvise(addr, SIZE_BYTES, MADV_PAGEOUT) != 0) {
>          perror("madvise(MADV_PAGEOUT) failed");
>          munmap(addr, SIZE_BYTES);
>          return 1;
>      }
> 
>      clock_gettime(CLOCK_MONOTONIC, &end);
> 
>      long duration_ns = (end.tv_sec - start.tv_sec) * 1e9 +
>                         (end.tv_nsec - start.tv_nsec);
>      printf("madvise(MADV_PAGEOUT) took %ld ns (%.3f ms)\n",
>             duration_ns, duration_ns / 1e6);
> 
>      munmap(addr, SIZE_BYTES);
>      return 0;
>  }
> 
> Performance as measured on a Linux VM on Apple M3 (arm64):
> 
> Vanilla - Mean: 37401913 ns, std dev: 12%
> Patched - Mean: 17420282 ns, std dev: 11%
> 
> resulting in more than 2x speedup.
> 
> No regression observed on 4K folios.
> 
> Performance as measured on bare metal x86:
> 
> Vanilla - mean: 54986286 ns, std dev: 1.5%
> Patched - mean: 51930795 ns, std dev: 3%
> 
> I tried magnifying the difference on x86 by using 1M large folios, but
> can't spot an obvious improvement (looks like my system is too fast to
> benefit from batched atomic operations!), hinting that the benefit lies
> mainly in the reduction of ptep_get() calls and the reduction of TLB
> flushes during contpte-unfolding, on arm64.
> 
> No regression is observed on 4K folios on x86 too.
> 
> ---
>
Sashiko:

Patch 1: at that point there is no caller passing 1 < nr_pages < folio_nr_pages to
folio_dup_swap_pages(), so doesn't apply.

Patch 3:
a) yes I can add a sanity check here, something like VM_WARN_ON_ONCE(page_anon_exclusive_batch != nr_pages).

b) There is no caller passing level == PGTABLE_LEVEL_PUD, but for future-proofing I can change this
to level != PGTABLE_LEVEL_PTE.


Patch 8:

the is_defined() thingy is wrong, I'll change that. This was pointed out before too, but in between
splitting that series into multiple sub-series, I forgot to incorporate this change, sorry.



