Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 939A6C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 23:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8C046B009B; Tue,  1 Sep 2026 19:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3CE96B009D; Tue,  1 Sep 2026 19:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97A656B009E; Tue,  1 Sep 2026 19:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6CA876B009B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:24:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B7292120554
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:24:51 +0000 (UTC)
X-FDA: 85166775582.19.8DE5DEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 275AF40004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:24:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ibSekCGB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788305090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dD8NdLX7k458iQXtwaaXdMdVjxLHPxreylsAIMI2VEQ=;
	b=ebjZp13EgCMBZeoFwfbAujAsi1lstVKn12Fn3bmiQQ50/MvEujEhTJIQe+9ydZCCaWnPeG
	SIUN5wV++X6PM265tMxU9cj37999lSOcfZec3gqtwZXbxyrdLkCBMweV+PessZSjBdGTRM
	ydc7OUFLOhkMmuEbUdiPzp8wT/jjd3o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788305090;
	b=zeoal7PbIRW/fwpt200lh/2DTI811QCETUT/w84oQrt0SnuA+AyBsQ/fy2/3pXf5eiYXxw
	HDBtxBSuD35Hkmbo0y5N8egcR8myt2h6epJexlt17WBkpQyJkfQRzXZiFbUyvS8aW8Rkk4
	3rUFkLk2iBr4++MIbsRTiWWdKspayR0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ibSekCGB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78B26436DF;
	Tue,  1 Sep 2026 23:24:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F941F000E9;
	Tue,  1 Sep 2026 23:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788305089;
	bh=dD8NdLX7k458iQXtwaaXdMdVjxLHPxreylsAIMI2VEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibSekCGBXiuyZPZB+TrUcrTvmAVz4J6blUZQSkuuhDcLDR9ixnqf+520nUiUdNc6T
	 /cpaWjlXga/eXeMvWhdiJdjIq5EufHp0OkMW012RFkqkkeR+Lr7Z+U8P3LKYiPRRyR
	 dOBRbhWd8KtLI007ns+Kd4ST8tbyD0yo/O5kzHGxZGFpRpOga/W8TMY/QblqcaC8Ny
	 mchLUVU7GQlymWA6adU+ZBXG1OEHfMZU6ex7wEs3LpwhePv5+aAmVavwglaYKnv+d2
	 HAf4VC18aG9u8u4oldXleMhgNffeppkJBDl3iii0bdGyOBwLfUkW25gCsqXguV4Y3l
	 Ar+vE10FgAfpg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v3 5/7] mm/mglru: make LRU folio prefetch helper an inline function
Date: Wed,  2 Sep 2026 07:24:19 +0800
Message-Id: <20260901232421.40157-6-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260901232421.40157-1-baohua@kernel.org>
References: <20260901232421.40157-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 275AF40004
X-Stat-Signature: 8bztc1eoynwguda9gac6e3ctaxqyzktp
X-Rspam-User: 
X-HE-Tag: 1788305089-478261
X-HE-Meta: U2FsdGVkX187P8Ax4NChFMcMZvyCzfUXzvOdhLeSrmYx5nr7Tg8EIJ9G4605g0XAfMuamVbL2M3mkOaQdvv+GWbVIt4LNjhHxOrM593sYIulgxBFF1qwg5p+YcSs90p3npwrbtjrRftd5wTprLEugYhxzRW9X7DFVjdPnf0TtnkJOiF7Tb99P49KhHqhU9ie9By18wXod0dVFQsERmaRka6KD7Kg0DTIXbg+d8DRB9f1OAcyPMgAL2DnwTQZgIWqYHO+yTmZgDwpiKcRHGBj63eqL/lvUPZMDriFBWpr7Ea74fjTwaDssogUIfjZEBHGq48BxGkG7AflMnZTABz9nvUZ+MdqU69HPTzONqdAt6VylxLFKfLw2lo04ZBP1FbQrGVIRjZT10IiRz/sEUoN5eSwOi0uvObnjrW3lLESwlaA42m+CWI0q9EqYy7Ee0mqLTUlnUG7rqOhNRaBdkhifzYFl+PEZhuCFFpODqQrFFYCHpkLHZ+tffHVttyTqvDerpWHjNggt7Z64FBGOhJX+RxupgU9uTkPh7V+22wqUJ25n5riwaViL2gHtYZVhuuCmSEhub8/phLsQbSGPV7PVufBPlZTSa54XlaCKs8NuflFHZ9R8jEMsg8BRlDNs9Rj8Bsz7j1eTWz4KTGhUz6OvMybiO8qOj3jsCHTAKx58bM4T//NV7pawqsaTAqurBXfw9wm7UbxrR88EyY6xGhCbxaVDcTcDrfggK7LnH9mzp6KzYCikxT+QP+9dD5HUxwSbGVP+gK2nZLRvnpnc69N5oTCorF5jykjbn3wHSA/bCGcIKapuhtOvKGU07yg6ILF+Y14bBITxQSe7R3IvKXYMJkNmkhQ/bc5tYMjVdT0iRJiqObQhEziGG7Mz/S1HEcVsC023tTrsg6S7L1M+7h4eIDTrPFVk9uEFvZvfoq/2oj1tLWLOoQDrsdaDa3uAYZJjZFOHb303yEtX9JZJaR
 JWnUIAK3
 xas44c0VqmF94pVXxpN2hJuAzCZAQNE2uAbgBKMGeMVduXk3J3uF7wRSPxBexs+hFHILdNkTLmBAzrbiKuU1jhuoEPy8QZ/BKjFwkyxgtPfjAyGXYQbKPdXGjnbZhKIKhB4SfVOW6iAqcuqkSpCrMgMgqk6F6Hmuqqujg9L6+/uBf/fKsNYJbqctYEnVUnUx6Sbq8d3RHK3dXT1ll3+G2qwT3Vtrw1LDJJIv0OGqTaGgyFvcmYYkM+Fgw8Df8yXuo+5y24PTGxJ8BsUNyIivPeVupM0MAIZEGn0iK3zRolufXofq5anIaIxgQvq95rKuUl3o0zmJT9MAsPhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

`prefetchw_prev_lru_folio()` is currently implemented as a macro with a
potentially unused argument. This makes the helper harder to read and can
also trigger checkpatch warnings about unused macro arguments.

Make it a `static inline` function and remove the unnecessary `_field`
argument. The helper always prefetches the previous folio's `flags`, so
there is no need to make the field configurable.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/vmscan.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ca57f6095b37..1907a946840d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -182,17 +182,21 @@ struct scan_control {
 };
 
 #ifdef ARCH_HAS_PREFETCHW
-#define prefetchw_prev_lru_folio(_folio, _base, _field)			\
-	do {								\
-		if ((_folio)->lru.prev != _base) {			\
-			struct folio *prev;				\
-									\
-			prev = lru_to_folio(&(_folio->lru));		\
-			prefetchw(&prev->_field);			\
-		}							\
-	} while (0)
+static inline void prefetchw_prev_lru_folio(struct folio *folio,
+		struct list_head *base)
+{
+	if (folio->lru.prev != base) {
+		struct folio *prev;
+
+		prev = lru_to_folio(&folio->lru);
+		prefetchw(&prev->flags);
+	}
+}
 #else
-#define prefetchw_prev_lru_folio(_folio, _base, _field) do { } while (0)
+static inline void prefetchw_prev_lru_folio(struct folio *folio,
+		struct list_head *base)
+{
+}
 #endif
 
 /*
@@ -1695,7 +1699,7 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
 		struct folio *folio;
 
 		folio = lru_to_folio(src);
-		prefetchw_prev_lru_folio(folio, src, flags);
+		prefetchw_prev_lru_folio(folio, src);
 
 		nr_pages = folio_nr_pages(folio);
 		total_scan += nr_pages;
-- 
2.34.1


