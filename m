Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 200A61061B1A
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 19:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7F66B008C; Mon, 30 Mar 2026 15:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568686B0095; Mon, 30 Mar 2026 15:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47DF76B0096; Mon, 30 Mar 2026 15:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 36AEA6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:25:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD8641B8583
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:25:11 +0000 (UTC)
X-FDA: 84603707622.11.C3388E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1F61840005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:25:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BtaRypxm;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774898710; a=rsa-sha256;
	cv=none;
	b=Has37He7xW5BrknRihtdV93xhzfpwSXq2zDwczAdUzU1jU8s64Z5rMswRT34EvdQhaH58y
	UC+lEHMs46l7DyNWe7fTKUUnF44lc1vWi+bWl/uEiu/Go/C5l6rB/AT2ZaHC/aag8/rpGp
	SwsLdSkDoPuOAEQk8L6LxVvCqTqTkbM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774898710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ru7TwW1+jWfO+DjWfhI04ncIvaaOAfPAb2TiadJGRpg=;
	b=V8aoGI1hJe9oGV1pQVmW5iEEVGKAGOhgbreXbv6ju7ewpLh6aV9KAVQOryBxBjAtIoSNKZ
	9Qz1KAZ5tZFDOfeJyq52CPIMeSb+njFttFIGnLjonRYOWeNzf/kh7G8njRhE7fAE+kZ0LJ
	oGmssdDe1Asp+ihTk+zsp+tw1JnIuow=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BtaRypxm;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 692A960121;
	Mon, 30 Mar 2026 19:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCF9C4CEF7;
	Mon, 30 Mar 2026 19:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774898709;
	bh=7al5O4bBZZH0Ib7f4duHqDl5oMT2j0Ey0qkepxtrNB8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BtaRypxmtugWdzAkIPgNlu+r2F6IPN9+eyYQCkAZHY9Prh0Y/+QQFjU5BuY2A3fqE
	 6sEtRKcphgS2YYt1OB+02vhGoJV6s0APCsCcZZ5zAT8ECst4QJVB8/COjrJidxgt/Z
	 UUZ0Z+LEOVg7jmJEbMBU86g7icDOE1/+oE2ohpxw=
Date: Mon, 30 Mar 2026 12:25:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: david@kernel.org, shuah@kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v7 0/7] selftests/mm: skip several tests when thp is not
 available
Message-Id: <20260330122507.1dcfa49ab0fd9b58f923bc1f@linux-foundation.org>
In-Reply-To: <20260330151503.670415-1-chuhu@redhat.com>
References: <20260330151503.670415-1-chuhu@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1F61840005
X-Stat-Signature: sgpxxtn6sa8hz3wmxd81kc4q14ndwryn
X-HE-Tag: 1774898709-536547
X-HE-Meta: U2FsdGVkX18Og3QtsozDwaJoKY+kO9mhWQHc+CDdDibqk0XvXfnJcpikiTmiLCtsMBCXEwjv6hALIsKq+fOYocNt9NZuKkRHGB6MwEfxZ0fw2CWT8yJ2PCsFdd4NBsH6p4zKmrDRKL0SFmeul0opKR61jwNnN/ByeeqdmNgUwCXoNug9qrKpE9Hf8fKDUEl22akCsiqahn0cW+hLCMTC+plHHYUVldgEevdnaJB8dhq+pA4wYv/Pk6Hva5bYtn4QUglUDDgRJ158ufIwAizwdUSf/44a6veWS7OmvD/j3UdSDyiXLhQ9bPmbcAY4CM32QEeK/RAhqPhCbLmYz0Lywy1aYlEnlRkqcz1ZjTjQF/qED1kPyzxrDRA0Kz/3wgogIkV4p2GuWfER1yj0Xfod3OJPVCmUxCbMDicRyDqg3LW4Q9KaOlT7vOuNVMc6UTD3H27UHwdoJe7Qbq76qAlksMopNnDmKQFVg084wgmuCS9bguL8kc+mwGEYhBZN3cPLF47B03A+BNxe6Ia8ulVJtF5PobilSv/yjFdA2eeDwnTdOzFEoSDE7vxZB6o9JrR/3TrLfuiPaVcICwz3/91P87sE5Oy3AEfsTlsMKqqdo/ceVMH/rTGSGT/UHwE+biNa62LRBhOpmhLwEvM9ovpGnE4eoFnR3dvagiLuLJ60fmOD1RNYnGxOXYFerhvrHRl+2fvMHUMpjlGYgagIflhstB+XEerJJgEUXS0gqBBTR6OzrSgwTBhzPrrYvabCPcpBYmWCg4rxCTtTVNloRZezC24gxW+WgCe7Jz1/nAqHYXFFSo7Cp6/0AHAf/AHOT3/4Y07m3Bd8rsKtEkMoFOsMgixf/qoW07/wyk1OHhBZ0E7nD6iZ/LFDMfEj4gEbZpZfTu7FUCicRnOPKUNgWSlJP9rZzQluojZ5AWH8Djh/trwrPThlNbstx4OyZSTOnVJsYA2hSIU3N/FAD6y9YFJ
 50f/19jk
 iLyUTym95vVGwqQY55eJNIuh5vFT/9xCbvf2whp9/ax81w+ZI7XkyChYMPjmMLxyAU5kFi4/eyYPXHLcrdfEOwwOSohzXaLmlDuut0thjciGEl0si9arEcrfgDPMxgjgnPDRljCjvEG4EcGEhDygjdCqxRM263dbgPTbCWN3DK4pn7z80aQsuaUB9eJHhqfn70UP0lwcVSu6adyGfxEJhUBn5Kp6/9OEmzbjrJKv9uE9gNOzX1+VbnrueueubmtJ8dO9TkguDq1W70tZjoZJkMLj9DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 23:14:56 +0800 Chunyu Hu <chuhu@redhat.com> wrote:

> There are several tests requires transprarent hugepages, when run on thp
> disabled kernel such as realtime kernel, there will be false negative.
> Mark those tests as skip when thp is not available.

Thanks, I updated mm.git's mm-unstable branch to this version.

> Changes in v7:
>   - patch 1 add reviewed-by from Lorenzo
>   - patch 4 new patch to make ksft_exit_fail_perror variable length
>     arguments
>   - patch 5 change to use %.*s to print the buf when error happened
>     Limit the buflen arg as 2 minimum. Check the error path (numwritten
> 	< 0).
>     And use the ksft_exit_fail_perror to print the logs in error path

Here's how v7 altered mm.git.


 tools/testing/selftests/kselftest.h  |   21 ++++++++++++++++++---
 tools/testing/selftests/mm/vm_util.c |   14 +++++++-------
 2 files changed, 25 insertions(+), 10 deletions(-)

--- a/tools/testing/selftests/kselftest.h~b
+++ a/tools/testing/selftests/kselftest.h
@@ -43,7 +43,7 @@
  * the program is aborting before finishing all tests):
  *
  *    ksft_exit_fail_msg(fmt, ...);
- *    ksft_exit_fail_perror(msg);
+ *    ksft_exit_fail_perror(fmt, ...);
  *
  */
 #ifndef __KSELFTEST_H
@@ -417,9 +417,24 @@ static inline __noreturn __printf(1, 2)
 	exit(KSFT_FAIL);
 }
 
-static inline __noreturn void ksft_exit_fail_perror(const char *msg)
+static inline __noreturn __printf(1, 2) void ksft_exit_fail_perror(const char *msg, ...)
 {
-	ksft_exit_fail_msg("%s: %s (%d)\n", msg, strerror(errno), errno);
+	va_list args;
+	char *buf = NULL;
+	int saved_errno = errno;
+
+	va_start(args, msg);
+	if (vasprintf(&buf, msg, args) == -1) {
+		va_end(args);
+		ksft_exit_fail_msg("vasprintf failed: %s (%d)\n", strerror(saved_errno),
+				saved_errno);
+	}
+	va_end(args);
+
+	errno = saved_errno;
+	ksft_exit_fail_msg("%s: %s (%d)\n", buf, strerror(errno), errno);
+
+	free(buf);
 }
 
 static inline __noreturn void ksft_exit_xfail(void)
--- a/tools/testing/selftests/mm/vm_util.c~b
+++ a/tools/testing/selftests/mm/vm_util.c
@@ -782,21 +782,21 @@ void write_file(const char *path, const
 	int fd, saved_errno;
 	ssize_t numwritten;
 
-	if (buflen < 1)
+	if (buflen < 2)
 		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
 
 	fd = open(path, O_WRONLY);
 	if (fd == -1)
-		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
+		ksft_exit_fail_perror("%s open failed", path);
 
 	numwritten = write(fd, buf, buflen - 1);
 	saved_errno = errno;
 	close(fd);
 	errno = saved_errno;
-	if (numwritten < 1)
-		ksft_exit_fail_msg("%s write(%s) failed: %s\n", path, buf,
-				strerror(errno));
+	if (numwritten < 0)
+		ksft_exit_fail_perror("%s write(%.*s) failed", path, (int)(buflen - 1),
+				buf);
 	if (numwritten != buflen - 1)
-		ksft_exit_fail_msg("%s write(%s) is truncated, expected %zu bytes, got %zd bytes\n",
-				path, buf, buflen - 1, numwritten);
+		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
+				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
 }
_


