Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43114606A328
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 18:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=pmzTkt34
Received: by kanga.kvack.org (Postfix)
	id 64D956B05B7; Mon, 26 Oct 2026 14:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624ED6B05B8; Mon, 26 Oct 2026 14:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53B046B05B9; Mon, 26 Oct 2026 14:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2366C6B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:06:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94EC0A0829
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:06:28 +0000 (UTC)
X-FDA: 85365557256.14.7A9F90E
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id D34FB1A000E
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:06:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pmzTkt34;
	spf=pass (imf19.hostedemail.com: domain of parri.andrea@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=parri.andrea@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793037986;
	b=4b+dklqRWjogrDBHcrwevO5nREuAnURJ9BO2VjfQmowHBd2Js460+2eRMmosl+ienBl0TQ
	wl7JbxBjjJ40sr1L/GOyfbWPYDIZs31TVZjCa6mkphPreExhDYOlA1RG8qMIt6vz6apOf4
	6K1Uy7OVEHnvZ3zPOF/TZvPh2xOoiVY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pmzTkt34;
	spf=pass (imf19.hostedemail.com: domain of parri.andrea@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=parri.andrea@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793037986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xHfjRrcnHq0gMjmE8KEiw2pb4RTHUukE8vXn8oTU6AA=;
	b=ugHxNc8psXg7XC+JWyHebge+YyskgmDkkxzKzptmz/Okjbqjb5Tedeye786PJILGVdUna1
	rRj08T6lVP9firR54cjiQHQpQVZyTzRHlsIsKtkYsT5UeeFi1guyEm+H0IiFk4yluPyhaz
	cT/eCTHu2gaPcixE/+2srCRKcmuziio=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48e0d885929so2202326f8f.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793037985; x=1793642785; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xHfjRrcnHq0gMjmE8KEiw2pb4RTHUukE8vXn8oTU6AA=;
        b=pmzTkt34ZajCwuZqucqd/LIfqSqo9vMBH/tqfAqZiCPrmazvlQQ7H6lXUfKmng9jB7
         zQpcQ+jUNezeMGBEcwvwokgxGnLcXYfux0n8jUY31iV5vQqao9oflUS3aNFmYZhuAxRg
         8+oByG0NalbRtki9BQl8UhnSWORzspy8XPfl9ru4iFc8HZ82VtKSttyuMPBLCt6PxgEi
         kmBT7Vz+kDI+vc+DejdKetf1E54Y3hU9/rj1Qw45WRn6CJAOc0WWv2QyKBQZbKGhPuuL
         KGPiej19jXvuwWqFYK0sK2cB2HiouxubMp4LiH7qW6X9oXlcq2Un5oNMCSFRPmr6WxmQ
         TdxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793037985; x=1793642785;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xHfjRrcnHq0gMjmE8KEiw2pb4RTHUukE8vXn8oTU6AA=;
        b=I8KU1vFcR6H/7Vw8BXIYNQLBhanD/eim9NflQHiwNY4MW/SPVBgUhr2mcclVOaXIkW
         6NQsc4B3kpzI1JS6rqynRnVr9Swi9Vacv58Su4nAHSZoGP78c3jYKuFlF8UmlFx39dFR
         H4MPiGO32oD6ZonANC/hRfwSR4X75H1uHq6Siv3TzZa7CwfdadJXdrGHMQLmgH0SiG8Q
         r+E0ZL3dMGJNOOX6ugIgMhPa3B9ZBn8iC/Vth1a9EbPETOJKK643NzrixYidIHhgjc5p
         jNWY4GGXudBtmqwvjzRLCl3ud0COcKybPs6nPVXa+QYZsfSGihYfM34j3Sf7Tob29Fsw
         qVTg==
X-Forwarded-Encrypted: i=1; AKwUvBwZnhR6U7hsYCdayjBIQs1JzwsTVw+jzupBgmTRamW6rQRCfXLpernKW7ao5xNPN3YOxtBt653scg==@kvack.org
X-Gm-Message-State: AFq9FYI0QManRTMSlN3mJ4GHCS3X7U4rv5nxyfOVHWiW1N1oIaSBauDg
	CFUkyyItYxAnEIo0NK1hNShoG9lPIGg8PVTNemZosWk08UNj8jsqw+fA
X-Gm-Gg: AYBFou2hVakkWcyBzrWWFBJoSSVGJH4PBP8xvsZWs4sb7SqURFrpc4q+44Ub+EclmF9
	5+vU2+5fCPIDRVihyLI6uaBvuZCqtxdYUPeBWXjmlI5fPTKJj3MAGx+MV6z5yvu8BelW65utLno
	J9IwQkIvEhnf2u7bKxa7wgY9jgoosemrzeIF1kmwggDGNcPa81sHcL8ZgSa/xcMeUEpdDhSlI1T
	cJ9VCKSZZk97n+KO3iuapzqm4VNhRREzP9fQAoEIkDJKv6TaNvUzXBvO0jGfwEYlkZaD17wR8EC
	PIB8GkpSyWmVZRhFey0EDCk5gIpDyr/JjvHo1+HtR/ghLpZuzdm+HqrkXrxMQWFVFjNh/vwobrd
	WqwTptNC2jkYbkOmk8sfUYmDVdf2LqqHLqJqCcN1+k16h9mARxIy5xQ/1zpOXcNq6wbxHXM3QWC
	L2PSffvfSDEoONfedPYu91iwQXxJJaQjy7xQOlRyZtsxplPrzrU2UwLA7dawGRNF4nrcUTphbyC
	7FptRQcnsMT0FN9xr1ypLNbio6uLuuvYwsMEd+Lv/gQDgfCdLWKjsCISUtkMxCDQIKEO+N5d6Kl
	he9e6Q1/600ZCCvINLxy3nA+HPA=
X-Received: by 2002:a05:6000:2405:b0:48e:517b:cf21 with SMTP id ffacd0b85a97d-48e517bcfedmr5799152f8f.26.1793037985247;
        Mon, 26 Oct 2026 11:06:25 -0700 (PDT)
Received: from andreayoga.wind3.hub ([31.189.109.255])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebd48fasm17694846f8f.31.2026.10.26.11.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 11:06:24 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Andrea Parri <parri.andrea@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] iov_iter: take an unsigned long segment count in import_iovec()
Date: Mon, 26 Oct 2026 19:06:18 +0100
Message-ID: <20261026180619.4147910-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D34FB1A000E
X-Stat-Signature: 5kdxqfr1z6o89u3p7gp81x75d5xj4ydj
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793037986-833373
X-HE-Meta: U2FsdGVkX1/6gYs5QSGn8mz9i81FhCODWPaErSML5n0g5mRXKlKWACLCL9uGYd0LVH8USyCW7/1PBaN8teqcAXXtmdbP91utHasO27NJz+SbRGWZpBPzLdluL7xD30l3OP9VaqsXMaOiixZY2b9M73MIbVqTE5HCqi4OI1chmrR5i4uO5zUv15NH0AB0Us9iTQFL6JD88p17VgHGLXJLXzAsqH0e1duGDDe7cXpEbdJ+dKhOBtNlQVFEFxTNSxZJI35Dk0J9bw0w0oQqcvYdae7SFWxmWuC3HXSDq0xcAm2BL11h1VRpoqA/vr+9mvoItaUwleY4JyMMiBO7AmfhbF1VbqdKxXGL14OqZTsibZCpRItaDjVxNmKG/MNm+VEsNe8hITHybdjw3dGWDuBQknQ5GId6I3cyIlhSK01bj1BkJde4HEujUewRDeEQ2jTPH489FhvnUb3FRQjruZA/2PPoljxjjeMbkBegxcRNGBhRdX0YDj/8rB2EE2nFXtIe9Jq5WbqymvTuun7otTTBtTcycVFbSdwGO+y1P3HZET+M1K5ZS9S/lfv8jF41Yjril3UWMfG9wgwcSojVt13APIt7XsPsxRueAUekqXcZxb8yix/lzD2Cpx/JM022xiKWEBMuK0/StslKc2lAnUeyCR1IafGEGeFPD5ymIJ8qzPbYhnX1/oivjY/7AFhCgDRGKE5PzCaP0DA9H0q9SYGrUdeglfnEpotSgpkAnH5JSQBHKzySgXBu63w3Z7mti3Nc/kw1p4b/czxrQ74A4IWe3CpkUxJjhwuRGA0YyU6RUB8ttCFAV7HwkLeSe1XI1xr07Bb13lMfLQf4ehXCyv5UGVA/pYc5dbdJXE95HeVeQB6Ilfr9xpOhNM8cBlNFHxQJcQKHHQVw53jNNvu/DcvbmsoErpcSflNGcwVbwa1wktVUwlkOgRYiAjycflRVKSrdrxX8nfzoMszq/PGYnZG
 DpBXq9FC
 rf00qIC/1+c1JRYPCJkgAl4ry7kf+6jDsP8OdTvy/LsPfc9wRb7cLGtUKVF/jYpBPuVH73gnHswfaPe4z/9FMx29sPX3dB8chwfAAAvWzTxwq1cXcRe6ysyqmW/cL9SewkPo5EyDtjkj3AQFpiyDoCAjrTc64u/zSZ48v8PU5qCyIW8I+oxn3dgT1/4pMJc/qItlZBUCFQK6pwhKh0V0w9CDy3ex0kOeFY443WLLqe3/4ew1wlLSjmU3lbEOpGZJzpOGlr3/EdCxVJH3Y77+A2DCBHFHI0K/LMPcJA6TYp+wIHAoo8vbFqZW2j1LdfPpZxfDDhzpdpzzfY+f1xRZKvQVX/IkLyJoHigEggTLL3/E8RQ9VtQqIsCziVuanDw/F4MsJU0xaUjmD03qcFwRiO2AujliJvnGlQ88/qLFvuGpcDBnosGGNyuQXaG4JLjUaCSazq2iW6vecahQfCgub9dus4W/AgFqFFmcV1XZTnaMKDwaKy+KBR7lNOArEYMwJJXlzJmb208UlbwGkrXh1KpCvEPSX8s+vKadd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

readv(), writev() and their positional variants, process_vm_readv(),
process_vm_writev(), vmsplice(), process_madvise(), vectored aio and
the btrfs encoded I/O ioctls all take a full-width segment count, and
all of them hand it to import_iovec() or __import_iovec().  Those take
an unsigned int count, so on 64-bit kernels the upper 32 bits are
dropped before iovec_from_user() checks the count against UIO_MAXIOV.

A count of 0x100000001 is therefore imported as one segment: writev()
on a pipe writes a byte and readv() reads it back, instead of both
failing with EINVAL.  A count of 0x100000000 returns 0 as an empty
vector.

import_iovec() was added with an unsigned int count, but the helper it
wrapped, rw_copy_check_uvector(), took an unsigned long, as does
iovec_from_user() today.  Until v4.1, readv(), writev(), preadv(),
pwritev(), process_vm_readv(), process_vm_writev() and vectored aio
therefore failed these counts with EINVAL, as did vmsplice() until
v4.18.

Widen nr_segs in both import helpers so the UIO_MAXIOV check sees the
count the caller passed.  Callers with 32-bit counts are unaffected.

AI assistance was used to find the bug, develop the fix, and run the
reproducers.

Fixes: bc917be81059 ("saner iov_iter initialization primitives")
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
---
Tested on x86_64 with virtme-ng, base 734bef548a96e vs patched:
readv, writev, preadv, pwritev, preadv2, pwritev2, vectored aio,
process_madvise, process_vm_readv, process_vm_writev and vmsplice with
counts 0, 1, 1024, 1025, UINT_MAX, 2^32, 2^32+1, 2^32+1024, 2^32+1025
and ULONG_MAX (LONG_MAX for aio).  The base kernel accepts 2^32,
2^32+1 and 2^32+1024 on every path; the patched kernel rejects every
count above 1024 with EINVAL.  Also built every caller with
allmodconfig W=1, and lib/iov_iter.o and the readv, vmsplice and
process_vm callers with i386 defconfig W=1.

Reproducer (64-bit userspace):
  cc -Wall -Wextra -O2 repro.c -o repro
  ./repro

// SPDX-License-Identifier: GPL-2.0-only
#define _GNU_SOURCE
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/uio.h>
#include <unistd.h>

int main(void)
{
	char source = 'x', received = '-';
	struct iovec wiov = { .iov_base = &source, .iov_len = 1 };
	struct iovec riov = { .iov_base = &received, .iov_len = 1 };
	const unsigned long count = (1UL << 32) + 1;
	long wret, rret;
	int pipefd[2], werr;

	if (pipe(pipefd)) {
		perror("pipe");
		return EXIT_FAILURE;
	}
	errno = 0;
	wret = syscall(SYS_writev, pipefd[1], &wiov, count);
	werr = errno;
	close(pipefd[1]);
	errno = 0;
	rret = syscall(SYS_readv, pipefd[0], &riov, count);
	printf("writev=%ld (%s) readv=%ld (%s) byte=%c\n",
	       wret, strerror(werr), rret, strerror(errno), received);
	close(pipefd[0]);
	return EXIT_SUCCESS;
}

 include/linux/uio.h | 8 ++++----
 lib/iov_iter.c      | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index fe2e985d74d24..529c6cd53df7a 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -362,11 +362,11 @@ struct iovec *iovec_from_user(const struct iovec __user *uvector,
 		unsigned long nr_segs, unsigned long fast_segs,
 		struct iovec *fast_iov, bool compat);
 ssize_t import_iovec(int type, const struct iovec __user *uvec,
-		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
-		 struct iov_iter *i);
+		 unsigned long nr_segs, unsigned int fast_segs,
+		 struct iovec **iovp, struct iov_iter *i);
 ssize_t __import_iovec(int type, const struct iovec __user *uvec,
-		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
-		 struct iov_iter *i, bool compat);
+		 unsigned long nr_segs, unsigned int fast_segs,
+		 struct iovec **iovp, struct iov_iter *i, bool compat);
 int import_ubuf(int type, void __user *buf, size_t len, struct iov_iter *i);
 
 static inline void iov_iter_ubuf(struct iov_iter *i, unsigned int direction,
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 2072c04e99d05..55cf2ff5bfdad 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1362,8 +1362,8 @@ static ssize_t __import_iovec_ubuf(int type, const struct iovec __user *uvec,
 }
 
 ssize_t __import_iovec(int type, const struct iovec __user *uvec,
-		 unsigned nr_segs, unsigned fast_segs, struct iovec **iovp,
-		 struct iov_iter *i, bool compat)
+		 unsigned long nr_segs, unsigned int fast_segs,
+		 struct iovec **iovp, struct iov_iter *i, bool compat)
 {
 	ssize_t total_len = 0;
 	unsigned long seg;
@@ -1434,7 +1434,7 @@ ssize_t __import_iovec(int type, const struct iovec __user *uvec,
  * Return: Negative error code on error, bytes imported on success
  */
 ssize_t import_iovec(int type, const struct iovec __user *uvec,
-		 unsigned nr_segs, unsigned fast_segs,
+		 unsigned long nr_segs, unsigned int fast_segs,
 		 struct iovec **iovp, struct iov_iter *i)
 {
 	return __import_iovec(type, uvec, nr_segs, fast_segs, iovp, i,

base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.53.0


