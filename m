Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 926C6E8FDCD
	for <linux-mm@archiver.kernel.org>; Sat, 27 Dec 2025 14:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33CBD6B0005; Sat, 27 Dec 2025 09:36:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EAB46B0089; Sat, 27 Dec 2025 09:36:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CEBE6B008A; Sat, 27 Dec 2025 09:36:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 05E1A6B0005
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 09:36:17 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C6A713B4A7
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 14:36:16 +0000 (UTC)
X-FDA: 84265501152.19.C85AF34
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf22.hostedemail.com (Postfix) with ESMTP id CE6D6C0002
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 14:36:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZuQgI0tL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766846174; a=rsa-sha256;
	cv=none;
	b=4+mTA1tW9kAiHEy5a72QeQ9y2Q8MfCPZ/9mNIlsIb061n0+z2WSxgFGV5TwR/B00Nx8EwW
	gZKfpOJLCcMCJzNLTL188jRB6BPldjcMJrRB9EbjIdZybdstKW0GBQP8zi7LWsTsAELn+y
	GgF6rOvYGouUneYX7MzYLay2VeWXWwM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZuQgI0tL;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766846174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IYNG2JvwQp7/xyTUlwApxfFOMKfMS7rsdQ2y5vNt3yA=;
	b=kgIbx4WM95Z6+xbUD2GEXrpci8aMrPlvr2TZ+5f9aAuBj7Awil7FZkGA8ic7dP0AUMapFx
	0aCyXPbD5SICRHVDHr8O2oF+LW39as///Hyq+TgRIB3xdv3n4R8BV9lOO2KcHmtZBjRIGX
	qvr1X/YkSHSnPNF44l5Q/HLvVMQQxF4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766846174; x=1798382174;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XruNjXDQ+pLSmZykNsY99NzSIdjR9hrgODcg6kqeGpQ=;
  b=ZuQgI0tL6FrT6aj+jHWf7DK9Laji6okSBRUOt9aNv7MaZ+5ofV72qNQ+
   LInzhZ5pP2j3Ghk7K8+VLtBqAyFzyXu1aeoQGaFTsYBe3C71y03ylRrzA
   39mVjg8u/yG2+oHgwmImjgUsINmeQmcBE9cLIR0b/SW1VuS+Bzr4M4U5L
   IHLfrCnR+uF/txLYbSagCb7xRaDcjTUC1iTXcWfNd2lZj3UWzOVKPqSUu
   Jgmj76fW3Gma+TU2C18vLHgbGMuJJ0hTa0guqtq5Ff8x2Qa6oqft8hdfi
   IVTiKiUZuNFrWRO9Vuwe2OhKg9ZFCqCLkdDR2o21iW970raxDWvbkmrOZ
   g==;
X-CSE-ConnectionGUID: mF18ObIoT3qsSiPka2OBAQ==
X-CSE-MsgGUID: kphntdr4Sk6XnWeEH3DAOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11654"; a="94014690"
X-IronPort-AV: E=Sophos;i="6.21,180,1763452800"; 
   d="scan'208";a="94014690"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2025 06:36:12 -0800
X-CSE-ConnectionGUID: ytWJBh5gQ0SgHankNUyK4Q==
X-CSE-MsgGUID: Lzx5E9MqRXeniwUYM6lSQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,180,1763452800"; 
   d="scan'208";a="200581167"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 27 Dec 2025 06:36:08 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vZVOn-000000005sn-1JCs;
	Sat, 27 Dec 2025 14:36:05 +0000
Date: Sat, 27 Dec 2025 22:35:11 +0800
From: kernel test robot <lkp@intel.com>
To: Coiby Xu <coxu@redhat.com>, kexec@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Thomas Staudt <tstaudt@de.ibm.com>,
	Arnaud Lefebvre <arnaud.lefebvre@clever-cloud.com>,
	Baoquan he <bhe@redhat.com>, Dave Young <dyoung@redhat.com>,
	Kairui Song <ryncsn@gmail.com>, Pingfan Liu <kernelfans@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/kdump: pass dm-crypt keys to kdump kernel
Message-ID: <202512272218.ghBaSjzO-lkp@intel.com>
References: <20251226140636.1378505-1-coxu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251226140636.1378505-1-coxu@redhat.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CE6D6C0002
X-Stat-Signature: 567ef6sk9rpmdbx8wxka7jfeiiqyg1if
X-Rspam-User: 
X-HE-Tag: 1766846173-699061
X-HE-Meta: U2FsdGVkX1/hLlewNjjwgXqbgjMuVsOTyJv5koGgQSTHrqeDkLQmggpPSpsG9io5PQJ7F5cDsFnotn1gKuxKwP96F8+1tokQBW0CpFjxznLWUP0TnONnanUus5STES4Y0HGppNMvS6deSoaz0zN3CyrPZfu2Jt5LpzASvjOqVuemkYAnhmT0sPAfHuftNKAIouh0i7JI4qTsQbP5ofZe4AEhEEpY6GYwTmRulpTNtJU623l6F+QJWEaT8HjDSbK4heczupLGaACFH5J0+PMwyI1CCKbpuDnPDymm0K1XoVfQgeaxn3f97Fh6Yh0DTjOn1D6C4oQkhrgGM34KYFEnFtE4Q5wyHxmHgCxf5XinuyCGEwH2XoV6dnWJMMdAS5Ci4DFzIcOQsYJgSS0iM8BH0gIJXqRv+14Qdl2EEXTW84Mbe4/MuXVMTzy39QF0yAjlt9okS5BiewZXE12Fi3eLHddoqKYmntJguz3pQPdLO/Wu47UEs8+Fvv9hubrPS2alCsQpQY2BW4Q2eiF2eK32sjZ0tpE75JWFxa4u7inoo7tuf7Bl2bKjWDrRtPxhVu+tGMTHRFIXqVVSj54OkVJ8kLL05sTJcOp55hKJw4aXXsKjSLHouZnHarqd5TFDLPV1TXf14rbatEyCPcs9ifbGqLhwt1RugM2LtYBlweOMQxJaDfXulEWDewI4ye/B+zDeGi0Bau7XUTyh8R97NpQHrcITJYaoK5MRDDSDBDp+Rmaov4haCAXsi2W9XJA9ICbMtzqKmnL8opkZpSZNgOP0ZQcfpVdSjkh344pgk9U7j/5qEBC/Wz4vdUNJ9Hf5VNQMkm9UqAUiPeCzE6iZoeq6Z6H/pexH0734UQLXqNLd+Wc9KIWnRDXTPwMxEFqcw2Cr15XbuHBkyqeC1E+luyEFkSozvfcGKWnplGLLgHiW42Qz6SaJFH0xR31om0aSQZX9i1XTfIdTD1aGWfM09to
 wI8xUgXM
 LJ0P6XiCutbNUQs2977S3O/PEPgaxC6LH7wjp+OYRj+bydCS+ArfrfOa0LDW7Muf4oMXPTervK7vbWsKcQAbYYPA3U0IBtm4ETE8WCc0daDilJ+Br4olCVt6/cGoqTYrYIkZwiKgppBDRAXqNjylXqAD5oiCbLdo2Ups71bHEXeo3RB8aGo8xrc7wPlIOslsT6yaeeLU01ceMdvuMdoUr3MeeYEVBJXJhkKTC0Bka9G9xufvem7xZbwTmtAbrMjHoEyWu2quBcep6ZWmoQvEZsSjMhxTH+CqU5oxv/UJENu0EIwivE66OLU7HvCm5d+MLIHs4UNseueu8DJy3U+9Wm7Bzp/wQAgOZs7Vp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Coiby,

kernel test robot noticed the following build errors:

[auto build test ERROR on ccd1cdca5cd433c8a5dff78b69a79b31d9b77ee1]

url:    https://github.com/intel-lab-lkp/linux/commits/Coiby-Xu/powerpc-kdump-pass-dm-crypt-keys-to-kdump-kernel/20251226-220726
base:   ccd1cdca5cd433c8a5dff78b69a79b31d9b77ee1
patch link:    https://lore.kernel.org/r/20251226140636.1378505-1-coxu%40redhat.com
patch subject: [PATCH] powerpc/kdump: pass dm-crypt keys to kdump kernel
config: powerpc64-randconfig-001-20251227 (https://download.01.org/0day-ci/archive/20251227/202512272218.ghBaSjzO-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 4ef602d446057dabf5f61fb221669ecbeda49279)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251227/202512272218.ghBaSjzO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512272218.ghBaSjzO-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/powerpc/kexec/elf_64.c:95:9: error: call to undeclared function 'crash_load_dm_crypt_keys'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
      95 |                 ret = crash_load_dm_crypt_keys(image);
         |                       ^
   1 error generated.


vim +/crash_load_dm_crypt_keys +95 arch/powerpc/kexec/elf_64.c

    27	
    28	static void *elf64_load(struct kimage *image, char *kernel_buf,
    29				unsigned long kernel_len, char *initrd,
    30				unsigned long initrd_len, char *cmdline,
    31				unsigned long cmdline_len)
    32	{
    33		int ret;
    34		unsigned long kernel_load_addr;
    35		unsigned long initrd_load_addr = 0, fdt_load_addr;
    36		void *fdt;
    37		const void *slave_code;
    38		struct elfhdr ehdr;
    39		char *modified_cmdline = NULL;
    40		struct crash_mem *rmem = NULL;
    41		struct kexec_elf_info elf_info;
    42		struct kexec_buf kbuf = { .image = image, .buf_min = 0,
    43					  .buf_max = ppc64_rma_size };
    44		struct kexec_buf pbuf = { .image = image, .buf_min = 0,
    45					  .buf_max = ppc64_rma_size, .top_down = true,
    46					  .mem = KEXEC_BUF_MEM_UNKNOWN };
    47	
    48		ret = kexec_build_elf_info(kernel_buf, kernel_len, &ehdr, &elf_info);
    49		if (ret)
    50			return ERR_PTR(ret);
    51	
    52		if (IS_ENABLED(CONFIG_CRASH_DUMP) && image->type == KEXEC_TYPE_CRASH) {
    53			/* min & max buffer values for kdump case */
    54			kbuf.buf_min = pbuf.buf_min = crashk_res.start;
    55			kbuf.buf_max = pbuf.buf_max =
    56					((crashk_res.end < ppc64_rma_size) ?
    57					 crashk_res.end : (ppc64_rma_size - 1));
    58		}
    59	
    60		ret = kexec_elf_load(image, &ehdr, &elf_info, &kbuf, &kernel_load_addr);
    61		if (ret)
    62			goto out;
    63	
    64		kexec_dprintk("Loaded the kernel at 0x%lx\n", kernel_load_addr);
    65	
    66		ret = kexec_load_purgatory(image, &pbuf);
    67		if (ret) {
    68			pr_err("Loading purgatory failed.\n");
    69			goto out;
    70		}
    71	
    72		kexec_dprintk("Loaded purgatory at 0x%lx\n", pbuf.mem);
    73	
    74		/* Load additional segments needed for panic kernel */
    75		if (IS_ENABLED(CONFIG_CRASH_DUMP) && image->type == KEXEC_TYPE_CRASH) {
    76			ret = load_crashdump_segments_ppc64(image, &kbuf);
    77			if (ret) {
    78				pr_err("Failed to load kdump kernel segments\n");
    79				goto out;
    80			}
    81	
    82			/* Setup cmdline for kdump kernel case */
    83			modified_cmdline = setup_kdump_cmdline(image, cmdline,
    84							       cmdline_len,
    85							       "elfcorehdr",
    86							       image->elf_load_addr);
    87			if (!modified_cmdline) {
    88				pr_err("Setting up cmdline for kdump kernel failed\n");
    89				ret = -EINVAL;
    90				goto out;
    91			}
    92			cmdline = modified_cmdline;
    93			cmdline_len = strlen(cmdline) + 1;
    94	
  > 95			ret = crash_load_dm_crypt_keys(image);
    96			if (ret == -ENOENT) {
    97				kexec_dprintk("No dm crypt key to load\n");
    98			} else if (ret) {
    99				pr_err("Failed to load dm crypt keys\n");
   100				return ERR_PTR(ret);
   101			}
   102	
   103			if (image->dm_crypt_keys_addr != 0) {
   104				modified_cmdline = setup_kdump_cmdline(image, cmdline,
   105								       cmdline_len,
   106								       "dmcryptkeys",
   107								       image->dm_crypt_keys_addr);
   108				if (!modified_cmdline) {
   109					pr_err("Setting up cmdline for kdump kernel failed\n");
   110					ret = -EINVAL;
   111					goto out;
   112				}
   113				cmdline = modified_cmdline;
   114			}
   115		}
   116	
   117		if (initrd != NULL) {
   118			kbuf.buffer = initrd;
   119			kbuf.bufsz = kbuf.memsz = initrd_len;
   120			kbuf.buf_align = PAGE_SIZE;
   121			kbuf.top_down = false;
   122			kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
   123			ret = kexec_add_buffer(&kbuf);
   124			if (ret)
   125				goto out;
   126			initrd_load_addr = kbuf.mem;
   127	
   128			kexec_dprintk("Loaded initrd at 0x%lx\n", initrd_load_addr);
   129		}
   130	
   131		ret = get_reserved_memory_ranges(&rmem);
   132		if (ret)
   133			goto out;
   134	
   135		fdt = of_kexec_alloc_and_setup_fdt(image, initrd_load_addr,
   136						   initrd_len, cmdline,
   137						   kexec_extra_fdt_size_ppc64(image, rmem));
   138		if (!fdt) {
   139			pr_err("Error setting up the new device tree.\n");
   140			ret = -EINVAL;
   141			goto out;
   142		}
   143	
   144		ret = setup_new_fdt_ppc64(image, fdt, rmem);
   145		if (ret)
   146			goto out_free_fdt;
   147	
   148		if (!IS_ENABLED(CONFIG_CRASH_HOTPLUG) || image->type != KEXEC_TYPE_CRASH)
   149			fdt_pack(fdt);
   150	
   151		kbuf.buffer = fdt;
   152		kbuf.bufsz = kbuf.memsz = fdt_totalsize(fdt);
   153		kbuf.buf_align = PAGE_SIZE;
   154		kbuf.top_down = true;
   155		kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
   156		ret = kexec_add_buffer(&kbuf);
   157		if (ret)
   158			goto out_free_fdt;
   159	
   160		/* FDT will be freed in arch_kimage_file_post_load_cleanup */
   161		image->arch.fdt = fdt;
   162	
   163		fdt_load_addr = kbuf.mem;
   164	
   165		kexec_dprintk("Loaded device tree at 0x%lx\n", fdt_load_addr);
   166	
   167		slave_code = elf_info.buffer + elf_info.proghdrs[0].p_offset;
   168		ret = setup_purgatory_ppc64(image, slave_code, fdt, kernel_load_addr,
   169					    fdt_load_addr);
   170		if (ret)
   171			pr_err("Error setting up the purgatory.\n");
   172	
   173		goto out;
   174	
   175	out_free_fdt:
   176		kvfree(fdt);
   177	out:
   178		kfree(rmem);
   179		kfree(modified_cmdline);
   180		kexec_free_elf_info(&elf_info);
   181	
   182		return ret ? ERR_PTR(ret) : NULL;
   183	}
   184	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

