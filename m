Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E1FFCD0CF
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:14:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F926B011C; Wed, 18 Mar 2026 04:14:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22CA6B011D; Wed, 18 Mar 2026 04:14:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E38736B011E; Wed, 18 Mar 2026 04:14:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF3366B011C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:14:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B0721C250
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:14:53 +0000 (UTC)
X-FDA: 84558472866.30.D4AEB2B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5727BC000E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:14:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BpR5p4Lb;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773821691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dvyk+rmMU2+r1/fLDKtW2SvJ7b9t4sHtJbxXhCORNNg=;
	b=hgnlRbKDMsHOUpqDUfdwW+sduiTx1cDsElxEjPPIjhLj7BGOAUEMf3Ss6ObZ2GlUdR++xg
	N/TbjVUV3KSI0Mel+pe6YAgI9hgfg5zibbs+7t6t5/ZpBAMjFMBwYO+mONu6BjBcDLonD6
	3qDHbmvVX2rFVASqozgeB80xou9TXFE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773821691; a=rsa-sha256;
	cv=none;
	b=aANURUoTHHLQu9ztCbjgHGrVt4zCtz6JfApnfbosrOTQmzxI2yAU85cKH1hQkwtrzglGeO
	7gwCuJ2oluCVy9deGbOLgA695RA0WgA0w4SV9pKYb+txAF+qz+UFLWwtkee9+wtapaSFYc
	bT1gl4Yb0H2U1thgk7FeSz7evrErAl4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BpR5p4Lb;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773821688; x=1805357688;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KnJQnAwoUMsLr/BjQ2p+6cnCTXVLGYccKQ2pW1Askdk=;
  b=BpR5p4Lbxa2jZRzmZ9VEuIzlvC5BMpyGpbNuDS5Nn7KOMno0AZmO8wpu
   decP58Tx1JR4AY7QlEIM0QVK4ZDbRa2fimUhiBP6EnlV6+jLQwo+fhITS
   V8kizfOwCapAU2JApG3Ds9Sh69Bvd+jgVyI4wLgoQzhY3YdLNDgRuP3wo
   /r3ZGg58QcaoNMmOSwpIxUQNbxkfZqWU3uMdgjR5hBEdOEQVwdKasfc/e
   wXLyBM8GusRXs9E0Eb3ghxD3XPBBpMnaFBg6eNC8rU/3z90L2lm9ns3O8
   dYCGMXtMQo8donELberH+LkmBvoqN37kEj7a/X7KKkVa6EIB6KhH6JW9u
   g==;
X-CSE-ConnectionGUID: YIKyMUE3SsKsyBaFa4OJpw==
X-CSE-MsgGUID: lHEjv7EXRPKmx9Kt+XjUDw==
X-IronPort-AV: E=McAfee;i="6800,10657,11732"; a="75051370"
X-IronPort-AV: E=Sophos;i="6.23,127,1770624000"; 
   d="scan'208";a="75051370"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 01:14:46 -0700
X-CSE-ConnectionGUID: 2h8ZQetNT3CK/+F1r6g9MA==
X-CSE-MsgGUID: soGT5hiJSj2k7sFnrbUVvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,127,1770624000"; 
   d="scan'208";a="253026050"
Received: from lkp-server01.sh.intel.com (HELO 63737dd503cb) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 18 Mar 2026 01:14:42 -0700
Received: from kbuild by 63737dd503cb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w2m34-000000002i9-3nhJ;
	Wed, 18 Mar 2026 08:14:38 +0000
Date: Wed, 18 Mar 2026 16:14:13 +0800
From: kernel test robot <lkp@intel.com>
To: Leno Hou via B4 Relay <devnull+lenohou.gmail.com@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Jialing Wang <wjl.linux@gmail.com>,
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>,
	Kairui Song <ryncsn@gmail.com>, Bingfang Guo <bfguo@icloud.com>,
	Barry Song <baohua@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, Leno Hou <lenohou@gmail.com>
Subject: Re: [PATCH v3 2/2] mm/mglru: maintain workingset refault context
 across state transitions
Message-ID: <202603181625.6juiPMws-lkp@intel.com>
References: <20260316-b4-switch-mglru-v2-v3-2-c846ce9a2321@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316-b4-switch-mglru-v2-v3-2-c846ce9a2321@gmail.com>
X-Stat-Signature: t35etysk9oq5ryqqp7qeigms3ekqd145
X-Rspam-User: 
X-Rspamd-Queue-Id: 5727BC000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1773821687-121044
X-HE-Meta: U2FsdGVkX1+G5lINppibL4P8TpbsV+1LKDOf2qLRmLyflkyxnJJXli5m905tcCeIBWK0en3gwnnwzJrdy8hzMYg67tw60l6bJUOYhx1Tsk+fdRupnrO0fudDQsBYnoWXMN+MXRegi1dAHu5eJgO8EbJ3nsdl4f9+mdrKOo07HvPgfOkAyp6gMD3n12JtdNgQ/+EnAPMAIUralCl+HO6yc6EWeNhCW7VGKExmWarw90zIH1e2V3lDIo5IZk1OsIwR1kIfq5UdE/sMNox9YOzMvbiFN4oB/8g8A7PUmD4x2kH0nUl+CbSxEqwGY9PdDsnnCrKtnp662l5RSaNFdesSffk+BvQ6UU9bIA0KkGW8J9rs0psgk1+Pb0ODsUxyIY+N1pRv63JGIzkb+xIXjxD4V47Kl1sUWO2twrRYprqqCpRRRJOfkvMzeCX+XWmzra49LKzlOwi/IryDjph0XzF2mhGo4xIr4e/61XVaXPmrzkandrEt873T6csMPquwjhSUqUQe3akamZwazsm0Ohx95uSjQ5LaLZTjTupJgQS9cQ4BQXRKm9w0hwT+1Ze0gtd8tVNzR2Dwl7QkzNeT6asnKCsI+9S48PQS7K3DKfxKantT1mIZevv5LYfl1rZqbgwEQDkJBJQsaB5hSDBIdDeLCEgWTBimn5rfvvSSD6pS0ytf//E+7LjAAVYD9bfoAFEUwf7ohma9t9sHByiqZFAWohk39NduiZWsKDQEkFjmGJCnJtc/3PwLGOrXHXdZFJnKCgm3f215UKbjOaFzlvPqafwhIrXnUigh3Sp9cW5QggYcKCgTiEMal4eKZIq+kBULbgiuyViXsAq51nHpnsNCgK679yxcHHdxw5AXeHfSnhRy18vhQD2iJSUGOqRgscV8Dxb0svJbCC8GLiDklF9JXHbshuVT+5LaQAvYkX16Z7CgbMBqd8Vcorll6hy9yd/1Ob5ys/Ke4c0bcpeuLRB
 pBnkwWOD
 p5I+vEhzasltnGrRxvZxiDSYPC2HJIkrszxr2Y2CzzuWRklVHqoyG9x8Ngz456vGpfwJmfP34AX3dzor170EMX21mpxt3H//EyNUFFjBfBdkN0wrWmQWddLTVvJ71rTVLQCMCKTQ0+wf3blnWOaU6lTQge/KZ4wqUMqA5HB8TpgHRATXHHSfmQNDqI9psOX5uUy0GFgzrDNM7rNVBQTUbLjDmztWM+MT50ABIofcubGKxpxFBhjAAeywL7Q+K50Ezpx8YvUmodJWXtwgROVHzEHf8ruXv6lMBEicU00hVK+ufxyxkNN5ij4tT6HttRe/nXirD5AVOAuzD0mmglwXpBBs88Eqc5rj1pSGilPh9VeLfM4efb/z2VgN4ROqrvHlHKKCWLAcl7+y0b7vRMFbMInFmtn3x6UuN9BEJZ6aHKOPVzEaHLw5O2CWF+AotFsclxxJ4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Leno,

kernel test robot noticed the following build warnings:

[auto build test WARNING on c5a81ff6071bcf42531426e6336b5cc424df6e3d]

url:    https://github.com/intel-lab-lkp/linux/commits/Leno-Hou-via-B4-Relay/mm-mglru-fix-cgroup-OOM-during-MGLRU-state-switching/20260316-140702
base:   c5a81ff6071bcf42531426e6336b5cc424df6e3d
patch link:    https://lore.kernel.org/r/20260316-b4-switch-mglru-v2-v3-2-c846ce9a2321%40gmail.com
patch subject: [PATCH v3 2/2] mm/mglru: maintain workingset refault context across state transitions
config: openrisc-defconfig (https://download.01.org/0day-ci/archive/20260318/202603181625.6juiPMws-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260318/202603181625.6juiPMws-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603181625.6juiPMws-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: mm/workingset.c:395 function parameter 'lru_gen' not described in 'workingset_eviction'
>> Warning: mm/workingset.c:395 function parameter 'lru_gen' not described in 'workingset_eviction'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

