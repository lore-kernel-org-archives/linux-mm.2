Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DC3AC61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DEBA6B00B1; Tue, 25 Aug 2026 09:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B77E6B00BE; Tue, 25 Aug 2026 09:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CD246B00C0; Tue, 25 Aug 2026 09:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 512096B00B1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:36:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D40071A03F2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:36:32 +0000 (UTC)
X-FDA: 85139891424.07.7FD55B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 416B4140011
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:36:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bL/6T7Pt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787664991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3O0jUa3F64kLLrL5LogQDPv2j12GdtTejlIkXela4M=;
	b=mXGeH/QrMCUDEVZ8u0nUuGT2aJSlPs6vThLGeJSt1LnT7on0aauO1WE3vdjw4+z/U2Gb4K
	T8/pzsWmT4t2AqRNKC93R8FSEiLqSLnLCd002IJOYzbLFArwkCO4CInCk2DqbxM1u7049J
	uEY5RNG3nu2732fxL0xLrd0OUFRnqaY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bL/6T7Pt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787664991;
	b=pUViT7L0Spr0Mf11b5SSXzpN9pgtctlkC9leiRme5b81PMQw80ysAGbZTkwq4NQLtS7T0T
	sPLUjHEwPt/vjNIY0Qjea2Umsg41DfhIc5P0EgmlBG6NaHVdo3pUOrCibCfQH/8JRPpnf1
	cGJw6+Kevfspjy0B7MT2jFCoahK3X/8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3F2D6011F;
	Tue, 25 Aug 2026 13:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996F61F000E9;
	Tue, 25 Aug 2026 13:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787664990;
	bh=j3O0jUa3F64kLLrL5LogQDPv2j12GdtTejlIkXela4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bL/6T7PtIl1SE4jX/P04Rg3Ro8uDMTXBR+IfVYE+x9UAvjV6ffKU5KIi2UYbb2Azk
	 p5jWRud8g9M6fKt/WdbCiANY8IOY6E0GO9tF+/y3HH2CIDHPBZRk4lM4v8EXdA9xIV
	 vvdmBV3MJpokO9m4uxF0kV9DadEr5xUgE4g1MEcQyIKv4p2QffHM5m8kqMZ5wAcpr1
	 1OFmbyY/SJk7SamSMGhyjmip1vkbS4m5jfEpR9huTf9xGy3VQG/pSuJr6VdL+amyfz
	 85Uhn+kpEjV22Ml8U417c58fgjFzYStIqvm9LlIaMeR72+D3VnMuYgSB9ZwSdjt5wy
	 9BywduZwpF00A==
Date: Tue, 25 Aug 2026 14:36:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, liam@infradead.org, rbm@suse.com, 
	akpm@linux-foundation.org, luto@amacapital.net, brendan.jackman@linux.dev, david@kernel.org, 
	liuhangbin@gmail.com, corbet@lwn.net, kees@kernel.org, broonie@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	vbabka@kernel.org, wad@chromium.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, geert@linux-m68k.org, 
	daniel@thingy.jp
Subject: Re: [PATCH v2 1/2] selftests: run tests on nommu architecture
Message-ID: <ao2aTD1ZGObPfp4T@gremlin>
References: <20260825015945.141739-1-thehajime@gmail.com>
 <20260825015945.141739-2-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825015945.141739-2-thehajime@gmail.com>
X-Stat-Signature: j5ssceo9md3jo6i4tun41uoq1m3secfh
X-Rspamd-Queue-Id: 416B4140011
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787664991-254480
X-HE-Meta: U2FsdGVkX1/ARjsXetdT3zEFC3BWXwu0xnORkrkco40wm8YgtnlxLxwFjs0RAf/eZxp5JzUnJaR6SbepalDEpnX5s4VQt9D3XapzWLGcEX4g+V2oSTrCuRSeLotgLpmrZAZ3zvxfbGTEewjzSxZ8XFn4sV6cCHBdAXK6CDPc2Ywtjpz9wC3T7oPEcJUxOeIPb92JmsfgoeYqlgs2k8l3uzRp9h/6Rg5aOBPiQOA/8uZ66kwqaix/8A9SnFIyPgG4XI9Uv2WVwdxhtJVYmdsnq4eAIJwfgVySIwS830EXwWdmj6RWZF4b3EqsuAuxeA/6JL1u8zL39zhMW23iYNqi9Lxb90y7MCynQ+R+vtng5i6Qk1M4QMGR1jSQzcyFBpYjoftMzHyHhlcfcpjDi5yPl0PlrbvuAW2GVX30TqwUIaZFe/ypF9tsOcoDIT9KaSPWF7eX9HemB2xTkQ00Z+PAshUMKUA5PvPnY1eWPaGmMUJweuF7Ril9XHZ4coGse6kJVo4zvwG8xbmcYAGBbpFICatjj4gz4cAI7Nhbt3mfEq8lxScS3PnpQtT+8n1+dRcc019MILa9E1h69IpiKxzVH4OhsonyPEhuv1AHjSrrtmGCT+XXS9pSwL6dHIyahsuTn/HwXHwM+6hlwodijQZ0uOCtJshQ3wjNVhVaPQgD6iFprchP5de7DyZoIP6Jzq+ZtBKqyH0haBmYAYP+7QBioBzGzW125NLQ84B3aqBiHqzp/CW/HsckME4iwS9TpKrUvvtjH1ZjmC1w+V9oLisFA+eyysoG8WrcVDKC3f0M3fSAegbXL/DWZDpNYyZG7WPQA+sm6Ozh7wNs6vta2cf/HYsQcO6lsH36C9KmB2U7rM0+mRT6ATddF1Wywe9bYRWnqpNzTzTqPV9ZuEaWJeUcOq1t3iNwAlpxMg6TPXL6T9roiRuuvILoUtHqAmLiuFkq5YBl6bMACQ+NSlnq1zD
 omfPE1y9
 g+U5/t1okR9L54R525a94dqQueXykukW7ajTv80QT0Q7EEWZI/s/kdB165+gLCanHur/Y3w2K2l7zEox02E7zLQzcB3PJMk9pH8U530Zgn8ucws8D6pBzWTSHTrQAeXgxe5QsnlAN8/IOKCbODy49Bl2DN4DlcnMuqrjBRFMkHuPpHacdVmUMJITyTvrG2+WcXH6015lXqj4Sswl+AJbdurogp8ZDqkg1eBjJ60fTlufkKTJrY/AF9yH7Dsn6sGB4FpCUn/owpk+O2EBpqIuPXXFBoSAyt49+04MEeB3mT6W0z8lqGi3169AnMrUCIDCxviA5yQB/s2csK2dLdhWSgm0RdeTATl7yH45ZbErGWeoiBSjTj78acGf/fS/VSp56GwLTrvP1HXRH3FTxL/x+GA+h0cB5ztt33lAYrNJIJAlNmzHLvrszOhTDFliZeFCcxw9SH/K0j794afIC+g9e6r3jDFngumx+wWfvKcEubEIq+Bn0FGYVWOjhL/yiKvQz5V+aaXNbB8tQ5sLfDm29lZ5YCYrvzltiQwBUjh5U9nzr6XxrDnviUlWiTJsPWYmwMWQuE7XE/B5M8POWdo4S/8DiXcsQsKG06K/6zRgIxWWPIhD5mUCEvfhrkfgxBlPEnG6x7D4sG/TqehAydabeTnkRf7kycvc9bOz0Aipi+7GZqKskDC8a1n5Lt0EQTEbhh//MvoAYNPAjEt6LcPvbiY7ikRTvLQcykSlkBgDay16eIvcdlhq2PWZMow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 10:59:44AM +0900, Hajime Tazaki wrote:
> Architectures lacks MMU doesn't support fork(2) syscall and only
> vfork(2) is available with limitations.  Thus, we cannot run kselftest
> on nommu architecture as is.
>
> This commit addresses this issue with the following changes:
>
> - on build stage, add -DCONFIG_NOMMU to CFLAGS when NOMMU=1 variable
>   added to the build/make argument.
> - on test run stage, avoid calling timeout command when NOMMU=1 variable
>   added to environmental variable, since timeout command uses fork
>   syscall which nommu platform doesn't support.
> - kselftest_harness.h: skip the tests if the file is include when
>   executing on NOMMU platform, as there is no fork(2) syscall.
> - replace "cd -" use as it is not available a shell supported on nommu
>   (e.g., busybox hush), use cd "$OLDDIR" instead.
> - describe the difference of nommu tests in the document.
>
> So command line to build/execute tests for nommu should be like below:
>
>  $ make ARCH=um NOMMU=1 O=build kselftest-all TARGETS=mm/nommu
>  $ make ARCH=um NOMMU=1 O=build kselftest-install TARGETS=mm/nommu
>  $ NOMMU=1 ./build/kselftest/kselftest_install/run_kselftest.sh -p \
>    -c mm/nommu
>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Brendan Jackman <brendan.jackman@linux.dev>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Cc: "Ricardo B. Marliere" <rbm@suse.com>
> Cc: linux-kselftest@vger.kernel.org
> Cc: linux-um@lists.infradead.org
> Cc: linux-mm@kvack.org
> Cc: linux-doc@vger.kernel.org
> Closes: https://sashiko.dev/#/patchset/20260813063401.1786548-1-thehajime%40gmail.com
> Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

Doesn't seem too crazy, but some nitty comments below.

>
> --
>
> rfc => v2
> - reformat ktap header, reported by Sashiko review
>
> rfc: https://lore.kernel.org/linux-mm/20260813063401.1786548-1-thehajime@gmail.com/
> ---
>  Documentation/dev-tools/kselftest.rst       | 14 ++++++++++++++
>  tools/testing/selftests/kselftest/runner.sh |  9 +++++++--
>  tools/testing/selftests/kselftest_harness.h |  4 ++++
>  tools/testing/selftests/lib.mk              |  8 ++++++++
>  4 files changed, 33 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-tools/kselftest.rst
> index 64c0ec7428a2..a65f3ebc5906 100644
> --- a/Documentation/dev-tools/kselftest.rst
> +++ b/Documentation/dev-tools/kselftest.rst
> @@ -230,6 +230,20 @@ section::
>
>  .. _tar's auto-compress: https://www.gnu.org/software/tar/manual/html_node/gzip.html#auto_002dcompress
>
> +Build and test on nommu target
> +==============================
> +
> +If you (cross-)build kselftests for nommu targets, or run tests on nommu targets, use
> +``NOMMU=1`` as a make variable/environment setting to tell build system to do the additional
> +checks.  These nommu targets may differ in several ways, such as not supporting fork(2) or
> +using musl or another libc.  Set this variable to apply the necessary build and test adjustments.
> +
> +::
> +
> +  $ make ARCH=um NOMMU=1 O=build kselftest-all TARGETS=mm/nommu  # <= build-only
> +  $ make ARCH=um NOMMU=1 O=build kselftest-install TARGETS=mm/nommu
> +  $ NOMMU=1 ./build/kselftest/kselftest_install/run_kselftest.sh -p -c mm/nommu
> +
>  Contributing new tests
>  ======================
>
> diff --git a/tools/testing/selftests/kselftest/runner.sh b/tools/testing/selftests/kselftest/runner.sh
> index 311811dc55a0..7287d8290b6c 100644
> --- a/tools/testing/selftests/kselftest/runner.sh
> +++ b/tools/testing/selftests/kselftest/runner.sh
> @@ -38,8 +38,12 @@ tap_prefix()
>
>  tap_timeout()
>  {
> +	# nommu doesn't support timeout command (missing fork(2))
> +	if [ "$NOMMU" = "1" ] ; then
> +		echo "timeout isn't supported for nommu"
> +		$1
>  	# Make sure tests will time out if utility is available.
> -	if [ -x /usr/bin/timeout ] ; then
> +	elif [ -x /usr/bin/timeout ] ; then
>  		/usr/bin/timeout --foreground "$kselftest_timeout" \
>  			/usr/bin/timeout "$kselftest_timeout" $1
>  	else
> @@ -130,6 +134,7 @@ run_one()
>  				return $KSFT_FAIL
>  			fi
>  		fi
> +		OLDDIR=$(pwd)
>  		cd `dirname $TEST` > /dev/null
>  		(((( tap_timeout "$cmd" 2>&1; echo $? >&3) |
>  			tap_prefix >&4) 3>&1) |
> @@ -147,7 +152,7 @@ run_one()
>  		*)
>  			ktap_test_fail "$TEST_HDR_MSG # exit=$rc";;
>  		esac
> -		cd - >/dev/null
> +		cd "$OLDDIR" >/dev/null

Hmm, why are you changing this bit?

>  	fi
>
>  	return $rc
> diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
> index 261e4df94d9d..0d05946a5e7a 100644
> --- a/tools/testing/selftests/kselftest_harness.h
> +++ b/tools/testing/selftests/kselftest_harness.h
> @@ -1274,6 +1274,10 @@ static int test_harness_run(int argc, char **argv)
>  	unsigned int count = 0;
>  	unsigned int pass_count = 0;
>
> +#ifdef CONFIG_NOMMU

Let's not prefix with CONFIG_ :) I think this is pretty confusing vs. the kernel
CONFIG_xxx flags, esp. as this obviously inverts CONFIG_MMU.

maybe just 'NOMMU'?

> +	ksft_print_header();
> +	ksft_exit_skip("kselftest harness requires fork(2), unavailable on NOMMU\n");
> +#endif /* CONFIG_NOMMU */
>  	ret = test_harness_argv_check(argc, argv);
>  	if (ret != KSFT_PASS)
>  		return ret;
> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index f02cc8a2e4ae..fdb895967768 100644
> --- a/tools/testing/selftests/lib.mk
> +++ b/tools/testing/selftests/lib.mk
> @@ -97,6 +97,14 @@ TEST_GEN_PROGS := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS))
>  TEST_GEN_PROGS_EXTENDED := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_PROGS_EXTENDED))
>  TEST_GEN_FILES := $(patsubst %,$(OUTPUT)/%,$(TEST_GEN_FILES))
>
> +# detect if users request NOMMU build or not
> +# User can set NOMMU to 1 to build/test for NOMMU platforms
> +NOMMU ?= 0
> +ifeq ($(NOMMU),1)
> +CFLAGS += -DCONFIG_NOMMU
> +export NOMMU
> +endif
> +

I wonder if this could be put into testing/selftests/nommu/something.mk? Though
I guess would have to be included for all builds to account for nommu trying to
build any kind of tests.


>  all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) \
>  	$(if $(TEST_GEN_MODS_DIR),gen_mods_dir)
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

