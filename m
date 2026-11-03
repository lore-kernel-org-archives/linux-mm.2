Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10C33606D825
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bt1+zkKF
Received: by kanga.kvack.org (Postfix)
	id 241246B05B3; Tue,  3 Nov 2026 13:19:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2191E6B05B4; Tue,  3 Nov 2026 13:19:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12EFC6B05B5; Tue,  3 Nov 2026 13:19:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEFFC6B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:19:33 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8AD61C2F46
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:19:31 +0000 (UTC)
X-FDA: 85394620542.29.B496743
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 36A481A0010
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:19:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bt1+zkKF;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793729970;
	b=LENDvyc2JsBRCPK40KmZhs3+ZVO9p77fflaugW8qA/R8sILOhC0k9sCo5hEUs89PfBfMKl
	KLfsm6o7Awb+Cv/ZcCO0gxtB9iuX8tj0c6D1Lk5GCMbEvKdd8G/9KpFpjf+8+gCZmXO4+c
	JA+XW/Tq80HQycib00xYdJbhVoRB1nI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bt1+zkKF;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793729970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYHOxuzquXBIUkTOvswFznqwg+VfrAF2mXc+DGRaufk=;
	b=70nOQ2GlbF7odpVGXEneHXc28o8+8rVRbibUzpSILNnq1VRyqQciW6wQMEIsNqlAplaqH/
	jXVNFTjOzlUcA/f88f2HclEOtinPl0KBJVj0aqbL6eTnJJn4Z9t0ozJVIzCyhC45wP9qBx
	KPWv7DZPK9gRb0VXWC+HjloJghzcIwc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AAC243D27;
	Tue,  3 Nov 2026 18:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 245421F00A1C;
	Tue,  3 Nov 2026 18:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793729969;
	bh=FYHOxuzquXBIUkTOvswFznqwg+VfrAF2mXc+DGRaufk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bt1+zkKFo0p/VYFtoaUpCeVO3q5Cot/MAaSoDdO3JiIxqdBgddjfqGHVdU99f1yWj
	 RsT6XXcuLwdpqT7Qab6KbC+RyTnGd06cSobRJaWbAoKxvdNKnkWvxmFMjQCOqumBl8
	 takgjwM5VsjAfThX6toPDwysqGPdMju8o34WUTRroShJvepb9fCACdAZdXesrVMKJE
	 0zFf5NU8SdZRixP7e04hwd7Ic/5kKoelEmkDaAuxulY3md1Z3X9wnC/JaDAjGz1Mhx
	 5bVn2I1v8p5m/7t2COrI4myiOIdk36kvbkiHLIcGlK31qI5uR8RK+4eW7NOuA83TUs
	 uroXbiBov88PQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] liveupdate: luo_file: allow keeping private_data from retrieve until finish
Date: Tue,  3 Nov 2026 19:19:13 +0100
Message-ID: <20261103181916.2462825-2-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
In-Reply-To: <20261103181916.2462825-1-pratyush@kernel.org>
References: <20261103181916.2462825-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xozod8fdasd6f6sz7rnbgsji16hd4z4g
X-Rspamd-Queue-Id: 36A481A0010
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793729970-551131
X-HE-Meta: U2FsdGVkX1+ImOrEvg2isjVdMwqGLm3aFPTxSoL78MITZ4oCBCCz3bz4KVdMzlmHfCvV3rBzYU/B7LiSc+sIL0wLjyRq255KBmcIXY7mbmkc2G6r7Pu+J+ahketc1SeGyrieGfYPEKYCdz92uUt1ys4BUimC7igxcFXUJ8aoSUQaeyVAfS3dtHws8meT7+433cAGoB+6R3kfwvaARW86Zh4Gm7lPZ6lvoHk6Dvp+t1bGyDsVPxr4U6gcC2gPjSbJutszmSDN0UuyZcgS0+8qTG1LIgeiulufRFJmF1BGYrNYBpJKocSNYQp/Ath5Fq/VUadJjUQyAtcV7xian+WrbtCLhhv7nNn+082FA1IccNQxeVokrixqQYX6fgE0gKzWgd+aPPzoV2QD8RtDhjC/UcieBaebDaB6BX8UdynnE66+k5R6DLMJmv1dXjvoaVMJ12EVV0T93x9SFzFsLK56jrug95Fj/jLYP5VLLQYz2skSNIdElU4z8tNmIEI8lYha/0nl2xZuTNNwminO38i5RujBNE5k9aQaHYodB/6lh+tfAtnVnwEln7Zu/CwDL82dW9E3h1KdiQJrWbkzR0XDoz/z09B0QxlmRV7BXqAjoj8ta5GGmPG8KW7YNTCw7z75uezTcQdjcnMgDBMNNi/rBIiX0SQqsYgWL7i6npAmsVfpZpI6ZDZ9I8MTfkE+UwSQoF3uVd3X1Mjvl4we+25t81zOIOvVtqAzsEuYqJVCndGyRfVgg4W/J1jH2k7iAo/stxys5nFNys/9UeNdZuYITVxi5MdazD0XONFrCb0vur1uVS0JqPFxVfpJPWSjOyKmCcx8cXlH0keN+p/AQfTdOXKI1uF8jFyOToezLkcb3i0hmqpkiNNG4Rurj/iTPhxhVlX6LCo7ndJp0aB6WFUJzWZwMQ+1/EZ4S3UL06Fic1NVIBVSaRpioZ/MuqFLoy3wMv3lzr4B1Oe6Wz4w5AE
 31sYC8Jx
 UCrLpzM0i+xgm1xQiZapcQO2YcjHq1PLK+wSiFvOlzKGaPo3Mou3LTIo4+qm/Cet7v9e4yvpS230MM6CmWDrWF/vG58dx6+3Oce1R4I3bVurj0gRQKeHzxPhkK7XCddMTQ2LrEVOhU4XsOPvqDlaKf3i7APPsinZEqbI1r+x95nBlxvctr8ts2nx/TvhlKwjXjbCN92xlw2u/mHA164Dhler4SDow6I6+ZQBs8fjneMOA62z0nLTXdhdHdCKE4LsjWGLqmXUka86UBN17qHtvZ07+iw==
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

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/liveupdate.h   |  8 +++++---
 kernel/liveupdate/luo_file.c | 11 ++++++++---
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 63ea5417de849..21caff8a98a7e 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -36,9 +36,11 @@ struct file;
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
  * The 'data' and 'file' fields are used for both input and output.
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index c39f96961a85b..ca4b685d6e1ce 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -130,9 +130,11 @@ static DEFINE_XARRAY(luo_preserved_files);
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
@@ -596,6 +598,7 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 	}
 
 	luo_file->file = args.file;
+	luo_file->private_data = args.private_data;
 	/* Get reference so we can keep this file in LUO until finish */
 	get_file(luo_file->file);
 
@@ -622,6 +625,7 @@ static int luo_file_can_finish_one(struct luo_file_set *file_set,
 		args.handler = luo_file->fh;
 		args.file = luo_file->file;
 		args.serialized_data = luo_file->serialized_data;
+		args.private_data = luo_file->private_data;
 		args.retrieve_status = luo_file->retrieve_status;
 		can_finish = luo_file->fh->ops->can_finish(&args);
 	}
@@ -639,6 +643,7 @@ static void luo_file_finish_one(struct luo_file_set *file_set,
 	args.handler = luo_file->fh;
 	args.file = luo_file->file;
 	args.serialized_data = luo_file->serialized_data;
+	args.private_data = luo_file->private_data;
 	args.retrieve_status = luo_file->retrieve_status;
 
 	luo_file->fh->ops->finish(&args);
-- 
2.56.0.385.gac671c819a-goog


