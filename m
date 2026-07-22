Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E4CC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6BFD6B00A4; Wed, 22 Jul 2026 11:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D6E6B00A5; Wed, 22 Jul 2026 11:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933356B00A6; Wed, 22 Jul 2026 11:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 634D86B00A4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:00:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2834401ED
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:00:13 +0000 (UTC)
X-FDA: 85016723106.16.4FF2347
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id C8D1F4000D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:00:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ptbENXlX;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784732412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DqWQT0tndGmEGj0PwtBrPN312sJuLlEj79gAZ9AupX8=;
	b=JEASC6qQBsAkKWbMXFUHgj+faZN5j91FQFHeCRvRdfyn2bYWKfsizrxQUkDIm44aXazq2Y
	h4cb+Ry5TH7lp3Jv8/REifnvl2xYlPGr3YEzWTYcg76cYYX+7kcQfA8Cqk7Y5ByVYxGFNR
	ia0sTKB/hvoLhfYNA2s6bXDfQ+mYMDM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ptbENXlX;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784732412;
	b=kGE09H61orl/W3CEo5Wufa5Boz6X6O/gvxlK50ZutnJ5gCWRqzHKbPrvzJm+HHtf4mwkH4
	Rq5PZSZdell7+Hc9azwQWzTQ/TFEfV+dOddb5fwMTjRHOs5Q/yLCLeM3Zk0WCmbK/oNhcD
	LGkO0b8TQ5eyfRh0WSDbOAGg2Xuc7ys=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8ff20870ac7so102868176d6.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784732411; x=1785337211; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DqWQT0tndGmEGj0PwtBrPN312sJuLlEj79gAZ9AupX8=;
        b=ptbENXlXGWWQFt6st5yyItZatlOF0ZhcGk1ICNrfkGrpgc2l6eHcxyswfbtJpBeaKd
         GtR/qrydeDZIp0sdSRldJ15j+5dyiiBu6teU9H4YQfsQIU62t1OoByOqlPmPgHLI0roN
         8wevfgdkAZuqBISkVxIFZUdZSFesSiDTf7E0dv3T/CVDbxhYiOOeMHwOXyxUpxmq81z0
         Nta66Er2gI23Lu/V20S91lXfZTJD1a+x85+xsiO5UZJ82iPe1CroEaYTHB9+rIw9ZeIj
         ZXgiOJ7NzsQr6E6lAjDFwE36iPPiEsNzwvBdyVz4b0BST3cqzO/u2Mm/O5WxBDLkgQM9
         HBog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784732411; x=1785337211;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DqWQT0tndGmEGj0PwtBrPN312sJuLlEj79gAZ9AupX8=;
        b=kXNFSpFYZE2Gzt7bEK/gypzNk77kkcGSevEtf8vgAyDqrkzWtP4ukaVS66UpeAhqLx
         2B0zdg77peql2aunTW4o5gRwGirUufF9hmfGQhjcvMpLRitnGyjklnFb6hEjT5CNb3NB
         Za1cSSw8Kv6gKYfIYQ4unFmA+3nfROFJOwuXw7c2TsaEoKknV4okrtk/OCwvkQivLNtv
         9KZ+6GdwKx3FLpUl0mnz6y9nJe76T0Y0Y0FfBmTSOIDSdPGZZA+JboZ1Yd0YaQajgb73
         wCaKjXdsFf8Vo5Rwv3QtplPJZOIDBHel3miwX8gPi5YjarXneqD8qNZXMhvUYsmwfc/Q
         3ZCQ==
X-Forwarded-Encrypted: i=1; AHgh+RpL7a4cOLFnXf+zh6WG4ZOpNDxIG+zbPzIU6sdBdWPb0PYlYle79FSWpWS1E+hyCNal2KDtik8REA==@kvack.org
X-Gm-Message-State: AOJu0YxDkUiXsag+fNUXupRWyqOrwjtZRhd49WvlhYm3+c6bKmu9zn06
	aAVnx+GCQRdgut9ScA8AnSv3SbEiktiT1T9ah3YHGggU9hZ1EWpQ3oaj1gF+mTQla/0=
X-Gm-Gg: AR+sD1297KKMxIQn58EMNh4dgfhMR6Zz6HiX8pe76ncYf/uPIbgBJjvZjnb5gnMH45a
	xyRvQz2y0gZYUEFdUfBQI+ASQ5YmrjqgSivYB2dy5ZlWsRQRfNJcTTLcHeInqyqRV0rClqKdiE3
	Hl/IGDhl7BKxZLb2xbfnPyYVBx6VAQ8gXOX9gJ+KIPUlD1D6dqoIsNS7ivcMa+owSNy7p9LX0BF
	yHG4ErJIHfWRG4fM+PLtD8AleIZoKYkqxVqS5dRT7+5QSXfmQ2V3+kYZFVKSxXYXW2nvciNkd3O
	x5ruFMxJdChEhAPabi9DDUZCAqpyPbiFESuQQdV8stC9yrBMKD3+8Wadv3KGHkKmZXnmdJtsp7e
	cGk2jjqvqr11ySWYqlWKXQf+EdTN2ee2JHyeqmwcXik99M0VYvzzJ8QsRQHkIrpBj2czQvLqJ71
	Mx
X-Received: by 2002:a05:6214:248b:b0:8dc:ad48:70a7 with SMTP id 6a1803df08f44-9077835c6damr256478456d6.26.1784732410422;
        Wed, 22 Jul 2026 08:00:10 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907baa0f4dasm22586176d6.41.2026.07.22.08.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 08:00:09 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] mm: fix reclaim storms in defrag_mode
Date: Wed, 22 Jul 2026 10:56:43 -0400
Message-ID: <20260722150006.3848560-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C8D1F4000D
X-Stat-Signature: j5nai4befukrcwftqtr3u7s7kqogezbj
X-HE-Tag: 1784732411-112137
X-HE-Meta: U2FsdGVkX18K03dgGvAn4Wyu85I4CVmkFLE1KzEVH/6hJv9vpD1y06K9G86sO8RDr+IY1FGNLIGlhQcHBux/WWa65y73xgCY7MhMt+Tl+LavXUF5mUVNOEtquY8qYUelTyKJK9wnK5yxqwopQDh7gKPN0tSQN4QE+AKOKTKZ1uOH9I2C8MStNCWRuK80OHebFI2jpwnGG+VeiNAaiiuqI29JpCdpoclUPq5QRvSC62ir9QxZYjVy+2z1s5NozZS795nIBPRfhygGCM502luw4a5OQ3rNDPfnoQoNaHqTT5iztS75Q0sPm6rEgZyCHoc+5JZp8KAzvi4yzj8FwbD3wvPf6PybHWrc9BmQaCOax3HLgohfUFOLnbrES9zEHUhKC+sFIL9ygJiSekDpq9aQPpNcRMCGh17kZwlmnC0uNFGrCqXkab981enCnJD7YoAkGJjSpL3sjJSn4TM/S5mkB82SIgXsJQKlMKnb/zTMOnBVJervPjbVBkp4NTseWB4iTelTpkW1bdZPDiIbstBZsRDeRbdprYGuELh8geWdcMUUSFPodA6V1s2ycvrtQYyPPxq2qdFwQL+wPRlduXeJLfNygIEjxSPVhhHzyiC7ot0zxlmFuTe2cLltM4xvA6RbMzw9lxOObQgzi7eczyznQV1d9ezgC4vxnlxErsbjBoF1yPAJF7j7hCPHkKDhrOHrwbopuAFb36wAlaCAsQpF4QzQJB8dY1qwN+CEgKLSOOlvF+WgILikv8eAAwNHsCoQuhU0kJW+oPpys7DkJuuwigyoVU7Tpv1EaeRJM6ppSsFl5qy4vnKiz1OcwU+i0gIIF3HqeniWkeE0XN8Jd2pzPfon00/GkuKJo6TN1MKf0QXllCbvIrKKsbTbVa6VXHksWqadO3bDboN3L/1t+BBRkkE7T81NWdcfouMj4wyD6CTOIYj86RzXTPSQfQjDjniCdldR/v0t5xtFjnKUkYC
 jXLN5JAF
 VddDXuEEzrOGptXMN2Mb8iDNIaiuCG6ELRe+2bnc5HFv592v3+q8LYDLlt+0ltopule6TLABpGKK/xhJef4Lu3RrdzziIbHS3n39yaHsJFEv4n2OPAG7jkZuZisSf+04Jl960zFhV8Jg9T8UbJ/I2zshD/c6RDJif99vBerL1EMUSfo63glhmc6C24Zel6K6/XxH0tqdqAt21sMTfVyayx6sJNIAOdSFXfe4lY6R+7Hqaza2Hw01K4VNlWtV0OPtQgFNpgz+GVIl0RBJnmeNNHgUB6OZy3JOlkLxTsre/HNpJM7yGiUGS2Fttpg/HGB+JcNw7qh7jwoQKQotTMV9eHLRC4/ElhBj9GYbiLTfbzmsxbhQ7NM2PD2Lp+/zuLmPj4zeY1yji8Y/b8GQHg8NlWHGm/FgBS1WB0O6chY4eDntHoh7qeveFeU97SsD5xkGnX2cSBDoK9hKTt5E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As we deployed vm.defrag_mode=1 in Meta production, some workloads
regressed with recurring pressure spikes and swap storms (which in turn
triggered userspace OOM rules on pressure and swap utilization levels).

Tracing pinned this to non-movable requests spinning and reclaiming
unproductively when kswapd/kcompactd are overwhelmed. Direct reclaim
predominantly frees up pages in movable blocks, but those requests
cannot use that space under defrag_mode rules; and it is unlikely to
free up whole blocks incidentally for __rmqueue_claim() to work.

This series fixes it by making non-movable requests participate in
pageblock production in the allocator slowpath - meaning, they will
invoke direct reclaim and direct compaction with pageblock_order.

That requires some small-ish adjustments up front in the allocator and
the compaction code: three prep patches and the fix last.

The series has been in production against one of the affected workloads
for several weeks and restores the OOM kill rate to !defrag_mode baseline.

v1: https://lore.kernel.org/20260626182215.1107966-1-hannes@cmpxchg.org/

Changes in v2:
- Patch 3 is now Vlastimil's version of the capture_control move: the
  allocator owns and arms the capture control entirely, and compaction
  just aims it at the zone being compacted.
- Comments on the migration source scan restrictions in patch 2, and
  spelled out "small" as <pageblock_order (Vlastimil, Zi Yan)
- Corrected the Fixes tag in patch 4 - the referenced SHA was from an
  old development branch (Zi Yan)
- Clarified in the cover letter what block production means (Shakeel)
- Added review/ack tags
- Cc stable on the fix (Vlastimil)
- Rebased onto mm-stable

Based on mm-stable (2026-07-06).

 include/linux/compaction.h |  3 +-
 mm/compaction.c            | 96 +++++++++++++++++++++++++---------------------
 mm/internal.h              | 10 ++++-
 mm/page_alloc.c            | 76 ++++++++++++++++++++++++++++++------
 4 files changed, 129 insertions(+), 56 deletions(-)


