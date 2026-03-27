Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DC6510AB83C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 01:17:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3E16B009B; Thu, 26 Mar 2026 21:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA43C6B009D; Thu, 26 Mar 2026 21:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE11F6B009E; Thu, 26 Mar 2026 21:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB8C46B009B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:17:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3282413C3F9
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:17:52 +0000 (UTC)
X-FDA: 84590081184.18.C22E053
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8C44100004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:17:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N8wbJjBq;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774574270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rkML6vmdI984fNm1g689Le+gzbrSU6f48wG8kugUHuQ=;
	b=KeYcgq2iVZFnQdBgKgoj50h4AL+2Q1UvuhD24Nnqfz5WOqjgWpCFXSNsSlR0KjaOUklQja
	cAslUN3lJGhPP4oKtppYzHm44tZIFbI0tnQ4/1M4gmx+HPZwTvpzOCjiR+M75Ni0ZAfcGP
	EFBoMweO/sM27f8Ao3bGbkduoozDcJA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774574270; a=rsa-sha256;
	cv=none;
	b=RhdWWAgGrKHCZBVtmnpIMqmY+cvYl6lnClDEt+Bnd2Ujjfp0JiI9y2v5e1hoO870J+lVPM
	NmGGuEdxSnIejOt7ENXEu3WQc9QkKu24zKBOFz2GmKSzhDQ94xlN6xsIQhXaKotC1tRHwy
	zYjCfUOQza6CUr50HeF9AgbKj7UvTUA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N8wbJjBq;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A12A240E45;
	Fri, 27 Mar 2026 01:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622C3C116C6;
	Fri, 27 Mar 2026 01:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774574269;
	bh=Fj+wzq/6iKYICFkTGU/r8tL7mIACYw3BRf1GTOTNh94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N8wbJjBqfUz1iZ2pyro304QYGXMLlo329AaeIw2pH/rYmSXhksT98yYQxIsqmd/md
	 hSCuS1AclGoRsOQIWSn67Xp/JXgSdsXyMQ8WQkQATgKC9sb5DNhFEYcpcM5z0K48Dh
	 YUXQ57CH0WqKbdty5tYJDAn0+5Oq8vf6mtQ7au+iYM9i3g/+SjN48XvPjzmJTSymbj
	 cnFWpHCq4IWFJqPPquXDsSRd/F3uhzxqfXO87YO7nYFZK3VaYvrYApCH1zlAtfIAvI
	 9tEY3RuglpzUiojnhamHfDdVxRImwkuhqWcaMWYVF3m4QNFvKD9sG9bzVNKdFnTVaI
	 orhB8UPMLOUbg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH] mm/damon/sysfs: dealloc repeat_call_control if damon_call() fails
Date: Thu, 26 Mar 2026 18:17:47 -0700
Message-ID: <20260327011747.66127-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327003224.55752-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A8C44100004
X-Stat-Signature: be5tzakudhu8kzkmofxd7e6scx7uepco
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774574270-793180
X-HE-Meta: U2FsdGVkX19xSEH/PxxvlZksKsRwDZMAiMGop6rFoILKswO1jt3kwYQeEUkZMQj+DDnryk0Xvz+ArywxMPOnVSZEIeQ0hORVjZMrTS9STk35cYu/QCP7XtJ4GaHym37KZYjefEyXsMAGfNqYtOVfWX3P3vh5kXDPBsCNlgVCFNwQY0QhGxJnp8zwWYFRDH8CQeEdjE/pQvpY0XS/NXgI7JxLxAoz8sBlXjhbuObKGrmb9k3kx2vZ//fCmTITvaxYQ5bLrFpMIkrW8m9o/7ptycNZZjknMm2/6iMkpyDjDDWnYC+gssrmZ3KOLkU86/ok4hYSxfQasTgvRsdbtelUUzc9seqm1jT7iHqspCZruX8v0Ij/9VwlA6ypJX0GfebAPiIoieytLvyq8/RGCopMFZXmkOKupbqUePp9xYPHLVMTbLYdyA6JTl4jweqgEcfsH9VlRLaGutOpLYWCzd2J/G5WcsVFyJyofFWoMErr4GL+4RMLKkEVSmRehYmiJRrTP9EZYP2r6qa5clDGINsWYYDvtipB1PwjjQbPiacZZ5XPZMie1SeNJshnrZ6LvXP3fNVkY03dkSVibtBIXGBpaQwHkKfjdxWd1IQNkm6eHQTaze7jk3B/LI+ymtf1nD8IGJj3DSc5/71loV3I0O6/+yspzc3lHwG5haRa5Ll08OWFculqltZ0BCqIMqRYL1eCynOBCG7UMplkobq76eEcoh2tL5N1dLX1cj6X7jL3y4W+EY1hbUizJ4LdI9roJvJPNLsOyvoyChWCqWIaqBXILX1kacSGYH+Jzq9ryPyTb5XHHji6bUlNFovm81GNfxU3Xem3BayAALVQlSfAPOnWGUxyHddgbEFtGwJ5uuTm+l0eaF+ns2QAmEl8SkKtDBCv4osqmoT5RVXK2sClOuKZh7LXLlw29CmfKqASoq2QTtRRbMKnkQtdQk3/boaP6Lw9a2A1nwrG57el2/r90j1
 YhenPoqK
 9gfBe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260327003224.55752-1-sj@kernel.org
# start of sashiko.dev inline review
commit aba7f94d0accfda5ab9b573157f691de9e9acf00
Author: SeongJae Park <sj@kernel.org>

mm/damon/sysfs: dealloc repeat_call_control if damon_call() fails

This commit attempts to fix a memory leak where repeat_call_control is
not deallocated if damon_call() fails because the kdamond stopped before
the invocation. It adds a check to free repeat_call_control when
damon_call() returns an error.

Link: https://lore.kernel.org/20260320020630.962-1-sj@kernel.org

> diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
> index 6a44a2f3d8fc..eefa959aa30a 100644
> --- a/mm/damon/sysfs.c
> +++ b/mm/damon/sysfs.c
> @@ -1670,7 +1670,8 @@ static int damon_sysfs_turn_damon_on(struct damon_sysfs_kdamond *kdamond)
>  	repeat_call_control->data = kdamond;
>  	repeat_call_control->repeat = true;
>  	repeat_call_control->dealloc_on_cancel = true;
> -	damon_call(ctx, repeat_call_control);
> +	if (damon_call(ctx, repeat_call_control))
> +		kfree(repeat_call_control);

Does this fully resolve the leak of repeat_call_control?

If a sysfs writer thread calls damon_call() during kdamond shutdown,
after the worker thread in kdamond_fn() flushes pending controls but
before it sets ctx->kdamond = NULL:

kdamond_fn()
   kdamond_call(ctx, true);
   ...
   // Before ctx->kdamond = NULL

Would damon_call() add the new request to ctx->call_controls and return 0
since ctx->kdamond is not yet NULL and repeat is true?

If so, does this leave repeat_call_control in the queue and leaked since
the worker is already exiting and this check is bypassed?

Could this same window also cause a deadlock for synchronous commands like
DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS?

If a synchronous command with repeat = false is added to the queue during
this same window, would the caller hang indefinitely on
wait_for_completion() since the worker thread will never process the queue
again?

>  	return err;
>  }


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260327003224.55752-1-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260327003224.55752-1-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

