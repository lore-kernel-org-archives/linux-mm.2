Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2B1A60A5BE8
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j9ddginL
Received: by kanga.kvack.org (Postfix)
	id 8BAC06B05BB; Sun, 15 Nov 2026 09:02:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81DB76B05BC; Sun, 15 Nov 2026 09:02:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E5B76B05BD; Sun, 15 Nov 2026 09:02:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42BE16B05BB
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:02:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4F9F140706
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:39 +0000 (UTC)
X-FDA: 85437518838.24.21792B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id ED2BB2000F
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j9ddginL;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794751358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJ0EchGlVA269SbkEhgc06ZWAj446vqDrn2p8jAuv/E=;
	b=CnYe5Aj7TgWSbsBFT5BogXb3DMIOMWcTvotE41KAOrNX8/GE+UiHR6dmrlwL0wKa9duRd6
	p9MZr9sCRKMk/4DDQ57F5SAZw+ZPG/3CPa4c1fQRPBrlhNetwcyQT6uluue5W3xdo3ei8E
	EiDgo4HTS5ho2IwFLXj6btl+hb33IMM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794751358;
	b=5KVFJNiZNHAfF6UN8SJ3nk9ZY8nDCfvP5VPWYbqNu06eHshOkhj6Kcnj06IuSVmHC1uO45
	aaBpMzbH0uxhnkdvWUmZCwhLduyMuowaMTK2Kyp73kBxm4KYv1P98blU6srTgR+mVAG+u9
	TeQfZGfYx8aoe5T1KgHJApL1TfNcS5c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j9ddginL;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EFE645A6F;
	Sun, 15 Nov 2026 14:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE30F1F000CD;
	Sun, 15 Nov 2026 14:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751357;
	bh=qJ0EchGlVA269SbkEhgc06ZWAj446vqDrn2p8jAuv/E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=j9ddginL1G0GxAHDpTjszI0GOWTyBzsRGUoqoOS/Eq8EtiggIDFzkrpgaY+H2IhoP
	 F7aqPREaqPHqyq4OWyMq1EFrAlM4QIX3S8k4pDFGQwI7QWeE2U5nOf8pNR8VpggXuZ
	 MA1gn14DoMP0a7WU8bqRZ5MQCZCUhB45HgWBLR4H9dxZ/IXff8SUQG8rNjQahgLXg4
	 +AH8yGJ424iNwn3m70UcEEcndFSWEe99TefI+eeanISs9IGtZvBjIwrADK98N4ryJF
	 q2PksGa1dCMIgZ8X9dxuC9g1esWHbuQWvX3PpeLUnne4rIxIyHyBSgOQ0Z859r9Hh8
	 T/9hROhAfl1nQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:38 +0100
Subject: [PATCH 08/13] ipe: handle errors from resolving the real inode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-work-ovl-d_real-v1-8-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2633; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5DKvK6nh9WS+g3ryQ++IdJj14tjmxK81GaGi01tWosw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B05rfno6g8PCtlUrx64aLL53fxOYZOOh/+aGYKkd
 4cJLlAW7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIFmNGhjtnWnuNPd2FTQ9o
 zxPitZL93r+hRG6BfmmXsTpLMrvvPIb/Hjr7DYQrrr/flR1urazf7bq6ZpaMxQb+LiuRs/v4roj
 wAAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: zxfjceaj18kwpp9wh7nxpwqrrismmy7j
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: ED2BB2000F
X-Rspam-User: 
X-HE-Tag: 1794751357-746353
X-HE-Meta: U2FsdGVkX18aKlLN71C3TR0YBOc8ejT3Alsa3CrXOMaV1v1y4/j+CMEncS3XnLxb6gy4/UADM+FvnqD7rynqoSgfjIMnl8UnrVkAjVhJpMSUsrwAt5V83opBiboR1MN5ppLrVzrCuWTSsWTYvkQb6Em351csefdOSLAyIQsf4lIMn5XHOwxmmPzOnol455hFwZbIHiADO/nHRf9BM0dmhKNMv6FnioNex3fvGyn9Qm9VkmvzryHZwEDAdc6oaUCRNXW9c1wEdld8gd9djStzZsxpsQkhPul6CqrAD4mqP0/u9voUzoBEDimLdBFPQl3H5zkskhfxLqstr4H2PwupY4pbSWH+wi4mOfVO8DceQ+2VSJvZLiiIWiF29QhR4q19eLUIyFG50fzlZOEfDTQtAjPmB1CjRcWRppSfBy9NKXIoKnGuixKns3RJe3mI/2aEeAuEDEVfovAQZDUxrufVM3No1agKxml18CmfLJyHu8fyqT6g+ZfJhGJq6n5KpFopsCwlVDe0ONOe441v4kw1KpAJkKiZYvvWk+tcpyGufvRs4eNQokwB1Gad182h7m9LILlDncUQqdIQKoly9rx0v3h9nxRY2jeAb+GE5iZpMjMWpRiYbqYTBPiKi8Nofs82it/yyV+uWJ2yeTufWPjQLqfD5YICmVd9AhKUq1aVMVwExmBvZFkXkSascRFALb707QUHdM+sWb4pkbDg4A7468Gi5/BRHsZltM6mBgtADw9MJc2ZHag7zdlEqIfwnwxW56XuGKjQEXSE5CTU7QJRC5vvd0YQNSu4pPWZnW3t5oxJ9bX5HVvnSPsMMQ9/xbp6Lck7u6qkc+4zz0oHC7C4QOTxPJOiAVW1kWO2TADOEW0sw8c0ECLT+TcxohICAvB71dFQaw9bm/cKOpcxCD3XOb9avrkLdjoYDy9Iv9V1LrYpidQbBdlTrPfHjS+4q91Kdw1D8gWMsZhluhhYeSF
 p1hXqMMu
 9hKYq3rs8jHLC/K2e0pwtJ7rehQ2URLMtJ6XCxxY89H0nky/Zdtv5z0bcm0M20ZUxatkcDD0nB465RZFKNb3VZhw4NqhzJc4ZOdmPZcHR23nCfG2GfvfWUijDJg6/Unddh7D5PGSED7+0F7w4Ve8PgLrn/BGyjfK5Mrce31TOo8kRgo8Uvf+90EVa4MHu6p1t/aK/h/cpOjtzmf1Jg6qABUdzq2vIHoXb2PCCOJLgueh/PohHgubMBVnJ5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

d_real() is about to be able to fail for D_REAL_DATA. So switch
ipe_build_eval_ctx() from d_real_inode() to d_real_data_inode() and deal
with the error.

Currently, if overlayfs fails to resolve the data of a file it hands
back the overlayfs inode and IPE evaluates the policy against that. The
overlayfs inode has neither a block device nor any fs-verity state so
none of the properties of the file hosting the data are visible.

Remember the error in the evaluation context and if a policy is loaded
refuse the operation with -EACCES without looking at the rules. That's
what IPE returns for every denial and what IMA returns when it can't
appraise a file. Permissive mode allows it like any other denial and
without a policy IPE still allows everything.

Note that the operation wouldn't necessarily fail on its own. overlayfs
doesn't verify the data again on mmap() so a file whose data can't be
resolved could otherwise be mapped executable.

This is a no-op until d_real() can actually fail.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 security/ipe/eval.c | 15 ++++++++++++++-
 security/ipe/eval.h |  1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/security/ipe/eval.c b/security/ipe/eval.c
index 4a7be96c84f03..3751963509df4 100644
--- a/security/ipe/eval.c
+++ b/security/ipe/eval.c
@@ -102,7 +102,11 @@ void ipe_build_eval_ctx(struct ipe_eval_ctx *ctx,
 
 	if (file) {
 		build_ipe_sb_ctx(ctx, file);
-		ino = d_real_inode(file->f_path.dentry);
+		ino = d_real_data_inode(file->f_path.dentry);
+		if (IS_ERR(ino)) {
+			ctx->file_err = PTR_ERR(ino);
+			return;
+		}
 		build_ipe_bdev_ctx(ctx, ino);
 		build_ipe_inode_ctx(ctx, ino);
 	}
@@ -335,6 +339,15 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
 		return 0;
 	}
 
+	/*
+	 * Without the inode hosting the data none of the properties of the
+	 * file can be evaluated. Refuse it unless IPE is permissive.
+	 */
+	if (ctx->file_err) {
+		rcu_read_unlock();
+		return READ_ONCE(enforce) ? -EACCES : 0;
+	}
+
 	if (ctx->op == IPE_OP_INVALID) {
 		if (pol->parsed->global_default_action == IPE_ACTION_INVALID) {
 			WARN(1, "no default rule set for unknown op, ALLOW it");
diff --git a/security/ipe/eval.h b/security/ipe/eval.h
index b26d1147d0708..58ca50987b2b5 100644
--- a/security/ipe/eval.h
+++ b/security/ipe/eval.h
@@ -42,6 +42,7 @@ struct ipe_eval_ctx {
 	enum ipe_hook_type hook;
 
 	const struct file *file;
+	int file_err;
 	bool initramfs;
 #ifdef CONFIG_IPE_PROP_DM_VERITY
 	const struct ipe_bdev *ipe_bdev;

-- 
2.53.0


