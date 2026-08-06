Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A38AFC5AC82
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AA536B00AD; Thu,  6 Aug 2026 16:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95AB96B00AF; Thu,  6 Aug 2026 16:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823B46B00B0; Thu,  6 Aug 2026 16:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8536B00AD
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:23:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF0C94020B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:23:56 +0000 (UTC)
X-FDA: 85071970872.17.742DA60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id E9DA420007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:23:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MmRVMcEe;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786047835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Nmbnq0r/tdkn7LzRpvbEkYwmsG/p8Yg0FdX7/Lw0rs=;
	b=ph7FViXgGuXLk6O5iAdTFcJXsYqpUHJw8KDA0U9Jn21WGEIha+7WlldzfX1NgOgFTOANRR
	Y8m0YbOavg/5XNIMumSOqtL/IPp9v/0UUY8tJeRafxBkuNx0//fBIXcSdwVI+/4nQn0ZKI
	ICA9e1Jet5+voyqq3oNGelCAwTxUxas=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786047835;
	b=nBrmRe8zS22KPs0Ii9rOkPaWOXuJhPn11RPWwjFJuZ+0/Os8BiBGcf/lJpum4HPJJw8c4P
	vBMeZxdLN1L9VJExVwZxEwNmUvR7+Bpp/ZyBXSnZ2R/DoftKt0s+8lKcC/8XzcpwfD2UkY
	Ch4DftV36xTK9d4vjUskB8PlLBPnOCc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MmRVMcEe;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 345BB43E6C;
	Thu,  6 Aug 2026 20:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47601F00A3A;
	Thu,  6 Aug 2026 20:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786047834;
	bh=7Nmbnq0r/tdkn7LzRpvbEkYwmsG/p8Yg0FdX7/Lw0rs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MmRVMcEeke8BjN31Rb0/r5myJ1BpKgvkvJfkwKHqBm5coJ9gj6rtuhKQ+tC9UB3Ag
	 yiLLYr0VOLFl6xOwI18COwsR+5i8NSN+kzUzrcrvBRVpFwpdrZ++efgxEfNe+RlrSG
	 /cd+OJHUGUZOb0HJ194nrElF/EGJe4HtJ3N+XGk69H7fTMYtlVuTBUBEYH2A+bziNd
	 B04HmW6LylmuwA6SwXA80N2i4S+JyUblqvN34SlHE6XUbK7DvgRisD25b1gKvUWkRq
	 ywkUAyOSQO7kX5DoyqY1/dW/DMHAbovwCV2uYSh1uoOfPFcEO+uGbAWdA8JjzpYQDR
	 N91T4jABgdjIQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 06 Aug 2026 21:21:30 +0100
Subject: [PATCH v4 05/20] mm: update print_bad_page_map() to show anon
 index if appropriate
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-b4-scalable-cow-virt-pgoff-v4-5-ab318a350404@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2529; i=ljs@kernel.org;
 h=from:subject:message-id; bh=n0kfl3sX7UAIKHIjCWNuf6tCoy4kVBTkNam6LpgmDSU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJK3px//F1mabFgwLH5d36tUp/vuOde9fP0mn/Pz7aus
 T/btlqpq6OUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATEVjE8E9xhfb8e4cF1/75
 uV9j7q7QY580ff+/Fbq5ZW8sh+O1Qu/bDP+r0zsiF9z+q3Tq0YsL8oKHF3POfxV4RDBgWZDckXZ
 byd2MAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E9DA420007
X-Stat-Signature: ukn4ttf144d74mq8hroku91jumx3kek3
X-Rspam-User: 
X-HE-Tag: 1786047834-255361
X-HE-Meta: U2FsdGVkX1/0mR4lQW0LaWZyGRmkPYMoGc7/QF/FFP9fpDlh7Cf8UFyE6lcHzvVd4C4dODmnf+49Wf/SNFpjkfICy4a1Q29OvADLDvonwBbRGgi5oOYT0VFM8JzC0dluk/L05NF2smqbhOORsvmu2cVHmEvG335dar1c0Naqgj6RlWMBim12FOx06I+Soa54a7zDfS8RhfVB8mJKcEy4TDfG66MdqV15Am722t2h/94SCh31t0eNqJCewcBbbMPBQxF3AzkeDOf0tXzpIjhZcik5w/tjCKuxZStiwmtd/QfYmV3iYqL7T74FyDq/n6AWEI4lkL7tT5RD+PrLbz9f0HB9J8ukXyt2QtaG8NG3WJogTcDhg2bM7ssB8tLV/HMD2HKi6icHEwCIxl5QXoPpcKnUuIlswJ5kLLBo+OlxgONKbTeJHb8zstCPooz6jcjbJXjexsTsuqiLoGr9O8EhiTcrYnnkmkDudCKrPPBVggYSl4hAWgb4lxtXM9E0rUBX46Ilb8zt5e1afjPPl+Xf/oTdvfld/jJZ2PlOparjGySxrTt19irAL22sVUVW97wMa7dSAgzJy5p8NwflRc3WG4OsQ+DPpFqJWCV7VcIlCF9CohHxJbB3mEL5Iwv0fR3InXITJIOqSE0dh57aWLdZrVcozmwMEMnXyk6sU5btJZRO9tNe2pnLZs4nlHoPd7MPYDXJ7glK7L4D5y5H4KGfHo733CV0vPnsEwAWaE4W4hikBO+Y+OLyTAxfm1HEJL71Vlo9WkQqQBOr7OTmDq5Ud/85pocimNBLE3WpSQYpM2/H4Y6QxP05xH0MHQIN1Uhx8iqYP9f+N4mHJu1pka9m/pEhnFmf+1nhXtmZZRq6S1G02Q6Ct/rNh57SQ2fyEwbQ0Nq2BZBEM1v9tuD8soZJgfgtLSPBkj2xk6fqQS3xB7xRsGf4c2MVteIyufWIQ0Khw+rgubZNwpFNVd8/+v8
 IzmpGEdf
 zGVz/NEMbKLOin5yiFc++/mCGs+zvPkzMacSs2/BlTqwvIn2j+PTy+XX2b4VG9tZ0szjb4InqL9GNSswTiJNY5RlKu9J0EL4XxLenn7N3ARucZQ63s2QBUi3FTLQUJXa9XyM6GxBagvPqK1yrWpvkbxZn1NVxN7fF/eVFJpmfqAsp8BoOSvWlFstkAfraiW/WGzhOYEaAyLqNS4f+13ihD6SD99rKsnH5WmA5Mg8gqDU4n+OTPgXY2XvsQr1SwGsRHkNMaixxUE4zQZIvx+D0BTHxZINv/4hJSKfBu0Jh43H6VSUOslzV7Rsu0OcUuSetElo3i9L8ptA9zvIg+P58JI5muxIHrNSxmLD4uZET1icxjqZB+olr3uTuDE3r5wXIktMZROCq2aXK0U+K2vccV2+VqqwSJNEPNlIZasjMP40LcEM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the VMA is a CoW mapping page offset may differ from anon page offset,
indicating different positions in the relevant rmap trees.

Update print_bad_page_map() to reflect that - if the mapping is non-CoW or
the indexes match, then output only one index as before, otherwise output
both with (file) or (anon) suffixes to reflect which is which.

It's not possible to give only one index as there is no folio available to
perform folio_test_anon() upon (the page table entry is bad so this is
unavailable).

This is potentially useful debugging information and matches the existing
page offset provided.

Use the raw __linear_anon_page_index() function so as to always output this
value regardless of whether the mapping is file-backed or not and to avoid
asserts that shouldn't apply here.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/memory.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index e1349e18f046..3bd3616b27d2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -631,13 +631,14 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 {
 	struct address_space *mapping;
 	char entry_str[PTVAL_STR_MAX];
-	pgoff_t index;
+	pgoff_t index, anon_index;
 
 	if (is_bad_page_map_ratelimited())
 		return;
 
 	mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 	index = linear_page_index(vma, addr);
+	anon_index = __linear_anon_page_index(vma, addr);
 
 	ptval_bytes_to_hex_str(entry_str, sizeof(entry_str), entry, entry_size);
 	pr_alert("BUG: Bad page map in process %s  %s:%s", current->comm,
@@ -645,8 +646,14 @@ static void print_bad_page_map(struct vm_area_struct *vma,
 	__print_bad_page_map_pgtable(vma->vm_mm, addr);
 	if (page)
 		dump_page(page, "bad page map");
-	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px index:%lx\n",
-		 (void *)addr, vma->vm_flags, vma->anon_vma, mapping, index);
+	pr_alert("addr:%px vm_flags:%08lx anon_vma:%px mapping:%px",
+		 (void *)addr, vma->vm_flags, vma->anon_vma, mapping);
+	if (!vma_is_cow_mapping(vma) || index == anon_index) {
+		pr_cont(" index:%lx\n", index);
+	} else {
+		pr_cont(" index:%lx (file) %lx (anon)\n", index, anon_index);
+	}
+
 	pr_alert("file:%pD fault:%ps mmap:%ps mmap_prepare: %ps read_folio:%ps\n",
 		 vma->vm_file,
 		 vma->vm_ops ? vma->vm_ops->fault : NULL,

-- 
2.55.0


