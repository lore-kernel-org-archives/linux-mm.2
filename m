Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A630C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AD566B00BB; Sat, 25 Jul 2026 17:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1A06B00BC; Sat, 25 Jul 2026 17:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589126B00BD; Sat, 25 Jul 2026 17:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A4A96B00BB
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:06:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A59281A03C3
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:06:00 +0000 (UTC)
X-FDA: 85028531280.28.9EAC8D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0F16740007
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:05:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AhWkmOY/";
	spf=pass (imf07.hostedemail.com: domain of kwilczynski@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RSa+weKwTyM0tp9L5Vf4KtyDgEuS9BC6cM9EMAxoRr8=;
	b=IJXfn4fNUqS7d6kOL79CZ7Elfy2aI5pHjrca7QnFbM197w33DA4dbFllI3yHqLCTlfzTni
	PWiV0bXtL1+7FwzqN6MRj4ICotnj0mf3oRwax0CRaAWVa0kw8hbU5dwQEN6wKRhsEt5OFu
	Ig7krBb5tC+DZ4Nzn3F2oPvYtxGGe+U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013559;
	b=4Ez4BUbh+GB+3F8tdYs0Xkem7oVrrMZkXaONi4T5EiSirmaGra59D+gf+kei+CTn8NyrfZ
	fvtKP19GNS27XoIGlF/+s+BpefnWdNIGeBbol/b6/8lfcxzUTRbESTBnagkbFi4uoFlpjB
	wRC6d7E0ynkrrozvA4cjNnABvHGVF+U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AhWkmOY/";
	spf=pass (imf07.hostedemail.com: domain of kwilczynski@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A024660A97;
	Sat, 25 Jul 2026 21:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A395F1F00A3A;
	Sat, 25 Jul 2026 21:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013558;
	bh=RSa+weKwTyM0tp9L5Vf4KtyDgEuS9BC6cM9EMAxoRr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AhWkmOY/Nt9hXs0PlFDC/LdXs3RyB/46uNC3kLVqCNpDb2QuE175EsdNmAHSSfBtg
	 XcVtmxd/7eyenYWRqZac3QyWpgaT07s0i9i+tvpC8UkVIu4BgKp433wV95gIRGJLpM
	 YjgLVHk2FxsFR1zTC2WGcomHmhfqbqDbDm6VuZK3UTH3nfiMrgv8HxUcP30V7/sdQZ
	 pWeNalEdqSEybche3/DHuKeTZ59gqvf7xyIB31mhCnU0OKQ2E48Rl8Ue5xVK8STMR7
	 1UvetkXS9bfvzTVKUckrGaJ4C8eekChSPPZTVXvz6JHLcquiWj7iYughAE/NCbZdM/
	 T9x/oOfMw20jQ==
From: =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>
Cc: Bjorn Helgaas <helgaas@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	kexec@lists.infradead.org,
	driver-core@lists.linux.dev
Subject: [PATCH v2 1/3] mm: Add unmap_mapping_file() helper
Date: Sat, 25 Jul 2026 21:05:47 +0000
Message-ID: <20260725210549.3716546-2-kwilczynski@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260725210549.3716546-1-kwilczynski@kernel.org>
References: <20260725210549.3716546-1-kwilczynski@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0F16740007
X-Stat-Signature: 8x59dxf4bbmkkdrfdnf1wx1fg3497qdz
X-Rspam-User: 
X-HE-Tag: 1785013558-691403
X-HE-Meta: U2FsdGVkX18uBHNj1tWbSpPvCQuYqyVheSxmhBFt3x6l3YbWeji9G/Dzd0bnq1Yc/YlJ2GXyq2Q42bF2MGQgZugR9iFcBqlL+h8f+1nmikWG879JA8oZqGWBkA2sd8dC4v/m3soYwrLV4a3O1m9e6G3l/3eMAu2KLxlYslwpZ+I2wknH7gDZ9y1Z4WwZBeZ6gFxFQYtYYFEw6y/exnG0hkkEw46wQ3Vt4k8Dm59UmIKYiI4hhsVDW1nqE6Vb462aXt7FVBg7RgdJ2L8IoLX01KMmc/h1Ow7wQQ8H6p/BKrxzltZlI5MkNUa+GribJFRErqTWFObx/MGfszj+9zS9pKzBmaFR55N5wEBzchQFpwjwqrO5dMFi4CV6Jx3vgym6WosV9Pl48ObxH7yqDeaZvEou1EPHWouS/CQx8n5vIAWv1dcfKWfvVOzmtCxBTOVBVBJltKqRTmqCo+KoQJcG1Ho9wQyrr9787fFD9mImIGIWKmB9Yc7kTzEx1uH8tLDm/FIFT/5u8OORlgnF2JdSnzlJpcIbiGWaalOVljMTXXsTsG+DdE/3DWdNVhua+OympIk71QvgeBjRvDjaOAWdfS89ZSlEo4kztmiMF2b6ZEgHuyymJ84eIQrwZQ0ZA+/62nr3aYVNQH6WwWZ/sayRc015fO4ymihaHGPIJQCf1laSLe2wdC8lXHsngY5cDIQ2GTgru7hJoDS9T3dW0xPzZaFxiYkr0E9WSJTZphVx1KdhCx4dAO6r6rCepUA2InIn7Bbf6XJooa9P5Nt+Gl+T2H5dRh28bDDTZ+i4Bwm+6qgndOLRazr7sip/yJ2u7JYbkpBrf/NpDh+hZ7fOyGOk4gTBvQ3kw4hNkKpbK7Zo89CaRDYl96PBpLQ3akSmGwI6RXWkUgOfgx6FM7KGlsoEQNkZGbXqA4XrpnbqPTApjwTM4FKKZQNiWaUGblSyZ/W7S/z8aAQe8sDOXdD2o7/
 mFhJAfjz
 Be4f3EPrCVx5xzFH7whDgbhrunwjSh4s/Qeoiz4UVdwLRpV+xFQKzT5jsr6Q6brhsxof7eGxgW/dDoOg+rL7HDPUJ7v1dNAl5YCEgfJBFbz2SaDVdhND1LVQX2nFz+pNTbtZWuKTDxmsD22wNbpiqjhC8JRfaYQ86E/vAYLIualCQSDL7IKHcjR3LunyPvvDagDyUvhMOdWoOvqyempjfpr0IHwW8CNFpl6uXI5+9NxKPnNy1JyhIOD9ezsvfz55F6qJ4qNyZlBvqx8iNn2fbKyz8FAziwsgZrXoBNgneKTFKDun3TRnUcisdhtSGOYhzG07m/g4+/GS+lh2oB1lA5SwCWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, unmap_mapping_pages() and unmap_mapping_range() unmap a
page offset window of an address_space, and code that removes a file,
such as kernfs_drain_open_files(), relies on them to unmap the pages
of a file that is going away.

Files with f_mapping swapped to a shared address space at open time,
such as PCI resource files using iomem_get_mapping(), have their VMAs
attached to the shared mapping instead of the file's own inode mapping,
so unmapping the inode's address space cannot reach them, and they stay
live after the file is removed.  These VMAs can only be selected by the
struct file they were created through, which is recorded in
vma->vm_file.

Thus, add unmap_mapping_file(), which walks the VMA interval tree of the
file's f_mapping under i_mmap_lock_read() and unmaps the pages of the
VMAs selected by should_zap_file_vma(), using the same per-VMA zap as
unmap_mapping_pages().  When f_mapping is the file's own inode mapping,
every VMA is zapped, as unmap_mapping_range() does today.  When f_mapping
was swapped, only the VMAs with vm_file set to that file are zapped, so
callers do not need to tell the two apart.

HugeTLB VMAs are skipped with a WARN_ON_ONCE(), as zapping those takes
i_mmap_rwsem for write in hugetlb_zap_begin() and would deadlock against
the read lock held over the walk.

Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 48 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..e882a03eaddd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3183,6 +3183,7 @@ extern int fixup_user_fault(struct mm_struct *mm,
 			    bool *unlocked);
 void unmap_mapping_pages(struct address_space *mapping,
 		pgoff_t start, pgoff_t nr, bool even_cows);
+void unmap_mapping_file(struct file *file);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows);
 #else
@@ -3203,6 +3204,7 @@ static inline int fixup_user_fault(struct mm_struct *mm, unsigned long address,
 }
 static inline void unmap_mapping_pages(struct address_space *mapping,
 		pgoff_t start, pgoff_t nr, bool even_cows) { }
+static inline void unmap_mapping_file(struct file *file) { }
 static inline void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows) { }
 #endif
diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..4a09d7b6aa6b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4423,6 +4423,54 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
 }
 EXPORT_SYMBOL_GPL(unmap_mapping_pages);
 
+static inline bool should_zap_file_vma(struct file *file,
+				       struct vm_area_struct *vma)
+{
+	/* On the file's own inode mapping, zap every VMA */
+	if (file->f_mapping == file_inode(file)->i_mapping)
+		return true;
+
+	/* A swapped mapping also holds VMAs of unrelated files, zap only ours */
+	return vma->vm_file == file;
+}
+
+/**
+ * unmap_mapping_file() - Unmap folios from all mmaps of a file.
+ * @file: The file to unmap.
+ *
+ * Unmap the folios of @file from every process that has them mapped.
+ *
+ * If f_mapping is the file's own inode mapping, they are unmapped
+ * from every VMA on that mapping, as unmap_mapping_range() would do.
+ *
+ * However, if f_mapping was swapped to a different address space at
+ * open time, only the VMAs with vm_file set to @file are considered,
+ * since that address space also holds mappings of unrelated files.
+ *
+ * Must not be used on HugeTLB files.  HugeTLB VMAs are skipped with
+ * a warning.
+ */
+void unmap_mapping_file(struct file *file)
+{
+	struct address_space *mapping = file->f_mapping;
+	struct vm_area_struct *vma;
+
+	i_mmap_lock_read(mapping);
+	if (unlikely(mapping_mapped(mapping))) {
+		vma_interval_tree_foreach(vma, &mapping->i_mmap, 0, ULONG_MAX) {
+			cond_resched();
+
+			if (!should_zap_file_vma(file, vma))
+				continue;
+			/* Zapping HugeTLB VMAs needs i_mmap_rwsem held for write */
+			if (WARN_ON_ONCE(is_vm_hugetlb_page(vma)))
+				continue;
+			zap_vma(vma);
+		}
+	}
+	i_mmap_unlock_read(mapping);
+}
+
 /**
  * unmap_mapping_range - unmap the portion of all mmaps in the specified
  * address_space corresponding to the specified byte range in the underlying
-- 
2.55.0


