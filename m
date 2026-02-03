Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FF8EE6E7FA
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 10:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59E7C6B0005; Tue,  3 Feb 2026 05:46:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575EE6B0089; Tue,  3 Feb 2026 05:46:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478336B008A; Tue,  3 Feb 2026 05:46:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 34D3D6B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 05:46:03 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34D43D4A9E
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 10:46:02 +0000 (UTC)
X-FDA: 84402815364.18.9A2823C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7665A40012
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 10:45:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PWQQxToQ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770115560; a=rsa-sha256;
	cv=none;
	b=akNoQZwQ/9u/edogu3Gt8lR4vIFo+T37Mcmq4mpae7MQJ2hGJRTkxHv0kY7oFuos7u0xQw
	QfZKv8VdRWKitiOZRcDIe7EJ4kT2tj2sevwAWEo+0MRkJRHuqSyN6fJUu4bYVNuch3EHzH
	0772TsIDgpMg/SxE95uNdiN3bdQvUBQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PWQQxToQ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770115560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8VATGLQu7syLnVJBTQ1R5d/vkW/tQsLc0Kjih0XxmlA=;
	b=s1qscn2snmahvLiOw67HIdXdtai8DojTFUDILSGCy2ziVGVNJMf+Y7VGeAQS++jjNqrcdQ
	lcX5lFYFk4FcvQXbmVa9dhrPsJDqQspFmSd336GLtN60G7W2u1sbsY6jntJqNJb3QnaWd/
	VGkA0xUKdUyxVI+6+jzc1RE1JFlhvuY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770115560; x=1801651560;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kjyxA60L8xhgKFON85U0bBh5TOrChBXp9hwXJ5/2Fvc=;
  b=PWQQxToQ9Fu0cKcWcsYEmy7APWTzrL3ON7trEEX3QrGNGaOVvpxrHuO2
   8QIdwOCjlaKfNd+1nSqObqt224VHtFjoL0U8uqmmTdzysZcbkV3h814/I
   H9QWBe53DkPUHm4SJb1aBO60g0q950a0oSMPvXu+sROQ/xIQvHPL/Dbna
   ayBXJuc6BrB8QiUXBNa9ZWOESvwkSiOY68T6itwvZw9dCafw40naFfpcr
   jV35bcrnGhKsyftgx1CbSfQ7+OdTjTpc3ZLEp/1TlFEsuiMA/ZXOcPqxN
   fRkhmtMMhjQ3QPS7tvYZy8zegmrmyQRZJXqZ6e3yOIBfWpz0OSujLWvYV
   w==;
X-CSE-ConnectionGUID: GNs0oqdETf2WIrTFk0spVA==
X-CSE-MsgGUID: +4WDOuHSQZKhFnh8MmUIFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="71005737"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="71005737"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 02:45:58 -0800
X-CSE-ConnectionGUID: OxX4/WPKS7eRU64QvwjcBA==
X-CSE-MsgGUID: GSPn8rJPR4O6xritYvNlcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="209982222"
Received: from rvuia-mobl.ger.corp.intel.com (HELO fedora) ([10.245.245.55])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 02:45:54 -0800
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Brost <matthew.brost@intel.com>,
	John Hubbard <jhubbard@nvidia.com>,
	linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org,
	stable@vger.kernel.org
Subject: [PATCH v2] mm: Fix a hmm_range_fault() livelock / starvation problem
Date: Tue,  3 Feb 2026 11:45:32 +0100
Message-ID: <20260203104532.98534-1-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7665A40012
X-Stat-Signature: xj6qeg4jitue55167uiwykwezgej5fmr
X-HE-Tag: 1770115559-198255
X-HE-Meta: U2FsdGVkX19is7nUm1UhNDqdf4Lbe46RlnphA9H0n2hJJZ1aeohzM73+l5bxd3428yxB7iGZ26ZRdj31FXwKHDcgp0BXzg6BSwbcPQv9vp0aDvRkkUloi3e47nSCFhls5bKqxpEjKQ+vWmxFIq4Hhgeh2wS7mTWz3O01r05R0IS9mUUL67+1wYCvQZeaiJCHrInPSEBPWyPVdUaPYG8Mhv2gMAzL/esBDUEiqsNuz5iWYQwkPJs3PRvLhgCdUYxEQktfo2MNImeowI4G4Cgh2tT+xy3Tli8XgYQbbnlhoYkBrEBIKPhuj6GO7wLFBe3qVRXHdMg3p6EVWWNk8tRxcvYDyTRm5xxPiq5pI7B7k//DqOSjNYeDRW+23HtJXo2YgZyUQJoLZOF1dfjjBrxhRwqyf2e/KWkFKP6PdAED/zsTmT7DaKvxbVG2QjPvK+O+o0rm9ng50uoLzJ0Oo86IwP5AwatFe9FLnKT1uc3up6pRAgQWG5QOsXdXaOiAeuaTz37eDmqDGTQKDxLGrw7c2ZFLOZA+a7TFDdBiUpman7RkarzHlyOBw3uXcA66IXCiJafU9V8OQliZvgf+PhhGpdWU/TCbJ0ZvV1QWSDHp7DKcnFLL95NbwnIJeRf2eZ0ccX+4WtVYLBVFp6vLavfoNM3KImbD6uyNGB5nf+DIzIYLPCtxVWmpGw4V7cx0fLzR1cbQ9Ncpjco1aOG2iSJIPf8WgPqTMItZBOq80llqqHlKKJqjCCBfnRdgryg4F25tEUFcJmSzyLiX8sGR3XMNG8YjLBlhjKLwF5YnyYdjsqST6RZ/eYRlZxoQ4sW97oggyyPyXngFDpL3w9CWNbI5RRdRCc/+xt7oKceWPnlz8gPG6b9wAFZzOTqhH7J9UcULR+xzWYtBGSXBKWUhZeeD0SIl1FojGAbp89CKI5waHBEInvXnMA9kZs04AkhNdhxHwTmclaXLDwx44kKO48u
 Vz+TMlKR
 xuKm/NyvAcfLvQQAVTNGlgJFcSkfZE84EWdm1m6MCSX71Ajemts0quvdxBDQgqKD1parloMN5C4v+lp9sFQAaj8wGgUXuM38kPH/urBBRvLBe4pnltfXfm0tIgNq1RdZAmg6pJkpPeF8/yPXudMHohB2SipxmPQynEWPAJf9VKzHhQfIJEPyC783lJndF7QPOKvorKD44kSOwJEIR3k9SO8ZjdlBGdxIU+Qnsb08TIuMo/OZfLY7m9Rr0+/U3Eau8eWrwc2BOGd9N3OTOjdQ+L6EvevGhWSCyy2hESzOPYMKt9N6mcC8UNIcvkHEokEYBtkuHIk8arXFaxlxa6+C3rIq8Ul+I68jmtUWN7DH7ihT3lTJWCSXl4Fpj0OEHgPfdDG7POcigxIOJoFyVUF/ilE2xjrl0v36wzb5BdwpWYsSMZGsL5hwlAlchbQlUIJ27xEPfMTsQp26Dk0S1fFe6bNjR5HvH3MWs6CcknmH1LYd8/M5wGRAvdy4A65UJF++iS0sMySxMQUQmNydcY7HWJq8ZUuv3fS0fmFvknYhhpigx+89JpkVHEKFbArYrBG2Dyf6/Cq2jrE/i9dl6WwMrBgMjbKqtm8Eq659EwcJoGuLaT5W6UzfmxhfLHn0y6I87mm7TD/dM40J/nFrC5Dz3ltObBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If hmm_range_fault() fails a folio_trylock() in do_swap_page,
trying to acquire the lock of a device-private folio for migration,
to ram, the function will spin until it succeeds grabbing the lock.

However, if the process holding the lock is depending on a work
item to be completed, which is scheduled on the same CPU as the
spinning hmm_range_fault(), that work item might be starved and
we end up in a livelock / starvation situation which is never
resolved.

This can happen, for example if the process holding the
device-private folio lock is stuck in
   migrate_device_unmap()->lru_add_drain_all()
The lru_add_drain_all() function requires a short work-item
to be run on all online cpus to complete.

A prerequisite for this to happen is:
a) Both zone device and system memory folios are considered in
   migrate_device_unmap(), so that there is a reason to call
   lru_add_drain_all() for a system memory folio while a
   folio lock is held on a zone device folio.
b) The zone device folio has an initial mapcount > 1 which causes
   at least one migration PTE entry insertion to be deferred to
   try_to_migrate(), which can happen after the call to
   lru_add_drain_all().
c) No or voluntary only preemption.

This all seems pretty unlikely to happen, but indeed is hit by
the "xe_exec_system_allocator" igt test.

Resolve this by waiting for the folio to be unlocked if the
folio_trylock() fails in the do_swap_page() function.

Future code improvements might consider moving
the lru_add_drain_all() call in migrate_device_unmap() to be
called *after* all pages have migration entries inserted.
That would eliminate also b) above.

v2:
- Instead of a cond_resched() in the hmm_range_fault() function,
  eliminate the problem by waiting for the folio to be unlocked
  in do_swap_page() (Alistair Popple, Andrew Morton)

Suggested-by: Alistair Popple <apopple@nvidia.com>
Fixes: 1afaeb8293c9 ("mm/migrate: Trylock device page in do_swap_page")
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org
Cc: <dri-devel@lists.freedesktop.org>
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.15+
---
 mm/memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index da360a6eb8a4..ed20da5570d5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4684,7 +4684,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 				unlock_page(vmf->page);
 				put_page(vmf->page);
 			} else {
-				pte_unmap_unlock(vmf->pte, vmf->ptl);
+				pte_unmap(vmf->pte);
+				migration_entry_wait_on_locked(entry, vmf->ptl);
 			}
 		} else if (softleaf_is_hwpoison(entry)) {
 			ret = VM_FAULT_HWPOISON;
-- 
2.52.0


