Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE82AC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29E36B009B; Fri, 18 Sep 2026 04:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A00936B0095; Fri, 18 Sep 2026 04:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9AA6B0095; Fri, 18 Sep 2026 04:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E7AE6B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:54:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 191AF120329
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:54:17 +0000 (UTC)
X-FDA: 85226271354.27.3DF3036
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1F10B14000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:54:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N5heMBhi;
	spf=pass (imf23.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789721655;
	b=cbBzUznPmE1GpLRLzejqiCJjR83m704LSr/35AUmGrV3OpJpFFsKALTk3qJX3BBPwBgXiQ
	uKW04VC2vO7NWY52dVT3Cari1R9dH3DpibYKxGC1x8Ctk9zSNwh/wtxmmQaAgFH73KZOws
	VRQsO+3SJE8QAKL4s0Mb5Z+bFwoFjRA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N5heMBhi;
	spf=pass (imf23.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789721655;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vesh7QY6cqlCWJ5ZqW9v2t1L8j+x0dcgVZtRjrhKyxs=;
	b=glWzufrzIMvBvo8PXi2Z9NcJ40bqxwDfmsTUJg/pgiRXKosFqv72goaq3IQCCHELamHHf3
	W8p/olFBdA0tqgM9sY+yrnBVCKzwkMKuf/p3Jay+8bXHMP+AaaTcQGhCdsWIoDcZU0+gx7
	fBt8njAKz3r443tJ6/uoOhX/kmcmkBM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FEB944790;
	Fri, 18 Sep 2026 08:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A092FC2BCFA;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789721653;
	bh=/9TCN4nj48er2nF+5svVR6bjZx5z5MT9HxKzhS8mbPg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=N5heMBhiUdbRycjA66PMTBjUd0NULsArduaj8elWTzE33EG7piDFAIG+MbpZXUE7C
	 9MchWNwOnUb29ixyQdfT3izy59RGjld9d2btsoo/Y+9MR/FaQ1BL/DUrlYAcKDUIY+
	 un7RBXjSSb4beSCa9lXywyg4W/dMrbDB/JdEXz7BWmMowjkNVkKNrYlylOhpVr8lmV
	 bfIaT6ZcX6xqI31PW5kI4+Yr8F21uQ0c6qlaBGY0BDo83wHhPuDPVx2oOBsALW+Ch3
	 y2ab+He++k1KQJYad2IFexvES7WJX3+jihVtp9Dhz83sHgM8OHu1wTYO2CevZ7j5S8
	 M1vNLO+Dou2xg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8257AC982D2;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
From: Jingxiang Zeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org>
Date: Fri, 18 Sep 2026 16:53:43 +0800
Subject: [PATCH 3/6] mm: page_counter: drop protection fields from struct
 page_counter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-descriptive-name-v1-3-dfcfdd91b456@tencent.com>
References: <20260918-descriptive-name-v1-0-dfcfdd91b456@tencent.com>
In-Reply-To: <20260918-descriptive-name-v1-0-dfcfdd91b456@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Oscar Salvador <osalvador@suse.de>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: Jingxiang Zeng <jingxiangzeng.cas@gmail.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org, 
 Jingxiang Zeng <linuszeng@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789721651; l=1721;
 i=linuszeng@tencent.com; s=20260909; h=from:subject:message-id;
 bh=GADlg4c7MuNMFrgGvBXbc27o0HpJUKcrZX5lbsFPXjs=;
 b=1jXeFmMF4d9zQQS9hsdMiN/aPBms3k02q4O+kWhQZ8m+MkzNteDbtTrmxJgIpSWeZDVGUAUdr
 L4jsYEoTO8mCLqkgVNx9pNECUvDG3RsxJoXyoLpns9C1TmS/Ppv9kUl
X-Developer-Key: i=linuszeng@tencent.com; a=ed25519;
 pk=6K54xRzYIRWqatrAPy86M4E0MsI92BVJBhXwz5NdC74=
X-Endpoint-Received: by B4 Relay for linuszeng@tencent.com/20260909 with
 auth_id=1017
X-Original-From: Jingxiang Zeng <linuszeng@tencent.com>
Reply-To: linuszeng@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1F10B14000A
X-Stat-Signature: 46ooruix7myg4ctrq5jooyzose68sr4t
X-HE-Tag: 1789721654-242084
X-HE-Meta: U2FsdGVkX198mkmnhTl/WKiiTxfLdxBp0nTcMJKOS9nJ2hrWTCpQedWqcoR0xt+ixkzrq7puc+42vZKcTOKNqES9s/gS3wwj8zLn8wcZwNCVs9XscyroNzmpBxwpBQgNhkD7xE2rTHNh1NavAwzTTLpGwGrVJn5nr+LduS4mbzqUjveAalV8IsM0S6V6U248dsn4K2NoiGNCh+tZWQjysX5e+c3ANP0KbB3TJtSEOdxC5HhDIfIG10GdbdBCaFdIdCqI2EKiH9OEIAfldriUQKty0hegcrNnUrzBsXr8Afv8Z1TX+HmyJIe8MdPMP9UGqtK7hcTaDGSRuil7KAUUnr+4Xq371AK42OZdEcc66aNvd8QVFJfXfl/j1Xayo5R+pV4Lqv2iDbbRNZvWh5O2iKriWcVsK+IZyy8/Zvsj8hDRe/FPUewW7VplfwvMfgvoNvLRCPrGp2pdL4LCHI3NjZdTl/Ob4v9yotjkUrgvcKQj84t1LLpqA8Aau76dcn3wBRxHT3ET2aT+9ZmGisw3RI6y3hr9qCuarWudts0r8aSaFi2xLBrPRM/Zu9mt+RjpnB+Rp6USq3I+X/8znuzen2aWgR4C8ht7SRIqm1PwC8Isl9M0f5P4v2PvHprTph3ZsEWjNaybg9rbFZGs8FaPipBJYFyAidStzGuu5DeiUOYFLx3z1ehhDuHXf2v+ML/5Q7d70M7dywB6D5562WZk7l8S94irCjOVMyLz6TFMzuVQshguK61SP80NJkLxrPV69l9Mgkm1OhpEK5Ir+5IfJX4C5uDpbgTyOFhL/HYhMUSYNU8h7RlKDMPX91KGnyriwWRgmt2G7jOopCFpdlACPE16u6Tjo7paUJkS41XJqasysUCu+MoD+Im4hVD7MGtlzNJXVGtJt80fX2eFBA/qPp8sKjqJ9n1s1IOYrtcAcN8UerOOEEaQQVZfqP6AKfhu7aEuvYkSJGek9ULaata
 T/90cruJ
 M+Ognf0wi27nbIWd3RcMn3cfbUsgjyAE1vOc5iTcz3wK1Pb5be9s1oxZxbsII6fRU2gcZQISpUieacF2C+sdtoCl89ZUIT1g7aeguFEvq+pTaKRSkJhm001uVROj6tDYm55bzSfkWB1v3ownKP7jOShFrVKsc6Yh6cF8oBafC490fUKnnWXicT3tJrZn88XyKKcQf+Vz95KGgfi9Ri1RcFAyvOCJN5ZPKVJXB774oA3r3VlGqMRKnmLaOdlVfpqrJtHqWRHrIry/foW7yRPLMEkLu6DnZP0lzPdhYwco+2u+iCQ7sgcIwJSOK8oABUaM+liZ/f/vBdHZ+62ioK7N8pJM9GT7Onw6Mx5l+N8wkUfHzViimgRAESK5C31t5yuwIeLUlkRgL5v8+JWgyypZHjBrFikB1lYq/7cCBOpWEDNqplMbvdYkV5BVwR262z2apyy9J3eQ0xDd0x9awWYqYonb6WPqmcZ9HnhQpF5NNKzN6i9lGCE9jKitwTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jingxiang Zeng <linuszeng@tencent.com>

The protection state now lives in struct page_counter_protection, so
remove the emin/min_usage/children_min_usage, elow/low_usage/
children_low_usage, min, low and protection_support fields from struct
page_counter.

Also drop the now-orphaned _pad2_ padding and its comment: with the
protection fields gone it no longer separates the read-mostly fields
from anything, and the structure's cacheline alignment already pads the
tail out.

swap/memsw, kmem, tcpmem and hugetlb counters no longer carry this
unused state: on 64-bit the structure shrinks from three cache lines to
two, saving one cache line.

Signed-off-by: Jingxiang Zeng <linuszeng@tencent.com>
---
 include/linux/page_counter.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 5020e62aacb4..27467bf3b8e6 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -56,27 +56,11 @@ struct page_counter {
 
 	CACHELINE_PADDING(_pad1_);
 
-	/* effective memory.min and memory.min usage tracking */
-	unsigned long emin;
-	atomic_long_t min_usage;
-	atomic_long_t children_min_usage;
-
-	/* effective memory.low and memory.low usage tracking */
-	unsigned long elow;
-	atomic_long_t low_usage;
-	atomic_long_t children_low_usage;
-
 	unsigned long watermark;
 	/* Latest cg2 reset watermark */
 	unsigned long local_watermark;
 
-	/* Keep all the read most fields in a separete cacheline. */
-	CACHELINE_PADDING(_pad2_);
-
-	bool protection_support;
 	bool track_failcnt;
-	unsigned long min;
-	unsigned long low;
 	unsigned long high;
 	unsigned long max;
 	struct page_counter *parent;

-- 
2.43.7



