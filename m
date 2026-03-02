Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52EBFE9B365
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 10:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FFDC6B0005; Mon,  2 Mar 2026 05:56:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD756B0089; Mon,  2 Mar 2026 05:56:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68EEE6B008A; Mon,  2 Mar 2026 05:56:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5976D6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:56:39 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBF938CD56
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:56:38 +0000 (UTC)
X-FDA: 84500819676.23.7B09C17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id CCEAC1C000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:56:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MceG+ZEc;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772448996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fO53EIEqZf3EeMJEV5MFvgG6rIsJTFc2D98eC5UlMU=;
	b=s8FCTh2dfd5UDommnEAByc7gF+AL0tDxxRUgNfPC6keSac3wNErzQ5mvmY7dgwyb8gKrsd
	md4VgcetiGApZqXPwRqukTOSPIPupT8/pIud7ttV8ivGYQZVEBydoFE9U90t8kCw3TO8bv
	rkDj9G7s7bGdmQfq9Em/NdgrkpgzWjg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772448996; a=rsa-sha256;
	cv=none;
	b=hSaWonDJHy8Yt1sZKxzDimGx2F2yXnipXtH8gIFvYRwPq37skDKFHHkTWzVKdYfjIy6tFD
	1odJ7MOfKbBymwBoGN0g3i8dbglUiHTD8YiJGPMfUV9iWofsMDnnt3mgSBnAlM54Oqj0kU
	7yWm7QLfL+UdofjLNro1N8HwIPp3Sl4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MceG+ZEc;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 14C30600C4;
	Mon,  2 Mar 2026 10:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2511FC2BCB0;
	Mon,  2 Mar 2026 10:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772448995;
	bh=QIorwtQv/JYtsIRrCdeqpsv5dj2Fg5DePeC8vwGY8zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MceG+ZEcp3/SuWG3t4ZJKUbTlcyKR9LQl0gmjP34KPmM1OPcpJ1jT8FA55hODX/4L
	 AJaIDVM9ISd1REbQj31AJSXJ6mgqV7dO39fYKTD72i5OSI59HlX7/ws/s88h1Vs9hT
	 fWIU+rQVC6tOrQ9fKp7AAVhOq/8Pe4N3GvBE7rbrZzLnzDK4efKsY3qsaFdk/B44i9
	 TGfQMIWfs0PuBOIFl+qyLinNrr1bARru7CjCwNCMBx91f8qA7CboXDT9kyYjZNXXFb
	 nKd/9BWu0Ydc2CnUDlNVSEaVw7rcPdfAcNh4kX0g9Bg0p52D9Pe6tsHrDrTwOlwO/q
	 7XwQMPB8jcVng==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id 245B7F40068;
	Mon,  2 Mar 2026 05:56:34 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Mon, 02 Mar 2026 05:56:34 -0500
X-ME-Sender: <xms:4myladjV01iWsOUtjtzcj3vZupj1Y1XZ52NB9CTcS42N2KVYqebmBw>
    <xme:4mylabMmI-f6TLtFwjswwP2yHngZCaAvMI2sOn5bsBZjXBTfu-1Owz5vCGlXXgrHJ
    5XA2TBeo-AvKsI4gmrM5H1M3Hu7R75Og4XdJj_eyAdhgwPDGrdE78A>
X-ME-Received: <xmr:4mylaXMtbuPsATgmuxJHjV89K0zt3CuvIB_boPi7x3NPTZBs0D_CosHxgsWlog>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvheejgeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucgoteeftdduqddtudculdduhedmnecujfgurhephffvve
    fufffkofgjfhggtgfgsehtkeertdertdejnecuhfhrohhmpedfmfhirhihlhcuufhhuhht
    shgvmhgruhculdfovghtrgdmfdcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrf
    grthhtvghrnhephfdvfedvveejveehhffhvedufedujeefuddvkeehleduhfeihfehudej
    ffffiefgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudei
    vdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvg
    hmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhmthhpohhuthdp
    rhgtphhtthhopehkrghssehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslh
    hinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprghlvgigsehghhhi
    thhirdhfrhdprhgtphhtthhopegrohhusegvvggtshdrsggvrhhkvghlvgihrdgvughupd
    hrtghpthhtohepsghhvgesrhgvughhrghtrdgtohhmpdhrtghpthhtoheptghhvghnhhhu
    rggtrghisehkvghrnhgvlhdrohhrghdprhgtphhtthhopegtohhrsggvtheslhifnhdrnh
    gvthdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehf
    vhgulhesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:4mylaTL_5a_Tm5FcC4DkzFyVnPOUD7NWAMruXiJ7cLUt4G70LqyDxg>
    <xmx:4mylaWt-BwsGNwvyb1I9YB3jtaA0LQ2aYs58v6i_bSjprG2Qy9v14A>
    <xmx:4mylaVF5tD6lw22TzAR11tltaMNEpftkfceacgzzxR6iJ7oYNXtewg>
    <xmx:4mylaVPV5xjJwdJ_j2BWUtR4lUjIQ7DmcR0whs3UjzW6Fbzus43HZQ>
    <xmx:4mylaYFG6vRkUEa9tC7J99RSubdP_bO__GGYLVU8KE4yvCzo4jTLrzXq>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Mar 2026 05:56:33 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: kas@kernel.org
Cc: akpm@linux-foundation.org,
	alex@ghiti.fr,
	aou@eecs.berkeley.edu,
	bhe@redhat.com,
	chenhuacai@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	fvdl@google.com,
	hannes@cmpxchg.org,
	kernel-team@meta.com,
	kernel@xen0n.name,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	loongarch@lists.linux.dev,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com,
	rppt@kernel.org,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	willy@infradead.org,
	ziy@nvidia.com
Subject: [PATCHv7.1 17/18] hugetlb: Update vmemmap_dedup.rst
Date: Mon,  2 Mar 2026 10:56:28 +0000
Message-ID: <20260302105630.303492-1-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-18-kas@kernel.org>
References: <20260227194302.274384-18-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CCEAC1C000A
X-Stat-Signature: gwo6c463xi6a39xdefm3oidij91b6e18
X-HE-Tag: 1772448996-197101
X-HE-Meta: U2FsdGVkX18+zFsT4TlN3CbzskZ1sopE+IjB89HMVDO9HpIj+8NZapNmcld0kllHh59XjR4TZB55bCHPUJhulZdd1R0ZTD5NBz4u20Em7I8QV9OIpMQSyxQUhSZGMJ+jwuwXCirtp2bbFl9ijgLfkF8VsWEU1DRad9cgdPZlXwysnBug7KLfHBfSChyEqcHZXdfuzNQDLkcYiohll/sgUwE62aw69+edIPpPzKVUVr2kLdAdqqSA8mH1vtTJNLmENZwmXEzMbD8fyL1veDiJNNLZJ2t+Z/6y6fuKUxzPvE4RkGHPI70URIaanDLbYgaTVu8dxabJC9I1fwb+vWpvifIRr2OOz8IOnvkVPRlZTVofhJSw7B0el/ocjlhb0HwJaCCAwA8pQ362FjAmCzHMHCtPoL2AfxPaRUVg+KRb/dG99mIljUWHhUDgcJvrvKqfcL453zDj/gakVxrq6Rle0YfgWWNW3eExU5D7zXtdOCUShpPqiieKy5fiAbY6DFhS7WoMkNoilEmUVbTmnU4WCxhPC7w1oxpP0Vrh9AaspAycCjI4fWC09Rx5dymC+S9sx7UB/Zsqydc3KTB2obmEgineIK/BiiB8jL62b8efw6eg+6w5ao4ROxfhFqv34A8krVy7bmLzyiflHM7VjVNhahmTDStZDUCPdrfOIDlp+eamzLt8wVUnrA4A5ixiVh1qZe79Sv9afkNur9Bu5sHrkyiztUyyQF+YhSGvx6tG27DuQrhRMXA8X9hNlsSjgJuSn2NYZN7vq61p9D4CjsD1r3P9/5EFsh5gMnJIsotjS99p9+XjaWTbd6yflEGgwVG01kqSA8AZPKtqQ0xAuQQ0+8XsYyD5Z4n0WFuK3qC2YjtUf9wjIW1GvLgljER0Q2TAXqr+qg9GzIHVaBbkMatv1wCRb5rmAI2hlDCiedqLtxHj4m4n9PHTo9/iN7ttSDHa1ucK4Fs6XLQt5u27fJp
 IvjxCwAf
 GCwSEwc/0LqWAG2Q8xczvxgR9946IFJ0+OWyoAolqgc8YOV5ZJG7TFdqROWm3ZcL8Ea9Csj90gAIc0+3vTVLWxVjCWaMTWI2N0P514CmtsY2Kxv/rAqAMVIbZV9ZGTRjcz+0RLW12qxmcxWVqxTPlpULQSLY/Tae8rnRegATcnjXREsmRo2EretH/cQSfkSi0oo7sk/ugL0LjNevOJS7yPau4poe/nI/s2ngdw+0+4dBn6Hrn52Sp6Tlvxw+rIzVJZljXGhnVwzgAnE6E60me/9WJOd0HLTzqCZOBAZaloiMQbktyV99NFvSrNyzO31DpHo/wmyx1uWEZKG4pvj3ExQ0Kpg==
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

v7.1:
  - Add missing period (Randy);
  - s/per-node/per-zone/ (Muchun);

diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
index 1863d88d2dcb..9fa8642ded48 100644
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
+The optimization is only applied when the size of the struct page is a power
+of 2. In this case, all tail pages of the same order are identical. See
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
+ |           |                     +-----------+       |        | A single, per-zone page    |
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


