Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F36EC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 17:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB746B02B5; Thu, 13 Aug 2026 13:53:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37B206B02B6; Thu, 13 Aug 2026 13:53:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4CA6B02B7; Thu, 13 Aug 2026 13:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC0526B02B5
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:52:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D943A1A0248
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:35:48 +0000 (UTC)
X-FDA: 85096948776.30.63F75DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0ACDA1A000F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:35:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PkmLlMyr;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786642547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7idCKxvuxc1VD3/Y+D8HZ1eKufEBlsCtRsBSzrHM2Y=;
	b=U2NXXg7OxEEbRBh2KfApHKwW15dB7N8V4xk8P9pFTU64EAI0Vj/56IwQEGTe8zNWgxJY8z
	8jHsEKplPpMD4SrUUWYY/y1sWtwiR8Fk24R+4mJll4xsmBZGcEz5HL5q/vftCnBz3179Wu
	YeBpW9N7/b+XRwOahwhVon4+n1cyxqY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PkmLlMyr;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786642547;
	b=dU7gCopmZ7HneLq8no0RLCyt+Ey627SEX64db3RoDGLQpJRqfX3TfXuWbILkVWjflP6Z5a
	8Lc6CECl44ATR/lq0nuT6gm+yCwFlVtKJa9JVHr3fhW2PpC/0NI+roLGnjwYZdZDGGEaMI
	pZ/U2K2iGa7TA+lNmnAn/1Akq93iGsw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 85399600AF;
	Thu, 13 Aug 2026 17:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4661F000E9;
	Thu, 13 Aug 2026 17:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786642546;
	bh=e7idCKxvuxc1VD3/Y+D8HZ1eKufEBlsCtRsBSzrHM2Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PkmLlMyrsX2m5fanA2c5rpxa/EifX3xwSAX8xxMpwcWxhpca2+mz8b35ptW4+WUVm
	 z5Jv6LMlKfeILZji0OtaDQxFCCuYwYZKqz/fII4SzWAm8mnDZXWbA+khF9g338T4J5
	 iOjn02HhY5DO7GFnYnzbPjLi98OSMn6LpTiXqX9llMaiiS12b12txoGGobH8Gmhl8J
	 bgk0Umr5fyJRavOes1pEb0n1WbIsDmOsjkxuME1WI6oPzyciES452Tf3RI3jr3YGo9
	 ivCA7S0VWHHo22BAdkUUVcxX8wBXPSxScIu20TJaK4Zg4SXT7cznU5Tr4mK24yPlsf
	 esvmH+OknqRBQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 13 Aug 2026 18:32:25 +0100
Subject: [PATCH v5 08/16] tools/testing/vma: add tests for copy_vma()
 self-merge
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-b4-scalable-cow-virt-pgoff-v5-8-c21581c0c3c8@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2596; i=ljs@kernel.org;
 h=from:subject:message-id; bh=0z311QDVDbRkLzxpR827T28yvRS4ZLJp7flLC+XA2kc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJq/69Z1VT5fCvv9WieeoYZE4xYRd0e5rmd/HaXyaCjr
 b07ME22o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABNR6mJk+HCb/2br05jeXX67
 rD18dnZHCr6eJ7+M+Uf/ovddiaw/chgZjjKwZfxl+8Z1YvPXU3t1Djz67nk4X3rWBO7UMzaPco1
 U+QE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0ACDA1A000F
X-Stat-Signature: 9yfgimq5twz9pkjnfa9hpakj4ztmamib
X-Rspam-User: 
X-HE-Tag: 1786642546-661651
X-HE-Meta: U2FsdGVkX18KTReAkm8+4HWE7Ip4e6wbuWxKZLez3B9tU/KifFivit0hTG24d6+Y9JAx+vBFPqp11+bR+FVt+H0EG1ndiAdRtnC/KtFk+a4wdW79rfHgUdvlg30k3LKhp2C6/x2a5gE8/frwkC9dcaXc7KE0loDNj58Lp7x7tlKGREViGNV1KQtgwIOGWe3TmV1otKlnnFLJkz3GsSZX8NvWn/V7+nOxHYAiPktDl/TIs4MkbPwDfNyJVzVZQdxU77lcCNyQTtNrH+C23BDztMDqHgqJN0dusHK8b7bXzL/DpDWxYD/RaT4j0q5MIrY6FuMgNkhPFsqfi2qwzHF9lDj99oiV7J6RJ6d48n0lS172XuJmfzVhz14E47l+b8mitB5xUDgbynFoCIaVa6QVFAnNFEQVEQCi9fSHYIVopzEEt5nE3mUbkXiTTq3nlWKV/AGY3V0tpZ7VCAlddrlFghB/TPJFx4lsByN/83uADzjmMj/H0IaR8KehdTGL0y/nLdjS9jJ9EaVrTivtBIwkTP3T4tfsBNlSoQRwqz88kf7EOgJpUSh980oGJUALYj5TCQX0Y4T+nRfqlnU8avF5/BCUX1zCc0imlLKZcW+yt0uSgLc3H6ySsn6C0JiYmvsSBXdEoPYUy/ah9Aw7+HseS3NX3TVLNW4/kYx8ZyVLxloQqrgcd4zRciuuX7Tx96cQaJ0tFxPgSoqHV+V2qdeFfvbDwh49TdXcoGleVaJsD07RkrSmgryZLVMklvUuBljwGwqkiiQISERl5Lml7SEEi5Z7XzD1RD7QLp1fsMS838oF+3B37mPUM/fwVlOxLUQrKj1bnag7Gb0KnM2DhckpeXoTZeDocEFuaxBzYTueksng96yzs3BfocVnFPLKXFZQkELy84CEEuYGvyhWzMSoG3jF4TGzzwAXLNQn8+itg6ZmnTHWy/GAD04m/44cAF/b0PgZzIBDL6ujbyK4pus
 qd/Doykr
 PNs7Grz6W3YI4l+ke5FHETFyGNadVSYJq0f9MetQSGSvXVceVYTxf8yG1tvCUFI1mgpJsNNiQSurPR7iznINzP1jNZQMAD0Sz/RrVRCd26/zen/enuftM5kHqhEvPMh5px5dhlxT7kdDnU42J3u5a5eFJ7UBrEBSfPyhQ+7ZWlBDpnnN8UeC8pG6NIdBxXpwNZR+NTI9PdOzkpa7luwFmZf/pB8IqI2rnb+t//MmWvrTINnlU86QDdAPl8maJsZYqcV3kXrfnCzhWuOo6tEk1y86rrX1Uzh5xBL/SAatNY3TwGHFzuKu99Ls45VINUUBWB0e39dqLBpOUBVRqWruRjeuuDIczFcO6cnXajC2gOTu9Mjs=
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

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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


