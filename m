Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6556C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 464966B00AF; Sat,  1 Aug 2026 04:49:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424E86B00B0; Sat,  1 Aug 2026 04:49:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314C56B00B1; Sat,  1 Aug 2026 04:49:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09D8F6B00AF
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A15A80226
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:49 +0000 (UTC)
X-FDA: 85052077698.13.F86DA80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0900840004
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bzWr+9fM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8jWUj8mEuI70BURr/iwksxqdZh09vWaLH/yvaQwQxNw=;
	b=yI8GUwBgoLo0r2WwPtaoPUSOfntc3/E//3Mc7huVCb4MPYPTaKU8czIEIUVrWy0aeojDkn
	hi104yQ2J/UCDF2pyjjJyuHNnZfjSPtfLWM0rEZb3+hDo5lm7R6ptCAcBwTdHxRZQV8K73
	EAmGJYqJuaCBoBcdXR6gANdDaz4mHhs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bzWr+9fM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574188;
	b=NSAJnYmYN6qVuY/p8HNBYBZeH4/euUFdBL91ZDQRZOsw6inw++vrNhVc7YVuPoDiydk7CQ
	UL9IYwd8NLOJkqf1SXhZ25KxoW3i1Slo6BudCeO0VRASt2UsrivFHGvO00BbwJY0niBCzw
	E45A761WJ3qQvqdMUVNvBzHj07tEvPE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B70564077F;
	Sat,  1 Aug 2026 08:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E071F00ADB;
	Sat,  1 Aug 2026 08:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574185;
	bh=8jWUj8mEuI70BURr/iwksxqdZh09vWaLH/yvaQwQxNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzWr+9fMDT40ul//Wh0slIyzzEidBdejxO5cR7NbPRtOVVvAqGyj34Wcjl0GVsVL/
	 e5AAu7R5FuHpcwcl0vT5OxO4mOGW6ILzHpmz1KtFmnmjro7qyVe+AFD+y2/hzuRoeR
	 /Hu3VoM24gw7pmHajQ3lZpvlkeatiCzIECuyvAIw4f7aG4fZf+RCCf3dQv4wsPaSDA
	 Qjh2zuOfvgXZucv5/6fXHsA2A8fVnoSZGc3IFtIq6SHTpqIt6xJv+tlsXY0H6I+VmU
	 IkJQNnthGSgjr3scbIY1IHtNXps73QQ06RmRq9jsU1okpl4j6xT0vNrXsqKoMLoN1R
	 MgEOeKb/B0UXA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 21/22] memblock: add memblock_reserved_hugetlb_size()
Date: Sat,  1 Aug 2026 10:48:30 +0200
Message-ID: <20260801084833.1897543-22-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0900840004
X-Rspam-User: 
X-Stat-Signature: u6z1tc4jeox45it4wtg8resyz3gkgtbr
X-HE-Tag: 1785574187-401621
X-HE-Meta: U2FsdGVkX18LpvQmiSYFdbATX1dZezQhFY+ozzS14hVCqgUyZ9Pq+UOSsgSzKJ5YhfKBeRqbN714KKUH7meW6ycq0aBS8dVu1lDIvPZBPLg/hDEcAM53Cq5wD2YgTqK7k36kSfxa+Y2ayZa9ug+0juM3zNCBd+jnD5T6q+LsU+afDvv9LrTDat/Js2kSUZ1ZVhsrvNE4wub/eSTorJI64kWZXS0ey3MpdTlKbbM92NP5EAQszyHvxBrPzur4nclyK2ZnqcmLHOUg1Ah7NCTUoTfhxufSISXoI/wi1z6K7ozcERaJzzMQdon1+sG4lqT59drHaNNzWd4gZxOkRxV93/gCguSsd7loZQKWGHoAHQ7lcLeoH6QOBoXpDFAjDldDj+FUIIz5nPn8aZOmhneV+4WAN1sYRz68v79fNpt2sRl4exO69l1qmBEGvE3GquEbjDKDELRkgTMU9jUMr102nTB4ZY0VRvVy6mN1LVMFmedYMqdZ4yAoLEIJk/ojj+xJSvapeSsD3elv4/aoNbItF0HrqH+njyW3nYm8NHFTX3kIisb98rD76L1rS//9xWiqeu4MuRqEwB6QB5RlR7nYq+Yp8/sQqqdeCsDNUu09RFdFpdj0hhC8IZbEkmAqGfCfAduYm5ERkCQa6vm8lNcz0iiDtSX2G0I9ykVPhoykMqMxr6E9tnwal3S5LHAOrj/o84sT3oiIA8e/SzfExdgUyMqDKY8Xb1BPcAJ8ql+MSAzLguDTS4fJqoR64ikvRd5lM9x77dEed1x94Tj40BnJKFD7fGf4j4uSI2rCv7wANv32cyc/RXH3Tslqv2TYg7nrrvUYsjSsfk6O1Wl1odULZpgrbY1IQYP8exdaW8QR4YCaiOkY8DF6Ow0erpx/ExiCH8OTUqscqXrKc7FPia0KfyzzgEVGeFrgI9T6nlBsUwwJGpQ2xixSGalzi38gAxjHTEbKDDk5Ba/bC1RjuTa
 pQOKPyyt
 7AQZZXy1/I/w5t3Jk33+zZwoRmD+6yo8tQrkiiFmH9Q/RdQobN6G8X7R40yyijzjG+ZYNpb2sZUhkdV9FEWu4JXHMD4B36do7CatqsWXuJR5kCX28GcpbIADQczGjcT9MeF7FIiRZwLdly/ZmSF9QrBjaqxFYd1aE6GWcnNDskBB2uMHjBDDkj1cVRDy2jn+DbpCVhOFt/AhJ9Ks/yRUtVbqSTgmu6bnKjw2dcE/uI/3qYgYjSESH6fFk5KRJgNQUxhz+KtzjUfk4t1qjqw3A890QzvfZOG1e4VQr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Similar to memblock_reserved_kern_size(), but calculates only the memory
reserved for hugetlb pages. This is needed in an upcoming commit that
subtracts hugetlb reservation size when computing the size of KHO
scratch areas.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/memblock.h |  1 +
 mm/memblock.c            | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 678fe466529a..d62db9e776cf 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -487,6 +487,7 @@ static inline __init_memblock bool memblock_bottom_up(void)
 phys_addr_t memblock_phys_mem_size(void);
 phys_addr_t memblock_reserved_size(void);
 phys_addr_t memblock_reserved_kern_size(phys_addr_t limit, int nid);
+phys_addr_t memblock_reserved_hugetlb_size(phys_addr_t limit, int nid);
 unsigned long memblock_estimated_nr_free_pages(void);
 phys_addr_t memblock_start_of_DRAM(void);
 phys_addr_t memblock_end_of_DRAM(void);
diff --git a/mm/memblock.c b/mm/memblock.c
index 77c6540e7528..37e06e70c1d0 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1899,6 +1899,28 @@ phys_addr_t __init_memblock memblock_reserved_size(void)
 	return memblock.reserved.total_size;
 }
 
+phys_addr_t __init_memblock memblock_reserved_hugetlb_size(phys_addr_t limit, int nid)
+{
+	struct memblock_region *r;
+	phys_addr_t total = 0;
+
+	for_each_reserved_mem_region(r) {
+		phys_addr_t size = r->size;
+
+		if (r->base > limit)
+			break;
+
+		if (r->base + r->size > limit)
+			size = limit - r->base;
+
+		if (nid == memblock_get_region_node(r) || !numa_valid_node(nid))
+			if (r->flags & MEMBLOCK_RSRV_HUGETLB)
+				total += size;
+	}
+
+	return total;
+}
+
 phys_addr_t __init_memblock memblock_reserved_kern_size(phys_addr_t limit, int nid)
 {
 	struct memblock_region *r;
-- 
2.55.0.571.g244d577d93-goog


