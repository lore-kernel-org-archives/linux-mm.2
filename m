Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05822606A327
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 13:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JYNSQwiF
Received: by kanga.kvack.org (Postfix)
	id 189466B00EF; Sun,  1 Nov 2026 08:49:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13ACA6B05B1; Sun,  1 Nov 2026 08:49:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028CA6B05B2; Sun,  1 Nov 2026 08:48:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE7BD6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 08:48:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 598B71C4347
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:48:59 +0000 (UTC)
X-FDA: 85386681198.28.162771A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 38CC3180003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 13:48:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JYNSQwiF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of devnull+joasantonio108.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+joasantonio108.gmail.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793540937;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sf2fWx8SkwotfgOzFNKCbxbo9iqhQM6sIeyQ7Y70Yyo=;
	b=orQn8DoJNvH+uvNaacsx5rcSfiTSMY1GjP+rAHBOwfmnX4cR1ymMhET3vKrFqz1CKX9UXa
	gWQBkjW1RMHV1V6qEYAr5GOpy21I0LMCAEgLVBXuFYnLaX3lt8TKWMgbrl/OF6oFdrG9cL
	AOdqhs1JvxoM+Z7k+3rESBVuffy6fQc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JYNSQwiF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of devnull+joasantonio108.gmail.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+joasantonio108.gmail.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793540937;
	b=lU+F1alHZA9prI1MA0HmiGMOLK0Bq/XDc9etTzYVWnFPa1qkQf+tkPIWVB3aPRVTXAUxmJ
	lHeK1o9FBgEPkOJNlM8LXDVDYzVOFMnX9rJbW0ihpdAueIKB09FecEKgaBJjoO3Kot5ygV
	iAnAOAS5A0NTjFthcX2W6AAjpexTyqI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F4B340889;
	Sun,  1 Nov 2026 13:48:56 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793540936;
	b=T7w5Tyrc4K2ozr+FIjIIs/M0hh8V6ZxF74cBo4nIbrWyV+zCDaOeb9Xe66Vj+8EcIbaH
	 JSMJtyJ9Tr15rozd/NsorloxK0u77LR4e7XEdQIWtmAr5UsvNXD4vczyO3crg7gkuM5Qu
	 0bRsR93y5EKHDmy/vLgroN+DYlRtQLYR2UqNJOHvg4U1toN2z4biKqvqh9Ib71t43GqE2
	 i2gKqIQ3v+MBP9AqO866HRYqaqOluAlBK3PYQdFRk2wfuwdGzDmzHuilGaO5P2G3wSkvH
	 r/oUomCfY/x2vW/E3nZ7q7p+9jNlVdUHzSQj4dZ6xvDlHiiIel7Il0NC6KdS4UpvXkw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793540936;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=sf2fWx8SkwotfgOzFNKCbxbo9iqhQM6sIeyQ7Y70Yyo=;
	b=KzdZvJkw3lHyXXQ9suzwBLrH27njJ6wenmxO1B/Z4KhbFSHkCN+hD4kkWfbqrwiVDBFe
	 OYRdchiQA8SDWwgeqhMBQ+JmhVBbLXDS11lydbJ5ybok28l5jrG+MRdv63zH8H+1K2TUa
	 Ytka778SLzAl9oUmFmTWZf0KRjY8bcaKbpz1x8766sLyVYd/pahA62NMGHQO/UqjX9wSZ
	 yeGY3SyJH+JaY40DJHhmOHbYPO6cNNEypt67n20yFfl+Od8AbiYs453jhU1+Q6NUtJ3uL
	 TLE1Qtb97lW5cCvHyLfAqVAytpxIBDBcg7m0yunslUePp4A3lhehGfrSeXjQY/EBXKA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B936F1F000C1;
	Sun,  1 Nov 2026 13:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793540936;
	bh=sf2fWx8SkwotfgOzFNKCbxbo9iqhQM6sIeyQ7Y70Yyo=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=JYNSQwiFGZz73IBHMo4DK3+cb8IZRdzBWiN79Be3d8ZytFx3Qe7HYmGZuNmKT4xTI
	 b4vxmDyQNJRS7V3T6g2kWrsqogi6aLac0Wjee7UnYdy3SP0k9QJhn5M7hYhshotcOj
	 SrrdAKwvRvOapBPmBdt+hQcbuM+LPlaaf6H8C5wIYvglMDw/vHC6IIC0ClC+ZzI7p8
	 IHAF8UGehrfkXGPIbJWLBLrQO9db6KGmTIujtMFDuomZGUM0+ptHCx8uGhBt8o0GVK
	 H/7KaQgLauMGx77Eiq1awMnWrN8azaLHdb0lP2GuXv4K1yd4HE+f/B0x6tpVX7Sikp
	 G0UeSscAoxXJw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1FD6646188;
	Sun,  1 Nov 2026 13:48:55 +0000 (UTC)
From: Joas Antonio dos Santos via B4 Relay <devnull+joasantonio108.gmail.com@kernel.org>
Date: Sun, 01 Nov 2026 13:48:55 +0000
Subject: [PATCH v3] hugetlbfs: move hugetlbfs_free_inode tracepoint to
 ->destroy_inode()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261101-b4-hugetlbfs-trace-v3-1-051b716f490f@gmail.com>
X-B4-Tracking: v=1; b=H4sIAEZD52oC/32NQQ6CMBBFr0Jm7ZiWViWuvIdh0ZahnQQoaZFoC
 He3cgCX7yX//Q0yJaYM92qDRCtnjlMBdarABTN5Qu4KQy3qqxRKotUYXp6WwfYZl2QcodLSKtU
 Ye7lZKMM5Uc/vI/psCwfOS0yf42OVP/s3t0qUqMk1naiNEs49/Gh4OLs4Qrvv+xflPZQgtAAAA
 A==
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
 Hongbo Li <lihongbo22@huawei.com>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com, 
 stable@vger.kernel.org, Joas Antonio dos Santos <joasantonio108@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793540934; l=4610;
 i=joasantonio108@gmail.com; s=20261031; h=from:subject:message-id;
 bh=hsjYpEEpLfY06mwC5K6ZIdgYdPIvwZSlg1C/xa03vNE=;
 b=BmXuNSntQmCrvn/OtUUWVl3EBh3PNxguI3icnBQ5TGmrSpMuwaATN0T3mCF81AKlpCxVZw1sq
 LQgetf/RxWvDBb/SVzvpMm/Au532FAPkGM0YXtOvySgToUd5LBN8AyV
X-Developer-Key: i=joasantonio108@gmail.com; a=ed25519;
 pk=ZxAznJT/FcPPdzLrDDFJQm4LLjjHVGBBqDSG3TXS23w=
X-Endpoint-Received: by B4 Relay for joasantonio108@gmail.com/20261031 with
 auth_id=1371
X-Original-From: Joas Antonio dos Santos <joasantonio108@gmail.com>
Reply-To: joasantonio108@gmail.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 38CC3180003
X-Stat-Signature: cze9bybosb78f3pnwwu7ut69o7dddtbq
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_REPLYTO_END_DIGIT,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793540937-219853
X-HE-Meta: U2FsdGVkX19xdGPHGOKjM4/bkpyRTHXBaLr0dgERVxytACWXjDD0rc//fjnC8dCxR8BxjAs0YbTfs4fajbyjrY7roWJy6NlPAkpw5VpCPT3r77y0w7G08gQwuMfKYgRCS5BpQsXSIwm+3C4oQ6WuETEgvQUtlT0aKcwtnOKYmMTeGDEwl+YoDrRNPMHFOCKhdIeVVRuupq/WVrCmJgigaJBa9zOuFixudUIjWGat8mKCvuTDm3CsPTmQL1D27tAN8ulxkvT8W2gR0ND7u+MMBTeNVkHnNKgcBDq1dxHjGYDqjIN9GzPftoLt7cmoMR2eWiAGpWzG37mD4CMY9zbdRQyMDUcC6rHtbxGd8KxOVl9aHcB9Uohiy0RV7rIh0TZf72MVhJQ/EapiOrKKqM4ouTqqCJakWgJeeS3IZ1GVcsimhc1/59Bc+F7UOjoEsDbnbziIa3Z2yenc4o1ybXIqFslKcxxjO8dr0HzOd0owJBSdWzHk/1hW7wK9mSIBR2K+i72jcC58NXEyVGDNFYuCHWLIrZ0jnM/g/YjMI/RmyH1urcfmoIqL6VNhTSHuNQ6ndT6W4uOcSue4Azwr41fzGKa6JTRz+D+rfi/pWzlgeQ2yE89j3+gbah7YMn/c1qhzPo4PjHb6h8qsRiCLLZ5cgUjDcKnkiFk6Awnmb1UMTlbS8+AVcqtBwu0Zo4tlBTBhADnYBv+zmWuKceKSynMJ1ka9HVqYH6F/1KE4+f5aW+Ck7pO4WeRnzHnswzyMSqQDjrio7odoApNXMymHvbngXBPTgzkUzK99fT2akuEtvJCr8rldtL4+x0Np30q57G9frXERD3LSDBO9rBj/3YbqsV5ML9sygw1+jmghqTXAe03QYV/U6L+XBaRMwNazrMN8YLjTZSq2NB0LMsRWxDkowD3qmQ0qQscM9Odz2qcodI1RJHFMFz18021Bqg3Gj+q9jPfsjRzewhV1o2Sv89c
 81/oeWNJ
 POfTSu6Y8+eZLDCbyaplXROP1EbEpW7owKlOTePLTsEoiIkdvdUTRI5RV/D4dnIvtTHbzg0WoZDUwgIuGTZAT7ClYvuooHkIeni88POF1B3a11njoSe73MI5g8VfxmmoFV5fK0cp8l8xGdzIs/GWXwOYKHFZnVhD+Eu4npfasW42DfIJ+bUMO1yfiOs+C5WD1mikFNk5IZyCX3JuQ+RiXT9Uob8AE4D9B5P5xnTmdxoqdELv6+km0Z2FBgUkrU/JfUZCW/t5g29Xi4KFcgoX9hJoXYl+BLneQ8GH1iiZTDzuD+/vPIbC6plL+GSaouGl7jXH/Mww+YqPAI4EW0i7501Z4kVV4OOr2q/+gNiRUbBeZZ9Fsm1zhS5NJImUbvGkX510BjA3m2DU2TL4jKli4CTnchfZ/w4+cGU0Lzfv4qAqkpKp29Ji8BG4VycOKAPbvCQiOM2GDFlW6Az6lFbuiKVg2V+0CGO2c3olUSgDEj1lXHzTBbgb6Q85YRcgz0+VzjzD1FQvTabiO6vlDxjNShvh16DTLANkplQrYH4XJKlQB2KwwzIGSKGhMES0Bp+fG8q2KBQ9Xs56xKGMObqL+g6IKW2VLdwBGZ7Pafb4c4NOfJ9qI33FURdPnFq3EA+ZGr17e38mjh8GhyKrak1d0gw6E0RhM/ZQsulmo9K2L6IsdCu5tAMhAPOgQd8Zspj4dR1QOi6k6fTXXBSTxx9iPxsodimey2lhN+yOjPAX9qRTfVTlDEegyjCGpLjACGK6usD6QFLMRTNlUN5RB9OT/kU5QkNfpomgqwZsBZbot785FkNrYIzk5iSkydbHA95Sk2/fx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Joas Antonio dos Santos <joasantonio108@gmail.com>

hugetlbfs_free_inode() calls trace_hugetlbfs_free_inode(), and the
hugetlbfs__inode event class records inode->i_sb->s_dev.  ->free_inode()
runs from an RCU callback (destroy_inode() queues i_callback() with
call_rcu()), and Documentation/filesystems/porting.rst says that this
callback "is *NOT* ordered wrt superblock destruction; as the matter of
fact, the superblock and all associated structures might be already
gone".  put_super() frees the superblock with call_rcu() followed by a
workqueue item (destroy_super_rcu() -> destroy_super_work()).  syzbot
hit this with the event enabled:

  BUG: KASAN: slab-use-after-free in trace_event_raw_event_hugetlbfs__inode+0x45b/0x4c0 include/trace/events/hugetlbfs.h:36
  Read of size 4 at addr ffff888038850010 by task syz-executor952/6134
   hugetlbfs_free_inode+0x15e/0x1f0 fs/hugetlbfs/inode.c:1182
   i_callback+0x46/0x80 fs/inode.c:317
   rcu_do_batch kernel/rcu/tree.c:2650 [inline]
   rcu_core+0x5f0/0x1220 kernel/rcu/tree.c:2919
  Allocated by task 6134:
   alloc_super fs/super.c:326 [inline]
   sget_fc+0x1ba/0x1f60 fs/super.c:874
   hugetlbfs_get_tree+0x1e7/0x2b0 fs/hugetlbfs/inode.c:1431
  Freed by task 855:
   kfree+0x22b/0x6d0 mm/slub.c:6923
   process_one_work+0xac7/0x1b10 kernel/workqueue.c:3495

Emit the event from hugetlbfs_destroy_inode() instead.  destroy_inode()
calls ->destroy_inode() synchronously, before it queues the RCU
callback, while the superblock is still alive; hugetlbfs_destroy_inode()
already dereferences inode->i_sb there.  ->free_inode() is left with
only the kmem_cache_free().

Since the event no longer fires from ->free_inode(), rename it to
hugetlbfs_destroy_inode so that its name matches where it is emitted,
as suggested by David and Muchun.

Found by syzbot; analysed and tested with the syzbot C reproducer on an
arm64 KASAN kernel.

Fixes: 014ad7c42a69 ("hugetlbfs: use tracepoints in hugetlbfs functions.")
Reported-by: syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6ae27525.5451848c.f7707.0001.GAE@google.com/
Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Cc: stable@vger.kernel.org
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
---
Andrew, this replaces
hugetlbfs-emit-hugetlbfs_free_inode-from-destroy_inode.patch in
mm-hotfixes-unstable.

Tested with the syzbot C reproducer (adjusted for the new event name)
on an arm64 KASAN kernel: no splat in 3 of 3 boots, and
hugetlbfs_destroy_inode events are recorded.

Tool-use note: the analysis and testing were done with help from an
LLM-based assistant; I reviewed the change and ran the tests myself.
---
Changes in v3:
- Rename the tracepoint to hugetlbfs_destroy_inode in the same patch,
  so its name matches where it now fires (David, Muchun).
- v2 was the resend with the Assisted-by trailer dropped; it should
  have been marked v2 in the subject, sorry about that.
- Link to v2: https://lore.kernel.org/r/20261031-b4-hugetlbfs-trace-v1-1-4ec8d02a30cc@gmail.com
---
 fs/hugetlbfs/inode.c             | 6 +++++-
 include/trace/events/hugetlbfs.h | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 01c4d6f44e..095b7fceee 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1179,12 +1179,16 @@ static struct inode *hugetlbfs_alloc_inode(struct super_block *sb)
 
 static void hugetlbfs_free_inode(struct inode *inode)
 {
-	trace_hugetlbfs_free_inode(inode);
 	kmem_cache_free(hugetlbfs_inode_cachep, HUGETLBFS_I(inode));
 }
 
 static void hugetlbfs_destroy_inode(struct inode *inode)
 {
+	/*
+	 * Not in ->free_inode(): that runs from an RCU callback, when the
+	 * superblock the event reads may already be freed.
+	 */
+	trace_hugetlbfs_destroy_inode(inode);
 	hugetlbfs_inc_free_inodes(HUGETLBFS_SB(inode->i_sb));
 }
 
diff --git a/include/trace/events/hugetlbfs.h b/include/trace/events/hugetlbfs.h
index 8ba72c1d4f..a7932e0db0 100644
--- a/include/trace/events/hugetlbfs.h
+++ b/include/trace/events/hugetlbfs.h
@@ -72,7 +72,7 @@ DEFINE_EVENT(hugetlbfs__inode, hugetlbfs_evict_inode,
 	TP_ARGS(inode)
 );
 
-DEFINE_EVENT(hugetlbfs__inode, hugetlbfs_free_inode,
+DEFINE_EVENT(hugetlbfs__inode, hugetlbfs_destroy_inode,
 
 	TP_PROTO(struct inode *inode),
 

---
base-commit: c339f4010dea8b0d754f84ace70cd1b089878ef8
change-id: 20261031-b4-hugetlbfs-trace-341b338ab57b

Best regards,
-- 
Joas Antonio dos Santos <joasantonio108@gmail.com>



