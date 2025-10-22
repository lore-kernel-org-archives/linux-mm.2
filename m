Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03128CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611798E000F; Wed, 22 Oct 2025 04:29:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9138E0002; Wed, 22 Oct 2025 04:29:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525F88E000F; Wed, 22 Oct 2025 04:29:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42CA98E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:29:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 127BDBB0EC
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:29:57 +0000 (UTC)
X-FDA: 84025077234.18.5EBFB74
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf01.hostedemail.com (Postfix) with ESMTP id DC55640002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:29:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="UjK9zXw/";
	spf=pass (imf01.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761121795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JnXbC8Tsm4E4QgfOBrLeXM6uRTNeO8HhAUEHsum3ZMo=;
	b=v2klc1FWdfjoClhr0VZsqXsYNFHwm9zwTiqaMris8eq6pH9wpvbe5cgtfL53nLXyBNo202
	5jfUo05tw9ca7oDBHs/diTk72xBQv7uLgLpKoKabXfcQK2qpU+4YtTH8TZxsdvfdkepXH2
	9c3hh/PdRpvtLch12hyT2HYDYOu6VM4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="UjK9zXw/";
	spf=pass (imf01.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761121795; a=rsa-sha256;
	cv=none;
	b=vJdkkP+Av7WyeSWPWaR0TuA4DsOcrJQdHxl6d3HpYcl2yZ1RJZTnTYkUp40Z7dIAAHeets
	4f1rRbgWGhuRR+r1Om8610Vvz4veuJZZFu6r9BfbD7D/nk/Cvh0YcuHQfTaLih++unQMM5
	BYdZu8gStcp3Bp2xNWZUnGPwrpO0FcA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761121795; x=1792657795;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UdXEkbwZwh7s3Ab/yIsSNM8JqfKTQQu6KsOh09Fx8rY=;
  b=UjK9zXw/eytzTwZyyhGKfqqgFh+AF++3kYe1+CF03DX98gxXu47DJ81j
   hljmmvxifS5YMgWO8C3L8VkZVtwTQqWrKbrLUwfckqrYw8EBdDimnzYrF
   zFGeRFyayTGsuh0vT6OdkRuXHxmZRBlxD2BVPjTNB5s+S/dVFsfKGmFS5
   T4pfnyBLFYB4xbRHCk1CnvLAhtlBU297DVHJHhCvA1y35yWHJFcqQWwwh
   UaZLHNKk/icovtgbhQlVoqDZ74NebN+NgjSWIpdxlRi9Dkd4BLo9QAfg9
   dXyUkj2//YBo3HQAVisImUjuuIEkFVsKpzUQzYjsrq4gUkWwcPM2hIYft
   Q==;
X-CSE-ConnectionGUID: IUBO99TgRdmmzmvPrNIy0Q==
X-CSE-MsgGUID: raBI5KwoTimqA3d/IuMFlA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74382517"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="74382517"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 01:29:54 -0700
X-CSE-ConnectionGUID: xpCywqjkQey1za499pJiyQ==
X-CSE-MsgGUID: sVb55JoAQ0aCTSAQaUEdMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="183516428"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by fmviesa007.fm.intel.com with ESMTP; 22 Oct 2025 01:29:47 -0700
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
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v7 6/8] x86/mm: Use pagetable_free()
Date: Wed, 22 Oct 2025 16:26:32 +0800
Message-ID: <20251022082635.2462433-7-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
References: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DC55640002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8f3ti3r69yj975ng5bo3aoay9wuhf5j3
X-HE-Tag: 1761121794-963531
X-HE-Meta: U2FsdGVkX194lE3o0OJDByvBkT0BRwJc3l17XjyaCv8tgWJ/2mzUHXb1Q+9Uo3uk/gGy3jWcJtCLXpU7JR1qKRKq6wRGAHsFxMlc9GH7POMmlUMcarWYX4JWc6n5NDizhyhVv+niLVLckkrt1XXMvyeMru/PsPjP1gPr5f9Wa/LIog9jWCk7DFxBZoQ+nQX/irRqKHIDQOuEar0ux/GVYvT/b8rYyU4TkYrXz5Iul1+vIlM3ypjrI0O7a6uqE5NnTqyWMXMQ7xaXSZ0LwcxFfSJOHEBPnvRKNlaVtoQzkBjGIkfvjZ2aSndspkrTqA1g0nfo1VP9Gk6iWEG2rOlOsvQVyt7WUW0ww29ZFof1J0SlWh8vAeytOZNcur7uIRMJJ7hVpjDJpjo/Qzf21kDVnLS1RqhCprR05dhfe2sw0nD1Xfw8b/5vCUge1LvrvMb5eQ5s/YF/29e69CquFnALdIrsR74f52s75bMLERc0ISI5kt4E/1L54ZzknlnxpSsLeyYWsRA3LNJU1+tpnPmMia2qlDgjydlLg17ceR24rf+q2WhpdLQhmRVQGL/4KyuzOPaM2AALKnC479pN348Ybfx5DF9s8KaNiOXuwcZ4ar4WCY/sqClGTOyH0P7omOR+6AyejIRGNVUO3pX25os2bKsmdVO4NwIr4J0XMrfuK2aAOgA9XF7LnxfzcfpWL0WfLrTbXiXZrRQVdOVNmbL/JXgxveUYkRV8SdL6DQKtBh6eVGA5U6QLmIK8pAYKqIR10WqPh9O+ntuNf3xrmGZUS/wXtOTMMhGhfpnYUIWKV7YwX0G92tsqTeikjnbOommAghTOVKtx1PD9zrCN673QCPIrsmqIt3onvRIkXDy3JR+RQ4QC5JMTyrdrAbceUtIl+dphXz9nGODQ7nSpVA4aAmx0By6/TVb9UBd2ls9lICvG/r+vTSwLQQs92+GrOV3xT/V/Cu+hjvAhT9//Lsg
 iEnxBcXQ
 37OoGDf7ptC0IYWsotAqETgguQhoGT5Xze0RLET6Dh2ocgOYf6tLY7RqhQaPet8zKwxkiYMMGmpjkknth6z91VPnwqs2uB2jS+/0mwIzjAz9S+5941zPFv3t3xJivdQ9WE2d6VofBfGNvejckocpMgMSq2PprHMudbf+j/sDau3bJKKKTQjScJrzgffchzQQlumpMUrnWwIx500CQhV3PO9z9V+12NJjTTTUex8y2dYm3Mf8tz0aGOcvwtB6MVTDCcHdk7M1h6AeBXfG+QorXa7LltrpBiu8eNb/f
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
index 970981893c9b..fffb6ef1997d 100644
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


