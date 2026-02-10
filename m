Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 593A7EA3F16
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 07:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C5126B0005; Tue, 10 Feb 2026 02:45:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748746B0088; Tue, 10 Feb 2026 02:45:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6478A6B0089; Tue, 10 Feb 2026 02:45:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 568E76B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 02:45:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06477C1B99
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 07:45:36 +0000 (UTC)
X-FDA: 84427762272.14.0EBE562
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4FDB5140008
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 07:45:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PrZQSAkx;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770709534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0NNluPR1qrBvwTR58SCT0U/BUQcTW1FGfFjXRsyE+I0=;
	b=ZDrnHQPli/X+OpcZrBjyuatyuZQUOCPtvmqtyVTl1sWOImiDZlXnqqZagaTho6fOvgl8D/
	Cr86foozqBjQWsUxszuN9OiM+oP4t3sV92TCTItcMdrMt9eaHwPvTwCfmMX3bO4Z3uSNi4
	dApOlUoE5vsfc+g7f9N7CjG+m9B2I8w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PrZQSAkx;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770709534; a=rsa-sha256;
	cv=none;
	b=HA5H8wEeMdAWuFqTNRomnLAY1X+RA+3E4cGNaYSxlqBb5tYKl4gM/e9zq8mjcLwcTc7FOQ
	IHuaTPkVNj5LIMoT12Ym2Snr1tTUY5jXqJnxEY096QRuijejT//1WmsVPlwiyX6RJJgNz9
	0O2iwNqJILiykuIYJfZOwpnBbc1Hwhc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770709533; x=1802245533;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sJGjG6kg446tp3EparQy4R1qSHF3uD3BHRcp+JD38W4=;
  b=PrZQSAkxJCqyy5Xarc3jCp8HEvxZCDM68nqPqer6LStZF0L+9AnrTF3/
   tFs/Ni5ZZ09e32xlPCC2U4d7CqD+L+gO4wmC1Cb6XxguaZfUlJhMgy8bC
   QPLjkpavUGPtsEVQZHYNCKDYeuhoQMDt1HEvtQ+9VcYoI/PNyAYJ7bBkG
   /3NkNMUdh+sJj5PVTaLheEPgU5k6CfmbX3xpn0zVJ/YntfwAW7dwDqshC
   /jeYcMnB1aMJVyGxIO1pcnRJFtKZBybbLoFcZe2SHm/lKMvmuF37TxUW5
   aIZ3gja8P3sPVcvjnUJZ35DAAWpxDIClDxdzwR/k+kubr9NJPRgX6Fgur
   w==;
X-CSE-ConnectionGUID: Cs7CEHYbQv69X9lG7CilSA==
X-CSE-MsgGUID: V3XT6p+NTouMogoNGV9XHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="59397516"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="59397516"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 23:45:32 -0800
X-CSE-ConnectionGUID: MLtRNXcZQyWsNMJxLg+mhQ==
X-CSE-MsgGUID: 9nFpA0/HRhStRt3vD635+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="234797933"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 09 Feb 2026 23:45:29 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vpiR5-00000000omy-1aOM;
	Tue, 10 Feb 2026 07:45:27 +0000
Date: Tue, 10 Feb 2026 15:45:02 +0800
From: kernel test robot <lkp@intel.com>
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, david@kernel.org, baolin.wang@linux.alibaba.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	ryan.roberts@arm.com, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: Re: [PATCH v2 02/11] mm: introduce pgtable_has_pmd_leaves()
Message-ID: <202602101556.msl493OX-lkp@intel.com>
References: <f55ca6204336f52f1651d02dc370bc3b771df3d0.1770675272.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f55ca6204336f52f1651d02dc370bc3b771df3d0.1770675272.git.luizcap@redhat.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: jc5a74tiw8fx641dgnr7q3ey8u9q171i
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FDB5140008
X-HE-Tag: 1770709533-615470
X-HE-Meta: U2FsdGVkX1/FriakqfsGG7+Y8iGHlI7fC/AU/7lGXwmrkeYfsJrrcq0v3YPDWMj7Dw+ZwxI4tbszn4jLoiRZQos1+K3t6MfuNsRxXj7eNXjL8Gmlq31y+1A/Ip/A92RwtDuJhxGrEKpZC+mQ/4A0EE0s7SfrdQdc/uQDnT8BiIIV8nYFC3KVCr77FAKG4rEGEOGS1KmijqIc00/yj3XViLkz8Xbc1xfU8X7L+gMsEuTAxeG5veNUZlwVfKx1eIxJJPMnxdx5s+/dkLVSxeTPH87q6E4ULfESzhlvUrT0XnJVNB0gg76VjA4nYa9DLpgECsMBfTnZ4DyapAMtcRQrglZi5leZbR6b3JHEXazxl1UCwWI2BwGPEvwaDVfJ4W1x/K/q/xziuPlY4ouBq+kJ6hfj3uqpA94vTwMsx5k49TY8mxK96nzjth091e455E+IFLyEEwieQ8+G+/ImFGicnP2w6QfY4ivxvDx/50Wyx4SQv2b7KJ2YaMskp9BMu8mHPKGG3BOtQk+1SojAZPO5UaUswvTWCAjfqbLm4t75VBRqFKuimpai9QOhr67VcGOk5qasdajeNF+pZnuPONWKNuKHnmtxK3j3iYaTt8V0FQKTiTF1fK0995BF5ymdhVNuAiR5/EoUFGlsyqY/+IidK4E3WJ0hFPNYqYstLiCIyz4onsTqUV5cHYwGMfYFkjG7sHSckJumBAJh2P/bP5h/dBFO4sxikr+FPhB29QnbNycEDB+a8QN2MbrBb1YzlKTmW6SmMRm0UJVRWMhWxCgkvU1ABhjf/opdWL2tBRC1xr0d7UTuEyQeyhEW9PiPlN7SxUWjJh2CWnGZ9LCSqpl9hEedqNGIhb6WbaeKwf3TNF9Q+mNuemkaGuGPL4vS6DbuxiWqD9BtU3i8VqHopp66Ta5PViGOQVFWPvT2OFX7A2Yd/sID2JA/+m4WYQksFr9gQb/bxnzaPfHxNAnlyyy
 tzu+SnaG
 EMeRegHcj54mpDcIA/NbkqIYFnaKZdLjEWHNcg4QDceduPVZImcSmt2oucWPa+dfwTQ3WlyrFCnua0CUKRH8F+ORIFzxIurP7yhg2jNJ6yND3YPRFDBucUDMAkdkR/jaofVU4BOiXoNyzZNZ4imSyDRpdwcvI9/3Qr0Bn5UsPwFDHOwOMsvXDYpd+5o80+0uc0TEVrrhh0oQk82j252nj1vnpHp1g34PX5KLkKMNtbTOdZL5NykN5vhyvhLdQjOZDJiq6uWkTVYQ8mlcDDe9V5xG9KY4f87tdZBVUmA5nBwp5lR/X0uW3PQV+ClCeaahl45cK7u9R3ZFb6Y+C76iP86ZNTBO1yXE8xAqA0mq+13Phm/prqbjcKrNLBE+jwectTn70
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Luiz,

kernel test robot noticed the following build errors:

[auto build test ERROR on powerpc/next]
[also build test ERROR on powerpc/fixes tip/x86/core linus/master v6.19 next-20260209]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Luiz-Capitulino/docs-tmpfs-remove-implementation-detail-reference/20260210-061806
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git next
patch link:    https://lore.kernel.org/r/f55ca6204336f52f1651d02dc370bc3b771df3d0.1770675272.git.luizcap%40redhat.com
patch subject: [PATCH v2 02/11] mm: introduce pgtable_has_pmd_leaves()
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20260210/202602101556.msl493OX-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260210/202602101556.msl493OX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602101556.msl493OX-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: init_arch_has_pmd_leaves
   >>> referenced by main.c
   >>>               init/main.o:(start_kernel) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

