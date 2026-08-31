Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9427BC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988986B009B; Mon, 31 Aug 2026 07:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960A56B009D; Mon, 31 Aug 2026 07:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8760B6B009E; Mon, 31 Aug 2026 07:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6865F6B009B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:19:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2A7DA3D0A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:19:17 +0000 (UTC)
X-FDA: 85161318354.11.D2C161E
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0131B1A000C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:19:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=PkYX+kv1;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788175156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ob9H4dgSGLsuZnXTYmFdoB7QrJmgRd8FFQ463R9dn04=;
	b=0OUxj1TxMViHVXlhzgKVJ+m2mq4mx82y0XjeYaTHIb+pb+s6sYI4YB/0K98MjHxLcNNHFa
	eeAN4QAawG7FXFnc+kvK/WLjAQheOinWI50TePVDZjhsOEe2W/z0oAcHS5fvwT/EWLXufc
	SRAlx3hdjETnBnp86wr6I2YMVAP+RAM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788175156;
	b=iwyx5aiigcYteO7qnlEfxre0btjn2CeVFTcXCjxTo7ooVh1ed1zmG+kzMxBAMtXr+EhuDn
	Ba5UGUYeB4d6vPQxtFLayTSmAJzkcaZkLIYnziiOb8pteTP+EqMi/SwV9gKhG3EYMR47yn
	pJWizVJl/ILj4O1GoEHQ8ZF25rcnoNA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=PkYX+kv1;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788175151; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ob9H4dgSGLsuZnXTYmFdoB7QrJmgRd8FFQ463R9dn04=;
 b=PkYX+kv1AJTKg57OJLF3Zslaz+IEv+uBxIE8T+c56ZXsN7th1qgAmfcbDN0lrLL0BIV+Oj
 07jRz3wRsxlC1STsAvP7WiDg1UscV66kMGTCK19JzLAUzQ735qybqs93PqwEdTKONTd1B5
 kYZkuSZApJu86B7JCs5/zUDA+L0hGS6hwqA11S2fGWna/vejPOouxCXobIK7yAneZ07rfS
 k427sjX5ESuOjcxIxZCBsfJ3Uxz56b+yz2eIiriXfo+sMaRR0UKntxJN+v33vCCDGDSYpc
 XN6sbqQcvU7jhqoO3OyTKk9Lgb99P6o3uIiQ2N990bqvBn8nJe1noK2sK6HPdw==
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Message-Id: <20260831111638.76012-5-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a95632d+9abe36+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH v11 4/7] mm: extend the template fast path to zone-device compound tails
Date: Mon, 31 Aug 2026 19:16:35 +0800
Mime-Version: 1.0
References: <20260831111638.76012-1-lizhe.67@bytedance.com>
In-Reply-To: <20260831111638.76012-1-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0131B1A000C
X-Stat-Signature: dc9k8xqyopt7imnzm38foth98f73n198
X-HE-Tag: 1788175155-897380
X-HE-Meta: U2FsdGVkX19z/4DkX0Bwpu+rsHGJDRNx7JQQ+q0dVgf5wsRkRjyKqeqzTac/O13AoJfb+G2dkYTKbJxrDPLKQAVOL33qI7DfFiCyZMy/zASsgq3ulRpG87MTeI7XJaNspGhhjAOLNRK5DENw2NcslmjUlPZj6Hl6x04hsnC5jKN7gCBcGIqdIQEA3pUEGM5Pk/cG/pe9AbdR+4WfqjSuSZt5qcka3PG9uqGDDnW7MtAFXOeLvbeagm3QvRWHZbO0TEBwVMEEFVrKNSl1C1pVl1B8bGpfz+oNyAcbZNOFfpdeN1tubzdSfJNfn5bPmUeYoQVVrW/2uQypAJl+9O052stL32kqXq77IZvfMNqzpdj6w7y9JF2dKK9YwlABYmmMFDR4td3g2LPCPqVLD/C+kzcwoNLJWABxGcBMBBa//ckjsrhGXoaUkke8MTaG1R9PA9+iTNpTQxX8gOJ6tT8nvIW6EfjJEUs5fUddUdggktkNPBUmXuWQHZyfkDkqG7xEAbmAEPTvA6IQUXt1mY2TpjxzJjoZbRyUVb8zl2mm+g8mLH9lZCgM4Nyz1ZpPkGFSXPdVodtRl3dQ6lmMZ4f/Sq3l+Vp7y14cxHvzEjGk+v/m9F1mv8UWu1Bsrcorp1wTyxJA0Oh/YLdf6bUH7ZnyqYFNaRoYdMD4z2o/sdQGmijxhgflcy0nVTkuc2wImYs/tSCqkmWsk5esG55E3gj7DC2MeKqUMjuRIsi9W6exp42PRD0ij4fYSOwsxgamrlkumVnIGVDKQXulPMRanGQm1x0gSi0hIdFSnCu1RNZg3RNy/1D8TNFbNYer3RHIIlpwWNcNNAs1xga+Wzy6hI9TB0mBBKUchXbpm7xxxfrDJo9h3RyjbmvycuRR0HJB7vIoa2GgB6dTiBq66QEsqADtV5LGhYR989tIecd61IG/fE76u7tne6XBAHYnVy3uUJW1bDBxGQX49HIGwiJIza4
 ikCn1GZg
 uNRReW9bGlJC7y5HAu6x3VBlrzKcoiquiou2lygcLG2fHpCtnCYdJJwPp8oT03HCUjtq+iamrNlTht0eBDkGmwiiZsdsmny/Z3z4Hz5rGEXZp6RaugYS2wJP+CqNsHTqnq0OL18RfLjh+0mLp2QcnXdvZUGwKNG0s2KG8bomz93LM8b9vpKfjpezLV1ffnP1Ms0/6SJC90L150vXKZjDCEkkakYHjTtrzE+q8a9O/mJFEdadvImEroYW07m98JKb14uB71ukOlX4M58Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The template fast path from the previous patch only accelerates head
pages. Compound tails in memmap_init_compound() still go through the
normal initialization path one by one.

Build separate head and tail templates and reuse one prepared tail
template across the tail pages in a compound range. Head pages preserve
the existing refcount policy, while compound tails always start with a
refcount of 0 after prep_compound_tail().

This extends the template-copy fast path to pfns_per_compound > 1.
Tail-page PFN-dependent fields are refreshed in the reusable tail
template before each copy.

Do not keep a separate non-template fallback for compound tails either.
These pages are still under memmap initialization, and the
initialization-time refcount updates are not part of the observable
lifetime of pages handed out later.

The impact is controlled for the same reason as for head pages. The
first tail page still seeds the reusable tail template through the
normal tail initialization sequence, and the copied tail pages have the
same final initialized state except for the PFN-dependent fields
refreshed before each copy.

Tested in a VM with a 100 GB devdax namespace (align=2097152) on Intel
Ice Lake server. This test exercises the dax_pmem rebind path and
measures memmap initialization latency.

Test procedure:
Unbind and rebind the dax_pmem driver 30 times, collect memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.3-rc1):
  Average of rebinds for dax_pmem driver: 191.20 ms

With this patch and its prerequisites applied:
  Average of rebinds for dax_pmem driver: 176.87 ms

This reduces the average memmap initialization time measured during
rebind from 191.20 ms to 176.87 ms, or about 7.5%.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index ba4148de2b28..04ba37d95bfd 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1060,6 +1060,8 @@ static void __ref memmap_init_compound(struct page *head,
 {
 	unsigned long pfn, end_pfn = head_pfn + nr_pages;
 	unsigned int order = pgmap->vmemmap_shift;
+	struct page template;
+	struct page *page;
 
 	/*
 	 * We have to initialize the pages, including setting up page links.
@@ -1068,13 +1070,23 @@ static void __ref memmap_init_compound(struct page *head,
 	 * the pages in the same go.
 	 */
 	__SetPageHead(head);
-	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
-		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
-		prep_compound_tail(page, head, order);
-		set_page_count(page, 0);
-	}
+	/*
+	 * All tails of the same compound page share the state established by
+	 * prep_compound_tail(). Reuse one tail template for the whole range and
+	 * refresh only the PFN-dependent fields in that template before each copy.
+	 */
+	pfn = head_pfn + 1;
+	page = pfn_to_page(pfn);
+	__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+	prep_compound_tail(page, head, order);
+	set_page_count(page, 0);
+	memcpy(&template, page, sizeof(*page));
+
+	/* Initialize the remaining tail pages from template. */
+	for (pfn = head_pfn + 2; pfn < end_pfn; pfn++)
+		zone_device_page_init_from_template(pfn_to_page(pfn), pfn,
+						    &template);
 	prep_compound_head(head, order);
 }
 
-- 
2.20.1

