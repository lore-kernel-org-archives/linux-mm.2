Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D91D105F7AF
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 14:48:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CFE06B008A; Fri, 13 Mar 2026 10:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D926B008C; Fri, 13 Mar 2026 10:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87CA16B0092; Fri, 13 Mar 2026 10:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7588C6B008A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:48:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25F6F1601EA
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:48:15 +0000 (UTC)
X-FDA: 84541320150.20.DE3510D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6E92A180003
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:48:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mcEG7Lcp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773413293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5M2HEq/sFy0WjbfiSEKc+uzwRzJKs8HdUTuQF8gfJls=;
	b=JyMkZQV5GdlYZGln1C3T7tqoZ0RzZ5PZ9y12VhAf4F7q2qDjY3xfqurg01Q7KHVfHK9bTO
	9bSvP+joQFxb252K8w4Ys4HjYPwtSR9BjT0h87cf5Ugk76gDcv76aYxS5kK1rzFq8SyM6W
	NWhZ+hgnhQmTnQurrZQ+Wlayr1+OWas=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mcEG7Lcp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773413293; a=rsa-sha256;
	cv=none;
	b=mfeJDWTDNsTWzet6Zf+FpAKFktNcQ7xHN49uuKaA403IbnZOwAfcdzHkzdl0NRUBcQfZK5
	F890D9zMVexNp7HKSVfXTSdxs674nH/WgRz0ZU4q0nkMuaiw+IAiGgqD0doiQ85yigmvYP
	HCFsvBdkCPxCFTW+tr5PnUNASyEvkBM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 52D4C43D12;
	Fri, 13 Mar 2026 14:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3F6C19421;
	Fri, 13 Mar 2026 14:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773413292;
	bh=CUmFsU2G+NBF4oI24RS3s7BTKOpnDvSejeSWKgDW6y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcEG7Lcp5gbPg7QvViC5EM6NsfYIuaxOUVfI6Ps3cHxNmGUwjmVW0vmwXVrcxSX1c
	 k9eJFrOtZpnUwXvNEdk5OR3TcnuXF/XQRGhZsWpYFsF6dw6XSOgeYh6gGnPLsXuFbF
	 ldFhrgJeG7g3+0+ph4r5UH8uBIv1YqrhdRa8DSPtZwV6aUoIU5DHtv6wbty6etPhNJ
	 LdZ09iDzyZQPp5LldQUhcWrUvofNB8MygeeWEVq3LYI4K5wRZ9NRW0j59uD0Xid350
	 60dnn0ImFOKBVWBm28RoH8aHJhz/fove5WgZ/Cenm8NUeQAyYFRVVLSe+pDoGc4pEq
	 tKVIpb4ey6gAA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [Question] mm/damon: conflict between DAMON_STAT and DAMON_LRU_SORT?
Date: Fri, 13 Mar 2026 07:48:08 -0700
Message-ID: <20260313144809.46527-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260313111702.38667-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6E92A180003
X-Stat-Signature: kfi8o3t3hn9i8q3xsmnmniqm9pmdj94s
X-Rspam-User: 
X-HE-Tag: 1773413293-285299
X-HE-Meta: U2FsdGVkX180XMdKMGJtRnabQVsAyilDQQGxL0Qku5UrWSXbY8LO7tHzuQAhaXW57pkdv/oT1HtuP//f49b+s1gK6IubPJPmYQkdkzaiAhkfOZ7lUU/EhXKlMoeBF8SM3GqVKOJveePfGlNMWsJs/GZlQYC6RLr7Pj11ocZeb0YCGGmFmqz5WlZswR6UrBdmRw43hdiGDIR7O2qPOijHFH8YbcUvB+IXAwBummpf87chNFlObpIgQzKRxOCOgrejnsZmO7jeYioGnbUj9egEYiHldHvu3h/U/2K6A4jIgEcSW/j26xrrpOjNg71vXyA7bY29gc444klwa7DOBxhQISEjC3L9Br9Suasi4Sm3Ie9tPJqfm4GuT6yhP3IzvjrEMJCrdwTumwHPcyM/reZS+L2KjnftZc8YtDYJVv16Nx+gCuuUA4o56phsynbOvHJ2CTnNKog5rXmS2LTVKQBjT46onjWCuNx76iuC/CS8Ybz9vwLh3gMfU1v3muSE5ZbZJz6a6JP1oFbOX1U2C/w9MF05wjaoU7CBebjkGgVCLcYE+Xkk6G+is6gMWPdRHFEVcxiu+eX6E/Dg5S6oiB5ols72chEYPmvowYvdZXtNev6vmCsSR4rc8Fcy3q8YTcaTW5jz7vxvWERu/IIsWGXWXkHrhnvW/zXcuzmcnFU5Io8temyk6VaoxN6QcGlJz+hKU81qUDm4V45NBxQnHifJC9zopqEZmL0UITeVG0ojhRjPqmL6mpH44Zh30lcIY8KZ8VtO74J2DKcSF8NVf6IuTIbN/0klCCBZnAMSXFL2WGe9BrP3ApOkZgHRXGucbo/0GqideeoyCugr9sK1SPliljhG+o8zz8YoJP6hWOBBT9/mmrTIoigDwZM/e9YguV4phJHBCP7T4doMlaBeuqgw1lAJ7QJCecRZWuzo44gdB/0ZWAHR8WH+POUlgmwttKKdPaHahXxsVWGU2okTiRu
 50XuO+Py
 e2LEKtKZlS9MdnlDNHB3tCPWaC4FjebcUm1+PxO+C4hTyBbcsgX/R4v+M6Nx9TiuQhz6Px8u0qelhGpY8uVYmmhVYRc8kGzEVuAnVWGJ11BBJrcHj98KBvdj8yq3zdik2sHrsggIydAyua5Jdy/Cz4WcboqKzT3VRMM8/9fv539pUddN2aUtp4Y5V3cKBBN5qlOuP9eQzy2zx1n9jj02DnV+M7ZJWW+PsoScsDrGFGoLuCGN1/QhLvyJlRvHAKYMZsF9jEm+uC3+KcL9H4WPLjz23uGvEiQsTK7lSLOYeoQXBe14oZIhiUOOTvC/iMpr6yrZ7Lq9tMqcqSi3GewuWEyyp0EGRYg5OeFfE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 19:17:02 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> TL;DR
> =====
> When CONFIG_DAMON_STAT_ENABLED_DEFAULT=y, enabling damon_lru_sort via sysfs
> "enabled" parameter returns -EBUSY. Is this expected behavior?

Yes, it is an expected behavior.  DAMON modules run in an exclusive manner like
this, to avoid interfering others' monitoring results.

I'm planning to make them be able to run together [1], but that's a future
work.  For now, this is the expected behavior.

> If yes, should
> this limitation be documented?

Good point!  Yes, it would be better to be documented.

> 
> Reproduction
> ============
> Environment:
> - Kernel: 7.0.0-rc3+ (x86_64)
> - VM: Virtme-ng (4G RAM, 2 CPUs)
> - Config: CONFIG_DAMON_STAT_ENABLED_DEFAULT=y, CONFIG_DAMON_LRU_SORT=y
> 
> Steps:
> 1. cd /sys/module/damon_lru_sort/parameters
> 2. (optional) tune parameters: hot_thres_access_freq, cold_min_age, etc.
> 3. echo Y > enabled
> 
> Result:
>   bash: echo: write error: Device or resource busy
> 
> Workaround:
>   Disable CONFIG_DAMON_STAT_ENABLED_DEFAULT, or disable damon_stat at runtime
>   before enabling damon_lru_sort.
> 
> Questions
> =========
> 1. Is this resource conflict between damon_stat and damon_lru_sort expected?

Yes, as I mentioned above.

> 2. If yes, should this limitation be documented in:
>    - Documentation/admin-guide/mm/damon/lru_sort.rst
>    - Documentation/admin-guide/mm/damon/stat.rst

Yes.  But, I think 'Special-Purpose Access-aware Kernel Modules' section of
Documentation/mm/damon/design.rst is a better place to document it.

Would you mind sending a patch for that?

> 
> Additional Context
> ==================
> - On major distros (Arch/Fedora), CONFIG_DAMON_STAT_ENABLED_DEFAULT is typically
>   unset (disabled), so this issue may not affect most users.
> - However, for kernel developers or custom builds enabling both modules, clearer
>   documentation or error handling would improve debuggability.

I agree.

[1] DAMON-X in https://lore.kernel.org/20260307210250.204245-1-sj@kernel.org


Thanks,
SJ

[...]

