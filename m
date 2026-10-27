Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7E9F606A323
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 04:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Nz8aei22
Received: by kanga.kvack.org (Postfix)
	id 703C36B05B7; Tue, 27 Oct 2026 00:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 664876B05B8; Tue, 27 Oct 2026 00:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553486B05B9; Tue, 27 Oct 2026 00:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BD2A6B05B7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:22:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A870340928
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:22:31 +0000 (UTC)
X-FDA: 85367109702.13.9DE9207
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id E119D40003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:22:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Nz8aei22;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793074949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+qp0OXlPFpX5xiEJlY0VrKPIDA5cshKQIUi1chin/AM=;
	b=uEpz6eUmy397kVG3ASWkeLKUMdL/GB1xsrQr/VdCb9I9N7yURZ+sKsXzJngtudJ23Ql6r5
	FlfBzHfhKeCcxJO9a+VIxHO8dJbOiIwSDgeI3JVY3RHyuxExHFVuuEYkq3xAdzEFjaHJrN
	yfW3Ru0e93Afe8JgnCHjnjVDnFLuUtQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Nz8aei22;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793074949;
	b=yKwauW8Urvu67f1DKgHxaSlvyCIoTIRbF3fJFRRW0/mPz+XJLHxebZFxIkwmCw88BTg15E
	oYAVIwfBy8GUZUXdI4fe9MoTq/b47qMAquXNyEfSiF1cRojsspdUTZWWsUI6h1i0jUOs1g
	b7BYBv7WgetJsToaCvGEPeAj8cx9KgU=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-530e75d1ba1so31969921cf.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793074949; x=1793679749; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+qp0OXlPFpX5xiEJlY0VrKPIDA5cshKQIUi1chin/AM=;
        b=Nz8aei22auaUVkuWtljA3UkBdEPRv9dbuwySABkVdSJTQWKk93lUfErA/D5mdmSKLh
         rzbJb5IsXGQ/PbiS34/knV57rl6wuBxSkXKk7vtekHN3nhGRs20a0W+iV5hEDQDdQl0y
         ipTZGryhdDBnGp6cb+eN8aI1TbblHSjoJPfLToTio6lev8FWxNbmbMnzHbvFNoKCQMqb
         ZJRPKcJlbdY/kA1U1BYabpr8C/6tBe3+jxMcDbJM421068Ii5EIHHXT8+CVoJxNF9Oip
         0wqt5AMXikxEWxZ4K0y7L6g8vhpn2kdl2+iIbTr28PxQsUnw3dYcD/UNocydyyGGA1tO
         HiTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793074949; x=1793679749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+qp0OXlPFpX5xiEJlY0VrKPIDA5cshKQIUi1chin/AM=;
        b=Y/mmyR+TbBWmMHsonPNDAm7G9616HBRRdf0MWIAO5Sl7h4isjLS5z5lE2yRRREdTG1
         G9vS6eaGP+2bMCEJt4bRHMo6HKUbkXbRbiVAcM41xmR61wLcQYpH1IXx+jiZyE9c7PAS
         rN7Q2a3h5eKDAvUUwk3FIZ96VU4ZF8ncLTY3zlpYgodNR38lGDElUpNhS09+USNVUpxi
         JonE6QKAvFv6kdtMdRfao4J+D8M8M4Zms3wroa41+jBED8Enghagiy0ajXVelNHNq6GX
         0zTEK19Ix28zqdlqgtmUk1BcnfeBPEB9dWfwDVmEYxfx09lutliEX+CaUw1b3YIEU9S/
         jaJw==
X-Gm-Message-State: AFq9FYLnKBc25Ji4ucKcPqBA4M9Zjil5TOKCfOhpYZzHZHk6a/WYurwq
	KaJpwWoalVuK1QfOrVneUZH7JM0/ZQTbpFpe4cwibY5fV7DeY0twx5CnjQULuPmQJq/FFqCpqgA
	nStKa1OE=
X-Gm-Gg: AYBFou2klKlET/HWZ5J5LWqfnoSiSQ1uV4TmTOOlEx4pqj+vim3pZv8X/rq0Pl+s7gc
	rpunCL3sQjPgOrvCp1t1HGZXPNb2GWUF0W1hflvUSB46hn2+FMuzWSH6sd22Wsm+zhENcXI/QEZ
	LeckQ4jsdRgItRh759/tCfg4/boHj7E5f9TbAXH7QHJXFDqMu2LCc1zHOdThNQoavQmWPxO3f78
	T2y3p1ESyK/JLICJJQJ6L41Lj6tYvP05pxtzZGn2ehzPj64qa7AgNFRJHj/UHgY4OJjKhc1Qrfy
	9p5exc8GGXcGRonOvseDReFhQq47UxMGV4iFvso3s6UOovekJFOrcIKPF9sI1GNZg+mqRxdTfcw
	9nRCJ16Gv6Y+uBakLv/KH0LRI/Wc3zolHk06UkK19ySRStlMdf/UlGE89IlBn/eN5nUgUENXPG9
	3l3VJj6ujiLksj1kZCtBzB/OtsTSDJkzF8y7XnBiADtmY5sZOmt9lA3Un9MXXoocdY/tcEvb9NW
	pB4w5ghmfvCIlB7zvh36TrmDj+BRHj54VsqgNXP63dNyd9UpOf5zuuS8UTGP4Q2V8h7+cSmS73D
	LceXDa3ruhKjLDi15Go9MsGKcPDc95NZxXRandfAuQ==
X-Received: by 2002:a05:622a:a6cb:b0:536:66ec:1b06 with SMTP id d75a77b69052e-53ae5466c89mr89523631cf.50.1793074949087;
        Mon, 26 Oct 2026 21:22:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47bd01cdsm91139676d6.7.2026.10.26.21.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 21:22:27 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	osalvador@suse.de,
	muchun.song@linux.dev,
	iamjoonsoo.kim@lge.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH 6/6] mm/hwpoison-inject: keep the page online while filtering it
Date: Tue, 27 Oct 2026 00:22:04 -0400
Message-ID: <20261027042204.3741307-7-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027042204.3741307-1-gourry@gourry.net>
References: <20261027042204.3741307-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E119D40003
X-Stat-Signature: epc6ughd89x5u4ui946ogoxqshxode5f
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793074949-130936
X-HE-Meta: U2FsdGVkX19ytsq+/HCjgGNek7pjjaAySd8PcbjhAdjm2iH8/EIXRe/MaUzCkSWMiSmGJe/xxB/Zb2bKOJB3zoW0Pflpmh5PUPwRxj7pwWxWvu9bTcLmXhV0WmFhgyYgcI1Ne3IqQ2Ja0tUMojZM+bp/SMvPf/BbUfTHFuOCRFcvmPZclpUJaWXur9u91oMlyR2f/CSiCSNz6rPrTZpPF4VG+HMDpwmFKx8P3yRRvFDzzZkCLoN7fwgnmw2uEEQ7Bg+H7zpqmMJemF58eRs/1n0fP8fDJF1P88tpoUkKAW7o9J6r2sUQNrNFpoeHYml8N2yLZOpG1OMWh0vOoiQ2Vz+RaD8YioRKF4hSyDgu/SoovdrnL8yvtKPfwxspnxfYifoYYtDAKxAwhFbTu2np6ftsPN51zYR7tYeNibmhrMk5u/lFZgVyUnhuyiwJK52AV7TvU52uEdJ6iI9t47qOFLot3SA10lhmziD02qcahLN7rhyRZaQZnJnDD6v5sY7vs7C8P+XGtaTJGnufwXQDYg11tdzrE2Vs5bH2azapmeAr109nb2yZFOC60rz9eTsrvumco9sAqQAXZ9z4GqAv0FZs/jjPWLVw7j5RTDpwK58PT1i3SLm7eyO1Y/f1cfTVy2rHZyeSsOLub3nP8a3eko85khGfZxqKS96yHk4vmrtM1+ioZ41ZsEFpkPQSJi7kqwA2E+QRKv/+MYH+917TZFNcX+p/iKrcwxK6VDUdLLsZK94Wu0deIoPPYGEwZlIls1g14EQ1SUH/35JxyUgNstfckR7JBkLZUUnXo9hQF8Tk5r44RpVpCeNxlCHs+BjsHqCLo5r+zfQRM6qan7PrVtA8xvoJUjYsE0fgR6gYRj77/bNGACmORVM/ZVsTaNJysLaovJwVc/n/fPVbFHodc8sn6VgvQD/FiRZ5CLQCEgEYL787etf16huoHa0VVgX74z+8m3cw66IORKOndc0
 SkrvGIsr
 oMKh2C3AsE89oTAZc3vOmurUzrYNOVcaz/LG68vyq2nQL2QhsbrvXW1mltcsP3cef6SbVznN0/5Rjp5v7//RmuUiTcUw2yUeasycZ3tydJWZSEf1P46fKlRNuN5Jz1gtX5A3FO5oSsxtKatI5z+QPZUJZOXFkxjyqgcyT7s/U1EIH/LhDboxooS0DUCZQ9QowHdaUsa1NYPtMD2gs0zU+B42NjFoADs3J2dfi/YFEIHNTRAgV75yEZzTctKOM2KP4o29vQF86SuNAwbKr7LIm6RYpZuiRkFpAk/mc/zlqEhAz0kSM8i6fo8tpwX1SglRaq+rR9ERWpdfgzAGeA/Kp2LIpHdUI5axQucR7DxcOTl2Wa84OIofknqj2dQhcp6sM+o2mADIeUChCYMOAeo4lEaHPxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Injecting a memory error with the filter enabled while the memory is
hot-removed can crash.  hwpoison_inject() checks the pfn with
pfn_valid(), then runs shake_folio() and the filter on its page, which
can sleep in lru_add_drain_all():

  CPU 1 (hwpoison_inject)             CPU 2 (ACPI eject)
  pfn_valid()
  folio = page_folio(pfn_to_page())
                                      offline_pages()
                                      arch_remove_memory()
                                        vmemmap freed
  shake_folio(folio)
    reads folio->flags

  BUG: unable to handle page fault for address: ffd4000006040033
  #PF: error_code(0x0000) - not-present page
  RIP: 0010:shake_folio+0x2a/0x50
   hwpoison_inject+0x232/0x4b0 [hwpoison_inject]
   simple_attr_write_xsigned.constprop.0.isra.0+0x179/0x220
   debugfs_attr_write+0x63/0x90

Until the filter stopped pinning the page, that reference held off
offline.

Hold get_online_mems() around the filter, check the pfn with
pfn_to_online_page() under it, and drop the hold before
memory_failure(), which takes it again.  Offline and ZONE_DEVICE pages
never passed the filter anyway.  Export get/put_online_mems() to the
module.

With the injector held at shake_folio() on a free DIMM page across an
eject, base faults in 3 of 3 runs.  With this patch the eject waits, and
the injection then fails with -ENXIO, in 3 of 3.

Fixes: fd476720c9ba ("mm,hwpoison-inject: don't pin for hwpoison_filter")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/hwpoison-inject.c | 55 +++++++++++++++++++++++++++++---------------
 mm/memory_hotplug.c  |  2 ++
 2 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
index a11222572f978..f6cc967b3a468 100644
--- a/mm/hwpoison-inject.c
+++ b/mm/hwpoison-inject.c
@@ -9,6 +9,7 @@
 #include <linux/hugetlb.h>
 #include <linux/page-flags.h>
 #include <linux/memcontrol.h>
+#include <linux/memory_hotplug.h>
 #include "internal.h"
 
 static u32 hwpoison_filter_enable;
@@ -99,43 +100,61 @@ static int hwpoison_filter(struct page *p)
 
 static struct dentry *hwpoison_dir;
 
-static int hwpoison_inject(void *data, u64 val)
+/* Returns true if the filter rejects the page at @pfn */
+static bool hwpoison_inject_filtered(unsigned long pfn)
 {
-	unsigned long pfn = val;
 	struct page *p;
 	struct folio *folio;
-	int err;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	if (!pfn_valid(pfn))
-		return -ENXIO;
 
-	p = pfn_to_page(pfn);
+	/*
+	 * Offline and ZONE_DEVICE pages are not LRU, hugetlb or free buddy
+	 * pages, so the checks below never let them through.
+	 */
+	p = pfn_to_online_page(pfn);
+	if (!p)
+		return true;
 	folio = page_folio(p);
 
-	if (!hwpoison_filter_enable)
-		goto inject;
-
 	shake_folio(folio);
 	/*
 	 * This implies unable to support non-LRU pages except free page.
 	 */
 	if (!folio_test_lru(folio) && !folio_test_hugetlb(folio) &&
 	    !is_free_buddy_page(p))
-		return 0;
+		return true;
 
 	/*
 	 * do a racy check to make sure PG_hwpoison will only be set for
 	 * the targeted owner (or on a free page).
 	 * memory_failure() will redo the check reliably inside page lock.
 	 */
-	err = hwpoison_filter(&folio->page);
-	if (err)
-		return 0;
+	return hwpoison_filter(&folio->page);
+}
+
+static int hwpoison_inject(void *data, u64 val)
+{
+	unsigned long pfn = val;
+	bool filtered;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!pfn_valid(pfn))
+		return -ENXIO;
+
+	if (hwpoison_filter_enable) {
+		/*
+		 * Keep the page online while the filter looks at it.
+		 * memory_failure() takes this again, so drop it first.
+		 */
+		get_online_mems();
+		filtered = hwpoison_inject_filtered(pfn);
+		put_online_mems();
+		if (filtered)
+			return 0;
+	}
 
-inject:
 	pr_info("Injecting memory failure at pfn %#lx\n", pfn);
 	err = memory_failure(pfn, MF_SW_SIMULATED);
 	return (err == -EOPNOTSUPP) ? 0 : err;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index b5d9e367b893d..fe2ed0894d49d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -215,11 +215,13 @@ void get_online_mems(void)
 {
 	percpu_down_read(&mem_hotplug_lock);
 }
+EXPORT_SYMBOL_FOR_MODULES(get_online_mems, "hwpoison-inject");
 
 void put_online_mems(void)
 {
 	percpu_up_read(&mem_hotplug_lock);
 }
+EXPORT_SYMBOL_FOR_MODULES(put_online_mems, "hwpoison-inject");
 
 bool movable_node_enabled = false;
 
-- 
2.53.0-Meta


