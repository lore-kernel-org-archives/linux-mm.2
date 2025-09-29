Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 550BECAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 11:55:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922EC8E0012; Mon, 29 Sep 2025 07:55:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3908E0002; Mon, 29 Sep 2025 07:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810308E0012; Mon, 29 Sep 2025 07:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D74C8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 07:55:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF6CD160377
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:54:59 +0000 (UTC)
X-FDA: 83942131518.23.A525A38
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 28E9B1C0004
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:54:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mkSGAOxe;
	spf=pass (imf20.hostedemail.com: domain of sidharthseela@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=sidharthseela@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759146898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/nxMwSBQwOydmRinFjGwKZjIbNHBnsDSojBIvT19KMQ=;
	b=xyhO2lOx9gcMbqNbDqf5kx2U2y9cbDDB47M185Nrb0xolHn1GzvcN7ZDns4VdrdKwch6ee
	WQTuFEw/pGLIn6GxXnzzEwvW2OsLnw8vtNb3Qe8yv4nDoZ2rRb9r5tSSwb2SkWqQ+2SgNo
	6eV8YTOE9vSN9jh7kLVuMAxUZvlluig=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mkSGAOxe;
	spf=pass (imf20.hostedemail.com: domain of sidharthseela@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=sidharthseela@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759146898; a=rsa-sha256;
	cv=none;
	b=MBSGHGH0QfJ//jmk7e6zGzrdo7+VZM/OpFUTzH/WLpPx0IKM23YBnUzoxS3pS7wCbrZakV
	YdNswrHdspvMrnFwJMPZEkZ854Ojbb9JBUdBZN5djTBwIr/ADkTQrLK4BqEjOvL9VRrut8
	v7s4ti0qsOspEhV4yUea7nqRrMZ2Ihs=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3306d93e562so4812795a91.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 04:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759146897; x=1759751697; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/nxMwSBQwOydmRinFjGwKZjIbNHBnsDSojBIvT19KMQ=;
        b=mkSGAOxeaICFrF6briAwuiObrf7GAQwbAcck1mqB8FVUn65pG/7pMchn/nT4fm47GG
         IMA3cNR8J1no1r0f4bCr9FD+bgORn+cH+Xe+dnQQJm07jp7GmX5AifqgjMSBMF2s7eo2
         ZBJt66h2myHv7H805dpxC1W9+230WOJwcXMuEXslG2A6nWzWekS1kmfZXfyhNEHQTR3w
         vJ+9zVqL6ACmZ/PWzx3/21K+Js53Skr25OHmrym9yJVEIVTiIeiDRem1sS+q/FTYxVxW
         nIpKZXJzP7d9Zbulkx8PqB7bMbAT7Qi8GCFTHxkD0a4Q0aCwelTci2AMiCBGv6Iab6po
         R+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759146897; x=1759751697;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/nxMwSBQwOydmRinFjGwKZjIbNHBnsDSojBIvT19KMQ=;
        b=XsAMMUt+hdOESwabS/SP1ykJjemulsOlW3jswnywQHSkKYIek9Pj+PD8v6AK3LzOUD
         osqxsVs+uf3/6E7sfa8AEggoA7GK6d0AcjZp73fTLhLrO2igGF7ufv6V7JBnQKOzclXk
         QhYYsZn8vLVW1uUSfshW+G5/I+r2//notxd9IYCI84tnHML6ZCigGdSCLdFSpiCKkXf/
         Iy2DZ8cr5fXarQyA+bU/8jKW9WaJ19s4YAuSUZ9DjPhqGteqp/F6CGNp0I5HqoJ1EhD0
         udqse96yK8WR5EFeTUIaO4xQar4sM1ltn8//P5CGOkagjFowRCJEwK0IbhoC/lqJK5nN
         EPtA==
X-Gm-Message-State: AOJu0Yxu67GGU1220u97RGlJeZnFxa4xPY5pmJl4a4nm9EWM52YW4wsZ
	+xYtmAgtM0Z11dROyqKJKtPiWCcWxcr2Y1KmbrPujJzyr/T/Y5YFZHti
X-Gm-Gg: ASbGncumKaDNqb/2oKsAAuQahs7v9UfmVTWW5cNOV28dU9u1VTGxIDenUpfz3i+zZNh
	z+eUx0Xy/lFyO7QvCS27xJT1/jS1MA8nDwAahgAzYNsFkSIhfH4cG8KosdaQIu2B5f+5kLIxnyx
	vOYcWXTcDZDxh8lYsE7UYjPlRYkEik+IGBek6erU3+Plb+9RGNzM48uTYN2t9lIQBd7XOVfu5bB
	UXvXsvPPNBGYyiubCr0gkINXaQAQGDT3BOpVkYu8FGLOLvW/PUEOcMFnWyeKT2hc/GzbJu1LJqI
	AtfLJ2r1uM18xrkIzsSybcx8BIppDsvGxwKF2OLzNV4q3jVxnAySQ7uX700Zb//v0yk6IBCTLqL
	90KIUeH3+pCgbgy7C3NiXB9Mw/mVd
X-Google-Smtp-Source: AGHT+IGZZNUqAN5enffrxbMWSeJ5zzoNuwdSyjXDEWzGn3w9G1pwp20etolI1Qt0978OXhgQfd+jHA==
X-Received: by 2002:a17:90b:33c7:b0:32e:753d:76da with SMTP id 98e67ed59e1d1-3342a2abad6mr17486517a91.20.1759146896814;
        Mon, 29 Sep 2025 04:54:56 -0700 (PDT)
Received: from y740.local ([2401:4900:1f30:25ff:36cb:10ee:ba03:839f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3341be384c5sm16983570a91.26.2025.09.29.04.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 04:54:56 -0700 (PDT)
From: Sidharth Seela <sidharthseela@gmail.com>
To: nphamcs@gmail.com,
	hannes@cmpxchg.org,
	nathan@kernel.org,
	shuah@kernel.org,
	morbo@google.com,
	justinstitt@google.com,
	nick.desaulniers+lkml@gmail.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	david.hunter.linux@gmail.com,
	Sidharth Seela <sidharthseela@gmail.com>
Subject: [PATCH v1] selftests: cachestat: Fix warning on declaration under label
Date: Mon, 29 Sep 2025 17:24:06 +0530
Message-ID: <20250929115405.25695-2-sidharthseela@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fz31fsgx1tzo6xdb9b9jmqcnf5ocymah
X-Rspam-User: 
X-Rspamd-Queue-Id: 28E9B1C0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1759146897-841722
X-HE-Meta: U2FsdGVkX1+tjNZCCJxCNvtMeHH2TnAE9fZ5aiWCCOP+WN/Xb52M10EOg7m8tn17Ir6+G3H27sZVCwSKGc0QWqGT1aJzhZM/3TMpllbbxema+OlY0LiMB0e6P2z0ZB1RcR6p2zLAHHAhSu+Ly05iDVZnRPmvSyq+UNcjzSrlhQqaPkR2K+rW4Cf3B6FHrmFQ4dXs2mrpZn+2BiAsC+dndk3IWU1v1N83ipw7VdGzsFb7qwWzsEEZtyoaNqC8vyG4iSOg2apHkX5kDf1A1Xo4klt01pw+Z7Pl3UgE1McaQIuNWelx0kiBeu7nmRCLs1S/GOfpZ6jCxQHqEzSLR9DtQQu0tDkqhKUvtNr3UrwMfpw416BbBZy1RF+KGHtA/5IDwZBrmoMJAu/dhItx63ovSbTSs3b6OdTsxPuCZHg/Y8O6fuhPALHsx3UGMXlTjwg6i2LyiuNmK0pdXXIprpFQUYCj24aWHQZvZOrZ7ls3d4KcAM0epWdlQKXehO1dLFewLd4Sl3GdXRDbilWMc3HlpdMv9qiQcVcIZi0JWoXRKibLM67Qzh24Cnpg2cRgZy6c/BUJ6+avpMvHiQDkp2xNuZ/568WjQwayVGBXRcx9X1qdC43maOY2vZqiVmNtPH3HUYo8duubplWjJfaMWmznKwqH/m6rSGjk9kNxk0DcEs+1aK7gS2AJu0vlqHzfV3/y241ulM6Pqeh9HuTaEXETiOFoOD9wzyWY3qDfTPUNEauSEt891675AFlKHKnqzDyBOm983DpuRRG2RtICpHtXTvYoUsntG1XkPVVnDuIqkFdkOWxiaGMVCtfVdP+Odw0Y4CIS0ht0CykJ7JHbIwy2En9d+BdjjnYDlPXEzogPyIBhaKsz7Ip2OgETJF/K8rehPTnOcQsY6llnw5Yf5kPkhvZH+5uQLP3k6GTCn3B/SMcFTlfjMiI5B7kdadr/GPSpLqY14i4qkgNW7kaUaAr
 dJoLkjFu
 TwD0nbOc8bvJ1oERGGTIPNW2uRyYVcumY2EqdLc1jC7V4p2SP0WKCSVTygwwB6jllrMzG9VeXYmpfK544CtEV1WR8fc4QSMYfqToFP82MjqFS8oPhGUI5wZ/fS0VZZBB9+OI8R//unSBPUPHM0ghOfaBvUj63X7Ua6EOcxYQhZ1v/htgNiLT9mqRIDBhNu9NBHxfoMp0z7FTxG7gzUYc9h1jFMRbzUR0+IKAO93xEdXN2ULlmrLELxSqPpQzU4SUyRbTxdzO8xXqsubxe7icAcgcilW+U7pAgN5Jiwf0+QYl8LtY+lq0euyznP69tefg3zcmZV7ebzf4wsK9r+jb+eBHjECaISVYTYv1dhIZnGed3HoIxfF25lCpwwrLOm/Lfdb3LfWwjsQdsWEMXx0DcIY84URk2nRxXny3+7Oc5LMr+j0Nd3W/eVRCcnnVDSaaWe9bmn1uUryPIqcx2HTNcXQB4/A6U4FTkicUdWsSDMrptUnfszpY+JuQAUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix warning caused from declaration under a case label. The proper way
is to declare variable at the beginning of the function. The warning
came from running clang using LLVM=1; and is as follows:
--
-test_cachestat.c:260:3: warning: label followed by a declaration is a C23 extension [-Wc23-extensions]
  260 |                 char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
      |

Signed-off-by: Sidharth Seela <sidharthseela@gmail.com>
---

diff --git a/tools/testing/selftests/cachestat/test_cachestat.c b/tools/testing/selftests/cachestat/test_cachestat.c
index c952640f163b..0305e736f2b8 100644
--- a/tools/testing/selftests/cachestat/test_cachestat.c
+++ b/tools/testing/selftests/cachestat/test_cachestat.c
@@ -226,7 +226,7 @@ bool run_cachestat_test(enum file_type type)
 	int syscall_ret;
 	size_t compute_len = PS * 512;
 	struct cachestat_range cs_range = { PS, compute_len };
-	char *filename = "tmpshmcstat";
+	char *filename = "tmpshmcstat", *map;
 	struct cachestat cs;
 	bool ret = true;
 	int fd;
@@ -257,7 +257,7 @@ bool run_cachestat_test(enum file_type type)
 		}
 		break;
 	case FILE_MMAP:
-		char *map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
+		map = mmap(NULL, filesize, PROT_READ | PROT_WRITE,
 				 MAP_SHARED, fd, 0);
 
 		if (map == MAP_FAILED) {
-- 
2.47.3


