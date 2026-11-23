Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7626C606A698
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BttjuyqB
Received: by kanga.kvack.org (Postfix)
	id AF2676B05B5; Mon, 23 Nov 2026 18:39:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7D4D6B05B6; Mon, 23 Nov 2026 18:39:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945976B05B7; Mon, 23 Nov 2026 18:39:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 613DF6B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43CDE120A0D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:37 +0000 (UTC)
X-FDA: 85468003194.19.4B365E0
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7B6EFC0004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=BttjuyqB;
	spf=pass (imf28.hostedemail.com: domain of 3ts4EawgKCMUoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3ts4EawgKCMUoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477175;
	b=wnI5PKYK2yuDU8LXc9icFM6QuHLVwKZY9wX4VjCLGkZPoRZ3Np2xlR4qlLHPZvJ3zO1IN+
	+VKsIbXpp2Vmn5KYfIZjhB/ZrXNgF8OvHeQpfhMnoTWB7kA62dxyOJAVSSU8K5LGb9kgTA
	DayqGUPA5dUXXDDy7VK9H4/9SA98FdE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AwhDL8d9Iaq27a1JowEPw9jFEWG4nyWIagv2/If4Hg=;
	b=DWcO7EcNhbnNKMbbZmuEXAMIVW9dTawiMeOfs8+lnjyltEwF0R8ePPE5Lzntvr1StRxbaJ
	Ju5D6MGDt2Y/vy4bcniCFAXVgLsWWjplzzv3Os6tsZlAdz46yxoBlnlUGehUJpmSGUrniW
	S8B8VuokVTXDGjqbaTKgXOZYPJh8fMM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=BttjuyqB;
	spf=pass (imf28.hostedemail.com: domain of 3ts4EawgKCMUoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com designates 209.85.210.72 as permitted sender) smtp.mailfrom=3ts4EawgKCMUoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-862a543c4bcso4232580a34.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477174; x=1796081974; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1AwhDL8d9Iaq27a1JowEPw9jFEWG4nyWIagv2/If4Hg=;
        b=BttjuyqBbFewV6sTfvhbRxBlNnDJUirJMtpfJfFEdOEA9orn+PLXv+M6Q+loGWLSLg
         /wVdqU2843EjrSwrO4N1cc4xm+IF5XlOuDyzZ/DYC3dWScLjNjylWCUWRVskwPS+v34J
         NDoFENZ+UQZ3fH2jkogWq1WCNc/iC37/CGAWTv7mfLjymdlJaLZLlaY8qC4kH4ZJSdLb
         rH2MMJYYTTPW9chzk/eV7t61Lys7RBfJKrgcS8s7T9YNrd9FdlCTvKQdx5hLAURIEGEX
         363Kjpq5wc159Ah5VPoLAxdp5cRjUxtG+eHLoUFMkap4mdRJiuKMxUiWJY0sIuoc5YHS
         q7hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477174; x=1796081974;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1AwhDL8d9Iaq27a1JowEPw9jFEWG4nyWIagv2/If4Hg=;
        b=XVZXNxNI/IIi2Is6j8mafJi9z4M0osg7/Qzi/N4HEWCswdl+XRtFteNr+NMCLCHMuR
         Spqgd4/AhEdjExFdZ3TbpdxqsKx/jautDgouyFFLdE4hCaEyhhGkwt42Uu7itpX/zDo6
         Tj9+tEWeMOB7cba3yPfc70KFng3LOfm3L0sbB4YB2qLS6m8I+Y8H1RKoG6bxPW9t0Qk7
         F6W86MpbJPIL4lnplV8YPVbQ6jqUV1e8bdstuuO2pyL/evwotFDQgmFcsx32BHt7+2xw
         uiOILtkgKbogDRIy8s0qOytxmts+sJVQ/S9SihFPC15+8EAwp18h4tW3oKVqq4QfuCCE
         HYmw==
X-Forwarded-Encrypted: i=1; AL+hErEMedR1ggoAuR+wZJdim5sPGppvc9DMniySSkDl0GP0HquRIVnx4HmdtZ5/gA49iw9FeDVFVbHztg==@kvack.org
X-Gm-Message-State: APuU4Z+GI1OcW6gyFOPND/YWlNSMdBbCsirnG9UvPCS2FXZ2FaPR+53L
	Q90sJXJjDOfwRXCavxXgnCaLwMNMma8w3VFs6E3EaCDJyi8KEl6DxdUdw8RLrit61s0GD5VzLUJ
	mBKqZvRlbFo3Srw==
X-Received: from iofz21-n1.prod.google.com ([2002:a05:6602:8515:10b0:9ca:727a:80b2])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1310:b0:56a:608:c445 with SMTP id 5614622812f47-57a0b95a622mr12887442b6e.51.1795477174130;
 Mon, 23 Nov 2026 15:39:34 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:09 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-5-dmatlack@google.com>
Subject: [PATCH v5 04/18] liveupdate: Allow file handlers to mark retrieve
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
X-Stat-Signature: 19agm8ut49zisyz3dr41y5mgqdih8nsy
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7B6EFC0004
X-HE-Tag: 1795477175-105498
X-HE-Meta: U2FsdGVkX190I9NySKhg9y/UOZ+BKdzxpJXVS8AcmvG4O6LjhWSYulDFEyh03d2nIbUh0Zzze7fFxWEhowI0rh0VswdXC/yBczhfLdUdFFZCimrBQhIOqMcXiBBamxKJfZTP/MACSD1rTgAPbhoBiJCBifcI4I9IS28TlNtPeX4taC5WTS09rUYIlrPoZcsHf5NajGYLeEEuuYjkPm6Da1cpLo2mEC0CZsjzy56TyQtVSyinsqxdFWTewEPdvmcNTq3txVpFNFEeKSy3qV2PGXMbrk7Ip2DmEEysxqza6pLRKWETPXqtof6z2BZRNN1blUqS09kcMmnxm5FqnYhKKsRmGyO9Mr+U10RVEBpZpV2Zu6AaA1DFNoPjYDC6GSXfyvr8UYPfUTshemaJG+BLLk743Xx9toC2dCTXehVEPFvwdtujawqZjyf8GTSZ933tww0at/YhwiG49Xo71p7RdfVdvmb5xFZWAtp6XmGaWpMCplw1wPTCHGIuS79tmvQHdCrHU6tFVtRDLZ2ZoutlF6T0ORZ3HBKNwYg0YccxzFa8j8HO+w0H4wpMfdyqabGmyTcfA4CSOx2ZG6TVfwqyeb+Wiltmopd2OJNyCB2cu68Lh66gULQL56sCUy4j2lD7VmyRhrntAbrzlDzXOXP+NLdwa8wmcz/vUHGDph+X7Pzn0r6cLC7Al3ken7M/sOw/pdL3rphD80geePz8U9jsXO29SB39lA5ocslAgufoJvamLybkEdauwLFFWLoNJEYsBixfpBuhJOOE8hRDnsv3DajI6qYZGgBUZbL9rW88++AljPG1Yw+IqLohHUAamBul+yzu3U3+ehZT4kEo8jFcXnL9OzNjC2myF1U5QhoZ4fUexBKNYMgjmk+vWba+IYmlWYfjCzQEIPkI3Ny8PlaqggWtCXDjaGwl6pyys9jD/xEzlZ784WixbfcKR5eUtSKLaTbXWEX5gZ68arsVTUT
 fa38Zki8
 +zo5OVSsCKKYR5wklzWJhWIqzs8Vy3JKzsyxftnOwMhNxE2fNahKBuecTuwTBeWpZwc6reDjR2aFrrZmXRBw43acTdSsZkEyHRiqN8LljTxdpHWH9Iq8TVy1osZ/4vdX7Zih7yKdFYj95MGOk+dxOUt588Gj5j0JRg2Mj7v5GgtO5cqCGpTnUl8yBpWLXL9r7cLZFCPKy39sVxNJAozyXVFWHzaNIPhT/Ka0tVCGZYsz75vUMAODPblxXqckPvB9vWg9hA2kfwN+k1Xrg8ojE8IXAHs659NOkJcvqMp2lNaJhQbut1mk4AMKq8+Fyi2ISZLtkGF57oZi5Q2Bg8g/NKfUp0UEoB9Rv+Bmu6W08KGfXkzjG4fpOTtF4GWcQMwqAYdpY0+38MS+ljEPrKHhOxj/n68zyzck7emMu/lvs3SxIsw0f3F6eBngvJ83+XJKa4OZ8wzEy04BhdC2Yz168g1c3Bvy/rMCicsU7+i+u/YAgBVKmTXTrGse/M/IICCxTOygqBAzk8JO3iBOOcPYuGSpXXaqyGS5hN6usmWyKXoumjLfNMUXz7MOi84W4/ppNoyFAk/unWCbozv9zlwZSWp4h0O/qVJqGKw9CwU1FQC8ltd8GGQTN7SS92ENwf2kygFcBBG2k6P2yrhf7NAM1UTAAr0JgehnGVMl6sK/jgjN+eU2VZpzfvE2qLaBO20lKnfmvsZowJWN9xibMvMHjwZ0M/KDPjR65aKYNkMMABwJkaX/Cs7OkQeApTyEAo1H7JJwT5cXzx5I5C+GW9eEF0wLqXKWk0CJHjnklH2PgiKmfExrEfMV1mCg+AefCnn/2MfqdpX2qXhEJKSfI4/tZ6JFAlhJGQmB0PhwCKfwu3IMiAG0=
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
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
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
index a460f4cdb608..38ba1cf23d2c 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -178,9 +178,11 @@ struct liveupdate_session_preserve_fd {
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
index 3987ab86a3c1..9d98438b0166 100644
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
@@ -594,7 +595,9 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
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
@@ -662,8 +665,13 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
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
2.56.1.809.ga0b61035b5-goog


