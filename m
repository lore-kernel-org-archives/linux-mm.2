Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73DF560A263B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jk/FjUy0
Received: by kanga.kvack.org (Postfix)
	id 9B8256B05E0; Mon, 16 Nov 2026 06:07:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940FD6B05E1; Mon, 16 Nov 2026 06:07:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8585C6B05E2; Mon, 16 Nov 2026 06:07:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 620B86B05E0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:07:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECEFF1A090D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:07 +0000 (UTC)
X-FDA: 85440705294.25.986797C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 298B940007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jk/FjUy0";
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZjUZ/LbyySofwJKchunYgmcW+hv6mWM9r+0t30zrAC4=;
	b=dUuNJPFXlf14ManBqF1JJoPz49KgiTp/u8JzMk9awmfCLZvVeaMMhmZhS0tsZ98B2tRBGr
	69LkSdSZbIaEzjiJmMCy4V2vtpYEhGMsRc636ioAATJXXfab5JEAdSEVbxGvXUqdVQoB1d
	VsTlCya5YDtazB2exhA1Q4dT2OPwDNI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jk/FjUy0";
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827226;
	b=iBtoecBTFNtmAk0qGRDurKstiAu3Co29GxuWVjHLCBYV+ZV+dWHUR76qoev8cbE2LKfvrK
	AaExJsRpT62GvO4tV3EGMEDmVX6nm90KPTOKUUtFUzbT+eeVha+g+U707jJHUfq+ryIoLR
	e5hGPJk+b2rHBNeCFU+a3ctHkT5knco=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 780A64398A;
	Mon, 16 Nov 2026 11:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EBE1F000CC;
	Mon, 16 Nov 2026 11:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827225;
	bh=ZjUZ/LbyySofwJKchunYgmcW+hv6mWM9r+0t30zrAC4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jk/FjUy0cS6GgqVt9SsPloY8k3i4CqrkgFOMuEfM9XpfG/P/xdaYstLnK6As2uWUx
	 DEasrHPORlAiJurUDvkuRuudCdX4+089Oc2tRistqib9WEwQ5lBrReoBhl8MhZJbHr
	 l6aBHu8foX0BKN0F6xwxKuR1wHN/HENZS+AdFP226DO8djRCuCN7EcShhykNWGeUfv
	 2qReXmfM4j5HwLrmWLj8INf6brOXbWCkQPlzkcCvyFZ79G4NtpxPZuc+Bt5iZoOrkI
	 QVXW8/XVnBthjiWRTNhaVer+CxRfjJN9ob0t6JGwEOzJgRSBms1wlYdaktJYkpCcpN
	 a/EAYoQOnhFDQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:41 +0100
Subject: [PATCH RFC v3 08/44] mqueue: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-8-8cbbea1cf34f@kernel.org>
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
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1349; i=brauner@kernel.org;
 h=from:subject:message-id; bh=eUpb/5VRc6uGUB6tbJ3+67OknD2n3CMn6o+Ub0d1Knw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epzhGiew20J0pdn/rc+br7ncYiy+qrz264M7t5VXX
 HtelL34bkcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBESi0YGV5Vvm5S2zypdNU1
 0asTlm32TIpeYct0smnHH95QyWeSPuEM/x1bNttw/OG9Ib/orjXbnP81Nr9VO1SydlbPvJgivPC
 LNT8A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 8wc8njjcznkbe7c98ooiqnz75jffj58a
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 298B940007
X-HE-Tag: 1794827226-829218
X-HE-Meta: U2FsdGVkX1/q4kgVY66R5F3+xx2VBNBzc4wkOJ0cJE6sYWq7fSOxFnTUAsD17zrAE/26yQW6iEMaRAJ4eInAkGkd0XNTBBB7GGcqPo7u+qVvIAyBOvm1eUxAO662v/aRPvpmUeI1KAltDfrx2SpKfXjk7FG7+H2nfB7SGJKQZ1Is3hwtNka2RzLHIAfpCAOrUh1/CN25EZdzq2KRsCeR8brmJv3cBiDsnOiaksu8BY8y7qcs4Z50H+GDJRCeMjC+xFbth7Mp0XkQtsCuO6K1QQBIChUUv5ULo7yQKHDft4kKKMOVvBMm5hEkgb1cXHj9ZRDPTlSphh/Ck8k0xNk2/wD6R2UlGkdkTVqQefTdGJN/iEXCX1+Au2dV3+j6AlIo6Q4HVgE1LCLVaIiWgO18M944rwGwdT+sOR2eVCcT7aDk9yNF3BESZbm7rWAaut4olqMlqioJrOl53YjAOjOwhkTZnxkV0PtmkkBUv7SRuxbN9WcuN+JBBzi3992u2pqO5vO5LBBnfYdJdGIxCk8X9u30FmL2aXnJ8SLdCU1SHn+QJlBUJGQk/mHN4ViNG+p/F4FZ5YQJcq4taJG183gpBaKGUiiI7k2G3o5pn1Nxm1OzZiIxsrXDq45SRZVZ2v45NSBa7pjS55kGe1vqfwkOhrhoGp16oiVWkB3vV6Z1r5wmLTINAKxnPfDo0x2Uo1MJINBzrE8KEMiCcZAljiO6FDCbbSRtuDR3sz/jSOR873qPkQ1iV444Na98iKxWF19dQO0V+B1EB5r0U9xqtrqUcLwJbyIel0vifJsWLZhrcGZtsTwiIyYQ1C2MP2OAuu34v09XFCfmhL8Ak5cW3H4qhdMuje/YOIImU3SKAv6QH9fV/5otMK6PXVSHHfouGRlVLlhLYknYHAIKlZ4+Wy844S5jzfV73mxFxwDYAff3od9qmampJWwqi3YzTLrcfkbklpoUn3y2SWl5cfm+nM5
 OkosEeRu
 iv//5q4TwTgiIGCk8MMH6sC2pAImrmVWx+Lc6X42GKJJT3AnOpXWcEcwqua32YFK9wmEg+iPCkOPz+AkNG+R33qvkkeCDjCqC20rGX7iEdSgJgBYIiPURyzUxVZLL7EAKIycBMPtXcJb46iC3kpkOj1s8Q/3xz5gjUQALvDNw8Jim4T59ajib7JS7zx8+2bVWi4RHpKqL4VoKnXPLEDg0MBOIK8X0tK05PivhSl5gtEQhCoBJn/Iwnx6b+BD3Fwkwrb2V1iJRrRRMcPTM1DRGqNkVRlh6LZgRN1PFuD6CjqH3JMtxTg4bgoNNLkH4UqMoQdy55TKzEpl1v4GPV+Sezswl5kZ7AsK+AewX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize mqueue as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 ipc/mqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 322c3dd98c447..8bbe32d0881f2 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -18,6 +18,7 @@
 #include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/namei.h>
 #include <linux/sysctl.h>
 #include <linux/poll.h>
@@ -405,7 +406,6 @@ static int mqueue_fill_super(struct super_block *sb, struct fs_context *fc)
 	struct inode *inode;
 	struct ipc_namespace *ns = sb->s_fs_info;
 
-	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
 	sb->s_blocksize = PAGE_SIZE;
 	sb->s_blocksize_bits = PAGE_SHIFT;
 	sb->s_magic = MQUEUE_MAGIC;
@@ -457,6 +457,7 @@ static int mqueue_init_fs_context(struct fs_context *fc)
 	put_user_ns(fc->user_ns);
 	fc->user_ns = get_user_ns(ctx->ipc_ns->user_ns);
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &mqueue_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


