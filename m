Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CD01CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 09:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37298E001F; Wed,  1 Oct 2025 05:04:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0408E001D; Wed,  1 Oct 2025 05:04:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF098E001F; Wed,  1 Oct 2025 05:04:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C26E68E001D
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 05:04:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 72EFB1407CF
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:04:35 +0000 (UTC)
X-FDA: 83948959710.28.6EA4DD4
Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	by imf20.hostedemail.com (Postfix) with ESMTP id 504B71C0018
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:04:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=gM4RFjSk;
	spf=pass (imf20.hostedemail.com: domain of "prvs=3627e3e53=acsjakub@amazon.de" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=3627e3e53=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759309473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XbjLxHPX3pHS5RC1/ropqG4Thiyj9sqaDWC+ZZ01EUg=;
	b=3WTsI9/Eul44wBeMUmp/skF+m+0AA0H2eQ7kqRqIfxX2zKxEolYv7DGQMbhDSumFAe63uQ
	1rA0l7xT9uOsoIIAwzpVOSOvIBp3efk+RQlMr+PbjqIBNlrKM+7la2166WBs/O0uaDyTQm
	wg8Besx+nZ7oW/LDp6YLRZYq3A37kq0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=gM4RFjSk;
	spf=pass (imf20.hostedemail.com: domain of "prvs=3627e3e53=acsjakub@amazon.de" designates 34.218.115.239 as permitted sender) smtp.mailfrom="prvs=3627e3e53=acsjakub@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759309473; a=rsa-sha256;
	cv=none;
	b=1RXrEHnBjNPI5vM3eV137/5zVKDfra9uXGueYRSXiG8DFSDBSXM4a+TSlM/3Q++ceZPMaK
	dEgV/IYoGyndc5qhSFq432RJlta0YxU63LJCAEJ7QSQIgsMrte55DkOlbF1IOR1WtGOcqT
	T6eEzls/5GoFCsi0EWTKxUd4iFJqPzk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1759309473; x=1790845473;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XbjLxHPX3pHS5RC1/ropqG4Thiyj9sqaDWC+ZZ01EUg=;
  b=gM4RFjSkRrj7sVN+CMULl9/TVLzT70wX98RhGbc/5zDpalgWcwQLTJFX
   HtDrkrLzrikVjOCqXtbhR+Gjw2IPxMOUWgSQYqrSThEm1JX3qPc2dsDw4
   wky8Dj+m+KtoSDXZ2UINUj1ElLy1jUFocV4D48Sh24jDCWseO4OkQ5+Mb
   YkeCCsIXi0ZrO/aP0kaDTSyu+cbZJR8RJ1q4BZhMEI4ENtE5xKfPILkJ6
   NyWz1p7s+nq4Plv70wlnN/2aOoFN+E2D+Ne2Tk6VKEPy2sG1NeWWm1lmE
   tQbVex3Ver52w9jzAWjbfyaj1U3g+GlGv61zjF/EHTMs+XgALyHEfV9Es
   Q==;
X-CSE-ConnectionGUID: qzZB1Dj7RgaxXW/DXso8Yw==
X-CSE-MsgGUID: zU1wXzfmR4CAaKr5nq7jOg==
X-IronPort-AV: E=Sophos;i="6.18,306,1751241600"; 
   d="scan'208";a="3877563"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 09:04:30 +0000
Received: from EX19MTAUWA001.ant.amazon.com [10.0.7.35:19205]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.36.10:2525] with esmtp (Farcaster)
 id 2a1fecd2-3ff4-4d02-9405-1e1b0aa88cbf; Wed, 1 Oct 2025 09:04:30 +0000 (UTC)
X-Farcaster-Flow-ID: 2a1fecd2-3ff4-4d02-9405-1e1b0aa88cbf
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 1 Oct 2025 09:04:30 +0000
Received: from dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com
 (172.19.75.107) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 1 Oct 2025
 09:04:28 +0000
From: Jakub Acs <acsjakub@amazon.de>
To: <linux-mm@kvack.org>
CC: <acsjakub@amazon.de>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <peterx@redhat.com>,
	<axelrasmussen@google.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/2] mm: redefine VM_* flag constants with BIT()
Date: Wed, 1 Oct 2025 09:03:53 +0000
Message-ID: <20251001090353.57523-3-acsjakub@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251001090353.57523-1-acsjakub@amazon.de>
References: <20251001090353.57523-1-acsjakub@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [172.19.75.107]
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 504B71C0018
X-Stat-Signature: tgyi1b48emyq31o8gdjtu4qc8qhbsm36
X-HE-Tag: 1759309473-636812
X-HE-Meta: U2FsdGVkX1/6DQsOPA2JO4aWpPVKkPdzAN1MaOdc/ZvcBi+gP5G3JSBsc0abLYPgaNFiWLGhRAQOqaougAfuZUT0VrmV8OoeAuSnU4IRubtbfpHAp05kkwmndbyzUejLYolNvhyz8Y7810y6Kxcx/mh4s8LOFKcsL800lAXe8yOijGd0IG4vtoMu7aGoSvcugH9jalFAknatjZ7S9HIYvvNENtX8xORo47NjhkzdDdbYTUIPeWnGLk8iawRN7YyBa8bvneYtwT5RlHKmdwXGRwPNG31rb10/Xp8KwlinUkp5SS/IOgPk6PIAbgsPXxUg4/BK9JWiMr29yQBSbETCM5ULiOBJO3DkuOezMdOeH3LVqIsHKnH4AN+zKYPjv+WQiD2t34oDSQPIddYhWdBv4kGfgeJLqMUx8JpA/ldDC40pzdU2mUNspL/zXV7LW2Uzipt3cWCRl0EP36HIsYhHzdojbegZMEJhcKDcBsK9JYOuxoeuaGp757anz03f8tb7QR1Tgvw4FVRq90bikkQ1dbIMTmxgykPaxg+WUI0uzkplHE7SgH/jKsTt27LbqCksFn5zcRg+1YmYdfMcLO+DHRj/1mVOsW0EN8xod7TA5r9vYLtvmusgMbKaTJFDV5I7LAdL5VWUZIo6RuNE0KV8lmrPkYMgTEPYHiMt/dAe66uAUl8FKMWi4ET8hPTURSjK1IrUDjDHVpQ0El+PmSWc4/NquebzvLlQcVU6nWaOPhNL9y+CICuV8A8Mv5BLe7GZQInLiPP+PL3RTd90ZQGyPhH9dRn17CRLWhnmWUs7WT3P6cRU4NQwWOyrcBnsrw4ZyHnsV5u6g7YiPFBGXyCfwezJX7xIgpsUPYTVUs+55bbsBMjy9bT0M/TU7GQTrwE9e6atzA5V7LWRGessDIA5i6hnp0+OySAg57Pl3HPwOWXiQ0bn/0LDBYMuBQeffYe6aBuYgUjhWyZGbIn1eSu
 IBNQPQ1h
 EIgWtrVsQc/3102tWfeocpGe/wFDfuvFa4fkOLDFnJ9dSgi+WGKqwsasiWktGXVejgECFvRVEtwoVWEA8hFY9h3GbR31/6pBu2IJBoXTWCpy/BJAZxLxGhkZdFM8gHOVCYocmRJhRHKAwzIA+bayqiwr12DjN6LsvopTdXbTmFQ6s9tnMl0qJHgXvZLTHxZuRkkXuZYisbzBMWH0B4UAG9tbAVEaIvgFAgcOspUQOSNjQh+UGMY8lXJJUl/vTFEnDIcJI6rQluhsatt2eNsD7ddzS3uy1gEt2PHkYwn9NftJ1WRcqEhGJj7TNbYi6MrODOSZplPNdhjlgzMagVluZbxiCKa8egN6nUfDWG90UvX6ueoE6qlAIQjQ60KwKJPwvZOsNFQ6oYHqjmZmanOXOG6dmhCAoHWLPecKVXlrn9fdYQBALH+m7MZYDsp8COT4TXGakpIGIyPZYaf6e9SGIXzEYzgm5Q6CiEqQdOGgpIN5TvjGLOGQcwAvBtfV50YNGgWycQFqmN9LHALtm1yHWDKxxGX58k7Ax212A4C9w4H6JYaPDDj5UsFxtPzyKlrIO1pmwPtrdJk3KPiLu/dXzuzf+V1jFVs07DGIiw+qcyxIH6AgNVaQHdTrxhVanW1lhco2KFXb3mBTZ7pQHR8K2yANq75jKksQhn0ye/QuGjaaEtjG9Q73TVwLFkJTZr1UsAgMwxzpF1/2xvIQG5mc1nt9DnqM1vvAzlKj4cX1q7My+euI0Eo4fYo2lIOHQ8eC9S+mxABn+dpSUgDEj85k+EGGZEdWMPenLhJGez4CmKfi/jyHhOTqYSIqnHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make VM_* flag constant definitions consistent - unify all to use BIT()
macro.

This is a separete follow-up fix after we changed VM_MERGEABLE
separately to isolate bugfix for easier backporting. As suggested by
David in [1]. 

[1]: https://lore.kernel.org/all/85f852f9-8577-4230-adc7-c52e7f479454@redhat.com/

Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Xu Xin <xu.xin16@zte.com.cn>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 include/linux/mm.h | 66 +++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c6794d0e24eb..88cab3d7eea2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -246,56 +246,56 @@ extern unsigned int kobjsize(const void *objp);
  * vm_flags in vm_area_struct, see mm_types.h.
  * When changing, update also include/trace/events/mmflags.h
  */
-#define VM_NONE		0x00000000
+#define VM_NONE		0
 
-#define VM_READ		0x00000001	/* currently active flags */
-#define VM_WRITE	0x00000002
-#define VM_EXEC		0x00000004
-#define VM_SHARED	0x00000008
+#define VM_READ		BIT(0)		/* currently active flags */
+#define VM_WRITE	BIT(1)
+#define VM_EXEC		BIT(2)
+#define VM_SHARED	BIT(3)
 
 /* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
-#define VM_MAYREAD	0x00000010	/* limits for mprotect() etc */
-#define VM_MAYWRITE	0x00000020
-#define VM_MAYEXEC	0x00000040
-#define VM_MAYSHARE	0x00000080
+#define VM_MAYREAD	BIT(4)		/* limits for mprotect() etc */
+#define VM_MAYWRITE	BIT(5)
+#define VM_MAYEXEC	BIT(6)
+#define VM_MAYSHARE	BIT(7)
 
-#define VM_GROWSDOWN	0x00000100	/* general info on the segment */
+#define VM_GROWSDOWN	BIT(8)		/* general info on the segment */
 #ifdef CONFIG_MMU
-#define VM_UFFD_MISSING	0x00000200	/* missing pages tracking */
+#define VM_UFFD_MISSING	BIT(9)		/* missing pages tracking */
 #else /* CONFIG_MMU */
-#define VM_MAYOVERLAY	0x00000200	/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
+#define VM_MAYOVERLAY	BIT(10)		/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
 #define VM_UFFD_MISSING	0
 #endif /* CONFIG_MMU */
-#define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
-#define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
+#define VM_PFNMAP	BIT(11)		/* Page-ranges managed without "struct page", just pure PFN */
+#define VM_UFFD_WP	BIT(12)		/* wrprotect pages tracking */
 
-#define VM_LOCKED	0x00002000
-#define VM_IO           0x00004000	/* Memory mapped I/O or similar */
+#define VM_LOCKED	BIT(13)
+#define VM_IO           BIT(14)		/* Memory mapped I/O or similar */
 
 					/* Used by sys_madvise() */
-#define VM_SEQ_READ	0x00008000	/* App will access data sequentially */
-#define VM_RAND_READ	0x00010000	/* App will not benefit from clustered reads */
-
-#define VM_DONTCOPY	0x00020000      /* Do not copy this vma on fork */
-#define VM_DONTEXPAND	0x00040000	/* Cannot expand with mremap() */
-#define VM_LOCKONFAULT	0x00080000	/* Lock the pages covered when they are faulted in */
-#define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
-#define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
-#define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
-#define VM_SYNC		0x00800000	/* Synchronous page faults */
-#define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
-#define VM_WIPEONFORK	0x02000000	/* Wipe VMA contents in child. */
-#define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
+#define VM_SEQ_READ	BIT(15)		/* App will access data sequentially */
+#define VM_RAND_READ	BIT(16)		/* App will not benefit from clustered reads */
+
+#define VM_DONTCOPY	BIT(17)		/* Do not copy this vma on fork */
+#define VM_DONTEXPAND	BIT(18)		/* Cannot expand with mremap() */
+#define VM_LOCKONFAULT	BIT(19)		/* Lock the pages covered when they are faulted in */
+#define VM_ACCOUNT	BIT(20)		/* Is a VM accounted object */
+#define VM_NORESERVE	BIT(21)		/* should the VM suppress accounting */
+#define VM_HUGETLB	BIT(22)		/* Huge TLB Page VM */
+#define VM_SYNC		BIT(23)		/* Synchronous page faults */
+#define VM_ARCH_1	BIT(24)		/* Architecture-specific flag */
+#define VM_WIPEONFORK	BIT(25)		/* Wipe VMA contents in child. */
+#define VM_DONTDUMP	BIT(26)		/* Do not include in the core dump */
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
-# define VM_SOFTDIRTY	0x08000000	/* Not soft dirty clean area */
+# define VM_SOFTDIRTY	BIT(27)		/* Not soft dirty clean area */
 #else
 # define VM_SOFTDIRTY	0
 #endif
 
-#define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
-#define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
-#define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
+#define VM_MIXEDMAP	BIT(28)		/* Can contain "struct page" and pure PFN pages */
+#define VM_HUGEPAGE	BIT(29)		/* MADV_HUGEPAGE marked this vma */
+#define VM_NOHUGEPAGE	BIT(30)		/* MADV_NOHUGEPAGE marked this vma */
 #define VM_MERGEABLE	BIT(31)		/* KSM may merge identical pages */
 
 #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


