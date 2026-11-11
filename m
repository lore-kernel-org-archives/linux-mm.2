Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A88E560A6F4F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=j2+ccXYt
Received: by kanga.kvack.org (Postfix)
	id ED8B56B05B4; Tue, 10 Nov 2026 19:24:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87A66B05B7; Tue, 10 Nov 2026 19:24:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2F276B05B4; Tue, 10 Nov 2026 19:24:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A136C6B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:15 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32F6914017D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:15 +0000 (UTC)
X-FDA: 85420941270.28.A8A0957
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	by imf21.hostedemail.com (Postfix) with ESMTP id 64B001C0006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=j2+ccXYt;
	spf=pass (imf21.hostedemail.com: domain of 3rLXzaggKCEUkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com designates 209.85.210.69 as permitted sender) smtp.mailfrom=3rLXzaggKCEUkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XT74yUDszl/ziK0mi3MJ4vZ5wlDvYd0idF7CJlDoa8U=;
	b=HMl24HsR9KmSkwvIxkiZdI8N7Sie/BHbvHK4+uwIzI+Vi5vXy80+I59mUfnZEs8eS1umZk
	TQeqoHLZRuXq+cnMYTMaL3cMDsJNgqMVU/ih0nz2SuFwugqH3mnMPO5fdwEWb2Vt2zfssi
	Powqj6bmtuABl9AdGOkcDLp1Y1MBgqs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356653;
	b=nSx/QJlj79EUPZD9E8WEXKkTnHBg0pawGIISiIB0HdtvDsRfRe40hiEToOjDalCg1LCNXO
	6z4tXNhDPzqjrerNTkfG+5fhHBV9Csy4FNCMMpKTO0GnIFv9Wi9lwJgPJatHcoyeMii0Bx
	VuuXKJyMIIN1U7aVX74+hzvcMZHKgjc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=j2+ccXYt;
	spf=pass (imf21.hostedemail.com: domain of 3rLXzaggKCEUkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com designates 209.85.210.69 as permitted sender) smtp.mailfrom=3rLXzaggKCEUkth0shjrnvvnsl.jvtspu14-ttr2hjr.vyn@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-84fe2593525so3521101a34.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356652; x=1794961452; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XT74yUDszl/ziK0mi3MJ4vZ5wlDvYd0idF7CJlDoa8U=;
        b=j2+ccXYtrHxMJHIhV8HGZH/YTH0VKFdyPE0LEuV4/dIzOMpeMzfrA2pewdRAXvxWjj
         L4hO9xg3sW4HY0y66968D8BpmlODj4ZE4yVxzcPvkTWIVENztMqzpfPBbvAbPC8dPs50
         hzLQHPsg50Lnanc41geJtThDSVoTGCit1ySQ3poYPhP1kzSeJ4BlvFK89vKaSueSvC64
         VkOyPgucnxB9q3TDT6TuKeHYKYmdwkVe80mJ8Zj0dMvBLCXtvr3kxZQyHGtPNTlqveTn
         e1xhy8iyNCNu/K99vPIJcv4pP64sHpfWmHGDs1OnPggxuZSDsAgKKPQ04+aMdlFTw+m+
         AWbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356652; x=1794961452;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XT74yUDszl/ziK0mi3MJ4vZ5wlDvYd0idF7CJlDoa8U=;
        b=B5Y9rARrIjIWqliPrrmmCf3synFYrc0yc1Pmbi3Bzzx7dCcL/7lfAbwTPOQukfN6Wq
         rjV4Ob1V4ehwoKmJ2JZPhtyUdWURq2n0F2IVa0uM8e1Y5y/4znqT5fizDxXVfFp+s81E
         eQL+ViwTpd+tyot8eFcTGJMsZaswf63ex7mx2M85Y+QF5BbkspaV/nuCdW8VKD+CslpZ
         C2lmL03YNwe6+EJJeYYMhGs82e+DSEb2u649DVvNr3o5Mhyn7cRfEwBuF0XFbZU0FkNV
         6EdtdopeCm4f49UtcWjHrk1YzLciiZt+x6i0qf/gBGBLrTrzvBg0rnTOsv3pcK8keEDh
         jeAg==
X-Forwarded-Encrypted: i=1; AL+hErHuljoEeQkMLnk+GxZXnOlFk6Jwc8Zz+OKxXYo1hhWt1AhCq0hcGCYsQ776XcFrUpNK3ruCpxkWkQ==@kvack.org
X-Gm-Message-State: APuU4Z+KZPcsKLcshLR40jEyGoLyAbQgAj3xIuhTCgjdO7S6+KCJWdU6
	KV6XO6OqsQH9lJuqwJps9RggKZBZJKw/fBjtEi/5ALlTVxeRL0CKrfEMwFW+7Y0HwgMTORG9oB0
	sGThBMKWTWEkLpg==
X-Received: from ilbej4-n2.prod.google.com ([2002:a05:6e02:4e04:20b0:523:a008:3bb])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:2392:b0:4f5:c4b9:dc14 with SMTP id 5614622812f47-56b968d6d45mr569805b6e.13.1794356652192;
 Tue, 10 Nov 2026 16:24:12 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:42 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-5-dmatlack@google.com>
Subject: [PATCH v4 04/19] liveupdate: Allow file handlers to mark retrieve
 failures as retryable
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
X-Rspamd-Server: rspam06
X-Stat-Signature: ninhfmiws9jr875xg4fatd5j71ca6j8q
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 64B001C0006
X-Rspam-User: 
X-HE-Tag: 1794356653-273547
X-HE-Meta: U2FsdGVkX19EK+tAd7Agph+GIZo5zhIVtKkBfYsKAietGmH0GJoUvVzu5cGmf3qArWlUqHYsNSZiU9RvcIi9eDP7LCv5FV/9IR5YkdOHLh0mvpe+VtvBAFlBwOUslUUEVRRA/ki9Z1DWArCDAkYCwT0EkGcVwN19+ejMbnVHw7rVSITsDAroFyTH7iJ2uYULv1P7cxaTDgBR3PPJrqf/HqH0qu7aTuIwh/Oh15/AbfJ6fOLLBSCome51JtyWm5HUuqIZSshtOO/sdJWuOxk/1Y3DW3uMegKnPt2iyw0j61rmBOW2y9+JvdBV28Odfp3XbxWitf9ULJxmgGVSPTZdyCNGp+JaHc40xKmRbc78TmYbXanlnOSl9zSJP6HOIhxikpXRh3UMlBps8HNazl9um7Ccy7he/2Zk3BgmJ6ZOqKMbYv6UIXMuB7214m7eV3Nu7oxHyvEP6VUgSVxhovazc0+aCnBU6VM1/ug62omAmnqP1ORnlEg3/BO/3Ucx1JAPEporua71gmrzLzvk++t+wuVLoYWtiVrVJYZToT8hgiGX26YNZhlD2Y7C8BV5OAJNgidcs0sUAQ/hIZR4Id0XPYLs/xDjWlWEfFMwUs9BAUU7UNsCEBKHv5r6G4szejkAnf1S/36Q/GePLTdVKeDif0X13XKbykaSUDjC9mJ8SFjqKn9MkdfqGHhlWs9KBcDHxfkh3BCxhioYmGUnHVuOOJyBWr9adK3XGOrScPT0hZYI8UhIir96Kx6rSvl/61+fwIFZbp69ePFuCbhVz0FYnCG6lELlOfsVu4QAWdH+D0++zkQ7ONfJ/xhN2uvQv9lZ9D/GypdmP/aOsMi6IAvp2EvsXPgdZ/NtCOJobEqQLRxvjqe/LuaprwF3So733a1QhpEaOjEyjywESVSHz16qDshLu9NTro8dMYyJs/oUsjRLgndyNdLKZbdWnNmHeSB+PMUYX/cCq0zIzBXBHLL
 J9CKjVr9
 rZNy2sOzIMChkBXdNd3pDZCIK7cykyX6EvW7dYkfpbIcIf5pajOEqIykEj3q7BdMTvjCbL489v4KplUFtZZZad5YZMPCGr2XvhiPOUCMaaDNx+iOiaKwRqYSVpQUmQYVOcEK/MYfLQdNBMzJ47nrE9ZCrkrowXLLXQlJofXxOt+HsK6pk4gZ4PY4T75lih51bRshRvTU4JPDBZBp4eUU4qv9pLDQN5uELI9uMBf90J9sH3SsVkMNekiSfIZcPX+U8C++RKVM38jMqluczF84PLeihpwneK+pFcR5HsRFfF98lEN3FLdt1Y0DC46Xnr+SXLHLPdzcEoLjSAiCvabHm131CpjdkDygoem19c4gfPHXye/z4i/oEgezjDgvMRlZNJdpZ9xyBHqVpr4K9Npak0weRTUfFF8CCU5oFKJxwTWuWZfC3/tCLQI6GfRc7IKCTZjLx9m2IY3kudVpp5wH+D7df7ZYHBfCcQOoD9xURukYDFx6TZxMb29Qph/T7hOPx+yrl+fjAcSzFqJDLVGN+DO5lCNawHjAHiC0GPdBIy/e27zfV7z45DoDglRL8+QNjDMsN6qIcReoA0/ChhmK5Mk9isVH53Q/eC+JpL68RqzdMNxpOjquG+C5XdonYoclf+EGkOChIJB5S9uI41MPsstbvYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Pasha Tatashin <pasha.tatashin@soleen.com>

Add a retryable output flag to struct liveupdate_file_op_args, which a
handler's .retrieve() can set on error to tell LUO that it hasn't
consumed the preserved state. LUO then lets userspace retry the
retrieve, and .finish() still releases the preserved state if the file
is never retrieved.

When luo_retrieve_file() invokes a handler's .retrieve() callback and it
returns an error, LUO currently records the error in
luo_file->retrieve_status and blocks any subsequent retrieve attempts.
This is necessary when the handler has already partially consumed or
freed the preserved KHO state.

However, with user arguments passed to .retrieve(), a handler may fail
early while validating caller-supplied parameters, such as a missing or
invalid argument, before touching any preserved KHO state. In such
cases, userspace should be able to fix the argument and retry
LIVEUPDATE_SESSION_RETRIEVE_FD.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/liveupdate.h      | 11 ++++++++---
 include/uapi/linux/liveupdate.h |  8 +++++---
 kernel/liveupdate/luo_file.c    | 20 ++++++++++++++------
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 7543f5d648d3..e4ad0bf78a5c 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -58,9 +58,13 @@ struct liveupdate_arg_spec {
  * @session:          The session this file belongs to.
  * @retrieve_status:  The retrieve status for the 'can_finish / finish'
  *                    operation. A value of 0 means the retrieve has not been
- *                    attempted, a positive value means the retrieve was
- *                    successful, and a negative value means the retrieve failed,
- *                    and the value is the error code of the call.
+ *                    attempted (or only failed with a retryable error), a
+ *                    positive value means the retrieve was successful, and a
+ *                    negative value means the retrieve permanently failed, and
+ *                    the value is the error code of the call.
+ * @retryable:        For .retrieve(): [OUT] Set to true by the callback on
+ *                    error when the preserved state has not been consumed and
+ *                    retrieval may be retried.
  * @file:             The file object. For retrieve: [OUT] The callback sets
  *                    this to the new file. For other ops: [IN] The caller sets
  *                    this to the file being operated on.
@@ -83,6 +87,7 @@ struct liveupdate_file_op_args {
 	struct liveupdate_file_handler *handler;
 	struct liveupdate_session *session;
 	int retrieve_status;
+	bool retryable;
 	struct file *file;
 	u64 serialized_data;
 	void *private_data;
diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 87e77c3bfd82..7420e2c5434b 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -174,9 +174,11 @@ struct liveupdate_session_preserve_fd {
  * associated with the token and populates the @fd field with a new file
  * descriptor referencing the restored resource in the current (new) kernel.
  * This operation must be performed *before* signaling completion via
- * %LIVEUPDATE_IOCTL_FINISH. If a retrieve of a token fails, subsequent
- * attempts to retrieve the token fail with the same error code. Failed
- * retrieves are not retried.
+ * %LIVEUPDATE_IOCTL_FINISH. If a retrieve of a token fails after consuming
+ * preserved state, subsequent attempts to retrieve the token fail with the
+ * same error code. A file handler may instead leave the token intact on errors
+ * that occur before it consumes the preserved state, e.g. an invalid @arg, so
+ * that the retrieve can be retried. See the documentation of the file handler.
  *
  * Retrieving a token that was already retrieved successfully returns a new file
  * descriptor for the same file. Passing a non-zero @arg in that case fails
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 1437630d435e..0c9a3b6921d1 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -152,9 +152,10 @@ static DEFINE_XARRAY(luo_preserved_files);
  * @retrieve_status: Status code indicating whether a user/kernel in the new kernel has
  *                 successfully called retrieve() on this file. This prevents
  *                 multiple retrieval attempts. A value of 0 means a retrieve()
- *                 has not been attempted, a positive value means the retrieve()
- *                 was successful, and a negative value means the retrieve()
- *                 failed, and the value is the error code of the call.
+ *                 has not been attempted (or only failed with a retryable
+ *                 error), a positive value means the retrieve() was successful,
+ *                 and a negative value means the retrieve() permanently failed,
+ *                 and the value is the error code of the call.
  * @mutex:         A mutex that protects the fields of this specific instance
  *                 (e.g., @retrieved, @file), ensuring that operations like
  *                 retrieving or finishing a file are atomic.
@@ -588,7 +589,9 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
  * The operation is idempotent: if a file has already been successfully
  * retrieved, this function will simply return a pointer to the existing
  * 'struct file' and report success without re-executing the retrieve
- * operation. This is handled by checking the 'retrieved' flag under a lock.
+ * operation. If a previous retrieve failed permanently, it returns that
+ * saved error code; if a previous retrieve failed with a retryable error
+ * before consuming preserved state, the retrieve operation is re-attempted.
  *
  * File retrieval can happen in any order; it is not bound by the order of
  * preservation.
@@ -655,8 +658,13 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	err = luo_file->fh->ops->retrieve(&args);
 	kfree(args.arg);
 	if (err) {
-		/* Keep the error code for later use. */
-		luo_file->retrieve_status = err;
+		/*
+		 * Keep the error code for later use unless the handler marked
+		 * the failure as retryable (e.g. invalid user argument before
+		 * preserved state was consumed).
+		 */
+		if (!args.retryable)
+			luo_file->retrieve_status = err;
 		return err;
 	}
 
-- 
2.56.0.542.g3ef89b7020-goog


