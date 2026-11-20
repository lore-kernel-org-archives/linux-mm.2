Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 233C1606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 06:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=W548s9JQ
Received: by kanga.kvack.org (Postfix)
	id 047C46B05B9; Fri, 20 Nov 2026 01:59:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3AE46B05BA; Fri, 20 Nov 2026 01:59:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28D96B05BB; Fri, 20 Nov 2026 01:59:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B1A356B05B9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:59:32 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8DEF240D4A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:59:30 +0000 (UTC)
X-FDA: 85454596500.22.DC8E6CA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf15.hostedemail.com (Postfix) with ESMTP id A72FEA0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:59:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W548s9JQ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795157968;
	b=BGlvlQq2ECbR+BShnd68gtPSP+5YItkMPlmiNbhtynMi75BUCeNW9g/VTA4w9NRTmVxT6w
	l26s+M4Nxm+PXTrGae1F2QVGX1/h7FuYfabO0K92Ftjouf/dXzIhj6f/LANH0XkAex5C5O
	SU3OozH67QHcUBcFdi/tArwOVIQnn/4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795157968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GqQKDW2mAXubWgPJoR5AXq1PFV8yqcFgiU2g7CuZ8IY=;
	b=eGKS0I2/O07X9/8hJ6lHG6G1k11DThdM0UGagmCv+tp0TYP3lEXoRiOvSBXPEVI+DQk0P4
	1QqcDTruJ9RBHdpX3Tr2Cb98yr0jxwMQqIl1Duv8ZOpWxl1jl5buwdA4ZCaLSVk2mlR1gT
	FlicskKYih+WEtRQPyXYynZ/oxqnTTk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W548s9JQ;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795157967; x=1826693967;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SnI+Dzdsr+rQqdwN9p1c4GpH9EILitFRJyMiNp8nR0I=;
  b=W548s9JQRxiUpMPVms4b6yKUhwKLRengopgpOYyl9GERssG9c0j2m8pX
   l460VQo18BesvDEA54nMexiM/OqYK3zT1Ym9X/M+ZoaWEer6BGrs4ELgX
   hjOj94dLYbTvB/jmDwfiomF/Czoi/9jwdUAvfOBMzx5Pw+alA6bHzAjik
   iB4ecIEz2kYo0LLAOAWGq9K6nYy/fLzE3O5+nQlASxijfrLClUdU8hyP7
   70xGT25E7LNRwoQzGBJtXDmkABsmwl94uOUe1BDfd5/rBTgdxq7rsFeak
   hNteqYJ7IG3Ft4/ckuExYVLjPjR+ZGWdz+zvwWLww5BmN2/cZ6oDZKlAe
   Q==;
X-CSE-ConnectionGUID: grA6go3uTguuIx8rAV3ZDA==
X-CSE-MsgGUID: 15DX8xLtTfako099ClLAUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="4071531"
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="4071531"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 22:59:25 -0800
X-CSE-ConnectionGUID: Gs41PpVETNiQ+MR09BIa5Q==
X-CSE-MsgGUID: qRKObIMLQoS+9yliyccTyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="12474588"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa011.fm.intel.com with ESMTP; 19 Nov 2026 22:59:20 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUIaZ-00000001HI3-2xJc;
	Fri, 20 Nov 2026 06:59:15 +0000
Date: Fri, 20 Nov 2026 14:58:40 +0800
From: kernel test robot <lkp@intel.com>
To: Alex Williamson <alex@shazbot.org>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Alex Williamson <alex@shazbot.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, Johan Hovold <johan@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Lechner <dlechner@baylibre.com>, Armin Wolf <W_Armin@gmx.de>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Marco Elver <elver@google.com>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Bradley Morgan <brads@mainlining.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Petr Mladek <pmladek@suse.com>,
	Pnina Feder <pnina.feder@mobileye.com>,
	Mete Durlu <meted@linux.ibm.com>
Subject: Re: [PATCH] PCI: Allow untainted driver_override for PCI stub drivers
Message-ID: <202611201442.3jFAppXk-lkp@intel.com>
References: <20261118235645.2907908-1-alex@shazbot.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118235645.2907908-1-alex@shazbot.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A72FEA0005
X-Stat-Signature: dzr88wfx854upeiyf8c6z9s9m4akixy1
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795157967-851369
X-HE-Meta: U2FsdGVkX1+XG10LctmViGlT3UoJLyLWo7eAcFrMAcKd6M5yn+8BM6EIMyzfSVB+FmAHFmd070IJAPd49HJ7hIpcotR/KeUBj3PBFUmUqT/xZvy+ujoqo6Pft+g6UqKpQ+nmfNocm4TMDLH5/iSk2sm78X9B8w6Fa7sQVpzdX0MRpnJAb9DA4ufQfxBCXPx1RdR0Xd00pV7y0WEMTXdrSPhtFPmkpMlWcTazqLUfNbJrtosrkVtZyPRKClMVVBtZME6tUY+banALpIiN+QZWmRj/1Nc6++3VvRJJEjYDQBgelT7mGsxBI0EfwpkpOxeTAJwT564CLdZV3ZrUphjnQxJl+4m7UAA1Gk7yEulk8UR+Mx92YjP/MdTaJqJFZ9s9AvGbOZHLaIDihrugKTjR8PH3k4lZcWi0jpTL6Yv3qxJHibLJKDinsilqW8E3/LFZ+dsU/7qpShkuGDO99v14BiuZ1EkYFmHHwTkPZL7J4nws3Y5M1Sn6S0H5M0G+us6mqS/8ZTyv5Z+wZkvTf1i3fYs70ZaCq3U4g9C13jFmKsfT75APsUGtLR3EiR8LFjCr7iTFrAd7zil3WnZCKFeFbpWmDi6LK94QzBLPV1T4swn2rWFk+6Q4TP+eVIzL8s08Lqs37Q/ErPI44MZJwbpLECcCxvpZ8zkXPE19K/1kUznKTcMLbo8xWHHsFHNJmHP+4Isk3fEg4bOxl0ma5Ao5hLTeeNNXoZeWyUvasx+CWb8aUQcC0pSLUX8drlqVeVB/qBwdAKslnGoJifIrU7qn3uQbZfsMILfRAQ6GtgLzmK7dcgncaPdWyFL+NnOPIFVZsQds0v1ZDJzGMR39FMfXLPoa9OvRjzKXRaRNyrLgBEm3Tzm6Cn6CY10kn9ZXI2PjesC2Ef46kwXZS6OgaCTV6WZAP0AYD3MZHQqfT1VmObNQEpFoeXMUaaPbEsTGnY6W5ryGut1MWCMNaRAS9j+
 zxkBZICv
 WUUDXDBXqjgaj/0zmsr9Y/O/M1pLaZQXHL89NcLvPEvwwD7BOKE9tB5YKVn4JG/ZU8ZOWGiVBCH1AdrsOkaJDK9gQoXjLlvRcqnwfhhPKO33xlHmgMc9ogQT31d6qAflmEvMnV/vi7y5dNrP4OMFQN6PSHexYlM7sgdR7u9TuFIxTjRZYKHjT36AsWs2B3I4UBgrLELsnonNU8mDhGL2tzxXoo49UzZk3Qq+kHw828VeyBrVYwqBMn5Lu4kQMgLsv3AVy7oRRvpQeLhEq6I4l6FpDvt7RV7ZjDXWxLtHcNQJCRHE/Tud0mrTf43qz3EoA6dxXnAKjcG0oGkFpWYKAx3krLmw+MPaeRLD+I+yjQuvrQ/Cjypy75O/91WWAGyxQBgiER4AVpKs63UgBdvzKv39T7Ciau4rt9MkrMAo5GUK3+oOSjNA4dtGo5vJ3/iZyXtDW33LpQ6dm0QpWVfRQKIXcd257j4cGERkYw4uoZpvKqHjSwMRC+fvD7apb7RPquM8u6iK3fVlP2OyBxhzh5oiA1/S+7FxvvqvOr0iAvsGot9E0LTI0xxnqQ+vlw6lHDsHnBlifPHdIIUvv8xq/5V/+76+e4NWUoksrqy8L2pldT8urEWV0+S4Kn5hjuRRJoLJnCB16t+fYm2z74Vm5vs9lhEpaO7CQZUt3qUCkyQn/Jv0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Alex,

kernel test robot noticed the following build errors:

[auto build test ERROR on pci/next]
[also build test ERROR on pci/for-linus linus/master v7.4-rc3 next-20261119]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alex-Williamson/PCI-Allow-untainted-driver_override-for-PCI-stub-drivers/20261118-165643
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git next
patch link:    https://lore.kernel.org/r/20261118235645.2907908-1-alex%40shazbot.org
patch subject: [PATCH] PCI: Allow untainted driver_override for PCI stub drivers
config: loongarch-randconfig-1000-20261120 (https://download.01.org/0day-ci/archive/20261120/202611201442.3jFAppXk-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261120/202611201442.3jFAppXk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611201442.3jFAppXk-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/pci/pci-stub.c:40:10: error: field designator 'support_driver_override' does not refer to any field in type 'struct device_driver'
      40 |         .driver.support_driver_override = true,
         |         ~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +40 drivers/pci/pci-stub.c

    34	
    35	static struct pci_driver stub_driver = {
    36		.name		= "pci-stub",
    37		.id_table	= NULL,	/* only dynamic id's */
    38		.probe		= pci_stub_probe,
    39		.driver_managed_dma = true,
  > 40		.driver.support_driver_override = true,
    41	};
    42	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

