Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 922A4606C66C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nXwsv5rT
Received: by kanga.kvack.org (Postfix)
	id 6DCF76B05C1; Tue, 10 Nov 2026 04:16:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68EF36B05C2; Tue, 10 Nov 2026 04:16:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E8E6B05C3; Tue, 10 Nov 2026 04:16:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2374F6B05C1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:16:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A262F4014D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:54 +0000 (UTC)
X-FDA: 85418654748.23.B3EDD5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id E41301C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nXwsv5rT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rTt9ZODnqMGXt2QPWO0j4LWRDHe8dvGNICyHTYt985E=;
	b=KziduDtphqwqa2DDrC5X7fiKmilAbbjgR+fdpA1mPO7ugeVm8ac1nOPoHIMajIrEloEWPc
	pEOguo99kkxQHppkdOQEY5vY12meNMp2Y8mN20Alq462rmX6RzG6XJaZhb+CTn30JFO6FH
	fI4SfINZpbH1vKBQ3EeH7aZPd7cKyJs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nXwsv5rT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302213;
	b=yapVVEqnsxigf5XyJ7SJPwHZUbByMn8NNX9vc4yT/LwH0FyJ7IvMi6r9SQEaGPA6RPhec0
	ExaK1msYIeKAtA+BYY8yybggrKMFdfsdZzPQ0vCIkvaXBbCHNeey5fPvlsTLHNGZBSHSNG
	2kFDjh8c22hKqyrnU8Q7gzdEaryeDPk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78A176021E;
	Tue, 10 Nov 2026 09:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49B51F0089F;
	Tue, 10 Nov 2026 09:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302212;
	bh=rTt9ZODnqMGXt2QPWO0j4LWRDHe8dvGNICyHTYt985E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nXwsv5rTzvrG122CXPiddOJ0ugXqcsoi/AaGfNNbu7zvGK8mvUz48SAGlBU/zLVkz
	 LooUWqRoN/4S8I3xcJYcAEFNAJv7CmbUQiM+ChF5ZHpfxf63bNo7Z0QdCAiOO59dr1
	 8fhU2KVqLBCjOH3X9bxaSSk/C75cMEo2HD2kESGJ6Y10yT4ZTrwrUuApzZmSmAZkyq
	 7KypYuKqM5Pjoxx7X2T/0YDQPSzhDhTa8yf55w0TWoYWrEVFZ6el7TpOiZWeC8kVq8
	 oCDfcYgrQZNoq58895X8dxus9Cy79YWYO/viOCOJpKnTNCeln3Zt2fAQjdrWaXV2Jd
	 BAdVF5Rtw3JRQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:24 +0100
Subject: [PATCH RFC 08/41] mqueue: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-8-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1198; i=brauner@kernel.org;
 h=from:subject:message-id; bh=McdhKaZYT4i07Xats25HT8jpBIeYReCKfIiqQkLDh7c=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejDXp05OOqNfiGfutU+mD244ZPwWu6w2Ner6mY67a
 1N9rz580VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRz8EM/8zfXf24LmZt6Maf
 748F7bqwrvMdv95q947nnlLsuYdn/j3N8JvF0yvka11ts23/pvzN+To/re7tc+Vlrptwd4bj6ob
 /3vwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E41301C0006
X-Stat-Signature: rcmu7mmnts85cxyyoh5m1owidtn3ke5r
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302212-677000
X-HE-Meta: U2FsdGVkX1/maotNDbRM2s++sJNK4qWQ1e5/2rJ+Tn4FgaxWPoYKQ4ke+ZxGXp5V9Fo3dnMm1kEkWxK34xXLrl0me4pPZPt1h4x2LMypV97VltYlbq4LRU5Tz7mu8uAVkdNe+wFtY5okpbzMivmtUs4nS7tsl7FOVaJ7V37aZGGRzMU7/cplbW8kb7qTpOovrAlTQOPnYb2GGzaNuR/XE3VlVQjJYpPT088nkBX4NeZEx5kaVg1IEISZzDphmWDpH6Z8hWE8/A3GjUqmo7bpsfLTrnHXUt1cpuwl2qRmw1r5XZP7/ybFHL2Ult4hBg64jf/Aw2Xtbdnw0inG0edzZU7bMys5mbIOkJ/i6qTrm6ujO8HPw2OY3uSI6d4cK1YG+JGquUFkleRtcKO2ufqlxCcPhx2/sOBgMadWHuKf3atc5z2Yvw0IzJFGKXhSSqGkLsCUJDGf6BexfUMYnIGs547U06dxf2LvcuqpH7zd+WUSlxu2HgvCIizVi1eustV/3MxdWmFkYlixhlVY6mWoXpX474zxM0hvnlDRNXf7nMY7L+f/fWq/vL6VYRbCydZP2oq+1IAPBdc23B/oEk3VCzyq1+oe4b2wzTj/Gp4i/wYgT2FV5TrH3ZKB9D7YdPM87ohgISj8j2baj0fEk6xUbO5iAjHYqB5Xb+6oBKKApffDa1y8VJJDasj+77629nUC9oW94Dv5taP89FJiwKDTZLOScfXYRs8KD5cRJ6wwjVK8nTzDkNZ7SIeBtztz1GxETJs8slER94zwY2ejvbgIFLHvaggYN6I24u1QdggCYSWTtM4+5BvhcKGw0sPU3GdhrqqmNXe/L5tjhS/N87VH/O+A1YssmOSQGvX4y+pKrx20QjM0LH51MjDUfIU7z0ykNnwIyQddm5Xt0RLEV+98mbbxt1TWZDpZVfaTl5naT83Nys56uBfEeu4E1/FGSQf1lAS/td06Z+W0UHjo396
 5LbZxrGz
 CKQYCU7faENT3DjR0ksdSHYBo2+GPgN24S3NSi3C9uXfe5CTmNSSkIWWr5FE6F7FM8Q2II0kX+r9NXwTz1Rrf6GKPDym2x4N686rTADYI1PPHov9qgAkEmqaJujfYEqtTyLIwNWM7T+GtvKBPxLZYVRrtQPC/5RkbfGqM3prwQ4QJxxTxWzgZhj0iCHOIkZj2Zvc0IB6OP+0Kek7PL95aLh3asklQkfsTH32m+xK9S81uk7b2u9NlLDmlFeOsj9lMW+vYXgDfnGdgdDWJduwW7VioxdRdNF1948oG5T5ma11NQWFdBocVJGPvveM4Ud00s8xBMDqggUmv55Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize mqueue as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 ipc/mqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 322c3dd98c44..8bbe32d0881f 100644
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


