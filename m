Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A01ACA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 16:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C9B8E0003; Thu,  4 Sep 2025 12:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C238E0001; Thu,  4 Sep 2025 12:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0BBD8E0003; Thu,  4 Sep 2025 12:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6818E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:52:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 60B09C02C2
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:52:55 +0000 (UTC)
X-FDA: 83852162310.07.0D464F5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf26.hostedemail.com (Postfix) with ESMTP id EAB18140008
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:52:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XyZTQlhm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757004773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=c4UkRm5N8iojkc8QawaylSVbj+TnqeNVuLFCRbsST4I=;
	b=b6G61TGKVZKUTPXu5oa49cbpu+fCrOczor8LcathvkzQ4rX33vx+3LvgeSkud+YROCBoVm
	h0fNuU6+wCQ3R4bD/RLSsOLQkvx1Y+5hJbewIAVeT9LfAFEsuDq5m7Dxq7wNXLTiBd6Zmt
	xcKa+/Ay5RBWu6oMyMs9PcgHJ1yWSaU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XyZTQlhm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757004773; a=rsa-sha256;
	cv=none;
	b=caDq6s0tYyWe6ptf4QD5zt50AQfMhBEEOBsJO6ard1vi0fa6sfwYVXFqv9muX/EKAt6SWm
	RQ4B7/NbpTgNbm7UQCuL0URIbDwIrRC6oB3oN4jKRWyisG+oobZ3D2JU+5G2+WCGYIZdMy
	34iQTW9CrJ1lV5hbqgQ1iVgLwJMB5Y0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757004773; x=1788540773;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=19TYjnY2OcYhkXyxuSM1TRY31pdrEDoN9ZOH23PUDXo=;
  b=XyZTQlhmKM6r2U2Ms2kyedA7MrspAPtAzJ9dDfDZJCuNOLt5Ky7KLYhH
   umfbTJTMmv3nWpKMWyeO/dOnhhQWdknDmhoT6ZN4PGe3Oj2saraS1sM/C
   vyvlxzY80ypteujlb+YpvuAFW00wrt6bIAMPUtrkcGRmt67vm8tn6x3h1
   BEqiX/6+ajnd/zc2Mi8rp3awf7obWH7mZk5lVkmIIEPESvjiolGWNXVF1
   QFsCvaYslQvTOmhpFJLwG2HcUSwqXt556IvYgcnlbR35E2xbAJx56kQKn
   uTOS3tkVnPBTDhhJzcdMoCmRyWaQdRjw258snTFAN9FhXo6M51SUbp3cl
   A==;
X-CSE-ConnectionGUID: GCe6hy3yQ16F2vjuY53gZQ==
X-CSE-MsgGUID: /LlH75dFSnChTOHLQKZNVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="81940983"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="81940983"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 09:52:52 -0700
X-CSE-ConnectionGUID: 4hwcH9irS4q38umVVnR6Fg==
X-CSE-MsgGUID: /IQP44JkSEi4M3Hl5atsgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="172382929"
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 04 Sep 2025 09:52:50 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uuDCB-0005WQ-02;
	Thu, 04 Sep 2025 16:52:30 +0000
Date: Fri, 5 Sep 2025 00:50:11 +0800
From: kernel test robot <lkp@intel.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Petr Mladek <pmladek@suse.com>
Subject: [linux-next:master 6141/6355] kernel/panic.c:70:6: sparse: sparse:
 symbol 'panic_this_cpu_backtrace_printed' was not declared. Should it be
 static?
Message-ID: <202509050048.FMpVvh1u-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EAB18140008
X-Stat-Signature: fis6u8hdm917577b7rbbcjhh1m9dgojh
X-Rspam-User: 
X-HE-Tag: 1757004772-908823
X-HE-Meta: U2FsdGVkX19vFEnPn5micl/nYhHxvEDtkmikKYRt6LVqYBX/JwKpzERaAFybOFWJ+P/d2bONRQzwSclPfhdPfiCQZvs9qIpXpzo8tlPT3+SCjkbBpcqsxXDhuEhZvTLJX0MEHDkmcmZsMbeG6YfInH0LMIJ70ehIFMJHkZbRKbDDc7Au4l6KfCdHv2bTcrDTV0U1SvvCo7+X7s5ShrgyOsui0B+RiT1/jd5jQAeb4l++60qddEbubrqjj22sRP9ToAQLm3FZhYh8WE+md2AUuyK2BwFhhgAj6nkJg8SvjX3Ll4jS1vLSUNe9fTP53+CvbmA72tnJF6h4pMxjoIzkhDW0c7kv1nF4OXKBuOGHtW5c4N50PVerfHfrXINq9OQVtZHzyca2jsLbUkjq8znfzVtJujUaOj8jEBl9wr7QiEHLfvIR6HqBPtgdnBmpD5+3fS2CBcvi/U71LWjGO6HYZmujlksYEbNHhCD9ULjKaAnbsUBPAiUeMDM9Gx2MF3oLJdE4t7pO0adp8n77y7Y7sjCiP0wesHpLvo6K5TRnaaVhW+PRf+FP9XpoIYEeDAmwpt0RxtUpj1FEmfCpdUrI7wPIkIOgaSfTlJ/+OaY/MqvEGvDMh2lG3Fgulnefe6R8svsxjiyzWhMfC7ViaMJCUHdVWeUXjbXyPOOICw456mDcWfUay3bpD4/1SlSVrfUd7AKJcq/rpE765RL1XBDXVzuwgxqZadardmNozkl9n4OA1D+Qkf8lPj73QXnmaZnT7eP3RqNEjiNKuRSF36LmCtQNth7zdLdgnP3plsN83dQ8OXsaJwuB9tL23GoDcxGrfEh1QTnp5YMYlJ/VprIsTlbqJokmf/MMov9jHuNU7hdUrAI/qJ1z1OnqWFXsgzsZHYEDb4a3d6nCQELjqvvU4PkoNhvn9pl21y/gorN5NbmbSh+BqB46zIhCIdsMS4FWPQSpNLPfT+kt2pcXz9v
 lRj4b1X6
 pDhswaTR8dZjus2iinIfvcGWTRyEqVb65B1VKHe582A8yd58QwtMnSyJFeJlgkMbwe57J+ktZHRn0zNWUATlx6gwb0cpxS6M3aELuT2Xe7U3P1d2R6cb1h3ff0j3D/aYCmCU9I4eqFj+yr0GXGuq0PfYICAKwcgi/yE4gz038+KHL7PYm6EKrwxJqW5XGM65RNw8Hsic/mp4Aaa7CsFGly1MOC7aeV0wcETYSF6UjY1pZKjoXl3D3EtDVRulcsQVN20qvOLeVmcwFa41auA0R6K+wEyYjIYTYz7Zha2AV/IK+zUyVkTinU+MS3Spn9bDo7q8qBWhw+1c5uxVQgGr9VfyWxwj1DnEwzFk0XfN2A2yNozqzV6b/jY3PsY2IA4xbZSBdDDCUifbDZ3yBMp7TSdPAx75R6hqze9uc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   4ac65880ebca1b68495bd8704263b26c050ac010
commit: 28ec7e0d834d81ef8abeb6a6c1376f1fb26f1510 [6141/6355] panic: remove redundant panic-cpu backtrace
config: i386-randconfig-r132-20250904 (https://download.01.org/0day-ci/archive/20250905/202509050048.FMpVvh1u-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250905/202509050048.FMpVvh1u-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509050048.FMpVvh1u-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> kernel/panic.c:70:6: sparse: sparse: symbol 'panic_this_cpu_backtrace_printed' was not declared. Should it be static?

vim +/panic_this_cpu_backtrace_printed +70 kernel/panic.c

    68	
    69	bool panic_triggering_all_cpu_backtrace;
  > 70	bool panic_this_cpu_backtrace_printed;
    71	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

