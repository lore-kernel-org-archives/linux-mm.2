Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CAB2C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 16:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 810156B00A0; Tue, 22 Jul 2025 12:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E8026B00A1; Tue, 22 Jul 2025 12:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7249F6B00A2; Tue, 22 Jul 2025 12:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 633EE6B00A0
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:42:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 117A216045C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:42:22 +0000 (UTC)
X-FDA: 83692468524.13.54490EE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf07.hostedemail.com (Postfix) with ESMTP id D133640007
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:42:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="ihS9mnO/";
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753202540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjkGJYwCT+KxLmmG6lvIaGMMdDQ9qBztMngIEEAngj4=;
	b=7pleRViSHsU8uCaroTyRoJiWVLqqUs8ujoTeO+sbN17kk9JP5LIxxVU79Bjqoz8W9Imgh5
	Og8gEO38b5XHe57SCoN7czjYyYkDNMjuHpoWrAcMPeMUM5pUTGT0d1cyZoImsgAzXyHus4
	reGI5spsMnKqeCqkr9VuqE2IpEBuVRk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753202540; a=rsa-sha256;
	cv=none;
	b=qdinB0qkZozmD2I1o0gPkHgaOHSkokxcyYdz+wfpIveIvVBAoA8e4RunOq+7WsSWTNy452
	94O0+Ce0YH0pWSAhAPvX94Ph7LW9hhbhbwWwhsHSlTPoeWX4qALl2E75sbCIDKkxANGuzu
	YoGvblLNPgfciqa0bCV/W+ytNHeyQOk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="ihS9mnO/";
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753202541; x=1784738541;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RaJ+Jpxw4Z1gkEyO0AntIYQXlU/FNtY01F1LH3AHnLs=;
  b=ihS9mnO//BPmrALLZ+4O8qbyVB6QKIIo7rsZRamN0B0SePN5jMxmkBHE
   8kzyZxtd3NpApNO06CRYpmymWLVrUr35e/WdGJsCxczKsfKp7TyPImAj5
   0pkKFnp3nvqOoi0QxDhjimv6ongeMYwq4w8rdJmX3fAa6JlrBXcazgqnR
   hDJeLg2O8G3Usq2Jr68g92WeKFSnn7K2SMjIkjukymxA2T9LiW+zuYfKN
   7iWYnvzilw+WiP9XYJflu4AveP90l7IbzRLlBBh4xS0sfR/L+x/Gk5Bze
   0xRtZcKrE6cVfqIPCxBiQiWo8k3LRjvnf2s9bdiTGV+u8lNffNb/6NEu2
   w==;
X-CSE-ConnectionGUID: US3CoY6VTjSYXeL7N62hrw==
X-CSE-MsgGUID: BKreqsajQ0SksWbDvUS06A==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="55611987"
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="55611987"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 09:42:20 -0700
X-CSE-ConnectionGUID: QdnwgSZkTSWNugI+qCkkpw==
X-CSE-MsgGUID: OnyzoUzLQze6vfH2jpY8cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,331,1744095600"; 
   d="scan'208";a="163430987"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 22 Jul 2025 09:42:12 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ueG49-000IXj-0d;
	Tue, 22 Jul 2025 16:42:09 +0000
Date: Wed, 23 Jul 2025 00:42:08 +0800
From: kernel test robot <lkp@intel.com>
To: Pingfan Liu <piliu@redhat.com>, bpf@vger.kernel.org
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
	kexec@lists.infradead.org, KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCHv4 03/12] bpf: Introduce bpf_copy_to_kernel() to buffer
 the content from bpf-prog
Message-ID: <202507230035.9xLXz9Js-lkp@intel.com>
References: <20250722020319.5837-4-piliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722020319.5837-4-piliu@redhat.com>
X-Rspamd-Queue-Id: D133640007
X-Stat-Signature: 54a6dfutqczdozcpt99hafy7oj9hwcb1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753202539-175278
X-HE-Meta: U2FsdGVkX1++hCv8zSIuyOthXnqRYUOpXsiboJ0DsmEjENTqAPp4/WDhuSes1aT2H2bFxQmilu1IwL7h4WJdYvnuJRje+PtMRbDBIt8CF9SaydU8/2VOLJ9DomYpL1iNGbLa5mg4i9pTUTHfeJ8YZypq6TvpqdOgPQpAz6jcYHP0nmKFR+cDIiDvqMLDhWvRAwIwunVou5Cw+FIriQIs79lYm0sFE9ZH5EbQLJIwbxdVhMvnvvStxSUDuc7tLDiEMHkR9tRtXBw7W8bMULj+wJjgQICibDzb1dBOh1b48eQHGpMU7RWx+2P5IlXsBnkDd/1ypzY49RbnxwkiaFsTrBo/vScn5qswhP7BIBjXVy81iOmz68H/VEJxbvPYaV6QHh+OziPW8RmagCR4onPQv9xejMskKE0v9XUD+I+LqFUdvJYu8V4f2SI5w65QD7HsIkfxyQQyjkkML7a36IAwUoas3PEBVGk1EseLwbyHU8SowQ5rpKrztanXp/ykMYFsf6keCSaAuhPl8ZuyoRNexm63UdKewTDEtV8HK4e6VfzldJbHt3NJbENyzHsIl+W1g0tPXVMf/ckyjKstnc2FXTBy26c+G5t7IZ00JhJwq18xgNcWxEjqmBOAzUQQgp4aF/M6V617KRyUR68M7DCyN0w031j0FbQHek/tCYtplkfbzBVUC6MROYtoDmP0bk6e9axvVT8moM51N5yz7YI2EyQ2cakKbIuqQKG2Xqcrn+p+iBFABUfYQgR5JtskTClHbsRgWOaLMb0e7X/pVX/LkiAlUPcU8oVgF2iEaIgvV8lTF5PyLEzK7u5wBxM7H/6bwZn5NnVOFE6dqSMtWABiYGqGoHiBHT4UC6GXtlfqwmdf819lN2NCOmw1y0Rt0NUH5sWeLogt17JXS+CRS1e0fdLuWfdyJH4eN3iCSYcW5OpEnxuK8UKeMZrU+f4bGmGeuWHxz7eY8+ABLjkiKcu
 B/LUWFrP
 DIQahslSYHtAC4WvOYEemF32Gwb9Jd7J6LcHMNqvH39GhZOt447uCCKOAwdsODq/Emtn56fIEPk9RMW8E+W/tOqFKnfZzEuBTb3q8rGLCej14PZ8ITR4l37nNMJYIOSKnXvAPqizOUig9In+9mzugr9ggZN7GRqRn8sRZGlzST4aN/yh65gw44nofmuq9jDXBDJZMKLPcCArmfQwtnTCtvTN77mFXaOKSnxG5Y8b75G96X3SXwJ84lc3KRCVc1YpPJIp/dzveSTRRHgH8nRimHI4m1sELIdCYxTtWaCUqsVrnggkI3YocBgkevlcrSrUlzY334KIqGeYsmwyzot6K7TiwOtn31IpiyDDlkkYjuGKYfwDGfgaIqQeoKzlRbGlejpWsavxMeiTxNXzjyBscQuWteLnskwl4HmEkuKiTKBTVKgOf+AMxVUyltRl8D2r2+3n20/mgoA/fyc18+JUa9/02zrdaEoAZUMAQKJfdidFrnQavGYsS6jdNDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pingfan,

kernel test robot noticed the following build errors:

[auto build test ERROR on bpf-next/net]
[also build test ERROR on bpf/master arm64/for-next/core linus/master v6.16-rc7]
[cannot apply to bpf-next/master next-20250722]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pingfan-Liu/kexec_file-Make-kexec_image_load_default-global-visible/20250722-100843
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git net
patch link:    https://lore.kernel.org/r/20250722020319.5837-4-piliu%40redhat.com
patch subject: [PATCHv4 03/12] bpf: Introduce bpf_copy_to_kernel() to buffer the content from bpf-prog
config: x86_64-buildonly-randconfig-003-20250722 (https://download.01.org/0day-ci/archive/20250723/202507230035.9xLXz9Js-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250723/202507230035.9xLXz9Js-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507230035.9xLXz9Js-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   kernel/bpf/helpers_carrier.c:84:17: warning: no previous prototype for 'bpf_mem_range_result_put' [-Wmissing-prototypes]
      84 | __bpf_kfunc int bpf_mem_range_result_put(struct mem_range_result *result)
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/helpers_carrier.c:93:17: warning: no previous prototype for 'bpf_copy_to_kernel' [-Wmissing-prototypes]
      93 | __bpf_kfunc int bpf_copy_to_kernel(const char *name, char *buf, int size)
         |                 ^~~~~~~~~~~~~~~~~~
   kernel/bpf/helpers_carrier.c: In function 'bpf_copy_to_kernel':
>> kernel/bpf/helpers_carrier.c:124:9: warning: enumeration value 'TYPE_VMAP' not handled in switch [-Wswitch]
     124 |         switch (alloc_type) {
         |         ^~~~~~
--
>> ld: mm/mmu_notifier.o:mm/mmu_notifier.c:25: multiple definition of `__pcpu_unique_srcu_srcu_data'; kernel/bpf/helpers_carrier.o:kernel/bpf/helpers_carrier.c:13: first defined here

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

