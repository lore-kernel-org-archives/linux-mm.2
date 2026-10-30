Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19975606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 09:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SpdV53ga
Received: by kanga.kvack.org (Postfix)
	id 2568B6B00EF; Fri, 30 Oct 2026 05:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206B36B05B1; Fri, 30 Oct 2026 05:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6556B05B2; Fri, 30 Oct 2026 05:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF92B6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:52:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E17351205EE
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:52:37 +0000 (UTC)
X-FDA: 85378827954.24.F97C0B9
Received: from mta1.migadu.com (out-192.mta1.migadu.com [95.215.58.192])
	by imf26.hostedemail.com (Postfix) with ESMTP id 00965140007
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:52:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SpdV53ga;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.192 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793353956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=H3pdNgV2kIMazb8X+rUUMyHlKbuV+ZiZTksRXL4D6lI=;
	b=agcMilnVC+Gc2qhRpB5StGbeAXGzB9o3IA+rqG7yUPq/aWpLGr/kDuqS52XXhlHU/8VDO7
	ywymGcu6kMGZYGX8hK/ihmabXUwAG7vR52sTh5GrhGgfv6O074As8bzJAavaHrSqMjVB2U
	Xo5s1hfc+RwyoKYdBv/cdXOKLlq1YKw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SpdV53ga;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.192 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793353956;
	b=BRL8UrJPWN3ycjxzIZlKMeqIxQG+URtUUjIJ7LSUDE/m6M8glbuc9jQWqDT3kO4WrD+6g/
	lelY/+XL1P2DP63DZTzW1iGlRQdA92nV4Kq0xrW0W/BYhaf0kZxaSgl4DkkiRHqhK5yNUI
	X0JySED3Hj6AETpwLsCa9WO87w6lyEc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1p2vPcKyuahPiXCpBK1Tm8nVn5slemcow3+ebdFu0mI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793353954; v=1; x=1793958754;
 b=SpdV53gaDoeTngFa7y6FaAQdRKpkiOm5tM2wSWFWy98yAZlWdEwaGoxv4LBdM+RWAGrANlvb
 jaLhxCYw+uLQN2JZdWAMIunuToWU5dp1rASctC1jrhuZIe0Q/BBG5joTMcQuFpqypHLbE4Wbxub
 DpYTALbNaUUDx7OaSPdt4JaQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id df75d9a41b4a335a;
	Fri, 30 Oct 2026 09:52:34 +0000
X-Mizu-Trace-ID: df75d9a41b4a335a
X-Migadu-Flow: FLOW_OUT
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH mm-new v1 0/2] mm: vmscan: skip anon folios zswap would refuse when writeback is off
Date: Fri, 30 Oct 2026 17:52:16 +0800
Message-ID: <20261030095223.325309-1-jiayuan.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 00965140007
X-Stat-Signature: nj9c41kt1x1dx69gcnn3fuzoudaywohs
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793353955-149190
X-HE-Meta: U2FsdGVkX196TP6c/pKzv0FPx5thqF19zDv0cSRt62H3UL35R75gsEThejjx3VfDGBwqDl6Xb0EywUL9Dm9lynDsFYv/fPkEgA+2zfY2U+cUVWVbAKG0J6uODBJW6/e2/WdrY3Bfx1aKN7Sonf0WRM4JFmPaPTolrgWFyzNXh6xnQO0gpeX3uA386lymF+f0/E3PnC2RVnY7e37r8VjiK1TFwIZKqJcZ1gCbCku3obm7+oh5h0GAlSzG8RnO0J34RSCxxOMZEeVmg6nQhcDAifnMxooJ3GF/s7Dcr4KD+Vd1/NmPrge/4kIRDnp4zf2WLXOgP6z8M7j4Etp0/mVjoab8QZcP8DlgWqJ/0Xk/x7Aj4O9SGxYtwZxUAoq/Pi6vx7cc3YeG2MXv9cVfcOfGHrRzeEit1Rz8nggz1ga4xxi26F+RH8Jj8jspUybp4RsOrl9L9cjSTsKXuEJnw5V7AsWMN+cZoEON6iZlI+f3dY81xm9MKq39A+YKqtht9V6hgUnEVQW802qz7QRbnaw27MchhNXMEmnFD15D7aEu7teEk+qbix2djwpgf1iumWskcaHDb+WQm4Vtffc01EIdz6i9DK1PyD/fK0Ipq0gGS2d8k88e7en0gESAnh03/zztU75gtwT5aDpaUz0elECaTKhHXlL9FW0wnHqEAUqljD4ImUY2lpOC8tUXhuk7jGbrqJE7KEXvj0/3chFVUSMmCcwUbJh36mbeCT7zyw7iy7q6TKQ7HXEYRHbysKs7hMAfLX/x4gmie7Blo8ucrDWZkt/MnAd3myPkM3ZljJmOeVg3bzqFSglfA9auVaX+rFbFzntcj4T83fSkHjqm2uDGfk0D1gw6kpdoN8yKnZxk1KZXuoxTGNavMrHkseZaqXr2NCtdbM83hvUqPeb7UbxAXg0Qq/mUA0ZeY3vt1JqsBFW79xFKj+gGbcF/SSYz/BOGbFfFccPTVYJcR3BbyUA
 CC371iy7
 bJjYQ64UCJo6eCMTm90DO4syIsNyn93FsmM+ZsGc/+7N0frM4WMXrq6V1ZBJCBdm/Czs2ZVoSajYsj7bDALdp9ToR2sTtzEV3XLaKohZ5xUdFiCjQVMbcupSpylZMfZolGe1h3H6/YuCG3wPoKw1CmS6Bw9uNDLpppvtL5vedeLERGEXdEEwBdTSRFj5mcKDsAc2Xa29vJMVX6yAUkAnoWhbXwqFgYoJj5MT3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

memory.zswap.writeback=0 is what we set for latency sensitive services:
their cold anon pages may go to zswap, but never to disk, a swapin
from disk is a latency spike they cannot afford. Such a memcg can only
swap into zswap. When zswap stops taking its pages, because the pool
hit max_pool_percent or the memcg hit memory.zswap.max, reclaim still
goes through the motions on its anon LRU: every folio it picks gets a
swap slot, is unmapped, is refused by zswap_store() and is activated
again. Nothing is freed, the folio now sits in the swap cache holding
a slot, and the owner takes a minor fault on the next access.

memory.reclaim below is just the easiest way to trigger it. The same
loop runs whenever the memcg is reclaimed: when it hits memory.max, or
when kswapd walks it under node pressure. Neither is something the
service can opt out of.

Patch 1 is a refactor so the memcg zswap check can be reused from
reclaim. Patch 2 adds the check to shrink_folio_list(). It cannot go
into can_reclaim_anon_pages(): zero-filled folios never reach zswap
and must stay reclaimable.

Numbers from a 16-CPU, 32G QEMU guest on mm-new, zswap with
max_pool_percent=2 (~640M), a memcg with memory.zswap.writeback=0
holding 3G of 2:1 compressible anon. The pool fills up after ~300k
pages. Then 5 x "echo 512M > memory.reclaim", and the task walks its
3G once:

                     minor faults on the walk
                     MGLRU        classic LRU
  before             786,454      786,452
  after              301,168      301,158

The ~300k after the patch are the pages that really are in zswap
(stored_pages was 301,133 / 301,165), swapped back in once each. The
other ~485k before the patch are pages zswap refused: unmapped, left
in the swap cache, mapped again on the next touch.

Jiayuan Chen (2):
  mm: memcontrol: split mem_cgroup_may_zswap() out of
    obj_cgroup_may_zswap()
  mm: vmscan: skip anon folios zswap would refuse when writeback is off

 include/linux/memcontrol.h |  5 +++++
 include/linux/zswap.h      |  5 +++++
 mm/memcontrol.c            | 26 ++++++++++++++++++--------
 mm/page_io.c               | 15 ++++++++++++++-
 mm/swap.h                  | 12 ++++++++++++
 mm/vmscan.c                | 17 +++++++++++++++++
 mm/zswap.c                 | 11 +++++++++++
 7 files changed, 82 insertions(+), 9 deletions(-)

-- 
2.43.0


