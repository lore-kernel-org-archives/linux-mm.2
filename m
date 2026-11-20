Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E45DD606A326
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CO8z6D2+
Received: by kanga.kvack.org (Postfix)
	id CAEEE6B05ED; Thu, 19 Nov 2026 23:21:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87456B0716; Thu, 19 Nov 2026 23:21:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9D236B0642; Thu, 19 Nov 2026 23:21:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 995F16B075E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:21:38 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3878B40CEE
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:21:38 +0000 (UTC)
X-FDA: 85454198676.16.18453B1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id 532D71C0004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:21:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CO8z6D2+;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795148496;
	b=BQ5lKDsGcgcEJcZgXbHdgKVNT0e9OBhPHb/Dm4nWEn7BCmvOthKGOjrXDkd4E9NpnbqgFk
	mCJ6m8iLVFxSxfZ6UozP8ANd5e6QAw/h5SVOD/ZcNuNU9V8STtR7UpqY1+pBfuFAGlPdmJ
	7ro/D24+Ikqwh+8Plxj7ijOLW4gA1/A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795148496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aCF/9QsXGxPiuVfa9izWAY1bS5suwF+J5Gv8PYcgibE=;
	b=We51rjlyaXm3vkLpIFUIr8ro70elbJXUIag5YNZRpJOf+7+N72qck/Ycx1Gczi8Z+7z64Z
	idkq4VKGAaSaLvYYE/fYqQvlhjK5C+egvdtHyNUg6z2LOlqoY0diUJydKr31C/sbEUxwNj
	60ivSpC5oVZJS6jEziuuHFW8RdkzgZ8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CO8z6D2+;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795148496; x=1826684496;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hYIJ0a2DlFsoUIkgJ8frMlcR8Pb107JbX1ud/3a5NwA=;
  b=CO8z6D2+Ptjpb1CvLzJBV7FXYpC/7tNAnVAkV3sz7P805xDMnPrJElkE
   xG2QEj9LpK3IwSJhGXRdMhLXgMTY5nVn0DCgJtG7vuiuxLpefUtV4OMza
   dssPWhY3LfF9QUasrBtn5QnZBJqnxwZh7ufEkHGpv3pA1al70o0xuENv1
   2MwYSTcKsTNfX5BYbtoo0BJCnRtQFpe95c2fvCuoAAtHBPSFeXmsFaF8O
   FD+o3fe9Mkg8DppsRmvd+Enz0o468BEXI+GkGT+qxGSVajuBVukLPi9cd
   ljRZi0fidmkF1vqE81Jx+lPTtJExaQ6CFnZf3yIquQNCJDQtLIe5CdDBf
   A==;
X-CSE-ConnectionGUID: uwvyxdNgRlWOHkdQQlzTbw==
X-CSE-MsgGUID: sWYCT7pVS/y+MIHphT8efQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="3941990"
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="3941990"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 20:21:34 -0800
X-CSE-ConnectionGUID: QSyDhMpXTSyTx5+CPSQzGg==
X-CSE-MsgGUID: VvpOMlxNQyuEqgIo9lpwfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,222,1787036400"; 
   d="scan'208";a="10692032"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 19 Nov 2026 20:21:27 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUG7n-00000001H3D-1HgV;
	Fri, 20 Nov 2026 04:21:23 +0000
Date: Fri, 20 Nov 2026 12:20:27 +0800
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
Message-ID: <202611201122.JwnDSHON-lkp@intel.com>
References: <20261118235645.2907908-1-alex@shazbot.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118235645.2907908-1-alex@shazbot.org>
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 532D71C0004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 8gog3y1gc85fszo4p6zict1h6eyyd89f
X-HE-Tag: 1795148495-270576
X-HE-Meta: U2FsdGVkX1/ejIHnRjdQgJo9hhUTNMhjiNp+mL3ogZ6s0cj6CwP1E4IhnDrpr9hFXbL0fvXaCUS6fYJTjoQll4fKLZg39hvbWu01tmJPcpMGqNmMNWyun6zclhzVkDnla7r578q3KkXIvs8/Ip3RspxcKmEPFVRFIgUebIohp8+Dphz5Ti1C/430WEFUnP3kprW5lNES5AErLsvZVQMNxktrxrBY70l6rcyNS10rE18kZ6P2+ZwtUSU+8xs+rzbEPlPukQdnJzpg4vBqfbzCSJRexwWnlRY02KzLQRQovZhuYvlLvpSlLe+FrFEwanIMB3aKwMz4FW20ixP9/TPgc7uZhKdnioQpiEEb+9NnzKAf+eYJHHdSLkTpmLoplxFePgR8hhJS/qB3jckEVaO5lB5HQR1r7oYaku5EY19pFzTGdxIFYdeXoh4V2wLbV6bjSx3srfiAKZOx/MOcZASJvfPXuEwSYXfyQLmv61vD5FPUTeRjin3mL+TCTXveXRD8/6hYOhr+QxNzRmrXwNuqO9ol/aIIIekz4H1gRZ880lmkOYQwXqK4vBLTti3ZwKq65VF/RShsZmtGDOzAIhbQBP+k9ZZcqpNUn++JhnVD/CkdgJaCs4hS1KqAEeDPRR3ggKdp2+hXC5roWqRvHPA8KOd0ZM8d7YLPsWFZX4abrITB7Ge+OSKTzKBESgR2n5Yt6PpCAzn1hZRyLZKwz46EZuHL+GuB1y42z/HOzFBplonFSdNu0I5Fng7C8m7ESp07ZRSY4g7+hZ1GixSDMCxxaug48aIy+lPoXfwKqupt+Y5O4zIU6gXgGqkYckHmCtM9QoK09bhWl1SwGkvbMK/RYD4VD7wBQFRoCvUr8YYyjkqzxVcs1FEfiVLNaX8w5odo6+syR02Vpq3yaJSS0t47w1LyBn69jGOqjTqvtvdE5JgHHip6Or0XLqJwLVRpSo8QpBHH0ps9xyjofLCWJWI
 J6bOACOp
 rWE3wCGHBXXmgdP9y+AO0bB3NGJxVqZ5XW24SSJghZoED+owjU/8UXM0j8OAMh1IpIekGdCQSkxsqHmM932OTktKAt6jE+vgaa2E/ikjxIUCJRkOzN8RAyoLWrK0qCmb2NYyQH67tOf/u/UTjlzUQ+VK4xhMycUmF/Rb3cJzNGDPWoIRrBPBLxU5PmTfhrt0rbxlZoaJMXo74vUXndOvLswEuVu7OtDQHtTC4CUKrE0LT6XMvH38DhuslBxZCX2hoKn2yBjfXRYyqwRzy6kvOaAba6uyZfkY8gINp6xrFzA5VstAR+y3DvNmhIoM6y1T5N8IpIuVdwKSQ9PimDJTRqCTPMqDdPsCafE40RkyPDNKa7u3aqT9wuxA1O1i3QQDeBuIe21g+tpLxiY0V4o9no0ZkCSPKTylvRYVGt3jZuv8V4zHiyiuk8FcQWU4LE5ltuh3fOQr7xnC6hPMfXQ2sFae6D9OYy+Uvm+jWP+i8oijB/8RQpzysqPwNfaC+8unLZdx7sO7C/1zdkHwTstxfxAdVVnvvEF3aFFtYQRBEGgjvcOGI+pIYl4YYEA6dGtGWjHOtmybfLBmZM/6rEKNVZs/XVsMjZu6N9fXZqg97K5ApyLNoWsn9WKEnwIHv7kKDrxl1hp6hyP/2yTB+dUO7ipjneH2asvJEOrW1OdBBlhjbrQsAC+uVZqSs8Q==
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
[also build test ERROR on pci/for-linus linus/master v7.4-rc3 next-20261116]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alex-Williamson/PCI-Allow-untainted-driver_override-for-PCI-stub-drivers/20261118-165643
base:   https://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git next
patch link:    https://lore.kernel.org/r/20261118235645.2907908-1-alex%40shazbot.org
patch subject: [PATCH] PCI: Allow untainted driver_override for PCI stub drivers
config: i386-buildonly-randconfig-1003-20261120 (https://download.01.org/0day-ci/archive/20261120/202611201122.JwnDSHON-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261120/202611201122.JwnDSHON-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611201122.JwnDSHON-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/pci/pci-pf-stub.c:39:10: error: field designator 'support_driver_override' does not refer to any field in type 'struct device_driver'
      39 |         .driver.support_driver_override = true,
         |         ~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +39 drivers/pci/pci-pf-stub.c

    33	
    34	static struct pci_driver pf_stub_driver = {
    35		.name			= "pci-pf-stub",
    36		.id_table		= pci_pf_stub_whitelist,
    37		.probe			= pci_pf_stub_probe,
    38		.sriov_configure	= pci_sriov_configure_simple,
  > 39		.driver.support_driver_override = true,
    40	};
    41	module_pci_driver(pf_stub_driver);
    42	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

