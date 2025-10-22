Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86B52CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E274F8E0018; Wed, 22 Oct 2025 04:29:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFF298E0002; Wed, 22 Oct 2025 04:29:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3BE68E0018; Wed, 22 Oct 2025 04:29:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C42448E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:29:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B163C078C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:29:50 +0000 (UTC)
X-FDA: 84025076940.30.3F26A68
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf04.hostedemail.com (Postfix) with ESMTP id 46F3D40003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:29:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TrZgT7vQ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761121788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yw2o0UexK0xZOTbTc5X3EWwE3ehS2KZhHOwDpvDbv74=;
	b=c49226tuTRmo17oFAXuzzFD/pubZFSiZzZh9D8ZfL5KJMDMWwFXJ5mGqYIrubH+DhBo8m/
	ucu43/2pzLIuyjv4mYP/MbpjJGYRXloxUnNVCnmenK0SZ7a7MfPzjTHJIMyM5e61LC3KWs
	lFnZetgbfcRm17nnDb6Ls9sA1kikO8w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761121788; a=rsa-sha256;
	cv=none;
	b=cKt7KVuS+vc5qFgmJ71xxrRNq9olZSSP4S0MGNGqj7U3PlaDNotOSIs9MprsAuqkbnZK99
	ilT+aEpxplC7jGBM9tyF3zOrv3za65AibHC/+bjScRNLLIip8zv2dp0mixEEp/uF+AFfY6
	izewc7tpppdOL6S8/ScFV6m+Zxb8P4w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TrZgT7vQ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761121789; x=1792657789;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mbPmTlwTy+FeaIisuAWPXHAhimNAXyev/5jdHXGKqJc=;
  b=TrZgT7vQzuiDMBCu6GtQZbGhTmtXnTTKrcwSIvfyXNWI4hFD6nFUO2M3
   tPQ9Xhn5Qtn3yWXdT4PQoMUpe7az+XSkySwpbAAQjTo4s5pfPgpOwSaFy
   CWaG5TMQ012bYLrrlcwauq1MmRzP2ZE2QnRoaxSNhjLigg7QUkfwHDg3E
   SSk1Db5BnZyQnAwkcspa4/Nvl5en2p8jTApKszZAzIdVP0ITzzx+7vMzW
   zQ9L4WeTI2LIDp268B+2i1WPJlbIBmYVGiPerLVULyMo9it6Dni9aVrWh
   321hEMYj/l/B5fEusAIT5RsGWyeqpAimF+TkltcyBSKkMPAI8oMbuFDlG
   Q==;
X-CSE-ConnectionGUID: BZZ7DtUcTBexM1OuPi450g==
X-CSE-MsgGUID: hH7WP4gJTqOPwm5wFsHQSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="73553008"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="73553008"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 01:29:47 -0700
X-CSE-ConnectionGUID: mg1a5UIgSHOP6I/XJ15gVA==
X-CSE-MsgGUID: YMVBwWzsSoyi79/QzztH9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="183516383"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by fmviesa007.fm.intel.com with ESMTP; 22 Oct 2025 01:29:40 -0700
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jann Horn <jannh@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Andy Lutomirski <luto@kernel.org>,
	Yi Lai <yi1.lai@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v7 5/8] mm: Introduce pure page table freeing function
Date: Wed, 22 Oct 2025 16:26:31 +0800
Message-ID: <20251022082635.2462433-6-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
References: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 46F3D40003
X-Rspamd-Server: rspam02
X-Stat-Signature: azz4sdew9r1hx4pox6hkorawzp4mdsri
X-HE-Tag: 1761121788-432886
X-HE-Meta: U2FsdGVkX19YZvBsG/2nn3J3GcURA4TQqjGDUdv2MJektamiS8x1JymSRK1T7L+DDjld4T0GVubktrelZMPDqlBlabv8A6SBxt9CkWGjWWnpJCBEHNVqnwq96jr2jbAFbIVW7fquS+d2nImkvxQZGTYst78Tg6BSPX3U3fQcj1ljc6JqIdm6kme894Iwv3+Ff/5imIk3/kwxGV7DSog2EjglJ1w+5sXnFGLndAG1OJN3Ko4fxpoKyqgxWRvbyTxLSYUs2APr+T5E/22677PUbHk2SACEAN3cZeMu7/cAwjCJCae4EkhQ3b55tr4dBku7N4FzOxMIsjaN71ezizrq5msM4ZlOqes92zj/VN2dw0VQDeaXyYSOltVYwubZ9GtRsjpia5ECXGqpwVUCG4sNp+PHJl6cDRSrxwpAhGmbePc1ODXBCcYyC2NnB0lWNPLk8TdferSqwjIod9T3PITPXxyTmzYIsQqRxYCe5vz77WA52SeyPY9+RBEnBOm4BMg6nvESmygEjBmMsGqKvLVhc3aX1FoTD+d+iZkA/QGbjt812jab1iYhY5diSHPS4ybOqhAFyXsFNrZo9w/h9Qca65Q5Rq5Md/hXBYEjSR+JzKJJgicv9PVMAWhQmYFNdnZ8Z2/muIVGqPX8TJz8mvKAhDY2ieHL98kDOcs/X01BSvOeH4h2euWa9ZYNAWm1fRxB90hlROeWNah/nQDcTKl8MDTvZj72L38PqHXpAA7oa3++YkQ2SZbvU1DblcawuCrzN2xL4tVln/WNeRIKfL/rkgNX6uMZovQJm88ERVLEZQSDsPL+j4A3aKGuFcYphSPTPq2Z98ZLJpoXaTYJpdHHwwfFH19iWh86w/BOsZcXQZEBrMGn+FELa3VT8Ukrw6dx4viFlZdVQ1EcdNftCx0gHQcQcXF/s1kwb4vhrVzX3tdXao598B3tkEGKzBV7/9LaR2ws7o3e0tFEkoQ0Jrm
 8wABozgm
 oyuPydg/TMw3qlVpssuJfoWs5MIibHNXdVgX50QHj6j+8PIKIl3c/0YRqMR2vTKD60NHFikZOnTIv7OjIen8KU++IgWfH1WKkiVTyfZsHjTuuFwa4ccJOpEh9ey/f0EAwvdJL7iQPO1iJFpUs8aPEeUiTDUNHXTsB4hNtPUruX5lC9Jgz1NnI9AOvW3dEWWRSvowpXwxvkCnSo7w/27VV6r5BRmMSMBkWcsyb0gOtkXvThGLpV1nGvn9gLV/AKFGQkxRjY9QgxKaq6voSMg/lqt4GpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

The pages used for ptdescs are currently freed back to the allocator
in a single location. They will shortly be freed from a second
location.

Create a simple helper that just frees them back to the allocator.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/mm.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cca5946a9771..52ae551d0eb4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3024,6 +3024,13 @@ static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int orde
 }
 #define pagetable_alloc(...)	alloc_hooks(pagetable_alloc_noprof(__VA_ARGS__))
 
+static inline void __pagetable_free(struct ptdesc *pt)
+{
+	struct page *page = ptdesc_page(pt);
+
+	__free_pages(page, compound_order(page));
+}
+
 /**
  * pagetable_free - Free pagetables
  * @pt:	The page table descriptor
@@ -3033,12 +3040,10 @@ static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int orde
  */
 static inline void pagetable_free(struct ptdesc *pt)
 {
-	struct page *page = ptdesc_page(pt);
-
 	if (ptdesc_test_kernel(pt))
 		ptdesc_clear_kernel(pt);
 
-	__free_pages(page, compound_order(page));
+	__pagetable_free(pt);
 }
 
 #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
-- 
2.43.0


