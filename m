Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6407CC98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 10:41:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7950F6B0092; Sat, 26 Sep 2026 06:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76D236B0093; Sat, 26 Sep 2026 06:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AA8F6B0095; Sat, 26 Sep 2026 06:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6C66B0092
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:41:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1C03A6CAD
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:41:33 +0000 (UTC)
X-FDA: 85255572066.30.3CFC331
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 15A31140006
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:41:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bf3UH823;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790419292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QpNjJERy5W0kZ4sRAK5DqssDq5giEzAZ8nJVAHeIm7A=;
	b=rDGgJ8TSx2yXAfd4pzzlpoEIbk2ilyF05moqxAcClGBrZS/8qa6ZZgL81Ly6jLwxhghhez
	sqkkQXrP1PRugghKQkwMdRkD5COTVQM3ocbzqZC5TT9L/5LBsVJjFZwB7E0cMlKKWxWXY3
	/f1Eco+xLJiZ91VcY8nFCiMVqrsHuW0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790419292;
	b=pO/oLdHnJySVsUNSboM1CrkYtQ8n++0VmsxBobfCwwXaYTICWRoYUSuaCrWCLggSxo7pRO
	TzhlzUWv4m09ZpnsnXQnbfyC1HJqAeIg0bRemixYoHcJsW8ndFsd7V3jPDPFHaZh6d7rPb
	l3wRPC5zvepF0XtrD2ve27q8FomlHRY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bf3UH823;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABCC7602C8;
	Sat, 26 Sep 2026 10:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051C41F00898;
	Sat, 26 Sep 2026 10:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790419291;
	bh=QpNjJERy5W0kZ4sRAK5DqssDq5giEzAZ8nJVAHeIm7A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bf3UH823SDyPigbs7RNHaNH2jKNNG8Cihq4p8htIHOFP0y5JPaxJKzygUs/G0S41+
	 qvH12ic20EaJ9etadHm39FyDSWwS/1JqRu3taTIBWeIhsTJNSXxxULGOc1zSRZU1e8
	 /NkpnZRm2YbTo5anSZ3jMGIiuSo/Wj6yes7xyynt+PFF7DD8i+JRTRkF4pJCWaqw10
	 YXLw3YB193YrQs0PmKXPMMgvy6eJ1hMGZOeQBbFCQbOFZpAXXIAsss//DISRZ+S18w
	 oD1HDq0RdLj6II9up3zANivAUvWWKAN84FV03dw2h7iZcA3DR2dpboP2KN2P4SXG4U
	 2J+uMGvjwkokQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 26 Sep 2026 11:41:07 +0100
Subject: [PATCH v3 2/6] mm: implement file_is_dev_zero() to uniquely
 identify /dev/zero
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260926-map-private-dev-zero-v3-2-d4781e84ccfc@kernel.org>
References: <20260926-map-private-dev-zero-v3-0-d4781e84ccfc@kernel.org>
In-Reply-To: <20260926-map-private-dev-zero-v3-0-d4781e84ccfc@kernel.org>
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
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2L/SZUz/xt+YCHmOZAPNVR/emF+mUGhpznuz9NHu/+
 ZlfkYv7O0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARUUNGhofakp8W1xypEPqm
 YdMh/+jFtb13zgT8z7tm055uai8VZM3IsF4kyNlMPifU9laL+nZRr5jX7YHa1pt04kysJuazPJb
 mAQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: piaeys5mi1ey8yx56exckiyw6s16s1kp
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 15A31140006
X-HE-Tag: 1790419291-506156
X-HE-Meta: U2FsdGVkX1+Z1OXmy7yg8/K/xuhL0yMQu8srxZRXaZqKwdDAocCpkUJr1l/K/kHEyE/EdDImNrhKY5igyqB5IOAThhJyI8R4rk9rDYJv0BGxXPl0A77GQLwegHVH3KOR45qIgPzG0mH73vmxBQKtvOCM14y4OKcmjV72ktyb3JltceIFJfeZon5fLmaO5e36HgwIHRBG+qEAPKX+KK/wu3kaibESWNBTiSGalu8p/bwAVerxNys0A1rBSEMrCfkrIMkcsPvyq0e9DI8glkxTV4gn+p3/uYZ8t38EeZN4t0Md5wqgmB/fp4aQR1SSAWFJ3VMAA/7XBlNBt1k7GBTSmVUecM3zetkQqlY5zu18alGFcgGOk1xR55GwnZZbuMLwFbE3LdqfIldq7pGv2zE5HS58tyVWpWWqd3d8pLdia+XTU6dbfKAhU4KwwQo2TJd7R6O6GyEID399d4Qqtqmbib9CpH2auhOegO6lp1Rms+8RuPEMF8LAP+hf4SZ5vqVhExDO5eVYPx87u5LjvaisAQdU/XjsNqHMRNJqMV60T7cM6KmBH4j/08VOHN10/KoIcIidSeC0GY1lYqpswK2Enex5D1pq2JEo25Br7hxpQ12RppVXMPewwmKRRTVQaGvTQSi2+2SlDG4lmsnOIvsTr/S4v+CDLbGkhPyPEZjRJLaLNxsycnQevdOtCR3kWXt/untpYl0wrYe4pl7XsNgUvrQvkKsqqcOq8kuCcfHSc94iE9EJfRK54IgoOr8mj9KBwEC5YXrArMDW5ZMZ0NlpEciTpihEsdK4lDIARYi+V1ZxAyr4Y11dZiZgHqCxh+URQOzug9iKcHpF71ZzhQ+yUaP9kt2b4UonRBuU4aaoHIDRbAnSUWJuTx+YBhipln3oAkxbnVh2ZgAMxjxvCelgc1leb2zXdIa+urckhLSj0ZVPlbXBNuTm3scSwKLGzrg4FSND450D8o1n6GcnAiZ
 CUEJDlJ3
 jKa095q+x56Rilpn/6Q/Ix1/zytB4WEsC2oPFzAyqdxn/mrWXAGNcZHFVeAlCmO5biJBZ6N/7Oy8/JrXtfhQY1WZUROUXjFxijAEiBozPc08GNL221hPMiIw8dY1jVYrJdhZRe4Bmik37YDAAyxpPX5vNFsQHyS2RBM2sGVFjU6QVsbRYJwP+wkmojyFBUVU5/Wr+Nl0t+xiYu0v8Hgfv+uPcNYTOMEm+UL6VWWLtNDpSOm2lUlWBTPcV4iycH+CHjDhHXZ2rGZdUFGQTDysp2IvJIDRaOAfawgM9
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


