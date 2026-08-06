Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F108AC5AC82
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12AAD6B00C8; Thu,  6 Aug 2026 16:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA356B00C9; Thu,  6 Aug 2026 16:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7286B00CA; Thu,  6 Aug 2026 16:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7A116B00C8
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:29:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 691AE801F5
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:29:08 +0000 (UTC)
X-FDA: 85071983976.04.B6D81FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8864B4000A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:29:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MqixkwPX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786048146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zxluIbSheiE2FDZ53esBrjUVebLxGYMQbFJodrgP/1g=;
	b=fOuP4hirTDkYvU12xengyiaezsXLCEf5xIuex2Hp4at9IiP/SVm5OcMuNwOIXz2e7J/BK8
	1n5uJshpov7aE/L7wrEHkwd6WSreg/EAZclMvBoOOZ+hRTg49ugP4SD/5wZaVaOEn/tC7i
	ZMmoDqoyXr9ZL+aigdzmfd2lNPTyYQY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MqixkwPX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786048146;
	b=rtLyfmUK8xXYQCrlD/60gsx9/ENuzAHbWG4TOMTr0q3RuzzyUAJKy3FthaDHyX3bsgwczb
	YBlvGtb9k187Tydlw4fIDOijgmNcwCV302JZfPq2hapL4mnoWSgQ4JqgoU5t3II3tav1Ec
	zeHdbONGWy+DepxeKbNAu5Zji9X4O9U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 11BD460A8F;
	Thu,  6 Aug 2026 20:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6631F01559;
	Thu,  6 Aug 2026 20:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786048145;
	bh=zxluIbSheiE2FDZ53esBrjUVebLxGYMQbFJodrgP/1g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MqixkwPXrlSArdj2AxmQRUBAZOxeLM45HENcNI18hOrmFCubXTqm3d/pW/j+GilWB
	 9BahqG6yE3oQZYYcsw3PW6+dCIC8tpH1E7EVsm176N3UJmTmu2M/Dq6UlGOOKi0fG/
	 bZWAQdPIFjolMfp+Tn/LN3PXlnONNeQMHvvqoHDq4L0yGD9qJBJnptEEtbcxSm2wLQ
	 Z9JO6AB2xF4av8yDDgKhEnLl4sZQt4ZCyPALOpTUCNvnXwIDY6FjrcByNEoCYBm0Yl
	 89v/zFEEAT7TvOEzEK2scmXfAZHCbFM3Cs7QX5BVF619scXT30pbj7AwTy6jaXq0VU
	 eOdySbmCEenGw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 06 Aug 2026 21:21:45 +0100
Subject: [PATCH v4 20/20] tools/testing/selftests/mm: add
 MAP_PRIVATE-/dev/zero merge tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-scalable-cow-virt-pgoff-v4-20-ab318a350404@kernel.org>
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
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 syzbot@syzkaller.appspotmail.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4325; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Hf1sWA2I3g3xjEoBx6Nr1xgWjzHqdTMWAurRnr10dBc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJK3lx8f3eBxxNuU4MJd/orhZRcbc8ErJlwcsVS4QDNx
 BWGF9x9O0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRPy8Z/llEfH7qFB7SUJnB
 6yfno9ad9iN3vuQpqacrFlZ0SamUP2b4pztd5lrZobh1Z9ycDvMcn7Ak4I/HB3mXjVurlwrFbPU
 0ZwQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8864B4000A
X-Stat-Signature: n5nofwindwqkqm5rjocrmtshn4w73bgj
X-Rspam-User: 
X-HE-Tag: 1786048146-527954
X-HE-Meta: U2FsdGVkX1+e5zBKt2wndLxJIV7KPy1wXuynvTMd/EGSW9kSFOQlQt4uHogaZM4y+tfvkLJqB6Dm08rFD6ljwDV4DBDjePW11wdrUkJkuLOvRNGsZsUBo/WU7uJpqZFhQvEsVNBMBbeu/vhkfRv5/qnvfaIZDE8LB8d2Viet8fJ6cJnY4YQLSFjQ7K3K/r6DNE+LEZc/RLw+ol4dr8VTZWUO1hY055pSLpRnhav2yye/Jz2rffM3NrJr+rOH3BMkAZLHyvQzRVBmRokYM488i2SCGLOhhg2x+pkNBsyv5mGCjFFgTkWobQcnI7W+J87BML6twQoWXvEppDFa6zlrHZ0Yg0CP3lvnLr68DTlWfcin3J+OLdSJhK69aFY2xWy8PEfqwGISxmaT5NIdcj3EA77el1tvsj8lk0PuFqpSt8/0PSWEi8x66dxVusfBgwgehAaijrOp4DXBhwGUm4fNrk613xWckoP+0VRYP1IukTYsrMNEFSjy++6vpD5giiaX52xZg6WuYW9kyrpa0UvlhB8bPB7lay22kvf/sFIcX+3WLWtB1nzoGf037T89Em6A12+R5WG7+5uo3GVhyf0bf+obCucdE0czMtKoK9Ycwt8+JmeTGCotDSUGtp1eNkcVXBWzJbG44DFyDgsuL7gJLVSqzNwMclMHxzhRJ6XYDw+lM9r+z0SR+HuCemIUFYxA4D1WRumuoV9XDC0l+FJEN4+YgzAX8NsxVZHO0nwTIDMXv1RqhBC4RNTXqpn6wF5cjHHQzejvPTgp3D/stAyLDxODm8G0vlkC19K/XCm3GuoPF/9AEn39drtqtVzZSs936quHvqQ23oqXp+vwTvwvc595kTSqfy7HfeFUaNFr9vaCt3XTLHcN9OncylzgnFqITyYbs1hJCntIK0Pt13DpFThEOsDSiycsutDcZuNPDRDtEargnSu2lqK/6gNMm9lOCoBMbwrHLuQ/VAGXURH
 dUnydfjR
 iujyhfWbBA3LvkEsfamwR5D43cpC1zYAI+mI/KNcLF05hn2JG/Pav3VI2idmXtidskrAeczjG58IxoFGJjECPMw+x8+mXcx0uMVAmiLlCI4DKLJmlGjqgQuzvJQamyYktn4yV0AQxovO0vRo2kCiPeqk7TFxeNUEZbLdHP3oSSZiGzmCmkPCqUCZpzIEGnLe2i6DIZ25TpUgTg6qLZx4twswxJJJhkGEThrvphcBvImRH8an/Yyh51sPuf4IqtmsSF4sIMrLKhQfRGR4iTWYlgRSq906/W+8YwL8+WyQoGsfgck4H4LULvmbr4WWaZE4GFLVwS9im44gYvBYY57uVr0SBpd+3q7z6GoPOnSxhsVmcC2Bjm+nXzzZGs6ibvr9LsZonupx16hEHGlh4gLPqbY4B3DYrUNJT0fJk/CldtQIW11c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Assert that MAP_PRIVATE-mapped /dev/zero mappings behave like they are
anonymous.

We test both unfaulted and faulted/unfaulted merges - each with the regions
having page offset of 0, which would not merge if the mappings were treated
as if they were file-backed.

With the recent change that makes them behave as pure anonymous mappings,
the merges should succeed as their page offsets are equal to their
anonymous page offsets.

Tested-by: syzbot@syzkaller.appspotmail.com
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/selftests/mm/merge.c | 104 +++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index cb7cdb6b7ada..19c9bf9eb9ce 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -1362,6 +1362,110 @@ TEST_F(merge, anon_and_page_offset_mismatch_memfd)
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 5 * page_size);
 }
 
+TEST_F(merge, merge_map_private_dev_zero_unfaulted)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	char *ptr, *ptr2;
+	int fd_zero;
+
+	if (access("/dev/zero", F_OK))
+		SKIP(return, "No /dev/zero.");
+	fd_zero = open("/dev/zero", O_RDWR);
+	ASSERT_NE(fd_zero, -1);
+
+	/*
+	 * Map two MAP_PRIVATE-/dev/zero VMAs next to one another with offset 0
+	 * each.
+	 *
+	 * With these being made truly anonymous upon mapping, they will
+	 * merge. If they were file-backed VMAs the page offsets would prevent
+	 * merge:
+	 *
+	 * |-----||------|    |-------------|
+	 * | ptr || ptr2 | -> |     ptr     |
+	 * |-----||------|    |-------------|
+	 */
+	ptr = mmap(carveout, 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
+	if (ptr == MAP_FAILED) {
+		close(fd_zero);
+		ASSERT_TRUE(false);
+	}
+	ptr2 = mmap(&carveout[5 * page_size], 5 * page_size,
+		   PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
+	if (ptr2 == MAP_FAILED) {
+		close(fd_zero);
+		ASSERT_TRUE(false);
+	}
+	close(fd_zero);
+
+	/* Assert that they merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+}
+
+TEST_F(merge, merge_map_private_dev_zero_faulted_unfaulted)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	char *ptr, *ptr2;
+	int fd_zero;
+
+	if (access("/dev/zero", F_OK))
+		SKIP(return, "No /dev/zero.");
+	fd_zero = open("/dev/zero", O_RDWR);
+	ASSERT_NE(fd_zero, -1);
+
+	/*
+	 * Map a MAP_PRIVATE mapping of /dev/zero with page offset 0, then fault
+	 * it in:
+	 *
+	 * |-------------------------------|
+	 * |           faulted             |
+	 * |-------------------------------|
+	 */
+	ptr = mmap(carveout, 15 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
+	if (ptr == MAP_FAILED) {
+		close(fd_zero);
+		ASSERT_TRUE(false);
+	}
+	memset(ptr, 'x', 15 * page_size);
+
+	/*
+	 * Unmap the middle:
+	 *
+	 * |---------|           |---------|
+	 * | faulted |           | faulted |
+	 * |---------|           |---------|
+	 */
+	ASSERT_EQ(munmap(&ptr[5 * page_size], 5 * page_size), 0);
+
+	/*
+	 * Map in a new unfaulted mapping in the middle with page offset 0 -
+	 * this should merge and would not if it were treated as a file rather
+	 * than pure anon:
+	 *
+	 * |---------|-----------|---------|
+	 * | faulted | unfaulted | faulted |
+	 * |---------|-----------|---------|
+	 */
+	ptr2 = mmap(&carveout[5 * page_size], 5 * page_size,
+		    PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE,
+		    fd_zero, 0);
+	close(fd_zero);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/* Assert that they merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
+}
+
 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;

-- 
2.55.0


