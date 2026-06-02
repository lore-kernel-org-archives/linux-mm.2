Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50B99CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 11:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57176B03DA; Tue,  2 Jun 2026 07:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B079F6B03DE; Tue,  2 Jun 2026 07:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1C796B03E2; Tue,  2 Jun 2026 07:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B87E6B03DA
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:06:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AB34926CB
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:06:47 +0000 (UTC)
X-FDA: 84834694854.25.9692CD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 81942A0016
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 11:06:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f+coS9bU;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780398405;
	b=vSTh38pAA4QqhJALfEhP64LAkXumyVwNw4nWCbNDiNidKsQQL5qCaVN6PyBQEgmxhMvw4G
	9qqrjY9lJ6PYIKL7ZlTaEZcQ4xnxq0rEWZH9aVVEZSwILhi0sTix9C2jjMY4vuXxC/avhg
	2e1BrDySk5vinp0w6gYP0jRujELye0Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f+coS9bU;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780398405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F0B4o40L/vdj2UPhP5HubCeeLQUl0X/X8R3+9RCeRZg=;
	b=5TAPh0K1IKEW7FcMj0fcT6Bgcr4uJs3YsiwC1TG1xRduPDvcV/mW9ARrGXfpTKlR2SXNXt
	JQZi44XxYc+vGL6cykDLTan0gmQigY/7TfB8Eo1qBRQ4+/zc5K7extlTb7UUnyFJtqykuU
	pITL8u4tqNyWqJENhG7nA5ZY1XITzfU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE77341A60;
	Tue,  2 Jun 2026 11:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3ED21F00893;
	Tue,  2 Jun 2026 11:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780398404;
	bh=F0B4o40L/vdj2UPhP5HubCeeLQUl0X/X8R3+9RCeRZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+coS9bU/z238epRHKz7qsUSfNlbI1vN65w1piUAjQpmEbE1+knhgPdMYy7EuCGUu
	 RVI5RamVpaOq5bbv8hFl4Gnxyu0uSH2rIMp6z6/LLB9WNaftYjNaVtO06cNrXKfc+u
	 Kyzps1uzP4+Jvo7jKrpeZVzYXAeAQ3ueR08qqHTc/Bzlwy00x0vHtK543+hwiiGtbv
	 t7EaBmMUX+AOmFYJR6R1r0T145Q2/5bkp2lIP1imPi1IYg0CNAtd7JiIZEy1nssUbk
	 fc5o6j3s/3OSdF1n1Zfti14oi8XVQmzhHVMlU1cwzSNRbX0M3OBenmXIrQZ0h6Jwx0
	 RuH7ioPtk6/3A==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 3/3] mm/vma: eliminate mmap_action->error_hook, introduce error_override
Date: Tue,  2 Jun 2026 12:06:27 +0100
Message-ID: <55d13f7d016b827c459946d46a56105635be111c.1780397980.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780397980.git.ljs@kernel.org>
References: <cover.1780397980.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 81942A0016
X-Stat-Signature: xbd9bs7g7uy9whhsiasg89q39jrcudx5
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780398405-291500
X-HE-Meta: U2FsdGVkX19wLg9cXqt6JE51VblTX8w0n6gU9eBVVOYLxv6zFvcHxhMIAxIuISu8Y+ncE4wln8pkKCGJN98EGwM9MjBf2MdQBVtew8sH5uemUCSdKW4FAXOm5QW0xhOHPP6J9WIwcxXFxOYGB3QgTr/f+ufQs/Qi4gujTSidNSUWFr6VYxZuf7M3WzsUSB8hoajEW8PZOM9/3hLFUqygbrubP99WFg17qLiUJ0mQ+y35RJKT/02dymoLcKKLF/X0PcUb2cAS9IiucOMlabLF1A2rNYixQvzJ9358l78fAAhJhjzxpDMNbm9aSXY5dBPM+kBFNqIhssdhnq/d6jwjiEZbcAROZFvnTfHzlc6JNIben7kItHy+fIwDMGGzKAteuKPVp2ylcVWiEZRSoUc5SZswLzYHHEYMj5ZidQeHb6JuCJG9UombdnRtBxDxCUaild/yRnxd+0NCJhq0RB4fyq9mUo8nkQ4wDhcnu21eT0jlfnz6mUg+IZHWEZmVpyno8ZDkuhqOl+69Or7EBPkW/8pA6kF/HZwiOQfjLLrfK9zVf2FHJIEdVhVhyHDzgeaUXMxY3voHTAmHffUkFC26kskzIRJETozyT51Xm72LWDx9BX2PCDq5bove/OLAgqRiUNDVKhy+JkcjTJsXW/kUoYURFxvgwrOzxqggtEKEYTQpla20AlBrytbYZnfKBCQoy1/Ca2d30wM0XF4RK9WOfMCYMUIm3nJuvDigBC40v7IRBvqZ0LAJIieyde4Xty+4Z0ulmfzv2eFQDz6z2UFWT9KWVP26gDlSXgmh3VV3aZVMZQgBc4Rf5ZFC6RppNv4Y5AQcD85smHfLoqaG+cLfE3tTegDCkxMj6+fyWED7fDguQPvISogoOere1NnB/O4Qloilj/QAMmHi4jXCV4aGP39W6YwI/SkMAZEtjN4tyeWKeOUiWHCXCO9aaeV4VRoCXbM+01oS1coKgl/Lye4
 ZtVp6SdU
 H8cLgwMax7gXSRRcv4qV0lMrLP9f16qDt7bDQCsJCgXapwqtwMIeYiE8Iy0/a7nbnPC8COXLxoD47+nxgj8GEbj8nIqG0qRaYgLHYd+rwaNkz+fNeiQjcLCZcpFwZ6ZPvwIWbEBctOQ/CY8dK0K5iMe6vWEcJTTCkdxn60JRuU7akxDLz35BTvnyi+fJ7nJoBoulhQWBinw8kDShqk4j9hl579n7aVDeG/R2yTQnUfesJRRMFVENnr50Jc2qdWMyRHImLUwM/zlYjfz42RkbKyCuvGS9L088wAoeK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than providing a hook, simplify things by providing the ability to
override mmap action errors.  This allows us to more carefully validate the
value provided and thus ensure only a valid error code is specified, and
simplifies the interface.

This way, we eliminate all hooks but mmap_prepare and allow only mmap
actions to be specified (which core mm controls).

This significantly improves robustness and eliminates any unnecessary code
duplication in driver mmap hooks.

We also update the /dev/mem logic (the only user) to use
mmap_action->error_override instead.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 drivers/char/mem.c              |  8 +-------
 include/linux/mm_types.h        |  9 +++------
 mm/util.c                       | 29 +++++++++++++++++++++--------
 tools/testing/vma/include/dup.h |  9 +++------
 4 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index a4297eb39887..63253d1de5d7 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -322,11 +322,6 @@ static const struct vm_operations_struct mmap_mem_ops = {
 #endif
 };
 
-static int mmap_filter_error(int err)
-{
-	return -EAGAIN;
-}
-
 static int mmap_mem_prepare(struct vm_area_desc *desc)
 {
 	struct file *file = desc->file;
@@ -362,8 +357,7 @@ static int mmap_mem_prepare(struct vm_area_desc *desc)
 
 	/* Remap-pfn-range will mark the range with the I/O flag. */
 	mmap_action_remap_full(desc, desc->pgoff);
-	/* We filter remap errors to -EAGAIN. */
-	desc->action.error_hook = mmap_filter_error;
+	desc->action.error_override = -EAGAIN;
 
 	return 0;
 }
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 945c0a5386d6..5ef78617ce93 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -844,13 +844,10 @@ struct mmap_action {
 	enum mmap_action_type type;
 
 	/*
-	 * If specified, this hook is invoked when an error occurred when
-	 * attempting the selected action.
-	 *
-	 * The hook can return an error code in order to filter the error, but
-	 * it is not valid to clear the error here.
+	 * If non-zero, replace errors that arise from mmap actions with this
+	 * value instead. Only valid error codes may be specified.
 	 */
-	int (*error_hook)(int err);
+	int error_override;
 
 	/*
 	 * This should be set in rare instances where the operation required
diff --git a/mm/util.c b/mm/util.c
index 4e172990afcd..af2c2103f0d9 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1414,16 +1414,22 @@ static int mmap_action_finish(struct vm_area_struct *vma,
 	 */
 	len = vma_pages(vma) << PAGE_SHIFT;
 	do_munmap(current->mm, vma->vm_start, len, NULL);
-	if (action->error_hook) {
-		/* We may want to filter the error. */
-		err = action->error_hook(err);
-		/* The caller should not clear the error. */
-		VM_WARN_ON_ONCE(!err);
-	}
-	return err;
+
+	return action->error_override ?: err;
 }
 
 #ifdef CONFIG_MMU
+
+static int check_mmap_action(struct mmap_action *action)
+{
+	const unsigned long override = action->error_override;
+
+	if (WARN_ON_ONCE(override && !IS_ERR_VALUE(override)))
+		return -EINVAL;
+
+	return 0;
+}
+
 /**
  * mmap_action_prepare - Perform preparatory setup for an VMA descriptor
  * action which need to be performed.
@@ -1433,7 +1439,14 @@ static int mmap_action_finish(struct vm_area_struct *vma,
  */
 int mmap_action_prepare(struct vm_area_desc *desc)
 {
-	switch (desc->action.type) {
+	struct mmap_action *action = &desc->action;
+	int err;
+
+	err = check_mmap_action(action);
+	if (err)
+		return err;
+
+	switch (action->type) {
 	case MMAP_NOTHING:
 		return 0;
 	case MMAP_REMAP_PFN:
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index fddfd1b57c09..bf26b3f48d3a 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -483,13 +483,10 @@ struct mmap_action {
 	enum mmap_action_type type;
 
 	/*
-	 * If specified, this hook is invoked when an error occurred when
-	 * attempting the selection action.
-	 *
-	 * The hook can return an error code in order to filter the error, but
-	 * it is not valid to clear the error here.
+	 * If non-zero, replace errors that arise from mmap actions with this
+	 * value instead. Only valid error codes may be specified.
 	 */
-	int (*error_hook)(int err);
+	int error_override;
 
 	/*
 	 * This should be set in rare instances where the operation required
-- 
2.54.0


