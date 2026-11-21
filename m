Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9B10606A69A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 02:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iy2MKOqX
Received: by kanga.kvack.org (Postfix)
	id AA2D46B00EF; Fri, 20 Nov 2026 21:56:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05CD6B05B0; Fri, 20 Nov 2026 21:56:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CFB86B05B1; Fri, 20 Nov 2026 21:56:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CEF06B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 21:56:45 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9EF311602F3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 02:56:44 +0000 (UTC)
X-FDA: 85457613528.08.FD034AA
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id ED551C0005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 02:56:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iy2MKOqX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of evanfengff@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=evanfengff@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795229803;
	b=tL94J/t6bvkCOFHpf+9XU8dfpBrSfeD50e3RGm4P5kfQwUsLgg6ZUte1ozY9G2P0WeQQmn
	zV2k/+ugSwolod5pZPArGQkdnjy4PfoJ/uGOnGNiJ+cSbI12vcEBNVhTLzVOvxIxfMsgrm
	86IwYtJGYEBjZ3TZ/K9an6jCvfJkPK0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795229803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sQ0URJXLHPyhV0pqjQJeFam3yZqKvnQul1dVgNuKRU4=;
	b=XguzN/DhoYum16Ql7HOeiOV3BwImTv6DvH8/x/LOyHUIlU3u9wj/8iA7ZS5NVA1lNPyzXw
	1UOxN1XCojYfofYjIFdtQXJLXXR1GVkckmW+i0xZIsEmUWscaCQHZLPPTg8gvFyiZKhHW0
	XYhZXjUZQ5aLbuvp1dGHkdJuSRxt2Ts=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iy2MKOqX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of evanfengff@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=evanfengff@gmail.com
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-385d8a00598so1842743eec.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795229802; x=1795834602; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sQ0URJXLHPyhV0pqjQJeFam3yZqKvnQul1dVgNuKRU4=;
        b=iy2MKOqXbWY2QIZXxLheqVFmWRaFwzgVy8xBnEm0EJGotSpxqvfPTxOtaTsSflJrsr
         plDaisDKbAq40ckWdGmh1RpUxFU+zT+btvkzTZThkdXbOnwCxEszfTFb+TD+gFotwCV0
         lQW6AUl0qkYaQYJrmEH38K/XHU9BEC0T5sXLe4UfPQ0XxPbzwEELv5tl6pTLOu1NrfzY
         uncso9wDGfVmt5YFIOdG7tU3nzja/DBddYQL9n8WXBxc4OqOw2rHC5u0gmnm5t7Ukin7
         K8V9oHClLeh91dHCU+FjyBoBoBJN6n4qv4tpqoV7qLR5OpgdTu8nyGWYjNelnOqQ4T/O
         fbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795229802; x=1795834602;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sQ0URJXLHPyhV0pqjQJeFam3yZqKvnQul1dVgNuKRU4=;
        b=mwLcSp5Wuaz1/65gC0C7QzebO0E15ZO0LtOMAbi0cPBzD/KRnxqQNOB0HnoHloMbFr
         RwswDhYZSH80cD88+ZWKZj/fBA7zjpM1aPS9qMT0plAodl2fLc0Gjd7/xRRftPH7h5RP
         dh4iRGDpu5+RKtGZPG2z4/T7VwZ+mXzrNp0aMfB29k10JepHDAqXTTeD06LKri3sFnBs
         7ZTIp0Yz3d2UWS5beDfmREglWU9wLEmAtyEG7RTfAyrTUzshid+H4atZuwzk8PznrzUB
         EaXmImetb0vEJnlzTREcPRVQqVksJb0KUmF9Fa7XWPtfNlIhLFukBLETAp2exxq3FCaD
         0EiA==
X-Forwarded-Encrypted: i=1; AL+hErGLjw2uBVKAWHjCEkKgd2P1066Fl3He2fajio7t+oIefo1MtimETumxxoFA+omaIdy2JWwTNOzglA==@kvack.org
X-Gm-Message-State: APuU4Z99PLLR4m5nvk+tTBMk1q5SJCIqpVSm+sw5aotvltz9QxtGQauq
	EorqKXZraHCbdSl9lKk92Yq9E2U+PnS8eWoRcOOl3tdITUqKCL9yiA13
X-Gm-Gg: AZFdTZcfToH6B+ppHDKVN55IS01rNimG0tAOTZ5nxlCX0Q0zDwqkTNkXj9AXKxd/YMH
	XiN8uc1OD12VwAZupyVlOvxI8/64Rx2Gs8iOv/uSKuE971/3CCImi5tUKqlQ8zr4912nmdESSs2
	D9Z3HfTdiETWIoxnD4XLof1zJ6tum1BuDWEx62x4Tqshqmy6AXjmw3pRiKpOp2MmtOJ8SptWOyk
	D1st/Cp4OdGbe0mS6AGoIH2yx/8fa1SlYp5NVoHj7bncLe2SZql9WAo1bjMtq31Vbf84vTVhS8c
	QZ6doB7yUxHBMHoDCee0k93DRmNhJ8zucj5lFLseRV0wobXvks4zLMOTOY86Q/1mEybE98GCdLF
	eIiWrvzBBgUGsspA5LANObLmyl84h0q6MtGiMMObCnLtzwuqRxBTlwBqBjnDJOmbpRPaoEqS48S
	PglnWWvlGiYroQN306H7AfrmqjblaSvkMwJ33ZDSP29t3TykIm5jqub1KzBDZk3OXIIL0GtlOyK
	ZIsKD2xmbZL77IbN85qIxC22m64uEReqID0ikZhYd+qSsnwlob7Q8U2UPTGRPbzXi5FyIAKhTPY
	p2Ni+nm/VX5reuIAWqnF+NQeaZZn75hqPrHpUvuJG8k4nAPlwkqEAM3/6WMQUq8K+5d05CL0rqg
	DP9Sljwi/ARiRY0+FI7KVkbTN7RW4sLIF3gzp2kDdbe5JVlCjzgl3k0KdXz2vaYmS3zvyQKrHhx
	blTQ==
X-Received: by 2002:a05:693c:8641:20b0:383:50b7:1d78 with SMTP id 5a478bee46e88-38571223ee7mr5312730eec.40.1795229801565;
        Fri, 20 Nov 2026 18:56:41 -0800 (PST)
Received: from localhost.localdomain (206.135.124.34.bc.googleusercontent.com. [34.124.135.206])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385667decc2sm12071967eec.9.2026.11.20.18.56.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 18:56:41 -0800 (PST)
From: Yifan Feng <evanfengff@gmail.com>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yifan Feng <evanfengff@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/damon/core: fix damos_walk() hang with zero watermarks interval
Date: Fri, 20 Nov 2026 18:56:26 -0800
Message-Id: <20261121025626.75981-1-evanfengff@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kzs8fgow7ro435absgux9hhgbnsqt8ca
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ED551C0005
X-HE-Tag: 1795229802-5350
X-HE-Meta: U2FsdGVkX19RC6cMZ9nXtLvsxnCxG4FHpoZ3KBTeJZEGLYfzgz6akI2jIJUCRNJjlbxwRhqSvuCai8aSTnscgDvFOvXrZqtd/EF70LOczJZg68VTAs7ootW+lLi1FsSR8ZefwjdLRZOuSfh3yCZhFe7/kZaJ3oRoKLSCGKGf98ESwnQmMlc7/VioxmbMDioiU8PG9mv6CAIjc3gmyv2SX8VnpBDp+yU6LPbDwkyBhRq5FPSMmdtYMum8JwOYAB5S2Yh5jOuVkBE8AtBS624MRPvnuVTTTp3FR6R4JJBFRodWo2xmhd2cj2Ht3kia9Eaq6ZDctyEpKpWtyVb4GLkfp23c2VsM6Dmd3kLDg0oZwQ8ELCwPz514KEvZbisoaiIfaH/KCxHs2LmrNo82b1zCGlBtO2ZfrhOj9RIVUCJsNYr0aUfOoXidIqmu4Ly0jODBC7oJSMCFfHRH5HCVbE9ioFSu3w37skvACiXR3r5YoaW3gCHtSu6gwdK+HAqpvknhIURt3ufbUd9zIoo1VVhC9LuQFredj6K+Xy093NevFhH4WQPvymfnZMf1IhCopqJo1+6iE2qXz4Ql41FFvNbN37Nc4VeEVOgdaHLhGpLy9+ASmbM+w8S9IhTU8lk4YHXCwmr2XYpotkgjGRw47Lk2Iu1mdlF//x79oIPjDfX11eVOJksBDyTbpC6mboJHz+fuHI8Mu7jTFWtodYBAoo4b3nYv6IEYAiZny/E/sAvqfb3jOBnq7e223AJ40F/3N0je4mUYNwkF9RiglKB4ULzbCUEHLPkfUU9fkn8uf4/oVEdMYVXWsvigeP54vy4ZNYCcilV/jGB4p/DRFgFRivNyTov/ub7xeNSVxiTksfh0/hofY/5cd547jI+2HZOCBxNS+lgnDTgNzTnIfVhgguo8E/60W7iHhBfDQ+b/6TlknfjYCrHLR/ZrS9hb7AlpfGr5KN4LUVivlu04kLXeOF7
 0JGuhdED
 6efJmKspa+9syWJHVQ3qSnRkRme4IrpRZUnGkcJ3MwLCM1YCSoWSzL3xN01NKKIkgw7aGaCvmK0U6/KBEYMmXxkUylMs9mVBGNB1/UXPe/P4hgSHwv+vrcRLN7f7WNTpkrt5Q54kHqyfB567GTTZMi7Yv/njSVL17cpgYX54x+M15zg3ljDNX3M19unwokwY4xgXeKXyExaFkaOXQ7pKWetxNnCHD5OoOJEx1aEos1EXgzmcnjZ9Nku0RjpaXSQ3goUVw7ftSwWH8KSzITU+zbpF+b/qW7CurvewTNxMReCm1P58Z24vS1lxEJhgdTGiaWs1RM7JckixctjLrbmwJYIt6N7vUOu9S2xDBpr1vziYnpDq19w8V2lHCN6WHUPltKQTudzGlriySeR19Ltc19ra3CbQ/Xw2MqhppyEU4PCbAtCQuczOQS7er27Z3tfpUGq3aYisdvDL/h0QKSlE0ejnMbA9CYW0ZZjIPgq2qAcsJznkj2y5N7NYEVEgqNnC5R8rxZz3y9RHybQToQ5MruXX8gavxnF9xa+qg9+YZKogjHCPDQj01GPf2kMXXw8eLPFce+QBXLIIvDsciR4LSZQcnG06c4Cnw2t01cBVtubxe1CvvaequDpL0GiUxxhS7noFkuA1xxaDC3qJc4I2lTLWHpraq7nodsKU82v03kT6gEvs2QVyQCgki52K2Pj194pKd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kdamond_wait_activation() cancels damos_walk() requests while all
schemes are deactivated by their watermarks.  But it returns without
waiting when the watermarks check interval of a deactivated scheme is
zero, which is the default of the DAMON sysfs interface.  The kdamond
main loop then runs with all schemes deactivated.

In that state, kdamond_apply_schemes() finds no scheme to apply and
returns before it calls damos_walk_complete().  The walk request is
neither completed nor cancelled, so damos_walk() waits until the
watermarks activate a scheme again, possibly forever.

For example, with a scheme that has the free_mem_rate metric, zero
interval_us and a high watermark below the current free memory rate,
writing update_schemes_tried_regions to the kdamond state file never
returns and cannot be killed.  The writer holds damon_sysfs_lock, so all
other DAMON sysfs writes including "off" fail with -EBUSY meanwhile.

Cancel the walk request in kdamond_apply_schemes() when no scheme is
activated, as kdamond_wait_activation() does for a non-zero interval.

Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Cc: <stable@vger.kernel.org> # 6.14.x
Suggested-by: SJ Park <sj@kernel.org>
Signed-off-by: Yifan Feng <evanfengff@gmail.com>
---
v2: cancel the walk when no scheme is activated, and leave has_schemes_to_apply as it is (SJ Park).
v1: https://lore.kernel.org/r/20261118235012.14859-1-evanfengff@gmail.com
QEMU: -ECANCELED instead of the hang, 20/20 walks of an activated scheme pass; kunit and 13 selftests pass (2 need drgn).
Found and written with the help of an AI coding assistant.

 mm/damon/core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b8678a53b0a9..2748f9199924 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3492,9 +3492,13 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
 	struct damon_target *t;
 	struct damos *s;
 	bool has_schemes_to_apply = false;
+	bool has_activated_schemes = false;
 	unsigned long max_region_sz;
 
 	damon_for_each_scheme(s, c) {
+		if (s->wmarks.activated)
+			has_activated_schemes = true;
+
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 
@@ -3506,8 +3510,12 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
 		damos_adjust_quota(c, s);
 	}
 
-	if (!has_schemes_to_apply)
+	if (!has_schemes_to_apply) {
+		/* The walk cannot be completed while no scheme is activated */
+		if (!has_activated_schemes)
+			damos_walk_cancel(c);
 		return;
+	}
 
 	max_region_sz = damon_region_sz_limit(c);
 	mutex_lock(&c->walk_control_lock);

base-commit: 4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd
-- 
2.39.3 (Apple Git-146)


