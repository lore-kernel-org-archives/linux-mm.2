Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08F57CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 15:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F8996B00D6; Tue, 26 May 2026 11:13:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AA516B00D7; Tue, 26 May 2026 11:13:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E66A6B00DA; Tue, 26 May 2026 11:13:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 507A26B00D6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:13:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22AD416177C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:13:08 +0000 (UTC)
X-FDA: 84809914056.13.93CCE91
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf21.hostedemail.com (Postfix) with ESMTP id 66BAF1C0016
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:13:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=xtHDw9ww;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779808386; a=rsa-sha256;
	cv=none;
	b=IlmSfkd0mdR1OvIRKy7DGCjmzdJaWkbouY/2XfhCi9iFiq+fg6Ob3VTpZutbP8GozAjbps
	Mwu0mfRZX4IRDYpm8Gw/oV+JNBK7bBF0hRYNO8TSR1ne0X8VnLm3ZKe8UwKB5tMfHyv3zc
	ZZfNyKPFsoyO3mw8OTYxRLkhX71qq04=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=xtHDw9ww;
	spf=pass (imf21.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779808386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w7fh/zrSEr4aiiZTWxTruWfZmIvpNK/R/una2H3xjd4=;
	b=vwcqPwr6/valT9A6kzifQeChPBT2SuS3jNtc8CtypRCacziHLXYSmpluYVGSRVPe1Rs/8Y
	u0zRYrdw7Iq8NDao7aW/3XW3UMEoC74FVRZ6unv+R85Y0fk9NFgiI+MFA1Z2KGgJ78ydTF
	EjgHNBDWufJsObd8e6z7uMQdLEXATy4=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id ABC03D0C4B;
	Tue, 26 May 2026 15:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1779808384;
	bh=w7fh/zrSEr4aiiZTWxTruWfZmIvpNK/R/una2H3xjd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=xtHDw9wwWgqvb9UrbriKSbej9cKBiuXOhXwAhLqOTPYFGTinLcwujcGvPvsxucVMi
	 f40mdSZNqRod8hk3AUvSpNVBe6EsuwUCVn5aSuGl9ShxLBOaPukHknCQlJs5LfML+L
	 0kORWOZO3guDaOo/Co0LPMOdQImXXuCIgBPa+Goo=
Date: Tue, 26 May 2026 15:13:03 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 3/4] cleanup: Annotate guard constructors with
 __nonnull()
Message-ID: <ahW4fyZ6j9YvJho9@shell.ilvokhin.com>
References: <cover.1779286416.git.d@ilvokhin.com>
 <0ab092c41e18e6a7db703547d87e6b632d6f79b2.1779286416.git.d@ilvokhin.com>
 <20260523084901.GF3102624@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523084901.GF3102624@noisy.programming.kicks-ass.net>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 66BAF1C0016
X-Stat-Signature: q75qdzh1o7q91nbaz5rcozfhc87o6jkb
X-HE-Tag: 1779808386-118193
X-HE-Meta: U2FsdGVkX1/0YQSndv32MIRr8VNOzabNJWeeNudP+IlC5mqcqU70iSarSY4l356BajK2hIlvhtUbwwHVT2UGflIsVtzsO08iYKHSHb7s5qkhUcBgI7BJTzU87vWIPTCUvzOoFxO+2KAmd0MTSa0swSk3Us+V/rJnFYv6qD1F4wKBmhOK4tFDDtp/iH7u34fCuw3f6j37p+IbidugMITZ0t/mxBNt9pGhsg2byBkbd34aSop2yM6PbSnUSGeFqkFoJqIswfJKAJ5TaGTiyU+oeWZIXSpX/YuRynStriC6X4PuOeSebHrD2fnm+H4CB1MduF/J82A1scwl++WPHalmy9lzSPCiDqxQs3yLMa5B0LkMVxvY45Z5nou95Y13xAZIDh7Kj5boxXtJ/j/f1mvAhbNQkQQULVWxFuGswoAKNcA5VvsucXwMCqcH8Ts3J2dn7qkuNt1tb9OqF4hsiOUm8JHBtPTmPsfEtmqvC3s2uxZU5ae8tHz6O13sr8v4j8RJ3pkBHEpBDNW95XUNs7ALVC8UvJN95EVZWMpbY4HON8XloE93N/+smw24fNX9O0reMqoENeJe17ljPzQ4zzR0Xcmj2hRZ02SPVuwXLT98edRbohXlDDiuSxjNPxMYbpakbMunudrUS0jgQu1Iw18BKsueT1aTr8HWjgaSLuV/9rUhnNTdU5ToLIWDtcJk2jhBjjx7IAwt+fjpMen/bM0g774NjbGCW8S1cOMps/9DzNHbk1oGAHq8PIdg8YrQ/PvcrCFRymF2fEjW2Lz3j3vjx6plZgo9ysmIOYpdVG6wooofgO89vhd6NOsT/BOeAK2/5kLfg07Rh/ebR6irLx6Jwmxe0GwApsQng0Z15QOpZyq9xqc3a5DonVzqJzIyqsAYhRZ+lNkvP3Z+FzmlkvS/+doF94jHAB10c/7dqF5nFOEHiWONJhgTzjVCaT1qiP6aGemM3RaU5Ry3IFyw4Hp
 y60mgZcL
 tE6hpJJ7GCcJkH0W0WN/gTTc0oWVImDi3BUusDhwhNHdq1W9/vjRsdzi48oxKiH2iwOIR3uJQ3BIpgG41hJJalxvvrKlzjDUUtQBb92eEH7FZyz60JdpUKqaw/FNkskPBrKVODWRGEWSCLe61HP0XUzgZJsAwxWDHAoMZ4YZ4ZIalGUkwVUpjcRMCdQKtDiVrfS6QMUcqy3EuxAXOa+6aK55qb+ZiZ7LcuLhE2Ud/m2THbWSNbvdxzpK19FEDDG7csGZCciBTAbA1dm+k1f24dVDp5uzC7KDUJrVw8EjIHmF5AWe0knX4t/Higffe0r52nJ4XyOrt8FSllXLvMnhtK8vFWMf3OWN2YXzcUmgZCPrc2K3Gmy82TXQqQL6Qtsz9367bcST7PoMUASKg51Dx2lBn1vRd1i2hGGzSzEy4Bvlzu+o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 23, 2026 at 10:49:01AM +0200, Peter Zijlstra wrote:
> On Thu, May 21, 2026 at 07:18:03AM +0000, Dmitry Ilvokhin wrote:
> > Add __nonnull() to unconditional guard constructors so the compiler
> > warns when NULL is statically known to be passed:
> > 
> > - DEFINE_GUARD(): re-declare the constructor with __nonnull().
> > - __DEFINE_LOCK_GUARD_1(): annotate the constructor directly.
> > 
> > DEFINE_LOCK_GUARD_0() needs no annotation: its constructor takes no
> > pointer arguments (.lock is hardcoded to (void *)1).
> > 
> > Define the __nonnull() macro in compiler_attributes.h, following the
> > existing convention for attribute wrappers.
> > 
> > Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> > Acked-by: Miguel Ojeda <ojeda@kernel.org>
> 
> The build robot found something to hate in this one. I think you're on
> Cc there. It looks to me like clang-23 is confused somehow, but who
> knows.

Seems like clang is not confused here, I was able to reproduce the problem
with GCC 11 as well.

There is a conflict with glibc's own __nonnull macro

    https://elixir.bootlin.com/glibc/glibc-2.43/source/misc/sys/cdefs.h#L560-L562

which doesn't match the one from include/linux/compiler_attributes.h.
They usually don't collide, except for User Mode Linux builds, which
include both kernel and userspace headers.

Options are:

1. Drop the __nonnull() macro from include/linux/compiler_attributes.h
   and use __attribute__((__nonnull__())) directly in
   include/linux/cleanup.h. This is a bit unfortunate, since __nonnull()
   seems like a useful shortcut, but seems like the simplest solution.

2. Rename __nonnull() to __nonnull_args() to avoid the conflict.
   A returns_nonnull attribute is supported by compilers, so the name
   fits, but it diverges from the existing naming convention in
   include/linux/compiler_attributes.h.

3. #define __nonnull(params) __attribute__((__nonnull__ params)). This
   keeps the name and is compatible with both kernel and glibc usage.
   Current call sites use __nonnull() with no arguments, which works
   identically. Future callers with specific parameter numbers would use
   __nonnull((1, 2)) with double parens, matching glibc's convention. I
   don't like this option, listed it here for the sake of completeness.

I am leaning towards option 1 so far.

