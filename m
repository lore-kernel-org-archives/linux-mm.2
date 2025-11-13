Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0847FCD8CA7
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 16:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CEFA8E000C; Thu, 13 Nov 2025 11:37:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480048E0002; Thu, 13 Nov 2025 11:37:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC3C8E000C; Thu, 13 Nov 2025 11:37:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9CD8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:37:43 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B63D45C3D7
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:37:42 +0000 (UTC)
X-FDA: 84106139964.27.4649A43
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf25.hostedemail.com (Postfix) with ESMTP id 06680A000E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:37:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ct6vVd7R;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763051860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NWPg9BguaMSndys7SpNC2ouAVsPIyce6s3kqntE/0Qk=;
	b=AiDU28BitqvyMGjrNvzUpF4d24fl4W5lLLARwBofVXHvZWT57gng/KZp5p+88ecM8paEM5
	Ri9o14XOHsbxS4NsfIX+TUaYqBooQOeR4JnuYT9MrpCqiYPcnLNvWuuLG2UNv3j+WGICIb
	dAoeTG+WM/K7xkzasGC2P7VNUpAY9gs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763051860; a=rsa-sha256;
	cv=none;
	b=a2XR1VBhhofArRGcfckjfovAzOl7QCDbdbmRLXT+6WfGSfLkvaox21sL+VdTSXRCfAdPpw
	cxbuHBcAezq9qVKwHXfQke61wfjov7U0kH95bnsCL1/hQmwY/d144uv90nIZiLwNXRq8kK
	6KPy5QUpiBcPFlgvO+8jRLPsEqsWL30=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ct6vVd7R;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763051860; x=1794587860;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L2dJ8M6bmfI5rWS0eXljqH0I3hgmIRg5+3CvR8yK6O0=;
  b=ct6vVd7RRE6lT1iDKlA/K4uN35bCOfV5XcO+5A1sY6GKqZ9Yw9qA6w3M
   T4z8RMRi59NhjGcZW0Mo55JEMqf4KLctgNrrYIHnXOQJ0TJHzEPuIW0Ft
   FzsGsXKOKIvImoHROjcxkzMdUOJXRUnX07PvvmaS3x2lZPlz6njDZKYOb
   MnHph4X6xj1gkFqp8o4GaBgtOl4KUtle4Ovnh4OL+31l4K3FvT7GcbuJo
   EL70O5zxRoGywydbFm9D9OzVskq5ID1gLwYMZEtUr3IBvYYOQQM9yej+Q
   rqcV8WB8RpznAyQcs+mAFSTCCtZ123V/quvZKCIP7pwJLGuLYoOViWZZt
   A==;
X-CSE-ConnectionGUID: 8wP9qw1LQ8ePnhByo3s0bw==
X-CSE-MsgGUID: Rm8H9ORDRCqr+PxSgW+WLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="65045380"
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="65045380"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 08:37:38 -0800
X-CSE-ConnectionGUID: AxHjYY+HQ/WDwsFLkMMLsA==
X-CSE-MsgGUID: +4p+XrXRQaqBFv8amwvoWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="220358822"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 13 Nov 2025 08:37:37 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJaKE-0005Zh-1r;
	Thu, 13 Nov 2025 16:37:34 +0000
Date: Fri, 14 Nov 2025 00:37:28 +0800
From: kernel test robot <lkp@intel.com>
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, kernel-team@meta.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory-tiers: multi-definition fixup
Message-ID: <202511140039.XVfj2ju0-lkp@intel.com>
References: <20251113145815.2926823-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113145815.2926823-1-gourry@gourry.net>
X-Stat-Signature: okjpdrq3amt7s1ckuhp813d9uaoea9ng
X-Rspam-User: 
X-Rspamd-Queue-Id: 06680A000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1763051859-740947
X-HE-Meta: U2FsdGVkX18f3BS0E90ExltOesg9im/XG++wMF1C9fkXZWbRrR9l/kgFC/OWuNaIA2YRMXUu9rnsV8Dukvv1AwEoO1hToBrFEVN6RHkhRw0ckZ6YRzEqRXl6lKvyXhJW9NSwMjBYKlj4bvWq3P9cGolk0GSgY7L0TR58oFpkXh+mQYbBfBNB+Snj09hNhlVplOTKCSPHrFuOLrEve33rb54QbbdfPbFcDhT576mWzTm+mTznZRi2cl2awyN1OsubLP7Xvc8GCNp7DCwxCzw4uG5QiH79nay9wukpPcLgm9AX8cpXH/wUgYQUwVfLZT2M85hJMsdd6WlmYR0IX/UnrqT/ODNkt8jcShUhAyjPMHKYDYNXiHCanr8FRtkJkVeuD9arI1lYk47Uzofuo3xtumXxrcom4sjR5NqkLCl6u9/sOM4uM8wwI16B5+Khg2osBihnKKharx0Jt5odaIcSGOMBMTVXLumGZ448Bs7/h3jaSShvnodXmM83g1VFomkWEw8O/DutypyYMAwhO8OhxZkZB3qA6hL62iRBfUdGdFqWVrRc3gAaJ0DOn5QeAQSW6zsycacnhHB6ZU7h6ymMFFCBXmp8exZTkQ4KSo83G3hCoyOfAdzM7DSFy4+W9/rYpbwybhqQbH8RXdcwqd80/zfmbBwr+iANfsRHcSAVHJSWsubc84qaQi8Z4VqDprOXqriodo/GhZydCGpNX6u7/FZsOAXSzO+aDTzlYW770IN09HmVogqQzzC1YpAjPQ74r/PKJl+e6mkfvwyUQMgatTKXVkOXN2q0P9cFTgiFTHaLO5DeMkbQx7Uku/rE3HDpFCj7Q9MGoceXwyUi1lOD9hC8FHo/50k9Pic4ddh6/ZMHx+NJqB8u4xDBDPUDcHr/cD7infuC/J78SG2qugr9VLzp0/q4iExiIjSdx3DnyAwRV1mQjEq9QMn4hQoIqLrzsrCjPRf7qE1JOOQV2bk
 pwWpdQ6x
 ffzapdgjzJsSeLzUXfyaOikk1J/L+jtzsTEXVyyPWM78Lm045QYrj6W8otQ2Qrx2OBWJUrDR3Etsus6tsdEBi8LmQOC5HmZWy8VflsHcvxLR0m/tJJtXDjPbgtYTblmp8czqH9cgepjKupjOCnRl+KadMeM8XgXSlkMaatkEEqqohZt8bqrrB/jP/s4zjvFvq4GIY+pqShDnJUkE6MVlCvScMWsZBCl8JXDA2H+MWOHpexwFeyEizdy1bJPm4sbp50+K+nUwgfaCzHlEIJ1j8Cye0vh3HdSbqu32u+XJNgV2lJogK1wWFRfWiEkN9dlSbkCsbznQOID3cw5GE2s7K/fb7v9HNtmLLOZZPtna9uz3afL91uwvhVDAFee4zF5igPcZJUxrl8QFOi+3o8eYoU4GLgy9akGtO1Lu+WFHtO8/avVw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Gregory,

kernel test robot noticed the following build warnings:



url:    https://github.com/intel-lab-lkp/linux/commits/UPDATE-20251113-230036/Gregory-Price/mm-constify-oom_control-scan_control-and-alloc_context-nodemask/20251113-033247
base:   the 8th patch of https://lore.kernel.org/r/20251112192936.2574429-9-gourry%40gourry.net
patch link:    https://lore.kernel.org/r/20251113145815.2926823-1-gourry%40gourry.net
patch subject: [PATCH] memory-tiers: multi-definition fixup
config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20251114/202511140039.XVfj2ju0-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511140039.XVfj2ju0-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511140039.XVfj2ju0-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from mm/oom_kill.c:37:
>> include/linux/memory-tiers.h:197:12: warning: 'mt_set_node_type' defined but not used [-Wunused-function]
     197 | static int mt_set_node_type(int node, int type)
         |            ^~~~~~~~~~~~~~~~


vim +/mt_set_node_type +197 include/linux/memory-tiers.h

   196	
 > 197	static int mt_set_node_type(int node, int type)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

