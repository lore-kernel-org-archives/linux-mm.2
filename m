Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885C2CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 09:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D0846B0099; Thu, 15 Oct 2026 05:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6236B009B; Thu, 15 Oct 2026 05:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BF016B009D; Thu, 15 Oct 2026 05:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C9BB16B0099
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:38:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 341D5C026A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:38:36 +0000 (UTC)
X-FDA: 85324360632.09.0ED0DC2
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8203F1C0003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:38:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fELaTspa;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792057114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZelI1I51j7rf9JD3PGtzWapemkkjt987366KVri7bQ=;
	b=phPZkkbeY0y2WNqYW1s+TjNK57jcptRLBRzmejC6wY1eFgV9q/VC0W8tLabxO+cbJSP2/u
	QsMTZRk6V5dFg4S+HABLWz2Bsm7ucuMhVGDMOgCrvib4K8oeoqgBOFDOVnqThyIHrYRgVl
	o7Uczu2meMlB1a4DLB6kGyQivAiMPys=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fELaTspa;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792057114;
	b=Fh5AXGlBlsC87veAF5foHeglXe0yLlStEcJgvMzqGqGIPHjOYPMj3jtmvjnFcoMuhhhB1/
	WVyUmfaDtIb8H7kxfUtVNEyR1RisW8QK6ZL/sq9rfPzzDKaN8r7L8xBvPwxTmkQt8KypaR
	I7/TPl4z46MDQzhzjc05cH/a5Izo3DQ=
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-7bec5112765so757596137.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792057113; x=1792661913; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=rZelI1I51j7rf9JD3PGtzWapemkkjt987366KVri7bQ=;
        b=fELaTspawv6Zmr14vuMUrZmUUA0h0eQIakWeLSB/spHi7VRytAd+/efcI6bLV0aOlx
         ik/SibFILDqJIJeCyZcfCGnhnKyrTlVAIQmORXdUTykHFZZhrYeZlvEc4oN0UWYHSCx4
         V5QQwhEetvkgkfLjeCzZlw04EWm0C/miRK0F3WFzUMU/JktsSnF07t3LHcwQotHa67va
         /yYybs6+RxQnoitmqyVpJVFu2lCZ5f5Jh1iIxpChDcbJroJ4Ig/Zu6sOIo19VTnXG3Lc
         1yCpJVZ8I2ZtrUnNTydF1nJHvEQ4urz9z1NosKE5Cnmc6W7NAIXnYoQ1VwGcbWfynMxn
         80Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792057113; x=1792661913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=rZelI1I51j7rf9JD3PGtzWapemkkjt987366KVri7bQ=;
        b=vuxmFWT0305+Rt18qs1YHAWuadsgkPordPh75BB5xHGzUjsv8J9Ql8UUTsIx1gj/Fd
         1md45BefcRB1emZigcqeN8fWPmq5JdIzGFflDaCE8c4nF4sLCv1tY1T+pnbGzR4LPb8C
         JHW4GeELaRbuJOUL2eh9qc9qTASOFxqjbC7aj+vjU9bk2zLiu07jo6NgrWi92ArmyGwx
         5eTRxlsUok0Xtws792wtKyO0sywsHuRk8MmSKJXRyKEg9qTVXhtGPTgBcOintmrsjGZ0
         inrSlTA103hxpLx1zMrA2fFrAyYUym0xRy8eaUqblvGYlIG2RF7rIL2RKcuwixes9X//
         C48w==
X-Forwarded-Encrypted: i=1; AKwUvBweBPHhd0giW6Xhh0ArhOPSfhitguU//axqwXqnFq6T38qJY7Mbj6V2BTULeiTa0Gbvh2xKszmiOw==@kvack.org
X-Gm-Message-State: AFq9FYJAmlM7braSYM0xdGKB1sQuYajHxTBMFXMjeEW4THYyNzVqM2NX
	lr/iXKB8ltiV+0Yca7eBSPcRVF2UsDhluJFJDGbdp3EeHvv3H0wZAguQ4hE4W+TzpHo=
X-Gm-Gg: AYBFou32dogxXgAmXXMCfCcGk+W/eHDmpT0zL6/tZs2SwIaJ1MPs9xYWyqD3rzES7WO
	KZ92tV3Jo2GbNlhMY1MzvH6ia3HYJaB3UsaasKbpNfpWyYk4nF7CP/RNibEpnsYkOrHKc8TsFZy
	rKoofK6sWu91JYHh1gosWa7HQr31LSqu1G9niWaqdUJVe9SsvFTO8gsMRu7taNt0BCoXruDCoGz
	eEY+MF0BCVBpCEtxk+JBMEUuB9YGFz3zKyeZf2kGCuUfBe20ogP1YC4QDIDJMLAYniwOmiaksnm
	K1X8Gj24gsh55n1iaWkFejk5uNqq2gfaBcNgV1orXQDpc8lli/hfTrDSD2gBonVqysPG8WZfXSv
	j32wbWGnBD+8SB0B5n17Dhv3XfCnxaDXtYMzmzHK8+QDSO2MhcTzR5vtzDk5Ua2OV/2SDJs5I9V
	/2TmfMVclieg9Vi7PHd88heZChVvO2VG0ieZ0Jes6nbfyUeKDJccuIDkYnKv+NFDaKHE4waCszb
	EvF34lH2EcRw4dfArOf6xsRhgsVWSqgqO67FGhJ6eIMbx9ywYZJkpBK0WwNuoDJiFwIO1urTEFo
	Dnjb1Qfkeg+aBGhrLyYyyL2/h74TVQ==
X-Received: by 2002:a05:6102:2924:b0:7cc:56a:58d2 with SMTP id ada2fe7eead31-7cc056a64bcmr366185137.31.1792057113624;
        Thu, 15 Oct 2026 02:38:33 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003d37009sm12275672241.2.2026.10.15.02.38.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 02:38:33 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [PATCH v1 5/7] liveupdate: Allow file handlers to mark retrieve failures as retryable
Date: Thu, 15 Oct 2026 05:38:14 -0400
Message-ID: <20261015093816.2438942-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
References: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8203F1C0003
X-Rspam-User: 
X-Stat-Signature: zabekbb84pizwi94xdwwz1gdwfsf9hqb
X-HE-Tag: 1792057114-208758
X-HE-Meta: U2FsdGVkX1/q72KrGioeSGKQaKBxh5zbTOc8EGUyUndt2kdR4I3laGfbEwrZQbw8CevJaWi6behuMItzZ6PRNJoHGSEEmkt4rmmlGlxutMA493dpriGuhbAJfTWrWQIhR99UJMJdLRMDTfhVV3XQyF4iqR38fCjAxsNgAW904TeDZrF5XalfxEDxb0LI0crzEclV+ICa7HJfhaXf3egkQbvKnVMQ1xZMDjX8RRObTx4kWpoyBVkQyKTeNu1Gi5/Fj0HXyPDQ0ZqKM2AmU6k1CIPfCopLSI2cYdHZQlMc8COks9VzO0ywWBQ3MSgTvEilkyMeaKJ/ZbGHheKrQLjvmxTf8SIfDmIS19zGVJT0ij8/8wdNRSX8R6fEmVhVXpYfyiyo7VJ7SQpefZTW6Ft2YSc3LVL2F+EXcI/gGOUvIIbn8suT2PA1MxE/it9hyxKTZDUgj43NFVcfFnOAxtzQUMZxIpmMMjj5adgSKjHKyinH9FlKFQGEEITi/YXUTxNZcjwKSsHp+Q5sOptdcJQQYqgJzg2P21NBrCJuoyU7m3Eg3lh8CMsWAsQzlFwipECr/yRMkLj9mdeFgpkF7fKFAne9uD8I7zqj64CmKhiTZ5t6nlancrbdVXKTNqVooatfjAVqXFqm3kRmRgOJzeUSgcbDqdilpswkaBkf+3QNVNBvlG2fAgGN4fc2R6KLHe4hF3ccqIS+yT2LVwzgxWDYFviZsOrO5SZ7BFaK1YZ50k6d0lKRgf93iUcQQw8psZU0TKE99cYBx+i6xbDZ/126HIxveFTiiOxIFCfIK22SPOZaC4T7htY4IUXs443XkPKlEfYfK6nShrOj9toaSXNZk+uHMoaODuHctz+goHXJcBNkOQuvmYc/ILL6J5cvAnxv6Xk3+N5TrkN3UVTed6Xj7ZF2czun4mt9e9OwEDjrDBWW1Fo/4pXnZYTBY+GVkWu2LWTxq8ozy2MV0P0UPhM
 TkhxAeIY
 VMZWMUywoA3+pKmYvYqEDZTwgwdTEhelE2A2Y/Ub/ubu02e7Wr1TSbiffNwuCkxFCo+OUUpCIgE3EXLsh6rcZTGFaad+WEytbaVpMixemk2Wce38akLkXQP+EJG0ZwFd0+LLWCpic2ZGpKOpbJShF+LNwrTt5D1DeuO7vW+BcP8v6J9dYC/CqtbnYle5g60XVzTYKTfyA6RM2LND+qGM2Y3i30cCZ5ZNECIgeCUtFfZcDc4TmRjRS2ehCychtZUHx2GxtEUpL0/tBAzjHd/XD3q5EREueW+w2rz7OotH19sy9sEPc7Nsqv3kFsWY4U4cuiQphUR4H9l+YVSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 include/linux/liveupdate.h      | 11 ++++++++---
 include/uapi/linux/liveupdate.h |  7 ++++---
 kernel/liveupdate/luo_file.c    | 20 ++++++++++++++------
 3 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 52d3f453ae011..4e1f0f4cbd6fb 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -57,9 +57,13 @@ struct liveupdate_arg_spec {
  * @handler:          The file handler being called.
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
@@ -81,6 +85,7 @@ struct liveupdate_arg_spec {
 struct liveupdate_file_op_args {
 	struct liveupdate_file_handler *handler;
 	int retrieve_status;
+	bool retryable;
 	struct file *file;
 	u64 serialized_data;
 	void *private_data;
diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 57a3c129d5a9d..0ab28fd58fa5f 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -175,9 +175,10 @@ struct liveupdate_session_preserve_fd {
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
  * Return: 0 on success, negative error code on failure (e.g., invalid token).
  */
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index e3bfdbc6baedc..5c2ffec696885 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -138,9 +138,10 @@ static DEFINE_XARRAY(luo_preserved_files);
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
@@ -620,7 +621,9 @@ void luo_file_unfreeze(struct luo_file_set *file_set,
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
@@ -678,8 +681,13 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token, u64 arg,
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
2.56.0.385.gd3acb90ef8-goog


