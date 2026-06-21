Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71E5ECD98F0
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:57:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D01D6B008C; Sun, 21 Jun 2026 11:57:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04EEB6B0092; Sun, 21 Jun 2026 11:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E596E6B0093; Sun, 21 Jun 2026 11:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2F9B6B008C
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 11DB314025F
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:31 +0000 (UTC)
X-FDA: 84904374702.25.F16E1CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 86C60C0003
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o0MnpeRU;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057449;
	b=cgaGdPEDamhW6aU9McqKMgyCFvX9DkuFnVZwaQiClYZo+KU9gYCwNjXLvh1erG7q7NrKn7
	lSftfs8oWRcGlglXEGTnLT7uQ937BNvhsSkVMs8f5iBVTosSUa0jiU3dQXEPlJN+dwSRa/
	t77BiyZffb8kPNtqm9KGKdTvcHdoCCE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o0MnpeRU;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dGqKzRnIP+DKXc/Th2v0SJe+T3xtV4bAe2ASi7qsS9Q=;
	b=DFZjQw5BW/B3w0hKHaz1ofOET7qBJvNcL9Bku90N1qNW+z1d5Btoc7HWIHAHIli7+z4l/i
	GZz05PW+9oKuO6E3gCAJ3m+J9kemyaWjKeuOLUJAgLdCWDPAIwMBMP38luYjaFI/QDby5t
	siy4lTV4bhIM93ed+e2wGBEyGXMzTwo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C740601E2;
	Sun, 21 Jun 2026 15:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45621F00A3E;
	Sun, 21 Jun 2026 15:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057448;
	bh=dGqKzRnIP+DKXc/Th2v0SJe+T3xtV4bAe2ASi7qsS9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o0MnpeRU7Bd1V5NtFQdnEKhZt6TNXi+Ip9i2mq+QYLhqMp7sfjAtmQbj37MTDbt5p
	 ztl+93FSsTnNeksUONb97v5/CytrjrsIZiFRdW5nY0efklO5am5XuZROX2batRQaUF
	 DErYKF6n9Q9ErKHqqCGaBumc36cMXNI2RpRcL9E6HrPmjfLNq5DKvPqTWt6dGGuVyB
	 FeQ0dzd0BbUBLL4izOmz2jtUBE4fJkGcd6ikYFfm8lFZqRzsis9iX0onNMsMW2T0ri
	 VLIDbNND+TR5LFxqTS4o6gY8sB3xNu90/c1Xiglfo6FLoPMmKxj0X88uQl2YWhIb31
	 /uYW9j6Ru6L5w==
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
Subject: [RFC PATCH v1.2 02/17] mm/damon/tests/core-kunit: test damon_mvsum()
Date: Sun, 21 Jun 2026 08:56:58 -0700
Message-ID: <20260621155715.87932-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ykfi3rskixhzyy9myjr3rgu43xc44s8x
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 86C60C0003
X-HE-Tag: 1782057449-341844
X-HE-Meta: U2FsdGVkX18xD35vuqwH52HyanIrvkd0jbw1h9qymRRS9w01LCocOUeMM/Lvbz26DqJWBEoMU7HJ8CiNTaTURzJQMD2KPOLYyVp9IoYDcUd/fwvfNNGGQZ0Knh5z7xImtQhb1Dluygp+a/T65VZUYTplhbhw5uxJZ1pfJiN/uDG16LzZ+9yhnNsVkwI6tk7QBtfLIKy7fKvDnlmbogwlzzO15nIz2Xd3u/AwamSK5Cc6F6F/GFYnUeRUG28Ic1X2KCrqz4pPdzCkwToEyt8IB9xHNr7bp2JkNgB+ZjFuf7GMBesq8i03+Xtb4XZ/R4WzQ/+u9nTqZaLj+/E6hqosbE8kMg1GSeRdXjY4mG2YZKZ3htp3Bsyd8DbI96SkjxRsiEr7kMg1I/xWwy9LRANU+hy4Hh29QmLMyS3hL0LK8Ksk9LJjfwymXHV63w3Rkkn8h/r7i8+r/jBORT5dJhE1TEnT+HzYcdO4uBuOzKkZ1TOQBYI8N3BCaSsLNv9dY0F/g62WBe9jmYSEImvqmbXWh4bU2cV6wkXQuSIYRxYO7shRi7li2t9G6m8mGXDi4E8r9CKIMdV/pIzb4zJUGyQUpuvKq/JZzDxyVCtEsaJig90nTdhCkUrlmZ7pYEvnYCzTtvv7gkI2to3SK1tT3fSu4jFSgHaQ7ghE+vGUoWRgpbSLbaRrTJiLdPcGk//7VI4+Fwh04172AQIbOj19PDKkZygqZlZqIO0H06shzQVheL0Wy1Xhg+28GZbDM5DpZzity7j16XJgLWpcI8pGh1Cntsl/U3jLq24ToXl6wWWj/CJZUASosJ8qdRd0VU0QPMHx06bAtURxW6lS8K9nNWp0rhEvqOVwTg8dXN/erFJ6whLdOqPXTqLu+IEdgW5EYDOr0h+tpG7DJ9gQIH6ilE6TTrfZCtYfx5KAKRsj2kgRcgPlzhrLuESLbtpz275yioJLvKmfB7r4TuGFJQy4k9q
 PiSsrix0
 mYfkwQLmZR6QuCwaiMjCSr71G1CTwbJ2szyPSJ1DQH0tCjHCofooRNroFScx8CyGs1EG9mFK0i6jqCnarqkz7fWH2kCNuX/ogamR2Pxp2W01S1gLeN4dTEK2PEY7SWieyegqeQqPaH08fxESbcg10N9DyQvfDgyPcan155/yqIvLuIo/4cPzZQByZPQtxGgWPfRvGv2JA989AeH7YPd+zU6PVFLYeZqsDOqvJtaRp1gNNJZec1GH8iDB1fyTNeGfdGm8/d825OkNo1uzGThNo5nAfuA==
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

