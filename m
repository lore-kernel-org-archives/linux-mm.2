Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99D61D46C1C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 06:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60216B0005; Fri, 30 Jan 2026 01:44:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0DE66B0089; Fri, 30 Jan 2026 01:44:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0FD86B008A; Fri, 30 Jan 2026 01:44:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FDC46B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:44:10 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E834DC1F82
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:44:09 +0000 (UTC)
X-FDA: 84387690618.24.FA704B9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf09.hostedemail.com (Postfix) with ESMTP id DDCFC140009
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:44:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mgJ6JCJq;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769755448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U9bJdg7sESmUggjpsO2Vlzf1851RoIfE69ZJgp5bSXo=;
	b=UIe6ILFg9BrMr9arUEfB55Qw9/UtO7LcHHlHfSbPsb1aJBQcbGgN8D9Yz+iPViDra0vyJF
	MMcKeR8a4XECa5TQAlRrhlyllvf1Yy/EsANdJ1V9TQAmaENKuq1cYKclFyfh6ISaZQfybP
	ymay7H0OUmZ0rXsBXlZ+9bhDiKssqI4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mgJ6JCJq;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769755448; a=rsa-sha256;
	cv=none;
	b=bur7hXKH7LHekPYpwDGCfeNCd+jAIsMW6JFXfVB75mOqPWETkVKo6a/e9JaDsyiX8z3BaE
	+XG4ncUTz+JCMtycJk1gEH8pS4NNIdBB6e1YtUcE9MAXEFk43XEQABaK+81rBfxZYq7CIm
	zjPTnp3IhG1V8pGhMVpgcW7Mt1Kx+M8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769755447; x=1801291447;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wrrzZRomTXxLMU8ISyp2Xzik5/V5pqCs87PE/IqGcVQ=;
  b=mgJ6JCJq5MhiBvxlSjY+v3cP3I1ASAGvzDqeSJnWv9T4j4SIEqoT/wSp
   nS6HpqMtsn6MSCL8NwZlbnodwTyp677DXZmOMxeT3eDU8Z5XYqCOr/3Ft
   VAKV+dofpNYe/nPmyQggg4llr8C2DbxbihaeV/qz3wSG+CcjLYR+fb9Ob
   rD/toCNO5VUQP2MEwGjcJ8cGDcp0IrJEmDFz9HRGUC+zAzpdW46PU/Ui6
   KYjFzAdVT/+QEc2lmOZKfD+OFfmuyU7Tfym5zGxBQ1IyLdC++UhBocd0N
   WI7eA8YLsWMQ1L412YVRXSRpQQQmn6iYWEGi6zuiHVfD6oGC1jnibyWX5
   A==;
X-CSE-ConnectionGUID: ie+en4PkRV6/VHAp0e7HOg==
X-CSE-MsgGUID: 9ZfGJxsHTn+Pg+tX4FdicQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="88419701"
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="88419701"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 22:44:06 -0800
X-CSE-ConnectionGUID: VjKh33a3StiQLpQQIfJUgA==
X-CSE-MsgGUID: F3LW/Y8jQ6Sz+7nhKq+F3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="213273923"
Received: from igk-lkp-server01.igk.intel.com (HELO afc5bfd7f602) ([10.211.93.152])
  by fmviesa005.fm.intel.com with ESMTP; 29 Jan 2026 22:44:04 -0800
Received: from kbuild by afc5bfd7f602 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vliEb-000000002Qz-28Tl;
	Fri, 30 Jan 2026 06:44:01 +0000
Date: Fri, 30 Jan 2026 07:43:08 +0100
From: kernel test robot <lkp@intel.com>
To: Andrii Nakryiko <andrii@kernel.org>, akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	bpf@vger.kernel.org, surenb@google.com, shakeel.butt@linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 mm-stable] procfs: avoid fetching build ID while
 holding VMA lock
Message-ID: <202601300733.c69u3XEU-lkp@intel.com>
References: <20260129215340.3742283-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129215340.3742283-1-andrii@kernel.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: fqu8uxo4wh7tsixthr185pqtjkcgzya4
X-Rspam-User: 
X-Rspamd-Queue-Id: DDCFC140009
X-HE-Tag: 1769755446-301286
X-HE-Meta: U2FsdGVkX193m7/UD2NGt3Lp1l/599R41EizQDhH0yNT4MEeQA8zLZtILU4yIRbhVhkC9Xf8eJHisnvPwa/4gv7vw3RogGXzGgESVYPuk9S2O3lE0FWEEdvgmpOH0NZD8CZZyAA+UTSnlJBk1q31vh72z+8mEHlGzjLwjKJNuPXOAIg7ZeBC2Ea5HNdNOC2gJ4XPTGwBUazEGfLujtGVdSthXjFkf3+ycIcW/SJepLs2y5w6IxzS6ywyTNX7vVgGcSUxXO/EblPNGvm7H+vnfy8ob9VqHGl5RA8a/MZmS3Y8I54dhv5OXJIaDozLR0fbRp6vMo6enQ58JdpJ+WJGDrpwsi5fPFGMpV81ryRe8reqCe6f2dVYUUmnCqNDxhGRWENHBeRf1hIut0Sd3HqiECZBviK7xXiAqYhDLvEjrkrItI+rhKIlCsG3Go9r1EvYaekeIdXHU6GRNA5J9v6obPPdinQL5AVTm3Y4K5iQHPMeJItGNoWgQAr3+hoXrQzf9IjLfg99VgqHjBzrgX/BJFyalY3L6toBaN4F+1wdmJ5ZeJy7RU3tCZoLEyPjojrjCZO6NZovhL1YPFokHQhTwZ1d3BrXWOJ+w2mvdkdIYMWQ+ZXS+FBjDIgknBLCU1qRvW6JQPg9R60z3vn1TiPWU5MdCGYtGSY8N9SuE7sGj4iFxLzcCdc1lZCdgVpWnLm+f+flhkHxUPqEkMDiXfQGSKFyqw1g+Q+rR1NnuzholT4LlMlchXAUa2UCL7spue2iNwRVzqRSWcwxrrhEaemklGwO55gKuD6moilpsKruFEeTea+9EGdarv35oePa0xrgtrYZ6nNPxvSpb3cagTlVD/vKPVQCRF2QXohfFmlfJEOLeqqa9eC8kllfXDjaHoIhPOuxCx81AVWK38EcykdjL0lQE4bFqTHyzTtpztyFAfAPnNXgMMEtn6IWjgKzYD+jRPCmqWn8eXeTylatGpr
 UZfpWiR4
 cQUc0G55pBAj+wOl5ZJg47RI+M/JI6kDDhiQ9z2fv82yU2nyy1T7pe7PrITMPalOfdk8P2s+5pXfnd1EBtc+pYfcEW0ktOoVVcsqdDOWjFZaAy4s5QnnzOj273d8BSkYXpdBVHP0fAVC5HjRx3Qa+wmMiS+L5L73r001/pLGPIW/RlpTot4x16EaaKeIihnAVx34S6SXpt2HhZCSb0KPVoR8Tj+GQH+kHYQNdyHY/mUO/8SOoIJIqx0It1r5vGQc26ubBi2lQF7ZHP+tOGrYxWX0DBNCLHkmdJ5YCoNDXG5IpUGqONkb8DiWgaHUZUEp+js28SlMoPOf5Yibg1dADRcOw/TospUmSQ2HIKu+natYPffgmicgc5T/AtPKWgowD2ELJVlNO2sv87VC7hb3m70VjHp0JpCQctvSpDKyayBA9t6l6iBJzWhYRtnZiZBRlg0df
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
[also build test WARNING on bpf-next/master bpf/master]
[cannot apply to akpm-mm/mm-everything linus/master v6.16-rc1 next-20260129]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Andrii-Nakryiko/procfs-avoid-fetching-build-ID-while-holding-VMA-lock/20260130-055639
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git net
patch link:    https://lore.kernel.org/r/20260129215340.3742283-1-andrii%40kernel.org
patch subject: [PATCH v2 mm-stable] procfs: avoid fetching build ID while holding VMA lock
config: x86_64-rhel-9.4-ltp (https://download.01.org/0day-ci/archive/20260130/202601300733.c69u3XEU-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260130/202601300733.c69u3XEU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601300733.c69u3XEU-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: lib/buildid.c:348 This comment starts with '/**', but isn't a kernel-doc comment. Refer to Documentation/doc-guide/kernel-doc.rst
    * Parse build ID of ELF file

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

