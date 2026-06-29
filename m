Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9015BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:24:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 101576B009E; Mon, 29 Jun 2026 08:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8946B00A4; Mon, 29 Jun 2026 08:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFF666B009E; Mon, 29 Jun 2026 08:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DEBA6B009E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:24:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 228EB903CB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:07 +0000 (UTC)
X-FDA: 84932867334.05.4243B53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 75364C0006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jv0S71x0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735845;
	b=ymADRWTXpuRhLrjmhIqeL6UbZGxf3PlPfKP6Ohy48WY1k88A+d8IUo2VgiO3ivAtAOiAOX
	EduysRJyifAjmG/hGp45sKYpX+6+/1CBqb9UZLh8DW3bhuQTYpvsqg/+zML+QEyn40Pke/
	+OTZ/BmVM3kgz1HxVWN2FoH1IuRj7w0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=caVr5w9GakvkpY1A37y5WyHo43wHFmBLWIOiIkQAHWo=;
	b=5aiA38PtHQy+MkBPGOT07ib4koSxg7ad8pvYKYglOTWual3loHHK6Y7+eqIM5lWOuI5xwH
	AlGDkMHCBqT8OoZflSaN3+SM5eFeK7OBJEe6jhFcoGcQ4RJ8Abqpq75YS1wkYbdtlCj2yC
	/kLMj3+yLC4dUmCw6rhwzmU9jPEQoqc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jv0S71x0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1ED043E80;
	Mon, 29 Jun 2026 12:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1E51F00A3E;
	Mon, 29 Jun 2026 12:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735844;
	bh=caVr5w9GakvkpY1A37y5WyHo43wHFmBLWIOiIkQAHWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jv0S71x0XtjbY4JynE0d273n/VW6fPRlmcznd9ij1cca8fIKmAalEgiU8JCOkaACm
	 6KqZC183aScWDsZhacSbQv9LWkazSoo8rgMRieyjC2hHPQ0PFTE2knRfFXoT3MfC6K
	 KsCyLH6j+g6vriubKpidkbJ1Xm42w6dJGA88dBb2sDUPDdh2Iu87CRnUvUNfEJpqoR
	 tkXy9XYbTgMZYiMKZ3HnckzJxZ/XRlg0AvUWqxGRzMRj8DX4haLWzKFy6RdtDa+H0l
	 aBpW8jPy2czajWUUXK3OIQzRdRVRChG+UF0iZOWlTdI2SJVLQNtWYDJWkFJF+S2lgR
	 5ieRrKdfvagew==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 03/30] tools/testing/vma: use vma_start_pgoff() in merge tests
Date: Mon, 29 Jun 2026 13:23:14 +0100
Message-ID: <b501eca378b9d9734e83838102aadc9276590fba.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 75364C0006
X-Stat-Signature: odg8chgifxb886ennc8c3wmayqmyngjg
X-HE-Tag: 1782735845-711816
X-HE-Meta: U2FsdGVkX19pUeaGSIH0ITxQpY2rtWk5x106MmsDjRSX7/qSPwEFeKPfELN8UyKINqvQCp1hLd3xma+5zY65cHbdL6mNQlpF+Y6ojeMSV1oQxk9eUyR5/he6fU2AqLzGMIxqbB/0rByVoj/w0VT7WPBVqt61U1o2d6wKy/zdjMx/2g/tgPU1vzQ1OiFhmZo07kEPu/9W03wY0CqAx010Nlul8NI7zJL+1RhQuIA8MkIpD6yb8jxDYZsuscVysSKXU4fTGcVEI1YaHOIvzEzT0JOdyAjQSizKXuKP4CIU7qnnrnwG2V2KG7tOpoZcWfk/CdnYgsSMItK0xxd8P+TQ6Oge7nmXMMvxgAKVgVC/476cPFd0iZ5ZpItyCakBJYotFuownj7Gw2zW8xK7hkE5gr3ThZGwN7onHx5pjdFuT8aeryfD2RIAfHdiKDCKHsv+/cxwJaNzQmC2H8fLdFn1zDUbavqteu5i4CiS7sic1edaKU7sMPGZcVyOik386BBoaqLA0tOfXGl/TR3aTqFeb/OZKhgIfXMredFzAXumjUdFLAoypQNPMMede4Kd7+zhQHHKwvi9xw0z2WQHM1U7cw6zf35wTGFvSQ4DcljeqN3+fSXwdJPZvOOoJA8SZpePz+7OLSBsN4HgDmqX/jYHj27MRDY4CEsUWWFs/amEL7mlRlYq0S7qRyw+PDGgHGgZAghHlKWux1o8irUJnxKMMNyTdEanoCkO8sb2tIBKHVWotscL5yO0X5sZcnptZbUKvCAh2QGCaRoV53WwDKDj9K48ch7dtOldp6C5w4hHWsDn83MXOIlHfyqRvPWHfbt+mwrICRC4+tGMbrGfPtqwhJsqn7eZL0+J6Oyb6jXW3ElaXQSVyRJ75+LKr2X4P4AKDTLmCQyn5pJfJ2OHsSt+M4ACXuBGtZawCOc1+wN8vYCCPI2CaGX+muuQ9RSqXjtS3AWgB/tzqjjJSfX7hhG
 s1Z+N8Z6
 RYX34Vh/Gz/uSVD1156HlywxuO/w8GR2UUZ+lRM97W1KFAXHYePoUvMqWTyT585jdRsNRnyo0UITa2dIww5P/xdlSGk54wzLPEzJICIyrNcC23WXlxnRaeIo+88mkYUzFPUDBHVhBLzMa/Kn3ZcLT/YYaRbO7ehMpYnCG0sucZq6srakvwVSAlgk5cZRRzzNIst6SPpIJ0pMDv2+Sf++Id5Rar8Z36Eycr4Vfe5vfRkhW/V5/MTIkO/Uj34+0a2lVfp3IVYz30SvPUxOXm+rDQEtcy1dpG0neUcjc/T2jcH+0e4C4QQiCVOHtVTMV7CKpKa14EM4Jy8VaDNFS+GWHWjDlZhQJ0H3FICVQ9QjoSnaJzS4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have the vma_start_pgoff() helper, update the merge tests to make
use of it for consistency.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 tools/testing/vma/tests/merge.c | 38 ++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index 03b6f9820e0a..f8666a755749 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -118,7 +118,7 @@ static bool test_simple_merge(void)
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x3000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_FLAGS_SAME_MASK(&vma->flags, vma_flags);
 
 	detach_free_vma(vma);
@@ -150,7 +150,7 @@ static bool test_simple_modify(void)
 
 	ASSERT_EQ(vma->vm_start, 0x1000);
 	ASSERT_EQ(vma->vm_end, 0x2000);
-	ASSERT_EQ(vma->vm_pgoff, 1);
+	ASSERT_EQ(vma_start_pgoff(vma), 1);
 
 	/*
 	 * Now walk through the three split VMAs and make sure they are as
@@ -162,7 +162,7 @@ static bool test_simple_modify(void)
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	vma_iter_clear(&vmi);
@@ -171,7 +171,7 @@ static bool test_simple_modify(void)
 
 	ASSERT_EQ(vma->vm_start, 0x1000);
 	ASSERT_EQ(vma->vm_end, 0x2000);
-	ASSERT_EQ(vma->vm_pgoff, 1);
+	ASSERT_EQ(vma_start_pgoff(vma), 1);
 
 	detach_free_vma(vma);
 	vma_iter_clear(&vmi);
@@ -180,7 +180,7 @@ static bool test_simple_modify(void)
 
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
-	ASSERT_EQ(vma->vm_pgoff, 2);
+	ASSERT_EQ(vma_start_pgoff(vma), 2);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -209,7 +209,7 @@ static bool test_simple_expand(void)
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x3000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -231,7 +231,7 @@ static bool test_simple_shrink(void)
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -324,7 +324,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x4000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -343,7 +343,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x5000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -364,7 +364,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
-	ASSERT_EQ(vma->vm_pgoff, 6);
+	ASSERT_EQ(vma_start_pgoff(vma), 6);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -384,7 +384,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x9000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -404,7 +404,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0xa000);
 	ASSERT_EQ(vma->vm_end, 0xc000);
-	ASSERT_EQ(vma->vm_pgoff, 0xa);
+	ASSERT_EQ(vma_start_pgoff(vma), 0xa);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -423,7 +423,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_TRUE(merged);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0xc000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
@@ -443,7 +443,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 		ASSERT_NE(vma, NULL);
 		ASSERT_EQ(vma->vm_start, 0);
 		ASSERT_EQ(vma->vm_end, 0xc000);
-		ASSERT_EQ(vma->vm_pgoff, 0);
+		ASSERT_EQ(vma_start_pgoff(vma), 0);
 		ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 
 		detach_free_vma(vma);
@@ -805,7 +805,7 @@ static bool test_vma_merge_new_with_close(void)
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x5000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_EQ(vma->vm_ops, &vm_ops);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -865,7 +865,7 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vma_next->anon_vma, &dummy_anon_vma);
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
-	ASSERT_EQ(vma->vm_pgoff, 2);
+	ASSERT_EQ(vma_start_pgoff(vma), 2);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_TRUE(vma_write_started(vma_next));
 	ASSERT_EQ(mm.map_count, 2);
@@ -931,7 +931,7 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x7000);
-	ASSERT_EQ(vma->vm_pgoff, 6);
+	ASSERT_EQ(vma_start_pgoff(vma), 6);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -1416,7 +1416,7 @@ static bool test_merge_extend(void)
 	ASSERT_EQ(vma_merge_extend(&vmi, vma, 0x2000), vma);
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x4000);
-	ASSERT_EQ(vma->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma), 0);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
 
@@ -1456,7 +1456,7 @@ static bool test_expand_only_mode(void)
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma->vm_start, 0x3000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
-	ASSERT_EQ(vma->vm_pgoff, 3);
+	ASSERT_EQ(vma_start_pgoff(vma), 3);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(vma_iter_addr(&vmi), 0x3000);
 	vma_assert_attached(vma);
-- 
2.54.0


