Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 924BEC4452D
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 17:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 480126B0098; Tue, 21 Jul 2026 13:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457596B009D; Tue, 21 Jul 2026 13:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F6B6B009E; Tue, 21 Jul 2026 13:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF18E6B0098
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:47:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A76FA0906
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:47:36 +0000 (UTC)
X-FDA: 85013516112.05.E5416A6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf30.hostedemail.com (Postfix) with ESMTP id 86DFA8000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:47:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WYEYHPKu;
	spf=pass (imf30.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784656054;
	b=8YqPgkLKYjEzbuejgpkGfOPPvyXRo5bKIWdheoHSTZGs+RtnPvZhYqTv56p4I7+bQz/aYh
	uHQm1oFFf+RyD4hLvMUmsthNO3oUA+EjRWsfudnKMPtyaSOvnV9TIQedMTW8cn0jJaeiPC
	hPGYVyY4ubfgnz+zfxb++PKoezxNdFE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WYEYHPKu;
	spf=pass (imf30.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784656054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3oX3N2HwwJVG2SesNfw4R7Q58HQ0qdjVj2e06TaHTIk=;
	b=MxbH12N5GdLjj64KTOXvQawPQnJGzy4LpVZKkiu43kl+Cf0X5Z+H+61ZNhxVkMwapXChcL
	QchERwsk8+JVYO59Vv80/03Tno9ANTyaDMbUyj4sigaRt1hKwOqXjaUgMxinCChaO1r1Q2
	tSfp3Nwqp/v7GP6k9myQR6pY7MRjLmM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784656054; x=1816192054;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nKJKT/P+qEgUMo/wDI71pfPxFpDWy8cquVcetFsF/9A=;
  b=WYEYHPKunBdU78e74XnLAlYu2hsNuwTpcp44YJR/iN4NN93/z0hzMRnS
   VsJNG9RKjEeyR1n20MTRwkEB9wwhwc5VjIMimzRgB8GP7OgZ5o+k4vy8j
   jDazoaMCUdZC27vlho5lPqgnIJxlQ5megH/Mfwb9e0sQaToDc8jdBdcmf
   J9J7y7p5G6dK05u28pVOOTLTA88Za1NjEVC3rfpTo6AnPTZkMKH9tCUNm
   kbuGhUydOTdRr2rx+WgoxCJ3/w5Yj06gUoddQH1T3frlCbpAWnKAFjNFZ
   Oi5evWrIoougPnQK0Y/q9CFIC3rcxv9NmPjVk4VAuCc9NSw+Q5BS/EcFZ
   g==;
X-CSE-ConnectionGUID: U82sTtc1SG+JXBaC2ZlcQA==
X-CSE-MsgGUID: iOHWN9uPROCsAuvg88S3Sg==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="95920601"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="95920601"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 10:47:30 -0700
X-CSE-ConnectionGUID: aX85PhGqRZ2+OzCWKl4KjA==
X-CSE-MsgGUID: C9cUg2WjRnO17Cple9Z0iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="254418016"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 10:47:29 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] drm/ttm: use shmem_backup_folio() for folio backup
Date: Tue, 21 Jul 2026 10:47:23 -0700
Message-Id: <20260721174723.1039395-2-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260721174723.1039395-1-matthew.brost@intel.com>
References: <20260721174723.1039395-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 86DFA8000C
X-Stat-Signature: ue1mcaquhi8e1h1o44wg6dgog7em11md
X-Rspam-User: 
X-HE-Tag: 1784656053-287638
X-HE-Meta: U2FsdGVkX18G9KHQ98bwzosNTxYIzGfhcFNY0F4LPfgH/ZZyUQzk3PdFm9x2DGZYRNAilqbMl7MFhDE3yeypU7cGLRiNwzNSyhKqmITlEwC9LrYz9Fa6VFe/R4p5H+P1Q4/7GZvSa3SdesAIX3AG9PwkHGIBS7uRxdKfK3WdvEcpaBKUs0ju2iGdV4Two6K/fAfwEQxw2pxDTmVFTwULsLZvgo2tav4LFopyO7DtRGiXxZmXeRegHaAl6pMwRzwyIUW537SQcQkSRQtZzXY4zqiVn4hTzl9nkBqkXqhaKheYe8e6lEibYeEJ9B+la0rkvf1O1zdzEe3eay8ruNv+JaB/664+px5D3QqbLL+qC5k25aDIyezTemnWEbd6wNpnEJ89T3piLpprc9t68uFfuzh4NAfhixi24qaCGnSLLhwRwbiY1481gSW2pBWI2GG86gYT0AQVt8RqQJa7UNtEPvWHIBAz//z7AHDZVV/M1vPWwoCDhxAwqAB4exyblBgTWzH1N2gXUk9FQ2gdsHf5KazODwkK6FShFaTlWjqKyPYopuCY6mzRK+mTC3urOagsfZ9DUbS4t0S4qSUhU9kBsKCuClxi+yq3/vyvwKzq2Dus4d/kxGuYNP+KBuvQJJVc3EHg75h1u3WGfyUAEPTdRJIraIriShR/uPm3/bPaxvtwtFjDYOPOtlk/aFbBjG5hO0NVfYMuo4zRSUeK3zTJWrdT0AwjyNHWBoJSxeEuJmb+BbxlO/aHYi/HEVJnwnanYg+uV7OWvMt99Tal13kB4r555M5HhdaTQQ1JXrE1q3LXAvQaocjr0XTJyNZ66uh6/UARA2ZD9Ri14v55x5Um1Fn9LS5bd0UBYiBJ0u3z0Ta2kWRFUTw55QRWrGdxqv6q7Pt1HwQuHsXoaiBymWhH8StrneZy15Sa26gMwX3EUBlbab5C9Xt3KODRo+LLkDAS+OIWxgVVdZmQOhilwjn
 ZGwsAXMl
 vOXbWfQ2N3SceTUHCJs5JPv7fxGlhLifvsTunEH/DH8dD91v1ygef3AHZ1q6b556FVQPpr5T6y5xUy7C+vRC+E7MGXpJ2twlSUp2DCyqCzrkRytyhQ6ul8Ax498EvwC+Qo8lmLQUzHPVvlEqdP2Ik9LuIl23dDHnqvwdLoGSPYpzZZYAP39Yh6EEhylRyHMQvdnzD5OK8+w7zb1jbnBY3dygTEtHEkarS1LuTXUYuCQyFeBvqqTIBotN2DN9v/SamAjDNhpcrnjKfp8P2N3/ODJCLQlkx8QyelGqCzwCQKQz6YY0Me0iyRMAszUFCi5CI8Ht0BuQ8zzo1oMVWI+6l487rfPfbDgucP5eWD1KfOzYaFstfl9tbn7+r1jRHQXYQ0R1seT2DL5Mp33HP7eHCvgoWqv6ztlvgl7LhNoqS4ZA7uZCgtTLoywN60WQvc2BvpEWgb/rRys8ErBaLXSEP9OUd9SSFDIK4ayZGa/Kr5tKZLqf/yLGTb1+zJFBF6INjTQT4eTaFAvDn+Aw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the open-coded shmem-backup loop in ttm_backup_backup_folio()
with a thin wrapper around the new shmem_backup_folio() helper. The
wrapper maps the helper's (int errno, *nr_pages_backed) contract onto
TTM's existing (s64 handle) return convention:

  - 0                                     -> base handle
  - -ENOMEM with *nr_pages_backed > 0     -> base handle (short backup;
                                             partial progress kept)
  - any other error                       -> that error verbatim

The mid-compound -ENOMEM fault-injection point that used to live
inside the per-subpage loop moves up to the wrapper and takes a new
shape: instead of synthesizing an error partway through the loop, the
wrapper passes order-1 to shmem_backup_folio() when
ttm_backup_fault_inject_folio() fires. shmem_backup_folio() then
backs up the first half of the compound normally, returns 0 with
*nr_pages_backed = (1 << (order - 1)), and TTM's caller sees the same
"short backup, nr_backed < (1 << order)" it would see on a real
mid-compound OOM and drives its reactive-split path unchanged.
Injection is skipped for order == 0 since there is nothing to shrink;
the previous "inject only on i > 0" guard mapped onto the same
observable subset of runs.

No functional change intended for non-injection paths.

Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Assisted-by: GitHub-Copilot:claude-sonnet-5

---

The patch is based on drm-tip rather than the core MM branches to
facilitate Intel CI testing and initial review. It can be rebased onto
the core MM branches in a subsequent revision.
---
 drivers/gpu/drm/ttm/ttm_backup.c | 91 ++++++++------------------------
 1 file changed, 21 insertions(+), 70 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_backup.c b/drivers/gpu/drm/ttm/ttm_backup.c
index 3c067aadc52d..a6c4e6cb643b 100644
--- a/drivers/gpu/drm/ttm/ttm_backup.c
+++ b/drivers/gpu/drm/ttm/ttm_backup.c
@@ -105,76 +105,27 @@ ttm_backup_backup_folio(struct file *backup, struct folio *folio,
 			gfp_t folio_gfp, gfp_t alloc_gfp,
 			pgoff_t *nr_pages_backed)
 {
-	struct address_space *mapping = backup->f_mapping;
-	int nr_pages = 1 << order;
-	struct folio *to_folio;
-	int ret, i;
-
-	*nr_pages_backed = 0;
-
-	for (i = 0; i < nr_pages; ) {
-		int to_nr, j;
-
-		/*
-		 * Only inject past the first subpage so *nr_pages_backed is
-		 * always > 0 here, matching a genuine mid-compound -ENOMEM
-		 * and driving the caller's reactive split fallback instead
-		 * of an early, no-progress failure.
-		 */
-		if (IS_ENABLED(CONFIG_FAULT_INJECTION) && i &&
-		    ttm_backup_fault_inject_folio())
-			to_folio = ERR_PTR(-ENOMEM);
-		else
-			to_folio = shmem_read_folio_gfp(mapping, idx + i, alloc_gfp);
-		if (IS_ERR(to_folio)) {
-			int err = PTR_ERR(to_folio);
-
-			if (err == -ENOMEM && *nr_pages_backed)
-				return ttm_backup_shmem_idx_to_handle(idx);
-
-			if (*nr_pages_backed) {
-				shmem_truncate_range(file_inode(backup),
-						     (loff_t)idx << PAGE_SHIFT,
-						     ((loff_t)(idx + i) << PAGE_SHIFT) - 1);
-				/*
-				 * The pages just truncated are no longer
-				 * backed up; don't let the caller mistake
-				 * them for valid handles.
-				 */
-				*nr_pages_backed = 0;
-			}
-			return err;
-		}
-
-		to_nr = min_t(int, nr_pages - i,
-			      folio_next_index(to_folio) - (idx + i));
-
-		folio_mark_accessed(to_folio);
-		folio_lock(to_folio);
-		folio_mark_dirty(to_folio);
-
-		for (j = 0; j < to_nr; j++)
-			copy_highpage(folio_file_page(to_folio, idx + i + j),
-				      folio_page(folio, i + j));
-
-		if (writeback && !folio_mapped(to_folio) &&
-		    folio_clear_dirty_for_io(to_folio)) {
-			folio_set_reclaim(to_folio);
-			ret = shmem_writeout(to_folio, NULL, NULL);
-			if (!folio_test_writeback(to_folio))
-				folio_clear_reclaim(to_folio);
-			if (ret == AOP_WRITEPAGE_ACTIVATE)
-				folio_unlock(to_folio);
-		} else {
-			folio_unlock(to_folio);
-		}
-
-		folio_put(to_folio);
-		i += to_nr;
-		*nr_pages_backed = i;
-	}
-
-	return ttm_backup_shmem_idx_to_handle(idx);
+	unsigned int backup_order = order;
+	int err;
+
+	/*
+	 * Fault injection: back up only the first half of the folio to
+	 * simulate a mid-compound OOM. The caller sees *nr_pages_backed
+	 * < (1 << order) on success and drives its reactive-split path
+	 * exactly as it would on a real short return. order == 0 cannot
+	 * be shrunk further, so injection is skipped in that case.
+	 */
+	if (IS_ENABLED(CONFIG_FAULT_INJECTION) && order &&
+	    ttm_backup_fault_inject_folio())
+		backup_order = order - 1;
+
+	err = shmem_backup_folio(folio, backup, idx, alloc_gfp, backup_order,
+				 nr_pages_backed, writeback);
+
+	if (!err || (err == -ENOMEM && *nr_pages_backed))
+		return ttm_backup_shmem_idx_to_handle(idx);
+
+	return err;
 }
 
 /**
-- 
2.34.1


