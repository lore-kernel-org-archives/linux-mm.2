Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6469C5AC82
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6B586B00B2; Thu,  6 Aug 2026 16:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1BC36B00B3; Thu,  6 Aug 2026 16:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4AC6B00B4; Thu,  6 Aug 2026 16:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8EB6B00B2
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:24:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23864A021D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:24:59 +0000 (UTC)
X-FDA: 85071973518.06.083BD89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5E47C4000D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:24:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=it9dz7Pp;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786047897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZwB0kepe8H+9w+FQhSK8VcxxvTZJ+pddqATUquP6OA=;
	b=SvplhKrS1Fdl8wKAIq9hqDuT2lV2aL5l1vras/L0LvcujCSoClYQfdA5yY3YRhK4au04cX
	j6GTjUhIoH6wFSJoxsPCpWTZUHkazDeArRcfc3tLy7fmmJfacyJSMs0jECpgpv8v5nv4Mp
	RsDaZneCcmOxYlSrQ54ifIqCxEpl3so=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=it9dz7Pp;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786047897;
	b=fmjJOAApAgxtAHsYgBQjGMNBmvpT2mm7EKe3p0nulJwTbGNEoiUUXXcKbGUTVc4l2cfBf1
	f9a2TdQ5Ti2MMBswx/F2ttP0AH6KJRIcSY9eQKrTTIep1JfPj8ggPNHdhmBt1Rz5CaXr7V
	uJOXi6pWk9m2tLZ6jg0g1ENmLckspuY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F3260601D9;
	Thu,  6 Aug 2026 20:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790AF1F000E9;
	Thu,  6 Aug 2026 20:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786047896;
	bh=PZwB0kepe8H+9w+FQhSK8VcxxvTZJ+pddqATUquP6OA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=it9dz7PpsOSLESWT8uwHQovZ/mvj67amjGnQ8gZRPpDJKKbsnlU1uSsY/1dLyMCXm
	 ba2y3JIf6FNk78aRrHS3h90Kr6M/zps4OruCQfkUBqboYjLqG80QbIkNDmz6dh6n8W
	 mQQ7kUuDbG1OKAQDp8JZG8nSMi9RF7HeuYHqCmUPZ7KC4oQGZ4ajukmQ1MKQXFGu9T
	 da2t8ur2ROVD5M9cVUNxBMGHOP2O4TEhTXJ1wpkcPwiLqj38eL+I6wV+tXv9o1uUMe
	 DYXAowI7nzDQEDDFNPCE9gJ9ol8ld4fAe+ZaBEx3jqA02FiOHvjBi2vKern8w0XtHY
	 30sTdJBOieI1Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 06 Aug 2026 21:21:33 +0100
Subject: [PATCH v4 08/20] tools/testing/vma: add tests for copy_vma()
 self-merge
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-scalable-cow-virt-pgoff-v4-8-ab318a350404@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2542; i=ljs@kernel.org;
 h=from:subject:message-id; bh=zAtkjtetOPzY9ZCvVmUG7AAWKdJxJJDvCD2O0e7vMx0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJK3lyInr43/OZH39eLbKZLSetMY+o5wy2lUrZZ6kDq2
 iXWu51ZO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjARqXuMDFeKHKTsNJ7EiaUb
 PnS1qhWtVE7Z9SV+XdrEE9Ys0v9UVRgZHk67+SqfQVCz8MXRWQ25+bMnhjzuvfSe13jeba8t/kz
 ruAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: rpra69b1m36xembfjx77njz9zqfig61q
X-Rspamd-Queue-Id: 5E47C4000D
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786047897-705269
X-HE-Meta: U2FsdGVkX1/P3dsxs1JEim435EsEmqcjosCRszE6fnhRI9VwJH6QErVv/aQ+Y5pbNWUvvPdRsNWVHLEesSr/PD6BXO3HnOarzjjGs8+oHcNtABkWGRW+aEfhrckH6r9gUt7/SnMzDD8blQZr46BPrUuYlTOuU67CKOR1zykyBio7Ve6dojrzf/SraQC3/sbiuCS98r3FvLRl235GhVow3Da+x8YADXXbS8KWl/wQxhaEDGqbNVGaf1MDzCiNuVDmPd/fKVtbm0imRbR7UaWcx5Upjqkti89Fq39RAS+OQBgRU4VXZFl4OKhdgYfuqoTQBqfgFCkZW4K6fRjYvFheXSiqR39nvVSHhrgwfWylo5COqTpzUapwGpn90I/MGBizXpa9kj5qT99KGvYldCdWEpEmK3YPHroWanbxNbPMxndOrZ7bN2hkOkRYODsmVFgOO7cPk6fTwmjbQS+qgkr02XkAnVlchnu7m9iMp6GsaKD+Es5J8yR6d1/0Sf0GBSI+oERtxd8+A+Yv0zG6uoS0SinSGcxt6tLe03lAzxd5/c6bdqemMM31n+zhY9uZKge1g74Isa0S5tFI96bNfQo23a1ITkqakgKzSMCv9BJENOuM6+tuTioa+sI2kXQ2TlIlKiytAtNsFboymow3xp3fkpjSPKxkJMXhIip3pzokpFDfnGT+YkL0JbYAlvYFkRC7ty9N8sP0KZ3BhEZWl/9JmD7fFWXUX7mMRvbjJwXBgEWgmLRSraBL4uXDP2Rem7oFFyhQaKJlrKKSoz3B7jXn6Es35ugqo/35sTYsIBXXVmrjBsAfQV+d0aKifSD8obyP75pa270V+wPW3ztLPnCJJBTkFpkWF9POomtAprwc6hqivg/mJvgyj75c76B33VFWXzSd0U7DNED3Uez7zoI8Y0l9qxB9zllya8aFG5nKzwsD8KEH2V2wnDbhz7QxbfrVurOa0vawoEa7P9iad0m
 hh1VIpGn
 U89a4vVYKFPxeW/fypvi4j3WSENv3GmdR4eXeVC/T7azL6eXT8XhDSPxDVfNjIEXjuj4kygxsfAkUxLR9S9Op5mv8vua18M7vYmKbGOQOiox7nLtuHotohIf8FeWcxlTROWC1GSRIGogcolnvSh09PmsmxM/CrCfcfJQbiIpnPuQzHO4vGzg/j1AsnGg/I7YdhRqdv7dZqNc2BUEQuthvaKAp66hOV/qHQ9URD6r1vWENMwhOA/i42NUlFMSRyICQRjodt+fh8Kc4/y4BXHLBf3vKa+S6VD2tjVgIxGZg3YsksAuo6+W6Ba+nnlRyiXou0Ng3O6VbrAXGPO7WONMZP17/2YRaffEVlum8dkjIc4MzbxU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Assert that a VMA can be moved backwards, forwards and between a preceding
VMA and its old self.

In the cases in which the VMA merges only with itself expect that to be
achieved by expanding its old self, so assert that these function
correctly.

However in the case of a merge between a preceding VMA and itself the
original VMA is removed, so assert that the preceding VMA replaces the one
passed in as vmap and the merge is as expected.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/vma/tests/vma.c | 46 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
index 754a2da06321..0d40d7ba2181 100644
--- a/tools/testing/vma/tests/vma.c
+++ b/tools/testing/vma/tests/vma.c
@@ -33,7 +33,51 @@ static bool test_copy_vma(void)
 	struct mm_struct mm = {};
 	bool need_locks = false;
 	VMA_ITERATOR(vmi, &mm, 0);
-	struct vm_area_struct *vma, *vma_new, *vma_next;
+	struct vm_area_struct *vma, *vma_prev, *vma_new, *vma_next, *vma_orig;
+
+	/* Move forwards, adjacent to old self - self-merge. */
+
+	vma = alloc_and_link_vma(&mm, 0x1000, 0x2000, 1, vma_flags);
+	vma_set_anonymous(vma);
+	vma_orig = vma;
+	vma_new = copy_vma(&vma, 0x2000, 0x1000, 1, &need_locks);
+	ASSERT_EQ(vma_new, vma_orig);
+	ASSERT_EQ(vma, vma_orig);
+	ASSERT_EQ(vma_new->vm_start, 0x1000);
+	ASSERT_EQ(vma_new->vm_end, 0x3000);
+
+	cleanup_mm(&mm, &vmi);
+
+	/* Move backwards, adjacent to old self - self-merge. */
+
+	vma = alloc_and_link_vma(&mm, 0x2000, 0x3000, 2, vma_flags);
+	vma_set_anonymous(vma);
+	vma_orig = vma;
+	vma_new = copy_vma(&vma, 0x1000, 0x1000, 2, &need_locks);
+	ASSERT_EQ(vma_new, vma_orig);
+	ASSERT_EQ(vma, vma_orig);
+	ASSERT_EQ(vma_new->vm_start, 0x1000);
+	ASSERT_EQ(vma_new->vm_end, 0x3000);
+
+	cleanup_mm(&mm, &vmi);
+
+	/*
+	 * Move backwards between prior VMA and old self - self-merge and vma
+	 * updated to a new VMA.
+	 */
+
+	vma_prev = alloc_and_link_vma(&mm, 0x1000, 0x2000, 1, vma_flags);
+	vma_set_anonymous(vma_prev);
+	vma = alloc_and_link_vma(&mm, 0x3000, 0x4000, 3, vma_flags);
+	vma_set_anonymous(vma);
+	vma_orig = vma;
+	vma_new = copy_vma(&vma, 0x2000, 0x1000, 3, &need_locks);
+	ASSERT_NE(vma_new, vma_orig);
+	ASSERT_EQ(vma_new, vma);
+	ASSERT_EQ(vma_new->vm_start, 0x1000);
+	ASSERT_EQ(vma_new->vm_end, 0x4000);
+
+	cleanup_mm(&mm, &vmi);
 
 	/* Move backwards and do not merge. */
 

-- 
2.55.0


