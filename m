Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AE0EE8B386
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 01:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBEA16B0089; Tue,  3 Feb 2026 20:36:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6C586B008A; Tue,  3 Feb 2026 20:36:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B780A6B0092; Tue,  3 Feb 2026 20:36:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A4BED6B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 20:36:28 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2009E14058D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:36:28 +0000 (UTC)
X-FDA: 84405059256.15.8398CA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 44A0316000B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:36:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UOZ9O05y;
	spf=pass (imf08.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770168986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hq2xbKhR9wr7hQnm1mSbFXPqOVqrlx/YQZbkdmaikj4=;
	b=pcFTYaJMeBilpMv7dTUuAcdBUp/hA04McEpPswfWjsC4xcsaXSReMeciIEWw7sYWtq84k+
	HZH0fnWUjpZG/d1HC1RmhuT2yKqTRTqS/X9OqRyPOli0lVX5xVO+SwSFaJxPLjXgIYqmaE
	fPqXpGmqgXsfIwzWQ7tXWqvcM1WiM/8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770168986; a=rsa-sha256;
	cv=none;
	b=XzngqwiQEv5P+jjm9nMDRQHsM70Tcb/WGTrV11g2RrxpBA/tD3f5DaGiq+HP4wONRixQCB
	iBbldTC0pr66FQk2agkaJMOhHpVLqfneLXZBhYvfjCF1bQAVBG2ZBTq6txbVeW6enxdUYq
	3xgJKou2hsJ1jaXK+fFz8VixuwbGnvY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UOZ9O05y;
	spf=pass (imf08.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1625141A7A;
	Wed,  4 Feb 2026 01:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE427C19422;
	Wed,  4 Feb 2026 01:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770168985;
	bh=3J1yG40l4xBx53q7czVEncWZi7wToG/HailPa7lrU/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UOZ9O05yRahAFd2bgWZYrBRJsnzpJuJfsbkWYAEtgU9gPknO0DYIpP9niURbRZ9eu
	 uh3AvXzm8h6Ap9ral2bT1IiwwWOGBRSCH1E1UM22TdYaHnpDa9IZpctqEdjAXY3ens
	 7v0jD3JJ8PrUddiQSxnEJt/R4WHVCKD+xBP5qkCfHOgixJw4DDnvM9cMt+73Vcmt2x
	 2tyiEqnLJbTMo6ZxMdGxPCXgc0BB2vltvFUr4310QBJJaGtLt5mazdjHbBl4ETKe5H
	 Z2HpZGNUGjObOR4D4uPMVf5aq1hKdSwKOBexOgmPR+ObI4xTbfeL4PnTE5ytjSfdWD
	 XAVxwJusoB0Dw==
Date: Tue, 3 Feb 2026 17:36:24 -0800
From: Kees Cook <kees@kernel.org>
To: Titouan Ameline de Cadeville <titouan.ameline@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/tests: exec: drop duplicate bprm_stack_limits test
 vectors
Message-ID: <202602031722.72C5EBFF15@keescook>
References: <20260203175950.43710-1-titouan.ameline@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260203175950.43710-1-titouan.ameline@gmail.com>
X-Rspamd-Queue-Id: 44A0316000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: eoigs19zrdni8w515c9hzx8okmwznjny
X-HE-Tag: 1770168986-235821
X-HE-Meta: U2FsdGVkX18j3LWd4oOKwEHUprmpVTgueGY8EFcrvjpc8jAFwcf/35m7cLlin4981FLHBgvPROSA08xu6J6AOE/VpVqpNvA7ks2qnHlIIc7lGKyYVGcL1m7IcB9WMBh64b0yQ9U4bUHU7Ery+DJtYbj/Iq4mOfI4f/YuvaOlT8NlfP8q5Gf7lScv6g7CPzONMocH+ZUMmATLCPD03fs4QPFFX0iL6DW2qNEjHWxPM/+mjKWhpKHEimaAdL/0gUUSJCMOXe8yJoyE/vjeMSI9ji2Pi0Qgl2b74gg3/Pf2FEtUy4Go4yeXvTzhm0MWUumN2afl5b1RZG9SkfDpzYmoiGoD2NvOyUItZkilWNrWK2cU5nizRSeoJ5d8A/NxQ1lwjOQIq43z2qS1qVOv1CxJoU2dpafZlRolkvjMMUo/g+/27Z8B9Y09HnKzZXsHtzNJkh4rO7u31JuLcZYc93zlrd4tz70ufrM8q3Jh3j/FpYw6rpv5X2SUosHR1XaeKhOzmSoCboJLOyeFVw1znLUtHP0j5n8GmnRDqDnwemsEx2iVaceNiWg7Xmc/MkK79rYEqsE0UIyyWb/TZAbjJ9vse0VnsGlYjSirBcjqhPDit2Vuhqbckw35rGFVjl7y8xO/UV5i6GCiAVTfd1vY25CMciodRQ9c8KuV/ep+dqYt1hPLroMFg7z/0Qp6RlESFX6pBoL1tNvC7V3E26bRqoVSdvQO6fNXaedcUnDxnzOvZbpx2cMSraM7JCsQq6qvsAUmvM5aIJ7ZzbxotCM0J2k7Bxqfr8Rih5NcQVn7JYwfYFFtVKpPfh9abzhP4/tnmR4c33CBlicklYNaXXQgOKJgcE3C3w32MGQykBEPrwLy8nclny2G+25hAAxQ5/jkl9MBqzWK8UyuaHzP2VLorPtnsh3tvTghi2Li6F6TUV59YTPNYSxBmnQHRYcmRppxf1fNS8fsM3vHVTyfKquWfzc
 g4pI+T/O
 gILdiS5x9hHXxIAxUwJ+cBD//fmkbNHhYB+9L2GqE1+P0R6vIpiKhKU7l6HqFvmgCqNfDe+L8+m72xotMth2SC0wW1nLpPxQrK9FgQwocRM0xBQOEp8mWWpPdbMratHXNqb0ihLQOpzpW/2LlCilWtluidv0eGYl2SZxOpcy6naoMk1M1VTU9/qpNEH1VcmYSNjE6OfzMCmD+Xs4t24Jf0IQtdjZ67ezGf9et5+z1Z0ljZCS/jkHvPyK1NkmZKoImW6E6ldQbEsjTroLJdKJCQ/KkPqtDjzfTcnd98OneUBBQeimFSi/qdcLMzW1MhwSwL43+vWVHwikDLODhHlopjHwP9lfnnGhB59BZrN57NqOd9ecR4xrEtx1Jpg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 06:59:50PM +0100, Titouan Ameline de Cadeville wrote:
> Remove duplicate entries from the bprm_stack_limits KUnit test vector
> table. The duplicates do not add coverage and only increase test size.

Hm, yes, these are pointless duplicates. It makes me think I typo'd
something here.

> Signed-off-by: Titouan Ameline de Cadeville <titouan.ameline@gmail.com>

Regardless:

Fixes: 60371f43e56b ("exec: Add KUnit test for bprm_stack_limits()")

> ---
>  fs/tests/exec_kunit.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/tests/exec_kunit.c b/fs/tests/exec_kunit.c
> index 7c77d039680b..f412d1a0f6bb 100644
> --- a/fs/tests/exec_kunit.c
> +++ b/fs/tests/exec_kunit.c
> @@ -87,9 +87,6 @@ static const struct bprm_stack_limits_result bprm_stack_limits_results[] = {
>  	    .argc = 0, .envc = ARG_MAX / sizeof(void *) - 1 },
>  	  .expected_argmin = ULONG_MAX - sizeof(void *) },
>  	/* Raising rlim_stack / 4 to _STK_LIM / 4 * 3 will see more space. */
> -	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * (_STK_LIM / 4 * 3),
> -	    .argc = 0, .envc = 0 },
> -	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
>  	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * (_STK_LIM / 4 * 3),
>  	    .argc = 0, .envc = 0 },
>  	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },

Looking at the surrounding tests and trying to jog my memory, I think I
meant to have differing envc values here, but that turned out not to be
useful: I wanted to test the impact of rlim_stack.rlim_cur, not
argc/envc here.

> @@ -103,9 +100,6 @@ static const struct bprm_stack_limits_result bprm_stack_limits_results[] = {
>  	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * _STK_LIM,
>  	    .argc = 0, .envc = 0 },
>  	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
> -	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * _STK_LIM,
> -	    .argc = 0, .envc = 0 },
> -	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },

Same here.

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook

