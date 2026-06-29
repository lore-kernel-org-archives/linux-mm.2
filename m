Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26F43C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E01A66B00F8; Mon, 29 Jun 2026 14:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2A26B00FB; Mon, 29 Jun 2026 14:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEEAC6B00FC; Mon, 29 Jun 2026 14:05:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A66C76B00F8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:05:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4CF12A0228
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:05:18 +0000 (UTC)
X-FDA: 84933727116.16.56C52EA
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf22.hostedemail.com (Postfix) with ESMTP id C2A18C0004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:05:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=o9sVhhSN;
	spf=pass (imf22.hostedemail.com: domain of eva.kurchatova@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=eva.kurchatova@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782756316;
	b=m4LT9dBbTklsvwc5Lxw9RYsr1Ovxx2CsgIoixQpVMRxflMR9Dih2FU8sv+O9sfS9gD0Dq0
	Vyly1ovQflpP1U5xK+/D+vb76fjWSuvrrdjakgMoYU4gGEVpT8Wv7n9K1HJNCPY8+XzwvW
	fXZ+SPHWZo2EoY6lpxmZTX15OSBzh6I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782756316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Xw7+7GTSEIFgzQjEp9Tkxqy60zlA62aEgnD/nFgBypQ=;
	b=BynhEFTvBrU2L/S24XDBSpdjjzdqdHCUGDz5NlDdI7fGlATejdCGIoW9ZwBCvV9RNlxg0X
	SBfFYHglny3wt5JuGfwse/Tpuuv0bvy8JzJY0whjJ5N4rQxfSJYT5agE0VlL+gd+8R/8Zq
	K/3lY90R4DHFiztqNgruASLjR16Y+O8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=o9sVhhSN;
	spf=pass (imf22.hostedemail.com: domain of eva.kurchatova@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=eva.kurchatova@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=MIME-Version:Message-ID:Date:Subject:From:
	Content-Type; bh=Xw7+7GTSEIFgzQjEp9Tkxqy60zlA62aEgnD/nFgBypQ=; b=o9sVhhSNhQ5h
	VCSwzB39fjU2NUINsUichjlgh2RsmfuNptO0t/1d6evQqKoVnZttv9zXdOA6wlyWIc14loaFwruwE
	nG74qSb8h6ACv6L8KlNUwpAwcYDpRUUELtctPK5sC7jPB2ZIBr1aqzBfb9X3pUYeJyWgznUGqj6MU
	9QVeN+TLeUNQ3wkmjkZCtNRHUhYGG7XFsP7OhP+gKYbV4a+OkBHOGplqEBa8wtW6/ggWNCmY0+vB+
	YyJj6pxAN1QtndwewfiGfL5AEAx0Tv+fGIEKVHT1Jm7wOk0LIGrgNJrm+OJLrk6Nq/YZGeKUIcX+P
	KF9wS0JJRaU5RRB6YG+Bog==;
Received: from ch-vpn.virtuozzo.com ([130.117.225.6] helo=LekKit-T14)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <eva.kurchatova@virtuozzo.com>)
	id 1weGL7-0048be-11;
	Mon, 29 Jun 2026 20:04:55 +0200
From: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Eva Kurchatova <eva.kurchatova@virtuozzo.com>,
	linux-mm@kvack.org
Subject: [PATCH] hugetlbfs: enforce F_SEAL_EXEC in setattr
Date: Mon, 29 Jun 2026 21:02:46 +0300
Message-ID: <20260629180247.2343229-1-eva.kurchatova@virtuozzo.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C2A18C0004
X-Stat-Signature: wumzxeczuuqfzw3wgj4euz1gee8jscud
X-HE-Tag: 1782756316-883627
X-HE-Meta: U2FsdGVkX1/GTYrIAFEsj4sGiKXdDvETwV8OegIOZR2tTl8PysLcp99fxR9TK8tkfyna9LKOwXaLdcryifgMAQu0DglCrHSVCgGbfrvRvmPru52d9O+bfHji15/INX/GIxUW6EJbIg5at/rGcypZEjxCU09KBRx3hyA1nuiLFfrS3G2ZHnyKrK+KH46Cing06x1tmP5AIbe4RretuUgkARUHi2xAH5MCyVhmVA4MtfqFGA0FDc/O80awbBGKg+/RY8uOsmeOTwwqlvM2byATDMlzdUrZRyIRQifl0dob5mr4TFXGs8fSXrBwMad8Rn2tHs8OUX/y06kunYFRQxAvSW2k0PXywy0ahiI8XaKRjxseYmCFtmJFb3MCP4Ewes9Sx7dIPjxpafrqTt35RB8d2+iIZnfYGJlPV8iwJO28Jsd5fGji80GAzcyzs/m5hw8scZQ6mLRd4FRi/Wmgqpsx+v/YVEBXyF7SNSKyTrZvJNcW4Q8yc02jLnG1zRYafBcLpXrgNFHEQAweGs9oWJA9xlwucAY3EUp5PUc/rw7epNoSPaQhzhwcSdMD/BOq4/5x3JG/nswDsQGmurl11/xBPYMiN5D9kOCY4ySEZsX5bVqozJ9Ts5YBxLuhS+jpgqhdFuVcBxv4kZYClWTq6yaDUPK80ZCmBA0dg6FP/sOKWuh5uxafq+itXN1Z0Y5Rf90vd+TO6ZJ2V//XWSQU30Esc6VuTB85E30LObDgt7/ZEg4Ne82AKo2yI8C62XOsUMcGKnv5aMw6MagUxDJ31DxJspluzIgg67dH3vHJ+f/z5hIOFkVAUrGScp7WtqADdnkzyv4QlHYCc6E9agoogmT2MYvki6G7bYWzErcpXMVPiVlvfExyfEoj4wU8VI+QoIz3zwd8FALNnrPFZ8t/SqN0PvqjYpSBDalxERgfU6QPLOjlUuOsaVTUgv4iZHK3X9fsaqqlDm+Fojg5LGhIEeJ
 KKcvpwP8
 sUscnC/GgnHkZB/bEx7GWTpeFuCW/EQhnGAscT2SO920tost1SPs7xG+/4qc6EMbaDpUAy3Mkwy9hWF/ICQyX8xKrlcB0g+JYgD1eIv1mm8zyu4FD78fnZ6U/uzZnS26rr5UG4kG1eOwpSei69woGO1mMvviydCNeVBXLJ5k/ErNwhAJ46B7fU3fm5J6JytnWfvm/oNmr6AZWyDU1papB4eMu87PkCDN9ThdEFyuFgyPtIlNW0T8/psYxPar7F1QccFfnSkn71evWJLplQBYhX49GUONtdCFrMfjygpOF51SqVF3yItp3p9AqUgprPuMMxBt1nzj+1PT6+zSXahHMOCzxBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 6fd735518263 ('mm/memfd: add F_SEAL_EXEC') added the F_SEAL_EXEC
seal to memfd, with the corresponding enforcement implemented in
shmem_setattr(): once F_SEAL_EXEC is set, fchmod() of any of the execute
bits (S_IXUSR|S_IXGRP|S_IXOTH) is rejected with -EPERM.

The hugetlbfs equivalent in hugetlbfs_setattr() was missed, even though
hugetlbfs memfd files carry the same 'info->seals' bitmap and the same
F_SEAL_EXEC bit can be added through memfd_create(... MFD_HUGETLB ...)
plus fcntl(F_ADD_SEALS, F_SEAL_EXEC). As a result, the seal is silently
ignored on hugetlbfs memfds and fchmod() may turn execute bits back on
after the seal has been applied.

Mirror the shmem check in hugetlbfs_setattr() so that ATTR_MODE changes
that flip any execute bit on a sealed inode return -EPERM. This also
fixes the memfd_test 'hugetlbfs' SEAL-EXEC subtest, which previously
aborted on:

    fchmod(/memfd:kern_memfd_seal_exec (deleted), 00777) didn't fail as expected

Fixes: 6fd735518263 ("mm/memfd: add F_SEAL_EXEC")
Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
---
 fs/hugetlbfs/inode.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 216e1a0dd0b2..812bf8e21b91 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -841,6 +841,11 @@ static int hugetlbfs_setattr(struct mnt_idmap *idmap,
 	if (error)
 		return error;
 
+	if ((info->seals & F_SEAL_EXEC) && (ia_valid & ATTR_MODE)) {
+		if ((inode->i_mode ^ attr->ia_mode) & 0111)
+			return -EPERM;
+	}
+
 	trace_hugetlbfs_setattr(inode, dentry, attr);
 
 	if (ia_valid & ATTR_SIZE) {
-- 
2.54.0


