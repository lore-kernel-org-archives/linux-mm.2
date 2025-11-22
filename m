Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E98D3CF64B1
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 04:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3990C6B0010; Fri, 21 Nov 2025 23:56:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348686B0011; Fri, 21 Nov 2025 23:56:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 237766B0012; Fri, 21 Nov 2025 23:56:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A96C6B0010
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 23:56:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79FE75954A
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 04:56:35 +0000 (UTC)
X-FDA: 84137032350.03.3ACEEF9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf07.hostedemail.com (Postfix) with ESMTP id 19FD940003
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 04:56:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Gwx1Hucw;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763787393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yuA3YWeLSsaqbfc364gnRkQWvn7S9drMMnYRnYCpi1Q=;
	b=FabE1eDn9/acV3aPQ6qYb01tDMC/KscyAumdcf0lJQ+fPnRO1s+yZDQ45EPmzIUGsFrNCv
	Hpg1or2ozUhoAUq0XZYKaZ7oN+VL3ir46HUocaO7onfEDAMUVv0rjTuIhAiNvqCJg6WcZT
	o69Z4MPueAs7nSbuVylBO0rWh3ylD4w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Gwx1Hucw;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763787393; a=rsa-sha256;
	cv=none;
	b=qhUM2zwWhvy1eI9XlR+SQV1HyzExVpe2XkhDSA+dW0t+KNU2CY1qQqibF2ytqxdhGBz52M
	h/04b7o7lxVyY0rxNXgh+vw2Vg47UJ5nmulKoc2DzaDv4EHHvpTl/LxSrBKR+Cn24VD+1Y
	wX/WcteURzp5QH8LlW7AlyN2E6HgZwE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763787393; x=1795323393;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RpAta5pW7pTRynNxwbJLZvj/eo8rVxs+scWqmeP4VCc=;
  b=Gwx1Hucw5Z1s0UU49yblrOqGOD7xBnzZxuTGwiPqEPHxLI3NoqWpHVmN
   hOVR2tPKf/271KF0b+ryu6QG3ab25dpL5adE1UVSl00I3bOUxlY9JGjRA
   /5JTZv5GicNc3H9Wu2QXNZFrxkEw/dXNvkWufeLRw+FvjFIT5IGwty8NB
   35hTARrLYDz+jObZg1m1jLUgLvvKU9tlnbsaY6T2QtAS1C0xuVmA4jlS8
   qRQKL8eYFczfup1ddLXyZabgNwGEGhjSvGM7SEPlMzl+pVSGGxyKhJh1W
   4ynH3KjH+uyL8hoffU9jaiqE6j8LMNMnulk8Ps/oqXwTYi2Ku2JXt64Qu
   A==;
X-CSE-ConnectionGUID: RVHMFAI2T5Cshf1yIVWhDg==
X-CSE-MsgGUID: 9v3AuDSZQuGMaZ/u02CO1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11620"; a="65068432"
X-IronPort-AV: E=Sophos;i="6.20,217,1758610800"; 
   d="scan'208";a="65068432"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 20:56:31 -0800
X-CSE-ConnectionGUID: TyUuip1jSRSAWl7cfJynJA==
X-CSE-MsgGUID: rNBLW3izQzutdtYWUy0/fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,217,1758610800"; 
   d="scan'208";a="222811795"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 21 Nov 2025 20:56:26 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vMffc-0007AZ-1E;
	Sat, 22 Nov 2025 04:56:24 +0000
Date: Sat, 22 Nov 2025 12:55:58 +0800
From: kernel test robot <lkp@intel.com>
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	tglx@linutronix.de, andersson@kernel.org, pmladek@suse.com,
	rdunlap@infradead.org, corbet@lwn.net, david@redhat.com,
	mhocko@suse.com
Cc: oe-kbuild-all@lists.linux.dev, tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com, linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org, jonechou@google.com,
	rostedt@goodmis.org, linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: Re: [PATCH 23/26] soc: qcom: Add minidump driver
Message-ID: <202511221252.PPEXScZ2-lkp@intel.com>
References: <20251119154427.1033475-24-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119154427.1033475-24-eugen.hristev@linaro.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 19FD940003
X-Stat-Signature: 7zgasiecd8q4fdr8pg8q4d9eynh4n363
X-Rspam-User: 
X-HE-Tag: 1763787392-164547
X-HE-Meta: U2FsdGVkX19Bpce2UJJqhO28pSM6qc7O3W7kS6jh9Hsn86IyWLcx+MOFQ2umPsRqbKOPOtl9nfSv82SL8Mc3dDix3lqILJVtYBBpAnZfiNq8IUMTjrgikX9g0KchjLzUH4yiZDzjnW3sB8y+cufKrGur2ypv0Cgne3j9LzqYGXcmUqaHwgFOZES9tC1zFz8PMN73Gpmho3t4Na7bD7Li5XWthgbTHuRXQmHplqkGHr6yeMfak2wkv7tdseigOLYhKluVsBWAOWo1aXoP0ySxDoYlSTSKx8gFoyFHQ1bDYduNavispgoSNz2fFZax5RAblzaqAyAXTrDRfVsj29cHJfOvPzSLOVAxYal8J7f6jklet72NzVIEM2CLGhAC11vcjQuXfYNLpOwFMnszm9uZJqLyE5u2ZQGe60vP6xsYiPRl3N/gbn2B/xQ280ZDyLHZoiWoxYjve0KHqvpZwCYPZJ5LIuYa13PbsfVnVBGQ0UCxOz8qzSk8qoMTFnB0uGBNOt7AlRephcePceHY5jLwv/P8339tD2bfj4RYQhC/RfsUcuOdTciN4Nnl9MWP6VA0cnOSIV4X6dFQ39Qsr4LC8ht/FW3ggBKa0WNbWSO66uG5TI7iWzSs+3jU0sTXVGz1K1dAhlne63hKVOLUAcbdvDqJA50ZsflzBjGONdmJBsgDM6T3bfxw88CKLk3yx0cd3jit/XqM9VytHToCxowIopXIsduvrqrsxr9yaFGU8hONjPv00GBxfu5FmV2X/0zYn/6FDQm17kKw2TreoE7jPFR2e6Ugs56/6mIvnyoQnifygKwV+rJAkjogwLRX8PPlQWXl4CgZMSNO4/x+cTn52mC07GbW+29qnK+skYdjqktc26xkQni2Nqpi7PPRX+Fa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Eugen,

kernel test robot noticed the following build warnings:

[auto build test WARNING on rppt-memblock/fixes]
[also build test WARNING on linus/master v6.18-rc6]
[cannot apply to akpm-mm/mm-everything rppt-memblock/for-next next-20251121]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Eugen-Hristev/kernel-Introduce-meminspect/20251119-235912
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
patch link:    https://lore.kernel.org/r/20251119154427.1033475-24-eugen.hristev%40linaro.org
patch subject: [PATCH 23/26] soc: qcom: Add minidump driver
config: nios2-randconfig-r123-20251122 (https://download.01.org/0day-ci/archive/20251122/202511221252.PPEXScZ2-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251122/202511221252.PPEXScZ2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511221252.PPEXScZ2-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/soc/qcom/minidump.c:108:35: sparse: sparse: restricted __le32 degrades to integer
>> drivers/soc/qcom/minidump.c:154:22: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [usertype] seq_num @@     got unsigned int enum meminspect_uid const id @@
   drivers/soc/qcom/minidump.c:154:22: sparse:     expected restricted __le32 [usertype] seq_num
   drivers/soc/qcom/minidump.c:154:22: sparse:     got unsigned int enum meminspect_uid const id
>> drivers/soc/qcom/minidump.c:184:19: sparse: sparse: unsigned value that used to be signed checked against zero?
   drivers/soc/qcom/minidump.c:183:39: sparse: signed value source

vim +108 drivers/soc/qcom/minidump.c

    93	
    94	/**
    95	 * qcom_md_get_region_index() - Lookup minidump region by id
    96	 * @md: minidump data
    97	 * @id: minidump region id
    98	 *
    99	 * Return: On success, it returns the internal region index, on failure,
   100	 *	returns	negative error value
   101	 */
   102	static int qcom_md_get_region_index(struct minidump *md, int id)
   103	{
   104		unsigned int count = le32_to_cpu(md->toc->region_count);
   105		unsigned int i;
   106	
   107		for (i = 0; i < count; i++)
 > 108			if (md->regions[i].seq_num == id)
   109				return i;
   110	
   111		return -ENOENT;
   112	}
   113	
   114	/**
   115	 * register_md_region() - Register a new minidump region
   116	 * @priv: private data
   117	 * @e: pointer to inspect entry
   118	 *
   119	 * Return: None
   120	 */
   121	static void __maybe_unused register_md_region(void *priv,
   122						      const struct inspect_entry *e)
   123	{
   124		unsigned int num_region, region_cnt;
   125		const char *name = "unknown";
   126		struct minidump_region *mdr;
   127		struct minidump *md = priv;
   128	
   129		if (!(e->va || e->pa) || !e->size) {
   130			dev_dbg(md->dev, "invalid region requested\n");
   131			return;
   132		}
   133	
   134		if (e->id < ARRAY_SIZE(meminspect_id_to_md_string))
   135			name = meminspect_id_to_md_string[e->id];
   136	
   137		if (qcom_md_get_region_index(md, e->id) >= 0) {
   138			dev_dbg(md->dev, "%s:%d region is already registered\n",
   139				name, e->id);
   140			return;
   141		}
   142	
   143		/* Check if there is a room for a new entry */
   144		num_region = le32_to_cpu(md->toc->region_count);
   145		if (num_region >= MAX_NUM_REGIONS) {
   146			dev_dbg(md->dev, "maximum region limit %u reached\n",
   147				num_region);
   148			return;
   149		}
   150	
   151		region_cnt = le32_to_cpu(md->toc->region_count);
   152		mdr = &md->regions[region_cnt];
   153		scnprintf(mdr->name, MAX_REGION_NAME_LENGTH, "K%.8s", name);
 > 154		mdr->seq_num = e->id;
   155		if (e->pa)
   156			mdr->address = cpu_to_le64(e->pa);
   157		else if (e->va)
   158			mdr->address = cpu_to_le64(__pa(e->va));
   159		mdr->size = cpu_to_le64(ALIGN(e->size, 4));
   160		mdr->valid = cpu_to_le32(MINIDUMP_REGION_VALID);
   161		region_cnt++;
   162		md->toc->region_count = cpu_to_le32(region_cnt);
   163	
   164		dev_dbg(md->dev, "%s:%d region registered %llx:%llx\n",
   165			mdr->name, mdr->seq_num, mdr->address, mdr->size);
   166	}
   167	
   168	/**
   169	 * unregister_md_region() - Unregister a previously registered minidump region
   170	 * @priv: private data
   171	 * @e: pointer to inspect entry
   172	 *
   173	 * Return: None
   174	 */
   175	static void __maybe_unused unregister_md_region(void *priv,
   176							const struct inspect_entry *e)
   177	{
   178		struct minidump_region *mdr;
   179		struct minidump *md = priv;
   180		unsigned int region_cnt;
   181		unsigned int idx;
   182	
   183		idx = qcom_md_get_region_index(md, e->id);
 > 184		if (idx < 0) {
   185			dev_dbg(md->dev, "%d region is not present\n", e->id);
   186			return;
   187		}
   188	
   189		mdr = &md->regions[0];
   190		region_cnt = le32_to_cpu(md->toc->region_count);
   191	
   192		/*
   193		 * Left shift one position all the regions located after the
   194		 * region being removed, in order to fill the gap.
   195		 * Then, zero out the last region at the end.
   196		 */
   197		memmove(&mdr[idx], &mdr[idx + 1], (region_cnt - idx - 1) * sizeof(*mdr));
   198		memset(&mdr[region_cnt - 1], 0, sizeof(*mdr));
   199		region_cnt--;
   200		md->toc->region_count = cpu_to_le32(region_cnt);
   201	}
   202	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

