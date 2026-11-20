Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D112C607BB1C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nbLiUntg
Received: by kanga.kvack.org (Postfix)
	id 8EB036B05D9; Fri, 20 Nov 2026 13:10:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8747A6B05DA; Fri, 20 Nov 2026 13:10:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C7AB6B05DB; Fri, 20 Nov 2026 13:10:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2D26B05D9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:36 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CDBF11A015F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:35 +0000 (UTC)
X-FDA: 85456287630.22.0F696D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B1F5040007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nbLiUntg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf04.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198233;
	b=1bqZbLJ96HFTdsua562QbR0IF7Ep/sPnMYnuW3UmIuj+VPKQNU+IfEaZEHyeGHGrHSItlL
	ueUS2o9nH3sWzfnFCHrYS3aUh1jjeioV1SLdr9Ya2y6Of8WXlnJbr6VtBuGqX8pMNYcQfU
	yWUXbutPlsZLTu/qAVueLc0U4+5zYC8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198233;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Ag3N9FpJk876fPWs4rnvyKIM3F00ANMUIQWknOquWM=;
	b=QqVfUCJxn9A/c7EVEbjS+1MINqnFmMrZJ+Fh1lQvjvuLv+wsnSGOuCF7k+8Rhy+Ww7YpuH
	DGURVHCxWIHWCXVoRh2TfAPuzmR+pzpXtwSExx079JRf2hD4SK/LziG9owOEJFOuvFt/40
	ebtA/TQL343DhMS1qYOnsNe2xjUF+t8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nbLiUntg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf04.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 07BAF46CCF;
	Fri, 20 Nov 2026 18:10:33 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198232;
	b=vyfoGJCJRU4KLFmr6kgc8fewSy03v0m5BGduUAUBRZQ9HdH0cFdO6la395g1hFg4OPpb
	 TF7rZZA3W2nJ6GXF8rmM4b7S5RQ5Ci83+m16JW1ZPyORCWWczCSLPbH0PLmkvS7sbuqRL
	 y5cuXwKYGR5AHgyJxvIH4WEmJeslfUuaVkxWH/wU7QxAeojpj8JqFp9APDkmTjixDQTfm
	 cYvJ3qc7r1DF/QW2dXaqVCpxR6hQHmad71ZKihstvMyY0vWGWJ7D9NEWWK389IhkqCD6x
	 6npX+wxmutu1V1Vs8/VuT19jtIvQxKnL/VgzWb9oOTOUjn/lk8IJGxlWc0RoAx+ct8Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198232;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=6Ag3N9FpJk876fPWs4rnvyKIM3F00ANMUIQWknOquWM=;
	b=AoNFhss60qcVM6UUsZbdJj9TEeLSV+l5GudtkFrpIcMeuiQx5J73ZS2BwVIZzlLuuqDS
	 P1ezHmBiK99viDiBuWNEq+JvVbG2XNo1Z0yhIDzbVicTNGIjasRj7VyAI/EDVJQBTcDjc
	 6uwoF42natSJ6G+sZqcOEt7nwAiuXT4zbNTIRCwX53QkZIXWG8DeoqKcsjFxdg2TqYncO
	 J4r8Rz+S0CIp/9Fa9F70m+DlyE20K4YJ/j6QtkdQTZHarhmIDut9zfR85rSEMibap6nuy
	 BfkiiizYKn3E/pfCsWfAhMYY2ga/yAraxq8tY2BJtxW3KVbbZXhSTeDlVPq8WjdFgig==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8A7D71F00A00;
	Fri, 20 Nov 2026 18:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198232;
	bh=6Ag3N9FpJk876fPWs4rnvyKIM3F00ANMUIQWknOquWM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=nbLiUntgNaGpRF/bFt38weGkCM2bQhO7pb0kffLzYF/69W6S2Kg99+oLaFamCHAee
	 pxWIfMpQSxzbhIWSyLICC4lAr4fSNL0FUsBNIHfBXjn6NCDEe2QIpUN5ujRE4FVsFB
	 NDpGfilsWw45iKSmwJ8NmYk8LZln2cqL1qgPh89brHbQjgiUt/CKG1CB/B4EfjkwTe
	 OfZmpPSgs9rgG8Y0L3TbwkKSdoVhhbS1y1IM5NGIiS/q05IFmAedhjUqPMuGG+LKA0
	 SHm5Xr+vaAbm532FgqW4LS76ok78jEkmAvoHgGpu0gf7xgBKrp2Iavv0haq+B9D85S
	 PQmfNkNFJt8EA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B7DB14B93D;
	Fri, 20 Nov 2026 18:09:20 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:22 -0500
Subject: [PATCH 31/60] cgroup/cpuset: inherit common memory when a nodemask
 is private only
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-31-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=8729;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=lhAjAk7Sm6BaAakto+KbG1/rEMIjEBUTFNJJhHnsEgg=;
 b=0w6zXkqUQAxwMZHNpdjCJwh22P2ZJENxucUISEDMrEBkWvfPDRkY99+RSVag9NWwOq11MJQRH
 IcyhSRPQT3UDQwfXY7yDZh+nJ2+FXeoiiQ9r1UMnmnYyaJVB/NX9klN
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B1F5040007
X-Rspam-User:
X-Stat-Signature: zpbcucm9htc8zkk67rrrrwr81iuiacuk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795198233-537663
X-HE-Meta: U2FsdGVkX186adhuxbXKTLEV9w9QvT9h8x3icklYO5ljNSQWPESWlS4FrWXI2Zt8vvBu0jU1OWiADLd+oX4yx8S+WL/FN/PTGsdTMM6wFFcLqScfFnmd3n4Qx8dQP631TGP3+X3OeZyXk0wcSv8svpaP8/PrFjPDVgsk5Pg+tbQhxZfA701BYMneD0kvT8/dbAAK7jVOZbblga7FnwomqgLM846KZB8014AvXbQ4MY9nWpON0LUsBsfgJvJG9e//8Rp0iLxAaDNaE847++OB/jlTdOBku/uG5bh89DbQf1w/6QiGC51SsyOJVIRLSJ9koN0iKTU2NeoaxUgWxOcalcrMHNhQc+68qwLR//aEEE/E4KEuugkxwTMe/nLh9zmtMZcL3wD9nHqrERQSiXIXifzoo36bKc0YLHpQBeJcPka9i3LsIAy6FbetRe0Aj0Dp0yPDtN2l91GrAUP6nBXcMLv2gLF1j0+QhWBCJbAk+SFKCkSejab32rv60fhp68Gul8a4Nr0p+Tp6i6RO8p1fcQ7MQt+Sd+FMAGoMcmWoCoOWVJrCpMuk6ZC/p9Re1lwXbk8mQEzTHXkvJEgJfqw9udsGqgEWR2/w0UPPJX/+FDBBy80VnsK3+jR7JnCJdmWng9si8yfDJnfAwg9faCrqJET/sscNQ/KdyWKSyE1vaS1DswWPB24myInk0OJ4H9Jd71Bu0XqVmbLN7tGVz8DpJoeLEJZ+m4kp/lG2pPfxyhPJLwtyV40y/BxTgQrHj2HcsXqpG85TGagu12xKVwBovD/+64XljgjFDpYJL1fFiRysIo8j224r/VGl9yDMgTgNwY8qEEbAX2/trH3nJief3qmF3hI7jqo7IEalyll6uk2QNjJGR5zJHmifnNEpZsxucElYmjdajwx4urvJtCIgpmWBuTcKhZ2mQ/KSsE4OqAlo9DB9IxKZV+eCGtSO2YQImwzFD/1lTX0Z6Vdhe9X
 ZSC4JwmD
 iGzADOjRWm2Io83JRk2661WKqpRlhsmLSwdlo7Y+6v8wC4OLtPV4U7eBNk/ba+qZ916AiGq/6g/RGKI4nEJUBfBjEbFCAXn3NhwwB06dMHVGITb4IM9GlNI4TWjiqJqImJTUhspfmIZYs6/aqhfppob+vb8IUDuFEE1oZ/TI/vxXspFOl8dQLyyQz6rx/W9oCJw8q/qPGVNojMw/GjuRRaLnZP/TuCAZUT+xEd3S9Zke4mr6O2hnzgUof5fMKNoybIlUq9xFcRcB4L1Gej37VfhuxJR7ndcjGXyq/+Jq173y3xrgxp3lIopgo+Rs/rESVlABJCCEIxj7/leD5E/c7wtuf0rXBawSzGx7/V667Wb2JcpyafnSTVwLtabBI+weO08WfuRljkgl6qp2E69QTJniyIWe6vVFNGCOR4FpJLBDqJzHf6xWYHmm9tYC9uTF5rPXA/0s/cVLu1YlKd8Ul6afiVBElQHeIRqokTsd+uOUNuMw+ct4PZ46o7E3WUnYHn6HHI3CL3vEnaIHnJX60n48IWjteTLJeIc6BaYdJIi8v86aCa9crdguo6mEejriR5JQQ35OlvAY6VClxOWgJdNucZYVoE2p5lH67HP8gKvqTTgu7eFzEPwIBD447WVI2mSGiyMxsjmXetEdDIpxScPTR1+G4c5b7MJBfJBF3jW6k0XF2SVMk7n9Fm3ZLMwBFExA5M35PlkqMqZ0AG47PX/Yjx/G8ggg5UIWjg/B2Nd+C8l2FWxlhDevFrbHQ7inkD7nIhCyZRPtN2Hc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

cpuset.mems governs every N_MEMORY node, but ordinary allocations
can use only N_MEMORY_COMMON memory.

An effective mask without N_MEMORY_COMMON nodes creates an unsatisfiable
condition for ordinary system allocations, such as page tables. This
can cause an unsatisfiable OOM or an infinite fault retry loop.

Treat a cpuset.mems mask without a common memory node as a condition
to inherit the parent's common memory nodes.

The inheritance behavior differs subtly between v1 and v2:

operation                             v1              v2
 write {}, no tasks                 remain empty    inherit all
 write {}, populated                -ENOSPC         inherit all
 write {private}                    -ENOSPC         inherit common
 write {outside parent}             -EACCES         inherit common
 write {common, private}             normal intersection in both modes
 task attach w/ {private}           -ENOSPC         use effective mask
 {common, private}, unplug common   clear & move    keep & add common

In the v2 {private} case, the cpuset inherits only the parent's common
nodes and gains no access to unrelated private nodes. A request naming
no node the parent allows does the same. Systems without private nodes
are entirely unchanged by this commit.

An actual empty request still inherits the parent's full effective mask.

Example: (C=common, P=private)
  parent.cpuset.mems = {C0, C1, P2, P3}
  child.cpuset.mems  = {C0, P2}

  /* User sets private-only mask */
  echo {P2} > child.cpuset.mems
  child.cpuset.mems  = P2
  child.cpuset.effective_mems = {C0, C1, P2}

      or

  /* Hot-unplug removes C0 */
  hotunplug {C0}
  child.cpuset.mems  = {C0, P2}
  child.cpuset.effective_mems = {C1, P2}

      or

  /* User clears the nodemask entirely */
  echo {} > child.cpuset.mems
  child.cpuset.effective_mems => {C0, C1, P2, P3}

Private nodes are thus non-inheritable unless the nodemask is empty.

Rejecting a private-only nodemask in v2 would be confusing (-EINVAL
on a valid node) and inconsistent with hotplug, which can still leave
a cpuset with only private memory. Resolve every case the same way:
effective_mems inherits only the common nodes.

For v1, a write rejects a mask without common memory with -ENOSPC,
even with no tasks attached: v1 has no effective mask to add common
nodes to, so tasks attached later would have no common memory. Memory
hotplug that leaves a mask with only private memory moves its tasks to
an ancestor.

Automatic memory migration uses only common-memory destinations.

A task's mems_allowed comes from guarantee_online_mems(), which walks
up the hierarchy while a cpuset has no memory. Walk up while it has no
common memory instead, so a task never gets a private-only mask in the
window between memory going offline and the hotplug update of the
effective masks.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/cgroup/cpuset.c | 58 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 46 insertions(+), 12 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index db32d330cfbc..6802ca13c46b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -534,22 +534,24 @@ static void guarantee_active_cpus(struct task_struct *tsk,
 
 /*
  * Return in *pmask the portion of a cpusets's mems_allowed that
- * are online, with memory.  If none are online with memory, walk
- * up the cpuset hierarchy until we find one that does have some
- * online mems.  The top cpuset always has some mems online. With v2,
+ * are online, with memory.  If none of them is common memory, walk
+ * up the cpuset hierarchy until we find one that does have some.
+ * The top cpuset always has some common memory online. With v2,
  * effective_mems should always contain online memory nodes except
  * during the transition period where a memory node hotunplug operation
  * is in progress.
  *
- * One way or another, we guarantee to return some non-empty subset
- * of node_states[N_MEMORY].
+ * One way or another, we guarantee to return some subset of
+ * node_states[N_MEMORY] that includes common memory.
  *
  * Call with callback_lock or cpuset_mutex held.
  */
 static void guarantee_online_mems(struct cpuset *cs, nodemask_t *pmask)
 {
-	while (!nodes_and(*pmask, cs->effective_mems, node_states[N_MEMORY]))
+	while (!nodes_intersects(cs->effective_mems,
+				 node_states[N_MEMORY_COMMON]))
 		cs = parent_cs(cs);
+	nodes_and(*pmask, cs->effective_mems, node_states[N_MEMORY]);
 }
 
 /**
@@ -1684,22 +1686,40 @@ static void compute_effective_cpumask(struct cpumask *new_cpus,
 		cpumask_copy(new_cpus, parent->effective_cpus);
 }
 
+/* @mems names private memory nodes but no common memory node. */
+static bool mems_private_only(const nodemask_t *mems)
+{
+	return nodes_intersects(*mems, node_states[N_MEMORY_PRIVATE]) &&
+	       !nodes_intersects(*mems, node_states[N_MEMORY_COMMON]);
+}
+
 /**
  * compute_effective_nodemask - Compute the effective nodemask of the cpuset
  * @new_mems: the temp variable for the new effective_mems mask
  * @cs: the cpuset the need to recompute the new effective_mems mask
  * @parent: the parent cpuset
  *
- * For v2, the parent's effective_mems is inherited if nodemask is empty.
+ * A nodemask whose memory is all private cannot serve an ordinary allocation.
+ * In v2, a non-empty request retains the requested nodes granted by the parent
+ * and inherits the parent's nodes other than private ones.
+ * In v1, cpuset_hotplug_update_tasks() empties such a mask, so the tasks move
+ * to an ancestor.
  */
 static void compute_effective_nodemask(nodemask_t *new_mems,
 				       struct cpuset *cs, struct cpuset *parent)
 {
-	bool has_mems;
+	nodemask_t inherited;
 
-	has_mems = nodes_and(*new_mems, cs->mems_allowed, parent->effective_mems);
-	if (!has_mems && is_in_v2_mode())
+	nodes_and(*new_mems, cs->mems_allowed, parent->effective_mems);
+	if (!is_in_v2_mode())
+		return;
+	if (nodes_empty(cs->mems_allowed)) {
 		nodes_copy(*new_mems, parent->effective_mems);
+	} else if (nodes_empty(*new_mems) || mems_private_only(new_mems)) {
+		nodes_andnot(inherited, parent->effective_mems,
+			     node_states[N_MEMORY_PRIVATE]);
+		nodes_or(*new_mems, *new_mems, inherited);
+	}
 }
 
 /*
@@ -2667,6 +2687,8 @@ static void cpuset_migrate_mm_workfn(struct work_struct *work)
 	struct cpuset_migrate_mm_work *mwork =
 		container_of(work, struct cpuset_migrate_mm_work, work);
 
+	/* Private nodes are never migration destinations. */
+	nodes_andnot(mwork->to, mwork->to, node_states[N_MEMORY_PRIVATE]);
 	/* on a wq worker, no need to worry about %current's mems_allowed */
 	do_migrate_pages(mwork->mm, &mwork->from, &mwork->to, MPOL_MF_MOVE_ALL);
 	mmput(mwork->mm);
@@ -2900,6 +2922,14 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 			  top_cpuset.mems_allowed))
 		return -EINVAL;
 
+	/*
+	 * In v1, if a mask has no common memory nodes, it's treated as empty
+	 * because there is no effective-mems inherited fallback. As a result,
+	 * we treat this state the same as-if there was no memory at all.
+	 */
+	if (!is_in_v2_mode() && mems_private_only(&trialcs->mems_allowed))
+		return -ENOSPC;
+
 	/* No change? nothing to do */
 	if (nodes_equal(cs->mems_allowed, trialcs->mems_allowed))
 		return 0;
@@ -3090,7 +3120,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 
 /*
  * Check to see if a cpuset can accept a new task
- * For v1, cpus_allowed and mems_allowed can't be empty.
+ * For v1, cpus_allowed can't be empty and mems_allowed must have common memory.
  * For v2, effective_cpus can't be empty.
  * Note that in v1, effective_cpus = cpus_allowed.
  *
@@ -3103,7 +3133,8 @@ static int cpuset_can_attach_check(struct cpuset *cs, struct cpuset *oldcs,
 	bool cpus_updated, mems_updated;
 
 	if (cpumask_empty(cs->effective_cpus) ||
-	   (!is_in_v2_mode() && nodes_empty(cs->mems_allowed)))
+	   (!is_in_v2_mode() && (nodes_empty(cs->mems_allowed) ||
+				 mems_private_only(&cs->mems_allowed))))
 		return -ENOSPC;
 
 	if (!oldcs)
@@ -3988,6 +4019,9 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 	parent = parent_cs(cs);
 	compute_effective_cpumask(&new_cpus, cs, parent);
 	compute_effective_nodemask(&new_mems, cs, parent);
+	/* A legacy cpuset left with only private memory moves its tasks. */
+	if (!is_in_v2_mode() && mems_private_only(&new_mems))
+		nodes_clear(new_mems);
 
 	if (!tmp || !cs->partition_root_state)
 		goto update_tasks;

-- 
2.56.1



