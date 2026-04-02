Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17B24111227B
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 03:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79B2D6B0092; Wed,  1 Apr 2026 23:32:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773336B0093; Wed,  1 Apr 2026 23:32:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6899C6B0095; Wed,  1 Apr 2026 23:32:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 586296B0092
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:32:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F11DF8B653
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:32:25 +0000 (UTC)
X-FDA: 84612193050.12.8392CE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 216171C0003
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:32:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FPYIfzU6;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775100744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iAp+olFaWBoNIEG9IotAMF77yMkjBypMy5GBRb/hkbo=;
	b=n8AASZgGarX8HNl+1EGHs1aNY73khBbmc6VLN3egUtggzDyv/r4UvNkKWppYDZ8+zsfe86
	1NuTo2rvCICAfO1WtR5XRxADTesLocc0FtP3iwUm2OBR7EXqM6DOmtz6OldbUJAqApOxY5
	wmN9sgg9gsSoPVsStpTRQ3FIX348E8A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FPYIfzU6;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775100744; a=rsa-sha256;
	cv=none;
	b=ledUxXjTI+QJZPrzXZT0/wggxmI7VGOWGO5mdv8cuG29skvuNTDHqGlASS4DKl8GLdC+cQ
	l5bR9w2LvSiWm48GKOIHKKA9vNwfEhRHyngQkw3nUQUk6ShOm92Txs+TU6T2z9hn7I/++7
	nj8H4pBr35+d6XVCm90xFU5Ud9yni6w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 28F5D43443;
	Thu,  2 Apr 2026 03:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D80C4CEF7;
	Thu,  2 Apr 2026 03:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775100743;
	bh=2MP/a40KprMuIlnowfOI0K4jOmpx2qWOmDyzhQunkEY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FPYIfzU6oXyMyr9FVChI9F0TI64Va34bKPPujmvrq45d4OOaBz//3vgbSrDG95YhC
	 l7lZG2zZhV+Gfjg7/mBjsLKw61NIpCqcRa3D6BOfx6BxVigMWHGQZjXGPRgW2E8UO+
	 fFNKwPLPVcXvoQECyzNJqlukxpZJSEiNIdN+ycHk=
Date: Wed, 1 Apr 2026 20:32:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: david@kernel.org, shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v8 0/6] selftests/mm: skip several tests when thp is not
 available
Message-Id: <20260401203221.7e192497ba526afe33b9b5ae@linux-foundation.org>
In-Reply-To: <20260402014543.1671131-1-chuhu@redhat.com>
References: <20260402014543.1671131-1-chuhu@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 216171C0003
X-Stat-Signature: mnkkare8cwuz1bab8pd5ouo99xs1jedc
X-Rspamd-Server: rspam06
X-HE-Tag: 1775100743-195756
X-HE-Meta: U2FsdGVkX1/xl+C0RrnsXO7Wb161qV+uRSJfTY+z+zwq8Mn1TNSMYxEyevtZbxZKQFHT0hpeoJ7bm/JAve5f7zcRuBpYQGzL85wFWIOLXGkzb7U0EXqA3n622tIMyLFpW7+VNlG+AqgPymZprsnHtuA2mB1gsquqf/WaeZKufDWs4ljucaVZw89LqY7xPeDXH27KpvZxQYL5mGm3Kh/cTyXAUOE5RWv3w9KQYZ8y/3OfcbvOSKJo2RmhO4N8Ahl9DQhoQH2MtZ+DnAYQOE+P2bsWx4Jx7D+Q6nZQDkAXs9MxQofSVD4JNerAajTOaDOxonJyu7ueMCgbT0oNjMyhyWqNOHLFwYdHmeXJopFrfIKi7H42chxu83sayiPnSHGyrlGJp2xG8kRAxReMzyOKgmWhMOcged5EvMEKx0PVOfoJPBHDssGDI4SpB+MnaXgqDCZ9YS7h1e63c1GC4tmcAoFvEykJFwuQjVhYWwEdngAFzhKdx87viK7cMWguojtjxnF+5yWqCZ+zTBeTsrx4lSLYgl6QM5Y1upEytaO47wkD6H70ehQXsZpKta0MwBAe/SrShzB4YLEnJyOae/OCk39nWEXHG6vJB+h7pfgXAuH8XnEB+lAN5hFrsnUv/Fg7z+wQUIG65J45/8cK8TEF2C1g8B9terX+RxQR4vQGlTujLJd1hv9m0ebjqLMhnasBxP/4Q1PH8irQ4t6wijkc8wizcE+7fPxxki4mMx6SsokMxujqhwEbOoldn2tHTFAbXNULY2sJe5F73DeySwuLk2dovFKmS0OiuWj1MWyaeZK7/rfXcUF8YUe47FlMqDGpHC3qrhMcEX1CkCdsiXuvemk4j2vTx4AkshNyOt28iHrsodIjQmJPAtn1JZTtUgEyDkWdHkds9Y8guswRuj/PSoN+9x3nkqCCjqmyQTRV0cFi6Jaz22bG7Dp4bEia7gy2ziT4wJ/lSY0avoWVqsH
 dRqMge1k
 84fOM+AYLoCrezLpeQKBnEirE3qGBwaGvjPXazSM2vWXf06SRCECtC8ADSmYfxx/yFCl9QU2s0s6NdMwOVmy5Mm+MnoowOR9HbNlPHtWxDQrNOr6JY4HPV49PeC8E/XqtaJLGTTZG/QilfYsE+OBRGSurwn7lj6iFqdUEXwmvOaBD0BdE+gjHpIyNRqyVeBtavSyN26Ix8TiHk8TchVF9gk8uO3+EeviqgUEVLHpBbI+Ic+8wcOvSXc71zJXQ6rnkKPixmRWmTOPkGbwA/jWgdK++aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  2 Apr 2026 09:45:37 +0800 Chunyu Hu <chuhu@redhat.com> wrote:

> There are several tests requires transprarent hugepages, when run on thp
> disabled kernel such as realtime kernel, there will be false negative.
> Mark those tests as skip when thp is not available.

Thanks, I updated mm.git's mm-unstable branch to this version.

> Changes in v8:
>   - removed the patch 4 in v7 (make ksft_exit_fail_perror variable length)
>     as no clean way to do it at the moment and ksft_exit_fail_msg could
>     do by printing an extra strerror param.
>   - patch 4 use ksft_exit_fail_msg instead of ksft_exit_fail_perror  

Below is how v8 altered mm.git:


 tools/testing/selftests/kselftest.h  |   21 +++------------------
 tools/testing/selftests/mm/vm_util.c |    6 +++---
 2 files changed, 6 insertions(+), 21 deletions(-)

--- a/tools/testing/selftests/kselftest.h~b
+++ a/tools/testing/selftests/kselftest.h
@@ -43,7 +43,7 @@
  * the program is aborting before finishing all tests):
  *
  *    ksft_exit_fail_msg(fmt, ...);
- *    ksft_exit_fail_perror(fmt, ...);
+ *    ksft_exit_fail_perror(msg);
  *
  */
 #ifndef __KSELFTEST_H
@@ -417,24 +417,9 @@ static inline __noreturn __printf(1, 2)
 	exit(KSFT_FAIL);
 }
 
-static inline __noreturn __printf(1, 2) void ksft_exit_fail_perror(const char *msg, ...)
+static inline __noreturn void ksft_exit_fail_perror(const char *msg)
 {
-	va_list args;
-	char *buf = NULL;
-	int saved_errno = errno;
-
-	va_start(args, msg);
-	if (vasprintf(&buf, msg, args) == -1) {
-		va_end(args);
-		ksft_exit_fail_msg("vasprintf failed: %s (%d)\n", strerror(saved_errno),
-				saved_errno);
-	}
-	va_end(args);
-
-	errno = saved_errno;
-	ksft_exit_fail_msg("%s: %s (%d)\n", buf, strerror(errno), errno);
-
-	free(buf);
+	ksft_exit_fail_msg("%s: %s (%d)\n", msg, strerror(errno), errno);
 }
 
 static inline __noreturn void ksft_exit_xfail(void)
--- a/tools/testing/selftests/mm/vm_util.c~b
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -775,15 +775,15 @@ void write_file(const char *path, const
 
 	fd = open(path, O_WRONLY);
 	if (fd == -1)
-		ksft_exit_fail_perror("%s open failed", path);
+		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
 
 	numwritten = write(fd, buf, buflen - 1);
 	saved_errno = errno;
 	close(fd);
 	errno = saved_errno;
 	if (numwritten < 0)
-		ksft_exit_fail_perror("%s write(%.*s) failed", path, (int)(buflen - 1),
-				buf);
+		ksft_exit_fail_msg("%s write(%.*s) failed: %s\n", path, (int)(buflen - 1),
+				buf, strerror(errno));
 	if (numwritten != buflen - 1)
 		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
 				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
_


