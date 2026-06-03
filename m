Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B23A8CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230786B00AE; Wed,  3 Jun 2026 11:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E13D6B00B0; Wed,  3 Jun 2026 11:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D04F6B00B1; Wed,  3 Jun 2026 11:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC7656B00AE
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:45:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9387E1203D4
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:45:52 +0000 (UTC)
X-FDA: 84839026944.20.DCC72FE
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id CBDA0C000F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:45:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hmHuNwzR;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780501550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9xWUzUEP3GatCDCPhqDCyXoyiDq9Ol5847oPRS2f7E=;
	b=JEk8WLjoRBwPeMkS6JUYd/sn9Qc6wAsTZGy6omLMkvbVB1FVa80PFIUAo9IcHL/fTdpmko
	gCQ3CPUKxfeDSKxOJKzbmoOh2pXHeBa8Uw512naK94RS1HeNOvzpST+Ld8s+6R49A6pAjB
	OKdvOCiUmDUO8ctilrfOmcdVC3b11wI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=hmHuNwzR;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780501550;
	b=k0tpW158hkBZDAdGsRTpqllfmQQHlCDsVBXpFmjPk9v6odEpU+fuEilx16fXQzYxXcjsgk
	uOrN3NVt2qifck3ZCd2+vhw57R8KW2eRyWfai0mb7h+V30F3Zpc4UhPdytg7dLLK9IJcMV
	0F3zSeH2vIpT24jHFHcQkP19YRH1KN8=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-9156ceb55ffso260154385a.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780501550; x=1781106350; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C9xWUzUEP3GatCDCPhqDCyXoyiDq9Ol5847oPRS2f7E=;
        b=hmHuNwzRF8EHUD+n0CkB/tU2fBb8seRvCYL1YGRR40//9gnhARAFsQD1EWDh8M1/t/
         iwEQrmBTZhU+t5Uaml2LD047r28ww8t0AjU35X4xpKNMGXUMATWC97sca9g4D7yUgJQR
         AKL5ESGhD3c+FqGVVS8QKwwlm+ZHkfSinZqHezYcBo2x0+dAqIxyClfstXz5GXLD8Ifn
         bsftbVyHhqa62W+8d7aKSroZ92RQKOX7fLedfdxq7Dgr1dpBIvynUgvCOBbQ+aSWAzDT
         SdWENFoxYPBVj7QDNwnNobwZ4B7dQDr33a9fHtWiGsL9Yry4kY/XVEFpSoa/rHanQPFF
         LBSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780501550; x=1781106350;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=C9xWUzUEP3GatCDCPhqDCyXoyiDq9Ol5847oPRS2f7E=;
        b=AC9GICBF4ZwHVvhylZW+eTI3GcMB6g0OhvvywATHyeSgUinFHwxTDk39A8ZAnVCsn7
         HZc3Nbw8+NlTrqcwu4vh4IjelYQab8tklbBQ6uwDPmWLSSvuM5MWYdJ2LrEEG3IpCH0G
         Wthx42V+KcAUxJR6mIXS6X93jslGOv1LZCUmPJ5PBQtuWC2UleH5MTA+TpXJyq1CmOXs
         PhQgEoC78knO+sYlLJocL1ucq+TagPWK8efktLM6/62187OJlgOV2qDEP211PSJA9LMU
         xqjWQUPqe3DCFVkDVi0tDkWJNXGK79y8dZePD5aeRzAUy1K90FlVscyal1Qc3o/zM8Xs
         uFeA==
X-Forwarded-Encrypted: i=1; AFNElJ9PdCT22XnemGnJmsdc9/V6/fTVLIWwvreXl7s3yc0eok99y+mFT8TGKzBng2pI+iIOXwSIV7Vh6w==@kvack.org
X-Gm-Message-State: AOJu0YyHZRYoxIcvIU7K0yd7D6h7lHWl8i9nn0Cw2Y2LYeT6xbZ6nwie
	ecFek0lb3h5RCPWrdHa/cok+STNWzqCscrjdYgZtirqheW+gcJGYHcgBefoRGAs/q9M=
X-Gm-Gg: Acq92OEy7t1SQWL3NtAOxNpK5kMPo/B+2adHTkgrUWQaAaug6DXGZVIa36WpPkHV0eK
	G/+z8T9Gu0ofeIv0Am0abwE6oZ/7/B2MvUj/mZLERQj1BQGXPsIKvs7ydcdSMxfhOOZ8U8Ek34E
	o3km9ej5PyFB4ZUMjs7a0zddtTSmGHxZetY2SiLsllTbn1S6R9xqJlrT83W2dqhNnJ2ByuuWRD0
	vxRWs51Z/Im1+dkRyapQGAAOwqNZ53UfzeRidh636MXiAnbuh9liMlY0ee1BchvhI4eRqXZwTj+
	lF1IHvSRaOo4dxV7fb97i21B/iYIGbYP4OfdUfXXZNQcClTAHyubNfZubqFhVxpQ7MycPihaqvD
	zqmwIO9wWznFbMJ2+ir5zSp7VGWrB8NJlwcJ1Db1eocRrm195KY8/0W5Vm27Rf+cpO1juAvNRg5
	xxxis///ElhTs7rXmVJirHifKCWd+uUCg9NignkNnQYIbfBCqqQvbFrfyb6zIefQ==
X-Received: by 2002:a05:620a:25cf:b0:90d:b6b7:caa2 with SMTP id af79cd13be357-9158a64528cmr652914085a.11.1780501538664;
        Wed, 03 Jun 2026 08:45:38 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a00ba04sm272435585a.7.2026.06.03.08.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:45:38 -0700 (PDT)
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
Subject: [PATCH v7 08/13] liveupdate: defer session block allocation and physical address setting
Date: Wed,  3 Jun 2026 15:43:57 +0000
Message-ID: <20260603154402.468928-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603154402.468928-1-pasha.tatashin@soleen.com>
References: <20260603154402.468928-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CBDA0C000F
X-Stat-Signature: 9aq1b49p5rbgzqmost9d91ek4ztpyana
X-Rspam-User: 
X-HE-Tag: 1780501550-975188
X-HE-Meta: U2FsdGVkX1+Ebjpwlydrvd1/weFEtMoYM75VF+/2yOj102AqQLxdHMNDQY/OycSCMQx+YbpvidJFGgCCvmJDe73YuzFXPiOIpB6iZkal6QCEXnUjRCuJptotQKTKvIHkTeADwMjl9zNe6YT1Ul0nvNg6yp+sfzvqYdeJGUor9otPLuvhLnaEBvg7arR17vqr735sQgb/6RHu4KY3umZYg3GHRAY55l6EsjxLNF41pihtPosYR4NhViGRnVkkEhcs35lg09NcIOTiUS8dyy33qvpZG1jpPe97Hb2E0FyIJdz6UFcrPKDi19MDUTXr9Jh6ZH1CXk7bsWrWvjHYpBXvtRE6qTvDq5ptbAdDuPNmqDoUnjGBpw5RSDFyVVUXKikPHGspZNKyxd2ivrprvOVq/XQaNnIRri/HrGOPUCckqxqUkPZM/aVbDmn8psR9qOYu+3pycLD23pjGj+Y0UpmDXz2y0UhSACAkE0WSJ/daS/WeVlxAOR5Xc+KXiAmORpJyhlVDBj7jHAkPVES2BXnnMQH/+LFutEChMK8kLAcmJ+tRX0KUMj9228bXjNdVrgmkJExdNFMpA1K0bcDoalgBY2TBF/kvt/2y13wjOq0+XDGlCrHog8UsP07Wgrz+4i2lxcxgp5PKjWYPe3bxFJUGcPePDM06wgtP97qsIW2/fhqmp35Ix7lGjYlq6PmfS02qW9A0NT6LAw+1pzy82JoYAIAIkPuD7KnB598Tp0YpROWqbVUBYFf295yRCE1noKwdFYjySVckn61I4ALleJFzH4juTWANeU/65c3nfYiZhIGfMPmX84M5P1gvoZFT/ShrmBfoNXTFfCDaWVd2ihbaMpNFPeGju0paXAoQ/7BxKh039KtvQTEROi1GyGWWbJlE4FxRaFGO9QfcVLtw4ktd+U5jaCS0AxCMUqj8P4tiWTV9nKjnn6hQmroSedvQkHHnGoQS2s3ST+hP5B11r78
 ZbiUhuRu
 PzLF3/owLdg1OFgX5OJuq6IR4Rx0ZPOVotEyf76Zl79u+t0RyO8znIppn9Pk2vbv5mdTnAxiriW9mBs9Wnxf9dg2s8xL4nSwBwkQ+Y07uK7BbX5e/C+28n1RkMOC5e3ltD+XVJl4+AfpHNQDUHnzneADOBvTxfWj9zlut0PxdlkbNsooi4tP+9CYFy6qq9JDvGd3g5Z54uqdRserlbj1MYjj0UP/qhwpoQrdejK7h7veKpHME25VhnsEfXQ1rOvP6bTnpIEJXGH8+ZA2Dh0NF5DEIushhhCTsqhdOjEW+nyoQKwbfLhoZ7sJJxTDNlCUmNs4BP246rfz8pqXJw3XlGGPB8HtDtllw27I5
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


