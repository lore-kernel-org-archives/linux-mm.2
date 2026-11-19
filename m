Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 028B960A2601
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 19:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=M0wa/rBm
Received: by kanga.kvack.org (Postfix)
	id E27636B0681; Thu, 19 Nov 2026 14:22:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8AA6B0692; Thu, 19 Nov 2026 14:22:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7676B0693; Thu, 19 Nov 2026 14:22:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A926F6B0681
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:22:29 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4679DA89E6
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:22:29 +0000 (UTC)
X-FDA: 85452840018.12.FDDF670
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	by imf20.hostedemail.com (Postfix) with ESMTP id F21981C001A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:22:11 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795116132;
	b=IEXW3DxCGM+x1dfbYBrHShN24VAdC8AijO3Ls75w4a7iBaH6/XwvOOe+HoCUmfhkRR+qCa
	FamTtuAtBn8buDxt9WQsGiQAlRIOFVHvnKBMTBBGjU/QbMsZgykvtum5UNTKU3sr0wrg7u
	mZjlNpsYtS/E7K+qwuZWO8zeRq+XKEw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795116132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2ANqiizTAscXP4+/g+gxIaFQ07HRmFDK7ucjfLUofJc=;
	b=Q7qLrhaJeCSxFjX8/DDu0UTQfT/KVc0qq4vCXZr3C7+hju6NPyVv/exPsT4LMrTfVkLD3j
	NNyskhn3qZ6mhCpV2FhfPXe1H+xF/4DNQoJEScyf9IrYXnLrdUCvoIOzayZqGDthfMSS4/
	Y7ZBEdZfvIWpn5qtKQ9EQtYn0uryIWs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="M0wa/rBm";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3Ykz_agQKCFc2BC95DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--dmnk.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3Ykz_agQKCFc2BC95DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--dmnk.bounces.google.com
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a1f03f2e8aso370805e9.1
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795116130; x=1795720930; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2ANqiizTAscXP4+/g+gxIaFQ07HRmFDK7ucjfLUofJc=;
        b=M0wa/rBmmTjnGVpY64v5ufBbg4EpUDVJ3HDEc0yn+MR28+PeB/t9JeShHCdvdlB4QZ
         icDVDUXFcf/P+SxaRLAoShq96ti/7+9hymGBAeYloD6/R33+kpdwWII1m027SA+MhYUV
         Z4fLcXA/kAY5hvKiJpepv+F1JtU52r0Zu3QMiTcOXsP5GmZwcJX6ECpeEfJ92DGmjRGr
         6lK7Y/TgFl2odPGnkcX8wG1gHzaDkT1YyUskeLSy0ih5Y4WzhCEdkc+Hw4uq30BOv1Hl
         w/u4ZXtQhMai/m0tCYuBZ1Vqs7vV3LECUo2C0SgWM4E+ZffkYV1DgQXiLJI6dY90eEU1
         3tPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795116130; x=1795720930;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2ANqiizTAscXP4+/g+gxIaFQ07HRmFDK7ucjfLUofJc=;
        b=pA8VsPB0Z3+WoQIs6mbCbMQzOuaU667ogTzJKGQzReYZPCCyXOOr1MJpikdMhfTsVZ
         HqrT1Mu+q3lCinr1CZrJeyVqvyz1BeVtd8n1ZwFccGlvKBS9UeTFvnHURtnFzT4QE5/D
         6rSWYv9tmYH/FZGVg69JA+FlZE0rHiOGd2o2MNz+cMi9kVtFLShmAl49lSBGXvkbDee0
         aPA1vvMlIuNkyWN23tEoXFcJM4iywSqw4q1afaN1OgGJNPn6B1sBwQf80kPR77oqjhGM
         SVDrnKKZaiC9WRR+yCg33ZI6ikcWBXn6EdewL0TSjjFFM5ucyQwADfedyj5NP/nrqQya
         A3tw==
X-Forwarded-Encrypted: i=1; AL+hErH4c3ZjUhBcmGQg7ZiZ38mHCNWgKn2+ImRaSCNDj0F5lX8L3lkDx2Wj0M3JDrgMcvqMj0/VZpshnA==@kvack.org
X-Gm-Message-State: APuU4Z/efDvx4jjlNLga0MYZ68TaBeG0T0C9uAJKfEIdt/h9SrjCAYcx
	vDo4th/618ZRzSuuL9SR25ljaI692dHujowQ2KQiAhG3DXcW5OCFOqN6WQ5ZK1hreQlBT+pMJA=
	=
X-Received: from wrul11.prod.google.com ([2002:a5d:668b:0:b0:4a3:5c5b:309f])
 (user=dmnk job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6749:b0:4a2:1867:10e8
 with SMTP id 5b1f17b1804b1-4bb8881a294mr12043615e9.25.1795116130200; Thu, 19
 Nov 2026 11:22:10 -0800 (PST)
Date: Thu, 19 Nov 2026 20:22:09 +0100
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119192209.2651562-1-dmnk@google.com>
Subject: [PATCH] hugetlbfs: respect F_SEAL_GROW and FMODE_WRITE before growing
 i_size in mmap
From: Dominik Maier <dmnk@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, dmnk+artist@google.com, 
	Dominik Maier <dmnk@google.com>
Content-Type: text/plain; charset="UTF-8"
X-HE-Tag: 1795116131-217853
X-HE-Meta: U2FsdGVkX1+J5idIc/zKqx9GlovUztwSwS+SbBandiwtsXTDeC/7KD3eba5YY4eSiMbh5y24tuZ8kbeCRUwxCsNIsrCqb+bcKll3pgJfxHVnNH2R+55IvE4AXpNbBzFGSLiJ97Cquw1qnRPHBvM4+PhmjC3v36LQNub9Bn/JrcZmoJTLTirMCKQYzHpklNJknW1MLG7K2T/StO/qJXR7AyHtaWxh18fa7N4fs82zvDaP1ixwIxy3iRHVhnwFcv7vTcay6dJJ14rozF8+94CB0nJ1ya1DU7ycLRU1rqZfk4Y9Ou/M5dq4aPazwXtxTR+/DL2J9I9T23Cp7UmtL28vPIhTlzZYQ50GiKQhi0BNjEIsWdXtPjiX+zugOifb8mH2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hugetlbfs_file_mmap() expands inode->i_size whenever VMA_WRITE_BIT is set
and len > inode->i_size, without checking whether a shared mapping
violates F_SEAL_GROW or inode_newsize_ok(), or whether a private mapping
holds write access to the underlying file and has no active write/growth
seals.

Because do_mmap() and memfd_check_seals_mmap() allow PROT_WRITE with
MAP_PRIVATE | MAP_NORESERVE on O_RDONLY descriptors and sealed
MFD_HUGETLB memfds, an untrusted IPC recipient holding a read-only or
F_SEAL_GROW-sealed hugetlb descriptor can inflate the shared
inode->i_size to multi-terabyte values even when vm.nr_hugepages is 0,
causing trusted peers relying on F_SEAL_GROW to hit SIGBUS past the
allocated pages. Similarly, MAP_SHARED | PROT_WRITE beyond i_size on an
F_SEAL_GROW memfd (without F_SEAL_WRITE) bypasses the growth seal.

For MAP_SHARED | PROT_WRITE mappings with len > inode->i_size, reject
F_SEAL_GROW with -EPERM and enforce inode_newsize_ok() before reserving
huge pages. For MAP_PRIVATE | PROT_WRITE mappings, keep allowing the
private VMA itself while only expanding inode->i_size when FMODE_WRITE
is set, no growth/write seals are active, and inode_newsize_ok()
succeeds.

This issue was discovered with an AI-assisted code review tool (ARTIST)
and reproduced in QEMU/KVM on an unmodified v7.4-rc3 kernel without
kernel modifications or error injection; a standalone reproducer is
available upon maintainers' request. The fix was verified against the
reproducer in QEMU/KVM, compile-tested with -Werror, and checked with
checkpatch.pl --strict.

Fixes: ff62a3421044 ("hugetlb: implement memfd sealing")
Fixes: 045c7a3f53d9 ("hugetlbfs: fix offset overflow in hugetlbfs mmap")
Cc: stable@vger.kernel.org
Signed-off-by: Dominik Maier <dmnk@google.com>
---
 fs/hugetlbfs/inode.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 02e0a65..de416fc 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -100,10 +100,12 @@ static const struct fs_parameter_spec hugetlb_fs_parameters[] = {
 static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct inode *inode = file_inode(file);
+	struct hugetlbfs_inode_info *info = HUGETLBFS_I(inode);
 	loff_t len, vma_len;
 	int ret;
 	struct hstate *h = hstate_file(file);
 	vma_flags_t vma_flags;
+	bool grow_inode = false;
 
 	/*
 	 * vma address alignment (but not the pgoff alignment) has
@@ -139,6 +141,24 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	inode_lock(inode);
 	file_accessed(file);
 
+	if (vma_test(vma, VMA_WRITE_BIT) && inode->i_size < len) {
+		if (vma_test(vma, VMA_SHARED_BIT)) {
+			if (info->seals & F_SEAL_GROW) {
+				ret = -EPERM;
+				goto out;
+			}
+			ret = inode_newsize_ok(inode, len);
+			if (ret)
+				goto out;
+			grow_inode = true;
+		} else if ((file->f_mode & FMODE_WRITE) &&
+			   !(info->seals & (F_SEAL_GROW | F_SEAL_WRITE |
+					    F_SEAL_FUTURE_WRITE)) &&
+			   !inode_newsize_ok(inode, len)) {
+			grow_inode = true;
+		}
+	}
+
 	ret = -ENOMEM;
 
 	vma_flags = vma->flags;
@@ -157,7 +177,7 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 		goto out;
 
 	ret = 0;
-	if (vma_test(vma, VMA_WRITE_BIT) && inode->i_size < len)
+	if (grow_inode)
 		i_size_write(inode, len);
 out:
 	inode_unlock(inode);
-- 
2.56.1.750.gf70dc682cf-goog


