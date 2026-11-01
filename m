Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 406AB606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 02:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=QHh1s9/W
Received: by kanga.kvack.org (Postfix)
	id 1E9966B05BB; Sat, 31 Oct 2026 22:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1326B05BC; Sat, 31 Oct 2026 22:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B0216B05BD; Sat, 31 Oct 2026 22:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC7AA6B05BB
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:14:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 485051608A5
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:14:05 +0000 (UTC)
X-FDA: 85384930050.05.E573F8E
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id 811E8100007
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:14:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="QHh1s9/W";
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793499243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3en/0J1kDOWu6/ZYZuTg1hfkkAOyFwxacReoQ2bAwQ=;
	b=bgctwKyowxUkVzA00kD0yvpceSswr+hdVAIE7X7Xv3lkgjhIz000/bZfjL4vSdxkqR1rKx
	kZbzne6ByR0Og/TRjkVImMHtxSKdJw6sl0174DQ8NAK3EmkG06iiXqjW/Eh9E+nb5Hj545
	h4IdSeNZz60JyLoMrYFKXjpE6obhO+Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793499243;
	b=xK9BnKsu4lWl3971pEd5ugzAJeNM2ItgGQkhE4DOGqefFIZT04ybWuyP7IZLOdmzTJJqd/
	RqL0wIEdGq3aL8VZfWVjm/B+dwOBRPyyLyJmj0K/F1SGO8yee0tvv/hjrWQu+7tBfVpX4j
	Inppy/gP1HS5yDuTO9hKnzR0C+/hbZg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="QHh1s9/W";
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93f20b304c0so182783485a.3
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793499243; x=1794104043; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o3en/0J1kDOWu6/ZYZuTg1hfkkAOyFwxacReoQ2bAwQ=;
        b=QHh1s9/WBBX1JBpOWySlCT5Sb9bDVji3bDv/4+wQDX06C3uNY4yyApJ4/66ZJRGH85
         uHKFWyh9tRF76VrxR6ZNHnRFWVL8I+IanLo9MBlUTlzT3urisPp2oXMelNqWx14iunya
         YKjVTNDhu5e5N5YrLQh0PUEgrlP92zlIZG8wVgRseKGaTVVKyG9TZ7ZjXq03knMn5i+o
         pB3pIC8WxtPbSCQEF1O069S3vidLJJx4/Pxhp/7/sqexsNSwnYeZPCr5zGYcDgRWCqRa
         Xr556WllqmpuyBJhg+qBBmEqJoGSv8qnavePdGkA3sHJtqMpqwOHRSIdTjEZYhiIIrPi
         1jfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793499243; x=1794104043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o3en/0J1kDOWu6/ZYZuTg1hfkkAOyFwxacReoQ2bAwQ=;
        b=G5/lLJHGcsMsd3Q53R+WGrQpx2hUZRMgJvGdCEovTKyikdXLXfdMHB2TJW6r0fcX55
         X9KKBrhDzeGuc/5m9XcaZCT2Fxwsmml0GpybTsAntiCJ1o0/O8DTgQDLohbH1wBq+M3H
         Qdooncsfn8XqAlGbJcUQh0v/1m6woe4MPj437/VHiyU3namfaTsT0ITLNh+NNXueI9Nn
         jwce+5IUGkS9WlRbc/a1QZK5YWVq26mxGapFutx4i31lFEWE1t2/dzAxVKhQJSmDDl1t
         rjH/k9X/pFn8iOXkJ96l8VDUhTZLjnHAAP30Dn1MtlYxfTC1Oreh3kSCk1pY6eDXG4F3
         pyZQ==
X-Gm-Message-State: AFq9FYLOd8ChAfB1joWAZkG4tSRCHNSGNc+lAm1v+Su0pea+QP6UcQLJ
	zcYAVNm9SaEbHQN1WsogrDu9WtJH4F37BDr/buKq4SBvk3FxolGOzzTiynpSWjUZFyulP3reakW
	hDYAL
X-Gm-Gg: AYBFou3LqSduOu41pHf4FFuWmMo//O2+GssfPC67Z5LRr5dSOQX951NgpwyBa1EdZSg
	5huLuV3nuBrl6TZXChG85XJIr+hLrMSIpmiyp27qKHh2dUC0wyrsC9ogBdwhn5h6IWQ1VMR3z6U
	8s+EYxoGxfg+6FEmrFJ4FaInRcCrvPMx3ysAIeuJfxDxhclmJRL7hwAxQT56aHFkL/mAyxk+o1p
	1banqbTtuBPQn8jFD4TeaA+LOgisVYblv7irEy9JwGrFSn2B9wqiz+Joleh1JEcEzznDbWAHLMk
	lekvRDeU+IDoxYTCHSd0P/mRoqQOkkaqVwteSyOQ6ZFdIAPk52/xlCyHDcbmF2Fvf3nbDfMfeUf
	hLk2CBjbuaktSiIKG66+AQguNGSVIVk2el/Q+1QvN3S18K7vIV5pPXHtwG0Jci3hLsxEjhjAw4g
	7ca8oUfqXwwYvnekQqQ7uKoCJ2UMiIVcubShrbw7W0r7tuKr9os69o7Osg0vIhjNZe1EeRgWxzN
	XR9k4JyrXpFnFLyEjoMoufU591df/Tzam4tRRjoPELrLDH7kIRhskmesOASAwGSs24uU3M//J7C
	IvpkxMu07is7KrUxA7Dd6o9Gx5UMTy21iWj6dx87BH28EDsxxmMjl0fZbzfeV4AYyaD5Tuq+w3X
	bjvOfHe24Sg==
X-Received: by 2002:a05:620a:44d1:b0:93f:2a56:2772 with SMTP id af79cd13be357-9442176a63amr1067445185a.78.1793499242716;
        Sat, 31 Oct 2026 19:14:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425858552sm498131985a.18.2026.10.31.19.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 19:14:02 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v5 10/12] mm/page_alloc: retry alloc_contig_pages() when the zonelist is rebuilt
Date: Sat, 31 Oct 2026 22:13:38 -0400
Message-ID: <20261101021340.2251928-11-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261101021340.2251928-1-gourry@gourry.net>
References: <20261101021340.2251928-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 811E8100007
X-Stat-Signature: n1yqphihcxpe18en1teoqjr8c7ixmocg
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793499243-49603
X-HE-Meta: U2FsdGVkX1+zR/8hgyJDtjnnAP/2U2jELqVvJWbnayvOXey4Rvzw8cATFbAWFYDbeyEaszec0Us0wVmvPm6VV/VI0fkjdqfy7g651Fl9IDOObzlNecOz42ivYBUtwWnm2S2t0a07AN54+E9K8MiQXC6vY0fh1Jo2s5Hc7vE4czQ5Ev2aUGBRBzUWBYVOk4eKCQCI2UJHRHCiP88X0fCMKObP8CvUWup7O+CXYN3OUviIeQaogUNchumiXY+oTZnOqnQqrDTUBQjkZkzsaxJynugfmOQ9ISVivTBeHzeP3oKrNBZjGqX0bdbcrr+fILp+RcZAmUrzbIKrm0xrtS4A1GJsQY9M7hR1pEHtNKn27O+DMdCoK/GmVli7phFx3g0gUUJ6bzLGdEbUJCbH/MbqGmqzk2/72bUNmQ8t0rnhwG0AQH6O3uqU/dHUxbLA/XTf1BzSxmNg5O5lg/qcZ8irmk77jN82Dk0NneLi6WZzzkeTXilWBOnbJix8x/QVJ9CsRE4Vmc09HST0nfoU0QfYVybF85i7TZ4+XmWdmnDruk2PTUQgF/iyeoo+bU25RKA1TXrN0yWW4xFOsCrdPirKVhzj2tukIv/fBD9iGjrMCKLRcH6R5Rc5ySDRXQOtFdTkP/ZDMz8+5zfwqb5Z4NMh8FRm/yTHT3wpDTdv5shWuMLn+Ech7ebHNQ+e48+duBdcfDYJJVg1YQEjRhTNSlnJUAnqsQH7r0grKMQz9ExWNFCxTk/Cx2BDZ77xKOimo1vohsbNSh/tKjWXH4mn+5rqOF2Cn9G9Y8eJ1pzF9XSGcQBAul/EeyAZAtJnz0NKSYlij3kB27rzQKqccDD73bsNwmsooPBRiWEORCiMMyTKqGgHrRJIaAjLYmPezRY/qCvb8S8InEMv0g+EP2u1FBKg/zcusCTFMDAXKY8AbJbMYucU5TUncRnVu9lp9QIaiB6D0NwqUOJzkskoo2jhukt
 zfvAvoo8
 5h6oJOMr3u/JtnG1qvpKbB+8Mqi6Pi6+ahQQyIwXTZuf1zE3V+vMNyNhiHiwAJHM8RDln3nDmZuJfTfLilFFjF7loMBU4Rh3fl2YSUy5obRr0gMb9jiRnzRKnqG9DVvyP6Mdm++D9KS/WKxQcDw5dmhQu9bZlEHKGtZIjj7Yh3OtwdqhHjbgcLiyyg+DdI9lKrq3WYUkWKqjTyCbINrXYg2JuXu1f5w5apbF9r7CvLNjFJpElugnSlX0usG7Ek4ixZQSIfRPXxzw6WBK1sY0T5KXLKAQQ+41dxAmwmOipCVMD/l4VoHbN8eIlShLeRnE9l1CvGXKDENp8Gxb3xlAEqkJzG4CuubZwP3gM8H5Ov+3jyJ6e0Xzt9OBxb+DLDvSPOzM+FO6tzuSbq3yOvoUjYQaJdo46TC9Ef1qSnu+Xc9fbXuOFQwvBEx6KiEN5xi+NtHDPqJZiTyrgpVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Onlining the first block of a zone rebuilds every zonelist in place,
shifting the slots after the new zone.
alloc_contig_frozen_pages_noprof() approves a slot by the caller's gfp
and nodemask, then loads the zone from it:

  CPU 0                             CPU 1
  alloc_contig_frozen_pages_noprof(GFP_HIGHUSER | __GFP_THISNODE)
    slot 0 (NORMAL1) approved
                                    online_pages()
                                      build_all_zonelists()
                                        [NORMAL1]
                                        -> [MOVABLE1, NORMAL1]
    zone = zonelist_zone(slot 0)    /* MOVABLE1 */
    alloc_contig_frozen_range(MOVABLE1 pfns)

A gigantic hugetlb page can then land in ZONE_MOVABLE, and a nodemask
caller can get a range from another node.  Gigantic pages are kept out
of ZONE_MOVABLE since commit 79b63f12abcb ("mm, hugetlb: do not allocate
non-migrateable gigantic pages from movable zones").

Check zonelist_update_seq before using each zone, and restart the walk
if it changed, as the hugetlb pool walk does.  Check again before
escalating to the pass that may migrate hugetlb pages, so a pass a
rebuild cut short is redone rather than escalated.

With kprobes holding the walk across the online, the base kernel put the
1G page in ZONE_MOVABLE in 3 of 3 runs, and this change put it in
ZONE_NORMAL in 3 of 3.  Direct GFP_KERNEL calls with nodemask {1} and
{2} got a ZONE_MOVABLE range and a node 1 range on base, 3 of 3 each,
and neither with this change.

Fixes: 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_alloc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 242bef2fe400..91ad979409e5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7570,6 +7570,7 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
 {
 	unsigned long ret, pfn, flags;
+	unsigned int zonelist_cookie;
 	struct zonelist *zonelist;
 	struct zone *zone;
 	struct zoneref *z;
@@ -7578,8 +7579,13 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 
 retry:
 	zonelist = node_zonelist(nid, gfp_mask);
+	zonelist_cookie = zonelist_iter_begin();
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(gfp_mask), nodemask) {
+		/* A rebuild may have shifted an ineligible zone into this slot. */
+		if (unlikely(check_retry_zonelist(zonelist_cookie)))
+			goto retry;
+
 		spin_lock_irqsave(&zone->lock, flags);
 
 		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
@@ -7614,6 +7620,9 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 	 * second pass, we will try moving HugeTLB pages when those pages are
 	 * smaller than the requested contiguous region size.
 	 */
+	/* Redo a pass that a rebuild cut short before escalating. */
+	if (unlikely(check_retry_zonelist(zonelist_cookie)))
+		goto retry;
 	if (skip_hugetlb && skipped_hugetlb) {
 		skip_hugetlb = false;
 		goto retry;
-- 
2.56.0


