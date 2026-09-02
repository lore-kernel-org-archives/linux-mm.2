Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06F06C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863B06B00A9; Wed,  2 Sep 2026 13:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83AA36B00AA; Wed,  2 Sep 2026 13:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777B26B00AB; Wed,  2 Sep 2026 13:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57CCF6B00A9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:43:36 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA596C0303
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:35 +0000 (UTC)
X-FDA: 85169544390.21.35CE5F7
Received: from mta0.migadu.com (out-95.mta0.migadu.com [91.218.175.95])
	by imf25.hostedemail.com (Postfix) with ESMTP id ADB82A0002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qGWHhZGb;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.95 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788371014;
	b=B4nCvUWaN6biPXkMPD1vNICFzv6jXoi4NmawhglXnXqxc9fD07yAf31YC4dHkxqOadZ7vG
	aqn6Ie7Ptb/0Bvc9C30tEM132Btw3ay8pHzbwJAdTAxbr+zJmWE2Ht8FIiwm9D44zgfp0x
	oOtDtLsXofB/ovIAbDMTrX829skGcNw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qGWHhZGb;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.95 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788371014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3OxUkfnCHogRQIYKHUah4yIRXqE55F7CgBU/oMOXoxc=;
	b=JeFEtiS00vkPzso1ap6X48qcC9L3kjDn2wpOv14wStMgMeP5gcndAcHkGZ4DsNQ6Ylk4gj
	HbBoQvt4gA4XV9YZ0FzI69AxBWgYDODUxBwF6G/qby7ByOSblCXKlgyX/MxMnp/8CHOd0K
	/Jv2OLEPaKqrJhXKWkaFPNEPTov/DcE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dbMEz1JHYuKrPhG1IXsUKT9HXwJuTLvgviFN/ZwRb6U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788371012; v=1; x=1788975812;
 b=qGWHhZGbo2LzF3DO9kknlbs2X7qXCisREyuW9CQd7bP8d3CaOC4JILczONwcc8cfmEUdOubm
 lU5cKr90f5wQMLnBnpPnFPe8oFECbh1PO0qMWgpIMAmhBC/VwDGXD30J/XGwYaxEwaMlwkABzTN
 sPNY0OCSpEuAXfEMY+LgfGfc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 65786b149d393ad8;
	Wed, 02 Sep 2026 17:43:22 +0000
X-Mizu-Trace-ID: 65786b149d393ad8
X-Migadu-Flow: FLOW_OUT
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
	tjmercier@google.com,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] memcg: remove the v1 soft limit
Date: Wed,  2 Sep 2026 10:43:03 -0700
Message-ID: <20260902174311.1772372-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jrejnufgh1f4ght4fdphr83i1iyqshjb
X-Rspamd-Queue-Id: ADB82A0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788371013-444423
X-HE-Meta: U2FsdGVkX1/cypCQqgzS+HiA/RGhtpRgpJP7JF3yG427hHlSEfSHQglmzrk8qfp+3q+Z4Pf5G3ydC89DY3FyN+1cbv+NWpY+U5yqngm+G3pDoDbgIcmR2Aw97v0UfdZ8RBlyGdoDTCVMxed0/MEEafXrYhM7LgWHP/ejLAfFrtdcu4iyTZ2/ZNXqN7P+L/9rhn18RBCdvIpgQCvIIrtYcZkidTPm/CVtZaCJlKyMHc8WqQz05aN6vlRMPapBcHUsmgDhsLx4Ah4rot9Yqar/1bIAbTk51pTPGLl7TsnUQvewmESvfpwRPOzN6iQNlM6j3tQaodTnnD9Nl0cWdRO/enVz4kmvk84VtkhsG8t3r+h2SFl4NWtatYH4j4XEWD/VSm1Dgp2pZ5WpnWIOKVu7jrLBLUdECs4d8uN4icY6dLOX4NjYQ0lqMVQY9xpB6O1YaGxB9KGZ0Mw6Iz3p10Rw6IcL+2LtCJrWPVpnbkB3JNrjs3xgNHVnQgz5NeRjUg3EPJIqdQSNmKMV9v1L/4BqeW4gUjgUgSFXySCEEGiuInK8p7OeHDlhceCgj6bfqx1/10hb7E8iYM1ae3Sf/2en6pGCr5ZGDneTTgjLmX2QziuVIUkcIBm+wJJQczbV9MqzC9G3QkDZvvXVEv/QGBKVUNnuV8ptz1OurFCbV116FE0Ha5C9QNP9ebfNEhSyKSfyx9oIixW2+4+Bh8c5LBBCdfvTN3gHvzKGbiadw0/EL3nB3nFxvM84Z4L9RXTnteACRNW2fRN0he7h0ij4WISQft/LOQ67Jcm3K8mjhzPs5oPVNKwr78enXtoNWTzrVOH1q9RhWt4hFB9xCSc8paFpY3SxTGG87MdOPjD6Rk3WynKSdC6noQcLBa/izCz42ADOGCYj03JHo4fnZko2obvQhZ28qAPETRi1hsN5VPgc/KIV/fuz/6Lq6GAWmfBf5Vb3l1yMXTUa18k915BcyMs
 w6Oz8vNx
 8aGKZDSf2t3TEP6fSqyi2Ovy5Dd4ObCKXw24qThFF/aqx9RxvVe6IvCG8iUJZCiBN9l/64wwt5FtMkWbSBUugEkykDAy9C8QedPp0UJFtZTuAdlQ5g6K+ewL6k95vmIFkv7mOA91RwF+icl6snPtfRAR77oerHZ6vxAhwBD17BEs3IU+JiK1gUeYlWyfxp9UwVuCbn4DKfws+uUWeLZAH0kTSx6wBh6BKKtvR8noUNhgVwhyTUuAUWxtWlf+WhxJ0ZzCInjV+eID+CZDRMXOqALiPEqARzMuAQ2z+pHA+uq0ToDc9sHcmB79zHUBsRQA7gZdFkFcOHG57rEFmdEj4RHqdAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The v1 soft limit was deprecated in v6.12 by commit 569c4f62d84a ("memcg:
initiate deprecation of v1 soft limit") and nobody has reported depending
on it in the ~21 months since. memory.low and memory.min in v2 have
covered the same ground for far longer.

The knob has since been made inert by "memcg: make the v1 soft limit knob
inert", already queued in mm-hotfixes as a backportable fix for a syzbot
report [1]. Nothing can enter the soft limit rbtree anymore, so this
series just deletes the machinery that is now dead: the reclaim pass in
kswapd and direct reclaim, mem_cgroup_shrink_node() and its tracepoints,
the per-node rbtree, lru_gen_soft_reclaim() and the MEMCG_LRU_HEAD op, the
per-node tree fields, mem_cgroup->soft_limit, and finally the v1 event
ratelimiting which is now down to a single target.

memory.soft_limit_in_bytes itself is untouched: writes stay ignored and
reads keep returning the maximum value.

Changes since v1 [2]:
- Dropped "memcg: make the v1 soft limit knob inert" (1/9 in v1), which is
  already queued in mm-hotfixes, making this an 8-patch series.
- Collected the acks and review tags. No code changes.

Sashiko's v1 review [3] asked whether the softlimit tracepoints,
lru_gen_soft_reclaim(), the per-node tree fields and the
MEM_CGROUP_TARGET_SOFTLIMIT ratelimiting could go too. They all can and
they all do, in patches 3/8, 5/8, 6/8 and 8/8 of this same series.

[1] https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/
[2] https://lore.kernel.org/all/20260811203203.3456029-1-shakeel.butt@linux.dev/
[3] https://sashiko.dev/#/patchset/20260811203203.3456029-1-shakeel.butt@linux.dev

Shakeel Butt (8):
  memcg: remove v1 soft limit reclaim
  memcg: remove mem_cgroup_shrink_node()
  memcg: remove the soft limit reclaim tracepoints
  memcg: remove the soft limit rbtree
  memcg: remove lru_gen_soft_reclaim()
  memcg: remove the per-node soft limit tree fields
  memcg: remove mem_cgroup->soft_limit
  memcg: simplify v1 event ratelimiting

 include/linux/memcontrol.h    |  27 ---
 include/linux/mmzone.h        |  30 +--
 include/trace/events/vmscan.h |  14 --
 mm/internal.h                 |   4 -
 mm/memcontrol-v1.c            | 392 ++--------------------------------
 mm/memcontrol-v1.h            |  12 +-
 mm/memcontrol.c               |   7 +-
 mm/vmscan.c                   |  96 +--------
 8 files changed, 34 insertions(+), 548 deletions(-)

-- 
2.53.0-Meta


