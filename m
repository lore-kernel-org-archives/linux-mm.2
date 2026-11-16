Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BD3F60724EF
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g2frNxrg
Received: by kanga.kvack.org (Postfix)
	id 9E10A6B05E7; Mon, 16 Nov 2026 06:07:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 990E56B05E8; Mon, 16 Nov 2026 06:07:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87FD96B05E9; Mon, 16 Nov 2026 06:07:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6490F6B05E7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:07:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 091EA1A0907
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:30 +0000 (UTC)
X-FDA: 85440706260.08.FC71F66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 489A6180007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g2frNxrg;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WqIZi0cu6VIwI+9lCXiohYR/wzGXA5+EoTR/jNdb16Q=;
	b=2EiEBTmPr4jhWK7cvQZVKoY5ILn4dt+vxlx93hdcDMhgsazPpqw5FYddKRzOJJ8l5YFK/M
	Bd7HbW8DmlOEwQpnd3jMm0HM2tGdb58EPgYN5bFVkFQ9wI3iTrPd3229pZ//MD6DDpzMy9
	9wXius3sDq/RWSEEdAEEX7qvaYx+ufw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827248;
	b=JraOt3g/shc0bRtuRpH3IS2/+2kuebZsFUY8ejyKlkHQ1IVwRO6d7K01UNHtKmiUs09NNz
	61spMtMoHmx+WRzJK05E2wIHQ9RExeoXdVy38Z3w1jNdBEuYRzTFF/suSP+BilqC8oYxxN
	LjWd4FxdnlqSweep1XpAhrWNfeKa/EE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g2frNxrg;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8994441B60;
	Mon, 16 Nov 2026 11:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB291F000C4;
	Mon, 16 Nov 2026 11:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827247;
	bh=WqIZi0cu6VIwI+9lCXiohYR/wzGXA5+EoTR/jNdb16Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=g2frNxrgZo6gLuMwR6+xhSzuQz+NeN4PVS9PDKJxwGORwkeyKjneTNcs+fOXdfC0l
	 RiANOUi2u3Nw9Vjt5yQENMMlt2EbmVD9lpUujX88ZtQwjdWgVyUWDOMyPVuk5v+kdF
	 5NNRbJZ5dMlswOWW1+VX2aiKkmFocxNzYdlRCv3rX+6xwPv1g4Qcuh+KqAzxmlSL2Y
	 D19MD06Zt7l/6/v1MV+tZrtsA5OEEdLYhuFnRi6vP/WLBwDKdf40fkzIDuPnjMz8xR
	 dzG1nGsc0L2M0llokOCNc/BbiBjwr0VV5fECKZc6IdgZGS5W+/CRlryJSKAc4ThDZ7
	 GHqrx5WtpvCCA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:44 +0100
Subject: [PATCH RFC v3 11/44] failfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-11-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1012; i=brauner@kernel.org;
 h=from:subject:message-id; bh=iq4zyAUpqzVmiSNBanL4il/lHhHkqTjKQJsO807AsZU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epytN2PB6sVPK4Ls46WOb9KbO+HDinbZW+LiVx6qS
 0YIPZzp0lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjAR5wJGho/Kk16y/xT/9GVr
 hPf6HXuyP0gtWSXm85b71oS8V53MAvKMDOtOs7GW7A+SE/Hk3mjdNMUzMG3LLqvcy41pByWaLmw
 u4AQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: mewsk8t7knuk5tohcyousm9n6eu5nj3i
X-Rspamd-Queue-Id: 489A6180007
X-Rspam-User: 
X-HE-Tag: 1794827248-246190
X-HE-Meta: U2FsdGVkX1+CKGs9fkDp/z8wDRAGhWloM5zX/WlHtDSI4X5v6Do5y6Cih25bwwHE/sFn/kwhqnsNC8UGlJ/Po5DM0QigvrI/gx8QspYM+lcOxgEUueMzhv2nq6gXWF5jw3O9BvYumVWizoqXPNREFcDNjPQB/+WA1la/APCqgV6th/Bdofd1a71L2QkQ5uuidOuVOwo7rHxUC8597MXeGWeijYzbs+QVGUmO6Iwj0DuW+4DQfY7H65l9EIMeoX5gTVSr9TWnHqtIVTNKkLbiFnpH1Ss5IcuvubCn2seBCg7WcS3pzjtJ/N1hmA8fWg+lH399HYa5FzoVCY1djG4oV104/mCLUB7MX3VbfJZrsqD7VcxvNKAXYBZy+xddeCMKUWPLNid1K7Nql79dFDoF2GcEfxRsBJc0ckx9HReS+mt8Z3ishBUx6NkwKOGcLhhekZcxo/sMej6E6X4Or4mZXVLIAKNq+6kf0KMO/SES5iBEmFXkTZr2UGjE0l6JxIKz+V0xlkzhePgjiTSsbiy4+4UWbhomk6hHq/qmi9FXUspyB3f4VoLDV2YNNUUcUL3XR3KU3UOsHRyWPxlZiHqPDFeQ/5HsuCKyvuBZzXehYT1A99WWGPZWZjs4CyVRKGMwQTAK5RPbAopGKJL2nqxeQrDcpfj/VzVY+60h+6zSLdbAJnH2gSue+kcxnYd8ncE7fZerVIONITiULSKBenqQjbRZmMxfdJfryUIht/4Z+g4Ohq6niMg7wwJelErMpJpvuS2ZM7ZHkBTR7dvFcsJzu94Fl+X208ZFSqy3MjSo97G2oEWeMM1rlJIpck44iSBEEzUBZXwvfXwinzHr75eqLSMwUnV0UliUSAPTHKYoqfdYaxQ0YguuzNim5ho9CKghEuNCTeAjjKsEQs1F5Cw/4WyvQZ4cXvdO/9g4d9LsnZoMoZVfA62w6e/Smu/OvQ4BtB/hx5gLdl7Vw7bVnRG
 lOtabaf4
 8u6zXPPjC6xFauvUMO9IXwRPkZsmBZ/Mfsi/tjYbjCqFpX1V234qfBAWrIRDQdRFG8RB1ZjNLgoK8A3oFtRyGd/9WP6qSsK9RKDwCVJqARTy6gWkjS3RcsplG0mGi0SR3hRKDLjQN6AkGQm46edOG8aisJCxP2l+mdDjviXTW0cEp7pi6EtFA3h4hvbPUj+8D8rXt8bnn7RzcnTYaX1qumMBCzHNLEqPTPZxoo+dj7HGOdEoqvXsR1/FdGE3sAYsRCfCQVzD/435VCCmB+7izSB1askFXzk+1ZHi9cluPoSfAARE89SvwbVP4x9iC46GSySJy6ao8o7SuPDk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize failfs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/failfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/failfs.c b/fs/failfs.c
index 437cdc981c2de..f03334f361c0e 100644
--- a/fs/failfs.c
+++ b/fs/failfs.c
@@ -3,6 +3,7 @@
 #include <linux/fs.h>
 #include <linux/fs/super_types.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/mount.h>
@@ -132,7 +133,7 @@ static int failfs_init_fs_context(struct fs_context *fc)
 	fc->ops		= &failfs_context_ops;
 	fc->global	= true;
 	fc->sb_flags	|= SB_NOUSER;
-	fc->s_iflags	|= SB_I_NOEXEC | SB_I_NODEV;
+	fc_init_pseudo(fc);
 	return 0;
 }
 

-- 
2.53.0


