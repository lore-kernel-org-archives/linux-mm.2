Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 277E6C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 08:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3008B6B009B; Thu, 20 Aug 2026 04:40:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28A146B009D; Thu, 20 Aug 2026 04:40:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A3EC6B009F; Thu, 20 Aug 2026 04:40:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA4076B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:40:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 615DA16052F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:40:58 +0000 (UTC)
X-FDA: 85121002596.03.BEE0514
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B47C416000A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:40:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ivA5gWwo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787215256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBdjBx1YsDTFwnZ3I58K5RxANHs66TKFjnUSFDktRdc=;
	b=rtrgrq8D9rtrxwu+fHgnV4/09pYalOYMJDOliGAUIf/COqGf1gVIdCgvSnQUuu5xgkZ/Zd
	pVjGkwYl0ohDYYO1LI9/YffCYS6sucruG+0SMiPdmCXmnQaJeIEhtzQDQRwsuAvyQzbR1x
	t3bf5uqMm1nYuNRQmoXYxE3cE3raNAc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ivA5gWwo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787215256;
	b=lAkPVJP/rfRSokmc3g1zcbelTArZw6d+kVh7tCUkIMZsGz9zL0mwplmFelXvDw8qVfLzpk
	VVtup/UU0+mFXzHa3qeisdDHxHa+M8BZivvJgWqQMxak02BDc0ao53+205gU+0O1lJ0SXU
	xT3EFmh+f0xGTxtZ8pAuv3DSYMRymbY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C9A960AA9;
	Thu, 20 Aug 2026 08:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA301F000E9;
	Thu, 20 Aug 2026 08:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787215256;
	bh=gBdjBx1YsDTFwnZ3I58K5RxANHs66TKFjnUSFDktRdc=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ivA5gWwoA5e/8ObfYdUslPWKBktQN8We+u7eqmXGqWx6wV4i3FnezogcK8DARaDdD
	 qvLOAaM1T7LfWWSXrpreNCWDD2U9MLDfdkHiAuRhQzzglatIj38K8m00QbYdLrUcWg
	 nvAbMLQ2wDbCgb/Rgi9VI4F3aXWQOft3d6/xD68fThfOlyUAG3fc8A5qxpMZKAwbCw
	 889CtZwTeWR2cxPrNTq075JIDkUA7HDYG1cajaZWy4unl8e5Ltrfkb8yt7MZDEJvC/
	 XPccEyXGiUQuWgytEw0ZgcrYoH1O3ZzGWw9djkNFB6UeAlvYOVr/Cdf8QPpMKCaUTf
	 yMBZJITjP6IYQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 05/19] selftests/mm: make the swap cases' swapout
 reliable
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
 dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
 liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
 shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
 vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, 
 agordeev@linux.ibm.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kas@kernel.org
In-Reply-To: <20260815015901.1236937-6-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-6-kirill@shutemov.name>
Date: Thu, 20 Aug 2026 11:40:35 +0300
Message-Id: <178721523516.2799959.17614116166980239496.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: B47C416000A
X-Rspamd-Server: rspam07
X-Stat-Signature: efigw8jxc4r9at6oz9gqoimc7d3uiin6
X-HE-Tag: 1787215256-964708
X-HE-Meta: U2FsdGVkX1+giDmyMSlh8ofNqMYmzJg2Fv9UtudRZEhZM80h27O/O8Bs5VROYEdQGB6ym/uBxhy0r7stq3E4vninyZt6IM/pWR5/BxuwiRXGPd1PeJtoKC3HHr8PEMEFFtaH2LtyP8r7lm/UD2RpAGQp8SO/1sVHC8huM3Gx8McR+Blq+c5BX5kJuuOsalYkvkgIA67MmEXamoTi/myvl5ZeRpb42Zfi/BA1BnDSoZBcHzO8lDvJw+tq6Lwz48iaWhUgeHNUwSs2fuy9s+GtNk/qng7bFh1HwI8eNpuSWp0JbqabG6SvCu6xwAjBS4rxqQRlQNTb1EoXKh5DzroIXldpACSixjWF3zg1BIxCIjHshhkMq44yzkO6bPEsA9g8YH2n3uBoajfoh7aQzQjWS6jy4cLx68jMG5HiribHvr5NvZPMr06HeL3MMAleLSCG/kGWbYofF4uYGT08zd4miTMIfaX+pcnnGrRwzDkZ12JNqhd52i7DgZoc7UGoqx0XKChtCdwM5y4bYC05now/bhUW5xLcUdvV0s29n8p2hD1FuRgjierokI2vw6VBjeigQTVdTIHrPNEVFdT9B0PD5Lh716SkOnNK4J6FBosNlgVwBSzER51wnBOfuduoahYEDMDOD343VUg0Mq1524vkr7Qyk+58wjQZb3ZoVT2KRGkLLG/Kon4ib7uELi2WyeYhfJOW8XBrFcEGt4qKLLSWd0+3q8pSb+fJGfNEehSVX5bEyIHvXTXxJ9Jp+wgyimTQ3fNhXXQTjzoP5reh/O6Npq6BQMYLW0fxr7RsA2w52VKnRcK4TeY20PSHjtXSVe1+D80ycvu+EF5eSwTuBsNmaFh83zQZ4qVMWfWDtz/34chPjoQX3jofKjRjTXdOyJUzHPhNx9OddLgZOkqzRGIL6Oagljn/wdH4M92zkSC+YwkqWioUZRXyHkC7zyMIwSSDy7+UIKiCTFLTcVvOoKS
 t+GUV2Do
 tOvLMBEc5owCI7lQsumURRkdj0v4GxjBZyVFgSrHaMTM5ojSpeCsgZTRvaafDmJwfQXWqW3gU3WiE/s66JEaJ8K5o6oyrEyrTvIUagVSpjpxFVhe3LNeYY8ozYWQRfrOtJeLgxnYfazDFEdhBLJ93v0uLVgWB9Q6CeOgAX6CL7QEBnEGjitL7xp3/+kg0r3cxMovMdPQPL4S35FsIKInLlh190AMBipbr1fHYmXyGRv2JMQr1KUQpxLgGwx7POsjy4JYfcx/GeXHp2SUjoC4atFdiBt832FTMmkY+Xeqa5K8uykI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> collapse_swapin_single_pte() and collapse_max_ptes_swap() swap a range out
> and then require smaps to report exactly the count they asked for.  Two
> things keep that count from arriving.
> 
> MADV_PAGEOUT is best effort, so the count often turns up a moment late.
> 
> And wait_for_scan() leaves MADV_HUGEPAGE behind, so khugepaged is still

"... leaves range as eligible for collapsing, so khugepaged is still
working on it."

> working on the range.  Collapsing a range with up to max_ptes_swap pages
> swapped out means reading them back in, so the daemon empties the swap as
> fast as the case fills it.  On arm64 with 64K pages max_ptes_swap is 1024
> pages, which is 64M a step, and the case loses:

".. the case looses the race:"

> 
>     # Swapout 1024 of 8192 pages... Fail
>     not ok 10 collapse_max_ptes_swap
> 
> Ask again for up to two seconds, with the range held out of the daemon's
> reach while asking.  The collapse each case runs next puts MADV_HUGEPAGE
> back, so only the setup is affected.

"Retry several times for up to two seconds meanwhile holding the range
out of the khugepaged reach. The collapse each case runs next restores
MADV_NOHUGEPAGE, so only setup is affected"

> 
> If the pages still will not go, skip.  A machine with no swap, or swap too

"If the pages still won't swap out, skip".

> small, full, capped by a memcg or busy with writeback, is not the kernel
> under test refusing.  An error from madvise() itself still ends the run.
> 
> Assisted-by: Claude-Code:claude-opus-5
> Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index b436b401e2ea..a3d14cc1a2bf 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -241,6 +241,41 @@ static bool check_swap(void *addr, unsigned long size)
>  	return swap;
>  }
>  
> +/*
> + * Page the range out and wait for the swap count to say so.
> + *
> + * Two things get in the way.  MADV_PAGEOUT is best effort:
> + * shrink_folio_list() leaves a folio alone when it cannot reclaim it right
> + * away, and one still under writeback from an earlier pageout is the common
> + * case, so the count the caller asks for arrives a moment later.  And a range
> + * an earlier collapse left MADV_HUGEPAGE is one khugepaged is still working
> + * on: collapsing a range with up to max_ptes_swap pages swapped out means
> + * reading those pages back in, so the daemon undoes the pageout as fast as it
> + * is asked for.  Keep the range out of its reach; the collapse the caller runs
> + * next puts MADV_HUGEPAGE back.
> + *
> + * Failing to get the pages out is the machine's answer, not the kernel's --
> + * swap too small, swap full, a memcg cap, a folio still under writeback -- so
> + * callers skip rather than fail.  An error from madvise() is different, and
> + * ends the run here.

I'd replace this cumbersome comment with

> + */
> +static bool swapout_range(void *p, unsigned long size)
> +{
> +	int i;
> +

	/* prevent khugepaged from swapping into this range */

> +	if (madvise(p, size, MADV_NOHUGEPAGE))
> +		ksft_exit_fail_perror("madvise(MADV_NOHUGEPAGE)");
> +

	/*
	 * retry several times because MADV_PAGEOUT is best effort.
	 * sleep between the retries to give a chance for outstanding
	 * writebacks for pages being swapped out to finish.
	 */

-- 
Sincerely yours,
Mike.


