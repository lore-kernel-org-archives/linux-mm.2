Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C6EC4453A
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 04:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5D7D6B00D3; Wed, 22 Jul 2026 00:42:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C31016B00D4; Wed, 22 Jul 2026 00:42:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6FFD6B00D5; Wed, 22 Jul 2026 00:42:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 845956B00D3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:42:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 01DBF14035B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:42:30 +0000 (UTC)
X-FDA: 85015166502.20.C855414
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8A0C9C0002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:42:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ncx7cI8I;
	spf=pass (imf10.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784695349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ydF7Yo/8YaF4jhzJBegRn/mex1K70N31Epdks730HPM=;
	b=Apb34muC+WCdZ2gjpoVvrBP+mbFZrh/5xEnClmaxHxAj6ABYquBQApjlciNwHB9YOBoejt
	kidehdNPuloj51C3N95Uzwf0QpKhQEbR70DqRWfHhaNSgIU3cx+B+YqCD5/Nuov7Mm3kEe
	zfYorXc6vMNurSC/PeZLbhbP1K+4DYQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784695349;
	b=NpOSIbQ5YEU/Nzq5sGL2IrsWNtx6x6gF/wLeUSa8db90Tl9XR8EEa7OkSF1uyTPPZpwrMr
	7b+tMc0oS/yGNp1oNopYSas1Jn//nEEaJas/ZFvEaUw1+P7Iz1BWvMuAMua5pqFa5m4Yt0
	cXpdiy8ORi5aAqE/u4ZZzjQiME3GhGs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ncx7cI8I;
	spf=pass (imf10.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784695349; x=1816231349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DPPvDE2ZYkY75cjC/FOqIdz/rzKIfyUjxxUz+ht8NJo=;
  b=ncx7cI8IoZwbF7IjcL953w2GtzT+COqlTuxUY4pODzQ++U0BIgigjOvK
   d06fdKFMXBqYbdHGQZqoHOmkrZ8PNfdPojAsJaTWUh9Tf59gmxPtAbuGC
   ApHyrkC9aN74+ykMUk6SgeWsIHoSB2hhX4BxuAIKzpHDEp5vqphPhugtT
   4RLryDHdHY1T3JQDMC5NLtK1EBCRZ6lu2HJTPietssSs39Z9ZCg3qxC0L
   0lyPa9RbTIUFYAYw6xIx0/h8KYDyh4Qfq4DU5NLP7H+MongW1UJxiQwBd
   X0SgYZhg2WzjjmXkxoxAmfIXEaydnlLigR55024pUHfAP/woG+1R0eBJU
   Q==;
X-CSE-ConnectionGUID: uslM0A5GQq2eaZBU9fqWdw==
X-CSE-MsgGUID: Zy8Z+6HRQl6txFTbTRhoNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11853"; a="102865797"
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="102865797"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 21:42:27 -0700
X-CSE-ConnectionGUID: yeAK+zsQTJ6aZaftSkRXRQ==
X-CSE-MsgGUID: U6MJW0PsSS2/6S9Nm9dxBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,177,1779174000"; 
   d="scan'208";a="254063558"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2026 21:42:26 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Dave Airlie <airlied@redhat.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 2/3] drm/xe: select TRANSPARENT_HUGEPAGE
Date: Tue, 21 Jul 2026 21:42:19 -0700
Message-Id: <20260722044220.1110278-2-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260722044220.1110278-1-matthew.brost@intel.com>
References: <20260722044220.1110278-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8A0C9C0002
X-Stat-Signature: n98tyej38dmdendx9hyzs9uikpkk6gwe
X-Rspam-User: 
X-HE-Tag: 1784695348-929678
X-HE-Meta: U2FsdGVkX19BD35URztxApyFzb5p8Kv+JNqgD0w3ytStkLE0Xq03bzup/+rmziGW7UhEND8p06F2BreDMJJjTrMBWDIJ7RCHQNZEsLux8hQWWJzsI0APO3d2kabbKNXJfBDGziQTj+7/Id/P6ut8pMB89RQScd2uQ+v7ki5930mwoxhwpUeIen8k+0PNRxx2du6NpoD2RH01/QIi5k8lqH4iZ6YT2xCcIhSxNi8Eclc4I/GaoL4pOAz0tQ+ib13MqG+2XqWdAsApg1IYiF/3sjLcxsgcvF//nnwkd6+QojBFpDmv/uN+BHMg5M5zE5fNznCDytzGo/UnqjbGYwDATAzmurw7EsI3KEqxFi9LN4/CjHY8Wq3L9gg0uzRJfvaMQ5GHtWD7lm4ufXVbQ04hqcbd2ygL8/Su3sxmY7I1fugEJp8Jc0SI6pFYl01mebfwcMo9p8U53dFpDsog63o6fAimxyttBEi1nDlFYs/9FMPFyKrkIjreVdHldVyqf3l/dN0j+B6drfsTXWmmAuCQwdSJkHTbUxSsVMkzDgOyxoBOs8OwsS1gqvPScdnlxBN/mPybf6ktN7tG9PXzbDajwIeNXDKQpFfnH2OT/ttb+Ax3PWoilppblHluKtG5O6tZSz91qL6pOh0eO7OPe/GkR/Rz5aXa/1PT8iA3W5WA4oxop4XsTN03OSOifd6hq5wjO3twFyCRigIGBtBW8zPbFhjxBKpwLPXQfHnbJFuT0+R/PtvDypHMEMyxacv00NBr2b24XaVlP+D+f0uVJ7C6qctSNgFfmyxHvh96410P0i8avZMIhyh7TM8YcjtcVwkAbFTOtMOuDqWJv7OJAsG99/ypo4eRnPKiCT7J8SW9elWDAjeaCFVYh4FOKMVjOvnodQ6RztwDR5dKYgNMi3Rzoa2LHatQTgjVtad2UJIJ2q9E3B3426sDE/4BE2Om3lgGCApcKzYy4IdquMndrSR
 tsr2RbyU
 4OfVM8F1ACoaedyKz9d+jmDBnG5XmQyrQREqBw7H81kik6RVmGjNxC6fvXFUo3LjAfhmwzdtcgmvmzpfpgEwPzT4i/OyaXRT3QR6WHnlTD5ERkOljF/GhtL28dkeTaCAmaSC7i0HMrZcfzRty4Bw0biO0zGAL3mr+KASSyzXXd/ZxWyNkMwK7cmGxou6G9QQT6ATk3n4VVK4jFFGb9MqAE0v1AC5jxQ5BOfosjfiBcnx3JVjuIk6FFqNpH7tLRX9haNiDpb7gnry18ZnSjHinKcqCkAo5aq1qU56iXR1054hzC3SY80JDdJqi3FteHk04t/RxjXisz8TUBJGfTRdrEPfo00qrSBq4MNdDKHl7nM3idl1nkt5zXybRiJEDQczznUqsnKwCJZ/TCJCQHYnFV4EAEsjux6y9QqV8E+NmyIqJVHNMJ1dydrQjP7qU2JFqVqOd7CGpBR9rjBnhNHC121BCSqXlZR5EpzhWpTUOGGXeFpksxZH+0lBZ/WpBSVy7/CQ1lK+EolIJASqBoD/mzJqWJuJYEZXmbPzhDZdXjUiphXKU41jxpjyv7tw3Ia16gE4EC4UMp73yfTFNrSgaJFbDWsmZvSfWie3XJi3JcuM+1qD8P2GjPETHlpwvbkGafySBUOjn0VBnW9Cv55gzdcEaDBspIGldaTQEWJeRG5FzqO7MKiFqVb8wDZJZFVDQm712w3n8k3P1wCX8241pheK3Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Xe is currently the only TTM driver that drives the TTM shrinker, and
hence the only user of TTM's incremental swap path. That path splits the
pool's higher-order compound folios one page at a time via
folio_split_driver_managed() so individual pages can be backed up to
shmem and freed under memory pressure.

folio_split_driver_managed() is part of the transparent hugepage split
machinery in mm/huge_memory.c, which is only built when
CONFIG_TRANSPARENT_HUGEPAGE is enabled. Select it from DRM_XE so the
split primitive is always available for the driver that needs it, rather
than forcing it on every TTM user.

Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Assisted-by: GitHub-Copilot:claude-opus-4.8
---
 drivers/gpu/drm/xe/Kconfig | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/xe/Kconfig b/drivers/gpu/drm/xe/Kconfig
index 4d7dcaff2b91..88a4f3d09d5f 100644
--- a/drivers/gpu/drm/xe/Kconfig
+++ b/drivers/gpu/drm/xe/Kconfig
@@ -11,6 +11,12 @@ config DRM_XE
 	# the shmem_readpage() which depends upon tmpfs
 	select SHMEM
 	select TMPFS
+	# Xe is the only TTM driver that exercises the TTM shrinker's
+	# incremental swap path, which splits the pool's compound folios one
+	# page at a time via folio_split_driver_managed(). That helper lives
+	# in the THP split machinery, so pull it in here rather than for all
+	# TTM users.
+	select TRANSPARENT_HUGEPAGE
 	select DRM_BUDDY
 	select DRM_CLIENT_SELECTION
 	select DRM_KMS_HELPER
-- 
2.34.1


