Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9A43CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 06:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58C758E001A; Mon, 10 Nov 2025 01:37:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5645B8E0002; Mon, 10 Nov 2025 01:37:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1E28E001A; Mon, 10 Nov 2025 01:37:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 38F2D8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:37:41 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4FEC140C38
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:37:40 +0000 (UTC)
X-FDA: 84093741480.29.5E44086
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 435B912000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:37:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762756659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=ow/f6+py7CCE7jnhdS4aAc135No6qFP1V/T03/GSyOU=;
	b=QgVHr3RlSOMFiAsmdUlBbKWG8Cxj20Z6vHjeZyzWG4BzGljcEyROJCtBWW12FOvqyx82+v
	QCz3LRalHK1oNLDDzx7K3vktqTWfGmROx5DLVMJZojyCa/Gn7pgEuDl+Z3rUOLS0UtJUt+
	L5SLqqjWAgIk463Q0+lZwndzbHwdaWE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762756659; a=rsa-sha256;
	cv=none;
	b=e1kyJrTVs8ds30k4uISCXAPhtrsgyhTKDDAq88sti554HO9i8ViBDGN+qLmDZmP8F3fL0t
	+n93p0iG+fcx7Ij/Hx9dw5rz5YJG0wT4z89I9+ZM26P2jZoCpxK1wurN3fxpfeGgZoRD07
	ebH0KOlurpU0ojRViVlA6YXwJptKTPE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7032A497;
	Sun,  9 Nov 2025 22:37:30 -0800 (PST)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F02B63F66E;
	Sun,  9 Nov 2025 22:37:35 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: vishal.moola@gmail.com,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/ptdesc: Derive from the compound head in page_ptdesc()
Date: Mon, 10 Nov 2025 06:37:25 +0000
Message-Id: <20251110063725.3118037-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dj9knescnymuqo4ybtnkn84uzxgna6q4
X-Rspam-User: 
X-Rspamd-Queue-Id: 435B912000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1762756659-454769
X-HE-Meta: U2FsdGVkX19EYqy3wl76m+jurtANBwX7+gRejKmp5Nr9IjQXgGEYvlZ3a6Sjaksr0VGgL8TcUdQkLQrI6zCfn1VSy68mZdC/8eU82Cku0n8eYF9o82yRKDDoe0nY69fyQvryAiVGnkkFAhLEL/ESosOVEE19mhCiIHuBpRyTzwzz136U+z4Y4suDA3RYyfne/Tb1vTOujtSHP0f4A/jxJ3rBc4EIQloDEh95K3rAM2PX6LQEBLAKzwxFH3rS4TogYHkm4s90DiC0KtPhS0plr1zq8mjVPFLvi8VZpt/s1sGEfHRxUw+0TB/2+jhD69MOXFAipN4cvkVA9zGVIt+OqeTPVMdN7d46KABuAkV2QKfQRIzJwDEuwBSigERZLmUk7l9aOI6R36BOg7nNzCziOXbipnwOLDgZS1UJn3O9AqHjR1COlnyVQM5QTKibJrXmkBKHEs9uGq9MkUvUNX3nv15uq0GMscO8PeXZZ0ao6tzcXoZwY+vSsz5GNc9StJVPxAiZ9nTw6jRiMqOX7XXtCzuS0fN1vqfKknvq08nO/7X2sXyJ8ucGLzwlA6C489o1jvd5eOxaWGAJlzTiCThV5KkxgX/uWrgiZs6JkMDAwIln0KniNB42UNUcsKohnbfCQis7bBSzjQk6BmeVwrn/LjshUaOa6HKtPGzAa853Yg+ZXoxBe5uER4EkvuMGy7dHRjddgEAuo5XxhRQvV+BL9ktDuqcxgyukr8lxsSJRiX0ChIPSckTm6b6CwUsM1dl8Gp/XeWyTz/8Tvc7DtK0oTxxzhXtjlceUIQkF12sLPwG/UKMWZsnLFDSyTUR6l0YkN+IDuVxgPWVukevD6IK4T9jBY4pmyApdneDaPzwLfZjCc+9IqAK+5HfYEV9q3sRVG86K2MpwythAVKnDNySQyPQo0vunNVsypWfW5JIT7lw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct ptdesc (including all relevant helpers) support multi order compound
pages. But page_ptdesc() coverts given page into its own ptdesc rather than
deriving from its compound head as would have been expected otherwise. Just
change the macro to fetch the struct ptdesc from the compound head instead,
so that the same struct ptdesc is reached from all tail pages.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
This applies on v6.18-rc5

Found via code inspection. Apparently struct ptdesc could represent a page
table page which is multi order looking into helpers as ptdesc_nr_pages(),
__pagetable_ctor/dtor() and pagetable_free() etc. Am I missing something ?

 include/linux/mm_types.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 90e5790c318f..f7107bc55d1e 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -604,9 +604,9 @@ static_assert(sizeof(struct ptdesc) <= sizeof(struct page));
 	const struct ptdesc *:		(const struct folio *)(pt),	\
 	struct ptdesc *:		(struct folio *)(pt)))
 
-#define page_ptdesc(p)			(_Generic((p),			\
-	const struct page *:		(const struct ptdesc *)(p),	\
-	struct page *:			(struct ptdesc *)(p)))
+#define page_ptdesc(p)			(_Generic((p),					\
+	const struct page *:		(const struct ptdesc *)_compound_head(p),	\
+	struct page *:			(struct ptdesc *)_compound_head(p)))
 
 #ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
 static inline void ptdesc_pmd_pts_init(struct ptdesc *ptdesc)
-- 
2.30.2


