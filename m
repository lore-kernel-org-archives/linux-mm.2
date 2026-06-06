Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D85D5CD8C90
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 05:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4856B0005; Sat,  6 Jun 2026 01:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985126B008A; Sat,  6 Jun 2026 01:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89B366B008C; Sat,  6 Jun 2026 01:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 785326B0005
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 01:53:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 022A71403C0
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 05:53:41 +0000 (UTC)
X-FDA: 84848421084.23.BCBB44B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf20.hostedemail.com (Postfix) with ESMTP id D20C81C0002
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 05:53:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N0sZVdyL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780725220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=LPq1Fk40D/LuuxOKYpGBCxzh/CDNQg/kGxL8TNTD8FY=;
	b=eDbraQ8yGlvzhrKwhKj+xtutT6kMQVuc7hlAEU18pXcpnRLHLND2pZIK31aAoTL6Uq3lzZ
	GteSpk3TMS55z/oTrdrlBFQ+YPYedlLDTgVrDLx86CvAVZiQiN9Gw/hJLppoxfwRXkuvFC
	pS4zSns09LA/3308iT3coyndr7oyQAk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N0sZVdyL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780725220;
	b=ei/54j5qWGO2nN+q+p5AMF/UfmatG1xJdoF22AO64W/pwUaCP6WO3VKzwv7aI9nIrmow+I
	zVPAvS4jLueFJm/Ilp3ngTS1h0bYX9mmg4QH1Tjw3OgpfHMpP+967UwqZ4klc+Tr1t4Zza
	JBu6vzhbZhL2c4/y1ix92fRqOZ+twuw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780725219; x=1812261219;
  h=date:from:to:cc:subject:message-id;
  bh=gvOohcgxP+DgF2jMC5ghswmVcORSlUZ+yR/rp0dmeFg=;
  b=N0sZVdyLULNEV1isH4FodOevPCjQQ9NfV1WfGQDMkZkWNe3Ly8JKouZu
   rbr65CRyiKqbh3tZ7yjM6HRYZtlfRvRPaAOLRaePHghtxVarYzx58x07X
   8oaH3nLNqFRLjxkJvdWRHBbkDgK7SIfG2blRBd7N6w686cStCeybFU6ED
   EE2UQN2PwQhpS49RJRfhVKlLK/pwCWnrEGDBZ7KGFGcTc2LyfmWvsXCWq
   43j5nMD+ArPFZ4nj70IP4FtOXUogogDlF+PBLxrlk7ZE5yeIPoozPLB5M
   rygytvy21VnOmKxngAJmzBdeg4S89KBSfWKOq9Rthnxo6ICBghoUeXPjJ
   A==;
X-CSE-ConnectionGUID: SlGwZ8mfSCSofscXia6zBw==
X-CSE-MsgGUID: N398oj6LQxKxZHam1XtEIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11808"; a="85438403"
X-IronPort-AV: E=Sophos;i="6.24,190,1774335600"; 
   d="scan'208";a="85438403"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2026 22:53:37 -0700
X-CSE-ConnectionGUID: nwbau5vRS361H7fruU7Eqw==
X-CSE-MsgGUID: SL2LoenLQ4CY8t3f51RRNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,190,1774335600"; 
   d="scan'208";a="242563207"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 05 Jun 2026 22:53:28 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wVjyH-00000000GmI-1GPu;
	Sat, 06 Jun 2026 05:53:25 +0000
Date: Sat, 06 Jun 2026 13:52:54 +0800
From: kernel test robot <lkp@intel.com>
To: Hrushikesh Salunke <hsalunke@amd.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 8165/11755] mm/page_alloc.o: error:
 objtool: get_page_from_freelist+0x1584: unknown CFA base reg -1
Message-ID: <202606061342.et6zQdGM-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: D20C81C0002
X-Rspam-User: 
X-Stat-Signature: tkj9mry1pspy6t3apykct7nga4x4r9ub
X-Rspamd-Server: rspam09
X-HE-Tag: 1780725218-441984
X-HE-Meta: U2FsdGVkX1/yBDtyZBbkZgh7jwlDa8W/t0KjGHLtRpR9oPLatc291Jypvn0/JflhWRj8ui7FLu1u+QLwCtPSH7mzTGJUuvUXGEgxdk23BkJxI283DvHPwAVpfsml1Fe9W4JwdkCpBzlN7JexThQSPDuN2D2oAgKTtKXEMkhOuMo99uxAcljIlvqDpI1o12xb4SIXuoc8tVKV3e1+fWmaiZcCsR3B3jNvThrJ8UyplrCAIm7hVooTExKFoWF55U/wGz/Q/MAVDNEvf7m+0TB2jsq6eq88dbM6cQPW0XH/D911AFAoCbPgDvAoS4YMQQNHJKcE0ivcFSsdXTEXfz4sXEpAZKZ9gjA95gnldhTCZ2jJU1ecElAg2AIYYgvIcd9VUwbL16hMFYC5erSON/wHDpBzsvyngmdfBIgTe5iGDhAtQCgYnd7STiTigIAy+QEKGhCrxHg/yD08P87ZBFifmAPo6Kd6Vk+AWZVuSdK7VO9jmPualVxKEhe0OUaadIgTwC8rWv+ewU5vZRUlx88COYZ/8gknFhS/v2AyvS0WlssDYJ3IPdhlnu+Icrc1FJxjysltPLYBILDWdii0FppqEJH7yYQwbrS0lDbNPpU+KAJiu7DWQ0rBTRfnfRvWFnG06vOMkPy/nysoaFMLeTAlRCNpxt9PPRgjjS3Ur8c4uINNSLVkXS4QIA34s4EgHg2fiyPkV5N0mdyWe75JORA3r8knT5DK1VnBlvZZYqFAO8pZwYOuPB/Ap9B0FjytD7kx4NNa219imoCEtVFAyc9Q/78ncMbdGSe/BZfh6VrFNqiKYLsKOLhRPmO77lP8IHiFRtz9abboo/kWmzRBzPuYOzZNmOZmZ/Vt2l0NpXPM9apPDdGAU9E120BNg4uxsbXAj9VVt/ctAxtiPXbSAdGN9dV+w5tTNUGVKQyLTZf9uLFRhPZY+R68rFPk2kMm2bKE3uTQ034xOSdjnWM1je6
 uImqElwL
 Fw2mPICmCWx92fJYTYa4D/TEXYR5tYW0Fqx9H/fkVDYZPlueS5SG8/sVt4DWxlj5ZDzPPmmA/uMBeUBC1ws14qZte66NB2yOKGP9l7z+FOwdBK4KLTmR1AeQf/xzsjw/6hDix6dS/qVboL/zQRsbzorVoywVYZV1Fz4GTq2jadhZPzJ3kYFOnG8iC0VHfIwzNky6YBOGG3a8oMTF+A+vb0lpwtIB5SkNxI7XcrnQdsnf1ljEMjui8lchXNqbqrv5EtO7RUwLnlnq9hgXAqnxf0OgAThQRRfWVlHDIma3AyNVVzXYBp8jLeL/6kNFts6g9VyZQOP2aM7k2TKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   b7bee4ca5688e30ca50fbc87b1b8f7eed7006c17
commit: b001cf7d16dd18f14bd372a8018ecbf48197289d [8165/11755] mm/page_alloc: replace kernel_init_pages() with batch page clearing
config: x86_64-buildonly-randconfig-001-20260606 (https://download.01.org/0day-ci/archive/20260606/202606061342.et6zQdGM-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260606/202606061342.et6zQdGM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606061342.et6zQdGM-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

>> mm/page_alloc.o: warning: objtool: get_page_from_freelist+0x1586: undefined stack state
>> mm/page_alloc.o: error: objtool: get_page_from_freelist+0x1584: unknown CFA base reg -1

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

