Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7547C606A327
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IGEWR2ZH
Received: by kanga.kvack.org (Postfix)
	id D63F16B05BA; Mon, 23 Nov 2026 18:39:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41346B05BB; Mon, 23 Nov 2026 18:39:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05946B05BC; Mon, 23 Nov 2026 18:39:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 549716B05BA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:44 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 24B3AA0AB6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:43 +0000 (UTC)
X-FDA: 85468003446.22.100EB31
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf24.hostedemail.com (Postfix) with ESMTP id 61527180005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=IGEWR2ZH;
	spf=pass (imf24.hostedemail.com: domain of 3vM4EawgKCMsu3rA2rt1x55x2v.t532z4BE-331Crt1.58x@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3vM4EawgKCMsu3rA2rt1x55x2v.t532z4BE-331Crt1.58x@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477181;
	b=FBk4nRarD8jrQksihEmSfi30NLOGqY8i339hvPGd0G9cBKuDDGZU5q+aB0+eYjhXlUcfmq
	FePRlIt/f0wN78G1ZB/ytjjqR+o97wltlyfcdac5oybopGYG/GIG/WzOKQIW5cCgjNyRHL
	NiPLG2+1qysai30GgoM4R4Rf4YWWsJM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PdON3gXs/6uQsPuxGzIPmKwz1/GfU1B3j8DG4CMn1QI=;
	b=yBBmUz+ySUcp0q6Md0n6gDkXNQha01siISjp6pLeW37PE4JWsbGjEyQ1OJSoDHOlG+EPzR
	pM1LZV70+S9TAwzOFutKIqi4P3Z/0U2w5+CJqfwjH6nWlfgXvpOrxYo4zK/e8/PoURMyo4
	f3IP0ew+GTjOkdiPQe9wCgtjo2yV/ac=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=IGEWR2ZH;
	spf=pass (imf24.hostedemail.com: domain of 3vM4EawgKCMsu3rA2rt1x55x2v.t532z4BE-331Crt1.58x@flex--dmatlack.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3vM4EawgKCMsu3rA2rt1x55x2v.t532z4BE-331Crt1.58x@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4c55ba309c2so4473192b6e.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477180; x=1796081980; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PdON3gXs/6uQsPuxGzIPmKwz1/GfU1B3j8DG4CMn1QI=;
        b=IGEWR2ZHXnkbgWU0PfiapEGSkHdd9YLDQLAVnn04Mm30Cgb/50eilDpZi1aLVxdbNZ
         n16BvG/Szv1VoFO7aUTfa73VIF1dJDR/QfdohEWEc6v2FVJykfwYCOMFXui82hp+uFXD
         nFxb0lBX4CEP7oB3oczQOzWQ6ApgSq13gBDpLD/8fD+vsHB1/zJ6Z5qe8S30woKWDSN0
         XhZGgUxOMGUgIRPXhl5eHjl6EXLGibUBpZ+bOT5A9U9QodN4UpFA/0/bK4SP0qipyRAa
         mEtwDOq0IK/jNxlcBqaVIp4pteTDK5a3vyGU16MEfTI+1A4Quxg0m16kG19zZBF7xMfo
         jV9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477180; x=1796081980;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PdON3gXs/6uQsPuxGzIPmKwz1/GfU1B3j8DG4CMn1QI=;
        b=dVomBqHKEUiv6bAkCJWQnv7dp6ulpMoqlGJJopK9RTmFcQfE+80CvFiKUxLSspskf5
         Vb11h4qJqMAMD5jLiJPz/A90CQ5gvyPBsJBnnPpWAQMqVYXmtj133UcoPZhu1qRvNA3h
         qwwBOLj18MZKf2OpIC5NY48m0hi8b2oQbHEA/z1HjyvYaJGA5mlC1pj8YmtW/O48381x
         EaxfZq33jDB4+ChglYbHKP1NtG+hokfQUUz6cUUeQrfO0Bw+SdkaELwDkSk5BUtGQYl9
         wuE0BZCktOv9O8a4MkdDiVdNiqQNJxIWw3rFczb3DzmK7ueYIBdC3K/VLGYu51PeFQ8W
         z4UQ==
X-Forwarded-Encrypted: i=1; AL+hErFb0f5hv/atXJPepcCAWsyA3/BxlqDNTqm66Sc3ZLm1JNuoEqQivHiMRdwyP5OFFJcUPdoZaQgeRQ==@kvack.org
X-Gm-Message-State: APuU4Z+LPcZKjByutYYgLWbujjl1k1+7lSFaJI2n5Uwvlbi6kjzXW07O
	jDtSe1WY/oSZxAJGfQ8oKZcs4tHSfNY/vLdDnU++gHUXpSmPEBD1D/WVnvV6728auMyIMhC2EDM
	LFwv2eDzVCRR91A==
X-Received: from jabio27.prod.google.com ([2002:a05:6638:831b:b0:608:c2f0:a34d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1507:b0:4f5:20:d847 with SMTP id 5614622812f47-57a0b64ef2fmr14660562b6e.36.1795477180255;
 Mon, 23 Nov 2026 15:39:40 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:13 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-9-dmatlack@google.com>
Subject: [PATCH v5 08/18] liveupdate: Let file handlers retrieve into an
 existing file
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 61527180005
X-Stat-Signature: j7rjqy5mx91t36f55a3iyws1rppo5n5d
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795477181-842424
X-HE-Meta: U2FsdGVkX18krgQ+rFocYcybA061u5/Kvq0s0IwBx0KYpihya14KK+0mh699M93xkKmJe5JUnCdufzTjrDfsPRxnlYLD2nJ6IHdn7Q+3FD5pjtNA33JOEKMvLcTUshzj8P0sYtuR57cPK9bhxNvEu20v0SmUWarY7+DInvmIbdG/TEUTqTruOlCx1SdVl82HXD8WE2rifa5Gu90qlO7/A0U9Fzec0pTEpeRd9ewIj+iVtuIuPWpm+uokWfe+YifeDd+ER53JbRgnqmGR9gEY+fE4kK73BkwRAgpu9Jr8He0KPI0T3ES6vmoziqK/LNwNt86rPthprY4NdJQAEAw5vW3LL9//tgEXt3o9tfhtpZ4/Uq6fPuph2yAmn2zI6IB3x3Pf0oGvTIfbuaHCzkhvMnyHZ8Opt8PJ0s2HaK42TtUdWohD4U/wUJi52b5FEVKVvPMQmS9nN8hvXGL2Ei5XMTDpDsgUhWOqDyJBA1MuRZ45jSOMyBnG1tvqrhtG3mvqiaRhiZ/mdPTAULNMxOy8Qs83WWfXVfUQnbUGY5sWxgKAzSo88W3ht+5kyaGugYvfLA1aj4gW+JDUgofJnrnE1+pAAUMWbPbqJazWdIwKHY3Fg5dDZpFK+0FRyF3Indda0H2yfQjzkR/2sfBGoJ9HfghNV4Ckl/Yj0yBlOoiqsMNYx17HFzl1xYkcopYaqrNyTlKeRdnRSbOJPUUOzs4kdVMN4OcFTEN1lHiv8b1EUbNSbVWDqwHxOc9BtBH/vjmWWM6DbjSTsYyZrc+erE1fFim2rpFj+90KrFcKVEeagdnhiR9+dmyZh1qFtAy9h8Htn4pwfucIa9vhkAcN+Ba0q9En42A+bb6hJoHpLCvuNflkcYoxVSszL985RYUcWqWxGUvFUa4umJe7G7i0FOmG9IZQrSzBGgsc9H2gVc9zJdwuVDrOy/WoUARWldJUVw2K5NOphdUl44MH/ZDDVLq
 b7cc0QJq
 NBQcrHTjoPteZNkVoSScD38pfBsW3JfJFvh2H0vQJxcB+NrQJ6/Lkb8LNSkQKcuX2su5El8Xfi8Jt1i2WbYSS7zwMFVP0nFneY/Rl9zdxS0mW5Yf31oUWAgLPlcjYcNO/g51Tjr5qe+pTGs8USzFPVQbJ6CJ98KJwVBE793l/wv9/p6UejFxEiG2GAb9EqLqzw07s9CBTs4nel3lZ6U6X+l3B07wtpBx6m8ZBueU90B9XExve9Bu3EAfQNB/clh/pOY6S7j8m70WL5TjXv3fPEVR3wCWcC0Rm+mNnQwwohcNxiz0Nv/Oo12EXhQ5WAuwlvstlzoTcmTY6ppnSdD8A46+DlbSUcVvUlsyuZ2zbPrsPx4kGO9UTKbQdHWYb9OFjowGNSl4+wUCozwxRa8e13Ts0PAHZRxhq1FrXebfSvTWS4Og/c+oWe5dtM7N2NSKczq3TCvcgh7x7NA0ANgmussO9UOGyayOIaRT+nsPEDgEFO1pLwStZzcPtahC/ydgoQJ1AaAaHNWRfO3zx4gktyWFXjat8xtlELHBnShOiofBDPZFQWNiF0KpQam+faEVkVa4ueQRQAhoO8O+bMIgj3Ho6jdaAGX4hEXCJAjiZMrWrY8bPsMJZI15At37mcNDe8tcGYqJVpYXKkaTq7ovtItLhjzIcyhyi88MdP1xhYGZB0mdk9m/K6WjlcJLKADKgGFyAcxcEZ2MrrK7Cgi4vBVq+uPwNxyaShyYWsUIs38P64wVyFVeYk+3ykml3E0cnnwtvyvZhYhv8IFhv50wAB+p9W7xr66fjq0A7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add liveupdate_claim_file() and liveupdate_unclaim_file(), which a file
handler's .retrieve() callback can use to make LUO manage a file before
restoring the preserved state into it.

LUO starts managing a retrieved file after .retrieve() returns it, and
fails the retrieve if it already manages the file. That works for new
files. The shmem file handler will restore tmpfs files into an existing
file, though, and such a handler has to know that LUO accepts the file
before it modifies it, not after the preserved state is consumed.
Otherwise, it could restore into a file that is preserved in an outgoing
session, or into a file that was already retrieved. Since preserve also
makes LUO manage the file before calling the handler, claiming the file
also keeps a concurrent preserve of the same file from racing with the
retrieve.

If .retrieve() claimed the file it returns, LUO doesn't track it again.
A callback that fails after claiming a file must unclaim it.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/liveupdate.h   | 20 +++++++++++
 kernel/liveupdate/luo_file.c | 67 ++++++++++++++++++++++++++++++++++--
 2 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index e4ad0bf78a5c..03ac06a2b24a 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -79,6 +79,8 @@ struct liveupdate_arg_spec {
  *                    to the handler's expected argument size with any trailing
  *                    bytes beyond the user-supplied size zero-filled. Valid
  *                    only for the duration of the callback.
+ * @claimed:          For .retrieve(): Set while the callback has claimed a file
+ *                    with liveupdate_claim_file(). Private to LUO.
  *
  * This structure bundles all parameters for the file operation callbacks.
  * The 'data' and 'file' fields are used for both input and output.
@@ -92,6 +94,7 @@ struct liveupdate_file_op_args {
 	u64 serialized_data;
 	void *private_data;
 	const void *arg;
+	bool claimed;
 };
 
 /**
@@ -306,6 +309,12 @@ int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
 int liveupdate_get_token_outgoing(struct liveupdate_session *s,
 				  struct file *file, u64 *tokenp);
 
+/* For .retrieve() callbacks that restore into an existing file */
+int liveupdate_claim_file(struct liveupdate_file_op_args *args,
+			  struct file *file);
+void liveupdate_unclaim_file(struct liveupdate_file_op_args *args,
+			     struct file *file);
+
 #else /* CONFIG_LIVEUPDATE */
 
 static inline bool liveupdate_enabled(void)
@@ -370,5 +379,16 @@ static inline int liveupdate_get_token_outgoing(struct liveupdate_session *s,
 	return -EOPNOTSUPP;
 }
 
+static inline int liveupdate_claim_file(struct liveupdate_file_op_args *args,
+					struct file *file)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void liveupdate_unclaim_file(struct liveupdate_file_op_args *args,
+					   struct file *file)
+{
+}
+
 #endif /* CONFIG_LIVEUPDATE */
 #endif /* _LINUX_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index d51bd75723fa..82ec05c7d3ce 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -676,6 +676,9 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	err = luo_file->fh->ops->retrieve(&args);
 	kfree(args.arg);
 	if (err) {
+		/* A handler that fails must unclaim the file it claimed. */
+		WARN_ON_ONCE(args.claimed);
+
 		/*
 		 * Keep the error code for later use unless the handler marked
 		 * the failure as retryable (e.g. invalid user argument before
@@ -686,9 +689,14 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		return err;
 	}
 
-	err = luo_track_file(luo_file->fh, args.file);
+	/* A file that the handler claimed is already tracked. */
+	if (!args.claimed)
+		err = luo_track_file(luo_file->fh, args.file);
 	if (err) {
-		/* A retrieved file is new, so it can't be tracked already. */
+		/*
+		 * A retrieved file that the handler didn't claim is new, so it
+		 * can't be tracked already.
+		 */
 		WARN_ON_ONCE(err == -EBUSY);
 
 		/*
@@ -1093,3 +1101,58 @@ int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
 				 token, NULL, filep);
 }
 EXPORT_SYMBOL_GPL(liveupdate_get_file_incoming);
+
+/**
+ * liveupdate_claim_file - Claim the file that the preserved state is restored
+ *                         into.
+ * @args: The arguments of the .retrieve() callback.
+ * @file: The existing file that the callback restores the preserved state into.
+ *
+ * LUO starts managing the file that .retrieve() returns after the callback,
+ * and a file can only be managed once. A handler that restores the preserved
+ * state into an existing file, instead of a new one, must call this before
+ * modifying @file, so that a file that LUO already manages is rejected before
+ * the preserved state is consumed. For example, @file could be preserved in an
+ * outgoing session, or be another retrieved file.
+ *
+ * After a successful claim, the callback must either return @file in
+ * @args->file, or call liveupdate_unclaim_file() and fail.
+ *
+ * Context: Can only be called from a .retrieve() callback.
+ * Return: 0 on success, -EBUSY if LUO already manages @file, or another
+ *         negative errno on failure.
+ */
+int liveupdate_claim_file(struct liveupdate_file_op_args *args,
+			  struct file *file)
+{
+	int err;
+
+	if (WARN_ON_ONCE(args->claimed))
+		return -EINVAL;
+
+	err = luo_track_file(args->handler, file);
+	if (err)
+		return err;
+
+	args->claimed = true;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(liveupdate_claim_file);
+
+/**
+ * liveupdate_unclaim_file - Undo liveupdate_claim_file().
+ * @args: The arguments of the .retrieve() callback.
+ * @file: The file that was claimed.
+ *
+ * Context: Can only be called from a .retrieve() callback.
+ */
+void liveupdate_unclaim_file(struct liveupdate_file_op_args *args,
+			     struct file *file)
+{
+	if (WARN_ON_ONCE(!args->claimed))
+		return;
+
+	luo_untrack_file(args->handler, file);
+	args->claimed = false;
+}
+EXPORT_SYMBOL_GPL(liveupdate_unclaim_file);
-- 
2.56.1.809.ga0b61035b5-goog


