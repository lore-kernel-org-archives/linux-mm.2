Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A98CCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:59:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58DD6B00BB; Tue, 26 May 2026 13:59:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4206B00BD; Tue, 26 May 2026 13:59:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ADF66B00BE; Tue, 26 May 2026 13:59:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66B5B6B00BB
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:59:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2217840385
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:42 +0000 (UTC)
X-FDA: 84810333804.07.C132777
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id 336AE180002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rb9sSGoN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3it8VaggKCPcZqca+fhsfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3it8VaggKCPcZqca+fhsfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--ardb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bg9HdLIrtfTsrLcuMDzN3Kt0yw7TgIGpz80e87aySNQ=;
	b=nB/zkvYAwJTkiNWmb1k6BQvv7/56LIXAVt0Wzfou1TzPHWmZ4etpTVq2wC68uZ2NS5CsFV
	rImOGg+M56i43lHIHHSRs/RCrM4WpLuqcHWF/fkLQpRekRYH0v6I3fsC9fKwyb35WME3Q5
	KEmgSJdCWJxd1639Gsz3lMlqQUXD0ds=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rb9sSGoN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3it8VaggKCPcZqca+fhsfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3it8VaggKCPcZqca+fhsfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--ardb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779818380; a=rsa-sha256;
	cv=none;
	b=19MMZCllvWBWw5MH1+nxi4wcx8KSt9oY8ZfuaVfzXwJkUkFy5SJmRrWGuT2fcmxddZTjHe
	NF4R4oo9aZjUr7gSU7cafeNjV+QN9DtHs9I/7Hhk8gWr6JZkyVe6yX5wMxBv62fKMe5pdL
	GNfjKp5aKU23DfvHZGqvAIDlNxGXfWU=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48fe40b61a3so70767765e9.3
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779818379; x=1780423179; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bg9HdLIrtfTsrLcuMDzN3Kt0yw7TgIGpz80e87aySNQ=;
        b=rb9sSGoNLxEyKEc/UpZrd2ygku2IjJqtUfeUHKTcaR4L4rHQcP3xT4IkfI/B3eicQR
         nalKYHJTFYMEQ7XYAY3DZ2e/cPOOel4qkilMfjXd+IBWvRG1Rkd/9DO8B9RuLJgyYmiO
         Itv7RsBpAb3vf4Zxy4fqNfqUC3RJqN7Wiazi4jGkeTJvopu4dTIEBI+3oiadg8FK3Abm
         xBHpJZl/7ViRN4uWBam3oGCZba01d64IcGQnIyVBqFlww4X8jlPLasjCLPSkzFp9ZCW9
         gBeojltGOo5kpj7JBoQd1B9GbT5opg0jPms6ADPEEoqF7jnB1LGnBrsYr2aSJ8djgHX0
         DUow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818379; x=1780423179;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Bg9HdLIrtfTsrLcuMDzN3Kt0yw7TgIGpz80e87aySNQ=;
        b=LR9+2yhwlsQ92FtqaWX+ksa7K5uiOUd1hdzksIbjRy6Es6N14RceL9Cd92zG19SDLN
         bofhJc3u+7t68RvAJWfUoVCcrS34mfX+luqZtLXwDKFTiYLAITtSbz2+Jwwn09gUmJzn
         TX6jwN9I13VLxQPSBwapDY4i5OpsV3pyanbRIvpBuQO1GCH8Douypv7IF528GPXZvT5y
         H6Jrrju0eipu/YqkKaTdxD/yXgxVGl1T3cCoGz2/sS07274D1eTnkq/CPN+/Zq2JQzJL
         oGwKPTeHyf7fWLyAom0SBXYqYIbDpKpWigECQQ6N5qgwl4j6Gen8Q+nIFQDktURzAexT
         RerQ==
X-Forwarded-Encrypted: i=1; AFNElJ8nBXeYtyYSLwlT+xSyehGEuAjJkxVhjlOzdzWMo8r3gL3wjEUzGFLDXEs5awIE5hYr2tC9MvMH5g==@kvack.org
X-Gm-Message-State: AOJu0Yx3hbGtvFp9D8XxcUgq3fOiYBKFyeV9y/HiU3IHiPgylZH1Ex+N
	pW89gv38b5ZUKyDXZ90ieREGQlDK8OU7OxBUiPcvtPJNag3gN/EuhjxG4me+7iEYefYqT/tREQ=
	=
X-Received: from wmfv6.prod.google.com ([2002:a05:600c:15c6:b0:485:3f38:3dd2])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:35c8:b0:490:45bb:8dd9
 with SMTP id 5b1f17b1804b1-49045bb8efdmr348556125e9.8.1779818378710; Tue, 26
 May 2026 10:59:38 -0700 (PDT)
Date: Tue, 26 May 2026 19:59:01 +0200
In-Reply-To: <20260526175846.2694125-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260526175846.2694125-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1898; i=ardb@kernel.org;
 h=from:subject; bh=mYtVYiSzRogY9cxOoJbyywYkU254ucBHoAXG9B3cPO8=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUv0fiZrSsLEz85Vxb/brc+ssGD6r5/EdCw1zi66VivRb
 5JYlGdHKQuDGBeDrJgii8Dsv+92np4oVes8SxZmDisTyBAGLk4BmEhzByPD0ky+XTe7StYuXrtA
 se7PPWVX9mMHpG+dm3iu/EHwtpNeExj+Cv4Q0JnTu+ZI3cG3t5OPxTdavzl3yvBbYsCGnriEHY2 z2AE=
X-Mailer: git-send-email 2.54.0.794.g4f17f83d09-goog
Message-ID: <20260526175846.2694125-31-ardb+git@google.com>
Subject: [PATCH v6 14/15] mm: Make empty_zero_page[] const
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 336AE180002
X-Stat-Signature: yengc9usqz11hr8uuhx5bzketprawj3g
X-Rspam-User: 
X-HE-Tag: 1779818379-117308
X-HE-Meta: U2FsdGVkX19Hw3JwDy1RpLCSCl/JR7EpACIQyn+TEpUzcZQPZAviqNz4+t+DzbrclYXTx4zTBVAio/a+bURO4sO1SBNcP/b6KH5TRo2KBDMoJ1rtT43fJcR+uPmTJGUX7tpjNHou6w4GsZgXfSsePBEmigYSk8XETmZIZGrfnTKz1va3zOg41uahmqFz5H+WpAiW9SVF60ZNx0eZD03SPp7J9Lkhu9dQrbwzouUt9IbVfAQppTdMAc7cJKaa2PtSugVei7nPXkmZQwV13iy35axqq17fmVBvwwtgFRXZqBTlVbNr33gZxDbKepyS5jsRerUmT1ulVpH/+DXPnvQX5bx+pI/Q2itCfczBQrIaHxaITahObxQpWJCAkGA47Xbp7DfyDlPbhwUxUMAY5+3U8NH8mIWVY0a3TSWPcmtvtLXYqlk1nTRbpl+FZXlnbO8UrnLCRXzNlParCtjCDIc4WKnsMxUYFkq28yoiAjKJully3AkoMPHy63oWMgMaD23BIyzabwVzC/GxOIo4csgbtqU1EN+oNALJi7Dd/FqsTn2jbFofYZ745u7zWKTejzENgVaFHgYzPuo0z0C9MqZKFVGH6DMAcZy7ssFkNas1xYHIQrA3GOcAmaleFKU5B1LKUazntEZOlLjbstCJ3Jy4COlJJ19NyXEI0Xhx/91frieV4HWPed8U225B2DDfe8DBt40ouGC2d0+1NWrqKcFS5NyqmRRUXl2xtJUEjw5NZsqbxq94MDFGMXZITPTnKt4/0ZP/XmJjzTibeaAYu/bn6xcjkAVRR7pCn5Qa3r4ZVsGw98pKAnIXxGyMn1ZMrqaehYJLuoRuEVJfroJ0LrTue/M7yj/dGNaSXd81UmLSd8o1WqWuxuxw9maJAX18lM0d2rij+QNWwnWQKWHUKxpUEpZ1xGLYMOjzHa2TRZZlwTA97GMEGYU0By8h894qwTT45nqI2/oY3W+hn3kGRKy
 LPYEnaQj
 KqMQL6KDJ/994pl/m8su72A/CYEuYXy1CQYVy4zO7EaZ+2+WkFA8KdzCJxqvs9b1h+fngUI0FGwzJq1ZEwsQ/J8TtrY7LLYTg5U1pVSGs3pZ/Ln+MY34V8r6WY2mHurS7+C1h+1s49n1EAFXrm/R7SOcrKkdxSYy8ARS9qRTm+AxAtsfrWWmrecJ7HlK3pvv09+HXBE2LVMolJtEW+JYTZuZMR+QLjlzect4vasfDltesAZSWWgQra1BrMHTWJOP/OzQ7N6F6vYhqe0Zto6NpFv8HHTcQi7BCpAVHgw3aS2ZYzX2dPZS5n/2uVvOL4gI2mYGaeoP4WgSMQOQQMu0PKjAKzvKkkIWRYuqNMIedxf91NwF1YZsuTF5q47Bs/tIpz2XKV9AJeIscfu7LBO+Boem2TGXNQhdwSzOzYQmb5GFLPTctWc+87njitkeBmC8ISThDYszc/POuTQMgUqnqjQ9wiTG0h/Ltk1fkhOccDsDo5/4Sn4h2i3M10iKrGQN/JxAboD5LalE1S1R6QmANlHt5KPYKndlGChzhi1JZGqm3oV3pHjTUBUNzNun14qxu5+U7ojkyKJdE/rri7jInKx/NWj8lvKNPB2BsLl4sDaD+5mL5YF++uqIXXWi9BISoT2D3k4JCj/b7QENXFHk4Jk/LNmLsjgbEOs1anOcWyZFgwz/bh3ku5RJOCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

The empty zero page is used to back any kernel or user space mapping
that is supposed to remain cleared, and so the page itself is never
supposed to be modified.

So mark it as const, which moves it into .rodata rather than .bss: on
most architectures, this ensures that both the kernel's mapping of it
and any aliases that are accessible via the kernel direct (linear) map
are mapped read-only, and cannot be used (inadvertently or maliciously)
to corrupt the contents of the zero page.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/pgtable.h | 2 +-
 mm/mm_init.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..67aa23814010 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1993,7 +1993,7 @@ static inline unsigned long zero_pfn(unsigned long addr)
 	return zero_page_pfn;
 }
 
-extern uint8_t empty_zero_page[PAGE_SIZE];
+extern const uint8_t empty_zero_page[PAGE_SIZE];
 extern struct page *__zero_page;
 
 static inline struct page *_zero_page(unsigned long addr)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..46cf001238c5 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -57,7 +57,7 @@ unsigned long zero_page_pfn __ro_after_init;
 EXPORT_SYMBOL(zero_page_pfn);
 
 #ifndef __HAVE_COLOR_ZERO_PAGE
-uint8_t empty_zero_page[PAGE_SIZE] __page_aligned_bss;
+const uint8_t empty_zero_page[PAGE_SIZE] __aligned(PAGE_SIZE);
 EXPORT_SYMBOL(empty_zero_page);
 
 struct page *__zero_page __ro_after_init;
-- 
2.54.0.794.g4f17f83d09-goog


