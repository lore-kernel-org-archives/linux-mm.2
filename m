Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 697ACFCD0C6
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 07:15:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D6D26B00F6; Wed, 18 Mar 2026 03:15:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860CC6B00F7; Wed, 18 Mar 2026 03:15:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728916B00F8; Wed, 18 Mar 2026 03:15:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 582646B00F6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:15:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C59E1C3DF
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:15:41 +0000 (UTC)
X-FDA: 84558323682.02.DED113B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 75CFB160003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:15:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T9cufFL5;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773818139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e6JCeNZ95+yBjSjR4N0wXMT4ez3TrIwcOmTSFq9XJmg=;
	b=ffiuW8xaRjpkO3W58AUGT9SkQQdYqTbNZVxCMFi9X1WiMdR0BMwHRmrNKsjJRH8Igzf0/4
	AWSn+B6EAC6iI6bt83B9wN8GlHu06r7rhgCmK+CKl1tiUY715H4NUtU4FTUEXRGjirBH5R
	zUxMFJFiRjDyxx5BDpfj0l53Ol435/w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T9cufFL5;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773818139; a=rsa-sha256;
	cv=none;
	b=U9QR4+Lje9tBcubbw1n+0Fju43xr5RMkGTNSG4HwgquV4nUJim6lXdq592/efVdfdyhuUa
	QZIpFPYo+lkoY8TWLft75uJ5giY3vRd4EkC9JvDVCo+ugOeuuiD1056fZiVNDYX7lteESe
	kmd1LwCwZFe6/eWzVZ6uH4+jIUmoI98=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B138C60121;
	Wed, 18 Mar 2026 07:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7960C19421;
	Wed, 18 Mar 2026 07:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773818138;
	bh=HA57TZoe4kUHc2+bGmz45ludm6iUpxni9mm++DOzFxw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T9cufFL5XjwyV8VXoZUq2Dftqo/gLYu5x7FdiDrcQd3PhMf4B3ZtRpskY4DrsJJf6
	 BzCUja/lf6wGuGhbSazOGuLsVkWXa/rlQpcfrcIEAeKNMCscbjfjpXws473vaOElIR
	 dUGryHxVz5asQsZwiGhc1D6dCqiHeq88gfVDNuslgWqkGi5lQQP8IVrAkZwPBnuL5F
	 AhbCCG3Pb0ZuzyCND91nwa/v0KsO7/pMp9TVbz/MsRydZlXlpZzvL3B1q/mO2hx5eH
	 6FFpKCA3y0F3bJuNjTkXh0pt0lztkIS9GX5nJZLKi8yykdnUkdfdCeeEllMbdSx2xx
	 /+XFAKcy+FeMA==
Date: Wed, 18 Mar 2026 09:15:31 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/6] selftests/liveupdate: add framework for memfd tests
Message-ID: <abpRE6cfsyuoeiiq@kernel.org>
References: <20260309115441.266805-1-pratyush@kernel.org>
 <20260309115441.266805-2-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309115441.266805-2-pratyush@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 75CFB160003
X-Stat-Signature: jm1iqdiwdzcxf1hn3azmf1upx98nq4xp
X-Rspam-User: 
X-HE-Tag: 1773818139-144513
X-HE-Meta: U2FsdGVkX18NyPtjQqU6VW5vuJPbgxDA6YuPMxFeE7WMMGzyao+wr26jhEcEVluR1eJ3/Ro4ZE250y4tWKy3D1Fdpxez7oK2nVtwus4EsUiLoVvckyCLO9QNflSDlhS6JfKBaDABmhp4TV8KtJTFxeZWpMo9dapZIuCLTlariEBi68VxBXChPWrxeOZYrdVGkiukPyp2PXsFKP8XLLp/a/UOuowDzacefqeUyLEVS10c4EMojd5ifPxmw/rRDZywwObnQJmHU2YZxf8Jz04B8y3DPWx1wjjPzpSoZLOFafL/gbdVXINkItsashr6BKs/DzoORHdd80TVTxdBrWzl+Zpp/CAGNz/I0H/zkpyyTkl3Hu3cx+RuPZKrYoms0lVB4IeXXxOfKtyTAPNu61MDCdesLFX4jVKz4kwIAFDgeSelrfvSanWjuVA9qdBtG17RdaX3AFZatya94yecZ2y9IUHdquznJkZULrzbFEFE0xr7ELbK/Fdgl1YPAS/ruD69KlVuQ0J0uvF993BK1Nqn0L0Ss08mjF6uLCCZ+CKAhsN3oQalmLew+sC+0WZFdEAtpbhE+JwESnb8iC3g9tmA7/1Xyqcuk39FlGcQdlYg8Z1amkL53cWUUxMfiaNJb8vEVYaaH/wdOfFu4fwOQFVuppp82vsJBpSBBe9Rc2tkVR6EKwdkHqHEi64f3+/G91MQr+Z+OGGGa/62BkunZ5NWwZ9I4xh+5/X8/qdlk2l8jm3EjfS0CflfNsiRWh1Q/lzgpOC6m7wMeD9kmllUaDJo8lx1xP3WECDA1jIO5c/oZzDv5f89G6yGiXnKIL8fo1Rb2S+P9RxqCBFrz2SXalGn2+hqSeoLaHFJG9tmdfNnsEdHbQjASRjQpbIu2i1ozfMPMbTTHklKOLc9RR0ht8jdn/NVGdEnNTrlcHOHY7FT01BknlBrjgaHoQCHl4nLOCdDs29Y/GwRJ8Vij1XLcww
 QBeAqi/F
 e4PByF4Kpa09PeTeIAOkLBxx2VBQLHcKdn/7WKJxdagc2zkJhWXCK3yt8ZkkFASQH4V8fTcMMjXCAJqsRkyxtClruMNN5mewguJaUuTVcbjYJc3cbU9F/MEulC51vJ06yM5xKWtGog9bUqymZ1wZRYXHMAWAzYtmSnwgR7FoErOadqIkXGv2uoPINZOd6r/75EUgCDcKB0TzMtgoZW9FnCZw+RZZDxEZ6zpJ846J7hw6p7znm5O9leKoxgQqM6nBszDvo3UJ6BccVm6eV+RfIYHGZhTjd990xknheJw1myqMDEEn1UffLaP3fCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 11:54:34AM +0000, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Currently memfd preservation using LUO is only tested indirectly via the
> luo_multi_session or luo_kexec_simple tests. Their main purpose is to
> test other live update functionality.
> 
> Add a framework for writing memfd tests. The framework hooks into the
> kselftest harness, but adds some things on top to make it suitable for
> live update.
> 
> The LUO FD (/dev/liveupdate) can only be opened by one process at a
> time. Each test runs in its own process. This means the LUO FD must be
> owned by the main process and shared to children. main() opens the LUO
> FD and shares it to child runners using a global variable.
> 
> Live update tests run in two stages. One before kexec and one after.
> Detect the stage using a special state session. If the session is
> present, it means the test is in post-kexec state.
> 
> Additionally, take in an optional --stage argument that lets callers
> specify expected stage. This is useful as a safety net to catch LUO core
> failures. If LUO core fails to preserve the state session properly, this
> option can help detect this and fail early. Since the option is not
> recognized by the kselftest harness, remove it from argv before calling
> test_harness_run().
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

with a few nits below.

> ---
>  tools/testing/selftests/liveupdate/Makefile   |  1 +
>  .../testing/selftests/liveupdate/luo_memfd.c  | 77 +++++++++++++++++++
>  2 files changed, 78 insertions(+)
>  create mode 100644 tools/testing/selftests/liveupdate/luo_memfd.c
> 
> diff --git a/tools/testing/selftests/liveupdate/Makefile b/tools/testing/selftests/liveupdate/Makefile
> index 080754787ede..051daae55eec 100644
> --- a/tools/testing/selftests/liveupdate/Makefile
> +++ b/tools/testing/selftests/liveupdate/Makefile
> @@ -6,6 +6,7 @@ TEST_GEN_PROGS += liveupdate
>  
>  TEST_GEN_PROGS_EXTENDED += luo_kexec_simple
>  TEST_GEN_PROGS_EXTENDED += luo_multi_session
> +TEST_GEN_PROGS_EXTENDED += luo_memfd
>  
>  TEST_FILES += do_kexec.sh
>  
> diff --git a/tools/testing/selftests/liveupdate/luo_memfd.c b/tools/testing/selftests/liveupdate/luo_memfd.c
> new file mode 100644
> index 000000000000..b779eee18387
> --- /dev/null
> +++ b/tools/testing/selftests/liveupdate/luo_memfd.c
> @@ -0,0 +1,77 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +/*
> + * Copyright (c) 2026, Google LLC.
> + * Pratyush Yadav (Google) <pratyush@kernel.org>
> + */
> +
> +/*
> + * Selftests for memfd preservation via LUO.
> + */
> +
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <string.h>
> +#include <sys/ioctl.h>
> +#include <unistd.h>
> +
> +#include <linux/liveupdate.h>
> +
> +#include "../kselftest.h"
> +#include "../kselftest_harness.h"
> +
> +#include "luo_test_utils.h"
> +
> +#define STATE_SESSION_NAME "luo-state"
> +#define STATE_MEMFD_TOKEN 1
> +
> +#define LIVEUPDATE_DEV "/dev/liveupdate"
> +static int luo_fd = -1, stage;

Nit: declaring stage on a separate line is a bit clearer.

> +
> +int main(int argc, char *argv[])
> +{
> +	int session, expected_stage = 0;

Ditto.

> +
> +	/*
> +	 * The test takes an optional --stage argument. This lets callers
> +	 * provide the expected stage, and if that doesn't match the test errors
> +	 * out.
> +	 *
> +	 * Look for the stage. Since test_harness_run() doesn't recognize it,
> +	 * once found, remove it from argv.
> +	 */
> +	for (int i = 1; i < argc; i++) {
> +		if (strcmp(argv[i], "--stage") == 0) {
> +			if (i + 1 < argc) {
> +				expected_stage = atoi(argv[i + 1]);
> +				memmove(&argv[i], &argv[i + 2], (argc - i - 1) * sizeof(char *));
> +				argc -= 2;
> +				i--;
> +			} else {
> +				ksft_exit_fail_msg("Option --stage requires an argument\n");
> +			}
> +		}
> +	}
> +
> +	luo_fd = luo_open_device();
> +	if (luo_fd < 0)
> +		ksft_exit_skip("Failed to open %s (%s). Is the luo module loaded?\n",

LUO can't be a module :) Maybe

"Is LUO enabled in the kernel?"


> +			       strerror(errno), LUO_DEVICE);
> +
> +	session = luo_retrieve_session(luo_fd, STATE_SESSION_NAME);
> +	if (session == -ENOENT)
> +		stage = 1;
> +	else if (session >= 0)
> +		stage = 2;
> +	else
> +		fail_exit("Failed to check for state session");

There is ksft_exit_fail_perror(), would be more consistent with other exit
paths.

> +
> +	if (expected_stage && expected_stage != stage)
> +		ksft_exit_fail_msg("Stage mismatch: expected %d, got %d\n",
> +				   expected_stage, stage);
> +
> +	if (stage == 1)
> +		create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, 2);
> +
> +	test_harness_run(argc, argv);
> +}
> -- 
> 2.53.0.473.g4a7958ca14-goog
> 

-- 
Sincerely yours,
Mike.

