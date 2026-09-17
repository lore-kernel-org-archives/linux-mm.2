Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7410C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 19:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E51AF6B0093; Thu, 17 Sep 2026 15:48:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C8B6B0095; Thu, 17 Sep 2026 15:48:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D183F6B0096; Thu, 17 Sep 2026 15:48:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB7776B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 15:48:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3CCC4140470
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:48:17 +0000 (UTC)
X-FDA: 85224290634.13.86DDA09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7832820003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:48:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ND4CNBlX;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789674495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62s9qkXq6r17IuwiNPx+api5etWusepzLRBx4u3FLR4=;
	b=F8LldJ3Jo3/1uDjROPUHuqf8g8SeoGBmNmzGCjw5l+jL2WiwofZ4YUU+Kr6ttDxQ9wtQ+8
	oy8BIipnXzunocQi1o9terxNkuSQ9yxjToI6Hvt8mbNj4VAortKcIAoq7Oj1zpYjZCVQ1V
	v7hkIYkGQQC5/Ora5NOHNaOciHbdvAk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789674495;
	b=qQWGhgla3FYKOlbBiEcjfsIbeVL7NwHw9Ip8hd2COIXC4C/pflpIjNHdsXhHWHDJFLWZye
	k3NWfWZ/rHtx3kY3S+EKUXmZq15fMpMWReab7FHtqfg50slZPcqgO9stfxkK6+s1tE5P3x
	TgoZdd3wD72KyyP5IvMNVUfPy93B7L8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ND4CNBlX;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1818B6020C;
	Thu, 17 Sep 2026 19:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6AA1F00893;
	Thu, 17 Sep 2026 19:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789674494;
	bh=62s9qkXq6r17IuwiNPx+api5etWusepzLRBx4u3FLR4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ND4CNBlXtyj77nav8hEVmG2jfavMgyjiDYBFcaBqvISYMRdlgUaKK6dKJGLKPlL/S
	 f82ud7i4gFmufXGzFcFLWIi46VHHpl3s0qzWO+XjQnzdFN2sATVOFuAQuJCUQAKHEz
	 3Bc26ykBomOzbOTFyEVOyTKRhlJW2n6T1Na7HsxTUcHh7v+2t3v3SG/57As6y+VoTY
	 QqCahhK9tkOyyYEH5kiSpzMlS8NQAFK/2pRn5UE4f84BV7TbXLwbn58jPWEDgVG75O
	 PRYca0Zyqe8QzejEXH9GnqM6le8kZ9GIOxqlnHMMRvzZfWBOQ8jEGMBhydcayxh8tp
	 XbOuCFDlFrrYA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 17 Sep 2026 20:47:41 +0100
Subject: [PATCH v3 1/3] mm/vma: const-ify vma_assert_stabilised() and
 associated functions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-vma-is-faulted-v3-1-5c22314a72e7@kernel.org>
References: <20260917-vma-is-faulted-v3-0-5c22314a72e7@kernel.org>
In-Reply-To: <20260917-vma-is-faulted-v3-0-5c22314a72e7@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3347; i=ljs@kernel.org;
 h=from:subject:message-id; bh=vloWjrSgn5PFdU4AaKDJGM/wu9+6TuZ0V219iHLmchc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLWOL9c29Prv+7T2mnMn/Q4Vv77selyisGDM7/iMmTXh
 hyOuqvO0lHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJhAkxMmx7e5P7qg3P67sr
 uy+xvwjSk1u579IWk+pLDudzc1ZmT7vP8FfqR/KNbXaF8ybPnMpzdLH4sVOHm+ZM9DhaFC18dH/
 ERjVOAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 4fqjzg6mbujnicf78xy3oqsqtjt3kgr7
X-Rspam-User: 
X-Rspamd-Queue-Id: 7832820003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789674495-718594
X-HE-Meta: U2FsdGVkX187I8UxjC7UQw5DD+8qZQapojzQfo30BxHULtIaYkdb/lawHPpJIn/pj5pLrOQhR3Bz11ki6rzudBa3cf4H6eqWmGgh+RCxyHb7MsEdrRkNJrXE4BxPDNm6OTc94DSN+ovKcrnjInUqAeolY/Nb5eA2rGR7nk3Ja8zz2MZ88qGP3ATF7GDHx2wotoufWTwG8bJ2doAJciWsa7vS594/xqx8+5nEdoiSb+J3nHeicDpF1l2KWyBa72VVJ62QGAwYs5+O6LW+tzmisN0vrruIxO90EDcKHuz4dxgtML+/3clLKrkXc0kdAzMmUGIYRIXIrGCi8BfiR+PYBKolT7lo/9w3PnUzefXUb3QqhU9VT3mROhccAz63Uyj5ZBXjS1pEkNuiu72uhX6oCHK5KYiWGIIEfdcwHlA90lmm5ta8/N8DrLkD8iHAnboTl+Ryt6hqjOzoCg9mb0GBhY9AA1SZUTSO2QSWu66nfne1pcC7r2GqePyckIjhcpS6GT6a1OGaO7NpV1F9oc72gFkJCDCdBCoozyERzfpqzUN1qbCByJ/sT/PyH/1gFGzlM/pjdQTNW8ZMMo67rRizcTJZanz+1ey6ksvSQchclF0MxGSgqCxFwhhDIkQchV+EcCQEbuHVNBVhPtPbeDfugGt2x6MCVal1EvXnR5W2NjarxUt4EjxmKD1Gsc8A38Y5MVjWFlPy+ZZTTGRrubxdjufPz+nEpJvvE2vO8TrTu3ob22riqf9m6mSeLb/h3Og0XAAgBcFa5pDjP6U08Zo8CkwYVvaqcWnpljpigod8p5bZEIh73SxqPH1AwbRXHK3o2lwhe/oP9qHtFwaT6EHuWfqKCWhN8Yu+dzZwOXpGDHaRaINaeFWmk4O5NoWt5Bdq7M1MDQA8ASbl4hb4mLuXiD9453LKwKmpsKzydMbGRfRL4sHG4/ieBIWXjEmL9eiL1x7dUwH2XgEnJ5qNCHb
 FwONbDwe
 ilFhx+wBF2EJ1cTd/KB2c3wAOBXb15AMoTd0nagO8At3d0X9hzvxBhz3S2j/Q4p/7s54cghgsdpkx26BimvWfB+xBWHGMh9UKwO49VWg55dpNm6A9M3a919y9ij0rERlvlTPyPQ1KRxJwDJ4ew7/FMf9QzSETvldrmWC3A73mxydFuefoxIkjTkYLKFkEVNM4XeJam9T4ztc6CkpFRqppJX1HrdjwqeXqIpL5lfajnxV4wlXfNuZZxzHi3Y1JqPorcj4AWTwoeWtZTC85DITAYeX+agnMyJ8y1yJ1QHV4ML36iSlrEkwC9dEKCC36/kJPBRfK/6OTVYcNxTgYa99ULU5jPH3hmO/t4XKgxBBQgHybJ7x3QSOrrS4mKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vma pointers are not modified in any of these functions so make it
official by const-ify them.

Propagate this throughout the call stack.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mmap_lock.h       | 12 ++++++------
 tools/testing/vma/include/dup.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 00eae65b74bd..03e1eb136111 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -273,7 +273,7 @@ static inline void vma_end_read(struct vm_area_struct *vma)
 	vma_refcount_put(vma);
 }
 
-static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
+static inline unsigned int __vma_raw_mm_seqnum(const struct vm_area_struct *vma)
 {
 	const struct mm_struct *mm = vma->vm_mm;
 
@@ -288,7 +288,7 @@ static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
  *
  * Returns true if write-locked, otherwise false.
  */
-static inline bool __is_vma_write_locked(struct vm_area_struct *vma)
+static inline bool __is_vma_write_locked(const struct vm_area_struct *vma)
 {
 	/*
 	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
@@ -344,7 +344,7 @@ int vma_start_write_killable(struct vm_area_struct *vma)
  * vma_assert_write_locked() - assert that @vma holds a VMA write lock.
  * @vma: The VMA to assert.
  */
-static inline void vma_assert_write_locked(struct vm_area_struct *vma)
+static inline void vma_assert_write_locked(const struct vm_area_struct *vma)
 {
 	if (!IS_ENABLED(CONFIG_MMU)) {
 		mmap_assert_write_locked(vma->vm_mm);
@@ -359,7 +359,7 @@ static inline void vma_assert_write_locked(struct vm_area_struct *vma)
  * lock and is not detached.
  * @vma: The VMA to assert.
  */
-static inline void vma_assert_locked(struct vm_area_struct *vma)
+static inline void vma_assert_locked(const struct vm_area_struct *vma)
 {
 	unsigned int refcnt;
 
@@ -410,7 +410,7 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
  * With lockdep disabled we may sometimes race with other threads acquiring the
  * mmap read lock simultaneous with our VMA read lock.
  */
-static inline void vma_assert_stabilised(struct vm_area_struct *vma)
+static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
 {
 	/*
 	 * If another thread owns an mmap lock, it may go away at any time, and
@@ -445,7 +445,7 @@ static inline void vma_assert_stabilised(struct vm_area_struct *vma)
 	vma_assert_locked(vma);
 }
 
-static inline bool vma_is_attached(struct vm_area_struct *vma)
+static inline bool vma_is_attached(const struct vm_area_struct *vma)
 {
 	return refcount_read(&vma->vm_refcnt);
 }
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 16c09dac59d9..17505bcf9cf6 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1179,7 +1179,7 @@ static inline struct vm_area_struct *vma_next(struct vma_iterator *vmi)
 	return mas_find(&vmi->mas, ULONG_MAX);
 }
 
-static inline bool vma_is_attached(struct vm_area_struct *vma)
+static inline bool vma_is_attached(const struct vm_area_struct *vma)
 {
 	return refcount_read(&vma->vm_refcnt);
 }

-- 
2.55.0


