Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA385E7BDBC
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 13:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172EF6B0092; Mon, 16 Feb 2026 08:32:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132026B0093; Mon, 16 Feb 2026 08:32:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0236A6B0096; Mon, 16 Feb 2026 08:32:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E24166B0092
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:32:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 94DE55C9ED
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:39 +0000 (UTC)
X-FDA: 84450409638.27.64499C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E1BF94000C
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 13:32:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m+BfJKAz;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771248758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YD3yU9Vlw9ssB3cROEE29TuqxXOWJT7xBd4NH//eYTc=;
	b=zFaAvDchQDvAFY+KdRK2v2ks9VuIJTEVpyCNhAhvByFroQFdsfhN7lyA+CQnaMJG7r89dB
	lDD03FmdJR2qocezGbAmYW3AoN+y3RoNHNs6jKDoRmZmG4p4jAbb3cLQ2cb12I+pybap2p
	9UI4t1Fhpzp8Im/T+YegN4/z4JOt5fw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m+BfJKAz;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771248758; a=rsa-sha256;
	cv=none;
	b=ZXnLdBu2LGzhkcKA/pLEI8qPi45n89K4kNKPIu7T7PMQikYI1FRnDGYw8MzvtCRvMEQ5kH
	xmoIdraqr7v3n/+QE+8nppN7gaOH1tt5rFJ9f+bAMZLLpwswcu43R+rWHHjxNPT6CXOb8k
	Q5Hk7Jz5ttAfB9o8txYa/Iamfh+ieUw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 18053438F8;
	Mon, 16 Feb 2026 13:32:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B37C2BC87;
	Mon, 16 Feb 2026 13:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771248756;
	bh=07ziX3ZBWcGP0yXHy4c2MCvyc7P5td2Iy64SBWqQAOo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=m+BfJKAzYWN4zRNOyeAKZFgosWaCsFhQr5OoKBjrtGva6kKKZwcb4Xc0ENxQhwZxW
	 Cav9RWXEa+GqmdMN4mjcEvTPYAQCyQdnVHTDK9l9ZeV1F5FvfS7/FWV+11RQzgpRkF
	 4rmR0JlI0gQAlZyfJfnpMvbYhHETArqW/CI4j4FDhOp6Pon5WyNlwzcYKDOM2vm5Qw
	 SEqGiKWWZqeMDdbRHB4bAs1PJucx+LVd55gKbstS54PNXycvtc6h34CoTNbW4oQiJJ
	 +gnSRdqpHPesrG/aDcLIUKe9KQh9Vqc8j76cTO1y+hKdouYYBRgMoTOHeZGvKG8jKv
	 uOpT/x1XDiSQw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Feb 2026 14:32:01 +0100
Subject: [PATCH 05/14] pidfs: adapt to rhashtable-based simple_xattrs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-work-xattr-socket-v1-5-c2efa4f74cb7@kernel.org>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
In-Reply-To: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jeff Layton <jlayton@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
 linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, 
 netdev@vger.kernel.org, Christian Brauner <brauner@kernel.org>
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=4671; i=brauner@kernel.org;
 h=from:subject:message-id; bh=07ziX3ZBWcGP0yXHy4c2MCvyc7P5td2Iy64SBWqQAOo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWROlonrmOSRt8BdI/uU0iNeMd706vvT+u6knXFNkOs8E
 xV/M0yqo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCL5rYwMO/OFTrtsmf/w+sqq
 mxcSshzvbYzPqk0T37/IOnD3e7FdQYwMZ+xlClubDmjJHnt5zIFpR9KCF1cXVz2Tecu5sTdn3e4
 b7AA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E1BF94000C
X-Stat-Signature: ufkbzpr8ig9i364rbhx573j843mu15nj
X-Rspam-User: 
X-HE-Tag: 1771248757-155330
X-HE-Meta: U2FsdGVkX1+KrSn5ymrc3faAtcSlzcYLXAe6o3cxFrXtKrS8qC7j8HttFsU7SQnDR/F6pvoclAYodNEsuyK2xOfdg/E3XBX4kHuRUEwzl6ysEXlPBgSHHc8TPRf+qEoa5M6+LB5HGBhBG9zWOwMme7r3n3Mp7pYNIVa6yiADgU5H48G4CR2cx0TNP8LDH2kICnYB/msLcdut0UzaA+e3/6gwXK76M6YUiueUDRAhQOnAjaOnnqUe4xiay0jQq963ZGSb5elNB4A4UJy8HuIfHMZHVwSwlQoVKtCoVIXTEpTr2QaOUz8c6SZ1Ug8rf51u3xwmGpkZ0/GAkDGeDwcYH269Ai59DVroedLUf9xMI9qpWDiCvz/igyIUy0zRteJ1KUzHwpOS/4u89z1cI5dMd41DzkZR6/8h5vxwpAjUL9idDvg4axlzoaJe0VbrKahL3ixrffBkQOKkYxFwY6IEtI5vO2ArVegjQOSbQQRE2k5KUNdRyyu/HgYAgebvbtq5fhJXnLdjtKCYEiJsezPXYSvt8v5Ije3eqViB93L7Dbygyq8hpYslU7knsSlXcNPW2qvXRB8CqtERXurB+WbWqcK9AU1SaakgO6G3FJoZ2ZOpZRR+YgshLDoFKiJeCTJi34BVhDWxzPT+5L2veXFF98Tp43MGT3CvJfiMp9pHIZ9tQ4rkgrwP4XKSvqAKrqv0kqCQ+HSH8qW5/i9tIgC5NiYY2Gm9w+D1gG2JGu2Y6QcTz19C+lxedz9pWc4X8P9Vau43ckRKb44TzfEVEzVIABrOINF5CzcDGg9XNZ3eZnQcq5AU4+pdpYMz3sODURzCemyAzgMN489JjLwe6w73TLzxwKt4Mzfjzhm6NIX1dP+6xgSxW7nCqrvHVW5NUoY7ltxAzXHTzy5ZYujbVIsyGlJ2s4Qp5WEWZYD9zjFaLHJtQIwqTn8eKco71tsvr7UPX29t7tn4tO1rrkFTEIZ
 2DJBn3Ib
 hnGuR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adapt pidfs to use the rhashtable-based xattr path by switching from a
dedicated slab cache to simple_xattrs_alloc().

Previously pidfs used a custom kmem_cache (pidfs_xattr_cachep) that
allocated a struct containing an embedded simple_xattrs plus
simple_xattrs_init(). Replace this with simple_xattrs_alloc() which
combines kzalloc + rhashtable_init, and drop the dedicated slab cache
entirely.

Use simple_xattr_free_rcu() for replaced xattr entries to allow
concurrent RCU readers to finish.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
 fs/pidfs.c | 65 +++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 41 insertions(+), 24 deletions(-)

diff --git a/fs/pidfs.c b/fs/pidfs.c
index 1e20e36e0ed5..cb62000681df 100644
--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -21,6 +21,7 @@
 #include <linux/utsname.h>
 #include <net/net_namespace.h>
 #include <linux/coredump.h>
+#include <linux/llist.h>
 #include <linux/xattr.h>
 
 #include "internal.h"
@@ -29,7 +30,6 @@
 #define PIDFS_PID_DEAD ERR_PTR(-ESRCH)
 
 static struct kmem_cache *pidfs_attr_cachep __ro_after_init;
-static struct kmem_cache *pidfs_xattr_cachep __ro_after_init;
 
 static struct path pidfs_root_path = {};
 
@@ -44,9 +44,8 @@ enum pidfs_attr_mask_bits {
 	PIDFS_ATTR_BIT_COREDUMP	= 1,
 };
 
-struct pidfs_attr {
+struct pidfs_anon_attr {
 	unsigned long attr_mask;
-	struct simple_xattrs *xattrs;
 	struct /* exit info */ {
 		__u64 cgroupid;
 		__s32 exit_code;
@@ -55,6 +54,14 @@ struct pidfs_attr {
 	__u32 coredump_signal;
 };
 
+struct pidfs_attr {
+	struct simple_xattrs *xattrs;
+	union {
+		struct pidfs_anon_attr;
+		struct llist_node pidfs_llist;
+	};
+};
+
 static struct rb_root pidfs_ino_tree = RB_ROOT;
 
 #if BITS_PER_LONG == 32
@@ -147,10 +154,30 @@ void pidfs_remove_pid(struct pid *pid)
 	write_seqcount_end(&pidmap_lock_seq);
 }
 
+static LLIST_HEAD(pidfs_free_list);
+
+static void pidfs_free_attr_work(struct work_struct *work)
+{
+	struct pidfs_attr *attr, *next;
+	struct llist_node *head;
+
+	head = llist_del_all(&pidfs_free_list);
+	llist_for_each_entry_safe(attr, next, head, pidfs_llist) {
+		struct simple_xattrs *xattrs = attr->xattrs;
+
+		if (xattrs) {
+			simple_xattrs_free(xattrs, NULL);
+			kfree(xattrs);
+		}
+		kfree(attr);
+	}
+}
+
+static DECLARE_WORK(pidfs_free_work, pidfs_free_attr_work);
+
 void pidfs_free_pid(struct pid *pid)
 {
-	struct pidfs_attr *attr __free(kfree) = no_free_ptr(pid->attr);
-	struct simple_xattrs *xattrs __free(kfree) = NULL;
+	struct pidfs_attr *attr = pid->attr;
 
 	/*
 	 * Any dentry must've been wiped from the pid by now.
@@ -169,9 +196,10 @@ void pidfs_free_pid(struct pid *pid)
 	if (IS_ERR(attr))
 		return;
 
-	xattrs = no_free_ptr(attr->xattrs);
-	if (xattrs)
-		simple_xattrs_free(xattrs, NULL);
+	if (likely(!attr->xattrs))
+		kfree(attr);
+	else if (llist_add(&attr->pidfs_llist, &pidfs_free_list))
+		schedule_work(&pidfs_free_work);
 }
 
 #ifdef CONFIG_PROC_FS
@@ -998,7 +1026,7 @@ static int pidfs_xattr_get(const struct xattr_handler *handler,
 
 	xattrs = READ_ONCE(attr->xattrs);
 	if (!xattrs)
-		return 0;
+		return -ENODATA;
 
 	name = xattr_full_name(handler, suffix);
 	return simple_xattr_get(xattrs, name, value, size);
@@ -1018,22 +1046,16 @@ static int pidfs_xattr_set(const struct xattr_handler *handler,
 	/* Ensure we're the only one to set @attr->xattrs. */
 	WARN_ON_ONCE(!inode_is_locked(inode));
 
-	xattrs = READ_ONCE(attr->xattrs);
-	if (!xattrs) {
-		xattrs = kmem_cache_zalloc(pidfs_xattr_cachep, GFP_KERNEL);
-		if (!xattrs)
-			return -ENOMEM;
-
-		simple_xattrs_init(xattrs);
-		smp_store_release(&pid->attr->xattrs, xattrs);
-	}
+	xattrs = simple_xattrs_lazy_alloc(&attr->xattrs, value, flags);
+	if (IS_ERR_OR_NULL(xattrs))
+		return PTR_ERR(xattrs);
 
 	name = xattr_full_name(handler, suffix);
 	old_xattr = simple_xattr_set(xattrs, name, value, size, flags);
 	if (IS_ERR(old_xattr))
 		return PTR_ERR(old_xattr);
 
-	simple_xattr_free(old_xattr);
+	simple_xattr_free_rcu(old_xattr);
 	return 0;
 }
 
@@ -1108,11 +1130,6 @@ void __init pidfs_init(void)
 					 (SLAB_HWCACHE_ALIGN | SLAB_RECLAIM_ACCOUNT |
 					  SLAB_ACCOUNT | SLAB_PANIC), NULL);
 
-	pidfs_xattr_cachep = kmem_cache_create("pidfs_xattr_cache",
-					       sizeof(struct simple_xattrs), 0,
-					       (SLAB_HWCACHE_ALIGN | SLAB_RECLAIM_ACCOUNT |
-						SLAB_ACCOUNT | SLAB_PANIC), NULL);
-
 	pidfs_mnt = kern_mount(&pidfs_type);
 	if (IS_ERR(pidfs_mnt))
 		panic("Failed to mount pidfs pseudo filesystem");

-- 
2.47.3


