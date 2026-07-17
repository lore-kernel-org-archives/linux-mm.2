Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C00A4C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B72466B00C9; Fri, 17 Jul 2026 13:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A916B00CA; Fri, 17 Jul 2026 13:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87B46B00CB; Fri, 17 Jul 2026 13:27:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67E2E6B00C9
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:27:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C82651A0201
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:27:41 +0000 (UTC)
X-FDA: 84998950722.17.8091370
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0921740007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:27:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h5lrnV+N;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784309260;
	b=YuIH8+xRxB3ZKfzIt0BcSL/ff+IC77XZMQVRFhlhM7BUf+a1Vj/wccOwAJARhqCtB3dLSb
	NDX05YAKJ6wk+TWp74OKzV8zdfkYsqlUrW4DPOQ6y5KPC8E/5IFNkuGoVPD1ozot5uPVRA
	uDkGPuPtIjaoo6oDzJUW/4rqqcIU0gM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h5lrnV+N;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784309260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8715hya/g0NKVec9bzb/sd63YPbKJXZUIO5+V7cVQ8=;
	b=csNRRJcaHk1glsfliQT1ZDaDz1ae7p+xSxCm2qlcC7yJoC7/i+e6QJMqibyAF2VPLZ7AXT
	qoU+ZKb/SS1uPAFcsFVM11/AFBFwFpjMLKm5F+/My7mVmPmomaAwskrlbOwOTNiEdIctdP
	yBzum2qd8LfmU4mA+BMpiO1n34jzg3c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7EB4560A77;
	Fri, 17 Jul 2026 17:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E87D1F000E9;
	Fri, 17 Jul 2026 17:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309259;
	bh=C8715hya/g0NKVec9bzb/sd63YPbKJXZUIO5+V7cVQ8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h5lrnV+NVw1sZK8KnxqV+HWsnNdAyHsFT0M3MXrmdEn2VGhpfscesbf5LsHGWtqVz
	 wLyNn4Y+o/JXKEzS/O35+n4FwxEefrTM13NDrKh4ilX2wQTHIqJXpNkB9BCqqoVCzk
	 O+BQMJLV46NT74u7C5nX2Ze4ZgIzk9JwCa5TcLExD7Ht+U7aEEzO146bEO3iMEAfcy
	 jOHNVEHGqAOBJBoW6nSTe7wPtZQe1UxCe15QrB3/napbdHrbLhWwebKMARAOHDpFz0
	 Up8aK7M1f/Pf17zrGP+18lrqY8d9fa7nNOY6EuOo81Vr20d0wQhGp6jIk7aKAK0x1g
	 bY71h2H032Sbg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 18:27:10 +0100
Subject: [PATCH v2 2/3] mm/mseal: limit scope of mseal address zero to
 address zero
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-mseal-fixups-v2-2-0daa0014b813@kernel.org>
References: <20260717-mseal-fixups-v2-0-0daa0014b813@kernel.org>
In-Reply-To: <20260717-mseal-fixups-v2-0-0daa0014b813@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4628; i=ljs@kernel.org;
 h=from:subject:message-id; bh=zNaXN89YTmnYqq+jHnFLlAdY8+gqqdMCq58SBYujaWg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKiUr84Xw99n3I+OZ+lMKKvQ/3vuTfauvFFfZ0OPk8kP
 ZYL7LvbUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIlYv2P473dJM6mISfj9x9O3
 g58wGGennVrx5fWRU1MqeW85Pzj07i/D/5AVCc/mhy48O0FoaZmc3qeXy/5xWFzfOXPx6XOOxwQ
 ufOEEAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0921740007
X-Stat-Signature: ugbrhtxp4ek9h3jpdeqajt8u7m9jmfrp
X-HE-Tag: 1784309259-830858
X-HE-Meta: U2FsdGVkX19COKJiwoNkZAriS4mqsIoq3LxfeBtmDL4ndehd6uSZwZ8k4LUBfFOjyVDTxmGx7uLk7XS6gJR6yRZMihXEV6ZMFyjHi4qnH1jzIJLOdDabk3r2TzdLZ+444dpi125Ef41wNMHoK0qPJi8QwZpLqhIFEDl7w2nAjELdtwT+C3RbRizInQWVLdPo20eUGS31/WLz9W2ncgU/6rm6jjMOkrcFccbyvyI0J8ApnXllAk2LzpHgyJsNSl+J90Z3/MbYqF+Zg31nYFqev/Y9cxrXLScuC+scQ2HFEwULhjKjHyRNVFa4a5DbSzq/M9Ln7yWqzSx+OJZ5SlEU9eSB15O3ujUfXNNXnNI36YWNv8Hxtf+GoAkbG59Nd50jkJA485ImOBtbBLE1whHYFxzWWdN9b+kygFU4QQHNBA1ppE94cgH7Otwp0UMDLULJW+jj3/dp62kbDUwseOCeW/9Gm3b539F+Qs7+r1P4Ulys8WWhBfCzAfWXOnaVu2Jr9zdqYuVyzN96dsrRKCJB85fTGWbWSkyqobYxreA+f2/neSxIQ3S+SJGAqJh+SZZ5EUJ9yRfaOuetskqG/0c78y6aBmZ4FoijX1W6EdwZFAZIxKQALF9B+9Amx49Wa8EgPFTupe/EsUwRXjCYl7myb/Kx38rR02aHbD70W4O5taJ/Au5Lnx1sW5rLPsD3GHzU2de5hhzxWh/cDWfZSGs3lqmDZu8yctPfL4HEmB/ommriz36jZF4gewvgvcR6JyFCXoKKFgEfzf9b0l5hJsPk5JIPjgZ4RpKWBqyEI24tqSfnRFlRyZGaLfCWPclZnL741rb85OSQwRXhX6qCMokk0kH1t2gU8YAgTqsSV4wrEeP7C5yEvFAXI3Kw5h0jSdQAs7LAlYGbPRi6ytQmszgNdtnZBmHqNCkjE2Kd6rnBmTLMVGdr7RFyKU0QSAJiyq0rqvz/RYI5dW9AWN76CSK
 rQm3vZIe
 RaS8+gL5qKbk5cA0ELoTGgXq90PMjkviaUUAkNofW5H7upaWe1y6Af9f+p8Iq1vChQ+JJ0tjq/t6v7WPsJUGSUt2VizQNGT3ei/tucxDzNsbv16Nxw879POCq0icwCjroH0+DsN9lAuo2u8+LNUaqKxU5DQGfzdtAV3PJts1xMdUvWvLRuogK/hk5UtdeMzh2EZnHqwgATGeld6ZXGfMmQwUp3uR5SJ6QiUoetve30mbSf5+eW+5tyMdcGp8TzTxzqPngG78rzb+2hH0RGwLSkRZGZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 44f65d900698 ("binfmt_elf: mseal address zero") unconditionally
provided do_mseal() to any internal kernel caller in order to address a
corner case slated for possible removal.

It also incorrectly attempts to mseal without checking to see whether the
mapping even succeeded.

Restrict the scope to the corner case by providing mseal_mmap_page_zero()
which asserts the MMAP_PAGE_ZERO personality.

Avoid unnecessary checks in the start, end range by abstracting the actual
mseal()'ing to mseal_range() and have mseal_mmap_page_zero() call that
instead.

Also only try to seal the VMA if we mapped the VMA. This isn't strictly
necessary as the operation would error out anyway, but it's useless work
and could be problematic if me make future changes to mseal semantics.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/binfmt_elf.c    |  7 ++-----
 include/linux/mm.h |  8 ++------
 mm/mseal.c         | 49 +++++++++++++++++++++++++++++++++++--------------
 3 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 16a56b6b3f6c..e3131a311995 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1353,11 +1353,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		   emulate the SVr4 behavior. Sigh. */
 		error = vm_mmap(NULL, 0, PAGE_SIZE, PROT_READ | PROT_EXEC,
 				MAP_FIXED | MAP_PRIVATE, 0);
-
-		retval = do_mseal(0, PAGE_SIZE, 0);
-		if (retval)
-			pr_warn_ratelimited("pid=%d, couldn't seal address 0, ret=%d.\n",
-					    task_pid_nr(current), retval);
+		if (!error)
+			mseal_mmap_page_zero();
 	}
 
 	regs = current_pt_regs();
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 550fb92957d1..87feaa5a2b78 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5291,13 +5291,9 @@ int reserve_mem_find_by_name(const char *name, phys_addr_t *start, phys_addr_t *
 int reserve_mem_release_by_name(const char *name);
 
 #ifdef CONFIG_64BIT
-int do_mseal(unsigned long start, size_t len_in, unsigned long flags);
+void mseal_mmap_page_zero(void);
 #else
-static inline int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
-{
-	/* noop on 32 bit */
-	return 0;
-}
+static inline void mseal_mmap_page_zero(void) {}
 #endif
 
 /*
diff --git a/mm/mseal.c b/mm/mseal.c
index 430a252a6da4..2a516da694c6 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -32,7 +32,7 @@ static bool range_contains_unmapped(unsigned long start, unsigned long end)
 	return prev_end < end;
 }
 
-static int mseal_apply(unsigned long start, unsigned long end)
+static int __mseal_range(unsigned long start, unsigned long end)
 {
 	VMA_ITERATOR(vmi, current->mm, start);
 	struct vm_area_struct *vma, *prev;
@@ -66,6 +66,38 @@ static int mseal_apply(unsigned long start, unsigned long end)
 	return 0;
 }
 
+static int mseal_range(unsigned long start, unsigned long end)
+{
+	int err;
+
+	err = mmap_write_lock_killable(current->mm);
+	if (err)
+		return err;
+	if (range_contains_unmapped(start, end))
+		err = -ENOMEM;
+	else
+		err = __mseal_range(start, end);
+	mmap_write_unlock(current->mm);
+	return err;
+}
+
+/**
+ * mseal_mmap_page_zero() - If the MMAP_PAGE_ZERO personality is set, mseal()
+ * the page mapped at address zero.
+ */
+void mseal_mmap_page_zero(void)
+{
+	int err;
+
+	if (WARN_ON_ONCE(!(current->personality & MMAP_PAGE_ZERO)))
+		return;
+
+	err = mseal_range(0, PAGE_SIZE);
+	if (err)
+		pr_warn_ratelimited("pid=%d, couldn't seal address 0, ret=%d.\n",
+				    task_pid_nr(current), err);
+}
+
 /*
  * mseal(2) seals the VM's meta data from
  * selected syscalls.
@@ -118,11 +150,9 @@ static int mseal_apply(unsigned long start, unsigned long end)
  *
  *  unseal() is not supported.
  */
-int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
+static int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 {
-	struct mm_struct *mm = current->mm;
 	unsigned long end;
-	int ret = 0;
 	size_t len;
 
 	/* Verify flags not set. */
@@ -145,16 +175,7 @@ int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 	if (end == start)
 		return 0;
 
-	if (mmap_write_lock_killable(mm))
-		return -EINTR;
-
-	if (range_contains_unmapped(start, end))
-		ret = -ENOMEM;
-	else
-		ret = mseal_apply(start, end);
-
-	mmap_write_unlock(mm);
-	return ret;
+	return mseal_range(start, end);
 }
 
 SYSCALL_DEFINE3(mseal, unsigned long, start, size_t, len, unsigned long,

-- 
2.55.0


