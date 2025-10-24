Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85E58CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD398E0106; Fri, 24 Oct 2025 16:44:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAB998E010A; Fri, 24 Oct 2025 16:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C15B68E0106; Fri, 24 Oct 2025 16:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A18A68E010A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5CF20C0F95
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:49 +0000 (UTC)
X-FDA: 84034186698.10.713284D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id C5744A000C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="L/8pLmBX"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yf9e7bj3iEIfzl5FHNdDBGyLJ9g7vgLfDYkp2G8icxs=;
	b=E4Bd9QXerVxWR/G7qoMTWr9pUR/LQUbDm5ghISEBYG1Sujb8F6adYqjwP5rB6zg3/SqEP5
	j+ROafv/nO1CdF2YY5G27qOmF3efK9y5HRAT6bhMLcIhfHNopHBZZ+FIN8c2N6id1apE1W
	h7jK6YdX2VW+WrU3ixoqbP40k0DlpH0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="L/8pLmBX";
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338687; a=rsa-sha256;
	cv=none;
	b=iF9Fa0SQeCM1w4ZldGi6zYu+6ACJUG+49Rd5caUnD1uGv4FtYoRzeezwVqUaIenjUHMJ+4
	j7eEteXjvqJYVHlgh16ROu3TGSSuU/L0WXQHXpHrGa5LFS6MMK3UvoAYIS2e12TB8zegVs
	ABJ3wU6XKjztXXqfH8OgYe4MnJnJOnI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Yf9e7bj3iEIfzl5FHNdDBGyLJ9g7vgLfDYkp2G8icxs=; b=L/8pLmBX84sA7SSkGNCzaWesl/
	HctDg53lh0/C9u36ruWpM0kB2hFV3kvVjqPwJTP/Ni0FI8a2IM4vDlOn16Mef44XedyNZu84N9N9E
	wSSYBDsp+KKaFK6a5gxnGoIjYa/MFManimnwHGsgzyAgv7c0rcyX2btqwPJGW1/q4/N59y88RMBdW
	bwP4BqttxzK2DNOeYtOA3CegzGdZZ3h1rOgFf10PUhcjn2kgO6I0MttSFOowbAB5veiHTdPD0Ot9v
	rTcn7JSyCOwvSnKdwL5+zTjQobbJwB/FCg2cjv7uC+ez4NhoQJ0QAveM6XdijwCCndufJVQylmJb4
	tb8yjCGg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeO-0000000AKTb-1afU;
	Fri, 24 Oct 2025 20:44:40 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v3 12/17] slab: Remove folio references from kfree_rcu_sheaf()
Date: Fri, 24 Oct 2025 21:44:27 +0100
Message-ID: <20251024204434.2461319-13-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C5744A000C
X-Stat-Signature: uy67uncawz1m4wjbykcyhbikes9c3ypy
X-Rspam-User: 
X-HE-Tag: 1761338687-350903
X-HE-Meta: U2FsdGVkX19niOujqWZAfnXVxi4tW8qdsbNBzZhmSGFPiE8ovJJEw5MiKau3xMZDTlGgXpkT7SE6vpDgntNfQRVdHqFmWaVTxIuRVmQoZY7k6XztD91NrSWE+5iUkLeAFs3RV1oExxw2hEIQA3v8jjK3EUezC+6mKlOnP0XqI0PFbcfYQ2sW9sDkj/fnTAMaWKI9evFAg59oAjvmlwC3liiFe0xqh9ny8HGU0tQsJbA9RCMs++eNUrBAxuMGfRdC6CEmAarR84wkmd5Yqfxxm1sx5djvHF4yYPZjeJ/Jb4ZMYu5iCBqbvx0ezv+peXB/pFt0aBtH4XJVeLM9S6iSYkFCOCO6Na0x8PadwqSvRjWQMBmU4/7OmhKptQyulLAqA9ghvwblMLHprF2HLJZUyIzN+JKhLwzdJ1KKG56hwZY40xsCFEnQl4uRE4ENHFvoFPCuC4jMFCh+KeH8CeyMX5x47knKpaBLZWLcYkZhSA6sMdtGnaW6vR3tKa/XhaOZagEcerGkFrO3FvA8Cx4ue15RqZKwlX8lwO3D2kivjiq0kIoNuJ424Lnrqhv02LHlhL/3DSRZLNRj+6hJVNNvK2TU/LwE+ALCtqyJQKr3KCPLXcERC5Kyendpw4ryGoklnPmb4MvSnarlocOdKZM4QntMMKbGyEbFarthSp2utphCBtX0lIoqXpYN7MNLDvKSIsFTPWAUb3uGXm7Fe6Udl2VCmgAjWtp8d1yJ/g5EebnT30Hi/MTtaOJlIjj6B9dvadpWWMKF/UZ4NanCfp3PD0zS4YjvPL+/8agQgQ96PGEd/hKVxSvRQL5660lK1BD37JQ35Mt6y7rW/aE9fnV2xs8vGZ1TqKSsXSxs/eQrk8jmL+kSxZXdYgZRhLaQJiCcwVq5YYozeRBTp4zS4YRA7WCD/R4oue0fEmXmUQZq9EZIWOV+TxQzGYV3WUlUTJerXB1IqS795UqgWT+58pV
 69GeF4tb
 LPti1NF1hbk2eqRsd/OiRbdvzTFAiCO16nQB3jTLuXlZXWJNt9HcB6HSvakVqg6+d/Sk7oCUEG/ztuhZOm02loRsprSROmBIFWi6r6A53PrtK975AHmKSk0k70zvaYUau9vBsbvOlulKWfoZAGZBfIsnjFjMBUg3plW0gXAkteNC0+4U/wK7a2ijMako4jZ/xKVZbYZp/+MG++dWU68mIEDksp6HBy9VJO9z6MIlX7H5IgQ+yTqsLap3G/gR/7V9sKUg3pIqdXILyX4U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for splitting struct slab from struct page and struct
folio, remove mentions of struct folio from this function.  Since
we don't need to handle large kmalloc objects specially here, we
can just use virt_to_slab().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slab_common.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 236b4e25fce0..b613533b29e7 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1615,17 +1615,15 @@ static void kfree_rcu_work(struct work_struct *work)
 static bool kfree_rcu_sheaf(void *obj)
 {
 	struct kmem_cache *s;
-	struct folio *folio;
 	struct slab *slab;
 
 	if (is_vmalloc_addr(obj))
 		return false;
 
-	folio = virt_to_folio(obj);
-	if (unlikely(!folio_test_slab(folio)))
+	slab = virt_to_slab(obj);
+	if (unlikely(!slab))
 		return false;
 
-	slab = folio_slab(folio);
 	s = slab->slab_cache;
 	if (s->cpu_sheaves) {
 		if (likely(!IS_ENABLED(CONFIG_NUMA) ||
-- 
2.47.2


