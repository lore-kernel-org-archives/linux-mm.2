Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADBC2606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZoTtl5Wn
Received: by kanga.kvack.org (Postfix)
	id 9BB606B05B4; Fri, 30 Oct 2026 17:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 996A76B05B5; Fri, 30 Oct 2026 17:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A92D6B05B6; Fri, 30 Oct 2026 17:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BDAD6B05B4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:35:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D94521C41C9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:35:21 +0000 (UTC)
X-FDA: 85380598842.20.3F9F3D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0CF5912000A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:35:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZoTtl5Wn;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793396120;
	b=zqmMpus9wP1QaH2Qv+fkYGZCrZMG/x9pFwsbHu6QktpnIYIX3pro0eVENBtpZwNS7ZlvAX
	LIAgljA/PtnXjAteOnF2TgyQN7QVoKmnGuaMOXc2rOLul7n8Zd2ZzWN9XIzqxGcULAhPz+
	rXybLmhoyFKRgRA6V9PXQYC3KxDIMqU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZoTtl5Wn;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793396120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0ROzhyVWpaAD+zcRsivDjlq++3aMe3aJhf6SnEDbsg=;
	b=1k9IT53NaGH1CSefhE0C5dUleFfXqdGdph5EzVFPNGeGijk9kegS/UvX2DuigoqnVjNw6B
	ON4X3L7DBpLrUSA2W+v//NMN55clBOq60X4LxhpmsWqqfd0Ht6Krod61QF48RE4TgOSbHu
	BjjnTRVK7hMBDGgkYhMKNca4fQy9tOQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EBE7C4141D;
	Fri, 30 Oct 2026 21:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10001F0093A;
	Fri, 30 Oct 2026 21:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793396118;
	bh=q0ROzhyVWpaAD+zcRsivDjlq++3aMe3aJhf6SnEDbsg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZoTtl5Wn+RQqFla8r3LjDKV+bAtFXOeegK5eNCIUCgycmQVrcSSjkYE9jQ+AC/9v3
	 xYHrgenAy3jbwXbjPeZiHCVacwTobYW7Di5R/FSNKH7BVJqE+eIkvGpbyT98IFq0Gz
	 96p6zIwxsTabga3thwvR8w/dl//OuCo6xapDVJacUt/Lk0F2Mf1bBsB2tiVMYo50Sj
	 8ZLTCgrchSkz4EwF6OPUCgw/8dolpsJFlRT/EauLpyLe+tKnH/AlpMaBfcoC/Deicm
	 77P0HQAgmAQ69rF6/V2oW8OVFE+dOBK4+Ume4mPw38dvbw4cvMyYcsjPg18plX2CjM
	 gSBwSyAE4GIoA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 30 Oct 2026 22:34:26 +0100
Subject: [PATCH 2/7] MAINTAINERS: TMPFS (SHMEM FILESYSTEM) updates
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-maintainers-v1-2-97278f8a5f54@kernel.org>
References: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
In-Reply-To: <20261030-maintainers-v1-0-97278f8a5f54@kernel.org>
To: Alistair Popple <apopple@nvidia.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Byungchul Park <byungchul@sk.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Christoph Lameter <cl@gentwo.org>, Dave Chinner <david@fromorbit.com>, 
 David Rientjes <rientjes@google.com>, Dennis Zhou <dennis@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Gregory Price <gourry@gourry.net>, 
 Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Kairui Song <kasong@tencent.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
 Nick Piggin <npiggin@gmail.com>, Nico Pache <nico.pache@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Pedro Falcato <pfalcato@suse.de>, 
 Peter Xu <peterx@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Rakie Kim <rakie.kim@sk.com>, 
 Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2535; i=david@kernel.org;
 h=from:subject:message-id; bh=YpR5XrhWeYStaaeRtOb6nKhSn1uNGhC94VBBnUzwKd8=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKe8ua9aA2fIvM4ZMvmI2+X/D96bZLdRFajH5NDJz8wa
 j9xa8mNlo5SFgYxDgZZMUWWoOD7Bi9frqutduNjhpnDygQyhIGLUwAmsqiKkeEaD8Oilid6KywW
 Zd/2MC+yz/Ioc14i/CBu1sGktzEqMi2MDD2f/rBO3rR0964/H/4+cy+TMVnblruv99eP/J/c+gq
 q0twA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CF5912000A
X-Stat-Signature: rtefzjun7hgxfiwiwqm737fto1kz1np3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793396119-761445
X-HE-Meta: U2FsdGVkX1+yqTGD2hH3sAjyt+QSEVWsGiaG1KlUF32jB7G+hG8q5tkXrThlvxFX/P3TXnl5QSpF8eiqz8Is8IuvnR2i2f6D6PWSnZGmFqrd22fDOZ8vqo/Em5wkZMj/wHJOlgV0mBcVGdWH/EYjBz93i9dBPGYlxpua7pUgG2VSVhnn4IQlyAPdejphtbmthNWI4lJGoD3886gjpsfqn+J2vYmfZgxaxv0qkc4P48Oa9Pgg9j+81Si3NsCW8rfrQVcQxN4YA8jD5Rknvx9MlbB8JjwGdbS+luyy/d9QdAw3weRL45iRQi55sbnqvrEJ/w9PIuS5w7ciZB8/8h5Zpo3m9DSqCDPxGisHwtxyI6IYK6rovl3eAbuCTu4LXZn3eXuhWfxeOcNalRpSN47ue4YHUjBL5oLOF4QP49fEqeYh9XhdXSYg6Ak4+xLtzPqC6uKgXqpzZPBal5xQTLcZzCPuGO52RdPqMIwBo5qH4jPdvbhsPLeZ31Sq6pr/+v6NVUqpOKglpRZ1yX6EeMng6lU6jP6u4hYFBv6IIawFxmkXQNrx5hT9b/THeejJjXf2yilO+oPVplqdOwKnwBcwc5lQQvvcUHTWExSMo7l/xVHAxqNje0hCw8leB/f1xftqitjeAUXH7ZdDGp3p4EtnDycNn0GFvxg3zL6VddfJBnRlMrpiTWZkMNHQ5IkydzhHYs4/HC5NoRt/ofRQlPAED0e77Fjr8n7gn6nQTh74cF7h5Ux4DuxI0fKTL8M7bSy8MdxIiJuNzFMduLJH4W10bKyPvqB/B7uD+/F0TZDZNzhxTYw52s2foB68PRKjHWxl8xO14VQPbbMoD29uC116MmfjCGmNWBYfqeiJG5JDaSKMIZ/O2FdIZYKCOvFmco5CGJk97FPzRcILlKnWwx0Em8zuvkZE1Qjt9vIN3tljJGK7OrkptMYo2vuUQFT/xyaEvej4zAkkiwKvdc0yMKh
 hPB/V1dP
 o6a3NbsY9efX3u0SU6jvd7svJpGDrXBWmegueErC3eC6ovjIVDmhnoQDQmBQXQTWLdDrjN98onKXZVQxN7WAJgZ3Z9DGZoBthdBYtaze+HmUKqhxEVExWTqWPQfht2vcfe0rAVhNiYWuk7PUAPyWuWei3OV50T2XgF71hCWJlFeWmjkPHm1VkHp3snXZfYwa90lYaZ+tGPhc0njMLgqa/8Cs35zt8mzsZNka6tL4pUKqrKr1u5gGqhfRbsa3YfFYO8eHEFSuluqj/5arK1bV+YCUPYLg9fxd5QFhF33PW3lDirtvSZbVnD1ob7IbrLV2t2SbAJJNyfsnre2Y/gDkMXGW4AHNmHG81HxwB+E5D9ka92F0/vvyNnEv2y0w59yUukJGIRxEVaFzE/Gjz8H9idYMYuJmGV/5X4guCeNQhObEDhru6vXIJG1HIBRXKvbN9iTv7sw4o7PzGIbwktharqgTUz9hmTPY/xTAMQ5NmYIxZLI0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I am not really the best shmem/tmpfs/memfd expert around, but it should
be good enough to judge when something is ready to be picked up, to then
pick it up. I'll have to heavily rely on Hugh and Baolin on judgment
for the more involved and more controversial bits.

Rename "TMPFS (SHMEM FILESYSTEM)" to "MEMORY MANAGEMENT - SHARED MEMORY
(SHMEM/TMPFS/MEMFD)" and move it accordingly. Add myself as a MAINTAINER
so people know whom to CC.

Add mm/core.git as the target git tree. Once shmem becomes a high volume
component we can dedicate it a separate tree and have dedicated people
pick it up.

While at it, add some more shmem/tmpfs/memfd related files+directories
we missed so far.

There is also "kernel/pid_sysctl.h", which includes some of the pid
namespaced sysctl vm.memfd_noexec. But that's really more of a proc/
namespace thingy, so it's not a good fit here.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 MAINTAINERS | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index dbb5582ec1c74..0baeb37b0dcdc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17772,6 +17772,25 @@ S:	Maintained
 F:	include/linux/secretmem.h
 F:	mm/secretmem.c
 
+MEMORY MANAGEMENT - SHARED MEMORY (SHMEM/TMPFS/MEMFD)
+M:	Hugh Dickins <hughd@google.com>
+M:	David Hildenbrand <david@kernel.org>
+R:	Baolin Wang <baolin.wang@linux.alibaba.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git for-next
+F:	Documentation/filesystems/tmpfs.rst
+F:	Documentation/mm/shmfs.rst
+F:	Documentation/userspace-api/mfd_noexec.rst
+F:	include/linux/memfd.h
+F:	include/linux/shmem_fs.h
+F:	include/uapi/linux/memfd.h
+F:	mm/memfd.c
+F:	mm/shmem.c
+F:	mm/shmem_quota.c
+F:	tools/testing/selftests/memfd/
+F:	tools/testing/selftests/tmpfs/
+
 MEMORY MANAGEMENT - SWAP
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Chris Li <chrisl@kernel.org>
@@ -28202,17 +28221,6 @@ S:	Maintained
 F:	Documentation/hwmon/tmp513.rst
 F:	drivers/hwmon/tmp513.c
 
-TMPFS (SHMEM FILESYSTEM)
-M:	Hugh Dickins <hughd@google.com>
-R:	Baolin Wang <baolin.wang@linux.alibaba.com>
-L:	linux-mm@kvack.org
-S:	Maintained
-F:	include/linux/memfd.h
-F:	include/linux/shmem_fs.h
-F:	mm/memfd.c
-F:	mm/shmem.c
-F:	mm/shmem_quota.c
-
 TOMOYO SECURITY MODULE
 M:	Kentaro Takeda <takedakn@nttdata.co.jp>
 M:	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

-- 
2.43.0


