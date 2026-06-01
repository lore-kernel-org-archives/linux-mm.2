Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D664CD6E57
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674E36B03C1; Mon,  1 Jun 2026 10:17:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64CA66B03C3; Mon,  1 Jun 2026 10:17:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562B46B03C4; Mon,  1 Jun 2026 10:17:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 455D56B03C1
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:17:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E59111A0685
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:17:25 +0000 (UTC)
X-FDA: 84831546450.25.225C2C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2A91D1C001E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:17:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bCsLsbpF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780323444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2hF44QBQfUGRJ9iAPSXn6oHYpoPJZaLfD83FbTWLpNs=;
	b=kemnQ/xcOwgOlxLdV4FHKG0VkpJ+bbMri4WabTmiGEPEag88lenKjPxo0fv+57M6T/6C+M
	TsYxxEmnVt2kusITM1CRj87jNG7bnG4bcm5iDUReqkO9Rr70LJMNTyO/7v/qjgbUNnLuQJ
	cAX9bldRpEY/F3rnaIxpKGg5BYyswXs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bCsLsbpF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780323444; a=rsa-sha256;
	cv=none;
	b=NWdE9u707RnSR8aIUubRg0bxqSYbTA/8dQ1gErOAVwq2wYrnqGchVSrAQ+650WVx74thWI
	fnHxkWkvMAXCgBQsSAHzxBmnroxQBkeGYQN8YMQiUEZqygwdfK+qzaBTY/TMADSqjPEhBc
	TP8bZ4Dfn8aUG6ZIeeZIbfj6PsIht7g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0BB66014C;
	Mon,  1 Jun 2026 14:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34081F00893;
	Mon,  1 Jun 2026 14:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780323443;
	bh=2hF44QBQfUGRJ9iAPSXn6oHYpoPJZaLfD83FbTWLpNs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=bCsLsbpFf1I2jIhql6W7+uBxnx3jEUKFN5cFzZWZo6CIsF+hI2WutwsDUEbUPviJJ
	 oRV9Ueh2aOziXxB+xBQbTl8qQi1ygOSeQJn8sPgZBnp/q98drLJgRrzSjs2sZjUbKp
	 dWl9vlcRbvItA9+hdOCEXt95ytfWSdkos5XeWE20pDKnlXw1iL3XPENRPNKj8d95g2
	 Y0z9UgPbkn92Elp9yfffpJnylqQ19mbq3+h1N9eeOxp0e8itjuXTZ0bk+knwrzEVe2
	 Vq7KfwOqmH1gpKR3r4zRdBtwkSC7N1g01XBW3ixKM6x/rKTI0vf6+uV3xT26yDU7C0
	 SXGetPm8P9v/A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  skhan@linuxfoundation.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  corbet@lwn.net,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH v4 11/13] selftests/liveupdate: Test session and file
 limit removal
In-Reply-To: <20260530221938.115978-12-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 30 May 2026 22:19:36 +0000")
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
	<20260530221938.115978-12-pasha.tatashin@soleen.com>
Date: Mon, 01 Jun 2026 16:17:19 +0200
Message-ID: <2vxz7boifiq8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: nega9hrtko1f9w8zejx64f4swrh9qz5a
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2A91D1C001E
X-Rspam-User: 
X-HE-Tag: 1780323443-568382
X-HE-Meta: U2FsdGVkX1+oToM37T69NjoUhIyl1N8zsmEUj87gu4FT99NwETAQnxCLeOpZPtlCMoKvSvf0GfDuPKNqGf7Rt2rbDuQsAkobUDvaGFe2eJ0VDh2vxBGIKeUckMplvFOYvOkQYTXtSf5Vv+nxETzoy+flbMuKwCKWFSJ3NT4fYctmBv0d4/xd9dbwaSNVwg7daM8WzgoCnpiL+BX+0kyhHD3meb/Z89/oebVdfvQBnbSnV8tqgrB6aT4pXygPI+t9UagR6W8VH+Lxcn5u4yxKdykfabkeFWyH6fxiKmB3EBqRsCuDLFOiP6bde4moUsUL7/vf0CUCQc7yAuLSol2YkNLfdMnKvINzq5jkTN/XqUek+BSYQvI52FH4isvzAGam1Fh6ObGcArruLA+6xaBG8BWCd/p/tlAakXuK+sYQxpbXdjVPoN6DkW3uoBLZiYg6QLCVODyRDUpX/Ey/z9upv7tKylGYq+4LrUpSAn/iZqgGG7nB79a68nb+7cKjRDOuaDFdmOXWxVs1ARbtXNVTNVcwZViARO4wSBYEUnuNY4wv+DFMzFlVNJwGcRs4TX+mB3NupjaTYO23lXMcVdU81nKrcHhDdD3lR7lQvLE1lojz5+yIQ2z6eYWykej5rE/dPKFC40PGAFDkZGhcR7kNf9T1OuFm7hibNB7roe13qd/OVqDdMdpQ7I7HH7GmsPkcp6AIXZslph5i8eZKyf94WCIkTJlLGRpA+FFuFKXlNSL+xELyIlV4bfgVErK8SlNnP8B2PjRl+RScdBEjTrybWWVwuAHu7qkKxac0l9CefPgX4/49g5xPSCEmlcWzm6bK34u9RGl0aSvs5amXiSrhRjUdK+m9+DaJLrXlkuzaidN+SKic9mz4VtnH7JcaU4z9XbCtm8hJJ7xNTP0ndlwUkMMwpgBurSC3I0wi296LdbStLCP+ELnWwfZZ3IDZbFuwq+1CwRIdCIYoQ80s4SZ
 vnTdM/4b
 BF0E1Yo2fMAkaD/awo2ZYiIpfdm/HGiz1dOJg3tM4OYYYxcATewn1nmu7JEYrtaSa4WU15m+DSsB7dWdk+FLDjU0tTSceCSyCDjJu9gbhmCSV68N30uXm+opbML4KZqLUmRpb/+GIIRXzfSdmTpqBJnJTtZBpl10KEUKXxn1rT+e2tAa3hjgtEv0GLVGocZb8AbWuxNWWYZpcavkVZjADbwi6vy1qQfRyuWWgivaOem3hk/UzGUOmqISHdHUhjmcOQ5Kl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 30 2026, Pasha Tatashin wrote:

> With the removal of static limits on the number of sessions and files per
> session, the orchestrator now uses dynamic allocation.
>
> Add new test cases to verify that the system can handle a large number of
> sessions and files. These tests ensure that the dynamic block allocation
> and reuse logic for session metadata and outgoing files work correctly
> beyond the previous static limits.
>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

> ---
>  .../testing/selftests/liveupdate/liveupdate.c | 75 +++++++++++++++++++
>  .../selftests/liveupdate/luo_test_utils.c     | 24 ++++++
>  .../selftests/liveupdate/luo_test_utils.h     |  2 +
>  3 files changed, 101 insertions(+)
>
> diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
> index c7d94b9181e1..502fb3567e38 100644
> --- a/tools/testing/selftests/liveupdate/liveupdate.c
> +++ b/tools/testing/selftests/liveupdate/liveupdate.c
> @@ -26,6 +26,7 @@
>  
>  #include <linux/liveupdate.h>
>  
> +#include "luo_test_utils.h"
>  #include "../kselftest.h"
>  #include "../kselftest_harness.h"
>  
> @@ -499,4 +500,78 @@ TEST_F(liveupdate_device, get_session_name_max_length)
>  	ASSERT_EQ(close(session_fd), 0);
>  }
>  
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
> +	int ret, i;
> +
> +	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> +	if (self->fd1 < 0 && errno == ENOENT)
> +		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +	ASSERT_GE(self->fd1, 0);
> +
> +	ret = luo_ensure_nofile_limit(MANY_SESSIONS);
> +	if (ret == -EPERM)
> +		SKIP(return, "Insufficient privileges to set RLIMIT_NOFILE");
> +	ASSERT_EQ(ret, 0);
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
> +	int session_fd, ret, i;
> +
> +	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> +	if (self->fd1 < 0 && errno == ENOENT)
> +		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +	ASSERT_GE(self->fd1, 0);
> +
> +	session_fd = create_session(self->fd1, "many-files-test");
> +	ASSERT_GE(session_fd, 0);
> +
> +	ret = luo_ensure_nofile_limit(MANY_FILES + 10);
> +	if (ret == -EPERM)
> +		SKIP(return, "Insufficient privileges to set RLIMIT_NOFILE");
> +	ASSERT_EQ(ret, 0);
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
> diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
> index 3c8721c505df..333a3530051b 100644
> --- a/tools/testing/selftests/liveupdate/luo_test_utils.c
> +++ b/tools/testing/selftests/liveupdate/luo_test_utils.c
> @@ -17,6 +17,7 @@
>  #include <sys/syscall.h>
>  #include <sys/mman.h>
>  #include <sys/types.h>
> +#include <sys/resource.h>
>  #include <sys/stat.h>
>  #include <errno.h>
>  #include <stdarg.h>
> @@ -28,6 +29,29 @@ int luo_open_device(void)
>  	return open(LUO_DEVICE, O_RDWR);
>  }
>  
> +int luo_ensure_nofile_limit(long min_limit)
> +{
> +	struct rlimit hl;
> +
> +	/* Allow to extra files to be used by test itself */
> +	min_limit += 32;
> +
> +	if (getrlimit(RLIMIT_NOFILE, &hl) < 0)
> +		return -errno;
> +
> +	if (hl.rlim_cur >= min_limit)
> +		return 0;
> +
> +	hl.rlim_cur = min_limit;
> +	if (hl.rlim_cur > hl.rlim_max)
> +		hl.rlim_max = hl.rlim_cur;
> +
> +	if (setrlimit(RLIMIT_NOFILE, &hl) < 0)
> +		return -errno;
> +
> +	return 0;
> +}
> +
>  int luo_create_session(int luo_fd, const char *name)
>  {
>  	struct liveupdate_ioctl_create_session arg = { .size = sizeof(arg) };
> diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.h b/tools/testing/selftests/liveupdate/luo_test_utils.h
> index 90099bf49577..6a0d85386613 100644
> --- a/tools/testing/selftests/liveupdate/luo_test_utils.h
> +++ b/tools/testing/selftests/liveupdate/luo_test_utils.h
> @@ -26,6 +26,8 @@ int luo_create_session(int luo_fd, const char *name);
>  int luo_retrieve_session(int luo_fd, const char *name);
>  int luo_session_finish(int session_fd);
>  
> +int luo_ensure_nofile_limit(long min_limit);
> +
>  int create_and_preserve_memfd(int session_fd, int token, const char *data);
>  int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);

-- 
Regards,
Pratyush Yadav

