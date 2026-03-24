Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F06EE9A75A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384B76B00A7; Tue, 24 Mar 2026 06:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3366C6B0088; Tue, 24 Mar 2026 06:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C8A6B00A9; Tue, 24 Mar 2026 06:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11BCB6B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:00:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5C7EBF402
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:00:36 +0000 (UTC)
X-FDA: 84580512072.18.438EE70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0D7398001D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:00:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jSMiLBo1;
	spf=pass (imf30.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774346434;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y2wxZaeOArFNepfalmYe5W33Ju5J4nZ+HJMiHJ1bOY4=;
	b=iScYA2WARzR5zoiAxzgBHOX620CSeHTLJ8rgM6w/T1Y8ovcguPiIPGB+IkqSaFnV16hvEY
	HV4Ox476W4l2PmsJ/RKV9+2KNK1SruoexSFLadPO/510+CDTUWkeeHtlfYzcHtx48PmwN1
	RkqLvYLypaaz4S5/Vota+bAy6zrpgNw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jSMiLBo1;
	spf=pass (imf30.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774346434; a=rsa-sha256;
	cv=none;
	b=7gPxVFcu2RW1e3zBb9vdrpoQNKmfwf6HJrzxwudbi3a805Mkoy/hcJ4WkatbrguYoihYWW
	J/pVcD+DW0Vt+uMZlEGjJcXtv/wDZaWvplB7kchCcA0VwjYw4Jd19gZ/D+sIsPddNDqFlM
	nxr1amfb9pEPIHWjnAVZemuRu8QaTbA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EF63744545;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D13F2C2BCB6;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774346432;
	bh=lvRKpv9TIZt0GjqdnA46kctN4zrgkYUFc8NhDjAPR0g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jSMiLBo131wqj1FXMCmPuiWlsDWs4E4y7DNDf1rzL/7IA/iUzmmDFk9BF3vEPMgfe
	 Hwz7Z990wQJu3N80LBtu449qV56Y/IYOSadjUrg/eNqU7l42Ot+Y3kcppQgMN2sIPU
	 f7+g8QXnb05OucTwny1xyPRiFfyD9o2vtpOOb+rtnPPuLh5XwXeuN40XLqq/2sjeiC
	 7d3tyFqnjAAF2G/5XkFt9Cdg/4G5Irig8JLzS77yRRaYkw7XcYwmwMo/AVQJKCro1v
	 PKh8rwN4Z19RXUqBvaONrUdAvW2nAR40jsHNkXBtALj1loN5UJd5mz4VaoqHUlelEv
	 2QOp08E2KRm2A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA809E9A75A;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 24 Mar 2026 15:30:29 +0530
Subject: [PATCH v7 4/6] mm/vmalloc: use READ_ONCE() for vmalloc nr_pages
 status readers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260324-vmalloc-shrink-v7-4-c0e62b8e5d83@zohomail.in>
References: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in>
In-Reply-To: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774346430; l=2959;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=q4Ito1vUmJmb3A3de47pGFK3WSX+j54Hs6oFM89TDPE=;
 b=3qyErl+BdMfksbupmMLQP9N6WcJ4/N+QyYsiJ6o6Do43NdkisYyO+pqnixaf4/KMJIZr53QVS
 n2yE/CxvHXWBew0wRQcmzqpR4d5njVMgs0tkA8bYJzMKeukfqW/6VBs
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Stat-Signature: fq9erk5sdjjfnee1ncayp3dew7hxxntj
X-Rspamd-Queue-Id: 0D7398001D
X-Rspamd-Server: rspam09
X-HE-Tag: 1774346433-347535
X-HE-Meta: U2FsdGVkX1+z/pgJtWZXvBNciKB6yO+Iyxzd7bA6I62sXS+ydLtMIl3OFyo30cdHYLZ0bsHnZw88HfCHwWDJ6GZ03pBR9SNChovhh7bmt9GKC7y5CduA8+hkgZDYDe0zCoZTrrh7Z0mu9hxEIkjp3kmLxGYtQhfJ5QcyglYYyrzk6qbZbuUvLrezzxJ7leV4IqHAw3t67Svvj52zDf1aDMnqz8aRkaBQlpGJB9eXjqAQoLdpG+yZgjxiOQfevuQ03jZnPYeFr0zJT/h6iF+Qte5cRJ7RfhaDiRa08OcSLowoyCFIGXkbPimjmxY7wiVxRhZhTh35+7rWGK2WGzvOOGeiuez8mH21ls7Tn2N9bJq9ez37lzHywlSdByJp1JPG0FxJYvjNHxF3QF2l4uGAbO5kViEWAh3drwLv+zPwiJkcdtQ6uXtmxVKNzZrh+FQgPnJNuZOuH+G8j6xco8tP8gYSWt5ssHImN53gKXRG3usHX76+qIXhiwVAg+3LGD/LvauYLpl/Z4xZ3me+PDKqGliIO7EZX42LcdCmymqLc+biJnaFw9P1eGPmZSpJT0I/+tMxxrRF034w9ZHM6rDHltyJ7VjUT1nxfTvOHAVmGSD0QOCw413NpR8Q9juQgj4/iOSu7prSCBT7b9GQyhZfKyQlVx2ADbSGT/W4NEnb91XE+sqCEBp8iXfDeaCaW9018W9RWQHrWaozBfUHM99hQAeH7YflXF8CdqM5hzOMjU2+UGjNmu44Bi92xFmcXPr7bHhotM4NUum2If9DBaGgytLIAXhtg0GyK6KgMdHY/po/c1ULY5e1F/v9fRzQM+7GYod6VPmlV/GNSQoDL6P+jGy0syvFqwrEsu2eO60jfeQEgrSaXIJQ8C63I6CjBMTzbZNTD54EzvOovI6ITYD0bFlCXnEivW0TOle/YTsjXum9vaHiuAvVt3uTMmM0d6vxsmTezEz32EJfCXePxaC
 UIERqLRV
 WgQEY9WH7d1uyTrqmeHrp0YbWHejfkOuM9cW2DWF3pV4EvuBlklKwnZfgkZrDQ6p6+e1/o1hVrXycToVujTfpHvmjvzcrSDoJvO94C42ZtzpFkDO1A2RPavFj8Ac65Uh27rdZOBSuxh9Xa8fv0U8e74XVm4fWlCb5G/MUpKFSrINAl3jB4Jz/F0lXDP5Mzm4TZbC0SDbxy8w7xB3R/zP8zo3vMgGQN0m7VxwL1HUtVZxo8vhNiXex5CjYdL5EvPTA/epg3+7AKNQVuvy42OODNakku6Yw7zxXP6/X3qE/XJsY9LVmj2GcG0YAoM0h8QHVvi0xpZsAoMlh/oHa4G5+JQVDmOcXpzuNXrrT+MLu45pf7VlCa2Eo1wTxYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

The vmalloc status readers (vmalloc_info_show(), show_numa_info(), and
vmalloc_dump_obj()) currently read v->nr_pages and the v->pages array
without any concurrent protection.

In preparation for vrealloc() shrink support, where v->nr_pages can
be decreased and entries in the v->pages array can be nulled out
concurrently, these readers must be protected to prevent use-after-free
or NULL pointer dereferences.

Update these functions to use READ_ONCE() when accessing v->nr_pages
and v->pages[nr]. This ensures the compiler does not re-fetch these
values and provides a consistent view of the vmap area's state.
Additionally, in show_numa_info(), explicitly check for a NULL page
pointer before dereferencing it to avoid potential crashes if a page
was concurrently removed during a shrink operation.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ddb689bf9ba5..c6bdddee6266 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5189,7 +5189,7 @@ bool vmalloc_dump_obj(void *object)
 	vm = va->vm;
 	addr = (unsigned long) vm->addr;
 	caller = vm->caller;
-	nr_pages = vm->nr_pages;
+	nr_pages = READ_ONCE(vm->nr_pages);
 	spin_unlock(&vn->busy.lock);
 
 	pr_cont(" %u-page vmalloc region starting at %#lx allocated at %pS\n",
@@ -5210,7 +5210,7 @@ bool vmalloc_dump_obj(void *object)
 static void show_numa_info(struct seq_file *m, struct vm_struct *v,
 				 unsigned int *counters)
 {
-	unsigned int nr;
+	unsigned int nr, nr_pages;
 	unsigned int step = 1U << vm_area_page_order(v);
 
 	if (!counters)
@@ -5218,8 +5218,13 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v,
 
 	memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
-	for (nr = 0; nr < v->nr_pages; nr += step)
-		counters[page_to_nid(v->pages[nr])] += step;
+	nr_pages = READ_ONCE(v->nr_pages);
+	for (nr = 0; nr < nr_pages; nr += step) {
+		struct page *page = READ_ONCE(v->pages[nr]);
+
+		if (page)
+			counters[page_to_nid(page)] += step;
+	}
 	for_each_node_state(nr, N_HIGH_MEMORY)
 		if (counters[nr])
 			seq_printf(m, " N%u=%u", nr, counters[nr]);
@@ -5247,6 +5252,7 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
 	struct vmap_area *va;
 	struct vm_struct *v;
 	unsigned int *counters;
+	unsigned int nr_pages;
 
 	if (IS_ENABLED(CONFIG_NUMA))
 		counters = kmalloc_array(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
@@ -5276,8 +5282,9 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
 			if (v->caller)
 				seq_printf(m, " %pS", v->caller);
 
-			if (v->nr_pages)
-				seq_printf(m, " pages=%d", v->nr_pages);
+			nr_pages = READ_ONCE(v->nr_pages);
+			if (nr_pages)
+				seq_printf(m, " pages=%d", nr_pages);
 
 			if (v->phys_addr)
 				seq_printf(m, " phys=%pa", &v->phys_addr);

-- 
2.43.0



