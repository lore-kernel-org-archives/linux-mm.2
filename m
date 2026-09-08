Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE414C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B989E6B0096; Tue,  8 Sep 2026 07:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70E46B0098; Tue,  8 Sep 2026 07:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86C66B0099; Tue,  8 Sep 2026 07:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8947D6B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:24:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 083A6A0534
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:24:51 +0000 (UTC)
X-FDA: 85190362824.15.E995607
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E6773180006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:24:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J2vGBeCe;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788866690;
	b=e1+X+S143wxiKxeOwoK0tX2KcxjutK9/eGadWDeSxgMkupegKb6Vvc2lob+XANluII8+Op
	icPNLoh+wc7pqRWSaaKmudggEcTotgviXsGb1fNZDggv9kAIsktLW1KJ4dSxBwLC4CHmRP
	dL92WPvXmypYEuzY8mh5DXGKZre2rj0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J2vGBeCe;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788866690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QpNjJERy5W0kZ4sRAK5DqssDq5giEzAZ8nJVAHeIm7A=;
	b=ZD8suF3oBkRiBnGMYK6L0aQ8GBQOf0jcBYGbzi2Nc77nVkPLmtF0DUyDWHczuH40XYmBs1
	nxvKRsubZoecmsK9z2Rn2tdZZXV9SrRtaFGzv4HnncJZleHootoGcxqxRn5jRJ/ythFN5z
	JFeuBLmi09PvhUSa7XPlYWp4qtYGEB8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36D2643F4D;
	Tue,  8 Sep 2026 11:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BDD01F00A3E;
	Tue,  8 Sep 2026 11:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788866689;
	bh=QpNjJERy5W0kZ4sRAK5DqssDq5giEzAZ8nJVAHeIm7A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=J2vGBeCewZOhjQLLB49PJxkgMpsXWdqjwH7GKarj61WbzSCS1NNO2oOQt9HIjm5rp
	 u4jBuYPhwsTKgB+LY7E6DrAtdeh0+kGQ3XDJWk7P0/J2tjJsGgcohsLg2gKViHhNlT
	 HMFNoovZtWaYxqigrBGQwQWaruFMVFkX1H2eaxW0fwKlrWxRnCV4nN7oni97TZAioY
	 TJLnyC7f2dfjBY0gWgs6vUpEXWkx3E/1Lw5j5O3IVuGxhkpAd11PqQ5sOuK9XCZAMg
	 QITnixPPxa7aTS1r4Rlbke1xMxw/oZ1ABhd2RJT4b5lDuWyN1TlNRdT8lQKtXXYMWZ
	 0BYDV6/5X6ROQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 12:23:39 +0100
Subject: [PATCH v2 2/6] mm: implement file_is_dev_zero() to uniquely
 identify /dev/zero
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-map-private-dev-zero-v2-2-acc7b5625305@kernel.org>
References: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
In-Reply-To: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2988; i=ljs@kernel.org;
 h=from:subject:message-id; bh=A0bJ64HW79psSPlOLCnw7EMt+8G8UJeBpFvBmWrksO0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLmfyjcGSSo1Re24du3VUcC7M8aau83dRc+0TDx5cfHI
 VMDs27xdpSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAihUEM/+PWJrT9WRQRY19Q
 ZWlws69zynZdjsJ7BoFxXr+urndleM7w36O0/4+4w8YDU5d/DppydP6UKZdnc2258yTK5umRjr+
 Nq3kB
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E6773180006
X-Stat-Signature: mr4et97e6iaf4996i33hd8zdy4cz9p3a
X-Rspam-User: 
X-HE-Tag: 1788866689-786551
X-HE-Meta: U2FsdGVkX18jB2EQFgSBvBj9CdzlrKkrCqyURd/65hGYLDsdXQAxZR830/TWUrYf4LFr0WmqGfjtc80+w2oyO/WhFPGdYotiQCdJkoeXl3XNqvORcjuY22K6K+pdai6O6SYhoPFA3zGhysR7Jvfuo/0bDpTQutdBVvhVBw7FwyBiE9NZXnFQMPF1ZR2NaiYUclQAAzzAFeq/uwvttmeFaeJiIqrt8R3dlT67VAP6FcAiMfJWvoMkvt9DzUwkE6pDkvAiikZfY54NeToqYTK4lz+tB3U7fKRzIrTfbVeuxCDUen3XqP4RQXbGTJ8aOLJlLZhbLYsiN7AVPJoBz+wJzTn8UcOiR75w6QhRO1SoWqSCKh+/Pf+bpGRGVpzPSStXXJWLvDkaXt4nFtrYxXNp6XGB2qzQ2SF79Pp75xSt0HIUYcF3d/wn4AhlHNE1LFCIJdpESF9+CUPGYrSGAIbHRmT+cWrMF2oj//72fZmtUTbUyH8+3BsAH7GruKonHd5Na8t+t/rv4C1uBJyrfycv3RiOuxpqPYBZyyBJHXbdxkDS5seDUU4l+rO3EAz3hAlKnKTZeDEVKaRaJem8OmghkB2/sAUEgGDUQTC9NeXW6kyhk4+J8fP/g+9IJ8fytaxt8sSKAPMPEfZhNDXbny0iIh1gMFEbQuoz8aOBu82UTROGA+OzceEAyEIs8L7LGQZ9Jj/wadubBI2xuebzkVabnS3MfBCwgyWcFdrxgRBRVleplUXo9GV60osqSb7DgYNqLeknWf/f69JFMpGhFNsCrzZxl1Accl4O3887oOPaDR4c61XmMqloVwhfKuOIkaT11/ucnPeMdY1JS6uQG/gxenrdl1+g62yFSG9qn9djPmlGoV3UoXxMDESOKTDI7rFGeJqMJYEmTwqXUnF9+2lSSB5/BfZLUcytUBFeOw9B36NlhQkW76UxTqwlZBXdY+dNL65gA6hDlu89/c1vf9L
 oXTZ/W2g
 V3x4miFBs1ZKtNhiBRmwnf+UK8GKSh2pGwApyYiDtNM6SWuqquHThMTc8id2d9BWLDVlk4QmSTwD+Ms5W9y1C4a4PRqZTuJMENRa75AD1fSWzLnpNm4KRbf9PdxrcVuwKOjcyMWvrBpWDjpMTSz62epoxAVoPqIJUv1GhYmDbr1/3gRLBW8uO1bwvaj4N94io2MTgz1Gv6nYgbIxVZFj5ohMbfvO5bhRQm9LTVrvTNzEZ1TMKd9mZ8JeWmiltZ4kVS0mUvfo52jEDloz0XRNnxDYd9RNs4G5rdhZqP0iR2IAqH34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To lay the foundation for a future change that converts
MAP_PRIVATE-/dev/zero mappings to be truly anonymous, add the ability to
uniquely identify these mappings.

With the memory character device now part of mm/ this is trivially
achievable through a file_is_dev_zero() predicate that simply tests that
the file operation hooks are zero_fops.

Also update userland VMA tests to expose file_is_dev_zero() and provide
a stub zero_fops for testing.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/char-mem.c                   | 13 +++++++++++++
 mm/internal.h                   |  3 +++
 tools/testing/vma/include/dup.h |  7 +++++++
 tools/testing/vma/shared.c      |  9 +++++++++
 4 files changed, 32 insertions(+)

diff --git a/mm/char-mem.c b/mm/char-mem.c
index d2e575545044..e53e89e6ddd8 100644
--- a/mm/char-mem.c
+++ b/mm/char-mem.c
@@ -31,6 +31,8 @@
 #include <linux/uaccess.h>
 #include <linux/security.h>
 
+#include "internal.h"
+
 #define DEVMEM_MINOR	1
 #define DEVPORT_MINOR	4
 
@@ -707,6 +709,17 @@ static const struct memdev {
 #endif
 };
 
+/**
+ * file_is_dev_zero() - is the specified @file associated with the /dev/zero
+ * driver?
+ * @file: File to test.
+ * Returns: true if it is, false otherwise.
+ */
+bool file_is_dev_zero(const struct file *file)
+{
+	return file && file->f_op == &zero_fops;
+}
+
 static int memory_open(struct inode *inode, struct file *filp)
 {
 	int minor;
diff --git a/mm/internal.h b/mm/internal.h
index e16f1250b25c..5d474e5f7709 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1638,4 +1638,7 @@ static inline bool can_spin_trylock(void)
 	return true;
 }
 
+/* char-mem.c */
+bool file_is_dev_zero(const struct file *file);
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 57046d8ac81d..0d1a2ac88922 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1641,3 +1641,10 @@ static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
 
 	return pgoff;
 }
+
+extern const struct file_operations zero_fops;
+
+static inline bool file_is_dev_zero(const struct file *file)
+{
+	return file && file->f_op == &zero_fops;
+}
diff --git a/tools/testing/vma/shared.c b/tools/testing/vma/shared.c
index 4a39c9d50489..8c4826499f40 100644
--- a/tools/testing/vma/shared.c
+++ b/tools/testing/vma/shared.c
@@ -12,6 +12,15 @@ const struct vm_operations_struct vma_dummy_vm_ops;
 struct anon_vma dummy_anon_vma;
 struct task_struct __current;
 
+static int mmap_zero_prepare(struct vm_area_desc *desc)
+{
+	return 0;
+}
+
+const struct file_operations zero_fops = {
+	.mmap_prepare = mmap_zero_prepare,
+};
+
 struct vm_area_struct *alloc_vma(struct mm_struct *mm,
 		unsigned long start, unsigned long end,
 		pgoff_t pgoff, vma_flags_t vma_flags)

-- 
2.55.0


