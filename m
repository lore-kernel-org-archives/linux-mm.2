Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B300C606A6B7
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IVKicsEJ
Received: by kanga.kvack.org (Postfix)
	id 8C6446B05B7; Sat, 21 Nov 2026 21:48:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89D8B6B05B8; Sat, 21 Nov 2026 21:48:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DAB16B05B9; Sat, 21 Nov 2026 21:48:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 536036B05B7
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:48:13 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF0948060D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:48:12 +0000 (UTC)
X-FDA: 85461220824.09.EB48A04
Received: from mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1189EA0007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:48:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IVKicsEJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795315691;
	b=S+j/oamEyImYyyyzGrdtl6CxlaLJwIuKQM/XrXK2A7FPsTU4n8/l3EtzWlMDYXmYyEgRLH
	riIJq6ZGAgH/aUB621l6OnzWX6NHmVdEbQcCbH0qdnPJ8tA+36l+StkaCFo/rEcK4rLpCd
	peOaC1qH8VYLkPJc8jzqSkvfLvWytCY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795315691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kAE5NOdIS0At3Jh5k02AXwppwZhtnhWNnu4TdJThSWc=;
	b=VGczFMDLwEWSI/udKcFMnt3ncO4oSnw7YiV9WeKAH8gVqsTWMz2w4kiegcZEw6D1rwl6gz
	W+rmQCNc+DD8aT/TRipM1XXgx0CmhOPegf10XxwECCgEAKdaMvHrF4okm/N0wXrb/adlAp
	+UpCKbu500k0+eG0azaqlfQh3H2jU1s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IVKicsEJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rf+KgpXOB1eGgKM+XYvnpxenhFFTGz2oUtU9DXBh1Sk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795315689; v=1; x=1795920489;
 b=IVKicsEJXNAKfxno/Kp7uAN9lKaGVXM31V/OlAcTkNUiqcInsY9HcohqbaruKBNUi59YoWv6
 zIOyfH+lX2pgNiAwJAGNPhTPpqhisrnSDlyGT1D3S1ZquOINWJW5B00/nY10cB+fXoN0GrAuF50
 swEwHjvAR5ChboOv1dFubP9o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0558d52f41647cbc;
	Sun, 22 Nov 2026 02:48:09 +0000
X-Mizu-Trace-ID: 0558d52f41647cbc
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/7] mm/khugepaged: handle memory.high overage in MADV_COLLAPSE
Date: Sat, 21 Nov 2026 18:47:35 -0800
Message-ID: <20261122024737.2741569-6-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261122024737.2741569-1-shakeel.butt@linux.dev>
References: <20261122024737.2741569-1-shakeel.butt@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wa7fj64u6q3e97w9sbscmzt4ciktf8dz
X-Rspam-User:
X-Rspamd-Queue-Id: 1189EA0007
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795315690-405858
X-HE-Meta: U2FsdGVkX19FR4VVlaVHt0OEP80OqTE8ynujo0RsOFZqzzPAe+D9Sy5f5eR24jdMoccnq2coo+83kGy1CTsQQToXTcpp8G8Sm1UIMotF/yGFi8Mjp9iogVscOPUHwPEsBr16MgKkEnum9QX8Lb9/Br4LWXAOa7F5yaAN0hDLPBH0zEizg9xtr8oGWivj/+38bBOGxEAqtHG9diRAlMvjrWI7fjczWHsF6/gekKiu74zFZKKN+KXxyHYxKKxnK6r8TU8NlBu/1+HRVBikotvprZ5CZRljrKyagkwS9fuKn/eO9u1IXv+3eX4oI53/oE3OHAVRSrJ66W39D2C9p6oORRwPEOYH+PiWz8746/IuAuVVINokL/PwAphGhoQ5GK+l5ZqHv8XMHkQbIuebXA3CkuyC9yXhZES9dovfKYeM/WDuCd9dQHUCDQe+XlCww/CP538kOsSoNGVIPt0yvV1tVWF53peHCH399WDpZyRwWkYvQA1P2Lp6NZnTJgLgvq4sqtbmECf+d47I6Zdfj++jkxNPGsDzrrg3+zrnZuTInHHSxfOxKhP+DphAhg1tyC3UJe62xAkW6fTs38iC+XZcRmBXv8IRsOHXvkz3onwgq4aEujXxAQspzXF70rHWZlX8mhXjcuZXbrO/nZfsAe0VJh41/5Xei4LkOGEl9DQ11vqKsZd/WXPxQS+Iy6jlTaBYhnCo4rCUYzebqs6UyfxibLuChg8K4pk77jLptSqHRlmRlmKogDKtphwzTokI7s4VFQQ13LRjmor3vbTy5ZVWOIgKa474N4UUzJUw1UPD9KnEGnEHltz6rJuL/Cv4e/ADq5bh2ElxdK56JNwBU6vQRnaiXjLsaB8i8VDYJt9ijMPs+IRLT+splkcFPYreGbuaOq4xaIRGvJgHYgLbA8g85MsJTP2uk8AUk4vPIlO3MyM6sRfjAf+V+iLKKKj2HaRhk/rxzDemnmpPjRGC4Mo
 euw0Ncpt
 bHfheLB/ELSdNYNaCFf7QJG+eOt9PFt+iO6S+rVFBG/nhpWXGt5HNtB1kWmvqQJh53Nf+aDLOSXlqLadv0gop10cEE0CQ4Y++BcoW+PCC8MtuYQqYfnmRpyYmpY3qXp3HspWa1K7Kd6nm+r7lxAa3FrsOGBthI5KkusTtbxkoXbZA3sCQBrVysl7y6OO0GaYBOnQ2Cy7tKbTb4a405fNuEpcSfrvAGiU7ijXqmVCZH7ScMwUKmTFR7CJslTVXduAr6gObSijqCXD274WWr1uAM8CVm5CAP5bZgYmDmArfvLDxDRsY0ZukdGLH5tdTKEOLqOcUaQHXgha3M4sC3VS+SQ4IWmSG8aTYsJ/jypUUwvfCLfKNYUhH9zBErJlV/NMWKBvEiP7+AGMjFuG9MkCGbkfzGWzp0ySUCcJbKVi2K3HjKH5rj3BDViQbqCXz0DG+S3Gp68KkNZMdnLeeP94cvT+I18U2Ie3p+8onFuEdqw2+DsU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MADV_COLLAPSE doesn't limit empty PTEs, so it can turn a PMD range with
one resident page into a 2MiB THP. Over a large sparse range, one
madvise() call can charge far more than the range used before. Today
the charge path throttles it for memory.high.

A later patch stops enforcing memory.high in the charge path, where
the task may hold locks other tasks need. Handle the overage right
after each collapse that dropped mmap_lock instead:
collapse_single_pmd() drops it to allocate and charge the THP. This
also covers the last PMD of each call, so madvise() over many small
VMAs, or a process_madvise() vector of small ranges, is throttled too.

process_madvise() on another process charges that process's cgroup.
If the caller is in that cgroup or below it, the caller handles the
overage here. Otherwise high_work reclaims it and no task is
throttled, as before.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/khugepaged.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2dc4245814df..1ede7d30853d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -3306,6 +3306,14 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 
 		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
 
+		/*
+		 * collapse_single_pmd() drops mmap_lock to allocate and charge
+		 * a THP. Handle memory.high overage before taking it again,
+		 * including after the last PMD.
+		 */
+		if (mmap_unlocked)
+			mem_cgroup_over_high_throttle(GFP_KERNEL);
+
 		switch (result) {
 		case SCAN_SUCCEED:
 		case SCAN_PMD_MAPPED:
-- 
2.53.1-Meta


