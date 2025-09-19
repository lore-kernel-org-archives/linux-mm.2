Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CD83CAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 05:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9F1328003C; Fri, 19 Sep 2025 01:43:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4ECF28000F; Fri, 19 Sep 2025 01:43:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B169F28003C; Fri, 19 Sep 2025 01:43:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E1F128000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:43:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 70A4D58F14
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:43:15 +0000 (UTC)
X-FDA: 83904906750.01.A244A11
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3EFA2100005
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:43:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cWO1xr5K;
	spf=none (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758260593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LChq7bmjzzbynujSIG7YgrA04pIM7gkSiW8a/45Thm8=;
	b=I6ffwCKXqOaGvtKw0GEZlYgbDKm3l+QGqhE2Zn3R8U2tXZJLe1uoeY/jviVPyt9p80wKYz
	4CeyV7QxH+8OKcm39FAUIyjzC5OM+eMHKOKzrbMlpk6MissiK2hrJQ3IAfUN7LvYaJgqNw
	P9JRYddWJTH4hNGy9aUCk6uaNKT1KXc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cWO1xr5K;
	spf=none (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758260593; a=rsa-sha256;
	cv=none;
	b=JZ3G+PYv3bq37Vk8xQlfKLT7rthuKcYuAHeoEjVtBELxp9BH9wohMD1XHWWMDvzPamnQoO
	UIkna4JZxMvznTN9TevpafZ+R08aHhvrXmN1jIXqZfU9rDbxpacFt1mW/jjgUoILmTn+8Y
	OAtfjNv6Azpsh21QCJRmgHxflsJnjRo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758260593; x=1789796593;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4R1MBHQq1JefAbwJJHoL+8VoAIMfKTm1QFbquO2mYLA=;
  b=cWO1xr5KVFFwmeUH2uHtd9LmHAeKaemo2tfzzYgdh7944xrXl2C4Dk7X
   tLI+2UPj+kHmHBvip6l5lneMeX2oDgBQZy6d+IHXGMVy3yHWrKmfUST4M
   8/T0mB9mL3hT3+IR+SnpGY2PSZOq7Ijtn1pkimW8tN+TCXCo+7cCPVKHA
   Cc0Wh+C6hePvk+kVo+e1VFwQNoaeW3xCPg54wp8tqq+31Ac4eRAkpZarf
   fA047MeCW89xQYHU7RaGOWQa729yir4mOsDZJFwemJw+IDgnhfZk4fSCw
   BHAjm8rMIrykSxw1hAv5ESBtD0eZzXpdjYlKuLFPOZ54XRuTaRIlsqoSA
   Q==;
X-CSE-ConnectionGUID: KejqUlCTS32l+BREJidaVQ==
X-CSE-MsgGUID: iFHUvHV2Qfi1I44jc4dA0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="63235850"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="63235850"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 22:43:13 -0700
X-CSE-ConnectionGUID: AnSarqLJRvCAo0XtC3fUqA==
X-CSE-MsgGUID: pmp2LUxXQ/WqgCkFl7wFLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="180858828"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by orviesa005.jf.intel.com with ESMTP; 18 Sep 2025 22:43:07 -0700
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
	Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v5 7/8] mm: Hook up Kconfig options for async page table freeing
Date: Fri, 19 Sep 2025 13:40:05 +0800
Message-ID: <20250919054007.472493-8-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250919054007.472493-1-baolu.lu@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3EFA2100005
X-Rspamd-Server: rspam05
X-Stat-Signature: 9yx6tw15qnzhtwicfyz6g99d8zksxfo4
X-Rspam-User: 
X-HE-Tag: 1758260593-143241
X-HE-Meta: U2FsdGVkX1/pb2YgEdiO8qKyYCQNWN4vag4nSBslkjSre0tv/dsijeuh36Bd0hGYq84Jp5+dgBrEIecaR0gpt2k6ulE6WLim6knQkmSZr/CA2xak+CCP7Gp/jLUFeb2QW18kigVLNb9S0GGrzlm0k9m7AN7IPtEh/ieV1oUVE8bzzBgAMssMGL6CT+lLZhGniUxPj7BZ1I6cx4d1hR1aZ7+YktIl+IMWMLMiXKJvyg8Zs6A2FeOwVfy+qzMSZQ95X32U51I4iPdfBeI53kjC7/ZpUp5OHC7cpsW+svbtMzXvvuL68o+V3vaSQa9ZUFto1cJ5sBqRTB6cV5ZEE43gN1RUMfF1u4ReXRhNOa6A/VhCU6rd0uGJ0vYW+Biu3oU8/PskUv+I19+hzkz3Ge7dov7YtxMnUBf/3qT7YIMGWFA7CD4CX9yuISG8ZNUAbnpJUVcdraY4NKDeJH8IwJIL0YtlGqVocEw73y8Uib3A8oY6IphBj7nVRHuOuu3QyNXAKBqF7lZrM96IQ5VTiehC8F3hE9kMhn6zb1s9XJD9caVrDwtx4kpdp3+VVHK5iATWAbpxIBAWXYDo3saDENaW2NqgJFY4GrP/5vuOmxT2qdx2NJoJEkRA+WR3aNOYKnxJ9MRW3BtJQW0IuUO1FHhu7X1O3b2lMuzaLUQo98DuDaiN8yHT32mlENk7bJM/v6poDpbcPmFW2EO4NFHWRPJbPJmhYJMDq+9pWZjKEiM/8Xnq8GAvpvD3LnhYbMbd90qw6Lqac9wTgyOSw8PaPUdk4GXMePUm/YwSGY8PYpzgp+32q66GVPEyAkwlRBvz6EGHJ2tZUB5LRukujakU/Z/1Li52E85KATvHWxRz7DBfDBcham4s3yDQH0p58HZ6th8jAXEl+LIwKMd3dmbkea4ZwFZ9A3lz4O76DRlA/g8Yw9nA3cvzs9tgIfeBFi+VRfICLcFaUrP+4k3Ndq3HXd7
 YrPt1DJh
 PZk8yhXLTpG/tvHzOFIPy5iMTxSk2VTpMJTuSdjGJya8Yp4fdfGYMa+z4kUpAFfMqQ9QExavPD3PFGifrjKoqsdLFYm6W/8oW5Zvyyf+ryiNoq1I9CvGgV3soCFAvlNFGrGnwdnxOwknYCZCHajMABQDtPJaFKmw1f2ziSQ7D7o+k14f1dZtqON+UTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

The CONFIG_ASYNC_PGTABLE_FREE option controls whether an architecture
requires asynchronous page table freeing. On x86, this is selected if
IOMMU_SVA is enabled, because both Intel and AMD IOMMU architectures
could potentially cache kernel page table entries in their paging
structure cache, regardless of the permission.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 arch/x86/Kconfig | 1 +
 mm/Kconfig       | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 52c8910ba2ef..247caac65e22 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -281,6 +281,7 @@ config X86
 	select HAVE_PCI
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
+	select ASYNC_PGTABLE_FREE		if IOMMU_SVA
 	select MMU_GATHER_RCU_TABLE_FREE
 	select MMU_GATHER_MERGE_VMAS
 	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
diff --git a/mm/Kconfig b/mm/Kconfig
index e443fe8cd6cf..1576409cec03 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -920,6 +920,9 @@ config PAGE_MAPCOUNT
 config PGTABLE_HAS_HUGE_LEAVES
 	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
 
+config ASYNC_PGTABLE_FREE
+	def_bool n
+
 # TODO: Allow to be enabled without THP
 config ARCH_SUPPORTS_HUGE_PFNMAP
 	def_bool n
-- 
2.43.0


