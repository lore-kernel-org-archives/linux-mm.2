Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D30251039880
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:43:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE21C6B00C9; Fri, 27 Feb 2026 14:43:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64F46B00CB; Fri, 27 Feb 2026 14:43:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C88036B00CC; Fri, 27 Feb 2026 14:43:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B02EB6B00C9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:43:24 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 70D5E13BCDE
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:24 +0000 (UTC)
X-FDA: 84491260728.17.206B3F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 57DB440013
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:43:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IZEn3CfY;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772221402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grL/itXWHHkK/vIJd6j96dBmaq0HO10oPmtPqnoJYhw=;
	b=M5MptTR0oIJYZ21CTSXJrfqzqW3fXvNi09N+ZIduSR+wxCwe8vCs9FKY62E14J5UZUipqE
	mhY9t8ALXiSLPlkZ4BoXH6htNTV+OhubBBzqu3k75CC0sLHgkdYt9NnN+tkGlYIlggF9X9
	sEWZ7npt2R7V2OclhN8XYEqRUhpnSLY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IZEn3CfY;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772221402; a=rsa-sha256;
	cv=none;
	b=HgK12TOVsWMoTYshGr7yXu4Q+b70+TNU5wSUvXHQtbTaHNuOzlxUOZPXVN0Zrx8SDfKkKk
	rX9+dJi3HN/hq42zUamASJZxQDYSb6oXOJ4QCUfZV9UTukW3F8TpwY6rFgQlJgcwULKNpW
	hi73eVrmkFT52kWMMWnEDlZOfkYRE3g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FF7C445A7;
	Fri, 27 Feb 2026 19:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEBEC19423;
	Fri, 27 Feb 2026 19:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772221401;
	bh=dDlhIg1ZurYJ03ybCvzQ/8rd/HYYP+ChnQ3pTqezzmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZEn3CfYySJZGovC4vlaxPB3NGKdzK4+qhUkwHQsXqtdKtDp1jKJKJk5eWrgLnfPN
	 0IQmtBctXrgxdAKCwcd0vfhBmfFsLhf0bnwz4P6X0OGvMaRVbOAnuES08WK108aBvN
	 7ivHob/OdIeAxsjuAkTZ538lKFXcbm5VQZ5LgMEcJp7QZF84YwjgD1Obmoevivsgnn
	 5cJBYdM6rTM2qZsmZx6aEjs6KxqQp9YS/9TG9agDbVWs0y9wok7oLd4mowRA04Yj40
	 Uod4rqvakpYgr8DG6eSJHU6hAt92Ea6OltOQ3r5YhOuJhQrqx0X3Ifr+mKMjj+VS/R
	 mAjDhOOHiGOEQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9FE40F40068;
	Fri, 27 Feb 2026 14:43:19 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 27 Feb 2026 14:43:19 -0500
X-ME-Sender: <xms:1_OhaRPXUM6uHC6-8JSTmW2LGRPmB3J2vh9PEUOyJ-gO2y7bKfxa6A>
    <xme:1_OhaVOG2DbkytU37ZM3MFun2NppW0vI57Y-oJtduP2SLgjrFD019Qbw6eYOmTHEM
    KZQLs7DNhlL_rWdrxGYeVLmOfU6pQGx_bTIwgMCTYNot9tneUeg7u-C>
X-ME-Received: <xmr:1_OhaZIWh-6Dgf5OGz2a7QMtZ7DP5BxvO8_H5Rpir0oDBMunxxDxSWBS3MKLbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
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
X-ME-Proxy: <xmx:1_OhaUuyHj0uktem_Qy4Rv3xLvqDvP0Et7PmVpH6YrtlxG55VEaJ9Q>
    <xmx:1_OhabHPsH1nxKzqwO_9f4pN9emiZR0PmAQtS5SG-Nh46TnpGH1JTA>
    <xmx:1_OhaTPccoA7PJ2IVYn_eQY9CS8RQTMMoVUrJU8xNOEJw_cl8tJBNQ>
    <xmx:1_OhaeFzyYlI2_8HqwvUL95FggnLcWjVMJaqwL9zVzAsspl38sOQ7A>
    <xmx:1_OhaQHbJJWNI6fzoZiRO6KTyVyl8wRCv-YCrxTNmsqZJ1Eo-TgQ8DHT>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:43:19 -0500 (EST)
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
Subject: [PATCHv7 06/18] LoongArch/mm: Align vmemmap to maximal folio size
Date: Fri, 27 Feb 2026 19:42:44 +0000
Message-ID: <20260227194302.274384-7-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-1-kas@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 57DB440013
X-Rspamd-Server: rspam08
X-Stat-Signature: yd8kntdc7uxg3he8ft8h7ca3n1xsitzb
X-HE-Tag: 1772221402-345607
X-HE-Meta: U2FsdGVkX1/WYbRnaYxNGCi9na/eI0g7w7l69muJUi0NzWehuQrV9lkmTTSopnMcVC/YS8+7ISEMrEXYKkxCCFbBV4e3ZKLr1/rVvdqJI9WFpZEoz6xzuMd/688y8G5CqDJI9IKGWD8jnJM1BU9fcfJKbrNAzyQ2u1DHF80pxw0c1I8PvB+lKTHlZkRjBSowH6NbsUoJRQoNOGj8+bqpNLmC2EfvqRaE7m71Ka/Hi/bte7SLSfW63Pjp/Oyc4cm7J+g0B7MHFX1LkbXRJ0qPVcHebMQH0PTFRPUBd8SaNuY423NRRUliWKt+b5CD6Xf9ehw29E2J0TCcoQB+OUL46YafXJKIfBNSV1ILLM0AxtrhhlVK0Vgzh4dGJXeLGvOnXW4aWbL197HZKnbFw+7JvX8ud8bKRzhNgP6cvZZxzr9ua+Up32btb8r9T01hJFsia2Pt8hj0jSdT/EAH1b/f1ol/QnTMtv9vUTLJg/bF4wsOggepBatQIrhs56maBUQZKDYXygQzIAgIFAMPD6flCWXzhsgChCR8PJHv+GPa5hz/kSOIee5euGaiPxKdsJfSkpZJGO87c4iK59mjSlnIqi4mdwj0SYkpPX3BFGBx0v0GS9tAdl0wG6fgvAcEZDUEp/Ekt0CpY6YUWo+QXk9S/U58oOdysvKU2SVaaDOdnXPViI+NBk+YENJaK3fd111LdUHT7s4j70NHn8D2YQMtv9nJLoMc4y7p4JMHErFay2/vDMIDdGRII/J2pAWOI7jcb+2efL5dsqFhzbxK4yCXr6XVJvcFSTNXK/6N2aRl0qpKPG6eSiH1P1KJy3gX72rHFIROcJxIT76Rglj0jJpVQANBkciNr4p4ZXQsRQa1A8oCnQOUM28qeZMM5pX97yNxJjZ57IefuAWTCZFEls3AhFJTHukzkC9KaYBcgh3UOjJU+8EWww3sbx2M+VBtmDz9rlC/7b9Y/nBZ+pjPOpL
 UO60ALUE
 XM7wvqVuVNkbsVTNdCbs2QyfEtU8gdPJAFPUX6Q7nelC+mRr4FmZZGMhyPT0eUTaWK5U26aaYocam3QA52On6hgAjIKzz7fwlTFD7NkY6jQozTHP+7hLV/tStCm8GyJe+LqJGjjF/w9JtF2Tla6ynDGSsnP8nAwq96zwnieJmZJTgRjlHF+DjF2FfSb7Ob3wixgByRHQLOGD8834loBzcPpJGfzAaSgk0lKqmxXG1230maeRfCWc9DqiESwc2ReRFOb352VnYS9a3AHE=
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

Align vmemmap to MAX_FOLIO_VMEMMAP_ALIGN.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 arch/loongarch/include/asm/pgtable.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index c33b3bcb733e..ea6c09eed2e7 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -113,7 +113,8 @@ extern unsigned long empty_zero_page[PAGE_SIZE / sizeof(unsigned long)];
 	 min(PTRS_PER_PGD * PTRS_PER_PUD * PTRS_PER_PMD * PTRS_PER_PTE * PAGE_SIZE, (1UL << cpu_vabits) / 2) - PMD_SIZE - VMEMMAP_SIZE - KFENCE_AREA_SIZE)
 #endif
 
-#define vmemmap		((struct page *)((VMALLOC_END + PMD_SIZE) & PMD_MASK))
+#define VMEMMAP_ALIGN	max(PMD_SIZE, MAX_FOLIO_VMEMMAP_ALIGN)
+#define vmemmap		((struct page *)(ALIGN(VMALLOC_END, VMEMMAP_ALIGN)))
 #define VMEMMAP_END	((unsigned long)vmemmap + VMEMMAP_SIZE - 1)
 
 #define KFENCE_AREA_START	(VMEMMAP_END + 1)
-- 
2.51.2


