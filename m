Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FBD6F99C73
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 04:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1BB6B0191; Sat, 18 Apr 2026 00:17:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4711E6B0192; Sat, 18 Apr 2026 00:17:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35FBF6B0193; Sat, 18 Apr 2026 00:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 240106B0191
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 00:17:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2725C1A61
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 04:17:39 +0000 (UTC)
X-FDA: 84670367838.06.F5F0F43
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id D93E3140004
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 04:17:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=P6VNMBpw;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776485857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cP27zeRun5nCnbgqutW/rz1GusWQaq6Mzm9A44tQDsk=;
	b=mpCr7yST+Eg+RtW3Ob6dbAY+i/C98dh51Fud7LOy8PlEC0J3ZXn3SZX0F3Gddf5bsFfuRd
	TycVewBJ7kwUCSRqFT0wOq6Xe3qZwQFpLPZzuRLrnPK40UrmtMF4eej3iEUS8AqfA2TbNv
	La56MmyRMpl2RdcsQKgVIfGt967rJ0M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776485857; a=rsa-sha256;
	cv=none;
	b=Wnn7yWBxIqQ4vku+n4+C7Z5l/DA1gRhhy5zh+RKzG4O0KJw9dvTZVogp6EiSaHgZ5pWnO6
	H8iRNOLqJKV5hjMsajd98JMFiCKq5TBpT7PuTDrLBmel+qdyyAxcY8v2RPcYuJ+lCdAJ6u
	lHn60of05kBC2VocgFF7L2MjYVt9aKg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=P6VNMBpw;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8acb09ddbf6so19466746d6.2
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776485857; x=1777090657; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cP27zeRun5nCnbgqutW/rz1GusWQaq6Mzm9A44tQDsk=;
        b=P6VNMBpw6lzR3mT6wmCNTmXhrnD/lhCNd3JnJA0o5w8FRE87UT+wJ/fc6Nj88eR6es
         78LXo+KVhOupSyrwCIw1uYi62IkufZ6EQG5H6EXmOUxCKXwuBuhHWPSL136LAYaLLpvf
         84pAIfGzuFHcr6Qa9cwl9fh8tIDu2cnUVEtKqF7IQKy+D1cAye4YaAClzcffRnRRptfj
         uNo2YtWnL4GRFClRv4j4I8LZB6n7CYVDIbIsI6dRSRFDJsTVtJOsnysLkM/FC0kOgXSp
         sg8a9e/i/2eo8VjQvZUFxwtSj6ITrCN9DS4C8gW/5QOEHPhRt9eXFstBLts2AfiEePJS
         9h0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776485857; x=1777090657;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cP27zeRun5nCnbgqutW/rz1GusWQaq6Mzm9A44tQDsk=;
        b=r9kNwCNluF3Aaa34zQG44x7aBJVIH9QBszfJ+a31KN4ktFyO3r09Q8HnQafQ3g7h5U
         gdAqFOJPV85yd/f31tTUfQtpEAk13F/6xSwmxGfybziykbGYP5i9GX0VrtfHXr+HidMD
         3Zpc0GGVzcK3EjkQhe3TuK+noq9kF+U2R7gs0EAnCc2CUGad8fRtJwlRsa+h34MEYDaX
         gwDxwr71FQMhi1gBbrQkt5fHpQ+l8UKh81PGV/InKnzBkJLYiOplLAb3T3iWYPBwu+h5
         gbIL48V0IqoMDpaxrb2ilyjtWMU2bXTUVD8SFRhoR7umNcxpMLtzNoCN33wwSjAqF3+P
         Ibkg==
X-Forwarded-Encrypted: i=1; AFNElJ93nufT+wNq+DQF0BcJnLgPzsoXPr+JPDSuzmrTqm44QWoOv57cZ6Rr5FK9wLl5qNgpeGlxGMCZNQ==@kvack.org
X-Gm-Message-State: AOJu0YxHWiS7zBLbBmHZDU63oAfzHiqJILzC8a8x92tw8ZHM0l8iUM99
	3VRi6KejSEPpOHB71qY4UizFNU4HUWWI2noVNGSSP4ehxlA6OTPV5XIwgU2QUkKaXIg=
X-Gm-Gg: AeBDieunOGeTxmwSeafGDC0o+vOL8R6hQIQoo7MLWgUH1OkaQUGUEkkccBYTIFxMl/8
	MN0Dgdt/lYmW3Lw1iDEkJ4fWCLO67MJks8uAl5IsPDdmBn+Kk5mB3g6vME9YjLjFac5yqE1Ec5a
	O5q3rIPUHlZdxw4bDg6c4BnikS2wpObkrus8YvmIj71Lma1NQTOmzH6/OX5RqmWau558tLLkvNL
	DMTFld8oVzmKWxDk3PKuNgdGcQM+AJen+RpFwtIcHBvK4i0fTgSbD1OrTh/2i/8Tpzi1x49ifgr
	1FMQZF21LB2mHAuoe7SbWmyH+T0fUBR+NVxNz48PpUFCkRV/fudclgdi2ao9u5IA4zv4un5qXOk
	vSqwi9LTbU5+yvlFTWyIWnbyAAAe0tjAH+fWGv54unfTv3EvWdL6MKcuTnlJ3Cu9wkFry46Lpj2
	FDvFjFarvRvdnbGEuKZCMY2cacRtROHjf+DipOkJGAm/mZNEa1zBSyF3raLUyq
X-Received: by 2002:a05:6214:4f02:b0:8ac:74d7:dd14 with SMTP id 6a1803df08f44-8b028167980mr85768556d6.34.1776485856935;
        Fri, 17 Apr 2026 21:17:36 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02aea5ebcsm26638176d6.44.2026.04.17.21.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 21:17:36 -0700 (PDT)
Date: Sat, 18 Apr 2026 04:17:34 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	brauner@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/4] selftests/liveupdate: add test cases for
 LIVEUPDATE_SESSION_GET_NAME
Message-ID: <qwztxisl7vf3ukjqrv62msq6iaavnru2kyays6ye7rspg2uej2@62cwrsshdxfu>
References: <20260417220831.1934945-1-luca.boccassi@gmail.com>
 <20260417220831.1934945-4-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417220831.1934945-4-luca.boccassi@gmail.com>
X-Stat-Signature: tortrh75itkf3zwt6mm8zjmbg4iw8daz
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D93E3140004
X-Rspam-User: 
X-HE-Tag: 1776485857-361257
X-HE-Meta: U2FsdGVkX1+HjajY1LtTnB2uia8Wjv1QGLbvgTnEeyVyM4nT9UCBS1Ab4vswqfMbQMyB7/deSu/Hx2Rd4iMI7Ac9jVokIDkC1YNbrByeB64KtvOeH65CfUZbZiiLkeOioIAZXgEm8Aw5OHHAZq//L7JcJwBbz1Wxu5al7pt9OvT+o0vX+xFvxMjWxPmXu7QIszIENnZFugdPWdSnAOux/4zZ9us1YigPsAPa9Vt4dwyKSci6kCTLcl4/OkX7vOH+N2sNPVxziaZ667cP3iRpzGf1jXyOmESoa7r5V8GFBdrVlFtgyd2jVrEopghQbxrWKAhXr63wHSa6hkdPsFudRrQ8u7yscaNalg4jdDSYFXXJFNSTDf9J0xFwkjMWzGrFytEb24Xtqs4a/ozkwDBWxqpObao1/UIcHrmEAjkzETMhHfKXee2a+4rnIx+ccdvm1bf9S5DNEO3+j+bw7ttg1ciMkHO20R7BR8b94Ir6sVIqMAnG77jvS9GuHoiQ0ExuN1XBZEscHS8rVJXE9H7jRUbldgsUxLkf5ED/c6JuszzacEN9URaeEq8PpxCWkonMyUERn0F35jGqNoaZ9Y6ZzrweugfjpURY/hG/faNAoni1AAerZhVDQl6u91IWfk5DPGmdA1PODoKj+El5ot7wFuiZe9JlpfcvQabBfsPj1UxKxdOAmCI7bwU1/yjDAhKhBduk4zlg//4UXl5BXZtZy/qAMZQ9v8sXz8T0Izp27H3hh917bf4V4A6sY+YT7jvBeACdedOYv+CNyae50ex44ijx8H0jLjN24RvV/0Qx/OyMZQnQxN3GN0W2xUk9s8hAJ9kABMrzQYxdJ9wBtaK9rdCF2uC0UWgpBtS/Lxs3d0KJHKqhgZ1bzNbKpsPAj05IAOWqd8ttMTwvDMdaMRXYu7sodcEg6YQUrJzYftzuIIMIn2954MHa6B3U73aAv339G93JEV2np38szSa1z45
 123njdMx
 d8ugilhALc6HyfyHYfQsUN0T0X8LTMNxHjbnbHgc83C5YTo6i6hm+58XpuI5w48FD/YB0+LlV8BVXSKZOBB5cXMVj5Yf6r6yBL+VWX3Ny15r7SvFzgyC6lPSc34cO2vm5dD06vbGPJwIjndYnrP2wI3fKulLaZEnXNOHVKAnBpruT7PV7ZEm8akiEtUKKQT3npFZ9Y44SgeNIT4r3EKy0Ic6dcS+gYN45h2SXpJ/uwlorDoap5L1Te67/MY2vJSPM7zvPH8KB1VUBx/7uLLpxCR9K63GRp4orFytlZOjA9YPJAF3VeJ87YcYP8K+ar0PIdUJEpEKR04dVLWzrhPeLC59wTNsD7JeU64Pe7gSyBp7ScBIq3rxbt9rL7dPpnLJJyP1oYYI8kKY8bFA9UAQhibjYKTQDQPo0u/TVMraJ3Lty3F5sfP/wqz4tivlvGBZAHdlfz85/m3AMzZW4OrxxqyrlVrzj/RcRxCfw3ke+MNjKSiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-17 23:05, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>

The commit log is too empty. Please explain what this patch does.

> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> ---
> v5: merge with LUO_SESSION_MAGIC series as they both change the same
>     unit test file, to avoid merge conflicts
>     split into separate patch
> 
>  .../testing/selftests/liveupdate/liveupdate.c | 71 +++++++++++++++++++
>  1 file changed, 71 insertions(+)
> 
> diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
> index d132b4685f767..f81201b363cc1 100644
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
> @@ -385,4 +401,59 @@ TEST_F(liveupdate_device, session_fstat)
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

May be add a few more edge cases: i.e. no '\0' termination name, or empty 
string session name?

Thank you,
Pasha

> +}
> +
>  TEST_HARNESS_MAIN
> -- 
> 2.47.3
> 

