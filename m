Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0B97606EEF5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VFBfo7hd
Received: by kanga.kvack.org (Postfix)
	id E58E56B05C9; Tue, 10 Nov 2026 04:17:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11326B05CA; Tue, 10 Nov 2026 04:17:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0586B05CB; Tue, 10 Nov 2026 04:17:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DA646B05C9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:17:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3787B140129
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:29 +0000 (UTC)
X-FDA: 85418656218.09.8E88DEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7E654140007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:17:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VFBfo7hd;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nwdvLDg6bh1u0DzBGVwm7FjMDeBdtqjQseAh0xTl99I=;
	b=bmiQtfJrdqmTKsS9UTmh/esKvkE4Ncw2UJcvdQ0bc0cuv+DTYbEg+ByV1CJjPAfw6q9Ree
	b6//6G1zjgMD/fIa8v5tkomWfgOSRq/GOQCXNNNLeVGFT/HerkLoleqDCXnttpHGqIGEoL
	3VR3wH88RWIYTekopba51lJC82Yjrik=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302247;
	b=wjfnNP6RbbbQzIJ9q8ZDOWEgdTqhBTiTRPpim6NeKvhpfjXHznPi1uzwU6k5TTypFmId92
	jt7PEpu1zrCXI4kvHW8xrFVJV9VFvdBL2WAJn/0OovPGwkyvjgfU0H3qknOGglv+PW8sOU
	xSv1VfZouBaSelHnb7WRtFnDToTxtlE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VFBfo7hd;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7682455FD;
	Tue, 10 Nov 2026 09:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458491F0089F;
	Tue, 10 Nov 2026 09:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302246;
	bh=nwdvLDg6bh1u0DzBGVwm7FjMDeBdtqjQseAh0xTl99I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VFBfo7hdp6CeqpCV/lTJ2YVYrsN+l15aUN/nPrx8Rg7U/JoKUXLTS/O+qt5CD668b
	 Tvg82H2hCyRZdK0y09cJVY58Rhl/zTfH024a37WXVgI61JHTo+hhQ4sAK9pYHF9Jyc
	 DzcnFl9SoR42roIHoSyhOt3f1yUXXQ9XEu4wnL6doNmOxGOTC2UxCXLYIJjUWc61Yf
	 k2GkpKuijQrA44JhQn1HQ4PgE/MbIqiot91NvXxjd/Re5Y7uEX3vLft3JgMtpiT0CH
	 /c90C0EJy51OUlGahyRcvr5j+wOW65ab+AmNA2qoyUDajcckrSrMy8qdO+IXNuXqIq
	 YuNNlKf10iZug==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:29 +0100
Subject: [PATCH RFC 13/41] devpts: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-13-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=916; i=brauner@kernel.org;
 h=from:subject:message-id; bh=NbjUJKnUFt4/WnttO8t6CLNMaU7LsVpFd2X5tAMzhrk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erD4sV7JnhvtkV5xL4MZSyqkM9c3WZr+jvrmFegxf
 8Ze75f/OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYyLZeR4ZqalqDRG+1nqwtL
 9i369KNsxlvXLdmFi/l7l0SdtWZQ8GL4X312nsC5iU3+AX+yRU57OepI7oo7eS8qNuHM0k+v58a
 n8QMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: xgnmxnkg4skpwf4589h8mtjo18afwok8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7E654140007
X-Rspam-User: 
X-HE-Tag: 1794302247-774293
X-HE-Meta: U2FsdGVkX18zFh5idMs4QloJGhuBugUsDG66VzU38Cqi8qiy9NxRUnaVTt8OsC1freSLl0+xgDO90bnE62uDw3SMKLr/U/a5sETYjTm7lwrtCGP13jh1FPWVqJhjKPXk+ijKoWOcN3ea0zwxOZZk8RDzWoo+1ZmwxDoRCTuixOdjA9X3uX6nmRO9RFxTvURNzqKZ7O/WbSUO5ydyQ9IepijF3wJsSujDffUeUx57NPcBngHBiq6Rem1qwCl8joc8d+wHaCs4vYNWQxL4OLM47KdH2w/BIcuog/ogiaCQs8jGwE49TRry0P7auqZO+A7xejcKskpaFq0hVGGWvNgxChY5T6MFnQ4Xzbbw+w5PymiwmR1T0h0idd9r31716pDoo5mEJuwbLQu/947lcAJDPF/ERpZGbY6gCPJlNvGCMSVo2iF36B/BqHVTN9LpsoLR/6748QxE4dJshJYPyLP+xXnZ0+5/6w5HbU+yP+W907pKYnpchUgNZTypVUfJIy4gRyjyWorR5g+DAkpU2Wa5TNTqK3B3Qmk4oJk8X75cjpno6UEJVnybAY9k6leDULs9sSTwK/Z6Zu8aMgvztb/3QhKzbBNKhF6uJ9an2seiwy1E0Q9hS1wQ4PaEFNn9eMocVmpisqLi4oiHZshVqDCl9h8anC9idulO7gnP73DjGjV1+Q3/6YjyaHZS4n/4aGRFOBvCPY7u8XQ4MKvCTzM8aOZL6eKoX7ltL4xA92TuZZR7rwxoWc4BXwBqixw+NbU3u5iGOp3WlP5QkPwzczfCRphxdqwQ1SbiBJbFeyTkJkDqaneFZ3ehe6og5ziC8CHGuAEbhCntQaOZBQxA+8xTkQ75pkr9NnfYggUydrtwHoPA5Vq8DgFM1YTuMjifncCoFLkRGwxchw4yXf/MG0w+MbCu6YzqoRdu4lM6uzEfKQB5zxFR6EFIJs6d9v4FzyFQxha3AWMgMJhOknzwGDu
 OCjxONK7
 v+45ZNzq4/sI3QOWX+2lH/jLUVGoZXpvDgWBGutGaXfPpCp6ksgCFZr6LK8EPfvnCKgF8Sf2tGQTscnWoykf+99thPqwtLvtDmopq4QbHxWLdvAe8lJWcYDXnwHY+ANZQRlDwwvRksXbP6GlGckQ9MTYXSHfGVgPf6gTfpezv28NFfV4/Yrej1CfXFMf0pb2W6oK9yUZxvqHErpporY3Zbr4Gop/ZRP4aRo2ykRkzP6yQCUkkNA8Q1qFDccEdvhi3BvkSIYoWkTTov+BJrKsKrmlJaRJHSXqLuJfkmTeRwuGRbpgFhRIBWibN9C0DGD4gNhiSBoBrcLfECDI=
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/devpts/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index bd1e8eb26edb..47ef12241d92 100644
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


