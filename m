Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C9FFC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 18:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FCE66B02A6; Thu, 13 Aug 2026 14:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4726B057B; Thu, 13 Aug 2026 14:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB116B057D; Thu, 13 Aug 2026 14:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E785B6B02A6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:09:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 102BB16024A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:34:07 +0000 (UTC)
X-FDA: 85096944534.27.E363548
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 41953160006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:34:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SgK/s4ib";
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786642445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=guTiHCsFNVG67Ttnk4SCPHHfd57LUZl91cPGNyrXtXg=;
	b=COkVoVohnR1Z1Pc2dMUp+8Jq+jMc22Tj+shGrzADRNX3xsnHAgNmkP+OOJJGo1x/tOSypg
	LiaEiBQhngYvlbXxRUIRe/XsHFyvHZuhk2AfiqSThjwGYzdLdbQDgNRCxd7IcKoyvHB5om
	tY1NJY7CxARkq1/Kbe5S+x07kuvrJC8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SgK/s4ib";
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786642445;
	b=NdWexNIRnnuVspASJ/p7gWsJOUfGlMzVWFkgZHHzGgMLceHR96+8bqArNgJfN0LszvIYyR
	N/CwSiJk0+P1SXQ3n693CVQTwVDK1I4IY1/Q4qIr0E56C68xoe6mtzrtVbbSP0qV3AzqLH
	L5yMSh33kLYMV2l8mI0sNE8TZ2c7zUA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6FAD600AF;
	Thu, 13 Aug 2026 17:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A501F00A3A;
	Thu, 13 Aug 2026 17:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786642444;
	bh=guTiHCsFNVG67Ttnk4SCPHHfd57LUZl91cPGNyrXtXg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SgK/s4ibLKzjYPT7hLeXQwQh7ZM1+cr4gLJ9JOd4pcTUc0m/OXFDYZE0rK5Wk4+yp
	 31h2S/hTDIh4N0B2EzJrSYvW2y/4U2LshW8p6Xt5g676OTsfNMaztzJfV6FLu+G3bS
	 m37cOGQtMxnuKYufRhLmRuyCtSdjcrkRomYAzdDEw69NDcwf2PE+8+ytoaUPUxY6tE
	 f8NUWZoVFWcRfebSyF9BSNUobYZsem567XB2Z+WmKIBvr4fFh+KU436lNvtI69CxQ/
	 AMoADn5gyY67bkkypYFrf91VTnOTA9qr/0skHJ1nb5StGhDVc1IeTXhdJkpyW04wML
	 ebAgynBxTPE7A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 13 Aug 2026 18:32:20 +0100
Subject: [PATCH v5 03/16] mm: introduce linear_anon_page_index()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-b4-scalable-cow-virt-pgoff-v5-3-c21581c0c3c8@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5197; i=ljs@kernel.org;
 h=from:subject:message-id; bh=y6jzJtnWVZLf67Htx6t0c40EgHiFxaw6UOaxbttS95s=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJq/69e1nbnifDj9bYaryaZ9Hi+mGUdXCh4T3y/veOmx
 pr85JIHHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhI4TpGhk/+4c8YPnNsnRed
 dcW7TvuYttHbo3slig+L65cKrbtZVsDIcPri3uJLk38cuHLfttB3t03fk7l2i3+1MhdwhgtX7/1
 mzwwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 41953160006
X-Stat-Signature: 3kfoacmaziw4dg9n18hccdz388y6mixu
X-Rspam-User: 
X-HE-Tag: 1786642445-576949
X-HE-Meta: U2FsdGVkX1/O8zzkGCN1MrSSD4EfU+lRo6hlBkC0dijCpjMpmIvlrU4K+VtiSqwK7SD2+qhAp/CLqAIuQ+modx1+Bm76D2lBA1oBkWdGD86KqqCKWPrc6ikd6NXWH9gzHoGWwkJxoafSU4XAU2FWqtl2hdBr15YMGcAvxghdDWQ3aw4zrXoJH088q8p4b1UQjXiFIHSg7P2+orFEOYE9NqHOlJiz9jU5dLyFhrjOF9mlvTXzUpLpI0HKdylIGEtU5bqPk1xM1JFi0Vfah9NJv7eokFMc7C77yV1qq1Ww14iYyRJla3Hx18kYL+u3qPhBexmQ+uArGAwY5NPJ1gkIUgYZHUvxIMDIgL/mruSALmrXgmsXg+GapR/qRG4QjUUuB6qzoI6EaLl7G30Fj9CH1k1jLxiPSTkwwfwpqhsPGPRpkEHqvnqdohzGkBy4Z9aAgIxUvRfVxuHZtAEIuZ3GQPQR71O3gjGJjN4xEJrD29xAlLp1RzeLkK1wyrRvNXQx//BbtgqyJgtNHtF+oFSzNXY0V2hwklakiQoLkuj4A8vTeXSv8ysV8x6vfuGrItirhBqJFYr8iZtmUelYACaiFx9A7NOln8Inw9curCs5T59Ejg2Rczicq2pW/hTMbq+qMzLReKCPpGbKlPDssWOusoRwNS1CjoNLuaHcgBt3en8JlFNi7Dv+evUvbXxaPF+DRU9aqn/nj4V+RUy9llsFrVR37g29KqnX7VB27DTrTnZd5lOdlY71yno6U3oeUaZJBd9K4+jLwYoNc+TIiIvtqYwRC1kR73Ck9JcjrLovQIql3U3Mf2FizQkJ87ytWig34pMZLdAlG0VWYQ9PRUysnWZgmo73bTPnM7TcR/Q7VQSy6m9uL3ZTjCaHOUfQq+AEWLzKoZoKm9FB0G/JzftBde84gQdC+T2D34IP0bq0We9Lpm1GP5fBjaGpiVnqzX8IuC8cHWOTejV5kYRqnX0
 7uZpmmfv
 fzdqJjzNTczZZL12iQUd5Uyjme2XpvSadKCJy4lyM7A2s2Lnoiuv2cmYeQmrMj09z+C0wugPb4Ii07g2k5YFNGHFlcu632YWoGVXmsaQwtqav8mjehaQt2+ivzjb0d7i9qeZz4D9USHFyBDUBx0O//rPsM3l35S8/wYQuRmcw2s9PuqRxj2DcWtLl4vlkJnHzQXqxHrCcM/Bpen9PxwKsi/u9MBX+CBl0JPHuCjAOOhYhkS7C/CXzAMdXzLUfjA/CJzLx5cXZzw62CvqNEudIRjqXXF7XXi3cYi2HfS3bJy992QffvyTgRInUtYGryg5mOD9++wU+0ctbXhc28D3qf3ov84yXirEIl/MjtPqd5PW4d9kGIemTN9t9mUeDoWwQg592C21j79LFBZp+MmlPdZpP5HqUTThS8AMQ/Z/MmJhkodU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function provides the anonymous equivalent of linear_page_index(),
instead offsetting based on the anonymous page offset of the VMA.

It is valid only for anonymous or MAP_PRIVATE file-backed mappings, in
other words CoW mappings.

For pure anon VMAs, this will be equal to linear_page_index().

Assert that both of these invariants are true in linear_anon_page_index()
and implement the algorithm in __linear_anon_page_index().

Note that MAP_PRIVATE-/dev/zero mappings will satisfy vma_is_anonymous()
but not fulfill this invariant, so when asserting this we check
vma->vm_file to account for this.

We do not update callsites yet, so no functional change intended.

Also const-ify vma_is_anonymous() to make it compatible with the
const-ified linear_anon_page_index().

While we're here, update linear_page_index() to be more succinct.

VMA userland tests are also updated accordingly.

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              |  2 +-
 include/linux/pagemap.h         | 40 +++++++++++++++++++++++++++++++++++++---
 tools/testing/vma/include/dup.h | 25 ++++++++++++++++++++++++-
 3 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 199d0a64b14a..0829e0d3b2d1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1556,7 +1556,7 @@ static inline void vma_desc_set_anonymous(struct vm_area_desc *desc)
 	desc->vm_ops = NULL;
 }
 
-static inline bool vma_is_anonymous(struct vm_area_struct *vma)
+static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
 {
 	return !vma->vm_ops;
 }
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index c6fc783aaee5..0adfa6605653 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1094,10 +1094,44 @@ static inline pgoff_t linear_page_delta(const struct vm_area_struct *vma,
 static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
 					const unsigned long address)
 {
-	pgoff_t pgoff;
+	return linear_page_delta(vma, address) + vma_start_pgoff(vma);
+}
+
+static inline pgoff_t __linear_anon_page_index(const struct vm_area_struct *vma,
+		const unsigned long address)
+{
+	return linear_page_delta(vma, address) + vma_start_anon_pgoff(vma);
+}
+
+/**
+ * linear_anon_page_index() - Determine the absolute anonymous page offset of
+ * @address within @vma.
+ * @vma: An anonymous or MAP_PRIVATE file-backed VMA in which @address resides.
+ * @address: The address whose absolute page offset is required.
+ *
+ * This returns the anonymous page offset of @address, which is the page offset
+ * the address possessed at the time the VMA was first faulted.
+ *
+ * For anonymous mappings, this returns the same value as linear_page_index().
+ *
+ * For MAP_PRIVATE file-backed mappings, this returns the anonymous page offset
+ * of @address, which is the page offset the address possessed at the time the
+ * VMA was first faulted.
+ *
+ * It is not valid to call this function for shared file-backed mappings.
+ *
+ * Returns: The absolute anonymous page offset of @address within @vma.
+ */
+static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
+		const unsigned long address)
+{
+	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
+
+	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
+	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
+	if (vma_is_anonymous(vma) && !vma->vm_file)
+		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
 
-	pgoff = linear_page_delta(vma, address);
-	pgoff += vma_start_pgoff(vma);
 	return pgoff;
 }
 
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 40ad83936b28..4c58487b764e 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1428,7 +1428,7 @@ static inline void vma_iter_set(struct vma_iterator *vmi, unsigned long addr)
 	mas_set(&vmi->mas, addr);
 }
 
-static inline bool vma_is_anonymous(struct vm_area_struct *vma)
+static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
 {
 	return !vma->vm_ops;
 }
@@ -1621,3 +1621,26 @@ static inline pgprot_t vma_get_page_prot(const struct vm_area_struct *vma)
 {
 	return vma_flags_to_page_prot(vma->flags);
 }
+
+static inline pgoff_t __linear_anon_page_index(const struct vm_area_struct *vma,
+					       const unsigned long address)
+{
+	pgoff_t pgoff;
+
+	pgoff = linear_page_delta(vma, address);
+	pgoff += vma_start_anon_pgoff(vma);
+	return pgoff;
+}
+
+static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
+		const unsigned long address)
+{
+	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
+
+	VM_WARN_ON_ONCE(!vma_is_cow_mapping(vma));
+	/* Account for MAP_PRIVATE-/dev/zero which is only semi-anonymous. */
+	if (vma_is_anonymous(vma) && !vma->vm_file)
+		VM_WARN_ON_ONCE(pgoff != linear_page_index(vma, address));
+
+	return pgoff;
+}

-- 
2.55.0


