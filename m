Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E2ECA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 09:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 318E0900228; Fri, 15 Aug 2025 05:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9308E0002; Fri, 15 Aug 2025 05:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B833900228; Fri, 15 Aug 2025 05:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 076128E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:00:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C76DE16089E
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:00:28 +0000 (UTC)
X-FDA: 83778395736.09.7433799
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3A67F18000B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:00:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QfXlUFoJqgmHvB4kfrxDSe7CpMtX9KOJu7aPoYueG0I=;
	b=VJbTXOblXhw69DHfIkrdJSEnEHoVCqlVHEMVZanpYaxXUZTjkKqMfHOCb7I8mNA5YMijXx
	D2jCb8XNat5V6FJMhW+ocsxJ7IHSIJaMuCo8UdMcBB0Ql+MJcw1fch0pmzNrZ8CDSEVT4B
	4SKUKyGgjSE161OjrccB1fudIG1oE+E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248427; a=rsa-sha256;
	cv=none;
	b=EUXUZpoGpF1K+IInqh5/+EhcO8nqlmJAYKTZorG3eQuibefV8oo720zK1NFO1eCU0ZvUra
	82wZ+n4hT6a5vUoqZTUe8jxSjgMK1VYg0JI5ge9Rgh9j4QOAdw9qp06ahBruCFJf2zsOqK
	QStjFlKsRakm2ihJ+8gWdA6a5mev6KE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 614402C41;
	Fri, 15 Aug 2025 02:00:18 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 283233F63F;
	Fri, 15 Aug 2025 02:00:22 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Howells <dhowells@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v2 4/8] rcu: Allow processing kpkeys-protected data
Date: Fri, 15 Aug 2025 09:59:56 +0100
Message-ID: <20250815090000.2182450-5-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815090000.2182450-1-kevin.brodsky@arm.com>
References: <20250815090000.2182450-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3A67F18000B
X-Stat-Signature: h6bhms9upiwz8wznxt5qz65jz7gfxjoo
X-Rspam-User: 
X-HE-Tag: 1755248427-980869
X-HE-Meta: U2FsdGVkX18yf8Aw009E/T0ZKcIFCkQGmWSXEPsUaPL/yHp9HM7LOh0UCfdLDUnUZP6y3H82N7Rh+8FsaHmJTvctrT2wvFLVxiXYOzJHe51MawYdGliy18YXhdlxrHrymxIcItSDB3vEakQ2gJNNPDqudFA/d+Jt4wuba3OlebJFQ+4aOEc/uRYV6rKM5boThKY4mr+PHd3l/YCOhu7H5IsSDB3HUdiiS3qQTR6Az/t6fNCVPVVnbPidSGm6ahXwTq3l0nFmIVmB1UpdBji0vWaAHutvDQi2pOBfXx+CeoatRUst0gjNr7HQKako3kY//L9G3kQGstEVr0E7Q2vKWaYtokrmkdgjwgiWQNKUyiqqaJbks3aoOJJk7m+SSjg8CSDzg8b5u52M8fSQ8khNNdTtHOwajOx/ktJ5ybb7TaYEaRwm860wdpNiUR0CUqXV+HgQRduVPU9vNW3tU2EOzIjTQr1Uw7dr8R1els9zhpEmSFxQYNVVPxkWfiH1H7IEMsjqQmbZA0F88lvP2/JiDyTm/3sek5SkTCZsFHUbRSDViOQOELFvP4pcnW2JR76qiI5JUhAm0n3EqYu3LHtnqCMrU6OFyDLeyEIqFV6/rheR6TNiNRcd9O0dHPjInRVk7M9C6axIABd8rvneBpK6XBTop0SEjW+IGPP9epxBCvs0Omwxoi8ezRkKrD5KzRWigE0oPuJQBH2IRAJv7QsMvbohBGLxywRXr+aucFi6GFDLsbqB1MfbFCvLYmJDyOm1I7CsX+6Q9+0vM5CV+59QE5akiqQivtjQlmHYztkhoNtRo0zVTik/P3CZoAGdJPQ9UFZccnOiUYLFQGvyDbO3NuDfl7EvpUlUgZ0xgZcwS4VdRXkcXMcGT+T55C6mbMHOHxDODm6HzJNMZSA6K8tYW6abY/ARmw4zDguWIIorkDEP63pv/XYE7zbWyD8dVw0S7EeU96KyogqCVKX+IoO
 8FCPNQ8i
 r26vLMyAHqNCyYZ5NiFC+OQ0E6B3OnYw3V2Elg2FP85fEuc+MfAkI1FUCn3pow33ryIhLbFRfliBwuZc5NW1im4+BvvxQcLgSkUx/X84YN26qncBZfsJahSDspVbo/Ql+gt6WE7CMOrEIbcdNA1z5fJ/rOgRUg1NaL99qy6XW/69v8czSx/cNgb4Y6usGhxnEGprRRQ31rZos8476yjiwaoRFYGK+vdCtXCpg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Data assigned a non-default pkey is not writable at the default
kpkeys level. If such data is managed via RCU, some mechanism is
required to temporarily grant write access to the data's struct
rcu_head, for instance when zeroing the callback pointer.

There is unfortunately no straightforward way for RCU to know
whether the managed data is mapped with a non-default pkey. This
patch takes the easy route and switches to the unrestricted kpkeys
level whenever struct rcu_head is written; this should work reliably
but it is clearly suboptimal. That behaviour is enabled by
selecting CONFIG_KPKEYS_UNRESTRICTED_RCU.

This patch isn't comprehensive, in particular it does not take care
of Tiny RCU.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 kernel/rcu/rcu.h           |  7 +++++++
 kernel/rcu/rcu_segcblist.c | 13 +++++++++----
 kernel/rcu/tree.c          |  3 ++-
 mm/Kconfig                 |  2 ++
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index 9cf01832a6c3..71e9a695f4eb 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -10,6 +10,7 @@
 #ifndef __LINUX_RCU_H
 #define __LINUX_RCU_H
 
+#include <linux/kpkeys.h>
 #include <linux/slab.h>
 #include <trace/events/rcu.h>
 
@@ -691,4 +692,10 @@ int rcu_stall_notifier_call_chain(unsigned long val, void *v);
 static inline int rcu_stall_notifier_call_chain(unsigned long val, void *v) { return NOTIFY_DONE; }
 #endif // #else // #if defined(CONFIG_RCU_STALL_COMMON) && defined(CONFIG_RCU_CPU_STALL_NOTIFIER)
 
+#ifdef CONFIG_KPKEYS_UNRESTRICTED_RCU
+KPKEYS_GUARD(kpkeys_rcu, KPKEYS_LVL_UNRESTRICTED)
+#else
+KPKEYS_GUARD_NOOP(kpkeys_rcu)
+#endif
+
 #endif /* __LINUX_RCU_H */
diff --git a/kernel/rcu/rcu_segcblist.c b/kernel/rcu/rcu_segcblist.c
index 298a2c573f02..e7d6c8370b70 100644
--- a/kernel/rcu/rcu_segcblist.c
+++ b/kernel/rcu/rcu_segcblist.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 
+#include "rcu.h"
 #include "rcu_segcblist.h"
 
 /* Initialize simple callback list. */
@@ -332,7 +333,8 @@ void rcu_segcblist_enqueue(struct rcu_segcblist *rsclp,
 	rcu_segcblist_inc_len(rsclp);
 	rcu_segcblist_inc_seglen(rsclp, RCU_NEXT_TAIL);
 	rhp->next = NULL;
-	WRITE_ONCE(*rsclp->tails[RCU_NEXT_TAIL], rhp);
+	scoped_guard(kpkeys_rcu)
+		WRITE_ONCE(*rsclp->tails[RCU_NEXT_TAIL], rhp);
 	WRITE_ONCE(rsclp->tails[RCU_NEXT_TAIL], &rhp->next);
 }
 
@@ -360,7 +362,8 @@ bool rcu_segcblist_entrain(struct rcu_segcblist *rsclp,
 		if (!rcu_segcblist_segempty(rsclp, i))
 			break;
 	rcu_segcblist_inc_seglen(rsclp, i);
-	WRITE_ONCE(*rsclp->tails[i], rhp);
+	scoped_guard(kpkeys_rcu)
+		WRITE_ONCE(*rsclp->tails[i], rhp);
 	for (; i <= RCU_NEXT_TAIL; i++)
 		WRITE_ONCE(rsclp->tails[i], &rhp->next);
 	return true;
@@ -381,7 +384,8 @@ void rcu_segcblist_extract_done_cbs(struct rcu_segcblist *rsclp,
 	rclp->len = rcu_segcblist_get_seglen(rsclp, RCU_DONE_TAIL);
 	*rclp->tail = rsclp->head;
 	WRITE_ONCE(rsclp->head, *rsclp->tails[RCU_DONE_TAIL]);
-	WRITE_ONCE(*rsclp->tails[RCU_DONE_TAIL], NULL);
+	scoped_guard(kpkeys_rcu)
+		WRITE_ONCE(*rsclp->tails[RCU_DONE_TAIL], NULL);
 	rclp->tail = rsclp->tails[RCU_DONE_TAIL];
 	for (i = RCU_CBLIST_NSEGS - 1; i >= RCU_DONE_TAIL; i--)
 		if (rsclp->tails[i] == rsclp->tails[RCU_DONE_TAIL])
@@ -436,7 +440,8 @@ void rcu_segcblist_insert_done_cbs(struct rcu_segcblist *rsclp,
 	if (!rclp->head)
 		return; /* No callbacks to move. */
 	rcu_segcblist_add_seglen(rsclp, RCU_DONE_TAIL, rclp->len);
-	*rclp->tail = rsclp->head;
+	scoped_guard(kpkeys_rcu)
+		*rclp->tail = rsclp->head;
 	WRITE_ONCE(rsclp->head, rclp->head);
 	for (i = RCU_DONE_TAIL; i < RCU_CBLIST_NSEGS; i++)
 		if (&rsclp->head == rsclp->tails[i])
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 174ee243b349..2eada18c04d5 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2601,7 +2601,8 @@ static void rcu_do_batch(struct rcu_data *rdp)
 
 		f = rhp->func;
 		debug_rcu_head_callback(rhp);
-		WRITE_ONCE(rhp->func, (rcu_callback_t)0L);
+		scoped_guard(kpkeys_rcu)
+			WRITE_ONCE(rhp->func, (rcu_callback_t)0L);
 		f(rhp);
 
 		rcu_lock_release(&rcu_callback_map);
diff --git a/mm/Kconfig b/mm/Kconfig
index e34edf5c41e7..c023f74a2201 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1178,6 +1178,8 @@ config ARCH_HAS_KPKEYS
 # ARCH_HAS_KPKEYS must be selected when selecting this option
 config ARCH_HAS_KPKEYS_HARDENED_PGTABLES
 	bool
+config KPKEYS_UNRESTRICTED_RCU
+	bool
 
 config ARCH_USES_PG_ARCH_2
 	bool
-- 
2.47.0


