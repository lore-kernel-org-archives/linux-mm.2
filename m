Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96FA2D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 05:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F06A96B0007; Mon, 15 Dec 2025 00:47:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE456B0008; Mon, 15 Dec 2025 00:47:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD466B000A; Mon, 15 Dec 2025 00:47:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB5EF6B0007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:47:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 605A31A0DAF
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:47:39 +0000 (UTC)
X-FDA: 84220623438.29.8C7BD75
Received: from mail-pl1-f193.google.com (mail-pl1-f193.google.com [209.85.214.193])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5756320002
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:47:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=VEwyMk4E;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.193 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765777657; a=rsa-sha256;
	cv=none;
	b=maBtYE/5NhoiTSl2ra3BcxMcZ1iE+0oV89g4lt6XQ0WIZdMnDnFojTP0Kyfg1JGKRgjmso
	QZz8FmC/RI11F36q5E2OgJhedmrOS+gOhezpOpjM0QYXXbhrs7ac9a/MMXaOOvRNMSUd/c
	4iB6nQkkNgxQNpyRalop+tgQncQ8FnY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=VEwyMk4E;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.193 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765777657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JD4ByuAVTaWhlyQJK6OxCvRV9wbLq8nBroY+7NCKsuY=;
	b=Zcdse5/LDnYO26Acs2AyZtnniF7vxh5CH0hDSQLgSZ9DN34ndENoKsU/xbYctpyak4t/k2
	FZx/N9AHzAYr+ua5+UEkqEvJ1/eB5YezDlvW0M5LyofZmbjXDLcDMbI0XKHCqEqy+XAj1T
	kmG9lNvSxM2Jt71RSEULxK87o/09GT8=
Received: by mail-pl1-f193.google.com with SMTP id d9443c01a7336-2a0bb2f093aso10101725ad.3
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 21:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1765777656; x=1766382456; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JD4ByuAVTaWhlyQJK6OxCvRV9wbLq8nBroY+7NCKsuY=;
        b=VEwyMk4EbhljnaHYGqcb/C/ekW2ho1+/hCK5v009/0sFjuFxPSvAmr233odYb/927w
         Ac+Y84K3/9pv/KxMW39CCLefcRVpHSMPIcKoCsS7q0ACjpFLyKlrW1ssILwpq9l/0axc
         YerVmOAaJYLM6NsT06X915miAPIZSVxlewZy0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765777656; x=1766382456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JD4ByuAVTaWhlyQJK6OxCvRV9wbLq8nBroY+7NCKsuY=;
        b=he82W1HniEBOuJQdTGFGeC6yTpvlDw+OdtlS0mcwheLEhJ1ifur2ZE5T2lqbCirPbB
         0M20opHdX2IoQ92rtIugw5anY9aQXj6SS+BWFQSU+8OLxknjcEwIE46hglfl9b90Q03u
         5TFOrpzvLmNWw59PdWLUqMQZgny4RYl/rwwH7d7zfN1+fm+S9SjjYKmQe9Gn5+He0HwW
         6IsEg/NhE+lwWuqqKKgn8jr+3D8qpRX7dmfQm/Nsmrp6EBjTpNanBEEAEcJNW/igUTgn
         R2Q82tTvDqEN2Ce50faT/eh5qSBj3NrXUdWc1CW3uPBnuTfQEkWhSGgO7VfRw+55XziL
         haiw==
X-Forwarded-Encrypted: i=1; AJvYcCXaDedpEqiUVbakgv/IVoIoDiibBZ4Wld/+RYfitPjiCk12Z7kuPnArcH9L35qv8M8EcGErZUTbZw==@kvack.org
X-Gm-Message-State: AOJu0YxdU+QrfZhvpSrPUVmO6VdQqlW/dQI4OZ5bmuVJA2fO/xSWB3B6
	AdYAYCEStSF5C/XV8cTt1pQOTa+PLjZ3ufmkdQjTwGG/09wL2oLKIyWrhTWZZZ5hkg==
X-Gm-Gg: AY/fxX58AY5HnVtNtJ6K6cLtbyBXrEZr7jqmVIy0cXgDmy1grxRfO2irB6mfoOKUd8h
	irSMC/d1/CVjYbjemX4SUV5dyULY81N9A4yhi9gWRdgDet9aIewgdg4PYdQm/NeiaM6hU9wDdC3
	KaT6O64f9V1fAOClaE+O3wOAXgydZCmJRvAO/3lRWWS5ZCQcdVltEHQcyqoxxuXSCsoItHERZ+V
	dx24WlBv1Nw4S1XCs0B6RWP1PxIG7Z/2MZgq4Eto2ZoHjS/9udMO0UuAwijJgZMWjPZNOix/Zj4
	dSQb6MhnONflurpK+qZENwhxQ80FeOYB5KQ0jscVY9wBGXszpqDGUJV35EK4m4vgPICuqvCQBQ1
	fyIUJkaMVKUMnGxrYAqp51eUIsm4I9QZD5e/nFkzii2AsQufUuYqMFNHfGmrQCe34I7iDdNnvyy
	vueqXoCJZSqJfimWm3jOnWuM7gzIS4wN/3ClvGgvTObNsNCm7HITiRfIX3vpd5m32HG7Q46Bmwa
	g==
X-Google-Smtp-Source: AGHT+IHmFAV4lCoyU3DN1IQSULIhdvPiJOOOe5ttXwVRsJ7H5f5Ps9fUhfdNvyTBHZRKJvyGsdxMRw==
X-Received: by 2002:a17:903:32c4:b0:2a0:945d:a195 with SMTP id d9443c01a7336-2a0945da490mr71099135ad.45.1765777656088;
        Sun, 14 Dec 2025 21:47:36 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:88fa:c762:fe19:6db7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a0bb39db53sm36391945ad.11.2025.12.14.21.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 21:47:35 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	David Stevens <stevensd@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 2/3] zram: rename internal slot API
Date: Mon, 15 Dec 2025 14:47:12 +0900
Message-ID: <775a0b1a0ace5caf1f05965d8bc637c1192820fa.1765775954.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
In-Reply-To: <d7c0b48450c70eeb5fd8acd6ecd23593f30dbf1f.1765775954.git.senozhatsky@chromium.org>
References: <d7c0b48450c70eeb5fd8acd6ecd23593f30dbf1f.1765775954.git.senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5756320002
X-Rspamd-Server: rspam10
X-Stat-Signature: s8tc3onm5xrmmw8i3ib1y3s4t5ngo1uo
X-HE-Tag: 1765777657-728434
X-HE-Meta: U2FsdGVkX19zACdFNTkBw6S8omMAsC6mQhZpTjvCb8fXrlyRRDcupYq05Qm/CiojqYtdsmalhZWVHqaTEhVVPc6pq9KvAG9O9Zh6ofJyFTGu44zstLzCMzjOS3981fxWiOU7tQi0WIGMo6LXH+pC+TsMe+G4GK2Tm3vhX57Z4Ht+tor248C1CyRO+W79oIYxiGtEBKoMmbB92oPhdKZHrCnpjG3zyqYv8quO4ImODuYrvnHKa0bGHPq4fKHjaQof9YuTGe0jEaybMocioLXuKxA+wZlExUlOg5Nq8ouNbJPCEwBaplMywmXXYNZY6IFMTP7Cm0PstvwgRWmSRx3ck+2FEhNQAIwuYMwUTASIAFFbhNpxUUfI71i/WRZ/GBfkhR0o4hkO4BafvTcuf20juTRk1/BQNOBxprTwYgubaQHVxgP4qZBe9VJZn7RBa0IlgCzg7LyHma51JTWUo0NPZEq0M/WRmXiWdtvN/94ElMXgm8mLD+ZXYpgCVodTdeTIT3xSLiFZUt0r33gRHwGXY6lxr7Qf51YIUPuBfeEiL2jLfhNtGKpKsrrSNDVkQ0tuASLkbdZyCjrRm2+wj3yIyoxYr4YrsiPpMQ0xgrHN25aInUSR2aGVToCl4OQk+efbERxg89PDerGrNukC8ZI5AjHp6KUwFw+H4LIADq9hi/aciavKStNUxMvTiGARi/eEL/w6CTXoLO1JFVVlmrtvF75o9Pmquu2CWAXcIgc5lRFN2SPbgrVcFSzmiH21NVltX1scdflrhYhlhV8yEwvttBTuWTQisP2TvypCP1ykJCIDCGUHLsBpGKvFUCPgI9WqtFmzNTy2NRX3eZd5ORLb87bVSWRjc6ETf5Nzf+dRL554S/4MbXFglitRdp/fKocBT2xTxmPXlAy5la+kTYi8xrg03j0fxA0PrUwNhHSIy68fFfkS6ISU6dtahbOr1I+4dsUvYIg32bXQbkP2jN0
 BnN9AzRf
 A1wy69J6L3jQ09Y7BqUMcWwBVx8SP95kAzOzQYadPjQOFMGehf3YOH4LQkzWqx+bJhpcJRMc/qS/rCijW19yBgTOGvzMeVKV15019rX2KgB/T7JRiS/yc2m0QHRseJLxYuH25Oo7U1zawBT0YH1gEHGVEQ1Vefefta1C3HTEvHuAcjlmxwgPM18Noc23ECS0pR33GQPX1D6S+8avWW5jplqbt7aPr8aAK6L0o7FkwUU10qtjmssASIIhkrQbx0cbuvtmSVk7AypFceJJxjci2J9uT/TD8ZP+aEYOvjE+iagNTYAUHwMvBnkRJsRFJg4t2rWtmyTqNfokBzSuH13W24ZXFn143WrammtjxoxKvCkjDuhkJVawUcNvHvt6ceQNGrQPjVLdqsicb/2k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have a somewhat confusing internal API naming.  E.g.
the following code:

	zram_slot_lock()
	if (zram_allocated())
		zram_set_flag()
	zram_slot_unlock()

may look like it does something on zram device level, but in
fact it tests and sets slot entry flags, not the device ones.

Rename API to explicitly distinguish functions that operate on
the slot level from functions that operate on the zram device
level.

While at it, fixup some coding styles.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 363 +++++++++++++++++-----------------
 1 file changed, 182 insertions(+), 181 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 65f99ff3e2e5..f00f3d22d5e3 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -56,10 +56,10 @@ static size_t huge_class_size;
 
 static const struct block_device_operations zram_devops;
 
-static void zram_slot_free(struct zram *zram, u32 index);
+static void slot_free(struct zram *zram, u32 index);
 #define slot_dep_map(zram, index) (&(zram)->table[(index)].dep_map)
 
-static void zram_slot_lock_init(struct zram *zram, u32 index)
+static void slot_lock_init(struct zram *zram, u32 index)
 {
 	static struct lock_class_key __key;
 
@@ -79,7 +79,7 @@ static void zram_slot_lock_init(struct zram *zram, u32 index)
  * 4) Use TRY lock variant when in atomic context
  *    - must check return value and handle locking failers
  */
-static __must_check bool zram_slot_trylock(struct zram *zram, u32 index)
+static __must_check bool slot_trylock(struct zram *zram, u32 index)
 {
 	unsigned long *lock = &zram->table[index].__lock;
 
@@ -92,7 +92,7 @@ static __must_check bool zram_slot_trylock(struct zram *zram, u32 index)
 	return false;
 }
 
-static void zram_slot_lock(struct zram *zram, u32 index)
+static void slot_lock(struct zram *zram, u32 index)
 {
 	unsigned long *lock = &zram->table[index].__lock;
 
@@ -101,7 +101,7 @@ static void zram_slot_lock(struct zram *zram, u32 index)
 	lock_acquired(slot_dep_map(zram, index), _RET_IP_);
 }
 
-static void zram_slot_unlock(struct zram *zram, u32 index)
+static void slot_unlock(struct zram *zram, u32 index)
 {
 	unsigned long *lock = &zram->table[index].__lock;
 
@@ -119,51 +119,80 @@ static inline struct zram *dev_to_zram(struct device *dev)
 	return (struct zram *)dev_to_disk(dev)->private_data;
 }
 
-static unsigned long zram_get_handle(struct zram *zram, u32 index)
+static unsigned long get_slot_handle(struct zram *zram, u32 index)
 {
 	return zram->table[index].handle;
 }
 
-static void zram_set_handle(struct zram *zram, u32 index, unsigned long handle)
+static void set_slot_handle(struct zram *zram, u32 index, unsigned long handle)
 {
 	zram->table[index].handle = handle;
 }
 
-static bool zram_test_flag(struct zram *zram, u32 index,
+static bool test_slot_flag(struct zram *zram, u32 index,
 			   enum zram_pageflags flag)
 {
 	return zram->table[index].attr.flags & BIT(flag);
 }
 
-static void zram_set_flag(struct zram *zram, u32 index,
+static void set_slot_flag(struct zram *zram, u32 index,
 			  enum zram_pageflags flag)
 {
 	zram->table[index].attr.flags |= BIT(flag);
 }
 
-static void zram_clear_flag(struct zram *zram, u32 index,
+static void clear_slot_flag(struct zram *zram, u32 index,
 			    enum zram_pageflags flag)
 {
 	zram->table[index].attr.flags &= ~BIT(flag);
 }
 
-static size_t zram_get_obj_size(struct zram *zram, u32 index)
+static size_t get_slot_size(struct zram *zram, u32 index)
 {
 	return zram->table[index].attr.flags & (BIT(ZRAM_FLAG_SHIFT) - 1);
 }
 
-static void zram_set_obj_size(struct zram *zram, u32 index, size_t size)
+static void set_slot_size(struct zram *zram, u32 index, size_t size)
 {
 	unsigned long flags = zram->table[index].attr.flags >> ZRAM_FLAG_SHIFT;
 
 	zram->table[index].attr.flags = (flags << ZRAM_FLAG_SHIFT) | size;
 }
 
-static inline bool zram_allocated(struct zram *zram, u32 index)
+static inline bool slot_allocated(struct zram *zram, u32 index)
 {
-	return zram_get_obj_size(zram, index) ||
-			zram_test_flag(zram, index, ZRAM_SAME) ||
-			zram_test_flag(zram, index, ZRAM_WB);
+	return get_slot_size(zram, index) ||
+		test_slot_flag(zram, index, ZRAM_SAME) ||
+		test_slot_flag(zram, index, ZRAM_WB);
+}
+
+static inline void set_slot_comp_priority(struct zram *zram, u32 index,
+					  u32 prio)
+{
+	prio &= ZRAM_COMP_PRIORITY_MASK;
+	/*
+	 * Clear previous priority value first, in case if we recompress
+	 * further an already recompressed page
+	 */
+	zram->table[index].attr.flags &= ~(ZRAM_COMP_PRIORITY_MASK <<
+					   ZRAM_COMP_PRIORITY_BIT1);
+	zram->table[index].attr.flags |= (prio << ZRAM_COMP_PRIORITY_BIT1);
+}
+
+static inline u32 get_slot_comp_priority(struct zram *zram, u32 index)
+{
+	u32 prio = zram->table[index].attr.flags >> ZRAM_COMP_PRIORITY_BIT1;
+
+	return prio & ZRAM_COMP_PRIORITY_MASK;
+}
+
+static void mark_slot_accessed(struct zram *zram, u32 index)
+{
+	clear_slot_flag(zram, index, ZRAM_IDLE);
+	clear_slot_flag(zram, index, ZRAM_PP_SLOT);
+#ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
+	zram->table[index].attr.ac_time = ktime_get_boottime();
+#endif
 }
 
 static inline void update_used_max(struct zram *zram, const unsigned long pages)
@@ -200,34 +229,6 @@ static inline bool is_partial_io(struct bio_vec *bvec)
 }
 #endif
 
-static inline void zram_set_priority(struct zram *zram, u32 index, u32 prio)
-{
-	prio &= ZRAM_COMP_PRIORITY_MASK;
-	/*
-	 * Clear previous priority value first, in case if we recompress
-	 * further an already recompressed page
-	 */
-	zram->table[index].attr.flags &= ~(ZRAM_COMP_PRIORITY_MASK <<
-					   ZRAM_COMP_PRIORITY_BIT1);
-	zram->table[index].attr.flags |= (prio << ZRAM_COMP_PRIORITY_BIT1);
-}
-
-static inline u32 zram_get_priority(struct zram *zram, u32 index)
-{
-	u32 prio = zram->table[index].attr.flags >> ZRAM_COMP_PRIORITY_BIT1;
-
-	return prio & ZRAM_COMP_PRIORITY_MASK;
-}
-
-static void zram_accessed(struct zram *zram, u32 index)
-{
-	zram_clear_flag(zram, index, ZRAM_IDLE);
-	zram_clear_flag(zram, index, ZRAM_PP_SLOT);
-#ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
-	zram->table[index].attr.ac_time = (u32)ktime_get_boottime_seconds();
-#endif
-}
-
 #if defined CONFIG_ZRAM_WRITEBACK || defined CONFIG_ZRAM_MULTI_COMP
 struct zram_pp_slot {
 	unsigned long		index;
@@ -263,9 +264,9 @@ static void release_pp_slot(struct zram *zram, struct zram_pp_slot *pps)
 {
 	list_del_init(&pps->entry);
 
-	zram_slot_lock(zram, pps->index);
-	zram_clear_flag(zram, pps->index, ZRAM_PP_SLOT);
-	zram_slot_unlock(zram, pps->index);
+	slot_lock(zram, pps->index);
+	clear_slot_flag(zram, pps->index, ZRAM_PP_SLOT);
+	slot_unlock(zram, pps->index);
 
 	kfree(pps);
 }
@@ -304,10 +305,10 @@ static bool place_pp_slot(struct zram *zram, struct zram_pp_ctl *ctl,
 	INIT_LIST_HEAD(&pps->entry);
 	pps->index = index;
 
-	bid = zram_get_obj_size(zram, pps->index) / PP_BUCKET_SIZE_RANGE;
+	bid = get_slot_size(zram, pps->index) / PP_BUCKET_SIZE_RANGE;
 	list_add(&pps->entry, &ctl->pp_buckets[bid]);
 
-	zram_set_flag(zram, pps->index, ZRAM_PP_SLOT);
+	set_slot_flag(zram, pps->index, ZRAM_PP_SLOT);
 	return true;
 }
 
@@ -436,11 +437,11 @@ static void mark_idle(struct zram *zram, ktime_t cutoff)
 		 *
 		 * And ZRAM_WB slots simply cannot be ZRAM_IDLE.
 		 */
-		zram_slot_lock(zram, index);
-		if (!zram_allocated(zram, index) ||
-		    zram_test_flag(zram, index, ZRAM_WB) ||
-		    zram_test_flag(zram, index, ZRAM_SAME)) {
-			zram_slot_unlock(zram, index);
+		slot_lock(zram, index);
+		if (!slot_allocated(zram, index) ||
+		    test_slot_flag(zram, index, ZRAM_WB) ||
+		    test_slot_flag(zram, index, ZRAM_SAME)) {
+			slot_unlock(zram, index);
 			continue;
 		}
 
@@ -449,10 +450,10 @@ static void mark_idle(struct zram *zram, ktime_t cutoff)
 			ktime_after(cutoff, zram->table[index].attr.ac_time);
 #endif
 		if (is_idle)
-			zram_set_flag(zram, index, ZRAM_IDLE);
+			set_slot_flag(zram, index, ZRAM_IDLE);
 		else
-			zram_clear_flag(zram, index, ZRAM_IDLE);
-		zram_slot_unlock(zram, index);
+			clear_slot_flag(zram, index, ZRAM_IDLE);
+		slot_unlock(zram, index);
 	}
 }
 
@@ -933,7 +934,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 	}
 
 	atomic64_inc(&zram->stats.bd_writes);
-	zram_slot_lock(zram, index);
+	slot_lock(zram, index);
 	/*
 	 * We release slot lock during writeback so slot can change under us:
 	 * slot_free() or slot_free() and zram_write_page(). In both cases
@@ -941,7 +942,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 	 * set ZRAM_PP_SLOT on such slots until current post-processing
 	 * finishes.
 	 */
-	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT)) {
+	if (!test_slot_flag(zram, index, ZRAM_PP_SLOT)) {
 		zram_release_bdev_block(zram, req->blk_idx);
 		goto out;
 	}
@@ -951,26 +952,26 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 		 * ZRAM_WB slots get freed, we need to preserve data required
 		 * for read decompression.
 		 */
-		size = zram_get_obj_size(zram, index);
-		prio = zram_get_priority(zram, index);
-		huge = zram_test_flag(zram, index, ZRAM_HUGE);
+		size = get_slot_size(zram, index);
+		prio = get_slot_comp_priority(zram, index);
+		huge = test_slot_flag(zram, index, ZRAM_HUGE);
 	}
 
-	zram_slot_free(zram, index);
-	zram_set_flag(zram, index, ZRAM_WB);
-	zram_set_handle(zram, index, req->blk_idx);
+	slot_free(zram, index);
+	set_slot_flag(zram, index, ZRAM_WB);
+	set_slot_handle(zram, index, req->blk_idx);
 
 	if (zram->wb_compressed) {
 		if (huge)
-			zram_set_flag(zram, index, ZRAM_HUGE);
-		zram_set_obj_size(zram, index, size);
-		zram_set_priority(zram, index, prio);
+			set_slot_flag(zram, index, ZRAM_HUGE);
+		set_slot_size(zram, index, size);
+		set_slot_comp_priority(zram, index, prio);
 	}
 
 	atomic64_inc(&zram->stats.pages_stored);
 
 out:
-	zram_slot_unlock(zram, index);
+	slot_unlock(zram, index);
 	return 0;
 }
 
@@ -1091,14 +1092,14 @@ static int zram_writeback_slots(struct zram *zram,
 		}
 
 		index = pps->index;
-		zram_slot_lock(zram, index);
+		slot_lock(zram, index);
 		/*
 		 * scan_slots() sets ZRAM_PP_SLOT and releases slot lock, so
 		 * slots can change in the meantime. If slots are accessed or
 		 * freed they lose ZRAM_PP_SLOT flag and hence we don't
 		 * post-process them.
 		 */
-		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
+		if (!test_slot_flag(zram, index, ZRAM_PP_SLOT))
 			goto next;
 		if (zram->wb_compressed)
 			err = read_from_zspool_raw(zram, req->page, index);
@@ -1106,7 +1107,7 @@ static int zram_writeback_slots(struct zram *zram,
 			err = read_from_zspool(zram, req->page, index);
 		if (err)
 			goto next;
-		zram_slot_unlock(zram, index);
+		slot_unlock(zram, index);
 
 		/*
 		 * From now on pp-slot is owned by the req, remove it from
@@ -1128,7 +1129,7 @@ static int zram_writeback_slots(struct zram *zram,
 		continue;
 
 next:
-		zram_slot_unlock(zram, index);
+		slot_unlock(zram, index);
 		release_pp_slot(zram, pps);
 	}
 
@@ -1221,27 +1222,27 @@ static int scan_slots_for_writeback(struct zram *zram, u32 mode,
 	while (index < hi) {
 		bool ok = true;
 
-		zram_slot_lock(zram, index);
-		if (!zram_allocated(zram, index))
+		slot_lock(zram, index);
+		if (!slot_allocated(zram, index))
 			goto next;
 
-		if (zram_test_flag(zram, index, ZRAM_WB) ||
-		    zram_test_flag(zram, index, ZRAM_SAME))
+		if (test_slot_flag(zram, index, ZRAM_WB) ||
+		    test_slot_flag(zram, index, ZRAM_SAME))
 			goto next;
 
 		if (mode & IDLE_WRITEBACK &&
-		    !zram_test_flag(zram, index, ZRAM_IDLE))
+		    !test_slot_flag(zram, index, ZRAM_IDLE))
 			goto next;
 		if (mode & HUGE_WRITEBACK &&
-		    !zram_test_flag(zram, index, ZRAM_HUGE))
+		    !test_slot_flag(zram, index, ZRAM_HUGE))
 			goto next;
 		if (mode & INCOMPRESSIBLE_WRITEBACK &&
-		    !zram_test_flag(zram, index, ZRAM_INCOMPRESSIBLE))
+		    !test_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE))
 			goto next;
 
 		ok = place_pp_slot(zram, ctl, index);
 next:
-		zram_slot_unlock(zram, index);
+		slot_unlock(zram, index);
 		if (!ok)
 			break;
 		index++;
@@ -1369,22 +1370,22 @@ static int decompress_bdev_page(struct zram *zram, struct page *page, u32 index)
 	int ret, prio;
 	void *src;
 
-	zram_slot_lock(zram, index);
+	slot_lock(zram, index);
 	/* Since slot was unlocked we need to make sure it's still ZRAM_WB */
-	if (!zram_test_flag(zram, index, ZRAM_WB)) {
-		zram_slot_unlock(zram, index);
+	if (!test_slot_flag(zram, index, ZRAM_WB)) {
+		slot_unlock(zram, index);
 		/* We read some stale data, zero it out */
 		memset_page(page, 0, 0, PAGE_SIZE);
 		return -EIO;
 	}
 
-	if (zram_test_flag(zram, index, ZRAM_HUGE)) {
-		zram_slot_unlock(zram, index);
+	if (test_slot_flag(zram, index, ZRAM_HUGE)) {
+		slot_unlock(zram, index);
 		return 0;
 	}
 
-	size = zram_get_obj_size(zram, index);
-	prio = zram_get_priority(zram, index);
+	size = get_slot_size(zram, index);
+	prio = get_slot_comp_priority(zram, index);
 
 	zstrm = zcomp_stream_get(zram->comps[prio]);
 	src = kmap_local_page(page);
@@ -1394,7 +1395,7 @@ static int decompress_bdev_page(struct zram *zram, struct page *page, u32 index)
 		copy_page(src, zstrm->local_copy);
 	kunmap_local(src);
 	zcomp_stream_put(zstrm);
-	zram_slot_unlock(zram, index);
+	slot_unlock(zram, index);
 
 	return ret;
 }
@@ -1584,8 +1585,8 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 	for (index = *ppos; index < nr_pages; index++) {
 		int copied;
 
-		zram_slot_lock(zram, index);
-		if (!zram_allocated(zram, index))
+		slot_lock(zram, index);
+		if (!slot_allocated(zram, index))
 			goto next;
 
 		ts = ktime_to_timespec64(zram->table[index].attr.ac_time);
@@ -1593,22 +1594,22 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 			"%12zd %12lld.%06lu %c%c%c%c%c%c\n",
 			index, (s64)ts.tv_sec,
 			ts.tv_nsec / NSEC_PER_USEC,
-			zram_test_flag(zram, index, ZRAM_SAME) ? 's' : '.',
-			zram_test_flag(zram, index, ZRAM_WB) ? 'w' : '.',
-			zram_test_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
-			zram_test_flag(zram, index, ZRAM_IDLE) ? 'i' : '.',
-			zram_get_priority(zram, index) ? 'r' : '.',
-			zram_test_flag(zram, index,
+			test_slot_flag(zram, index, ZRAM_SAME) ? 's' : '.',
+			test_slot_flag(zram, index, ZRAM_WB) ? 'w' : '.',
+			test_slot_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
+			test_slot_flag(zram, index, ZRAM_IDLE) ? 'i' : '.',
+			get_slot_comp_priority(zram, index) ? 'r' : '.',
+			test_slot_flag(zram, index,
 				       ZRAM_INCOMPRESSIBLE) ? 'n' : '.');
 
 		if (count <= copied) {
-			zram_slot_unlock(zram, index);
+			slot_unlock(zram, index);
 			break;
 		}
 		written += copied;
 		count -= copied;
 next:
-		zram_slot_unlock(zram, index);
+		slot_unlock(zram, index);
 		*ppos += 1;
 	}
 
@@ -1976,7 +1977,7 @@ static void zram_meta_free(struct zram *zram, u64 disksize)
 
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < num_pages; index++)
-		zram_slot_free(zram, index);
+		slot_free(zram, index);
 
 	zs_destroy_pool(zram->mem_pool);
 	vfree(zram->table);
@@ -2003,12 +2004,12 @@ static bool zram_meta_alloc(struct zram *zram, u64 disksize)
 		huge_class_size = zs_huge_class_size(zram->mem_pool);
 
 	for (index = 0; index < num_pages; index++)
-		zram_slot_lock_init(zram, index);
+		slot_lock_init(zram, index);
 
 	return true;
 }
 
-static void zram_slot_free(struct zram *zram, u32 index)
+static void slot_free(struct zram *zram, u32 index)
 {
 	unsigned long handle;
 
@@ -2016,19 +2017,19 @@ static void zram_slot_free(struct zram *zram, u32 index)
 	zram->table[index].attr.ac_time = 0;
 #endif
 
-	zram_clear_flag(zram, index, ZRAM_IDLE);
-	zram_clear_flag(zram, index, ZRAM_INCOMPRESSIBLE);
-	zram_clear_flag(zram, index, ZRAM_PP_SLOT);
-	zram_set_priority(zram, index, 0);
+	clear_slot_flag(zram, index, ZRAM_IDLE);
+	clear_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE);
+	clear_slot_flag(zram, index, ZRAM_PP_SLOT);
+	set_slot_comp_priority(zram, index, 0);
 
-	if (zram_test_flag(zram, index, ZRAM_HUGE)) {
-		zram_clear_flag(zram, index, ZRAM_HUGE);
+	if (test_slot_flag(zram, index, ZRAM_HUGE)) {
+		clear_slot_flag(zram, index, ZRAM_HUGE);
 		atomic64_dec(&zram->stats.huge_pages);
 	}
 
-	if (zram_test_flag(zram, index, ZRAM_WB)) {
-		zram_clear_flag(zram, index, ZRAM_WB);
-		zram_release_bdev_block(zram, zram_get_handle(zram, index));
+	if (test_slot_flag(zram, index, ZRAM_WB)) {
+		clear_slot_flag(zram, index, ZRAM_WB);
+		zram_release_bdev_block(zram, get_slot_handle(zram, index));
 		goto out;
 	}
 
@@ -2036,24 +2037,24 @@ static void zram_slot_free(struct zram *zram, u32 index)
 	 * No memory is allocated for same element filled pages.
 	 * Simply clear same page flag.
 	 */
-	if (zram_test_flag(zram, index, ZRAM_SAME)) {
-		zram_clear_flag(zram, index, ZRAM_SAME);
+	if (test_slot_flag(zram, index, ZRAM_SAME)) {
+		clear_slot_flag(zram, index, ZRAM_SAME);
 		atomic64_dec(&zram->stats.same_pages);
 		goto out;
 	}
 
-	handle = zram_get_handle(zram, index);
+	handle = get_slot_handle(zram, index);
 	if (!handle)
 		return;
 
 	zs_free(zram->mem_pool, handle);
 
-	atomic64_sub(zram_get_obj_size(zram, index),
+	atomic64_sub(get_slot_size(zram, index),
 		     &zram->stats.compr_data_size);
 out:
 	atomic64_dec(&zram->stats.pages_stored);
-	zram_set_handle(zram, index, 0);
-	zram_set_obj_size(zram, index, 0);
+	set_slot_handle(zram, index, 0);
+	set_slot_size(zram, index, 0);
 }
 
 static int read_same_filled_page(struct zram *zram, struct page *page,
@@ -2062,7 +2063,7 @@ static int read_same_filled_page(struct zram *zram, struct page *page,
 	void *mem;
 
 	mem = kmap_local_page(page);
-	zram_fill_page(mem, PAGE_SIZE, zram_get_handle(zram, index));
+	zram_fill_page(mem, PAGE_SIZE, get_slot_handle(zram, index));
 	kunmap_local(mem);
 	return 0;
 }
@@ -2073,7 +2074,7 @@ static int read_incompressible_page(struct zram *zram, struct page *page,
 	unsigned long handle;
 	void *src, *dst;
 
-	handle = zram_get_handle(zram, index);
+	handle = get_slot_handle(zram, index);
 	src = zs_obj_read_begin(zram->mem_pool, handle, NULL);
 	dst = kmap_local_page(page);
 	copy_page(dst, src);
@@ -2091,9 +2092,9 @@ static int read_compressed_page(struct zram *zram, struct page *page, u32 index)
 	void *src, *dst;
 	int ret, prio;
 
-	handle = zram_get_handle(zram, index);
-	size = zram_get_obj_size(zram, index);
-	prio = zram_get_priority(zram, index);
+	handle = get_slot_handle(zram, index);
+	size = get_slot_size(zram, index);
+	prio = get_slot_comp_priority(zram, index);
 
 	zstrm = zcomp_stream_get(zram->comps[prio]);
 	src = zs_obj_read_begin(zram->mem_pool, handle, zstrm->local_copy);
@@ -2114,8 +2115,8 @@ static int read_from_zspool_raw(struct zram *zram, struct page *page, u32 index)
 	unsigned int size;
 	void *src;
 
-	handle = zram_get_handle(zram, index);
-	size = zram_get_obj_size(zram, index);
+	handle = get_slot_handle(zram, index);
+	size = get_slot_size(zram, index);
 
 	/*
 	 * We need to get stream just for ->local_copy buffer, in
@@ -2138,11 +2139,11 @@ static int read_from_zspool_raw(struct zram *zram, struct page *page, u32 index)
  */
 static int read_from_zspool(struct zram *zram, struct page *page, u32 index)
 {
-	if (zram_test_flag(zram, index, ZRAM_SAME) ||
-	    !zram_get_handle(zram, index))
+	if (test_slot_flag(zram, index, ZRAM_SAME) ||
+	    !get_slot_handle(zram, index))
 		return read_same_filled_page(zram, page, index);
 
-	if (!zram_test_flag(zram, index, ZRAM_HUGE))
+	if (!test_slot_flag(zram, index, ZRAM_HUGE))
 		return read_compressed_page(zram, page, index);
 	else
 		return read_incompressible_page(zram, page, index);
@@ -2153,19 +2154,19 @@ static int zram_read_page(struct zram *zram, struct page *page, u32 index,
 {
 	int ret;
 
-	zram_slot_lock(zram, index);
-	if (!zram_test_flag(zram, index, ZRAM_WB)) {
+	slot_lock(zram, index);
+	if (!test_slot_flag(zram, index, ZRAM_WB)) {
 		/* Slot should be locked through out the function call */
 		ret = read_from_zspool(zram, page, index);
-		zram_slot_unlock(zram, index);
+		slot_unlock(zram, index);
 	} else {
-		unsigned long blk_idx = zram_get_handle(zram, index);
+		unsigned long blk_idx = get_slot_handle(zram, index);
 
 		/*
 		 * The slot should be unlocked before reading from the backing
 		 * device.
 		 */
-		zram_slot_unlock(zram, index);
+		slot_unlock(zram, index);
 		ret = read_from_bdev(zram, page, index, blk_idx, parent);
 	}
 
@@ -2206,11 +2207,11 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 static int write_same_filled_page(struct zram *zram, unsigned long fill,
 				  u32 index)
 {
-	zram_slot_lock(zram, index);
-	zram_slot_free(zram, index);
-	zram_set_flag(zram, index, ZRAM_SAME);
-	zram_set_handle(zram, index, fill);
-	zram_slot_unlock(zram, index);
+	slot_lock(zram, index);
+	slot_free(zram, index);
+	set_slot_flag(zram, index, ZRAM_SAME);
+	set_slot_handle(zram, index, fill);
+	slot_unlock(zram, index);
 
 	atomic64_inc(&zram->stats.same_pages);
 	atomic64_inc(&zram->stats.pages_stored);
@@ -2244,12 +2245,12 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	zs_obj_write(zram->mem_pool, handle, src, PAGE_SIZE);
 	kunmap_local(src);
 
-	zram_slot_lock(zram, index);
-	zram_slot_free(zram, index);
-	zram_set_flag(zram, index, ZRAM_HUGE);
-	zram_set_handle(zram, index, handle);
-	zram_set_obj_size(zram, index, PAGE_SIZE);
-	zram_slot_unlock(zram, index);
+	slot_lock(zram, index);
+	slot_free(zram, index);
+	set_slot_flag(zram, index, ZRAM_HUGE);
+	set_slot_handle(zram, index, handle);
+	set_slot_size(zram, index, PAGE_SIZE);
+	slot_unlock(zram, index);
 
 	atomic64_add(PAGE_SIZE, &zram->stats.compr_data_size);
 	atomic64_inc(&zram->stats.huge_pages);
@@ -2309,11 +2310,11 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
 	zs_obj_write(zram->mem_pool, handle, zstrm->buffer, comp_len);
 	zcomp_stream_put(zstrm);
 
-	zram_slot_lock(zram, index);
-	zram_slot_free(zram, index);
-	zram_set_handle(zram, index, handle);
-	zram_set_obj_size(zram, index, comp_len);
-	zram_slot_unlock(zram, index);
+	slot_lock(zram, index);
+	slot_free(zram, index);
+	set_slot_handle(zram, index, handle);
+	set_slot_size(zram, index, comp_len);
+	slot_unlock(zram, index);
 
 	/* Update stats */
 	atomic64_inc(&zram->stats.pages_stored);
@@ -2364,30 +2365,30 @@ static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio_max,
 	for (index = 0; index < nr_pages; index++) {
 		bool ok = true;
 
-		zram_slot_lock(zram, index);
-		if (!zram_allocated(zram, index))
+		slot_lock(zram, index);
+		if (!slot_allocated(zram, index))
 			goto next;
 
 		if (mode & RECOMPRESS_IDLE &&
-		    !zram_test_flag(zram, index, ZRAM_IDLE))
+		    !test_slot_flag(zram, index, ZRAM_IDLE))
 			goto next;
 
 		if (mode & RECOMPRESS_HUGE &&
-		    !zram_test_flag(zram, index, ZRAM_HUGE))
+		    !test_slot_flag(zram, index, ZRAM_HUGE))
 			goto next;
 
-		if (zram_test_flag(zram, index, ZRAM_WB) ||
-		    zram_test_flag(zram, index, ZRAM_SAME) ||
-		    zram_test_flag(zram, index, ZRAM_INCOMPRESSIBLE))
+		if (test_slot_flag(zram, index, ZRAM_WB) ||
+		    test_slot_flag(zram, index, ZRAM_SAME) ||
+		    test_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE))
 			goto next;
 
 		/* Already compressed with same of higher priority */
-		if (zram_get_priority(zram, index) + 1 >= prio_max)
+		if (get_slot_comp_priority(zram, index) + 1 >= prio_max)
 			goto next;
 
 		ok = place_pp_slot(zram, ctl, index);
 next:
-		zram_slot_unlock(zram, index);
+		slot_unlock(zram, index);
 		if (!ok)
 			break;
 	}
@@ -2416,11 +2417,11 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 	void *src;
 	int ret = 0;
 
-	handle_old = zram_get_handle(zram, index);
+	handle_old = get_slot_handle(zram, index);
 	if (!handle_old)
 		return -EINVAL;
 
-	comp_len_old = zram_get_obj_size(zram, index);
+	comp_len_old = get_slot_size(zram, index);
 	/*
 	 * Do not recompress objects that are already "small enough".
 	 */
@@ -2436,11 +2437,11 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 	 * we don't preserve IDLE flag and don't incorrectly pick this entry
 	 * for different post-processing type (e.g. writeback).
 	 */
-	zram_clear_flag(zram, index, ZRAM_IDLE);
+	clear_slot_flag(zram, index, ZRAM_IDLE);
 
 	class_index_old = zs_lookup_class_index(zram->mem_pool, comp_len_old);
 
-	prio = max(prio, zram_get_priority(zram, index) + 1);
+	prio = max(prio, get_slot_comp_priority(zram, index) + 1);
 	/*
 	 * Recompression slots scan should not select slots that are
 	 * already compressed with a higher priority algorithm, but
@@ -2507,7 +2508,7 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 		 */
 		if (prio < zram->num_active_comps)
 			return 0;
-		zram_set_flag(zram, index, ZRAM_INCOMPRESSIBLE);
+		set_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE);
 		return 0;
 	}
 
@@ -2532,10 +2533,10 @@ static int recompress_slot(struct zram *zram, u32 index, struct page *page,
 	zs_obj_write(zram->mem_pool, handle_new, zstrm->buffer, comp_len_new);
 	zcomp_stream_put(zstrm);
 
-	zram_slot_free(zram, index);
-	zram_set_handle(zram, index, handle_new);
-	zram_set_obj_size(zram, index, comp_len_new);
-	zram_set_priority(zram, index, prio);
+	slot_free(zram, index);
+	set_slot_handle(zram, index, handle_new);
+	set_slot_size(zram, index, comp_len_new);
+	set_slot_comp_priority(zram, index, prio);
 
 	atomic64_add(comp_len_new, &zram->stats.compr_data_size);
 	atomic64_inc(&zram->stats.pages_stored);
@@ -2675,15 +2676,15 @@ static ssize_t recompress_store(struct device *dev,
 		if (!num_recomp_pages)
 			break;
 
-		zram_slot_lock(zram, pps->index);
-		if (!zram_test_flag(zram, pps->index, ZRAM_PP_SLOT))
+		slot_lock(zram, pps->index);
+		if (!test_slot_flag(zram, pps->index, ZRAM_PP_SLOT))
 			goto next;
 
 		err = recompress_slot(zram, pps->index, page,
 				      &num_recomp_pages, threshold,
 				      prio, prio_max);
 next:
-		zram_slot_unlock(zram, pps->index);
+		slot_unlock(zram, pps->index);
 		release_pp_slot(zram, pps);
 
 		if (err) {
@@ -2729,9 +2730,9 @@ static void zram_bio_discard(struct zram *zram, struct bio *bio)
 	}
 
 	while (n >= PAGE_SIZE) {
-		zram_slot_lock(zram, index);
-		zram_slot_free(zram, index);
-		zram_slot_unlock(zram, index);
+		slot_lock(zram, index);
+		slot_free(zram, index);
+		slot_unlock(zram, index);
 		atomic64_inc(&zram->stats.notify_free);
 		index++;
 		n -= PAGE_SIZE;
@@ -2760,9 +2761,9 @@ static void zram_bio_read(struct zram *zram, struct bio *bio)
 		}
 		flush_dcache_page(bv.bv_page);
 
-		zram_slot_lock(zram, index);
-		zram_accessed(zram, index);
-		zram_slot_unlock(zram, index);
+		slot_lock(zram, index);
+		mark_slot_accessed(zram, index);
+		slot_unlock(zram, index);
 
 		bio_advance_iter_single(bio, &iter, bv.bv_len);
 	} while (iter.bi_size);
@@ -2790,9 +2791,9 @@ static void zram_bio_write(struct zram *zram, struct bio *bio)
 			break;
 		}
 
-		zram_slot_lock(zram, index);
-		zram_accessed(zram, index);
-		zram_slot_unlock(zram, index);
+		slot_lock(zram, index);
+		mark_slot_accessed(zram, index);
+		slot_unlock(zram, index);
 
 		bio_advance_iter_single(bio, &iter, bv.bv_len);
 	} while (iter.bi_size);
@@ -2833,13 +2834,13 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	zram = bdev->bd_disk->private_data;
 
 	atomic64_inc(&zram->stats.notify_free);
-	if (!zram_slot_trylock(zram, index)) {
+	if (!slot_trylock(zram, index)) {
 		atomic64_inc(&zram->stats.miss_free);
 		return;
 	}
 
-	zram_slot_free(zram, index);
-	zram_slot_unlock(zram, index);
+	slot_free(zram, index);
+	slot_unlock(zram, index);
 }
 
 static void zram_comp_params_reset(struct zram *zram)
-- 
2.52.0.239.gd5f0c6e74e-goog


