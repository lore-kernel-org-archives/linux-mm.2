Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FAC2CD6E56
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5399B6B04C3; Mon,  1 Jun 2026 23:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510886B04C5; Mon,  1 Jun 2026 23:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4270D6B04C6; Mon,  1 Jun 2026 23:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DD6E6B04C3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:17:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EEC561C1DB6
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:32 +0000 (UTC)
X-FDA: 84833512344.30.BABB19A
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 297AB1C000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jRZKNgjd;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780370251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QdKgJAMVKXqPuW+WtYwvlJP92RZZBzScgK8DeOU2nzc=;
	b=TtKE3uwrwUr7XGmZX4GrjN3kYfrjatOjdm6+ZaXoeVdQUb5nmUq5BtDznVLHKu1kifCSXQ
	M0b8JZfyeP3DE8/w6c8i6233lduSBm3uHqLaE/AS/HNKY0KyPZ3b7R+4oH3YXygrOVVeRI
	fWOuqBRrUXGyEUZC5kUsPyYRei44TSw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jRZKNgjd;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780370251;
	b=UWKtzm/8HEwx+J91J1QeYpYEkRQ9y1rRz06DtOZkw3nz+zWNgaYWVmFQxdcEl7UShzd/ce
	ibWGNge4CKfkAU4N7NaMFebx7NXkDmiOhIHhjk4tDDnM25cbuH5G+pio0fA1dH/nbZsGqH
	XEzKs9xw+P30kdfrf4Bk8U19JhCD2iE=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5175cb5946dso9301041cf.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 20:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780370250; x=1780975050; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QdKgJAMVKXqPuW+WtYwvlJP92RZZBzScgK8DeOU2nzc=;
        b=jRZKNgjdqo2wYqV6UfF8ED4L5QVy4qPwxMeMD2ZVMtCsu1gqhKSWmqN8L8sIfNX9NZ
         VNHItga7j3J2sSCZXW1YsnbEQqQ1/iVPnJ5peyBebI2svzCFCAUhqvyE0Z5EsHeUiScz
         eZviTiFnBPRKOvqBZYTwMjatZgsUcKj4r9nah2pwpl3H3MZa7oMb03HR8d4BuRZzjovI
         dFdbujRb2goX54zpjbHy3vt+jTxm4Shgnk6kTlF97S8m6Og6IBug5V+KL5K8NXojAkCl
         JdgRhMn+sZ/cQONxOm3sLgcoqCYfc8tZiuRRnxj6KoKNZCUNOfWk4eeDZC70mCnG8NV3
         f9Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780370250; x=1780975050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QdKgJAMVKXqPuW+WtYwvlJP92RZZBzScgK8DeOU2nzc=;
        b=HPtBpLJaT2lcmZphR/pGNYszOmXGxQyC20PE1C078pZ+on1zsAgw7tB0ML0UGC/KJb
         Ud9gztFxHFNCXXWpQRGrgMh2TWd2lcXuvn568hsm7mEJt/jc3WY9Hgt0MFfk3ufUYWZH
         omrEt8JgXktjQ7knchTmwc26oprqO/YzdQ6n4CeQb42PFwNfSRmEIT3vGsSxYDFdPO6H
         xjavBUZVxdhJ+ecL2BRZRO9FJgfajamjE8UUtyq7ZNjUMgLXKbia7npvyczEG/Hg05dR
         AaTfnGSJUoKMV5/HkZptw3J0AqK9Mta7qDnDhdNPzk6bOeQold1d7ugw6oC9H5Mm19qX
         945A==
X-Forwarded-Encrypted: i=1; AFNElJ8KkyJjcP4LIPL1Dny4rmzBJ7DRkiXQaf88NWhGvM7/+0Kwogn+Py/G7LZyWCdL8bynqqQBQRvNVg==@kvack.org
X-Gm-Message-State: AOJu0YxH3+AXdZAKz+X2b+pJwaemUIs6AVH+c6FEfYCFdLCQJn5YgDOI
	cjDgM9Mic2fxDYq/1zpCLiNLdTG0P9pIITjmK9DDUEUZ9cvQ+TMYqZzytmzRxIILutk=
X-Gm-Gg: Acq92OFsqGk78dDqfBZW4gDsEqOoKcBm3M0yoAACWB4iQ8IRhuVOV+EGBU4C0OP8Ar5
	cODxc1GsWqmSzTnIYgr6MC1JZyr4FNzppM7tdzel72Y9nAcEsf76C0Gujw8cMP8c3ipxnAxAEvM
	bFtPW7qqrrfl6I/w5QTCAxPQya508iYDwPIXb1vMclNJrVaoHhL8cI7LZ1v+I2fgJeXI5w0WwwU
	PL1EbMC0PSLPxOLMWJssEsvVwBu5LzEGsUeYddCAmowMuzNRyqsMrkb3iMnrksxJ/3EwIFvSJMX
	+H/96r7EaUDJuJvGStnc8JUrAroxeoqRcXPwIZ2JoEnbk5znkYbaG3JYUP1lZKySdRcvsudRHOy
	bXmQEm/lWuT32WjatRRBCRnTQz5Cbwjh5AvR8CLbTyfE8+Jmx9l3Kad6f+tIURf7sCO2y9odlFG
	Tj8l4TILukfufAk+jtwziRL0CJ3OJ/9OQ5/57onH5OLezQuP7mO5Khl/fJ+WiO5DP/RKKsD7DQ
X-Received: by 2002:a05:622a:a6c2:b0:516:dcbd:aaae with SMTP id d75a77b69052e-5173a89dda5mr159389971cf.52.1780370250181;
        Mon, 01 Jun 2026 20:17:30 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51741b29745sm71219081cf.8.2026.06.01.20.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 20:17:29 -0700 (PDT)
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
Subject: [PATCH v5 08/13] liveupdate: defer session block allocation and PA setting
Date: Tue,  2 Jun 2026 03:17:12 +0000
Message-ID: <20260602031717.197696-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260602031717.197696-1-pasha.tatashin@soleen.com>
References: <20260602031717.197696-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 297AB1C000A
X-Stat-Signature: ed468fq413riwe4ocurwfycnix9yqtjh
X-HE-Tag: 1780370250-631288
X-HE-Meta: U2FsdGVkX18GgEKkeCd1vSMuOXflMbeI87JJWTZkd3lZ5yWKqpg2OJtblCCOuzbc0SjbpZ5k+2m0aAkaqi66ORPOkzugU68KIantae5opipXPa40P5cjcl0g58c/zZXsiivmBW2RkORgKvC7avNqVQYTL23fb1TPzgHA8R3jesrQ2XZBApsf5fEGNkVGuyZ2zwHR2ODBnA1L0BMy94lxme6LIQJAFzPLNRhcPT2FB2r2W66abBoPw4I8ZWPbEqbZmsUABbzgiGRH4T4rZGZl/X4ge2umS63fNUm9+7f8lqyEwMJepMjYzNbG3ex52a+6xRpxlFT4Tl9+EVfx0D2DMVuitE5D/7jDQMYS2Co1fz5BxjmL/m+RZKuxRHKwnnZ1pYydMy/vV6VEK8ccXG1HvgKXJFx4Py9DrjCqu/6LFbj01SHJyF/m/im+tWhHLUXQMm8gjDEkEPosyQRQvHyVEef4sO0JChkEmanxFia7GFweiqypkSfNaLerha1nSxm9hRnazYxVlCqMrif1A3/pvYJMklhwgiwow5MVyGR86xJbCRrCIMVA31UBZ5pdtlWjtau8HD2zVxj6Lkcgo8EC3LoTguzovvyakVUq6SbzPE0XCe5F+E4eqSttR54nvFX65GPqtQgdFsrXAJcu/fqOYBSt+9yulAgLvGrDiN4TsEpNDysZON4hGSpmNF97Jf63gR+/61sk4d2kome0D3nUHC2U1mH4Vwl/xyS1Vyz6hUmfe01QwRn/zNWWt0UkNUO/mEru3C0Av4FQA/Fdc86fAfJE/9woRZdTE/MOKkerknQlxqHmVqF7cVBX6V3TTNu2Z84E00LSb+KvIs+ZpdZkUQ4Wuf2PI/teZCHKr7FFToCJIKCZMRDtNtlgXaBn5hqtKB+m/GAm6YNXf9ztP1kCg12/p1BqoQM4JeuovZV/Pe2To9xBlOnaH8jUaREAaCsK9aYx5A2tcFWPnzY62JC
 F6CQspuJ
 2O5JOGCHz/PN4BAEjMj+d4K8ASt0WwXf5U21iDFvCl/sIV4iSN/NgcokTfC0OZY2BylG/3cNflGtC4DXGbQdQaii9oWtdhx69n8vpSGKDzgPIXX9KNh+0rMA0OanpHf7+neJIwsaFrj2ONg3o3hf5mr616PTLxf6NtDwyqHXdlbKemmiYtVxa5jgmXkGExc1UlZuYLLBJ92Pe2QaXZfgeK7hiqjfy0yQ/kzJi+GQvDvDTREEPVtMS8yrGaqpaEvaEPNTcSWqFdfs2upiG1pI+R6EDIivqsALArDz960lrbtaz66la8hZWDzzo4UqNN67N+/M+
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
 include/linux/kho_block.h        | 22 +++++++++++
 kernel/liveupdate/luo_core.c     |  4 +-
 kernel/liveupdate/luo_internal.h |  2 +-
 kernel/liveupdate/luo_session.c  | 68 ++++++++++++++++++++------------
 4 files changed, 67 insertions(+), 29 deletions(-)

diff --git a/include/linux/kho_block.h b/include/linux/kho_block.h
index 505bf78409f2..0a8cda2cbfb5 100644
--- a/include/linux/kho_block.h
+++ b/include/linux/kho_block.h
@@ -70,6 +70,28 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa);
 void kho_block_set_destroy(struct kho_block_set *bs);
 void kho_block_set_clear(struct kho_block_set *bs);
 
+/**
+ * kho_block_set_head_pa - Get the physical address of the first block header.
+ * @bs: The block set.
+ *
+ * Return: The physical address of the first block header, or 0 if empty.
+ */
+static inline u64 kho_block_set_head_pa(struct kho_block_set *bs)
+{
+	return bs->head_pa;
+}
+
+/**
+ * kho_block_set_is_empty - Check if the block set has no allocated blocks.
+ * @bs: The block set.
+ *
+ * Return: True if there are no blocks in the set, false otherwise.
+ */
+static inline bool kho_block_set_is_empty(struct kho_block_set *bs)
+{
+	return list_empty(&bs->blocks);
+}
+
 void kho_block_it_init(struct kho_block_it *it, struct kho_block_set *bs);
 void *kho_block_it_reserve_entry(struct kho_block_it *it);
 void *kho_block_it_read_entry(struct kho_block_it *it);
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
index 9f72a8b0a9a8..43342916d314 100644
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
@@ -522,21 +545,10 @@ int luo_session_retrieve(const char *name, struct file **filep)
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
@@ -642,6 +654,8 @@ int luo_session_serialize(void)
 
 	down_write(&luo_session_serialize_rwsem);
 	down_write(&sh->rwsem);
+	*sh->sessions_pa = 0;
+
 	list_for_each_entry(session, &sh->list, list) {
 		err = luo_session_freeze_one(session, &sh->ser[i]);
 		if (err)
@@ -651,7 +665,11 @@ int luo_session_serialize(void)
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


