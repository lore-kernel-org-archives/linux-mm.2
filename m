Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712FA606B1A4
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SYR9TaGr
Received: by kanga.kvack.org (Postfix)
	id 991F06B05EA; Mon, 16 Nov 2026 06:07:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942FA6B05EB; Mon, 16 Nov 2026 06:07:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831546B05EC; Mon, 16 Nov 2026 06:07:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60FA46B05EA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:07:45 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECC511608CA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:44 +0000 (UTC)
X-FDA: 85440706848.13.296FD70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 40F3840009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SYR9TaGr;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRo8rafT0SI0ZYIjwSP5s8nuDkHhspwSH2/U5D4Vwdo=;
	b=FWkBQcYzjFeJKi4x3UcTl+2zMcsLPacX9q8rzOnUgyaKnYwr7Hzws/qtBkaiOY6cXgGsqZ
	cUO1rSIOfhGAmtplNm88mxWr+B2f1U9Tg5Ycwb8SSjYjEFUjQl7EpAW4WOmwp5TrnJCTer
	7e1jSsydUiVmFlxmoov3HoWJ0oi8gVI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SYR9TaGr;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827263;
	b=TkVB5vs/i2jDtwyT9vK4Cp37dutYCIz8w844+PLnT/nNaKR2yazriCsaau4Xz8xiTQHMa1
	Fk/LjvgcdSw2roPrGtr7Cv30nzsHxHo637/RCky5BHyMTry7JXXgi+X9hqrx6GSr5eJRo3
	5L66nFZaDctjjC86WycdJVp5T20VkBg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E70F41B40;
	Mon, 16 Nov 2026 11:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E231F000C8;
	Mon, 16 Nov 2026 11:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827262;
	bh=bRo8rafT0SI0ZYIjwSP5s8nuDkHhspwSH2/U5D4Vwdo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SYR9TaGrdGbZIarQmb7FZiAh3aYqeET1aKxpQildzBF54+XkCs3w2hwe012i9YDNn
	 KwplWWfrUqSG6YeiB4M+R0HFxuvky3aQ6H/xSTFl3YsGJUXt6YKVqEho4Ze+G1tUXj
	 1LBnFF1Tjb5B8Wq8WvTQUAgcpvPTABUb9ZbFJurPQxuPY16ScwtILZqX1vzDRAK0zF
	 WYGfVFRgoNgVMFqCXJGrivTUJE7Uqv9I3Kjf3hFqKNQ0l1/yg7xjQvZGT4y6D6g3Hu
	 GlJP4jytTeb5jsL1OPfVY2sB4N+I4DKQZdsAQ/ckyHlMUVC8NaHv6jRpgn76WWmzBp
	 MIF24A6RZBJQg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:46 +0100
Subject: [PATCH RFC v3 13/44] devpts: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-13-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1022; i=brauner@kernel.org;
 h=from:subject:message-id; bh=bmgpF+T0PjaM4BszluBOeRyncWOMZk/p8QFUkfXrwyU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epwbMLfmqPHCfTn5hRfrWbZIf8s8rLk06bC0camwg
 mzGq1XBHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOpFWRkOPz/xJLoOzVBuYb7
 +QSlfCOaZ5lzMH+rzjNdtcfly5aJtxj+552pNBCM1J7apuA9/7a7a/D7lgk6wf0+3lyc19/OLmz
 iAAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: z4tjz4kz3kwis543g7wy1mhkg3nojoz7
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 40F3840009
X-HE-Tag: 1794827263-759844
X-HE-Meta: U2FsdGVkX1+7/TorB/Scef2zgJU7rx5kl+5ZBvS+TiAKTIPwPeNqHFV8K+eac7ffDKnepfzKe1kHuvrCsHbiLVHEgKwcukniZrQFddF8y/5WYfPgbUL0rT+JeQ4eiNPO5rW7TcVGjI/avG16EKlSjqF6IMU7yoE6bsMGfdDD9nCq5mGQNx/zPwcgfKpQwJo2W3H4MsmbIFj+6yJHNDTsLDcN1RGiFTdg3FpnJZ/8Rdb02UnmBIgpbx6KieaCla05Lk7OCSMN4tiCis7i756TL9hrkrLXYTqZjaqHCV4NJpBAn8leP/dItpW8i5HAVQmJpfrSEf1ArdfmUGgFK7KXyFTtBuGVTIcNd1N4fVNZtmxjwVqu4vyGbB4m4E1knbUgAvTl5LIJz/wP6U7//VPIs7IcQf/eGzz0DNgv+PpU6Jwx89AiGp3qw8Gb0hsVLm9ETGcknimeoN8u9SIbuSWbc0nkcqe8Qz3aBAmtCwQSYS0NeIZSzgnTyTLCFgHy6OohXdEHhjsD80KqZS2S0HYEYlv/2PrUGrKVf7VN4vQ/HNMq1T3NhsnIOBgNnnJIw+Vm3izVSYCBpzMPJmOVUqRp26oQ26Bt2QyzUU1snx/7ZmmwLJDhNtsaM3rOk+ryGKzRulhbGhzg+g4aabO7J1upQByXWKWzNfgdYa1i53pMmXHNX3RBYdVkC4ni2WnYok4uT0xXOPoHBO1a+UyQ76iUSAt6v1NkI2RY4zfMaKpe6r0XqKAaauORUS/LvSidSuMuNz6c8Y544eQZjiW6cyohsTCHY2CqvBHUYCnDHIBcDerLeZifH5GPijduRgWQE198X1aUh1mmGoopHWvT7H4YJGXRB1AzNWeblWk3nKsF1a+yPg2pMEst4w6N2vdv876wgydxWJjsnw7IU2jfDGKAtYdF+65GC2lCTJpHWc1HGRdfiyX3MgChQdSRuWPIMnOkQmq/CzRwSy1ePzM7YhD
 /rKProrC
 8g703Thu8E4QdAjAzDQhtlYffPMnz9Vm2W8rI/3yxm3PNxGKitGWnwR8t5a6DhpTCeQbmXoDL1MvoYCA0P9QsPk2X9YU7GpnPfneAfyh/BcwsDBdTWSfP4VpCL2PZQHQviR8b5qlj0zcoPsFhe7N4yDcehfkDUSi2suFY+IYs6RM1adWg8J5Uiq3E8qj+XEygiLScQZflnVsvUIhmZHum3HbHxaeyEsC0v9YB3cQLRGfcxqS4ZZnNeTgXWaIPO+Ba+jdkttmww+ULZeBo1rmAKX382UiW1gIye2kgkTQROy8XUdlDjoZZrVll+Mlz6da8BGYVD9yOHPA03OuZ6CrLr7bfZY5IzTh0Q4Ar
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize devpts as a pseudo filesystem. This raises SB_I_PSEUDO and
SB_I_NOEXEC. devpts never holds executables. devpts_fill_super() keeps
clearing SB_I_NODEV for the pty device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/devpts/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index bd1e8eb26edb7..47ef12241d92d 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/sched.h>
 #include <linux/namei.h>
@@ -438,6 +439,7 @@ static int devpts_init_fs_context(struct fs_context *fc)
 		fsi->mount_opts.reserve = true;
 
 	fc->s_fs_info = fsi;
+	fc_init_pseudo(fc);
 	fc->ops = &devpts_context_ops;
 	return 0;
 }

-- 
2.53.0


