Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2FA7EB104C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD84A6B008A; Tue, 10 Mar 2026 07:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA5E66B008C; Tue, 10 Mar 2026 07:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2B36B0092; Tue, 10 Mar 2026 07:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A90966B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:08:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 72A351BBDE
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:08:59 +0000 (UTC)
X-FDA: 84529881198.13.DC743AD
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9E17D40016
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:08:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M+9SDae3;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773140937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqjOCzwoh4qQ8R2n79BwXderUht8dH1U1qDDXCtHGrw=;
	b=krqXeUTmTY0B+CToOdQZBcmU3ggeG+C0FIyZjMaD2jy8IeF/zIt7q2wf/38cuPoiaGTQwV
	S8Wq/xl6mQJbcdijY5baYwuuROdlfmeSypQv6InItZX+wuE8HI0kfpKUl+vh5idrLnXEcx
	BcDy7shLnr12nhSercKDs0sttfbnWAA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773140937; a=rsa-sha256;
	cv=none;
	b=Rh+BtjBZ2nTk2FES7L6g+X5wjKrnMpzIHpOLdGQSmUiwddte2OMApoolA+99/cH4MvQl49
	mxbrf3F+cRQ/cb429iC3YEpC213M36MvXwwfIhIy4PjV9gZ15bpoF+PItNtUISRTRNbFry
	fSgb3521D7Qac0fEP1USopVtkyE0STw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M+9SDae3;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773140935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BqjOCzwoh4qQ8R2n79BwXderUht8dH1U1qDDXCtHGrw=;
	b=M+9SDae3wrDlhJznygoVI+mezWPeZgLNg2T2DAmqqp+bXNykFhLYIpZPQ/DYnhV69B6CdR
	8GePTwOIxmaaxiTxeiaRy23ca37K1uI9M7ztwTcD8j6eMjhP8FxM9Bx6kwzZq6vJhPz9EG
	olRAvEk/6Elb6ZjojNeA4gwo+shnqO8=
From: Usama Arif <usama.arif@linux.dev>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/6] selftests/liveupdate: add framework for memfd tests
Date: Tue, 10 Mar 2026 04:08:45 -0700
Message-ID: <20260310110847.3519998-1-usama.arif@linux.dev>
In-Reply-To: <20260309115441.266805-2-pratyush@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: gmqjotz3tq3pbqti9kaj76c4cjm96aa4
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E17D40016
X-Rspamd-Server: rspam12
X-HE-Tag: 1773140937-22666
X-HE-Meta: U2FsdGVkX19utJclh5uPBcw47kKEcIn5XsvOfr8seGTRhYxLL5NpDYUpgWwUHAG40vd2QEykcsHUsBu9v76lVAVFec0pXAo7BXaEsR2XlfU894MARnCkcjmW67ME7BAK9bny8E3c2+138h4ZOhWpiHkSbn8dwBNOh4COT5EzUp6JT/tQ8SDKMLGWeIK9wSEawH+1ViZaK4QCsE3bun77eLX79Vss52iRA0YlQdLgOfO1hMb2bx+nPx5PqHjDSaB6mCLkO4Ho0dgq431/y/G5nfwlIjmy9AlI8X1ljO4jYs9B/Gy3hVAlLB8svNgUcIxUMBJ0Iajifns3aQC/LhfKW0Lh2pSRlK7KA2+xNOaSdXK33v8hVVLRYAPsyyC71iDpq8Uls+agAxmnW9n3T5p6lG7Q82nRj3Hv/C1DxSaeNDMSWo19zXTeAiUfs9H9FUjiWGtHtTTGj1+883ueqqxy3clYdTt3JTKNLXvgSnPNIS+eQsZxm8C0VCe4CaeCHaPdJW6AElhVDJqzfqirJeLGNasPMi/nM5o2lYT9u4+QOren1+dHiH3Bksyid+404iwXQ1oHN2+6b+Kg81CHA5SnT0orMDyTr/eSesS+dLo4nUbGcPM+w7q7Jb5TLna2oBjyE5geC5SPhk5dCzMA6X7ZG36rU3CK/UoZlKTZ+01tgo+kRTGynDUe5ktotw5KI3PLf8xjNXfEI/Qoe3HzUdPDbw+1W8hboyhDHHTa/6CDfV8KWc3692huKZI8YzOZPG0qlUt6X7dnF7KUrGeTqrHiz9ID5mOiSpww4eBNBwWptzNkQJCPrB9wS4sCJS+P+Z4lweZv4pkOeE34PjxRpVoi3xDivn9GUSN8UaGA56IY+jaPl0sqm9iiqvWtXcJ/xJ0Vh1yvWyR1UuhyejNFuPG9fNJFpBP7sM2B4oeki6cGfnZuA9c46NkwbHVD7Pjq3zni4/CHW69uAidiywr6tZs
 vlwyJkXZ
 1fftqAz3Az4aKvh8ekOwZpwYLWJthtM8q4xE8QWNr67sHkD5u6cXYYwDsXIIOJrLCAzsJS1xmJVKi7oG+gtvNYekXMgUhILH80wpNbiUJ9e2ACBrRQjMGLrGU6DOp4v+nsE6lglAR9Fh90FlAPy0lmz4AV9gGEBJXucN9DPbOEUEjQkxPtmH2ypkZLE/thMOxq+qcVzRyjmMqtz+3oGtJJX2Tbkw9hefUCc4hrGAxnT2OQpsofw5DY82a2b09KOX9+NfD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  9 Mar 2026 11:54:34 +0000 Pratyush Yadav <pratyush@kernel.org> wrote:

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

Hello!

LIVEUPDATE_DEV doesn't seem to be used anywhere?

> +static int luo_fd = -1, stage;
> +
> +int main(int argc, char *argv[])
> +{
> +	int session, expected_stage = 0;
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
> +			       strerror(errno), LUO_DEVICE);

Need to reverse strerror(errno) and LUO_DEVICE?

> +
> +	session = luo_retrieve_session(luo_fd, STATE_SESSION_NAME);
> +	if (session == -ENOENT)
> +		stage = 1;
> +	else if (session >= 0)
> +		stage = 2;
> +	else
> +		fail_exit("Failed to check for state session");
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
> 

