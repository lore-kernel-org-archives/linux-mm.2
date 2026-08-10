Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81B98C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EEDF6B009B; Mon, 10 Aug 2026 08:23:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89DFF6B009D; Mon, 10 Aug 2026 08:23:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C6D6B009E; Mon, 10 Aug 2026 08:23:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 480A66B009B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:23:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0DABD12010D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:23:30 +0000 (UTC)
X-FDA: 85085275380.08.D2686C8
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2EABA180009
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:23:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=NEW2BiAv;
	spf=pass (imf06.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786364608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s126gl7tRFhaJiWX2giecuLSdCnS+/Lfp4QcjvwoLqg=;
	b=jKD4VHguOSGwxdR1fItPA46HxgLkY+BH8tLXqDBfqMvZYU2b5a6ei2+17v7L6smpSvXKqu
	UbdPEPZXeilKOXFFk72NbThzHeSPloCX1p1ci4RAUZcuHc2YHghMgSZEK42O4kpdoQJ6Ag
	rMzIMYyBOEYjH/SDYeCkg6AYgGnT7D0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786364608;
	b=sjUYIjEgYsAvq7oKQFZuTARTlYEeroHTlej/mHHtPbOiwzs1g1rZwHRb6P+T/am6TpShLE
	x8MBF1J8I7dxoz4w5LU06XRD0LxaxJd91S4w8RHjBlfez5NfkWO+LOZeXThVDAFUIPzCVf
	8LC19nyP4cvJEnjuinFDNzpvnH8pgJs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=NEW2BiAv;
	spf=pass (imf06.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786364603; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=s126gl7tRFhaJiWX2giecuLSdCnS+/Lfp4QcjvwoLqg=;
 b=NEW2BiAvcaf9WiFuc+Sdy1VBVa6WLD7vxKEl1iam7o0dQf3m4icujr7UkXEEqhDYL7dqUj
 AZjElPV8OfaphJUDMJLo1eeC2Kh+TW/DBavR6fJEzQM4u1h/yTKXSlutlbDDQ4zUV8YxSs
 oQJMYyySjDlNaWRAQKnajgr/uBcwsAeq732OOIYHE1ad7Stdvtv3xm/8SFhMgW8Uyfcdwl
 NKBLOd8OJlLW5W5d1+6Fo/5vJ0OtdGKIeDfI6TOfOUk2O6eb8DNGZq7kRHpLqvmuhrZ+mJ
 pkuYaOeq81JhcvA2Ue3Zm4zIwUVk3LhbzSpqfOAZ26XNZs0DrrLRVW83f4Uyqg==
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH v10 4/8] mm: add a template-based fast path for zone-device page init
Message-Id: <20260810122057.30447-5-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
In-Reply-To: <20260810122057.30447-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
References: <20260810122057.30447-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a79c2b9+a17953+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 10 Aug 2026 20:20:53 +0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2EABA180009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: apfkdzfyfyuattan3934fmoz4ewcbsdz
X-HE-Tag: 1786364608-28583
X-HE-Meta: U2FsdGVkX19LK6LUyPjFb/D4jtdUQTB1uNPZK2uybRPvYe2f3ko47j/R7UvhXfl12Z4TH+WgxYJgszoVWeaMtv+E1KkbcIt0a3X/zwW8ezx3PxunUdQcSUbiSfVmjccNY2NUMH6bU3RUdgc1hKBCep0iuRLqWQDVQgYSltcej0zatXs5KyeenhcHCi7Z3wrIJ8V38pmfWikWVEErv8Zs3x5ADLBbrTaH+B2HgGg/gd7ID/SpZtOfkNNojIWL147U4RJflKhbzqwDSgg1Xeh6r6PLhb6XYN6oqxakfpCUcj2k2HepxK0gCs2T/qcGAHpC7vTx5r+GDEi1B77GB61FpOU0V5L8oVgtim2v+Tn8LcXTVkOEU4B+LTT+PGIbCCmE0z9sOKQDIJf5jFSlDLj1+H1cx/H0pp2DmK5GFmjfk50BzzntCwu77swAC9d3T1GWL/MsBF5mSxgYcg9u8b40hgM19EENi6B5vk/jEHikxp/sWsQgra1x5YioU8ANUXvfQUuXpwKXSJKtZStf3x6noE1Lsyldey+aPA23/9Mc+FJ29lE7oSBH/AArqk9WCnChb42gf130ShxvHR5G9qIO2h4ch9E/3IYVT2jtF8NDPwcqy5blyl8vxgQLrZGWJEy+mRpHmV5ybe/DhYxSwocNJVsAyxvmnhsPA8WXSBkVcYoyplw/Wl0UgRK5Kn5UclWW87jer6mAba92pvjx2+WJCHZPYhuXj0KluV33pAC8oK/BjcgS4IEtUvJN4CwnE5m8q6cmh3Qce/7P+repLfStdEecvIW6g9y2UwSdglKdWf9qylFW51zSYUznOJqeqV9vW22YBluc6XthTF7qBAgvB4VsVhlqOBUBLiOeewhMMx2dQ3eehvhCggCCNZr0SeTy+tOeNN03zbQwKc1ilevDF5WX8w82NHGgsWL5WfzkzvwEDlOT4RJ9icW9j+EcBjXzhtQha59pSo/3aEAJ8I6
 Xe7JN2+0
 ua9igHEWJbafl0Zvi85WK0FAsQGECQjrZb9pqveddy+Mo+FwO2KRsDw3tWNKWaUG3Vbaxb6lJQ62iMHA4yrAsLgIAlksJ+F6m8Yedx3TVtRD/fJNMwROFUXvAzrOS9RQGefp4dfH9AFAc/pa1t94Ra367lX3U5LkkFaGurzkAl6F3ixqVv38TxlBhHttS5V2GlZaKYecrvONZeqrR0IuMbjNOKQ/qJkm8sVhK+okZGbgz2uE0kxrqav+eswTHPmggd05i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() repeats nearly identical head-page
initialization for each PFN. Prepare one reusable ZONE_DEVICE head-page
template through the existing slow path, refresh the PFN-dependent
fields in that template before each copy, and memcpy it into each
destination page.

Use the template path unconditionally. The page_ref_set tracepoint is
primarily a debugging aid, while this code is still initializing struct
pages before they are handed out. From the perspective of users of those
pages, the initialization-time refcount transitions are not part of the
observable page lifetime.

This means page_ref_set will no longer observe every initialization-time
refcount assignment for copied ZONE_DEVICE head pages. The impact is
controlled because the final initialized struct page state is unchanged,
and keeping a separate non-template path only for this local tracepoint
observability would add complexity to the common path.

This patch accelerates head-page initialization. The pfns_per_compound
== 1 case gets the full benefit here, compound tails are handled in the
next patch.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev on Intel Ice Lake server. This test exercises the nd_pmem rebind
path (pfns_per_compound == 1).

Test procedure:
Rebind the nd_pmem driver 30 times and collect the memmap initialization
time from the pr_debug() output of memmap_init_zone_device().

Base(v7.2-rc1):
  Average of rebinds for nd_pmem driver: 244.28 ms

With this patch and its prerequisites applied:
  Average of rebinds for nd_pmem driver: 215.55 ms

This reduces the average memmap initialization time measured during rebind
from 244.28 ms to 215.55 ms, or about 11%.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index a70acb7431a6..56a36a71ba89 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1065,6 +1065,35 @@ static void __ref zone_device_page_init_slow(struct page *page,
 		set_page_count(page, 0);
 }
 
+/*
+ * 'template' is a reusable page prototype rather than a strictly immutable
+ * object. Most ZONE_DEVICE fields stay constant across the pages covered by
+ * the current template, but section bits and page->virtual may still depend
+ * on the PFN. Refresh those PFN-dependent fields in the template before
+ * copying it into @page.
+ */
+static inline void zone_device_page_update_template(struct page *template,
+		unsigned long pfn)
+{
+	set_page_section_from_pfn(template, pfn);
+#ifdef WANT_PAGE_VIRTUAL
+	if (!is_highmem_idx(ZONE_DEVICE))
+		set_page_address(template, __va(pfn << PAGE_SHIFT));
+#endif
+}
+
+static void zone_device_page_init_from_template(struct page *page,
+		unsigned long pfn, struct page *template)
+{
+	/*
+	 * 'template' carries the invariant portion of a ZONE_DEVICE struct
+	 * page. Update the PFN-dependent fields in place before copying it
+	 * to the destination page.
+	 */
+	zone_device_page_update_template(template, pfn);
+	memcpy(page, template, sizeof(*page));
+}
+
 /*
  * With compound page geometry and when struct pages are stored in ram most
  * tail pages are reused. Consequently, the amount of unique struct pages to
@@ -1127,6 +1156,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
+	struct page template;
 
 	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
 		return;
@@ -1144,7 +1174,22 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
-		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
+		if (pfn == start_pfn) {
+			/*
+			 * Seed the reusable head-page template from the
+			 * first real struct page. This initializes the
+			 * first page through the existing slow path and
+			 * then reuses that final state as the template
+			 * for subsequent pages.
+			 */
+			zone_device_page_init_slow(page, pfn, zone_idx,
+						   nid, pgmap);
+			/* init template page */
+			memcpy(&template, page, sizeof(*page));
+		} else {
+			zone_device_page_init_from_template(page, pfn,
+							    &template);
+		}
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
-- 
2.20.1

