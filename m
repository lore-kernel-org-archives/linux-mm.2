Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D665DD64087
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4944C6B00C5; Wed, 17 Dec 2025 02:34:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448316B00C7; Wed, 17 Dec 2025 02:34:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39ED16B00C8; Wed, 17 Dec 2025 02:34:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9196B00C5
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:34:47 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF0CB60901
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:34:46 +0000 (UTC)
X-FDA: 84228150972.12.66A04BB
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 418EBC0002
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:34:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FrCcOy5z;
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qToP01h6jjC7s+UEzKCCG2SIQKxDhYzXBfQMHZwu8oY=;
	b=d8i8XOknQbj0TD22QqQrQnI5Hajj9Dw3Xp7REgmEYalRwoiYyQW5sPlUcE04VbMUjIHv46
	N3nXPn2XYqUltud/ZeD/PaZ6cKAb7fwU0DsZHN3xh26P44P0yli2G3SPrvzeDv78oyvytQ
	M0KYtGlmpRWO00U6NXjDWDImeCZ4Y2o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FrCcOy5z;
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956885; a=rsa-sha256;
	cv=none;
	b=MCH8fADUVP7MUQypb2lVOxCGwFupfq3Z7m/4DfcUxV1wJmvUxul36wbEq9OBcrpRe6TS0c
	eIOHllMSK7KaCUyJAqCNK1pcR/R6qTVz1cFQsNsyQoMfYZEMUUC6U3iHJPN8vIq+1MR67r
	s78EowO350IgUbyiehYlirWEiwcq/RM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qToP01h6jjC7s+UEzKCCG2SIQKxDhYzXBfQMHZwu8oY=;
	b=FrCcOy5zejKPmIe6RZhxcc37rX0Thqf+a7WCqahbplcOnDgkMNMZvKvGVtfQsbsk7ikWoa
	wG02IG7PU6FRiYDU1ldrOYpSY/YflikOoZMb575URPc1K4yiDO1KifgR1iOm6uyd9ovkHd
	GyaYb4aNIiF22aPDMQKVbN8C1QfQPdM=
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
Subject: [PATCH v2 28/28] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance helpers
Date: Wed, 17 Dec 2025 15:27:52 +0800
Message-ID: <a3ee89c663fd0f5b0f0c5579a1a2a39a0563727d.1765956026.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: 1iy5jny73qcgr54k98tqo4xt6fixhhnu
X-Rspam-User: 
X-Rspamd-Queue-Id: 418EBC0002
X-HE-Tag: 1765956885-870401
X-HE-Meta: U2FsdGVkX18CUJ7KijV09kawVO0kRob9WzaRYrscgPkdCX35vTetD5DHYt622jI2C8tPLHEF1hxHE12Fue1Otwsb/ssxuMMM85c4uyo1NT3VM+rs+aPGwXjbXbIIcflqvYkMiCIbG0ytofkKyfn1ybPNNrWfuQk5mK37n+FQSmeTokRqscBs0aDC3CpiP9k+anSds26EFZH4swubg+a9FPBjrebcxWpPhHT/TutMI7oho+57R+v16Iknrge56sZJXBGOJfe1AFm8eIloO/d1XiA+FOeOS/+T9uWh1YS6bmOFsKUBjSgRTUdD3wzivpR1UExhj5VKL/6uSRP/EUuDdGdsApVNAmOhL7U53pe7EEK73iexX/UfHKim2Nim5FeWxbl9q9ZCG3afnN0VzaC77WKBRRKy8wgsWquYg6nyLKM0+EIiyFs6c5AoepEkQAjGODmowQUBQg9yogeRzSRmBNxDc3xASgaxzwFMz71+7+UVUhQjw7fxGiFsdehrjQP8jNjqTLDojvYVHOtdffhJ/HJECaIBf59Zy/SpEGFkMEQg7QTcPk6qdAj0Wqf8VK5rrRJy4ookuQH3MrVvjbvjT5A8SwB0E3kRuEEWF1kPzg+adAZncZO2ZaaVC8sVG5PAj12NxIcQ4raLmhm3IjjIm4Hwi87fGfSb1T8R6LG+yH7RoUjk37YB83dYWxRk/xCTA7hJwRDW8+LU6TKsCMU2URGEe6655iLkXIt1eGnCLBDafmF+aw5Bs556SZE9IqqaAM+aKqYtyWlyj1pmftR3XMYR2hSU96bhf0+mTfUIA7eO7uhU2AIdpwdlum0Ai12LwQqMYrP/w2jzobK56qtvCN7oo1gbDC+8Mr/rULIq9HOrYhfiTJZKaG9C65985bDm2aATLMFI9Q6iqd5wr6s0mn1ipEiaMJjkli7rM7the3zev9L5SY/Y1IWF42fom3IUOX81mP095os77I1lzVU
 oGHOPjO9
 5+72nP2mmxlx/ne3cli3/7tkLMJwZCFSKJ0lpunEPxwFZACHdJeAk+ucrVT/kZjBRIVVs2C+N8QGUkwYPIWFPciOzzuKdvtJS4FjC1ksSWNwbbDjXBBZWGxOg0kW60w0a2zXJYz67AcQQLHtOarIByVUlLpcdpStMyZSNjExzZe1alfLStw3JUNtlbMXM0AIyHidAVPzUrPdrF2TW09xfvgL58O6Ps241XfjddANUwdRfsRXQZ3gCxC2BxFQJ3ROzHrwQ32KUPLFD7rOitR8XYWBw9GFyeHtRaT8SnrSZNUPfrh0=
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
index 64a85eea26dc6..2dc3ae432a017 100644
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


