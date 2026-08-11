Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39CC5C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3181C6B0095; Tue, 11 Aug 2026 16:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EEF96B0096; Tue, 11 Aug 2026 16:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205BD6B0098; Tue, 11 Aug 2026 16:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E89946B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:32:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C9DD80209
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:18 +0000 (UTC)
X-FDA: 85090135956.30.14B1540
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id 603B740009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GHFUcx52;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786480336;
	b=OjcbnT/e6iHBaE7KH5Gf/1LfJXfyWFOJnL27jfdzSoSj7J/Aq+I7ab+XjiDw+0R9pAx/y1
	/kq5TBrNKj9xkQFKoOQGQU1CG8UCfHJgWf3ljZDa+EhainEfKvz5uVPVr7J7V3MZey5Lm1
	IdTGW87W9RYfMT2StLfFXrNeg4a1Zjc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GHFUcx52;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786480336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1wlHWvlNYK5X1K+L0iWyXB0vamRy/Y38tCPlEOhHAM=;
	b=MeamyQzGmudoetmaLKeadOh4ceqM7irXQFupwV3+4LgPJpfy+Cd+fnHB5hOgeysFLpBWtw
	fHhlFIzDIcV8MWfkrJzFm6ffRPLj8o8mOaenb8gop03jweJN3/hc5d75ZnxaF0cVqeGNXf
	TOidiTynpF39/lNhuwOr+4IOnn8oq/8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786480334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L1wlHWvlNYK5X1K+L0iWyXB0vamRy/Y38tCPlEOhHAM=;
	b=GHFUcx52I5JenvTVMdsP5ma5oWDaCPHj2bexFUFhqqbihu1co2+uFmNkT8mKZHxMr0yi7i
	bcdbNyVplWAsJ89GZkLTLksflSlJn217QSyr0h1zPUpfP84aKJLREgJ3RT0lhhNZkQ/dRO
	fnnMMvFdTpu2vvtFkIF0itKpByVkWvY=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
Subject: [PATCH 1/9] memcg: make the v1 soft limit knob inert
Date: Tue, 11 Aug 2026 13:31:55 -0700
Message-ID: <20260811203203.3456029-2-shakeel.butt@linux.dev>
In-Reply-To: <20260811203203.3456029-1-shakeel.butt@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 603B740009
X-Stat-Signature: sh1mgznfpd4nb4mxra3f4dpjptqs9k9w
X-HE-Tag: 1786480336-246039
X-HE-Meta: U2FsdGVkX1/BcidjKHOnANWYgXqEsmyS4++cxCEyLTtJmLSjznNIFytmbW9OZXj2PtftAq6oHEl2Seq7uY0dqMu3BXGfwNksfpSvE2yBgKzVXKu7ynnq4p1IbEr6gjvf6fbiwYl7CViIzA5KHVb47gP6DoFe6f6gOLcSJTBC/fZEA7pP8BzDgW6UMmOBEMHvQtxZgokj1QQAgcyC3FvLzwNm0Eg/VCMG8jCcBLVUrq1Cog34gOB4R7L0lzU7GKApyGDZ1FYPIHCbOLOtfa9fOhRc0rM+QZR78AGuGWk6aNvbJ8wHt2QVnT7ChxC4/d+j9Fg84FO+Tw5xqFlFqJs1LrezFFLRki81XM6aVuimGXMjeRhrsKQ4VMOsky1rq8Od/1kQLJJLwyOfmwDSwL9p09q/nFaWVjb9kJiubsqYy+CjTRQlPIHo/oCaT4aOccKYcdVlh6GtNHFoLI+u4sQxZ5Qy2a+gYxO2V+RMEIlAVzBxIGCfPtbgBH0ifURpogR30XtqWhd86OrmVBeQXNY/Rkrz+aRdHQPuVoYs08byERriBa8R2PRMjXHLw4WSoZOHz49zM50BT+W3YfWuc7kKUW3EGaC9L7vmvLle+iboSl2GVT5fWYntqkyLP8knycnvQUPEpDPT2snPGnyQR+RzFCsodvsdxXgJjzX16JcOL22MJFYMSmmL5ewr+WmoCRbOc5rJ+Re0XjluP9pj2ETvlsp9b1BRYEePwenq2VDjdsEDcAuIMZNw2W0H+VfabukItWJPVdq1G1Nk6R8P8QJVKtrqGDdcqjqpYpQ8z9GL3njf7+z/UYlmDshxdKYRIc3zPcKXhj+MjDgP5x/xnd34YyKAqmSoGiIFQNINk3xkCt8l89jRyqKE7TYT7W/lzQUvaId6bdvQ4jM1i8t5n/Frm2g34T+KTxm1dq77e1SGYDVzH25lkOlAABj2lk9mknUV/UeA/CVwrWxbiTjgjCd
 5i9XiZ+b
 cBS0rLdGdbEEkDcpyn3k6UwT2MRqS320vEG6Iq1hN2uJ52dDjlh56IbV3ENxHGZqSR8+3Urtu0TrTa5u+5s6/op8sHgkNAyd2QWM8+cTQMcPBjg+rRO5umdV1e2hdCjVRZJjJfsPFs909ndvamTQ9Yw6lU48eSv2cLX/pJ5gI1s4Ar9p+hxdjuYO7VYZa6iZpLIQjTiYBNfiO36fOXsw+yjohIiy3OlZ7aS/t+ikoiRR78KTHQHSkot3DFgssZxKNEELRf43cRgwgjG7kzgkJNQwzB3dCkj33jjKIkFNFbzlQHpe+a/kIGbuQOSn41LlAyYq+AMP4LxSms2KSaltfsqAgV520Kkeu6HQoy7PGceaV1tqBgbCO7T+QQZJMOOcdzQL+ppqV39mRA+kSsnpu7b/AcFTYXYkhkVbox3xkfHuJNdwRkTfVGoYH4NMqbMmsyA4svVKY2VJTHy125q441t9eZ6sIVsb6/6k84QQLAM0bHIAL5mOKaXExXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The v1 soft limit has been deprecated since v6.12 and nobody has
reported depending on it. Start the removal by decoupling the interface
from the implementation: keep memory.soft_limit_in_bytes, but ignore
writes to it and always report the maximum value on read similar to
what memory.kmem.limit_in_bytes already does.

Writes are still parsed, so malformed input keeps returning -EINVAL.
The knob now also behaves the same everywhere: it used to return
-EOPNOTSUPP on PREEMPT_RT, where soft limit reclaim has always been
disabled.

This also fixes the syzbot report linked below. Soft limit reclaim is
the only caller that runs shrink_lruvec() from kswapd against a
specific memcg, so it is the only way to reach lru_gen_shrink_lruvec()
and in turn set_mm_walk(), which warns when called from kswapd.

Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 .../admin-guide/cgroup-v1/memory.rst          | 49 +++----------------
 mm/memcontrol-v1.c                            | 43 +++++++++-------
 2 files changed, 32 insertions(+), 60 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 7db63c002922..7d2a44af52c9 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -47,7 +47,6 @@ Features:
  - pages are linked to per-memcg LRU exclusively, and there is no global LRU.
  - optionally, memory+swap usage can be accounted and limited.
  - hierarchical accounting
- - soft limit
  - moving (recharging) account at moving a task is selectable.
  - usage threshold notifier
  - memory pressure notifier
@@ -76,10 +75,9 @@ Brief summary of control files.
  memory.memsw.failcnt		     show the number of memory+Swap hits limits
  memory.max_usage_in_bytes	     show max memory usage recorded
  memory.memsw.max_usage_in_bytes     show max memory+Swap usage recorded
- memory.soft_limit_in_bytes	     set/show soft limit of memory usage
-				     This knob is not available on CONFIG_PREEMPT_RT systems.
-                                     This knob is deprecated and shouldn't be
-                                     used.
+ memory.soft_limit_in_bytes	     This knob is deprecated and has no effect.
+                                     Writes are ignored and reads always
+                                     return the maximum value.
  memory.stat			     show various statistics
  memory.use_hierarchy		     set/show hierarchical account enabled
                                      This knob is deprecated and shouldn't be
@@ -340,9 +338,6 @@ memory.kmem.usage_in_bytes, or in a separate counter when it makes sense.
 The main "kmem" counter is fed into the main counter, so kmem charges will
 also be visible from the user counter.
 
-Currently no soft limit is implemented for kernel memory. It is future work
-to trigger slab reclaim when those limits are reached.
-
 2.7.1 Current Kernel Memory resources accounted
 -----------------------------------------------
 
@@ -710,42 +705,10 @@ For compatibility reasons writing 1 to memory.use_hierarchy will always pass::
 
 THIS IS DEPRECATED!
 
-Soft limits allow for greater sharing of memory. The idea behind soft limits
-is to allow control groups to use as much of the memory as needed, provided
-
-a. There is no memory contention
-b. They do not exceed their hard limit
-
-When the system detects memory contention or low memory, control groups
-are pushed back to their soft limits. If the soft limit of each control
-group is very high, they are pushed back as much as possible to make
-sure that one control group does not starve the others of memory.
-
-Please note that soft limits is a best-effort feature; it comes with
-no guarantees, but it does its best to make sure that when memory is
-heavily contended for, memory is allocated based on the soft limit
-hints/setup. Currently soft limit based reclaim is set up such that
-it gets invoked from balance_pgdat (kswapd).
-
-7.1 Interface
--------------
-
-Soft limits can be setup by using the following commands (in this example we
-assume a soft limit of 256 MiB)::
-
-	# echo 256M > memory.soft_limit_in_bytes
-
-If we want to change this to 1G, we can at any time use::
+Writing to memory.soft_limit_in_bytes has no effect and reading it will
+always return the maximum value.
 
-	# echo 1G > memory.soft_limit_in_bytes
-
-.. note::
-       Soft limits take effect over a long period of time, since they involve
-       reclaiming memory for balancing between memory cgroups
-
-.. note::
-       It is recommended to set the soft limit always below the hard limit,
-       otherwise the hard limit will take precedence.
+Use memory.low and memory.min in cgroup v2 instead.
 
 .. _cgroup-v1-memory-move-charges:
 
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 835fc8e51184..05ef55cae4dc 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -96,7 +96,6 @@ enum {
 	RES_LIMIT,
 	RES_MAX_USAGE,
 	RES_FAILCNT,
-	RES_SOFT_LIMIT,
 };
 
 #ifdef CONFIG_LOCKDEP
@@ -1888,6 +1887,30 @@ static int mem_cgroup_hierarchy_write(struct cgroup_subsys_state *css,
 	return -EINVAL;
 }
 
+static u64 mem_cgroup_soft_limit_read(struct cgroup_subsys_state *css,
+				      struct cftype *cft)
+{
+	return (u64)PAGE_COUNTER_MAX * PAGE_SIZE;
+}
+
+static ssize_t mem_cgroup_soft_limit_write(struct kernfs_open_file *of,
+					   char *buf, size_t nbytes, loff_t off)
+{
+	unsigned long nr_pages;
+	int ret;
+
+	ret = page_counter_memparse(strstrip(buf), "-1", &nr_pages);
+	if (ret)
+		return ret;
+
+	pr_warn_once("soft_limit_in_bytes is deprecated and will be removed. "
+		     "Writing any value to this file has no effect. "
+		     "Please report your usecase to linux-mm@kvack.org if you "
+		     "depend on this functionality.\n");
+
+	return nbytes;
+}
+
 static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 			       struct cftype *cft)
 {
@@ -1924,8 +1947,6 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 		return (u64)counter->watermark * PAGE_SIZE;
 	case RES_FAILCNT:
 		return counter->failcnt;
-	case RES_SOFT_LIMIT:
-		return (u64)READ_ONCE(memcg->soft_limit) * PAGE_SIZE;
 	default:
 		BUG();
 	}
@@ -2020,17 +2041,6 @@ static ssize_t mem_cgroup_write(struct kernfs_open_file *of,
 			break;
 		}
 		break;
-	case RES_SOFT_LIMIT:
-		if (IS_ENABLED(CONFIG_PREEMPT_RT)) {
-			ret = -EOPNOTSUPP;
-		} else {
-			pr_warn_once("soft_limit_in_bytes is deprecated and will be removed. "
-				     "Please report your usecase to linux-mm@kvack.org if you "
-				     "depend on this functionality.\n");
-			WRITE_ONCE(memcg->soft_limit, nr_pages);
-			ret = 0;
-		}
-		break;
 	}
 	return ret ?: nbytes;
 }
@@ -2384,9 +2394,8 @@ struct cftype mem_cgroup_legacy_files[] = {
 	},
 	{
 		.name = "soft_limit_in_bytes",
-		.private = MEMFILE_PRIVATE(_MEM, RES_SOFT_LIMIT),
-		.write = mem_cgroup_write,
-		.read_u64 = mem_cgroup_read_u64,
+		.write = mem_cgroup_soft_limit_write,
+		.read_u64 = mem_cgroup_soft_limit_read,
 	},
 	{
 		.name = "failcnt",
-- 
2.53.0-Meta


