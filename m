Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD31BCD4F41
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 22:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F1A26B0093; Thu, 14 May 2026 18:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A37B6B0096; Thu, 14 May 2026 18:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0433F6B0098; Thu, 14 May 2026 18:26:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E22C76B0093
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:26:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C9278E3B4
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:42 +0000 (UTC)
X-FDA: 84767461044.24.DA09CBD
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id DBFCB80003
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QHsvHNJY;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778797600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eb8o2KCzs8bbwuZWDFPZ38APTKPTdJK2DFY1v5TRs6Q=;
	b=xGyQTp9cQpn4n8q37t1r09NpI289sMNUjux9wppwFeVyzz62+vF72nL7GBo5lTn5ZwQGQt
	lbIdVFgpiC6/GWtiTyI437NGoOVSFV7OOfk6pnRd7lZRQPAv74rbSc05XDqh/CPQhKxo0O
	HD8BUlBom35/axU652On6V74svA4U5g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QHsvHNJY;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778797600; a=rsa-sha256;
	cv=none;
	b=x8QrQrHyGs+7vtCpfR/vG6UcPQlzUF5BG3toPr/qiVz1S3hmn6W7XZHXXXQ3AUJzyQkosE
	Nmu6tQRLm6WBIIKNFYhSTjwRtOJO2FAD3zBlGtpo5qBN89N+s7GYyNFEkaeCpEaxZ/+pQf
	QoTqgsMbI/eQGP+S6sBAoe45hAf1IFQ=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50fb4a7d704so64170811cf.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 15:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778797600; x=1779402400; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eb8o2KCzs8bbwuZWDFPZ38APTKPTdJK2DFY1v5TRs6Q=;
        b=QHsvHNJY9GIxu8Rb0jmdH4LHGZm5SAHJl1rLWpPmupxoe+0ZG5m/3EGwUjvokC91GN
         MWbdYhbWrSsb/YnnwsIcPJ2wDovVX/s/eysi4c/csPUKGlyYcbPfqQCo2JFpOQ5/AFl5
         KFLiz2dYkqydA5r44uWfgFSnMVx0lG2mTPbK/1jzt79nVInHZarIi+N/dn95Rowkj/Sb
         t4UxvHTGwnMHPK+Nqa+XGspsP3JZEK0OgbSlPxKtpbdex5SuI64jMigstFFPYXp4JH+u
         9c2lm9fYcUKL4ssCVkVpQt2vqFDLMHoE/NzS998iU9UK1VwywjxzbHuXvWqetY4iMJO+
         ElUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778797600; x=1779402400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Eb8o2KCzs8bbwuZWDFPZ38APTKPTdJK2DFY1v5TRs6Q=;
        b=pON7HMzWIlhfz0dxg9doUfBFKCwMVjP0pMcHlhEukho6BWxaA65rcjLxsCr/uFJsMN
         YfhcPVSDwnrC9kXpnjJY4t3CIbyB5AmyXY3lgDXxy1YbF0Y5AmMwr4v+BpdPmrjAkOHZ
         +218cgaHT8EXbNodhwhDG+zaFGQL+FDfovayOwMZhuZ+/iAx7sAY2av5GhQWnf6fIvjP
         7eDZfdb7wGEPmSr0ZGOjRyqdFY6O25h/7EaMWH/9E2t2CL3bK8a2dNpBFWdUyaHbIIL9
         mm+RYQRfhNuMEtR1XhIsj+f5xb2bjI5gMDncDV9yBseKRBOH3zCbcYadjP8M748nATZS
         bK5w==
X-Forwarded-Encrypted: i=1; AFNElJ+UWwSup72Ik1Oc/tWJew7qYfATet4ufdzowEmO7c1xTCM5EK4JDa4y9kYQy+w+V8sZ9usMpwnJ4w==@kvack.org
X-Gm-Message-State: AOJu0YzmvMBujquef1oue/GT7FHfEVC+YUlxg2IwgqDSSZnWu+EgHnRI
	YIcGOQ8XIPbLf1k8+uVIbi5Vg6n7ULbegiLq+dINm0z77uZM61GBSpHu7iR1HJuhUXg=
X-Gm-Gg: Acq92OFX9QoyJ6LCC76dyagaE8zafo1gK7SMVcK+PRoplWrCQocn4bYw7wqlCmWf3Nd
	cG2sDcruaeFkgsrvWBoiMF6U/nvNMELWAYY/psm8OK9lpFNRvMsG/0XnWtGT8En/haRT4ZA8iXY
	Z96wzcL/vgFl/MbPsZemXs9bjpGpoLBwmjZkGM0iWEW28Sawor2L5jWBv9WKSHFR5SZ6HDEn77k
	X9nqYoKxlUarYsEwW/ABSghgj3L3UeSkNVsui3vhoJsXGRnXSd9vZ3ZQFq4fCV644DtKvDKP6uj
	JZYZcsv6kb92Pefgg1MLsUHFIGXNdXooWuUICNf36wCfvrVOJK2Gif5QjEtiAUBR7hR8/ItEnkK
	957LM6Rv5lzP3HsipcvYVvxqbsvUsUHIA8f9gV/N+llkrVJWRDzANGfuZXnlWaIPt5bDwiqjKuC
	oMdT0Dzj8y0KNtv0XPJl4Ijr4dKWTmzID/b+towmEGvYkuC35z3cw=
X-Received: by 2002:ac8:5cc5:0:b0:50e:601a:217f with SMTP id d75a77b69052e-5165a076dcamr19672381cf.25.1778797599975;
        Thu, 14 May 2026 15:26:39 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456ba92fsm28671901cf.9.2026.05.14.15.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 15:26:39 -0700 (PDT)
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
Subject: [PATCH v2 05/10] liveupdate: defer session block allocation and PA setting
Date: Thu, 14 May 2026 22:26:23 +0000
Message-ID: <20260514222628.931312-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260514222628.931312-1-pasha.tatashin@soleen.com>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ceoqisaifk9nzp145f3t5nrhnd7xyc7e
X-Rspamd-Queue-Id: DBFCB80003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778797600-778535
X-HE-Meta: U2FsdGVkX18L5zukHob31FNbZRqRItFz+zclw+eX7slQVbzRkib1jB7JPtFMzVzr7IauEo3ObD10tcq1+4eeRujCv+QjetmtHWU1fw+0PdMmzBXSzKgmm4LDtsjbLvmEPX4/eqhIo6kpkGlFRnwXD2Bn0JGY/2FLuKTR78kwklSSKGNlvuxGunFIDe7Ze2Jx9NNEU5sSwVa8KKQ6jvQ2jqcExF6jo4FtehirWn+RlwMqkKNSPzvAuLtMPK1/fQTIiJ8r4ogll1gwd/DpvaTc8OR8845Q2Pv3P17L/LofrhoImY3BPCm53YpDcafAs4NnjBfcQvRXAWU58gkDRqtlFsbSH1wubhqtOskqbu2xXoy9whfRD0RQh37HXVnuJMv24LIUY3lIiCQQpgfpz4IaR4obAvzntZraVFqw3lkFmEMl3PoOM3TnTdSMvCnDei7jfw4ISEXRWXWlZNwWvwi7cMru/waT/RlvWiW2r5ZiGe/7sbUJt8gTInUKU0VNiFqP7ZAxX/eh6p+Rj9VDHYwJ1C+2JJUKDqKgOhNpLV9N0krQO+CSnQlbSZ93PE0kd+mT2MCzYMo2QqoIBPDkJzPBUa0C6iYOtFLwyqb/buqvkuMfzDA4XrwKuaykDP0ucMxLiIP0RYdPwQDtBiqKQsJyHPWGLvWFraMCGb/mbJOTdIR1y23wU6fhLugP4Ij4jPnWvYExA43Pyg8bwBsZulp4pLAE2/8PyDyq090PkGtyuPcUMXZR4P5MsajD2hIrh73k5999vwAfLLCsjvbPj3KXZPHGD3/M8n1ZOx5zsru+l/lj81sE1Z11jJt9KoxnCyMKScecs0y+xsLkGMIadts2tYpwbzQElgrGwKzNMxKGlP21Dbb1uHalaMgvhJ27D3NJZstSe/V9XwzzRhUuz4eov6sNKTSeH23T5aoS6+LcMWa4MulkVaaS3BZvCErcjaBELlH7VJG8l88X6Ty4Mye
 UPuC5Z7F
 t8mYOmYguNrIFucp3ZlReRTAsC2tqrZw/E0JJu3HyhvkisfnG5QH4ZRcJDHD1bNnPMevMbr0kHTIbpqKEAHrhRohaLN9UO3GPXqDgjEuJYuM6QxgvrJCMtZSVYK97BDAP/vl5ybaWpgVIOZlCYrfaH9qFz6QqhBew3Kz3ZxdUScvwV3imuitL8VQHD5dYIpzomeD/S0W3vgDHu08fqIRtpKTZfuP+3EU9eaA2XEr5qbVzwvDFpvsnjdKDweJqjGqSm0lLOtcwEt5ioibfw7IA7TRP8fmGDylwJtuCaaaPovnLXQOeiuoCdMjbHc/byppGk6oeRVvIPtN5tVw=
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

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_core.c     |  4 +-
 kernel/liveupdate/luo_internal.h |  2 +-
 kernel/liveupdate/luo_session.c  | 68 ++++++++++++++++++++------------
 3 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 9bd649b22029..5dd7f1e7dddb 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -189,9 +189,7 @@ static int __init luo_fdt_setup(void)
 	if (err)
 		goto exit_free_luo_ser;
 
-	err = luo_session_setup_outgoing(&luo_ser->sessions_pa);
-	if (err)
-		goto exit_free_luo_ser;
+	luo_session_setup_outgoing(&luo_ser->sessions_pa);
 
 	err = luo_flb_setup_outgoing(&luo_ser->flbs_pa);
 	if (err)
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 04f31319ccdf..090078ad771c 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -126,7 +126,7 @@ extern struct rw_semaphore luo_register_rwlock;
 
 int luo_session_create(const char *name, struct file **filep);
 int luo_session_retrieve(const char *name, struct file **filep);
-int __init luo_session_setup_outgoing(u64 *sessions_pa);
+void __init luo_session_setup_outgoing(u64 *sessions_pa);
 int __init luo_session_setup_incoming(u64 sessions_pa);
 int luo_session_serialize(void);
 int luo_session_deserialize(void);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index c08733a328bc..339514e8122c 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -77,15 +77,16 @@
 
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
@@ -93,6 +94,7 @@ struct luo_session_header {
 	struct rw_semaphore rwsem;
 	struct luo_session_header_ser *header_ser;
 	struct luo_session_ser *ser;
+	u64 *sessions_pa;
 	bool active;
 };
 
@@ -140,10 +142,30 @@ static void luo_session_free(struct luo_session *session)
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
 
@@ -152,8 +174,9 @@ static int luo_session_insert(struct luo_session_header *sh,
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
@@ -458,21 +481,10 @@ int luo_session_retrieve(const char *name, struct file **filep)
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
@@ -573,6 +585,8 @@ int luo_session_serialize(void)
 	int err;
 
 	guard(rwsem_write)(&sh->rwsem);
+	*sh->sessions_pa = 0;
+
 	list_for_each_entry(session, &sh->list, list) {
 		err = luo_session_freeze_one(session, &sh->ser[i]);
 		if (err)
@@ -582,7 +596,11 @@ int luo_session_serialize(void)
 			sizeof(sh->ser[i].name));
 		i++;
 	}
-	sh->header_ser->count = sh->count;
+
+	if (sh->header_ser && sh->count > 0) {
+		sh->header_ser->count = sh->count;
+		*sh->sessions_pa = virt_to_phys(sh->header_ser);
+	}
 
 	return 0;
 
-- 
2.53.0


