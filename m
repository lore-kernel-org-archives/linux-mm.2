Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7D7BC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 802976B0099; Fri, 18 Sep 2026 12:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3676B009D; Fri, 18 Sep 2026 12:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A23E6B009E; Fri, 18 Sep 2026 12:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 324026B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:35:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A69C2A6212
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:34:59 +0000 (UTC)
X-FDA: 85227432318.12.7EC4203
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id F35841C0006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:34:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L7oemrp+;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789749298;
	b=vQDBEr/82IdWgA0MLo+l+EYuRYEIsDouLlxn3nmq9iB7124JQgT8s1IVMaiCljD7nn2rH8
	BtgslqejCQkDArOEICRE0kD/jY/VczjOwA9gvh19CdslmiiIFiPRnwwUSMELCsnJI6dlIm
	RuZB4YiPEmvoBKaJsF9m605mF6lEwW0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L7oemrp+;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789749298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MsNld8aUbgRIh2O6l97cYYAQPrAGS7NYzO+geQva67A=;
	b=OIyLl3uVUrTtk/KnBC3BylA9bh/E8ODB6sh+QBlEVWgRyANJmJUAzFvdqmeWtL2FC/4KsY
	LNBSN60EbqAUrYC6wYKrpFBRQSGMIorfOsNT1IwyOESrM+iR9I07RfhFrbNZtDoEIsfvHI
	gEaV4K4A/Dokta2xXus3emuhiN5gdwE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8350460A58;
	Fri, 18 Sep 2026 16:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4EC1F000FF;
	Fri, 18 Sep 2026 16:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789749297;
	bh=MsNld8aUbgRIh2O6l97cYYAQPrAGS7NYzO+geQva67A=;
	h=From:Date:Subject:References:In-Reply-To:To;
	b=L7oemrp+rrNnE4+Tt2e9cmSNkzn9oKbVyqO2t5vODb7ut75ggqJqs+JXQBeBM5C3j
	 7LfJL3qrXcgAplBN9bjW3/I/69ywNu1tGa9NFtKQB/cYpXPTnYQ8TV7a7TkPo4q1PC
	 Idi5WvJMqWqMV2bDIRnp58qJ81hQZU+r4Z8vyHm9z3pyK99tRVh8MyTWEtUJ4FGOjW
	 l5Y7V6Yc5jjlKtnkSTMBWThDUjmuSE8/cIPcUSXv5Jh4KAJtLv9lPdYh+YLbjBRmhz
	 7PgO1llreYx6bTMQ0ha6GY3odPxKyt3pVTHrmBt3kBgwWfZBHlNzM8vXw7nEDj/ewf
	 APIfrKf6yhccw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 18 Sep 2026 18:34:25 +0200
Subject: [PATCH 2/3] MAINTAINERS: move memory tiering under MEMORY
 MANAGEMENT - NUMA PLACEMENT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-maintainers-mempolicy-v1-2-9a94cac6d135@kernel.org>
References: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
In-Reply-To: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 Rakie Kim <rakie.kim@sk.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1806; i=david@kernel.org;
 h=from:subject:message-id; bh=UPCYiVO/tjt8CLbaK9mu1VcDPWT+Zq6Sy/WXkOGWMYE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLWZigbbI1cXvn4xWbfEMar/5/LBVpzbM/4sPnuvwNqV
 qzRtXNlOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjISnlGhvlSCpIXvM44cPpU
 FUy9qFTOLn0n7e3UKlE2v8nOIjf8LRkZJuZUfi0763LbRV1Evm/PmzVbKxc0P1yu/CH2R838DwW
 HWQE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F35841C0006
X-Stat-Signature: bw6x3ewexogcdmdcegnokuj4afk5ujus
X-HE-Tag: 1789749297-116230
X-HE-Meta: U2FsdGVkX19YLDq5ZwlzGzKw6FMFsRt9Y4rKwDcKxZCu8xeFrEiiiUrPpTsjch1NEaGLhfCirCriXpCMXZYrwPD08fD7TPEbdzz3bYE/cOP1k7y9gUzDWUcST3I8hT1fwTxiH3lgdR83mNp5TG/7Gc/S6QnNEj3x5G6nluezlwxnD4b25xmrZ/WVZhcBzRbNlGwEmfbA7a4ReUBwfbAZB+6E1Ejln6WzTcNjUBch2p+AmDPH9/9Jx+n/HzpxwHZLu4+ASPxf5VEGeQDM4sJlPzMwvXZvKphkWkNr3ggyE0eJrW2MCB12JYo0hcCDe8jUcYMvLx53ih+r02wm/5mNNJmGRsU91X9JU9D8ayyweRc7KqeaWQe0gQitjS4Kuvx9WL3RrxrDlW8daqNJchlBMbKbNmZvhYVK91WizJ7sQC69Axo6SdZF9xEaWPJAWPWqKspoPVhjtu5hGbZxVtzrEoUWVxg4YkaM2Lb1YeOayoAqS+UyuBFRPYgb1O442QCW/rT5/5HKFdfKoCNVrQxUXbiclmImfsM8MNRHtE2CO1ZalqV9x2BA/1fw+kvGsQes9fLIuobNVZDhc2tn79mExLGaZeltNwejhmu3VM7iwjj/G+Qb/oSVMijaZt6U7YXRZjZKQrGjGADeh5r3YeWvBEaOUxynuEJARdeQCI1D0JcKw7bLpiSXGkYVkk8XenEDAq1QI5GSSk9dlgQgW5/dzGklXwlT26a+VcCqZQYgkXhrd/f4UvjsZasP3ZAC6vp4oio9oJT7rr/6F+UL2L7ye2be/KwTTsfZ+K2m/8JDWDX4SvV7PcTu5aZt1wAb9B7818SXRuwKGlimVhBIGxkhltMVsWHbOyTZttoZXhiBlQ9YpjhrpzG+QVrWwsYoebiy15FtV1+abLPo0atqblOOGOpDsYPjR3rHDab9bJzweat79H0tgIpKSZJPWFhFNXb/C9fVMZIziwHum0IjY9d
 NgW6ecTv
 RWNEZXvVG1s/mLIY4BgyQCVTG0qiZ3GAgJCWAZc4uxwMjHYMDFNosjrGiqoFLdC6nL5n0O9/DHON4yby8OKHfBm4fR+GeOUA4N97gAo2NhF206bXF8KVg89bcqMX2IC9X5UkN111SmTLGcVQN4y3TERvDG2SoIqJn5ZuE3rmdP9+FJDiVjR3M+0Fnu35qdCdPxy0Cil1KM3w6F7AD/RYREfLq0wJEHaXYUE5zmW0c7HedEu6mepZOMxSrF7RtaiDe7pCp2pu8yRXZheszXXvM3fnf+pQPU/xdks/nxPcYO4ihC+xMuMn9CwXBgLm3plQGEeVXY2hw07t29xEuoiyc2X6ruWJ/kSdlVM3uPyBQY/T1LmL6qxT6V3WAKjXBP9uIyyVyBKDt9adTjO9uKNB8mx0Bgh05PcOrJOfgdSNlhf8aSkqUhzicKj/mtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NUMA PLACEMENT is a better place for memory tiering.

My best guess is that existing MISC reviewers are not that interested in
memory tiering, so don't carry any over.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 MAINTAINERS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 77232db57b53d..344875eefd175 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17261,7 +17261,6 @@ W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 F:	Documentation/ABI/testing/sysfs-kernel-mm
 F:	Documentation/ABI/testing/sysfs-kernel-mm-cma
-F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
 F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
 F:	Documentation/admin-guide/mm/
 F:	Documentation/mm/
@@ -17269,7 +17268,6 @@ F:	drivers/char/mem.c
 F:	include/linux/cma.h
 F:	include/linux/dmapool.h
 F:	include/linux/ioremap.h
-F:	include/linux/memory-tiers.h
 F:	include/linux/page_idle.h
 F:	mm/backing-dev.c
 F:	mm/cma.c
@@ -17281,7 +17279,6 @@ F:	mm/early_ioremap.c
 F:	mm/fadvise.c
 F:	mm/ioremap.c
 F:	mm/mapping_dirty_helpers.c
-F:	mm/memory-tiers.c
 F:	mm/page_idle.c
 F:	mm/pgalloc-track.h
 F:	mm/process_vm_access.c
@@ -17310,10 +17307,13 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
 F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
 F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
+F:	include/linux/memory-tiers.h
 F:	include/linux/mempolicy.h
 F:	include/uapi/linux/mempolicy.h
+F:	mm/memory-tiers.c
 F:	mm/mempolicy.c
 
 MEMORY MANAGEMENT - OOM KILLER

-- 
2.43.0


