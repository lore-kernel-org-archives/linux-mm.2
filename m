Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C4DEC2A072
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 05:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39C06B00DA; Mon,  5 Jan 2026 00:02:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7536B00DB; Mon,  5 Jan 2026 00:02:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEA0F6B00DC; Mon,  5 Jan 2026 00:02:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9AAFB6B00DA
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 00:02:08 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2BF5B1A65AE
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 05:02:08 +0000 (UTC)
X-FDA: 84296713536.08.0E46F01
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3E41B1C0007
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 05:02:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bLi7S3qQ;
	spf=pass (imf21.hostedemail.com: domain of 3zEVbaQgKCBcy5A365xB3BB381.zB985AHK-997Ixz7.BE3@flex--bingjiao.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3zEVbaQgKCBcy5A365xB3BB381.zB985AHK-997Ixz7.BE3@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767589326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=su2/+ldtr1VxfhbSExiP2B87zrnxmLqxFxzTKeN9kWo=;
	b=wmdoseI40wmAiZ/ksouqpePP8gWXmZUqsfO443qzm4SrGUD7JdxsgmvLxmM4AfLnXKSpms
	NDaRl6JwnxTEORL/ho+KHCPJtq6yk5j/0P2NSUgBgqlvjqkYlxVhuQka6W3QVqef7/N8me
	uzcIHaYLQGzOb7Y8R/OKinjLieWA5EA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bLi7S3qQ;
	spf=pass (imf21.hostedemail.com: domain of 3zEVbaQgKCBcy5A365xB3BB381.zB985AHK-997Ixz7.BE3@flex--bingjiao.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3zEVbaQgKCBcy5A365xB3BB381.zB985AHK-997Ixz7.BE3@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767589326; a=rsa-sha256;
	cv=none;
	b=oBa8flB7AOzgZD3N5/ZzIx9VmaBsF1hXqn8y2Rmrq0SNSL6q9+xsxMOOCMLw3CapyLvaWj
	7eP0uvYTd1X/fs4HgjTdgotScw5nZGW5iGgCy1SWWv7bG3fAlBXpeWIoPulDC2wDoVb60U
	jwirFM5U3o2gq3JsIlXgXS8NTdm4qtg=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b62da7602a0so13521870a12.2
        for <linux-mm@kvack.org>; Sun, 04 Jan 2026 21:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767589325; x=1768194125; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=su2/+ldtr1VxfhbSExiP2B87zrnxmLqxFxzTKeN9kWo=;
        b=bLi7S3qQGFDWGqqYliuNKGY8fARptYPaux34u3HwN/wkLQVjJFV3vE9eS2WrNMYcMW
         ZqkyqhmHzAPvgbaOVV98yMXYF/SIfXLS95UR9AytJStjWqvZsRnVAUWuwaAMWUYIsUYl
         Ik2XKxNPCNwemkDmvzbvER86Yyl86tMNacrd0cOaNtx/xmfANZVZG0pOqlP8H1hb+wW2
         /zejD6u3+AGlyvRhJyNroBys1rbciWsSXmJCwOWpGCJpX3Wojf2KmJyt/kjOEt1pWUXy
         YZDRJnOH9Edj3wegtm6xoHrZ9wR9xLusvy+MkP1UitDC3VaN7h5euOUuqbZELfSSwNnN
         7/vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767589325; x=1768194125;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=su2/+ldtr1VxfhbSExiP2B87zrnxmLqxFxzTKeN9kWo=;
        b=ivmXWazB8pmBb9+aMkLv+Pi0E89ISdO2QuzxUai1mcB7npOhndhTefLlzvixMjfA2j
         W+t6TEFwBMnMMDM6/5DzXpjf1lMQPcVzbNRt1r6iPOXROuQO5Wbbt0JrJ3iYbdBDkvb6
         aLt9UdqhKr22Dp/k/YUIXugvNSIEWXgYJMqlPNGvdHW1+ZoVnE6hK+7tItqI42YaUyAD
         arrzwar8rBF5iNkBSx2zJVAuu2ATItYozu1oZwK00CSXyZOguNb+FwQaa7Oh70O/gzxf
         jk/QRsdwiLnf45LUNk20u9VtdBvQvM1DnzfWJ+pJtyzEowaz2Bnxh3SoZ5KuAkC96PbF
         ugHA==
X-Gm-Message-State: AOJu0YzWVdaSMRqaILRT853XLX/kfohWkh7Se8zD6iHXO/dLAcIPm9xn
	pQ6e9vb9cQ3bi6IvjTBNsFoV6l63/Z8L4dnlh8CvUgW79pkgX4woK7qPql4Hpi2yF2Hx4PniiU7
	bUEA8rg76a1WBigNn47H0vcJMR5grkdH+iscPPDrP2V5FeW8Q6FTo7HzJj7B5LlYoCJVYKIV84V
	lQlx5hh63l6+iB+bQ7l9ycSVeILuJYbQyJCji48Z/1lA==
X-Google-Smtp-Source: AGHT+IErg21SFCuglC5MAFW97zunmUDsIzYmQ1WqnCLTH98KRE2tTB+ijyI26lSVVFbDUqFv8s6EcjCVtmq44Q==
X-Received: from dlbcf22.prod.google.com ([2002:a05:7022:4596:b0:121:7aad:54d9])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7023:a81:b0:11b:e21e:5653 with SMTP id a92af1059eb24-121722ab59dmr31204081c88.19.1767589324637;
 Sun, 04 Jan 2026 21:02:04 -0800 (PST)
Date: Mon,  5 Jan 2026 05:01:52 +0000
In-Reply-To: <20260104085439.4076810-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260104085439.4076810-1-bingjiao@google.com>
X-Mailer: git-send-email 2.52.0.358.g0dd7633a29-goog
Message-ID: <20260105050203.328095-1-bingjiao@google.com>
Subject: [PATCH v5] mm/vmscan: fix demotion targets checks in reclaim/demotion
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gourry@gourry.net, 
	longman@redhat.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	tj@kernel.org, mkoutny@suse.com, david@kernel.org, zhengqi.arch@bytedance.com, 
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com, 
	chenridong@huaweicloud.com, yuanchu@google.com, weixugc@google.com, 
	cgroups@vger.kernel.org, bingjiao@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3E41B1C0007
X-Stat-Signature: wa3fqscytsooy4xkzoj9fanhc9s5q5a1
X-Rspam-User: 
X-HE-Tag: 1767589326-302145
X-HE-Meta: U2FsdGVkX1+B36PlWI7oHLNEL+5qObziBs5RkjiK3Y81GRnyP2WhV7yuiGsZumpWfbVpl56ttkhGzVpSd4O/oophl5xoNIY9IYGAtNvVHL/Aqc+Y2acHxjIWImmqvORiZVtkBntvW8liYieRDGN2RPk2pn0OyiJCukHVjZAv5kgNubTRZKs0SK6iX29UY1YUIAzdU+KuCZjB3pPA7vnUcj7RvE0JPc2gwU7gifzZx1zwQeiOdO8K9RT3hJ7a24b/fz5MbIEr9UPvLXR9U4yv8HTrCjBIMbqDNbdQZkGvXIP94KV9G5szQGdmPbXBk90Vn2KwPBG8KIAmIzBRPrk7MoskqwJ+VGkrzdnSFLm4ykn5rc5hnvn0D+WOAH9opgrP5FXib7i5WJ1jFFYoDSoYusq9Ce3e/q5V/tPeN0O5y3Kew0lNlehkNhYjckK+JxWVyCDKXjPiOEA8NwjQce9+2I0p4wcht0+gNuz5LNvqTHmogHgP1o9zAWJ15U48YY0HpYMGdllmN90Se7JjD2BSK4Qhkssj6uF4rK9KY8B52RxIV+lK3kjLLheNylhR/KegbaBGs2NP/0oWqeVKhVBgwh+Lk1murA//ooeA/9sHi1rbhOIyy31cGpJ8PIUSq8sE/N43gbUX7gnTuA+/Soq+UrzShu77HA3+MGzckB6DtoTTMRrgARCP5fMNskGnfyMl6cCey3LJM3pA/GPuyvtFC5WmF647BFzbw3az9dxMNVPJIjBvKVdkO16xw+5MXk6QK1LxQqnLTwwYCXD2mNTb3DKqHcRc1f/b3lIjmegNMK3Cjz01632dBJ1Ls+3nGdcPr+ccPqVYGCYNWLdNK29t9BpAMWdzi4eHm3ve923RMDq9+0kYFrITJV3nbVELNsqorvlXmcK+0Q0xkwfcoLGGyRr0VST2WH7k4vwB9Aw6jAZ22+rVJm8cjYc3A8XlEwTcapcCiP2Tp7pUmU/LKC/
 LXmvRY+r
 lXlcVa8zBKpMbeWf9PQfSGjQxs66IK50Di59+7sCTHwHpbGASz8zKJLk2rAKSFFZMaA8FsejJcZor2Vnx2YvWQdRK35AI9InQvw/5CL2Iq+CBx6Sv6lgtD2Ru/y0XupThQS/klXi/DuVlymOdPl5Yi7125vpCYTa6EqYMgokpemyPoG2Nn8wF3R1IPIP3ClcaUkroK162IGxtrh1LeZHlPuPnLGMDGrjI2ObXdexRfgb6ragPyVqyhnJHSg/z7sAqK/q7ne1ip0WIevTufYJmiR7/ctOYRIfuB4WS6vNF2kb4J9alSBWyAqMh20WnThSNbeNU466+gnNBRFaliNCgETLFbVhB9bG40PDCGXrwAibY+WZUQtCcvRm7u/r+abLKpbYpyqw1YnBd35aMFw0ZsEowUmLLbY22BCAIiksmTVptLUXLEG8k6vmXCdjXnL475iURjJw72ZwN3+g/8tzt9hieURzYZvqzzcWeHtopnw6glBTE1nABYZDPpjB8PVeBzKqYlhA39BCsQ1lQbBX0imegQtSPX8UuFBZCzWoeAX6i4AcJ3AkVD8k9m134mDLEmcClboWtZeXx1Js=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix two bugs in demote_folio_list() and can_demote() due to incorrect
demotion target checks in reclaim/demotion.

Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
introduces the cpuset.mems_effective check and applies it to
can_demote(). However:

  1. It does not apply this check in demote_folio_list(), which leads
     to situations where pages are demoted to nodes that are
     explicitly excluded from the task's cpuset.mems.

  2. It checks only the nodes in the immediate next demotion hierarchy
     and does not check all allowed demotion targets in can_demote().
     This can cause pages to never be demoted if the nodes in the next
     demotion hierarchy are not set in mems_effective.

These bugs break resource isolation provided by cpuset.mems.
This is visible from userspace because pages can either fail to be
demoted entirely or are demoted to nodes that are not allowed
in multi-tier memory systems.

To address these bugs, update cpuset_node_allowed() and
mem_cgroup_node_allowed() to return effective_mems, allowing directly
logic-and operation against demotion targets. Also update can_demote()
and demote_folio_list() accordingly.

Bug 1 reproduction:
  Assume a system with 4 nodes, where nodes 0-1 are top-tier and
  nodes 2-3 are far-tier memory. All nodes have equal capacity.

  Test script:
    echo 1 > /sys/kernel/mm/numa/demotion_enabled
    mkdir /sys/fs/cgroup/test
    echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
    echo "0-2" > /sys/fs/cgroup/test/cpuset.mems
    echo $$ > /sys/fs/cgroup/test/cgroup.procs
    swapoff -a
    # Expectation: Should respect node 0-2 limit.
    # Observation: Node 3 shows significant allocation (MemFree drops)
    stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1

Bug 2 reproduction:
  Assume a system with 6 nodes, where nodes 0-2 are top-tier,
  node 3 is a far-tier node, and nodes 4-5 are the farthest-tier nodes.
  All nodes have equal capacity.

  Test script:
    echo 1 > /sys/kernel/mm/numa/demotion_enabled
    mkdir /sys/fs/cgroup/test
    echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
    echo "0-2,4-5" > /sys/fs/cgroup/test/cpuset.mems
    echo $$ > /sys/fs/cgroup/test/cgroup.procs
    swapoff -a
    # Expectation: Pages are demoted to Nodes 4-5
    # Observation: No pages are demoted before oom.
    stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1,2

Fixes: 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
Cc: <stable@vger.kernel.org>
Signed-off-by: Bing Jiao <bingjiao@google.com>

---
Patch against the linux mainline.

Tested on the mainline and passed. Pages can be demoted to correct nodes
on a VM with emulated 3-tiers far memory nodes.

Tested on mm-everyting, after Akinobu Mita's series "mm: fix oom-killer
not being invoked when demotion is enabled v2", and passed. OOM can be
triggered properly when far nodes are oom.

---
 include/linux/cpuset.h     |  6 +++---
 include/linux/memcontrol.h |  6 +++---
 kernel/cgroup/cpuset.c     | 33 +++++++++++++++++++++++----------
 mm/memcontrol.c            | 10 ++++++++--
 mm/vmscan.c                | 30 ++++++++++++++++++------------
 5 files changed, 55 insertions(+), 30 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index a98d3330385c..631577384677 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -174,7 +174,7 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 	task_unlock(current);
 }

-extern bool cpuset_node_allowed(struct cgroup *cgroup, int nid);
+extern void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask);
 #else /* !CONFIG_CPUSETS */

 static inline bool cpusets_enabled(void) { return false; }
@@ -301,9 +301,9 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
 	return false;
 }

-static inline bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
+static inline void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
 {
-	return true;
+	nodes_copy(*mask, node_states[N_MEMORY]);
 }
 #endif /* !CONFIG_CPUSETS */

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0651865a4564..412db7663357 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1744,7 +1744,7 @@ static inline void count_objcg_events(struct obj_cgroup *objcg,
 	rcu_read_unlock();
 }

-bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid);
+void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg, nodemask_t *mask);

 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);

@@ -1815,9 +1815,9 @@ static inline ino_t page_cgroup_ino(struct page *page)
 	return 0;
 }

-static inline bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
+static inline void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg,
+						  nodemask_t *mask)
 {
-	return true;
 }

 static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3e8cc34d8d50..5bbd1d2fe5f6 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4427,27 +4427,41 @@ bool cpuset_current_node_allowed(int node, gfp_t gfp_mask)
 	return allowed;
 }

-bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
+/**
+ * cpuset_nodes_allowed - return mems_allowed mask from a cgroup cpuset.
+ * @cgroup: pointer to struct cgroup.
+ * @mask: pointer to struct nodemask_t to be returned.
+ *
+ * Returns mems_allowed mask from a cgroup cpuset if it is cgroup v2 and
+ * has cpuset subsys. Otherwise, returns node_states[N_MEMORY].
+ *
+ * Returned @mask may be empty, and nodes in @mask are not guaranteed
+ * to be online.
+ **/
+void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
 {
 	struct cgroup_subsys_state *css;
 	struct cpuset *cs;
-	bool allowed;

 	/*
 	 * In v1, mem_cgroup and cpuset are unlikely in the same hierarchy
 	 * and mems_allowed is likely to be empty even if we could get to it,
-	 * so return true to avoid taking a global lock on the empty check.
+	 * so return directly to avoid taking a global lock on the empty check.
 	 */
-	if (!cpuset_v2())
-		return true;
+	if (!cgroup || !cpuset_v2()) {
+		nodes_copy(*mask, node_states[N_MEMORY]);
+		return;
+	}

 	css = cgroup_get_e_css(cgroup, &cpuset_cgrp_subsys);
-	if (!css)
-		return true;
+	if (!css) {
+		nodes_copy(*mask, node_states[N_MEMORY]);
+		return;
+	}

 	/*
 	 * Normally, accessing effective_mems would require the cpuset_mutex
-	 * or callback_lock - but node_isset is atomic and the reference
+	 * or callback_lock - but not doing so is acceptable and the reference
 	 * taken via cgroup_get_e_css is sufficient to protect css.
 	 *
 	 * Since this interface is intended for use by migration paths, we
@@ -4458,9 +4472,8 @@ bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
 	 * cannot make strong isolation guarantees, so this is acceptable.
 	 */
 	cs = container_of(css, struct cpuset, css);
-	allowed = node_isset(nid, cs->effective_mems);
+	nodes_copy(*mask, cs->effective_mems);
 	css_put(css);
-	return allowed;
 }

 /**
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 86f43b7e5f71..252cc456714a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5624,9 +5624,15 @@ subsys_initcall(mem_cgroup_swap_init);

 #endif /* CONFIG_SWAP */

-bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
+void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg, nodemask_t *mask)
 {
-	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
+	nodemask_t allowed;
+
+	if (!memcg)
+		return;
+
+	cpuset_nodes_allowed(memcg->css.cgroup, &allowed);
+	nodes_and(*mask, *mask, allowed);
 }

 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae5ba..eed1becfcb34 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -344,19 +344,21 @@ static void flush_reclaim_state(struct scan_control *sc)
 static bool can_demote(int nid, struct scan_control *sc,
 		       struct mem_cgroup *memcg)
 {
-	int demotion_nid;
+	struct pglist_data *pgdat = NODE_DATA(nid);
+	nodemask_t allowed_mask;

-	if (!numa_demotion_enabled)
+	if (!pgdat || !numa_demotion_enabled)
 		return false;
 	if (sc && sc->no_demotion)
 		return false;

-	demotion_nid = next_demotion_node(nid);
-	if (demotion_nid == NUMA_NO_NODE)
+	node_get_allowed_targets(pgdat, &allowed_mask);
+	if (nodes_empty(allowed_mask))
 		return false;

-	/* If demotion node isn't in the cgroup's mems_allowed, fall back */
-	return mem_cgroup_node_allowed(memcg, demotion_nid);
+	/* Filter out nodes that are not in cgroup's mems_allowed. */
+	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
+	return !nodes_empty(allowed_mask);
 }

 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
@@ -1019,7 +1021,8 @@ static struct folio *alloc_demote_folio(struct folio *src,
  * Folios which are not demoted are left on @demote_folios.
  */
 static unsigned int demote_folio_list(struct list_head *demote_folios,
-				     struct pglist_data *pgdat)
+				      struct pglist_data *pgdat,
+				      struct mem_cgroup *memcg)
 {
 	int target_nid = next_demotion_node(pgdat->node_id);
 	unsigned int nr_succeeded;
@@ -1033,7 +1036,6 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 		 */
 		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
 			__GFP_NOMEMALLOC | GFP_NOWAIT,
-		.nid = target_nid,
 		.nmask = &allowed_mask,
 		.reason = MR_DEMOTION,
 	};
@@ -1041,10 +1043,14 @@ static unsigned int demote_folio_list(struct list_head *demote_folios,
 	if (list_empty(demote_folios))
 		return 0;

-	if (target_nid == NUMA_NO_NODE)
-		return 0;
-
 	node_get_allowed_targets(pgdat, &allowed_mask);
+	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
+	if (nodes_empty(allowed_mask))
+		return false;
+
+	if (!node_isset(target_nid, allowed_mask))
+		target_nid = node_random(&allowed_mask);
+	mtc.nid = target_nid;

 	/* Demotion ignores all cpuset and mempolicy settings */
 	migrate_pages(demote_folios, alloc_demote_folio, NULL,
@@ -1566,7 +1572,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	/* 'folio_list' is always empty here */

 	/* Migrate folios selected for demotion */
-	nr_demoted = demote_folio_list(&demote_folios, pgdat);
+	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
 	nr_reclaimed += nr_demoted;
 	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
--
2.52.0.358.g0dd7633a29-goog


