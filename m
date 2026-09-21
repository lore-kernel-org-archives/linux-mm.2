Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64263C982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624D76B00D9; Sun, 20 Sep 2026 22:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D5496B00DD; Sun, 20 Sep 2026 22:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4752C6B00DF; Sun, 20 Sep 2026 22:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6B5C6B00D9
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:00:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA52980520
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:00:25 +0000 (UTC)
X-FDA: 85236114810.02.E4A41C3
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1D33F40006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:00:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VuRV6Y8g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VuRV6Y8g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789956024;
	b=saISrDHD+dsN9KvQaO/Z0MNaLp5NRQMmrirkF9sjjJs59zQhU6O8ltF67rDeKSc+S9058V
	RIXlw8kBugbtmKgwzpej220JdfYksIhie0Zd+H1HTTTJfGklx9Vth4PKEpSl3wiWWQi6tw
	o73+P8fc5qt7CZp4dB3FLRQDOVVc6DQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789956024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OijqBYKK0m6rMTpt09frMbajAxUXg2fiGkgxoIrzzPc=;
	b=KqhCYxO6HPirs+F4S7rUs8rmOO7HevZXjsUOC0A4rodhQd8sD2n0I00/e+OU2YgoUK+8va
	8CH0qLfc89UMmb8tyxlho/iFnDEkW74hL7sDCNRRwq2YOfHBRqjBreEtyWCXQzte4CvM9s
	ejTFx4J2xHyagevAZQeRNhQlk1N3djs=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485933b24c3so1219968f8f.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789956022; x=1790560822; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OijqBYKK0m6rMTpt09frMbajAxUXg2fiGkgxoIrzzPc=;
        b=VuRV6Y8g7+486jf5UcEIvL1n410VM9CCHK+AYR/99XWIls6aUlGfQswJ3Zh6KiaI2r
         XJijwQ9iQos8XPSRQRxF47ODFw/geb/0A7aMFVqGFwE6PtMX7Am+7MD/obkqkWvo9pTB
         WXjze1B7kTvRh3fHoPS7oFa8FYG/xmd/eIk92Xnlfpxc+EKjsnhN9rAbPOWh7Jom6r7z
         CfWYtMr2hRrjww5EFw0au8eXpeIimKUvogz69eaMV1+n+Rhy6pEHDqPcrFWCjxhjv6TM
         RzNH3j61BiGGqJ+EC3NTbJpWKAN/hvL7IrkNooPywhF8vh1j1leLKUXEygnQOyR6Hy0/
         vJcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789956022; x=1790560822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OijqBYKK0m6rMTpt09frMbajAxUXg2fiGkgxoIrzzPc=;
        b=slLNy8MpmAuGjXrICHBFw24AZnYQ3k1n+tjK3UY2QHWRUj64YfM4v07bo8bxeaJE/8
         UnhM7OfmuuUChdpRcdBs1Cw51WncV9IZIhFj1seUIkiBdhZPWyXw7jB7rpSWHhaxVBP5
         O+gOhnzw4Kjw+6lytC30a6aZTJ+zLSB9zH/KEsi+dX4rS30D09hWWI1UiLH+rKoEJY8O
         bfOAR4DiYfYpFNUH8uL2nw1WPjfJi8T5hApM+WWMtHF6WtPljEdxqqt9vErM1Cl7ystJ
         zue6BvJsbEzvhfdF10lXpnM1Kehwu688P2l9s2ZW+iffe2Sjr61HA/xAe6Jlze/rIl8q
         wF3A==
X-Forwarded-Encrypted: i=1; AKwUvBw9U7S4O0ZFntKVgrdPL2yYS44ELEG/dExb1pLP7j8GHer1OUHzFoa7jBtawzauMix2Oc8vH4R0tA==@kvack.org
X-Gm-Message-State: AFuF++lvIDPj9kVh0Fn08H4Yvg3wSxPSbiQ6SHPrfaXsE/oZTDsS7jv8
	K8e7GvhcD4RjcOcdYRO8F7x37AKzh2yQQrRp4+HWA/DpiFAbp6ahfU2d
X-Gm-Gg: AYBFou3I4N3h2HOrjrNo/QN4jJsJiyCJezpljm4rz3+JyYuyJT8IvNLTdyvYq/rEDVx
	Z68KijKARSGAcPhF054xxlKVxqthP8P4x14EicW/SVQbb16EZl3/sLOcyi7GJcKxp6ah6A2EKGZ
	D7PT76WLeJEE2L0QJUUPkwpwtCEhLQhuuxXIcCawM+kATr1yX5WlXleYJuCcYURr9thjPh5Vg9F
	3A1Zt/AcUes2noJ1XCfSJ/+3qtSuY46fgkZ5pfcDb4ZWvaLIsMtpWBrLDujPM8eYv+V8SCSOXHD
	AuB3Z9Z2rscQl/qQSOWimRWQ/mKSujgoN+bo1zGSAGRB+I/tvZ5NRw4XrhfhIjvU+SHIuowqm8Z
	g1NTMxWbzK/x1sR9Td+dg+aHlgHInl9+D+Z3xWT5O4Ai7e6RGiTKPxaEcxcLDayU4Kb0rKW946F
	TGPZCw1VKkrXAzoFQTeedAyRkshJzsyTUUx/IetEJus/wc7xrpe86WtbZIYVQQrrD9oFtlJQroH
	DYvoOcPf9a3c7HNx9AwFeBTU4zshHFcJ2AvgVP9qXsf3pH7nySeVlbqDtWxbb0jxRf3lHkgY9Ld
	0HaZxvEQecrJaQg5buzw3DVSUIsuMRksYQYKH7hSPa8Nd2vNpdZ2juyW+ZUEPB/HnRXBc+wPBuK
	TRg==
X-Received: by 2002:a05:600c:1f95:b0:49e:7862:c09e with SMTP id 5b1f17b1804b1-49fc57238b8mr117988965e9.14.1789956022582;
        Sun, 20 Sep 2026 19:00:22 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a8e9-c501-2c36-515f-49b6-c492.310.pool.telefonica.de. [2a02:3100:a8e9:c501:2c36:515f:49b6:c492])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fcd10273fsm193284995e9.7.2026.09.20.19.00.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Sep 2026 19:00:22 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mm/damon/tests/core-kunit: test PSI goal values with explicit samples
Date: Mon, 21 Sep 2026 04:00:13 +0200
Message-Id: <20260921020013.33105-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260921020013.33105-1-kmehltretter@gmail.com>
References: <20260921020013.33105-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D33F40006
X-Stat-Signature: fraai7btcbwq5jw76bdj9hnccsfwmy38
X-Rspamd-Server: rspam01
X-HE-Tag: 1789956023-544301
X-HE-Meta: U2FsdGVkX1/Q3q0WqhuihHX/ZNQ+96Be/LMOzzfr5LvgfaxrM1HnpCKwFzFg3mzabB6/Y4MfoWsrqnjIekExsyo3/nhJdX6anU9918c11JS9YnawF9rCsSxcQs58+oYBtlI+JGUEFlfwwxjsP6DDU8+Bc4FdeO/ITIUK2YcmhH2xOGIOjE8IJNhf+8xnfNXCZpLcJ0uZ0DjtPyAucedtmLbRZUnkbfZO7xQrhXQzZMR94FUj8hoP6HcjaF0goOU9tIGVRMzKadVZnlKToTaHZzL4k996osfmQEDsWeGito4y3yAQZHF/r+nkY8w/j9x8XECdWpc/TijfcMsM7Hg7nzCunfPx63pf06+lLzAaDFQqFpkIXw/rMiRB9znMl2qMbjbRTDkBJNrgshHQW0/7UAEl1t2+9XS3Nx1wC86DepIo2PhxP/TfHst3GHNZJv/5j9SS6W0LsDzVVgvz0BuCjeAXzhz7kwHUsXQxwriVfrMTNuICCUpLh7LG0u6ss3ARZVRn7ys6I/hzmTcC0Sw136MNyOqU1VD5Jw/7cOXKTJdUT59W/izlxcf/d6z/M3aODZr/YhvSPIkqG9JBywtgIlbfMXUFPSmJFkCdcVpI+1l/1ZpddP9anTUwMmhihiJtNvbm8jeDOc8hmpVkEE/jIZahTp0lT93NNMZpMmf9Zc6XqAx3R/Y/h1GNOyKowqMHK6D+isCf7ymbUqHE2rugi3pbmUi2zRmWrYdFP9uLJ6V1cpBjMTFf3zK9dcWiaU3sVM2Ojn6Lf7Cm7qEc4PXDGzsOQdWKtBQySEx9bAZpp0XP86awerCUnjYDboxO/o6CCLDTmKyZwBfFa4KjWlFWbBFCEhZu6omSWmYLCRmu7fmEICyT3Z46c3/f6NvADR6/fJySSa6ZdcJsTv8JRWLvkid6ywwW7rc/e+9ceXPt4SODfZCF+XaRU/Ejt3TkBWJt73X58XYCIzu57GLZ4Am
 amlDPA2W
 aMd6jV1GJljY3N6eMM4enbmfvPTiQ8SWEjXhMBEHQCSzXfe+/rwuPIUJ6e/BHtawWFJyxsg8a2xJvfLCPseBUwRzxKHwNZNNIJp5I/4UP2s6XGOxJbzftBPm5Kio8uZ3L2d7ApW7ocPfpLoXICl18TjhlC6Qs9Azxgl+7riZH+JomCu9ys/MUjZLJB31KsKyi5QL3XBMYRHU03gvpvKWy8i9yKqjtVoDCd5LnT56y+VR9ga3VsFKEawXBrxCbLYQbU7GnqUxCjt+xh19lHvCDE4uioc5PlhqtTjAQmW5tSoSQz3pjZzoGKWWbILLB2fjhXt9Xyl2OagHpkwLpv3fQ2ZFTX1ie+ZOrmtph5RXWrgd0ypxFCwa6S+UgPOgJ5e6NUL5PrCdUAwjIq6gxkbWlEbPntDKErh4Zygk/U9pQa46uQq7OM3987lf7qOMvK6wY15KqPJIUBoAz3UAlwnvROpD7coLVQxGmWSsQVkH891l17eY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test the PSI current-value helper with explicit totals so the result does
not depend on the test system's memory pressure. Cover an unmeasured
consist goal, unmeasured temporal goals with zero and nonzero effective
quotas, and measured rounds for both tuners. Check last_psi_total after
each call.

With the old unmeasured-round behavior retained in the helper, the
temporal check with a nonzero effective quota fails.

Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 mm/damon/tests/core-kunit.h | 43 +++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 5ff0436c58441..a30040826874e 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -910,6 +910,48 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 			});
 }
 
+static void damos_test_set_psi_current_val(struct kunit *test)
+{
+	struct damos s = {
+		.quota.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+	};
+	struct damos_quota_goal goal = {
+		.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
+		.target_value = 100,
+		.last_psi_total = U64_MAX,
+	};
+
+	/* uninitialized last_psi_total keeps the consist tuner quota */
+	damos_set_psi_current_val(1000, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 100ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 1000ull);
+
+	/* initialized last_psi_total gives the delta */
+	damos_set_psi_current_val(1030, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 30ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 1030ull);
+
+	/* temporal tuner keeps a zero quota */
+	s.quota.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL;
+	s.quota.esz = 0;
+	goal.last_psi_total = U64_MAX;
+	damos_set_psi_current_val(2000, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 100ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 2000ull);
+
+	/* temporal tuner keeps a non-zero quota */
+	s.quota.esz = SZ_64K;
+	goal.last_psi_total = U64_MAX;
+	damos_set_psi_current_val(3000, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 0ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 3000ull);
+
+	/* temporal tuner uses the measured PSI delta */
+	damos_set_psi_current_val(3250, &goal, &s);
+	KUNIT_EXPECT_EQ(test, goal.current_value, 250ul);
+	KUNIT_EXPECT_EQ(test, goal.last_psi_total, 3250ull);
+}
+
 static void damos_test_commit_quota_goals_for(struct kunit *test,
 		struct damos_quota_goal *dst_goals, int nr_dst_goals,
 		struct damos_quota_goal *src_goals, int nr_src_goals)
@@ -1947,6 +1989,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_nr_accesses_mvsum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_commit_quota_goal),
+	KUNIT_CASE(damos_test_set_psi_current_val),
 	KUNIT_CASE(damos_test_commit_quota_goals),
 	KUNIT_CASE(damos_test_commit_quota),
 	KUNIT_CASE(damos_test_commit_dests),
-- 
2.53.0


