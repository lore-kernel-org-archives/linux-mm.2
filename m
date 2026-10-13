Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB016CA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 02:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27DA26B0088; Mon, 12 Oct 2026 22:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22EC36B0095; Mon, 12 Oct 2026 22:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 145766B0096; Mon, 12 Oct 2026 22:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E41D26B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 22:23:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 537A5160A44
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:23:33 +0000 (UTC)
X-FDA: 85316006706.18.C96867B
Received: from mta0.migadu.com (out-120.mta0.migadu.com [91.218.175.120])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1E94320002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:23:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sth5oaSX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.120 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791858211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j8XhnfP648Cz+O6ovodx+xAGkNaGD2llakJPnafX4TA=;
	b=4LdV8Jdq4o+AID45eRXyn1byoCUjAkhQ/Qe2gRxlaGaKLIOxHZWuH79LqoWO3usUqdRMYt
	9iFJuhJn3lLql3M1eYx+u8MwWjV2ujrPCCzma3oIR0VsiyYCIuhHvR6rOc3V+Fp7uEhTU/
	fZfDgW2M69vrKhrUahIGkVGKkVDxFiM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sth5oaSX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.120 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791858211;
	b=ctzs9fro0GQJeCp12i4hvc1XvttlK96/r+8wTKb/puWs4imrojjYwEcy7RjxAoFrkWX7if
	CXq21m+NhO0bJavYW8Kv4s6ow7mIg2XU6V4ZPeCjgY+r85Zf3bYQLr+Ldcg1XJlEmWvA5k
	FVav9tbF/a3PgOJwCGqZAQ2AwFWdwPg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wCnL6viEy1CesNNIWQQHyBFJylxrQHFF/Yc3GsIfI3M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791858209; v=1; x=1792463009;
 b=sth5oaSXVmazhbqjMSm9UreItIu7BqfmBHDx3GkxkSOr2A2T6L7KwtBHUW0WLaBq2sQ9efAH
 HznDHucugTQ+K43NcNThdrwVa8LD3m8o78pjyOlQo2yFnjVQ0H8G7dEBK1xPn0h44ta4QG0OPXI
 lk3PosVQwvW+cMpjqXLIUdzg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c5dacfae51997a19;
	Tue, 13 Oct 2026 02:23:29 +0000
X-Mizu-Trace-ID: c5dacfae51997a19
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] iommu/sva: Charge IOPF allocations to the faulting mm's
 memcg
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261012200823.699316-1-peizheliu@utexas.edu>
Date: Tue, 13 Oct 2026 10:23:14 +0800
Cc: Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Jean-Philippe Brucker <jpb@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 iommu@lists.linux.dev,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <38FAA6E2-15C2-4C1A-9E3F-3F0B079A9D08@linux.dev>
References: <20261012200823.699316-1-peizheliu@utexas.edu>
To: Peizhe Liu <peizheliu@utexas.edu>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 1E94320002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: hhgq377kbew5d9pejyf3h7inbrhcczkx
X-HE-Tag: 1791858210-588580
X-HE-Meta: U2FsdGVkX19VSyrTwHWH8d7aYwQKwJD00GCvPtWWzPbFcouGZ5eRkNd7UovVN7mg0lvD2+EVYfOCIJzdoz+E0pGMJi3xRfNslPTfKQResBx0vbhTcX9NY2jtj10FRwWZFzSeCGLfGcTO90JbizGhaqDcsyoSelrBlZy6lB62mRRE17NvndWHE9yFNP6M3adyEOLmThf86wkT9qUfNnTY+5wiG5hmr+tdQe9m8xtZgVM5OYdWUYiYhAG1CnSYIdjRxV7/O5s0dqnLPHtPrWPME+g/5culw8tVdoKVNbLwn6Y+otEHprnFqM6k2wGfOx3YcIxbrUp7urgHYWcdF1sshs09p9UrYK99BGmKGznvMwqg+Sc7GsM2nEDsqOekNrdq3mEM7iMLmOOgkRfjpX4xDevrfVZM3qKtWNiaLoAQtYkgDdDKhhjcUVD1Oqj8jxcavCnXJ2YDUJpWPCiUrNz7GbV1wQ01U0/AepjWXAUZGIPWuRQZnmpchN/xcmbxtGJoGcEyx3cRcSo84autiFUwoBJLW2xDjPlv4k7nFfAr5OCALYErVDKBo8novMISwC8FselwiGfX6kZHv7j2WqLCQF54LivGbbdn0DrHr7cTimBajPs4u6ndpsiHWNCTdbD6ksGZzTBU2oBGu8C7P3HLEbIrB+Kg8ps1+nVlM0pxYuFs+WbadQEj97Pm/XRJ2KD1CYyKw+Q65sHqgVwjP6tVCBFCT5r3N1asex1fhYcNLqy+/ELnIFkqC1MzxcVkj52Fevvaz+v+9vrccj2CTqyJyy+hFORQZMT+cjZGjRtgzQCx8GQzH3ydl969HWCxRkHx3P89i8zBjJwxVOg6ubDwqXbkhp1CT1mrt6ZfXRdYJ4U+s5VejJRxjna1g06FHI8Hv0wUyI4bLFMWJizwl9hiaI9UgAl4RtELkKDKPgQOv5sBTaBVR9AX++IpyxUr4jv+iuBXhs1Gzj14QT1jk2X
 xfaxvKIh
 0MVhMJ7s4TNoG0fWTAqicncX2jyh7eaRAtTFJv6xn0yNk9mQ2M12Mc9IOH1z+244L7AP89F0dFLJDnW+yC8Vv9xVjv0Ys0tTamVR+tK86G2RfmU7z/9YYhyGjEjh9JqIriqwU1su9ZZ4OSWAnMHZySAX4Zi7/htJqLu/IQkIwjOxdWqseivPxbOaAANGX04lATABLWO7Mq4FVHBwQHtaVrUmtzT1uxiNy/LBIUszaOsJxtdcVfPLbnEXnR7HX8KdLUud4fk+4yEevyWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 13, 2026, at 04:08, Peizhe Liu <peizheliu@utexas.edu> wrote:
> 
> iommu_sva_handle_mm() runs from the IOPF workqueue and calls
> handle_mm_fault() for the faulting mm, but does not set the active
> memcg. File-backed faults can allocate page cache through
> mem_cgroup_charge(folio, NULL, gfp), which falls back to the root memcg
> when the worker has neither an active memcg nor a current->mm. Page
> cache faulted in by a device is therefore charged to root and escapes
> the task's memory.max.
> 
> Set the active memcg to the one associated with the faulting mm while
> handling the fault, and restore the previous value afterwards.
> 
> Fixes: fc36479db74e ("iommu: Add a page fault handler")
> Signed-off-by: Peizhe Liu <peizheliu@utexas.edu>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


