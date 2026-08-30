Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3129C61DE8
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 22:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 467166B0088; Sun, 30 Aug 2026 18:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 417336B008A; Sun, 30 Aug 2026 18:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 309286B008C; Sun, 30 Aug 2026 18:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F30256B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:56:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 702DE140127
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 22:56:21 +0000 (UTC)
X-FDA: 85159446162.14.45448E5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf25.hostedemail.com (Postfix) with ESMTP id 96708A0004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 22:56:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rt8rTSuy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788130579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e3/cqdLvccPxZ2uqG95iLdrUgQeCw11ZIXwQ+yjx428=;
	b=M8Kc7J/fbtwT0s98WNKJebvIj/wm+zpmZR2+Rqbngyke1uKu3h2UINZHwiXKSQYp/nYo5h
	gTOvBe32q5YTnGeSOha6OXO77qo6HJ9QkeH+aQnECVYGuMg7UayRuSCoaXC1ZeBVlW5RrO
	ldezLsduU3h0XHbY6pz7tdXsPY9G8qQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788130579;
	b=48z/UonqqbH5ns+u9rfwWavaw6nkAhgZCPUlDLKFSbEVyugQKDDVC/4WcuL5Yj9PUQyLor
	joqo1ZVd0EbwlU3hQc1kI9VgRaFTyG8shSVI7tG0JHI1SvE9hwZhgf/pnqltQYhyF7yUa3
	V1rgPb80u3fMpkkxR2N66S78Px6h/eY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rt8rTSuy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788130579; x=1819666579;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=w2+MqKImWzvJSAsgyiI2Ii4OdoNpIUEYROMw5ChEGl8=;
  b=Rt8rTSuyVUMEE+fjtD/QfQTTWW57F6JvARB56LYnsqzJLWfzomMViK+n
   VOL76kujZ0bYQrL9qJQPNHMuhUD71VEVNwrgb5P0jLozgQ77SXtGV2u3q
   JudszZfzdlE7bHR5hbq8aEgS+xfSXdb+78yoCMGD4HH0dXvwEZC3IoFfO
   fCv7mk3i+BbDAtku1OZi4WJi9rQT7s4AKAaCTGffk/Qm93Zcc8vu3O7v7
   4Fe+tJTYhxfUVYLmjRXR+Ix4xxsehMJsf7tCI3SsWvjQHNPUdqHcbSfl7
   KDUm0k4GdVXRrnwz8sRDkt+5XVO2VE8itZ5AaZ6TiNGn5mxwBHlsqznq4
   w==;
X-CSE-ConnectionGUID: 5xqVKCzwTUaASjkt0notYg==
X-CSE-MsgGUID: rsk50HLZQcG3OwxUsCV2oA==
X-IronPort-AV: E=McAfee;i="6800,10657,11891"; a="88462316"
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="88462316"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2026 15:56:17 -0700
X-CSE-ConnectionGUID: RywSKtqsQvSRZEniFtSE1g==
X-CSE-MsgGUID: TucMrbV9Sc+der39RTEi7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,252,1779174000"; 
   d="scan'208";a="292139749"
Received: from igk-lkp-server01.igk.intel.com (HELO 32268bdb9915) ([10.211.93.152])
  by fmviesa002.fm.intel.com with ESMTP; 30 Aug 2026 15:56:12 -0700
Received: from kbuild by 32268bdb9915 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x0oRc-000000000GZ-40gG;
	Sun, 30 Aug 2026 22:56:08 +0000
Date: Mon, 31 Aug 2026 00:55:20 +0200
From: kernel test robot <lkp@intel.com>
To: =?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>, willy@infradead.org,
	mathieu.desnoyers@efficios.com,
	David Laight <david.laight.linux@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	akpm@linux-foundation.org, Yafang Shao <laoar.shao@gmail.com>,
	andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com,
	Petr Mladek <pmladek@suse.com>
Cc: oe-kbuild-all@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
	kernel-dev@igalia.com, linux-mm@kvack.org,
	linux-api@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>
Subject: Re: [PATCH v5 6/6] selftests: prctl: Add test for long thread names
Message-ID: <202608310045.6IJtlqhj-lkp@intel.com>
References: <20260827-tonyk-long_name-v5-6-5fa843782a00@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260827-tonyk-long_name-v5-6-5fa843782a00@igalia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 96708A0004
X-Stat-Signature: oyuqfs7djq6uarunpbeo8hohuy9a6shk
X-Rspam-User: 
X-HE-Tag: 1788130578-46428
X-HE-Meta: U2FsdGVkX19qAk+KmYtZExnpgzQV960GfVvAKBZ1I+2jWIws0ZMzJhOT7168Y0XYVU303mfAeU7zC4kQcCsWQ1MPHGN+Lyb05h6M4IqLVTTQX6BtNvZ0sWpP7NvbyoZiXNF60JCB3H4wX+YNOLzCm4TlR3jC6CNtGvNjxcw0DQGlAc8eTEp1B+u+Zp7QUfTKSfur1J+Xtf0G2ARymwapuy2UMzWRoiZSxoZ1tnf5N/WvDuSpFJntrr9aYjc5wteoi1NGDaF5XT7wpMpATOxtdZffjoW31bfG8WyccwryalC1n79sguHV+J8YFdMDWaMV7xG9hI8xiCrdr114dCQuKxEXOmxQX9IIokb2gZ5UfB8VHkHMOcYGwtUK9iw7YZHay3MiH3E+KANVeDOIY2TXNsoIBKdeuHuOKjqcpoAtK4ctBQxzVdNnWj2YKEMhfALWc7wvHu5cJXTXvH3WWc1Ah3HDtAhpi1fzF+L6bCqFPz4EiY/QkSedAXS5qOoctSXq696X2NLIfFGrQpm674UAA0YSzK1g4q/Z7325fGUC6En8ee6KGIVlpSxsHeOsUi23BJ3P5Lukty5xoncaSKwV2g7eeOGk/OQVv3pnkWYYXG+j/WNKPrasa7Rcb2Ob7MM3ICzOcTC87LtYvbHmDIT74ykO8egJu6BGOubnCbHEJJxi7MkOTexTr7y2IzKYAIdAsz7aRlv3zvt7U+jMz3xz4jXamAnHEiwtxyFpcgeC8CV0WAH+0nHqrsJ7XM+PC+Oo0IZ3kf4QZBmKQJB5XMxlo2rOYGYV/b3nGobqoF2uVq1zoK/+XDOwUp4bXwSTTIbrNucgLihvFtj/+4p8qX5Cji8zSSJMbTsdCKuzgjSNjXrF5LG0ZrpoxH6L/3Pk6Kkl4lB9DzCVl3BYT8kdPfAF2Rh95OTgW216MieOLTVDrtynnzaQB1J0zRSrRBrm2QkkNfRzDRhOLcIlL7iXpXf
 yK5n0jhe
 9K8L0DU+85XzAqd7eLbcrMfh+WS2SzjYEpKp8kA1jd2BYxk+MeiTw/Pu7H3CXkP9W0YEKWZmVYvp6RR2D+dLPBH/PhSjcmBuapaT+h9YpodF/uw3uHhN2ZPW0tgNgWmVPT5tphE2N3RKaf1zQFJrMf0TeBqKTyFtzCIvcrjjaKkYVyK5u8rZSKnlSGza/Jt81iqvpEzovuQt4OdZ8Hf76XHibWXDKXdvod2D9Ue7ElPw007us1otkD7G3e85EvJ1tT5DU31Jxjq7lOOW6y7H9q7pTEeETxDqSFkCBDr3jokwe+dKXw0wgoAMHJ0gZHMpRGDxOpKXY2sJaOoekjyrypRrTcUOgp1gaZjuHUqQHgkp6lOLVrawx5RanrJnIlfBQrm9VVUN6A9CXduRG4mu6nEGDCudR2Zqbp+thPH4VVxTOBtbVmOO3fNRSN6wrg7PxvCOjQjbz6Hijdct/vmECOSyonPA6C1Ndqs7G2GMY7qWUl4o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi André,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 73e3f0710014fe6d4ed98cfc02292f6121db7558]

url:    https://github.com/intel-lab-lkp/linux/commits/Andr-Almeida/treewide-Get-rid-of-get_task_comm/20260827-152300
base:   73e3f0710014fe6d4ed98cfc02292f6121db7558
patch link:    https://lore.kernel.org/r/20260827-tonyk-long_name-v5-6-5fa843782a00%40igalia.com
patch subject: [PATCH v5 6/6] selftests: prctl: Add test for long thread names
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20260831/202608310045.6IJtlqhj-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260831/202608310045.6IJtlqhj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608310045.6IJtlqhj-lkp@intel.com/

All warnings (new ones prefixed by >>):

   security/smack/smack_lsm.c:150:8: error: call to undeclared function 'get_task_comm'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     150 |                 acc, get_task_comm(comm, tsk), note);
         |                      ^
   security/smack/smack_lsm.c:150:8: note: did you mean 'get_task_mm'?
   include/linux/sched/mm.h:151:26: note: 'get_task_mm' declared here
     151 | extern struct mm_struct *get_task_mm(struct task_struct *task);
         |                          ^
>> security/smack/smack_lsm.c:150:8: warning: format specifies type 'char *' but the argument has type 'int' [-Wformat]
     148 |         pr_info("Smack %s: (%s %s %s) %s %s\n", smk_bu_mess[rc],
         |                                       ~~
         |                                       %d
     149 |                 smk_of_task(tsp)->smk_known, oskp->smk_known,
     150 |                 acc, get_task_comm(comm, tsk), note);
         |                      ^~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:584:34: note: expanded from macro 'pr_info'
     584 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |                                 ~~~     ^~~~~~~~~~~
   include/linux/printk.h:511:60: note: expanded from macro 'printk'
     511 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:483:19: note: expanded from macro 'printk_index_wrap'
     483 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   1 warning and 1 error generated.


vim +150 security/smack/smack_lsm.c

d166c8024d620d Casey Schaufler    2014-08-27  132  
fba3d32825f4bb Konstantin Andreev 2026-05-11  133  static int
fba3d32825f4bb Konstantin Andreev 2026-05-11  134  smk_bu_tsk_to_obj(struct task_struct *tsk, const struct task_smack *tsp,
fba3d32825f4bb Konstantin Andreev 2026-05-11  135  		  char *note, struct smack_known *oskp, int mode, int rc)
d166c8024d620d Casey Schaufler    2014-08-27  136  {
fba3d32825f4bb Konstantin Andreev 2026-05-11  137  #ifdef CONFIG_SECURITY_SMACK_BRINGUP
d166c8024d620d Casey Schaufler    2014-08-27  138  	char acc[SMK_NUM_ACCESS_TYPE + 1];
fba3d32825f4bb Konstantin Andreev 2026-05-11  139  	char comm[TASK_COMM_LEN];
d166c8024d620d Casey Schaufler    2014-08-27  140  
d166c8024d620d Casey Schaufler    2014-08-27  141  	if (rc <= 0)
d166c8024d620d Casey Schaufler    2014-08-27  142  		return rc;
bf4b2fee997997 Casey Schaufler    2015-03-21  143  	if (rc > SMACK_UNCONFINED_OBJECT)
bf4b2fee997997 Casey Schaufler    2015-03-21  144  		rc = 0;
d166c8024d620d Casey Schaufler    2014-08-27  145  
d166c8024d620d Casey Schaufler    2014-08-27  146  	smk_bu_mode(mode, acc);
fba3d32825f4bb Konstantin Andreev 2026-05-11  147  
bf4b2fee997997 Casey Schaufler    2015-03-21  148  	pr_info("Smack %s: (%s %s %s) %s %s\n", smk_bu_mess[rc],
fba3d32825f4bb Konstantin Andreev 2026-05-11  149  		smk_of_task(tsp)->smk_known, oskp->smk_known,
fba3d32825f4bb Konstantin Andreev 2026-05-11 @150  		acc, get_task_comm(comm, tsk), note);
d166c8024d620d Casey Schaufler    2014-08-27  151  	return 0;
d166c8024d620d Casey Schaufler    2014-08-27  152  #else
fba3d32825f4bb Konstantin Andreev 2026-05-11  153  	return rc;
d166c8024d620d Casey Schaufler    2014-08-27  154  #endif
fba3d32825f4bb Konstantin Andreev 2026-05-11  155  }
fba3d32825f4bb Konstantin Andreev 2026-05-11  156  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

