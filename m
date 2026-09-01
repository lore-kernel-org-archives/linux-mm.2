Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3728FC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 20:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20BCD6B008C; Tue,  1 Sep 2026 16:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BD236B0092; Tue,  1 Sep 2026 16:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ABE86B0095; Tue,  1 Sep 2026 16:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D51D76B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:43:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4322614052A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:43:24 +0000 (UTC)
X-FDA: 85166368728.28.D5C0205
Received: from mta0.migadu.com (out-115.mta0.migadu.com [91.218.175.115])
	by imf24.hostedemail.com (Postfix) with ESMTP id 82DEF18000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:43:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nowcvRCv;
	spf=pass (imf24.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788295402;
	b=AVCI+9k50KInNRK7VWrovHZZfvPoAXm7loNekP7wXptpvAisFFMfSnCvURBmPWn43ImgY8
	0SM5MmK96g4VB4U226NivJIQdDM5MKHydAaIc7/CdCaKpk3cw4qwYyKRbWqf42/zYpXw7y
	FOFaN3RY5fz2LIIRHMgcxlMBhzJIZkI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nowcvRCv;
	spf=pass (imf24.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.115 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788295402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OGNNwwRyZcarDvGMJ390BBtnjxeSceiCoR/YnThu2U=;
	b=D8k9x1pLxLXftT/TYZMWQ9YmKt7DWT2cwQogZrP3KblTNvD9jrKNoiohVM5ef1XNAcTlrn
	o5h0bvhhgUQS0Pssowd+4zx+1K812dRNgNPlCKYbZkEj6N5bqxEh5oBZhXC7WyK6GrJ4i2
	Azlhncoq6GRbNVmSIVkztUsA1S+pnLo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jBKvXUFM1f0s+hjikahqMP0nXyIuhryvTs8Cm/LcB1g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788295397; v=1; x=1788900197;
 b=nowcvRCv2q7WbiAYvGa+rJ4eBEDwPUuW5YlqlM456eY7wJvrcvYF9c0JewyzCu+c/N/DSkHU
 ANv1e+YyrsFEBPzfoCE1tDoGm7bTfJESVVaVfpglf5Xb+eEVTOlXBzoPi80QsNd01T4w+kSi0AA
 7WCKpT7iyiVBg2ReevLBufI0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b57c6c0cb33d22b9;
	Tue, 01 Sep 2026 20:43:07 +0000
X-Mizu-Trace-ID: b57c6c0cb33d22b9
X-Migadu-Flow: FLOW_OUT
Message-ID: <f2f9c32b-589f-4d9d-b42b-c83b435fc821@linux.dev>
Date: Tue, 1 Sep 2026 13:43:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] selftests: liveupdate: Add selftest for eventfd
 LUO
To: Chenghao Duan <duanchenghao@kylinos.cn>, viro@zeniv.linux.org.uk,
 brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
 pasha.tatashin@soleen.com, linux-kernel@vger.kernel.org, rppt@kernel.org,
 pratyush@kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: jianghaoran@kylinos.cn
References: <20260625054946.73445-1-duanchenghao@kylinos.cn>
 <20260625054946.73445-3-duanchenghao@kylinos.cn>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260625054946.73445-3-duanchenghao@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 82DEF18000A
X-Stat-Signature: 83emfiyq9uuxrzdsiffush4guyrcjjbp
X-Rspam-User: 
X-HE-Tag: 1788295400-64352
X-HE-Meta: U2FsdGVkX1+aS3F3Jk/P5Z7FXwX5oqlRcOiDegqzLzsDGktEBtDLHSeKuKkEU6cSif8XJcuwD9Xp8NBxkbK2OYX4bIaDnpRzWPgChU26L79TT0m2zgZeRXg1xH7z+u5YLYUrVz0L+LD2ibU4cKC6MQe28g0RVLzST5e9zV9qNNlW2NNqtut7UA7iNY63R5cbdIAxCfwquOSdrrrcsC2oEMa7NyT4asCdg/p29Csj7yk6kNv6qZeGcliVvKp7edKwnrhmCACfE9/TF0oiA7qaO3Wz3aoZSFBnM/KXrpdzDKjflq1W21dKmg3U06AlYiygG+rbFw3fXYHCPz2ZqzzSwMzRCr6Z1hdJokHD+EkWmR8VUpkaViJLpPTd3V6W/CIT+VEV8hTz+ggYB9Ubg6hVPkdGsLvN2Abslg7dQuZ+4Zu4VmEcDFMP9aN6Zb5qtB+cwToBusYISS17H9UYDwVWP2c6bXMApHNUVhjiTJOO1l20rdOIxOEbVwWxy4eIGDAFRlE8gIrzh2KRrf6BuVgc1ihHVjvAFofPo/zBW3fXTvsaNLzni+FqE7dw1C7JCBvV4V52yUrnCazBGL8hgXe6jeidCcytiIb+vbz5ekhdvdKnDhtKQUcbZBxqMEcXfMRJ0spti6N26DanwekjEFUMhi5FgH2TzstpZ8G67t8OLnwT5aInO9/jGIpYIdg7wbakmcWwGcjoDX+waeh3ivUg/7O4onZ0cgJ/ocRx26fy4FmCpKXxpF5zbGEpt2+IZi0sDgBIZ/elvmnKEgeXQyIoLLzGvC3EMRKGBcIYLwhJV0sOKBfKUG6CUZrMoDg+PptA+j9ZFupt7DXZ02GP2fKZrih3C79NQMISaZXN9vO/xe44akjTwcf3+byOFrpOb3M0YBb723P6gBvySEIMI7qMPrr2rRWbP+K2r0iXvBrc9EiIYG8ZPQgoUGwYizJ1hIsHIdTff01eK2e/x7h+0wv
 91CaYHyP
 bck/qOyPqeRcdtPhVYjxwzmlnVQL+7FGWteEcLe5pRMm0+wJYc7AXcnaKVR0tzIpt89AoxDn0OhRHwwXRGXHUkJr9MUh91hbOhJVi5uRLCRXfoDiSfWikOOr8739qJkusBPAd++rRvgsdOhgubf68vxwQ1WuQ47pTBvHewxJFQNUEek9ugP83BP5aBC1myxa5bhxeQkTzl6tL+NmNY/TS8e+BHQRrVOucP+b6cT0gXuclEHdO/yoY90uavpNlrU48MUj+0XL89Msn0i9x8R53Rxygx0vK5J9WdIt6uG8rTZKiJRJ6/UHiVDA11gT0f7bYoA0SeNlXJJ/WXOYkn0xU9nEEOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2026/6/24 22:49, Chenghao Duan 写道:
> This test verifies the Live Update Orchestrator (LUO) support for
> preserving eventfd file descriptors across kexec. It creates multiple
> LUO sessions, each preserving different eventfd types, and verifies
> their state after kexec.
> 
> The test covers six different eventfd configurations:
> 1. **Empty eventfd** - Zero count, default flags
>     - Verifies flag preservation without behavioral testing
> 2. **Default eventfd** - Initial count + write, verifies count preservation
>     - Tests basic counter value retention across kexec
> 3. **Semaphore eventfd** - EFD_SEMAPHORE flag, multiple reads
>     - Verifies semaphore behavior (returns 1 per read)
> 4. **Non-blocking eventfd** - EFD_NONBLOCK flag
>     - Tests O_NONBLOCK flag preservation
> 5. **Large-count eventfd** - UINT_MAX count value
>     - Tests handling of maximum counter values
> 6. **Modified-after-preserve** - Count changed during handover
>     - Verifies freeze callback captures final state
> 
> The test validates the following sequence:
> 
> Stage 1 (pre-kexec):
> - Creates state file for inter-stage communication
> - Creates multiple LUO sessions
> - Preserves eventfds with different configurations
> - Trigger kexec reboot
> 
> Stage 2 (post-kexec):
> - Retrieves preserved eventfd sessions
> - Verifies flags and counter values for each type
> - Tests semaphore read behavior
> - Finalizes all sessions
> 
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
> ---
>   tools/testing/selftests/liveupdate/Makefile   |   1 +
>   tools/testing/selftests/liveupdate/config     |   2 +
>   .../selftests/liveupdate/luo_test_eventfd.c   | 376 ++++++++++++++++++
>   3 files changed, 379 insertions(+)
>   create mode 100644 tools/testing/selftests/liveupdate/luo_test_eventfd.c
> 
> diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
> index 30689d22cb02..e092e38fa6f6 100644
> --- a/tools/testing/selftests/liveupdate/Makefile
> +++ b/tools/testing/selftests/liveupdate/Makefile
> @@ -8,6 +8,7 @@ TEST_GEN_PROGS_EXTENDED += luo_kexec_simple
>   TEST_GEN_PROGS_EXTENDED += luo_multi_session
>   TEST_GEN_PROGS_EXTENDED += luo_stress_sessions
>   TEST_GEN_PROGS_EXTENDED += luo_stress_files
> +TEST_GEN_PROGS_EXTENDED += luo_test_eventfd
>   
>   TEST_FILES += do_kexec.sh
>   
> diff --git a/tools/testing/selftests/liveupdate/config b/tools/testing/selftests/liveupdate/config
> index 91d03f9a6a39..d388bd755245 100644
> --- a/tools/testing/selftests/liveupdate/config
> +++ b/tools/testing/selftests/liveupdate/config
> @@ -9,3 +9,5 @@ CONFIG_LIVEUPDATE_TEST=y
>   CONFIG_MEMFD_CREATE=y
>   CONFIG_TMPFS=y
>   CONFIG_SHMEM=y
> +CONFIG_EVENTFD=y
> +CONFIG_LIVEUPDATE_EVENTFD=y
> diff --git a/tools/testing/selftests/liveupdate/luo_test_eventfd.c b/tools/testing/selftests/liveupdate/luo_test_eventfd.c
> new file mode 100644
> index 000000000000..94ef3bc66ad9
> --- /dev/null
> +++ b/tools/testing/selftests/liveupdate/luo_test_eventfd.c
> @@ -0,0 +1,376 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2026 KylinSoft Corporation.
> + * Author: Chenghao Duan <duanchenghao@kylinos.cn>
> + */
> +
> +/*
> + * Multi-session kexec selftest for eventfd LUO support.
> + *
> + * Modeled after luo_multi_session.c.
> + * It creates multiple LUO sessions, each preserving different eventfd types,
> + * and verifies them after kexec.
> + */
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <limits.h>
> +#include <stdint.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <sys/eventfd.h>
> +#include <sys/ioctl.h>
> +#include <unistd.h>
> +
> +#include "luo_test_utils.h"

luo_test_utils.h should be libliveupdate.h since the commit df1a0d068d48 
selftests/liveupdate: Move luo_test_utils.* into a reusable library

Yanjun.Zhu

> +
> +/* Session names */
> +#define SESSION_EMPTY     "eventfd-empty"
> +#define SESSION_DEFAULT   "eventfd-default"
> +#define SESSION_SEM       "eventfd-sem"
> +#define SESSION_NONBLOCK  "eventfd-nonblock"
> +#define SESSION_LARGE     "eventfd-large"
> +#define SESSION_MODIFIED  "eventfd-modified-after-preserve"
> +
> +/* Tokens */
> +#define TOKEN_DEFAULT       0xCAFEBABE
> +#define TOKEN_SEM           0xDEADBEEF
> +#define TOKEN_NONBLOCK      0xFEEDBEEF
> +#define TOKEN_LARGE         0xBEEFCAFE
> +#define TOKEN_MODIFIED      0xABCD1234
> +
> +/* Counts */
> +#define COUNT_INITIAL   42
> +#define COUNT_WRITE     10
> +#define COUNT_EXPECTED  (COUNT_INITIAL + COUNT_WRITE) /* 52 */
> +#define COUNT_SEM       5
> +#define COUNT_NONBLOCK  100
> +#define COUNT_LARGE     ((unsigned int)-1) /* UINT_MAX */
> +#define COUNT_MODIFIED  25
> +#define COUNT_MODIFY_DELTA  99
> +
> +/* State tracking */
> +#define STATE_SESSION_NAME "eventfd_multi_state"
> +#define STATE_TOKEN        997
> +
> +/* Eventfd verification modes */
> +enum verify_mode {
> +	VERIFY_FLAGS,        /* Only verify flags, no behavior testing */
> +	VERIFY_ONCE,         /* Read once and verify count */
> +	VERIFY_SEMAPHORE,    /* Read multiple times, verify returns 1 each time */
> +	VERIFY_NONBLOCK,     /* Read once in nonblock mode */
> +	VERIFY_LARGE         /* Read once, verify large count */
> +};
> +
> +/* Test session configuration */
> +struct test_session_config {
> +	const char *session_name;
> +	unsigned long token;
> +	unsigned int count;
> +	unsigned int flags;
> +	enum verify_mode verify_mode;
> +	const char *desc;
> +};
> +
> +/* Test session configurations */
> +static const struct test_session_config test_configs[] = {
> +	{SESSION_EMPTY, 0, 0, 0, VERIFY_FLAGS, "Empty"},
> +	{SESSION_DEFAULT, TOKEN_DEFAULT, COUNT_EXPECTED, 0, VERIFY_ONCE, "Default"},
> +	{SESSION_SEM, TOKEN_SEM, COUNT_SEM, EFD_SEMAPHORE, VERIFY_SEMAPHORE, "Semaphore"},
> +	{SESSION_NONBLOCK, TOKEN_NONBLOCK, COUNT_NONBLOCK, EFD_NONBLOCK, VERIFY_NONBLOCK, "Nonblock"},
> +	{SESSION_LARGE, TOKEN_LARGE, COUNT_LARGE, 0, VERIFY_LARGE, "Large-count"},
> +	{SESSION_MODIFIED, TOKEN_MODIFIED, COUNT_MODIFIED + COUNT_MODIFY_DELTA, 0, VERIFY_ONCE, "Modified after preserve (kexec handover)"},
> +};
> +#define NUM_TEST_SESSIONS ARRAY_SIZE(test_configs)
> +
> +static int verify_eventfd_flags(int efd, unsigned int expected_flags, const char *desc)
> +{
> +	int actual_flags = fcntl(efd, F_GETFL);
> +
> +	if (actual_flags < 0)
> +		return -errno;
> +
> +	int expected_fd_flags = expected_flags & (EFD_NONBLOCK | EFD_CLOEXEC);
> +	int actual_fd_flags = actual_flags & (O_NONBLOCK | O_CLOEXEC);
> +
> +	if (actual_fd_flags != expected_fd_flags) {
> +		ksft_print_msg("%s: flag mismatch - expected 0x%x, got 0x%x\n",
> +			       desc, expected_fd_flags, actual_fd_flags);
> +		return -EINVAL;
> +	}
> +
> +	ksft_print_msg("  %s eventfd flags OK (0x%x)\n", desc, expected_fd_flags);
> +	return actual_flags; /* Return actual flags for further use */
> +}
> +
> +static int ensure_nonblock(int efd, int current_flags)
> +{
> +	return fcntl(efd, F_SETFL, current_flags | O_NONBLOCK);
> +}
> +
> +static int verify_count_once(int efd, unsigned int expected_count, const char *desc)
> +{
> +	uint64_t val;
> +
> +	if (read(efd, &val, sizeof(val)) != sizeof(val))
> +		return -errno;
> +
> +	if (val != (uint64_t)expected_count) {
> +		ksft_print_msg("%s: expected %u got %llu\n",
> +			       desc, expected_count, (unsigned long long)val);
> +		return -EINVAL;
> +	}
> +
> +	ksft_print_msg("  %s eventfd OK: %u\n", desc, expected_count);
> +	return 0;
> +}
> +
> +static int verify_semaphore_behavior(int efd, unsigned int expected_count, const char *desc)
> +{
> +	uint64_t val;
> +
> +	/* Read expected_count times, each should return 1 */
> +	for (unsigned int i = 0; i < expected_count; i++) {
> +		if (read(efd, &val, sizeof(val)) != sizeof(val))
> +			return -errno;
> +
> +		if (val != 1) {
> +			ksft_print_msg("%s: expected 1, got %llu at read %u\n",
> +				       desc, (unsigned long long)val, i + 1);
> +			return -EINVAL;
> +		}
> +		ksft_print_msg("  %s eventfd OK: %u at read %u\n", desc, (unsigned int)val, i + 1);
> +	}
> +
> +	/* Next read should return EAGAIN (no more events) */
> +	if (read(efd, &val, sizeof(val)) >= 0 || errno != EAGAIN) {
> +		ksft_print_msg("%s: expected EAGAIN after %u reads\n",
> +			       desc, expected_count);
> +		return -EINVAL;
> +	}
> +
> +	ksft_print_msg("  %s eventfd OK (%u reads)\n", desc, expected_count);
> +	return 0;
> +}
> +
> +static int restore_and_verify_eventfd_generic(int session_fd,
> +					      unsigned long token,
> +					      unsigned int expected_count,
> +					      unsigned int expected_flags,
> +					      enum verify_mode mode,
> +					      const char *desc)
> +{
> +	struct liveupdate_session_retrieve_fd arg = { .size = sizeof(arg) };
> +	int efd, ret = 0, actual_flags;
> +
> +	arg.token = token;
> +	if (ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg) < 0)
> +		return -errno;
> +	efd = arg.fd;
> +
> +	switch (mode) {
> +	case VERIFY_FLAGS:
> +		/* Only verify flags, no behavior testing */
> +		ret = verify_eventfd_flags(efd, expected_flags, desc);
> +		if (ret < 0)
> +			close(efd);
> +		return ret < 0 ? ret : 0;
> +
> +	case VERIFY_SEMAPHORE:
> +		/* Verify flags + semaphore behavior */
> +		actual_flags = verify_eventfd_flags(efd, expected_flags, desc);
> +		if (actual_flags < 0) {
> +			ret = actual_flags;
> +			goto out;
> +		}
> +
> +		if (ensure_nonblock(efd, actual_flags) < 0) {
> +			ret = -errno;
> +			goto out;
> +		}
> +
> +		ret = verify_semaphore_behavior(efd, expected_count, desc);
> +		break;
> +
> +	case VERIFY_ONCE:
> +	case VERIFY_NONBLOCK:
> +	case VERIFY_LARGE:
> +		/* Verify flags + count behavior */
> +		actual_flags = verify_eventfd_flags(efd, expected_flags, desc);
> +		if (actual_flags < 0) {
> +			ret = actual_flags;
> +			goto out;
> +		}
> +
> +		ret = verify_count_once(efd, expected_count, desc);
> +		break;
> +
> +	default:
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +out:
> +	close(efd);
> +	return ret;
> +}
> +
> +static int create_and_preserve_eventfd_keep_fd(int session_fd,
> +					       unsigned long token,
> +					       unsigned int count,
> +					       unsigned int flags,
> +					       const char *desc,
> +					       int *efd_out)
> +{
> +	struct liveupdate_session_preserve_fd arg = { .size = sizeof(arg) };
> +	int efd = eventfd(count, flags);
> +
> +	if (efd < 0)
> +		return -errno;
> +
> +	arg.fd = efd;
> +	arg.token = token;
> +	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &arg) < 0) {
> +		int ret = -errno;
> +
> +		close(efd);
> +		return ret;
> +	}
> +
> +	if (efd_out)
> +		*efd_out = efd;
> +	else
> +		close(efd);
> +	return 0;
> +}
> +
> +static int create_and_preserve_eventfd(int session_fd,
> +				       unsigned long token,
> +				       unsigned int count,
> +				       unsigned int flags,
> +				       const char *desc)
> +{
> +	return create_and_preserve_eventfd_keep_fd(session_fd, token, count,
> +						   flags, desc, NULL);
> +}
> +
> +static int create_session_checked(int luo_fd, const char *session_name)
> +{
> +	int session_fd = luo_create_session(luo_fd, session_name);
> +
> +	if (session_fd < 0)
> +		fail_exit("luo_create_session for '%s'", session_name);
> +	return session_fd;
> +}
> +
> +static int retrieve_session_checked(int luo_fd, const char *session_name)
> +{
> +	int session_fd = luo_retrieve_session(luo_fd, session_name);
> +
> +	if (session_fd < 0)
> +		fail_exit("luo_retrieve_session for '%s'", session_name);
> +	return session_fd;
> +}
> +
> +static void finish_session_checked(int session_fd, const char *session_name)
> +{
> +	if (luo_session_finish(session_fd) < 0)
> +		fail_exit("luo_session_finish for '%s'", session_name);
> +	close(session_fd);
> +}
> +
> +static int verify_eventfd_config(int session_fd, const struct test_session_config *config)
> +{
> +	return restore_and_verify_eventfd_generic(session_fd, config->token,
> +						 config->count, config->flags,
> +						 config->verify_mode, config->desc);
> +}
> +
> +
> +static void run_stage_1(int luo_fd)
> +{
> +	ksft_print_msg("[STAGE 1] Starting pre-kexec setup for multi-eventfd test...\n");
> +	ksft_print_msg("[STAGE 1] Creating state file for next stage (2)...\n");
> +	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_TOKEN, 2);
> +
> +	/* Create all test sessions */
> +	for (size_t i = 0; i < NUM_TEST_SESSIONS; i++) {
> +		const struct test_session_config *config = &test_configs[i];
> +
> +		ksft_print_msg("[STAGE 1] Creating session '%s'...\n", config->session_name);
> +		int session_fd = create_session_checked(luo_fd, config->session_name);
> +
> +		/* Special handling for modified session (preserve then modify) */
> +		if (config->token == TOKEN_MODIFIED) {
> +			int preserved_efd;
> +
> +			if (create_and_preserve_eventfd_keep_fd(session_fd,
> +								config->token,
> +								COUNT_MODIFIED,
> +								config->flags,
> +								"modified-after-preserve",
> +								&preserved_efd) < 0)
> +				fail_exit("create_and_preserve_eventfd_keep_fd modified");
> +
> +			/* Now modify the preserved eventfd's count */
> +			uint64_t modify_value = COUNT_MODIFY_DELTA;
> +
> +			if (write(preserved_efd, &modify_value,
> +			    sizeof(modify_value)) != sizeof(modify_value))
> +				fail_exit("write to preserved eventfd after preserve");
> +
> +			close(preserved_efd);
> +		} else {
> +			/* Standard session creation */
> +			if (create_and_preserve_eventfd(session_fd, config->token,
> +							config->count, config->flags,
> +							config->desc) < 0)
> +				fail_exit("create_and_preserve_eventfd %s", config->desc);
> +		}
> +	}
> +
> +	close(luo_fd);
> +	daemonize_and_wait();
> +}
> +
> +static void run_stage_2(int luo_fd, int state_session_fd)
> +{
> +	int session_fds[NUM_TEST_SESSIONS];
> +	int stage;
> +
> +	ksft_print_msg("[STAGE 2] Starting post-kexec verification...\n");
> +
> +	restore_and_read_stage(state_session_fd, STATE_TOKEN, &stage);
> +	if (stage != 2)
> +		fail_exit("Expected stage 2, but state file contains %d", stage);
> +
> +	ksft_print_msg("[STAGE 2] Retrieving all sessions...\n");
> +	for (size_t i = 0; i < NUM_TEST_SESSIONS; i++)
> +		session_fds[i] = retrieve_session_checked(luo_fd, test_configs[i].session_name);
> +
> +	ksft_print_msg("[STAGE 2] Verifying eventfds...\n");
> +	for (size_t i = 0; i < NUM_TEST_SESSIONS; i++) {
> +		if (verify_eventfd_config(session_fds[i], &test_configs[i]) < 0)
> +			fail_exit("verify %s eventfd", test_configs[i].desc);
> +	}
> +
> +	ksft_print_msg("[STAGE 2] All eventfd sessions verified successfully.\n");
> +
> +	ksft_print_msg("[STAGE 2] Finalizing all sessions...\n");
> +	for (size_t i = 0; i < NUM_TEST_SESSIONS; i++)
> +		finish_session_checked(session_fds[i], test_configs[i].session_name);
> +
> +	ksft_print_msg("[STAGE 2] Finalizing state session...\n");
> +	if (luo_session_finish(state_session_fd) < 0)
> +		fail_exit("luo_session_finish for state session");
> +	close(state_session_fd);
> +
> +	ksft_print_msg("\n--- EVENTFD_LUO TEST PASSED ---\n");
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	return luo_test(argc, argv, STATE_SESSION_NAME,
> +			run_stage_1, run_stage_2);
> +}


