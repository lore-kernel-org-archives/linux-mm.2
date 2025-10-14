Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1809ACCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75D7A8E0114; Tue, 14 Oct 2025 09:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70E108E0112; Tue, 14 Oct 2025 09:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64B538E0114; Tue, 14 Oct 2025 09:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5534E8E0112
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:08:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11BECC0944
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:08:03 +0000 (UTC)
X-FDA: 83996747646.07.2A8539F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf22.hostedemail.com (Postfix) with ESMTP id C0B90C0007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:08:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VuwXZ8Z6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760447281; a=rsa-sha256;
	cv=none;
	b=f5WEy46rdwVgOKODZ3EF+vaxRvzNw/giBDr5/MyRDI+kuU+bl3GKgnz2u+sWPPhX+3WA5Z
	IGmRDtX2FuQehuc1ai8aWk180iO/2LQNCt2+8GT34L7QjXdBlic+iENE0Di1BIwixQX42y
	O5CRJfmI6xxyUCTMy6+jtBbDPAex6fI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VuwXZ8Z6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760447281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PA3zhpa+BD/5dmKfcQGwmcHcAgqFVRQk01mUODYy3M=;
	b=OdWJdG1GaHvD0GIf8gMgWD5D+YIP03ZfcGZhi7jnQauFV7aMZSkMMc5QODKk4Yv4hrc4Bp
	Q5x7pygwuZWvxB5815thyz1077BMe6r1Z5UWQt+qj3orXZTefQefzs3ne/8QyeWCTGLJJK
	c5v+nY3OzgfZFgeykPPHkfVkQpiryM4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760447281; x=1791983281;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vO9zGwkmI5awwHRZtJhTqnzpNbqrGk1H0cCSFDOeJMw=;
  b=VuwXZ8Z6T7mAC6yreupAO/SjCBOy7wiYFIJcY8W7CY9aC4l+xg1Cm759
   vAeZbjrHTraMajik4XrAL6Pcu+xkJM26H95OUuXF08ZBlGVRM8IcwoZVu
   uQkEFaucnvEMlZ13HAZbMQ7WAwidrENFqXHSA3qJ+ViCAqNZ+pISBa11F
   /4Hi7sYCR7p/tCHasok366TEvrutXKCUMXmwd6rIpq2zE4ZjkruBOm7mu
   g2L3+HjFDcJbU/9uQlodC7cuS0R9v2EosrbtY/SFANaTPONk9gtG8y3/p
   vhl0lYqO3VdynZp0OBFrefQVSAe5bowUdL7/yfGRLG0S7PUKIHxsMcDzB
   A==;
X-CSE-ConnectionGUID: hsDia2LWTReWtS65VVkvTw==
X-CSE-MsgGUID: pX7MUggBQY2Cx/pj/2rArg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62515412"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62515412"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 06:08:00 -0700
X-CSE-ConnectionGUID: RdlCVzNdS+u6SSMJDv3Wmw==
X-CSE-MsgGUID: nksl6V3QRdqLMmdbw+DpWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="182675639"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Oct 2025 06:07:49 -0700
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
Subject: [PATCH v6 4/7] mm: Introduce pure page table freeing function
Date: Tue, 14 Oct 2025 21:04:34 +0800
Message-ID: <20251014130437.1090448-5-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nrah8xoktpq4pbaminf88kp9sdjqrdi9
X-Rspamd-Queue-Id: C0B90C0007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760447280-571043
X-HE-Meta: U2FsdGVkX1+cfudGTc9JadLbWAyiW+Hy0ZZ+50JQdY0QFTJLmHh7IdS0HvM7h/vE+BVBBqn6i+k2YP9XsTlBy4zNszX5ILqDvImcTqvU3CwxuiP+SHG1LAx/cJYCM/i5ChV1TLcwn7SMpnGF0jIrs/f/DfOtmCVPD6h0hnSyEJcwGFi2Da8XIkAxe90vGC7fB+UPURbnYyx9JmC4Fu9MAyAaPVfsitiHcurtAQ3I/FQDcfrTJYRYIFIx+80dP3f0oNEPpf3TQNLt+zGxjn9g2+3XPALdMXaPJlwtVlbCodFr7/9v3g2SINBNQTQGoWNBvJ580WzteGzopvQ/NgRTVYdawLPMBAX70r4Jo3AzGWHXRo0z2kEpjF6Q2NZJjTLBbOYN9ushswY+Th37fhgKAJn9mz5t7ePX7LPxUN55Hst4GwsrndUsaHwc2RnSPFBjmyOOHNWlWwEzNvibEokt87qCCBGl9oMrDOhje9UmqMfbU3uO48IfGqYlNjwU5I/RZjokCA0iEnrLe2J/Tx9YQh6kTXuuN4U5cOqUrqDqzlT9hGxvWx5rzQ1hD6CACX/rtN4Bk4Rpp6/4iQQWpi/ALHr5jLW7RNNa5XV/uzoM0iHABeFmHRuA7GPh1lM0wIqlBoplYX3QejAe5X2sgEOXI2EnwpCjS0MM1O62oEEpLObHusnGrQV2uzKS+RUHfEF9cexuAq2J/XVhlC+xGxsVfzxa87Y7fuuFD+3xRphUN4fL5HLajYR0sSlFxA2OCqM06O77zgSXvNqzJ1Wa7SrnX3f3hbpPzSdFkEdHBP89jFkb3MkTT5gI9oE7y/9696SS0D9scjZkccdivAmK7I7zaE8zjYDNDSNgwHxm7XOydKH/+OQCy2qfKwtjbwa0FWreFNONA+OW4sYHjJOD783a40cr5G801L9TQrqCLhpo8ZyQ+lzsti0x29ReyPbIlj5qsWo1XJeDkAlsnehyAf2
 WSzNub+s
 +qZF+RDRAl6WSapyQaQyTFAeCIXo6RSboyuol6g6cnoQv5ZYq3LBuFwV1Oivm3M1Mj1zzouXrhHvRyzj6KGfJEb7DQTjfRz96+Pr2zce8Wy07ngUuBiltJFt5fvYV3ls06Hnae7Zlxn4/VeT90gGkdskOphxbeYYh9eO19RbmRoMfsZ/jbt2boqqRsEDz63RAwsUHrm3N6UpRxrCQDuydG4Focs5VZF9Wm+eG38qVQLfZtrSCQ1EYH/Wz9JiiYQmU7b8eLXaewbq2NQehW3vAy6Temw==
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
index 94e2ec6c5685..bb235a9f991e 100644
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


