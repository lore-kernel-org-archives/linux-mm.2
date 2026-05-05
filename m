Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CCBECD342C
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 01:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6ABF6B0088; Mon,  4 May 2026 21:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1ADB6B008A; Mon,  4 May 2026 21:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A1B6B008C; Mon,  4 May 2026 21:01:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9057C6B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 21:01:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 05DB61C0246
	for <linux-mm@kvack.org>; Tue,  5 May 2026 01:01:34 +0000 (UTC)
X-FDA: 84731563308.28.FAA68E2
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 450B180003
	for <linux-mm@kvack.org>; Tue,  5 May 2026 01:01:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ter5qU2x;
	spf=pass (imf30.hostedemail.com: domain of rosenp@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=rosenp@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777942892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=noRB/3k3PKvhvGq4d2i3S6nAV184FSHocbhdsDyNxPc=;
	b=P2o4TKh+I8IYwc8hrepbE+KpEp0EM4ddK7mTyhuEqEAIw1copM3VqqO1uU1L2kJSCS4eHN
	n+VQAlAJmDK6Q0lRE5t9DwomdtZkmTgHb73MzrbVwf7g6A9klmk/QysXdjRVlJ1B0Nxs42
	N4LyCJWA3N0QJxpltwcQpqSt2YvB4zc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777942892; a=rsa-sha256;
	cv=none;
	b=XhRLZUeQFTt9U3KSfT/fwtGWBWlEqKanFyiUlb52NtjsTD+2Wc4g71Fe8QsSn33OOjyNdQ
	NjTg7qAVYg4Vk8dlPc2ff21itKOiDJXxDEbF/0SMCfy/KYDR5rTtqkeqi9Zqg9hTDwU6SM
	lx51EJ23HvB/arB4dIRK1GW0gftXGzM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ter5qU2x;
	spf=pass (imf30.hostedemail.com: domain of rosenp@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=rosenp@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-364ef7a759bso2062583a91.1
        for <linux-mm@kvack.org>; Mon, 04 May 2026 18:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777942890; x=1778547690; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=noRB/3k3PKvhvGq4d2i3S6nAV184FSHocbhdsDyNxPc=;
        b=Ter5qU2xQHv6ccvriVKol5U8N1Bdo0EEzDZ6l/joJJoxofUX72g0mLikIZsaoLnct1
         6E81Aogg5Ixz6ij1jYXsRCbSLCzZGA8/qqZ666yvuysvuLef/s+bZgE7eZ8xG6SvMQfB
         F6OJlC0gyjs8XBQwS88B8a95k0NSkrFN+coGTICunrVsXexA9JdOMfUna3hGOxTETlXA
         0QBYXUpvIo9RmdJo3sN4XP3ihmYHwXcowLCtRdT+YgCye8d4gjtN6JxaOcbj8Im/naFY
         1WsuBBNdAm0+HkgxKDpvBYPKHFHbAAw+EMlH79Ve+8jbA9VkllVJRoH7/521rWzXsaN4
         mQXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777942890; x=1778547690;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=noRB/3k3PKvhvGq4d2i3S6nAV184FSHocbhdsDyNxPc=;
        b=grUrnY4CSyh/9z5g4gmVlpSBhOseWjMlEAPSMl2rWMAaIaWAnmU8G0fNBzPEI696zX
         m2mmCHdLLeILi/XyMzJmErM4uuWiV8NhhkJh/vcuxhobFA3kiGmerHhQ3SmzLdIBRzx+
         bkcj2ndcUantmz7zqDmajYMKSCZaDyHRLZG32kBVOZTGFAvltkbS/iN8G0ukGqSyMrp/
         +dmiRo0iZPJt+tt1aD/aZvRbZFq+8Cr7lLjUiukl+H8k/DGbak2ZjJ7y3SMbjBe+t8zW
         w0VadPCLu09A1TT5PQQTP/Orqw7JY9LIG3i6m700RPlccuLjImKgDAdAAIqRm+zAX5ct
         PCIA==
X-Gm-Message-State: AOJu0YyuNZ/DFiD1e1jLbPEBZAM1C5e7vw37GOiWT/Rtvkxu+bIX04j5
	iv0wPpu5rJ/a56KNaahoyAA9lBcoJFTUxqHMyG3ORAEhuSalgLv4WA9W9hrBk4AC
X-Gm-Gg: AeBDies8FUDhnxPihkpS5EwAb7I03GDgfKrJ4AwP0vlU8L0WJhZx78D1hU7xA4yR9hZ
	HlWrEapBKOJN7pOd/JbjqnqC3BsPVNDlWJArhkMxN22BrN1JcLDwcLQQtA2fPh9zdO6gn+hVPqs
	rfH14wc+nBuOKFtMArzpWKqTU6hD2y3NMfrOS73H7S21W+yyyhGuwKAg2yq+5BrhjF3SOFm9ung
	hq6DOM6PUkApYhvQE2UUmR5SLftVPDH/3HPo4NfffQTXaC1nmDZYXhGa37mh0lWKDWu8/crDj79
	UilyjExnZEXHUfzRKJ9Jb2I9VogWOM4aOewsoca+RolVtnQUKFy5DMkP8sXWcQ4zYgsE1rlez1M
	qw6mi6lS7oFh+rEzSdwRLBT/xItwS9oDRwkiYUmM9gXX8POwYuaiDbXvhTjxvJ1jurGhQHCQRl5
	KCKmUkwCKuIOTCySOYkE9Lqfh8nj7X9RQZtrrpIvhjCQh2qDcUftPwpfSQEyBeYA2Xv+TjM2Gk/
	Cm/Pt0m/qqzU86oVDkaQ0POMPr4go5mUqSBoIWj6JPGaA==
X-Received: by 2002:a17:90a:d443:b0:359:84a3:1942 with SMTP id 98e67ed59e1d1-3657287d45bmr1268764a91.13.1777942890198;
        Mon, 04 May 2026 18:01:30 -0700 (PDT)
Received: from ryzen ([2601:644:8000:5b5d:7285:c2ff:fe45:8a32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ba1c451d9bsm53830935ad.1.2026.05.04.18.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 18:01:29 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-kernel@vger.kernel.org (open list),
	llvm@lists.linux.dev (open list:CLANG/LLVM BUILD SUPPORT:Keyword:\b(?i:clang|llvm)\b)
Subject: [PATCH] mm: move phys_mem_access_prot_allowed to header
Date: Mon,  4 May 2026 18:01:12 -0700
Message-ID: <20260505010112.645361-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 450B180003
X-Stat-Signature: juyfxcqg3ajpte41trczwe4iwi1c9uh4
X-Rspam-User: 
X-HE-Tag: 1777942892-11466
X-HE-Meta: U2FsdGVkX1/iDDykwthPwTKu9JDzDudBGlZ7sHFRK8hA2IfnRT7itL+EcXnBfkBqakWKk0kqhO0VWLC+EkGp/ZRpWhjhEY/kYlEzKv23Ms5GdWm60FpK0BiCKA+1mTa9s/9743AlcWvmO6TvSzLk3PYZVRcE/kmNO+p/hIU6D1Cy72dxSIb5jCuPVamwKRlzDgYJK2NxC1DsJlSo3U/MPoJFRMmTUf69J0orpqB9dwzbaKCLJa9JLxOyKlwPkCV6QqBMJTolYLg7SSqta0sTkar1SUDIU5/ZjD0OGIm2cn/Q2NKSyKYHLYLtY9w7/7vrIxmDkaU+9rUBTdPnnXnJpDzV0bp8YK3uIDCc7jeqxjOpt1wVIhDtdsm/+kiivaEPhmNF7V23wa4QBAhZwEc2n3U8IlO18D8hoSlE4JAK9x9arY1EaWYVCrUDVyJHiLauP7iw1wpI6m0SxsEz12zz75YszDBhrpZ0APVM7fjpQSnJL0Q0DEaOKvAm12Q1aae+OTJz9gXun1QI5bd7GV8fwlx+g1QiU1PNnXHqUKnsONdIRA4Cm7rP5jWlmx++BjCGpNu8sQg53jPI3brLMQLItWg9sAuUqntvCl8opAnnQAC1cnJ9Ris2VgdJgw6T3YseuW8OzwlhrMYUYLQgtigH105Hyi0TT4o/ZH5GOX1z2rZ0BfNyYz0wx1WRQG93z8YFA1YPCvH3W8RgEzEDN/giEjoqclIcgRgBSSP+1S+DQY4LMSSJNVGYQwdtdu3YCIXPr2SpFxLHIoc+bqo6ADnht4Yh6iyZ1WwjJ5GE7jUSL0GvomoJuEw8IuYcX0GSNSU96Qf57Z5QYb2fYAKgMh9gv52y17PpbP9nwl3jp6M3BdvztZkGfg8HiLhoazSBWDl1yeUuzaPKAgfC9TpfRogTpsE7roNZjQsgoSAYgAK3ikxvK+V+7UfxGSQLnpuFR2pd8bMb7nQzQ50FKJgoCyy
 ZfhSGiSH
 G8WBsxFCjZi7IwswvD2uKfMQRQurIjk+4GaGhEH8q63VsPVGfEX39rtTL226g5gBVWInYrPZGrBxQD4UQ+lcq3pB/zpl7+xDIElGwJaHpk+oRI7JRP3VS/D0I5KBU6bQeB6XmhsqrLB9HOrwtHEXuVD3zW7EcbSeFvzM+RGUf95z1p/59pg4Wz1Z78ylkhEb9YILjh6CNBHGs/0GzeWnUPO4bO0GgMaH22OOF6XyFbgvoMSZCC+IHWpSy3vVnwXMb/LGp07vvSiBrCDSHWExpyVZm6v+f1Y3GvZHcZwWQ7fruKFkmmTadFI7fmIg26/Pl1aJMJvWh+jo0BPAYYWEznBu5RyhDL/BFHwiljLxdRsi5JsYAiUZEPEdpr3SSAj2FmvYGpElljjzHe3ztXMxWpWixCfCR2jB/JWqcNN9aHg2jQX62nbQROj54MoTrQUynDt0TKsnnMjC4SpORFa44IeWkYDBdOHvgJgPHufdFcNK/Hq2XwF51DX79AyB/ZDPt2XFWvb4NywCMTebtvyObpBhguyI8Vpij9ffYVi9pq0PuuT41zbyY3aMjShShHDbN5icDpEJbQb/IrtdteMmXu3aOJz7caCGiaATnYVSnz4SmQuMwQaueABv25Mh5aUUWNVnr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

phys_mem_access_prot_allowed is only implemented for X86. For others, it
returns 1. Move it to header to avoid using __weak.

Fixes compilation with make LLVM=1 ARCH=mips

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/char/mem.c      | 6 ------
 include/linux/pgtable.h | 8 ++++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 5fd421e48c04..ae8449674f46 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -239,12 +239,6 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 	return written;
 }
 
-int __weak phys_mem_access_prot_allowed(struct file *file,
-	unsigned long pfn, unsigned long size, pgprot_t *vma_prot)
-{
-	return 1;
-}
-
 #ifndef __HAVE_PHYS_MEM_ACCESS_PROT
 
 /*
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..72a7fa388e88 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2154,8 +2154,16 @@ static inline int pmd_free_pte_page(pmd_t *pmd, unsigned long addr)
 #endif
 
 struct file;
+#ifdef CONFIG_X86
 int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
 			unsigned long size, pgprot_t *vma_prot);
+#else
+static inline
+int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
+			unsigned long size, pgprot_t *vma_prot) {
+	return 1;
+}
+#endif
 
 #ifndef CONFIG_X86_ESPFIX64
 static inline void init_espfix_bsp(void) { }
-- 
2.54.0


