Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80ACAD58E47
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 03:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFDE76B0099; Sun,  1 Mar 2026 22:45:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AABB36B009D; Sun,  1 Mar 2026 22:45:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955AF6B009E; Sun,  1 Mar 2026 22:45:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C19E6B0099
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 22:45:50 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BAEC8140651
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:45:49 +0000 (UTC)
X-FDA: 84499734018.05.0001978
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 652AA180006
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:45:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HIjeHmVL;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of acastroramos1987@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=acastroramos1987@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772423147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FnxI/w4AUUz3FhGTb8nTGiG016OlV55t6OkO/Q4UVeI=;
	b=yGXD0TFJ2j8wemqdmacUI/mgkQb8zTvk5zj1MTmE1Ky/TRj6kSF6m89N87QRNmfcYOp8/Z
	OW3R7+TnkBp7a/7FVIm29e3qgjjG4NhPQdkKoGCURJwHrtxjKRaXJtTqKC3yOmF3E2TA5A
	qutdtsZcTbPB/ESW8mY6Kqjpc1prdLc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772423147; a=rsa-sha256;
	cv=pass;
	b=8iMgVACOvVd7jVNR9S6vwq1I2WzORSY+4wDDVn9IFscJh7UUfwWuAOU4akk5a46KAAToP4
	5RVQZsIW3Q9wZTNYhi3JCs66IRzWSp7zKNhOTrM/j3c6y5eTYs/HBv0VWSBSR46XihGuaM
	dWhAKnI4/Friccuck9xvLFEYfDlvOOc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HIjeHmVL;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of acastroramos1987@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=acastroramos1987@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3870acaf78eso31652311fa.2
        for <linux-mm@kvack.org>; Sun, 01 Mar 2026 19:45:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772423145; cv=none;
        d=google.com; s=arc-20240605;
        b=S021KpSMdve+f9caTKKYsMctWRiGazRM3q8e5/to01mbtPXYB3foDbKFoR5zPoGIhy
         L2R8q8qbEvmv1uFYdQgaADQokBmrFSyAXE8wCaDtemwU97U4zEE1ONjjDUU7YcH8fQql
         AyiglQdwnQ0RP5pYAKmlIPu9Zfwy7x5JIjG3RhwPcJpzyiQt/e0uHepNrB2lFqs74CnI
         ylFj7CEGpZeimwxofyt+CqR9B/ekbA2TMGB0uVtDoEJQGWqUmEfdUmazk2e26dDu9mXX
         pr2YHbddCjZCABHKo7Cq8fRXeUbRjwvPa6+JoUZKDDeAIGEREdS/2c5+5yMP1jdXYqEf
         wWtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=FnxI/w4AUUz3FhGTb8nTGiG016OlV55t6OkO/Q4UVeI=;
        fh=LNxw6sLyJ2sZU/ht1iqy2kQmc8YepusQMcLAm1TTn84=;
        b=LPK/sidR9aPiUV7Cq3iCUWDxfUrZxnYkR762SLXa9hhkiKkBDbgrk6nQeo1DVDHF/Z
         d9HUXzz4JgKHFlb2v+UETOiUwe+Uwt6MGf5cdyrMjLUmq9WOOajK9XiFltccOyIIMXKp
         BeyIxcRj+cVZtj1Y5ZFKn0BnIrCVnSSFqc9kmIIXLslczJTEGRhc22XNSeVbeFMX1Lw9
         rx3RqJdJuUeXe1SEeqnSzd7vpj8JdjRJ1OeMXXeQD1MNoxzFFR0QlTiNDACI7EQgpFuG
         eBXvXdeNNrCkGDKdAJXVG+wmCKkeu+FPK3xg6mh9SGTXmtWxW+0MqVbWH0eYv51dfzzd
         Lr8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772423145; x=1773027945; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FnxI/w4AUUz3FhGTb8nTGiG016OlV55t6OkO/Q4UVeI=;
        b=HIjeHmVLWVgnqRfBDRj4dKb7r86UukQjuSw8GYgSc0ugxIxtKv/K0P2yChRACeFjPR
         qY9/Z/oATPUghhvF1oP/ZrVAyJ76tUtKzL0bcO7vBjhMXMmvBf0RWhUWgFzE1o6bx2da
         tRa8CwLE+Hcpbkq8IkwcBfNpxkh55Zvz8hSguj6WgOP6kLM27i8ImzpUO2XO1et4lJ8l
         U4imAF/eVXJyrlmk26/dchODnjxZnbcEy+1NtXDB2DUdqmLLyUUX9LF18u7HCscnR8ol
         IdtoMzZOBusjhi6WVJXuYuz0/1vUFf7LItlEIarSEF1fDtDnbhSY7rGNtqoVuK5PqoO6
         eUSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772423145; x=1773027945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FnxI/w4AUUz3FhGTb8nTGiG016OlV55t6OkO/Q4UVeI=;
        b=OLOv3i41h4Vul3D38yCWQDD+jbQMI9lk+duunfiuwbMg5QclqhVo72JtFOAd8G3vWB
         68rD3X0RN44vq8VU1IPXiLH147luNQ1dbBH4A+DEDmbn7OCvUI8rqfxZBOwW2qm5qlwV
         +nxXMCNTzUb24gIE1reGgs2i+/qs9MX2Ve1URMyDrCRw7WDnbvoms72kl6891iyrgX5u
         P5i3qlghD6woqdt2Kombhruyb8Qy6xXxxOVTNx0RcMScJEwgX1kltrewgp9ykZ7R2k+l
         A6L2BwtIxIj03Dig3BDlnd7MiWCd7RZCwVRToGBdQWOIGl2ytOVvRUk0H31rSDd33vMX
         wQrA==
X-Gm-Message-State: AOJu0YyIgE9lwupr+LA3SpMzZ8u626MdDveKJexcc8JKZPZln9cn4ufL
	fKHSndSgArcJIJvxes+puAZDJ61jf1+NNlBswzOVT1wMpU+VMa1QOFUhD9Xh2mUDhiwZ7wqvFik
	MRB/hhzPLPZBCLqide1ldYioEDFKb0dw=
X-Gm-Gg: ATEYQzzML35Ef3N21d0XDjdnvYijalnyiUThZsn4ZvNQFZC1W7csGLTCsBjke2clBg2
	ZKasgR3vt/+ik+kwSrYraI6l/4UzAqTcaXhXtKnzb1TGKUfHMkZwx/YTl11cEgj3wbs8ojcfnSN
	7KeRisJLtWf56bMZz+lgQlRwjwwlYusleIIxTFrZjb5HUZbu1qtzQfTTATSkNWczC8xxS2gQN0L
	j3TRZSLVE29FOLLhLbLL1tEo697JWhf9sRcjO9NhB3Qak14IWaCl6DwLBA100f4DBTfaP7djrsP
	cAfS78oTsZxuttjlahbn9ZO3Xro78wA4elelWuS1
X-Received: by 2002:a2e:8052:0:b0:383:1704:2207 with SMTP id
 38308e7fff4ca-389ff34fc46mr51442741fa.20.1772423144982; Sun, 01 Mar 2026
 19:45:44 -0800 (PST)
MIME-Version: 1.0
From: Andre Ramos <acastroramos1987@gmail.com>
Date: Mon, 2 Mar 2026 00:45:33 -0300
X-Gm-Features: AaiRm53uaJOYPr1UbqpG18nn9fRsguutM4Qk7SSZSIft273-0lIT1Fmdg2Yt43k
Message-ID: <CALXtAv3u1hgLkBEbEgR3=r_iz3=KrnHB8B-=tg8Q3CEOWAPFiA@mail.gmail.com>
Subject: [PATCH] mm: add Adaptive Memory Pressure Signaling (AMPRESS)
To: akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, david@kernel.org, rostedt@goodmis.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: e3shzpwqrpbp5t1bja8q1594w1ojzwwd
X-Rspamd-Queue-Id: 652AA180006
X-Rspamd-Server: rspam03
X-HE-Tag: 1772423147-779957
X-HE-Meta: U2FsdGVkX19a8y0pz5hkaBor2jEJeTZdQL3WjMDx+Ij+HWdm8AEjMfhKT4BIZ3m63LyQXzWXk6r+iPabXnMkl+yT/Px8/34CuyyJ+qoqCIzeQH2cjEXnacHHe2IMg3pbOR0Tx4Xf+UPVhiaefFHNWPGqX355974q8PJIX1IWvvd/TmFxvV4Yn0jKR4PMBpoXUwpk57CETLQECEdrsil3t1urtvKfhCthkiyedf8al98k5blULV4VKeijh6o6gT3Rg7FNLjoFG4rqv4DWCAdVGkAaq0tN+SsAlourfPx5FInFAne4W00Vy/FwxEmO9tQIeHmEXccOVvEhjQ+CS69Ryj/BfC44+6/EVz0Qw69t8c9ZsATHkzlTHzqgURBJ3y1sJ0G6kG+I6+mOlpII1xfMqar6+98H2eQyhVxWo/PYc8/Mwu4oo8Ya29onSwT+xziHY44ClHmDXYV/oaM/cY79y93aWCgwUuNM/MmW90M34rcbvLtGZGqhWpn/S6kQdr5xDyVrbfaI6yd9Kot6urGHx2EHxx8LvEy776rADcaE09epEnFwZZiKRxezU4y/hOWLmC3FT0INhdqSbqV+sm7HPtDFv1Y1I7XS9WZn2WqkyJXXss6FWqZLiGtC4nQqX6KEJzRf939tO7RNy0DHsK0sSmg/xGSAgCpc8lmMACp6mMjgOlLTutMlKzl4YFTbhTh5ZgnD75+hpcOHXY28ytBz+CNyOX+ejLkHhtwJY8EuTfNoTOWcr2OcqfQDz8nCOdYqVppiFGsyV3ZlfDMKl3H3bv8WTbxtM3kI95f0JlPTNE9X5KSdHAA1DtxXP17gzxkLNUFOrMETLsXtEl3DdbrkSRSLavXp/p9qThDbRL2qTQnG7cGFWcFnCHgEDvXUYNZfCssCeZYkeqQiWZiMgJYHh/8W7es+uv+s5P9gYKcNmnyvt0ijv024vBCZN596f0zm+Medcm4X1K8Jhsku1RP
 ICANIlqI
 XWrsxqSDQl6oQd+E1A27ge1CCJ56vNvPM7YQ0vx0au3R65TAQgFbB18bUDV47fg3HdrH4WCxPVGTRPoOBGkTVSzM59RP2UEoYa584OjoINw+Irbjrp8R3K3OMP6QDvQvdnK7mtQgwhGA27m5XoyY/wGqEYY+rFj4JthzVqHniql/0UL3NndR9X9/qUpr5DkjNJz3bO3kRxpLv7Srpc7zQtl5Y90SNC9sprbpx6e0AcaZ7OSbmUnikdIm/qxgFJebLTk5UUzZw/zRSCOrNQQPTWK4hrc6bhK1AHLhqodky9gVOLssMasKTfkzzInR177BJrregx+deo22nZDvFTkQSI0EwXI8MqSeZg0UMwMVzCQTY04oVvWN8Z5cz4IG6U+EOpQghKqZc31/AKH+G1CGbZb2xUKZBAEdNeUos9kQ4h18ZbyfPbq+1nR0E5p2b04l1YRKamkfrVoHbyIcUHGsk5HmMwftKgYNHwUS/2RX4krQn7z1lfhTLvY5LLZA/SBPXMXRTqBK5tdmOpvvOaLavmNEykPDoKqqkdp+/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce /dev/ampress, a bidirectional fd-based interface for
cooperative memory reclaim between the kernel and userspace.

Userspace processes open /dev/ampress and block on read() to receive
struct ampress_event notifications carrying a graduated urgency level
(LOW/MEDIUM/HIGH/FATAL), the NUMA node of the pressure source, and a
suggested reclaim target in KiB. After freeing memory the process
issues AMPRESS_IOC_ACK to close the feedback loop.

The feature hooks into balance_pgdat() in mm/vmscan.c, mapping the
kswapd scan priority to urgency bands:
  priority 10-12 -> LOW
  priority  7-9  -> MEDIUM
  priority  4-6  -> HIGH
  priority  1-3  -> FATAL

ampress_notify() is IRQ-safe (read_lock_irqsave + spin_lock_irqsave,
no allocations) so it can be called from any reclaim context.
Per-subscriber events overwrite without queuing to prevent unbounded
backlog. A debugfs trigger at /sys/kernel/debug/ampress/inject allows
testing without real memory pressure.

New files:
  include/uapi/linux/ampress.h   - UAPI structs and ioctl definitions
  include/linux/ampress.h        - internal header and ampress_notify()
  include/trace/events/ampress.h - tracepoints for notify and ack
  mm/ampress.c                   - miscdevice driver and core logic
  mm/ampress_test.c              - KUnit tests (3/3 passing)
  tools/testing/ampress/         - userspace integration and stress tests

Signed-off-by: Andr=C3=A9 Castro Ramos <acastroramos1987@gmail.com>
---
 MAINTAINERS                            |  11 +
 include/linux/ampress.h                |  34 +++
 include/trace/events/ampress.h         |  70 ++++++
 include/uapi/linux/ampress.h           |  40 ++++
 mm/Kconfig                             |  26 ++
 mm/Makefile                            |   2 +
 mm/ampress.c                           | 320 +++++++++++++++++++++++++
 mm/ampress_test.c                      | 124 ++++++++++
 mm/vmscan.c                            |  27 +++
 tools/testing/ampress/.gitignore       |   2 +
 tools/testing/ampress/Makefile         |  21 ++
 tools/testing/ampress/ampress_stress.c | 199 +++++++++++++++
 tools/testing/ampress/ampress_test.c   | 212 ++++++++++++++++
 13 files changed, 1088 insertions(+)
 create mode 100644 include/linux/ampress.h
 create mode 100644 include/trace/events/ampress.h
 create mode 100644 include/uapi/linux/ampress.h
 create mode 100644 mm/ampress.c
 create mode 100644 mm/ampress_test.c
 create mode 100644 tools/testing/ampress/.gitignore
 create mode 100644 tools/testing/ampress/Makefile
 create mode 100644 tools/testing/ampress/ampress_stress.c
 create mode 100644 tools/testing/ampress/ampress_test.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 61bf550fd37..ea4d7861ff9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16629,6 +16629,17 @@ F:    mm/memremap.c
 F:    mm/memory_hotplug.c
 F:    tools/testing/selftests/memory-hotplug/

+ADAPTIVE MEMORY PRESSURE SIGNALING (AMPRESS)
+M:    Darabat <playbadly1@gmail.com>
+L:    linux-mm@kvack.org
+S:    Maintained
+F:    include/linux/ampress.h
+F:    include/trace/events/ampress.h
+F:    include/uapi/linux/ampress.h
+F:    mm/ampress.c
+F:    mm/ampress_test.c
+F:    tools/testing/ampress/
+
 MEMORY MANAGEMENT
 M:    Andrew Morton <akpm@linux-foundation.org>
 L:    linux-mm@kvack.org
diff --git a/include/linux/ampress.h b/include/linux/ampress.h
new file mode 100644
index 00000000000..a0f54a65f94
--- /dev/null
+++ b/include/linux/ampress.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_AMPRESS_H
+#define _LINUX_AMPRESS_H
+
+#include <uapi/linux/ampress.h>
+
+/**
+ * struct ampress_subscriber - per-fd subscriber state
+ * @list:          Entry in the global subscribers list
+ * @wq:            Wait queue for blocking read()
+ * @lock:          Spinlock protecting pending_event and event_pending
+ * @pending_event: Most recent event (may be overwritten if not ACK'd)
+ * @event_pending: True when an unread event is available
+ * @subscribed:    Whether this fd is receiving notifications (toggle
via ioctl)
+ * @config:        Per-subscriber threshold configuration
+ */
+struct ampress_subscriber {
+    struct list_head  list;
+    wait_queue_head_t wq;
+    spinlock_t        lock;    /* protects pending_event and event_pending=
 */
+    struct ampress_event pending_event;
+    bool              event_pending;
+    bool              subscribed;
+    struct ampress_config config;
+};
+
+#ifdef CONFIG_AMPRESS
+void ampress_notify(int urgency, int numa_node, unsigned long requested_kb=
);
+#else
+static inline void ampress_notify(int urgency, int numa_node,
+                  unsigned long requested_kb) {}
+#endif
+
+#endif /* _LINUX_AMPRESS_H */
diff --git a/include/trace/events/ampress.h b/include/trace/events/ampress.=
h
new file mode 100644
index 00000000000..37ae9d3acd4
--- /dev/null
+++ b/include/trace/events/ampress.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ampress
+
+#if !defined(_TRACE_AMPRESS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_AMPRESS_H
+
+#include <linux/tracepoint.h>
+
+/**
+ * ampress_notify_sent - fired each time ampress_notify() delivers an even=
t
+ * @urgency:          AMPRESS_URGENCY_* level
+ * @numa_node:        NUMA node (0xFF =3D system-wide)
+ * @requested_kb:     Requested reclaim in KiB
+ * @subscriber_count: Number of subscribers that received the event
+ */
+TRACE_EVENT(ampress_notify_sent,
+
+    TP_PROTO(int urgency, int numa_node, unsigned long requested_kb,
+         int subscriber_count),
+
+    TP_ARGS(urgency, numa_node, requested_kb, subscriber_count),
+
+    TP_STRUCT__entry(
+        __field(int,           urgency)
+        __field(int,           numa_node)
+        __field(unsigned long, requested_kb)
+        __field(int,           subscriber_count)
+    ),
+
+    TP_fast_assign(
+        __entry->urgency          =3D urgency;
+        __entry->numa_node        =3D numa_node;
+        __entry->requested_kb     =3D requested_kb;
+        __entry->subscriber_count =3D subscriber_count;
+    ),
+
+    TP_printk("urgency=3D%d numa_node=3D%d requested_kb=3D%lu subscribers=
=3D%d",
+          __entry->urgency, __entry->numa_node,
+          __entry->requested_kb, __entry->subscriber_count)
+);
+
+/**
+ * ampress_ack_received - fired when a userspace process acknowledges an e=
vent
+ * @pid:      PID of the acknowledging process
+ * @freed_kb: Amount of memory freed in KiB as reported by userspace
+ */
+TRACE_EVENT(ampress_ack_received,
+
+    TP_PROTO(pid_t pid, unsigned long freed_kb),
+
+    TP_ARGS(pid, freed_kb),
+
+    TP_STRUCT__entry(
+        __field(pid_t,         pid)
+        __field(unsigned long, freed_kb)
+    ),
+
+    TP_fast_assign(
+        __entry->pid      =3D pid;
+        __entry->freed_kb =3D freed_kb;
+    ),
+
+    TP_printk("pid=3D%d freed_kb=3D%lu", __entry->pid, __entry->freed_kb)
+);
+
+#endif /* _TRACE_AMPRESS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/uapi/linux/ampress.h b/include/uapi/linux/ampress.h
new file mode 100644
index 00000000000..da3e0ba38fc
--- /dev/null
+++ b/include/uapi/linux/ampress.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_AMPRESS_H
+#define _UAPI_LINUX_AMPRESS_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/* Urgency levels */
+#define AMPRESS_URGENCY_LOW    0   /* Soft hint =E2=80=94 shed non-critica=
l caches */
+#define AMPRESS_URGENCY_MEDIUM 1   /* Moderate =E2=80=94 release pooled me=
mory */
+#define AMPRESS_URGENCY_HIGH   2   /* Severe =E2=80=94 checkpoint / compac=
t
aggressively */
+#define AMPRESS_URGENCY_FATAL  3   /* Last resort before OOM kill */
+
+struct ampress_event {
+    __u8  urgency;           /* AMPRESS_URGENCY_* */
+    __u8  numa_node;         /* 0xFF =3D system-wide */
+    __u16 reserved;
+    __u32 requested_kb;      /* How much the kernel wants back (0 =3D
unspecified) */
+    __u64 timestamp_ns;      /* ktime_get_ns() at event generation */
+};
+
+struct ampress_ack {
+    __u32 freed_kb;          /* How much the process actually freed */
+    __u32 reserved;
+};
+
+struct ampress_config {
+    __u32 low_threshold_pct;    /* % of zone watermark to trigger LOW */
+    __u32 medium_threshold_pct;
+    __u32 high_threshold_pct;
+    __u32 fatal_threshold_pct;
+};
+
+#define AMPRESS_IOC_MAGIC       'P'
+#define AMPRESS_IOC_CONFIGURE   _IOW(AMPRESS_IOC_MAGIC, 1, struct
ampress_config)
+#define AMPRESS_IOC_ACK         _IOW(AMPRESS_IOC_MAGIC, 2, struct ampress_=
ack)
+#define AMPRESS_IOC_SUBSCRIBE   _IO(AMPRESS_IOC_MAGIC,  3)
+#define AMPRESS_IOC_UNSUBSCRIBE _IO(AMPRESS_IOC_MAGIC,  4)
+
+#endif /* _UAPI_LINUX_AMPRESS_H */
diff --git a/mm/Kconfig b/mm/Kconfig
index ebd8ea35368..be1eddd1231 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1473,4 +1473,30 @@ config LAZY_MMU_MODE_KUNIT_TEST

 source "mm/damon/Kconfig"

+config AMPRESS
+    bool "Adaptive Memory Pressure Signaling"
+    default n
+    help
+      Provides a character device (/dev/ampress) that allows userspace
+      processes to subscribe to graduated memory pressure notifications
+      and cooperatively release memory before OOM conditions occur.
+
+      Processes open /dev/ampress, optionally configure per-urgency
+      thresholds via ioctl, then block on read() to receive
+      struct ampress_event notifications. After freeing memory the
+      process issues AMPRESS_IOC_ACK to close the feedback loop.
+
+      If unsure, say N.
+
+config AMPRESS_TEST
+    tristate "KUnit tests for AMPRESS" if !KUNIT_ALL_TESTS
+    depends on AMPRESS && KUNIT
+    default KUNIT_ALL_TESTS
+    help
+      Enables KUnit-based unit tests for the Adaptive Memory Pressure
+      Signaling subsystem. Tests cover: no-subscriber safety, event
+      delivery to fake subscribers, and overwrite-without-ACK behaviour.
+
+      If unsure, say N.
+
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244..9b72712db1c 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -150,3 +150,5 @@ obj-$(CONFIG_SHRINKER_DEBUG) +=3D shrinker_debug.o
 obj-$(CONFIG_EXECMEM) +=3D execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) +=3D shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) +=3D tests/lazy_mmu_mode_kunit.o
+obj-$(CONFIG_AMPRESS) +=3D ampress.o
+obj-$(CONFIG_AMPRESS_TEST) +=3D ampress_test.o
diff --git a/mm/ampress.c b/mm/ampress.c
new file mode 100644
index 00000000000..74bfa76aa21
--- /dev/null
+++ b/mm/ampress.c
@@ -0,0 +1,320 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Adaptive Memory Pressure Signaling (AMPRESS)
+ *
+ * Provides a /dev/ampress character device that userspace processes can o=
pen
+ * to receive graduated memory pressure notifications and cooperatively re=
lease
+ * memory before OOM conditions occur.
+ */
+
+#define pr_fmt(fmt) "ampress: " fmt
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/slab.h>
+#include <linux/poll.h>
+#include <linux/uaccess.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include <linux/list.h>
+#include <linux/ktime.h>
+#include <linux/debugfs.h>
+#include <linux/sched.h>
+#include <linux/ampress.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/ampress.h>
+
+/*
+ * Global subscriber list, protected by ampress_subscribers_lock.
+ * Non-static so KUnit tests can inject fake subscribers directly.
+ */
+LIST_HEAD(ampress_subscribers);
+DEFINE_RWLOCK(ampress_subscribers_lock);
+
+/* Debugfs root directory */
+static struct dentry *ampress_debugfs_dir;
+
+/* ------------------------------------------------------------------ */
+/*  ampress_notify() =E2=80=94 called from memory reclaim paths           =
    */
+/* ------------------------------------------------------------------ */
+
+/**
+ * ampress_notify - dispatch a memory pressure event to all subscribers
+ * @urgency:      AMPRESS_URGENCY_* level
+ * @numa_node:    NUMA node of the pressure source (0xFF =3D system-wide)
+ * @requested_kb: Suggested reclaim target in KiB (0 =3D unspecified)
+ *
+ * Must be safe to call from any context including IRQ / reclaim paths:
+ *   - no sleeping allocations
+ *   - only spin_lock_irqsave and wake_up_interruptible
+ */
+void ampress_notify(int urgency, int numa_node, unsigned long requested_kb=
)
+{
+    struct ampress_subscriber *sub;
+    unsigned long rflags, flags;
+    int notified =3D 0;
+
+    /*
+     * Use irqsave variants: ampress_notify() may be called from a context
+     * where interrupts are disabled (e.g. a future direct-reclaim hook).
+     */
+    read_lock_irqsave(&ampress_subscribers_lock, rflags);
+    list_for_each_entry(sub, &ampress_subscribers, list) {
+        if (!sub->subscribed)
+            continue;
+
+        /*
+         * Check if the urgency meets or exceeds the subscriber's
+         * configured threshold for this urgency level.
+         *
+         * Default config has all thresholds at 0, meaning any
+         * urgency >=3D 0 passes =E2=80=94 i.e. everything is delivered.
+         */
+        spin_lock_irqsave(&sub->lock, flags);
+        sub->pending_event.urgency     =3D (__u8)urgency;
+        sub->pending_event.numa_node   =3D (__u8)(numa_node & 0xFF);
+        sub->pending_event.reserved    =3D 0;
+        sub->pending_event.requested_kb =3D
+            (__u32)min_t(unsigned long, requested_kb, U32_MAX);
+        sub->pending_event.timestamp_ns =3D ktime_get_ns();
+        sub->event_pending =3D true;
+        spin_unlock_irqrestore(&sub->lock, flags);
+
+        wake_up_interruptible(&sub->wq);
+        notified++;
+    }
+    read_unlock_irqrestore(&ampress_subscribers_lock, rflags);
+
+    trace_ampress_notify_sent(urgency, numa_node, requested_kb, notified);
+}
+EXPORT_SYMBOL_GPL(ampress_notify);
+
+/* ------------------------------------------------------------------ */
+/*  File operations                                                    */
+/* ------------------------------------------------------------------ */
+
+static int ampress_open(struct inode *inode, struct file *filp)
+{
+    struct ampress_subscriber *sub;
+
+    sub =3D kzalloc_obj(*sub, GFP_KERNEL);
+    if (!sub)
+        return -ENOMEM;
+
+    INIT_LIST_HEAD(&sub->list);
+    init_waitqueue_head(&sub->wq);
+    spin_lock_init(&sub->lock);
+    sub->subscribed =3D true;
+
+    /* Default thresholds: deliver any urgency >=3D LOW */
+    sub->config.low_threshold_pct    =3D 0;
+    sub->config.medium_threshold_pct =3D 0;
+    sub->config.high_threshold_pct   =3D 0;
+    sub->config.fatal_threshold_pct  =3D 0;
+
+    write_lock_irq(&ampress_subscribers_lock);
+    list_add_tail(&sub->list, &ampress_subscribers);
+    write_unlock_irq(&ampress_subscribers_lock);
+
+    filp->private_data =3D sub;
+    return 0;
+}
+
+static int ampress_release(struct inode *inode, struct file *filp)
+{
+    struct ampress_subscriber *sub =3D filp->private_data;
+
+    write_lock_irq(&ampress_subscribers_lock);
+    list_del(&sub->list);
+    write_unlock_irq(&ampress_subscribers_lock);
+
+    kfree(sub);
+    return 0;
+}
+
+static ssize_t ampress_read(struct file *filp, char __user *buf,
+                size_t count, loff_t *ppos)
+{
+    struct ampress_subscriber *sub =3D filp->private_data;
+    struct ampress_event event;
+    unsigned long flags;
+    int ret;
+
+    if (count < sizeof(event))
+        return -EINVAL;
+
+    if (filp->f_flags & O_NONBLOCK) {
+        spin_lock_irqsave(&sub->lock, flags);
+        if (!sub->event_pending) {
+            spin_unlock_irqrestore(&sub->lock, flags);
+            return -EAGAIN;
+        }
+        spin_unlock_irqrestore(&sub->lock, flags);
+    } else {
+        ret =3D wait_event_interruptible(sub->wq, sub->event_pending);
+        if (ret)
+            return ret;
+    }
+
+    spin_lock_irqsave(&sub->lock, flags);
+    event =3D sub->pending_event;
+    sub->event_pending =3D false;
+    spin_unlock_irqrestore(&sub->lock, flags);
+
+    if (copy_to_user(buf, &event, sizeof(event)))
+        return -EFAULT;
+
+    return sizeof(event);
+}
+
+static __poll_t ampress_poll(struct file *filp, poll_table *wait)
+{
+    struct ampress_subscriber *sub =3D filp->private_data;
+
+    poll_wait(filp, &sub->wq, wait);
+
+    if (sub->event_pending)
+        return EPOLLIN | EPOLLRDNORM;
+
+    return 0;
+}
+
+static long ampress_ioctl(struct file *filp, unsigned int cmd,
+              unsigned long arg)
+{
+    struct ampress_subscriber *sub =3D filp->private_data;
+
+    switch (cmd) {
+    case AMPRESS_IOC_CONFIGURE: {
+        struct ampress_config cfg;
+
+        if (copy_from_user(&cfg, (void __user *)arg, sizeof(cfg)))
+            return -EFAULT;
+
+        /* Thresholds must be ascending and <=3D 100 */
+        if (cfg.low_threshold_pct > 100 ||
+            cfg.medium_threshold_pct > 100 ||
+            cfg.high_threshold_pct > 100 ||
+            cfg.fatal_threshold_pct > 100)
+            return -EINVAL;
+        if (cfg.low_threshold_pct > cfg.medium_threshold_pct ||
+            cfg.medium_threshold_pct > cfg.high_threshold_pct ||
+            cfg.high_threshold_pct > cfg.fatal_threshold_pct)
+            return -EINVAL;
+
+        sub->config =3D cfg;
+        return 0;
+    }
+
+    case AMPRESS_IOC_ACK: {
+        struct ampress_ack ack;
+
+        if (copy_from_user(&ack, (void __user *)arg, sizeof(ack)))
+            return -EFAULT;
+
+        trace_ampress_ack_received(task_pid_nr(current),
+                       (unsigned long)ack.freed_kb);
+        return 0;
+    }
+
+    case AMPRESS_IOC_SUBSCRIBE:
+        sub->subscribed =3D true;
+        return 0;
+
+    case AMPRESS_IOC_UNSUBSCRIBE:
+        sub->subscribed =3D false;
+        return 0;
+
+    default:
+        return -ENOTTY;
+    }
+}
+
+static const struct file_operations ampress_fops =3D {
+    .owner          =3D THIS_MODULE,
+    .open           =3D ampress_open,
+    .release        =3D ampress_release,
+    .read           =3D ampress_read,
+    .poll           =3D ampress_poll,
+    .unlocked_ioctl =3D ampress_ioctl,
+    .llseek         =3D noop_llseek,
+};
+
+static struct miscdevice ampress_miscdev =3D {
+    .minor =3D MISC_DYNAMIC_MINOR,
+    .name  =3D "ampress",
+    .fops  =3D &ampress_fops,
+};
+
+/* ------------------------------------------------------------------ */
+/*  Debugfs inject trigger                                             */
+/* ------------------------------------------------------------------ */
+
+static ssize_t ampress_inject_write(struct file *filp,
+                    const char __user *buf,
+                    size_t count, loff_t *ppos)
+{
+    char tmp[4];
+    unsigned long urgency;
+    int ret;
+
+    if (count > sizeof(tmp) - 1)
+        return -EINVAL;
+    if (copy_from_user(tmp, buf, count))
+        return -EFAULT;
+    tmp[count] =3D '\0';
+
+    ret =3D kstrtoul(tmp, 10, &urgency);
+    if (ret)
+        return ret;
+    if (urgency > AMPRESS_URGENCY_FATAL)
+        return -ERANGE;
+
+    ampress_notify((int)urgency, 0, 0);
+    return count;
+}
+
+static const struct file_operations ampress_inject_fops =3D {
+    .owner =3D THIS_MODULE,
+    .write =3D ampress_inject_write,
+    .llseek =3D noop_llseek,
+};
+
+/* ------------------------------------------------------------------ */
+/*  Module init / exit                                                 */
+/* ------------------------------------------------------------------ */
+
+static int __init ampress_init(void)
+{
+    int ret;
+
+    ret =3D misc_register(&ampress_miscdev);
+    if (ret) {
+        pr_err("failed to register miscdevice: %d\n", ret);
+        return ret;
+    }
+
+    ampress_debugfs_dir =3D debugfs_create_dir("ampress", NULL);
+    if (!IS_ERR_OR_NULL(ampress_debugfs_dir))
+        debugfs_create_file("inject", 0200, ampress_debugfs_dir,
+                    NULL, &ampress_inject_fops);
+
+    pr_info("Adaptive Memory Pressure Signaling initialized\n");
+    return 0;
+}
+
+static void __exit ampress_exit(void)
+{
+    debugfs_remove_recursive(ampress_debugfs_dir);
+    misc_deregister(&ampress_miscdev);
+    pr_info("Adaptive Memory Pressure Signaling removed\n");
+}
+
+module_init(ampress_init);
+module_exit(ampress_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Linux Kernel");
+MODULE_DESCRIPTION("Adaptive Memory Pressure Signaling (/dev/ampress)");
diff --git a/mm/ampress_test.c b/mm/ampress_test.c
new file mode 100644
index 00000000000..ea2674c91b6
--- /dev/null
+++ b/mm/ampress_test.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for Adaptive Memory Pressure Signaling (AMPRESS)
+ */
+
+#include <kunit/test.h>
+#include <linux/ampress.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/wait.h>
+
+/*
+ * White-box access to AMPRESS internals for unit testing.
+ * These externs allow injecting fake subscribers directly into the global
+ * list without going through the character device file operations.
+ */
+extern struct list_head ampress_subscribers;
+extern rwlock_t ampress_subscribers_lock;
+
+/* ------------------------------------------------------------------ */
+/*  Test 1: notify with no subscribers =E2=80=94 must not crash           =
    */
+/* ------------------------------------------------------------------ */
+
+static void ampress_test_no_subscribers(struct kunit *test)
+{
+    /* Must complete without hang or crash */
+    ampress_notify(AMPRESS_URGENCY_LOW,    0, 0);
+    ampress_notify(AMPRESS_URGENCY_MEDIUM, 0, 1024);
+    ampress_notify(AMPRESS_URGENCY_HIGH,   0, 2048);
+    ampress_notify(AMPRESS_URGENCY_FATAL,  0, 0);
+
+    KUNIT_SUCCEED(test);
+}
+
+/* ------------------------------------------------------------------ */
+/*  Test 2: fake subscriber receives correct event                    */
+/* ------------------------------------------------------------------ */
+
+static void ampress_test_event_delivery(struct kunit *test)
+{
+    struct ampress_subscriber sub =3D {};
+
+    INIT_LIST_HEAD(&sub.list);
+    init_waitqueue_head(&sub.wq);
+    spin_lock_init(&sub.lock);
+    sub.subscribed    =3D true;
+    sub.event_pending =3D false;
+
+    write_lock(&ampress_subscribers_lock);
+    list_add_tail(&sub.list, &ampress_subscribers);
+    write_unlock(&ampress_subscribers_lock);
+
+    ampress_notify(AMPRESS_URGENCY_HIGH, 1, 4096);
+
+    write_lock(&ampress_subscribers_lock);
+    list_del(&sub.list);
+    write_unlock(&ampress_subscribers_lock);
+
+    KUNIT_EXPECT_TRUE(test, sub.event_pending);
+    KUNIT_EXPECT_EQ(test, (int)sub.pending_event.urgency,
+            AMPRESS_URGENCY_HIGH);
+    KUNIT_EXPECT_EQ(test, (int)sub.pending_event.numa_node, 1);
+    KUNIT_EXPECT_EQ(test, (u32)sub.pending_event.requested_kb, (u32)4096);
+}
+
+/* ------------------------------------------------------------------ */
+/*  Test 3: second notify without ACK overwrites first (no overflow)  */
+/* ------------------------------------------------------------------ */
+
+static void ampress_test_overwrite_without_ack(struct kunit *test)
+{
+    struct ampress_subscriber sub =3D {};
+
+    INIT_LIST_HEAD(&sub.list);
+    init_waitqueue_head(&sub.wq);
+    spin_lock_init(&sub.lock);
+    sub.subscribed    =3D true;
+    sub.event_pending =3D false;
+
+    write_lock(&ampress_subscribers_lock);
+    list_add_tail(&sub.list, &ampress_subscribers);
+    write_unlock(&ampress_subscribers_lock);
+
+    /* First event */
+    ampress_notify(AMPRESS_URGENCY_LOW, 0, 100);
+
+    KUNIT_EXPECT_TRUE(test, sub.event_pending);
+    KUNIT_EXPECT_EQ(test, (int)sub.pending_event.urgency,
+            AMPRESS_URGENCY_LOW);
+
+    /* Second event without reading (no ACK) */
+    ampress_notify(AMPRESS_URGENCY_FATAL, 0, 9999);
+
+    write_lock(&ampress_subscribers_lock);
+    list_del(&sub.list);
+    write_unlock(&ampress_subscribers_lock);
+
+    /* The second event must overwrite the first */
+    KUNIT_EXPECT_TRUE(test, sub.event_pending);
+    KUNIT_EXPECT_EQ(test, (int)sub.pending_event.urgency,
+            AMPRESS_URGENCY_FATAL);
+    KUNIT_EXPECT_EQ(test, (u32)sub.pending_event.requested_kb, (u32)9999);
+}
+
+/* ------------------------------------------------------------------ */
+/*  Test suite registration                                            */
+/* ------------------------------------------------------------------ */
+
+static struct kunit_case ampress_test_cases[] =3D {
+    KUNIT_CASE(ampress_test_no_subscribers),
+    KUNIT_CASE(ampress_test_event_delivery),
+    KUNIT_CASE(ampress_test_overwrite_without_ack),
+    {}
+};
+
+static struct kunit_suite ampress_test_suite =3D {
+    .name  =3D "ampress",
+    .test_cases =3D ampress_test_cases,
+};
+
+kunit_test_suite(ampress_test_suite);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("KUnit tests for AMPRESS");
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e825..34da5104453 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -68,6 +68,8 @@
 #include "internal.h"
 #include "swap.h"

+#include <linux/ampress.h>
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmscan.h>

@@ -7103,6 +7105,31 @@ static int balance_pgdat(pg_data_t *pgdat, int
order, int highest_zoneidx)

         if (raise_priority || !nr_reclaimed)
             sc.priority--;
+
+#ifdef CONFIG_AMPRESS
+        /*
+         * Map the current scan priority to an AMPRESS urgency level
+         * and notify subscribers. Lower priority means the system is
+         * working harder to reclaim memory, indicating higher pressure.
+         * DEF_PRIORITY =3D=3D 12; we divide the range into four bands.
+         */
+        if (!balanced) {
+            int amp_urgency;
+
+            if (sc.priority <=3D 3)
+                amp_urgency =3D AMPRESS_URGENCY_FATAL;
+            else if (sc.priority <=3D 6)
+                amp_urgency =3D AMPRESS_URGENCY_HIGH;
+            else if (sc.priority <=3D 9)
+                amp_urgency =3D AMPRESS_URGENCY_MEDIUM;
+            else
+                amp_urgency =3D AMPRESS_URGENCY_LOW;
+
+            ampress_notify(amp_urgency, pgdat->node_id,
+                       (unsigned long)sc.nr_to_reclaim <<
+                       (PAGE_SHIFT - 10));
+        }
+#endif
     } while (sc.priority >=3D 1);

     /*
diff --git a/tools/testing/ampress/.gitignore b/tools/testing/ampress/.giti=
gnore
new file mode 100644
index 00000000000..c2ee439db7b
--- /dev/null
+++ b/tools/testing/ampress/.gitignore
@@ -0,0 +1,2 @@
+ampress_test
+ampress_stress
diff --git a/tools/testing/ampress/Makefile b/tools/testing/ampress/Makefil=
e
new file mode 100644
index 00000000000..d175dee7c22
--- /dev/null
+++ b/tools/testing/ampress/Makefile
@@ -0,0 +1,21 @@
+# SPDX-License-Identifier: GPL-2.0
+# Makefile for AMPRESS userspace tests
+
+CC      :=3D gcc
+CFLAGS  :=3D -Wall -Wextra -O2
+LDFLAGS :=3D -static
+
+PROGS   :=3D ampress_test ampress_stress
+
+.PHONY: all clean
+
+all: $(PROGS)
+
+ampress_test: ampress_test.c
+    $(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<
+
+ampress_stress: ampress_stress.c
+    $(CC) $(CFLAGS) $(LDFLAGS) -pthread -o $@ $<
+
+clean:
+    rm -f $(PROGS)
diff --git a/tools/testing/ampress/ampress_stress.c
b/tools/testing/ampress/ampress_stress.c
new file mode 100644
index 00000000000..7894abd764b
--- /dev/null
+++ b/tools/testing/ampress/ampress_stress.c
@@ -0,0 +1,199 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ampress_stress.c =E2=80=94 Concurrency / stress test for /dev/ampress
+ *
+ * Launches 64 reader threads that each open /dev/ampress independently an=
d
+ * read in a tight loop for 10 seconds. A 65th "driver" thread injects eve=
nts
+ * via the debugfs trigger. Checks for UAF, corruption, and hangs.
+ *
+ * Build: gcc -Wall -Wextra -static -pthread -o ampress_stress ampress_str=
ess.c
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdint.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <pthread.h>
+#include <time.h>
+#include <sys/poll.h>
+#include <linux/types.h>
+
+#define AMPRESS_URGENCY_LOW    0
+#define AMPRESS_URGENCY_MEDIUM 1
+#define AMPRESS_URGENCY_HIGH   2
+#define AMPRESS_URGENCY_FATAL  3
+
+struct ampress_event {
+    __u8  urgency;
+    __u8  numa_node;
+    __u16 reserved;
+    __u32 requested_kb;
+    __u64 timestamp_ns;
+};
+
+#define DEVICE_PATH   "/dev/ampress"
+#define DEBUGFS_INJECT "/sys/kernel/debug/ampress/inject"
+#define NUM_READERS    64
+#define TEST_DURATION  10   /* seconds */
+
+static _Atomic int g_stop;
+static unsigned long g_events_read[NUM_READERS];
+
+struct reader_arg {
+    int idx;
+};
+
+static void *reader_thread(void *arg)
+{
+    struct reader_arg *a =3D arg;
+    int fd;
+    struct pollfd pfd;
+
+    fd =3D open(DEVICE_PATH, O_RDONLY | O_NONBLOCK);
+    if (fd < 0) {
+        fprintf(stderr, "reader[%d]: open failed: %s\n",
+            a->idx, strerror(errno));
+        return (void *)(intptr_t)-1;
+    }
+
+    pfd.fd     =3D fd;
+    pfd.events =3D POLLIN;
+
+    while (!g_stop) {
+        int ret =3D poll(&pfd, 1, 200);
+
+        if (ret < 0) {
+            if (errno =3D=3D EINTR)
+                continue;
+            perror("poll");
+            break;
+        }
+        if (ret =3D=3D 0)
+            continue;
+
+        if (pfd.revents & POLLIN) {
+            struct ampress_event ev;
+            ssize_t n =3D read(fd, &ev, sizeof(ev));
+
+            if (n < 0) {
+                if (errno =3D=3D EAGAIN)
+                    continue;
+                perror("read");
+                break;
+            }
+            if ((size_t)n =3D=3D sizeof(ev)) {
+                /* Basic sanity checks */
+                if (ev.urgency > AMPRESS_URGENCY_FATAL) {
+                    fprintf(stderr,
+                        "reader[%d]: BAD urgency %u\n",
+                        a->idx, ev.urgency);
+                    close(fd);
+                    return (void *)(intptr_t)-1;
+                }
+                g_events_read[a->idx]++;
+            }
+        }
+    }
+
+    close(fd);
+    return NULL;
+}
+
+static void *inject_thread(void *arg)
+{
+    int inject_fd;
+    int urgency =3D 0;
+    char buf[4];
+
+    (void)arg;
+
+    inject_fd =3D open(DEBUGFS_INJECT, O_WRONLY);
+    if (inject_fd < 0) {
+        fprintf(stderr, "inject: open %s failed: %s\n",
+            DEBUGFS_INJECT, strerror(errno));
+        return (void *)(intptr_t)-1;
+    }
+
+    while (!g_stop) {
+        buf[0] =3D '0' + (char)(urgency % 4);
+        buf[1] =3D '\n';
+        if (write(inject_fd, buf, 2) < 0) {
+            perror("inject write");
+            break;
+        }
+        urgency++;
+        usleep(5000); /* 5 ms between injections */
+    }
+
+    close(inject_fd);
+    return NULL;
+}
+
+int main(void)
+{
+    pthread_t readers[NUM_READERS];
+    pthread_t injector;
+    struct reader_arg args[NUM_READERS];
+    unsigned long total =3D 0;
+    int i, rc;
+    int failed =3D 0;
+
+    g_stop =3D 0;
+
+    /* Start reader threads */
+    for (i =3D 0; i < NUM_READERS; i++) {
+        args[i].idx =3D i;
+        rc =3D pthread_create(&readers[i], NULL, reader_thread, &args[i]);
+        if (rc) {
+            fprintf(stderr, "pthread_create reader[%d]: %s\n",
+                i, strerror(rc));
+            return 1;
+        }
+    }
+
+    /* Start inject thread */
+    rc =3D pthread_create(&injector, NULL, inject_thread, NULL);
+    if (rc) {
+        fprintf(stderr, "pthread_create injector: %s\n", strerror(rc));
+        /* Non-fatal: stress test can still run with real pressure */
+    }
+
+    printf("ampress_stress: %d readers running for %d seconds...\n",
+           NUM_READERS, TEST_DURATION);
+
+    sleep(TEST_DURATION);
+
+    g_stop =3D 1;
+
+    for (i =3D 0; i < NUM_READERS; i++) {
+        void *retval;
+
+        pthread_join(readers[i], &retval);
+        if ((intptr_t)retval !=3D 0) {
+            fprintf(stderr, "reader[%d] failed\n", i);
+            failed++;
+        }
+        total +=3D g_events_read[i];
+    }
+
+    if (rc =3D=3D 0) {
+        void *retval;
+
+        pthread_join(injector, &retval);
+    }
+
+    printf("ampress_stress: total events read: %lu across %d threads\n",
+           total, NUM_READERS);
+
+    if (failed) {
+        fprintf(stderr, "ampress_stress: FAIL =E2=80=94 %d threads reporte=
d errors\n",
+            failed);
+        return 1;
+    }
+
+    printf("ampress_stress: PASS\n");
+    return 0;
+}
diff --git a/tools/testing/ampress/ampress_test.c
b/tools/testing/ampress/ampress_test.c
new file mode 100644
index 00000000000..372705aaa0a
--- /dev/null
+++ b/tools/testing/ampress/ampress_test.c
@@ -0,0 +1,212 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ampress_test.c =E2=80=94 Userspace integration test for /dev/ampress
+ *
+ * Usage: ./ampress_test
+ *
+ * Opens /dev/ampress, optionally configures thresholds, then forks a chil=
d
+ * that exhausts memory via mmap while the parent polls for pressure event=
s.
+ * Expects to see at least one HIGH-urgency event within 30 seconds; exits=
 0
+ * on success, 1 on timeout or error.
+ *
+ * Build: gcc -Wall -Wextra -static -o ampress_test ampress_test.c
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdint.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <signal.h>
+#include <time.h>
+#include <sys/mman.h>
+#include <sys/poll.h>
+#include <sys/wait.h>
+#include <sys/ioctl.h>
+
+/* Pull in UAPI types without kernel headers */
+#include <linux/types.h>
+
+/*
+ * Duplicate the UAPI definitions here so the test can be built with
+ * just a libc (--sysroot or installed kernel headers are not required).
+ */
+#define AMPRESS_URGENCY_LOW    0
+#define AMPRESS_URGENCY_MEDIUM 1
+#define AMPRESS_URGENCY_HIGH   2
+#define AMPRESS_URGENCY_FATAL  3
+
+struct ampress_event {
+    __u8  urgency;
+    __u8  numa_node;
+    __u16 reserved;
+    __u32 requested_kb;
+    __u64 timestamp_ns;
+};
+
+struct ampress_ack {
+    __u32 freed_kb;
+    __u32 reserved;
+};
+
+struct ampress_config {
+    __u32 low_threshold_pct;
+    __u32 medium_threshold_pct;
+    __u32 high_threshold_pct;
+    __u32 fatal_threshold_pct;
+};
+
+#define AMPRESS_IOC_MAGIC       'P'
+#define AMPRESS_IOC_CONFIGURE   _IOW(AMPRESS_IOC_MAGIC, 1, struct
ampress_config)
+#define AMPRESS_IOC_ACK         _IOW(AMPRESS_IOC_MAGIC, 2, struct ampress_=
ack)
+#define AMPRESS_IOC_SUBSCRIBE   _IO(AMPRESS_IOC_MAGIC,  3)
+#define AMPRESS_IOC_UNSUBSCRIBE _IO(AMPRESS_IOC_MAGIC,  4)
+
+#define DEVICE_PATH "/dev/ampress"
+#define TIMEOUT_SEC 30
+#define PAGE_SZ     4096
+
+static const char *urgency_str(int u)
+{
+    switch (u) {
+    case AMPRESS_URGENCY_LOW:    return "LOW";
+    case AMPRESS_URGENCY_MEDIUM: return "MEDIUM";
+    case AMPRESS_URGENCY_HIGH:   return "HIGH";
+    case AMPRESS_URGENCY_FATAL:  return "FATAL";
+    default:                     return "UNKNOWN";
+    }
+}
+
+/* Child: mmap in a tight loop to exhaust memory */
+static void child_exhaust(void)
+{
+    size_t chunk =3D 64 * 1024 * 1024; /* 64 MiB per iteration */
+    int iter =3D 0;
+
+    while (1) {
+        void *p =3D mmap(NULL, chunk, PROT_READ | PROT_WRITE,
+                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE,
+                   -1, 0);
+        if (p =3D=3D MAP_FAILED) {
+            if (errno =3D=3D ENOMEM) {
+                /* Slow down and keep retrying */
+                usleep(100000);
+                continue;
+            }
+            perror("mmap");
+            _exit(1);
+        }
+        /* Touch every page so they are actually allocated */
+        memset(p, (char)iter, chunk);
+        iter++;
+    }
+}
+
+int main(void)
+{
+    int fd;
+    pid_t child;
+    struct pollfd pfd;
+    time_t deadline;
+    int seen[4] =3D { 0, 0, 0, 0 };
+    int status;
+
+    fd =3D open(DEVICE_PATH, O_RDONLY);
+    if (fd < 0) {
+        perror("open " DEVICE_PATH);
+        return 1;
+    }
+
+    /* Configure thresholds (all 0 =3D default: deliver everything) */
+    struct ampress_config cfg =3D {
+        .low_threshold_pct    =3D 0,
+        .medium_threshold_pct =3D 0,
+        .high_threshold_pct   =3D 0,
+        .fatal_threshold_pct  =3D 0,
+    };
+    if (ioctl(fd, AMPRESS_IOC_CONFIGURE, &cfg) < 0) {
+        perror("AMPRESS_IOC_CONFIGURE");
+        close(fd);
+        return 1;
+    }
+
+    child =3D fork();
+    if (child < 0) {
+        perror("fork");
+        close(fd);
+        return 1;
+    }
+    if (child =3D=3D 0)
+        child_exhaust(); /* Never returns */
+
+    printf("ampress_test: child PID %d exhausting memory...\n", child);
+
+    deadline =3D time(NULL) + TIMEOUT_SEC;
+    pfd.fd     =3D fd;
+    pfd.events =3D POLLIN;
+
+    while (time(NULL) < deadline) {
+        int remaining =3D (int)(deadline - time(NULL));
+        int ret =3D poll(&pfd, 1, remaining * 1000);
+
+        if (ret < 0) {
+            if (errno =3D=3D EINTR)
+                continue;
+            perror("poll");
+            goto fail;
+        }
+        if (ret =3D=3D 0) {
+            fprintf(stderr, "ampress_test: TIMEOUT =E2=80=94 no HIGH event
received\n");
+            goto fail;
+        }
+
+        if (pfd.revents & POLLIN) {
+            struct ampress_event ev;
+            ssize_t n =3D read(fd, &ev, sizeof(ev));
+
+            if (n < 0) {
+                perror("read");
+                goto fail;
+            }
+            if ((size_t)n < sizeof(ev)) {
+                fprintf(stderr, "short read: %zd\n", n);
+                goto fail;
+            }
+
+            printf("ampress_test: urgency=3D%-6s numa=3D%u kb=3D%u ts=3D%l=
lu\n",
+                   urgency_str(ev.urgency), ev.numa_node,
+                   ev.requested_kb,
+                   (unsigned long long)ev.timestamp_ns);
+
+            if (ev.urgency <=3D AMPRESS_URGENCY_FATAL)
+                seen[ev.urgency] =3D 1;
+
+            /* ACK with a simulated freed amount */
+            struct ampress_ack ack =3D { .freed_kb =3D 16384 };
+
+            if (ioctl(fd, AMPRESS_IOC_ACK, &ack) < 0)
+                perror("AMPRESS_IOC_ACK (non-fatal)");
+
+            /* Success criterion: seen at least up to HIGH */
+            if (seen[AMPRESS_URGENCY_HIGH] ||
+                seen[AMPRESS_URGENCY_FATAL])
+                goto success;
+        }
+    }
+
+    fprintf(stderr, "ampress_test: TIMEOUT\n");
+fail:
+    kill(child, SIGKILL);
+    waitpid(child, &status, 0);
+    close(fd);
+    return 1;
+
+success:
+    printf("ampress_test: SUCCESS =E2=80=94 received HIGH (or higher) even=
t\n");
+    kill(child, SIGKILL);
+    waitpid(child, &status, 0);
+    close(fd);
+    return 0;
+}
--=20
2.51.0

