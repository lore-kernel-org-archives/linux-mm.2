Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D11C4F89252
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 10:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2362B6B0092; Tue, 21 Apr 2026 06:35:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BFDB6B0093; Tue, 21 Apr 2026 06:35:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D6206B0095; Tue, 21 Apr 2026 06:35:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EBED36B0092
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:35:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 99F2B8D1A1
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:35:07 +0000 (UTC)
X-FDA: 84682205454.25.1F00D80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 08991180006
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:35:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fxFNhT5o;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776767706; a=rsa-sha256;
	cv=none;
	b=fY4lu/4z0qzEvPkF+2GtviRzFjlICUSFrRE0UiicjX5ZJc7UORbk1XPdd6457dA2JSYUEu
	xyarF0JeC22+NxhClzVnTXlzNX8zdn4MNETphdC+JuZtPSoVwgqWuLrpQVbX+V0P7XuH5i
	K27JLUtj+CQTpQgxtoNhR7PL0Npw4zo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fxFNhT5o;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776767706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i1Bc2Fsz7ZQWWEshUgp2lyvHER+93je+FBGx0DEVx90=;
	b=hUqAaqp42mfvYlPcJ5NugZbom6lVYWMU/iApu5loUGMrP9py0XftJfMtl356vz+hatqrbv
	FBlU3x7iuL2QBVT86ocN5gYs+kyVkkN/RrKv/APtpl2WMnAw2L+qvJct2zYCeKy+kuSZ2Z
	a0AD+VpQtYc8uiw5OF8bCVJxPxbLCUQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 896946013B;
	Tue, 21 Apr 2026 10:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F2BC2BCB0;
	Tue, 21 Apr 2026 10:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776767705;
	bh=Otx4/28D/avzJk9j+GmtzEbJr9JeUGnkNqWUvmAkEB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fxFNhT5oIpf/DoArdi5DWsQl/Vw0cITuuGLY+OnDTbqapl+Vvr902bX2oA/Sqved1
	 JheUmnmd3Z/zvhKAPmOxliqyx/4oQTv+Mx+U1LXTbe/e4fB4GISVVU5UJnpqqRVycQ
	 gLpAz9t8O2jMQsYimjLHYAUozjs5iggt3NmSuZOXOhgA3qrxyR1uZ3xOdi2o6H1r1E
	 WviXL2QVS3PvUx139LohMrlhOFBvyK26mOutl65/ME2Mb9ccNedXgXfNNizBLWRf/+
	 +GmYVYlfI6Qf57qGBzB2lFtiE1dZYWNROXKR8RwCZ1DUtAgLUfPQID2yZ3RoF7iSAZ
	 l3M2lsNKCK/9g==
Date: Tue, 21 Apr 2026 13:34:58 +0300
From: Mike Rapoport <rppt@kernel.org>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com,
	pasha.tatashin@soleen.com, pratyush@kernel.org, brauner@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 6/6] selftests/liveupdate: add test cases for
 LIVEUPDATE_SESSION_GET_NAME
Message-ID: <aedS0ioK-ab9UB1O@kernel.org>
References: <20260420141741.2688371-1-luca.boccassi@gmail.com>
 <20260420141741.2688371-7-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420141741.2688371-7-luca.boccassi@gmail.com>
X-Rspamd-Queue-Id: 08991180006
X-Stat-Signature: h1oe3sp4uw1eqwikrymk7fw76woqnkfn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776767705-727025
X-HE-Meta: U2FsdGVkX1/ZcVI522u2R/Jlx28I7xUh5aBJN/VAsteVOqXtCs3PpcXXamafadQ4lnKXJHYT/2uxgOgKdRU1gw8FIXFUESBR9pllHF/7TQbHwnKMghrwd6ZWWtmCbGw6G4W4+fks3ahx924GVkW1Tfxkjj0NNodw10V5IOgb4zLlWPAjuvnNBlipvZc2A5iGQEnxS0DcBIUU7jxHsNjo5lfKOCvTfSDPuDZNpNI+1M5e5nT8Jz+0bPvaUIYhJrYbJTGt2dU49w1mOLuu5/J9WYt8YYIu6Kyi76K3eqwypgT5K7YBRO7K1pA3YYTnmr+tmmiW0eEong5R7/n+ex9JYhFxm2JMvUadbU6ZUi9FDBIMKnuMzW9kAiyZEG+hJCxCsO/4uAFBvcb1qRHPvPPpBKZG8fqkgwF/TiASmRZQ16kHH/Oyqmh7IhjCW7Hjk0mIu9YgU4vFCIKaFMGUQOKRPz7gsHvj+rjt1XOdjaKlffQFgfkAXascb2tXxgtrscx6zWbszn6YNXodA+bpamhhNii5LqjSUbB77IC3gbukvZ7nwf8ZiVN6BCeF2yNuvVxPwrILg8BTQmD+OqGEmAmziRHTfjmwt4/xG8eWYFkW8NoL2M1Vid2lyVZKtu4Fg4cp33rUrELT/jdeuacuZSdeb2VgM8qv0Qcp9CMsQYFkI3f/NAyg3vOvfaTWbPS58+FPK1SUu7P+LVOxK2ZpyqSwLP6zQsB+4TgcQVoL2Lph7sTdjgp8mXhprdwMWANTuVF8K1PZyeWRJnzkQHV6T3828lQg5iesYUcXziya6qQFsPgipCvh8S9YbDe/5JyJ2lZMB5u8A1WEA7165p4NvQG1komQQpsEsBvlupXVvwwG3+lAIViFCjYWJUNL7g408Rg2GmOu3ng0onVO/Y3wRqeUU38VZlRHJwPQjzIb1BH1XU+avAa9VVPLZfoeJbxMIXfOziNK6pUPMvaqZEo49i/
 nEh+A6EH
 08O+vjoEz3FPvOuDsxUGcKWKe/JMBkrNuhZ6Jw2xIqRRtpNWLbr6NHOXgdXTfd/FyeSKm3V9rdRm4AaGdEaH+NtiNRrgGBJDMZujBcbrDNTy5ovyrKmNWGyFA+EdBSiW4gELLRNsft8IaXaihA40PdRdspKzJQO8tIcZp/0mA2OGQXTPAYoLCI6AgFbAEm9UrSGefpBc7RBgU3PeszX4WwRr4zKvVNyUF4rb3kl0vH4UY0SgWMTCVMjctBI9TRkz3lvwXphnZ2mPgjHCl89SumoKsDK4mU2CV4Z3MS96Mef2aVCCfFwnbCQ9QbMdiLfD48zv+nfCGp2mRmV+7grnHiTgJ0PuvgVjpdUNh/PIuR4p0P7l6P2cWiBcq+jmnC0Vo7tpxfD9ZCP/2Eja1De42wWCYiBbr94+hbOUVsJKmu5MsY/h3Yqdv4KxTKEUiX06w82Jk7jgdzKa7rrjSCvX1YBmGmladVkDLJDwz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 03:15:14PM +0100, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> Verify that the new LIVEUPDATE_SESSION_GET_NAME ioctl works
> as expected via new test cases in the existing liveupdate selftest.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  .../testing/selftests/liveupdate/liveupdate.c | 71 +++++++++++++++++++
>  1 file changed, 71 insertions(+)
> 
> diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
> index 5e99af0cc6e9..c21354dc9b93 100644
> --- a/tools/testing/selftests/liveupdate/liveupdate.c
> +++ b/tools/testing/selftests/liveupdate/liveupdate.c
> @@ -105,6 +105,22 @@ static int create_session(int lu_fd, const char *name)
>  	return args.fd;
>  }
>  
> +/* Helper function to get a session name via ioctl. */
> +static int get_session_name(int session_fd, char *name, size_t name_len)
> +{
> +	struct liveupdate_session_get_name args = {};
> +
> +	args.size = sizeof(args);
> +
> +	if (ioctl(session_fd, LIVEUPDATE_SESSION_GET_NAME, &args))
> +		return -errno;
> +
> +	strncpy(name, (char *)args.name, name_len - 1);
> +	name[name_len - 1] = '\0';
> +
> +	return 0;
> +}
> +
>  /*
>   * Test Case: Create Duplicate Session
>   *
> @@ -427,4 +443,59 @@ TEST_F(liveupdate_device, session_fstat)
>  	ASSERT_EQ(close(session_fd2), 0);
>  }
>  
> +/*
> + * Test Case: Get Session Name
> + *
> + * Verifies that the full session name can be retrieved from a session file
> + * descriptor via ioctl.
> + */
> +TEST_F(liveupdate_device, get_session_name)
> +{
> +	char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH] = {};
> +	const char *session_name = "get-name-test-session";
> +	int session_fd;
> +
> +	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> +	if (self->fd1 < 0 && errno == ENOENT)
> +		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +	ASSERT_GE(self->fd1, 0);
> +
> +	session_fd = create_session(self->fd1, session_name);
> +	ASSERT_GE(session_fd, 0);
> +
> +	ASSERT_EQ(get_session_name(session_fd, name_buf, sizeof(name_buf)), 0);
> +	ASSERT_STREQ(name_buf, session_name);
> +
> +	ASSERT_EQ(close(session_fd), 0);
> +}
> +
> +/*
> + * Test Case: Get Session Name at Maximum Length
> + *
> + * Verifies that a session name using the full LIVEUPDATE_SESSION_NAME_LENGTH
> + * (minus the null terminator) can be correctly retrieved.
> + */
> +TEST_F(liveupdate_device, get_session_name_max_length)
> +{
> +	char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH] = {};
> +	char long_name[LIVEUPDATE_SESSION_NAME_LENGTH];
> +	int session_fd;
> +
> +	memset(long_name, 'A', sizeof(long_name) - 1);
> +	long_name[sizeof(long_name) - 1] = '\0';
> +
> +	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> +	if (self->fd1 < 0 && errno == ENOENT)
> +		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +	ASSERT_GE(self->fd1, 0);
> +
> +	session_fd = create_session(self->fd1, long_name);
> +	ASSERT_GE(session_fd, 0);
> +
> +	ASSERT_EQ(get_session_name(session_fd, name_buf, sizeof(name_buf)), 0);
> +	ASSERT_STREQ(name_buf, long_name);
> +
> +	ASSERT_EQ(close(session_fd), 0);
> +}
> +
>  TEST_HARNESS_MAIN
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

