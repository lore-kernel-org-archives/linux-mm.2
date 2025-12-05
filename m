Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39298D3748E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04E416B02D4; Fri,  5 Dec 2025 14:44:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A016B02D6; Fri,  5 Dec 2025 14:44:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D1F6B02D7; Fri,  5 Dec 2025 14:44:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BB5D26B02D4
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:44:15 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E66813A7F8
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:15 +0000 (UTC)
X-FDA: 84186443670.08.487A131
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5C89F40006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aVyMDVUn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764963853; a=rsa-sha256;
	cv=none;
	b=i1Z5W9LRPvNWuYRPzVNijhSmYj7Vw7P5/gqnB6JvnlKLjTtWXjvD4ErMHrg4ionAj0sWAb
	Q51Ci67NwhFv4+1aW8DNVwM8GHSwYgcZqUIDautIA+l4QLx+v4LQhp4CU4kZVf4Op6AC/f
	h1kUB5cU4rK1kWFUOFM4NvDOHIrMBnE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aVyMDVUn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764963853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDW4JDaGgFpQkVgrKAwgGhopPC/dX2Av1LwPbglr06Q=;
	b=GbDp451Mc0E0xhz9cdVDUUHgspY8hkF8o3FjtvRb/26KqAWEqY0qvNhGGDBTHUURLqgSHe
	HwlZzyIRPA2qEV4FGz9sMLbcU04qdhtTSF+JX75z8UzOeV2qBViweDIqUuML2w6EnF9evP
	XyqAlEYjIw6plduI/9J9VLSScXhccEw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2324244449;
	Fri,  5 Dec 2025 19:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4621BC19424;
	Fri,  5 Dec 2025 19:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764963853;
	bh=qHJKjreeIB8u6+GC7KtXgFelYE26+ueZzxyId6y/BHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aVyMDVUnqvDhSDHXNC1m2wArU7R1MUDFvsEPnrTbUKjqQt1T5H8KHPX3g+qQ5GcXO
	 XdrTtneqi0WkYXwY55LbOrndMb8Z7l1ounMEiplPr0Lwt0MbH1oM0p8kx6EaYg6rxC
	 ZWNh6oHU+VTewK8gnXlbGvi9aaMtBZzDzk8fwBoGgc4FgHCWAn1lKz9xIIYb1ozKPJ
	 cW/OWFyD1n+d51NUaVEuLVVj40S7MdhJLWpkc0KyPP9UG2qOGftPwbLqzJArruzo1w
	 PbrktfwvyRgeJrxhSxHuh2d01dlLnnXygtrhJ7/o+DyyYWunowyGp9jW2aobtZmKGA
	 GM3ZX4AR37/gg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 91C13F40070;
	Fri,  5 Dec 2025 14:44:11 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 05 Dec 2025 14:44:11 -0500
X-ME-Sender: <xms:CzYzacuEDobpd0dd8jwjISI2iocJ5NUG65dqIAF7L9fUSVCP3PgjJw>
    <xme:CzYzaa2Du_apaQOvKv0oqRifNs-71e6vc-XDroseY0Gy-7ndFMwOrsW_APu5vLkV6
    fTY1i1W73inQqdiTkEEq83sv02pJeHKo9SZujMs3VRKzMeUcTavMY8>
X-ME-Received: <xmr:CzYzaRA-V4uXYWNkj72EKMSUtPlB6w21f1Vd_teFOR1wC6fdqbJGJM2jW_6IkA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    ephffvvefufffkofgjfhggtgfgsehtkeertdertdejnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeffkefffedugfeiudejheefleehteevtefgvefhveetheehkefhjeefhefgleejveen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeduledpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhope
    hmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepohhsrghlvhgrughorhesshhushgvrdguvg
    dprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggs
    khgrsehsuhhsvgdrtgiipdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesoh
    hrrggtlhgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhr
    ghdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:CzYzaXeDntB38jw0Vf1yF8pPBmq6qMF6evx7z-aUKyC5HTY_REF3sg>
    <xmx:CzYzaTzt9LabJkaD0ji25niHES210gpkgCYmSK8ev7dKtFinKkRNxw>
    <xmx:CzYzaSNIoMNoSxElwtkEgVBiva09vHqKWy9CLqBH417nwiievLSqVw>
    <xmx:CzYzaSZ7QdggY1ALRSw5JvTpKdp9wsP1-urPY3hrq6Mi7ajskLoaYw>
    <xmx:CzYzaUrLQ4jhnBUc5B-W8Q0vLRGK0irdmr6OqxtxJQJvlYiO8f6nND6t>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 14:44:11 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Usama Arif <usamaarif642@gmail.com>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH 11/11] hugetlb: Update vmemmap_dedup.rst
Date: Fri,  5 Dec 2025 19:43:47 +0000
Message-ID: <20251205194351.1646318-12-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251205194351.1646318-1-kas@kernel.org>
References: <20251205194351.1646318-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8uyseoick581oppe166u1kripo3wbr9c
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C89F40006
X-Rspamd-Server: rspam01
X-HE-Tag: 1764963853-17276
X-HE-Meta: U2FsdGVkX1+SVHTXgaXo80Efp/clDyy+eZIXsbCsShOa3UnA2bvzohYssnJmxZqU6hd44eWRnll+p8ukBGX3dSV81y66O59XeoIkEOts7q7/fKqCopYY0gVRTb19yz0jyHBr1FFoY7WOCE50VaPDwP3d7599J1G3QMx2px3/bqAERnAueBndk2yqxBITxdn7N7W2Nm5M7yfBOMsVU2aYYHRInmx6qmo5TUMf4UIqzy76AZGmR8JW5HdfpGoUt4vJwEjU0CpRm02HA+yqBZ2X8JuzllXRLOcB9yHOSvcL2l76pDGPcHZXT5vK10ii5kpwEkVKJ2o8rtdKZrPHKjvOKlITQCGqWwBW/qdYLTG8mTxKwtyJu6iz7WZC7T0pnGP6/Ey7+MKmjXxSHNNa6QiV2Is8/T5C6hT/jxMzBHL/Hwh5kmZOi+ScdJwEyOv1RwHI6bFGZ9ZY4q1/n/v0ys8UvfPI6jL4QEu73+9HJsCP/EpV/XOQXRAdAkGwBbubY5sE9ubXRQ+WFSnOm3dFf18ZNnybUkG3uK2Gl6IKDMIBlECje6hyyb4ATkzn214bLd+M+8Eem0xybXlp8wdS21QDeV8tiAbn0wH9p7uvybe0OK32ZwlmrSbPGpDXQMLZelW7TYGrbUYaCoL6pk1smWrnLkFHeK/U85jidovDAoKwBY3viFtGcVdET2XnlfWMh9YqYT18yIeS9ZBoSRDc8iPtLJiGgAlg+jLn6YPhsvS+Fi2sE6Ab/GtI13/PSt3zWZMD94KU2yJmkoabxRque0EUt/CTSxPpcwrRF9VXLWs7Xs3wyGCAKAEKWXfTNk+IT/EJwQsifsXnJewfiqNgMFEfUnCCaiaw8AMn5hGm5TsHLeBkq5NoWVZQsAt/DXr/wIdPp/aa1a7y8A+mOJJe+sp/zWzivkuymYaByDGaxbrG1fq3r6wcvY/nVk10KWOLz47Y5kHLhWk7N7S36JiIAXT
 xQGDGrv0
 TiLrC7uZVY4Z+mWuRhd9gnAi8IXBCX4MeReSZljTw+OurcVS+Y2ckjArLT6KMnBflxzsNao4WU9mijzaTY1y1g0u/dt//f4KhE1eQcDJ0mfQGalNBcz1sIm8EAqBPaC5L2Y0e73NbgYz49wpRJKgp9tnp3s5JXMMoefcHn82QLTLFV2eQ4xZDuSsEqe224tB3Ft2MkJxpfJT+W3oK4ejrVCteW5zqT6ZDLzV7EVzgCxd5eitmabF78oBA3pIuIKpfu55yfP9XDEPBBchKChoYHMT5BnmN1riBE6a0115eRT2IJ9MRjNFG8kxE++IGMEzqXLM30T/b1OJiI15+ozrg8lJMlBJ/jXoDqZp0
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
---
 Documentation/mm/vmemmap_dedup.rst | 60 +++++++++++++-----------------
 1 file changed, 26 insertions(+), 34 deletions(-)

diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
index 1863d88d2dcb..a0c4c79d6922 100644
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
+ |           |                     |     2     | ------┼        +----------------+
+ |           |                     +-----------+       |        | vmemmap_tail   |
+ |           |                     |     3     | ------┼------> | shared for the |
+ |           |                     +-----------+       |        | struct hstate  |
+ |           |                     |     4     | ------┼        +----------------+
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


