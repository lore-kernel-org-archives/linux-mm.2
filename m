Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F8B9CDB470
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C1596B009E; Mon, 22 Jun 2026 10:21:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 198D86B00A0; Mon, 22 Jun 2026 10:21:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D5506B00A3; Mon, 22 Jun 2026 10:21:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12B166B009E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:21:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8EF24140189
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:52 +0000 (UTC)
X-FDA: 84907762464.10.4B6B8A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 321172000D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hKFS2GeK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGqKzRnIP+DKXc/Th2v0SJe+T3xtV4bAe2ASi7qsS9Q=;
	b=NUt3CuHFJYp+3U3EKTk3Kt1JprPOJyNDubzcFw6ltp4jnPsAsTYSg/VSVNgMhp297CAyvJ
	i72AOx5GpRSIXbkvCN7IaEE7LH9Cwr9jc2BnccSBw40E8FmcHUk+xs6twC5bPDdLSMTw1v
	uAmZ43ob3VGzVHCHKF08P/WRufjdsTY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hKFS2GeK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138110;
	b=3f7JYAtOyuCRhy5C5eWv78+xRukqRdWEGX6TVpS1IHsJGWLFp7guf3TfGjagKO+FJgQqkg
	+m3gJen2kY6GTbV5kPC3jBX2sy7u7IkH7YUNMCVtx7yeJmPKeMEYGHroo6g0za6cyulaK1
	e4szxa42PqpVEyK20HTq0gvCMEn0Z9M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DD8D44177;
	Mon, 22 Jun 2026 14:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B15B1F00A3D;
	Mon, 22 Jun 2026 14:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138109;
	bh=dGqKzRnIP+DKXc/Th2v0SJe+T3xtV4bAe2ASi7qsS9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKFS2GeK5U3MgDNMoCsMQIKsrh3pn/TsMBTeO4WBg4OCVz3wmpQ957Pw8ugD9nw28
	 4oThG6qRW4hz4M5XYkMs7YTn2obP7oJV/DnxX2pP9I9OoW+M3mlJMK1Qfw8ujVZnSL
	 LNKf60nNUEvRrMFCmzc45s1ioplG2jl4N2pmTJOWtPqInPV+U6puJJrPzLyx0PZ51P
	 xM6id3Xp46vTDnId+acniulVAiMk1PDmOq80ISfeLvxrgE4COuDIThpAKfYqgbMD2A
	 Q0v8KcqpCFDv0dz7qnLIAs6Z6bMpbSgiohiEl6mg4VsbqBiWYv0tL88HyX9jQ5if+j
	 y25rTKguMgfNA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 02/18] mm/damon/tests/core-kunit: test damon_mvsum()
Date: Mon, 22 Jun 2026 07:21:22 -0700
Message-ID: <20260622142139.30269-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 321172000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: w3ryubhy8ob3xudh5wy4fyhwe9zus69c
X-HE-Tag: 1782138110-582556
X-HE-Meta: U2FsdGVkX19jjqSPgUZ7jVwfv1vtEjaOc0Cp7mT0rorZH/2Vps+ETuuNp6Uz+INVJPQT75uS03jqxnQeGs1k9Ulv4yWXeCq8KRr+DuQ2qA0BN4VDCTNOjZoJP/z4uZqcrfReQQ6j3W2B/7FFm2KZZABY99y+FoitznzBlqdN7/YWXZWtk2OaL7Gjn07fJKSBaeknlDoRjiYSpO4SPjsU8Mz2vJA5I2GQI0O1e9rnYznLaUxDcPcWeq7cEYMhbF5di+5GW/zeE7RLGXfSl6yhM4fcE4FHZ5cPvn2g7bQbbk3XLFmdQYCRpRBhoM440tIbLC7NOoGGy8Hr3egvf6t5APn0hir1b6qDc3JZTbLTBfV/35xOFSh4DjyHdkicwFPoDkyH18bqkAZ98UlEEOdM1SXGmlsgNNCZUBbH9Qe/WKenp1oN74bTij1/6R6ePIdj3FV9cn0we3UtnsER2njXOdVt2PX0AQqtAAC0Z+bu509Mb2rG25nncXft7C3/L8mCGC87ueSbAotOqY0823uEpTFdOpO7eYGo8gCHfLrMgr7uXi7H2fUhgFtLEK6bOw7SHlvVmXdIO0SLgBF/UovTpa7hhxoSU5aOCDlL/ACSgYNuhG32QPYnA/Szbe6AqJujaOf8c74NKazUYZbopkdvcp1RvjkAe4VFxhR7+CpFB7yTlLHvj/YDQPRUGkINOdu6OMWgx+bceSysfRKToQJiyCrKfj2idRTKURHcUVqw9/qVmhFubv0UwCWAbcdLRgCadGVn36S8G9f0N+qNrzTQJGtCP9y69IGhXLRtUVIxEN42tNvIm5QR4XBByij9Fl6TWlqSNSPmfKQPx44Q454xOOU68PiX/1X2kT5NkTKm+ZpjJIillybbWlep33MOJNtyJKBcP3VIdXnTRe2tKHIg3J+NMQ2cRunzQ87WpnnBpbzJhlIWpi7a6y5KRy1FFFrHeM8EpnVS5LecwMwNuD3
 BfwMfTuR
 6ev9UK1AAzw9ih8K+IE/8DEMpt1fPXR68E6bahYAntcS739z5okqo2LMyOqBggL9zwu7zHOvVPzC57JrfXVYVipzhOL6TUwdTmHq/ryYcFgARAI6YAYlIwcois0yEV2de0KEicnWcIXWYrMWB6TDY00StlXOazU0NOi51tqE/JKEcmUAYswCDGL/9qvk4PmxT6UlU8J61dKblf8SNUD/Rp9LCmVlw8tI5YJwhv5PpQy7DNc3TvTraKLEeXBNHaWN8JYkZiH4NRVA932DqazWuWULndw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a simple unit test for damon_nr_accesses_mvsum()'s internal core
logic, damon_mvsum().  The test contains cases for just-started windows,
partially completed windows, and just-completed windows.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4e448c08c724a..cdab14396250f 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -623,6 +623,30 @@ static void damon_test_moving_sum(struct kunit *test)
 	}
 }
 
+static void damon_test_mvsum(struct kunit *test)
+{
+	unsigned long input_expects[] = {
+		/* current value, last value, remaining window (bp) */
+		0, 49, 10000, 49,	/* 0 + 49 * 1 */
+		3, 10, 7000, 10,	/* 3 + 10 * 0.7 */
+		3, 10, 5000, 8,		/* 3 + 10 * 0.5 */
+		32, 100, 1000, 42,	/* 32 + 100 * 0.1 */
+		42, 49, 0, 42,		/* 42 + 49 * 0 */
+	};
+
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(input_expects); i += 4) {
+		unsigned long current_nr = input_expects[i];
+		unsigned long last_nr = input_expects[i + 1];
+		unsigned long left_window_bp = input_expects[i + 2];
+		unsigned long expect = input_expects[i + 3];
+
+		KUNIT_EXPECT_EQ(test, damon_mvsum(current_nr, last_nr,
+					left_window_bp), expect);
+	}
+}
+
 static void damos_test_new_filter(struct kunit *test)
 {
 	struct damos_filter *filter;
@@ -1501,6 +1525,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_moving_sum),
+	KUNIT_CASE(damon_test_mvsum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_quota_goals),
-- 
2.47.3

