Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8EEC43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1E46B00AB; Wed,  1 Jul 2026 04:48:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962586B00AC; Wed,  1 Jul 2026 04:48:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82C0F6B00AD; Wed,  1 Jul 2026 04:48:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 565596B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:48:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB595A02B0
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:48:44 +0000 (UTC)
X-FDA: 84939582168.02.E853B8C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 090E740010
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:48:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UUZG11Jn;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782895723;
	b=t95G0PAdqI+Epo+gWPtLIaF9iGEhgwSrVGg+ROJ8KUkB3a4Xa9G6ZaDeIqTcF14YWsViMr
	7DYI6yIdH8Idk1wMC1OV+tEZVolwDHcxnx9boSgAg8oBwLVD12jAdvh8oHic9eFbLYlX1X
	OK95OAcHrfIplTqkaeARAoR7gdeCGe8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782895723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m++6PLUR99n1ZhHesDJiK905TYLQV22npBUiqVdVw0A=;
	b=xh5PfxhTWYZLIpxeDGs/KbnCF+uoZEwQr+BOkoD3fRsJn1EBIUM4AVuzhekCsZo25mAp/n
	SaTMSCcbCMwoKpjwx43+wwyXeh0o/eVx6wjIkZAkdwPBNG4zJyH19OLaj0aHAMpmivBKjl
	Id8QEmIP9vQ2SkKeMq5SC7wKUIArZhw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UUZG11Jn;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D85CC339;
	Wed,  1 Jul 2026 01:48:37 -0700 (PDT)
Received: from [10.57.81.2] (unknown [10.57.81.2])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4BFB33F85F;
	Wed,  1 Jul 2026 01:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782895722; bh=kcjNMO66XSIEF/iAXE3FuGZ0OWXnyv0A9h2AM7C8BEE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UUZG11JnwTN0Wq/TaeDeCOdanWmjFRo1FHUmiOvPnGzCk+0nqr8Z/amy7fAhaqqL+
	 d4At8zrzsJJVLefeSUS7SYskAqV4OfGmkrGQCuRfORjNwyXCAo9dLLmV4WObQlqK72
	 BRlH5jKPHPzyaY+bEpYq4Z0bl21om5m/VGnn3p5Y=
Message-ID: <8ad9d4ed-939b-4e93-bfb8-fcf1a19c00db@arm.com>
Date: Wed, 1 Jul 2026 10:48:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/5] selftests/mm: use pkey_assert on clone_raw failure
 in pkey test
To: Hongfu Li <lihongfu@kylinos.cn>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, keith.lucas@oracle.com, maddy@linux.ibm.com,
 usama.anjum@collabora.com, yury.khrustalev@arm.com, jhubbard@nvidia.com,
 joey.gouly@arm.com, zwisler@google.com, hongfu.li@linux.dev
References: <20260630073235.3802271-1-lihongfu@kylinos.cn>
 <20260630073235.3802271-4-lihongfu@kylinos.cn>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260630073235.3802271-4-lihongfu@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fbtizrotznxc6ctui38twxg9mrti558b
X-Rspamd-Queue-Id: 090E740010
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782895722-521428
X-HE-Meta: U2FsdGVkX1+tDOvzBaUbd31z8vI3Lgb3ZuYEElQSTxbC9AJjuYYpf7v+6heMXXJM2FesAPkuB2J7onyB8H6/I6m+lnzbs2LyaXAO5xksl5Y6vr7vKz0GxaTm7jeVQ8f2vwa43mtLNmt2kAVT2PsQFOEjGxwFg8r6dm1OLAiD3omz50SMGXjCjdSILDD4G+cMxxyuef98L4zGnrxtilSOqrwqoMH4ir1DB9HEjQMY6nd4CoJYtRvgqv4yv1t4TiYbXNrnQQiOdplX8lg4awl1HIhlVQRwXbJv+R6TEXtNTY+oZAs5uGBR8VUNvoTOsGegLtZc//uYGdbnLxf39jbDNZkupXErLKsgmgmaZI9dUgnpqrDoL1FULkE3Zqt5cmBjE/XDzQEHLJM0NBsBdVyw+nGEY+oLE3hXM1GGjFf/6cd9Mu6CoQ35IYRxJn9fUqZDjVIJJqP7EuufJN0tgUSmI75A1ZR/tYR8aoqPJNmEgZMR1HSefVgy7zHotIk34iLkJYK+Fzq04NE1GIopfiimZI68Kxeni52E/bMwr6FuOjmZirsY83jUBK/MgUEgrX+GJv1spuCjXdTZHtY0N1eYJgOnhs0KvkGIUqQ59/eXM3fUUpHdBdSziazRUtV4sZS6NaODIwlQcgMSOnYTsrkZK6La1dboVCz+rw+BTsV4Ok502a9VVd7MP5HAoLQqObOAiqgumlz9gUSnWKKNKVCVe6H3iJmsZkgeDxzNmDY9nKDs99riGa8IvXwz5+MhFgV5UGK0vH29QmJ/AqSPFtD+mzg23YP0yycfmfceM+f/whzdsknMYNJ5ll87ORtuF9acUF7iD/G9O6MZvbFsyj2WCwkNA7a9OfAdkF+JUF6u6ND7j+EPEuOrbvIvh568yKsyoe7xOko/WXM9buoxCcklUf0PAA0q5kmsHYDDpxpSNyr9rxHTmx9S1uewADTkKpePDXySPAoB0rmexUTZlCx
 DITUUZQX
 uKSfu9bf1e3mlQAoy+Grmd5j2soSrEyK2+J/GBXZlSODTqtA0ykiBn3EfL4BwuiJ6zzEXo01RrqpCRbcUTL6iCzvwVWr/xBSHEmchybhglEoOHUmFEnGvmIYt3KKGRgRTPoq2hUNE8lWhIdLkb7Bo7R3iLpNVyFEIEjbOQ2XJGm1k3ceYU2f0WccMn2Z27jUpD7ouXhDDkt0OG4dv30ca7h54bGP1KR5Zc6bZB73K5gGlXNbkb9vI/beNovJhz0H9KLobDIxN2jBTaXgLW7v/fI+T+e6gVSqZv068sWANIOh6DOo9VHfxpJjKfd905lQuKVafT23vyT3EPZ1/SuqMEgb4LQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/06/2026 09:32, Hongfu Li wrote:
> Use pkey_assert(0) instead of perror("clone") when clone_raw() fails.
> The old path only printed an error and continued; the test now exits
> via pkey_assert() on failure so it does not hang or proceed with an
> invalid child.
>
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

> ---
>  tools/testing/selftests/mm/pkey_sighandler_tests.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> index 085e771227fb..882928f2912b 100644
> --- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
> +++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> @@ -333,7 +333,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
>  
>  	if (ret < 0) {
>  		errno = -ret;
> -		perror("clone");
> +		pkey_assert(0);
>  	} else if (ret == 0) {
>  		thread_segv_maperr_ptr(&sigstack);
>  		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
> @@ -506,7 +506,7 @@ static void test_pkru_sigreturn(void)
>  
>  	if (ret < 0) {
>  		errno = -ret;
> -		perror("clone");
> +		pkey_assert(0);
>  	}  else if (ret == 0) {
>  		thread_sigusr2_self(&sigstack);
>  		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);

