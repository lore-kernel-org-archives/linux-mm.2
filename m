Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE0FCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 11:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5190D8E000E; Mon, 10 Nov 2025 06:16:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0CC8E0002; Mon, 10 Nov 2025 06:16:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4061E8E000E; Mon, 10 Nov 2025 06:16:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1F38E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:16:11 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B1E7E4CAFE
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:16:10 +0000 (UTC)
X-FDA: 84094443300.24.12DB6CB
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id D74AEC000C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:16:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762773369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=oRSXEGDPXpNtVK5+kTNlEj4aQG5TyKfDyS+DDaGalzc=;
	b=Upc8xZqi38zQqxuytfD0lwjjQuCRUTVYEU/bikK+fdUgcPFH0tC/tLsOh9zYTAxX6ZjURn
	C6y7BdZxYgd3aD8NA/3BbW0mZaDRSux7uYksW/cLu5UaqeZkxY6+7Cz5AoEShctc+HlE1D
	DCCy85OPVJf4PqwuiupZkxbVS+d1niI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762773369; a=rsa-sha256;
	cv=none;
	b=UHrf8vDXl9Hh+4P6rf+eUJX4yELc98yzTDrQU8g8jYLiA42DRUV6LVEGnxITAW3SXjyX6X
	LuUNKUFWFz67Lp0lPmJs9iFlnaCwtC9zV9YvOlFVP+dQZURwpHPBa45AwVdUqCtlb+2Xjk
	QzNlVSZlQDggNSkxnpOC9ucLTzGqfi0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-340ba29d518so1795165a91.3
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 03:16:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762773368; x=1763378168;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oRSXEGDPXpNtVK5+kTNlEj4aQG5TyKfDyS+DDaGalzc=;
        b=LqKTCfSyMhD2eO5nn418PSvi9Q/z2OUz7QGyjgSSzhRm0EcbeavxYGvH8zgn29agEw
         J2Fe8kqV2T99ZfQ2wxEl3ZWqos330Ayppxz/BJmteKuDn04iq+sXVh0z/U1SD15EPPXI
         zM0OfEdZ6zHLpYtWEDN7xIl9UKm8Mq09ZWg3ZnVY2xtSjtZwjlhjMXue8J7NCRJpYWp+
         /jIQ28oAJPOkWha40RSrj7dZleAtdspzaJuzVOOH7UIhAqfVsFsj/7voSxx9XM1lPcEV
         1KP+bDIJmEXFgMeUiQxsGDmxvNCXKzzdfy6l8yUr9GUEeJBvw5FdFJmah8H9jvb3zU8n
         Bxmg==
X-Forwarded-Encrypted: i=1; AJvYcCUGZpgE4L4v6cSCkX7igVibzKlDaR4/stC75reScVBGcIqxF0ODpJQrVAiye1sZlzMHxNj1MdR2oQ==@kvack.org
X-Gm-Message-State: AOJu0YzYObe0Lx857U9mdfN+f2bj9d1mpSgv1InjoxS8fwIT8Kmp/JSu
	78PYSkDxHSqhdHl5570irSD+DqcaF3XNI4OXAZdAkWVpkMvcgXms7Ccc
X-Gm-Gg: ASbGncsT2E6lhrdYjSolBFXnrLD8V6QW7VNK0bP3ozPHZh5dDhVsSfGQ6KjSmaMRuch
	W1nvXhvOeWrZYqpbGPSzCVT9obNKhcCtU0PqdQWa5+jqg/GmAC9GAjSDrIeEMzISUOTvi8rn1d9
	5KYt99DS47hJG9I/a+2DSgbv+2vt4TC36J82BOycgXaaZzxe7qbe9WHxw4k6PNL/z+0z09cdq9d
	AsAHUqT/AA7qJ6MtJ4rchcGMC18v7pXg+Py782Wjnlrpd9z7lPDzR+Dtlp6ZWzVs+p/PMMhtnDd
	Z5maAMgcv6/3GJWnEONNvFE93xDBI3ayNFKtcee1VMMW+mi43vOiaUQUclOsGdg5h+uZijtB7S+
	T5dD2JNqjBn+6t1L5qVqXfYytNZUAnbimexeeEU/sBCjXpMbKsuzSHstPVyCCU5on3wI0leaQFC
	bgwPk44ik=
X-Google-Smtp-Source: AGHT+IFmx5F0C1FFfC1T3kTAEofW5SYHF07alyTgfqPESgG9ejsnGcr8FXW/IACqi7z7O6oK12Ycjg==
X-Received: by 2002:a17:90b:1f8e:b0:33e:2934:6e11 with SMTP id 98e67ed59e1d1-3436cb898dcmr10302982a91.11.1762773367674;
        Mon, 10 Nov 2025 03:16:07 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([2403:2c80:17::10:4006])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bad33c801d1sm8989478a12.7.2025.11.10.03.16.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 10 Nov 2025 03:16:06 -0800 (PST)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: syzbot+3f5f9a0d292454409ca6@syzkaller.appspotmail.com,
	syzbot+ci5a676d3d210999ee@syzkaller.appspotmail.com,
	david@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	syzkaller-bugs@googlegroups.com,
	syzbot@lists.linux.dev,
	syzbot@syzkaller.appspotmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v2 1/1] mm/hugetlb: fix possible deadlocks in hugetlb VMA unmap paths
Date: Mon, 10 Nov 2025 19:15:53 +0800
Message-ID: <20251110111553.88384-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D74AEC000C
X-Stat-Signature: qxiugrmn66coqd6qd8edphi669byqsgf
X-Rspam-User: 
X-HE-Tag: 1762773368-172842
X-HE-Meta: U2FsdGVkX19LLDgzGpNNqi3cDvpVH8AT2E6AtUZaPrFeeQ8agKAljdLGUngcBCPM/iYqBP3Ta5dj7+dRE6R92NxPugrMjx2+RyEutZTavM4VuZswbjaUgUV4dwXXMeXajMA8oEYbyHAxi+CdDNg+rqeYxsUdfUPP6rgBxchq9PCLNhz0V4SMh0WwpAA/CNYe8cEhM1vMAtYLeDj8kKdvbkguL6sOFUNcMNETS0aB/VTtiYDldmyHmV1ZYn1+ODSsyzcbAtLtjRHuGOXqKinNuINz6NecFlP99Lh6af3qBTrcUiT5R57/w0VWJTdnYubmt/8IqqyS1Hu7+Yp7AXycTD/dzCk8tA9Ce/i9cwikdt6P2iJCGAnHde5hdAAr1OgYfq/tO4PvT1r73NxXY1n4kaWcAfkbmcX1qRi1BhPxs7XSer50nfxJTV8YfLwzmtlFhDLBIO8LUpU6qZpk3JrfMMTfCMOwDmGB4EuP57ew79Lze9KF4QTcf9wiSC7lF5jkcmhqeX9niC9ty/fR2/rqeg/EiqPFYphoERx0gCvtveYFa71QYy5mGWQhhpkTNmgeP7j+1ppNjAqgtZXzPqafPZYz12qGgm8wYqGxSN8fEqZyBNoinous4QGTNU7Wx6TUkWfzMQRrI040VObQ4FmSFegY6dgapU3pbwMOlLBw2WXI0g7mrPJy4KAZ3YqWBIblcSbhExE3PkmJmMc91vg20k8vT4vtkZPiLmcqs3+6hABCJkWu0TiSnGMPRKOUTJmagLoly59ETlAyoFNIeZEfnV6C05ud0NOOfitd/+ldhH4n4YM1VD4MYivvN2MFfUU0KWuLzE0Td0XfKRpEnqpz65VUXF+H/p0Vy7tENr16ZNSuaa9ZBPxejVIDbTBZ+hyAgZwfQFr9h9EBaL4gBUNPEFsf98zusZqUuRYVFPqciJAyKJN9E1zNKsyJm5C9L8lEiUabtOnNmjnEO+PbVDy
 SckNdmFd
 2tnlekCVhT/i33LgQhynIDUxDgcjbpDU+QFNQ4dlSvRKqMtfz7T6CbTAkpDtE6L9x1sUCeBtUP6MefB+XPXtjpBA5D9fReDpvZdcUFFH68u4JWzc3MJb2OZWpD8r8T7THDjQr62pObv4MU1wTHyzyvohL4E7/WNzE+b774iUyThSbkeXMTWnPj0LI8zCWstKlU52FhxfK8/ou9TmcqMdz3Gw4huKXwn/FKogYGui8GRy/f9srOdZbFMOgkOi9xPlTlX5vMCkSAmEpPnVdKBsbrGN1WVlRajFgcVmXbTK6oOlPS3HpD+n7ShsBH9QT0XslIHDcCwKu33CjrhGnUJpa2347msWuiEjI8RCCaHjTSyDqEwXG/Yz2h0DBnX2kcYxtSinMxAi7LCESGAaQ7Ea+pwcpJfAdi9SAqFfGNFgMN1LBdwAge+VwIzUgW10TuujS9rF474/NMCEe457Or8jm2/iiu9x8JRWtozq/Rdf8bQE19tzh7KhlsWkOH+F+jnz8qj5xk8LJiLC3RenmV6fC9IYdOE651LlckaBlitzClzYmuv5tGP2tBlqRaerrZYB8RCsbB8ABPZe19S2YofOrAEyqOyimZBz0ZZ2kSg5znC+w4+vAt06dYzrYUM+NonOonr0XpTvIqYc4vOg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

The hugetlb VMA unmap path contains several potential deadlocks, as
reported by syzbot. These deadlocks occur in __hugetlb_zap_begin(),
move_hugetlb_page_tables(), and the retry path of
hugetlb_unmap_file_folio() (affecting remove_inode_hugepages() and
unmap_vmas()), where vma_lock is acquired before i_mmap_lock. This lock
ordering conflicts with other paths like hugetlb_fault(), which establish
the correct dependency as i_mmap_lock -> vma_lock.

Possible unsafe locking scenario:

CPU0                                 CPU1
----                                 ----
lock(&vma_lock->rw_sema);
                                     lock(&i_mmap_lock);
                                     lock(&vma_lock->rw_sema);
lock(&i_mmap_lock);

Resolve the circular dependencies reported by syzbot across multiple call
chains by reordering the locks in all conflicting paths to consistently
follow the established i_mmap_lock -> vma_lock order.

Reported-by: syzbot+3f5f9a0d292454409ca6@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/69113a97.a70a0220.22f260.00ca.GAE@google.com/
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
V1 -> V2:
  - Update changelog
  - Resolve three related deadlock scenarios reported by syzbot
    https://lore.kernel.org/linux-mm/6911ad38.a70a0220.22f260.00dc.GAE@google.com/
  - https://lore.kernel.org/linux-mm/20251110051421.29436-1-lance.yang@linux.dev/

 fs/hugetlbfs/inode.c | 2 +-
 mm/hugetlb.c         | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3919fca56553..d1b0b5346728 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -447,8 +447,8 @@ static void hugetlb_unmap_file_folio(struct hstate *h,
 		 * a reference.  We must 'open code' vma locking as we do
 		 * not know if vma_lock is still attached to vma.
 		 */
-		down_write(&vma_lock->rw_sema);
 		i_mmap_lock_write(mapping);
+		down_write(&vma_lock->rw_sema);
 
 		vma = vma_lock->vma;
 		if (!vma) {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b1f47b87ae65..f0212d2579f6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5110,8 +5110,8 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 	mmu_notifier_invalidate_range_start(&range);
 	last_addr_mask = hugetlb_mask_last_page(h);
 	/* Prevent race with file truncation */
-	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(mapping);
+	hugetlb_vma_lock_write(vma);
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
 		src_pte = hugetlb_walk(vma, old_addr, sz);
 		if (!src_pte) {
@@ -5327,9 +5327,9 @@ void __hugetlb_zap_begin(struct vm_area_struct *vma,
 		return;
 
 	adjust_range_if_pmd_sharing_possible(vma, start, end);
-	hugetlb_vma_lock_write(vma);
 	if (vma->vm_file)
 		i_mmap_lock_write(vma->vm_file->f_mapping);
+	hugetlb_vma_lock_write(vma);
 }
 
 void __hugetlb_zap_end(struct vm_area_struct *vma,
-- 
2.49.0


