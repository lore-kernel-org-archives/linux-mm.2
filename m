Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6245CD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4DE6B0093; Sat, 20 Jun 2026 13:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA59A6B0098; Sat, 20 Jun 2026 13:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E8E86B0093; Sat, 20 Jun 2026 13:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71AB16B0093
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:23:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0824D401C4
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:00 +0000 (UTC)
X-FDA: 84900961320.16.3B70AC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6BEC9A0008
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:22:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PHuwwO9B;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781976178;
	b=Ba7hgku0XCiEe/8ra4Gpq/ohUROYSgaIwB18OJr6n3IYi/oXXJFf3Ikf9mZkiyvA5OSupr
	/2paEAuxQn5XxP+S5xvyjRNCPk5kj4neTzWtdC0EhWZWwgNwyxGcBgP3o+xaZsZsOC3vni
	VjPoJ6CKoYfhcZtOHXEsOcA7EwWFlyQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PHuwwO9B;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781976178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGqKzRnIP+DKXc/Th2v0SJe+T3xtV4bAe2ASi7qsS9Q=;
	b=rMj/HupAtE6fV6AVYf7z+Vb63DfneSPH4+gL0fTqMVGh2V0s0ZCoKcYuf6ryclWWHq4Z/C
	kYb81nYpPsqXVbwM7Ixr4z/wW3SpncHBGk2FtXtEkOoL+mmchO1Lb8fPUN3qleLRfwII8w
	XbYQbFTDZwKNfy4H3IL1cRRfv1g7HUQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B04C444424;
	Sat, 20 Jun 2026 17:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25431F00A3E;
	Sat, 20 Jun 2026 17:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781976177;
	bh=dGqKzRnIP+DKXc/Th2v0SJe+T3xtV4bAe2ASi7qsS9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHuwwO9B54CWPTt5BvV46KzE/1dreh00K6wX1qBuSsMco5Bn1SOUpZnm7VX6JvLYW
	 MdMGZO/UZwcviUhyhuxUrslPReBGjTOPXhZv3/T4fJMgqp1rO4e5P6NifuetqTaOP/
	 D9Z72oVcZeluSY7G24yR4lozkuCFFNzX5KcX0sxQcke7w2nODKUudV0iH1waL4z6jI
	 Pz7+d6t0wC3TjdpD/+0KA7Ue8w/jtG6iAWY7evrZpedJzzrZBA+v/YqU4ByFp4//fJ
	 NVdd6RsgPOoPXpwAWlWe+2qcSO/R+fhskyUox+my14LWp3X7sdHpPM4ifecZbx53Zj
	 NDGS2i00Mo4TQ==
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
Subject: [RFC PATCH v1.1 02/13] mm/damon/tests/core-kunit: test damon_mvsum()
Date: Sat, 20 Jun 2026 10:22:32 -0700
Message-ID: <20260620172244.90953-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620172244.90953-1-sj@kernel.org>
References: <20260620172244.90953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6BEC9A0008
X-Stat-Signature: zrp66jndgdsnsh4izkfgip194eksesug
X-HE-Tag: 1781976178-111349
X-HE-Meta: U2FsdGVkX19z/fVUl7gCIa5nYzdSszYdMaNTnGsQ29SaeXaaw+O/w2+UtzdyDHYzZ8fzoBg/oMaKPqQ95M5etOuc9ubcGJkXxZpZkVBZTgT7ne2RACrRHoycSa3wjUTV29bFIVCzVbD9Kspbd8ggoWtk2EVBDdfJ0f8MflgSnz+dKZlQi72dtS7H0gpylEWpPj/J2y1pz7fBWM9vnT9nOef36RtZhqGaBEAMcit/VRzgzFO2mhRB464aUqI9kJhNyumZdm6x2QEAKIFPKjSSjvA+zkIrKzITJimGWssDiTCXIhhp1e1bJEDX7uAzTFetq7spQsvrvfHInXyeMUJN11Vq3yyysi5moV+UXaU+M5M3RUtZ47rT0Y955NXv43xlzffzAYkC2v+kB7CgtyDLBheH9pkBxwyyHk3EGEJB+pZNQZ121IVjbdG8UwAvWme1U34B+c+LNhXBzNsBlON0LFa3pHdxpfMh+Kaz7Vf7YwAjJpRApAfK/8x5+UBHebxY/oBJ7swu+1InAWxG3iefxptvDFS8CNFU+Ou3BgWCBEmAwpG/kObtn+10gjVcnlpeJ3bT7Mk9huX6sjhHlUyf95KMw19J/pH7dWJF315butmpVhgFCbra2VuILPpVGZEYO5MbJFFZhld9gEA/ArahX0tyK+IWW/gA9tSFepitToBOgj+eGQO3ZeyWqBruEm2dzNqB5DFrJuvUwjKAJAMitP20aJmHZns//0P/YyjdJJobObSVh7G9TApfCQP/ylqsEc4HRouVnhs+5itcITboiXRN6OGSAbhPpDZVcSENu0kO2DkiO39cSBKoWmNr/IIzaGeCOV6vtp7BFS/hssqiXevREL57jPDMyxSXCO1LYf4ljp9sS2jXcDAWxWWi+pRsZecMOPkBdOPT23/T+ip5mu2YhuE7dWYJTiDdo6Cg6oJ6h1ZCLBd1dBh+SULWZyr1uXe4kLSMyNQChBUM/wW
 PVKQtApy
 TwbvFAUdt2Ix+OiIWu/CQpRnW5w0/GqPSN+haJwd1TG/+RL/sqdk1y2uUF1hTbkxlUqX760++oydCzo2v6O9JrxsqQrd8+GQlVzlSkFDumlMIaeVvhriVoEMWdNHGzeA5KaeWfdhZ4udU1Z2upynEEkiEggFGVMB+eZNBxTboa1BdrdwqD8EviqsPcTPS82NlxF3QcGxTOJs/ZFPJhaqoDZCLdPWpzSV9dPaMDw1wehZmWC3prz/N/k4vrrAQiNg4GYaZuj1SIuREff8+CStGCfxL7A==
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

