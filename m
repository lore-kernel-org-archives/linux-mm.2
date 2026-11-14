Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C38606D2BB
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GFHvRmPz
Received: by kanga.kvack.org (Postfix)
	id EE1596B05C8; Sat, 14 Nov 2026 08:07:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91476B05C9; Sat, 14 Nov 2026 08:07:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D80F96B05CA; Sat, 14 Nov 2026 08:07:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A29626B05C8
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:07:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1CAB9803DB
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:32 +0000 (UTC)
X-FDA: 85433751144.01.836ADBC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5DB77C000B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GFHvRmPz;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661650;
	b=Z9OW6i40fAqDhq3+i2+GHJ0s1dNcjYGHQNU/BnPNWFI9fUw36VmjMeiG2TWG7wOstVBry5
	bH8Ltnm0uVLPyXvgDnWPaGCe0dLhCdoy2I71RebcDKQU1d+MWCAjDPr69iLPX02ADJgDZ/
	F6dvWyaDGHB71ebU827DVsZqMA0EUG4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GFHvRmPz;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Ytkno3jTVi+FFRUdCUqmeMcgBru4oLAHALyh9TN4hQ=;
	b=7crKp4IeI+0T26pM+TsYjxUsWPZ7WiSJRaHkhu46gBaLOPYx9jgm9xud8jV+iIgg3zhzPk
	iiCJvbUfe/hF1qjdrfzcFM/8Or+OmJna6MT8Fqc8rdTexUEgbEv+0yc8ZB1g0NMs+ZMD4z
	2itU3tWyXs8JAeBNIhZqu4EGystXFJs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E81ED62747;
	Sat, 14 Nov 2026 13:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE82A1F000C5;
	Sat, 14 Nov 2026 13:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661649;
	bh=8Ytkno3jTVi+FFRUdCUqmeMcgBru4oLAHALyh9TN4hQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GFHvRmPzrl9JT/XnWgZ6mHZe9H02hsU97t3+ppYOuzxqJMSfmYjPWgdxAi/Wgu8V/
	 wrZy1vRHCZdd0bC3qI68hsdNcKgmQ3IfSWbtHayF9hWHqdbEWqPyzLLH8RbYsc2XCZ
	 dXSM6hWaopdLwe6Tk47JXm5nRSuNnbE8q0uiLEKYHIn3zKgz4gm0hCB1eldl8tNsaw
	 9r5Nn1nPEqIl+dH7clVv0JN4xn0WgIG2u28WaYeRfsivii2u6GrnUxXBTzpaIAi0hh
	 87j2TXLbcazLek+XXOfbey7w3PmofUiagXJteCYNZfZvoshvSXFM6Zg0UUYgny94Iv
	 NhCBc31tgKfxA==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:57 +0100
Subject: [PATCH RFC v2 16/42] configfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-16-98639a2286fb@kernel.org>
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
 Breno Leitao <leitao@debian.org>, Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1052; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Cs6hi+IJv6YL+cABcEV5PmkB4gvNrgirbEkbHavmri4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iKmo6zy18/cHrrR7f6484D3B9HbNopIHW//r8rL/b
 7n/ouvYt45SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJyIgzMsxe+XjzPdujcT/X
 dlcLtp6+NiOv++ZaxhfruqUl7wfkfepm+O/nmC3+VkJi2/4AH0tulRslnlL+mWJ/ffz2RXNuXWh
 +jh0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: qux5k6z13ofurbbytpsp34tstn9woccj
X-Rspamd-Queue-Id: 5DB77C000B
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794661650-533498
X-HE-Meta: U2FsdGVkX1+kuqtQc4grkxZkkEPVfXf4rhwmfbYrL1vr7t+2NjToYu1DMCJRvuKpAt0d6sjty/N3oq+7NokCQQ4Lw1tSP7a7rhu44GOsxLIZXmLso0lJN79LiJ5o2xpUhSKdiAecj+rmmURWP8KwWIqI8UveoZK3Kh3VFVLWOVcAk+q8lnaURFwKBk3hnlvXZmFiBBzdigSkZqDyJqwBIFYl0kftqxu5nU41gIUI+msdBsz+ACuqm+VVpn5ZQRAooZGsiD/Z5fnC1VNB07l5GMYnb6zZ7pKyOimqm2P21DWPiW+MKuQ2tHG6U2aYti9xfCeFb2Wlsn6BbNJBrHCuwFgynVT1E6hw2sYZhpIVj1qCz1O5k3Nu2hklgUKWwP7rX/CBTrRzJ99Wu6HTJcKOQauvKnHeEbswRNrQd7c9TQkElcYzOdgchTO8iWkB1SCpi/gHrUc4B3nss7G3ZZfa1SZ0HSZHq3k0FZvqU9aQEN1SlFWoe5+/xCzuCg86p/CDw1ZZAAms9EEivfH+LTj3hxjY//exG2nRgT269y5DMkJ7XgA1/cFE3APDvyKvoaqdtw18z1TBEHi+/7gNzxlFYsqbqi2s7iEasomrpFa8Z9CLZF1fExeqAAwo3jh+lsdczV9hcyXlh/zTQ7nPiei7MVMqPfPtRAdbDCJbABBfDXbCCRKrdx8lCPD0Aalrc32dWmSHqRk2bhxW+vveK1uKZlTb9bciw+yziXQmQGJG1kvv4GnL3vJ3FpqQgz7jbw23yrv/k7c9OnWt6h1BwGBDVDowRlSqYpjfa//UM8buHBs4cTIblrrZDcb4y7wSmlUi/eTDfbpUb1nVv4U38EWu7eNhZu/ZaShEGoKx55jFXpCje4KrFpeajxnVnnl64+ArzSfw/fDnwms6P2guGCYmut2tgJtwtlMkUA5EEBtIqIdmwlfa53UF5SoCojxSf16jGfIP06OSypLUVTE429X
 lC7pInUk
 ONsCNn/kY0tP5ICxk3SHn7PtVyhzY5bEtPBvy/Ue3XGtYCxifm2sVsME4nOuvRtLrZzE6pj7MMd57/+8j4K9fmHC61CZSmCrJYKoUzQGLomVuf7TQeXDQ6RyeFcoA6RkrsTlVVctG3EJYCIBPjco9BhwS3BxQIOCmvjOJCzwhlUN5LaSJuUHzRaWIju8eve2NojI+0BQBaC0k98dopfAG6xouKpmmhXLFisj4Rq345YzqZ6w1muv6KpiElV6A1MyIrDh94+r665NCr3rNoRhxSTEKVl9Og+jyQVvCUiifNZYKZrbPXlJbGHbf7GcBY/kRSYpqfQp7CA1BNfPc1h4lCXAxhDgegt5JHZBJy4L/BeGkKFRUTUWBGATQBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize configfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. configfs never holds executables or
device nodes.

Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/configfs/mount.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index d8cac1cbf3bd5..60ba24e7ae2b9 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -106,6 +107,7 @@ static const struct fs_context_operations configfs_context_ops = {
 
 static int configfs_init_fs_context(struct fs_context *fc)
 {
+	fc_init_pseudo(fc);
 	fc->ops = &configfs_context_ops;
 	return 0;
 }

-- 
2.53.0


