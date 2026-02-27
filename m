Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01042FEFB6A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 16:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A003E6B0088; Fri, 27 Feb 2026 11:01:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95F196B008C; Fri, 27 Feb 2026 11:01:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CA26B0089; Fri, 27 Feb 2026 11:01:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5918B6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:01:16 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED9F2C28D1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:01:15 +0000 (UTC)
X-FDA: 84490700910.10.CD5F306
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf23.hostedemail.com (Postfix) with ESMTP id F2C8B140015
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:01:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Ve01KqIT;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772208074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vL2gmeWvIXcKqpbeZJOT58tvlHDLMuAurr2dMdDct3A=;
	b=dMJB6JKl+7bENwfILmlylak84hKri2iYs5xm1uJtR2LkJwSfUIkbpVmp0cXBL99RNm1wQb
	7YKftK2rqMr65Q59JXMtvToq1bpgAkwBFS5GuTRXb4OF47JMubILNgtErN/NNBHO+3S83s
	+7032UvpO+4XbLjpeNDMmaAmZeBw70Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Ve01KqIT;
	spf=pass (imf23.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772208074; a=rsa-sha256;
	cv=none;
	b=C31btOzRiHKDkLiGkydERp9L3WF8ys5vQ9aY4iYm86yWzmTgrjn13hy5hA3ECe2ccN1Syf
	sM2nqeMHa4a/HIOPvPqcz1zL1tkIA77tp9i9LrU1qYRKP4twD40EcM5TR0ABQtZrzeK4Dm
	HdP3pvs0ibWHeAg4jueB3z6pGzAHeHE=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 1095BB2E33;
	Fri, 27 Feb 2026 16:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772208072;
	bh=vL2gmeWvIXcKqpbeZJOT58tvlHDLMuAurr2dMdDct3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ve01KqITpLGHQ8GqeWzWYoY8WBzxqqlDBEIXDvb0e3G9boUo2qZvqP5SSWkX2H7QX
	 lMzk6o2fI2gBVG/+okSBQJnWXDUAtMv7O2f+CzCcyKAP/MMh0KLogICFizFm/Jhgdw
	 /nG6VP4fttxuHbSTD8PXdMlY1s+6+drq74v4vkX4=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	"linux-cxl@vger.kernel.orgkernel-team"@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v4 1/5] mm: introduce zone lock wrappers
Date: Fri, 27 Feb 2026 16:00:23 +0000
Message-ID: <849dee9c47df1e6fba97c9933af0d5a08b8e15d3.1772206930.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772206930.git.d@ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F2C8B140015
X-Rspamd-Server: rspam07
X-Stat-Signature: mgifkcyi8b94uixnsa3du5ze9uhhfydh
X-Rspam-User: 
X-HE-Tag: 1772208073-726550
X-HE-Meta: U2FsdGVkX19rLcbZcYtJk7bIRdm8pvcKt51xX8A9m5Gu38xFKRh4yHqgMb3jbh5shqp9OKVsyJnpn+mFPqXCdqHxcDIocngrOWCz+UhXkyhsICOzX035CmXOR39Qg5T4qDraxfEsnIsgn22bupcqGGnsSKvZ/wqeSV486gEHWXwToGV0ZvNmcbcSOk2u5YVJdEovW1PIXvSBZDT8LeYMVz36C0UkIUihJQcmTGo6sgSIzTfvZORYAJQI4oc5OGPZ2cLy97uXlQEtHUPUp8R32xPRJzYU5qQBBSy/IPPJDESudNka8DTEmanBaEsoZbDFjDIX8XQ5OsJ0byEl6YrXNb9ohFNQ0vuK4CmhHxKKSBZwQ0sjpB1HZpWZZ/5dQRfxUOHEK5G2x/afaJD/2qPn0B+3wHuOFNHRW7KLHF2fQIBIPXsyhO3ROt7mbQt1vCiyZ6kSKt75WtqIXEMm5q1rU4cTef93j+1z0DqwNpjbwBLUFQMRouSSD858r5+I8JRhdXrJfkmvaoQWhfjCYnGYcX2NTAhWYHRPReI+Yrjp6sq5nOd3OdXJo+NBAXH05czOmwISLhLCJNH4FXeQ4TgTHCg4SmWJxZhqsplAApjMDDdx1+O8FaGzLFkG69y5nwC4ToBPoUluNKHuglzuRJO77YBsQWE3ypztK3ad1rQlJHuUioKoyoW0u456+bO7BjZQOegLWxJBIXWqRhXm7AOUdXhzhFC7vSQrdd4OdyTi6tFBoXP2PaRnbRiXwavgvUL3U1wnM05pp4klXDWM3/4qfrhLpn0wC1vHlM85tfExopUWDhfU3Txogp2KfZk1w/6UymL7QhPjygaTDbpN2WV5fyoerqBS1Mq6rYdzH8+j7Ri1QKhCHmgCFrHg2CgnabOkZ0Ae8hsggSeosf8yuz8VyPdS7T+m/KtDJE6Bi7cs9AVmc0BUEQvfGSe+d/rRgqviAKOwBPEVpVOKE2QU3yh
 fgLTmtQA
 okLQeD6yez2JVRMHCQKzAs8n3pz0NUVFUI0BdlLmxztLqhOvu4SyOHzAHokXAVc5hKrQliUzEEtW/3K2ZkFc+KedZOBMR/PzYHs3nLTk+z2f8M7xjGeI2Syvud5J0Eei0zSJBx/4haoe6/2NjM/eZMK+fwwG+83HkPa8qOEDnKFOROODQhEOI8uyW7Dcko4AnFk7SsE6MNKrQZGGdZ0UVVe2jIJs/dGHLplnvPhUz8F4f1fgUVJiDA3TVM7m/kBQPbgkrAipj9ve89nMqVB7M+8mro5eiTj73Gu0exnS9fZeMaosk0XeHPLW5RxkQ4mJGCaCe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add thin wrappers around zone lock acquire/release operations. This
prepares the code for future tracepoint instrumentation without
modifying individual call sites.

Centralizing zone lock operations behind wrappers allows future
instrumentation or debugging hooks to be added without touching
all users.

No functional change intended. The wrappers are introduced in
preparation for subsequent patches and are not yet used.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 MAINTAINERS                 |  1 +
 include/linux/mmzone_lock.h | 38 +++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)
 create mode 100644 include/linux/mmzone_lock.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 55af015174a5..947298ecb111 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16672,6 +16672,7 @@ F:	include/linux/memory.h
 F:	include/linux/mm.h
 F:	include/linux/mm_*.h
 F:	include/linux/mmzone.h
+F:	include/linux/mmzone_lock.h
 F:	include/linux/mmdebug.h
 F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
diff --git a/include/linux/mmzone_lock.h b/include/linux/mmzone_lock.h
new file mode 100644
index 000000000000..a1cfba8408d6
--- /dev/null
+++ b/include/linux/mmzone_lock.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MMZONE_LOCK_H
+#define _LINUX_MMZONE_LOCK_H
+
+#include <linux/mmzone.h>
+#include <linux/spinlock.h>
+
+static inline void zone_lock_init(struct zone *zone)
+{
+	spin_lock_init(&zone->lock);
+}
+
+#define zone_lock_irqsave(zone, flags)				\
+do {								\
+	spin_lock_irqsave(&(zone)->lock, flags);		\
+} while (0)
+
+#define zone_trylock_irqsave(zone, flags)			\
+({								\
+	spin_trylock_irqsave(&(zone)->lock, flags);		\
+})
+
+static inline void zone_unlock_irqrestore(struct zone *zone, unsigned long flags)
+{
+	spin_unlock_irqrestore(&zone->lock, flags);
+}
+
+static inline void zone_lock_irq(struct zone *zone)
+{
+	spin_lock_irq(&zone->lock);
+}
+
+static inline void zone_unlock_irq(struct zone *zone)
+{
+	spin_unlock_irq(&zone->lock);
+}
+
+#endif /* _LINUX_MMZONE_LOCK_H */
-- 
2.47.3


