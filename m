Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 781FDC5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 04:31:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C7916B0394; Tue, 18 Aug 2026 00:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89FDB6B0395; Tue, 18 Aug 2026 00:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E556B0397; Tue, 18 Aug 2026 00:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5877F6B0394
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:31:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CCB2540A85
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:31:52 +0000 (UTC)
X-FDA: 85113117264.04.F6F0CA2
Received: from mta1.migadu.com (out-100.mta1.migadu.com [95.215.58.100])
	by imf05.hostedemail.com (Postfix) with ESMTP id A0F4110000B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:31:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eJ0sYUFh;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.100 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787027511;
	b=36DrL0bBTl5H9O7E7OSDraSF0Qn1gPLBIBdUjLEkVWzZpOrJmUoGHzsO7zQOHCfp6Bi4Me
	S4wfuagkJzV6Aehm9WE4a2rp2TVXCCKf80sus7EdLnTwgRMlC9N0sPoqfFT6d7HL5C9qU2
	o1+qLOsEtIIz+qmIFADOiO+s/ycsiSk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eJ0sYUFh;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.100 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787027511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gk0ZehlrJSadol57C4ISMKAtZvepnSELO6PZTCv8qK0=;
	b=Mf1S87U6uPqX1Ku0hdzFtVCFdil9Y1UZX62qZTYO39cfPgweSlNqJWmoJx0vQCWYvr0oDq
	aGAGudAxx5wAlL7eBWPtwaDdfnHGFPPJNlC1G0QeSBcbwzPCd61zP4c2eWXNMFgDeSibKn
	vHulcyJWtwwWU98OaxNKTSAXzwJwT5M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=b2qJdvQbeH43yX00jUqynKJ+7oIe65NCighffZRb504=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787027508; v=1; x=1787632308;
 b=eJ0sYUFhhZAuNKTQ/qzhVQzv//0wCF3uo5zIDptKyc4TkCe2wAVOR7+S/zUqC+D4Pfp0ptqn
 Oxavt8bxxgp9Di83cX4p3PyOdnaQ0xQtrbCd+CmoGDeJHUkK+3HPsXG6iV5x0MJjGHyyHRrxIdj
 7pwE9FAkyMc9LqHbMDNE8qgg=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 64c7aa18bce6ebfa;
	Tue, 18 Aug 2026 04:31:48 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: gourry@gourry.net
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v2 0/3] mm: reject zone device folios in more folio walkers
Date: Tue, 18 Aug 2026 12:31:43 +0800
Message-Id: <20260818043143.22297-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260817220810.1175596-1-gourry@gourry.net>
References: <20260817220810.1175596-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A0F4110000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: sf1o7we8zic3hpbyggacs3mdjbx5qtnu
X-HE-Tag: 1787027510-981517
X-HE-Meta: U2FsdGVkX19roRMRl+XCtRCGGsvYaBy/HrpX8uTbrwPKDoR3ANFT9nzqV0oE5fD2cqR6e2wtTOlTWPo+zchGT5Xq7Gwkmu13Adr6GImLBlcctmYL/7deLIENKPubpbiotEfz7V/J8p74kddlWZ8si60b7SPNprM4XnwtHHIZgstCUz6t7PWEo5S5DMj3iX+jaRuJf1yvPgvVbuyAcudMV7u9YfdZpFxRnx4mg1+6zvylKw8bj8zqFQCxaBY1rMB4wQr5xrhwDiFzvjA8bazV1HQ/lS/eBPN0mOMXCD/leMciWhwYVflxwzMnl3wFEBtc8SKqaBYD+9yBCL32GWO8XpKlD6hW7N5/8S8cgsWyfIB4s8qxmsERL5rfJvcFBSWeWasXCKFa6VGdHkCb4arNsysflZWyyVZGIrhUowDVP86KRkBhGwNPOKN7MC9f5VFYW+gN9t7kY+GYZWuhBbCBZnuZSWjjo9HdCVf4BzsHSHt4LgbRPcz0+v2x7Ewdnt1V4wmRIRLhOXUkabFFGeVicCFIJr0lprtRKpoUrq/rnJN3C0vWEmUo+ymUIxSEShLk1/zjH/QNsw7ZBipnqxM8/kHoSGSe1muWSrbcTeeycgXn7SBT4ImrMxxyNQ6eUkJY/aXn5ycdJbgLWpquLg60MqQCBB1ImWM7DlNvClmwvI9ZQSB3B0OL8N2cyFjVXyTtQg03fClBRn08IshxqnbmAe/w9QvLTQcAGG5ABhma8nzU5D4NCQNEt0cgMU+dyDG+r8sj/SkWRahuwdojjUbda+czQhYglDc6rpbb6MUkkqCUe+xGaSkpJIBWXQx4se709iKcqi6D3vNSXK7gfXBCS88XWmp1DWgkxv5hEIrS8KLevtFDUiYttnTkhK6eMPVQG2SM1K8lbmLqaU62dK5VWo3ufPDuivCVhWvheYq/XGzFBY93HOE+/LMxWyx5/qNn2eENQYxRoqXoIqb2hXF
 37C6r4GW
 Mg4VMp/pDAWX9rLhnA2EaXNp9wDcLk00Ok7ZOpwt167SBLa/iFQL91nMpB6VSqp3e+z0TUhHHLcWVRuNEwo8868e86ounbZFwwYT643pil6RiosCMLLxiUypbcrir8OFYGhzZANxeS2+v96uBGrv73hU3H97THJsKlLHcBaCX1KOtkCUdpmQubb0MFv7PH5VJG/sXVRoIO0PTrcGEsFdGMN2l6n3fZ0pQE3lGpJ6rohFtcKm30zc9irADolLmpespZA01sgPi9vKcJl+5cF1GxHFGIrK4lAL8HseSJcms9zBIetjZ9vsQN0a9vtOaryLQHJEOYBomDfwSz6eXusH9MQlXnTuZArqICfCjU73BJeJIUUs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Aug 17, 2026 at 06:08:07PM -0400, Gregory Price wrote:
>Several LRU-oriented mm walkers resolve the folio backing a PMD entry
>(or a physical pfn) and then reclaim, age, migrate, or lazyfree it
>without ever checking for ZONE_DEVICE memory.
>
>This series adds missing folio_is_zone_device() rejections, matching
>the checks that comparable walkers already perform.
>
>- mm/huge_memory, mm/madvise: the !pmd_present branch above these sites
>  only filters device-private entries (which are non-present).
>
>  A present zone device PMD (e.g. device-coherent) would still reach the
>  folio and be lazyfreed / aged / paged out. Add an explicit check.
>
>- mm/mempolicy: queue_folios_pmd() can see a present zone device PMD
>  (e.g. device-coherent) and queue it for migration.
>
>No crash reproducer - this is a correctness/hardening cleanup found by
>inspection. All checks are placed after the folio is resolved and before
>it is acted upon, on paths that already hold the relevant page-table lock,
>so no locking or refcount changes are involved.

Cool!

Gave the whole series a spin on x86_64 QEMU with a PMD-mapped
device-coherent THP. Without these patches, partial MADV_FREE and
MADV_COLD reliably hit a kernel panic in remove_migration_pte(), while
mbind(MPOL_MF_MOVE | MPOL_MF_STRICT) returned -EIO.

With v2, all three worked fine, PMD mapping stayed intact, and data
checked out :)

Note that both kernels used the same small change to the in-kernel HMM
test driver, allowing its coherent device memory to be allocated as 2 MB
folios so the PMD-mapped test case could be exercised.

Tested-by: Lance Yang <lance.yang@linux.dev>

