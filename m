Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 525C1C61DD3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 00:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799CA6B008C; Thu,  3 Sep 2026 20:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74A5B6B0092; Thu,  3 Sep 2026 20:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660386B0095; Thu,  3 Sep 2026 20:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 377086B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 20:35:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC0A7A47D7
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:35:43 +0000 (UTC)
X-FDA: 85174211766.16.4A79AAB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0D9551C0004
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:35:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RL1Vm7GC;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788482142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/i0PB9wZ1BVhvmuU/BjDsAlCJWHvx+Op8tKKNzHHKY8=;
	b=zm4qba1EuUegeTNE/Yk1mRW4jU6Y8Z6MdBxyGWanL2chNF4W1sNK6FAPFmsNPojIdV97r8
	xqXunb0FklTnbTdaq2j6/fjHAMVi/YtvpUkoitZzRyM0bzmk86ipgwurXjmR4hMBWk+f3o
	Bx3BY7yLqZrDIXkhDr3Ds1D3A62OGIA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RL1Vm7GC;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788482142;
	b=VQAKVwO16oIjVbbimput02xmIkIXmyeZ0mKhAeHBQSMune8PzhvIjjcYfhDJQFEPSLrI2r
	FFGdB7XtY2bNqFWFMG2EAq/0jK/0sEeM41JwTYCV1OgV/7ATxdjPSzHs8KlT5+mI/1cMcg
	9i6TdC3l0Nsq2CyWYNXjiptciubenD0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53B006057A;
	Fri,  4 Sep 2026 00:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98E41F000E9;
	Fri,  4 Sep 2026 00:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788482141;
	bh=/i0PB9wZ1BVhvmuU/BjDsAlCJWHvx+Op8tKKNzHHKY8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RL1Vm7GCgFf5V9xYnCjpbbZYUGpe6r9pkdDDULkM8h3VSSYPHnHI0b0+fkdMB/iRh
	 PqWDkm7zxDo/trg60ESnjwaGEwBo75ZTD4QD8KqUhouYiWS042mB4Fde7cNTiPBvCI
	 3dFpKjDn79U4dj243cWrUyJQiNCk01+xCg739Hjk=
Date: Thu, 3 Sep 2026 17:35:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SJ Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/memory: fix hugetlb_zap_begin() call in
 zap_vma_range_batched()
Message-Id: <20260903173540.e8f660dcaf083946417cba3e@linux-foundation.org>
In-Reply-To: <20260904000028.149656-1-sj@kernel.org>
References: <20260904000028.149656-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 34x3zrd1efqnshycejq8nosd8mmyfg8c
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0D9551C0004
X-Rspam-User: 
X-HE-Tag: 1788482141-623893
X-HE-Meta: U2FsdGVkX1+LKqcZ7AKl4pTtLM+iHIUvbdElt1S9ks8jE2S/R5YZzTqo88Ysw3QJspGr4L8lbfrGeOJ6sn3qyTrEYS1gR3NpYw9fZ47Tj8OwVXEyogMTllQb5ysUgblYaQdlUYiFDNkDUYFKhIpGqitZxyf4uKzKH4W/IactZiBtdbh39R4byjtgOaDH8929d7ovikuWkkjZDzmX7Wl5HFR9RUYF1J9wR/AfRRTA9GgOPJ/QgbT3jM4r91towhqNQHqlLgC/9Eu3nKnRYQAQffuulpHZfxKWOWwLtKnZ38xHCZEC5T9ei7NbNo7zQK0SObNmTrWUCUqXMZ9CGJwpjmxxrjILG/ScOPZJYOP0r+wqKbdkrORiv0xPnqF2AeHT9rvuYy8GJua2hJQNTQi7Ca5puu9LIaqk6o/y04pQgqa51oYLN9mIR76vaE+FjdebrQb5l5uDKbYUp37cdLiblM9KOJQAyeUyDbmRE7w11bFz5CpTt3t4tFK73UQ9pEpklB14xd3b/xfuGotJgNqbm6DcEh5RiiahMn3gGIQACgSJFJUKIN7jYTg+Z6/7nTrkbxgG0xasJWp0Hd5sNtgmtWQlLZI4FsJNHrQg3g6CrvDy1cq1bjeqbr9u/KWKAq94gmNTCbEBdIGVQK5kmzDFFa9eUF/4CCfvDiFAWp/5NAR/9ae6ZwZdRGuZ05aataDKxqa0ycuZRf1C78MrQmEt7Zy8BAkqgwoFCZ3ix7GUghjmEQlfsJW55sJq+cDWCs7nFnDVB0fBmBvS1vM2X92XESZgDJ9UhJH9SiPglzCDSv4LthobeACxGcoilGwMp/FhZWFq13Xax14BKBRIWvWww/TZBlpC4JLNNLmx1c2lbBCC1P3YIxtFT5VLRIPKa2H1GXr1JW9KXj2Vo55hR4XX+PaFPnC3aylJo5YGrM1M5R5dPDQDseWbjfHsNKzdCcnjgNMMVl1/DM7Iaf1PPZ+
 rBgTfYwl
 kn3DCv0UHTjaZ+xAC8Sgik1dN7p+FqBubzOp4GKxhupAaOmsPAoRRXuI0rTQLPDPTAYKQIdxoj5colGNuwlkDmJHtkg3m44wvQQwHsWsDwis1sAKqBlAujBmB9dTAmgIg/uOzFczRYBs4HJwIX3Qd8dBAGpUA4KtFNiNX65KET7nRWWM+Ge/AzY3biFPOjLbYhwph3tm/Wvd5MpEgSieuiQz0sJWBEoQY0SExYx9XthDMt4G+feWA4kWb2sys3Ld+XQHVqldcaxarha6P00rsELUll7OJOmikjDGMm/Kpfo4bC6LXUS+qAP0yQsbIxCqxqtfEPGJP78niSYRdXconTrfxf0f6jtfsvmi6yfcQwX211jcXN8QymJ0vPCXBh14lkXqc/Z+8Ue59O6sl0YXDpxbRJFWCdCMEPOw47HYY93y/eb3NbnfoBEumsoQoyhhpSKkDiVLuyQD9Mf8AfoznA86FjjUNs6PforN3pHWPcHU62TQAkU+DNEEzQXhh7QZsdf2yiDKVUvfxoy+bfF/i7ncsA3MNhy10YMZZ10db5vf/CoKXn3ikyOfgZb2LQ+q1hd+YEOug8BL0r/VNpVxf1CFZ5bK2WYOfGUZYCusIkjANzEl/Ig6O2Pklvk8GqEUPvoAe/uyU3dKSOZAQlVjkSqapAAWVVFYiFsmqi0eOppx9R2SdqJhRpUkzTUaVz6y4xN6tBbHUkx2QIje/XhbzYSU/ik+wi2QjLmtz5+IsMT5HGf5b7TEy/t2+Jq20Yu8vIhIt3mxXsvQSk2M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 17:00:26 -0700 SJ Park <sj@kernel.org> wrote:

> Commit f1fc44daf618 ("mm/hugetlb: don't lock private resv_map during
> final unmap") added zap_details parameter to hugetlb_zap_begin().  But
> the hugetlb_zap_begin() call in zap_vma_range_batched() is not updated.
> As a result, build fails as below.  Fix it.
> 
>   CC      mm/memory.o
> .../mm/memory.c: In function ‘zap_vma_range_batched’:
> .../mm/memory.c:2308:9: error: too few arguments to function ‘hugetlb_zap_begin’
>  2308 |         hugetlb_zap_begin(vma, &range.start, &range.end);
>       |         ^~~~~~~~~~~~~~~~~
> In file included from .../mm/memory.c:48:
> .../include/linux/hugetlb.h:253:20: note: declared here
>   253 | static inline void hugetlb_zap_begin(struct vm_area_struct *vma,
>       |                    ^~~~~~~~~~~~~~~~~

You cleverly pulled during the ten-minute-window after I'd pushed this
out in order to pull it onto my build-test-machine.

There's probably a smarter way of doing this, not sure what though.

It doesn't happen often - I usually only need to push/pull the quilt
patches (25-new).

> /* TODO: move below to commentary */
> 
> I didn't read the broken commit in depth.  This fix is only
> build-tested.  I wanted to report the issue with this as a temporal fix,
> but the broken commit doesn't have Link: tag.  So directly posting this
> temporal and not very well verified fix first.

Yeah, this is possible fix for
https://syzkaller.appspot.com/bug?extid=bd6aaf99e8443d8a9034 which I
had chatgpt create for me.  It's in limbo at present until I figure out
what to do with it.  Actually I'll hide it from others while figuring-out
happens.



For the morbidly curious.  It's really only a 2-line change, plus a bunch
of changes to pass the zap_details down to  __hugetlb_zap_begin().



From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/hugetlb: don't lock private resv_map during final unmap

Replacing a private hugetlb mapping can trigger a lockdep circular
locking warning and, if the corresponding reclaim, NBD and socket paths
run concurrently, can deadlock userspace tasks.

The mmap path holds mmap_lock for write while removing an overlapping
mapping and then reaches:

  unmap_vmas()
    hugetlb_zap_begin()
      hugetlb_vma_lock_write()
        resv_map->rw_sema

This establishes the lock ordering:

  mmap_lock -> resv_map->rw_sema

Lockdep already knows about a transitive dependency in the other
direction.  In full, the relevant part of the dependency graph is:

  resv_map->rw_sema
    -> fs_reclaim
    -> q->q_usage_counter
    -> q->elevator_lock
    -> set->srcu
    -> cmd->lock
    -> nsock->tx_lock
    -> sk_lock-AF_INET6
    -> mmap_lock

The resv_map->rw_sema -> fs_reclaim edge can be established by a
private hugetlb fault.  The fault holds the private VMA lock for read
and huge_pte_alloc() can allocate page-table memory with reclaim
enabled.  The middle of the chain comes from the block and NBD paths,
while sk_lock-AF_INET6 -> mmap_lock can be established when an IPv6
send copies from userspace while holding the socket lock and faults on
the user buffer.

Consequently, lockdep summarizes the relevant reverse path as:

  resv_map->rw_sema -> sk_lock-AF_INET6 -> mmap_lock

This is a transitive lockdep dependency, not a single call stack
holding all three locks.

Commit bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private
VMAs") made hugetlb_vma_lock_write() acquire resv_map->rw_sema for
private hugetlb mappings.  That lock is needed for partial zaps such as
MADV_DONTNEED.  It keeps a concurrent fault from running after the PTE
has been cleared but before the hugepage has actually been returned to
the pool, which could otherwise result in an unexpected SIGBUS when the
hugepage pool is fully allocated.

That serialization is unnecessary when the VMA is being finally
unmapped.  mmap_lock prevents a concurrent fault from entering a VMA
which is being removed, and private VMAs do not participate in hugetlb
PMD sharing.

Pass the zap details to hugetlb_zap_begin() so that it can distinguish
a final unmap.  For final unmaps, continue taking the hugetlb VMA lock
for shareable mappings, where it protects PMD sharing and the lifetime
of the VMA lock, but do not take resv_map->rw_sema for a private
mapping.  Likewise, do not attempt to release the private reservation
map lock from hugetlb_zap_end().

Non-final zaps continue taking resv_map->rw_sema, preserving the
MADV_DONTNEED versus page-fault serialization for which private hugetlb
VMA locking was introduced.

Fixes: bf4916922c60 ("hugetlbfs: extend hugetlb_vma_lock to private VMAs")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: syzbot+bd6aaf99e8443d8a9034@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bd6aaf99e8443d8a9034
Cc: Rik van Riel <riel@surriel.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>
Assisted-by: ChatGPT <chatgpt@openai.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    8 +++++---
 mm/hugetlb.c            |   16 ++++++++++++++--
 mm/memory.c             |    4 ++--
 3 files changed, 21 insertions(+), 7 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-dont-lock-private-resv_map-during-final-unmap
+++ a/include/linux/hugetlb.h
@@ -245,15 +245,17 @@ void adjust_range_if_pmd_sharing_possibl
 				unsigned long *start, unsigned long *end);
 
 extern void __hugetlb_zap_begin(struct vm_area_struct *vma,
-				unsigned long *begin, unsigned long *end);
+				unsigned long *begin, unsigned long *end,
+				struct zap_details *details);
 extern void __hugetlb_zap_end(struct vm_area_struct *vma,
 			      struct zap_details *details);
 
 static inline void hugetlb_zap_begin(struct vm_area_struct *vma,
-				     unsigned long *start, unsigned long *end)
+				     unsigned long *start, unsigned long *end,
+				     struct zap_details *details)
 {
 	if (is_vm_hugetlb_page(vma))
-		__hugetlb_zap_begin(vma, start, end);
+		__hugetlb_zap_begin(vma, start, end, details);
 }
 
 static inline void hugetlb_zap_end(struct vm_area_struct *vma,
--- a/mm/hugetlb.c~mm-hugetlb-dont-lock-private-resv_map-during-final-unmap
+++ a/mm/hugetlb.c
@@ -5403,13 +5403,25 @@ void __unmap_hugepage_range(struct mmu_g
 }
 
 void __hugetlb_zap_begin(struct vm_area_struct *vma,
-			 unsigned long *start, unsigned long *end)
+			 unsigned long *start, unsigned long *end,
+			 struct zap_details *details)
 {
+	zap_flags_t zap_flags = details ? details->zap_flags : 0;
+
 	if (!vma->vm_file)	/* hugetlbfs_file_mmap error */
 		return;
 
 	adjust_range_if_pmd_sharing_possible(vma, start, end);
-	hugetlb_vma_lock_write(vma);
+
+	/*
+	 * A final unmap cannot race with a fault in this VMA because
+	 * mmap_lock prevents the fault from entering a VMA which is being
+	 * removed.  Skip the private resv_map lock in that case to avoid
+	 * inverting its lock order with mmap_lock.  Shareable mappings
+	 * still need the VMA lock to protect PMD sharing.
+	 */
+	if (!(zap_flags & ZAP_FLAG_UNMAP) || __vma_shareable_lock(vma))
+		hugetlb_vma_lock_write(vma);
 	if (vma->vm_file)
 		i_mmap_lock_write(vma->vm_file->f_mapping);
 }
--- a/mm/memory.c~mm-hugetlb-dont-lock-private-resv_map-during-final-unmap
+++ a/mm/memory.c
@@ -2268,7 +2268,7 @@ void unmap_vmas(struct mmu_gather *tlb,
 		unsigned long start = max(vma->vm_start, unmap->vma_start);
 		unsigned long end = min(vma->vm_end, unmap->vma_end);
 
-		hugetlb_zap_begin(vma, &start, &end);
+		hugetlb_zap_begin(vma, &start, &end, &details);
 		__zap_vma_range(tlb, vma, start, end, &details);
 		hugetlb_zap_end(vma, &details);
 		vma = mas_find(unmap->mas, unmap->tree_end - 1);
@@ -2304,7 +2304,7 @@ void zap_vma_range_batched(struct mmu_ga
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, end);
-	hugetlb_zap_begin(vma, &range.start, &range.end);
+	hugetlb_zap_begin(vma, &range.start, &range.end, details);
 	update_hiwater_rss(vma->vm_mm);
 	mmu_notifier_invalidate_range_start(&range);
 	/*
_


