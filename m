Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 198D3D3B7F2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 14:28:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB1FE6B0005; Mon,  8 Dec 2025 09:28:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63046B0007; Mon,  8 Dec 2025 09:28:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C778B6B0008; Mon,  8 Dec 2025 09:28:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5F926B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:28:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18B74160154
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:28:09 +0000 (UTC)
X-FDA: 84196533498.01.18C7F63
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8B7A018000F
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:28:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QtFUnilP;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765204087; a=rsa-sha256;
	cv=none;
	b=k+9rsr+9WFSAvEjggVDRbxIZ6mZ2XuCNRPvx+cBelRn2TWw9O2mcU21oatC+qYBLwL/dlo
	JMeh6V9+TaAX7v6lBm/R9mj9bFMiFcc8Y5SEeqwb5KA/d3vd5xhGnH8KqrEUN1r4KZOnri
	Pq+4JBouToHJu3k6N9HPBXf9JiYiQr0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QtFUnilP;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=tianyou.li@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765204087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GUlK2idGprdGFRUC6azlopRwrHmRvCbA1hWps33Akb8=;
	b=Z9XI5HL3uM0gO74StR1qWgkR1MQojMYDQOn43Z8+GqpSx+rfNhZWltt8wIAE+jUl5vVMVQ
	ap93Roxl5+DDOynhv1O8n8ZiT4CfxuNxcdg8v4V2a7oBIeWDQvR2C9V4WQhdbcUyV/y7at
	e2PkvAuFU6WQ4idKpp5Al70h8wxF11s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765204086; x=1796740086;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YhkXeDpojjQAahTJ45sd2BTdvUz48R4h8dyVLpF3miI=;
  b=QtFUnilPMV2VTUuezYjNEXpBdk0N6Ve1qWuJ0TNNfKorlR4h98Q4FWTi
   Vd4aESLTiNbmc53mn6QiLk5T92u0pDJ3zhQ9goBwUjAJ6btHSjWLmXXlr
   IIEi907k0S4yvGtBU5wWlqb9Y1o6ze0cXTpBn0dsNmzIPldbH7blV1wXl
   H70XrcybnH8eTVMrK5w+eVVMY6zhudvVEnhTC6sWJ5RXOP1WuXe+C1UgN
   ULhbXNDe+wvXoJQlRrXtXkeVjfLaf4mbtmivrQNOr35dtIwFsuaVvAONv
   JsbGVJufm8kMKzywhMc1xX3DR04EcZ8QCSptODnXvCLNShHq35/ny/VWi
   g==;
X-CSE-ConnectionGUID: lvmm+18BScma45Ve8yPDzQ==
X-CSE-MsgGUID: x4UfacOcTVWusxaIUJruBg==
X-IronPort-AV: E=McAfee;i="6800,10657,11636"; a="67181507"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="67181507"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 06:28:04 -0800
X-CSE-ConnectionGUID: cfm4mnZZS2yc82iiiObh/w==
X-CSE-MsgGUID: JbJY0ggMQoWerjpst00HaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="233317783"
Received: from linux-pnp-server-27.sh.intel.com ([10.239.147.41])
  by orviesa001.jf.intel.com with ESMTP; 08 Dec 2025 06:28:00 -0800
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
Subject: [PATCH v5 0/2] Optimize zone->contiguous update and issue fix
Date: Mon,  8 Dec 2025 23:25:42 +0800
Message-ID: <20251208152544.1150732-1-tianyou.li@intel.com>
X-Mailer: git-send-email 2.47.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8B7A018000F
X-Stat-Signature: jmu6aipkgbkudk6brjgqjw87dnttmiwk
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765204086-826926
X-HE-Meta: U2FsdGVkX1/0NUEiOHPNDQSRLabU1tb8S7CEbII4n/pyGhiVkiCRNJy+Z8yxECt4t+0wLMCxOZzqSKYVtvItBtfy3jAWMBGKbAu7FV6Vb8BB+JOaYiHaj1Zl3kjFubVLPCvk8wuk/VDwosmzv5FvMNWohEZcfuzpCA+/dQinDPwQL8SXGgmc97mtVZSrPlml+xbj+WUYfxq/ZORxuiIdtSXTx85steb/ijeM4FIT0FTGIwppdLbUxaCrs4y9Z9fMKqWz79FasrPOp7Uoifo6RyBq69Cu/JmTkWPayO+yHy3B0FppS64Ir3daUt/8li2j9DNwsU8tvkG29dUfkPz1AHbAOCf4ZHXY4hFqOeDe186R8VI8glNUls/NiIOHx1jwBJtwHlS+CT0H7rSJIjcbU+B4ltvyzJ3/c+1J/J3wFGdxH1kWiuT+rgOFuBrcbV0+atF82mkajIBMpEUNnwtFW2gZi8/U5me3bSvZthf5Dm0A5J3Q4f/+gJDAU+CRR/UtTK76vruSMdJ5eYIEH/gCIedmOPczuL/9Idxn29rajopNYPa1W8Yi32SzzviqfzPP+WJljYM23k6zeq/84qs/7/MA73zBnzCX39du2Q/DGZBsBTHLc7WWFpgM91x7qdDoFylRulxKkWCUAVsBuMC+DSNGtn3jsSffuZT3xQJtTMwdRf3y441iqhJ1D6rcTEQi0SBqkKqGgMjWQLgK4UPaQw+Jx69HAEQAGv37GghZ8kTgcDuCxrna+MMzChELUQK1sy7rSKyJYMDH7Mxq6xHyKQotweSV4Fte9d6VDtZ1wpm/Z0S0/qlIOjqpqltMDSZ2rdVqRAD7OS83r7wdg/bNmx5Xm6U8W6Beyc3V++FWYd2AhdjP0glNHIHhku8csjz3A4vdOFageAp86zcLZyK+edo5vlb/8Z8tH1uBSOpcsbqjc4stHadq2/Vc9Nc2XUqBCRpfKkYl59OL+3bCohu
 y3IkQJVb
 dogybsmr0eHoxjiD29oYYSevXuONqT+yYWR/koN5YoIF8eK8GNmBAXBdOLNZrMFja/baURBcTbJlnWcQur8UQ2A3mGV3vTUpzz6hBos1S892iykJIMd7GEUmXBr+MqRWqkCH6GXUl5m9uPY0C2zfHw7djCFbBJF71uzPv7rfGb1uhkwhbcNmzdWy2N2Adw1O5ZIGa39a3dMBKvk4MPa5j8HQeKGTq7dbcNZdG
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

 mm/internal.h       |  8 +++++-
 mm/memory_hotplug.c | 70 +++++++++++++++++++++++++++++++++++++++++++--
 mm/mm_init.c        | 13 +++++++--
 3 files changed, 85 insertions(+), 6 deletions(-)

-- 
2.47.1


