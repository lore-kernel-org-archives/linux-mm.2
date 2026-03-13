Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72FE6106FD66
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 04:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CDB26B0005; Fri, 13 Mar 2026 00:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77B466B0088; Fri, 13 Mar 2026 00:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67A736B0089; Fri, 13 Mar 2026 00:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 546336B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:18:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3FEA1B88BA
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:18:16 +0000 (UTC)
X-FDA: 84539732592.06.A1DC155
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf17.hostedemail.com (Postfix) with ESMTP id 41E3840006
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:18:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ScKHz4G4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773375495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=RYrIUHvQYnWuytSOz3FCQ/P8tN9xTzSr/h20z2LdMrI=;
	b=GnfWW8NK+mYbjElUnmEYWBvj1mRuX35z9jkKgCmqLjWsSdN1tTJpntnrBkrKZbapYSYtaL
	Fj6JqvlMs1Dx4N2jVL/uBljX61AxWvW+QwwYj+bN/hUN0bE5Rlc8tKylc4q6XBckLXfcji
	LNRTKAUN4T4Z1AHQcWvo8+AtNs+6h1M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ScKHz4G4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773375495; a=rsa-sha256;
	cv=none;
	b=KyJo0c+j3I+0G3FjpO3ZDQVTLjV8Sic6RrvgfOv2Y+LaB+93um8nwejTsnMmRy7b9C2hYI
	JcA9qlBd2XoHoiRVmDdcKQDN5aDnWryiPQXktjHhjK+PU3mrh+/SRc8+xxVOqPpv0zugFa
	hIvsUHX+9tfWuV5D4TAXlP3pF/5Ts7w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773375494; x=1804911494;
  h=date:from:to:cc:subject:message-id;
  bh=2k/F0SZT7Xv6ggBApqTgD5cbWgwsRk0FUwBiPmm0rP8=;
  b=ScKHz4G43O8ad/zVbBkqvrFMy7EHrm4So9JUBuE8VAdewBSCLAfsJPf6
   P62UmFL1jfnhXpNgvNW1oPreBaM9XQhCkSvT9+ByPaRo7VttMMe3iYO7V
   YA++BoTqq1QyHOBTnZ4iLavaxtDksQ/vCj1XFwu9utpZuFtP9djshWvRs
   hSh/mSf8DIZTS6CLN0cmEbKPP37dYqa/fV8Gelnt6btxmJvQcUT1d4XB3
   DSeLVkE3Bewt1aJnRF76B8y6uEacbS3pzBWzJQLtdrGLB6oRTjyGnEdur
   HCpPq6LJnANcChtHwfGHu3lYgAoHKAJNNCHfLw1uUhBMPbD+HR1Pptftq
   A==;
X-CSE-ConnectionGUID: g7n0yUb3QpucFjzzF7SMDA==
X-CSE-MsgGUID: LDdPGwFkSIC3lurEntR8TQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11727"; a="78374317"
X-IronPort-AV: E=Sophos;i="6.23,117,1770624000"; 
   d="scan'208";a="78374317"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2026 21:18:13 -0700
X-CSE-ConnectionGUID: rppWKp1nQWWSguyclS7gVQ==
X-CSE-MsgGUID: zlOdF+XhSOmoxNzuqNLAPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,117,1770624000"; 
   d="scan'208";a="221237166"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa007.jf.intel.com with ESMTP; 12 Mar 2026 21:18:11 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w0tyS-000000003d7-2LJs;
	Fri, 13 Mar 2026 04:18:08 +0000
Date: Fri, 13 Mar 2026 05:17:44 +0100
From: kernel test robot <lkp@intel.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 linux-doc@vger.kernel.org
Subject: [akpm-mm:mm-new 367/381] htmldocs:
 Documentation/filesystems/mmap_prepare.rst: WARNING: document isn't included
 in any toctree [toc.not_included]
Message-ID: <202603130548.Eq61ZQ3W-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 41E3840006
X-Stat-Signature: pnjye8h7zohfg38bdfktsfjswtr9gn8x
X-Rspam-User: 
X-HE-Tag: 1773375494-693438
X-HE-Meta: U2FsdGVkX186DajEa0yHkFpRgGNadlzEVwVHgJIA7CeZYE43vAiPNoTUbN27lLy8zrEDXVsDnTtPxUN8SnRu5VW4iZ85Cd+W4aSqSAw7kqQFYDxE/FdI6+LYhy1ZSuMdn6Iq0Q1g9gN0yBfPnsHhj7UyUgk0zfyX8uvervKyXD+4g0pMdqe4710wq8kiDmpP/nPYSqLBwiXqms3P/FaPs2+YZEq7okePr06DAoelAjkaRtt/Hlja78+z3P0S2CdqvFaPpn1WANkta5qOjEBNkWOrvcofiCJt3lEu0P4C1wHzoYt1LexsE+dNmMcZC64Wr7DN5Jr92MwwjSefLyLsSvSbetXHvwgxmAmhj4uDOv4mGWqxAWAHEK4p4zXV77+sOGHqZCvCv24w9Tex8OgXNBBnUpMqm1QnU5D0bLMuAylS+Yn9KZuT/kxg1Ql9rwOzltSADw10mh6+qIxM5IMl6tDNZ8ozBx+EQPSwgotPtnGOL5vQZugfITZp5e57Wf00s4aMYgLwwSJdBMSGEgiX77pU4PCvON0X7rvaeO02cqPM3MHg+onTVewpJ9n4ovdYz+rJO1PcJRNYhokPrkSwoeKr/yAuc9rEoi0Uz+vQ6mcWCJ2C3wvjZNxdpDy1Cue5erC3+HIx7SpnOAFWYd50SJk293pQnoLTSd3h+0r2uAsTrC22IZvoeyolaQ7AfkfhXP5Epn3yG169MkB6NVwr48msgHgcfzN/anN4l5802H0FxsbLEvp0zh2eWjJ9PltopyRCKogL8nBhRWucCV51ER2djPgbVaZiDKFPZPVYibwHogHvfG6Qfu/jjx47Aiv7HdujBgqXswIWCLoSvKt9DdiN2hYMf9HKnWorGBe4BXUhItYyZw1NUBQ0AX+3J3elAmNcdKWVL+PUeNH2SqMt0q8fnbhTgqkqFMrELMSR8lanqJ+n+ezEXLKVBv6nbCwXQ3YlGelVJm6txB1mEND
 idSYoWud
 hKp9b7ibayL99ujhb/OI4sjlMGLF+6xVfATLRObKx8oR9l8uawgZ8BRxwZoY8JylXljFu4hlQIKl6ZFgrYK2MCXcSGi+DavqIwVTq3hBEhNoFi0u2mwN9HgikSifDVSoZMFxPeUxjb0F7Dd5Qg0NQey/WZ5tX87G7OOC09ON2O2T2JR3dJKyYrIbPybdBxJdoxNZS+YdAW+8uQkmEwvZhUFu76fstmLJ8WTm/KU8c/iBKhksacgbcEYlGK8FRmnTyH79v67C0r6neUfFn1eUqKF1fZauZUna0FMq9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   593fab843afbd6800243552aebcc61d02d3cdcb2
commit: a6cdd3274e8a03e218fe6bf3ef711902adb76727 [367/381] mm: add documentation for the mmap_prepare file operation callback
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
docutils: docutils (Docutils 0.21.2, Python 3.13.5, on linux)
reproduce: (https://download.01.org/0day-ci/archive/20260313/202603130548.Eq61ZQ3W-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603130548.Eq61ZQ3W-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Documentation/userspace-api/landlock:526: ./include/uapi/linux/landlock.h:50: ERROR: Unknown target name: "scope flags". [docutils]
   Documentation/userspace-api/landlock:526: ./include/uapi/linux/landlock.h:24: ERROR: Unknown target name: "filesystem flags". [docutils]
   Documentation/userspace-api/landlock:535: ./include/uapi/linux/landlock.h:166: ERROR: Unknown target name: "filesystem flags". [docutils]
   Documentation/userspace-api/landlock:535: ./include/uapi/linux/landlock.h:189: ERROR: Unknown target name: "network flags". [docutils]
   Documentation/core-api/percpu-counter-tree.rst: WARNING: document isn't included in any toctree [toc.not_included]
>> Documentation/filesystems/mmap_prepare.rst: WARNING: document isn't included in any toctree [toc.not_included]
>> Documentation/filesystems/mmap_prepare.rst:60: WARNING: Pygments lexer name 'Cw' is not known [misc.highlighting_failure]
   Documentation/networking/skbuff:36: ./include/linux/skbuff.h:181: WARNING: Failed to create a cross reference. A title or caption not found: 'crc' [ref.ref]

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

