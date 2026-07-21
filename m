Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E35C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96AEF6B008C; Tue, 21 Jul 2026 14:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9424F6B0092; Tue, 21 Jul 2026 14:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F5B6B0093; Tue, 21 Jul 2026 14:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C4356B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:53:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD204A01A1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:53:04 +0000 (UTC)
X-FDA: 85013681088.05.9724845
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1E220C0005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:53:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RYWNVhqB;
	spf=pass (imf22.hostedemail.com: domain of kwilczynski@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784659983;
	b=wDX0L8VhtgD+a3WjmQSAC4a1BCKI6V+tLtFFnmy6ZNH01Autb9FvBaYfX1AdXST0LCbkrH
	WRxmhNqHM4TTg2sePcPCThzDO3WKDF4lpXF+CXZb13nxagPwMGdIrqi7/Lk1styUNIVNhP
	o9FLtZxEn4DnuTcWJa3YD5CKuJB85dY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RYWNVhqB;
	spf=pass (imf22.hostedemail.com: domain of kwilczynski@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784659983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMLxNPT+alN3B9d358mO+K91kmoDqoyAF9P1cZ9RVr4=;
	b=ntsS+YwcogcwuXbM3AolQUXXN25/I4h1P8Puhf2elom+TOsnQQX3NIy6dQfCGC76HbPveV
	dA1CkUJ7H4yrtaj051UH2z/knHow03oKjD8dPJcNAJnxL+38t9LuYUDiECgkjPUyRgbQZV
	oiwAZ2RDfQrOFRyM8tCrtHE8flzuvJQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B2AF40B1F;
	Tue, 21 Jul 2026 18:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771671F00A3A;
	Tue, 21 Jul 2026 18:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784659982;
	bh=jMLxNPT+alN3B9d358mO+K91kmoDqoyAF9P1cZ9RVr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYWNVhqBZ/wCCKbxKgWojGthduYZlKb8YzS6t+6VwY1NE0XU530OA5B6pabktkVGe
	 KAU5pbZSgUuU/D/pg2NXJqFxaAft/6e6MryY7P6SeFiFNlwTEaFPe3O7yv95I2cGNP
	 8MCjywYcJ3HGaILSq/QUWXGsEbhRhXBDC3Z2O4xA+w18dVaEBLKj7cbynrzkrR4Fam
	 +kYmipw2mLYTvu13onPE47RkqF+vU5mF7wnQWTbLgQsrnk5dVrZ6SmhE1HJqkLqZ68
	 HE0kSxDIbfZEnJr7GGGBY6ILaTbyY8vlCjaPwVBpqUCgnEQ9B2LgA8ntbIW2k0Y11l
	 IU22Zjjlj39fQ==
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
	Dan Williams <djbw@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-mm@kvack.org,
	driver-core@lists.linux.dev
Subject: [PATCH 1/2] mm: Add unmap_mapping_file() helper
Date: Tue, 21 Jul 2026 18:52:51 +0000
Message-ID: <20260721185252.1670958-2-kwilczynski@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721185252.1670958-1-kwilczynski@kernel.org>
References: <20260721185252.1670958-1-kwilczynski@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1E220C0005
X-Stat-Signature: kxnytmjryfc1g87aerqyqmyq5khwekod
X-Rspam-User: 
X-HE-Tag: 1784659982-643846
X-HE-Meta: U2FsdGVkX1+TGOmcd6cP0QK78aMyyvJ7mRYXpp6JzYq+IIw9VmHlfSeOxIBvIUXdVJ38ZmM33plBlLovhmTwX4XYDBfN5B0foi7rlpntBkQ7eS4d7RLvf2X3Pu9umLyWectiPvNDCQmDfYi94gS2xx8ap/KT81PjErfv7K1pfdigP0HIxiA6mOQcX1uu1SmElRWF+etaa3t+jipRgUwueKSjdsUuEvidklKgaYRz9VwM70B/kei9KnguxPraClANDb0LMbRyfzkoYsgCTNAuvrfWm0KpQATT4eSRLZBDiOxYmxLINfNCEejB+nuNxym98mv6lo+rNJheSKqkuYMG4vupRfHkMts1qXeV3kqqaX7+jpiZJnz+hVGOVOtN0rCvwbV0tHKlnNcZoGE3gM9x2ZXAKQW3+Haz0D+wVejKBtm5ZhyOHzGAvipVrImI3rzMNZ0A5Nxa+I1fDL5WgNOT1uThxcPsgZMTGIJ3jzbtew2wSYWQGQLa9w7XmSgGmTeH8DQzUuh6Vod5M2cFM/9pGz7OnYzP+gClpwpTmBsQ0EobvAH/G8sQTieAsT8R9EYqxVhTjXJ6fXojazQC6kPR7ISiB4XJ7OIyL9igXng3WSg3U0UJNRSNgi9fHkwWsaKAk84FNheZNciA4nhebY/NgGSLyVp7MADE4aSbXJPf3P3yFFdNNLzmKTcNLfqL5TYcBhFjiSWFYnVF8MrGl6RTUE/e1WXz7VeEp8+RWWB+M8TT27nR6Di+BHjrJYWIVXLUAhBF7dr2IVKcJ2GLisZkH+WdvVf/wYm2uVhtxoSvOb1eFExOrNt9hyxkRWhbp7OGrzCuoise8WnVPY7KmI5ZLPyWkpA53V/KND87CkDEjtRez9NLcNZgzKxswsyk4H3wBd7rFVMUD8V44xqrCipKXTRQ2UO1yy1qahXqYSEf38Oh2h+LturoKRztlpdELKgRpDkh38b+vm0qmCkDruS
 eeKVFK6S
 Fh/+UPzVPDeh9ZjWBnanKnu3IM834Mv8dISnb/XuqlfLCVB2BJC5zsrwp7oUptw6CdwpgBh7sZRDIS/0WgdFMY7eyTMw46wAwbLEPMn9S50AGkow17HaiOB2m0i7yybsOJg4YfZvHUe8cEEVU1q1zkE275Al9OF+MlFgEp6SEgAKS+sVK9PrzAQHTAvAFsKooHtR9lZoep/4A5KMZXp9v0YqV1a+PzwUrl1VcWgtgZOnfTqvYEsh3aiZAYgzhGAazHwt/e6yRvtsjHnG6D6h+KsMcerwjTZUttPIM7FX6bVwcjwlmCEtYBzoVHWIb4F05jh1IpNAoYeQiHJ0f9amLXDgDzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, unmap_mapping_pages() and unmap_mapping_range() unmap
a page offset window of an address_space, and teardown paths such
as kernfs_drain_open_files() rely on them to remove the mappings
of a file that is going away.

Files with f_mapping swapped to a shared address space at open time,
such as PCI resource files using iomem_get_mapping(), have their
VMAs attached to the shared mapping instead of the file's own inode
mapping, so a teardown that unmaps the inode's address space cannot
reach them, and they stay live after the file is removed.  As such,
the only correct discriminator for these VMAs is the originating
struct file recorded in vma->vm_file.

Add unmap_mapping_file(), which walks the VMA interval tree of the
file's f_mapping under i_mmap_lock_read() and zaps every VMA with
vm_file set to the given file, using the same per-VMA zap teardown
as unmap_mapping_pages().

Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

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
index ff338c2abe92..f9cfb88ac4f7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4423,6 +4423,32 @@ void unmap_mapping_pages(struct address_space *mapping, pgoff_t start,
 }
 EXPORT_SYMBOL_GPL(unmap_mapping_pages);
 
+/**
+ * unmap_mapping_file() - Unmap all mmaps of an open file.
+ * @file: The file to unmap.
+ *
+ * Unmap every VMA with vm_file set to @file, regardless of the address
+ * space it is attached to.  This also covers files with f_mapping
+ * swapped to a different address space at open time, since such VMAs
+ * cannot be found through the file's own inode mapping.
+ */
+void unmap_mapping_file(struct file *file)
+{
+	struct address_space *mapping = file->f_mapping;
+	struct vm_area_struct *vma;
+
+	i_mmap_lock_read(mapping);
+	if (unlikely(mapping_mapped(mapping))) {
+		vma_interval_tree_foreach(vma, &mapping->i_mmap, 0, ULONG_MAX) {
+			if (vma->vm_file != file)
+				continue;
+			zap_vma(vma);
+		}
+	}
+	i_mmap_unlock_read(mapping);
+}
+EXPORT_SYMBOL_GPL(unmap_mapping_file);
+
 /**
  * unmap_mapping_range - unmap the portion of all mmaps in the specified
  * address_space corresponding to the specified byte range in the underlying
-- 
2.55.0


