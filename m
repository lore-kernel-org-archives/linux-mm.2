Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20851C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 11:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1512A6B00AD; Wed,  1 Jul 2026 07:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 102206B00AE; Wed,  1 Jul 2026 07:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBDA46B00AF; Wed,  1 Jul 2026 07:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B38906B00AD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:47:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 391A71A0352
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:47:42 +0000 (UTC)
X-FDA: 84940033164.14.2B225B7
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 69865140012
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:47:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="alXslpf/";
	spf=pass (imf26.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782906460;
	b=UlTV/TODUax3VTB6Vunhjvf3d3u8S/ehBNgwBbh7ac5OLEi1YWct4vJHQUftQN12rP+p9P
	f7aGo+feBic28ser5FSTckuv5edcEYV3GcHA0wQ61mp4vx/cHpjKIROtPHptKEOcmMfybD
	xi6kyt4i4fWC+vMyQkgfMzQlkYXNjSo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782906460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2S1A2WLG+DXJhb020TiDIFAisi2ilb5rl7oXhzW+7c=;
	b=LggpRrePBJlh+OtL9zSaBG1FuEsnTGh2O0v9OTC+iUoUp3YlfQvZbkgqV/Xk8rJp8VDnHJ
	8tB9hAyhFEkqnwV0Pc81DIxuyIvOc4uj+nm5PmDqP+SDY7ABctnNN3IQo5j+COusnXI44n
	wAuk8m09qufEm5ukO+sU8iu5JZFBmwM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="alXslpf/";
	spf=pass (imf26.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-30bc871ecdfso935691eec.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 04:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782906459; x=1783511259; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z2S1A2WLG+DXJhb020TiDIFAisi2ilb5rl7oXhzW+7c=;
        b=alXslpf/jqz9wfHkHwbycVk9mCHOavDHvJXF/VmGmjYL5ifzon+TIi6c8aRzdFDVr7
         05xRdna+LsCYSo4Hyj+PA1FtWDvG2QQBvw+bfd6wHwszVU6CPUwM0rKoOW89K9kXCg43
         FDOAlhGw3ubCX3Pl9nDb/v5/IUEHy/uBQjyjYjp5s9SH56WzVz7sv8SKlFelsMjl4/lA
         ko3V0pgJKMfgIsi9UtNUuhgNI2SXrW0KHAOK5LQOHYAvlbx6V2rcN4/eGiuheKvdFOfB
         AptHOA38+bm+z5RX5BtmZfHAN3TJ+C1FZienJF4lUonSYMNmqkbkcw962KN5OQy88sVr
         El4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782906459; x=1783511259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z2S1A2WLG+DXJhb020TiDIFAisi2ilb5rl7oXhzW+7c=;
        b=j/TmZ6V37759wuF6NRXwva034I7041x79wmQHWlEUdbTEXxe82Ku6pMZOOwavhr8uF
         VCkkal2f+1eNNTD9+6EhAKKLgucq+FsTyey/ivdoWq/s3ANQk7vBrjAn7C4SCMIRpeof
         MyiJtO+7WOt+UNWwRYV7NRCemOotQBDfMdXBqePJDDEeIBr8Kkg1Zgh3v6ulb+uNRlG5
         QhEWQm/9WwK1OvoKWfNlyLeyr6jWQhtmGnNzl7Ov/Mp8rM7QbQ1P6YvO9XHRj8WrQwrJ
         y8Y2v/qT2aLw8PJNlrCwz0jtnyxCBMeoKy5II3HWzyrFS1tGfB1rrf7WyUeT1S2XYAy2
         TJjg==
X-Forwarded-Encrypted: i=1; AHgh+RqfpM4hUrVJtU20dceSmFYTa7H51uCrQzKaBzz6p5cYZWMAGDBXH0bbiURB6emGyKZ2x2ZvIoYnkQ==@kvack.org
X-Gm-Message-State: AOJu0Yynb2gPnlziIIiBvueAaZJXaRj/II5VBoNtxSPHMAwzY2wXv9Vc
	CGQVDKy4qsoA3PkL70Uo9iufIxEFxx5lWSf/SC0/8DqGn8ux1FyAvhQ/
X-Gm-Gg: AfdE7cnUseqsyXSIV+gF9VCeifkD8ndITcElxO6tWxmVqwAak51czO0PzRsb7+0s9oe
	cjkpgHHGqS4zd4jRHEpFWtmBxtxMN0uLgAKPcdFgCEE0uIWGIvQwYTxqg2qUQi6ys30P0mfkF1r
	uXR8duiKwYxV3cTDhwwXM/UxFJdtRSl3lrs+acHOgx2gt9dJbo8pSQHwzs/8fxJhR85JBvx4Z95
	vbn1Sec+TUJ0m2gPQ/rvqY5L7DVzEF0VMdclnwDPeTHwp3iOJVVOZ3q9O4gnKUEejSVRAxgvdB3
	EXe8ggZyXXOVGVGeRLkivHogElXSJMmaWcGQNNkPdoKl3XEjP1pdBuWDu44seQ65hrg81pYC0Vy
	tvp5flw7uHuMYEIcVYnNmiEgTlPbGDm7q29fqYLLYYiUZRzulnJ6TY7ehvKFzY7NwrSiDJg5cY4
	fB1w==
X-Received: by 2002:a05:7300:ec0c:b0:30e:cda8:e37 with SMTP id 5a478bee46e88-30f053c9521mr397911eec.20.1782906459147;
        Wed, 01 Jul 2026 04:47:39 -0700 (PDT)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ee327cea7sm22518169eec.31.2026.07.01.04.47.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Jul 2026 04:47:38 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	sj@kernel.org,
	gutierrez.asier@huawei-partners.com,
	daichaobing@sangfor.com.cn,
	lianux.wang@processmission.com,
	Wang Lian <lianux.mm@gmail.com>
Subject: [PATCH v2 4/5] mm/damon: introduce DAMOS_SPLIT action
Date: Wed,  1 Jul 2026 19:47:15 +0800
Message-ID: <20260701114716.56503-5-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260701114716.56503-1-lianux.mm@gmail.com>
References: <20260701114716.56503-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 69865140012
X-Rspam-User: 
X-Stat-Signature: yex7g69jms8wh7qr53b4ibexr8a5rkh5
X-HE-Tag: 1782906460-833241
X-HE-Meta: U2FsdGVkX18IO0H9LwZQE0ZoVepkVIN2CV48wa9cxBvw8Ef/MW7XUAXHpRvOKYnnUUBzhd9nT/53MBeXqi1oeOL183Z4PfnOHBdP/gwHQccLqAMJkp1oYaBWRALQdhgyQ/bz+tg27Lm6/ghOis10fffFFRTzpQickVP9OFSQZBVL5E9mGHXoM9oWR2Iywj1ZqCbNypFAtzg/Pb2a/S+aLo4Qi4rqOk3zVUynei6vl6fZrpPlWajION/ovJHLAvEI6VE8Y9MHPlstuU1vk9UZ1ypLTPKx4GDvch//Kl/ppx+VQ36r9Ca2N5OCJAhc8PYy7OGpSmTZY6N1pha90Cm8IWEE9B8VKUYvTT1xRCyBeaezfUzx/ArGhMfxb2TZz+wv5wIerraiUAXtIgEfMO2rr66hzK/uXFv/KLprdaXzkoV1wiWiWU5x0BfAHuEaEs3WeKgxOAWNlyhyvX9uv4ELqXFazwsk5ogWuX+eF4stfa3MmttWUHh4zjj2meWmeZSrvLKlZHrpnVNrZguyGXo3tUFTMGdOLVDje5EXKCHRAV3Z3TZ0BGqnmCN7edxJhRQdmwZFxH3cM2ZlKfhx9TSGX555snXfnTD6rh9ZJgXeE74YE/yGnLAbc3x7WWnGQDAhQ9zm5LUMiO1JC2M/ZQaW73/Mr9nGXeaV56RcAWFe1FjQ2NTPICoDHJ6h4QTyJGlgf45s3LWuqk5/52GAnuCupx9pA/oW18jc76KM8IYoTnO858rZR8wSFC6vlVGDp79THfakrrycNR/UzfanxzKpRdY9avMJlnQcO5Rrjdh3Aum6UsNecK+cIGh80cDKGAAAYkdu+AQwNM7JYAm9o002hZvpnf7k3FoYie1P3eeCbq9ghQfz6s9Wym2nNfkViolhRKhfpiaDqWOOlHRFvJjplrtaamBS1JsLajSaWT4qp2ZPt7wRROHiKV701Z4ImwFRla5a4NL7Cg95h3yFZ6r
 Y0CN1lEQ
 E8QCsDQ4h7UbyAV7HU9MBlYOsjqa7fCmURUYQLH9QBq1rAnfUxVjUak2y0MHe96biDa2yNQ9sieRYGw4vJ3/xQNOaGOH0gV8J8DtWI53bKqDASyuW8VXi8lqcc9qfrH5VlCKR13dYzOBzif3UU84RERFWLLTWxCGhfeH2kj14+DvWj+5+Y+tXYF+/bDqRrnRx+gta5mYHGkUQu+KiUGdzIM9Gss89L5hgbD3EA7XwYLKBsfcaGOMXhlsCUgftEom14rkKUVmZU+SOvlSpQuax2y8FkLIBIL/BHHOWf2loD4q03vg0ldghinreNH7AZlBLweiMea5wRqweClehs5BHPZ/XEnCnR7O8EGrah/sIIUJmCqJtHlBb6NLqJza/6eK5nDkL7Kpis0RYIxRDWsk2eUjnpoWzvAV8r7dr+eCKdfTBCVCr1Ari4qqZEFtGayHykP3MpJ8glGDu9QEl6vuyvQ/FHZmeQIBPv5+8AqQpxuXoAfKiWljFwVIr964tF/BucIk/aB+W4bsYIOJj7FLnRIzgOU7M7NCCb8NB7vFBPN9GO/C6lFg7ztHtL39csVj9K5QNjnpPKZV0c8yeyWz8kBoH1wJSguOm/Bx+5A+EOydPmooFND+iyZdEC9wIEHbkOJvYSl4AdB9lMvs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wang Lian <lianux.mm@gmail.com>

Add DAMOS_SPLIT to the damos_action enum for splitting large folios
into smaller mTHP-order folios.  Add a target_order field to struct
damos to specify the desired split order.

Expose the action as "split" through the DAMON sysfs interface with
target_order validation (must be 2..HPAGE_PMD_ORDER-1).

Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.wang@processmission.com>
---
 include/linux/damon.h    |  9 +++++++--
 mm/damon/sysfs-schemes.c | 12 ++++++++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 5a0587556573..30cf4afb212c 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -121,6 +121,7 @@ struct damon_target {
  * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
  * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
  * @DAMOS_COLLAPSE:	Call ``madvise()`` for the region with MADV_COLLAPSE.
+ * @DAMOS_SPLIT:	Split large folios to the target mTHP order.
  * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
  * @DAMOS_LRU_DEPRIO:	Deprioritize the region on its LRU lists.
  * @DAMOS_MIGRATE_HOT:  Migrate the regions prioritizing warmer regions.
@@ -141,6 +142,7 @@ enum damos_action {
 	DAMOS_HUGEPAGE,
 	DAMOS_NOHUGEPAGE,
 	DAMOS_COLLAPSE,
+	DAMOS_SPLIT,
 	DAMOS_LRU_PRIO,
 	DAMOS_LRU_DEPRIO,
 	DAMOS_MIGRATE_HOT,
@@ -573,8 +575,11 @@ struct damos {
 	struct damos_access_pattern pattern;
 	enum damos_action action;
 	/*
-	 * @target_order: target order for mTHP actions (DAMOS_COLLAPSE).
-	 * 0 means system default (PMD order).  Valid: 0, 2..HPAGE_PMD_ORDER.
+	 * @target_order: target mTHP order for DAMOS_COLLAPSE and
+	 * DAMOS_SPLIT.  For COLLAPSE, 0 means PMD order default,
+	 * valid values: 0, 2..HPAGE_PMD_ORDER.  For SPLIT,
+	 * valid values: 2..HPAGE_PMD_ORDER-1; 0 and HPAGE_PMD_ORDER
+	 * are rejected at scheme creation time (defaulting to 2).
 	 */
 	unsigned int target_order;
 	unsigned long apply_interval_us;
diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 735970717048..547252fc8a20 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2293,6 +2293,10 @@ static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
 		.action = DAMOS_COLLAPSE,
 		.name = "collapse",
 	},
+	{
+		.action = DAMOS_SPLIT,
+		.name = "split",
+	},
 	{
 		.action = DAMOS_LRU_PRIO,
 		.name = "lru_prio",
@@ -3048,6 +3052,14 @@ static struct damos *damon_sysfs_mk_scheme(
 			HPAGE_PMD_ORDER, HPAGE_PMD_ORDER);
 		sysfs_scheme->target_order = 0;
 	}
+	if (sysfs_scheme->action == DAMOS_SPLIT &&
+	    (sysfs_scheme->target_order == 0 ||
+	     sysfs_scheme->target_order >= HPAGE_PMD_ORDER)) {
+		pr_warn("DAMON split: target_order %u invalid, need 2..%u. Defaulting to 2.\n",
+			sysfs_scheme->target_order,
+			HPAGE_PMD_ORDER - 1);
+		sysfs_scheme->target_order = 2;
+	}
 	scheme->target_order = sysfs_scheme->target_order;
 
 	err = damos_sysfs_add_quota_score(sysfs_quotas->goals, &scheme->quota);
-- 
2.50.1 (Apple Git-155)


