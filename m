Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0CD2CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 01:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0C696B00B6; Mon, 18 May 2026 21:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCAD76B00B7; Mon, 18 May 2026 21:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACE816B00B8; Mon, 18 May 2026 21:28:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 93C9B6B00B6
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:28:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A9BFC01D3
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:28:08 +0000 (UTC)
X-FDA: 84782433456.30.ADBFEA2
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2CF8A180008
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:28:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PhLI1Nol;
	spf=pass (imf24.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779154086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mx0oFUKOV8XCrLOMX8VahRqZqhy0/sjUBJqBWDg1Dmg=;
	b=POVBYIvpZM7/sOwwCn5MbKK7lECTDYd9AMFdvv3eVKRMYxex8nDWqpWjVVDd1BuDm3rhdo
	TR+zGJ3XYfOsT79LcF5v9r6xsyuKtmFToCrMnSuzsxlw3mTCx1tnK3VTvmTsRc9UJcpOEh
	r6FISECqOJTBYayrIovQNhHD2aegtzU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779154086; a=rsa-sha256;
	cv=none;
	b=HXHMDhi0zq5j0eVzmTpEZ+qyg9xhmOsDICE/V1Q2fLbIJkS/kmZiU7C0VNJ6TEL/W1zk+D
	UyH7Zhw4SRLNAz07rXST/964361/uAOaIvg+4O38bszWGCWzy4WHbaHvBcmxi8kZWxE980
	dz3cJIrY/yI+2aHh38ednkUlknOqEJs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PhLI1Nol;
	spf=pass (imf24.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-45297094718so2290595f8f.3
        for <linux-mm@kvack.org>; Mon, 18 May 2026 18:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779154085; x=1779758885; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mx0oFUKOV8XCrLOMX8VahRqZqhy0/sjUBJqBWDg1Dmg=;
        b=PhLI1NolfN5UaBuEMlvxVhKxhpk/OK7wg9lmI7LqEekRM3xHBjhU3wqynJb/DRDaAJ
         CiJVUVjFsRtVHlVj/RZWwqf1S52x4zAPb63Kgqlm0R2VWL1ewaq7h8y9Xn7GfJ1IHELW
         0ro5flyvi/B9393K5CqpEmljhAO+w+B2MoQH1xbfcCNwMwcJhjhEG2Py//VGStw78dP/
         LvCLO3RRPLNBOtZW/07rH1ISlb2amF4x91qSfYUElFWRyTRxPlvWxh7AQLryMz+tkg2J
         ijg0H1UVipTAvAZMrCSCEFLUzHmIa75AL03PqdY3ufD8o3NrkIU9kX7RhhvluSitpfmR
         abPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779154085; x=1779758885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Mx0oFUKOV8XCrLOMX8VahRqZqhy0/sjUBJqBWDg1Dmg=;
        b=G4YZhmchULgx6Dug7HLvn19XJYt3Ouy6FVsz3W+1JMAP1/lJ5fIiCZrPWlhC4u9cRA
         eJ9sbrnMZcfxmbLhhS9Oy7V/yDhLf/i9mvXGNUz8hn+Ksp4fKzCVMUxFecFaa86zFWux
         c7ZxFf14yCTTCkj/sTF0//x9bb1r8Q0Rd4FwnM43AOcMUzJ+h873ZAwvBFSiWwcLUaYw
         joRfzuZZRh/+8+YaKggY4riYs1GeJ605AiiOB3FdzvD5wWftrFU9eMKowbi127TfK3Kh
         eZi8LJwQjC321Wqz/XvIz5RECZWTBvYsxDjxTZMhbxLDwMWq3t1yebYLZtvZe2b9pYZO
         MtJw==
X-Forwarded-Encrypted: i=1; AFNElJ+ypsXw/yN4VmbGvEK/HUe37g7hKdLZJpjklNCxqaoR9YJM8dMuNe0iOtXT8ULOcnnZ6Cr4Db1L7w==@kvack.org
X-Gm-Message-State: AOJu0YxlnBRz/u/wxfXENdfYMdbAweVqoHwJXn39dRJQJ2GjTIrAwVyN
	5KMW1mTGY0m28AI7MRVrlO2/k1peOkqIBPveBNcqkh8BBKhV89fmMKDh
X-Gm-Gg: Acq92OEQdRBgB9IuGkBBsg2dIPQT2U9rv4uUoXGF+9MF+TWVZB8qr8V8OYOB6Vd+6vK
	A8c40H7qI6BwFFo1UV37+g/MS+yb5Nt44gPt+1mBsoAokWAVX5EjCTjwh/jPPcR+Hbdr0QRh1O1
	9p7Qb8W5viJRCmhTFa53G1FmEWoircHNsv+s4xf2gK3EDqz/CHZH/GVC37Dzu1dAB0/4UanYpFp
	cszhTYH+NbpP1yBDbVJJbQfj+Z4GLuctUrYEpjgUxmQMBf5hxZq5/rc/ttuiwELwti5oPOGx9AR
	XXzjrgAxrhxcL3uegRN9bx6TLAp47Wk+BjWdD2+r2KpZa9r5RwVLznnnrjoLfRn16/uWtsW3/99
	ePAx0L81MObFhFG+T1SSSY7rQMVbbxtpp+DXh5W7uWbVUR/VkcdX05brxKCiX8Hyi5docDujfbu
	5dU0XOwS4/8KYyfDr1h8UmmqgVaBI1OA==
X-Received: by 2002:a05:6000:401e:b0:449:c5e2:a8b7 with SMTP id ffacd0b85a97d-45e5c59ec1cmr26953205f8f.30.1779154084539;
        Mon, 18 May 2026 18:28:04 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f83:8501:800:cd4:5e2:9556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9ed2f738sm40548683f8f.16.2026.05.18.18.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 18:28:03 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Leonardo Bras <leobras.c@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>,
	Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Coiby Xu <coxu@redhat.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v4 4/4] slub: apply new pw_queue_on() interface
Date: Mon, 18 May 2026 22:27:50 -0300
Message-ID: <20260519012754.240804-5-leobras.c@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260519012754.240804-1-leobras.c@gmail.com>
References: <20260519012754.240804-1-leobras.c@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=29095; i=leobras.c@gmail.com; h=from:subject; bh=8q9feMK42IfvEu2tWg1UBCdmj8KxKXE5X0orIY01H4k=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLK494R/udDBw8uy/TbzSS6JFZ0Mb99Gnn3dxnln8aP/W SFHImped5SyMIhxMciKKbLIPpq/iuf7lIwjV34sgJnDygQyhIGLUwAmwq7OyHDJu2QN67bJX6NK hJ2mJd3Ys5BpwvwkD81a/c6wF48FOvMYGb5+dqwVkmau9nJqYI91quYvSnU/Maf5b0lBm+oE7+/ rWAE=
X-Developer-Key: i=leobras.c@gmail.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2CF8A180008
X-Stat-Signature: bkjc7d387kti3nncucp9yecspfexu4d8
X-Rspam-User: 
X-HE-Tag: 1779154085-702416
X-HE-Meta: U2FsdGVkX186yHd86T6tEAoP+QtuK/GaTHrZQGW/QyJDFWRZi0Z7fJ2K8pkKPaAWz1S2ov8XOCoSHwgQ7JsMBMVIBYOXj05TYbjO5/d6bqTAyxcm1pyCXFoeBecEOPbsu15j4qzqCao9/Gw0XjDV3/jHr/uhS6D1ZNOcHIj5/BkkDyOsZDFH1pKNSm861h69zLGCBm7gZJQPgKNLr7/uDbgRWFfYZIUiefaKWlaQs5rSlnLF0B9GgrVKvujtEt7soxC02TAJDbcqzE54j0GQNVzh8QwHingcQYbQ8BY889JPw5HKX5OcOXVXE2xmcqTE3Rls1VVJoxfUBI14extzTb/uH9xslCbMUUO1P6Wmf8l2IQVSchzF7T0InSPUI7M955cMxwDgL2AQSQsiQKbUsZuW8uitYw+p/utN9SCG6dv1TUx3VpXO4YUZ/jwXbKXqrfcUXjuLu7qGdWPpMHdvk0IbwOZvk1GbKqJ4W/epA4NvD9v2pZdrDYgW5483eFcrtUTBw7wyDbdQNnlKObJfBJflCsc431GKw32aLTRASVzKmO9kJDzSea37xGU1PofVMFbOSfLXU6rO5jHIqvwbXP6gCzJ/97As7b+I3jj/YIgI/yf786RTEqZYcU8BOBBYfXuyJvUmoZrs73FRrn0pBbiGBDaS8XpSUJclhrS3o/RCGQtEk04/yxtKosyvUlFdmc5tPG7O3HThL1W0A2lx0G6l8oKVLaMj6znfE49zWvXDL8Wj6M0TwYIVanUtGCqSK/06BNhyn4d286+yQQtpu9vk//4hLIX+5PQX+hFg6lnoupFJZgbHi5Cnzg3zPowLoh/iOaotSFNq319nVRygLBJyv+PGWrguAk3fDgu6VuR4M8JpCHX9VDibs5K7b9u36bLG/Ibl9dQL2UXhdqfBXrHeZShUvRwmrQXPDI5c0UmxDleLKUCyXwnA8H1BMQXs+JbjbqGfLokAxwAzX8U
 sMKM3Mym
 HNan9VCOfT9Ozv5ASBaT5E2McAuqxPXgWJhJS8IygVZLD9NvRenCHDEQgU8UZtJVn74Wq1Y97Dup5pX3z1QyxRosFrsTZ2R3OWGifY7bcDLZFf5Dv20bzRoq5p0oiWdtd1eqPwa2duZj445iZ/Kxr4hYblIp70Mab49R+BZhV2TaMBwa10OIMVFEJ0RTuWNQmdYQ8TnXACejVuAduEKl0jf9AwBBuphpl8kNEj3t7U8OGTGAmDaL3DgIxfJFTR3I6d2iYmzhFvI+4S471rZJjssGv8hSFIr6V2VTEYAXKOl1SxEwvCxaw7AJVqs8SU41JE0UkFqYRohVvtXdrilEw5n3K+y6B5IyDal4qtJhITJlaiIyOwjYt5wgLgA1qDy5Ab2Kn9QqwS0rS0AMv2ZQ4mNGQm0+PcSKUYshGnzWJ6ywEQ11g1YPXtOMqDaGIc9e4EF10YvTeAwccr5AZKdPjJioVDOUuvU+CJeZYiUv+UASqYxhvM217/FR01+01hqKY8zkOi/87CwXtFKWmi4tRvKt746ornyhsMpHpJd3SGhaw6/IncdZdLPXWZlt2aH1S+mBpU5YAc1SqMnaOUuTUpT42Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make use of the new pw_{un,}lock*() and pw_queue_on() interface to improve
performance & latency.

For functions that may be scheduled in a different cpu, replace
local_{un,}lock*() by pw_{un,}lock*(), and replace schedule_work_on() by
pw_queue_on(). The same happens for flush_work() and pw_flush().

This change requires allocation of pw_structs instead of a work_structs,
and changing parameters of a few functions to include the cpu parameter.

This should bring no relevant performance impact on non-PWLOCKS kernels:
For functions that may be scheduled in a different cpu, the local_*lock's
this_cpu_ptr() becomes a per_cpu_ptr(smp_processor_id()).

Signed-off-by: Leonardo Bras <leobras.c@gmail.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 mm/slub.c | 142 +++++++++++++++++++++++++++---------------------------
 1 file changed, 72 insertions(+), 70 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8f9004536729..a154d20e78f7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -43,20 +43,21 @@
 #include <linux/prefetch.h>
 #include <linux/memcontrol.h>
 #include <linux/random.h>
 #include <linux/prandom.h>
 #include <kunit/test.h>
 #include <kunit/test-bug.h>
 #include <linux/sort.h>
 #include <linux/irq_work.h>
 #include <linux/kprobes.h>
 #include <linux/debugfs.h>
+#include <linux/pwlocks.h>
 #include <trace/events/kmem.h>
 
 #include "internal.h"
 
 /*
  * Lock order:
  *   0.  cpu_hotplug_lock
  *   1.  slab_mutex (Global Mutex)
  *   2a. kmem_cache->cpu_sheaves->lock (Local trylock)
  *   2b. barn->lock (Spinlock)
@@ -122,21 +123,21 @@
  *   (Note that the total number of slabs is an atomic value that may be
  *   modified without taking the list lock).
  *
  *   The list_lock is a centralized lock and thus we avoid taking it as
  *   much as possible. As long as SLUB does not have to handle partial
  *   slabs, operations can continue without any centralized lock.
  *
  *   For debug caches, all allocations are forced to go through a list_lock
  *   protected region to serialize against concurrent validation.
  *
- *   cpu_sheaves->lock (local_trylock)
+ *   cpu_sheaves->lock (pw_trylock)
  *
  *   This lock protects fastpath operations on the percpu sheaves. On !RT it
  *   only disables preemption and does no atomic operations. As long as the main
  *   or spare sheaf can handle the allocation or free, there is no other
  *   overhead.
  *
  *   barn->lock (spinlock)
  *
  *   This lock protects the operations on per-NUMA-node barn. It can quickly
  *   serve an empty or full sheaf if available, and avoid more expensive refill
@@ -150,21 +151,21 @@
  *   cmpxchg_double this is done by a lockless update of slab's freelist and
  *   counters, otherwise slab_lock is taken. This only needs to take the
  *   list_lock if it's a first free to a full slab, or when a slab becomes empty
  *   after the free.
  *
  *   irq, preemption, migration considerations
  *
  *   Interrupts are disabled as part of list_lock or barn lock operations, or
  *   around the slab_lock operation, in order to make the slab allocator safe
  *   to use in the context of an irq.
- *   Preemption is disabled as part of local_trylock operations.
+ *   Preemption is disabled as part of pw_trylock operations.
  *   kmalloc_nolock() and kfree_nolock() are safe in NMI context but see
  *   their limitations.
  *
  * SLUB assigns two object arrays called sheaves for caching allocations and
  * frees on each cpu, with a NUMA node shared barn for balancing between cpus.
  * Allocations and frees are primarily served from these sheaves.
  *
  * Slabs with free elements are kept on a partial list and during regular
  * operations no list for full slabs is used. If an object in a full slab is
  * freed then the slab will show up again on the partial lists.
@@ -411,21 +412,21 @@ struct slab_sheaf {
 			bool pfmemalloc;
 		};
 	};
 	struct kmem_cache *cache;
 	unsigned int size;
 	int node; /* only used for rcu_sheaf */
 	void *objects[];
 };
 
 struct slub_percpu_sheaves {
-	local_trylock_t lock;
+	pw_trylock_t lock;
 	struct slab_sheaf *main; /* never NULL when unlocked */
 	struct slab_sheaf *spare; /* empty or full, may be NULL */
 	struct slab_sheaf *rcu_free; /* for batching kfree_rcu() */
 };
 
 /*
  * The slab lists for all objects.
  */
 struct kmem_cache_node {
 	spinlock_t list_lock;
@@ -477,21 +478,21 @@ static nodemask_t slab_nodes;
  * Corresponds to N_ONLINE nodes.
  */
 static nodemask_t slab_barn_nodes;
 
 /*
  * Workqueue used for flushing cpu and kfree_rcu sheaves.
  */
 static struct workqueue_struct *flushwq;
 
 struct slub_flush_work {
-	struct work_struct work;
+	struct pw_struct pw;
 	struct kmem_cache *s;
 	bool skip;
 };
 
 static DEFINE_MUTEX(flush_lock);
 static DEFINE_PER_CPU(struct slub_flush_work, slub_flush);
 
 /********************************************************************
  * 			Core slab cache functions
  *******************************************************************/
@@ -2838,74 +2839,74 @@ static void __kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p);
  * Free all objects from the main sheaf. In order to perform
  * __kmem_cache_free_bulk() outside of cpu_sheaves->lock, work in batches where
  * object pointers are moved to a on-stack array under the lock. To bound the
  * stack usage, limit each batch to PCS_BATCH_MAX.
  *
  * Must be called with s->cpu_sheaves->lock locked, returns with the lock
  * unlocked.
  *
  * Returns how many objects are remaining to be flushed
  */
-static unsigned int __sheaf_flush_main_batch(struct kmem_cache *s)
+static unsigned int __sheaf_flush_main_batch(struct kmem_cache *s, int cpu)
 {
 	struct slub_percpu_sheaves *pcs;
 	unsigned int batch, remaining;
 	void *objects[PCS_BATCH_MAX];
 	struct slab_sheaf *sheaf;
 
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
-
-	pcs = this_cpu_ptr(s->cpu_sheaves);
+	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 	sheaf = pcs->main;
 
 	batch = min(PCS_BATCH_MAX, sheaf->size);
 
 	sheaf->size -= batch;
 	memcpy(objects, sheaf->objects + sheaf->size, batch * sizeof(void *));
 
 	remaining = sheaf->size;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	pw_unlock(&s->cpu_sheaves->lock, cpu);
 
 	__kmem_cache_free_bulk(s, batch, &objects[0]);
 
 	stat_add(s, SHEAF_FLUSH, batch);
 
 	return remaining;
 }
 
-static void sheaf_flush_main(struct kmem_cache *s)
+static void sheaf_flush_main(struct kmem_cache *s, int cpu)
 {
 	unsigned int remaining;
 
 	do {
-		local_lock(&s->cpu_sheaves->lock);
+		pw_lock(&s->cpu_sheaves->lock, cpu);
 
-		remaining = __sheaf_flush_main_batch(s);
+		remaining = __sheaf_flush_main_batch(s, cpu);
 
 	} while (remaining);
 }
 
 /*
  * Returns true if the main sheaf was at least partially flushed.
  */
 static bool sheaf_try_flush_main(struct kmem_cache *s)
 {
 	unsigned int remaining;
 	bool ret = false;
 
 	do {
-		if (!local_trylock(&s->cpu_sheaves->lock))
+		if (!pw_trylock_local(&s->cpu_sheaves->lock))
 			return ret;
 
 		ret = true;
-		remaining = __sheaf_flush_main_batch(s);
+
+		pw_lockdep_assert_held(&s->cpu_sheaves->lock);
+		remaining = __sheaf_flush_main_batch(s, smp_processor_id());
 
 	} while (remaining);
 
 	return ret;
 }
 
 /*
  * Free all objects from a sheaf that's unused, i.e. not linked to any
  * cpu_sheaves, so we need no locking and batching. The locking is also not
  * necessary when flushing cpu's sheaves (both spare and main) during cpu
@@ -2968,45 +2969,45 @@ static void rcu_free_sheaf_nobarn(struct rcu_head *head)
 
 /*
  * Caller needs to make sure migration is disabled in order to fully flush
  * single cpu's sheaves
  *
  * must not be called from an irq
  *
  * flushing operations are rare so let's keep it simple and flush to slabs
  * directly, skipping the barn
  */
-static void pcs_flush_all(struct kmem_cache *s)
+static void pcs_flush_all(struct kmem_cache *s, int cpu)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *spare, *rcu_free;
 
-	local_lock(&s->cpu_sheaves->lock);
-	pcs = this_cpu_ptr(s->cpu_sheaves);
+	pw_lock(&s->cpu_sheaves->lock, cpu);
+	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
 	spare = pcs->spare;
 	pcs->spare = NULL;
 
 	rcu_free = pcs->rcu_free;
 	pcs->rcu_free = NULL;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	pw_unlock(&s->cpu_sheaves->lock, cpu);
 
 	if (spare) {
 		sheaf_flush_unused(s, spare);
 		free_empty_sheaf(s, spare);
 	}
 
 	if (rcu_free)
 		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
 
-	sheaf_flush_main(s);
+	sheaf_flush_main(s, cpu);
 }
 
 static void __pcs_flush_all_cpu(struct kmem_cache *s, unsigned int cpu)
 {
 	struct slub_percpu_sheaves *pcs;
 
 	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
 	/* The cpu is not executing anymore so we don't need pcs->lock */
 	sheaf_flush_unused(s, pcs->main);
@@ -3942,83 +3943,84 @@ static bool has_pcs_used(int cpu, struct kmem_cache *s)
 
 /*
  * Flush percpu sheaves
  *
  * Called from CPU work handler with migration disabled.
  */
 static void flush_cpu_sheaves(struct work_struct *w)
 {
 	struct kmem_cache *s;
 	struct slub_flush_work *sfw;
+	int cpu = pw_get_cpu(w);
 
-	sfw = container_of(w, struct slub_flush_work, work);
-
+	sfw = &per_cpu(slub_flush, cpu);
 	s = sfw->s;
 
 	if (cache_has_sheaves(s))
-		pcs_flush_all(s);
+		pcs_flush_all(s, cpu);
 }
 
 static void flush_all_cpus_locked(struct kmem_cache *s)
 {
 	struct slub_flush_work *sfw;
 	unsigned int cpu;
 
 	lockdep_assert_cpus_held();
 	mutex_lock(&flush_lock);
 
 	for_each_online_cpu(cpu) {
 		sfw = &per_cpu(slub_flush, cpu);
 		if (!has_pcs_used(cpu, s)) {
 			sfw->skip = true;
 			continue;
 		}
-		INIT_WORK(&sfw->work, flush_cpu_sheaves);
+		INIT_PW(&sfw->pw, flush_cpu_sheaves, cpu);
 		sfw->skip = false;
 		sfw->s = s;
-		queue_work_on(cpu, flushwq, &sfw->work);
+		pw_queue_on(cpu, flushwq, &sfw->pw);
 	}
 
 	for_each_online_cpu(cpu) {
 		sfw = &per_cpu(slub_flush, cpu);
 		if (sfw->skip)
 			continue;
-		flush_work(&sfw->work);
+		pw_flush(&sfw->pw);
 	}
 
 	mutex_unlock(&flush_lock);
 }
 
 static void flush_all(struct kmem_cache *s)
 {
 	cpus_read_lock();
 	flush_all_cpus_locked(s);
 	cpus_read_unlock();
 }
 
 static void flush_rcu_sheaf(struct work_struct *w)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *rcu_free;
 	struct slub_flush_work *sfw;
 	struct kmem_cache *s;
+	int cpu = pw_get_cpu(w);
 
-	sfw = container_of(w, struct slub_flush_work, work);
+	sfw = &per_cpu(slub_flush, cpu);
 	s = sfw->s;
 
-	local_lock(&s->cpu_sheaves->lock);
-	pcs = this_cpu_ptr(s->cpu_sheaves);
+	pw_lock(&s->cpu_sheaves->lock, cpu);
+	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
 	rcu_free = pcs->rcu_free;
 	pcs->rcu_free = NULL;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	pw_unlock(&s->cpu_sheaves->lock, cpu);
 
 	if (rcu_free)
 		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
 }
 
 
 /* needed for kvfree_rcu_barrier() */
 void flush_rcu_sheaves_on_cache(struct kmem_cache *s)
 {
 	struct slub_flush_work *sfw;
@@ -4029,28 +4031,28 @@ void flush_rcu_sheaves_on_cache(struct kmem_cache *s)
 	for_each_online_cpu(cpu) {
 		sfw = &per_cpu(slub_flush, cpu);
 
 		/*
 		 * we don't check if rcu_free sheaf exists - racing
 		 * __kfree_rcu_sheaf() might have just removed it.
 		 * by executing flush_rcu_sheaf() on the cpu we make
 		 * sure the __kfree_rcu_sheaf() finished its call_rcu()
 		 */
 
-		INIT_WORK(&sfw->work, flush_rcu_sheaf);
+		INIT_PW(&sfw->pw, flush_rcu_sheaf, cpu);
 		sfw->s = s;
-		queue_work_on(cpu, flushwq, &sfw->work);
+		pw_queue_on(cpu, flushwq, &sfw->pw);
 	}
 
 	for_each_online_cpu(cpu) {
 		sfw = &per_cpu(slub_flush, cpu);
-		flush_work(&sfw->work);
+		pw_flush(&sfw->pw);
 	}
 
 	mutex_unlock(&flush_lock);
 }
 
 void flush_all_rcu_sheaves(void)
 {
 	struct kmem_cache *s;
 
 	cpus_read_lock();
@@ -4589,36 +4591,36 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
  * unlocked.
  */
 static struct slub_percpu_sheaves *
 __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs, gfp_t gfp)
 {
 	struct slab_sheaf *empty = NULL;
 	struct slab_sheaf *full;
 	struct node_barn *barn;
 	bool allow_spin;
 
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	pw_lockdep_assert_held(&s->cpu_sheaves->lock);
 
 	/* Bootstrap or debug cache, back off */
 	if (unlikely(!cache_has_sheaves(s))) {
-		local_unlock(&s->cpu_sheaves->lock);
+		pw_unlock_local(&s->cpu_sheaves->lock);
 		return NULL;
 	}
 
 	if (pcs->spare && pcs->spare->size > 0) {
 		swap(pcs->main, pcs->spare);
 		return pcs;
 	}
 
 	barn = get_barn(s);
 	if (!barn) {
-		local_unlock(&s->cpu_sheaves->lock);
+		pw_unlock_local(&s->cpu_sheaves->lock);
 		return NULL;
 	}
 
 	allow_spin = gfpflags_allow_spinning(gfp);
 
 	full = barn_replace_empty_sheaf(barn, pcs->main, allow_spin);
 
 	if (full) {
 		stat(s, BARN_GET);
 		pcs->main = full;
@@ -4629,21 +4631,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 
 	if (allow_spin) {
 		if (pcs->spare) {
 			empty = pcs->spare;
 			pcs->spare = NULL;
 		} else {
 			empty = barn_get_empty_sheaf(barn, true);
 		}
 	}
 
-	local_unlock(&s->cpu_sheaves->lock);
+	pw_unlock_local(&s->cpu_sheaves->lock);
 	pcs = NULL;
 
 	if (!allow_spin)
 		return NULL;
 
 	if (!empty) {
 		empty = alloc_empty_sheaf(s, gfp);
 		if (!empty)
 			return NULL;
 	}
@@ -4655,21 +4657,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		 */
 		sheaf_flush_unused(s, empty);
 		free_empty_sheaf(s, empty);
 
 		return NULL;
 	}
 
 	full = empty;
 	empty = NULL;
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!pw_trylock_local(&s->cpu_sheaves->lock))
 		goto barn_put;
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	/*
 	 * If we put any empty or full sheaf to the barn below, it's due to
 	 * racing or being migrated to a different cpu. Breaching the barn's
 	 * sheaf limits should be thus rare enough so just ignore them to
 	 * simplify the recovery.
 	 */
 
@@ -4733,121 +4735,121 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
 
 	/*
 	 * We assume the percpu sheaves contain only local objects although it's
 	 * not completely guaranteed, so we verify later.
 	 */
 	if (unlikely(node_requested && node != numa_mem_id())) {
 		stat(s, ALLOC_NODE_MISMATCH);
 		return NULL;
 	}
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!pw_trylock_local(&s->cpu_sheaves->lock))
 		return NULL;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (unlikely(pcs->main->size == 0)) {
 		pcs = __pcs_replace_empty_main(s, pcs, gfp);
 		if (unlikely(!pcs))
 			return NULL;
 	}
 
 	object = pcs->main->objects[pcs->main->size - 1];
 
 	if (unlikely(node_requested)) {
 		/*
 		 * Verify that the object was from the node we want. This could
 		 * be false because of cpu migration during an unlocked part of
 		 * the current allocation or previous freeing process.
 		 */
 		if (page_to_nid(virt_to_page(object)) != node) {
-			local_unlock(&s->cpu_sheaves->lock);
+			pw_unlock_local(&s->cpu_sheaves->lock);
 			stat(s, ALLOC_NODE_MISMATCH);
 			return NULL;
 		}
 	}
 
 	pcs->main->size--;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	pw_unlock_local(&s->cpu_sheaves->lock);
 
 	stat(s, ALLOC_FASTPATH);
 
 	return object;
 }
 
 static __fastpath_inline
 unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
 				 void **p)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *main;
 	unsigned int allocated = 0;
 	unsigned int batch;
 
 next_batch:
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!pw_trylock_local(&s->cpu_sheaves->lock))
 		return allocated;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (unlikely(pcs->main->size == 0)) {
 
 		struct slab_sheaf *full;
 		struct node_barn *barn;
 
 		if (unlikely(!cache_has_sheaves(s))) {
-			local_unlock(&s->cpu_sheaves->lock);
+			pw_unlock_local(&s->cpu_sheaves->lock);
 			return allocated;
 		}
 
 		if (pcs->spare && pcs->spare->size > 0) {
 			swap(pcs->main, pcs->spare);
 			goto do_alloc;
 		}
 
 		barn = get_barn(s);
 		if (!barn) {
-			local_unlock(&s->cpu_sheaves->lock);
+			pw_unlock_local(&s->cpu_sheaves->lock);
 			return allocated;
 		}
 
 		full = barn_replace_empty_sheaf(barn, pcs->main,
 						gfpflags_allow_spinning(gfp));
 
 		if (full) {
 			stat(s, BARN_GET);
 			pcs->main = full;
 			goto do_alloc;
 		}
 
 		stat(s, BARN_GET_FAIL);
 
-		local_unlock(&s->cpu_sheaves->lock);
+		pw_unlock_local(&s->cpu_sheaves->lock);
 
 		/*
 		 * Once full sheaves in barn are depleted, let the bulk
 		 * allocation continue from slab pages, otherwise we would just
 		 * be copying arrays of pointers twice.
 		 */
 		return allocated;
 	}
 
 do_alloc:
 
 	main = pcs->main;
 	batch = min(size, main->size);
 
 	main->size -= batch;
 	memcpy(p, main->objects + main->size, batch * sizeof(void *));
 
-	local_unlock(&s->cpu_sheaves->lock);
+	pw_unlock_local(&s->cpu_sheaves->lock);
 
 	stat_add(s, ALLOC_FASTPATH, batch);
 
 	allocated += batch;
 
 	if (batch < size) {
 		p += batch;
 		size -= batch;
 		goto next_batch;
 	}
@@ -5017,40 +5019,40 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 					     &sheaf->objects[0])) {
 			kfree(sheaf);
 			return NULL;
 		}
 
 		sheaf->size = size;
 
 		return sheaf;
 	}
 
-	local_lock(&s->cpu_sheaves->lock);
+	pw_lock_local(&s->cpu_sheaves->lock);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (pcs->spare) {
 		sheaf = pcs->spare;
 		pcs->spare = NULL;
 		stat(s, SHEAF_PREFILL_FAST);
 	} else {
 		barn = get_barn(s);
 
 		stat(s, SHEAF_PREFILL_SLOW);
 		if (barn)
 			sheaf = barn_get_full_or_empty_sheaf(barn);
 		if (sheaf && sheaf->size)
 			stat(s, BARN_GET);
 		else
 			stat(s, BARN_GET_FAIL);
 	}
 
-	local_unlock(&s->cpu_sheaves->lock);
+	pw_unlock_local(&s->cpu_sheaves->lock);
 
 
 	if (!sheaf)
 		sheaf = alloc_empty_sheaf(s, gfp);
 
 	if (sheaf) {
 		sheaf->capacity = s->sheaf_capacity;
 		sheaf->pfmemalloc = false;
 
 		if (sheaf->size < size &&
@@ -5080,31 +5082,31 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	struct slub_percpu_sheaves *pcs;
 	struct node_barn *barn;
 
 	if (unlikely((sheaf->capacity != s->sheaf_capacity)
 		     || sheaf->pfmemalloc)) {
 		sheaf_flush_unused(s, sheaf);
 		kfree(sheaf);
 		return;
 	}
 
-	local_lock(&s->cpu_sheaves->lock);
+	pw_lock_local(&s->cpu_sheaves->lock);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 	barn = get_barn(s);
 
 	if (!pcs->spare) {
 		pcs->spare = sheaf;
 		sheaf = NULL;
 		stat(s, SHEAF_RETURN_FAST);
 	}
 
-	local_unlock(&s->cpu_sheaves->lock);
+	pw_unlock_local(&s->cpu_sheaves->lock);
 
 	if (!sheaf)
 		return;
 
 	stat(s, SHEAF_RETURN_SLOW);
 
 	/*
 	 * If the barn has too many full sheaves or we fail to refill the sheaf,
 	 * simply flush and free it.
 	 */
@@ -5627,21 +5629,21 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
  * An alternative scenario that gets us here is when we fail
  * barn_replace_full_sheaf(), because there's no empty sheaf available in the
  * barn, so we had to allocate it by alloc_empty_sheaf(). But because we saw the
  * limit on full sheaves was not exceeded, we assume it didn't change and just
  * put the full sheaf there.
  */
 static void __pcs_install_empty_sheaf(struct kmem_cache *s,
 		struct slub_percpu_sheaves *pcs, struct slab_sheaf *empty,
 		struct node_barn *barn)
 {
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	pw_lockdep_assert_held(&s->cpu_sheaves->lock);
 
 	/* This is what we expect to find if nobody interrupted us. */
 	if (likely(!pcs->spare)) {
 		pcs->spare = pcs->main;
 		pcs->main = empty;
 		return;
 	}
 
 	/*
 	 * Unlikely because if the main sheaf had space, we would have just
@@ -5678,31 +5680,31 @@ static void __pcs_install_empty_sheaf(struct kmem_cache *s,
  */
 static struct slub_percpu_sheaves *
 __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 			bool allow_spin)
 {
 	struct slab_sheaf *empty;
 	struct node_barn *barn;
 	bool put_fail;
 
 restart:
-	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	pw_lockdep_assert_held(&s->cpu_sheaves->lock);
 
 	/* Bootstrap or debug cache, back off */
 	if (unlikely(!cache_has_sheaves(s))) {
-		local_unlock(&s->cpu_sheaves->lock);
+		pw_unlock_local(&s->cpu_sheaves->lock);
 		return NULL;
 	}
 
 	barn = get_barn(s);
 	if (!barn) {
-		local_unlock(&s->cpu_sheaves->lock);
+		pw_unlock_local(&s->cpu_sheaves->lock);
 		return NULL;
 	}
 
 	put_fail = false;
 
 	if (!pcs->spare) {
 		empty = barn_get_empty_sheaf(barn, allow_spin);
 		if (empty) {
 			pcs->spare = pcs->main;
 			pcs->main = empty;
@@ -5725,107 +5727,107 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	}
 
 	/* sheaf_flush_unused() doesn't support !allow_spin */
 	if (PTR_ERR(empty) == -E2BIG && allow_spin) {
 		/* Since we got here, spare exists and is full */
 		struct slab_sheaf *to_flush = pcs->spare;
 
 		stat(s, BARN_PUT_FAIL);
 
 		pcs->spare = NULL;
-		local_unlock(&s->cpu_sheaves->lock);
+		pw_unlock_local(&s->cpu_sheaves->lock);
 
 		sheaf_flush_unused(s, to_flush);
 		empty = to_flush;
 		goto got_empty;
 	}
 
 	/*
 	 * We could not replace full sheaf because barn had no empty
 	 * sheaves. We can still allocate it and put the full sheaf in
 	 * __pcs_install_empty_sheaf(), but if we fail to allocate it,
 	 * make sure to count the fail.
 	 */
 	put_fail = true;
 
 alloc_empty:
-	local_unlock(&s->cpu_sheaves->lock);
+	pw_unlock_local(&s->cpu_sheaves->lock);
 
 	/*
 	 * alloc_empty_sheaf() doesn't support !allow_spin and it's
 	 * easier to fall back to freeing directly without sheaves
 	 * than add the support (and to sheaf_flush_unused() above)
 	 */
 	if (!allow_spin)
 		return NULL;
 
 	empty = alloc_empty_sheaf(s, GFP_NOWAIT);
 	if (empty)
 		goto got_empty;
 
 	if (put_fail)
 		 stat(s, BARN_PUT_FAIL);
 
 	if (!sheaf_try_flush_main(s))
 		return NULL;
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!pw_trylock_local(&s->cpu_sheaves->lock))
 		return NULL;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	/*
 	 * we flushed the main sheaf so it should be empty now,
 	 * but in case we got preempted or migrated, we need to
 	 * check again
 	 */
 	if (pcs->main->size == s->sheaf_capacity)
 		goto restart;
 
 	return pcs;
 
 got_empty:
-	if (!local_trylock(&s->cpu_sheaves->lock)) {
+	if (!pw_trylock_local(&s->cpu_sheaves->lock)) {
 		barn_put_empty_sheaf(barn, empty);
 		return NULL;
 	}
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 	__pcs_install_empty_sheaf(s, pcs, empty, barn);
 
 	return pcs;
 }
 
 /*
  * Free an object to the percpu sheaves.
  * The object is expected to have passed slab_free_hook() already.
  */
 static __fastpath_inline
 bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
 {
 	struct slub_percpu_sheaves *pcs;
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!pw_trylock_local(&s->cpu_sheaves->lock))
 		return false;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (unlikely(pcs->main->size == s->sheaf_capacity)) {
 
 		pcs = __pcs_replace_full_main(s, pcs, allow_spin);
 		if (unlikely(!pcs))
 			return false;
 	}
 
 	pcs->main->objects[pcs->main->size++] = object;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	pw_unlock_local(&s->cpu_sheaves->lock);
 
 	stat(s, FREE_FASTPATH);
 
 	return true;
 }
 
 static void rcu_free_sheaf(struct rcu_head *head)
 {
 	struct slab_sheaf *sheaf;
 	struct node_barn *barn = NULL;
@@ -5898,63 +5900,63 @@ static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
 bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *rcu_sheaf;
 
 	if (WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT)))
 		return false;
 
 	lock_map_acquire_try(&kfree_rcu_sheaf_map);
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!pw_trylock_local(&s->cpu_sheaves->lock))
 		goto fail;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (unlikely(!pcs->rcu_free)) {
 
 		struct slab_sheaf *empty;
 		struct node_barn *barn;
 
 		/* Bootstrap or debug cache, fall back */
 		if (unlikely(!cache_has_sheaves(s))) {
-			local_unlock(&s->cpu_sheaves->lock);
+			pw_unlock_local(&s->cpu_sheaves->lock);
 			goto fail;
 		}
 
 		if (pcs->spare && pcs->spare->size == 0) {
 			pcs->rcu_free = pcs->spare;
 			pcs->spare = NULL;
 			goto do_free;
 		}
 
 		barn = get_barn(s);
 		if (!barn) {
-			local_unlock(&s->cpu_sheaves->lock);
+			pw_unlock_local(&s->cpu_sheaves->lock);
 			goto fail;
 		}
 
 		empty = barn_get_empty_sheaf(barn, true);
 
 		if (empty) {
 			pcs->rcu_free = empty;
 			goto do_free;
 		}
 
-		local_unlock(&s->cpu_sheaves->lock);
+		pw_unlock_local(&s->cpu_sheaves->lock);
 
 		empty = alloc_empty_sheaf(s, GFP_NOWAIT);
 
 		if (!empty)
 			goto fail;
 
-		if (!local_trylock(&s->cpu_sheaves->lock)) {
+		if (!pw_trylock_local(&s->cpu_sheaves->lock)) {
 			barn_put_empty_sheaf(barn, empty);
 			goto fail;
 		}
 
 		pcs = this_cpu_ptr(s->cpu_sheaves);
 
 		if (unlikely(pcs->rcu_free))
 			barn_put_empty_sheaf(barn, empty);
 		else
 			pcs->rcu_free = empty;
@@ -5971,27 +5973,27 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 	rcu_sheaf->objects[rcu_sheaf->size++] = obj;
 
 	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
 		rcu_sheaf = NULL;
 	} else {
 		pcs->rcu_free = NULL;
 		rcu_sheaf->node = numa_node_id();
 	}
 
 	/*
-	 * we flush before local_unlock to make sure a racing
+	 * we flush before pw_unlock_local to make sure a racing
 	 * flush_all_rcu_sheaves() doesn't miss this sheaf
 	 */
 	if (rcu_sheaf)
 		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
 
-	local_unlock(&s->cpu_sheaves->lock);
+	pw_unlock_local(&s->cpu_sheaves->lock);
 
 	stat(s, FREE_RCU_SHEAF);
 	lock_map_release(&kfree_rcu_sheaf_map);
 	return true;
 
 fail:
 	stat(s, FREE_RCU_SHEAF_FAIL);
 	lock_map_release(&kfree_rcu_sheaf_map);
 	return false;
 }
@@ -6082,21 +6084,21 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 			continue;
 		}
 
 		i++;
 	}
 
 	if (!size)
 		goto flush_remote;
 
 next_batch:
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!pw_trylock_local(&s->cpu_sheaves->lock))
 		goto fallback;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (likely(pcs->main->size < s->sheaf_capacity))
 		goto do_free;
 
 	barn = get_barn(s);
 	if (!barn)
 		goto no_empty;
@@ -6125,37 +6127,37 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	stat(s, BARN_PUT);
 	pcs->main = empty;
 
 do_free:
 	main = pcs->main;
 	batch = min(size, s->sheaf_capacity - main->size);
 
 	memcpy(main->objects + main->size, p, batch * sizeof(void *));
 	main->size += batch;
 
-	local_unlock(&s->cpu_sheaves->lock);
+	pw_unlock_local(&s->cpu_sheaves->lock);
 
 	stat_add(s, FREE_FASTPATH, batch);
 
 	if (batch < size) {
 		p += batch;
 		size -= batch;
 		goto next_batch;
 	}
 
 	if (remote_nr)
 		goto flush_remote;
 
 	return;
 
 no_empty:
-	local_unlock(&s->cpu_sheaves->lock);
+	pw_unlock_local(&s->cpu_sheaves->lock);
 
 	/*
 	 * if we depleted all empty sheaves in the barn or there are too
 	 * many full sheaves, free the rest to slab pages
 	 */
 fallback:
 	__kmem_cache_free_bulk(s, size, p);
 	stat_add(s, FREE_SLOWPATH, size);
 
 flush_remote:
@@ -7554,21 +7556,21 @@ static inline int alloc_kmem_cache_stats(struct kmem_cache *s)
 static int init_percpu_sheaves(struct kmem_cache *s)
 {
 	static struct slab_sheaf bootstrap_sheaf = {};
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
 		struct slub_percpu_sheaves *pcs;
 
 		pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
-		local_trylock_init(&pcs->lock);
+		pw_trylock_init(&pcs->lock);
 
 		/*
 		 * Bootstrap sheaf has zero size so fast-path allocation fails.
 		 * It has also size == s->sheaf_capacity, so fast-path free
 		 * fails. In the slow paths we recognize the situation by
 		 * checking s->sheaf_capacity. This allows fast paths to assume
 		 * s->cpu_sheaves and pcs->main always exists and are valid.
 		 * It's also safe to share the single static bootstrap_sheaf
 		 * with zero-sized objects array as it's never modified.
 		 *
-- 
2.54.0


