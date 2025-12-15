Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A426D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 12:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B256F6B000E; Mon, 15 Dec 2025 07:07:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD456B0011; Mon, 15 Dec 2025 07:07:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13FD6B0012; Mon, 15 Dec 2025 07:07:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF126B000E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:07:21 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2740A1DFA67
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:07:21 +0000 (UTC)
X-FDA: 84221580282.28.523C8B9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf30.hostedemail.com (Postfix) with ESMTP id 759A280014
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 12:07:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eNgMKZQR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765800439; a=rsa-sha256;
	cv=none;
	b=Hc4SYkws3mdTK1MfuJpGiyWLLsBBPeqOm8i926bRssX5ShIynrg4aRSTt6REhCCz1rgpDI
	uN6MlnUqWXfQMW4Yxpil2SoYP1whYUkyEu/Fzr6ICXTW0v04D/R1DQOFESHXjFSL9rEu32
	qGp9PHIzhG5vvBKiYpAfSuHRJkwIrHU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eNgMKZQR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765800439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aoTp17FSNEnrp/0/Ki2P/V4EfSoLgaVCp7uBs73ZRtI=;
	b=KJUHeUjv8iS8af58lU3iEc0RaSSHS4cpNoekYQDKS4sTC/PEwt6vjkWgnrKNY409m8EIdj
	SZ1IyoFvhbz6BZ27vDFAiG6XktH33VRMR1gnOWB2LFAofUW6Db4Ftob/ptIY+ShYE3Rn0w
	Y5VRxWcyHsTXnVYm0qoow2J3JDtkOIk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765800439; x=1797336439;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VZbaSHeMrFD10tCnogVmCMF1KNI1nTBo4rCtGSYN72M=;
  b=eNgMKZQRmiy1YPzer7VyNjYMRhj6PmUgvdynYff7obXW5UditgogFZkJ
   bhhP+mmanFLHICT7ZX27wIaN+pL2O6tCzKKYSfhDAJVEN6QPOyPp3zEQu
   2kgQ0gB5gyfyYOv9Cfqs/hpKqso0GJaDeGebgY+tZ4P9iIrdggriaEVex
   FanBRCrip9aVcMf7Y7+dyH5zqtVHJbzUqJN0jruoR4OM7/oJRWgApmN+q
   +LMHsGVJ+Fq0JC+MEvsaRPZq3v9gt8KvRwxn9vH0uwCe8wc5oublRayAd
   yfWtlXedW30/ykWpqQ7zGk3zMTDI+pX1CvQxJQbdz9tL5S9GDxMmCcYit
   g==;
X-CSE-ConnectionGUID: eEFdoOV3TzyLR3UXZm0zRw==
X-CSE-MsgGUID: NyLaBuSMRAmibTnmQDydNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11642"; a="79154737"
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="79154737"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2025 04:07:18 -0800
X-CSE-ConnectionGUID: xRGi983IS2e1MpYlMRTCtg==
X-CSE-MsgGUID: cuyf0ADfQ/uuWvEA7J0WZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,150,1763452800"; 
   d="scan'208";a="228357211"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa002.jf.intel.com with ESMTP; 15 Dec 2025 04:07:14 -0800
From: Tianyou Li <tianyou.li@intel.com>
To: David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH v6 0/2] Optimize zone->contiguous update and issue fix
Date: Mon, 15 Dec 2025 21:04:35 +0800
Message-ID: <20251215130437.3914342-1-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 759A280014
X-Stat-Signature: u1dnd1ff3ayrxgh6e6ap38f6rouw33cq
X-Rspam-User: 
X-HE-Tag: 1765800438-465889
X-HE-Meta: U2FsdGVkX185fcb71Z2knVUeqbk68YsEyB+ka7tlL3yxAh8Oi01cO1bPDm08x6x+e7n8/LJbnCyKzUtrmbxTxcrO06uAS5TqzgD6zQ5eGsteENHJg2KfEOSGXpeszO2RhayU6OaH4Ysx/NUWEIGv/5tzZt/dbe2/mjGRsP9MqigcTkCo0A5fzsKwkY88seaTYmDBUM9n35IWXIV87ivR0HZwYBCAqUJM2215Q30dz7LFIOo0E1QTlkeQI0uJM9jK+yaJMmCNZkQNbPVeRSZuJPSWwu7ezkgNoTf/A5Un56LGe9bwjLTGozmIRuYOz07Zpp8GUTOFbbQZG0U2YaBZFIZc7ChKxr6kGXQmH9VrDdjm0tPBkvywHtqMW6WG4KupSFJ9NA2FCxAijho33Xay82Wnkl2n26qwBHBzKWNhCokxif31pDNQ6cO2vmra91vQ40lRsTkfZcHgsTDFSjwuNVtBviS+ILaGHr1HnpoAydvGULdW9PAzHvCK7iHm5yC6DWzv3q/S9GteG1QZIRFdIrM3jRHorK80LsfiCnOdDlJCQlVGX/S/QTnUUxFfz+d/blt3c2CAilnYK8Nyv6pxzeo0McMHz724mcaOBo/GDoIpGWs+YUi5ptD6vRSC+N15+oxtDA7TN7MwiryiXCJr9ny2tyl4gQVB+Zmc8LTiEuZhZXfrcswmNgOsSMUzDrQv5s2SfSOQqY7riDJ41MEnoHRFp27vVXad3hgAfis3jI4bW1pCerzh9XQHcnyevAfTmEVVhKV2b43dX3jGTD7xJ879O6sC+siwqS3qgl1Lr45Omrhz9UPvLSy+fDB0/l0Zl6xdqEkjjqxOBc4Mm9LcrEqujX5stLJ2Y1BKdqZbbwAy447ijd4OXnkrUU9Ij0eVEL1FFRDG04N4JMwb5cIN/CX5fVMN6T/FEVRjwOE0vvYmieJZXj4Eu8USdADffM9POrVhPo7+aYahqsKTTkP
 I5yvHKIf
 900X2mXi6M3+NCjR8wGNjjAWg3kgI06NqF8M+Zch+XIGPSFrqwMz+WLrlmAAODemBrjC/SBLAMmu5A8sJ5u2dqv3bemyXsCH7A8rdJltLDj3LVi6PgD5ayyNxvtJtbJSW9XWW5uqLNN1eGaLDqmr5Lf4wxtdxc3yz89TOPX9HMGCNkMP1nGG+xLLYepsjZSiVbbV9MasFMVHEQ5BAl+e5V88qJk3xiD/YzotD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series contains 2 patches, the first one add a fast path to check
the zone->contiguous, the second one fix an issue when check the
zone->contiguous at the slow path during zone grows. The issue fixed
by the second patch can be found in the original code path without the
first patch.

Tianyou Li (1):
  mm/memory hotplug/unplug: Optimize zone->contiguous update when
    changes pfn range

Yuan Liu (1):
  mm/memory hotplug: fix zone->contiguous always false when hotplug


Changes History
===============
v2 changes:
   Add check_zone_contiguous_fast function to check zone contiguity for
   new  memory PFN ranges.

v3 changes:
   Add zone contiguity check for empty zones.

v4 changes:
   1. Improve coding style.
   2. Add fast path for zone contiguity check in memory unplugged cases,
      and update test results.
   3. Refactor set_zone_contiguous: the new set_zone_contiguous updates
      zone contiguity based on the fast path results.

v5 changes:
   1. Improve coding style.
   2. Fix a issue in which zone->contiguous was always false when adding
      new memory, leveraging the fast path optimization.

v6 changes:
   1. Improve coding style.
   2. Add comments.


 mm/internal.h       |  8 ++++-
 mm/memory_hotplug.c | 75 +++++++++++++++++++++++++++++++++++++++++++--
 mm/mm_init.c        | 12 ++++++--
 3 files changed, 89 insertions(+), 6 deletions(-)

-- 
2.47.1


