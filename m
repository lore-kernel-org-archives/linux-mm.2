Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29CB9CA9EC1
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 16:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375056B009B; Sat, 10 Oct 2026 12:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34C186B009D; Sat, 10 Oct 2026 12:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261CD6B009E; Sat, 10 Oct 2026 12:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2B9C6B009B
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 12:21:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85E43140593
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 16:21:55 +0000 (UTC)
X-FDA: 85307232990.13.20B3D2B
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id C0A0A180005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 16:21:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="aeDg/6Ji";
	spf=pass (imf06.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791649313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+tttsdNRPkGTFHD+cQkqcfUTsQCG7wUbwOdSg+1Yvk=;
	b=vxLlBkRNLEOWewEb4ZpxSkElfDrtBSRrZr2vf9pwlbR4RtwTedkDAmD38hKDAh2EwQaPF0
	vpll/MGE7R7QwXV+53vw7oPfrdvIj9xjpQOCtEaAjk/UNBK6syBjG72FtCQlxvVU/g4WiV
	p84CzQXoxOlVBAToneF5y1GXnjxOazI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="aeDg/6Ji";
	spf=pass (imf06.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791649313;
	b=mB4nsOcsuBuUKgWLpTAR+UDrDxOfeVXZOKEH1MZFj6g6qg1r19Iv91pWlRFLofE5b4zCzz
	JliYNhzkEt+iSA4Q+mCxFKoGFzU5a/3ZQ68kxvr+sc1Gx49dho7YfOobYo4BRf9Th2uEiJ
	OKHLqTW+CNUKP7GoLNNEXFhSxJlwHpA=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-33c2520ad38so1484915eec.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791649312; x=1792254112; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f+tttsdNRPkGTFHD+cQkqcfUTsQCG7wUbwOdSg+1Yvk=;
        b=aeDg/6JiP1fPiauMuoHgoaAYgGObfCZrycKUMEKmo6W5/cHOliRHILO3hkb6umyjUf
         /3wo75Z2ZG44+qMpoG+BKyExkQOSlbzO5UrWwOTgoiEYwZJ0Ijo3Ohr2MShOj5pxzKCb
         nY2z1FuGP79cdH0mrdUVUJVWxXtO15NT6VDzU5YJ7woueoqIHUhuSwR4li+idkqMP5o6
         4TDGdzTW9FE/rKiIw+RHspdMdlZizJO7DRpHe8CgjFC2MzeIzTeuJeYVzzDKf99FqyMO
         ebevfm/GPECc2MMtaGxYnaJw4+0kBdiCjtxndZdjfT4mfusntkTYFYS0pAXF9EzNGqW1
         YaRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791649312; x=1792254112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f+tttsdNRPkGTFHD+cQkqcfUTsQCG7wUbwOdSg+1Yvk=;
        b=CtcEGrNDAOu01Db+roZKiHvVyTaVdwfNe+5HXx6FMCI1Oy9kiBGoDFS1opjTtowjpd
         aV/bPtM0/l79UoNAAirgml1WPyNQxcjinLzcGMIBFWIFr/sHvEI05+m2Ntb/7FRd2HKF
         H6yx7LxA3oIbtKh4M4tdMPUY+Nb5ecjZF/MPjCpTF2mdHefHqqsLWTjxIfSUagxdcO98
         bE1JhgAloe94WE2oZzEIMnT/9fwPSyyWHFuMUnbeVKF3o6BT+cn8NYuoSiRr50gmVXsC
         YL2koURoXtzUeSQQLqfmcxRz9jU7Gk/n+IkkDqt/6ooBNg1v3J4BGKaLzXEc2POjJAmY
         5u9A==
X-Forwarded-Encrypted: i=1; AKwUvBwyYcGuvX5fmUg8wzoKmpljjeEpdv5fysT5kP33a+pLEsDrUe/gO9EaJ2JZB4iJdLVIzs8Merax8g==@kvack.org
X-Gm-Message-State: AFq9FYIZx+GrZDvNT9ewgbZLCiimaMeANI+rVrTgozBsd5EdG+dTMVil
	tJcdHm7Tk04mxhOw20Dv2ceLH6VLASzpCeTp7zKYMkoAabgC2DHCGO2i
X-Gm-Gg: AYBFou3T/SXd0ufj0O+Dxlo6+aawL5soQMnnX8t0IMzIHjPJ6/Wuggq1wS1Xbm3N6Vm
	A4W6k96UEd9H+Jmsmb+WVrSdw0TSXviF0FzQlLW+Bimf/u9nV4836DfD1lzmtB1oHG8/13UdRpj
	+/WQSjRWrvpLiysMi49IbN6rAWUuUIqotycfxiZZ2jYpftge7XI/jZP1DPJtgHYPhf0GSmpTVVH
	V3PlLsHCb7Y+vDD51/gr9uQ+ZhBr7JSLwR4HW2NFLHxfoo7xxZhnHirsJrlEqAgR9EZX9d942pL
	oiIvGkVej+9+xGztbmgM1/BkO9kry/XG234/Od+DsKwbklp88hya0kFarB9EanjVUIh8CUFEy6Q
	D4zrLpZt1ssPonZ1wrMFRBIY4YQZF+C7N8clGrlXEia+CEXk52Ootc2RpuJqpcauJl3XdsUcmmD
	h5+MTGVKYlufds8QUdiDuCGslvRR1lJe06qam8g+6TMwtnVmhKGUjkKZrr30YihTTeuiXCij9t2
	HPe6LbxyUHEob0zyw==
X-Received: by 2002:a05:7022:28f:b0:14f:99a2:1715 with SMTP id a92af1059eb24-16a612bc067mr7503413c88.39.1791649312371;
        Sat, 10 Oct 2026 09:21:52 -0700 (PDT)
Received: from acer-nitro-anv15-41.. ([115.96.176.39])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a3f6186fsm15778622c88.14.2026.10.10.09.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 09:21:51 -0700 (PDT)
From: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
To: Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <djbw@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Breno Leitao <leitao@debian.org>
Cc: Ira Weiny <iweiny@kernel.org>,
	Li Ming <ming.li@zohomail.com>,
	Richard Cheng <icheng@nvidia.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Kiryl Shutsemau <kas@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
Subject: [RFC PATCH 5/5] cxl/region: Register device poison before exposing RAM
Date: Sat, 10 Oct 2026 21:50:13 +0530
Message-ID: <20261010162017.62506-6-shaikhkamal2012@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C0A0A180005
X-Stat-Signature: uout1mhpx1aqbpx8eibbtydgzpkpaz9b
X-HE-Tag: 1791649313-93690
X-HE-Meta: U2FsdGVkX1+CjmL7ONXhy5e1i/BR52lIEGsHfVsfVLJMqP2UIS22WNrOrm3SMH9A8vTBgx5I8rnqYPLyAwzajxwnMtlx7cCdrC8JnJFWt3Dx4+Gup8JPacXnUFeTU7WqNoB6daQwBBW01HBRDaoIwjKHpksQai0pmiBD/oMkZwT8v1uiL4vS6ZVcnH8mJ+Z54cEzJEUeIoB2EQoP5O+OZgzeEJYOBDxEIzgirilit8TxdnmIGXH5ZU/V68khpwLWHheOWpOt/Ew5lp3VuXf8nLMt6fr4e2nTqqXHUJX6qk0hGzvtRX/536w803mPUPXCuP0SGvcy8Gn/IyAi3DLCet6v0hDAAF5LW4zG+tYJChNamZnurmFCxn1pP7RXXUsI4Y09k+S6aIWEl+KB8WkKKOWXDwG/8bqeXLfD12EhTDqcKsLj4GjBArCcJwHO6Ai4URYF45cwP1I9oAfDYqWWlWNHT4nywMyn2fVDqZuFdSkgmVRvBqAIqxBBGtsAuNhms4V/nexwVUqw2FGLEgOI8x/CSq3uv1QnU7yxEL0od2CK4nABGii3KRPwxWnZNuoYWL+LVe+dMxmxKpZU+OVr3FtfuddPs8D0oSLZWBiPzGQvGHvTx58ta1kg0k3yoBL6GvrFf+8NUnFpgB4LBqkhxjQRUTgjeH2RnsKR9J2K26cD1WvWwghmLWCK9YpWxxBfbjR4G9VvC5tR8qnfM58GRH0GWRXyA3RGOXjHPeJc2unRYjIzTSggfw3BuTWEdHhWCdkRig5we7D19xKYCO5AI9paBggWWYtOizqRqjrqUHZkCKL+c9rNfbQUyhSQHHdKlScfIQslMxQVTWpKYO00liqeSpwT18BkFjiEaAG2orRBQRlvbf3mtVYFp9SZT5NLKbM9xV6WeTefu64HOzEH4RbSYrFgO+2UF+2v7eh5FPoXRas3fRoVVn8YSS6MZOP1Qgk7Iaimch2ImlE0om/
 v1cr9boQ
 X91Kt+J9MxsbaClxVTcniBok4iUOHta6nbO7UsVZiTYZt6iUfRYSJRSHmiwKXx25iQWdNIgLOLwo9t1PWlq5k1qLAIYB4FYwJQBSU5sgMI2tfzQUCZ1zyVH6iD0JOocNjI7WqFiX8pHaMB7CdkLtUdzRUIQobzkP9HAwF66VR5FgEdYj+DoFKpadOCOFwdZ7ZDflAPQf7g80PEhdLzQX4RScMgeDll2vHaKahrJNsgkiWRuWIe4/MB+AKNIfru09x6GFqu9VIRGMQQdrGBVIbqjTie42W4aJYXFihQ9Epdgdha8EKiDDuZLk0fCV2faYJYPNv5MhyiQ+sRWQQe/1xYcih9Bj0KvlmtuGEmcjEbZqYqrn3KzGaK+jkHNmt72za3tapTnOjRYvaMuSk/ntm3K9+sWio4/IF/R/5GH/le4wfEuNOK71DF4oARn3vJb20zN+5/4tWQavV5t7ObemblfHI9IQdopF0lkOeK1huPCvdEoI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The trigger_poison_list interface may retrieve poison after CXL memory
is already online, which is too late to prevent known-bad frames from
entering the page allocator.

During RAM-region probe, retrieve a poison-list snapshot for each
participating endpoint decoder. Validate each record against the
decoder's assigned DPA range, translate its poisoned DPA units to HPA
and PFN, and collect the affected PFNs in an xarray. Coalesce consecutive
PFNs and register the resulting ranges with the pre-online hwpoison
registry before creating the DAX region.

When Get Poison List is supported, abort region probe if the list is
incomplete, malformed, or cannot be translated. If volatile poison-list
retrieval is unsupported, preserve the existing behavior and warn that
poison cannot be withheld before memory onlining.

Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
---
 drivers/cxl/core/region.c | 322 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 322 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index c72524923b38..e3ffa77927df 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -14,6 +14,7 @@
 #include <linux/string_choices.h>
 #include <cxlmem.h>
 #include <cxl.h>
+#include <linux/memory-failure.h>
 #include "core.h"
 #include "mce.h"
 
@@ -3038,6 +3039,323 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port)
 	return rc;
 }
 
+/*
+ * Device-reported poison is gathered at RAM-region probe, before the range
+ * reaches dax/kmem, and registered with the pre-online registry so the
+ * frames it covers are withheld when the memory is onlined.
+ */
+static int cxl_poison_store_pfn(struct xarray *pfns, u64 hpa)
+{
+	return xa_err(xa_store(pfns, PHYS_PFN(hpa), xa_mk_value(1),
+			GFP_KERNEL));
+}
+
+static int cxl_poison_store_hpa(struct cxl_region *cxlr, struct xarray *pfns,
+				u64 hpa)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	int rc;
+
+	/* Outside this region: not ours to withhold. */
+	if (!cxl_resource_contains_addr(p->res, hpa))
+		return -ERANGE;
+
+	rc = cxl_poison_store_pfn(pfns, hpa);
+	if (rc || !p->cache_size)
+		return rc;
+
+	/*
+	 * An extended linear cache makes the same DPA visible a second time
+	 * at hpa - cache_size. Match the translation used by the
+	 * cxl_general_media and cxl_dram trace events.
+	 */
+	if (WARN_ON_ONCE(hpa < p->res->start + p->cache_size))
+		return -ERANGE;
+
+	return cxl_poison_store_pfn(pfns, hpa - p->cache_size);
+}
+
+static int cxl_poison_record_to_pfns(struct cxl_region *cxlr,
+				     struct cxl_memdev *cxlmd,
+				     const struct cxl_poison_record *record,
+				     struct xarray *pfns)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	u64 raw = le64_to_cpu(record->address);
+	u64 units = le32_to_cpu(record->length);
+	u64 dpa = raw & CXL_POISON_START_MASK;
+	u8 source = raw & CXL_POISON_SOURCE_MASK;
+	u64 length, end, step, cur;
+
+	if (!units ||
+	    check_mul_overflow(units, (u64)CXL_POISON_LEN_MULT, &length) ||
+	    check_add_overflow(dpa, length, &end))
+		return -EPROTO;
+
+	/*
+	 * A corrected error never reaches the poison list, so every record
+	 * is uncorrectable. Only a failure of the device's own media is
+	 * withheld: External poison was written by the host into healthy
+	 * media and a rewrite or Clear Poison recovers it, and Injected
+	 * poison is a test artifact. Withholding either would make a
+	 * recoverable state permanent.
+	 */
+	if (source != CXL_POISON_SOURCE_INTERNAL) {
+		dev_dbg(&cxlr->dev, "%s: dpa %#llx source %u not withheld\n",
+			dev_name(&cxlmd->dev), dpa, source);
+		return 0;
+	}
+
+	/*
+	 * Translate once per unit of HPA contiguity rather than per 64
+	 * bytes. Consecutive DPAs within an interleave granule map to
+	 * consecutive HPAs, and a granule no larger than a page lies within
+	 * one page, so stepping by min(granule, PAGE_SIZE) from an aligned
+	 * start reaches every page the record covers.
+	 */
+	step = clamp_t(u64, p->interleave_granularity, CXL_POISON_LEN_MULT,
+		       PAGE_SIZE);
+
+	for (cur = ALIGN_DOWN(dpa, step); cur < end; cur += step) {
+		u64 hpa = cxl_dpa_to_hpa(cxlr, cxlmd, max(cur, dpa));
+		int rc;
+
+		/* Not mapped by this region; nothing here to withhold. */
+		if (hpa == ULLONG_MAX)
+			continue;
+
+		rc = cxl_poison_store_hpa(cxlr, pfns, hpa);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+static int cxl_region_collect_decoder_poison(struct cxl_region *cxlr,
+					     struct cxl_endpoint_decoder *cxled,
+					     struct xarray *pfns)
+{
+	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+	struct cxl_poison_snapshot snapshot;
+	int rc;
+
+	rc = cxl_poison_snapshot_init(cxlmd, &snapshot);
+	if (rc == -EOPNOTSUPP) {
+		dev_info(&cxlr->dev,
+			 "%s: no Get Poison List support, nothing withheld\n",
+			 dev_name(&cxlmd->dev));
+		return 0;
+	}
+	if (rc)
+		return rc;
+
+	rc = cxl_get_poison_by_decoder(cxled, &snapshot,
+				       CXL_POISON_QUERY_PREONLINE);
+	if (rc == -EFAULT) {
+		/*
+		 * The device keeps no poison list for volatile ranges, which
+		 * CXL r3.2 8.2.9.8.4.1 permits. Online the region as today.
+		 */
+		dev_info(&cxlr->dev,
+			 "%s: no volatile poison list, nothing withheld\n",
+			 dev_name(&cxlmd->dev));
+		rc = 0;
+		goto out;
+	}
+	if (rc)
+		goto out;
+
+	/*
+	 * Withholding from a partial list would online the region on the
+	 * belief that every bad frame had been named.
+	 */
+	if (snapshot.truncated ||
+	    (snapshot.device_flags & CXL_POISON_FLAG_OVERFLOW)) {
+		dev_err(&cxlr->dev, "%s: poison list incomplete\n",
+			dev_name(&cxlmd->dev));
+		rc = -EOVERFLOW;
+		goto out;
+	}
+	if (snapshot.device_flags & CXL_POISON_FLAG_SCANNING) {
+		dev_err(&cxlr->dev, "%s: media scan in progress\n",
+			dev_name(&cxlmd->dev));
+		rc = -EBUSY;
+		goto out;
+	}
+
+	for (u32 i = 0; i < snapshot.nr_records; i++) {
+		rc = cxl_poison_record_to_pfns(cxlr, cxlmd,
+					       &snapshot.records[i], pfns);
+		if (rc)
+			break;
+	}
+out:
+	cxl_poison_snapshot_destroy(&snapshot);
+	return rc;
+}
+
+static unsigned int cxl_count_poison_ranges(struct xarray *pfns)
+{
+	unsigned long index, previous = 0;
+	unsigned int nr = 0;
+	void *entry;
+	bool first = true;
+
+	xa_for_each(pfns, index, entry) {
+		if (first || index != previous + 1)
+			nr++;
+		first = false;
+		previous = index;
+	}
+	return nr;
+}
+
+/*
+ * The xarray holds each PFN once and xa_for_each() walks them in ascending
+ * order, so runs of consecutive indices are exactly the sorted,
+ * nonoverlapping ranges preonline_hwpoison_register() requires.
+ */
+static int cxl_pfns_to_ranges(struct xarray *pfns,
+			      struct preonline_hwpoison_range **ranges_out,
+			      unsigned int *nr_ranges_out)
+{
+	struct preonline_hwpoison_range *ranges;
+	unsigned long index, previous = 0, run_start = 0;
+	unsigned int nr_ranges, nr = 0;
+	void *entry;
+	bool first = true;
+
+	nr_ranges = cxl_count_poison_ranges(pfns);
+	if (!nr_ranges) {
+		*ranges_out = NULL;
+		*nr_ranges_out = 0;
+		return 0;
+	}
+
+	ranges = kvmalloc_array(nr_ranges, sizeof(*ranges), GFP_KERNEL);
+	if (!ranges)
+		return -ENOMEM;
+
+	xa_for_each(pfns, index, entry) {
+		if (first) {
+			run_start = index;
+			previous = index;
+			first = false;
+			continue;
+		}
+		if (index == previous + 1) {
+			previous = index;
+			continue;
+		}
+		ranges[nr++] = (struct preonline_hwpoison_range) {
+			.start_pfn = run_start,
+			.nr_pages = previous - run_start + 1,
+		};
+		run_start = index;
+		previous = index;
+	}
+	ranges[nr++] = (struct preonline_hwpoison_range){
+		.start_pfn = run_start,
+		.nr_pages = previous - run_start + 1,
+	};
+
+	WARN_ON_ONCE(nr != nr_ranges);
+	*ranges_out = ranges;
+	*nr_ranges_out = nr;
+	return 0;
+}
+
+static void cxl_unregister_device_poison(void *data)
+{
+	preonline_hwpoison_unregister(data);
+}
+
+static int cxl_region_register_device_poison(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	struct preonline_hwpoison_range *ranges = NULL;
+	struct preonline_hwpoison *handle;
+	unsigned int nr_ranges = 0;
+	unsigned long nr_frames = 0;
+	struct xarray pfns;
+	int rc = 0;
+
+	lockdep_assert_held(&cxl_rwsem.region);
+	lockdep_assert_held(&cxl_rwsem.dpa);
+
+	/* The region may have been decommitted while the lock was dropped. */
+	if (p->state < CXL_CONFIG_COMMIT)
+		return -ENXIO;
+
+	if (test_bit(CXL_REGION_F_NORMALIZED_ADDRESSING, &cxlr->flags)) {
+		dev_info(&cxlr->dev,
+			 "normalized addressing, poison not translated\n");
+		return 0;
+	}
+
+	xa_init(&pfns);
+
+	for (int i = 0; i < p->nr_targets; i++) {
+		struct cxl_endpoint_decoder *cxled = p->targets[i];
+
+		if (!cxled->dpa_res || !resource_size(cxled->dpa_res))
+			continue;
+		rc = cxl_region_collect_decoder_poison(cxlr, cxled, &pfns);
+		if (rc)
+			goto out;
+	}
+
+	if (xa_empty(&pfns))
+		goto out;
+
+	rc = cxl_pfns_to_ranges(&pfns, &ranges, &nr_ranges);
+	if (rc)
+		goto out;
+
+	rc = preonline_hwpoison_register(ranges, nr_ranges, &handle);
+	if (rc == -EOPNOTSUPP) {
+		/* No poison tracking in this kernel; nothing to withhold. */
+		rc = 0;
+		goto out;
+	}
+	if (rc)
+		goto out;
+
+	for (unsigned int i = 0; i < nr_ranges; i++)
+		nr_frames += ranges[i].nr_pages;
+	dev_warn(&cxlr->dev,
+		 "withholding %lu frame(s) reported poisoned by the device\n",
+		 nr_frames);
+
+	rc = devm_add_action_or_reset(&cxlr->dev, cxl_unregister_device_poison,
+				      handle);
+out:
+	kvfree(ranges);
+	xa_destroy(&pfns);
+	return rc;
+}
+
+static int cxl_region_scan_device_poison(struct cxl_region *cxlr)
+{
+	int rc;
+
+	/* Nothing would consume the result. */
+	if (!IS_ENABLED(CONFIG_MEMORY_FAILURE))
+		return 0;
+
+	ACQUIRE(rwsem_read_intr, region_rwsem)(&cxl_rwsem.region);
+	rc = ACQUIRE_ERR(rwsem_read_intr, &region_rwsem);
+	if (rc)
+		return rc;
+	ACQUIRE(rwsem_read_intr, dpa_rwsem)(&cxl_rwsem.dpa);
+	rc = ACQUIRE_ERR(rwsem_read_intr, &dpa_rwsem);
+	if (rc)
+		return rc;
+
+	return cxl_region_register_device_poison(cxlr);
+}
+
 struct cxl_dpa_to_region_context {
 	struct cxl_region *cxlr;
 	u64 dpa;
@@ -4262,6 +4580,10 @@ static int cxl_region_probe(struct device *dev)
 					p->res->start, p->res->end, cxlr,
 					is_system_ram) > 0)
 			return 0;
+		rc = cxl_region_scan_device_poison(cxlr);
+		if (rc)
+			return rc;
+
 		return devm_cxl_add_dax_region(cxlr);
 	default:
 		dev_dbg(&cxlr->dev, "unsupported region mode: %d\n",
-- 
2.43.0


