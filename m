Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DFCA606D83F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=XKB3Nm7L
Received: by kanga.kvack.org (Postfix)
	id E08006B05B9; Thu,  5 Nov 2026 00:01:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7F56B05C3; Thu,  5 Nov 2026 00:01:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7F796B05C5; Thu,  5 Nov 2026 00:01:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A3E326B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:01:05 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FF101A0962
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:01:04 +0000 (UTC)
X-FDA: 85399866048.21.EDC729E
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id BF7091C0005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:01:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XKB3Nm7L;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v098YBuIdrKaWG/f26OqsK+m7fEKJ39NQmIhL+jm86Q=;
	b=zvOq/34GKu0e2V13P0lFwNh297CU8pbx2BItNwaP9d3TfHAFlJ22wE1x9JeYVt24OgCzuH
	I7B912IaYDVUGSwCVJGja8u/KN1OT65KoPTaZSs3yb+/rlh/W2YLdeHYjiNzq4JjLstj6y
	82lSvV93sXyIlBVLWGf4SQhv26TNQDo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XKB3Nm7L;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854862;
	b=x0+T41o4wP173A15oKA9/CdU/KMLLgIZ9LO7NAeFke8JYUwuV+EIl8kXIuqA17ebieoq2V
	i/9N9uBgcwnPQd/m0DHMC/1fEk88cjQcQV5cwpK9JaTIh9H9I4o76MBSY+CdXEhsHgIbez
	Wk0vLqPXi3MoIy8sWAwIYf11H6+Dd8E=
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5e948e56af3so520029e0c.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 21:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793854862; x=1794459662; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=v098YBuIdrKaWG/f26OqsK+m7fEKJ39NQmIhL+jm86Q=;
        b=XKB3Nm7LHeBl3LdEX+MVGm3AuSYnkdDvaqw3VZwKLDtoxCLCDsky5xNrNA7IoTX+Wh
         ezJN6wrdVsUHFW1hUavlcT33JrXedTu85zm1foBXIHOce5HOsCupgDGgWDbHR3ISPE7w
         Yb7cQ6+9Me82JRlQnYd2HGEZAlJLxwuOE8XQ+M0RWScD8u3jnnRgwuGSDKxc1R1u9oLk
         79Wur6PWkgfxV03/8uv0fN1dxhv005AB4Muwdv5EPSY4dqXRwDPEjnpUQiBhqHaPwsAv
         4j7ytxivveL2EHlqqKHWvkFME0i6S7fcycd1EPWOi5yDZW9GLih4sz44VD3u62r6pWD/
         VnDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854862; x=1794459662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=v098YBuIdrKaWG/f26OqsK+m7fEKJ39NQmIhL+jm86Q=;
        b=tuY68cIvDj4S5B9Fc2IZr/CXPG2mTH4T4WEXpLbpd0dHVGEkdSEmG5o1JpDHchREoG
         jxCwkXWccIdoM9Xo0pfJ48YHmX9XdJhKHuq/awXcPkH+rCJBeJkABS9xNTHuEMhlEZih
         ozHnkbN42qD1N9A+QAinJEO7+7cSK6UFUF5WP5Ku1dUmdqXZg7HKTc2EP5khA9I98uj1
         FNAM8Wmf/WSEAxxXZQjqSNx4OVCq2LzZo9JxNkz6aHV0U9EhsftMbhVEJKWOz/Pv1spg
         QPDQZebBSdKZYX7LI6GdrylJOaevHXByCteL0Dk/lf/1mUyeIWcgsJW8q46Ao5SHtwje
         z9rg==
X-Forwarded-Encrypted: i=1; AKwUvBxHVAEbM+vLye3hMMcHAav6hmgpH0Z+D6eE099/1K+gVLTixaLq1+rnpoxjlwfETuKnIdR34tkY4w==@kvack.org
X-Gm-Message-State: APuU4Z/d21CUhHfhlSFapJZjnwFNeRmt/nadHVAuEk1o/XsGS0/oLg4E
	Ki29b7RLXiiqze86LxW9CrskEKMJOt6Ad63BHa72J+gBpEbyXltt0BYMIbm9vDgCuUE=
X-Gm-Gg: AYBFou0dVErqohzZqugpbkVgDzJvUeggMHYMfmGKmrTbO3eSpjLWa/oT3SrppjTWq8H
	LVHHbajjQBDS2zcD9GKIFtH6UTJurrdKHEUIEpxTVOc1QxGPO/43WGWYkIAPMjR0hsEOs1XdgNM
	MW4Vw43i79HVfycjHSASMimm13IsezW+oKOlpHVsPqUyuO2R07a+K7a5szEpLQktxipfupZVm00
	oeTXI7dwerSfrrW6LwvAXDHZvVfLVBo3Mx9ZCYOuzK6bzur1SsNIE0iB09NSJ4pXVo4p23UAPFY
	83tKdOqnhnlqGxya3YRfYtgNMrwS9E2C/nDE8sJY/8R47pTNxIbleLyOWLAhgQR6NCTA+KO+C1B
	7v0tIhLdPOIT4MRi/503TJ6fQcd22vGWK6IPFIthvV4npisRmS8eWytI8Jjf8md7cg7QTFGhgs7
	X794ZaVs61sbHrzoXMFLz33Cv3+ax8PUHa01ATQlOU5SdisqEaCTVMkduvpzd0dghodG+sBNAh0
	oIlOUIrIAvvZeSUf5+jOGIZKRn/OGFHPxamYEipRrblVx9NvhII7EuQtP9ZgB9ZB2YZI5SyL/dX
	Dje/wmMjdyJgWkgcmBZIVgEZzLUGnJ41dIpxxNRl21mP1xpkJMkatojCRFmSsEhNpHYG39ovTlq
	ZXkYG64M9BPQucs79sMvrqHKfdev6ldOFhoq1Fe9EhQRtM/2kiw==
X-Received: by 2002:a05:6122:468d:b0:5ec:4a13:8aae with SMTP id 71dfb90a1353d-5ec689801b4mr8447981e0c.17.1793854861885;
        Wed, 04 Nov 2026 21:01:01 -0800 (PST)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca8d9d62bsm3305282e0c.8.2026.11.04.21.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 21:01:01 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	graf@amazon.com
Subject: [PATCH v5 3/6] liveupdate: luo: serialize sessions via per-session publish helper
Date: Thu,  5 Nov 2026 00:00:49 -0500
Message-ID: <20261105050053.3063001-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
In-Reply-To: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
References: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BF7091C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 5mbc1gf51m5bm14aye1fx3gppn8bh53g
X-HE-Tag: 1793854862-242568
X-HE-Meta: U2FsdGVkX18IhrekCwvSqxHd0YR4LI509sISfNFJqo3E9REAaR2joNnsh2E5HHKjUH9hhJ/L4Cy1xyypOTHgKAJh6+6AQrd83n5vIKKJAOS5qJ5hdA+CVZLFCu+uaxI1nUJtuLvyzawtPJHs/chRonoAcfD/56JbBYdYuCwgN597kkFPNVN9H0zTTGFqM5lXwdcXwO6z2rbenDRSEvRlraVMPUvZav7m5IeJ6H0tSFlol11vayGuDAu2G4w1nV8/UH/ngr1z5AIT7Okjm5ZghSMb6fOn3xuRGJZclhkIE37YR4Vm3/79oki3XfT5RYM3RxsrQFwmoMeF+3MFKmP7rvynvOCHXO9Ss0fF7lnv+2Yesv/gdi08hCRSGEhJplxEIDNx+6s1V5nUg6U+YHioRFAfaIwJpRcC4Mw2ciVKHADrawy49A93iqFi7o23++hU/P9mM2SHrLeBDuDMOYpaqbRIsf1pXoRKxP6kuBxSy2JrmgJcyLtXx4TtyDhzHhXERaHOmzZ+P0fZxd3OjxuCzQAX187tWA/TZFCPO1DojInN4Zp7VJyv4biC6PM0GPKlS+fcPQ5b2lbfGUVq6kr/vCTp+kMPsqeniHW3p8jCidfVcJATuKz1BnTOP4yvST9WGXzH/JJ3ieQawJuoKsf8KcGFQFk9pPLBRScOLi2zbgAsVdIzNrhlzIyB20rIflf3UszHbLYdjVlYz6DujdS5RhGZXEN0teIWYV6NPWRtf5FVLZ/ccihAE5kjmfH7cQdGkmnVRQIybYre0xomY+ACmBQ9qe8uv+XEp2DKhBOjx75/HOM14m/Bsc5gPF1ZghJuUSxD1IjazeyyOvrHBgtBMPp8k+uphPhGeMACbywppI8LNcR0cma0Bv5Zev5thBn+aYqxbmNAHHJa2WM3Dd4OI1XoX5nO/c9fDLqRWbbtxzUv+jbIjmZ24Z00cSAnAFy296R57MVbSNdY58UsY+6
 Aibvemhk
 yeEx1K/8/O9yX7uvHH8OtXNGJm/Ms9g8IWxxdjP3vKl4C7j52h+Q06VQg45ejWZZMyH/00OMFR2hqGcdYZzQPbWUdFnRDanjp6ufdVKa5NmTrwW80P8Amr9kgFO6JlZfI9G9LIIRT6XUnFlyzMEoQApJW/RjosFCzc8IoQj8MxIb/hOxzAgNIiGwEc316HY8KgFEiGkw45ilSOP0mY43bhpUPjrClBJC8OGbXC55zAXtu8yg4q/sqh27xlejkDcuyptstdriM8ym2wQ/LVcV+2owYvoeN/rSPPDLNIjAjTSCFPiTuPs/XDc1GhGBNbkVrOi/HajNXbZNA34HW3+XaiaYDzh6kVJA4MSFSwzi/q3TG2iCTRQFANEsjcFD+dN27FFr14ILP64/uU3jmWeSC3qgXTmxwLqnqorCq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With incremental kho_block publication in place, LUO sessions can be
published into sh->block_set individually as they are committed, rather
than rebuilding the entire session serialization chain during reboot.

Currently, luo_session_serialize() resets *sh->sessions_pa and
serializes all outgoing sessions from scratch in a single pass at reboot
time.

Introduce luo_session_publish_one() to append a session's
luo_session_ser entry via kho_block_set_it_append() and move the session
onto sh->published_list. Update luo_session_serialize() to freeze all
remaining unpublished sessions first (rolling back via
luo_session_unfreeze_one() on failure) and then publish them in a second
pass.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_session.c | 92 ++++++++++++++++++++++-----------
 1 file changed, 63 insertions(+), 29 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 6dea35911181..caf0e85081e8 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -103,20 +103,30 @@
 static DECLARE_RWSEM(luo_session_serialize_rwsem);
 /**
  * struct luo_session_header - Header struct for managing LUO sessions.
- * @count:       The number of sessions currently tracked in the @list.
+ * @count:       The number of sessions currently tracked in the header.
+ * @published_count: The number of outgoing sessions currently published in
+ *                   @block_set.
  * @list:        The head of the linked list of `struct luo_session` instances.
+ * @published_list:  The head of the linked list of published outgoing
+ *                   sessions, ordered identically to their entries in
+ *                   @block_set.
  * @rwsem:       A read-write semaphore providing synchronized access to the
  *               session list and other fields in this structure.
  * @block_set:   The set of serialization blocks.
+ * @it:          Iterator tracking the next slot in @block_set for outgoing
+ *               session serialization.
  * @sessions_pa: Points to the location of sessions_pa within struct luo_ser.
  * @active:      Set to true when first initialized. If previous kernel did not
  *               send session data, active stays false for incoming.
  */
 struct luo_session_header {
 	long count;
+	long published_count;
 	struct list_head list;
+	struct list_head published_list;
 	struct rw_semaphore rwsem;
 	struct kho_block_set block_set;
+	struct kho_block_set_it it;
 	u64 *sessions_pa;
 	bool active;
 };
@@ -134,12 +144,14 @@ struct luo_session_global {
 static struct luo_session_global luo_session_global = {
 	.incoming = {
 		.list = LIST_HEAD_INIT(luo_session_global.incoming.list),
+		.published_list = LIST_HEAD_INIT(luo_session_global.incoming.published_list),
 		.rwsem = __RWSEM_INITIALIZER(luo_session_global.incoming.rwsem),
 		.block_set = KHO_BLOCK_SET_INIT(luo_session_global.incoming.block_set,
 						sizeof(struct luo_session_ser)),
 	},
 	.outgoing = {
 		.list = LIST_HEAD_INIT(luo_session_global.outgoing.list),
+		.published_list = LIST_HEAD_INIT(luo_session_global.outgoing.published_list),
 		.rwsem = __RWSEM_INITIALIZER(luo_session_global.outgoing.rwsem),
 		.block_set = KHO_BLOCK_SET_INIT(luo_session_global.outgoing.block_set,
 						sizeof(struct luo_session_ser)),
@@ -186,6 +198,10 @@ static int luo_session_insert(struct luo_session_header *sh,
 		if (!strncmp(it->name, session->name, sizeof(it->name)))
 			return -EEXIST;
 	}
+	list_for_each_entry(it, &sh->published_list, list) {
+		if (!strncmp(it->name, session->name, sizeof(it->name)))
+			return -EEXIST;
+	}
 
 	/*
 	 * For outgoing we should make sure there is room in serialization array
@@ -203,6 +219,42 @@ static int luo_session_insert(struct luo_session_header *sh,
 	return 0;
 }
 
+static void luo_session_publish_one(struct luo_session *session)
+{
+	struct luo_session_header *sh = &luo_session_global.outgoing;
+	struct luo_session_ser entry = {};
+
+	lockdep_assert_held_write(&sh->rwsem);
+	lockdep_assert_held(&session->mutex);
+
+	if (!sh->active || !sh->sessions_pa)
+		return;
+
+	if (!sh->published_count)
+		kho_block_set_it_init(&sh->it, &sh->block_set);
+
+	strscpy(entry.name, session->name, sizeof(entry.name));
+	entry.file_set_ser.count = session->file_set.count;
+	entry.file_set_ser.files =
+		kho_block_set_head_pa(&session->file_set.block_set);
+
+	/* This should not fail normally as blocks were pre-allocated */
+	if (WARN_ON_ONCE(!kho_block_set_it_append(&sh->it, &entry)))
+		return;
+
+	if (!sh->published_count) {
+		/*
+		 * Ensure the first block header and entry are visible before
+		 * publishing sessions_pa to concurrent KHO readers.
+		 */
+		smp_store_release(sh->sessions_pa,
+				  kho_block_set_head_pa(&sh->block_set));
+	}
+
+	list_move_tail(&session->list, &sh->published_list);
+	sh->published_count++;
+}
+
 static void luo_session_remove(struct luo_session_header *sh,
 			       struct luo_session *session)
 {
@@ -636,50 +688,32 @@ int luo_session_deserialize(void)
 int luo_session_serialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.outgoing;
-	struct luo_session *session;
-	struct kho_block_set_it it;
+	struct luo_session *session, *tmp;
 	int err;
 
 	down_write(&luo_session_serialize_rwsem);
 	down_write(&sh->rwsem);
-	*sh->sessions_pa = 0;
-
-	kho_block_set_it_init(&it, &sh->block_set);
 
 	list_for_each_entry(session, &sh->list, list) {
-		struct luo_session_ser *ser = kho_block_set_it_reserve_entry(&it);
-
-		/* This should not fail normally as blocks were pre-allocated */
-		if (WARN_ON_ONCE(!ser)) {
-			err = -ENOSPC;
-			goto err_undo;
-		}
-
 		err = luo_session_freeze_one(session);
 		if (err) {
-			kho_block_set_it_prev(&it);
-			goto err_undo;
+			list_for_each_entry_continue_reverse(session, &sh->list, list)
+				luo_session_unfreeze_one(session);
+			goto err_unlock;
 		}
+	}
 
-		strscpy(ser->name, session->name, sizeof(ser->name));
-		ser->file_set_ser.count = session->file_set.count;
-		ser->file_set_ser.files =
-			kho_block_set_head_pa(&session->file_set.block_set);
+	list_for_each_entry_safe(session, tmp, &sh->list, list) {
+		mutex_lock(&session->mutex);
+		luo_session_publish_one(session);
+		mutex_unlock(&session->mutex);
 	}
 
-	if (sh->count > 0)
-		*sh->sessions_pa = kho_block_set_head_pa(&sh->block_set);
 	up_write(&sh->rwsem);
 
 	return 0;
 
-err_undo:
-	list_for_each_entry_continue_reverse(session, &sh->list, list) {
-		struct luo_session_ser *ser = kho_block_set_it_prev(&it);
-
-		luo_session_unfreeze_one(session);
-		memset(ser, 0, sizeof(*ser));
-	}
+err_unlock:
 	up_write(&sh->rwsem);
 	up_write(&luo_session_serialize_rwsem);
 
-- 
2.56.0.398.g882cbad275-goog


