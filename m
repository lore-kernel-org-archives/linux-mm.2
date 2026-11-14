Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49E4606E0C1
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ahGg+gbK
Received: by kanga.kvack.org (Postfix)
	id F0A956B05E9; Sat, 14 Nov 2026 08:09:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE2436B05EA; Sat, 14 Nov 2026 08:09:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD4E76B05EB; Sat, 14 Nov 2026 08:09:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD43B6B05E9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:09:24 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50BA51603CA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:09:24 +0000 (UTC)
X-FDA: 85433755848.10.B09A1A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 91F7AC000A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:09:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ahGg+gbK;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661762;
	b=J/CZ4Jyq2l7NcGdpY81SDhZ1TxPdbihVLJDjE6Bqvk6sek1jE2pW0wbmEQ30SmEkB9HM0Z
	EFGw5Vr8FbFTYV9XswQ4Ao81r6pz93U7ILprrveqlPjmd/C8eBVXNVBYemmAdLF+re+XkD
	E5d1RMIblL7OKVBkucBLlf2gGJtpym4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ahGg+gbK;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdlKWawwdwZpGTfkQNHBk5b32jOSAzRsLtI4xTW1vDQ=;
	b=EUuVMftS/h24VLN2kcE5egD8HO9BH26ReIENWDYoUg/xMMPf55WQutKE/x6IJWeHrzFQkM
	zeJDtl18zk0MvbHsWkIkP70MdOUsnw3dP8nlVGFT4huYITd125XvuRaWof9G8lvKM3CokW
	uzPDw3fsvfmTl4cbEiO6Bn65pZNZV+Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D370B406B8;
	Sat, 14 Nov 2026 13:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEE61F000C7;
	Sat, 14 Nov 2026 13:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661761;
	bh=OdlKWawwdwZpGTfkQNHBk5b32jOSAzRsLtI4xTW1vDQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ahGg+gbKJXxbgqkOcSvuZjZ7iPlwqVzDb7EoxKqbMYLfnwG2b1ybTE6823Yt3K+6g
	 6pxGQrYoIqiTMRS2KhVum/gBvAKYjwtRqLYJCBO/9ug+3ibc96rUKSQG8oL+uPM/Cp
	 otj/ItmyYhEy+iuvYfxXHkC9TxP25a1aDbikvQC0LaWKFqqkHfvi1rF3sXkQx5MRrH
	 gup6EgTCHwl6mcX33AkMw33YPKcSKfn9nILfmzWaqX+7hRwWvA8CVF1JFBWIvMizqB
	 9iaDWPBWP9dpOG/jN3GKX5YzZjKL84UtGahKm/OO3Hrc5uHtCRmGPTFTPgEI2L+fkM
	 4xc2owYmq/A9A==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:13 +0100
Subject: [PATCH RFC v2 32/42] usb: gadget: gadgetfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-32-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=982; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YWRf7GOro6drmYRPuYvYnNI62ZxquNzo3CA3o8p8z3k=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iOkuXt19v9szNHxy/sSShDNHi+s1AhW1jvfPOLx+v
 43t+vdHOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZi95Dhn+K7b5fV2hevnL5D
 2vJ8vvv+x1/kZkmvkvsmunJ/0t+X6ZmMDDeNr0oHP1bwdTnx7e2hwBWKTidX/diQpKYmvejZFYN
 lK7gB
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 1gi4qsp4z6u6myxf6dsjfadjyzi3irgz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91F7AC000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794661762-200391
X-HE-Meta: U2FsdGVkX18+xcuepXWXb96EPm6QwW9ZdSqbw4rektakFVKxMd/FZK2tVAR0z8WmxvASBa1eSai3Rhfd6aKvNrnpYhsI1QaTT5MmAH8D/v1htq+esS4IzpzkS6Wf4zuekpBmB/w5m+yUNk3k9RgoFWypi/igniYy0uKeay286i1MdgH7xLAp2NpADfd13OhcvKK7+M5IAiDv5NXgzuKkB5xT5whAvZQBd7C6/epiGY46P5g57G+36WCmfRr/EyJfNQZR69/k4o/aBdwFNnBqaYKrJcDROCGe5siEgTxOT67KoJs0f70oGF7V6hbBuSmjCa5ADPTdGjx/g7Ac52H0aFgkVTZ+U96EMmKa6OUHPbRZ8rHr8q5Jy4p9UR8Qwn1R17LFPeDcyqcPjkquro4SvZKbX6CWSHwp2G+dM3/Yk9Mx9djXHgxBvzV+w6umthSc6FPzdBHs346fHhdW1ZKQzYNlZl+LSzbralWbZpGhIjD2c4tkPd3+6wAMNcoCwTxN0HphkseTDXIDqfLzCgyNXG+b3MUh7X85B5TRNSVYZtseA+CPJtAE3ExLdVlGHhN+uUoiOMXCNv6DJdLcsWyuMhW9CwoZLwpCmvlD3QKGtO0iqE/iEGEDOzzrwVyeQdRtWnbOLCoYPOiJUrPEJeOIYM87BXxfcqh/QGREMzxOSvdLHrLyUVTMmBFl5+xM6LqGKVKOzVEHTjLPQHRpemME/5KrG9Lp6Qm+P5EQlM/Noh8ER5rbykyPnnoLj8oDhzjMq17mfVbvvW7I+CPwFTsm8GBPCCpzw2e/qqlFV2Aa/vGjMt2XI9089QSZ5I3Rfit4enAeUup+aW1t4UZSnm80H3UFGt2KXMK5b1A62vgWvBnZ2pg9OXgtIPNEYrTiNMponfzrOlzqWmeneS+6ouA4ndFSb6ZtZgi520bCUDkhmL3QdP4fhDBEb5y0nblkbEkfJ0nBq6YN9m2dildqcVs
 /IgjaUoS
 EjTd7GRyyhwGYqG9HD+rKIDZaR2WJVwms7lnAk5PPt91hnw0SE894VKcxXEKM+VnGowW1BRQwzouylNYhxCFvXU08UensstUtdEmr7uIz0bMebz7cuu05AVLNvHUD7jjLD7St3iutr5m84lJTfja4fyl532+HmQlEWnrEOYHX8EcDGvAFZ0jBRPGELw1WiWV13kPz9Rk8UFirtu6dZwB1RJggPW5F/En77+hwKw7LsRSPYXf1EPqNlbhYEZn3tx6as2q2B/iw5+Cz0KFhvXLNXP+sAZuWJpz2YA6t0P/QxjgTdlxRiXBD1dnXhhwlUK7ylySl0VfrXHWmBAZmz78nI9VkYwsaupydcIoiEvJGHLf+doVsB9cxkEa0nVAE+Q3NjYFCz71sRnFTJcdxDGV7bK9OJPiqATZdWJ4dExMrn7rEs/BKtUmCMOLGpmE0ZeHjsuzJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize gadgetfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. gadgetfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/usb/gadget/legacy/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 7f6d8460152f9..8490e5d0351e1 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 #include <linux/uts.h>
 #include <linux/wait.h>
@@ -2223,6 +2224,7 @@ static const struct fs_context_operations gadgetfs_context_ops = {
 
 static int gadgetfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &gadgetfs_context_ops;
 	return 0;
 }

-- 
2.53.0


