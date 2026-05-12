Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59FB1CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 11:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD68E6B008A; Tue, 12 May 2026 07:04:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86F46B008C; Tue, 12 May 2026 07:04:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9755C6B0092; Tue, 12 May 2026 07:04:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82E4D6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:04:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C83A1C109F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:04:10 +0000 (UTC)
X-FDA: 84758483460.08.5D67CED
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4851AA0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:04:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OMRLIhGT;
	spf=pass (imf25.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778583848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7yC5INWPkyd83Ljyyy/Ta0qbxJas75a21xgNQs+1waA=;
	b=Od32GXzWeNzggXSvieC519mFK9eGlcQwWDxc0QkeUveyKCVYjJJnFYfuxef72vx+1dsJjM
	7StnCPvMJJvftlVSL5u9mkwxfz1VfVdiGjXImz3+SLyislxSngcqqe3nwoVw0f9sU6gRmB
	kU2Wb9Iq7uOIcC2pumyRDhUe0v/kXpw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OMRLIhGT;
	spf=pass (imf25.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778583848; a=rsa-sha256;
	cv=none;
	b=woMLLYPXTSODer0VRbDI//qFfR3ZPqDCmX2+kJa12T6o9QNNgnhJArgiBZmDWt31762dYg
	4+l31Gid4JyZGjNZFZppVuYPmibr+XWQn3vkPMcmOTNwkmsyw2G3T7gnKb8rHbB56s7Hg+
	964qUPYi0e8ldI3ymO3cOl2KEYrU8j0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778583847; x=1810119847;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7KOlaCmQVQ38tmd3TXFpuRwgbIM2E/PLAoYmYrZ5mX0=;
  b=OMRLIhGT6zsqGsZ9JO23imMVMGHHVk2X1IeB6vGoc7toQ4lfwJxXdzvO
   OER7g9m6uBmjCF15VUxAwHHUg9Moy780kf5cWpQdw4Ef5L+C+4IdEWQjI
   xCq+mYZgMgxECeO5Zah7POB9x9ElmQiQHTtogwx1jyat7Vfh3AekrfAR0
   eMPrp4yds1KF7aCZeyrABgjTCGtMbvR2NqvgYFZdQ/Vud325j9a9wlsFI
   X7pUkfqJvfPTLawdMBsMZ4D1IXhbGQJRqC+c/r40YYBo3/tTrFiJt1Njv
   TWY3qBNCs3Xxd0aw3hRJ56aQiSSG82Aqv7Jkl0sHlj7IiLwmtms8UBSlq
   A==;
X-CSE-ConnectionGUID: PcwYoL5yTcOKwQNZ536KMQ==
X-CSE-MsgGUID: yGlweuscTcm9M0zi5lCJMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11783"; a="104944448"
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="104944448"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 04:04:05 -0700
X-CSE-ConnectionGUID: TOA3ylJtRESQSd0LzmadNg==
X-CSE-MsgGUID: XsVunJPJTWeK9QXHKv0OgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="231339480"
Received: from vpanait-mobl.ger.corp.intel.com (HELO fedora) ([10.245.245.172])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 04:04:00 -0700
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Insert instead of copy pages into shmem when shrinking
Date: Tue, 12 May 2026 13:03:37 +0200
Message-ID: <20260512110339.6244-1-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4851AA0002
X-Rspamd-Server: rspam06
X-Stat-Signature: yacim74kq78kq4ckf44ewhirao86t5xu
X-HE-Tag: 1778583847-603627
X-HE-Meta: U2FsdGVkX1+9gbnxfTk/Cvv6Twa5AXU6zUz9ocQatI+n7yGMuJKo/dLfLf5dIF2+lJXBP27k6ok27TOAH4xV5mOmC9vamppkOJYxpa3MVseUHhOUgqonvd8soWMxDomKt1GESkJliW3RDo6fXvKGrVhN6ciPwNwQxXJPviS82YBqvDNXrJMFVq0eaqpqJAUAUCkWckpACtx9kkiuU6cf8yiE1w4SuZusDom9NrJBp/RuDlRt8Bj86BPLhJaC4krQjXZHOF+P+UUp+wAaBZ6XUypI0eR3Lmqe3/DUNytU6v4oqtLdFx7qeWkQ5CuFjTI/SCqcYTw4f7m7HdPrVUYEK0WDgZnH1AgiEbAT1hMKcJMQNps454F1kJpqOIR3OmEr3JxHnReyUqNV8BmR2wtT4RsG0y4GyTXcqfSa/fSyZJPLNMC+0RJMc8B5x+CgN2qeqtFS3T8YEplKbXchTOM1guIPee3mbwOGPk3rM+QNQ8Vp8+LwwnbN9U0ak1/dOyzExlj3tVa8Eq/HrKunMmk1V5ZjhmH9cpUl7Kn5pa7lBOUHZJqcfgypzeqOFXlh8NKQh6mtVnNX96bcRE2dPeUFp+TmsqTUMWXYYWuAh+VF0I3+61PD+hYJB6cbPtMHjpNukfg++cBCbh2dPjEYE/AAVNcJCWFw8GfN7qN7/nTAxTSzfvC1oCWQc/VwPgWJxcWmcQ0tqDj49bf1//VdVjsDrQRx/fde5Phz4FNw3VtTZPFpscQXSijiYt/zwTR1u386t6w6jhxdhDGp1BJwN3n9b/S3aqH0+9IkZCAVd+EA58oS20V2fVwS5PvpYTX9XDAQ4BMkKluwCup5Z848U+mmu9QrdQo93KoMKMuKTB4Bc9zQwMTOupAw8UowFynknnmaCDih9t2NCCBoyapyy6vNJdSNcZ/DBOuIQ6iOLuKR0NwQScW6wF4+JtlvkaEtcixImtNsJdSvGEUlo3gTywn
 AYFxc/Vm
 Y49fCfpw+LPXbI+kWcogOlegQsCY02mvxFRg6V9x6BMMfYwyBaEHIzNZd1zpoXBEAInWgF08P+IDYjWqae5fpmv2ZOgSryX8PFPdrIq0Ngi2gJwRvaLlyyyo8MZfVk1jv2CbrOVUJwSKjGQ5fbQL1a9dI1pQ5BxS4v6dIU+Tm6dXKcZY/1gkRr0orvPZRurZiqIjsu4FS+kZyddOlgy41Acf4wAn/cjIejW4nANVTJHuFxw6JBOZMHDKjow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To be able to easily maintain pools of pages mapped uncached or
write-combined, TTM doesn't use shmem directly for buffer object memory,
but on shrinking, page contents are backed up to shmem objects so that
the content later can be swapped out.

At shrink time that puts some strain on the memory reserves. To copy
a high-order page, one either has to dip far into the kernel
reserves (one high-order page size) before any memory can be released,
or one can chose to split the high-order page into order 0 pages and
free them as soon as they are copied. The latter approach is used
by TTM but that tends to fragment higher-order pages.

One approach to get around this is to insert the higher-order pages
directly into shmem objects, so that if CONFIG_THP_SWAP is enabled,
they can be swapped out without splitting. And at shrink time there
will be no additional memory allocation save for the shmem radix tree
allocations.

Add a shmem interface to insert isolated pages, with enough
asserts to avoid a user of the interface inserting pages
confusing shmem. Then make TTM use that interface.

As an alternative, one could add an interface to insert pages
directly into the swap cache, but since the swap cache doesn't seem
intended for inserting pages for which we don't immediately
schedule a writeout, the shmem approach was chosen.

Thomas Hellström (2):
  mm/shmem: add shmem_insert_folio()
  drm/ttm: Use ttm_backup_insert_folio() for zero-copy swapout

 drivers/gpu/drm/ttm/ttm_backup.c |  92 ++++++++++-----------------
 drivers/gpu/drm/ttm/ttm_pool.c   |  67 ++++++++++++++------
 include/drm/ttm/ttm_backup.h     |  11 ++--
 include/linux/mm.h               |   1 +
 include/linux/shmem_fs.h         |   2 +
 mm/page_alloc.c                  |  21 +++++++
 mm/shmem.c                       | 105 +++++++++++++++++++++++++++++++
 7 files changed, 216 insertions(+), 83 deletions(-)

-- 
2.54.0


