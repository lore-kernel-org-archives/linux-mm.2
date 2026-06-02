Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71E67CD6E61
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7E96B04C5; Mon,  1 Jun 2026 23:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A95276B04C7; Mon,  1 Jun 2026 23:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 847A96B04C8; Mon,  1 Jun 2026 23:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CFE16B04C5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:17:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C5E9C2734
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:35 +0000 (UTC)
X-FDA: 84833512470.21.4ABB6A5
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4969B180003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=C9+VX9YE;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780370253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWqTePdW4kjpFcuQSRvtq+YZpFX+FpQQHf9HMyZY+aI=;
	b=y+WOwaOr/aXXg3eiYfmAiABC0OsIH6HKEA4BMyjYH0h/c4THcc+UgRS1yd0I9ND2DqigE2
	YsXR8jTYI1D+xdRDR0usPsODhj400tyzyYTNLyneT0sZVJYZQ4dgrMwmN3jTIDSQCSM+OO
	gzzWb4cMjWe+IAS3q8yf42aAi+qI+s0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=C9+VX9YE;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780370253;
	b=4fUgtutfrKgEmzw3eP3YtSpVWEdO4e0MGGGB8/SUmxU/kyFdSuzxJH4JKolxNBk1z9I9y6
	kBruMaB60FgqwG1wX1AB6rLglMrFnZanA2oBz4UUhZangr0+4sV8RSvZ0REwVVU+sIYbXX
	xGEd5OsJejbz87DjtdOHSDbsuTYqUXQ=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5176bbb9384so1978311cf.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 20:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780370252; x=1780975052; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fWqTePdW4kjpFcuQSRvtq+YZpFX+FpQQHf9HMyZY+aI=;
        b=C9+VX9YEm2oHvQATKBoB5Fp/YT4pOBhjTFLvVC1qPESiJBAlxk/OT7DQ8qnBjRlaji
         ZR3DoZr81jDWR7ocCtEP0bytmgMZEt8YZwfHc4cDFtUPxJAejPpDxMrgLXu3fHxL6lGM
         pR3ixo/OgNO1nh64m9VVP3QfyIytwTTiTwWtpLBJZCI7MUk94zAygzrr20ADMkF3Mcs5
         rAn+AO9d8qWQdbPyRpr2zAZDBlwNxg55lTiD88SjUZnyumEUT0F/Aq3MBKDt2kHJ31TF
         sGgE/ATc6quV51rNpD5NrM9aL/HTgf0q8npCqwB6uDaJ5ltGlkPlLaZQQrIS6AKJsnlB
         7Wag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780370252; x=1780975052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fWqTePdW4kjpFcuQSRvtq+YZpFX+FpQQHf9HMyZY+aI=;
        b=ajKJAX9ZHkSC2tCHKubjH9JEUnfK1Rp4MbLTSfAXxGG7KJU+5i9EXcZVar7H71QH2F
         gnvCKNIBU+CI05Xi9uepmeD9Im/fAe5aZ6w9fBZMYRJLC0sCtn1ZHyC43vPnDrjsLx5q
         JOQO6FB28hwXpkmgGtN2pujz3YgwV6yAWsw1w+rz62DRWFZBuNePKfk5uuxaoClSR/IM
         /6a4oRgvR/EP1ys6suZ2xBko3mEZ1poHnKBRO4hm5Muc6Du0RfC9XKVM3zdgDurF2bn9
         oK29ASqv/cg7Yv8yAb3iKAQm7Vak+uSoH88to/KlH1dHxFmg5k7JWqj2ada1aGSzqkdd
         9jHw==
X-Forwarded-Encrypted: i=1; AFNElJ/JLMC/xQWK6//lW2XZcmSIS/xWNymVpBYmWLgWwV+YHHZdmYM8wXk6IalIAIAPKsERM4FycYVO7Q==@kvack.org
X-Gm-Message-State: AOJu0YyHY5HOpdHIS6LxI7e/WUd2FHLdbzVb+XmIBjPwcC1mF0z5ywah
	x6OPb8YifgTrsAkW18eK6Agkiqu7vXwklkrCFsyuok+TjdVBueTzKvfk/WWFLJlQI/w=
X-Gm-Gg: Acq92OHyU1RGLjxLvTgeFnD/k4+1NkvTwnITjwnAQCFJBJYXlc0ijIPRD0FwNy42O1/
	pbQHc782drEtrkhF2WKRxw8bZ/LMBNTdnVu6mgKqfhbanjmiNErZ4ZKuNHosRzSsWGzPIDy8NJM
	HLfe6yR6hDHuFVS/bfPGqpZPPmK57XMAH2rmLAYkt7XC2T41xQYjFMi6XTZEdilx/WzfftV8j0q
	GsYYl9mZN7hWdt2KEERSmoDw9nJMMcLJ5JMo/m+zNukizzQoor7fL1xaM6j7+1zJxPF3AAAF09L
	8av/m4G5TC89Sjb9f3Uohm/PXVyTveb6CT9AWYz62/7oXOxOZTCVLGVUjH56IohoFWUP46owdbJ
	owTB4pI01BXR3FKQU3DvtzCAPybJNCO+KntNgJNtnBai3t4k5yd16ZmdAvkKmFB4F9HyIcHaVKC
	L8FMTVJk27qZvkaCPUQHKpgUMKc+Herq03sccNswAahDJAUL7zDRMf8ScpsAlJNQ==
X-Received: by 2002:a05:622a:90:b0:50d:8db0:7abb with SMTP id d75a77b69052e-5173a841d22mr202025281cf.42.1780370252389;
        Mon, 01 Jun 2026 20:17:32 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51741b29745sm71219081cf.8.2026.06.01.20.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 20:17:31 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v5 09/13] liveupdate: Remove limit on the number of sessions
Date: Tue,  2 Jun 2026 03:17:13 +0000
Message-ID: <20260602031717.197696-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260602031717.197696-1-pasha.tatashin@soleen.com>
References: <20260602031717.197696-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4969B180003
X-Rspam-User: 
X-Stat-Signature: zbaomn4zree1njk5r3ercfm7fq88mpkr
X-Rspamd-Server: rspam09
X-HE-Tag: 1780370253-688724
X-HE-Meta: U2FsdGVkX199S8JRqP0WOEm0APVLlKVcFEV3VPvt+KuyLOGZkFI0cu1zsochuJ+dbePfghegvaLwUpnTmwfAKo5AZ6/6tHZ+dkNH69kv5oJgPSRMzqMqQ9vXti8fsW4ZaHAyyPycyDL9Flu9IySFJVLUbXN7Ti/o1rmPSIkx93c6nIzvYxBLG2ljxRLX6oJht/83L/fwQNC1BKwMhNIek7sc7lIN9ALNwk6uE7JFlHEbMG/wq5y3DkD7n+WNS7eF0cSLdq09wkTy13xJkSPb5mBUDOOhQHzKGolY3vae4syOVkb+AJhUp+0tJRGbjziP/Z3I/FBG0kdDx/d/HeIivAVRLVBs8qAtcVxwbCj/0SiPMECK2Hem5EX7JR/RCaeztgoLXYG/7XSLUZL9UbHJM6GJ/kDiV/zpSi84twx3mJZNm9VckyoXAS3Pwh9Fdi5fb1jBzn8pMaIgm4n7eJrENpauHRpfwToGPiOq93hIrqPDu3uDjIsWC9qEVjukq3nbT6rppj+rQJJCjEukYmKfGA9Yu7si5OEjTJuN6prQ/WLdwOFQxYLovwNbta8dv+gb/l0qPoQewt6G3gfDpfEbdCQKZ/3XoDCP3Q7Lu7bvTbPrp+6yYjcDGryvV/7qv4BA757YtQQhVr+iHtNPc8tRZE8xcWUxYJ9i2+QZtIT2g6Vb7QMLLiarpOxIu/1R5YcQL7NIycQpt5ZJlNezO2B1ehwem5BNU416GCxxj4U5GXW7oVfWs8JLcW+0t1E5+yyPQBKRItBf7fGqAeKZye/bLBmjEDN/Ql5eeH92JmxZ97pvEybF1Bo4veP3d9PjZFVY96UUIEasepMKy7UFFIgwhnRH1oY7is8scnyV8OqRZAf8eTTf8HACkx1hAhckWUbvZkTeIBe+LeeVaDfKZT8+pPxxVyX8jNYC/kFwo56TbVXULnMJsnRenoD6j0kOQjtAdm+4qgj4QxAtioh6iLm
 W/nfPNgJ
 6aqqlzp2orEAyBSYQIErMHH3fDZoG7I09Al85uI1lB/VuosAxlv21hfe+2TmbNf/NbvJe07jYKuw3Dbl8y36dxvw1290z5tLHN0Anu4YAz0M89m6OpspzlxO6/x/Uh3ruXjpHpBG4tiOTqvP4MOW1ZUMXRfy7hFCG56OfDHE0fpB0tJ8zj+EQL05EhzYyqP89povrHPFd+KBPZr4F+QQM0QARSkSPvSDTP/Gp4TtuifYDKtYPucBU1d4Iq7tmTYfXdXZp0iJaQnSxCnw8J0zeUYG0FHtHLbct51H84JThXPaONgIgFRtCSFERMU7UpIp1TehLE5l7BiV69MVL6LP5Mkzk9Ntehz4Hazu7
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

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/luo.h     |  24 +------
 kernel/liveupdate/luo_session.c | 115 +++++++++++++++-----------------
 2 files changed, 58 insertions(+), 81 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 9a4fe491812b..79758d92ed5f 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -33,11 +33,6 @@
  *     It includes the compatibility string, the liveupdate-number, and pointers
  *     to sessions and FLBs.
  *
- *   - struct luo_session_header_ser:
- *     Header for the session array. Contains the total page count of the
- *     preserved memory block and the number of `struct luo_session_ser`
- *     entries that follow.
- *
  *   - struct luo_session_ser:
  *     Metadata for a single session, including its name and a physical pointer
  *     to another preserved memory block containing an array of
@@ -63,13 +58,15 @@
 #define _LINUX_KHO_ABI_LUO_H
 
 #include <linux/align.h>
+#include <linux/kho/abi/block.h>
 #include <uapi/linux/liveupdate.h>
 
 /*
  * The LUO state is registered under this KHO entry name.
  */
 #define LUO_KHO_ENTRY_NAME	"LUO"
-#define LUO_ABI_COMPATIBLE	"luo-v3"
+#define LUO_COMPAT_BASE		"luo-v3"
+#define LUO_ABI_COMPATIBLE	LUO_COMPAT_BASE "-" KHO_BLOCK_ABI_COMPATIBLE
 #define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
 
 /**
@@ -118,21 +115,6 @@ struct luo_file_set_ser {
 	u64 count;
 } __packed;
 
-/**
- * struct luo_session_header_ser - Header for the serialized session data block.
- * @count: The number of `struct luo_session_ser` entries that immediately
- *         follow this header in the memory block.
- *
- * This structure is located at the beginning of a contiguous block of
- * physical memory preserved across the kexec. It provides the necessary
- * metadata to interpret the array of session entries that follow.
- *
- * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
- */
-struct luo_session_header_ser {
-	u64 count;
-} __packed;
-
 /**
  * struct luo_session_ser - Represents the serialized metadata for a LUO session.
  * @name:         The unique name of the session, provided by the userspace at
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 43342916d314..f6eeb965b3c1 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -24,9 +24,10 @@
  *   ioctls on /dev/liveupdate.
  *
  * - Serialization: Session metadata is preserved using the KHO framework. When
- *   a live update is triggered via kexec, an array of `struct luo_session_ser`
- *   is populated and placed in a preserved memory region. The physical address
- *   of this array is stored in the centralized `struct luo_ser` structure.
+ *   a live update is triggered via kexec, session metadata is serialized into
+ *   a chain of linked-blocks and placed in a preserved memory region. The
+ *   physical address of the first block header is stored in the centralized
+ *   `struct luo_ser` structure.
  *
  * Session Lifecycle:
  *
@@ -89,6 +90,7 @@
 #include <linux/fs.h>
 #include <linux/io.h>
 #include <linux/kexec_handover.h>
+#include <linux/kho_block.h>
 #include <linux/kho/abi/luo.h>
 #include <linux/list.h>
 #include <linux/liveupdate.h>
@@ -98,23 +100,14 @@
 #include <uapi/linux/liveupdate.h>
 #include "luo_internal.h"
 
-/* 16 4K pages, give space for 744 sessions */
-#define LUO_SESSION_PGCNT	16ul
-#define LUO_SESSION_MAX		(((LUO_SESSION_PGCNT << PAGE_SHIFT) -	\
-		sizeof(struct luo_session_header_ser)) /		\
-		sizeof(struct luo_session_ser))
-
 static DECLARE_RWSEM(luo_session_serialize_rwsem);
-
 /**
  * struct luo_session_header - Header struct for managing LUO sessions.
  * @count:       The number of sessions currently tracked in the @list.
  * @list:        The head of the linked list of `struct luo_session` instances.
  * @rwsem:       A read-write semaphore providing synchronized access to the
  *               session list and other fields in this structure.
- * @header_ser:  The header data of serialization array.
- * @ser:         The serialized session data (an array of
- *               `struct luo_session_ser`).
+ * @block_set:   The set of serialization blocks.
  * @sessions_pa: Points to the location of sessions_pa within struct luo_ser.
  * @active:      Set to true when first initialized. If previous kernel did not
  *               send session data, active stays false for incoming.
@@ -123,8 +116,7 @@ struct luo_session_header {
 	long count;
 	struct list_head list;
 	struct rw_semaphore rwsem;
-	struct luo_session_header_ser *header_ser;
-	struct luo_session_ser *ser;
+	struct kho_block_set block_set;
 	u64 *sessions_pa;
 	bool active;
 };
@@ -143,10 +135,14 @@ static struct luo_session_global luo_session_global = {
 	.incoming = {
 		.list = LIST_HEAD_INIT(luo_session_global.incoming.list),
 		.rwsem = __RWSEM_INITIALIZER(luo_session_global.incoming.rwsem),
+		.block_set = KHO_BLOCK_SET_INIT(luo_session_global.incoming.block_set,
+						sizeof(struct luo_session_ser)),
 	},
 	.outgoing = {
 		.list = LIST_HEAD_INIT(luo_session_global.outgoing.list),
 		.rwsem = __RWSEM_INITIALIZER(luo_session_global.outgoing.rwsem),
+		.block_set = KHO_BLOCK_SET_INIT(luo_session_global.outgoing.block_set,
+						sizeof(struct luo_session_ser)),
 	},
 };
 
@@ -173,25 +169,6 @@ static void luo_session_free(struct luo_session *session)
 	kfree(session);
 }
 
-static int luo_session_grow_ser(struct luo_session_header *sh)
-{
-	struct luo_session_header_ser *header_ser;
-
-	if (sh->count == LUO_SESSION_MAX)
-		return -ENOMEM;
-
-	if (sh->header_ser)
-		return 0;
-
-	header_ser = kho_alloc_preserve(LUO_SESSION_PGCNT << PAGE_SHIFT);
-	if (IS_ERR(header_ser))
-		return PTR_ERR(header_ser);
-
-	sh->header_ser = header_ser;
-	sh->ser = (void *)(header_ser + 1);
-	return 0;
-}
-
 static int luo_session_insert(struct luo_session_header *sh,
 			      struct luo_session *session)
 {
@@ -205,7 +182,7 @@ static int luo_session_insert(struct luo_session_header *sh,
 	 * for new session.
 	 */
 	if (sh == &luo_session_global.outgoing) {
-		err = luo_session_grow_ser(sh);
+		err = kho_block_grow(&sh->block_set, sh->count);
 		if (err)
 			return err;
 	}
@@ -232,6 +209,8 @@ static void luo_session_remove(struct luo_session_header *sh,
 	guard(rwsem_write)(&sh->rwsem);
 	list_del(&session->list);
 	sh->count--;
+	if (sh == &luo_session_global.outgoing)
+		kho_block_shrink(&sh->block_set, sh->count);
 }
 
 static int luo_session_finish_one(struct luo_session *session)
@@ -553,15 +532,17 @@ void __init luo_session_setup_outgoing(u64 *sessions_pa)
 
 int __init luo_session_setup_incoming(u64 sessions_pa)
 {
-	struct luo_session_header_ser *header_ser;
+	struct luo_session_header *sh = &luo_session_global.incoming;
+	int err;
 
-	if (sessions_pa) {
-		header_ser = phys_to_virt(sessions_pa);
-		luo_session_global.incoming.header_ser = header_ser;
-		luo_session_global.incoming.ser = (void *)(header_ser + 1);
-		luo_session_global.incoming.active = true;
-	}
+	if (!sessions_pa)
+		return 0;
 
+	err = kho_block_set_restore(&sh->block_set, sessions_pa);
+	if (err)
+		return err;
+
+	sh->active = true;
 	return 0;
 }
 
@@ -603,6 +584,8 @@ int luo_session_deserialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.incoming;
 	static bool is_deserialized;
+	struct luo_session_ser *ser;
+	struct kho_block_it it;
 	static int saved_err;
 	int err;
 
@@ -629,18 +612,19 @@ int luo_session_deserialize(void)
 	 * userspace to detect the failure and trigger a reboot, which will
 	 * reliably reset devices and reclaim memory.
 	 */
-	for (int i = 0; i < sh->header_ser->count; i++) {
-		err = luo_session_deserialize_one(sh, &sh->ser[i]);
+	kho_block_it_init(&it, &sh->block_set);
+	while ((ser = kho_block_it_read_entry(&it))) {
+		err = luo_session_deserialize_one(sh, ser);
 		if (err)
 			goto save_err;
 	}
 
-	kho_restore_free(sh->header_ser);
-	sh->header_ser = NULL;
-	sh->ser = NULL;
+	kho_block_set_destroy(&sh->block_set);
 
 	return 0;
+
 save_err:
+	kho_block_set_destroy(&sh->block_set);
 	saved_err = err;
 	return err;
 }
@@ -649,36 +633,47 @@ int luo_session_serialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.outgoing;
 	struct luo_session *session;
-	int i = 0;
+	struct kho_block_it it;
 	int err;
 
 	down_write(&luo_session_serialize_rwsem);
 	down_write(&sh->rwsem);
 	*sh->sessions_pa = 0;
 
+	kho_block_it_init(&it, &sh->block_set);
+
 	list_for_each_entry(session, &sh->list, list) {
-		err = luo_session_freeze_one(session, &sh->ser[i]);
-		if (err)
+		struct luo_session_ser *ser = kho_block_it_reserve_entry(&it);
+
+		/* This should not fail normally as blocks were pre-allocated */
+		if (WARN_ON_ONCE(!ser)) {
+			err = -ENOSPC;
 			goto err_undo;
+		}
 
-		strscpy(sh->ser[i].name, session->name,
-			sizeof(sh->ser[i].name));
-		i++;
-	}
+		err = luo_session_freeze_one(session, ser);
+		if (err) {
+			kho_block_it_prev(&it);
+			goto err_undo;
+		}
 
-	if (sh->header_ser && sh->count > 0) {
-		sh->header_ser->count = sh->count;
-		*sh->sessions_pa = virt_to_phys(sh->header_ser);
+		strscpy(ser->name, session->name, sizeof(ser->name));
 	}
+
+	kho_block_it_finalize(&it);
+
+	if (sh->count > 0)
+		*sh->sessions_pa = kho_block_set_head_pa(&sh->block_set);
 	up_write(&sh->rwsem);
 
 	return 0;
 
 err_undo:
 	list_for_each_entry_continue_reverse(session, &sh->list, list) {
-		i--;
-		luo_session_unfreeze_one(session, &sh->ser[i]);
-		memset(sh->ser[i].name, 0, sizeof(sh->ser[i].name));
+		struct luo_session_ser *ser = kho_block_it_prev(&it);
+
+		luo_session_unfreeze_one(session, ser);
+		memset(ser->name, 0, sizeof(ser->name));
 	}
 	up_write(&sh->rwsem);
 	up_write(&luo_session_serialize_rwsem);
-- 
2.53.0


