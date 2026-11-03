Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBCCE606D831
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Qs2+p/0y
Received: by kanga.kvack.org (Postfix)
	id 18EC26B05C4; Mon,  2 Nov 2026 20:02:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F10E6B05C5; Mon,  2 Nov 2026 20:02:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3196B05C6; Mon,  2 Nov 2026 20:02:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EEAE6B05C4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:02:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0849F1A02BE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:30 +0000 (UTC)
X-FDA: 85392007260.08.144E708
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf26.hostedemail.com (Postfix) with ESMTP id 45CE614000B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="Qs2+p/0y";
	spf=pass (imf26.hostedemail.com: domain of 3ojLpaggKCAsoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3ojLpaggKCAsoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667748;
	b=NTvizsze+Lek9fJlTHuQasdvQw/Ilee3FzEE/YwxonGRoeOsmazixZdh/TjH7uApx3DiOb
	F3k0b6b9ZAt2WgMdC0mV/96XxHPDfp3bZzistSN3wvdo7N8aGHA9xyAPy8DzNBddBwxmJB
	7OlYJ2OSUOuzBD/YgcwrNLx76GiTGT4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="Qs2+p/0y";
	spf=pass (imf26.hostedemail.com: domain of 3ojLpaggKCAsoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3ojLpaggKCAsoxl4wlnvrzzrwp.nzxwty58-xxv6lnv.z2r@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ydFgwH1RqwYD9oLhXsqCdCYSovd4C0lCZbr6jb/QI/s=;
	b=DF4NP3IRhZgIcsjLmpXvOCKjHeN31FIdJUdZ1GSfh8omp6vLmiPUqVga/II9cbeTWKrVXh
	ZnhJyPYHWTez+H20CEfAE1m4Eramy8XKN5L/PPBBMeHDX/LKXjscfHX/TdaJZXTTNw+7Da
	zF3mEpNvzYqB76JglPKIpe0A5U54SBs=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e94f72fb9fso35519945ad.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793667747; x=1794272547; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ydFgwH1RqwYD9oLhXsqCdCYSovd4C0lCZbr6jb/QI/s=;
        b=Qs2+p/0yZw84oA+/GRiHtPua52TN3YLWiO2rX60BZnoFlwtsRH/T5c+h7xHnF04WdP
         rv+leR1Ko229e6T85PGUFDV5CK4n5PUE30xwaNYh1x52ojdAy3hGazpVQqyK5asEUKKW
         q5ok3AAz2tdlRn0llP7Db+q+lQGSatWS7RInzodlJJdK/rDDK1Z7GYuWOkt9Rv+bG2Sq
         8hW9cAC+6ek7HcKGUlnbcBMNza+Bge2bFs7MMa/8haUdwTFdNUrU23cIPxwOXVNaOME0
         XLYD/LpgMPDaQczACX2lifQU4A0VGFDYdphduEFt36w/PMv9EHbx4aHjkAS9cRKt3zJE
         Xt9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793667747; x=1794272547;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ydFgwH1RqwYD9oLhXsqCdCYSovd4C0lCZbr6jb/QI/s=;
        b=Wpcs8BAp+AeiwfOvCU7QtulIla6gFO7slc6Qw01wHzMnTZaoabFqdsNz+uPvGyzAto
         qaSc3efkOn00IUchjUtU2c+Y8Bb4k/nL2ELwNLI2IRv3TO6wGqkJLr9XQUpGOuh7tF68
         j7E7whcQELqso4Ylb+zprbLFuvJYfAXGGRKg//lXswOG7CGOX68FvBtkeAKUeK5xrSvZ
         4HtGNicBRkW526HtAtz/eu1cd6zC813wZxh3fXrJE90ZguiFzgwun1S2Y6P0NXiQBF0J
         c8vJXDSjEDVd9RkrYoYBXeCLZORsqqA9HydHqWKwTb/ZesnxwKn4TAjvExSaeMPeumwu
         nY8A==
X-Forwarded-Encrypted: i=1; AKwUvBy0kclwfxznJQFZTpE4BLZp/Ko9+awC1XU6scR1u8msz3I9uDFcbUqxt5hqtr9tyoDXvNDI+FF94Q==@kvack.org
X-Gm-Message-State: APuU4Z/81clqwZMHLr64l9zjLU9omdzOlGx7lgTXUTZEiRTyuzca/KL8
	DipI9kLDQ5Be+hyfOtW5E7vS3jq7CQz9RpFYQpPTJ8CAHVwGTn4C59KOFECR/r3Y1u2I0pneQN1
	urcw9Fpyl8xesiA==
X-Received: from plyw9.prod.google.com ([2002:a17:902:d709:b0:2e9:7e8e:b72e])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2f8c:b0:2e8:295c:f03d with SMTP id d9443c01a7336-2eb364f2b64mr122067965ad.58.1793667746894;
 Mon, 02 Nov 2026 17:02:26 -0800 (PST)
Date: Tue,  3 Nov 2026 01:02:09 +0000
In-Reply-To: <20261103010216.3447716-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261103010216.3447716-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103010216.3447716-4-dmatlack@google.com>
Subject: [PATCH v3 03/10] liveupdate: Allow file handlers to mark retrieve
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
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 45CE614000B
X-Stat-Signature: tk1pof1yx1wpxt8ygnksuer313uq16dq
X-Rspam-User: 
X-HE-Tag: 1793667748-548521
X-HE-Meta: U2FsdGVkX1/aE+iqu22ZXkpYBiQJZdbPt7dcqSrRogh5Z2+JegScq7gzpXYZsqrMp0Sn/p6yeGsOzQIHGURAPyxkEwi5jPIClyB5Xn+nXXEb0n8OCHQ+CkXpr8ZCRhNIE6QkFLkQG1O3p0l1A1eujGm0BDLYH5RMlCt5MYFxXGsg4/wd5K4kd7sR8r6Yc8HrVzqdFXx3AxPdOV6IBuyFHxOYtaVXr5Aw0Y5zY76sntRcl7DaVQSa/YlYbVVrwlIqqNR+d1NIO4LYm9p2GSa/2kl/8CydP9cybRPdpDQJwz7NWNE5w+kIdwpdzVQ7nAqN62T4I4qLrs6c5Z96Uv+WgM+Ve8KwubPVc8MkrHX/Y33Fcf2RdelqUWuYPW/lWh7GplDoIB3sKeg6WxXFbUPLlL1QjopUVQdJLPjmwVwoAnkTNrTgZNdV0b0B6QyzTZyyogXk/Fe8gw2+eSMomVKZgmhnPfYTtnUZM8kSvxBw0d8QNH6+A5rKyzT4lPTLcynbIsZx84W3MlqMFIuq5tz0XpNKl9Nk7W/v+21JfYdF1IqX//tC3V4ZXxshVyCFsrUTd+6fnNa/o44kBumgHPgypesxT5bTukVEbonTt9vSsoRsMl0eUqGdrl5mogvW9N9VVEgSUFJ85p+0nVjb+/7kZiWw57y6ZGg2VYtil4ZEapoFTGy2R9zr/zlVlyQk30ljFjzBzfdHE7J3liGolC4/n2OD6ubsnAz5yCqoPDYdRoQ0thohwpBWfZZqFO3kyftZjjjhEvos54ojeAI7InQvc5wBRqWTIx1b9xiredKg1iJHBUVSh7c0xOvYU7+Bid7mwyE0/2fmEFZFX6ntyy8pE/MmmQObK6xWFraiqktvnng79en9jkhla3QxuxD2eeBUnWzoES8nAupp41l7n6vL59KzH1S+oN0Is2YBOXWHJnlAJdASEQ0N5E5N8LElETXq8tD3MPm8s3MPHeWvNaB
 nfglIO49
 6gVur/RPcq6Q5o23jAldl0DVBCdPG0C1UN1VHLywyXBfCHQNw/FOIugNw+FRl0p0oPB2i0YyC46kdcrrxn1twU1qdWsQ+mT1WcENDqveV4Iqmw/Sb1fqV0NUSe4b77BWB2H8PirP2iuaPAw3/Bacnu+uHmtuKzyleRb1LW6NoxC2eW9BJ7ZV7zR3oXaZyf7Zzsm8ITs2qfjG0eQJFASKaMSM9BahiNpebn+QrDrVwcooYy9tT8dXT4NaPTF4pwOJCsJTAVpdKBcmkaQ4VInnf4MTMzFiH+1BUfD5KeB1RtPaZHsz6471Q87ODLSyQO48gw9kXbrNw9rcGPgi7JNdDg1KKukE/L50HJXexAueItrAFSjhtQiEu/W/ifH2otD+Lw8jE/i9yjLlmovz6YkK52CI3IA2vmkiTm7GJJFRu/w2hMZhtOn7nd8ky75bIse4JJEMRh6TCCWwTAlL216WsGyD8skN9YIBijeuKpXYWiOuCuP8rgBadJP0ygYK8w4YJNCtSm0EoluGFO2STBaXTHOYZ9hGOcN8iAn7WOT4g/tAqvCaU509LB8EB5UKZKtSFWRKFXA04OijHsTarF78gzxfxBsfL4JSf1w4RTk0X7X2PQ2YezFipFx5NAGd3ybwYgIYANYaQHJUxGVwWXNKlJPNwKw==
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
2.56.0.385.gac671c819a-goog


