Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50117CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48716B0005; Tue, 19 May 2026 11:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A22FF6B0095; Tue, 19 May 2026 11:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9359C6B0096; Tue, 19 May 2026 11:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 836D76B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:10:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44B8BA056B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:10:22 +0000 (UTC)
X-FDA: 84784505484.01.C2C281F
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 95F31120011
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:10:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Osw6ANCr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of qkrwngud825@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=qkrwngud825@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203420; a=rsa-sha256;
	cv=none;
	b=TD9C6D3gBl4pmWf6FPZG+4W7qJds2nyQDMQhYmyP3phndqfZ1l+ZI1P3a6+E05XLkFspd/
	eC6XEIhbE636L24nDppwFqZA84Frx12ax1JdX11fQwQe4cE0NL8lRIR1RhMjfnPjZ/U6/P
	ojy3zi3fsWBH7EIasGrAK3qVbfYn01M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Osw6ANCr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of qkrwngud825@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=qkrwngud825@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dNsRRNdoq/mh7bkgCE6Fn2FhIJG533x7ld3bg4XFCu8=;
	b=T7AaOKZDtn3zhtla3wUFUYiFZEIY3CIdVH7/xemYhJBsWkgHs7XusM13k0pi7LNeBV71MO
	89+FAB951Tv/OiyCoY5suDDtfA8UWIBrj+Nt/MEEVbuxNAeQ21o0qBAWz2H0ayzneBJ+Z3
	+sA0z3+RjCh4y4ggs8Mm3K2lC9IABrg=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ba0fc8b1f0so24167595ad.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779203419; x=1779808219; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dNsRRNdoq/mh7bkgCE6Fn2FhIJG533x7ld3bg4XFCu8=;
        b=Osw6ANCrVgT74tiJI3JsZBs3y8LFoe6/uB0ruswLEjnfJ7KM9HzKrBRG/HaOW1AAtT
         o3peDv0/65JcgkeNhxNADIvRM6a/Bu1s4yEww3cJr4g+nocdU6ViySXkpw9QHIqdHbrt
         Tg2SqAnHHGYxGwIJCiNZuCMWO7AM4FX8t/EAjLRYhbtsvZB1N17xKzVIGeQK/GCshue9
         osDL+Cj5ojLmxmx+sIBn6Cz+SNS3dBfkfJY/kswhGzxdnTSGBHd561ALk1R1M6NpR8iN
         /BpLSA0EdyAcWE7waQoerBOncjR4+pgUBFK1fCtAuOfxTcHYcaG0F4I5qFoOsAus/hBi
         5n2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203419; x=1779808219;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dNsRRNdoq/mh7bkgCE6Fn2FhIJG533x7ld3bg4XFCu8=;
        b=Gg0aFyAjZa+L+6SpBBs7PUWmlMkFZpUaeWLJ6vUx/gBdZuyDSIAZcC5PofgvtpF9IE
         TU01mZZswfk+VIdID4RT10j5RjgpwA0hcoaAZ6bqKyxrzD1kLZq8tOPYX/OuAMSs/iSe
         BwDeDjBvXlvFSaqqqfHYWKHKpLeuMpHniUKmZqojPSSOBFNgPYzVwx/o6QY2ARMpTEwy
         ZnA5hbNmsToxfV2h7xs9gBctfJMzi9YOYzvbfFlPiersZC2U0ooDddXDYrK+LibjCphA
         vxWmBLdOs28SyJ+qbtv1UdFGmDIQ3j1ztvfTSRmlctOz2hHj5TCbXFp9jatL5W5v2cmu
         x+kA==
X-Gm-Message-State: AOJu0YxjFEY1dYDA5MQMQonpejrgyeXmk6EcHCCgJixpkt3Wal5AF7A7
	CUQOEcN3iSeaQsokMJpNui2Ipnaqyi7jtPdMNWPhVIQIljZrdHRxNfJ0O8izguDitCY=
X-Gm-Gg: Acq92OFiFz649MNNFaEs5O+8i1iOE5jFat6AzwKh1G4QHxvLMGdBVxjFOvfyV+4sUwT
	zC+AKhHW0tdt7oyQih5P0KeBdIl8SHQyF+nYBAznKasb3b9KgMPFCp4ahguZMAyB7rVTSjGCD7U
	WjeLONJPbtUYfcLqW/AC9OnyA+B0g8kf06fgZSZUIhL6DQZN9mteTHZYKQJeIv251bddY2JD84x
	x4dHoCxvwLtRhaJYlUiey30+znVy3mha0SvqdQbithLN5U5OwvqTmq44ZTdUchRfEr6DJFXnHjg
	1I/JERUvOIMgC0ddZhHbbZrnPU3ptm21kjkevvXHIqd+9ciKbxprH+/rbFvaeDB8cQUIW6rD4+n
	RPeRbkEPVwHj4MBHczDEdGcQY/A1HVWdOI7OQ8ewk3Z6ylMd9qhKn9+wVZbi9GrWZB88qcsE39X
	xIYDep41mGjGUDRDZkO9oWgqkiUozzMyFJkzKSMg4wIGdnPqr9C6WxXqk7
X-Received: by 2002:a17:903:90e:b0:2bd:e452:a484 with SMTP id d9443c01a7336-2bde452a535mr99470535ad.33.1779203419298;
        Tue, 19 May 2026 08:10:19 -0700 (PDT)
Received: from arter97-x1 ([58.124.177.116])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5d11ce67sm193784595ad.74.2026.05.19.08.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 08:10:18 -0700 (PDT)
From: Juhyung Park <qkrwngud825@gmail.com>
To: linux-mm@kvack.org
Cc: Juhyung Park <qkrwngud825@gmail.com>,
	stable@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
Date: Wed, 20 May 2026 00:10:08 +0900
Message-ID: <20260519151008.1399226-1-qkrwngud825@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ra6kmdykpk1nue6za54ktgf5abpduypu
X-Rspam-User: 
X-Rspamd-Queue-Id: 95F31120011
X-Rspamd-Server: rspam07
X-HE-Tag: 1779203420-46577
X-HE-Meta: U2FsdGVkX1/QfqqMdUEbc6RKoxuD/1LIS5OhecEPOoXfIYepg5bBTs2rgW+vDQILLnEQAO/gHjwYlKq8SX0i5gvJK78hhHTRSTkeqVMf9gZTDcdCiKtuHWWOGP70AbbNlm2SOqeLQXO7dNLUejXucnv5TF4CHdp6IER5X1+keymG4SIfQ0mcku8nYtqUMcQtelW7pL7mk1BwI+8FVTVZmzdE6M7dfjfNt36OG5psBnGhwS6sJM/E7mXLBOS8vdg7M4/pBxRjTFuHaaWVOF/xUcGZv4CfBE26U0J58AbR3vYsqw5IAUV3apRjRjCgb1DKvdeMGg7Hr7dGj68SIqL3hfbt78JjIKFoLZ426mSXEtJgdPM5s/Z7HTB6+BgZUou5K28nAkemd66Y2WUag0ovQ+Y2gXWTjKHxLquKC/W7cLhkjzhCQ3BzMTP63PJPfDVzDziSrE3S6d0PD716wJPaKFhX1hK7w9nlEVnvbRhuDUJH3ylXuHnuef6Im1kFoIzhkDLlySyMFGkxvA/kMZNDNkS7g3ZRY64D6ps52200jXw8dYX2qO1te5pPCyRBy0bP6/pwfTFRUnDyzv3Rl9G5DNwGUOhBzc9kyQUSHJ/L+LpKVJUUS7/EIyjSObZbkXu1nFJ+IYEq1ZeX+XHm4Kp6X8/2waiFE+mL/SB15ItWLl9z2h2GuFIAVw/3L6UcCyb01cZ5rzTKl5s0T/rzl0K+GFUCjwKdn/Ry73jKVaRZitJyYNEv7g7XyWgvYatHtz9nI4CfGmtwPcSDu4uz08aDcLhN80hnm+NFGxpgNgImXOWZpvH7zPnaqvsqj3lGfC/flFZWpL0vkAfLDnQY+V7f975B3d2CtwcucjcEcSLFlhwhAi8MMujSA7cNDxzbZkbGCF9MsQtIy0xVAxbpswnAPYLiCfz2Ow91hqn7JouYQBEDaoWfCzUk68Bgeg9zVb1+ixvxyAe5jDIqM+eB+8+
 gkCeNKB0
 6IIQXnCczms8vjCHcYRWeXLHMAk0pndBuG/fadh1ELNiorei1To71BKNmzq2keGONOq1kUcIjhdOcDbBG+1/gliPMTHLnmsVtkdqifD7nihSYsyDm7DII/teQDeA53z8VdDOJjzt8Jctxz8qCAvpJhb6R4nuk5qnPgS/3gfhHNM792XtI+gaeBWHpY/pwS96Wxm+25JrVhTv9opjYgP64KwjpaOkLtXQ4J2E/I5DEn4NDX2sgOsrOkAKZOV0g4qRkNoMQXub0TX2+0l+AEMz75+izrMJJ+/ifxsOAoFOKuo0HgER+Cx4KqnFsNDhzVjnR5BDpLsd380q0qaJWzj0EiQnoDODbx+iqnopkBBDrekyydmf+KUm8jWl4rL7YqbrljrTlIvApY0PXQULpL4lMua3lneJap5XfrmwLVxxE301ytQKwhVnHuDyGHtWDnJWV0HQD9Jea9c7IRv0odmdavvk+4mS4PBMHxKU9qifnO5KphAXQIOJ53EZ0P7IhNGetuHcSVYXy6Bl8BJ8LXt+MSr1ONOarml8nJvl2C4vfhfGmlEzjyOsWIdBuMsaNSp/b26v+Tz8+xW/4fUc/bX7MvaJPu9d252LWe2cZyKmYeAda1C8M5RjvIAUPLgVtEQFl2CfB8rEaHpfyXF2991rwodNASnzeQPgbofIDu4Z7XkSRKIcd0eT88hzWWMd/X5O5M7avlBFT/PBXCHM1mbvFPKEt+YHdqfXnAciikYxBzK+Hp8ImfA45j8TU/ACIpGlWlwo8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_pagetable() is called via free_hugepage_table() with
get_order(PMD_SIZE) = 9 to free the 2 MB vmemmap PMD leaves that back
struct page arrays on x86_64. After commit bf9e4e30f353 ("x86/mm: use
pagetable_free()"), it goes through pagetable_free() instead of
__free_pages(), and pagetable_free() ultimately calls
__free_pages(page, compound_order()) which ignores the explicit order
argument and infers it from the page's compound metadata.

The vmemmap PMD chunks are allocated by vmemmap_alloc_block() using
alloc_pages_node() without __GFP_COMP, so PG_head is not set and
compound_order() returns 0. Only the first of 512 pages of each PMD
chunk is returned to the buddy allocator on hot-remove; the remaining
511 pages stay allocated and become unreachable. Generalized: roughly
16 MB leaked per GB of hot-removed memory per cycle.

The leak affects every memory hot-remove path on x86_64 when
memmap_on_memory=N (the default), including dax_kmem, virtio-mem,
balloon drivers, ACPI memory hotplug, and direct sysfs offline+remove.
memmap_on_memory=Y avoids it because free_hugepage_table() then takes
the altmap branch and does not call free_pagetable().

Reproduced with CXL memory toggled through DAX in a loop:

  daxctl reconfigure-device --mode=system-ram dax0.0 --force
  daxctl reconfigure-device --mode=devdax    dax0.0 --force

Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
Cc: stable@vger.kernel.org
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dan Williams <djbw@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Juhyung Park <qkrwngud825@gmail.com>
---
 arch/x86/mm/init_64.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df2261fa4f98..a2301bddb647 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1024,7 +1024,12 @@ static void __meminit free_pagetable(struct page *page, int order)
 		free_reserved_pages(page, nr_pages);
 #endif
 	} else {
-		pagetable_free(page_ptdesc(page));
+		/*
+		 * Use __free_pages() to honor @order: vmemmap PMD leaves
+		 * freed here are not compound pages, so pagetable_free()
+		 * would lose leak 511 of 512 pages per 2 MB chunk.
+		 */
+		__free_pages(page, order);
 	}
 }
 
-- 
2.54.0


