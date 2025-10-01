Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1842ECAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 17:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7719D8E0012; Wed,  1 Oct 2025 13:56:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721E08E0002; Wed,  1 Oct 2025 13:56:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610ED8E0012; Wed,  1 Oct 2025 13:56:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4D70A8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:56:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDC8813985D
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:56:48 +0000 (UTC)
X-FDA: 83950300896.12.1D6C57D
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7B007A0016
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 17:56:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=jo4lfrDb;
	spf=pass (imf25.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759341407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pFGrw9AJtqB09g7OZrEbnRk6JGZDUVaKcZE3piDe3Pg=;
	b=Wmz31JQBuH0G/jclJx8vlYFJep5k/kLT5+/ilH1D5WuR6whpHFsOD37l2dZiw3dSQJ8F7z
	k+QEm7T0kfymbCNobE7CjKShwJzSohzWoqPwdKtcN1XC6kD6wdTbf2Kl2FiFOV7DqtBYPz
	HLllHhwcAQFIU0Fs7mRLIAsbxtxftLw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=jo4lfrDb;
	spf=pass (imf25.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759341407; a=rsa-sha256;
	cv=none;
	b=PFwLF7gZoLmEaNr2uEKPyCtvgUUKqcy/RP53yeON06bil0EgCND676fGSKFPjFCaLxhvvk
	qcQOxbi7DKGA+WsyTQRvHhSmODpTwhRjVerM9QVRZS0xYfSpKFaxZXP33ChCimdVpivtIz
	+Vjc3Jz/kvewsNBPxOU87uXO8QQBgSo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pFGrw9AJtqB09g7OZrEbnRk6JGZDUVaKcZE3piDe3Pg=; b=jo4lfrDb7Ln2/ekILrcZTwpfHy
	ovbXmao2JZNNpAUTrE4TW71cJIenl9mkQPyMufLmibgYOnkD4vbFyB9vgDiawMZpvJa2PzWjrmCV2
	y2luluqHqYGX+pBCFLuB1omuC7KUjIdsD/L5LY8+WFYrZaah5JqcODcnIUoals4FvmMXVzb7YKY8R
	GB6QZAPxELiecJKph7kxb5KiONOEhiqRjcn+WQ7hNmCe7sV5vKtyfzKISls4Zz5pdKtsMdPG7Mk9K
	0XCVIVJpZOdPL4PAVwW59CLEiCpWltbNqy8CA4Rl2jxgxYnxN+tI9xXXYeF7YgpM3j1s1y6kre/np
	vBbhq2Aw==;
Received: from [179.159.118.139] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1v414E-002xd4-DL; Wed, 01 Oct 2025 19:56:43 +0200
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH v2 5/5] mm/page_owner: update Documentation with 'show_handles' and 'show_stacks_handles'
Date: Wed,  1 Oct 2025 14:56:11 -0300
Message-ID: <20251001175611.575861-6-mfo@igalia.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251001175611.575861-1-mfo@igalia.com>
References: <20251001175611.575861-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7B007A0016
X-Stat-Signature: c85uwatayyk8mbjfqe8gwd1i8mc5wpux
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759341407-891639
X-HE-Meta: U2FsdGVkX18Dcyf1wbLYHBpn8NODyrredQMETChAlpfaDN5y1uQMSYDuhsBFUr2wzHBDs2sG2UTxEm7b7n/Fg2yAfCXJ9DUIAwdWde80rUyAgdIR7/9w/neZFfKN8LB1IAiqleWvMqlvpq8DCJYYtj9gyq+nww1U0Y8Yuy1wPun/c7PUQF0N/Ma3JU9bEJbAIYQ9eoLsfgq/lEujrXdWwf+4mCAjmeIVcE1hZf8lhAy/st7QqO2jPkK4qCmOkEDQ9enK7hHMVWi/cjn2zknGKgIU2GOqEWXg9o5axhf4wvcJj7svySwVrPG9z6uPURGinblmYjszu7qyhLTsSddWagZlBIKjJ5bEskJuZ7cSyXyG4jseket7tvmBJPVv4JvyXdBkCJcwZVpu4LYlGQn0GQyEXMCRGA5R7KC0ceQhxYMA/oSImeqj8CmAXZQ2Weo9Vodw5YGQ73ZwG16nbTUNPAyjHyOJaUfToFwcTXcjCsA1b4HOf8cx38WnQ65nlNTp7wsUhcMQOxGqUQu8zm9ot4N6EjO8hPzBTOvlUgLwYx8MduZdOZrmud/iwBVda0GG0zOKUFwBllPekytYA5shGtZy6Z3Ks9WeKiFw6Q9cQw8gUjBwn+AzC3hCphkAnjJOIZRZ1qDMe7GOeACzQ/6s7tH/NSSjywmFKmFO1uYDLA1yYhYIZ976z3Y+/pJsz3tI2cJbLbQIwRC21eDKt/EdoN8/yT400QFpbn4SZmL8laOYPEuMg1BofBoJnOOlGN15TEqtxRtLjloJRT+BATTNkIX2eOdtX2RxNRfCrysznLPVq0VtTaYaD+M5E8CKyg7ZLKM+FsLcOIfLgv7/y5JYa/+ipkJmudX2RATHhjPKs4dLy7ngpAVcvYDCMzFw9I2EOdJonw3yvY4jxArGuBn9koVHOorh/MUyLsm/UQwoFtOHg2McstU/xfX01O3UsFV1hpH7PJkJkklQW2Cuar7
 CyYKXBbj
 A+2tXd7Nk/4l26lE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Describe and provide examples for 'show_handles' and 'show_stacks_handles'.

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 Documentation/mm/page_owner.rst | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/page_owner.rst b/Documentation/mm/page_owner.rst
index 3a45a20fc05a..6b12f3b007ec 100644
--- a/Documentation/mm/page_owner.rst
+++ b/Documentation/mm/page_owner.rst
@@ -27,7 +27,10 @@ enabled. Other usages are more than welcome.
 It can also be used to show all the stacks and their current number of
 allocated base pages, which gives us a quick overview of where the memory
 is going without the need to screen through all the pages and match the
-allocation and free operation.
+allocation and free operation. It's also possible to show only a numeric
+identifier of all the stacks (without stack traces) and their number of
+allocated base pages (faster to read and parse, eg, for monitoring) that
+can be matched with stacks later (show_handles and show_stacks_handles).
 
 page owner is disabled by default. So, if you'd like to use it, you need
 to add "page_owner=on" to your boot cmdline. If the kernel is built
@@ -116,6 +119,33 @@ Usage
 	nr_base_pages: 20824
 	...
 
+	cat /sys/kernel/debug/page_owner_stacks/show_handles > handles_7000.txt
+	cat handles_7000.txt
+	handle: 42
+	nr_base_pages: 20824
+	...
+
+	cat /sys/kernel/debug/page_owner_stacks/show_stacks_handles > stacks_handles.txt
+	cat stacks_handles.txt
+	 post_alloc_hook+0x177/0x1a0
+	 get_page_from_freelist+0xd01/0xd80
+	 __alloc_pages+0x39e/0x7e0
+	 alloc_pages_mpol+0x22e/0x490
+	 folio_alloc+0xd5/0x110
+	 filemap_alloc_folio+0x78/0x230
+	 page_cache_ra_order+0x287/0x6f0
+	 filemap_get_pages+0x517/0x1160
+	 filemap_read+0x304/0x9f0
+	 xfs_file_buffered_read+0xe6/0x1d0 [xfs]
+	 xfs_file_read_iter+0x1f0/0x380 [xfs]
+	 __kernel_read+0x3b9/0x730
+	 kernel_read_file+0x309/0x4d0
+	 __do_sys_finit_module+0x381/0x730
+	 do_syscall_64+0x8d/0x150
+	 entry_SYSCALL_64_after_hwframe+0x62/0x6a
+	handle: 42
+	...
+
 	cat /sys/kernel/debug/page_owner > page_owner_full.txt
 	./page_owner_sort page_owner_full.txt sorted_page_owner.txt
 
-- 
2.48.1


