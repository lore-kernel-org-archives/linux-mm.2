Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2976FC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:00:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70ECD6B00CB; Sun, 20 Sep 2026 22:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E62E6B00DB; Sun, 20 Sep 2026 22:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D21B6B00CB; Sun, 20 Sep 2026 22:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34F516B00CB
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:00:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8ABCA6190
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:00:24 +0000 (UTC)
X-FDA: 85236114768.03.B0A2A7C
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf18.hostedemail.com (Postfix) with ESMTP id D9F111C0004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:00:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Har7SyDu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Har7SyDu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789956022;
	b=hjLW+vUqi1zIBo89t6kIlh3D6Z/bbODRHBjuXzCXbCuok/m5iFkaKknEfJRZOVJyYyJ667
	XNkaoP+vJRaICE71/hvqHR+cGAmMxPQ1v4MgmL7UNpsEz6NQwmh0kfmZIeht8HnQkRxLsX
	8wFU67NiDoAvhrLHdRfV0SnzHKl0O9U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789956022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7TZP8BNLRLnhNjBcWJuFbaWGwNCp5mqjDlxAcW8kmE=;
	b=SerMSvy4UdKTaJ7BFwTwHAGiC3rhswF+AMoQLMetAdiXlUd/gGZ8Sj2YlMRcCineFaKCIy
	ejirJ/ElF6Ss7YxwMWAT9WrTt4LJUR/AakJfz6C/3/fGUcMfPhjDK2OvULGJRXXzTD+sUI
	OWifpRpeAow1txATupaxjvXuFYl1oYY=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e71cdb22bso17689445e9.2
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789956021; x=1790560821; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r7TZP8BNLRLnhNjBcWJuFbaWGwNCp5mqjDlxAcW8kmE=;
        b=Har7SyDuC45GLSwsn33+FxqsPkWSYvx5J7kVVkEfFIf0iXMXoxpqSYDKzAYOnkbUr2
         EQ6kQUmxIhc+3ZQL6qh9uJXIBPXiPoPgHdt5VCFdfUyjezgxlp4FrJ7nWckSAyFxowep
         K6UFE7tbQyXZBVWV2stsTGbSP4lez/wRUYD8fk+OuOjg9bfTm4bvp1g0k0LAq7BLodQj
         XunFodszYYGyf607mehGFCVph2IQWeI6gvDx8bQ2YDSnPb/5JwnRHvFvMYPYsoyxhIUu
         5U2MzWPNwGxuVv/5gThA3Gdy3l/1ukTDb1vmL9IypZvvfzETWLokxYZyC0omWti0ovJx
         B9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789956021; x=1790560821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r7TZP8BNLRLnhNjBcWJuFbaWGwNCp5mqjDlxAcW8kmE=;
        b=CNmIKlsTxFNaGxPNC5EmYDKD9ndixuHzZ8AHhZxs5F+Fjo77C9IdSITvd+lwILrfUs
         TJk0XbTOk4PMkmmy+lSX2EO2ElEKe0lQLGiH+dm9UoOfHWMBmnLJJNfWv4bMYC+rBK9m
         0mqR6mYf1YrIEz2gQHOw+oakUQNVPKD/t+ZUQnbNBQgUWYiQeuZWNNzFFZPlDEWwgTRa
         4z4c07WHs0ex89cNFJVKdu0DZQLPQWPSSsHp6mY7dkSk5D8NSTDvb9yLn+icc29SZ9qx
         7H8/PyrITi4I/n8OELX2R5ATQJCZXyhiO7ByscABuSROAuwkAjenwPp9Bz0F7kcesuF9
         Huwg==
X-Forwarded-Encrypted: i=1; AKwUvByB06nmWUdVBpZlXf69BboZz4k0z0nFIVFlREaUtSi8/6hZMVV5ZdYRmgMlhYlOpHCgzd3wq/eQVA==@kvack.org
X-Gm-Message-State: AFuF++mwefnbdik7QDzkKNIbr10uOZ8ffz9GgqHxaeM1HP+OOBhVV1aD
	T4ngosr6cl4Qjhc6ClSbPSO5jkgopp6Cb4Lqur+gQYYiLmj/puTIVKAD
X-Gm-Gg: AYBFou3hCjVwVEhNkUpkMJS7EN1NHDFV0dZoxFFS5MwttTYNML+q0whpOxpdz8E0rrh
	ETzYyCQsAagRBbDaoZHT0l8AfcQ3BUiDaYZWvWP4DTcyIeVoH+qzfq4ok3gaZQJ7rBX4TKc5V9W
	YY5KWbeNXOWGZMpitffgzAp31cqpsnsEWXf3ztEHjGbURUR498o3zM+l/cCWbehIaMj1VaiUYCf
	8GQLM3iYaHLyC4Bneuy6OZTjWetQkMTBnolLKv9nwds2jHyHImYyASBfXI5uJwCU8Zrbw9msWGF
	NRb0pIJJPxbMbChVVtKpcynjCVz5KBW+Wal6hL6QnOtr5npz+j2pM3PR/bKg2Ao0yfPuh33bYTu
	uROYw/7N4xzfL85JkF8+QelUdpZhchLvNrLDGTY/xest6n1qnooN11m9BuKRXO21t82LW8GPmVL
	ZR5Rlrn6FYiu4u69+zaezwi3+R5iFeMoH/ZC/obVsp1BZTk9uzGJLu2BDEPrg48k8vpf/HTXbRh
	J8qL8Wbo4Pwwmr+nlqU/ChI4HU6J/q9N16sjL1edBuOYUSZiM43UqOIdAQbRdLRqbeG2A0MlJN+
	KFXK/xynMw0459nidQH+ZGNQRka3QZdIVE7ULwH720Qi/QUzdfxocqzPQPXMjPEUAZu58hIYF2s
	42pZfJqoHguW9
X-Received: by 2002:a05:600c:358a:b0:49c:fa20:cc08 with SMTP id 5b1f17b1804b1-49fc5741844mr142422905e9.31.1789956021522;
        Sun, 20 Sep 2026 19:00:21 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a8e9-c501-2c36-515f-49b6-c492.310.pool.telefonica.de. [2a02:3100:a8e9:c501:2c36:515f:49b6:c492])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fcd10273fsm193284995e9.7.2026.09.20.19.00.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Sep 2026 19:00:21 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm/damon/core: keep the temporal tuner quota over an unmeasured PSI round
Date: Mon, 21 Sep 2026 04:00:12 +0200
Message-Id: <20260921020013.33105-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260921020013.33105-1-kmehltretter@gmail.com>
References: <20260921020013.33105-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D9F111C0004
X-Stat-Signature: b4qduraqwhxctboz9hgese5wks34hita
X-Rspamd-Server: rspam01
X-HE-Tag: 1789956022-19346
X-HE-Meta: U2FsdGVkX1+bMOOBZmDIaCY36qYmfQKWseadxswV69LQbxw7ihiMPVJDWJcEkXZnhCgnJo1qrGRZ3C+3+Nm8tXGykO5pjPjehas6Clr64UbqcXM/xMw3EAZ6d9CW0Xz8NXIgG7cJiPjjq8KC2iI/pIBUjQ4C4+r0laIO1Lb7cER0SgCEA/hXvFxi7CuZDIf4h0nxS2A166IAfwgLuPqntmGD4qBFYPPapsd2HJDQi4BIqrDtjsqs+9C3m2Nj4WcO79+4pw/ITmELqWiGmQPWIgiPkPgB3vlgVJ3vCWjH46AyrHfPX/3bZBjlc9fOznZVWkr8dyQ8PqJ93EKtc7JOVh5nznB8BXkem5Jy0ts4ZOZLK61Mvsi9I+PTJhpCBGF3lmhXSsJxjzMIq+Z+Tn99G1fbv7dvtfPtxtk75/SwcHsNBrV1pIILSezjHcGdNdIZtdbkuyynmrgKb0UTcGfDh65PF3YOVCCGf8kpexL8xBVpFjnMPA+oxu5y0VPaj7haRHlV3EsWgbDk8iK40XHVsl5+cRR8gRRrYVM8IvFpM/boMmQyUsSBG3zSexj4cpRg2YFgzk98cCn1SsfI8XPUZsBr3aiHX8lvhU+DfPpUnwqeHqSVL6YPAkfuYD5p8e2Sd68iFbVpZXh/c3N73B69+p+6fbibwniywibJt5UuYEHKqOLBSJ6Hbw2ZlEne68e5Iy0/b0CEdDaC4wL2DvYwkvB9eNH883ifgsrUhzZQVRSIWex300lxNM3PYXhlBkK+/jB6FFOoM91Y/4nOOpvI/IkJSEz28nARfzi0bcERkEID4q3izi+zTD5vtqtEdQhSH7nF+OVEcFZHfpShE8pzo6Q74+ehnVYcCEK4kOmnFeoDaZxZD7vXLQRPFZWu9PsNZBv4ktAKCGuLXz4c0DEyTH7P7UTLV2f8uZMnsgOKLxtxX2McRbAFafKurXM2WNq24fharh0Wji6HKwjpLk7
 cW1mInYD
 xZ+IZ+96GoAcSL5UmgPfpvOLKRjMP0ZrK7vScRalKViisKQJTLhJ5MSW1DW5qrY3l+SNEeBkLwPZtJ6dgxAXP5uPBgWP9QnP36Iadl8osb6ilrRkctKxzgF052FTkhf2keReflsVwAmcaz0G7+d2ljGMNxrNhGZn/pbhMX9GqxX1WoMTxcrX3jnV41H27glyLTEWjdeVbQhsFTFvqf2ShT1szP88EdobCTgeX9Es64d8BLq184kSHktl5IJn36AygJsUoYkR/foi99FEiMjtHh60+TKraDSWM/CtcA6kfIiS2Oz5jRJ7NHYW8pX9Xk2wIfFvyAqW0kX1aW5lm1ujC99ELbvP0xGS8wDo5gwtuTBGrd/dYQVT3rn7KIge9mNTAN4oWI0VtmvKB49VWmr8ywzz0dE65qrcXOo+Wzw8UW1b1+uapEl78pwMuvv5zoQDkcuRRTdA0RaOT0hcl2GJZaXuSlsSfsXfZICd3KogyrVpmZZT5uDYy5hNrwxDaP8loTSHUDrK4NDEc2/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit b73198a47ffe ("mm/damon/core: handle uninitialized
damos_quota_goal->last_psi_total") scores a PSI quota goal without a
previous sample as achieved. This leaves the consist tuner's input
unchanged, but the temporal tuner sets its quota to zero for an achieved
goal. A running scheme with a nonzero temporal quota therefore loses a
charge window after a quota-goal commit.

Use the effective quota to preserve the temporal tuner's previous
goal-achievement state during an unmeasured round, as SJ suggested [1].
Score the goal as achieved when the effective quota is zero and as not
achieved otherwise. A new scheme's initially zero quota stays zero, and
the consist tuner's behavior is unchanged.

Move the PSI current-value calculation and last_psi_total update into a
helper that takes the current PSI total. This lets a unit test cover the
unmeasured and measured rounds without depending on system memory
pressure.

Fixes: b73198a47ffe ("mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total")
Cc: <stable@vger.kernel.org> # 7.1.x
Suggested-by: SJ Park <sj@kernel.org>
Link: https://lore.kernel.org/damon/20260916001311.101024-1-sj@kernel.org/ [1]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
The commit being fixed is still in mm-unstable, so its hash may change.

 mm/damon/core.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2258b72da7a78..add1b7afb957a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2955,6 +2955,28 @@ static inline u64 damos_get_some_mem_psi_total(void)
 
 #endif	/* CONFIG_PSI */
 
+static void damos_set_psi_current_val(u64 now_psi_total,
+		struct damos_quota_goal *goal, struct damos *s)
+{
+	u64 last_psi_total = goal->last_psi_total;
+
+	goal->last_psi_total = now_psi_total;
+	if (last_psi_total != U64_MAX) {
+		goal->current_value = now_psi_total - last_psi_total;
+		return;
+	}
+	/* uninitialized last_psi_total; make no effect this round */
+	if (s->quota.goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST) {
+		goal->current_value = goal->target_value;
+		return;
+	}
+	/* let temporal tuner show the same achievement as in the last round */
+	if (!s->quota.esz)
+		goal->current_value = goal->target_value;
+	else
+		goal->current_value = 0;
+}
+
 #ifdef CONFIG_NUMA
 static bool invalid_mem_node(int nid)
 {
@@ -3207,13 +3229,7 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 		break;
 	case DAMOS_QUOTA_SOME_MEM_PSI_US:
 		now_psi_total = damos_get_some_mem_psi_total();
-		/* uninitialized last_psi_total; make no effect this round */
-		if (goal->last_psi_total == U64_MAX)
-			goal->current_value = goal->target_value;
-		else
-			goal->current_value = now_psi_total -
-				goal->last_psi_total;
-		goal->last_psi_total = now_psi_total;
+		damos_set_psi_current_val(now_psi_total, goal, s);
 		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
 	case DAMOS_QUOTA_NODE_MEM_FREE_BP:
-- 
2.53.0


