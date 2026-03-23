Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85C8DEC01A1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 07:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEA026B0095; Mon, 23 Mar 2026 03:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC1F86B0096; Mon, 23 Mar 2026 03:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8386B0098; Mon, 23 Mar 2026 03:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD3766B0095
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:49:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 96A645AB67
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:49:48 +0000 (UTC)
X-FDA: 84576553656.11.7EB43FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id F34EB140008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:49:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ApW+Ttb+;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774252187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y36mYnn//4FrI2ubOkjWYg4TmngNW6rB3lI2di8xzT8=;
	b=WlADccM9zmMNzW43SWQ/0HtKA/8/NidE6ygztaPuetPikdSvVRzhBO0J860zapL8cTJuGk
	rjR4ZRk6ccZNthTi8VrVb2tr1f5lQNpX36GRvyPNYEcNLTxywC0QSXQVbkv1IU6WsK0a45
	NSjTvZ9AiE4xDQ12/uUzXFaXZrMw15A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ApW+Ttb+;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774252187; a=rsa-sha256;
	cv=none;
	b=F3rVxHD+Rmz+DslA5FDN3lnozFn7Xy9KubE7DG9RmS+irsIUPQW2oloinDTzZOn08qKecI
	gt73yBw0iDqR7WuIHOZba3NOnHb7x+Rb6fxa4/4x+GkeC1h0rtTEuFi3UDngeBCowSN55j
	7FHBOsADi12r+hZ/KDcT2EFCPonlFuM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 68329600C4;
	Mon, 23 Mar 2026 07:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A752C4CEF7;
	Mon, 23 Mar 2026 07:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774252186;
	bh=oTjYKF2HzgnTzfVt/T4KR/aYoXu0jvREAeLPVzJjchU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ApW+Ttb+jFMzL2PVxO2byAuk+A4fmPJnMaO15oJq2IHN6Zecm4hgjhBgwx8npbKST
	 TGIhzz69K5K4pqQrfkuVb111Ir4KwV9TblQWUzh9dnGHx88hKymgGX1Jv2l7vvSHbM
	 eeOwB1tP4IvmYQA/ieHNVxEm4eqUCFiuavhCV8w4JZLIDlqV+RrBsQ6RutKPB1KiCx
	 CTJ9HkxBlgZ4IexKCBXnmCd9iYf4bnQmxV5OCKwv84oMEH+prH6i6fEMCUVPImpnIq
	 IFbjWI+qGUrIe7+ITN828go5miiQUt8iDKr+D1nvEix/c2fD9Fsz6E0RBqR/E2a1+7
	 j3bxw4hqbLsrw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rob Herring <robh@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	devicetree@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 5/9] memblock: make free_reserved_area() more robust
Date: Mon, 23 Mar 2026 09:48:32 +0200
Message-ID: <20260323074836.3653702-6-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323074836.3653702-1-rppt@kernel.org>
References: <20260323074836.3653702-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F34EB140008
X-Rspamd-Server: rspam07
X-Stat-Signature: 8f4d5n38r1shc74dowe1upahu51z6igm
X-Rspam-User: 
X-HE-Tag: 1774252186-804371
X-HE-Meta: U2FsdGVkX1/YYrvD8cZuuqgDBzdy1qRDPcpA1wOj17ycWQrIy09atkYLWaLsDNCYLfInTF9yMjhpryzYcMW+xZRu5nMABhZ8FA8xeK6rZPvQxOggtfQu42m6Il/7tTWorl42hBrTZTJgLBpc3E2K2Jt8Um0ysYypQb/Up5LMrUrFo6aed+ukgr1FUJ29hZVvw054Q+U1vh34y1U9GjhsN2KjujEKkSALIaPJSbYIHRdIQ2ApDVweDHqLsgXaW4rdG8omkGkNihEKF1PQcohdtD8A0baIn80WuW/Uw6r7rVfuDuZasmEMKe6NWIKUTVmvHQl0oFIGebCAe8v4feDo9JPRujI9ibnXeeGZMG0zgyU6oI6QNY/xtAI8loyhq5tiyjI0WYd6XLQwlvAbUXcL/kbt4rGo7kuVF3+gbOeINJGZ/tgckv+jWmOIHQl7ohi/r1JOVWvhavD/Udlbd9ICxM6d1X/Ww6/7v9uoGqIxBi5Jo0DF0zdoNq8hCnK+nxAuDsKPSwx4TVc0BHfkx0jXeUldmbP5/AKad6CnkMd/EmK0soTR4XJgIT+gmEotGVcRU0D+98g5kBMBekiFP4QXM0PYZx6K1SCsAxoD7eC6nee9Csls0pzpllmg5Vtn2s0jcs4tR4TRn6ZZjhOrUhGyfsnFUv8fddCeUcLpikGLECyPC/icwRpUpyvk838qrCt7JANoUTHgENt0v7nWuwzBzbcNjzRGmyEOYNl1VzlIbPHfjXoNVMYdH3hE148xeEXGlSN6ePPtn8IeIOVKQd8SYkot+rzwhM+JzlZDiCjTq4NS9ppg+CwQzpXptpYtGC9o2DSXrX3uJHfCs6H2veiZh/wBrLEueT151tz0qtdx1TDWAW5Dbhr4hSJj66YAuRHn2EsseBV05r9cTNYgl/MQEzvHECgvlT01+RW87RvrF5t6NAV8C+H8cnS48NGWC2dWdXA5LnunhcsnzfBStPD
 ld3tCYuz
 /Ls3RJqdlpjtLhyuHlrJ1yzefFO3dme1eSSUMMHCPWnVPMVs0rIV9+YRWqzmUszNLSpvLW5eiG+bMMt6hnvTRWWyLnteL9Mtl+HKBAkCDVL8OpZZECPHrjZeCg/P4mKt3yyV0fFopErLB68IXtl7ytamETVXAxSN8m5O+cMSaecOfs6wl5HLtuP/R5cF1uZR/Z3+Qhn3cPnPYt+FQOumvwmq+MaTCJqdiU+EsLxVuFyru3sqA4F0lhzsueaqQs2mLr2aox4YjZ/eM/GSwHyNMkJEiqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

There are two potential problems in free_reserved_area():
* it may free a page with not-existent buddy page
* it may be passed a virtual address from an alias mapping that won't
  be properly translated by virt_to_page(), for example a symbol on arm64

While first issue is quite theoretical and the second one does not manifest
itself because all the callers do the right thing, it is easy to make
free_reserved_area() robust enough to avoid these potential issues.

Replace the loop by virtual address with a loop by pfn that uses
for_each_valid_pfn() and use __pa() or __pa_symbol() depending on the
virtual mapping alias to correctly determine the loop boundaries.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memblock.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index c0896efbee97..eb086724802a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -895,21 +895,32 @@ int __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
 
 unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
 {
-	void *pos;
-	unsigned long pages = 0;
+	phys_addr_t start_pa, end_pa;
+	unsigned long pages = 0, pfn;
 
-	start = (void *)PAGE_ALIGN((unsigned long)start);
-	end = (void *)((unsigned long)end & PAGE_MASK);
-	for (pos = start; pos < end; pos += PAGE_SIZE, pages++) {
-		struct page *page = virt_to_page(pos);
+	/*
+	 * end is the first address past the region and it may be beyond what
+	 * __pa() or __pa_symbol() can handle.
+	 * Use the address included in the range for the conversion and add
+	 * back 1 afterwards.
+	 */
+	if (__is_kernel((unsigned long)start)) {
+		start_pa = __pa_symbol(start);
+		end_pa = __pa_symbol(end - 1) + 1;
+	} else {
+		start_pa = __pa(start);
+		end_pa = __pa(end - 1) + 1;
+	}
+
+	for_each_valid_pfn(pfn, PFN_UP(start_pa), PFN_DOWN(end_pa)) {
+		struct page *page = pfn_to_page(pfn);
 		void *direct_map_addr;
 
 		/*
-		 * 'direct_map_addr' might be different from 'pos'
-		 * because some architectures' virt_to_page()
-		 * work with aliases.  Getting the direct map
-		 * address ensures that we get a _writeable_
-		 * alias for the memset().
+		 * 'direct_map_addr' might be different from the kernel virtual
+		 * address because some architectures use aliases.
+		 * Going via physical address, pfn_to_page() and page_address()
+		 * ensures that we get a _writeable_ alias for the memset().
 		 */
 		direct_map_addr = page_address(page);
 		/*
@@ -921,6 +932,7 @@ unsigned long free_reserved_area(void *start, void *end, int poison, const char
 			memset(direct_map_addr, poison, PAGE_SIZE);
 
 		free_reserved_page(page);
+		pages++;
 	}
 
 	if (pages && s)
-- 
2.53.0


