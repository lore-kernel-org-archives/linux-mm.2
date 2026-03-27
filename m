Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F75E10AB83C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:16:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4656B00CB; Thu, 26 Mar 2026 22:16:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755926B00CD; Thu, 26 Mar 2026 22:16:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692C56B00CE; Thu, 26 Mar 2026 22:16:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57A786B00CB
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:16:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20736E15B8
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:16:28 +0000 (UTC)
X-FDA: 84590228856.15.8E78909
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id E92184000D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:16:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XE9dZB9f;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lE7v5lDGM/JWEaWuAACCuFGk8rRw4V1pzGfx+4tEAgA=;
	b=cqz5iUTyhutG7yuIVDFawC5pJAGspZcZAoBJFobOD/AN0H4wtjEX04uQBYEdXzm+o1IAnx
	kgeVpOny+QVduCmKhSMAyT0NIcUTUQ1mgrtWpsYkPpkvEBBZz3xBoEA3o2hj8bW944PFTz
	ahy5pw34J61ghYR6ZNE3cuYMfbgaljM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XE9dZB9f;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577785; a=rsa-sha256;
	cv=none;
	b=NANUfKBufCW2IgTxlYGr4NNVP90ITyFYikqe4cirDACiJ5lRFFTzPc2FQc2i08pWCRIKgG
	hznfTMU0GGADVj6Q1e/2o695inkGxgJq2VKToxaR1wHNlVACi1fnVfp4xbm4qTQP6G3ozZ
	ctPunQTugC73gc5mrmJpDAweseo7Al8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lE7v5lDGM/JWEaWuAACCuFGk8rRw4V1pzGfx+4tEAgA=;
	b=XE9dZB9fLZ/OArOngsedrObo//4dofSQ7egtq16n4UZmnM75/spWLYNbGNXdNBcCTBB+Fo
	cnGQD1gdIQDl3tgpRirkYMGiJR0/XwR2Cvg+8mZxq+a73pFDK7w6i+bpfpGytLEzfpmE/g
	n0aN0IQDsz7hR+A1FcsvHnMT47HCL70=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [v3 23/24] selftests/mm: add partial_mremap test for move_page_tables
Date: Thu, 26 Mar 2026 19:09:05 -0700
Message-ID: <20260327021403.214713-24-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: hfknrfap18erhiqzdeawudyhrcq13dm8
X-Rspamd-Queue-Id: E92184000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1774577784-997731
X-HE-Meta: U2FsdGVkX1/B2ME1HwOlKp+aGqUvS3yMCe7saZo3x27zqpPIGHCVQkDSKPFrkeLa1Q6VpRTa9wl7WC+Q2ymXMuhl2KAerRQq0+SzFK/J0l2yMAYoCQhpM4PtS0rtHRPsghb3oF5krxQB13jrNUdkdQLf4GW5V9N83NRKGuks8vNm4Mjjoh2Bo81wNUHN2OD6rJAg0ijZO/BtntdZQHdiP5ySj7nQA7cI7KH+9PR2SZB06xlq4JZW6FERdJgR83H51QCiAVdfVY00O02HeHtUtgnMalRM0CgQx8696XEvgKZ1tt2rQOJ8Ut+FK28Rqk871lK+v+tl101dGACzB1vSq4bTKoMIsz1hY3VzMxJIhKhhbopOJ+0wSLrUdAn9c9e2eHSaIbnTs/uncSsIBUwcFj1xnBffpBIFUcNf+LG2Unc2hqDQAzX4Ek5Q8/L8nl3OBF2ICZ4x13q0JMrSiB+Goduij8/TljJsdDRv2jJGgTxwdCh0/fxKIu137Gwk51t59a4zJRQsGTaoLk53TXnmjxPAR/tJEJCYdEX4TiqpAPhstX9UF76/WJUycM6kOYv09uSuD7TseQ+6BpNHxH0dtAaSUp0y7gcfT1y5i2LUrKNsrv8zgdDwhDv7h7u30VUNO8yhRSDPUnTKKjGJjfgwRxx7uBXvcf4Gw0048J9dcxIWgRHAY+muvO0o2fEjxhWniZvlAYD9IjqRuMGwady7C1w5TNWl4Pp164r26ew53PtbqK1JOaYErQqTpkmJ7/bH3uPpmyzfolRgAbQEi4vSao2t9VqB3IkKRSVzDBr+ADPzsOCzltaHf8GsI4CbyJZRosnGtCWd/Q6Yab7YikNN+DdK2El8UCZj2L9Kgmz7/YbTAA8KivrZ+vrkRuY0F5vqITOHaEATAm8qABt0sA19+q6VzFawGBx+c/KCU83kKZnAS+TZXY/GlHPax5azHhjlDFEXcF8Sn60=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test for partial mremap on THP which exercises move_page_tables().
This verifies that partial mremap correctly splits the PMD, moves
only the requested page, and preserves data integrity in both the
moved region and the original mapping.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 .../testing/selftests/mm/thp_pmd_split_test.c | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tools/testing/selftests/mm/thp_pmd_split_test.c b/tools/testing/selftests/mm/thp_pmd_split_test.c
index 3c9f05457efec..1f29296759a5b 100644
--- a/tools/testing/selftests/mm/thp_pmd_split_test.c
+++ b/tools/testing/selftests/mm/thp_pmd_split_test.c
@@ -203,4 +203,54 @@ TEST_F(thp_pmd_split, partial_mlock)
 		self->split_pmd_failed_before);
 }
 
+/*
+ * Partial mremap (move_page_tables)
+ *
+ * Tests that partial mremap of a THP correctly splits the PMD and
+ * moves only the requested portion. This exercises move_page_tables()
+ * which now handles split failures.
+ */
+TEST_F(thp_pmd_split, partial_mremap)
+{
+	void *new_addr;
+	unsigned long *ptr = (unsigned long *)self->aligned;
+	unsigned long *new_ptr;
+	unsigned long pattern = 0xABCDUL;
+	int ret;
+
+	ret = allocate_thp(self->aligned, self->pmdsize);
+	if (ret)
+		SKIP(return, "Failed to allocate THP");
+
+	/* Write pattern to the page we'll move */
+	ptr[self->pagesize / sizeof(unsigned long)] = pattern;
+
+	/* Also write to first and last page to verify they stay intact */
+	ptr[0] = 0x1234UL;
+	ptr[(self->pmdsize - self->pagesize) / sizeof(unsigned long)] = 0x4567UL;
+
+	/* Partial mremap - move one base page from the THP */
+	new_addr = mremap((char *)self->aligned + self->pagesize, self->pagesize,
+			  self->pagesize, MREMAP_MAYMOVE);
+	if (new_addr == MAP_FAILED) {
+		if (errno == ENOMEM)
+			SKIP(return, "mremap failed with ENOMEM");
+		ASSERT_NE(new_addr, MAP_FAILED);
+	}
+
+	/* Verify data was moved correctly */
+	new_ptr = (unsigned long *)new_addr;
+	ASSERT_EQ(new_ptr[0], pattern);
+
+	/* Verify surrounding data is intact */
+	ASSERT_EQ(ptr[0], 0x1234UL);
+	ASSERT_EQ(ptr[(self->pmdsize - self->pagesize) / sizeof(unsigned long)], 0x4567UL);
+
+	/* Cleanup the moved page */
+	munmap(new_addr, self->pagesize);
+
+	log_and_check_pmd_split(_metadata, self->split_pmd_before,
+		self->split_pmd_failed_before);
+}
+
 TEST_HARNESS_MAIN
-- 
2.52.0


