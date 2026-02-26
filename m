Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 679A0FC5933
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7DEE6B00B9; Thu, 26 Feb 2026 06:35:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5F686B00BB; Thu, 26 Feb 2026 06:35:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B92AB6B00BC; Thu, 26 Feb 2026 06:35:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A34D96B00B9
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:35:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 68A7D13C0C1
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:35:09 +0000 (UTC)
X-FDA: 84486401538.09.84D85AB
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id B7882100002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:35:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vDnDtqlu;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=90K3/Ap/gcMw9j71y2Oyck7qwp5+WMwh/4brt0FtyC0=;
	b=EyrwXvKlJOR+8C256XJEtInL0QLj9XNfl6bFUkI8M/vR0/O8AOdbVr1mOsObHIkXUtA7xT
	LRTrb6+GZga7O+spuwn+kDK+aoaNcnCJK7UqdYKasF8aNMDTSbAz8MBSyVp/UZg+lJJ/YN
	k/j0OTrX9xK6EHkEkJR/YEnZVlhcqpE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vDnDtqlu;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105707; a=rsa-sha256;
	cv=none;
	b=bqAETZWIVd6C1rZ8qnz4KG8x04Ala0znAseWY80Gzde5vMa5wPTYafziBkmM/ZQuOzFDjb
	vwh2xjniTY6XWeEWIdj0ye2utCqIkMiSgCMDukt3eD0kMTaA627W9gyKl9MvWHdNLBaiH4
	3yCpgoFoNTF77jEanHUbnrXxCUSnJDE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=90K3/Ap/gcMw9j71y2Oyck7qwp5+WMwh/4brt0FtyC0=;
	b=vDnDtqlus/KJ8Kb996zZEjIj0Q0OZrP9GY6JYe5v0jo/jHj6Hhvq7Y6+kbJrhcBUFwKCR+
	ptXaefkfhEcHKSCBne13vyEB9khUI5H2IRECqYMjzQXrM98xkEITpmyhzIlR8rRiLVUScp
	6fbItK2kptHjFBl0pkeiWG9RptvrStU=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
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
Subject: [RFC v2 20/21] selftests/mm: add partial_mremap test for move_page_tables
Date: Thu, 26 Feb 2026 03:23:49 -0800
Message-ID: <20260226113233.3987674-21-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B7882100002
X-Stat-Signature: 3rwtqbzasn96ykfst98955qz3rncg88s
X-Rspam-User: 
X-HE-Tag: 1772105707-452327
X-HE-Meta: U2FsdGVkX1/HLU/dlM0FNrglL/2+e4Nf4EOvyGqOHq6jBxDgIRH9R7GlASxofPxBRmNG40yzWHz7ihOzY1pKul5LB+jn0Jqr6MMpJGTNMVflSnuzCrsd+kIEJ5ELzLljRa97pzogI6lzxWRtzhiVjkq4EN2W/84+PNIfUOWHDHNkRVoBoT3aHH2ERtXovhZXgHa+G+wxAegiVxfUl/99kaCWOcA66i1Q+wnialbeCjD6vJPo5ibLzvDfiIkQs0K8rfQlRVdSpb9twj39BGB7dzHpIw3Vu6rUPZBEYnW6SQEj7g/Hbs1RHrwkzF11VnUxlKrHqdzgHTE9WcXKXj4B/Y9QyNAwWYoUk6BWYX328wtDysxHt3Fc+PGwO3mp+USN13Lf+RmXrIp1khN7L4/D9RJII9Dm3VTFkAVVWcDhBoxGBXIiA75OgdJVPYATnf9+P4c2D3loZmbVPOXSkgwh5rpj+VrLcoeITf+ki2kCHuKsgrgDVn9SfiiKjPFstD6cKTTgHSIm0RsJB0ew2YIeutTyIW5m7llzZcX+UwrhpSFsDHZ3dsgMTG9ineuSs1zH63HLo1VLhEGmQvrBCxHql2+q1W+EOIQ3JipZc5XfYNFSK0DnjzxTwF+8dqhBclRG/Oz7mh+GEKV7/nQddEXYg2MaklpgW79AdNk3r2Pqw6XbToCO/KuqLGWqpmhzTHI9DBO1kfUyUv0OiwHf+/xaXONfEJoGkJeOcwMVJ+18Vjh7CcPeMuFm37pqvlj01pjCGjUqtVMHTv97MTbfeKpC9nVdyrxkHpn52cnrQysVbp688c/MHHerN3wFlYIypxW2VGozkRhQtxMoEFRG7ODJrZYfr5DtdJz6g0a5THKy0fuLS2P4RmatOs65TItpFddjWWrzo8l6W5EUPGy2GMu/+FpjN7pEghlnWD8TM2E2muaHVDg6XVVezmc8+YTCg7/8QOdKW2VECK9mmBzzGsN
 33oKBnwK
 sw7xCuprpZdymbvq505CTSqXafaQ1+RBne1Z5qgpCWywOHjDRiJE2wVeXPfFnp+qOQPX50rZg3molfFE6zgV5iANBO7tjTkXuIqRtdLa4/oBmq6OJAr0kD5v2DgQD+aGjkvrGPMYxlzuA+47KAjCRGJBEEFGDxiWLzpQ3n1GdnYW4hxEsdmJlgomJW+lKdzGVUBfWjRtUaiRbYag+mzLRDaYuRp3wt/m5wuNzQcHPl1NT8SZeHRH9iMiXXg==
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
2.47.3


