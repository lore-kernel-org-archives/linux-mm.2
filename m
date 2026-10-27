Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55D9E60A5BC5
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D3Of6IeD
Received: by kanga.kvack.org (Postfix)
	id 135AE6B07D1; Tue, 27 Oct 2026 11:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6786B07D3; Tue, 27 Oct 2026 11:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC94D6B07D4; Tue, 27 Oct 2026 11:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B928C6B07D1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:46:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9ED1C021F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:54 +0000 (UTC)
X-FDA: 85368834348.20.1E843D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 262AE180008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D3Of6IeD;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JvUszYBU/N7jUawur+/6LzByWky1OpFKDF6ZGnWFJlw=;
	b=NnDi/jXPSiGhBYxo+e3Dek0FGSiqouT2/OhXqF/Rk8N1xw5q8ejQ1C+/VjZtv0OqP9TeWB
	fae2zJ6xC/ro85A8QJlohhy0Sr2AqdtbNMaJTb67fwP9xzKkbG6KnWMOOBNG33efCaMVYs
	ECLQpnvRJc8/WtXkgswweQTpcf8XiPQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116013;
	b=F2aDDbtEX8yY/N8Y1lBcii7e9kFWn6sPdCH9PG8Etc68uOD+NUxWQNwDwyflBE8E01zXK8
	7CORLcPTfenU5B3BneIrHyKCiwdayUqFsHH9H6Hsw0zJIghNRTIMU3IAEZkXxtZRdnVKcW
	7HwtALwKgl2HzytVkOymnRivWdGh2Oc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D3Of6IeD;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 803D8444F2;
	Tue, 27 Oct 2026 15:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF9E1F01828;
	Tue, 27 Oct 2026 15:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793116012;
	bh=JvUszYBU/N7jUawur+/6LzByWky1OpFKDF6ZGnWFJlw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=D3Of6IeD944gEsByi1tbI5kVhZhWbjXQlclLubW2T1BCFomUIgZ3LiHyJdVbW4wiQ
	 mAtsKV8es4WuDsxvE+ZuAtQk2qfD61e0q0AYJUylBM09jV/Eaq9b3UDwxSJ0gOeQQR
	 dAqu98gTBNqbQQTVPUpR91e5mFj047yif4/mbU0+aLm61mTti9/N4ChkEaQMnn16sY
	 2ug5VoUaUGE0SFNSt3ZwMg1XhXVuZ4sOMacqIx1V4N+Ma6LVErvFQNKSDSgf7Sfyhz
	 zYBUmfrIK6ZJOrukO5VHUz5esNzs1UuAbpYLUiT015rOonxPmM01Bts1KWSeEzwdr7
	 10E8xzbi4qH6A==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 27 Oct 2026 16:46:31 +0100
Subject: [PATCH 5/9] mm, page_alloc: pass zone pointer to
 trace_reclaim_retry_zone
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-pgalloc-ai-hotfixes-v1-5-9c7d1aca801e@kernel.org>
References: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
In-Reply-To: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 262AE180008
X-Stat-Signature: fxrao5eyw79ixezt5g5cu7oofccbprkf
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793116013-379741
X-HE-Meta: U2FsdGVkX1+fRmvhOy9bTBS/YjA6Qe/e+AAkwJYjvds9ML5UFwG4LP6jrJsFaSjSwrseVg96IdkhLTnV5mJ14FC1jch+qrkW3ZPp8e8rKcuwcvIYgFMdXcduFpMUWYgoGVBOYSfUi0qe0i0qMPkclOpgnyjoE3ztV3Tl2kO0CCoSNXOwm7s6NxZ1Ce27iIkavK2KTsu49jp9xNdGF/peUrCatNvctUCg98N1xpOEpGNwwaeM8FtTbqJu9uuhC/1jwF3W5tRPGnDk8dLvbypc7t71ReoHServEmvybh3V+S6zvPAs1xPb3EEaxHDLA0ejD2ngnyrvXdeqD/FjIA7dAsTf55Z9YESkt7/dVRgVBFI6JpOs4tDOGAcrUgBrMuo41pMCSde97BZYp9LPXbCI/Eiran6ZiHFMtU/FxOKD/15xrVhYGQAzTyaEnaoxplijej7nkgf3hm1b9vDW8TGBE4V3/Fh2q0yofTfNjuJopFe5qAFWE486OtjrWbRgqA4sTHR0D8VmHMR6D2rdTDszIuTE3pPyGdCnhPv6GyIwlkGOW/UwpX/3MzQvlI0Vp6MHOdnTWYII2f579+IXc6RX4j9LqBuxWlDpLvyQUIMHc65w0Bj8pZln575h9B4jCLIwJ3R8/LnpDhdFFIGKxtpuIPIytkuyZr5nRT/qx3m9V/1wBA+3faPptQJnY3Qz/4Bhgznaj2Ij1FngN7M9AbhuhNEpfYqOSae2O8Fgt6DFIqbTTuC4M1c89DUHddwZT8diTntjMcnRjs6r7yykb21FyXV/7vL/6rIcZ3H9eyN+aD8A9ueSQkFLWaKFYI9a9sPBcaX80emhakfJGBxY0DXKq8EKjqsM2AKYMnuArIrRjn7EyP8CNG1SgMAWlRPhbFstAOtUeCmMTx8easNqc7ytCv7bMTidK9BfrZcMLOQO5+rI7a9Vni2lPn0pJcarpufVo0UpyQSQSspI77CvLRZ
 /yjw6otY
 QFY/nIycJLaAiWFY/yrymx+vrP0o4j1QRIu67mBsym/HJMcxXhmcx6nZXAROjmPWRmWCYgMGNwFlqYUu1rX0lmh8Q6/L1ttw3u7LZNSTNE7Wsw6XcScrine8xSkDN2bUxjjLytlnAmMvDybxinjJ2SDqSTNRUWYknlfTHDJxPV0b+n8Foyd9/plXfpgrWkcKEu2x1QF+Tn1j/ZFh0p2m4SIN6kma55VXYsrWykE0OAgcDfWF7WyZBz8wOUkA3w+87szUVHr0gau7NP44TBUaOo8Cavcvp3rRG0GQ+rq6sGAuScem7T4lAJiiXMEirZUV1CeVu7XCG7/1Rd6c5yBs790kBjT0l+jHrE25e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

should_reclaim_retry() walks a zonelist and passes the zoneref pointer
to the reclaim_retry_zone tracepoint, which loads the zone from the
entry again to find the node.

Memory hotplug rebuilds the zonelists in place while allocations are
under way. When a zone in front of the zoneref entry has become empty,
the entries move up, and this one can be the end marker by the time the
tracepoint looks at it. zonelist_node_idx() then dereferences a NULL
zone. Short of that, the event can name another zone than the one its
numbers belong to.

Pass the zone pointer instead of the zoneref pointer.

Fixes: d379f01de095 ("oom, trace: add oom detection tracepoints")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/trace/events/oom.h | 8 ++++----
 mm/page_alloc.c            | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/oom.h b/include/trace/events/oom.h
index 9f0a5d1482c4..cbcf6fe4cc61 100644
--- a/include/trace/events/oom.h
+++ b/include/trace/events/oom.h
@@ -33,7 +33,7 @@ TRACE_EVENT(oom_score_adj_update,
 
 TRACE_EVENT(reclaim_retry_zone,
 
-	TP_PROTO(struct zoneref *zoneref,
+	TP_PROTO(struct zone *zone,
 		int order,
 		unsigned long reclaimable,
 		unsigned long available,
@@ -41,7 +41,7 @@ TRACE_EVENT(reclaim_retry_zone,
 		int no_progress_loops,
 		bool wmark_check),
 
-	TP_ARGS(zoneref, order, reclaimable, available, min_wmark, no_progress_loops, wmark_check),
+	TP_ARGS(zone, order, reclaimable, available, min_wmark, no_progress_loops, wmark_check),
 
 	TP_STRUCT__entry(
 		__field(	int, node)
@@ -55,8 +55,8 @@ TRACE_EVENT(reclaim_retry_zone,
 	),
 
 	TP_fast_assign(
-		__entry->node = zonelist_node_idx(zoneref);
-		__entry->zone_idx = zonelist_zone_idx(zoneref);
+		__entry->node = zone_to_nid(zone);
+		__entry->zone_idx = zone_idx(zone);
 		__entry->order = order;
 		__entry->reclaimable = reclaimable;
 		__entry->available = available;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 13211b8caada..8f8885165045 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4675,7 +4675,7 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 		 */
 		wmark = __zone_watermark_ok(zone, order, min_wmark,
 				ac->highest_zoneidx, alloc_flags, available);
-		trace_reclaim_retry_zone(z, order, reclaimable,
+		trace_reclaim_retry_zone(zone, order, reclaimable,
 				available, min_wmark, *no_progress_loops, wmark);
 		if (wmark) {
 			ret = true;

-- 
2.56.0


