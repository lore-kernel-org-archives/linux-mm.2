Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93901C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 12:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82F246B009F; Thu,  3 Sep 2026 08:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8069C6B00A1; Thu,  3 Sep 2026 08:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CEE86B00A2; Thu,  3 Sep 2026 08:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DD2F6B009F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:22:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C87B840521
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:22:06 +0000 (UTC)
X-FDA: 85172363052.07.4BF2AEA
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 00D4240002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:22:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Sg9zhbjE;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788438125;
	b=w3/fZ3hho8I5kXcj7yOyFbb0XNMFim/oq1pL3lvx08otJdKimjWLF2pukgt+y5VJPLDTIP
	4sMJM8xjODQNF+osRmKsirZ7eZH9/UjgfBt4hh3vf5CtH2u3RheGVZBWT6FylpdEDgchDo
	5WYyqcPhsKSaM+cZkCEkcgVEKWkgumA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Sg9zhbjE;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788438125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M9z1xem6qEcuUVJMDQZaw5sCruZ2xCngKTtcTUgfBOA=;
	b=OvteWXCBYOFJqy/OLBmJwkEqWVeGQNfb2fguOWlttpvyxfPm4XD4FjGV1C7oF1qYAU7Bvr
	sut5PnRWqHo1RRc4e/IDiDzyig1D/2Ai9mhWVHVpQAfytN28oyvNn3QwQ/d2tH8V/341nf
	DrOzlRuZ0uBcDTBuYMqCKerM8b719Nw=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-853c947bfefso869289b3a.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 05:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788438123; x=1789042923; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M9z1xem6qEcuUVJMDQZaw5sCruZ2xCngKTtcTUgfBOA=;
        b=Sg9zhbjEYzrQAmSdr0OJAz/k/ktF9eG8JQrQutg+NPvVmCy8MaWOy6VwKyWuX7qdC5
         4VSoK9UdyGpScQjjMy6RpoS1Fu+t8WJygvCCm6FfOOiNPdnZcYeLks989tAeIWytKYMx
         NC4KO13Kfim5CkUeGVeA+eNelWiL1I1T4XoiTP5194ZakkupoWflcK4fd27zz7qnrvPc
         LA2ChDFcmU8f+sSqHJRfd1T8cOCWK6MSF33gEK15dZDFMkXAEMZiyVN9dOjCqXJRYgvS
         GS0Eiyetfqm9JKtxyr0fOmOMF6xAnbmtX+1RUM/5fXc+Tahk3J/0zYgKhYrD/VuQd2Uh
         P3dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788438123; x=1789042923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M9z1xem6qEcuUVJMDQZaw5sCruZ2xCngKTtcTUgfBOA=;
        b=AztCH8auiTS+42g5jWxvi7ruskI6vmFYuEtb31tLn3W8CoFKBxmYnApDINet9b4WAN
         jpAxVLVoy4cmTxzO1u4Oqkw7n/ka4i903CYHsD4KCM8GOYTu1YVq7AvynGRiOTAB6z6k
         S9ToNEl/zlWmdk0+V2a5XgQcKrZwGTMf+ajfsZodEdi/FF0XaspLZgkWv30MipQcF1IV
         8qiJMkt0Lbc53LngUoG3x6b86J0ZjCt9q2DcmnCntdoI1sUCg3dRBS/gEymSAXLEaEHI
         Rz3BujfHcx+i2j/A4DFEdCNIw4qqr/VqnKiylsfWUiIcKFw/h0tdTgKfMXhDy8L/p+DL
         vX4w==
X-Gm-Message-State: AFuF++n/iD+W9YSc52LLy35V3EdPH30ru5AbRUbGMglqJExtNcxmlyGn
	FrtIzY6otEMCeWVAhvrB6mgeY0rwLZJ71Nan6eunWpzgXoohnIQAgcUykrJ7cc1ITCQ=
X-Gm-Gg: AYBFou2KDwMcupkAeGac6aAqIAMGKkBca7XmIxLZsOYl7RKWuwe4ThBh1gYp2KU5Jms
	o4tL9Sh0UE0/Ub+xlxgh8HaHUvGhEdm/IbPeHpRH3358xbloZJPRsy6/RXpayL8I2TnE4Y9weYq
	JTCIiqXJvrVDrtWxJnBNkdjAgmc7yo1uWSveq4Qe0WrsrYrqkk09zKHVppWzgmsRXxA5h3r5kQh
	TMIuR14uSbs6f7IBybE6SdnSdSJ8iioNjXA6X3RTaIlOjWXfDFiEOWP6CnJn0u2mm1urMmp2ngu
	QcV/pWjSin5u+oDKQem6vnkhtZxFK4ZWsasPJOb8v54MI4DrOHdroEys5jA+sP2JI0lJF9Huven
	TfMJbmijhzDOym6tPVYPASQn9fbKU7+Qt7LwJWnMdgY67XvMnb5B13J62Q5iZyb4xsnkgXBHtrT
	LuFECrPQqMP+/shS0krRVUf7uJSCMwlhxCB1TOcqdVH8wM5U4h2rZN5nlCZYkpPf/cEbKGrj2LU
	yLnSNv/U18AtS6N8hD7SRpajg==
X-Received: by 2002:a05:6a00:17aa:b0:84e:c851:a058 with SMTP id d2e1a72fcca58-85ffcb616aamr4808528b3a.10.1788438123307;
        Thu, 03 Sep 2026 05:22:03 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.13])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db24f2076sm2868126b3a.4.2026.09.03.05.21.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 05:22:02 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Ira Weiny <iweiny@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH 4/4] fsdax: materialize pmem vmemmap metadata on faults
Date: Thu,  3 Sep 2026 20:21:27 +0800
Message-ID: <20260903122128.12264-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903122128.12264-1-songmuchun@bytedance.com>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 00D4240002
X-Stat-Signature: 6ottfnqw5jt95mn3yx3acpc7koq6ja58
X-Rspam-User: 
X-HE-Tag: 1788438124-456847
X-HE-Meta: U2FsdGVkX1+UySWJa8q0nnikDTEDm5ze+z9duyX6q2wNDBCZv7CqwYxWyyAqXqEd3p4XIBDx+bcT7BD0OVXHhHnRdkV5Ctw1l7vbT5VJSDGKtqwMGg9Ft0r0atuP3SDX/ZHF9ptyTKW+wSuYgJJEqBCTntobqW8xzIF0OfM7QuOUv8an9ENKsx4WxUCqOSFEXtVWecqahngE3QhEyEUVo9lN4HW+TepVqGMYv5xKA0RzTIiULc1L1SFW8X3INGRKM/mALLP/1LvLUbYDQFx9QM0YfLzRIDy/xG5grgDf0F/a3rLblSaUX6j5KwEKYUCI+aQ+1oI2ZA4lEwhD/C1HAcQjb36w5oDCY1QUrC510SrBkDa+s1ZqYOgnI1wYW1f2Ak/acLd37y2YC6HQ2pM+uzPC0FWT47P2sUURjWxw2SBwj8MKKXYr8zlA8vyJSgTg+cUf1tmxs3QpeBXCDHEk4ULV/oFqEB+kTtWkCQXt0UEOgm5ZqpRzVrcDrLAMOBKLiXpmGVsnpuymmudyL0lXjP7ZuDBApfgstbAsKszjCedOiw8OkRxHagLadH0ipvXVGhODVDEjNsQr1GQYTtfbdzbQV2Zy+BLHQnAdlJJuK1C4Q1/K5Lr4GEXhXoqc1VgHOJHZJ9Lg2v9oB/pVj7dPrEIezlLgFBQVWHTRdkNavZ0qPlPuciwIpm/1NIthx6V58mAldpF0rh5ErwgPp+PQ/O8vex/PRfT+W+jW2jDPVWojfto6q2RdCXWvRH9R+fDaxVbdrlaHfEj+E5SPPBO/rHRU1yZfBgCL4377wFIjy7CxXToKZy6RVAGMu4ZBLBU19ajMndiTXk4R/1YThuRKjHC9x+k4WFfkAdzuqXvrO2kdHSnTyqHfiKwjrMotfFwFVDVREnqudiypJ176baBLC/bRX/5zI/FZGf3Hg+dBvxZMSb2DfbEuBFjWw/Lvzte8twK/0hqtYE5F/nR/McZ
 575x4jTM
 OXsx9HUsG2pezTfCWgpINYV+U1LgVzF2HWmJ4I24n9vh2n4P2lbk7/VcNip0lCFzbplOKobLGx+UocCrcDCcbgx5LC3SmsiJWwrGGRu7H3evdZQh/oX1na5BjOHrSmBb3Nsra4gZZVYI8CR85g9S7M3+tkpK0ArasSrZ0RkUY8BMwvciJKVlTIRaxxjXbGNuhDld/mApoiCqiQQvNCihqO9KBVEfHqeKp0DaCYkdy/VVpY9VZCsirGjSV6clbSNqYSE0TP7nnuY6g7gOYOXNJcR+BXU89viTT7PetbYUr67i+0oQQJsIsEai2ueEssieaTlYWkOljxp22sr5zwy56o0NR6zCBvI4Z3/EQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pmem FS-DAX registers the device range as ZONE_DEVICE memory, and the
kernel normally allocates and initializes vmemmap storage for every
advertised PFN up front. Sparse backing storage and workloads that only use
the DAX direct-access path may never need writable per-PFN state for most
of that range, but still pay the memory and initialization cost.

Opt pmem FS-DAX into the shared read-only vmemmap mode and materialize
private metadata before inserting a PFN into a userspace mapping. PMD
faults materialize the whole PMD-sized metadata range. PFNs that are never
faulted continue to use the shared metadata.

This shifts private vmemmap allocation from device registration to the
first DAX fault for each metadata page, so the struct page overhead tracks
the faulted DAX working set instead of the full advertised pmem device
size.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 drivers/nvdimm/pmem.c | 1 +
 fs/dax.c              | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index b14f75daeda7..5530b32163d3 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -543,6 +543,7 @@ static int pmem_attach_disk(struct device *dev,
 		pmem->pgmap.nr_range = 1;
 		pmem->pgmap.type = MEMORY_DEVICE_FS_DAX;
 		pmem->pgmap.ops = &fsdax_pagemap_ops;
+		pmem->pgmap.flags |= PGMAP_VMEMMAP_OPTIMIZATION;
 		addr = devm_memremap_pages(dev, &pmem->pgmap);
 		bb_range = pmem->pgmap.range;
 	} else {
diff --git a/fs/dax.c b/fs/dax.c
index 1fbba0d21c13..89377301d51b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -13,6 +13,7 @@
 #include <linux/fs.h>
 #include <linux/highmem.h>
 #include <linux/memcontrol.h>
+#include <linux/memremap.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
@@ -1877,6 +1878,10 @@ static vm_fault_t dax_fault_iter(struct vm_fault *vmf,
 	if (err)
 		return pmd ? VM_FAULT_FALLBACK : dax_fault_return(err);
 
+	err = vmemmap_materialize_page(pfn_to_page(pfn), pmd ? PMD_ORDER : 0);
+	if (err)
+		return dax_fault_return(err);
+
 	*entry = dax_insert_entry(xas, vmf, iter, *entry, pfn, entry_flags);
 
 	if (write && iomap->flags & IOMAP_F_SHARED) {
-- 
2.54.0


