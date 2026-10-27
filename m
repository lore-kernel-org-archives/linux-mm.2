Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 426B360A262E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=fBTZK+5F
Received: by kanga.kvack.org (Postfix)
	id 1F1D26B05C0; Mon, 26 Oct 2026 22:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C9D16B05C1; Mon, 26 Oct 2026 22:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091266B05C2; Mon, 26 Oct 2026 22:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA54C6B05C0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4BF831408DE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:58 +0000 (UTC)
X-FDA: 85366894116.30.8DF3302
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	by imf14.hostedemail.com (Postfix) with ESMTP id 96B0F100005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:56:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fBTZK+5F;
	spf=pass (imf14.hostedemail.com: domain of 39xLgag0KCPomgxkpnqwijnkpiqqing.eqonkpwz-oomxcem.qti@flex--kevinloughlin.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=39xLgag0KCPomgxkpnqwijnkpiqqing.eqonkpwz-oomxcem.qti@flex--kevinloughlin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793069816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eHj0mfeE/EOyly5xUtGq8rmazujhmFPCCIldDauievA=;
	b=2hP3wopZOzVUQTLrVBIor4AYQVEyVxTrC/OkfR6Z2iRbcQKusMz1nnWm+ReytLbkhUBMww
	moKRmVKI8kNPLuK5WFWUWfvQIMmrdb2DzSM7umKFM4A349HgSV9ALxOvi/tf14p8r9//BM
	dxIUZHRwGsDlgYheLcMR19epFkbjvmE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793069816;
	b=6FnJpEHTmSeNyVMncFCImftX7Qr7k7ld2neU7LWwjeInWq+dwtN136CnKPC1kUKdH9zPw0
	UIxEZ4SR3F22QPXVVyEQ3UlT8ah+Gd4XLK07jtQx8BrdpuT5iHcd0n2vWS8FW62GcYLx9U
	rS6EHp4062vuPaJbP9/33ukXVlYfRLw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fBTZK+5F;
	spf=pass (imf14.hostedemail.com: domain of 39xLgag0KCPomgxkpnqwijnkpiqqing.eqonkpwz-oomxcem.qti@flex--kevinloughlin.bounces.google.com designates 209.85.161.72 as permitted sender) smtp.mailfrom=39xLgag0KCPomgxkpnqwijnkpiqqing.eqonkpwz-oomxcem.qti@flex--kevinloughlin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-7026e2e80f0so4293868eaf.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793069815; x=1793674615; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eHj0mfeE/EOyly5xUtGq8rmazujhmFPCCIldDauievA=;
        b=fBTZK+5FUljLFUyfHEL6vabFAVdBnvmF25COjq7GibKRAFHReHwNFNZhtRF1ZpWi7k
         xHkKN3R0pk3tQsyc3uQI5q3U4lb0GR0IEO5MTZzPDE4SpT2WcgUaWKvn6i3e11RlGUrZ
         HDMmxsuo/AtPhAwIIUXVMPsJ7oOga+lbo6P0Kp/XAg3VeVaPq+OLwyb4DYj4OKY4JdR2
         XgvDJgPJQa7TsFqUe5nkDH4Rd0dGdVyZlK8KJVSiqIUtf2S+AAMYtFvdSX6eISprv6oX
         3ZQ6C4/3pSklR0RCOH4+JzbdFg0Pn8TlRMDMMu/dEHqMvCtZjMWQo8SZbGnmB6NJNI7L
         ZMqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793069815; x=1793674615;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eHj0mfeE/EOyly5xUtGq8rmazujhmFPCCIldDauievA=;
        b=KzHPvLBgcORx2Ruq5zlUncFZRgOGDZEDj/3eHLpc1rDxXCFYWN5sX5Qj0OSTbA3n0U
         B7nlCGqB6tSlKmhN7jfla/wnSBJ49ID9oVHrTASk5Gp4BxLojzI/iDGvNvNO6xdmvD9M
         0Nk5hr632HTR3nx4/YZ4Kijj7ODhLfz79pNzVroAKaACNEL7bHTWvp+UozewbZRX7fA7
         nGHYDTFy5pL/4hG3a96EU+u8I3km3odZRR5632Gmk5HACi1GcRJIvabHJroMcGDo5ErN
         923NS4zRXb/HULpjqDQVPv8qH1OPMKzHmkZw3AcXzi8UN0btHs7JRkR0hJxptywoZWSm
         Zppw==
X-Forwarded-Encrypted: i=1; AKwUvBzLQ08VzsJZi8KgGHAnim3zsYEZLGJwPMa5pmsCbluRbF8vyAZUdKhaqK6O0P+Vs2kNw/kR87rgWQ==@kvack.org
X-Gm-Message-State: AFq9FYLsw0eKnleB/aKbSn3ICk+uWd3RCyXFyjuJykYbX7Px+BR8pE9J
	eHzAcp/Kpx1JaKThkkCqLZ1ALtAIkWi+abT982Hf9bTMSTQuIZ8ZulJmGygxKBASRCPqGNt9JwO
	jPyssIpNP0EW+7bPnsZ15v0ur/i0gggHlvQ==
X-Received: from ioda11-n2.prod.google.com ([2002:a05:6602:204b:20b0:9c4:dfbe:8634])
 (user=kevinloughlin job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:603:b0:70d:8086:e452 with SMTP id 006d021491bc7-70d8086eebemr3032864eaf.25.1793069815271;
 Mon, 26 Oct 2026 19:56:55 -0700 (PDT)
Date: Tue, 27 Oct 2026 02:56:12 +0000
In-Reply-To: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027025616.1632690-10-kevinloughlin@google.com>
Subject: [PATCH 09/13] mm/page_reporting: account for unaccepted memory
From: Kevin Loughlin <kevinloughlin@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>
Cc: virtualization@lists.linux.dev, linux-coco@lists.linux.dev, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sidharth Telang <sidtelang@google.com>, Punit Salian <psalian@google.com>, 
	Peter Gonda <pgonda@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Jacky Li <jackyli@google.com>, Steve Rutherford <srutherford@google.com>, 
	David Skidmore <davidskidmore@google.com>, Kevin Loughlin <kevinloughlin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 96B0F100005
X-Stat-Signature: t34q6chhuraxxju4y7tstx3oxk3epccz
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793069816-104611
X-HE-Meta: U2FsdGVkX19NymXJDLAXW7N9mItpSz9o0npR7ljC5fRvi1sMCRCcgd3+Fa+CCwVpNivrnRYQQOkn4jOr6FwS4CTK5RTYCryP5rYU4sHiomKFIAL/ZHiZM4b0EIrDGuyvUQ3Egz1XdgMBjh3OZ8cy1SCe7bgcOzyl0l4MHG4t6zeRIYBX5IHKxzBlAoRKZkqO7wfUp/j9DqOAeYcCAD9sN/3Daupkz/crlBZafwjENkYT7YqXYPEjpN8IRzM40vWWW80L7IE4ny1VaMqHceMU7562UCKSTFRoR8D4FSGLszBi0mBfknPacB1Hk/HsJqFQlHiRdszwe58Da3VbC5nZfT0/KwMTL2jcEsMG5LIQY6GGIWpUaK72FI7yhBW9PMn4JAZq/kIaKbWsjbfU3APxNO56gVcExAbFOjdR6U9Mh5/LozSbZUFzQFf8sdW2qmrrJttQPuUbS9kSCozb6i3PmcRWZwTcEy4BukClLRR/tSbtk9/gHKbm37XmtokjRZkzXp5o9xF4eZC+CZLf9TzzAb5gs7qYIuNOT/SlcVwSS7wcj97tbxpFDCuLC46TDbXQvHaUF8hl1cxMj2AY6umWWTbmMKaKABmmqK6yEC3J1UCd2aCO+qjbG4N5llf/YLKFnV3zoScjVPpSQsigrvp0EZCCTtWdVr6LCFkWRlCx8p35I/agZnhAFlvxKQLsjm7NiiBVxaqXKnHRxhGjO+zLxJkCahNUVMGEY1wddTyknEBd+Og9j6H1t2EMbvsGy2OMVRNKU4aivOpkAIyDRBT34nOvNuZY5T9w0Rgk1UP+lXBrPa+u7iERNhWmrECZ5cMq6xJGfipICqt09IuXQwCF7ZMR+ZO2QAVz3X0H3QZMjD4CnO5bbdwgXuWILJRyBOLMt5ln4CsUVRsCeszOrrwtfHwiWwiJ5g8KMZTtJq3T/RSDI7kj03RA45GhDoW04cpHf6mKEvLgxr0k7WOEnao
 1t3n2ztF
 QzM0Fnn/8YK0EuqL8qcIVIcF5erT1CMeQ5cak7rB6wsnMfFFpCpEG9ZZr22CF8YO4edrhw/FYKRqQ8ZCRr4lPhNurZ98Bmn7CX2G+hzbH8gcaIup09QAJSeYzHY2lpMnvsgKgNWArv2AtdsQ4f4/itoNYkEFPiA5NzdoFI9PNpZaZUXCIYy1k21ZUDsFJ3TLt6Uwl4+tRjTJnpuZCbop0uOzvhovmAZdDZficRn+BzuYgx+Ff94AW/mIjkmUO/cEjF+HpvT2s+R2CeTVmObUNeVrHef6Qnk4d/DvDFKUG30WriRNC+VmDS5BWltO/bStkgcnvczh5THSd85zCUFCHSxsk/ncS+f3qc+xWOeT8uL1tOxTSfgZQeKb5CERrw5opE3m7UBf9m+VpJrJyRr5e9CLIm8f/g+IW5WOm2cETh7BI/LNS/fSQ0JlO/P02fmjh7B4GlMtoVtKXvqweAy8ClOH2FycsCCPBOeb6pdmEyQt+GsWylUUOxXhCE21Ul+10WChY6VsGwas+xlxyyBJMwUSsfa1Qgv1n4aWdHaeQjdfA2VXH6gtWHFkaSL7MPKlzn0g1ySr39BR7gbHdD2gfMis58wo8jaBquRw3nNBL4pm+HGzsBnohmwjutb9oCYf5rjKMkvyc9EpcBcczzIQDAlXKvoOx0CDwxWpmnM681+7AqCcSBa2sebJxuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When lazy unaccepted memory is active, pages on zone->unaccepted_pages
are counted in NR_FREE_PAGES (MIGRATE_MOVABLE) as well as NR_UNACCEPTED.
Without accounting for NR_UNACCEPTED in free page reporting watermarks,
page_reporting_process_zone() and __isolate_free_page() treat
unaccepted pages as already-accepted free buddy pages and can over-drain
accepted free lists.

Account for zone_page_state(zone, NR_UNACCEPTED) in
__isolate_free_page(), page_reporting_cycle(), and
page_reporting_process_zone() (using promo_wmark_pages(zone) for free
page reporting watermarks and skipping non-mergeable migratetypes when
has_unaccepted_memory() is active), and enforce
unaccepted_memory_order() as the minimum page_reporting_order.

Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
---
 mm/page_alloc.c     |  3 +++
 mm/page_reporting.c | 34 +++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c10b77304633..541b2eaf34a4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3183,6 +3183,9 @@ int __isolate_free_page(struct page *page, unsigned int order)
 		 * exists.
 		 */
 		watermark = zone->_watermark[WMARK_MIN] + (1UL << order);
+#ifdef CONFIG_UNACCEPTED_MEMORY
+		watermark += zone_page_state(zone, NR_UNACCEPTED);
+#endif
 		if (!zone_watermark_ok(zone, 0, watermark, 0, ALLOC_CMA))
 			return 0;
 	}
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index de587be17801..adacdb015b55 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -17,11 +17,14 @@ unsigned int page_reporting_order = PAGE_REPORTING_ORDER_UNSPECIFIED;
 
 static int page_order_update_notify(const char *val, const struct kernel_param *kp)
 {
+	unsigned int min_order = has_unaccepted_memory() ?
+				 unaccepted_memory_order() : 0;
+
 	/*
 	 * If param is set beyond this limit, order is set to default
 	 * pageblock_order value
 	 */
-	return  param_set_uint_minmax(val, kp, 0, MAX_PAGE_ORDER);
+	return param_set_uint_minmax(val, kp, min_order, MAX_PAGE_ORDER);
 }
 
 static const struct kernel_param_ops page_reporting_param_ops = {
@@ -206,6 +209,21 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
 
 		/* Attempt to pull page from list and place in scatterlist */
 		if (*offset) {
+#ifdef CONFIG_UNACCEPTED_MEMORY
+			if (has_unaccepted_memory() ||
+			    !list_empty(&zone->unaccepted_pages)) {
+				unsigned long watermark;
+
+				watermark = promo_wmark_pages(zone) +
+					    zone_page_state(zone, NR_UNACCEPTED) +
+					    (1UL << order);
+				if (!zone_watermark_ok(zone, 0, watermark, 0,
+						       ALLOC_CMA)) {
+					next = page;
+					break;
+				}
+			}
+#endif
 			if (!__isolate_free_page(page, order)) {
 				next = page;
 				break;
@@ -275,6 +293,12 @@ page_reporting_process_zone(struct page_reporting_dev_info *prdev,
 	/* Generate minimum watermark to be able to guarantee progress */
 	watermark = low_wmark_pages(zone) +
 		    (prdev->capacity << page_reporting_order);
+#ifdef CONFIG_UNACCEPTED_MEMORY
+	if (has_unaccepted_memory() || !list_empty(&zone->unaccepted_pages))
+		watermark = promo_wmark_pages(zone) +
+			    zone_page_state(zone, NR_UNACCEPTED) +
+			    (prdev->capacity << page_reporting_order);
+#endif
 
 	/*
 	 * Cancel request if insufficient free memory or if we failed
@@ -289,6 +313,11 @@ page_reporting_process_zone(struct page_reporting_dev_info *prdev,
 			/* We do not pull pages from the isolate free list */
 			if (is_migrate_isolate(mt))
 				continue;
+#ifdef CONFIG_UNACCEPTED_MEMORY
+			if (has_unaccepted_memory() &&
+			    !migratetype_is_mergeable(mt))
+				continue;
+#endif
 
 			err = page_reporting_cycle(prdev, zone, order, mt,
 						   sgl, &offset);
@@ -384,6 +413,9 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 		else
 			page_reporting_order = pageblock_order;
 	}
+	if (has_unaccepted_memory() &&
+	    page_reporting_order < unaccepted_memory_order())
+		page_reporting_order = unaccepted_memory_order();
 
 	if (!prdev->capacity || prdev->capacity > PAGE_REPORTING_CAPACITY)
 		prdev->capacity = PAGE_REPORTING_CAPACITY;
-- 
2.56.0.307.g5fe7bd680c-goog


