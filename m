Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C9CE606A880
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I9B+/s3S
Received: by kanga.kvack.org (Postfix)
	id 2D1046B05BC; Sat, 14 Nov 2026 08:06:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287C56B05BD; Sat, 14 Nov 2026 08:06:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1708B6B05BE; Sat, 14 Nov 2026 08:06:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF0306B05BC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:06:28 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 831B11403E0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:28 +0000 (UTC)
X-FDA: 85433748456.28.0C46B23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B21E3140005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I9B+/s3S";
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661586;
	b=OA0a11ZSvG88P+cyjcSkZD8777l3XcQI89sUnZ3aExgEpKTZaRslnoA0J8Po3u/W9rBR3x
	0L9gBTHcu0y0UgiDhX1TRXJWtev9m9rT5NnYL87njV2OXqP3m48Gc+BCzAcZEfCCH+yswY
	eW/VmfbtF/hOmo+CBY6N3V1W9afKThQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I9B+/s3S";
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgs4W2I6jyh9uREhF01VP/+x2A31fQRHH6KrlL4045A=;
	b=wvP6klG68o5f13bpdP4pAp///lOJQeeK6iqujwIFZ3u5LygmhsIZuwoa+ecPL7Evq2SZ0x
	LHOEb1cwkIHguU0jjim88XtDN2nDf0R71X6ZFGCLAUqWZrk69JyW07c/dMIpxoKuh4WmM2
	sk8TDGEjJpNfux2BY4bxSvhhwcOeo7U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 06AA043F84;
	Sat, 14 Nov 2026 13:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FFF1F000C5;
	Sat, 14 Nov 2026 13:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661585;
	bh=sgs4W2I6jyh9uREhF01VP/+x2A31fQRHH6KrlL4045A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=I9B+/s3SELG5SM0WBcJJ+bzQ/9D/re85FCznroL591YvUWc373nL+cSoL9KAp5RzK
	 UAh2zDRAYca50XtY7i3Tv4dodLxUqwxwTo2T9y328XqGTzT8IyJSGT3uFDH00JS2T6
	 EmiF1Vj4PKvUBCKINcK3PbEeYMUAMCvP9Gwl/5SG+hbMaqVkskZ0molDV0KZnu3Dmp
	 NgeJizS1V2OJr/io2hOpe8FKvhrr83bhr29d2bsfERf6pIH/dHMJUK+wRnrFmqvU3f
	 798wauulfg3yNQCuADzs9Ljrm2YDVHH17AWN68OdKsAAZ/GzaSDoSqD3oCKUBTXELN
	 V6mLbqYofrsZg==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:48 +0100
Subject: [PATCH RFC v2 07/42] binfmt_misc: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-7-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
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
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1333; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ExZBUVvx9r18SdKJrfF6sZNEu0ZA1ZdlFfR0zqTTCHU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iMlN/XnopuTFo6lJxTd/lFacnmUbf2Z+/TRuvSOBu
 QvLsicc7ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhI9CaGf2YzWpQXz5uauPyd
 QYfojx9XuhxufHopucU0dfExi7nVe3UZGeYEPZk6NXJx2gyhu7MtpNqPZ5epOWzy0e3YWn9nhtf
 PRWwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: btirb5bqeqhjmt45bcso91zutag4atpb
X-Rspamd-Queue-Id: B21E3140005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794661586-728585
X-HE-Meta: U2FsdGVkX1+Iv6jTuzcPypm42eyAYVmZronv9PKExPesRO8ap+cLrnmUryJcI0gO1GxfNTj7gpXu5eb7Lmu5B6Y8wR0UuSa39D/FsbxkVsGhAnsleaHwPsfZMgkQog2sW7aXgEX/OEaEhDZL4VLzaFuJkA1fhoiwEYEjuv8YUmnl5Is7RKDseMnaFjRFHp8DWS+jPehKUQnbArylBiYP2nuJXHfrpyDIGUJ3D4N14fzV5NkHt/530i3XLlT7fu3tKI+YFfTp8boY5WdpcutxECWomrXRtrQNdsCSH1I8eYhPLkLVjI2mPtp43objZGEizNqYrdSo8WmE+wjKFZH4gyUQAiwbnDn2ui6hnGaOlnRF2XJBE0Cy/6iXbi9i6S5s8tXwq5fIfhHOenDl/lpJSIZPJkhhMrjeByW6beBaEjNpuKBW4ZxRHScY4l0Q2P+mVuJEG+tT82J1qEI9ikMq5b5OroZItUrF39UlUCvX1aVfduskD1h4AyoCj/POCDzEg8tCeDxmJDcLbfcf5s53v/8Ex22t+m/xtRAVUV9+rzrO1HjTRimfBqwgqMGy3pUI/O2MQ57tv67xRQMzhFinUXYBVsfMCGpx7YoNeK13ofUfBJrc0lg0kKP7jEcBSZHGIkubHUXRUdSvDUNKneVQayJIOH5hWGDsZe+EjA9S5LPv2CFho/YXI0c0zZDT3cz+H3ybNuzuxhNBSI+c78YzKbvUP/T4wBgXlhTy+BWCwxPKvYygkppFpOhR/WRitnO6xxG6RbeF1S30V1vJQKiuf2I9bJqoAXuD5oYwVeWUmbKoRnZVgUlKtPKRLRm36XNxmTSqkbXylJyY0MFHWA121F39rZ8KB3moJBamTnN38Tfi33kpkuK6ePx6CoX5cmXH84ykkWcEIlnvDVXxCsFXw1YUp0AagP6dxT12rpW/DnkHS/QguhraI23l6aG6pxatNQQTd5AyjVIzKjCHBoo
 +fvHiIcZ
 wJbDPuX34or0abrU+6OiJXEsUu2blm08eSfYuu8yRKQqy2Kr5JVXVL5yjQ9JILFUqksRolep86fRhfEZBOmcvuc5+eInZBi3uAFdhxDrl7k2LDNpnAqr8w5ZfjfaO4B7rYpzCJKwem7mUGrNCoMo9d+qmImCRoH2QzlvXdantCMjicHfElDHmXnCPspiZKGa7Nmsv0jOKTiGfkA7uNyqqQ8+hLuAPMTbU3T6WtXCcn1AiJ4onJ4gbhlgZTvPO2LrZP/ykG1sm6TgDIcEO/eIlbL0zEROQFsRF1nWpBBswoImfbv1n52/1dUvUHid8C4g1k+HwIg4cn4CvKhBKXHFb6kSYbLPG0EJYVhfa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize binfmt_misc as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index d945b4f6e1581..7dc233becd98d 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -22,6 +22,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/init.h>
 #include <linux/kstrtox.h>
 #include <linux/limits.h>
@@ -1575,8 +1576,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (user_ns != current_user_ns())
 		return -EINVAL;
 
-	/* Never exec off this instance and never let anything stack on it. */
-	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
+	/* Never let anything stack on this instance. */
 	sb->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
 
 	/*
@@ -1660,6 +1660,7 @@ static void bm_kill_sb(struct super_block *sb)
 
 static int bm_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &bm_context_ops;
 	return 0;
 }

-- 
2.53.0


