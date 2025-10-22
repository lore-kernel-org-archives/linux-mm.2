Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8D38CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54DD78E000B; Wed, 22 Oct 2025 04:29:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525298E0002; Wed, 22 Oct 2025 04:29:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 461778E000B; Wed, 22 Oct 2025 04:29:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 389528E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:29:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7DF8160759
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:29:19 +0000 (UTC)
X-FDA: 84025075638.16.FD0360B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf17.hostedemail.com (Postfix) with ESMTP id BFCF84000A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:29:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HO48mn1E;
	spf=pass (imf17.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761121758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzj4mNk1lBwNFeTIdeQPZxe+g4WElHt7bL5S6CjgLhY=;
	b=ZELiPjaSf35V8yPK7AK9nBNa0kGwT5Spul28WrZnafPSoYRHhjHPaB+TnVunKwtpYX5jHA
	SOxYIJwVGKsM/UqTaSmHFkE6xpT0lMGoU+EqjEIuvE58A6pkYO63hWbSykPK2NkfstJECX
	DzGaPMPvVrcguraYB40iUVAbdej36pI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HO48mn1E;
	spf=pass (imf17.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761121758; a=rsa-sha256;
	cv=none;
	b=bMVwW7GIJC7JE7Jr8FYiDBqm1t9KIZZtUUaND+AW1Yc9vA3r0g8vZ/TsTn9adQ26taocnW
	CyqmgoxvChiA16pA9jdhv+7aEzBhgIrhavI4pHciextY01BCU0yCjjPZrllsdkqHxhTD+P
	ug6LHuKYeZmwEgX7v9cmxqjrPGe3Occ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761121758; x=1792657758;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X8hpluMqUjHyF3NnFKeki1ZNOZ9A7wW3hfxRIst9gNk=;
  b=HO48mn1EaWM6bikVLYXswOm+wWf7J103gcxVuf89BePxwmBPzfryGGhY
   2rbWBd4ETjBOHyBQyJfUu+INYn8s4yuIn5EHnrdIPcooZQDmLm9SyjLge
   HdRc1l/jDECz46SOKUkKLNokuBcyZ4r6QKYkd75jOUiYAgnTOs6QAH80z
   cZww6i/czqqYexvB4gBBWukEsw8KQ54YgA7yJZZYfXWHpQp8VkurB2966
   XXr7LF27vBNOQMdC8sylTIdnTkHnUgtA/VxA6SB5aPR3xKN+An0GDR0Xs
   GeSdnv/EbyFYgR8ZZuojsjPoIy4R5U+LJ0JfStu/3yCX+90Hz+RqpUjis
   g==;
X-CSE-ConnectionGUID: nWSx7mg/QvK+RM5KJutoxg==
X-CSE-MsgGUID: 9lfGXzq2SGCANkKGEgdQ7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62292573"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="62292573"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 01:29:17 -0700
X-CSE-ConnectionGUID: V+b1HRBlR6SJ4CzEl3BbxA==
X-CSE-MsgGUID: akeshMYnSd64ObPki9LPvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="183516218"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by fmviesa007.fm.intel.com with ESMTP; 22 Oct 2025 01:29:11 -0700
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
	Lu Baolu <baolu.lu@linux.intel.com>,
	stable@vger.kernel.org
Subject: [PATCH v7 1/8] iommu: Disable SVA when CONFIG_X86 is set
Date: Wed, 22 Oct 2025 16:26:27 +0800
Message-ID: <20251022082635.2462433-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
References: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5t4jmw8i61c4ut57tk7k3d1p88butkin
X-Rspamd-Queue-Id: BFCF84000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761121757-70175
X-HE-Meta: U2FsdGVkX18dKJ5+hAFMEwNsRxGvRW+EhJXN3G5maGWJ9Jbbm2EqptP/rTRtSXK1HvUZ/KpuxgkES0EtHXWJWarcOM6SRZL3grUkIzfcWbJFSHdjffdS8TvDOrL9Zs5RpPq61G8ssFNjl5/c6BJhyszcTRJyVSlr+CC7PNbJhEMKb6+TgV18kBZe66D6vCFex1yzZa2VPftjrHZJNd7ZETrbV27jztqFcsM78V8YrM24J9BoQNfbDmq6pSwQlTtYUEMt93mk+LGshtepg0V4xmXfweB+RN5Gh9EBKBHGgatWhhBJYrWOjlXIgZdFKbhe/A5U5D11TpITzsGr6dZPNxSW5hQIQo8J+Xkf7KVSAfZO05Ghw5H+n5GXMTmtOJ4/0zYjeyUxNJWJvV7ueN09BGl3wf4PyCJBs3VuQq82943W5dlt6+Fs59lWppR6dHiX0dKgEEqSxy0c88Uplj4Z7tlqVt/wHnMRdPEyjQxWb102QWZrMRhQlYoSxQ2805o/NwNrP++KuFIlRIIItzZPETk7b4CfGyP2dNyI+BqSE0STeVQUk7QbSmOJsSe+fZM90a6GZsxLB3gFKOZFgS520BmCevsaVbZ1eypyjdJ8g3Oy15a3BkF4KvUlat3h709mBHVmf0qkuo9x1mL34eTe8sKSWCdGpfbiCTX40maAE2wkU8iBid2aiX2yIoShR5awUkZYvwH4H/gH6C+PIU0ABfu54oEy6w9rwadGNSxAScCu3p1imJcIXZ342WiSdaL2AQciialP9t1CbovFxKyuDTARB9usvhmQu5eG5kJri4PlSW+9C/3bB/gQYejfxdxBVdz1FDDaKHPWp2W+vR3zpB1ErgbqWsMA96A5nQlrZHjlVWYJRsZqrcmtq84O5SjJ+LMKTsUnBwoO1Twipmd5/yuLtYZhlhxX+Wu5EPRANwtgB1grMvcm7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the IOMMU Shared Virtual Addressing (SVA) context, the IOMMU hardware
shares and walks the CPU's page tables. The x86 architecture maps the
kernel's virtual address space into the upper portion of every process's
page table. Consequently, in an SVA context, the IOMMU hardware can walk
and cache kernel page table entries.

The Linux kernel currently lacks a notification mechanism for kernel page
table changes, specifically when page table pages are freed and reused.
The IOMMU driver is only notified of changes to user virtual address
mappings. This can cause the IOMMU's internal caches to retain stale
entries for kernel VA.

Use-After-Free (UAF) and Write-After-Free (WAF) conditions arise when
kernel page table pages are freed and later reallocated. The IOMMU could
misinterpret the new data as valid page table entries. The IOMMU might
then walk into attacker-controlled memory, leading to arbitrary physical
memory DMA access or privilege escalation. This is also a Write-After-Free
issue, as the IOMMU will potentially continue to write Accessed and Dirty
bits to the freed memory while attempting to walk the stale page tables.

Currently, SVA contexts are unprivileged and cannot access kernel
mappings. However, the IOMMU will still walk kernel-only page tables
all the way down to the leaf entries, where it realizes the mapping
is for the kernel and errors out. This means the IOMMU still caches
these intermediate page table entries, making the described vulnerability
a real concern.

Disable SVA on x86 architecture until the IOMMU can receive notification
to flush the paging cache before freeing the CPU kernel page table pages.

Fixes: 26b25a2b98e4 ("iommu: Bind process address spaces to devices")
Cc: stable@vger.kernel.org
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
 drivers/iommu/iommu-sva.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index 1a51cfd82808..a0442faad952 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -77,6 +77,9 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev, struct mm_struct *mm
 	if (!group)
 		return ERR_PTR(-ENODEV);
 
+	if (IS_ENABLED(CONFIG_X86))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	mutex_lock(&iommu_sva_lock);
 
 	/* Allocate mm->pasid if necessary. */
-- 
2.43.0


