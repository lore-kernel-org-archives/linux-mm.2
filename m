Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36898C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 03:55:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8C726B008A; Sun, 19 Jul 2026 23:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63466B0095; Sun, 19 Jul 2026 23:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE346B008A; Sun, 19 Jul 2026 23:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85AB06B0095
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:55:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF6D01A0271
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:55:27 +0000 (UTC)
X-FDA: 85007790294.21.59F3087
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9C6AD80004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:55:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="tSyM/jk/";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784519726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BeDXJ1GH6u80+km2Mx/ZY9/6+inc9EkBSDAiip49A38=;
	b=Nn9HVim5LcI63yqamo2rFCpgs9Mn4pkZ4oUNaw/sjeU96zr3eLH67uXSo4W+q1q60jrKoj
	/kX+eLV9ykCTZELwQ89coWVAYTNGE1E9eUDERhxCn/zFKQ4A9LhiF3vb+joxaQIs8AgTal
	jYE2ml+RSqWlSEw/ZB8Fkgai73Wwp+E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="tSyM/jk/";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784519726;
	b=ldGWakNOJh/homjxLIkUCmWackEVFmy4RIccqCqo+IIS6g7goxvOQi2iCHA6K8WepyOfh+
	bQGe82QPh95TCW2WGPy3CqlhxZ74Ur1y+Eo02TPhb0YJgAa6F1H2ZbQxNeGbackHW0MMJD
	lShaV7P4LeZFtR90ZOHXzPPEJo4WAPs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=BeDXJ1GH6u80+km2Mx/ZY9/6+inc9EkBSDAiip49A38=;
	b=tSyM/jk/lOLlTHOcSgyBfEdncp3mh7QY9+QjM1ylC7ywQfjuqYHXBVEHdTvvaO3P93AsAOf7E
	BTFeabim1p3C6Ze6+b0dZ97a62cYRelNCOFvXl3nt3HK9hhwU3LZGVti/trKuNsCOAHdPBJSnij
	gNBnODcPdv84ZMS1YkDEP3Y=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4h3RJ42rRHzcZyH;
	Mon, 20 Jul 2026 11:45:56 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 11A9D40575;
	Mon, 20 Jul 2026 11:55:21 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 20 Jul
 2026 11:55:20 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <ziy@nvidia.com>, <david@kernel.org>,
	<luizcap@redhat.com>, <willy@infradead.org>, <linmiaohe@huawei.com>,
	<svetly.todorov@memverge.com>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<tujinjiang@huawei.com>
Subject: [PATCH v2 2/3] fs: stable_page_flags(): use folio_test_*() helpers
Date: Mon, 20 Jul 2026 11:30:20 +0800
Message-ID: <20260720033021.4091944-3-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260720033021.4091944-1-tujinjiang@huawei.com>
References: <20260720033021.4091944-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9C6AD80004
X-Stat-Signature: 9ptu55s8535u9tq8j1ra43spn5fi61d1
X-HE-Tag: 1784519725-928693
X-HE-Meta: U2FsdGVkX189mE+Ryq6CnnDVzQLVJ2njatvDF0psWOI+8+giPb+B8l3AlgG0Nenex3RuUkt2JB85Yg7nYQRb1cY9ldcBKrGvvoH0y0UajsyaOPZrpRv9AACD3D6Op5Ygd7reGacx8Sy+hUWAJDlQbBpoFCAslo6SToaNHydVhDEExXRXg+yxx2eDr4JNlmj6iZ6eowy0E1Ladn9n2p117S3+GxqQl2ZoAnyrUqHi6c17Cf+jhQrGl0ZkKPFCykORnVftsWVZh4+lNkH9UMkhsPEov3ztZP4Cwx4EltxhBk1blk0t3Ny3XJS6LkXdY3uJ4ZrHhjVetnRyj/DZJ0GmWMSzSbiTxiMllRGjsbiDaVrARLjM0oiAdxqn/Epo6VY16o8+XTrzrgv8RI/nZ9VfJDgNi7ulJmh07gqZV4EiwaL0etMQHyIwvGa8o6fT3+1K4gtctDzIMk6dHLPmXL0JAsa13RPmSnYgtH6Rbve1RCVWSx1wZt54pQXLfRosZwnbmC9VTFU88uS3Dz0pDlRyAz+xqY1Zx+g1l9RvJGDkENUTQZ8pIwhH0O/y1/HJStrtXML39M8YrKacx+0uTkRZhIEIyLhgCJkSKJYsD2idHMFvY/R4rHso1aGebf57hF+1ZyJJZo7gN3SwXFn8h5lsiHpnXsWIuH0BPdYQCw4cx6BG0Tvo/d/3h32KXMO/RxpDD3iLqgmNWmERWGn+/4xVxn9gLuYxeYkTRb1V04WuD5D1Lb50XjcqbwLc75MpoSfH/wEQIzn3n5nH3w2nJJFwnkeR8u+INuxHvHKRdBIFC1j82Y4mWtC4J/q7pomfhnPwn1I4JpMDnjsCedCewBBmo091Mu3uPCdHBkYgDyufCA4i2PjZJBVUILdwK1mU834Q+FvjH8AQw8Lp/wrRMRnTv+EmthxQK+s8Q4AoaWdI8bfTCRApt0LjkrcmYp4JULDPnmEEudBvWhqr1C7kx4V
 0+6kFNW2
 6ERN3bkdAIDKAGE93DpgymZYm1dxzEy8TXXSejbS+nLYD1c49xjp2bLzwceTRMKDEXlp4pmgSM6ZfayNjSBb9oIFAJA61rZUumvS5kCNqcuJdMaE3bq7FgomL/8X7eq5f+IhOtVaXNOK3vyDTnJChzZPLOIPFGnzNSFCFVYKMutZvn6dM6zYOUIpcBLVj8tXV/jtEDWK0gnhbnqs7jRHeIGwiDUcSEAitGZSLRybgRhia0iVRlG0eSx4Z0P6CZsMql2vBOLhVmRm7rQ/S0ZlHBTJh8/+wKE+M/GotUZ5EIiDQ4o1oQimSppWwlHO6U6wIyw99ZIiDIlfGetLMT4iu8dhQRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 304daa8132a9 ("maps4: add /proc/kpageflags interface"),
/proc/kpageflags directly operates on page->flags to determine page status.
Later, commit 177975495914 ("proc: export more page flags in
/proc/kpageflags") started using page helper functions when exposing new
flags, leading to a mix of both approaches.

For tail pages, the original code did not return corresponding status.
commit 0a71649cb724 ("/proc/kpageflags: return KPF_SLAB for slab tail
pages") and commit 832fc1de01ae ("/proc/kpageflags: return KPF_BUDDY for
"tail" buddy pages") made tail slab/buddy pages also return corresponding
status. Then commit dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
made all tail pages return the same status as their head page, except for
hwpoison and mapped flags. It also cached the folio's flags and operate on
the flags directly to avoid concurrency issues if using folio_test_*()
helpers.

Since commit 476d87d6a061 ("fs: stable_page_flags(): use snapshot_page()"),
we can now safely switch to folio_test_*() helpers instead of directly
operating on flags, which is more readable and consistent with the rest of
the kernel. Only convert cfolio-specific flags (i.e., anon, ksm, swapcache)
to folio_test_*() helpers, which reduces redundant code. Keep others
unchanged due to they aren't folio-specific flags or coverting them doesn't
cleanup.

No functional change is intended.

Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 fs/proc/page.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index ee39b321f1c6..b3c1d7a7604d 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -148,8 +148,6 @@ u64 stable_page_flags(const struct page *page)
 	const struct folio *folio;
 	struct page_snapshot ps;
 	unsigned long k;
-	unsigned long mapping;
-	bool is_anon;
 	u64 u = 0;
 
 	/*
@@ -161,19 +159,16 @@ u64 stable_page_flags(const struct page *page)
 
 	snapshot_page(&ps, page);
 	folio = &ps.folio_snapshot;
-
 	k = folio->flags.f;
-	mapping = (unsigned long)folio->mapping;
-	is_anon = mapping & FOLIO_MAPPING_ANON;
 
 	/*
 	 * pseudo flags for the well known (anonymous) memory mapped pages
 	 */
 	if (folio_mapped(folio))
 		u |= BIT_ULL(KPF_MMAP);
-	if (is_anon) {
+	if (folio_test_anon(folio)) {
 		u |= BIT_ULL(KPF_ANON);
-		if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
+		if (folio_test_ksm(folio))
 			u |= BIT_ULL(KPF_KSM);
 	}
 
@@ -225,11 +220,10 @@ u64 stable_page_flags(const struct page *page)
 	u |= kpf_copy_bit(k, KPF_ACTIVE,	PG_active);
 	u |= kpf_copy_bit(k, KPF_RECLAIM,	PG_reclaim);
 
-#define SWAPCACHE ((1 << PG_swapbacked) | (1 << PG_swapcache))
-	if ((k & SWAPCACHE) == SWAPCACHE)
+	if (folio_test_swapcache(folio))
 		u |= BIT_ULL(KPF_SWAPCACHE);
-	u |= kpf_copy_bit(k, KPF_SWAPBACKED,	PG_swapbacked);
 
+	u |= kpf_copy_bit(k, KPF_SWAPBACKED,	PG_swapbacked);
 	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
 	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
 
-- 
2.43.0


