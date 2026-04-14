Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63A2AF9D0F2
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 20:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5B996B0089; Tue, 14 Apr 2026 16:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B332C6B0092; Tue, 14 Apr 2026 16:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB4D6B0093; Tue, 14 Apr 2026 16:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8BDB96B0089
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 16:02:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 454061A0188
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:02:44 +0000 (UTC)
X-FDA: 84658234248.21.FD22587
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 74C16180013
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 20:02:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=W62R86i1;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776196962; a=rsa-sha256;
	cv=none;
	b=V3Xx8/67JC1Yxej3+vtr4VDG9vZvVKlKC2N9TtqgLQHqslvC5mWpgaDdl1HwnAXiQDK0d5
	00l93u7BGog0s4sQinZ1K2WsEgeN3u9Fe8AkeBxLj73OG8OF/+E1bNBNCGuQFxz//r0XQu
	ZmYIL2ETGSvfv+Ctm+t5GvbI4FZzAQc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776196962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCjDlIp8tcNOYvfHKmC0ZdWTLeU0ejjgXIXAdGPq7KQ=;
	b=KyNYQUCteCF55d0LlCHI1qJgn4jBb4kiLAqxOZnHrBpA+dO0pbTKk03zGEvttyaaDFyxB2
	5AhXsUaieYdCpFpbY+nGWjptFztvH/OMM4I8rOC7tYw6fsYc6B+V8AjaTK13P3QvqB8MSH
	b0xy0zmBeuihLGaRWwl+K0qBuY6nTJk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=W62R86i1;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8a4b8c3a30bso68710256d6.3
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 13:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776196961; x=1776801761; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LCjDlIp8tcNOYvfHKmC0ZdWTLeU0ejjgXIXAdGPq7KQ=;
        b=W62R86i12wVkU66yDB/bMV9gfBwMB+IN8K2meIaSFJv3geGLuwX8xeFmfg1qDGSz6O
         ncIbl6pos8DHT0atYC+7Yak4l/DOIxX6YmnEd8/aKMIX9OBZqxT5A2zG3kJIkn2RQBmU
         skXH8/effhoAt2FLcpccEVdahSDk7ZALTfHxjDrGHyS5/T3ZNdul3T9TE++VO8z1Wp60
         7Fo+62tPgXZYoqwgrwFNh/qM6uL2zCqFrm5NGM9lmhBpDcAifzb0TuV4dA5nPHT9M2gi
         foA12Y9S4gKPKOsMoytgt1XKidnVVSafsp675zKu/656UGmSJC/mjrw7BxkpXKF1ueVK
         zvHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776196961; x=1776801761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LCjDlIp8tcNOYvfHKmC0ZdWTLeU0ejjgXIXAdGPq7KQ=;
        b=H2aUR9BdDYRxMNuruxLWDxVGOKz5+E0Uw00jRqFu+tDMLnddVV2LGjDK+q/ONRmQwn
         lhJdyvHsdwJFYRYukGH6LjU/RTh0R7SrWLqgiRh6Y8JrLrjQxC7KhMkvdt9wPZWApQ4X
         jalob9oSaY6pHrUoE7JQn0PG35i35geqtWKR6fcTcFfR1yZgVAUUtSlxz2VoNUFyZdmA
         fHWbYVop/g2VEoPJjalyhIJR6rG6XRr4EtVsTrbRiyhrt/Dy03f31YBCQANcPvWBKttz
         zgoREl9fyQ6fjzvuSujjQq3qCafkYakA6/kcq/frvYo8te3p6Zz/OnDRbZd1fD53oC2C
         mc7Q==
X-Forwarded-Encrypted: i=1; AFNElJ80FHChIIiRhwgX3ILfHU/aUJZBbolkcBbNpnbDj+QNqQw/tIPWOuDfnShTNx7Etqm4QQIwxRV0SQ==@kvack.org
X-Gm-Message-State: AOJu0YwzSoK1okFGXQyPrBY300ieLqDRt3MU6Pt3S0Zzxs1tcO0lGGvd
	cH+s4utM865YiGF+IkJ8fM63KOAMZFRROoRZ91pcXvDQI8A4sHtuwhck78hiLj4SlyE=
X-Gm-Gg: AeBDievf7er18EQzo9/WSXstz8wHeO9qyajtwLfGgK0Rm/4eBtxdrTWv1/ikowXrwwG
	Px2nVqOjehlo0BSaVcpX6E9HRd73iLOTjZj7OZxJjTMUejKVv5ZdLSQhaUD3g3G6wyFtQrBpzc2
	00YSjSTjxJ4hzm9pnIRCgUQ/bx4ilGhvxBkLlFm7fdTQF9HCMddUSkSdKt4gKR98utMw9jq6Ijo
	+Dsc1F4x1SLWUReWnRWjbcdAQln3KFZQ7cayYqaPXe3444asWNmgjCnbE2MSamblmLNPbJtfdDR
	ZG9UKgJlXhIOGpsnhsC7Rj5vr7vf3jMVPH2Ry8eVRiaut1NzFe/M5iBeekGzXD6aywlPUrCp/Of
	cv4kg26hzmxKvi9E3VY8FQWB0hxbVfI6CCOUeFNuE6+jT+T4cS5aS2MsKX61oFPYUaI5lxfXyl0
	Lf313rOL+HbQw2CYIiZbPq1W4j85UcVSJhZ2yxwk3XTJeJSYbAN9ZiyKXMeOE4FKt0EA==
X-Received: by 2002:ad4:5966:0:b0:8ac:b738:45dd with SMTP id 6a1803df08f44-8acb7384f03mr120301296d6.34.1776196961105;
        Tue, 14 Apr 2026 13:02:41 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ac84a180a2sm132213656d6.15.2026.04.14.13.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 13:02:40 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH 1/5] liveupdate: Remove limit on the number of sessions
Date: Tue, 14 Apr 2026 20:02:33 +0000
Message-ID: <20260414200237.444170-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414200237.444170-1-pasha.tatashin@soleen.com>
References: <20260414200237.444170-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 74C16180013
X-Stat-Signature: b5p8nr7f8p5dgodbfa94b1389z7c9opp
X-HE-Tag: 1776196962-988781
X-HE-Meta: U2FsdGVkX1+bhgC8ty2oU/WT6FOaLYZOQ9p4z4Cdw+uFsAkolMrJFYnZlJoV42TFgphXHUU9nIauXFRztmbizl1O9cWmZ6w+ipRg2mpIXEuBufx6UQ63g6L0/84J/+fP1Vkqb6cx2xZ3aXR6BQdp8v+i6AZFt4UbFjoChPToVP0L1YP7qKTBE4yfr0WJvbJGWplKANHe6csoPhGDebGdUg9jP6athGYlEpqrcMpw58Q1Ji8SmsZUtZWgf2V+DsChLhpPVKT35irmGvsJ/JTH+V0xhhUvCHUNrhtGGpHGujyc0nTFmFgwACU13YSdawBSkMBK7PVZyReDZWhnEJUvBDWyvsFzzdL2eKsJPun/2gimao9vofZ0zAT8vGY36q3EyxkqBerlxnEbEsQNTYFxgiPLUSxj4Pn0/pREyfbkoZvc8hlu5ZGGy2sLYtyCDbofKyYKK0fWk+WQltB4rNINELl01kwbaS/XBFd+gMNuFAQpkydwqvEC4Vx72fhnYfgazz243Hvc2pfsSen1rDS9/E0rSfBlVdV6R/kg1gdExivFgVS913LoE8qaHoWP0RdXQieb/Q6jBZpp1nd9cVb2++kEeXaKsluf+y/rncKmkwi4eenG4oV1akHBAyHGVRYHnRGWIrWBc7dOGKWLY7M91MBFULh8NpZ01qfvfvF2ObSlPplW3sBNUgjQ/C0DfxAzwCCvVohvirHS2IIsxzlUxHCyFCTqPpWa/lUN5ZAta3uh6ytxq9M6/VTCk7yBpzMZ4eM1mNCAz8cyGq52C40NfivZj9R4s5IzCMJj4x+bJi8C23vHKoMXZkfYewcD35E2yM2T+U/EFjwE4oaByTFy1t6Jt6Rl6sH8CzoiXqArUPvDlud5sAm5po947nXn0002nSPrZSl7rAOMdGJYUx9zrbby5c0cZI1aiCMk9GOqD3CQapnNr+kRn+GOs/4d7++8lq0KrqWU0gtvrIw0cO5
 DxO0jDYy
 zDEGj12Iv/3nGrqSZANeaEeGG++V5HIDm/gnEeV2O51Oe0HO9alUhwVWGTyhrKB9WRSPWBexAU+Homy3TZU0e+tJ3/WoDUje6kyzgqMj/v7EWz3WnjmmV5mUUp9IkS0qDLJQR1pTN8Ajk8lfd52Cf+b3OCbC+St4GFjJ/MLq962+YwEudL4s23Cwp9/6utIjFNo/Ak80jEbOWM+0hHyIInztfztRGfn3LE22iNDWu0jbXT82xkN5Y+xySE0p7x2MzFx9d+EbqsAbKGLN+BXydu/UY6hWjy3ET7m6/btvZCWpAQYfcvfIPcvLBVJkfjx4gxGzF1xW/0Bo1UDk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the number of LUO sessions is limited by a fixed number of
pre-allocated pages for serialization (16 pages, allowing for ~819
sessions).

This limitation is problematic if LUO is used to support things such as
systemd file descriptor store, and would be used not just as VM memory
but to save other states on the machine.

Remove this limit by transitioning to a linked-block approach for
session metadata serialization. Instead of a single contiguous block,
session metadata is now stored in a chain of 16-page blocks. Each block
starts with a header containing the physical address of the next block
and the number of session entries in the current block.

- Bump session ABI version to v3.
- Update struct luo_session_header_ser to include a 'next' pointer.
- Implement dynamic block allocation in luo_session_insert().
- Update setup, serialization, and deserialization logic to traverse
  the block chain.
- Remove LUO_SESSION_MAX limit.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/luo.h      |  19 +--
 kernel/liveupdate/luo_internal.h |  12 +-
 kernel/liveupdate/luo_session.c  | 237 +++++++++++++++++++++++--------
 3 files changed, 197 insertions(+), 71 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 46750a0ddf88..f5732958545e 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -57,9 +57,10 @@
  *   - compatible: "luo-session-v1"
  *     Identifies the session ABI version.
  *   - luo-session-header: u64
- *     The physical address of a `struct luo_session_header_ser`. This structure
- *     is the header for a contiguous block of memory containing an array of
- *     `struct luo_session_ser`, one for each preserved session.
+ *     The physical address of the first `struct luo_session_header_ser`.
+ *     This structure is the header for a block of memory containing an array
+ *     of `struct luo_session_ser` entries. Multiple blocks are linked via
+ *     the `next` field in the header.
  *
  * File-Lifecycle-Bound Node (luo-flb):
  *   This node describes all preserved global objects whose lifecycle is bound
@@ -77,9 +78,9 @@
  *   `__packed` structures. These structures contain the actual preserved state.
  *
  *   - struct luo_session_header_ser:
- *     Header for the session array. Contains the total page count of the
- *     preserved memory block and the number of `struct luo_session_ser`
- *     entries that follow.
+ *     Header for the session data block. Contains the physical address of the
+ *     next session data block and the number of `struct luo_session_ser`
+ *     entries that follow this header in the current block.
  *
  *   - struct luo_session_ser:
  *     Metadata for a single session, including its name and a physical pointer
@@ -153,21 +154,23 @@ struct luo_file_set_ser {
  *                          luo_session_header_ser
  */
 #define LUO_FDT_SESSION_NODE_NAME	"luo-session"
-#define LUO_FDT_SESSION_COMPATIBLE	"luo-session-v2"
+#define LUO_FDT_SESSION_COMPATIBLE	"luo-session-v3"
 #define LUO_FDT_SESSION_HEADER		"luo-session-header"
 
 /**
  * struct luo_session_header_ser - Header for the serialized session data block.
+ * @next:  Physical address of the next struct luo_session_header_ser.
  * @count: The number of `struct luo_session_ser` entries that immediately
  *         follow this header in the memory block.
  *
- * This structure is located at the beginning of a contiguous block of
+ * This structure is located at the beginning of a block of
  * physical memory preserved across the kexec. It provides the necessary
  * metadata to interpret the array of session entries that follow.
  *
  * If this structure is modified, `LUO_FDT_SESSION_COMPATIBLE` must be updated.
  */
 struct luo_session_header_ser {
+	u64 next;
 	u64 count;
 } __packed;
 
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 875844d7a41d..a73f42069301 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -11,6 +11,16 @@
 #include <linux/liveupdate.h>
 #include <linux/uaccess.h>
 
+/*
+ * Safeguard limit for the number of serialization blocks. This is used to
+ * prevent infinite loops and excessive memory allocation in case of memory
+ * corruption in the preserved state.
+ *
+ * This limit allows for ~8.1 million sessions and ~1.2 million files per
+ * session, which is more than enough for all realistic use cases.
+ */
+#define LUO_MAX_BLOCKS 10000
+
 struct luo_ucmd {
 	void __user *ubuffer;
 	u32 user_size;
@@ -59,7 +69,6 @@ struct luo_file_set {
  * struct luo_session - Represents an active or incoming Live Update session.
  * @name:       A unique name for this session, used for identification and
  *              retrieval.
- * @ser:        Pointer to the serialized data for this session.
  * @list:       A list_head member used to link this session into a global list
  *              of either outgoing (to be preserved) or incoming (restored from
  *              previous kernel) sessions.
@@ -70,7 +79,6 @@ struct luo_file_set {
  */
 struct luo_session {
 	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
-	struct luo_session_ser *ser;
 	struct list_head list;
 	bool retrieved;
 	struct luo_file_set file_set;
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 92b1af791889..007ca34eba79 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -69,30 +69,39 @@
 #include <uapi/linux/liveupdate.h>
 #include "luo_internal.h"
 
-/* 16 4K pages, give space for 744 sessions */
+/* 16 4K pages, give space for 819 sessions per block */
 #define LUO_SESSION_PGCNT	16ul
-#define LUO_SESSION_MAX		(((LUO_SESSION_PGCNT << PAGE_SHIFT) -	\
+#define LUO_SESSION_BLOCK_MAX		(((LUO_SESSION_PGCNT << PAGE_SHIFT) -	\
 		sizeof(struct luo_session_header_ser)) /		\
 		sizeof(struct luo_session_ser))
 
+/**
+ * struct luo_session_block - Internal representation of a session serialization block.
+ * @list: List head for linking blocks in memory.
+ * @ser:  Pointer to the serialized header in preserved memory.
+ */
+struct luo_session_block {
+	struct list_head list;
+	struct luo_session_header_ser *ser;
+};
+
 /**
  * struct luo_session_header - Header struct for managing LUO sessions.
  * @count:      The number of sessions currently tracked in the @list.
+ * @nblocks:    The number of allocated serialization blocks.
  * @list:       The head of the linked list of `struct luo_session` instances.
  * @rwsem:      A read-write semaphore providing synchronized access to the
  *              session list and other fields in this structure.
- * @header_ser: The header data of serialization array.
- * @ser:        The serialized session data (an array of
- *              `struct luo_session_ser`).
+ * @blocks:     The list of serialization blocks (struct luo_session_block).
  * @active:     Set to true when first initialized. If previous kernel did not
  *              send session data, active stays false for incoming.
  */
 struct luo_session_header {
 	long count;
+	long nblocks;
 	struct list_head list;
 	struct rw_semaphore rwsem;
-	struct luo_session_header_ser *header_ser;
-	struct luo_session_ser *ser;
+	struct list_head blocks;
 	bool active;
 };
 
@@ -110,10 +119,12 @@ static struct luo_session_global luo_session_global = {
 	.incoming = {
 		.list = LIST_HEAD_INIT(luo_session_global.incoming.list),
 		.rwsem = __RWSEM_INITIALIZER(luo_session_global.incoming.rwsem),
+		.blocks = LIST_HEAD_INIT(luo_session_global.incoming.blocks),
 	},
 	.outgoing = {
 		.list = LIST_HEAD_INIT(luo_session_global.outgoing.list),
 		.rwsem = __RWSEM_INITIALIZER(luo_session_global.outgoing.rwsem),
+		.blocks = LIST_HEAD_INIT(luo_session_global.outgoing.blocks),
 	},
 };
 
@@ -140,6 +151,70 @@ static void luo_session_free(struct luo_session *session)
 	kfree(session);
 }
 
+static int luo_session_add_block(struct luo_session_header *sh,
+				 struct luo_session_header_ser *ser)
+{
+	struct luo_session_block *block;
+
+	if (sh->nblocks >= LUO_MAX_BLOCKS)
+		return -ENOSPC;
+
+	block = kzalloc_obj(*block);
+	if (!block)
+		return -ENOMEM;
+
+	block->ser = ser;
+	list_add_tail(&block->list, &sh->blocks);
+	sh->nblocks++;
+
+	return 0;
+}
+
+static int luo_session_create_ser_block(struct luo_session_header *sh)
+{
+	struct luo_session_block *last = NULL;
+	struct luo_session_header_ser *ser;
+	int err;
+
+	ser = kho_alloc_preserve(LUO_SESSION_PGCNT << PAGE_SHIFT);
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	if (!list_empty(&sh->blocks))
+		last = list_last_entry(&sh->blocks, struct luo_session_block, list);
+
+	err = luo_session_add_block(sh, ser);
+	if (err)
+		goto err_unpreserve;
+
+	if (last)
+		last->ser->next = virt_to_phys(ser);
+
+	return 0;
+
+err_unpreserve:
+	kho_unpreserve_free(ser);
+	return err;
+}
+
+static void luo_session_destroy_ser_blocks(struct luo_session_header *sh,
+					   bool unpreserve)
+{
+	struct luo_session_block *block, *tmp;
+
+	list_for_each_entry_safe(block, tmp, &sh->blocks, list) {
+		if (block->ser) {
+			if (unpreserve)
+				kho_unpreserve_free(block->ser);
+			else
+				kho_restore_free(block->ser);
+		}
+		list_del(&block->list);
+		kfree(block);
+		sh->nblocks--;
+	}
+}
+
 static int luo_session_insert(struct luo_session_header *sh,
 			      struct luo_session *session)
 {
@@ -147,15 +222,6 @@ static int luo_session_insert(struct luo_session_header *sh,
 
 	guard(rwsem_write)(&sh->rwsem);
 
-	/*
-	 * For outgoing we should make sure there is room in serialization array
-	 * for new session.
-	 */
-	if (sh == &luo_session_global.outgoing) {
-		if (sh->count == LUO_SESSION_MAX)
-			return -ENOMEM;
-	}
-
 	/*
 	 * For small number of sessions this loop won't hurt performance
 	 * but if we ever start using a lot of sessions, this might
@@ -166,6 +232,20 @@ static int luo_session_insert(struct luo_session_header *sh,
 		if (!strncmp(it->name, session->name, sizeof(it->name)))
 			return -EEXIST;
 	}
+
+	/*
+	 * For outgoing we should make sure there is room in serialization array
+	 * for new session. If not, allocate a new block.
+	 */
+	if (sh == &luo_session_global.outgoing) {
+		if (sh->count == sh->nblocks * LUO_SESSION_BLOCK_MAX) {
+			int err = luo_session_create_ser_block(sh);
+
+			if (err)
+				return err;
+		}
+	}
+
 	list_add_tail(&session->list, &sh->list);
 	sh->count++;
 
@@ -444,9 +524,12 @@ int __init luo_session_setup_outgoing(void *fdt_out)
 	u64 header_ser_pa;
 	int err;
 
-	header_ser = kho_alloc_preserve(LUO_SESSION_PGCNT << PAGE_SHIFT);
-	if (IS_ERR(header_ser))
-		return PTR_ERR(header_ser);
+	err = luo_session_create_ser_block(&luo_session_global.outgoing);
+	if (err)
+		return err;
+
+	header_ser = list_first_entry(&luo_session_global.outgoing.blocks,
+				      struct luo_session_block, list)->ser;
 	header_ser_pa = virt_to_phys(header_ser);
 
 	err = fdt_begin_node(fdt_out, LUO_FDT_SESSION_NODE_NAME);
@@ -459,19 +542,18 @@ int __init luo_session_setup_outgoing(void *fdt_out)
 	if (err)
 		goto err_unpreserve;
 
-	luo_session_global.outgoing.header_ser = header_ser;
-	luo_session_global.outgoing.ser = (void *)(header_ser + 1);
 	luo_session_global.outgoing.active = true;
 
 	return 0;
 
 err_unpreserve:
-	kho_unpreserve_free(header_ser);
+	luo_session_destroy_ser_blocks(&luo_session_global.outgoing, true);
 	return err;
 }
 
 int __init luo_session_setup_incoming(void *fdt_in)
 {
+	struct luo_session_header *sh = &luo_session_global.incoming;
 	struct luo_session_header_ser *header_ser;
 	int err, header_size, offset;
 	u64 header_ser_pa;
@@ -501,11 +583,14 @@ int __init luo_session_setup_incoming(void *fdt_in)
 	}
 
 	header_ser_pa = get_unaligned((u64 *)ptr);
-	header_ser = phys_to_virt(header_ser_pa);
-
-	luo_session_global.incoming.header_ser = header_ser;
-	luo_session_global.incoming.ser = (void *)(header_ser + 1);
-	luo_session_global.incoming.active = true;
+	while (header_ser_pa) {
+		header_ser = phys_to_virt(header_ser_pa);
+		err = luo_session_add_block(sh, header_ser);
+		if (err)
+			return err;
+		header_ser_pa = header_ser->next;
+	}
+	sh->active = true;
 
 	return 0;
 }
@@ -513,6 +598,7 @@ int __init luo_session_setup_incoming(void *fdt_in)
 int luo_session_deserialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.incoming;
+	struct luo_session_block *block;
 	static bool is_deserialized;
 	static int err;
 
@@ -539,40 +625,49 @@ int luo_session_deserialize(void)
 	 * userspace to detect the failure and trigger a reboot, which will
 	 * reliably reset devices and reclaim memory.
 	 */
-	for (int i = 0; i < sh->header_ser->count; i++) {
-		struct luo_session *session;
-
-		session = luo_session_alloc(sh->ser[i].name);
-		if (IS_ERR(session)) {
-			pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
-				(int)sizeof(sh->ser[i].name),
-				sh->ser[i].name, session);
-			err = PTR_ERR(session);
-			return err;
-		}
+	list_for_each_entry(block, &sh->blocks, list) {
+		struct luo_session_ser *ser = (void *)(block->ser + 1);
 
-		err = luo_session_insert(sh, session);
-		if (err) {
-			pr_warn("Failed to insert session [%s] %pe\n",
-				session->name, ERR_PTR(err));
-			luo_session_free(session);
+		if (block->ser->count > LUO_SESSION_BLOCK_MAX) {
+			pr_warn("Session block contains too many entries: %llu\n",
+				block->ser->count);
+			err = -EINVAL;
 			return err;
 		}
 
-		scoped_guard(mutex, &session->mutex) {
-			err = luo_file_deserialize(&session->file_set,
-						   &sh->ser[i].file_set_ser);
-		}
-		if (err) {
-			pr_warn("Failed to deserialize files for session [%s] %pe\n",
-				session->name, ERR_PTR(err));
-			return err;
+		for (int i = 0; i < block->ser->count; i++) {
+			struct luo_session *session;
+
+			session = luo_session_alloc(ser[i].name);
+			if (IS_ERR(session)) {
+				pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
+					(int)sizeof(ser[i].name),
+					ser[i].name, session);
+				err = PTR_ERR(session);
+				return err;
+			}
+
+			err = luo_session_insert(sh, session);
+			if (err) {
+				pr_warn("Failed to insert session [%s] %pe\n",
+					session->name, ERR_PTR(err));
+				luo_session_free(session);
+				return err;
+			}
+
+			scoped_guard(mutex, &session->mutex) {
+				err = luo_file_deserialize(&session->file_set,
+							   &ser[i].file_set_ser);
+			}
+			if (err) {
+				pr_warn("Failed to deserialize files for session [%s] %pe\n",
+					session->name, ERR_PTR(err));
+				return err;
+			}
 		}
 	}
 
-	kho_restore_free(sh->header_ser);
-	sh->header_ser = NULL;
-	sh->ser = NULL;
+	luo_session_destroy_ser_blocks(sh, false);
 
 	return 0;
 }
@@ -580,31 +675,51 @@ int luo_session_deserialize(void)
 int luo_session_serialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.outgoing;
+	struct luo_session_block *block;
 	struct luo_session *session;
+	struct luo_session_ser *ser;
 	int i = 0;
 	int err;
 
 	guard(rwsem_write)(&sh->rwsem);
+
+	if (list_empty(&sh->blocks))
+		return 0;
+
+	block = list_first_entry(&sh->blocks, struct luo_session_block, list);
+	ser = (void *)(block->ser + 1);
+
 	list_for_each_entry(session, &sh->list, list) {
-		err = luo_session_freeze_one(session, &sh->ser[i]);
+		if (i == LUO_SESSION_BLOCK_MAX) {
+			block->ser->count = i;
+			block = list_next_entry(block, list);
+			ser = (void *)(block->ser + 1);
+			i = 0;
+		}
+
+		err = luo_session_freeze_one(session, &ser[i]);
 		if (err)
 			goto err_undo;
 
-		strscpy(sh->ser[i].name, session->name,
-			sizeof(sh->ser[i].name));
+		strscpy(ser[i].name, session->name,
+			sizeof(ser[i].name));
 		i++;
 	}
-	sh->header_ser->count = sh->count;
+	block->ser->count = i;
 
 	return 0;
 
 err_undo:
 	list_for_each_entry_continue_reverse(session, &sh->list, list) {
 		i--;
-		luo_session_unfreeze_one(session, &sh->ser[i]);
-		memset(sh->ser[i].name, 0, sizeof(sh->ser[i].name));
+		if (i < 0) {
+			block = list_prev_entry(block, list);
+			ser = (void *)(block->ser + 1);
+			i = LUO_SESSION_BLOCK_MAX - 1;
+		}
+		luo_session_unfreeze_one(session, &ser[i]);
+		memset(ser[i].name, 0, sizeof(ser[i].name));
 	}
 
 	return err;
 }
-
-- 
2.43.0


