Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A048760A2612
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oFsN1e/5
Received: by kanga.kvack.org (Postfix)
	id BE4126B05B4; Tue, 10 Nov 2026 12:59:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBBC06B05B5; Tue, 10 Nov 2026 12:59:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF8E66B05B6; Tue, 10 Nov 2026 12:59:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89BA86B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:59:09 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0AAE8A03BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:59:09 +0000 (UTC)
X-FDA: 85419970818.08.2D73150
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 55DA3100009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:59:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oFsN1e/5";
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kasMDOcTvV0NYyrBnOBPw++vO4YiuCVgb2XxRtS1qvM=;
	b=mDrsZmapo7KhYg53eumaTjBbC9Q+wjGjsB3uF+YXLjbmQBxe8xih11YrIE+sPREPDHBAta
	n0pS0MfK94LKk9955WqVN84t406W1I/MocznYtmCnal3r9HT3GZb6XY1QeI7J1bJPg1FOY
	c0Mw1E/7R8s9ZSIaAOIlQAJEwgERleA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oFsN1e/5";
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794333547;
	b=OEFqsxDSfekv49scVIcbpgkjAMchRtqrQa47FoiN8joLzJEg/JBBO/7n84h4YggcNxfdj9
	ofU77chYl8TxpbTV9uyB5oUo9X2AFoLJBOwm11r480cQj5X/TpeiJwSH6c7wlMzv6ur77Y
	S3DNJEf6NTJlmiPPg8la2PwRHYz3/t8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A2AC42386;
	Tue, 10 Nov 2026 17:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8701F008A3;
	Tue, 10 Nov 2026 17:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794333546;
	bh=kasMDOcTvV0NYyrBnOBPw++vO4YiuCVgb2XxRtS1qvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFsN1e/5hDYrH56ZTnZw4RkCYmdJHwM1nMxBBY7ZSClYsmSuucVsBUlHN2IYqDlDC
	 LdzOYSbLn/HJXII+igJNAk1rTfminwVeW82CdICH/810OfiY0NlQZCtb1ptX+3C2W3
	 t72j0w8bjptIJc3yhzxsJsYGzFI/0iNEwDNQxDJ5+Ci23j1WHmyNal4r04x0nDsm9t
	 LF1gpP1E9Jhz5xSL3T+6kbsQPsV4kxVprErtVQzbYds7jC7ghYOSk6tau5rpDMCZNY
	 5KHu9jRr2PteO5L2rdG+G5EjWSYYajJ/EYO+NjTGlDpwTpl2UXSj7C3qXc9ehSnpLq
	 k1wV3z+ZPZsUw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 1/2] liveupdate: luo_file: allow keeping private_data from retrieve until finish
Date: Tue, 10 Nov 2026 18:58:52 +0100
Message-ID: <20261110175855.2437084-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
In-Reply-To: <20261110175855.2437084-1-pratyush@kernel.org>
References: <20261110175855.2437084-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ie7roy71fwdbe3kozu18s6dc575sxpx4
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 55DA3100009
X-HE-Tag: 1794333547-803450
X-HE-Meta: U2FsdGVkX19Rg3Nc6b8ybWM30EqQDqvoclb0lZ8LCd1v/C9kPcvaz/1nrTIgkRDnjTRR3v1/xP9pmduU5r4tdefN//3/QrfL0yG6/X3aQ0tuHN5e1K7Fd2jWrmXxCt4DG3XHrwsDecBkewRS/ZixnGFTmRI5uzWZCW0xGRYH/3330qVsxcH1eADUK4deD5R3Wofe9zhXfh7BfLE50Eh8ydUGWfmxoYqgInbbZleQtq9xugECky5b3tNlYZtVifGp9BIOvQKqj/N325WjUcRv7ehYPpbxlVJ0KRL6jSMmq2PcF5aYiFdOW/mH9x57+XL/uZTuwsPQzUnyChQmIkvbK7tji9YNXmxu9+UJe2++dDAVW9PE28sSoMUmMBUdxLLKss80Dc4mD3bRi9yChgKQta9mJgDyoUYYfKRhrr71gTb4FwR/NKLwExQiInatP5t+6gW5ASG5A1YeUGAH60A2LIw1mrtUURXfb2ij1DVIZ28Icf74IpZISZt4gVLMsVQV22/9MoKfobgnS3shp+QAvtHscNhk1LsVoAXajxFgeUydBUZnRYCOR9wpZrc7i4NcGgENG60Ua4v1Kp/I+AdkGiWoPP1H0l6xFcJUbf7HyG/k4UqdXAi0xiCtNkPOAh9/Yy48OptnjG+vGeO35AM9+cIO8FfG9pb6vd8oPXbMbTzarkohDCPFJBnnR6dwMAw/HA1HCTehNWHs0FC0Cve9uHs25/h0oLPRAGqx/PFjMkfk4AimwUo7CdR2d4expR9c1O59KrK98xAgqfTApLxB85q8e48qPWcSx7qYRFmbuQyBTK8IadwV8GYxT58F/bZiPLBGNA9g+/by6ZUmF7yUF7+jONsFTLgD6pfmP0bQXo3CfIEIrXA0GrAJxe5dfL69qJa7pnXYnWOQaCJmhf0LdPlri2hxr3RrRWtlILF0eiJCyqOdzdOtpJFyJpPlaPwF1iV2IrQ4GbG8w4KZBcO
 JvppI2KK
 cUFiAPzsTH0WGiQGB/FmFqVqIZg0J4MKSG+j9lpb7+T6QKIwPzcs1l5mT2csXtj2Xe7DYJZY55BsQCF10ByDKvTa+98sm5HpbIG2LzAzNGVXxUyDPq6fOBgfW5IVU+Jv4kCAwfnG4mHxUhcdq+ZH8Y58xVtIUBp4mZCrr/QpIx7NnJfsX9TZr6W8UAgLS9LGpWx0L5RNg6xJngRt4bdsgATQPE/STdEMfOUNRTN+vq5MpChmsoNnquY5IOWIjHizAei2zojP8h97vAFDidGFsptupmYEXNlkX8eh0GFCVMZ2SJ1QImOQzvgilsQxJIuSTkFfQD1wInfCPgS2y5NnQYaw0HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

The private_data field of struct liveupdate_file_op_args lets file
handlers keep runtime state that is not preserved. It is set by
.preserve() and passed to the later outgoing callbacks, up to
.unpreserve(). But in the new kernel, nothing set by .retrieve() is
kept, and .can_finish() and .finish() always get a NULL private_data.

Handlers might need to keep runtime state from retrieve until finish.
For example, memfd will need to remember the folios it holds on to
until finish so it can release them there.

Save the private_data set by a successful .retrieve() in the luo_file,
and pass it to .can_finish() and .finish(). The handler must free it in
.finish().

While at it, update a stale comment under struct
liveupdate_file_op_args. There is no 'data', but there is
'serialized_data' and 'private_data'. Refer to them instead.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/liveupdate.h   | 11 +++++++----
 kernel/liveupdate/luo_file.c | 11 ++++++++---
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 6051abc0612ce..f01e9ab68d996 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -37,12 +37,15 @@ struct file;
  * @serialized_data:  The opaque u64 handle, preserve/prepare/freeze may update
  *                    this field.
  * @private_data:     Private data for the file used to hold runtime state that
- *                    is not preserved. Set by the handler's .preserve()
- *                    callback, and must be freed in the handler's
- *                    .unpreserve() callback.
+ *                    is not preserved. For outgoing, set by the handler's
+ *                    .preserve() callback, and must be freed in the handler's
+ *                    .unpreserve() callback. For incoming, set by the handler's
+ *                    .retrieve() callback on success, and must be freed in the
+ *                    handler's .finish() callback.
  *
  * This structure bundles all parameters for the file operation callbacks.
- * The 'data' and 'file' fields are used for both input and output.
+ * The 'file', 'serialized_data' and 'private_data' fields are used for both
+ * input and output.
  */
 struct liveupdate_file_op_args {
 	struct liveupdate_file_handler *handler;
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a39992da504fb..9bda37b0dc4f1 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -145,9 +145,11 @@ static DEFINE_XARRAY(luo_preserved_files);
  *                 .retrieve(), and .finish() callbacks, allowing it to track
  *                 and update its serialized state across phases.
  * @private_data:  Pointer to the private data for the file used to hold runtime
- *                 state that is not preserved. Set by the handler's .preserve()
- *                 callback, and must be freed in the handler's .unpreserve()
- *                 callback.
+ *                 state that is not preserved. For outgoing, set by the
+ *                 handler's .preserve() callback, and must be freed in the
+ *                 handler's .unpreserve() callback. For incoming, set by the
+ *                 handler's .retrieve() callback, and must be freed in the
+ *                 handler's .finish() callback.
  * @retrieve_status: Status code indicating whether a user/kernel in the new kernel has
  *                 successfully called retrieve() on this file. This prevents
  *                 multiple retrieval attempts. A value of 0 means a retrieve()
@@ -616,6 +618,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	}
 
 	luo_file->file = args.file;
+	luo_file->private_data = args.private_data;
 	/* Get reference so we can keep this file in LUO until finish */
 	get_file(luo_file->file);
 
@@ -643,6 +646,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
 		args.session = luo_session_from_file_set(file_set);
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
+		args.private_data = luo_file->private_data;
 		args.retrieve_status = luo_file->retrieve_status;
 		can_finish = luo_file->fh->ops->can_finish(&args);
 	}
@@ -661,6 +665,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 	args.session = luo_session_from_file_set(file_set);
 	args.file = luo_file->file;
 	args.serialized_data = luo_file->serialized_data;
+	args.private_data = luo_file->private_data;
 	args.retrieve_status = luo_file->retrieve_status;
 
 	luo_file->fh->ops->finish(&args);
-- 
2.56.0.542.g3ef89b7020-goog


