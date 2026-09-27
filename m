Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A70E6C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 16:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B003F6B0088; Sun, 27 Sep 2026 12:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0D86B008A; Sun, 27 Sep 2026 12:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A24F6B008C; Sun, 27 Sep 2026 12:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 758D66B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:02:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D9008A0A99
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 16:02:37 +0000 (UTC)
X-FDA: 85260009954.08.6E1B01A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf29.hostedemail.com (Postfix) with ESMTP id F2151120005
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 16:02:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G2A4DdzV;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790524955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3tIfYOBxRcIE6ZYuZVjzbaqOVJBWedrZx52ljsxSZo=;
	b=UUGjyzQAK5GOMjxdqaaVjnJ43a9w9YnzYizWNoTEVFWi9RNAilouVrvvw+Q73dIOjuFfBs
	1iosZrCUEFSFHs/iPHQQIu33oS512g95OmYyr57r+MLOdppF5vKLhn/HE9QL1AZ/KdNFJv
	LRjmjoGOXhQBqBjKGzBNKpmRV8JJfsQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G2A4DdzV;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790524955;
	b=ruFcS3YopbPKya4H4OZl64JzT2L1+J3Th3+Dpin4IIjtjmP6ujzqKJO6tHNRw58ELgg3yE
	c6tVE/wWATkULtdE5TNIwYoKSBDx/DVZoHtReaXnJoREd7fdZs90ugdv4ILQGQUNE+TU2D
	kxOyJw2TCci6vgPL9MqFLuuKHn+uOpg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790524955; x=1822060955;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CTavZ99JhSancwAsfzE/DN+VXQbwpmkhXZpVZJuivRE=;
  b=G2A4DdzVgspaR0Q2PkPmQm5H/4BECsgJmRwWUCCMT3WnGPuGCp79Uaez
   Sdm9HYFiD9r63jzj8eataqD1hXjWs3GqJ4d+fufCV1brFcXMAmo8iDOuJ
   7D2C2TkMwTVNol25QjrQL9HkOznG7Ol1qodtAke3tb6edo56I3xljO0wy
   KfFn5kmnjK6SopJX7qS9ZSunBm+FfNI2RbX7lpqVNFs+yM/xJ8HNLDtmq
   Ov9u7LMkkPhtPywdNl3OK6zdOS3cP40pfBu+DuW4EOPAqFY+C7NgHjW5Z
   TMW5JsM6y9vjC9efJ/R8LziYTQSYeryuVev9Gz8nHLGEI5xEoS41N06Gk
   w==;
X-CSE-ConnectionGUID: 173c+FEMR32YDnV2eDcEPg==
X-CSE-MsgGUID: xHaew0HBSgmJRy91aULeUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11918"; a="101898219"
X-IronPort-AV: E=Sophos;i="6.27,126,1787036400"; 
   d="scan'208";a="101898219"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2026 09:02:33 -0700
X-CSE-ConnectionGUID: nLEMoT7ET6CiSvxDhsc62g==
X-CSE-MsgGUID: XdM9XDKSSPyCk3+TQ0yBlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,126,1787036400"; 
   d="scan'208";a="274358961"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 27 Sep 2026 09:02:31 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xArKe-00000000Mzp-0QOT;
	Sun, 27 Sep 2026 16:02:28 +0000
Date: Mon, 28 Sep 2026 00:01:50 +0800
From: kernel test robot <lkp@intel.com>
To: Abhishek Bapat <abhishekbapat@google.com>,
	Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Abhishek Bapat <abhishekbapat@google.com>
Subject: Re: [PATCH 4/4] alloc_tag: add a test for trace state toggle and
 filtering
Message-ID: <202609272338.hVBNO626-lkp@intel.com>
References: <988dddb203416668a10bc9c5e6157a78615d2ed2.1790025465.git.abhishekbapat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <988dddb203416668a10bc9c5e6157a78615d2ed2.1790025465.git.abhishekbapat@google.com>
X-Stat-Signature: 4scku3ngmsjyo338jz6tmn7utb46hqxu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F2151120005
X-HE-Tag: 1790524954-139991
X-HE-Meta: U2FsdGVkX18gdYAC3WBNZtEW9CbLoZUNkr6mgdH16v66p7CuH6MesoBSdNgQ8SXxRY4plEfLS3Vlx9fXTqGeETGv12IzjOp/VOXAp4l/KAQj2On2Cf2o/V66nSKIpCg9J+Oz1DRti0w2UAP1NKWtR2dBsspAC5+5sIPelHUNbwIkyxPNZ+amiwXg/+2TQ5A7BKtY0hM8LxnNiybv86S5sFdpB/6zo4/DRCWMzYQUTNOMg/h00yNc1Nk4Ec1d0Uylksx2VzCRtea1BLT1cPhmuEnoiYj+qRJ6BKPPdSNpwIbHEO4CqkKeP0w38GxiLLkw3Z3vzK23/dRKypqU4GwS2KRB/yW5+TXqcWvBJX9/J3ZHTKvXVQm7gvIEUUjYeTGMcaOpdFz73S2OF5JsCYWHfV/h1pOFbeBQPyJ6E0JWTnBBb+NMUp/CzptKAxR4yVUjxBpglYZfmLMz6qKNQUo43A2oGy8TskaBHNAJi8oxe3q1xY0e6BZKFEFIsc9MsPAdrfVT1+HkUfxO8vZlTcfw+9CewLIUYEZjXFQWokPaIhHPuShoLiaygPc7vdKmUINjtVYjzs2xtOuRobzwGa2lnCdRF50ytlHmyrIazA1q4FRx+4REg+NEr+2w0Se+a8thgkOLVgC6g1yz+hzPJlVRcObxCsapcWsTrXbLo4WJaVGccC1kPLGhptD/t565+bTzQWik8IMaYCbTg8HaADAHo+SCUu6b+gs/rePA8aQWIO3creSaj+OGEWJ8ZrQISwhYm7IRc4QC5GsxHrefuEnSpUjO0GWCsgFhOBGHDVDCANVl0bBqcSUfARooFDM+IW2QsQrrLVkFhAY2vEwnEgDIo6MdHj6yFZIhqMUKQnL/k9ffGTnXz770ADhAy26mxzceD3uoQkiNv01hwpSySqWi8YmS5Fj7EtysPKJPdDpmr1w7AQRWfVvpm5BqgMsTN0hUR4mU7uA14VtXEeZ3cM5
 d6O2lj/K
 dqvl47eS2T2fHqGMzvHrUmN7bxoNBqku0F5IdjqQF9uB0R+4156BwVkndl673hjAG7SbSGbYW4H3zD5dOMKIiItLHBvzbDhB2UC9n4PWDdCXZQoblwNmOkDAXuhJ+4lSrrGgobo8v3VLTC54gHKQfDbi1XgkrqIvEQqhpCfzp7tOoiCNgVydhNhyWPvHkh9iXWtvmvAhuxpxgp4MdtRh11xdUaVg8YASFEsIyPfwlci55UfIuavKENuq9PKe18NuI7gC5UXC6o0prcWkq+OzoFEhib0rmo7qgnxbjeK5/ii3EDKBWMzARJO7pwUfdKCvPHW6az14yNTG3BSTDuGayZJZT7CBDPQctErmd2W0ptS+3+Xy0769j28InMnmX5Gb4W3zOdcMcrbXyXddfK2EdsujIRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 8d61431ed2607386b427752505379536eb634ce8]

url:    https://github.com/intel-lab-lkp/linux/commits/Abhishek-Bapat/alloc_tag-Add-trace-events-for-tracing-allocations/20260921-212638
base:   8d61431ed2607386b427752505379536eb634ce8
patch link:    https://lore.kernel.org/r/988dddb203416668a10bc9c5e6157a78615d2ed2.1790025465.git.abhishekbapat%40google.com
patch subject: [PATCH 4/4] alloc_tag: add a test for trace state toggle and filtering
config: xtensa-randconfig-1001-20260927 (https://download.01.org/0day-ci/archive/20260927/202609272338.hVBNO626-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260927/202609272338.hVBNO626-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609272338.hVBNO626-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: vmlinux: section mismatch in reference: alloc_tag_trace_hit+0x28 (section: .text.unlikely) -> initcall_level_names (section: .init.data)
WARNING: modpost: vmlinux: section mismatch in reference: run_tracer_selftest+0x250 (section: .text.unlikely) -> initcall_level_names (section: .init.data)

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

