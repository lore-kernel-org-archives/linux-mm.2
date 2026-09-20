Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D34C982D8
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 14:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E384D6B008A; Sun, 20 Sep 2026 10:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBFE56B008C; Sun, 20 Sep 2026 10:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C86906B0092; Sun, 20 Sep 2026 10:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 977496B008A
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:13:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE1FDA0453
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:13:38 +0000 (UTC)
X-FDA: 85234333716.11.5791088
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1738B40007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 14:13:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OWv++KQH;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789913617;
	b=1qcRcJadUax77G7By3yO0H1rLQmzWXrOx4BoCHyy5TS0+O9g/S5FNTonBb+se6rau/Nphv
	adQuS3UUP1a3F9U0rULrMPXdnyZ3cQGiP4EVy+UaebvwreekyHUenqADW6PtXy/4a/Vpeh
	unkCki4TvHhwKZ8WTcqR8nvI7BE4/B0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OWv++KQH;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789913617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wuTTB08dUEw+auFKFpO6hUoO88RZSfTJOEDWI/SO6ck=;
	b=0DPt4y3XwaYbhGrhsC+jAb8fdoRI0acpOQQoenxYclG6MkY02gNMTLJ1e6QKcq34aJLMHS
	XfilquPAWXQNiqfKV5hUwryDtEUtn/Qzre4jxJ6T5pCZzAxm6t0FzmsRTC1LGT4iMvCtI9
	RjeTBs17fA+8nUT4HL/MJrqVVmcrOZQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A1350601F9;
	Sun, 20 Sep 2026 14:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84871F00893;
	Sun, 20 Sep 2026 14:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789913616;
	bh=wuTTB08dUEw+auFKFpO6hUoO88RZSfTJOEDWI/SO6ck=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OWv++KQHYKsrJTLCNMAywUPNOYbKv4lS6Yb4rf2jm77yyS86ot95L3nLZJYOxx/Tb
	 YYPhL2Q1xnx/AoOPImjKgqJb7SuOEndoICWeA+zDq0IpQsZ2RCu6ruBLe5HEO97y9l
	 0FaEDgaWEa0GbPGM0N+JK4W28977b3AA5NIUu2XpQGwa3luOr1FdMxbfmhG4VqEDHo
	 PJDhqv3kGfYia8X/A6+V6/D7m4T/ooqu4csKi0lGDwKYcjbC8Obwm7Ie8pub8jSvti
	 lpUubk43vg7ZAucfM9SmzJRTnbCXEQHL1EVkFkp1YtQgx+A1PFoIz5nLUHxYtD5SMZ
	 Vy025jNvpbglQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sun, 20 Sep 2026 15:13:10 +0100
Subject: [PATCH 1/2] mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP
 self-merge
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-fix-dontunmap-partial-self-merge-v1-1-6ffb556f8f8b@kernel.org>
References: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
In-Reply-To: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
 Kiryl Shutsemau <kas@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=7383; i=ljs@kernel.org;
 h=from:subject:message-id; bh=7NKK0j5EusrBCNKL26BUuITRpi+S9GQj7txy+LzBAXE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWv+LUExRWZZg7dfWU04ciVW7JrD67S67ESGuX7cbLe
 rrvVa+md5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAinz8xMmx/7SX676+F3kTH
 PUctGPj03dkVl+Wx8er9tko0lQliZWX4nxKpr8K0OMBeeH3wui0Pqn4qzrq1U/rKlakNK03nnjI
 6yQgA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1738B40007
X-Rspam-User: 
X-Stat-Signature: qzpnadcsp3dr8y5dx74itcymeqkonwss
X-HE-Tag: 1789913616-649222
X-HE-Meta: U2FsdGVkX18sZ+hlWNQGJtUoFAehuyT/HwWS59DhdXw/glUFghgvTe3av6c24HI2JE6LGWHoAtBxHmFGJhOfq9FwcvO7g7FV4ItPU0Q9zT7LXmgW4tWdWim7zCHYKgisOo4mMckiBD3AgF2OvgUdDcDQOHtnXzM+1Ibdbc91f0wz8muKqhQSYQS3ukNrsSRTidHwT3fMnPgjJY54Ox0LaERJvee1c31CKoHH4XtM8ihtxZ8ov1RtUX3KuPo8TXh0YqVsDFvFPkSop1A2YCmxrJmUPfc+iaqWUIGg31H/Aih9lR617pOl61e07QQoECACQJ4Iqmg33b7aj6bYZt8eFaLK2eFJkVQ5CJs/4Qe3vvMD2azknN8FumcSGsN9zObDWgMry27xcrtHAH3+O47iddj4dhscsuDkE8GwyGj7ktlNUoCzHFGpP3bCf5PkJ9Bt0shtUBEedkaIZXxO+S2NDN6xfGaFwDLhQR3bbVWMIGJZdPczW204KWz65z98uGyMHD2YRiLJsFTV7pLov7lHdwfhLVpywdeGg1znRB466BSFLT0P8U/wpM6YQe4GxowwTetRABxOvMKhU42Z67J/+muuZrRyfvT+12qYBZGnYQaH0pudJM/G4suY7TAkKbUFK5wh1/dhYlfK0ySFdAlRrfvCjXN5zpEXaKuD8wR/knuZnCXwIciO4kVw0OOE0e57oBK3SJAvgloMJu2OpEOYRNzQWrGyw/w/cBtl8Cbd3V+9HIfdtaEJQvA6Np6lP1TP+Ro21apMx9k0to7BdE2RUTImj4X1pwUa7AAhNxbOyNkYn2jei1Mdjczogjp+jb1p209GH+6mmQYDt8XRCJUKHjTGTuAF6tI2I6Q0851vle6jrRplfeU3eZj7yx2KzdDh+keYG5jk66ePOx+UoGs662U8DYEuh/LbPZxvOPHS6GprypMjo/VKG1YDfAxFs9MCvN7n1DbkRQ/+MWk0CWL
 EbY5u2eH
 hqwf1GAw4+thDeHIltLd2o62QIDyLRB18Bknnklb2cwjHCkHZ8PEanBs5YPtYH/NkfCy6OmhzEMepgE3vouLFDvFJdyC7Pvnl7o/yjBh7BnLXaUOkHbxFgh1zoh+JTJdpWhvl+AAEUGgKD0u9zqhSbgwIzOSObX1rYRaa4ATAI5X1taVws1O1l+ksZD9Ip9UyNraviG62sV2r+dwBrdJ/noQ7A2BeZkE1TbHxVPy7H4Yo5yrdu4SiDPmAQejD2V8RzgF0w/bllzlL341VDRapy/rWY1ToF9tqpKaT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
operations that keep the original VMA in place.

Historically this has led to a lot of bugs where non-obvious interactions
occur between existing mremap() operations and the original VMA.

Fix another of these - self-merge.

Self-merge occurs when a VMA is moved in front of or behind itself and the
attributes of the VMA permit such a merge.

Practically this can only happen for unfaulted anonymous VMAs due to the
page offset equality requirement for merge:

                           |------------|
                           |            |
                           |            v
        |...........||-----------||...........|
        |           || unfaulted ||           |
        |...........||-----------||...........|
              ^            |
              |            |
              |------------|

This becomes problematic if the VMA is configured by the user to
mlock-on-fault, i.e. the VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT VMA flags are
set.

MREMAP_DONTUNMAP clears mlock flags for the source VMA and maintains them
for the destination VMA.

Self-merge makes this impossible (there is only one VMA) and incorrectly
clears the destination VMA's mlock flags.

This causes a leak in mm->locked_vm as clearing this flag does not
decrement the counter and the VMA no longer has VMA_LOCKED_BIT set so it
is not decremented on unmap.

Resolve this by simply disallowing a self-merge in this case - the source
and destination VMAs are kept distinct and then are able to have distinct
mlock() flags.

Update dontunmap_complete() to make the now-redundant self-merge check a
VM_WARN_ON_ONCE() instead to guard against future regressions.

Also update the VMA userland tests to reflect the change.

Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/mremap.c                   |  8 ++++++--
 mm/vma.c                      | 17 ++++++++++++++++-
 mm/vma.h                      |  2 +-
 tools/testing/vma/tests/vma.c | 10 +++++-----
 4 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 1122282a1d6a..73f52c45705c 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1275,7 +1275,8 @@ static int copy_vma_and_data(struct vma_remap_struct *vrm,
 	PAGETABLE_MOVE(pmc, NULL, NULL, vrm->addr, vrm->new_addr, vrm->old_len);
 
 	new_vma = copy_vma(&vma, vrm->new_addr, vrm->new_len, new_pgoff,
-			   new_anon_pgoff, &pmc.need_rmap_locks);
+			   new_anon_pgoff, &pmc.need_rmap_locks,
+			   vrm->flags & MREMAP_DONTUNMAP);
 	if (!new_vma) {
 		vrm_uncharge(vrm);
 		*new_vma_ptr = NULL;
@@ -1335,6 +1336,9 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
 	unsigned long old_start = vma->vm_start;
 	unsigned long old_end = vma->vm_end;
 
+	/* Self-merge is disallowed. */
+	VM_WARN_ON_ONCE(new_vma == vma);
+
 	/* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
 	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
 
@@ -1342,7 +1346,7 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
 	 * anon_vma links of the old vma is no longer needed after its page
 	 * table has been moved.
 	 */
-	if (new_vma != vma && start == old_start && end == old_end) {
+	if (start == old_start && end == old_end) {
 		const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
 
 		unlink_anon_vmas(vma);
diff --git a/mm/vma.c b/mm/vma.c
index 0db3f1222cad..55d4d0939129 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1946,7 +1946,7 @@ static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
  */
 struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	unsigned long addr, unsigned long len, pgoff_t pgoff,
-	pgoff_t anon_pgoff, bool *need_rmap_locks)
+	pgoff_t anon_pgoff, bool *need_rmap_locks, bool keep_source)
 {
 	struct vm_area_struct *vma = *vmap;
 	unsigned long old_vma_start = vma->vm_start;
@@ -1984,6 +1984,21 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	vmg.pgoff = pgoff;
 	vmg.anon_pgoff = anon_pgoff;
 	vmg.next = vma_iter_next_rewind(&vmi, NULL);
+
+	/*
+	 * If the original VMA is kept (MREMAP_DONTUNMAP), the source and
+	 * destination VMA must be treated distinctly.
+	 *
+	 * A merge violates this, so in this case disallow a self-merge.
+	 */
+	if (can_self_merge && keep_source) {
+		if (vmg.prev == vma)
+			vmg.prev = NULL;
+		if (vmg.next == vma)
+			vmg.next = NULL;
+		can_self_merge = false;
+	}
+
 	new_vma = vma_merge_copied_range(&vmg);
 
 	if (new_vma) {
diff --git a/mm/vma.h b/mm/vma.h
index b2c3bc832a48..03ed8afd0c1f 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -534,7 +534,7 @@ void unlink_file_vma_batch_add(struct unlink_vma_file_batch *vb,
 
 struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 	unsigned long addr, unsigned long len, pgoff_t pgoff,
-	pgoff_t anon_pgoff, bool *need_rmap_locks);
+	pgoff_t anon_pgoff, bool *need_rmap_locks, bool keep_source);
 
 struct anon_vma *find_mergeable_anon_vma(struct vm_area_struct *vma);
 
diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index c8ef7b8cd46b..e973e0a6d1a8 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -40,7 +40,7 @@ static bool test_copy_vma(void)
 	vma = alloc_and_link_vma(&mm, 0x1000, 0x2000, 1, vma_flags);
 	vma_set_anonymous(vma);
 	vma_orig = vma;
-	vma_new = copy_vma(&vma, 0x2000, 0x1000, 1, 1, &need_locks);
+	vma_new = copy_vma(&vma, 0x2000, 0x1000, 1, 1, &need_locks, false);
 	ASSERT_EQ(vma_new, vma_orig);
 	ASSERT_EQ(vma, vma_orig);
 	ASSERT_EQ(vma_new->vm_start, 0x1000);
@@ -53,7 +53,7 @@ static bool test_copy_vma(void)
 	vma = alloc_and_link_vma(&mm, 0x2000, 0x3000, 2, vma_flags);
 	vma_set_anonymous(vma);
 	vma_orig = vma;
-	vma_new = copy_vma(&vma, 0x1000, 0x1000, 2, 2, &need_locks);
+	vma_new = copy_vma(&vma, 0x1000, 0x1000, 2, 2, &need_locks, false);
 	ASSERT_EQ(vma_new, vma_orig);
 	ASSERT_EQ(vma, vma_orig);
 	ASSERT_EQ(vma_new->vm_start, 0x1000);
@@ -71,7 +71,7 @@ static bool test_copy_vma(void)
 	vma = alloc_and_link_vma(&mm, 0x3000, 0x4000, 3, vma_flags);
 	vma_set_anonymous(vma);
 	vma_orig = vma;
-	vma_new = copy_vma(&vma, 0x2000, 0x1000, 3, 3, &need_locks);
+	vma_new = copy_vma(&vma, 0x2000, 0x1000, 3, 3, &need_locks, false);
 	ASSERT_NE(vma_new, vma_orig);
 	ASSERT_EQ(vma_new, vma);
 	ASSERT_EQ(vma_new->vm_start, 0x1000);
@@ -82,7 +82,7 @@ static bool test_copy_vma(void)
 	/* Move backwards and do not merge. */
 
 	vma = alloc_and_link_vma(&mm, 0x3000, 0x5000, 3, vma_flags);
-	vma_new = copy_vma(&vma, 0, 0x2000, 0, 3, &need_locks);
+	vma_new = copy_vma(&vma, 0, 0x2000, 0, 3, &need_locks, false);
 	ASSERT_NE(vma_new, vma);
 	ASSERT_EQ(vma_new->vm_start, 0);
 	ASSERT_EQ(vma_new->vm_end, 0x2000);
@@ -95,7 +95,7 @@ static bool test_copy_vma(void)
 
 	vma = alloc_and_link_vma(&mm, 0, 0x2000, 0, vma_flags);
 	vma_next = alloc_and_link_vma(&mm, 0x6000, 0x8000, 6, vma_flags);
-	vma_new = copy_vma(&vma, 0x4000, 0x2000, 4, 4, &need_locks);
+	vma_new = copy_vma(&vma, 0x4000, 0x2000, 4, 4, &need_locks, false);
 	vma_assert_attached(vma_new);
 
 	ASSERT_EQ(vma_new, vma_next);

-- 
2.55.0


