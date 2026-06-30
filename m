Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92FC2C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 21:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B847A6B00A8; Tue, 30 Jun 2026 17:18:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8E36B00A9; Tue, 30 Jun 2026 17:18:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9395D6B00AB; Tue, 30 Jun 2026 17:18:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61DC16B00A8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:18:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A335F40135
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:18:52 +0000 (UTC)
X-FDA: 84937843704.16.1A1AA7C
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id D1A40180011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:18:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qufLB++9;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782854330;
	b=xKmW7Rf4XiS5tOwgB1sfnqWUE3kwiGSGY/vB8aF9CCoaOI9XvPMCvdOuDDsDGh7GVuSGjE
	/fVD0MrH6C++1hFPK2g/N2QA1ViL/Or3g7sVOY9yadHYT3t742Y8jAAiJicSM1w3M0N5g5
	NxMrhQJjuzJiNl7alO7fwcIj6ZckRqc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782854330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8SI86A/tUZQ+3KTQEDQQAFYWb5y1VZ6lRAmoYBSC2uM=;
	b=TlS+Tev2jCfaRnvcPoFheIgSq7Z9l+lLaKueu2I7a/cPKfNnqK1JElow+nUh8HFhWy7U/U
	TBXk5mYfLML8xKm7n1va9DLauIlan6col0SNHIqH8UC6EJnTH6NDVJPV984jenxOtueVdv
	PCSYnmjA/aWvc8VYnzBb3yhBt17lmxc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qufLB++9;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92b21f65b60so105607785a.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854330; x=1783459130; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8SI86A/tUZQ+3KTQEDQQAFYWb5y1VZ6lRAmoYBSC2uM=;
        b=qufLB++94UDr2mKXF2t7mmkiRXxS9tb5HM9zeyumuZOFgIfO0VTvbAEzToHi0n/l1t
         rCZZD8EnxAWimnO3G/t58vV+rpjRJoNFpSojRDK8Mk6UCeC6QqRDPw2lN90GZou+aAWt
         g3FAxN8FSYPAxt09bKfH1r/jnx1q8vjlBYG65WAt8yv9VtA4o4gFf6pkveuqmRwpDmdv
         3LpsB7dCliPo8nKquERLRljBLKGLgYK3heaSoK24d1+IUc5c6ZJrx3Tji0W4RthOJfqH
         z/BumuRWfLI5N67c5UcObF6h8YZkThrNoZ016Ij9H0fxLHbJpagFJGAqdGVZpcn19VCK
         Eshg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854330; x=1783459130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8SI86A/tUZQ+3KTQEDQQAFYWb5y1VZ6lRAmoYBSC2uM=;
        b=Gd5NcN4AlsL047Ydh+Xd3o46Icf45WRAPS91wjjzpIL9I1dNlbuwQ5QlVpzuYubnez
         I4AlYRkRJYofOuIkAYc0ZgxJ3lLwn7uAC/Q/4l8Jpg0B8rHiTvOcyRCdLPdqvSjrTq/K
         Lak2UThHr4Hmt0Y/IeZhGwAYttJxVDgajoVoVAfj2cAWRsDOFT7kYj25qJmxEHHuT/L1
         Hg0JfMNRZEpuUXYqwVK61Btfu/90qmW+28xHdZNhFLTppojuKhb0kpYBQCfQ6IQNuJcN
         QwlzjJB6EYWIIwX8vjBiOG3bt5V49M3ySOkAXbezcv8PrS1dL1OHR+NGsLvQaQuILBi1
         TZ4g==
X-Gm-Message-State: AOJu0Yz79VYVsspJpluxmS+QOrOhCVdn8vusO2gMJH3LfTKkPqCEYCAR
	TRk8AOaphZrUWEHyCcEmNkYvFt6wJBtdq8g65BnKb2QscDLZztAywjRx0RtkGvdOfZcTCv9AYk3
	DtIDT
X-Gm-Gg: AfdE7cl7iFIncC0xiCL5wS1ac7HIGoo57XqLK30pEYmv0YtgF6kaTdqH6YUYh7Dzkn8
	4FGbVEc7kKeT5tc0ph+KfmKsjZ54PjArWXdwE6E9gMW0930+XkxcKYiQmcIYkDGokhQSt2qanrh
	OAbrj82b1KIPmVU4bxbNZhECl2mumKedDpH+utzFXl0pRGTPWni/miCsBsHYLhdTFnh15eH1GoM
	894vI4hATO2jMYLZMnRI10TK4j/D9RBGxdJANqYW+qrSFCiImRdImFw3esVyTKv2HTLsJcj8mGY
	lKZqmCtp5yoqN3y6CYF4LQNcrUHgi5mmbIiZy5ME+pUd1R7xfu0EVwO86hXiNcQrDWQdPSWuNhN
	lWMlnC399yhCNgq8eaiLhruIj2dQXBTtYgINvUC5HqV05mM115U/vSXGxB4RKi4USVivhB5p8je
	wb1TZdBs7Ks04A8Yk7S8DTamtZmLWAqSGVvq2nRQ8IHJ1UkCEoQKe+mTkvVlJAcWuOUZMSHh8zD
	w==
X-Received: by 2002:a05:620a:6019:b0:92b:3203:ea70 with SMTP id af79cd13be357-92e696f3833mr471607485a.12.1782854329895;
        Tue, 30 Jun 2026 14:18:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:18:49 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com,
	apopple@nvidia.com
Subject: [PATCH v6 01/10] mm/memory: add memory_block_aligned_range() helper
Date: Tue, 30 Jun 2026 17:18:33 -0400
Message-ID: <20260630211842.2252800-2-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630211842.2252800-1-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6ddoqhq8bx4fw8rj4zzrjz88y1g817r9
X-Rspam-User: 
X-Rspamd-Queue-Id: D1A40180011
X-Rspamd-Server: rspam02
X-HE-Tag: 1782854330-468352
X-HE-Meta: U2FsdGVkX1/dBfkkszaZfsqyUL6iCionneNVJwPtzhebIgtPBaDbPlYnbNEN6L2aO9dNwzUIWBSGk+fyDCa+ahOl6sqBPhmKAd1xhcKbA2RLLPZL05DZnZJMC2jC7iCauuQfRerQyN1IKAfj4cAvYc5quywxJNkpMzy5L8KD2xBEP7fi5QCrL7wXDE2e4Xq9En71j11h94Cy5/L26SXZJA2bX5A054jDjlMVb4pLfwnLgkgaa4WQpo3Dx3DEaur7E+babahaNykdSMAEs/7SNq5DRu0KyelrB0z/JLwQP9MJubI2k13PP1tjnhLnCmsTrVSWPhdFuTP6X3dqo8EFM+8Rz3H/rrLkcaaiDzv5GKQk7pDtUw1IzHexdaimL8yitj5I6XZ+1djAGe1gvuZQ1mY9Tj/mLv9hulPRDcGTuAtOXCyi6YFK31fiaxku3KtNgQw1NVMFUbTf3VoPrQM34PfogxhSqvJysnnoZnCNz/Fbjwo8lVgh4QGfbNsPIbJ5ymwNiUC3U5iYP7WYEkUG9Sf7kRuoibvRT0+2GY8FajHHC8goL8bIzxlYpQ2MI6ZU+YrGRltX/Kv54mHFFIxCTQk3yc9mJgPSCSUYjqMjtktq7iZIJyiATLNQ6T1/ujy23f+Pnm0HnWTMPmCLSvIxjCb59ztlgS+wtz0eRI6RXGA5kR7PgKqFduWpQNwCWdqmSVm6NcCgAgOTLIpipc1X+aQ/7TIXn9oOjpbOcVdomt8IcXae4fNFRGfCxky1gLYwjiWfim8+c/vLF3Cg09ma9N3yYRpz4Ia9D8T4pbBwwl3NC7bW+RlP7+yG9iFAA02qorfNgUO/ZSZtKcDd2Og6M78XmSaYJebWs1DGcDih7LloXJNbYn3Kdf0pDF7f3Vdj4CXlx7W6Us7mnLDCmvKYxJugu80N4yGJXK9KPqZdWChC4LW2SWSTrhVJe8aUA4ETpOewZlvnTNZ+6DerN1R
 60M1RadQ
 WTWFnpZUEnxhsYp5G5riVI+jG6d5WXr3J5i8n27A1vwgjzMmU0Y6webSc3MOABxkP4eK68+Vi+WpKpD+UstrUa0CrLRsui/WnfJsYRectPR0hhPDBIvRUyAW8gB+Nn/By90kAvu+puX/g4Cc3XVtAlrZfZ+sOtJpXvGw9AG7aeBzS4sXRgouvDKpbD79cuQXcxss3W4TcSUU7RJN+/M4YLOytltQ9sJ7PcG+sOmRCewla2QSfEg9jwynAg/V9rQceWYm2uvN+4OleIIXtJAOgpZhSQITSOeN8ZB5xfztXPu63S0eRcfdaJxQtP/gtnma1bAlRBUnTcVvNZ3+0KkYK5H89u9VM86QW5FIE6xUTG9PLta2ju9W6tk45fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory hotplug operations require ranges aligned to memory block
boundaries.  This is a generic operation for hotplug.

Add memory_block_aligned_range() as a common helper in <linux/memory.h>
that aligns the start address up and end address down to memory block
boundaries.  Guard against end underflow when the range falls below the
first memory block boundary, returning an empty range instead.

Update dax/kmem to use this helper.

Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 drivers/dax/kmem.c     |  4 +---
 include/linux/memory.h | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a18e2b968e4d..592171ec10f4 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -33,9 +33,7 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 	struct dev_dax_range *dax_range = &dev_dax->ranges[i];
 	struct range *range = &dax_range->range;
 
-	/* memory-block align the hotplug range */
-	r->start = ALIGN(range->start, memory_block_size_bytes());
-	r->end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
+	*r = memory_block_aligned_range(range);
 	if (r->start >= r->end) {
 		r->start = range->start;
 		r->end = range->end;
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 463dc02f6cff..1783299073e4 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -20,6 +20,7 @@
 #include <linux/compiler.h>
 #include <linux/mutex.h>
 #include <linux/memory_hotplug.h>
+#include <linux/range.h>
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
@@ -100,6 +101,32 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
 unsigned long memory_block_size_bytes(void);
 int set_memory_block_size_order(unsigned int order);
 
+/**
+ * memory_block_aligned_range - align a physical address range to memory blocks
+ * @range: the input range to align
+ *
+ * Aligns the start address up and the end address down to memory block
+ * boundaries. This is required for memory hotplug operations which must
+ * operate on memory-block aligned ranges.
+ *
+ * Returns the aligned range. Callers should check that the returned
+ * range is valid (aligned.start < aligned.end) before using it.
+ */
+static inline struct range memory_block_aligned_range(const struct range *range)
+{
+	struct range aligned;
+
+	aligned.start = ALIGN(range->start, memory_block_size_bytes());
+	aligned.end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes());
+	/* No whole block fits (e.g. range below the first boundary): empty. */
+	if (aligned.end <= aligned.start)
+		aligned.start = aligned.end;
+	else
+		aligned.end -= 1;
+
+	return aligned;
+}
+
 struct memory_notify {
 	unsigned long start_pfn;
 	unsigned long nr_pages;
-- 
2.53.0-Meta


