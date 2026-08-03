Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC7C3C55AB9
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 18:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817B46B0092; Mon,  3 Aug 2026 14:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF6E6B0093; Mon,  3 Aug 2026 14:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C5B6B0095; Mon,  3 Aug 2026 14:05:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44EDB6B0092
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:05:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B287012078C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:05:17 +0000 (UTC)
X-FDA: 85060735074.07.8489494
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0DE17140004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:05:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JMUECnJP;
	spf=pass (imf26.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785780316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=W2kStB1YVLVAsQPtUhw3R9F4+saCiGZ5gertLGOHTy8=;
	b=OAVdUdwpY2+NWcG7zbWCr2A8MT4uOoZ6Sr27mulugfms0Lz/GJxPrbkm14mRMGNzTceJDF
	Q+Z8jp7YUM1P5Y1LiKLBzMW5PpcbMM5jC4fG/txpPl4A8TYkfB+wFOHVq+W7JrMXUddXjC
	KcUNA+xYlbyHcwX8MCBddXg0gyzXSpU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JMUECnJP;
	spf=pass (imf26.hostedemail.com: domain of ebiggers@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785780316;
	b=pTJmaHgsgJYEbl0DHlDxnfROfkiAyn4Ev3AlxDbFHcoqch9OFBIAOGLb6rwFbdVxUtksM8
	2egaHLNh3Eb1WxYI3WZonuY8cCjuRGIp8STBP/HhK0Tr2xdty8qQQhLx5lY2z1hoLBOeJ3
	rE/f4TIAqW8Y7kQnpa95BzI8mqDcXaQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 663FF4501A;
	Mon,  3 Aug 2026 18:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4F01F00A3D;
	Mon,  3 Aug 2026 18:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785780314;
	bh=W2kStB1YVLVAsQPtUhw3R9F4+saCiGZ5gertLGOHTy8=;
	h=From:To:Cc:Subject:Date;
	b=JMUECnJP5du5ysAKwoLyMQiDiGNYXlVRUq/jZCqBrv1ijy7sailXgEvXbniKkAgUv
	 7CvucJgQ2c/xRqrhe1JGRT3xaN38/honV6cGw/RCu1hMtL1sN4vs3VLIT2sfMkdD9R
	 LCY/87XFNb1QnLJu7tfvrWYuzZhIpACYLQCHvI7Ze75HQsWaxFYmfKHbYpqtwIt/Ay
	 GT8WPt+dPkX94Ha8/d68fRGAeaFSBS8NsxJHizAOSdkLH5VsWnk+fLI96Y412qKhEB
	 JW1LYt7Zf8mhN3d4Y7zp5B+tvU3YsozNo1RVdBAHVc8AOYu4JX/vBVu8UXYtVST7rI
	 PxI03tlWuVv5g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/swap: reject swapon() on filesystem-level encrypted files
Date: Mon,  3 Aug 2026 11:04:26 -0700
Message-ID: <20260803180426.3123-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0DE17140004
X-Rspam-User: 
X-Stat-Signature: i63a8najaxumshbcptnduo35c5bfxfp8
X-Rspamd-Server: rspam04
X-HE-Tag: 1785780315-522731
X-HE-Meta: U2FsdGVkX19zAICZNWVDDPvYBicBsbqItaUrsVgudftUxdyvSM3doKpRx6G1aH2r3WdviH/FfxQK5LjFz5HerPVWRJ0VTg4LCLU7+IVUbgbEC2ECdnyLo2xDHBXqB5QkLZVawSe9mo3tjAy+QhCPQ/PeAj8tN62r/664MvNom85qsLvELcnLgiZmqw3yRpapZluquDpMhQ6af7RKpapuFGR4CqLSNM8XAlDC3FHMiIirPQ2M/0I4swO3GoMWJgyrX0rnOCsrDFTfXzqHBcvwtgYvkNla+3xoWNr8/Tt73ucinpeku9HLCCwWAL+CCgi04DhPwp9i0PoIhFuqilKVyxnpGTNeVkZ7ftyRH5s+Fwwja3uZAp1BYvKlu+ebcyaoOmzJJ+QsUDHRwJhEeKFuU+LCFuE/77ckPBbKhLnhZxbEx7zdA1kAjlBxPH51GACUt4lzcgPIY78i3uZOUXaYBi1Uui5o0vYT3XmyYlOAaeO5s5d0Z6ppP7a7sMONjW1dh16aJhu6nsPSInnqavDfS6ggB23LtkA0Hpmia6UhviRC2qBFsv7b0lwLJT+oDs7OjscZN0KBxTwITjvYd52bijZlsS8cH4xTViEOlQ3KfmWa6rXtt1G0qkuFS0EwtXlybz8LY4fhZ3Ss4aScogsRiUVnBhnT0scguwhcKg77GAAh3fge5GNmID6BkD+veTIUyvrzmh+JYx0zmjdwY/f+t+nARCuV20/3uWUvgQEjsvPQG8sQGccYk1SlxGmnqtyMArP2csmaotG8VUreswSv+pyocMUC72MpPQ3T5lPcGoYXsV/ayrkJKNx0HNofv1sJj0YvkM3S1hv86LdgfOUDmjj0MfAPzSZ0XwbMnFitDXwZE+3AVfctT8vJW2W1Ewi7P26QA/u1kUulMuuuhI8HjDZKINngP8ZgzWm7Ge5uk+b6YPPO6YZZz+prH8dZ5Oq+t00oitO6z5Z+YxsTSDN
 +z+mNV7N
 +6LUNnuqSjbCcuXTmFdzJyo6uOklSO5eejQZxClzzGDVDdXdDj/XtqhcmiT9YbzFZjKwAZsCpWbLStN4XIvxPs7wFMMmzSUwMbbvvtHowN8rv6aZFk2J/Vl2QTwH3b5sDVYrYf2879f1BVbQ86JwUcFbSsFcvopC/VfsFS5T+4BudiaOuxkMEggpCYqSUUAdAT6zG1UWlQlCSMHBQdF/TNC6cDiDpPri1NgMEaMvRrpB2wBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ext4 and f2fs don't prevent filesystem-level encrypted files from being
set up directly as swap files.  In this case, encryption is bypassed.

No one should be doing this, vs. the methods of encrypted swap that
actually do work (such as swapping to a dm-crypt device, or swapping to
a loopback device on top of a filesystem-level encrypted file).

Nevertheless, to prevent user error, make swapon() explicitly reject
this case.  Document this behavior in fscrypt.rst as well.

Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
Fixes: f424f664f0e8 ("f2fs crypto: add encryption policy and password salt support")
Cc: stable@vger.kernel.org
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

Changed in v2:
   - Added a pr_warn_once
   - Removed unnecessary word from fscrypt.rst
   - Added Reviewed-by

 Documentation/filesystems/fscrypt.rst | 4 ++++
 mm/swapfile.c                         | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index c0dd35f1af12..e4882b73120e 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -1238,6 +1238,10 @@ astute users may notice some differences in behavior:
 
 - DAX (Direct Access) is not supported on encrypted files.
 
+- Encrypted files cannot be used directly as swap files.  To swap to
+  an encrypted file, set up a loopback device on top of it.
+  Alternatively, encrypted swap can use a dm-crypt device.
+
 - The maximum length of an encrypted symlink is 2 bytes shorter than
   the maximum length of an unencrypted symlink.  For example, on an
   EXT4 filesystem with a 4K block size, unencrypted symlinks can be up
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 78b49b0658ad..8538659acb9e 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3650,6 +3650,13 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		error = -EBUSY;
 		goto bad_swap_unlock_inode;
 	}
+	if (IS_ENCRYPTED(inode)) {
+		pr_warn_once(
+			"Filesystem-level encrypted swapfile '%s' is unsupported. Create a loop device over it, or use dm-crypt\n",
+			name->name);
+		error = -EINVAL;
+		goto bad_swap_unlock_inode;
+	}
 
 	/*
 	 * The swap subsystem needs a major overhaul to support this.

base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
2.55.0


