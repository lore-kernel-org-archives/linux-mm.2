Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F0351099B4B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8FAC6B0123; Fri, 20 Mar 2026 18:40:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B679B6B0125; Fri, 20 Mar 2026 18:40:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55A46B0127; Fri, 20 Mar 2026 18:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97B476B0123
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4DF2513A29D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:23 +0000 (UTC)
X-FDA: 84567911526.19.93602D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 943144000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gjT5OfG/";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qNZ0cSW5tVKwJdkc+8VZnUhYg3Myxx6O/VK3EewvUNU=;
	b=Jjp6d/ZxyiQzamXyEK16jLpkmyLeTc/gt0if0XrRKi6lDJECLghiKAMqVc8kWcz9DjH+EL
	ONP2z1AbXYaMJ5TqfiR7/HFO+g0CaUSS3Lm72kKlAsNgB+lGAxFqsU1gsLTz73HfiS8LYx
	11K/ASrQQ088A4jsJuf2m2jok82dt38=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gjT5OfG/";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046421; a=rsa-sha256;
	cv=none;
	b=qXw3AdQ5W9QRh4GwA0iP6hnGrLrTnjHio/KNvJ1Gwe4W6lW7oaof45nQTNLTPRssr1b+X4
	n9hAVu1RwuQww5zUTHxzlrH48+MY8w3gSSNBTwo6move359DFKnwfNDKlS9QKBaPeuRHIm
	hy4kGxep6I5TevGeTnr+r4ooY0J72BI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B65744452A;
	Fri, 20 Mar 2026 22:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E63C2BCB0;
	Fri, 20 Mar 2026 22:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046420;
	bh=nTMi7MwgWhsqzEL3innRO8x3UGd+wS99PKV5J1/IH6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjT5OfG/LeaNBmLBTUcJPgnFfktEPzYQp1DS+lVjzFF9mviCzUaOB/pv5EHU0EsMM
	 0WimX7637MvnHvbDM5ijVu4+dtO8s0Vvfj0NenkAY/HaB3Ad88bN2u1mlJ0c1QIkvA
	 cIxW5OOMSphnCBkiQSwasBNYmIRGz9qUDAFkFdd6pzQVCWVUiupz5jZCRHZs5XTkYp
	 DB/EkEvfD1Afqqzo+MwllMaR4ktnrqaRLNCUlkajLtTYHG7nILemLEO/ih0qWLXHHT
	 sHtHoecxEP3lZPCejF3YNgU1Tz5BXICj27Ua1a6alZHwlWd+3T5ga9RjPT/WeFhCgB
	 Wbo/bkpNIqoog==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v4 05/21] mm: switch the rmap lock held option off in compat layer
Date: Fri, 20 Mar 2026 22:39:31 +0000
Message-ID: <dda74230d26a1fcd79a3efab61fa4101dd1cac64.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 943144000C
X-Stat-Signature: petupdreunf9zr6df8q3c669jh3179cb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774046421-992373
X-HE-Meta: U2FsdGVkX1/VTAdb6yJOdYE77vyxl2wlR3tWAXrL5+nZJQIzMNmX/Mo5g4+sOJGESz6/oWhuHaHT58CGyY580sxb9FNj1CyFOhX889L+kVmmZf6CPW9rPNpfeK68qAY1hgWjNwwrv+n/8M3lx99KU76uoRfIiBDXkqCcIC50Ry4SxawAekwhHV/cYKhxBIkidTXNSMwBDCkKl6JG/RjIarIgjgdxalDzf6Qoom8wKTKex0Fbbw7fvhfIeUJ2QRId2UZCN11+6yKk3nZyyfT0A/Kojhs+ZIIyTVvsfbx4W5qOhy7XAOYzWLXZBGM6CjTqTOTlNPXy318uhxg0lkF7xk320pxI21kvTXB8GQuexWMVDGbr1ubfC5PYD1vcroIKMXjlS7qrLtArE6J6Ob8omVD8WmczuA7YIhx1kka4hpsocMGfIW3SngvDR6ar+lP2sVKAnaQavtq9FYM6BWD+XqqodaeDS3pxpmkvAGrOuUolHUENZPjzod7yhR3R9KaUh5BOpVL1534bv7HULF/sImnx+UiufbFi36kHtYEcTNtUbTfskF8JTdoClHEnkLakf/gT5pZLmk5eaJ+yZnYl68HYoiE6PyLWwbNWf4wpczFXgLRCgQv57HTBAADRWnw+1FZ2xQnIox/RflT1nsrrCjj6hgWIn3w3ovWzX3NmwABD4UsVJb1xlbk1lMA8gDuClSFZf5ytpkWmdxHxu1W+6eS8YxKSCduavg+bsl42t4O4JJhhfY9IA5CrUkSLV8tkOSbrrilH6bZAPD5YoT3kvoektHNcsrvFv6LuEbEHRhhgmeNoQbaZixskTOgcUrr6byONcNmqVxpm/gFVC56g/hKpp6JVFTVnq5KoE2X10UHu0BS0cvCr84n5PGdJwW5rI477kzilLpWHIVJORHTKQ8zKrqMU+HbUaGqmeczHm+7Mrt+U1QBRakfdtW1y/Yc7AKE+TObXFJYMUpvCupH
 A4iWfF13
 wnsauqmBneCU/1TA4QLXLOq3jnPk9bvrENJvcbov9MPlQnP8Nn/PTQS92/tHcU/nicOiVwoAlnqubteuggZtDKJKf+9ttLhhqkL9/Q9EkEnEn5svE5oSnJrp1lVV+A33iNMy+35WqlIEcYwSdaJDqLf08ilEs7g/3Hno0GzxC+qThKLH3OJu5b/orSfiQnz8LD9ZDkZPAHvUpI7tqfQkCksGuBeUYwYntaMVhx7rhnsVtcgPa6Qs7aUhEdYgrZt09YSO4WeemtYF0BXERntioLzFKVWVUPLeU3YMFC7P6Zy552hQy9vhHAOgrIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the mmap_prepare compatibility layer, we don't need to hold the rmap
lock, as we are being called from an .mmap handler.

The .mmap_prepare hook, when invoked in the VMA logic, is called prior to
the VMA being instantiated, but the completion hook is called after the VMA
is linked into the maple tree, meaning rmap walkers can reach it.

The mmap hook does not link the VMA into the tree, so this cannot happen.

Therefore it's safe to simply disable this in the mmap_prepare
compatibility layer.

Also update VMA tests code to reflect current compatibility layer state.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/util.c                       |  6 ++++-
 tools/testing/vma/include/dup.h | 42 +++++++++++++++++----------------
 2 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index a2cfa0d77c35..182f0f5cc400 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1204,6 +1204,7 @@ int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)

 		.action.type = MMAP_NOTHING, /* Default */
 	};
+	struct mmap_action *action = &desc.action;
 	int err;

 	err = vfs_mmap_prepare(file, &desc);
@@ -1214,8 +1215,11 @@ int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
 	if (err)
 		return err;

+	/* being invoked from .mmmap means we don't have to enforce this. */
+	action->hide_from_rmap_until_complete = false;
+
 	set_vma_from_desc(vma, &desc);
-	err = mmap_action_complete(vma, &desc.action);
+	err = mmap_action_complete(vma, action);
 	if (err) {
 		const size_t len = vma_pages(vma) << PAGE_SHIFT;

diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 26c6c3255a94..c62d3998e922 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1256,8 +1256,17 @@ static inline void vma_set_anonymous(struct vm_area_struct *vma)
 static inline void set_vma_from_desc(struct vm_area_struct *vma,
 		struct vm_area_desc *desc);

-static inline int __compat_vma_mmap(const struct file_operations *f_op,
-		struct file *file, struct vm_area_struct *vma)
+static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
+{
+	return file->f_op->mmap_prepare(desc);
+}
+
+static inline unsigned long vma_pages(struct vm_area_struct *vma)
+{
+	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+}
+
+static inline int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct vm_area_desc desc = {
 		.mm = vma->vm_mm,
@@ -1272,9 +1281,10 @@ static inline int __compat_vma_mmap(const struct file_operations *f_op,

 		.action.type = MMAP_NOTHING, /* Default */
 	};
+	struct mmap_action *action = &desc.action;
 	int err;

-	err = f_op->mmap_prepare(&desc);
+	err = vfs_mmap_prepare(file, &desc);
 	if (err)
 		return err;

@@ -1282,28 +1292,25 @@ static inline int __compat_vma_mmap(const struct file_operations *f_op,
 	if (err)
 		return err;

+	/* being invoked from .mmmap means we don't have to enforce this. */
+	action->hide_from_rmap_until_complete = false;
+
 	set_vma_from_desc(vma, &desc);
-	return mmap_action_complete(vma, &desc.action);
-}
+	err = mmap_action_complete(vma, action);
+	if (err) {
+		const size_t len = vma_pages(vma) << PAGE_SHIFT;

-static inline int compat_vma_mmap(struct file *file,
-		struct vm_area_struct *vma)
-{
-	return __compat_vma_mmap(file->f_op, file, vma);
+		do_munmap(current->mm, vma->vm_start, len, NULL);
+	}
+	return err;
 }

-
 static inline void vma_iter_init(struct vma_iterator *vmi,
 		struct mm_struct *mm, unsigned long addr)
 {
 	mas_init(&vmi->mas, &mm->mm_mt, addr);
 }

-static inline unsigned long vma_pages(struct vm_area_struct *vma)
-{
-	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
-}
-
 static inline void mmap_assert_locked(struct mm_struct *);
 static inline struct vm_area_struct *find_vma_intersection(struct mm_struct *mm,
 						unsigned long start_addr,
@@ -1473,11 +1480,6 @@ static inline int vfs_mmap(struct file *file, struct vm_area_struct *vma)
 	return file->f_op->mmap(file, vma);
 }

-static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
-{
-	return file->f_op->mmap_prepare(desc);
-}
-
 static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
 {
 	/* Changing an anonymous vma with this is illegal */
--
2.53.0

