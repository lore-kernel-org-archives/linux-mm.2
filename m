Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F65BCD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0FB36B009D; Tue,  2 Jun 2026 23:29:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9989F6B009F; Tue,  2 Jun 2026 23:29:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8390F6B00A0; Tue,  2 Jun 2026 23:29:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D13E6B009D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:29:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32A82C0ADF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:23 +0000 (UTC)
X-FDA: 84837171006.21.4D182E4
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6C72020002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Rgr1tXhC;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780457361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tz2WlgQShBzc08rHE8f9hPH77UCMh/X7xv20EWPP2Uw=;
	b=kASR384h/5lRqpS+0/dXu/QIOadOCj3MNcu+GyxlELqb4cr7nVH4ymuZB4+FJgLETqlAh5
	n6u633UKx5tTl1c5xE0odcGqdks/thbJXiHtJ6s+2JTtumzDuzmOlYXjeS13zCsQ7pQwxy
	YlkGLqUiPCoPR9dq3xUYuBn4tFyPMfk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Rgr1tXhC;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780457361;
	b=C1d8gnU80cjOq3AF5guUFXibiKqX9DA41Ziu5k/RuInkav4z9jHpYwkFTS20Iafnye5tRl
	FxH0Isuv1XMPl7tn5b7Z7zQy+VulZGiS8zFZaNVjDzRRiFffsH/stAy+B3iDWdvyTiqNcD
	gDIV4YBV7F2KzQ1EUMpJzGrh4uI2XAE=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8ce9df48e1bso31845146d6.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 20:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780457360; x=1781062160; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tz2WlgQShBzc08rHE8f9hPH77UCMh/X7xv20EWPP2Uw=;
        b=Rgr1tXhCq4xmcIgMRqBQ1M5dZ6WeTnB2+0Fjoi+UEhMZgzwe6GHSSkDUIJ+jU9ZaVS
         gXJcVxPeRFjAzcYrXAmsct9S7gmrVOa9r/MgDfIG82lKJwmTC4aJV1jxvWxd+7DrgTr1
         fLtN/8mlXMhdnvULOZKrvrcqPkd5F+F22dx3Eq42T8Ca5FK3cliHqADMorLpHU4PRoIz
         EO0oRojB10RAXszBGjl/KVnpFYXAsPWwpwpZjb92r1/S2r6aiIxNhW453HTXyX2mYfv+
         HH8EOSQPJH9ZCbp+PSx1eqPxqWn48Ehb+MrVCRkkqy+TvWZBjUuAv1a14GBROpAIVYgT
         eQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780457360; x=1781062160;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Tz2WlgQShBzc08rHE8f9hPH77UCMh/X7xv20EWPP2Uw=;
        b=rgFFMu8UWfJIjhN32dT2mUN6FsNAudu3Q+KFSx61wb3103g4vKwoX9w9+in8WR7RvP
         S9cLmwPLRUKX/snJL9tMIlKfPdLlfmu2IAlp/uogviIBL//53ko6GvCinVDsTMuYkDY1
         rrgqUytMnTV4DxHW3lXcP81G6Anc2I2OgB1uQxglytPMgllXnfZ09ES++xFALM7oArHa
         fW4JO+aAQr7cjXzQJccCT22sxBic1Fck63yH9U1zzAdqVImm80A5TvJObVnvXI67cz4m
         wdRD7HGcbdsm5Q2fdUYmixve5ifv5JHBYLVELgJRKKWrxDrOz0mJYdINKSHIztAobP9P
         LSiA==
X-Forwarded-Encrypted: i=1; AFNElJ/GC8w2sehdoMLps0Jbh/QPlonQIdZfB7WiO9ePrRZ79NXtISOpE2CTvrySVB8AGj66pJDUqGHgVg==@kvack.org
X-Gm-Message-State: AOJu0YzXg13vS+ND6JYb8Fpia19xLq7D5UXE00T9vOarR9mnY6ylyZnS
	rvFeHNgDFE0METiZcAyTxi8kTBdqZuYGcG6/iUT7UcRXTG82lQkS/IB2NgQUrZH3WRc=
X-Gm-Gg: Acq92OFGM3WZlVsNel+jQ7Mf2zTdmpcRxWLgiCqegh6kwVCrQoOKQKrcJKGoBh1GfD2
	fFSChy4iiN0A/xGDW0T1c8bXeDcnmfrsFds04T1e6PHPzzxCxQVcOYen3/+vqToa3L0EKflzsB3
	HMgcPTJHgG5/0YlSk+/m6C8FRQUp471VHVSJsiezAiaT3EB8fe/oqONe00hn/ieS+Y/QsSe0d6k
	vJSfxJwVhftzaOWHIOpWnw9zVsGe9PLnm7AhNdnmWDZqIS5ySSnH6JXlGfVJvLpKHy6Mod8m2c7
	qywFchlTvdbUv/JIjZVbNISM9wVL+o9r4rzYQ7x/FAh2sxJP8MtqcS2x7jGUJImkdkO9o1EOHNS
	ariLkn4RJr1qGDSQeCVoIUe5qMVygLX6QUZNSveUqjOg0A+afK/6ZNcniQ/cIKafum/3KVF7ewi
	5pzOi5Tu60EJUm3EDopEtbH0gNkuKxbvawHO0rO+cSM8gwZLTT4WPiy4GyJPkIVg==
X-Received: by 2002:a05:6214:260e:b0:8ac:a154:e156 with SMTP id 6a1803df08f44-8cecdca3c5emr23602316d6.29.1780457360528;
        Tue, 02 Jun 2026 20:29:20 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd26b3b9sm9244566d6.45.2026.06.02.20.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 20:29:19 -0700 (PDT)
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
Subject: [PATCH v6 09/13] liveupdate: Remove limit on the number of sessions
Date: Wed,  3 Jun 2026 03:29:00 +0000
Message-ID: <20260603032905.344462-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603032905.344462-1-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6C72020002
X-Stat-Signature: xz8tj4aggci95wj5byerca787mxkp66n
X-Rspam-User: 
X-HE-Tag: 1780457361-702440
X-HE-Meta: U2FsdGVkX19WiikTQiq3jfibvPBIqeuSMGq5kvYju1w9DbprgPKiWGp+dots+xrC8+B6RLEFt2fkMyEK+sZnl1NKf6/UdrDDaBEc5HuGGJS+wreCHp237xd5QyszvsdAzszw8K3o6UBC+Zg+H8jbR4LARU358ucUNaQEe5XBLDV6euGMsuXvFLPofhOxpEvgukSg0tCBJRDhtcVJAaMLo56kDNkkBkYIrD9TAl/zXqP4frGqV77oG9eCvzFtjqIW9aXqSVKGauB0o7VDRaEZAhCq7IUOrztZ/Ssl0HVB6mksogmzzxm1W3nWw8JwE3Ei5Fmen8adL2QeyBgRogM3XarQHUdTrIJZsdmWoxPZKK0+C+FyX702bfu2LWXFUYSei3Kldd2swYDXmBfKkCI65pMlV8frYtWNXWhppbt9hs/OvGLNVP2f6DFhGskAtacnS37JCjSPdrKaKWOrjiFbCZIQLONSP7NpF6lv+viulRg5PEk+FLFEs/QnjtYqdzx9xNgZeR8RjmEndpnWvfUE09WgLlt91uD1ERI8yAHPDiCajaDCrhj0i7gS9YAw2xuIX8mc4unjrfa2fNgHGZZsNIbZDbh9UTbdBJXvyLc0k5hYAra/zoQGnRppAetY2gxKwcQf2cvOHiWT2lC3cvT4OKQjQhxr2vrijqqRPq/d96BkZ5A0E9Lb0yj1WNUIn42iFByJbiEQcV+BOh901NBJgb3uC80fTm6mTDBKrPTldXrjv/kgd8oae1v02zHFrTNtGmSpKJaiYugU4o5h4O6eEmJJRn1VNuG4YbL3w8E3j3DGv9pnmz2Dedl3xBKRHobm4AU3ds4hq4aRmvaxBODHGFtGO32zXinPCC8POBr8D+PO+9+95KNr1dnNguWVOoMQTaTMRSmGxoD2/SpgITMuiFfLd9+Ku+B6BNWSTFq8JnhmxcZov5vEAY1HhU+VImxnFlqaFpQz1v6+rhfikCz
 2bWZ+nvA
 seF9IWJQOJNjo42psll6l+RWonNJBZNo1NrEuGiTgZKp8boWqXruhe0LgVBim3SK3l+vREn/So9sTiMFwkqK/n+y9wY+4037J/zqLAH0lXAIKoB1bmZJOHpobp1ATznRLf28jf70Em1v7xhvBIyydvMaLQFT+ZJ1bMSIOVo/yS9hasDYYeR5D6W5AEmoF+W8vK0VtYGnnnPQmi4+tZnEI8cFtN8aCnvGPYsAQPcsyEdu7JE6G/+QaTsp5WpalDq/xdGk1K4NDQYBv2lYqPBlLicX1YVZYuePzmkSRm232B3Mx3xgh/e6PPiYDrg==
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
 kernel/liveupdate/luo_session.c | 113 +++++++++++++++-----------------
 2 files changed, 56 insertions(+), 81 deletions(-)

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


