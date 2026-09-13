Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F6A4C88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 152776B00AB; Sun, 13 Sep 2026 13:17:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103E16B00AC; Sun, 13 Sep 2026 13:17:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 019186B00AD; Sun, 13 Sep 2026 13:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC29E6B00AB
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:17:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 60FE31C2D76
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:19 +0000 (UTC)
X-FDA: 85209394998.23.D46C9F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D41F5100003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H4W7py6a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqfaQq4DYDAwDcS6eX/vnZ8ZZiveWwkFxlbgk1mGGIc=;
	b=QnlIkWD2g6wBGyZ4v23a2h2rE9MShhexFoPPJcDv/J9dw0OpGG/rTpFbwgAn+ZeFHJyOeI
	5WxZRUt/5Q+ZC2Y5Dpqjju+eKmp3g59SJRE92ZNKOqgnOv+Pbwi+RzFnbzGCeM4IUytAra
	2+WRItwMP4XhIn4C44nd3PcB1wDRcHE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319837;
	b=wjsN14ONbjEOjSsZ3DtoYrxTMYhE1ToKDwFA9cVZF4cwoxhtbk0rImYOeikwSdNnAqR+/8
	lOjqCPlRSipm9wKRvXFlp37gQ3W3OfjlSbbgBzquhdRqKgjTYD/UDxmbmMVSLI5jmmhnwQ
	bmh+2yCltkByevblAiEkkRwVO1WG4QQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H4W7py6a;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7990760E9E;
	Sun, 13 Sep 2026 17:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98D71F00899;
	Sun, 13 Sep 2026 17:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319837;
	bh=nqfaQq4DYDAwDcS6eX/vnZ8ZZiveWwkFxlbgk1mGGIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H4W7py6aOI53Y/ZvNSunZRHFe0l0i6pGkVwow4aMEflbBTjd5mP73d/jl4iuSE70w
	 /wMFvEg+0UIYFIoEVo3WqwWNj/gFLtEaiCpbb3iCkP144bNl+M74+2wCvC01cCK+hV
	 8fnB74LyzDzBwjdXY70NVF2vwiQZy0ru2VnbjyQIKq+y3tDkBc2HertUhRQBF7vz5a
	 juJklc1eGsYaq31xW8meHEK1YRl0Wo9eUadCuSSylpj3dz6eZAlIsCF90TCJ1sUAUd
	 Z6w/90du8neSMJ4i5vBWBP1W0V6eZrUZdmcDO+dDrf2GqhFrQTWKwuol3yI8zdQIcL
	 3rM52daiIfvxA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 7/8] mm/damon/core-kunit: extend damos_commit_filter_for() for wrong input
Date: Sun, 13 Sep 2026 10:17:04 -0700
Message-ID: <20260913171706.103052-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913171706.103052-1-sj@kernel.org>
References: <20260913171706.103052-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D41F5100003
X-Stat-Signature: m3if6i3ow7jkcgeqr61qjxot5daf17c4
X-HE-Tag: 1789319837-92931
X-HE-Meta: U2FsdGVkX180AYk1pkSY98OYgoNacBUuME2qRqjuf7CmyKr+Oxm/pUZKsNsBkH8/L2bznkwp6I6coUzWPot1W3UYCEQIDgZls3+4a92GunXnCJ8B9zpCTmAUYW+1sTft5Stmzqql0tULDXS2hhToxbkBiVlmUnN390oHtkq9XbLJtTyxFj+GNbRDOK9We+zhFsJnVfJPyzdtDANAEn/J4h1qWs+UVWOyEB6mOPT+mHgO9Dgr4Rlyj9KcWWgvq+teeJ2b//S1aPU1U8qZdwCQt6rgPand0Hh1ylS+/4dCrePOXWECdWLp8CZqyNayknwO5xZskfDfis4//fAKLnPOgiCfaeXFPhVNUprBmWOM1jq6u1gEkjT4DLMIEwJ8vDEqtd333aCS193CxMc4kKkW3nsvDqzsqotoYwvo8wX3xRHsAdCB6qYb9IyiaFjewgKx8F2JPudWMEv5s/Kjh0NCAeRTOico29ugep8bHj0BTc58DkGnaoZU4A/Qx5XnzcHPW9yyaH8S3SvQ+isCnMKoMR3qLoWjsOL4eJX5qRdHOdKm7WZ0Y7XNSwAlJBRegNS3oDaIZFYv3D4AgtlOJ0BxnxFD1JYDW4KWAAxzKpYZLSstxifiz//doqH7VYUUzeiOtPs4j5DRkkcOamS6hj/MZ2uPGxiFAI8+xTonbHXHU4BVfr/vdwuqEt2WKQiO+OBt/A3Myegk0TdKX6kP5vGHcVe3pnyCCQ4uh2MmJSjAh1djyii1SokCC9Bcm/Jj+paeIyHOaiyerxgPhSgzuuiRDw3dFBvdg9Tb/Qj21gwfMgiZfouvg+eo2clerRBIAhhNNxy+29hJwKDQuhLpwaKsPGMisPhHe2mOxIwOlTl85hDlHtGJ6pV1/gK+rO6MuleF5k7dsVY5d0ktEAvC7equ2qYUvAaXc6iJuxylrHNr2AmZVakKa0/4nUCmUB0GsL4dKprvsvaZvo9nO41SE4s
 eJkN33u7
 yvHaKG9ZCaY9fUJJ+zXS5afmqnh+sU2WGOtKo7tLteHlFBx5kNmn8f1HBVh1a46qYw97oJA0JZURSFDriW209OJwnJx5hnGCGRhW+VLgC1apVhgQZNOnprJdV1sg8tMWB2jRPOsvWwV5wLyyqb2K4Lv2kTLz+mABmzXD730TxC8IqRwnw5K7/JoKPSXh8v/AKMOzBYtARWp/7ljLARYIgQ9V/jq6VW4hmorvJZnpmEeE0onyxAJMXkUDAI/lqat5DOwBZJ/yboI+kW+d2b/B9AZoSJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_filter_for() supposes damos_commit_filter() to always
succeed with given inputs.  damos_commit_filter() could return an error
for invalid inputs.  Existing callers always pass only valid inputs, but
they may pass invalid inputs in future, for test purposes.  Extend the
function to be able to be used for wrong inputs-caused error testing.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index a47a5cdf285c8..c9941f3bfb42b 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1127,9 +1127,15 @@ static void damos_test_commit_dests(struct kunit *test)
 }
 
 static void damos_test_commit_filter_for(struct kunit *test,
-		struct damos_filter *dst, struct damos_filter *src)
+		struct damos_filter *dst, struct damos_filter *src,
+		bool expect_fail)
 {
-	damos_commit_filter(dst, src);
+	int err;
+
+	err = damos_commit_filter(dst, src);
+	KUNIT_EXPECT_EQ(test, err != 0, expect_fail);
+	if (expect_fail)
+		return;
 	KUNIT_EXPECT_EQ(test, dst->type, src->type);
 	KUNIT_EXPECT_EQ(test, dst->matching, src->matching);
 	KUNIT_EXPECT_EQ(test, dst->allow, src->allow);
@@ -1168,47 +1174,47 @@ static void damos_test_commit_filter(struct kunit *test)
 			.type = DAMOS_FILTER_TYPE_ANON,
 			.matching = true,
 			.allow = true,
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_MEMCG,
 			.matching = false,
 			.allow = false,
 			.memcg_id = 123,
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_YOUNG,
 			.matching = true,
 			.allow = true,
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
 			.matching = false,
 			.allow = false,
 			.sz_range = {.min = 234, .max = 345},
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_UNMAPPED,
 			.matching = true,
 			.allow = true,
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_ADDR,
 			.matching = false,
 			.allow = false,
 			.addr_range = {.start = 456, .end = 567},
-			});
+			}, false);
 	damos_test_commit_filter_for(test, &dst,
 			&(struct damos_filter){
 			.type = DAMOS_FILTER_TYPE_TARGET,
 			.matching = true,
 			.allow = true,
 			.target_idx = 6,
-			});
+			}, false);
 }
 
 static void damos_test_help_initailize_scheme(struct damos *scheme)
-- 
2.47.3

