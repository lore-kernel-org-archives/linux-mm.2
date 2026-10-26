Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63A0D606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 19:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BDuFowmd
Received: by kanga.kvack.org (Postfix)
	id 7ABEA6B05B2; Mon, 26 Oct 2026 15:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A9D6B05B3; Mon, 26 Oct 2026 15:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673896B05B4; Mon, 26 Oct 2026 15:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA356B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:53:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 77AFF1C4139
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:53:47 +0000 (UTC)
X-FDA: 85365827694.28.55827FD
Received: from mail-dl2-f7.google.com (mail-dl2-f7.google.com [74.125.229.135])
	by imf03.hostedemail.com (Postfix) with ESMTP id BAD7B20002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:53:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BDuFowmd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.135 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793044425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DTIyB5b+yzQFZkwGlBG+chET3oIYSbYIvUVhe1jopHU=;
	b=3hOKzYNk5RYbhCc/yor+om+6PBCb8EZQItd97r/J4qncmHwfkAtwtjuxgi/vSJ7ySgwOPn
	3Rdgu44fOfxBokjukAN/fFi4MOS8jfexXHo2XnqVYFaMbvyG8oIx/IGkKlTIcOTvwrDJLH
	9RbycRV+ItG7SBh+aHCqFglLUlBiR70=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BDuFowmd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.135 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793044425;
	b=I0OhIpPM1//nM5zJAwzG4GgwN1U0Od0HaShT5tIcxPfSmonyvC5k3yNyaxJK4RjyUCDkrH
	ILCA9hE2rf9Jcl2l0i5sw3Zpc113eTwnAyibdrM2SpV5I4ymbSCDeP/Zy56RrwAm4ZtTEA
	zNZgv/SIF3BHim/R4AVGryWqSq+KGkk=
Received: by mail-dl2-f7.google.com with SMTP id a92af1059eb24-139b659a45eso585110c88.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793044424; x=1793649224; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DTIyB5b+yzQFZkwGlBG+chET3oIYSbYIvUVhe1jopHU=;
        b=BDuFowmdcgjhEdl8XRuES8ZzolH9EfDbWQ2+NOrBz0NStpNG2E3XrMpKzGoIb+8ra6
         lHgxMqzU+3pt1cTLiWvLGbiZZt39heOMcGixKBM1yRvffIFkpDDVgtmjZYHOD39M42yD
         NWZxBNJ4ko042Fg4Z6PEzFXlgy1ekqe9Yq+fR2GcDeAg2UYRq2iIv/PIq2RFrNT4uHxe
         zY9Oul8Iqq+Yu6qJWgr6Rmni+LRg82kKD/LNr8JEk/HqGiTrVACQdaBtKRGhiDYoPMbZ
         8mAShTQhArERGWrBPkgbWUqT8I+J7d8lNBGtm7+Nm4Ca0ZKKXQRJbnu+8oGFK4bbALKP
         TGMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793044424; x=1793649224;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DTIyB5b+yzQFZkwGlBG+chET3oIYSbYIvUVhe1jopHU=;
        b=fv2KpeT2OtYhb/o0o0SG7x25k7qFoIE8aiYPqsdWJgJPVH/daTA93dQSdm457dtgYG
         WsQwG51aDMmtCzHQuUS1m9WatA3M0s3VY1ITwVeFXwV67dw9Gl+qluECf/CQ3w/t/W5e
         Spg1AnlAN+3o88TNLAxyPNzCyq34S4etlC1sarpL4yNy1/1hKaTmmkbEs6GtlJ052AHu
         3w2+P6/S5Nd3QetGn8NpvUqlbYgyFWLMRxtuCSo3Mmox1OFSJiMe9ytHoqfIKdo/O3VK
         OXx5b86N55PSbkdd6kWeLpdro3VoxRR7fV+BLdh+MiAUSpN9EuZm3BnDSeLRqsit7GXv
         Ufvg==
X-Forwarded-Encrypted: i=1; AKwUvByl8xm0SX+bkhPKxRwFZM87K3JIP+eA+M46mB31RtnPIGg6TEs8LBzs5DOp8dWBidTe8bhyrBjL/Q==@kvack.org
X-Gm-Message-State: AFq9FYKOe+H6nh3w/W2/nCDLnb+yJ8RBOvtoSlhNAKohGulQCjId0Xog
	DXIu/Oa+ovTFWl/A8y3Ge+oR2vHMYDHzlvNw7tzFyrvcppeqCt1CzRCT
X-Gm-Gg: AYBFou3KGyjEielUDwg1UNqWGOafN/MvBvUjkHFVAEyQtdJkKt5hDCSedpSA4sDQdws
	4m/N7asOFmhhsuoAlIIr41ios69YmnLPUUMCNVCo83JGtCj8d5GC6uDyb3fLoXqDPjwlP/9RU/L
	9yqRj1p4UTqTe4iJS4kX2nG3LUEeIDqm+WALuH5ADZiUBViP1SeBmyl96C/AdsjWmyhlt8R4X7W
	Rrl/2zfg0rjwwlsuUHWvJsrYLvERf6Ptl9xZhYUyALXmqjFocKYW1urg9da5eNARnTzJB1vYmTZ
	LtJs9n/uRBhSJ4ntE1PqdNuK300Q3O1knsYaTwnWW6OLdEc5Z5BfxpK1zRVRceGCzH4zuSW/HeQ
	SZx4/kpj+uayVlefH86HX0b9gQKZ1WFqsli+qPcbf0IvN9Uc1Lw5OgE9Dy+EoSS38CrncI61NYx
	HxJGz1txZU6DjN4eKMsS6fnOY6hNfx17pjm/V/+pYIQgPJha9XUwxvbRmZAwyM/hqhHbZ0KJuga
	S++um4L1lQckBvC2udgR5YcPXIpR6rUFQZe2cIDl6CyOm3dxHPdzkuHTeI8ohSrspqXmdxO1G0T
	+A0VrEUP
X-Received: by 2002:a05:7022:1508:b0:182:6c6c:d876 with SMTP id a92af1059eb24-19934a928c1mr12215723c88.8.1793044424317;
        Mon, 26 Oct 2026 12:53:44 -0700 (PDT)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a32ff780sm25821501c88.22.2026.10.26.12.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 12:53:44 -0700 (PDT)
From: Hungyu Lin <dennylin0707@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	andreyknvl@gmail.com,
	catalin.marinas@arm.com,
	vincenzo.frascino@arm.com,
	odys.yuan@gmail.com,
	sashiko-bot@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH v2] mm/migrate: untag addresses when querying page nodes
Date: Mon, 26 Oct 2026 19:53:29 +0000
Message-ID: <20261026195330.46757-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BAD7B20002
X-Stat-Signature: 3mx8qxx4rpgsogoowy6snnce4i4ni3kk
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793044425-621048
X-HE-Meta: U2FsdGVkX18GSBikbjq592E2Xgwgj8rrB/c24xzJhiKpuqbEjy07jJG1UF7tMmQZ0kUex5YvRaGRhnKJ01J9gFdqtX66etVzrlW4uzD6O3OYkP9/+4fzv0GD/7r0XP+r2zwDoMmzJXpu81ENnKiQQCcbmNx06Nc52SNQzRCUqBAsZ/3b5ClPCKFQ22dvYqcYjeYWgO6xIH9JuY4x1VTPs2z+yx0w2ed28VJ/MyUEb445zdLvbWlyO9YhyLXtAvxGmrN3CUuILJH7j80G6WrPVlZtrXrlD2ypptRRVOX66WQW28c56CzprmvoBhPxITQxAMjVfpFQDz7AfZjhZCHZyEOpyCNaRFsrdlA8DOdEfhq2AfadgigX/7AxlLrivhp7uptsLvAS6g1tlJCGZvPi4mz9FHKsNz63lMigZIjqqJ1/XbhglKT6ZxyzLzM0AI5bNsFFCjdv2PWWMjHzX6MSmkkBQaIREyAfJAsbYMowzO9pY2l5WW0MloTgMKDCI9RmCldfPRNn5zzgFCHGI8f/vIiHonpMu5XDX0QTKXb4PhIiJ11cdkHxKOEa8l5KYFOwLW0iru4LTm13vAtbSkTQZKJ9L4A/fOBy+jQA7MuzrpnZpT0q8rI5+7YZBYaDESy9c3R/agTD76h2SPR2GnjcXy1jGeYfGLmUu+A5ulPUDYoAZKPAxK+ZdgD4nXrxOGfYa1Q4rrLJKPWHosR6mBXAhTKK5thgBzeZna5fXqtmOvu6aj1otw2xTfRjHQg77TuYRP7oSTcdjE/NPsq3+MGvBOsS3b0s2SavNm/t/HkQBjVr9ZVPep+OY88HM70vsl2rpuQDP0SswREk/KSQDpciM0Z8Juppa5QkqL8wEEs/rBB8hhXW4i8OZRXEFi43Duz3YIZg/8lpSQEp9XkC79tI2d7pvqR7bE42wicBzLAGdQLALuWrXaO6hWbZo6KemlsqQSobqumVuHXCdWkzu8m
 OPH+cSNK
 wmeiz8wxHgyymTMZCzNuL2uJ9woIiFzZn/S0P7FoMX/FsD3yk9AbKxgW3G77fO4ZY8Jw740DjHwQAwQ7Pymi+J0innbG3AYnNcHQVLJ1V7atxJw7qqZo7yvQD0Op59fYou3LKHtQsLWtheTcTB4YQQz7PKr6FIczbdb3iUlPDJVNyWEnSC7Tlcj3ZHwmTkZNxBOmKpqFG+cBo29dqdzJsVLDZZxBc2ki1PiZsjDBcsdI736VO7Q2+9C0dtIX+KeFwelIWno7DvXt2zb8hVIbgvQIYr9ScV0YvL6RteZMJlbTHkW6ABSEnbB1VTxNrYCSH+OT9hfuYxsdvbL1zlUJfwQ0UAmzzMcdEpx5wGH5T8BOVq/nAYv+HGG47W2YETwG0uqokOVzK0lJPtuYNUjr95o7YzKat/zZOGynz59VP/qHjZRv+uuafPu/LjSzvV5E8yIJYHNVu5owXLoCV1IpzddpOrFYcQBAKuTTqwu0GXiXYWujFPgTXhkEq6SqQel/cJRd+diHk9APdciJKuqCOmkRHuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When move_pages() is used with nodes == NULL, do_pages_stat_array()
passes each page address directly to vma_lookup(). A valid tagged address
therefore fails the VMA lookup and gets -EFAULT in its status entry,
instead of the node reported for the corresponding untagged address.

The tagged address ABI permits these pointers, and the migration path
already removes their tags. Apply the target mm's untagging rules to
the query path as well, while holding its mmap read lock.

Fixes: 057d3389108e ("mm: untag user pointers passed to memory syscalls")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260721183257.706661F000E9@smtp.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changes in v2:
- Replace the report Link: tag with Closes:, as requested by Zi Yan.
- Add Acked-by tags from Zi Yan and David Hildenbrand.

 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 7e3a81f06974..994c78782a54 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2461,7 +2461,7 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 	mmap_read_lock(mm);
 
 	for (i = 0; i < nr_pages; i++) {
-		unsigned long addr = (unsigned long)(*pages);
+		unsigned long addr = (unsigned long)untagged_addr_remote(mm, *pages);
 		struct vm_area_struct *vma;
 		struct folio_walk fw;
 		struct folio *folio;
-- 
2.43.0


