Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2156F8FA71
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 12:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D203F6B0088; Tue, 21 Apr 2026 08:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCFE96B0089; Tue, 21 Apr 2026 08:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B986A6B008A; Tue, 21 Apr 2026 08:55:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A80556B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:55:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CDDE1B947A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:55:12 +0000 (UTC)
X-FDA: 84682558464.22.E8891FD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9D3131C0002
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:55:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LyRz57Qf;
	spf=pass (imf21.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776776110; a=rsa-sha256;
	cv=none;
	b=TRG7tGYHOwHYWlVO7nsDV+K1EZ+bTEHSJ26RdB7TbJ3pZFrGpXdeFY9tkQ94ajYtkVxFbX
	DYEope5zbahJby8qFHf9YrGuHBcnicORtxMo+3Co+hMn+9F4TsIhDYI7QMGGiYnx8lcHvD
	QNcCMHK+b1w88TgE3uoJ1dN+FcvHBK8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LyRz57Qf;
	spf=pass (imf21.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776776110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZxPwV3bJwgy0jf2JUYvIhkKuev1YFX4Tu7JlNW6rr2w=;
	b=o7LrpKrx5VcPxggvwMT5LO9isRJWMXyybCRfRxoAYR86a5+1aU6x4bl6T1Xxfz2VhclS85
	1w6tLDYpPMlhYCsRd5sOFSk7VLMhN0POY4+e6AZGRZcOZgAQut0VL2hzwYf8WTG1/p8uvE
	ogJt9BaqFTnWx+OQ5DS4/g9S5xZUlFI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776776110; x=1808312110;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bq05xU3PL+CyBthJrCtQ/r4CGnYbkCvNdm1pwmKOzK4=;
  b=LyRz57Qfg3XSy+6t5tzrOeqfwPjnKEgTnrHdZgd0fw7ZxH7siemRUVhi
   KLChDISQrcWkamYe5wOwxrYJIIY3vfkelsbIA/8RDOHsaK8suWcQwR/2S
   v4OFdcwXdCiJt+MDjOtN3aCL0L4WJl0QViz9HN4cCulbOmeg7cVj6Gi0u
   +X1DzNBbnl05fRE9tMJ/IVfmACTn65kHxs6mOP68WyQY4mNMKrwauwlb+
   y6Q3IMYIy/K+vjfVqf/wsVyd9k0RN85VgNEUW43xStGwltXBIxW/JjE5I
   DLMGMWK4kU5txS4ytBrIgMq96PgbzixGOhNW5+XPK/osSvw+9uHdqMN25
   A==;
X-CSE-ConnectionGUID: zoDa8anKS46X1ymr4YEQZA==
X-CSE-MsgGUID: z3b9EuXXQBu7llsxX9nP8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11762"; a="77721574"
X-IronPort-AV: E=Sophos;i="6.23,191,1770624000"; 
   d="scan'208";a="77721574"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2026 05:55:05 -0700
X-CSE-ConnectionGUID: CFmvs+vuREqcNYoLHvmCzg==
X-CSE-MsgGUID: uYv5bPufTKi7ctkH2oxBlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,191,1770624000"; 
   d="scan'208";a="229355498"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa008.fm.intel.com with ESMTP; 21 Apr 2026 05:55:01 -0700
From: Yuan Liu <yuan1.liu@intel.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>,
	Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>,
	Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] mm/memory hotplug/unplug: Optimize zone contiguous check when changing pfn range
Date: Tue, 21 Apr 2026 08:55:06 -0400
Message-ID: <20260421125508.2317429-1-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9D3131C0002
X-Stat-Signature: 9d5q6q4tpycsnkf4um4bdnni83agemjq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776776109-516505
X-HE-Meta: U2FsdGVkX19K7Es2Rd4x+j1Bge1aZ1Ej+Wbo8i7GAUuP3xHACcqwY9HhuNkVorGQF5Qv1Mq444neihAGXAuFtiVCd/5awTpCTFAjS+VBUEDBy2nCd2jYb6SaGhSXutonICSzY/i1FoNl3+/Jcf2ZBAaVjlidffY7QSXr33Wv/4LTGERhLm7shVa76Lz/HHpilwEixzszC4w9MNrcWxFl9nLPXZC5vi4LkFR2DdoSj8lOFXtgaRBvt6D6HJ7pAWRaqwj4RIaUEkb9tUP+5r0kZuD4WKEa8PNjGuYqbD/D7ofLI4jdeyUIjqPhOtb1RVeCJq+xzkSaS7kpu4U6Yme1gpXSmh8GLtlYIK0idF1gH9oJBPaR97UYBB/+uLDI56944yfVGRNAkIfwRRZ72/BFRbXny2VF4lzQ3kRAHHTlwn+t0o44SA8KLpiF1b5Z5f1heoJEc4LQ1mviYPXsxbTU3Hz9a+unpQqu2cHU/MLb6LeLcEyRdKs0Z9bZYG8qjCX5y9mSi4GWI3Zhfvjqy3Q+k6MK0yZeeh40P5zmyag0Ua8nyXkNcr/mkTAB15aA8NCXJgISkU3NtnPVQzV2GV8GeR2zLBB7jPPCUnaSmFq2dzUTsZ/2cSxAQ+P4Xvng/xwZIxYOi8IpVExxnAW7YZx1PNeUC7rb7Wa6PhaTN0l2v7fY1lDBhVTpM5qMpSyViEHDi1OMAbvlrL2RFgiUW3smZeqSshbpCUkFuLEhfmdMTS7QPOfIRAGXiffzD1kKkr3Kko6a5RL5ypoJQpnSnTUoZG31Hhy9FHN/DA0YZur1/lmiDd9ycwYP04Y2fM5zgS/k6iGRJJ4vkwQduRSSY/Ys15ms/iwoABcz3UpXKppAExLT1G1i4RCjgderpLX00zoJt9BJDSmqR/WwIyJq190HV9r+toSLDfYOvHWBmFN6KYqKCeAJtwNnllbBGylS8KktoAz1fY65if/UCJfRymu
 6EpA6RYK
 AJ7PBkaaSuvhdYyP9xGt7xtnZT28fiiNcwQPub8CWgkWzj0TOUShqQcZ89c6p98QKpOQF6DwNnq255+FoaquX4lVDBHJ/j7pQQm9VQSWFuFijVS2kvs31bcHzqQCn94YsvlZucKhN3q7G3KU8cJi8fuxsNu8xqw9DcdiZm7hs/0MGujUuh3Ycusy38aoOkiarpK+BNCZHkkoVUZUGRnGhiJ0suzj06f84qi3bm3BEpnhxAls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series cleans up the overlap memory map init check and
optimizes zone contiguous check when changing pfn range.

In addition to providing a significant improvement for VM hotplug
(see the second patch for reference), it brings benefits for CXL
hotplug as well. The link is as follows
https://lore.kernel.org/all/20260409023552.GA2807@AE/

v3 link:
    https://lore.kernel.org/all/20260408031615.1831922-1-yuan1.liu@intel.com/

v4 changes:
    Add a new patch for clean up overlap memory map init check

Yuan Liu (2):
  mm: move overlap memory map init check to memmap_init()
  mm/memory hotplug/unplug: Optimize zone contiguous check when changing
    pfn range

 Documentation/mm/physical_memory.rst | 13 +++++
 drivers/base/memory.c                |  6 ++
 include/linux/mmzone.h               | 47 ++++++++++++++++
 mm/internal.h                        |  8 +--
 mm/memory_hotplug.c                  | 12 +---
 mm/mm_init.c                         | 82 +++++++++++-----------------
 6 files changed, 100 insertions(+), 68 deletions(-)

-- 
2.47.3


