Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54FD2105F78A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 10:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0C8B6B0089; Fri, 13 Mar 2026 06:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC36F6B008A; Fri, 13 Mar 2026 06:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F01E6B008C; Fri, 13 Mar 2026 06:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8EF4E6B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:05:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F5961A0874
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:05:59 +0000 (UTC)
X-FDA: 84540608838.16.7A11062
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A4119C0004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:05:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GY9H471s;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773396357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t0MrLjF+7m8BoQJbuVZ9MTBk5c8yLEpd2qDNH9w9nXI=;
	b=rqRbHdKdYeJkohT4PQq/0pkcZIkS8h1vP/ARMu1JuYIMEdxSbeMMecdNYz/9ce6cdYOEMq
	NnUk4pX0MDTWGNUTp1yZMUmWyrbxcLfAtFa2hh1qLwKxSINqjq4GxN2iY8fw2EsKBjA3v+
	c7FSsCLo70aeLftoNHP9R/ksrBvM9AM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773396357; a=rsa-sha256;
	cv=none;
	b=JbET4xFo5Gxj4X9kQb8t/84jwvTfkq4HbLKx2kg7/Ch7VBd5Zos3+WajkSyggYyDKtz7BU
	0QCfQEFwF8V4T0f3MOml7SPdhua9w1RemKwzjO07hTKj+A5l2FDH1LlAH6aPy8J/WF5/r9
	9T2fdfjHAiCNGfAk8sa/neMhiHYCUNo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GY9H471s;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1D7A96012B;
	Fri, 13 Mar 2026 10:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45E1C19421;
	Fri, 13 Mar 2026 10:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773396356;
	bh=aVjfpNlCAnDLl1tYf6aaIB1a5oJJV9l2khNsC6sGWFA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=GY9H471sDgZY1DAiyWi+rI1xxC2fP6YbtuTjzgp/AZUxg5153tVgre8WPJHW9IwAJ
	 VASw7NexVjHYb6iw+Cqbfw7J6QRGKkjdspazh1Uk2nd2+RchynXcpvI8COKe09nODm
	 hucV1CZCzT/rmLAVNke21rylcZt/SRaSfwVMw4cGHiaWYCcjKi8bCaHF6U+WgQeC0p
	 48Db2xsy0FNZ4i32SSeYWXia9Gp7H8xLCH1FPx0I+3FMsPziQ4vdjVk1fXxDZCIzNv
	 SMFjRvYJ1r/x1/aRBaIq21T5V0oZuFzi2KSq6y5PSD80JqCAP5xxPQh2hqO5Spf2BZ
	 24BnAC2yLGv9w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Mike Rapoport <rppt@kernel.org>,  Shuah Khan
 <shuah@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH 1/6] selftests/liveupdate: add framework for memfd tests
In-Reply-To: <20260310110847.3519998-1-usama.arif@linux.dev> (Usama Arif's
	message of "Tue, 10 Mar 2026 04:08:45 -0700")
References: <20260310110847.3519998-1-usama.arif@linux.dev>
Date: Fri, 13 Mar 2026 10:05:53 +0000
Message-ID: <2vxzldfwf3i6.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: mr1q7eonj65974pptr7xsbi41teuwkqa
X-Rspam-User: 
X-Rspamd-Queue-Id: A4119C0004
X-Rspamd-Server: rspam12
X-HE-Tag: 1773396357-309471
X-HE-Meta: U2FsdGVkX19EQdiODU5BMuvB61RdTUSrcHPcufBEkMeDOBk/0YF8+m7rKz+Cs/tXSTntaF/w3FsVTmN/OOrdMFo6k5UiQgWZ5Iv0939VMiIamJkTd9rm9i/lr4Rnxckg+MJvspV0GeBTRVbLjlSM1GocS3JYHwUgnN5MMi5cBYR7wSxmbJ/GSxYPyI01NKlxsZ4MR+Rk9X3XrrMpO7BaISqKhZ1PzFwXaLLQXjn8iRzU3npTvM0iT7wkyVxo0Lul/amAGvXiVm/IF16MTxmvzvImBgVBlwyiPiPjISh9p557GsKPIhGQ5XLzyHCrrXQ4WECUjJeaaRse9N9XqTniPpI2edYPuOGqpYRQoFXMksPfFb5Ukyqz9787XcAD5iZwdTpwOxuRxeeUE5t02rL3NlbliayJAW/X3BUl+by41cV2TLrx/atvZAzZK+7KihaFWFc9o5ThnDIH9mJTOQpf+6yS29Ucf9/IrEkiiCDA1QFuFBqkVNkdmnLKJJmG7Tm3JAze6RfwAj/jHFIk7YyNQed17DTu22j41gYd9d0K1Wgv3SMpq/G8HAbQ3iTDdxOsQUsV0tNWpGAhJpsRNdOYh24AwW0D0oSVXCKcJscoC8uBkFHCwRCDHG25i5voIDDvy/cFcLoHRYWVIW+tgmChBd7rNk+RGBzMVkoD5AYgcDxmNtHcgzwkZSjt6mKYimS4ZFeuylwnqjdPRzBDatXnlC+iirEdszIMFvTF7IstMBRXNen9WF25v+YJ72eVygfG8/80RJRMRJQvHgwhkaqcYyj0w+5wdpvNyPRnV6U41lWUwvhfX3PemBPfsPcg98HxW5RU7nOrCbEdndy9WmuHtyUPeCvrbFAu0xegOFTRA0zvxTJ8MtzXqg3P8YDhbATFW5fW6d5yJew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10 2026, Usama Arif wrote:

> On Mon,  9 Mar 2026 11:54:34 +0000 Pratyush Yadav <pratyush@kernel.org> wrote:
[...]
>> diff --git a/tools/testing/selftests/liveupdate/luo_memfd.c b/tools/testing/selftests/liveupdate/luo_memfd.c
>> new file mode 100644
>> index 000000000000..b779eee18387
>> --- /dev/null
>> +++ b/tools/testing/selftests/liveupdate/luo_memfd.c
>> @@ -0,0 +1,77 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +/*
>> + * Copyright (c) 2026, Google LLC.
>> + * Pratyush Yadav (Google) <pratyush@kernel.org>
>> + */
>> +
>> +/*
>> + * Selftests for memfd preservation via LUO.
>> + */
>> +
>> +#include <errno.h>
>> +#include <fcntl.h>
>> +#include <string.h>
>> +#include <sys/ioctl.h>
>> +#include <unistd.h>
>> +
>> +#include <linux/liveupdate.h>
>> +
>> +#include "../kselftest.h"
>> +#include "../kselftest_harness.h"
>> +
>> +#include "luo_test_utils.h"
>> +
>> +#define STATE_SESSION_NAME "luo-state"
>> +#define STATE_MEMFD_TOKEN 1
>> +
>> +#define LIVEUPDATE_DEV "/dev/liveupdate"
>
> Hello!
>
> LIVEUPDATE_DEV doesn't seem to be used anywhere?

Right. This is a leftover from development. Will drop.

>
>> +static int luo_fd = -1, stage;
>> +
>> +int main(int argc, char *argv[])
>> +{
>> +	int session, expected_stage = 0;
>> +
>> +	/*
>> +	 * The test takes an optional --stage argument. This lets callers
>> +	 * provide the expected stage, and if that doesn't match the test errors
>> +	 * out.
>> +	 *
>> +	 * Look for the stage. Since test_harness_run() doesn't recognize it,
>> +	 * once found, remove it from argv.
>> +	 */
>> +	for (int i = 1; i < argc; i++) {
>> +		if (strcmp(argv[i], "--stage") == 0) {
>> +			if (i + 1 < argc) {
>> +				expected_stage = atoi(argv[i + 1]);
>> +				memmove(&argv[i], &argv[i + 2], (argc - i - 1) * sizeof(char *));
>> +				argc -= 2;
>> +				i--;
>> +			} else {
>> +				ksft_exit_fail_msg("Option --stage requires an argument\n");
>> +			}
>> +		}
>> +	}
>> +
>> +	luo_fd = luo_open_device();
>> +	if (luo_fd < 0)
>> +		ksft_exit_skip("Failed to open %s (%s). Is the luo module loaded?\n",
>> +			       strerror(errno), LUO_DEVICE);
>
> Need to reverse strerror(errno) and LUO_DEVICE?

Will fix. Thanks.

>
>> +
>> +	session = luo_retrieve_session(luo_fd, STATE_SESSION_NAME);
>> +	if (session == -ENOENT)
>> +		stage = 1;
>> +	else if (session >= 0)
>> +		stage = 2;
>> +	else
>> +		fail_exit("Failed to check for state session");
>> +
>> +	if (expected_stage && expected_stage != stage)
>> +		ksft_exit_fail_msg("Stage mismatch: expected %d, got %d\n",
>> +				   expected_stage, stage);
>> +
>> +	if (stage == 1)
>> +		create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, 2);
>> +
>> +	test_harness_run(argc, argv);
>> +}
>> -- 
>> 2.53.0.473.g4a7958ca14-goog
>> 
>> 

-- 
Regards,
Pratyush Yadav

