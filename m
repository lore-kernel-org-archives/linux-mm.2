Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D9DFE9E31E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 15:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7336F6B0005; Wed, 11 Feb 2026 10:23:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E17B6B0089; Wed, 11 Feb 2026 10:23:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C2D96B008A; Wed, 11 Feb 2026 10:23:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 485CF6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:23:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F16AB58C4C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:23:25 +0000 (UTC)
X-FDA: 84432544770.27.D98D075
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf25.hostedemail.com (Postfix) with ESMTP id 444D9A000A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:23:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=GCLbBzEz;
	spf=pass (imf25.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770823404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7pIPpettLlSQoHWOm1p7EtiixS7ksKzCY9xzpT+daI=;
	b=GUiNfRm2ThfWPSkcLXVfunT0KWJYVIOoMoSlUDcAL91oAB8v8WpWWeZGlHHoKwWRJoO51r
	c8KkK8R5lL1KHaj4gMQkgcGqiKwuzn1VftY5kxSyBgarqySlAWDB/DqNnhXoJcKjBAYmIS
	BvXC/9aOlo16Z7rm9fAST466lPJNSdw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=GCLbBzEz;
	spf=pass (imf25.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770823404; a=rsa-sha256;
	cv=none;
	b=SQZz0HHfLGx9+GTO2VxF+nS56ku1dss3xy+cWVq9BW75v36nGD8fqSeWVMk1yija77r3EW
	S1yoVfq8J4PR8D8mgfCSs9jYyTYBsMTyV3mHbLauHXGChhv4EdLbSoBL9Z6+X+y67z5MFz
	uMADdcH50zIFYsgHpE21E9NKm1UI2E8=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 6FB4BB2584;
	Wed, 11 Feb 2026 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1770823402;
	bh=f7pIPpettLlSQoHWOm1p7EtiixS7ksKzCY9xzpT+daI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GCLbBzEzvvGcC4OQoQw1NLDJPOjkUC9s49rkNbr3+0EBeQ/ebAoZISWZYAH26SABB
	 zNgugPQOVRqWsGvT2sCt0sPPbgBF2aDPBgr01xMqS6Uh+tQbaiPKT67mNAQfDjt5I8
	 kIlZIYZbLAZM/q6GyZeSwLgnIcp+EujkPX5YdpEo=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH 1/4] mm: introduce zone lock wrappers
Date: Wed, 11 Feb 2026 15:22:13 +0000
Message-ID: <3826dd6dc55a9c5721ec3de85f019764a6cf3222.1770821420.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1770821420.git.d@ilvokhin.com>
References: <cover.1770821420.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 444D9A000A
X-Stat-Signature: du8qpzteaias1ybo1eo1gdsw98yqdxqw
X-Rspam-User: 
X-HE-Tag: 1770823404-314616
X-HE-Meta: U2FsdGVkX18zAkG+QwydiLwRMtgVYBnfPJLksru4voYuN7KW39EIeBNJdukLZLEZOciCKtqES1+gxnOykNVhw8vjtLeB66eXj2qHrh4lF/n/U2mpkStXbRuyh/erLa0QsDVhkNprZNLZVJFmPZoDMDTeeK6C5siXzpkdjdCaEm3K73xN1f5ViBczgnK/8WIT+T3uBE72njJd+2dYOHtfk6MvI5V4gfUrbLlBnVpnXaavHIl54OAMTr1EoNpJiXgllTf775JGg91zc6KBU8v43jQK0wgIBk7i6TwpZX+NgQcXYWfkNMJCHcVaYufdBpIcXYDxl4iSeCKnE2WtBoPAQFTl4NZKDUgZSZPx69uJJ4uh/2Pv+v/T91gkR5nCeUNpS1drqBY3yFZtLEBid7Z5DPKCK7uOlEcPeI7IBHYzZaA7FvpWFMPc9lbAJE9W2RookTY8dpf7nWoeLHFTo3tmVRva7RPHnSQsyMTqAPinOqOf4DqVIUbyBOHNeD1Xj6FY2mIoLi5gsV+4vmMb8naOTHUaCqin62dx3Gj6PgGKcZ5fa/XXbabH0BMIJMYnYOxMRpzbUYgUlotzjRDCwPRkhSLs3Pu/ZGm4qCpDdj5iYQsvL85jC2c6KXO6hvE7nNmfrJv9m4CGoA9Db+foj8QFcBjJJ5zh+XaVA5hpw/2wovM6YH852TAWl5qYexRgzv5mcsrZCPtPPWVww5JqIyrs4szhc4T7Vob+0asV0lV8c90Kp7mYgEnhSb4aOjD9M8WG9XsCU+im1XGA7Aq36fSc+xqVovlbgZF1hSl6l9hD1d43RdmewrSeY8HzJYakBFum/fLsQvEcCxUdbnDm68p4+lzLvYjaMWpGGozN3qj9DwCpsiqy9Hzpyqx+/5x6w8sP8ramScoWnVURtHnASA0C1/3a1S0MVOwIyfpq/LH2ao6sXHYW5QiautHKcMM8BoYp3no/+O/etuAlMYV1EbF
 uYkMkxQj
 66X0B75veLVvAZtSvbp3MgekdUfYivFdrv30ji4pWyPthSPDwbs3rG2ikj9zm62OqOMlZxYDoPeA3yjlOMi9b/loCeFcokvqLlCQWr7DfL6rRG9QJKUhgoKHFNKIfbhpoPj/bIxRGjwYZvsa07CjcVpWRjcMRRExSV/U8Y4bDFnF0Yov86HzPiGbvRGUxlly/c0y7hejCDNi8kNQWF3M9e8WZ1IJ+fdYNXpD775EL129stduEWyb3AVlThf3Ku474ouiqiHpzgIlSp0K95prbrkz/hQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
---
 MAINTAINERS               |  1 +
 include/linux/zone_lock.h | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)
 create mode 100644 include/linux/zone_lock.h

diff --git a/MAINTAINERS b/MAINTAINERS
index b4088f7290be..680c9ae02d7e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16498,6 +16498,7 @@ F:	include/linux/pgtable.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
+F:	include/linux/zone_lock.h
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
diff --git a/include/linux/zone_lock.h b/include/linux/zone_lock.h
new file mode 100644
index 000000000000..c531e26280e6
--- /dev/null
+++ b/include/linux/zone_lock.h
@@ -0,0 +1,38 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_ZONE_LOCK_H
+#define _LINUX_ZONE_LOCK_H
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
+#endif /* _LINUX_ZONE_LOCK_H */
-- 
2.47.3


