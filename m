Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DBC660A2601
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 18:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ODZK9b7w
Received: by kanga.kvack.org (Postfix)
	id 2894F6B00EF; Wed, 18 Nov 2026 13:22:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239C66B05B0; Wed, 18 Nov 2026 13:22:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128926B05B1; Wed, 18 Nov 2026 13:22:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D13316B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 13:22:45 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0D2C1C3C99
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:22:43 +0000 (UTC)
X-FDA: 85449060606.23.B84E763
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 297F9160004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 18:22:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ODZK9b7w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795026162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xvB8IhYRPSnbnj2uCIAQHzMiYpbNgO0dDpgbm6C1Dps=;
	b=LLr36kcfTjZ3FDt1dnl4Z379vTMttoB4lzLnCRr5fXEC5LQtylKQTYQKnvUWuJUMgBV/2y
	cR+/r/Cywt+QF6+YSiqzum1BIYkvv6W3Y3joPI45qSX/TZqVOWoPzWrw+ZmwKAO8KB+SO0
	120XPa7oRBPrinuGFdFVs/kqEVGkw1Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ODZK9b7w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795026162;
	b=b/X+ogShvG+FvIdlClVLNprqlTWF2hfvOI2jEuj/YsZW4nTv/24teMCMWWbepadGhTKIxy
	qqZOyiugGCtNHuJgGr+XrhGRmFOK0Yqk/xWE2d2qyAt0u8fDR2lqICIHz4HpalCRj/u5yJ
	4yB3QhMbFsWTJOzoEvz0FlwdTRfV4YE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 77A4C636D9;
	Wed, 18 Nov 2026 18:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6571F000C4;
	Wed, 18 Nov 2026 18:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795026161;
	bh=xvB8IhYRPSnbnj2uCIAQHzMiYpbNgO0dDpgbm6C1Dps=;
	h=From:Date:Subject:To:Cc;
	b=ODZK9b7wAy+7knSx5IdGq47OxYc/w6wlve6EX4WhEEofAft1dtcexWSkfUhq+/7G4
	 xmHel7e0ZkMNcepri9ctwPko4OE+uDGGjVIYfa2U+quHtXGNo2RzkoIjTHs8v4TrHZ
	 wbxiD2HbDSz+7T3SJOokPcpXsQ5lpMkV5wjMPxaOK6kAVKFZ7mU1jDM9ts/W+/YWYB
	 T7CIeqSyM8ze/TXw3XTE1O8tR8Iv1D8gFU6OoEWDX0vfFmPcvwFpFkk3gzrDPTHXaG
	 OodFbQOhiT1Pe6x+nj3Da+6fhoTZ+jz1NWCxQCN1iHGeWlTszHrrbantqG6LozlYGL
	 Zk6q0tBAEH31w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 18 Nov 2026 18:22:10 +0000
Subject: [PATCH] MAINTAINERS: consolidate the memory mapping entries into a
 VMA entry
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-maintainers-consolidate-vma-entry-v1-1-8019b0e9928f@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2NMQrDMAwAvxI0V2CnYJp8pXRQE7kRJHKRTGgJ+
 XtNhxtuuTvA2YQdxu4A411cijaJlw6mhfTFKHNz6EOfYow33Ei0Ntgcp6JeVpmpMu4bIWu1L+a
 c6JoCPUMaoHXexlk+/8f9cZ4/533uRHMAAAA=
X-Change-ID: 20261118-maintainers-consolidate-vma-entry-ff6a360ab069
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, ljs@kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5075; i=ljs@kernel.org;
 h=from:subject:message-id; bh=avC9Gd6INiMLB87wWgBdV52PLjJojmtRdMkvf72D52E=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLL+vnmgWPR1cTCT+oFt7iIvN3LJGa0y+FnwPdTQ7MAll
 YJd+WpNHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIhyPDP8O/pyP+sR7RfHg4
 x5l7ncSVSU5yLSnfazdPuMCqeFxszQ9GhkuPDsx8nJ1QHFfockovemI1U/pe3ZCHvledC3ZKrpg
 4hxEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: qtg6mxqmmq9hk6cup7fow6s878i9ecip
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 297F9160004
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795026162-822373
X-HE-Meta: U2FsdGVkX1/LS+qX/VTMd9R4/4EgwSLTc5CYpmH0gRWMzx4fj0WqLEmwbew2Kb0CoRHn9X5y9tfiif5A6ow1lTL/COLwBm0GIzkUxgMrRh9zPc4S23WD+FNHhDRiycx2DE27ySjZHyVfsnhTeBeouhKN1kLkWRXj8ENvVwXR6AkPqXxbj1d4MWbhhQoyFqEkChEG9DOhTgqztJ6J6dfzzwIhBSLiyVUZZuCWisaRX0zw1Aachw5f1R1VRu1dl/6NiYVwQBVhRdHz5/nVj05QD4NBWUWJSUL9dFBUY6p4Ph2UDSmmDQCjVa/VNp/sRmEAb4ipZgaP/jGlUZ7BYuHRCiiXDZDUnWPIXasblgV7+uWhrrdcdSz5LpzyE8kDOphCdufp4S4lSccdQoJj2BkID03BrrVPTKPQQQ4Ry2782drT8rsv9o0WKZGpIJrfgREwmYMYNwjaygHw1sDIoeWDLReInI5z8Q6W5zoczrGea6BIUVGNCp7H0R0eo2sx0XUnCyjD7YWnFAh6M1uuU7HvDe2KtQVDCKTYHUfCX8x/VJtOw44U8aq2Di8AU6oNZeiIm1/Z1rnEQnNIELf3zSDyaYi9QEBEraEeSc6DIHLXGysqaEg0HP5tnbS250homG0F0ZD0PijLtwQsZuU9nF/Dx7hu0ZYcBKtNTfTDhdLtQhpE4adL1A6s4JmC7vS5MrrPQYwI7CZ6jsZinY9NZU2USjMg6DF5q8iv15l5ugNdFHkJ5jEgxkWYPmQC1KOem25UKZvJ5pz0zKE0HYzpnwzxNOXgfCJzQ5QMtE9q86eXbcs9J0OexE9RpiX7vaFh0oVERotLcmy5/a863SKe5IDEEBjD0UEVF/xtUqVB0KVVJbFW9YqwY3isIuCgq7Pfv3rOEyl49R0z65Bvr3N892273xNGkH7GOK7cq1acDiebiXY1U2GTusmtk9fbP6681EyWHYUUfvMQA5nwte/iXy6
 pRp5gY26
 jO90Nwl7NyQQjzF5iUpsjhbLoluALDzg9/FUOg5UTS3bzZVpjp+ZsVHqb5J8wIk+NfpK0WSAro91gkNSA7vElk7rZBSL/fZEDf57Jl5yv4G83U368diaGHEcBAm4Koo9sEa3vLNdEeXEm6TTgixFQs+1QUDbH7DqflE1Uw5xuHkN8SDFDPrNDoY1Snm4Vjnz/mZYPYfIPqYUXVfdaFaqWrsorQdkz/+M+Tr0UMbc4VC5pKTZ4oDYxofQ0qwn+I1bWhSZIZgR6UwKll09WOEd5wLul7aWn54I7zmT0pAvQl/FbMF4W+5QeKRMzmouPjXaLtpzdkoWAsjycop404dGigfwZt0In6CHe/dFFFsK6a84Mjsl0SzQiajrnz1iUKZhLf82oN/GW0tGVKTjffIA85FzbAqw3bQ3RtnG4gz+7RpnBGszEnrKXGhMV7GMDZJVo5mFv3rqk7h9wbBi9znbIMFQrCzFPZcSiLOkKk96IpfvpZQZw2mK8oL/D6VP1d1hdMugLK4G4eWN42SGZvngNlZ88OoqyzFaRqqUBEhEW9dDCF8bsp4dwzJjTrDviQnRJBCqoomMwn2kz9WcDzO4jo/gziwaKmVjFLXm2MLSrgJYD73b2yIF/ehpmVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Memory mapping entries were kept in three different sections in order that
those maintaining/reviewing each distinct part would be made responsible
for/cc'd on only those parts.

However this creates confusion as to what files belong to which component,
so simplify things by consolidating them into one.

Expand Suren's maintainership to the entire component, as he is a trusted
and valued member of the VMA kernel team and very much deserving of the
position.

Additionally, drop Suren's core and misc reviewerships in order to focus
upon VMA.

As David is receiving pull requests directly, make him a reviewer, purely
as an administrative change.

Also specify the new tree location in preparation for the tree being
established for next cycle, and remove the link to the not so regularly
updated linux-mm website.

Given that, from next cycle, the tree will sit outside of Andrew's current
process, remove his entry, also purely as an administrative change.

With that said, I'd like to take the opportunity to express gratitude for
Andrew's huge contribution to mm, and for his being both generous and
gracious throughout this period of change in the subsystem.

Co-developed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 MAINTAINERS | 51 +++++++++++++--------------------------------------
 1 file changed, 13 insertions(+), 38 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 222b7fc2c3aa..59496dd1d11e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17509,7 +17509,6 @@ R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
-R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -17680,7 +17679,6 @@ R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
-R:	Suren Baghdasaryan <surenb@google.com>
 R:	Michal Hocko <mhocko@suse.com>
 L:	linux-mm@kvack.org
 S:	Maintained
@@ -17974,30 +17972,37 @@ F:	rust/kernel/mm.rs
 F:	rust/kernel/mm/
 F:	rust/kernel/page.rs
 
-MEMORY MAPPING
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Liam R. Howlett <liam@infradead.org>
+MEMORY MANAGEMENT - VMA
 M:	Lorenzo Stoakes <ljs@kernel.org>
+M:	Liam R. Howlett <liam@infradead.org>
+M:	Suren Baghdasaryan <surenb@google.com>
 R:	Vlastimil Babka <vbabka@kernel.org>
-R:	Jann Horn <jannh@google.com>
+R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Pedro Falcato <pfalcato@suse.de>
+R:	David Hildenbrand <david@kernel.org>
+R:	Jann Horn <jannh@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/vma.git for-next
 F:	Documentation/core-api/protection-keys.rst
 F:	Documentation/filesystems/mmap_prepare.rst
+F:	Documentation/mm/process_addrs.rst
 F:	Documentation/userspace-api/mseal.rst
 F:	fs/proc/task_mmu.c
 F:	fs/proc/task_nommu.c
 F:	include/linux/mman.h
+F:	include/linux/mmap_lock.h
 F:	include/linux/pkeys.h
 F:	include/trace/events/mmap.h
+F:	include/trace/events/mmap_lock.h
+F:	include/uapi/asm-generic/mman-common.h
 F:	include/uapi/linux/mman.h
 F:	mm/char-mem.c
+F:	mm/madvise.c
 F:	mm/mincore.c
 F:	mm/mlock.c
 F:	mm/mmap.c
+F:	mm/mmap_lock.c
 F:	mm/mprotect.c
 F:	mm/mremap.c
 F:	mm/mseal.c
@@ -18011,36 +18016,6 @@ F:	mm/vma_internal.h
 F:	tools/testing/selftests/mm/merge.c
 F:	tools/testing/vma/
 
-MEMORY MAPPING - LOCKING
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Suren Baghdasaryan <surenb@google.com>
-M:	Liam R. Howlett <liam@infradead.org>
-M:	Lorenzo Stoakes <ljs@kernel.org>
-R:	Vlastimil Babka <vbabka@kernel.org>
-R:	Shakeel Butt <shakeel.butt@linux.dev>
-L:	linux-mm@kvack.org
-S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	Documentation/mm/process_addrs.rst
-F:	include/linux/mmap_lock.h
-F:	include/trace/events/mmap_lock.h
-F:	mm/mmap_lock.c
-
-MEMORY MAPPING - MADVISE (MEMORY ADVICE)
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Liam R. Howlett <liam@infradead.org>
-M:	Lorenzo Stoakes <ljs@kernel.org>
-M:	David Hildenbrand <david@kernel.org>
-R:	Vlastimil Babka <vbabka@kernel.org>
-R:	Jann Horn <jannh@google.com>
-L:	linux-mm@kvack.org
-S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	include/uapi/asm-generic/mman-common.h
-F:	mm/madvise.c
-
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 M:	Richard Weinberger <richard@nod.at>

---
base-commit: 0c524518413094607a6178c53a65815762bc9c45
change-id: 20261118-maintainers-consolidate-vma-entry-ff6a360ab069

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


