Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC7A1CD3427
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 00:57:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC4CD6B0005; Fri,  1 May 2026 20:57:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E6A6B008A; Fri,  1 May 2026 20:57:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B163E6B008C; Fri,  1 May 2026 20:57:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB966B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 20:57:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46B47A036A
	for <linux-mm@kvack.org>; Sat,  2 May 2026 00:57:20 +0000 (UTC)
X-FDA: 84720666240.14.D06C628
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 91D41C0004
	for <linux-mm@kvack.org>; Sat,  2 May 2026 00:57:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pVlc1hHx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777683438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wjZHNgAlc5fbakN7Rg2PZWjwbctlYdmA1M6spjYH734=;
	b=0nMGn6wN9goGzFsm680skTAbb9ZNPFZxldva/j2IUm5FNU+HZrlfNbCUp0uWPq1IP93ocJ
	YvWWq7DIEpLjL4XKoT1Ct9tmSM2MjA03ALmTfuW5Ty4jvZQeuLT2XMAB55C/PPoAaTZow3
	UfnmwTCCot7F1K4iwK1Xkre04IuC+oI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777683438; a=rsa-sha256;
	cv=none;
	b=N5C8VPTWHVfVHe5JwZNW9ubm2YmWuc560wHFrhiTo5Kko25Inzl9P6yJpNwreaSJWWaOhA
	MQ8ePXjGsaYhYNckjiH+S5aBbcaZqVxCsbjvPTvlCMJvjvw4N5uXTafFbMXLtRAfBt+kAx
	SfW/HDA9h5U27feu94+Txub1XJlYMzk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pVlc1hHx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2b458ca2296so14717185ad.0
        for <linux-mm@kvack.org>; Fri, 01 May 2026 17:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777683437; x=1778288237; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wjZHNgAlc5fbakN7Rg2PZWjwbctlYdmA1M6spjYH734=;
        b=pVlc1hHx8bFurWrKccsPzoyvdDtOFDFjSSwnXXrs41CdnX3vPdprjSgqsutZ+GA5QR
         Ec/9J1j/JqSq7M7+0KaC4h72x9lt2OGlgOoetgZN5P5863IZSrrNR5pJJ2RX1TW3NIS8
         mYvtYjioDNkYG2V8ffUNpbEKl/G3KZEPxnrOEByP/MJLZ4GOhzKBa8vMNY73Ewpokhi7
         oLWxcot1yiYCd6gD3s6NmVH2f2sbDhPXLk1IJmtmMT4dcS8PXLldNQ4dEoY1S1UEs2Ph
         XONCxCvJvClpHy3NOjezMdq4Z/qXm1XPaA8BGiqLys+BNelSsN4CKsELcFSXKn4hCfpL
         xNeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777683437; x=1778288237;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjZHNgAlc5fbakN7Rg2PZWjwbctlYdmA1M6spjYH734=;
        b=NmhShwZvY3iKCs7K1bQlElJfPazdAGuO5+k7t6WbEzN8+O5P9qa1VUHpBGefhsWu0a
         rfizv0syxEWVaiCETdL+3wyp2X6zyOiV6oftEIVc0A72WPUMlNsUlyQgo/zznia3BFgu
         xJEG1KF9TrZxXLvvvEKruPonGFXeH5tZva/EGlS/UI0OVtIuknQsezc3Z6ZJ6s6mpuPA
         Xt7x4oJoAaSPsI5KgFxCOviOZTKyZJSsg7Xt0s3r6dUZw50itzlrRI/hdn1Rywx32BMk
         60Ihym4fKTGmlKGT5zopg4NbxHhtXv6VWvTPjseM0zKTRj/gTFbNyDmfIaPlurAHmw2M
         rm9w==
X-Forwarded-Encrypted: i=1; AFNElJ8k3YM6FcHV8TtQaIOT/g7e5nbT77pvIzNA7HDHdJ8+F5YYt/eF8U3S0KTJc5L0np6Imld+eN2kFw==@kvack.org
X-Gm-Message-State: AOJu0YwwmnGczxdx/+gacbxzn2+9DwU6PXZBd6cRgFmXCZd8/266tm5m
	kN+52zA2Bie2qkRfbrOBqn0lPYjmpD7v0S/sh5015PPDLbrpAVtN6OUp
X-Gm-Gg: AeBDietE9IKpQ9UJHecCMv3rYOMcZwJP+vjAT0NjAaRr3qItLMRHeK6JZbHtmrO0WmY
	uaRzfXWfzzGJ1OOF8Z70MytXSMbbI8A307A2qjJEEbZrSXr4Mt60u4zXZSGamRUSVX3hYic+Abh
	mNm1WZyaopj5sLHHWJTy0DRjE1Pi+kpfBcJRlIj7ZcbzxYYOC+lkhdT0GeZSI9TIY+DFa4fqGvK
	oYsaacSzVV9ZdDf0fCCt4E0U8lJNITHX2mEEyBNeTC6LlHL3yOYMzH0vnz42r5dDf7/jkWUaTrl
	HznbHDISv4zAmj4wPtDMke5KQLUgwcESWuxTWT8tJUeLqLkIMHiDJ8KRkYGw5FseTF3tl75Ntid
	bKWzv/e/S5mj97dzDjtGMG6MAE2l8cqRMn+fC1xkX3InRfl8kTQqggJDTiXM3B3XDy/3EgwSoNz
	mC6IS3x6bfItsRy0frUodtLOIjRE/p8bgPS06OcRs=
X-Received: by 2002:a17:903:4b24:b0:2b0:ac1e:9737 with SMTP id d9443c01a7336-2b9f2595fe2mr11583295ad.12.1777683437390;
        Fri, 01 May 2026 17:57:17 -0700 (PDT)
Received: from vini ([2401:4900:8fcb:edbd:7155:edb6:dac:107e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caaae66fsm34192445ad.21.2026.05.01.17.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 17:57:17 -0700 (PDT)
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
Subject: [PATCH] selftests/mm: ksm-functional-tests: fix partial writes
Date: Sat,  2 May 2026 06:27:02 +0530
Message-ID: <20260502005702.593878-1-agarwal.vineet2006@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 91D41C0004
X-Rspamd-Server: rspam04
X-Stat-Signature: hfnh385ccpbkjaanrtcmmzsqr7h9h1df
X-HE-Tag: 1777683438-588846
X-HE-Meta: U2FsdGVkX1/pve0eIOBuOALcp/3Hao0GybBb9GlQWXPlrcfopnAxWc5h2OPYTLNMJPD+jMRcoqfW6NeP3eHKyRygKUNTgg2ZnimtOitzvkbfbv6LUtPqVhLsktAA/l/OdPLFTTqLz3NRxnATnj2VVxecnLRDkGOl78Q2266DCuoEspW0vIos24AT/rmT91bMnah6KobHs+MH9kC6t6YNtjgt/e9X2qoRm8dZJ4JER0bDhiCzMZ4OZg8plVuMii60MIq122xEu1XzAg0j9fqUYW5r9OI/nKcObUaAp6xAOpgcKYkIAl+xeSovCRJq9RHx9BgZdCzZXERlqvBGpN8RkSTvgQ2ALfmzW4KjT590l7LYtp6Xedmc5czrtrokGCPs9epbHR/ihuAj+O9mQzAVniw7KapCEm+habuS4h1mMfcd0LOckbNoVfD24kdPn2uvt+DDV2GXg9uRUgyktG7AGVM6tVJBDbeyL/ZJt+zdg1qP7MQF/79AD0cLVywvgywiyVC0lhykmC3GQ9HywY6byr8m+zihE/kUH0KMnLJ2duJ+tN2I7vY/f0rxjDs77dUTv/h/sEKLeW7lOgKa5LcwMPv5F3TOy8z8Jao/UM87XfZvJu376soof0GbJJEZQVVNtRotftMkWKTCUw/lgnVmeckcoSmmcTmhc0DCDmUANMWw0ZxmkH27oZN1rSiUEf6g1hhUlCwdfH+5K2/nhtZwxq6vEZQhD37OQf96X45hMafpGMKif7sUAAt84cQwfHbK7ZE31Sn0tUMtjE0Tw7OVqgyK1tLWZgi1zFqrxZDAITvHv1gKcbduM9YCfbe/xo72LTVcWmYleYr00hnWfpK+Q+OUFzXCIHx80WqNtWir9fc9YCfMlnQCe5meXn8IhlGEh4Y64SSsuTsu1w6uIRNybP+6Zndwt1G/onevIC0oIPLHRIaWKUiSWxezSRzF2KcP1hXilfODH0s4EjIBy8Q
 cwARQAfe
 SkUO4dcjSV0V0nEzCtwboq9x7slr0eZEww+xqJvFpNeYCyOV2MkfkaxCECg6+TLugcKKqK8Nq6GA+8AFC4WQwmtGhzDsNUsSs+zr7BbR0YWi/NHdJ8niTyeEK2x6LUOyqLMvE33EbudSBk5cJM9A9JiHKoqXCYgIXekkEIP8hU4KvBdtv8nfPQDq29tazC9awvurdlZhXKExYUakUtxDBxPmu7DQT+QBg4enNerbjeEcWPAJBvVYf6qu+mKvWUpbERYW3AJ3QfDHXE0h6fdZN96rG9LjI3hmw2P8o4OBjVpvxLKKG1+N2Kx9Qq09dg+LNUMbb/suCZQIGmo6KNRxa9uLK9VuHs61f4GntBpJYSshdafZPik63U706Qp5yGd+Ca83uK7BmxzoubSjcTsM4IUoAo4OOrWXgkpt2OZvxC5ZFZ1B/vnSZcZ5+i8tHmkqrNhLibWHQOn9mByEVzSZXuTPD0EGYlzrHuLnvmXm3Xj9DjcQUdVBIvhVg+udaCWcEfj/fh1dmlQ1hDak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some write() calls only check for <= 0, which fails to detect
partial writes. A positive return value smaller than the requested
length is currently treated as success, potentially resulting in
truncated writes to KSM sysfs interfaces.

Other write() usages in the same file already verify that the full
length is written, making the current checks inconsistent.

Fix by verifying that write() returns the full expected length.

This also aligns with recent improvements in vm_util write_file(),
which enforce strict validation of write() results.

Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
---
 tools/testing/selftests/mm/ksm_functional_tests.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 8d874c4754f3..9a8c852acd68 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -498,6 +498,7 @@ static void test_prctl_fork(void)
 static int start_ksmd_and_set_frequency(char *pages_to_scan, char *sleep_ms)
 {
 	int ksm_fd;
+	ssize_t ret;
 
 	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
 	if (ksm_fd < 0)
@@ -506,10 +507,12 @@ static int start_ksmd_and_set_frequency(char *pages_to_scan, char *sleep_ms)
 	if (write(ksm_fd, "1", 1) != 1)
 		return -errno;
 
-	if (write(pages_to_scan_fd, pages_to_scan, strlen(pages_to_scan)) <= 0)
+	ret = write(pages_to_scan_fd, pages_to_scan, strlen(pages_to_scan));
+	if (ret < 0 || ret != strlen(pages_to_scan))
 		return -errno;
 
-	if (write(sleep_millisecs_fd, sleep_ms, strlen(sleep_ms)) <= 0)
+	ret = write(sleep_millisecs_fd, sleep_ms, strlen(sleep_ms));
+	if (ret < 0 || ret != strlen(sleep_ms))
 		return -errno;
 
 	return 0;
@@ -518,6 +521,7 @@ static int start_ksmd_and_set_frequency(char *pages_to_scan, char *sleep_ms)
 static int stop_ksmd_and_restore_frequency(void)
 {
 	int ksm_fd;
+	ssize_t ret;
 
 	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
 	if (ksm_fd < 0)
@@ -526,10 +530,12 @@ static int stop_ksmd_and_restore_frequency(void)
 	if (write(ksm_fd, "2", 1) != 1)
 		return -errno;
 
-	if (write(pages_to_scan_fd, "100", 3) <= 0)
+	ret = write(pages_to_scan_fd, "100", 3);
+	if (ret < 0 || ret != 3)
 		return -errno;
 
-	if (write(sleep_millisecs_fd, "20", 2) <= 0)
+	ret = write(sleep_millisecs_fd, "20", 2);
+	if (ret < 0 || ret != 2)
 		return -errno;
 
 	return 0;
-- 
2.54.0


