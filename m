Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E103560A260C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QFTzAogi
Received: by kanga.kvack.org (Postfix)
	id 782476B05B9; Sun, 15 Nov 2026 09:02:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E45E6B05BA; Sun, 15 Nov 2026 09:02:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AC496B05BB; Sun, 15 Nov 2026 09:02:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3AE5A6B05B9
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:02:37 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4E4BA0739
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:36 +0000 (UTC)
X-FDA: 85437518712.10.63346BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0CE96180004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFTzAogi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794751355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfCScPvxBu5oZg9xpGXlkIMcGAYL0ttu2zAfyVzw/Yc=;
	b=XdICkiumvbVBCpAlVz+n/TQf8yAfoEXCsMfB0UXokQSZMZHK0gkmMEuLyB1yO0bgjcnBHm
	6yOImO+5u1BNluKHQ1pn/cHCxDntdFXXg5hCYGmYBTgEWo47OZ6IGcKIhHpCZnT/0KqTEn
	UfDKPQbAle4ENLpxhzyBgQptfZadCIQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFTzAogi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794751355;
	b=wcJH94XLE3V5I3ITLC7vEbDbHNQbuiovKNe9ZrPYzpb8lf196Bk7YVrBotAWMmfvM8GSl7
	OU/bu3Kpcdlu0xhjy+iTPzyuu3VmYmchXxchpFXO0Bwku5FWRpU/ra3WEpnzsgJqToVV4M
	GDWHxNIR/bZOneG5TR5MQjA08T90e+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5576845933;
	Sun, 15 Nov 2026 14:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB64E1F000C8;
	Sun, 15 Nov 2026 14:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751354;
	bh=jfCScPvxBu5oZg9xpGXlkIMcGAYL0ttu2zAfyVzw/Yc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QFTzAogiTbCfihWO3f4nfNW3u7SKK3MVvEZ1oFb/D9/jZbtrkEEjAcikJXz03GUAz
	 O+2MFT3ENDSo/8Fg6o13JEku1L6BgiAzQ8Nq0WqTyIkY/nA8tmH69yukq+OF7MwiUd
	 JkUuMOqSUSArsSWU1DfeX/2NtfKyKu/iexpt7zOpbU1jCs9eXja0iAD+1qPMDN3o5R
	 V5pBYxrkSY73qql/ErRY24RvAj/QK8+AnaIp5e4hmGxtOnsMqJ7U/8NNWhTiwplXOd
	 C3lxpeORF5lcZx1/eX+hRwAr8Pa71Cyb0kWkh3Nu6IW3DZKDinbqwp1NWda5XrEAWr
	 1ZO0qRF79vemA==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:37 +0100
Subject: [PATCH 07/13] ima,evm: use d_real_metadata_inode()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-work-ovl-d_real-v1-7-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1773; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DlAMm46RiTZx7jjK5X0U0ynYF8/+mqpchcvWazipVxw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B2+79T833xcF/k+Hq08UiOWl9a77eEKzgixvGulA
 kJ7+S5/7ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIYjgjw9Glp43MuUNVLy0T
 zFpy/n6F2zHeCMOt/bvVZzkIFVnd3sXIMNFm+wHTAGVt1xhDkTPJqz9e3/vxoartpDUBeeF6e45
 eYwYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0CE96180004
X-Stat-Signature: 4fhjj74b5ioux7913kpzt3w9zukyezuo
X-Rspam-User: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794751354-171655
X-HE-Meta: U2FsdGVkX186p2+BMLZoE5ht7nX6AHI0DEAu+MPnMoozZrP9GKFg9mfiJbuDXth0zOiuiuWSH/OcNlW7lhLmn764kLN1b7xs9+PuPIeapTnn3lQ1IWvpPVEUIbycmRecZefD//VQCrfdEvSCicZZZIq2B6bpnpLh8EWugZUjDDMUiLt2UogIQKB+3Xj1K/5dps/7scB4vYgLWP5Wx3ULLuEsO25TmxL7NBcTfrdXyVakmcCCqAAygD0hmzOLZBsJZMH889R1NCEmmMWf2cIsmcPLe51ZLLRol2BhPJNPXEoL8zrwGqon20WrfIznmOoiu7DKaeDeV/ftCWgjPtqZLDJ5es99/eDcWK1B8gFG7ZUOsmdDZYsUanTHts/VpUhqlz7y1pf08KZ+uZjXkk2xiNrvH1buzwdEYIc4tAI7DL3JTulEONJmP9x5k8f4cJOY2dLFDkHnsnUQf5rwhq3WjSt4vwbydl3P3RFy4cdouAT/cAQdmHht5uTi0TEeZG2hnuA0yy9h1let6jJqKsVg6l0LSw3T+vBMuKwl/EgUDrBy+bB4+EA8tFlR/Sepkbf5fRRDYDRKFU2vcz5HeDmk9Rg8tJ3HtPHGOZd20RccG8/ntt0wyFn4cD68VkmuxU6BZv4Da9njrJp1j4viVTkWkkAECkSBM262M5CzquVXIrVFzC9C5ozjoXYX3alxeAQqoweeKk0OKAyUWWLy6Tm4435zDI+GP6GfwzeY8sWN1benHvCfHyIpcamwNoarYI4XQp9oCaRTN3lsDq00H1kgrCRhtnLWI0dEE0IQiMhGiFcVXwnlfvofx5MWVnNu/7IK7JN7ubpV+LG5CEAY55yhQtp90kbye+sA+2WPiXMBz08lIiWvgz36TA/jngUA4MgO1TOF/BN5/dvdGxb0oQ5TYVOG38gMpddxPx+DnyZW7MMniKNMBbPdMFMPFv3rOy1sZ5Cjfk3r2MSrDiICzYj
 Y0BNSuPY
 xCJKbLWDGCT3PpZjA0H1chD72AMVcnSOI1/yX5GfFyAfhFIUDS0e1gmmWVVy2mpqUOOSukZmY0ck4dKOMLAIJO/4pWSn26RwE1aLTmG5LsqDsZc0B5Vu9Gi757LbkFMw/x46Ho3Zx7U6rZeYTQUZWqoIQGb34OfR7eHp8jaRSZzcQzRIaUhw3XK0SlmdJ/LEe+nonISkRrOYmKp2UIeY4zr4Z5M04JGsI+0cTa+d2r78XQxyGFa02/Wc2oA87+xj4hhwfSMZXzofOS/4wBImmEVQHY0kfq5GD3OEk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

d_real() is about to be able to fail for D_REAL_DATA. D_REAL_METADATA
never has to look anything up and can't fail. Make that explicit and
switch the open-coded d_inode(d_real(..., D_REAL_METADATA)) in
process_measurement() and evm_calc_hmac_or_hash() over to
d_real_metadata_inode().

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/integrity/evm/evm_crypto.c | 2 +-
 security/integrity/ima/ima_main.c   | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 1c41af2f91a60..1b50cb4913d0b 100644
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
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index e463cfc1e3f43..9df7fbe3523e8 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -359,8 +359,7 @@ static int process_measurement(struct file *file, const struct cred *cred,
 		/*
 		 * Reset the EVM status when metadata changed.
 		 */
-		metadata_inode = d_inode(d_real(file_dentry(file),
-					 D_REAL_METADATA));
+		metadata_inode = d_real_metadata_inode(file_dentry(file));
 		if (evm_metadata_changed(inode, metadata_inode))
 			iint->flags &= ~(IMA_APPRAISED |
 					 IMA_APPRAISED_SUBMASK);

-- 
2.53.0


