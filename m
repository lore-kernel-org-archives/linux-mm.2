Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BB4BCA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 13:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 377D16B0095; Tue, 13 Oct 2026 09:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34F946B0096; Tue, 13 Oct 2026 09:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266286B0098; Tue, 13 Oct 2026 09:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 001546B0095
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:13:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75289A0C19
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:13:58 +0000 (UTC)
X-FDA: 85317645756.15.FB0C74D
Received: from mta0.migadu.com (out-147.mta0.migadu.com [91.218.175.147])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6D8E120005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 13:13:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UHHWKwwg;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.147 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791897236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ek3mx6TgDbBeR7p5M7Cos/FCxBGxrw+lLXaTAB3CRUU=;
	b=2mvqMocPHAQ8trNOWhFJY4AHOScknbXhhDw2Od8pbnRc95WY88TwmAPA9Y+8uWr6XNTokd
	YXG5dxTf62VnaDbo6XHKMkU9h1/kJgZDLt6i+BuKYvfSrGfOa5iBtLy//pp/MGqyGEIt6p
	qelEFgTf5k7TxUMCTWBOleQG1Wvjy+E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UHHWKwwg;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.147 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791897236;
	b=KO2ORIek6XMdWMQD0+hkYpXeB1HUEmYTDk52Umxred6mmznTMS/iAAN2LZezkhUpEfNutH
	cBnGGkH9wYqtThx3jttFBxzLXFESb8AIST/08m0BAjNK98Soqdq4nZH1Er4UJx9IbSv4Nf
	l/Eri6y+pW/cvDpxEZGq8H88+pksWec=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nW1CspOmoIVHPTo1Fy5r0YAubWWAsv4TLIksg+iz1Qc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791897234; v=1; x=1792502034;
 b=UHHWKwwgwua6TrldSTRjOqx9TAxFVpZno5eXQurqE12PqzCgIcY0JX+At9F6TcTWRGuszx7s
 7s0bi252YZGu7Q5z/hG4LH7mRMp2w2QJ7N3oDtDp/qLwZnX0/QPZYtiuYCafIJ2XwJEl0OcDGxi
 TunVgroq2BmLSk/3OVd/G3LY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a30b4953a17dcf97;
	Tue, 13 Oct 2026 13:13:54 +0000
X-Mizu-Trace-ID: a30b4953a17dcf97
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	bpf@vger.kernel.org (open list:BPF [MISC]:Keyword:(?:\b|_)bpf(?:\b|_)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH RFC v3 2/7] mm/vmscan: move vmscan tracepoints to a local header
Date: Tue, 13 Oct 2026 21:13:04 +0800
Message-Id: <20261013131309.2790253-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261013131309.2790253-1-ridong.chen@linux.dev>
References: <20261013131309.2790253-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D8E120005
X-Rspam-User: 
X-Stat-Signature: 3817o4qsc6k93dqzpb6paf3aigyqzbhj
X-HE-Tag: 1791897236-917160
X-HE-Meta: U2FsdGVkX19D9BbhRjTsVtslP2TSBAkp4MOQ8EsoLnyh94AKw3tD5AaVjrNH6Bf0zbE/+QGezo7XOXQnsC/yNDbsI5Z2kda47g6GYKdvJS5XRo2hrLOwcfIxq6uqC+6leWmygFodmaO8e1vZKMoDzR8ElWuyIQviMPvp5KlW6SvEzU10yIKU7ACUPDE9qzgH6dPP70q2umHv+vSwUzDPt+TWuzhss/FCa0FCjUrepMwHmB8j4WB1B6qNYCtHuYAVZnPakFf3e6MvMWxdJdMTUL/e/4OhqkS01ZLLdWlARf8TGkbK/Q5n3RuIeGTo5J1lH/Z9V6c/HjjDpgNdUsdZeQqnvD8swTU4SLmZBh4zlsQgIbM9JJVzT1/rorQExiFiwnWIKiv4k2cgk1pzW5es1ixrPdVBUe9JAasYEsaVBtq5uEXIVSby8WDimiiKMNiuG5H/1kX1870K3gwoPnGl0T4VSykarSO9iwWdoTEmq9Bg332WLj5RzvttkJf+X5ZGqE9Kjf0voyZVSd9RWnnEO8Gm16eNQsYIcXlW8eSxRueUiJBhV9K1UGnyu7XCRqG8cbvlaZwd1ef3kBvMwmqdptXXJirrs3zGpstm7VaCGTBhTZeeFdDaS2u43P19gLhRmCOOV86ymvzJxcfp9k7Eq4qMpXOZ/vkxon/Q2HlMS+uy62wc4e1DN93v2Ircgtj+JAebcGI3wv/cGVx6GmjXNCZ0vZzy1W3lFWAYMX5AjzgeY7oQSkL5RRqAAnYpJNrXy9B41/1xWY6eQpY9WM+l7KeBB4s4g821kLqqTKSBD3NX5LSRTDo9m3spTu40Uk1i09YWNYik7ICK/bjDMW6LYnAAC1xcXuHVMK18ZAZaxIlRimrwvV1dw6LtGfUiJ9AbzGZMWYxx0jjDNYfkqncxW0IvTzIP7WttPLLNhx8bptUHV4xEH5+W++m2lxhk2yp+DXjmGV9ZedOy0e7ZtBk
 l+DQWiaa
 9YTpeM7PvrkDyyZSYMZxsocDrjQOcl7aZ/bPN/0MRSyLwyNpi+Gxg0qwa736WBv/zW8sOpywr9QoY19AzRDNOmP26/t09mbOyrhJMSJxUJOEHAIeWy/Rm39pFE6nOiKjPft9xS1tO7WM0sqd5lCLdyqGby+GUqG4955ZJQ/nX3NQbkQhTXZj5CH59Wca1z3SvW9KsM9rT+EwMR+ynS9DDizXwgPj3iukJDmOhxsic8DwLyV0ToshqtKX0mbgON2AHfmamnRrV/fsWU6+IQK0kSS6PzABrj4HuiDbOhh/uAyq83nrOMT/ar/nZ3bu3cdCcnyYl6Vgp7nn5D9HnffZQFlpVDIcbLg3nf9swgcDUzpuGkcZaUnfSFkNQ6avuAYiZJAhPFnhltoj/91RE90r9V4OuCdfi4ijEXMvwLH4QtgyY0jNDMslqgoORTorqed67KFjH5T1r3q040VmTQRhzF5e3upvB+Q5Jp9O4808y9+zdLmTY9tFbEMNfpQf62klEnknrZFsjdq6E8RAZEh+YlkDsP5RioTDCt6ACpIPcNxZ4awaMTtMHXaQXkOWnm71iLR99hk31MSjrPjgDF+qvhQFzLRMS+BI9g5tH2iZtLqZE9NiYsO+kQByKVz2D6prEdU/AdW/zpZFVyteAtLbcSCFsZat+irMXFiEUtekjROqw2TVgc0TyRQ1yceobalvxvubbdGMK6kkNFVurKmI8zFa9NOM03TYWICuoJaKVZEZl0GxQ9oy7XfmntUNNysyVGSm7vlx0sRTUycfvsdwk49DtPv+53+Dn/vEdE1LTifyb+ieBCNad248wj+lm9wwTyfYLgG7UlbsS3M+vmujco/uSf4VqGZY5FCH6M91W1DNq7lOsr9DcM9Ow+6nn22t+OPLWURZY39eMuLdi+4NkL7Hzb1YIJLGO2wmrAryXOhB3dnDsdj2VSVzdcHVvQrAw7LQzX+6wGnnp1Jd/2QroJIa1YRxi
 h4DNCNvE
 VnD61XiHqbCxsvH6Hsn6h/3QrqvuO7xd6Eua3CDC9ek6itHrRWx1n9orCULmEyApj+qNgd7chnzYxDRQOw6b8cq92mcTS3HxrZVHA7F3l2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
tracepoints can be extended to reference vmscan-internal structures such
as struct scan_control, which is not visible outside mm/.  This mirrors
what several other subsystems already do with their trace headers (e.g.
arch/x86/kvm/trace.h, drivers/gpu/drm/drm_trace.h, net/xfrm/trace_iptfs.h).
As they do, use a relative TRACE_INCLUDE_PATH so that no Makefile change
is needed.

No functional change.

Assisted-by: LLM
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 MAINTAINERS                                        | 2 ++
 mm/shrinker.c                                      | 2 +-
 include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
 mm/vmscan.c                                        | 2 +-
 4 files changed, 8 insertions(+), 2 deletions(-)
 rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index c5519d67b6f4..80d2a9dd0525 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17575,6 +17575,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
 F:	Documentation/mm/multigen_lru.rst
 F:	include/linux/mm_inline.h
 F:	include/linux/mmzone.h
+F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
@@ -17722,6 +17723,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	mm/trace_vmscan.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 7ec2a9704f6f..3c3e87c4b61c 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -3,7 +3,7 @@
 #include <linux/rwsem.h>
 #include <linux/shrinker.h>
 #include <linux/rculist.h>
-#include <trace/events/vmscan.h>
+#include "trace_vmscan.h"
 
 #include "internal.h"
 
diff --git a/include/trace/events/vmscan.h b/mm/trace_vmscan.h
similarity index 99%
rename from include/trace/events/vmscan.h
rename to mm/trace_vmscan.h
index 8a872990b4be..c5d824fef554 100644
--- a/include/trace/events/vmscan.h
+++ b/mm/trace_vmscan.h
@@ -648,4 +648,8 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
 #endif /* _TRACE_VMSCAN_H */
 
 /* This part must be outside protection */
+#undef TRACE_INCLUDE_FILE
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH ../../mm
+#define TRACE_INCLUDE_FILE trace_vmscan
 #include <trace/define_trace.h>
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 29b31446fc11..6207dad9e644 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -71,7 +71,7 @@
 #include "swap.h"
 
 #define CREATE_TRACE_POINTS
-#include <trace/events/vmscan.h>
+#include "trace_vmscan.h"
 
 struct scan_control {
 	/* How many pages shrink_list() should reclaim */
-- 
2.34.1


