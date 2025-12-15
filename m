Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32510D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 05:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9116B0006; Mon, 15 Dec 2025 00:47:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 679F66B0007; Mon, 15 Dec 2025 00:47:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58FAD6B0008; Mon, 15 Dec 2025 00:47:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 449B96B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 00:47:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D504CBE494
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:47:35 +0000 (UTC)
X-FDA: 84220623270.07.768ABB6
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id EEDBA40005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 05:47:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=SnAWY7gq;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765777654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IonsJ3LbB8AUdyCVRgel7KA7biBiZzI5NrUoHUACON4=;
	b=eroXSCFxJa/qijwa+trwNrScY0QsBp7BS8+gSG3ltPTjxrAPZ7C+Nu3Qgl2muX5KvviQPH
	XVXpKMjT9yTUJKmycKLJ7/ViJsR/oCTekVzlHVRB+5TdV7960SFLBX6JukvG9PQXVBw2Vm
	3AjGlpCabOJOnLNFNogIxfDbB+FV1vU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=SnAWY7gq;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765777654; a=rsa-sha256;
	cv=none;
	b=Mct4q1JvKhCO0duniNmKXGy0xeJWsp+0ViBga1mRlgbqs3NAsqkKdPleZp68YkY3Ra1lgD
	js2Ykan10DmCcqINqnyegGwXAnx+tKdZ4ckIBRwyZ/IPNQYnNbTlInXbvmQGJm1GsWNKCM
	h0NgIACEpUCycLg/vdLVkC/tGli3+R0=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso16715945ad.1
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 21:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1765777653; x=1766382453; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IonsJ3LbB8AUdyCVRgel7KA7biBiZzI5NrUoHUACON4=;
        b=SnAWY7gqJy/SvCYCpw9XkPDDeCByXeFSNzWNouDk3XJd33pxGsxP5Q86EM9lkZftkt
         3uiCt7hC0qygKUVsisZ6pfPK63hPNGji+scEntztH3MizwqIHMvLUvD5pfXjoe5XsuGj
         KpT8qhY6KtnR4frQ/fhZHTGBHp5BN3qwQjtoE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765777653; x=1766382453;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IonsJ3LbB8AUdyCVRgel7KA7biBiZzI5NrUoHUACON4=;
        b=HXU0x4T1xs8e88UKMR2ERq32SRyt96QCKD7hmxLwkgy9MPyfknx45KQIUVUuMAHK1N
         ljRyve0yRp1gtgS1kQWizVy1xjOhMaj7Yksme2l67jc3PpAWMAcmwwPh64/0b1vm5W7Z
         RNIqihRZkjrlsUEK4prC1Z9B2YwyJWZJYWXw7nhBLN/1RiNFK3txiCfByqKLPAorIZJk
         REfpEhB80dmLNauYMLY1eVI2Q+Rpwc6vnAsBuxSB9OznlsViokMsjDu2n6R7Awcp9h1X
         iu0cz1hDQ52CaTWIBdaeXZhXSF/FqEmd1JB2v5uoJBNKtF8iFDD/5i0BoaO4n8pp54Di
         Wr2w==
X-Forwarded-Encrypted: i=1; AJvYcCUuDxYgZxSDcdsqS55RR3crGf4hft7PhBu6lRZlQpgTQv4FLaTQFt+Z6AZ8zbS0nJ1EwWz1RCEDfg==@kvack.org
X-Gm-Message-State: AOJu0Yy8+XOf+isEysUBtMSSNauAXISvwQMQnXZ8bm+vK801+i8Ju64M
	kPO57U+4L9bvfXBN6WCP56Hv9SwnXZ5zMWW0GNDe33xlhHkMcuM4hIrogaotL+RKyg==
X-Gm-Gg: AY/fxX4eny2un05fLMOL7tntKzkBBLJGdF/d3X6dlcXEb4+v/ah9KTRDGLzlAyqRabr
	1hMMy3xP3hBMhZvfPzmHHh3x/UPJ0n7lESrTZc8yOBaRCFJD1iJN1Y/RXS12W4/pYGqwCSvq5YW
	sZrhYZ1RYcCWC/HR4oPOjHxZ884QeS4yMyXrZsk9cgF+V2R+4DlCnjjPdwbbZ74kNjdb2NaAGc8
	WuC5a6p6XPPszLHxTpN3G/9Y1sMR9sBON36D9l8/C9SuPEk4Tzwgs1+PxsuApwc9DsZxJhX9Wvr
	eYyb1AciRpDjp/vPwGi79plVEUrC2SybS4fBXmLxXN7Sa2GSnUi9pOOymveWvWeQoek+Lg0FvVp
	r7jVVyb7lFGRBAByXJ0bHvXOunsy362FBVR1vsrNb8R3zVqhkiwwiyIIcVOc8KI5n4LostCv2oq
	UGckC1m6tPjyPn2qC70xLl0A6ZjvKHNd84hj1Ie3F7YjS9dIGp4cfRYmHZF98uNnNeE4f3I3BbK
	g==
X-Google-Smtp-Source: AGHT+IGWzKWE4FxeG3w6tIQsZVaipTdv+2vkpll/N34qp/C6l7qnJ36dIs1SGAcaq63EU+SH6DLpqw==
X-Received: by 2002:a17:902:e94d:b0:295:6d30:e25f with SMTP id d9443c01a7336-29f243879d8mr94329765ad.53.1765777652755;
        Sun, 14 Dec 2025 21:47:32 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:88fa:c762:fe19:6db7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a0bb39db53sm36391945ad.11.2025.12.14.21.47.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 21:47:32 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	David Stevens <stevensd@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 1/3] zram: use u32 for entry ac_time tracking
Date: Mon, 15 Dec 2025 14:47:11 +0900
Message-ID: <d7c0b48450c70eeb5fd8acd6ecd23593f30dbf1f.1765775954.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EEDBA40005
X-Stat-Signature: aqofpbrf5x9u6rzg1soy6pid475d1ojp
X-HE-Tag: 1765777653-217453
X-HE-Meta: U2FsdGVkX193uB8xls1E7iX5JEryetLCwwvMfvAbceo4ZDdoL5LGAW27b6nnMDMxbmOaGYeFYAPIFBbQi0oiTAqkeBiIsacMiZI2PeGygwjbq8TnJ4VKdwya8vK7HLy8BV3EW36rLzWCYLimk1dq3aK4Hg9t7TD1HXrMa6scKQAhdAIBcSdml0O0B8ibosmugrO/UnprpwIkQc5Mts7VdTkhZ2VHNCdEEAAfc1sBVPQxEg+kW4tHtRHcFNWkempPl1rTmnd3M58Ih7mkpSdCQryMEpVVKiG5GOP8DDkecqtvfHPT70rwJzwpITmB12inTMR7Nxao4U3alKOYuFwOLOH4DPG4eIylwbZ5arsOuOq/1ad8Q8zDtURwtYxoS6DzMqoCMuFy4fYFk2TKed/dDJXYqwKRu4JxNJwjBgpWbUXHbfwJqPW8FceUXkN+QU2zBTOQ861jf1CDXD/TaA7D0L+5WhTMZAj9QunKiHYWloa98noV6bTIxM8z54m9EuhDVQPe6gPtDhZaJ0MiHLSTp/zRK9sinYAT7y0itUzs0lHOVWTnCw6AXUKRhsnqWUKqTBGbJfn6jRsynkw5SecgZfHeRtH1r0Wctd3MfATTFMkHi2pFSz+IgLdNFCbAjSEehuXPtbaOkO8eZ1fXRGgTcQ9N9IpXemgEfIqAbJO0auEWQWSgMqH2fulF1BtXDEjeJMym566Vvou7iPFNYjvu3JXJEZ0x9SeJo6pMWECIs/yxiYkN3drEOZEp8kJzQuH1E94I8edH5fP+vErqqDmNA8M2qoJmZh3qLCApvVOCZfz6nNaO5knzQ4Z2m7AyevtRjzR8OqWAH+/rwmvU9RRcUGimrPEEh902M8VJY+GZm55PeqjxE28R98XnrOfq2avve/95rJPemPSAmjYKq0pY03mb+MTFGAiM0bZi6VT0LA+HeurRwo6g+DwfMhj61gydfMRlNCJcM6dWpINuPni
 1q+pY+97
 POmgJRPNY9nyC+QekKjEFJtzX7GP8DlkKMatkHbPDC+avnSutTDy2YMianOXITRiLhwqW3DFZWeKL7Mb6BUM6QBJmQZp6wNXbKkYaztGW7yRfXSfONyAs8gvYvjXDhuGm1jCPrjqSiT+QZn4w90gagA/SbgUDFl+9B/Z+O7CyPXiRHJW1iVIcwhislKAWkswystegi+IwJ0dUhQmhXOr9u39GeDKqouJ3vAFnm19NBM9+L1IB4rh9TDdy925aaMDDBKuvT+wV8CUY3MPwuNKAoUdd+33u567AeazaM6Qb+pC1tVMO1/ID4EDFu6xekPWx9Rm5eUrLDwHpYPBgbygXQk7g6+74q0OoiOEGcBPhiJw+/GeC8Q52tAJUxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We can reduce sizeof(zram_table_entry) on 64-bit systems
by converting flags and ac_time to u32.  Entry flags fit
into u32, and for ac_time u32 gives us over a century of
entry lifespan (approx 136 years) which is plenty (zram
uses system boot time (seconds)).

In struct zram_table_entry we use bytes aliasing, because
bit-wait API (for slot lock) requires a whole unsigned
long word.

Suggested-by: David Stevens <stevensd@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 60 +++++++++++++++++------------------
 drivers/block/zram/zram_drv.h |  9 ++++--
 2 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 67a9e7c005c3..65f99ff3e2e5 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -81,7 +81,7 @@ static void zram_slot_lock_init(struct zram *zram, u32 index)
  */
 static __must_check bool zram_slot_trylock(struct zram *zram, u32 index)
 {
-	unsigned long *lock = &zram->table[index].flags;
+	unsigned long *lock = &zram->table[index].__lock;
 
 	if (!test_and_set_bit_lock(ZRAM_ENTRY_LOCK, lock)) {
 		mutex_acquire(slot_dep_map(zram, index), 0, 1, _RET_IP_);
@@ -94,7 +94,7 @@ static __must_check bool zram_slot_trylock(struct zram *zram, u32 index)
 
 static void zram_slot_lock(struct zram *zram, u32 index)
 {
-	unsigned long *lock = &zram->table[index].flags;
+	unsigned long *lock = &zram->table[index].__lock;
 
 	mutex_acquire(slot_dep_map(zram, index), 0, 0, _RET_IP_);
 	wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK, TASK_UNINTERRUPTIBLE);
@@ -103,7 +103,7 @@ static void zram_slot_lock(struct zram *zram, u32 index)
 
 static void zram_slot_unlock(struct zram *zram, u32 index)
 {
-	unsigned long *lock = &zram->table[index].flags;
+	unsigned long *lock = &zram->table[index].__lock;
 
 	mutex_release(slot_dep_map(zram, index), _RET_IP_);
 	clear_and_wake_up_bit(ZRAM_ENTRY_LOCK, lock);
@@ -130,34 +130,33 @@ static void zram_set_handle(struct zram *zram, u32 index, unsigned long handle)
 }
 
 static bool zram_test_flag(struct zram *zram, u32 index,
-			enum zram_pageflags flag)
+			   enum zram_pageflags flag)
 {
-	return zram->table[index].flags & BIT(flag);
+	return zram->table[index].attr.flags & BIT(flag);
 }
 
 static void zram_set_flag(struct zram *zram, u32 index,
-			enum zram_pageflags flag)
+			  enum zram_pageflags flag)
 {
-	zram->table[index].flags |= BIT(flag);
+	zram->table[index].attr.flags |= BIT(flag);
 }
 
 static void zram_clear_flag(struct zram *zram, u32 index,
-			enum zram_pageflags flag)
+			    enum zram_pageflags flag)
 {
-	zram->table[index].flags &= ~BIT(flag);
+	zram->table[index].attr.flags &= ~BIT(flag);
 }
 
 static size_t zram_get_obj_size(struct zram *zram, u32 index)
 {
-	return zram->table[index].flags & (BIT(ZRAM_FLAG_SHIFT) - 1);
+	return zram->table[index].attr.flags & (BIT(ZRAM_FLAG_SHIFT) - 1);
 }
 
-static void zram_set_obj_size(struct zram *zram,
-					u32 index, size_t size)
+static void zram_set_obj_size(struct zram *zram, u32 index, size_t size)
 {
-	unsigned long flags = zram->table[index].flags >> ZRAM_FLAG_SHIFT;
+	unsigned long flags = zram->table[index].attr.flags >> ZRAM_FLAG_SHIFT;
 
-	zram->table[index].flags = (flags << ZRAM_FLAG_SHIFT) | size;
+	zram->table[index].attr.flags = (flags << ZRAM_FLAG_SHIFT) | size;
 }
 
 static inline bool zram_allocated(struct zram *zram, u32 index)
@@ -208,14 +207,14 @@ static inline void zram_set_priority(struct zram *zram, u32 index, u32 prio)
 	 * Clear previous priority value first, in case if we recompress
 	 * further an already recompressed page
 	 */
-	zram->table[index].flags &= ~(ZRAM_COMP_PRIORITY_MASK <<
-				      ZRAM_COMP_PRIORITY_BIT1);
-	zram->table[index].flags |= (prio << ZRAM_COMP_PRIORITY_BIT1);
+	zram->table[index].attr.flags &= ~(ZRAM_COMP_PRIORITY_MASK <<
+					   ZRAM_COMP_PRIORITY_BIT1);
+	zram->table[index].attr.flags |= (prio << ZRAM_COMP_PRIORITY_BIT1);
 }
 
 static inline u32 zram_get_priority(struct zram *zram, u32 index)
 {
-	u32 prio = zram->table[index].flags >> ZRAM_COMP_PRIORITY_BIT1;
+	u32 prio = zram->table[index].attr.flags >> ZRAM_COMP_PRIORITY_BIT1;
 
 	return prio & ZRAM_COMP_PRIORITY_MASK;
 }
@@ -225,7 +224,7 @@ static void zram_accessed(struct zram *zram, u32 index)
 	zram_clear_flag(zram, index, ZRAM_IDLE);
 	zram_clear_flag(zram, index, ZRAM_PP_SLOT);
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
-	zram->table[index].ac_time = ktime_get_boottime();
+	zram->table[index].attr.ac_time = (u32)ktime_get_boottime_seconds();
 #endif
 }
 
@@ -447,7 +446,7 @@ static void mark_idle(struct zram *zram, ktime_t cutoff)
 
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
 		is_idle = !cutoff ||
-			ktime_after(cutoff, zram->table[index].ac_time);
+			ktime_after(cutoff, zram->table[index].attr.ac_time);
 #endif
 		if (is_idle)
 			zram_set_flag(zram, index, ZRAM_IDLE);
@@ -461,18 +460,19 @@ static ssize_t idle_store(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
-	ktime_t cutoff_time = 0;
+	ktime_t cutoff = 0;
 
 	if (!sysfs_streq(buf, "all")) {
 		/*
 		 * If it did not parse as 'all' try to treat it as an integer
 		 * when we have memory tracking enabled.
 		 */
-		u64 age_sec;
+		u32 age_sec;
 
-		if (IS_ENABLED(CONFIG_ZRAM_TRACK_ENTRY_ACTIME) && !kstrtoull(buf, 0, &age_sec))
-			cutoff_time = ktime_sub(ktime_get_boottime(),
-					ns_to_ktime(age_sec * NSEC_PER_SEC));
+		if (IS_ENABLED(CONFIG_ZRAM_TRACK_ENTRY_ACTIME) &&
+		    !kstrtouint(buf, 0, &age_sec))
+			cutoff = ktime_sub((u32)ktime_get_boottime_seconds(),
+					   age_sec);
 		else
 			return -EINVAL;
 	}
@@ -482,10 +482,10 @@ static ssize_t idle_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 
 	/*
-	 * A cutoff_time of 0 marks everything as idle, this is the
+	 * A cutoff of 0 marks everything as idle, this is the
 	 * "all" behavior.
 	 */
-	mark_idle(zram, cutoff_time);
+	mark_idle(zram, cutoff);
 	return len;
 }
 
@@ -1588,7 +1588,7 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 		if (!zram_allocated(zram, index))
 			goto next;
 
-		ts = ktime_to_timespec64(zram->table[index].ac_time);
+		ts = ktime_to_timespec64(zram->table[index].attr.ac_time);
 		copied = snprintf(kbuf + written, count,
 			"%12zd %12lld.%06lu %c%c%c%c%c%c\n",
 			index, (s64)ts.tv_sec,
@@ -2013,7 +2013,7 @@ static void zram_slot_free(struct zram *zram, u32 index)
 	unsigned long handle;
 
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
-	zram->table[index].ac_time = 0;
+	zram->table[index].attr.ac_time = 0;
 #endif
 
 	zram_clear_flag(zram, index, ZRAM_IDLE);
@@ -3286,7 +3286,7 @@ static int __init zram_init(void)
 	struct zram_table_entry zram_te;
 	int ret;
 
-	BUILD_BUG_ON(__NR_ZRAM_PAGEFLAGS > sizeof(zram_te.flags) * 8);
+	BUILD_BUG_ON(__NR_ZRAM_PAGEFLAGS > sizeof(zram_te.attr.flags) * 8);
 
 	ret = cpuhp_setup_state_multi(CPUHP_ZCOMP_PREPARE, "block/zram:prepare",
 				      zcomp_cpu_up_prepare, zcomp_cpu_dead);
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 72fdf66c78ab..48d6861c6647 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -65,10 +65,15 @@ enum zram_pageflags {
  */
 struct zram_table_entry {
 	unsigned long handle;
-	unsigned long flags;
+	union {
+		unsigned long __lock;
+		struct attr {
+			u32 flags;
 #ifdef CONFIG_ZRAM_TRACK_ENTRY_ACTIME
-	ktime_t ac_time;
+			u32 ac_time;
 #endif
+		} attr;
+	};
 	struct lockdep_map dep_map;
 };
 
-- 
2.52.0.239.gd5f0c6e74e-goog


