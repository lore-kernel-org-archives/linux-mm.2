Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F3E606A331
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KyNtY6FC
Received: by kanga.kvack.org (Postfix)
	id 171F66B05BE; Sat, 14 Nov 2026 08:06:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FBF96B05BF; Sat, 14 Nov 2026 08:06:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2C456B05C0; Sat, 14 Nov 2026 08:06:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D56DA6B05BE
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:06:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C647403F5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:42 +0000 (UTC)
X-FDA: 85433749044.06.DF1257D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9228120003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KyNtY6FC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Acb/Xrf5UEvLQ3qZblXZEvLF8dI3PWAoA3H4K2Drtr8=;
	b=tZaX6dV1A0LXojQcaPw94hpI2RPHFYFKx0YuDy/U0Il5yS//wUmp2jzt01gJOZ7rVhBcb6
	JhWsKVcc6Q7mNU/CeDy8iyXGT/EDqbrJE+17IfYC8QyIObh8ptV7ZZSyaBSOSCrPhvkEw0
	Vpl/IthYplQzjPavUYUSk34qQHHCxNs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KyNtY6FC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661600;
	b=yEwI2SSX0RB1S8MYdaKV43YcxmTnhrBOT5bVctLP4iSUVy/0BTqH4EdLc8yKs2WQ6LoJbG
	VsTsGmft+ibwoKmwdoUaBX2w3MlY/+mGO6fZVzSzmBEHaVAtTIs+0YLDnzHysRz8ZiQ9S/
	Bqpg5g2X+EWCkxwtohLoI2j0t1xIfMg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E5845464B4;
	Sat, 14 Nov 2026 13:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646751F000C5;
	Sat, 14 Nov 2026 13:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661599;
	bh=Acb/Xrf5UEvLQ3qZblXZEvLF8dI3PWAoA3H4K2Drtr8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KyNtY6FCF87BGL6Kw/0+nFiSNhII6bCQoi1XcgNkkdx5QnSLvOmFeUx+1Gzw6qx6W
	 8qfU1kxc4TxMYaN7FiDkUr2M3uz6BLbF+u3v/FDkuwPjs/jbG+c9zGvRkTjFJmEjiL
	 8JS1ZHT8JFf+5Nw1nJtiYKkLg72hoVlMsqVfMy3CtWoGP4sQd8ckfZhFir2N8shzIj
	 rbapZY7d9iip7viefelICnAUIpwFJjRrBSAisiXulqRLGKF7pcgO96Dpzy48VQDU+9
	 fXRynAzshbd784aJhyQ+BI+MHkoqrwcw09i4frlx5HrLz+z7BB29FpUtgvajAYU8kx
	 5ZLHrcpkiH2sQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:50 +0100
Subject: [PATCH RFC v2 09/42] bpf: use fc_init_pseudo() for bpffs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-9-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1306; i=brauner@kernel.org;
 h=from:subject:message-id; bh=RMw1xl23FNzYnwkWPo3aqKCop8QxJMPcn/mgOSyUY0w=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iMnP/Sqt8ZKlWW/DquWr7Q+27feurNp59XxZz58a9
 18b4yU7OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZyeTYjw/USkxUJXYnv5D+F
 7fy6Msz9i+c5yYvtTRpVx5rmBdWU3mP4n7mJ5axYzdeTT2Z2JT67oLhnXfTECV2TncN/ctca7o3
 3YAQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9228120003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bdfaj38j1o87ao9f591aupbkbeic3wfk
X-HE-Tag: 1794661600-388993
X-HE-Meta: U2FsdGVkX1+UNc+w0aySPXUmBNC+yZbn27GnPrseFqmVrLjg1LBO/htBlilWIjEzm8ZBmJQQetkOJn3pofTAspGME8FmCrA3eu+0Mc2bYiQJgbkBkgdg3JDqhINzTjRDV0IEK2VDUEYhSnSH9I8N2xfNiuZPIJLvEfm9qMjXFZ9TZ6lmhmNg+1meSQf5tfX6ADR56kqvNQorW5b+MXWqOW/E4TlNSad6BwoIxim0O6Fuqq5PJ/0zARgWC/CajGIYh3hc+cRTDqdWwVhRE+wok6QUARIJgCrq6HotY9J3rpXRqjF0dMnjj/rpYPly4EzC6LFO2Sc1l/hCAdU3D7vHtw/DqjJfqttE3CKKTKZOnfug7DSiZvbsJYsmRSTk6LYA1GpCygYye1lPyoJhnlPzDCopaosBAUPS9aCAdwW4A9xaFYauH3Sx27GiAg+mye4glmsMSSi/LvDhPtWNDxweFLrItmVAkn6bEh4SYuNlbfeEOJgM+rWvIlom6gltaerlF9hAfgmOqvc1ushz7/yFPL3zL5BpgTjE7fvY37whmmRjZunyXOBhj6up8aTwnZHi93ABXZma5JQK5GaQSu2OD39iW9JMUyjnEmXBYZUeGYQS0mIa7OzGTEEp5JlsZByHL4PGmtFu8fcFs89Y1B8vjM5ACVxds077klgef2hCdMQ4XUmjLrPz6CIEILZYbXahYNZhCsnG3YgAlZSqygN6EcVQUh9hgetrnYycxg6z0SNY//r2ezr59okJhFWHPMA7WuvZoJEQPfe13qur9NOCRv2y2Wx8GIjKZktgV623ZOSDm6Szn80bdx/4PixE4jlmVREcges/W+IazTbGY42GVEosYWIioHQVack8DHd1x6WevcS5ka20qG5Yi3n52zrgek8YoaZp/bScHHtIGVralLOn8QKB0VEC35nX0thBDq9P+33f+X+/hOBLJBuoFirqpUNB8qrMRz0+DEIzWvR
 IzHjeA+Z
 QMdH3dsz6ukEesD+uXRh/rR1yhAIOeyXq531A8+fJDf745vyCG0e/p5OsWKhhrERQm7ZGZzrMNcb59oTrKwV64HJ5mCslh13+eJuOvWAXE5psjRvLXcCcgex8elSTt0JURN11IGKG/++/Ts/79dNM+ru6TTU4IrTUo7hwIHlCJcMNjeLwk0PkiaxZHXM4z7mSKTbzYVwE0tzJsoYWgaYgxtO4m8sAyKyAENZgzAz7J17XbUok3do6Y3MYJdB2pYmpFPici6bqty02I+0sqxgr7hl7Iqoskq4s9E0cHH0/9XJsy9W1b5UQQCNtqo9+1fUtLaNxnd2SS5OX1lMoBbT3ugibjciwrSy7r23f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize bpffs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/bpf/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index c6f328e4752e1..57cf3775c0766 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -15,6 +15,7 @@
 #include <linux/namei.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/kdev_t.h>
 #include <linux/filter.h>
@@ -1197,8 +1198,6 @@ static int bpf_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_magic = BPF_FS_MAGIC;
 	sb->s_op = &bpf_super_ops;
 	sb->s_xattr = bpf_fs_xattr_handlers;
-	sb->s_iflags |= SB_I_NOEXEC;
-	sb->s_iflags |= SB_I_NODEV;
 	sb->s_time_gran = 1;
 
 	inode = bpf_get_inode(sb, NULL, S_IFDIR | 0777);
@@ -1261,6 +1260,7 @@ static int bpf_init_fs_context(struct fs_context *fc)
 	opts->delegate_attachs = 0;
 
 	fc->s_fs_info = opts;
+	fc_init_pseudo(fc);
 	fc->ops = &bpf_context_ops;
 	return 0;
 }

-- 
2.53.0


