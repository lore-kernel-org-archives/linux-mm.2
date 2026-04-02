Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92D13CC6B05
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 05:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 969A16B0088; Thu,  2 Apr 2026 01:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A276B0089; Thu,  2 Apr 2026 01:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856FC6B008A; Thu,  2 Apr 2026 01:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 75EA06B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:38:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12AE2B9404
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:38:07 +0000 (UTC)
X-FDA: 84612509814.18.C1AA79C
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7C7ACC0008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 05:38:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="T3rOh/9f";
	spf=pass (imf10.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775108285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wpZU7evQNWPDKH6NxwB4xQqMBTVomSBrqVWkgmSAht4=;
	b=I4f2IZP7+1Up/jv+PjXPgL0DLL12efAUXliURYoBh3bbvQpzda+oSgkAAbvufzULfgVBk4
	UCT1GMNtmrr2DAUaq7eG+BdQtBhiO2ES50DWyecRyIDsEqclKDx82GJNKfsBOS4GQkONa3
	9JrZk0qBo+Y7HPhcTCwwAUGGiUyizug=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775108285; a=rsa-sha256;
	cv=none;
	b=N/WvTvPQDD5KPpU6h74rc3UBSoF7Pnznc9kld5DWtKeT8peZ1iVo+vaPSwF90Izj3O4HLr
	ERBHNUOb5nEx2EzY42HZaUzVtRxiKqS1XK2VWfslJRyK06p6hR0WaN9I+jyRO5k418L/Pr
	hIwXNlIFn31OVeSQ+1sMBfXsZVIrT7Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="T3rOh/9f";
	spf=pass (imf10.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-82cdb4ab547so221784b3a.2
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 22:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775108284; x=1775713084; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wpZU7evQNWPDKH6NxwB4xQqMBTVomSBrqVWkgmSAht4=;
        b=T3rOh/9fm+MAUEb7SWZSAeLr87ftXRoExCzciBrp7cL16bU22zVAwJ316lFpLi4Isv
         1/mU7dUvzZybB9K1aiscevjchniaK2uJvPjf2oO85bGHvR92di2M+6FsSHMwoFkS2vQf
         v9hmkI59Q1VV6ptqVEyKbbo9esanNHaJ7yOtvawLx5EDeDYoRKrARNCwN52doJwY9umC
         FEGmJJ12XWSnRZv8A5qr8jFPdw46bylhwxgQlNJ3IasWGKwcaGsVXSUhx8aTjBPKn79m
         K2z8TFWJvQUoyCs9Q3ZJiJtkv8oXN1nQ5GYAcQIfMQaESjgMbGjYywXcejAvEeRnoUt9
         FOIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775108284; x=1775713084;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wpZU7evQNWPDKH6NxwB4xQqMBTVomSBrqVWkgmSAht4=;
        b=fQ/tRiE4fu5sazYxV0qJtE34isvtESuBb0BC9hyteS2GYpgjWNFXAKLOS0pIDxUKm8
         Gu0yX6ovKKxLAxUWxLSpQ0SpWVZiLJxyp2wEg3AqCWzlVtUZ9yIuXRjVbacd3dhweI5y
         E4XxN1aoOTxxyGKQjIeH6Ehi8NWiavFIkvPyDq300RwSraZ9toBJz8+xc6TMtTTHOeNI
         k38A4cmmImyDhxT1uweOS+ywocwontD/kR4oDHDEVRNHMgtfm7bZs9+kSBKJJ+AihOJF
         CnOCEh9JSwzboN08/ja9YDk6y+jOEnLOdg6OisaxTHzUsh0Ub7tZi2071lM4/f/qebsJ
         8z5g==
X-Forwarded-Encrypted: i=1; AJvYcCXMrIMI5Ot37sLkTZkGaUJnUPFoMrgDY8dbegoNbN9pQSmGuI9wGpsmJ9SuDX9TzASOGBAiFONvlQ==@kvack.org
X-Gm-Message-State: AOJu0Ywooj0Kp7DmBs9xaasXeWXxBijwaqZ0pyUC7vo7XirLW7TeHUOC
	HSAn+UgfhF16o/m5iDys9itJwgautvoSCLP4Tdw6DJHFZYUnXvCdbRtn
X-Gm-Gg: ATEYQzzHkigDToefPTVu2+d2V6IHmOMVH5zmoNZRGTYi1Qdrpl4b+sNBhJTqyFJ1BU8
	Cf6Y8bClyKpyee8nyA6dkPT2Byi8HSx69wXxX1AyHo5NJYakCG7nMHVlxX3CzFE88Oqnep3Cm+j
	Xb829wYUSB9hEXpIZETZJTfLa/n/ct/UQb9eaguHHCL2KY01D52/I6ELS6LXTdcNXvc6RhN6iZz
	bcRqZdfXSHqGW4RcuU0s5rFwBuBR1Vnm7cEztX3Bn3SVMBzwd+uDxcj6+PwNof5/p98vNh5eMOf
	0du39q+YBHd2GGTTgO7GWQZDzg8t37K5lZFpae8lDgfHTpNiD0h+3amCuNykQbBVGk29dKpsZz+
	VcUGN9w3CuUfgtf5/VRx3KBbpQQttb8WAG5Z7VsHHETnhSwrOwUlAXKN57ONG7Y1Wfv9aD3KWpf
	7gTJrRsBP+l99GMGGs7RiRvEbAtnhuLkVLyEhIXC9NVtdhpU2bncU=
X-Received: by 2002:a05:6a00:2e94:b0:823:12cb:f5d1 with SMTP id d2e1a72fcca58-82ce88ea8ebmr6525320b3a.6.1775108284208;
        Wed, 01 Apr 2026 22:38:04 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9ca1f28sm1758569b3a.57.2026.04.01.22.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 22:38:03 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v2] mm/damon: validate min_region_size to be power of 2
Date: Thu,  2 Apr 2026 13:37:56 +0800
Message-ID: <20260402053756.26606-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7C7ACC0008
X-Stat-Signature: 3bmitg64q4dhu93hmygekk53egeadzwd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775108285-634093
X-HE-Meta: U2FsdGVkX1/Uvxa9f4Z5TJsVHqkJAJj6ZLT01+2cwA+Lkp15pBMtykeBq1aVtogJVuUm9xbl6TfbFSI7zZqwAMK+EgHPp5vSDkmBmJMOUywRB6QcVhu1rq60MlWeB2LwRKvqWmwEJ9i2MYkcZrkrGTaGEUd+k7Fic3J4gcGMKu//TGlJsh2WnbOR78KPo8f0/MlPjabhMpqLjGe7hI4GoAjuqizMCZHxdE27s0ci3MoMdaEXdTuNoMp8uSoDXp1e9RfAK3Uzrv6Erb2g7JydKRbZxzV7uuAlfU3qWUSOOpDFytSLd0hKxP8owjLv9Pm3fGxnyJXR2CzLARB/Ads7ynnCqo6jlP4O6KAw2ESgyf6K81P819sfiz6BLbGjMs259AoxB7jgWZM6HG4UgpBfM6nUjEnS1OCXQVKonUV5ncxr9jKFKgEEl6sGVFQf9MHGDO/xw0T4eCTW9WDFzsi10WTfl34Sw8B4J4NmbPfNjpPpTNDDTVeSl2UwpWAqrXeJjswT33ItqTOGtaAnwPC6IXuYOuiQ3+9EEDmtVkpf1RAdq1j3up6nbjBjAA45DOrKevbkdAjWJvpAoMzlHBrDecGGMhWeS4eDZKhc6n1iTqRlAugNO/B3wUaIxNQqAW46DZd8GRaYAO0FBAZOGlCVzy42BxRYV1WZSZWinDYEH/d8QHQiyaYACOZNECVQ5V6P41nGSL39KYqySkiVxGschFIv38NZXfWRvwpGKV/qdp0qpyJAL0IKHYRZumshuTzOzebxQlMT3HDr71g5TwvCWRc80AX3ArxB/yjaD5G3B+PHz2/aoaNMBnotqBJ6VSNunQFq1lsXvE/rPv0Y+TIAope+E/BQxF3c0EIKH4sOJUI1PKOV+FL/LS42+ggWrGhvepqnnieJmGkk5NFZL+uK69ykeuziY/bVMLESOp8DlZZKHbbgsFVixr8bE09+m4x+Y3ST88ngLwA08REOLGQ
 EU2FY+hW
 8g2pt/z3jS76BqcpAqPfw6Ok1FR9rqjGqjPxPvcaz82Ze28EpcH+yzFsLaJ2S1a6hHRWvl/98Q4GWv2EvP63udosKdABRdd4SISXn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======
damon_commit_ctx() checks if 'min_region_sz' is a power of 2. But if it
is not, kdamond will terminate unexpectedly due to the user's invalid
input.

Solution
========
Add the same check to damon_{lru_sort, reclaim}_apply_parameters(), but
return -EINVAL immediately. This is to prevent user's invalid input
causing kdamond to terminate unexpectedly.

This patch is a follow-up to the discussion in [1], where we agreed that
the validation should be done on min_region_sz rather than addr_unit.

[1] https://lore.kernel.org/20260330233343.4083-1-sj@kernel.org

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
Changes from v1:
- Fix memory leak issue.
- Link to v1: https://lore.kernel.org/20260331073231.30060-1-aethernet65535@gmail.com

 mm/damon/lru_sort.c | 5 +++++
 mm/damon/reclaim.c  | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d72976..3fd176ef9d9c 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -294,6 +294,11 @@ static int damon_lru_sort_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
+	if (!is_power_of_2(param_ctx->min_region_sz)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (!damon_lru_sort_mon_attrs.sample_interval) {
 		err = -EINVAL;
 		goto out;
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da14778658..2747eef5919d 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -204,6 +204,11 @@ static int damon_reclaim_apply_parameters(void)
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
+	if (!is_power_of_2(param_ctx->min_region_sz)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (!damon_reclaim_mon_attrs.aggr_interval) {
 		err = -EINVAL;
 		goto out;
-- 
2.53.0


