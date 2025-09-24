Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 276AFCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 17:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9948E0010; Wed, 24 Sep 2025 13:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D708E0001; Wed, 24 Sep 2025 13:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AD298E0010; Wed, 24 Sep 2025 13:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 77D6F8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:40:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 35D121408FB
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:40:44 +0000 (UTC)
X-FDA: 83924858808.18.7363785
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id 96A21C000E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:40:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=YqWUDH+6;
	spf=pass (imf10.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758735642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1svfcZ9VH/76WFGoREwGAwZmvZ0N9/uv3HXzR8Dmmc=;
	b=cbdOkp5XlPcpzWqIg+Wu2G9cuWNyCHlOWp76izpmuQJSJyHQHS0bs3yRDqQMtsTdXSXbI5
	TP3a+8HzqVNV0/FcJfOOfvjiNeNABf7soapHCG30UNamMtqX5wAv7c974FY/6tgl6alVBO
	0Xgqq/o3Gj7Mk4oYRl8l5G/nLxDIDu0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=YqWUDH+6;
	spf=pass (imf10.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758735642; a=rsa-sha256;
	cv=none;
	b=Llq60rCAXw2RU7VvJg8SrM+ps4wmYvpZ17ooJJD6YluQdsiJdNepbzuRLHACthitwVuubW
	aw5XXMSiZsyziJqMz5zOBKkOvHb3XSzkjUbut7FLHFIVdTa8j6KLumCmYQGtoClp1nm0am
	MsVxj4lw4Fs8ziyeFmjLbvffMzStR7I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=O1svfcZ9VH/76WFGoREwGAwZmvZ0N9/uv3HXzR8Dmmc=; b=YqWUDH+6ic5bSW/v28hNGILXwK
	LNSxd6pkvlKvAdF/hjq5qrL1xcQNrNB8YCgzf80190ncVKsnbGG2TIMwdkP+7fTmy0bwj4CSbbdk0
	+IXi3fa+fIZmDn+lpSVBNSkZ5XEuzlC78L7SJ1vmifc5L3DkLUrGzV4vV1qbzGKAa/UnASUT6CBW8
	OO8K+P8apJ2bbheogtSqWsuZ8ILgrP6jdVppsqUt6H4GRKwNJc1Qu246vCxOW7iPpHKNoIhc/z93W
	UZvueLH4wm+tcup/YfxhcgSW+hyF5kdIRw4Jz2vTbIZ+AmJpFLns2mmuQ9yTJ0G8jRhfMIRyqWgrr
	MqZSqU3Q==;
Received: from [179.159.118.139] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1v1TTn-00Gz9Z-CY; Wed, 24 Sep 2025 19:40:36 +0200
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
Subject: [PATCH 1/3] mm/page_owner: add option 'print_handle' for 'show_stacks'
Date: Wed, 24 Sep 2025 14:40:21 -0300
Message-ID: <20250924174023.261125-2-mfo@igalia.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250924174023.261125-1-mfo@igalia.com>
References: <20250924174023.261125-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i8qnzafqocuuq1q8poyffdknpxkub5ke
X-Rspam-User: 
X-Rspamd-Queue-Id: 96A21C000E
X-Rspamd-Server: rspam04
X-HE-Tag: 1758735642-83960
X-HE-Meta: U2FsdGVkX1+XyLBF1ba5IpOS1CXh8VvjdlSv0H7L1FkZcL/5tJDzVCqVW5ydedO6MSM+GCEsCiNcpY0MflrX/n11vkfQ+Esi8nmGn57UVh3BgedA+u7kqkXzhGpf70dZQI29nBueAdUZuFpANpOdLXqv9HXRirWrv2WK3PDaqzcZxkhY78HWmqZzajjExLLFgukd6G2c0BW+LjZe+z8W0+uITnBE6OsRti5HgxnDEOJODv5I1MYH0NrFGE/ry5JPi7MXtARPl+Tx9764ucseRls55rbHsDREr7cALF4cfGFKiia4dsCWIlwlrc629K9CXvePDWY5AJJivF7XJtmey12Ll7k4//smt+oNyxHv1P+PQ1Kge29x6ZpBBdxQzob2hIYjGPCVe7lDEBtKyeRg0HmxgZYr9IjzJh76vtaedNpssjk8H5tUVbukk27FcQ4qisRnkZVJaGrpzs2WuZ+do0d7aEGZiv7oTFq9VWxLCKhMhVLQ9t7c7KyD2x6/v2es4P4Fbth84IUgLItbpDdHfrod1zGverMlLaVpG4PJarC/tq6BKYkstUegm+iKOS5PpcqfVRXyqm+0F4iuCwlC7ZuhIbJhFr75QHXZbW9EXNw7zvOIDQplUsmiI76EmxbfEGbLMxkfgoPg6GDSe59cDb/89NiGlt8eQsM5EgsoZDnj6WURjG+ARLc/ZOc7UiA+7EvkPC7YWSlvkaGk1w0+MUaWtR+5KNo5TJ3nMAeZ+5qV21AFKScQBimcYM2atZwGHIxPRPR08B+6mYmiQU+MRJnyvRdbM5e4pJPaAQ6DBWsDpoXZUaZj+e9r+TLhFBGr2j0cfXtj9qnR0fXv8+JnQfyUv6HGRKIP/5pbzfJgN62wcXOLLEDDcF/vNkBWEgQzzZ1+JOPw3GqgDfFk7Ww7qrU5zWV32sOxzvWCiH6TLfhy+yeq1bl9/AXZtvCtz9lYQIgeqk7R3Rb1HqJS8+O
 L+I6Dcln
 5XurbWSFS1YXYetH1WUoIpP+sqQ+39qwux/rFr3sUokODhsMrvDjF05ihGoOgHZBzYo7nGXhfOf7oMKKKxORnDoKtXrRXKMUbc/DqeEio6vbhYlRVpdk9hDIB7IvDAM62UgFUzyTK9c48m1D0NYnZPVikhU4rIUaSsjKEPotSl/r+GQOaVzEzR+tWdhLVXmqf4HiEhzJHUsvO2RNFMOSs8b/GTn/4TKRwNUI7CUVVXibWyvWZ00g5wMfrOk6MVgrS8t5kt33m7hLxTv/fAgA9544MuwrZzsOaovUSjuOXFjN5X60RJHFrta9nCsbl09pcuKO/1pUlwvgTcgyJ6L34uCzLHlXQe1jivhO7Y0ZDR0ahsNc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For monitoring the memory usage per stack trace, it is more efficient to
use the handle number as unique identifier of a stack trace than to, for
example, read/hash all stack traces to uniquely identify them everytime.

The handle number is a unique identifier for stack traces in stackdepot.

This patch adds the option 'print_handle' to print the handle number of
stack traces in 'show_stacks'.

Testing:

  - Without handles (default):
  # cat /sys/kernel/debug/page_owner_stacks/show_stacks > f1

  - With handles (new option):
  # echo 1 >/sys/kernel/debug/page_owner_stacks/print_handle
  # cat /sys/kernel/debug/page_owner_stacks/show_stacks > f2

  - Same number of lines for 'nr_base_pages' and 'handle':
  # grep -c '^nr_base_pages:' f1
  873
  # grep -c '^handle:' f2
  873

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 mm/page_owner.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index c3ca21132c2c..420426749239 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -887,6 +887,7 @@ static void *stack_next(struct seq_file *m, void *v, loff_t *ppos)
 }
 
 static unsigned long page_owner_pages_threshold;
+static bool page_owner_print_handle;
 
 static int stack_print(struct seq_file *m, void *v)
 {
@@ -908,6 +909,8 @@ static int stack_print(struct seq_file *m, void *v)
 
 	for (i = 0; i < nr_entries; i++)
 		seq_printf(m, " %pS\n", (void *)entries[i]);
+	if (page_owner_print_handle)
+		seq_printf(m, "handle: %d\n", stack_record->handle.handle);
 	seq_printf(m, "nr_base_pages: %d\n\n", nr_base_pages);
 
 	return 0;
@@ -968,6 +971,8 @@ static int __init pageowner_init(void)
 			    &page_owner_stack_operations);
 	debugfs_create_file("count_threshold", 0600, dir, NULL,
 			    &proc_page_owner_threshold);
+	debugfs_create_bool("print_handle", 0600, dir,
+			    &page_owner_print_handle);
 
 	return 0;
 }
-- 
2.48.1


