Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 180F9CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D166180166; Tue, 28 Oct 2025 10:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9FF98013F; Tue, 28 Oct 2025 10:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8FCB80166; Tue, 28 Oct 2025 10:05:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 937F58013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:05:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54F8AC0483
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:05:18 +0000 (UTC)
X-FDA: 84047695116.18.6B7709F
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7AC52A000D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:05:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QZ08CyZX;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+4JuPe6Xrl/SYCmzewScvNRpN/5M/JdTL4WT8/nRkM=;
	b=8UHLmJBOkPMz+k42R9BTVMxYrKXqZQO4/xa5MPBvb2cuK3JzLFpm2FS410cBf0rgS25UMA
	cyR9hXd/B/zmnrAmVtTZEINxHVmIDjktlpXX8ZE2RJGrPbXrJSsQK/YLCseNlOLMEDfdhx
	tyWiWCHlVaAldTHOq0BEFEeDaOsIiBk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QZ08CyZX;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660316; a=rsa-sha256;
	cv=none;
	b=MTkqWA7OFGv+g+grVNhVTZzBSwQSKSSb9pV2ltdeVsu11u6JvGcIcFkZnD4YdyDn3D05kG
	JxUC0vByAUOfYL7BHW7J6i8FI92w1bcA6iFzuVAbGCa84ptpwmcsxfFj21aOv2TM9HG3Cy
	qQI3Z/PCSeDxhThJKmnUkn4GrlyevJ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y+4JuPe6Xrl/SYCmzewScvNRpN/5M/JdTL4WT8/nRkM=;
	b=QZ08CyZXMwfT4eFZs6LeoiXExg+Zb0ZEn7nn6b+Q3xbDLDOgxfqeGdLARk6QkvAIoaFDgy
	jdI3nKcmsJi02Hqo4qkI42o7inxB3rf196178kVRJxdYQwi/2sajqr6xsiNVgF234tsjYX
	CA0xYbgVOcQNCaafV2FFIVuOMfiUDfo=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 26/26] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance helpers
Date: Tue, 28 Oct 2025 21:58:39 +0800
Message-ID: <7c59a234362d080af554061941983588feffce01.1761658311.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7AC52A000D
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rbpcmwmqz4q3uxnbg1q8w46btpa1wayx
X-HE-Tag: 1761660316-917534
X-HE-Meta: U2FsdGVkX19aBaVQsMm9VsdIc9WmwzjOFrUb5n/ucXWTfjoVt3k7K6YcGU8bgz3VyiClcDfqoPXy6XxuxXRgNB5MOhUVLivyVcnxoQcuxuRiiFrKxLxAFbdUE0OIn2ogezQ9b1p1xx+qmyR4JDqvJMdyM/4vSBiMxhNv64gele4Qp2AdtDzVACtNLSjeYgvsjgUFPkHTgnL5G1M9AbAyo+9ZjYXbAPhzCGR0DzNYqnU43s4WSiwNAotd02cdsgxa2SJx9XLgReEcmYp2uHjLKLnlkiMW19Cb0lP1Ka5G2l/ek2CX5nNXtfTet7u/TbNWNeswChulLMhMGFK7UeFZYMuoDsplF1IgNM2Rk94nKyg/7k/yCrh2vaUAzF/l6QEN+Fj4ytKt6zZbkKZjZr8d3R8FzXp8IusJXxiWhwgLftWU7Ge2bE87bcJu/0LsGSgtv38+zrb2oqv+6NElFgup6hsrRmf/PPLGYZ/5j4KZpAGh0v7HCmpApJ/37Q+Klq8Zifha7hjWPOu8YBhbG9urXayd77ADtaLdQea9kG6eWTJZ7qFw7xQ8mzTIolWiqgGTVqU4acTzdXHWRDMO+VQb5hM0VOn/2SBLamPAIzBWvOpvE0M0E4k+CbOgnLGVihFvC1mP3Y5AQJunsZYuS+iUNjOUJQgFILbhShyNu8uyeyNR+kcnp7qWX31WfmI2swNJfrKOs72X0pzHIqOeuXxwqfgppaOM7IL4S1glmPp+OWPieQyMLj8NY4WLlD8O1fDQif0sEp7/Pelb+9JSrFmpGtCz16fUkG1gbfI2KaSga9r+cBN/BSI3IjoRdXYTu9tsnh3nVb3O4XrEROP3gtZdmdZ1ClePhEDd9GNbvlFDSTZjUuPrZykYPgDOpUyp8AkcmFkfDUrCPJgupABH1q4AsoRM2HaWlQvis0v3muEj2HFDLzdM/WnYZCOfJHyLSa8TJZE9a1sEbdwtig9e8Bj
 MlZeSIex
 gALvMU9FGTAkgO/vevOltxjcHgoiWliQAEH/IY4OBFcU/hDHUP9OhfftgCDMs91rkwErxUp4w0EDgWWLkU1avZxnLNYZEQLfDXhhPwqyYmYif6buv2HYF2LRZJp0Mhp8vhgR6gugn++oLm7AeDsB04pHEfoNRdR6kjoorjnZ2KfnJDGH3gI3qce1PEkmKMupMXHzrNqoHC+EB35TudJHkm5G7StWIvg7ZjIy0sktEYr2nc8FUIp12cjLnfeQnuDlkz+Yh1sVXWEpJn93GJvoA0vOyU9xA5vrrtwN8t4fvvKVJi90=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

We must ensure the folio is deleted from or added to the correct lruvec
list. So, add VM_WARN_ON_ONCE_FOLIO() to catch invalid users. The
VM_BUG_ON_PAGE() in move_pages_to_lru() can be removed as
add_page_to_lru_list() will perform the necessary check.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/mm_inline.h | 6 ++++++
 mm/vmscan.c               | 1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index f6a2b2d200162..dfed0523e0c43 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -342,6 +342,8 @@ void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_add_folio(lruvec, folio, false))
 		return;
 
@@ -356,6 +358,8 @@ void lruvec_add_folio_tail(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_add_folio(lruvec, folio, true))
 		return;
 
@@ -370,6 +374,8 @@ void lruvec_del_folio(struct lruvec *lruvec, struct folio *folio)
 {
 	enum lru_list lru = folio_lru_list(folio);
 
+	VM_WARN_ON_ONCE_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
+
 	if (lru_gen_del_folio(lruvec, folio, false))
 		return;
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 82c4cc6edbca5..5f22ec438c018 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1934,7 +1934,6 @@ static unsigned int move_folios_to_lru(struct list_head *list)
 			continue;
 		}
 
-		VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 		lruvec_add_folio(lruvec, folio);
 		nr_pages = folio_nr_pages(folio);
 		nr_moved += nr_pages;
-- 
2.20.1


