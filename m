Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0707DF89253
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 10:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 717EA6B0089; Tue, 21 Apr 2026 06:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8CF6B008A; Tue, 21 Apr 2026 06:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58F256B008C; Tue, 21 Apr 2026 06:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48A766B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:34:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B5FC7E451E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:34:13 +0000 (UTC)
X-FDA: 84682203186.06.76C9306
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1CA81120011
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:34:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QNr3cg9e;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776767652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOVhWn379rJaJvK6pUaaSJtAPJheIjl+VWuC5JneF4o=;
	b=YUdZc35NP366QG2KN3boaerdZjIWGew296jGU5OspbcKwr17S/NgrjOUihekfaW9q0a9rQ
	mur2CYxbUXrc7hDf/SHKSMfgV5kRFVM72oeYIMXp6zzs/Z/sah+1Qtw8uj0XQKYBRjJNqZ
	NYbzB6wnrxjJEiQYdmfWvo+GhB5Mci8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776767652; a=rsa-sha256;
	cv=none;
	b=4uUWZ2Y00zgzpRHbIKImT7dvxWP8IfDW50Dm3j3IeRgLmpjb4QABnFE9iAqELr5UYbWe+H
	7NOlFO1fWo+P3OvwdG1PjsA87Bb9v2IDY5QuVv5fiH9xDHpzanF5Ch2Bl+84a1SdgHSC94
	EKwp0AKiCCiuJfqshlRQqoSYvsoL2T8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QNr3cg9e;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FB3960133;
	Tue, 21 Apr 2026 10:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585A9C2BCB0;
	Tue, 21 Apr 2026 10:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776767651;
	bh=ohwc7f4xvLfkQrWbOMULG7DqY75uoI42N8YjYFEYjwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QNr3cg9eZIJCPpOfr3PFQwsan4XWF3084HZ1dnOQwDda2m94gnDjdXzMlCL89paI3
	 iuU0cx+rB0ztcu9+5GfUBWT9QJUz16ys29akaZEu6SAXsrfq7yFLiMi2opOt4zpUOv
	 GmwGXRmErmI72VWdP/W/q34JAJbnHBcFRgGeJ9lP1AXXOQnFNBxa4o5fS1X3lAeEPP
	 lEgqoyN6ob22X0EcKohnaAmJkWR4pcvdazKl091Q438nUXyr/aM1Q82bhbRUBpmwua
	 O+W1WFR/gKCCs4y7+sdM1txK3R9PMa3uAPyZwRadgBQUZArycZpaY3E2xdnktDu0Nq
	 BEtO4NGuD9RxQ==
Date: Tue, 21 Apr 2026 13:34:04 +0300
From: Mike Rapoport <rppt@kernel.org>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com,
	pasha.tatashin@soleen.com, pratyush@kernel.org, brauner@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 4/6] selftests/liveupdate: add test case for
 LUO_SESSION_MAGIC
Message-ID: <aedSnGnrXwTuDUGX@kernel.org>
References: <20260420141741.2688371-1-luca.boccassi@gmail.com>
 <20260420141741.2688371-5-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420141741.2688371-5-luca.boccassi@gmail.com>
X-Stat-Signature: ke9963usxs4kenknhj5iaup1ndyok8jt
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1CA81120011
X-Rspam-User: 
X-HE-Tag: 1776767651-842582
X-HE-Meta: U2FsdGVkX1/EqheyNAyDZYjYJBC7qNVVIeP8/m346YhTxQVQgk4jUgpk+drDE7L0tWOLyc/xGQt8btMyYlmFAINYTr4mPRW3Uf4l0otey6kVF2tgmVByqiWM1gFdzkq6pkTqqqJQFNrG90YsIBDrKtBnDwYN8fkxRvPuN+PEnMn379dOrVtGEMAjdyIJQJG3Ub7JSSL2PSAPPaELe3OzEnRgd6fLgQq+mR4p132wfUx21+7RvPnWyEu/c0lEQQwfGUV6fBFEm6dxs1e5OgUNkCx0PME7Z9g3uFCVTW7VqI8Uhjq+v6gWa3cxGw+2oY60koR+bFgXqo/ZBUcRoBxLaSA02lZdAdkteZ1zfJcJQt/skY4YLx0JGpTq5Blr2wYF/q4e82ney5gnNZcG50ki+3HKwZ+3cBbZPRTxNmYkaS35REFZ2TqNhoCm7NzsR6b+gWqXFkbqDdPEIqcT4pNRFn9Z+Y8JbJcKMkhrnKCffTu6Wcg03ANGSzaroYa88Dv5oLRVycWFuYXVc9PhVddVpPLj9kSpPGz8aKjyCk4Ehng4Q1OOQLnVEGqwmgDmmTzQcO5VDUhKkO5FI64YdS8fKc2O4YfhluqbMzzBtSiqhY7nUFaq7q5NeR6GRfM/+VbimGWC3OXt/fSIpGkDlUvpd4qloC76g66pvnuffabkb5v14uzIktpO1soFuiFH6wMN33LKrOfiiJf01W57DXJs83tJOZBWjpcdPHFvM7SfPeDG3Cb0RBFeqR0Y0efzIKprqX45GvSo5PFtDNHj/SouI1HzQn4XEx1KlVDrcWmLOpiT7Syz+QdLVVA1FJxtt0ow4jiNekkbc4L35hqdDKhtc+1Gy53or3sI5lpkas+Fb3l0FMiSbDLXDKjs8kNrEjgxh4D+rxYZOmHUpR+F6fCAfKnqssFlssYYk2C94ueU09QZencmuHBYKGqQIfLr3OpUaA3uxEZuEfmYUdwEvxb
 fothGK+q
 gbLk0//9udXrRv/2c8eWkacDVdxw67ezogJ/5w5jw1o7qHb9ctASpCdleuIgqJPqvEKQldmqltP9ivucbuB1vo5hMSMjaRJFKO3jjVFoS5fiM8KV3QR8S42siXN022HQQGh/M/dqpFB96mBgTZRwKHiCUNGsZc4rHcHkGiXKEJMe2xL8Sj9lMSBku4ENTDma61w10Aj/tbApKCKs4JPaxiVyF13CHLkOFWPIh0XzKv7QWfS536hLuN5xqfh4XvZl1vs+hdilNiJu2D397U0n7Q9alnNprlJHLFhk2q4ZizSakXWrdCst5qOojrc+8bbxi9+rH9hXXhJms+0aocIgqzVxcZCWh107dBJYBWJ06wKa10ij03s+1Y4BzpyOEQb4aOme1u+WqPWIy66ie+pkugzTPi6e+FXRyajz/jLK3IutJdbia4eRlBEV7Fh6O7Ez2bpbnsueBoKVTlSD7/JJghxmWLjQXSgqYg196
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 03:15:12PM +0100, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> Verify that fstat works as expected after the switch from anon_inode
> to the new magic number.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  .../testing/selftests/liveupdate/liveupdate.c | 40 +++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
> index f0a8e600c154..5e99af0cc6e9 100644
> --- a/tools/testing/selftests/liveupdate/liveupdate.c
> +++ b/tools/testing/selftests/liveupdate/liveupdate.c
> @@ -22,9 +22,12 @@
>  #include <fcntl.h>
>  #include <string.h>
>  #include <sys/ioctl.h>
> +#include <sys/stat.h>
> +#include <sys/vfs.h>
>  #include <unistd.h>
>  
>  #include <linux/liveupdate.h>
> +#include <linux/magic.h>
>  
>  #include "../kselftest.h"
>  #include "../kselftest_harness.h"
> @@ -387,4 +390,41 @@ TEST_F(liveupdate_device, create_session_empty_name)
>  	EXPECT_EQ(session_fd, -EINVAL);
>  }
>  
> +/*
> + * Test Case: Session fstat
> + *
> + * Verifies that fstatfs() on a session file descriptor reports the
> + * LUO_SESSION_MAGIC filesystem type, and that fstat() returns consistent
> + * inode numbers across different sessions (shared singleton inode).
> + */
> +TEST_F(liveupdate_device, session_fstat)
> +{
> +	int session_fd1, session_fd2;
> +	struct stat st1, st2;
> +	struct statfs sfs;
> +
> +	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> +	if (self->fd1 < 0 && errno == ENOENT)
> +		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +	ASSERT_GE(self->fd1, 0);
> +
> +	session_fd1 = create_session(self->fd1, "fstat-session-1");
> +	ASSERT_GE(session_fd1, 0);
> +
> +	session_fd2 = create_session(self->fd1, "fstat-session-2");
> +	ASSERT_GE(session_fd2, 0);
> +
> +	/* Verify the filesystem type is LUO_SESSION_MAGIC */
> +	ASSERT_EQ(fstatfs(session_fd1, &sfs), 0);
> +	EXPECT_EQ(sfs.f_type, LUO_SESSION_MAGIC);
> +
> +	/* Verify both sessions share the same inode number */
> +	ASSERT_EQ(fstat(session_fd1, &st1), 0);
> +	ASSERT_EQ(fstat(session_fd2, &st2), 0);
> +	EXPECT_EQ(st1.st_ino, st2.st_ino);
> +
> +	ASSERT_EQ(close(session_fd1), 0);
> +	ASSERT_EQ(close(session_fd2), 0);
> +}
> +
>  TEST_HARNESS_MAIN
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

