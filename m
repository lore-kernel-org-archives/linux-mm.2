Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 666C2CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4C48E0110; Tue, 14 Oct 2025 09:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC108E000D; Tue, 14 Oct 2025 09:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9092C8E0110; Tue, 14 Oct 2025 09:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 801688E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:07:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4115911B070
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:07:35 +0000 (UTC)
X-FDA: 83996746470.09.B89CF76
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf09.hostedemail.com (Postfix) with ESMTP id EC529140008
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:07:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VKjYmE6y;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760447253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sh+fhUiadqna4QZb2NgDyHNXI2PUbTv6KBOnVjvFL38=;
	b=Ur0Bzej5mu4OJo7ML3adqP38DCVRDrKOww/t3sX5lsjhaALMoEHxNi9DiASe3ZRIc+1OnK
	9xdmEwqGIJmy94MOR3AU+Fs6DMZUtrzgjExHeAX92xSnq19ctccKRv0ALVJCmZTocAWes3
	HAWpXzX6ef8mRUc1+IozuVLkoUGJ4Gc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760447253; a=rsa-sha256;
	cv=none;
	b=MFQmv8hIKCXhDu6K3yhJaGlrIX2ZvAeAqZQio/TuIZ9gTPITja4BChj+pGqtGPtKD0apbD
	0z2g0cwU0boNmn6TQz0BjtjQjtMVW0aaOqDm1PuuFPH0czMbYKGa/YV9ovuFuiW7njPD0W
	Gx2PHpp1Ih8258pgIClzaFEA9yKoeTM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VKjYmE6y;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760447253; x=1791983253;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gJZPFOgCCY7Vm1gn07xeeMUAM+JDjIVlwa8HcX5Wx9M=;
  b=VKjYmE6yjYgscVm1jQUeeHvKgCOhYliz7cp2WMVMixA2EdhuB/Ii6wv5
   JWxIUYyS1Y8shBQg73jQuTgd2LQUYwurxTd0F+174WuL19HyvPJNUuiFx
   eLUyxILRYWE7JDordtrBd1KGC5PKHDTZ2WOzDQpMRgUZa79OXczL7GQvI
   pHAovNU5Mq/pa8UMOWo6WrcNhQ4LdniBevN+eQQYxnaPgckpi2AzbExUz
   w9hnU2pMTRQaKRpOu5HJVPjOat6viMs3DZ5L5niPFkAAYKKWWUo4SU/m7
   14tQIKvhrWUWDSCxZWiQZSuxb9Umc/CM6qCjxTpY4Whv3hjnirl8J589A
   g==;
X-CSE-ConnectionGUID: TXorB8P0SXeLVrzkF5OvOg==
X-CSE-MsgGUID: yK29OqT9RB2Q/4OFbgyPQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62515321"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62515321"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 06:07:32 -0700
X-CSE-ConnectionGUID: LLjJGhPvRVORbJ3C2K7/Og==
X-CSE-MsgGUID: WwAf0EKjTJi6kFtDp18FpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="182675546"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Oct 2025 06:07:18 -0700
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
	Matthew Wilcox <willy@infradead.org>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v6 1/7] mm: Add a ptdesc flag to mark kernel page tables
Date: Tue, 14 Oct 2025 21:04:31 +0800
Message-ID: <20251014130437.1090448-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EC529140008
X-Rspamd-Server: rspam02
X-Stat-Signature: t71c66hknpbfxbcddecjzkx8ugewux34
X-HE-Tag: 1760447252-353676
X-HE-Meta: U2FsdGVkX18X6HnNK1U0e3RaGauuBtEkwRtBrD+5dOEQiB+agSinY4Zvbz6dKwPyUNA6MzGIWjhMmcqPIeTR2+/i4gRY7xm0ruJ5d0D5zU4PwfHR/f200Ziak3bG4nyed1IWQoohmQpBRExn0eoZVwW2ww44XRj/XIlE6rojaq8xAyqUFgUXBrcsaUsyZMOTt74dZDXBoyATapwOkMLTYDkPei2dnT1c9yidufiPY+469pZlXmmtRqiGztZI5r4i/Ceq3w9fqI44taQIxGWGHsNfv0uNGzNB16w7+rkYSbhCm3P412KR8R6PY3dpSgxcsgObwFAUukNIvzrTrutkVudwxe2ynIvYxSK0SFcuaXj2A3+mmzoLxjJq5dFP6pROf669csoE16vzr9gnIyMusFT0+gvREDTw2UbJZZGDoBeOMZL3GL9ZEuJaxkGQHfV27APatE7qkfE3jYMka4KoqMAwwSni2LK9AKGxYwKuBiNiAh3gmgo6cFZ76ZMEoV/ZHkLiXNZ+mXlzjZ1WFL63Y6I/RYdwDRwGL4YbosbDfSm2M2I6MANBv0MNJivb4wvSgqIci2QsyEuy2Av2U7RVUQeckM/Xm7RkgR6GKNl4v2VRkAPh+9i6DaC3n0gtw+eMgZe0hJA//9VDLotMcnL/QBLAoSy8Z6TqEgVHooyovPc6HW3q1HGZCFla2Qw7/OEx5OrGq800qPrBUJHzzzmlkG2ZczZZtzY3HG3JFsaddMvzdDYF1vv3pfcYBqCuYyg8OfKTkd+J644egKVFYQV2rE1hamen+VJlOestbZ/7tX6AaKB68BNDQRA1kPSqAkrCRJb1nmEUE+Stcp4e9jMh3VzP44QqM/Nn58m7IHF1awCIDiiNJ53LTyctygqPlfhHwiyOJbDXlOMVGtYR9WkYf1AuO7oOvPaiXmL8EQShOswA9n8ArwbEOALQi1NgKr6k0yKKb+rsybXH72NTOz5
 Qz0Garnn
 /cqjL1FsmH9VvsLFw+VIBm9e2u2sk5ShxJuMG/m00HzOsMkv4nf/jDsZAILGjK8oclWSYuoZF1nfOMTDMsm703rTPBBeLfq44PvVgE2V2qBfxvVNlzELDSVTZxPvUGUiTKxnktKHVT3uaUHWlEr64hbbPsG446am9dXLUZ17GQt7cwm/HNJr5M3bVXURaN0i77kUtQa53vHoZBDt0HLDewWVB5cYT1ZM9oMGzXclVGrLJVYc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

The page tables used to map the kernel and userspace often have very
different handling rules. There are frequently *_kernel() variants of
functions just for kernel page tables. That's not great and has lead
to code duplication.

Instead of having completely separate call paths, allow a 'ptdesc' to
be marked as being for kernel mappings. Introduce helpers to set and
clear this status.

Note: this uses the PG_referenced bit. Page flags are a great fit for
this since it is truly a single bit of information.  Use PG_referenced
itself because it's a fairly benign flag (as opposed to things like
PG_lock). It's also (according to Willy) unlikely to go away any time
soon.

PG_referenced is not in PAGE_FLAGS_CHECK_AT_FREE. It does not need to
be cleared before freeing the page, and pages coming out of the
allocator should have it cleared. Regardless, introduce an API to
clear it anyway. Having symmetry in the API makes it easier to change
the underlying implementation later, like if there was a need to move
to a PAGE_FLAGS_CHECK_AT_FREE bit.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 include/linux/mm.h | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32..9741affc574e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2940,6 +2940,7 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
 #endif /* CONFIG_MMU */
 
 enum pt_flags {
+	PT_kernel = PG_referenced,
 	PT_reserved = PG_reserved,
 	/* High bits are used for zone/node/section */
 };
@@ -2965,6 +2966,46 @@ static inline bool pagetable_is_reserved(struct ptdesc *pt)
 	return test_bit(PT_reserved, &pt->pt_flags.f);
 }
 
+/**
+ * ptdesc_set_kernel - Mark a ptdesc used to map the kernel
+ * @ptdesc: The ptdesc to be marked
+ *
+ * Kernel page tables often need special handling. Set a flag so that
+ * the handling code knows this ptdesc will not be used for userspace.
+ */
+static inline void ptdesc_set_kernel(struct ptdesc *ptdesc)
+{
+	set_bit(PT_kernel, &ptdesc->pt_flags.f);
+}
+
+/**
+ * ptdesc_clear_kernel - Mark a ptdesc as no longer used to map the kernel
+ * @ptdesc: The ptdesc to be unmarked
+ *
+ * Use when the ptdesc is no longer used to map the kernel and no longer
+ * needs special handling.
+ */
+static inline void ptdesc_clear_kernel(struct ptdesc *ptdesc)
+{
+	/*
+	 * Note: the 'PG_referenced' bit does not strictly need to be
+	 * cleared before freeing the page. But this is nice for
+	 * symmetry.
+	 */
+	clear_bit(PT_kernel, &ptdesc->pt_flags.f);
+}
+
+/**
+ * ptdesc_test_kernel - Check if a ptdesc is used to map the kernel
+ * @ptdesc: The ptdesc being tested
+ *
+ * Call to tell if the ptdesc used to map the kernel.
+ */
+static inline bool ptdesc_test_kernel(struct ptdesc *ptdesc)
+{
+	return test_bit(PT_kernel, &ptdesc->pt_flags.f);
+}
+
 /**
  * pagetable_alloc - Allocate pagetables
  * @gfp:    GFP flags
-- 
2.43.0


