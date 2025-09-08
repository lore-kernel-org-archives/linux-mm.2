Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C45CAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125E06B0008; Mon,  8 Sep 2025 10:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FD906B0011; Mon,  8 Sep 2025 10:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A1D6B0022; Mon,  8 Sep 2025 10:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E532E6B0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:06:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90FC8C0197
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:06:19 +0000 (UTC)
X-FDA: 83866257678.23.3AC75D2
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 712B1140011
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:06:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hmtlGjzm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of yajun.deng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757340377; a=rsa-sha256;
	cv=none;
	b=Nvzst+fAWp4XRm2yD5JBiCAKGXbu1X+DBaIkU1m7X+XYbhM5EWVwhA6M9ZZiUCW6hSqQiW
	Tn3yvl2nvQsPtIPk5YmH87zqd/kRdi58Eu2KvcKgByoKcESr+oE0bb24qJfj2984j4mZyF
	+xs7xPTfhWyRlxOOGmDKMXx/O7oXAvU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hmtlGjzm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of yajun.deng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757340377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VDoikzz6aWVYuIc2+JSxHrk0vkVl4ua3xQEWiywgjQ4=;
	b=6OSWCneU1gIVZJqw1oqdWY6eRfW9OoMvgxpmWbfNnH7okP6fPqa7tAV4rrresm37xU0zCH
	T8ucpd+BdQDC7eGcuFQsZesB5LZm9TsgMkDFNAiQwbWW4ZyGTQHv5SF72MZbK7cEwcSAkb
	r4MqqdF4Tw0SpKETziWkcEhIEKlxwIg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757340375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VDoikzz6aWVYuIc2+JSxHrk0vkVl4ua3xQEWiywgjQ4=;
	b=hmtlGjzmkfcppimA56uWjEYY1cnvcf7MPxwCd9vwT/tKgyuIdhuI9MtM1Iy3ovuS0YOXf4
	UuQJgbo6L1fW9aGeUptsvj12mEN6JNArM86CWBX1Dj0ev2zl4ZTh3B9pi+Wv9dYRNaMRnZ
	rBZI3c2C2YBuCoOY97r6hoJ6HNpCvyg=
From: Yajun Deng <yajun.deng@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yajun Deng <yajun.deng@linux.dev>
Subject: [RFC PATCH v2] mm/rmap: make num_children and num_active_vmas update in internally
Date: Mon,  8 Sep 2025 14:05:04 +0000
Message-ID: <20250908140505.26237-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 712B1140011
X-Stat-Signature: 8pf1opoab4oihjj91mnn4xngjd7qfp9c
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757340377-115440
X-HE-Meta: U2FsdGVkX19bkG2jsIBs12SdFW0/Bij880FItkxhpgOmsWUlZKIWr9/SQmQYSlQjO4EpamEpG3NGY6KTmdN9JNgOxKdYhkldRo+HDuIalGbVY5QabASB1Tl1Px/3StB+F/xSuStg2alZ+HW0RkpWUiAnQwXgpBSGzs+lY6YbOAPUvedQZPwDyQuH0oCQbGylYEd8EV15yDA7SV8rfvRBAi6ooFSVzQBXrxLLyTRJicjqo3UbhzGGX+q8j2naKsrX9jpNsL0EhDkbxBvwggjb/qQrzSGlioIQn+rK6pr26bH6cO4/+OMcV2lRHjLBaQ0baeCGC2Lc8AuI66mGBmY4IQH1ot4RykN8uZfYbG0IKGRKYuNqJUUPogBbUZlaogINHfdtL//iYllVEEXhC8jLKCoJTOXMfuSulooqE+lARUfxGmxvphApNWHeEV4/N62oBk6Zjg0NbpqBi7vE2K1NFneai7/CNt664WtJ4EpS0mwnVnvqD6AlfHL0Ikny8MHmeb25HYKmkqLmSHp0zCex+Xt0CvQUfqzRfQngmeL5Vghge1GmYKECmVFqoo9lio1OfPLqsAvy9N8xvgdGXw/Uh9iWOvr1bx0VvmTEEKqitodhJjgRFE3yZUNLaySNh3SYexLgjFOl/OnuTczjgJoMRuwhZCXM55jwRWeSMecB6f7e63VtfBa5ywj3o1qzwvwsCC6OveBnnNt1vRkUnnYqvnFFdWEANINXUsDcnt/Ivr5h1WPBXE6S2lzEbW5thyNkaSIPh6cDgRXjxHI/zZmAIdRjCB3o2BYhc097EF29YkwiaE5+0ej0VqwDRFs1YgkofEYGl7yqVSGwGGXtDcQI5EK2MOzz3iKEXp2KSie+p6uKHVtj+FJvERcmI/f4BNbcEKxAX2Bzf5RhqefxyNc2hRbl3zwVnj6O8DQUft/arwPOZNDL1xEvZ1T6gMIY71ATXoLYw/FrVkQhu6ezc2D
 9fNl1uwn
 HQlincLQEN9FqJvcmNfJvZ2v9RltjwFfIhEP0KQnZJA9dLZ3/gKptWETrcidVB5AEaxhMPevmQl7VSKmLAdliNindMXNqp4/vnpGJzzPr1LEJLPz74b2oGGCbSbYM93600O6PDmDCgld+CghB18OiIkrnc7sS2T3hnh+sehJxjelcdcLtP3UgrorJZcTLUH0KlPImcOH7/dGgZ8TJF9XpqZixdcfokVxKdV0+XYC0/3zA+cM+BLml4n/n6FrVClRyKK4MbRfPw7rwL6MluFkc3gs4PzzUiQmRUTvHrV6wAjkvzLo+jR3HJ9xaRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the anon_vma_alloc() is called, the num_children of the parent of
the anon_vma will be updated. But this operation occurs outside of
anon_vma_alloc(). There are two callers, one has itself as its parent,
while another has a real parent. That means they have the same logic.

The update of num_active_vmas and vma->anon_vma are not performed
together. These operations should be performed under a function.

Add an __anon_vma_alloc() function that implements anon_vma_alloc().
If the caller has a real parent, called __anon_vma_alloc() and pass
the parent to it. If it not, called anon_vma_alloc() directly. It will
set the parent and root of the anon_vma and also updates the num_children
of its parent anon_vma.

Introduce vma_attach_anon() and vma_detach_anon() to update
num_active_vmas with vma->anon_vma together.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
v2: fix a WARNING in unlink_anon_vmas and optimize the code
v1: https://lore.kernel.org/all/20250905132019.18915-1-yajun.deng@linux.dev/
---
 mm/internal.h | 17 ++++++++++++++
 mm/rmap.c     | 64 +++++++++++++++++++++++++++++----------------------
 2 files changed, 53 insertions(+), 28 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 9b0129531d00..12bc71bb2304 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -953,6 +953,23 @@ static inline bool free_area_empty(struct free_area *area, int migratetype)
 	return list_empty(&area->free_list[migratetype]);
 }
 
+static inline void vma_attach_anon(struct vm_area_struct *vma,
+				   struct anon_vma *anon_vma)
+{
+	mmap_assert_locked(vma->vm_mm);
+	lockdep_assert_held_write(&anon_vma->root->rwsem);
+	vma->anon_vma = anon_vma;
+	vma->anon_vma->num_active_vmas++;
+}
+
+static inline void vma_detach_anon(struct vm_area_struct *vma)
+{
+	mmap_assert_locked(vma->vm_mm);
+	lockdep_assert_held_write(&vma->anon_vma->root->rwsem);
+	vma->anon_vma->num_active_vmas--;
+	vma->anon_vma = NULL;
+}
+
 /* mm/util.c */
 struct anon_vma *folio_anon_vma(const struct folio *folio);
 
diff --git a/mm/rmap.c b/mm/rmap.c
index 34333ae3bd80..de557707c34a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -86,15 +86,25 @@
 static struct kmem_cache *anon_vma_cachep;
 static struct kmem_cache *anon_vma_chain_cachep;
 
-static inline struct anon_vma *anon_vma_alloc(void)
+static inline struct anon_vma *__anon_vma_alloc(struct anon_vma *parent)
 {
 	struct anon_vma *anon_vma;
 
 	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
-	if (anon_vma) {
-		atomic_set(&anon_vma->refcount, 1);
-		anon_vma->num_children = 0;
-		anon_vma->num_active_vmas = 0;
+	if (!anon_vma)
+		return NULL;
+
+	atomic_set(&anon_vma->refcount, 1);
+	anon_vma->num_children = 0;
+	anon_vma->num_active_vmas = 0;
+	if (parent) {
+		/*
+		 * The root anon_vma's rwsem is the lock actually used when we
+		 * lock any of the anon_vmas in this anon_vma tree.
+		 */
+		anon_vma->parent = parent;
+		anon_vma->root = parent->root;
+	} else {
 		anon_vma->parent = anon_vma;
 		/*
 		 * Initialise the anon_vma root to point to itself. If called
@@ -102,10 +112,18 @@ static inline struct anon_vma *anon_vma_alloc(void)
 		 */
 		anon_vma->root = anon_vma;
 	}
+	anon_vma_lock_write(anon_vma);
+	anon_vma->parent->num_children++;
+	anon_vma_unlock_write(anon_vma);
 
 	return anon_vma;
 }
 
+static inline struct anon_vma *anon_vma_alloc(void)
+{
+	return __anon_vma_alloc(NULL);
+}
+
 static inline void anon_vma_free(struct anon_vma *anon_vma)
 {
 	VM_BUG_ON(atomic_read(&anon_vma->refcount));
@@ -201,7 +219,6 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 		anon_vma = anon_vma_alloc();
 		if (unlikely(!anon_vma))
 			goto out_enomem_free_avc;
-		anon_vma->num_children++; /* self-parent link for new root */
 		allocated = anon_vma;
 	}
 
@@ -209,9 +226,8 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	/* page_table_lock to protect against threads */
 	spin_lock(&mm->page_table_lock);
 	if (likely(!vma->anon_vma)) {
-		vma->anon_vma = anon_vma;
+		vma_attach_anon(vma, anon_vma);
 		anon_vma_chain_link(vma, avc, anon_vma);
-		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
 	}
@@ -355,38 +371,31 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	if (vma->anon_vma)
 		return 0;
 
-	/* Then add our own anon_vma. */
-	anon_vma = anon_vma_alloc();
-	if (!anon_vma)
-		goto out_error;
-	anon_vma->num_active_vmas++;
 	avc = anon_vma_chain_alloc(GFP_KERNEL);
 	if (!avc)
-		goto out_error_free_anon_vma;
+		goto out_error;
+
+	/* Then add our own anon_vma. */
+	anon_vma = __anon_vma_alloc(pvma->anon_vma);
+	if (!anon_vma)
+		goto out_error_free_avc;
 
-	/*
-	 * The root anon_vma's rwsem is the lock actually used when we
-	 * lock any of the anon_vmas in this anon_vma tree.
-	 */
-	anon_vma->root = pvma->anon_vma->root;
-	anon_vma->parent = pvma->anon_vma;
 	/*
 	 * With refcounts, an anon_vma can stay around longer than the
 	 * process it belongs to. The root anon_vma needs to be pinned until
 	 * this anon_vma is freed, because the lock lives in the root.
 	 */
 	get_anon_vma(anon_vma->root);
-	/* Mark this anon_vma as the one where our new (COWed) pages go. */
-	vma->anon_vma = anon_vma;
 	anon_vma_lock_write(anon_vma);
+	/* Mark this anon_vma as the one where our new (COWed) pages go. */
+	vma_attach_anon(vma, anon_vma);
 	anon_vma_chain_link(vma, avc, anon_vma);
-	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
 	return 0;
 
- out_error_free_anon_vma:
-	put_anon_vma(anon_vma);
+ out_error_free_avc:
+	anon_vma_chain_free(avc);
  out_error:
 	unlink_anon_vmas(vma);
 	return -ENOMEM;
@@ -420,14 +429,13 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 		anon_vma_chain_free(avc);
 	}
 	if (vma->anon_vma) {
-		vma->anon_vma->num_active_vmas--;
-
 		/*
 		 * vma would still be needed after unlink, and anon_vma will be prepared
 		 * when handle fault.
 		 */
-		vma->anon_vma = NULL;
+		vma_detach_anon(vma);
 	}
+
 	unlock_anon_vma_root(root);
 
 	/*
-- 
2.25.1


