Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E791D78769
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 12:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B89946B0089; Fri, 19 Dec 2025 07:47:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33C76B0088; Fri, 19 Dec 2025 07:47:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37E16B008C; Fri, 19 Dec 2025 07:47:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85CEE6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:47:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28689140153
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:47:03 +0000 (UTC)
X-FDA: 84236195526.25.309653F
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5575F180012
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:47:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766148421; a=rsa-sha256;
	cv=none;
	b=rJP1684Kpr0MDMliWEwLAbJgHBqgSn6/tYP+Mkaj98/39hLz/lxOOCU2UY2IrzE5B3Tkuo
	E++TbGe1AkV7OB7TTlNsqZ0SelTekWgrm+WAvnFWFWMJhNUL0IR1nZ71RcJIb8EGQm+h0i
	5biDAwJAKdcxDI6cd2CyWdlcWMfK+/I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766148421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LvfTSSXGbFRbRmG2UcWCJDvxVSJKj0mkWqKgSoDnWMI=;
	b=1VKyLJbVs0T/5ImKWTYHube47Ai0HlcbcMKmV8oGHSHX2s2IQjolODGvuOu4lTQomMcpy5
	1Wj5bDoNpRQAgjOCXuSMFKWAScwK/t7C1wVdoLABMUrNHXO5OQfGuubE6rFaVH/X9u7BQH
	iMFchkLMaUzWQ/aTgTxs3AKzS4NYs9g=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dXnN35vVWzHnGh8;
	Fri, 19 Dec 2025 20:46:27 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id E969540571;
	Fri, 19 Dec 2025 20:46:56 +0800 (CST)
Received: from mscphis00972.huawei.com (10.123.68.107) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 19 Dec 2025 15:46:56 +0300
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
To: <patchwork@huawei.com>
CC: <guohanjun@huawei.com>, <wangkefeng.wang@huawei.com>,
	<weiyongjun1@huawei.com>, <yusongping@huawei.com>, <leijitang@huawei.com>,
	<artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<alexander.grubnikov@huawei.com>, <gorbunov.ivan@h-partners.com>,
	<akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<harry.yoo@oracle.com>, <willy@infradead.org>,
	<gladyshev.ilya1@h-partners.com>, <yuzhao@google.com>,
	<baolin.wang@linux.alibaba.com>, <muchun.song@linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH 1/2] mm: make ref_unless functions unless_zero only
Date: Fri, 19 Dec 2025 12:46:38 +0000
Message-ID: <d30cf64b3b48080d21a5d14b79d51a82e0f80e7e.1766145604.git.gladyshev.ilya1@h-partners.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
References: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.68.107]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5575F180012
X-Stat-Signature: x5uztu9bhe4jcu4yuy5rtk6r351spm36
X-Rspam-User: 
X-HE-Tag: 1766148420-660295
X-HE-Meta: U2FsdGVkX19ub2DsS5dcfoAwUkbzXZ1TWFSOQsNnCPCaKjGot4giM0Ai+WGTn2Y2jHA16AP5DkHFq8J23aSVOi3wgcdqJi4pHJ3DkztAIITAsYFaT7YQekU/9N2gHf5NELUoJQ2EdqZ6sFjzi7B8m0NGin9Sw63CR0cKKVBHGuFfA6tNXV9HlkiU1g/0t/skTgskp4z5GCKeYWqsVMmLlxqTCORtNHkPnC6UQLwhxepIYy29rGcfPMGmGkhzn8CN5+mlbQsQ6DEWhWEf4l1hg44gRQ4Z2jxUgf2PHIMI9rjRTgkdVrXikW9oqgdyrPZhWYQSCticyjbct/kwg9fTFUYyyCduFSRtE2LRTcly6sxntJE8aT1SNwDANhq2Gs2OwvwVMZHUq3v58eyvAHuwHDMC3hPKsp4ExqKmMHlOBzsP2VetxOnIx8oLnjuZeEZBpxzNTTtp2Z/KALKFeIHE3RIOdD2ACqXVEZHnWqe18WOODEkGzFgzpvpWtXA5POX7iUDDwZI347j2uYzPBOK/87I5cX3Lm2uZKMgtESuWfLEk3iczDNh6Sx4DsQNGD22snLg3XZ3NjOsmz6Qf3y3PPaWb8LSCKxQtaGulYknX6ijQbuB8kwBAUS0Dyw2Ud5RXvjKJjTd5N3EPllgtG+doblHsd3Az919W4j5aupaLA4HZ99rY7JDvUizRawn+dEzHXJkt8NmVTQ3kbQ69KQkvw5JkUs7QpC8ugQ4xNF0fidVoj5UaKbDjmZR3G/YDANQ4+S/TxTWtDQXQsyiKY5jMQgDi0zlIecNzAmN4ijNvvlKZyHPVAvvj1NlExANiIyms5IBes73pCLST1NOi1i2dFd4+NkzMDSSzBv4tfinlErbF3Q1/gHcY2+0JD3KQlr+hW8aX8u9YxHbj5xMzz0IZ0J7HHdvVe9uoPq8kAyeujEo/f/LtYIdIytDNgseDQ4WEzLXY2SzJFmI+12tAU7n
 PRbQPpKN
 ZZARE1402n9RK9HiVyq66uNehg5dGJ1vg5X9G7xz/bo1DrBG9MXPB9RggietqhIBtj0HV5scBOj7Ii+kfv7VnxJf9wLOjGCkwXiJ4JDA1lWpW6Q2+EJGh9LOGICyB3R8eQQYH0QN3XCVPVEZRI5idX6xOM2IGl4pG61DpMoXmrL1HsOKorq1F7BwCZ1QOhGFqHeBXJrZ7APVdOUJ2ZHqrvNTSeea2PcqHwLRXF9YTcdYQxz8Ne9dkxRJeQbvpeoYzao7N9IrHY6KStwijOgh2Bo7f80ofg18MMXSjMOUnGEOvPSD5GPHphyK/+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are no users of (folio/page)_ref_add_unless(page, nr, u) with
u != 0 [1] and all current users are "internal" for page refcounting API.
This allows us to safely drop this parameter and reduce function
semantics to the "unless zero" cases only, which will be optimized in
the following patch.

If needed, these functions for the u!=0 cases can be trivially
reintroduced later using the same atomic_add_unless operations as before.

[1]: The last user was dropped in v5.18 kernel, commit 27674ef6c73f
("mm: remove the extra ZONE_DEVICE struct page refcount"). There is no
trace of discussion as to why this cleanup wasn't done earlier.

Co-developed-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
---
 include/linux/mm.h         |  2 +-
 include/linux/page-flags.h |  6 +++---
 include/linux/page_ref.h   | 14 +++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7c79b3369b82..f652426cc218 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1115,7 +1115,7 @@ static inline int folio_put_testzero(struct folio *folio)
  */
 static inline bool get_page_unless_zero(struct page *page)
 {
-	return page_ref_add_unless(page, 1, 0);
+	return page_ref_add_unless_zero(page, 1);
 }
 
 static inline struct folio *folio_get_nontail_page(struct page *page)
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0091ad1986bf..7c2195baf4c1 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -231,7 +231,7 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
 	return page;
 }
 
-static __always_inline bool page_count_writable(const struct page *page, int u)
+static __always_inline bool page_count_writable(const struct page *page)
 {
 	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
 		return true;
@@ -257,7 +257,7 @@ static __always_inline bool page_count_writable(const struct page *page, int u)
 	 * The refcount check also prevents modification attempts to other (r/o)
 	 * tail pages that are not fake heads.
 	 */
-	if (atomic_read_acquire(&page->_refcount) == u)
+	if (!atomic_read_acquire(&page->_refcount))
 		return false;
 
 	return page_fixed_fake_head(page) == page;
@@ -268,7 +268,7 @@ static inline const struct page *page_fixed_fake_head(const struct page *page)
 	return page;
 }
 
-static inline bool page_count_writable(const struct page *page, int u)
+static inline bool page_count_writable(const struct page *page)
 {
 	return true;
 }
diff --git a/include/linux/page_ref.h b/include/linux/page_ref.h
index 544150d1d5fd..b0e3f4a4b4b8 100644
--- a/include/linux/page_ref.h
+++ b/include/linux/page_ref.h
@@ -228,14 +228,14 @@ static inline int folio_ref_dec_return(struct folio *folio)
 	return page_ref_dec_return(&folio->page);
 }
 
-static inline bool page_ref_add_unless(struct page *page, int nr, int u)
+static inline bool page_ref_add_unless_zero(struct page *page, int nr)
 {
 	bool ret = false;
 
 	rcu_read_lock();
 	/* avoid writing to the vmemmap area being remapped */
-	if (page_count_writable(page, u))
-		ret = atomic_add_unless(&page->_refcount, nr, u);
+	if (page_count_writable(page))
+		ret = atomic_add_unless(&page->_refcount, nr, 0);
 	rcu_read_unlock();
 
 	if (page_ref_tracepoint_active(page_ref_mod_unless))
@@ -243,9 +243,9 @@ static inline bool page_ref_add_unless(struct page *page, int nr, int u)
 	return ret;
 }
 
-static inline bool folio_ref_add_unless(struct folio *folio, int nr, int u)
+static inline bool folio_ref_add_unless_zero(struct folio *folio, int nr)
 {
-	return page_ref_add_unless(&folio->page, nr, u);
+	return page_ref_add_unless_zero(&folio->page, nr);
 }
 
 /**
@@ -261,12 +261,12 @@ static inline bool folio_ref_add_unless(struct folio *folio, int nr, int u)
  */
 static inline bool folio_try_get(struct folio *folio)
 {
-	return folio_ref_add_unless(folio, 1, 0);
+	return folio_ref_add_unless_zero(folio, 1);
 }
 
 static inline bool folio_ref_try_add(struct folio *folio, int count)
 {
-	return folio_ref_add_unless(folio, count, 0);
+	return folio_ref_add_unless_zero(folio, count);
 }
 
 static inline int page_ref_freeze(struct page *page, int count)
-- 
2.43.0


