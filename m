Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DFF0CD6E6B
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B94E56B0098; Tue,  2 Jun 2026 23:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8D86B0099; Tue,  2 Jun 2026 23:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972416B009B; Tue,  2 Jun 2026 23:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87E666B0098
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:29:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4FF6A1C0427
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:18 +0000 (UTC)
X-FDA: 84837170796.30.B3E7BE7
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id 881B11A0003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Smrpp//L";
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780457356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QfziVgpqRfO53l/kiKYNLloUUY6f9C5CrjqJQDvl8iE=;
	b=uCaXVHRbww5I/yD3QwSpCcnRXL2CUTuq30Kf4oiCt5VTYGymfpkBs4ASHO9rkvpkfy7eHi
	PzdpEv2MPHFf5ZF+Kc81EPgH6J9OaTWSF+Xy6iff0Px6x2vOcQdMgprZsuXdhZKDIBBhJ6
	Q+ja2/QtoRrchK7Zej0cdN/S3mKbcgM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Smrpp//L";
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780457356;
	b=VT8W/aayHMdhJNIEHPOXKAZ0fVUqkfsVdfGUF8/T7hizpBo5uGAc7A7Nc09ZYR+5Fkb/IC
	x8nh8oD+fVo+7HGBq0BDVjww+/oRsYT8c4NQY5tB9oymsKSpF7cLt9htOYJR5yWAW6Wyht
	z2odkA/ZZBQxbk8DbJbjE+bdKlqNXfk=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5177945a22eso2875631cf.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 20:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780457356; x=1781062156; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QfziVgpqRfO53l/kiKYNLloUUY6f9C5CrjqJQDvl8iE=;
        b=Smrpp//LRQjvUV/BWZyrWm2DYrIsA4nYIqEB2zeJonj/oRkKCPT6+ia3pPdoVZEVBi
         A+u2T27N+B7kQHgTeo0+34QPfmSN16ZRhej1DaFl3NctSbPTJxNbq0XoQE+3XtUmnNcZ
         yTTfeGn8eMRsqESFxieHuevkzsZWWbxoQTlFuWvI6II59UXG9eHDNVHA51hrqNpYOEzO
         Pa2Z+EzNjVqRRtRTdrJXuGZ6hTiHkGnw3G3o6Ld1rU8iPuKqE8+Ob57dtnhHowJklvQd
         VkFaHKUhMJEzGenvw83GfjMx4zheAEPg4axNK3m7DLkQJqWXefV60vrda6C7QLlRrLO8
         kXgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780457356; x=1781062156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QfziVgpqRfO53l/kiKYNLloUUY6f9C5CrjqJQDvl8iE=;
        b=tFU4ZyslQlurwCl0dMAclhQwOIECwqoLXC35UyY8KVmuDmXyw9amS/GFbQBSfrPz4D
         xSigsExosYyWfBDIxVBsm6TmqRGDzsr1EO9eBv4cA1QSkYl+U8zqTV191elb7Sw58FSu
         1axZbQmPhNTgcMGDMxuB5VAxWlCce+YeXL/4I6m/nXpS0QVQFqFs0z4ECrMpJlJDPolP
         WbQFw8Hj8xC9ENfVNpsKp//0gKSLLoVCJUeC9/KnIhHKsrn/RkBy929JOLkOBg6HfdqT
         wQymleNvfispi0CFDF3NxNtALS8Hr1nyvNcQlbW/B1w1StZzWQHD7d26P8nwfz9xXypo
         Ykdg==
X-Forwarded-Encrypted: i=1; AFNElJ9roOXJedSTrQtAxc5gpzWdrKRfy7NyJ99nH5+5t/0VVvjG3SGsYrtyZ+Sct/xyUGmJ0qZsyvZVGw==@kvack.org
X-Gm-Message-State: AOJu0YykpqcNIcesQsrj2e6+vOJ8nZNcFEwjjGMI3SFm4SI9WWmTtjlh
	Y5JmNqWXmPk8w099TUTRE0yIlYDt1Fv0+WoiKB4blkyiERkm9OiPHQj1Z8IGo3FY3Rc=
X-Gm-Gg: Acq92OEI1h+J5zkTLoOOggbRbKjbAODOuuAAC6fT86wXmR4Q8N+wxrkQlaPys5cjS0W
	auxB0EVOnEMLBoR2fq8VVtGyBllRprtXhk/8C5Os3fjVrlqSWB6omea5hBRzHjyZpqIrYzrJpcO
	xUwUERQ5n98enJ4HBg/XBEVGd+4F9UysNcQRPJE2uzeHuBAqqs7Nk4bTTyr1i8vOj125qZYO2x4
	q8OPl7RgEgShouAfuniw85QjvCrgyQhQC5dHUabkR+UuEYQVGgrCyAy1Kw/I58g3TxFEnvu16d7
	amfCPFlSyMvhXPos0grHJTuGC26ZiJtskAZkli4x+THySgySO61P3QFdI7hgkqPNA4z3RczPhdh
	KDJm34Ba/6GB7846hnJdujEoEj+eBxeMmfQsZ/seglgn9no9raxtNQjGOlIL/bDJ/CJNSj+u9aT
	IurXWcOuSTg7EifBwiX5kfNe8P34KfjHvBWkKNGRgNXRU7xqgEQqUX0NHWj13O3Q==
X-Received: by 2002:a05:622a:1c19:b0:516:cfb9:2856 with SMTP id d75a77b69052e-51778683f95mr26668491cf.31.1780457355655;
        Tue, 02 Jun 2026 20:29:15 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd26b3b9sm9244566d6.45.2026.06.02.20.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 20:29:15 -0700 (PDT)
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
Subject: [PATCH v6 06/13] liveupdate: Extract luo_session_deserialize_one helper
Date: Wed,  3 Jun 2026 03:28:57 +0000
Message-ID: <20260603032905.344462-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603032905.344462-1-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 881B11A0003
X-Stat-Signature: dwishbuwyyubrghgy3z47zcqn565i7oz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780457356-274325
X-HE-Meta: U2FsdGVkX19G5Oav1qZ1AKEDdUmWiVeZIazckduyqShgG1EkNWdMtxLyMBQ7DUV6ELuZOux22Xe8aW3d6tbBV3NDooQhZkIX1cnHjgsR0EH7qmVye10SKaIMK5fmUUlCzz+vjwReIDNXe1F9leK9ZNcnJyMgqxm7uMjXj7t8oGsk7iwojgcrdNwr3hPisXcvKodfnaY+mjnda0Hb23N8Em0qx8AMJnEk2ixX8LTAdJP/0q2q7xbUMySl51YzZqTcQdmWvSEI1vsnr8gf78mJNIrzZEEdHJY8A6fNN0T6ajsOq0+dJ1O7Apwai3plJUUrTBOAX98A/u0oz78FRIORrTz49hpd9Ho3HdJs+JYdO3mitUl9ZUmj/4qu7dXl7qedZYjINEjF9QxPN5b6YlkTZ/D7lyoAip4hnMd4oY7B+b5mxeYG12asBzyH6XlljuovnVqAM7wL1qzo6OkI2fYwfCYygo0L+kEVzwv91j6E/dfoF3+AuKUz70IfaGMgBCte9/9mIfqJ8x78RSBJS2E3EpPQfdsqpP+vYn3qIiGufK+/OYEJQSKMJk0M9pVb3MNaGvvcaXwVdpj+B9DwLr1buwY1OvO1jk1ALWb2tGy1mRqAp/8YMXvuxovI4dKDvRcBZzV+wbGy4idXlea6mMmjJUspzSvfKnX9759HXQoH2xRUjZRxlSnSZJIOkzdsr93hNsTnJeH7yVUPG8iW5VsMD0BUCRpRzkVMUMJbMZJ+6dPizYMWRGIs5S8x7lM69tU91FTKWpKKacfTEm+jBVv2wIsvk4u4/8NPrzKTWrQcsNabXQ030+h1qdv63J03SPBTs6Qd+Z3D1tgxPG5ZEsoi07DymDVhOupNDP4BklLtHDIGmIvsrjHd2wXlZx7Y9sD/uFMw/n4OS2i/QLg5qxd6djHyn4r7xNzvKNUMTZoe7w1QcBTV7qZyvQHn01siwcFnRXhbax06yzt7pM7H+zi
 qdyc+Fyg
 y16JN5c/ydfDKTbiUC50nT/a2WlXbfI6NXIzxnSb5f5GcL/ki1pn8LmEhKOVfMezaq/oicgZq44tRWEksQ8wrgjfS0kMKRKu4dCVjpKHOYD+rN7beaM4UkHRuc4N/rjf7oeVRlNpGkwW/tka3wAd0l51bgB5Pjs0Ydi5476FcBvSFkeCdLRGKxEkEZOBY2ylc/D4JdmcMlmffuj8j/5yjYDJ2/ghcHoJtPhYMOkYWVbdKL34RhL5pMKzsLgSbIhdsWjIoXlNJOhYnpKsG6haBsaVFrSiqltnh69R0XHFib8GkumbmtphDBXGO8TjpwK7btE6ofMZ4+sJlTDdCL4nRYg5QZ/NFq0aKeKMUIAHrl4rPQnH5Tx78q7DRuit4/63yw5eEf8t0Jpaf3eA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the logic for deserializing single entries for sessions into
separate helper functions. In preparation to a linked-block
serialization for sessions.

This is a pure code movement, no other changes intended.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_session.c | 63 +++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 85782c6f3d6c..1cd315e0f6de 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -555,6 +555,40 @@ int __init luo_session_setup_incoming(u64 sessions_pa)
 	return 0;
 }
 
+static int luo_session_deserialize_one(struct luo_session_header *sh,
+				       struct luo_session_ser *ser)
+{
+	struct luo_session *session;
+	int err;
+
+	session = luo_session_alloc(ser->name);
+	if (IS_ERR(session)) {
+		pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
+			(int)sizeof(ser->name), ser->name, session);
+		return PTR_ERR(session);
+	}
+
+	err = luo_session_insert(sh, session);
+	if (err) {
+		pr_warn("Failed to insert session [%s] %pe\n",
+			session->name, ERR_PTR(err));
+		luo_session_free(session);
+		return err;
+	}
+
+	scoped_guard(mutex, &session->mutex) {
+		err = luo_file_deserialize(&session->file_set,
+					   &ser->file_set_ser);
+	}
+	if (err) {
+		pr_warn("Failed to deserialize files for session [%s] %pe\n",
+			session->name, ERR_PTR(err));
+		return err;
+	}
+
+	return 0;
+}
+
 int luo_session_deserialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.incoming;
@@ -586,34 +620,9 @@ int luo_session_deserialize(void)
 	 * reliably reset devices and reclaim memory.
 	 */
 	for (int i = 0; i < sh->header_ser->count; i++) {
-		struct luo_session *session;
-
-		session = luo_session_alloc(sh->ser[i].name);
-		if (IS_ERR(session)) {
-			pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
-				(int)sizeof(sh->ser[i].name),
-				sh->ser[i].name, session);
-			err = PTR_ERR(session);
-			goto save_err;
-		}
-
-		err = luo_session_insert(sh, session);
-		if (err) {
-			pr_warn("Failed to insert session [%s] %pe\n",
-				session->name, ERR_PTR(err));
-			luo_session_free(session);
-			goto save_err;
-		}
-
-		scoped_guard(mutex, &session->mutex) {
-			err = luo_file_deserialize(&session->file_set,
-						   &sh->ser[i].file_set_ser);
-		}
-		if (err) {
-			pr_warn("Failed to deserialize files for session [%s] %pe\n",
-				session->name, ERR_PTR(err));
+		err = luo_session_deserialize_one(sh, &sh->ser[i]);
+		if (err)
 			goto save_err;
-		}
 	}
 
 	kho_restore_free(sh->header_ser);
-- 
2.53.0


