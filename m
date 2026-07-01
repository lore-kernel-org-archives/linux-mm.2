Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1A84C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 03:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 369E16B00A6; Tue, 30 Jun 2026 23:41:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348D76B00A8; Tue, 30 Jun 2026 23:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25A726B00A9; Tue, 30 Jun 2026 23:41:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 021DE6B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:41:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 714651A011A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:41:35 +0000 (UTC)
X-FDA: 84938808150.03.70E4FE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4B64B12000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:41:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lkNYXl3w;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782877293;
	b=QFtn1iMYL5sVQKlMID5E6A6LNVSu10eC4i8S2HL+Rhou3gxJ0hX3Mw0dlJOoDGMR1vERHl
	v6yFzQzb131ve4xskHCu3AB87/HpmreJCm6AeZjCkjubENM7nIYVoFF0yYGhcCT5eTPjtT
	6PiHwQUV6QZ5Yhkr7Qgh9nJCyWL19+s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782877293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CqtgTA57MDI/0YnUoY+V1bgidOgTGiuy3XUEF9UDwm4=;
	b=mT1bHqUAOBOBKhRbxBfPoPjmG26EX5PKdN3tnQ2ZgjNFmBFxB8alcyjPB6luFfy9y/4Qtw
	ztGb0hIXA8qaYVyC+y2USwdWwak3A8G99l9ieSQWW07m9P7fillkZ9IL2mkG7Q5hzecZw/
	nMyFg/dJiGyqRrhgPUSIOd0Wdlvjn88=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lkNYXl3w;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E691842CB9;
	Wed,  1 Jul 2026 03:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8131E1F000E9;
	Wed,  1 Jul 2026 03:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782877291;
	bh=CqtgTA57MDI/0YnUoY+V1bgidOgTGiuy3XUEF9UDwm4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=lkNYXl3wN6FlZc1dSjCYlIyCIGDyCKAIwsLp3AlZ/1TI+Wtk+cn5+mvxo6WWrgEtg
	 OA/XFVrL+9g4xQVfcr396TfvUU9KmCoEfq4vbzrfRGRqQstJIs2MnZVFSdrBPXcOsP
	 cnTtMqnfsg7WIO8wgkdoEvNmKFP1shUr9QbwxsfA=
Date: Tue, 30 Jun 2026 20:41:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/7] mm/page_owner: misc cleanups
Message-Id: <20260630204130.175e9a2addae86058327918e@linux-foundation.org>
In-Reply-To: <20260701012239.315262-1-ye.liu@linux.dev>
References: <20260701012239.315262-1-ye.liu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: w3mcckk5jiysf6ga1i68849jgrtyffz8
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4B64B12000A
X-HE-Tag: 1782877293-76658
X-HE-Meta: U2FsdGVkX18TynG36DHALbaGXXpBCEdYYFI6d4rAI9DwE5QbUpX/VqC4/nqILw/azr5ILhk9YlHwSkq7c0veWhCea9oSCMnwhXfyGSmh8DlOWly4vh2C9wDpdy7WRsd7rJOQZ7txe5QyVtOjeJHJL6dnHahlBuka4AO0CLxt+LqQc2fPMD8aCpVZxH1Mj47r0B1BdUBMgBQlVx330srb2TkZzoJkHwECiMTMEFRY9IO9o51cNyRhinN7H+6X58KSmJgnYtIwIOtvmZTi3r59pEkvaueUp7YqsvuHZvVRXCxK2SUIDRc3hmwK4GJSWCyzOUXeTnE5TUwErCC2jeNyw1UtS5POI+GJK4nKaI/SBeD00ecrpW8InQ/K7K5HpsvPN+FekMihlMraCnIYIIIvgsljofYPA3f51x1dWA+Qqc/2+YXkc/YYk1OpU6x9B4wusg21fv3eFzhESRpiPaYDCCMhYBcahdJ+xCKiMHrcuwd4efu4Suz/dkoGWfqL+GeyThM+rzXiy0y6XfrTDNy2s0x+p0CdoKRpe75kyKSF7A5Haxx23aOLsvVYHlh69GJotO11qRAYeZJmDQmJKgda4AvT9OwldYGZvS85bJIDMgRuKR98QczukDJe2jX8Ib4EN2zDpceDsBWlUZkWIEA82NlKg6VftaXZ16d5XV0+8kfLXVk7GTxpC1m7ZXD2DWZjAXEcdiCUW2mtcK/ZQwi8JOILB4IBdnJFe3jtbgQlRPN1yeJGoBfVatiW5KEgDHZ1LsC/wKcMhbCB7qOxvBCK+bp7LEU6VnrRmDdYHjxjbuRnR3e++N4klMqIQk9BR7AAsvVTF/FzAp2VOt3C/NyBqW6BcfhMLAl8WY8tGP3S0sqTid7W07G3OnuqkoeP0OKPbzvzAF46NMxnExHgkfXKba/+bXwOMl4Py7zn8qQvm5rq8IAY42PtFcO7lmWEQeBgfSGQPvcWoNiMoXpbWDy
 4N8vHxjs
 XD5UZa+0M5pfaEwjA9kiXwfjrO4000XEYsFz67LYqtkXUWiVjIZeUIlUFmEeDW8xrpU/WdZE3G+ftDHJHSn0vQESAwuB/DhGocaOWVn4dTaXBnyiiZf8iuCtdf83P3psNqiWLbSxRXVFBlstXNjhHn0b/dOu+6A03wTcZGpo53pyzgpvabe85775RP7NKWf/YkjWhXmNRU5jDM2s8z6bKmFyBRIr0cfJW0MicV4HqDza7IgsyHIDGk67vT951SGek7h3Rthp9r8wpTtbNT1pH+Ss+PAB+AxXOd379ZgWerN7fhSrPUyQK3yoFdR9EJ9YebE353Jtqd3Tb3vBHxw9wvilUzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Jul 2026 09:22:26 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> v4:
>  - Patch 2: also update scripts/gdb/linux/page_owner.py to use MR_NEVER
>    instead of the hardcoded -1.
>  - https://lore.kernel.org/all/20260630015331.147174-1-ye.liu@linux.dev/

I'm seeing more changes than described here?


Thanks, I updated mm.git to this version.

Here's how v4 altered mm.git:


 mm/page_owner.c                 |   16 +++-------------
 scripts/gdb/linux/page_owner.py |    4 +++-
 2 files changed, 6 insertions(+), 14 deletions(-)

--- a/mm/page_owner.c~b
+++ a/mm/page_owner.c
@@ -428,12 +428,6 @@ void __folio_copy_owner(struct folio *ne
  * to skip less than the full buddy block, but that is acceptable for page owner
  * iteration purposes.
  *
- * The lockless read of buddy_order_unsafe() can also return a garbage order if
- * the page is concurrently allocated and PageBuddy is cleared between the check
- * and the read. Clamp the advance at the next MAX_ORDER_NR_PAGES boundary so
- * that a bogus order cannot carry @pfn into an unvalidated memory section,
- * which would break callers that rely on boundary-aligned pfn_valid() checks.
- *
  * Return: true if the page was skipped (caller should continue its loop),
  *         false if the page is not a buddy page and should be processed normally.
  */
@@ -445,12 +439,8 @@ static inline bool skip_buddy_pages(unsi
 		return false;
 
 	order = buddy_order_unsafe(page);
-	if (order <= MAX_PAGE_ORDER) {
-		unsigned long new_pfn = *pfn + (1UL << order);
-		unsigned long boundary = ALIGN(*pfn + 1, MAX_ORDER_NR_PAGES);
-
-		*pfn = min(new_pfn, boundary) - 1;
-	}
+	if (order <= MAX_PAGE_ORDER)
+		*pfn += (1UL << order) - 1;
 
 	return true;
 }
@@ -561,7 +551,7 @@ static inline int print_page_owner_memcg
 	cgroup_name(memcg->css.cgroup, name, sizeof(name));
 	ret += scnprintf(kbuf + ret, count - ret,
 			"Charged %sto %smemcg %s\n",
-			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
+			PageMemcgKmem(page) ? "(via objcg) " : "",
 			online ? "" : "offline ",
 			name);
 out_unlock:
--- a/scripts/gdb/linux/page_owner.py~b
+++ a/scripts/gdb/linux/page_owner.py
@@ -34,6 +34,7 @@ class DumpPageOwner(gdb.Command):
     max_pfn = None
     p_ops = None
     migrate_reason_names = None
+    mr_never = None
 
     def __init__(self):
         super(DumpPageOwner, self).__init__("lx-dump-page-owner", gdb.COMMAND_SUPPORT)
@@ -65,6 +66,7 @@ class DumpPageOwner(gdb.Command):
         self.max_pfn = int(gdb.parse_and_eval("max_pfn"))
         self.page_ext_size = int(gdb.parse_and_eval("page_ext_size"))
         self.migrate_reason_names = gdb.parse_and_eval('migrate_reason_names')
+        self.mr_never = int(gdb.parse_and_eval('MR_NEVER'))
 
     def page_ext_invalid(self, page_ext):
         if page_ext == gdb.Value(0):
@@ -138,7 +140,7 @@ class DumpPageOwner(gdb.Command):
         else:
             gdb.write('page last free stack trace:\n')
             stackdepot.stack_depot_print(page_owner["free_handle"])
-        if page_owner['last_migrate_reason'] != -1:
+        if page_owner['last_migrate_reason'] != self.mr_never:
             gdb.write('page has been migrated, last migrate reason: %s\n' % self.migrate_reason_names[page_owner['last_migrate_reason']])
 
     def read_page_owner(self):
_


