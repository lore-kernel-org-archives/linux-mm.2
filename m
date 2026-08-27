Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 833BDC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 918D26B00A0; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851E66B00A2; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607706B009E; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 411726B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D31E6A0E61
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:42 +0000 (UTC)
X-FDA: 85147572804.06.07407A2
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7E87E12000C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ggXzahVa;
	spf=pass (imf29.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847881;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ubyjPs0XPl7ANEpl0YX14bjSE3xYgWesyhGRSLOi9nc=;
	b=OCYytiEwbQNHqmWz82uwu+CkrYMUiuc8lPGe+NvaGjC8FF6KKkrRhD2Crncr25vQGL8hN0
	umeVYPuE7Icu5z29XLs+QwghCNLVLwBeCE475JRihByBv6IBivpQbQd6CSgc0Me02bh+CK
	R7O4oYBDr/KtxfvnjbbaczuoDHAtF3A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847881;
	b=PHWo0MtKdJPhu4aNbdhJpjyF4ME/SNsOe0BTnyvKehjIRoYgVhfoZ8HQbccJIvHN8X8BBm
	N4f3kGWqamMnJlQ5DD2VlO127A012LxG/mCe4Cxycvo4LLjrsNPZk9Vu3hsOf9ipOElmIr
	8d3gWLSm94Hcd/ue9Ty8vD4H02XqREs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ggXzahVa;
	spf=pass (imf29.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ubyjPs0XPl7ANEpl0YX14bjSE3xYgWesyhGRSLOi9nc=;
	b=ggXzahVaaBfCtHNRVFOrt6bSpyceyYC+W328qh5SyVVXpU7ve6ADh6fJGtgRPWvJ1Ro+sDJKs
	grtkf31gGgNDbjaZXxwrccLWpDTBTV9bFUMtSs+XQZKgw7pfzz3bMSYuJ9U/ZgkMRlD0E1zNXPT
	VnMYHbLlgtfayKqSH8rHPFE=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KD6DMWzHnH3v;
	Fri, 28 Aug 2026 00:24:00 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id DB7054058E;
	Fri, 28 Aug 2026 00:24:36 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:36 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 06/18] mm: add support of memory protection for NUMA replicas
Date: Fri, 28 Aug 2026 00:11:46 +0800
Message-ID: <20260827161158.3618409-7-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
Reply-To: <artem.kuzin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7E87E12000C
X-Stat-Signature: nsbaeaj69seo6dxzd6943hxtuxxdm74r
X-HE-Tag: 1787847880-797995
X-HE-Meta: U2FsdGVkX1+FQ4xgJX7Go2wZQtcnYai6qtV1dMAB1RM3yqqcxWx9Tzawe32kdxft9KOy/S+mp3wbzg9FqFpt3J5b1PU7+xRVQ1u/y7sYFHFKjWNhH4xN2Jkq+oGsKYfl50kmspxpVcnKsgyVMuYLG1ClEFTAxOMn/DyfxsSb+J8qFJUUK5qekGHeY3/I+vogmIsHtlBmHISsI2y8cdsqgH7xU4l05W52128WT0AvKRdxdkNDjxX99RYQKBKlOfi+sFP+QvAOdr2Bddp+mWYeg07C2APk8AmKmUxC0QJKDkmXnkunndj9muxB6w9wlkAfgbrLLGAm/cxsh2r+ucKLa+aPKwc/ZNNkY1iz5Gv9CzbFsEZFfa9+Lv4V5RzbjeJOym/kAuHkido5yrjLvRT8dA/oNhSfq5XtiD21cnrhthbYi5JTNTGJsOiGMcHOPPWCeNmOJv/iDaeFlG7kGu8ZvTB0VBnF8t8f+TslgEaD56GRdVNs3OJsF3yaqo27mWSTTJkV5jFoaEglJstiQ5jyDuZ/q1hv+DfG4K7XFLKzUJ01EOwNQBGSlK1q5Qil8xxHuChCKHHOaKz/I/7GckoJ8FnTUvMd2vTveatR62wUujg99aOyP7wJy80mod3xM2U8t7MGM04Sx7NU6OflJLq+lLzhadpMbMnUREK8D98I6bNB/sfXFGMXedkvZrt051L2gQZv/dUZ+MI6fs1glkww2qpoYdPjugE1TqFqwZIW/ttz43A5dUVQ5LaZt/4ZsrzH868sZoW0FPpdc4h0pHVRv0JFWqn3HeM9uGxTuXrgXlVIFbQV0zkxiAnocMf0qL89IbcXTIyKbIak5VfFmQuXyfg4VzY3+e3sT95csHMsZot20HxToElR/imq/R8xxhfX988H3YjnPU12dphbHwy0UWpgmSR64sFD47bOD4d1shxNZuVBwC3ZnN7UrPLHmi7fBG1RQvYcA/Eovt5z7bG
 8a3Dvpwn
 G8q9Uj6T9V7TvBPxTjKbqZMEHw2yC67NMCBC5FjC8hrOWIR3PR8+MRqGfhIeGmE17PaLiCIrw0cmZ1KFLOmQVjqTfrqszI1QYBFrI2RZfdgFYkBcmpFF2I/tVVyFrtg58l0k2L4sli9Ft047FYt6HeeKrSuHya3/A39xH7xJ8tMvyoQWLnRE0/e3DRfc+gtz/+iMi3lAGHYYrgUIl+Iaa9EzoCkZh870oYaoW5l35ngsoETL0Fu67FdIJjxnaGY1KNAjyF+fo4ng97hm94PjMaXUTYbZ5xKia6am9s5D6tDAHAgPpLaUgznDvkhHIq5q4huZKU32KIO8Rl45gooRjLfTxuhDpsc5m5nruTJUVUkwAADp5VrTE1XjueqKTtgI3IVldkdzawTh2TStnBgjmPbZpNzNlZBnSjgrFMQ41wkAwEESAADgWdv6AQ65W41rzziGzkCK9DIsvqqjhPR994fDJsot4NBmJd1X+O3RFy6RFib2Z93MSCQae/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Artem Kuzin <artem.kuzin@huawei.com>
Acked-by: Alexander Grubnikov <alexander.grubnikov@huawei.com>
Acked-by: Ilya Hanov <ilya.hanov@huawei-partners.com>
Acked-by: Denis Darvish <darvish.denis@huawei.com>
Signed-off-by: Nikita Panov <panov.nikita@huawei.com>
---
 include/linux/set_memory.h | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..03fccacef037 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -7,11 +7,32 @@
 
 #ifdef CONFIG_ARCH_HAS_SET_MEMORY
 #include <asm/set_memory.h>
+
+#ifdef CONFIG_KERNEL_REPLICATION
+int numa_set_memory_ro(unsigned long addr, int numpages);
+int numa_set_memory_rw(unsigned long addr, int numpages);
+int numa_set_memory_x(unsigned long addr, int numpages);
+int numa_set_memory_nx(unsigned long addr, int numpages);
+#else
+
+#define numa_set_memory_ro set_memory_ro
+#define numa_set_memory_rw set_memory_rw
+#define numa_set_memory_x  set_memory_x
+#define numa_set_memory_nx set_memory_nx
+
+#endif /* CONFIG_KERNEL_REPLICATION */
+
 #else
 static inline int __must_check set_memory_ro(unsigned long addr, int numpages) { return 0; }
 static inline int __must_check set_memory_rw(unsigned long addr, int numpages) { return 0; }
 static inline int __must_check set_memory_x(unsigned long addr,  int numpages) { return 0; }
 static inline int __must_check set_memory_nx(unsigned long addr, int numpages) { return 0; }
+
+#define numa_set_memory_ro set_memory_ro
+#define numa_set_memory_rw set_memory_rw
+#define numa_set_memory_x  set_memory_x
+#define numa_set_memory_nx set_memory_nx
+
 #endif
 
 #ifndef set_memory_rox
@@ -24,6 +45,20 @@ static inline int set_memory_rox(unsigned long addr, int numpages)
 }
 #endif
 
+#ifndef numa_set_memory_rox
+#ifdef CONFIG_KERNEL_REPLICATION
+static inline int numa_set_memory_rox(unsigned long addr, int numpages)
+{
+	int ret = numa_set_memory_ro(addr, numpages);
+	if (ret)
+		return ret;
+	return numa_set_memory_x(addr, numpages);
+}
+#else
+#define numa_set_memory_rox set_memory_rox
+#endif
+#endif
+
 #ifndef CONFIG_ARCH_HAS_SET_DIRECT_MAP
 static inline int set_direct_map_invalid_noflush(struct page *page)
 {
-- 
2.34.1


