Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E44CD4F57
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 09:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9AE6B0005; Tue, 19 May 2026 05:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AAD26B0088; Tue, 19 May 2026 05:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDBBD6B008C; Tue, 19 May 2026 05:57:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D8A8A6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:57:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83267120286
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:57:44 +0000 (UTC)
X-FDA: 84783717648.30.2A35423
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D48664000E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:57:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KAjf8cDU;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779184662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1EjH7o9lkTA87riZrU42tHISO3JAqsF2/99hMyksSh4=;
	b=0AhDUm0Dd/zFaTQ7CJ7Iiwqn9xSDud8d42ET78R5bdgNhj5bs8VDL31MH1m3fNnpBFjj1C
	e1TqFX3ga/lNH/piUi7oxM3dztMyuJkF+V7XosGbrjTBLSnkdLEz6d3HFEtHtlPxF+sRxq
	xY9LJXQgDR8fPr/vAgUAPGj0ZENm9jY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KAjf8cDU;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779184663; a=rsa-sha256;
	cv=none;
	b=nUgRvWatdPnlBR8a5QAM6al5jMWvS8NHtOt2TH936N0QZ91amkus7k+1AMHNr2x5gPz7lv
	WHW9vY+QO81buIGkMtls0nbYKImsYszP4jRgIWhGpp0TpT5QSmx6y2Gr0Mofo9i63571BM
	zvR2n6YSYQEUEWJXnVHYfVbnzm2X7Bw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 09B954387A;
	Tue, 19 May 2026 09:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2CD0C2BCF6;
	Tue, 19 May 2026 09:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779184661;
	bh=/mEyPpYJP1wJFopm9f9dnhO4LeuJ33cHQQJCxlPEN0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KAjf8cDUJD+A4i/8IGbEbsuDE6P49BGZS9qpXvbOOa795GPwxfQZRl43GrkT1sHKk
	 LDeZkQYsuM4HOUFcgT4L20slUwxsa3W8i5RmGYuIhgIroytg+HJSGpX3JMaKGrVph7
	 1s68+W60mvqqXnrEx/EgW25n+d6Y6izrmb0mqX+UbOsp13SaXK09fKEOQl4WQKYA3c
	 +biCb1zbyA0kH4pO9odCn3wx3tWK0VFyz7uT785HzUnkcAg4MgfXDQ1ymflgqW7fg/
	 pDx2AYqwFT3i2Kr8mhwqTj9+d+884MlC8/vhsv5ERPxFWL4Ua8JClrBmDLAIsAH4rM
	 McB0Gt42kP50A==
Date: Tue, 19 May 2026 10:57:35 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	vbabka@kernel.org
Subject: Re: [PATCH] selftests/mm: add missing mmap() return checks in pkey
 tests
Message-ID: <agwvkyXSlZ-Suz7j@lucifer>
References: <agrrp5fRWWuMSoYB@lucifer>
 <20260519091626.371028-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519091626.371028-1-lihongfu@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D48664000E
X-Stat-Signature: can1uuxoogwa4itzadd5ygwpbaxtfnm8
X-HE-Tag: 1779184662-600484
X-HE-Meta: U2FsdGVkX19vGVIz4KRu5MNraaMb7ESs/MzZEKs/9UZlJ8KkJU3/p00tfyHBDgLc8qdX7eGUGTZy53oDcQEu/n4DGkpqXg3RFHNPp3/e0JjHkqI+V9Qd8xacK6HTdH0L86+vWpZEH5cbVCiGkoxCInYrU4XiCYsp9qkTeJulQdRHqz+E7oouDLzROmyeR4CXhtVKDmcJB3AQi+9IevZNV940mBHKx5596+BwT/ISa9HWZUUIWIhSMvKVXC3oCuDRT0lpwtj2QG1JVMLeID4R791zd1V1yQS4Lh/UcQgR1C5D/ngmGVpBuHvFBl0VC0RtSn2qvMcFAOzcv62uOgaTuA8YktcJKIo/3j0ZM4tvtpb1Nvo5dxCsQNNQp3BBlT9oNgBp7vIW31CMfwFj04ndO05LzEaJgKs2hzSsT2SU/uwYV0+i+qkUTqWKO6SfXJkNOofrT3sCKnb36JGDAAn4yYui9fPGJKx68lcZFTr2uFVZx7a+lDEd1KYVskh3nZ3XmFO9D/q8QSjbhuasA6rPw5UWtOPw++6d7j7mbuSnegCMGdCx5QLFU+bvmOXnGNH2yQJSYevFuSH0rVHKyzXYt/slQqDzfNu9FF0kmdKs/lZh31OwaIo2mvE99qfnWv+04zsVTpjYy3xz7vLF8v6Kz9mnYebvOEHvLp7GLpSFXXElQpY4HriO59fB+EMrbfKfkONiWoyZAkD04kfinaA1RHqRBbEocjYFTynsILhJZ0epHLS9rsPxZrYk9qIgYbQ2M4yKNTEHCC6rc4/l8mAj6jpKvdZVOuO8GkUjO+r430FuubNHebCRAvV7kpNafTqQ0KLMbvO1hSqsUExZyBGj5iFG3ZkhLgEYwAuqaFLotmHiNSbrAk4HQ0icA4feVA3MviHpjtAU/EicdGrY51eZGVCoxcjbCemiGAuBySk/Ri3amIyQz0VWsItmvwRNpC6Iy+m1yhfE6gLXsnz0IWd
 qpvT147+
 AsCN9Z0pTZSSzh+VU3STaXWdzfK8A07rBgWbaAdKkePaWkKgTrE3ro4hjq//ZdIW2PSO10ImqjX/aEHu9IZ+fVDBlk5N+k2sptWMFDIWFqaRMF2MTVhzNwOcBpqIfh2wY+vY8+ug4joYgucZ9jFW4zqfOrMWsrhIg9ptmN6ynUEhD+mnX9Yv0Aim4nRz7bx5lDnkpSAE7ynGnevH8oCYy838gI6WYP5ayLUY97u+hQpGD844z+3t/czxl0FC8Cp4AEalJsk81BejYjXRc0OisH/HZBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 05:16:26PM +0800, Hongfu Li wrote:
> Hi Lorenzo,
> Thanks for the review comments.
>
> > Hmm you're sending this separete from the other MAP_FAILED checks, and not
> > referencing that in any way? (original patch at [0]).
> >
> > Please just send this as a 2 patch series _with a cover letter_ and both patches
> > in-reply-to the cover letter.
> >
> > Also make sure to propagate tags correctly.
> >
> > [0]:https://lore.kernel.org/all/20260513095609.789935-1-lihongfu@kylinos.cn/
>
> The first patch has already been merged into the mm-new branch:
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?h=mm-new&id=ffe64def0071989cff47b5525d38f5e558c637c3
>
> For this reason, I split this one out separately to avoid confusion.

Hmm ok so you sent a v2 that was rejected [1], you were given feedback for a
respin but the v1 has been taken + not updated?... That's really not how the
process is supposed to work :/

Bit of a mess, Andrew - maybe best to keep the v1 then, and Hongfu - you can
respin this as requested?

[1]: https://lore.kernel.org/all/20260513095609.789935-1-lihongfu@kylinos.cn/

>
> > On Mon, May 18, 2026 at 04:21:20PM +0800, Hongfu Li wrote:
> > > Several mmap() calls lack error checks and would crash on failure.
> > > Add the missing checks. Also replace bare (void *)-1 with the
> >
> > Well you're assert()'ing so you're causing a crash on failure anyway?
> >
> > I'd just say that you are adding missing checks against the mmap() return value,
> > as well as improving readability and consistency by replacing (void *)-1 with
> > MAP_FAILED in instances where that was used rather than MAP_FAILED.
>
> Thanks for pointing this out, I will correct it in v2.
>
> > > diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> > > index 302fef54049c..4637809192f9 100644
> > > --- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
> > > +++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> > > @@ -317,6 +317,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
> > >  	/* Set up alternate signal stack that will use the default MPK */
> > >  	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
> > >  			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> > > +	assert(sigstack.ss_sp != MAP_FAILED);
> >
> > Why not pkey_assert()?
> >
> > >  	sigstack.ss_flags = 0;
> > >  	sigstack.ss_size = STACK_SIZE;
> > >
> > > @@ -490,6 +491,7 @@ static void test_pkru_sigreturn(void)
> > >  	/* Set up alternate signal stack that will use the default MPK */
> > >  	sigstack.ss_sp = mmap(0, STACK_SIZE, PROT_READ | PROT_WRITE,
> > >  			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> > > +	assert(sigstack.ss_sp != MAP_FAILED);
> >
> > Why not pkey_assert()?
>
> protection_keys.c executes numerous tests in loops across multiple iterations,
> so the test_nr and iteration_nr printed by pkey_assert help easily locate the
> exact failed test case and iteration.
> In contrast, pkey_sighandler_tests.c consists of only a few standalone test
> functions invoked once each, so plain assert providing file and line information
> should suffice to locate failures.

Why would we not want more information here? This argument doesn't hold any
water, please use pkey_assert().

(BTW This reads like an AI generated sentence. We're fine with you using AI to
assist with English for instance, but please make sure it's your own thoughts!)

>
> > > @@ -1775,7 +1776,7 @@ int main(void)
> > >  		printf("running PKEY tests for unsupported CPU/OS\n");
> > >
> > >  		ptr  = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> > > -		assert(ptr != (void *)-1);
> > > +		assert(ptr != MAP_FAILED);
> >
> > Probably best to convert to pkey_assert() at the same time?
>
> This is a pre-test initialization path that runs before the test
> loop, so test_nr and iteration_nr (used in pkey_assert for diagnostic
> output) are not yet set up at this point.
> Would using plain assert() here be more appropriate?

OK that's gross, please just replace it with a test failure kmsg_xxx() whatever
it is, and a return EXIT_FAILURE; or something since you're in main().

>
> Best regards,
> Hongfu

Cheers, Lorenzo

