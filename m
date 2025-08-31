Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B3E3CA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 10:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 952CA8E0003; Sun, 31 Aug 2025 06:27:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 929CE8E0001; Sun, 31 Aug 2025 06:27:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866688E0003; Sun, 31 Aug 2025 06:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 740F08E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 06:27:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1482C1195E0
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 10:27:50 +0000 (UTC)
X-FDA: 83836676700.05.D30CF26
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf22.hostedemail.com (Postfix) with ESMTP id C27E5C0002
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 10:27:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LLIo70Qm;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756636068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wlTrT8N/8QrvwfonXm3IyAKAHRQ9/e6rOitYE9NgwIo=;
	b=oVVxfo+YS2s8GhXQ48sQ01Vr+6/DOg3E9QxMSMQ0sf/CYflfcwdLZNdx9l+ZwycoaLOW7O
	ltpXt+TiwMHvT8nHeQVVRtKbAlz+J4iM8UDQDzD9S6zw2bO5ZdemaLNOX/bJvPttSjZ4nZ
	GKcpn0z04gE2mmSOcyWLIauiGz8QYKE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756636068; a=rsa-sha256;
	cv=none;
	b=DsyLBlV+voJd3SXF5RAgeo/s/mpmknyzwsu5+vFeRHTVEVFkf9OkHvB55m2GYwjwY5Ifki
	O6Da4P9VniRJsjDyY0onOmScB7y1uXvjFlB1w3BKz510mbE9/J+RMAuBC5HLwYVpRXRTB7
	coe+eObZms+aL2yby/ejc2Mzcl3vIvA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LLIo70Qm;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756636068; x=1788172068;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=G3VUUUy+Z0eEDLbmnC2uWZmW+NftXH+FJS/0FINvCZo=;
  b=LLIo70QmXegSzRhkUpCfBRZQ04QowtoWVpFmNR4pj2nldILLumtzijB+
   H1vQECuxBSLnRgoaPXCHXuJNowxpZk28qvJzmQEHwCJck5h17pbLPU3sw
   WjnWdtyLNcSnifoP1KvKHKCWMkAXvsGv9ZN2TrE6zGtzGiEhsO1xMXaMO
   fd41TaRLIJpmZaGGikhgA3NcHQIs6J40n/OLPtjGioh19599cn6Qqnz/r
   HOGq7sVusGrlQEwzw531+M38Wg4Gij6BZqR+gtI/XiNJsHAZI5LEPMbc5
   r+dEjRLyyiX0lB9V1QP9X7sk6+Jm8Lp+Myg06nr5WZ/+0stYZ1R4n+JDf
   w==;
X-CSE-ConnectionGUID: YSXab1uuTzmisHgSwdeBmA==
X-CSE-MsgGUID: TTT9XSOKQVylt8LdiANEZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="46429010"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="46429010"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 03:27:46 -0700
X-CSE-ConnectionGUID: XAOUGNalRseEqI7XAhA2rA==
X-CSE-MsgGUID: t8fpDd0QR+6w+3bfnX9N/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="169989735"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 31 Aug 2025 03:27:42 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1usfH3-000W4p-1J;
	Sun, 31 Aug 2025 10:27:07 +0000
Date: Sun, 31 Aug 2025 18:26:08 +0800
From: kernel test robot <lkp@intel.com>
To: "Roy, Patrick" <roypat@amazon.co.uk>,
	"david@redhat.com" <david@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>
Cc: oe-kbuild-all@lists.linux.dev, "Roy, Patrick" <roypat@amazon.co.uk>,
	"tabba@google.com" <tabba@google.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"will@kernel.org" <will@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"Thomson, Jack" <jackabt@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>
Subject: Re: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
Message-ID: <202508311805.yfcdeaFC-lkp@intel.com>
References: <20250828093902.2719-4-roypat@amazon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828093902.2719-4-roypat@amazon.co.uk>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C27E5C0002
X-Stat-Signature: z8w3m378zrnko8uoqt6urhfs76uwgzfb
X-HE-Tag: 1756636067-168812
X-HE-Meta: U2FsdGVkX1/oxT/D4xD2ycbIdQsSBFu14kj2SfXjTTuIPTUUIgrZDCFKE5kM+DRF9wCLGKpcLW9fjCnH7Ke1+FiJ7hqOSUpI0EsputUnmqFEbZ98u4ITKByRKoZpNKaUG2BbuXVnZNRI60iCOz3WJVx418FgR813mUQZ5yo0W9iJm33K4V67tLIkCOr/x2NoSMC73Hx9a6WzfHKfape2VKeplxvTtDMCgazdAOlQQkr8NPMwxVoPbGWGMlHeGk/cTKLXqXqbjW90H5HFHKJw+oNZzMP67zhK1vjk5w2x3Vf4FUHcyERXe3Ws2y7nPGAkHwjiEq4D6yTxF56uVAGdfqnIMc1QhCXxnupMaDKzn3SKZJvZMvy0SI5BZXZCBSmPLYQJjzmUptoPneWiwa04yYo487NH78ZzJ5rOt560Rf1+W9dlalxzdkK6gb+n0NcE1Z1ilKpaD1xDzds7KIa6hl+AXCd18WLqb2yFyG8Wts8xBb6EGihRXgWPL2e1DQk/yma16EyfnFobwOzygyipOYl7ZWP8xAxxg84R1lf0VNA2tIwHY0k8n16JwLCnDpq3np238yrcKgmNAiTDAgwepvtOf/shKpxSWvs8EM0qQ9y62jHtFMp/E8EV9Uyksj7JFD3up2zN9HvSXugU2VL0TSu8am5hwEZujM31OhU8Io+Pponc5Iez8I54o75gE3pDyn9FlE0Adr2QAoPrbafWn+7AIZSn108f2TpaUiLL0tRXG5gc3WzJawLnBTnGkIaK+W4beh3m709Z7KKVU6InRzrVcpNdMldOI7ejlYqu26ZmwgR75IaEfd9M4xO78ZHtRm6UsxxeJh8TvyYfCJHQ9HV0zTuqJzAbJ+dcP+kddvUuIQU6caMvAT5TVPlE1Tw5+wGo1KETQNmhZIydqq2cAAwtz/ihFJD72NNvtOruE4A6HOmyNqlsB4sCm+Qg5TddUzlUQ2KnWSRQC6WGrl5
 Lildwnlh
 O79f3OENOJF0KU/0A5QgXOEj3HMCzI6zW7abHJ4m24/ewx2IpIRI89MW0gipIqX8y+yYbxIIjykRal7aME+OpE7p6zK5qCfN9T0ANBcZ6ToYnXmRg9OgUPqUE/jpqblBmAF+dJYqHlN/BB/BraBhDHFlSSYs7FOrxgL8VvivREkBLvLEubY0sIvQwPV078iI/vbsaOIRdadCM/M9jleFegp0//UKMdvszlVSptlxMnDNtU4zazH+VhXvjP8dCM4hNbkUSlpgcVCWHcxF/C23qp0rfnVh/QPrxv4NG3cKL+boyPE6NKNYxcJp2xMtdjoLEyLaPyPUqf2QCY+mBphS0awQcmeZGByMg4rd2cIxKdsUdFEgCyzuVGb5/a8GFgV1BZq1i/zVDxH6kzqiHMeH2/axv/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Patrick,

kernel test robot noticed the following build warnings:

[auto build test WARNING on a6ad54137af92535cfe32e19e5f3bc1bb7dbd383]

url:    https://github.com/intel-lab-lkp/linux/commits/Roy-Patrick/filemap-Pass-address_space-mapping-to-free_folio/20250828-174202
base:   a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
patch link:    https://lore.kernel.org/r/20250828093902.2719-4-roypat%40amazon.co.uk
patch subject: [PATCH v5 03/12] mm: introduce AS_NO_DIRECT_MAP
config: loongarch-randconfig-r133-20250831 (https://download.01.org/0day-ci/archive/20250831/202508311805.yfcdeaFC-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.3.0
reproduce: (https://download.01.org/0day-ci/archive/20250831/202508311805.yfcdeaFC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508311805.yfcdeaFC-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> mm/secretmem.c:155:39: sparse: sparse: symbol 'secretmem_aops' was not declared. Should it be static?

vim +/secretmem_aops +155 mm/secretmem.c

1507f51255c9ff Mike Rapoport           2021-07-07  154  
1507f51255c9ff Mike Rapoport           2021-07-07 @155  const struct address_space_operations secretmem_aops = {
46de8b979492e1 Matthew Wilcox (Oracle  2022-02-09  156) 	.dirty_folio	= noop_dirty_folio,
6612ed24a24273 Matthew Wilcox (Oracle  2022-05-02  157) 	.free_folio	= secretmem_free_folio,
5409548df3876a Matthew Wilcox (Oracle  2022-06-06  158) 	.migrate_folio	= secretmem_migrate_folio,
1507f51255c9ff Mike Rapoport           2021-07-07  159  };
1507f51255c9ff Mike Rapoport           2021-07-07  160  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

