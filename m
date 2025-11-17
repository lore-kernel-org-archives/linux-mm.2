Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C761FCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:12:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287D78E001B; Mon, 17 Nov 2025 06:12:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239258E0002; Mon, 17 Nov 2025 06:12:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 127BB8E001B; Mon, 17 Nov 2025 06:12:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBC8B8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:12:54 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D2311A0CB4
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:12:54 +0000 (UTC)
X-FDA: 84119836668.17.9DBB9B9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf22.hostedemail.com (Postfix) with ESMTP id 45546C0012
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:12:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kkiQSp6o;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763377972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QgAtptvokPu4JfYlXnR6E1QfQ21cAL8q8YMREWHrj3o=;
	b=tVvcu6Gktk+l583GFoijPIeaGcKu6YyZluqdMmRANxvrE1HTKP0rZIT084VeEeOHva7rbU
	4eX6zY+yHFXRT3Nhp3ciNVkRu08OswVXNHFwhVpY36k/xZGlaaWvvnp9zUQDOlRnH1wIqa
	YeZzjE6r6SJR/bogGQV0/vcBPNCO0sc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kkiQSp6o;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763377972; a=rsa-sha256;
	cv=none;
	b=gvRIXYZsvlFXE0SPkFIrRXOECQNTPGURMRwsRX/dabzMVwWfIWcxpKb1IUC5/rYAmHeckJ
	otgFA4ZyQC3YhBOSIFRpfjCPsb9135T1zZilOL2ctAnEtcqh++GfZ2cckz+nfOnPVxB840
	i2RYFhu+1KEYSBjHV7RTfjGzMVmdOQQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763377972; x=1794913972;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uiVn5O+Z2ckh8lfSZDoQxdciZi4Sh+koQbfl/Op6dYw=;
  b=kkiQSp6okecN/AgCGIgv1Mbrod1rxbG6dk1PPL3An5KiqledVHqLQcCP
   8rihnhfTS55/avNsCnyK/IlQcsig2Q7EYZpyGwj/iHvGFApXaZbCkfk+V
   COOuHrqR0sapB0+1ykvCoIV4v+xezMxhOdE13J+IXFb86oU5nUXl8gAk1
   NJsH/AM80oUmKY9zdeJ3Mrir33KuOnt3oM6FEpSAFFhelxBIHC9JpxWpL
   h/PBDlN9TyAsK4PBD7b47FM+LfAELx/unhTMt5ORCEAw3Yyk60JlSj4hO
   lvy1tb7sP86Yjgayapx+AhX+6ipdWvsH2xxFikEVPoO3gt8e+uhLfQD31
   w==;
X-CSE-ConnectionGUID: Ftrqkd2uThKVArzmIOmE0w==
X-CSE-MsgGUID: XHSBEc3JQce89coD7H1u/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="90851945"
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="90851945"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 03:12:50 -0800
X-CSE-ConnectionGUID: LarFWhw6Q7eLzbFJT0IRVQ==
X-CSE-MsgGUID: Zi9XQFgmQ8u027dmYe6Hwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="221317842"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 17 Nov 2025 03:12:47 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vKxA5-0000TH-22;
	Mon, 17 Nov 2025 11:12:45 +0000
Date: Mon, 17 Nov 2025 19:12:14 +0800
From: kernel test robot <lkp@intel.com>
To: Luigi Rizzo <lrizzo@google.com>, Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>, Luigi Rizzo <rizzo.unipi@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	Bjorn Helgaas <helgaas@kernel.org>,
	Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v2 2/8] genirq: soft_moderation: add base files, procfs
Message-ID: <202511171936.CT5XHXPZ-lkp@intel.com>
References: <20251116182839.939139-3-lrizzo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251116182839.939139-3-lrizzo@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 45546C0012
X-Stat-Signature: bg488w7ts749wbfid1e9ci5add3z8obz
X-Rspam-User: 
X-HE-Tag: 1763377972-500908
X-HE-Meta: U2FsdGVkX18pVTQtr0L1aodWRXJUnZNB28Gu2fOgalH8X69pp5YV6cHK9LEqzQuQKQUOY0XtXvwPn53GHUCwxdNZ5Y3bndfWLx2WVFMGoOWEOOlrSI1OD3eFUSstIp3AwulYXPJFcKTYS4HyeyuMn64U8oUTng7Ss0F1J6BgAJ/2qEAniSo2/ypbFNqMrxPG9I6RxtaQ96KelQ/V8SbP3PxG8adXlv/RRUXjEyG0myFYvm7c6GDH6G1egZO4Pa5WkeDcGyisubHoOR0lAZuvr1OuSW2ClepRxk3JYjaQwvs9Kmgqd13lPej7YaWf/GUhaO4s9i6KIFEGlMoxJv08jhcr3PqIyEVoA3S7pPRW/thhV5sjJaXXJb8WrWXvLX84kgYbWgYWtgbzkrLKVW2FGAW8wl641Z3Dvcm0LSZFRV2T0bTw72QDP7MphI5t89LBoOV+hCQSgptyR5J1UdPSXlvg5kdgtK38a+OqqVLhKWJtDDyK88L54JW9nkYpFaMt01li5+nT6iL9nOZrtGeJxTqtJ+H/dJUMQ2XLd+rAUsQKj7pQrcWAXtDkAvlyNjBUreinsuhcWqu/A33DoMako0kEcs7jR5mbis2lz49J1Iwws+logJhb/mFyaye2KPj836f/J0hmJaCH1bULtFxBBhbyaf2DVOlcNv9f5xTdc+9UaULX1jQ5wdrGBXjk+2kh/evMZtoeR10iThZ3DUc8BN5GnDEJyEutNTI4zt+QXRKrx9rlOPbifa5r1x6x1Rjb3sYmogsXq5tEn9u7GMmJx/USuzLrToNP6vGlHUlsFJS9pM8WVfx7w5i+AOL0NzfNr77d+IeXaKD+dtpzltWxS0fKVDxq+DYQ7HoX7447Be+uCrdDJJfPexC46NQUonTOjgiZPqnunsNo0TWX5dhfgi4HeZ4F6xYj2wfLlV7WyE6BZm+HjHv5KPIUyjJEliv22cyUbCbw/4mOnV8Hm75
 S1jNaMBr
 SNvOrFy75rkdVqFqvVz0LBK7IGSAtS0DE325H+3RKkEiifWavNj3BK7YEdcLIiTkm3Q5sPMZSYbsLq8KDZ55BypfThEvlpFz6uGF39RkZPoSykK7UFQWHhaIJsfCpClk+tpm951GmAEuR1mGvqe7ju5xoLQJrA3StAqTcRTa+KTPluQMD+EcHxt1WIdYyL4KRc1OY0l2mPiBNQhW8DMvCVYAc4s4GDIZDiG8XZl/OZsG58hiOC5dKiEmS6MSVkLvczSookAZpJ9xsntrH6dJAHeHN/FEdnwu00r0Fjq0deWpABhPyPKbzJEiaRy8K47xMxra96GWANhktFiqonlS/l28eE352ydr2LwueR0Kf+3gsMyQxQcp/7iZigi+w+8ANqrkjQSlqysM3FnKuT3Sczs3fUMHQETepU5gc7L58k5DgDbB0uViXyydG8c/wu5QghjGnxOUmZSS6AVDPxxiH1moO4pc3mb0tnasK7I9ONglpq02pif9peEXlog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Luigi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on tip/irq/core]
[also build test WARNING on tip/x86/core tip/master linus/master v6.18-rc6 next-20251114]
[cannot apply to tip/auto-latest]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Luigi-Rizzo/genirq-platform-wide-interrupt-moderation-Documentation-Kconfig-irq_desc/20251117-023148
base:   tip/irq/core
patch link:    https://lore.kernel.org/r/20251116182839.939139-3-lrizzo%40google.com
patch subject: [PATCH v2 2/8] genirq: soft_moderation: add base files, procfs
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20251117/202511171936.CT5XHXPZ-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251117/202511171936.CT5XHXPZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511171936.CT5XHXPZ-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/irq/irq_moderation.c:103: warning: ignoring '#pragma clang diagnostic' [-Wunknown-pragmas]
     103 | #pragma clang diagnostic error "-Wformat"
   In file included from include/linux/uaccess.h:10,
                    from include/linux/sched/task.h:13,
                    from include/linux/sched/signal.h:9,
                    from include/linux/rcuwait.h:6,
                    from include/linux/percpu-rwsem.h:7,
                    from include/linux/fs.h:34,
                    from include/linux/seq_file.h:11,
                    from kernel/irq/irq_moderation.c:8:
   In function 'check_copy_size',
       inlined from 'copy_from_user' at include/linux/uaccess.h:207:7,
       inlined from 'moderation_write' at kernel/irq/irq_moderation.c:169:6:
   include/linux/ucopysize.h:54:25: error: call to '__bad_copy_to' declared with attribute error: copy destination size is too small
      54 |                         __bad_copy_to();
         |                         ^~~~~~~~~~~~~~~
   In function 'check_copy_size',
       inlined from 'copy_from_user' at include/linux/uaccess.h:207:7,
       inlined from 'mode_write' at kernel/irq/irq_moderation.c:223:6:
   include/linux/ucopysize.h:54:25: error: call to '__bad_copy_to' declared with attribute error: copy destination size is too small
      54 |                         __bad_copy_to();
         |                         ^~~~~~~~~~~~~~~


vim +103 kernel/irq/irq_moderation.c

   102	
 > 103	#pragma clang diagnostic error "-Wformat"
   104	/* Print statistics */
   105	static int moderation_show(struct seq_file *p, void *v)
   106	{
   107		uint delay_us = irq_mod_info.delay_us;
   108		int j;
   109	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

