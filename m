Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C897CDE002
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:58:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D78A6B009E; Wed, 24 Jun 2026 10:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55EEE6B00A8; Wed, 24 Jun 2026 10:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38CF96B00A9; Wed, 24 Jun 2026 10:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5F6B6B009E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:57:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3DF344039D
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:57:59 +0000 (UTC)
X-FDA: 84915111078.14.2314787
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 56045160003
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:57:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PXgMMrLY;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782313077;
	b=XMaBmcvs+CdhNjqyHC8KoDOdjce3QkGSyu7Wz8GDd6DePgVIwM5cBHr4mbuTxamHn9j622
	A7ATdqWZ4I+6cuRJWkrNo8u5M95IGaJEdsS2cmwY117pwBUCHErLG1oerFXBEcZs0IImXY
	WApC6hMgEa+xdGC9GSSE7KtMfEYm+n0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782313077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5N7tLwBQJv8x9qNdxv/vKv4Fda4fwQcQqQmjxm5j+/M=;
	b=YSz/+QIVF0ASqejZlM/HQsHzKfNuYWKFzuEzGGZ7gSRXTGCfsILBJjpQdM4KmRJAGHDxM3
	Vg6fEfqZJDV/mzPhHLM3gWxeZl0JZLSBHhDVEduTzenbgm11vEDNtn8TzNuQ8kmv8MxdAU
	Qayki52IdLWO6cUF9Es6qUfgHV9l178=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PXgMMrLY;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-517b1f2c6adso9593961cf.2
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782313076; x=1782917876; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5N7tLwBQJv8x9qNdxv/vKv4Fda4fwQcQqQmjxm5j+/M=;
        b=PXgMMrLYjGJXjz4EiwI7ANZfLh6K0C3M+VeyDSl9jbrLG3ghhZUnSyOC0Ws6Ci9qGt
         xH/lONp/WfR+Y5TrX/lbvrL08aazJGPXwYzWgezZnLbXXj933DWn3niBhKimTT9Azj7U
         /S2vqCohQCcm+fF/ZopRe4AESIpPM5Qq+lNRwqSuAFs0NbTgNT2ZeAfVJPfBGGzUaQoR
         vhY4dhHIx+/GqK7jZkWcGmUc5mvpa+DGW095LcGborY+8amW1ZK1ZQr3pXOK9ffS37US
         2+z04Z7XKLdq6lRIZunyRtu36U5CdkkffnGGb1xz6ao3qKvcE2atgl4YYAsTrlodV1ds
         GW0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782313076; x=1782917876;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5N7tLwBQJv8x9qNdxv/vKv4Fda4fwQcQqQmjxm5j+/M=;
        b=GbScqm2p0Kme5G8UfL6WszLeWhM/6eBcUBo/6IcOOfpshXPAe+SWPYrYfAd1N+YEdm
         tSV9tL65O6XRAXHAXWARIotKtTFotPFtZ6ufEGqkGOWvsCwiyd46sO9imN/kf4VtixLJ
         yW0QxzQlojsbbfX46PbcPFdBvo7KIklyRmeRX111hsFlbPPVuqw7QNzxVMYdry6A1kE1
         UOptLYJ/Vy4HnyPKUslbJuZAZqdW2eMCT0+YZn7PGHFQHt45yb6yeBA6DzAxMbffRbVD
         wG+b8HD0m38rTW2yV4L5T7M+CzNNe7PvjUNJcDXjBC+XdQtUpbNQrDuRsERUFQzlU0vs
         T8zg==
X-Gm-Message-State: AOJu0Yz7SJUni4QC1v5vbz3dkW66bUseahi+Rm4m/2i+NuafYxxZ7ihc
	438Upg7ScpBp2imOtRW8cPeed/rxb2QRiZ+UzMLY017J441bjw6ZP4iIpSz41FKHiXJtqEHKuyB
	NwIVI
X-Gm-Gg: AfdE7cktrIu1wI5tB0wHGWXKEaM5Na8sqmWLy/EOHcNq41mNoet7uh57POHHrz3jARM
	qEiYwS7qgbe0C1FRB3qDllNtxZ3/CK+HkLpE1xd4dP7uzHPrBXEWyDjzM7u8WnClj6xF3XdfPoQ
	FldqJL6+hWKuqCDZ+ERfjmysj8XnK83DNgvWSg4CNRi0Eb+wAZY2X2ib9I+3SbVQ8Mdvh/QARFR
	8XiHimckVLbTvdOk5Wwpvov5Ojtof+Fv0Jpny4dJBQRMCddNqk0Fsx9/uH8+vIX2oydB2Z3FKRK
	YoXNzzVRi3wGJ57LoVyafqa02iqzsNYAVGqxj0piCY33rCrnhmqLP4sugwsQ52fLDeHeixbazST
	WYW9Xa7NAlNwDdnK+126hI9ioi+4+b93ClNHMmC8EumVpm5wUTCLEVkr06ximsz7soiql1Qvm/J
	a3+d9cQMsTHNE54TBa1MGi74HrwOt399JYPxNGRwotTd/qg3c6eLN3qCER7t7t5iu5vXgN8o2SK
	SAJHtryB7rt
X-Received: by 2002:a05:622a:144f:b0:516:d84a:9f54 with SMTP id d75a77b69052e-51a5484ff5fmr102012121cf.38.1782313076353;
        Wed, 24 Jun 2026 07:57:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a51ae8ee7sm49502301cf.24.2026.06.24.07.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:57:55 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v5 1/9] mm/memory: add memory_block_aligned_range() helper
Date: Wed, 24 Jun 2026 10:57:36 -0400
Message-ID: <20260624145744.3532049-2-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260624145744.3532049-1-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 56045160003
X-Rspam-User: 
X-Stat-Signature: 6nq9578dpn8gfmfmygonzdit1w9r9iyo
X-HE-Tag: 1782313077-691467
X-HE-Meta: U2FsdGVkX1/emMYxAtr+3VuSLwj6mSJDUtUMuk1A8UBeIT8ncHs3U6OL6/2KdnrGP7uEuWoTqFsdFoQ9xFHAuZaoiIYW0TrB0tnpdSuAHnf0EoG9uGBp62Gc2lTsWceYtINdAxY5dVuEx0Fc/k5Kdvj9bc7M7kHgZdb+zIFlDU6O3YhvXQNsdjp6nwl8TnN2qPcSwIEmau51Ct/j/rExZdGMwYGcZSKwE+DxYlZheyNTsnQy3McRhmgXvqOddBLC9EnEBKX2vAElJElVrIrH/VEtbEM0vu+MQKVf1DVkPK1+aWaG2ir+Fbkz5Xj3A1JgQTolNttPYntTRkZGKn1GR9SARoIHrQKp/2dEPntEd4T64xNHm/39AuuOeVN0Co6DByHVbTf/yghu7p6tqLTK15TYIz246vSugGdioMoKWGyk2cDInVwVJXyoZwRmOc5yH2Ctl+Nqqb35OpgAA2++X/z0pc7NNLVyEKA7sZkOhVapRKPwe0+iUKz4H6GEyxtfrhQmo3M3aACij/CGaCJc932Ar1gOVj4YmL6QcLy54mF/Dvi16kXjpzmxiPwTQBCMWSsl4216b3jWYX2MtJTaijn+PajRircA/4yVTiX+14i1TeTFdsuC2kzfmkl3yhGpimjp4aqTeS8yn/cywsGJtg2RaI7M9BlszA7TqrIX+Utb5EE6ADq6WEgqhFq0mv50wlBRyIHUZ6aRIyWibp4qQKMBZPzFHlNE+2GVepjlOIPI1RM/9ZOUkQ3TJ+BcAScJYJSoV9g7fVdXUbL3K4fry5R67Jn2WBOUf1eRTo1mvl5OpLoD5ai9UNN8joht0HC5ofLG7pL6bQViO/HTxVyHCbeDIOeogk4eHuEAGv5gJNoc/7QJNhXZ30YsgEez5VR7s4LtHkZtsBP9xHeTxzmMtgoqMarUs/PhNYZ9YFHqKVqv2UcfXjmcbSt31wJjQPP0cQk450TxHEivVQmIQhL
 tkgpugPe
 gNUbPvvPe0xGmrhUDXQfF2wCxeOl6MDx2juxv1sIow78uX80abvlOpPb2GfuAcxdJYtiNMSAIsUCqQks2Ov8RtK3ptKkHkB1XNBYu7HDiStgMiaytfKaErViF4dZ2EpvoLRiC9Z85VrvAYC08OCuy0KjSXkZ8ATeQ1/SKhfb9ulQt7+UR36z0Jv6g7bBFQ/Sjv5R74OEnuR1cCZdn/ksV4jXWhahsVlM+s/PTchDF2LvvIMQ8B0vQwt15N4PlHZIR9d5fuijnZevjg2yuyEjo1yymrD9VPZoOWg3/CZ+RUteYLmJKlT2vnzag//gUibCaawHioYC4WiXgfoc8NKfW0I3/9MOG/IbBqNGhdftjqtG72XkuC+SBGWVfsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory hotplug operations require ranges aligned to memory block
boundaries.  This is a generic operation for hotplug.

Add memory_block_aligned_range() as a common helper in <linux/memory.h>
that aligns the start address up and end address down to memory block
boundaries.

Update dax/kmem to use this helper.

Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 drivers/dax/kmem.c     |  4 +---
 include/linux/memory.h | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a18e2b968e4d..592171ec10f4 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -33,9 +33,7 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 	struct dev_dax_range *dax_range = &dev_dax->ranges[i];
 	struct range *range = &dax_range->range;
 
-	/* memory-block align the hotplug range */
-	r->start = ALIGN(range->start, memory_block_size_bytes());
-	r->end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
+	*r = memory_block_aligned_range(range);
 	if (r->start >= r->end) {
 		r->start = range->start;
 		r->end = range->end;
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 463dc02f6cff..9f5ef0309f77 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -20,6 +20,7 @@
 #include <linux/compiler.h>
 #include <linux/mutex.h>
 #include <linux/memory_hotplug.h>
+#include <linux/range.h>
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
@@ -100,6 +101,27 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
 unsigned long memory_block_size_bytes(void);
 int set_memory_block_size_order(unsigned int order);
 
+/**
+ * memory_block_aligned_range - align a physical address range to memory blocks
+ * @range: the input range to align
+ *
+ * Aligns the start address up and the end address down to memory block
+ * boundaries. This is required for memory hotplug operations which must
+ * operate on memory-block aligned ranges.
+ *
+ * Returns the aligned range. Callers should check that the returned
+ * range is valid (aligned.start < aligned.end) before using it.
+ */
+static inline struct range memory_block_aligned_range(const struct range *range)
+{
+	struct range aligned;
+
+	aligned.start = ALIGN(range->start, memory_block_size_bytes());
+	aligned.end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
+
+	return aligned;
+}
+
 struct memory_notify {
 	unsigned long start_pfn;
 	unsigned long nr_pages;
-- 
2.54.0


