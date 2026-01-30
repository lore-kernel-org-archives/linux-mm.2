Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BB43D73EB7
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 03:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3C266B008A; Thu, 29 Jan 2026 22:55:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE6D86B0095; Thu, 29 Jan 2026 22:55:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFCDB6B0096; Thu, 29 Jan 2026 22:55:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D06A46B008A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:55:33 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8A78B7A32
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:55:33 +0000 (UTC)
X-FDA: 84387265746.20.0B7EAFF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1C60920009
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:55:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EHB8lySj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769745331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qf4yyFwT4C+EAiIpa7/A7kThnwf8zmTKqvMYA7auCME=;
	b=HYQzuk4YdV0Z/0KwXjplnstVgc4OUErYmPvOrb+36LzmRA9vLJjhpJCyjOtbELs97ZeIwJ
	4V4M3J9PRn4NWq66J+Bzqu9jheQI/ESBu4Eko82XRRDQw7yNh/QxAKVors4Klvtfx4CcvS
	mGfAJps2ZUYNrlohTTd/tsWKbJXI1Oo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769745331; a=rsa-sha256;
	cv=none;
	b=DnMQUU92s+aJHPjVHt4piX/KSEwbx1Z+DDU+w1BS0kw+FsgrOqpaaXSavzhZ51umx1vLqA
	mj5N3I+tYC9Zbu4axQ0nuMucOCPPQSJ8Ii76KwGsoAJgv+z8rdtWCubea3inKYBNdWWUfm
	iCaGEsysqPkMGVkgGjQcSjpUxc37s4g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EHB8lySj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769745331; x=1801281331;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lCApoAs780KvAuXMjci54Pk5bdt1ic49wr2Ha4ZQ0NI=;
  b=EHB8lySjUio5eD44dwImH+w9gokm3QnJqaWpTRvjjwDLdyFU9OLes5ak
   ZiXHfWXClzp2kMdkyTf4fv2+f8EEwCo3h/8ndAdbqzdbGZ8rd2/YCcoqO
   zz2sfaiS7/I4Agka49sAfcnCVHgNO98XMOmTasjdLC59B21EK/ELxhvlE
   4QVsJInP6gTJg2A5N+3q2EBoWdyETTHLfwASwbNwEUHudV52S9UQSu5z+
   cLGEJk3Tv2eNJ6ASY2GnSaOAqV5Rkeh2pSbU5+qnGk1acgUQ8BHmDSRUS
   ekSZFbeUvO5uXZzCTZwGgAv8PlQkWul3sYqdhpI6JebdydNG06EbxMWQO
   Q==;
X-CSE-ConnectionGUID: Ntvs0KYHS2qyEsbN2lNa9w==
X-CSE-MsgGUID: foVyhcDmR0aviOJ/JWPeVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="71048413"
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="71048413"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 19:55:30 -0800
X-CSE-ConnectionGUID: 5JwofcPES8yhw6zqynO64Q==
X-CSE-MsgGUID: 9GWOSkM7TeqVnLGsYipAuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="240005118"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 29 Jan 2026 19:55:28 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vlfbR-00000000c96-3Iqw;
	Fri, 30 Jan 2026 03:55:25 +0000
Date: Fri, 30 Jan 2026 11:54:52 +0800
From: kernel test robot <lkp@intel.com>
To: Andrii Nakryiko <andrii@kernel.org>, akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	bpf@vger.kernel.org, surenb@google.com, shakeel.butt@linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 mm-stable] procfs: avoid fetching build ID while
 holding VMA lock
Message-ID: <202601301121.zr5U6ixA-lkp@intel.com>
References: <20260129215340.3742283-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129215340.3742283-1-andrii@kernel.org>
X-Rspamd-Queue-Id: 1C60920009
X-Stat-Signature: djsht3u66ynuh37w3h3z5jhaix4519x1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769745330-166584
X-HE-Meta: U2FsdGVkX186Zd7xa0a1T0TbkfslioWKtuQRBE2SVm8ntJJ/yQ+e8kuoWueueO7Pj5bdRftzrUWSrnyjVlN0m9lKvOBe+akh6OHqhBcfCFBuFiHI2WUr5e3+4sLND1qumB2D72z9UWTNXVt9bzLHGyvXZEnGX3lBPpFeam4qdGihJmDthVQPpYXpaXENklx2D+1Ex5thIYQhrruWPZvE2ZmZgzxxdJMxRTRUoV7iq9p7/5PPRhSLhBHuUq1jcxNFISyKVF8+8lhcrYlE+H+vJVqGvcu7VOQVi6u3zbyrsg3r30BeJYW/DAWXYumpIJAdDjpjQEw/H02TZoSIqHwk37n6oy6nHeqJx/2j4MYElAHVpy9vEcBpiyvMOCBG0EDN8EJbNc5WgegNO+HdRXxpONV/d8UuBNaWPQfIj45AZC+6qzDWlgH2y+8Vt20Wq1a9NnpNp/rmM4UnksX7sqDilUo/bZzYf/evutSQr87xqUoKYN4jWMyXv/ZwKjxuK3eKW3vYTHZ4uMTMH/4SBuORkYOqlGET2/eOwLwungYuBEzpjeukar5sFwafQsR+aRSgHxfyK3DVNUjOV822bGUHS8i7RzsQcwzCSyII2t1oUrvRkXcxivYRCyuBw37G44j6r86Uh2U1Sb8CqLe6Oyu3QTwDjpfcqjPhfP1MCM5oigd3vtjSmrLfUhDJikp08v1tEhE3OMTLEF0JRkQm95OC6J6vldZKdOClIgOQRwFQLWkqgI1vgzpd7Q0g3d30ndTCLdAU9LgCP99xQLbBMHgv5loA8ZO6WYJpGwLA380f5XvT7/mXv/kXqQ55U74QSpFhuSjE2vU42XXFVmLq7vgv8lt4Q2Fl/ElqZ3L9h69xr91yxP2rMCFYIDyheTyP547uHZN72M0QC+7rrNjv55fxCcijdk9sBv37+L9p9eU8dtANRJ7iF4il81JAueLQCK/oVq5UN1MM+oVXTlXBIgn
 ONDpa1S+
 4CBNqpr2P0hHdxb2SVrGwwATTC8lyHecxML6hVxiHMunFq7dLxUq1Vu67Zt4OsN4WSbnheBcfPNxMlqSgGtljr0s//1eI/DNQtIOEI0FL95HfZeiAY3e+YlhgPgO2pRTbjceq9saWBh7AVlxBXJbuiwY/y7oqi4GEMFwRB0JVr4+z6mkyT1lR9DYyCsnNq+9h4aZMbYTMuXnMkCud39HJIu1qkcBbdXqU8ryr7lABgNj7k5WSNgSjWP1wCJ/AzNLARf/3aQekNWkwcTRkZTvuZFGlUTGWF3u+pwJmId/huZIsRUy7uJ6QyIr8S0j4MZ5+4SADkV2SzYkEirfYT7g373RYSy3qJgxJpHR/8yDqRQM2xiVqaO1OTPD0jz+mciU71fP+nsFbq99hKbKZkj+1IXtgUBUbTUVVL8JuMZKVufqVlViaURcSUwsUsbTmtrNq6fVH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrii,

kernel test robot noticed the following build warnings:

[auto build test WARNING on bpf-next/net]
[also build test WARNING on bpf-next/master bpf/master linus/master v6.19-rc7]
[cannot apply to akpm-mm/mm-everything next-20260129]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Andrii-Nakryiko/procfs-avoid-fetching-build-ID-while-holding-VMA-lock/20260130-055639
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git net
patch link:    https://lore.kernel.org/r/20260129215340.3742283-1-andrii%40kernel.org
patch subject: [PATCH v2 mm-stable] procfs: avoid fetching build ID while holding VMA lock
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20260130/202601301121.zr5U6ixA-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260130/202601301121.zr5U6ixA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601301121.zr5U6ixA-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: lib/buildid.c:348 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
    * Parse build ID of ELF file

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

