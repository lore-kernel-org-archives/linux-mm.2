Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C55D3CD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 14:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC1AA6B0149; Sun, 31 May 2026 10:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72E06B014A; Sun, 31 May 2026 10:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88856B014B; Sun, 31 May 2026 10:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A9FB06B0149
	for <linux-mm@kvack.org>; Sun, 31 May 2026 10:31:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5DC9B12048C
	for <linux-mm@kvack.org>; Sun, 31 May 2026 14:31:53 +0000 (UTC)
X-FDA: 84827954106.23.A3EEFAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C98E38000B
	for <linux-mm@kvack.org>; Sun, 31 May 2026 14:31:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=itLeleWj;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780237911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VH65tbFn/cmtsF072HRQao+gX1EFVbFjdBx5iGwdBNw=;
	b=BUuVwsQxC7NW+brxEBUFtNsz172epJEQGWfD1EfRWwZQGoEbm8bspCQcpwk5NFMXTpgNF0
	HK0r2thXgxTbEe5+F/qWQxHD1fUio/0igEKJ34IRO3e1Ll3/P8BUXZS9ljfvp4wofr5lQh
	E6lou+Gk3Nev8DUzERI2idS98zp4sWs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=itLeleWj;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780237911; a=rsa-sha256;
	cv=none;
	b=U2AfcjCbhXhQ68xCelaUFS8KzHnd1Ohtz9QGzGc2uyJYrk9tcMZPtRIOHWjACC0YCSI6O7
	hivnLv/TmV72aYu8B5SG/I7VqosQ8lUJNr5NvhpxnXh1qz9tcfYoq8yKrIPNW1BMam5ixE
	BwlJ4pLkrhGk7j0bm34S3BjHnIxtoWI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 45DFB601FD;
	Sun, 31 May 2026 14:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D121F00893;
	Sun, 31 May 2026 14:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780237911;
	bh=VH65tbFn/cmtsF072HRQao+gX1EFVbFjdBx5iGwdBNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=itLeleWjfiVH9EbXtx0ATIlQrtbycOnld+xJp/WELYVcoAHooVNGfTto8GAJaMjZZ
	 3UrhZkBgMWD82y+1XsAllxPLHNz2Mimt9K8EZywOoju3sWVJ56mGJZ/+qRR683BsEG
	 XDesXW6/ZW9359/Tdibb2CAu+uFpzjkmAcZdc7Z5+WHzocVB1J6GiDavTksfvjeXWK
	 2rLzur0pScv0nxJr2vIMG/Y8f34uMcDkQaGSG9TZhIBUEiJxDFJAFXalRxnN9DWvmV
	 H4EJ4asejInO5H9bijLUTmlaXddp+AAwfSH6lNZhuIihAX+gSZzav9JZidYYhV46rB
	 r7eS8oAtgg75g==
Date: Sun, 31 May 2026 17:31:43 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/4] selftests/mm: unify pkey sighandler selftest
 assertions and tracing
Message-ID: <ahxGT9Q4JjhHBK0z@kernel.org>
References: <20260529071633.2807814-1-lihongfu@kylinos.cn>
 <20260529071633.2807814-3-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529071633.2807814-3-lihongfu@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C98E38000B
X-Stat-Signature: efh71ixyc4bspyiysg478tceci4k4n1t
X-HE-Tag: 1780237911-834253
X-HE-Meta: U2FsdGVkX19FZZiUQh8IlgDDHlkPg3iN+/0LrLDC6VT+X8hUBL7kDGsZJkGNulF0BGkmn7NH3pewlLEacPfVwKca1hBG5ci/ja1PJbO7CDSWpZaazYQzIIv3w40uyjPGyE9n3myo7dnxE8lQ/julLSEfZjHIPEqO66g4BOYkRGPNw4+60cjEXeIsQ3bcsJbflFx5hToyWpJVwnm0cPmFK9M+9KmWvHy8nZNjitZGfdCqSx9fIwGTVrtRXAKYng8csqgYodPsGtSPYrQsWsLSYeF6ndgWbz2zTFWdT5eEeY1xgRXspXSjrjgyMEYLJm2VhGrZYt9DnvSHn0hm3Itib0J/U1cwicEspojw0duVkdu3Xu4a4SUfGW5k4neqx0OAzs6Fm/51WvrSfq1Ngo6uimkHuCEp78nOOxHdfmzRcjlrtOcnal+D9lVy/TCHMK/TFi01b6vLjDlX0tkDXkCKUzfGiPeLcx5JSX82u+7I1lRkvqrYxguFYTZC3HFUsPdmpm8MInmDxQI3C789cwQdu14QkPlFdK/cwH2mFCees76Anrc4khfoV5al4g54qj443E5TszTzV9v1R3GkTsCIg1vihvQ44vkOuu85wFWFESKamjTdDMMvQAoQ0aTKqsLtFeuNM5GnG9XtUPj2Xnmjg0QORS7pRe/ZCsjvBKPgv341St3IylM6xaB0DOcb1cgMD7Tdxg3L+8fXmxNfpUdvb6IuKG0tB1CSXHJT1LuTeLLG4UiVa0+6g/zuJvflFrB7m3jL3YVEG4kTYbiySuVauKaILraSWYb0eN/bI36c1/1Sp49f4C+4Aspwnm907sArsa12iVeAMEzG78Gsm7pVR2hbBTVa5zrz1huXSYiajLOUhpMyE2R9thwnXaMqUPpESPXITcmY01cBABfFfvzdi8nXffGQtvOzctssi5+ye9TDnt4eC9gAik8R8PYxQxkKtwamPx+Y4Ci5Ve4Ri3W
 waqrJYS3
 DZ0GdRCj0cVtQmHQiy1l2cWalcuuDTw39v8rUjg569ZcoRmGmcsisJChhm0IVRHddp+5b3IlqjAsnDl2eMbMJaBV4+WVT+Ej2HDHI+vbi+Zj4bZNGeqQJaZfS+8noe9vCRpzRdxo4l+lCl+ePxURHBI5kIoLaiSUDJjXCzDdHucnkAo4wMsCnAV02ML9AbsC/0G8/9PVAxMLym8LoYg9wZZMlBMKWeUfxei3OiWnZHrUw4OM09j5IWre4MTWspmoACee+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Fri, May 29, 2026 at 03:16:31PM +0800, Hongfu Li wrote:
> Add per-test tracing to the pkey signal-handler selftest and use
> pkey_assert() for error handling. Each test enables tracing at start
> and disables it at end; on failure, pkey_assert() calls abort_hooks()
> to turn tracing off so ftrace is not left enabled.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
>  .../selftests/mm/pkey_sighandler_tests.c      | 104 +++++++++---------
>  1 file changed, 50 insertions(+), 54 deletions(-)
>
> @@ -323,18 +323,18 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
>  	memset(&siginfo, 0, sizeof(siginfo));
>  
>  	/* Use clone to avoid newer glibcs using rseq on new threads */
> -	long ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
> -			     CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
> -			     CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
> -			     CLONE_DETACHED,
> -			     stack + STACK_SIZE,
> -			     &parent_pid,
> -			     &child_pid);
> -
> -	if (ret < 0) {
> -		errno = -ret;
> +	child_pid = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
> +			      CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
> +			      CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
> +			      CLONE_DETACHED,
> +			      stack + STACK_SIZE,
> +			      &parent_pid,
> +			      &child_pid);
> +
> +	if (child_pid < 0) {
> +		errno = -child_pid;

This change does not seem related at all to the patch.

>  		perror("clone");
> -	} else if (ret == 0) {
> +	} else if (child_pid == 0) {
>  		thread_segv_maperr_ptr(&sigstack);
>  		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
>  	}
>
> @@ -494,23 +490,22 @@ static void test_pkru_sigreturn(void)
>  	sigstack.ss_size = STACK_SIZE;
>  
>  	/* Use clone to avoid newer glibcs using rseq on new threads */
> -	long ret = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
> -			     CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
> -			     CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
> -			     CLONE_DETACHED,
> -			     stack + STACK_SIZE,
> -			     &parent_pid,
> -			     &child_pid);
> -
> -	if (ret < 0) {
> -		errno = -ret;
> +	child_pid = clone_raw(CLONE_VM | CLONE_FS | CLONE_FILES |
> +			      CLONE_SIGHAND | CLONE_THREAD | CLONE_SYSVSEM |
> +			      CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID |
> +			      CLONE_DETACHED,
> +			      stack + STACK_SIZE,
> +			      &parent_pid,
> +			      &child_pid);
> +
> +	if (child_pid < 0) {
> +		errno = -child_pid;

Ditto.

>  		perror("clone");
> -	}  else if (ret == 0) {
> +	} else if (child_pid == 0) {
>  		thread_sigusr2_self(&sigstack);
>  		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
>  	}
>  
> -	child_pid =  ret;
>  	/* Check that thread exited */
>  	do {
>  		sched_yield();

-- 
Sincerely yours,
Mike.

