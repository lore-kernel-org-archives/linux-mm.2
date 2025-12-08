Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC6E6D1CDC6
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 00:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 928906B0005; Sun,  7 Dec 2025 19:58:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1F96B0007; Sun,  7 Dec 2025 19:58:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7795A6B0008; Sun,  7 Dec 2025 19:58:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5ED916B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 19:58:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D5F3B8B0B3
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 00:58:48 +0000 (UTC)
X-FDA: 84194493936.09.C6E5018
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0E0B1C0002
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 00:58:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LxruW5jz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765155526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFVMojQ3Vh2BILTu1t6IFrfKeeykv15sdEd15zYZaiA=;
	b=J3APGK5HzwbYS/Z6KLVOQxr1YcesGWw3HaqU76xrU5UKNxP7SVrIdUNlsuQvsU0cQoUdnh
	TPFmmkI51vxSmHlt4wOov0vMPkOYzasQ/k21eF65dOrYVF5CuU1QTzyvXlyx8C8T+dxpo9
	SE340IHFLWmiVjwSNmhxfpV6LK4fPkg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LxruW5jz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765155526; a=rsa-sha256;
	cv=none;
	b=UZ8sj/jaq722NyZEr3RKrH2ofczR+ZUVD5hvIy44WyCl3eVJsZIvAsT26IcvpJRXx9US5i
	qt6V5zO1og9ViziTxyVNUCWAiN5nF50zlYkrjnixFdaHNLU7yCvspsC9y0MMvcov87y0Wr
	m/LhwY/uC0b0hIAtBUFmySjTbCVn4j8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765155527; x=1796691527;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AuVsZDC9lU7lEds0aHXmR4LfwJLUrfxrrmaf8c36yhk=;
  b=LxruW5jzvnsQheO3In7n+HkA94He3E1BqgjeGvEDi18orXlw8+ZJqn4s
   nJbdByQAn+enM9Us8Yzbe1Ap+MBEgzQGQcEgM1X0cWsf/6rXux+GXGMhy
   hKpqcTFdc7wcpwrkbNGACgiUmnxMPOrZLf1qKWAvdoosbFtRFa2LKezAl
   1KYW41I3jj2TxvdE/SYZsMkDDRudMV4/pIYIiplPlOBh96Ng1lhzRlw/+
   4/oVqudGcca7Jcnd1RSRX/mKkvLqqSz0NwbkMyLrj07awsnP6gfe8RaOu
   UIjyq9bLce+i1vwXRUdnpS4iI1O2Q/1HdlAZZNLlmUZ7sLZyiCy5bO3BA
   g==;
X-CSE-ConnectionGUID: brL5N3bqRjesdHe1tT2kGw==
X-CSE-MsgGUID: ovhLOpAQTKmxKLdBLcenJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="77419579"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="77419579"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2025 16:58:45 -0800
X-CSE-ConnectionGUID: BKqEMDGdRcSJTkPM7/7ErA==
X-CSE-MsgGUID: 7D6Fkr6YT/a08RrtUmbsOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="195827665"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 07 Dec 2025 16:58:38 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vSPaF-00000000Jkf-2Xiw;
	Mon, 08 Dec 2025 00:58:35 +0000
Date: Mon, 8 Dec 2025 08:58:22 +0800
From: kernel test robot <lkp@intel.com>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com
Cc: oe-kbuild-all@lists.linux.dev, andreyknvl@gmail.com, andy@kernel.org,
	andy.shevchenko@gmail.com, brauner@kernel.org,
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com,
	dhowells@redhat.com, dvyukov@google.com, elver@google.com,
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
	jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	rmoar@google.com, shuah@kernel.org, sj@kernel.org,
	tarasmadan@google.com, Ethan Graham <ethangraham@google.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
Message-ID: <202512080828.Gxjg6av3-lkp@intel.com>
References: <20251204141250.21114-10-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204141250.21114-10-ethan.w.s.graham@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 1yewk9knyy9hsa5htsrd6wmfeh95php8
X-Rspamd-Queue-Id: 0E0B1C0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1765155525-544267
X-HE-Meta: U2FsdGVkX1+PC8Mtk5ul2M/SGHnu3UgrCwer48ew2uPhd4kmlBRIRplJ6gptCOEzvi1WJ/s4KAdqBCVShAgTBPXUvKNk6G+9Wftu/Pa8W2XrpEnLswU7jQHbdlSc7EZLnEtI/w2OdIaVuQ8mTd0sqQuwthaXA0bv15RHjPKpVJFG6eIw44zgDzmM+ZHtqV6R/ER5WmF4/fjSJRMnKNVx1OQJRK4X/B7ol10BihcXfYH0QqxPQBtdA2ccgtZA7TukvEd2Uvy7BiYQ8PAN2hqwddCXR0qPVemhZN/9k8U2k7tRu1+GwTf8HUJpLkQLKG8+hTPEuFN+PHfveU586WL1tVCQJAlycEiDVS0ZIN0IG384oAg2iiZLTm2fVXlFLMlqzrHk4jc8NFhcWzcoHS9y9jeTgY3OZkSItjpfo0/9zejfPVUA3ftHOQTBZF7zBvhnytejGVu25m1a/7XBb4BW0asXhK1x6DhpNuu1L7JsBk46QnixI9C65vImb5vmsv3eFPsNPDiBuwuh6cGDQ+RT50WjID5UuDlD0oosfP+8JqAUu7Ibw8s5eoeeIJlTL1WqEcm1A5W7ptZyfWbWutXS3NAo48whTIs6ZWxkm2a2W9UOdwHs42vQOFVZm5DVjIjDarSPh4IP4dvGWpc777y622E48jFKTQVwD8uA6yKL+/Pa5PBzSQZ0Q8vcUv42x75jNX+F6fBkX0a/wf+RRwhKRpPCWWfoaE8ANst+r/4WF/JBjGNpIyKKz3kxKPImTxUy2p6c3K1OcXXpErdgvxsKbuZgTkTrHwYUKXX+4/4c1bWeLWo+dcoLE4uLD3LuVTdOFBZkY+EYLjyHJ7JBzzfxJ9OJIl52Eql6OTUOPwXPYq1+uLessRx5Dv3eftQb3lxNigp4hI20KouPEvjTkX+EW/vKw17LFsSSyM7MjBvMr6IUcRjg1t/hWfxKiXLW0ShHXSq8IElge3OY38KP2Zl
 76Vjpfza
 Ak5DB5f8WFKzFHwSdqsLy55vyQfr8pdNGTe5Y6JHMWu946/ln7wJyBVdX/nkpQgcm8P7/WWXbkWUwHSwCPzyZCcDvImQH7Wuk31F6X19JcbrXSMmENzBCb5bze8DQT93PSYjwXeO2DoL7qbQj7mN0/wQ8bE3OBWGUsLZUQQpuTG06GVEZF6K5o61zrMhfsAqSx1RzzIzdjFXTxC8DImOnBmfYNewi8ROv7XKvtklOQKdkqN/yI9pDIs1pDOpq7vgmB3Imeags5Xlvi4uo/6z48CcYMtJq3xiG4eGJ/BOFidMIpYpYn11J9z/nT0N5kuLDcMikHjOeTh4+NCIvOyRt/bUWHefRS9k9/DMkcp2+pTVQag+PTqoAmdHN0pm57rLWxc2Rf2C8oT8+ZU1/wkHvO9acbhe22KWhZEHSwDs3aGqO0FAG5F1ewfZqv39NLC9blzqov+LponoOJSrD+oCh8YxpoMQP8mFiucu9gLZwUGvhei3yZi+6jYZAsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ethan,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-nonmm-unstable]
[also build test ERROR on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.18]
[cannot apply to next-20251205]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/mm-kasan-implement-kasan_poison_range/20251204-222307
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20251204141250.21114-10-ethan.w.s.graham%40gmail.com
patch subject: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20251208/202512080828.Gxjg6av3-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251208/202512080828.Gxjg6av3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512080828.Gxjg6av3-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "kfuzztest_write_cb_common" [drivers/auxdisplay/charlcd.ko] undefined!
>> ERROR: modpost: "kfuzztest_parse_and_relocate" [drivers/auxdisplay/charlcd.ko] undefined!
>> ERROR: modpost: "record_invocation" [drivers/auxdisplay/charlcd.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

