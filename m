Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09997D6D230
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA3C66B00A1; Thu, 18 Dec 2025 10:10:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC726B00A2; Thu, 18 Dec 2025 10:10:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986076B00A3; Thu, 18 Dec 2025 10:10:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8207E6B00A1
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:10:22 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53C3B1A0223
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:22 +0000 (UTC)
X-FDA: 84232927884.21.F420703
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 535B58000B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:10:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j5pE5e8i;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766070620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDW4JDaGgFpQkVgrKAwgGhopPC/dX2Av1LwPbglr06Q=;
	b=tX5wt+uOMY1gJxFkBaBObKJAxwRqlQ1h+q9tp6qawnD1oFN7HSHFDGKJBKkqMJX9OBQQu8
	ANPCO/FUi/mC8qLZ1idLfJX+Q9zCGgJKZEd5GTjFGG4aMNB5VdIUlr+gIHGuHZ3m11TKV5
	OlGtiMxQJgdouKXAma4AMMnThovP/Mw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j5pE5e8i;
	spf=pass (imf02.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766070620; a=rsa-sha256;
	cv=none;
	b=jXymz0ps9jk2x2KsREs+dk+38neSPkM+EEoIRBs91+Bc51sCsJ0JbtzWCQOaerGgOs9c0v
	wwZQxwZPGSVBn3pIHVd6rEj79pglRf9y7W69EI2aQlGoX1MRJlTe+FHbU6aRofgkMwEqDs
	wVGe0cRw6qcy3ow9AwQw2QbGgZtTazg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D463F60135;
	Thu, 18 Dec 2025 15:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23724C4AF09;
	Thu, 18 Dec 2025 15:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766070619;
	bh=qHJKjreeIB8u6+GC7KtXgFelYE26+ueZzxyId6y/BHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5pE5e8i3AKjkR8X26UUaRqpDhXaxWIJP0ehbs1RS+1zq9BnrSEf286kgh7Qu6/Ls
	 XGLlHSahXuhHL34g9WL1KNM+oKpopVdzyztmbr0ALoN4bwBvU259mk89csSgIsmD8E
	 4XUOEGSVDm3pbksY+UU7y+RKy9Ar0GUNtETuMWvxUBsGPF1v9RChz52Rc8D8Y+2zvw
	 wFHsfOzJcBilraBa/s8XcIO8NYrqm8j3BN+7GWkk6DPsI+C8oF0KBHrluvtazBeEuW
	 EfIRTGeQhbZPMShfvqfCL74EOOqGguuvQ6D/V29n1yUnLOsOii7tKov1bDRmwu7sjM
	 6YCwEEsnf/vlQ==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 73C68F4007D;
	Thu, 18 Dec 2025 10:10:18 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 18 Dec 2025 10:10:18 -0500
X-ME-Sender: <xms:WhlEaepC3GZh-r6xmLaZAmXW63cSj-cNRTju0DBpr7KGuYUSxNcE8w>
    <xme:WhlEab7xVHDB4OnS8nB7ZTiLLgPbyhgIeE78ri8a7WxUlPTNgZQYAqyM6fUgd_YOJ
    gYo3kDV6FvPv8BVFU4rZxWI4XCM8d_hZ4Q_fIQlUATxpRWzGhzFBkA>
X-ME-Received: <xmr:WhlEaWCW4t7DYlsF1Fw_uLX8hux4OPpaxB3H-1Oh3Eyxr3tBIOwZHwChuCilrw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegheejgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfgggtgfesthekredtredtjeenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepffekffefudfgiedujeehfeelheetveetgfevhfevteehheekhfejfeehgfeljeev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:WhlEaVYe5tbE9G--vULGabRD1d0K6KI53elxisGeUIC7IcHCcpI_7w>
    <xmx:WhlEaSJ30P0rdxauImtBholqpTNuVOFMl7-J_WOOeb28DvKDOvmg7g>
    <xmx:WhlEaWCUJoiTGOn9cK3A18oXitd7fOgNXeVYKIswAwHPJGOzZ6pnVg>
    <xmx:WhlEaeNTT7Puh-O6FLoAI6G3NJ2U4gkhyJOKefys8qB0oAheOU_-Og>
    <xmx:WhlEabWT2yAiLvtA2ZuCdhYqUzASJXRauEymYK_Oi1txACbze74di7I4>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 10:10:17 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
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
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv2 14/14] hugetlb: Update vmemmap_dedup.rst
Date: Thu, 18 Dec 2025 15:09:45 +0000
Message-ID: <20251218150949.721480-15-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251218150949.721480-1-kas@kernel.org>
References: <20251218150949.721480-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qb93c5s8t4167pt897uupp4zzy8maste
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 535B58000B
X-HE-Tag: 1766070620-698295
X-HE-Meta: U2FsdGVkX18mjTVfnvlxekEKoCoM5z8yart4wpZiGYE4r6RmFE+zTyZVlLRgTD7DjjbuSmNbrd3hgUzMadf+EuEPLkj4xJEOI97Fz92tUXUMilCC77If422hsWBuxi1ywXujjDlfDZvUVVieVACnVPdHCWlSqXWOw6GyK7EH80ioY8ToDct0CxX/CCKYwMn76/CePKq0KkTbnKBMmaajg5Dj3oRY5rEnO/gJFX72SL+0GlrORoCw3T5Lk4GddPv6r9UG5+b39dDyRu2VNROYkHkmUWq48+MIxgNusYCpeigf6+9AwrCNqZBH4uwukLJK0zaRkQ2RrVSVNrfKjkPWBrNYhSh13JmNfgvaNAnOu3OQ1zRqMlttSB8brpoPJrqXrjm0Gx7tUBgexDWy9mMe/sBNVEYg/VzXqceB7AWD3v7Knl721CBBJvAEwURhPaxgQSVITdvxcPYX/vqk7b4VdPxdZvGnWx5mxy6fYDCutINCjCpdObMuHvjVbd8eCN51yRRv2shwF7exXYK0OIGwPkpBLavDXQ116GvgutSbOhhlfh5ptbWXgHdUZNuOI3lFpJ+IbjKOEmnByNbUSm3nEPCb/UrnHPZPEQSR+TpKWPMEhxEZvhGk1fBmw5T1IQmZnp3ROQOsKXWGnDiKnecE+PNBjxV8R1Iyuey2ck3dOKblGqNo7Zduz/MAMaL2c242NioWCjAnE6w9tF+uc052WGCXEbdh6H2GbN8yibjUnecCHDfyrCYcy5sx8iZx4z4Hri2oM2yjjTtpiuYQYtmE21XjDyAWza8CTvxg8mntLBuKhFSipgzMtVaAxcW727vwVFBp0v5fcMNfFkz43u+5a1SYjc5AQ4kszkI9E1sOwXxSm7fskoVzY2QB6dorM7P3E9O4koWRhcj1EDHhcaFAR6cI+2mEtGJJquTk6ZjEkeq6YA51bSmVrBS3Z15q3MSB2lK2OFi9yJMZQvsQyYg
 4OVGdY6Z
 WjspUY0GwqcZUbFPH21Vl7HysR+p/wWFEv6jPtmJvMb8Z6lmKZLbJCt431h9Tl7CXvywn4t3nDbUBMZqSZCymYm1MnOLMZxf8GcnjP3gXxxgnfMt2KMuIe1h2FNO7/g9jMO8ZmijCaWoxq0lcI0YVYqYLIL11Kkb0Tj6VrKOps3jXKgSmgDHZAOdASQmgKLXXbmulP/Ocil7pas7Jg9H08Aksz7wYDa+WYbp6PDoi87s1uJvWbeXhYnfU4/hQ8EDZQULrgfS+SkAVef9RkCVimjMxhWJlXxsobP/LgGkDKmele8+Tyhyp2Dt5Y2CKWKGv9bgIYEnU7JaI9FHR1uFIrkGizQ==
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


