Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B84D0FC72A8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 07:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E84326B0005; Mon, 23 Mar 2026 03:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0E1B6B0088; Mon, 23 Mar 2026 03:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5C86B0089; Mon, 23 Mar 2026 03:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B39166B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:08:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1680513BF70
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:08:13 +0000 (UTC)
X-FDA: 84576448866.04.0562517
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf10.hostedemail.com (Postfix) with ESMTP id F310BC0006
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:08:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Dta6vbMy;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774249691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVQsD2O0qghSgK+rqUALDAR7d8NzlSIi53UHyplYAF8=;
	b=eKG50vYxHO7ILfDn9+RDv9lhYmXwovRIcSh3Me7RelhNt2SG1MFI4Z8dp6nfl+N58WbNLA
	RySxEEmubRAGmWrK2KFJHFwcUzvzsj4e57Ncad+HUjzoMUdPxDHS8DPwYdaHc3nln9O4Jx
	F7Oha7DvjdbQ79tgtNdX66q0rCvX/50=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Dta6vbMy;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774249691; a=rsa-sha256;
	cv=none;
	b=S6+OT4qWDLB5XcCZwoBFE6AcHWYBv1XPK3b84552c7QyLXRh1bFcUzcdroZnII5dhfxXEg
	EGRnliT9uDH9VraXFl/fpCi2vykZCfW6NUzhuOX3XLT46QQnh9ODDU5kMahCqTuukTH8dW
	ivheDLZr8Y8+WrrCSfRUCgu20yacNDI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774249690; x=1805785690;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RCpk62n3AYbYiVU8MLmHxHTP0ibiZw4A4+CXyOIQstk=;
  b=Dta6vbMyC0pCanBTtdHy3xZ75E20sQ3lQlBOD5PZu4tB1cHgHKc0d4WC
   vEckc8BcVg5Fp7orQRIxvu+fJXs2mpbOXmjyNP7AI4f+qLBmYkhMe9MDT
   ag3OcD7lrMF8IEhvgAZgovt5RdFu4nikQHU5tjguZz74xSTDBj8JukkgO
   MywTvbX7vB6jmmz2c+re/oQvgQMxdR05ATXepHM/jEUrcggcef701bbAE
   PYtBo1StBLDUkbiT3btMfMUt+Ax3kh7rwHpTAnWUVCWQ8GLvvQkYxMFle
   egNhy3L3HIGsuL3lBmMYc8S1MiXGmvcZ3BW1JnsMd3B3h1ze0c0CCPG2j
   A==;
X-CSE-ConnectionGUID: dcB9gCW9SlKUYhJMJQfhvg==
X-CSE-MsgGUID: PLqyozWeQsuBBJaARtJF+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11737"; a="77851860"
X-IronPort-AV: E=Sophos;i="6.23,136,1770624000"; 
   d="scan'208";a="77851860"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 00:08:08 -0700
X-CSE-ConnectionGUID: kRJ1g0y0QDaExnkxhsB7Kg==
X-CSE-MsgGUID: badPk84/Tv+lneKFJzNajg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,136,1770624000"; 
   d="scan'208";a="219142609"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by fmviesa006.fm.intel.com with ESMTP; 23 Mar 2026 00:08:03 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w4ZOK-000000006Zt-2URK;
	Mon, 23 Mar 2026 07:08:00 +0000
Date: Mon, 23 Mar 2026 08:07:28 +0100
From: kernel test robot <lkp@intel.com>
To: Pingfan Liu <piliu@redhat.com>, kexec@lists.infradead.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Pingfan Liu <piliu@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jeremy Linton <jeremy.linton@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Simon Horman <horms@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Philipp Rudo <prudo@redhat.com>, Viktor Malik <vmalik@redhat.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>, Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	bpf@vger.kernel.org, systemd-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 08/13] kexec_file: Factor out routine to find a symbol
 in ELF
Message-ID: <202603230851.qOD27RaS-lkp@intel.com>
References: <20260322014402.8815-9-piliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260322014402.8815-9-piliu@redhat.com>
X-Rspamd-Queue-Id: F310BC0006
X-Stat-Signature: p4aqxrnqmuoj59o861118cej3auihf8j
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774249689-857383
X-HE-Meta: U2FsdGVkX1+ikT0otXgzYxYVs1ixghTt+cXYp+WcCOQfPLu597C9+uno1J8oCej4QTL66IU06M66TeOvXZBMJeOA9+jLtQkm875Ayoe0gu30rSl7C7g4FDQm+mv/+xLJK62HJC7tYb6z/QaPxpBj0mT4Ac1LLGSYcqtn8Humz0isji3vTj0GasNwXVA9LYnqTpURnf8nOhrvp+osonRtVImSj+zAlcbERVCmYJR3F6rvbpZQ/FnkOgc2gswmoIN3W9pAha1JT0zHpTrwKlW1mXc9SSEwVGLEJCCoUGc6HXBkeT7JjPh01LIgWSR/FXYw9RKvlez8JvUdg7l8iH9ifHiRoFrKzcd7iX4g4TfzRbOZltcTnPSsiwfbnkMgMhmfYQcO3Tx/4iOh/ZWeHjtV7GjKmMiYdkf6ujktSy2S87ocAYR7/tWEjvlwEcb6dVNuFZVUIfv5yFd3X0vP4jPuvAfc1yz3idE6ees848vZT/JWDR+ebvyJwuyeoR9TVfpHHPAT+g/hr2qHFBMTFERwhTDlWLsej/pWUwg3Nv0E8wB0dNQDEBSUpMDL8IT+VfbQvb5wl7jzuHMHq+1a5JA3ZZzsr4+1LMwC+hNxQyVCvombrv67dFwfEQ3DNvFGBNR3ILr2hVRx2MCbCRtt9Yo6EjN5uzo69Gs/CU6c/ck8uyiBVo6dgMtjKWQAjge3Ydfq0YB17botHpAUcgP0v+rGz8hUc17W8q6z0tohHu0Zu7MaFQ3hjsBnD+xUWeLGotfvWm6u5xmDLrbKU7HE2RDx0MLN2NCfVcJ/czzWNFp4m99qZ06u6LnPPRD51QIv2eZjss9lAPhO3tuOkOAPHMl12/yD/swyFNxxnGCzCa/HfcmI20FmKSaeWMZnEeONlXwCUzlOvFuWPnNTCNh5V+ggC/bvR4xWNVBnbjkIHqTP+5fLaH33cFQ8RBZNZW7wS/21R/SWR/ny4XYbLRoiJZY
 jIphy5U8
 58LiiQPJRpHN1JxqHkqFOj3s2dQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pingfan,

kernel test robot noticed the following build errors:

[auto build test ERROR on bpf-next/net]
[also build test ERROR on bpf-next/master bpf/master akpm-mm/mm-nonmm-unstable linus/master v7.0-rc5 next-20260320]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pingfan-Liu/bpf-Introduce-kfuncs-to-parser-buffer-content/20260323-084500
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git net
patch link:    https://lore.kernel.org/r/20260322014402.8815-9-piliu%40redhat.com
patch subject: [PATCHv7 08/13] kexec_file: Factor out routine to find a symbol in ELF
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260323/202603230851.qOD27RaS-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260323/202603230851.qOD27RaS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603230851.qOD27RaS-lkp@intel.com/

All errors (new ones prefixed by >>):

>> kernel/kexec_file.c:1276:23: error: redefinition of 'kexec_purgatory_find_symbol'
    1276 | static const Elf_Sym *kexec_purgatory_find_symbol(struct purgatory_info *pi,
         |                       ^
   kernel/kexec_file.c:958:23: note: previous definition is here
     958 | static const Elf_Sym *kexec_purgatory_find_symbol(struct purgatory_info *pi,
         |                       ^
   1 error generated.


vim +/kexec_purgatory_find_symbol +1276 kernel/kexec_file.c

  1268	
  1269	/*
  1270	 * kexec_purgatory_find_symbol - find a symbol in the purgatory
  1271	 * @pi:		Purgatory to search in.
  1272	 * @name:	Name of the symbol.
  1273	 *
  1274	 * Return: pointer to symbol in read-only symtab on success, NULL on error.
  1275	 */
> 1276	static const Elf_Sym *kexec_purgatory_find_symbol(struct purgatory_info *pi,
  1277							  const char *name)
  1278	{
  1279		if (!pi->ehdr)
  1280			return NULL;
  1281	
  1282		return elf_find_symbol(pi->ehdr, name);
  1283	}
  1284	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

