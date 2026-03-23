Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B841EC01B4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24E06B0089; Mon, 23 Mar 2026 06:20:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5A16B008A; Mon, 23 Mar 2026 06:20:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB516B0092; Mon, 23 Mar 2026 06:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 81EA76B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:20:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1FCAEC33EF
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:20:12 +0000 (UTC)
X-FDA: 84576932664.18.24C2D30
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf05.hostedemail.com (Postfix) with ESMTP id D575210000C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:20:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SG+YvpF5;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774261210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V/OrNILMm81yMqJLknyha56qtfnrFV9Nb4D2NaSWFUE=;
	b=UDjhujKgwXgFTdV8rw7BsuDkHGDIrxqYZFQ4twpq8FGf7ERqDoD4bSVnDgxab8z3+jHP1h
	J4WDt2mE0XEzLcFDdTBljQwhU+Zp8R8TIBoVpmuecXVvmZqAGFJon/gJ1uZARCwsaCwBCU
	8EMaX8yp/YW1qkYiHup/YXmM6TeD9FQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SG+YvpF5;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774261210; a=rsa-sha256;
	cv=none;
	b=sByq0nC+zaXqqLF98EZPN705a5LLFN8pBDQmKwOG7ugRLNBU8UwYU0gi/68yBP19RpuUsk
	MqJ4Azo525noqcTgEOghio0kfMwFTcWpR3G33zU7GjLtqou6UjQaIhU1+FCVY8kHWAw//e
	SMwZto711AHQg/b59g4PoGKMuYXm+Vk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774261208; x=1805797208;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yXatQ4JO8B9DvDgSV+G8n5ZDZn06+ptILBIxSJt93bs=;
  b=SG+YvpF5S9ycHR19ld9cXh3Zk6PYlOuwW1A6Fdbj29hJxOJkbBuCu1pX
   OjstibpTnvMoZIGT4UjcsT8Ighl6POOqiceFwbzM8PCe9jBepnTyKKATR
   +CPMNvYeooROevJ7uSFHAzeRadodkRo/8IyPK1sMTSM224U+fv1Sz2MFR
   5pWMdrfZ87eed6lpmQg69fL93yMkRqrXB8GLy9ltbb5BAwiweepJeNk5R
   KAbxdOq/JW/geca6fPC6rdPXTh4TaoBeiuLIKzW6ZQEAq280QVTG7pQQT
   iy1TGXUt+jcuWt15kQBnwFX95zGpACr0NKQPRcAeBiukz6X0+6Il7dlT5
   A==;
X-CSE-ConnectionGUID: OgQRCB1NTbGTi5PtjO7JdQ==
X-CSE-MsgGUID: sdASmiT6Tf27FF5kdfhGLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11737"; a="74433428"
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="74433428"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2026 03:20:07 -0700
X-CSE-ConnectionGUID: sdWJRHdHQlOkec0YBpFIgQ==
X-CSE-MsgGUID: nHQx2jjIRzyJoC4IQ2Koiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,137,1770624000"; 
   d="scan'208";a="228707869"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 23 Mar 2026 03:20:01 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w4cO6-000000000LJ-0Inl;
	Mon, 23 Mar 2026 10:19:58 +0000
Date: Mon, 23 Mar 2026 18:19:04 +0800
From: kernel test robot <lkp@intel.com>
To: Pingfan Liu <piliu@redhat.com>, kexec@lists.infradead.org
Cc: oe-kbuild-all@lists.linux.dev, Pingfan Liu <piliu@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <202603231812.ZGRRlzPe-lkp@intel.com>
References: <20260322014402.8815-9-piliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260322014402.8815-9-piliu@redhat.com>
X-Rspamd-Queue-Id: D575210000C
X-Stat-Signature: hz5fy5q7ot6rcnz6i6snyqq1fpgj9ssj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774261208-429065
X-HE-Meta: U2FsdGVkX1+shzJhRoG62Ky5KTRUxH2KGjZe92rQt+DvFirZR9tkfDYTFrUIUg1dikJmRsGm/lFUOQkTN/6FTJHgN1Mcyf111SCq18rxMxjVlmiMEWeUZSzOLUDrkBiCNpLyiSwXs1QxAElxohzx2DD5A+QDwrcIeU0cCSRt7Y1iHZuAGzyBLnLsAU01UY3S/OlBZ7jWFaU4964rixgP1C6cdjUyyQyG9FudnxdYamFNCuTayErkJ/D3LM5tgyZuypfoI83MWS4hYsPE7aNlCGGLW9+Ssxbo8iJpnYFZmLATPUjbQeGM246NUw9td0s+xHfbqcCBcvmQ+ZHOpvb/VdHYC7ljsIaxhXYi5CGRhTl7UvPBvS+ORQP5XG5CEWz9026bMvVbGH38c2F3oU4t8+mJLtvxNCTvwnnlsSoT78EjmKickiu7rpJy6rLZlwmHdf1ECHyriMDrAsYsNa6le5c1OubRskp1tggBkMGNlquE6Bae0fbJYHCmAZq2lOkgXggKSLyQoTFJUSkfqbXI4embMkH0ZXg7XLStIDRziUQQjWB4w3y5Hw1p7Mc/eu+04Lo9zKaDbui/CJJD70Hn2tReTB+8oDoQFtAr8AvbAhGUaCV6KOyXEb4IWmMMFmDRvSwM1WlieznDsq7fhcLyZZiEtw73V/8l0Yy5QBzE402MusZifbmgnlDaWzZMbvM71aP7YLoYJrhqsEmmwcVxNWD1J5uc2FlMqX3jJS3xMaY6I6JjQEa9Xaswwpmd4adji89gTwvU9DCt6QZfXN7JSSHLsv0iXuGsjDp9Cyrr9GFMciRSbQGCfodssbMrC2hGIbdyN6aq13t8nThDv1s6DRJVcW7tU8p3HULNb4Vq0fKcwcZA8W+8k5gYFaTKr9Ou32Yf1PnZA6ayvhM95bSOIQGDWQ/mk2t8cYvcdnWC/GICQhWfEmd4Es05mM8KlCo8ZuGOxDPq3mlTzqT+Rb2
 naRVCi7o
 mYQxtFx7B0FF8eT6C6olQEbKAQDQZ0Um4b4jg04speEUUT+CCN8APV0x9JmevX1wUWBsDUDuA9XqyV+KLmHk9SqIQ4NeZD42LuxIMeUdk+33MxTWB0SM+/A4MAbZbB4eeMSbbdKvrv7EaUNrKB3vIPsZC/dmaCdWs7h3guwJKslfmiVANcJhd/y2mPObnCRr46fNLZkrckUsOkO3sd4W4XVwwrnYMVONe3DhrlvEKSfS9+3clEnxorsYp/qk1g1qrMozWGMld0pBoLoZqbtKsKSHfqoScOJfS7Hh+mUTj21PUznyZHvXd9JTiWQqkzGMl8BMCZPJzvkKxOfDEXEm3bxG30hjPUvmFulk499kWtApwhIXa9VW7NIrIjmFyQY68pPZKrV5nV1rbuWPmTG+Er8N37IPDsjvx+3QvFRAkUJXNzqmgBzf5ens4r9xkSLaMXQzrbw+NuHIIneoWWc9XkOidOzFBRaGNOLL92XzUJ6+B/uskQYJ7/FV1LQ==
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
config: x86_64-randconfig-002-20260323 (https://download.01.org/0day-ci/archive/20260323/202603231812.ZGRRlzPe-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260323/202603231812.ZGRRlzPe-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603231812.ZGRRlzPe-lkp@intel.com/

All errors (new ones prefixed by >>):

>> kernel/kexec_file.c:1276:23: error: redefinition of 'kexec_purgatory_find_symbol'
    1276 | static const Elf_Sym *kexec_purgatory_find_symbol(struct purgatory_info *pi,
         |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/kexec_file.c:958:23: note: previous definition of 'kexec_purgatory_find_symbol' with type 'const Elf64_Sym *(struct purgatory_info *, const char *)' {aka 'const struct elf64_sym *(struct purgatory_info *, const char *)'}
     958 | static const Elf_Sym *kexec_purgatory_find_symbol(struct purgatory_info *pi,
         |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~


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

