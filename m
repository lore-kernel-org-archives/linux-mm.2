Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE9E3CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 20:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001206B00C3; Mon, 11 May 2026 16:21:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECD406B00C4; Mon, 11 May 2026 16:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D94C16B00C5; Mon, 11 May 2026 16:21:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C283E6B00C3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:21:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F111C09B3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:21:51 +0000 (UTC)
X-FDA: 84756260022.27.ECB1B6D
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by imf12.hostedemail.com (Postfix) with ESMTP id 545BC40004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:21:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778530909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=HMGgp7p0gzHaQqnXt2VXdbJfar/OLo38kZniMO/g5cc=;
	b=2jjPzuvxMc6oBg8/1Q92WVRflb/x/buZJ3jDZd/JP8lMhnjWpthUHmGd9VhgQK9RLSovHe
	5EainfF5M+V464phCPPsj8jR2oDL4ijZ1ZYcF8Rig0nI+HItJzMSgERJr+t9Uv5bQoZL3+
	ydFeQ4+8kaDs2p4EY7Y/mYvesmYrRdU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778530909; a=rsa-sha256;
	cv=none;
	b=C7SvCL9ANUEFCMzSLl5d3LhK7YUF7+c9AVrBCvUmkj6n3UD0Nfrlzu+cNxxNelCWNAkvYf
	azUZfDNbnr9UDbIvwSVlh7LkGYgV/Yp6XrzUP+lUa/O49EghtiUGUuC0VOSVN3lNe5+DmQ
	Odk6xC87byoE8V8Ria8/PPjT99f/luE=
Received: by mail.gandi.net (Postfix) with ESMTPSA id BF23F205EF;
	Mon, 11 May 2026 20:21:42 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH 0/8] per-memcg-per-node kmem accounting 
Date: Mon, 11 May 2026 22:20:35 +0200
Message-ID: <20260511202136.330358-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTGquq6RgtNh3qAAxG94VEBK0qIBmDDtoo/Zzcjxcpub7oP1RvXprwh05ms8DIfSfYwk911N5nCX8LFMrx+zdijkay9SXXntyv3aAc2iYuK82uOnILo39/ReHTeKjYXm2jGDzj68yb3e64ySMICR8r5EDpQfqweR7crbFhK6YXiJ7WFWpOlFkz3nekraGBCR5kMb/hNFVRvdHlEskriYh9kOGsO7rEwRpKjYyVoNiiy40BNfc9dBXB6YhrOqKB5AkYQMXuyJAZmvwH4eZjWFTuLv2jQRdJxTA/HZi9ea1FJrc1hijrQl0nHC6ck2jD0ovPyV7rEmReY6PE3doqmNCxTsbJEYcgA88Zrr0xTNFHihxWAOLqgB4q9gdAXWnvGoZFOJXgAidn8qkUEIKHmb9vlfi0hYKxVd1R35cjil0UNpgd7IJGSULKtAerOMBKojfvoZpyAfuhwFmVKa+gB7CnRafXK0eBHVaGg1YScD6eb6l7Au0fU3b9fbLDh5Vlxuo8AeIC3eGs0PVHsHUepf70VednVQcovy6ss1tDjxEfQkdL3XbO594VcmGuQUjBLoJDrnhZ3qLy+AxfhNziJlITymzO5LlxHLSxCOiIIsTlKXRYryU74AKwOrcm2OOR/cAIuoT24rgTPQ0osWEsXawRBnIVXx6t7T4+FbV6VaV7J1iQ
X-Rspam-User: 
X-Rspamd-Queue-Id: 545BC40004
X-Rspamd-Server: rspam06
X-Stat-Signature: hzbdcnmm366i5uhczp8tuazftymdh137
X-HE-Tag: 1778530909-697747
X-HE-Meta: U2FsdGVkX1++MdQZTEeim/kWPvD2twcwiAjFemE5umvFSv5zFFAJ3efAfVRlKLl7mFcLIv2H5vbHfATNfSw8yjEac09MbS6KdiGwzchvfjYxnBafZ6D3P9uFkNH6hvf0YBTBmDv2CPYnjtaHs0UHt7rqKV518eYqWC/8S8M6LvcZRuCAf2iYbVQhNZX3DNKh2W8HqrgUHz01afHOi4acpNmiOfOo/QPnL0TaRGDVJOGNvMLvH27jE3YbVP2scDt5JftK0k7MsTpHAVTYgxHX7V9uSm+S/r3Lfhg2vUHptFI7dhEmmmgavWhPmB8q5qZ+pdiiGhOMRvVFR657GvAo0kSZ2TTfmh/lV5rhfpRrRszsWYLNhcV8+lxJd7AzwGN4N30q11AvCbiW+S5o0wMzgl8i/y2FeNoD1mwOtFlxXf7hLgNWQDtUlaZeR0qlDOonHV/Pg+DjSmkIsq/5rojbrn3zPnjMlCRPXLZS6pjn71LYB+FtTMRUc89TYL9Ab8BvgcP2wxtDiaMS4wjVkPHhfuIXY55TOlT+cncRKe9HSc/S/nZ06bxUnJ5sGGVfMFKVxcfPHNxcd09ge+AR6gHyP/aZk+jD9sYE2WJX6F2mPRPDg00eIWi0evu+uW750nUrr741MKpZkFxmoQY03fIXvbQ8OuklZhMyHdcv4gYxj9C9rGGL+CJm80u1necrGZmd4tGHiRWwy5BjTBLaI3n0IltZ3g2zWNnNpM5d/utnEy8SiHOSKll0SvlOYVarFIw0GwFRjiRRecXARzWPDLxybmpk37NniDajDtSFfobXkWrZG3OHhdyhCaRnL8BIlGNJ0LdFhhGMJDJSTpIOvBKiAEN1sIAKPfMEXibIr7R6qANedyenmzWmEJxya4vhmbKM1fvXtDAkc0baXcsQR8DQPEeEkTMLNW6rNNZHp+pDx1gGcXRN5p8/99nods9kawvl6GKZxmHsWQVQSFWIsnc
 xszZKKE8
 F1Wh/S7GSqIbiw0qu10e2xBnGcQdKCfqWtAY+1S2cgvWjh8orF6rMO70MkfLyRkJYZ5cy7CNbGyPo0mTvzhSUtMHQJT8YW6i0zC2HCwflBKgY1QIQkRWHEaHTgoLWAjOm0ZgwEGu7mUtJnaf8Z9oevxAfAOFTokm1qW2zrqXJYFsPxlKGx2//LGfHgOsAb9WgfEdpthypZAlPTT59P89NCPmjinZnG2O6SxL7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series pursues the work initiated by Joshua [1]. We need kernel  
memory to be accounted on a per-node basis in order to be able to  
know the memcg and physical memory association.  
  
This series takes advantage of the recent introduction of per-node  
obj_cgroup [2] and makes those obj_cgroup tied to their numa node.  
  
The bulk of the series is percpu per-node accounting: percpu  
"precharges" the memcg before we know the actual location of the pages  
it uses, so charging and accounting had to be split. All other kmem 
users (slab, zswap, __memcg_kmem_charge_page) are straightforward 
conversions (zswap support is limited in this series because Joshua 
is working on it in parallel [3]). 
 
Thanks Joshua for your early feedbacks! 
  
[1] https://lore.kernel.org/linux-mm/20260404033844.1892595-1-joshua.hahnjy@gmail.com/  
[2] https://lore.kernel.org/linux-mm/56c04b1c5d54f75ccdc12896df6c1ca35403ecc3.1772711148.git.zhengqi.arch@bytedance.com/  
[3] https://lore.kernel.org/linux-mm/20260311195153.4013476-1-joshua.hahnjy@gmail.com/

Alexandre Ghiti (8):
  mm: memcontrol: propagate NMI slab stats to memcg vmstats
  mm: percpu: charge obj_exts allocation with __GFP_ACCOUNT
  mm: percpu: Split memcg charging and kmem accounting
  mm: memcontrol: track MEMCG_KMEM per NUMA node
  mm: memcontrol: per-node kmem accounting for page charges
  mm: slab: per-node kmem accounting for slab
  mm: percpu: per-node kmem accounting using local credit
  mm: zswap: per-node kmem accounting for zswap/zsmalloc

 include/linux/memcontrol.h |  27 +++++--
 include/linux/mmzone.h     |   1 +
 include/linux/zsmalloc.h   |   2 +
 mm/memcontrol.c            | 150 ++++++++++++++++++++++++++++---------
 mm/percpu-internal.h       |  16 +---
 mm/percpu.c                |  90 ++++++++++++++++++++--
 mm/vmstat.c                |   1 +
 mm/zsmalloc.c              |  11 +++
 mm/zswap.c                 |   9 ++-
 9 files changed, 242 insertions(+), 65 deletions(-)

-- 
2.54.0


