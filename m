Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 981ADCA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 07:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 744CF6B008A; Wed, 30 Sep 2026 03:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F67F6B008C; Wed, 30 Sep 2026 03:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60C5F6B0092; Wed, 30 Sep 2026 03:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A60F6B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 03:27:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0088120708
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:27:13 +0000 (UTC)
X-FDA: 85269597546.27.35DA180
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf29.hostedemail.com (Postfix) with ESMTP id B2BAD120007
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:27:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=VGS+3SNd;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790753232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=diIEvF2TasT4UOWkGa58uWQ9wl1dmZNC1jWBY2aBQCU=;
	b=64M/RWKUbWTJQpCtT07HGM4HlV6fkUsVb/2vFgmwuquEEFi2TmVb6arhcWurO7t7BMChdK
	kdqKXkfoU0DH9VjkXbpsiT+uXrjnJ5IdOVPKKpW55xR4a5J/HGQCPXnpnlSw6+8TXaSSl3
	S1HBABQHXoD0VsYcXqJNkp0yxKupsdg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790753232;
	b=n99pfZ1siqbQgatebmmOnCc+CPnL8RsM5Ceu+zatcM4sLFsAvBVyTpwEEbmByYADYvxerY
	DncvIbeWThaG9WBMoQ3wwBi8Iurv30YDuVnmj3ytRD7Brwy0dj1K8K+g9mMUcILG9J7ZI5
	Yk5PkEhviMmb3yEMFBLg93wAoPkfkUk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=VGS+3SNd;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1790753226; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=diIEvF2TasT4UOWkGa58uWQ9wl1dmZNC1jWBY2aBQCU=;
 b=VGS+3SNda8+sgaPeOpxyEtKZRV8WsptusvmjuYmCux0V6BJHVy9ROoKFRCm5vdox84g2GA
 tmQ9jgeIvqvg26/CCElQtyXPp2wAw0SaRHQV7LCZ7rEfjTllODqVtgeK0Q+TeIp3+Qzt1k
 COGttf88pkYPp6AmnO6SNY8vSfvv2UEjLGXQRdq0Fi5FQLI6xKPcWw8Mh04KeQnCVxOGr5
 NvJcp8GmlHcDUU8LwqkCzhn39HhwNze5cOGCtd7eJabFYiBn+gQ5noHx8V09NTPgVNIam8
 mvk2qFgs9YBVAilwWqD8GzS3LXEUFrgrsHwNkopJE3Cum+UhvXurtNS6zktGBA==
Subject: [PATCH] mm/numa_balancing: allow migrate on protnone reference with MPOL_WEIGHTED_INTERLEAVE policy
Message-Id: <20260930072617.64665-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Date: Wed, 30 Sep 2026 15:26:17 +0800
Mime-Version: 1.0
Cc: <linux-mm@kvack.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26abcb9c8+13dace+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<liam@infradead.org>, <rppt@kernel.org>, <mhocko@suse.com>, 
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <ziy@nvidia.com>, 
	<joshua.hahnjy@gmail.com>, <gourry@gourry.net>, 
	<ying.huang@linux.alibaba.com>, <apopple@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B2BAD120007
X-Stat-Signature: aomey41qdfckd53xawg1hq3okwzj5amk
X-Rspam-User: 
X-HE-Tag: 1790753230-483955
X-HE-Meta: U2FsdGVkX18zAxEbdS+sSBvcpGxHeEoasiA4c8boAmPKL4EESTu9b/YGO9M7XD3QgmASxHp37xGF1R+sZtEHQteP410adAgcAmamVWDfSRkE248cfBqrgx9x1vjUO/P/Nnv43enlXWNfkOJbbGJeClJztv8KBdipm/5QZQY3khRXwUmOoVlD9m/CLYaIjBybImdGXBxn7Z+jag7k76obp1Cxx1RiYiSrdwGVi8H68f88Lt0qf0DRvTpElCI1o0e/p1PB5WmmSQu0WspOD/mVmRnnuz5brUWSCQWH5+f4PZHZ5Fpp5fL2ZbcQqsVYwD1bjF8TLO/Xa216/EI0LBlchwCbqe6lOQgsmoscz+E+35tYN0xg3jNwTvhGb514LysiSBuJVqkeSUfqVvTS6H+IX45btocMb1ctvpbdqSeZl8PfDUxQoXtmqk29jxwWFOgM9rfOtYPdyOohZJX8a2Dbz9sRBDd/8xHnjZaTMrFcaeRn70q79b7se3IX8SnAgELUmcIYap6fFLOxB0H3nRO25RdT9qaT9T5mOPtzs93YAdzIJBHx84zpbQ5PJk4dtDxE9j38n+82RvpRIaIHEjZCwsAKtaZnlmzbyNE3vx8AnmdUOSKrHmnxWTfWEsTePupDJYttldJZwhSkndJdydNA3LW99GNedtZU9hm3rF1xTg1CTTdYm4/W5BCXo79RGaLzxhV54xjX24AffcEiMsdnTS+CWisoOmYZJaxHkJMpAZgtojR9gv0ncdR3DnpF2yx/mgRjVcTqJ1GXtjLRg+ndBFbNIySweSi+ZDsNJXlYgMg0JES+Cig5/EimfjFYS1iJuhlcBmSI0Tw8HHCB6k9nDrQI9CX8UHBe8J05+TyHVq66qbtmX4osSgLB2a1pIGfDyM+pil2qwcVWpreVs6H6o0kYE+gIq/TKRxuDciZ3r1GwB2D5o+eJCKjYEOAErdvQOE4kF673saR7oVWJlsC
 41B4I+nv
 HC/ynCSHJAOKgIg4muG9X+WrTeLtH8rLL8nPT99bZKiYzHdiiA9goaUj4eJCmuEhwV1Lhi6+qZK6XkBWJoLHFUjHirIFdK5U6EpTayxTylo1j14E4KnPRRLbW0KP5zYQ5i52BhtjdMRrW0qK4uHys5QufOwWNldu9XBhuy4797bftFhjGekKUZC4wucQfnIm4NRbePG6ureEq3kSwC7CGO6iFwWUs15uOOJVaSMGA0xDUkKLHBvmMSqanINXTVaqil2Nh7H0bWKCZyHTybpInZA/qKsDBu92mFPRhjzOZN1t64LO4oxTVs37zHrl4sYfVXEa5m9YbWq7+Wijp6CrtnaZR+HfhCGJ5wBqDy2fKPDUe/3OoXz5hMlRg4sZ64Smv3S1W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MPOL_WEIGHTED_INTERLEAVE is useful on tiered-memory systems because it
can seed a workload's new allocations across fast memory and slower
capacity memory according to a configured ratio.

That initial placement is useful for workload managers and orchestration
systems.  They can take the amount of fast memory and slower capacity
memory on a machine into account before starting a workload, and choose a
weighted policy that seeds the workload across the tiers at allocation
time.  This avoids starting from an all-fast or all-slow placement and
then relying on promotion or demotion to reshape a large working set.

After those pages have been placed, however, the policy cannot currently
opt in to migrate-on-fault placement.  set_mempolicy() and mbind()
reject MPOL_WEIGHTED_INTERLEAVE when MPOL_F_NUMA_BALANCING is specified,
so memory tiering cannot promote hot pages that were initially placed on
the slower nodes by the weighted policy.

Initial placement is only a starting point.  Pages initially allocated on
fast memory are not necessarily the long-term hot pages, and pages
initially allocated on slower memory may become hot as the workload's hot
set changes.  The policy therefore needs to be able to combine weighted
initial placement with memory tiering's NUMA fault based hot-page
promotion.

Allow MPOL_F_NUMA_BALANCING for MPOL_WEIGHTED_INTERLEAVE.  As with
MPOL_BIND and MPOL_PREFERRED_MANY, keep migration constrained by the
policy nodemask: if the CPU's node is outside the nodemask, do not
migrate the folio there.

This is an opt-in behavior.  MPOL_WEIGHTED_INTERLEAVE without
MPOL_F_NUMA_BALANCING keeps its existing behavior and does not
participate in NUMA balancing.

The weighted interleave weights continue to control new allocations only.
They are not a target residency ratio after migrate-on-fault placement.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 Documentation/admin-guide/mm/numa_memory_policy.rst | 10 ++++++++++
 mm/mempolicy.c                                      |  8 +++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/numa_memory_policy.rst b/Documentation/admin-guide/mm/numa_memory_policy.rst
index 90ab26e805a9a..f10a8297fb178 100644
--- a/Documentation/admin-guide/mm/numa_memory_policy.rst
+++ b/Documentation/admin-guide/mm/numa_memory_policy.rst
@@ -259,6 +259,16 @@ MPOL_WEIGHTED_INTERLEAVE
 	weight.  For example if nodes [0,1] are weighted [5,2], 5 pages
 	will be allocated on node0 for every 2 pages allocated on node1.
 
+	When MPOL_F_NUMA_BALANCING is specified, migrate-on-fault
+	placement is allowed within the policy nodemask.  This is an
+	opt-in behavior; without MPOL_F_NUMA_BALANCING,
+	MPOL_WEIGHTED_INTERLEAVE keeps its existing behavior and does
+	not participate in NUMA balancing.  The flag can be used by
+	memory tiering to promote hot pages that were initially
+	allocated on slower nodes.  The weights still affect new
+	allocations only and do not define a target resident ratio after
+	page migration.
+
 NUMA memory policy supports the following optional mode flags:
 
 MPOL_F_STATIC_NODES
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 79053ece02cd4..f71cdb488bbdc 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1731,7 +1731,8 @@ static inline int sanitize_mpol_flags(int *mode, unsigned short *flags)
 	if ((*flags & MPOL_F_STATIC_NODES) && (*flags & MPOL_F_RELATIVE_NODES))
 		return -EINVAL;
 	if (*flags & MPOL_F_NUMA_BALANCING) {
-		if (*mode == MPOL_BIND || *mode == MPOL_PREFERRED_MANY)
+		if (*mode == MPOL_BIND || *mode == MPOL_PREFERRED_MANY ||
+		    *mode == MPOL_WEIGHTED_INTERLEAVE)
 			*flags |= (MPOL_F_MOF | MPOL_F_MORON);
 		else
 			return -EINVAL;
@@ -3005,6 +3006,11 @@ int mpol_misplaced(struct folio *folio, struct vm_fault *vmf,
 		break;
 
 	case MPOL_WEIGHTED_INTERLEAVE:
+		if (pol->flags & MPOL_F_MORON) {
+			if (node_isset(thisnid, pol->nodes))
+				break;
+			goto out;
+		}
 		polnid = weighted_interleave_nid(pol, ilx);
 		break;
 
-- 
2.20.1

