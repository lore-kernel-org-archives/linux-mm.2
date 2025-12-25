Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80257E78498
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 00:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8E156B0088; Wed, 24 Dec 2025 19:32:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3BB16B0089; Wed, 24 Dec 2025 19:32:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68716B008A; Wed, 24 Dec 2025 19:32:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 975D66B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 19:32:11 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 36B008B5A4
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 00:32:11 +0000 (UTC)
X-FDA: 84256116462.13.AC9B5A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 99E33160004
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 00:32:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oTqV4BMT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766622729; a=rsa-sha256;
	cv=none;
	b=iXAa2o1ilkhiB65f33mwZiMGAmyzyaqzAnGmd6RXYJwnlEgokkGS1ZLdonNxLGLtoaAS1y
	+O3v59MHnlwgDag6H2ynnsI0uOyX0UhfQWIOIx1cBcM18x2MBUYae4GtiXzfX6IKOOKILG
	WXb2R6TbBR7MBDzm8ioUyt7ZCZj17Qs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oTqV4BMT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766622729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mqnCvAApKbHjDZGFAj0/XZl1T5t1pTAnTJ6VDKZw3YA=;
	b=gfKjOp8DPipZyDEDJuGX1sP6hbaH5+57U9JW61ivYzX7Q/a89Yw/mORLrZCtnvlsIxHIkS
	fTwuBHqgbvFSrKMlBCtq5ZhlyWyoKBoXOkaaDr6ZwQuPD3Q1pxTxxPbONEk5b6KEG3pLtV
	+j3vU7DKUVR87EugDFCywz3c6u8ikSo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C574560010;
	Thu, 25 Dec 2025 00:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C7FC4CEF7;
	Thu, 25 Dec 2025 00:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766622728;
	bh=DMNb9i/SFEwVpqNQgZUPgGw3Co+PDnxW1tSpBKvAxVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTqV4BMT01S/DYK+zeEapEb9gaRIR94SZfxKYI7ZrjWnf+IJWS1z/gJVy4atUkm3E
	 8jZejl6IjdA7Kz/JAiY3+ZBocgQMwGS95L4yKdcftKz226koQIDikRFLylYPuQjboW
	 Ngw7C7V5UR9k5/1deF5UOnX3Ap7KR03AMKbJFLyIsO2qV/1wOlN5eaVVphYqhQb1gC
	 zTaL6WCp9rBsoNBVS3uhv1TZ/owf8Nzxw7BpFtZv2nW2QI7naHG1lWDbHEGnnEYt9W
	 EBptmq+szFRYZOga39JOgc/EUOmBmagEHrEbVpDC3+3A+1tO/UBVZha9CJZ5WeIs5u
	 KJfbAlaQ1CCrg==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	rgbi3307@nate.com
Subject: Re: [PATCH] mm/damon/sysfs: preventing duplicated list_add_tail() at the damon_call()
Date: Wed, 24 Dec 2025 16:32:04 -0800
Message-ID: <20251225003205.14522-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251224094401.20384-1-rgbi3307@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 99E33160004
X-Stat-Signature: 7i5utzkfhbg3puxbygp1rb9kaebkfrd1
X-Rspam-User: 
X-HE-Tag: 1766622729-798706
X-HE-Meta: U2FsdGVkX18yjAa6d0+bMXmmAwdiJm/0Qp3QBiXVuz6CU4CE0GN7FlWAnqcbKWp+Dex/Rnm9U3BNDpNpno4pH9f8bbNRMj7+ANriGMBoOR++FapNKEGC/1O+f6oajOl16e+ojGLJFdUAHXQ9PZdd9IChJtMcmcfJX5HSDa87jFl0SuaraRJ2aMOczMHKyZA7X6t9NgZR/dtv1ytNXec0PSy//qSxhaCllmuJnJYrjxSh9IXuObkEunscpg/JQE+zkm3i77cFVzzNoGP09eDlvUjRZhcNKlB+evFH31xa7x2CCO0IUwZ+RcQ5/sMmudvgYjSx99wlfKDAyww+9GqPFKEGvi1xJTcOtqzdbI4R88IDLwl5qVw/1aMTQvqY1NcMhaaYs80OhRG6BRhs50Jl8kVgo0qSiXX5m1QfCTE9KWXmQMHfbLr6TKTf+HqvMS5h9nh6J6kyGtE2Ta/5H6UNC56V1U0fSjmm8KLSK+qnfi89prnxU3+/mIP7EWUiewRfLVooip+pvcW5E0QElA8CJBYoljGtvk3DhgAJnMCpdGP0kXy4PaFP8W6pwy+1CtA7rIiQo1PGkPV7OrbMPwKPxSbH32wmwnPAR6/enNxVmHnvuY58bV7S/1Gqq/movmWKLA93x9oNfz8hBJ2ueXBAHVmo8GwTw/RS6SeabMZrYg4AfMzhOvzgHMvQcCdQL1vVTyi/9T1eu0TxJcFB0cLvmf1o8XqZ0Wh/ato1X2ruBhmErlt4DeeH+jjVdMGW7f2Dm1WpI43cbi37S3Vx27TKjRedX3vB16lwGuzz2pDNMRF9p/7ys+05i8CS86aa4Dt8/6PaceQ+LWmjrQxWenYAgizCmk0ouKKKrwmHfebDQwrgIVuyqfCJQbge+OSMYFMf7ij4TiD1UIxJ5Q0JZLtfdr6teX8rIwvAC0mBtcItkY2Ox5ij7WgpBjFF39KsJpiBT4vl9TT1JyAaAX7J/nz
 2mD1fTxU
 FSYIy6exFTn4o4xQz7a06KlL3VkfrmwLs1t4pHuxtCGBjaGwFiMlBgDQI0j7+O8U68xuDZOYL7VECrHBqsMQOLfeb7uwD6C4d+uGKp2oHCoQtu51RdP6NVpgw89qvTCaK2hNNZ8GpZRHSHd4pq5Iu3xpS2TlrK17egmwIxTmtkGCiHM5C51fSBGpR8rCFj6q9uiPS1Yh1/1diHGAO7ggGaaUTaOtcyC7hRnU+uukH4z0Hdcm2jvN6wqzy8QlC8gTCrl90BBe9gWpAzTSWA6gkDSH+fA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello JaeJoon,

On Wed, 24 Dec 2025 18:43:58 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

>  cd /sys/kernel/mm/damon/admin
>  echo "off" > kdamonds/0/state
> 
>  echo "commit" > kdamonds/0/state
>  echo "commit" > kdamonds/0/state
> 
> If you repeat "commit" twice with the kdamonds/0/state set to "off"
> with the above command, list_add corruption error occurs as follows:
> 
> 4-page vmalloc region starting at 0xffffffc600a38000 allocated at
> kernel_clone+0x44/0x41e
> ------------[ cut here ]------------
> list_add corruption. prev->next should be next (ffffffd6c7c5a6a8),
>          but was ffffffc600a3bcc8. (prev=ffffffc600a3bcc8).
> WARNING: lib/list_debug.c:32 at __list_add_valid_or_report+
> 0xd8/0xe2, CPU#0: bash/466
> Modules linked in: dwmac_starfive stmmac_platform stmmac pcs_xpcs phylink
> CPU: 0 UID: 0 PID: 466 Comm: bash Tainted: G W 6.19.0-rc2+ #1 PREEMPTLAZY
> Tainted: [W]=WARN
> Hardware name: StarFive VisionFive 2 v1.3B (DT)
>  epc : __list_add_valid_or_report+0xd8/0xe2
>  ra : __list_add_valid_or_report+0xd8/0xe2
>  epc : ffffffff80540bce ra : ffffffff80540bce sp : ffffffc600a3bc00
>  gp : ffffffff81caec40 tp : ffffffd6c036f080 t0 : 0000000000000000
>  t1 : 0000000000006000 t2 : 0000000000000002 s0 : ffffffc600a3bc30
>  s1 : ffffffc600a3bcc8 a0 : ffffffd6fbf49a40 a1 : ffffffd6c036f080
>  a2 : 0000000000000000 a3 : 0000000000000001 a4 : 0000000000000000
>  a5 : 0000000000000000 a6 : 0000000020000000 a7 : 0000000000000001
>  s2 : ffffffd6c7c5a6a8 s3 : ffffffc600a3bcc8 s4 : ffffffc600a3bcc8
>  s5 : ffffffd6c7c5a6b8 s6 : ffffffd6c7c5a6a8 s7 : 0000003ff3f32794
>  s8 : 0000002ab38c9118 s9 : 0000000000000065 s10: 0000003f823a5cb8
>  s11: 0000003f823264e8 t3 : 0000000000000001 t4 : 0000000000000000
>  t5 : 00000000fa83b2da t6 : 000000000051df90
> status: 0000000200000120 badaddr: 0000000000000000 cause: 0000000000000003
> [<ffffffff80540bce>] __list_add_valid_or_report+0xd8/0xe2
> [<ffffffff80255c86>] damon_call+0x52/0xe8
> [<ffffffff8025c9a8>] damon_sysfs_damon_call+0x60/0x8a
> [<ffffffff8025daf4>] state_store+0xfc/0x294
> [<ffffffff80dbf1fa>] kobj_attr_store+0xe/0x1a
> [<ffffffff802f070c>] sysfs_kf_write+0x42/0x56
> [<ffffffff802eef4e>] kernfs_fop_write_iter+0xf4/0x178
> [<ffffffff8026545c>] vfs_write+0x1b6/0x3b2
> [<ffffffff80265782>] ksys_write+0x52/0xbc
> [<ffffffff80265800>] __riscv_sys_write+0x14/0x1c
> [<ffffffff80ddf124>] do_trap_ecall_u+0x19c/0x26e
> [<ffffffff80deaa38>] handle_exception+0x150/0x15c
> ---[ end trace 0000000000000000 ]---
> -bash: echo: write error: Invalid argument

Thank you for finding issue!

Also appreciate for sharing your detailed reproducer.  Nevertheless, I think
the reproducer can be more detailed.  E.g., you could explicitly explain the
fact that the reproduction step should be executed only after starting DAMON
with the kdamond, and the kernel should run with CONFIG_lIST_HARDENED to get
the output from the kernel log.

> 
> The cause of the above error is that list_add_tail() is executed
> repeatedly while executing damon_call(ctx, control)
> in damon_sysfs_damon_call().  The execution flow is summarized below:
> 
> damon_sysfs_damon_call()
>         --> damon_call(ctx, control)
>                 list_add_tail(control, ctx->call_contols);
>                         --> /* list_add corruption error */
>                 if (!damon_is_running)
>                         return -EINVAL;
> 
> If you execute damon_call() when damon_sysfs_kdamond_running() is true,
> you can prevent the error of duplicate execution of list_add_tail().

The kdamond might be terminated between the damon_call() call and the
damon_is_running() check inside the damon_call() execution.  In the case, the
problem may still happen.

The problem happens because damon_call() is not removing the damon_call_control
object before returning the error, right?  What about removing the object
before returning the error?

> 
> Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>

Could you please also add Fixes: and Cc: stable@ ?


Thanks,
SJ

[...]

