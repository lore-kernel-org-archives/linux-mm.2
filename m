Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22C6CCD5BD1
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:21:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0568C6B0098; Thu, 28 May 2026 23:21:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFFEC6B0099; Thu, 28 May 2026 23:21:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10616B009B; Thu, 28 May 2026 23:21:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D22226B0098
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:21:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97C761A10FB
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:18 +0000 (UTC)
X-FDA: 84819006636.19.366AAAD
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id C763B160005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="H2QK/IQ2";
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780024876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/lzT/uKNjiuJAcCs6ljq32s6d+IXBzBHeWWiRI2fHMI=;
	b=AS9oyUFCq7Cu4qu6NcSTGP2M86yXsNKFismyTgiZMBO+LGB/R7pzQ6dU+fj9vbs9AcF55i
	OfW2z9HfRuiQrz0cFIZBE6I+Iejm4+afZ9M7O/2RGsgbADyvESS63HRp7+7w2ZD7Dk3dcD
	y+fP4qwgCXc2RqaZ5Ug9ft5e/4LfRlY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="H2QK/IQ2";
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780024876; a=rsa-sha256;
	cv=none;
	b=xQpbwaAobKm3UBA/HeFbH1qEssLoZjx62S3Uh0z/MN+6qC5WD0QhDhDhOqFveLR1ll3VWX
	Z6Nq4D4WFIvkvw2npaytKXByptbt2OUx8Sw6iZYtVBjbrogMIr0hZgqJQ3iuMtujevoWoP
	8cbOF9RshjtEubXOtkPssROP9V0sVwI=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8cce22e029cso6209346d6.0
        for <linux-mm@kvack.org>; Thu, 28 May 2026 20:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780024876; x=1780629676; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/lzT/uKNjiuJAcCs6ljq32s6d+IXBzBHeWWiRI2fHMI=;
        b=H2QK/IQ2F7xQFgXzZ4S9E27OxeeuYPceXqXNgkjSAELmQwJZqpvqEHFAjU/S4V47R+
         SyqvnidxDSRd0wOraCeCV6XQsomPgs5RFLGJnMqysPh91BqsCzlwcYNOjb0m7TfjqP5b
         cBKco+no647uhzpVkPYvvMgth2rW3bvSJnbEieVKssD5VOwo6aDekpF6c0o48BPOPEpL
         Qhi1EE8CLRwO96oQ0OO+3xTru7RR0HatoMJ4IaHgqR3DhHFtO7l/67YUVtfFaD/POl6e
         J36RGCqZuq2cZ5cmor7ggAheTME5aBxYWDng7zHz/NKTYTdhMtKNyG42vKDiX3EkbF/l
         CIuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780024876; x=1780629676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/lzT/uKNjiuJAcCs6ljq32s6d+IXBzBHeWWiRI2fHMI=;
        b=Axc0nEZbcxgwfI3cLs5xgBw4PR6vD9eOldEP8t7FUG9NMU2TqtTnqXqw//l6j61c3B
         IPjYo/FOHz3KD2qJIqOC+5wgYlZmKl/XJyxMlrJ1kWVGNvzCih35ABTJmONsCmO+1/m4
         fJiU5hThaPGzwR7EBG6enarWnlywMvpTfrSEhJauCZYEE80Wcjk6CQI4ogCFieRUDFFr
         mpYwEmbqq9AzedifV3pRF+WOmv2/N0Uv8iouoB+3nJ9CgLavT9a41RgZD4FNh8zcx6GD
         Vv5CgYS5l5LCgUq+LxYjISETxbqkN1XxPs51dM7MmZtHv+eQJ5ZYb2bVCLKuIYtK0C+q
         Xg6A==
X-Forwarded-Encrypted: i=1; AFNElJ/Rtdx8LE5v+vinT6y9ZKnvXPbpxNmzaDXwnE9BJxLdSezDwPCw9/5wSyPzoTht9++XlgPMIbbjZw==@kvack.org
X-Gm-Message-State: AOJu0YyEUYlgh8hsSeKqC6KF2BG5RD+enTW8B02xQiI4LUHo1b6WzCFg
	VT3KmPgSnDmPxibhr1bgB7k2RJY3n3lvr1nUhqciNFEXo7xTV6P2eBFGzevoZcFzEJw=
X-Gm-Gg: Acq92OEZF/EvhnG7k1FGSufaeooJbNcG6YwHdKrO4uSuq0a1aIFoWHFwvEsczaGh3Rf
	Kt0tL407HE7UoOwqOtnfI65hbUQ3Ucpa7Ax6WENVLA3Mm5A7fUa/0cMoU38TtDEf5VGUaJ73wnj
	d0O6uF2CEUkkBqcTfWVUZhtqi+sb9jkKIfFVBaqpMi5At4rNc71M8GPdhYfNi/a3YbuxBfLYdzh
	7QWoGi37VU2hgt18fhsAyx2NILcxk913ogqLd3zaPdaGr1M+MrM4LuHGvPnPILauSiVMrWvvJnK
	1Nea+lNZ3Ty1cZ/HQzieyfEjyGKcFqGCnfKR9smQAYzQThqWLEGzhIAL7WWY4DBla8MuPVtmad0
	kpWpc4ux1yClZYhxs54wIG278ua5a3UQQBSRs/QGxJW2p14THBlppAjUpwlfUFoXgl2UqPs4sEI
	B2i1ENsyU6rKcuGjXUaunZHzSSeSefYF3+Fvy4VVQyuDG4XaFhFiB5CovMgJuH1Q==
X-Received: by 2002:a05:6214:33c2:b0:8cb:d479:a103 with SMTP id 6a1803df08f44-8cce621c869mr14316046d6.20.1780024875958;
        Thu, 28 May 2026 20:21:15 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea26d286sm1179476d6.48.2026.05.28.20.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 20:21:15 -0700 (PDT)
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
Subject: [PATCH v3 06/11] liveupdate: defer session block allocation and PA setting
Date: Fri, 29 May 2026 03:21:01 +0000
Message-ID: <20260529032106.1505796-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
References: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C763B160005
X-Stat-Signature: pekde88dx1h31r69ny7hp9fibynf6r5f
X-HE-Tag: 1780024876-956855
X-HE-Meta: U2FsdGVkX193BqSLtxfY9zKpNIRZWezr/DjbV70I+UTw+blpOr7N1CDQ5B+8ntVPXynEDTmk5RkKoJ97QfKA0SB8XmhCSOO1Vm6Ie5CpVhRsWZIm+Pk/U/MZVilhPkO3BltPoyXxHjOLfqC7tQKhZGIw+wp2PfE4kTs41ulfEg+9HIUPCgliY+ovtqYeoVEmy1jkGnK7HIbAtiBSfQ/NxOkNUkSLaGsqELQEKVXdy3w9LlFKky8UzOv8JNI4eFuoR1w3SJzaIcXaaWJm+LaHgOnkFN6WGGVEOWUkgztFsyB8KKo/j3HXu9UzE+bREaVhb2qRNHK4yjPXcgCP617oEyFQDZu+PQxTAOJ7EctWqlTd7N0g80CXuhU7xuSINF8b5SXwQ0X2OqTusaUTjxDud5QxxlE2pcBpcY5Wkdwkm6au8uOIJz0ORtcg0F0blkrda1QX10qhJ6n50EKbz+R1KCSmt59zpgzeekEUJ71zunr44M45Xc4V+59DNeFZDO540swT+b9568s+Gyv+oqFM1BAQIZ2NPS/GJWcPI6m3D6jOwE2xZ3U5u9teyntFA/+jt6xjUWsDfgm9F4tSosTteRob7BjAijJoVOTNm8j8527VfylKzwyyXXcybcorHmV2e6wGhpXBB2U9BEMn9r5svU4IEzo81icPCIRaCHXvPcoigspQqPovwEjXdCWHELBLYbUPBqMncTIGmo2b4zQMga7c/rBs03cDp0kpf3+WdQcLSNgZb3TcSzWCKPyv9f9U0BMAJxAt9nA1GTn0xozIY9n3NP/XE6UhrXPI3MBA70Gjtr+u0+fCNCagILB3851TvSyOAtM0ywHyLScBbTO1Y6W/6Y0vtZyhE031lOG3g1DPivE+uqdy3NJYCs/53A9UeSKFZ13zsHZwfhfXbtf1mD8oUQKdifpWzA3yBoirtttJbqcdME9jybTlnsY7VbUvkcZrbHcyr4Bg8mtJUeT
 uwuAIbr5
 wT1e96c61n/n7Ln/sjybUWbg4DRvkY/4khZTFjv/5rKZdRCSCMQIa4g1M5MyRFXMMxhklYKp4ptI8VERxQuecsEBPkFUhs8pxZNhGGYgnfAeSm4l6iP+P8HXO9qGw30xJWrBvz13/rt9SubaHqPfRaTsbDdgPBvA/jHXBvusj1TAJcuU6BAM5jiuIcrkYlYF0iMLiqan6H35MWA20yTEe1Tz3zsfVL1hhRP7Plzkk6LS4qH8rBJgDzNHihfTFklj2Z2zt5cIUlxn/c+0R7gPDlZHNG7Vw0CowixK64RTcb/gOQmT7aZLDvXrV2u0Ge2HalDUt9iJ42Gp87cKyjK7aLs1Ix6uc/ZwZSK6EJvH6N/iWbrmJyvqHbiLOaRWXtOuYko73S5ebfKkcUHSUk/vPi5hoHtGVFWyITRZC9BswrPbS8oGmRxDDryY0iA==
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
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_core.c     |  4 +-
 kernel/liveupdate/luo_internal.h |  2 +-
 kernel/liveupdate/luo_session.c  | 68 ++++++++++++++++++++------------
 3 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 5e12c8f8669b..92f8c53c7a73 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -157,9 +157,7 @@ static int __init luo_state_setup(void)
 	strscpy(luo_ser->compatible, LUO_ABI_COMPATIBLE, sizeof(luo_ser->compatible));
 	luo_ser->liveupdate_num = luo_global.liveupdate_num + 1;
 
-	err = luo_session_setup_outgoing(&luo_ser->sessions_pa);
-	if (err)
-		goto exit_free_luo_ser;
+	luo_session_setup_outgoing(&luo_ser->sessions_pa);
 
 	err = luo_flb_setup_outgoing(&luo_ser->flbs_pa);
 	if (err)
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 9bf26c5b1495..28ebb4f3000b 100644
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
index 5c092c71797e..ec72f16185f3 100644
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
@@ -495,21 +518,10 @@ int luo_session_retrieve(const char *name, struct file **filep)
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
@@ -611,6 +623,8 @@ int luo_session_serialize(void)
 
 	down_write(&luo_session_serialize_rwsem);
 	down_write(&sh->rwsem);
+	*sh->sessions_pa = 0;
+
 	list_for_each_entry(session, &sh->list, list) {
 		err = luo_session_freeze_one(session, &sh->ser[i]);
 		if (err)
@@ -620,7 +634,11 @@ int luo_session_serialize(void)
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


