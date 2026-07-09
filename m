Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A06B6C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 11:28:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 918716B0088; Thu,  9 Jul 2026 07:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EF216B008A; Thu,  9 Jul 2026 07:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82DB06B009E; Thu,  9 Jul 2026 07:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC9E6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:28:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F19D61C069C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:28:53 +0000 (UTC)
X-FDA: 84969016146.22.B00852F
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0660010000D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:28:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=kwKIzdWJ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783596532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJcKYOJQhKyg/isyMbMzrX1li+G0ZF58QSuW2HC410c=;
	b=PLwAn14HKNkws3jtaU8vc7YwLG+g0RcDJQX3LcvuNynfeHhpGAylXjcQMP5ev5Q6rC/fUv
	jSyys3jFeN848EQRqWd4nIZwixrBkiESrSZDmC4Z79Akuc+xIzZVI15hM2KkLXhA3IjIKf
	vJ8RpIkEqTJk391KZQL2wxsmfkKU+gc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=kwKIzdWJ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783596532;
	b=fwWoB+XpuWDxhaOV32T1fGZOuhbiAibQbkfQDWtcrpXNIdZZaTrYBRtlpcmvzeRN2mAx68
	eYkiVLTnQDzAHfnlXCqL2nPmjgT0wlOoza505JwD65A+mAoVShu3lREED4LklC17k4WUmB
	Cun0DeatLuNNimPlPl/AKjng63O5lzg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783596527; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=UJcKYOJQhKyg/isyMbMzrX1li+G0ZF58QSuW2HC410c=;
 b=kwKIzdWJAlIq6wGx8BgDz//6S0ckbT7x52bNr5qRL0mAfXe5FUrk8K9jV+vJ3GqcG4QqNl
 awQbHDCeAcBw6PVa2QXO+v+9fF9hLg8OG2k9ymylKNLVUi6HZxMmky1oJCkeMcdK7ICds7
 GMpURhN7E5wXZtnKxZLpdPTApnCrn9B0yNt8fnIRAQ/+gp0zaYtk2/2OpVJGr64G18vzz8
 n7lnAFIsCwyTQBI0Q3WDVetpP+4Gb9/ZA0k3Ot3MMNIK4l1EF9ieN7BsZ5uOcAtUW9SgzX
 u9aX5GEflM9TfqtonNut8gyMXmGW7QIFpkUuyi/PzBPhY8yhEsIaRQomO9AYaw==
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a4f85ed+c0435a+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
In-Reply-To: <20260709112520.24857-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <x86@kernel.org>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260709112520.24857-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>
Subject: [PATCH v6 8/8] mm: use memcpy_nt() in zone-device template copies
Date: Thu,  9 Jul 2026 19:25:20 +0800
Message-Id: <20260709112520.24857-9-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0660010000D
X-Stat-Signature: wys4t1ikzkdz5c6rhd8uen3ont5kmu1x
X-Rspam-User: 
X-HE-Tag: 1783596531-172952
X-HE-Meta: U2FsdGVkX1+a8++1SCnBeegugVT7to6HWCPbYr3518fHAyptNO24oH3GyWy3JNOep01Un3U2VWEjVzM21x1i8Tvz5qwv+gVlxS3JG1pv/jHsMfpCv21SkaE/ndyw2VZvvDl0SlCR4GCMVFKj8lAiFcWu8JbW7y75GO8yCy/2xw0dG4jDoNDX9V/k0+2n/3paZXpGaPRQ/wpcl+Q9QKxvQJox/VkG5UKPv67uLw8xG/s+GHq6Gm+8mJXxB609y5QJ2EcP/FetBlEJmoCmjiagjFzUBo9WSbJ5DVzO/VRh7uXA7GkrdP6SHoenFaQpOCY931KaAjKHS+Aa1kI3hyx6cy/IFWJEDP9kMNggGuY7mDzRyYV9iX13v9Y1JmbIrmznvOFBN0c6OWFKXcr1JKNyJO9NJxYOwigp5M/mdakU5vu3YlTZxDhYvrH4HzYguQvkjEyNGw5qU5sCntunTPqiY3FK7W8Fo0WEVx0RhCDbjiMqgAxbbc56Wp0BRxg4aSwnnIJAxHnLLSfyclnk6ysUzsf0XagZ2cJoWqil02nJbAVYZi2UwMITPNTXeEbQz9+dHp6278tQKMqxuT1uO49hDviC4AcrN4oNl3sDJVxnN06oT+dokjEvWoTYNRpE+y9StUly6PQaHg3xgNdEJBDw+K1d35ifuC6Iwelb4cKo3uKHolE/MRSOsySMHgfBqVQIn8p8vi8xeElNJogI4re+Bs2ABZdgUxbxmJJ5rwfRH/m3RdY8wARcwV6heRsBQv+sWmOxsDPozGFgTBYsjCXU6KPjO1j8FSWBJv0HeRZdlRZrGELP3SOU/ZJQ9PB9OIJ3D73dp+pmnRIA43DzIkCO3r2JfkTKTaMDDMkjSQybc5jGSR3a4GxuwHxZkW/0lrZLa84EtCBPv9izk2mdWER4wwDvKaMew0b8pcXOLInQYcZm97hu2jKwFcUap/7Z3C2YmEJGq1dJZdDaqCQ8QxJ
 qDsVuojG
 wbSXCWuqLs6XivFRimfiddnZC02GODwsak5/avGpnBde9OWiT+GkTZiNUSaTMAsXrLwzg12bbPnwnX2n+27UMjAZLVbsDAgATJgv59+d31g9JbSzquqS0SHbebRBblMyy7KnHL2StkwhxvW1eiaZANZgV3pYeDhWcHQmEZkBtONU67fGQKmp1uYGO3VCo44OiMX16xQtiQM02eAaUhStf5+uxoUX8F0R1VN0Y/KwIvTpZ3Yq0QmGSlkwGyuTvq9D1TDffEqxM+f8eiqgkUqlNFD7WwS1GQpBMbFd19PyHr0lgC6YNq9nHzTqczg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The template fast path currently uses memcpy() for the actual struct
page copy. Switch zone_device_page_init_from_template() to memcpy_nt()
and add memcpy_nt_drain() before memmap_init_compound(), before
prep_compound_head() updates overlapping tail metadata, and before
returning from memmap_init_zone_device().

ZONE_DEVICE memmap initialization is largely write-once: each struct
page is populated once, and most destination cachelines are not expected
to be reused immediately afterwards. On x86, a regular cached memcpy()
can therefore incur write-allocate traffic by pulling destination
cachelines into the cache before writeback, and can populate the cache
with data that has little near-term reuse. Using memcpy_nt() lets this
path request non-temporal stores for that copy pattern, which can reduce
cache pollution and avoid part of the associated write-allocate
overhead, while architectures without a specialized backend still fall
back to memcpy().

When memcpy_nt() maps to non-temporal stores, order those stores before
memmap_init_compound(), before prep_compound_head() updates overlapping
compound metadata, and before returning from memmap_init_zone_device().

Keep sanitized builds on the slow path so KASAN/KMSAN retain their
instrumented stores.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
server.

Test procedure:
Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.2-rc1):
  First binding for nd_pmem driver: 1456 ms
  Average of subsequent rebinds: 244.28 ms

  First binding for dax_pmem driver: 1462 ms
  Average of subsequent rebinds: 273.31 ms

With this series:
  First binding for nd_pmem driver: 1272 ms
  Average of subsequent rebinds: 96.79 ms

  First binding for dax_pmem driver: 1354 ms
  Average of subsequent rebinds: 119.04 ms

This reduces the average rebind time by about 60.4% for nd_pmem and
56.4% for dax_pmem.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index fb855bb0437a..addb4969587e 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1067,11 +1067,21 @@ static void __ref zone_device_page_init_slow(struct page *page,
 
 static inline bool zone_device_page_init_optimization_enabled(void)
 {
+	/*
+	 * Keep sanitized builds on the slow path so their stores stay
+	 * instrumented.
+	 */
+	if (IS_ENABLED(CONFIG_KASAN) || IS_ENABLED(CONFIG_KMSAN))
+		return false;
+
 	/*
 	 * The template fast path copies a preinitialized struct page image.
 	 * Skip it when the page_ref_set tracepoint is enabled.
 	 */
-	return !page_ref_tracepoint_active(page_ref_set);
+	if (page_ref_tracepoint_active(page_ref_set))
+		return false;
+
+	return true;
 }
 
 static inline void zone_device_tail_page_init(struct page *page,
@@ -1110,7 +1120,7 @@ static void zone_device_page_init_from_template(struct page *page,
 	 * to the destination page.
 	 */
 	zone_device_page_update_template(template, pfn);
-	memcpy(page, template, sizeof(*page));
+	memcpy_nt(page, template, sizeof(*page));
 }
 
 /*
@@ -1179,6 +1189,15 @@ static void __ref memmap_init_compound(struct page *head,
 							    &template);
 		}
 	}
+
+	/*
+	 * When the template path is enabled, order the preceding tail-page copies
+	 * before prep_compound_head() updates the overlapping compound metadata
+	 * in the first tail-page descriptors. If memcpy_nt() fell back to
+	 * regular cached stores, memcpy_nt_drain() may be a no-op.
+	 */
+	if (use_template)
+		memcpy_nt_drain();
 	prep_compound_head(head, order);
 }
 
@@ -1238,10 +1257,26 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		if (pfns_per_compound == 1)
 			continue;
 
+		/*
+		 * When the template path is enabled, order the preceding head-page copy
+		 * before memmap_init_compound(), which immediately updates compound-head
+		 * metadata. If memcpy_nt() fell back to regular cached stores,
+		 * memcpy_nt_drain() may be a no-op.
+		 */
+		if (use_template)
+			memcpy_nt_drain();
+
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
 				     compound_nr_pages(pfn, altmap, pgmap),
 				     use_template);
 	}
+	/*
+	 * Ensure any prior template copies are ordered before returning.
+	 * On architectures where memcpy_nt() used regular cached stores,
+	 * memcpy_nt_drain() may be a no-op.
+	 */
+	if (use_template)
+		memcpy_nt_drain();
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
 
-- 
2.20.1

