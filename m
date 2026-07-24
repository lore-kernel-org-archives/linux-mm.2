Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92FFAC531CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 02:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2619A6B0096; Thu, 23 Jul 2026 22:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213296B0098; Thu, 23 Jul 2026 22:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 103156B009B; Thu, 23 Jul 2026 22:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D90136B0096
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:43:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 504F51401D9
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:43:36 +0000 (UTC)
X-FDA: 85022124432.15.08673B1
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 85450C0004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:43:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DnsTpQu6;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784861014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bDCqTywiR4s5nLQyaf6i50wmBQjCRcVwZ9olAr2XKwM=;
	b=CeryO8mxyTHb/cyjsYfaRWf1+K1ITVT7aeRU3ukx4KCCaBWs72TTXCfnd+KSYohjP1MACL
	NDQeSnuNrVC0vxKuLOP3jmn+NTDyvv4efCitQJM1IiMFpiTu3cwZyQluuCmpHQ9IPnz08x
	deHSnM0jlA199wK+PuK2XX7Ctcu8gfc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784861014;
	b=q3X6U/PJ9Qm/Jr7E8fwrHTcLB2e39mE583hSWRdV4MIWszx9Vyj1VZ69wBPFlqMU0A9fZw
	vhR8ukkcageEA3Kgu1bm8jo5u02z6D02NSLLL9WYowB4xrnD1xZYsGj89BkFnwvRdWtAH8
	M9sIMeJgXTfSyupeXbaaP5fRD82kung=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DnsTpQu6;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <8336e48a-ab3a-4db9-a7f9-5bb6af2b22c3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784861012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bDCqTywiR4s5nLQyaf6i50wmBQjCRcVwZ9olAr2XKwM=;
	b=DnsTpQu6+6hScxk3UNzHkxZ+9oUCyQoZu3i6pZIRcPs6V5oPVGV+fGVxbo2cHPs8fq6isl
	UlEBUVPrZBt/ciDvZZREkRR41w5enOI7A3d39Qdm/elQTUIykkXPqO/3VMY64Q2/koJTYK
	X9va7hKIQ6OCHzf8nd67U7o9/N2O+yk=
Date: Fri, 24 Jul 2026 10:43:22 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/4] mm/vmscan: fix swappiness=max and clean up
 per-node proactive reclaim
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand
 <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Zhongkun He <hezhongkun.hzk@bytedance.com>,
 Muchun Song <muchun.song@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260723045718.2052070-1-ridong.chen@linux.dev>
 <20260723171842.137e45eb36b21b3b45245da0@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260723171842.137e45eb36b21b3b45245da0@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 85450C0004
X-Stat-Signature: 97y9u5cg8sk6c8d5yzobqo3xu5f88pag
X-Rspam-User: 
X-HE-Tag: 1784861014-428600
X-HE-Meta: U2FsdGVkX1+gMzolEgam2/xPheG7pYGf5k3zbqF8rqK4+A90p4/RcQqBk6NHN+gDLFDvTzkwTTfX2F1cUWKmavUuWqeCktlkJyMXG8HTm4FXrlahJmtMqRG3durbKQe5Xa9vM1T+NsNNnz+rVPpkYzTIV1vxwUQCAm8VTyEifLQrBJBNTr4e5G7NWF0sc8I9REyUPByotLq1eDzSVg2WaMJuRqEhpd6EGOBmtJeAD8ZUIFqzuBFrfjHSEaCZ0NyMCiscQ2ONzj9b2cQSCQDgkLHAcyub1bbjprbqRJvB6VGHQBFfW7nzoIyWPuXtb58FoEqidxkEz4RO08sdGhnbehYp8kqTi9pXjCTGvLjFl8nG1OsMrmfarYbZ8+c2bH1QOh/ev9yv2HX+VtSCAs8zERmuVjnLe0HgBV8mH6SLPuJ8V0tmgkkbScVLZdnhqWxPRNxrsJiZMx1MD5zT2qWN2nv3oaoMx2QSNajfTUzIOUfHikat+5LQHtHSjidAniIcP5X7hiusORMvMQrz0r3D9Pt5HpECSR41+A102cwfGQ6WMjiD/XWm/pl989liOZhe5fvQ+22K+SEOAseH7OPBkfhPoLbjajvI1fKReIVHa6mftHn/8N5oAek0/6JwIm8TVDvXBt0L4cKnJE3ZghtZtUaHGmSj4D/+uxUwZQ6Izc60H01luDhV6MTz4kJU0G0WwRWFxbob41wYmR2D1GaHcchaPdzrnfrIvkJuydpgW3OFR3tbcePGfYQNTOuOIPCh/0NgOd9s8duzQtdIT4wd9ImOMeDLKmWxgV9ArqfZab6VcRv7aZRXX7V0GO3alLOTMeBsousEEfuf8ueuyxkR8un02B/poNDZcJoHXy8O6BS5uq5THYpeHNJFajryipaZBgj8a07A4ZfvQEcO36sDmla6TZWCvTQUfshvA52rKKiRiJ5VZnoc6swyQ8ZLUzkKLFxc/Ps+/o4U3ZOyztl
 TzYMxXiT
 zy2QmA84yIS5SXGhO4DAkzPKqXGQqtaMzg0CWdjUznPIHFHnxUqSoCv+NWaC0RNLAzC3Azb84KvUFqO6tyyqsGB22E/jJ6MEWz6pE3QthH1bkMy4gwdpRKncIdr24xbZaAsNR43rDNx1FmrXbwEdl1PhLeRGR90FQk4Mh/GI8dGHVExDBrkDWrGZd3ORhTCcP4i4FnpeghltJP/FR4KuWmSQkHyrlnL7kKDf6gP/c33aXtk59Hs5xaeTb04G94RAvmtz++oLFmwbXeF4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/24/2026 8:18 AM, Andrew Morton wrote:
> On Thu, 23 Jul 2026 12:57:14 +0800 Ridong <ridong.chen@linux.dev> wrote:
> 
>> Fixes and one cleanup.
>>
>> Patch 1 fixes "swappiness=max": the anon-only test in get_scan_count()
>> sat after the "cannot reclaim anon" check, so when no anon was
>> reclaimable the request fell back to SCAN_FILE and evicted page cache
>> instead.
>>
>> Patch 2 fixes reclaim_store() collapsing every error into -EAGAIN, so
>> callers can no longer tell an invalid argument from a busy interface;
>> propagate the real error code, matching the memcg path.
>>
>> Patch 3 drops the now-unused gfp_mask parameter from __node_reclaim().
>>
>> Patch 4 fixes the same "swappiness=max" issue for MGLRU.
> 
> Thanks.  AI review might have found several pre-existing issues which
> might interest the maintainers.  Also a suggestion against your [4/4]:
> 
> 	https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong.chen@linux.dev

Hi all, sashiko review:

   This is a pre-existing issue, but I noticed that per-node proactive reclaim
   fails to reclaim memory if the node's unmapped file or slab pages are below
   minimum thresholds, completely ignoring anonymous memory.
   In mm/vmscan.c:__node_reclaim():
   	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
   	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > 
pgdat->min_slab_pages) {
   Does this condition incorrectly block proactive reclaim of anonymous memory
   by applying legacy zone-reclaim thresholds?
   It seems to bypass shrink_node() entirely if file/slab pages are low, even
   when sc->proactive is set, which could falsely return -EAGAIN to userspace
   for anon-heavy workloads.

Should we add:

if (sc->proactive ||
     node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
     node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {

-- 
Best regards
Ridong


