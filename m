Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 720CFC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 763146B00D5; Mon, 20 Jul 2026 10:40:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73AAB6B00D7; Mon, 20 Jul 2026 10:40:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650B96B00D8; Mon, 20 Jul 2026 10:40:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 39BE66B00D5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:40:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8C09C01E4
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:40:51 +0000 (UTC)
X-FDA: 85009416702.12.F82F9B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DA16340003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:40:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a+NFlRrY;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lGZ9e1pthjj4S87/Ux9jMBJ05B+0BlhW+lsD1DqHNms=;
	b=hxtesa95rnR8VJMtbPyOG7LMPwgVEfoDV4AhFO38XWnJNsaN+tIyNRtfeeZfPnPMgyWyP8
	br8da7/UZrkEm4Sc5hpCToWabiZlhyxIJCbNLh3r6L0Sl1jOvmXX/pjA9tyW6zCtEmTvJr
	0SXXb5pGhci1BzpdtsjgTRN/KLREgKg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a+NFlRrY;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558450;
	b=hZLbteTrnDAHv+M+WQibY08tzPuiXJsS1AWU9HGuhHaeg+fwB3bOaSpvZ/VWNun47woxSk
	NlacSHKbN6ICqx8qae1nOUJdmAl4LjtcvK1pv+muaDDqDHQzbJ3h3cGb++lhhyJzG+vxN8
	fqYnD50qFIxoj1pHILeghN+gw+Jgt7k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 30EA44164B;
	Mon, 20 Jul 2026 14:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DBCD1F00A3A;
	Mon, 20 Jul 2026 14:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784558449;
	bh=lGZ9e1pthjj4S87/Ux9jMBJ05B+0BlhW+lsD1DqHNms=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=a+NFlRrYs9ugYrCxbNOfyYpwr0zpRWjp0g19yoKcm0yOsNIEZozZ5PFDw7aL4ED48
	 w3y6upjTmGTdJRZEbJYDXU9KsZqZkAaXmqQnTDMO1+4FZPV4VVFRBKT2G7g9TSM/G8
	 LIrv5/5vB/GEGZRRoW3cok9WMR6G8QAoMbIr4zA2cV3CGsQi1hG8aeX0mS5J+KqVzN
	 OQJwoJE+dOUFSIeslYj3rz3Et9JWL/OiV3HQObsakNnf3PbcVb1OZ0K34AFa7E0YVd
	 8ANOKgWSJHVsc2/Jp2NmJQLq6yUBmt+SptNhmCoSFjjvhfZ2X79nuszcMKN2cOK5hl
	 Y3xtrvuX1qyQw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 20 Jul 2026 15:38:38 +0100
Subject: [PATCH v2 12/15] mm/vma: only permit MAP_PRIVATE /dev/zero to be
 mapped anonymous
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-scalable-cow-virt-pgoff-v2-12-2d549757a76f@kernel.org>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
In-Reply-To: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9643; i=ljs@kernel.org;
 h=from:subject:message-id; bh=1QxiRt+MCk0qy9TQF5Cy2ZBarENmthDf89CuLVHgVvM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLijN5sN8qZ8OHMzjb5ata4T1Mr7sxfpvD7wolf3ivNJ
 No8FnDt7ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEdvAy/C9tn12ipfTlzHbJ
 STzRzLNXFRkXyohPy+G2M9+k3LTR9yEjwzH7mvtXryUmec8q2js/X33TFumt6sd7lyoLqzoXLdN
 Q5gcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DA16340003
X-Stat-Signature: ktxjx1nafjm9jjeah1gzbm67u3gmsksp
X-HE-Tag: 1784558449-654604
X-HE-Meta: U2FsdGVkX1+JJzZBgWQ8Ha8MiqUE1unUA+7m3NNHUea/KS2+LS1QbLszT4JFVYVMqHyrvSmPH2L+5bxxT2mquk4xmV7TXdiTBAZ/E8rvq5usw09VScZi+CdvwqauvP+3o8evGI1H6FdAKlQQ+/ME4LO4xxt/9OBUILygI9LVXdjlNMcFCg1psAbYl9DJy9/QG/8wakssKjFsYUpfzH5RggI0tUgjYO/EyV4aia1geaxpVEqJSE1d1n9vCJmHv7rF9R0kUmbLWmtXAfQ9vjrpyjgCOfwta/FFRjHPUCoMPZwmbwJuXPoKQ2B501grEFQRlsiMKol1YltQdRjCOQfc7frTGU/dOgUfr+DJYVk8E3Oqk73yyXv5YXubq/j2DM1xFE83wT077DlQDO/F0BZkIS5G1pD+p2VXxFjne/TH5quInJUmHtCUd4Hun3DmKoqUpbdY8YgA85SDo1OEa8ew4C0SbfImq6KEuYhpXhqjukEMwJq7VY/IUgt7Un8XdemY7z68/RY8sG0M1llAoD4gKsmzpixISgbaRHn2stuIBmbg626eaJFfTUU3D2TwaElb0wVJCsirk6W3ibO9bVw2GVR3wfSnoYF7ghzrvWQlTgYm1C5JY/VigvFNaXuoSeEJZxppDrmNFLqCFxZ+OCcxE3ezaX7INBbblmMSoPbwlunA7mtLAxIoj8u18UfmSCtzCt/U4kw4bS3OXuBdemqgirWDAE5mNBeKUClciArKzPEjdQaNWOYf9cWYcQ4SvGx42oKpTPycm6OgBvXuKfc6a2xeDVD8YdtiMR1K+TsSVoXuUQusqQU0inzfsu3tOK1ALkwJWqsd+7eSmxIMxf+tQKJUgHVklZgUqhKfQ6pL0ueGk3nfrFX8EMh3+mSSFeUKu/yKUgQf8n/KmOpaFP07iXPTz9VMwo91r8kcHgiYqCqzB8Laj2JZ5eproA6J2kMXDKMl/w9lqgrIkkqNLgH
 penNdG3B
 fDG4+n4jWrqY+uTQFrUN8p5/4uFrFZlKyJu7rU9Fzg4tEcYgfkTp+rYOYM1QYRjUABfIuHX6Eq9wgEHkjkIMU6qORaOF9lt5iNoWN5MfoXTEkt0yRpFOMGK4ovDRd9Qqlv9bui/uMcPmykbJpOeACrpDCz067hdSiLa/gjPD0cBMHjtv9zhPt7Rx85jfuvzDO18SOrMRr2th5PPs1Cpq8yWUs/Ya/RqmFgWJy1xTlXS4X2dBuwFkmaNqMkRwhampWxjUpvANoIVf8A6SzjdWKAUqb2kc2qEkRadPkJqiBLI+1E2c0GTwFOtQ2m+x84EJqMEXRHE5Gd0vibdUb0N/fNS0IDHF1dARHv0BMegdZ+DSF6Ey8YrMygl7+/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to use mmap_prepare() with MAP_PRIVATE mappings of /dev/zero
without the success_hook hack we explicitly permitted mmap_prepare handlers
to set NULL vm_ops.

However this is dangerous and we really only want to allow this for
MAP_PRIVATE-mapped /dev/zero.

Make it possible to explicitly identify /dev/zero by setting a global
DEVZERO_MINOR device minor number then explicitly check for this in mmap
code for a MAP_PRIVATE mapping and only set the VMA anonymous if we have
positively identified it.

Then remove all ability for mmap_prepare or mmap hooks to set a VMA
anonymous and update mmap_zero_prepare() to leave it to the core mmap code
to mark the VMA anonymous.

Note that this disallows nested MAP_PRIVATE-mappings of /dev/zero
regions. Doing this would be broken in any case.

We therefore do not need to update the mmap_prepare() compatibility layer
to reflect these changes, as the mmap hook check suffices to disallow this
behaviour.

Now we're setting vma->vm_ops to NULL for an mmap_prepare-initialised
MAP_PRIVATE-/dev/zero mapping, we have to avoid a subtle issue when
updating user-defined fields via set_vma_user_defined_fields().

The default for vma->vm_ops for all mmap_prepare-initialised mappings is
vma_dummy_vm_ops, so map->vm_ops will be set to this and setting
vma->vm_ops to this will render the VMA mistakenly non-anon.

In general, we should never be setting user-defined fields for an anonymous
VMA, so explicitly check for this to avoid doing so for the one case where
a mapping can be both mmap_prepare and anonymous.

Also, in order to avoid a single commit bisection hazard, add a temporary
workaround to set the VMA anonymous only after vma->vm_file is assigned in
__mmap_new_file_vma().

This is because vma_set_range() calls vma_set_pgoff() and
assert_sane_pgoff() in turn, prior to the vma->vm_file being assigned. If
we set the VMA anonymous early then this assert will fail.

This is removed in the subsequent commit.

Also update the VMA userland tests to reflect the change.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 drivers/char/mem.c              |  8 ++------
 include/linux/mm.h              |  3 +++
 mm/internal.h                   |  4 ++++
 mm/vma.c                        | 43 +++++++++++++++++++++++++++++++++--------
 mm/vma_internal.h               |  1 +
 tools/testing/vma/include/dup.h | 36 ++++++++++++++++++++++++++++++++++
 6 files changed, 81 insertions(+), 14 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 63253d1de5d7..dcfd896b733d 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -506,11 +506,7 @@ static int mmap_zero_prepare(struct vm_area_desc *desc)
 	if (vma_desc_test(desc, VMA_SHARED_BIT))
 		return shmem_zero_setup_desc(desc);
 
-	/*
-	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
-	 * of /dev/zero anonymous, despite it not being.
-	 */
-	vma_desc_set_anonymous(desc);
+	/* MAP_PRIVATE semantics are taken care for us by core mm. */
 	return 0;
 }
 
@@ -698,7 +694,7 @@ static const struct memdev {
 #ifdef CONFIG_DEVPORT
 	[4] = { "port", &port_fops, 0, 0 },
 #endif
-	[5] = { "zero", &zero_fops, FMODE_NOWAIT, 0666 },
+	[DEVZERO_MINOR] = { "zero", &zero_fops, FMODE_NOWAIT, 0666 },
 	[7] = { "full", &full_fops, 0, 0666 },
 	[8] = { "random", &random_fops, FMODE_NOWAIT, 0666 },
 	[9] = { "urandom", &urandom_fops, FMODE_NOWAIT, 0666 },
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b6503b5f0010..7614afe99c96 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -740,6 +740,9 @@ static inline bool fault_flag_allow_retry_first(enum fault_flag flags)
 	{ FAULT_FLAG_INTERRUPTIBLE,	"INTERRUPTIBLE" }, \
 	{ FAULT_FLAG_VMA_LOCK,		"VMA_LOCK" }
 
+/* /dev/zero minor device number. Special due to MAP_PRIVATE semantics. */
+#define DEVZERO_MINOR	5
+
 /*
  * vm_fault is filled by the pagefault handler and passed to the vma's
  * ->fault function. The vma's ->fault is responsible for returning a bitmask
diff --git a/mm/internal.h b/mm/internal.h
index 22f63cb85bd3..41561fdeb56d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -240,6 +240,10 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
 {
 	int err = vfs_mmap(file, vma);
 
+	/* Hooks cannot mark themselves anonymous. */
+	if (WARN_ON_ONCE(vma_is_anonymous(vma)))
+		err = -EINVAL;
+
 	if (likely(!err))
 		return 0;
 
diff --git a/mm/vma.c b/mm/vma.c
index 6dc095d03382..103a6a134dec 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2612,6 +2612,29 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	return 0;
 }
 
+static bool map_is_dev_zero(const struct mmap_state *map)
+{
+	const struct file *file = map->file;
+	const struct inode *inode = file_inode(file);
+
+	if (!S_ISCHR(inode->i_mode))
+		return false;
+	return imajor(inode) == MEM_MAJOR && iminor(inode) == DEVZERO_MINOR;
+}
+
+static bool map_is_private(const struct mmap_state *map)
+{
+	return !vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
+}
+
+static bool map_is_anon(const struct mmap_state *map)
+{
+	if (!map_is_private(map))
+		return false;
+
+	return !map->file || map_is_dev_zero(map);
+}
+
 /*
  * __mmap_new_vma() - Allocate a new VMA for the region, as merging was not
  * possible.
@@ -2625,8 +2648,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	struct mmap_action *action)
 {
-	const bool is_anon = !map->file &&
-		!vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
+	const bool is_anon = map_is_anon(map);
 	struct vma_iterator *vmi = map->vmi;
 	int error = 0;
 	struct vm_area_struct *vma;
@@ -2642,7 +2664,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 
 	vma_iter_config(vmi, map->addr, map->end);
 
-	if (is_anon)
+	if (is_anon && !map->file)
 		vma_set_anonymous(vma);
 
 	vma_set_range(vma, map->addr, map->end, map->pgoff, map->virt_pgoff);
@@ -2660,6 +2682,10 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	else if (!is_anon)
 		error = shmem_zero_setup(vma);
 
+	/* Temporary MAP_PRIVATE-/dev/zero workaround. */
+	if (is_anon && map->file)
+		vma_set_anonymous(vma);
+
 	if (error)
 		goto free_iter_vma;
 
@@ -2768,6 +2794,10 @@ static int call_mmap_prepare(struct mmap_state *map,
 	if (err)
 		return err;
 
+	/* Hooks cannot mark themselves anonymous. */
+	if (!desc->vm_ops)
+		return -EINVAL;
+
 	err = call_action_prepare(map, desc);
 	if (err)
 		return err;
@@ -2790,10 +2820,7 @@ static int call_mmap_prepare(struct mmap_state *map,
 static void set_vma_user_defined_fields(struct vm_area_struct *vma,
 		struct mmap_state *map)
 {
-	if (map->vm_ops)
-		vma->vm_ops = map->vm_ops;
-	else	/* Only /dev/zero should do this. */
-		vma_set_anonymous(vma);
+	vma->vm_ops = map->vm_ops;
 	vma->vm_private_data = map->vm_private_data;
 }
 
@@ -2873,7 +2900,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		allocated_new = true;
 	}
 
-	if (have_mmap_prepare)
+	if (have_mmap_prepare && !map_is_anon(&map))
 		set_vma_user_defined_fields(vma, &map);
 
 	__mmap_complete(&map, vma);
diff --git a/mm/vma_internal.h b/mm/vma_internal.h
index 4d300e7bbaf4..385c0ab13777 100644
--- a/mm/vma_internal.h
+++ b/mm/vma_internal.h
@@ -23,6 +23,7 @@
 #include <linux/ksm.h>
 #include <linux/khugepaged.h>
 #include <linux/list.h>
+#include <linux/major.h>
 #include <linux/maple_tree.h>
 #include <linux/mempolicy.h>
 #include <linux/mm.h>
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 0c74899abb33..c617ee2532bd 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -15,6 +15,20 @@ struct task_struct *get_current(void);
 #define MMF_HAS_MDWE	28
 #define current get_current()
 
+#define MINORBITS	20
+#define MINORMASK	((1U << MINORBITS) - 1)
+
+#define MAJOR(dev)	((unsigned int) ((dev) >> MINORBITS))
+#define MINOR(dev)	((unsigned int) ((dev) & MINORMASK))
+
+#define S_IFMT  00170000
+#define S_IFCHR  0020000
+
+#define S_ISCHR(m)	(((m) & S_IFMT) == S_IFCHR)
+
+#define MEM_MAJOR		1
+#define DEVZERO_MINOR	5
+
 /*
  * Define the task command name length as enum, then it can be visible to
  * BPF programs.
@@ -23,6 +37,8 @@ enum {
 	TASK_COMM_LEN = 16,
 };
 
+typedef unsigned short		umode_t;
+
 /* PARTIALLY implemented types. */
 struct mm_struct {
 	struct maple_tree mm_mt;
@@ -45,6 +61,10 @@ struct address_space {
 	unsigned long		flags;
 	atomic_t		i_mmap_writable;
 };
+struct inode {
+	umode_t			i_mode;
+	dev_t			i_rdev;
+};
 struct file_operations {
 	int (*mmap)(struct file *, struct vm_area_struct *);
 	int (*mmap_prepare)(struct vm_area_desc *);
@@ -52,6 +72,7 @@ struct file_operations {
 struct file {
 	struct address_space	*f_mapping;
 	const struct file_operations	*f_op;
+	struct inode			*f_inode;
 };
 struct anon_vma_chain {
 	struct anon_vma *anon_vma;
@@ -1633,3 +1654,18 @@ static inline pgoff_t linear_virt_page_index(const struct vm_area_struct *vma,
 
 	return pgoff;
 }
+
+static inline struct inode *file_inode(const struct file *f)
+{
+	return f->f_inode;
+}
+
+static inline unsigned iminor(const struct inode *inode)
+{
+	return MINOR(inode->i_rdev);
+}
+
+static inline unsigned imajor(const struct inode *inode)
+{
+	return MAJOR(inode->i_rdev);
+}

-- 
2.55.0


