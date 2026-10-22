Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 179B160A2621
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=WJ0zFTXa
Received: by kanga.kvack.org (Postfix)
	id CA22D6B0A06; Thu, 22 Oct 2026 18:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A176B0A08; Thu, 22 Oct 2026 18:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACCA86B0A09; Thu, 22 Oct 2026 18:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0AF6B0A06
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:50:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B999E160332
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:50:43 +0000 (UTC)
X-FDA: 85351758366.10.8ABC81D
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0DE24C0009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:50:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WJ0zFTXa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3QJPaaggKCC8OXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3QJPaaggKCC8OXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792709442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZxtqEGpizmVFkbAIWqB2ioSJ0+pXS1WhHyAhjSgL0fY=;
	b=z8TzJSyCYYiKkgRlDpSZY/X1gpWWe7bperrJjeM7cdC58UkFhSV2cFE0LKPsJfHkW2M6Be
	/ozsqNiOELwq+dTS4pX4jnzyz+grn07bynBowTq+0ko4l4ju6kLa+LSCHBsMHGSclCrbgI
	zgMD2GMJ3jHVyseo93xxKzZ6NO40fvY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WJ0zFTXa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3QJPaaggKCC8OXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3QJPaaggKCC8OXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792709442;
	b=E/SqebD7gUuAwKeSGKIZpB1MdNrj8pxaxyDpUHvwrjwDu8fv2+7frU7L3lliIvx8HKfegZ
	mkHf9umBFL5dnNAlIDhuxsCiMnpNoZaOV/bwjzsakSuomXlahYAZ6zM6NaA4dIy1cJA3Q3
	Xgt4/zRaMiyQN7wriRzZDflVkjCEtXc=
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-89e6ddd4554so212298b3a.3
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792709441; x=1793314241; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZxtqEGpizmVFkbAIWqB2ioSJ0+pXS1WhHyAhjSgL0fY=;
        b=WJ0zFTXaGiyPezBzGbxHtENsfgHJ8MVG7UToEtOGBlDIDAAH3D28EQHBZYI7QzF1E/
         bYK9nUKGRR5qfFkRYLO4tKp0c/DzK4v5TRXutdvj/nGemSn5Ut8o0rP2rVC9kUb1eFER
         NxuUYXVH3/xadE+qta268f2eocz51BZSj7Bf0Dh0xzwO9VCT1WONH0WrWhy7x7NwkCea
         Vrru2tu/rc/uyWnivLf5DvlYUTNpE9Tteb4oRILM5HxTWq0OO4QIStPg8Z4cKg1aDiV5
         nTo0wR27rnts+THmCrRu84dt8QK8Sv5tjoo0RN75rQJnd05hgi/3fV1f1bsyhTuhxx6b
         BePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792709441; x=1793314241;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZxtqEGpizmVFkbAIWqB2ioSJ0+pXS1WhHyAhjSgL0fY=;
        b=jnJhaiMZeiFUXrTzk2j1LM40nkN0wldWLeG+ES+DhM0g6bDhHJIy07dq6QEG9cZA9S
         XAY6xDUAdDqIMNNXx2uzm4gXhGxHugGrfba/DmfOjkHcj2Nj1I3d82QEAaiPiZAzeYKd
         zk2aJQtPYwwgvQqM7IfhvfwUpXIriCWSJVA2owYlgZGHjIuoiYMJsaFZcvekLFZ6nVtY
         zAyhv48ywa0R8lMGLBk9m/65yiMlYYujq0xLwtiv2KwjYz1gXRdaV/XpnqAZKBL/KjGs
         unMSsCv1zg8dAFt6VysABz2BYcmwpxJgKLOJhyhFJGa+gfpV1nc006riI3eL3vd9VQk5
         MoRw==
X-Forwarded-Encrypted: i=1; AKwUvBw/sKhJ6681P1fvqWsiPIHyN53SsyEWkgKKOYrFD2QeSWo/0o8AsAqcFeBuMsSypID0G2xlGXLPLA==@kvack.org
X-Gm-Message-State: AFq9FYLrKECSAhe4gsecRC8TBK8dy9YLi4+1F/jL00nacmNTxoEmb8bU
	RF6Lrz+B/P5Ep75Xc06fSJ+fBKNsGkRU6SXPZQIFTvg64Bj0vqyC2D9aSKfvmukwfC6nUlwDMAE
	wTJxjZ79EGtStIw==
X-Received: from pgfd7-n1.prod.google.com ([2002:a05:6a02:6547:10b0:cc7:d1fb:4ccd])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:d81a:b0:3e2:6825:beec with SMTP id adf61e73a8af0-3e369227d0bmr279978637.19.1792709440800;
 Thu, 22 Oct 2026 15:50:40 -0700 (PDT)
Date: Thu, 22 Oct 2026 22:50:28 +0000
In-Reply-To: <20261022225035.377445-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261022225035.377445-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022225035.377445-4-dmatlack@google.com>
Subject: [PATCH v2 03/10] liveupdate: Allow file handlers to mark retrieve
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
X-Rspamd-Queue-Id: 0DE24C0009
X-Stat-Signature: zkra9ccm1sziajrh6entw1gg4tezoomw
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792709441-200422
X-HE-Meta: U2FsdGVkX18eyMQfY8QZsLCVfl3uXo4dp0foUtcWUd/8qMip+pfVk7+nJ2HZrn73In7YlTsXclZNXDAWEBylKD3TbBfBOCveQrtyu5qW+LH6mRFWDTYpkTXtNUMolbpP5CDrRe3oM9JYTHCvofuTo9XtnkmzoDGvxkmteO07sDKFdBoyslnPdDO856U6IQen2RdFEr3f2MB2N7+0pMnmZ0+fCPFz77/X19maJCkDY5km2OVdyPE+lSwomya/ZrCrYt2IoyK53jpC/YzKCNfBJUH/WZZyjAc3iud2/LTgAXo3OWTjfRjQz1dtQHYgi6ME/9dCqNdM6FjK2WlprzWRai7UUAbtGgUn19c4Kj+hh/3KkI39CX0mxFd/ynTSk2hfWj5REcQa5Y37bCyw7EwJ8qUQTSr48i1fqahdGZepW3qasr6GusruVJPkSrKfXU7JWedcKkV05EMcX+KPfhx1KE854QVhlidIEjgqkc2t+61Vi69wMXovk0pRjefvxLa9JE9N6FBQ330lQMQct9E+JY+7oeolaogylvjUjv3+6ecYXNNGFQYAXt0V5xfkXl8gw6PG+xwF73bkRUiYxy7A/rXjzctgkcVUoqvKElUnIqUe/ytt6l2W7alZCGaLV8YPrr/lF3JRXOPRoHyBdkBFW6vk3a9JtaJASEHs7DrQpmy9lWLROmoRKcqeWUtopE4holkyj8xS6Hmob7t4HAtPi2fxtBgaZ31WhoUatMn3g5ZmyEOvhEVRVDmG5Lnm82w1xbqBR4AvjQsO1IFI1thpgi+L+CkiL4u9OQ7v0fgcQ1isdjYL7vyzspPQoawYy9mEXH4n6z2M4Hq9bq+bH/tP3nZ6IgOTKSwIF7chsvyRi5cm1LEkFWc8Myqvb+iwaYDmcGL8H+7kxmUSic8kVdfCEerOjWP9okAMuVQtJrST6ZjU6J0fw2fCYrH5IldoiFSXDyfZwVRS0e3wTpgz5Pd
 hZ37jWoa
 RERkm/mU4AGJlbwl7tcomw+D7z9CMc24m68svPoyW6r1QD3zLi1hIXxCYS1p6pI/1W3t9rIC14+yfYiC+gACNf+5XHSmFjh0AtNbLHKjmHLtPCA82Z2zKc6dpz80nr9wz5ljxu8390kqGCaWBVEaQebXqOHXg/+uKtnBceBdwetlkQQdHWQ3IdLV36qi2j2yxg8cYjIkKwuEt2ZRCFG9+9UcMFbbXM6FZLKD1ns4QY9LHk2hHnJ5d3h1jdvFGZnjJhTRtCxDQ6IVpFJDeOVYejHJOhv3scz9e05mh4KSBN9IkYgCGBJ6sKPr9NHc7pHqKR0Pn0Nczr3wtUVZj8ReBEj3JocZF0LRzq8n8qLC+PrQPb0slyk6OjY2SRR5tll8yF4TCm+9d+GvO7qxvPikP0qQpEtNgTfvb8F5DTRHQRUFRbYVYINAjCoWU4KtcLhBTbESFy4+FtK1oeYi/agZS4ki86GckQESd8JZREl8CHJXRY/KTsid2jpEDlBQ1tNAqM6gi5oGY92M6XJGLsYtBdkzUDPB6cwpPzIH7YG5WftRjQK2imhz9FTYehem/I+oFXSsn17uAjeXeYFEMrZboICepNECpdXF0BD7oW2yXtVgHVza+YKbV5YslWW8f9XFMRhV2VmvzxOfUlpuxyGbKIQbH9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Pasha Tatashin <pasha.tatashin@soleen.com>

When luo_retrieve_file() invokes a handler's .retrieve() callback and it
returns an error, LUO currently records the error in
luo_file->retrieve_status and blocks any subsequent retrieve attempts.
This is necessary when the handler has already partially consumed or
freed the preserved KHO state.

However, with user arguments passed to .retrieve(), a handler may fail
early while validating caller-supplied parameters (such as a missing
argument, an invalid or read-only target file descriptor, or a non-empty
target file) before touching any preserved KHO state. In such cases,
userspace should be able to fix the argument and retry
LIVEUPDATE_SESSION_RETRIEVE_FD, and if the file is never retrieved,
.finish() must still run to release the preserved KHO state.

Add a retryable output flag to struct liveupdate_file_op_args. When a
handler sets args->retryable = true on error, luo_retrieve_file() leaves
luo_file->retrieve_status at 0 so the retrieve operation can be retried
and .finish() will still clean up the unconsumed preserved state if the
session is finished without retrieving the file.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/liveupdate.h      | 11 ++++++++---
 include/uapi/linux/liveupdate.h |  7 ++++---
 kernel/liveupdate/luo_file.c    | 20 ++++++++++++++------
 3 files changed, 26 insertions(+), 12 deletions(-)

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
index e806752c2fc6..953ffe0823be 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -174,9 +174,10 @@ struct liveupdate_session_preserve_fd {
  * associated with the token and populates the @fd field with a new file
  * descriptor referencing the restored resource in the current (new) kernel.
  * This operation must be performed *before* signaling completion via
- * %LIVEUPDATE_IOCTL_FINISH. If a retrieve of a token fails, subsequent
- * attempts to retrieve the token fail with the same error code. Failed
- * retrieves are not retried.
+ * %LIVEUPDATE_IOCTL_FINISH. If a retrieve of a token fails after consuming
+ * preserved state, subsequent attempts to retrieve the token fail with the
+ * same error code. Early argument or target validation errors before
+ * preserved state is consumed leave the token intact and may be retried.
  *
  * Retrieving a token that was already retrieved successfully returns a new file
  * descriptor for the same file. The @arg only applies to the retrieve that
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index eeeb3b5ff2fa..908ae124ea5e 100644
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
@@ -604,7 +605,9 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
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
@@ -671,8 +674,13 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token, u64 arg,
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
2.56.0.257.gf7497c7d27-goog


