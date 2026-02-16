Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F679E7BDBB
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 13:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBEAB6B0005; Mon, 16 Feb 2026 08:22:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6CE66B0088; Mon, 16 Feb 2026 08:22:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4E596B0089; Mon, 16 Feb 2026 08:22:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9FA1F6B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:22:36 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C77D13C2B1
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:22:36 +0000 (UTC)
X-FDA: 84450384312.08.9BFED4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8ADB6120006
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:22:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VJM0lDVf;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771248154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZYJbwBIdDwtgtaZgS2ZKH1lz4ET7s3CtdJa2nf3VVrE=;
	b=FWOYE3RAVgMurfzv77ZnSPCfs2LT8YpGou03940hZP4+3obDiYL9LX5HSn2YQu7sarkVAJ
	1ael7t2pkpGoBPVk+LkUxdZDYPW9DYA41qtT2ftUkxzIjMDWhw2W7wHNeyVuzSv2QnA+d8
	gOExW4YDaTw+cjIrYnNsy9xXeYyR6YI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VJM0lDVf;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771248154; a=rsa-sha256;
	cv=none;
	b=TYMXnaXAUpG5V2PzE0HHrnPoa2a/16kw/xidJoccWmVnrBfA6WREvIQoqyaE4MIEKM395D
	WRHZsskUmFXFsuwATqOwbLYtxB3ROR+mctb/HC6grrkJYw273bc57EUkmmTqa0N4ZX7hEn
	IEwcB0mLkruBKQ9EEAdZaohqwHRLJbc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EA8B41B36;
	Mon, 16 Feb 2026 13:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1585DC116C6;
	Mon, 16 Feb 2026 13:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771248153;
	bh=5JDSWbQYXsrP/Ta9EcOGFW4rHI86oaq113jhO8KP0PI=;
	h=From:To:Cc:Subject:Date:From;
	b=VJM0lDVfUGOZQ+cvlCXgzRsjTdZnj1CoJbkO6LdTRrMHAInX25baCL5CwR57B7kL+
	 LrOI/2DLwK1Rr9ZoPA7/rYFMpY/sZjwTaZ1dwGflvPQg3grdH4LocHaZ2tO6WHdvnU
	 3owLqb4X/3VfDiia2mTvHJAf5EJCN97By4FHgXo3IGjcg5+b4qxWga6Mv5yMhKlNH8
	 46FPXKL9Y5L1oMm78LBVcjdpkIEm8QvkwXomNtUUh4WJOQI1UkpfRsw2qM5F4NuN02
	 ywxdHCp1nRptiYSszinDltj9I0SRggR+buS4MpQBbJRfsTgXhx6XqYgZIhal1IzycG
	 AJyfBk4997OZw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] liveupdate: luo_file: remember retrieve() status
Date: Mon, 16 Feb 2026 14:22:19 +0100
Message-ID: <20260216132221.987987-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.335.g19a08e0c02-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hw1smo4a13o9iw9md1zadr7fh971mp4m
X-Rspamd-Queue-Id: 8ADB6120006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771248154-673341
X-HE-Meta: U2FsdGVkX19YEk2/CdQkbSKY+8lG5SkCRqqlYnJxurAD0i6StSKE+xXjwUulj5zWa0d5yHlV5a9LnciQM+DS3pX+32KZtmuBLYdhaqWW3uG1bfBgBlK7tR8gwoAoiKlF02dBhfUqEoygnCpUaQC2oNgw2+jhl73XsoddLTaBoQewAvG5u9j8CA58y3UcJxRgufuxnRzIQ75uc8pESh6z4Auor4DKhi+P/6xWOExhDieFqrm6bumY6TKSRCEIvJmblKL9DNpGzhyNXN4CeoE2TVWQzxLRPn9t/wNdSPGcta+7gPrDV3J5gf6PG9iz9Zg/EgZ4Wxs+dtrXcf0sSTXBtc921NCqz5lBBIyM6irK+UbsRDh2uPWmvSilVUsOf0ky58EoTys1ciDlqUw2xY96LE3wdrFkC1T9XwiYg4fbIhzaYbElHvqI/VLy22ESpUJZvWNhH7T/Q9jKp7KLyJqvstPD7Y08xvVO2um2vC2qajnd9Fbf3xm6ZRd7lKnKmguNQr0CsTxcefHVhvB0VQHzjWSMnFTEYhRICMsuUTo66m0Gmj+b2MS20Cw5ZI03l/MALDHW6USMzzBUUcqs85bqJIMeZCNa3ll/2RHYCuaK4a1gAUYRf/10PQ++i2yW3d2iLuvT+8JfFrvNw2A4UnjWGxtPtDYQJKmLqLycfHXth6QsmESMiFpl/Gk16FpRFjaFjqJH8OaWOKcTRdhWDswtE7btHqsdrYqTLuyxkBgKzvlabXzkgrtklvKN9B22nVqad4PTZ/zmqx+xygZzNrWrb4Ld2dg30cwVuuyk46477QF0tfYqPuXcCbXjKv0hIW8vuYeTjV+jAR6sGWPdHVaPSYQ8NJ/LMN/5qow9OUTF6QmRNibzpVgFCcFKaA0eVcnVYtM1vGZ7POT30SdMoYesGhCFJsBKfRTZtvtbbGPbG46NvADrnlPxUWkUlbY+75d1nG3KoMNlUGm4nRjTcHR
 MaKJY9f0
 EyjJesVVpwdAPTYIobIQzTWQHnheP2BlT8sIsNZ+7mIQeyIe4M23GtGqM6EuPpXO1u5ST/M14iHof9oCDr1c/JC/FIUNOGJQbPtY0aiz66UBKbL5gsvQ8JAj5z3QN/ZuFeuds0XQaNyno13NSZndmnGsRaR/4Te4Rk177eVYfqOuNSBIZAcpICtS2mMgUWl51YtDraGAmxIDoOqMs0qeuCenAG8DGzaoPOsWMpLGWyCVNjsU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

LUO keeps track of successful retrieve attempts on a LUO file. It does
so to avoid multiple retrievals of the same file. Multiple retrievals
cause problems because once the file is retrieved, the serialized data
structures are likely freed and the file is likely in a very different
state from what the code expects.

The retrieve boolean in struct luo_file keeps track of this, and is
passed to the finish callback so it knows what work was already done and
what it has left to do.

All this works well when retrieve succeeds. When it fails,
luo_retrieve_file() returns the error immediately, without ever storing
anywhere that a retrieve was attempted or what its error code was. This
results in an errored LIVEUPDATE_SESSION_RETRIEVE_FD ioctl to userspace,
but nothing prevents it from trying this again.

The retry is problematic for much of the same reasons listed above. The
file is likely in a very different state than what the retrieve logic
normally expects, and it might even have freed some serialization data
structures. Attempting to access them or free them again is going to
break things.

For example, if memfd managed to restore 8 of its 10 folios, but fails
on the 9th, a subsequent retrieve attempt will try to call
kho_restore_folio() on the first folio again, and that will fail with a
warning since it is an invalid operation.

Apart from the retry, finish() also breaks. Since on failure the
retrieved bool in luo_file is never touched, the finish() call on
session close will tell the file handler that retrieve was never
attempted, and it will try to access or free the data structures that
might not exist, much in the same way as the retry attempt.

There is no sane way of attempting the retrieve again. Remember the
error retrieve returned and directly return it on a retry. Also pass
this status code to finish() so it can make the right decision on the
work it needs to do.

This is done by changing the bool to an integer. A value of 0 means
retrieve was never attempted, a positive value means it succeeded, and a
negative value means it failed and the error code is the value.

Fixes: 7c722a7f44e0 ("liveupdate: luo_file: implement file systems callbacks")
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---

Notes:
    Changes in v2:
    
    - s/retrieve_sts/retrieve_status/g
    
    - Update name in liveupdate_file_op_args docstring.
    
    - Re-order retrieve_status checks in luo_retrieve_file().
    
    - Do not explicitly initialize retrieve_status since we kzalloc() both
      luo_file and liveupdate_file_op_args.
    
    - Apply commit message fixups suggested by Mike.

 include/linux/liveupdate.h   |  9 +++++---
 kernel/liveupdate/luo_file.c | 41 ++++++++++++++++++++++--------------
 mm/memfd_luo.c               |  7 +++++-
 3 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index fe82a6c3005f..dd11fdc76a5f 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -23,8 +23,11 @@ struct file;
 /**
  * struct liveupdate_file_op_args - Arguments for file operation callbacks.
  * @handler:          The file handler being called.
- * @retrieved:        The retrieve status for the 'can_finish / finish'
- *                    operation.
+ * @retrieve_status:  The retrieve status for the 'can_finish / finish'
+ *                    operation. A value of 0 means the retrieve has not been
+ *                    attempted, a positive value means the retrieve was
+ *                    successful, and a negative value means the retrieve failed,
+ *                    and the value is the error code of the call.
  * @file:             The file object. For retrieve: [OUT] The callback sets
  *                    this to the new file. For other ops: [IN] The caller sets
  *                    this to the file being operated on.
@@ -40,7 +43,7 @@ struct file;
  */
 struct liveupdate_file_op_args {
 	struct liveupdate_file_handler *handler;
-	bool retrieved;
+	int retrieve_status;
 	struct file *file;
 	u64 serialized_data;
 	void *private_data;
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 4c7df52a6507..a64ae611cb30 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -134,9 +134,12 @@ static LIST_HEAD(luo_file_handler_list);
  *                 state that is not preserved. Set by the handler's .preserve()
  *                 callback, and must be freed in the handler's .unpreserve()
  *                 callback.
- * @retrieved:     A flag indicating whether a user/kernel in the new kernel has
+ * @retrieve_status: Status code indicating whether a user/kernel in the new kernel has
  *                 successfully called retrieve() on this file. This prevents
- *                 multiple retrieval attempts.
+ *                 multiple retrieval attempts. A value of 0 means a retrieve()
+ *                 has not been attempted, a positive value means the retrieve()
+ *                 was successful, and a negative value means the retrieve()
+ *                 failed, and the value is the error code of the call.
  * @mutex:         A mutex that protects the fields of this specific instance
  *                 (e.g., @retrieved, @file), ensuring that operations like
  *                 retrieving or finishing a file are atomic.
@@ -161,7 +164,7 @@ struct luo_file {
 	struct file *file;
 	u64 serialized_data;
 	void *private_data;
-	bool retrieved;
+	int retrieve_status;
 	struct mutex mutex;
 	struct list_head list;
 	u64 token;
@@ -298,7 +301,6 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
 	luo_file->file = file;
 	luo_file->fh = fh;
 	luo_file->token = token;
-	luo_file->retrieved = false;
 	mutex_init(&luo_file->mutex);
 
 	args.handler = fh;
@@ -577,7 +579,12 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		return -ENOENT;
 
 	guard(mutex)(&luo_file->mutex);
-	if (luo_file->retrieved) {
+	if (luo_file->retrieve_status < 0) {
+		/* Retrieve was attempted and it failed. Return the error code. */
+		return luo_file->retrieve_status;
+	}
+
+	if (luo_file->retrieve_status > 0) {
 		/*
 		 * Someone is asking for this file again, so get a reference
 		 * for them.
@@ -590,16 +597,19 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	args.handler = luo_file->fh;
 	args.serialized_data = luo_file->serialized_data;
 	err = luo_file->fh->ops->retrieve(&args);
-	if (!err) {
-		luo_file->file = args.file;
-
-		/* Get reference so we can keep this file in LUO until finish */
-		get_file(luo_file->file);
-		*filep = luo_file->file;
-		luo_file->retrieved = true;
+	if (err) {
+		/* Keep the error code for later use. */
+		luo_file->retrieve_status = err;
+		return err;
 	}
 
-	return err;
+	luo_file->file = args.file;
+	/* Get reference so we can keep this file in LUO until finish */
+	get_file(luo_file->file);
+	*filep = luo_file->file;
+	luo_file->retrieve_status = 1;
+
+	return 0;
 }
 
 static int luo_file_can_finish_one(struct luo_file_set *file_set,
@@ -615,7 +625,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
-		args.retrieved = luo_file->retrieved;
+		args.retrieve_status = luo_file->retrieve_status;
 		can_finish = luo_file->fh->ops->can_finish(&args);
 	}
 
@@ -632,7 +642,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 	args.handler = luo_file->fh;
 	args.file = luo_file->file;
 	args.serialized_data = luo_file->serialized_data;
-	args.retrieved = luo_file->retrieved;
+	args.retrieve_status = luo_file->retrieve_status;
 
 	luo_file->fh->ops->finish(&args);
 	luo_flb_file_finish(luo_file->fh);
@@ -788,7 +798,6 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 		luo_file->file = NULL;
 		luo_file->serialized_data = file_ser[i].data;
 		luo_file->token = file_ser[i].token;
-		luo_file->retrieved = false;
 		mutex_init(&luo_file->mutex);
 		list_add_tail(&luo_file->list, &file_set->files_list);
 	}
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index a34fccc23b6a..785f26aa58c0 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -326,7 +326,12 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	struct memfd_luo_folio_ser *folios_ser;
 	struct memfd_luo_ser *ser;
 
-	if (args->retrieved)
+	/*
+	 * If retrieve was successful, nothing to do. If it failed, retrieve()
+	 * already cleaned up everything it could. So nothing to do there
+	 * either. Only need to clean up when retrieve was not called.
+	 */
+	if (args->retrieve_status)
 		return;
 
 	ser = phys_to_virt(args->serialized_data);

base-commit: 6c8dd4f02805de481c200636e567a871f25399a2
-- 
2.53.0.335.g19a08e0c02-goog


