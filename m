Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA7860A2621
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N/ubtL31
Received: by kanga.kvack.org (Postfix)
	id E90866B05BB; Sat, 14 Nov 2026 08:06:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E199B6B05BC; Sat, 14 Nov 2026 08:06:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0A366B05BD; Sat, 14 Nov 2026 08:06:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE59E6B05BB
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:06:21 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45E43A03DA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:21 +0000 (UTC)
X-FDA: 85433748162.20.67336A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6F5B240003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N/ubtL31";
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NnRPpMKcN9yVfeXQRaQnGebNudMmHI+DUOfgXRvZF2k=;
	b=3BqcoE2mL6r/GEUqT8czUkcDcoZXoWojkJM2/b9wGh2Z53S0HIdolD2anZ81JKP908C+t1
	ryS4Do4Eggj8wcTlkYsQEMCh3D4htiHQtkME1Ir+Mh3Yjj8HRGSpQ/j3mquAIFfvoZpGRt
	GsgddgSwWOUCSgy1Evm7/gNXgAdlMrQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661579;
	b=Z87Vp2/+LNyxz9HwXeTYKr8qpoYFsafbXjdYFnrbDwZvdoD+vpYlnGu2w4/GEflHcMX1Yk
	5PFCCbAtA9GTbRrTDT9juoqObUimu82iKX4pICpyTRKnARtj8ZB2HPvjhAQ8Lql/TPtFLh
	qwu5IicrE7IMTV9os39Q5GL9VPcnWhA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N/ubtL31";
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B9CC14637D;
	Sat, 14 Nov 2026 13:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0B41F000C5;
	Sat, 14 Nov 2026 13:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661578;
	bh=NnRPpMKcN9yVfeXQRaQnGebNudMmHI+DUOfgXRvZF2k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=N/ubtL31jom4eCsfCr6WpwL+MzKUK+rWwpFr4vgqMUy06gbO86k3xFL/VlhTtjybt
	 o3d0PDdbLEy9jHXv7T5i3zo1EBRIqVAu/ZacRS1retYyYhxmkcSel3BM1zOn1JXfvT
	 j1dl7rLX/nE/c0hHw7WYlCxm5LtmKhEmBxCBiL0Rx0/pMBD9F5WQlfq+VoGsYrh6sB
	 EoBC//ArgbDcTnWusWXsxEQCVbMy6hCKCNl3yIXPnFUODMjEzsMezuDoTZo4Jytdw+
	 VM9ybNeR637U1rMcm9u8t7d6wvsPa1ke2eVusyEuf1MTwKev4R1WEMPGbBHytx3Eq8
	 fhAsIGxVLYMEg==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:47 +0100
Subject: [PATCH RFC v2 06/42] proc: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-6-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1408; i=brauner@kernel.org;
 h=from:subject:message-id; bh=wvImD7sMv1Zo1NPwHwuuoeuuUg5KPRN98RPqhNbSu40=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iMnpmesutyB8V/b0LVcfp532arap6m4r+hdd5Hsq7
 Xz78q6OjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlIsjMyvFL6nBbm+cmh7cNW
 o+/+y5gDpu7PW1vMKy676K58p8+pVwy/WQr/TZnocHWqxVPTHZNuH104SXi/kiln1+yjJ8vj0nb
 O4QUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: wcde8sbpsg4bhj37im93pkdosdc59m1z
X-Rspamd-Queue-Id: 6F5B240003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794661579-885863
X-HE-Meta: U2FsdGVkX1/p1BMRgB2+W6dtgvb8PDnKg4GqBBNGSTwmCHXma33tDWBK44ZAPZEfWKjR5XbuoW0MsOPfqe+9pD1e6iq7kHogsi6CZML5J0XToX64OgN9Qn01AVFtkf7Hlp7+b1Wsdxx2PjgOjsrRal1UDZtEF5yzLQj9UFkYfrW4HWWpadKoy3ai2EEkyIfF1sc7OvVNvuo5E2BpCqW/E/iiR1CofnbclZdaWx5QgYuxydabSxBRdqW1+41bBGAtsSTG73jJBtpiKrGfYDrP9J4OX6t/ZNSRE7VykN6rB6Eru5UNOkWZoYuRvvWr1lSuEhfkztgLu73afcXPOqLJkwH8nTuM/xToY8tc+aSpCM4yX7jkW5/x+98EWh6zViP56zK9zKJuz8bGCJHfOcOnrr1EWFZkBrIsqkvu4mIjzbPe2vxdPswKqOBmlHgPW2rpvQAFAovKd7s15pwCjkCkuK5+0fCJN9aNWEdFkpGOkSMR5cVymBzfSlwkCmlDWKskdiswtCc5iWazST+5GroNAcCUtAtTcq7XoCyNPu+YUZTHgEuSGRa/zXMiLoJjAPtOnvM6P9G/0neYcemb6lCsrhAR1RcvuB9pqOKIoRaaBHQsATjLH58+z/Eo9S/41bqd5aitPS82Z5gIVCZh+EOMHitFlTOchpHLVW2SCC0wPl1BIFr/OHfgMhbBVc3epQhT38oyQoQUj0cqpyKwEt7PlAhb2xaVoHqA7FX4h84LETFBBNpj8f27yB+xbi2/nKchi4BoZg201qInbIHpPrbyJQLBdXPrWD3m64Cbry5qPYSb1nl2aIt/Gc95lgqtOZO0fCO529aCvsaenP79zZx+S93dVsMwc32aFx5MgaDO10jhS15s0NcyUfiarrL5/LV5WpURdHxqxHbbW8u+gF2SZ2pStPd972OIRtu3/+z7Ji/f3FNoin59Vje7rRlZEhJUGk/+FVYta2trdN929uJ
 5p66nunz
 eARkUK8UAibefQ/3ISWiOLEXJkx0q1l5B+IvfWHYoOgDoQBcHWBIbzwPLkmWO6q4FBh9YXlcn6qjbDAO5yi11iha/v10RifKfOUR7QlqXrsBicTheXlUvigbTx7EdaQCmL3P02i7DXHQL7ySrQU0KJqlGYQ/NTgv7GtzaJI5KE4kHTrkdrWrkjk3/1m7ykAJXQi14V3rbv96lP7YpXsO0StRvHN9NwNoqW8M4YJEUrqh653wSdxdhKlOJWH9+qCx+BSpVv89QTanP7t29pF/cmQ6uNPx8+rHTfvumyWvIDBPTmmykODt2cEdHQROpVsNRYFapxTjtFi0dwIwO/s+picNQBIDqieANlGpB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize procfs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/root.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7fbbe92bf73a7..ca0e75081934f 100644
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


