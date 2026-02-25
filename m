Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A890BFD3764
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 14:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19BED6B0089; Wed, 25 Feb 2026 09:44:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154346B008A; Wed, 25 Feb 2026 09:44:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0561C6B008C; Wed, 25 Feb 2026 09:44:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E696E6B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:44:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9254F8C03B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:44:17 +0000 (UTC)
X-FDA: 84483249354.18.C629863
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf19.hostedemail.com (Postfix) with ESMTP id CC5631A0004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:44:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="v1/Z023L";
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf19.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772030656; a=rsa-sha256;
	cv=none;
	b=GQwJCeg8z7dtPkg+cYcbJbN2ReSRWw37NdMY2vwU+4vUt3vahoQ7f627nXGQ6pJBB8AMzv
	apiqUbHXBgSrysdx+3XdYAYUnsyUpBrOAU3mR6wQMjks4J6XYXXYlOOZ1pmMllBBxqRYqa
	Fn22GtAZwoYVFzA6gM3hg6A1cEzeiKo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b="v1/Z023L";
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf19.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772030656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zgqMM8R7TMKjzolsktMoOqd00HunAyLpj6pvpo7Z8tY=;
	b=EakxHkDYgCCKZX+AsqbxBQqZuk+7cwhHGmUVs2xDx8S6fZA+l43Jtu8EWeUiuZn4fNoE/c
	aamIVz+cwcW8WVvtwfJaYYYKeaWXmjuPKWw6qWajyJ5RGvTwRTS+vHyOhllPq+0iqMEGgN
	Gz1t8/QYmAghG4MzzzdWwblwHZ5OwEs=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 2BC9CB2C29;
	Wed, 25 Feb 2026 14:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772030654;
	bh=zgqMM8R7TMKjzolsktMoOqd00HunAyLpj6pvpo7Z8tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v1/Z023Lcr4+Wv/56Gncnq+EMZVfqh3qPWqdch+3UmEyoVhV2Uq1mRmYCU3HJmUIi
	 1m22YQbKLFMFCxkHUMBHa/20yVpBxhodtgyw+b4mqxKLSp3DFtdQunZAqU1gWHcXfF
	 hwKCdZh/jMYGJodz5NJ0fga8ahB+pfwyEcx+zFnM=
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
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: [PATCH v2 1/4] mm: introduce zone lock wrappers
Date: Wed, 25 Feb 2026 14:43:03 +0000
Message-ID: <5bcc39cd3a227944d0fbe75ff86cdac92b38d4ca.1772030186.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772030186.git.d@ilvokhin.com>
References: <cover.1772030186.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CC5631A0004
X-Stat-Signature: 1tmp955kj7f3ttw75eoyej6uckecxpm8
X-HE-Tag: 1772030655-102008
X-HE-Meta: U2FsdGVkX1+viwRSYvd8bMidyfkUHi7lQOsqlWPL17M7wcxm3lM5cgkt12pKwsRwvCF5d6Wg7V8ccKP8q+VJ6X6vJ1n1ip3A/mk3m85ovqlKafviNJ/Y80WFdpcCADiryKwu7GmybloFUbieAmWWQbSvMzsLNM9UqOOJbdqG0xdV7YJ0hXNd8GCU367tD7WEKUKqVm2giRAVGr3XyjA2si9NdBjU3UAZjmETzJe9att/uFvddgeKA0GesbLOQ5uujZsRF/2I5lYGlWVMLBZb3Cu4pLoizeC1Y/CWMffYi+C7x6MOAUFsESGhKBSewWgw/mOd/Ds7TxUlAgkqheFmww4zOnZYAkOyj+1LFotKfo8ituh2S8fs5pDRsFkuuZquyCsSIhpUEcSjlBkGgfE9Sjm+5Kz4OzAKVxPG38YOEFuOqT3PiL+s95b2b2d9hqIFmE0bMqlM4nW9uDm/MLOHoq0MiZcWW3YdfB9dlD3QzaWezRpDPHMN5suVy4SI3KAxwfT76bqyuHPKQnV5m0Lnbm5y1ZmoQOsjNwnReZ5/48Kr7Q+vfZ0DJQAHpP+xZ1l6Wvmnp/MHG6Iayg0+Y16x3I66QTClGoB9qRAX9DrKA67yfPC7RYelJhClnPjj5bJYIfbtm5653vLY8Dx5beh5xbuGlJBpMJKZIUlK1r1GxrToDN4xaTbWZiTooG7yBr25RdAlY1bXk0gwNKMxWk9axrIse/hu1drdpg8VmVdifRLXX2Q4eVLXOImurvJWtegREbkcrWBjFGn8+iTcbenET4GzW4NzDBsmF4+qrRv1tlfFwgVI/PXqUUI3F5d5o8y2ZrK38d1Ced1fQANFkNZ66tDi2FSjMxyMz8BNh5sxliS2Y4GzaDGJ652zLSMzB7gLg+X5VA2q+fRTvaDswTQAzISBN9h6ZjmfgidU6+zHGK4o4pRQX5gDyt/Mng8wikKUPAEpsJp5jNx28TscUc6
 +OUFqOIT
 JIVg9mSlxfdw8wlMGSuoiKpzETbFRiUltsYVWi8C+93LD9Ew6hy1ggw3RidRFhX0r3KIA56NPFr/FW2nD2qL6iiOlHcilgWFMgpRceQFdyi+T/212SNtiOhW/hu2rOmIP0ro6oDWDYu6GgQWYqM3Nz18E/IapJOh2JruER4KpF4+jYpVVs/aCgxMRrjIFFuoQ/E2pEd5MUVJMtq9IFHlNccusaDdXdiZ4CjQcvbGAWVaqKUvploPYZs/dswJfsv9BIHOj7ZdeSbnNNqlitCi+P2i0JOKPPBlKVf2T0PRnbXLNoxCy3LPPqKm1q/q+/xZmfgHW
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


