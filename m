Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D40A7D6AAEC
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BEB96B0089; Thu,  2 Apr 2026 14:13:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 396226B008A; Thu,  2 Apr 2026 14:13:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3396B008C; Thu,  2 Apr 2026 14:13:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2161F6B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:13:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BEAA513BB3F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:13:48 +0000 (UTC)
X-FDA: 84614414136.04.50C2848
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1C3658000A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:13:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jBVlATxq;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775153627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYo+MsU3NDEL+koHfyTJu1xHHS5mV0CFXLaMn8ZezZo=;
	b=pugN+J4dsXCktm1zIGIW0CD+7XmSP/V2nKoqz4Qn1Y9hZVmr9i5Us/7Fo4tYQmErWRoG4l
	zYUXvJOdEnt7IiO3rUal8Rg/IseCfc+sExBTsswuesFle2LE4P1gehSaPG0lqrr7jt4+xU
	uxZegYce000OFKNJhfcCwV+KD2Vpp48=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jBVlATxq;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775153627; a=rsa-sha256;
	cv=none;
	b=FVRGuWEFLMX2EWv3FaoBiIiaeXtwjnYv3+QEGvogpdQTsHyz/HUPjcj61r9M1M7sMaki7/
	NISJ6VWyVd5W5ONgfKkpLhT/pfHCP+pV9Ag9GmBpb/GC5sgqz+HwWzEX8fZvviMq9OYAZU
	sHTb58bcAxSeQTIc9mjawiCIOVUkLaE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775153624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BYo+MsU3NDEL+koHfyTJu1xHHS5mV0CFXLaMn8ZezZo=;
	b=jBVlATxqIYgZfj3KHFj3T3aVBW1J8ZhMacXVtFHk4eHh5FwgyqeygxWtikdiA+B1T7VuFg
	v/zAHoBUYT/h+us80bWmoIGHjJz8uEo/Um3mzOQJ7+5N9tE4RDgdtwmMVvyXBJ/TJ40i0J
	828uNtru0sPYXV9jPylnQLnOE7M8Y8c=
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
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	wilts.infradead.org@kvack.org,
	"linux-fsdevel@vger.kernel.l"@kernel.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	leitao@debian.org, kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 1/4] mm: bypass mmap_miss heuristic for VM_EXEC readahead
Date: Thu,  2 Apr 2026 11:08:22 -0700
Message-ID: <20260402181326.3107102-2-usama.arif@linux.dev>
In-Reply-To: <20260402181326.3107102-1-usama.arif@linux.dev>
References: <20260402181326.3107102-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1C3658000A
X-Stat-Signature: 45ykxm1yciypt97jxpgckonkmoj3eexn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775153626-248830
X-HE-Meta: U2FsdGVkX18o0kH1uJyXKy8lS9/JVJKFxkJk95UhfHiCvWxVZDD+Awc9AnsPBKZq8VP6cAs3Ywsrg6kPa1mfwqZWKdvNuGPChb5q0zHTV60bUofRREizlFkq1dogkJp47IF3CvtBr5p1DgoST8BIQODfZICpAt6sPXGrKf8cLQdkWIFwkEtpgiM7Jenahhj0g8TqckiBQN2SU5WCWPgVG1+d7f0MZl1I3skqoJkKIUx7x5Q+EnsuIpxqG0fsj6hf5rTPxxiQrlOG9bK803TVpjtST/gd/1k6rNZN8qLp0vyLdCAGYp1KnDNS8OP/7aCgL0SCl64ZjUV6gF203Y7omCyYAS4uKeo68lu6aBV43+YHd+vSO2tOaHtpKe5Iub6PVRObLdKPv4RzKgAs6WJDXfePCHeZ/iZk0OiFnN4/eFTNqXEqfnakAQSZBgRLvC+pTlGZJzzZoN9670d5ybmfqdRiBVuwT9UnJlAiY2N0U2qXqMQTK4vsxF4aOQSWtAsCFE+0x09mLon+Y3UxGqQRGU0RKI88C0LKH9yNNHM/QEgEkMqgP4S7epu8ClOBmQ+bu7Z11u1HWXYAOXKUMnJBlpcw+s1dgpgP+SXYI5sPZoLoMYQTV5tmqdVrWfBR9ADpLKa8qgg/+8ZveUfv81ak6lkuyFyyFbvOb6jpOq3hZzTk98qklLoPziXOdGHc2kMufUZvDVtOHv37FJrHTmt+g4qIQ5iRGL8qyAzMmzFiVEfXqEn1IVznW69u6/XWZ5r7XPKWEVTNNC+g2wj/0FJvgon55CzMSkVDKx46nV1+ShkdSsSPM4+9Sb2hfTtp4kQc7NrFX7czwIcT/39ryoDUYd07EqbJ8BZ24wM3fAYfrhvII7MjPjNhunF+1a+C7Otxd7TA+n69qn1yZiGWz+4aBPLmDXHmzV8WYsCPCGcKM5nrc9gkrFmKqsxjjMD72mcLrKY9xEUTimCTxVZlbjS
 HVGoZRke
 AaEi6y9QYZhhlxDnAxweCmxv2t4R5PryhJ5I7euqcunip9L3Z1fTkkKE0JB7/q2Er/WID7eEQYQQkmDjosVyigcgnO8ZrcV+0n7l7K0iCch6oUhNOSCScUIfMgaRT2S0K8W6UXljc93x8g144QhDuSqz2LfrsHja6hIidrtxp5wxSHQmpi3PYXlvq3u0fBnAzXiHuwDox8s5E8ynYltDhvFlxfsc9nJ/yHB42loptot5Ge6yPlC9z8L2/lHoRGCadw2jdUQ6sIvKkPQy2COVdzr2HmNtPVRJyZwbhpAxH+lQn0H0fh9XQO6lyet/NMgiUeov93u61KJtwR54=
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
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 2b933a1da9bd..a4ea869b2ca1 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3337,7 +3337,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		}
 	}
 
-	if (!(vm_flags & VM_SEQ_READ)) {
+	if (!(vm_flags & (VM_SEQ_READ | VM_EXEC))) {
 		/* Avoid banging the cache line if not needed */
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss < MMAP_LOTSAMISS * 10)
-- 
2.52.0


