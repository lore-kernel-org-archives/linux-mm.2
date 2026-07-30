Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAA43C55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982356B0092; Thu, 30 Jul 2026 03:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933AE6B0093; Thu, 30 Jul 2026 03:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848AE6B0095; Thu, 30 Jul 2026 03:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 65CED6B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:13:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8510C089C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:13:30 +0000 (UTC)
X-FDA: 85044577380.20.A029219
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2CC2A4000C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:13:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m4dlqh1u;
	spf=pass (imf07.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785395609;
	b=xuEk6RpSWHyFm6iilWLVXkwRVUAFE4OY+uSrAOu6L2Eea5O7L07m+2fhu8SyQOuLVhaE+b
	4H9n4wb/uy0C/IKGb8HpimZk3vNsbkOgf80MoMczgqW5uRynbNnq6QkUfOvgPgh4CLGUzU
	qnCdgRioh1AJHHyvfhpPdZB0gXaJ+X0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m4dlqh1u;
	spf=pass (imf07.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785395609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CPrk4t4iG0XjStu+o65Zjwa966zGEs6R7VTzoqoByrg=;
	b=QQ+3vrNN9xVz//LhIuNPIhPck5S0N/E8GmT7f3GIoSyc/zDEtGSMOh4eeDrAuXq+UvYUW8
	5Hm9TkZjLNut5fCZPheJzFIZfFTzspULaPLwNrpGLvCMjr+p6Er4hYdzQgmLSTmNArLvJ6
	ddjgBmUd5/ggIQ/Srk1Fs9vh2NUzOAE=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-47f3b39f2a1so1676338f8f.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785395608; x=1786000408; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CPrk4t4iG0XjStu+o65Zjwa966zGEs6R7VTzoqoByrg=;
        b=m4dlqh1ue2av4YRxnla0t7NCXsV5n7J9IrV6lS4bQ0n+Pls/qz0yDX6Ir0vjMlobXG
         ZmDf6u/sRLArGHzCK6/gcBdzmKbwoEgIWP9OKbaWyES3fe+npSvXVOLy5G9f5j3E8gEw
         OWw1QwGJT3XudISL2oZXc62oVy3/mmOLPdo9OO+g3SFr9ajLhH9ZUilZNulF6L4AYCc2
         2CtwB+SBvcxElbRj9C4yfUYWUjR2x3ftRQ+IfRw0b0gXlnlT9410qzmCsj509oSd2P/D
         3CQXljOoaStjx2c+8q/MrfTdaplZI58018Eny9dP5hyHRixZwhzasr7wFpWbAemj1PN+
         Mttw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785395608; x=1786000408;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CPrk4t4iG0XjStu+o65Zjwa966zGEs6R7VTzoqoByrg=;
        b=eHjfpz43FMmFVrXECj/gLAFvqOxmEpX33geouLHOXUQ4kr8Z94YstaqEe4TWIwNIxB
         ZuJnhZPVNUgK+xDqNtRD3Yxl4Ik7bgePmBaWJz+fVHXoOT3n6jRzSr5tsl3ST8kLj0X6
         Pd4KPO6HcPFgtgJxfnoj6YFQa2TS9nL8tZtoD1pQ9ADYICiXQiAcYGFfXfW4SEjcd7cg
         veH8zYFyt3i3rB18s8XU9+4czhwiFRv2RxIDbZ+Nzpy+pHyMXWXV87wbHuNBCUD+Veyp
         rYqQ0/JC8JYmqdwq0UtFwWCyn9wEMqxdzIYsUWv/XmWbkLgmPue8kUF/7dJsq2savfRU
         JyKg==
X-Forwarded-Encrypted: i=1; AHgh+Rp9Y13uVGGxaJB20oNmIyOIwsU5YM0b7AvrAMmXFUpTrkBuUr3ahhYIuINMUb25wV3qEAdmMVSw6w==@kvack.org
X-Gm-Message-State: AOJu0YxnN9uDC7q116Kr7fdLZRuPTA3FRyn0uGDS+u1CpATT4qpiNP+S
	DgbmmamCc+BUwy20PczZ3sPTqcCT5xO1UOryP1LtT6A3jNY0SExjMrdj
X-Gm-Gg: AR+sD10gERlbHnYurdangPgnRkhLDYLh3ATpPGtM7nU3Nk6YucgGOE3ySGmupPMvZu9
	3sY1o37oRGgAcYWwcDRAN6nbbYnn860EyJNqLX71TuVWGK4MVG0d7hq+LABlcRJhS6VriYxBqD/
	5UxjfUL8CwJM9TWVbGnb3Wev30HmyOi64CTbn4XzwgpG3P/L8jHFnz0T7wStnrppmoOA4CWvmQy
	SAe2vC6i9kxTxjlQQKCLj+BBalA4WIK8XUc26Ba50mlMM1xqvELna7MaWHZFU/1C+QTD1knjuSR
	F1yTv7BnM7scQEKYrjRlFMi5XOvr6UNK1DF/ZdUbFZtQcgPNlWuBJ9qu7UZLVUH9Jgpi25nQWEn
	cN546QgByVb9MvpIye6conIoWoAK0GQ6mJ3hVgSaqbkru/wiYg6x9qTu1ECjNS3pC8z6UznbE3K
	OdDYOVp4cfvvvDm3knsblOc9j1KWOiJ+PSJfOCX767wf668Mm4PZBR45froXgiF8vG5jEHNILLy
	vsF2b52BJ/m9A==
X-Received: by 2002:a05:6000:4382:b0:47f:6efd:8421 with SMTP id ffacd0b85a97d-47fc81ee02bmr1757235f8f.13.1785395607476;
        Thu, 30 Jul 2026 00:13:27 -0700 (PDT)
Received: from LAPTOP-AVI.taile24b5.ts.net ([2a00:a040:1b7:4f41:1fba:f3be:5adb:fb78])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc88d6f18sm3534010f8f.4.2026.07.30.00.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 00:13:27 -0700 (PDT)
From: Avi Weiss <thnkslprpt@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Soheil Hassas Yeganeh <soheil@google.com>,
	Arjun Roy <arjunroy@google.com>,
	Eric Dumazet <edumazet@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH] mm: return -ENOMEM for page-table allocation failure in insert_pages()
Date: Thu, 30 Jul 2026 10:13:23 +0300
Message-ID: <20260730071323.964321-1-thnkslprpt@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2CC2A4000C
X-Stat-Signature: tednji5kmeth77i5hn9p8ntrgp9kxrq7
X-Rspam-User: 
X-HE-Tag: 1785395609-555654
X-HE-Meta: U2FsdGVkX19yHdXfsD2sWv13WbSFdsPTxYRWwlchtspQ96oBDIJJE2nUOaccMyuW+yGzS0ypFO1JD/9Riv8PUsRQ4fPz1AdmH8fISQEY/oV7ftZFYrvtSQsinRCia7DieYprUAZgXCWskD+mVXaXee6zzMVykk0TZUNB+PD4da+XUuqJ81EQ241k86BfyGCmLrjHb8wTCh5nSNshB0YQEENxHdCHFdRczC0gHcUgr+mlm4bIpWT0nSEQMFrRAStRd6OwiosUdO32pXpYS4gmJL963iny7EdOXPBC8rORM4dLFBeFk4/1Fm4b5S8WswN5oCYVRgk8C8Kxk7haV/zOAWnhQF0+P/k9GvOBAac5V55BjBE2fsiZ//dVRCigHDdciooJKOEj1rB3cnFLjwIDtPij7r4wHR6wO5hcEBjuJ8anKDyDrWQU37yNu90liHpkQPnqoAH9VURtBJ46zSWqshpXEmxYk5RxZEwzUAEIQ5Ah73Qmr9TPVXEn4rqwxcbTphOP10pK5twp2ZaS2lktbEbocLvCIL6htHiYKoEC4AAW8NHX7JyoqCZtP/WubfVbBWLmXaUuSqE43dcxxW4ixmAzrJRBl1rHlMnPgPuEs5KW9aA+yKqWchpm25vPJzXEUR9wXfgUgSobTl8yC2lOOBN6gmKLhsjhBXeg163G2wCnDC/K/52Wr+CAdtqQ0/D5IzgThW6yIrEF/eIryT4lzqUmjtkuR46y2FUjbL0vnFBW/qukZR18iIDWlvaJhmR02rukzOztyGk7K0OoDKhCxtuyuF/BvG4UElhtkNMMu2dMpZ8KRq3jzUGR/KDbG63cbhVfM1zPVUgwae0HcL2+Jve/hPU8/7Gs9go+YMsvyPE/LRo4xzwDIKRMRH/o46vOeBwPzjO4fvJFOg9YZ43TRqA5ddQBlRIls2f5ke2lhPdw9tkc0fnF7oQ8rzynjhvg2sbFTM44FmmaMqGXrbL
 H9QujHHF
 VG3w9Ni3sbBxpGLgILEpY8evEkCoUbEYld/udCP4g/v9r0aGdLsomQQzxrp6P9/ZLFZDjELDG/0Swml9URtNHXBVToMNua+F+gWWhpUwQz6De52XVp8h5TguxcViissEe0l65vv/r1tZrv5hlo/a7uDZYuAkRcYkE61oIEXkUY2L/j2xhLB7jxjDpxsb4UP9yJXiAXbcD0HrAV1p+4ZKPDoWp/Rqzj84zpmqzUteCkdXSBpAFGKkAhgaC83Ytl0AD1w2L99RCLoBbvHG5aGQ4pKAih5hggQqaxic7mutbFw7Hze9UyIBBfMQ1RIMcK9UsS03iNf6KBNMktKDGzp97bBRjQa058KyRNCggkh8shKhFjx+5jS5Fy557zn2Uvw6NcwyOaleS43aJ0ecxSX4aEBfwY5HOuRzjNQccXRm+evMWEm/WZS6Ecio6wbI0zf+azp9KgY3vpJ+xZr/jthjlC6abTxBdOLYnnyCTAU3zlnhsV7RUI6Kk6N8JpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

walk_to_pmd() returns NULL only when p4d_alloc(), pud_alloc(), or
pmd_alloc() fails. These are page-table allocation failures, but
insert_pages() currently reports them as -EFAULT.

Return -ENOMEM instead, consistent with the subsequent pte_alloc()
failure and with the single-page insert_page() path, which reports
failure of the same page-table allocation chain as -ENOMEM.

Address and range validation failures in vm_insert_pages() continue to
return -EFAULT. Keep the later -EFAULT return for
pte_offset_map_lock(), which is not an allocation failure.

Fixes: 8cd3984d81d5 ("mm/memory.c: add vm_insert_pages()")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..d8eddca8e251 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2436,7 +2436,7 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 	unsigned long pages_to_write_in_pmd;
 	int ret;
 more:
-	ret = -EFAULT;
+	ret = -ENOMEM;
 	pmd = walk_to_pmd(mm, addr);
 	if (!pmd)
 		goto out;
-- 
2.43.0


