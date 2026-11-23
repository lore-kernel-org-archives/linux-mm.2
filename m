Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A021A606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 10:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oodj3/y2
Received: by kanga.kvack.org (Postfix)
	id EC2E26B05B9; Mon, 23 Nov 2026 05:53:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5F66B05BB; Mon, 23 Nov 2026 05:53:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C765F6B05BC; Mon, 23 Nov 2026 05:53:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 998DE6B05BA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:53:49 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38B611A081A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:53:49 +0000 (UTC)
X-FDA: 85466073378.03.6F71E5E
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 99D1314000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:53:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="oodj3/y2";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795431225;
	b=GAWlGuAXWN/XCG3uxZ1t5Y5a9+Fd1iLQZArseWndJDZp2Vrc8ystYTeDRgeF5mNFHEK2Iq
	7QiJ5EgR7lAoD8qX1npTsZxq3yelRXrYeoMJeIhKCyNjxPtzCszFIaJbZeaEWISEpQnPeP
	4t612DxZXV2yl0xFQYRPncuQKwpV4Xs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795431225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5Y6RrQPl3+RDc3EwpamkVIy6Oyhib7bCsIXwFSNt6so=;
	b=4rw4CE2ORydGWxb0xFWOkpculZLZmfuYsEFgxsgPigpv28NSrAHuIg5DmLtiS4keobCLZR
	WQ9v74BoMC2m8qRCY6oCHOy8RnH64sJBw7slqsi7e8WkBGRpyjCD+2YHqrmI4zql4Vx9LC
	7suD3uEFAVcWCBOenkxNIjTOZvScLQE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="oodj3/y2";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795431220; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=5Y6RrQPl3+RDc3EwpamkVIy6Oyhib7bCsIXwFSNt6so=;
	b=oodj3/y2bd+8IJ8KIoGzTWmXDhA0FWxNC91KJCU2gCjBwyK69AWUKGGP5J349NSfLMMvVRH6+inEOnNhXe//V6VeHoOlJT2hOmIXXiGsUxyirsBZ/+ifKMGleHiSMtBZFQy74PWwlMOO0z3WDfKQg8A6Ibgsd0+fLxVE07W841c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XFHJgze_1795431215;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XFHJgze_1795431215 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 18:53:37 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	mkoutny@suse.com,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	xlpang@linux.alibaba.com,
	ryncsn@gmail.com,
	gourry@gourry.net,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH v5 0/4] mm: restore per-memcg reclaim for NONSLAB shrinkers under nokmem
Date: Mon, 23 Nov 2026 18:53:30 +0800
Message-ID: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ip5w9kobjk1f86qr78617w5zs1iq5fcz
X-Rspam-User:
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 99D1314000B
X-HE-Tag: 1795431223-207047
X-HE-Meta: U2FsdGVkX198dKBDBVgb8cneHFcl6oH3g498tgugwGODv529fvAdh/mKItrZrmCKufijpQwB2ZCmEjLnwH5da9f7cYCMczDeUkPkO3cPL/0IyitXLo363pDVxaWxnK571Xj6D7Cg9JUm6vmBBe14IVeRRL9k3An0uyFozBKeFH0gOxSotiuBkf8yRj41xx5EdFKg4dg2lIslV1TV2x7kd9X73zRQnrToD8PiqMja5U5boUfJUiD7EYgwXf0XROppbGVKD3ZzE+kdT6i+cE8v6KMBG82tveAdH0W/hrSJpAY39F2tGUILS47Nke7aC/5kVtpzIxVlSh4PFJuNK+UJIyYHn/GQlqjW5zF/qJBUmN+Izt4ar5OvJRECpH3y0AqIKf5TdjJ/xKodDvPKGSgNIOwrRiPqfiM6k/HZfhk4ZjpMx9CygHbBYXTmQhrt105lUXWoYRrxBBUh+7ru64PPzHs8hvkY57Bp768UYlpHpa3jW4Lv/dCy/Q9ki1/H4ANwILiISYxotElEsJfOPF6b8M2XrDlM53ecxV/GWIQYuK+X9rc4whvGADhDCWylF+HiTyp8mxg7PuqFR2szfGCwQpD5eFdQNMk8ZiA4ZB36fCjAKtazVIFtuYZ/DxhuPfYmXJ27gX8TELo++s7t0CB7757Ug3X7WXUG899YoEyvwfZbWJ9nrHkpDAmM7AWdiPIUtRQtLxd41v3DVmNwDRQMq0wPXjW5e1FNrbd62Y26SlrtWKD2kgncCcF3qKWMZZcFNuioSnzdbxskql9lFeX2lJEAaqvbziZpjt5ohCfpZ1moqJjGwpX9W35eicbd5jXrP2wTmLJW+rAiXab682V5zny4LseAKMtJ+G/bYsJAe+9J/vKEBh0jSJJApf3kLO3i5wn5xoUHBBVpOiVPEWd8cRtF0lMgRbbSNWvY9t9ySn6HKlvaCE4Tbbwy0e8nyGDgEJHAXY8RNpb9PICDCCY
 iL4WYX5K
 a0GUPO3sHXXHP+fVuSGsDFJNzTuoqvZ6DvvO7Sdd+vphcaFencvI2VUCIP9OTtQlVKOn2EM5Ksl1Gv+v8qUy+wDXygGsfD7YQ9gX4KbIZYRbJo2W+egQaGPNgywe9gRvVnL6SUaQK/wI28KiPvzEVahuncilWs2FqMaj9neBERKAew1VDrgBUOeOZKTOkuEnJSYN5sZ9iWfFYKhV6AY7kK9GonswujchEQl+ypeex0/l6lxBlZVKi7BAdwxgosgTTqEYpnTBHdrJF3yXja4iGT+Ak7xO9A7ptvsox1mPwSeX7fyjgM2qtMbMoBujzLAnAVkzcLjXTCSEo8U4YyDxOePD0CjVDHMXF60F7gmhBZEq/2D3JHQhwaU/fCBxjUdOBjK/GqhvRscyP91Brpa6OylSxXmGazstA8gEtr2cSvIjKUEbYpy7P15AwNC8cbW4Uc457VxnvfnvdventaqS9VXqzGDdNRfLqtCndbWki66RfQ/HKhEx33aGyny5zFMYIM7wrMB/u8MrQXcnosUddoXnsByM/g4nMgCtbmGSTzN1bLjk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With cgroup.memory=nokmem, the THP deferred split shrinker and the
zswap shrinker lose their memcg awareness because neither sets
SHRINKER_NONSLAB. When a cgroup hits its memory limit, these shrinkers
do not split its partially unmapped THPs or write back its zswap
entries.

Under nokmem, __list_lru_init() also disables per-memcg lists. Setting
SHRINKER_NONSLAB alone would leave all memcgs sharing one list per node
for each shrinker. Adding the first object to an empty list sets the
shrinker bit for its memcg. A second memcg can add objects without
setting its own bit, so reclaim in that memcg may skip the shrinker.
A scan for the first memcg can then reach objects belonging to both.

Before commit fafaeceb89a5 ("mm: switch deferred split shrinker to
list_lru"), THP had fully per-memcg deferred split queues embedded
in struct mem_cgroup, working independently of kmem accounting.
nokmem only opts out of kernel slab accounting; THPs and zswapped
pages are user memory and remain charged to their cgroups, so
per-memcg reclaim is still what these shrinkers want.

Patch 1 drops kmemcg_id and indexes non-root lists by the memory CSS
ID. The root memcg keeps index zero and uses the per-node list
directly. The lists are reparented when their memcg goes offline,
including under nokmem.

Patch 2 keeps a list_lru memcg aware under nokmem when its backing
shrinker is registered SHRINKER_NONSLAB.

Patch 3 restores SHRINKER_NONSLAB on the THP deferred split shrinker.

Patch 4 sets the same flag on the zswap shrinker.

Slab-backed lrus (e.g. the superblock dentry/inode lrus) still fall
back to per-node lists under nokmem. The per-memcg lists for the two
shrinkers are allocated on demand.

With nokmem enabled, the test_memcontrol and test_zswap kselftests
showed no new failures compared with the unpatched kernel. When one of
two sibling cgroups exceeded memory.high, the patched kernel split THPs
and wrote back zswap entries only in that cgroup.

Changes in v5:
 - Rebase on mm-unstable (7d1a16abe4cc) as discussed with Andrew [7].
 - Fold v4 patches 1 and 2 [6] into patch 1. Use the memory CSS ID so
   that two generations of the memory controller on the same cgroup
   have distinct indices while both are alive.
 - Keep the memcg argument to the internal walk for the owner check
   on restart. Hold RCU from the XArray lookup until the walker takes
   a reference to an online CSS.

Changes in v4:
 - Fix the boot hang reported by Kairui against v3 [3]: the walker
   no longer reverse-resolves the xarray keys; the index is passed
   directly through the internal walk path (new patch 1, split out
   as a preparation so patch 2 remains a pure key switch).
 - Drop the kmemcg_id member from memcg_struct_check() along with
   the field removal, as pointed out by Gregory Price [4].
 - Otherwise unchanged from v3.

Changes in v3:
 - Index the list_lru xarray with mem_cgroup_id() (the cgroup ID)
   instead of the private memcg ID, whose lifetime only covers
   online groups, and pass memcg pointers through the list_lru
   plumbing; inline memcg_online_kmem()/memcg_offline_kmem() into
   the css online/offline hooks (patch 1 as numbered in v3, per
   Johannes's review of v2 [5]).
 - Describe in the THP patch's changelog why the list_lru conversion
   dropped SHRINKER_NONSLAB knowingly, per Johannes's pointer to the
   original discussion [5].
 - Collected review tags: Johannes's Reviewed-by on patches 2-4,
   Nhat's and Yosry's Acked-by on patch 4 (numbering as in v3).

Changes in v2:
 - Keep the list_lrus behind the two shrinkers per-memcg under
   nokmem, so the shrinker bits are set for the right memcgs and
   scans stay scoped to the target cgroup's objects (patches 1-2
   as numbered in v2, new; addresses Sashiko's review of v1 [2]).
 - Patches 3-4 are unchanged from v1 [1] apart from review tags.

[1] https://lore.kernel.org/lkml/20260904033503.4067283-1-qinyuntan@linux.alibaba.com/
[2] https://sashiko.dev/#/patchset/20260904033503.4067283-1-qinyuntan@linux.alibaba.com
[3] https://lore.kernel.org/lkml/20260910080722.3961351-1-qinyuntan@linux.alibaba.com/
[4] https://lore.kernel.org/lkml/arNK64PxTXbVEhis@gourry-fedora-PF4VCD3F/
[5] https://lore.kernel.org/lkml/20260907110111.2286932-1-qinyuntan@linux.alibaba.com/
[6] https://lore.kernel.org/lkml/20261013031221.1997194-1-qinyuntan@linux.alibaba.com/
[7] https://lore.kernel.org/lkml/20261120191122.f31167fc1c987196e5a0b86b@linux-foundation.org/

Qinyun Tan (4):
  mm: list_lru: index per-memcg lists by memory CSS ID
  mm: list_lru: keep per-memcg lists with nokmem for NONSLAB-backed lrus
  mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
  mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB

 include/linux/memcontrol.h | 16 -------------
 mm/huge_memory.c           |  3 ++-
 mm/list_lru.c              | 49 +++++++++++++++++++++++++-------------
 mm/memcontrol.c            | 45 +++++++---------------------------
 mm/zswap.c                 |  4 ++--
 5 files changed, 45 insertions(+), 72 deletions(-)

-- 
2.55.0


