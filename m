Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4217BEB3633
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA5826B011F; Mon,  2 Mar 2026 15:43:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59146B0121; Mon,  2 Mar 2026 15:43:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952436B0122; Mon,  2 Mar 2026 15:43:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 832976B011F
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:43:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B3D013A7C2
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:43:09 +0000 (UTC)
X-FDA: 84502297698.01.51041F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6418840003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:43:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UCZ68iJ+;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772484187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5O+B/fWwUJz942RtHPPLBWi6fJdEQvC2BOIRnOAKTf0=;
	b=5FLaKdz0KLT1zEyFd/JqzfdzZfkvAZfc8h2NZTHG8eZASEJJiTGFGy1p9si8XZUkyMOUxL
	30ZNLKhwR2qGVmYgROfspyz8GNnfTENAqQO3HQH9s3emvC2Mi2YiuRbSWnxSX6gkHwUmMR
	QpdSS52OOyBgiBMO0Ch7CupLoNJ6hfg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772484187; a=rsa-sha256;
	cv=none;
	b=QadKXtpSp1MBKSoxw4BO3Agga0OBvx1UMqtWjiNlxegG/4AW8T5Ny6JuLIqD1pBErGA3nE
	0NGya7ei9OXf2dkyw/iTBOp4Z0IqmZTAKhXwUT3yJ6w6Cb/+G+CcrZc7V719P/jMRYRUjS
	mOv4I+y7FEDKzqSH/FU1H2Iuj0yyurw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UCZ68iJ+;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C7F9C6014C;
	Mon,  2 Mar 2026 20:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A328C2BC87;
	Mon,  2 Mar 2026 20:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772484186;
	bh=8jcRbTjIYYoEeo6c1jQlp3VJwq3xRQpJ9kuc5+hcUTQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UCZ68iJ+2TwxqdabJNKHBbq8jGZ/2EJdLAUuAH3h7VBEgYxI/n7kXeNv3eVD1Zz3P
	 yvI8PZGs8KBq2Wakr6Q1C8l0bLhK848YNlHcAPZAInPOQjTPJqDdbNYT+xzk4K9krV
	 aVLTx76+vTC1aHSADmIXR3n1vTndOO3XdMl4V6Nw=
Date: Mon, 2 Mar 2026 12:43:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Suchkov <aleks.koyf@gmail.com>
Cc: dywoq.contact@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>, Joshua Hahn
 <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH] [PATCH v2] mm: initialize 'seq' in gup_fast to remove
 -Wmaybe-uninitialized warning
Message-Id: <20260302124305.6bb7f34228bfe07094de51ca@linux-foundation.org>
In-Reply-To: <20260302193405.37961-1-dywoq.contact@gmail.com>
References: <20260302191237.34375-1-dywoq.contact@gmail.com>
	<20260302193405.37961-1-dywoq.contact@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yajawnsb9ncuxrs8uifzrfus9krddzdj
X-Rspam-User: 
X-Rspamd-Queue-Id: 6418840003
X-Rspamd-Server: rspam12
X-HE-Tag: 1772484187-775235
X-HE-Meta: U2FsdGVkX1/c69wxbfCwsEB0LhjaOEZqy9fFHUXRUJBVWTKhSAxIezLoqy79qK+2pdhnGeweCx0w043GtjYigxZqCOXBSEXIe1es627PHq4IZHi+kRlBF6mawIvBX2u/GLV+Z9uALL8VD4wl6e7TAByhwg/KSB+wC7iWFaWe0BofW0xlXYb1kT09PjM+VIa8JDBZCkYuXCBMz2JXbgu1kkitJsofoYhImrOhgDrS9X1j0GGJD7qh7H0MP5nOU0Cd5JWLqOVwUckdzLsZOfRpLGM4v78jRmomvdUPq2XW0m0qsvCH3SGQS6EY2C1hwGBlHHx3SA9uJYGEZhi5KaCS7PQ03FcLyKVIDZx3Mwx5L83ezFXEvwn9cZhGjQnwkzzwJFgfBwt5ioPDfvt+Wy3/E1Wi77rXiXgw62fdVVbUv2FxzLWmTdiGhyDa4yTuqVKSZs8D3VRxzBeP10pKDWVJfOQwqeyAPwvnv9+0I89j8RZ+SHCDBKmI3086s46ITfjThD3i3jdqf0Eflg2IASeodQ/e1pHncF8OIFzrkgr61WGVqLx3emueX6lEwaplunv5E2h+A9THuq/H78SdrlY+74UP7yV3rGqgfSqkpR/POhctw+IWaSWsstKEGrCNaUzLOhAB6lYjrpaSDDZxIM752KzrH8IHoy5gy+lCPd0nARSR7sYwHeBMDDntiywUyDc/QpHdb9Fc1yGoJnMbSv3eZTYz+cuE6we0GBjk71KV0vgVpqktvdWHeX9bZUwIu0CrotIRqL+kMDtumDTimDbcrQz6T8loDxYTlwGh8rZC1Cf+I1imCEqyKyrQ+q6+pqt6XTOZVCxUNY8m0IYVTft3XUq1vlz1kp1a6I3r9HTIHAYDc+7+XOIw69CQr8BWPO6vnO1zuZsocjts+PGhYqsAj5i2T+QncVaOT7cfhicu2CWQ4rHbaUAEeUZ/yD9ImsPrYNI2L2OSZq2ZE2ZEsxL
 fQ/E7zkS
 GPIt9rp1ugqx+rcG/VDipoXZ6tYtgRFlI/i03+j5S5UUvap7whpip+VYFgF0cv33xMAGy72d/pNTwT/DmRG3ghddjt46quy8vhjgDg1bfk78yf9FNwB9RN0o6NdO/KQHw1BFfda34Ht+UNlG4GNppQFEt7AlU+6wfakZ93sORkWFev/egJsBh+K4EV7elI42s27AWWxPWX8NsovjGXdsX/331xXrYDh24mpYRdbvwT9OadjsyzXKW9lqXEb/JJfkhwWw7owsXjyh7Lo5yPWNCMMqQAM6imJl4OCu/2dDcXp2CfnhaPCJ2NCtQkT0Sld8yf+htdMab31JHuJOXXs4tT1sHZjePM5rXw4pxwASZC2LDMZCvhTYQb/MZm5+JaaIIJdwsp9QNMLqDBnpW7X/vPgMV8JM8baRJcAZx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  2 Mar 2026 22:34:05 +0300 Alexey Suchkov <aleks.koyf@gmail.com> wrote:

> The local variable 'seq' in gup_fast (mm/gup.c) was declared
> without initialization, which can trigger:
> 
> mm/gup.c:3165:20: warning: ‘seq’ may be used uninitialized [-Wmaybe-uninitialized]
> 
> Initialize 'seq' to 0. This does not change behavior, since
> read_seqcount_retry() always writes to it before use.
> 
> ...
>
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -3131,7 +3131,7 @@ static unsigned long gup_fast(unsigned long start, unsigned long end,
>  {
>  	unsigned long flags;
>  	int nr_pinned = 0;
> -	unsigned seq;
> +	unsigned int seq = 0;
>  
>  	if (!IS_ENABLED(CONFIG_HAVE_GUP_FAST) ||
>  	    !gup_fast_permitted(start, end))

stupid gcc.  I liked uninitalized_var(), particularly for its
self-documenting nature.  Never agreed with Linus's hate on it.

Thanks, I tweaked the changelog a bit:

: The local variable 'seq' in gup_fast (mm/gup.c) was declared
: without initialization, which with gcc-15.2.1 can trigger:
: 
: mm/gup.c:3165:20: warning: `seq' may be used uninitialized [-Wmaybe-uninitialized]
: 
: Work around this by initializing 'seq' to 0.  This does not change
: behavior, since read_seqcount_retry() always writes to it before use.

