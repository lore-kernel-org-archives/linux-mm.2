Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FB99D2ED11
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 09:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C2426B0392; Tue, 20 Jan 2026 04:19:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 943CC6B0394; Tue, 20 Jan 2026 04:19:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 751D36B0395; Tue, 20 Jan 2026 04:19:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6421B6B0392
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:19:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 33FAB1AF0C1
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:19:36 +0000 (UTC)
X-FDA: 84351794352.02.F13B16A
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7421540003
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:19:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eFA42CRZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3pEhvaQgKCEUztvz0hmhnvvnsl.jvtspu14-ttr2hjr.vyn@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3pEhvaQgKCEUztvz0hmhnvvnsl.jvtspu14-ttr2hjr.vyn@flex--smostafa.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768900774; a=rsa-sha256;
	cv=none;
	b=Hit7eSCc9HypWiCgeP2uIb3x4t6PcFVyvgnMIkepXwX2KgGpCFQ3B7KJwhdQbgSuagefJm
	0qJesVPVgjr13R1+Lj2r1hDQQYYamTCuKCnZ/4v157ftlloXqEuZ0FO5Oz0egjKGqJyzqP
	gawHE04iNlHEze9XmD2/3CMHtOTLT2g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eFA42CRZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3pEhvaQgKCEUztvz0hmhnvvnsl.jvtspu14-ttr2hjr.vyn@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3pEhvaQgKCEUztvz0hmhnvvnsl.jvtspu14-ttr2hjr.vyn@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768900774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0gVSCji/amPzVpAugMKA+gNQb8Vp/dW4y1DM63bYO0=;
	b=4C961dEH0bp9Z5g3MJftKBzOWnEcXc2n35Hf+WTlsADWb2yzF6vzUc7XLFjlujc5C1SQA2
	zcBmPLzG12/q3TjrkVRFq6PpPzii8JlNN6JtQREMt8E0db8nAd2C0EgYKqO5hQLnp8OGe8
	SKLaLuLlJ45D6uzxUIvuvIY4jFLkpV8=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47d62cc05daso35497785e9.3
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 01:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768900773; x=1769505573; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=X0gVSCji/amPzVpAugMKA+gNQb8Vp/dW4y1DM63bYO0=;
        b=eFA42CRZ86hUI5mlBmUow37PD+V8I4DQrFo4veEcXN14yj7KvdKEuj5vnNFYxcFKnD
         cn0XCJXFuOU90+fh5ghrU8+kyuqQwH4HPrdtnLxq+iyK7IeSMXvNbiCT5t7od5Ud44nT
         qgC1sT/P17laM5VQw0f+KkOZNCnZHSrfcG5/cX6RMIkxBLEF8lLtTSnkYI2QlylarbZ6
         CyeYIjRoMSSBZCBzhBEA7uHwnNrUpDjd9bnKRgiJcV0HyQUy6Z62bkI7YSq+jv4+Z+RD
         xJENJQYT5o24uA/EXy8M3bYQi2pc1LivMi5FfrxMMAUvKqESHG90Y1JokzSNVsbrvBMf
         YJaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768900773; x=1769505573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X0gVSCji/amPzVpAugMKA+gNQb8Vp/dW4y1DM63bYO0=;
        b=Q6G9ggTqGElzkcCM09d9m96glkPb/kmjkP1KDhWj1JkfFOTn+oIXkL4ZD8ux6C3+RP
         lf43NMs94v0TSnh37zD/qluCZCVbdUUj1AbgrCa55pjDoBz4JV2WOt0bIMegPDwhmS7m
         +MPgp8z6bC+Wjj2oiBD8Wwq9ttZUyVjly7Qbo6IV+D9atdSLzIcoJ++tnBvUHfJ1rqGU
         ut//qLs3nw9HO4J+8gHh5ZPKQ7iixaznPTvsPEbkjwy9IyuhNGvMBp4yPLrDdxFwCjhD
         NsuNFr2FwSMaDuIzhUV2YSna5iMD1lrxy8Xz++M447GbpZdKdRDVHtl5kguipVdRPc6i
         H3+Q==
X-Gm-Message-State: AOJu0Yx8NUY2qy1qOoUemkXoQMeYR4AiP8PXQKvdIU8wfIO0tZA4qVrz
	22ggvrwVZ5j6EZ2HroiEc255m50aQMBToH8N+zmYxu2X+5sDJBMXrNZ8gdbPgXex087pbLBiMWV
	9QcCAHgOMWwEnyqNzcd9Ig9rT82L6h66/p5hjJ1oUClDTzhkdsUb1Zpnes7/q8P+cOkxUnSutoI
	c13CnsoqYW4lfivMekjujK0TMMCZNzgU+UFZ6HPnZhFg==
X-Received: from wrbgz21.prod.google.com ([2002:a05:6000:4815:b0:435:64f6:e987])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6099:b0:47e:e952:86ca with SMTP id 5b1f17b1804b1-4803e79b81dmr13478605e9.2.1768900772778;
 Tue, 20 Jan 2026 01:19:32 -0800 (PST)
Date: Tue, 20 Jan 2026 09:19:25 +0000
In-Reply-To: <20260120091926.670155-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260120091926.670155-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260120091926.670155-2-smostafa@google.com>
Subject: [PATCH v2 1/2] mm/page_ext: Add page_ext_get_from_phys()
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7421540003
X-Rspamd-Server: rspam06
X-Stat-Signature: ykyr4utpa5d15zjxq17p8ezmg357i3eh
X-Rspam-User: 
X-HE-Tag: 1768900774-975576
X-HE-Meta: U2FsdGVkX1+icUxoCL47kh0xq/i5E6pXTYI6LVBUoazMLE7uPoFn7jbZh60Crcxgjeks5pha51I+UFktCqk+KiyWVmt2Xogm6ps6WHe3aLsWDb4ppWbkw7Ml/+wDeBc2zlLjmIlM6JxS5Ukrh4a2UIIzb26jaEazs7h4uIG1ONytITdsFkgU0EBQFaCMBcpoaRehtrvxPPZebLqrO/naUNZmKYOhhaI/kNFA4+i3m9VSJXToUdnTZ6hAFa3j+nqBWD5087APABch5Sbv72bO/qC+Kksa3MumrxSrUCt4U9TSKGg4Zpyo0A00fPBpURVlCc+524SNmMTZ81qPElPB15/QCcOfx6Kvc6MWnl7rVwWRHI/XYt15w6Y26xiDOz7sXzG7QuHpEA5c4lWgcEkJxOBuE5GnFRCkKn7GjP4CqOH35l58tyPfoT/D0KDV4fnSkDwErKPHslgHoupFmdGUwQ9oX2WUUyRgBEehuTg4yr5nTt63BvjA7q6b79c+POVoqLTI6/MJw+RiLUWpX8ty9MbbV6T2mLVaj4bQ/0OxkW/q8lZKZevwpRxlWvsDcNJ9azhep9EFjwBQaX3Eh64/Kcpb01/mbCiY0S/rIdKt9apb3Bw6q3xGQfRdMHhbvbrVZdbBstNN4Nt9pIZ4+vKtK3V3y/01SFSVbXx7KLek/oL4cpKRvwAJyi9knGRtWc0v+JAfhZLuwcOctGU+4O7wOTYtHI8M9c0M+G+Og9Dnu435L0ss5D2idfhTQKdQZcWCN7/fbAYKkC4qool4OkTEb/v1EZVYCCd8JVxTD41i5JLgEfVs5XgVS5A0ehi9jd4SuhRZduR+VccEihuUJexVrRlA63Tq1XFi8iArxqCZd7wq63r6lRrV9fXJ/lcIW/9qVaG3oCEFtQ72iQFmxPMY9C48BhQX2SYMDUnam4xQxhCIPJZv6eiiAM92PZhLoVQmeLUovRgz97upBmbxTOP
 INApy/Xz
 QJ2LJfRCk2G3jfMe7lsL7hJItl3IewnYPnWgA2aZMiIoKsCfZLWqGEgEQo0xjACT1V69bl3vV8wLMPe0t84lsiUE2azLJSOIIMX7/md5BwXS/0FVVS8776vLIVrptfyoG7+zLXdzLfK9Y7LC2/ptRC2pLbu4f4/EAiiOw4E1EwnWUFXDFJc742xMJtkHCB+TNGmmRTO07vMGytqQsKrUgmSA3dvBqJva8cz6ZSG4LGPR57NX2/akgPlXUQsIku5o6XhJiE5hMSNn6MAcA4ipWaJWP+yRQvnRO5vEiZcXHh3q/uzsRt1dXiGa2BW6xpmmu3U8ez9qYBetEqmtXggu3uy5EBlQDGrvkj9jbycUYq7vdr1FlUTit58uZUCNPyY0Pg9K3Hz8/AL7nzR65F6nEh92M2K7coIkaz6XH7tIuafQBJHsVGOYyzeF4asxNLKgQ4EZSnJ+c57+mMKgq8V54x30ifnkLhh1Bg2S7IQZaMNk0llj1dAg5/eU6oJU+SQfeBN1y/2SPLEcvboZoaIJp1ePcqhav18oUHCOc+6y7GBFJIZVkt/4Px7rMayEmTbQnmzK/ssGVDUKsrV1P+sU8UZ0VHlPQ2bOjHwWf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The IOMMU code operates on physical addresses which can be outside
of system RAM.

Add a new function page_ext_get_from_phys() to abstract the logic of
checking the address and returning the page_ext.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 include/linux/page_ext.h |  6 ++++++
 mm/page_ext.c            | 23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index 76c817162d2f..61e876e255e8 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -93,6 +93,7 @@ static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 #endif
 
 extern struct page_ext *page_ext_get(const struct page *page);
+extern struct page_ext *page_ext_from_phys(phys_addr_t phys);
 extern void page_ext_put(struct page_ext *page_ext);
 extern struct page_ext *page_ext_lookup(unsigned long pfn);
 
@@ -215,6 +216,11 @@ static inline struct page_ext *page_ext_get(const struct page *page)
 	return NULL;
 }
 
+static inline struct page_ext *page_ext_from_phys(phys_addr_t phys)
+{
+	return NULL;
+}
+
 static inline void page_ext_put(struct page_ext *page_ext)
 {
 }
diff --git a/mm/page_ext.c b/mm/page_ext.c
index 297e4cd8ce90..e2e92bd27ebd 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -538,6 +538,29 @@ struct page_ext *page_ext_get(const struct page *page)
 	return page_ext;
 }
 
+/**
+ * page_ext_from_phys() - Get the page_ext structure for a physical address.
+ * @phys: The physical address to query.
+ *
+ * This function safely gets the `struct page_ext` associated with a given
+ * physical address. It performs validation to ensure the address corresponds
+ * to a valid, online struct page before attempting to access it.
+ * It returns NULL for MMIO, ZONE_DEVICE, holes and offline memory.
+ *
+ * Return: NULL if no page_ext exists for this physical address.
+ * Context: Any context.  Caller may not sleep until they have called
+ * page_ext_put().
+ */
+struct page_ext *page_ext_from_phys(phys_addr_t phys)
+{
+	struct page *page = pfn_to_online_page(__phys_to_pfn(phys));
+
+	if (!page)
+		return NULL;
+
+	return page_ext_get(page);
+}
+
 /**
  * page_ext_put() - Working with page extended information is done.
  * @page_ext: Page extended information received from page_ext_get().
-- 
2.52.0.457.g6b5491de43-goog


