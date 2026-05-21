Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65918CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 16:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56B16B00B1; Thu, 21 May 2026 12:22:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0EA6B00B2; Thu, 21 May 2026 12:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859F46B00B3; Thu, 21 May 2026 12:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DFF26B00B1
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:22:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3013B1406DC
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:22:12 +0000 (UTC)
X-FDA: 84791944104.29.8DF18E2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9AAEE20006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:22:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HVNb/v0B";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779380530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=atLo39KUHSbdrUnGByF6jC4S9Ytfud1UYa6uCnPklXc=;
	b=zB7nSJRjjg1VXv2KlKZ3xWbdjFBHxkkXWk9YG2mcX4eonP/9mEkmQ1uT+XkhNWMdaL8q7j
	Mwa+jLuAnG72J2QHjsMWuJfuB9e/cMi7R0pVF/GLYV1m3948UOSteN49vT0xWnbaXZ17zw
	2Tb3DLZtWUn9uFac1gHACAsDg7nQwuo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779380530; a=rsa-sha256;
	cv=none;
	b=Zh2+AF7Sp5kGrmZ/nMGaNGSoKo4bQY4lmV/c/NfZABGCKEWAB4FndcJS3+AVe4jg82AUi8
	WjT6KdkcHaillG+tJ/34KhKNDaZggS9zqImCQacFde2zp7A9x347rOM58x2sVqaLgNHCPE
	RkwERCmBDbH9odSQZ1uO5mJYphQZxZo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HVNb/v0B";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2576F601F3;
	Thu, 21 May 2026 16:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5559C1F000E9;
	Thu, 21 May 2026 16:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779380529;
	bh=atLo39KUHSbdrUnGByF6jC4S9Ytfud1UYa6uCnPklXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVNb/v0B7xQNW4EcbSe1zWM13aDZe+C3XtSDg6ukc+rD5Va8iUNrtk1d4xuScUmgt
	 TGAbAHNTc1mAOGK2DxkiUHP32LcZpKvl4Zme2sbIfz949DEgvYrOrNCxv2B6Hh6feN
	 1dRyweyrwhBrZv6mF7z/ABqxobmLrAhWY5TyKIYJXyJDkRhA29uragL6PK8/oL2mTg
	 c39RAl6l7UkkbKcG1PZ8Csa4V8VJMi4CVV6tVEEfCWKHSPO5Je07+1Dz4kwoLbYzZS
	 Pk3h3uspW8Oz24BRpnF8eYN9iGGY/b0N37xVcen8n/zwoEDO2hUAvkPaxZhtBKO329
	 YxgFhZNjrjubg==
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
Subject: [PATCH 3/3] mm/vma: eliminate mmap_action->error_hook, introduce error_filter
Date: Thu, 21 May 2026 17:21:54 +0100
Message-ID: <a2c0cd3406f4e064f8dd8e7c419b8cacbad8f021.1779379804.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779379804.git.ljs@kernel.org>
References: <cover.1779379804.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AAEE20006
X-Rspamd-Server: rspam04
X-Stat-Signature: dqouyjf7wwrpi71i7h7hk1r9xh1mwf17
X-HE-Tag: 1779380530-718290
X-HE-Meta: U2FsdGVkX18w0hSfNGvPLnfq3bNujvYjNPo5Jbxtz+OEVtbY7C/CbNAWxHIHkHVbLEX3W9s3Tv78CcQbRIQmR1g3gZHbjkn528dpMd3DqLCvClXsPPKTfRUGf9MnomtiZ8+LRHtKob5E9Tg5Zy7oJLUMktKCAnuzoc0PKnyfsz9lPGdbVYFmXGBUPFoA0O4GfZ9WVzpD7wQpiUmoFtMT8nEUIIsJLVzbjM7Ya0l8AH/DhXArbabl0nghRNkj1B37EScs2HSaaAyhw3G4/WcKke2puHsQs7hVUB5bCGk9D1Ba2vM/vYKL+CEJc56YPiA4XXfofBJXkwE5U23wInJ7dliN2sYVYQbMCIShPryAsn5k6u7lJKJbqu6DxluD1dMaHomr4Ukv3FEnN0696j6Hi8f+EOwvemQHFLdo8/c0z1y0puE0fQ64Z7bDF+DCO7v53Nvb+niHwPoWh8VULEc0uS+Yx7gGFNNyvVbwO8JFECYPtO1MVmKld29B+TTWuBSmv1gj5FA6NxYQqVExN6R6cKrRuHucbdO+CCpD9EVeJExJnIjy6cw7/11mFNgF09eP2EtJKrXmqw1T7LqcYL2Yew1+g26mgFBLJSyCY0g1MZ0nSKpTaAX9pLXmpvnzT2tLEBHJPHAA60G4kCZHRpqo1WgYz1qKrIpTZ9l2ILRpSBXTMXqmfLkoqG2laiq0fVMFSu7b1UZYfNiYjrFt9jqM9G1KdzAQrq3zSLexHadCg+7pJw75SYlTczCRt/8SdAbOFUKBqr9w5adxbP9uwkWl2VMiQpMtU55oQITn3Me+cBN1SeoL+kK6MLOGFkUqpyn56LyXEOe8/yUkiq4N1s/lY/FULFHUALc+ZDt7U9syDXqlHWUYGPiY5MqxYNRK+y/cbtGuagSptxzWadJkE6kEv+0GUku0G2SZcyPTvehE7HGc2tcAXyVycykMPuLeH7qo9gX8SROLcgd5MKw2roX
 WdPCYaEv
 6QgyJw2hOWMUtHC8mfYqT59I9HqQWiISjq8mWDDKe4HZPd9EjkLD+xxN0UZ5NyiZLcreC3PnBGZa13GI0HbiJwkJFJvsZgeTU7qvK6levvLnwWJdEVMwq+VmTR2qVyLA8hIx5uDaAXzmQJHIxM3eJdyYg2hn3n24IFMbIwAcrUcgU7qJr7Tbn5DPq8rDskeY+k3yZY0DzxvzZN0bp5A/UBUfhH9g+9mbwA2QL5lVjKBiK94T/YGeqL+pk8hyC7UyxBsFtwFM+D5C4SEl41nuYL1X4vQ==
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
index 1555aa1487b8..939ed0b0bb5d 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1413,16 +1413,22 @@ static int mmap_action_finish(struct vm_area_struct *vma,
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
@@ -1432,7 +1438,14 @@ static int mmap_action_finish(struct vm_area_struct *vma,
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
index bf67a80a8332..4f7dd92075a3 100644
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


