Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93E7AC61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0E9C6B0099; Mon, 31 Aug 2026 07:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF556B009B; Mon, 31 Aug 2026 07:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FBC26B009D; Mon, 31 Aug 2026 07:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87E766B0099
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:18:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FB08140494
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:18:52 +0000 (UTC)
X-FDA: 85161317304.26.BAB62F3
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf19.hostedemail.com (Postfix) with ESMTP id B439B1A0007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:18:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=prEkJkNR;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788175130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PEniiU9yBVKIk2zvd2yZlOYClo4KAi6kKS5dsV5iO+A=;
	b=FYcSyZlGg3qgOUjs5oqq6e+0FxSkqcoLlEV03D/Z4hutMqfSgy4BcnC0UIGGrbhejKqj6P
	Z7y7bA37Vo/6JQsji++7DLx0ScPBmcdZfCmK+Bn7jLLsR+iMOKUvQVQvwLSzM8lWoH/fIe
	SPAT2QYa+9OHX1AtqOeXL1xrwLWdeto=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788175130;
	b=w/hXn2DQI9JxJ0vflFJljfZ+ouNLNaZbMTdGK9s2oF3Nuv6ve1cZfcxJTOSpIzC/dyYwzY
	DIz9AzLWjjRA0rXzRlt/B9cJPVPtnEwwVfgxIxUlip3Of3wj91Aw2DRTabMuCeGcJ+xU87
	HIvchGhK5aT0LgyCnpeqxXtmvtnYzeo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=prEkJkNR;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788175124; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=PEniiU9yBVKIk2zvd2yZlOYClo4KAi6kKS5dsV5iO+A=;
 b=prEkJkNRc94GeiZSlf4W8q32JAwECdSGtcb3NjCxMQDR7pGPv1lEuj0ATTrDle3tKhFBPw
 C+6lbt5K/u/HB5jSuFr6l2aRsOJO7SicZFWkUk3xjNb5pi25FCqmjElXQL4vh4/Ptmd+GT
 SuNtGbxJf551ekNGlNCHQQklJuCjFdx9g0wiwQrxKagMXYnUIN04HwiCfRNuI8PKGldaTk
 ZzaJS8hWjAziEXTUbStoJopTab/LoFtlenjUGBF5WwaGStqLyVPlKfKb3N9I8TaFt3FZxl
 q6WceI9YhGzwhn3r9BHtSu5kJA9k7WazVm5yO0GkmBaxsuS+AXUGVEHKO6c4Nw==
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 31 Aug 2026 19:16:34 +0800
Message-Id: <20260831111638.76012-4-lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <20260831111638.76012-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Subject: [PATCH v11 3/7] mm: add a template-based fast path for zone-device page init
X-Lms-Return-Path: <lba+26a956312+0d0d82+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
References: <20260831111638.76012-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B439B1A0007
X-Stat-Signature: gaex5gznkcm8uwufyookqeaty4m31yhf
X-Rspam-User: 
X-HE-Tag: 1788175129-173114
X-HE-Meta: U2FsdGVkX182YHycUZIh26AmcMSvATUNmPBRzjYvpTLzIrUMcNNG6ifRuiwyag1K9t5D8btHEsastlb/L/7I61p3Cab3oTLKlyuHOKWB6CrmcwJFBAhMPvCh+2zzH/V+tpuhGfdOaswHO5EriAqNficnz/ufB3JmrvlFchsCw8xC4oqTsRFeXJnWipXpXhLpH4mBz9ttq4Zt15PIV4I9lvdaiX9PjFjB9BtTF3OrNxjUNDLYoZzU/JyTsJztszXMM3A9fC1bPU27cxdDX10MO7xU7Js3VJtpc6+ltq/8RNWQxmoObcahDif+a0ZTAB5HFk0XT3GX233Ud7uy+EuLTbJmWULbguzxd5GWxXeIVytXvWLAqQrFxGQDMTJFdsX7E30btMDUvgGiv5gi/H7i/cQcYrP54rPzC76jzw+ZYoHvpGFg2uRAL1lv6yfT6vTYd3IORHznJIwmD6WrJJUH6KVJdbY3D/CL4qKA+t0Ck2wzfZMclx9dkpU2pydHqgOZvf/SbL3r0WvgKjyiOIdnni9EMd1Ppx1MB2heQeMwVZ4TMU1idl+MIRjsvnzP5c8ft/OJ+vbOphB5ECznBOFjzVvYjQm9sorjoyiSAHL/5xJt5b834Wm8McmR6yJX5Iwb070vGfuVeHm8+22A6Kun9HiVIg1hJN3e7++YOkPzDO0I9QqCiD8hlhqQ3ZS+9yzs0is8BFt4EeOS3WWKYhiADcEWoINdrNWK4q0zTPKczXmhlAxrbCj5kLy2G/4D2KuJcFZyYmUX4FgNYs89abIHTltuEUKOuFvFeBDYmGhEroU1S3zXRhQ0NNdtjjnOpskU6jKFb70RJx3PZjxMBt3RPyVqYcElKlwTAHOLQtTnn5AUqInJu8EeIuc6V4TUA/46XxTjsbI7f89s3QbpxJdJq6/o/6WnBbO8/3og450CGMFnrsE+5ZwBv+XqMZqQcagz5gLKhM+UkHqLc/3ePoD
 v/knEnNX
 p5ANP25WRBSFq/aoQMbt2l8GT+SLAihrHXbi86v9YgSRyQRSbfzDygLQ/1G/AIhbP+NipyeEghMc0cPF81zCBBtH7KPG5uXOYpCkkXM9RCMatdZU/prWLSkUq8DB3gH/2NnGgttCQgEYaP6HwPrT88Sp9E8TISsUF3uBeoVxVzSqTcciQxgBjtRO07qr7yL+44VU3WLbroN6/1sPwx+WJq1zykdRjBVerdmJOhZ+JzK1b7nqUZQb0NR5RvWuGbSWyK+Yd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() repeats nearly identical head-page
initialization for each PFN. Initialize the first real ZONE_DEVICE head
page through the existing path, copy that final state into a reusable
template, refresh the PFN-dependent fields in that template before each
copy, and copy it into the remaining destination pages.

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

Base(v7.3-rc1):
  Average of rebinds for nd_pmem driver: 221.07 ms

With this patch and its prerequisites applied:
  Average of rebinds for nd_pmem driver: 155.00 ms

This reduces the average memmap initialization time measured during
rebind from 221.07 ms to 155.00 ms, or about 29.9%.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 8f73d5850db2..ba4148de2b28 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1017,6 +1017,17 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 }
 
+static void zone_device_page_init_from_template(struct page *page,
+		unsigned long pfn, struct page *template)
+{
+	set_page_section_from_pfn(template, pfn);
+#ifdef WANT_PAGE_VIRTUAL
+	if (!is_highmem_idx(ZONE_DEVICE))
+		set_page_address(template, __va(pfn << PAGE_SHIFT));
+#endif
+	memcpy(page, template, sizeof(*page));
+}
+
 /*
  * With compound page geometry and when struct pages are stored in ram most
  * tail pages are reused. Consequently, the amount of unique struct pages to
@@ -1079,6 +1090,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
 	int nid = pgdat->node_id;
+	struct page template;
+	struct page *page;
 
 	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
 		return;
@@ -1093,10 +1106,29 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		nr_pages = end_pfn - start_pfn;
 	}
 
-	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
-		struct page *page = pfn_to_page(pfn);
+	if (!nr_pages)
+		return;
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+	/*
+	 * Seed the reusable head-page template from the first real struct
+	 * page. The normal page-init and refcount helpers must operate on
+	 * a real memmap entry rather than a stack object.
+	 */
+	pfn = start_pfn;
+	page = pfn_to_page(pfn);
+	__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+	memcpy(&template, page, sizeof(*page));
+	if (pfns_per_compound != 1)
+		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
+				     compound_nr_pages(pfn, altmap, pgmap));
+	pfn += pfns_per_compound;
+
+	/* Initialize the remaining head pages from template. */
+	for (; pfn < end_pfn; pfn += pfns_per_compound) {
+		page = pfn_to_page(pfn);
+
+		zone_device_page_init_from_template(page, pfn,
+						    &template);
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
-- 
2.20.1

