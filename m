Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3CC7C561E6
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 19:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48A8E6B0092; Wed,  5 Aug 2026 15:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 301F56B0093; Wed,  5 Aug 2026 15:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1336B0095; Wed,  5 Aug 2026 15:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1B816B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:35:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 454E31405A5
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:35:47 +0000 (UTC)
X-FDA: 85068220734.05.B611113
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9EB6640002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:35:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WxIEp9Uy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785958545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1O0K5pHo6AZrsBj+U9+dp6Jxpur4wphPj0/CPlkhP8Y=;
	b=iEib8fJfj61h1ZRcZhQ8EXbEkdi673tljAABGAnAuxNtE1yziL0Fv4WCb3vq4iB6SjxUkz
	UP4aAtmf7W0IqxF6OSbG1+Y8+9Ibl+txi3XUMrYYBEv6MsIFYgZKihYdHdh3jnJUgBdbr+
	++jlT8NMT7jFmsYgch+6HY/mowwovjA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WxIEp9Uy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785958545;
	b=qsW39sDRspQkZO3RYGZcnt3M2mzEllYBoSO2DtobijkMyuhLg/TpXHjlrdpL1CEkxpDSbV
	smwiwIv+Sr/WYhlxqLHtm8JeDGXx/kPQvdi2v0+beUhbErh3A8BZPjHi6T9qvtVRVwcFeq
	de1mNAlARVPc5EwPdbYeWmUC2VrTqYg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785958544; x=1817494544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0YG7iyYcbF3G1EFKh9ioNjadG3W1OhFnqKUemvuHbQY=;
  b=WxIEp9UyybAK5OHwZ+yljQuyX5fEFKaSMzyYwoI5T6znV+qmzQpf2jGY
   i2VhcB8pkTfzPuIPoMrrJJXxcIypOoEl7y9EfAEedtJRaUgY74l6ilMHh
   YXdQ9dRf/HwSIYFUCHRnkDuSAxdUQOAaQ2raNzpc5J+xWXi3m+c3ohNTl
   tDGsw/iOy2WAwmYksEyjb1ZV4o0Gb1OiNuPUhb3eY3l4e/2E7QT65s0xn
   pSrDcFJCcllsagTiht5oyaVJvfZ/sx/cPitcnNazQVMUkGGNHRvk85xaL
   gSlEI/97B1WMnBRITsK31UgYAmz/digX6+lQtn4E50HYkPsSlzYlH0v+I
   Q==;
X-CSE-ConnectionGUID: HscpDm6LQAiEP/3KQYAx1Q==
X-CSE-MsgGUID: ehcZWaZmQRGp3INBfwSzeg==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="109332917"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="109332917"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 12:35:42 -0700
X-CSE-ConnectionGUID: +IlgXOyXTU+bAoeSzcnfsg==
X-CSE-MsgGUID: aH+F8fM8RHmiW/7pNd/qeA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="285263519"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 12:35:42 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sashiko <sashiko-bot@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/5] mm/migrate_device: Clear MIGRATE_PFN_MIGRATE on all sub-folios of a split THP
Date: Wed,  5 Aug 2026 12:35:32 -0700
Message-Id: <20260805193536.3756457-2-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260805193536.3756457-1-matthew.brost@intel.com>
References: <20260805193536.3756457-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9EB6640002
X-Stat-Signature: 5ikubtndq8j9n5szziunwsfzsogeknt5
X-Rspam-User: 
X-HE-Tag: 1785958544-975437
X-HE-Meta: U2FsdGVkX187KLkH21ALZwofXzBG/BsmOuZvwYaoABYdHqrHh5FvIbYGSQygGv/98yGlbvbSYxepPICyueDW87qDvxxfnpgaUy9vw/1AiwsAJtSzSWbrBHUpU8I3umYzlpmE/qfZKGfxb+SNlkPu8Unc15cNO9Fcu27DYToQCcf+z4i/dXxc7oPQ+JbHrttmF3gGIFA9xp3FN9eqqN7RnQiQMe8ucv4puVV/VkemEu5dhrMHTfoR4psLQZksgovBr5uOxlziIi0/MtBLhv6P/ZRs4799MtH3UMl0i71+OAByDKuXLhDwwjnE9wzAIwBTSrnIi8dyNV2XrX9Dx+kIRX4YFJ9LHQdwekLSqh/dK9vvExTW5+Dx/+lTKVhumwuh89J+reSL4NrH3pvxltCxIYVBb0SVv540yifAP6FuDXxWbXR6f7acrVcQpNYoy8nQ/F/sNHcuNtn371mwILEwGnei8vKN+VdtTW8FivA04er/mxTkaZ376qIP7pjTNaLtgkkEiDMTI9L0cPSbqsKf38KCTVhHteb6B7mIHyqWGceqOnZDNcy4Xu64x/ZnrqGtzPF/9QpCT4ki3xruSz7QtoTIYZc9qRh4tF+PyX60GeJYhqTZB7fOxc7LD8xOWpcq/ikxIApV49xsdZIUwreTH81erbryiyUnY78EmnIDhDZ7R3zwRE0JVbYT6cTS78D55I8PMk74i1Ud3kx4xFbkFG60QdNUrNtkNTggNRsJtQFIS62jyMgUS+J1875ilMNhA5DODNapo7aJB11k1uWxih8B6VIv2oRW4bkt8clTUhgUI1UM8G5ypQcxl5Wppsu7Xu4e7UCRXZmGHT0JkMIbg1r4NYk/abInaNqPpzKY1X7je3VgQrIA4n+/M27cZAlIbGSzhn1oAxBoBbRMPTdMP1dT5P5ksAij4jEzMJ7gJVxoU8rJ7jxVHkYS0cO8BlFTksrALXNbfaUOBY5THCk
 x8Mi6Zt0
 3uj5d+H7o0aGuc+zoyQNDPZpSMlAclQiJYswfaomw4knFmMVZoHH1OnPRTb9OqBtkSJciVsmHGpt+oE1jyG9D4hhJi7Nf1+ukHK3i3jhivCK/wWN8qJZgP3VXwIHvjKAz3bwfra0rU3wgKhoseZD+jNz2GwcODXO9WilQ8sMBmbovhZvbA0ulyC/J6FgDjFOaST3bJhUuBQZqIAmdHviPXCL1MVvoe63diu7Cgl/Peg0utezNlqez85IghmoRypdHeSvVu9rTIk6xRZw8X8yi6gkTvEfNBnLJ2ATlZ//F4y+5CfA6mRhMjlPEjcRF4uNim47tFGpu5WqxEB3TEFqowTP1x9/XbeeXhARjC6lEzkS5KJiF91YoSecnCgr9yC82gxB/yLQ3JOafeAqCNQnQmPjwVg6gUeWx1w/hbdU6HyAt4Ne3zIKIe3kqi9WfdyDpw4rKYVIvNjR+W5YdZiHhdoPxseUuboUZ9b1cITylNnIL2eZTvAcpl77HxoKAIXNFPa1PfCSQIujSdhhHvSQ1xEgsQ8+48M4PKfxeuEEMf2xVGIWiU1N1j0O8LoA7z51D8JmRUPoWlLd4+sILYbRkry4SZyu1R3ZwCkSnMOuZMfEvN1ZZudPD6G/xuHklcpnCy9uMBXlYLu5OrvbYMGWXprxvbIiaE1G1sAM6WGaXGiK4K45L9vtxMQ569Mcw8jhVgvqH+AJD/ScIdNXNvvVwyBHhtfLUDkpSpO1oBODzM2JmQoL/eAcikItJxXyqbnlwg8KI+/isc0Sz2nHNMWMseeoJNUHodMGSpUKMJMKME+6/dQtadNLZngeVASSUpENNCqkF0r35QMAmkrCCaBGdU0x91g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

migrate_vma_split_unmapped_folio() propagates MIGRATE_PFN_MIGRATE from
the head entry to all HPAGE_PMD_NR entries of src_pfns[]. The two
bailouts below it in __migrate_device_pages() only cleared the head, and
the "next" label then advances by @nr, so the tails keep the flag and a
valid destination without ever going through folio_migrate_mapping().
migrate_vma_finalize() then maps unpopulated destination folios into
userspace.

Clear the flag across the whole @nr range at both bailouts.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 4265d67e405a ("mm/migrate_device: add THP splitting during migration")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Assisted-by: GitHub_Copilot:claude-opus-5
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 mm/migrate_device.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 908d2d4ec43a..d37a96cc6335 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1199,10 +1199,14 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 				 * device private or coherent memory.
 				 *
 				 * Try to get rid of swap cache if possible.
+				 *
+				 * @folio may have been split into @nr folios
+				 * above, so clear all of them.
 				 */
 				if (!folio_test_anon(folio) ||
 				    !folio_free_swap(folio)) {
-					src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+					for (j = 0; j < nr && i + j < npages; j++)
+						src_pfns[i+j] &= ~MIGRATE_PFN_MIGRATE;
 					goto next;
 				}
 			}
@@ -1210,7 +1214,8 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 			/*
 			 * Other types of ZONE_DEVICE page are not supported.
 			 */
-			src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
+			for (j = 0; j < nr && i + j < npages; j++)
+				src_pfns[i+j] &= ~MIGRATE_PFN_MIGRATE;
 			goto next;
 		}
 
-- 
2.34.1


