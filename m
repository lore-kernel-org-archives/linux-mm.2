Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C52606A8A4
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GQEYXCeI
Received: by kanga.kvack.org (Postfix)
	id F19AE6B05B7; Mon, 16 Nov 2026 04:44:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2A56B05B8; Mon, 16 Nov 2026 04:44:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6C966B05B9; Mon, 16 Nov 2026 04:44:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A0F516B05B7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:44:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 17CA21204E9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:44:59 +0000 (UTC)
X-FDA: 85440498318.12.9BFBEC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 50D1D40005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:44:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQEYXCeI;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822297;
	b=5dcb+gnU680ALISLt2d8yCbL5ztC6H7B08uul4nKNr9RXIZV+eDVOzIHXgtrm1Bt11PPOW
	Go6Oh4ahNsAt0tIwwQO1tRxko8IdivA0vgoaJCNQsdrME4AdejG2almK/PtuRzX4YJqTjI
	oIHm7B1dlVqAZSvlMJxgPRuj5oP1uzE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GQEYXCeI;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WQF/2nGODv0RRGHLUgReoktqpsZiCbfLp8w8v9L+bo=;
	b=6u1FC7ZQD9qkuz0QUHwuHbf1GsC+Ta8WCWx7MxE/jgglDQXU2sAroJdNZGAAMOWtCQdkSj
	q4orQ8RwOFPAIR4rZKst8KGdF+x5yrPPQXCJW3kzGpOjTKGuTdLiXr4WseMYfmHcOBLHOr
	IMYW0/PJEC3SH/ux1gahRB7id8yZaQI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 905F5408A9;
	Mon, 16 Nov 2026 09:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D381F000CC;
	Mon, 16 Nov 2026 09:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822296;
	bh=5WQF/2nGODv0RRGHLUgReoktqpsZiCbfLp8w8v9L+bo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GQEYXCeInNJNAeSXEXFEaAtWT2pWKfXmT0uj5OKSMGSwAZpGDUl37UqyhzlDm5GEG
	 BJUy2JglWLls31L/8g5AWG7c4DdKsHzXa3oSV1q8edhD/T1G7ufA9Fo7XYm39kwMlH
	 KefHuyXMwSbcRY+eFQ9fyIqpEvAAHcD5qW/9rfiPozawtenYPH+c0KvyKkjoe1E5kO
	 GOa+n43b8NPEOrOc1pdtKWHzCCvn7pS1DS7I4tj7dynE33KUafW7bIU8XXI/iBQFmV
	 NOnCcfQYEelSkfTZfBgtpRZumhwflU+10AIdufOzVTUORUd8EXwNOudR16x4cPwpAa
	 msGqOmtJHy4aw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:03 +0100
Subject: [PATCH v2 06/13] ima: handle errors from resolving the real inode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-ovl-d_real-v2-6-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4587; i=brauner@kernel.org;
 h=from:subject:message-id; bh=LT4oKx89iCAnb882W//c+yjvL+VroCgoISJRbee7R7o=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulDasUJ4a7H1JOlnMzLdimdH5T+JcPi6Wbphd6P07
 EXnfnRkdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk1mlGhlOVX5wfnwu4t9pX
 UDw5g/frTp1r8uz6936wGe7UKNlxq5Dhn+Unm0Ovfh7aIq375aFK1lcuRQXtf1MDP1xfV/hoOqd
 wEjMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 50D1D40005
X-Stat-Signature: dcxrut59ncnx7789xmt1szqrz3y1kkmq
X-Rspam-User: 
X-HE-Tag: 1794822297-357106
X-HE-Meta: U2FsdGVkX18htL3BEaWZmCDy4F8I3wrC3MoOc5pAHK8JOXRcXWJdQRW7Je4eK1GaVFQwKA2b4FHZIy0TXKLFlsgGOdHYu7E7Y4572/J9kuVCprEyRIqPpKZcZZ7OhLiROCx6W47y/8A91f13RM9uA7bX1TQZCk4fRODihFQNspSVhtAFf4GpVR5wvetBMBVdO8c3hbmIvHICt89H58VbtR3sS7mc5y3pSKFBJ8vyGp+bBEab8oEtATE3Tm79sbRjFUuxye1plFNQ9P1I0QshJfW+/tZXped1ZrdaDh4EJrza1eTfFaZlItPtcdjo49pjDJbFg0glS/++KyK13+xV3JrechBIOVxsayfmSbaeDL7op9LNZU8Fxl2TS+aM8VVZtHSu4L2BYWmjej6epEu0jjAD5Ma4M1jX/nT3l3yQeUvAE0/0Tdy0MxsD28viMqf1p1n7LG3nJfZrF0AwPg2o2iU2022eSxgq2QxgvYrW/noW5iltepdba8RlCwJT0X+BYsupeLe/oaepNK88agXey0BzM00ToS7TkW1JAAde6AXu1A5ZN3nZRVzQAKF2vvXSodwOC1Ds54MV0dcIVJOXCGrUHkn032uXt4yhP1lpI2W9UkPxTPyrunVxrC4qb26fRMdY9gNvW6L9jHkFAVlnbLgC4TSrDcPsYvUzmD9d440+ACLsY57DirgboIN1EZZz9svkPtnFvzKoXjSoTOMH1Npi97NtsGSQLYpC73mr0JZDQnWd2zS4g1eIo9K//7GcnuzbY/EE6wmFlRuOpM5sXU2wxhaT621kCZBMIXhZIJY0JNekJeRMVQtvQsnEHR3wv0oI8WF1m4sockAcNn19ueN/lItk8pa1Gp/nZy4z82lcV9xP+2FcpQ/wqiRH9KFNOGKidzBQ9Y6bRhJnbGkbqoKplWftk9b6tW3wXr37By5+W6jzLg0ehmdZoc9RhkqKS3BEQMWc5fGCXhFr9mJ
 2klcsm1n
 tJvjOFvmTkcOY6GhdEoOtYU58yYasXjWiSUKa5rE2MEogHRPerWjHPWekLt7Z0JBvuJL0YRZ1/UQ7MUQOKmeKozzztrNJRNZ98vrQN9hTEYI8RMZWuES7hl4ykoAHhUYAhkaVUJfjdtDDAUlO0+2vzhTmyr4ZxRAc76/GJxPluN9PLCDjiO5huRaW6Le+9c+or5SSQYzJR8wjlUf/yrt9ec7QcDqr+uS8pXoIpg9mzHVAu18WvLQz4PBFcQ==
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


