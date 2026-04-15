Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8E75F43858
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 16:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 424DD6B0096; Wed, 15 Apr 2026 12:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC3D6B0098; Wed, 15 Apr 2026 12:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0DB6B0099; Wed, 15 Apr 2026 12:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 139E06B0096
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:47:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C9EBB13B194
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:47:34 +0000 (UTC)
X-FDA: 84661371228.11.1355149
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id B494F180003
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:47:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf16.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776271653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k4JpYVcMpH8gy//+nGqFzD3fN96UK9Ogg3354aXrQrQ=;
	b=ySGMQnhYxK0QF96xxl4B8iKERaZb7usTsNy9f9kW/p+C7wWEealVrJVTzOxXdQtSh1XKhG
	EtAyNNEAmQHSubJ97rtpNB+xVDRV/g/BjpA8BgpFTK+Fw/rIh/8ygN90JzmWEGt1tjD0J/
	3Q0lbezUfSqKme6azDeWFdgWm8IfzhY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf16.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776271653; a=rsa-sha256;
	cv=none;
	b=OHnBaKWLw4IZcI0S9ddhl9QKd/2oMA0l1sHU2DWGts4Ilz3+amCReloMUUqTyUuZYHNEnt
	1tojqDMF/UC8w0Lot4qbmLbpk9lqcDSJ5g6ZXXiCsEbmJ2OF/uc61VmAY/N+/FHcVWRB65
	mOLnr5kvOiRWIzepHunh8yayF7PIEz0=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fwn9K6MNPzJ46DM;
	Thu, 16 Apr 2026 00:46:45 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 4733E40569;
	Thu, 16 Apr 2026 00:47:29 +0800 (CST)
Received: from localhost.localdomain (10.123.66.205) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Apr 2026 19:47:28 +0300
From: Fedorov Nikita <fedorov.nikita@h-partners.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, Juergen Gross <jgross@suse.com>, Ajay
 Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov
	<alexey.makhalov@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>, Arnd
 Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>, Boqun Feng
	<boqun@kernel.org>, Waiman Long <longman@redhat.com>, Darren Hart
	<dvhart@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>,
	<andrealmeid@igalia.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple
	<apopple@nvidia.com>, Anatoly Stepanov <stepanov.anatoly@huawei.com>
CC: Nikita Fedorov <fedorov.nikita@h-partners.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<virtualization@lists.linux.dev>, <linux-arch@vger.kernel.org>,
	<linux-mm@kvack.org>, <guohanjun@huawei.com>, <wangkefeng.wang@huawei.com>,
	<weiyongjun1@huawei.com>, <yusongping@huawei.com>, <leijitang@huawei.com>,
	<artem.kuzin@huawei.com>, <kang.sun@huawei.com>, <chenjieping3@huawei.com>
Subject: [RFC PATCH v3 3/7] hq-spinlock: add contention detection
Date: Thu, 16 Apr 2026 00:44:55 +0800
Message-ID: <20260415164459.2904963-4-fedorov.nikita@h-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260415164459.2904963-1-fedorov.nikita@h-partners.com>
References: <20260415164459.2904963-1-fedorov.nikita@h-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.205]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B494F180003
X-Stat-Signature: 7ahdcfm3frerdtr3kkb36aip3f6guj1k
X-HE-Tag: 1776271652-682812
X-HE-Meta: U2FsdGVkX1/cQ+PWxPqPGjlsqxI6P0KERO05WKPNIjS7zizbNZ3hpnjomqKjnEn27T7yRLCryWRZO2vPmsCEC0x+WG3vg+81poYqaKYh5bUCFu082mphbDf2prMrobLe8KjzmNAN3mRM1fT6nOQrFzmPnfWh4fImX1yflXAcHUjaVzf2EmXHKOFU/AM1gaz9MmIy3KjBbblZqlZIs7BmAcY/0b2FQZGHthBno6bzznlc5/RdQccrL8eTxA5wjU6tmPxwEII0Sqo3WbNv2F2KiaS8cleg7hddNsuMDhrUoG1BXxdLmwnjlLZKkDK/szCeuWn8kbPwZ/b26b7ndM4PE3j+GWp7XvLbHC1rquDvIQ5ncbdLBEigJydHX4uwq3U/nDhOOIPryWSMiGSzJO1BhCxkXdi3X+DSmULUzJicSaeA61Nld/Dre15vT0uGqi0g9j5wGevbUgYJSD2/chQX88kwz6vsoLa+8yGhqDIljaIsD8uDTM6wwY6x400IqxVE+Zgm759TjqbLvI9GVAujsZ87AEjUTFT0eMvFyEg173bmUb+PiEtGh1Gn5zv3nIprp1YvxSQhbhwiEOGNscIKLoG4V6ChIXv0CXJv4BiOtZhJmZJVzQRJxjFua4cozdURRHVjERbZ9GCecv6tAcWWQfMIZzabpOT4UMDU6c8NgYVzCtWvuYPEg7wdJguTj9jUXun3FeESgwi4Bo7iKFdRC/wRQJ4u1jBjptgu8aKU+baMQIb+OTBYdKZ1gXZT2wajadhakhP6Zvd/RgOh5G4Gvj6WjL+18I/Xzw/MIPyQinkgEnA4NlzNJbrG3F+39+HhflSaA5cdLu7fwfo0Rnv/4gHahc4TJzr/mWtf5IGaW0lQF0UZnPpEXh9lkEsVWAWhkMZwVpzoHl90o/Pbzshg5kB06Jx21FnB40YaNYx37PNBSdDQf7YSJoU27Z/fCJC4utW98u1I9JCid2PqTHs
 HPi/RUMD
 4+4VRTHJQ3mftIsobJsnZyQl+sDaiSVfqe8Pf7Nb4RNU571RUg2GIi4GJEpF2k+aOsYjsaRGPWGBaiXXdSH3Rb5u0M4Zr+V4kR0CGyn8UUwiHIGYjRyuX4s9XkvnuWD8bFRY8P87ClvfNElWQu6AsDDZU2WphYKndVSwdAD+dpQQBlXLntMW9MAg05nG2tigv+OfH3LpLcQbMt1PmuSuqv9PInN/3fiy40goyrzuHJuXilmxGw1CvZKEdwyTzHS9SEgW4mIf7nXzHo8HWV0KQOLFJ+MqACJFQsMIiBab3yQzjnQQSYnRMCS5NEuZDNzEzzts4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hierarchical slowpath is needed for locks that experience
sustained cross-node contention. Enabling it unconditionally is
undesirable for lightly contended locks and may decrease the performance.

Add a simple contention detection scheme that tracks remote handoffs
separately from overall handoff activity and enables HQ mode only when
the observed handoff pattern indicates that cross-node contention is
high enough to benefit from NUMA-aware queueing.

HQ lock type can be turned on if remote_handoffs exceeds `hqlock_remote_handoffs_turn_numa`.
Lock can be turned back into QSPINLOCK mode if in HQ mode
amount of remote handoffs will not exceed `hqlock_remote_handoffs_keep_numa`.

Remote handoffs counter will increase only if the amount of local handoffs after previous increase
is not less than `hqlock_local_handoffs_to_increase_remotes`.

Additional locktorture reruns showed no degradation
in low-contention configurations after adding contention-based switching
while maintaining practically the same performance improvement in high contention cases.

Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
Signed-off-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
Co-developed-by: Nikita Fedorov <fedorov.nikita@h-partners.com>
Signed-off-by: Nikita Fedorov <fedorov.nikita@h-partners.com>
---
 kernel/locking/hqlock_core.h  | 57 +++++++++++++++++++++++++++++++++--
 kernel/locking/hqlock_meta.h  |  4 +++
 kernel/locking/hqlock_types.h |  8 +++--
 3 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/kernel/locking/hqlock_core.h b/kernel/locking/hqlock_core.h
index 7322199228..e2ba09d758 100644
--- a/kernel/locking/hqlock_core.h
+++ b/kernel/locking/hqlock_core.h
@@ -450,6 +450,23 @@ static inline void hqlock_handoff(struct qspinlock *lock,
 					 struct mcs_spinlock *next, u32 tail,
 					 int handoff_info);
 
+/*
+ * In low_contention_mcs_lock_handoff we wanted to help processor optimise writes
+ * and avoid extra reading of our cpu cacheline (read our qnode->numa_node),
+ * so previous contender has saved his numa node in our prev_numa_node,
+ * and now we need to update remote_handoffs counter by ourself
+ */
+static __always_inline void update_counters_qspinlock(struct numa_qnode *qnode)
+{
+	if (qnode->numa_node != qnode->prev_numa_node) {
+		if ((qnode->general_handoffs - qnode->prev_general_handoffs)
+		    > hqlock_local_handoffs_to_increase_remotes) {
+			qnode->remote_handoffs++;
+		}
+
+		qnode->prev_general_handoffs = qnode->general_handoffs;
+	}
+}
 
 /*
  * Chech if contention has risen and if we need to set NUMA-aware mode
@@ -458,8 +475,13 @@ static __always_inline bool determine_contention_qspinlock_mode(struct mcs_spinl
 {
 	struct numa_qnode *qnode = (void *)node;
 
-	if (qnode->general_handoffs > READ_ONCE(hqlock_general_handoffs_turn_numa))
+	unsigned long general_handoffs = (unsigned long) qnode->general_handoffs;
+	unsigned long remote_handoffs = (unsigned long) qnode->remote_handoffs;
+
+	if ((general_handoffs > hqlock_general_handoffs_turn_numa) &&
+		(remote_handoffs > hqlock_remote_handoffs_turn_numa))
 		return true;
+
 	return false;
 }
 
@@ -485,7 +507,14 @@ static __always_inline bool low_contention_try_clear_tail(struct qspinlock *lock
 	else
 		update_val |= _Q_LOCK_INVALID_TAIL;
 
-	return atomic_try_cmpxchg_relaxed(&lock->val, &val, update_val);
+	bool ret = atomic_try_cmpxchg_relaxed(&lock->val, &val, update_val);
+
+#ifdef CONFIG_HQSPINLOCKS_DEBUG
+	if (ret && high_contention)
+		atomic_inc(&transitions_from_qspinlock_to_hq);
+#endif
+
+	return ret;
 }
 
 static __always_inline void low_contention_mcs_lock_handoff(struct mcs_spinlock *node,
@@ -502,6 +531,17 @@ static __always_inline void low_contention_mcs_lock_handoff(struct mcs_spinlock
 		general_handoffs++;
 
 	qnext->general_handoffs = general_handoffs;
+	qnext->remote_handoffs = qnode->remote_handoffs;
+	qnext->prev_general_handoffs = qnode->prev_general_handoffs;
+
+	/*
+	 * Show next contender our numa node and assume
+	 * he will update remote_handoffs counter in update_counters_qspinlock by himself
+	 * instead of reading his numa_node and updating remote_handoffs here
+	 * to avoid extra cacheline transferring and help processor optimise several writes here
+	 */
+	qnext->prev_numa_node = qnode->numa_node;
+
 	arch_mcs_spin_unlock_contended(&next->locked);
 }
 
@@ -557,6 +597,10 @@ static inline void hqlock_init_node(struct mcs_spinlock *node)
 	qnode->numa_node = numa_node_id() + 1;
 	qnode->lock_id = 0;
 	qnode->wrong_fallback_tail = 0;
+
+	qnode->remote_handoffs = 0;
+	qnode->prev_numa_node = 0;
+	qnode->prev_general_handoffs = 0;
 }
 
 static inline void reset_handoff_counter(struct numa_qnode *qnode)
@@ -580,6 +624,8 @@ static inline void handoff_local(struct mcs_spinlock *node,
 
 	qnext->general_handoffs = general_handoffs;
 
+	qnext->remote_handoffs = qnode->remote_handoffs;
+
 	u16 wrong_fallback_tail = qnode->wrong_fallback_tail;
 
 	if (wrong_fallback_tail != 0 && wrong_fallback_tail != (tail >> _Q_TAIL_OFFSET)) {
@@ -641,6 +687,13 @@ static inline void handoff_remote(struct qspinlock *lock,
 
 	mcs_head = (void *) qhead;
 
+	u16 remote_handoffs = qnode->remote_handoffs;
+
+	if (qnode->general_handoffs > hqlock_local_handoffs_to_increase_remotes)
+		remote_handoffs++;
+
+	qhead->remote_handoffs = remote_handoffs;
+
 	/* arch_mcs_spin_unlock_contended implies smp-barrier */
 	arch_mcs_spin_unlock_contended(&mcs_head->locked);
 }
diff --git a/kernel/locking/hqlock_meta.h b/kernel/locking/hqlock_meta.h
index 5b54801326..561d5a5fd0 100644
--- a/kernel/locking/hqlock_meta.h
+++ b/kernel/locking/hqlock_meta.h
@@ -307,6 +307,10 @@ static inline void release_lock_meta(struct qspinlock *lock,
 			goto do_rollback;
 	}
 
+	if (qnode->remote_handoffs < hqlock_remote_handoffs_keep_numa) {
+		upd_val |= _Q_LOCK_MODE_QSPINLOCK_VAL;
+	}
+
 	/*
 	 * We need wait until pending is gone.
 	 * Otherwise, clearing pending can erase a mode we will set here
diff --git a/kernel/locking/hqlock_types.h b/kernel/locking/hqlock_types.h
index 32d06f2755..40061f11a1 100644
--- a/kernel/locking/hqlock_types.h
+++ b/kernel/locking/hqlock_types.h
@@ -37,9 +37,13 @@ struct numa_qnode {
 
 	u16 lock_id;
 	u16 wrong_fallback_tail;
-	u16 general_handoffs;
-
 	u16 numa_node;
+
+
+	u16 general_handoffs;
+	u16 remote_handoffs;
+	u16 prev_general_handoffs;
+	u16 prev_numa_node;
 };
 
 struct numa_queue {
-- 
2.34.1


