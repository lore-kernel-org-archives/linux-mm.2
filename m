Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 141D360A2619
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 18:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=KWfjA+/O
Received: by kanga.kvack.org (Postfix)
	id 326BA6B05B1; Wed, 18 Nov 2026 13:23:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D71D6B05B2; Wed, 18 Nov 2026 13:23:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ECEF6B05B3; Wed, 18 Nov 2026 13:23:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E75D26B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:23:09 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90CE2C0826
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:23:08 +0000 (UTC)
X-FDA: 85449061656.21.3B5B115
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id F186920004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:23:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="KWfjA+/O";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795026187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=EU0w2Pj7eYZo7t7cHwVW7q82EN7P2iEY8kXTkymFoF4=;
	b=q6YQ7+DUZHNm1lhVWibk2LOKvZFSEXnKlsQ48Y5zZnmSE3lVTxAcKZhP9/qv1CFGCAuymY
	6cHtpaytqjkBStiWNrEfH9sd/yBcwtOVYXUzofHn+MgJGzTX3yixyt/jH+e+L2160Sx8wK
	lIs2XvVnnDgwxIPfSLYPUMYpLoBj95M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="KWfjA+/O";
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795026187;
	b=uWI3cLuu2lP6g4Oy2G4Z0ePhUJDqR65/RMKdLoZEPneh4riOgZyidX8wMGMwyruG+7+xgm
	T1yI+/jl2T2xd+z87RZSICwZ4gcgqZ75Y8oMyiXGHyuPTYgc2Kj8luhbPsNVmtVcXNFtKu
	+ItNi6UUSmdhzwnPJw73UL7Kl14j9K8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10F6646F1F;
	Wed, 18 Nov 2026 18:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64531F000D1;
	Wed, 18 Nov 2026 18:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795026185;
	bh=EU0w2Pj7eYZo7t7cHwVW7q82EN7P2iEY8kXTkymFoF4=;
	h=Date:To:Cc:From:Subject;
	b=KWfjA+/OMvOcJKU7kDKY+pGt1QJ2Z+wc3E2Lk1dFAkFKbiPY0t7/40JEp9Rmukcno
	 b/DPcqypQEYGvEl/sk6k/mdsxqoW6eItFpo4APZsrQ7qS1Nfz0g6NOLxzIxTPDHqoi
	 k8Fu1l3Q+e/5iv1IBlaUP+1+iJrtdVydfZ4+g6Ls=
Date: Wed, 18 Nov 2026 10:23:05 -0800
To: Christian Brauner <brauner@kernel.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Miklos Szeredi <mszeredi@redhat.com>
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <00461f0c866d4a4eb9f50792f0e1f3d0.1@linux-foundation.org>
Subject: [PATCH] shmem: consume the reserved xattr space despite remount
X-Stat-Signature: npwjn1d6i89yj9x3q3aicssx7onj9643
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F186920004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795026186-437009
X-HE-Meta: U2FsdGVkX1+sg3+e3VmopAm46fDcVJ3v5xnL9BtEoVAcx0AmtMxhMnhtoLbe64YnATKZh3KFXmlAVrgQyoUoQRSGgQepRb6IpyKtl7p9NyxQUsVJcNYoLmt0WV4br80CXr96BseZnXV+fDdOyBcz0BvJjvao8n/+YbVDDJCSmZwEmxpv0jC3JS8YuTr3iYDCiuxx1YTJ0KT+WTnD0ILWWYCYCBQCRQ4t1FZO73OrTnsvfiwNKRtjSvy5EbOdGesiGcG6z84oD/g8cPw305r0a15IK+GqI7dOoI9JNAcg9BKgDucNF5+VRuUzl+GhmE6fPj3DUU5fvMsPoJeWHg4FEqUMd6XWjGeMYGFUswcOFX185SxcHOyQMRUiJYNFVw3Wz0JTSuGUcVoikRDE7usszcUlNVCEWh0l4gMMx1tn9bU3yaD7KxUqb8PBekPgvye6TljLtJhCoDTSWg5EK6hiCiKOHBFQJgwk+W30VnoOuTNebd+BidF6Ylwf0HAmT5xPnf18vCcapTrh2G2SozMQndEpRUtXNuQRM3mIka6Tewpf3tqmdpFjKw/+T9TTgeo7jlFw9LhyQ+X+N9l8vLohi3Wd9REnAch9D0ZCZHdDMAGb8txUPo3Li8u6zMqOwIllM31iMCxJl4nMzUrItQ6IzctMHsaVqcj8kDcZ2qTFkk3FnzYjt1nBo4bw6RvySgTV58N+Hlcy3dzgb4kH4ZbURbRJkAk1AlMsb6u1YGTS1lM1Y7Sr480FSw3fJSwXukgn2+TOoxcfq3UjhpmxC+LEW7crG2tkyWS9FxEK4OxSGvph7YcfiMwTFtRe7dle8KLa8un5m6kNrpPZCv3d1gBVWgxv16QUApigWMj/4lL7SrIYw6EwSxNaiuzb0/GHq2my1l1/8uqg5VXM0YHhMLaAnzyk6IHIR/28pUi5qz9T6NOOPbK67aOeJPZ3xGPBvWQNEnwPUhE0dmG+3FHboLF
 apWKUoeC
 pYG4GDWHzvrXmCJjDBr0eRKGAb88E+8qWNBFZLzdkIuMvlVWEW3OrX+gPHE0Q8zfnnQX52A4LAM6mBiK3QlXNMtPHeYTwbJ0vwJPHJy2fC5rPZbXxmTo4/T+KhBbWH9q3aCB1nIgo4W7xeHuZofR9QxzNJKjxM1vT5rSLKDQdkti4vmM9l/shLmsMBVReCb7nQo/fS/F/+9n0pcwT87oTejcrKDx/G0UmjxvxRgzWB3KdVzFI5uqUGlX3O59nJO8/h+1O05TyOHk//smt9/322GIksRV5zpr6FGTYq8HyHcABCbgSUykxHYNv2H7dzOkkwUxhGgCUjLDEOoisx90C97/B9ADV/OFwMBvVcWd5ro+gThb9XiCulQ8nIVejB6liCfUEcIfS12BC0RmOxS1pyuFnkZLxG4N28TQvT8irGEB7NtNV7UfdRiFlDFt6LMebNjoFHPBTV/LEzGLhMgW0GB7PRd7DZtsDhPm1DIdaNbNlvm+M7fBIe1pYlNY48BFkxo5+aLuvi/MsZ2auRr5WjObWYKojZuSEG4tYAb6oYeo1jExVSC+Zvgc7E9Emes8/2MYUQ0Tyi4Q2j4FMqA6GTkIIiT0s24Rwa+exefRCJuOcSHCJiEfBhbJAZZE4o6C7iAuP+/IIupnC0Zw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>
Subject: shmem: consume the reserved xattr space despite remount
Date: Thu, 05 Nov 2026 08:08:06 -0800

Creating a tmpfs inode can trigger WARN_ON(ispace) in shmem_initxattrs()
when a concurrent remount sets nr_inodes=0.  With panic_on_warn enabled,
this warning can panic the machine.

shmem_initxattrs() reserves space for the security xattrs while inode
limits are enabled.  It later tests max_inodes again before consuming that
reservation for each installed xattr.  If remount disables the limit
between those steps, successfully installed xattrs leave a nonzero
reservation behind.

Use the remaining reservation, rather than the current mount policy, to
decide whether to subtract the installed xattr's space.  This also leaves
the failure path with only the unconsumed reservation to refund.

An initially unlimited filesystem cannot acquire an inode limit through
remount: shmem_reconfigure() rejects that transition.

Link: https://lore.kernel.org/20261105082717.c459bb33778fcf27e5675082@linux-foundation.org
Fixes: 076e5cef28e2 ("simple_xattr: change interface to pass struct simple_xattrs")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: <syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=4324f771847cecb27c54
Tested-by: syzbot+4324f771847cecb27c54@syzkaller.appspotmail.com
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
---
Reproduced the warning before the fix and verified its absence
afterward in a Debian 13 guest with SELinux enabled (permissive).

A temporary hook paused file creation after reserving security-xattr
space. Another process completed a real nr_inodes=0 remount before
creation resumed. The unpatched kernel left 94 bytes unconsumed and
triggered WARN_ON(ispace); the patched kernel consumed the reservation
completely. File contents and the security xattr were verified.

Ordinary creation on limited and unlimited tmpfs mounts also passed
on both kernels. No additional KASAN or lockdep reports occurred.

Tested Linux 7.4.0-rc1 with GCC 13.3, KASAN and lockdep, using KVM:
8 GiB RAM, four vCPUs and one virtual NUMA node, backed by a
Threadripper PRO 3995WX. Both kernels had the same diagnostic hook;
the ordering was forced rather than left to random stress.

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~shmem-consume-the-reserved-xattr-space-despite-remount
+++ a/mm/shmem.c
@@ -4491,7 +4491,7 @@ static int shmem_initxattrs(struct inode
 		if (simple_xattr_add(&sbinfo->xa_cache, &info->xattrs, new_xattr))
 			break;
 
-		if (sbinfo->max_inodes)
+		if (ispace)
 			ispace -= simple_xattr_space(new_xattr->name, new_xattr->size);
 		retain_and_null_ptr(new_xattr);
 	}
_

