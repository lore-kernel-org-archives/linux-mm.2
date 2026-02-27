Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BA77FD530A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A31676B00A8; Fri, 27 Feb 2026 14:30:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0EEF6B00A9; Fri, 27 Feb 2026 14:30:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB1F6B00AB; Fri, 27 Feb 2026 14:30:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7523A6B00A8
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:30:45 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C1111B8251
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:45 +0000 (UTC)
X-FDA: 84491228850.05.72A60CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4686C1A0002
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pWOmVfG9;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grL/itXWHHkK/vIJd6j96dBmaq0HO10oPmtPqnoJYhw=;
	b=WrvhxtC3oBgWqAU4MIGpde+9HVsV5j+E2gDdHh2l2BnXog5HA7xLfjo6I0LOvuHxMLjsla
	ja66JYMPEWgGhf1rNIVRGFveAr3nNzbwmiMDsMa20W1Hra6auOHzWnWRxp+47A5gb9M3SO
	rI1CDZCaUNT7L80fJ9qQa4pDMPRiYds=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pWOmVfG9;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220643; a=rsa-sha256;
	cv=none;
	b=HNvyp2PAA5v7nFH/p/2cJ+MN+a58UN7jOJF0XiZJqgJYVg2dU00a2mTif1jlDH+1JL/29q
	ns5VNkKm9yZd6EFKsdab8IMou20E8WHEdH6SEyFAYJBgfnE77j+cVdW2e8CGtYvqZVka+m
	P3xcHLl7q0xsRJk1LVAhlpZQ9wrZqFA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D266B60137;
	Fri, 27 Feb 2026 19:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8048C4AF09;
	Fri, 27 Feb 2026 19:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220642;
	bh=dDlhIg1ZurYJ03ybCvzQ/8rd/HYYP+ChnQ3pTqezzmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWOmVfG9L1PtXAFwh7t0U0BJevImZgOUekUjPRBveHQm1Ghl6kiM0Ae/FhsqRUS1l
	 Bjd53tMFDTSjxZKYlqjn4zL0+O+UwSFNVaEo0IRmNlD1O8KZJmJHgmT5bMf0sWlQUn
	 LEUfhJGDUKu51//iSReNCY4a0eXjRKwOzpxWPDyAJY2sFxJ/kF4CEhPAkAMOsn3107
	 yTzgRjlPyCrh21e8rpAdKlXd8wHWbreCujlA/9OSfgXqd/5LkcBbtoj+ODwr7mxXLD
	 RbFQnDCy2MZpvM8oIgHvuQyKtPEqrwjUcQ2Tnr/AJ0vpqsQzRa/pKMe1bKpzPmLByW
	 6LTVG7oRXhbiw==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 096E4F40069;
	Fri, 27 Feb 2026 14:30:41 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 27 Feb 2026 14:30:41 -0500
X-ME-Sender: <xms:4PChaaxF05G3PS4ruFPeqrl4CfZBDukTsDkjkkX0ww5r7pPTOXtreg>
    <xme:4PChafc7zpnA3mTUcYsZf0M1R0ABoQtFC3Akvt5C_MlNYimapFQHKrZpXU17zhl0L
    43RiYrUFQsj-jA3NDZZe9NOLp6j6iTQerxzCNCzcikoWNkbmdo3mgk>
X-ME-Received: <xmr:4PChaWdTET4SMgY7Fn96q5cb-3D2uHdS4l2nsNBKTYt7P_ggbH4zNLPqeXiuPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeegucetufdoteggodetrf
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
    thhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:4PChaRZgZnAwpi58ZHawdb4qKlrjpKRC6V7XXsAcelIEKiye7y6Yhw>
    <xmx:4fChaX-X7WJRg904CQZJbtYqA_MlWebh8fOZoMW9hk7EdNhukRDNgA>
    <xmx:4fChadUepdxhwwpMA1572Y0TOfn8qc8d1l5mY5Nj5I9TTNuu1g03eQ>
    <xmx:4fChaYfmwppmk5aKQ8HiqnXf2GjRxuenBMHD3ghASM7TR4WX0SMCzQ>
    <xmx:4fChaaVRlQQyQl5KbWzB3Xuju6bQ3miKkNTSW-EQlpIJpfyJHls2M4hY>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:40 -0500 (EST)
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
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv7 06/18] LoongArch/mm: Align vmemmap to maximal folio size
Date: Fri, 27 Feb 2026 19:30:07 +0000
Message-ID: <20260227193030.272078-6-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4686C1A0002
X-Rspamd-Server: rspam08
X-Stat-Signature: yd8kntdc7uxg3he8ft8h7ca3n1xsitzb
X-HE-Tag: 1772220643-735089
X-HE-Meta: U2FsdGVkX1/VwxR2JQrjcg3EAlg65xMyRk44h1Oj4BCtDkH6jLgucSsiQiBH21z2/pcAiw5/3jiI1zVusgXSRV5kDs3/r+QJonOQIJWfF+Dxs/G3t2E/J5UDI3gpLpUi38QUXXyj3fe0nh/a6Ofi2vIg/H4cD0VuaDRNw+PBpJLkLDbh4MU53fqAG4rnhT0GEOFe38NQLcZLf29aDG3GLa56uUsYYjLP9uCL0m9qGvKYdSjMVJJC+ZWSSuTil5enpPmaCOxaIsaIkHRMWZ3AjjQkf7Q+rUpiFGyMI9p7W3ysbL8nXNo32/BJGGzpeBKtyyrGDvB6MT3SzgbhgbZ3pmdYm8CqT6TdO0ZwErkR0ERHCpxXMspF8aLwakCSdrf2N3bYWgGiH4+qTSJkmGd6344mhG4eFPDsC9Tjok4NhEw8CLcObcUJos2sS0g1J25LQVRfNVtuJe/JqvdJpMYVtC8H7KUiw9G7VvvQVCuY+t4fhiYl4CByE/x+hlEJVlHwctC5C6/I7ZsdPt6/Gmmv2tAEXIw92MoS4PaPsGK9SKrw8D3v2jTB34SjXOvnCKwAT/nefBN0aYCNE3Jyt9DvOUmbK0l+fuK5CsI9IOCpv3jFBGLpFPx6HaO1xgmv0L5VpjzQcDbwz2Qypxlsy/WrMIjIjCPeyG4v4qefX4bahFy4nUSdb46ibpGqbmE65Wsq01HZOR1bSWsJGSDw+N39tfUbipPSxQFU2KBVWNgi/NDh+dNzO62FJGV9QyEY5v0XvDXepqsSCtWT1mwMw+fONNIz2P9KHC7pY8nbGq9I70OBPuYn+yhRjpVZKFtLHJEGCVZav1+tzfbcKJb7gMNPZpT209RYdinYJgOrg6ZBygyt8D0Leu131N89gPnJOeWbej7nFajEifaUIlC4KuEJeGbgzUk/SzEIdhHSsSj2zkDqOy0zPvdMAUqUCV+VyflNNPyUiPiwEEQATIDMVJY
 20v7zFUq
 90yVDMvqPk7gxZ1632je1M4TuucTmGgFSy6Q13mQR384BJ7URdnLbdFaws82frQ2AuBO94iIrfeGE3RCZuVLOZTfJ6qgWngIurFhVnQLT5DDntSNVPU2dV8gc+nsrqNASPmnhBaLdyPcEf/ONBCXVweRhxt4h22Og8aNPlTMZcaIQ4h01MRySPc/FujbRs/FJITdeIQY4z0FePoAJ6/qtxdRCdgt68VDcbDqBYKlbRJbzWw6YFHSWogVb04odgHuHmqUR
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


