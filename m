Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72DA0CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 18:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453EC6B0088; Thu,  7 May 2026 14:24:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD076B008A; Thu,  7 May 2026 14:24:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A4BD6B008C; Thu,  7 May 2026 14:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1342A6B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 14:24:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 89EFB1C04D1
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:24:55 +0000 (UTC)
X-FDA: 84741450150.26.9C7A2DD
Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	by imf16.hostedemail.com (Postfix) with ESMTP id 16034180011
	for <linux-mm@kvack.org>; Thu,  7 May 2026 18:24:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="m/CF62FO";
	spf=pass (imf16.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778178293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YTzBlN1gNPaYI5pbhlNSNBseIFET74X1DkZd5PVuRlo=;
	b=mmyrgYZnfEsOhzXjZJY1AIJuHw77rWoIrZG7BMta8e0V9o5EL7x19DCbuhbKH/jR3Qbo0R
	L84gmMizpZv7oe4KEh9adtc8oXhxfwyxrLPqnBmxpZS9xw4WJzd/o5l6DCCKh294557vHe
	875ODKVg2rqeeupoB+aGJeKslGJdPc4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="m/CF62FO";
	spf=pass (imf16.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.87 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778178293; a=rsa-sha256;
	cv=none;
	b=NmR/GIlr7Ot+mkeTI44FKPvfleAcSsfW+WNfNN4gigrw3uOepr5KBPnv1NN3pOQImgJNGj
	cEzEQYlnhnKQ5ICtecJkg3pGrt7smZ+jJ60YqJsqoTCworl+dXnNQ+tv8Y1FcHy7jJrvH/
	WRLExBTn6XhMZFd4v3MpRO+wpjpB8xU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778178288; bh=YTzBlN1gNPaYI5pbhlNSNBseIFET74X1DkZd5PVuRlo=;
	h=From:To:Cc:Subject:Date;
	b=m/CF62FOjDxVPXT1r0SnoFDAFJAgBj+cT2MUDTrElOMV/p8G61MyVyxO7Y6amDJQP
	 yXCGrByFm6yianlh1isop5O1K6CnwTfXmCKSI257N3N6UALZkobAn9g3yGmcmVZ8Fl
	 C9eneXZ8/wukaqPEmb46NdyQxwJjZKDlJvnkaiLY=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 62D296E7; Fri, 08 May 2026 02:24:45 +0800
X-QQ-mid: xmsmtpt1778178285tb9b85fos
Message-ID: <tencent_863C8A01F3C81EBA238F375B16065CBACF08@qq.com>
X-QQ-XMAILINFO: NoN45VbJ/ow6D8Ht9dJHfQ5rBWFj0quQCNsp5SWGz1K2OzF2JjOX+OhWVDckHJ
	 ICalNrMnfnrU6ZtM2HZkAYCFn/ciM9cJmfPvmWi6FNSkrqLn4OhuhXWYpNH40HZMfnegtcb+WPmZ
	 Rh7GMxuXmkZUFtPic6JjfuCRxLlUen05vfEzcB4Fw1QqnJ3oQ2ZQ9ZFon6VbvAeVbu5zNwW3bbQA
	 xGM0xS1qtcG4BWCN+4ib+f3nErVlC5uJVNfU+hBPDHbGCznQjFhGqI/5boyOYdNaN42dv9Sscw0P
	 VMF1Mc8mzWfKLpsECs8eztxe9pydfBMRr097A4lvjZgcHg3BfTL8IJEbgvheSeyEqspd7JiO3S65
	 1b2gVP7zcGLE+6EijbBqo7m1sSjSbtzXqade7AWG0aZYM6Snw8bHLdFyHmSmTNmDQR9bVkLRAttg
	 7xCtv0mpFmHKXjqLi7ZqDUSbOeEr7VRmTp781SdDmq+wfANvH2ShNGIuwxh6Nl96plEJoJKslnsv
	 VOTACGTW+yoF+jbUI93H6NcvFRDueBKTmtF4QF2EOtnMz+FiBf+FU0Euug1g9FtVsruh+SP4jpis
	 krjcpt72RpdxeSl6n9p/tDVO2hezT9s7nP31VPKMixcl/rCpcuHKwJMCeIcQpCp0MxWt//qDFJ8D
	 fliF0HG7coWA/ZCzXgN4cNlecPxUAhM0rUuW3sPflwHvZotR6n3glMeSEhVAWd5iwIhNl//9VPPB
	 3mMupRPyso4LTugJfoBacHtbtPUIk7V418Nu8J2W/pPZeEZ9jle/yotSpsNPUKOLLsiXDcQMDcRW
	 hssp+vs0m1ILYtEyGFFUq6I8oVFFKcUrD3ZwIZKsfLyb2P4mAn7lrjclZ0gIKIcxKbEYGiMNz1LL
	 w78i+BSsBC1LiUabdhd4k7lq2vG+PRebRxmOsqLgSj9GQtprxlYubSW4aZ9YOoLlE0JiU5DEfoqZ
	 CdcYrzZg1IlErgYbWVlCYgtW46iADi56+ag0vG8DM9UkdlX8qUKSiLeV6yCZslq8gF7Fya8c4dtB
	 MOS7OL1A==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH] mm/mremap: unmap full fixed target for multi-VMA moves
Date: Thu,  7 May 2026 18:24:45 +0000
X-OQ-MSGID: <20260507182445.2077251-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: abpnerd4s5buiyue3q8t7nomqkngbdxu
X-Rspamd-Queue-Id: 16034180011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778178292-134935
X-HE-Meta: U2FsdGVkX1+ORSZ6ruIXjyvjujHlRRoRuhvukZOSjsFk5xAfent2Suhd5F5Sxyt/qWZTdKDlDfKFee7bAa/QzxvsjpvRaJq7AUjRivOEaQVRJspC55siZm8clJCqguTxJmC5AIn9TxAQeto6myR9/m6cnL8IzGRvrTU9NDIK7NQKy9iCEqbBXODNzJDTW3wJmIt4X/Ko5xMxDgXrl44l554FMIL+EHBeIQGriB6V4ozlVGTYLde5SiLbRuYKYy4JzostssBFlsmBYaRt8t4K8oCqOXE06u8BkyJ0EVmuZse1Cy6GqDnSVLhuZ8HgEfgF/38ATn/bnkcjFOeWj5cruYkoC+abXE+xqA/0C4RWy4rrkCnE1zpljtfo/iJRCP+j8iRx0aFhM58IvXrXMjrqMJIvRZo/ino3a8ZguJABud/646AjxnH88Q4wsct/YykxpUD5hRHZ4ASFzozRvxLnPz6l/AkqfSTJcdiRTcOz5b7IECSGAoy3ZnkeMdNfw50ZCCnno3yRYs85Z5xpZeDuwmSBGJpCcVctUC6ThRjBZMRNpnCmr8x8eVWMUlEWuIrtSsi9nld5liir450xnO+4FdCjXoGXX3GjP89pA1+aVwP+IbLR7AWiO/e9APFPbmw52itb20N8yK7aVIVCJT6UVJvD95Q8k3LM/1AdBX2lB8sw4q7gRLcuy/MR9PkTqOoPHPNPCmxN42nMop3aEO9JotM8HivimOGRj/vl3yQgmNqf6cLd8QTZvmG3+mVpTbQPvlEKz8mCBEKyV009CD+WfRiozmZ4KFpkZwaxFNtaxBwfTWan2Rxp2SvwneOd/UcWoAlUcVKIMNnsxlaueE9XMps1BmOYwbOsLzTxi7V9ttLSg5Eu4ff8akix25qH7h4Bq8fhDOGKm6gmOZ7A1pjA9uscKaBv79yyxzK+zaM0ZhhEuhExaYRdsmrahFCYFM1a4LV9bkgkdIssfH1748s
 t9tOT614
 xh6ayDTjiLRIr3kYiKc51I2VQoXbAXILCB/L6kCEH2coPIaqZMLVxXpzrXml007DKcb8huTzZrgfbmdnJpGXV2jNonlrKLgphnqRB57lUq/VY6Tg7mTox1WN8lDh6vjBx3OoQDR0OQ5llZhTceZMMloPsvKbBoj5NYJLurunvh20b8JZujuWcBv6FP6Zc2NsFshxeXSVBmsuGt0NUvuECqfEGHLw77KUFmCgrfLyGSDToLagbiR7kdc65NHVrrudHi+3RYrRls/5vrr6DC9ooLsYh7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When MREMAP_FIXED moves a range spanning multiple VMAs, remap_move()
iterates over the source VMAs and skips source holes.  For each source
VMA segment it narrows vrm->new_len to that segment length before calling
mremap_to(), so the MREMAP_FIXED destination unmap is also limited to the
current segment.

If the source range contains holes and the destination range is already
mapped, the destination subranges corresponding to those source holes can
therefore survive the move.  That violates MREMAP_FIXED semantics, where
the destination range is supposed to be unmapped before the move, and it
also means that preserved source gaps do not necessarily become gaps in
the destination.  Userspace can then observe mappings at destination
addresses that should have become holes.

Unmap the full fixed target range once before moving the first source
segment in the multi-VMA move path.  Split mremap_to() into a wrapper that
performs the MREMAP_FIXED target unmap and a lower-level __mremap_to()
helper that assumes any required target unmap has already been handled.
Then the multi-VMA path can call __mremap_to() after clearing the full
fixed target, while the single-VMA path continues to use mremap_to().

Use a common unmap_fixed_target() helper for both the ordinary mremap_to()
target unmap and the full-range target unmap.  This keeps the existing
iterator invalidation and source VMA reload behaviour in one place.  The
full target unmap still uses the existing uf_unmap_early path for
userfaultfd unmap notifications.

Extend the multi-VMA mremap selftest to check that the destination pages
corresponding to source holes are unmapped after mremap().  This covers
both MREMAP_FIXED and MREMAP_FIXED |
MREMAP_DONTUNMAP.

Fixes: d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs")
Cc: stable@vger.kernel.org # 6.17+
Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/mremap.c                              | 92 +++++++++++++++++-------
 tools/testing/selftests/mm/mremap_test.c | 52 ++++++++++++++
 2 files changed, 118 insertions(+), 26 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index e9c8b1d05832..e91fff2ba3ce 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1430,37 +1430,39 @@ static unsigned long shrink_vma(struct vma_remap_struct *vrm,
 	return 0;
 }
 
+static unsigned long unmap_fixed_target(struct vma_remap_struct *vrm,
+					unsigned long addr, unsigned long len)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long err;
+
+	err = do_munmap(mm, addr, len, vrm->uf_unmap_early);
+	vrm->vma = NULL; /* Invalidated. */
+	vrm->vmi_needs_invalidate = true;
+	if (err)
+		return err;
+
+	/*
+	 * If we remap a portion of a VMA elsewhere in the same VMA, this can
+	 * invalidate the old VMA. Reset.
+	 */
+	vrm->vma = vma_lookup(mm, vrm->addr);
+	if (!vrm->vma)
+		return -EFAULT;
+
+	return 0;
+}
+
 /*
- * mremap_to() - remap a vma to a new location.
+ * __mremap_to() - remap a vma to a new location, assuming any required
+ * MREMAP_FIXED target unmap has already been handled.
  * Returns: The new address of the vma or an error.
  */
-static unsigned long mremap_to(struct vma_remap_struct *vrm)
+static unsigned long __mremap_to(struct vma_remap_struct *vrm)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long err;
 
-	if (vrm->flags & MREMAP_FIXED) {
-		/*
-		 * In mremap_to().
-		 * VMA is moved to dst address, and munmap dst first.
-		 * do_munmap will check if dst is sealed.
-		 */
-		err = do_munmap(mm, vrm->new_addr, vrm->new_len,
-				vrm->uf_unmap_early);
-		vrm->vma = NULL; /* Invalidated. */
-		vrm->vmi_needs_invalidate = true;
-		if (err)
-			return err;
-
-		/*
-		 * If we remap a portion of a VMA elsewhere in the same VMA,
-		 * this can invalidate the old VMA. Reset.
-		 */
-		vrm->vma = vma_lookup(mm, vrm->addr);
-		if (!vrm->vma)
-			return -EFAULT;
-	}
-
 	if (vrm->remap_type == MREMAP_SHRINK) {
 		err = shrink_vma(vrm, /* drop_lock= */false);
 		if (err)
@@ -1486,6 +1488,23 @@ static unsigned long mremap_to(struct vma_remap_struct *vrm)
 	return move_vma(vrm);
 }
 
+/*
+ * mremap_to() - remap a vma to a new location.
+ * Returns: The new address of the vma or an error.
+ */
+static unsigned long mremap_to(struct vma_remap_struct *vrm)
+{
+	unsigned long err;
+
+	if (vrm->flags & MREMAP_FIXED) {
+		err = unmap_fixed_target(vrm, vrm->new_addr, vrm->new_len);
+		if (err)
+			return err;
+	}
+
+	return __mremap_to(vrm);
+}
+
 static int vma_expandable(struct vm_area_struct *vma, unsigned long delta)
 {
 	unsigned long end = vma->vm_end + delta;
@@ -1882,9 +1901,11 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
 	unsigned long start = vrm->addr;
 	unsigned long end = vrm->addr + vrm->old_len;
 	unsigned long new_addr = vrm->new_addr;
+	unsigned long new_len = vrm->new_len;
 	unsigned long target_addr = new_addr;
 	unsigned long res = -EFAULT;
 	unsigned long last_end;
+	bool fixed_target_unmapped = false;
 	bool seen_vma = false;
 
 	VMA_ITERATOR(vmi, current->mm, start);
@@ -1939,8 +1960,27 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
 		}
 
 		res_vma = check_prep_vma(vrm);
-		if (!res_vma)
-			res_vma = mremap_to(vrm);
+		/*
+		 * remap_move() narrows vrm->new_len to the current source VMA
+		 * segment before calling mremap_to(). For sparse source ranges
+		 * this would leave target ranges corresponding to source holes
+		 * mapped.
+		 *
+		 * If the requested source range extends beyond the first VMA,
+		 * unmap the full fixed target range once, using the original
+		 * new_addr/new_len, before moving any segment.
+		 */
+		if (!res_vma && !seen_vma && vma->vm_end < end) {
+			res_vma = unmap_fixed_target(vrm, new_addr, new_len);
+			if (!res_vma)
+				fixed_target_unmapped = true;
+		}
+		if (!res_vma) {
+			if (fixed_target_unmapped)
+				res_vma = __mremap_to(vrm);
+			else
+				res_vma = mremap_to(vrm);
+		}
 		if (IS_ERR_VALUE(res_vma))
 			return res_vma;
 
diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 308576437228..ebbe1aa42ef0 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -419,6 +419,54 @@ static bool is_multiple_vma_range_ok(unsigned int pattern_seed,
 	return true;
 }
 
+static bool is_range_unmapped(void *addr, size_t size)
+{
+	void *ptr;
+
+	ptr = mmap(addr, size, PROT_NONE,
+		   MAP_PRIVATE | MAP_ANON | MAP_FIXED_NOREPLACE, -1, 0);
+	if (ptr == MAP_FAILED) {
+		if (errno == EEXIST)
+			ksft_print_msg("range %p-%p is still mapped\n",
+				       addr, (char *)addr + size);
+		else
+			perror("mmap MAP_FIXED_NOREPLACE");
+		return false;
+	}
+
+	if (ptr != addr) {
+		ksft_print_msg("mmap MAP_FIXED_NOREPLACE returned %p, expected %p\n",
+			       ptr, addr);
+		munmap(ptr, size);
+		return false;
+	}
+
+	if (munmap(ptr, size)) {
+		perror("munmap MAP_FIXED_NOREPLACE probe");
+		return false;
+	}
+
+	return true;
+}
+
+static bool multiple_vma_holes_unmapped(char *ptr, unsigned long page_size)
+{
+	static const int holes[] = { 1, 3, 7, 9 };
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(holes); i++) {
+		char *addr = &ptr[holes[i] * page_size];
+
+		if (!is_range_unmapped(addr, page_size)) {
+			ksft_print_msg("target hole page %d is mapped\n",
+				       holes[i]);
+			return false;
+		}
+	}
+
+	return true;
+}
+
 static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 				      unsigned long page_size,
 				      bool dont_unmap)
@@ -529,6 +577,10 @@ static void mremap_move_multiple_vmas(unsigned int pattern_seed,
 		success = false;
 		goto out_unmap;
 	}
+	if (!multiple_vma_holes_unmapped(tgt_ptr, page_size)) {
+		success = false;
+		goto out_unmap;
+	}
 
 out_unmap:
 	if (munmap(tgt_ptr, 2 * size))

base-commit: 1b55f8358e35a67bf3969339ea7b86988af92f66
-- 
2.34.1


