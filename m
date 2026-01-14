Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3B98D29FF0
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:36:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AD886B0095; Wed, 14 Jan 2026 06:36:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 392BF6B00A5; Wed, 14 Jan 2026 06:36:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29DC46B00A7; Wed, 14 Jan 2026 06:36:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 186616B0095
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:36:46 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D208C1404AE
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:36:45 +0000 (UTC)
X-FDA: 84330367170.21.BF92E0F
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4FF231C0004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:36:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BYiOKqSC;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cs9GVF7LIvQ9XqxorxYvjeDNqFvIg9IUXns1kdaiOGk=;
	b=VxGCplg2epUYclYWUKqIun2ggapSmQOWgDMII03BzFQjOyMG9pq3c8XDxviSLmm3FJbQgf
	ft2siZALgCzqs0isGCSMxbet+y+rNXYBZXzE8ucSwZ95pvmmMqrvTj7eHvAnDeZDZAx2tz
	HxWZtGxYmZnOzdgAyye93kf0ivJ3gpk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BYiOKqSC;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390604; a=rsa-sha256;
	cv=none;
	b=OR3L+pz/kZzqANzeDBYaCtehHVS4jU658pob5FLTLOZEnzwN5inyeMrErGXtqUEyMp4ero
	erN9A95Rl3w2IWFmSkfv2pOpxyZ+C3VQG7+UcxO6WOpmwYhclJjENRTCoojQPOiynhV7P3
	je+5GTBg+e9qCcvF3jiowfkFSpDvyrc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cs9GVF7LIvQ9XqxorxYvjeDNqFvIg9IUXns1kdaiOGk=;
	b=BYiOKqSCDSAyg1H55pIlV8GWS+W2vUkKXMGTEPXMRLHd59AdRVC7UHKdBOkHVj0waadkfD
	I7pwse5Im3PqcxJja4etRPmxO60fGbYA9zXJ6Nw0Cpn66iCq3No0LNMAp1azTCCas00j9S
	alQu2NJg/5YUInMj4TcfygSsqTffRdI=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 30/30] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance helpers
Date: Wed, 14 Jan 2026 19:32:57 +0800
Message-ID: <de04c58aca36fbf1f2b4f06d5b4c79a35a856a8d.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4FF231C0004
X-Stat-Signature: ojyc35gu9snhy1spomii8di94f9ysey7
X-HE-Tag: 1768390604-440278
X-HE-Meta: U2FsdGVkX1/rmo6KnUBAH1BjVQMg527l6vR1yvVvrpqFIbW7JpjgAA/F7lrbE2d8khGVzTRn6L1kotdcWxyWnrWVvdwuhNah8A1UXgUjUi23fKy3uwi26iShDTgFJMSiSDwqRlt7wzdEyLSR9qHPDPcApXVrl8sYG2ZFakkKLj1rHi4OZN07hXf+mceQemCQB8JHIg5ZN/XPmJ1qKDpsM6vTx688nsLgbys5MLQM1vAk8S+glXWkFhbY/Tf4f3EzXcUCV1K3BpjyLb1Mc04ZRJccIwG8Nje/6+/IJDRCyzsiBNJzW8qRQjYc124r99fMSpM3Y/t/Zxe7r93WJE25G2Kja6Z5/o5uefqcFO9+dW/6Ttec+FqP6IQ9iH+LKEiJ8woUHDVMA+lUE7kDZo3snOxdXRpIKGExvmNM1gtfotpf3oUoOTJeUzuyKGlg9R8xWf1U7C0mUTOQCUOUpCPkFLh8sTp6dpTm1Zz6omtkpTCUQ7PbZgeGZ3eePrxRM0CntnHtu23Qcz/WHlS1JKlBTnBMy0/+5dCLLh2BXA+KBswk6bE4uC6b+mib0VlZ2tsIqkN51PvJVhnu5A4xMqhXr+eXilb8j7HtJELmuo8kg/KK31gMP1SP7N7b/Et2/cA1tuSDrcVdZw/jxqupukRl1h1XfVjn2xH0BVc2+3jTxLWFPkvKDOdyVxQhgwrPk0EWgX/VKQhgAnoqF2bJW0u6tyjlqKPGDjsVbq+dtoWMHpENplffGYIQig+iImOR62+x3shSawiE3cQYtlQgqDx9HC1a8lXEdRE7Gurp3cYEVOGkUWWHLSi3niGVVEqA35AAAeD5+CkMEVP/10IMnVT3nTRxFQnBHpDLrlUpRNrlb1kNEvzxuJ8ac3B1tzFwuFlstb81HfMhRZ3/JkCVCIX6VA7R3pJZCfdF+uGBHoHOU5ZAf/EgFwCCjIJ70cI1YaP8CPFT6EIirJg=
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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/mm_inline.h | 6 ++++++
 mm/vmscan.c               | 1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index fa2d6ba811b53..ad50688d89dba 100644
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
index 6bc8047b7aec5..56714f3bc6f88 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1939,7 +1939,6 @@ static unsigned int move_folios_to_lru(struct list_head *list)
 			continue;
 		}
 
-		VM_BUG_ON_FOLIO(!folio_matches_lruvec(folio, lruvec), folio);
 		lruvec_add_folio(lruvec, folio);
 		nr_pages = folio_nr_pages(folio);
 		nr_moved += nr_pages;
-- 
2.20.1


