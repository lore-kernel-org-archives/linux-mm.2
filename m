Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17995CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 17:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A3C8E0011; Wed, 24 Sep 2025 13:40:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021AA8E0001; Wed, 24 Sep 2025 13:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7A6E8E0011; Wed, 24 Sep 2025 13:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8A098E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:40:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2C771408FE
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:40:47 +0000 (UTC)
X-FDA: 83924858934.13.3E93244
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1A22C1C000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:40:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Iz9bi393;
	spf=pass (imf20.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758735646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LvNuFgAVsZu6pshvnPqZ/JYaqtoCuId1tC+yF0PREAA=;
	b=dPdsK1Xf+w7JZWoybCUPhlXvkK4zzldGaceYitk8VdJyVviSnzpzJI+kvIElAsKGjyzioE
	A6/r8yYBlhIhbyBXmGm0T2GVjCsvQCPR7JSu3Avd8yAjl9pe8u29hBwnVbXdoI8kpK7t9J
	Lla+E7EYdm6Ke9z0rr4kNw1hM5Tfx0M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=Iz9bi393;
	spf=pass (imf20.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758735646; a=rsa-sha256;
	cv=none;
	b=mAeE6DHfw+pm7FMw6SsJWSyS6dqtb9+lmLdH+pHBZsCWdZ84xHB8ovUOt51/+dkGC1cK2s
	ZrKvL9Ysk4tsMJEKYm+OaDFvnmSMBfPTPmAsNwdoqp0bhWO3nGVrgAW7/tL6C1wHFy/qwE
	6LWE76Z3rSLdDRDQWwjT9NAiyUn1PYY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LvNuFgAVsZu6pshvnPqZ/JYaqtoCuId1tC+yF0PREAA=; b=Iz9bi393GJHzqEoSUbMwy9X0s9
	dlx8nTvyw7L+cGGykkkZwZmjG4NgYk/0VNUsBtNFfpn25HCvykxUJgyhp84vHM5or0c6W36FaUJ/q
	J6nG/3uNmkXmow7RjKAN3KgrBrU44jcIPRsgVG/eDSy/fhSEzAn6Fh3hZc9CgmOPVxNBcwJLzavIK
	IUncTU3jGLCiAoDr+WiFoOkjyqUnh1VkUQPJ0IGEunwskwClQSGm/WgMoqvLjihFTPXHecI2EwrPi
	WGvCsBBNTncGQyJBt7qbbkW3P6OJXZ7nYpoN17ZwwIYXwgFjRct0URtAJPv+7kVJNtq7mVgAt5QE6
	ZcV/tnJQ==;
Received: from [179.159.118.139] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1v1TTs-00Gz9Z-D7; Wed, 24 Sep 2025 19:40:41 +0200
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH 2/3] mm/page_owner: add option 'print_stack' for 'show_stacks'
Date: Wed, 24 Sep 2025 14:40:22 -0300
Message-ID: <20250924174023.261125-3-mfo@igalia.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250924174023.261125-1-mfo@igalia.com>
References: <20250924174023.261125-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1A22C1C000C
X-Stat-Signature: f48ct14ou5ifnse3c87j4qe8w5ord6ng
X-HE-Tag: 1758735645-205583
X-HE-Meta: U2FsdGVkX1+Xu85bBNIH5DGVaFRzNMRxZk8CFz7xxFnYwyHHtd74nkE376FZe5jdJJ1RdkLDYNwxTiM5CIf61l0iDN/JM1HxUseO+t5my7MkLsmzp+z7LLB71i5MAD/IXGuhSd9eHZwc/518He48/iBs2buaYDvb2n6ZgI6GPGOwFqZS16AeMD3t8ZYPHnjjv2jFOTrKHubnewxrh1d9Su1tVs/1EKXG8+Pof2AdhsKkI5qo4HRQf/giKA98MpcxAf44sZzwx1wBed6tKodW3OnRvFMBeLftnLvER+wMyUOyMxm/KhIHdE2v+tkgWQeW3eu47WpKNsTmKn/OXQe8yk6nnp+EdCZRF+LRT54HfTlFhVK/SlD8XeF9e/JnbXl3Uc5nZaYNfJBVvfEhU68g6wgR14AdQqDfZ2zwbebOXIPHM5P8CukCOe/5ONuuPVgEMMbaNBO+CD7Z9IOBtWiQ9nYLZi+vE7wKlemJdl0wzRFCTjClwvSGH5V4UkikxDg0h8BK/yFFPmdXxMw+JsAVArHqMwVspepZjV0JhFADMyDOljJtcyhM4ZHx9jpGQd52qXkPkQ/vLNP07SEfeLvwhNbEQxOpbqMQPXFVH7SzAzuMZ5oeh7gnUj/mstMCl6h3jFTsjMpLZhDM4NhH3KNo7isZK3OL1DYc26cUHQUsBZ3YsRckYfygyspIBOXX2kjAYFQMxI8i2ThSNgA7cCaSCdU3nG0wzPhd4Al+Ys8t1MSoTfr4ctBok3NsO1D1NPSFzMCu5H6bz1NK27SrGupL6RKkUPUvbX0VH0ilILE1maYNWRLIkAKLmI1C3A4eSDQVx778h4zWKErtc3znP61/T+aWgAkHGWGMWQe2Ed0OB30CfDAzlKLp/7/WZR5h9nb1KBnzTg7Mhrez1tx9b1E9DdyZ0N71aSusPeg1gS1eKxaUXHNfB7U96WOXt3yJffRQRe5klco2/JeqafehYbr
 AmMosd7t
 068hr3+eaD59m8TQIXJVm+bgDd8O4CwLC/aeCxHR/DOxJl/YMlXGGFOXgdK1vUJgzNnM7+YB/Bbojnxkf58borBCAvG2uLlj9CTTQnVcXGhjDYk0Hx1/b7toJAkXDSF/H9lwr/YGngWYs/XyK+FRniajKxPQ15qgLFZBMBbQc++V89V276dM/rTDfsscsQijd7TWHzHI3Y77rN/4iam3HLJRZuQyur2TjglNdVvSTTYPNH3O0Y0dP4jy0GJnhoedG5hJS+31A8AFgQkGyFf8bvKbNo9CN8DbYobslsqqC8ZzD0VnKlAak+2jyWuWoKk+WXgCJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For monitoring the memory usage per stack trace, it is more efficient to
read _just_ the handle number of the stack traces _without_ stack traces
themselves, and their number of base pages.

The stack traces are required only at the time to associate memory usage
of a handle number with its stack trace (eg, see top-consuming handles).
Before that, it is sufficient to have just the handle number, as it can
be matched with a stack trace later (possible with the previous patch).

This patch adds the option 'print_stack' option (enabled by default) to
print stack traces in 'show_stacks'.

Testing:

  - Enable handle numbers:
  # echo 1 >/sys/kernel/debug/page_owner_stacks/print_handle

  - With stacks (default):
  # cat /sys/kernel/debug/page_owner_stacks/show_stacks > f1

  - Without stacks (new option):
  # echo 0 >/sys/kernel/debug/page_owner_stacks/print_stack
  # cat /sys/kernel/debug/page_owner_stacks/show_stacks > f2

  - Differences:

  # cat f1
   get_page_from_freelist+0x14ab/0x16a0
   ...
   do_syscall_64+0xa4/0x290
  handle: 15728651
  nr_base_pages: 2

   get_page_from_freelist+0x14ab/0x16a0
   ...
   do_sys_openat2+0x8a/0xe0
  handle: 8388619
  nr_base_pages: 16

  ...

  # cat f2
  handle: 15728651
  nr_base_pages: 2

  handle: 8388619
  nr_base_pages: 16

  ...

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 mm/page_owner.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 420426749239..25221676676d 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -888,6 +888,7 @@ static void *stack_next(struct seq_file *m, void *v, loff_t *ppos)
 
 static unsigned long page_owner_pages_threshold;
 static bool page_owner_print_handle;
+static bool page_owner_print_stack = true;
 
 static int stack_print(struct seq_file *m, void *v)
 {
@@ -900,15 +901,17 @@ static int stack_print(struct seq_file *m, void *v)
 	if (!stack->stack_record)
 		return 0;
 
-	nr_entries = stack_record->size;
-	entries = stack_record->entries;
 	nr_base_pages = refcount_read(&stack_record->count) - 1;
 
 	if (nr_base_pages < 1 || nr_base_pages < page_owner_pages_threshold)
 		return 0;
 
-	for (i = 0; i < nr_entries; i++)
-		seq_printf(m, " %pS\n", (void *)entries[i]);
+	if (page_owner_print_stack) {
+		nr_entries = stack_record->size;
+		entries = stack_record->entries;
+		for (i = 0; i < nr_entries; i++)
+			seq_printf(m, " %pS\n", (void *)entries[i]);
+	}
 	if (page_owner_print_handle)
 		seq_printf(m, "handle: %d\n", stack_record->handle.handle);
 	seq_printf(m, "nr_base_pages: %d\n\n", nr_base_pages);
@@ -973,6 +976,8 @@ static int __init pageowner_init(void)
 			    &proc_page_owner_threshold);
 	debugfs_create_bool("print_handle", 0600, dir,
 			    &page_owner_print_handle);
+	debugfs_create_bool("print_stack", 0600, dir,
+			    &page_owner_print_stack);
 
 	return 0;
 }
-- 
2.48.1


