Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 933A2606B18B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i6Pqa6AK
Received: by kanga.kvack.org (Postfix)
	id B67056B05E9; Mon, 16 Nov 2026 06:07:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B171D6B05EA; Mon, 16 Nov 2026 06:07:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DEFE6B05EB; Mon, 16 Nov 2026 06:07:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 771B76B05E9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:07:37 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F2661408BD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:37 +0000 (UTC)
X-FDA: 85440706554.13.655F08B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 62CE580005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i6Pqa6AK;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unDyG99Rc2/QnFjGnYYD038yieUDExHdgCgrjykz2ZY=;
	b=wMFHdt36mGMZE9PrnaseFu5UnHyHreXPvYJKv44mlxo4R76gxB+xXCtiHq6nV7TGfHyP6Z
	SDE2WbRij5eDyVPTA/Ffua+fq/bBX8FIW83bZdcGxpjIc/zFRy/hi1G69tydqPLBGF7MxE
	mmpFoCQGl2bXABwg7/Bzw9k0W/ehVcw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827255;
	b=VQL/E4XoDVTqwGQ09uyZ3wUdUBNTAyGfV+vZM0ahNuv6jlHOEhQ/jJH+8spuGS2cIX+ur+
	bRi9rTOV6PPXLuIt7YTKml0/ZZXcxireQ/zDTQ3UIc/gC/byO5fVEkMXgadQ4F1fmdmRIL
	86sdl96QInh+N3Yrjt7cvOwBorX35P0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i6Pqa6AK;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E389F62957;
	Mon, 16 Nov 2026 11:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F1A1F000C6;
	Mon, 16 Nov 2026 11:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827254;
	bh=unDyG99Rc2/QnFjGnYYD038yieUDExHdgCgrjykz2ZY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=i6Pqa6AKqSvC4ebvXTzRd7oi7aJBBmSogD2MCZUz+Gnyciubja82o8kqkhXx7dmbJ
	 YZ3OFzxMqg5vhnUqEdYWnGqrDZ2761QlIJx4ugYu46+wc79S1rLXYRAojCd2F8EJPv
	 rWtXzwXgonLmkOAYpmxDxXhGHf+SRv06DZqPMXss0nKRguX50b8hr52CXLrvIrsQJb
	 R/MzhbgN9X3LeDn2FNzkkLWBu7qU92XxamIU3Wyj+KWteLIrApxDfwLHL4PnSlVBp4
	 4nMXDHWmRdwXEYpIJfXlUPY7gsKx2DcnOYAbzXZIfzq7R9duuuzTBHHeDujfTitnZh
	 SUS1JrRQ5cEaw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:45 +0100
Subject: [PATCH RFC v3 12/44] rust_binderfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1351; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Se/hTFkDp0LtS3ScLeBDxadBnc0o/SVsPeEgiuoeVFc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epyT8M69m8XXMjpjcWzYNVUegbmXD+1dF+byklHpx
 K5cB/M7HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPpmcfwP+mi0U8hwxbvvU4l
 Hkm1cav/vpjiVt8euFTLYsOZ/GWeHxgZXjDYxa6vVr+1U1HGOv+SmujnxRGNLG7xKmG5Rrx2IlK
 MAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: ndfw7yrxxjxuikexifpj3g6nrajf63w7
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 62CE580005
X-Rspam-User: 
X-HE-Tag: 1794827255-370837
X-HE-Meta: U2FsdGVkX1/2mOkVTyywyc2+k9m3I7/EnDLZ4dbD4giucwmu4I/DcieMrIifhQH4+57FmIlGUXCHL9bGLHl2vIt/AsPXE0/m5WCIwRDNqkz5tdBqIGwbqJEbfetVD55oFqcwZUq1dDRJOhDZ8SunON7OTftKH+s8g1RnX6cXim78ENvzO2MZMh1Cs3z9r0ZtFiH2BBRcFmkfiRYGHqYKetGvcXe4fUmQtimemdJ+CfFhiGC2zM5v6Kz8jt29iJQ2no1jFKGTYyJcDhsEF7qzpx3vKDIGILOq04RM60/+g8bW++jOSTK35+WQ3iGTgi8Oud7BEo8fqixAG7YOn80mE+dx9+5KFDJCY7nHDe0pt4IG8PLjspsjSXImdOrUKU4pnQPo5AxaGitQ64LlFzwoVU74XoOyHebQkCO5GKYEAPJAjxntu1HSGaB7EEHAUCEsjTHPrcH3qAOppBVcVZFD2cdzVfyGWm3/13SURkv9DeiLBJr+FSGYhesSFDVk2A+TItg8HXzvM5VYXmuAvF9OtE72Sq/zh/UsWp4B3hH9yeJIKFpfCb+O+zEM4wGT6QChyWXrzAxQt1PCYU7ZwVBXkw3scfkn4JC0lwlx5udDsBFR2C9djIh8VHcoDis8vq2eOr+3D9ZixvCqIY/19zbBVmgzVAX/ejDqIj9w2D2L1JuKzls5KWt1R3Fwff5JWfBDau7UcUXLPasCcqdoCpLmo0EPciUjMkkSyUooxZHYis4tIPziBbCri6tbeMutWRRD7Y0ZM3os0N6U2uXGSprFe/ww+5ElIsyallnGvWLg/dIdp7CLLBK50tDbJ96DYG+RIFDb9f6EIxehVLTHND9mRXCw7nE+MejZuhCE/nR6t35DBLS9Uqb5tJC9pC0heXAiI+zUoOUwxB9J/OhZdlL/9TawBwAofNhfPHeXeR4/0ctbgCbPQFXjYFCISRydorVtaCW3NuuLYKz4wAAhKc4
 4QgamhCm
 BLKmZKgV245DD92b5Zr75xa7NOIHGAYPXzN22fKPpHoh0k+dz511f5h7gb++I0FSSpXWtLBMsu3JY8Cp1jSjqc8AEoTrgjvMAvLYZajlrYkHS1/kMeOmtLmKWmVZbg+SqXMKa3Mo69dX+1T2xJC0LeDrFbUFjo+dAE/klqvEXzQXJVAhEgWf4xlN2l08EivX48rDR2lK5yBqTpm+Nm7jvL3MOldRejNxoOZu3N5iyA730PZrjEUy1639LuFrOvnJgPY7uN/oOfwxzvNuwL0BnP3QizDbkiGKsaris/vHiH+FoA2//hxCORl/x4nbOG3fHOVvj5/bP+1ih8vm2FLYaHE9WCVEQhRS5zNvjxnAzyeiXfamHwO4+MFvVJXeHN3+vkvqOoWjDQaVEbFRRAwySIO5kCCPfYMP/5qbtXw0prvR6FLPTFSF1dmpk3qDKBnnujXHj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize binderfs as a pseudo filesystem instead of raising SB_I_NOEXEC
by hand. This adds SB_I_PSEUDO. binderfs_fill_super() keeps clearing
SB_I_NODEV for the binder device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/android/binder/rust_binderfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/android/binder/rust_binderfs.c b/drivers/android/binder/rust_binderfs.c
index 5f020226720db..04468c5b5c116 100644
--- a/drivers/android/binder/rust_binderfs.c
+++ b/drivers/android/binder/rust_binderfs.c
@@ -3,6 +3,7 @@
 #include <linux/compiler_types.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fsnotify.h>
 #include <linux/gfp.h>
 #include <linux/idr.h>
@@ -667,7 +668,6 @@ static int binderfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	 * necessary and safe.
 	 */
 	sb->s_iflags &= ~SB_I_NODEV;
-	sb->s_iflags |= SB_I_NOEXEC;
 	sb->s_magic = RUST_BINDERFS_SUPER_MAGIC;
 	sb->s_op = &binderfs_super_ops;
 	sb->s_time_gran = 1;
@@ -759,6 +759,7 @@ static int binderfs_init_fs_context(struct fs_context *fc)
 	ctx->stats_mode = binderfs_stats_mode_unset;
 
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &binderfs_fs_context_ops;
 
 	return 0;

-- 
2.53.0


