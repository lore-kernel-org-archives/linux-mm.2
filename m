Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9706C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 08:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDA5B6B009D; Thu, 20 Aug 2026 04:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB1D96B009F; Thu, 20 Aug 2026 04:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEE8C6B00A0; Thu, 20 Aug 2026 04:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0DE6B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 04:41:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 157F0406A6
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:04 +0000 (UTC)
X-FDA: 85121002848.26.5CC25EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6E9C9C0003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 08:41:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SqXc3BNJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787215262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TH8icUmIsFqcx2XyjrrIGOwMDuLcmtY+UH0kZbaRyrM=;
	b=mAWi4fMRYYLPx0vQQLEh+kWEQu3ows0q19CBFQlu/ze93KlTNnclroqfsy0jh8lBWXPWPY
	7piN+4GuWTmgPzvnVflb8k5JjNdgWBBBjt3dgG0haTHiAwqlayBMvX0whi5GJWFyWwkb5c
	HG5ZqVg+COMssvhxMZNo+FtBJPhrjaE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SqXc3BNJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787215262;
	b=g5p9l6dvjhopB7HQnXWiY6NEOfYdaPHJv4ePsLxoHcXIl9ebvnjutvr1CoksQH/U7Cu8YY
	XZQ3H/jGHK+r8AUerLFcy6lQaML8Asz62GHkre87kixX/h2yKabvwpYxuHJMGCWKHb9cRL
	egZhSuvlptH/keIDhcMJtVIu34R2ATo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0149D60AA9;
	Thu, 20 Aug 2026 08:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECDB1F00A3D;
	Thu, 20 Aug 2026 08:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787215261;
	bh=TH8icUmIsFqcx2XyjrrIGOwMDuLcmtY+UH0kZbaRyrM=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=SqXc3BNJnZsXg3qq6Qf8ToulTCVa9Es0x+UV/0KzHsCmHQlYf4ZfBACOUq5rYZ/LX
	 qNNWRDm4eC2uvdlqfzr0DDVu6FG6cKx2yTbrIxjvZ1zSBlTsrW8r1BzX9N+5O1jeif
	 Bld8ATzn9dRJ6mdNhxsmUIA8tTHRp3M33rXKxIt9KZV6GYTWQ+LkeV5f6yOGxYnIdL
	 MGafhU4SNKwZdgVwR6qb0GsycixlKNUP2wnK9EVDcY62mzfqhTXvJwEXp9nR63oysA
	 FnTrDFXeYila7L4Rthwj+Mf0owS/1uIUdlCOQ5YtWOvxoBw3zpLo6bswTT4COd9odB
	 sxRNNqN1mpSxA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 06/19] selftests/mm: stop khugepaged during the
 MADV_COLLAPSE cases
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
In-Reply-To: <20260815015901.1236937-7-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
 <20260815015901.1236937-7-kirill@shutemov.name>
Date: Thu, 20 Aug 2026 11:40:35 +0300
Message-Id: <178721523516.2799959.13966792702490563774.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: r3snaut3z6mis9iob7moiupn85t668sg
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6E9C9C0003
X-HE-Tag: 1787215262-564913
X-HE-Meta: U2FsdGVkX1+nfQRS5dQWZTaLfxNnADv3WanQFXnVRkPr7xWpT0IIrZOHSaJNkbLuLU9lXoHuRKvNYz5FEyeTL4dngUTZbPOK7vXaNapDi9OmPyc48/9IpTUD6zCmarewTwuum2keSNtZT4K8r5PysRTLtq7LqFg2HCw8jN+Uho8CeDsRRZphIgqo+T8tF8qge1r6pnADkXt84uaUpVFKWFHxcyTWB8vHqIGiCnx/KovS9j7O5xgUuzzZUYbh3YMdo7hBt9W3O7Wp6Fn8PEDRI5nXqnY7NHWEjp8lCUvanVocu/9wZ/ACKsNyb1RXSB2nRXEyvM+5Qvp91uNzHsv1TqHi51+EJtLIa5LB4KVqeFNBNY/VgT6aa8rOfHwK5ct6XXmA9hGggAukEg8oU6MB93yP0rgRI70xi+28x2Ghj4qf3LDHxYMPHntzh8G3Q3oanZY4LcoyUiehX6R/cmJ6nglfwDKLwHqQ2hzK3w7CurowWIcT4iTbZsr/JZovqhPJmyaiNR2JK/dgpZCAKakm6xN2O5iEcMjvzuo6ywcjARXUpQvYKWTpEaOJBSiFaYzaWB30bwCYMQ6yiTsatyESVzJTbzeVKKua4+t48mBcP5WcDOAXEPeL57Ov7V1uQ97OvKbck8CdQgAq7VBSTwozbixG/9VteEzQ79hy6AHko7O9baek+I0YRXWKpjwro4iaS9+tSQgvWV8zGlBuZ+P0jPRMbSd0BvHSzZg7MxjedkQSXsdhSWxLVElXrmrc7bJhs8JjC1PQPrkDqNuiomaNWVf4Q6x0LReh7XnC1JooHzuaxzlYLS4FYI/prwwVju20+h9kGFiCx5hCG+vRkS8CVxacV2L48hflFklleeimgqhcw5pJA3FUjCyzAlocUOeCfG8bIZgdqoI1bwZ1i2BqE0iPQMYoNVfBRB/txLTgLi5cLh8Q502j57xqKsidRTB+nTxpjRcINNMGXYcWnNz
 /NHJfwpj
 sEd+DaKTQYKU6dW+ZrphJ8tsy53CvZYBCphs70kUNGu1Loq+JLt/5jq2okyh7T2VzxVYLXVLdndSLmtCo+ZnbVmu4MO2meqS2K8hqEIoHdWj7eA4a91q3t6+FGKcrTqgnM9cpJTfxA65y0iJwqWSBCAUYoMCMLEJM0vNffV6yUvuG/TO1pilmv2BoNrGmH2du5wqA2DWfALMe6732PeKDwOpEPqZ5kHPVHd19EctMsIR8w9izFSJq8cmeX06Odym4G0z1l18hTjJWsq1/lZH/KJiNakenLJw9aVtt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> __madvise_collapse() turns THP off before each MADV_COLLAPSE, both to keep
> khugepaged out of the range and to prove MADV_COLLAPSE ignores the setting.
> It clears the global controls only, which is no longer enough.  A per-order
> control overrides them, and -s leaves the source order at "always", so

Nit: description of '-s' would be nice :)

> khugepaged collapses the very range the case is working on.  The case then
> fails on a collapse that was interfered with rather than refused.
> 
> Clear the per-order controls too.  Set them to "inherit", not "never".
> khugepaged honours the global never and stays out.  A forced shmem collapse
> takes the order it builds from these very controls, and still finds one.
> 
> Fixes: 9f0704eae8a4 ("selftests/mm/khugepaged: enlighten for multi-size THP")
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index a3d14cc1a2bf..5aa92de93ec1 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -572,8 +572,8 @@ static bool is_anon(struct mem_ops *ops)
>  static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>  			       struct mem_ops *ops, bool expect)
>  {
> -	int ret;
>  	struct thp_settings settings = *thp_current_settings();
> +	int ret, i;
>  
>  	ksft_print_msg("%s...", msg);
>  
> @@ -586,9 +586,20 @@ static void __madvise_collapse(const char *msg, char *p, int nr_hpages,
>  	/*
>  	 * Prevent khugepaged interference and tests that MADV_COLLAPSE
>  	 * ignores /sys/kernel/mm/transparent_hugepage/enabled
> +	 *
> +	 * The per-order controls have to go too, not just the global one: a
> +	 * source order left at "always" -- which -s does -- lets khugepaged
> +	 * collapse the very range the case is working on.  Set them to
> +	 * "inherit", not "never".  khugepaged honours the global never and
> +	 * stays out.  A forced shmem collapse takes the order it builds from
> +	 * these very controls, and still finds one.

From my experience LLMs tend to add lengthy comments that describe their
actions in the moment. Adding to the prompt an instruction to make
comments more concise and in the global context usually helps :)

-- 
Sincerely yours,
Mike.


