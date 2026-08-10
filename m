Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67725C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F67C6B009E; Mon, 10 Aug 2026 08:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A78C6B009F; Mon, 10 Aug 2026 08:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 395D26B00A0; Mon, 10 Aug 2026 08:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06A0F6B009E
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:23:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 921C31C00DF
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:23:52 +0000 (UTC)
X-FDA: 85085276304.10.17FC82E
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf05.hostedemail.com (Postfix) with ESMTP id 94D4B100011
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:23:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=CrZCPDbt;
	spf=pass (imf05.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786364630;
	b=a02QJvn7zNZh9HSasXs2iRUHAKlldFX33HH3eRXirB/eSqPmGVbxctJHHEwD0CuEbGxlLR
	f+mZnJjhz/fvMDt9HDne84SA7BwGLheqXPXHQb5K8js5FyZJvhKY48nrebaXnfxLVTNTWI
	6Ls6n/R7C2x3xcXyiLSMc9CLqcfMh8s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=CrZCPDbt;
	spf=pass (imf05.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786364630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cizGxiXgfyBnRadLUW5Uvz95HeeiSdYZ4khU0tGvPq8=;
	b=yMyNleaj8eD2BgutPbarGH+gydhjYBbvwx+LVvIHf8z3y1/H0Pkeyu0BIFMtdxgr3byks+
	i631rkrHLVVQ+sGydbiJXoTnMIaanSjxiyBoC6ris1WATFQx6cBbZ/lN9ga09GkzUqUjm2
	AQoqPka9geTcxi8tDBjt7wPEMOC0Jes=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786364625; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=cizGxiXgfyBnRadLUW5Uvz95HeeiSdYZ4khU0tGvPq8=;
 b=CrZCPDbtXQ5wPBqieg3Di3K2IGP5atdi0QVgOKh1pcFv8Siv34p1dXBXwrxJz0sveG8M47
 tUkHcau8CeC5D5P1VTZ4kzW54Ars6kY8MHXDNQ6xeCdyWxOg3P7XRKjhO1davnhqSl5upf
 2wknkYrzsy+QYdDXXAtbkq5H295fAwO63PYOpu1S5VO8IaUIGJDL9f/ZnMKPJO38r8UPq6
 b1IyVtMWtI5QyDV7IcYuLNksFoGFbuwFtUCKI6y1w/au8cMyR55LrxSfHeNLeUOl27MfVW
 0CH02R60B06hIBVkUn3v7QWUVmKVFuKIzCqPwUuqIryr3r1mHFv5GH4GwBwLXQ==
Date: Mon, 10 Aug 2026 20:20:54 +0800
X-Lms-Return-Path: <lba+26a79c2d0+846b8d+kvack.org+lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Message-Id: <20260810122057.30447-6-lizhe.67@bytedance.com>
References: <20260810122057.30447-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260810122057.30447-1-lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v10 5/8] mm: extend the template fast path to zone-device compound tails
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 94D4B100011
X-Stat-Signature: k53sx7psyaoigwbnjy1omf3fea77z1zo
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786364630-788382
X-HE-Meta: U2FsdGVkX19IIg+tFhKG4+4MYg1LVQLxg6fUYsxMmrXHSoSjiJn/wFrBCHoF+7I8gVTpA79doKxp7LVFeloZ8JFI+MvzVIT58WXy38BPdLm7iTwAvwqrj+tAo0UkYE1HGVJrIIEEkELHcIoEyJ81zXj+u7JUy591au95T4gCZHL6I6jDN287shk/YNWzBAzt6Oe3/92pTfgl2fECJ695T2M9ibckW9LpKj/s0r68rraK6+1I2J5f9yLxUnBF2BpCYncikXLkKInbYFw0BTnucJJ4yd0kDi2hPai4CfWwdRuSbPF3ldcQP7kHBWj6P7jRMhyBiU1iYsBw13cR8D+VgDSTamolp7Mt/utIH5dNIqdvBNT6KOGbFO80JPvCoLC55uvBAzn32qYwRU+yvKGszReqR8P85hX43NcGuDXItdNh+BtOYO/IRCSHJLqkE1YECFSml2ni7DJ25Kjgn30ZNRLS9QX5vBNUWaf9fJFc5MFsCXU4/1xt0oz1avnPezadtwJwrnNTAaK3rhKgonLTP3Scf+Y84zhUj6VoaouMc8ZzMzURLkSzvLdFYhHemT7bDoQZrc1ZOfqpBjxF52aB6zXWwSE9Cxe2cyJ9AN9b/U048dRXLyQnJBaQ49naRK9dYeDcLfVvg08gl5lSdgnTgi86fPd+Mbq1PGgDQsbcLRQYf5FwYGO/mkSrs6YOKeSI3vPHWgJrU1TpZt+YsSmZZSadSJIpl/jA8BCkvChQlGFPJK/IHBk0w5qM+YzfW3H2pUhDNr09ialbMZQ6lT5RkOUWinfYkX9qW1YnqIbIYdJG2qf4TCcmXCHOushSprFyx/lM5XoHu9rjUWzgJBKg1hgvibobdK4Mu4rTq+CObu4QaI1kfmZMnvKNnbfqWsvxqFDjl/cDUyVs/gONUFuTDCiyofBxbc4nPVAM1Tms6Dh5CzkqJJ73sFfUBe1R+W4hUleeJ2YD2Xlq0B3PLKI
 CXaBSqGw
 00x9JJZkruAXOg4mA0B/eHO/HY2QqTTm/pVyaNmS030DNQ28eteZDazrgedC/bWT2aLkgZJcpR9Rje5z9x5GCmC46Kn/zdYGtIPi/yyhDQTn28NMQa/Yt5Ts3YQuvlB9Bzx/mZq4Sd39jBzlpixadE4qPNcqBohwAUu+K5pXOc8stpl43mGiS59ebeU5/ak0ToIwajLC1dqdtsmfFw4P4wdIDKXjZWs5Lkt+1TH4QC/mrkTKG6khiHNsYVpVsof3stcZ4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The template fast path from the previous patch only accelerates head
pages. Compound tails in memmap_init_compound() still go through the
zone_device_page_init_slow() one by one.

Build separate head and tail templates and reuse one prepared tail
template across the tail pages in a compound range. Head pages preserve
the existing refcount policy, while compound tails always start with a
refcount of 0 after prep_compound_tail().

This extends the template-copy fast path to pfns_per_compound > 1
without changing the existing zone_device_page_init_slow() helper.
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
initialization time from the pr_debug() output of memmap_init_zone_device().

Base(v7.2-rc1):
  Average of rebinds for dax_pmem driver: 273.31 ms

With this patch and its prerequisites applied:
  Average of rebinds for dax_pmem driver: 244.37 ms

This reduces the average memmap initialization time measured during rebind
from 273.31 ms to 244.37 ms, or about 10.6%.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 56a36a71ba89..9691fa2a060d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1065,6 +1065,16 @@ static void __ref zone_device_page_init_slow(struct page *page,
 		set_page_count(page, 0);
 }
 
+static inline void zone_device_tail_page_init(struct page *page,
+		unsigned long pfn, unsigned long zone_idx, int nid,
+		struct dev_pagemap *pgmap, const struct page *head,
+		unsigned int order)
+{
+	zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
+	prep_compound_tail(page, head, order);
+	set_page_count(page, 0);
+}
+
 /*
  * 'template' is a reusable page prototype rather than a strictly immutable
  * object. Most ZONE_DEVICE fields stay constant across the pages covered by
@@ -1126,6 +1136,7 @@ static void __ref memmap_init_compound(struct page *head,
 {
 	unsigned long pfn, end_pfn = head_pfn + nr_pages;
 	unsigned int order = pgmap->vmemmap_shift;
+	struct page template;
 
 	/*
 	 * We have to initialize the pages, including setting up page links.
@@ -1134,12 +1145,26 @@ static void __ref memmap_init_compound(struct page *head,
 	 * the pages in the same go.
 	 */
 	__SetPageHead(head);
+
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
-		prep_compound_tail(page, head, order);
-		set_page_count(page, 0);
+		if (pfn == head_pfn + 1) {
+			/*
+			 * All tails of the same compound page share the
+			 * state established by prep_compound_tail(). Reuse
+			 * one tail template for the whole range and
+			 * refresh only the PFN-dependent fields in that
+			 * template before each copy.
+			 */
+			zone_device_tail_page_init(page, pfn, zone_idx, nid,
+						   pgmap, head, order);
+			/* init template page */
+			memcpy(&template, page, sizeof(*page));
+		} else {
+			zone_device_page_init_from_template(page, pfn,
+							    &template);
+		}
 	}
 	prep_compound_head(head, order);
 }
-- 
2.20.1

