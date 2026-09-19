Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A3BAC982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 13:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EA416B008C; Sat, 19 Sep 2026 09:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49A816B0092; Sat, 19 Sep 2026 09:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362AD6B0095; Sat, 19 Sep 2026 09:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09AF66B008C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 09:54:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8FF9EC027F
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 13:54:20 +0000 (UTC)
X-FDA: 85230656280.19.663B8E9
Received: from mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf23.hostedemail.com (Postfix) with ESMTP id 14CC6140006
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 13:54:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZTG3CoCs;
	spf=pass (imf23.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789826058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqfDG4k5JTeMOBTZkf5CyX5+rM0cvpC9W4QM6kxTSso=;
	b=HqnJmhLUb2rV+k/SdYJJhb00ZSCtq1iLY82SKq/q08HDZBSn74KVuQXSUhlYVvo6yreLi5
	ak5BiHkdeQBrz4OLiLs0K819OQDMwJwy8WztzVjBCre7LMmWILnfpi8kOG8eKtDUd3jx5L
	v/6a2au/GWu867BKXm+XUJY0LsNL11Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZTG3CoCs;
	spf=pass (imf23.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789826058;
	b=jqXeIRED9fCCthqtLDe2T/Oh7EQzMlg6NKAcJOaL4k/aR+PncrTZn3hwtDN8XMfE8MBwPT
	uiokOUfZMoXv+2aiuTkE5zOUDuz1knwMyiibCHTkRDveG+2hOsoLX5Ax3b+NJrxKFF3VCC
	Dg3ehOVX2an7gqAKh1k1nvUg+z6arQA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NvPx8OfXlBjTydmRGXNV9+CIy/MtUUq+PQTUgas3+4I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789826052; v=1; x=1790430852;
 b=ZTG3CoCsa9r3QMVkwNds/OYUf/TlyIdu8tIG0g/oUNI0b0qb9CyVJ2MG8jL4qRzia+u8bscs
 7p1IooO8Aqd4Fc0DMJNhdWJPRm5DwcV7OFiahImZjBssyMVnS42EjbZIa5oYsrfRlPZW6VEXUAn
 Pnm4oOr72qMeqZ5SCIxIdO4k=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 51be81c82004f823;
	Sat, 19 Sep 2026 13:54:12 +0000
X-Mizu-Trace-ID: 51be81c82004f823
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>
Cc: Priyanshu Kumar <priyanshukumarpu@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v2 3/3] memblock: Remove unused memblock_alloc_exact_nid_raw()
Date: Sat, 19 Sep 2026 21:53:27 +0800
Message-ID: <20260919135327.74089-4-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260919135327.74089-1-kaitao.cheng@linux.dev>
References: <20260919135327.74089-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 14CC6140006
X-Stat-Signature: j99defg3smp1yt7gczuim9qmufk9p33m
X-Rspam-User: 
X-HE-Tag: 1789826056-322299
X-HE-Meta: U2FsdGVkX1/lriM00hGs+8AGp1bbxZwnm9sQtKR35BHDAPAXndOZv26Y7Es9nt7hVIhKceoH8rp7UkIuKHdqzby3y1PSWSxIDlGGNSFdXVzm69M2IIbPGyOeD7vL2IDB2+XRpZLW7Ssa7jbzgIIFerqNEztYgb3ubxEGyFHjcihYqhCGt+ft4Iaqz+EmUY2KNmDLSHuIFrNaPQWnzcJLXoTktIy/s29FlvEbuUd7+2Y/h1r3PNadsGtJ4RGqZEGb47tDjTN/HY4PT4BosY353TZABCAoHNAMSpLoTuACzjRB7SMOYxlWCuNto3mvrTUab4gzZt/d9i7Tx0bIJT0z1FjD8qlfa4HG4YhkaNmt8/k9kx0LOQ5RuYj9JHmiYae3NW4QX+WLMeb5wjYC1xkACCM45g4rAiZQD1O+aEqnEBOcZPiFjlrZeeDuki2d/g43Y8jbOdoqABI+XXPYqt8qvPWmNx2hCd8+TEDaNCfT1JuFCKN83Zo9Q6bwnQqJwva+yuQB5N/ki64ymCtZJo+MTCODpaBstk3e7hLN6M6LKoV8/RYawsue5b6KArT9xEdbxDJUjRqScuJ8kBwSwG2vLNaRGTFZIXPcZstSaMVeUGUKe1dARLXJR+ZkBy3hatchu16/cVdUil7yeDokUFqLJ7qbGhLxkyaJcdbATXQZqn1BwtkGNzQ9IR8FHWsxT6yEgHn2NIrpaFQMWxynjxAaKFaLbrVMXLiVgbWaQ9Q715cQVNrMCJRWOL+FA4aROmB4feXNAQAKPlnreNpBPBmX0N8V+YOGiSKyHGHCKqs7OO/rECig8BhWuylzzm0Li/CA/WTDo2d/AMKvxRYCtbhFHvmjvuEqm82ZWDr4HIjOYPVjtZarreQW08xXyNbge3cS/BlmKf7Sk0kCTsuDcXwvuRrZsyzQs21KbjAP2gFV9+yroGTXZJvRK5LbXzKlGlNL6MEqBzFkL0pKdoAzTTK
 eopWrOOm
 oLq7y3G39umOEIa26vipkXbL9sykRV4PgxBY5CiIYMZOFo+84gM2/B+cSPgn+LT/z9czEKm7Vd/ghB7De+Az/Qg9quO0kztWX1DE+a0fBYE/7tZPRRsPQU7yiW2yr9O0PFrK+6UdG5oqwd0Wc+wfm+/WmgnYmNcRyhXgNcL0Wms7Q2uGp9E8rAxFvdx3P+6mNIlPHlQJt1MoBndkJrMFsRB8wUs9jvK9PCV7UIW+CJN1XSPjbFo3fO8ofgi+EdtQyZB6blUAY+lPe6lru0saZtRAOYuStHog3fAgRVHljScaeox4=
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


