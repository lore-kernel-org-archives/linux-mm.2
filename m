Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12FC5C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D4216B00B8; Thu,  6 Aug 2026 16:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 084F46B00B9; Thu,  6 Aug 2026 16:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E684F6B00BA; Thu,  6 Aug 2026 16:26:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B68986B00B8
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:26:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A091B1A0221
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:26:01 +0000 (UTC)
X-FDA: 85071976122.25.75B405C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C2E9FA0006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:25:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XLaBEEfi;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786047959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aEc+GpTkQ0+PyuSQU7RLIhs+vRcJAzmQsvl5QanIRU=;
	b=yUtp0NY5Trp73FxcWCVQ80lc6Wfhrj2IeIX+jiGU/RX/ZIs90nuj2czyoHcx9Cs4wFg4QR
	Xp2Z4srO0u9390FJS2tilM9alK+S7YU/dxxVHmsVqVJ5IqNQtevOuNqJl4JYxUOlqKLNH8
	SbVT9a8k3dSKBIIfxF8Z78H5dLqyE6k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786047959;
	b=YAsUfjp4XP6LLPI+6qNjXpvK3SxQS1XC3pEtpG/qj8zSUp1goal2uYlD1KQ37twLYrYpvv
	L5kGU7sZXZ10VrEX+RT7NWm2XmsG3EiUJQIvLeB1V6Ip9qMN/Jsf6Q4LSlJJc/pzzBquYP
	vBXxBAK70GWgANy+6dFxdUKP55BNQls=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XLaBEEfi;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E53F642A87;
	Thu,  6 Aug 2026 20:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10771F00A3D;
	Thu,  6 Aug 2026 20:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786047958;
	bh=9aEc+GpTkQ0+PyuSQU7RLIhs+vRcJAzmQsvl5QanIRU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XLaBEEfisdymhdMAkrk6t/WHMuk76cQnpPqVJx/MdqUpfsyAOq8O9FcCUK5GppgIp
	 w7FnNc6qQQ0UNCMPFsuI6Jax1IE0OYNlqFucf6RWEoE2XlOgVc4Rk3vK5+CSDdUmY8
	 p44YMxs/hfqSJ1P1IdejNuBo1hKTQF2e8eNGUSsxRik61Rl6PY8NtTMk8b3JbCFjKp
	 m5QGQy3/se94DfwMWTn7kQEjqaguvLEJoU8xj1Q/GGWvwP5FJuQZCK96QJNd1NVz/R
	 D8qLVd0suYrx9nGQDf1i8x/ZxFpE+E1WIcwD3tJYm9/xVPBEWRE1uUcx2IsGZD9/k2
	 SVtiXx///mnLw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 06 Aug 2026 21:21:36 +0100
Subject: [PATCH v4 11/20] mm: clean up vma_address_end()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-scalable-cow-virt-pgoff-v4-11-ab318a350404@kernel.org>
References: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
In-Reply-To: <20260806-b4-scalable-cow-virt-pgoff-v4-0-ab318a350404@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Alex Deucher <alexander.deucher@amd.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>, 
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Youngjun Park <youngjun.park@lge.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
 linux-s390@vger.kernel.org, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1986; i=ljs@kernel.org;
 h=from:subject:message-id; bh=p3P1FLjNmsKquOfKyZ9JRZehrfWrVy9CMy59xXBf5Js=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJK3lz4rtf2q3xF3rGaAu1zfh9Zdudted1+r7vBoOHDr
 6uNy3O3d5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiTFMZ/mc+EX+ZtKmTb31U
 z6fvdm+/6MbrG2Xmsr7RP2Yf8Krx4mWG/66pky2Xek6cYnxu+bc7N/frhYs8qT6pY3HlUo7Wbpb
 dVowA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: rxoka5up7xtuw5phztfxh6iphfzkwtbj
X-Rspamd-Queue-Id: C2E9FA0006
X-HE-Tag: 1786047959-80224
X-HE-Meta: U2FsdGVkX190d5t8zVn2M3RxMXVj94UlZw354Z8vdsa0zRQMCJm2Qb26ihKYYymEgO1GnPmJyXdQyUgRk5FJ0/MjDA233xY94koQXTh4hQNRMxwG5vAH3bBYxo1i5mfvNWrj4cdzH13PC9j7p97A1iLNfJKxwr0J64L4eq2X4VhAuJLkDu/c1mRdD/BctPnxje07H5dN+ALcbi1N41Qm/kZwa/3cyzDfGR+N4C5FhTccVT1uKJIqW4LQEDcI2ucd20qMROnQS2AugFAK6Ix6vzVkwA/vQpfJxOoLV7y3RZlcPEIE2OvCbpEXTLxFqEq7HxK+xJ1313kgg+9Pa7DAdQVBVN90KEJ3RScaCErcE6WXmpnoyasELaTO77bA79TJrDcOGbZ7LchaR7Gjijz2Vjh4q/Yu/YgMGFSnvUqXkzdIfSnAtJAiDw5k8BD5DwtNjBuT05F/9Ly8nPjH+Gb9ngSfo+ZHvZhXSt1GQIihwTYuHvAhO+ACc8xhIusymlvXNkxyXJffWJnOOLx1uEjiVD4jOYFpc/+eskWg+8T3XhzCmm9qIencIKqLYm8Ied+ChAgcYljnwPwo75JqOZk+nXtv3j367Hyx21a2Q6eysBbbLc75TBYj9M30vrduFA5FATzGDrIEIk5i1KNB0oWMjDVCbQByXP+UkSyH1hlmdQhaefvSvhOneTxIC/09X0UbH/h9H7t7qLiQ2DL/yiZdAL1epTuwvVJedFl49oa9wlvLstyxUXbeXLJAi/+6Hi845Gls7VONJBJCceFLoB8ld5H7dlxIGxgIZnmR/DtmxJZ7EX2gQ+Yn4BXfRZvDl2MBxFsGD1yr3pBUcLavK2WSCHAUVs53w98pQOLMi4FvbZBoeS9dAGF/qcoRkcT6Z4M0FRPNc5wAbFVpzdvgHnMztEp8hDkVHB6LSxcqbOa6n/aqs+73DCgywRhAmGK6NCxkW60nksqZjhX+uqf4m88
 ciRS2nqw
 mxdxjNePZNVnf8sYC6OGwKIzoZAWlZYbb2r7NaRCy+XN5/coNcDa7IX6mS9JX2K+7zU9j46G7aZd790WIp8g6+E1giJUhWr4Y3bB9dh+A+Qr0GH7chDlIpT1QLVLY13AZHcsGsrLtvMdjcZPamjw1aYWGPqLiRxMceTgEBkfPCTuwG/VyLsbur7Ri0GFZNHm6GvPZAbztzw/hSjcro8O4yybdKztjiunFNJeZ5LKcqvIBXewxuTWCuc7WLtkftBoDnvGwsyr6IcSVM9utVdcOP+e8K4DVbF8YYIllSCX0/6GXm6lVdJ9QF04HKWybRY7/7HLDJiS1yLiVcg3VHQOMnSSh1el8cTENHTicn6dVFAFEXt4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vma_address_end() is a confusing function with a lot of moving parts so
clean it up prior to extending it for anon page indexed mappings.

Const-ify some variables and establish pgoff_vma_start and pgoff_end
variables to clearly identify the page offset for the start of the VMA and
the end of the page offset range specified by the page walk.

This simplifies the function significantly and lays the groundwork for a
future change to update this function to account for anonymously page
indexed folios.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 03145b8d0d56..98b067472ceb 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1079,22 +1079,24 @@ static inline unsigned long vma_anon_address(const struct vm_area_struct *vma,
 }
 
 /*
- * Then at what user virtual address will none of the range be found in vma?
+ * At what user virtual address will none of the range be found in vma?
  * Assumes that vma_address() already returned a good starting address.
  */
 static inline unsigned long vma_address_end(struct page_vma_mapped_walk *pvmw)
 {
-	struct vm_area_struct *vma = pvmw->vma;
-	pgoff_t pgoff;
+	const pgoff_t pgoff_end = pvmw->pgoff + pvmw->nr_pages;
+	const struct vm_area_struct *vma = pvmw->vma;
+	pgoff_t pgoff_vma_start;
 	unsigned long address;
 
 	/* Common case, plus ->pgoff is invalid for KSM */
 	if (pvmw->nr_pages == 1)
 		return pvmw->address + PAGE_SIZE;
 
-	pgoff = pvmw->pgoff + pvmw->nr_pages;
+	pgoff_vma_start = vma_start_pgoff(vma);
+
 	address = vma->vm_start +
-		((pgoff - vma_start_pgoff(vma)) << PAGE_SHIFT);
+		((pgoff_end - pgoff_vma_start) << PAGE_SHIFT);
 	/* Check for address beyond vma (or wrapped through 0?) */
 	if (address < vma->vm_start || address > vma->vm_end)
 		address = vma->vm_end;

-- 
2.55.0


