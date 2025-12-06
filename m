Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54603D3ABF6
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 05:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E87C6B0354; Sat,  6 Dec 2025 00:08:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59A736B0355; Sat,  6 Dec 2025 00:08:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AFA26B0356; Sat,  6 Dec 2025 00:08:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9796B0354
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 00:08:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8C808A43F
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 05:08:45 +0000 (UTC)
X-FDA: 84187866210.09.2592B60
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1EF36180013
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 05:08:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m1ZymLkg;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764997723; a=rsa-sha256;
	cv=none;
	b=3quYkikNDAFhcPETXhbwScWOz4IwYjwHFgRz1wkcCY4NzKT4Sw3eV+uChum44/BC6IuLn5
	HZhvPJh+CuUXEnse2lp/sxsNwJ8pQLGL7pPYooeh3dih7L8SW6qTHyM71gmp962/yPfOOb
	f5LaWMSOOBZyQTn6U8ueYgXWMboncGs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m1ZymLkg;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764997723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dsvMPL8bHwXrDhvzjoduEfThJkr2XfBHkUndaLCSWHM=;
	b=ZAyIih2Kf5uYrmJPN660Lu+ET/TYukozs8LHUG67Dk2pgqI5/WrSfRIclVeaR+Uf8/vCIA
	nsKE0oHxivfIk+so6b/J+UyjXbTYVcf7vALQ/BdW2zW3F2RHA51m6To6pghpZq8C1RZWnO
	lKMDc63qVhxqrpPebf+dsgLss69CLmo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764997724; x=1796533724;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i4eZbh90/dXtI+RO+dqTkK2XlXBfTjz0i75FE3jkEPI=;
  b=m1ZymLkg9c+Cstz9duWEGnJ/0MUWPK2+rMkiq1EZDYivSEBiD11uoWtC
   l8h41mL0c7zICGuxlOT6gMDBpFdBAI60tz84YX1vvvAO6PysX16HNTHrv
   RpTGGRswe9ncItecOPYCUkfHmWLRQDEJAQN7t9UEWHlyt64JoMAl6n+6W
   ogdyZJelr2zSQMkJOJcSsGxKgueHc3U8BeLThDeJR7Pc13ZQu/5d5WFAs
   6umLDescJUpjmJqZEBkduPPGaj3AexN1uU+V6bxRiBgrrUrFL6gP/05LO
   TfRaKtTf1WL0pUtOBpq9edjmH1YXabXFtdApi51TCQVoFfH3gnk5fNk5d
   g==;
X-CSE-ConnectionGUID: nXjFb8ttQ6ioRfMlizGlRw==
X-CSE-MsgGUID: 2YrRr/gKQZeF465AMuxp1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11633"; a="78495333"
X-IronPort-AV: E=Sophos;i="6.20,254,1758610800"; 
   d="scan'208";a="78495333"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 21:08:42 -0800
X-CSE-ConnectionGUID: I4OZjqtfTXK8E7qqm+r7kg==
X-CSE-MsgGUID: 7J5EECH7QGWKBstfAoTTMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,254,1758610800"; 
   d="scan'208";a="199911933"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 05 Dec 2025 21:08:39 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vRkX6-00000000Fs9-3wHJ;
	Sat, 06 Dec 2025 05:08:36 +0000
Date: Sat, 6 Dec 2025 13:08:09 +0800
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, kent.overstreet@linux.dev,
	vbabka@suse.cz, harry.yoo@oracle.com, da.gomez@kernel.org,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 1/1] alloc_tag: skip rcu barrier on module unload if
 profiling was not enabled
Message-ID: <202512061207.7zufoIcC-lkp@intel.com>
References: <20251204220957.360838-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204220957.360838-1-surenb@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1EF36180013
X-Stat-Signature: hm7fdpk6pny1bc49xas1xdkbozt39q31
X-Rspam-User: 
X-HE-Tag: 1764997722-72085
X-HE-Meta: U2FsdGVkX1+Qmj63G0Amr3E+f09dY1j7SM4depOXlGpd91CpacUEu+1wlOgbro2c7vyc2402dgfxDeQiRNr6A6mTyKXONbtDK0IR/ro+tSUii94cL01XDBD4Rh0Yia/gEP5t/6NrICMCrbzqPWQA6oeaJK9bbT0CZkj+ntUiwBhZDV0jxhIZKlIU0Z3pSLW/R2lHvIQUqJd7hu3/rwIUtL7C20HE3DIMp3esRkikBS8uuUm0R2wI8G/gJmjYaDDTuPdsky7Z1ytVX4o1h4w6PnHOWrzJ3aFaACACExkjSAmoaLoszIrtHJPBPqNnw0P8DmPDeLgJIar2nxkjsAg5/LT/qbEutth7HqZfJgD7Q+e0296QuwbjRJNlvtmLvp0opP18Miema6iaPjjqt8cpvQ3vq8dNzTgvnHaHLewkZqdPGL/Q2V6pbKOp1zciRJbIcqh3fgsVmpbYfPP80g2HBUpVwGOVNPK+A5SX1JVEt18BUpHmcfg6s1FBt+mHx2idkPIf2Z+ZW4aXQBJFaZqhCYQBn1wX56gWYq/Jxhg632Se2WWfWnXWIEesMzmHN3Hn+B9mBCrCeorXl9WwgRtZ6kOUsPUk6ZvA1NBVjTBMSlE43S8uySd6sbE/ZDpB91KDqoDPZAd9pGpcPJtzhtQv2PbSPsSc973hGPVfUh+ILXidBkoRFpctvK2GCSv5XY+hLyJ8UZeyrtN5AdhtO86y2xWRL1Swdi5166tA40nUFHfF8sa5a1lUXD+ncik1Pw5gPn3MvtcmGgKrAaxEJFUOgKSukXT3UQiV7106rb5npXxpBymrWBdgNFqVp8+egLgzzVEtB6KfZ3zY54MAPgAziKyPQWS1HAvFWlfsxTPxKgXfl7Tatm/NrIwb+jxl8baLtP+mCe8Rj9vKprpgLsp2H1Nv2n5mjbpUFDdjg5m4DAqG9xAhQmihhtyUHcvymUXxZM0tQ0jaPFRxwhF+Het
 0S76OAf5
 5AXDPjde+gIKi3jqQOSYrIpiKdZPmo53K+hqD3h3/7VUzuaILo4bxq9BVpQAJYoPfs5NwM1smxi/nDbJpWo3WI+zVcCiDpwWgAks235ERC9Kf7MNy0jdmEMcpzxIp3Z5NW1tkTaSXLcE1+v5EEZOcuJ0WR1hMBHsKshL1yDMqtO0xYAiNRwyR0uOGHf5i+/zCekpX1yfZS+4NQ7wFG/31rLZ6o1Q4UlhkEcYXzEWDKzjeSY+2EtldTmIK04iH3obA/g7ggjkqwlERiUnvOYJZzvUmUSnf3w+iE//8lKYn/sc5p7knn5S+wRWPAnWtExLbKDEXIbdwAAITyfcHg2Lyqye7bZmu6A05bFcs9LkdZHgeYMJXZTVowM4/J+xg35t6ukMhN9nwb9G/Kk4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 3f43be96f919cc611dcb2a4e38dd464831f4513e]

url:    https://github.com/intel-lab-lkp/linux/commits/Suren-Baghdasaryan/alloc_tag-skip-rcu-barrier-on-module-unload-if-profiling-was-not-enabled/20251205-061310
base:   3f43be96f919cc611dcb2a4e38dd464831f4513e
patch link:    https://lore.kernel.org/r/20251204220957.360838-1-surenb%40google.com
patch subject: [PATCH 1/1] alloc_tag: skip rcu barrier on module unload if profiling was not enabled
config: parisc-randconfig-002-20251206 (https://download.01.org/0day-ci/archive/20251206/202512061207.7zufoIcC-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251206/202512061207.7zufoIcC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512061207.7zufoIcC-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> lib/codetag.c:37:13: warning: 'flush_rcu_on_module_unload' defined but not used [-Wunused-variable]
      37 | static bool flush_rcu_on_module_unload;
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/flush_rcu_on_module_unload +37 lib/codetag.c

    34	
    35	static DEFINE_MUTEX(codetag_lock);
    36	static LIST_HEAD(codetag_types);
  > 37	static bool flush_rcu_on_module_unload;
    38	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

