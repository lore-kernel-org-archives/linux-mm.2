Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0EBCC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6827C90008C; Wed, 13 Aug 2025 09:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60BBF900088; Wed, 13 Aug 2025 09:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3EE90008C; Wed, 13 Aug 2025 09:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B179900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:57:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3812117383
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:57:36 +0000 (UTC)
X-FDA: 83771886912.04.58D8466
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 16657A0008
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:57:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ISDa8KMt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755093455; a=rsa-sha256;
	cv=none;
	b=VlRzqXjd6+k2xXdrrTdpMzqHbaKWHJYxr5ZUA8jlKWeNbfBmTvKlOcL2DGiQlXX607oTkK
	x3JHw1eZM0PuM6JbEmFSJ7su7cpmL1ghQBvI4Umeol8cK5RLtj/sj5uh5ErMm0WrtWA51a
	pyprnHXNbeKXzc9YH/7ejkdkNwtJdrQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ISDa8KMt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755093455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F1kmHl9ou54J+I7Bwx5/90tmVmkUsMDP6I8Z0yPOlyc=;
	b=v3TJS8UzwJRSprZETIdKZO1xmySR7zk2l/kdnkd/IQIjAiQmDObcrUydHWxbC1UySmZdGs
	J+DRz8q1L8Wa2+HR6Kucj6ynfgTJr2gDIgLC0d9qyl/c8gUvFcCCu1D6TNygHPieIJJITU
	yOO65+anGHtRr3LH2XuWMGMP7ZtQoDU=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4b06d162789so76938931cf.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755093454; x=1755698254; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F1kmHl9ou54J+I7Bwx5/90tmVmkUsMDP6I8Z0yPOlyc=;
        b=ISDa8KMtLojJWIryAuOi9ZP0dOJoc/2ML6YeYR4sLLL1leLj/d6UDzkJOUjTqc4Rz7
         3LUd1pMbPZGyQR2Iou4V2KT3nHjmCjKMLIp2Spw8HGHI9joTZPGF98GrKb48z38gztT4
         t+keyL6bNC/PoidtIrh57deUMW6vK3WvCpr5aFB5anHcChWI+cBwvgctYFfdHgY6v0WB
         vQbiq0DtwEupcsWinX3fqUj5d0sprK0yNZgcgPGjCzH1DKyhYmJR04Q4bzdvYZi/GkwZ
         RIZhHqV5vLmfP5rQbTFAsZIWrtdEhHp1n10uvUuZgM0p4uPVoANzXF1fYJCo/0HFkFG8
         dUxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755093454; x=1755698254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F1kmHl9ou54J+I7Bwx5/90tmVmkUsMDP6I8Z0yPOlyc=;
        b=oHT+2pBRN9cHYrThIb2WXEjAudgLILYiG9yCbZwmRmNOS9Eg5Ujr74/Igs+y1H8aLl
         Ygus9i6EcfZJq6BI8jp183lo73IsgXP90TmRj6lRmRD2QJzimaSG89IzbdAXpYQbjccg
         c8fPtgvXmNti4bHBCoTB9xA3EXrUB9rZjx5H8HBK/mQm6SzsCLT0InlJQgDgD9BSUscL
         9C0b8nR/sqHGSBhKqbfb1aFWNT28DIVrxpxBi+InnqN2vxzk1gHFT5RdetbliEmsGa5N
         DdyfhTElHA4ur/l3xQkNnfXF5BlwEngsqsLiNz3ollyB19oGXz8x7INGo54jnPaucXNA
         KUng==
X-Forwarded-Encrypted: i=1; AJvYcCVLf8UTIZx0O1AMX0w2IKQflWGVzB8fXdCdKoC/SRIYSvolPEfn6AVXPCI+eKGQyGlTxH1lZyxGAw==@kvack.org
X-Gm-Message-State: AOJu0YwgUc0XF6tJj+fA4SYyjclW7y2Yt8H3I3JHyOzs81QQ5RQfWH9H
	ot2jFbgLnrsK8wNzZq2EdLtzXqZrJavjD8zSJnFFWTHfZJVoX0zuaWS6
X-Gm-Gg: ASbGncswY10npISSaCauIpheef0H/dyGYRXBZXXHGtUFYP3g9tE/cnu7Vj+eOV8eoK7
	auo96kMWH5f3Xm1+lmjVg8wnJftED9vPkJvIPJNSXCjpqhcD+diFONv6n/kOsmaVzt1Ll1JOVd4
	PNGvj/XUqX8PZg42L1kjlYBRuTn1W+Bi6hFcQFSodNasn9JqWb/TldUCGKR54bWJhP656hbaoKh
	DChMTdUspwGagnzlYiY0NS/F8ydbX2vzmFGCYawZGj2WgZH6g4NmposjQemHRnu/K7Reirxr3sV
	/Xki7L4TY7yBVVWPRuTluSozOl4cKGDpfVZC65YmRjT11+ulzTYQ86fHI5FKfrD8e7LfUDrsbVq
	9MO8EI7ohLko+IexTXbeO++xMXxPK9A==
X-Google-Smtp-Source: AGHT+IETKIO2cxrT1cZ3eXzUyHUKDprszoyaGoaKc1HytP/YMuHzMaLVDM6g+PqCuavNsU3xtLqWMg==
X-Received: by 2002:a05:6214:5006:b0:707:bba:40d4 with SMTP id 6a1803df08f44-709e88349e5mr37039936d6.11.1755093454166;
        Wed, 13 Aug 2025 06:57:34 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:4::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cd56e1csm196270946d6.45.2025.08.13.06.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:57:33 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v4 5/7] selftest/mm: Extract sz2ord function into vm_util.h
Date: Wed, 13 Aug 2025 14:55:40 +0100
Message-ID: <20250813135642.1986480-6-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250813135642.1986480-1-usamaarif642@gmail.com>
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 16657A0008
X-Stat-Signature: oowzs73m3zs3jtdeskius1uar6og8iqg
X-HE-Tag: 1755093454-640963
X-HE-Meta: U2FsdGVkX189xnwO8o5O3p9PMOM1D+khp3xNm+xxbOk09OL25FETuTgzb9Xy85MSgh6dCLBLYSTMwLuvgl/8q1F3qdkT3pm41bouEM4J8QJGYjzZqt/A6miHxE0AGGAiVMbmOopO32aXdULSfOTqA4OqbDJANrWHR/eUBA9Ep24eA/hKwz2AWgMmPR/Bho4r6Hm9FiVODCcg6+eifG/Fft0ByYgbwdjaYXooy65+0rEaQ7WUr1WrC89WZ84lZOJpqfdmk1tPzFKoCKBFJ3BNXM0IuHSP58X4S/mw9Bu3/Lx5if87rBCLmR4mlz3o+f0912c5vi2uph67fY6BhY7UGZZv+vRYwWb+2pN97WzAMzaPbw2J7i8wYg7xyEzwSjwA4GQ6MQN8VHN/LrtBK4KK52/bZncv4u5TfJ7mCGTQSc4wsg2FOy5o+A5qxoi/EEvtbbvriy8LWDtDmjZc3yu2CBufxcS1ppLB5r2IIcraWI8FcAZEp9AidQi4ZyvKOgyi1vUL4eAKHl+9hVqeLa2T9u6LP6B1lryVlksNko55pMzJfmc0JZ+rO0w0ff1g4uRm7q0UfC8ZjtwrLpSIfm83XbI3/g9jWD5sJk3t7QXiWXpSkgKmSCq+jm2zvOAzfJG035DdRxaJFQmnj0Jq9m2S2snSPr/GZSHKEIhULPHbKHyBEEYLe6x9zI8RJU7m3dsJM3DXrRDujKc3m0elP0EYQNvDoCjwm+twS2pLVYtybd5iYE8UiNHeczEjAH4uwsmamd0nWgp/QQfDveIg81glc95BTQVzjsoxoRw6xSJzsMzk3q24INL3Yu/tHrd2Bhe6zoykAq9TOxifvEooHwmP7JvyW6EjQZa7yZkl/HxGCD7J0GzyP2avSDx4ETenFYJvt3aWXig6KWQPgqxyXAezlr9YDDIgFJGELc6cBDAHWyHKk0LjowpRNol+p6W20L6V8edp3VDZXKX6/hUpxMT
 otme0kTc
 7ulMQTOocsYvNdNz5V/IzEGK+rPFqSZhRj6OcEpicNriXuqkJ7AgBat/t588a0RfUZtjriZ0+xjCeR3mr70SlTSkknJ4ERNJVaUn4a2dRosnuc3F1bdyuJtPxF/PnOglWHWNoZ2i0FjOVpPdJrurg6GcowfyhMVrZ4KP2q/5D2w5Oop9QhC8vAT9Ichqp6+52Ut34ebRkv0eiSoVAycBG6Wsx0lCg7OhmCGrr8hSCc7LQONwYwp8ujgqNa0Y8xX+8jvOh6tfgiTKIVWOcti3wP64O0IuGexA0karMyL5/xJifpLWaNNv9387O/fh4rqHLX/ntnMecLIHWbNaNqIzescG8KzUVW2EKXrgCGpbhjCKAU/UYhHB7OwfAUOFUHUNEKesisnyNP+8lNadT98ckuT+pn9ZX0n0hK40bI/woPOjpRINqqWylN0H+H+PYmClp4xUsTuVCjX2b/KU9VTShRPiG8l+BdNEl74pwuaJy2WeW8aLZyxfoSLr81RCsUIqVLuRHYjdyvxmuQMdYpijLxR6bew4a1LAKeZGA/2Y+7G2etBmgxJWA8IhTmZNA8rlrmuog3ugIYEPnOmR11kNp6U4z5u3hFYPN5/5JW7rKRBrMdinqUIN7piBuSqzyZ0c/HgrN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function already has 2 uses and will have a 3rd one
in prctl selftests. The pagesize argument is added into
the function, as it's not a global variable anymore.
No functional change intended with this patch.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 tools/testing/selftests/mm/cow.c            | 12 ++++--------
 tools/testing/selftests/mm/uffd-wp-mremap.c |  9 ++-------
 tools/testing/selftests/mm/vm_util.h        |  5 +++++
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 90ee5779662f3..a568fe629b094 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -41,10 +41,6 @@ static size_t hugetlbsizes[10];
 static int gup_fd;
 static bool has_huge_zeropage;
 
-static int sz2ord(size_t size)
-{
-	return __builtin_ctzll(size / pagesize);
-}
 
 static int detect_thp_sizes(size_t sizes[], int max)
 {
@@ -57,7 +53,7 @@ static int detect_thp_sizes(size_t sizes[], int max)
 	if (!pmdsize)
 		return 0;
 
-	orders = 1UL << sz2ord(pmdsize);
+	orders = 1UL << sz2ord(pmdsize, pagesize);
 	orders |= thp_supported_orders();
 
 	for (i = 0; orders && count < max; i++) {
@@ -1216,8 +1212,8 @@ static void run_anon_test_case(struct test_case const *test_case)
 		size_t size = thpsizes[i];
 		struct thp_settings settings = *thp_current_settings();
 
-		settings.hugepages[sz2ord(pmdsize)].enabled = THP_NEVER;
-		settings.hugepages[sz2ord(size)].enabled = THP_ALWAYS;
+		settings.hugepages[sz2ord(pmdsize, pagesize)].enabled = THP_NEVER;
+		settings.hugepages[sz2ord(size, pagesize)].enabled = THP_ALWAYS;
 		thp_push_settings(&settings);
 
 		if (size == pmdsize) {
@@ -1868,7 +1864,7 @@ int main(void)
 	if (pmdsize) {
 		/* Only if THP is supported. */
 		thp_read_settings(&default_settings);
-		default_settings.hugepages[sz2ord(pmdsize)].enabled = THP_INHERIT;
+		default_settings.hugepages[sz2ord(pmdsize, pagesize)].enabled = THP_INHERIT;
 		thp_save_settings();
 		thp_push_settings(&default_settings);
 
diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index 13ceb56289701..b2b6116e65808 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -19,11 +19,6 @@ static size_t thpsizes[20];
 static int nr_hugetlbsizes;
 static size_t hugetlbsizes[10];
 
-static int sz2ord(size_t size)
-{
-	return __builtin_ctzll(size / pagesize);
-}
-
 static int detect_thp_sizes(size_t sizes[], int max)
 {
 	int count = 0;
@@ -87,9 +82,9 @@ static void *alloc_one_folio(size_t size, bool private, bool hugetlb)
 		struct thp_settings settings = *thp_current_settings();
 
 		if (private)
-			settings.hugepages[sz2ord(size)].enabled = THP_ALWAYS;
+			settings.hugepages[sz2ord(size, pagesize)].enabled = THP_ALWAYS;
 		else
-			settings.shmem_hugepages[sz2ord(size)].enabled = SHMEM_ALWAYS;
+			settings.shmem_hugepages[sz2ord(size, pagesize)].enabled = SHMEM_ALWAYS;
 
 		thp_push_settings(&settings);
 
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 148b792cff0fc..e5cb72bf3a2ab 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -135,6 +135,11 @@ static inline void log_test_result(int result)
 	ksft_test_result_report(result, "%s\n", test_name);
 }
 
+static inline int sz2ord(size_t size, size_t pagesize)
+{
+	return __builtin_ctzll(size / pagesize);
+}
+
 void *sys_mremap(void *old_address, unsigned long old_size,
 		 unsigned long new_size, int flags, void *new_address);
 
-- 
2.47.3


