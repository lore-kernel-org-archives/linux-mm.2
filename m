Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA6D5C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0B586B0096; Wed,  9 Sep 2026 09:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDC386B0098; Wed,  9 Sep 2026 09:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF2D56B0099; Wed,  9 Sep 2026 09:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2D166B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:34:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 09759401E8
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:34:06 +0000 (UTC)
X-FDA: 85194317292.13.8797669
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 38B4840006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:34:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxAJ8TkH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ke7wbwtpCjUAwuxuLGTSFpELTF8GAXgQgWxJpOfKOlk=;
	b=mX8kteO+12j0Y3js7D8slnaDM/E05MXG9UrQrWMltsfqptYhmNAxxsGir/bZO4l7hf8fU8
	o9mZDoLl/dTvcTnCfPJJx+WTsEsmEB26jKzi0Ux+OJ+x8QRuLDnrfJ344ySQ0xr0aVkadf
	nn+GtuXDUaedk/YTuAZ6qdmVZPFO+rA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960844;
	b=WAUaKx2lCvbfQ410aOGeaNp1kjMj2ANYlDo5dRjMFGcYgb+dSEdHpZ9z7k70dppi4cufLr
	W9YjxAubYd8q6Vdqb/bjinwFJ6pCmRO4MoQKgjBTzAlkEPW+eAGkVef+h7L51zc+0iMF6r
	507cFdEH9+gSoNtOsEsLzjXqK3RUYPY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxAJ8TkH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D31643977;
	Wed,  9 Sep 2026 13:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A319F1F00A3D;
	Wed,  9 Sep 2026 13:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960843;
	bh=ke7wbwtpCjUAwuxuLGTSFpELTF8GAXgQgWxJpOfKOlk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kxAJ8TkHym33fm/nM2JegElwmiyVwFZ0YNsgval5iLx/fAaFlApVsOrk21RqvhOTw
	 bdhecW15KUMV8YzLqiIH9eH0nvy37ki3NSxffsRITrTO2nvb4Pw9r+uTw0uLYi2lQ7
	 JEBxI1bdBIc9ph6Vw/Q+9p/SAbxsj56xU9uloikO5hpn+uFjATCy8MwIALXktyfQbh
	 W5WZd1dLWstQKdJ/jti2Ep5zLEed9g5EExRVy6+g7zvzTrS0AIAUm/UJRTGFtCV7Ka
	 eY+vCZsu9eFAyTywAl+ehZ3vRHLoi8Wm+gXFid62KNoMwvpJ7I4t9YT9ozLsk3Ok5h
	 2B5UB6El4/WMw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 09 Sep 2026 15:32:54 +0200
Subject: [PATCH 01/12] mm/sparse: move mem_section init to
 sparse_extreme_init()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-b4-sparsemem_cleanups-v1-1-008fc8d579fe@kernel.org>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1918; i=david@kernel.org;
 h=from:subject:message-id; bh=tuizVE3zPZHpcM2HGG+m6b3SuJ7LR3VtKbc7zGfeEhc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIWJqhf+8M6eYfkbV/5ZQszo18qzdtQdUrG9MjBH/tyl
 68/zXM4p6OUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJXPZlZNhr2Gf7Y/aN9uOy
 Ru2WM1VWpqrOtt1qHfHiRc6HOeov9mkzMjzbsHlZRXPhkflTWh+3JPtvW87zXvjPD8mr2Ve0bPT
 4f7AAAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 38B4840006
X-Stat-Signature: ziksn4o3cjt3g9nzw95osnm7oibo9jr8
X-HE-Tag: 1788960844-108834
X-HE-Meta: U2FsdGVkX18GOh4UsYEhjO6kWLQOh8mld8z1Vf/GmiAqWiCF91Rp3TBXmWlz87KazyF+NkmIKaBa/WXn+Bjji6gYEajwFsRmgk9juq3rcoD4epMX67/0i7GmWzNGMtsLJVZKZtIkNCoUGeor4UHSehLGwlTwHOpa4KOVg8PdA1hU7Y/cpZNBMstPPL1u+GsSeB1xiMYmnEmZTxw8GAM58NSvg1qh0fZo/wLR5HpJexMvMDPIyi4gmbKIqw/NoulgS6HNUBlQtiEz0EA8E/S7WxV1MANii5ajIaTkamoU/RA2yTFi6MQHl9KNfbzxanC5sVluP31cEzLaLBiO7RoQRadvrvq8LJZx6iFSWJB5tC8V8hbUoIs5ZQLkCbRQx1N5uMCzqmc6bvad3yItIwScTpfdcG8wHa8EERnwTkBLFeJSkmexxfSzK3wsMTd+lk1Yqdnvdetx6JHE6QxyA6DRS42lDhw1WjYLG6leuh/WcbOIw0c3YkBP347B9j73prc8yIe9Laoh4itkA26HLUQyczM3cOQ6TF3OHMYkGg2C2iwI5Ct/BuLKN/iUqdNYCM/Vtw6dbQTwoT0j04/G77mQGgPZ7iaIl9uoaovOhgB+u5Z+bGf0H/zIEH9RoBq3gV5JXwDiEzsrbYO57u/jH0PPNfoJgTUfmomPzu142ot4t60KAzzOOqR8h67XmdUhrHcm5CLyXP2IQ8eUSHhquBonbgYJWx1rH5SeOlmrVF5tyoE9Ka+vcBQ4aHTl+2ZP1yXxomOH8zwl4nI+8VYeA2hIXsJZheEACkpQlx5hhzV4jHwaJt2BznjiVVVIHWUR9wlEfOfM5+/vp8C4YQ64TFa10QzhwaPiuyQmvuzHE1R6fvcMysT/vXCPch3zpN9kJqpHxFVBmHVAIVNLoIQmmnVPYv7i9FOAjgBDRnJJsMdYnUAAyfho9f+XslBvwesYUBMtGyhjLadqLyMd5SJ0xBr
 4B5bGimx
 y+UdaXu6ZS9r8RKCCP/Iv6ovnKyaIH/kfh6EqmL/0rbmYirOFPQaIObCUEjgRN+T9jM+VgEXvWiaWU6v30+Q9m9Z9k/4H3/iSvFkoaLfSuWXy94Pyu7eszbBv3rLF2O/8kbgi4kWu4Y3ozZAKth5u9Y+HmjW2KlTxwNat8I9tKA2rzGLsGEj67iY+L0xfvkjn7LouQPYQuBlN2lUx2yj3rQKPn52zfadUTmNP890KrgeHzX1WCgDRGe1hxZkRQ54DCtrGJ5BV+qmPvLrlxMo0bNXF1W28DpNjuXDt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's just avoid another pair of ifdef inside a function. While at it,
switch to INTERNODE_CACHE_BYTES by just defining a fallback in cache.h
as well, given that the x86 variant already provides one.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/cache.h |  1 +
 mm/sparse.c           | 19 ++++++++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/cache.h b/include/linux/cache.h
index e69768f50d532..b6e857b985bca 100644
--- a/include/linux/cache.h
+++ b/include/linux/cache.h
@@ -89,6 +89,7 @@
  */
 #ifndef INTERNODE_CACHE_SHIFT
 #define INTERNODE_CACHE_SHIFT L1_CACHE_SHIFT
+#define INTERNODE_CACHE_BYTES (1 << INTERNODE_CACHE_SHIFT)
 #endif
 
 #if !defined(____cacheline_internodealigned_in_smp)
diff --git a/mm/sparse.c b/mm/sparse.c
index 9349ed6326c01..6a6d258862904 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -103,11 +103,22 @@ int __meminit sparse_index_init(unsigned long section_nr, int nid)
 
 	return 0;
 }
+
+static void __init sparse_extreme_init(void)
+{
+	const unsigned long size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
+
+	mem_section = memblock_alloc_or_panic(size, INTERNODE_CACHE_BYTES);
+}
 #else /* !SPARSEMEM_EXTREME */
 int __meminit sparse_index_init(unsigned long section_nr, int nid)
 {
 	return 0;
 }
+
+static void __init sparse_extreme_init(void)
+{
+}
 #endif
 
 /*
@@ -197,13 +208,7 @@ void __init sparse_sections_init(void)
 	unsigned long start, end;
 	int i, nid;
 
-#ifdef CONFIG_SPARSEMEM_EXTREME
-	unsigned long size, align;
-
-	size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
-	align = 1 << (INTERNODE_CACHE_SHIFT);
-	mem_section = memblock_alloc_or_panic(size, align);
-#endif
+	sparse_extreme_init();
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
 		memory_present(nid, start, end);

-- 
2.43.0


