Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2326FC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 09:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35008E010C; Tue, 12 Aug 2025 05:41:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CE68E00E5; Tue, 12 Aug 2025 05:41:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949BC8E010C; Tue, 12 Aug 2025 05:41:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 867C78E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:41:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2683F1A0218
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:41:19 +0000 (UTC)
X-FDA: 83767612278.09.B03964C
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf14.hostedemail.com (Postfix) with ESMTP id 31580100006
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:41:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754991677; a=rsa-sha256;
	cv=none;
	b=hNhY/cVWm6koshj1Cwe/K5MsBoPJMhyboW1shb1uWH9XkxNrZEYqlY0ght/DCFd2b4pggs
	KrFbOlVxsn4Q5tqCFYiORTI3/8Mz1vNTjzEUMZ5zz/oyr+oOZWJldSUUBC6DBl4hgAImEf
	uTvJU9yXgsrl3vDst6jmtJOglFk7N6E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754991677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0ZRHhJcxfKwjTa6kIvJ4bWkENtLvMKAbCz3O01opgEw=;
	b=PsJchxXsZHN4EDWzVAqW6KbO5gmhDEm2CoEFTzSLrVp0CgMs4bapoox0BI8gTHF+8PX8Wm
	1r+r4D8phdoRezrlksBfygAKNBvN2FQAk9/AT+F/9rw85A2PQdi6ktku7GirmOa+T7ozkr
	4oqG4sQpZuCHYKt+ydMQVIMuuJcX7Gc=
Received: by verein.lst.de (Postfix, from userid 2407)
	id B8E6B68AA6; Tue, 12 Aug 2025 11:41:07 +0200 (CEST)
Date: Tue, 12 Aug 2025 11:41:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>, Shuah Khan <shuah@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>, Rae Moar <rmoar@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org, workflows@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 00/15] kunit: Introduce UAPI testing framework
Message-ID: <20250812094107.GA27450@lst.de>
References: <20250717-kunit-kselftests-v5-0-442b711cde2e@linutronix.de> <20250717132259.GA25835@lst.de> <20250718073743-d4a1f713-f81b-4e89-b3f8-7eed838798e6@linutronix.de> <20250721070958.GA29367@lst.de> <20250721100913-0c6d93d8-79d6-482b-9db4-7b0c06b604fa@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250721100913-0c6d93d8-79d6-482b-9db4-7b0c06b604fa@linutronix.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 31580100006
X-Stat-Signature: dukqifg9e4t5wdakohy796qauwhxheda
X-Rspam-User: 
X-HE-Tag: 1754991676-109379
X-HE-Meta: U2FsdGVkX1+MsRrfFKMAjTtaTT2Hg+5+9pPbX48L3NXp7n2UAN88UXGe5DafumexgDDZHhLpv8iSOKBsMxP69679bu9sM1X2REuD7KlcLJkSrnM6f3UD+pdZWlHgBUPl5hAff+EcEe0kqzL5u+tGg3q/PZss6xR5r57MhscFktTBY+RRWaOlJa1rWRfDX3YEb4m7dRtIDNHnYLK9cARkKPcasNkCQN0QUeqcZhhTazMNphbfbsCx/2oOmvpVwDTDGwAU4pWTB0HqyIXUq4pXBj6vx4U7Q8xmQVAgPKcI7XY8P5qhyYpxRgyOL32XXsOIXAnRZwUVTvN0FMvtlOaK9ZuiKjLRva1qesh+vssD9kO/KXjsk40Oni9rCu/bCAKatt08VoX3k+e9S9BexmM23eASo6Bg+0KxRFTv2Btr8gS0aop1rscJnOue2oc7OwNILp9AB4DV3sFoVhboqZLI5brpHCp9LEM14D5RmjO8wFlUG9QFn97xqd8wHWa/3hRvW5F8jGKF6Yl8U/gAbCanKNhf0szBLtd3ubBHxgtH8sMCTAzfloPDaMKZQ5aBXrg6+Yeq0cRG/PIAoA/cpEuyvXm1bMkjEIELwYeBaC9ZfMq7sg84HOY9jP7Qf1peGtW9XkTgA16HLaj/KiSeRfuFkdBLEUMiNQWTWDb2cP2OZo7p0o9u63RYS8LCqB0tbQW7sau7F/Jbe+lQdH2TKPSjioDbTmLEs/8N1IZcJZiB45144/rsWWpmbiHStm8ssWMN5peZMMsLMZdpK8GWhlgvbT8p0OPFlCIGQHQUaLlYssfbXcnh/KiRTBQiU2nH5+M/9opmjChJ7s6uUoF4xAvto/QmS88JuQ0fPKeIYt8IiJjXhRtlTx/hgsV0hShR1JTljOeexTe97Y9Vo5I4f7OlLkBr6ERD49F7h/Frmdz1H70dGcRljPOzCW6YOT8Qf4Xt2cfUi1T4k/nHed4zh8Y
 OSbiJ0he
 Km2LBiS4k4bangrh9jww3s1isxils//bUYNRQMwsaqHxHfYXP28dAlrg1tL2VaE5LC4fUT1/eknVw+5EUoH3FO0HJ6LOrQVYADSINoSEmS9poLlApJQrgN/hXnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 05:01:35PM +0200, Thomas Weißschuh wrote:
> > That's great.  Let's reuse it without having to drive running userspace
> > programs from kernel code.
> 
> Running in the kernel is the point behind KUnit.

When using kunit as is to unit test kernel functionality - obviously.

When running it to integration test the syscall boundary - not at all.

> It could be done by putting
> all the userspace test into a initramfs and run them on boot from there.
> But that has other drawbacks:
> * The tests can't be run on an existing system.
> * All tests need to be loaded into memory together, and not on demand.
> * The tests can not be rerun.

None of that is true.  While running syscall level tests from an
initramfs could be a nice feature for an automatd kernel CI system,
nothin in this tests should require running from an initramfs.

> This was a response to one specific statement. Could you be a bit more specific
> in your critique? I am not sure what exactly you mean in some cases, making it
> hard to respond properly. For example "bloat", it is bloaty
> * source code,
> * object code for users enabling the new kconfig options,
> * object code for other users *not* enabling the new kconfig options?

You are adding kernel code both at the source and object level to run
userspace tests.  That is very clearly bloat.  Even more so as it adds
functionality and exports that don't fit in with what the kernel already
does for actual kernel functionality.

> > > It is not and most probably won't ever be. The maintainers of each testcase
> > > will decide which libc to use. Like it is in tools/testing/selftests/ today.
> > > Some use glibc, some nolibc and some can do both.
> > 
> > So why do you want to use it here?  And how is is related to the rest
> > of the series?
> 
> To make it easier to test a wide range of architectures by not requiring a
> libc from the toolchain. It also avoids relying on a bunch of out-of-tree
> code (glibc) as part of the test. And there are existing kselftests which
> use it over glibc for their own reasons.
> 
> But using nolibc in test code is not necessary and nobody is forced to do so.
> 
> (Maybe a disclaimer that I'm one of the nolibc maintainers is in order)

Well, why do you even mix it up with this unrelated series then?

> To run kselftests we need the following things:
> a) A toolchain which can build userspace executables.

You'll need that for any userspace program, no matter what test
harness.

> b) Quite a bit of supporting userland, at least glibc, coreutils and bash.

Well, a libc you will need anyway.  Maybe nolibc is good enough for
some tests, but as you already stated not for very many.  The others
are just an artifcat of how you run tests.

> c) A rootfs assembled out of these.
> d) An efficient way to incrementally rebuild the test executables and rootfs.
> e) A way to put that rootfs into the system under test.

You don't need a rootfs.

> And for all of this there should be good in-tree tooling.

Absolutely.

> Moving to a pure userspace solution would preclude the usage of KUnit as far as
> I can see.

You've still failed why using kunit is the goal and not just something
that made your life easier archieving your goal.

> > Yes, kselftests suck as most people will agree. But the answer is not
> > to add a lot of kernel bloat to treat userspace integration tests
> > like kernel units tests.
> 
> I fail to understand how this test code is worse than the existing KUnit test
> code. This is not meant to test complex scenarios, but single system calls or
> specific UAPIs, which may depend on architecture features. For example timers,
> signals, vDSO, mm etc.

So now having another half-assed test framework is a good thing?

> > How about you just fix kselftests, preferably
> > by reusing well known and teststed userland code?
> 
> Is "well known and tested userland code" referring to glibc or testing
> frameworks? As mentioned above, glibc can be used just fine and the frameworks
> I know about are lacking.

Basically any kind of testing framework that has broad use.  It's not
like there aren't userland unit test frameworks if you really want to
use that.

