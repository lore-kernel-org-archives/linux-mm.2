Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95175FA3729
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 07:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB226B00C1; Fri,  2 Jan 2026 02:06:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060196B00C3; Fri,  2 Jan 2026 02:06:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84526B00C4; Fri,  2 Jan 2026 02:06:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4FB26B00C1
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 02:06:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F31413AA73
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:06:55 +0000 (UTC)
X-FDA: 84286141590.23.8C2A7F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E535E80006
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 07:06:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TkDnmotZ;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767337613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0d/fgmJzUuC3jidaBzidx264jdRyo/z9z8uWc0qcsnY=;
	b=2GEo90DoUqpWeFEIWRb4Yy2SyX+4TEUO2X/24fWxK2mL/MwoRmDz39k09We+4+HUu/Aj3P
	dt05fTQstW0Wu7yqDGT2mC8+UhL8BrEqBuZWhaoQ7c+TlWtqJ9x1qSf9Nqf4xeWBEGSsY6
	1dZjhiZKAxTCfQNN6hNfFWTs7sUSwZI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TkDnmotZ;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767337613; a=rsa-sha256;
	cv=none;
	b=l9IUsgj0FoVVaIYcB0jDsldQXOJpgbPSNrE2huPprG1zxes0Euzs/rq7ExFQ2xYMvi0AxN
	KR/f/AUWwcxq0tOeXZfa86gPtKM974CNIWBMRWmRV36GFYt0ZNIld+wLd8sxJ7TywXLjbj
	2NWJb7HPdDXTjMBbZvMWvG7lCzAgGqI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C56A60017;
	Fri,  2 Jan 2026 07:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EEC1C116D0;
	Fri,  2 Jan 2026 07:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767337613;
	bh=kMKUIBkqL1O4S3ZKa4SfOsA0W3WTf/VpmW+w2Z3QAsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TkDnmotZu/YdNywK+Eq/loOeeJEB97xyKcnXixh8fkgNeSCwHVL6QnzxLLoAyErWM
	 TRj2JtHlwHjDoVrWQTbaRj59/J4jnFOEokG7LKVo52RjzFCb878p8ePaRTeDzh2Si0
	 3eLbVEoXK5/mP+D2jyewADhIDqxVGI2EpIIAjd0Elxy9Vlp2N4rNc/JsXa0N5H3giT
	 0w6d0zO+vezRlwoSkgewur1fcZo4H7c1PPtods9nW8WUnlSV1SZFSxxt7kyXrS24qp
	 KUWoXUzjudgicjqcHDPCRzEqHWPBB1EWTVX3Ta28eX8TEBh0H1yNHWWP6NYEYDqBll
	 SVfxF1n6SYoTw==
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
Subject: [PATCH v2 27/28] mm/hugetlb: drop hugetlb_cma_check()
Date: Fri,  2 Jan 2026 09:00:03 +0200
Message-ID: <20260102070005.65328-28-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260102070005.65328-1-rppt@kernel.org>
References: <20260102070005.65328-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E535E80006
X-Stat-Signature: 8fc5nnb73d77ctwrd7jwjwr3mzmqnetm
X-Rspam-User: 
X-HE-Tag: 1767337613-363907
X-HE-Meta: U2FsdGVkX1/T2OjGL10fy/zNZKaiDayx3BUJ1bnnCFbz1uFNbGzQqzAPpYg4Hq44fxL6LgPud2kG8rETGmAvplNz6BzcZoLNLxBVD0I1zcOiHJ51Vp8SXwgwTR+2aKZsSmOULj1Pe+NuZIInvUKju7nsMQYfxJM/xdnLVZDt16QpG75LekU8qLPa9KMsS04aJzIb3fs8vzLXBR0AeJYECLaWmhWUXx2qdjE7bqEmvpvKhOssf3z3yG36t47dXVFFv53hzOlQedNrdsL820MtDKK66QvXPah7fIm/lnpT6zBRDcHkQAt3YQ4aVSLVfnAlN4L+2vbXf/7ehoA7fiW/I3FUBDQNmTVNFyggtRUEIOcUVy7d6GjIGvP1SQ4CKvqJIm0sqyQ2ggwi+iPcqo+ZRC7tT1nG5Ehg6suHx4Mn1pZz5EDi8uF3KfsE4Jxim4HPQGKO+jaViZZA1WI6S33g/rC1ak5UjtiqLm4wnh3rk9U/Ta3P120rIEY22GBiMcpee9Aa9p+qkrWMtKpjRz9WFhEe3Llz6nYUvOXXoPkpV32SjfDD6MUkTsemL3JLR8qW0KjPNxkJVBKk68IYR3iMQ6RB5Zq2ktW5A0SqhH7+dFwlC7ifHrDn/mWBL4UNrCV/+bCCA/TqwI5maO/YPWSZBqkZ+EO7fgoEoawc7Q0jsbg3IXWLnRjlKgbi+4YfH0CcBjQog9rh5Y+SZTOKCcRnVT1jpcSx72SmHulUZf+kvqEu6lJ05kxY/qMklnWjok5Erkpxg+ecFENunenddnymD4toI5nZgZzULIZHv2nf4Ng8hSr65CEO20v2aUmy7vyug2Z/Tt5qGHIoKE7QnecPaBxGyMF/u0KycSKtA2qkjuMm5raA55TMCMA4bo5YAWTUVIBhMn5+FDVjFwpiKqm/NgNKvJCO9EvjAPwQR2kqYylEQ2UErqToTFKRwZm5pe+mE+d5Y663SjeyN+TdK3x
 BnNvq884
 WRmQc+xXLVv/iP0pot+D5xd6TRrd6D/wFAbfqDHIXDKNRZ3BuvzNKgW70SBKg0G28N+fIQK5N4u089vPm/6+/rmWBXev598laYjvzASFN8tgSoFh3bVIY/YrfT89zGuCq9ee1RplbNBlLNurZv5BdwA3Kgnv06P3vu5cHXt5hjx20w0o001T5pWKfrOm0Y6IMUNiHyU9ysbLoWbcjK3+BbRZ0mycpGXG90PARAMYBjK699Sv+D2DpJ3wtwt5ui15CNg+Pz1m7FRySSCLdW3u1ewKY8gIjVArpqi1VSov10kKb3me6Sz8sAs4kDw==
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
Acked-by: Muchun Song <muchun.song@linux.dev>
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


