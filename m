Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8036FF99C72
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 15:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9044F6B02C3; Sat, 18 Apr 2026 11:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5786B02C4; Sat, 18 Apr 2026 11:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CAB86B02C5; Sat, 18 Apr 2026 11:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6E9376B02C3
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:50:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13C961405AA
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 15:50:29 +0000 (UTC)
X-FDA: 84672113778.04.21A3586
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1D2CF1C0005
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 15:50:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PaREwvgQ;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776527427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/XzWNaaP6trt3AVnYC3KX+BGwZlVeHmz05lVckXapB0=;
	b=5Qvk8kbEQu5TutwVfFZMuROTsT6KeLVRI/O292Fnkk0AdBQQXTc0eEpU73Y7kMIQiqu36K
	pYhcB6hBEPOlqpOalW6Wpdg44tUGkHLiZTGjGynpXJOHhDk3B7sT7x1L3EkZRCKpdaEbwA
	KtFxlwxqvtUsGTcl/2132pGuPgfpfF0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776527427; a=rsa-sha256;
	cv=none;
	b=L7KhAJ1XpBwCIQBfIg4QyzIIBNnT9ut9jKmVIspiq7KF3MB6SmWJUA9s9KDNLI1GOz0PZ1
	jj2QunLBLmIq2iQYMyVClctYldnX8hCSZzl9MxBeIHJ2hVBjhfGJlpcbRrLIHjDVYzMtJW
	nfrokCN3oAs+I+qo1YmpL7Bey6kbS3Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PaREwvgQ;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-50d876329bbso20655151cf.2
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 08:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776527426; x=1777132226; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/XzWNaaP6trt3AVnYC3KX+BGwZlVeHmz05lVckXapB0=;
        b=PaREwvgQvyCwzmtfwOGOhs3pSqhLnimM5hWhTA4MBSl6o6FnXIEwXOgAxcsOib7/b7
         /MT7TNtEjNWNr4FAo/x+JzFufl7/2btjSDOTO+z5AtHH6314N3HXd/1oiEkigfyfsK8b
         GXhDMciR8BHRXwTXNHk9UAbDwrbxAXU98W1vi+c8l6YgnVZU8e231SZA6TVW62qrvusR
         x6kVaZuDQaFH6q2GLurg5FyX2sJnGzV19y7aCvGWAZMNV0La93fMEDL0EuxLe/kokeJQ
         9BTtZFmaFt3FI3KV+C6W2b0a8JwuhcSOPo50onEKOQpW4MQ+mP13dueGobWWSetJ4st7
         gNJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776527426; x=1777132226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/XzWNaaP6trt3AVnYC3KX+BGwZlVeHmz05lVckXapB0=;
        b=fvclFpu8QQ1cdhDYp8/mwA0aNgsULEgYx3xJH/P82noCcfA3XbHgdR02a+NRSLTDYB
         2V+cH2twK+LxgSlJBajQm00F4NrYX+vRPqtEJtN79v4WUAyukImVs55ga8I/oUkRq6ag
         CoSFslsPL/MOdJUlsCYn+0Be5Sa0Sw0J/1HnJu3uW4LauASHp3+C5nr6rZhvzSiibxW+
         HxvbxXNrEgm7BHVnMQORSTU26GOzLn9LVCbNoOc/2+UzcdgVKRa+CRzoWUIY8wr1lr2c
         i5nHLGd7P3kTNTS74f+NRFd9CzmvbtAjFBV/NJ2ZEJ7lVXzYp1DW4Kbyc6ihA5NfeChA
         iO9w==
X-Forwarded-Encrypted: i=1; AFNElJ9HxCFbdJW6N5/crLEp8Pu7TpLEkjncM+3mMNDh5LKUpmx2ffTQgfloBtK/+a1oKVgoxpDQw/akXQ==@kvack.org
X-Gm-Message-State: AOJu0YykW0VkdZN46n0jA0YwrvQpdN8FiVVOIZuJwUDzK5IrfpW/J2Qn
	apCh2zRNfuzzHzFs/N1gnmjg9OkvuLst+zMOUFSIERmT/OAetOdKxaO0qFFGD+jkMiF+/cZeSLQ
	a52Pi
X-Gm-Gg: AeBDietKSiu9HTk4ZQpT1vOUZ+1oXiAaTssmw6Ae+9J+XLH78w2F7JtHX3ZdeOuafvW
	fYjP0fAT/HHIiaXSkKzuR6tTYV6U5a8zl1oZBdk55W/OnjyTz6InzSAKahfGV2MumA3wJ0YHbeY
	7GiaSqMLFjqCWrzWRpHDnYHoHdm0isalcCcRS8XhVoYy8uZXNYYi0iwnaftqRWy2RdbPw9/87lq
	gD0qnw53BX+u5ClYp74orTPVWl3GE3+9XuRGd8F4yWEuv7Lhj51/ML5rFic5Jl76nGSNEjeUeXX
	UuJn8bC9LCkYsKjTfBuYbPa0tx8tZ47a3xc3v7FxWvZ6i0cQMaRA9HLBgPj3Pbh5K02eIcEm3u4
	Y2al97WS8VQxqzaRJ8+LO7plTBHELRc7oLKjFg05uw1XOYYGBJ8cUMI4FP1IkVpnH26E8hL2lgE
	4UnQOx8igQZ/T874BMPE87WEUq5pboIQYa2Uffk3WFocY7IDLsXSjivTu/v/81
X-Received: by 2002:ac8:594c:0:b0:50d:8727:b1da with SMTP id d75a77b69052e-50e36c48accmr112628991cf.39.1776527426038;
        Sat, 18 Apr 2026 08:50:26 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e394addfcsm45648821cf.29.2026.04.18.08.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 08:50:25 -0700 (PDT)
Date: Sat, 18 Apr 2026 15:50:22 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	brauner@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 4/4] selftests/liveupdate: add test cases for
 LIVEUPDATE_SESSION_GET_NAME
Message-ID: <a4jd64pkvamnwuwzu5k762rgn6sgzp6ldcoknkwhuddsrwcbyv@vxwdpp66x7bl>
References: <20260418141123.2193917-1-luca.boccassi@gmail.com>
 <20260418141123.2193917-4-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260418141123.2193917-4-luca.boccassi@gmail.com>
X-Stat-Signature: 4cjeasud5af5ujo5ymc1aua8a9yujf39
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D2CF1C0005
X-Rspamd-Server: rspam05
X-HE-Tag: 1776527426-126359
X-HE-Meta: U2FsdGVkX1/E8kAthB6ODeL7Ob7AR/9hCFJ8l4xlbf9sKFPX/u6Dlht/CaK3EJtFnNyE7cizSkeEUyYR8mWvlRNTltYM2k++lEUEJdxdC+Er3orZ1JtMFdYWcENQa0626L+abQnmIzFCHXfGB0nQg2e0bbQbtrpJmkiF+Q2Q4ihtmyUDQf9AcvjY07kYp/ceLuxbsSCgzC82328UVzeIDdWYRbBV4dk9EtG2mnst1zHaCRcPd4BR1UOgDUsqlJ5XlCiU98QGpTjyIh0ogr66DzSwA3rsVWu3DUD7oC4DvruixLD56wnVNBU7u7gMdi3hp4caR9j8tZZZpF8XWdeDsXD8b54t1MelxaXEQ3Hd3uSgv8arMpbTnhoNd0+iCQhd/7ZPwBBGC7DArUzFaQ83ua2R5vxFq3/Dgh45/dWtomAfW365SrkO9spUjfe1Qm1nNtMlOB4MvdZu+NzctPwd/el7RXxxIOaIeEORitp5Te44OFWK9RQAFwCWLCDtOs1rIwMEOTmA1vCoXL+FuHbnrejTgh/7/77PnNy51HVd+76wYchvvdQRqyr8LTegRKHiy6d1b/w6oYZcYG889iBHX1FlAL85OTExekRjAgvL8skTIz9FnKPlAomMLxYgnjfh9KipAJdBP/t4EAcFsRw5wOmEToylI0ub8W9dlCUvuGm9xcQrqFU6+ClLCU5ylelUCL34f7DnubRNsWZnpMcyPD/sGJi2GzdEFaiucm80xVjvcIhLa638/Jz6Z/teKJDi4W/23HgXyE5j7wcJK3gvR4cMGuFkeccBXBoNRiZMu2uRMRmXBCKhOBtwV2cfZz1Q/OwNxBd82+5kbWgZMCT2Do6/jnI3Zh1A7njPyEGoMVERfgiHAb0bH1pqxvCjA6R4rUhNaJVE5EkOBdcxp4nhco6q8/6vNt98hTV1WzF+1hNw22aIejgt3QZ4PhhaKpOi4TORQUqhMDEoTIaFEmZ
 rNfC4I1y
 6ej1YRHPJQOxtWbpATv5adjQnUYErBqa7sPjcfRYa8L/o+cRrKHk5U1Q0xOvMmCMXMHfeQYy2IREJzRoa4/fXodVRN3V3w/GfaqlV6bSgE+HJp81JERW7qiPD4o1Q/EY5kij1bF7WuqiJcx3Y5BICEL91oC5LnFVUbN3MengN5WwKWJ6kqZCV5JJwn+6bcaGFE2+VgyOI4Erf4S27TikDydlUBh+zxHNyv8OugTt5BvClhmNJGDovIXHpq5BqpTgh1Acqv0mFM6X2w8HIxsj4rzqAvJnUP8Sa7C4+aeTqeSRcS2I7jT25ejMY03EJxS0gQ+SoWSk6O7De2kTcGQkuxzrXLqQ0uS+MksUoLO9ZqjEbh9cEn8nGa+nE6J6Nwm0WpWZaiDG6mgUb9WpnCHio9j7EvEJv5whs1vhARSb+xsz6GHa1TpsdmGwkoZO1IHVbnar6S0TO4uIglfvRZSP1YSPusXZUfTodcW+EoNAJrnSlWGM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-18 15:09, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> Verify that the new LIVEUPDATE_SESSION_GET_NAME ioctl works
> as expected via new test cases in the existing liveupdate selftest.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> ---
> v5: merge with LUO_SESSION_MAGIC series as they both change the same
>     unit test file, to avoid merge conflicts
>     split into separate patch
> v6: add more test cases as suggested
>     more verbose commit message
> 
>  .../testing/selftests/liveupdate/liveupdate.c | 138 ++++++++++++++++++
>  1 file changed, 138 insertions(+)
> 
> diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
> index d132b4685f76..ffbcbd465c9b 100644
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
> @@ -385,4 +401,126 @@ TEST_F(liveupdate_device, session_fstat)
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
> +/*
> + * Test Case: Create Session with No Null Termination
> + *
> + * Verifies that filling the entire 64-byte name field with non-null characters
> + * (no '\0' terminator) is handled safely by the kernel. The kernel's strscpy
> + * truncates to 63 characters, which we verify via get_session_name.

[...]

> + */
> +TEST_F(liveupdate_device, create_session_no_null_termination)
> +{
> +	struct liveupdate_ioctl_create_session args = {};
> +	char expected_name[LIVEUPDATE_SESSION_NAME_LENGTH];
> +	char name_buf[LIVEUPDATE_SESSION_NAME_LENGTH] = {};
> +	int session_fd;
> +
> +	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> +	if (self->fd1 < 0 && errno == ENOENT)
> +		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +	ASSERT_GE(self->fd1, 0);
> +
> +	/* Fill entire name field with 'X', no null terminator */
> +	args.size = sizeof(args);
> +	memset(args.name, 'X', sizeof(args.name));
> +
> +	ASSERT_EQ(ioctl(self->fd1, LIVEUPDATE_IOCTL_CREATE_SESSION, &args), 0);
> +	session_fd = args.fd;
> +	ASSERT_GE(session_fd, 0);
> +
> +	/* Kernel should have truncated to 63 chars + '\0' */
> +	memset(expected_name, 'X', sizeof(expected_name) - 1);
> +	expected_name[sizeof(expected_name) - 1] = '\0';
> +
> +	ASSERT_EQ(get_session_name(session_fd, name_buf, sizeof(name_buf)), 0);
> +	ASSERT_STREQ(name_buf, expected_name);
> +
> +	ASSERT_EQ(close(session_fd), 0);
> +}
> +
> +/*
> + * Test Case: Create Session with Empty Name
> + *
> + * Verifies that creating a session with an empty string name succeeds,
> + * and that creating a second session with the same empty name fails
> + * with EEXIST.
> + */

For the two cases mentioned above, we should implement a fix in the 
kernel:

In luo_session_create(), we should verify that the name is at least 1 
character long and at most LIVEUPDATE_SESSION_NAME_LENGTH - 1.

size_t len = strnlen(name, LIVEUPDATE_SESSION_NAME_LENGTH);

if (!len || len > LIVEUPDATE_SESSION_NAME_LENGTH - 1)
   return -EINVAL;

This change should be submitted as a separate patch in your series.

Additionally, please include a cover letter in the next version 
explaining the overall series. Once the cover letter is included, you 
can remove the individual patch versions from the stat areas.

Pasha

