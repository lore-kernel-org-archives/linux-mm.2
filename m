Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA838CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1496F6B00B0; Wed,  3 Jun 2026 11:45:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9566B00B2; Wed,  3 Jun 2026 11:45:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEEDC6B00B3; Wed,  3 Jun 2026 11:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C78786B00B0
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:45:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8DDA01603F3
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:45:53 +0000 (UTC)
X-FDA: 84839026986.23.6B8B86A
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id B30F74000F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:45:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cJwgravi;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780501551;
	b=bFQGOqZbrdHFD1kZKYWtQujGjK/DoZW7bclBaS6x8vVcyHfwBZ7iiNUWBNoKJjlfmcHRT+
	Y2juDE2WBTHLFF4SoFChJMMcNS++Y2dHGFjvVIpDoLvQf4TqabAYgOtLc7oj6/VkR7x1iO
	Dz+Vqn68fUKVbG7Adxjeo1nU569k7o4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cJwgravi;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780501551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G54EjScdsoAHhtz7nw9E64EqCSfODXiX67qASj3ZuAY=;
	b=BJ15Ewxsf42xz7sxfXwzFr1Feuf6HCZjxweDMDjwIClyoaJO8I5Ezxtp590qibbj++SuMa
	flXCXTlZguwwiHu+qwmZgiXII9LHuApP7UDrHcpr4gqM7a0xX2eCl1WWR+ooCgaFh1tpS9
	VBSKH7fYas6aDamsQDRZzTEA2suSzMs=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5176a2fd597so16725971cf.1
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780501551; x=1781106351; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G54EjScdsoAHhtz7nw9E64EqCSfODXiX67qASj3ZuAY=;
        b=cJwgravi/wou30wyToRKHsSE7osnMBF/SCS59HIUHkPbUOxySeYCwrxWH/5Hrq32u2
         L3VF6R8VxdDNqNjGrAGODlmLCJ93SKYa1Vs18UmDUlLoQ6Irwd9wSt5bSoa5Ynf6Tdy6
         ta/koazp6T1MOrFgHfU/1ey08gqdA4tWFnh4JXjeBDxuC3DiVwpp57Zletk+xKpT8kDz
         +NfvJmPTkixapAkIMjM6RgLm/A3w/8XpLsTC77uO0nShxz9KsfJjlOtjB/e51c5HClmP
         sMsiT9f/3oUyIyqLzk8lbb+1ONkIAphAxuTNlEdrOMur7UvjtEmkrohB63MjMl1nJhZG
         gsLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780501551; x=1781106351;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=G54EjScdsoAHhtz7nw9E64EqCSfODXiX67qASj3ZuAY=;
        b=qbr+oSkhQmFJ5kOgwAEt9H0Rpv0MB2GeYpVCfeHloiOh7cZGTHQczmbTYI3iXaENMH
         Ng2zgZ0U20hTnR5kcTMe7QhfVwkZZXOZtwcDrYzQymK8+NmSQta/tVsbvp/sPxXgdi9N
         XkraBfcL6HxQIlorxU32s+el2WT9prA0vDlfFtQFZYHgF9x4CHY06Ht26afavRIj4/3L
         GmKCb3wKvLaqzJH11H9H7P3F5547qCFnkX9de4ab/pm7PqSq/0JXc1WIIjKWAXslifO4
         BSFBwn5OdHF+dEAKUdROKrgLGVdow+he8lcGW+ags5QGePKA0g2EPgcdo9FxMFhaH0ol
         8MDg==
X-Forwarded-Encrypted: i=1; AFNElJ9NisGX99Hibi7+Upk25zh5DFxAypATCE28k5CbVdE3qw0brJRkKYjoDHxscfg6qdLJRE4VHyyEWw==@kvack.org
X-Gm-Message-State: AOJu0YxKj74OljJ/JBbiSwms+624QiDaqFF5QO0Iw5Ki/+p0t/HazwSj
	CoG0Q6/0NxcOAsJZsZc4QCls4IU6BrEJ3MCj7SGKG/viHg80TJgEbPiXV6k6TVYx9qNYr6gOI8k
	G+vH2
X-Gm-Gg: Acq92OGfgqqt+0fD6CUAYIfe9OA7jz4GYrklb0RGyYZLjQwFXdq790dqyPOSTDWUA3w
	/mivMzyycwar6t7DDAUSa9PLs/IxfAOvNmJH0mSBYHeombCrzXmpnp5ptHdz6M/E5ZfWiLq3Z4b
	c6GSdQ6bjJo9jIPb9UY5uIBxEtTXfmw3Zj1J7Tyvi2mFzggtxujglj7d9O6gmD5GqY1rYVWzA+t
	FsmdFBw/jh0G/hOzXi7yZQ6a4E63WBCWCAGQuHgcVTOlZRdUc2xxgsxnZOyZI25Wf6BeT7/aoGL
	a8dLEmsEWbixas/r+2E+MVyLakLu7pluTI/Cubeg4UvoGNjHLOj2A5gicF861y7j/gPIo3Tdc2O
	JIF5mRz7RJe2dhzfHSouLHxwksbFj1riJuNdMZIYF5RYhKYzl3cPYjZPRXbSXD3L+BPFkPgvYAu
	X1Lj/2cYAUMrewHm4rb+yDLKz4IJ8hSWYCsd5mzWlojgldaVIpbbD8F0UIBEf9CA==
X-Received: by 2002:a05:622a:8416:20b0:50b:38c1:c6a with SMTP id d75a77b69052e-5177860194fmr45451841cf.19.1780501550650;
        Wed, 03 Jun 2026 08:45:50 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51775c4d7absm26135361cf.11.2026.06.03.08.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:45:50 -0700 (PDT)
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
Subject: [PATCH v7 09/13] liveupdate: Remove limit on the number of sessions
Date: Wed,  3 Jun 2026 15:43:58 +0000
Message-ID: <20260603154402.468928-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603154402.468928-1-pasha.tatashin@soleen.com>
References: <20260603154402.468928-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B30F74000F
X-Stat-Signature: 7m9866xu9hq3stw6hzd9din66wit184a
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780501551-99019
X-HE-Meta: U2FsdGVkX1+3V/+qmcojx/aRrD9g2XJFClshKygwoH3rItBVIr/28dfx1qs0FF9dVjtE2djBwN0A+NxAkHlhuGsLrb+xlIHluLNrMys8DKeov5WJnJU6WqT5xO7aFM78HJS8yHcPnuhJTTJA33e5FDUtrg3B2FQQSgkl/Ue9bfwiwL3wNdzgpE9dplnpK9sU39EKE5uUT3KLZB0H90yGjtC/85mqxx0wqavckUvMAy7SA5t4Bnbmmb34AqpQRZMefzpq3C7Etx1P8xQrh7R3CIbN6bYTeN01CWsOhpWg0aUjRxfK4uvpPf/Bc0zU9A1A54yiokqXRXIOSF2xbYhWCeVPRUy/Iai1W7tyIBOGGNWDGay6AS53HsIdpQd20O9RKiKj5ohS3eA7ZpBx322BX6Bt67jRg0hm0yTSNvDxxxPO8LRNOGEZjbLnhS3VHNgyDPBdqORyJo5ugnlPMd62RFRy/dfoSe40KkaZqWxRlqRqelSpX8re7moqdOg0h92dWE8ZrBaYgtRLIZsZ1JD8sk8n71aXFlRIpKjst/9GhEaYrSo8r03miw7w/mMng/cCsutXg1ueMoJpzbo1VnJplxxGytYtlyfnp9FFOP4xGEFXd7iMWwEY6bFccXCjq154RN26H+ARWGdFBWof9KBmys6Iwtndfm7hqCTB7KJJi5Lequ6RpVrTr8N/h55CtHzbGGlZkVBPSj5U6a5nZ3XshzU5IZkz+ymlcT1eae1Bg+XBksW4cnEjIeEapS45dgy5nOwDQAxvdBtMmYsaejRXdjtbNRZ0C2UEvT64uv4J3teB7Yt+xfbvUtimCaDqMt8pbQtvnsC5aJq5cIVOidz0g4piCHyKdpL6scVxgi0yStA6rP0G/9vyK5m65KA45Xy45K4oN4IHMReWUoGeJTySgCj+bgjkdGojVV6Qaf3ZuSyDMa5qM1WdGrJHH6P8JFvw8PdsnaSqVP0KQursYwY
 42q6gsHv
 kbcUPUwckL9HxAA7gpk+UuYwEPPpQ7/Yrj8W7LTtpyYwNYwddD7YKnBZdsWdgY7MJptfc8xUj3SUVBc0KgUhVYfxaowql9Muh0HIAnQgY3ggQgasSMGdopGdq18VORTwFwXZCE5YryS8JKMgGRXcY09MRnI0tJLbzHLoHFa+bOJWgDoYtgZ8n8q+7IBzSgUafMwR9ED8siZV9ZF/ZjhCEqzcc/wy6vElpqgTRqsw4HwW+R6l8kuqPqzk8okasXx7y6WjpTH3eEUv1x+B+qAL3m9f71t4mJSi29gU2xtMvDyLV0O8tnF0pF6XlxsRduF9JOMlAJMZFvEKAENKpEzfJRm3NTmsS8AOeFxED
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
 include/linux/kho/abi/luo.h     |  23 +------
 kernel/liveupdate/luo_session.c | 113 +++++++++++++++-----------------
 2 files changed, 55 insertions(+), 81 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 9a4fe491812b..03d940d0f9bb 100644
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
@@ -63,13 +58,14 @@
 #define _LINUX_KHO_ABI_LUO_H
 
 #include <linux/align.h>
+#include <linux/kho/abi/block.h>
 #include <uapi/linux/liveupdate.h>
 
 /*
  * The LUO state is registered under this KHO entry name.
  */
 #define LUO_KHO_ENTRY_NAME	"LUO"
-#define LUO_ABI_COMPATIBLE	"luo-v3"
+#define LUO_ABI_COMPATIBLE	"luo-v4"
 #define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
 
 /**
@@ -118,21 +114,6 @@ struct luo_file_set_ser {
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
index 2411849a34e3..b79b2a488974 100644
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
+		err = kho_block_set_grow(&sh->block_set, sh->count + 1);
 		if (err)
 			return err;
 	}
@@ -232,6 +209,8 @@ static void luo_session_remove(struct luo_session_header *sh,
 	guard(rwsem_write)(&sh->rwsem);
 	list_del(&session->list);
 	sh->count--;
+	if (sh == &luo_session_global.outgoing)
+		kho_block_set_shrink(&sh->block_set, sh->count);
 }
 
 static int luo_session_finish_one(struct luo_session *session)
@@ -555,15 +534,17 @@ void __init luo_session_setup_outgoing(u64 *sessions_pa)
 
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
 
@@ -605,6 +586,8 @@ int luo_session_deserialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.incoming;
 	static bool is_deserialized;
+	struct luo_session_ser *ser;
+	struct kho_block_set_it it;
 	static int saved_err;
 	int err;
 
@@ -631,18 +614,19 @@ int luo_session_deserialize(void)
 	 * userspace to detect the failure and trigger a reboot, which will
 	 * reliably reset devices and reclaim memory.
 	 */
-	for (int i = 0; i < sh->header_ser->count; i++) {
-		err = luo_session_deserialize_one(sh, &sh->ser[i]);
+	kho_block_set_it_init(&it, &sh->block_set);
+	while ((ser = kho_block_set_it_read_entry(&it))) {
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
@@ -651,36 +635,45 @@ int luo_session_serialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.outgoing;
 	struct luo_session *session;
-	int i = 0;
+	struct kho_block_set_it it;
 	int err;
 
 	down_write(&luo_session_serialize_rwsem);
 	down_write(&sh->rwsem);
 	*sh->sessions_pa = 0;
 
+	kho_block_set_it_init(&it, &sh->block_set);
+
 	list_for_each_entry(session, &sh->list, list) {
-		err = luo_session_freeze_one(session, &sh->ser[i]);
-		if (err)
+		struct luo_session_ser *ser = kho_block_set_it_reserve_entry(&it);
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
+			kho_block_set_it_prev(&it);
+			goto err_undo;
+		}
 
-	if (sh->header_ser && sh->count > 0) {
-		sh->header_ser->count = sh->count;
-		*sh->sessions_pa = virt_to_phys(sh->header_ser);
+		strscpy(ser->name, session->name, sizeof(ser->name));
 	}
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
+		struct luo_session_ser *ser = kho_block_set_it_prev(&it);
+
+		luo_session_unfreeze_one(session, ser);
+		memset(ser->name, 0, sizeof(ser->name));
 	}
 	up_write(&sh->rwsem);
 	up_write(&luo_session_serialize_rwsem);
-- 
2.53.0


