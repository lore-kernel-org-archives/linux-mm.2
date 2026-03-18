Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1435FCD0C6
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 07:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBF446B00FC; Wed, 18 Mar 2026 03:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96CC6B00FD; Wed, 18 Mar 2026 03:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BACB96B00FE; Wed, 18 Mar 2026 03:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB3116B00FC
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:31:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A97759895
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:31:08 +0000 (UTC)
X-FDA: 84558362616.02.7EBC7A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id B9518140003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:31:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KsR1dFWJ;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773819066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zkzzlM1HmErl5gsnpT7utmJd6+nXWSgAPQ/ux13njTk=;
	b=dtddWbJb0EyWrPRNdz15Oz1wxvNUjt2tlcxmAtebedLP2Lq5wB+uVn8HawGAxmajWEnhHh
	aBovUhAfPT9P/6Cl9oX4/9mnCjuMPfNlZ6+GbC3ywKw0HJ301hIVMQU5A/bfhskxkfHcVs
	hQGtkstnxHW/BIwPhRbAAq9BMRx6Fw0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773819066; a=rsa-sha256;
	cv=none;
	b=VXnUH/u2Bo8sE0SV3GYT6LATbYsvY6tC6pxfzAGm9kyItEvsnX1okUtZRYxus7YcK82Noq
	tUJQ7tkNkQZPl+kwZHqIVDGW59zj+NM0S81ldQ5K+VQUDECYJXGD3hXe0gNx2322fIm9Y8
	+/1vbxeQW5RpB/y7GErLGVECCoa9NJk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KsR1dFWJ;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C0916011F;
	Wed, 18 Mar 2026 07:31:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8FCC19421;
	Wed, 18 Mar 2026 07:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773819065;
	bh=7Cp5F5RAPtltpaduI57no0pNJvzvNkLMFYL3EGRzLZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KsR1dFWJc6c/kpJkTR1cHeJ1sTGbTJQ5h0GXlUdBGSWEwmar8ygPoi5v4llJt9lUD
	 3mzxJSLkNSHX514tvqlOgnQp32jd4+WROa0gAqqwmFiBqh8v7A4+l5EdZlJonCHeLu
	 BKOTjPJHJgzuYCeCTH4wRbSa2Qhdie0u7sqjzuEkO2+ikyOt+b9XfSNcNzO8BBzZHy
	 TDfhgzxzwrttCFsoESxU1qHo3FStNpkD/pTnVjLpwMzriYglTdZ9GDS7ZzZ5u+91S5
	 TsqI+XZSiasjFKZ++KL7StsGQzZzOKRILfFvcJ9Ku90SEdBDFzwPHuXCWsUIsjbB0g
	 uW7teinKgSxEg==
Date: Wed, 18 Mar 2026 09:31:00 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/6] selftests/liveupdate: add test for memfd content
 preservation
Message-ID: <abpUtCd1-MGL1O4p@kernel.org>
References: <20260309115441.266805-1-pratyush@kernel.org>
 <20260309115441.266805-4-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309115441.266805-4-pratyush@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B9518140003
X-Stat-Signature: 6ymxmyyr85pn1ecps3hmz5jtjpync1ut
X-Rspam-User: 
X-HE-Tag: 1773819066-853834
X-HE-Meta: U2FsdGVkX1/mhKbyjXDqkz03hBGG0ojYfSUAZf45N0vL4kkYxfzpi9RtVM9x1vq0+BQMYystKLLdtoYV1jdhHQ9G+jc4+nhfXAhIKJ9BwanEa3XMJl4TIFMsaMJVoXPSQrpWLOXx5CPBhSJsujq85v+WCboy41+VDETS1SQXVUpGbIYHqDGVCdXb038MbiFTLPhz79U5296UncjcBVcrGndKmK3Poe7ZXNNEBwIJfoEhZ5fgtl2koZszFXYYdljUxfgvHmCYyvdb4i06IkdDjGPJOHCl3bboH9Oe1Yp6rFXGvbhApIbOoH/ccir8NUNe2YwafKKKfK2KUwHoUMojqyCr94uJEB2JvVOCUiJFTTKFNspfDH46y2/FjebGOQ6YddwfkpHBXFAeUnVcWSrkSpbIO0DtEg1sOyhKEC9zoy3SXn6eWVy/2K7COLV4xG0CuyJ2+hoQGgBLbD82BaNKComSrpsHQTM126TU1V873YF/uOfwtec6nFXtyYaqDz+zW5nbYq2AUkNUv7m627a32CVvHDsr7cxWpvYKzHJc2o+5q0GK6vLGsnNB0pU89c2iCGcUxZ7Wtf70k9A+VrC4NgL9heVF2rmgkZTFQKgdaSXrsDdW9NydK3RqRccBNFxr47AG9CzKGVevajhkhzUhpJypzbC0KA5yxpck/6W9ITeQcqyg4qirSkLCbW9zGjSsAUYTG4sB7QEIyd9D6zjrxbBIHYKk5/hQu/xo4QjPkcOblMX8fwobCa7KV8EFyX5PcyLw0uLjWv6EtycaKzFxS3WUC1b8yuRnvGnPoi9pxPh0PtMbetsGjr6c0855FlQ9IzwMPh51k0IP1R5837v3JZHM88P7AY47STXN/pDdSFFvzwJGPrH+6OhTZ3kWOYYsyPYrMcbEAdT9PFhLgKmvgDVm3tf4wU0ZJNcsf3nfUgg5RHbAaXNm1TNSGcAbjAcaJQfmhwoLvNDg2tUgPCb
 tE5r4Bf7
 VdUyWbdlL0Rua945AjIIjw+HM7rYrlTvNgDYHDiwB2yH+e2EQ+ElfKq1y09b4G/vGsFy7tXPZpMsth19+TViiB7LpVtU6I+6Cl0nSYD4+XtMxuiks8IAj81/od4r162IMJ0KzoE6L9TDm8sWzJrBjrziWc5a1EkftuD8E7jBAOE/rthe0IYSUw4CrhSnpxmScgXHQvY49lzS4IZg6FuwV2PZ3Aa0FP3gNNLrG3bcS5WG+XJqvvqztU3OaUColfdoRIgh6dk8USl7XesswD7gQwU164AnZmv/UfAXiBf8CFkHQ490=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 11:54:36AM +0000, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Add a selftest that makes sure the contents of a memfd are correctly
> preserved across a live update. In stage 1, create a memfd and fill it
> with random data, and preserve it. Save the random data to the file
> system. This will be used by stage 2 to verify the contents are correct.

There's a small caveat here, as some CI systems put selftests in tmpfs, so
creating a file there won't really help.
I think there should be a skip if the test runs of tmpfs. 
 
> In stage 2, retrieve the memfd and compare its contents with the
> contents saved on the file system.
> 
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  tools/testing/selftests/liveupdate/Makefile   |  1 +
>  .../testing/selftests/liveupdate/luo_memfd.c  | 61 +++++++++++++++++++
>  2 files changed, 62 insertions(+)
> 
> diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
> index 051daae55eec..8e2eb6500c07 100644
> --- a/tools/testing/selftests/liveupdate/Makefile
> +++ b/tools/testing/selftests/liveupdate/Makefile
> @@ -13,6 +13,7 @@ TEST_FILES += do_kexec.sh
>  include ../lib.mk
>  
>  CFLAGS += $(KHDR_INCLUDES)
> +CFLAGS += -I$(top_srcdir)/tools/include
>  CFLAGS += -Wall -O2 -Wno-unused-function
>  CFLAGS += -MD
>  
> diff --git a/tools/testing/selftests/liveupdate/luo_memfd.c b/tools/testing/selftests/liveupdate/luo_memfd.c
> index b779eee18387..52b5f6b16e19 100644
> --- a/tools/testing/selftests/liveupdate/luo_memfd.c
> +++ b/tools/testing/selftests/liveupdate/luo_memfd.c
> @@ -3,6 +3,9 @@
>  /*
>   * Copyright (c) 2026, Google LLC.
>   * Pratyush Yadav (Google) <pratyush@kernel.org>
> + *
> + * Copyright (C) 2025 Amazon.com Inc. or its affiliates.
> + * Pratyush Yadav <ptyadav@amazon.de>
>   */
>  
>  /*
> @@ -11,11 +14,14 @@
>  
>  #include <errno.h>
>  #include <fcntl.h>
> +#include <stdlib.h>
>  #include <string.h>
>  #include <sys/ioctl.h>
> +#include <sys/mman.h>
>  #include <unistd.h>
>  
>  #include <linux/liveupdate.h>
> +#include <linux/sizes.h>
>  
>  #include "../kselftest.h"
>  #include "../kselftest_harness.h"
> @@ -25,9 +31,64 @@
>  #define STATE_SESSION_NAME "luo-state"
>  #define STATE_MEMFD_TOKEN 1
>  
> +#define MEMFD_DATA_SESSION_NAME "memfd_data_session"
> +#define MEMFD_DATA_TOKEN 1
> +#define MEMFD_DATA_BUFFER_SIZE SZ_1M
> +#define RANDOM_DATA_FILE "luo_random_data.bin"

Reads to me like a random file containing data :)
Something like FILESYSTEM_DATA_COPY would better express the meaning.

> +
>  #define LIVEUPDATE_DEV "/dev/liveupdate"
>  static int luo_fd = -1, stage;
>  
> +/*
> + * Test that a memfd with its data is preserved across live update.
> + */
> +TEST(memfd_data)
> +{
> +	int fd, session;
> +	char *buffer;
> +	struct liveupdate_session_preserve_fd preserve_arg = { .size = sizeof(preserve_arg) };
> +	struct liveupdate_session_retrieve_fd retrieve_arg = { .size = sizeof(retrieve_arg) };
> +
> +	buffer = malloc(MEMFD_DATA_BUFFER_SIZE);
> +	ASSERT_NE(buffer, NULL);
> +
> +	switch (stage) {
> +	case 1:

Can we please move each state to a helper function?

> +		session = luo_create_session(luo_fd, MEMFD_DATA_SESSION_NAME);
> +		ASSERT_GE(session, 0);
> +
> +		fd = create_random_memfd("memfd_data", buffer, MEMFD_DATA_BUFFER_SIZE);
> +		ASSERT_GE(fd, 0);
> +
> +		ASSERT_EQ(save_test_data(RANDOM_DATA_FILE, buffer, MEMFD_DATA_BUFFER_SIZE), 0);
> +
> +		preserve_arg.fd = fd;
> +		preserve_arg.token = MEMFD_DATA_TOKEN;
> +		ASSERT_GE(ioctl(session, LIVEUPDATE_SESSION_PRESERVE_FD, &preserve_arg), 0);
> +
> +		daemonize_and_wait();
> +		break;
> +	case 2:
> +		session = luo_retrieve_session(luo_fd, MEMFD_DATA_SESSION_NAME);
> +		ASSERT_GE(session, 0);
> +
> +		ASSERT_EQ(load_test_data(RANDOM_DATA_FILE, buffer, MEMFD_DATA_BUFFER_SIZE), 0);
> +
> +		retrieve_arg.token = MEMFD_DATA_TOKEN;
> +		ASSERT_GE(ioctl(session, LIVEUPDATE_SESSION_RETRIEVE_FD, &retrieve_arg), 0);
> +		fd = retrieve_arg.fd;
> +		ASSERT_GE(fd, 0);
> +
> +		ASSERT_EQ(verify_fd_content(fd, buffer, MEMFD_DATA_BUFFER_SIZE), 0);
> +
> +		ASSERT_EQ(luo_session_finish(session), 0);
> +		break;


> +	default:
> +		TH_LOG("Unknown stage %d\n", stage);
> +		ASSERT_FALSE(true);
> +	}
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	int session, expected_stage = 0;
> -- 
> 2.53.0.473.g4a7958ca14-goog
> 

-- 
Sincerely yours,
Mike.

