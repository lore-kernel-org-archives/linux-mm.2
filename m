Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7358B606A32E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 10:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CxMEOkn2
Received: by kanga.kvack.org (Postfix)
	id 794686B0B37; Fri, 23 Oct 2026 06:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7457C6B0B38; Fri, 23 Oct 2026 06:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6344B6B0B39; Fri, 23 Oct 2026 06:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 291E76B0B37
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:59:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B15612038A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:59:11 +0000 (UTC)
X-FDA: 85353594102.27.02AAC44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A304D14000B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:59:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CxMEOkn2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792753149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D2r4ZfyHCaD9dgkcWlKEJHPq9+nOT0JroYVFAyy9ixA=;
	b=lOHvGNxYmm2y9LuAJxbUKd0mqCSR76z5PWxIsR35uUwE1C+1vLNSYAmQIkFMmGQuXMGCYP
	qW+7/88H/QYgKLCxO3SnGg3OMvdsxat+ztpcjIKq6XRQxUNGkM+Qz2WEwKrU8VyGHmMKCa
	n4pYo5tBwbMFFUxVNKXwMqZ7NzWX6fw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CxMEOkn2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792753149;
	b=I2kXi38LfzerYyQEy9pecG7YahQap0Yhgt9gwop/1Tx4VhlKZtPMwKINWPUiT2wFjb7rf5
	o8dZjBFOhHJAdC7fhjPa53ZHRjQy988Q8biXXzu6GR3RF7m6AWjj7/qRB9iGcFMJYmIgAc
	pt+kruAZWvJc8XmgUjIlbCHLTwW6cgU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC7EC60234;
	Fri, 23 Oct 2026 10:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925F91F01825;
	Fri, 23 Oct 2026 10:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792753148;
	bh=D2r4ZfyHCaD9dgkcWlKEJHPq9+nOT0JroYVFAyy9ixA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CxMEOkn2QmftN9/St9toBqP7XAtNuAbWcLCpgTK+PMt3x0BqCwxN28K8Ayx+vzucV
	 Pwan8wjYEC1jXvfZaCoyfaUNvZ+4cJ8bs5DxafA/pXyEq3rg+DCqvQ1MriZHOOutgG
	 9Kf1QHxbDA9Vvvp8qws2SOS+HENoV/V9SUeJA0lZforHoi2AMCHlcBl6Cq0Vn1Z7Qd
	 hNyL8NHI5RTaKrNpuZ/l/d7eBVknhC6JTl6AdHiUmLITB5r5AiesR1CMGgz1mhlSG6
	 Y+qdFdhFEBvjnbA2qGZswHYO1vsy/5JJaWJ6YqZWHwHnwcqiwsMxQM/vKlkoyyJ7WH
	 zfZZkDQZ2eFCw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9328A198003A;
	Fri, 23 Oct 2026 06:59:03 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 23 Oct 2026 06:59:06 -0400
X-ME-Sender: <xms:9z3bakz8Narhsm6NIlOE1eLTc3lHS6fMAu1_6AZRtewOW_nKdFh43w>
    <xme:9z3bah-XRVU1xBrR7GzQVzp7UFXPEudLVV90gLKTM0sWhlTQStgm9w7E_70p161xM
    MJsXroMWl4MrFrPat4Mqtl-0yjEldh-HbHsFhV8QJe0KCBEQVzLmQ>
X-ME-Received: <xmr:9z3balpzXAa4oyEb17mjDnb5bKZ7jvZrGDcxBLCOH7A5QyIVCug8pwpuqWI>
X-ME-Proxy-Cause: dmFkZTFLMZyDGD5DpP6lSiL2dELHyUp4N06Rl6Lue143rkn3tUALUBKEbbJY+IvL1iRWKq
    Z4dgEQq0FUdnRtmFyFv4zy4Gipk1NXKUpdUDUE0u6EF3hakrjkxN38+WVeBhS2nVL2lHZb
    75VM0Av6Bd/1PNVIfgaHNaJ03W0Ny7LmLqoUTHhwQErKe7pJCcHo+AEzr3Wsj9B8lzTHMo
    H8KiLgkrfoOLC114GyzOjleNKw8JHQsy/mpTRdhcs1uIYE5N5X3CZKwWn/vDlTEIiWXXM4
    nbNBQlvaL2nm5ycmEWThCY8DfEVm79j+zbIADZBneeVvw+SuWQvYX9sb9LGTljPv6Q4nIx
    OAN5J4EUxiZttFLQoN4ReJusDmlByS3MUkJ+GoqXrb6BYlbLQkAYgctOiP+WudqZKi2kzs
    Eo4cD3MQGEE/Z50zZRKMwL7XxWcv9VxDfQFeiuUNirwidXVEnXBLbZ7yVX3zHcXStdVIZM
    r1FUVwpVrYI33gyqqoUg4x4z8kpo2k5VaHGS61SrSB6iGQlWd/Y91Jf8HHNken5LZIRP3w
    6xpHLEmTPGugU0ByEbVDg8ZcFjySOg1HetrgTM3cvT2FlXuirxYtC3QDsxVZjMbT/IfO2a
    KgfQ7u0Cc+SWIBp1jfS+7nLgADrnnEwsFg+B5Fmf7CcbKpIDbVoFX17sbdlg
X-ME-Proxy: <xmx:9z3baqkX-TfdGYOgfoTmSRdNqnO2J_kmsxDMDdF9VU4Tm7zxj4qFmw>
    <xmx:9z3baqY95VpbZt8w-QSYTPgo3eFDr7etRJs1xLepJxbuRSjxahw6Aw>
    <xmx:9z3bavsHAA-TFsQz13dPgtWTDmrCGc3FoJ5NHTb5RX8Sm9X002CyOA>
    <xmx:9z3bajpFZoxPX6SsvI8uBTyjgv8nBtH-4xkm58Ok9I6KYHWnCZDgnQ>
    <xmx:9z3bapmrYkD4lXGoqMsluOX2WMGITXGxk5jDLk_w9sg3xDmZVxEybPgG>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 23 Oct 2026 06:59:02 -0400 (EDT)
Date: Fri, 23 Oct 2026 11:59:01 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-ID: <ats7oFM-fsYdUS8y@thinkstation>
References: <20261009125503.126202-1-kas@kernel.org>
 <15a9e03e-c748-4e51-b8cc-583a3610c897@kernel.org>
 <20261012192834.6934ef85444dee4a60d6d876@linux-foundation.org>
 <as5q14OsbK2CmOrh@thinkstation>
 <20261014202936.GC371161@cmpxchg.org>
 <78238103-3a7f-432c-b1df-bd14d7cf4bb1@kernel.org>
 <atDMN5MoGrwJNpAj@thinkstation>
 <4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com>
 <atiCG2iPrHwDznSZ@thinkstation>
 <d2b8edf0-39ab-4a44-bd0d-58230dee2fad@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2b8edf0-39ab-4a44-bd0d-58230dee2fad@arm.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A304D14000B
X-Stat-Signature: sjdmafd3oz8xquxwxy7amigwat6se4f4
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792753149-431381
X-HE-Meta: U2FsdGVkX19TvsZkR3g3nEA41P/f3IJNmwXJS5/hBXjh2y72lJPSgcgeKRvKlrQuOnA7LJ8vzxorRbaYV0+QSWQ2y34B1ZJnWF383Ai/O36inbMsYUSMNA0lllNa4FEqfXaIEoDYu+IW43upf40tUNHzoQIXRixNpUVnXrLXEDPkERSufHuxXpiUN4fhzCl0NNjEn+knweOuecpzwngBtVF71DKJS8yce7l0Xjvf+vxz6tJ640TRt+u3nScdJQYXWSRRYt+6vo9mSJnbM/YpFCIWxBl/sIroLLSAaatPI/FvteyNanC+t21Bl4hQHA1noiOWSOJIW1ThvikOhrqE7w9i+RYwUG6FGzgKrfag+GHlc/ce+C7PSZVsH9t+Ma9pNHyFOk5UFa6yE8hQnSA2me4o2eSxwjt3Rb+Xo0+LaAtc8fDLgX0SiEzP+iIIeM0CM2lr551w1cRx0m+5zE/Qf1zSy5ZYHnL5kL/GfAfBQFJCAMNjXWiIN0S00WaleohBJHy1BmRxAI3zdmlwVh1hgc0Lje4NXVtz/Mp5yFZ379L+y4S85l5/xw26EWBNFB60MBhETVnExu5tiFE8QV5jiwMKvH1qHbWUaIba1np6PWgydhceTp8rbLv7M1jx8X2anN8aT6fArJpCdoVC5gumliQwGMRpkXj3B5F3qZNrU4njRBO3ZCNGQYW77IShG8aTKMKTt5cIsll4+60mnh1XVKCW0o3ZR6+GNQtnrtq7tiu5mdaq4LvU8sf7aSM1sANq6E3pUxs9MR3UGjP17mfJh5yL0QZOftthW+jp3WoWlhL0dunScbuGsrGNUU5upgRt0hLQ4Qd0e7P5EfjOviZKUMW3tiE6v3cVjTGjEFBs+XTX6dj+8nFSnFNHooNmqMaaBjbh4Oyp4xqmSdm1xuUW6tOWE8wR7wLE/vg4NhgGFBllunHmJGlduasiaAJaw2kAu8X2q+DSDg3bvP7/z6+
 Pa+Ukst1
 dbCddemianIDGub4BIZb4ZfrR0GbYAVITQ1oallwLnocDOJ+46ngIMsU/azt9zSYezfmmRSjg4VDcNyRlgNfJbOx66v6+j6a/jUYzoHW9SZ1XQozP4SoHPfQVp9ogYQZ68rT5xTVfDRW/NM7dvi52ONiqnd+oZ/GKdwlg86lqHR3VibjinIrVQUb+MdKnCooCzLyqinw4bWyzjeoREa+aYrhpW2Qvv7BQAD7IfZdl9yH/yAUGL9+feNfDW85icAMRCMlBuy97a77lb6xM11/7CV2VNBgUzEZD4iNys/bv3m1BVB3VzkSoQ9Csj62izjAiX/OlBszU35GHG68=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 12:09:07PM +0530, Dev Jain wrote:
> >> I ran a synthetic benchmark faulting in lots of 64k mTHP with swap enabled,
> >> defrag mode caused me to enter a warn_alloc (and 8 times more compact_stalls),
> >> which didn't happen without defrag.

Thanks for the benchmark. It reproduces on x86 in the same shape.

I think I found the problem.

Under pressure, the free order-4+ pages left are mostly in partly used
unmovable and reclaimable pageblocks. A movable request with
ALLOC_NOFRAGMENT cannot take them. But compaction_suit_allocation_order()
asks __zone_watermark_ok(), which counts free pages of every
migratetype, and returns COMPACT_SUCCESS without compacting anything.
The allocation then fails, and since compaction "succeeded", it is never
deferred.

With the diff below, compaction behaves the same with and without
defrag_mode. Medians of 15 runs of "compact-bench 99 64 16 20 0":

                             defrag_mode=0  defrag_mode=1  defrag_mode=1
                                                           + diff
    compact_stall                    2135          32476          2290
    compact_fail                      668          32330           606
    64K anon_fault_alloc            20689           6780         11804
    64K anon_fault_fallback           776          14502          9687

64K allocation is still lower with defrag_mode. I will look into this
further.

Could you try the diff on your setup?

diff --git a/mm/compaction.c b/mm/compaction.c
index a049415512c6..09be677fff36 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2365,6 +2365,10 @@ static enum compact_result __compact_finished(struct compact_control *cc)
 			!free_area_empty(area, MIGRATE_CMA))
 			return COMPACT_SUCCESS;
 #endif
+		/* Under ALLOC_NOFRAGMENT it may only claim a whole block */
+		if ((cc->alloc_flags & ALLOC_NOFRAGMENT) && order < pageblock_order)
+			continue;
+
 		/*
 		 * Job done if allocation would steal freepages from
 		 * other migratetype buddy lists.
@@ -2510,6 +2514,43 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 	return false;
 }
 
+/*
+ * The watermark check counts free pages of every migratetype.  Under
+ * ALLOC_NOFRAGMENT, a request below pageblock_order cannot take a page from a
+ * block of another migratetype unless it claims the whole block, so look for
+ * a free page the request can actually use.
+ */
+static bool compaction_free_page_usable(struct zone *zone, unsigned int order,
+					int migratetype, unsigned int alloc_flags)
+{
+	unsigned int o;
+	int mt;
+
+	if (!(alloc_flags & ALLOC_NOFRAGMENT) || order >= pageblock_order)
+		return true;
+
+	for (o = order; o < NR_PAGE_ORDERS; o++) {
+		struct free_area *area = &zone->free_area[o];
+
+		if (!free_area_empty(area, migratetype))
+			return true;
+#ifdef CONFIG_CMA
+		if ((alloc_flags & ALLOC_CMA) &&
+		    !free_area_empty(area, MIGRATE_CMA))
+			return true;
+#endif
+		/* From pageblock_order up, a free block can be claimed */
+		if (o < pageblock_order)
+			continue;
+		for (mt = 0; mt < MIGRATE_PCPTYPES; mt++) {
+			if (!free_area_empty(area, mt))
+				return true;
+		}
+	}
+
+	return false;
+}
+
 /*
  * Should we do compaction for target allocation order.
  * Return COMPACT_SUCCESS if allocation for target order can be already
@@ -2520,7 +2561,7 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 static enum compact_result
 compaction_suit_allocation_order(struct zone *zone, unsigned int order,
 				 int highest_zoneidx, unsigned int alloc_flags,
-				 bool async, bool kcompactd)
+				 int migratetype, bool async, bool kcompactd)
 {
 	unsigned long free_pages;
 	unsigned long watermark;
@@ -2532,7 +2573,8 @@ compaction_suit_allocation_order(struct zone *zone, unsigned int order,
 
 	watermark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
 	if (__zone_watermark_ok(zone, order, watermark, highest_zoneidx,
-				alloc_flags, free_pages))
+				alloc_flags, free_pages) &&
+	    compaction_free_page_usable(zone, order, migratetype, alloc_flags))
 		return COMPACT_SUCCESS;
 
 	/*
@@ -2588,6 +2630,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 		ret = compaction_suit_allocation_order(cc->zone, cc->order,
 						       cc->highest_zoneidx,
 						       cc->alloc_flags,
+						       cc->migratetype,
 						       cc->mode == MIGRATE_ASYNC,
 						       !cc->direct_compaction);
 		if (ret != COMPACT_CONTINUE)
@@ -3073,7 +3116,7 @@ static bool kcompactd_node_suitable(pg_data_t *pgdat)
 		ret = compaction_suit_allocation_order(zone,
 				pgdat->kcompactd_max_order,
 				highest_zoneidx, alloc_flags,
-				false, true);
+				MIGRATE_MOVABLE, false, true);
 		if (ret == COMPACT_CONTINUE)
 			return true;
 	}
@@ -3116,7 +3159,7 @@ static void kcompactd_do_work(pg_data_t *pgdat)
 
 		ret = compaction_suit_allocation_order(zone,
 				cc.order, zoneid, cc.alloc_flags,
-				false, true);
+				MIGRATE_MOVABLE, false, true);
 		if (ret != COMPACT_CONTINUE)
 			continue;
 
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

