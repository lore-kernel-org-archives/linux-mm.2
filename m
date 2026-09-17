Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DB0EC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 08:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75EF86B0095; Thu, 17 Sep 2026 04:15:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735EE6B0096; Thu, 17 Sep 2026 04:15:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673C06B0098; Thu, 17 Sep 2026 04:15:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4232E6B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:15:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 83749160225
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:15:50 +0000 (UTC)
X-FDA: 85222545660.20.99890CF
Received: from mta0.migadu.com (out-147.mta0.migadu.com [91.218.175.147])
	by imf25.hostedemail.com (Postfix) with ESMTP id 69700A0009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:15:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oviWyruF;
	spf=pass (imf25.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.147 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789632948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqfDG4k5JTeMOBTZkf5CyX5+rM0cvpC9W4QM6kxTSso=;
	b=iPAwBT9VEotEy3O1UxmTexAqU7LNh3jZ0apu/gYE2neb0EB38VRcvKLAgTSgSkppNfMnHY
	cwEw+Actm4DmNpEQpU3Ts+H/rOWjohr6M4ozVpV0kOuKAlvOKkO3Zb7kc2Hsyq6PrhPzQ7
	8ZJiJRzvFRfoMfoCppBwAEGKapGLUug=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789632948;
	b=I78xwTuR9pC9PUWDj/GZMUHSmhFCj9mztEW7mfsvolYbr/Bx6qUHwsKJKcSUk1lih4yMCD
	kYzYqLU/RataPYq6aI1ykZcJRwGWYJ7NJeuJS82wVeU4g525fNZfX2bej6R/koHYiY4CHD
	ZCBgcJDnX1Nw5QW/euBizjw0Mq+ubqA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oviWyruF;
	spf=pass (imf25.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.147 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NvPx8OfXlBjTydmRGXNV9+CIy/MtUUq+PQTUgas3+4I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789632947; v=1; x=1790237747;
 b=oviWyruF+4T200BNL7mm2/MDkUTTdMb1Fbap8fbhjJqu85qSD/3FQFT9D1ahTNOXPhBYrbDQ
 gsUhsEMpseop1RKZKUwP654Cppeg0Qd6wc5W/xqROu42eLSTmUIeSGDnLxQiS+oBQAXZ+ViiK6A
 hEcInPFIJUViOnXRt3Dfveww=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e159dc0f4017a5ad;
	Thu, 17 Sep 2026 08:15:47 +0000
X-Mizu-Trace-ID: e159dc0f4017a5ad
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Priyanshu Kumar <priyanshukumarpu@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH 2/2] memblock: Remove unused memblock_alloc_exact_nid_raw()
Date: Thu, 17 Sep 2026 16:15:04 +0800
Message-ID: <20260917081504.30426-3-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260917081504.30426-1-kaitao.cheng@linux.dev>
References: <20260917081504.30426-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 69700A0009
X-Stat-Signature: oyc7xah6kh3pfniuixtgz47wde6rxzrh
X-Rspam-User: 
X-HE-Tag: 1789632948-26249
X-HE-Meta: U2FsdGVkX18PXcrTBNjtVWP2Vl2YzrBZy53NTlHkkUeKvaHntgFbEcFGDAvUgWUQa0C8Gcsh+2X1boc4ORenS+FwBg0WmRpPmSwpdl4O3cN/wAgmq/nxPW53S9NxPo8L7t/I7VvPZmxLnLUgz57n27qtkxo3jKB/zf0pQgGMuf8OXvpflynXwow5brv5N6Xr5oNKRIIZpifxWfUfHGsLSv8KUZesH/5b2CFeF7AiIoNlYWn1AmPc8FAnzSXGYBTK1EkGIz2trdGxYZYpM0eqfzkktMk81xriey3AUveRQu0KdM7XHkPgA1+BXp6Ju6+Jfp9BSA8hVVfB47YBHapX/zhz+ZP5Xr/dlVZCCIZNa6cfMOWjWSGTmoTcaDeMJrGoct0AU+bvoopTcMv1BsONOkK9PCKIlt5Zc/1AiC7mxTROKS63hDzNW5fG3yI+God1nBs6rzbccjy/5syAWgoAjhtJioHaegQo6W+kpBHxr2PfxrPEyRMUtIYrluFEglj2f9KIce7vb2o6E5bG2ZlXZ5RflhbVpu31OSRnQ981RFtkwdjNjyvynaVyeNE6K75CXtNe43Msn0hCrYeP0ZlHJJeCbATyNLGG9cwJ4sBp3VltTw1fnYRG0qPVw+CU6VEDsJ44D7xn+evRY8a1Pj19CZzqIsjVZZTCnBOHs5pSvQojlUn6ZkQB+oT6eHu8lVRdwet2WzzLNpMLKbOb2yCYKQ1pTXHonqVMqvAjMIEqlSTQ1X2t8puApM8KvFVqW5kxXrvprkcHwu3o+JhvAzmJbW+IugrgX92DB0ru2BQMbwSz0b/R8+V3BG5IuVLuFamgdEp7mBD11w4OYL64A3vygD2/HY1+iOn5ee1Ovc2yKqZAEYzSHhlVsv8l4sqrPSjyT3biCIde9uXvuCnohReKiCEq8zk/xdcdAfQ9Q+o2d6itKNpYBRBd8SpFNiUrdNJHYo6ds5DywnMB+wXphSJ
 szqTEYc9
 lUxNqgAJcMfvSRMCfpdLZVQly6ID4kzkptPtj0ukedKXob5hnhehkoai1ew59QLOVUnLO+ubtk2e/IG32eD58NNgHuVdrZoSy6sufuJcdBQO0ceVuu+WNZ4SAANFMo0gCYZdif0chZyVZc2vwC9QUNP8YdPVmNxHj8uAEL0+nkszSRDyxF13qy9ogzIbH6VRCkHqqO2tMgex4s4MAyb009dgqW+sKvVIoUYNo0pR6DBFks5yIF073DeE0sUjeFgLutGATjgeLRRPwW4jukt+C0M4WGtRfxz8STDIsgTbOWjB4xi0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

memmap_alloc() was the only in-kernel caller of
memblock_alloc_exact_nid_raw(). After removing its unused exact_nid
argument, the function no longer has any callers.

Remove memblock_alloc_exact_nid_raw() and its declaration. The remaining
callers of memblock_alloc_internal() always allow allocation to fall back
to other NUMA nodes, so remove its exact_nid argument and pass false
directly to memblock_alloc_range_nid().

Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 include/linux/memblock.h |  3 ---
 mm/memblock.c            | 44 +++++-----------------------------------
 2 files changed, 5 insertions(+), 42 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index aa845f488327..01a2dea5aa11 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -412,9 +412,6 @@ static __always_inline phys_addr_t memblock_phys_alloc(phys_addr_t size,
 					 MEMBLOCK_ALLOC_ACCESSIBLE);
 }
 
-void *memblock_alloc_exact_nid_raw(phys_addr_t size, phys_addr_t align,
-				 phys_addr_t min_addr, phys_addr_t max_addr,
-				 int nid);
 void *memblock_alloc_try_nid_raw(phys_addr_t size, phys_addr_t align,
 				 phys_addr_t min_addr, phys_addr_t max_addr,
 				 int nid);
diff --git a/mm/memblock.c b/mm/memblock.c
index 22d14a637f24..51f816ce0cd9 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1659,7 +1659,6 @@ phys_addr_t __init memblock_phys_alloc_try_nid(phys_addr_t size, phys_addr_t ali
  * @min_addr: the lower bound of the memory region to allocate (phys address)
  * @max_addr: the upper bound of the memory region to allocate (phys address)
  * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
- * @exact_nid: control the allocation fall back to other nodes
  *
  * Allocates memory block using memblock_alloc_range_nid() and
  * converts the returned physical address to virtual.
@@ -1675,7 +1674,7 @@ phys_addr_t __init memblock_phys_alloc_try_nid(phys_addr_t size, phys_addr_t ali
 static void * __init memblock_alloc_internal(
 				phys_addr_t size, phys_addr_t align,
 				phys_addr_t min_addr, phys_addr_t max_addr,
-				int nid, bool exact_nid)
+				int nid)
 {
 	phys_addr_t alloc;
 
@@ -1684,12 +1683,12 @@ static void * __init memblock_alloc_internal(
 		max_addr = memblock.current_limit;
 
 	alloc = memblock_alloc_range_nid(size, align, min_addr, max_addr, nid,
-					exact_nid);
+					false);
 
 	/* retry allocation without lower limit */
 	if (!alloc && min_addr)
 		alloc = memblock_alloc_range_nid(size, align, 0, max_addr, nid,
-						exact_nid);
+						false);
 
 	if (!alloc)
 		return NULL;
@@ -1697,37 +1696,6 @@ static void * __init memblock_alloc_internal(
 	return phys_to_virt(alloc);
 }
 
-/**
- * memblock_alloc_exact_nid_raw - allocate boot memory block on the exact node
- * without zeroing memory
- * @size: size of memory block to be allocated in bytes
- * @align: alignment of the region and block's size
- * @min_addr: the lower bound of the memory region from where the allocation
- *	  is preferred (phys address)
- * @max_addr: the upper bound of the memory region from where the allocation
- *	      is preferred (phys address), or %MEMBLOCK_ALLOC_ACCESSIBLE to
- *	      allocate only from memory limited by memblock.current_limit value
- * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
- *
- * Public function, provides additional debug information (including caller
- * info), if enabled. Does not zero allocated memory.
- *
- * Return:
- * Virtual address of allocated memory block on success, NULL on failure.
- */
-void * __init memblock_alloc_exact_nid_raw(
-			phys_addr_t size, phys_addr_t align,
-			phys_addr_t min_addr, phys_addr_t max_addr,
-			int nid)
-{
-	memblock_dbg("%s: %llu bytes align=0x%llx nid=%d from=%pa max_addr=%pa %pS\n",
-		     __func__, (u64)size, (u64)align, nid, &min_addr,
-		     &max_addr, (void *)_RET_IP_);
-
-	return memblock_alloc_internal(size, align, min_addr, max_addr, nid,
-				       true);
-}
-
 /**
  * memblock_alloc_try_nid_raw - allocate boot memory block without zeroing
  * memory and without panicking
@@ -1756,8 +1724,7 @@ void * __init memblock_alloc_try_nid_raw(
 		     __func__, (u64)size, (u64)align, nid, &min_addr,
 		     &max_addr, (void *)_RET_IP_);
 
-	return memblock_alloc_internal(size, align, min_addr, max_addr, nid,
-				       false);
+	return memblock_alloc_internal(size, align, min_addr, max_addr, nid);
 }
 
 /**
@@ -1858,8 +1825,7 @@ void * __init memblock_alloc_try_nid(
 	memblock_dbg("%s: %llu bytes align=0x%llx nid=%d from=%pa max_addr=%pa %pS\n",
 		     __func__, (u64)size, (u64)align, nid, &min_addr,
 		     &max_addr, (void *)_RET_IP_);
-	ptr = memblock_alloc_internal(size, align,
-					   min_addr, max_addr, nid, false);
+	ptr = memblock_alloc_internal(size, align, min_addr, max_addr, nid);
 	if (ptr)
 		memset(ptr, 0, size);
 
-- 
2.54.0 (Apple Git-157)


