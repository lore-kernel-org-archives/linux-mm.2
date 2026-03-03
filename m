Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61ADAE67A85
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 07:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1826B0005; Tue,  3 Mar 2026 02:09:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95F5F6B0088; Tue,  3 Mar 2026 02:09:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840EE6B0089; Tue,  3 Mar 2026 02:09:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 73FEE6B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:09:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 336A114063E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:09:39 +0000 (UTC)
X-FDA: 84503876478.01.D088313
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf24.hostedemail.com (Postfix) with ESMTP id 58C85180003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:09:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=blV+KjoE;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf24.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772521777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3drZ6aKuDCE8Tg06tx3yu597BYxHvLnyKlxduif6fYU=;
	b=6QcsJ8OMmBMEKA1a3FAmPS3/ll4HcJrrq//j5D770Tqn9GPjICuIFLSqorVHVA0wQMHSEa
	+a3bNkH9yPPEoDW2SRscduLEooCuXMG9RtQaXNYQiXat0FRBC+9rft1ejNXVaXiurZvNal
	yLnz1zmXqNhLRRTyy0FfkhC30Rbb//c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=blV+KjoE;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf24.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772521777; a=rsa-sha256;
	cv=none;
	b=EjPbbVz7stuzPk2WI78I+Lfn3KiakVW1MSnzA/+UJ2M1zxVDNN2pIsouQMD16Fu47/eAfE
	75RQLxHgPyCQBWP6ij4i+zKvkMgZWU8GGkH7j8+MyAKi+NneTfC4+rYAxdCx+RmXTnjc4c
	VyiCDbBg6317meZJ9DaF7WTIx2rsJyQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1772521774;
	bh=S2hyWDTjtOZ6PFcrmL53uq+Ut9lQFYrRfbPfG5BD0tQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=blV+KjoEK4/magl2I67qFyGBhkUPrpQ1V2CP+03cTLIzwvvSEKOBKBwhp92lHI4WQ
	 3wzn3soX95MZMFtZ5UZTbqMIvRBNNlIckOppgdpRTnb5vCEbBXMY03cRdWmYzgtMce
	 sRxm1O2lT9VgEGA4onE7yDBTRqqpOd8kXgeVbCw0=
Date: Tue, 3 Mar 2026 08:09:33 +0100
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Jordan Richards <jordanrichards@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, Willy Tarreau <w@1wt.eu>, Jason Miu <jasonmiu@google.com>, 
	David Matlack <dmatlack@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 1/2] tools/nolibc: add ftruncate()
Message-ID: <c65fdf06-2f69-4c81-be21-a14229eaf1b6@t-8ch.de>
References: <20260303010039.2969125-1-jordanrichards@google.com>
 <20260303010039.2969125-2-jordanrichards@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303010039.2969125-2-jordanrichards@google.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 58C85180003
X-Stat-Signature: rwdjyz51shi8w656fe8mxkgj8p15st3t
X-Rspam-User: 
X-HE-Tag: 1772521777-687561
X-HE-Meta: U2FsdGVkX194GV5dwIYTzRGijVKg8hnqt5BL5YgcB0HlgIHDrKiQY3OcWIk7CpCHXfByPk8zQFEquBJxUIOX7qHZ+7i160Bf2cFZ//Qe9du3QPLKkUHuNma+46eikIvSiO9W01I3TVZWcSGsX9XxgtyBzZUGP9momsOrbtw83PeSFn5Y0TA4UW4ykYiUuPXUuROJNZ/bx5fC3ywwkX18rOAzNOD8eTntkH+9z2H28yg+9AW4RcDOFzh4rU5zKIIwcNXsFsXWgcPCFKNxLnu5ycawROd8jcnGiwc+OM61Iv5pMNid1J4/Vd9xWZyAGANsc4KE+dJ3FT0cGx5yweXKapOWpW2SvRk574Es0hwtDVQ9btIVMI3xuImqPAltybk8oYMA+47NkKsp9/rhWP+1TQhIKv4pYk5Pkh7CAsgWRIWFkVdrr05cUPhiJJmdmBoWYUpndoAAy7Yink22gpUtndbXW9f5kPi9LHhDZQXtfe5jNppCwQXdgZM2IYrQHu79t5wEszbjKYzkDQ2kV5r+ytxwq02Gn432DY32isOQbIg6au5fbsiaY3QQL/76ShC2yCrpt+THf54kDeu7YdmtIvyZpQNJpKfjGqAAp2IXhITxB0f4Zdd0LzC3AcQ0F7g6QT5UMtw4a3IVph/FX/K5Y56dTDjdguqq0RDgwvCg0jyqjGkuYnGLgjtbO5+9OscvMlnsIak+Kj6O7/gWXn4jEsMKwlpfJn4foVDFSZF2plzbCOBmRpfWTYX1L0DyeESArrlEKqwD1prPNIQ+5PkZZroLdW7pkWcHPQFbDwjPktNIutvtf9Xv1rpc3rvP3UuLdrpVWBRtfXzqYmjbsuPT6EwqLRTzJKMPwfhjWcz4iAG3OsMPC333ylBr7jJ8KB5yOvBGHmHeFFk+m3yALNcWGQzV2DoHT6dUAJ3e6ZM204wtuxXyvAW5KheB4DY6rOO9LSwP1+dLh63LSKBdTIn
 JDJScKO1
 Jai0Phj4v2fxkUciBm/zMwfQ0Rk6xABJrFjILCgi5YRJjLcgAQ+EGq+89eVUimNccVlHviAUk3Gdu+e3t3tEzW66LVJytvYo3k4JmDT+x+5CdbgRFZRnfUxLoq4JinVGOMN+Mxy2sVRj5G0pJOndlVOTQT0tJX7Uaa57T35UJyF/seMsXqkrb3vUq/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jordan,

On 2026-03-03 01:00:38+0000, Jordan Richards wrote:
> On architectures with 32-bit longs, call the compat syscall
> __NR_ftruncate64. As off_t is 64-bit it must be split into 2 registers.
> Unlike llseek() which passes the high and low parts in explicitly named
> arguments, the order here is endian independent.
> 
> Some architectures (arm, mips, ppc) require this pair of registers to
> be aligned to an even register, so add custom sys_ftruncate64 wrappers
> for those.
> 
> A test case for ftruncate is added which validates negative length or
> invalid fd return the appropriate error, and checks the length is
> correct on success.

Thanks, this all looks good in general.

In nolibc-next we renamed all the my_syscall*() functions to
__nolibc_syscall*(), merging this patch through the liveupdate tree
will lead to semantic conflicts.

I see different ways to handle this:
* An an immutable branch to merge into the liveupdate tree
* Split up the series
  * Use raw syscall(__NR_ftruncate) in the liveupdate
    selftests, as it is sufficient for that.
  * Merge the nolibc bits through the nolibc tree.
  * Next cycle, switch to proper nolibc ftruncate().
  * Let Linus handle the conflict when merging the tree.

There are some nitpicks inline, but we can also fix those up when
applying the patch.

> Signed-off-by: Jordan Richards <jordanrichards@google.com>
> ---
>  tools/include/nolibc/arch-arm.h              | 11 +++++
>  tools/include/nolibc/arch-mips.h             | 11 +++++
>  tools/include/nolibc/arch-powerpc.h          | 11 +++++
>  tools/include/nolibc/unistd.h                | 35 ++++++++++++++
>  tools/testing/selftests/nolibc/nolibc-test.c | 51 ++++++++++++++++++++
>  5 files changed, 119 insertions(+)
> 
> diff --git a/tools/include/nolibc/arch-arm.h b/tools/include/nolibc/arch-arm.h
> index 251c42579028..ed65fb674e61 100644
> --- a/tools/include/nolibc/arch-arm.h
> +++ b/tools/include/nolibc/arch-arm.h
> @@ -6,9 +6,11 @@
>  
>  #ifndef _NOLIBC_ARCH_ARM_H
>  #define _NOLIBC_ARCH_ARM_H

Nit: keep an empty line after the include guards.

> +#include <linux/unistd.h>
>  #include "compiler.h"
>  #include "crt.h"
> +#include "std.h"
>  
>  /* Syscalls for ARM in ARM or Thumb modes :
>   *   - registers are 32-bit
> @@ -196,4 +198,13 @@ void __attribute__((weak, noreturn)) __nolibc_entrypoint __no_stack_protector _s
>  }
>  #endif /* NOLIBC_NO_RUNTIME */
>  
> +#ifdef __NR_ftruncate64

Should be unnecessary.

> +static __attribute__((unused))
> +int sys_ftruncate64(int fd, uint32_t length0, uint32_t length1)
> +{
> +	return my_syscall4(__NR_ftruncate64, fd, 0, length0, length1);
> +}
> +#define sys_ftruncate64 sys_ftruncate64
> +#endif
> +
>  #endif /* _NOLIBC_ARCH_ARM_H */
> diff --git a/tools/include/nolibc/arch-mips.h b/tools/include/nolibc/arch-mips.h
> index a72506ceec6b..26d044004ec6 100644
> --- a/tools/include/nolibc/arch-mips.h
> +++ b/tools/include/nolibc/arch-mips.h
> @@ -6,9 +6,11 @@
>  
>  #ifndef _NOLIBC_ARCH_MIPS_H
>  #define _NOLIBC_ARCH_MIPS_H

Also an empty line.

> +#include <linux/unistd.h>
>  #include "compiler.h"
>  #include "crt.h"
> +#include "std.h"
>  
>  #if !defined(_ABIO32) && !defined(_ABIN32) && !defined(_ABI64)
>  #error Unsupported MIPS ABI
> @@ -269,4 +271,13 @@ void __attribute__((weak, noreturn)) __nolibc_entrypoint __no_stack_protector __
>  }
>  #endif /* NOLIBC_NO_RUNTIME */
>  
> +#ifdef __NR_ftruncate64
> +static __attribute__((unused))
> +int sys_ftruncate64(int fd, uint32_t length0, uint32_t length1)
> +{
> +	return my_syscall4(__NR_ftruncate64, fd, 0, length0, length1);
> +}
> +#define sys_ftruncate64 sys_ftruncate64
> +#endif
> +
>  #endif /* _NOLIBC_ARCH_MIPS_H */
> diff --git a/tools/include/nolibc/arch-powerpc.h b/tools/include/nolibc/arch-powerpc.h
> index e0c7e0b81f7c..71829cb027e8 100644
> --- a/tools/include/nolibc/arch-powerpc.h
> +++ b/tools/include/nolibc/arch-powerpc.h
> @@ -6,9 +6,11 @@
>  
>  #ifndef _NOLIBC_ARCH_POWERPC_H
>  #define _NOLIBC_ARCH_POWERPC_H
> +#include <linux/unistd.h>
>  
>  #include "compiler.h"
>  #include "crt.h"
> +#include "std.h"
>  
>  /* Syscalls for PowerPC :
>   *   - stack is 16-byte aligned
> @@ -218,4 +220,13 @@ void __attribute__((weak, noreturn)) __nolibc_entrypoint __no_stack_protector _s
>  }
>  #endif /* NOLIBC_NO_RUNTIME */
>  
> +#ifdef __NR_ftruncate64
> +static __attribute__((unused))
> +int sys_ftruncate64(int fd, uint32_t length0, uint32_t length1)
> +{
> +	return my_syscall4(__NR_ftruncate64, fd, 0, length0, length1);
> +}
> +#define sys_ftruncate64 sys_ftruncate64
> +#endif
> +
>  #endif /* _NOLIBC_ARCH_POWERPC_H */
> diff --git a/tools/include/nolibc/unistd.h b/tools/include/nolibc/unistd.h
> index bb5e80f3f05d..85ac253f9189 100644
> --- a/tools/include/nolibc/unistd.h
> +++ b/tools/include/nolibc/unistd.h
> @@ -48,6 +48,41 @@ int access(const char *path, int amode)
>  	return faccessat(AT_FDCWD, path, amode, 0);
>  }
>  
> +#if !defined(sys_ftruncate64) && defined(__NR_ftruncate64)
> +static __attribute__((unused))
> +int sys_ftruncate64(int fd, uint32_t length0, uint32_t length1)
> +{
> +

Nit: Spurious empty line.

> +	return my_syscall3(__NR_ftruncate64, fd, length0, length1);
> +}
> +#define sys_ftruncate64 sys_ftruncate64
> +#endif
> +
> +static __attribute__((unused))
> +int sys_ftruncate(int fd, off_t length)
> +{
> +#ifdef sys_ftruncate64
> +	union {
> +		off_t length;
> +		struct {
> +			uint32_t length0;
> +			uint32_t length1;
> +		};
> +	} arg;
> +
> +	arg.length = length;
> +
> +	return sys_ftruncate64(fd, arg.length0, arg.length1);
> +#else
> +	return my_syscall2(__NR_ftruncate, fd, length);
> +#endif
> +}
> +
> +static __attribute__((unused))
> +int ftruncate(int fd, off_t length)
> +{
> +	return __sysret(sys_ftruncate(fd, length));
> +}
>  
>  static __attribute__((unused))
>  int msleep(unsigned int msecs)
> diff --git a/tools/testing/selftests/nolibc/nolibc-test.c b/tools/testing/selftests/nolibc/nolibc-test.c
> index 1b9d3b2e2491..6a84dfbb4b73 100644
> --- a/tools/testing/selftests/nolibc/nolibc-test.c
> +++ b/tools/testing/selftests/nolibc/nolibc-test.c
> @@ -969,6 +969,56 @@ int test_fork(enum fork_type type)
>  	}
>  }
>  
> +int test_ftruncate(void)
> +{
> +	int ret;
> +	int fd;
> +	struct stat stat_buf;
> +	const char *filename = "/tmp/ftruncate_test";
> +
> +	ret = ftruncate(-1, 0);
> +	if (ret != -1 || errno != EBADF) {
> +		errno = EINVAL;
> +		return __LINE__;
> +	}
> +
> +	fd = open(filename, O_RDWR | O_CREAT);

Missing the mode argument.
O_TMPFILE would make things easier.

> +	if (fd == -1)
> +		return __LINE__;
> +
> +	ret = ftruncate(fd, -1);
> +	if (ret != -1 || errno != EINVAL) {
> +		if (ret == 0)
> +			errno = EINVAL;
> +		ret = __LINE__;
> +		goto end;
> +	}
> +
> +	ret = ftruncate(fd, 42);
> +	if (ret != 0) {
> +		ret = __LINE__;
> +		goto end;
> +	}
> +
> +	ret = fstat(fd, &stat_buf);
> +	if (ret != 0) {
> +		ret = __LINE__;
> +		goto end;
> +	}
> +
> +	if (stat_buf.st_size != 42) {
> +		errno = EINVAL;
> +		ret = stat_buf.st_size;
> +		goto end;
> +	}

Could you also add a variant which tests that 64-bit values work correctly?

> +
> +end:
> +	close(fd);
> +	unlink(filename);
> +
> +	return ret;
> +}
> +
>  int test_stat_timestamps(void)
>  {
>  	struct stat st;
> @@ -1406,6 +1456,7 @@ int run_syscall(int min, int max)
>  		CASE_TEST(file_stream);       EXPECT_SYSZR(1, test_file_stream()); break;
>  		CASE_TEST(file_stream_wsr);   EXPECT_SYSZR(1, test_file_stream_wsr()); break;
>  		CASE_TEST(fork);              EXPECT_SYSZR(1, test_fork(FORK_STANDARD)); break;
> +		CASE_TEST(ftruncate);         EXPECT_SYSZR(1, test_ftruncate()); break;
>  		CASE_TEST(getdents64_root);   EXPECT_SYSNE(1, test_getdents64("/"), -1); break;
>  		CASE_TEST(getdents64_null);   EXPECT_SYSER(1, test_getdents64("/dev/null"), -1, ENOTDIR); break;
>  		CASE_TEST(directories);       EXPECT_SYSZR(proc, test_dirent()); break;
> -- 
> 2.53.0.473.g4a7958ca14-goog
> 

