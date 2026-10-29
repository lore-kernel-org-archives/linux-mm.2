Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA2D7606A324
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T4FHlTua
Received: by kanga.kvack.org (Postfix)
	id 9A7836B05E5; Thu, 29 Oct 2026 12:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930E26B05E7; Thu, 29 Oct 2026 12:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86D7B6B05E8; Thu, 29 Oct 2026 12:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56E486B05E5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:08:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1ACF16045C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:44 +0000 (UTC)
X-FDA: 85376146968.10.E62638A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2C104C000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:08:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T4FHlTua;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793290123;
	b=rWSvIGZPpmOVTn05Eznxel53P0iKBxPU8pEYmKpDc3U7jOhbQrXu3OBbCU9CAwhyMeuRKl
	fT5nkU+Hw2IdA184EHRm+P80p0ovIClbZ4KGVLX6364mR8TWA01rMkaOJ+KqsXUh9DX9Lp
	hk+NRjfAbzybiIOLNtWFOGE1NJkfmLU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T4FHlTua;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793290123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/BWnxppliWOmynaxs29fGFYt24wOTlqSg4Z+oJtQIpE=;
	b=3UuV1H3AH6hG3AFW6OuxCRlF1QrVCT4UIoNRVM5QLlD1bgZBAQKRpKajBHXdkeESRuZYNp
	1MjXV96+h4pzhm0lIbGs8JMsTIIwxX8YIxV2XVKjJCqnNO/Xwd5ZkTG8BHlqbZAa+QoSLg
	PMxF3eElIyoG1cAxv9D/E/rJQumWhVg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C4D0460623;
	Thu, 29 Oct 2026 16:08:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5271F01824;
	Thu, 29 Oct 2026 16:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290122;
	bh=/BWnxppliWOmynaxs29fGFYt24wOTlqSg4Z+oJtQIpE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=T4FHlTuaqRfJAzhzCJ1btbf9e9sQyfvqdPREw/hMRAZdwLVUfHioRc2GTMQk7m/Av
	 2o8qceLJnuQ2Yniqjw/EI832tf2PwdxCwRlaxHl16mcmqJZO4D6F6+vJvM2CccQq7S
	 d8IbekTfL7lPE3H8b7JebgeIIlsg3LMhu4lP5zsXw1KzJmDjPCMqNHAe3cqFv0NnYI
	 y8vSgEvao271qfeUB+qAukuKn9h2OT+A+b4YvvRN1s3kwce9Xm0dE9Taa/eLsXMr+B
	 RULIjQrSOsznLFzL+PV2X0/RQEIiZXkdAy/pbh/jXxpbd4uSL9f/ixbr+wf9ftMbCu
	 SIkpazprBoNQQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:10 +0100
Subject: [PATCH v2 19/34] ocfs2: keep the current mount options on remount
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-19-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1795; i=brauner@kernel.org;
 h=from:subject:message-id; bh=eukLrrIxQyicjG2U7lt02AzXtZXtBti4CMni+Zukyzg=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9ztfv235vgZqSUfy7nl9S1Zb3vNWKDwVoPmOSTdg12
 eA617SFHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPxYGRk+L9wWf2hvo7qmqqP
 2+Zo8Fumh+e/Y//8tNqO69baothaA4b/VbffPt52dXHp0bKpmSd+bP3lIOr3Iuey5iGbpa+27no
 rxQAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: r7s97bic1z5t73meg36rw8kkr974me71
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2C104C000B
X-Rspam-User: 
X-HE-Tag: 1793290123-576676
X-HE-Meta: U2FsdGVkX1+kM+miQqGihTM0sypGUDuJehTRuE/+2WwWEieejPiYZbtWC9INE5A1m7d+1hR8qIK/8qgU8JXYfLFxCWBkXu21NVqj4fGKY7ilCpBIYHhJBuWxhkXZdm1m9oi4TbMoYWzJ9447jf1IN/Rhwmlwrg72br9Oa3KZ83zdd9fTuHINUPQV84TwPABhQDL0gkerlAJnAEyhHXYUKcZuybSdd9YeStqETZL8OkjIk4NwfCuRaOgbLSkYLrZ2I8h37YPkUZhewyHI6K6E+nG8PRFF3GB5pmj/AwJCSFmhKeAyQsrbfaW+QcemMOEGS9q5hCE8aRiwCugUKVj4U1W6yJBikVqYSKuzUBCBUaUO79J3a6B+3K4AelBSvMvtlW+XYmOIu/PRMhxbW6Df/T+SesLtlmcby+rbhzWTcCpB2oLccht3d6g5u0ddXiDCLKyFWK5wX/gD87U+ZtMIuMcxZK5UFN99T0AAeqHZyFKyz9hJEa8HX35Tmzb5ktM1L8JFE3WhFIIoy6XauMyyY9KiptSVtl/3E9YWt004ds27PPKkRrZE4M5S+O+uMNZgeco6GOluk6HzQ61WTSVnqkUvzmNpb8tcQd5FHyKoSytSKHdircGzi30uI83eX+XMZgWqvuOum/1QCH5vEBtwnCuhumzh18k1GSpMXTC0PDMGkDbNgtuDH6Wsgc0YqDsC6NQ7/b1qJ1rCYA9TvBIt8DbL1PqzN/od0VSwvBDCR273zFA+nGp9M0DGjK8sUvwcIiac508d2GYRuuGwJeM0D6i9xdAJZvLAUa/Fkx4zzZ1ecLcgVr82K75nOPr2gwDdMKPNF43xNE0A8dXuOuDuxczRMrljkW7ZZkj+jKEPyXs6VT7MOeIFQo7NcFjxUH+BWAkDKzNlWB8XVDd7ZmLGma6lfkSZRi/i2xonEMePNCmXPb/FE2kThyplMZhO5+Eyz7IUnBGA2QqFzSEEzuY
 QBHQYDxo
 eP/Ec0yl+6lnbsmSFPQZn37ME0Tw87nG5u/RyXkEMXuhe88WisizN5uG3o3AITFrJ8CValtjpb6Ec6nYUvzCyewxNiAAlK5H8mc3QrKYF0FEQnSAXLaaQw0ebm28rrW99+hjuh/aLHElsWUOUCmHyfbTZUWGRoVDS2yM8fByKw/soBXnq1/CulJ1ih+A3cZKWU6nLrUe5jpkt0VcUGh82vzQHXM6ykBKA4JF68tmBp56Z2smZ7vyX0CQrTArCrpIRWeKiReVPglxTx3LlusUr7WM3CP9DaiuusXW0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ocfs2_init_fs_context() doesn't inherit the current mount options for a
reconfigure. But ocfs2_check_set_options() insists on exactly one
heartbeat mode and ocfs2_reconfigure() refuses to change the data mode.
So every remount without heartbeat= fails with EINVAL, including
emergency remount (sysrq u) which passes no options at all, and that
WARNs for every ocfs2 mounted read-write. A remount that does pass
heartbeat= silently resets every option it doesn't repeat, e.g. noacl,
errors=, barrier= and preferred_slot=.

So start a reconfigure from the current options like exfat and gfs2 do.
Asking for a different data or heartbeat mode still fails with EINVAL.

The next patch stops ocfs2 from setting SB_RDONLY after errors. An
errored ocfs2 then stays read-write and emergency remount would run into
this as well.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ocfs2/super.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0af2245ae303..67283244426e 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1222,6 +1222,19 @@ static int ocfs2_init_fs_context(struct fs_context *fc)
 	mopt->resv_level = OCFS2_DEFAULT_RESV_LEVEL;
 	mopt->dir_resv_level = -1;
 
+	/*
+	 * Start from the current options so a remount only changes what it
+	 * specifies, emergency remount passes none at all.
+	 */
+	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
+		struct ocfs2_super *osb = OCFS2_SB(fc->root->d_sb);
+
+		mopt->mount_opt = osb->s_mount_opt;
+		mopt->atime_quantum = osb->s_atime_quantum;
+		mopt->slot = osb->preferred_slot;
+		mopt->user_stack = ocfs2_userspace_stack(osb);
+	}
+
 	fc->fs_private = mopt;
 	fc->ops = &ocfs2_context_ops;
 

-- 
2.53.0


