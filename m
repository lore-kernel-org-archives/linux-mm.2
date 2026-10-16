Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 454DDCCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 10:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16BB66B0088; Fri, 16 Oct 2026 06:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5AE6B008A; Fri, 16 Oct 2026 06:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFFF76B008C; Fri, 16 Oct 2026 06:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4F5C6B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:25:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86CCC1603DA
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:25:27 +0000 (UTC)
X-FDA: 85328107494.09.AAA1429
Received: from mail-43170.protonmail.ch (mail-43170.protonmail.ch [185.70.43.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6CF6540005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:25:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=T7r9Bx03;
	spf=pass (imf01.hostedemail.com: domain of nick@karaolidis.com designates 185.70.43.170 as permitted sender) smtp.mailfrom=nick@karaolidis.com;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792146326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=b04DOe8vmbq+QEfUbmjT3IlS1rtxforJbJCVtR4UErk=;
	b=krg9N+kGK4yF0PrOx5Anoa5R01dSuMgM56OlmZTxnGAdGZxmhVnxOgtc+VT6bPrStiXqYG
	d4/3193pX6qwfu21r7R5sAYD6Tqk+ADYPgMqHida2EO/b5/m73ha8Gz7e2t/GfxTzRVOo9
	yZrVWdZNfQuDnDZPVUC2eg6y6nuFHpk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=T7r9Bx03;
	spf=pass (imf01.hostedemail.com: domain of nick@karaolidis.com designates 185.70.43.170 as permitted sender) smtp.mailfrom=nick@karaolidis.com;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792146326;
	b=whZ9q60k90q4VkoNlHeGgypYHwHx8rQ8r6O0F2UwwjEQucddaHw+vUBbFCdSdmIwGN2il2
	YvFyArkSxTE3wtm2LzEPBvZPmtPDGL9j0AbG14vSZfF1v4deC0bdOOLESziDEOIx2AAEqq
	fu2+KQ8BGTwsoz57b0QFWF2jNfa1zB4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karaolidis.com;
	s=protonmail3; t=1792146321; x=1792405521;
	bh=b04DOe8vmbq+QEfUbmjT3IlS1rtxforJbJCVtR4UErk=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=T7r9Bx03kZ1obL008QSpYAKFDmkSk37XBbQHx4AvZCIaA9xbTeoEXhc/cB3SMlI57
	 MezU9GsTh0X2puV8/EOcBKYReV9Q0Si//bRYSnPbL1TcjaRYoTjnNgeVCaWCY1cVuK
	 i0NDQkC539QboKy9GsknWUco5yAc/uayQ+OUsRMiUt4AiZlP5C9ARhF+WYL/nmv81S
	 ZxQB5w17SwmyKQ1rAO3+8EVTWuE8LSrLytrXUjkwV3tKsFbCUSs8BIla7JbG1YM4+R
	 d4C2VMC8QarJWifr87HQrFiLP5Coy2SvrrGakMNysf0RdIurfMPUjvoU/kLVO04JQM
	 6rwEEXp/bHUpQ==
X-Pm-Submission-Id: 4j5h0F5p8Zz1DDKp
From: Nikolaos Karaolidis <nick@karaolidis.com>
To: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nikolaos Karaolidis <nick@karaolidis.com>,
	stable@vger.kernel.org
Subject: [PATCH] fs: rotate inodes whose page cache could not be dropped
Date: Fri, 16 Oct 2026 10:25:15 +0000
Message-ID: <20261016102515.111285-1-nick@karaolidis.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6CF6540005
X-Rspam-User: 
X-Stat-Signature: y7dsst6dizeajwn5b47wecsw6tqdhood
X-HE-Tag: 1792146325-444367
X-HE-Meta: U2FsdGVkX1/9eLIIr4ovFdxmtpgi20QniyeYyOnpsweD0LCP1ARzIgK+hJalHhbwuLD4ZHkNU0snKZoGCHd1sJ5MQrmSGE/q+d2D/2kNypSF9qRk4H1+Wzh4ZdyKnbaJfh7dLv53rSxYPgi57D9n0C2jIElb1VVpQKTG56Rl7lsuLERBP3QkHBWKUqqsmSaDp0FNmT/rD/FKyt5ep0qpvDLZ6o3ktVTLRvXdOeU6YLy+n35+8wXusabixLxVVDh8fadlumRsDx2DDK0fAbD+77Q8ipFwPvrBFItVeF3LPo6vmkLa9JLJeR7By2BgKb+yarFeVHOBbUwoaKflziS0zMTW/E3OQCeIcTaQly7KGM9l3T0U4dFD3lqwKX9TN7EdndwuizIQdT1aEEFlVJNwH9LA+c6E2SCx8k6cpwdACBoTZbcNGuKwigoajwr6FFSZfqV/7iqft5S7nv/UwhuP7pDLlaUhhxlyY9z72/mx4zlW1DsfPoWeIvetmMx8e4gAjwWZ36PzQVKPgnCbwE1jSwM8N7MfnN+7PO2DnWkXu3ML84y59nZm3wOzCi1lkpJQlN7GRoo5ZnpYZ8tXKi6Jki9F0LFMeRf1pNZKHNvNTiLALoVrHxbRE6sgDseRgvY/KGg9UZwQzAnexlzfj40V66JKmiiipU0kQNuUfb0PZxW6R9dC4L/jaBXLXq8w8VSwe6LoSCn+vy6HJFTPp3s5uCzFchyD7uXd5tHNH+aua0bcONerDDwUIMBB766RZxsiZ+rZGt5Xq44IWG5Gj2wAEzAKfNu8OnxDeBbGoBYo2uSCeGOZmGrHKUI5rhOvMgAHkzdESyp36ELUlMRj3j00UNTG7z79V45OTvKuCoBS7+vDgHDuzH8wnVDrX5BgPWvTMpQ7TdGw5v/2ICIEiud/ZJXeepI7VeWhoAG6MaJEikHVXeqKQv7dulNgNo1N8k1++3b+Rz9UD+5f6Nv0iTn
 EnB8DXYv
 bu9h8fs+o3VVcIKLXu7ulGRskkB9R/8Emn+7+bE6J+FWs2G2zv6UyfUnY+mE+Ap22O/Zn8H9oUo8hrJLZAwuZsmDjfzJ1I7m27Yn111kTM3EL1ugzlZods+EvaCHBV8nvKo0dlywunZzuk2+ySEOj3nRY+TP0rxwwUDnjQv5hrDRkeoeKunl5cgmo0ICGr4kpSWEBlDf3CxspCgATJ/OAkFDs0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When inode_lru_isolate() drops the page cache of an unused inode, it
has to unlock the list, so it returns LRU_RETRY and the walk restarts
at the head of the list, where the inode still is. If
invalidate_mapping_pages() could not empty the mapping, the restarted
walk strips the same inode again, and so on until nr_to_walk runs out.
Every walk of that list then ends on this inode, and nothing behind it
is reclaimed for as long as its cache stays.

Before commit 2a0629834cd8 ("vfs: Don't evict inode under the inode lru
traversing context") the walker pinned the inode with a reference, and
dropping it in iput_final() set I_REFERENCED, so the restarted walk
rotated the inode to the tail. Set I_REFERENCED again when the mapping
is still populated after the invalidation, in the same i_lock section
that clears I_LRU_ISOLATING. inode_unpin_lru_isolating() now expects
i_lock to be held, like inode_pin_lru_isolating().

On CONFIG_HIGHMEM kernels this can happen to any unused inode: a folio
is left behind if it is locked, under writeback, spliced into a pipe,
or still in another CPU's LRU-add batch after being read. Without
HIGHMEM it happens to DAX inodes whose only entry is at index 0, which
mapping_shrinkable() lets onto the LRU and invalidate_mapping_pages()
never removes.

Fixes: 2a0629834cd8 ("vfs: Don't evict inode under the inode lru traversing context")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>
---

Found while working on reclaim of inodes pinned by page cache in
ZONE_MOVABLE.

Tested in QEMU/KVM on master af32da41b032 (v7.3-rc6-232), with lockdep
and KASAN enabled. A small init program makes one unused inode whose
page can't be invalidated, lets it reach the head of the inode LRU,
opens 2000 other files, does one "echo 2 > /proc/sys/vm/drop_caches"
and counts the inodes left via umount; kprobes count the
invalidate_mapping_pages() calls:

                              without patch           with patch
  i386 HIGHMEM, file read     2000 of 2000 left,      none left,
  on another CPU              10300 strips, 1 inode   4 strips
  i386 HIGHMEM, page          same                    same
  spliced into a pipe
  x86_64, ext4 -o dax,        same                    same
  file mmap()ed
  controls (no leftover,      none left               none left
  shadow entry at index 0)

2a0629834cd8^ behaves like the patched kernel, 2a0629834cd8 like
master. On 5.15.y x86_64, where every unused inode with page cache is
on the LRU, the read-on-another-CPU case blocks the walk as well.

With "echo 64M > /sys/fs/cgroup/memory.reclaim" instead of
drop_caches, the i386 pipe case does 262450 strips and frees nothing
without the patch, 40 strips and frees everything with it. In the DAX
case that write takes ~400ms with the patch instead of ~4ms:
invalidate_mapping_pages() counts the DAX entry it leaves behind as
reclaimed, so unpatched, the 64M are "reclaimed" by re-stripping one
inode in a tight loop while nothing is freed.

The reproducer is a single C file; I can post it.

An LLM was used to check the analysis against the code, write the
reproducer and draft the changelog; I have reviewed all of it.

 fs/inode.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index a9d37be390a1..1614a97ce953 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -593,12 +593,11 @@ static void inode_pin_lru_isolating(struct inode *inode)
 
 static void inode_unpin_lru_isolating(struct inode *inode)
 {
-	spin_lock(&inode->i_lock);
+	lockdep_assert_held(&inode->i_lock);
 	WARN_ON(!(inode_state_read(inode) & I_LRU_ISOLATING));
 	inode_state_clear(inode, I_LRU_ISOLATING);
 	/* Called with inode->i_lock which ensures memory ordering. */
 	inode_wake_up_bit(inode, __I_LRU_ISOLATING);
-	spin_unlock(&inode->i_lock);
 }
 
 static void inode_wait_for_lru_isolating(struct inode *inode)
@@ -981,7 +980,13 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 		else
 			__count_vm_events(PGINODESTEAL, reap);
 		mm_account_reclaimed_pages(reap);
+
+		spin_lock(&inode->i_lock);
+		/* The walk restarts here: don't retry leftovers right away */
+		if (!mapping_empty(&inode->i_data))
+			inode_state_set(inode, I_REFERENCED);
 		inode_unpin_lru_isolating(inode);
+		spin_unlock(&inode->i_lock);
 		return LRU_RETRY;
 	}
 

base-commit: af32da41b0327b9c6a37856ba82b6760d6c8d10e
-- 
2.55.0


