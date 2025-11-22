Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71475CF64B1
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 07:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC0A26B0026; Sat, 22 Nov 2025 02:55:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97E86B0027; Sat, 22 Nov 2025 02:55:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4C36B0028; Sat, 22 Nov 2025 02:55:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB646B0026
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:55:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 402F78A11C
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:55:52 +0000 (UTC)
X-FDA: 84137484144.29.B92251F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8B79A1C0007
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:55:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z2EDKPMk;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763798150; a=rsa-sha256;
	cv=none;
	b=5evb3j5B1awX1ETwvRLMICrun0woGwHP7MqZLuoqJvyv0nQe+PJbA1S28Dyi+ctNKTQXGq
	aQwtSDIgQpVbJXv7Z86OqyHLKlGB0+BF0UbJP2AGgZskrfNe/aDJesNZ1OHGzaL7OU/G64
	mpIN2QtLm/snyuVo9NJXkUgAS8LZb00=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z2EDKPMk;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763798150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QWHXPiJRYKkrps01kIqZqRVu3P4qRHYIVg+MRqwWDCs=;
	b=ZLKQ9WIZcv+x0fG7DG/T9cTlxyUg1RoJcsnOtNggXHf2lDrZz6AIpkMctgh9C38Pnak778
	mT/ucVDixQWQuDJY0y4fkXEtZFeoBEk14gBigK4bAmITTOwDTAnlQADpZCeToVut3BPIVo
	k7DLMvQQlPtI7YmUfrSUygiq1+Cb01o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763798150; x=1795334150;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SXw40nk81lfewjY1S+9hPKCWNPlyLR4zHML4HwWfuNQ=;
  b=Z2EDKPMk3krhLF/gubiVNh7Vkrj/Z4q7HbudVUI2N6oQtI4iI4cF41ZR
   q90z++dU09sUVNC3WCJWjWJMA3cjqMmmBHl6eBAD2i5+fG/L150uPjTXR
   jZ6uzG25CGOq6TWQHyHBtmQQ2Tsz02MYvLmQnqC/B1vZcs9XgFShCuyLv
   nPz82wipUiDiMk0MiU4c/Q2ZBi6dr716lv4plEQH8jkmn3r/jd4MSy7a2
   Y3Pz32uk4sQvT0N9Y4qTtXrH0H/Ih5na+MQfUTyOQpr53WoxNgJSWgkeJ
   x8S6zCMNZzvcVUmvvFlS/9dZYgygSSb3R+DmmbBIDDJ8KozKwShtPLgfa
   A==;
X-CSE-ConnectionGUID: PfQGknuLRiynI8DYBT7eWg==
X-CSE-MsgGUID: tqQQoWYSTuyrXq0yDbphow==
X-IronPort-AV: E=McAfee;i="6800,10657,11620"; a="69748448"
X-IronPort-AV: E=Sophos;i="6.20,217,1758610800"; 
   d="scan'208";a="69748448"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2025 23:55:48 -0800
X-CSE-ConnectionGUID: wOeO3mLQSJuDwYi3qD24uQ==
X-CSE-MsgGUID: AycttFy4TB+6j12x7ifhWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,217,1758610800"; 
   d="scan'208";a="222833433"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 21 Nov 2025 23:55:43 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vMiT6-0007Gp-1a;
	Sat, 22 Nov 2025 07:55:40 +0000
Date: Sat, 22 Nov 2025 15:54:59 +0800
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
Message-ID: <202511221521.2OINSDPK-lkp@intel.com>
References: <20251119154427.1033475-24-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119154427.1033475-24-eugen.hristev@linaro.org>
X-Rspamd-Queue-Id: 8B79A1C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: pk8zcsoif8sag3su6wmduewz9qjzhqct
X-Rspam-User: 
X-HE-Tag: 1763798149-741076
X-HE-Meta: U2FsdGVkX18v88cIFOYHEVP0D3NTUcVsZYJAlIHQS8mzlRPCCWoMoZK6RCQf+7ssC+REbz5bUniUWtFsVJFMPSAJ4q8B56+poCV6Y3IeER40IM5LqYes1f51uHej9jnL8whZiYaYXcZSgnwIFLFRnngkzS61ZwGyfjgYHLRVJnXaFjv4kTOLSWEbSKi0zTuVIeTEEh29oul/5ERMWKw4ykxhUzn07QwCJaW7zcU0LIe6F7WjdZpTupEhPiFhhXXTw7GtGQzvZ4p7oV0R+wzA8SHhT24QXyt4qKlkQD/WdiGHNFTEy3gRbWuovzy5OjKxSWPcGt4LG2pT/QV6yNSOQSmzaJajEJdphBBfrmpnveDFmTeShsWRxq/pWVb/HAphA5lhUGCU4XXLu6rNZmuHqhysDqyhI183kNugyHGNKt2c7n3IKJ43adQQgFk1kMIwR2ISBinnvkqGm7ym5OXwg0cJQ0pl80yThY/5pGZn/OR8w4Xm7fmgSl66k1e11WZaFYwQ5Xi9DD1pBOf48lgS5RJlkdiWyf9hn7yF3UQCzC1t/LmQrTNLJlK7cnC4bvpSgGJxlCXf0mJ1v3docvRrvcQTrNa21o5n+mhK3Nao0UCXX6Po5WWvuE4PtRiKoxdL1uYZYhuX2zIJb7CEx5bOrXQ2KyE+fbP0OKIaNLQrYP6taOWikAavU0nsemJMo63FjKIpwgOz/czYsSJOyJxF/BJDdvf7vOJ4Exp3aEwgGyUTdXNHHbmhkN9jkzGSxWTWfvEV9F0ub0SYgIwJxiQ1RmqXYzNU0/DC1WawROw2b6TxyWQE31bp8O3DN68rxhACMP3Uod7Z4gXfyZQpQK6DVWJ90VpDMrkKJDY7boTNWesBHw8uWaj+WU7jE1qiR4P7DaTjj0TFYcHXfIEKPEoOd0BncBtWZbfJgt5LGOt5J54IQ4HvIGtPGUD6lMoMFSctLbw6NRtTllT7S0XkY8C
 Au/pRCCD
 2sXdzcRj6oT28s1rqMmorMAmcqc+41U4e1DnCPbPo40pTNg5EClN7Z6Xm5BLNeAxQYgXFl62UOLEOB9I6Z14xAQksu/zwTAcrfhJzETPAQbjh2vuqkbSt7bCqe6f2H24RDhtf/S7j8+d+Dm7SuCwtJml5iOUIeA6Kem0tbFpypzD/Gtq/5FRXTBh6CccfDEtkSZ+gAHl1241eFmSUdiuheye6LCEMTKxYZ3XyiONwDAZe/jW1okpV4G2sYfC/Y6gAkVxyEb6i6Yqh4vXG69R7/Yjk2w6rB+xJN71YMazg+GWo8ObM7HFiPysgXn7JrvKXUf6bDD/0dhFiJI7OWaTDTfMJDUa1cYy87cX798zDTjJruSCm2rZNEVivgZ+bv97jftPqw6ePYj61uK8Vv9rQ+rrFymjFDdr/TAgR
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
config: nios2-randconfig-r123-20251122 (https://download.01.org/0day-ci/archive/20251122/202511221521.2OINSDPK-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251122/202511221521.2OINSDPK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511221521.2OINSDPK-lkp@intel.com/

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

