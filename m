Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFEDDC982D6
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 14:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229BA6B009E; Thu, 17 Sep 2026 10:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202926B009F; Thu, 17 Sep 2026 10:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13FD56B00A1; Thu, 17 Sep 2026 10:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCE3E6B009E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:22:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23C76140349
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:24 +0000 (UTC)
X-FDA: 85223469408.24.9DA7F3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 87833120009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:22:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ldfonNik;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789654942;
	b=he2QOTdJxGLMv1zfBHtr2X9wPjCZRhokomBRWCwr/mi0ewqTvGWiNhk2x+NpcHqtCujrFi
	WHBj3qUygcypYey7/ZU1PgpAsLOrUjeqOIGCEwWB709AgnB7qOB0/GXrnqXGinX46s5sIn
	ZEtu8eBArGuiOJl/9lfWdv35cFSXBPk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ldfonNik;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789654942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fE3VSG475bLo7Rafe0HxYfu5RyrdwRMonEKmjNKbeoE=;
	b=uroofCnm8jPLGKtQ5uveM7Wmty+XzQPhzKKeggEtmDhjMzPxH99Rgduog301bsahpJR5w+
	pH4kdBH4ekkjH+c7PG2mbLLaBnlucQVooMFLLMmfEvLOM1FgnbN7LXhpfcp9f+GFHvfl6D
	p8qlBwUdcjYsNfsejUPbYwzH5DQpJaY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8205E43C3D;
	Thu, 17 Sep 2026 14:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2040D1F00898;
	Thu, 17 Sep 2026 14:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789654941;
	bh=fE3VSG475bLo7Rafe0HxYfu5RyrdwRMonEKmjNKbeoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ldfonNikCJco+lq05YdWxGYXoi7MtGns/iW5fY3Tpy9ce2H2k551ftpQMsGuCANb3
	 Zr8ZOE8xM0sB4o9U1b+U0zBuRPVAnqdXz8vhyMUPoKJR02phbs7IWby77bhcjJHEQj
	 SAdtQyApnW3oBY75ZzFNExDRCiqCZ90ozvm/f1XdL25qEw9pBxRlnZfFnCIkS1mKNO
	 ++jqtlqfoapQbpnZUiUjk4BS8hzfy6eVDxYyiFH1KMC8P5JoENiN2UIxUgNUOcdaMu
	 xdKOLqEvVi3xAoToXKtC9CqGopxJZY+ipI+9qoyt5J7UdvlLvV1bQ68qLHhQhx8gsE
	 1hA1qIKgDeq8A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 08/10] mm/damon/tests/core-kunit: add probe_hits_wsum damos filter commit test
Date: Thu, 17 Sep 2026 07:22:06 -0700
Message-ID: <20260917142210.90829-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917142210.90829-1-sj@kernel.org>
References: <20260917142210.90829-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 87833120009
X-Stat-Signature: j4u6udao9ido5jrspzsdmbqoqtym7i3j
X-HE-Tag: 1789654942-54911
X-HE-Meta: U2FsdGVkX19eChJZC5vLPycQJKfgk/BqnrXhH3rNIREH5O20PDNgzVDf2OwTkmfloX27g1Bf63YktYTso1fQnjEOTYFRovpL0ix8eCK447v0A5MMyIwpC31x7GkY9DtVhL3PsjxqhaU1b+o/NWtwX46S9dMVyq9/evdj4n6WCAWG7BpOi+y0OdGUC02yfTddwzE/vJL9SKrqRcu7q0kQ2195OnvLZnB0fTtzlXpWYoQcVt6D9fCTlcRLnXzOe7G+Ta4UJVfBRhdYUEpxdkjCSusFjvHyiz9qMcGhrq9pjE7wU9iQP8IZUHQXeMkqH6qvZVdWNDYaPjTB1TwhMHMEuGWB92aB5i5mVoCcSU6wFO8C+DMBoqRfd0PL7jhlB9ZtuTMOAkZSf3PtJYUq0pSlK23IwcotYaVcm3pxZPU10pXdb7dAQL5KB6odtfo0Sgfr0b6h0gRhTwmzCVuCDJ+i8dT/a72RiRp/n8kvfTOvZLpxMaR1Ev0vIuXLrCjtUrIGEESsfDJ0eUgXii66ojz6cBfuN9DfYmq5IYo1fC3pWrzXwbvlpSta6/mrVVScxOKSN1UC5pTegyuHJZkp+Sj3XzmMYJx6pS+WXO7NEvf09qC6hzZHgRTWcyFfrkUvRhkhdzTGsC5VteoPDi6k6fXFcMtIIVB16uHprynhSUSW8zLNYQWLALedfV4IbIKTQbTXhlvpbQPJvITYEtBGymSx99/5gNXpKLNpUkVOKRjgGUCj2Yu1XbtoXqux+0q6M01S0hcs39E64g2o0b+kCBR+uE9aDUowSWbHNoyXygZnFSElcA2XQamZUxizZSp/j878pmcT5V5/iuEiR7yhDSeJUYPNMj3sv1a70I98WUISEUzbnr+93KcXUqmssngZiSkkauDwAzro2QIlKp9uvkD8tDIH5RMgL0jcW9BXWD7CloTgKAhORwHEU6aYBjPd9OQssiztXHjwW7yBZR0bfFC
 XtXFec9p
 B0MrIuOghrxYjJIVVzeI8DTEIf0Yaeq0SH2v27eH/d19+697I+fHK7zG7KriWe3COZyXWuQzgttHARXWt1D95uxz2XqqpGTRLHfvMaC6DDZCwIqeL+8TQoRFeNHK6GBqi4M3G+08yp0jxy99LlYGbqfBry76zwHmYcoptC5Ky9jSAzCzRsWb9w15zuhYuqJKmngKElfph575FBapKmFM+5LIY9HAnnGZKldEUfWPuA0/Wv+X++idjKfUSIrHUffILvRwg80U+osWShAOFPEY//fElYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS filter commit kunit test lacks test cases for probe_hits_wsum
filter type.  Add test cases for probe_hits_wsum type DAMOS filter
commit.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 1f19fefdd98c3..5ff0436c58441 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1166,6 +1166,10 @@ static void damos_test_commit_filter_for(struct kunit *test,
 		KUNIT_EXPECT_EQ(test, dst->sz_range.min, src->sz_range.min);
 		KUNIT_EXPECT_EQ(test, dst->sz_range.max, src->sz_range.max);
 		break;
+	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		KUNIT_EXPECT_EQ(test, dst->range_min, src->range_min);
+		KUNIT_EXPECT_EQ(test, dst->range_max, src->range_max);
+		break;
 	default:
 		break;
 	}
@@ -1239,6 +1243,22 @@ static void damos_test_commit_filter(struct kunit *test)
 			.allow = true,
 			.target_idx = 6,
 			}, false);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
+			.matching = false,
+			.allow = true,
+			.range_min = 12,
+			.range_max = 34,
+			}, false);
+	damos_test_commit_filter_for(test, &dst,
+			&(struct damos_filter){
+			.type = DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
+			.matching = false,
+			.allow = true,
+			.range_min = 34,
+			.range_max = 12,
+			}, true);
 }
 
 static void damos_test_help_initailize_scheme(struct damos *scheme)
-- 
2.47.3

