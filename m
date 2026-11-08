Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FEFF606A31D
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 02:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rf2twODo
Received: by kanga.kvack.org (Postfix)
	id 42A5B6B05B3; Sat,  7 Nov 2026 21:41:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402006B05B4; Sat,  7 Nov 2026 21:41:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33F076B05B5; Sat,  7 Nov 2026 21:41:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3CA86B05B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:41:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 765011C2B63
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:41:38 +0000 (UTC)
X-FDA: 85410401076.06.A9BD3BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id CD5D240002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:41:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rf2twODo;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794105696;
	b=R7XX/tBNu6DJ/uRtxrdSNuOmUXmdrZN/rRMgW2yNPxltf7SMIQX3vwJNcq90yyNu4qOPjd
	U0OvExHcuJh/BRibIW1dHae/DSxHlNjEh1AYiXGyQA4s7eetc9Yij0DxWIM6OkeCXGDLdr
	w8FzYICBBzBzCLR+UO3EmAJapdQ9oyM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rf2twODo;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794105696;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TznJpNICz/LIXq1AT7iwPZHDzdZFY1wF9Y26YwnLGGE=;
	b=5WbxOZcWpJKBaJoKAIItz8JqC7UB0+uOlzDvelh3EQRdxQw/2n/PfB5SOH0GkA5CaY6jjw
	TqgYP90HEg+OphY697czz0rh19IabYlZqokedYUlM5mfnba3E/vYTiyLTTod8ouKbj/Ver
	i4vYqjdG6npuIQBYHE+DT4CWmBHs8r8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6186C6116E;
	Sun,  8 Nov 2026 02:41:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A45D1F008A1;
	Sun,  8 Nov 2026 02:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794105696;
	bh=TznJpNICz/LIXq1AT7iwPZHDzdZFY1wF9Y26YwnLGGE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rf2twODouX7b9MwgNziWRPHPVGPaBqamIg5vsbGkehiRUuNMRwe18X9F6lSBgvLhV
	 7SnfBuLHCMJ1acCPr7WyNUC3P6d+sXvY1ssV/avNusvmcmNYpnxo89Lq14uAOIjuiD
	 YUiQ6WWYxG0KNCtEg4GQFHOSEvsVHrH+46UFlB7nE5pGo15723jhpJVDGKPt1waZ/3
	 E1HbQH3Wo93RxFa05adIPj63OZ90cNTGsJH+cTezTwcTtkcjgLNa3FoSBNVU1w2Vjs
	 IenWdKgsZhnmAhc/wW9a18rCoNguzElSKq6AZRvio49KdOZsXCR8LnF2q4p47D3V87
	 qQfhF42dtx57g==
Message-ID: <sashiko-outbox-203523@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 2/8] riscv: Add breakpoint and watchpoint test for
 riscv
Reply-To: sashiko-reviews@lists.linux.dev
To: "Himanshu Chauhan" <himanshu.chauhan@oss.qualcomm.com>, "Paul Walmsley" <pjw@kernel.org>, "Palmer
 Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>
Cc: "Alexandre Ghiti" <alex@ghiti.fr>, "Jesse Taube" <jtaubepe@redhat.com>, "Oleg
 Nesterov" <oleg@redhat.com>, "Kees Cook" <kees@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Arnaldo Carvalho de Melo" <acme@kernel.org>, "Namhyung
 Kim" <namhyung@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Alexander
 Shishkin" <alexander.shishkin@linux.intel.com>, "Jiri Olsa" <jolsa@kernel.org>, "Ian
 Rogers" <irogers@google.com>, "Adrian Hunter" <adrian.hunter@intel.com>, "James
 Clark" <james.clark@linaro.org>, "Shuah Khan" <shuah@kernel.org>, linux-mm@kvack.org, linux-perf-users@vger.kernel.org
In-Reply-To: <20261107023917.40606-3-himanshu.chauhan@oss.qualcomm.com>
References: <20261107023917.40606-1-himanshu.chauhan@oss.qualcomm.com>
 <20261107023917.40606-3-himanshu.chauhan@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 02:41:34 +0000
X-Stat-Signature: 4hpqkdbgd76bbau1n34kgm48o53rhhd8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CD5D240002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794105696-958849
X-HE-Meta: U2FsdGVkX19g69ybwei6xfx1OsTljfIjAwKMFxjNJ/Bq6yA4ewmiVDigzEfodnDHPRJPXx52yqsHGqzbR1E7yZiRzOJ+fvheKrZdEQ7qLkgu615z6SP9kkJAwBBicseA2FGKfZEFvR8Viwy17i4xrxxTW2ajL7Ghv9hOREHGILZie0xB6f8h8Tcinau6XIQMm12Pdwine7jVwgE5K0m2roSYp/9yU+vnzTE9PZRvOKJN9bW1OuMZi+Up4WjULWsqo1AxzE4X0LGACinULrIkQ1l/3c2c7gGuL7HotiAo5lkXwQ0gssQo+ftrcWFtoAHwcMLC2ObKnriaQDr0xUKn/ulbWrpVPJSvK2b8FfwEapTuW+E7M1hp4P0iEj6QZ81fIHjuecoZsOlQKirgZYAdKUIM5GvgrrM6XcLsbbE3xOH0JJjVkQJ67xuw1yErwGGbMsUgBd/Uu4owZWWz36uwf3c01bULkVahax4oYBluUNGRTIcaID9cTySjbSJPS5tUGlPXPxfcZEklM0hOdlrd1pkiFg16ROXO8Nrv8UVTnrWnq5EiMThMQVL6AkLaqsLA68zJ/iWri8+X4lypRSI18hO6BudCcZ4zTg2ShNeumwHDrPkTMyLiWIzMA89woOjiEW1X/gO4YOURZ2UvQ0BFUut2QlR2NBDYf9nalDNI7OVOGcJsFHho7F/Z9aUeR6c7xQwh+jB65ctgWKy5swjhQWEVQXpA2PUH/fgK7cDint64aKdYH27fgLM4dRF6qKcqwhJkvNXWabbxVE14Aneqy7IptCmkHWWSTonQ2QNAdON/9MzLXtFsdr1YOsquPzSdIUMzwT6Q4qNW+Cd1A3Om8Ek8YvW1hi21pYFMYJRaUbBDECGyMrKAbt2i2RPzd/F26zE8/BVXqfjbC7ZaF2bbPrzI4MemyF3zMGvHVnXPv2u/gQhm03tANoFcd8WQMCvYhFNA1PouMbfLKlkDC/m
 MfGzgUQC
 4eXwZUvIWIxDZCJmkZllE5hkMc5+OxrYP9jLcGheuMeVIMaIZYcsGbIAoLtbUvKWlhtqM5Oq4YIZuK8P6ZzqNavx4ObQ7NwoD0FtreSDvEGcCmpTFZs/YEpqmA1ot7VtHyfb54SGIArNPpiVyLueYez4PUxu5vYkQRIFZVkPJf14+ZEH+x2pE9iqvS6EOZvFnBRhYMFy4dNqRZRO/kpWkSsnIP9sMpughVOsUnKTFY4rbl3tjpWAbABr8O4g930zpyyTnDki8kZaIvfpaWQPRgqluHBHRzwKmqnKxwSUqY/iuyKxNVzl+aO1Kq1hq/LxrMHspHSTOpE5ESpj5oCbtuUk7M4zCJQRHeftKagXczsW0qc82+q4yN5HeImADHgnCHP2XvUYv4geKOXv7LvoBlD4PoPNKocPVYA0JpVkSXzXny4tHCadUj3ssrqvOGDX8W/M9BRhL2A5QMxRUYyc9I32JOUf0qs/iCUP4SOx545K0mXKak6W42wRrqrukl3QbkMGeguxGwDlcMD4LH8fP4Z/QTPT0Zs17jQQbY5veCmf+34CL+vVvtF6MR4lvaAp5M+xAxYirWonglfkGlKXKpCYyBZZueGfCA4PyWSchB/p/ja65NICVawCaZNh/rHJuImxK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 7 potential
issues to consider:
- [Medium] selftests/breakpoints: missing kselftest API and skip logic
  in setup_bp()
- [Medium] selftests/breakpoints: premature close(gfd) and dead store in
  trigger_wp()
- [Medium] selftests/breakpoints: non-volatile test_data in trigger_wp()
  can be optimized out
- [Low] selftests/breakpoints: forced -static CFLAGS and missing
  .gitignore entry
- [Low] selftests/breakpoints: commit message claims ptrace usage and
  .gitignore misses binary
- [Low] selftests/breakpoints: non-portable glibc macro
  __attribute_noinline__ in test_func()
- [Low] selftests/breakpoints: unhandled EINTR in wait_event()
  sem_timedwait()
--

commit 1561777f5a1538f9c1adcbe99231ade440297bf1
Author: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>

riscv: Add breakpoint and watchpoint test for riscv

This commit adds a RISC-V kselftest for hardware execute breakpoints and
write watchpoints using perf_event_open() and asynchronous signal delivery.

> Add self test for riscv architecture. It uses ptrace to ptrace framework
> to set/unset break/watchpoint and uses signals to check triggers.

[Severity: Low]
As reported by Jesse Taube on v5 [1], does this test use the perf_event_ope=
n()
interface rather than ptrace?  In addition, "ptrace to ptrace" is a typo in
this sentence, and the ptrace-based tests are only added later in commit
"selftests/breakpoints: extend riscv test for ptrace hw break/watchpoints".
Also, breakpoint_test_riscv is not added to
tools/testing/selftests/breakpoints/.gitignore.

> diff --git a/tools/testing/selftests/breakpoints/Makefile b/tools/testing=
/selftests/breakpoints/Makefile
> index 0b8f5acf7c78f..1f28f50e8f85f 100644
> --- a/tools/testing/selftests/breakpoints/Makefile
> +++ b/tools/testing/selftests/breakpoints/Makefile
> @@ -12,5 +12,13 @@ ifneq (,$(filter $(ARCH),aarch64 arm64))
>  TEST_GEN_PROGS +=3D breakpoint_test_arm64
>  endif
> =20
> +ifneq (,$(filter $(ARCH),riscv riscv64))
> +TEST_GEN_PROGS +=3D breakpoint_test_riscv
> +endif
> +
>  include ../lib.mk
> =20
> +ifneq (,$(filter $(ARCH),riscv riscv64))
> +$(OUTPUT)/breakpoint_test_riscv: CFLAGS +=3D -static $(KHDR_INCLUDES)
> +endif
> +

[Severity: Low]
Will forcing -static without -pthread fail to link on build environments
without static libc/libpthread archives or where sem_init(), sem_post(), and
sem_timedwait() require explicit pthread linkage?  Also, the $(ARCH) filter
omits riscv32 on 32-bit RISC-V hosts, and tools/testing/selftests/breakpoin=
ts/.gitignore
is not updated with breakpoint_test_riscv.  In breakpoint_test_riscv.c,
ib_mtx, wp_mtx, and setup_bp() can be static, and bp_triggered and
wp_triggered should be volatile sig_atomic_t since they are updated in sign=
al
handlers.

> diff --git a/tools/testing/selftests/breakpoints/breakpoint_test_riscv.c =
b/tools/testing/selftests/breakpoints/breakpoint_test_riscv.c
> new file mode 100644
> index 0000000000000..a8a94a788142d
> --- /dev/null
> +++ b/tools/testing/selftests/breakpoints/breakpoint_test_riscv.c

[ ... ]

> +int setup_bp(bool is_x, void *addr, int sig)
> +{
> +	struct perf_event_attr pe;
> +	int fd;

[ ... ]

> +	fd =3D syscall(SYS_perf_event_open, &pe, 0, -1, -1, 0);
> +	if (fd < 0) {
> +		printf("Failed to open event: %llx\n", pe.config);
> +		return -1;
> +	}
> +
> +	fcntl(fd, F_SETFL, O_RDWR | O_NONBLOCK | O_ASYNC);
> +	fcntl(fd, F_SETSIG, sig);
> +	fcntl(fd, F_SETOWN, getpid());
> +
> +	ioctl(fd, PERF_EVENT_IOC_RESET, 0);
> +
> +	return fd;
> +}

[Severity: Medium]
Should setup_bp() and main() use the kselftest.h helpers and skip via
ksft_exit_skip() when hardware breakpoints are unsupported or restricted?
On RISC-V platforms without SBI_EXT_DBTR / Sdtrig support or when perf even=
ts
are disabled or restricted, syscall(SYS_perf_event_open, ...) fails and cau=
ses
main() to fail the test run with exit code 255 instead of skipping, while
printing pe.config (which is always 0) instead of errno.  Also, the fcntl()
and ioctl() return values are unchecked, and in main(), if (bp_triggered) a=
nd
if (wp_triggered) only guard printf() calls, so main() still returns 0 if
wait_event() succeeds while either counter is 0.

[ ... ]

> +static __attribute_noinline__ void test_func(void)
> +{
> +	test_func_sink++;
> +	__asm__ __volatile__("" : : "g" (test_func_sink));
> +}

[Severity: Low]
Will __attribute_noinline__ fail to compile against non-glibc C libraries
such as musl?  __attribute_noinline__ is a glibc <sys/cdefs.h> macro; using
__attribute__((noinline)) avoids breaking musl builds.

> +
> +static int trigger_bp(void)
> +{

[ ... ]

> +	ioctl(gfd, PERF_EVENT_IOC_ENABLE, 0);
> +
> +	test_func();
> +
> +	ioctl(gfd, PERF_EVENT_IOC_DISABLE, 0);
> +
> +	close(gfd);
> +
> +	return 0;
> +}

[Severity: Medium]
Does closing gfd here before main() calls wait_event(&ib_mtx, "Breakpoint")
race with asynchronous signal delivery?

Because perf event O_ASYNC signals are queued via irq_work, if signal deliv=
ery
is delayed past test_func(), close(gfd) tears down the perf event and its
fasync registration before the signal is sent, or races with sig_handler_bp=
()
calling ioctl(gfd, PERF_EVENT_IOC_DISABLE, 0) on a closed descriptor.  Also,
sig_handler_bp() and sig_handler_wp() call printf(), which is not
async-signal-safe, and trigger_wp() never closes gfd before returning (note
that commit "selftests/breakpoints: extend riscv test for ptrace hw
break/watchpoints" later in the series adds close(gfd) to trigger_wp(),
though still before wait_event()).

> +
> +static int trigger_wp(void)
> +{
> +	struct sigaction sa;
> +	unsigned long test_data;

[ ... ]

> +	gfd =3D setup_bp(0, &test_data, SIGUSR1);
> +
> +	if (gfd < 0) {
> +		printf("Failed to setup watchpoint\n");
> +		return -1;
> +	}
> +
> +	ioctl(gfd, PERF_EVENT_IOC_ENABLE, 0);
> +	test_data =3D 0xdeadbeef;
> +	ioctl(gfd, PERF_EVENT_IOC_DISABLE, 0);
> +
> +	return 0;
> +}

[Severity: Medium]
Can the compiler eliminate the store to test_data as a dead store?
test_data is a non-volatile local variable that is never read before
trigger_wp() returns, so under -O2 the store between the enable and disable
ioctl() calls can be optimized away and the watchpoint will never fire.
Qualifying test_data as volatile prevents this, and gfd also remains open on
the stack address &test_data when trigger_wp() returns in this patch
(close(gfd) is added later in commit "selftests/breakpoints: extend riscv
test for ptrace hw break/watchpoints").

> +
> +static int wait_event(sem_t *sem, const char *name)
> +{

[ ... ]

> +	ts.tv_sec +=3D wait_timeout_sec;
> +	if (!sem_timedwait(sem, &ts))
> +		return 0;
> +
> +	if (errno =3D=3D ETIMEDOUT)
> +		printf("%s: Timed out waiting for event\n", name);
> +	else
> +		printf("%s: sem_timedwait() failed with %d\n", name, errno);
> +
> +	return -1;
> +}

[Severity: Low]
Does sem_timedwait() fail with EINTR if SIGIO or SIGUSR1 is delivered while
wait_event() is blocked?  POSIX sem_timedwait() does not automatically rest=
art
when interrupted by a signal handler, so when the signal arrives during the
wait and the handler posts the semaphore, sem_timedwait() returns -1 with
errno =3D=3D EINTR unless retried in a loop.

[1] https://lore.kernel.org/r/CADRr4bdFr+cu-1L0cSAJUwN-ehHiyb=3D4WHmwh3xS2s=
6q33ZCVw@mail.gmail.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107023917.4060=
6-1-himanshu.chauhan@oss.qualcomm.com?part=3D2

