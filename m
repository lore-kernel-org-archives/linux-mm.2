Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A427FF60C2
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 05:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0DA86B0098; Tue, 31 Mar 2026 01:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBE406B0099; Tue, 31 Mar 2026 01:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD3EB6B009B; Tue, 31 Mar 2026 01:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C85516B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 01:30:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4EA4414098B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:30:29 +0000 (UTC)
X-FDA: 84605232978.10.C63F3C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A7BACA0005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:30:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jAULHBCc;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774935027; a=rsa-sha256;
	cv=none;
	b=IkvuEjluQ+MFT5uZqPUIU1vv8YtbppnwM9LzeaSUM+QNlOdNch2Ytg7mlPtDNBXfBQDfMK
	NErX3iVNBgy0Yg71QSlC9hqSc2D+OiYMuNknCKtdgnzfsaUlvG3b4UMcg+JeoXubbK7jgn
	9YQHn50/imBEwLoN0mxc4hOGm0mqBXE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jAULHBCc;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774935027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sdG9hJ7QtYd8jfrVmKyydEwk9c9mFCCaioV2wDmT0KM=;
	b=Z64Uu2T2T7p9uxXDS4CxiPyHzPpFNWXRbcQFgwU4yxmyTAttOyw2C2WTq0FRx3B+IJ66Rq
	F7jNJ2SjoDh6mwQcR7pYI9dUa599wVXmCDL4d19Hsj+08xTeKw2dQGpWxz60pPjcmGKmOw
	ZROSwQedm4JOZZufKxS6+ImJaG4tGUU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AF0D600CB;
	Tue, 31 Mar 2026 05:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4CFC19423;
	Tue, 31 Mar 2026 05:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774935026;
	bh=awxDJnAQJUnZuYVgiLZKewBA9gUakStcl3tPHpT91BQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jAULHBCc+krXR3vE2jMC8wyXP1v4K2VYX5ohuEcmlrDTmy3y4VT3x8LY0uIx9EPs2
	 zTnheCGPyLk3BhTtUI8y0YTylgq6LnMpMMWFp0fozHKnlhlQZabcn43GDUrIydAojf
	 fF+X8iT5pNOIQdw7+w7d60qUcaTSgM9snfv8+glU=
Date: Mon, 30 Mar 2026 22:30:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <liwang@redhat.com>
Cc: david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] selftests/lib.mk: set PWD from CURDIR to avoid
 wrong extmod path
Message-Id: <20260330223025.4ad1cdb9b79e242f01d8b83d@linux-foundation.org>
In-Reply-To: <20260331040156.119158-3-liwang@redhat.com>
References: <20260331040156.119158-1-liwang@redhat.com>
	<20260331040156.119158-3-liwang@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A7BACA0005
X-Stat-Signature: q9i76ac9ihctzbhqaaad5bkb9smrgipi
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774935027-89468
X-HE-Meta: U2FsdGVkX1+GHWSlq/amSW4L0Zm5Tdw+tT7YnsIzyLHk6zQV4P43eOyd5B83FwbrNBlS7LA3YH12NdSVsY3S0xIovjFHWEALnIGcVU36IQU2cdMiNV20NI7MU6rrPxa6F7M2AicaaLojaWACazstE2qP7eQwLDaBopJh1dNnjuoKWeV9b9uH0JLdV5vvwJ8H+dvxD83gh613xReTkvJfpTfXQDckWEpWJBgpw/KH4bPKyL8SYZkd53qq3JHsC0s9Nd3lzf8do4YaENAaSTXB1YpIKVf9sFGsLGpaFulNKQe0XpYAi0BnLmRcs4j1PfVHMdtb3nApc8PP2GFQPqw/Vd7u0MtqzsM7haxSSLSYos38fov5eUIPEvocYl/WW2jvVrZR3juSQxr6Ky8zOXBJSuWn9v3NyTIC1+JzUR4W+S3prFSddfopGkxiYmTedyCQpNaTLYuR2326PZxR6TQWIqbO8qSO9/pY01QOlC2Et96dp127cDUKJjhr/CPKf4e3xi5Pe/DanGKThRX2K78MP7tpsQIwvc/0RWcd/St1lTPGycvruXT47KBKUdh9XI4960o9KBjbT+1E9eXZx9wD0rl8mBj4DbHmcf3rxJAeJ9lnrof2Ee1UQ2MwMdmvM23WcnFGXLC5gLfvrsyWEh7G/g+7XAAOO7Pt1MaSw/W7h/ARSHXZvSZjetVXzRTsLwLowJSS9BhJWJ8hAlNnz54d+UPZ5PZqQPUVQGV8G3QgpR9qQOInU60mzgCZeJcUnstGyo7ktLIvg8u4ddj5I2w4fTd80hdiMRC0iMc5Mx1/RuQW52MeD8cdAjzXI8ZpKWhiNnvmkVvM6GcU4HMK1RdvLhOk7oj2HdTfYEmIz6++hgTCn/buh/PKQlhxXJM/f2UfsUZ/veba1j/xHVfQUKrLGPPPDeTEoC6yPomagyWkpTtVABIMrz45FvEQZ8uavEhbzv1HZtuSlspl/XPzdA8
 0+7kMUSs
 pQS/CaP/gIaxHFiQNiTJQXWYguXHWuke7YxzxPgVwd8DyoPBM1WwcAOEiS+BHxudGVhp+gMaxaDZQC9EInHVkYFvfU7EDpaI1O0mFGQJ/V83c0jzlfV8Qkg15mXOSs8KCUbkTeE4N4i3m5NYaMQGIJgOPbTqHDPo6BXK0LPPvUCeP+Z3xOcCYAu1us5kdveFiPJYA5AsDlNyEqNVv7Nzz3YHWuG3OcVY3ZSJ4Anl/YwOjUrdrC43U4f5UR7iuaUIcQ3KAzQot6uh6Vj0/StiuQWR/06LyRD5I7jEpbAAW8BhO1VTpAGsitph5CpVoTtL6dOBw4a/oLlrExSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 12:01:55 +0800 Li Wang <liwang@redhat.com> wrote:

> When running selftests from the kernel top-level (e.g. make kselftest-all),
> sub-makes might still inherit the caller's PWD from the environment.
> 
> Some selftests use $(PWD) in recursive kbuild invocations, which can
> then incorrectly resolve to the kernel top directory instead of the
> current test directory.
> 
> In that case, kbuild may generate an external-module wrapper Makefile in
> the wrong location, potentially clobbering the top-level Makefile and
> causing recursive include failures ("Too many open files").
> 
> Export PWD := $(CURDIR) in selftests/lib.mk so $(PWD) always matches the
> actual current selftest directory.
> 
> Reported-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Li Wang <liwang@redhat.com>

I couldn't clearly figure out what I was doing to cause kbuild to
destroy my top-level Makefile.  It happened three times and it wasn't
fun so I Stopped Doing That.  

I tried a bunch of things *without* this patch and of course, Makefile
is still intact.  So I cannot confirm or deny, sorry.

I've switched my script so I'll henceforth be running -j100, shall keep
an eye on things.

I have no comment on [4/4] - it addresses something I haven't seen.

I'll assume this patchset will be handled via the kbuild tree.

