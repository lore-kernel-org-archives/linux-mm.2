Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9363ACD37B2
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 21:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B5AF6B0088; Sun, 10 May 2026 17:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 266916B008A; Sun, 10 May 2026 17:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17D466B008C; Sun, 10 May 2026 17:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 077B96B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 17:40:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89917120510
	for <linux-mm@kvack.org>; Sun, 10 May 2026 21:40:55 +0000 (UTC)
X-FDA: 84752830470.02.1954F30
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf15.hostedemail.com (Postfix) with ESMTP id CCE8BA000B
	for <linux-mm@kvack.org>; Sun, 10 May 2026 21:40:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lvJtxW7j;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778449253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y5sVmWLTTGheKXEeZGVMUHvXK8wir1tOg3XgII41Kd4=;
	b=jXl0nP3KxUxbYahochapZ+eZ095lw7HNQn5IDon+l3H8ENQzMmca9lksr87Ujji2qdDQ++
	bbEj9Cx5ghBe1re/p3ogjst3WFBPQIrka9MMTS06QAvwQVQig4BOrIZESkjllX9AdsPseK
	scP1apRwDmAwv4pNxjrruSDXI6hiaKU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lvJtxW7j;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778449253; a=rsa-sha256;
	cv=none;
	b=tM8nDOVqXMzVVn9u2YiOy8tl9PX0kLDsaMGqFB3o2EYhCFy5yYeOjGoqD8vo0QE5lMnwD9
	HlZiGAtsfKTgAW1aCQDM6i4Gzi4ijg6577fDQ4Vu3LTNfltuhpZDNSVZBjRl15+RHsgXcm
	O1s9Izx52Esa+AM4El1lx2xRangjmIs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778449252; x=1809985252;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hXygK0G1nkNaf+vivvqESQJciIwrQ+dae5+fHbGeSio=;
  b=lvJtxW7jogY1sadswMcPh8/aYmJ5B0zKeCOz5SdFAcm2+/DFAEf3lAIz
   nJk+DuqmnIq2SiagMvi/2gLiXc/TTEjE3AT8bPLixqCb0EcKV3+8INsmg
   SKFOb36q2cl9u7vWVSFiOlF1AN9sWLoPiInln3r47uFMcMe8Fho59UKwh
   QxvN8zzvQm7PN7m4Xntt6UEFKq21L/HW34qpquFRiTpJVyic4eann2tFB
   WpJgq2NEcDf6KaA/l0/mZ3ho5NYyeBlI/NVG/5g+Y6RoRf1cdV+fJ4d7W
   g+LTjZv85soUc/NZal4YpNquh/eRomjYLq86IZwHAXp4We3ckChQuhWFH
   w==;
X-CSE-ConnectionGUID: mBO7073ZQ6enoCqVA8sHsg==
X-CSE-MsgGUID: gA1l4okVQEqYG0cXTNxIgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11782"; a="104797733"
X-IronPort-AV: E=Sophos;i="6.23,228,1770624000"; 
   d="scan'208";a="104797733"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2026 14:40:50 -0700
X-CSE-ConnectionGUID: JpwARR4wQqWWIRcLPmbppQ==
X-CSE-MsgGUID: x5NVtusiQTqC0hpHwIzVig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,228,1770624000"; 
   d="scan'208";a="237511727"
Received: from igk-lkp-server01.igk.intel.com (HELO bdf09bfdbd5f) ([10.211.93.152])
  by orviesa007.jf.intel.com with ESMTP; 10 May 2026 14:40:48 -0700
Received: from kbuild by bdf09bfdbd5f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wMBtG-000000007mz-20dT;
	Sun, 10 May 2026 21:40:46 +0000
Date: Sun, 10 May 2026 23:40:10 +0200
From: kernel test robot <lkp@intel.com>
To: Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org, Jann Horn <jannh@google.com>
Subject: Re: [PATCH] mm: make zeropage read-only
Message-ID: <202605102324.g5xWKUc3-lkp@intel.com>
References: <20260508-ro-zeropage-v1-1-9808abc20b49@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508-ro-zeropage-v1-1-9808abc20b49@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: CCE8BA000B
X-Rspamd-Server: rspam06
X-Stat-Signature: 6o4684x4gy785pa7n1ozepcs5c9xuqqt
X-HE-Tag: 1778449252-221905
X-HE-Meta: U2FsdGVkX19FoygzXpB5G6UIy+3VBJyYnxRVIdc0BePihOJ8RrEkhPdcd4V3Y9ULjvhotY6W8WTs+wHc1XEtrJngBPpoNZRZwiiRJWMzbAWqMArzyjoDciYaptum0wr18yXXVXPtZI/Hw6bdEPg7Ur2h6hXbwZ/OxgRFD/1/I4Vb1ek8QjHsOc6wdjtGuLAk5armikTW5D2xZJYLhzkE01K/d9juwwzsjsG7dP8egzeaIO41pWJtxqQ69feAxNpT3RpFAverZ5tWE2n73wtTub+zP5oukdXaC6YAfDmy/fHKYzf6QfJQx9ltBTQIT4QkjY9ycF3SvPWntMnO1mmiNgOQhxnvKzCn2igPVAGKkPmR2K4TmgdDwwQzv3jUN8XqfbPooNuonV+O/tXlInaJ1D9kDG5mRPK296zMhG9b6p5YIQ0MsdsZAx3wEpdtcsbnX5AQEN9K3gOyLjSSJdkSC+NR/hul+0onK90gJDWFuhkE3uDOO/m9b24nozbF/ZT3XMSSiBMV6oKu3teq2XNeL+F4KfQtrRGGZaKJP1IZ0qrNuIpcKcJxg1+pGSIa9VVnGuSYxC7hnPdtOEv0/EXiINj27YrS2+Lbn8yNvAJ0/YbJWLZBWudkGGpdvcaSuu3v5BMPZHCIqknUXZDQMo79GvPToNFJPnxUqA483o8lqIcLSVe6U2AeeUSOFP8GUbOsBSFPwkLxG4pFhiFaKqJK9R+huEQtnxpPg3ZXn/NDqPwhPUGWtWvenjbiam0rbEEy9wdAbrZyYgk06h1qKhkh7pZu28uwCZyHX+qlumsCIQ2jx+AlsC1GCTH8apCzA4Pp+3sseKOJYHcMQLjSSbicIHkW+UzDc/ZWNq/A4Bpo3ZJgDhCuj1lLpmV8MhEskKldyUYxmgzO0XAVJNZHG9tv+xT9aBmIvhv1IfZ+kyNxb01E2aPgH0duCt06JfGFA2HEmVQ+A9wfes4Ha2LM8Cq
 zJgK9Pu6
 8b4NYiySvpYu5U6EkTDRo108dkayNOhm8EGI/p3r0jqbkPs6P4aRkiVLeYXKZLAcJOlck89AFEGFCdGHvXNC/pQ3dkf0JnMcJRvIEDVXIgEwvom/vsQV0P6Gkimn0bDlqI8sPUOWjhiCYFZAw5CEzuH+hJZCxtacXOBzEKI7DIQ29qWvCKgt0QWRU4LXK29vj2ImdeunexEDqJRyps46JB/89zCKvTrcL/jX5ZBV+/QdQlsxay4ERqhoumI+aTmgimeczq1NMakm7g6d9qrQWKkooMDm8wXzsaaXFGJwVS7Wqh0RP/gs+sS5hN5vWjrLEX81kCtUB2SxHWqeSbiMONEbPpaUkh3DiUZo7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jann,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 917719c412c48687d4a176965d1fa35320ec457c]

url:    https://github.com/intel-lab-lkp/linux/commits/Jann-Horn/mm-make-zeropage-read-only/20260510-200814
base:   917719c412c48687d4a176965d1fa35320ec457c
patch link:    https://lore.kernel.org/r/20260508-ro-zeropage-v1-1-9808abc20b49%40google.com
patch subject: [PATCH] mm: make zeropage read-only
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20260510/202605102324.g5xWKUc3-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260510/202605102324.g5xWKUc3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605102324.g5xWKUc3-lkp@intel.com/

All warnings (new ones prefixed by >>):

   /tmp/ccZJHv5S.s: Assembler messages:
>> /tmp/ccZJHv5S.s:14940: Warning: setting incorrect section attributes for .rodata..page_aligned

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

