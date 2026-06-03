Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AAD7CD6E6B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38D86B009B; Tue,  2 Jun 2026 23:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94166B009D; Tue,  2 Jun 2026 23:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F646B009E; Tue,  2 Jun 2026 23:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 90ECC6B009B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:29:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49766C0B69
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:21 +0000 (UTC)
X-FDA: 84837170922.26.71BC15C
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8A32B80006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Qi1zNhyM;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780457359;
	b=DM4yCrGYIxpmIJdjO887EdWY68jR/QpjnNgAWmO8Y8KyLAoMJpZ9nubmuSm0qhYeQu3wIz
	ccrdiYMIDC1hSq/TRDoxb3wu8xT6Aip7dMKTr+iBz7+8obrE0iku6TdoDLgdy3Cg7d5jDd
	0BSssLRBpZnXxabkCDIywMi02s3OkRg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Qi1zNhyM;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780457359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9xWUzUEP3GatCDCPhqDCyXoyiDq9Ol5847oPRS2f7E=;
	b=v0/Q865S6jLlcqTR8ph88Sc0MxSix3YCjqBS322arxzFsK8zyy+tl1mK337u7DVax8GrhG
	nrRCKROq/GDkTqqZj7Y6Ii4ziE8SQ9NxXLv9AZL+OPs5awvkWG4IGUPV0a5PAxo+nPAGzY
	fhs9cOza4g2WZ2D08M139/hBbcBVCmQ=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8ccf887de87so44618356d6.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 20:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780457359; x=1781062159; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C9xWUzUEP3GatCDCPhqDCyXoyiDq9Ol5847oPRS2f7E=;
        b=Qi1zNhyMGuHQ42Eb8sFhK3bceMQQLOSzBixcrGGqf9AE4wmAXfJDGdFmTQUKcn7Gng
         3AYspUItg/oiO9zrLxvuF/mqXG3ch73T9hgn0ovch09WVk2eocPgw/0MmMdLyxPsWvLg
         aN/7kIfPqDPRXMbMlTFmIeqCWAmlSjTZ/Z/tWbrOYvGGrSA3bgpVMCeDaCqRLWVBoKgU
         zhvHBJi9sr9CSgbEHfcImuAbSS5KOn8ip9OnEnzcsRTeA+iPM6fXYQrjrSQgbsJ5wma5
         BvawKZX/ZX1A/Dz6/AYcEd458ezl5rwfHp743A9GCfUsrQTCVhApP0t7u/wkOC7kAbRe
         s5lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780457359; x=1781062159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=C9xWUzUEP3GatCDCPhqDCyXoyiDq9Ol5847oPRS2f7E=;
        b=VkrIp09uZg9fl/f/a4AYJZyIBvio6MrbuZDdpYENQcI1NBxp244p137mYgutduGmUg
         gjK8b4kdN4C6xM40tIbL1ZFS3m6gtIRJvJkpJw4uwX8QAv1pGDUS+w9RkgB5OMzAuEdY
         uabjNI19gqwDdSu0mo34DQ2vUQnZ60jWsBB+ymr9n2N2NuEeaWu1BakesdzCmMItsNbx
         9ehkhCxCiVtCuZb4WnQU7zuSaPzSS8pxnItAbSm0puShgnWgIYDcsCVRhhJXcg82Dxa2
         hfIGGA1QrxA7fcS0l1km9Ehq3Dwy6ERn45MGiBLmJHedq3uBLf25qbgfr6d2KCjC5FXr
         a9ZA==
X-Forwarded-Encrypted: i=1; AFNElJ+nV9nW2/rwKGttR7NYVv6C+W+I5yayjCtQGFocHP3gRgkPuU4M4XkUexLHfKFriqgOI90mpiv2yA==@kvack.org
X-Gm-Message-State: AOJu0YyxJb8FGioC3fLh00dfwGsCQn5ZdZ59oWtr7qU6eG0TQl13ZspY
	273017fjy+aiOGX8sPLDx7m8cQAw5/LIuqqDZcYrBkuiuq2ajuU1jfg/1xrESVe/zuA=
X-Gm-Gg: Acq92OFbLr7ue9VG4rxklV8AYmvshe67zpr6n6ZD8KEMuOBLhnKO4z+FSuEqchtmB36
	zdCYrteNLyQc0XSJDUf9xSFJrfRM/LOAWQBXnapmpXQMDnEzxmpNu1K8ioDX5HbAMEdn4ebpX7g
	U4tfVh8tuauHBKTARkhaR3afyqWwMvbTu9C/IZT1qtl/yb400XnZsGrpXH+4WQIgWaC9DDqt0tR
	cNfcjQpqFU3Ck+tGlDvjFC7AwBEAMGbdhG8Pngn5B+haetJnD0lFNLjatlO63WrOVF2/p5qp18G
	FZyPdsmfJ6r8Avukhx0U5wIp5xDWo2Y/Aj2oAEQpB/NifCUaSxZ9hmZt2A0Dcx6cMDG3O54wHH2
	RVLOoK6lDHaYMLwpmljFLZbHbsyNvP59BWp5uID68IE6CSTdtfSrk8INTz/TpiJAnFzJCP432Ub
	oRr3V8Bhtl2pQIWArTdSRVHL05JOqUeoJdnqb1/EMkUhqjlG2RKxfw1e0G9RcGrw==
X-Received: by 2002:a05:6214:c24:b0:8ca:10c9:845d with SMTP id 6a1803df08f44-8cecdf0ca03mr21814626d6.31.1780457358504;
        Tue, 02 Jun 2026 20:29:18 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd26b3b9sm9244566d6.45.2026.06.02.20.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 20:29:17 -0700 (PDT)
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
Subject: [PATCH v6 08/13] liveupdate: defer session block allocation and physical address setting
Date: Wed,  3 Jun 2026 03:28:59 +0000
Message-ID: <20260603032905.344462-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603032905.344462-1-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8A32B80006
X-Rspam-User: 
X-Stat-Signature: opkpt1tgofx9wcek7qowbsi4qgckpx7j
X-HE-Tag: 1780457359-300677
X-HE-Meta: U2FsdGVkX1/7QnYisW5jGsZvKe62eCYmd+Ok/GMkf1GEZ+F70hr/8di/sZmRWrp3qQDufEsBpjCvnnJrKBqwBCAoJ6l02taP4LpvEjTU9drFjGE8cZE1GH6CHRB/7jYLwE/fFPau3IH7vNP/u0Lvyj9SKGHFkxl++J1vqHhS+CPGPmJ/EkcUzKPjX6xKdP4L2MCN59zB/hHgZTIAzLIF/3eQ8Y33Yqt3VW8BzD77yuQJiOB2VjtOMzagX74YBGsVr+otuHq8AIQRPJo3vdGpqYmO3sjIesPuRYA1qh8qNV8ANQmecCxBSWkofuIeH0TrQp1qOdKmbAmfdk6/F9AoO9bD6H9ruMTvyLLGhG1HMDvCAKfnK+D5RMwi1J0gAaqmwda3OH08Nw0y1e/EQPUBsHxcp0snYRjmem6KlphVgReBSK2MrtkTkHOTzDgyJKQEVy8MWZi8K1dBhBaQSPpAeCmOIkfLOJhYWgcbe5CWums/8/pEDcq4oSfGoPmyMJRPlKAbJtF+gBCA71XYWylkcMT5kxIBan0g/QMfFErIk9sHOy2ywY9mU02LEtXNaFKhexVRbEFOmO3/tQ8uYOxPkH2RywM38nEcVxSjSM9ZRM3lBrVIF5sQgsRLjfQQUDtPAysG6EWi92l2Tj+V8wUQdLGpm01c8dqpONNzfmsFyTRjM/cotkPeAtZ+Ba4VjPj1ZGWP5y8c/uILeUlZPDLG6z2q8Z12UIr50Kt4OQ8PJP8ztQsK5hl37Ys6hqlsCUvYOiI93NISybB4Ecu2gkaIuevBMde0kLIyVThmD9AVPAg7O6SWeZwBzxYTjHLAuq86/LQdQcVDBRS/7AOE5Qi7SD/d07Kj2tu6tANbj7QTcPYKuBz0nwgX4iGhRlqaJXeqn9qtxrrFo01/TQAkwvOZyECiopQrshXhD3qW4C0lc9O5/KXwNBf+sE5/SeC+hivcsnPVbSTmo4GHIAyFGcR
 0GlIGdIh
 34efH9hEN2CAolakTro7+xIktgEg/RND+UJFs0eEQuhdUA25RtabateOIaIDZIg/DdLADbptWZFjKFiW28h1xMzjU2g28iJXa3teWoES6yAcwMHKo1MXFJTjETFPn9gMH9FUo6nuwvL3SiVfWr8MkA5niy8lE4ueKkaDmdyEoG9TJruRO6AKe61GqcWDpNvydqiVWzQ4PttxHTbhOgVXntQPDTbqoJgo698CghUS7oSNjebv2XuSahj2XDRfNCcYIKIFJPYOSLN4JFeCJJaP2XUV0YRNEXNgXacwhvQhEcf35EFf/nwpqwZABOAGk06wpfBTN+N28wf+K8SkDt6Uot3OF28j2rqseCXsL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, luo_session_setup_outgoing() allocates the session block and
sets its physical address in the header immediately. With upcoming
dynamic block-based session management, this makes the first block
different from the rest. Move the allocation to where it is first needed.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_core.c     |  4 +-
 kernel/liveupdate/luo_internal.h |  2 +-
 kernel/liveupdate/luo_session.c  | 68 ++++++++++++++++++++------------
 3 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 69b00e7d0f8f..1b2bda22902d 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -165,9 +165,7 @@ static int __init luo_state_setup(void)
 	strscpy(luo_ser->compatible, LUO_ABI_COMPATIBLE, sizeof(luo_ser->compatible));
 	luo_ser->liveupdate_num = luo_global.liveupdate_num + 1;
 
-	err = luo_session_setup_outgoing(&luo_ser->sessions_pa);
-	if (err)
-		goto exit_free_luo_ser;
+	luo_session_setup_outgoing(&luo_ser->sessions_pa);
 
 	err = luo_flb_setup_outgoing(&luo_ser->flbs_pa);
 	if (err)
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index fe22086bfbeb..ee18f9a11b91 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -79,7 +79,7 @@ extern struct rw_semaphore luo_register_rwlock;
 
 int luo_session_create(const char *name, struct file **filep);
 int luo_session_retrieve(const char *name, struct file **filep);
-int __init luo_session_setup_outgoing(u64 *sessions_pa);
+void __init luo_session_setup_outgoing(u64 *sessions_pa);
 int __init luo_session_setup_incoming(u64 sessions_pa);
 int luo_session_serialize(void);
 int luo_session_deserialize(void);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 1cd315e0f6de..2411849a34e3 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -108,15 +108,16 @@ static DECLARE_RWSEM(luo_session_serialize_rwsem);
 
 /**
  * struct luo_session_header - Header struct for managing LUO sessions.
- * @count:      The number of sessions currently tracked in the @list.
- * @list:       The head of the linked list of `struct luo_session` instances.
- * @rwsem:      A read-write semaphore providing synchronized access to the
- *              session list and other fields in this structure.
- * @header_ser: The header data of serialization array.
- * @ser:        The serialized session data (an array of
- *              `struct luo_session_ser`).
- * @active:     Set to true when first initialized. If previous kernel did not
- *              send session data, active stays false for incoming.
+ * @count:       The number of sessions currently tracked in the @list.
+ * @list:        The head of the linked list of `struct luo_session` instances.
+ * @rwsem:       A read-write semaphore providing synchronized access to the
+ *               session list and other fields in this structure.
+ * @header_ser:  The header data of serialization array.
+ * @ser:         The serialized session data (an array of
+ *               `struct luo_session_ser`).
+ * @sessions_pa: Points to the location of sessions_pa within struct luo_ser.
+ * @active:      Set to true when first initialized. If previous kernel did not
+ *               send session data, active stays false for incoming.
  */
 struct luo_session_header {
 	long count;
@@ -124,6 +125,7 @@ struct luo_session_header {
 	struct rw_semaphore rwsem;
 	struct luo_session_header_ser *header_ser;
 	struct luo_session_ser *ser;
+	u64 *sessions_pa;
 	bool active;
 };
 
@@ -171,10 +173,30 @@ static void luo_session_free(struct luo_session *session)
 	kfree(session);
 }
 
+static int luo_session_grow_ser(struct luo_session_header *sh)
+{
+	struct luo_session_header_ser *header_ser;
+
+	if (sh->count == LUO_SESSION_MAX)
+		return -ENOMEM;
+
+	if (sh->header_ser)
+		return 0;
+
+	header_ser = kho_alloc_preserve(LUO_SESSION_PGCNT << PAGE_SHIFT);
+	if (IS_ERR(header_ser))
+		return PTR_ERR(header_ser);
+
+	sh->header_ser = header_ser;
+	sh->ser = (void *)(header_ser + 1);
+	return 0;
+}
+
 static int luo_session_insert(struct luo_session_header *sh,
 			      struct luo_session *session)
 {
 	struct luo_session *it;
+	int err;
 
 	guard(rwsem_write)(&sh->rwsem);
 
@@ -183,8 +205,9 @@ static int luo_session_insert(struct luo_session_header *sh,
 	 * for new session.
 	 */
 	if (sh == &luo_session_global.outgoing) {
-		if (sh->count == LUO_SESSION_MAX)
-			return -ENOMEM;
+		err = luo_session_grow_ser(sh);
+		if (err)
+			return err;
 	}
 
 	/*
@@ -524,21 +547,10 @@ int luo_session_retrieve(const char *name, struct file **filep)
 	return err;
 }
 
-int __init luo_session_setup_outgoing(u64 *sessions_pa)
+void __init luo_session_setup_outgoing(u64 *sessions_pa)
 {
-	struct luo_session_header_ser *header_ser;
-
-	header_ser = kho_alloc_preserve(LUO_SESSION_PGCNT << PAGE_SHIFT);
-	if (IS_ERR(header_ser))
-		return PTR_ERR(header_ser);
-
-	*sessions_pa = virt_to_phys(header_ser);
-
-	luo_session_global.outgoing.header_ser = header_ser;
-	luo_session_global.outgoing.ser = (void *)(header_ser + 1);
+	luo_session_global.outgoing.sessions_pa = sessions_pa;
 	luo_session_global.outgoing.active = true;
-
-	return 0;
 }
 
 int __init luo_session_setup_incoming(u64 sessions_pa)
@@ -644,6 +656,8 @@ int luo_session_serialize(void)
 
 	down_write(&luo_session_serialize_rwsem);
 	down_write(&sh->rwsem);
+	*sh->sessions_pa = 0;
+
 	list_for_each_entry(session, &sh->list, list) {
 		err = luo_session_freeze_one(session, &sh->ser[i]);
 		if (err)
@@ -653,7 +667,11 @@ int luo_session_serialize(void)
 			sizeof(sh->ser[i].name));
 		i++;
 	}
-	sh->header_ser->count = sh->count;
+
+	if (sh->header_ser && sh->count > 0) {
+		sh->header_ser->count = sh->count;
+		*sh->sessions_pa = virt_to_phys(sh->header_ser);
+	}
 	up_write(&sh->rwsem);
 
 	return 0;
-- 
2.53.0


