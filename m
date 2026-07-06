Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E65D5C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:20:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDF626B00CD; Mon,  6 Jul 2026 04:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8F3E6B00D4; Mon,  6 Jul 2026 04:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E8F6B00D8; Mon,  6 Jul 2026 04:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C60D6B00CD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:20:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2EE521C7BA9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:20:35 +0000 (UTC)
X-FDA: 84957655230.14.CECFA9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 890AA180003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:20:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aVCzimyH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783326033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YnYW7gijRWIjSN0XiWehcJ0WWReETZpoC/sP90hYzHE=;
	b=ZJYmF+9C8W/Vmu39fiRlZk2NQ9ohkDWVcMNmMQvbT8xkUVGLU4V38k75qZ+o7JBibL2kZO
	Fe79OZiClkR3WJgcwvK1dn1xeiQBf+p5FqTyEB/yX+nG9QbfDyDWFdl43deswK95MGGmAv
	Nkdg+mGcEP5beZejFvXtklcleA+1QxA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aVCzimyH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783326033;
	b=7BhuQQNEvG06BaaGGjrgsL8nDo1DRsD+HS8vu/hmxILLp29fyVrFopyBd48WnWrLzatt4T
	UN2/T0HBV09xHhqHsQjvKWMNskvLr68UhQpFvijiIbpDYmFUUHr+dvucewSSIIrgLijmeY
	wyimTja8i1NwhGIVx8DiNLtwizJ5VDI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA5BA4162C;
	Mon,  6 Jul 2026 08:20:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D432F1F000E9;
	Mon,  6 Jul 2026 08:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783326032;
	bh=YnYW7gijRWIjSN0XiWehcJ0WWReETZpoC/sP90hYzHE=;
	h=From:To:Cc:Subject:Date;
	b=aVCzimyHl9Pf4Otyx+cVBSBvCfDVz5GEKxCv4yk2/DaL5sdCxQuUGd3nqsWBpVnBR
	 /Ae/h+1PmeH9AY3XWOMcW4VHEf0E5PaOjvW3XcK2a6F2TmJPOTI4VZCer0uuGTfqL2
	 gKe++kwH3eh81zgzhRS2gkJBQ/ltMTA19GyxeVllepgC/vgWb/2MvX2WyXpN22OpA7
	 TUY7Uc7SGDAWXr5jbnfOZrPZwx+1goV+dAWdS02vNjz+BRiB53n/P0jRbcD9jXMTye
	 8H0aIuntWklsEtmD4v+NVFJ29x5dSu7WyU7yjHzRtwl3CLfAejg2hsZefxKygm4n95
	 n0vegptLfPzeA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Gregory Price <gourry@gourry.net>,
	Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Zi Yan <ziy@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	stable@vger.kernel.org,
	David Hildenbrand <david@kernel.org>
Subject: [PATCH v3] cgroup/cpuset: rebind mm mempolicy to effective_mems, not mems_allowed
Date: Mon,  6 Jul 2026 10:20:23 +0200
Message-ID: <20260706082023.60832-1-david@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 890AA180003
X-Stat-Signature: 7o8px4sswwxbzsgau7i768w8rqcz8kt5
X-HE-Tag: 1783326033-629510
X-HE-Meta: U2FsdGVkX1/16v3q4nzep6DFiFt4/3ZEuaFR2ASOi3fQysC1wH9K5p8LOh7md0EIaVKdHh3dUnOmMDmlboN0kr2vWSjsJOeAbHFWLX8RNShp173OFc0v7ilZDJ0xppjOG4iBM9Z4KNkZwoBTfK5kIFQAvr5lYw3+DJUECK08It4EgADiElnXg2mFfFaGCatrHJd6rr1+cqfKGkE84L2F/o2RBWyHGIY1MCd8G1NXTlCU3cU2567RyFEe7zxtsSiewVrCmj5S2jI3eAblOCYLRnTJhKMIs2WH15r/V+d54kiPVE0lt+ozVnEpNAZAGk08Ujem9cf5z6ORUrwp1hF7K5YPxMSmQK7MR3OJsYfffggyKwGUT/dVFjJ/k4rEktQkbGmL9ojxWldBPP5sDqWMEqRfZdifOxPQNTHawpVncTC/yoNguM3ViNEmcZ28BYaaztcS+yN63h/IX+EjIQBK7QQ9y/uCcuIZ8RUmawyp+SBDHeU11FGAIH+3I+0DEBwyJdyCV1RQUcnC05kzH8VpwWtW94WuHTLMewAocAyfMqo9WJ/MOnBeXpooTchupQjdRAVeAgCPQ1Xg/EcS6KDrgfcHda22ZMVzsJahaRyVG2kKGWyP3aVHYC3zSXuTEX8JwvaFZRsT559iV2LaTtAuJ40ozJmqmVtG+C3uTdiJw0z2rjORGt06s9xzl0gBznim8ht0Ivh55pP1p5Bb7bea020oiMwbxCa5UVr7OH3arrYVrDIk9kGxQMS75UupmGXeWNamyQGO5XT7T6DuNPZ+tvX+ggAup5bC4GezRwRoioNjZh/piWIp/FspZy4E+He3qGbPDWQa2Zjtr4A33pBaIPTXIGB87fw/3QZHEl/iY83CTNcEtWRRVUPdI/Nq4fF/BwxIvMcMnZM4CeJsH+o+rQFPbtBPQejh5ii9+QjuGBKbtf8E/VArN2q5AZ5OP0INPGZYxHvg0KdyvYG9nbF
 248O8D6D
 IHtdcbojwpv3Gqg1SAzBvmSd1owbPlRdaU8KSl+eV25H4xS3luxQO+eJ+11XbrD/z70cxhyJ4aiEbeX20t68x4eKW+XDTv6T4Ej5X6jmav/5XHMriMJu4A/BmWb9l/aZEFr6kc1695gQ/LneyQ4qDOiEUfya0PSJ4LcHSAFy/BYAWHOey0SNs40dY2i0YPW9pDZfPVALqOZw8NWuSdsP50ePnjsed5eLA3R+QLj47E/KLaRy4T+Zi5Y5offO/T3msfJxMiQb3lLCuDXX/WRstgqgc/92jqruwnQhPU4Lm1SG3ygDVXr//Z4My7UO1G02X7OdxwvkfY6sfljk70Abr2RCCcR9KlZoIKMZzlSOj+V5wXk7v2Nsz8AEnmM8duV/t9qtMzkki/YAOTBk3a7p77AqkHYAZxGSdgIpERmFdShUMk3FFBnCWEd66FWZPY6BZ7lmbHhcDuZSjkUPVO8hbVEKfkZtcLY4EaVtPGqbcqkBwKAR3iVidpxd1wi2I4OiK5sHilJpSVkZ1spugFKf++NocWvIFX/fwOMLMw6PbpnaPeRIpDZrxND4ksguR6ZJmGjJJsZ0JUG1g4xiqQ2DBUgq/KkPG5JDpSeVkM3gDfPN3S9g4wYs2jZmUIQDpvtni7/v+b63uTLi78pS4CDSfl2IVOcZDWjlYFgUgUvviQunh7WRDg9kZ+Ze/Aq96f2Wl5f5K5eacM8EprwBEs3H6V5NXvM65q+if9V6dsIPHi/gbD/VK3scN7ziA1mKbwAy4z/Vr0zyNCznzjCcYmz73GxKygkb9O4xxmDSfdUKjw6xKcVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Farhad Alemi <farhad.alemi@berkeley.edu>

Creating a child cpuset where cpuset.mems is never set leads to a div/0
when a VMA mempolicy with MPOL_F_RELATIVE_NODES rebinds in response to a
CPU hotplug event.

Reproduction steps:
 1) Create a cgroup w/ cpuset controls (do not set cpuset.mems)
 2) Move the task into the child cpuset
 3) Create a VMA mempolicy for that task with MPOL_F_RELATIVE_NODES
 4) unplug and hotplug a cpu
      echo 0 > /sys/devices/system/cpu/cpu1/online
      echo 1 > /sys/devices/system/cpu/cpu1/online
 5) mempolicy rebind does a div/0 in mpol_relative_nodemask on the
    call to __nodes_fold()

The cpuset code passes (cs->mems_allowed) which is not guaranteed to have
nodes to the rebind routine.  Use cs->effective_mems instead, which is
guaranteed to have a non-empty nodemask once we reach that code path.

Link: https://lore.kernel.org/all/CA+0ovCiEz6SP_sn3kN4Tb+_oC=eHMXy_Ffj=usV3wREdQrUtww@mail.gmail.com/
Fixes: ae1c802382f7 ("cpuset: apply cs->effective_{cpus,mems}")
Closes: https://lore.kernel.org/linux-mm/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
Suggested-by: Gregory Price <gourry@gourry.net>
Suggested-by: Waiman Long <longman@redhat.com>
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Michal Koutný" <mkoutny@suse.com>
Cc: <stable@vger.kernel.org>
[ david: add a comment, slightly rephrase description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 kernel/cgroup/cpuset.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 591e3aa487fc1..45944b3e31ca4 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2653,7 +2653,12 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
 
 		migrate = is_memory_migrate(cs);
 
-		mpol_rebind_mm(mm, &cs->mems_allowed);
+		/*
+		 * For v1 we can have empty effective_mems, but we cannot
+		 * attach any tasks (see cpuset_can_attach_check()). For v2,
+		 * effective_mems is guaranteed to not be empty.
+		 */
+		mpol_rebind_mm(mm, &cs->effective_mems);
 		if (migrate)
 			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
 		else

base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
2.43.0


