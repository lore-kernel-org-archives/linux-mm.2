Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFCD9CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A37486B0098; Tue, 12 May 2026 10:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7F66B0099; Tue, 12 May 2026 10:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FDC56B009B; Tue, 12 May 2026 10:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1CC6B0098
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:04:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 498C616010A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:04:22 +0000 (UTC)
X-FDA: 84758937564.03.C90BE7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 790602001B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:04:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cq2MuUjx;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778594660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SeXyZ2K2XEjBeKwwGeb4rWTFXw2PqWPPbiWdlJeVqhc=;
	b=8kjiNtnWJIPQwiz9j3iSJnZhUHZd+VJY5Z08RJYNoyxbzzwVib5sXoS+BzmqO3Knw9NxBH
	14xVp8pURhgt1d10MCucFAzHMv9OX7AbhMfDLnYGxgvvAZOLp8q4Hol2wkMqLUyeAIgIpd
	WH/c6PoMdDQfTAecPRiKFYwLYROD52A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cq2MuUjx;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778594660; a=rsa-sha256;
	cv=none;
	b=YX74oaZCYUB7JDBPB77gJXWxUkTQJ3zjEm4p2GulNYaL2jiYVLmXR/GabK2SPZ198tKSA8
	1tRTtx2MeH3xugJk4FgXfBB12Yj6FUciKg8sCmrp81p0QABn9p+HZUmzMHh5gyRu4Owuzt
	WBqmly9F45UzTay8dDWsMaTcjkD1o5E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4ACED42B86;
	Tue, 12 May 2026 14:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE51C2BCB0;
	Tue, 12 May 2026 14:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778594659;
	bh=Q8yAjyxfHY28L//mLfMimLlu3G9TMaVuo/gBH1FBvpA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=cq2MuUjxZaaz+oJSEXJdEeDtgTFAJIvx2jPoPT4P6i2bH/XG9P0Onm/6MTLHNcxKw
	 qoLuRi9AHWEatgSAaWFT5oiZwoPK1T5hcGQLdHc+Lg72YDYnVs3g2tzz1MTl1RiiR3
	 C4v1FuubXlphP8LVjCu4oVy53Rjqb12zvaF1rA7/dZ036+hm6IWAne2C34nnB7tcTp
	 auxKGuYUl/ylMxcMga0/vMAqhTqfNHr1cbjup6I/LfIcwOeI2Ylh14yHINQabwAWJN
	 y+kSgpKNsEWxbyTw/oGT1Obf5TzYUoR0dyqv4Xq6fVs201SJt7/HF3JZhvpg4n/SPH
	 nMxBaKQbDnbVw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH 3/5] selftests/liveupdate: Test session and file limit
 removal
In-Reply-To: <20260414200237.444170-4-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Tue, 14 Apr 2026 20:02:35 +0000")
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
	<20260414200237.444170-4-pasha.tatashin@soleen.com>
Date: Tue, 12 May 2026 16:04:15 +0200
Message-ID: <2vxzse7wafmo.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 790602001B
X-Stat-Signature: 6w6mgxhkypjnyrswtd5kehzwxhxh6iet
X-HE-Tag: 1778594660-192000
X-HE-Meta: U2FsdGVkX19QA3Dr5SJglhEPKw5StFdP8WKJrmA+jr9eBVW5OHvu6j62HUTF84ZIy9K/4M3ODzmF6hesqtew1Et7JHdqhFeHu402hv5lrH3B2rIliaCCPiNospS/tP5HIoq//XPGnErkwIKsc0VrbXeLlUe9lPSP2T3DOxbpjcQeK3x7pWG0wdYJnXaD++pxCPm2Zg0aYkf8XDkfMY4vjw/G4mR6tNSZr3zJYHKt1qatan5kZPgJsMbRI9qHjsV0XS6zjmwghRLjA5y1+eaUmzF+Utf00zjsKC6C1PxPBU/k267PEC+gVX5iMp2Mhc/oQctYenaOrQogoZHYKng/x98onsOIB68fWM4iEF9KcZOgPkphb2vg1RWi+ZO+7qKo93tY41E0DdvEBa1eZxmAmIn8lZac4qVXS4K7gdxXvl2Nfe8sZK87GQRF6IdtUgNlTw1s8DjA0ZMAh1UAa078JlqKVKCgTbdYg5LyjEWamqot0PprMsVBqNINBdp0TNZNm8WPzQbJmfcX/q5oD/652lkVGjjVxhT8ST0JEcZOKpgssM1m/ugs56kAB74j608uqOCgBHwRhWWHjgURwI6EWFTuukFowReBhCbZg8rGZdrgYT8+K+Mrgl5kLnUP5bC2Wq5Q+lFT0eCtm/QqqvhMKx0WuJATYVvqRAGkltrtauh5btpkrjITUXLX1esNwo8uVRzqBH3CM4/W68CYNHrEOV+4NrqiDclZZ+xrSUQ4oVIt+Mdzq+e9mYJcmxYK6cDWBZSTdIbDN/fCtgP5P5s/WwNWzektnr2OqUt1CYy5kZnXGVOMEn3sbe5rmS6d+3YDoY6rRTQV8IfPMmw5Rasnc02aXAXEztdFarTRlEKt2zeV5FwUcwJ3sDp6RquXNtHLz2F4syWBVRTb/8WuwcAAduBZj+FLEe20rHrpp0FHCtNWcP+mJCqGVnSDb5zlVIFNthyqhB0pzpjg9p4Qxg3
 vlwYNr9q
 LCJRhWqvWI1FZLRBzYJw9MGEKkQXtGEhOzTP4YBrs+v5ojKH4J5XAi8wsSfu/0mtFBYIGRj448pN9/96z27zvb+5D2QCLHzFru5IuJEjznrPT6fIDbzPXZDUX0EhTpi3JntNv+J1pCFcvkZofzSjW7QtwgCw+2ILAgizwtirUOlUNJMmhTX3dZhLku6tPjgLemWNL8gMjiQa/EnxInfm9HS4wpBnzJqG9qeLCoLfAQye62Ll4e+H2S6mtYzeTEmc97MR9NJh+msKAEnE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14 2026, Pasha Tatashin wrote:

> With the removal of static limits on the number of sessions and files per
> session, the orchestrator now uses dynamic allocation.
>
> Add new test cases to verify that the system can handle a large number of
> sessions and files. These tests ensure that the dynamic block allocation
> and reuse logic for session metadata and outgoing files work correctly
> beyond the previous static limits.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  .../testing/selftests/liveupdate/liveupdate.c | 99 +++++++++++++++++++
>  1 file changed, 99 insertions(+)
>
> diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
> index 37c808fbe1e9..0eaf97b19267 100644
> --- a/tools/testing/selftests/liveupdate/liveupdate.c
> +++ b/tools/testing/selftests/liveupdate/liveupdate.c
> @@ -22,6 +22,7 @@
>  #include <fcntl.h>
>  #include <string.h>
>  #include <sys/ioctl.h>
> +#include <sys/resource.h>
>  #include <unistd.h>
>  
>  #include <linux/liveupdate.h>
> @@ -386,4 +387,102 @@ TEST_F(liveupdate_device, prevent_double_preservation)
>  	ASSERT_EQ(close(session_fd2), 0);
>  }
>  
> +static void ensure_nofile_limit(struct __test_metadata *_metadata,
> +				long min_limit)
> +{
> +	struct rlimit hl;
> +
> +	if (getrlimit(RLIMIT_NOFILE, &hl) < 0)
> +		ksft_exit_fail_msg("getrlimit failed: %s\n", strerror(errno));
> +
> +	if (hl.rlim_cur >= min_limit)
> +		return;
> +
> +	hl.rlim_cur = min_limit;
> +	if (hl.rlim_cur > hl.rlim_max)
> +		hl.rlim_max = hl.rlim_cur;
> +
> +	if (setrlimit(RLIMIT_NOFILE, &hl) < 0) {
> +		if (errno == EPERM) {
> +			SKIP(return, "Insufficient privileges to set RLIMIT_NOFILE to %ld",
> +			     hl.rlim_cur);
> +		}
> +		ksft_exit_fail_msg("setrlimit to %ld failed: %s\n",
> +				   hl.rlim_cur, strerror(errno));
> +	}
> +}
> +
> +/*
> + * Test Case: Manage Many Sessions
> + *
> + * Verifies that a large number of sessions can be created and then
> + * destroyed during normal system operation. This specifically tests the
> + * dynamic block allocation and reuse logic for session metadata management
> + * without preserving any files.
> + */
> +TEST_F(liveupdate_device, preserve_many_sessions)
> +{
> +#define MANY_SESSIONS 2000
> +	int session_fds[MANY_SESSIONS];
> +	int i;
> +
> +	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> +	if (self->fd1 < 0 && errno == ENOENT)
> +		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +	ASSERT_GE(self->fd1, 0);
> +
> +	ensure_nofile_limit(_metadata, MANY_SESSIONS + 10);
> +	if (_metadata->exit_code == KSFT_SKIP)
> +		return;

Nit: This is strange. Why not just return errno in ensure_nofile_limit()
and handle the skipping here? Same below.

LGTM otherwise.

> +
> +	for (i = 0; i < MANY_SESSIONS; i++) {
> +		char name[64];
> +
> +		snprintf(name, sizeof(name), "many-session-%d", i);
> +		session_fds[i] = create_session(self->fd1, name);
> +		ASSERT_GE(session_fds[i], 0);
> +	}
> +
> +	for (i = 0; i < MANY_SESSIONS; i++)
> +		ASSERT_EQ(close(session_fds[i]), 0);
> +}
> +
> +/*
> + * Test Case: Preserve Many Files
> + *
> + * Verifies that a large number of files can be preserved in a single session
> + * and then destroyed during normal system operation. This tests the dynamic
> + * block allocation and management for outgoing files.
> + */
> +TEST_F(liveupdate_device, preserve_many_files)
> +{
> +#define MANY_FILES 500
> +	int mem_fds[MANY_FILES];
> +	int session_fd;
> +	int i;
> +
> +	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> +	if (self->fd1 < 0 && errno == ENOENT)
> +		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +	ASSERT_GE(self->fd1, 0);
> +
> +	session_fd = create_session(self->fd1, "many-files-test");
> +	ASSERT_GE(session_fd, 0);
> +
> +	ensure_nofile_limit(_metadata, MANY_FILES + 10);
> +	if (_metadata->exit_code == KSFT_SKIP)
> +		return;
> +
> +	for (i = 0; i < MANY_FILES; i++) {
> +		mem_fds[i] = memfd_create("test-memfd", 0);
> +		ASSERT_GE(mem_fds[i], 0);
> +		ASSERT_EQ(preserve_fd(session_fd, mem_fds[i], i), 0);
> +	}
> +
> +	for (i = 0; i < MANY_FILES; i++)
> +		ASSERT_EQ(close(mem_fds[i]), 0);
> +
> +	ASSERT_EQ(close(session_fd), 0);
> +}
> +
>  TEST_HARNESS_MAIN

-- 
Regards,
Pratyush Yadav

