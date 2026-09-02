Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EED78C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB80E6B0096; Wed,  2 Sep 2026 04:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43ED6B00C1; Wed,  2 Sep 2026 04:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90BCB6B00C2; Wed,  2 Sep 2026 04:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6398F6B0096
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:44:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9B3416010C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:44:49 +0000 (UTC)
X-FDA: 85168186698.02.C937C68
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0D5CF1A0008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:44:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jHWxHYJY;
	spf=pass (imf19.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788338688;
	b=w6yN7OiGJwjrRygxrM+t1WgSz19eiOZrSknaIif4Znr0OLVutDxSHeifYT1+T2WOAdk6jd
	p6QH6o4tFCwzP1jxowbnW3ApcpH32a2TXQ9MBHrO2r7cyV5fGck6LAA7DKnkwwnLbhh101
	3iD8g3JjYphS5+Lv2Mrj4jy5RWo5e84=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jHWxHYJY;
	spf=pass (imf19.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788338688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Uexc1NDi5NdMn1KWK0fKne2QitDNcH/zJBrubqnXvz0=;
	b=G7dTKit+FKTX8jSua5F801hb+qPceKU5gqwwK+5cSiWtb5i3by2Owx3i9b5yppTwvFUA3r
	KQNb8ImkbyNZPxIu3f/G0d3Gx0dpuVpl/fZo4iAGQPdbgKDeD4dKATRDhWZDqy+FQVDkvr
	EWHBRigN5US35nRc63EwwGeWikbt5MY=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-84e04df8c46so1147412b3a.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 01:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788338687; x=1788943487; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Uexc1NDi5NdMn1KWK0fKne2QitDNcH/zJBrubqnXvz0=;
        b=jHWxHYJYSGgvykfQCtHgwqvzpeWe5XS+G0CKu7JMNH1Zr8f5okBBhp68Ts/wC2iwzI
         Q879BLpz4rPMHxHnqSSbQh602Oqw4dV+PIJW1leqJlfNHiRWTAhwuNwP8gLcR76Py5ZO
         NcXE7LcR7wmNZvB35GazjM/ojZK3cJWjecWziG1N1e4gM1jAaB2L63jGg8+/CNhylzeN
         aOzqgScLj5l3l8Opub6B9y1yJzhZI8KWDf2nQPeN0ILBd9l3G+YHoiEL6eSxoE+MFdnM
         emdSQBvLS4+7fFup4Lqr5qEUqBBnH05SEpPk04kBXPhRet8LBCLgEL1iB6eBW67vQEOM
         s61Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788338687; x=1788943487;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uexc1NDi5NdMn1KWK0fKne2QitDNcH/zJBrubqnXvz0=;
        b=UG+f7/+4DUuq08VraOvxyGRLEQ0Un/jhIB+ue22Uewu7eo/zyN6S87t6f36qMJ9qIA
         wI9oab5o4wXA94DpeIoYDG19SGUdn7XqBBOFcJ5xgd9SaTIbpohqXa3+ld4qtYTEoIef
         ih2I0w7jwWB39ffr5vqUjcisyLnQZ92LitmIjDJeCtAHp9QIWQu+HVJdJvFLjtlfvrys
         zI8jTT8f7tOoAWZLFZ2nM+3qiHPFvU8rynTnI7o+e5e9DulCY6/BtFKffSNLR4CbNcrp
         Bz9cCETgCEfadwHN9XuwhHgmUL07kalF7F5+zWHRcf9z+9LOIorsP3enzQw473cDHhMq
         Gx3A==
X-Forwarded-Encrypted: i=1; AKwUvBzcLXqy5g/fdQBnoB7u2yWzuAs0RWljfWeJpWvDWvdCxQJVVQ7qasHta7oOOVTt6yTft1JCZnuv0Q==@kvack.org
X-Gm-Message-State: AFuF++mvg3gReuZRocvJ4vSlaPGgsO+pi2YxyLWUUgt7vgQXiu5FjT1E
	s40EmZrhTq9jVXEUJfRBw1mcpPAr5fTC6PyDeInScBr9F26hpSc5ZzAh
X-Gm-Gg: AYBFou3NtLOj6U8Lbe27FG23dRucOP1XvyRzfzjeDr5Ds7ElV8bTLrtZraNcKUvPm/4
	WGDqfyy36zIpNwYMAbLPktpSNP4OkeRKoiV1u9EW9+BHxjy1J2PueaeW8xMc4njCGZfV4UQALjp
	zuuxGuxH9RyPfr95iuuUJ5+gI08OEG6MQavTbnOtmFLhASz2sQ1tq4qUfDAWeqrQDkbut2Hs4je
	Mkbkc29JK5Mpcp6vE4RB9uxN4mEe6fwjUKP/+Ik/COKx3x5TjFFbdJKP9oIQ5mG4SbkUMAiGZ9D
	MsNh7wmRDX2ZX5gSofrYGPECwbrzJfnROya+RXqiYt+6Td5wHq2E5kdJuPtHEOUzs+8FHV+Nm3S
	etrKO4j8LoHDKfARJE9ngGglGexB0eDOZVTBMAXOZdt1JFFzLiF+EpxQXFiGyn+Ba74cbUTJGgJ
	1PMcjklf+55TZ7YgLPcbR7HyQ/cIUIyglsF2AYmJlnUXouoAsrqCA8Eywhbu8F6h0G+A3T0L0Y1
	QU3YxGnc1omVZXs
X-Received: by 2002:a05:6a00:124b:b0:857:726d:2709 with SMTP id d2e1a72fcca58-85ed3f6e6e8mr5014011b3a.21.1788338686927;
        Wed, 02 Sep 2026 01:44:46 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:9c5:2de5:8b4e:3f3c:b637:4ca5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db29deb9fsm1047430b3a.16.2026.09.02.01.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 01:44:46 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2.1] mm/damon/core: fix false positive in damos_quota_is_full() when esz is zero
Date: Wed,  2 Sep 2026 16:44:45 +0800
Message-ID: <20260902084445.27170-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0D5CF1A0008
X-Stat-Signature: kpxu69c1ycqtz3nxctyzcqgiwdcyg8kb
X-Rspam-User: 
X-HE-Tag: 1788338687-373562
X-HE-Meta: U2FsdGVkX1/jpgoc/sLMTPGxc0R9lgwuvAkyYZgfr1kZ1XGVoWpRo9Y04aEwshya/uiJMo9Qs0d1prSv+bl8icKpGdh8n5ty66krhHFjKv4c025ToynJslVXXAEkEYOwonbBqA08utW+d6RkKiGp1RfxjO/m74BHZ33FWPXZqoBEGXDz8jXN3YJ7z6QhrhgzaQl3SjgEgzyTBHN5dJ+lHCS3D3TM68XAKPhZu08J05iJKQy6N1CimsvJG1xznf2/X2M8uroqzPx+gLbmx6WBrEt35jH+Y5OfGh8Qt+b1sT5w8yBlFldfSu+52qW6MLr2omPer1Mc0SBi14C9ePNwiTHqibrfPZP8ugSOUapc+azRuKp9E8Db65g7JOhEhOtrohXCQIQaVx1geUTYBsgSDlxxV0BJ8OpuSIyxtmxDNLbLH2o/UGfWX/ouldpyq6phO/XZwEoCbxS5WIIcbRssSyjZ2mGYpKpTW10lXH/noxG6u54AaaTQjoSsMA4GTnkNqfxJJHwUP2ZB/V4PiXIqJd/BgKe5isDndXRtKvl1lSKv8Bzz+b6AD5oHrIrjcW3/9Cd7QAmEpXxlAx3eLhmpKmTgvKNzrZlQ0nslQBrmUUlbtAG9PmJfQVZ9zIAqTtB0uIP9lcjTXKWn+kkfhtNLIwM8mPTMUy9KbGBq2DgSAZCx+6dJvWW3V3JHjtQ3KlK0bTFhjnthHE9YDOe+tLsm0FBy6sQVhgQgs8QjPykBXn8IxSzWbpZOrdFAoPytRNxK1HjzmUQ25qNu4eq5F8yMVABwjMoQbTGCZcAFkN/7QgkMLrj3uMw+6owuAmvbO/hhyQHZUQoXZFEUPq4CiCt0S3uoAUU9XvTlLv5X9VueAK6BL0954FuiZYALdsk9j+K6dBzbtiPkIlkS6+QtcmD3hwsFeemrwSoyqAITBIeGxPGUARIKV/ffqX4ZCi8prPYJEq0qLAV3ao+3H9InfpG
 O6MhwgJa
 ufoaQPvkFaoSaeYDGTWQUQDSYfZuHPOsKY1LpsPUT/CB4q1ZSCMqDZr9HWfkHVtGXKc1HmxncV3AA5OmopG/1xCI6LzgV9/lS9LQboQc21kPZgt3IdbTHVar/+Z5eKMlOGVQojUx+QbKnVFsaVkOD3LrfxnXR+hG16gQWwOUoGlCGSR7YFkCJ93qHPkX8v6ggSUIvPG8oPya8MvM/uyufw/lXJ1mDTpy9ZVbmG+K2wMMPlRmOoc/Lpw3Gk2WzBPNcKR3qudTNzpSciXiMruBFrP1Bi4ZAQ4/9srIIuNeYR8Z15xnmB1iJR+vaihW03UaTP3mClrlFczFwkstxpUvEtX3xnbuoYSucofYH+Pt6OYr8wHyuHcZhnXIOBcUuWK4a7/AaC82yOJWULDr0UwPMZXhuohyup2sux7ek+ZR2fjan8gfTHTIK3bS0pJOO0nH/3uAUevTvT7YkeTg7+zL1goRBsmD6ET5snt0pSYfip88WZHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When setting goal_tuner to 'temporal', if the goal is achieved,
quota->esz_bp will be set to zero.  In this case, damos_quota_is_full()
will always return true, even if no regions have been tried to apply at
all.  This causes qt_exceeds to increase unexpectedly.

Fix it by:

- Returning false in damos_quota_is_full() when quota->charged_sz is
  zero.
- Adding an early exit in damon_do_apply_schemes() for schemes with zero
  esz.

Fixes: c7ec7d5f6b3d ("mm/damon/core: handle <min_region_sz remaining quota as empty")
Cc: <stable@vger.kernel.org> # v7.2.x
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---

Changes from v2:
- v2: https://lore.kernel.org/damon/20260902081825.18931-1-aethernet65535@gmail.com
- Changed patch title, v2 title is truncated.

Changes from v1:
- v1: https://lore.kernel.org/damon/20260901105925.106186-1-aethernet65535@gmail.com
- Changed the check in damos_quota_is_full() from '!quota->esz' to
  '!quota->charged_sz', because the former is an upper bound, while the
  latter represents the actual quota usage.
- Added an early exit in damon_do_apply_schemes() to prevent a scheme
  with zero esz from being evaluated by damos_quota_is_full().
- Changed patch title, original title: always return false when esz is
  zero

---
 mm/damon/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 8e3ded1a2cf6..de78ad56c8b3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2560,6 +2560,8 @@ static bool damos_quota_is_full(struct damos_quota *quota,
 {
 	if (!damos_quota_is_set(quota))
 		return false;
+	if (!quota->charged_sz)
+		return false;
 	if (quota->charged_sz >= quota->esz)
 		return true;
 	/*
@@ -2666,6 +2668,9 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (!s->wmarks.activated)
 			continue;
 
+		if (!quota->esz)
+			continue;
+
 		/* Check the quota */
 		if (damos_quota_is_full(quota, c->min_region_sz))
 			continue;
-- 
2.55.0


