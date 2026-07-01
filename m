Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA444C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:49:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F03D6B00A6; Wed,  1 Jul 2026 04:49:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0E66B00AF; Wed,  1 Jul 2026 04:49:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791A56B00B0; Wed,  1 Jul 2026 04:49:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47B0F6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:49:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA50C4023B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:49:33 +0000 (UTC)
X-FDA: 84939584226.28.093B874
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 129C8A0007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:49:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DtVstI2T;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782895772;
	b=qRm1ZvHoU5BYoksGR021vWk1c5Tp4SF2uxU/RG7kWP08jDRHw8Bg2X7vTZY7SgCcL4omTa
	yZ92yKxov4RmviiERRw40Hu+26mokG7dxfNegpN6FpWsKHqibklcbYADhrI9In3MY4LlwD
	bYCaGK7bmNf4B+75PJ4uFjBindcnLlY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782895772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wFf7KfsOWULyJC/rxUEjNrPqHgWlpCLk8d+mkUM8clA=;
	b=lUDEDHYSSZdXNmNkcIa7TsuxLi4jeKjZH7BFqw+A200ohVASyMeLPIQniPdD/jZ53+dkwN
	8O+Lx+W3tM2CMy8FqMQfBmR5Y/ck0afDIWiYGzfnp3ApBJE7jkwYkOkg4hLUTSY3qv2Ptu
	9ocGg4LuTf/kdiGId9wVwMbNFJqullM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DtVstI2T;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6A01339;
	Wed,  1 Jul 2026 01:49:26 -0700 (PDT)
Received: from [10.57.81.2] (unknown [10.57.81.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B30143F85F;
	Wed,  1 Jul 2026 01:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782895771; bh=uKjX69FEmz1w+EK9hRvmD936xbp9gVpWmS3vnjZ565I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DtVstI2TRlmEUurH4pBHky6MZtD1mgK2ngKEqVRi2venXIQw9HTyy+4XTDApXMkDh
	 Ayo/h3CzdRJ+SmlGkIQ0CuX3dsViWNTK7UPsyAxeYu+aeFttpyzTuvjUyjjEayIn+0
	 uC98ygLo4Q/14tR4NtmLvp3JnPwp6hpMeZy+SPlU=
Message-ID: <2572cfd5-70c0-41d6-819a-0b2f37e6289c@arm.com>
Date: Wed, 1 Jul 2026 10:49:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 5/5] selftests/mm: add missing pthread_create() return
 checks in pkey tests
To: Hongfu Li <lihongfu@kylinos.cn>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, keith.lucas@oracle.com, maddy@linux.ibm.com,
 usama.anjum@collabora.com, yury.khrustalev@arm.com, jhubbard@nvidia.com,
 joey.gouly@arm.com, zwisler@google.com, hongfu.li@linux.dev
References: <20260630073235.3802271-1-lihongfu@kylinos.cn>
 <20260630073235.3802271-6-lihongfu@kylinos.cn>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260630073235.3802271-6-lihongfu@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3yhnfq5ywoi76wohjiwk7tfzxudk7ebz
X-Rspam-User: 
X-Rspamd-Queue-Id: 129C8A0007
X-Rspamd-Server: rspam02
X-HE-Tag: 1782895771-417175
X-HE-Meta: U2FsdGVkX1/viukZcUrmYD5DKQ2CIXTPbv7fuFa+fY3WSd5TtjauvdK6InC3Zby/GxGl+Z3YMx/Y3R2ASTQsgqdCejBF1ePhajX46zE7ySaMwcS2Bzgq5uXB9AzkO5aSzrcFrE2Ox50gMn5K6cAoy0Ig7DLRzAu3ClCSyMqOHt8lEWsCCYnG/Fav+Q+heqM1k9nyXyXcRCHj2l7x5h2O9UJMq5lyKLa4vAyc5q8OsdLz9t+U8rzWW1YqlGqoqZ7jHS6jQD+FSm7xVYEP0FeKvAQyDtbLmFfkg3KRzKx1QDSCsCXVsLzyYK6cBCOJ4uxpikmJyfb7DCVZ39pc0iaftArN2k5EZJ57A9XlIR0/CWsPDETrZKw8RkHBePPWLioTkPii4eufrFAzFjFoh55W7YQaF2KZLGuTKExoiXHKdkwsvNOrrrRo9JtdluBBNza0rEBdI7l668c1i2jcFlhgMKRv4iZZevoMTwUq8FuDz2+X/+mB/fC0bzZRoUsfZsBbj9q3vhjyikzmPyob+aPJhFV2uHtUje1Ia8MFMj7MOXKb4epR7v55gfhN9E71OOgOrwWt/pdsKz5hPcLu3xf6xysAmR4xqRGHfIM1BYZjIT11xgmNbOsFeNOa0pB1SSL8k06WQO5mSvFUXMDyMTsWGngSJTp1WTIn2hF7tNFDPBJiNJTyUWJbAdEVJu7NCRRKQkBKDKZ17dWyXvOZon7/IzbDlAU3v8NglnCKtRueZ3dLmNN0l8zBJpYSNsJXDueppYaUeYvXvcAiDdzO9LJpAv2u6sKNMzZiJ63znQg+AcB02ar1lBASAXyq9mw41NgRtqK7JdvKkxL8zomDg6Dz8BeBVx3tESAnUIJVUWO+sI1dYG4WT949FddwztbXfBhly8hpC7GfUiY9lIkOk2rblagA5+KlcRSMIBnnYc7NAf/8lPTeayxbUx7juO2l67Wt/WIpGTPCacV/vHIYDcf
 BHzvFFRn
 VO1AblezSs8hFZRV9bXbPpc6DcB+d0/fHLfoQ82ZH0GIus39qD6p56WSWq/YoenpN+C60hE47xngriX86RD8qakMozmNIZ0ziRcMZcEnzgwtqpZjiZWz92/XP4otXjGXKeB8bKSaBiFzvusUzPsTBJMbxrAdqLaQNjx6sG66NblnJm/20QUJ3wEByzKCgt3mBOKeaRv3HjsDeKKJYmNoRxX30gJfxX6IqsXhCDDKaIiyVzaA//WZmjYye2Zf7xqXdvUZKVbEsrxaSFQDmUzOTIOcCS9Bb1oS8tFfmkxW0Wjd6ker7JGlurRTMZTjLKFLF/PfaQQgI9GfMG/nuK8akMx5PLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/06/2026 09:32, Hongfu Li wrote:
> Add missing pthread_create() return checks in pkey sighandler tests
> to avoid hanging in pthread_cond_wait() when thread creation fails.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

> ---
>  tools/testing/selftests/mm/pkey_sighandler_tests.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> index d185d3da26cf..f30c9965a561 100644
> --- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
> +++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> @@ -224,7 +224,8 @@ static void test_sigsegv_handler_with_pkey0_disabled(void)
>  	pthread_attr_init(&attr);
>  	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
>  
> -	pthread_create(&thr, &attr, thread_segv_with_pkey0_disabled, NULL);
> +	ret = pthread_create(&thr, &attr, thread_segv_with_pkey0_disabled, NULL);
> +	pkey_assert(ret == 0);
>  
>  	pthread_mutex_lock(&mutex);
>  	while (siginfo.si_signo == 0)
> @@ -263,7 +264,8 @@ static void test_sigsegv_handler_cannot_access_stack(void)
>  	pthread_attr_init(&attr);
>  	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
>  
> -	pthread_create(&thr, &attr, thread_segv_pkuerr_stack, NULL);
> +	ret = pthread_create(&thr, &attr, thread_segv_pkuerr_stack, NULL);
> +	pkey_assert(ret == 0);
>  
>  	pthread_mutex_lock(&mutex);
>  	while (siginfo.si_signo == 0)

