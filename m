Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ADADC5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 18:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9D76B0580; Thu, 13 Aug 2026 14:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD08C6B0582; Thu, 13 Aug 2026 14:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6826B0581; Thu, 13 Aug 2026 14:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A00516B057E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:09:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7FD3DC0239
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:34:27 +0000 (UTC)
X-FDA: 85096945374.05.33C91ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A69691C0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:34:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YugjBca5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786642465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GlrT7r3tcep46r6Il05ij5JS2SxeagPngYBWHI1YDNw=;
	b=JgwqJj+MCu5uCLfZpGumGKGXj3Oyk0YfZ/PBDqZ3blBwZhck2otALXXxxyjW4ZnpxMjkeF
	yCGHmL8OwHDR9XrBcM19MtF7Dm/7OTkfN9yZOI8jxNPySZKUhTGPs1OtaTdRVRRHYQjXeD
	ZbTt2naQkUFa/FDa3z8gvqV0ZlMrNtU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YugjBca5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786642465;
	b=mIMuYMH0dCnL27PC2Tqsxfq/YNzG/XE9U7i44meIGlrDWglJNwufNLYzOTDvPIAKIIxELi
	XVvD4R6OCC0UbT2vBVf+D/Hn4uDHgZMXFXrq1XrH4gJaSGAT+S5VagYVpJF2jTkQlohbpX
	VsTVOULqdkvHjqyO4N3lKpb/rBru1+g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8E8541959;
	Thu, 13 Aug 2026 17:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8B21F000E9;
	Thu, 13 Aug 2026 17:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786642464;
	bh=GlrT7r3tcep46r6Il05ij5JS2SxeagPngYBWHI1YDNw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YugjBca5WND+n3QaqWYkEL7gPewL8hAiL78fU5MbiGSIG6TMa9V7N1Od8KlaB1Zm0
	 EANGb2/0A0U2107blNX9VfRctXD15pC7sEti0k/dEIk4q3cg/HdHZeU2CHMchhYRJM
	 7C7Yjv17+AeCZvJvWcSCmGT5AO5lEZpFqT8zQkSb6rmu/qb7PglulSmb7q+y1sd+r1
	 X6SGHj1oJm7HLJULbGdHvPcRFKZR4cxfRBtHEwS8mBCQEYMK3isfql/LsTOtFirYte
	 vqbd6POdg05Jn8DcGcoQJcCf/SW0NMBpmw0SqMWB+8vzrZLSOvjw36Akp2jBAQYqJf
	 ufZdjAYY63PwA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 13 Aug 2026 18:32:21 +0100
Subject: [PATCH v5 04/16] mm: abstract vma_address() and introduce
 vma_anon_address()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-b4-scalable-cow-virt-pgoff-v5-4-c21581c0c3c8@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3692; i=ljs@kernel.org;
 h=from:subject:message-id; bh=TcLlQnmra6maBGHXmsGw4bE6RvgdQMZRWpLIfm3Ze4w=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJq/6/Wbt46vb61rk04ZfEGqcDu4L8/E0LvvuMzL/xVq
 3/hyX/NjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEyEM5GRYUqZfbsf1/frl++u
 L6lOUQ8prt7EaHKgzWrNmVxm5XjGJwz/HVSi7nZ7qYt8ljy/X7hmVt0Ug/0513/13qkWT1h332o
 xMwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: A69691C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: njhwugqj5hea3rjdm6hkq39gz1q6ohnp
X-HE-Tag: 1786642465-201152
X-HE-Meta: U2FsdGVkX1+tBZ/8x/KGIGezFpaDBZt77jh2EVDi6ppPTMkKdsBUr5kdFVCtioap9QhzubpBIujbGA1fzneS4iefaV9Nz+RvrnUAe3rbCt9b8hYVR/KbWvJ3RP2fLD/ahPyMqPVVR5JuzO+n61uWBwuhycilVy7q8LHm6rRBDKgDGO1AVdQnWqN7mAt70JKMy2Ph9gRZKxNo60SSV2pNDqcsxoJC9qsIeWHu+SOF/oq1GWmGBzI+yzEgkDkwlBERxCh9a0LyaC5z+9nTN+QiTp2J7AQrqmlMod4QWX71ASH078Ur+XeNWRVN7dixracWUbZhGvNHH3VIwrlpOXBsrYDf62DzPTaqfzI3ZqXK/akD9ncCMUc+H63TCbyAfNz/rxp9y8+8/dHcI7N0Yw8xRLgzjTWL3om0cp0NyX7zzZ2NSfLmzLVx0neI9oqOu8Wsy9Pwj242Qc3FnI+/mlQa7fWlVfmHMZm/nlu8PkDp0GYTXWU2Dr7qxlepjwoQFHnoohB1xBjaLsUET4V5fHVvzlDNkqdcvOdnEI/fHwB0O4Ola7CTBF4ewYMOHfrdFdt/UzuYlegDEE1j1NWkc83fpjji3SIQgpHb75nR/S7eAlUOC/WxLvTKV7/WDPl8M/zmWC8heHAHpXXRbJUnKcyRk6oYLred/UtAix3sE3UjRgxW5WsDCt0NG2Tv846dD53NssGzCy+FV8XyguNWEHtFO9ldJ/WsDeICdOmeJKicY9/XnTWokB2aCcsvNndUJ665Aq0/2hYQHW2sPaXK+H381Xq7Fps72Vdc/OA3tbCzrtYB1A4XHMduGINLZI79BVodwXsybHBUJupL06jIgHDXtb7A9s9FPYfiRLgYhK9iIUY7V4epX63Nplzp3XaaAzTL9imJdm0Oa5PCfCqHWuhlEOOIVgDqrvHZ8vGEmpB4d99r6yIIcPCy+uyarjbCifp4XsO9e2W4TVPmW3+po+u
 LSUPXpku
 hJvhyqYRN/pKK33Ta2nowy4ZB2G90ncDknmfrjkOl4YACM2BbXDg5GmGrdAbdBw11P93fFNuwGsPu74LhG1bkYgiTMOqOcuz2/csDs57+plKOMiEqLkDjcSpwr/PLzzIq7pQhNEQjHdsSS4Cunj+OYfWMhT5/4zfyjJMnT8d5aEhi2PmWnH5FqGuHEDBRiBFTGvTZ7mNLL0Do+rOGNxI7h5+Qg6QVVT7vPLlE2B7KhqL1a7RNxTCHg7WAXqZP7sFldj7EA10wv8jcl53LaXI4XbHtvbGsurZQoNdr87yKdPZl//06+R5HaKN0i9b0FSQ5smMmPCzusN9dWbdJ6qTY9tgLO7nIK8M/3BFrUcZGppezPKVeW91mxl/XEX2AlbGuykrX7gkDLglw7PJISvAvGWuY5n3pBlXRvzz1IqHcaZtb7Upy1NsOcfIOzA+7l+Pw8pv4j81fMR+Fqs7h/ya5SaCqX9EuFkW+hFffNedx6nq3k7Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce __vma_address() which abstracts the VMA start page offset field
as pgoff_start, then update vma_address() to use it.

Then introduce vma_anon_address() which does the equivalent of
vma_address(), only using the anonymous page offset of the VMA rather than
the file-backed one.

Also add an assert to ensure that the function is not called for mappings
which are file-backed but not MAP_PRIVATE to ensure it is only used in the
correct places.

This will be necessary for determining the address of a folio's index
within a VMA when the folio belongs to a MAP_PRIVATE file-backed VMA but
has been CoW'd, and thus is anonymous, once the anonymous VMA page offset
field is used for the reverse mapping.

No callers are updated, so no functional change intended.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h | 49 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index a75a1344e9ba..10b6662be8ed 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1005,19 +1005,9 @@ void mlock_drain_remote(int cpu);
 
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
-/**
- * vma_address - Find the virtual address a page range is mapped at
- * @vma: The vma which maps this object.
- * @pgoff: The page offset within its object.
- * @nr_pages: The number of pages to consider.
- *
- * If any page in this range is mapped by this VMA, return the first address
- * where any of these pages appear.  Otherwise, return -EFAULT.
- */
-static inline unsigned long vma_address(const struct vm_area_struct *vma,
-		pgoff_t pgoff, unsigned long nr_pages)
+static inline unsigned long __vma_address(const struct vm_area_struct *vma,
+		pgoff_t pgoff, pgoff_t pgoff_start, unsigned long nr_pages)
 {
-	const pgoff_t pgoff_start = vma_start_pgoff(vma);
 	unsigned long address;
 
 	if (pgoff >= pgoff_start) {
@@ -1035,6 +1025,41 @@ static inline unsigned long vma_address(const struct vm_area_struct *vma,
 	return address;
 }
 
+/**
+ * vma_address - Find the virtual address a page range is mapped at.
+ * @vma: The vma which maps this object.
+ * @pgoff: The page offset within its object.
+ * @nr_pages: The number of pages to consider.
+ *
+ * If any page in this range is mapped by this VMA, return the first address
+ * where any of these pages appear.  Otherwise, return -EFAULT.
+ */
+static inline unsigned long vma_address(const struct vm_area_struct *vma,
+		pgoff_t pgoff, unsigned long nr_pages)
+{
+	return __vma_address(vma, pgoff, vma_start_pgoff(vma), nr_pages);
+}
+
+/**
+ * vma_anon_address - Find the address an anonymous folio with index @pgoff_anon
+ * is mapped at.
+ * @vma: The vma which maps this object.
+ * @pgoff_anon: The anonymous page index belonging to the folio.
+ * @nr_pages: The number of pages to consider.
+ *
+ * This is only valid for anonymous or MAP_PRIVATE-mapped file-backed VMAs.
+ *
+ * Returns: If any page in this range is mapped by this VMA, return the first
+ * address where any of these pages appear. Otherwise, return -EFAULT.
+ */
+static inline unsigned long vma_anon_address(const struct vm_area_struct *vma,
+		pgoff_t pgoff_anon, unsigned long nr_pages)
+{
+	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
+
+	return __vma_address(vma, pgoff_anon, vma_start_anon_pgoff(vma), nr_pages);
+}
+
 /*
  * Then at what user virtual address will none of the range be found in vma?
  * Assumes that vma_address() already returned a good starting address.

-- 
2.55.0


