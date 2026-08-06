Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80594C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5F06B00C1; Thu,  6 Aug 2026 16:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 766686B00C3; Thu,  6 Aug 2026 16:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607066B00C4; Thu,  6 Aug 2026 16:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 321D16B00C1
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:27:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B31711401C6
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:27:44 +0000 (UTC)
X-FDA: 85071980448.16.AA251A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 033DEA0003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:27:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B4hKckcT;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786048063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ClCpkW84PAD177XPH35BlV4f23nMGVGxhm0xKhHeq3w=;
	b=iYHffU31RonklNIwwy21wWeQXUQYOtObHlOkuUJOacfgDAJlgPk40XsB1UkcCTSr2/Rhg8
	EF3vuoEQ5zjWLcQ2AsLk77End1lPXcT5DIslpu1tgYob/mjr6sIoHCKDEkJaGotwTrUxwG
	rxSDVj4yasc/D+sEH1Umi5zfg+J+vSE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B4hKckcT;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786048063;
	b=qkZnZpVEctNQL6QIdefbppj5FAcvk9BELDw99vbufWfsOc9NgLS1By83+7PU1rexUaUEjD
	QYxnQ7VDGSzuHj9b73NX6XZ5S+HICxgzeVsZyzghS6mfCQC8+Gxb/NTnBpF1M/Fhlr5GM6
	84SfZQRiV6fIbMv4wd38H342Y3N4trU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9278C60AB0;
	Thu,  6 Aug 2026 20:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F70B1F00A3D;
	Thu,  6 Aug 2026 20:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786048062;
	bh=ClCpkW84PAD177XPH35BlV4f23nMGVGxhm0xKhHeq3w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B4hKckcTGnI9v6x0L/ttZ5Gjj3aJrvQkM3ZA0if9612+8WxAFcZ+rRUbCX98Dzber
	 l7raRWNxhdoCuOB4Tr8nxC5fsxyvzVk07NYtreeXvxelSaDvBjvTrfKrZPx4gL3LWI
	 UiVSPmsjPWh+Ayfeai5vuYgZWWE2Awbhorkj5zSxNJaF/4bIUAruZ1FzJWdxpTkRwF
	 eWGyl/qizTeY+46s1Z4rWk9pjlqm+4kZOibDtRHKID4gRnW33deK7GhTWp3S7OD1jE
	 QSCHwpbTeFA2++WU0Caop6Pj3qqCrkqHHoNAYsdZqg8Ncesem6IOqQFnD4PtSPi1Dk
	 CNhgwYSsilv3w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 06 Aug 2026 21:21:41 +0100
Subject: [PATCH v4 16/20] tools/testing/selftests/mm: test anonymous page
 offset merge behaviour
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-scalable-cow-virt-pgoff-v4-16-ab318a350404@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2975; i=ljs@kernel.org;
 h=from:subject:message-id; bh=dwMvzFqQTQnP1VbLMwGR/grRN4JTFJuzh0kdCCF1g9s=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJK3lysCLqS22lc/DEvTjyMm4erKrXupsb6VfvqGjd32
 55842HXUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIlkbmBkmLnNz+P3mZaNP//e
 VpvTuMM/JH1lZoxt1yv1wNeMf2KD1jIy9OqcM7lx65HIgSCFnuelkc5tJ7d5Mr5dX3r1sKGosVQ
 +DwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 033DEA0003
X-Stat-Signature: 9u7ifgq16ruch1qbq1g7yrxpqejhgf34
X-HE-Tag: 1786048062-549685
X-HE-Meta: U2FsdGVkX18Exf3suNCilDDj60G2fdSVEYFAgR77hoWagTTed7DAkmyxdHSc6vVM4f9vG9GIltjlvnDJFpB2Vgqrf+8m++Inlz8JJ0EIpi+NaHOGHaNzGvcZ6i7zRaP6X2zPme7Sq51RpQZg2tq+nSYpI6mVElOmua4rcPZPdk0vNjTs1ytfW7JUl9DBEQhcczah0Zc8XkGIkZVKwKHObDpdeGebCLrlRWAZvUcU6fKN3RlSEYgMDX4yZt/f6xk6Wv6BxHLwX1dVAUlWjteRi1Dg5rtw0W4kf2kw0Yrs94qR9CndP4fwxb/fo+hPj0ZVIcmyD0fkzgz+BdirW8WnGupnSfrSoAMXNt+u/hJxaEelaEaf4bKDgQFXsar1g7Utw5nfISiWh0LC+qUYICqb/DcsOwBbA1KwCN9bKrpwC1edIUaH/Tp1x5qXwho9EPyCViufMU07oY4eMMhEFaa19Jzk46RPl1yamJkJf9DCU67QZ9jzMuSG5UFP4lpjYS5nqJHffnqaeykqnjy4IjWKP33IEo58ArJMFyzyHMY56ctWp506EpdzeXA76WzQLIUs/yxQaCVrbvP/FaoRS58Ve/LX4l/lH89EzOvUaeYgxuaDtl2zb6nZxJDEGUzUBn0PaEVxLznahdahYV6PaYM0Aog7KH8ahmKWvmvVCR5P6hswwIssWwqewN+/OrFWDPpgWAXrFu0pXLg3w/9BRe5xzrt3zYQfH+QfRJ/gvXnZSdsgICztur7iAm5Tq7TN2dLlFfNZCtmgl4vm1G+PaHixCGHsuV7T5F/Z6EY06JpqlODcfv1Xh6CyN8JIkUEdEKVgi+4PRGGz1MbsIGd5IVymS+S/6U2QjYLxF2RY7VBiixKjcDODZg1IYtNckJ5xrG7XXG8IRJNfLLtGJgXyIy1z3yzQ7be2sKv5JJZwNqZ+UND1FDzxE9oqFGBSSPqKtSs7wOKhg3mXujdFAI2PAhZ
 lWf+pcx1
 NgfeEASCVKr0RVL3gAn8es4RSjpximkT60d1xLuxCDN6qxKJfX3yYYPKJaqmq7N1KV1OQQKOEBbh/OS/NQ0/fh/AuA6FcWL0yZxu4a4HMs6+UDfchEiUyJuk/3bnZ6FFb9icem8vJn3i/EFgEeWLAI2mmoyakt23KppIB6cEC8gF2+azLQVXKAra4GxoSh+ExI5razPSuhciVq/CYO7QfPot2TTNfOkak3C/CxO3NnE8lejOUmLExQu4rnqzG5gJxZn+t/r1EituIKjWuU0CSlZgK9XIEE3LIJmnDz/S8D/+NioPcx7SGV4b4cL4NAqCKxq5z
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

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/selftests/mm/merge.c | 57 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index 519e5ac02db7..cb7cdb6b7ada 100644
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
+	 * Map another separately, and fault in, at page offset 5:
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


