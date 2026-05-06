Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 134DECD3436
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6938F6B008A; Wed,  6 May 2026 05:45:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644426B0092; Wed,  6 May 2026 05:45:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55A406B0093; Wed,  6 May 2026 05:45:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 40CB96B008A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:45:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DFEF71A079B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:45:30 +0000 (UTC)
X-FDA: 84736512420.17.6D426C6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3F78040005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:45:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Y0qWxXCE;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778060729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jueUnb9zt+4UhgN/vVQOFHxgLSaAoPOEUzF4/XA81zQ=;
	b=JxbU0YrrwPhmtRojbt55TSc9rsGpyGmOfwvjqdcdvOT+eHznpcM387aI5jS55wz0AozY1h
	wx7lfUIeNhEIO8JAh3ThlATgsXM+eOVCsv6GLaypbdKHWqtfDtPUXwpSQX8DqnrQq4s8xL
	5ao8c5TQAtp6zLKpfpcb6qZ8QB8mhV0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Y0qWxXCE;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778060729; a=rsa-sha256;
	cv=none;
	b=l1SBdAy7HEPkpK0Ch6mlAINnQrbqC1iAFp/IzEWu+dILIpmnS5uCKxX9J59Tb34e7wNACT
	HxngRYVWQtSMCApsfW6zKx58nv6hCX8j5FsEY1cllhaa9isk2dSeiocZF9GUhjhxq73JKI
	exW6yz07k47y1RPd5I3DZclF70rG3WY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD66D3318;
	Wed,  6 May 2026 02:45:22 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4958A3F7B4;
	Wed,  6 May 2026 02:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778060728; bh=XPQUi8kcI9WmwKX3xl5+PuvusFOvnITVdxYc3Bu5e5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0qWxXCEYRB1IYQAjN7og9sKOhPvf/8dyTcdvfDVahlt6YjdUMYvfUbO8aPrwv3VM
	 +xydqttF/zBl1udSAxeUVhQMhyKi+cDrH7JX+bdGu4gHZ+Uv/6dKg+645sQ1GKH1wp
	 GZroB5mqePcvfqPjRx7daRjX1XbmrRWnlWNSjbFs=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 1/9] mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one
Date: Wed,  6 May 2026 15:14:56 +0530
Message-Id: <20260506094504.2588857-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506094504.2588857-1-dev.jain@arm.com>
References: <20260506094504.2588857-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3F78040005
X-Rspam-User: 
X-Stat-Signature: 369bc86qpxak6cur3cwf6mywrnjpgqfo
X-HE-Tag: 1778060729-290480
X-HE-Meta: U2FsdGVkX1+FlYxtIRaYO/oLuXlDBuZo1MTlI2sguuBAjpDZYrLwXyH1Q9PRKgP/zWygVXOc2DjsKwSozl8N0dIDynOp2QC4WeeTkHpCzGexrMkEmQkMOVJwtlNaCrDmr7xxeKVolal/WVfk8r+6HHWVWzHl0a7iHqYWY4Oz+AfKAI9p+fscDEaIhzT5htFZKQCV+ggD2IP37uS2aHwrMGeDyD1jP5yhT7ztWNJFN2LtCM7FxGNPsszfqrYhcW4gl6zwGX4GGLp/MpaFsdrYJOnWqpYijhxRUkIDdeFDBBltfCrvE3LP2P5d63ZVm4+aHQ9ofnKuO66vQkcbAi4dp+JgZ9Md8ky/1SQfsujmWn1aBDaOslVjKLP2c/CqK472iiBdD9upMzg7hxOiylw7aPAmUFcjiiEk7Wq+JcVNm4bjtE4y0iswD/LX0lvpNE/hnDS+cGvSaMhQdLAqeiJosfZZqUjhcWeBWoDgVLW3jtndAyUHET9XJrfOXZk0oU0nJU6pGUlm0GvThGXD7saSyFVczAK8bkJU2RmhiLQ8VrVFHOp2dKJuQYvkVMIcI3tMTNex02FM8Is31rsrwYR9IKOGqrI9wORPUf8WsiknTZMJwulIi5WquxoKbwab0GNuxQLWOCzB7yvXffL0vyG/AIkz5LWVMYITRRBEaAb/znN/QZR9Sn8By/URv8XgbrQ5PPzJ7vYohSU5hBe394o0/S9SLLxRVaOJAidDU9/Vba96zNgFnfASMkvPjJpqtQJlTyw6+jvQVoApsv/ejret2Dg5c6cRHQmsQa1tkuG6VxDoNFxebpgrHSl/WRAQw6pso5t4xx2ypiu5BoXS47Hl55uASSQ5cX3HrGkMe6DOUhQdloVaP64OugACB6KVHaG4YXQplD6ll79GXU6I+AhTu4WDGHR3UH/w3lRAmbkPjHST0QJPAF7cVklUzVgSUreyRbL0apdgeudNrFYAYwe
 VI/zgiij
 LRSsTlm3kgbVcsVt2zR+W4Eh7QidCjiAHgepgbP8ep+0L9eD/Xnx0bOupiQY+OcjWjhPjVt4Y2jKF2AEyLlQFNmNbmYceS0aFFlMWc2b3wy8VdFDMEBwTBNKhehFNDSmqYWuhJYhRBvzv4MZL6zl1gJhakmfqTv1p7tfsL7kvS/CKTlpvYCXXxIDLHNuH6BFWiE6Be9vh5KVphQ7PAGI7s6TjtV8z9srFM46Kwil9xHvxeawa0t0oXEbt7Rd5UiAoUqtI8/T7tD2f0bCzpPRuIMhgLIndJRcccEohwJ0vD+RkByIpOreUzFIcwq1GfzmzLLuUfVQQp55gXdx8RrtouTWrDquqzt057V+t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Initialize nr_pages to 1 at the start of each loop iteration, like
folio_referenced_one() does.

Without this, nr_pages computed by a previous folio_unmap_pte_batch() call
can be reused on a later iteration that does not run
folio_unmap_pte_batch() again.

I don’t think this is causing a bug today, but it is fragile.

A real bug would require this sequence within the same try_to_unmap_one()
call:

1. Hit the pte_present(pteval) branch and set nr_pages > 1.
2. Later hit the else branch and do pte_clear() for device-exclusive PTE,
   and execute rest of the code with nr_pages > 1.

Executing the above would imply a lazyfree folio is mapped by a mix of
present PTEs and device-exclusive PTEs.

In practice, device-exclusive PTEs imply a GUP pin on the folio, and
lazyfree unmapping aborts try_to_unmap_one() when it detects that
condition. So today this likely does not manifest, but initializing
nr_pages per-iteration is still the correct and safer behavior.

Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: Barry Song <baohua@kernel.org>
---
 mm/rmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index fb3c351f8c458..a5f067a09de0f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1991,7 +1991,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	struct page *subpage;
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
-	unsigned long nr_pages = 1, end_addr;
+	unsigned long nr_pages;
+	unsigned long end_addr;
 	unsigned long pfn;
 	unsigned long hsz = 0;
 	int ptes = 0;
@@ -2030,6 +2031,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
+		nr_pages = 1;
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
 		 */
-- 
2.34.1


