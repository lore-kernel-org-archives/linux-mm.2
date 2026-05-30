Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5C47CD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 22:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44FAC6B00BA; Sat, 30 May 2026 18:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3162B6B00BC; Sat, 30 May 2026 18:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205256B00BD; Sat, 30 May 2026 18:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C9C76B00BA
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:20:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7355161AFC
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:20:00 +0000 (UTC)
X-FDA: 84825504960.26.16DFEC7
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 166D5A000F
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:19:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UNXiq8Wg;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780179599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ssXPv2DRhDSGHaylMjR7rg2Io0bTsFx1rhCfXPl0Sk=;
	b=mC+pKMnuFEG/YRjAtc938rrccdAGcv67OVGL82u1hECIsFUMCough/BdHu30xsOd66ElA4
	W5R51i2w73VxhcHvMbihwsg451ueWTR6UwAIj3tpjrjHAp8Sm2txE1H1lACydsU/YuZO7G
	4k+Clq9/1qgBywDzKhp9xKs4h7NuVsY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UNXiq8Wg;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780179599; a=rsa-sha256;
	cv=none;
	b=0F3wMuvbb8nYWBnzoBI5mj3wofblui7bZiwf7lEB0Co3P++1Fo64OK0R6qcrqYlYXz8vU2
	195sML0IE68asmm+IdKu4avOvqrxv/rw1tg9uLusQpwABm/2HWZyWjpf9IPrStlaSvcZXX
	iRGk1WAhm/2bkzXkqOXxTZ1mc+dD9aQ=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-915336b83adso188625185a.2
        for <linux-mm@kvack.org>; Sat, 30 May 2026 15:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780179598; x=1780784398; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/ssXPv2DRhDSGHaylMjR7rg2Io0bTsFx1rhCfXPl0Sk=;
        b=UNXiq8Wgp+wqcjxg0Pk255qaI6zgmKkbZexHYsxMC+KGpYTZpyuBTCWy+mcoVIYfj5
         +V63pLLA4ddokkwHflVw6A4caQq8vNB0I06EGoIGNYr9QLBUAMUC83GUmA6qx9/igoL7
         nPT+9kilYdrLYRloTmJKmT5iL5DUyzXbQ0LnO6qdBjUo0sFNuLcukuK5xQFpBKCQkdYh
         DFUcyTTd6te/eZmHNXtPUgJhdrwH5OvCx/aRNe6iyWtk9+fXDmzavfyNMGp2nYcMAP0+
         TwYjdyMrJ8Sw11mr35v/P2IGhqCOZKueGUT6fqZ+uKWeLggciBq8W45lAtyeljCXmsQV
         TFeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780179598; x=1780784398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/ssXPv2DRhDSGHaylMjR7rg2Io0bTsFx1rhCfXPl0Sk=;
        b=RKt9NYlVhHVQ+K+f3Ec4cPhthzLsxFzrfP2+oq58vTCuBciKeIdkuh1kcIsbTECwCU
         5AVaZB6V1bmDoZq89rD7UXDcRXThxUDVfZYZ43pgu8+K9WUGSj8nbff4+g3qY4gJVwc7
         VKNBeR95CUMeA5PbLVm0ib1KW+i7dAf54RxK4uKDmq3dkYt6k6A5FIkmjrAuIaeLjU/Q
         Agiaf0yHAtEtWFbyKai3+XSwIsCYO0yvQSIfbfjuDk87YT784IO0jO25JX9qWjvr1XPd
         ISB1rxfW0V5QjMFio0hHcN0gg3/ySi5LXkeL88Vdpkclt2N2QMIKKQdeuilerI26JlZX
         cXFw==
X-Forwarded-Encrypted: i=1; AFNElJ84F4aCqpyZir4zqiiR8igS62rs5K+y/MhrDMcQyBQttSoyBMZ4NFTwmBSESQGaHkBuqjCQK2iASg==@kvack.org
X-Gm-Message-State: AOJu0YyFmlX247eWXmRqjjmt3lcEHblb7IMh74iSJ2DnZyR6/DL127Eh
	G2dlBouYbALT0XdZMFxPQHxPFeZih7fdvPPS2Bag17eLJqHT7rhcPSHHm1uWrfwVueo=
X-Gm-Gg: Acq92OH1Ij+bsp7HqNqstpyMEyTof949SKgBtlEAlb+Twfscd3B8aT54A0gO/v66g1o
	IOXok0udeaqa6gy/O/qSkbBc7sbnFEWFesDCTi8pRCvEnNi9PdKAwl4gGwemJi/w+zTgZz//t9n
	ztVcPtP8RYEMNrGRV/XnOTTwQGptZSbFSQbTSyeEpYzr3aj/fJ5oG9Hxc6XKJrfC1Z506FcS1W7
	qWlxzGVT0Qq70FOorG+T1H+rb356IYu6m0sUWsIQ4TB88JnKZRCeN2NyYLO0HFwTzDanN58PUAq
	9h+Mglk028RrW8QdJHWb/2YLRgBhDEy9hr8SW/7ZTUpElrX9wy8GPbPgEjgD59MlHL/fkR3snNx
	ntTrsR7a4FODmNWvp6HTgMp88aN8qR8P2ALGT7gY7PYD89xRqtV4mmQSG2e7f4nWdHh4N73nkG+
	Wtu6+tAqaFTxQuKlFPpcIBchoZRr9W3jfMZdKYGDxn5/q3qfb2IFpOY7MJA2Be0Q==
X-Received: by 2002:a05:620a:a19c:10b0:914:c01e:6f92 with SMTP id af79cd13be357-9153d9709f3mr614876885a.18.1780179598221;
        Sat, 30 May 2026 15:19:58 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915324868a0sm651790085a.18.2026.05.30.15.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 15:19:57 -0700 (PDT)
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
Subject: [PATCH v4 08/13] liveupdate: defer session block allocation and PA setting
Date: Sat, 30 May 2026 22:19:33 +0000
Message-ID: <20260530221938.115978-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530221938.115978-1-pasha.tatashin@soleen.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mszt9exesade93pzaewq1dijem3z8bgx
X-Rspamd-Queue-Id: 166D5A000F
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780179598-503642
X-HE-Meta: U2FsdGVkX1+prAuC1TwWki0E6uQttmYcI8dGcdprwfOBuODOQyB7+oJoRYZHmzY4waMSEtJygxCyi4mI8TZmMUpO7O2z6vTsxM3xB4YkkXk1KuIoGHsiwHAS/YPPrX46COK1D3joi5dcnG0SZsd+/C4tIN97t6xXmeiKidML4IVQbk53QMZbDM8OsKvBUFxyirDdRqIPpidjfzQem+Rf1VrIKQzVgHD1l1qmy5ZetkGa5slPsdOyRU/CfTS9+bwbWpugCk/juMWykXnbXFinYH/69Jo1muIvgg+lgBAVtSS68sUym0Yc1R1HHP8vN5koEYorD9YTsVhooYHWQroTjH3LjtMLz2RZfYDDT9yTMVyPsEMHDvEe5mRluv/XizX5oezscAZ+Ig1l7UT8KYq2tcWjIrXITgXBCqx31QPWewhfXIsR9flvY1xqEkZOJ2NEHjwcCbco/j0VQxSJ5S3NpvOV5Rs5ZAXlcOMZKljnbtwLS70df4ABMKtgt11UAhvr7AZ9QHgB1nlqaL4PIRmWMqNvxY5eA8dDA6dXsVXB/ePyga6fLK2XxggNwuJKtTnhZPuslBwIPW+lsMNt1R8VkYW7aYD42MB6wliCTODxGrfcvhhCbsxaTMdc9Wq4zK77sO2ow+vLiC6C2+2gXEkKHSQtp/xcHeSJT3N5OA7sUB9b0vnl6t347jCE02vvWBs5tZZN/JWfkFLdwaP25Vvh8jG9okf2hP4rpe97miSgwTD+zXDL2VWLR5qr5inAVZ0gjEwWeiW5YeRtEroGi4haODv4vJXSgQUL3db5aqbkkpwS26dIRT84058AqI7EJV5xG2xX0lyAbySMxbbMFR/qEUw8an70BtbCyIiTOj1aQcZqveVfpapyT+HW7Mg09Uh+ebFsrN2W2V64nach+MBFcGGkG4p9DtywaW+0kYg7PQGATfP7xCBsJIk88oP9MTmon//V/HymsN/Tcj65YBG
 BdBVbloZ
 TG9qVmxMMI392blbnc5IQO++4NdCZTd250kCjWdlxIUpUWLFv+VlSQ/ccXnvMdds1pE8i2Nmq0M0QW34aE4o9rNkLnIihi15XR+hukYpCa1CB7Z3t6CI/iKDqc6yFOohl3LgH1Oczzrq1DEtumSa2EEwQ2EB6wkBV54FbGS4SRY26lzMW1wwlQRV3cBznIglrdVKRZ35H6+thQ6MAgT8bedsIPxKP4mks22psvWZE5BTH7hpNEGnt44W47+VrzX+KPTjdNpEOHs6lCN+ESR1ebwV9yfGkyymVVgJH6gSm903OhoRuOt6U4U3tVumAVD+xy91AdNhrCkQhiWiNURkx5rrxf06rVj2jzCSQ
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
index e261a03a1b47..fef7fc6765e3 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -161,9 +161,7 @@ static int __init luo_state_setup(void)
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
index b728fd9e3ed2..0548d48bb014 100644
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
@@ -494,21 +517,10 @@ int luo_session_retrieve(const char *name, struct file **filep)
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
@@ -610,6 +622,8 @@ int luo_session_serialize(void)
 
 	down_write(&luo_session_serialize_rwsem);
 	down_write(&sh->rwsem);
+	*sh->sessions_pa = 0;
+
 	list_for_each_entry(session, &sh->list, list) {
 		err = luo_session_freeze_one(session, &sh->ser[i]);
 		if (err)
@@ -619,7 +633,11 @@ int luo_session_serialize(void)
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


