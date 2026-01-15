Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2E7CD3CCA7
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 03:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E88216B008A; Wed, 14 Jan 2026 22:23:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35BE6B008C; Wed, 14 Jan 2026 22:23:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42A16B0092; Wed, 14 Jan 2026 22:23:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C31306B008A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:23:39 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82B331401B2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:23:39 +0000 (UTC)
X-FDA: 84332753358.06.2A0D5CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D5AAA40014
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:23:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2euoCv+b;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768447417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hQ4hXifsn2ZSkL3i0Km5rd6KhjDlM50In8Vfnkz7s9c=;
	b=5RZyzFcN90dKhrMkaLqU98D7C2EYEE9ZJEDqgYGRBb+qv921u1fTvnlLNsRVqXxOiPPSEL
	awi17ZdKn4reP7IIL5Bd2Tlh4zGGk7Z43PHjh3Y6aXx5df8wQgeSa/Xn+Jcz7RbNKv5/bt
	9qf6YSmdIgrCDik4khwdMIzISLUyP9E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2euoCv+b;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768447417; a=rsa-sha256;
	cv=none;
	b=Mb0bzYx+S2OL+9l3jWvAu+sPsc6EsNMrQpUMWdWPEh+zisU/asRmfaI1uBFce2gX3nAFQ0
	Z1vl0U5oAwdUFKUTXfLidGTrS6ZnfPJuhpysTxXAHhfe1g6qbCfDiG+JVJxYCEnsL0fuSK
	b2rDXh2DqswN1nXTgh6IFdqAQKBzHNo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E56B6012B;
	Thu, 15 Jan 2026 03:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE03DC16AAE;
	Thu, 15 Jan 2026 03:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768447417;
	bh=KN+zYSn8tDmLJyikkQkmn3ngIxIivedgTmssIMwqF8A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=2euoCv+bvYSLHd+iLJPBfCTR9dYqkea4DbbiwXBQVYQLiOOXMeNpbH+FHFjIvShcI
	 B/LLYSsCbZUlnmXrTOtJwOuJGFW2FgQG3FBnbyE1N8HBqOwClX0+VtD1Hpjt6azDwQ
	 5FH5bUfl4KIXmED3ylS4at9EIfR9Ky6Nz3VS/utE=
Date: Wed, 14 Jan 2026 19:23:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ranxiaokai627@163.com
Cc: surenb@google.com, kent.overstreet@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v2] alloc_tag: fix rw permission issue when handling
 boot parameter
Message-Id: <20260114192336.9d98f0330bfd6c8638762dd0@linux-foundation.org>
In-Reply-To: <20260115031536.164254-1-ranxiaokai627@163.com>
References: <20260115031536.164254-1-ranxiaokai627@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7w8bzr7ux83qyjy8wdp1de3grf8bx1ws
X-Rspam-User: 
X-Rspamd-Queue-Id: D5AAA40014
X-Rspamd-Server: rspam08
X-HE-Tag: 1768447417-834606
X-HE-Meta: U2FsdGVkX19/m+pstH10gYjIAoZoqr1ExG6C5L81jvmAz7qRStlY6o4qjyB7VxwHiTKzTXqo/WfdC8CKU5BV8M4uGp728Ms87sMfAye1ZL+GGn09CWK2TJ2/oe7v0uvLjyNlQQh6cAQRbDYMAXF8qgA2RZKsOzc+/rw+ZH3r+Yy+EbBnMCFYh+HFx/soqFhn1p4p7cy58ae42pK0++iIZTenT0U+i35SrijxbEFfOCHXACMXqRMXahlz3oC15myLOWpbdofFulBJJ2gM4BGNCToM10VbG/LEBDTXTLHkh8b/xUWzei9AYt9rrlBaZY2J5DksoWZ3BjVE+rSmlBT3gQUCmCuCnshDAzRt3Ku+1qc43rt5y6dFIFz+O+Yd8UC16mLvPr1ZwimSKA7wt5ygTGq/IW6XZ82gdftt5pHnGbIHISL6IuID5G0XaANCL4hWOmfAnhPlB96rR+dq2WAbpIWiE8YjvjczKHUmezs3n6DSJb4bqTea3VoenzRCgbH32b+dKz94CMrcBmEp11UAYtcWKmDKf8h7EaNmbcUKrzN6bmpBZXht9DOiATS3kFkq0F6YHiN0418DyyoDbkekyK0TnBdINWTmV7z2h+ISZTEgq9bkmXcLLxmbR8iBui1DILVrYFgTZQiyofy/6UaWK95M6KQNHf36XOqHxVuKjLoi0yYTXY+J6Ze2a/PgO7QjTX/ZgJtEg0WnRPTMkuZIkO544/Jg66QnhdORvmpy8r6LT9IVkkqwTozEPswznbRVvCCzZU4Lo0KyzyATyhc9b76/PKPO5AkImdHCt1bRWIXRufsUINtvNRxU+Us6ktfpkDTNj7eFJucRI0H6533rAht+FY7tzou0L1Kh7tkpuHRTY9u9zXZ2het2NvXNTLdDHlWcfFgQthDUKJ3JGSElc+30Nax4UypUZCZp2vx+yii8QeZvwGNQr2aDTYpBAgx/5HRb95sZTAEh4h9P1+s
 kmWlRAiK
 c56WjEjOERq3X8QEVVx9LYnvPAuHdLr1PG7zZR9MycdOwdrPM51F6c9tmV9r/IP89R80cq4yx6pfflEba41Xhxfm8nCJ4WyCcfna/6vYa2DxhhccZN76VxZzPTHP3cuXYcNHYMPZcaHuFiRoJG/wQvlm5bbHedQi1ez2DTjOPMiPyMC+Av25e0oLmcZHzY4G8APimEN37cpjrxGq15Z3sDgl8uc2Z7vAkQfxgLC2K8j+HdHkBO8/U70U7Bo1a2OQyNX/GfTzIOpxmtA/21jUEPZI8Z/+1WpTxAYWsRtuuEKPUzHeHl5JswxOvfBHUlLCRrVGR0SNReN7fH+4rj4kFI4JpRvq1o8q/Ka99hdiQoYxScIw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 03:15:36 +0000 ranxiaokai627@163.com wrote:

> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> Boot parameters prefixed with "sysctl." are processed
> during the final stage of system initialization via kernel_init()->
> do_sysctl_args(). When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled,
> the sysctl.vm.mem_profiling entry is not writable and will cause
> a warning.

This sounds strange.  Why would setting a Kconfig debug thing disable
alteration of a runtime control? 
Documentation/mm/allocation-profiling.rst provided no hint.

> Before run_init_process(), system initialization executes in kernel
> thread context. Use current->mm to distinguish sysctl writes during
> do_sysctl_args() from user-space triggered ones.
> 
> And when the proc_handler is from do_sysctl_args(), always return success
> because the same value was already set by setup_early_mem_profiling()
> and this eliminates a permission denied warning.
> 
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Should we backport it?

