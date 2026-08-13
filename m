Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4377AC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 17:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37FF16B02C5; Thu, 13 Aug 2026 13:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330436B02C6; Thu, 13 Aug 2026 13:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D12A6B02C8; Thu, 13 Aug 2026 13:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAA3D6B02C5
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:54:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A7FCC140249
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:38:31 +0000 (UTC)
X-FDA: 85096955622.23.55E4E4D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D35FB160003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:38:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=flX92SuR;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786642709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMo1I5EICsnpWK2NyeWJQT5c5+lum9qWOStjoHG+C7w=;
	b=tnmal/QVxs2G/ebuYKATXCzmWd58AnP81Er9pM4pxb8gB3Q5GXzq79Mbd0ET/dFtux2fBq
	EiJG9PYJuQv+gTv3nlqnGguaUz4DNEybpuo/hUCWHaLI4fJdrpyyBa8bklSFVJ6YKTe8R8
	a24DSV6ipoxq9qJbbK8NOtL8CFWIEdA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=flX92SuR;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786642709;
	b=yr5A4tNnn/nJrPVhZkRLOPEVx+aje3x3kO7NiCn+GYCJcVl4eYQd+FPk5f4R8Ol/figgcE
	zCq4VXeDgWOKPCuRUzLqIjYX3b34kU2Lb1H8aldUhLwQnWrTLPAAhsHRcm0h2HvKpViNgY
	Tcuso1Qa+wueibyMu4kIoVCs7Nv8Cmk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E46240F30;
	Thu, 13 Aug 2026 17:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA651F00A3A;
	Thu, 13 Aug 2026 17:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786642708;
	bh=hMo1I5EICsnpWK2NyeWJQT5c5+lum9qWOStjoHG+C7w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=flX92SuR9DTMANg5HOpHnyNYcgOcMymFbvVD3clXUl0rT1qSy6jmD+PyCw3AOEdZ0
	 AF94M4rwAMN3kBcOk8UPefw8GBepiPJCWLemuuu7ghdebqrDPLyCqT0+i3qXb3g5Cr
	 MZmnse0QjJA/thOdojIs56h10ZQvCMfm/hOG7lfytW4p/iANjZ4ed1ZYj5cH7aAk/d
	 ZxUVtkGz7fw7aaehO7Rai1OqFhiDrzI+tAKXH5xfTUFcYFO8vNgB+Evua53OFQ+zdK
	 5p67yd44WTqiBbNyd5q3qQDlb7mQt+MATFFu27DJ1Gw51kr3Rm4BJ6WNGb2VK511p4
	 4uFoGeeLj72QQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 13 Aug 2026 18:32:33 +0100
Subject: [PATCH v5 16/16] tools/testing/selftests/mm: test anonymous page
 offset merge behaviour
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-b4-scalable-cow-virt-pgoff-v5-16-c21581c0c3c8@kernel.org>
References: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
In-Reply-To: <20260813-b4-scalable-cow-virt-pgoff-v5-0-c21581c0c3c8@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3038; i=ljs@kernel.org;
 h=from:subject:message-id; bh=mYrfVGgyI30/pbLGvSPI/0MARQQYwT9E9OZ2ujBLXv8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJq/6/5OCPtm43YsWzDl1uy+WO2RH0/Pfn8bK7pemKNN
 6NSxeaodpSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAimx8xMmy8djfnZS3D8vdn
 XsRrCJmdsXyxpuzQ0he3LmvP3q419fgJhv8RjKlaMtPnTY5dtPdhqX9izFflLRwv/hg1/9v/Sn/
 /3Fo2AA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D35FB160003
X-Stat-Signature: 3o3yd4174i6oz17hrj9o81eiwxt3jt4i
X-Rspam-User: 
X-HE-Tag: 1786642709-751307
X-HE-Meta: U2FsdGVkX1+3DIMLTDDJrYK3BI5dfEbIuoFL3XNt++RmdQ3tuJDj5v/klJvE+QTVGmb9kwe6ur2cMQ8TpXAvV6xksnM8fr+aFx9JHDUev00GBxWTNVNvCVq2MUn2Mun6GpW2E8hHECNqWpggnYJ+zqQ1Ij4NvUTGHtyF9tJL0babVFq2b+6p+QiE9p/hb42sODA/CwSUQ8BivJ/LLa5zou5hYGh2xGPcqBHn/vdMwCDTDqB+B6p9YnoD5/cjyywM8r9iiM6RE49frdXLB4Psp2fiES8ZrExSP6seRwO/KTS7SiijMhYkr9OkIUr2oBLmjDUwQp1CFGc6Mwa5S3SF4JtgZZcmTlZP/JTBSJ49Mg3UVW0vd1cdTahorbAVYRDVORmulVom7gpS1KkV+hmF/qA97ElmJDvUQ8DPdSQ0lxMkWkPFEjvNdbhuC9f2sSUZCxYUX/SavUwdUywCZp6pCcQ5GTKcTqleiXwrAfpyEmNmZBDpjkbyXmprVqAb27Pf+0U+sJxQaSCJ9W9sJxkpgyevni9ajfDi17Rnju1h8jYCQe/Z6fwHuTb76vWrefc1yGJiQEt/Sy4k4R6cppviDdgDd+Mmo2JJIhYlaJaQh70aPaJ5sVyknn8hWKXOJLth1yY/pmnceP3hgTgZD89cVr9mYo081PUu2mHJwZFQjl+9Vh2MJSgJOe1j7arrL8IlD9HTNdxKMEvU/CZkl4kdJwGR36Q6jmaIGuRGX0hyJt9GCAqzD8Yo0qzWG6hCYg0vYVWZ5tQL/EXk5e5kGwOuqWggBY6GZ9L3/qpYU4+r3BG6xytqmqsxErkjcdoZ+XZVEOlEOtSSLWUpmJRZHTuc3aPFfhZ4ygWFFmuSpdjhUesqfjaC7lDi+BQpERU+Anz1AcLZTUw95TR8lCao9mLDYIt09/r8tl/xVree9km8xMoBVL6j9fVbMCpvXZRY02QbgztT2olQ8EDMUQc4iXP
 96aQdPMN
 uUw0FLZMg8ymjNeg3K4UPv1ElpP3MxRjLgA0Q8ectsL3ibG7/hhHx2GHWcfZC8b+UHcKk4JnHh6tt7Dx2xjtYMH6dTAhrzAlfoZ0hr1uMAS0/M50oCGmWXXGeVt9WQ7NHkve1UrHpEd7PY00fKQa9OVjN2WqVEDwaoV+AOTy5/+uCJXNAP6JBwSzepkiYNJT7qWW99UfR0YS87EvEwKsoc1m/JipBZlmg9tnGx9oXypCmsyvecasjcoA8TbGkcjFZM13tW49qLNEibsFg8FRAUt840woAU13WO603tp+AXMSkYH7wQBt8bn2auPM4zPZpkyMQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While maintaining anonymous page offsets for VMAs has no impact for most
merge cases, it does impact MAP_PRIVATE-mapped file-backed mappings which
happen to have matching page offset but not matching anonymous page offset.

Assert this behaviour by attempting to map an unfaulted MAP_PRIVATE-memfd
region with a faulted one with compatible file page offsets but
incompatible anonymous page offsets.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/selftests/mm/merge.c | 57 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index 519e5ac02db7..52b8727b6628 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -1305,6 +1305,63 @@ TEST_F(merge, merge_vmas_with_mseal)
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
 }
 
+TEST_F(merge, anon_and_page_offset_mismatch_memfd)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	char *ptr, *ptr2;
+	int fd;
+
+	/* Create a 10 page memfd descriptor. */
+	fd = memfd_create("anon_page_offset_test", MFD_CLOEXEC);
+	ASSERT_NE(fd, -1);
+	ASSERT_EQ(ftruncate(fd, 10 * page_size), 0);
+
+	/* Map a region using the memfd at page offset 0. */
+	ptr = mmap(carveout, 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_PRIVATE, fd, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+
+	/*
+	 * Map another separately and trigger a CoW fault at page offset 5:
+	 *
+	 * |-----------|           |---------|
+	 * | unfaulted |           | faulted |
+	 * |-----------|           |---------|
+	 */
+	ptr2 = mmap(&carveout[10 * page_size], 5 * page_size,
+		    PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE,
+		    fd, 5 * page_size);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ptr2[0] = 'x';
+
+	/*
+	 * Now move it in place:
+	 *
+	 *                   |----------|
+	 *                   |          |
+	 *                   v          |
+	 * |-----------|           |---------|
+	 * | unfaulted |           | faulted |
+	 * |-----------|           |---------|
+	 *
+	 * Because the anonymous page offset of the faulted region is now
+	 * &carveout[10 * page_size], despite the two regions being mergeable
+	 * due to file page offset, they are NOT mergeable due to anonymous
+	 * page offset.
+	 */
+	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
+			  MREMAP_MAYMOVE | MREMAP_FIXED,
+			  &carveout[5 * page_size]);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/* Assert that they did not merge. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 5 * page_size);
+}
+
 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;

-- 
2.55.0


