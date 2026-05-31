Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CFA7CD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 14:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527B96B014A; Sun, 31 May 2026 10:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8A96B014C; Sun, 31 May 2026 10:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EEC76B014D; Sun, 31 May 2026 10:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32ACB6B014A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 10:36:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7FF51A0423
	for <linux-mm@kvack.org>; Sun, 31 May 2026 14:36:35 +0000 (UTC)
X-FDA: 84827965950.26.0125B0B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1737FA000D
	for <linux-mm@kvack.org>; Sun, 31 May 2026 14:36:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fuc7Iyfi;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780238194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPApO5PSuZbWVoDOqItwGMqueNSdbpN7A+B7zA27RpY=;
	b=lHdoxLTR9alkXLr8sM8zymEsKARZXYUJdVTUengxgAkFY4dxr1g+CMDhHYDElTxHMnr8Q6
	KvbU5gGgA6dU1ajWz/z5Sm6p9HGnFC1t/1Af3/mbc16JPD5iKZT85eyHIXTXJPoSc4vpDa
	2PvN58D/32lpQ6U/szPWgKgaJYoBErs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fuc7Iyfi;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780238194; a=rsa-sha256;
	cv=none;
	b=S97Mf84Xogm03QkSS7GGsMPslVYHtMlVpWLFPFTsvvUAtq3SOaC5mhU0GFDmwscojBWRTo
	6cb4QtxFMM+b/POgs6kLTxWcJxMjMyq0lfqiKJRrDbOP1PzjuSXqeypGIGSbYk1SSdcDgR
	/9lxxXutCAo4vv5mEBa2EqixinZjtYA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 667DF601DE;
	Sun, 31 May 2026 14:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2BF1F00893;
	Sun, 31 May 2026 14:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780238193;
	bh=hPApO5PSuZbWVoDOqItwGMqueNSdbpN7A+B7zA27RpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fuc7IyfiSOek8PfZse6emleEPNfYRfDKOl6mqmyBG7s52mjxGzJCaL4Cp51ims6Os
	 fzxHGYqSXFviP0rozHD+x7NoYjraRc5m3aqfgoZ6L4oVeck/Id3F/uYQSbjHhxsyMK
	 ULGzD3DEdO7komuxKYNaOvzVNkFYN/iuKBynX9/OvL4SbzYssdRsHQT9kZXzrIDqvL
	 wzbcU4VgELLaq8rqTON0KU+e2SX+L7zB9dwvEE++yRoH/CVCiX0cAC+Na+1BZVZdKv
	 XxieYMD1F9QSIVcoMfOYcFKgzchdfty8MLM8t6yZwP+gxF94FnGBuZ+J3WCcIPVPnS
	 +nZpLF27aorVg==
Date: Sun, 31 May 2026 17:36:25 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] selftests/mm: use pkey_assert on clone_raw
 failure in pkey test
Message-ID: <ahxHaQFr3Uer2GBP@kernel.org>
References: <20260529071633.2807814-1-lihongfu@kylinos.cn>
 <20260529071633.2807814-4-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529071633.2807814-4-lihongfu@kylinos.cn>
X-Stat-Signature: iizujnqk1w4p5kqqtb3anbqegetwdgu4
X-Rspamd-Queue-Id: 1737FA000D
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780238193-76726
X-HE-Meta: U2FsdGVkX1+zwM4DLKIqTQYJLaRQOhcs/aKKxBqzb3zRnmA20ay2uW3KEQe9ecU7gJKyfqVgutHkZmkiBIcwYi/sJeWNzGRTiyZx/6YFs6o9TWdUENFE/fInDfY3xil0IM4UOilVfQp27bGzm2+GMH0G6yRZ3Me2DrmcAid9DGT+A0AOZ228TwTS+jR4SeKOztJjkUBRp2QytizqW6YVj7o7Mbrmo68YNtGhSiCr3AcJMapuAm42ixTDhUYhrD9FuRNad32a+c6vQeq9BkdAe5zgJYTTgva6lBEcDjxarIM41PsYfootMC8PMD2t0jli9utVHQuE1s9ma81hYPFbLtTKOwbLb+s+a6pYDHuLkJcXDPoLN+thJy8nEdcTnNlRX1bUDeP5K/q9GJbWWh5tGNTHlz71xp5LR0jjRn+lL0EEYDtmxOPFX8h0nCV+8UUGcW9TJ/3CUZjnSfna28Du7tl8WMNzjk19vP4HwU0qKsWg87oAFqbqhvb2+LrZ+RREgKjRHT/Gd4+gqExZg6KXSEFmVjn/lE0G4gVkEhBtB3q4Jlp10EkPdopowAsn9Nx/CI1h/rf/HC6/c7kS9p5rXzuGL42mCvZa38rJRGkOwb94kDwMXVA7REV9jQCT06wUUn+y34+3CHIhQL8nXGo7MIjvPLVbCIKx0S1KEOxQW2A+gAwBpYO45yT7iE7plrKMrK2AVNO68lDcYFjO+OXJwuq0zXovPQGY8xTrLf91/yTPNPZXdVx2OG+slYDX6elcxsZozh6jFrOQY9e/EXHHUzICapbACyN/Qk4cFcu5+RhSSw+ay7yNXRRLug6FwhPT2KDQWhBv8WGlinQu2MSL7NdT1cAvo9qY7swIVwBbZT/z5eWOM14KRMgfCeoPBH4T0BdfATPRmK+y19sUNgdfY3obuIvR/EgumeKYC5KTX2PbOBf1VJTflvLM3a0J+c4JpDRIqdnoA1TWlQUcO1O
 RmyUUzKZ
 /8/sIxvGMGGNDb4cEVrbPfW/5MfKOWBPfCUj0nVdGwct+Z+VUy8RXscuyealkp/5GL34uQmn5IlxhouYF0jWLZCfi+FvEv+yYHw51zoVtjAuqjCQzdeOabykOfoFO7SDxE7Dr/z1TQvUR2V3b6ZZ9VeI7lXOYZ8x3WnEHeoHa/uKFUXxDKmxPwYM8n+ajpRrf8WD0f3Xp3MadVKw5jPmqCX6THqanwSHhgXAHuYcuys46qBvgsoCepR2ZQ00kj9+xxSqAwUXFwN80lIxYf6ile6wRF65VHaCtMuMO24gcC1F4V/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Fri, May 29, 2026 at 03:16:32PM +0800, Hongfu Li wrote:
> Use pkey_assert(0) instead of perror("clone") when clone_raw() fails.
> The old path only printed an error and continued; the test now exits
> via pkey_assert() on failure so it does not hang or proceed with an
> invalid child.

Looks like clone() invocation changes in patch 2 belong here.
But is there actually a need to change ret = clone_raw() to
child_pid = clone_raw()?
 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
>  tools/testing/selftests/mm/pkey_sighandler_tests.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> index 80b5b3dad86f..231dfb079075 100644
> --- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
> +++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> @@ -333,7 +333,7 @@ static void test_sigsegv_handler_with_different_pkey_for_stack(void)
>  
>  	if (child_pid < 0) {
>  		errno = -child_pid;
> -		perror("clone");
> +		pkey_assert(0);
>  	} else if (child_pid == 0) {
>  		thread_segv_maperr_ptr(&sigstack);
>  		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
> @@ -500,7 +500,7 @@ static void test_pkru_sigreturn(void)
>  
>  	if (child_pid < 0) {
>  		errno = -child_pid;
> -		perror("clone");
> +		pkey_assert(0);
>  	} else if (child_pid == 0) {
>  		thread_sigusr2_self(&sigstack);
>  		syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

