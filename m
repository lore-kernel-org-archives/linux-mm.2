Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB1A1C87FC9
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 07:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FFDD6B008C; Sat,  2 Aug 2025 03:31:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076FA6B008A; Sat,  2 Aug 2025 03:31:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7E8F6B0092; Sat,  2 Aug 2025 03:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D520B6B008C
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 03:31:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92C8416095A
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:31:38 +0000 (UTC)
X-FDA: 83730997476.09.5DBF7AB
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5DB861C000D
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:31:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754119896; a=rsa-sha256;
	cv=none;
	b=WA3w96aKE55bHL/jtiB205wNspfOnsTeuSyK7+OToZGl97zHT7SsFmVjWybvxDg6SWOsYj
	t5BCoSUVPZSkBGIyXhzrNRjjVvX2DHRKVys1WDoBgmylkYf1y9d/rl681Zc6cOxjbpy13j
	t35BK2xF43nfh7KyaJazPogoMWhtuHQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754119896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JOigg7upYFcOPhFJMkcj2FtNgR6i3efU5qLAU0TjhQM=;
	b=y00VN+pUXDUIf4PszE60GnlB2gDILeUNt3SoSuxvaIRWVR6TCuaJL7Bdgj0i7OhS6WjX7+
	QZCGksghAHrk0WbGXzaS07akiFJ+o1Rc6NbKx6Wzhb4Iy/8XHCepqUwxkoqIqgZZIVct2n
	VN2vYsfY6YML3Xs6TmlsJRRi7NJHYTM=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bvDsy6rHdz2Cfrk;
	Sat,  2 Aug 2025 15:27:18 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 93B3414027A;
	Sat,  2 Aug 2025 15:31:33 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 2 Aug 2025 15:31:32 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@redhat.com>
CC: <linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 5/7] mm: hugetlb: remove struct hstate from init_new_hugetlb_folio()
Date: Sat, 2 Aug 2025 15:31:05 +0800
Message-ID: <20250802073107.2787975-6-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: 7tncj3h5o7ksktjgae17khb6fyr8i8fk
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DB861C000D
X-Rspamd-Server: rspam02
X-HE-Tag: 1754119895-587249
X-HE-Meta: U2FsdGVkX18729wJiAHVKt0k8o5mweBYNYiCs4q5Or6dOxhJbUb+fWnd/dyq6U8eAQCOpGCpGPIBwx8sJmN1mapDTtrnjmD8ctC4gLuo2HW4CiXObzDlMzV3XiVTvvierzw85g1Pm8xtIyatlSjmPnKykW8gKHAGp6bu560uDw2RNLrw/XKQWV+U992/E1kSpaSO7Ta3wq0JW0AUfvsj6aXA0x2SHXx2Vi9KTI3FFHMTupIyL4kMhXEHEUbGA9dvQ2sALNRRutCdbhNRbAkwkdbOFv65RnG3P+u0HIYj2TV9fhbzrKABdT7YNJGQ1mHMJ5kPAx30sO/pmH6CRYmbWgbixZG0US2n7OGQ+ppdoXhbSZYs0IdboGAc4ht2e+CtgvkCPVWXYRA8HYDJ3BzzPYC4n3n+V97dvrQSWbcwWtpC5+A32Sz6btRXcagrj4s/QwkJfIZ4Nu8ELbKpM7/j/dEi/j8H/wt8YndeI83r4t7HRDaQErHBe8+1rEQ25nNI6FCavb9FglS9KaF452h082EbDcIgS8NkQmDa0G0EdJA/3M9G7GWsaB2KksvjBvdp+cTC8Kk6e3iCQ9BDNlCDAvr9lc/ywq+gcGYOKnq8NW9NC+r/YxTpj1ujdnicwZ5br9pYFXYhw+MYButr1NfA2bN787GANB6KqyEOLs7i0rPNL7f49qqU3xGKNqPDsTuPnfGlNkM5MaGoFEhjWX+H2jBqhbIqnzjcY/479Less1KlulIEaXmVhuuSkZTLTnBWOddqNaJarfBriT5zrC62spy3ADnxncma92BU0tWNtQo+jxgSrlHml6QDlHdnKsKjYE1OcXy/36LrrMvwsE21y7J63IOaxg6R9gqhaZZmsiJHVq9gJCBMhTYiUPNTpJ9SDZnS+vA0e4nhGm4IMTX7l+I3SK/S9u0CsELPyjVw5eKOgZgstGfG0AmlRVIr+9Pd6ukkTBw9X7sgy5KPwh2
 cFc162eY
 SIC6h3pR9XL2/KT/mPLIwhSCAOh+WsdFcPSi8e4rUTAai/6T+eFSc/6Vv9bssVPpDpRI/Tl2dFDyTk4TjmR8l/Ond+S8aEBkpuaJVqnVid8TlPd54LBwETm4Lis6T2eGfzvHBao/MzCcu/S9j028zPdq+hsmLegyNVN9gXMJbTB2lRbbJMlGdx2M3T50xK1naltCSbSiOl/ui5u4XxFfcUQltIhy8RPTChlB4ZTDc2WfkGpdQIoMARpNr6TECmDoUG8TnpNC7zs8SeyKPLayxXyyWxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The struct hstate is never used, remove it.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e174a9269f52..b16011c9645d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1896,7 +1896,7 @@ static void prep_account_new_hugetlb_folio(struct hstate *h, struct folio *folio
 	h->nr_huge_pages_node[folio_nid(folio)]++;
 }
 
-static void init_new_hugetlb_folio(struct hstate *h, struct folio *folio)
+static void init_new_hugetlb_folio(struct folio *folio)
 {
 	__folio_set_hugetlb(folio);
 	INIT_LIST_HEAD(&folio->lru);
@@ -1982,7 +1982,7 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		folio = alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
 						  node_alloc_noretry);
 	if (folio)
-		init_new_hugetlb_folio(h, folio);
+		init_new_hugetlb_folio(folio);
 	return folio;
 }
 
@@ -3401,7 +3401,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 
 		hugetlb_folio_init_vmemmap(folio, h,
 					   HUGETLB_VMEMMAP_RESERVE_PAGES);
-		init_new_hugetlb_folio(h, folio);
+		init_new_hugetlb_folio(folio);
 
 		if (hugetlb_bootmem_page_prehvo(m))
 			/*
@@ -4013,7 +4013,7 @@ static long demote_free_hugetlb_folios(struct hstate *src, struct hstate *dst,
 			prep_compound_page(page, dst->order);
 
 			new_folio->mapping = NULL;
-			init_new_hugetlb_folio(dst, new_folio);
+			init_new_hugetlb_folio(new_folio);
 			/* Copy the CMA flag so that it is freed correctly */
 			if (cma)
 				folio_set_hugetlb_cma(new_folio);
-- 
2.27.0


