Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB8F7D2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 08:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 407206B00AB; Sun, 11 Jan 2026 03:28:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0AE6B00C3; Sun, 11 Jan 2026 03:28:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA0C6B00C5; Sun, 11 Jan 2026 03:28:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 15B266B00AB
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 03:28:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D55C4B88BA
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:28:29 +0000 (UTC)
X-FDA: 84319006338.08.7FA2015
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7575180009
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:28:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VYPj9b0f;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768120108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0d/fgmJzUuC3jidaBzidx264jdRyo/z9z8uWc0qcsnY=;
	b=ZXQzChlvtJc13Uipdk1mqwdk5y137+w+XnDLvuFkibzQwAxXMFTbnDjhiyd339ho6AZEmk
	+DQFHT8jUfzJ0SRmvKjV8dKm7iRRCTAZxE6JyNAOBIY/DgQZhh+XoGNPln+qfp8OEM4sSf
	dvosZ77Bs3xNispSy/DSvafVLg+4aTM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VYPj9b0f;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768120108; a=rsa-sha256;
	cv=none;
	b=tTUwohZVpgKAnqmdroF2RKRTVHkgD2zJ3SqoIngs4II+uohXdGnvDacjwERflUErFiwzE2
	SfXzsJA7JGiuJXqqdOHcIo6M6Z4ujOgnlkk7qJgaZn5dbKD/Ky2Ye0llNKBIWAXEHXb7Cz
	4ZG6skGORJSM57dIB5FPgHerM3RQBEo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E777D60122;
	Sun, 11 Jan 2026 08:28:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098BDC4CEF7;
	Sun, 11 Jan 2026 08:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768120107;
	bh=kMKUIBkqL1O4S3ZKa4SfOsA0W3WTf/VpmW+w2Z3QAsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYPj9b0fMhtgyRG3tBVmUyXLPKxdmg5x150SQusjLBH6QHSmY1li0V6oPCPL6xqZU
	 MEH229e0ZoAbJmeWNRLP1sB8qDlLHorYQdPuaHyK4EVKvweaUln12AkVcyJwjAVueU
	 jQgOmVx+665lxbPQD+mKBi6zrOHJcbjSgzO6VzA/F64XeumQv5zG8ZIrvb2xtg/sTh
	 4EeqXNUXciJtl4cNlL7m6I36LbPHvL3zM8JoGAdiJetJld4sNjuiGSfNmtjBYZ+NOJ
	 CUQK3WJ9+t9B/g7SLLj+wsdLaKXwdPiOjft1xYqs5eoseVy+W6YpOc1XzTcKIp3R/g
	 2XT1tnE6x3bwA==
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
	Klara Modin <klarasmodin@gmail.com>,
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
	Ritesh Harjani <ritesh.list@gmail.com>,
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
Subject: [PATCH v3 28/29] mm/hugetlb: drop hugetlb_cma_check()
Date: Sun, 11 Jan 2026 10:21:02 +0200
Message-ID: <20260111082105.290734-29-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260111082105.290734-1-rppt@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7575180009
X-Stat-Signature: n7jggjne7hbx1yfk8woo9mts8asws4sa
X-HE-Tag: 1768120108-351534
X-HE-Meta: U2FsdGVkX1+abDUqjkMK2cGfHtGgjewC2uvcr/EwzAGn49+9iugzWj23PvZxvLCcvyfqu2Mj+srgZlPPXHxYuBixw2WuKOkaH+XvVoj7ROusIlBzuYecP5+DNgrl0oMFoKXyPdTNQ0yH8f/RUUKapwwpx56145QtStaTHmi9yJ+p/qLX51E8B4uU/qtinaOdRdpJhFEYIany8Jg7K1LU8KWCN3BrH7g+c+rsme8PGz9klxiLzpjITx8OWRJ3aY/JpJD4SoC+UdznZ57jkyZ7BCgXYK9GWbX3sIJP6zKWxr8+d0noRLNv4XHxrLXiKqpm4gGJyIruknvxMFdJlIX+S8l/qxz1qBCxBXGF/ECoC31MH2KkaleLHebPdGDRL9dSPvCQHVaAygKxPkr0JOZcEDKLwb094vCEKXO1RUpz1EH/RrQIPOyclX7Ivc+sInXlcksv5+FufY9VX3mQlikIUJ9ApQlj1rOZ+p6Pw+vF+RcKdELMHOcvyQeO1Oi+Bz1tHP2w4dqwa6oD1/oPMfvloFfOd8WyiCW3yBCl2+r8IArFHpUENz7tMa6op/YEEt1fL5kXR0Rws/jBWiD2W98ChkfjpwQT/Ew7NsbCWroQYPPADS2g1bURUui9u85wLSjSdpojVz31BJW5SMnixfn358dNtPNTh1YPwrrXGJWKPaxFqowFMCsLPs1Q0xDOkAVm5FTc7MuJMxHKlwd6Q2bIssizSqUY6vcK5V95rwNaWJYBXO1PfldTk+84uF7vq33MGX6XyP6tLZY3+cCl9B00k+kbyb/wJafFPaNvoGZCFISadtwRNwK8Waobe3ha3MeA54Lb1BuFXtmJCyrYLIwEm1/APo4h+s0qXtmDltPUrImEV5MDwhsgrKU/QMNurjVFH8du5DTYEqk6FHwjBxbRvzMQ1SD5z4h43qSYL9z4Z4Zi+cU5XrhaSV+GauQftlyICwgkNho/CwyHcp0Zw+B
 9lM1ZvxQ
 JQN0nWbz0fGjHBz1bQLyLSNGMY+TmMF89jlPPjSJcFJZOhq7Mj+rgCtHPWEIksSapM+QmmV0VUSdTcES4xYbV/sZM04S4JzA78hXwZOQythBt/AOlZURrg28w8Q==
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


