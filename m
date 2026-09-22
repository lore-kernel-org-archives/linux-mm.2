Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0142C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 06:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90CAB6B00A7; Tue, 22 Sep 2026 02:53:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BCDB6B00A9; Tue, 22 Sep 2026 02:53:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ABCA6B00AA; Tue, 22 Sep 2026 02:53:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58D546B00A7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:53:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE1958039B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:53:50 +0000 (UTC)
X-FDA: 85240483020.02.E35805F
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf27.hostedemail.com (Postfix) with ESMTP id EDFDE40006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:53:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=dgu-ac-kr.20251104.gappssmtp.com header.s=20251104 header.b="nQRrP/i9";
	spf=pass (imf27.hostedemail.com: domain of ts930@dgu.ac.kr designates 74.125.227.140 as permitted sender) smtp.mailfrom=ts930@dgu.ac.kr;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790060029;
	b=uIyVMZX59bNYHlYQPwyc1WFFef4+WbGlIKOceYKOcPnX3eOwHtCKZPd/YWztm6bUS2Utx6
	YGc6F/GU8LZ84t13WNyXQW950oHDp3gucFFJVz+9v7h42jvEJx8XuLBAUR62vsy/ajgHOs
	d7Ygjb9jUaYOrWN+gk1Z0UeNWY096eM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=dgu-ac-kr.20251104.gappssmtp.com header.s=20251104 header.b="nQRrP/i9";
	spf=pass (imf27.hostedemail.com: domain of ts930@dgu.ac.kr designates 74.125.227.140 as permitted sender) smtp.mailfrom=ts930@dgu.ac.kr;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790060029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=I5hkDZLfpwpTgVNGBTeOG5mY/TLY3Zz2ZIUT6PQoExQ=;
	b=gQMXpux1UqlpG0KhakgKcVMeliH6oBFqVtVF9flOp1loSyFTVXwxCvXzkMXmZ26LfZPLNX
	oG8KRBdq7FVIHsddYw7V8DgsnEFuwyHF7tUY3lKFCnKlHlFidVc+oidQNJ3ot/gnzUD1r4
	NHuUZK/ijmcNzNegzrYWqkbbpDVJsww=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2db22383fe8so24677015ad.2
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dgu-ac-kr.20251104.gappssmtp.com; s=20251104; t=1790060022; x=1790664822; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=I5hkDZLfpwpTgVNGBTeOG5mY/TLY3Zz2ZIUT6PQoExQ=;
        b=nQRrP/i9gPLphaldBMW/NOeiAAhRFxHC1DroqGbC+kuZNOHJTJE0+n0bP6dLidgj/3
         QCjI9pGKJ1YUE3gk5kU/D8QKrHcrGcjCt5gSVawnmOmp5iJdKPSDpg82y3DhxsGaf99g
         oD7gM67ksKFHqxsp860ieHqQMyei97EaJ5txHbQPnUTI++nQZHjvyqOh7HYDao3yCtV8
         ih2cdmVUPUROALIjTeA/TveqOwbuZY2QsKJivn/SONBY16l1SMPajuwT93vrWJiCQFxj
         zbHF18p8UvmShYr9UxTINItFPlA15Q9/MMLDzzqrAO2kaGT0Gif6l0bOse1PtTF2dIa2
         Wc6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790060022; x=1790664822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I5hkDZLfpwpTgVNGBTeOG5mY/TLY3Zz2ZIUT6PQoExQ=;
        b=AgW7FWmKJXrZX+ni4KYaRDS/CbkcTG37pnE0chGdee/TpakIQuNDfEFUuwEbxSV38m
         jCuTNKF0B/Q3fKS+broF6YEH1wRWWxjbuHcrobN71gi7HjETG0KLM8SPT1jIwbCZ0x3V
         kjvj8+t2WgHc83J2gNvOrNIUoJKnYsqq2qCpikTGQy99hRgIsXtstCdVCm5ahJueeDk5
         NFiVF716zS7I4IGquaVOzzKHXvkrSpOn89gEMcckCsT9Qyqq3P6au5c3CfnXqlFiXDnM
         ZfSu91ZBpp3x8efCvpOgJblUzuBpCa8ET5mFlBqiiJsYYrXvx9ECBOS5p9hSecqZG9M1
         FItw==
X-Forwarded-Encrypted: i=1; AKwUvBxJwf+LeMW7b1HfKN99aFQhaPBU3duJLA/Ay4X36htbL5QkneJjyKck428Dk1sCodlFXfaZ5xksAg==@kvack.org
X-Gm-Message-State: AFuF++lBUUsNSHP69tEdp+RM3QtoxEiPJOK3qPrOMdU3MUbvsRpDsb77
	lFt7o1l3Kz+JNND46ap2sWRNSkRvN3NdUEq4Uon3hL5paVswCKvWyLtICYcoaLSvhlk=
X-Gm-Gg: AYBFou30j1Y33fj9qhzQbNe2S6mTYtcqlUnt/8OZkvFTzrDDDTGIeTFlnC5Lbj3jcX9
	FTl5m6QBFY0QZFRnF3gvUxKGqX73S2/tnjr4XKPAG/gYY4jtOIDOgRXIc3i4lsWclL6N8+VCRCl
	QbOl8x5TndC1Wo6wDHITDGT10gCcNv3WunjgnbpeIgP4+ts4WxMzbU13r67u8YFj8XD6qS7wL2n
	3/l3HTru9zflYZ8BLvp9UbcX8RaeNy/UjMqLOYtS9+NTqSRFJVzVtfFybN5vaFwDanUfvz9d4Hc
	kyGDS+/QdgUw47Wv9aHzx/U83KWQ/nr4muTbzgWWUGDq+LW2aOS6Y2war4jSEHWOYsz0TCz953J
	afUrFCU2JWSXxy/QEGK9YaMWiUjH4QYlHeWcECxPiKSg9esIN7CxguALhpdozRsZh7ooog/T9ct
	4c6GdijyGPoZXzM6QwI9Z8ULEm/84W+V1MikT9GopXszEID82d8I3y+z2F4MhWSUWM/KOClKxHo
	+8OzQ==
X-Received: by 2002:a17:903:3c48:b0:2d5:2f49:b3f4 with SMTP id d9443c01a7336-2df609ad79dmr2778935ad.2.1790060021931;
        Mon, 21 Sep 2026 23:53:41 -0700 (PDT)
Received: from localhost.localdomain ([175.193.106.181])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df5d0581f0sm4534855ad.74.2026.09.21.23.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 23:53:41 -0700 (PDT)
From: Park Tae-sun <ts930@dgu.ac.kr>
To: Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Park Tae-sun <ts930@dgu.ac.kr>
Subject: [PATCH] selftests/mm: mremap_test: handle ENOSYS for userfaultfd and add missing newlines
Date: Tue, 22 Sep 2026 15:51:43 +0900
Message-ID: <20260922065143.118702-1-ts930@dgu.ac.kr>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EDFDE40006
X-Stat-Signature: 9geojcdbyd139uo6s9cm4mqhm6h4bma6
X-Rspam-User: 
X-HE-Tag: 1790060024-771503
X-HE-Meta: U2FsdGVkX18gVWnaj69rlkB8TVIqxYZ/fdkx7//jlTxtw6jYPYyBlTao+Ag0h+gD74GL4rPAgVWqerd4A0kDaaOCTCew3lBm1eMFqsSo0nfaKJDnJ6CAgPU1d6GdqZmUzD+oUuNyFbcBjy64AtLK/TqyYxzJk7qr9TvenHQFudtiW9OpUX7gvRkmovGCdhlbNwZ9Nk5mKtE6i7cOXtNO7nsvpiiwaIUjyndHX+POE7TVhnd6ZYz1tHSP3deqO3BFBK0ilVEKcZuC/90xQ65e/j3jEEf9pNhDsIg6HKJEnUpzlSH/cLDEGOlMhsHfYh8M6nJgLGvDgHXH4VwDsgnECBPhhkQaDLrHj+jqF/TukZqURIm04+7UmI1zbXWnKhOnpq6zzq3gvU2qaCxgp6G5Q+CZSowrvRr85LEInj2JffgQUAf/87wzlSXlrOcGv8MZsgGErHk8IAZBLfnbvqxfKV76KWIcrGUQ3+/AVLecr1DTlFUURhAUh0wE1bH4tqI+439s3B28HYaV/CaHrvyXdQMKnW0aibEUQaSHEnMFxXflhQO+zrexJFz4Tr/MVfjH1enDp7ALPfI8P9SiOgfW1+mQIhsHA02vH2kJgS05VKSadj5ilWFAuu1tbT6nvxNGkjAwfq1JJR+T3Ihgpo5BSJWWUPaNIW4zXaDe3HJ4gsksGzulMWsjWuHOkGZXTg1RPTuryWWrFoCkrqsxVveUTEgAAGxAfylWC0dkoCdWg/pa1G0mVRXv40vW+xNB8Sw8hYtUNiRKDb+pXM16TF/BgjhbSwQN6jP6Ex3Kn+9i0Jw/inLSIoI7euA07KF+WFo7OoMc3RsaL7+gS7rzJcyJ1Z3XO3nMYzN13fE4rqTEpr+BkVECYwqpIwx2Qz3QUL9oJeUqMEuwoaAp0AdXiUjMxO7UVhich9ZyV0BVQqqtmdodr9iFz/IqxsIk2fYANTK9qzwgJxTLYYG8/RoW9cF
 aZbFQfcA
 CrqxvO3xSbwfy/LhL4hLiNeGHb2PtMwLVd+jwnek5hUYomkTgGvG3QzFYyLamEHRBfIuphSCl3s470Abg3AAnM4QFDVgs5Ktcw8zXrsoJmPm4N28OkG04xAUrwNEFl/dc3qYtf0sF5N1l2AAJ4gCAPMUjkK/uV1Xrs2dtRsn3bnhJZjq8ChWXbEM2H4ztIMtejrCgPi5tf3kGvE28+4o1SnQ/nhF1283ZrGmorTVd3fLPGAmmL6yCqV1IWdMkb6+tnhIOd1se1/AqzNfYrKmfiZcl49YuIoi7LHhBQGz4M7RFC3ZDOsv8aeNHYmXFnKbGvOL/6BGNDBCdY6U+bYJt/bPs3rS0DdEbjxi2UjkIJpX+jwZ+n11zcM4Bkhrs/vAIEJlIqt/DY3GVvCsztLR63Z1K/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running mremap_test on a kernel built without CONFIG_USERFAULTFD,
test 26 fails:

    userfaultfd: Function not implemented
    not ok 26 mremap move multiple invalid vmas

This happens because mremap_move_multi_invalid_vmas() only checks for
EPERM, so ENOSYS is treated as an unexpected failure instead of being
skipped.

In addition, ksft_test_result_skip() in both
mremap_move_multi_invalid_vmas() and its fallback stub is missing a
trailing newline, which causes the subsequent TAP summary count to get
stuck on the same line:

    ok 26 # SKIP ... - missing uffd# 1 skipped test(s) detected...

Fix this following the switch pattern in guard-regions.c (lines 1498-1506):
check for EPERM (advising running as root) and ENOSYS (missing uffd), move
perror() to default so expected skips don't print noise to stderr, and add
the missing '\n' to both skip strings.

Tested:
- On a minimal kernel without CONFIG_USERFAULTFD in QEMU:
    ok 26 # SKIP mremap move multiple invalid vmas - missing uffd
    # Totals: pass:22 fail:0 xfail:3 xpass:0 skip:1 error:0

- As an unprivileged user on host (vm.unprivileged_userfaultfd=0):
    ok 26 # SKIP mremap move multiple invalid vmas -
          no uffd permissions, try running as root
    # 1 skipped test(s) detected.

- On a kernel with CONFIG_USERFAULTFD=y in QEMU:
    ok 26 mremap move multiple invalid vmas
    # Totals: pass:23 fail:0 xfail:3 xpass:0 skip:0 error:0

Signed-off-by: Park Tae-sun <ts930@dgu.ac.kr>
---
 tools/testing/selftests/mm/mremap_test.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 131d9d6db867..1fa2f6aa1a19 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -743,14 +743,19 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
 
 	uffd = syscall(__NR_userfaultfd, O_NONBLOCK);
 	if (uffd == -1) {
-		err = errno;
-		perror("userfaultfd");
-		if (err == EPERM) {
-			ksft_test_result_skip("%s - missing uffd", test_name);
+		switch (errno) {
+		case EPERM:
+			ksft_test_result_skip("%s - no uffd permissions, try running as root\n",
+					      test_name);
 			return;
+		case ENOSYS:
+			ksft_test_result_skip("%s - missing uffd\n", test_name);
+			return;
+		default:
+			perror("userfaultfd");
+			success = false;
+			goto out;
 		}
-		success = false;
-		goto out;
 	}
 	if (ioctl(uffd, UFFDIO_API, &api)) {
 		perror("ioctl UFFDIO_API");
@@ -965,7 +970,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp, unsigned long page_siz
 {
 	char *test_name = "mremap move multiple invalid vmas";
 
-	ksft_test_result_skip("%s - missing uffd", test_name);
+	ksft_test_result_skip("%s - missing uffd\n", test_name);
 }
 #endif /* __NR_userfaultfd */
 
-- 
2.43.0


