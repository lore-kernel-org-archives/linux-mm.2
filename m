Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24239606A899
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hV6+oygS
Received: by kanga.kvack.org (Postfix)
	id 0253B6B05B8; Mon, 16 Nov 2026 04:45:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1A96B05B9; Mon, 16 Nov 2026 04:45:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6AB36B05BA; Mon, 16 Nov 2026 04:45:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A37D46B05B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:45:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 364CCA86CB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:45:02 +0000 (UTC)
X-FDA: 85440498444.12.729221A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7E3A11C000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:45:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hV6+oygS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eRdg9HeWYxK8nNNdp54EXfNgXm8ZdA21oo0OWAWt0Yc=;
	b=YRQ6Y2PQvCTSHtMFm+tJtVWn/d4ol6i/fx7SPcQtvDPywPTCmI348gbj9ysGpKkf8DHxcA
	YUO78YmXMCF1uupe1gz0yF0+OYRLs2toO495nu28TzeTPs64Lpyh4Dwjm15PDjGRgdzCNm
	79ba7zFR4FZK7TGBdRR+H5cXRm6xoag=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hV6+oygS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822300;
	b=HFG/ur0KjVGrAgfMd/zauIpggsMSt9Mxv8I6YH2ylN8fZpMzHcpuiwleG5zRYlKMqo5sun
	L0tIpPds4UeRfiUYkJx+k7keuex8r/IGts0QKTeYcJ2ud+C+Cc5eXORKCuL0d/Jek+w8LL
	nwk9Eo/TPE1b1MkCopcQa4/RObUZyzE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 212AB6062C;
	Mon, 16 Nov 2026 09:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27011F000C7;
	Mon, 16 Nov 2026 09:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822299;
	bh=eRdg9HeWYxK8nNNdp54EXfNgXm8ZdA21oo0OWAWt0Yc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hV6+oygSuLM7mo2IAC2neqmAEwNr2wmgk3IsHnHwJYmLo9/4Evwf0XZ+KeDO3NAZi
	 wfQ1nENiCbl5daVGHl6kw6gL8mEuI5TGlN8Lkd6Sw+fmbSIHnqT7/K8xHsMZG1Er3k
	 U3ytQvFZRiwT24bmSDaz4fOld7poaqGCANDF9YkmvuO63A55t51KgZ3Pa9XR8lKyBP
	 e17AHIskq7aB6QoBN59yIf3oTZdEZpfgD5S79QIWSoee/dW2CQKAKj6Wg43w6qIdC0
	 dKVLLLWiZjzIi/7lMyeL8Kw9KKLuScV/7NUJvDs+rdqxA7HdpFGRXr1vRFHOh8lMcY
	 uTY4LaLu3cd/Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:04 +0100
Subject: [PATCH v2 07/13] ima,evm: use d_real_metadata_inode()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-ovl-d_real-v2-7-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=4060; i=brauner@kernel.org;
 h=from:subject:message-id; bh=cGRzxBqY++Wn5nl5/qGAoLXdWcB+rZ3GJOCpw8/hvZI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulBmqd1lwebvqHsuxPPzqit9hzczca1b5PhNmn2Pq
 VcAYxhLRwkLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwESyjBgZFqv39t1aPcXpe0TR
 ROH56nzbW+U1pRUTRb33RTCpFuxgZvhxYFLG1oOXd7Caq/BOqJF13XI7O/xu0WmlIwskb1+N2cA
 AAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7E3A11C000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kdsf79zpomtuj1titmfm8g65tnpnmk8u
X-HE-Tag: 1794822300-79726
X-HE-Meta: U2FsdGVkX1/+1AwEruLAy46RfFplPuqqPkSBJgy+7gSfKuW1ga2kJcBuD0S79BjKBe1bf3eSABZi+1WWl396cYgCYZAvfwR+XozMjUFnfzD5duxLQ3ktoYL06gFw/P2538dD6aUySvMsiI3/lXUxxjObgBlVbntUCVaQBbSyWZBfTndgVTexDjVnlv2jN6VHis+ngZTZEGjIezgnIw1WYlnbHXGqvVBg/xR8EudAuxn2CdVydLI1r+9GR8G0cfZYZfNVMmHdIS/9NOSnMLk1GQEQCs1iVKkIRiXkaVktAQLFnQPQwB6MUcY4CvUbfJKufUGhCTa8u9ifL2Vauu4yxWsh1PCg3kmnCEzzItcinGHcOJGPUcU3Ynwdz+ONAWN36gOlEcUpUiO023nJ1ec3D69M2/TZMBBJNdHkl1FbhIMAqLfCgRQTv4S72CBSmuMefriPdqBWWuIohKoivrBJI5dxLtsGJFxzJw7nHch58F/Ob7DSPsK9jZPzSJbvUdPqAhnUJVQZ8AsDNBwCMzZl5Zgyuel3cPTm5ls1A93SBUHv5GtRD5/WFWYentnuD4lzI3BBGfFKjYTojgAnFQQ2ODs3DiOkdGRxU0c655KMGL1BKYSox19HPQ5ntiH2dxN/MVOM/EXVoWeMi6/cxauMuQCH2oqFJjGbmaDdOUgDW4ScDOHhG0hUHbMn8goTA95+4sFj4O+eTvhCz4G/w90uLdvkY2VwI3OBRdd3UAR1IUCq23rdXhETD57W94Y4Lnxvlj/7vm4WwbDHJ0YHVhWflYCEVJLTZXpVW5LxBdsCG9bV2HXBC9lZAnKQUuRrThBiq0pgAFP6Ypzmlk+CjXkgB1hkHgxq1oYyd1Yeu4PpQk0P2zGfejW0kIKXIhf08mtTIZzGtOWaic7zhZm89ZTOVPu+ozwJKYuk47942Kp82IQLw35WaapXODWrAQ8b5MFmvd/jDpF/ZQCvMhcURzZ
 OBH8bLUs
 Qig+yhcePFTeueysDj+aG27tgq6G1ENGbRm+HPTfEde2mKjC6LKa+SCcZmdWb82bNjM0Ved+GOsV1/JztEkDuDP9qMMGc3xM4SIM8dRosKi3PN5Ru1syek7WVhqGsQF9mlPY1PjBFAGoPzI3jft5XoS9YdHfrhOAosJ9IQeGS/jJErFWDkL50px0gIowumve7bbCoZN1fnWT6wy/EgIAT85i8a+GWkKZCr4Z8RBpD4upFFJoDVUfD0LPlOG6Bcgqy5KQq8dis3E8JQMEk4cKQw+9PLt+CfeMTFo2Erlm2DjH04EEa9X05PI0aV5PhRATkfyZf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

d_real() is about to be able to fail. D_REAL_METADATA never has to look
anything up but we don't want to promise that it never fails. So switch
the open-coded d_inode(d_real(..., D_REAL_METADATA)) in
process_measurement() and evm_calc_hmac_or_hash() over to
d_real_metadata_inode() and deal with errors.

evm_calc_hmac_or_hash() returns the error so EVM fails to verify the
metadata. process_measurement() passes the error on to
evm_metadata_changed() which treats it like changed metadata and resets
the EVM status. That is needed as evm_verify_hmac() would otherwise hand
out a cached INTEGRITY_PASS without looking at the metadata again.

This is a no-op as long as overlayfs can't fail D_REAL_METADATA.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/all/CAOQ4uxjoHbevvu8auB4m8AVcY9H6uHdDAP6mfi9OOMh+3775xA@mail.gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/integrity/evm/evm_crypto.c | 5 ++++-
 security/integrity/evm/evm_main.c   | 9 +++++----
 security/integrity/ima/ima_main.c   | 6 +++---
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 1c41af2f91a60..17d528771d8fe 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -231,7 +231,7 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
 				 uint8_t type, struct evm_digest *data,
 				 struct evm_iint_cache *iint)
 {
-	struct inode *inode = d_inode(d_real(dentry, D_REAL_METADATA));
+	struct inode *inode = d_real_metadata_inode(dentry);
 	struct xattr_list *xattr;
 	struct shash_desc *desc;
 	size_t xattr_size = 0;
@@ -241,6 +241,9 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
 	bool ima_present = false;
 	u64 i_version = 0;
 
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
 	if (!(inode->i_opflags & IOP_XATTR) ||
 	    inode->i_sb->s_user_ns != &init_user_ns)
 		return -EOPNOTSUPP;
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index ac8328812e6ef..71faf156f9d6b 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -763,11 +763,11 @@ static void evm_reset_status(struct inode *inode)
 /**
  * evm_metadata_changed: Detect changes to the metadata
  * @inode: a file's inode
- * @metadata_inode: metadata inode
+ * @metadata_inode: metadata inode, or an ERR_PTR() if it can't be resolved
  *
  * On a stacked filesystem detect whether the metadata has changed. If this is
- * the case reset the evm_status associated with the inode that represents the
- * file.
+ * the case, or if the metadata inode can't be resolved, reset the evm_status
+ * associated with the inode that represents the file.
  */
 bool evm_metadata_changed(struct inode *inode, struct inode *metadata_inode)
 {
@@ -775,7 +775,8 @@ bool evm_metadata_changed(struct inode *inode, struct inode *metadata_inode)
 	bool ret = false;
 
 	if (iint) {
-		ret = (!IS_I_VERSION(metadata_inode) ||
+		ret = (IS_ERR(metadata_inode) ||
+		       !IS_I_VERSION(metadata_inode) ||
 		       integrity_inode_attrs_changed(&iint->metadata_inode,
 						     metadata_inode));
 		if (ret)
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index e463cfc1e3f43..016de5a66eced 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -357,10 +357,10 @@ static int process_measurement(struct file *file, const struct cred *cred,
 		}
 
 		/*
-		 * Reset the EVM status when metadata changed.
+		 * Reset the EVM status when metadata changed or the inode
+		 * hosting it can't be resolved.
 		 */
-		metadata_inode = d_inode(d_real(file_dentry(file),
-					 D_REAL_METADATA));
+		metadata_inode = d_real_metadata_inode(file_dentry(file));
 		if (evm_metadata_changed(inode, metadata_inode))
 			iint->flags &= ~(IMA_APPRAISED |
 					 IMA_APPRAISED_SUBMASK);

-- 
2.53.0


