Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 843D1D3EE66
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 14:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2CA56B0207; Thu, 22 Jan 2026 09:56:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E03AE6B0208; Thu, 22 Jan 2026 09:56:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0F1C6B0209; Thu, 22 Jan 2026 09:56:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C22446B0207
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:56:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 694061A03DC
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:56:02 +0000 (UTC)
X-FDA: 84359899764.28.2F07518
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id 51E7EC0009
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:56:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GpMeQa3n;
	spf=pass (imf10.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769093760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39Z3xY5BPN6XAwZM/W6drGSAohVogKjxUvJh+CCUHDg=;
	b=PfGzC45jKJw5MZHZT2r5X8238LoUUBXQ1n+hEEBZcVMt73xxGELo8+TNv/IDLJQ44KCk33
	bAoZSuuHyoczSYZUT4HcuR35bz9GPAlgudYP66U/qGBUIS8Yk6oM4lcNmEYnV+dQ9x8vE4
	vyt+9PyZF/MAcNqVQGvUybzqtqaX/GM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GpMeQa3n;
	spf=pass (imf10.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769093760; a=rsa-sha256;
	cv=none;
	b=W9Mz1F/XwLgdAGYBlCn0oNTa2bHEmPqBcfHXMp6ouN1wt1nvkxtUlefJHfimqEF2XyveHF
	LjHHS4dIVWwcsyu/qnD0e+12ovCxNhsmABiNxMCKdP0FLUJXO5nkb2OAGKge3Rc2/LwVph
	k3QmwUhpKEvjWD0GARrQ2Rl73TGLyfM=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-432d2c96215so886487f8f.3
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 06:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769093759; x=1769698559; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=39Z3xY5BPN6XAwZM/W6drGSAohVogKjxUvJh+CCUHDg=;
        b=GpMeQa3nhub9hEdzbkBL5ySOLsjt4odhmFBWCxmSQxAJgt5/yXBYQRCYypc+jzeK/Y
         xRwvGWBrWpWkt2YwididEbEZ0KsxDwLxmJ4EN/Eg/ucOpysO7y17mUnGloRtMme1ZZcV
         F/pLYNFhZ0Si46Hx9ksoQXwEKpwWgoMYqq6QegYke9MoyqqnUK9hAb8GJulHBFsvmh9r
         o5IsdTIMoQHNW/EZ6vJ0lZMnOxe5mCaZn6n34w4dK8sN+wVj86lZqoo+3gR1LkL9KORo
         /ooPfZTU6Nq/USfLpelDjKKqjz3xeB0aQqRN52draIe/Aji4dkJJHnvva0OL7QWWJKfo
         fZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769093759; x=1769698559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=39Z3xY5BPN6XAwZM/W6drGSAohVogKjxUvJh+CCUHDg=;
        b=EMpnr93wduiW9k7SODH19C0OUP6450F6B44mQhxL2LKFnaEH0BxezfuDcYlheC6FLN
         37Pxp9fsPcy85sWg/awQQyAy5vNRbRt6i8nebW2epKttDq2QxV+bBs8E5seCvT8suk9n
         oPPV37KExEeTrYOo+z5BbDx051DYGrEEuSUn9CYis+yX8OaSd4ANUgEYa8KICzFHNSiD
         ZNciyQsrMfoIhVBiLOMzi/YcWdStrUxHZ3xhH5A6mOt92+qoMPeTT2NR5/eE9+AFr33g
         drvOXbqxNIMRTAwec/mrFgARaaeKpBhlflgDZY16gwVTqP+xiZhSIgPbIwHXJY6luLQi
         cKPg==
X-Forwarded-Encrypted: i=1; AJvYcCXESnYDHenKDCwacBPkkLsKi9Fri4OanD0Y4IUNrfD1UNsXHl8XH5jZLK36KtWQRMoxw9va9vI8iw==@kvack.org
X-Gm-Message-State: AOJu0YwSwG3lEBRKeS5LQGaNP7CTJO/pyqvkCNPsEfBu/kZpzpaQuQUD
	HLSSFy9XU1VfMLFKEMkdghbL0HbwIxTNjijDnzXt7i61lacV+Lj9B7+1
X-Gm-Gg: AZuq6aLeui0E60LbZoPediWrk6VYjKYcaekQLaTtyu7uAoJDGz7fQoIZoRVYKE5tn5K
	+CsmY6ccBkFyy4Bparkg79e8k3NrFBZXpfEpVfSzuHOY3y/wDOvKl2/x5KMGwH9ufL0rF6JRxlp
	NURZrmps2ftIZ43GuRmb1J5RwT8Vr1ein6YvdjAQ2lj1/sYdxAePIpQBkdYxe6dOPiWD+JioRxQ
	uujPKYX4+s8oz4HjQSPml/KDWlpOl7g4cNiSJqCUVS1G2MRzeFbvXI+kaoxETUmIkwTFXL4Yukh
	aRitxtCq0xlgH/hTbmXnLm30CmtxjTGwaSuPrNwI/nCUTBf7s1lCttV4NZnORTOBlXqfNe1MntL
	NaY8+ZsMB8r9jzWClLPAPGCl8nA2pWr9nkBMSJZ/cB7ZaXN3GQd/iku1tl4WZ/9USY3l15thzWJ
	K7uhG/h34ErnSsHmAvNvS7oA8muoDZ6/heblf/avEjQA/Zvjdr1qGB
X-Received: by 2002:a5d:584d:0:b0:432:84f9:8bea with SMTP id ffacd0b85a97d-43569bcf38emr33053462f8f.51.1769093758592;
        Thu, 22 Jan 2026 06:55:58 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43569921f6esm44884589f8f.4.2026.01.22.06.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 06:55:58 -0800 (PST)
Date: Thu, 22 Jan 2026 14:55:56 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: kernel test robot <lkp@intel.com>, Nathan Chancellor
 <nathan@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Arnd Bergmann <arnd@arndb.de>,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, Yury Norov
 <yury.norov@gmail.com>, Jani Nikula <jani.nikula@intel.com>, Vincent
 Mailhol <mailhol.vincent@wanadoo.fr>, Kees Cook <keescook@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH next 11/14] bit: Strengthen compile-time tests in
 GENMASK() and BIT()
Message-ID: <20260122145556.7d72f217@pumpkin>
In-Reply-To: <aXIzpC6wpdv47cSH@smile.fi.intel.com>
References: <20260121145731.3623-12-david.laight.linux@gmail.com>
	<202601221237.soiAkwkN-lkp@intel.com>
	<20260122103337.26473d1c@pumpkin>
	<aXIzpC6wpdv47cSH@smile.fi.intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: of16hean8tbu6nnmobkzf93dubcbujnz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 51E7EC0009
X-HE-Tag: 1769093760-845408
X-HE-Meta: U2FsdGVkX19iXp7j41GaGKCCxUYS2jWdW13gtnaH3UYEe2ihRs1FK001dXuqKwN4f/DtMOrumgprc9q9S3tjuckmIo/Pa+lRttkJ/AbYX0HYlQiccsoJwzyfeUfe6ZNK4LwYBY9jepFQJjYI4QK7gz5VMmCvK0J3L77O+LC32/KY7FT0h1IbgMlNTzTx6UFQR5lqYyfbcksEuJJBWKWx5e6oHFqmqE+h8l5IQIwPUFqNZm2Rk9+h6jf32jdXVAztmDxSl1kaqmF2c3EoBGx7zEaV5fatlfvo3QVPesHnJV13j7IUkz0OENdyU6wEDPuGTtO2RrdUvfxwfaH8lfjOs3kR/3upOZCBzPlXEiD1EpyNnDZa9Y81Ts8ZIiWKfNkwloTiFCYYk8tnkclUVZBfF8A1/vfzzd5MU8/FRHwadYeWlsU4rSrQQGuXtiVjXnzWL1ihPwqXBTt+WrjzmBhUdnrImtiomkoQFCTCGNbsZQ5QkfliQfGr6QFo7PilCzKQlba9M8Spl7flcATCJL/oFs74WQmt4q97zV0HDj0cj0kegGYiSGoRuJcuUs7dR/ZvAOIkPzG75PCG6YfZSOX/j+5CA6qmmNXgBwC0USYmOremEPrO1+V7Muh/jv0Z8jFA2fjCeEuNdJnH0RMyotA+DTK0f7/A0l6v+Ot6kCqS5JWSNAwtt03cBBr05N8oiqr79pnZexnp4NLJasgk3Ve4jzLYoWsrjPhF8zCj2Gmbl6cgt6Wmc7gns/UpU6LKb5ZjnPqlpmbgqLI03xGtPx8umH2kM9/XQDbibRlQzzeVvN36mGI4nk9ahUFQZh0R4WSeYlnc3svO4z+uD5EkHtW0omcV9dXRKb9bQANfztrRm7d0T/3+1VUKmM38cQhwGW1WMjghCJPBu0Ej3znD3+k9KM80c7Oy8gTOQWbxzetpnnUrXLTAik0NmSA+2B1gPSwxWcozmNFkzj9Gueb1VNc
 WLtA9na5
 qB7isC81gw+YOq20VjZ30mwAfD8bcfPtP6pQaKqsFSxOBzEQGuHqWGsThyWNXor83pVGUHay8nB8Nt6B+NNnimmxcQgKL2M0KJNLqVpawksIq4awJKfJO6+yUVmriF5OkWqMldYF2QkeLokXzxjd4LwOOYWnXiZ74UGvdqV6ya7yb9LGzBgwKzA7F9rYUZmhK4ZfUmy4wsivcZqw8I9pUcXFd93+KVMOovjAEbtVyYKYuZyM7Kx8CAIk4JnR73bx60JA6eTROBH/R/d+2jylw0XOsBf9Un29HOsQPYYn0JpKV/QMfJG6G3B9SqjqSDRos9ywQkFOXBN6she0ePXOOUARXp8gz2XSr9lFjAaOkf7ZBmgtcIjnmxRrFMn3SsjQdPHd3AZ/pp4FqxBd9SUxCK9G9jD9Hp7U4M+vML/faaNwdKQpVpYLN0KiCVRmoHxsbvqIjZ4X50T6wkiV+QAgaAXk/FTgg45XK4KstWuM8urJYvRYALhUHSlWcezHGCo7g/TCiIkXGwotABeIdIs4DjaTTGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 22 Jan 2026 16:26:44 +0200
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> On Thu, Jan 22, 2026 at 10:33:37AM +0000, David Laight wrote:
> > On Thu, 22 Jan 2026 12:41:22 +0800
> > kernel test robot <lkp@intel.com> wrote:  
> 
> > > sparse warnings: (new ones prefixed by >>)
> > >    kernel/kthread.c: note: in included file (through include/linux/bitmap.h, include/linux/cpumask.h, arch/mips/include/asm/processor.h, ...):  
> > > >> include/linux/find.h:209:45: sparse: sparse: Variable length array is used.    
> > 
> > Can we stop sparse complaining about sizeof(VLA) ?  
> 
> First of all, the LKP should install the fork of sparse by Al Viro. That will
> fix tons of warnings that are related to modules and speed up the process
> itself.
> 

The problem I have is I want to generate a compile time error inside:
	__builtin_choose_expr(__is_constexpr(x), x && error_a(),
		statically_true(y) && error_b());
Neither static_assert() nor a negative bitfield can be used in error_a()
because they are errors when x isn't isn't a 'constexpr',
There is less of a problem for error_b() it can contain a function call,
but can't contain {( ...)}.

One of the compiler complained about sizeof (char [-!!(expr)]) as well.
I'm not sure of anything else that can be use to get an error.
I could use 0 >> -1 but that is only a warning, at least the error message
is related to the bug.

Any other ideas?

	David


