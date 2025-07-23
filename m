Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D8EC83F27
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 00:45:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2D326B0099; Tue, 22 Jul 2025 20:45:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05066B009C; Tue, 22 Jul 2025 20:45:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42726B009E; Tue, 22 Jul 2025 20:45:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C5CF46B0099
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 20:45:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74681C0516
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 00:45:15 +0000 (UTC)
X-FDA: 83693685390.16.1DF7349
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf04.hostedemail.com (Postfix) with ESMTP id 523514000C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 00:45:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="nJF/rf8M";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753231513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/yVOebopCKz7Q2ng99Hh4CSN57XYcgYqrFuQZ+lEa4=;
	b=fERTMoF40akpE9U+wUfAMo8WlNeT15u5v8NcL9H374daIUbMpP0YfiICP0Yo/sWQnGpmG7
	weBWDJnoZBQH2RJhNK5sz5PFr3qMtUw4N8Dni0/AX0ZEgFjlEHiopkpz1KPWUJyJhW4h10
	4tF+1I8BNLiyoTCeN6/DfvVfncaM7sQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753231513; a=rsa-sha256;
	cv=none;
	b=B3EKev4wTP+yTfnMfeF9mII7F/wpkDmYyz9p7MwvJF5qOKOhhZPzd5qRDbnIhC0z+m35Bt
	6bX8bygCdrC/27zed38tWpPLk/Zw4NpEUdjIUezBbUVthKOP4302ptUF7WBQN5sNEmKdiy
	kBOs7wez1kszHXi51T+PhYqSsRGfdtQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="nJF/rf8M";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753231513; x=1784767513;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=m426WV1lDKEaPLng1dxGfobPDwFUytLJjSu785UlQ7E=;
  b=nJF/rf8MHNd2rlFASbtdiitMni9qoLNETdmULryKTJonI/5QhuTn4ORA
   JtImePhFfMxVzPjnlLxXnksR7F4FybSNszV0Vp0KEX6H+ZYnU2DKdxKBI
   u3Tw7U2M0g8iWe+bXaK6CedktG5qSM5mNQ6dZvcLdn+DzeuA/QQEgqMnv
   LZoqKP40ZVKVDPfUSXZ8uhLU+ym4oXAusFFaABiWCan8EiXnhUjBg2fMa
   DowYQC8TKq8UBG+LQzLZJW8hhoxZaStn1eGhPx4hDhVg8Rdu994+gCeSB
   tL9QXDJ3zhWtihjzAqG0kpw4lh4iS7duGRzanEh15bgrUostA6mr3ymZw
   g==;
X-CSE-ConnectionGUID: v3ChX2RCSCiz3jKNowj1Lw==
X-CSE-MsgGUID: 4NYNTLuATf6d+VLSqRb6/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="55348818"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55348818"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 17:45:11 -0700
X-CSE-ConnectionGUID: 706r2HHuRv625sILRACQ3Q==
X-CSE-MsgGUID: Uv2GzgKdTpedaycps3ofeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="159038253"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 22 Jul 2025 17:45:04 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ueNbR-000IpT-1V;
	Wed, 23 Jul 2025 00:45:01 +0000
Date: Wed, 23 Jul 2025 08:44:58 +0800
From: kernel test robot <lkp@intel.com>
To: Pingfan Liu <piliu@redhat.com>, bpf@vger.kernel.org
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
	kexec@lists.infradead.org, KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCHv4 04/12] bpf: Introduce decompressor kfunc
Message-ID: <202507230813.M1tmyREU-lkp@intel.com>
References: <20250722020319.5837-5-piliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722020319.5837-5-piliu@redhat.com>
X-Rspamd-Queue-Id: 523514000C
X-Stat-Signature: r7tkpedhib7gkpihfomehhcxtqa9waiz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753231512-80432
X-HE-Meta: U2FsdGVkX1/cNQOqu46i7tvg+iXJv5fqsS2rMUXWqIxWbh5NTHT5NCW/TSVZt+534WnRkwdBUUe09gfzSbJah6nWCoNHxxXVV926Wme7vrKhxSJ4u8gxk9afuFlA+hYShGvJhYwRsAuCuB4UUpziEIfvxcIpCQEtg5oNMT1V8/GzONEZV5jQ2ZBtWbtmdO7nGArfz10v2m516IN3z1SIo7oYlX3GJA7EaNA+ixGUntae32UoQoJsFvs8ngMVcJs7lALQDzQKaaiejWLBNsFypM7j7SQ0qemj38SRPYH8PozRYqRmeAxw80UE57aFtj7PkBJVb3Va+UVpsqS2jxbbT4IXHzYNHWFvZppiFge+zq/uS3t+qzG6kbQj2fbhqZyIQyEQevzfsmRf9BpnFU1l3sDMF1bFa55zC/phDb3NKfpdi0Kbv2vg5UNZhay5ZO5wsEiUSScNlSo2H6FhfTuYvjf7rxHhs8dcy+IwKKRNiCtXxs3WIHLy8Wz7Fx1o3f8WkUjPwZ34L9QlMbtf9h7K2ROIegCRMMnuv34DlaswzErsQp5HcxOrYTApaGlUXHr5z9dMk8WuAVd05Hgi/yv6snwZvKZ0p8ykW+R956RRwgayVzXvtLKQAM1+Aavrw0oRVFVAEyGTmCXfevShq/tL39lMDNagfNOJZjplx7kmKhV5r4WWrzUUOvCzsw8eZcldNtgHlhvq7W1goDT2n3SD0LOKarFrLdCUfpl17CdTtQiU2gU6LxUMpZ7ZRZB9wg89RL4gSUcXXr83ChgmpveYBIX9cDehJgd5kuV8CLlMUXJFxyd6XbiVufo4/HvfX0Uzjba3g4zprcftqWjihqpKieC0D5VdS/FROyKV/AL4YVjHfHAzeDS+dbRjjEjPET7sfbb9qw/PYJM0c0MC4/5oShdpyPAdISrj8pVR/NEW/F45t0DMPwenEPr3J4xW6/Wltuc8KKE4UpCjFR75cPm
 lcm6DRba
 fU+m4FnquWc0WwudZ+2F1C+Xszyppf0aVqBWHj+qHQpu17DmH/Rk4tb5ot1waKXNRZtYSRNlvyy5HkhTVC6bf3FTEA4wUAGB3n02J0X055TUnUvkeI15lyUSYq+QI+L9nAdY4f7KtCedLuYgvHayFZR9x+CfrJA7HtE8RWKRGVShHg2Ru+44KAyiLAefNI659oq10SDE5uDu4PtPDCSF8mjy8rd+vNRweHA/uXI3NJUkAIlkCIh9bBbogDFKYFZG4vmBucr9LNandIzQhwcIyfo8HUdikZsSWkMB8nM5Soy1xqeQSSZUTftXaa7BoiDD7zltpoJ6X73ZOKalrnZBIcyLhKnr2yc7B/rz7XQma4xG+N2lCDmYash+h/0Gd8ibIcb8sBxxQz08Jjo5Ry627CG/pyGLPG+SLWe+ae9PgiJYipKNHDHpplffBE4aYDzKnIUoY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pingfan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on bpf-next/net]
[also build test WARNING on bpf/master arm64/for-next/core linus/master v6.16-rc7]
[cannot apply to bpf-next/master next-20250722]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pingfan-Liu/kexec_file-Make-kexec_image_load_default-global-visible/20250722-100843
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git net
patch link:    https://lore.kernel.org/r/20250722020319.5837-5-piliu%40redhat.com
patch subject: [PATCHv4 04/12] bpf: Introduce decompressor kfunc
config: arm-randconfig-004-20250723 (https://download.01.org/0day-ci/archive/20250723/202507230813.M1tmyREU-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 853c343b45b3e83cc5eeef5a52fc8cc9d8a09252)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250723/202507230813.M1tmyREU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507230813.M1tmyREU-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: vmlinux: section mismatch in reference: bpf_decompress+0xbc (section: .text.bpf_decompress) -> decompress_method (section: .init.text)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

