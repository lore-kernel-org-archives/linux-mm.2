Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88E4DF31E26
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58106B0096; Thu,  9 Apr 2026 10:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BA156B0099; Thu,  9 Apr 2026 10:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880C56B009D; Thu,  9 Apr 2026 10:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B00E6B0099
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:22:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 086B71B8A1E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:03 +0000 (UTC)
X-FDA: 84639231768.19.0164936
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 42BBC180003
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mG0EerkI;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775744522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4rdaam9BwVxK+HQPMM/xSyzd71ZxUQuLXDJfRzSuG9c=;
	b=ld2ECoyz4/dG9hwpTrLD3UKvdQQQwq3d9f+I+TMgakm08IzrFcROXCPojqZ/2yAv47wcyH
	NZtzUaEJPiJlTo2WZTQbK2czNgM08sqN79vgKDs3ovxIRK4LT4nt6XGYtFbmkFEVvtDx35
	dEluDmLgnAcxU2a6LjVLJuw1dflHfgE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775744522; a=rsa-sha256;
	cv=none;
	b=czCmyMv3sWj7Lt26C6l3dJ9avH5xQh1APQ4OXifE4e60baEAdpavBn/WXAmxmBWtfPXjhH
	AGVV2EqidOYao31vjdm7XSEG0pkmJk1TWWiHu/20E5gUETSvYGanf4e2UIL0N3WcVqbAN8
	u06rsrrqhUhbB/cwiZ5J+9Rb4I7G5yI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mG0EerkI;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B444360125;
	Thu,  9 Apr 2026 14:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C89C19424;
	Thu,  9 Apr 2026 14:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775744521;
	bh=oBXW5uIN8lzshHczxlHFHeX8VLmiX/5T2Hz8N+WZ/sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mG0EerkIiWXO/JhNf6dSmW4UlSyrnzmIhzLE/KjFgogaQCYgaejI1UOz9d3lXPg9z
	 tPmdXPVkcI9YxidqvcLpYDgqXOWnVQWRw6GxCK0srLLKQgJU0hp8DB43Oydn9WaJrx
	 jlNGLVY90llnVQ/aJBDspIqKBYx85OJVjzlVwq/3EEhjAdu2eECuo04ClE1+SPmhSK
	 lKncYJGBbgg9UWHoJMPLurMfgKO/JeYKj+bthU+vvB9Un5b3dxZgOaATP0i3/NLsLQ
	 cM2B1JSpn3xlS7YjBdcwf0gVS8psuTBCC42Igh6wveEXEIlI6g/JP1/Kv86+ySHafv
	 wOlWQxvl7pqvA==
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
Subject: [RFC PATCH v4 08/11] mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing
Date: Thu,  9 Apr 2026 07:21:43 -0700
Message-ID: <20260409142148.60652-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409142148.60652-1-sj@kernel.org>
References: <20260409142148.60652-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 42BBC180003
X-Stat-Signature: h53f83yi7f9icmuc3zyc3suzm4xconwu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775744522-522588
X-HE-Meta: U2FsdGVkX18GO102XLU0vsadHeZbzUIVsEGfsuRsVZLDZYQ2OvW0e+BWbHwHdQhEm/lGeuOfzhHB1j/xOoqLn0/6TtUA4oUEoWND7UCL1LfW/rXwqH+D4T/S7z0NBgAgLc71zWwvzI7fHXjmym3XYo5I7AELggkegttLvf26NLD4J0eVwQ/EwF0WmBgly7GA9l7ZrY/6Q3J9U+yW95z1HqiZ6Ngs3ccTH9mo0H7SsHkOyhecKIcH0V87ighT+KUSYSoB/RMqfeSSR2nlAe/mqm+5AufUCTVJjInC178IhkrPDUkr4gD+Q/FsgKJOrVLgrh18vI+iHUS8cbU1jHRDUZzbiMov5Rl9SE/KkR3s1FdVJ+hN6Qn117ZVXPEJslnXu5Wav2cXdWdaf7P9TgEE/X/AksHo6WVi0j4GZAxKJhX5RIl++5rGfYnFM8iHccDo9PEt3iXge4i44VFD3Q38yS+4FuyBPVH3U+ydQn2QSd52WgDR1baAR8wIQaTjVEv60QoF3lmR27e5COJ8xYE2hdmmwmLekqximIKVzwk1IIKZ68MMHjvfuF6bDqC/b7xU/1ur3hmKn/kAxOMwPFGdDpa883QW99fNHBmDzSa+M6UMsUPvSkyBGQW7i8iQ8MRu+JsnByzeo1a975hd4nF8Oy4cgjTJdbk35F7P0JwBu6ka9Yf6vpfIITruzj9Q+/YN9pwbHtGyX1cPR4Xg8zwey7RBgbGYvyEJkmgQ7mEtMwS+C2wgaASpYYDs9skB/J19LgoXOr7VDEx4AaCcL6gAVnj96+lpdAy7psTnmSK7aEIYBGsnZ9ElfukquqfGcDnMxVFOZKtK51f6hkD5eqhG0U8/Np2Qc4mDw4uhRhv0sXq7rbqXjHM9ZCymXBabt8Gi9eKrHJ8OgKoSe8gltxcoJLjk9V7IScGvsAHjT7TPZS6fI0VMMM0IZPbFG97AouyhH6a9ZFdlhb08Ezogh4i
 V+cHkb8a
 bNSWtlZ4QY/pxEYBI07ryCwxSoHwEioGnkZg6D1/COvjf9gDEKOZpXu+IvfloqsRGy4ilHzyLUUetCO9Y9r7ieKDU5ExtW/9GZ9BeW8+VdxeuDHj3lvcTp6CRfiZcqS5j9m71a9dWrDMu0TV96S6BoLd/+oXF/x4v8xI/jp9jpB3jls4tmrq6oF5bJpo5911+7v0rS0WQXWj/+ZD2KFIHoa7V2DiOAxIGTm8uXoAbOr3A7q3hEf0IW9IQhNZGoT7glCE9SQf4PcZpEfs/qATruH/TkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damos_test_commit_quotas() kunit test to ensure
damos_commit_quota() handles fail_charge_{num,denom} parameters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0030f682b23b7..1b23a22ac04c4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -694,6 +694,8 @@ static void damos_test_commit_quota(struct kunit *test)
 		.ms = 2,
 		.sz = 3,
 		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+		.fail_charge_num = 2,
+		.fail_charge_denom = 3,
 		.weight_sz = 4,
 		.weight_nr_accesses = 5,
 		.weight_age = 6,
@@ -703,6 +705,8 @@ static void damos_test_commit_quota(struct kunit *test)
 		.ms = 8,
 		.sz = 9,
 		.goal_tuner = DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
+		.fail_charge_num = 1,
+		.fail_charge_denom = 1024,
 		.weight_sz = 10,
 		.weight_nr_accesses = 11,
 		.weight_age = 12,
@@ -717,6 +721,8 @@ static void damos_test_commit_quota(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, dst.ms, src.ms);
 	KUNIT_EXPECT_EQ(test, dst.sz, src.sz);
 	KUNIT_EXPECT_EQ(test, dst.goal_tuner, src.goal_tuner);
+	KUNIT_EXPECT_EQ(test, dst.fail_charge_num, src.fail_charge_num);
+	KUNIT_EXPECT_EQ(test, dst.fail_charge_denom, src.fail_charge_denom);
 	KUNIT_EXPECT_EQ(test, dst.weight_sz, src.weight_sz);
 	KUNIT_EXPECT_EQ(test, dst.weight_nr_accesses, src.weight_nr_accesses);
 	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
-- 
2.47.3

