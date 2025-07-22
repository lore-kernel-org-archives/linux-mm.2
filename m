Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6354CC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 17:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E02206B00A1; Tue, 22 Jul 2025 13:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD9826B00A2; Tue, 22 Jul 2025 13:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D170D6B00A3; Tue, 22 Jul 2025 13:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C20EE6B00A1
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 13:23:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C437C043A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:23:28 +0000 (UTC)
X-FDA: 83692572096.17.6A47DBB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf07.hostedemail.com (Postfix) with ESMTP id D86A440005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:23:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MT61Rebn;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753205005; a=rsa-sha256;
	cv=none;
	b=hNnHnf6Z0kVuZvGh0huGHm7Fb2LBzkIWpSZtLTf6y0UPOhONkcm5F9GMTRSlVZWCfh2/pK
	QuQOPVjIDDfKJGFmzODjzEIFWAsegykObyhwVhHUjxZWrWctjJ+vf80uU8HuwN5UJU+qXD
	DpfF6wXVxFGnE9t3Ow5ggP/TWs1HZjg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MT61Rebn;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753205005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLbXCw0F2QvZ7bBY7GP88H5v/+ABMtOq6lHh/3EqNic=;
	b=UORhDC0SAbCcQg08IsXHRH8y71b2LEKMCfCPRH3NajVGXAruu35QKbNdMT2WVksBr9nlt5
	el7bHsuWqDvt3YWnTiU0IiCweVf22REqf9YHdDkggBGf9A8hAWD2V5OogG930SJUsA2uxa
	MNyvVN8u/PVp4G1leZs8OMeuVGqhaE8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753205005; x=1784741005;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8tLBsgDMoKYn/cmEEtG36C5Re6c2A8hBzfa0rJS9qf8=;
  b=MT61RebnLuHZKV+I0TmoXAVUPW7/HF40SKrbQSh8NhOtGXvLs/EDjpYz
   oJ0KDD1HJKDT/2Gg2Z0nR+3ZcGJikfZ2Z3kUK8xz9U2HL5h4qwlP+mzMd
   9D/+CRPRUI2g0ThLvhT32rz3bsKnE8HEuAlmrzQjnF1KNkpgpo9//FBBw
   535Ne/eEJYdk9GUBrBn1kY8wunvCmNPzeaYtFXoFq32JzbRuiZx8ef5gV
   1hhcg1A1jPIo2gyUQmCWyc13m17ZJUh6PIQ2Bkp5uo1BnD9M19yukVu1F
   QT3LQPdDrJs22cY7sM+t7d4EIIES3l6rfn01RywopgDL78m644bTfy6Zc
   g==;
X-CSE-ConnectionGUID: H73SyQxcQpCdOfAt9OAyUw==
X-CSE-MsgGUID: Pm7zUL/1RZe3cmmKrdPfJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="55617278"
X-IronPort-AV: E=Sophos;i="6.16,332,1744095600"; 
   d="scan'208";a="55617278"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 10:23:23 -0700
X-CSE-ConnectionGUID: T62YgRhbStu03UHmIKqpvQ==
X-CSE-MsgGUID: vlVplxbJSAyI/3mxscLURw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,332,1744095600"; 
   d="scan'208";a="158503142"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 22 Jul 2025 10:23:17 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ueGhv-000IaD-1j;
	Tue, 22 Jul 2025 17:23:15 +0000
Date: Wed, 23 Jul 2025 01:22:56 +0800
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
	bpf@vger.kernel.org
Subject: Re: [PATCHv4 08/12] kexec: Factor out routine to find a symbol in ELF
Message-ID: <202507230016.NQ1WXqwG-lkp@intel.com>
References: <20250722020319.5837-9-piliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722020319.5837-9-piliu@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D86A440005
X-Stat-Signature: xcyxw455us8n39zbpmzddrr8o6xibkod
X-Rspam-User: 
X-HE-Tag: 1753205004-777887
X-HE-Meta: U2FsdGVkX1+TwIUorqLfVijz2BaywKeJDkum+Rnp3r12L2aADcRERzvyqLuIvE68QJ/n4+xLJr8GUFRqf3HiLLmZL0TxuHoQkqFQATZOJH9EeSJckJaFAHYStwUVOcLlmMK6LcKbVmEx7r792DDP0FxpjgtJVGKSABtn3G9VTb9pDVHjqD3lCGFgiUqG5VsjrraWvSjmAYbcewnYqY1+ZyfDOUJO9gpwYzbOv0m/zJmghWr68VHeoJh+EkydJjocUeNQF/Cmdv/jrzOA7LoZthSfRlURq2G3Gz5spt1eA0MW89Qdp0kQkcWqvNGyalz7LzXPgSJ6jZcqyaFx5rJx6SmbPUnjNznPGms4ja/2VJ61T7aZevF2uhAItz3v1Ls2XjYdAn8dh+eBmBtyGLusrW1YDhmcSuuBLOhIfH74NDYLpDtd/QTE9ColuiFoBVRYvC0lBzc/R/d8t+I+1dp6kMNTkQQaGX7rcb0BzlcURbiVuvIV4ybSPjLpmcZmR5g1+uGmvR9E/y//5hT+NsfV/79JSnQliIurLGJGCzUmGYBAtOxgxr0StJxh/NmNJR67maEZQODwehK+sLnUynSYNUF2YeolvC8XGAAGVmnDZI4mLPZmS3L/P0MP/adW4+Z4qM4/dOOGvtDrM/lSvlpeCHCxHzscIJLIQQbJt0e0mZxbj4jNhcZgDhrqyETCGryg2hHYHprfoWBheCTZi5wlIzR3Hly6EywjO2FV9ajpxvdqJvKuhLnKSCna0bEiuIumKTkIEIUPynicH6k1GTZFsoxX5KRutFinOzWFbfjZVKEQFD7NcxBHZi3lt6wDgJI8mr57HltilTMIEcNT24oI+gAROrxNPUghCYhXuL0Nl60UsvoXL0fVkUpRD1hJb+5ptbziGuxJrkmuKbIqGuSmb+1W7YjTvdYVE5/rQI5W/ksePLRegLKFTznfySBtdW5fHIod+lp+mkp8dFwz+ZX
 LFpjAVKX
 kCpfB7blP27rK6GvgQWAoJeIS02O7NJcDGv/E35Lnu+Xfv2ndIVX+hJemmfCuEHUWaQx4KyK5DsNwsh/R6G9SZbA88a+ZFCdUkX/LGwJo3ctAbJqgl7sFhNHLwLN7HEFm6wz7SY7vvFfTOQ1t/0VqvX8fPqC33jE84j32X14avIJUJeQQUQSjeB1hjT1uFqYZtq1aX8/pf3+/llUATMedLJs8mH12b/JBOGwiz3ycHZoyzrLX4nybUpAvGa8khBOxwGv5n/fmoU6petqpdqTou4zj+3Fb9FDUcoMzmu+60mC3PtzTA/U0mP0a+PUVRifWh8ewWymyl+/glgKRoD35Defak9SYIt8ntRtrMlsFetPs8hnKHY979hCVyFsUdkqHfEkGRwQjc1QVuR9lvikYrKQ5jbsT1rjRetIes2CNpDl6xVg+j0JGqr5eest5VA+1sfY9
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
patch link:    https://lore.kernel.org/r/20250722020319.5837-9-piliu%40redhat.com
patch subject: [PATCHv4 08/12] kexec: Factor out routine to find a symbol in ELF
config: x86_64-buildonly-randconfig-006-20250722 (https://download.01.org/0day-ci/archive/20250723/202507230016.NQ1WXqwG-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250723/202507230016.NQ1WXqwG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507230016.NQ1WXqwG-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/crash_dump.h:5,
                    from drivers/of/fdt.c:11:
>> include/linux/kexec.h:544:7: error: unknown type name 'Elf_Sym'
     544 | const Elf_Sym *elf_find_symbol(const Elf_Ehdr *ehdr, const char *name);
         |       ^~~~~~~
>> include/linux/kexec.h:544:38: error: unknown type name 'Elf_Ehdr'
     544 | const Elf_Sym *elf_find_symbol(const Elf_Ehdr *ehdr, const char *name);
         |                                      ^~~~~~~~


vim +/Elf_Sym +544 include/linux/kexec.h

   542	
   543	#if defined(CONFIG_ARCH_SUPPORTS_KEXEC_PURGATORY) || defined(CONFIG_KEXEC_PE_IMAGE)
 > 544	const Elf_Sym *elf_find_symbol(const Elf_Ehdr *ehdr, const char *name);
   545	#endif
   546	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

