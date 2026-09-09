Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EBF0C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:35:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B516B00A1; Wed,  9 Sep 2026 09:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CC016B00A2; Wed,  9 Sep 2026 09:35:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2D46B00A3; Wed,  9 Sep 2026 09:35:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E0326B00A1
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:35:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68D63A01EB
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:35:01 +0000 (UTC)
X-FDA: 85194319602.25.BC2EC8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id A3AA18000E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:34:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BRsmgCIw;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RbrTaD0MOwCU/dADLtwS3cqKnDKmO0natjZctaLbG/M=;
	b=an0HBsS3v56qMN/vZo7qpmlFhAQxwoB4y75KtCA6+Uc4bM230HeeI0nvydsc835AudAYFd
	bQRjQYbrU2SJUkrTi+VW5wePqrev3070wGOpbnyQWe239FWTjydbl7xjb8uQG6uwi2NtcI
	VDEjrPQdnNinC//tFbM/bi46ew1wbB0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960899;
	b=vipEFwZS17BHh857Yt9ej9nd26F3bGqB2UDDGnassgOq2S1xuMVbLluJkENd87WDRWsg8R
	KvXjCc1Dqmm92OsbLboMaOikz2bA5ITVCeLVPDkEN1sfPB3sPceXPtZTQyXb+W7NlqfIfr
	scyGr5EAlCrrjMSWYZYPZBcgKUY8DiI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BRsmgCIw;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 037AD40582;
	Wed,  9 Sep 2026 13:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9AF1F00A3A;
	Wed,  9 Sep 2026 13:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960898;
	bh=RbrTaD0MOwCU/dADLtwS3cqKnDKmO0natjZctaLbG/M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BRsmgCIwY0Z931Vf0ZjC6k0U+yWVRAZCHkkhlcXWETlu88ySO3sCpKrVMlBV0iwfx
	 uhI+WzvqD/3YQ8SMBuVeKSS3n9hx1GEVvZRBQVN+UZ6ykgBxwlGQRStGr9ZtQLU75j
	 5aH0gGEiUG3K64WjEPowzkxXP0T0DJT7FbdoM/VRe8+Cqvr0qaOBmdfjtxHK8E99jh
	 mCxckMTz3aD1mk4SOj53r+ZG94HF+mDeSiNjqjkOPLTKlbPE9tnTT1lHzT53+jY59q
	 em4ZD3q2xBchOgXc3/a8fw6iE6JpLL9tOd3EhDpAZ+Z9UGFQ1cTGuOHPZ35dJw+hKz
	 ndwC/p+XCnE6A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 09 Sep 2026 15:33:00 +0200
Subject: [PATCH 07/12] mm/sparse: remove pfn_in_present_section()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-b4-sparsemem_cleanups-v1-7-008fc8d579fe@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1038; i=david@kernel.org;
 h=from:subject:message-id; bh=DA7ADutddsFmCEjmK+yDurz/oaDpzdkWvjLNiIYgvvA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIWJhj9LT/1YHOplEHQxz9GrwpNzSyZjmz2tmhef2zS3
 OZzJVmKHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzk5BqGf8bHdbuE5Vl+1wfJ
 rk3bxv5+Da8L//f8XY1WufOf/10fz83wV1ZXYe3Dd1PSZ0bz3Ofq3hL065LbnIjrSodf/jx98dm
 sNawA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: pf9rfmc6eex64xabgkj5aqfj9i96reod
X-Rspam-User: 
X-Rspamd-Queue-Id: A3AA18000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1788960899-588923
X-HE-Meta: U2FsdGVkX1+2tSMoI++T1cAC+fmDuHhe9yTYt+bNi/hmwH15wpregQBdm9PuOi7fZZWfhxkyZXS/liCdIRyBAwhLd7Wd4qpkzT/nPylEcJ0OGjMaysDcsscfPPGGPG25myjA3EjSVlsT/Jt3/A7XzYw1Xs8Acu/hx8FkEM+hePBs0oK+rx4mzphc9/Yvv2iwEO9HV9djF6OUd+6I156yhiOs5u7JvJaZvQkksUqBKXOsXPqlorbBMf9Ki4IBdj+VQ/FuAWSBFFx/QCb4WW/cnGbXKkGzNvCNpVdm7S6IJ0oFUUQ6Vq8BLOnl2CGtpxidiOJiuwxqBYBm7yYuoHkyghK6Avde2+/H+T4Fb+xaAFA4o1WB8UajmKy5uDPl0tiWmz8WMMye0q3RhC2SJMJR2fkb9X3Pz65gU+q2Up0ni+9ChcqvbxYQ8Aywx3mbGsb6Jwcn3Q2x7Z1LYEuYKAuA8PqXTegC/1RO3SGzThsQt0U5dOGjjDBJ1o7puSpG4HWpkdanaDpouIoglukdTvjkATHXFDyZz7WIHw1xjJ6n5gyOUDbVQZ+1hF/VAFof7rkB2Gf13qCxIRgK37fGQ7/O3lJDkE6NcmtcJ5i9J9Ferf/wxgWVNjnDaPWdbytMmKvUwi3CpYfEmhcSaD2GGjyv73JGsY26BHTltFtr4PArIikNgR45HONF/snQnPg+nT0LdmcX6saN2U8VWbqNFeiTHD/dJS5x0caZ29PrsiI+D+HAVj3ux/9d6zixOHbrMoEwLaL3w3W2pYkQN7hq+iYJgQDs+8/PI50yJESqpjnXDN7Gu+vVbxc/Zz2nXXIcEGTZ9HdCRcV1AzrEgNZ1I9S+76OB3LNIKYX4xpt8j7zUV4myplqy1loKJdCe4hKxngh/+Zmkv1wqCT6TJcRRHwS/JIZhKXZTdMXJTaMlss/cYEL2JUJSEn9nvckZAGsy9cSqQdjqqcNaRLmsYjTTBqg
 XxaRnbh/
 u8fWpZmHVkyLeaSwZLUNCEBNd+QnJkncHXd1Tgsw8aW3KaxvOXpkWBA1NUI5X6iYd2wT7TV5v1t7ryQotnc47VoDoYDIYqZDnVCW9WommNriIBRKrFm0+Y2i3aX6jO/DfMl5mzJHCxZhvrUbVuWCfMaSM+C+QYWKb9k/hQ7nM773npw9xEri+RcpDkVnVchc7vAMiIh26UqUGmCXDjP+F+ryJVhuH3wYTu75Hpf2520891ZJ2Zl4Urk56tMjrCnowroDASL98kGadBL9aB/OjaxSUv9DilRU3OTlP+8kCN4zcDsLSQORLjt/yrIIiaP4yXLjjbvKFKVrSsgXsQtpt0kRSMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unused, let's remove it.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mmzone.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 19296e8ef44f8..e0fac344f6ac2 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2315,13 +2315,6 @@ static inline unsigned long next_valid_pfn(unsigned long pfn, unsigned long end_
 
 #endif
 
-static inline int pfn_in_present_section(unsigned long pfn)
-{
-	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
-		return 0;
-	return present_section(__pfn_to_section(pfn));
-}
-
 static inline unsigned long next_present_section_nr(unsigned long section_nr)
 {
 	while (++section_nr <= __highest_used_section_nr) {
@@ -2351,9 +2344,6 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 #else
 #define pfn_to_nid(pfn)		(0)
 #endif
-
-#else
-#define pfn_in_present_section pfn_valid
 #endif /* CONFIG_SPARSEMEM */
 
 /*

-- 
2.43.0


