Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A52DD2FEDA
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75D66B00B3; Wed, 28 Jan 2026 08:57:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C53E26B00B5; Wed, 28 Jan 2026 08:57:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5FEB6B00B6; Wed, 28 Jan 2026 08:57:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A6DFF6B00B3
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:57:24 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 780AB58A8C
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:57:24 +0000 (UTC)
X-FDA: 84381524808.17.5E1DABA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4FF461C0004
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:57:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TVdZsNmo;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZaBLJBmhdtK5AWTlqZvPeYcLY/m8rcAD9TYtu6o61E=;
	b=s53GJyVrM++RdbiCH4WSZb2n7/BQbzeRbkX1ncd/7yk+SgGo2A2aChX3ykDpqB2zRkDQm4
	YwWu1Ug5gssYETOeJ/43wc9/ZZY+EUn2GAMCV/iyiLavEqCbH7oFrF+7dxQmNc9cpM2nOZ
	ZftqEsHDRrb6R4QmpfS+1b+SIzM8Xl0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TVdZsNmo;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608642; a=rsa-sha256;
	cv=none;
	b=xaJJk5sbfRklubpx5si2gHENOrfPc3Aog+3NDXM4HBz1fULVDgrvP5clEZ6tfUxFW7IeOq
	ij+caddOWyczEbpGcR/I592Y/ywy1nEnP8zNzGUXWYjvwxmq95bmMLXkSfl+M2ZLPFyiZB
	feuQu2yDZTMNPZKVYOvc3WxjfYr6c5M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 86F8140398;
	Wed, 28 Jan 2026 13:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79C9C4AF0B;
	Wed, 28 Jan 2026 13:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608641;
	bh=X0JuAHEku0e+NeEYY+UFCEJtQB+xpNwKPHNJM8wJov0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVdZsNmoL5BDvfDib1ByKMQ23FPRuJwZ1SYB3BSvYZbdU6sPP+mgBmfs1py9+1OFb
	 8A8i2kCHtaQtZnxu6G5ZVXRhwU+KDFqsBUuG5cnYuM2TTM1NEgn+ISXgqskqaYuvrs
	 gDksJ6dG0qfglxlYgq3UVMw25Da4Md9VWqSM9SZkA4mBMLMw0taA7mKq1Bo7RUd+Gt
	 A84MD6J25DyTAKby9oMNQVZZTW+lwgRRKOq9C7MlWXGoI1Ne6rBxMV7aOk34AlD4Yd
	 oAceaKemyqBuv/0C9NgIHjmGU5OQRV/UdJloCKrUbVbvcrai54Y0U636QLdaFQLdwS
	 TIrf37NfTwBCA==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id DEFA6F40068;
	Wed, 28 Jan 2026 08:57:19 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Wed, 28 Jan 2026 08:57:19 -0500
X-ME-Sender: <xms:vxV6ackXI0kJ5Mw7Ck7kcobN_VFv8lFnAFHIz89QEvmkLUry7leHZg>
    <xme:vxV6aVDATDYSqL116tCpGxKENDNQqmG1GNKskpiHsUBuRJDcRxxlxtly4ryawPb5O
    JGPOpzyppkgZvZN9Y3VrIimwxfYuuo1snwC7GtM2Y9e85Abah00Bv4>
X-ME-Received: <xmr:vxV6aUyj47qgvwqhH--Y5GDDgxGvHXZGxkbhUGMBaXPPxQeF117lo1kJPNVJgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieefheehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhggtgfgsehtkeertdertdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeffkefffedugfeiudejheefleehteevtefgvefhveetheehkefhjeefhefgleej
    veenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhi
    ugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrug
    drohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdp
    rhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvh
    grughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:vxV6aZci1sbEABSqv5P8PwrtZFYY685kGLzvFKR7XxqtHHJ8Q5pG3g>
    <xmx:vxV6aWxOL8awV1kFFguQSF3L1GViFfatZnEgz3D7qyUvLjPTuhSUkQ>
    <xmx:vxV6ab7vdFLpHOW5AAGoRzJU6y072B6MQUtMHziSpu8-Cz0NsBFWHg>
    <xmx:vxV6abwvvB7cg93HAxwVTcZ_ami6kHGDqNPoDHnYU0eDwP79OcgwBQ>
    <xmx:vxV6aTYbW6DYm3pAlXXksewhrGAw7g4B7fhqOQerFogPjBnSVpTL7xAf>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:57:17 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv5 16/17] hugetlb: Update vmemmap_dedup.rst
Date: Wed, 28 Jan 2026 13:54:57 +0000
Message-ID: <20260128135500.22121-17-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260128135500.22121-1-kas@kernel.org>
References: <20260128135500.22121-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FF461C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: qqgo7gufusoqu8seaeitpha8j1ubkyws
X-HE-Tag: 1769608642-256394
X-HE-Meta: U2FsdGVkX19V7XOM9tHa3a2sNyynt536FOJ3SPN/O4AcABF+R2k/4Wsms+qn8GzWzdVNXXwDX5hmfTdG0HyUoxEmRaHLNcFYFff9zPIOD0Wr8+VOldqvkcFckQWG56KtYa3FwflKK6VUxPE0VGzXZdM688NX3Z4bSlvgnl12jPZBnWU5Hx+YReAU7BxiGi7USZSE1/Sz1GzvSnWAluyBhocFz0EElQnxl+40OcjiNyFhbvew0OF695G4TiTpHN+BgwRJQnQ8fHYskpUx64Ie7cP7mg3jHUfHHqnFqLdF3VrYp9BAG3yIzU9/lh7H0X6Goce0W1kope5oXY0yPoCh0nany0a34IkvWOBHr5mjJcRMkj5l2ttjb9PcjUShkfyMEeu/lrXnqexkehaQGO33GjHzhumq+u1J9eunGtu1pMWa7krewl8Smgy3d1OG/Bj1i+TmeX8wK9MAHJCrRD5+gEVg6ISjYLlZbb+25ZhEEZZH7ukzpn2Q1x2NSCa+bqtdKhp0inu5ew05HuFcOQFiJEF3g/rUIYHXqCCZTnLPQmKhRJwYYbzb4AFHe0EJYIgJ8cz5ETe9obRLQ+Rnrwrp0UlBTouGK/y+gmEoKTmmBl7ot/3V8sf3PExnnDgsN4+6jVETCKhhg3UDd1YfghE8lwdu518FVD0R0n+uqLhaHXreDVQinq9I3jJImqHMTa7lOqzsn7S4ORtRDAQcwSc235iPr3XZX7B5Fce3YhAVQgeu7SOZjLuswcpaDdENQbM5EGuAZ7yhHnB+9bkrvLH7tuVaEWsmBRo98mnmcVE3hFQr+XVLgvsWdiSL+xfoBpWegfw1BKLKU+8FmkkznFU1l8z5I0mkzOa9oe72ESIv1UFhSl6yS4WCPSFWbnsHe7gxu38fyEqfVHy9iEuc4u6lommUaUHuw2T8UWJslGuK/SjS69NFUmUP3dmT3wBa3NzLcKv2iu9sdOEB28a3IN+
 NAi8JDL5
 gDrlqJsxpyCZy/jqmruIxfSjZtdsDY/2XuEW2r5cM6o8gQp6UXxIlh34PqAzhZdHva4CjCNxP3csgHXsYBzqV/IFwNWqVMfAnviQ3MC1WyO0CDglrre+zz+fL5jg2aT3VnxtwyPh/MkRDSdQEXRHZ/XTPpo/tEZ/Q9maPFjYbgOZwrhvtt3B4/Yj229rRJFg7XQnCg9LsPCFLW5roS+vw0cR4BdJvaXH9ZyuZbX3+8ol6bEjrat1/2wzfso4bqWqiGJ5yALN++0+z4puZuP61sYoHFOfI4Zgh1SSt29r4IffFRcKq++6usqg8R+unAWnaK0A68U7pZivf1cuGWj/Ly5D4mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the documentation regarding vmemmap optimization for hugetlb to
reflect the changes in how the kernel maps the tail pages.

Fake heads no longer exist. Remove their description.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 Documentation/mm/vmemmap_dedup.rst | 60 +++++++++++++-----------------
 1 file changed, 26 insertions(+), 34 deletions(-)

diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
index 1863d88d2dcb..fca9d0ce282a 100644
--- a/Documentation/mm/vmemmap_dedup.rst
+++ b/Documentation/mm/vmemmap_dedup.rst
@@ -124,33 +124,35 @@ Here is how things look before optimization::
  |           |
  +-----------+
 
-The value of page->compound_info is the same for all tail pages. The first
-page of ``struct page`` (page 0) associated with the HugeTLB page contains the 4
-``struct page`` necessary to describe the HugeTLB. The only use of the remaining
-pages of ``struct page`` (page 1 to page 7) is to point to page->compound_info.
-Therefore, we can remap pages 1 to 7 to page 0. Only 1 page of ``struct page``
-will be used for each HugeTLB page. This will allow us to free the remaining
-7 pages to the buddy allocator.
+The first page of ``struct page`` (page 0) associated with the HugeTLB page
+contains the 4 ``struct page`` necessary to describe the HugeTLB. The remaining
+pages of ``struct page`` (page 1 to page 7) are tail pages.
+
+The optimization is only applied when the size of the struct page is a power-of-2
+In this case, all tail pages of the same order are identical. See
+compound_head(). This allows us to remap the tail pages of the vmemmap to a
+shared, read-only page. The head page is also remapped to a new page. This
+allows the original vmemmap pages to be freed.
 
 Here is how things look after remapping::
 
-    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
- +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
- |           |                     |     0     | -------------> |     0     |
- |           |                     +-----------+                +-----------+
- |           |                     |     1     | ---------------^ ^ ^ ^ ^ ^ ^
- |           |                     +-----------+                  | | | | | |
- |           |                     |     2     | -----------------+ | | | | |
- |           |                     +-----------+                    | | | | |
- |           |                     |     3     | -------------------+ | | | |
- |           |                     +-----------+                      | | | |
- |           |                     |     4     | ---------------------+ | | |
- |    PMD    |                     +-----------+                        | | |
- |   level   |                     |     5     | -----------------------+ | |
- |  mapping  |                     +-----------+                          | |
- |           |                     |     6     | -------------------------+ |
- |           |                     +-----------+                            |
- |           |                     |     7     | ---------------------------+
+    HugeTLB                  struct pages(8 pages)                 page frame
+ +-----------+ ---virt_to_page---> +-----------+   mapping to   +----------------+
+ |           |                     |     0     | -------------> |       0        |
+ |           |                     +-----------+                +----------------+
+ |           |                     |     1     | ------┐
+ |           |                     +-----------+       |
+ |           |                     |     2     | ------┼        +----------------------------+
+ |           |                     +-----------+       |        | A single, per-node page    |
+ |           |                     |     3     | ------┼------> | frame shared among all     |
+ |           |                     +-----------+       |        | hugepages of the same size |
+ |           |                     |     4     | ------┼        +----------------------------+
+ |           |                     +-----------+       |
+ |           |                     |     5     | ------┼
+ |    PMD    |                     +-----------+       |
+ |   level   |                     |     6     | ------┼
+ |  mapping  |                     +-----------+       |
+ |           |                     |     7     | ------┘
  |           |                     +-----------+
  |           |
  |           |
@@ -172,16 +174,6 @@ The contiguous bit is used to increase the mapping size at the pmd and pte
 (last) level. So this type of HugeTLB page can be optimized only when its
 size of the ``struct page`` structs is greater than **1** page.
 
-Notice: The head vmemmap page is not freed to the buddy allocator and all
-tail vmemmap pages are mapped to the head vmemmap page frame. So we can see
-more than one ``struct page`` struct with ``PG_head`` (e.g. 8 per 2 MB HugeTLB
-page) associated with each HugeTLB page. The ``compound_head()`` can handle
-this correctly. There is only **one** head ``struct page``, the tail
-``struct page`` with ``PG_head`` are fake head ``struct page``.  We need an
-approach to distinguish between those two different types of ``struct page`` so
-that ``compound_head()`` can return the real head ``struct page`` when the
-parameter is the tail ``struct page`` but with ``PG_head``.
-
 Device DAX
 ==========
 
-- 
2.51.2


