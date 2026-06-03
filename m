Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0881DCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 16:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66C996B00BA; Wed,  3 Jun 2026 12:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643C56B00BB; Wed,  3 Jun 2026 12:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5801F6B00BC; Wed,  3 Jun 2026 12:59:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 457636B00BA
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:59:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BBDF2140345
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:59:51 +0000 (UTC)
X-FDA: 84839213382.04.395EC2E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf06.hostedemail.com (Postfix) with ESMTP id 90FBA180004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:59:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mDD68vXb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780505989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=pI8bHrDXPHfs3+Igq6z2IVBGSW2GMBJXPEgrc8qFhhU=;
	b=X7TphAbP5RDkbcvO032AgJRx8vT8eHjP/ntZ2M9LAvmP2BrpBBbP5V23M9LhAvSWHEvram
	QTYFtPxnnAdavQ8GGqHNRmbUSEU/6iej9xlmiA+5NRkeX0FjOUhMghAny/tIwdk7YdMIOu
	tGjSRPo3hAizW8gaCxfnyKJVGFkMqsE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mDD68vXb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780505989;
	b=Xlug9wupS5m6jSEU9Hi1ihNPpE21uxNlksb88RHhQH/wQbpKZqzejOiBJAgfaL5ru4lrF9
	bMcz4L51Z0i+gca60utHhp4AYIo47uUmAib6xqZwNAM/mY5Ur4Zq0WRNMs+PkYgkHI2qlv
	faFKIsEowXwfh5lJid/kMj2FUyUmczs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780505990; x=1812041990;
  h=date:from:to:cc:subject:message-id;
  bh=v386T1vsDDAAs5Ni3Z2/P9ic1iWO3kLaIa5oGNiIo20=;
  b=mDD68vXbqE8T8l/d2UtSTCG20CFj2toCndV2m55GXJTGnVhYeDM1RsJo
   TAhHDzal9lWSsUwfJOW+sa5TcMmJq1qrz7Kdxk2mCHmJd3atWtTnuSdcc
   L5e770HuUKLeLfrt38OCZ0FGVV88Qem9Cq1Ckro6yLTuoiLrtZ5jWHUci
   XujIPtKX/v61p1xslxVjxE28aTUMDsEKX7+foJJ9qlDS4x05z8TXkp3A8
   qDNAnKXaMWNetTwYQtqycoySP/FeeoR1mEaHJac4JZqyAIZSpdi5+cS8z
   W9hWNudv3vBF493j/x+y7rw6Q+4soWaRORggnNzuo7IZK7nQbUXTFfJBE
   Q==;
X-CSE-ConnectionGUID: /4VRWf5qSNKwtrRZQAUm0g==
X-CSE-MsgGUID: UPhQgkC6TS+lYyzvzYWjhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11806"; a="81450238"
X-IronPort-AV: E=Sophos;i="6.24,185,1774335600"; 
   d="scan'208";a="81450238"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2026 09:59:48 -0700
X-CSE-ConnectionGUID: O1ru58sdTP+PktzFs6O6UA==
X-CSE-MsgGUID: 954JLIGuQo2vqCBVXId5GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,185,1774335600"; 
   d="scan'208";a="239819328"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 03 Jun 2026 09:59:46 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wUowQ-00000000Dg6-46x4;
	Wed, 03 Jun 2026 16:59:43 +0000
Date: Thu, 04 Jun 2026 00:58:58 +0800
From: kernel test robot <lkp@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Nathan Chancellor <nathan@kernel.org>
Subject: [linux-next:master 9857/10263]
 include/linux/property.h:226:undefined reference to `devm_clk_hw_register'
Message-ID: <202606040044.XTS61C9j-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: z8bnhf4j8w7bdzf5g1iewo3et9tbko3s
X-Rspamd-Queue-Id: 90FBA180004
X-HE-Tag: 1780505989-583740
X-HE-Meta: U2FsdGVkX1+9zZJKPMjk6NzGsTjFCryM6PIFHxPb0EyxE3tPznwfCMzJm1cGnHiEh73zjpZCpxRqwgqHxw0WYSOS7YXjmJYOyHEX+S7u4xLea9FrFA9wGZoVc0Ic5fNdATMXO1axoYX0Esoz7EgclhV+MqtKEw1F4m/dhWsmOWM17WskVsc4k2Q0991pRE+osEflK2CXK3YlGO6PZJ8GrJxTAZk5sy9siUsINzO/xSanZgK9doKIqE9kl82mUQKecJTzC5pXwEremo5cctIVhNgLIT/tWaWzGqYF+/iBKo6LD71oQdH80F993sNMLPOUa2pBM+6KmXj+REpgnaXArsCfnPFUZMDgAq5SnMatk5LNBzRLHgQGLuQqnOTWtcFT8uzjPxiJMT++qzjC7Ag9o7VbPhKH12euFXgbVgDfZTzdn6uMAybVUjeLNWT5QTfmBWP+awTZX4y0SlhgipFgCKGbHWMKw2HsxYOTlgGtp9ifETZJvh2P1wc1CYHPhikuhc91V9hy23ZoQz5hYsPmQj3fMsxG67Kkr7PL3dA7Vay7QOb5SOQBw4ZPOy68bpnuAR5L2cnb17FxdUPIoEVKYXzTj6M8MabFSY1X8mkxm4d/xi6yJV7IdMqqVrO56qaR/x5ejdJuoZ1cmzV31c6dVl6S4sckMeFiuvzf3Qvn/C2qporgynLaktk546A4eMpQfP7jze9/s3SAtwN3OoYp3d5RC2v3oAatWjp4ILfYh2XnzBJTXrGMdXljbHKF5RoBwduUvoj+2ilQQ+KHr+tHdrnzh49c/1Kf9HRLDYG25E1dP5HUd8+TjY7w96ZSgiI+/amstEyIos4jSDpBiBeEdc6pPwV3YxvJKv7uiPD+/0UcxSe9kXgOWp9tMhlE9ma1oUNyG0fi6hlpe0GhUCx1kqLdWzGbimNoEOzcy6kR+lBkpQyWmxnXsoHKJKoyvCH/IHB2aV0ln/fF4MCJDZ8
 /UM17k3Y
 2k437P2Az4KEvMjqxndJOekDt4JHGFuL7kYq5PrXYoMsKKjUaf+FZ+wBS16+VzEVL5WHHrVBKkTibVWFh4S+rPBzGdAo3Yo2JG9L8N41EP2x4lmg4YtvwfYXClZFuqsqPyeLDg/5L/Ia614jVBJn+Hl1FlH62rb4nAxshPGCx4NE2wUnDTgZ99Og4gEjS1ZygmNV5JvVfZ5knTCxoJ/6KTobfcqKqBpOq06FuzwEh6Oy6BFRd2vc0SbhdW6NKPirgXl0fzeGe6FyQ1ckWq2gUGYyPqX5UsEH6mkvHuWgbaEziBnv3Gvjj/wyX3qI7/2BZqkPlch5AgqDJVPOSH7K0znHfeSD3ukEmWYcJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Arnd,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   b7bee4ca5688e30ca50fbc87b1b8f7eed7006c17
commit: 0bf6bc1fe82a9307fa772e64c3adb89e98390f72 [9857/10263] err.h: use __always_inline on all error pointer helpers
config: sh-randconfig-001-20260603 (https://download.01.org/0day-ci/archive/20260604/202606040044.XTS61C9j-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260604/202606040044.XTS61C9j-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606040044.XTS61C9j-lkp@intel.com/

All errors (new ones prefixed by >>):

   sh4-linux-ld: drivers/media/i2c/tc358746.o: in function `fwnode_handle_put':
>> include/linux/property.h:226:(.text+0x1b04): undefined reference to `devm_clk_hw_register'
>> sh4-linux-ld: include/linux/property.h:226:(.text+0x1b0c): undefined reference to `devm_of_clk_add_hw_provider'
>> sh4-linux-ld: include/linux/property.h:226:(.text+0x1b10): undefined reference to `of_clk_hw_simple_get'


vim +226 include/linux/property.h

77fc5151f9c0e6 Jonathan Cameron  2024-02-17  215  
77fc5151f9c0e6 Jonathan Cameron  2024-02-17  216  /**
77fc5151f9c0e6 Jonathan Cameron  2024-02-17  217   * fwnode_handle_put - Drop reference to a device node
77fc5151f9c0e6 Jonathan Cameron  2024-02-17  218   * @fwnode: Pointer to the device node to drop the reference to.
77fc5151f9c0e6 Jonathan Cameron  2024-02-17  219   *
77fc5151f9c0e6 Jonathan Cameron  2024-02-17  220   * This has to be used when terminating device_for_each_child_node() iteration
77fc5151f9c0e6 Jonathan Cameron  2024-02-17  221   * with break or return to prevent stale device node references from being left
77fc5151f9c0e6 Jonathan Cameron  2024-02-17  222   * behind.
77fc5151f9c0e6 Jonathan Cameron  2024-02-17  223   */
77fc5151f9c0e6 Jonathan Cameron  2024-02-17  224  static inline void fwnode_handle_put(struct fwnode_handle *fwnode)
77fc5151f9c0e6 Jonathan Cameron  2024-02-17  225  {
77fc5151f9c0e6 Jonathan Cameron  2024-02-17 @226  	fwnode_call_void_op(fwnode, put);
77fc5151f9c0e6 Jonathan Cameron  2024-02-17  227  }
8a0662d9ed2968 Rafael J. Wysocki 2014-11-04  228  

:::::: The code at line 226 was first introduced by commit
:::::: 77fc5151f9c0e6068f1567b73d33e75a0c35333d device property: Move fwnode_handle_put() into property.h

:::::: TO: Jonathan Cameron <Jonathan.Cameron@huawei.com>
:::::: CC: Jonathan Cameron <Jonathan.Cameron@huawei.com>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

