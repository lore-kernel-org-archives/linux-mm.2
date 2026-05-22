Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6E56CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4166B00C8; Fri, 22 May 2026 12:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42DCD6B00CA; Fri, 22 May 2026 12:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C0C6B00CB; Fri, 22 May 2026 12:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7006B00C8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:00:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF9491A0ACD
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:00:26 +0000 (UTC)
X-FDA: 84795518052.28.948B4B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id AD5C5180005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:00:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aHQW+4zp;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779465625; a=rsa-sha256;
	cv=none;
	b=6mY9HJhlgd/BzVWZ5Be3YVT55pc9xRjF+Qwk5YtwUFpqB/bsozuWW28Y7RJYcyW1saHMj/
	Q4355aaRw65dftS+ie+gyAFe8cb74yLpX38UhR6NJKDhhpKAmbLNV/LwemK1YZNVQrfqKK
	S8AmEOGm8okElW8zL/pfV8DTkzHuEmM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aHQW+4zp;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779465625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=316RJj3nC9oY2FUmt7SPv6BDYnUsOE3VTbuP2TV/Ess=;
	b=JjbY6TrjWFotmK0kN6n/m2+OrGlE2inytZKT5mB+ZTbxY9V6qBbQgknTfjDCXV+dsfQYJH
	chJmw/BVVMxkq+hqtklXSevWAlzg5iQIjD48WkksekqrzshHHKS7sKdq/WSvtqhgas9Tij
	Pknr0M2CS99DGTe7hVwp3diOahIA8ic=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EEDF7445AB;
	Fri, 22 May 2026 16:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4249D1F00A3D;
	Fri, 22 May 2026 16:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779465623;
	bh=316RJj3nC9oY2FUmt7SPv6BDYnUsOE3VTbuP2TV/Ess=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aHQW+4zp4Ue8xoxOd05U7Jt/Y2i2slzBpf2CQ1ORoAad8i7w9ZQU29LvdVg7Mt4ym
	 HlN43tUOzQxvRhXfBTuhVKnY6kMoZgR36LpiKoNT+Sc2MTFHQuUVm4wfoB7J7zAdKr
	 9wNTfKvz0gnfcKwuqecKaDhLKnq96mZS1xb/JJhCGECEcTTYnWjcEipnLd7jsC7ldz
	 mhgsA+1oQI7sZnGQndk/YjfGgr1sKZ8/CHfnfaPFqgoteq55Udg1YtJjWQ0wuVNLMz
	 myMa97/dN7g/i1JFfq35hneSFMuZnoDSuRSrEWkRRcS6bfNlEjdIvqN97fN52YtVtJ
	 RWRDJAO4QQmPA==
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
Subject: [PATCH v2 3/3] mm/vma: eliminate mmap_action->error_hook, introduce error_filter
Date: Fri, 22 May 2026 17:00:11 +0100
Message-ID: <e770b28427937057fa953ac380a134b24acd8bb4.1779462249.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779462249.git.ljs@kernel.org>
References: <cover.1779462249.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AD5C5180005
X-Rspamd-Server: rspam03
X-Stat-Signature: cdxc4wkxnxbp9rdam6u4bxzeeucid74u
X-HE-Tag: 1779465624-826028
X-HE-Meta: U2FsdGVkX18XKIQfJNTfPIpW2jiN1X9PRe/sUrOSYO7zkgOjIdhyet8wGdOFqpEDzuLvUbE7TGqnWNsT6AtZY65+Hg6JHiJ9xUz7fExvbS9UpcCec9MDLSYG077iJL1EC5eZ+teeE8bzthpA5RzwXShtze7v1PVTqQFbSoqc0vHI2eYNEgRrSo2Y4hkfdi6EaO6rBmdAeUTDGptoPHkEbpdM8HgRrAeWXV2bnKmIPSVug5+DKwpCs6ABGzBJ3ia4SzmsR3vF+2cJsP4OluqCqqGr55M5ofN9joYV1fb/bK1QJ5IVD6P1C7yx+iMOf2Eoa1hw/aB/N7ReogPyJtXRrs0//goRprWjhfNUxSNMSBlFvySxd7/vsSCQHBS/HP5UlfDrlIiOCW3hJ4COoyK+6HqoY+UKaiK1SzRYHmeJ1Jq/RvSWkR4ngYeHPw+b8n6xDh8bq4Gm7FEx0Jbo3o36VLO2RrtPGmZQUpsFYj8kQ9K8RwBNiot0VhTVx6aBxiPkoucQJYZQ6N0/l6pvsfd5W6JDwYS/QMT4wXS0epk0mN0u0gSaHv+mC2UH7lEczp6/vu9W5NJcQlJ/PW22fWh53WCm3cb+AjKcoly2TgY3fQaQbK6jB+Cdhq4I4rGmPExMe+sgxHXYgYVeU6DxbqSQxnQ708rc5FyNk2bTC85WrS6880y8Q8h9CzJWZ9x8Bw1O43ef5bmMp3kZJiL0H/Fp8BXVfnj9zgbx7kdlu36LPsaU/c5zwPUlc4t5OG8hHvi6YnDP9HosP09cEfxdeb36dlQfi3PRmJ5lqSSaWj3NH4/8MwrRQb8EMjLEJtfqwfK/BfqzfIDVrrui0m6t7a3eGEnKibddBR67qX3YmlHA+NZRPo7eaMOaWwjBB0+w5ziiuykZkzy0apqrIbhbEiV4koLF3xGaOADskSw6VkTkRJlHzlYtoTcgAAX2X/ePnGJ1CneydY6Cb+RtxpSo36w
 RVyYaJLh
 0KvD6g7E9wRxfa7t27z7IVNHY/T7new2+fKzL0QD9EEK1N09jSRAnD8vV2hY358BYl1rhbgIbGGqXxNQmT/xQmiGGpKDIZ7kSVm9cJDdvaGHigUYwrTRSjlHkc7/3sRdTc1A2XdkYHBzXgQHX1NQosS7U+HtSEu0YnrgzP5BNvddpVXtHUvEOoMfOSEj0riLuz5UoqS+o0my6U8d45qSoparTM+zZ/honNYQDyKGBd/Z8mFonT2hVILTfcFjA/4FBVqx0U98NdN7cHzU4cAv019DOydO8hqmVhwRQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rather than providing a hook, simplify things by providing the ability to
filter errors. This allows us to more carefully validate the value provided
and thus ensure only a valid error code is specified, and simplifies the
interface.

This way, we eliminate all hooks but mmap_prepare and allow only mmap
actions to be specified (which core mm controls).

This significantly improves robustness and eliminates any unnecessary code
duplication in driver mmap hooks.

We also update the /dev/mem logic (the only user) to use
mmap_action->error_filter instead.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 drivers/char/mem.c              |  8 +-------
 include/linux/mm_types.h        |  9 +++------
 mm/util.c                       | 29 +++++++++++++++++++++--------
 tools/testing/vma/include/dup.h |  9 +++------
 4 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index a4297eb39887..11639d988e47 100644
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
+	desc->action.error_filter = -EAGAIN;
 
 	return 0;
 }
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 945c0a5386d6..8d1fb85e7684 100644
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
+	 * If non-zero, filter errors that arise from mmap actions such that we
+	 * return error_filter instead. Only valid error codes may be specified.
 	 */
-	int (*error_hook)(int err);
+	int error_filter;
 
 	/*
 	 * This should be set in rare instances where the operation required
diff --git a/mm/util.c b/mm/util.c
index 4e172990afcd..9b4e5432d45a 100644
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
+	return action->error_filter ?: err;
 }
 
 #ifdef CONFIG_MMU
+
+static int check_mmap_action(struct mmap_action *action)
+{
+	const unsigned long filter = action->error_filter;
+
+	if (WARN_ON_ONCE(filter && !IS_ERR_VALUE(filter)))
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
index fddfd1b57c09..bcd569a72087 100644
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
+	 * If non-zero, filter errors that arise from mmap actions such that we
+	 * return error_filter instead. Only valid error codes may be specified.
 	 */
-	int (*error_hook)(int err);
+	int error_filter;
 
 	/*
 	 * This should be set in rare instances where the operation required
-- 
2.54.0


