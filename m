Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A2B6606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 11:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=G6FQ70cc
Received: by kanga.kvack.org (Postfix)
	id 668C66B00EF; Sun, 22 Nov 2026 06:57:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 619546B05B0; Sun, 22 Nov 2026 06:57:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5321B6B05B1; Sun, 22 Nov 2026 06:57:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 355666B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 06:57:13 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BC3CC1A0697
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:57:12 +0000 (UTC)
X-FDA: 85462604304.13.20D6487
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf05.hostedemail.com (Postfix) with ESMTP id 56FCD100003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:57:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G6FQ70cc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795348631;
	b=2EpgG6Sv9+TDsGV86X4bVopz7WOKh9MVdnQNlOBr+AnBg1brTeSsE9hs7onZWdeNYYlU4+
	DhrW0VilV+l0p1kp1doeqMk5cRv86lrLb9kLeWtpruFjAyS8C2jbx6LlmHOXfq2c2GBCS6
	uT8k7WcqsGKf9hiZv/cUsMkZSat3u5k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795348631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=YPCAfZkl/VqU6hRR+iJpGXoDbiuH3r0An+aBhqpsDF8=;
	b=jQjL4mpOjvDVaMUEOlpxWMgVHl1XzSf8J1gWjYK/KoXoIzz3SoJdWeW/kL1dNn5i/PzuhF
	9IcvcabxhgotWgSOAXeGpnQ/75uvUzEO6Wq3dW8SQWN7XT1vuFoEYUeVuxeRBUxadaek3L
	35l8XIDy1x4ZmOicy8hJTpjE9mDTZzk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G6FQ70cc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795348630; x=1826884630;
  h=date:from:to:cc:subject:message-id;
  bh=o3O/KsOG+UIEshke3Si7D9+gwU4DTYejRXg7r0bbisw=;
  b=G6FQ70cct48FigfGdcGmrnYB3oOW2tjqkWIfJuHX+KeGPQ2Ez2ubb1qI
   Gt0Iwo9yWlTDCV+YoZ9AvVad8ui2mZGhKOcs4538dF+EnNmeNqL2X5ZW1
   cz2UTcbUbfA981HSElsI1TPorm3T6djQvivT5q8j+q/U3ffEcBIYzYgmE
   6xPPfjVZS0h4uyMhUFpvSSmSiPSNy56pGpbCNe5229mRB/pqJz6zJwqj2
   C+9VhT2BG64Iu6TeZ4cDfRg+GrZW0l22sklrEn+W2jm4lzaKx/rh8hAgf
   qGXddMiRDGwIPrZiAW3oiK+waC1MQ9/qxAORjDTTrKPqQCy9R8Dkpn9Ef
   g==;
X-CSE-ConnectionGUID: g+N7AUVNTi6qafLc3v4BBA==
X-CSE-MsgGUID: GMmSqzHUROm8KO4mMQfwPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11973"; a="4213152"
X-IronPort-AV: E=Sophos;i="6.27,226,1787036400"; 
   d="scan'208";a="4213152"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2026 03:57:08 -0800
X-CSE-ConnectionGUID: To+Sy5S2TvaFQ6iiUSGWHw==
X-CSE-MsgGUID: 3J9S7/buSiS8O/iAML/vCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,226,1787036400"; 
   d="scan'208";a="12891424"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa011.fm.intel.com with ESMTP; 22 Nov 2026 03:57:06 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xV6Br-000000004YH-2obF;
	Sun, 22 Nov 2026 11:57:03 +0000
Date: Sun, 22 Nov 2026 12:56:19 +0100
From: kernel test robot <lkp@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Andy Shevchenko <andriy.shevchenko@intel.com>
Subject: __efistub_cmdline.c:undefined reference to
 `__efistub___ashldi3'
Message-ID: <20261122125352.gAcg5yLx-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 56FCD100003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3qmu8exbiq7daur34xtxcpdafe4cz8is
X-HE-Tag: 1795348629-459197
X-HE-Meta: U2FsdGVkX1+dSwPkO9h2+5Uz/nnQFZBsWXS266mTolNNDtZC489Vff089/q4p8033aq5O3I3nUHYn07R52zEdfqy+11g8+zY4jHmc1cLi0NE7oBfxeoStpuoc9nWsZRxmQF9CGxYGZ5LQ/f3eFba3PTTYZIPnd8G/SzX5nkDc9eK+Py2/fo79exi6SD8A9hrDAR3ZbT+ImsRMXBUMhRInOeINqksKYa2Wbo9oH7ur4+aR/kpfxD81Jebhi/D8OBrBeu+EktfvNH8s6vfEZs6YFDnRH29tQ/0TfIpIhk09+o8pFdQp0HW864zJhkAREppsjEyzw57+89Z+8gkjBfmkJmaR4lhC33rdjQTZy8BF5Z9j/UxkBUyA/oVV6JY1QsZx/f5wiQdD1AjYushZcaebNrUAGMbM81S2tVDCcZjvdQjpNUKIAV5T6p05bjAek19cGZvRkDwTWlb1EadZB1DUo4T/qD98hUhF4Ur2oX8pXToI+HJVrfBaTIGmd2gsvE1IjtLHwjV4AGSI/Z9W3TZBw2g3Wl3VN4lEDA91qJXxrCsNfy+1YpBFABTzAsVJeHhtutFecrqfdhDgfxCc/lq+cvzbZYSmhpU6JxOiIpoYc7Q1lcp6hdvodvg+a+zyhYcqhFPqm5jm9CXVN4QXY5D7Dwp4rPgPHjefaf0TJ540SyGp6K2Cv5JexuTB+ln91AG7LR52bz5LsCpgbZgNuYPysP7cJeD27KqwaDsKHDRTqiBqQbt7BkzgqVYMvwlT0pgMY57QXsX1lLNJ77yMCdV3vo7tqiZNeo/xq3oQMSBBRRnKSdLSmsZD9B07ZVvF2iDMGnJ12a87IsiPdy3FOuQgk6DBqxzxfir8FlPqPJV8N++YMo4CwNmAEP+TSw33CjGy7PFQptqlX8vrpwhZK+x4DvIrIRwCoPVozHIMvwMehh4foTanB/uRuzUgd4IKdcw2m7B5CAhYTva/5tvpxf
 l3LbBQlp
 aO29nXc0dtgF5XiKRat4v+BcGFnG6fvtxEvN0Wg5kv/yw3zW53Z3GsRRnj7WU7IEMMkjrufSLp+fiTP6SWBiFGcky8Xh/OnTbyHwdWgXYmbFGF37eJZqcBXZzcxE+NSF/7y2gQgM8nMLaAxr/+vEHXKKmB7XxxNZBHCf/EFsopyIA35/j8NBiFEjmki940zk38vrhavNaDPZeNxMGQC/ZzeP6sZUMUSMZZjc46tjwJQ/Krfv1xnExkc0+uxvMo968GkW7hLmiyW7ygVUco+LCubODvUeoqK8KfVlk0j0xVfqRGaXE7englp/xlIHNciYUr0zOy22I4xGNVt3ZZaVbBtH9+sJy6BQoVu5fZT86pnXZQq1S1XoAQknml2Jt9C6HRhqoc1QW/jx1YpJfEliYG0wrblTrVs4YWzehgMxt6f1P8jC3w4dQC7/yoIxZYabE/k4Ysj6z7eGcY91OAOxb3PrJXQ8K8jKjmTr0rmgrL9jzbxk7MyeamefvKRGjvAi9qV2SUjIaMOJk4BNrDfe6wY08HBCnhebO3ine+y2qgtDWbPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Hi Dmitry,

FYI, the error/warning still remains.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   4843f6873f7c4835e62f2c73ba0fd538e57a2f22
commit: 9a4580db6e9f83428813f671a79486469684069f lib: fix memparse() to handle overflow
date:   6 months ago
config: loongarch-randconfig-r2100-20261122 (https://download.01.org/0day-ci/archive/20261122/20261122125352.gAcg5yLx-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261122/20261122125352.gAcg5yLx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: 9a4580db6e9f ("lib: fix memparse() to handle overflow")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261122125352.gAcg5yLx-lkp@intel.com/

All errors (new ones prefixed by >>):

   loongarch64-linux-ld: ./drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L47':
>> __efistub_cmdline.c:(.init.text+0x258): undefined reference to `__efistub___ashldi3'
>> loongarch64-linux-ld: __efistub_cmdline.c:(.init.text+0x268): undefined reference to `__efistub___lshrdi3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

