Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D739CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69B3F8E0115; Tue, 14 Oct 2025 09:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64AED8E0112; Tue, 14 Oct 2025 09:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A438E0115; Tue, 14 Oct 2025 09:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DCA28E0112
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:08:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFBA511B08B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:08:09 +0000 (UTC)
X-FDA: 83996747898.20.E37062F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7E20EC0015
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:08:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YT2T7mSx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760447287; a=rsa-sha256;
	cv=none;
	b=3205p8TaSZyyjik0Arn2T6L5E/fbp0jhfZw3QEWb5Kfc5D1yKvtjEYsANsb5GGrjRGi+NF
	21ksLMVSR/J2jWqw47jF0pq7TJ38gLBs+cevDC+ta5ni7z1EVqz05J7Lgt+b34d+pmISBc
	yTZcL1NR/DAiZJsCIkXmBxT+OcQRG74=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YT2T7mSx;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760447287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVmytK7jgyWMVn9XVGqc3U+uyuoLpbwXK8vohEPnIwA=;
	b=HQhLSHRkBTiD8ELzmzGdOP8FXnyaUi6jYSe6N4sTQoi3izt8aFJLKQdO7CCxHO4V38aONV
	eXmSX5Ez3YLIAenMUaqfCbHeYv8Qn/XwdGeR7RHhlHgNNvP8k5UyjKFdHvLL9r9rLtiF9A
	s5ia90Jpv4fronYl2mbDTkUMuBXeUM0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760447288; x=1791983288;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J/aPVU8JbHxYyfCDcj6K7oo52RWRfEFFerOeOF+XTLA=;
  b=YT2T7mSxoBXSgHsoSk1C3TgDcczA/RNkUsO4sfaLjdBmWlrnC7VSaD+5
   ecvjMePp+Fm0oetjp7ZFFGmzlMej4vyw6sv3yYNJZB9K9OHyafzCd+GNG
   NouXztDedsASjskgvaUiVnEcUIh3ombJOvyjOQgOiiOcdSUCkFaHy4PL6
   LCCco+QtwLIQTT4Lhleu1AYQD5PkWvj9LPugLUngslxYsjQ/DJWLAnDhm
   VyJ2k3JmnHuK2gka/yUULOKv8nWvak0rJC0/F7B078VD0imq4WRjHliaw
   1MnmCgRRXdK6DCwBspnr/mI0Bu6qpHpxDBghfjrrxNqZ3cXmw/DgShSfR
   g==;
X-CSE-ConnectionGUID: 3LG6ltLVRVyXaFk5lcfYDQ==
X-CSE-MsgGUID: 4CmWgMwpQ6GJ9GNKWi5cEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62515445"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62515445"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 06:08:07 -0700
X-CSE-ConnectionGUID: EIHOS615R1+i2QYo8Z03rQ==
X-CSE-MsgGUID: UH1eyTeURm+UWSuYvSl9nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="182675673"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Oct 2025 06:07:59 -0700
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
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v6 5/7] x86/mm: Use pagetable_free()
Date: Tue, 14 Oct 2025 21:04:35 +0800
Message-ID: <20251014130437.1090448-6-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p98msjmnzwqmwmoxsnsx8msfs6ksycft
X-Rspamd-Queue-Id: 7E20EC0015
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760447287-35223
X-HE-Meta: U2FsdGVkX19x82FYlGVhZ80kr9pa7iZ36qfG7FE3pW4HlCd00WZFhtoccOcm3VaChqrAF0+N4UMRPZZyzlZQh1i2BLbfW6fkfEwPX+xC00dIbCYL2Fo+1hVGO8O0/YO7yHMEu9mo0e1efuwWitXL1BwLzA/BtTgp2buywS+xk0+YnkK6s6EnltZqkiVJ70mPB8YOzy4n+7lW4MrStKkBJnLa73w0h2BbYd+CItAKR8pK2aLCi7OXlZc0uWegpAaK4iIGWcv8h3Q1HrdYYsXmIp/5oF5S+OQBEVPVFJ4uEr52qEHbk9AXOuJ55EZhqzsOL+IRfci4C5ONQPczYTg7+NuQUuIgF7AUamM0YapUHMcnUZWEnDMkA03GfMbvxcn2OHjzea0rnsn6c62weG+EmCaj+srLMUEzxaOL5jKDvkRca/8SWC10rfc1hnv0ZUTEyNcxzwMX+HEV4mb1NwvmggiokSCMYe2zY0nCvMBQnpbxxwzT++mPSBTgqZxrGEOP7dlQDr4Ou0Y/5d5ZKcziK/ecsWFkcIVqqGDGGWWU1oOH82SJVrykvCTN7h77oTOa8zQxK8iJ1iKDHoOBQXsJ05sYoeiPKNAZ3euiast+TWH2vnUApFPkKR9/l8zs/gR/PcZfbXJEhcR5GqzppohzRfonXhWhPslb4Xu0yOdPuiiDpbb9fbiXt9Bsmy6w6vKt+dNwOGW0uOy4gDbU9GilXDQrvLEVH340NKJv+Nbv9rOB/cSNnQkDvfD3IsPaAQWXSv3IogQ4ne795yRpsW3WbG/TlT8JQ4oGFJ0AELWhJi14h4IwHo2ReG5Yn8U7svlBVI/s2pQBTAtGu231XOTOL76CeXZ58Vr6ezs5/F96PrCZ0hzJW9EeI//Efijnyd8JmFkRFctm4yXowRw3697klTZmRTI2k9VlAb6L3wAnegY2kmHjpEcZyZqVrLZZK1I2upCAQo3b56HEPDbSmN8
 GcqUzr8q
 9OfPgNvnAPnSDYqcnU4Q0oAARhiN14WlyyNp1LRMUuAOJONgfX9F3IVCQOPTM8qOm/Nba9pVDog4uPp82WBcdBr6gBHFFsblFWA3DB84Pgz/x5xbt9qspmaQKrAQlz8ewG7Lb0OM7AFR9w0tpigFW5Ga8ygGvf5j/n7xyhcegLFK8mTD6hSmOTBePCIWlptkRRtGWyv98v0LYWndYQKmXnessI15W1vUQy/U5d0WKhV04b/xL5BKf2Uu1YoGqtWoSlwxr5un45VPs802IkjgDKvlhy3lOzGQ1uyg+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel's memory management subsystem provides a dedicated interface,
pagetable_free(), for freeing page table pages. Updates two call sites to
use pagetable_free() instead of the lower-level __free_page() or
free_pages(). This improves code consistency and clarity, and ensures the
correct freeing mechanism is used.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/init_64.c        | 2 +-
 arch/x86/mm/pat/set_memory.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 0e4270e20fad..3d9a5e4ccaa4 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1031,7 +1031,7 @@ static void __meminit free_pagetable(struct page *page, int order)
 		free_reserved_pages(page, nr_pages);
 #endif
 	} else {
-		__free_pages(page, order);
+		pagetable_free(page_ptdesc(page));
 	}
 }
 
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d2d54b8c4dbb..4366e7d11afd 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -429,7 +429,7 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 
 	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
 		list_del(&ptdesc->pt_list);
-		__free_page(ptdesc_page(ptdesc));
+		pagetable_free(ptdesc);
 	}
 }
 
-- 
2.43.0


