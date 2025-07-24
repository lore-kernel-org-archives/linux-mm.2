Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52147C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 14:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E49E58E008F; Thu, 24 Jul 2025 10:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB188E007C; Thu, 24 Jul 2025 10:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA428E008F; Thu, 24 Jul 2025 10:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9E078E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:50:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7528D1403C2
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:50:43 +0000 (UTC)
X-FDA: 83699444766.10.FB29897
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id A76142000E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:50:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=bmODlJne;
	spf=pass (imf13.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753368642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgGhybuB+tAZvqsghR5tZCuaExpLC7iQdGM6Ue4YApc=;
	b=cE9MHrEH6TId69NIAJ5JS/T5WmxUeU2aSYW1E/dSc33NUm4kir4g2pkNSqt1RYBjQ26wDd
	Yw/H/Z4c7+49yBIBNSUBy6FG4jjM10CgekGIzVPrp2a/nhLARQiu/1uW51xS3HedSzMRMX
	xF017c382lHpVAcLdGoGcFtW6MTUbXI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=bmODlJne;
	spf=pass (imf13.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.171 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753368642; a=rsa-sha256;
	cv=none;
	b=rGWXOgpqmQJccfvQ1Usv8T7jDVUB5Up0OvKhVxZLmRwYFmiyANfX0MUPTNNArOfTLCpgk4
	BuMaheQqKCZpvbRf90905c95faM+T2sOcw5Mzl2Ym/nOLzmIYbGnLft9K6TeUUe25uIU+c
	C3qRJ926XQ47vTszT5MYsM2slv5mqRM=
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4bnv7f3dscz9stm;
	Thu, 24 Jul 2025 16:50:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1753368638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kgGhybuB+tAZvqsghR5tZCuaExpLC7iQdGM6Ue4YApc=;
	b=bmODlJnet//564H9GeC9UKYZRU0b9X8jENtT/ImDqDE/BSUhU8rDT7sLaQXjai9cqvVPzC
	XRTh5RmBQ1OSw7iUsTEHZpj07zzID1a8hden/+Ko29ENEAmGxnE9WXBP/ZCpE6TdMcVWFY
	ziPtCk32ubRHQP9Re7bDQ5LcoGHYZ1HRESsfNTQRdlI7cFMrm5aCsx6seEQ8RRP0sUdfvl
	sEIV5w7JLjAF4BSoGp8kJuKfvhw5slZnmYfIQJcNvK1EQx3HCXMNi0n23ze48W2IQslE6a
	asi3QmBg3iL+GjW4H1HswQbOAienOX5tDKRH0fN+Qa6qnvMZ7lHZs/hA3JtlHw==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Michal Hocko <mhocko@suse.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	willy@infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [RFC v2 3/4]  mm: add largest_zero_folio() routine
Date: Thu, 24 Jul 2025 16:50:00 +0200
Message-ID: <20250724145001.487878-4-kernel@pankajraghav.com>
In-Reply-To: <20250724145001.487878-1-kernel@pankajraghav.com>
References: <20250724145001.487878-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 888a7sok4dtjmcis6kyk8xwiawntja7o
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A76142000E
X-Rspam-User: 
X-HE-Tag: 1753368641-521604
X-HE-Meta: U2FsdGVkX18eV2qalQx3JrCHF2vB9Bc68LdsNFTcxlMfhf1aeahZS2GeMk/HeJa4Q1hh5b2Q9e7USCXHYWWkY4ATpW/2pFXmx7ucpMqsAW7IS+RnYNgTpXRlDD9CIGrnRNJ37n2d6CynAmyeRmM23IKyl5qXI4oCW1jKBNvy4lp7rbp15UhHAtpag1xV/1I1gyej9Tc0eVuoOnhviZJX+zEqu6yH4RzQ+MFrcGf8Qdy6Jxcj42XiE54hV1fsj6QR109BVo6PNSVtixT3FqDrq49seuvDrzUMkkW/l7KogueQZ0967HSXNs6O6szsgXaX/L+KKKWA7T9QD28yEmLUztAzn/4q0Famxa2qPOeSeAoSoLPBssgdVnAnRwYmTn8bSSDRrU5j9xsIqKHXmj9/tre7mBO1F9xAIJIzfSSaMGEI7Amz4fYDLSr8vZY30R3qTNB+b1rgJ5/u9u6K0jqP5J0eODj4wuSmK3PLH3YSX2Va8AT9boA9dvClGKVmKYX3aDHROT474sq1rfVgG10Z0yphpmz1LKQjlk9jA7s0S5vgf+R/jJIXHiAbxfE4il0hziy8MBBkYQRXnjG8kya0AiPq2IToEHUpUPZV5iTOdn4CDcz0lS6/KQCX+BeXLZJ25966IrNigKhl9AmakCSXUOwpTt02csDedHdoZ1ehmsVDfPliOLJIDXldc2ldc2p4Evf1WyNXmybEhIVwwGs6iR/QszlF3ifN3geaE12De2qL0UB1VBePmGnjjJmlJGGC8dTKQnVhaqG5JVkpRNKepND65pUlspPAzMdPsLspfxgeoWbbtpmZ8n2QxN+9WAfFOAUD0UP4MoiwPnqax5tZR+c31BPB82wItFSY2Mx8465IfPOkjHdA+tsiOgTrZzB8Or50+E1MI1XethBOFwq39Xd3kA5uHFCRGYSz/9otSimSou2fgH9xmhdFq/yuBLRtAbEV7epjxOByCGah+41
 Eo+ggyFZ
 TMxlWv67vjq3R+pvsl7+cGPlBTieGVXulUJPYBe9qhQtx11XDeoTnNlRyw5n4ZEcm3aU6t9bOJ27wdZOzZKYPghwIIYn01TMO6OM1Anrvg9n3i2FxTm9Yjxp+Qllx01Exe52lCR1Bste4HImI7FKYdf1L78F9Tn0BLL9KyaZ7QGDTqpm7JUVn7+Ej2KZjTBjIbEiFUM+rZYkt0hWeTfa2+0RTcd2gMY6cOv/1egU9Ki23/7INPDFZioPUn7UaX83ElSrxEhLj8WDf0DFwZ/CMD6lYRNGjCL7AkWdAVa368fi6BjB1NF2ID3YsdtloZ2teR8P/TQKYlY+f55uWpxsw7TQfE6dErbM3ehvLu95OttsyMv/3BWLvOzCEMenXSZM9g5nDVkxYas1yTB+OLiGOujxFtITpOsNu3leCThfhtOijmsQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

Add largest_zero_folio() routine so that huge_zero_folio can be
used directly when CONFIG_STATIC_HUGE_ZERO_FOLIO is enabled. This will
return ZERO_PAGE folio if CONFIG_STATIC_HUGE_ZERO_FOLIO is disabled or
if we failed to allocate a huge_zero_folio.

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/huge_mm.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 78ebceb61d0e..c44a6736704b 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -716,4 +716,21 @@ static inline int split_folio_to_order(struct folio *folio, int new_order)
 	return split_folio_to_list_to_order(folio, NULL, new_order);
 }
 
+/*
+ * largest_zero_folio - Get the largest zero size folio available
+ *
+ * This function will return huge_zero_folio if CONFIG_STATIC_HUGE_ZERO_FOLIO
+ * is enabled. Otherwise, a ZERO_PAGE folio is returned.
+ *
+ * Deduce the size of the folio with folio_size instead of assuming the
+ * folio size.
+ */
+static inline struct folio *largest_zero_folio(void)
+{
+	struct folio *folio = get_static_huge_zero_folio();
+
+	if (folio)
+		return folio;
+	return page_folio(ZERO_PAGE(0));
+}
 #endif /* _LINUX_HUGE_MM_H */
-- 
2.49.0


