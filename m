Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12AF7C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 12:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28676B06A5; Fri, 14 Aug 2026 08:51:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F007D6B06A9; Fri, 14 Aug 2026 08:51:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17246B06AC; Fri, 14 Aug 2026 08:51:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B96456B06A5
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:51:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 47D0A1603F7
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:51:11 +0000 (UTC)
X-FDA: 85099860342.26.A263CD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id AF4D81A0006
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:51:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SRUKVShK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786711869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yp8F8xjPNWmB+RDW4xJTkvaQ+IS/CNpnMALNCGQ+iGw=;
	b=dCCb+1pFgOn0JXn+UyiHb9TgtBXVKxiOFMrOAQt0nTa1+MYmmXs1ox/SWDYadd6rhwmJq+
	5cimm3Vojor9BNdbaCegIOZ0xDNKZBa3VP1g299butj8OyeyahOlFPFnM6+wYVZSOp/R9X
	V8VCGnL/F10JlVy5oLhlX1dPoiOfBU0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SRUKVShK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786711869;
	b=2Oo9Uyf+2uloRIsJohZbFqPbPLZi1a0tP5zlZdd9J6ZKA+3pIxYtzw+3zLz9i2WSclP2MR
	DfyTIExapVySegNV+pduEkcWx3u+98uDRNjJyW/tU8FTxBMm6kLAQSqe89GuZn79IbDvBu
	f7EGqOGKjaUEBaWIANQ2ONTMza/w9Sc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4507A60120;
	Fri, 14 Aug 2026 12:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F271F000E9;
	Fri, 14 Aug 2026 12:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786711869;
	bh=Yp8F8xjPNWmB+RDW4xJTkvaQ+IS/CNpnMALNCGQ+iGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SRUKVShK72r41Ws8g4FF6a9lZMwbBJEIk0HbBDqZ0N+STbG4WW2td6mK2zyOx+ZqJ
	 Mw4+Bw7svi7x4saObAoGV+T1A1eOyOzz4ItVk6Pxox+vyGuLwO6R/MKN0TZke5UUuj
	 OJfMai0xJ4YKMTOwwhg8/vCqnk5yMPAB10U5IibX7bXDcZAtU86RXSU/6vsZBy+c/a
	 na3v406UmuTXQzQt08BjZkitTPYP2X2lKoC/Z6y35BmGL68aGNnN424sAHWB9gMsZ8
	 GQUgaMLvNK+b55nEUzFjwjOsnHuv3fr5UZtblxsxIl5tblc20bQJg7RzIDCo2L7YKW
	 YRcsLTygUrLLg==
Date: Fri, 14 Aug 2026 13:50:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, geert@linux-m68k.org, daniel@thingy.jp, 
	Shuah Khan <shuah@kernel.org>, Kees Cook <kees@kernel.org>, 
	Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Mark Brown <broonie@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Hangbin Liu <liuhangbin@gmail.com>, 
	"Ricardo B. Marliere" <rbm@suse.com>, linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org
Subject: Re: [RFC PATCH 5/6] selftests: run tests on nommu architecture
Message-ID: <an8MlE22U3586R42@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-6-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813063401.1786548-6-thehajime@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: AF4D81A0006
X-Rspamd-Server: rspam07
X-Stat-Signature: e16ktmwr8bhdhqipfms4woknicct3jew
X-HE-Tag: 1786711869-230487
X-HE-Meta: U2FsdGVkX185M23qSYMi3b30chGQCK04CMtxvhxczrwzUKtxr1zp7b4wCtg0t9dqBg5+TsFXXp73YfwAXAELbRHjqpzzs3B2rhznZReRaNSJwStpjjbeW72vobu/67GdL7BwWnhlj/Wx5fa0yZydAU04kJGiL9brpk6h1OeCFZ2ZoXB2umBho6ikrSyhIsp+3nyhLW6LQTCZZVRA4Qae8L2US/Ln0KJFKVrVZbTmkLfBxMrCPKw3npjGbCa2Sp40+7xB1m5SiwdIvzDX+ss2HnpP0/We+yLqWjDwEkKGl6BdMb5b3xl9bRN1dgmoCwMWlTbRML04ptixlYMw9ZN8pT38qgl3SR30Z0Til4dPY/OrxD+SMoEHyKmbeAruFvGCv2Uldts8w/rP4dTrn+jD31bUeHt26nnerizl+05+dmK4KPCRl6vf0Xg3O2+c8/i4smnkeVWLcwYN2x55QAk+IkhOn2PxiXDEgSHLQ9SQywxiZx3Ph4tZZ6YwR03anUlvNMlXAEyaqsXVh0ViyAgbp40/CtP7Vq2WhTR9peR0/iIRvLEgfEvtKR3w6uTgXRtgqwzhE1mgN9q+JZe0S7pKfv1cwGfFvqhmvkh9Lk4bZEBDpvLplEAY34oJXYBp7fYIdFWjSX8lb+SNkEG2ehHFpiU7zKKKTOIbDOMfdMSCiABU/CEyCx9ZWXA3LNTjjtptXi7SOTXEKnqH4S+1fmgxoF7lg7EuS9lyPRc7+cVLMoQNBtaewlaMgHHqSLdd6ychYpP+lkHxrAdjg1u/CVcT+fqwzxMs1oip/bvwWOsdAao3vheLr49UlYxkjKTLlFn+v8cktKkgf4SxogM1nX5mmyyYGaXiXJYZVOcHmbgTLMz+oxsmPsj3W2UJHBZ68tr6IZZLTaKseWU4xNE9tokblc+ghcUB4hzMbyw6pK8V2if8JZ715MPP7IUydhLHJUfxwqBGZ/vCbmkG+7xEPL8
 obG5m9eP
 HhRAsf9wtWphetx8H8E79EJ+X2WOqNvv3ZiMOU55LbSfVfQH8YdZXMLKexozxamHcrayOxk/RixtcRK1+OjDpqXo6gpE5zPWSQFpJ9797aVCW1svHamZuWpMZ/+wV8i5SJJ3Aln3w9k6GcnMFrFSlaCecPdTnNMhuWOcWiYc2SP9pQ0ls+3ZYvVFl223f6gNn3qjK3TOxUDPPgzg4dSU7gvUu+nnCBZEfOwg/24fHwXWke7C2zEYeN3fANEd6tPuLgygSXVLJBCM05wjSpodGwbuxWWY25jqaTfiGC+sqM1tjlQ5SIrWyINBVzZvQDHWFRqahY3ULpO3drlU3zq/oJNKckXl3/0Q+WC5mr4jFRLP1h8lGBRiykjAzZ6dA6etCHve2RtLIxpDW0Hi/5PIh+Ud6OmToam1/gPe2s5r/0W9ATCcsKPM5ub1FU6SU6tzpEJTakgtwQCmPsUQBbf/B8npOh+4c7kdIESOUDmu747FoJZN9EqyfW1qPuUKddy+1UDalA1pgUzxMfbK1vldxUteKoExeNDfqdf8/VrdoZB7lDooI/CcteDokhhk7O6ZCDai5dNgzjOODiwAZbEn++5+lA33sbXRKJ0P0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 03:34:00PM +0900, Hajime Tazaki wrote:
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
> - kselftest_harness.h warns if the file is include when building for
>   NOMMU platform, as there is no fork(2) syscall.
> - replace "cd -" use as it is not available a shell supported on nommu
>   (e.g., busybox hush), use cd "$OLDDIR" instead.
> - describe the difference of nommu tests in the document.
>
> So command line to build/execute tests for nommu should be like below:
>
>  $ make ARCH=um NOMMU=1 O=build kselftest
>  $ make ARCH=um NOMMU=1 -C tools/testing/selftests/mm run_tests
>  $ NOMMU=1 /tmp/kselftest_install/run_kselftest.sh -s -c mm
>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Will Drewry <wad@chromium.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Brendan Jackman <jackmanb@google.com>
> Cc: Hangbin Liu <liuhangbin@gmail.com>
> Cc: "Ricardo B. Marliere" <rbm@suse.com>
> Cc: linux-kselftest@vger.kernel.org
> Cc: linux-um@lists.infradead.org
> Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

Not really loving this as mentioned on the cover letter.

I'm sympathetic to making things work if it's not invasive, but now you've
essentially asking new test authors be aware of this to some degree.

And making the harness - which is the defacto way of writing tests - now
simply not work there is a bit crazy.

I'd ideally like to see _all_ tests use the harness.

Also a bunch of the tests already do forking as part of the testing:

$ cd tools/testing/selftests/mm
$ rg -l "fork\(" | wc -l
17

So at this point you're not really running much of the selftests at all,
and are only happening to run those that don't do the very basic stuff
nommu can't deal with.

I think an audit of existing tests to figure out what works with nommu vs
what doesn't is really unreasonable again, given nobody tests or seemingly
uses these arches.

So this patch might beget more nommu carve outs and exceptions and
therefore nommu workload and maintenance, which isn't really sustainable.

I know I complain about lack of testing on nommu, but at the same time I
don't think running arbitrary tests that happen to work on it and who knows
if they are valid asserts anyway really fixes things.

And given nobody really is doing testing, it's not really a great RoI
here...

...OTOH I suppose it's a minimal change we can largely ignore as long as
this doesn't lead to additional work/auditing from anybody but nommu
enthusiasts.

But I'm just not sure that will be the case :(

(I'm amazed we support a mode in linux that can't fork() in 2026 :)


> ---
>  Documentation/dev-tools/kselftest.rst       | 12 ++++++++++++
>  tools/testing/selftests/kselftest/runner.sh |  9 +++++++--
>  tools/testing/selftests/kselftest_harness.h |  4 ++++
>  tools/testing/selftests/lib.mk              |  8 ++++++++
>  4 files changed, 31 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/dev-tools/kselftest.rst b/Documentation/dev-tools/kselftest.rst
> index 64c0ec7428a2..800b2b688aff 100644
> --- a/Documentation/dev-tools/kselftest.rst
> +++ b/Documentation/dev-tools/kselftest.rst
> @@ -230,6 +230,18 @@ section::
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
> +  $ make ARCH=um NOMMU=1 O=build kselftest
> +  $ make ARCH=um NOMMU=1 -C tools/testing/selftests/mm run_tests
> +  $ NOMMU=1 /tmp/kselftest_install/run_kselftest.sh -s -c mm
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
>  	fi
>
>  	return $rc
> diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
> index 261e4df94d9d..8eee7b14f824 100644
> --- a/tools/testing/selftests/kselftest_harness.h
> +++ b/tools/testing/selftests/kselftest_harness.h
> @@ -1274,6 +1274,10 @@ static int test_harness_run(int argc, char **argv)
>  	unsigned int count = 0;
>  	unsigned int pass_count = 0;
>
> +#ifdef CONFIG_NOMMU
> +	ksft_print_msg("harness test doesn't support on NOMMU architecture (no fork(2)).\n");
> +	return KSFT_SKIP;
> +#endif /* CONFIG_NOMMU */
>  	ret = test_harness_argv_check(argc, argv);
>  	if (ret != KSFT_PASS)
>  		return ret;
> diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
> index 2cc819006424..4734b5ce613f 100644
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
>  all: $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED) $(TEST_GEN_FILES) \
>  	$(if $(TEST_GEN_MODS_DIR),gen_mods_dir)
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

