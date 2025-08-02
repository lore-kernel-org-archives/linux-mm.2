Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88DB2C87FD3
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 07:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF5AD6B0089; Sat,  2 Aug 2025 03:31:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D949A6B008A; Sat,  2 Aug 2025 03:31:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35216B008C; Sat,  2 Aug 2025 03:31:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A923B6B008A
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 03:31:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A388BC181
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:31:37 +0000 (UTC)
X-FDA: 83730997434.13.B4A576A
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3EDE8100003
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:31:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754119895; a=rsa-sha256;
	cv=none;
	b=cYNrNvddghzqwRo+JNqMuyNq1eGJ4JsQkijgwjbwFtLRp1zk+9ag9Pp/lIUi3KYqLEJ4w9
	TMn+Q4ae092U+fhavWYfHD730Rvap4JBQ/ULMRkJXauicqq1A3AmlSBgmdiw4QIHg7kSgx
	ivCjMD6CmGR38XkBmjcTDsM9GgYgHYQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754119895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QvKT6jCH4RoQl740YTYdqagrXbBpl9GPZaNYvXOzFC0=;
	b=BoXKZ4zzDHNkuAENf3WreyE4reitdcMfSx+6iMLjJxguob3LTb5y5ax8ffQR1tDW0UuvZ0
	ZtbqgI5Gnw3/1MPuUX4/ko/O7OjURT0CGO7tJEgzd8vYKr4d8zbwq2hr0eNF1zHnQvThhm
	vxTJGyJL9gfvBx32xg5HTY9e16DhCdA=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4bvDs95Rw3z14M5s;
	Sat,  2 Aug 2025 15:26:37 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 2EF601400D9;
	Sat,  2 Aug 2025 15:31:32 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 2 Aug 2025 15:31:31 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@redhat.com>
CC: <linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 3/7] mm; hugetlb: simpify alloc_buddy_hugetlb_folio()
Date: Sat, 2 Aug 2025 15:31:03 +0800
Message-ID: <20250802073107.2787975-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3EDE8100003
X-Stat-Signature: dmact1hbfxsj1hftpdfoh58k9utsgjd1
X-Rspam-User: 
X-HE-Tag: 1754119894-755059
X-HE-Meta: U2FsdGVkX18JZpVSjXyJD92d1cQzc2dqPo/TWy+/4k0kJ7J1CIxikpuQqHzTUXJ9j9XjW9QEq5EkrENCFbp7+vWGh50SZP1OLHAT/EHcQqXhcwtv1k7b87hjkSE7oJMLXzcJRdBq7LvL7MIaI3hwVGOD+OtHA3kbYCb9EUgMCcEF3fQ7C6Lj8/b/fpld7qevkdIabsjN51iU7pJ9xHRT5YzSxz3YvEprELS2Ej3TwNOxbnH930qWAo+hv0oo5MIsYRQVlrOk/y8RHj/udWodpuWV/myXc5dTVpQiT7zV5+JCxriZ8WoZj/CbjOD1qj80/rYFzAfB65Hhcc2zRyqLqTra2kX7M9NuSmUt19LWasmeJL2xqpaQ/6M56PDm5k5bWpoaGzJlIfVnfxdAiwplSWak/Ap3yoWmQzNw6a6SefXelxkitt3dySkvpzRliw+2a8tpcxx2OFlAH7u7OQYQnFkGSlbWdphFWpFeeh33h/CrwCUssw/wWYPQiOX5tlaZiHd2U+oCqv6KLnRAV7zkt8fBy+9aFpwhHkwFrK9t9aIsiqhNGRYT5m/ICkABU/nUli1h/59odzCinOImwAYybMsFS4CNhZafBc1v0+EDByeIe9aBB5XJir7DPM2eC6uVTflzdpPaEsPKnd2G+hrD3V9s/8VQM0emOspcMh5bD2JWQIET6bWol96s+3iTTl3bAmvCfikML/zXfsnyawJGvp5HJ+mRPkYhcf33FYDAP4/PN/tQ0ycRcb+xp/dmDk1KgSKso5ytjzVRW0URAWjeI4s5WY2gh1G9zoKmaeiDAuNUKGEIWLj/EORs56EX2f8wAQYiEzouyS4jR3cYXgHWScN8eNpicHMNOcdBYevdqsRD6EurunadhCWkXEGwbv5uTXW51n9rzHB/x704NjvGfYfhi88dg4Dx1GsBabBCdBbPeZ4Ctk02nKip+as3YguThCHKwAreqR8nafh52Cz
 D0RAGyac
 bUq1tnzlxP4ViIZb5D/tV+64hlLoxG1XcOzpI02KcWQpucj0ZIOPGDrwjoPwCnPNo3M9XmzV/LVCW2b1mfSXCYZPXqtYO1UzC86pcpaN52v8nq0hqa3TLHlWlndzE+4e3o6VH18ImHMursD7PjA/fNW2ROQp0nP/1+96g/fwoRUsOkcjhkyBIQGIB2DYY3rBhKSf1CXu2ZUMrHiAZz00gY/w3Z2yozhBILuFxiMydGAtYRYs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Check folio once instead of three times in alloc_buddy_hugetlb_folio().

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index afec5a6a8aca..436403fb0bed 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1949,29 +1949,26 @@ static struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
 		nid = numa_mem_id();
 
 	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
-
-	/*
-	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
-	 * folio this indicates an overall state change.  Clear bit so
-	 * that we resume normal 'try hard' allocations.
-	 */
-	if (node_alloc_noretry && folio && !alloc_try_hard)
-		node_clear(nid, *node_alloc_noretry);
-
-	/*
-	 * If we tried hard to get a folio but failed, set bit so that
-	 * subsequent attempts will not try as hard until there is an
-	 * overall state change.
-	 */
-	if (node_alloc_noretry && !folio && alloc_try_hard)
-		node_set(nid, *node_alloc_noretry);
-
-	if (!folio) {
+	if (folio) {
+		/*
+		 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
+		 * folio this indicates an overall state change.  Clear bit so
+		 * that we resume normal 'try hard' allocations.
+		 */
+		if (node_alloc_noretry && !alloc_try_hard)
+			node_clear(nid, *node_alloc_noretry);
+		__count_vm_event(HTLB_BUDDY_PGALLOC);
+	} else {
+		/*
+		 * If we tried hard to get a folio but failed, set bit so that
+		 * subsequent attempts will not try as hard until there is an
+		 * overall state change.
+		 */
+		if (node_alloc_noretry && alloc_try_hard)
+			node_set(nid, *node_alloc_noretry);
 		__count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
-		return NULL;
 	}
 
-	__count_vm_event(HTLB_BUDDY_PGALLOC);
 	return folio;
 }
 
-- 
2.27.0


