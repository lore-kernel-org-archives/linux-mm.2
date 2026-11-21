Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31EF9606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 16:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W+Kgbu0c
Received: by kanga.kvack.org (Postfix)
	id 412496B05B4; Sat, 21 Nov 2026 11:03:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA9E6B05B5; Sat, 21 Nov 2026 11:03:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B1606B05B6; Sat, 21 Nov 2026 11:03:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DA1C36B05B4
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:03:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 46B831C3DB3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:03:26 +0000 (UTC)
X-FDA: 85459596012.09.7B755FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 344FF40003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:03:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W+Kgbu0c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795277004;
	b=5vdL1bfR59k8v/8s1W7DmYCscXU5PinCMLu7MZxbcal7xGPp0fKlxYODa31BqP0rfTWRWo
	7xdy/C/Ilk2ThaAbRBS4BXDCFEnMdqARjQQBSu7exFbNJW7e31Ri1FwoISpNQSPuRyGtYc
	lVjUjQn7jCHgBJZ5mruM3op9DjgY1Pw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795277004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LId/pfdNK+kcwrBUkujBAEx5NAsbcSjlaxfY3IRiHMQ=;
	b=AWtJmZsKBSP08GirjFp2WiHWS4M4P6PQE86zz+lIOIRxUpHa7zhHAm80YY6RcRYTa3eX1I
	junlV4BVsfQ6Qx5KPDfVVN10Qel6SiNjAyNyn8MbigRo52mnFLZdXeOIc1aeDZRui9Bv7s
	Ct3n9E6qA3nHK3qd8dQS5v1HJrL1ZYE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W+Kgbu0c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 454C8459E8;
	Sat, 21 Nov 2026 16:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60DA1F000C0;
	Sat, 21 Nov 2026 16:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795277003;
	bh=LId/pfdNK+kcwrBUkujBAEx5NAsbcSjlaxfY3IRiHMQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=W+Kgbu0c6J7SGfPQ62/PPeyc4fUL1Z6sm4hDkdNeYNV90392EaD2iD8hCMRfL9q/H
	 EkjPSGjTuwn6j5ALU6yA2mau7ArCdK+LGHOgFDz4gTkjiQsMqq3MKun2ypLTSSN+hm
	 7L+fqa6neyZgUoZ3XbM1HEvyFNXkRyoeyWfbELQTTOwb8phr7+nF83wMfj1d2JewLq
	 RB74X9qZCCq8HDGAJbJet/enCNUSbqw0gEotGLbEc5fSNusnqM48mxWN8Sm3kI8iGQ
	 WbjWR9KGSl4RGGag1na8PxxH3bT5lSZ0VIdRL6V1IfuQ8aDi2QpVyW3bMyJ6xiatkI
	 2uQgjwRcmPQGA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 21 Nov 2026 16:02:28 +0000
Subject: [PATCH 2/7] mm/vma: lock VMAs before taking mm_all_locks_mutex
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261121-some-more-ai-fixes-v1-2-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, 
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4094; i=ljs@kernel.org;
 h=from:subject:message-id; bh=LrpiwotdXkJz5/ABY48wAzoP5uiMEH0O95S+K/32rIg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIZD2xP/HWsKIUv41ZP+9YPG7MeHpby+H3+0Y7fS5IML
 SQkjq/b3VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJRBgx/LOb8MhgJ+Ph3QUr
 BNlftZrKc5Y92eNpvezaCp/7PKsKYxczMsx9wiXqmj+37mTH6T7L8vANmrs26z3KkTpWzfDi/G2
 nEgYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 344FF40003
X-Stat-Signature: pu41qpmyds8mqnfjhb6t9o1xnf6q3qcs
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795277003-751847
X-HE-Meta: U2FsdGVkX18shXzFBvywIt7bI05dbZjBH5sHovxA9i53PlS/Wt3nXv/PrmOXDWeb8Koq/kTBTJc65fy/CkBfQu7ZzR0i9nNjy+tE+Nrkwq+1fn0MbLJaNbjczWt2sQkw4i/A1ZOw54pNbzUxxXS0JfyQ698T6losJyyx5wDXIVJPa6rO9Rf0GUrLziNm393FBevHK/Zf5TkU3xTcX3vaD91L5f2ED2HfLuWy/LgJdb65M8QhObaG9k3sNO0WDS7ONr5ME/APuZxjtI/l/hmo+2FICIi2FTZj0ojiSJPp7KquKRlrxAJfNHf1TPDjrd0KI3F4/n7Y8dYHZxpYfeTZglUi4nLSA53dKiSkN4e+js384KM0W3Nvv8pdsx3WU4IfHLgfpS2mdKgaQLW5U7vTeJVssI66KY63LLCwnxq/x/s7ktuA+jUsVSAeaXi0i1STKW9CORA3LwTbzFSp6nQCMtCajd8NJslgFzu41zJN1tYCPnkEEsMexQjbEIZiYG+Io5n0vQxeBZxq1pmsGABpz3CqC/NXgO5pIAxpCzx6QzNr6jam45UJyEKtEWqj4Ym5kFP3Fp+Q1dni3Fk1tqkSRKXa+TezInWI46Ouk3qsn+T1ExlxjfDiy4xoFJRlcrk0OcpGzy74d493NAuihJuQENo0vVOQU/XvotkkCu+Zyq7hr9odfa76oNkMWrN/PQd3+j+LprP0K10QwSR/v3e3xrL5YfLd6D5TsGwNjIlYhWelbMUugZlxdh6HiEXDGfdPlkErJdQwy+PWFUSbyidlTJ1ru1mPvT+RLxIKxukE2CELQ5jUyCjHrz/NLyApYcRCz6J+OqRv+1LrcVmMn2d2AwLIypqqjs2o09JwcK2JBCGFv+M1V3aPNVUporsX+Dlt5dSL5NtOYKd1mIEkPoDFljnpBJKq0rtg301nRgmZ2zw+P1MYvFM/JvjLGYJLccbj2Ektrlbe2eCTqddnvke
 jex8ppY4
 IQh9cwQxTw0q8uszbqbmFY+2FYzfYi0gNdqcbwEzpgNeihWmN8s//rgPtpmbAc4Z7AM2sik2vCUa+Tpe4oAdmlBXtKPJ8x/2KQ01wchFOp/cbzOc+IteO1N1EAXLaKP+xbXLZiiGsfAORDe12wVLr0Y9LK3ZCKPjrC63lERvZ2onf4ESDvcQAC0kEehY+PiKxlwIVCD6fS7x6ozDMMXqafE2R/2UaGU6sgBxlz4BWzufIu5vB8bgEp0XtWmGdlHTOsWh8P5E5XCPrvblzLiJ4/Bg/q1F2f0DOGfwFRAI36g2yfLCGKfdkutJxcx9gkQnyH3DrkXCDx4PwzI9BewKSTlozX9EYiYIbVzu3BGKQpDfK3to+r9QFwkGgRQhyVCcG4t25IgDDeqiiBUHaosQnD9SFigv8hSRvWLawo91njRTSHEu6u4MMczQAKF4WA1es447YW1t6plRoYJK7O5BV9/NjdaYwPcoGIFIewt0bd+NzedwDX+pFqplINLtV2SAD4Oa8X49eya289zI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If an mmu notifier is registered for an mm while one of its page faults
sleeps indefinitely under the VMA lock, the registration of mmu
notifiers for every other mm can hang un-killably.

mm_all_locks_mutex is shared by all mms, so its holder must not wait for
something that has no bound.

However, mm_take_all_locks() calls vma_start_write() on each VMA with the
mutex held, and thus waits for the readers of the VMA.

Since commit 4ed4379881aa ("mm: handle shared faults under the VMA lock"),
such a reader can sleep in ->page_mkwrite().

Consider fuse_page_mkwrite(), which sleeps until the FUSE server replies to
a write request:

    mm A, thread 1          mm A, thread 2         mm B
    ==============          ==============         ====
    lock_vma_under_rcu()
    fuse_page_mkwrite()
      folio_wait_writeback()
                            mm_take_all_locks()
                              mutex_lock()
                              vma_start_write()
                                                   mm_take_all_locks()
                                                     mutex_lock()

Fix the issue by locking the VMAs before the mutex is taken.

Additionally, make the VMA write lock killable so a fatal signal returns as
quickly as possible.

Finally, update the comments to reflect the change, dropping the lock
ordering list which begs for bitrot.

Note that the lock order at the top of mm/rmap.c doesn't appear to be right
- the hugetlb locks are taken after the VMA write locks. However, this was
already the case, and can be addressed in a follow-up in any case.

Target commit 4ed4379881aa ("mm: handle shared faults under the VMA lock")
as this is where it became possible for VMA lock readers to sleep in
->page_mkwrite().

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 4ed4379881aa ("mm: handle shared faults under the VMA lock")
Cc: <stable@vger.kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 09bbcdb4971b..f8cf319ff9cf 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2375,15 +2375,10 @@ static void vm_lock_mapping(struct mm_struct *mm, struct address_space *mapping)
  * mapping->flags avoid to take the same lock twice, if more than one
  * vma in this mm is backed by the same anon rmap or address_space.
  *
- * We take locks in following order, accordingly to comment at beginning
- * of mm/rmap.c:
- *   - all hugetlbfs_i_mmap_rwsem_key locks (aka mapping->i_mmap_rwsem for
- *     hugetlb mapping);
- *   - all vmas marked locked
- *   - all i_mmap_rwsem locks;
- *   - all anon_vma->rwseml
- *
- * We can take all locks within these types randomly because the VM code
+ * Mark all vmas locked, before taking mm_all_locks_mutex. Then take remaining
+ * locks in the order mandated by the comment at the top of mm/rmap.c.
+ *
+ * We can take locks of the same type in arbitrary order because the VM code
  * doesn't nest them and we protected from parallel mm_take_all_locks() by
  * mm_all_locks_mutex.
  *
@@ -2400,20 +2395,24 @@ int mm_take_all_locks(struct mm_struct *mm)
 
 	mmap_assert_write_locked(mm);
 
-	mutex_lock(&mm_all_locks_mutex);
-
 	/*
-	 * vma_start_write() does not have a complement in mm_drop_all_locks()
-	 * because vma_start_write() is always asymmetrical; it marks a VMA as
+	 * VMA write locks do not have a complement in mm_drop_all_locks(),
+	 * because VMA write locking is always asymmetrical; it marks a VMA as
 	 * being written to until mmap_write_unlock() or mmap_write_downgrade()
 	 * is reached.
 	 */
 	for_each_vma(vmi, vma) {
+		int err;
+
 		if (signal_pending(current))
-			goto out_unlock;
-		vma_start_write(vma);
+			return -EINTR;
+		err = vma_start_write_killable(vma);
+		if (err)
+			return err;
 	}
 
+	mutex_lock(&mm_all_locks_mutex);
+
 	vma_iter_init(&vmi, mm, 0);
 	for_each_vma(vmi, vma) {
 		if (signal_pending(current))

-- 
2.56.0


