Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B3E606A334
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=g4v28wEg
Received: by kanga.kvack.org (Postfix)
	id 68D496B05B2; Thu,  5 Nov 2026 00:01:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EFAE6B05B6; Thu,  5 Nov 2026 00:01:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5056F6B05B9; Thu,  5 Nov 2026 00:01:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 181026B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:01:02 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7EC991208F2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:01:01 +0000 (UTC)
X-FDA: 85399865922.09.24F0DCA
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id ACD3718000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:00:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=g4v28wEg;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854859;
	b=F6SHOfk6Pv/Mri+hrvtbAHy2D38wv7+84x9b5nVY+Imi30eY+UyjS7S1sIly/Icrtwv41H
	P2Vm4RKixFDxQb4YxrBDMczNda9mEvpbLxz1Es3Hd6TxtyTDMAjXHDira+oM6omDjHCX60
	jJldb3pQZnusR0PLuHd6ej9Xl7PoOeE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=g4v28wEg;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3dC/2UP23mv3BH3OYo6bEH5lmwGOxjF2IHkUty9s/lM=;
	b=VwFuYdhZvyUTliKTuhwpR7QnjPwSgFpEN/K2UEZZOZOps1c7iaNVkzwySF9qD1mREa52Gw
	KsrjUOmjFlwr+ovCLTAGaeVCxf5r7JqArgSEAdt5UpdX0BYkpFi4UrLzT5Hl73cM6cJ0kL
	PVLwpdphLxnhbS4qe1ErUm/CrN7Wzkw=
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5eafb65e169so929944e0c.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 21:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793854859; x=1794459659; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3dC/2UP23mv3BH3OYo6bEH5lmwGOxjF2IHkUty9s/lM=;
        b=g4v28wEg9S2jfmvF584QtlfMG6tBi9hXkJX0Fuw1sXwg6VDd6tShccGJ9ELabdlsv9
         H472NX+CJ8mSIc2mabII5aOKNXHh66OPaMGQlFBr1OMCwbsAvT0hmpIRqr2MRyaGY/C8
         zZ5d0pX989J4ZPC4PgEGFS+TQeS9pU3tKOEoeNXNizatBiDjJyYEkKoBjTyYvI3eL/43
         8O60DxAe6gYTK6NHTnf9bNAkMUfu0s47ydo31KU9dWCVyLuvyeS8K1qWacQitmypquXv
         QYRqjUYzHYPrc1uboT/8PlZt7kNt9t8XwigcFV4b3OPcFCUABmvwh3i3ZscHcjpoZ0Gy
         NlGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854859; x=1794459659;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3dC/2UP23mv3BH3OYo6bEH5lmwGOxjF2IHkUty9s/lM=;
        b=JAGfoqilsWI8zpeqxxUVOG9Bw56qWvvpPQB6yemjwovlcBesIAudhuU1jHOkeYutpi
         vPYD3v5F+PhM5lCxUWw1lp6TBxVN9Yctt5erar6Lg8CcC68bIB3pKSg5LQ9oc6g6J3Mg
         cimresx/WlR+uUgs7LN8uOYFuLnScVHhIg0X1hh0bjDsqvNzixNcMasL+b4OWgT9U8fn
         J8RIaT6vrC6yj21vMuSlHBJ/HFJDkMk6aQHuIosFN08K0FNg1mgMFvpUmJQBVunqqSZ0
         X27cWEWeWjqonnWtUGc/sRek5TRfLNihIjiQ3sGfqAwz9DHwXGyX7iUK0nRWGOKgjkiM
         TaaQ==
X-Forwarded-Encrypted: i=1; AKwUvBwjzASaBZWlLKn/mAVXW7VfLqMIloshEtfwHflIdQidb4e1KB4ovvo/Al94G+Tnz9R7uVKN825FYA==@kvack.org
X-Gm-Message-State: APuU4Z83mSBTF0mUDe0KbJvt6RWZ0v4e1j9CFtYIH6HyQlsV0jh9e53A
	QbwOrCB0sZS5fM3h0dcEhCNLQAE0gSsQ8pBpwVVi7Qf+s3ZadtHolDnlkfPaVuVUpnI=
X-Gm-Gg: AYBFou10qNxRa1v2f3RJF++PD9fx8Ue4wYnY4TMV72kWNjjKpyc5xHiNvMz6C5kdOnd
	xMxOaloiLeCfxWeK34g13I4avtb6obedIQtW7GoSJEARD56cNWsTbYuUHgnA52tdbteP0FmQaD4
	TuCN1D+f0H1SQY0a++CsxT6nJaDMhCcSGoS89gKVpv2ecLKY+9nlegm4btQCyd7YEKdSuyzBuW4
	5DDLGV1S0VV6di2ljjYg8wKpupngRqDRa32f9AQZOpxBw+qoZ/4moD5dacvChGq776IZ961KUal
	/xugETgwRsah6GyxFa8UCJJB9d8ZU5bJ7hXh0t2pjQU654OcF/gMU4ilJdAQZO4NQE4VSpT3rtz
	YxRZsKzBS/jGkhddZcn++AmilziKcuYelGFNZPaTWqOgloP4hDuVr4Maw06w/i+EHsrDc0M3QSA
	2TeLYbx7kSAIfDUYUsYJnQTP9Qo1E8xBZBdrVqWU7Hs2YZlsehAFPhGRgfKnW9h8gS9vxD21udY
	vq62sveKC50QUnVEP2F0CJO+AitL7xtrXogXWgZm3JOmob7Pnv62kG/hAbnV5vB6AsyFBbBA+Rf
	h+bVaAYCFJ8NsddNA22nc/TE6/qAXGjIeSk3jMu8c8nwqg09f7Xuv4LNZxBeYmPRSi8Hzqtqs6B
	zThb9kNtI2L7yEqZN1e4qynkZ15sSpgeF+R1wXwfIMeKSdWP75A==
X-Received: by 2002:a05:6122:e443:b0:5ea:e197:702e with SMTP id 71dfb90a1353d-5ec6899db99mr8875283e0c.20.1793854858748;
        Wed, 04 Nov 2026 21:00:58 -0800 (PST)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca8d9d62bsm3305282e0c.8.2026.11.04.21.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 21:00:58 -0800 (PST)
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
Subject: [PATCH v5 1/6] liveupdate: Move file_set_ser handling to luo_session_serialize()
Date: Thu,  5 Nov 2026 00:00:47 -0500
Message-ID: <20261105050053.3063001-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
In-Reply-To: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
References: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ACD3718000A
X-Stat-Signature: e37yrcgpakgtfhizzm1ju6ku68fwswba
X-Rspam-User: 
X-HE-Tag: 1793854859-926244
X-HE-Meta: U2FsdGVkX18Ftoa9GWYHu7YZn682BhXrRmBarBI+nvTWXBABc8NZfAftFOm+GkcB8L6kCbDbvlxt5/GahStdU8/jgcpv4nmLGiVNOt4KwfBlo06zGedbRB99GgU305kFqPnLlSg5YBolpMH0ME4vBa72ZYLjlePPu+nUbiXFp4NP0YpgIhKwqUZCEsdHh95fTL3yfhS4FsLlilZzdrbAmcp0CvxylnDQXWuS5K5XFW6JrqExIeJ0ej+mmLwj8Hz+hbbe1Wk7GEqnTo9Xlbjq1nIGUzWS7O//+MqGBBh3n/K7isU7lptiLM0CMErXnGO47PL1zXMWQIHh51A99lTIkJSZ56UucEWNqPs5Ne6gE5GUOEN2Tc+K9goQB0XLmCc97uOw21vMZmLI+djyaydajAtG14n4iOd/dWgZgqRw1dAMfHcTsiW95oG5qv0K1/BOhU6CElRjm6jJZvvRQSFeP/0L6ekzVOg0t2cOTvUKNT5xoKcgPKcGh3JJAPg9NnBzP0UG7gKE+dLUY2KZHprnVG12JdOmCuewv70GlAyZUdtvaxcR/RieHn0g7Dho5TLbE3NYJ/AjNGUt4TnuS33bGpoNk49W1Mc3qE8woRkAsyIcCLbExFcY2YUVIOnSxQYl/dH4Q8vDkhXtrIaaKgEzr77cEYeidNFmR0eTGFyK31EERq763PZrUyJLojLE1anI9QClWxA8xV74jhjQMq3kNP9yu4fvdfIoJ8r43M+rEHHU6WcOceOnPmjP9Q0Akqbn4O3X0BgNLVG6nh+/Q+PeIykeEp+ALl/+i2XnRucw8ZqzgFhGGDwIFZyIklG+ydG3z26DVC0hk9GmLMu51A4rtdL8SwKO3bOWUjP9AzSSUMr+liV1KbajL6/4gW0f+I+mmr3sRosAp0ebxkqRXZlLnAUkcbgXa5sVFsEqRqDatn30LyicjgctsN66pbOfQjcuj7BFpRAlvYsFja/dLUS
 W3oo4wnp
 GnzWPC5LGwFLN5JnZkfS5fThNDQO0rDzNyTYymZA+rMZnl514E/oA6sKbMM0QMVcBnVQ6H1ySqsM0HP6V5iV/rE8LbU5o9dTexaCrjdhvzWppowpLUw+Mn4cBLiUa7QiOX3xn4vEg29PWM3w9eNV0kn/eqw9Rb+9qsGWdLDQ86/r5PJ5XjeJhPksbZCpeTVW9pajgvQ8LODkQ5IG1C7agh1TE4ZLcFnP915zBs7ISExGwb+YTTx0tdbnc39Xrqo5atTkwon1Z8+asyDX4ZZFQeHoOFkeYMpC4zdqUN5xAu30gPze1DdlPoBZiyWATj25UNfMP3n8RxJ6l6cIGxwF4gAXLCpk5tyzCMmbFE5pziSB1T6NUOjyQJsZ5efy6i3FHkOJHmjgTQjzK9bHkRYg+5RV21Lvs5COnf+qw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In preparation for allowing userspace to freeze a session explicitly
before kexec reboot, luo_file_freeze() and luo_file_unfreeze() need to
be called on session->file_set before any struct luo_session_ser entry
is reserved in luo_session_serialize().

Currently, struct luo_session_ser is populated and cleared across two
layers: luo_session_serialize() writes and clears ser->name, while
luo_file_freeze() and luo_file_unfreeze() write and clear
ser->file_set_ser.

Drop the struct luo_file_set_ser pointer parameter from
luo_file_freeze() and luo_file_unfreeze() (and struct luo_session_ser
from luo_session_freeze_one() and luo_session_unfreeze_one()), and
populate and clear all fields of struct luo_session_ser in
luo_session_serialize().

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c     | 24 ++++++++----------------
 kernel/liveupdate/luo_internal.h |  6 ++----
 kernel/liveupdate/luo_session.c  | 19 ++++++++++---------
 3 files changed, 20 insertions(+), 29 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a39992da504f..988eb313a135 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -440,8 +440,7 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
 
 /**
  * luo_file_freeze - Freezes all preserved files and serializes their metadata.
- * @file_set:     The file_set whose files are to be frozen.
- * @file_set_ser: Where to put the serialized file_set.
+ * @file_set: The file_set whose files are to be frozen.
  *
  * This function is called from the reboot() syscall path, just before the
  * kernel transitions to the new image via kexec. Its purpose is to perform the
@@ -457,8 +456,8 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
  *
  * 2. Serializes Metadata: After a successful freeze, it copies the final file
  *    metadata—the handler's compatible string, the user token, and the final
- *    private data handle—into the pre-allocated contiguous memory buffer
- *    (file_set->files) that will be handed over to the next kernel via KHO.
+ *    private data handle—into the pre-allocated serialization blocks
+ *    (file_set->block_set) that will be handed over to the next kernel via KHO.
  *
  * Error Handling (Rollback):
  * This function is atomic. If any handler's .freeze() operation fails, the
@@ -471,8 +470,7 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
  * Context: Called only from the liveupdate_reboot() path.
  * Return: 0 on success, or a negative errno on failure.
  */
-int luo_file_freeze(struct luo_file_set *file_set,
-		    struct luo_file_set_ser *file_set_ser)
+int luo_file_freeze(struct luo_file_set *file_set)
 {
 	struct luo_file *luo_file;
 	struct kho_block_set_it it;
@@ -506,9 +504,6 @@ int luo_file_freeze(struct luo_file_set *file_set,
 		file_ser->token = luo_file->token;
 	}
 
-	file_set_ser->count = file_set->count;
-	file_set_ser->files = kho_block_set_head_pa(&file_set->block_set);
-
 	return 0;
 
 err_unfreeze:
@@ -519,28 +514,25 @@ int luo_file_freeze(struct luo_file_set *file_set,
 
 /**
  * luo_file_unfreeze - Unfreezes all files in a file_set and clear serialization
- * @file_set:     The file_set whose files are to be unfrozen.
- * @file_set_ser: Serialized file_set.
+ * @file_set: The file_set whose files are to be unfrozen.
  *
  * This function rolls back the state of all files in a file_set after the
  * freeze phase has begun but must be aborted. It is the counterpart to
  * luo_file_freeze().
  *
  * It invokes the __luo_file_unfreeze() helper with a NULL argument, which
- * signals the helper to iterate through all files in the file_set and call
- * their respective .unfreeze() handler callbacks.
+ * signals the helper to iterate through all files in the file_set, call their
+ * respective .unfreeze() handler callbacks, and clear the serialized blocks.
  *
  * Context: This is called when the live update is aborted during
  *          the reboot() syscall, after luo_file_freeze() has been called.
  */
-void luo_file_unfreeze(struct luo_file_set *file_set,
-		       struct luo_file_set_ser *file_set_ser)
+void luo_file_unfreeze(struct luo_file_set *file_set)
 {
 	if (!file_set->count)
 		return;
 
 	__luo_file_unfreeze(file_set, NULL);
-	memset(file_set_ser, 0, sizeof(*file_set_ser));
 }
 
 /**
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index dac6644bfb18..01a172cd9d7a 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -103,10 +103,8 @@ int luo_session_deserialize(void);
 
 int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
 void luo_file_unpreserve_files(struct luo_file_set *file_set);
-int luo_file_freeze(struct luo_file_set *file_set,
-		    struct luo_file_set_ser *file_set_ser);
-void luo_file_unfreeze(struct luo_file_set *file_set,
-		       struct luo_file_set_ser *file_set_ser);
+int luo_file_freeze(struct luo_file_set *file_set);
+void luo_file_unfreeze(struct luo_file_set *file_set);
 int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		      struct file **filep);
 int luo_file_finish(struct luo_file_set *file_set);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 74bc66929f4b..6dea35911181 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -219,18 +219,16 @@ static int luo_session_finish_one(struct luo_session *session)
 	return luo_file_finish(&session->file_set);
 }
 
-static void luo_session_unfreeze_one(struct luo_session *session,
-				     struct luo_session_ser *ser)
+static void luo_session_unfreeze_one(struct luo_session *session)
 {
 	guard(mutex)(&session->mutex);
-	luo_file_unfreeze(&session->file_set, &ser->file_set_ser);
+	luo_file_unfreeze(&session->file_set);
 }
 
-static int luo_session_freeze_one(struct luo_session *session,
-				  struct luo_session_ser *ser)
+static int luo_session_freeze_one(struct luo_session *session)
 {
 	guard(mutex)(&session->mutex);
-	return luo_file_freeze(&session->file_set, &ser->file_set_ser);
+	return luo_file_freeze(&session->file_set);
 }
 
 static int luo_session_release(struct inode *inodep, struct file *filep)
@@ -657,13 +655,16 @@ int luo_session_serialize(void)
 			goto err_undo;
 		}
 
-		err = luo_session_freeze_one(session, ser);
+		err = luo_session_freeze_one(session);
 		if (err) {
 			kho_block_set_it_prev(&it);
 			goto err_undo;
 		}
 
 		strscpy(ser->name, session->name, sizeof(ser->name));
+		ser->file_set_ser.count = session->file_set.count;
+		ser->file_set_ser.files =
+			kho_block_set_head_pa(&session->file_set.block_set);
 	}
 
 	if (sh->count > 0)
@@ -676,8 +677,8 @@ int luo_session_serialize(void)
 	list_for_each_entry_continue_reverse(session, &sh->list, list) {
 		struct luo_session_ser *ser = kho_block_set_it_prev(&it);
 
-		luo_session_unfreeze_one(session, ser);
-		memset(ser->name, 0, sizeof(ser->name));
+		luo_session_unfreeze_one(session);
+		memset(ser, 0, sizeof(*ser));
 	}
 	up_write(&sh->rwsem);
 	up_write(&luo_session_serialize_rwsem);
-- 
2.56.0.398.g882cbad275-goog


