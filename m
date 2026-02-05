Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D517CEA794F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 01:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45146B0092; Wed,  4 Feb 2026 20:35:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB22E6B0093; Wed,  4 Feb 2026 20:35:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72F96B0096; Wed,  4 Feb 2026 20:35:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD44F6B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:35:51 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C8341A0342
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:35:51 +0000 (UTC)
X-FDA: 84408686502.19.B9CBF32
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8655C40013
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:35:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IvuGfFjM;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770255349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IW48nM3DmZSMMmpiusrL/Y8AeUwB4gdi5tKxeg6LSPU=;
	b=2SNQJZzvs+qn853OR5lALAyiTcShqKgr87JyspbIxBeYbMrfvESOGQBOjr8ELoN9ybZWdI
	VfJwl7KKp+vgCC3pWGv14yl6VlWKC2B8a+Fy4JItC0ut1MH80KxssnALrkvcbMyUuJYkUl
	8Ax9Hs6LyPRxu+BF6A7gOF+LH3GH8v4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IvuGfFjM;
	spf=pass (imf04.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770255349; a=rsa-sha256;
	cv=none;
	b=OvrFwYdHCpwmRZrQPJWBiyJFbpyeDQPDpBATC79CFkACxFKo2SULoaPGiTnwc+nnnsjrG8
	MM9wx8CI7dFrRXkGrnT2r5+68EkXaesRmA0mVTy84XzlxOnpIDhUmNwda10hDV1JDXvdLp
	AbPcQATLpMW1KaPtl35XNsDMZ1bF78M=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2b81ebac5d6so477142eec.1
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 17:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770255348; x=1770860148; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IW48nM3DmZSMMmpiusrL/Y8AeUwB4gdi5tKxeg6LSPU=;
        b=IvuGfFjMIkChbWPbCOvUsNtDdh5O3bLu0VNLpbhEnkqbyEwvUkHrMAuwb+Dg1YYnuP
         /zhlZy6+Yrm2fh9DDpRnxxuhby/+ZqYNY8uJ4VyAJ/sUG4Yuc5+0lgxiMgmEXgG+jAl5
         6DS2HLVUXb+g6fg9qCdQHXJ2FEOi3Brk/gMiqCvl5Txn5W4N9mB62/RnCh7qrNgxcRRy
         xGiWKiKlRwNSXxBZa0MvVPW/zQF9Ck14jCOjI2VGVzvVII3pX6Snmo89+sHE8jy9XBdN
         6c8MhXB5evFtCi+3eh+rIVVuUWQp6pbG1G38lFIODrsY/tfMnmvcy0615x1sB64GqFsX
         VM/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770255348; x=1770860148;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IW48nM3DmZSMMmpiusrL/Y8AeUwB4gdi5tKxeg6LSPU=;
        b=t5XbjK/WvxcMXoQk/9ZKcWrmXMYmVhlcfJVmhVdSdLSClxGNuWEZF7F9G9b+pur3cd
         ufU4UY0Um/3ogApa3PTZHPZnz6OHFuX7e0fzk6mbVR7i4LyFgn+9Sg84R6p/NWc0Mbev
         4kdZW/dpWLLpynahEfhSCsOFX8ODuf8/aJZJ0PJVOM7awCYlZUKPjpxoEc/JA0e8wU9G
         i31gSwhpS2J/+QD8cuky0tJbjQvKrKvAuGQMQtJ9gMZ/B2t6kXyPNuO5hdM+B8zeiF/T
         pqi3tj46cyKu9pB6rLYJ0FwSRi8ACy2yzLg7OMIkW1CRdITjWF9CYWu0tztnevyiVSk5
         /h6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUZRtTQ5+7XWu8XQxn8qYC37xAZKxPHjet987GjyqHeyASJMpwbXSTv8UlVrjVo07hLxA8yDdsJ7w==@kvack.org
X-Gm-Message-State: AOJu0YwUR+sXCtlFLqmzUx3D2zN0W3nhpJ97s+e/4a2C8LOr4jPF6YkF
	ErQkV6jqDHAEGesXG0rlsW/ULCH7zD/Cgv6RmJajtQ+eJHijRiUJCaWm
X-Gm-Gg: AZuq6aKie1oiLuborfnOZbTGTpkx3DteG/dbaK+nEGmjmxRAQpjNpFbghx2QZKRC1aT
	yk+6Aj3S9g2HkJIRAk2hUYEH+UK/jth5rfVY94BZJxG9kXB35mnXltf9+mRWb7HtscK0h0df+si
	zEU/4WZrGrJtPko3Dshk73iUWO8iptXAfJFn7w1zC6RHEBk7fsuQ9VcyZljBfwHPUzYhMXvCdsv
	L7McE01VlmQSqbT3+nud66v8opWqavAZ/9qBYgBjm9H07WUNn6gNHMiK+oTTWV4qbIF+z6Kh6Gx
	U/6a/9XhVSf0WRffa4WgqnTPq0c7IatQ08RUc0SETbtevlwHZ7kC9qVlmqURymcGthIYezEkVRD
	ClRX+9iX/eRqlkabzaOrYRqIsDNIDagp+6DM/YdYpG7E5cGI2rJ0E8oJzpYJn3vp11S6Kp3GAgb
	0UTAE9fb9uWBqV7EwjYFDzGZVnq9HGizIn4GX6KxGk/lJ/XiQrT8U/yQ==
X-Received: by 2002:a05:7301:2f8c:b0:2ae:533d:19ee with SMTP id 5a478bee46e88-2b8329e39a7mr2414062eec.21.1770255348163;
        Wed, 04 Feb 2026 17:35:48 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-126f4e0f98asm3424982c88.5.2026.02.04.17.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 17:35:47 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH v4 1/4] mm: Add address apis for ptdescs
Date: Wed,  4 Feb 2026 17:35:24 -0800
Message-ID: <20260205013527.322157-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260205013527.322157-1-vishal.moola@gmail.com>
References: <20260205013527.322157-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8655C40013
X-Stat-Signature: i9p8btt3bxxq6ws1bazep8oxywnm3pds
X-Rspam-User: 
X-HE-Tag: 1770255349-881013
X-HE-Meta: U2FsdGVkX1/OxdwByZSqEu7WFSI0BuuLHN2VBkx5SCSXgTwx2LtyZaNYjk8MRS3F6h7sqQdrfknQBGwY5G4WelhqntBg/8u1DCool/v7TlWoKfWYZExSMNGSnpVHFOilGwngHqjorgbns5YxMREn3J6LzdGkVWRJa/0pNDERuz+SbAZy34Y1sf2EV2rrx07QQshzpfvwygXEZjRP8dm5gaic0ZhOLEETSMqYtudHBtYRfLnZQsAlAqeNaMCAlokNRv54+gmUwmOqtZPO6Hefo/UdUjPyRrAmxrC2LBOkwudCZW6W4YJMaSn+XxOw8d36gHP6Cs6Isu8QirI1X2UEsh9rEcdwpzYLsI09WvIFGiHIIj3ioyCAW/LAUtO6ZiHsvTyfjryuQejmA2AL/eiEX++j8WpS3Y5ay9WoXPCCW3lwJhjzCRFCAgJ4NIWUlJ8H6dMSnXYym3530hbrUCORwB1p4sd88lkHNELKGdFar3/PpyLkbUFcQ/dcOJSAeRrsacJEnpARPyHqIoRNPSX30vgbB4KYdHZ7gsiaHLgPGMTAQzOVW0RxFIfzjfyfHE8BGUD3yCnIHHRCcrDVX91fj43J0zSfuDV2b1mxXnJY7GDo1Bk98zA8OG5ddkuKrDqGn2Q0HXBFfmk0ZSQWq3TMuAWiZ3EDALGt21R3y+Bf3NwppcPkurt2DR1UdvgqluyNfivtc+4DnfmHhjZdtumsDjVH2TBSpK7hJnVVr4AIw/ioZJctwALtb8+8BRq7bfWPBy30bKaOptiAM763URmafEMo2HmewE4tx8sKRr0PHDW0R4O2MXuScW4MkRJcc5edvHsCa79d0oCS5bc4QU4Sxw7nEDG926mY0Y8vCayP1a+RRgdWfY8z7B/CAwRJXN+BurzvLETh4iD8lbU81KBAy0e6eI54j1JsrTjrBXVCm9Y1LeAP6ymXeYsmyXoL86oKBP1Hw1jVOXDE/WhJGm4
 bCVUWpzy
 7edlYAO7GrNXydZXWNO5pqUanfBlz1/MmgND8t8D3NnKJrjd8Wq9oZXBzsNlAjt1SyjntJpbN5EdmM/FWqn702JG4HpHVKvInvyev3QUgx5sXI1TZxR90Sy8avqTWrgZjVs2pCFfCbGV2CSc9mBJdIIUwpcc8ufweReQDnNgwxl/l6/7/7qi8306gbjgrSpIoD6n8/8nT5o2WR9ikLGwCIBriAb59AzuCsaFVt3mspyqhcgDY1/xTW7PjZTf+rV+XhxA8z5iFvRWcsW4WsEHALa9CUSQw7qZ1bdfuli3ocTDYmC8RH62V+15bTfI4qpAK63XtiTtKavmELmwgJzryOmnkZqLRk5atoZy90kXmjGoeGI7/5gzL4GdzEjphc7HKJRUiyTo2SqXZ8BJy+r3wEaPlbbTWhu0oochr7vaVNnLtdHWt8o3VzAHpblHBc0ZPJoFNLYeU2O2nZYOWU0/quqpHP15pwJ6JXQiptYRlCm7dzGYjBkMkosmRmS0QfFwWzS49kAcCCPL34jU7rSk+1Q+AzjGNK8VD8Iql6/YrIpcossDowgWTQfPDCV79YDklQ387
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Architectures frequently only care about the address associated with a
page table. The current ptdesc api forced callers to acquire a ptdesc to
use them. Add more apis to abstract ptdescs away from architectures that
don't need the descriptor.

This patch adds pgtable_alloc() and pgtable_free() to operate on the
underlying addresses associated with page table descriptors, similar to
get_free_pages() and free_pages(). The allocations will be zeroed since
theres no reason to want a page table with stale data.

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/mm.h |  4 ++++
 mm/memory.c        | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f8a8fd47399c..3f3000567823 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3419,6 +3419,10 @@ static inline void __pagetable_free(struct ptdesc *pt)
 	__free_pages(page, compound_order(page));
 }
 
+unsigned long pgtable_alloc_addr_noprof(gfp_t gfp, unsigned int order);
+#define pgtable_alloc_addr(...)     alloc_hooks(pgtable_alloc_addr_noprof(__VA_ARGS__))
+void pgtable_free_addr(const void *addr);
+
 #ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
 void pagetable_free_kernel(struct ptdesc *pt);
 #else
diff --git a/mm/memory.c b/mm/memory.c
index d6d273eb2189..96c4c4d06aa1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7451,6 +7451,40 @@ long copy_folio_from_user(struct folio *dst_folio,
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_HUGETLBFS */
 
+/**
+ * pgtable_alloc_addr - Allocate pagetables to get an address
+ * @gfp:       GFP flags
+ * @order:     desired pagetable order
+ *
+ * pgtable_alloc_addr is like pagetable_alloc. This is for callers who only want a
+ * page table's address, not its ptdesc.
+ *
+ * Return: The address associated with the allocated page table, or 0 on
+ * failure.
+ */
+unsigned long pgtable_alloc_addr_noprof(gfp_t gfp, unsigned int order)
+{
+	struct ptdesc *ptdesc = pagetable_alloc_noprof(gfp | __GFP_ZERO, order);
+
+	if (!ptdesc)
+		return 0;
+	return (unsigned long) ptdesc_address(ptdesc);
+}
+
+/**
+ * pgtable_free_addr - Free pagetables by address
+ * @addr:      The virtual address from pgtable_alloc()
+ *
+ * This function is for callers who have the address but no ptdesc. If you
+ * have the ptdesc, use pagetable_free() instead.
+ */
+void pgtable_free_addr(const void *addr)
+{
+	struct ptdesc *ptdesc = virt_to_ptdesc(addr);
+
+	pagetable_free(ptdesc);
+}
+
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS) && ALLOC_SPLIT_PTLOCKS
 
 static struct kmem_cache *page_ptl_cachep;
-- 
2.52.0


