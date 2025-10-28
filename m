Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F455CCF9EE
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4846F8014F; Tue, 28 Oct 2025 10:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435178013F; Tue, 28 Oct 2025 10:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED268014F; Tue, 28 Oct 2025 10:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DB7F8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:02:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD9B0B87FB
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:02:24 +0000 (UTC)
X-FDA: 84047687808.12.4528499
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id F21B54001C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:02:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YrvJpFSm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjHMsvNc6Xx00FaU40JWEli8RMLF1vJXLo7+WwnW8IE=;
	b=DJw55q+6W3Ub5pqJSWsrc4xUxq6x0TO6pr+b04UpZOYZTIqY7hd11eiiuUx9ehOzVK9qDA
	Ti67483i7yxt93/NBHq+Q5OjkRHIbaJUWJQ+34pY986LXqjKHX6iwxEbsHAQwTTKzscm0P
	8mMX9+Oep3cBrCYMyigcrDb66NBv1YY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YrvJpFSm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660141; a=rsa-sha256;
	cv=none;
	b=yCM/PXi/BkyE2Zu0HhZ9yqBby4ef+MNN4UUGeII+Da6jinolkRkRR/3ZVolF0P4GH4+mP0
	qsbk1Kds8ULRPoFlwRflZVznn5uE/puo1LWIVUksU/7l6qp4lqbuQeaZ3qlU6JGN0k2xrd
	uWXWhiqql9Gpywz8WOvMyJa6Bsv5aGc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HjHMsvNc6Xx00FaU40JWEli8RMLF1vJXLo7+WwnW8IE=;
	b=YrvJpFSm06X23CK+cQFmSOcRfTt3cT97EdWGct98ZAmZZsodG45MMmxuPeK6f+vymiDmMa
	R3Bl8CbCbZywc5+NmbhK1NFu3mg+nXz5b9feFPfwMUUHOAUs7vlqExUk/gZ0d38ndEwYRT
	WijBbtVbYAfPAgyXV/Eq5gyaov1eihg=
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
Subject: [PATCH v1 02/26] mm: workingset: use folio_lruvec() in workingset_refault()
Date: Tue, 28 Oct 2025 21:58:15 +0800
Message-ID: <02536beaa78aeaafcaec40d4fca42ccbbd9f8643.1761658310.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: F21B54001C
X-Rspamd-Server: rspam03
X-Stat-Signature: oaqxbguptu5jcnxzeoijzanmg3b5y84d
X-HE-Tag: 1761660136-229573
X-HE-Meta: U2FsdGVkX1+VbYfQjIHjH4O4hOMU00VUUNVs2+Nmo9xli4XpOpofvCVnBwGFAMw0Qocv5TwSov8D0Z+aczRJx8JTnNL05dfnEhHIWbvxnJBkVG6klvH4dZMXcb1B9Pn7CkuUIA+5RhXonyhZ/RQ583wvc9No6H5NDC2uBNWchKK03fiY37LEhxEf+zN/CJak9aIHbWJl+MgVx822xn4o2f1A7g2RD8NGuQuNLDxoO7BzXNJietn3COeL+OInMeD48/awliHZQkpR+im+PRjtpqjPRFpyJlYYvqVJtVF+BFWqU/ZKhddcQGqlDbaAVMlItbGvuxML3A6GIl58NHB01RQQdfLIkD7aTMb0q5nE2v9rVsXdrT/RUCDgzcMsAIl6frtMUudAaUfJGqg/HRu9THRXnyDwTjgrV9K7VjQHlUk9m9P2OIUFxg1tq61Ha8bD3B0fDo6varU7iyV9c5H1LN9oBVut5UixMQm1tNIl5qNL/ATmXncfzVyAnA3a8Mai8eY8ge+5AkyJ9sbCNEPyk1Qh9S77Slh2lvwU+bWehU/MiAMJ4QoSoiB6ITguKP3344/5rb+BGMqoWnZ8yqtSJ2FtvuNcMYl4b8d4xFyETO9obavUtueH0rp6AwROe5k7tfnoSHppBEe8xltDHkKlMK1okRGbsZ+/cESmdOM/iCt44K5oosCIATrLHr0bsksnIoOsSKQXTxSjeVhgeBKkqRbJqt6lIY10FXH30S75jvdJ9Grqkfh1MqkwckVmTEQTWxKNfHuLrsyMRp+ZKDR4mpKz2XXp6GwLe0xKheav2oQmfVcdiqibqnxZofxl7qHIsToo5W1OEutok2gL32JPeJ8NVneDrYKI5z9ogDllFYnF2J5PQ550to2lNwxB057mapbO10/TUPgFqJle3dERO9Ksm1z7+qhIOdpJzzp5qtaEYwS6xk+jcXgLRZee5UGwjXE/na6VXxPNut3za9m
 ns8G0/6P
 7fruveNuRgPjk5/Lgm/86sKrMJTOVyekObpP0uxzfY4ve17TalC7UIgbm7msXgsgB6U/PTxq0Kogzs29Bq6QSZx+3m8sP0kSGg6B1oh84i9KUDp6vxLGKNQndmOGVN4EEAT1dKd/9sElnWMceP0QRNwPu9TFoHtiWLHK7zDAxEbPKeQ65KcaYeEA1JJpzwsZJst9MFkcKGUJQm0MhiHYHpipxxyJlqNI15W70TZiamJ4uwqtrVwHXIkCpMk2tbIfnqhHeVCdezswPXmD+8d0JcZODSYyif7w8/uk6XsllNW4Y2Y0SoAVn2r5sQZKLdBFO5Tm25luk3KqctsA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

Use folio_lruvec() to simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/workingset.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 68a76a91111f4..8cad8ee6dec6a 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -534,8 +534,6 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 void workingset_refault(struct folio *folio, void *shadow)
 {
 	bool file = folio_is_file_lru(folio);
-	struct pglist_data *pgdat;
-	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
 	bool workingset;
 	long nr;
@@ -557,10 +555,7 @@ void workingset_refault(struct folio *folio, void *shadow)
 	 * locked to guarantee folio_memcg() stability throughout.
 	 */
 	nr = folio_nr_pages(folio);
-	memcg = folio_memcg(folio);
-	pgdat = folio_pgdat(folio);
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-
+	lruvec = folio_lruvec(folio);
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
 	if (!workingset_test_recent(shadow, file, &workingset, true))
-- 
2.20.1


