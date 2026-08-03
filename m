Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9963AC55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:11:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B3F6B0095; Mon,  3 Aug 2026 03:11:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72DF6B0096; Mon,  3 Aug 2026 03:11:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF7E6B0098; Mon,  3 Aug 2026 03:11:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 745196B0095
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:11:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C7521605F9
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:11:45 +0000 (UTC)
X-FDA: 85059088170.27.3D5FAD1
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf03.hostedemail.com (Postfix) with ESMTP id E62432000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:11:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=S7sBEr69;
	spf=pass (imf03.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785741103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qc8dQ5CG3JDfKki8p6Oe6zFvHP+EHrglN5Ie0hZFMQk=;
	b=N2wU4mV1Pn4KPl+jojONOugmQQ4E9eJi/nCxYSrusxnemH+i9wq7WVu6NLY5dBep/Gs4sX
	Kb123hVYF10+uAD7a3skooEJKKVMMlc/h6/Y4E+S8+9gkpCmXlql57Mx4uq7C4kPOTb+Dy
	VB/slsud+5kvx853mPXlEAuQ3VEWhYE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=S7sBEr69;
	spf=pass (imf03.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785741103;
	b=n8Pm3Dezbhi2c/mrZ6hth15e9NAGdXfsaPFcIlQD4jf8Fx31UfD5c2sw0XArkLyIOfx6xj
	09U3sUlK18DlguLb3A7i//Ul9izNfZV+PE8j/I4cppnyevRmCugCLMpcCbzzwGzSGA1mbv
	eSs8aNlArbxfymA4reHPtZOQLGgDXVM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785741093; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=qc8dQ5CG3JDfKki8p6Oe6zFvHP+EHrglN5Ie0hZFMQk=;
 b=S7sBEr69js1eorYUPyeOE7Ccs6AV6t+o8MpLZJPiqV0gvspBffCWbsiXVeEKWQCR5LS58n
 FaLI5Xh0EJC8PWowg+4WzZOzQUvnaJyUGRNfFjpS7C5KJ5QYZBdcM326VxJvPfsXDb3D+Q
 j46K0obY5jpD+mBupQX4SblwUeYELeXBgA2vaKOLm+FQ0U4LvN3s5LmDe+BZeizKUDbeGo
 8QlGWCJltmZoZOZBgkO5LQxVbuf72Yb+Fn8KcwHDZGEzjS0jMkBng40aVzqSggIHVvK2qk
 ++JIVg4Tri7A4nzz2ma78WgKmWu4epYoVM3xUIM1SCmSaZOt0H9QSmbBETxXOg==
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a703f23+e26286+kvack.org+lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH v9 4/8] mm: add a template-based fast path for zone-device page init
Mime-Version: 1.0
In-Reply-To: <20260803070929.86075-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Message-Id: <20260803070929.86075-5-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
References: <20260803070929.86075-1-lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon,  3 Aug 2026 15:09:25 +0800
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E62432000C
X-Stat-Signature: 8ft7bs1nqou366p1htc7p6khuh7uizcj
X-HE-Tag: 1785741102-492173
X-HE-Meta: U2FsdGVkX19ZCSru/TSwiHhGnipzCsDyGcokUsZfV0xYp+eOARvGtDybPQ38zwsidX4GRDALIOIQzxzdCykbE/clo9hW79ahJqjQ9wPVEA44GJsOibiKCaKGeTQdEFbkFeX3kv2cb5wtHeSzLp5R4kb2lyJLyx1TZsCHuuTRxeRag6U4QK117JmqGKhO5lE1rpJh5Y4tLu7LChCbuTo8cp4Yc9x7qtz171mr/VZYu7WYZ4MlhzzmT4nU/rx/Yh1Mn83JqivYj2Otk2gzp423PKsNL/RjYdaG/ebz1ZmenIfalC97GHVZWrH1pbM6FP0CNqi7ka2bwPNqdyAaTJNZEZWCov9lbGjLbKPkWigqc431wNKSDrx0n8gdtJ3KcAINpdV43U5ZLCeOPOyzOMJhK5UahwGCEB9+/q/65pU20wnAYRiGo7hYB/ZD4EeRw8Whurn6v1ZCaUs+qFEVkw3pfd9ji86OqIKM1z55JQ8LxdkInJMlNVr6nw64WDs+nM1EWiJRF1TzyxkgaUhvLQOdj3/8po6d73P/5jFOQFB5fv9YeFDoieIqOS8XboMLwWaP4m9zdJGF+yyIvryixDtCiqcnj0GBFwp/AEIbHlSyMYEMMoJS6UiswmXUPyOCprQjzWJmKIWScJM1ExuD1k2vmJhTjGehww0M4FiKn59QN3IZB7uHi5PloasMGP3dz94EOSO0vlnfzOQF7F8gc0OnkBVlkjbwhUytFLlh0nwzootrOwbAABPaUPDfH6ZI3m44Kur/4jhl2n+eKmyv9R8oewg881ZBwcqIWUfm/OUSa2PYr/SFAtylihNNYEjQej9O7WpD5AXJDDZXIqlu/KO5SvFAYbaSE/sDxumBdewwrHQzgcoXRisyVtbZnioq8iqP77NAMJj/ykyNNs5ZILpVTFq+StmAbtlJZNKwowT9J7KLSdv8yq4GqJu+rOM9D2l0H1hARod3p417q15rXLt
 GW5S3eT/
 DMO36RfyAMPmuc4l2w99LjhMnZaV6NbHDf9ooSt4ThRYeGR3qOMDlj0z3n2eH5ov0H4eOfs/1fLzaWB4JE3GFVvWJtcHCd65pILXFYUTVbE/lGD541NLOhWSiJj+wbmSfltywufJ+223fCum4eG20hnXc1JUStIA0NczdALAdDXduIbQnfqFehCE41I+8mzTtnLSfYqUcb1ha91NXP5rlfCtaZPagX2wka0Sdqbbne8pSL86cwbrKUueONI4MJnDQPNpkEr+oAstmKF4y62incKkq8Q==
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

Use the template path unconditionally, as suggested by Muchun. The
page_ref_set tracepoint is primarily a debugging aid, while this code is
still initializing struct pages before they are handed out. From the
perspective of users of those pages, the initialization-time refcount
transitions are not part of the observable page lifetime.

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

Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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

