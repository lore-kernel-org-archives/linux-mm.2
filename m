Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A596FEFB7C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8A6F6B00B3; Fri, 27 Feb 2026 14:31:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A54CA6B00B4; Fri, 27 Feb 2026 14:31:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C4806B00B5; Fri, 27 Feb 2026 14:31:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75ECA6B00B3
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:31:04 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 372E7BBB41
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:31:04 +0000 (UTC)
X-FDA: 84491229648.15.B734483
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 24006180008
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:31:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I4TQUYBp;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bzoo16O7ZrITNC48RN5QZ0zww2292+HM1+oMv2xat4s=;
	b=pGnCNoZ3hvQ+flUk4M6QmXxbgrWLM0TcGIoF+Jity6vBiUF+hJ1mUllq3DcA4hRj81Rz/H
	h0BOepNc2Id8yJ2C+31sX/fo0xctIchCBUWiO0zp6HcRHV5VrOdE8IqxZyI1hWeeIEOjkh
	GGe3vnTDc2FB+fqW/NxNBPpsV+3itoc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I4TQUYBp;
	spf=pass (imf24.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220662; a=rsa-sha256;
	cv=none;
	b=iIGq6B8lS+6K6evz7jE8UZ1a8dKEQI/EwTYUW2PAlI1MS9CQ8Sw878S+FsVnPaj/jpwjlQ
	LQa6ZtMCYKgL0thUc2EWT4SKAEdfFfVKiUPC15xI1vmJJGFjjemc4ka8s4393GkYG4byTa
	lTsmtG90cxTNvWXob6T1Pd1CUG3BGx4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D09A60142;
	Fri, 27 Feb 2026 19:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876CFC4AF0C;
	Fri, 27 Feb 2026 19:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220661;
	bh=AzObIjwfDWqBbZbwfrWx+NLWeNrw3OUfYcbmIl3qAkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4TQUYBpIB/Ir07wy+0/SiDX39vkrPmhua45EnU1uk8PnAKtd7XSf7gt19+pWIWaK
	 bDz7DEDW3OSr+R/tLF2Avnp7uGZJW6fmWmdaZPXSjtc9CyqiAYebVFFcrvGIqG/Zqy
	 /6knunzESXekQDRZiacGPYGjohsy1K0h2TPL9BSKnyb+pgn/3ZP5TT/sIh4BZ2Lpze
	 VfVRvjzMuxpugu6hQPa02WsTewJXhJcK3Nd0X99UN7kzNfoPMybd7ek9WrEh13ljEg
	 5E/FeLuBePzNtQ9qWNbefjF5l+D1VQ6npfSuNFqOl1BOUhHk6Ec9Kd7wvzpxbWX8S8
	 T6nr9Uze2B6xQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 98193F40068;
	Fri, 27 Feb 2026 14:30:59 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 27 Feb 2026 14:30:59 -0500
X-ME-Sender: <xms:8_ChaT2JCnARfGq6TGvB42txtSB0siSPo8ldnAuOL8mE3Qi4D0rwRg>
    <xme:8_ChaSMdDQTEG956tWws9YYVQ1b4ZIGDY7Wmz82U6bA2kVeYhyQwsAffHnhYbCn-Z
    pYDgmleo6OR-z6jDKJOlwpeCNcfhKHtvH_ysOZbB4Krgjef6u8vkAs>
X-ME-Received: <xmr:8_ChaRs43bKBKw3qhUzEvYoJvw4mPLmV-J--rlVLflewPDJIDnfCs-9nqKrcxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhggtgfgsehtkeertdertdejnecuhfhrohhmpedfmfhirhih
    lhcuufhhuhhtshgvmhgruhculdfovghtrgdmfdcuoehkrghssehkvghrnhgvlhdrohhrgh
    eqnecuggftrfgrthhtvghrnhephfdvfedvveejveehhffhvedufedujeefuddvkeehledu
    hfeihfehudejffffiefgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithih
    qdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrgh
    esshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdelpdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrd
    horhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgt
    phhtthhopegurghvihgusehrvgguhhgrthdrtghomhdprhgtphhtthhopeifihhllhihse
    hinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehg
    mhgrihhlrdgtohhmpdhrtghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtph
    htthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:8_ChadFkcp9C8p4jtDIF1mFEmg1N-reCz8vieH29K7_8vK7SfUO40Q>
    <xmx:8_ChaURhDjPU4Hfj_jxyBmdwct5kE0kN6uF9Zmym37ij-tTyi8eIRg>
    <xmx:8_ChaZh1uPpYtN8y2S1b1lF5GrOirxfuINjSRyIggPmtdiavrf1QqA>
    <xmx:8_ChaQbIwpUjF-40mgscc-G28FdVJbDUKGrsUpKriFyyCkE2mDl65g>
    <xmx:8_ChaSWQv1aEiXS0ffNTxDewcdJQJZc3KOl4GlRYcsTWsRFywo6d9Kv6>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:59 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
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
	Kiryl Shutsemau <kas@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCHv7 17/18] hugetlb: Update vmemmap_dedup.rst
Date: Fri, 27 Feb 2026 19:30:18 +0000
Message-ID: <20260227193030.272078-17-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 24006180008
X-Rspamd-Server: rspam08
X-Stat-Signature: ja4zpyp5ppe4e9gcxihbzutme5txg8tk
X-HE-Tag: 1772220661-571549
X-HE-Meta: U2FsdGVkX1/tNz/yIP2mFPYrnYwAKJBgxyXtK4FPLZ0ddARBwuWfMyX5npCDfOWZ62ISJDkAIjI80Im4Vb7jaqez059x0FT4cOqxkefkzl3tmETKpafvQr0qFCAVSqXi4RvyTYRVYBcLBALRFp7gH65iqhi5NP1ccdZpJ8/QuwLEJb3b7VBvJT4wZBK5dM9kmgdN+XNNSlUikUBJ6KodOmSwwkWNdueeItvjWFciv2CC/8GQ5wRbHEiDt7KhG31HkJpllxM2cAt0MPImjG2GzfoPtJlLlof2AC7zEusvoZzUpZDntn0+duEGMM1u2T8o6g2sRs2fqCoH5pa+Z2/ht0nITLDU7hhsNJfAwB3+2SeiFDbjmMPsrlGHxqmqnYrsTUGzqG1ltiKSVbpIy4vWNTXTYpqJdurdS57r1qmJ4MAP4cXIHMCVKM19aef2AYFxHxTAuGggtQBAwUg44BjZWGVyt5hRzxow37Psjx9taqvw2s+IXRDHSIud0z1115X6XS6hG9td3hkDWij/BasWpqHZ2ozQo553ovxZuC758rhQ8aVXhq7quVp3brxG39qtwYFYakIgEP90Or/AXBdQbyITxTgTP6kThb7azGWMetROuYgXDtJ0AsplCjeJTkpDfMkd7qC1/FKuOt1LlYTDcqcYlw5iVOlkDiR5pONk8rjFQV1TTacoSTMfy75VhzLbHVloorWAJpMGbevbBRidzicsVa/awEY7scW3a1b7HJ7aJiZGrI3fApn1fN8VnXcxSDN78nKqQkFH+hfAalHL/o3gobk18ZnOAVFXW9g4FIoJT0GZmXmZQPUo554ELYmw98eZ9E6ktzEMVJ+/iJs0OkTXKQbENYlxneKWkmdjlSZH9ZEdziTEPxc5SOZx0LzLEIN/IfWXqa1nhgJbY56bYjq5pGLN2DBqQepr0fXgOl6NX6tGecVNAt0aF9uleioS7AgzNlu4l+YHk9sUM2c
 Z/iS0gHU
 ljsA9xtwy4QPjcKE5b+jDmeTjct1sR6QrU/u4tRMXFaUrG/qImXrgaxfOhWXDEJwmcAqVbXX8FYYB4jlzqvaAkOtrqewDRDHJSJp9dpKans4sm8OoCOu48o/iqKD5KAWXdOyPz9TfLS/wB1Prxa5h76ZexbhkZsxOfAirqh/1elrJlIZeziDZifqmaEH7ZsMRXri0SAf/EeUhO+w0iePVAI9ijJFsiZV0re8IDH4xzXEThll4vlcY1552lBc7ZGIOkoukU0Zv4kS8BpMPW22ynoQjjZWn1girLsxMSX0PKT1u+F7RYOfEwpHL0amjSyHDxxO+mnd4amDHLgMhyAJWJSr0NA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

Update the documentation regarding vmemmap optimization for hugetlb to
reflect the changes in how the kernel maps the tail pages.

Fake heads no longer exist. Remove their description.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/mm/vmemmap_dedup.rst | 60 +++++++++++++-----------------
 1 file changed, 26 insertions(+), 34 deletions(-)

diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
index 1863d88d2dcb..4aaef36d8971 100644
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
+    HugeTLB                  struct pages(8 pages)                 page frame (new)
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


