Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B560CD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B8C66B0005; Mon,  4 May 2026 04:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 669AB6B008A; Mon,  4 May 2026 04:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558886B008C; Mon,  4 May 2026 04:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 417166B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:17:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D67BFC183F
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:17:03 +0000 (UTC)
X-FDA: 84729031926.28.B857D5E
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 22667100011
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:17:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="eNCttk/4";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777882622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EVbyjWaaT11NL9Dp5r+fBVJD7feswt259t9Gsa0JTNY=;
	b=i8poWd+TJZiawuXiYbz89waoAP07gmfXDKHt28rXgMZeUjrABj8kaBjX2QhqrphQvK3RRh
	T3BNzn4eUN3fkF7S4FEzDCHG3VAi3ZweTROvc/L2b8me1qtQU8XE2er+44h0Gps1i8vs8k
	sG5X9XNWV+5dlwcILbOxCz5GfPuBdqA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777882622; a=rsa-sha256;
	cv=none;
	b=g9eh6GOlk52h7OEHkLdzwaoJ9vsIQEOH8qiiGN7x88e2kT8SXXDVDD6B8iCNSwrz0KDPQE
	nAWex1UmkrFLJ5FuGtChrwijVj1sRpuk59E7446OMNBabnnZUJ6lkn+CBoiU50ZKAa1ORZ
	4tiqeBX3HLaevv2sd5eRcst+ez2KAwM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="eNCttk/4";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-835386ff122so1109266b3a.3
        for <linux-mm@kvack.org>; Mon, 04 May 2026 01:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777882621; x=1778487421; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EVbyjWaaT11NL9Dp5r+fBVJD7feswt259t9Gsa0JTNY=;
        b=eNCttk/4K7Qh4dG5zq+xSnO48kOIgxoU3oF03Oy6zWDRNx6ywqWiREYVukw0noYvwC
         BixH4EhMM7xYcmK+r52O57WEs6Lwc4FiouGs+KndmtYMtDq08pmPOmkiIe3O8NXOPY6Q
         +95MO0NdLvZPKPMFmlcOWqEd9YAidIG+JizV085vRqLtHQUD135s6ij4qp00VftUSU4i
         R55OOY8/GfXPcybU218KABfts3aE3qdFFD4BaOmbrNN+bLnbezC58/UQ4R/u1zNOmekd
         OYq4E1+sDBsmEthnjsvMBCGeVnkKr6FRtVfeltn78ah1nmEEGVw1pmVw4NYR4JpPUHxz
         LVqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777882621; x=1778487421;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EVbyjWaaT11NL9Dp5r+fBVJD7feswt259t9Gsa0JTNY=;
        b=ECnllDmUsJxboclFHuHc14OVxV97u+Nnf8qAJoUMUgxoXS09ExOiQqsXcWYQ7jzxqA
         Nx4gy/nhRfntW8tYZI/qF+CBGq84XEryFk3H9Q0sI9oXT75IoJM07f6dgM78E0xXHA8r
         skIgZNHfJ+9tdoK9T6NDOVF+HJbEmGWTzBURx93jvTItILc/vzagJmo/zTG9ikNeBaFP
         9ubwxhu+1zJeTGeX+/yxPC6LHdNbe3Z9VJX1Z3xSYryqsm5H8ZVzhawfFi+1nNIusVPT
         PqDY1akNmFOefTV+t2QAB1CsIUkJUwapLK8zuidnK/l1TdG04KXdaSWWs0x17aWUG3Fu
         Aa6w==
X-Forwarded-Encrypted: i=1; AFNElJ/OywyY7rqvkY1EkUUcuj14UiSH8nKUW9BR2EBHzwkph6btMQAEqp07C/mycm9s1J6YZeGmO3fNOg==@kvack.org
X-Gm-Message-State: AOJu0YxKBur+KJtT3CbW87UVOfgMl1u5QXRct/OrwaUmnRPdR95PZR7p
	FBcebQLHozVHpRLAYghqnHBbw7JKpKv6PemqEKytrgSEQi1STYXIoFqy
X-Gm-Gg: AeBDietub55tPBYHRSBJ+ie0FyXFt5aAJBWW0YDXOngVu1XGQUS8zi/diNjTluSSHs6
	S/7GTL6JNyQl/TpO+9x3p9aKdeIZxs7zJhCWjRQTuOBR+xEpCB617eV1DDyBuOiTQkWyyLoUBX/
	+AJXeX7XHSIXrOr/Z8zReu3lS0GnTFxD/og3ncGTzLr1FvQdUM+EFznt9QroUiUKgWpXVLAFtMy
	tuCFvgODVob3BtBpoFTH609ObN3Ask41pZnxOH1NdMLqyrV5oQEdF132FteJEIb65mf6D+ZhG6U
	ed10KYoIW8KyH4Y/M249kXFw7lqF/mCsY5khRohU6P0GnBWsiL5II3IhWpAP/36S/hiyMtkM0Gy
	Upf7tk96Q/sPj0KD9J2o12O2ZXbgZR2NyppfsDd+in/pLAvCY+HbHE34ECSc1b+1l1aCGI43wcA
	O+VkgB/FvD3974GhZYiSdm0IeLFgx7LxSmwOzRsjk=
X-Received: by 2002:a05:6a00:17a8:b0:837:80a:5aaa with SMTP id d2e1a72fcca58-837080a7537mr3460040b3a.45.1777882620904;
        Mon, 04 May 2026 01:17:00 -0700 (PDT)
Received: from vini ([2401:4900:8fcb:edbd:7155:edb6:dac:107e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8352bfe7a49sm7644356b3a.46.2026.05.04.01.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 01:17:00 -0700 (PDT)
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
To: shuah@kernel.org,
	akpm@linux-foundation.org
Cc: linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	Vineet Agarwal <agarwal.vineet2006@gmail.com>
Subject: [PATCH v4] selftests/mm: ksm-functional-tests: fix partial write handling
Date: Mon,  4 May 2026 13:43:13 +0530
Message-ID: <20260504081638.683223-1-agarwal.vineet2006@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 22667100011
X-Rspamd-Server: rspam04
X-Stat-Signature: zs15ggo68hk6gbax916rddfoe15aj3jq
X-HE-Tag: 1777882621-832151
X-HE-Meta: U2FsdGVkX18DZSlb7KtP80z+bCu90RBCQ8iz4kRIDHHjdtkWNaGj3SpqPw9fvGfOu78r0dpkDk2EizQnky7xtKwToFNLYwOqu1eGF4Rog9ehtYrPCHD242zfRoEij38rQb69DW4KJvyfYh5VcMjXzBs+QjEx5T4qBFvgN9OBfiEtxtdv+DlLnaNeuZwcAPDWIWyqIyQQbsQOhN8scjI5ER+uL216MQ7V060TEVNIT/Jjd2iBhRRXeDccZe0Atvo5y2QCcKNjmgyx9wxXKFuAtp4+htSt6eXXtLC+hdDtRk220H7oWSblCLNYpcqnHEyuiPB5gctd4KH2K6Hc8dxMOK+ALFw9rtEu3YHdFZp0hpPE0fJd5EIL10KW9ufyFgTnc1IYjPYcnfuVvY3ZaqO32dGafmatWky4lVRQJxCrjmt+l3X0yDagG1uzYL2hEXfiIgUI4+sDrBKJtiOkIzc5Jw7zGbE+1acy+wvBoc5u3bfZd4JWLgEuGcj8kaSPWg8T1hU71MZfAhD62ZiGy/AhohFLaYPYuk38KlLfF58WC2lh2JzNM7VsuJL/HMnfeZdLO6rQUlnYL/m+PBO2VKs/WXr6WDWh9ldn9b9FY1kQpluOaejFrlnRwCzMs9bPqQAkRZAiwafB17Xm1eA0iN5NuVa7CrQP0IowDvweT80MJZO3T41Go2axum3Xy3HVzExCwaX+DFUuv9A5Mwmkl2FDXDCWCck7w6IcNEMFvQyNX9p3atBBr+wed41onfoaExZKiZn7XNH9xIX9ZgDNu5NadVQbE8vYTM8Y/RnOJOj2tLZkqfj0WBpWjimfWqfHlsd1JdsUn2oPOyAfrNLRRipKcOV1EulZ1bJVjoJJM7ERoCqRnMGOcxpbF0rmDmBZypspnIUh8OkpKHbw/kp3463TlJlH3B+zuFGj7Q5Vyz+OixrMSN8hVyURCTHSZ/mGTJV3VYqwI+ZRD7G/cCevQId
 KE9XwHRl
 wYQbXdJqpiYfTNS7QrXeunyx1nX+RgFCMinud88t6yAkF5+I3HCbM9PqJxlUknS3b24HGGJHZY4ugQhyKxYNtLoHpSZ7wMDj8nGHADEJzhgidfrKF9i/+63H3YNwvgfJ0fcpVYSfEkDmJWoBZlmxTvPLGhqae0GVGeieKE6EKWj3E7yK4avqowI+lFht3r6HRQxwO7VNYz33jNWTU2vFCpNyF4tIQ3YhTYOMKQaUgcJCv+mF9RRE8qy/tF0NvqMY6WGjUMDdhuz25cody6yyvBS7E8Is0aF89BwaHWxg/vfpyh3sH37liXkfd9grzYZNmUNVUy0qMwhLzYseP0kSjI1MQveFJW86yvmh4+Ybt0zaqyRRoBKIT+svUNP7/TvveCBuj8eiIrDo2BizxVTjvhM4J/ZFYErq8HN5yTXJoCFr31IhyXDqGoTZ9moeELO/XJg+WFj2KQ1WQgf25mu3YfPqx3iC8RcfkhGsaYlEEfRc9ulsrAny0M5mJcQVs9Ygp/Fy/SF4k5Svu9d0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update write() checks to properly detect and handle partial writes.

Previously, the write() calls used <= 0 to detect failure. This
condition is never true for partial writes (ret > 0 but ret < len),
so partial writes were silently treated as success.

Fix this by verifying that write() returns the full expected length
and treating any mismatch as failure.

Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>

Changes in v4:
- Simplify write() checks as suggested by Mike Rapoport
- Remove temporary variables and use direct comparisons
- Use a single len variable
---
 .../selftests/mm/ksm_functional_tests.c       | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 8d874c4754f3..31c06c72203f 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -498,6 +498,7 @@ static void test_prctl_fork(void)
 static int start_ksmd_and_set_frequency(char *pages_to_scan, char *sleep_ms)
 {
 	int ksm_fd;
+	size_t len;
 
 	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
 	if (ksm_fd < 0)
@@ -506,11 +507,13 @@ static int start_ksmd_and_set_frequency(char *pages_to_scan, char *sleep_ms)
 	if (write(ksm_fd, "1", 1) != 1)
 		return -errno;
 
-	if (write(pages_to_scan_fd, pages_to_scan, strlen(pages_to_scan)) <= 0)
-		return -errno;
+	len = strlen(pages_to_scan);
+	if (write(pages_to_scan_fd, pages_to_scan, len) != len)
+		return -1;
 
-	if (write(sleep_millisecs_fd, sleep_ms, strlen(sleep_ms)) <= 0)
-		return -errno;
+	len = strlen(sleep_ms);
+	if (write(sleep_millisecs_fd, sleep_ms, len) != len)
+		return -1;
 
 	return 0;
 }
@@ -526,11 +529,11 @@ static int stop_ksmd_and_restore_frequency(void)
 	if (write(ksm_fd, "2", 1) != 1)
 		return -errno;
 
-	if (write(pages_to_scan_fd, "100", 3) <= 0)
-		return -errno;
+	if (write(pages_to_scan_fd, "100", 3) != 3)
+		return -1;
 
-	if (write(sleep_millisecs_fd, "20", 2) <= 0)
-		return -errno;
+	if (write(sleep_millisecs_fd, "20", 2) != 2)
+		return -1;
 
 	return 0;
 }
-- 
2.54.0


