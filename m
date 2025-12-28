Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B235FE784BE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 12:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C51E6B00C3; Sun, 28 Dec 2025 07:46:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182926B00C4; Sun, 28 Dec 2025 07:46:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2096B00C5; Sun, 28 Dec 2025 07:46:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F10CF6B00C3
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:46:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D74E9A580A
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:46:44 +0000 (UTC)
X-FDA: 84268853928.30.8A45C08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 28E144000A
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 12:46:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qdL0kS/S";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766926003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFDXLTGATkroZNEN8JNWl0z6F0M9aK5uk6oqTTiy5J4=;
	b=rJpb5fJ+aOfroFt2sanWEZKIEQVygn/fpRvyMpbCpm1BE15iy53bjplxvJRh7aa4Mfax5Q
	8Q+9D/yxj9IUsBMNWSiWHwdbdogG2iMMmU4EOO7/49g4gGlqArIHD9t0Ea7pVTj0/OmjU+
	NL47k6hkXCRQ660y7NfkgTJOLIgLSHw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qdL0kS/S";
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766926003; a=rsa-sha256;
	cv=none;
	b=Pz7C9aljlZWbCf0k8vOQ1eo5GZhd6uhkfatPwy7ZjUnvw/BQaKUdad8dnYo5L7QFcVghMn
	nPbwcQpbeQHpSfB67vBKXKEYfbjH0h21L06OJWuHjNhqZMbMZ4GHz1Ne2SWdwc8lR1ucCc
	IuWXqAVux2NJED/BUadezWueXbkX8sI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 50CE24378D;
	Sun, 28 Dec 2025 12:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC499C4CEFB;
	Sun, 28 Dec 2025 12:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766926002;
	bh=HLFdL0b2vHYE2Es8eysIP16cx1LQEF5ywfNPEf+XyUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdL0kS/SmoVKxl3WK0KKH+Jldx6Q7XCWF4V+7VX9pSzxoVIkAcP2FPqqmEDdDdypd
	 cLaoKUTUDB4h90YuoSE8146Xk14NH6RwNwsudZVlWBJbL+a4t2Nqpsbk3k2ARV3+N2
	 eID7ge2FU6TWbxLFJUWNUQEm0iiU1l23JkDPBTcH2jJtDq6J+FeokyJzunQW8y6L+G
	 6DbBTj4JSTeBjvfu66zvi0Ev+Vp1cGy39Y078vptGbfRjWTon98SfWpDR6jBxZ0QHk
	 a5h2+rfUr8yvB4s2JvJiV3TjJJQjjmTYiv3y8i2jyTIREdfgCO9d8lClaXU31YpnjS
	 AuacBCA8hM+Vw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Shi <alexs@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>,
	Brian Cain <bcain@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	x86@kernel.org,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-mm@kvack.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-um@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org
Subject: [PATCH 27/28] mm/hugetlb: drop hugetlb_cma_check()
Date: Sun, 28 Dec 2025 14:39:57 +0200
Message-ID: <20251228124001.3624742-28-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251228124001.3624742-1-rppt@kernel.org>
References: <20251228124001.3624742-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b9fhua53f3zcajg7yjwrgmrq146mnein
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 28E144000A
X-HE-Tag: 1766926002-771262
X-HE-Meta: U2FsdGVkX1+hDldg+Qcm3DZ/wYRB+cjGvpKPRDj7K0iJ9umEqmFetBuEMi6u0IS0eaQstBBfzolDUvz6WFN/taL0uN1RoH71tW2Uyb3aStqBPFSf/G2t0CZPOrgDbtYyk6OyHu6n8wf8XwjpMw70f6wMqYeSInYX7A43dh6cjNw3aH4z+UA0DknKrACVn1ZwHodFZa8pp6Cw6Bras9d4rdeMW/4LLFoqlZ7hsZN86wbfFwzO51hlBR3U1b5YVBFA4t5hdUJioDUNK3TAURMtX3L74UUZ7JBeeKP0rTI1wCG7GJKv8c3c7FJ8MtHzLMKqXb/typqvZQ1dihinQ9Az1cSaa2NBpy3siFMAK6C3F49M45sVtLNVsHiwP1W3PBUg9Qh4rg8APQLWvUkJAK5OHLIhBVn4mG6b48AXJTFfnIKQiYe5plvsrfG0dzt9C/4I8TuaLL3J5f8vr1N3YPo2GLoKrZajKemPRcIdFHUalXs/JBDZnndQo8tFQFqtY9TDq68p60n6lCTQn2Q9iY6y4GD63lkXtITNy+sM1G7C54hjUurbTeqzVLLq5I/49hPRPIurqj92m+eA1n9y5ZLJbyE2I3DOXbDmIH3OxCrEwtzvscyg5rw+Xl2IezAea3m9jOX/cP9LH67Vdg32AbNLhECEvh0/JvFE9rvlSszK7ZQh14UYpBMwtLT0lqhvNRXqiPucNwjsJFmeDmZtjAIxtsoj6I5Mvfzl9A2dsbu+xg+DvB25f62Vyuny3zADxi9T/++3UXN8zZN8tZgLWfaiWVU0DpdhFC2GBQivtb0nBDoVI00IsvDY2axPZGbc3AdgBLOixPYcpOmHF8VBC9I11t8KUi+PSfIvzLWGp13Ddx0FDIu/fxsYxrmm3/HAcjHF/cs+XyF81ClwuvkSsyN3pBzwMgID1btJFI9QRwQ1Pu/BX0txip9dj1QKxLLsebMw+G7QU3Jv9WBzQnctKbk
 oDgmud0j
 aXjXgDc7KVJlWgUb0ZUEODmQddCL5p1R793PTt8ukDojqtLJZb+j8sRddq0sPulTkX9fAiVef0zGc1Phm+XOtTR+/89yHcVE9BbDc+XSELeQNcUhRAQypcxL29fRmQinM65S3YIVum7yA+4sKpS2zYqf5q1WNU5uucqzTTDTHBIiAYW5i55hrcX9MqBGeBJi7LHb8Aaba9FjH4G65e8cazfrTA5NyY8bXEDmS5uEcW7lI6Q4Zv9WO5HnFIbEeGV+qZLcRAcluJfMQJKE1cuQ7EXqX+lBdTfUF85260WQI9N6vvtph8oyVcYCNR+5g4pDW02SE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb_cma_check() was required when the ordering of hugetlb_cma_reserve()
and hugetlb_bootmem_alloc() was architecture depended.

Since hugetlb_cma_reserve() is always called before hugetlb_bootmem_alloc()
there is no need to check whether hugetlb_cma_reserve() was already called.

Drop unneeded hugetlb_cma_check() function.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/hugetlb.c     |  1 -
 mm/hugetlb_cma.c | 16 +++-------------
 mm/hugetlb_cma.h |  5 -----
 3 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 51273baec9e5..82b322ae3fdc 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4159,7 +4159,6 @@ static int __init hugetlb_init(void)
 		}
 	}
 
-	hugetlb_cma_check();
 	hugetlb_init_hstates();
 	gather_bootmem_prealloc();
 	report_hugepages();
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index b1eb5998282c..f5e79103e110 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -85,9 +85,6 @@ hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid, bool node_exact)
 	return m;
 }
 
-
-static bool cma_reserve_called __initdata;
-
 static int __init cmdline_parse_hugetlb_cma(char *p)
 {
 	int nid, count = 0;
@@ -149,8 +146,10 @@ void __init hugetlb_cma_reserve(void)
 		return;
 
 	order = arch_hugetlb_cma_order();
-	if (!order)
+	if (!order) {
+		pr_warn("hugetlb_cma: the option isn't supported by current arch\n");
 		return;
+	}
 
 	/*
 	 * HugeTLB CMA reservation is required for gigantic
@@ -159,7 +158,6 @@ void __init hugetlb_cma_reserve(void)
 	 * breaking this assumption.
 	 */
 	VM_WARN_ON(order <= MAX_PAGE_ORDER);
-	cma_reserve_called = true;
 
 	hugetlb_bootmem_set_nodes();
 
@@ -253,14 +251,6 @@ void __init hugetlb_cma_reserve(void)
 		hugetlb_cma_size = 0;
 }
 
-void __init hugetlb_cma_check(void)
-{
-	if (!hugetlb_cma_size || cma_reserve_called)
-		return;
-
-	pr_warn("hugetlb_cma: the option isn't supported by current arch\n");
-}
-
 bool hugetlb_cma_exclusive_alloc(void)
 {
 	return hugetlb_cma_only;
diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
index 2c2ec8a7e134..78186839df3a 100644
--- a/mm/hugetlb_cma.h
+++ b/mm/hugetlb_cma.h
@@ -8,7 +8,6 @@ struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask);
 struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
 						    bool node_exact);
-void hugetlb_cma_check(void);
 bool hugetlb_cma_exclusive_alloc(void);
 unsigned long hugetlb_cma_total_size(void);
 void hugetlb_cma_validate_params(void);
@@ -31,10 +30,6 @@ struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
 	return NULL;
 }
 
-static inline void hugetlb_cma_check(void)
-{
-}
-
 static inline bool hugetlb_cma_exclusive_alloc(void)
 {
 	return false;
-- 
2.51.0


