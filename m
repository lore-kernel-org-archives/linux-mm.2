Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37AA9CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07CF16B009B; Thu, 28 May 2026 23:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02DBA6B009D; Thu, 28 May 2026 23:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5F6F6B009E; Thu, 28 May 2026 23:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D31296B009B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:21:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E93D140FD5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:20 +0000 (UTC)
X-FDA: 84819006720.08.D7C2894
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id E452640002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="L8qHsp/K";
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780024878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+twxrCgMPmxRUfCoAO2rR744nXbCirg1fWRSm/fo6E=;
	b=vQ3G/lEsK1z161wQat6kVeO/Gbp+VjdnfHiLzvyZOfI45VMWEKdEGXC5F+Fk6esDVWU874
	EC13xZ1puUibwmW1osAO249ukgDzN/jXPEpkjEg2M48TQwBoiS/B7iYigOfQrXbyOXAAPJ
	IftY4+5sHpwCKi9Gtpqf1LnInEs0nCM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="L8qHsp/K";
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780024878; a=rsa-sha256;
	cv=none;
	b=P9bZbwmGzm/K3jCsVHmGnveX5UQ4EZ97nChGNvSe2myd2AuT+uFsN8vCvou+1rYr+qEVA4
	zcvxMDwqDKIisF7P4NYkCnMLloBx31f8zCQugayqp+j7TP2TkCevCDCkaObWfzmr1aAaDR
	Baym5TmNU/RsyXDOne7zFn+lJXw6Y+c=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8be236ce888so129806916d6.3
        for <linux-mm@kvack.org>; Thu, 28 May 2026 20:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780024878; x=1780629678; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N+twxrCgMPmxRUfCoAO2rR744nXbCirg1fWRSm/fo6E=;
        b=L8qHsp/KM/RNEQFbSomSPP1TCrNMLzu5LkvywySJ6HlHA9xufhmtANm6fAqKOyYL/Y
         3GImoud+yiDJT9wgDtQYJlnof++XHQ0bYUEXz41BHfeM8ELxMW7dT1kXctcTLAUCrcQH
         Mum9wyiu+Glz4NvI7MqYJ9IjBwQ10Pv/4WyV2B9E2TvDXQ8TyNDmM/DCibxvudRxhM5I
         8Gmky9vGiwVDD/X1g+4Vj3Bq+kgDUE7b7jvFb+lG21gDCYjHrBUgPWfFScg9cHPuC0B5
         h2wJx6YSUnkJNu7LRGh2zu0EbWQWg8NX+3nn3bphmvNGajX1vOuro7K8QKeqk4h1ZSOV
         NLcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780024878; x=1780629678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N+twxrCgMPmxRUfCoAO2rR744nXbCirg1fWRSm/fo6E=;
        b=Ozr7GZeu65n7Fhn2vZRvPExhZmZ47Tu0hRgTN/g0VUqsDQZSvSVwkJRcrilRTj5V7Y
         0gkeF6vWCJ3JABoAFBKHZFJzeRI20zrXWzAhaDzcwc88egNUERPulVCj+CRILkp0bM/l
         GKNBDyNuGiyWjR5ZglbQvX0pU5vsPobH5LBkWA3NFkkfjxfSk4zF30R7vbnfkOThTGwe
         ZhhfkltzO4K7XJvRl05OLTzF5skS6NnoDE6+Shb4VeDZOdKFGeKQdajm3dKs4DOIgHmS
         3sw0moi9cTHk/z5+p8/TzwY4oF7sbCzp2B7e+V2WlTgHf3tiQWngn79vtt62jKAGtHOA
         Szaw==
X-Forwarded-Encrypted: i=1; AFNElJ/Ja4COcXgTte4LwJx+IJbtLMqbPo3AGq30I2lFhdQd/kzfHoMDnQFqsvutusWnNGaFGIHmy/Ns7Q==@kvack.org
X-Gm-Message-State: AOJu0YwvU5kXqkdXHUgLZW+QbDlu6K0355OysaIs23TCHs5Esjr7xxPE
	jNRvPl3wl2pLip8hAry0i1Am6PWn/Jdz5g/irl0MztwiDvQmdzF3jYRCSv926iuL4oU=
X-Gm-Gg: Acq92OE2aoWylGIPt92uOEosJ3K0uQCtzWFvcVFC78IJw5c5Vtri/dYYtAHSRLDmcnU
	PaD/wg/chTljZoPxnKDaFYCSAunDKWtHDqygDOGl36Se3T7kYdJMdSYgiy3mVwpPOqh489OGIBD
	HPwV+L2f5zZ/8xk6TxnTbbYyqPBlyYEVAdLpo+5EoOVhaJX2OxTF62FfsqmiOiUAAS6wpjwjd1/
	tYg9tMc7WsW9Z/los//uD9GfXBRyPf2K38r6HKy9bcWsrogkU9HHjfmvXmgBNEV7WH5XQV8vuT2
	9LZ/DhNtgxWLf6duEN8zT84EhbyAKkFxoWJQpawDdRvHOSyw2mSFnKbzZqh/x3+/Xd7IrFGC/rh
	KpBbXJHSuEDsL01qddClHpiCi6f3p/mHO8YwnXWzH7+dpsRaItJks5O/tENe29X4swnDyLATGHb
	MZouq8n7Hb6H026w8kQNyO/iuK5g0KLZaTw4/K7AGEuhLoj78As4CmQaEg22tLupqZ3qvgwuWK
X-Received: by 2002:a05:6214:238f:b0:8cc:3546:2630 with SMTP id 6a1803df08f44-8cce7fd38d8mr11874636d6.9.1780024878004;
        Thu, 28 May 2026 20:21:18 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea26d286sm1179476d6.48.2026.05.28.20.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 20:21:17 -0700 (PDT)
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
Subject: [PATCH v3 07/11] liveupdate: Remove limit on the number of sessions
Date: Fri, 29 May 2026 03:21:02 +0000
Message-ID: <20260529032106.1505796-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
References: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cruu7g3quauwsuhbzokk1hcy8ktf1itm
X-Rspamd-Queue-Id: E452640002
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780024878-261282
X-HE-Meta: U2FsdGVkX19XSzyOyTeCvATXgyk7VBSZ3n3BIdfOu98seGGNT8jSXgZHdyEsSrmjx/Ovuiz9Zj91HK0bfFmHFzTwj/0Qr5yF1Bc4qOBa6w9B6DoGA9WRjtySO7HIb7coQV+MqjPPUes0/AWmr9d57/qY60Pz0Fc+JsFUMt8Hw8i9pO8JIDaYBavdsAr0LiLBW+3N+D0SXsuvT4DygN9pzRZH9VCLVaTvUfos8/4DnfVdR8UUWgbexMEVABesP5eoZZl83nqNxYVg7WDUWbLUW56IfCvle0rTsBOmx7FfTh56wNL7gFfB7t4ZMb2POLiwYrw2Wor/Ip//ICdjEUWIMZt4UBxXbh8VI0jSTHd2T5PdmMt2ZrmgFcINeFj5cnhMfJaqy4oluC7yBNdRfNJtjCcW/J4nanqx6Ew5+ojzwbamoFKGoteJ/L+wW39AOzdAzzObuzRafb9UyflSysRpfFLQW5+fuqejhSRGBSbR4fHnPGLeCholE87vDjisfAVs4B9nH8v/RFAf6+/hFeTb6vBVsZtshUHTP7WCVQl0WfSjLYDRNc8klHhEcdBZgGKo5BE0uup303lPIv5hQNA83wc+4NTBxAs1VmILOM8ghZK25o2hgEnESxJEUL2t/yJ3Hs88x9/QR4k81OguIXdhYzT1n85S68r1qmNpLHWeVB0Ydporn5s6wmAxIwLmYE9PwIVPgLiqPRWNLydlSBUNPvAzsugslkLMYwvYn0pKTmma0hYZPAa+6kHWFkQw5xm7V2qCeAEKgxKwlctw5mzMaKYyn16RMDJSjyzchW6yD27STaWHLXvySUMI5mMKX0yOBaO1mCLA0TIuHiIDIQM2izzkhMGqUZNGi8n4lS58zCBX4VsIh9bawKeRFKPkM3zJVjYip59inm9oqiPAA1ot+5IcD70tBm9pfZ634PEsYyTCpaTKcuKvTuvU7FBsprKA3W2pAN6uza/7SpQ+FO8
 McUoayHe
 uIb7/Vkz18jZgpaj0wZhLejBArhYTWSQM3dnPS3EONmpfcQ2zpUsi/d25/FEF3F6NFaaRgqZ+fnoZyFlFYDzWRZtsKUIjDyIhNcn/0XXZBnmVHnnFrG+GE8AvgTa1tJuE0dFWIJEB9ysV6byJmmxCD85YCG3gHrjJhAfBwXGhtKaUpczIMOk7pzQp5MSQhbsM9RgDnA81jgbLtgv2LRmFBUqUwW89QYhcJe25AbvYFW378NKGOggtDsC2PBYYuwcdhxxyAh/9iqsM6fhI0we8RscU8AaEWFeCpXweTZLFYD6pT5xwzSmlheZzXa6mC7/UnGmC
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
 kernel/liveupdate/luo_session.c | 114 +++++++++++++++-----------------
 2 files changed, 56 insertions(+), 82 deletions(-)

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
index ec72f16185f3..c340ae4bf743 100644
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
@@ -526,15 +505,17 @@ void __init luo_session_setup_outgoing(u64 *sessions_pa)
 
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
 
+	err = kho_block_restore(&sh->block_set, sessions_pa);
+	if (err)
+		return err;
+
+	sh->active = true;
 	return 0;
 }
 
@@ -576,6 +557,8 @@ int luo_session_deserialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.incoming;
 	static bool is_deserialized;
+	struct luo_session_ser *ser;
+	struct kho_block_it it;
 	static int err;
 
 	/* If has been deserialized, always return the same error code */
@@ -601,53 +584,62 @@ int luo_session_deserialize(void)
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
+		struct luo_session_ser *ser = kho_block_it_next(&it);
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
+	kho_block_it_finalize(&it);
+
+	if (sh->sessions_pa && sh->count > 0)
+		*sh->sessions_pa = sh->block_set.head_pa;
 	up_write(&sh->rwsem);
 
 	return 0;
 
 err_undo:
+	kho_block_it_prev(&it);
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


