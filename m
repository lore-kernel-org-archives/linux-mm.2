Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E59606A8B1
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hol6NkIG
Received: by kanga.kvack.org (Postfix)
	id 6BECC6B05B8; Sun, 15 Nov 2026 09:02:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66EF16B05B9; Sun, 15 Nov 2026 09:02:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55EB96B05BA; Sun, 15 Nov 2026 09:02:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3676B05B8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:02:34 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0341C073D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:33 +0000 (UTC)
X-FDA: 85437518586.23.82B4EB8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id E92F82000E
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hol6NkIG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794751352;
	b=khaDQ+1VRQqwnyvFOtk7gya+DeeWMPCuK7C2yVLROBnMm3lYPrqUG/sWH/dPo7AYnSrjBY
	uf60WgjKmMz8TrDZW2X53aQSo2Z97ufevhsBb0s0HRIA9Vu5ZwcYdLNhTGJN4jTpi/Bq3p
	WWOJeWNM9ywEj7zuBD3y3m5wWWdp7NY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794751352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WQF/2nGODv0RRGHLUgReoktqpsZiCbfLp8w8v9L+bo=;
	b=g4voKZ+RdOpLG/e7I/hvUr6xbQX6WGcIoPCPe2toJjDUFgQk9uuLQ3u+7qNTUyHnHFEVkM
	q++PJ/mMFjOOC0hDzM9V6/CsScw+7JrFQ/Vb6s91mIdUuuJjxWbb9pDGnAzsqLrl3atP26
	twqQ3dETRZosHGmoDoVzlm/8RraPAho=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hol6NkIG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 811F3623CD;
	Sun, 15 Nov 2026 14:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78C41F000C4;
	Sun, 15 Nov 2026 14:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751351;
	bh=5WQF/2nGODv0RRGHLUgReoktqpsZiCbfLp8w8v9L+bo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hol6NkIGw2hStecb3jR/CYWDaHiuLyonnC5QyeK1BKr7BDtmGoCvOZWVe1mUQ0pr/
	 w+vmvc+N7GFJLvOuyd/o/GnizaPE0ixqvHIXsR34CcOS12K5a1uReO8YBaD75TAB29
	 9ucMO9LoX9sko338XJpILft7notYLzVAmq0pg9xPkl8VAGse7QuZQ8SIArbFvM0tx1
	 XFg5vO8wltX+jj3ZDGEo1CovJW3hcCVK3jF15wG3BAIABar+t/yqy7AlPs1nWxk4Jy
	 xKidxCQdmQ1NxHks6VqoVIF2erFk17YD3xpLs/iEdryQ7f+dQwt8TpngLZVwAUL5lQ
	 GXyWw/U501fIg==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:36 +0100
Subject: [PATCH 06/13] ima: handle errors from resolving the real inode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-work-ovl-d_real-v1-6-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4587; i=brauner@kernel.org;
 h=from:subject:message-id; bh=LT4oKx89iCAnb882W//c+yjvL+VroCgoISJRbee7R7o=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B2msc5j4fbvKx24LBh5Qm49aN/zT115eVX3unZxA
 emnPGwNHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNZX8HIsDB8xzTjadKlIZnf
 9OJ+lC6xWqGX93q9zeFpb0P0W34vPcjwP8Pe9luBxq93b5W2rj+5yTfFarb04+tBh5SK2JXWPsu
 vZwQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: E92F82000E
X-Rspamd-Server: rspam12
X-Stat-Signature: wky6fxph5pd5597cjkom1aarpqt78hun
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794751351-563730
X-HE-Meta: U2FsdGVkX18SzCa1tgwnA2tVtzc6K5EPSA8RsoaifSMH4MDnkLBUZvFeM8ZF+nG2ZwuAccNnsEWvPqhGoR26LW2Ny3fhIhXLLnrRb/niiZwA51EnIkWPZmfRYSxBHMaM7u1ws72GsywVAks8uEAJSpmOHkgtslOffrq5GVkYuewR2l7LJ0P9xE3/+EiiodxQrAxcEx5g2jwGpz6rbdaLR65VmBSL0+MQo1dz9gdVFDS9FdKqy0ARv417rYORCSl/FFTvmQ/FqdjxxKuzsFVEbZOkRUTIYFnc2cD33v4tIoDQbFcTujwUFIjGc/JbdgkBX3C1BfyYluW4K88Hu7BNDbyfVudHugbRXxT/d9sHTisL+33My10VWtWhVpY1EuwVnU9WCMoXLvgPHLxfnc18zj4ri/KYFIFuMxDLQkFXLxydzAkDtGk177Uo1ly+3dLPhtAbMXqIU2dFT0c2s3om3xu7CNMN0uy/1a2+8ewiDq9syoYVZKbqHdmUM0Q9DSG5ivoj49dyBxh4rEmxZbWp3dpPF8N1CCiY/OEiP9nVglzX74CATNu19xJFy0upjQwMDR/Bett1b7AwYWT4+PAPampRO1NG9DyJ/RK/xfh4F4aKA71zAvbG3BNLgpflmcaYZrmAatdGgJGIEmshG/ouv8WnJJc3nkGyoum8oNxFsnz3ak2ItpESJXf2xetzbohwQMDPC7h1JuNOSZNw4NMqopPaeaYkwOzb/+mZZt5vYr2dm8wU50G7X2xWJHXdtxO0XIyAxmrl9uLP3ZQbJfldNZUsakwLfmhSjyvBSJvwIMJ4VxGsvHb0c0XRJliWHgmOXx9e5nxhUS4ikLb+Z9pfLq4hyXsG3/+RSNaxNMmYgkl4RhDg/L4IYyj2Gt76oCvELUDEyQEgcfCLXhPFqe3b6uFBmBF+IxVPco4kbzRTqEYP9JPpGEe8Lv0Zo1e7VRRQhjupfXyRuiKUWSW/O1u
 w4otctvD
 rkcFOGZyoREP16LIEmXSwLXL4dUJE2TxDEXMo6LVVDWv5PEwLqTTp6r5+q7sXavVwb+hnaDV6yapH1SVpiYUArq5kPhsm5iEqrtS+Jr1H6IzM2UroNJfdt2tWPjA+KiBjRQKoc79s5/zudXeOz4TMsl6d8BJCNi0wNAZLNj91I0SNGCKs+gNTvIHMP4OXMBOTnNUYewJBFA1QiNpu9zSzkSuiNfj38SOUT3elxHAVEMcHKAEfZHpOnHaEHjtMLCoyZKnuMHqfRanB79INBPzZGCaFsr3m3e4nndyON+Z5f0OaGtUEk/RnYZv+kOQn8q+i8PsU97xr4MfC6lO3Q222nMYSzRJZKkohJYjUCH1wJV0qbDFCwpjnbXZAV7rZKKxW0SSnnH7DgqVRTZg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

d_real() is about to be able to fail for D_REAL_DATA. So switch IMA
from d_real_inode() to d_real_data_inode() and deal with the error.

Currently, if overlayfs fails to resolve the data of a file it hands
back the overlayfs inode. process_measurement() then sees
real_inode == inode, skips the detection of changes in the backing file
and returns the cached verdict. That's the wrong default. With
metacopy and verity this isn't limited to files nobody opened yet
either. A metadata-only copy-up of an open file makes overlayfs validate
the verity digest of the data again on the next D_REAL_DATA lookup and
that can fail.

So if the inode hosting the data can't be resolved in
process_measurement() we can't tell whether the data changed. Treat it
like a change and clear IMA_DONE_MASK and measured_pcrs so the file is
evaluated again. The metadata check for EVM stays independent of that.

This is a no-op until d_real() can actually fail.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/integrity/ima/ima_api.c  | 17 +++++++++++++----
 security/integrity/ima/ima_main.c |  8 +++++---
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 45701f04ba62f..f8c3437559943 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -246,7 +246,7 @@ int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file,
 {
 	const char *audit_cause = "failed";
 	struct inode *inode = file_inode(file);
-	struct inode *real_inode = d_real_inode(file_dentry(file));
+	struct inode *real_inode;
 	struct ima_max_digest_data hash;
 	struct ima_digest_data *hash_hdr = container_of(&hash.hdr,
 						struct ima_digest_data, hdr);
@@ -268,6 +268,13 @@ int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file,
 	if (iint->flags & IMA_COLLECTED)
 		goto out;
 
+	/*
+	 * On stacked filesystems the inode hosting the data may have to be
+	 * looked up and that can fail. Treat it like failing to calculate
+	 * the hash.
+	 */
+	real_inode = d_real_data_inode(file_dentry(file));
+
 	/*
 	 * Detect file change based on STATX_CHANGE_COOKIE, when supported,
 	 * and fallback to detecting file change based on i_version.
@@ -280,7 +287,7 @@ int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file,
 				   AT_STATX_SYNC_AS_STAT);
 	if (!result && (stat.result_mask & STATX_CHANGE_COOKIE))
 		i_version = stat.change_cookie;
-	else if (IS_I_VERSION(real_inode))
+	else if (!IS_ERR(real_inode) && IS_I_VERSION(real_inode))
 		i_version = inode_peek_iversion(real_inode);
 
 	hash.hdr.algo = algo;
@@ -289,7 +296,9 @@ int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file,
 	/* Initialize hash digest to 0's in case of failure */
 	memset(&hash.digest, 0, sizeof(hash.digest));
 
-	if (iint->flags & IMA_VERITY_REQUIRED) {
+	if (IS_ERR(real_inode)) {
+		result = PTR_ERR(real_inode);
+	} else if (iint->flags & IMA_VERITY_REQUIRED) {
 		if (!ima_get_verity_digest(iint, inode, &hash)) {
 			audit_cause = "no-verity-digest";
 			result = -ENODATA;
@@ -314,7 +323,7 @@ int ima_collect_measurement(struct ima_iint_cache *iint, struct file *file,
 	memcpy(iint->ima_hash, &hash, length);
 	if (real_inode == inode)
 		iint->real_inode.version = i_version;
-	else
+	else if (!IS_ERR(real_inode))
 		integrity_inode_attrs_store(&iint->real_inode, i_version,
 					    real_inode);
 
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index fed80da3ee096..e463cfc1e3f43 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -342,12 +342,14 @@ static int process_measurement(struct file *file, const struct cred *cred,
 
 	/*
 	 * On stacked filesystems, detect and re-evaluate file data and
-	 * metadata changes.
+	 * metadata changes. If the inode hosting the data can't be resolved
+	 * we can't tell whether the data changed. Re-evaluate the file then
+	 * and let ima_collect_measurement() fail.
 	 */
-	real_inode = d_real_inode(file_dentry(file));
+	real_inode = d_real_data_inode(file_dentry(file));
 	if (real_inode != inode &&
 	    (action & IMA_DO_MASK) && (iint->flags & IMA_DONE_MASK)) {
-		if (!IS_I_VERSION(real_inode) ||
+		if (IS_ERR(real_inode) || !IS_I_VERSION(real_inode) ||
 		    integrity_inode_attrs_changed(&iint->real_inode,
 						  real_inode)) {
 			iint->flags &= ~IMA_DONE_MASK;

-- 
2.53.0


