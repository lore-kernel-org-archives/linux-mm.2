Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DB941039880
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56F56B00DF; Fri, 27 Feb 2026 14:43:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91E936B00E1; Fri, 27 Feb 2026 14:43:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76F406B00E2; Fri, 27 Feb 2026 14:43:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 565836B00DF
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:42 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 06CE114088C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:41 +0000 (UTC)
X-FDA: 84491261484.24.C8182DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C2B3440004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UIRuX+z2;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bzoo16O7ZrITNC48RN5QZ0zww2292+HM1+oMv2xat4s=;
	b=yRbJrby43zMoQmzyP1Eo4ZQcfb1grpdBIfwzFtUaqx5DTWXMUf4AOlbE1MMkI/l8F16Flw
	AhJpfgmXw9dFTJBI3hSxnhdW3fYitQGxAHn+QoqkWb3N0yoatBZ1e7KtBBgJmkYwsv35uQ
	L1rGiwZEta5bhXOaDxQQEOD0+RaOkmQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UIRuX+z2;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221419; a=rsa-sha256;
	cv=none;
	b=CBksIM320MMycjy+ZFyZqDSF+QDEaRQIpdP2xgII586VRYRGewuMR5CGFkO9+PHvzMeEI4
	RxfzNTej/OexwhNNck1bXYfo5dRBDrtQi87/wRPvuKDcFTOGaf84kvZYov0kJUbrpj12Ru
	IDJJ0nPWMZ0UpPCwDwcwP3/qexcVqUM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F0D93445B5;
	Fri, 27 Feb 2026 19:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C25DC19423;
	Fri, 27 Feb 2026 19:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221418;
	bh=AzObIjwfDWqBbZbwfrWx+NLWeNrw3OUfYcbmIl3qAkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIRuX+z2/oYgfTN/fpVVkpEln3ystSpbtAeWmB8vYNF18xS9ZKEx6N2Bq2PxyKWxV
	 mIRjOF2HxnP5D51DP9UKSXBTka0UUyMAVzqmq8mbddULWxN64kVxc3T5cV3ukYE2Ri
	 wnEfA+I6OoKr9001nL+HFU8NA1oXImXvG+edpLacrbTzNQN3uW714wHsE/4RU/8sg+
	 c4T01MUHa5vOXDkLJg6HE6+Gg0YQKSRdw1/88WYIwNC0Xjwh5X60apk/W7sZ4WPbrt
	 x6ciOZOOWqMmACZ1NO73mwNeVpr8xzFVPgZmcpVenrZvex7Dzdui8tiy/6rSY6J5+Z
	 aiBIKj+MNZjLQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4347EF40069;
	Fri, 27 Feb 2026 14:43:37 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 27 Feb 2026 14:43:37 -0500
X-ME-Sender: <xms:6fOhaRljmtwCladvdVdTs1uKNBlldPgkpxj8iEjd6pRszwIE2LaaSQ>
    <xme:6fOhaWCxgfvqj23kCSp1LLpbdMxNPTs-KSaEMHjY89SU2kIdVg2Nc9s4nmKbMyLkb
    BP7xSOjfKZrAOa8Mq_R7D5RfGLQ9M_h60kia4SRprqJXTfpVlMsnik>
X-ME-Received: <xmr:6fOhaRynwl0l9IvW3dBXKdzlRB8psU4IbyBZGWiQuggEG1HD7ezP0vRRD4hrhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhggtgfgsehtkeertdertdejnecuhfhrohhmpedfmfhirhih
    lhcuufhhuhhtshgvmhgruhculdfovghtrgdmfdcuoehkrghssehkvghrnhgvlhdrohhrgh
    eqnecuggftrfgrthhtvghrnhephfdvfedvveejveehhffhvedufedujeefuddvkeehledu
    hfeihfehudejffffiefgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithih
    qdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrgh
    esshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhm
    thhpohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrd
    horhhgpdhrtghpthhtohepmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgt
    phhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihse
    hinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehg
    mhgrihhlrdgtohhmpdhrtghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtph
    htthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:6fOhaSei92AxKtDSNk7Tu4HEencE9E1hM3NnIzVlSUiaScfXq2KIpg>
    <xmx:6fOhabz-zfd_LnAY0kPWAbgOFi1iGlLBMYMJtyc2SOKL5rBUCEwkAQ>
    <xmx:6fOhac7hLe_myt9C81Hr2MqDxemPf7c3adCImg4mGg8cPUqGBMHmgA>
    <xmx:6fOhaYygtQki3TFoxrt9HX5uwY_MfKcXs6RTkRi3fkF_oWQLsLttcQ>
    <xmx:6fOhacYDqyd3Loj4RKa6CSF_PSzT8QpEqlmack8arkoZz8Twf1w2JHAk>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:36 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
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
Subject: [PATCHv7 17/18] hugetlb: Update vmemmap_dedup.rst
Date: Fri, 27 Feb 2026 19:42:55 +0000
Message-ID: <20260227194302.274384-18-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C2B3440004
X-Stat-Signature: ja4zpyp5ppe4e9gcxihbzutme5txg8tk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772221419-738407
X-HE-Meta: U2FsdGVkX1+FFfTuj/htE6qTQ7nc5cA/3qHZzi+CrFHZQ00TPBuPf/IZua6DGJRZWe8rm64Yjt7a0s5FXvogRO4WtHpmzkJ5cyu2csVUVyKgEotCOkuXtIskOM2xkTDoQaKXSHMYpnrvab7zrH5updtAG/l9asNb8b3y+PvbYK26ZjhudwaJHJ7mgYkQyulbU4KHc9HjKE+N8eB9sJfjCP2e4GjEo/eVxYkkYZa/2mBLiihY9wWEH8Kc9YePW7CteKnviIjQMGzzyT13wgdndlXaxD0GqnN+mPXEVBIIJxbPe7mD+UWMTbOj5QQzfb9Q10HGJGDFvENz2Hpg5egKkVYhLVGmqRkphgdVP8ghg1xzXUm4yCIxNSsyWAD8coiCVRi1/r2IfsGvJ3Be+2rRBumams789oCQui8qGoWVrIWg2G4qKnfvkMaxIUlUqvS4jtiuEDDew7yu08f3/ovBzws5MMm9zdUEKaBvJRmtzvoLnEiAHi93MJ3aDesLxf6RPnjXsPj+9L7NEl93TI7D5FF58mdXHf+0jmw0WRpBeDT4AfJEWokEGINBFnPXxirmni42xAKze6AXSe2Bx7k4dtOiSI4HjFk7tD9NXsezHLJcPu2nWwsAzSAGBC+8rcTImNC06Vw2VoRbyvVI0ClmBwtnuIwG9J/G1HV01jsCQBqFt1nWbPb7SF9fRvjGL7VtvfySgqCIovSysNkYgiNHVBEShBSl4Gkcz8eiWVNPxwsOjthNUGGaLVVkd9UwbukdKb8IAFlkS+OEpHAmOpi1I8iyu7tHOcXOQUhAs3IEEjW1ceHNybgWE3AbGuobIJWBGbTfIyzXnL5R49+nnlFaqsi+uc7tCyvWs5gMSAwdTph0a2kEKMFcAuQa9IFEDyf1FwBTgr9pcIHXz/MQFxcO77XF1bDAytPAXNXnr6Pv/y49t3ElbvHtDsQESOz8pq9D+1MmOiPZydMZf79fDa2
 431VfMhh
 12elF9UeilpjxBaqSr+DNyxWIl9mkyLXmSpcKPQlgJLDsV7eov2HxraWIoYTvllyOfByuuFzVdRDyyRFB1tbSWQesPjGHKdqoFFlHqcxU8BPFNCOe4/2Wx98OqRzlXOrmWbRGVPWRJvFm2ojYZVZLElFI/9fQ7/HPeeZXw74X7gdw7lk/PNRznZTL7BZU5cOx5S03OcCu9UMF2mBi63VoBZi66/RVIS0tVpur9n+9wCPfNg9G0qVgcAjFAzweAjWe7rnDDclcX8NK8Oek+BHvR/6SJZZQgncmem12ymuiB7fyK97lRTV/ghHbbqa9LllUMls0Fg07l4lo3jjmbv1i1zpurbdWpht7PvZR
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


