Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AEFDFD8FF9
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 18:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79B156B0179; Thu, 26 Feb 2026 13:27:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718086B017C; Thu, 26 Feb 2026 13:27:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EFF06B0179; Thu, 26 Feb 2026 13:27:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 39E3B6B0179
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:27:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E92091B70B4
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:27:02 +0000 (UTC)
X-FDA: 84487439484.03.CBED04A
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf26.hostedemail.com (Postfix) with ESMTP id B214B14000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:26:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="kK/UaSYO";
	spf=pass (imf26.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772130421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zgqMM8R7TMKjzolsktMoOqd00HunAyLpj6pvpo7Z8tY=;
	b=BGrWUwggQ9MxZLhm8EtMBq6LOxqn82ON5C9+nYgAoguaDX4DPY1bhre6856Dotu1dNn4ER
	J2+kx1w4jOwWQZAqUfSCDwZMaAhI0CMxfGua2EROC5ge8AzAfpBv86CJdwno+p+oBg4MJf
	eyrZvAdxBHONB8kPuXv2XkQTNXmqRCw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772130421; a=rsa-sha256;
	cv=none;
	b=E0I6AfFlxYqdmMv40iCkZcuIKw/PY/6wtFGUbiHiJhcUwKm/4uOYGFm5LSTGNRtoH4N3Gc
	BkZW7NTaGKMZ+O+FNTEtvwIMDtNOF8fjd14JqAeoRbQQUrdtIHcD/IO0ojC0TvHogPhpsU
	N+iNQ4gGjy/bZiqmiKQtUHnDciZ8FOo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="kK/UaSYO";
	spf=pass (imf26.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 9421EB2CDA;
	Thu, 26 Feb 2026 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772130414;
	bh=zgqMM8R7TMKjzolsktMoOqd00HunAyLpj6pvpo7Z8tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kK/UaSYOcu1t+smdLydMAUj8pFB1/KTNJYMF0ZEAsHJX3ZLxzzVoS3ZgiABRAb4dB
	 TkmWnuJeYqJib81Wwyzo58ccwWjHpGS/yJSvkPtuJmkcZefr+drvChjwg+zWsI5tjn
	 DOMzvUuNYrdQEXEIQkBANZRFxbgQF+R6jVTBNr+k=
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
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v3 1/5] mm: introduce zone lock wrappers
Date: Thu, 26 Feb 2026 18:26:18 +0000
Message-ID: <5bcc39cd3a227944d0fbe75ff86cdac92b38d4ca.1772129168.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772129168.git.d@ilvokhin.com>
References: <cover.1772129168.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B214B14000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 63qo8u46shs47pnkdc8fny7uodjmn15t
X-HE-Tag: 1772130418-496699
X-HE-Meta: U2FsdGVkX19EcyWM6zyrddZaRl9O10x/0cQN9OpLx+pNg7A6WdgQkHfbrKsX/gpAY3UheHu1UtWhNr4KZ6ZTKoHd2FN9eCBu+ktlre8iIsbU6Cb+3Ls9EECly6dRIrlaOWL5T61xi5+Tx1ZtowJJtsT6Vj5cQFUnsTog4eVQnrNhou79nkqzOA9cQ/TvegHtNxLgMrzeZL8lro6QC910aIDlkf7guZZGWWdPj2z9NS+X35LCVOoOVaiT7mmxrz/ZG47Ms2DvwPQpTt4LDcAC0icZ9+G9FixLBcXur8EXVV8epAblxPlXVV71yWheUjxdUHxWr89UC8zcQhqsQd0oZvEvQoDkq43dfflEPwYMc0NSGY5YvDKSsVZdMOXOUOyckTT8nomJStPnAvNnRT9wyzNGY5kYXqZ4Fol8WuMI/1qOyHPPE1dVggrF6hmjM7cxO8zk1m1Z9Zt5AmCKU1PUkNeKKJBDdfQVwmjIafCinI4NuF/lkcZOJ1PdYVfqNF2TkhZoFuaO/Sdt42L/y2+4fyCSLbVomtmDuZvH+WCpo256mzsu8dyeRPOwirK79wW+qlZLsAZPOYBcoVSqwZw8pUCtSwcrSUdXywMatOQRuGiuHjRr9/cCSVlZPbxhLmLlTGxDbMWhUhWBSgVRyRlP1VOYKHiCOZXQiiWy6A1hb6f7C0bFtCbTWhL36ae4zHj6FX+8U70Z1A/s5CYScFuqOMK7HUcEDjuSzmyRHe+b3BOCHSsqcuG+j04C2YqMqYozoeovHk/RXu2BF5UEq1yg0qN2Nubna9PGdSiiBevg1a0amA2EqMbUwLVZl7DJvh93E2MQcKqadz24MzUAd3zY+KG0wk5mqhfwznF7WeP3yJGoMg4eopAb/F0lp9pN6JDDp1pCVtRVgCpzK/Hm7Tw+nF/aiX14PnCHsOkS7l+RXv9liVlPhqvhl7hzABEoIDiDzG41HjV+LtrgRUT/spS
 Oj/RY7B8
 bCjWR1p/4H+b7M6rQWgQEi5vNLyjRIQC67jG2RnSbc8lwAx5Vn8tmSBWxNHGd9bSn5OMiXo6taGufFQJfIkICENKzF3pakl3cX1hvw1OnWrtRX3lmC5kZyEdOfAh2SXGKhQO8j8uQ+prqD3jc0TqCxQZZ3azaCweBH0GGHsopEZCDDWrYJlw9RY7mBSko/F0ZSRg3u1n5sbFiFNais5H6+np3jurY7TMirnqiPh+DT5ehlU2c+Tbow92ThTBGAPNiqWe9pkQnBai1JWamj4lJDrfy+t8VmTN+Lc5VpdGQgfFCtY6W4QRQWSgE6IKHzbHgCm3y
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
 MAINTAINERS               |  1 +
 include/linux/zone_lock.h | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)
 create mode 100644 include/linux/zone_lock.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 55af015174a5..61e3d1f5bf43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16680,6 +16680,7 @@ F:	include/linux/pgtable.h
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


