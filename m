Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78968CD3426
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 10:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49516B0005; Sun,  3 May 2026 06:12:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A207F6B008A; Sun,  3 May 2026 06:12:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95ECE6B008C; Sun,  3 May 2026 06:12:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 851696B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 06:12:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E8EFC2D0B
	for <linux-mm@kvack.org>; Sun,  3 May 2026 10:12:51 +0000 (UTC)
X-FDA: 84725694942.30.5A0B273
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4CCE340006
	for <linux-mm@kvack.org>; Sun,  3 May 2026 10:12:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RgZ5IImc;
	spf=pass (imf11.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777803169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KccpdQywlOlMR9K3mAv2UCpXK0oC+hyiMnrZpV5kK7I=;
	b=fHilgTDl530l7zSCHEAaKG8oK0Cw5JeSqivBVH28zJRSxsUercxRIGEaqCdmxseC4lqumr
	MlnrfAawAF45JArF6NlOEs0o49Vktr4f47wXz90dXb0mHMkqIjQ1W/UX04lNeeyKVQMAmt
	bGdtQmcEUckk62GkKlQLarixkW+eQC0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RgZ5IImc;
	spf=pass (imf11.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777803169; a=rsa-sha256;
	cv=none;
	b=eRjjiXRXpshXlHM9cUjKw4JIqkH9DJsEYSOhRqCJa7wHVlCFTNC0f8y4YVAn08q8L50jXu
	6ZnAfq3hk8OOdqltdOhjp0+ebefDAKzEDxoLMUZ3lH4riA7xkAUWwL3oteKEqGYJr+Yfb5
	4DeK/L9HeXHgQTjOhZkg82oMA8Xd9qw=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-365312a27abso311571a91.3
        for <linux-mm@kvack.org>; Sun, 03 May 2026 03:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777803168; x=1778407968; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KccpdQywlOlMR9K3mAv2UCpXK0oC+hyiMnrZpV5kK7I=;
        b=RgZ5IImciBWQ6j+M285g/ZWB5cPl5+X48tWsom/IzAzC76q44f+CvWR+lSnMalxaup
         WfJXtQ57kepV14u7yp9vihjB1X+6uV8dY11hQ2ihqJjr4XseFw67ewBQzWhKpOGfEMcS
         g6ZWrGrzsZbrpYm+CQvIecygQSVD+Pgg8tItClPMohs7jvyQsQZNt8AXbkaa6FQ27o2z
         T0waoRrfgqvQd3UZ0xP4pYAWn+3hhlOKk8rIp8Q7fsEWEpfaAeivpagjsxX99tUKqECK
         KeX4b6gY5xi6RiUJWaHTQ9RRY7HoP/9+EVym4GX6EGXnOiP32T8judVq8uvoWPnwUWqC
         X6nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777803168; x=1778407968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KccpdQywlOlMR9K3mAv2UCpXK0oC+hyiMnrZpV5kK7I=;
        b=fRZUVvPhnhCgezc5bjsNLw/2CvkPBph6sRW3BOEmOxbi5mFd3JEe7mSmaziCDUZ+rv
         qS2OKfOpaSdsRuIMIF6hJ90VEa3GTZHC21rvYTKTWXLjg8uqQNMBMa+2/IvDwzqtz+sd
         u8z73k1jmNs0sZ2luFMhf5P7g5F4JsJj20nWS4/CwgeA+R616HjFM2JP/ZtyOm9eG4Ll
         PUV+0H5LZbzsT402XgIYENei0sV2ZG0t3fAPBBSYKOEfU98CIHFcBJvTRfd2Uj/x3Qrb
         31K6EOew+HKhzDo7cRR9lvH0wrsK4+RTx+KoPWlY4N7TIzfHq3PtYx99uItsm7Hs5kR7
         8HaA==
X-Forwarded-Encrypted: i=1; AFNElJ97x+rwIb2/xjpgtxJz+9QUyeSCZoI9b1NxP3lHKQomNdH5rxvN68DIsD0jDRzfcF5pesX+hY+P1w==@kvack.org
X-Gm-Message-State: AOJu0YzDnl8INlL8+TpDjlGiZzAzwp6jsSKVO50KQTqEyUuy4qMSoIiA
	nH6yQR/kaXNGjiSZCotwugqTEbYUVLjvK1Ntpgqr8mB6lrsxQN0IzET0
X-Gm-Gg: AeBDies+bF2K7hIMTOrWl/Smw2zTKqqZ/vCuT6ajgnVHyqhkgKzSq+iLDa4sBSjTHWH
	OYl2joshwtaP3QmAbEM6chJj9GwZgqQo/abrRVYRMCYfUzLRy166o8sApyxMhdn47X+iOPWKE/q
	DW/vvr0rhVUYRTYTeRzyXBn/qbpESSAz3vbDyrM8Wsw77tOZ/Hlar4ODODkMFBi6yWqba+uLB/h
	BH5fq3H9SQJeGK8df4Patn2o1LzKkBUz0Nzsj53lBRC+g2YTkALXd6Pj8CtWkniQO/vPcSi4pi/
	rNCidiF0b4mn6OCCJS7bqWuWzgUBJAlGiCWg/XaweIKWzP3T5Ckpmg2K0GndrHZfA+Av1wSRWYL
	GtCo6Bx46jfazerHfZCHbEbS/aKyh7sRYArpLgcy7uOXkPueMoMprTj1o0/b/IdJAYweZnVshwe
	ov8B3zxLoqCwl5d142j9y9Xk5LPb0v0XySCPMNy9DS+9CBbcXS3A==
X-Received: by 2002:a17:90b:46:b0:362:eaa6:a3a2 with SMTP id 98e67ed59e1d1-3650cee0153mr5713172a91.19.1777803168025;
        Sun, 03 May 2026 03:12:48 -0700 (PDT)
Received: from vini ([2401:4900:8fcb:edbd:7155:edb6:dac:107e])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364ebec736dsm7810834a91.3.2026.05.03.03.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 03:12:47 -0700 (PDT)
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
Subject: [PATCH v3] selftests/mm: ksm-functional-tests: fix partial write handling
Date: Sun,  3 May 2026 15:38:40 +0530
Message-ID: <20260503101229.654763-1-agarwal.vineet2006@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4CCE340006
X-Stat-Signature: codnsdfzcscysogfpxi6iquc3e8k7d8r
X-HE-Tag: 1777803169-131251
X-HE-Meta: U2FsdGVkX1/YN441g3o15uPNlLYx/ApqvtcsqOY+7xZ21hWoZxnM/Fawpe/6xj+kTwDfN9rCctTEprTxqoygPzOH8ZcVz/FIuzNTFFpO96sm7H3kVi7XVa8m3+rToUd6vY8vTYEI8aY1EeLefVD1vlMq2vXJHxr6V/xETTVYcYWF9t1N1vp7K5tUqGDI6QcclmjZ/kHTsYPtXmYu3vKVv3D3lMo48XHYG6LG1x+UAOOZub/wHxNW7wCCpzEIQDBqRwvO5fQap6Fefy4MFW397FUMWTJjxM9cugoFDU+/9zXBtTeUU4gmn4q0AtI+U0SIXlRafvxtnlbMdGD/H9U0v+Q7ZL2GKSOYBF/UeCklJ5UymhzLQHPU6FD+MY+qwvuOpZ6c2uO4X+r17iE1zRE9TvPdf8ONjybkCK+Xl5wVR/KoFM0JLpWxqZGm9w4Hd4K70W7lYCph1g9QjMlVYcqZd84T4ZAP3viN0q5Wt3pyeixQnAROWsL+0gkIxHlJI4/PKJfUyROIt2VOd0E0Ilzq7Ctfsy+0tDGhvCYAcMrzCnYbA1mia6LuB6G+DxtTWevjYgrhhZRsdSajWfUV1y2z38oOnTh/F6uMtWjRMQYPGObvqUJ4HOCqiRW3r41aVm3kFWOjzA+AsjnuUe9zKCGvAqZCLU9B8Q7yk+3c4iiS97kyIF++mrpLeiFTV4Sz2mMLDlmLvQ/DVZp7kYoZDKQTTnP/W7TNtQVvKpy4eUH3Tilg1v08XHMEmCoWlvVpWtm/54bdETKJjiROOkkdoSyPqN9waKY/NyguU85Q86Ecu4lGoUQrux6DASKzbrra5tKBtYoUH+0qUmnGP8vvINsr+lBjZiYMfY4UX5bqGwT6rAlru7uP0Rj7w3bX0IgWvYS/WYyOLHA05+bTw5UCrs3mPQdKMap3pb05nBVOjKo6MyZ7HpW9cTceEOwN6bZGAJ7JdXTGTN0ivfCY/T54la0
 Ui/AxjHD
 462xuovnujppuJiHf6Z5AkijkuMS1PqhUVF5gPeKqoETvpXAJvYOVmcsbCfnn5ZoReFWBKvEOFkk2C5vdF8fRgVuA6ZgjwKiogCfOUV+AYOk4Xe2t3JMlyhWma6KyHFt+tcZv4VIqqUcpO+oyeWTqBz34wwh/gT8GFsnW3EW4ZRNRSj5CbmQkITY1OKs41mbHWv/H5+FtftDJMCLn7CnhT9aRGzah9rytvHje17DYsL0xPcwjHUUPAdKtNKfdAMKhjGumHyOrxnQFqMBKzSiIg/7wSF/J8xFxVAKZi/FDxWJb+j9CUdwMC59jbnYUUxUnDLqtbA1UGIcRVl3qOXQ8ZxDShBLTPrz2t1fdsdt9d16EnYL90eHqajYZmx0LWKD0OlH09KDxb0t8IFZntaw+75EGli7zR90mIjuwowWZDAbkDOvAdiEvhYGIyo9Dqs3wuoolmvuXshZhbcq/NistCKsV/6icSSTxGO5HOMsh7GhkKX0T5Xm1X1gsCuLDNHolo3xBJSEZVCHwaeU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update write() checks to properly detect and handle partial writes.

Previously, partial writes (ret > 0 && ret != len) could be treated
as success because write() does not set errno in this case and the
code returned -errno. This could result in returning 0 and
incorrectly signaling success.

Fix this by verifying that write() returns the full expected length
and treating any mismatch as failure.

Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>

Changes in v3:
- Simplify error handling as suggested by reviewer
- Return -1 when write() does not complete fully
- Rebase patch against base tree
---
 .../selftests/mm/ksm_functional_tests.c       | 27 +++++++++++++------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 8d874c4754f3..4abd98be3f59 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -498,6 +498,8 @@ static void test_prctl_fork(void)
 static int start_ksmd_and_set_frequency(char *pages_to_scan, char *sleep_ms)
 {
 	int ksm_fd;
+	ssize_t ret;
+	size_t len, sleep_len;
 
 	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
 	if (ksm_fd < 0)
@@ -506,11 +508,17 @@ static int start_ksmd_and_set_frequency(char *pages_to_scan, char *sleep_ms)
 	if (write(ksm_fd, "1", 1) != 1)
 		return -errno;
 
-	if (write(pages_to_scan_fd, pages_to_scan, strlen(pages_to_scan)) <= 0)
-		return -errno;
+	len = strlen(pages_to_scan);
 
-	if (write(sleep_millisecs_fd, sleep_ms, strlen(sleep_ms)) <= 0)
-		return -errno;
+	ret = write(pages_to_scan_fd, pages_to_scan, len);
+	if (ret != len)
+		return -1;
+
+	sleep_len = strlen(sleep_ms);
+
+	ret = write(sleep_millisecs_fd, sleep_ms, sleep_len);
+	if (ret != sleep_len)
+		return -1;
 
 	return 0;
 }
@@ -518,6 +526,7 @@ static int start_ksmd_and_set_frequency(char *pages_to_scan, char *sleep_ms)
 static int stop_ksmd_and_restore_frequency(void)
 {
 	int ksm_fd;
+	ssize_t ret;
 
 	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
 	if (ksm_fd < 0)
@@ -526,11 +535,13 @@ static int stop_ksmd_and_restore_frequency(void)
 	if (write(ksm_fd, "2", 1) != 1)
 		return -errno;
 
-	if (write(pages_to_scan_fd, "100", 3) <= 0)
-		return -errno;
+	ret = write(pages_to_scan_fd, "100", 3);
+	if (ret != 3)
+		return -1;
 
-	if (write(sleep_millisecs_fd, "20", 2) <= 0)
-		return -errno;
+	ret = write(sleep_millisecs_fd, "20", 2);
+	if (ret != 2)
+		return -1;
 
 	return 0;
 }
-- 
2.54.0


