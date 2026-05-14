Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 844F6CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 22:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59A926B0098; Thu, 14 May 2026 18:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525016B009B; Thu, 14 May 2026 18:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34D756B0098; Thu, 14 May 2026 18:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CFDB6B0098
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:26:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C64681C059C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:44 +0000 (UTC)
X-FDA: 84767461128.09.A12E515
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id EA6391C000B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hI8urN4N;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778797603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2T3oA7tkx4rspjASSft4V+bRK2GXucIgM1nPm7xvZEk=;
	b=IX//QKsnPOu3BDKitImG61xSXjzsZe1u8lDZO0lq6HJIF1NsTIYDWz+/03n09IXjWiMP9D
	FxBYOmlMsPqFr3a8Pa5GgyAYYg6IM+sCQSJHxRWev7xiROX58F3gO5y2psPYIa8Seel2Z8
	h0BG8Nh696y7mQ5d20PMu24RaGxN8ww=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hI8urN4N;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778797603; a=rsa-sha256;
	cv=none;
	b=l8qg++4aITHRcChWgZHW3uiVYPd3tJ9o0jPc0brt1nizZfYs8sDvYBB0sRF2PJJ85MhngB
	at5+S+9rm66EOXIliTcrSP7AkMfdoxHPNXhkS7OhgtzPREPEfDETt5TjOUQ5bGXU15qGlN
	BvL/biz0uvFuA80J0Puhf/Tga5DYCYU=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50faf8ed9c5so45563411cf.2
        for <linux-mm@kvack.org>; Thu, 14 May 2026 15:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778797602; x=1779402402; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2T3oA7tkx4rspjASSft4V+bRK2GXucIgM1nPm7xvZEk=;
        b=hI8urN4NvCQp4kz+NFIHV3mjRGhOWygt4H/tYDv1qK8HbpPTvTWAC1kLNdUE4lUKbz
         rKB/kQTacxwF7JMxaibeXIMkPKkIwTFP3HMelTgSHG724p6AMKBFsPQq7gfQohUNYW85
         M1ncW9w+CB96KJgOHCRI49SqPuXs/len6fJmdPWeQb6vYT/37WSXIZVIwYChbt8NCgUE
         TJM1hHClJ8vfv63Xx5WYNP5W9IM+BXb7T3cPGXTWDBJTLFuj+ZGHM6BqcU2Hk1DRR2i5
         iO/AxAzS9H/eBsYk6DzJEShvxeH35p5sd2aj2fenKAT2qemnoptbXGdXQoOn3XBeEcD1
         ZtPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778797602; x=1779402402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2T3oA7tkx4rspjASSft4V+bRK2GXucIgM1nPm7xvZEk=;
        b=ZzuS54qT4I9w1qHNU/kqwGVUhaX3IHu7iX11D11xswAzM2Q7tEtW7xZOiJ4WmE3sSE
         amGKxnm4mrMfw9eOzpaCWpk5LcQBgbcMRa3sSjJN4spzHVOwNS+jVGQWpFZkVE3x0exO
         K+MReYUXnXQW618xEPClo6qR6BUbg82s4xh2JvO71TW3yk8ayBiZCJ3nLP3aZJ8LwHZ0
         6Cgdfz8+f1SFzl5c9bsl/uH/63bObKCHMNn53VdMDeXrLY46h2UvxkG2F38tyFo0Z7DE
         JpMHbOEKd8Um7MjfsHTYWe/qreoJ7EMSyTkE3mBAQEXzQUo2V0LCge+Xjrm58JASKN/l
         BOtQ==
X-Forwarded-Encrypted: i=1; AFNElJ8qJe8iVbM5b+ZUkJUwz05xhn2H4waZQF9uzxfc7l01FS0XRkLR1z1aO0KdOcJHiBrvBh2BgDYZHg==@kvack.org
X-Gm-Message-State: AOJu0YyKe94QjOsWPq+JhmHCl0pRKIGg0Eyq8lLmid9AAZrOhXDuP9Ik
	pwKjgVrfQ1EGDEbG9t4QS5IruEv/SYNdd6Q0naeMd2XN9FD0xR1Zr9Jck5Dmt+kE0tE=
X-Gm-Gg: Acq92OGR2vwDRsHORiAPC2626HC2AHMStll3QsNOtI0zamFyqGnyAtTe5oKQ9vduBIU
	4+HpDulQLYBlfXSSGa70G2t0oyaNaJQrP+UQ+4wVOncEMZNHBg8xdkx/YKJPy+7u6B2kDkk1J4o
	jDNc3DxnvQG7h6tL9kKdxsTzeWKoWNmhhtOZ7YpQ1ZxuvGNHEdSHMLMQBmTHpvvHTcFlFxEzZJd
	/+4AgNwtA2vGFQKVjAuE4B/TKJe3+4+hCzY6jMTaEn6IT5xfy/6wO0EctgDlv5wk7VJZ6VXJx36
	NO5OVgiAMGikW9GLuAM4Vz5yDAQzVlDq6r9wicdzc6cgQZAaaFYzkTVfDqa42pYr3Xft1hIeQv2
	79H+8bgjOe29evYuyqRt3cq5QR8MQwTv4+QZlHTLgjWxPX/KMbCU9o4IT2+FWlFxjE1d3Tc18GB
	q/zn20TpCaJ8sl9YdQdM0AVbxOaj3+DqIgRz80Z8mTcNZpgA//nj4=
X-Received: by 2002:ac8:5c92:0:b0:514:6650:eea4 with SMTP id d75a77b69052e-5165a296e10mr18589761cf.57.1778797601967;
        Thu, 14 May 2026 15:26:41 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456ba92fsm28671901cf.9.2026.05.14.15.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 15:26:41 -0700 (PDT)
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
Subject: [PATCH v2 06/10] liveupdate: Remove limit on the number of sessions
Date: Thu, 14 May 2026 22:26:24 +0000
Message-ID: <20260514222628.931312-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260514222628.931312-1-pasha.tatashin@soleen.com>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: poy93z7en8ftuuhhiygjitenusd3tcnq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EA6391C000B
X-Rspam-User: 
X-HE-Tag: 1778797602-943781
X-HE-Meta: U2FsdGVkX1883tFBT9/AgjwXVoBqOTgCCVico/KFf2lB7S/3LynS6dxCNGoYHt7x9c35AjrdWgyU/ziyTaqqnZaqT8vG7B4Qkg7UN8kkVN7+rzeJy5ZsU5uCMXRaiQp0tCTaoYQR+bjm7HLYYZ85nqnVUBau4N7mFW8vpDKjyv7P+XFWQ+d/7RDB17vSt+wfVHquJfjrQuaErUwmcb5ttctAPr1AbrtqyqLE17RRtK5n/qb+ZR1Elx8EsjNM48qUo7EKFXnjNmVk0tgqZe44vIaNQQkyJ2ALx1DB24PlRb9jBOtwSrkDYGdE52Sztx77qegN/qY5rjjh+9uGYwp1SRhdZnHNLZJdzqPV3s+QQUGHCFueHw53ZzExk6VDeYp51ATJGrYZxZh2Co01Y6LkcMyJPdc2i4B/jBYVnipcR2Uhf5cdz2VQUQTreXgt3+/tO2AodRji2t9KvfNzNT9yVvc9IPHMBxtzC+GYe8VUiaDqHs52A3Jm3KR/MeOZrwtHJ9j2DYYDvI1WCKUEPZx0s0vIhA+wWjNRHow/PNI1nuHQwqwCkEp0ZdANWdut1FqvNQXaBx+Q723I4F1SFYu66skG9ZeqHbfDSxWfnAHeU/MBfvMWnvXuy0jL85GvH16HkM6s2ewvLXeo0oz/h3RQs/w7RAGBrbBigdLuj/r0ayoJP0+P3j+TP1iOGdE4xytB8RLT/fXMujorxHOWPZKcO5XHUZif5ObiS39iXEcHMu/nV50polrhbyhqGK3jN+OHV6BuYV/pHe6W4ucPjTiTCtcGPI3sEZ+ii2OtV8NI5WfjqoTVebq0Ct23/P++iw1CGpE+OLaS1rhodvUqd1IWqflBXFGXVshck+e94Sjoy6GGjyDsNGqhLsGuwtISb329nlU9SfwbZFJuduiYnPf52AcUNCluieOm/50x++6bWL8AVnLRy9Q7/+nOITMTg9X8OwJ/iokkQtIMq8Toc2s
 Uu4gzaBv
 x4tZ1eKz80s//2gM+xQh96dUYK5SwotGlzVNeD+3yHhu3CytO6+2etXdJ4Mpzk7k2Rmdwhh+o001b/anjS3ideMDITGPoZ84m7YOLygHmhcPIxdji1wZi9WhqiUF+5VHAfOmPGSFN+WxKM/Z/n13Y9w7vQp11YekrWRf+bPLkRqoam1W4NowHcM45ix6p2w5j/zgQZKq/nhsR2Q0QMoNMf9xXeVOB42KrkK70Sel0AqK3eQtr3IExRABLKahE4WmdmlbRCP3gm3wN0xEfUev6VVPu4G3P865mSQmhnaP8evk5HbMWWCeJusl7V7q/jJ+XWKzyFu7hLKzxZ9uEe/BpTfpi/7+/uWhzRzAbTzlUXPDhy2TuLQyxV75umIyYc9cHdN59y8bXVBiu50kvaYWL7HCJW2CszUXrwMpb
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

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/luo.h     |  24 +-------
 kernel/liveupdate/luo_session.c | 105 +++++++++++++++-----------------
 2 files changed, 50 insertions(+), 79 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 2ba447c0c1ba..a643193a379c 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -36,7 +36,7 @@
  *
  * Main LUO Node (/):
  *
- *   - compatible: "luo-v2"
+ *   - compatible: "luo-v3"
  *     Identifies the overall LUO ABI version.
  *   - luo-abi-header: u64
  *     The physical address of `struct luo_ser`.
@@ -54,11 +54,6 @@
  *     of the next data block and the number of entries that follow this
  *     header in the current block.
  *
- *   - struct luo_session_header_ser:
- *     Header for the session array. Contains the total page count of the
- *     preserved memory block and the number of `struct luo_session_ser`
- *     entries that follow.
- *
  *   - struct luo_session_ser:
  *     Metadata for a single session, including its name and a physical pointer
  *     to another preserved memory block containing an array of
@@ -90,7 +85,7 @@
  */
 #define LUO_FDT_SIZE		PAGE_SIZE
 #define LUO_FDT_KHO_ENTRY_NAME	"LUO"
-#define LUO_FDT_COMPATIBLE	"luo-v2"
+#define LUO_FDT_COMPATIBLE	"luo-v3"
 #define LUO_FDT_ABI_HEADER	"luo-abi-header"
 
 /**
@@ -155,21 +150,6 @@ struct luo_file_set_ser {
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
- * If this structure is modified, `LUO_FDT_COMPATIBLE` must be updated.
- */
-struct luo_session_header_ser {
-	u64 count;
-} __packed;
-
 /**
  * struct luo_session_ser - Represents the serialized metadata for a LUO session.
  * @name:         The unique name of the session, provided by the userspace at
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 339514e8122c..064e83fabe62 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -69,21 +69,13 @@
 #include <uapi/linux/liveupdate.h>
 #include "luo_internal.h"
 
-/* 16 4K pages, give space for 744 sessions */
-#define LUO_SESSION_PGCNT	16ul
-#define LUO_SESSION_MAX		(((LUO_SESSION_PGCNT << PAGE_SHIFT) -	\
-		sizeof(struct luo_session_header_ser)) /		\
-		sizeof(struct luo_session_ser))
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
@@ -92,8 +84,7 @@ struct luo_session_header {
 	long count;
 	struct list_head list;
 	struct rw_semaphore rwsem;
-	struct luo_session_header_ser *header_ser;
-	struct luo_session_ser *ser;
+	struct luo_block_set block_set;
 	u64 *sessions_pa;
 	bool active;
 };
@@ -112,10 +103,14 @@ static struct luo_session_global luo_session_global = {
 	.incoming = {
 		.list = LIST_HEAD_INIT(luo_session_global.incoming.list),
 		.rwsem = __RWSEM_INITIALIZER(luo_session_global.incoming.rwsem),
+		.block_set = LUO_BLOCK_SET_INIT(luo_session_global.incoming.block_set,
+						sizeof(struct luo_session_ser)),
 	},
 	.outgoing = {
 		.list = LIST_HEAD_INIT(luo_session_global.outgoing.list),
 		.rwsem = __RWSEM_INITIALIZER(luo_session_global.outgoing.rwsem),
+		.block_set = LUO_BLOCK_SET_INIT(luo_session_global.outgoing.block_set,
+						sizeof(struct luo_session_ser)),
 	},
 };
 
@@ -142,25 +137,6 @@ static void luo_session_free(struct luo_session *session)
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
@@ -174,7 +150,7 @@ static int luo_session_insert(struct luo_session_header *sh,
 	 * for new session.
 	 */
 	if (sh == &luo_session_global.outgoing) {
-		err = luo_session_grow_ser(sh);
+		err = luo_block_grow(&sh->block_set, sh->count);
 		if (err)
 			return err;
 	}
@@ -201,6 +177,8 @@ static void luo_session_remove(struct luo_session_header *sh,
 	guard(rwsem_write)(&sh->rwsem);
 	list_del(&session->list);
 	sh->count--;
+	if (sh == &luo_session_global.outgoing)
+		luo_block_shrink(&sh->block_set, sh->count);
 }
 
 static int luo_session_finish_one(struct luo_session *session)
@@ -489,15 +467,17 @@ void __init luo_session_setup_outgoing(u64 *sessions_pa)
 
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
 
+	err = luo_block_restore(&sh->block_set, sessions_pa);
+	if (err)
+		return err;
+
+	sh->active = true;
 	return 0;
 }
 
@@ -539,6 +519,8 @@ int luo_session_deserialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.incoming;
 	static bool is_deserialized;
+	struct luo_session_ser *ser;
+	struct luo_block_it it;
 	static int err;
 
 	/* If has been deserialized, always return the same error code */
@@ -564,51 +546,60 @@ int luo_session_deserialize(void)
 	 * userspace to detect the failure and trigger a reboot, which will
 	 * reliably reset devices and reclaim memory.
 	 */
-	for (int i = 0; i < sh->header_ser->count; i++) {
-		err = luo_session_deserialize_one(sh, &sh->ser[i]);
+	luo_block_it_init(&it, &sh->block_set);
+	while ((ser = luo_block_it_read(&it))) {
+		err = luo_session_deserialize_one(sh, ser);
 		if (err)
-			return err;
+			goto err_destroy_blocks;
 	}
 
-	kho_restore_free(sh->header_ser);
-	sh->header_ser = NULL;
-	sh->ser = NULL;
+err_destroy_blocks:
+	luo_block_destroy(&sh->block_set);
 
-	return 0;
+	return err;
 }
 
 int luo_session_serialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.outgoing;
 	struct luo_session *session;
-	int i = 0;
+	struct luo_block_it it;
 	int err;
 
 	guard(rwsem_write)(&sh->rwsem);
 	*sh->sessions_pa = 0;
 
+	luo_block_it_init(&it, &sh->block_set);
+
 	list_for_each_entry(session, &sh->list, list) {
-		err = luo_session_freeze_one(session, &sh->ser[i]);
+		struct luo_session_ser *ser = luo_block_it_next(&it);
+
+		if (!ser) {
+			err = -ENOSPC;
+			goto err_undo;
+		}
+
+		err = luo_session_freeze_one(session, ser);
 		if (err)
 			goto err_undo;
 
-		strscpy(sh->ser[i].name, session->name,
-			sizeof(sh->ser[i].name));
-		i++;
+		strscpy(ser->name, session->name, sizeof(ser->name));
 	}
 
-	if (sh->header_ser && sh->count > 0) {
-		sh->header_ser->count = sh->count;
-		*sh->sessions_pa = virt_to_phys(sh->header_ser);
-	}
+	luo_block_it_finalize(&it);
+
+	if (sh->sessions_pa && sh->count > 0)
+		*sh->sessions_pa = sh->block_set.head_pa;
 
 	return 0;
 
 err_undo:
+	luo_block_it_prev(&it);
 	list_for_each_entry_continue_reverse(session, &sh->list, list) {
-		i--;
-		luo_session_unfreeze_one(session, &sh->ser[i]);
-		memset(sh->ser[i].name, 0, sizeof(sh->ser[i].name));
+		struct luo_session_ser *ser = luo_block_it_prev(&it);
+
+		luo_session_unfreeze_one(session, ser);
+		memset(ser->name, 0, sizeof(ser->name));
 	}
 
 	return err;
-- 
2.53.0


