Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A55606B174
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IIsjfWUO
Received: by kanga.kvack.org (Postfix)
	id 640316B05BD; Tue, 10 Nov 2026 04:16:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57C596B05BE; Tue, 10 Nov 2026 04:16:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41D896B05BF; Tue, 10 Nov 2026 04:16:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DEFE6B05BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:16:41 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4CA24014D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:40 +0000 (UTC)
X-FDA: 85418654160.20.C726A65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 031B21A0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IIsjfWUO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mLVLyIpRLrs15SgdOEdgXbdYk/BZhN4swU0iCuBOyic=;
	b=ScpwHnaADTbYvLkiYZb7biFpJD5KPXDA315JXB1Mko1m2n3h6lNQXEcNwrlnk7U7A2jcNE
	Dmnrq1dSF2Y+9+y9aU+RL3kFadRbkyTWRiDjmR0teZO72Qycs0yCZq3LaL6A4nZM8aw/mh
	9LbI6rN3ahUIjbmBLykuWJ6IDT9t90w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302199;
	b=OQNRmi9TyL9T9W/bb7bYxOf33upjH40xOUdHycsn75/buYe1yPIZ8eivu34GCUy9g9MdgS
	dnQ/ehYIe78b+rn2TSZhHZ5zf+3wQuQ8Kl/ZrIrZhPunbUcaZJqTYqCc8k//cUfG+7dhzs
	+qar69ZEGUdKD0ZzgpI77pVMR0WIP2c=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IIsjfWUO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D6D5611FB;
	Tue, 10 Nov 2026 09:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4050E1F008A1;
	Tue, 10 Nov 2026 09:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302198;
	bh=mLVLyIpRLrs15SgdOEdgXbdYk/BZhN4swU0iCuBOyic=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IIsjfWUOtMl2CEA++5Jt8EWp6KRTI2HXcARdUBvCdmTdKWE1uX1aMYAXg8Ea/e8Ql
	 Xql4YvlNPt9K9QrXupja0AV8uGJ4ZeQk3gDHw7i85Y4EbqZiDD29w/gu3h4vBD1pOY
	 iAVha3oPB1bPlmff69yHag/xubD/tLzqQTssa1t0tgnGT7QGrFnYsIwcF9XMVmtUiW
	 K1WSiuD3LOVOs5EqoSIS8TpSROn1Jiuyybk5PLeAHpwhWS+d9EjZQcuJHs/HljUe2V
	 MtagQG38QZOlSaCBeycYDsPJbjUtRGiQhZJCiEt9y8RKsVtp69sly7RCCFqaYz3x8K
	 aiwArWlZiPSgQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:22 +0100
Subject: [PATCH RFC 06/41] proc: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-6-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1267; i=brauner@kernel.org;
 h=from:subject:message-id; bh=gjYrjHbn+wcxnIFNb/oa4teQqFEsQIh0Sk5lJ439ovI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejD77u+nlaqnLf4kFGhsen2irk6irPw3z+y/Bi4hN
 TdYuKQPdpSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExEgY/hJ+PsE4F/232+vH/y
 jeuV3N6zU727BJZKTjAty7kdyLHqgSYjw3K5k6+bop64Mr3ov9715vvhKE+JtjurFy9306rKeaY
 hyQYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: xn7r1e5gfymxx6y35kri7bp54eafrq7t
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 031B21A0006
X-HE-Tag: 1794302198-541820
X-HE-Meta: U2FsdGVkX18mXFzHVR+rk5FigohAs9AwH4n6azqINi25hzy++KoBYJV0kwjhy1D5Etmt4Krm48FUdJKIY97nkDbaxr0adjwTTBT2LF6hq7Vb1thrZBe7EbRWo/3RKj1320TtdU+6vWm+RqrSJm+4caZmzFEezkTIUKw1vggDe4pAQmlVZ5ClRGNczflCXi5JSKZzzirr7wyIM+ddIt81a3Xn/FIS99Z9T3H7isxuJC5oLXTVUrhbdipeQcqcXDTUXInSRNQPRQaeSC4UXb7rivetZJ3ZKlwJHeeG09LoyQs4rdoWBfXL0UQkht3+YQQmV4PbjAK3JW1h14JA2YfP/GxZ7XXRO1yssh6ooq668Ono0fl4Fl6DHU2rovF7XFTUrQkHgfSfeL4wHb+ekGazJRV26EtAjvysZu4fgWl6C23kwRNemWsuXoBCBx6Uyz7tlE5sQWrAKNBm5OT8RoK2LZ6rjG8a9T9vL2/YKAjSV+jQyfK6u450TTTReMu3P3jl5fQumKw5lu9SNJDhrO1cfvxFNN/Y+EE8qlQAqQFXMSRXM/v+x429A3eQxZ3AArN3ggFJkCSWSMf9L8WV1CCTOYDi5wHKaVMxyPDjtN6lDCvBl5GfQCSEEYX9KPL1Tkx802lwaohgdsuV5Gv+V5f/8ZhagttHw0khtWvZLoxIDYmqbbkiPzLmYxWUe5wjp7IcCtBInlTxx/DFuoSYSpt6c4Ihgw9bL3Krdln429M+KFrI0YxRXYKVzLfuOpx9Nl0tzbvKa3/8Poo3fqJQCicpVowVe3/P0L+3pV1xfgr5h+YBh4ZbbVxFLr3A+uBNlzet46l9riYWDb6tfOW45c0vuh9NgV8GkjXlLVw1tZbpslkA29X2edA4LQmiSLWA5YQqty5WzXONKG4fUHA7Gf1EO2Vo6EK/69wB2Qu8p2oUpHgdPsdnqShcVR376KaDIEdNoX0c9obVJjujrC48StE
 A2GTNjQf
 +orbXDwRoMFvi0xip3syCAbuBaS0y0+umbv//e33NhjvZwRgJAsrIKgdsF8aEoVnRYuL+uURRieC9LILzj9SJJ0rzYbIH7m4tYNDpD+hBWl58G1xwN47kjQFsZW2Ht09d4tyBfbE5t/dxdw+C9rhOKSAbzSAqJIeGLLRUKshOmFY0CvKzp/yhQDT2TD5ijkPTWIFGat2kkJ999aDlShJr6O/OtyZVMmvEX944ADxjhCtLkHm1cJtfiISAeTi0hQmGXe6nb00+/OG15dp4pk/ejrKKRSiGu/rSdJJbxHpEbPRMld4JStACsCccQeogsA93WEGEMoHry6KPmxI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize procfs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/root.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7fbbe92bf73a..ca0e75081934 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -17,6 +17,7 @@
 #include <linux/bitops.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/mount.h>
 #include <linux/pid_namespace.h>
 #include <linux/fs_parser.h>
@@ -265,8 +266,6 @@ static int proc_fill_super(struct super_block *s, struct fs_context *fc)
 	if (ret)
 		return ret;
 
-	/* User space would break if executables or devices appear on proc */
-	s->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
 	s->s_flags |= SB_NODIRATIME | SB_NOSUID | SB_NOEXEC;
 	s->s_blocksize = 1024;
 	s->s_blocksize_bits = 10;
@@ -350,6 +349,7 @@ static int proc_init_fs_context(struct fs_context *fc)
 	put_user_ns(fc->user_ns);
 	fc->user_ns = get_user_ns(ctx->pid_ns->user_ns);
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &proc_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


