Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C14EBF99C63
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 21:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266186B0149; Fri, 17 Apr 2026 17:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DD76B014B; Fri, 17 Apr 2026 17:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B056B014C; Fri, 17 Apr 2026 17:06:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 06B756B0149
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 17:06:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A123516035D
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:06:22 +0000 (UTC)
X-FDA: 84669281004.04.CDBE792
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id B23364000F
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 21:06:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gDqV0l5L;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776459980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Me/r6y+WzPcCjVhGDh2HGIPNUwQfElYLMiSVWgNDfI=;
	b=BxhycFMkfIFtBb9MksPCuVsZ7Mh55qJRVIxzDExZX7J/RM/34cJKSVJ/mK4Q//2QaCgPrV
	Bpj7JlKTVF/0L202hXi//P6FE92cTCrF/4DAA61Gc8GIiB+c6Wz44LwatQY2MCUjejA/Ie
	3/yb3WYE/bciLNyyfqrZxWhU7IYH/l8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gDqV0l5L;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776459980; a=rsa-sha256;
	cv=none;
	b=yIrTDSXD4hqSoM8y89AsyuYHl1WsA65x1DqII3czpbbSyqiTOkMQkNLk3xJ65mROCqOkXP
	VHCWDn43MPNQVxDJ7uAmiFMsZLSWWkt5IoBdhLuVActSf3slGWS4gffHAqxN6jhRqkLF9z
	x0JPcoACubXlehIUWQqwJGArnAUqBlE=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8d68f702851so146300885a.0
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 14:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776459980; x=1777064780; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Me/r6y+WzPcCjVhGDh2HGIPNUwQfElYLMiSVWgNDfI=;
        b=gDqV0l5LkLB9O485Ez9ZKa367lmJTIvC/F5shUDlUHOSFtunij0Wk9QGYhbFun8PFd
         mJCgd+Oh5mvmzEbXdnZy8WNro+8k9OMAw8ktxP+wRqBlTkOg3mm4zPckjwgkYHsW5aTb
         vMxxPBfiLwyfC5SExNR+LJxy8RRAPJd57Dz85oEc4T2r/+lAkdODlxK+a0s9GQ7ol1Qs
         JTqtsKlIzhpBOeQVnaUnReXKhIgiXcW8bcpFToEXZVU/SYURcG5Bw3M20rpTBOQm18LT
         0rUeiL36jK0waUs4qE5GOfDvuZUq7uaUI5Ap8Uwlg6iMkfThc2sJyRa/sobYPYweaMnF
         /6EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776459980; x=1777064780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Me/r6y+WzPcCjVhGDh2HGIPNUwQfElYLMiSVWgNDfI=;
        b=lOXFTZakL93DWCG3q6W3WOiufNENiYKK1IjePnrMkwaIYUktm33QygjiQo5SMb0q9H
         s0idMomA1/yKt/PDqta7zhlussvBhaRkxnQZrkzpH6/wx+QAggrPIGAevg7M6wfYtyZs
         KgTV796FB4Y6TFxww5znWr5z773/O4vE38+AKorBe+6Kc/DkWegdNIPeG34C5TpQiew6
         8CNBXduCuNZLXxiB43XUy0XmLxFa8r7Tk1t1uNYxMITkuTDVtSfklz0jNcx0Q2Gj/UD8
         gYSkkbDqJUfOAwGC4bUNc/Kz2jpNFL9au/+jIzgWwVqELe7k8Z3SGkxd+aexTOdr/zOx
         kIJg==
X-Forwarded-Encrypted: i=1; AFNElJ8kgtyWCWi7BktHabmn4BgPFmwKbyGePX1zLp6wgW7KPgW4gliNNUkxDAYGRlRIsv/BS1xW2IfPEA==@kvack.org
X-Gm-Message-State: AOJu0YwHYMssk6XUieJ/LGoivu9iUdDw31PiaLFLChTpI5Q9nOCe/O5C
	CFNtFm7h6Sr2ellFBqqKSmCFEvvabwu9vAEq2ocH07ZAOPbfE4qewBYLUDDHbMOeSic=
X-Gm-Gg: AeBDiesdiOnyf0h6ud8VGuEfiOZj2Bg/xR4YGB3p00OX5e+fKQUWjE9Q/yZcsmSsZZC
	CTP4dXh4CHIPt8Zt7lKUUxYfXLpWj/hD6Ix7Muy0hluG5E2YwiUooqARUAgYY1cDvuKoymEyiV4
	aI4mtcuQDy6phPf2bH2hQV+VnohG8YJ2pNb2+RxQ/qRVNxuIIBb5hTCrNJaGHEF2o+a50dCx6sz
	UPi4NSlpoWi674E7mzGmtbtw8Qn7ClEHkNq3XFvEnR/UXshAP9xSQN8PPKUeKD7ZnX2FJco/y/m
	Zm0qSNtUYNtjtQ51TAwBPUnUD/+6NQv+DgMJvFfFEoQe6s9lE45hOIYeRD+z3cZFCymFcPRjXPS
	d/csnzsAwArt4d77wI3JrL8ZXDfbNguKZFLSOfxFtCIhw7wRz1fwk2ctk+K+hXcD+bjb56pCTmw
	TuhvPfBYr2v6xuSNAlFQg4LShDZ9raElaAf4QzU/Gzj65+oE/5aTvJgdv70swFnAkgSuX4MaU=
X-Received: by 2002:a05:620a:4612:b0:8d4:aa50:686b with SMTP id af79cd13be357-8e7911ce9cdmr646446785a.31.1776459979750;
        Fri, 17 Apr 2026 14:06:19 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ac68e76sm19709696d6.11.2026.04.17.14.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 14:06:19 -0700 (PDT)
Date: Fri, 17 Apr 2026 21:06:17 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com, 
	rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, 
	brauner@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] selftests/liveupdate: add test case for
 LUO_SESSION_MAGIC
Message-ID: <amspd2iat2hzjf77en5d55wbmau6xyaa4mmxbzjxl5nw5tlqma@lellpiqvrgb5>
References: <20260417205810.1831923-1-luca.boccassi@gmail.com>
 <20260417205810.1831923-2-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417205810.1831923-2-luca.boccassi@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B23364000F
X-Stat-Signature: ye5nm6xgd1957i4hg6cp5aa6jqntfzy1
X-Rspam-User: 
X-HE-Tag: 1776459980-606085
X-HE-Meta: U2FsdGVkX19pVGefYvsiDWH6Cw+YHfE9QyS+F7ZMQKhumDrDyicDj9HhqwZ2hvG8MCpH8aKs16tcvMZlGki4fMRtQ58qv4ewWCwHslyNgv/VvpVrYOXGzQiYjnULcopuFj1DuOUB8Pq/LzBRff+51gCtm+w16i8A4DRgfK2CmNk7BdEU3cLXcU24yWoaMePfocEJCDt7vJhNBxQ3OeSNCTNuBIL8pYGYF8iOHMv/JZsRbFoBE5sDU+4z9sCZzfs0Q46BjCz9F2llsGBUIlU6rC5DvXus2G84TtERjl+q6dfZDRqNmQ20WZMSGTfiH3TJDoOtF2td6o2yT5IwXDT/LZuyE9lIeQYw5DNl3Mvlk9bw1v3Gyp27/Lbq4RnPRErHKXMib+YyQTX/QYIB/momdF33IdSxY8TY/SXwBo3idkQ/sioaQU273ERHQuZVmkaPZPEv6cMlQ24pcyAtuOzMAMpLOmmYskknD1wfGsZI4hpJPYRavvt1ESFKowG3/Fm5qdq1waqnFE074A75hwhJuhW57nPiDMFbsgAO92ik27m/3BvbtHrw6p35fiUhR1RKZru+RWX8LSl/MUY+BiDBrICfPPM9MVC2iR+8W0luwhPE4dCAIg9xDvcmak8qYjZzym3amxKbt3m8/R7c+nfZWTP7+PFwxC9dLzduxjcsUHrwpdj9jZYhlUgZOTLfvosaxlm0LBTVHyvenvidFMgwLpZ+PC6jHgx9++t7/nN0WODgNNbxEIIkW+0Cpx+2vAiIi8v7jvM+VlKuqk/JHncBa2uJuy90Y5Gib4ebbHHbAE7sG6gU6AIc5+dAtL7MWOWQIYt4vrKveyKVbVotUpWYCYExbxSXYTFV+fGbUJYOt4jLtddFZ9p+m8ARVBCW+BaCstXUkpd1ez38j1WDp63a8UYw0J+AFL1HoWQlv4SsmfU0pqyIDWqw9ESwV97bkaeYJK73FA0ls9xjxrI8dfK
 QZh3sqV4
 mktjvEZDLmmu49xNSW8i0w1ZFxno9ifV7cyRya0/387s1H8qCT1GVRxnO4ni1ncot7AY0mHE3jUs6oanWxcPfIlwAFqsfOnLlc2qNYw7MXP9y/0xClPslUuWKw1kLxs3cKteWmYEz2hw9GqfQKkUp1keH/FEL3UbMvvwS13myssUuHSXcgWImtgExSqtkRDeTQW7ed/ANexPb1DexUNIqM/wW18q8tBakINOaPWD50kEHoJZcUp06Fcfi5pGQwdwQ+205ahxYMpCWkYnLqUBW4iC1kM1sgcGd7DMvwHmRY9nx2ZcI/bisbcFan8aEibgXJCgTYFtzNdEweGUOt9bMdAMzNvJ+Pc/ZgeEODUyRnviF+qr9a9zhMbxDJ2IoEFDfeGNt/TjREq1djUKaSU2oatKTUgwnMkbuaIyIV46eomi7nOUfCb4b1VBVy1QeXEIZrQ0Yc5yWbIP+ycOPa/YZuplDUnInXTn+HJ0x18GGXYsmlJx5AMFqlU68Ul9H55+FiaXu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-17 21:57, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> Verify that fstat works as expected after the switch from anon_inode
> to the new magic number.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

> ---
> v4: split test case in separate patch, reorder variable declarations
> 
>  .../testing/selftests/liveupdate/liveupdate.c | 40 +++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
> index bdc1cedc4f944..3c21352f023a7 100644
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
> @@ -416,4 +419,41 @@ TEST_F(liveupdate_device, get_session_name_max_length)
>  	ASSERT_EQ(close(session_fd), 0);
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

