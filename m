Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F2A8606A323
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 05:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CzzFQDyd
Received: by kanga.kvack.org (Postfix)
	id 8A7206B00EF; Thu, 29 Oct 2026 01:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881F36B05B1; Thu, 29 Oct 2026 01:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BBA46B05B6; Thu, 29 Oct 2026 01:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 52BA06B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 01:55:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B21B31A0279
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:55:21 +0000 (UTC)
X-FDA: 85374601242.04.9EAB741
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E0FE5140006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:55:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CzzFQDyd;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793253320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hddx7cW1nUVz3kkMDf5xox3K0/URdftdZ51g0o1y9xk=;
	b=f0SLjlXbEysFXOXkQdxx/H3pEsX0WXYFfnIDnn2Md7zscFkVo3hTKAXG3IIefpRsUx72+8
	pyyOLANHH8ImKdUUFOsUUqqmOkqxJyexzmuGBk0qIYEhjHo44HiRkWrDj03j/Jyiw1diML
	0+hZji3bAmygN+95WtZzO8I0ryZemsE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CzzFQDyd;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793253320;
	b=zIV94Vk6axs+dTWT1jOXd5NXgokhMp44Dqs4CW2DRBeq4287jGqkRImDfefWH7l+DsZAsM
	m42lvI6xfGZY1rDFCLW9uiaCN31J5XjeovPlcw5Dq+//XmWiCWz3nmx8tGvg9g22xqVFIt
	/UJazmEy2nerwcMRlFdaderRFRUHhTE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A080600DA;
	Thu, 29 Oct 2026 05:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BC21F01825;
	Thu, 29 Oct 2026 05:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793253319;
	bh=hddx7cW1nUVz3kkMDf5xox3K0/URdftdZ51g0o1y9xk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=CzzFQDydrJtAi2nM2ke5/ieg4gB6r0aQxtJggHBc49Wvn3D68/5DrhEf5hGSC7tK7
	 aNRgjcj/Sgj0ZwCermfUWR69bU+QqkajLJL75XVXc6kklaiII0Sir8NYw9rH8LLYlD
	 7x5kovjRCSppfOyZkbk27wxx43tUAitJVCv8iEyQ=
Date: Wed, 28 Oct 2026 22:55:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Salvatore Dipietro <dipiets@amazon.it>, hannes@cmpxchg.org,
 abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
 dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-xfs@vger.kernel.org, matt@readmodwrite.com,
 mhocko@suse.com, ritesh.list@gmail.com, rvvandan@amazon.com,
 stable@vger.kernel.org, surenb@google.com, vbabka@kernel.org,
 willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking
 requests reserve access
Message-Id: <20261028225517.75e13881be22461a8c94e07d@linux-foundation.org>
In-Reply-To: <20261028144148.GA14023@lst.de>
References: <arFBr22V60BMmVpl@cmpxchg.org>
	<20261027150002.318916-1-dipiets@amazon.it>
	<20261028144148.GA14023@lst.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E0FE5140006
X-Stat-Signature: wpnfgm8q9eue7xh3b7zihjfyuborfwy5
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793253319-39967
X-HE-Meta: U2FsdGVkX19w3N8mdArO+gGYDNa+1E2LiZgIv68uWPOQGOrFwZz7vu/+3JjjFs+3zTobokIuSQ6wfClCaFJOb+IX8lpkoHYRGsCwTe4WPHogeJoXVHws9jyOqetfsX2U13slX3tGVRioekxPWcuecVMCqZma41uCL0Op8U4tiue7Qba7Tdcu7/m4XijboO3cmHcvlwzM1zjTLJXQWlj1WEFty1iMdXjX/Yzhx7udLpI61Pj4KNVFx/dM+3Gi6GojOO4pzV2Tbar+8tGKiLQrSptoXy/l9ItKe+X61l62Pm3VunFYZbI8bBdnyl1j1SvJ+6iiZ//2cPEneJKHpEo5yvDnFPD/6gGihhGJByBQFCntUuvaqAb34lO4SdyJC82lotWZFtpw9ZrPCW2FUW1+NS7oGRe+ChR4mAtsJAktAEHmWtuL0KPs6AgNhWKESpL/KdnW8h+BOdgR4q5vH8wD8QBZSKy7WF3ixHXAWDirZbyfMTrbDrvYMnKy4aHtfuT62UhCu306BHjVWl1JmwvwII142ZTI+NjkJwKZtPXQUHFOnWInrzdPHELJfQhtKR4r5KNJasmrDR17TvuYR+Vc3ADyvMwd6ijzTelnRk9KdABQwjkaV4nw+t6aoicerWkcBg9rQaZq4/uwluiGQ9TpEv63+6sKx7jz4UtM0X1Bz7JRBN7/zpASgL3kHKosCegNzOPZ1VijAFRDvx4psnfwTGobBMNhMSe3eUK/+RgNhUtQxEMk3HhmAIQenP7jfSFSX3etvMkbtmr4gEGHO+Cb96Rs/QwXkdJTXfoNWvAt4cppD+eCim/E7ukL408dQ6Ca9MbM5S+7zm2WQlmBfQyeRrwtQ5M2hGVB33B/GQIU44pbYJcmaWVLDX3k2ybTzSusK7PKDbA9Qt7O/Fl3Hi7TjTaMGdj5LoTKCur7awiNaUpYSIdphRXkwGiNAWQI4GSLW1fXpcQXuTcjNJIrAXk
 wnwmJFNL
 WgRtMhroodJIJ8xdyY59LxuAlSYjfyX006gsniYbo0ouSDptQwUxOJzr5P654Wi6KldC9P7foCnwStUivdfOccrvOOejynPmeXW7LRpgPUFH+boEkpHzTMIUHDGzF1Px0tjKBn4+VOld4XACtrpw53cPVAYMzvd+I11bfnWwQDQX0ecSQ6kVrOGCwX2zvTYXhBpsKBLnsMyCNmGiqQe2hXW5jdCv14XcQwMwJFpIxztpEtM8HDb5vJNLMftARDBtoHwdc0WGOdGz/Xc6MwMrOunMggIlleRJcD/Xa/RGn1xXnBLuQoTchjVs5CcDVCDKBGBCdmS9ljLkeOnxv5G3O/PIYdbbdan0aONO3yKFVuY2Y+ekNY2r00eMmYbkfrX7qNLSYBxgGJMUzgCgCXAg/d+5Eb4WaqEZ0vfXYYwbuF4j+SB5Peo3DmyoVvsEFHOkHdwpjlY5B3e9LCRpQwbXKF9Zfsk1VPme56je3bEAv0ky7XzLeC+qZoKO9fw5fEpiKNRiJOH5JcXh67YgGdY0R5p+pizIF7av7W1NS7Gxj9fmXVcQYCwmiiC5M/+8yvLBzO9xmgwDo9TWswl2YcQ3jxFvjrOufZ9neZH+7b+I8nDPYy4ehik7VZApASh23/sPHI7ST2Kwu9BSC6b0xd+HED1f9nRA0Z9ZROUeIKWF4DYkrQ0t+QgnvivIXZI1XlEvv7YHqT6BIV7PInO7opRNq2oSvRdLDAc9IHWSK4C3/2qb8nTnnxEvKZurC/thTX6+pX3irODZ2YQ2dIEcYvKYxtWhWrST1V/gQJhX1ynHR3VNR4DOq6Tudu6raOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 15:41:48 +0100 Christoph Hellwig <hch@lst.de> wrote:

> On Tue, Oct 27, 2026 at 03:00:02PM +0000, Salvatore Dipietro wrote:
> > 
> > Hi Johannes,
> > 
> > Vlastimil asked that v6 of my page_alloc patch [1] not go to mainline
> > before these two patches land, so Andrew parked v6 at the tail of
> > mm-unstable and dropped its Cc: stable until then.
> > 
> > Are you still planning to work on 1/2 and 2/2, and if so, do you have
> > a rough ETA? Or would you rather post them as a separate series as
> > they are? If anything is needed on my side to move them forward, I'm
> > happy to help.
> > 
> > For what it's worth, I ran both stacked under v6 on v7.3-rc1 and saw
> > no performance difference on my benchmark with or without them.
> 
> It would be really important to get some fix for this into 7.3.
> We can still perfect it later.

What is "this"?  You're referring to the performance regression which
Salvatore's "mm/page_alloc: avoid direct reclaim and compaction for
costly __GFP_NORETRY allocations" addresses?

In
https://lore.kernel.org/all/9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org/
vbabka indicated that Fixes: 281dd25c1a01 is needed on that patch.  The
patch I'm sitting on (below) has Fixes: 5d8edfb900d5.  Please clarify.

In
https://lore.kernel.org/all/c6e2c1e1-a285-406e-a2b6-c09e05df91d8@kernel.org/
vbabka argued that Salvatore's "mm/page_alloc: avoid direct reclaim and
compaction for costly __GFP_NORETRY allocations" should be a 7.4 thing.

So it's all clear as mud.  Can people please clarify?

I have hannes's series "mm: page_alloc: fix reserve access for
non-blocking requests, v2" in mm-hotfixes, planned for 7.4-rcX.

Should I move Salvatore's "mm/page_alloc: avoid direct reclaim and
compaction for costly __GFP_NORETRY allocations, v6" into mm-hotfixes
also, and restore its cc:stable?

My vote: "yes" - that's a pretty obnoxious perf regression.


From: Salvatore Dipietro <dipiets@amazon.it>
Subject: mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations
Date: Thu, 1 Oct 2026 08:21:51 +0000

Commit 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
introduced high-order folio allocations in the iomap buffered write path. 
When memory is fragmented, each failed costly-order allocation enters
__alloc_pages_slowpath() which runs direct reclaim, direct compaction and
drain_all_pages(), causing a 0.38x throughput drop on PostgreSQL pgbench
(simple-update) with 1024 clients on a 96-vCPU arm64 system.

The root issue is that direct reclaim and direct compaction are too
expensive for hot allocation paths that have fallbacks to smaller
allocations.  __filemap_get_folio_mpol() already marks higher-order
allocations with __GFP_NORETRY | __GFP_NOWARN, signalling that the caller
can handle failure.  However, the page allocator still enters the full
blocking slowpath for costly orders with __GFP_NORETRY, which is
unnecessarily aggressive when the caller will simply retry at a lower
order.

For costly-order allocations with __GFP_NORETRY, clear
__GFP_DIRECT_RECLAIM at the very start of the slowpath, before
can_direct_reclaim, can_compact and the nofail checks are evaluated.  This
makes the entire slowpath treat the request as non-blocking: no direct
reclaim, no direct compaction and no drain_all_pages() IPI across every
CPU.  Reclaim and compaction move to the background instead: kswapd is
still woken for reclaim, and it wakes kcompactd for defragmentation.  The
system keeps its long-term health while the latency-critical direct
allocation path no longer stalls.

Allocations that also request __GFP_THISNODE are exempted.  That flag
pairing identifies the local-node-first THP attempt issued by
alloc_pages_mpol() (mempolicy.c), which relies on direct compaction to
form transparent huge pages.

Clearing __GFP_DIRECT_RECLAIM makes these allocations reach the
!can_direct_reclaim bailout, which since commit 4c0ed883e051
("mm/page_alloc: fix defrag_mode for non-reclaimable allocations") drops
ALLOC_NOFRAGMENT and retries instead of failing when defrag_mode is on. 
With vm.defrag_mode=1 a __GFP_NORETRY allocation could therefore succeed
by fragmenting another migratetype's pageblock.  That is the wrong trade
for a caller that has already communicated it can handle failure and has a
cheap lower-order fallback, so exclude __GFP_NORETRY from the relaxation. 
The exclusion is not restricted to costly orders: any __GFP_NORETRY caller
has said it can cope with failure, so failing is preferable to fragmenting
for all of them.

Test environment:
  Hardware:  AWS EC2 m8g.24xlarge (96 vCPU, arm64)
             12x 1TB IO2 32000 IOPS RAID0 XFS
  OS:        AL2023
  Kernel:    v7.3-rc1
  Database:  PostgreSQL 18.4
  Workload:  pgbench simple-update, 1024 clients, 96 threads, 1200s

Results (average of 3 runs, TPS):

  Config                                       Avg TPS   % vs baseline
  v7.3-rc1 baseline (vm.defrag_mode=0)          58,602               -
  v7.3-rc1 + this patch (vm.defrag_mode=0)     157,246         +168.3%
  v7.3-rc1 baseline (vm.defrag_mode=1)         109,012               -
  v7.3-rc1 + this patch (vm.defrag_mode=1)     157,778          +44.7%

Link: https://lore.kernel.org/20261001082152.2879289-1-dipiets@amazon.it
Link: https://lore.kernel.org/all/20260403193535.9970-1-dipiets@amazon.it/T/#t [v1]
Link: https://lore.kernel.org/linux-mm/20260420161404.642-1-dipiets@amazon.it/T/#u [v2]
Link: https://lore.kernel.org/all/20260710143437.12379-1-dipiets@amazon.it/T/#u [v3]
Link: https://lore.kernel.org/all/20260904115629.3993331-1-dipiets@amazon.it/T/#u [v4]
Link: https://lore.kernel.org/all/20260911142102.2294202-1-dipiets@amazon.it/T/#u [v5]
Fixes: 5d8edfb900d5 ("iomap: Copy larger chunks from userspace")
Signed-off-by: Salvatore Dipietro <dipiets@amazon.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Dave Chinner <dgc@kernel.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
Cc: Ali Saidi <alisaidi@amazon.com>
Cc: Geoff Blake <blakgeof@amazon.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <dipietro.salvatore@gmail.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: <rvvandan@amazon.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Garg, Shivank" <shivankg@amd.com>
---

 mm/page_alloc.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-direct-reclaim-and-compaction-for-costly-__gfp_noretry-allocations
+++ a/mm/page_alloc.c
@@ -4773,10 +4773,10 @@ static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
 {
-	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
-	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
-	bool nofail = gfp_mask & __GFP_NOFAIL;
 	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
+	bool can_direct_reclaim;
+	bool can_compact;
+	bool nofail;
 	struct page *page = NULL;
 	unsigned int alloc_flags;
 	unsigned long did_some_progress;
@@ -4791,6 +4791,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	bool can_retry_reserves = true;
 	unsigned long alloc_start_time = jiffies;
 
+	/*
+	 * Costly __GFP_NORETRY callers have a cheap fallback, so don't stall
+	 * them in reclaim or compaction. __GFP_THISNODE callers are exempt.
+	 */
+	if (costly_order && (gfp_mask & __GFP_NORETRY) &&
+	    !(gfp_mask & __GFP_THISNODE))
+		gfp_mask &= ~__GFP_DIRECT_RECLAIM;
+
+	can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
+	can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
+	nofail = gfp_mask & __GFP_NOFAIL;
+
 	if (unlikely(nofail)) {
 		/*
 		 * We don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
@@ -4907,8 +4919,11 @@ retry:
 		 * Reclaim/compaction cannot run, so defrag_mode's strategy
 		 * of enforcing ALLOC_NOFRAGMENT cannot be fulfilled. Allow
 		 * fallbacks rather than failing the allocation outright.
+		 * Not for __GFP_NORETRY: those have a cheap lower order
+		 * fallback, so failing beats fragmenting.
 		 */
 		if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT) &&
+		    !(gfp_mask & __GFP_NORETRY) &&
 		    (gfp_mask & __GFP_KSWAPD_RECLAIM)) {
 			alloc_flags &= ~ALLOC_NOFRAGMENT;
 			goto retry;
_


