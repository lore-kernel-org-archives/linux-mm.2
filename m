Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65A19C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2379F6B00BF; Thu,  6 Aug 2026 16:27:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E77C6B00C1; Thu,  6 Aug 2026 16:27:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AFD66B00C2; Thu,  6 Aug 2026 16:27:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFFB06B00BF
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:27:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 61AA2801E6
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:27:24 +0000 (UTC)
X-FDA: 85071979608.16.39B38F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7ADA6180008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:27:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+NNPTrX;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786048042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+bmGJTDMCDGgU+ycP59x9eyJfos8oUKgJbHiuHs5iEI=;
	b=OvN2bDIAZAjXxlm2lydEcHAz5h+6tLaDFzLL/rM/SbKyYcQwtCSUcATZPo0eyAM9ft6ee8
	RBBiDcnO5F759O8tfkq0A3B1ptM4FTU1PPoucxm73Yf5KvhXA1pLzuC61+PABJ9PCgTRla
	FotlwLY4QU7qrkARwI4LTkjJzeEfMps=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786048042;
	b=hEcS8VjYtFyMh9SK+9HP8lyQVvioRJ5lwO/E9toynNUjKhnDIv9v4INdxq1aygRydX0qxI
	6YVpuQBQYy8A7x4fcOc7e5GEkfh+IOvO7LJNmC15G5NUrrLL37DqiMgH/BWORkBCNzXrBn
	nuiMsysYKdhRyGTpLrFh2Qp7N7gVCak=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+NNPTrX;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B346642B61;
	Thu,  6 Aug 2026 20:27:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657591F00A3A;
	Thu,  6 Aug 2026 20:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786048041;
	bh=+bmGJTDMCDGgU+ycP59x9eyJfos8oUKgJbHiuHs5iEI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m+NNPTrXYV52ReXRkAkJozqce/ofgqcNXdiFJ8bf48VWT9fWmbSj9mdrbvFVP6Mze
	 5V4Gpm8uw8qyu1vqdUoh0pqUlwkCYlo7h88Zz74GtD/A0Mg5wRUxBGZRl0Dxfq0HOF
	 /9ZjhJ1c8UvJByiCHmE/SlyOOHOitRJB7vShFdFMCLwJXS05j/eYt+DYrQrCTc9eER
	 v22ADi/+dhLp+wXva607kppybfenVTPyUghTXdugnksaSSP+/Q9ovmL+1dCzyBn1q4
	 Hraql7+IYYKMqdzL0IOdetrr5PzScbfe5fZi2734HgMBOQ1ZIJTDrBGSygndbprsNv
	 amv6VeCRpMPrQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 06 Aug 2026 21:21:40 +0100
Subject: [PATCH v4 15/20] tools/testing/vma: expand VMA merge tests to
 assert anon pgoff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-scalable-cow-virt-pgoff-v4-15-ab318a350404@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10061; i=ljs@kernel.org;
 h=from:subject:message-id; bh=c33SLNy9lX4ny9o263CYOjSEcyZN/XsrfEsxty/Rydo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJK3lzQ/npIuoyt1HXLA52ED/qC4dd5XzHYKW0XEuE7k
 HIn8FVyRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACYilMLI0LZS/ZSJb4zMLrXa
 H7NvNHdyJLlJrqsTOP10Toe4md6NOkaGOStSu7+n+Ux/vGvrigDXN27zm1nfcrqXiWTmrnfbtWs
 eBwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7ADA6180008
X-Stat-Signature: 3yf9f8juwbkguptpnhnjknudq4ioe9wb
X-Rspam-User: 
X-HE-Tag: 1786048042-773726
X-HE-Meta: U2FsdGVkX1++7RhEmi6XrCSw3CaEmqgqkOr5v0TeNYuSjtNlmaq/Q1TSCwhjvs+xEn0Bn5f/Fc6nstQ6y1vMUGxKBHa3icjriVBOUc63VS4GY9ZjX16/bu2PbLxKZSU5A8lKoBcydEbJ6YzC2HM0g+yIe0vTw0YjHchwVaohQEn/iCB2iNKJX5CoNGKyi9iaWcbkgpopyI+kIRdd/DYHUTqTWaeO0Z1Eqdaq1dzhskpJULv7M8XYudWMpPX092+QSJVg8WFQag81Pqr/KAUKp0OvT8ebuWGVhJwPjTTYOLPxQ617mLsgCpCSYATVBPzvM+jMCZhzIqgxYArGzBFO93SB4QT+AgfLJ9s2XTkbOvGWuSZvWGMc7kpzfP/wvm53x+C5Cojb77bQUAQ8RbsXlkefGTDco+Y+qEXDPuyc6R59XKbzigxmu2F2kPzPWbyrpAYE5cXA2tVGDFftzvEZ9wVwouDmIRjSFn1bftMkjUtA9TN04+s8rUElk062r/2YS/15TsTZiwiqrb4sNl1Bl9o4ftegqKe0vd4KwcSo4EK/WLfrOggwvBwB6TfJoJ7xP1RTRJznRrRpWeaSj4mHJvp4aWFtT7tsbjtR/YIIg+8wKH/QNp3tJOu9LSnNCcWuqIoyViIxyi97EfZ1bsBxcYqNKuDycl4Dyo+riuh6cjB26zk3ZOBC9alpuYlgj7SOVXP9o7VDCG6LQAqtrr9lTqjFs/4CKAmgb8R++PROSg2v64SLvxtpZuMAEZZ2xyVaUIxkMtouztic297qBUMTTXvB8Fi3EjD/UIju7q3wlcd2V0BRYjpG/vzYlMWWivetARjqYmLI1W2mhGLxb2kYLotU885+YtTXffSSnnUIZzTFBrAo+w+wgKitsIUn8jv1DxhnodGxkXkTLfygOryDsrG3MuVnZE4v1sc19Y+NSUYNn9js0bLlaTOTzrlcI9wexd+7XDL98TFa06MJgUs
 ce94AYAL
 7UhzFKO3GL7ciFynBAODqtz8inueffHT0dMrwJh2XhEUPbX4aLmkBK1eUXdsjktRICuwYEknu8lic7Tz3CDByi8Lqs4Lwp1uaq1eytHJPSw5CJVOUzREPEErnUzSmE1yIZ+3MG1g81FPrCd/WmradgB4BeMJ7z9ngQLl2EJsHVRQwNCD9Yr7teDooQo6mtcXRgm1dVVe94QJ/jFrSoHUsWDOEJhRgsEMx9tjL1VFuw6+dedYY4YyaNJA9veBQxi2fKM71P2vnkiKGGPNVIzLKT9XsLW4HsdmYKqTOs1nyoX1wcOwtYYPJp+8XMhv78T7iEuR2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have introduced the VMA anonymous page offset attribute and update
it when VMAs are manipulated, update VMA merge tests to assert that the
anonymous page offset is as expected.

Also update instances where we could use vma_start_pgoff() to do so.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/vma/tests/merge.c | 45 ++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index 48418b82b01d..acaab282939c 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -121,6 +121,7 @@ static bool test_simple_merge(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 	ASSERT_FLAGS_SAME_MASK(&vma->flags, vma_flags);
 
 	detach_free_vma(vma);
@@ -153,6 +154,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0x1000);
 	ASSERT_EQ(vma->vm_end, 0x2000);
 	ASSERT_EQ(vma_start_pgoff(vma), 1);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 1);
 
 	/*
 	 * Now walk through the three split VMAs and make sure they are as
@@ -165,6 +167,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	vma_iter_clear(&vmi);
@@ -174,6 +177,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0x1000);
 	ASSERT_EQ(vma->vm_end, 0x2000);
 	ASSERT_EQ(vma_start_pgoff(vma), 1);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 1);
 
 	detach_free_vma(vma);
 	vma_iter_clear(&vmi);
@@ -183,6 +187,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 2);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 2);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -212,6 +217,7 @@ static bool test_simple_expand(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -234,6 +240,7 @@ static bool test_simple_shrink(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -346,6 +353,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x5000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -367,6 +375,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
 	ASSERT_EQ(vma_start_pgoff(vma), 6);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 6);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -387,6 +396,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x9000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -407,6 +417,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_EQ(vma->vm_start, 0xa000);
 	ASSERT_EQ(vma->vm_end, 0xc000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0xa);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0xa);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -426,6 +437,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0xc000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
@@ -446,6 +458,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 		ASSERT_EQ(vma->vm_start, 0);
 		ASSERT_EQ(vma->vm_end, 0xc000);
 		ASSERT_EQ(vma_start_pgoff(vma), 0);
+		ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 		ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 
 		detach_free_vma(vma);
@@ -642,7 +655,8 @@ static bool test_vma_merge_with_close(void)
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x5000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_prev), 0);
 
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 2);
 
@@ -753,7 +767,8 @@ static bool test_vma_merge_with_close(void)
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x5000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_prev), 0);
 
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 2);
 
@@ -808,6 +823,7 @@ static bool test_vma_merge_new_with_close(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x5000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 	ASSERT_EQ(vma->vm_ops, &vm_ops);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -863,11 +879,13 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_next->vm_start, 0x3000);
 	ASSERT_EQ(vma_next->vm_end, 0x9000);
-	ASSERT_EQ(vma_next->vm_pgoff, 3);
+	ASSERT_EQ(vma_start_pgoff(vma_next), 3);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_next), 3);
 	ASSERT_EQ(vma_next->anon_vma, &dummy_anon_vma);
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 2);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 2);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_TRUE(vma_write_started(vma_next));
 	ASSERT_EQ(mm.map_count, 2);
@@ -897,7 +915,8 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_next->vm_start, 0x2000);
 	ASSERT_EQ(vma_next->vm_end, 0x9000);
-	ASSERT_EQ(vma_next->vm_pgoff, 2);
+	ASSERT_EQ(vma_start_pgoff(vma_next), 2);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_next), 2);
 	ASSERT_EQ(vma_next->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_next));
 	ASSERT_EQ(mm.map_count, 1);
@@ -929,11 +948,13 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x6000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_prev), 0);
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x7000);
 	ASSERT_EQ(vma_start_pgoff(vma), 6);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 6);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -964,7 +985,8 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x7000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_prev), 0);
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_EQ(mm.map_count, 1);
@@ -996,7 +1018,8 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x9000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_prev), 0);
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_EQ(mm.map_count, 1);
@@ -1126,7 +1149,8 @@ static bool test_anon_vma_non_mergeable(void)
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x7000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_prev), 0);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_FALSE(vma_write_started(vma_next));
 
@@ -1157,7 +1181,8 @@ static bool test_anon_vma_non_mergeable(void)
 	ASSERT_EQ(vmg.state, VMA_MERGE_SUCCESS);
 	ASSERT_EQ(vma_prev->vm_start, 0);
 	ASSERT_EQ(vma_prev->vm_end, 0x7000);
-	ASSERT_EQ(vma_prev->vm_pgoff, 0);
+	ASSERT_EQ(vma_start_pgoff(vma_prev), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma_prev), 0);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_FALSE(vma_write_started(vma_next));
 
@@ -1419,6 +1444,7 @@ static bool test_merge_extend(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x4000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 0);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
 
@@ -1459,6 +1485,7 @@ static bool test_expand_only_mode(void)
 	ASSERT_EQ(vma->vm_start, 0x3000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
 	ASSERT_EQ(vma_start_pgoff(vma), 3);
+	ASSERT_EQ(vma_start_anon_pgoff(vma), 3);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(vma_iter_addr(&vmi), 0x3000);
 	vma_assert_attached(vma);

-- 
2.55.0


