Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD623CA9EC1
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 16:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA04D6B0098; Sat, 10 Oct 2026 12:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A777A6B0099; Sat, 10 Oct 2026 12:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98D7F6B009B; Sat, 10 Oct 2026 12:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 775E76B0098
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 12:21:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8FEDEA032E
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 16:21:45 +0000 (UTC)
X-FDA: 85307232570.01.C96E28E
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id C8B8C40005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 16:21:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DTIzlS2M;
	spf=pass (imf11.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791649303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8PWS9Qoyo16uTAXAyqsyaf8MZtKTZdCptpC3zTJnlA=;
	b=hmiHEG6X8vTBeJYRXpcp65H7A86hP7xnwYfQ6Kx47Bx9LVzXE6k7dbihiv7GHWhpuBsSdc
	FK5vIP2U7QhovvHANexkRAk3+7T11531s3wG/mYwtWd+5Jk2rJuzBEMAbfPkWcQ8GF3bWC
	ceNbvmH72chzKeWeTVqpK1SAi3LucyU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791649303;
	b=qwTp6/0ASk48b3bkh3vwQr6F4LrXfBdbM35wrQixPQIb9ajzXQA2Ep0JL418F7+0bqaLLQ
	CcZV6WDvivFhhoFvvf8ADXctUVDYVKsP+zk/VW1WsMkFxFH+KQ/wHwqoYXHJaf46T/Nh8A
	EL85ON9R1zux6cCN9bWu41nC+ghYW/4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DTIzlS2M;
	spf=pass (imf11.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-141395927feso1175647c88.0
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791649303; x=1792254103; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y8PWS9Qoyo16uTAXAyqsyaf8MZtKTZdCptpC3zTJnlA=;
        b=DTIzlS2MIgdLbQDOrEPU6cVyqADaCzBrmiOrJifovfTpTkdjawOjIifwKfQamEcaVN
         JbntItFVb4PdU20KM5HumCVUWXa+Ti/vhMUdpo5NstNmlKgETUpMQfYEt8mmKQkUcBjx
         lrzcAaO7714dmbkqmdCVNJXBwKgq681GNiXnUQ+lzOqbno/dZcgYUypa0bLLNkjfIi0o
         rJK0+4QcZlguHTX3/3tyyHTbHibJt8zuGo6AIpKMq3dsec+psuy5AxplYIqOrNYxl+eF
         Fg9A3ZgGUkIHOZshZP3zltvL+njZrYugcVU2CVRX+gPOYzk4KhjT/KPhqLVg28y+UZEJ
         UnsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791649303; x=1792254103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y8PWS9Qoyo16uTAXAyqsyaf8MZtKTZdCptpC3zTJnlA=;
        b=OoaIJ9xGdcYFJvntT3qH58uaO46ZkimIR3Pr4o+bp2EvkJxUuATYIrlSszs/cecJsc
         pcuidnppn5mRR18OFItt5bX6IfEcsSl0rZ+sQxLFFUWf5fLxtG0zxD4mH1rR2e/pSBlo
         fi5U8OBUCbjbYI5AZAKx/qVVeNebT+3I3SBuFwUeZo/L4erqaRDbLTJ/gH8fEn2ZQKZg
         P1nNqA0mrSfMwwgysbuvYvrTz3F3E/04+PZ9t1k8S4OibPHFtcbfSzeJUoSJOrLHYfhz
         O27ENleWJ3GgHo7TSrYc4IZlJ2+JVczLkHt1T4Pa50TNFYfn7LrLiaui14FnvPSztBo/
         G2qw==
X-Forwarded-Encrypted: i=1; AKwUvBzeV6CgLbABB9VZINsMFsKXiIIJkSYSqzK8aAWaIDOmcb6u1UethuJqhjdaMLS+lHLKtO3IK3+5Ug==@kvack.org
X-Gm-Message-State: AFq9FYLb3uRdYe0QwGopipTXA077RrjouH8Vflxp1/7Nlq0OtnUrtX+s
	8Xh4BuTEORplokkZB4mdMP9DUPXGdfwaKWdKWuEUlJCOnMkl9zU9ydzX
X-Gm-Gg: AYBFou0BM1SJUDqj57Ku8hTYdIR8t1MmQvX+rfjeCjZr1OfjqWoXBmbYLYSqU/3Tcte
	7VRaAp75IVFmZbQxyJHV+Xer0PJK5E48pTolzSgms8y2MI9yMlyZ8iv5UWfgWGQzKCa4y8h6skL
	lbXyfg7/GNzt8vXJd4dMQwA7RfTz7LqCvqCwVVBhB7FrGfxX138+1b2pQg0tpYtYKtHjTb2HGlf
	FWyfAlr7vhTCMjB/5UqMfC0TL0CVyevVgFQvK6grCWQjjUeqovE79ajU4ExlV4N6IM4rejn2OEC
	CrQRLhCKF2Xj+y19DAJsseFdqqizJ2oid/pRZeNgNvXb9yPGPPy6bLY2X+Xjtj3bwau/T1peZnE
	+VJfJQox8vuRSvENoMcfZdNU1ow6bzoOojjD5/4aqovMLH4/0aQzEI0NyC90kxUKgp+bHVycBNU
	+aPkrEhzsVzHEvWlJIRy74j10XiFRQPE3tyUeedSoqgxT0oevDXI1blbLCsADNKPASfQKtw1s8E
	Wv4vmEymA7q4C6EpQ==
X-Received: by 2002:a05:701b:291c:b0:141:4951:f150 with SMTP id a92af1059eb24-16a5ea5d6famr6277251c88.18.1791649302496;
        Sat, 10 Oct 2026 09:21:42 -0700 (PDT)
Received: from acer-nitro-anv15-41.. ([115.96.176.39])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a3f6186fsm15778622c88.14.2026.10.10.09.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 09:21:42 -0700 (PDT)
From: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
To: Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <djbw@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Breno Leitao <leitao@debian.org>
Cc: Ira Weiny <iweiny@kernel.org>,
	Li Ming <ming.li@zohomail.com>,
	Richard Cheng <icheng@nvidia.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Kiryl Shutsemau <kas@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
Subject: [RFC PATCH 4/5] mm/page_alloc: Keep pre-online poison out of the buddy allocator
Date: Sat, 10 Oct 2026 21:50:12 +0530
Message-ID: <20261010162017.62506-5-shaikhkamal2012@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C8B8C40005
X-Stat-Signature: dtnh75bwc54qumm5j3hy8ttogad6nikq
X-HE-Tag: 1791649303-958775
X-HE-Meta: U2FsdGVkX1+VgrF6FYh96LAHcR9qD1xKLMGuwBtItnk3wbeaRhglAzXC+Bt00NIvEGlCYhe7Lw/4A7mOvapc3oUvMB+/fS8OMmPtQvg01O4XT+Qd/t1+UzLBHMEc6UBWrOaww6tvthi1irBxKMbQDX+GVSm4n5nJfOMBXF41vB9HocHYczEMXYZAUaEeoFGsXV52ymv3WnJ/8ZDNPnSKkXgzqDFZfGM1hkWWk8Gt8fJoTm5hG4cjbqirj8qdcgpuvLDdvY1LPI5TR2jJbExdVdrzjuurwsfo6q78scO191QrcYmlrG/BHGHtR7q38celsP+WeQ0cLiR0LJ45OlryCsFW5dEUAoR1h6JTAT/YTBVCrNa+XIU8ZVzLDadNVTCQNYDJDRbbpkIys2v0LcVDNFV0/EP93heX1BM/FR4/yIfNXty3z4y76dIdKjGDSA4NiK0X0c+OfIazCxzCdB0RDpoyDVoeG1LtReFXe7ahhkmjuAWGlojVQUf/PYhQ0kjPbRVZhdk1YQednHcZulQgp5TtS1lgt5VQ/2nwcOeNkdDxQsZbm+/iYOWr/EWeN709AwShIL7ULKF1mkAH1jGN21VyJh/YBDvhtA40DjLffwfZm71Uo4M6e2lV8fVvt3ZXANUbgpAEE2s3EPXEgrn7BebrZDcLJ81Wd3fw0VadsJ0QDEq1qrpa+rUjvbSVitjs73qvzcdNwvxQlcdMTo6Uk0EFaq/4svijAzYNCHKxiAl88zMxsmyAo5b+qur1lJ6rSuTzIUJ0CHC7Nn0zY6nnBO5eS1a9ycTmtyi0LxTMbvzqkYBQY7ssTcU6jiwzmcdrmvflgwF+3wbfbwiHlON8IeymoI2XoBJMNch3OGkECZyBAxMvNNEegPETEe3jMqXGd7WBtUUeKDu8u22A4QCBluoEU5MJhPCMJqzEytXU2L76ZtWsKcvgy807hi05zf0tDBdUtHnFRyAtOSS0eDg
 mOJrvBDj
 4X62b2Qt73vEaxc86fIKMB58SAGprJ5V9Vbpk8cHX/s2Wu/Pj+1P/dICHNI/IFp+829edayrRFHdWXVvXjYP0BKTbMlzOR3ft1KwWk16MJ24ZlUVDp9zu/eTkjeSQS7/2VhH8xfqcurcoW/AS2Z3ubZdtZTdrrRFdITuXSNqq1GvDij7QI3rkY3gIZ7kMJ24nkXk54u2wCatRCPxGbMTHD/a/QWGuZlC1k+RXRVptWs7kvRISZt79G56br0PhbB2wzNxYpqzHHPaErsWRQxX0Q8rzeQkxbMNuubKbgBOVpSmdBhrd/QDKJQz+eQiVi8gLOwEYq/I0valIowg9IWz9AIMvT+MoAvTohWk5WKan+Oh3KfC+yq+5qVXxJiCZ8l0nf9RRtKnxD8ZYDnZSQk4wIrwTl/7XmRtM91bTa2q9I+2MJkFSsZQWxo7litqiOKI1PRD1Rbyrfk0AXY4aQgI77noNt3eAbY6DJG7WnbVbV83ZL2+btKByxE1J6cqqR/gLmBzhmhl1s1SkLDNvg2jx32wTPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The inherited-poison path checks initialized blocks before releasing
them to the buddy allocator. CXL device poison discovered before
hot-added memory is onlined is recorded separately in the pre-online
poison registry.

Extend __free_pages_core() to send a block to free_poisoned_block() when
it intersects either poison source. In free_poisoned_block(), withhold a
page when its PFN is registered as pre-online poison or its physical
address is present in the inherited-poison table.

Pages identified by either source continue through
hwpoison_boot_page(), while clean pages are released through
accept_and_free_block().

Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
---
 mm/page_alloc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cca67a2702a4..57843df01b2a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -33,6 +33,7 @@
 #include <linux/cpuset.h>
 #include <linux/folio_batch.h>
 #include <linux/memory_hotplug.h>
+#include <linux/memory-failure.h>
 #include <linux/nodemask.h>
 #include <linux/vmstat.h>
 #include <linux/fault-inject.h>
@@ -1601,12 +1602,14 @@ static void __meminit free_poisoned_block(struct page *page, unsigned int order,
 					  enum meminit_context context)
 {
 	unsigned long i, nr_pages = 1UL << order;
+	unsigned long pfn = page_to_pfn(page);
 
 	for (i = 0; i < nr_pages; i++) {
 		struct page *p = page + i;
 		phys_addr_t phys = page_to_phys(p);
 
-		if (range_contains_poisoned_memory(phys, PAGE_SIZE)) {
+		if (range_contains_poisoned_memory(phys, PAGE_SIZE) ||
+		    preonline_hwpoison_contains(pfn + i)) {
 			hwpoison_boot_page(p, context);
 			continue;
 		}
@@ -1652,7 +1655,8 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
 
 	/* First: a block parked by __free_unaccepted() never returns here. */
 	if (range_contains_poisoned_memory(page_to_phys(page),
-					   PAGE_SIZE << order)) {
+					   PAGE_SIZE << order) ||
+	    preonline_hwpoison_intersects(page_to_pfn(page), nr_pages)) {
 		free_poisoned_block(page, order, context);
 		return;
 	}
-- 
2.43.0


