Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5801CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 11:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7F186B0093; Fri, 29 Aug 2025 07:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2F606B0095; Fri, 29 Aug 2025 07:53:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1F116B0096; Fri, 29 Aug 2025 07:53:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ACBFE6B0093
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:53:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3565F119866
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:53:16 +0000 (UTC)
X-FDA: 83829634392.11.2FA8BE6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9DFAAA000F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:53:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756468394; a=rsa-sha256;
	cv=none;
	b=IIUrLLSogJkufxWetB4P2Hiu8jruGD7njVvYQpoGayvspGgdoQUBYcQw0/TubwBL/oJ4X9
	8G1RS1t4q2vY9V8diDcl0oPKTfVaRQL3+gRl0AAlxkD3ZUokUQ5bPU0XTQPhmEpis8UcUX
	sLP5X73u4biz1DkQunC95pRu2c34kPE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756468394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RzNlJmhEZlyu1GH7NLwMq2rZh9xZgpmERsV/TJK4Tpg=;
	b=1NFr9V52A0wUhXrzZnByOWJA0QgRKSkX537q1af6ZJq4MSPKQfF7Rh1ii0/va0kR5s7ZkP
	VT7Irf4onfiLlislZOh01WG4/Apot9ovAWJvKecu3y9sU9EO08/Mur7+3IngWkEc5tAvZf
	lSSxPtX6CRp8wWz6LAO6IrPWY1L/maA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9999819F0;
	Fri, 29 Aug 2025 04:53:05 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E687F3F694;
	Fri, 29 Aug 2025 04:53:11 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	scott@os.amperecomputing.com,
	cl@gentwo.org
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v7 4/6] arm64: mm: Optimize split_kernel_leaf_mapping()
Date: Fri, 29 Aug 2025 12:52:45 +0100
Message-ID: <20250829115250.2395585-5-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250829115250.2395585-1-ryan.roberts@arm.com>
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DFAAA000F
X-Stat-Signature: 9cymacx1phmbuwugg736fhzu7prkz5pc
X-HE-Tag: 1756468394-137722
X-HE-Meta: U2FsdGVkX19Xi0Cbj6JrxbVLyUi8t82Gc8HCub0HvYHYW+L0zimgoGBnirCJAsKt3Tj7xrXzDVQX9xavCQnUkI41CeZ50+0OCb/PaU10bk3xqGxwOqWbP7I6+rt/OlfsJIII/W2f4SvqtBO010hqhOK1TkhG2MODFamgte78/NSUkCjCwlpWzlUWCswZk9CRH3ZFnJnPG60QvXe/YrEo/OczOhWprHZyJy7YcxvxHUZVATwDwJo7DE0RwhKh9DYnPplGsThfv4SnzzArrVrBC2aI49d7k+6lrcDQ31GkvO6UiVC7bSrwCFSvlJDGwwFIsS7S/BptSJdUioGMdTboLXBgi7vnjSqoh7KBMKrR3IBqsu+YkSVh6rUKh0TccYWNJm7+KIXbIMrGsjfVpCU5dmrIe3ri8gKEwFbWE/7XK5x+O7FHCuN0gQ/xRrW91zfL3DZhn1e1Z+Enhs4ALLtH3FuIsg4AKmMwiBBOaJIaHCJIu1whfkhaJSw/vG7XgIRdVPrTFwNeddrgs3xwwAy/AKxXM3yhItkuf4mw1kJv2RZwtNrYlf32AUGIwu/R5Sui8zOhL1+VoBEq+bKpJoqZAtFN+fVZGJwV4B5+3KLERWycWz6uOx9j7GvCuuEEzBGm2kU5clJas6Hd7/hHGBqarUvyRUvPHHfe1YaGjq4/oD4VrswiCzw2HeRMPY09ELv02tlyc1IKZBb2/0mtoKxI4369Nz2Lrv9UbjafcJdrTdM79taTAxVz/qKSpriHxmVFImon+OVGOBMRz2AvnMiUqqad+CUxenNledebjP0M9HK4vBoV031uJGgty16Xy8pFmAtItej2zm5OF1FXEi3Gr65qz5vn/63z8HxoUV1xanWv6QfxrTRJD7bfelVB0CDaE5EjnINuJBNoTOG1tjHxmCkQtGOl/qUPMoyswjgNDEOjVz0A/DTlFFTurlEckl3nTfzqfgHGvUSq+i/esNe
 D+3MEpCL
 jWCZTSZW2CjC1KPMTwoxez5JdcipBwCMxDz7Jx1adKTNucJfYgNI43XlQVaXguePzYhR3oIUdAOjExKXI/RxSmGWzsdZ6f3/1J3PnxNla+6uyqv8QUGtbk/fFONV2lRygu9GskCjOq0ofPfktB6V5bQ5WBGRIf+UkvkbWm0Moaig1MpIArdn+eewnRGFAMq/5wFSF4HK/eRRGVks=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The common case for split_kernel_leaf_mapping() is for a single page.
Let's optimize this by only calling split_kernel_leaf_mapping_locked()
once.

Since the start and end address are PAGE_SIZE apart, they must be
contained within the same contpte block. Further, if start is at the
beginning of the block or end is at the end of the block, then the other
address must be in the _middle_ of the block. So if we split on this
middle-of-the-contpte-block address, it is guaranteed that the
containing contpte block is split to ptes and both start and end are
therefore mapped by pte.

This avoids the second call to split_kernel_leaf_mapping_locked()
meaning we only have to walk the pgtable once.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/mm/mmu.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 114b88216b0c..8b5b19e1154b 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -740,9 +740,21 @@ int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
 	mutex_lock(&pgtable_split_lock);
 	arch_enter_lazy_mmu_mode();
 
-	ret = split_kernel_leaf_mapping_locked(start);
-	if (!ret)
-		ret = split_kernel_leaf_mapping_locked(end);
+	/*
+	 * Optimize for the common case of splitting out a single page from a
+	 * larger mapping. Here we can just split on the "least aligned" of
+	 * start and end and this will guarantee that there must also be a split
+	 * on the more aligned address since the both addresses must be in the
+	 * same contpte block and it must have been split to ptes.
+	 */
+	if (end - start == PAGE_SIZE) {
+		start = __ffs(start) < __ffs(end) ? start : end;
+		ret = split_kernel_leaf_mapping_locked(start);
+	} else {
+		ret = split_kernel_leaf_mapping_locked(start);
+		if (!ret)
+			ret = split_kernel_leaf_mapping_locked(end);
+	}
 
 	arch_leave_lazy_mmu_mode();
 	mutex_unlock(&pgtable_split_lock);
-- 
2.43.0


