Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 382A5C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 161E56B00D1; Wed, 15 Jul 2026 09:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139D46B00D2; Wed, 15 Jul 2026 09:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0767F6B00D3; Wed, 15 Jul 2026 09:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAA486B00D1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:34:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 47DD9401B1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:34:39 +0000 (UTC)
X-FDA: 84991105878.03.E8EE5D1
Received: from mail-wm2-f2.google.com (mail-wm2-f2.google.com [74.125.225.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9C30F18000C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:34:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jh71tGWj;
	spf=pass (imf16.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.130 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784122477;
	b=eT7jfs/1q3bHiuAbfeSwrAyEEg9ObGrEQjq4qzQy39i/rLOTzTZVWd+uncOXJZfHIfogks
	2mxrVke9TJ+sh9e/HAeK9rtFtePTgo+QWvb39vPI3AC0IGmyleqC37oDYF3o2307nEGQHt
	dFJUhBnDNwf8esrsoUWL+5NJ0KZbH7Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jh71tGWj;
	spf=pass (imf16.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.130 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784122477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gpdCEuNC6+ipebO3NzplfX4VLPuQi09kjzb5eK7FZmM=;
	b=OGI547fg9/Fu/NAsU3HW4THs3x/G7SDbba9E36mH/MMV7yN0HM5/KrDpCb0yxsy8lgUXSD
	L+L+UFVdTMkFeMwIUMqEgJ9UX3JKmL0jrfh1xKnYnowWX25BzhitI2qXr9tPjGoplWY6OH
	OWu9HMLHSWtuIdir4bHix5j5srAp9oc=
Received: by mail-wm2-f2.google.com with SMTP id 5b1f17b1804b1-4926d058720so5658495e9.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 06:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784122476; x=1784727276; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gpdCEuNC6+ipebO3NzplfX4VLPuQi09kjzb5eK7FZmM=;
        b=Jh71tGWjnVQOcCFUMFxjLHIROmldE6m4hyNVbBY7NaCI3Ckf639lwbauy4v/xnUCLa
         ar5tIyBL0dXjOWSlVdfi1lDQSbGJBFCPnd0lsnOm83AgkSBNe7/rKbo2fXeUrbf7DsYd
         Cyb6dnd6TuxkyYKCn/eCQlu77MmLFyY0GJKjo77V9vFrMT+mk65+1LN+pjHMYB+8gWbN
         WTssAsTJH5DuoIs2HnS7F+K1MyTT7EOq+4fazGe62kiz+/M1MbpCZNbUEpG41GBv4rWl
         mr0s60dCZwt5LoqAavfbaNCnv+yfmnZWh8JGUibw1wCURJj7J8Mwu7B1+zGmrjx92MaJ
         aVaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784122476; x=1784727276;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gpdCEuNC6+ipebO3NzplfX4VLPuQi09kjzb5eK7FZmM=;
        b=rEKhOSlx50xiLfc2WT23j5Edx0j5M1CnAdegxoAbq15of1+oCn55810GzCBjMvmSwn
         L3cX1E6NhuYJkrwJ0Oxa1SsKRNnG6ucRW4pnByHWaH4wtKE6stjlD9+rXIZZM02eTLNA
         PylQs+aJ+RIttWEyT27feV/yhuecFSbLNMSbSN4gj9MsDHbUytRRYMdI5qjAO7lQoJQp
         A8Rkd7aiCAHTf/Os7vLSPCXMtcZ5ltJ5VwjCc8qcXUI6NX7z+Bs9r8Uq1c9pzClAPmvI
         IwvLK6kByJdj2vpqibTFDg89NV31n1Jo024dMELO4tG+ZTSLrkS8WqmRRd1FcSbPEkkc
         Vr9w==
X-Gm-Message-State: AOJu0YzfbyricLX4zrCILgc7FboYbkc7suZxKdLORzuGxjjWQsZTVLJp
	/ewPtOi4m0lXpztOXS1Q8ul10tGTiMIIoiVtaraunJJuaQijEQh4p7Ca
X-Gm-Gg: AfdE7cmU7hfNukKAhTwuZVuDMaBWBakQ0/KOwAvfRCd6CGf2hcp6AyrwMejUWD7ooVc
	W8KDL6eaTwpCdiivpn5vlzdUqKXO3cu2o8uqYLF24hVY8HE60uOBc1ftHaSRipdW1Vw89IFcbfo
	XTD42dvLy+TECszRGY1damAta5/KY2HhSKl/MyLyb0r/RJDkF1zWCnhMJxvZP5MydhS5I216dVI
	OqK+4A9/wIAxpp7LHBwU1Y454PskTG5nt23b7ciaqU/4Baj9ANCXwPfW4nSLLSOzTPGsYc3Ot9D
	+7wWNX8sCpWU+a/qursVH/vI9+P7RVmwuwCVvgZi5W2BHZwk6AtBWoKZ43BTm5McyOsUI6xGF7y
	5SwqR4HzSpP5ny82ROfizE2r1DK3Zxz53opVPxbsHqM5CwYntlALOZhEXjWdvFykn8qD50i4L4X
	WoHJmHHR8LqoRpDUgOt+WFxgn0bivY7CcE+62dH/y/g7IOJ0UsJMVO/u04I18nR0QJ9AqnLGWoP
	BJyZXO96ctANLwZOPLPdrmP9/giKJKFvg==
X-Received: by 2002:a05:600c:a00f:b0:495:3dd7:ef06 with SMTP id 5b1f17b1804b1-4953dd7f0bcmr26130985e9.12.1784122475929;
        Wed, 15 Jul 2026 06:34:35 -0700 (PDT)
Received: from lima-kernel.. (host-123-106.campusbrigittenau.at. [78.104.123.106])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4950a322c86sm142033015e9.11.2026.07.15.06.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 06:34:35 -0700 (PDT)
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: [PATCH] selftests/mm: khugepaged: skip swap tests when swap is unavailable
Date: Wed, 15 Jul 2026 15:34:17 +0200
Message-ID: <20260715133418.170386-1-jaeyeon.lee.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9C30F18000C
X-Stat-Signature: 7yworcxm8pprpz8feqp3dc971zsjy93i
X-HE-Tag: 1784122477-460991
X-HE-Meta: U2FsdGVkX1/f7SEUZUF/A1LJEFZr9bZHTFU6HU8Q+aTMrz9NwIFtr/Hf9SiVsiweDTDapvtQThL0njHl9sWg30mAERFP6lgxJxK2+HXTUbmJ9Jg2B3x5j0erc5aw3h9sT+f3Ju0rD2K3lT2E3rAyT3AEbbVqGcxDl6If5EqFjYZ60iIPCypmmaM3g8+kd90k2HluZJYk4GDOdDux7RozLRE5S5P82bEbfh66WeJbcnlmrq9EeJrj97O6mVNsHdVRbRQG/v0ytb48wCzR5aIUJP6qCFpkvDr5gH+A/5QYG4HjG7mrjZtaMmMn0ZYjlorJbVPHyN46r1REgLiHPDJva4qjiTmdRptfu+st99lTnkaThS54kZOLyoO251yb/lAKuY00aefwZd7HWpdz58MQ75Fk+iSIpCe4R1hCylTdfaEk769QjMd2TOG9MvovQa0szm/jkarZN36FUXDyI1/Ttl/2BdC5+F7srTiIGLRhDHD8/HuZVJKS0yqvl6ZnrUijKuW6lWulH1XStR2pO3mYdtxy+Gq8qIzgBRKf2oFu6BeA5auxUTQYksA9G6l0ZJLw5BMAqChQNkBUNhNnYmiUvThJSDRZPy+5B/te99ODTmdmfjnvvO0Eg2ya/SjvvtmxFedqXpvNDAAscLASoZ1iH1sjKUbS2Q1Cs9Uk75qqRQviY/NDYVGLfTzC+UHRJ9+oEyD1liSiMC4zazI+n1cQrFr0be1HVLI3z6edoN+/VqQBkQ2aRnuy66UGk2AhaMJQSh4N4mS9+WlVmadS1cVMJWU7WzP0l/naSmuz9GvT04hOEtxfkvn86H5+diRscaYNEHFfYODBMA4vBhsLlYDBA9AaMGZMDjOPXyUpjEhILvOIckoR+CAkpMf5zPw/jtlV4z8dJOK1Hds5atmKl1oHekj/Dh4bRkrnvhTVyDWMyWKZZqrNzdGIp6LuEKDVIvGcbAUqZVSMpoRwThM1zXe
 tZHECyBE
 F61YblWGaAcY+nN+veIUnLtQHRKMhBMcTHzCmbC92zmpr5cb8ae715Hflz03Vlq2Cu0nnDd7TWtqsLPm4y6tTXE1Dunyyfw/1xkqepNfWnBC+Bea6JYUSKBLx/G/HKLoVQFZB1s/9rsWE4bccPPGSm3uvbvv8Us5BZh0tAZMMOYzWHUCXaC78MzWV2qmHKmEm/rKMqlavYqaehib8qh3H/mPdtEYBUrtJFtz7JwiKZdnA9Ro0zT8QQkxbWVOnjT0PjjwOfs5nLp82nC9ym5dE9TzHEvfaiO/zQwAODr+O+h7RhoWmIwp7nqASTBBX8f/VU3A0DUpWkDvqchRz20vW++sUIqv595OrXb/PzCI8q8KK3//WlKrAOvie5b4Mo1DFqReReUXK1F4WFE6zPmvnHWT8K1aVPvSHeRAr5tygHT/8sEpIDBXD7XUZ81G1K7BeHlItFyB/pxkZFm3K4x2ZYLMhCgjquY5CjPKONsOA/JSgTJw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The collapse_swapin_single_pte and collapse_max_ptes_swap tests use
MADV_PAGEOUT to swap out pages before verifying khugepaged collapse
behavior. On systems without swap configured, MADV_PAGEOUT succeeds
but the pages are not actually swapped out, so check_swap() returns
false and the tests report a failure.

These tests cannot run meaningfully without swap, so a missing swap
area is an environment limitation rather than a test failure. Detect
the absence of swap via /proc/swaps and skip the affected tests
instead of failing them.

Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
---
 tools/testing/selftests/mm/khugepaged.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 10e8dedcb087..f9b4ebe733ce 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -100,6 +100,22 @@ static void skip(const char *msg)
 	exit_status = KSFT_SKIP;
 }
 
+static bool swap_available(void)
+{
+	char buf[256];
+	bool ret;
+	FILE *fp = fopen("/proc/swaps", "r");
+
+	if (!fp)
+		return false;
+
+	fgets(buf, sizeof(buf), fp);
+	ret = !!fgets(buf, sizeof(buf), fp);
+
+	fclose(fp);
+	return ret;
+}
+
 static void save_settings(void)
 {
 	ksft_print_msg("Save THP and khugepaged settings...");
@@ -742,6 +758,9 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
 		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
 	if (check_swap(p, page_size)) {
 		success("OK");
+	} else if (!swap_available()) {
+		skip("Swap is not available");
+		goto out;
 	} else {
 		fail("Fail");
 		goto out;
@@ -768,6 +787,9 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
 	if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
 		success("OK");
+	} else if (!swap_available()) {
+		skip("Swap is not available");
+		goto out;
 	} else {
 		fail("Fail");
 		goto out;
@@ -785,6 +807,9 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
 		if (check_swap(p, max_ptes_swap * page_size)) {
 			success("OK");
+		} else if (!swap_available()) {
+			skip("Swap is not available");
+			goto out;
 		} else {
 			fail("Fail");
 			goto out;

base-commit: 7081238c5ca29839924f13bf5daa80763bc589f2
-- 
2.43.0


