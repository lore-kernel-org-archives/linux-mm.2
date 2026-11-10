Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD07606A901
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hCKnpX2L
Received: by kanga.kvack.org (Postfix)
	id 1DD9F6B05CC; Tue, 10 Nov 2026 04:17:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AD416B05CD; Tue, 10 Nov 2026 04:17:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C396B05CE; Tue, 10 Nov 2026 04:17:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DAC736B05CC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:17:42 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E16C40176
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:42 +0000 (UTC)
X-FDA: 85418656764.30.D04B7EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B3DF5C0009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hCKnpX2L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h94mIi/imn4D3waXvt8ZAO8zbcvNeSGH9zaPuRN/zFo=;
	b=azMCgdwGpBA3zSo08cQFzefq6sqt85h1FsemUk2ZT9gYKH91JMfZLtLacIaFa6FEToILsJ
	JQiREpRS8FIL+3MN0bYolHeIWVfDWzk2lYS619EMyYiwtj9l17b9Xocz41wg5C5dz2EQ4w
	fuz40+9T5bogrKOK9REaPF+RCI9yJwI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hCKnpX2L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302260;
	b=2cxXt426m0ttzItVHiqGfbNXaq0x4Pj8Gl3ygc4CoZ0NikZkJgJrYe5fRSByrz2fXCm1Ik
	M3n/FjnO+lBnkKXOdK9Z29XtTlRXfGUBNgmUmcJvo28ztJxms8b657j+W3xzeemHngHM/3
	Wlx9xv9T7GZ3EqA+KnoNwtnvyih2EMU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 575206351D;
	Tue, 10 Nov 2026 09:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD6F1F0089F;
	Tue, 10 Nov 2026 09:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302260;
	bh=h94mIi/imn4D3waXvt8ZAO8zbcvNeSGH9zaPuRN/zFo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hCKnpX2LMq/yIBVu+3fedTSWRzmEiUKg05k70/cabSsZyN0V70DQNw0habLh5Rp3N
	 c956FUO8f5KMtGhmwZF6JaNrD5YNWgtZGhi2tRzcc2lZ8L4JIxwL79H0b3tBFB4IaO
	 XmqyiHmmqPdau5vX2eMWUrlPCMnRhkbqwrhqOEqbuhQuSJxQhgZLHlWLkOa387kF87
	 c2QE631FmWh521q0EDzd1BLKeXN0jM2x4hEbJfjU0RuxAt/DbvL2B4RJaNxjRNgwuN
	 sRHkcU5kSCaIM/R/aSWv3TJjb6hXOJ6l+gef1isFdWoX5RRm93+0TI6pGc9yKYqXGJ
	 EIZJjyG5YAQyg==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:31 +0100
Subject: [PATCH RFC 15/41] tracefs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-15-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1051; i=brauner@kernel.org;
 h=from:subject:message-id; bh=nNHku2orMRQhrPcnxhaESkf9+5yEVey8qH80JYuUurA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erD0RXLTJKNzrh5L9mkY/O9J+HRKY33C443/9A4Lr
 21xrLd+1VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjAR+R0M/72Fl4jGuvHt3/5x
 u7NfzPNpdcsMM67cPHfs9ommtv7O3i+MDBdi/75YKJwQsP/1zN8L3y7I88yZX64y724L9xZhYx+
 hQ6wA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B3DF5C0009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 9z3fwn1c8oou81sh51ck5n8chqexmkh3
X-HE-Tag: 1794302260-23950
X-HE-Meta: U2FsdGVkX18uZ/dr5ibT1EyWlqfPplCYHuoYzB6l7tnGJw52y4iZbcd4EDMdpFDBYzKfVenyBky8QrBpQ035sr3KIGdYHp0VD7ct1Uf1YGFAAGx/DCOgtfmodwIuDPZwGux9ODnzQ1xmkqF4OwVAwnqnRb815jwkoKt2Ib55L0nq+eG7AIg3oF29Fdh87xYFQm2Dez+HFLlwAJT377146EedRbc4ztIYwLjausVag/OOMyjfwX2T0Ml0ZGuDKcudvzPmIQ6Oaux3hFX+gsKduC/gPOgLW37BQBZ/98B9zKPo+Jndhn1MPUp/sAdyHYIzNlq2FJDIR88vUbBilTtrXAL0RN9AZpdUEvHWL/LkwWjAercbkB0XZTEGXcDPeIU8J7d7DLwON0xcBWrGi151Vlw1CjgwnhDMrm+w5NnVK+PchrpWBWE12LhcOE33kWRulelCkPIHxEjOA26RGaeAEDi4h/IGHelMxdlXaXnmEo9Nj+ckL5gVwn2EZqEWWQpFEXSsV2a6+TmwI12rA9FTgbuvaSE88q5xRTrKId6FPnZFm+qJIOAiJVVMuvmtmMu2XDUAv3RraWI2VFChQFjZ/4dUM7xvwxxA++ztI3UtnL6G2Rz2qtURpS0p9uTbja03+ZetNeS6CJFP1WulfNtXw3bHuIY+n/D6U0J1PlpqhvKDfL4cOEXT2+YJYxLWlhtYSipzcDuBiyyL/UabusyZkNzJ3lX8RsjLOSal0ggv0SScWxZZzImVsRy9gHCVijqh4AM8AEB5gcMgrtT3hnyVBOBn9sCikOtmAiLjg4qU5kVKaNHFR7fJiv8mRdKanmvQ/nZnuswwkpPy7dDolqHKkBavGPV+kpCVEJJjP2Dx9bitDV7LAfz2lQpnwkNt2kcxlr6cDZMtjE2IldFCyfTiNln32qL7DA7LF3ejnyG8MuBOQwUY0ngoSqQTpdSbZuCmeSHPUXlT5U/Wv9itiLp
 ptQ9dHjh
 LnvAhIm/HVAGQq6WYLCMa/1Tks1+BsLe1w7TBFzEn8o5/iPPaSRmcJLOI91JNV41m3eJlOiCC1BekD3FFtPftzB8KiOxLKEbxhAGChEGKL140n2ATaEiW3fhTj3X66Hk9y6JPtgSLYb4AVLrxQXsIbnrwLOIFnhoIt2A95lRkCxt/w9GaRg9vWtTIUyudkYcIWbfbGcY1AKnr/lqDMvY7I/AEksv1Ng9Vh8CsflKzEHL0hkqe413LXQ31yLcNtqtPDTPUjvojQSARI+NjkX4YUWj7NbGHd3aric0GOAPSa7WaXD00vam0VixfoLIy4iE/+QD9UQ/D+t2Sfts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize tracefs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. tracefs never holds executables or
device nodes.

SB_I_NOEXEC also refuses PROT_EXEC mappings. The only tracefs files
that can be mapped are the ring buffers and __rb_map_vma() refuses
VM_EXEC already.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/tracefs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 5020365ca704..e04febd868eb 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/kobject.h>
 #include <linux/namei.h>
@@ -510,6 +511,7 @@ static int tracefs_init_fs_context(struct fs_context *fc)
 	fsi->mode = TRACEFS_DEFAULT_MODE;
 
 	fc->s_fs_info = fsi;
+	fc_init_pseudo(fc);
 	fc->ops = &tracefs_context_ops;
 	return 0;
 }

-- 
2.53.0


