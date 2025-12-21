Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF3F5E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 13:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A846B008A; Sun, 21 Dec 2025 08:02:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321D36B008C; Sun, 21 Dec 2025 08:02:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24B116B0092; Sun, 21 Dec 2025 08:02:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 124DA6B008A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 08:02:50 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AFE44160881
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 13:02:49 +0000 (UTC)
X-FDA: 84243492858.26.D3D20A1
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id E9332120019
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 13:02:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aHa4B2ZF;
	spf=pass (imf29.hostedemail.com: domain of shu17az@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=shu17az@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766322168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cSY7XOe/WRXINmaJjE9x1cwiIij569xd98uTVI5aS6I=;
	b=lFO2xz7kQMmXW4oOHfVxIn2lx9T8BkolgG7a4IG0Fado5QvilYaNaidBqhAEBsJZdG/muD
	9T7cw7oqk8zDhuWnE3NAe0F5KypxVKqNk1wQfppI3qNt0aZ5WoWuknOOmOlIqX5Qx8WKw3
	l6snN0duS6fIi4uYKvmoydkw2BK5gSU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aHa4B2ZF;
	spf=pass (imf29.hostedemail.com: domain of shu17az@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=shu17az@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766322168; a=rsa-sha256;
	cv=none;
	b=q+VjxgDYQcmwlqP+vdZWxKTWcEPyDqq+murj0IMIvhvv8myCpPKtbu//Y5nFSY+DpO+lOf
	MzG49EjdudP/3fjssn8X98pV1Yt3M88XMMnA6sLSkLlIeK2t1fs/C0xwQ4hbqGB2iiUGQw
	LkqC/bdR2V6G4ntqAvl+OP2pHDZuJSs=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-bf1b402fa3cso3294061a12.3
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 05:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766322167; x=1766926967; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cSY7XOe/WRXINmaJjE9x1cwiIij569xd98uTVI5aS6I=;
        b=aHa4B2ZFrC2rbi9Mha5ajkz5Adx7osJnfa1SHWbwnS9KSzYsNXfwQ9z9PrKTiPEmds
         gQIYLEanJ7pLXWnF+4EuNlInf8cNl1KAB0zUY2LQfFfhF0HUZjDE4C5i2OOdIuFZbKma
         n8AU/cwa2yy292+hJrHywxMj5IYE50c3mTw1nmQu7DTKNAIE1fNDtUg8gJBzs3jsLj41
         1JHXf41h+SNkEUEwo4HdzapucqDiMwNv5xu92jnmADqRFUclsqbkbV8mB4s3NpQYp4KB
         ycldXC/2EnfJGbTw1LlHEqM2E+MAwN0yreJKSoRNI+ZYymIsACEdCye2iICkmAlIEv3g
         TQYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766322167; x=1766926967;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cSY7XOe/WRXINmaJjE9x1cwiIij569xd98uTVI5aS6I=;
        b=vyopEorYmx9oyEJwYyDs7sVv9wtbFKresc+HNihAa2Oh7ROzQOKe2wab84rpng8GZ2
         x3C28yEMW3KwDfZBq/qqxWdR/vQCXWNnkbizAAyxbUBsn0jumHCY4/WGupAOMnUkijKl
         Y4sgfh2KzT7mzexR6HxtE8sh5nMGvJxXt/6fG7WSupWEOZTFLyHLPfLqOtiWjeXTgUOU
         26K0hDKGU/dZ4lHyv/5ubVO4tjt3NTMEQJRQjkDa7640i7qrnk2zYmTC2llG1S/zYPwE
         wy2zPyuiCU0xsXFEIMkwP/A1HlivIhJdjci+AtcHhcBUHP48h6dsbCf6TcaJvf9dBfkC
         rv/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWHtLL6Ag6j0/2fBv7K1Wt3/dkCr90jrZPeCqDL8sG4ZfFY2XdjmupSy6IO6rBMAVaGjNjn7L/PMg==@kvack.org
X-Gm-Message-State: AOJu0YzpA0B86wUU69+9jwLZmBkGZdsawD6IDTnLHtL2R3CsihNPo594
	WQMLpm2Riiszt3j8LKeov5KSXkNkwsc6U/z2JvHoZxX6DRuQusDN4VUB
X-Gm-Gg: AY/fxX7nDlY7rACA+WBDVXyoJSW4xZGKTeFgzXnoJzBEf/mSCCFAt/O2IkVQDHVFUZL
	ayAeIdqgz9uTezzTP94cHq7NdeOqyMDL9nQtNRz57pWEelfBU68z872Iy8ObHAHrJWX1FcSMyI8
	HUUveJBNewxRfT3HGzkl8tA7qoHDC7IKN7hHaZXLUmofMnySzrrc3exdxGWu3fnRfNrxz5EbRrk
	T7bwAcUTlm3bQS6/hpvQsgVxDalroW5dXW6ig6XXaYyuc24Ry8g6JSEYMEVkDuLFzMLkGzwdTKF
	KFBbmTysj0sxJYlHLx1vaaYbuw0aTVTF4Pe268H3ibwPJhI7KQ8O9iaJ6TBfrnhwx8TnjsgT2Dj
	v8Ve0vt29Bl11QO0UGFgGSvFRrDDmstbUNc0+KBs1z2JdTcHCaDDIVLA38yBOY0ecJoQ6+3ygVr
	X6
X-Google-Smtp-Source: AGHT+IE0pzTSaBZW0PqBo1nLMFou749uCZH2R8Sj1acU7EbMWf8ZDkTgJYeOyEMZv1HM4VBoxc7dMg==
X-Received: by 2002:a05:7022:2093:b0:119:e56c:18ae with SMTP id a92af1059eb24-121722c1f51mr7539579c88.22.1766322166515;
        Sun, 21 Dec 2025 05:02:46 -0800 (PST)
Received: from dev.. ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724cfd95sm31732013c88.1.2025.12.21.05.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 05:02:46 -0800 (PST)
From: Shu Anzai <shu17az@gmail.com>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: shu17az@gmail.com,
	yanquanmin1@huawei.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/damon/tests/core-kunit: extend test scenarios and remove redundancy
Date: Sun, 21 Dec 2025 13:01:14 +0000
Message-ID: <20251221130114.1483856-1-shu17az@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: x5c9czakw4c9ksr4qhb8ai7utxpmxrua
X-Rspam-User: 
X-Rspamd-Queue-Id: E9332120019
X-HE-Tag: 1766322167-359718
X-HE-Meta: U2FsdGVkX19iLLIGBIzL0R7r+8JSJRfg1vf8/qRKpywCxv4JE/ODZm4tBX1Cuj/WWb+1EE5Ju+UMrQFLa25Q6wnT1FN1nHMl45+ujaImnRDqxv5+EJURhAv8tiB143wOF7w/tdQlJHDZ/yw2N9bLIjMcXBWOohKNmpcL5FFjsbioumtAYJ/phkhGHgGAWIoZGjRg97dyAa2gUdyILtejPhg9btIrDWStk4CCi3sl068BvCfqzxb7GsgQIB2gWq0GO2qWCE2It0IOW1cAWjjTbemhCeoCUoIgWFGcoVDGv4kouSH2KljkcDZ54A/KE2sVea9aCCZKEf5E41CXzjh4uyxs7CM6CX3zFzY8mtrrbasi8MCZ7sA1EqBR7fqt7c0fauTBM8vZw/APCYgsY5SczldNsttVKuzkPEon+Bi7V7gvLbmU4zn2nj4FOOEwVwsF25I8SEYDmKIadNqK+py+fMjUMM9BUx40yleLkClwcLzjrZZD7pJvaKYLzKi8JxGPAj8vBO4hk+dqtodplzxgBwEwTA5nMGz9lL2+EdPdfhxBioTPWlg2rOt1xTiPCypkKABtb41fEIz3xyXDNz8dlp0j3MUSJm8/MysTOAuWvVrWG8/58hB38SnWILM+wOCNyG116HOgMC6+ZdoWIWxnSaPzkM+X6w0FjOQ/cYolUkwD7cFfqEb39Do5aQOfPppRj6BtWpjiQ9AuMnoISsmgJ8jHhkW4BmO8Ebyr7YrkQYaaasDE/W37ASA8OayKw/t00+qqUuwWR/YUOiU9XovBZnpxBaTrjEoceDyFfM8lPqE9nCbNaoafXgqhlGhC8DnKxcrCED4nbi69Xd6SHT3BLQkUXryIGMHzi1iB7qju3upiXxaepmJ+k0KwyWTKO7VqloKfNN8UD7oBgeymv7X6NkmlFVxKhrkRxnyQ28xfnW6si4Qs7qa74bKjn0/hIu347gSR6F8gdFIXgiyLZwt
 dSckl6to
 IPZQGRm4aWm+wEyYY5LaJPatYHliZ8+stnN+eC+yixDXL9qwfYBkUm2EYkLwRPLYLGWULlK0Do7gcmFyPRvxasCpE2ZKW/3c07uhg338bjOPmr/5jmfEhUlS+JycoRKFFHBTMLdVnLfFy3MYQLhwgb+gN9kSAp9Q6iwDoi7i3T/FdnTltfWwlTxGP6OQj1JDk81S528Ky2PMZ/dEb+wClh19W1L5+cQeiQWvdcNlBW1U6iSZcKNMybpPtCMulQ2XpWRqJPc3TLCDxu/LKkVgjdjdssRK7u8tkNjiN7bpVTNEeicxXuSZU4Q0e99G8jKT4XkfmwkDED5TuITLlRraOTUDOR1Y0bnGmjSRu91DpLcE+NdEyJvpiQeMuV5WQ0lejNG3cT4kVs1cssOzcNLWIn9OhU9l++fL+AWaB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add some missing test scenarios to cover a wider range of cases. Also,
remove a redundant case in damos_test_commit_quota_goal().

Signed-off-by: Shu Anzai <shu17az@gmail.com>
---
 mm/damon/tests/core-kunit.h | 51 ++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index f59ae7ee19a0..e9ccc3fb34f9 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -158,6 +158,7 @@ static void damon_test_split_at(struct kunit *test)
 	r->nr_accesses_bp = 420000;
 	r->nr_accesses = 42;
 	r->last_nr_accesses = 15;
+	r->age = 10;
 	damon_add_region(r, t);
 	damon_split_region_at(t, r, 25);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
@@ -170,6 +171,7 @@ static void damon_test_split_at(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, r_new->nr_accesses_bp);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
 	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
+	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
 
 	damon_free_target(t);
 }
@@ -190,6 +192,7 @@ static void damon_test_merge_two(struct kunit *test)
 	}
 	r->nr_accesses = 10;
 	r->nr_accesses_bp = 100000;
+	r->age = 9;
 	damon_add_region(r, t);
 	r2 = damon_new_region(100, 300);
 	if (!r2) {
@@ -198,12 +201,15 @@ static void damon_test_merge_two(struct kunit *test)
 	}
 	r2->nr_accesses = 20;
 	r2->nr_accesses_bp = 200000;
+	r2->age = 21;
 	damon_add_region(r2, t);
 
 	damon_merge_two_regions(t, r, r2);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
+	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, 160000u);
+	KUNIT_EXPECT_EQ(test, r->age, 17u);
 
 	i = 0;
 	damon_for_each_region(r3, t) {
@@ -232,12 +238,12 @@ static void damon_test_merge_regions_of(struct kunit *test)
 {
 	struct damon_target *t;
 	struct damon_region *r;
-	unsigned long sa[] = {0, 100, 114, 122, 130, 156, 170, 184};
-	unsigned long ea[] = {100, 112, 122, 130, 156, 170, 184, 230};
-	unsigned int nrs[] = {0, 0, 10, 10, 20, 30, 1, 2};
+	unsigned long sa[] = {0, 100, 114, 122, 130, 156, 170, 184, 235, 240};
+	unsigned long ea[] = {100, 112, 122, 130, 156, 170, 184, 230, 240, 10235};
+	unsigned int nrs[] = {0, 0, 10, 10, 20, 30, 1, 2, 5, 5};
 
-	unsigned long saddrs[] = {0, 114, 130, 156, 170};
-	unsigned long eaddrs[] = {112, 130, 156, 170, 230};
+	unsigned long saddrs[] = {0, 114, 130, 156, 170, 235, 240};
+	unsigned long eaddrs[] = {112, 130, 156, 170, 230, 240, 10235};
 	int i;
 
 	t = damon_new_target();
@@ -255,9 +261,9 @@ static void damon_test_merge_regions_of(struct kunit *test)
 	}
 
 	damon_merge_regions_of(t, 9, 9999);
-	/* 0-112, 114-130, 130-156, 156-170 */
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 5u);
-	for (i = 0; i < 5; i++) {
+	/* 0-112, 114-130, 130-156, 156-170, 170-230, 235-240, 240-10235 */
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 7u);
+	for (i = 0; i < 7; i++) {
 		r = __nth_region_of(t, i);
 		KUNIT_EXPECT_EQ(test, r->ar.start, saddrs[i]);
 		KUNIT_EXPECT_EQ(test, r->ar.end, eaddrs[i]);
@@ -269,6 +275,9 @@ static void damon_test_split_regions_of(struct kunit *test)
 {
 	struct damon_target *t;
 	struct damon_region *r;
+	unsigned long sa[] = {0, 300, 500};
+	unsigned long ea[] = {220, 400, 700};
+	int i;
 
 	t = damon_new_target();
 	if (!t)
@@ -286,14 +295,19 @@ static void damon_test_split_regions_of(struct kunit *test)
 	t = damon_new_target();
 	if (!t)
 		kunit_skip(test, "second target alloc fail");
-	r = damon_new_region(0, 220);
-	if (!r) {
-		damon_free_target(t);
-		kunit_skip(test, "second region alloc fail");
+	for (i = 0; i < ARRAY_SIZE(sa); i++) {
+		r = damon_new_region(sa[i], ea[i]);
+		if (!r) {
+			damon_free_target(t);
+			kunit_skip(test, "region alloc fail");
+		}
+		damon_add_region(r, t);
+	}
+	damon_split_regions_of(t, 4, 5);
+	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 12u);
+	damon_for_each_region(r, t) {
+		KUNIT_EXPECT_GE(test, damon_sz_region(r) % 5ul, 0ul);
 	}
-	damon_add_region(r, t);
-	damon_split_regions_of(t, 4, 1);
-	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
 	damon_free_target(t);
 }
 
@@ -574,9 +588,10 @@ static void damos_test_commit_quota_goal(struct kunit *test)
 			});
 	damos_test_commit_quota_goal_for(test, &dst,
 			&(struct damos_quota_goal) {
-			.metric = DAMOS_QUOTA_USER_INPUT,
-			.target_value = 789,
-			.current_value = 12,
+			.metric = DAMOS_QUOTA_SOME_MEM_PSI_US,
+			.target_value = 234,
+			.current_value = 345,
+			.last_psi_total = 567,
 			});
 }
 
-- 
2.43.0


