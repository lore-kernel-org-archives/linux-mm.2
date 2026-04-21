Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AA1CF89242
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 10:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30126B0088; Tue, 21 Apr 2026 06:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0FA6B0089; Tue, 21 Apr 2026 06:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F046B008A; Tue, 21 Apr 2026 06:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C23CD6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:22:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5F9571B9416
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:22:00 +0000 (UTC)
X-FDA: 84682172400.20.C1F70DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E09B720005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:21:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KrwP5ab2;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776766918; a=rsa-sha256;
	cv=none;
	b=hSe2VS2E5zwfU5NeIr4xH2LXHqnAj9fgvfmF+FiA5eFE6O6hlbBpFb3zyzlqi3NK8l+Ynm
	6mD7RF7mflArDXGpZ/3vaQ4NV9Cy1g6zAaSEF5RKYCXsIpRL64423iIBpmG8Tyq8l4PJN/
	InYPV12fuz+e4PaMC0nM1b7r+g+2scs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KrwP5ab2;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776766918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xyBlq4rEnY0XU8hvvVLnxV2Li/KBJ2NJA/oXO2ehp1k=;
	b=MWTj/i+gq6O4JVHidZ1TdVpekfSbEel+xRzWPRsud1dSHxJ1bxgkCUBJc3HwQSBTnA9a8e
	Mds1oh3ZC+7eO4BG1SH3G6TLAnjqvwHq8a/7QFq3GYcwdDubXCkcfq80/HbRBJzGc8o8ai
	zLotQzdKUXL3ioh18yzpaKCh3H2vv3k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 29ED06013B;
	Tue, 21 Apr 2026 10:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E26C2BCB0;
	Tue, 21 Apr 2026 10:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776766917;
	bh=YcQeXPBFzLIFxwlgMJlO6QDG9NPFdrQ59e2YKPfIG6s=;
	h=From:To:Cc:Subject:Date:From;
	b=KrwP5ab2KsfI7Let9L4Q4L7QZUFz3DDfjLL/nqfYqcy49NWC+eDrcRs9U7TyUXik4
	 o4qObBFGI2WxuVavdsm3kHdmfu2WA+B+SoeNcfH1HGtULWGjXmAyGz+56BxH5ODaZJ
	 s/SXT3ztJ5mIsVquOvoemzvGgD38HDKa0qGOivFube/NvSs3GBHPklx32YCRsII5G1
	 IYB4HciYwVSekuwKGXIShXGIz8pm+oDrbXD58I65NNAepMWCqsMNiKgASpwX4I4IZ+
	 8UW0dKT4Q/ON4uOECWZ2KjnqrovyynQAThcwwDk9Hm5qzB0hLWTJHuegkZXVAmPz/e
	 7ZkhuN77D9BBQ==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH mm-hotfixes] mm/vma: do not try to unmap a VMA if mmap_prepare() invoked from mmap()
Date: Tue, 21 Apr 2026 11:21:50 +0100
Message-ID: <20260421102150.189982-1-ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E09B720005
X-Stat-Signature: ehhhd6a3gtjpijokxkszkhdsk5zt3yt4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776766918-416624
X-HE-Meta: U2FsdGVkX1/+gzv4lfVdbiOaXQkOM4RpHJK6KE9e+KyPA5ueV9rgd2DrV7Nn05vLLWXEIpLwu27QJFZ34abW8J7iAEr53AmWsrt/UqXIIRVtnmvJT7UJrPLJAMwo8pf4qZNQlET1j9O5ZOG/h/2AMT1HX5mExI+o/iUnzJZXrHapFFbJR04ZMm4LxIYuAr2IUCGJvHwYYbrsjERngwtDNXVKQSSt1Q9Rk1DE2fBKfjGTCVQlI6hA50j3IjN79mR6jPvBFkx8VEy5M4D2N0ME54omjIokuUSP8AmYkYk6plLR2zmLExx9Yo4eqdx4X6Jwz2uj3VTDkv33JmaHar2VcNRXoe7U+VBWqQe5YCZVhRW5vcqkTn69Wb/gq9ShuwiUy8nM89rIPt/aDY3CgOqw8UKCbIODrzxlTp3k1rJGtqX1xyINMGL794YT55edb7O7QBc4x/MFG6DHaRbsEPP+E1LMQudpfpmpnetsVmPey4gXWYXpKGKOsOISgjBfY0l9tBWnipyKFtJgRirp8U9Z8XXuXV8zasYS7TZ/yUAXfKILF3E/DHaKiylHPcIZOHzpPiZC8YSAOKsgEk9B9hgomvzbfZFvq1XV2DSAJEL6H9mHlkIX3BhbyrRbJMydilSHSXKxVV74Pq4sVW3bV+OdMx3nANlR+TIJz7VUFz8T03Y//LwxDYUmomOel/+zUciFNCzF7jheS+2b/IOdjI0m5zugtOmAsckndCNClZHIaQ3/TOEafFOPwc1viq7d+vartp1tMsJlVksG0JPUJvaODYPYL28hsdXHCPDdIaZqc6//RBc+yydbuksa+sA0HDcE70GkFcGxO6PAEi22Fjqoh0uxPb3x7Kj01Pk9uSkUbyqhdnaWnYUp85syYDMUScyCvvdvQMJoO6WyH1dYFy/2KcV8ZlCWUQeHnuAZG28HKByx9rvmMs2pI33Nrgf723qst3/Sh53TQC7GewuMj/J
 6JvOm3cO
 JLV1EKKstGzohOpDPz2WeF0pDUZxHpXVxPiIS9XPCFQCKkvnXNyEz9P+xMawzJu1uoxqNXQkRyxlcYqwPdBidyT2wPU4gKt9ytcVQX640cpoBp3NtULpkMW9vGP6vR1HMfscLt+5cS1v8gjpCjlSg9pWg07LGCXpnZh4KBVl6Dt58GXSjPm36mRXrHIV7aoASkNZtCWqfDejJrX4UWUSKdAiQXafYOEBL2BIIJqNqtAWbl6WTdYT0dPAK4TrfueXjnJ2d58yrNEHzIW+OWptWan1k4M0Gl6drOLGk2mnZxjbeXHaleeDfRwhRxW9piIK7w3OZp7jKqbhbXz6aUZm0dfKXV3WLJqV6GYxs7t7i4YMDhmA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mmap_prepare hook functionality includes the ability to invoke
mmap_prepare() from the mmap() hook of existing 'stacked' drivers, that is
ones which are capable of calling the mmap hooks of other drivers/file
systems (e.g. overlayfs, shm).

As part of the mmap_prepare action functionality, we deal with errors by
unmapping the VMA should one arise. This works in the usual mmap_prepare
case, as we invoke this action at the last moment, when the VMA is
established in the maple tree.

However, the mmap() hook passes a not-fully-established VMA pointer to the
caller (which is the motivation behind the mmap_prepare() work), which is
detached.

So attempting to unmap a VMA in this state will be problematic, with the
most obvious symptom being a warning in vma_mark_detached(), because the
VMA is already detached.

It's also unncessary - the mmap() handler will clean up the VMA on error.

So to fix this issue, this patch propagates whether or not an mmap action
is being completed via the compatibility layer or directly.

If the former, then we do not attempt VMA cleanup, if the latter, then we
do.

This patch also updates the userland VMA tests to reflect the change.

Fixes: ac0a3fc9c07d ("mm: add ability to take further action in vm_area_desc")
Cc: <stable@vger.kernel.org>
Reported-by: syzbot+db390288d141a1dccf96@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69e69734.050a0220.24bfd3.0027.GAE@google.com/
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h                |  2 +-
 mm/util.c                         | 26 +++++++++++++++++---------
 mm/vma.c                          |  3 ++-
 tools/testing/vma/include/dup.h   |  2 +-
 tools/testing/vma/include/stubs.h |  3 ++-
 5 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0b776907152e..af23453e9dbd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4391,7 +4391,7 @@ static inline void mmap_action_map_kernel_pages_full(struct vm_area_desc *desc,

 int mmap_action_prepare(struct vm_area_desc *desc);
 int mmap_action_complete(struct vm_area_struct *vma,
-			 struct mmap_action *action);
+			 struct mmap_action *action, bool is_compat);

 /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
 static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
diff --git a/mm/util.c b/mm/util.c
index 232c3930a662..3cc949a0b7ed 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1232,7 +1232,7 @@ int __compat_vma_mmap(struct vm_area_desc *desc,
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
-	return mmap_action_complete(vma, &desc->action);
+	return mmap_action_complete(vma, &desc->action, /*is_compat=*/true);
 }
 EXPORT_SYMBOL(__compat_vma_mmap);

@@ -1389,7 +1389,8 @@ static int call_vma_mapped(struct vm_area_struct *vma)
 }

 static int mmap_action_finish(struct vm_area_struct *vma,
-			      struct mmap_action *action, int err)
+			      struct mmap_action *action, int err,
+			      bool is_compat)
 {
 	size_t len;

@@ -1400,8 +1401,12 @@ static int mmap_action_finish(struct vm_area_struct *vma,

 	/* do_munmap() might take rmap lock, so release if held. */
 	maybe_rmap_unlock_action(vma, action);
-	if (!err)
-		return 0;
+	/*
+	 * If this is invoked from the compatibility layer, post-mmap() hook
+	 * logic will handle cleanup for us.
+	 */
+	if (!err || is_compat)
+		return err;

 	/*
 	 * If an error occurs, unmap the VMA altogether and return an error. We
@@ -1451,13 +1456,15 @@ EXPORT_SYMBOL(mmap_action_prepare);
  * mmap_action_complete - Execute VMA descriptor action.
  * @vma: The VMA to perform the action upon.
  * @action: The action to perform.
+ * @is_compat: Is this being invoked from the compatibility layer?
  *
  * Similar to mmap_action_prepare().
  *
- * Return: 0 on success, or error, at which point the VMA will be unmapped.
+ * Return: 0 on success, or error, at which point the VMA will be unmapped if
+ * !@is_compat.
  */
 int mmap_action_complete(struct vm_area_struct *vma,
-			 struct mmap_action *action)
+			 struct mmap_action *action, bool is_compat)
 {
 	int err = 0;

@@ -1478,7 +1485,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 		break;
 	}

-	return mmap_action_finish(vma, action, err);
+	return mmap_action_finish(vma, action, err, is_compat);
 }
 EXPORT_SYMBOL(mmap_action_complete);
 #else
@@ -1500,7 +1507,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
 EXPORT_SYMBOL(mmap_action_prepare);

 int mmap_action_complete(struct vm_area_struct *vma,
-			 struct mmap_action *action)
+			 struct mmap_action *action,
+			 bool is_compat)
 {
 	int err = 0;

@@ -1517,7 +1525,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
 		break;
 	}

-	return mmap_action_finish(vma, action, err);
+	return mmap_action_finish(vma, action, err, is_compat);
 }
 EXPORT_SYMBOL(mmap_action_complete);
 #endif
diff --git a/mm/vma.c b/mm/vma.c
index 377321b48734..d90791b00a7b 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2780,7 +2780,8 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	__mmap_complete(&map, vma);

 	if (have_mmap_prepare && allocated_new) {
-		error = mmap_action_complete(vma, &desc.action);
+		error = mmap_action_complete(vma, &desc.action,
+					     /*is_compat=*/false);
 		if (error)
 			return error;
 	}
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index b4864aad2db0..9e0dfd3a85b0 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1330,7 +1330,7 @@ static inline int __compat_vma_mmap(struct vm_area_desc *desc,
 	/* Update the VMA from the descriptor. */
 	compat_set_vma_from_desc(vma, desc);
 	/* Complete any specified mmap actions. */
-	return mmap_action_complete(vma, &desc->action);
+	return mmap_action_complete(vma, &desc->action, /*is_compat=*/true);
 }

 static inline int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index a30b8bc84955..64164e25658f 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -87,7 +87,8 @@ static inline int mmap_action_prepare(struct vm_area_desc *desc)
 }

 static inline int mmap_action_complete(struct vm_area_struct *vma,
-				       struct mmap_action *action)
+				       struct mmap_action *action,
+				       bool is_compat)
 {
 	return 0;
 }
--
2.53.0

