Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F076FC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 18:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06D906B00B5; Wed,  2 Sep 2026 14:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044B36B00B6; Wed,  2 Sep 2026 14:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5746B00B7; Wed,  2 Sep 2026 14:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF1166B00B5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:00:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E0EE140205
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:00:59 +0000 (UTC)
X-FDA: 85169588238.13.01C1031
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6052DC0015
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:00:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=doxzFlR+;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788372057;
	b=b018mkQ4PDGCXaUTOcNJRgz7DQHumjarZzN9Tf9710tOKbP07X74kPjLYR4khkmFL7VyWj
	eO6afXoNBaj2LYeQ8V/HpHIamRJja871EAJCMdlf7XKIf2I0lfcGs+8qPJ1XRYjhezQ+jL
	G1NxEHCqzyK7xvdABTi+vbZG3MbzxM4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=doxzFlR+;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788372057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jalqcGbTgpiwMOKCsH/rxa3bYllTMGaMYpLwBNB765E=;
	b=NmNo3QjBwhI9Zw1ZtDgukAaia3Z3JrVu3RA1lYenjX8QH7IouepjKL0Em2ou9hti2La46d
	m25JiyQGMM7MnR4/c2fIaAX9RUmjITY5pCsk8sXGm0PRLNZeOFXoMwv9Ce1pA/2+R/rYNG
	swgfbr0EKebKFnr9OSRwktS1xa163Sk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8477543240;
	Wed,  2 Sep 2026 18:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618101F000E9;
	Wed,  2 Sep 2026 18:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788372056;
	bh=jalqcGbTgpiwMOKCsH/rxa3bYllTMGaMYpLwBNB765E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=doxzFlR+siE8INCIvg2cvuz6MHpVNZMF68w2lxnCxkffbz1ZHhmabPy8brvZyPiaB
	 QnZToLPbA8CMmcfXQZeQkjbEtUfFMArC1EX06mMDwjMMCckjtZk5t1nxZ8/ZHv0ZAe
	 1bcr1zeQFzHK+bmBpqwtxYp9gQRp4RiFVGfahnqXT5zTP8gIvKBUNvGrIqJ6QYmbXb
	 GKSkmcJ6lxk7qWSFTH2WfCLTnWRC8noM0Vp8qi8kmAsw0MzXy+DqlaGD7nqJBmTdmN
	 0cn4w4vj63IRafwXlO9E2GjPAgLcsvqdUKtIomG+HD/Cm3WYilI4HzJgHj36RUbwSQ
	 34eVzChAWze1g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 02 Sep 2026 19:00:19 +0100
Subject: [PATCH 2/6] mm: implement file_is_dev_zero() to uniquely identify
 /dev/zero
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-map-private-dev-zero-v1-2-a578c730cec7@kernel.org>
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
In-Reply-To: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2934; i=ljs@kernel.org;
 h=from:subject:message-id; bh=8RUVAZRLPzU4llnS3oLrE03c3Dx8Fmtq1pWNn43ElvA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJmpHiVax5h8JvsqLRXeYlzx+f1kz1m7N39TEJCWcg8e
 VmK26cXHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhIXwTDf5esEO3qK6I3JjL+
 EF/356EG67sPB9dVcgX1COy/8+d57VSGX8wzGk9dfDZ5g87s/3Mapy92fMJc+C1KQNFpZ1yPUfW
 MeDYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: d1j9ypzmd1b6h8313b1hj4745e9t5djk
X-Rspamd-Queue-Id: 6052DC0015
X-Rspamd-Server: rspam06
X-HE-Tag: 1788372057-701205
X-HE-Meta: U2FsdGVkX19/P32wgMvHYGfWaI+CSAbX7JyaHhoVGkxv+BZsIqyqG12PAf10xrGDSoqlnCHYwe82o8VEy5p12d1LYz6sd9jiYm36TiNCHuaaRr8IhKwYNqppqDTKkCRA5PnSJOYrq0loCvH0igPb+LArCkoMD6YmiNaGqYKFVak9rzqiRuj3P/W/T/rElaJeI51F/gbnqdeBHFttKCFCCkSBYVfwxRIwZbFk4AFykBvT2yGMKV6///auMyKpTjTqNqUSwNIfGMf1isbTz47hoPQw5f+CYGiy9BpGNUYlo6k0Hd57wFyx2i6bz3J5zBznNpvaKXh1Rf3fxU57pIQjV5gCle0op9a9NFQPkxqTzYMjc6t8vPojf6smjhBkRBvso9ZoRdcLExLLUvI4EXIDrPeJ3P0P2AVTcLhv7AdHdquq/XTEIdOgO/PgOshS03WgnAKHtkJIo/Zx4Gt9pgt6sbPRr1lfiQLXYqIesSCGcWUhkr+oTjR43w3/w64FZoQyjH3LNJvRv4kQBy5jJ2/66viK0fZYmFgOJpBoyGcHaiIDS5rsyP9KsBvX/NMVeU4qP+MS0ckjvYP9BAZt0g3RKYsD8u+hcvBmLmXJyxlAZGL2a5kpRaVypIYTnwK5zErUI7j+gaGHxvyXFwxf4dB2B+b8YqV0zaJ1HZLqaahxTlJB6OSFgs+/D7A4NAqcB2ipCjO7cxzGkmBQY5M5zZf19hw1QIU6FE6oJttbuCXuduRJkPbCpWOmzZ12E6SIsjxJxiMrAErn2UIMK3kDmJcnT+mCASkH7dK2RcbzMThG1YeKRee0Cfi8kcEix/NEafRXeFU3zDtniBVDl1UCLIKmcy9VMyCwsL6YXFsXOZs/ZLkRpTUD6b27OH+pEJorwvuK4tr5ts1wHSkKNnkKW6sw5Dld/nAB7dvcWH0OIXMOz6L/1Stw1H6xFNG3D7rGgG3W+sxqfDsr/Kz7olhaXPH
 3/1FHklP
 hTPXEAwMpbkjPp0XC/YCLH3jh1EO4yBBdFjD1hLv3TOv8VLV/UqLecy1lOQWrwa8yaydnjHTqxd1jyMrbaYeOm8DdtIQbNoHiWIECQulIky04B2E6+QoSLpAQEldLsAV4dQoQDMmuPsU31sdWc/Xklfjnttvw/AO3rHNW7xqu8kqtljJnEpFYvCoGP1R66Lm6mMERlyXau367sT+fVh1pc+tGJhmtVcpghrgRTA74m5vxJxjQuzvqf4Dbrjo44BIZjDI4EMH7xiewwG7bYF0efjU8sN4SbTb9eek514/zS5FRCbg=
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


