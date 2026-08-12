Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92DA3C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 20:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76E8E6B0314; Wed, 12 Aug 2026 16:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F88B6B0315; Wed, 12 Aug 2026 16:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C07B6B0316; Wed, 12 Aug 2026 16:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38E8D6B0314
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 16:32:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C9EC280451
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:32:31 +0000 (UTC)
X-FDA: 85093765302.29.B8D7C5F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf05.hostedemail.com (Postfix) with ESMTP id D4B3E10000F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:32:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gTPTeizB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786566750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=w3OM71q5jpRuRMtHsvNviJOTbFPWRW9zGPBWl+4rTZ4=;
	b=Wcu710hUQGlIyVhfviCKQ2Rb070umjNqc534UJXLFAGzqJbQWhLe5FYdxAxPCJ+SvjEhcn
	bb8YB9irC2StHgZor5yTRmGqBLboMSYXHzp5GiRXRn4SEwppizVmsucKTzRCl65GtpR4Ee
	12KI6U8hKxQ3GLg/K6gvvxeeR19sr1o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gTPTeizB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786566750;
	b=pPvaQN3gxWoVm4SbLlkHdaLe/H298EvOFl+dMWhdOaNafMiycdI0XNGl6EI+7wSe9YRPM2
	U5bZ393cP1gw1bDwBwcEyiJvrb6lQnhaQI7l6gjCkEX+ek8Ivi1aUXVbxYnEosjkEH/kem
	ApNLpZmYnSGpZamwhDfqsYX2nXVJbro=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786566749; x=1818102749;
  h=date:from:to:cc:subject:message-id;
  bh=81rHoOrQlf4dLih8DATUfBEZlHeIo+D1i6BG9B5MZ1o=;
  b=gTPTeizB+HyX+GO4fhDEUZYUeUAq6c6H2MKQ3tKKHhZT4XGj8uNBOsIr
   CTBjy66fbApgqUhSKQD9TPntGLiP86A6gaH2OLG3VTEA+ndSLZlYKHWrN
   tSvu4GC04vCAF79LYVTXPsHnxqAwbm++1ilBbvVoPa0eEafvIdAsOvtPh
   PT9G/ResYVsjV9X27aGrX0I0PtZtE3xK6S8xeEVW9DQc157Hf1aGVoHJd
   S6CXO104mriTR3a+OmRWpjJqE2qcFMGlbvLIsLPs8kz+xOFrE9dhMzWSB
   SkroXYLJiOtmU3zhfW5mBXpxaglnVecj0HUIQTYm6dTLkOk9Kpi8d3wtz
   A==;
X-CSE-ConnectionGUID: WELzsgI9SSmcUrZ3gysjMA==
X-CSE-MsgGUID: TqLL1mX+Q72iiuiQa6aYAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11873"; a="90814666"
X-IronPort-AV: E=Sophos;i="6.25,220,1779174000"; 
   d="scan'208";a="90814666"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 13:32:28 -0700
X-CSE-ConnectionGUID: fF6BGFNBSpK27Eyaysc3Xw==
X-CSE-MsgGUID: zmkzyJX9QvOaPc5DcjBvbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,220,1779174000"; 
   d="scan'208";a="268011495"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 12 Aug 2026 13:32:26 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wuFcd-00000000RcG-2Zcq;
	Wed, 12 Aug 2026 20:32:23 +0000
Date: Thu, 13 Aug 2026 04:32:19 +0800
From: kernel test robot <lkp@intel.com>
To: Josh Law <objecting@objecting.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: decompress.c:undefined reference to `__ashldi3'
Message-ID: <202608130401.pONAe1jp-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: c67rf15bk6jrm3zn7rakh7j5973h86ge
X-Rspamd-Queue-Id: D4B3E10000F
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786566748-504384
X-HE-Meta: U2FsdGVkX18ED7xzXydbYg8SGMa1CT6z091402FPg0mUfUYzykUcA4I17miMYKUREeRQdGZa3/N15LINvSQEEFNzCk0xxW+RidZf4moxr31dSEzo6kM74zfeRtGG7yQq3uwupnfQ6oWOoYK2wekJh0TiKkbWv6VvyRI8w3YiEDVh0wYbs4OkpOawAXTc3vq0Qk9Vx73F1U5YzOcZKYRqmFF2iyMRdZH/bCDtdRsoGJ1/m59NKXoS47cU6OFoVj1mrPMXvm42GmY3kHiUOC/8+isvFlQrmK8rfml6b2j2T189qMPPA3lQ63hcpt6VGD8JnnZd96ZbAFVGtgO+SizX+8+bCKBo6ThqBoBjEAAyDls36ZD8G7IXgD+eSszQHXU06rsnu9lWRwg0kWgFpgCvx+8/ZfErQZHmWt8zmym4152ddCr9mKk1sGjszMaH1eim6uKggRr1zKGu7N+0coCaDEHQCMXgsLp0J3xoVdBYjqMF72sPPKZsFMKx/fNDbngaUFxtuOeBCev8JPV2W7XD4S61ypwktujQ8Tc+l/0XRp+Io7EfTsDTevSylrIzEcO//KWpFC4XdLhM1wcetRB4klqvsXAeojIHRE3zMEPUGQV0/sU7cQew5gmulRTNRQM4f8L55m8TgybJMlNfPRUKQJJzUOAVF+VOtaWflvZ8lF5NQSHTVJYThDccTOrfSw3oxMxhyN5389b1TRquTWBnNGyfw7n03i6qSpWxPx2oItcS811Ivd12UiUewYPxs++wVQNs5v8S+MEU3/KoFSKXWggBAMo5IcH25yvNRQ+CgyBFSlygYXZypohZ2stVAeT+hMkwVBCec2qEIZmdEkY17rvvg/IUe7YD1J9RaX5E2VqDLg+N83JAGjIhAN2xa3NNt8RJL8J64KIY6lf71Wgqn30k7OJr2NiqQDJELmXiXgrYet3WA4tD380+Yckq7tXrBykRSdjOrYXfP02aIsO
 sdnu8AVu
 kN4rRIMIVc9Cf3Kzs7YNX3ZSNLdS8ef/2GDhQ/T3SaJ8sx14Cmi2jO4FYx6L8nxbeWzuhNYI7McNDQbicwyj6uxyx0fMi7Vh4xOVld14VwvCubfOwLKBZ8SOXGGubVSrH7noQXdJJSFVhD1YVumaI0ifaPcVrpWs9Ls1fzWjUa7QR8uz+jqPZBcTzFy+42MmomdUylYMdCewFfiHt27X4L9Ynt9m01QGC3wwT6pZcDQh67Ro/Uw3B4Fwdyg/I5kwLFxmlZHDhhDgwHI87flaOLKv9L3QRQ4a3GtGgpB8yC6BFoa8L97di+XhlyIwaHoPXB+mtZ6mzJqX9YNY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   f5bbbfec59b4e2fb7520a91de3df8a6174325d6a
commit: d4dba3b9c03a326cfa73833d6b166aeb442f82b5 lib: decompress_bunzip2: fix 32-bit shift undefined behavior
date:   5 months ago
config: mips-randconfig-r051-20260812 (https://download.01.org/0day-ci/archive/20260813/202608130401.pONAe1jp-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260813/202608130401.pONAe1jp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: d4dba3b9c03a ("lib: decompress_bunzip2: fix 32-bit shift undefined behavior")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608130401.pONAe1jp-lkp@intel.com/

All errors (new ones prefixed by >>):

   mips-linux-ld: arch/mips/boot/compressed/decompress.o: in function `get_bits':
>> decompress.c:(.text+0xc8): undefined reference to `__ashldi3'
>> mips-linux-ld: decompress.c:(.text+0x16c): undefined reference to `__ashldi3'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

