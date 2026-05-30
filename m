Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 252EECD6E57
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 22:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B54B76B00BC; Sat, 30 May 2026 18:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F576B00BE; Sat, 30 May 2026 18:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957A66B00BF; Sat, 30 May 2026 18:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6656B00BC
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:20:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 201671202C8
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:20:02 +0000 (UTC)
X-FDA: 84825505044.08.E4F60D8
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 561338000F
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:20:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Yl+RgOpy;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780179600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Imn772bBjRXOhvJWwenfZMGCHENcf6UnvP7wc5uTi4I=;
	b=x7GUhfWUxWis5UbCmljBvnJtpvBw+Bx3ioZOq5+zJpYSGdXRWX4RfMcM5Jni72mee5aqWJ
	pceYjkyUkSBut7jUOOyoswRG2T2WX5rocrPAOsOPrbKUqL3aVQQea9RUWiRVqdA4bsO6jC
	I4vtXDg2D7ttLF8lXkxfX8ypJprNJDU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Yl+RgOpy;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780179600; a=rsa-sha256;
	cv=none;
	b=XDYfJzWjSS1znAOlsAOPUkwsCaOUZxQxt4T10jBYwHHguvncwswD4c/iHDcSRkZNcwUym2
	l/Ffs1rdC868eRAvZrWuPDNdz7DqN0S0pxWIEt9/heQGejBBVhFp4V5OdhtYyBPD2r11AG
	68UHCDGm2aFNniCzb3ar8OCXrneChXY=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-91550dda53cso32285685a.1
        for <linux-mm@kvack.org>; Sat, 30 May 2026 15:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780179599; x=1780784399; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Imn772bBjRXOhvJWwenfZMGCHENcf6UnvP7wc5uTi4I=;
        b=Yl+RgOpy/ShkQbuyPXg0SoKd6ER0zZqqs3lOuu8Z5bqoTvDRiEUfoIYPFphTdZWOZE
         jbfBqxDu7eYB/hjUauNApHRL/2LOHP73Nk1ivJi82p9ZuHOR9H6YXyLe40iQmZl/RXdA
         FqS95WWPynuMo7MDzKfNgY3Yjo5vz1pjA8l/aG4J07/ylrF9dypiY9N1bRMchMKWYIkC
         0MDzIC2T5aPIntf6kMu1xRO3W2RJxYxzU19gLNNsoE+jYCnTknuxWFN5O4Z7wM3U2bWS
         VkhVcKzBZ6+ErmFRYAxUO/i8ilJceVIpPtk7T0/8G81MQ02S76ZRH8zBsSNI1QLAqWjF
         /jLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780179599; x=1780784399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Imn772bBjRXOhvJWwenfZMGCHENcf6UnvP7wc5uTi4I=;
        b=Cn/SEcSSXROU+33IIDwiHVJ9Jg9g4xpcmEAIqHOS2jtysj7A1szmtBixN8/TpHpB0b
         iT45E1Jg5O8jNZp8di3A/V0g9JuKIPd1fhZYNn/B1q/NV2vpSwSPdSQ+XIik/2LIvYx7
         aEUlzrJVpQUNs4ElNgwhTMFwzCfvOLA6F2bAyRnKIJgX/g+VnY5sCUwz1bJgLIFg5me8
         Cw69Vwkoqpidl9lRn7QjXvKOJSqB6visrqeUJmcCMMcCj/L1Je0+iIQgDt3V+wHddJcI
         ym0+QXbeYfIe7m28GBLm8ObR5UpSzSIwGastwz/+0B1qhV0zO0l2nH2QmQ3CU026d++v
         LT1A==
X-Forwarded-Encrypted: i=1; AFNElJ/FLwTJIPrZ8l3raKukyyM+qZMt+iUITZgbztzs3ClXAFqthxRhibR3cS/HIcZYzVpKs5nSxV8/lg==@kvack.org
X-Gm-Message-State: AOJu0YzKT9a/7GunVcgtprrCJ5N/iME3BuMBtiAriFq/bD037aWm+oQh
	c5RPhiPpE3sS3sh3Dh11UgNvFPp+l1NYJRXbq0+lbB69kZA4jKdfXReo7i7dvfPCpLQ=
X-Gm-Gg: Acq92OFshqPYzVDY4kmfBYLCg2KV6HSbkWWmJP9tsEixmL6x69wCN4NF1OsmgxL9gNT
	BsYZoTipGyfNZfHL6fW04Ud4G62Kw7/7Ji9OP4WNmIA/iWIVgXV2WeAluH8FmxVF2oZ1GInTkJL
	HrW2QXvlbCkkC3113Dni/8rYM5XTFAf0xx6734EH1VGVpZYBV7mXv7LImvLDM1Kw3j0GNFvAd2f
	bFNjsusS2UARIAULi3N1zKwC4xnmSztXCjV8TC8NLm582IcYcswu9zxpAlcE+kfqj4WlYsxeb6D
	S2N9detizq1FIXV0iRF+pG8ysNZ5bBTyHnDFXnWHMq7kM4+Z2P2X8dTrppxE1GHN1uMp3y+XumU
	hrtqdWJ/VEaVoiteVrtkecLzIcxadVBDNtDJAjrlOXL+iGP7Pf4cg6+bQ3P3WimXAk0nUtoQTUA
	LFgc7wTAMYl4Qnp43Ytg/cIT74WxAnhs6LQTXl/fkm40WSy2iK6TLUf8dN+ttZpw==
X-Received: by 2002:a05:620a:40c1:b0:914:ca5a:60aa with SMTP id af79cd13be357-9153d9cb8f7mr857976385a.6.1780179599475;
        Sat, 30 May 2026 15:19:59 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915324868a0sm651790085a.18.2026.05.30.15.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 15:19:59 -0700 (PDT)
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
Subject: [PATCH v4 09/13] liveupdate: Remove limit on the number of sessions
Date: Sat, 30 May 2026 22:19:34 +0000
Message-ID: <20260530221938.115978-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530221938.115978-1-pasha.tatashin@soleen.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 561338000F
X-Stat-Signature: tr9xz1mtbhnrqo6bt9s9quzj4t8n99kh
X-HE-Tag: 1780179600-238530
X-HE-Meta: U2FsdGVkX18uKvYR1ewa0KEbE1E2oCKTqm4jOf3cUW6V4bGO8vUnzv/p/oQgfNx0sAlxGD+qG5EL1sE60ROr5sT5T9+wIw9ybr5FW855xVuXzPD9qjAWpsAq9pkgFGV14bM4paLy7X98K7anskTAEOO/C5GqY6TulxadKDUw0Clq8jzVajQRvl6aQgIDs2R8/PJXT6/XWJVhhdT7zOBALCV+rqxffi6tLomv0AVfWs5ELqCfi/VL6HlOF/eU5k+xQ4bTsKH4X0l4X48Po2Ms+Sdiwmsbshs/V+TBhaxOvxVsLD3r0Flo0AX/Hu5BqOF9setof+ObFqVcSfkTeNtPt+nQPGai8dpJ4ysBn+dKxB4ENELXsD7K5rE7y3vYx06bYYLxQJmXtOuQciw5hWaJ8r42WNmAIJEv4FJp1wCPFzMGLxSnuParulu2nZjuvyxkRNvEiK3njmX3K85vL6ftteJsc5X49KWPmiv4ulZvxm4zTDVz61DQcbYxcmZnmICosbDaAYIXXJvsX7hVnl5Qi4XLtyTD9w3ZCRjL9gK0S+F7s7WtsxUSzHrJA8aI6feA7HzYQ8BwIcIoA/urTi2Vih+DvltntfHIk2iBC91KiBz09aQAX5QPQBV3/Qs89lq4GgmtmXLDL8/d5wEPpkyYmdn9Vr0YqQVTU/A/9m6QZeuMDhI2gG5K75t0imVJKHQWXLi489O55xquDTKCtR11xyeEdkxd540eUAUvlOrGw2cJu016IpcYmIjBen8X04q4xAK3dsV8XMOBy3tElvw7cZi/0qvvFTe30jY+T6vxvzeEFtgxxz9paSYDDq88lw347XSiyhjbhfoXpz3i+Q6YlcAlh5a++UJ4rgfzLkiSrp5DaADBQpTzXh7PQ8tc6smlgZxJ5eiufCSEgRAJC85d72BYdPDHoedH+d5McwyJuzT45mZP/6r7P9nI6Y9v/T/l+/wtLFLfRNYPxKwf1Pd
 ki6oYjcQ
 i6juhY2887o7dTrtGeFUKOg4BFPy0F0t+IQMj0BzXNrAn5yrgW+t8If7yhdgMkPhEqK7IDgiEWLvVC3D85inodc9pVnLLvVu0t8aAqEzuFrFeSEcfGSgG1RJHYWMVpI6LRHzbxGYaNSfMMZMCWX5DDerEbGWquDHgPEPRYnHMnSZ4FWYyQX66w59EDKIaUGegig1flZj/vdQRPhzwx3Md17d7JKrSeP60TGD5+jUmRYC6LVS5IsVM4G+LQFAYk0ZV79bFDdkFlkuWm7wsWgfaG2C56aqcvNOnCHEQ87+4fb3DFH662IqJQksn1g==
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
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/luo.h     |  24 +------
 kernel/liveupdate/luo_session.c | 117 +++++++++++++++-----------------
 2 files changed, 58 insertions(+), 83 deletions(-)

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
index 0548d48bb014..f1a6c32eeb2b 100644
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
@@ -525,15 +504,17 @@ void __init luo_session_setup_outgoing(u64 *sessions_pa)
 
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
+
+	err = kho_block_restore(&sh->block_set, sessions_pa);
+	if (err)
+		return err;
 
+	sh->active = true;
 	return 0;
 }
 
@@ -575,6 +556,8 @@ int luo_session_deserialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.incoming;
 	static bool is_deserialized;
+	struct luo_session_ser *ser;
+	struct kho_block_it it;
 	static int err;
 
 	/* If has been deserialized, always return the same error code */
@@ -600,53 +583,63 @@ int luo_session_deserialize(void)
 	 * userspace to detect the failure and trigger a reboot, which will
 	 * reliably reset devices and reclaim memory.
 	 */
-	for (int i = 0; i < sh->header_ser->count; i++) {
-		err = luo_session_deserialize_one(sh, &sh->ser[i]);
+	kho_block_it_init(&it, &sh->block_set);
+	while ((ser = kho_block_it_read(&it))) {
+		err = luo_session_deserialize_one(sh, ser);
 		if (err)
-			return err;
+			goto err_destroy_blocks;
 	}
 
-	kho_restore_free(sh->header_ser);
-	sh->header_ser = NULL;
-	sh->ser = NULL;
+err_destroy_blocks:
+	kho_block_destroy(&sh->block_set);
 
-	return 0;
+	return err;
 }
 
 int luo_session_serialize(void)
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
+		struct luo_session_ser *ser = kho_block_it_next(&it);
+
+		if (!ser) {
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
+	if (sh->sessions_pa && sh->count > 0)
+		*sh->sessions_pa = sh->block_set.head_pa;
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


