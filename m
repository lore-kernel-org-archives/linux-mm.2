Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0C09FD9E3A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234D06B00C7; Fri, 27 Feb 2026 14:43:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5716B00C9; Fri, 27 Feb 2026 14:43:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AACE6B00CA; Fri, 27 Feb 2026 14:43:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E78ED6B00C7
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:22 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C8835B867
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:22 +0000 (UTC)
X-FDA: 84491260644.07.94ECAF7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9DDC11C000A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pz7x/zeR";
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HGHTN3DUUSqL+AyAyhK2RUpMnu3/FhcMOUpN7zTMBQU=;
	b=Wgf7efivpIooueye5oe6oSoeV+GATGipBtJru1RqKXrLS7s9xKUKNkBTwvlLAn9CcIzJ+x
	G7maBEOcyZbAqNeIIItRQY8kapqKxpd8ewq8YqG/lDxInzaWSSTq8/wmWpdlIRjesje+um
	AKykxvy66NGgrLfDvQE1yLItsz5vXxE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pz7x/zeR";
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221400; a=rsa-sha256;
	cv=none;
	b=NU31zUsgVqCTxAU1/ZsFjvDWoofuy9Acq8dAwuEpDvaLv6EvgynVHfqWxrDUdyGB0qCj+J
	nLeLlfEkQ9di/GRbSeAb8hTWDGGkMa9UMo6c45HcamtWRXYkWJCYQxA1WDlXxXI43eZRSx
	s/a1MyMoVEpMrhV0SUODvIbJSqCOsys=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0185C6091C;
	Fri, 27 Feb 2026 19:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD907C116C6;
	Fri, 27 Feb 2026 19:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221399;
	bh=Qa3n5VKBU/DN+usEuz8+Om7G9sqmqxUGPeiY6zJ/Qrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pz7x/zeRZhQ6xZh/JF2PLBA3UVxYt5R7fliDJqQsrA7EWawCcDrq6rzktU+2Xknfo
	 tlAd7MbWAstB6zD7YDLt40LYBwiyBPtk/5130dQdxkHsr+jNi6oGQySAvmpDt3qVmf
	 s19NFBZCsIh3k5ZDvNy4BUsvYkbTDpxXcqw3ONh/PgxkXxAbPpQQCRZE1xaiz/mlHK
	 qmfkudr2BHhOHDDcJAFG8InHd4JESRAMaS8xCUrqhKkjlhhtSXUK647GOpOI4CgAHC
	 2FjqjqC9OPN+yaDqpOYnL2vnDhijVJ8ie2lehbduuMxeQ4TjgqWr4dEq46b9Xiyci/
	 CgMe6S4W/Rq3Q==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 167ACF40069;
	Fri, 27 Feb 2026 14:43:18 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 27 Feb 2026 14:43:18 -0500
X-ME-Sender: <xms:1vOhae7YFFAxZXh3_N19WWfb2lBzOwlSxqyevDM4BtfJ-BidljQ59w>
    <xme:1vOhaRE734JhlpbsLxbnczaJk9g1Lhp3aCegQ1fJ8EFJ4sJbA-M1y887CyhX4tiTo
    y-9nZD5a4huuGeV22LOqmIFkpBvSzEa3FJr1hUinhqyphyszHF_cplS>
X-ME-Received: <xmr:1vOhaXlNd3fqpGJtnHBHpj_4sS5cx8LORSG1Zdqhuxo50BCkCNKJSopNR9EFxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:1vOhacAFFqSOI4885Zy7Iqo0us3SXf_Rk7cqi7_GkheLV8lhkcXWpQ>
    <xmx:1vOhaeHcRVjpp47P7EB6ZOgUrov8X3dLllIUEtUN8eJcPa6fKn8mKA>
    <xmx:1vOhaY-16JPOoDp2IoZQcFlovyvM32cGRyMZpOu_Xa4yYLoeawolRA>
    <xmx:1vOhabkvbZv7ZqtIx-vd9H6Q44WMt4kD_MgZLhDFouQyirDnHmfbCA>
    <xmx:1vOhae9n8SDoKW34ApDWeA6Vz33Dgkc3q7pqQGTX0-uJGpGArdUeqCRt>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:17 -0500 (EST)
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
Subject: [PATCHv7 05/18] riscv/mm: Align vmemmap to maximal folio size
Date: Fri, 27 Feb 2026 19:42:43 +0000
Message-ID: <20260227194302.274384-6-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DDC11C000A
X-Rspamd-Server: rspam08
X-Stat-Signature: by85x954shy3h1mcm6aa4cmkzpn9qxim
X-HE-Tag: 1772221400-860752
X-HE-Meta: U2FsdGVkX19rbte0p4nxFGZNPxeN3x4hvSUUnQHa7X2fx3t9jAIcSBRK05uN2wRmu6Ce7zB5sl5FzpwK8zPN5TzcmZsjlMhznmRZXwic3TCbJZfOdZZRHl21LNkefw5ydnEVcpCF4NReADXvCHXFAxepVsED1UuZOBKeCU8Iy2o752vgI15+igT5g5YV/li4atcggWZ2uMpnuon7fIVXRskodNOK4389Zqx8sWp8giT2p6XH28CrSu0sBhjVNWqctTFOuav0PldjEL3AhWNwwQHa0ZHPwCfga2sAD3LK/RWCn5gDqV/Of004w1SyY0wU/4XI1NN6Luyky9cRuQ8qz8m06OSZdcQRZand9iFxVUCDVuSn/oo+iBYm32S8bUuNdY43OX5hdqMB+9eIe/+uZGy/XtnA09KibjZd8p7xescuuYWP6zaSsUBsN/CyCQ5WOD7ugp1WdA64N4H7o6Sw/OBA8AfdL7+Q7YqnlnzqPRlItNMfVKhFunAv0tTizeyMFhTAmhs+nf6f0Dgt2nwoG74Gq8yDjzPNKZHB147S2sqEoAgGEZfy+h3QqNeynUk4FNHv+N9nnZW6fU6yVbufLjCWBW6R2S/YyYPtPnfQuFoKJZGk42NX4+HXgvwOPJ9Wt2IRdh+jGAkRexedoUFrHz3wr5nqyR2IPxmfI6R2mcQUxas0rX95X6fFinWH6BiiSB+6+uXZ1I/eaWYcfynYYc5m3TDGX8cS/xge83Zfb3ZfCasdFX3KFGI/quvFvCYkakviibrupo1y81nK9tLIgABWNh9wDhTN0BZMlrZOBBsCN13qQ+gZzucqEEbuj++LtrwulNkIxnDGqPSTlPMfFY0xZvy5BO+0QvJUlwAezNT52BAkHtcdxK6d08uxKpD+8uohUlrmh0t+7co0YvgmlfYpai3Pk3sCoQ7KTkUZMoazhht48io2bPHRu2zvr8ghFXxjVprvgzlQgky5xWR
 1NC2odDy
 Tx5rRVX0xVk2ybXxao1PvDTfAeNQywHfncpgSUJymU52C1Fb1tHCIqvTHklU2BSxo+yK0pGEbHxLfyOpVoIN+FLG8RoQGs2UnCByHR+B5cpU/F6F7NQT2KH6VFqVR83bx3iQT4jIUhHrgV32DMvWcwPr+gVONySo0It7W0iKtwn7BColR5l4vpNsbolDyGjID6rtj4ucQZkZeiOMW8F/UZmq/IvflWCQuQshj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
struct pages of the head page to be naturally aligned with regard to the
folio size.

Align vmemmap to the newly introduced MAX_FOLIO_VMEMMAP_ALIGN.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 arch/riscv/mm/init.c   |  3 ++-
 include/linux/mmzone.h | 11 +++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 811e03786c56..e8fb2239a0b5 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -63,7 +63,8 @@ phys_addr_t phys_ram_base __ro_after_init;
 EXPORT_SYMBOL(phys_ram_base);
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-#define VMEMMAP_ADDR_ALIGN	(1ULL << SECTION_SIZE_BITS)
+#define VMEMMAP_ADDR_ALIGN	max(1ULL << SECTION_SIZE_BITS, \
+				    MAX_FOLIO_VMEMMAP_ALIGN)
 
 unsigned long vmemmap_start_pfn __ro_after_init;
 EXPORT_SYMBOL(vmemmap_start_pfn);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index be8ce40b5638..492a5be1090f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -92,6 +92,17 @@
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
 
+/*
+ * HugeTLB Vmemmap Optimization (HVO) requires struct pages of the head page to
+ * be naturally aligned with regard to the folio size.
+ *
+ * HVO which is only active if the size of struct page is a power of 2.
+ */
+#define MAX_FOLIO_VMEMMAP_ALIGN \
+	(IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP) && \
+	 is_power_of_2(sizeof(struct page)) ? \
+	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
+
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
-- 
2.51.2


