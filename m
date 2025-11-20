Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 615F4CFA446
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 21:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6FB66B002B; Thu, 20 Nov 2025 16:36:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F9536B002C; Thu, 20 Nov 2025 16:36:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0AA6B002E; Thu, 20 Nov 2025 16:36:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77D4C6B002B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:36:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 236B213AA60
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:36:27 +0000 (UTC)
X-FDA: 84132294414.24.5D1D685
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf18.hostedemail.com (Postfix) with ESMTP id 946561C0011
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 21:36:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LaJBzhHJ;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763674585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6EFdADKaPdUmJFGC3bGJoIPWkCFx4ee0UN5G6pGUyLo=;
	b=Vb06vADj1AvD8T9JVg3iPsJYMTzmHwQvmTgKatSd8jAvMQNvogFKFsh0jbVxhS4n3L//ML
	zmxeHvPs9hh9RefQGqeKqv06ExOd3mqjuYQEU5SmTQ+CQg1+/gpxsnXBe9boZty6SMMFI0
	zOfv9nuhsHchcXl6GBgT0bhrC8irma4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LaJBzhHJ;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763674585; a=rsa-sha256;
	cv=none;
	b=okU/g8AaiNTn2ia2T1JTvel1fJUS9qWqBlPEtR4VIvr8/fMZCyTv8Jm43ugQszVZcFQePr
	LKaNB2VbSz2NlAoaciKmjhw2T80BfBzzW0iHmihSrX4X8MAJ1GO64GnaSExXchWEu5Ify9
	kG01hYJqdC2u9Scv60NxuTTDHjsjTiM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763674585; x=1795210585;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=DU7XGzoH3AZNUi+RrQ3xeIu8dOW4ZXL6yva3U5HYBaE=;
  b=LaJBzhHJ4U4BBJmiMx7/knwwzqwTmnZEdpU1aP8m/FgFn3kf5lPicCan
   JMTPmOshlSL13+Ze93w+EyLRgEsJzYgWiaEn+783859ZHKO6jGcayZcA+
   UL1lOH6D1erE7NTVIiSe/a6no9x/yiHuzWrVglUO1xDMF1llTC5umg9fe
   JMT/JAccUYu6kidYtfYpdcAcEoM8kQn9bBXwnLn/Gftgs7PhGGU938fAZ
   qKn6iKwJY2MynNDosoo5CZY/0+G1AM0WNaoFgfX3S82VGJQnB0fh5cwYE
   f7fglF6pnjFmzHS6+P7FOohFhnzUMnhLwOrdCPaiLfgWnz2dUDSE6b/fF
   Q==;
X-CSE-ConnectionGUID: dpkLH0KNQq24AwzADSkNFg==
X-CSE-MsgGUID: VB9l/cmoRlSIV754HUDnPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="76864701"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="76864701"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 13:36:24 -0800
X-CSE-ConnectionGUID: NeC6Lu3vSg6ak7hTcTip5g==
X-CSE-MsgGUID: D2K2LDidSsmNJb062+ajeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="191591618"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 20 Nov 2025 13:36:22 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vMCKB-0004bJ-33;
	Thu, 20 Nov 2025 21:36:19 +0000
Date: Fri, 21 Nov 2025 05:35:22 +0800
From: kernel test robot <lkp@intel.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 9912/10599]
 kernel/liveupdate/luo_session.c:392:86: sparse: sparse: Using plain integer
 as NULL pointer
Message-ID: <202511210513.ywQeN1k6-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 946561C0011
X-Stat-Signature: zgrss94p6snzazqccw8pkh76n3kpwri8
X-Rspam-User: 
X-HE-Tag: 1763674584-612125
X-HE-Meta: U2FsdGVkX196WBn/fUd6r58aePXoMFT543QigV9NYL72oWP/LjaB8T7B5PBd9DsX/Gp05NiJu3Sfwm9t6PJPfDUqHFM+fDIdhrfz5xBbiTuNSJeHcrAip1XwQcm7f9Ta0Ey52fnpPGlU6d2KXV45FbGsGPXyHjgn20ruqojZA/j7nrscqFeUglK0Vg488kzmoaCqGUZ8OifT4POyHH6bsoAOQ98KutRQbi5QQv5WTNgKH0UhjUusheFbfkOqsmNdX+tIxs4UmuJ2R/ETmiHL1O9q2V+TEuW9ghtKWNFmCzM5DsSvgtg8x2rQaAH9xb7Hiye8DIElhfvMPC4TOU8NwdwgDq3FBExzoOBkyA/wQnXumB5pINhXCCphhCEplCkQjDv884+eBYsrwemBKNmR6xhTX3i8z0+4uUBI/6vTe3IRe25CMtTTUGD77HMyLD2lcNqbXxYpdyZJBa5aozX4EFDotMkOIuA71K/608QtRTohIL27asCIe0U7n+tVMf8TBQyypy0ZdAt4hueA9EJUhsn8q0Af4TEb6ALL74hS7+I7oGrURWA5AUXcxzQKgq2V66WnUozBQLwKS5blm+3K3R2ELvETRSKaS8SUIic/0jpqB6p4Sf7EFT2rkZzda/IMzuJ6m9uJ3wW+FU32FkupT5Q+h+PoqjMy0GKZ9A/rrgGo1O6etiaRKRVK1vj50DHoi/GN8NjIzmvdEuyVk/hUyj/PtjMrLVdxLZSnzaNglR6qt0daVFfcCvaORNkNukut4mfamZdhhzSyBqOgqdxI5qzv8r7Xxq/gH1c9EFa9tCwCvHA2VbtIp84uuF3oF5KBu3w2lpzF0PrcoA4HkWnHbUMo7XS6icC6Y56iobnE6FnN8QtkarSVJ21nrn7q5cOBDFeEpMpXEOyz5qTfrURKvsyaDpeh+XPYeIj7AWLpI7njCNTi9txszw05SX65DOQOl8uX0rtetB3aX2wr52L
 L42dkw2I
 OeHS0dQCY8+fJmbI6E/9Fm9QkFbAkX+S2/3E2KZMky2fFtA2zP03DKgrRgegUb3KSzUAIGZ7InK56USlWDa1XmSY3eXXovkGzXZR7tpcuuyMU7zNXDxoW0M4v1b5RdbuWjneqZSxSlxp3koTksT0IUk8a/pYgKaRGVS5HNYn1hX8PDxdG7orLJQnmANJz95OqDP18U5+TKKY+bYHIoLcz1jzdV2LZmUOJmLWFSWD0boLp8Y3XWs4MuR1GnVaCJMYS+RZARsFL/69cnU58i6ZcxLHqV1YvFLPfcH/KgQfa2tiFGApjrpAh8jJaW0BjTflKUG/qXlKDzstzuX4txlZZ9mmmcBItSdjYQ/DzvCFpQPLWNi5TqXBi2vF8gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   88cbd8ac379cf5ce68b7efcfd4d1484a6871ee0b
commit: f485f57c35af5b8c2a243dfc39ee171673484915 [9912/10599] liveupdate: luo_session: add sessions support
config: x86_64-randconfig-121-20251120 (https://download.01.org/0day-ci/archive/20251121/202511210513.ywQeN1k6-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251121/202511210513.ywQeN1k6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511210513.ywQeN1k6-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> kernel/liveupdate/luo_session.c:392:86: sparse: sparse: Using plain integer as NULL pointer

vim +392 kernel/liveupdate/luo_session.c

   357	
   358	int luo_session_deserialize(void)
   359	{
   360		struct luo_session_header *sh = &luo_session_global.incoming;
   361		int err;
   362	
   363		if (luo_session_is_deserialized())
   364			return 0;
   365	
   366		luo_session_global.deserialized = true;
   367		if (!sh->active) {
   368			INIT_LIST_HEAD(&sh->list);
   369			init_rwsem(&sh->rwsem);
   370			return 0;
   371		}
   372	
   373		for (int i = 0; i < sh->header_ser->count; i++) {
   374			struct luo_session *session;
   375	
   376			session = luo_session_alloc(sh->ser[i].name);
   377			if (IS_ERR(session)) {
   378				pr_warn("Failed to allocate session [%s] during deserialization %pe\n",
   379					sh->ser[i].name, session);
   380				return PTR_ERR(session);
   381			}
   382	
   383			err = luo_session_insert(sh, session);
   384			if (err) {
   385				luo_session_free(session);
   386				pr_warn("Failed to insert session [%s] %pe\n",
   387					session->name, ERR_PTR(err));
   388				return err;
   389			}
   390	
   391			session->count = sh->ser[i].count;
 > 392			session->files = sh->ser[i].files ? phys_to_virt(sh->ser[i].files) : 0;
   393			session->pgcnt = sh->ser[i].pgcnt;
   394		}
   395	
   396		kho_restore_free(sh->header_ser);
   397		sh->header_ser = NULL;
   398		sh->ser = NULL;
   399	
   400		return 0;
   401	}
   402	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

