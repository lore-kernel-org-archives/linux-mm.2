Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8377DE7AD67
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 21:02:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 313096B0088; Thu, 25 Dec 2025 16:02:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C11F6B0089; Thu, 25 Dec 2025 16:02:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BFC76B008A; Thu, 25 Dec 2025 16:02:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05F036B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 16:02:20 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A6318B9BF
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 21:02:19 +0000 (UTC)
X-FDA: 84259216398.22.9B8B322
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id E783216000A
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 21:02:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bDYUj5ye;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766696538; a=rsa-sha256;
	cv=none;
	b=06oBeJGAmjjyjCo5bArCR/bWm9ZKjlem7frpNGpSZMBEna/Gw/Xk9bUuCYrnCM8cISXxWw
	3KmDzWXfYdlSJe2zvyFyWaezw+1GJzJJtD8v6NN4KgoovId0tFp3RmjjmWkVewZ/1WLWO9
	rxD2HxytKNup6MPquSu+82gNKQ5eGU0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bDYUj5ye;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766696538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=HK1KFsrSoLjAVDLeBhBRTR0A1gSVuCCD04dju2KsICs=;
	b=SrHC4N9wChbLQghC5bzlAVuWmvsoujXjwp8KpdTjmst6Hgxyfq+PFLjzIf2m2vQSRx1LiH
	UIhJ7hU/DIEK3KcHCzHHumzMGKCzwLt754+lAKNGLq4epqNZKj2cI+bggXUNzjaHamR4NC
	pOBkKhVBV1rG4s5w6fXtNSYmzxnZ5vc=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b8010b8f078so933814366b.0
        for <linux-mm@kvack.org>; Thu, 25 Dec 2025 13:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766696536; x=1767301336; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HK1KFsrSoLjAVDLeBhBRTR0A1gSVuCCD04dju2KsICs=;
        b=bDYUj5ye6bMcSSjnY71mkIby9obP0xKvb45fMoiM52zjj97gkF7/5sam9hcLe7Aat/
         RKGhdyxH+txWotOU1N0zvaqWyK43bRW4MUwNy9CPdyQ/XwXa2vXZdll3yZAL5ywd9eLk
         03KjE5UpgDrKjWowJ2e5iAgX0g/oQP/IdKLrlfGKrqxGf7I9wMzkC0r4+nsJ3D3GDmDl
         QzQ4UvzRFz/BnGNjmcFyk8hHg0zz2giXlCs8uyjwqFVeiGnMNeQB/Z4NcPD9KB1zal+P
         CLZ4BzOGQJpTSafUMEykZ0Zf2SYlaCrcVNvUgXC26IOUGjzK7Oj/bTqc09uQflE3CfBV
         l75Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766696536; x=1767301336;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HK1KFsrSoLjAVDLeBhBRTR0A1gSVuCCD04dju2KsICs=;
        b=LO8IGxwV3Nv2b2OAj/3umXKgPP0LeRgBMCMfYxnYNUKOWI2BIsCfqSQuM/kOZuVwlY
         aZFElnX9mujM31gQg5LbGY9hHEpAb1KJ1DV4Dn8hNCGZacaYNx7IIFpl0trcbq3fGulF
         sjRLJ7Hvja7sZTia8s993g4PSiw1HxL/XQKmT2HxBB0XJxYOK5Ww0KBIBDFEn0eQiSif
         Z8i+YzZeyJRNqwc/hTuRr3Lz7LWff776fUOzITpwDXIrQQVFNnotWbGoJxPalCK7l5dy
         aqu/XPVNJOz8zVLlIq2nUlJGney+Fd9gG315HqtPtvBu7FLVluF9YqQoMmpFqonZzkec
         OqNg==
X-Gm-Message-State: AOJu0Yz6czOX4edZclTxBPo4MyM4oqT9ouYGMmJBAPabzyRmZSL2vv0b
	7I3hrSwcPXM4ZWL3J5gnQxxZ0Fk9Uh/f07/QP9HKdY7WkyElETxUI7Pe
X-Gm-Gg: AY/fxX7GnV6WiF4bijMTGsvGcsqmDuzqoBSrLtd8hh+gXU5+VxNGknQzb0t/62pdtkh
	TE0NDizZ2lj+YEfQtrOEEeWapANqLr6CtPB/2cWElc2vNFjGZIKoO6wO2efkGSmM+pCYQlj1/y3
	OyuExQFNoIeGrRTnQdZaWKigpoCwSUoxHzk5c3g1mmYsIObu4DTIi99sUgz5uq1b1SmUAi+u3LG
	QnXWoypVwl0JP6EzmuGcLI3hfZ5wcuCHKIgXJU58ou9lO6y2g2uFR2tRMwsG91hr6Q3mDv3we/0
	1PnG2qAEpXNdlnlA7Nmz0AwXBoL5Bq44WPzCU9EpiCbioXQZ4uQy45b+90BrxBouOFzyLbV+8uA
	5PlJaZUJWV3iqO6+8KV0d6foMZugCefljK/t8Nz8F4ssmXa793k81d6+zL3Jrj6XEO2K3ZNIasJ
	7MsA1At5PxGQ==
X-Google-Smtp-Source: AGHT+IFE0fXZSfsGedKKzTyPaJyBe64lfAtcsceZQxR/L6ZmPQRO40nimOumzUnhr3GoK7GgI2xcSQ==
X-Received: by 2002:a17:907:db03:b0:b7c:fe7c:e383 with SMTP id a640c23a62f3a-b8036f5ad65mr2229450566b.22.1766696535923;
        Thu, 25 Dec 2025 13:02:15 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037ae2de9sm2219117666b.26.2025.12.25.13.02.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Dec 2025 13:02:15 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: [Patch v2] mm/vmstat: remove unused node and zone state helpers
Date: Thu, 25 Dec 2025 21:02:13 +0000
Message-Id: <20251225210213.2553-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E783216000A
X-Stat-Signature: dbdh4bkn3dnzranqie3hsx58439rhgfx
X-HE-Tag: 1766696537-582866
X-HE-Meta: U2FsdGVkX18mt94qj5EFvp6JfA9iI3iDuqaSLlw5QJDE166vVsApazZUU4bHdlaE3FwW+I/zcNXTZyj5qTOhgWbiAYMGzqDYW3goBOZT9JtYWqRGZQ+zj5L43irUnTFpbljyTaOYqgTY9a/56765X3HZJ83NrJ8ZAtlA6EZW0hKzC9N4zyV/CPpNduZb5oF4sXwhjLapjlai8sOWajllXC6v+VcBnsandaFVLU1hU0b5JHXoIZJ1Jmyv25GOQZtq69xB3kXxm0lvPurwXjxJk2jZW4ar2rKTMiU1BoflxKF7kZj/wjUfcg5FDJpM+fj+oc2d2efruCwycFSp8NHpMeOLyxWn42NbxcjgWxJwq/YpJWAOHzln+Wseg2PZ2a62xrnbJCSgQ6vu/WLBrHEP1VLbrxS06MEorLOuky0QT+cgm7LJnXTKkC+1fBK5/3ruWzAMWI2HKtwHGrX7JmhpJ/Tyn6tQDcE8QcgktMRtbF1abRAebkaBU7f05yG8sf0BMCN38kpc++HmXDrmYsGxaTfKPejVd1r7NCSkiG3oHjxrYoCtwMUm1/wai516T579M/P1ZHoqeNu1Gks+bAWe+PhQ/9l6S4bXQQamO5AFMoyU47GnUPGb/OKS5kdbLb/fw1fWXkulbB5LHPq7DBznAvR8RmQ1RSajxPLGgUWhX/HXunHeB6Ghl8XHWlI5V4SKvHi+bB0+eqpYpwpTm1dz5/VKCI22jyeBtxBczIEIGoGklLqP3W0EPJu+bJBqpfRW10PHhIxSNXf9AkQ7Or5729c1frpeAQvVhrp0f0L7K17nVkZx6QhBIp6/9kYUBpy3TKNoc3pzCQgXIR4ooPwbTsMCi7OFjR3J0oQkpwnslhHhvYJKVBqN6x0HmT+hPS/DWdVGues1/vTwMxfdwPgd9edPX85d7q7C9vu2/cWcDs449OmnalelXQFMp2VbG7di6KhgMS9Vgnh7SYym6g1
 vwabjsss
 SQNRCN7rBFMbadft+f/Yn7854jVzXFYff18FjG+STSTxgG+gejfWi3XOVKPQCllKxjgLM/bfIhtiRPwmOvSWHXuZbO414eymZXVwsiaIhpcdb744gSNnG/DR84s2LWYElEa0AGKqkgT7AQax0mKmIgwHCaPuYwywVYaVXRPZRmMpYB8z55fmfMslU/n4pwdZrpmoLHkwtIYZSVlm6pZmf46Klhgf5FpRyLY+wIqIy+3WE8/+WeWHJHiguYsECruR6bw5EGV1vNyeSxzP/xoKG1WI6gOzyoLEeDVpSzMOEvPBOQVG5sPKA3H0rA8u7DGyagqjpHKEodgWC1puZqgmVSEEqXk2IFVC7tYRog7PhEO0QfKYgHGrYaF6eyorq2AQppHktQPvfhzhhoIXvWx9D2Q5FPXPzEWGtXqI8Pe9radQMYzwS0SvzgmOjtkU9EVgKglQDBapVvHX4ZC6vp1KWZbWgwtgmxsar58+Z74gpH/AKDK2uF6Qo/8ZIxIwhRb8EnI8dYf3zRuwoWZTcZbn9zeThoSZKI5LH9HCsh/WlQw2ph5mvSFk1JB8uEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several helper functions for managing node and zone states have become
obsolete and no longer have any callers within the kernel.

  inc_node_state()
  inc_zone_state()
  dec_zone_state()

This commit removes the dead code.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/vmstat.h |  6 ------
 mm/vmstat.c            | 15 ---------------
 2 files changed, 21 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 3398a345bda8..cf559e2ce1d4 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -286,10 +286,8 @@ void mod_node_page_state(struct pglist_data *, enum node_stat_item, long);
 void inc_node_page_state(struct page *, enum node_stat_item);
 void dec_node_page_state(struct page *, enum node_stat_item);
 
-extern void inc_node_state(struct pglist_data *, enum node_stat_item);
 extern void __inc_zone_state(struct zone *, enum zone_stat_item);
 extern void __inc_node_state(struct pglist_data *, enum node_stat_item);
-extern void dec_zone_state(struct zone *, enum zone_stat_item);
 extern void __dec_zone_state(struct zone *, enum zone_stat_item);
 extern void __dec_node_state(struct pglist_data *, enum node_stat_item);
 
@@ -394,10 +392,6 @@ static inline void __dec_node_page_state(struct page *page,
 #define dec_node_page_state __dec_node_page_state
 #define mod_node_page_state __mod_node_page_state
 
-#define inc_zone_state __inc_zone_state
-#define inc_node_state __inc_node_state
-#define dec_zone_state __dec_zone_state
-
 #define set_pgdat_percpu_threshold(pgdat, callback) { }
 
 static inline void refresh_zone_stat_thresholds(void) { }
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 090b5c5294b9..16b7cb24d411 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -671,11 +671,6 @@ void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
 }
 EXPORT_SYMBOL(mod_node_page_state);
 
-void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
-{
-	mod_node_state(pgdat, item, 1, 1);
-}
-
 void inc_node_page_state(struct page *page, enum node_stat_item item)
 {
 	mod_node_state(page_pgdat(page), item, 1, 1);
@@ -724,16 +719,6 @@ void dec_zone_page_state(struct page *page, enum zone_stat_item item)
 }
 EXPORT_SYMBOL(dec_zone_page_state);
 
-void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__inc_node_state(pgdat, item);
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL(inc_node_state);
-
 void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
 					long delta)
 {
-- 
2.34.1


