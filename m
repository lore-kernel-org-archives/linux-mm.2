Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0FB3606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=RiMwwKTs
Received: by kanga.kvack.org (Postfix)
	id 931EB6B05B9; Tue, 10 Nov 2026 19:24:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 908AF6B05BA; Tue, 10 Nov 2026 19:24:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F7976B05BB; Tue, 10 Nov 2026 19:24:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4637B6B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:21 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BEA251601B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:20 +0000 (UTC)
X-FDA: 85420941480.03.E21A952
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0C7AE160003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=RiMwwKTs;
	spf=pass (imf08.hostedemail.com: domain of 3sbXzaggKCEopym5xmows00sxq.o0yxuz69-yyw7mow.03s@flex--dmatlack.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3sbXzaggKCEopym5xmows00sxq.o0yxuz69-yyw7mow.03s@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Cr74Qub+tM1aXRzOZn7JCSg3Cj9WP9eXIaNfTgWpng=;
	b=lwdv/g00ppOo3mSSYYnPoXRUw9/H4Hojyodm/IadoexH7yuxtUVnrTm7cKxfGZxv8k8ik9
	ossV4a4PFm/DqIHlsvBp8TmzyMaaEjdS5VCmztDUMdn5X/WS27kRWN/sdyOUemJZAcBW92
	Imo22jFzjM63aRWLO2I2JrVoEqnfMuI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356659;
	b=ESW5KV9dHjxp+idwhTKFtTXoCOomZHVHfNw/U8v3OmTQuWk1NxFO/ZssNxEEAmZ/2VyBfF
	cpypD0fxOgZbFgfqmywYZqBu9akzLieCHukjJoe5yDkO+NEr87YMZ4n82iTEPOK5uG7svp
	rB88b7RRqO/S3jPrjAiwsMEXMGQsnOM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=RiMwwKTs;
	spf=pass (imf08.hostedemail.com: domain of 3sbXzaggKCEopym5xmows00sxq.o0yxuz69-yyw7mow.03s@flex--dmatlack.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3sbXzaggKCEopym5xmows00sxq.o0yxuz69-yyw7mow.03s@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4db3db8687fso3157596b6e.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356658; x=1794961458; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6Cr74Qub+tM1aXRzOZn7JCSg3Cj9WP9eXIaNfTgWpng=;
        b=RiMwwKTsC7kWr6P4JsSrzvPDyVK1DZ8EkFe1QeThnmmqXtABqsGf3ceRmqdnkvBWEC
         TpVyV+yg/+awM3gC0Obe/eo3utO4thgpx8xOAxDRgQv+5ol5+cVAWxRCiBjDiBZUk8G0
         6z/PVI3ODRY59t4OdXrY/aQBwuoV2N43QXiUwtORUnnr1W2UC8lmweE4Ed4h1idVXBGv
         E9NFfeQ8Wc+MCqOsMLEeQXeFt+awqSi4WXv4A8dz1MwbERUk9TAHT97dBOvBP3HYgsqU
         v4DtkMtCtdZmB2pwQ8IF/IuPMswZd0A/TH8kEPljHFHnlTdQgx3M+OVn3BhJl3fdu5p+
         qqKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356658; x=1794961458;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6Cr74Qub+tM1aXRzOZn7JCSg3Cj9WP9eXIaNfTgWpng=;
        b=O7X2W6ByAKwu9jbCgZXmnuDGM9WAWezWTT5SbI5SrSP5aiwFCt/IWknXXH2cNUDxMb
         VXq2BaaQ2RAEaLPJH22iqtxCDXwuzPUWbx8uRcGY/0b1oAMKwGX3mnXbCsGxMZzu6gIR
         CWPhxLVzoicG60y4heZgAJHA/LTKd/5/vA2TpFXkcJVwUMVsMDmFplCwN5FUPQBaWo2h
         sZ5dXTj8HaZFnEcmQgXAMszRvHKeVRVHsRsF7ox5QKwoElPIvuGeGtvRxf+YLJz8QuDH
         PFKMEjurTrm5SbejOUnKlIDDJHcrPF3SYqKf5zoYywVAC7HtZlSmgJ4gYt4ZX402f42w
         +KTw==
X-Forwarded-Encrypted: i=1; AL+hErFltr7nljfFxBT3hLIhJK0GIdFp2eXnrGQwcrxKC+tQd03l2tir73c2sbpHjVwP4koi41G0rPD6Mg==@kvack.org
X-Gm-Message-State: APuU4Z/vWnYbD9Vcx/1ix9dT8mJQJ7Wbw7mRb63CJ6eM1wO2svT6QgaA
	ksXx3pyKRx2EgI5JGiCWYy2W8r5R6tD1E5kzZykpXo8qZjvRGl2xlFTSMvJUGGkKxmo9Ki2isWD
	hqleuN90yLSnKlg==
X-Received: from jabll4.prod.google.com ([2002:a05:6638:9804:b0:61f:e4cd:8716])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:2507:b0:4f6:6041:f0a2 with SMTP id 5614622812f47-56b96def35emr632822b6e.27.1794356657766;
 Tue, 10 Nov 2026 16:24:17 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:46 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-9-dmatlack@google.com>
Subject: [PATCH v4 08/19] liveupdate: Let file handlers retrieve into an
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0C7AE160003
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: 71nxdmidrjibb8eqhcwk7543hc5asa1x
X-Rspam-User: 
X-HE-Tag: 1794356658-491481
X-HE-Meta: U2FsdGVkX1+FGomRVgQZDmGQOh+GZVNzLDQ+4Q2+XL1spwVdHZ0mD5i4fPN3L+C4TVcA3NMLrGBAeH32FEV47mszlhr8f3KAIdnxWz/BpN+rCyWwpW3xZ4TI43BTO5E9xcHVbFIRMXdJe4TmThgNnxJ1AYTS1q0oZEQkipMjvy1gk1k3qhEbAJ3wHXJ5MqKEqFVSE+eeDUQmZgMCbsau0Kb2l4plE1IBnI/6OOE8C9ah3/IjQ0QsOHiwWaMrq04tZCGCkox0c/TJWJJT0hdV/890nrIOXnSrK0uYVDGmOqQ5E+uhVo+kGCjlF81B+FdS+gBduR/fNNxck5/CFFmrYztjIrEQJD62E9OPmwS6v3MQaXin+6NL9IjGTDpG94u/LElKUTVlGf+QuUFb/VVQgeGrvmSRVJ8ml2dr7isqy1Ft87uUvmvIOUgxmFwFGsMUwmrOj6X9t/ifYHaxCoMuG6IFQBcFFucsasNSNQERuXrHxk2CXUX+28u6BcowR/DIzn0Qcnbjl9WCbRZZ2sXpqErNpWfi2osXn0I0NWWxcKu70MKBLMnB88nPVScDes+KfoGO9qUlQ8GuYLmZ97jw1HpNXIhq9Z5lgJJznqLsp/oOpf5UqKmWSUbrQiRX02g6K47FkpJ8hL4OPjASEm/dG8y5ImQ/Llm3rgBCexi/n6TjwbIjcSe5Zhas0trmhBY8IEFoWXG8Mj0eOpV0iubZc5+IILdeg+xGwPMb6iYd3hmya0LC/V1FfG4wPvFL5crGfqhi/V8QfTwoLfcLW8hj6f61v4aLkFYVaVP3wBAkpIjzmogcZdA8tc7+VSSVduusy5M0b0gWUNumf40mQC1LRyZ1Fpn/BvzFD2WVgzQTe+0it9YSOBsfYxvIcwyWDEBNBoxALxiWxdxTrltsXfVtA+CA2+pzFdLq6AfuZTqhTTXE+P93v1ATNXV/nd07Lsk4/DqO1KvY2Op9Xtth4Kd
 WdeldCl4
 Ob2mEn3B9NF4xQllza46/uv3V5nF5T2jyoTMHoy8XyBIEXj66G3mDkVQqHeRX3mP4FKEsXQ8w51vGEQNARB6gxQEFMbLPVJrwPHanI2ngvKUpPE6N0NnOaEHcFaih3t77Q14c2ZNV8sNA2NcdCdz2QR14F2Vs7ZwI1PvsN71pIwN2MLxIu+OabLEZQArkGoKLTTCfJhiIYJ2YcqgxRaROSh6LSXcvUemaX2QkeIQRvdinaJNQ8jN6FRGTFHf+rYw6iYvOISw9aDrYCi/JMEjefBvrOXvXSaJgXt3wyaX66DIq8NfqrA8qOgP31qr3aukb+EAcq3JeUSBHIblzzcDdbspSbWw7CJNf3YLsFpCY3usaHbBYXF/6U71oNgXz7Ow4wTTEolY5Io1jkzx8OZYQgVQtjaa22m0uO8km5r6Uk312QhhWf/7yoI0o9VVdmFauFdwNdWr5as0hKXgV5IM1TZY7dYXUlMaWVwP2tj5gIK4T9J3pX052GHbf7OqqiYXoq7OQyvB3smfwc0Y5DLYGpCYaKNOjgTteSifrhVTjkx06hh1sLSbuhTdENDAHcSYKFzmJ/+wKsxKsvbmaxeLufnV/WkS1u8KKeWps
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add liveupdate_claim_file() and liveupdate_unclaim_file(), which a file
handler's .retrieve() callback can use to make LUO manage a file before
restoring the preserved state into it. Also let the callback return the
file descriptor of that file, so that LIVEUPDATE_SESSION_RETRIEVE_FD
returns it instead of a new file descriptor.

LUO starts managing a retrieved file after .retrieve() returns it, and
fails the retrieve if it already manages the file. That works for new
files. The shmem file handler will restore tmpfs files into an existing
file, though, and such a handler has to know that LUO accepts the file
before it modifies it, not after the preserved state is consumed.
Otherwise, it could restore into a file that is preserved in an
outgoing session, or into a file that was already retrieved. Preserve
also makes LUO manage the file before the file handler touches it, so
claiming the file also keeps a preserve from racing with the retrieve.

If .retrieve() claimed the file it returns, LUO doesn't track it again.
A callback that fails after claiming a file must unclaim it.

A file that is restored into an existing file is already open in the
caller, so installing a new file descriptor for it would just leave
userspace with two file descriptors for the same open file. Retrieving
the token again later still returns a new file descriptor, like for any
other file that was already retrieved.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 include/linux/liveupdate.h       | 26 +++++++++++
 include/uapi/linux/liveupdate.h  |  4 +-
 kernel/liveupdate/luo_file.c     | 80 ++++++++++++++++++++++++++++++--
 kernel/liveupdate/luo_internal.h |  2 +-
 kernel/liveupdate/luo_session.c  | 25 +++++++---
 5 files changed, 124 insertions(+), 13 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index e4ad0bf78a5c..87a894e269f2 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -79,6 +79,13 @@ struct liveupdate_arg_spec {
  *                    to the handler's expected argument size with any trailing
  *                    bytes beyond the user-supplied size zero-filled. Valid
  *                    only for the duration of the callback.
+ * @claimed:          For .retrieve(): Set while the callback has claimed a file
+ *                    with liveupdate_claim_file(). Private to LUO.
+ * @fd:               For .retrieve(): [OUT] -1, or the file descriptor of
+ *                    @file in the calling task if the callback restored the
+ *                    preserved state into a file that is already open there.
+ *                    LUO then returns that file descriptor to userspace
+ *                    instead of installing a new one.
  *
  * This structure bundles all parameters for the file operation callbacks.
  * The 'data' and 'file' fields are used for both input and output.
@@ -92,6 +99,8 @@ struct liveupdate_file_op_args {
 	u64 serialized_data;
 	void *private_data;
 	const void *arg;
+	bool claimed;
+	int fd;
 };
 
 /**
@@ -306,6 +315,12 @@ int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
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
@@ -370,5 +385,16 @@ static inline int liveupdate_get_token_outgoing(struct liveupdate_session *s,
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
diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 7420e2c5434b..4ebbd578d2d5 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -161,7 +161,9 @@ struct liveupdate_session_preserve_fd {
  * struct liveupdate_session_retrieve_fd - ioctl(LIVEUPDATE_SESSION_RETRIEVE_FD)
  * @size:  Input; sizeof(struct liveupdate_session_retrieve_fd)
  * @fd:    Output; The new file descriptor representing the fully restored
- *         kernel resource.
+ *         kernel resource, or the file descriptor of the file it was restored
+ *         into, if @arg passed one (see the documentation of the file
+ *         handler).
  * @token: Input; An opaque, token that was used to preserve the resource.
  * @arg:   Input; User-space pointer to a file-handler-specific argument
  *         structure starting with a 32-bit size field, or 0 if unused.
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 91a2b74f71cb..95b17c980054 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -592,6 +592,10 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
  * @arg:      User-space pointer to the handler argument structure, or NULL.
  * @filep:    Output parameter; on success, this is populated with a pointer
  *            to the newly retrieved 'struct file'.
+ * @fdp:      Output parameter; on success, this is set to -1, or to the file
+ *            descriptor of @filep in the calling task if the file handler
+ *            restored the preserved state into a file that is already open
+ *            there.
  *
  * This function is the primary mechanism for recreating a file in the new
  * kernel after a live update. It searches the file_set's list of deserialized
@@ -616,7 +620,7 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
  *         Any error code returned by the handler's .retrieve() op.
  */
 int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
-		      const void __user *arg, struct file **filep)
+		      const void __user *arg, struct file **filep, int *fdp)
 {
 	struct liveupdate_file_op_args args = {0};
 	struct luo_file *luo_file;
@@ -656,6 +660,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		 */
 		get_file(luo_file->file);
 		*filep = luo_file->file;
+		*fdp = -1;
 		return 0;
 	}
 
@@ -666,9 +671,13 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	args.handler = luo_file->fh;
 	args.session = luo_session_from_file_set(file_set);
 	args.serialized_data = luo_file->serialized_data;
+	args.fd = -1;
 	err = luo_file->fh->ops->retrieve(&args);
 	kfree(args.arg);
 	if (err) {
+		/* A handler that fails must unclaim the file it claimed. */
+		WARN_ON_ONCE(args.claimed);
+
 		/*
 		 * Keep the error code for later use unless the handler marked
 		 * the failure as retryable (e.g. invalid user argument before
@@ -679,9 +688,14 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
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
@@ -700,6 +714,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	get_file(luo_file->file);
 
 	*filep = luo_file->file;
+	*fdp = args.fd;
 	luo_file->retrieve_status = 1;
 
 	return 0;
@@ -1081,7 +1096,64 @@ EXPORT_SYMBOL_GPL(liveupdate_get_token_outgoing);
 int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
 				 struct file **filep)
 {
+	int fd;
+
 	return luo_retrieve_file(luo_file_set_from_session_locked(s),
-				 token, 0, filep);
+				 token, 0, filep, &fd);
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
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index e0be84acb33b..5e2f82f5a044 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -109,7 +109,7 @@ int luo_file_freeze(struct luo_file_set *file_set,
 void luo_file_unfreeze(struct luo_file_set *file_set,
 		       struct luo_file_set_ser *file_set_ser);
 int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
-		      const void __user *arg, struct file **filep);
+		      const void __user *arg, struct file **filep, int *fdp);
 int luo_file_finish(struct luo_file_set *file_set);
 int luo_file_deserialize(struct luo_file_set *file_set,
 			 struct luo_file_set_ser *file_set_ser);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 0d7533f0bde6..2f3f0eeedf07 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -285,31 +285,42 @@ static int luo_session_retrieve_fd(struct luo_session *session,
 {
 	struct liveupdate_session_retrieve_fd *argp = ucmd->cmd;
 	struct file *file;
-	int err;
+	int fd, err;
 
-	argp->fd = get_unused_fd_flags(O_CLOEXEC);
-	if (argp->fd < 0)
-		return argp->fd;
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0)
+		return fd;
 
 	mutex_lock(&session->mutex);
 	err = luo_retrieve_file(&session->file_set, argp->token,
-				u64_to_user_ptr(argp->arg), &file);
+				u64_to_user_ptr(argp->arg), &file, &argp->fd);
 	mutex_unlock(&session->mutex);
 	if (err < 0)
 		goto err_put_fd;
 
+	/*
+	 * If the file handler restored the preserved state into a file that is
+	 * already open in this task, return its file descriptor.
+	 */
+	if (argp->fd >= 0) {
+		fput(file);
+		put_unused_fd(fd);
+		return luo_ucmd_respond(ucmd, sizeof(*argp));
+	}
+
+	argp->fd = fd;
 	err = luo_ucmd_respond(ucmd, sizeof(*argp));
 	if (err)
 		goto err_put_file;
 
-	fd_install(argp->fd, file);
+	fd_install(fd, file);
 
 	return 0;
 
 err_put_file:
 	fput(file);
 err_put_fd:
-	put_unused_fd(argp->fd);
+	put_unused_fd(fd);
 
 	return err;
 }
-- 
2.56.0.542.g3ef89b7020-goog


