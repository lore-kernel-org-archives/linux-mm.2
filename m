Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50246CD98D6
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 01:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539D46B008A; Fri, 12 Jun 2026 21:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4273D6B008C; Fri, 12 Jun 2026 21:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316BF6B0092; Fri, 12 Jun 2026 21:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 255836B008A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 21:25:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD2D31C316C
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:25:25 +0000 (UTC)
X-FDA: 84873146610.30.8CB17FD
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id 13A5340006
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:25:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LNAYvqa0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3grEsaggKCO8jbYRnRaRXffXcV.TfdcZelo-ddbmRTb.fiX@flex--skhawaja.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3grEsaggKCO8jbYRnRaRXffXcV.TfdcZelo-ddbmRTb.fiX@flex--skhawaja.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781313924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXicpC5BkNIy2t2e0Q8/Rwucvq5r0VnzR9Vhu1tNGPQ=;
	b=p9BZkDlxK0477+hEhQlL+to5WOuKi5god54Zjftyyuqe8mWViDH/YeeP/LyEEN5Ee5llTu
	j+y5IjTAzM55g1+SJHB3JLHd0+MlBt7tyuxBdZ7hSZuN+mwVGIwS6P4tk43Iv5q+S3ayXB
	cL+2aqQ03JFXWJ+zhvcfXLzNi7EGnTU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LNAYvqa0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3grEsaggKCO8jbYRnRaRXffXcV.TfdcZelo-ddbmRTb.fiX@flex--skhawaja.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3grEsaggKCO8jbYRnRaRXffXcV.TfdcZelo-ddbmRTb.fiX@flex--skhawaja.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781313924;
	b=dypJIvUt+cGwSC5Biinj9n999tS24ONzoPFyu58XFB9Ebie+FY7AgdBvY/1s4FgKsST/r/
	/t+VO+UndH25CijAOt+6W1mem6WzLfwEFJX2gOkzipjmNvDsRecFFuNgiYbx/XpiVtQ/qv
	ThsRbT700N7OG0GBYAH+/U0Nb1H6Vw0=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-36d992fa39eso1759845a91.3
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781313923; x=1781918723; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NXicpC5BkNIy2t2e0Q8/Rwucvq5r0VnzR9Vhu1tNGPQ=;
        b=LNAYvqa0qQOi3t+eSUt+lFFYlvSD2pimmQEdfEvEOPfGGi7GZlVQhCr028iZjwEm8b
         QTg0Ye6WJP+JuAudrCTUbng1Gs33Ymkpu5Pc6UFKhtaI29xCMTfxfa86T1i+wQh9Z2z0
         +NFDpCKMhbS8DuP/vC08pdcS0rPEm8Ss/R1yTAJoWwbPwbbe8FVHYB8haZYkJzz6rilw
         gEHV+8eoOJKQztjIfr4sKPNHtdAdWKo4a0MNR0uaDEAwcNNVade9AQ9Lk1Dx0sve7vuB
         WILdSs5xE4/SW8nOzK4VGRotAjzRTpwQZY0L1dIJIZGgr5TWQBs/ywgSTChCmbeKVOKo
         WewA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781313923; x=1781918723;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NXicpC5BkNIy2t2e0Q8/Rwucvq5r0VnzR9Vhu1tNGPQ=;
        b=DMwnGSfE6YAJcDYOwAyqvzYeHhNfSKTyOVZMDj4kFfYiR+j9pjNCT3AVXQfdAt0d2C
         oAXT/USo/qkFPken1m2NjILo1lvDdQ8nyHZsO0d7nNFZbXnAx7T+gxiyDs2usqUtnEio
         iQPpwglpOeqfLrmoZxzq6MhNmMIdHUiNtxMV6jgiS3PP68LQgv3VjZh9PvkyzoYv1Ljy
         DeQBIqODAiKDuJJ4/z0q3W3Mx9UtvAYpRuGJh+eZpjAYbUEYfBwKpxB9m3olWxPDOwPp
         CbyKodROtF/kulAxV7nrdCsClH3F2SWTE0cPkVlMdoLGikydWFTtcA9C1Qfd3t3L3eus
         41CQ==
X-Forwarded-Encrypted: i=1; AFNElJ+yI1OoLeLfZVszsGHvZJdc+TId7pvHXpN8Ej7NLkommMAo6I7yvEos9ZEINpMV4lHfvyn+YCydAA==@kvack.org
X-Gm-Message-State: AOJu0Yz3n9q+GIAOOhuGToQs7FJzpfLqDIcUCcFe/fBZZqUJKUWwx7h+
	OGS8BJvdUIOZ5dtn6PmylsWGhmOSPGOGEI7Pp/7KsPtovHrJlqJQgET6UG8X0VV27CnjO0L3/1v
	B+2TXRX2OY1+QBQ==
X-Received: from pjbfv16.prod.google.com ([2002:a17:90b:e90:b0:36b:7407:9b72])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1c8e:b0:36b:71e6:3de8 with SMTP id 98e67ed59e1d1-37a03ebeb89mr5863237a91.24.1781313922561;
 Fri, 12 Jun 2026 18:25:22 -0700 (PDT)
Date: Sat, 13 Jun 2026 01:25:20 +0000
In-Reply-To: <20260613012521.835490-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260613012521.835490-1-skhawaja@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260613012521.835490-2-skhawaja@google.com>
Subject: [PATCH 1/1] liveupdate: luo_file: Add internal APIs for file preservation
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 13A5340006
X-Stat-Signature: 613t4itsdw87p5w3ugyow59wsnpww5hd
X-HE-Tag: 1781313923-998409
X-HE-Meta: U2FsdGVkX1+X+oARmAhyLLFbcPa0eWaQi8jRp3FkkXxFi1rCguceDdJv4jWLWRROVNC5GHGamYGtVjUIp1nomadjGOipbHQ1P4M73sdq3Bt5yeFNYZYNMhiUoUOvNi+rID/RQHsYN0BkXAR+1Tx+7sSBpZsODqKkME5Ahjt3PzE9MrLcPR+sAimEAnwcJgpXS58LFWEkAOTIujbQZfuak2yCAQVNkn+moN0AWfE0C0P6g6ltGhACukfnpwh6738Qf+HD5Wkqy9Qb5GdIaz2MoGqlo69m8jHcrbQbgIWkGbE2xLPNbA5uejT6jntXYhXQivs0VD9sEplbNMP/83BTqgCBGDmnHwUd/MeAGTRdmzcDQt1PNRd1nMHFWX7WqBRXJQO6+hUqYrsuYMNLckQLcGWteUwi5K6iNrYFPPv3exmUorbNm7j0OsL3V4x7pswJ+SnPk1TSq2s7GhjAYJXseODiMtsEvqcnpGie30mfd1OC5crqSlHI5v0F8pYe2bXm+cZ7gUd9TJnqJPB1OFug74xRftBeT6XnVSjegDjtp4FF9w916rZY6pIxwXMBVZ0wsusiYjYpWg/CauZuvFxH535IaZp4B1DF6/q7IJopEywuFVjygHEnfhvMpcM/3QQJAs1ia5xk6uMh6maWiFbg956INa1zfZoQR2DOHq2SdzpiX2FAOkr73UP41BusoPwiSTwYKOeSkpPK+Td2cg1BIK6hSJ/12Mwo8ySKc3+N0DBgoyCT2KWK6Xhzc4rQVm6JlZxYm3hoItfOPc/snxMFTH3Y/ZuPSf4oogfobC4lthsgLJf1yLZjqX4unoLG8iBOpSVoXE6AuUTI/dSCAx91rei/AlKQCO3XlKrd2UDVWcuZkToZ2QjY7kVNkH3zZ5OcdxIz3XpAlrgIMIXUTL2r1bMejgne7DYetBWfFFC+gp+xhH2wwGoDUwTWZIMOFX7rfoiJL6U6qZSngk77lDx
 9MoXisw6
 EchgIe34wbdWc/JqNezACQEZK9BnhU7rWvDwb4Rp4b2SQEDvKNtascr6iv66x65dEMVuLJ7N8p9Ky9A4xggC2VB3qRpzKrUfpMhJ4hAkGTzlguAQ5i1DscwkQEHOtmMIjJro1L1CeBLHCKU3EGvzyYKIKALkYo8OXcBvR2K8BucCcjjLuip009aGHz8jrn0toDB315fELwcOopVeN3OCEr8Th/GMSx6a9AvvVp9h38qrcOlObm4xbNrhZISRp1Gmn27cFB3PoD6f+miU60WOnbqHW0pOyMUGneJnmwCdUFCd1xv9a3R7h4UTneInaq5jHaTVcQ/DSHZcfJjv+MFd/G+sPn0UxYcZUAsjARBey8bTMgdSk54hEsRvjU19MIHxR6OLOyjEWShEv4xASopINfO8ak8cPqu/Vszni1+aBHrKJuZta7oDq0EPJMuWFG1jj3WVqjX6WhUvKyw+WE6f3Y8BTkTSv1eDGIqhPUip57LovaIBGSHQTTt5M34ZD2eSefRdTr+BgMvJOCFiNfAbnYZXQ6JzNeBgjqodHYIQgOxXNDxDC6HjTZgpA2yzpOtO29LEFZDzmsoZ8L+Ci70jIkGf1FQohQrw6vfFxofG9ZGsEYJKjl9u6EvVtghoiEz4itF/Pq9arILRsDi8SiyweV5kIo69BOWqKcMTc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pasha Tatashin <pasha.tatashin@soleen.com>

Live update orchestrator file handlers depend on the preservation of
other files. To make sure that the dependency is preserved, the file
handlers needs to fetch the preservation token of the preserved
dependency. Similarly during restore, a file handler wants to fetch the
restored file of the dependency.

Add APIs that allows fetching token of dependency during preservation,
and fetching the restored file dependency during restore.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 include/linux/liveupdate.h       | 21 ++++++++++
 kernel/liveupdate/luo_file.c     | 69 ++++++++++++++++++++++++++++++++
 kernel/liveupdate/luo_internal.h | 17 ++++++++
 3 files changed, 107 insertions(+)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 88722e5caf02..261f61998fce 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -25,6 +25,7 @@ struct file;
 /**
  * struct liveupdate_file_op_args - Arguments for file operation callbacks.
  * @handler:          The file handler being called.
+ * @session:          The session this file belongs to.
  * @retrieve_status:  The retrieve status for the 'can_finish / finish'
  *                    operation. A value of 0 means the retrieve has not been
  *                    attempted, a positive value means the retrieve was
@@ -45,6 +46,7 @@ struct file;
  */
 struct liveupdate_file_op_args {
 	struct liveupdate_file_handler *handler;
+	struct liveupdate_session *session;
 	int retrieve_status;
 	struct file *file;
 	u64 serialized_data;
@@ -243,6 +245,13 @@ int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp);
 void liveupdate_flb_put_incoming(struct liveupdate_flb *flb);
 
 int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp);
+/* kernel can internally retrieve files */
+int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
+				 struct file **filep);
+
+/* Get a token for an outgoing file, or -ENOENT if file is not preserved */
+int liveupdate_get_token_outgoing(struct liveupdate_session *s,
+				  struct file *file, u64 *tokenp);
 
 #else /* CONFIG_LIVEUPDATE */
 
@@ -292,5 +301,17 @@ static inline int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb,
 	return -EOPNOTSUPP;
 }
 
+static inline int liveupdate_get_file_incoming(struct liveupdate_session *s,
+					       u64 token, struct file **filep)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int liveupdate_get_token_outgoing(struct liveupdate_session *s,
+						struct file *file, u64 *tokenp)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_LIVEUPDATE */
 #endif /* _LINUX_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index f428f720b53f..57f7f19fcfca 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -323,6 +323,7 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	mutex_init(&luo_file->mutex);
 
 	args.handler = fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.file = file;
 	err = fh->ops->preserve(&args);
 	if (err)
@@ -380,6 +381,7 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
 					   struct luo_file, list);
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -411,6 +413,7 @@ static int luo_file_freeze_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -432,6 +435,7 @@ static void luo_file_unfreeze_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.private_data = luo_file->private_data;
@@ -621,6 +625,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	}
 
 	args.handler = luo_file->fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.serialized_data = luo_file->serialized_data;
 	err = luo_file->fh->ops->retrieve(&args);
 	if (err) {
@@ -654,6 +659,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
 		struct liveupdate_file_op_args args = {0};
 
 		args.handler = luo_file->fh;
+		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
 		args.retrieve_status = luo_file->retrieve_status;
@@ -671,6 +677,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 	guard(mutex)(&luo_file->mutex);
 
 	args.handler = luo_file->fh;
+	args.session = luo_session_from_file_set(file_set);
 	args.file = luo_file->file;
 	args.serialized_data = luo_file->serialized_data;
 	args.retrieve_status = luo_file->retrieve_status;
@@ -926,3 +933,65 @@ void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	list_del(&ACCESS_PRIVATE(fh, list));
 }
 EXPORT_SYMBOL_GPL(liveupdate_unregister_file_handler);
+
+/**
+ * liveupdate_get_token_outgoing - Get the token for a preserved file.
+ * @s:      The outgoing liveupdate session.
+ * @file:   The file object to search for.
+ * @tokenp: Output parameter for the found token.
+ *
+ * Searches the list of preserved files in an outgoing session for a matching
+ * file object. If found, the corresponding user-provided token is returned.
+ *
+ * This function is intended for in-kernel callers that need to correlate a
+ * file with its liveupdate token.
+ *
+ * Context: It must be called with session mutex acquired.
+ * Return: 0 on success, -ENOENT if the file is not preserved in this session.
+ */
+int liveupdate_get_token_outgoing(struct liveupdate_session *s,
+				  struct file *file, u64 *tokenp)
+{
+	struct luo_file_set *file_set = luo_file_set_from_session_locked(s);
+	struct luo_file *luo_file;
+	int err = -ENOENT;
+
+	list_for_each_entry(luo_file, &file_set->files_list, list) {
+		if (luo_file->file == file) {
+			if (tokenp)
+				*tokenp = luo_file->token;
+			err = 0;
+			break;
+		}
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(liveupdate_get_token_outgoing);
+
+/**
+ * liveupdate_get_file_incoming - Retrieves a preserved file for in-kernel use.
+ * @s:      The incoming liveupdate session (restored from the previous kernel).
+ * @token:  The unique token identifying the file to retrieve.
+ * @filep:  On success, this will be populated with a pointer to the retrieved
+ *          'struct file'.
+ *
+ * Provides a kernel-internal API for other subsystems to retrieve their
+ * preserved files after a live update. This function is a simple wrapper
+ * around luo_retrieve_file(), allowing callers to find a file by its token.
+ *
+ * The caller receives a new reference to the file and must call fput() when it
+ * is no longer needed. The file's lifetime is managed by LUO and any userspace
+ * file descriptors.
+ *
+ * Context: It must be called with session mutex acquired of a restored session.
+ * Return: 0 on success. Returns -ENOENT if no file with the matching token is
+ *         found, or any other negative errno on failure.
+ */
+int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
+				 struct file **filep)
+{
+	return luo_retrieve_file(luo_file_set_from_session_locked(s),
+				 token, filep);
+}
+EXPORT_SYMBOL_GPL(liveupdate_get_file_incoming);
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 875844d7a41d..08b198802e7f 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -79,6 +79,23 @@ struct luo_session {
 
 extern struct rw_semaphore luo_register_rwlock;
 
+static inline struct liveupdate_session *luo_session_from_file_set(struct luo_file_set *file_set)
+{
+	struct luo_session *session;
+
+	session = container_of(file_set, struct luo_session, file_set);
+
+	return (struct liveupdate_session *)session;
+}
+
+static inline struct luo_file_set *luo_file_set_from_session_locked(struct liveupdate_session *s)
+{
+	struct luo_session *session = (struct luo_session *)s;
+
+	lockdep_assert_held(&session->mutex);
+	return &session->file_set;
+}
+
 int luo_session_create(const char *name, struct file **filep);
 int luo_session_retrieve(const char *name, struct file **filep);
 int __init luo_session_setup_outgoing(void *fdt);
-- 
2.54.0.1136.gdb2ca164c4-goog


