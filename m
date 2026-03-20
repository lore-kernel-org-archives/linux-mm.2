Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05CB91098787
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586F46B00CA; Fri, 20 Mar 2026 10:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55E196B00D7; Fri, 20 Mar 2026 10:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49B196B0134; Fri, 20 Mar 2026 10:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 378636B00CA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:04:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0381B1A025B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:04:13 +0000 (UTC)
X-FDA: 84566610828.12.287D9BA
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf23.hostedemail.com (Postfix) with ESMTP id 38BAE14000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:04:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NrVkySz8;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774015452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OruWX6Y+VrnzFhcejZb+iVJL+JhqwtkaO5WVBgW6UjQ=;
	b=M9JwmpcMn2jy68Ews2/Rh8FRamZ0kw6Q35cdO0dDfpVwgSKcIMXzROiJ5/syjrSQcHpRvU
	Hh3xo+aTw/HM4Mm+Taqh1aQ+dKNdE6ZNNg0VG1Ab92d/65wcnpdZAmEYtIkfVCcZaWKx2L
	FKftzMNW7hX6TerxEpdoc/GNK2+F7xA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NrVkySz8;
	spf=pass (imf23.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774015452; a=rsa-sha256;
	cv=none;
	b=Es2zNR/xuwICUdAOT/SdCf9dWeDqr4v0kDoXKK5G0kmNCfmKLID+Oa/VCG1OT7tx0I3n5l
	un0JvI3HAbRp+u7G9EmDu5c3qmbj/k0CR96X/Hfn/mVAsD9BoaYixhD529aVjrb8fS3yCw
	VRxWP7JzGQ0r9CZsDNjAlOzzPFICaHc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774015447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OruWX6Y+VrnzFhcejZb+iVJL+JhqwtkaO5WVBgW6UjQ=;
	b=NrVkySz8XFBNwS4JdeWfeBofM4ytOBdZdZrAkUxNYCNGh3uxuRAPJ5YcoZEoeOwqFWU0CL
	f+YfK4i/Zn1/yHJ1X93vajWc3NlKybjlbIro8UCI06nC4kwGlmM9uk9uEpVJpjEETXdRI4
	Pbjc2GicF57gusHNd3E8jN/ghaAy2VM=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	willy@infradead.org,
	ryan.roberts@arm.com,
	linux-mm@kvack.org
Cc: r@hev.cc, jack@suse.cz, ajd@linux.ibm.com, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev, Liam.Howlett@oracle.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	wilts.infradead.org@kvack.org,
	"linux-fsdevel@vger.kernel.l"@kernel.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	kernel-team@meta.com, Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 1/4] mm: bypass mmap_miss heuristic for VM_EXEC readahead
Date: Fri, 20 Mar 2026 06:58:51 -0700
Message-ID: <20260320140315.979307-2-usama.arif@linux.dev>
In-Reply-To: <20260320140315.979307-1-usama.arif@linux.dev>
References: <20260320140315.979307-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 38BAE14000F
X-Stat-Signature: orbpkyu4qwnp8wphsic4py6smhkzpxcj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774015451-700267
X-HE-Meta: U2FsdGVkX19wPRIby8rextXz/2FKocgHO8fc9Hof6bqPkKBb2afmoctNgjRsmqXQ3IAAF9abaraj4rVE9mTrdL0W6Dllj7e22kEK7pZFq82bxxkk8/T8nNUJFD+mHZyu2yEcCg5VGe6xnGiKb85cTMI3iF5LP0PcYQnw2meGms1lZSo2QaxQIBFhgwPIwb0HJ25Eu1DHDL5jnQUN5NC+0QA2qpA6TjAM9PhdMlTOb5vKKQeTJN1J4X49N+Fn5pIwz9i7zcNmjypR4w/R0YrTf8IU0Sxn3zODObFY63ELkVogCEvcqXUzAA0vh5h+tw1FhfuaP/jU3dHx5Ee86+4sW8zqHyBNPy4bFY2MdnZqzWNc2YlhCFvnlE02h4bmR/t6e+sdDSnp4BxRYORFbc8ZO4eLZySJxvQhY3sFQui/gx3gEob8m7pyPZKNv3o4HohP8r8JkC+cfbwn8Z615gpsWN+2e4s3UT/5MgKAcQ046RdqFlhJ8MINdJnBrrK+GY5Pf/AKuUhPmWSLdbC6kwBsmIdxQOPcfIFlUWGImPRJuvqPu5GbdYgAUR9xpDM9IagB5JqFdk82pYyGWIhiILHgRWomWTYZ+c6eNs10wibZifcDh04R1qbdg76+0EhOYoT9hHd6ZC29XinzSKixJBxgN2CL2Vet4xUHyq3tOGQMLGa1i1fUNJgKd7diJz3SDbGyU9jQdRaQ6wqSpPO16PNprJYTCDajlLfDfuyxMcVjF5vhHvY5yp91GATsrDiUDe0O3W5UqPGi2hMNQw8JFK8/+bxFnp0vAVR2JPQQQd7m6jJq530oVv2HhMf26g0ip0KEYkZfY2iZ2TLQtmCH1H8+jDgiGg+kO2j4j3f6XBOHMMxn/YF6dnbfcCd/E59+rQBzaGSa3mgwJ/T2tUlZIqURRA6scZpYBYbVZkus9t2+F7+BES/4NMAk4hsb/r6j8FmjVzes4jZtJVJ4db2r1aR
 7yceT+XV
 n0h6D2FWFk+ahEu4MABI98dL14t2Xyaun0lHAwKb8gGlGkcB3hnB5B5jPVpbTdQu3BO50BYIZiAmSxv2csjV6XZzYqKkaY/FF3wriEI2w71k5aHY7+JUqwUheFWc4Y986c3x8KgtF9AdaM0WUh5l3FKOTexZ+RfwiMJq3XTJqSvHpTJbeNKzZgZAstmLRoyqXnFaPnx/uymPG4QeKP8iHI4y/pkBMbahGo/2r8QT6n0lEUGSqdrN1AWOYDiUFNPXN60Z7wHLYZHcQw0uU4xnZYonClVjCaq4c7CJITXdh27KAIQ7m8p1UCA4IRPcSrd2/js0+nIosK+L7mx0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mmap_miss counter in do_sync_mmap_readahead() tracks whether
readahead is useful for mmap'd file access. It is incremented by 1 on
every page cache miss in do_sync_mmap_readahead(), and decremented in
two places:

  - filemap_map_pages(): decremented by N for each of N pages
    successfully mapped via fault-around (pages found already in cache,
    evidence readahead was useful). Only pages not in the workingset
    count as hits.

  - do_async_mmap_readahead(): decremented by 1 when a page with
    PG_readahead is found in cache.

When the counter exceeds MMAP_LOTSAMISS (100), all readahead is
disabled, including the targeted VM_EXEC readahead [1] that requests
large folio orders for contpte mapping.

On arm64 with 64K base pages, both decrement paths are inactive:

  1. filemap_map_pages() is never called because fault_around_pages
     (65536 >> PAGE_SHIFT = 1) disables should_fault_around(), which
     requires fault_around_pages > 1. With only 1 page in the
     fault-around window, there is nothing "around" to map.

  2. do_async_mmap_readahead() never fires for exec mappings because
     exec readahead sets async_size = 0, so no PG_readahead markers
     are placed.

With no decrements, mmap_miss monotonically increases past
MMAP_LOTSAMISS after 100 page faults, disabling all subsequent
exec readahead.

Fix this by excluding VM_EXEC VMAs from the mmap_miss logic, similar
to how VM_SEQ_READ is already excluded. The exec readahead path is
targeted (one folio at the fault location, async_size=0), not
speculative prefetch, so the mmap_miss heuristic designed to throttle
wasteful speculative readahead should not apply to it.

[1] https://lore.kernel.org/all/20250430145920.3748738-6-ryan.roberts@arm.com/

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 6cd7974d4adab..7d89c6b384cc4 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3331,7 +3331,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		}
 	}
 
-	if (!(vm_flags & VM_SEQ_READ)) {
+	if (!(vm_flags & (VM_SEQ_READ | VM_EXEC))) {
 		/* Avoid banging the cache line if not needed */
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss < MMAP_LOTSAMISS * 10)
-- 
2.52.0


