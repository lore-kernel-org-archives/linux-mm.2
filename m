Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D87F43858
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 16:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B50766B0093; Wed, 15 Apr 2026 12:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3E876B0095; Wed, 15 Apr 2026 12:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92CD06B0096; Wed, 15 Apr 2026 12:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A31D6B0095
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:47:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 419A88BD97
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:47:34 +0000 (UTC)
X-FDA: 84661371228.07.807E11A
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3DD83100007
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 16:47:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf14.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776271652; a=rsa-sha256;
	cv=none;
	b=AsghAR9ibuzFKopvANIVRq+4SlSj2tZjN+oHPWJXJ7jT4anRlXMhluhwqmlWboJFAoOkE1
	VZZbHXwe4by/Or65o9iGqWdLkuzw5v5RgoB9t7Mo0R6bk/YrNFCZoIlFAz1WRl1TFZTVSP
	aaDLhljlbAyflvBD4rLiLIWxLyRoZ4g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=h-partners.com;
	spf=pass (imf14.hostedemail.com: domain of fedorov.nikita@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=fedorov.nikita@h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776271652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rct3Z6RCFhg+pLwHspO85fLr3XG540WVaHSqSzhShv4=;
	b=nns0LEKKab4ivWgwzz1ImUUnUKfQ0s+4rzlOxYResC0zLMVZScUJa9SA1AVPLUC2NBsz4h
	0b0dI37SOzaJhuq9ply1/MYqKhBzp8VP5IIXWYGwPZ6bK4M7SvegWSIy0Xn44141qbqY49
	kUeBgdVHzRBobcICjcsNT5qlTYd4+6g=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fwn9M0FlXzJ46Dt;
	Thu, 16 Apr 2026 00:46:47 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 60A044057A;
	Thu, 16 Apr 2026 00:47:30 +0800 (CST)
Received: from localhost.localdomain (10.123.66.205) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Apr 2026 19:47:29 +0300
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
Subject: [RFC PATCH v3 5/7] kernel: introduce general hq-spinlock support
Date: Thu, 16 Apr 2026 00:44:57 +0800
Message-ID: <20260415164459.2904963-6-fedorov.nikita@h-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260415164459.2904963-1-fedorov.nikita@h-partners.com>
References: <20260415164459.2904963-1-fedorov.nikita@h-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.205]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 3DD83100007
X-Rspamd-Server: rspam12
X-Stat-Signature: m16zoqf81s7hdhy8usryznqum31h7rj8
X-Rspam-User: 
X-HE-Tag: 1776271651-370116
X-HE-Meta: U2FsdGVkX1/T4X/rE+x117c5uIMYCYhyrUVXuskJ9fMgJpvpQxMZ7yTjEl5XK2N3n38hkCYtcBJI0rpGkxQrg8bANoJZ4bFqm3J7H/Vdu+Y3lNfHjnJhA4tSR8NKWLUuR60ddBwvjSUPe8/mHbfTYlfOfZNFKNFcYL8/OBexI7fFtzjT4ekdPKtaGZ7CeV5kSL+Zars6feBgu5HyoawVVwiGvs8zzFiWFyiswxmcS4JKOm5aDqozZd0q+E9qBUM/GdY/Ex1r96340PsEAJl7mnS9JYX530IYgeEZj4W58c9HAvHogm5q4DiaZtOE/7rePQC9KUDF1lC+mdK0HUGDAhHyW2hcStNfuDRVnO8CT/2UXAIKGvKYfZBGcjc6vv3KicU5AsSRveUw3Gf+RPb2UEcfBOXbl50DiOVFuj4nHaRE164eOsE8220iZWyuye1TFHrAp5oZVijPxtMyBspc0VHtNmukCK1Fex+m6kn/3iDkFJAO+AZ5rB66Zo68c18K4cxXQXXLRu0Bpac76Jbe778kcR4Ecu/nC06wz5sL2+U4d19WDI/tt3gooIBsPa3PE608Bpb2sblAD3IcZDmsFxnUWB5GuAZWS5D9uXf0zJi77qZTq3Bv9xh9BKOUI0f2fyKRZ8iB7I7kPhX5as7v7vTS7cuGiB8eKn6fcj79TIUxdK974L1kqtHhfj5zfYx1x5S6nqlZi1exC7gdyJXPpCVnrUIXBcWbOiXSFd0hFk3FduRhNJNUHqIvYkLaSJP1ugTVt6xB1HcYndTKalVhnhwyAtvqiWtyfipsKNZ83a1RENaQpO8DspfYFfu8qYBHBlFptpM4jYDnyLFUjyDjrktdKMlAFK4N2NqwxrBIWEClZdxV7haVxJT83b3p/DBSo+y6ULysGhF/JDFSOGhM57/w30yHUrszme/cf8gHTIwC+vMmmc0hS8PJG+2ORL1CLkKzi9UKfaUkIHCNnFO
 J0TXkRsF
 RYy4KBjE/5DRdPMracOXpcRuVpgrrzeJcNBZvfFJm/gwrdrmXUpWvLzsdya9QLqfOAnYXvTp1GQHc5eX6h8oKMBYw42/Yvd3Cc2T4RX2qzHGEnWuaotVjXJZH36Q7yi+6461tErrce3HDSEKH2sDDqHwSlG3bXHeL8RfvIDlmjJGP9PSYwFKaKdJguxKDT0MnAech+yoP82dX6rlze6NO6qMR37PjI9bJQJQ0UuG69/mijgSKwfzqjz4B0u7+7+eJdZGyLLiOTAydE04xbw7rGc5ezU6Gkv0XdoctfAAAGfbdCok2C4Y1uOKuIGTU56i9PoVXtczELDdNjwQJ4cxDqz10bv5hBaT34QPQLPm/PJWCt7gdYaC7hBwMurSYSIl3HTUw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Integrate HQ spinlocks into the generic queued spinlock code.
It includes:
- Kernel config
- Required macros
- PV-locks support
- HQ-lock type/mode masking support in generic code
- Integration hq-spinlock into queued spinlock slowpath

Now hq-spinlock can be enabled with:
- `spin_lock_init_hq()` for dynamic locks
- `DEFINE_SPINLOCK_HQ()` for static locks

Co-developed-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
Signed-off-by: Anatoly Stepanov <stepanov.anatoly@huawei.com>
Co-developed-by: Nikita Fedorov <fedorov.nikita@h-partners.com>
Signed-off-by: Nikita Fedorov <fedorov.nikita@h-partners.com>
---
 arch/arm64/include/asm/qspinlock.h       | 37 ++++++++++++
 arch/x86/include/asm/hq-spinlock.h       | 34 +++++++++++
 arch/x86/include/asm/paravirt-spinlock.h |  3 +-
 arch/x86/include/asm/qspinlock.h         |  6 +-
 include/asm-generic/qspinlock.h          | 23 ++++---
 include/linux/spinlock.h                 | 26 ++++++++
 include/linux/spinlock_types.h           | 26 ++++++++
 include/linux/spinlock_types_raw.h       | 20 ++++++
 kernel/Kconfig.locks                     | 29 +++++++++
 kernel/locking/hqlock_core.h             | 77 ++++++++++++++++++++++++
 kernel/locking/qspinlock.c               | 65 +++++++++++++++++---
 kernel/locking/qspinlock.h               |  4 +-
 kernel/locking/spinlock_debug.c          | 20 ++++++
 mm/mempolicy.c                           |  4 ++
 14 files changed, 352 insertions(+), 22 deletions(-)
 create mode 100644 arch/arm64/include/asm/qspinlock.h
 create mode 100644 arch/x86/include/asm/hq-spinlock.h

diff --git a/arch/arm64/include/asm/qspinlock.h b/arch/arm64/include/asm/qspinlock.h
new file mode 100644
index 0000000000..5b8b1ca0f4
--- /dev/null
+++ b/arch/arm64/include/asm/qspinlock.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_ARM64_QSPINLOCK_H
+#define _ASM_ARM64_QSPINLOCK_H
+
+#ifdef CONFIG_HQSPINLOCKS
+
+extern void hq_configure_spin_lock_slowpath(void);
+
+extern void (*hq_queued_spin_lock_slowpath)(struct qspinlock *lock, u32 val);
+extern void native_queued_spin_lock_slowpath(struct qspinlock *lock, u32 val);
+
+#define	queued_spin_unlock queued_spin_unlock
+/**
+ * queued_spin_unlock - release a queued spinlock
+ * @lock : Pointer to queued spinlock structure
+ *
+ * A smp_store_release() on the least-significant byte.
+ */
+static inline void native_queued_spin_unlock(struct qspinlock *lock)
+{
+	smp_store_release(&lock->locked, 0);
+}
+
+static inline void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
+{
+	hq_queued_spin_lock_slowpath(lock, val);
+}
+
+static inline void queued_spin_unlock(struct qspinlock *lock)
+{
+	native_queued_spin_unlock(lock);
+}
+#endif
+
+#include <asm-generic/qspinlock.h>
+
+#endif /* _ASM_ARM64_QSPINLOCK_H */
diff --git a/arch/x86/include/asm/hq-spinlock.h b/arch/x86/include/asm/hq-spinlock.h
new file mode 100644
index 0000000000..f4b088164b
--- /dev/null
+++ b/arch/x86/include/asm/hq-spinlock.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_X86_HQ_SPINLOCK_H
+#define _ASM_X86_HQ_SPINLOCK_H
+
+extern void hq_configure_spin_lock_slowpath(void);
+
+#ifndef CONFIG_PARAVIRT_SPINLOCKS
+extern void (*hq_queued_spin_lock_slowpath)(struct qspinlock *lock, u32 val);
+extern void native_queued_spin_lock_slowpath(struct qspinlock *lock, u32 val);
+
+#define	queued_spin_unlock queued_spin_unlock
+/**
+ * queued_spin_unlock - release a queued spinlock
+ * @lock : Pointer to queued spinlock structure
+ *
+ * A smp_store_release() on the least-significant byte.
+ */
+static inline void native_queued_spin_unlock(struct qspinlock *lock)
+{
+	smp_store_release(&lock->locked, 0);
+}
+
+static inline void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
+{
+	hq_queued_spin_lock_slowpath(lock, val);
+}
+
+static inline void queued_spin_unlock(struct qspinlock *lock)
+{
+	native_queued_spin_unlock(lock);
+}
+#endif // !CONFIG_PARAVIRT_SPINLOCKS
+
+#endif // _ASM_X86_HQ_SPINLOCK_H
diff --git a/arch/x86/include/asm/paravirt-spinlock.h b/arch/x86/include/asm/paravirt-spinlock.h
index 7beffcb08e..9c37d6b47b 100644
--- a/arch/x86/include/asm/paravirt-spinlock.h
+++ b/arch/x86/include/asm/paravirt-spinlock.h
@@ -134,7 +134,8 @@ static inline bool virt_spin_lock(struct qspinlock *lock)
  __retry:
 	val = atomic_read(&lock->val);
 
-	if (val || !atomic_try_cmpxchg(&lock->val, &val, _Q_LOCKED_VAL)) {
+	if ((val & ~_Q_SERVICE_MASK) ||
+	     !atomic_try_cmpxchg(&lock->val, &val, _Q_LOCKED_VAL | (val & _Q_SERVICE_MASK))) {
 		cpu_relax();
 		goto __retry;
 	}
diff --git a/arch/x86/include/asm/qspinlock.h b/arch/x86/include/asm/qspinlock.h
index 25a1919542..13950221eb 100644
--- a/arch/x86/include/asm/qspinlock.h
+++ b/arch/x86/include/asm/qspinlock.h
@@ -11,6 +11,10 @@
 #include <asm/paravirt-spinlock.h>
 #endif
 
+#ifdef CONFIG_HQSPINLOCKS
+#include <asm/hq-spinlock.h>
+#endif
+
 #define _Q_PENDING_LOOPS	(1 << 9)
 
 #define queued_fetch_set_pending_acquire queued_fetch_set_pending_acquire
@@ -25,7 +29,7 @@ static __always_inline u32 queued_fetch_set_pending_acquire(struct qspinlock *lo
 	 */
 	val = GEN_BINARY_RMWcc(LOCK_PREFIX "btsl", lock->val.counter, c,
 			       "I", _Q_PENDING_OFFSET) * _Q_PENDING_VAL;
-	val |= atomic_read(&lock->val) & ~_Q_PENDING_MASK;
+	val |= atomic_read(&lock->val) & ~_Q_PENDING_VAL;
 
 	return val;
 }
diff --git a/include/asm-generic/qspinlock.h b/include/asm-generic/qspinlock.h
index bf47cca2c3..af3ab0286e 100644
--- a/include/asm-generic/qspinlock.h
+++ b/include/asm-generic/qspinlock.h
@@ -54,7 +54,7 @@ static __always_inline int queued_spin_is_locked(struct qspinlock *lock)
 	 * Any !0 state indicates it is locked, even if _Q_LOCKED_VAL
 	 * isn't immediately observable.
 	 */
-	return atomic_read(&lock->val);
+	return atomic_read(&lock->val) & ~_Q_SERVICE_MASK;
 }
 #endif
 
@@ -70,7 +70,7 @@ static __always_inline int queued_spin_is_locked(struct qspinlock *lock)
  */
 static __always_inline int queued_spin_value_unlocked(struct qspinlock lock)
 {
-	return !lock.val.counter;
+	return !(lock.val.counter & ~_Q_SERVICE_MASK);
 }
 
 /**
@@ -80,8 +80,10 @@ static __always_inline int queued_spin_value_unlocked(struct qspinlock lock)
  */
 static __always_inline int queued_spin_is_contended(struct qspinlock *lock)
 {
-	return atomic_read(&lock->val) & ~_Q_LOCKED_MASK;
+	return atomic_read(&lock->val) & ~(_Q_LOCKED_MASK | _Q_SERVICE_MASK);
 }
+
+#ifndef queued_spin_trylock
 /**
  * queued_spin_trylock - try to acquire the queued spinlock
  * @lock : Pointer to queued spinlock structure
@@ -91,11 +93,12 @@ static __always_inline int queued_spin_trylock(struct qspinlock *lock)
 {
 	int val = atomic_read(&lock->val);
 
-	if (unlikely(val))
+	if (unlikely(val & ~_Q_SERVICE_MASK))
 		return 0;
 
-	return likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL));
+	return likely(atomic_try_cmpxchg_acquire(&lock->val, &val, val | _Q_LOCKED_VAL));
 }
+#endif
 
 extern void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val);
 
@@ -106,14 +109,16 @@ extern void queued_spin_lock_slowpath(struct qspinlock *lock, u32 val);
  */
 static __always_inline void queued_spin_lock(struct qspinlock *lock)
 {
-	int val = 0;
+	int val = atomic_read(&lock->val);
 
-	if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, _Q_LOCKED_VAL)))
-		return;
+	if (likely(!(val & ~_Q_SERVICE_MASK))) {
+		if (likely(atomic_try_cmpxchg_acquire(&lock->val, &val, val | _Q_LOCKED_VAL)))
+			return;
+	}
 
 	queued_spin_lock_slowpath(lock, val);
 }
-#endif
+#endif // queued_spin_lock
 
 #ifndef queued_spin_unlock
 /**
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index e1e2f144af..e953018934 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -100,6 +100,8 @@
 #ifdef CONFIG_DEBUG_SPINLOCK
   extern void __raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
 				   struct lock_class_key *key, short inner);
+  extern void __raw_spin_lock_init_hq(raw_spinlock_t *lock, const char *name,
+				   struct lock_class_key *key, short inner);
 
 # define raw_spin_lock_init(lock)					\
 do {									\
@@ -108,9 +110,19 @@ do {									\
 	__raw_spin_lock_init((lock), #lock, &__key, LD_WAIT_SPIN);	\
 } while (0)
 
+# define raw_spin_lock_init_hq(lock)					\
+do {									\
+	static struct lock_class_key __key;				\
+									\
+	__raw_spin_lock_init_hq((lock), #lock, &__key, LD_WAIT_SPIN);	\
+} while (0)
+
 #else
 # define raw_spin_lock_init(lock)				\
 	do { *(lock) = __RAW_SPIN_LOCK_UNLOCKED(lock); } while (0)
+
+# define raw_spin_lock_init_hq(lock)				\
+	do { *(lock) = __RAW_SPIN_LOCK_UNLOCKED_HQ(lock); } while (0)
 #endif
 
 #define raw_spin_is_locked(lock)	arch_spin_is_locked(&(lock)->raw_lock)
@@ -325,6 +337,14 @@ do {								\
 			     #lock, &__key, LD_WAIT_CONFIG);	\
 } while (0)
 
+# define spin_lock_init_hq(lock)					\
+do {								\
+	static struct lock_class_key __key;			\
+								\
+	__raw_spin_lock_init_hq(spinlock_check(lock),		\
+			     #lock, &__key, LD_WAIT_CONFIG);	\
+} while (0)
+
 #else
 
 # define spin_lock_init(_lock)			\
@@ -333,6 +353,12 @@ do {						\
 	*(_lock) = __SPIN_LOCK_UNLOCKED(_lock);	\
 } while (0)
 
+# define spin_lock_init_hq(_lock)			\
+do {						\
+	spinlock_check(_lock);			\
+	*(_lock) = __SPIN_LOCK_UNLOCKED_HQ(_lock);	\
+} while (0)
+
 #endif
 
 static __always_inline void spin_lock(spinlock_t *lock)
diff --git a/include/linux/spinlock_types.h b/include/linux/spinlock_types.h
index b65bb6e445..ad68f6ad8d 100644
--- a/include/linux/spinlock_types.h
+++ b/include/linux/spinlock_types.h
@@ -43,6 +43,29 @@ typedef struct spinlock spinlock_t;
 
 #define DEFINE_SPINLOCK(x)	spinlock_t x = __SPIN_LOCK_UNLOCKED(x)
 
+#ifdef __ARCH_SPIN_LOCK_UNLOCKED_HQ
+#define ___SPIN_LOCK_INITIALIZER_HQ(lockname)	\
+	{					\
+	.raw_lock = __ARCH_SPIN_LOCK_UNLOCKED_HQ,	\
+	SPIN_DEBUG_INIT(lockname)		\
+	SPIN_DEP_MAP_INIT(lockname) }
+
+#else
+#define ___SPIN_LOCK_INITIALIZER_HQ(lockname)	\
+	{					\
+	.raw_lock = __ARCH_SPIN_LOCK_UNLOCKED,	\
+	SPIN_DEBUG_INIT(lockname)		\
+	SPIN_DEP_MAP_INIT(lockname) }
+#endif
+
+#define __SPIN_LOCK_INITIALIZER_HQ(lockname) \
+	{ { .rlock = ___SPIN_LOCK_INITIALIZER_HQ(lockname) } }
+
+#define __SPIN_LOCK_UNLOCKED_HQ(lockname) \
+	((spinlock_t) __SPIN_LOCK_INITIALIZER_HQ(lockname))
+
+#define DEFINE_SPINLOCK_HQ(x) spinlock_t x = __SPIN_LOCK_UNLOCKED_HQ(x)
+
 #else /* !CONFIG_PREEMPT_RT */
 
 /* PREEMPT_RT kernels map spinlock to rt_mutex */
@@ -71,6 +94,9 @@ typedef struct spinlock spinlock_t;
 #define DEFINE_SPINLOCK(name)					\
 	spinlock_t name = __SPIN_LOCK_UNLOCKED(name)
 
+#define DEFINE_SPINLOCK_HQ(name)					\
+	spinlock_t name = __SPIN_LOCK_UNLOCKED(name)
+
 #endif /* CONFIG_PREEMPT_RT */
 
 #include <linux/rwlock_types.h>
diff --git a/include/linux/spinlock_types_raw.h b/include/linux/spinlock_types_raw.h
index e5644ab216..0e4126a23b 100644
--- a/include/linux/spinlock_types_raw.h
+++ b/include/linux/spinlock_types_raw.h
@@ -71,4 +71,24 @@ typedef struct raw_spinlock raw_spinlock_t;
 
 #define DEFINE_RAW_SPINLOCK(x)  raw_spinlock_t x = __RAW_SPIN_LOCK_UNLOCKED(x)
 
+#ifdef __ARCH_SPIN_LOCK_UNLOCKED_HQ
+#define __RAW_SPIN_LOCK_INITIALIZER_HQ(lockname)	\
+{						\
+	.raw_lock = __ARCH_SPIN_LOCK_UNLOCKED_HQ,	\
+	SPIN_DEBUG_INIT(lockname)		\
+	RAW_SPIN_DEP_MAP_INIT(lockname) }
+
+#else
+#define __RAW_SPIN_LOCK_INITIALIZER_HQ(lockname)	\
+{						\
+	.raw_lock = __ARCH_SPIN_LOCK_UNLOCKED,	\
+	SPIN_DEBUG_INIT(lockname)		\
+	RAW_SPIN_DEP_MAP_INIT(lockname) }
+#endif
+
+#define __RAW_SPIN_LOCK_UNLOCKED_HQ(lockname)	\
+	((raw_spinlock_t) __RAW_SPIN_LOCK_INITIALIZER_HQ(lockname))
+
+#define DEFINE_RAW_SPINLOCK_HQ(x)  raw_spinlock_t x = __RAW_SPIN_LOCK_UNLOCKED_HQ(x)
+
 #endif /* __LINUX_SPINLOCK_TYPES_RAW_H */
diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index 4198f0273e..c96f3a4551 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -243,6 +243,35 @@ config QUEUED_SPINLOCKS
 	def_bool y if ARCH_USE_QUEUED_SPINLOCKS
 	depends on SMP
 
+config HQSPINLOCKS
+	bool "(NUMA-aware) Hierarchical Queued spinlock"
+	depends on NUMA
+	depends on QUEUED_SPINLOCKS
+	depends on NR_CPUS < 16384
+	depends on !CPU_BIG_ENDIAN
+	help
+	  Introduce NUMA (Non Uniform Memory Access) awareness into
+	  the slow path of kernel's spinlocks.
+
+	  We preallocate 'LOCK_ID_MAX' lock_metadata structures with corresponing per-NUMA queues,
+	  and the first queueing contender finds metadata corresponding to its lock by lock's hash and occupies it.
+	  If the metadata is already occupied, perform fallback to default qspinlock approach.
+	  Upcomming contenders then exchange the tail of per-NUMA queue instead of global tail,
+	  and until threshold is reached, we pass the lock to the condenters from the local queue.
+	  At the global tail we keep NUMA nodes to maintain FIFO on per-node level.
+
+	  That approach helps to reduce cross-numa accesses and thus improve lock's performance
+	  in high-load scenarios on multi-NUMA node machines.
+
+	  Say N, if you want absolute first come first serve fairness.
+
+config HQSPINLOCKS_DEBUG
+	bool "Enable debug output for numa-aware spinlocks"
+	depends on HQSPINLOCKS
+	default n
+	help
+	  This option enables statistics for dynamic metadata allocation for HQspinlock
+
 config BPF_ARCH_SPINLOCK
 	bool
 
diff --git a/kernel/locking/hqlock_core.h b/kernel/locking/hqlock_core.h
index b7681915b4..74f92ac3d8 100644
--- a/kernel/locking/hqlock_core.h
+++ b/kernel/locking/hqlock_core.h
@@ -771,3 +771,80 @@ static inline void hqlock_handoff(struct qspinlock *lock,
 	handoff_remote(lock, qnode, tail, handoff_info);
 	reset_handoff_counter(qnode);
 }
+
+static void __init hqlock_alloc_global_queues(void)
+{
+	int nid;
+	unsigned long meta_pool_size, queues_size;
+
+	meta_pool_size = ALIGN(sizeof(struct lock_metadata), L1_CACHE_BYTES) * LOCK_ID_MAX;
+
+	pr_info("Init HQspinlock lock_metadata info: size = 0x%lx B\n",
+		meta_pool_size);
+
+	meta_pool = kvzalloc(meta_pool_size, GFP_KERNEL);
+
+	if (!meta_pool)
+		panic("HQspinlock lock_metadata metadata info: allocation failure.\n");
+
+	for (int i = 0; i < LOCK_ID_MAX; i++)
+		atomic_set(&meta_pool[i].seq_counter, 0);
+
+	queues_size = LOCK_ID_MAX * ALIGN(sizeof(struct numa_queue), L1_CACHE_BYTES);
+
+	pr_info("Init HQspinlock per-NUMA metadata (per-node size = 0x%lx B)\n",
+		queues_size);
+
+	for_each_node(nid) {
+		queue_table[nid] = kvzalloc_node(queues_size, GFP_KERNEL, nid);
+
+		if (!queue_table[nid])
+			panic("HQspinlock per-NUMA metadata: allocation failure for node %d.\n", nid);
+	}
+}
+
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+#define hq_queued_spin_lock_slowpath	pv_ops_lock.queued_spin_lock_slowpath
+#else
+void (*hq_queued_spin_lock_slowpath)(struct qspinlock *lock, u32 val) =
+		native_queued_spin_lock_slowpath;
+EXPORT_SYMBOL(hq_queued_spin_lock_slowpath);
+#endif
+
+static int numa_spinlock_flag;
+
+static int __init numa_spinlock_setup(char *str)
+{
+	if (!strcmp(str, "auto")) {
+		numa_spinlock_flag = 0;
+		return 1;
+	} else if (!strcmp(str, "on")) {
+		numa_spinlock_flag = 1;
+		return 1;
+	} else if (!strcmp(str, "off")) {
+		numa_spinlock_flag = -1;
+		return 1;
+	}
+
+	return 0;
+}
+__setup("numa_spinlock=", numa_spinlock_setup);
+
+void __hq_queued_spin_lock_slowpath(struct qspinlock *lock, u32 val);
+
+void __init hq_configure_spin_lock_slowpath(void)
+{
+	if (numa_spinlock_flag < 0)
+		return;
+
+	if (numa_spinlock_flag == 0 && (nr_node_ids < 2 ||
+		    hq_queued_spin_lock_slowpath !=
+			native_queued_spin_lock_slowpath)) {
+		return;
+	}
+
+	numa_spinlock_flag = 1;
+	hq_queued_spin_lock_slowpath = __hq_queued_spin_lock_slowpath;
+	pr_info("Enabling HQspinlock\n");
+	hqlock_alloc_global_queues();
+}
diff --git a/kernel/locking/qspinlock.c b/kernel/locking/qspinlock.c
index af8d122bb6..7feab0046e 100644
--- a/kernel/locking/qspinlock.c
+++ b/kernel/locking/qspinlock.c
@@ -11,7 +11,7 @@
  *          Peter Zijlstra <peterz@infradead.org>
  */
 
-#ifndef _GEN_PV_LOCK_SLOWPATH
+#if !defined(_GEN_PV_LOCK_SLOWPATH) && !defined(_GEN_HQ_SPINLOCK_SLOWPATH)
 
 #include <linux/smp.h>
 #include <linux/bug.h>
@@ -100,7 +100,7 @@ static __always_inline u32  __pv_wait_head_or_lock(struct qspinlock *lock,
 #define pv_kick_node		__pv_kick_node
 #define pv_wait_head_or_lock	__pv_wait_head_or_lock
 
-#ifdef CONFIG_PARAVIRT_SPINLOCKS
+#if defined(CONFIG_PARAVIRT_SPINLOCKS) || defined(CONFIG_HQSPINLOCKS)
 #define queued_spin_lock_slowpath	native_queued_spin_lock_slowpath
 #endif
 
@@ -133,6 +133,11 @@ void __lockfunc queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	u32 old, tail;
 	int idx;
 
+#if defined(_GEN_HQ_SPINLOCK_SLOWPATH) && !defined(_GEN_PV_LOCK_SLOWPATH)
+	bool is_numa_lock = val & _Q_LOCKTYPE_MASK;
+	bool numa_awareness_on = is_numa_lock && !(val & _Q_LOCK_MODE_QSPINLOCK_VAL);
+#endif
+
 	BUILD_BUG_ON(CONFIG_NR_CPUS >= (1U << _Q_TAIL_CPU_BITS));
 
 	if (pv_enabled())
@@ -147,16 +152,16 @@ void __lockfunc queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	 *
 	 * 0,1,0 -> 0,0,1
 	 */
-	if (val == _Q_PENDING_VAL) {
+	if ((val & ~_Q_SERVICE_MASK) == _Q_PENDING_VAL) {
 		int cnt = _Q_PENDING_LOOPS;
 		val = atomic_cond_read_relaxed(&lock->val,
-					       (VAL != _Q_PENDING_VAL) || !cnt--);
+						((VAL & ~_Q_SERVICE_MASK) != _Q_PENDING_VAL) || !cnt--);
 	}
 
 	/*
 	 * If we observe any contention; queue.
 	 */
-	if (val & ~_Q_LOCKED_MASK)
+	if (val & ~(_Q_LOCKED_MASK | _Q_SERVICE_MASK))
 		goto queue;
 
 	/*
@@ -173,11 +178,15 @@ void __lockfunc queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	 * n,0,0 -> 0,0,0 transition fail and it will now be waiting
 	 * on @next to become !NULL.
 	 */
-	if (unlikely(val & ~_Q_LOCKED_MASK)) {
-
+	if (unlikely(val & ~(_Q_LOCKED_MASK | _Q_SERVICE_MASK))) {
 		/* Undo PENDING if we set it. */
-		if (!(val & _Q_PENDING_MASK))
+		if (!(val & _Q_PENDING_VAL)) {
+#if defined(_GEN_HQ_SPINLOCK_SLOWPATH) && !defined(_GEN_PV_LOCK_SLOWPATH)
+			hqlock_clear_pending(lock, val);
+#else
 			clear_pending(lock);
+#endif
+		}
 
 		goto queue;
 	}
@@ -194,14 +203,18 @@ void __lockfunc queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	 * barriers.
 	 */
 	if (val & _Q_LOCKED_MASK)
-		smp_cond_load_acquire(&lock->locked, !VAL);
+		smp_cond_load_acquire(&lock->locked_pending, !(VAL & _Q_LOCKED_MASK));
 
 	/*
 	 * take ownership and clear the pending bit.
 	 *
 	 * 0,1,0 -> 0,0,1
 	 */
+#if defined(_GEN_HQ_SPINLOCK_SLOWPATH) && !defined(_GEN_PV_LOCK_SLOWPATH)
+	hqlock_clear_pending_set_locked(lock, val);
+#else
 	clear_pending_set_locked(lock);
+#endif
 	lockevent_inc(lock_pending);
 	return;
 
@@ -274,7 +287,17 @@ void __lockfunc queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	 *
 	 * p,*,* -> n,*,*
 	 */
+#if defined(_GEN_HQ_SPINLOCK_SLOWPATH) && !defined(_GEN_PV_LOCK_SLOWPATH)
+	if (is_numa_lock)
+		old = hqlock_xchg_tail(lock, tail, node, &numa_awareness_on);
+	else
+		old = xchg_tail(lock, tail);
+
+	if (numa_awareness_on && old == Q_NEW_NODE_QUEUE)
+		goto mcs_spin;
+#else
 	old = xchg_tail(lock, tail);
+#endif
 	next = NULL;
 
 	/*
@@ -288,6 +311,9 @@ void __lockfunc queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 		WRITE_ONCE(prev->next, node);
 
 		pv_wait_node(node, prev);
+#if defined(_GEN_HQ_SPINLOCK_SLOWPATH) && !defined(_GEN_PV_LOCK_SLOWPATH)
+mcs_spin:
+#endif
 		arch_mcs_spin_lock_contended(&node->locked);
 
 		/*
@@ -349,6 +375,12 @@ void __lockfunc queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 	 *       above wait condition, therefore any concurrent setting of
 	 *       PENDING will make the uncontended transition fail.
 	 */
+#if defined(_GEN_HQ_SPINLOCK_SLOWPATH) && !defined(_GEN_PV_LOCK_SLOWPATH)
+	if (is_numa_lock) {
+		hqlock_clear_tail_handoff(lock, val, tail, node, next, prev, numa_awareness_on);
+		goto release;
+	}
+#endif
 	if ((val & _Q_TAIL_MASK) == tail) {
 		if (atomic_try_cmpxchg_relaxed(&lock->val, &val, _Q_LOCKED_VAL))
 			goto release; /* No contention */
@@ -380,6 +412,21 @@ void __lockfunc queued_spin_lock_slowpath(struct qspinlock *lock, u32 val)
 }
 EXPORT_SYMBOL(queued_spin_lock_slowpath);
 
+/* Generate the code for NUMA-aware qspinlock (HQspinlock) */
+#if !defined(_GEN_HQ_SPINLOCK_SLOWPATH) && defined(CONFIG_HQSPINLOCKS)
+#define _GEN_HQ_SPINLOCK_SLOWPATH
+
+#undef pv_init_node
+#define pv_init_node		hqlock_init_node
+
+#undef  queued_spin_lock_slowpath
+#include "hqlock_core.h"
+#define queued_spin_lock_slowpath	__hq_queued_spin_lock_slowpath
+
+#include "qspinlock.c"
+
+#endif
+
 /*
  * Generate the paravirt code for queued_spin_unlock_slowpath().
  */
diff --git a/kernel/locking/qspinlock.h b/kernel/locking/qspinlock.h
index d69958a844..9933e0e666 100644
--- a/kernel/locking/qspinlock.h
+++ b/kernel/locking/qspinlock.h
@@ -39,7 +39,7 @@
  */
 struct qnode {
 	struct mcs_spinlock mcs;
-#ifdef CONFIG_PARAVIRT_SPINLOCKS
+#if defined(CONFIG_PARAVIRT_SPINLOCKS) || defined(CONFIG_HQSPINLOCKS)
 	long reserved[2];
 #endif
 };
@@ -74,7 +74,7 @@ struct mcs_spinlock *grab_mcs_node(struct mcs_spinlock *base, int idx)
 	return &((struct qnode *)base + idx)->mcs;
 }
 
-#define _Q_LOCKED_PENDING_MASK (_Q_LOCKED_MASK | _Q_PENDING_MASK)
+#define _Q_LOCKED_PENDING_MASK (_Q_LOCKED_MASK | _Q_PENDING_VAL)
 
 #if _Q_PENDING_BITS == 8
 /**
diff --git a/kernel/locking/spinlock_debug.c b/kernel/locking/spinlock_debug.c
index 2338b3adfb..f31d13cbc5 100644
--- a/kernel/locking/spinlock_debug.c
+++ b/kernel/locking/spinlock_debug.c
@@ -30,6 +30,26 @@ void __raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
 	lock->owner_cpu = -1;
 }
 
+void __raw_spin_lock_init_hq(raw_spinlock_t *lock, const char *name,
+			  struct lock_class_key *key, short inner)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/*
+	 * Make sure we are not reinitializing a held lock:
+	 */
+	debug_check_no_locks_freed((void *)lock, sizeof(*lock));
+	lockdep_init_map_wait(&lock->dep_map, name, key, 0, inner);
+#endif
+#ifdef __ARCH_SPIN_LOCK_UNLOCKED_HQ
+	lock->raw_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED_HQ;
+#else
+	lock->raw_lock = (arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+#endif
+	lock->magic = SPINLOCK_MAGIC;
+	lock->owner = SPINLOCK_OWNER_INIT;
+	lock->owner_cpu = -1;
+}
+
 EXPORT_SYMBOL(__raw_spin_lock_init);
 
 #ifndef CONFIG_PREEMPT_RT
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index cf92bd6a82..e2bc6646ce 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -3383,6 +3383,10 @@ void __init numa_policy_init(void)
 		pr_err("%s: interleaving failed\n", __func__);
 
 	check_numabalancing_enable();
+
+#ifdef CONFIG_HQSPINLOCKS
+	hq_configure_spin_lock_slowpath();
+#endif
 }
 
 /* Reset policy of current process to default */
-- 
2.34.1


