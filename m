Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF18C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FDE66B00DB; Fri, 17 Jul 2026 14:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D43E6B00DD; Fri, 17 Jul 2026 14:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EAEB6B00DE; Fri, 17 Jul 2026 14:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA65E6B00DB
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:24:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4016EC0218
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:24:14 +0000 (UTC)
X-FDA: 84999093228.24.751B313
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9A15A1C0007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:24:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nok5y9V7;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784312652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkiX41oRUtbyELsD72Aha5EOEJUotYzdMaBBIICRLMU=;
	b=0KeSAHZiqIK1G/rfU9C2qdfxuoXkPZT/of+3+ntII5oXGgFZ0UAsHc//T4/lAqXg1GUdKR
	VqryHM6IoZ6dD2eV6q8nSozaMxe0nrkhqGiPPCZEhtDHgYbXyxBUw7C22zonW42zRFWkvY
	kREvMAFSnNOXbbplQ8z05RiQU0SivhY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nok5y9V7;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784312652;
	b=jZ/r6uh2/ZWgAe7T+LHZX8l8EftAe13THjiXEF7B1SfJ18vYrarOFMSQBjklIDGlDagR7f
	OcknfQbLBaX6BwQ349DXlgtzEymtgVIII918YmEhOw2epWO4YZFvGCCqnOlVHQ+LPvptNc
	mEtSbuTglIs+y8pZzMMRipdT0VpPF14=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 270E560A79;
	Fri, 17 Jul 2026 18:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0311F000E9;
	Fri, 17 Jul 2026 18:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784312652;
	bh=KkiX41oRUtbyELsD72Aha5EOEJUotYzdMaBBIICRLMU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Nok5y9V7uz97J68uVLNxkH9lWj0x2uAj7uK5VE0cKXSiIYTR/bogQ4ikpvYEEJnXz
	 NrVinhIg3yTbgiWfyStlcb8GWIt6LRFzjNX0iRmVzJSZpyO02oJLyo8hHnMTP/UFKs
	 +91eaKvRooR1qs76/DtIuE+9w1whqb86KouOz754CZmJt/64FB8mFMBrXfxx1qES/w
	 nplHl1qI86bWKKMhcsdLFVSGVMaWJZYrsXllxvcsfJofyLaQNGmDiiSUCAs1ZzqPBI
	 uMHsMSsJUtBE2mv18kPAIUeSscuCfo7hLx+rZb7BFYEY11dvgtciWupXWzDPg7Hd2F
	 DBCsiaKDltn9Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 19:19:51 +0100
Subject: [PATCH 13/15] mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings
 truly anonymous
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-scalable-cow-virt-pgoff-v1-13-cf24910ef094@kernel.org>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4776; i=ljs@kernel.org;
 h=from:subject:message-id; bh=C4IaEx/DcAW96RFPFZ/bWWEFrGWe3/+6S/w8PUQQWRk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKiivZ9VN962Us85H6JBdP+UpEo98o/NdE83AdOdbfWm
 kSFr7fpKGVhEONikBVTZHn+RXx/kEjYvM4L/m4wc1iZQIYwcHEKwEQOTmb4X/Dc+NG7De5Mf6KD
 Kk5G/ORgOGrvUKZ0/vNhs/xgzbBZcxj+u66a+ml1oLxcv+X5TKF/JyNjpmR+L18cFrtzb/2lVXZ
 bGQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9A15A1C0007
X-Stat-Signature: umridtpgpmtbq4jn3j666nbo8wm9pd8y
X-HE-Tag: 1784312652-853268
X-HE-Meta: U2FsdGVkX1/snNQkiQRyeYrrzYoypbIHS91PTT7U1cCcFL5c5MqupNT3eG6/fyPxF0MJAqnSYYtVKR025H+MTt8t5KrTX9eOYxTnTil9aCj08sgoMxchvgjtZRHE44CLfwOZv1OvrfowUgc/8gOIWyaiOubg9gutOHtVwDLiw3ZL3nKxDjW5ioM/e/lMEaSXSgFSiXagbWS0qoKzN3y7t58dpfh9Fkhmzw9HlvGT9EPxImlgPJWV4QP+gwcH8fb3T8otG4JXvIl/nFam5VSHXtM63a1nlqCIlnyDT0uY5NwHMKF397zrL9cvHG3OTpg5i2r/ZpKShU2F2NVFouGC8D+dZ1igltfs7kLoPRg7wtLVCR9y7GpbPUIQigtDamHAauaOi7eJJ6WGsagAG+yyk02rFhHn29tq6GWWMyHW7xl5TwL7SZvhUBl3fqWtP1z6mSoHFMb7wSa0dSBPf9Uhe6hbY1KZQuW6sFb2L/D/TitB4cIWXHhSD3MNCs+M1D45uBiZtQTZFqtlSoJbTtkALlQ693Kerxqar08V0wcvYxGxn1OKXEyiFEOkGP/DUrJrHvwo1xrz1y7Iavczu5toJNWoyTa4aPU9Pf7fofPZFeKs7ycRVcJMPZ0FrdNFxkhku/ccv76/9kGyzQhv/VFQlxxE0NdO+cc5Kv8L+cyc68ZACoZISxNb3d+C67dpUTocKmH+OZQ+OHVuZNKyFLRpO+Db28JNhEULK2KYetGQy9KkoQwXoRa0zgeA8b9x3joy/Ln7f4lnpwUpASdZ3uYYYCPvHPK+H4NQr6uDWaehb10u63rHn/vfbM161AQiCce20HxRGTTbEdATLhH9p6jzyByOKoik7hNR5+wsp+3D9j4ZEGk7dwtzkqJcrWqYq7hKXbjBQQthT+ZYsnrkOuT48RwYlSdeRSLtXY+jUl3WjTf4zsyqcvZINtVjHJmslsC6xI7A3+zyrOSGs+wAKZl
 7M7JWec1
 eXPopOBeqav345CMtiW78eg7N25JnokIFb5tguHk8tQ7KRdPd3LApkLmiG7Z0m19nVgQV9JliJvoUfE85gpZsFtPLuKRnUYZ5qMwZXofC3BlFn8HUlvsvuKcx/q2CnvdN7jo7RGx5gEuLKjL+f9vdHUWFbTZ9/52hDfARJON+WGwu4wjBcOt87VDLUT4zoqloJ1PSc2G44wqo4XqbRZC1YCY8lqNS0Q3oCgmmnBw2YStYMX64q+I73Et0dix4MjUwLO22ioRfzYKSxBR0GcpPw8zVm5xsQFcEPKgSEVnIahWmRyteqNACtDXDBx5htwlRWgnakvjP7l1r5dIV/1jujmnicyBluV0Qk48ue1hDtB3bZVHxXHONdhoohg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When mapping /dev/zero with MAP_PRIVATE, one ends up with strange VMAs
originating from Linux's distant past.

These have vma->vm_file set but NULL vma->vm_ops, meaning they satisfy
vma_is_anonymous() but otherwise resemble a file-backed VMA.

The introduction of virtual page offsets and their subsequent use as
indexes for MAP_PRIVATE-file-backed mappings mean the rmap does the right
thing with these but we are left with inconsistencies.

The vma_start_pgoff(vma) == vma_start_virt_pgoff(vma) invariant is true for
all other anonymous VMAs, but not these.

These VMAs are also observable as files in /proc/<pid>/[s]maps but
otherwise behave like anonymous mappings.

Therefore let's make these VMAs actually anonymous at mapping time which
will activate the anonymous code path for mappings.

This means we no longer have to account for this discrepancy anywhere and
no longer have to think about these at all.

A previous commit gave us map_is_dev_zero() to positively identify these
mappings, so we expressly only do so for these alone.

The impact of this change should be low as likely very few are relying upon
this in any case, and in using them are asking for anonymous memory, so no
longer seeing these as file mappings in smaps should have no meaningful
impact.

Update assert_sane_pgoff() and the comment for vma_start_pgoff() to reflect
the change.

We make this change in call_mmap_prepare() alone as /dev/zero has been
converted to an mmap_prepare hook and we do not permit nested MAP_PRIVATE
mapping of /dev/zero.

We also remove the now defunct vma_desc_set_anonymous().

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h | 10 ++--------
 mm/vma.c           | 21 +++++++++++++++++----
 mm/vma.h           |  3 ---
 3 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7614afe99c96..7fabe6c66b4b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1554,11 +1554,6 @@ static inline void vma_set_anonymous(struct vm_area_struct *vma)
 	vma->vm_ops = NULL;
 }
 
-static inline void vma_desc_set_anonymous(struct vm_area_desc *desc)
-{
-	desc->vm_ops = NULL;
-}
-
 static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
 {
 	return !vma->vm_ops;
@@ -4352,9 +4347,8 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
  * If @vma is a MAP_PRIVATE file-backed mapping, then this returns the
  * page offset within the file.
  *
- * Edge cases: nommu does not abide by these, MAP_PRIVATE-/dev/zero satisfies
- * vma_is_anonymous() but has file-backed page offset, and MAP_PRIVATE-pfnmap
- * regions have their page offset set to the first PFN in the range.
+ * Edge cases: nommu does not abide by these and CoW MAP_PRIVATE-pfnmap regions
+ * have their page offset set to the first PFN in the range.
  *
  * Returns: The page offset of the start of @vma.
  */
diff --git a/mm/vma.c b/mm/vma.c
index 6ccd097b8813..f8001d5c23aa 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2620,6 +2620,14 @@ static bool map_is_dev_zero(const struct mmap_state *map)
 	return imajor(inode) == MEM_MAJOR && iminor(inode) == DEVZERO_MINOR;
 }
 
+static void map_set_anon(struct mmap_state *map)
+{
+	map->file = NULL;
+	map->file_doesnt_need_get = false;
+	map->pgoff = map->addr >> PAGE_SHIFT;
+	map->vm_ops = NULL;
+}
+
 static bool map_is_private(const struct mmap_state *map)
 {
 	return !vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
@@ -2627,10 +2635,7 @@ static bool map_is_private(const struct mmap_state *map)
 
 static bool map_is_anon(const struct mmap_state *map)
 {
-	if (!map_is_private(map))
-		return false;
-
-	return !map->file || map_is_dev_zero(map);
+	return map_is_private(map) && !map->file;
 }
 
 /*
@@ -2808,6 +2813,14 @@ static int call_mmap_prepare(struct mmap_state *map,
 	map->vm_ops = desc->vm_ops;
 	map->vm_private_data = desc->private_data;
 
+	/*
+	 * MAP_PRIVATE-/dev/zero mappings are an ancient way of getting
+	 * anonymous mappings. Rather than allowing these mappings to be odd
+	 * outliers, simply make them truly anonymous.
+	 */
+	if (map_is_private(map) && map_is_dev_zero(map))
+		map_set_anon(map);
+
 	return 0;
 }
 
diff --git a/mm/vma.h b/mm/vma.h
index c1d65060071f..8caee3b4ba26 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -267,9 +267,6 @@ static inline void assert_sane_pgoff(struct vm_area_struct *vma, pgoff_t pgoff)
 	 */
 	if (!vma_is_anonymous(vma))
 		return;
-	/* MAP_PRIVATE-/dev/zero is anon, non-NULL vm_file, but has file pgoff. */
-	if (vma->vm_file)
-		return;
 	/* If faulted in, could have been remapped. */
 	if (vma->anon_vma)
 		return;

-- 
2.55.0


