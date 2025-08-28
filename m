Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AEFDCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 028B88E0011; Thu, 28 Aug 2025 13:12:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1AD28E0008; Thu, 28 Aug 2025 13:12:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0A408E0011; Thu, 28 Aug 2025 13:12:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C87DA8E0008
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:12:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4BF1EB7D3E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:50 +0000 (UTC)
X-FDA: 83826810900.17.E453058
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id AC722180006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YjBJ+byh;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756401168; a=rsa-sha256;
	cv=none;
	b=iAK55QkWTlM2maOmVleyYWT27Zex0i+xmPDUJOdh7cIYcfTPABPHdn0LbdPf56ekRtNlPr
	nqKmuO+2LM6gP52ZilRhL1+3g2QBSZoG8WlUNAx6+uK9AmvWehKJ/9xZepPHKQluQS2uAn
	v2v66pkkqWMEWzQGlTsXsoWhGqtGwmM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YjBJ+byh;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756401168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZwpT3dMG99pJu1dlK6KWJBnNEvDQMM8VQ7K+odivI+E=;
	b=o8pH7C+K/AXy2+Bpngad0smH5GVmMWypT+qYr3hiczo5A0X1L1WaF+vUBxwMnlBI01OhMc
	sKV2D8VVncuTtYXVbi8Hd/3vcvA304/lmf9TafJ22UwoL4deFppUOUfqK7ufkV1J2ubDmM
	mQfPWyD7yn0LskbalYIDXvpWunG3Or8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A87E344C98;
	Thu, 28 Aug 2025 17:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6573FC4CEEB;
	Thu, 28 Aug 2025 17:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756401167;
	bh=XMisQHBbtJ+sybKmhuOJ1thay4xxeICp3JVlocPQ0yY=;
	h=From:To:Cc:Subject:Date:From;
	b=YjBJ+byhXwpLP4Nhb/QINTUZnWulaCZqKoSScXOQYIiSWNc7HmO7cgWUK9DCbhhER
	 9ZlhUogSBYJC80pUmFoEBloHTU+emuuYJmcxdwdYcqfRm72ypvzteOE4VqPUn1y3q3
	 YDUZkC/IB904rebcUDG/PVHxhT67w5yky0HneQLa/utuX+TLFEApV2vf3ZRUrndLaD
	 OUy26STkYDEnMQxAE6lku0/ArwqiTnmECyMMuCTqphOWeiJvLdh9uO0i5gROgT05Rv
	 P2gdISyoD9FiwQwtnP8wrMa8k00SgYlUgxbqp5g7iGz+L+DaS3VCyUnlnBvBmtMLEF
	 uNCS3R8Zm2Dqg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: [PATCH v3 00/11] mm/damon: support ARM32 with LPAE
Date: Thu, 28 Aug 2025 10:12:31 -0700
Message-Id: <20250828171242.59810-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC722180006
X-Stat-Signature: x6qwset3rjhpxyecy6tpij5mp4qsd9th
X-Rspam-User: 
X-HE-Tag: 1756401168-227999
X-HE-Meta: U2FsdGVkX1+lcWsBgnwkI9ZbZwG4jVQRzFpxCsHDlIYls9+0ogSDM7OKzsILm+R/NjPEMpodnPKSr3eX9ZOqLy18kNmDpp19NlwcywS35VKuYVe8VWIH6vezLZusIIRToIByljGW/BVXfkW6++m8tLvOIdCG5BtGed0sK7UvwFlHoKJsPaWSywt8oVZRyMR3Akt29HEpEI7Mijmpb+wVwKBDGVV6GzpSlWSieFWOR6ApjXonlz1uHchJ5W4YgaWhXw83B0XzfcogFOUIYS0ViGLnLM3IDuORt6WajMQhXiMGjJYVhBKGfYVBjB0fSjIkVUGtFtt8CTysQb4kZHad8cyu1xoh5EsXQ/2vyTaTpf2R5NdITu5W8Ulht0tEmuv5pIFPtFSkWkEmND6oTWfdgpbdXrRbYsy9i2zMhaf9zzRplREe0ViB+MYj5xZ4AVqGHRV5pzwA8MhcKhoJuoDkvo/npl53O8bOfetcrFW3sI2VVT1aE7Qg31xhB8huOnWIcJbPi3wa9CMcXJ/bK6OLuf9N95kzInkPwrT53ZaFmtDH9O9KtN02Y3ukjiSoC3C/yVroWK3jcIbr9L8T/KH7N1yLCjOExcxjKRF/0rJ3nhQNcOfgqwxnQNQn1KhLnjtLcPjEKMDgiPWghPOpIZy8CeKkxlfHsUEjQ3M+/opqMOEWqx+eQBRCETlMx0qknWg6k0PsObvCtDopvrS/IwoMuVoG/8jx4+oYP8QQ9+7XONH2mJ5TyJhiwr9q9SIegsoGgfcINEdEFLLYDB1MwCHzHsZWecefmt6yFNJMuiGYlo1PH7Q5MZj03sb8MsoTHxuzNsA4Q5pzBx5VoWFv4FG9xhwihvOME1Gn6Ek6O+rCRskkciIWBu5utIShjT5VetnRKizD0XK4hO24BBPv3RWJ1T3FHo0/O+BWuIO9gJoFeYrr0HcQzuRkRk1mc2zjewDGphJfhUSF7Zkd6JVOnGI
 mvNSJ82+
 vq4gY6UzoOryJpFxRDLCd1LjRrstRoTmjD6Qupz5VlhwVUadf0W5njV10BjVuFjOQGJ9SYdyGfkSp1vVbMh0xR+zoB3tpakAhquxXQKe3MOxRpAxyqgPwNSukqb9GBwoJtSfVlhsFohzeSiQiPdk4qgwMCttJf1AS+Kam4ZCoNg6Hz1THMpFMfOT6ESWtH4aLDJeJPl+p4WofzjVcTp/sQLNWNrFemfaGYUNZYlv6MXXZsLElAaVlJa4lI4LYUL760+Fj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, DAMON's physical address space monitoring only supported
memory ranges below 4GB on LPAE-enabled systems. This was due to
the use of 'unsigned long' in 'struct damon_addr_range', which is
32-bit on ARM32 even with LPAE enabled[1].

To add DAMON support for ARM32 with LPAE enabled, a new core layer
parameter called 'addr_unit' was introduced[2]. Operations set layer
can translate a core layer address to the real address by multiplying
the parameter value to the core layer address. Support of the parameter
is up to each operations layer implementation, though. For example,
operations set implementations for virtual address space can simply
ignore the parameter. Add the support on paddr, which is the DAMON
operations set implementation for the physical address space, as we have
a clear use case for that.

[1]https://lore.kernel.org/all/20250408075553.959388-1-zuoze1@huawei.com/
[2]https://lore.kernel.org/all/20250416042551.158131-1-sj@kernel.org/

Changes from v2
(https://lore.kernel.org/20250822093420.2103803-1-yanquanmin1@huawei.com)
- Fix 64bit division linking errors on certain 32bit arch configs.
- Re-posted by SJ.

Changes from v1
(https://lore.kernel.org/all/20250821105159.2503894-1-yanquanmin1@huawei.com/)
- Set dst->min_sz_region as src->min_sz_region in damon_commit_ctx().
- Fixed the incorrect 'min_region' in the commit message.

Changes from RFC v2
(https://lore.kernel.org/all/20250820080623.3799131-1-yanquanmin1@huawei.com/)
- Rename 'min_region' to 'min_sz_region'.
- Separate the overflow prevention in damos_set_effective_quota() from
  this series.
- Drop RFC tag.

Changes from RFC v1
(https://lore.kernel.org/all/20250813050706.1564229-1-yanquanmin1@huawei.com/)
- Set DAMOS_PAGEOUT, DAMOS_LRU_[DE]PRIO, DAMOS_MIGRATE_{HOT,COLD} and
  DAMOS_STAT stat in core address unit.
- Pass ctx->min_region value to replace the original synchronization.
- Drop the DAMOS stats type changes, keep them as 'unsigned long' type.
- Separate add addr_unit support for DAMON_RECLAIM and LRU_SORT from
  this patch series.

Quanmin Yan (1):
  mm/damon: add damon_ctx->min_sz_region

SeongJae Park (10):
  mm/damon/core: add damon_ctx->addr_unit
  mm/damon/paddr: support addr_unit for access monitoring
  mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
  mm/damon/paddr: support addr_unit for DAMOS_LRU_[DE]PRIO
  mm/damon/paddr: support addr_unit for MIGRATE_{HOT,COLD}
  mm/damon/paddr: support addr_unit for DAMOS_STAT
  mm/damon/sysfs: implement addr_unit file under context dir
  Docs/mm/damon/design: document 'address unit' parameter
  Docs/admin-guide/mm/damon/usage: document addr_unit file
  Docs/ABI/damon: document addr_unit file

 .../ABI/testing/sysfs-kernel-mm-damon         |   7 ++
 Documentation/admin-guide/mm/damon/usage.rst  |  11 +-
 Documentation/mm/damon/design.rst             |  16 ++-
 include/linux/damon.h                         |   7 +-
 mm/damon/core.c                               |  70 ++++++-----
 mm/damon/paddr.c                              | 119 +++++++++++-------
 mm/damon/sysfs.c                              |  41 +++++-
 mm/damon/tests/core-kunit.h                   |  21 ++--
 mm/damon/tests/vaddr-kunit.h                  |   2 +-
 mm/damon/vaddr.c                              |   2 +-
 10 files changed, 204 insertions(+), 92 deletions(-)


base-commit: 398a6e2cbd43b92d9a5fa6b4020be72c2441babd
-- 
2.39.5

