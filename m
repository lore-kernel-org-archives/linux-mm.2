Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE9AAD46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 21:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33D3D6B00DC; Thu, 15 Jan 2026 16:15:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA4A6B00E1; Thu, 15 Jan 2026 16:15:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 221456B00E2; Thu, 15 Jan 2026 16:15:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F0E16B00DC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:15:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94DC6C1EB3
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:15:22 +0000 (UTC)
X-FDA: 84335454084.04.9CFC9E9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3DFE180009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:15:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c3fypLHz;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768511720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PS/w4qI2iNd98AaVptBp/28ScEe8EH7mqkZqanz/BW0=;
	b=MkOUUpseSt37LSxrunHGLlr5GsOTAOKLvn748V4dG2bBPg2EUSIgzk3u+z8Wb0mlmJ0C98
	ejxRPP50o/mPpDswkDIIDCt+JZFzGclNZEZtlqdFPJl8cDLEPh0XbSkeOAeBmNzXYEC6IF
	UyX21dCJ3m6vMYtXEqoH0jMY/LMbhqU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=c3fypLHz;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768511720; a=rsa-sha256;
	cv=none;
	b=qNk3PGykN1afjKNKv9KNZ90GMCLWJh9Ao4L72TXUYqquGgivQFBr/4PvGdnFMAqx/yTAbO
	xyrvLpU2XU267Xyn+SzMpGohlwaghO9kM3hhAtnq48pjcY6wM99gzfCoIfY9G0a9tjs95H
	fisAYXTVx9FwIEHT45E3kNCBB9meZAQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768511720; x=1800047720;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1A+T4CJFZG1miay751yy1KYlyXw8N+muZBboZSWUttM=;
  b=c3fypLHzPXJXF2CNz0Gg+g8MqwwYO+cuMbhpdcR5RxTP3HSgA5pMlxWP
   gF2mH8rOMKPr8SpeTkccMdKeBhhfisDJPn0BUj2FrOcZcJSPSCAh5u8Dt
   BdzF0TpdbrYuQIyP6dykRytjKu+lJ6n63xp+cwKZHk2Yvdns8aHjL2EAJ
   4byOwlxCbyglBBwQsxWad8noxRbAjBeHzUjVK/pPmJhUNHWaBEvxsdCJJ
   /P5ft7dkcDWLNBAaS3ZKjtJFcGtbbB9IGHF6DG+cv8YCi7yCU5+JF+4/Y
   DFYMIdL2XneyFuEt/37S/FdfPOoWYI7mjR5kkixN6jHgEsk8chcMOTdGn
   g==;
X-CSE-ConnectionGUID: fEKFLPYwRiGXrXeh3MogvQ==
X-CSE-MsgGUID: U+hG+WFaQ0CKbHoi0GjmaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="80472114"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="80472114"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 13:15:19 -0800
X-CSE-ConnectionGUID: eTlg1CJMQsGmMNMsaXqNIA==
X-CSE-MsgGUID: UV4mjTkQR7uGcxNnXPA2WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="205543257"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 15 Jan 2026 13:15:15 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgUgT-00000000K08-1fPo;
	Thu, 15 Jan 2026 21:15:13 +0000
Date: Fri, 16 Jan 2026 05:14:54 +0800
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
Subject: Re: [PATCH v4 3/3] genirq: Adaptive Global Software Interrupt
 Moderation (GSIM).
Message-ID: <202601160433.z2rdE9lE-lkp@intel.com>
References: <20260115155942.482137-4-lrizzo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115155942.482137-4-lrizzo@google.com>
X-Rspamd-Queue-Id: E3DFE180009
X-Stat-Signature: m45oia3c44git4wuca5pe6ywsmziy1et
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768511719-282381
X-HE-Meta: U2FsdGVkX18rQuqJmgn3AebnlUaoxWvWz6zHxKTaJbZUzB/iiCADGtGttqvRC69rnGOz30s9vlptZSu3FZM0PJ6CZ7ndJWXKcW+gqmHRSLEOV/57Kk3veoZUduCDjVQ/gma+eP3fQlrjW5ljDGRlEASaVJw1IckE+BwDd5ujw+JekQYDAfQEFTOjX0JqrWPaWbi2S/XAgXqZRl46nfVGxJY8SF36A7jXDOaESry9r2/M2M8NsAzQTzTjfX8ya2vdQ9fL1yJdnfjDliW9w6UOGY3E39hgd9kIG2wvRJ9s0n49XiND/zEbAG4QOK4BgySMr5YMagPxiv2TCKhcCLKIowRG7wp7UyAkhPvrayNy0rUlLyFmzAlAHZWgguWVAwSJZFD1konKg2du0l1CqYrOaryW3wReRVsDTEe0MhPcT2hmwz8w39DynZ+MopGsMgPb5X1m4SOg+ghrF0vBPQ9sUhiLJr/1duBHM9cANC1jo1ULVHtdms2p+hEdTWTj/3HWi/TcQaE5yJ5ZQg5JceVKro+K5I6JWKTPjbUKB8NzqKW7PTsFw2f2VaL+D3dmmPK9hjCdA+PvWps+590T9TbVCmc2YIy0RLKHtTaESx7NfrK1vScQRnpdSm3nBFO+aHaGXdsRfHPcvatZrxDyVlhdULKTf005Wi3VNR/YQydqidfHjtJwiG9XXov/W4Ep8l05a+unFTU3DEzeBwlOMxD22ZrzHTnEMXsZcAKKqh25CSS6C7SwPwP5L2bHA8Bkpx3GcUcDNIDs5aWJRD2aEoyOd5D6UaWiR1/AZf5FrUUIpLbLyMh/gymwsNmuC2UNct/fLQMPdLfm10RRE/cCtbstHmdtxj11fo7kJPnzSm2idzOMJGYburyrCSk26HdlC+nYgkX6YrGvzsZLH7nZd7KghYIhfe1f75IpFrOfPcTlxU5Om1XstShljQZjkfjD2Ja8tEZiAYnbGyc5gYjPHje
 6e6mQEVc
 J/yK6ELPe3GoRdX6heFf89c892XY/Lx3zO1PrBwF69Dfz3ob/KFFXH8elEOfgdjiQB1Z1eoxCsIyIy3ZqG7+p7wBfq1OjnvN7CIwF2cudOgkzz5fYid5ZUBshOYzzwkH3Bu/1ZctNtkG5omqm6neQb6whWGFxcEeiao/V4BSAo9TYG3zSgWm2cxjWj0IlB2Ll2QBxI+oSaRpLTwoudAU0XssgUKeDBBZx6FoUA/7onNhsMUcF0NTAh1eBRwLurj38GZ3H3Cg8CZbjE1S78y3QQAqD7iAMiYJT+muOUoQ3vb1YCKtBrk6N15D4YZ7jKJtptJk5CBUhC4hceLHv3Iahu2hmq+bVrYr0/Z7x85BCVXeCyDMm8LdLg2sZKYC0h9XYMlFVCEhyVDveRJuQCgdU5hr3in3YORD7rRxlJBcIDqElyNydxMra2HHto1vaC7P1S+Dg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Luigi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.19-rc5]
[cannot apply to tip/irq/core next-20260115]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Luigi-Rizzo/genirq-Add-flags-for-software-interrupt-moderation/20260116-000808
base:   linus/master
patch link:    https://lore.kernel.org/r/20260115155942.482137-4-lrizzo%40google.com
patch subject: [PATCH v4 3/3] genirq: Adaptive Global Software Interrupt Moderation (GSIM).
config: mips-randconfig-r051-20260116 (https://download.01.org/0day-ci/archive/20260116/202601160433.z2rdE9lE-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601160433.z2rdE9lE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601160433.z2rdE9lE-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/irq/irq_moderation.c:432:40: warning: overflow in expression; result is 1'410'065'408 with type 'long' [-Winteger-overflow]
     432 |                 recent = (now - epoch_start_ns) < 10 * NSEC_PER_SEC;
         |                                                   ~~~^~~~~~~~~~~~~~
   1 warning generated.


vim +432 kernel/irq/irq_moderation.c

   410	
   411	/* Print statistics */
   412	static void rd_stats(struct seq_file *p)
   413	{
   414		ulong global_intr_rate = 0, global_irq_high = 0;
   415		ulong local_irq_high = 0, hardirq_high = 0;
   416		uint delay_us = irq_mod_info.delay_us;
   417		u64 now = ktime_get_ns();
   418		int cpu, active_cpus = 0;
   419	
   420		seq_printf(p, HEAD_FMT,
   421			   "# CPU", "irq/s", "loc_irq/s", "cpus", "delay_ns",
   422			   "irq_hi", "loc_irq_hi", "hardirq_hi", "timer_set",
   423			   "enqueue", "stray_irq");
   424	
   425		for_each_possible_cpu(cpu) {
   426			struct irq_mod_state cur, *m = per_cpu_ptr(&irq_mod_state, cpu);
   427			u64 epoch_start_ns;
   428			bool recent;
   429	
   430			/* Accumulate and print only recent samples */
   431			epoch_start_ns = atomic64_read(&m->epoch_start_ns);
 > 432			recent = (now - epoch_start_ns) < 10 * NSEC_PER_SEC;
   433	
   434			/* Copy statistics, will only use some 32bit values, races ok. */
   435			data_race(cur = *per_cpu_ptr(&irq_mod_state, cpu));
   436			if (recent) {
   437				active_cpus++;
   438				global_intr_rate += cur.global_intr_rate;
   439			}
   440	
   441			global_irq_high += cur.global_irq_high;
   442			local_irq_high += cur.local_irq_high;
   443			hardirq_high += cur.hardirq_high;
   444	
   445			seq_printf(p, BODY_FMT,
   446				   cpu,
   447				   recent * cur.global_intr_rate,
   448				   recent * cur.local_intr_rate,
   449				   recent * (cur.scaled_cpu_count + 128) / 256,
   450				   recent * cur.mod_ns,
   451				   cur.global_irq_high,
   452				   cur.local_irq_high,
   453				   cur.hardirq_high,
   454				   cur.timer_set,
   455				   cur.enqueue,
   456				   cur.stray_irq);
   457		}
   458	
   459		seq_printf(p, "\n"
   460			   "enabled              %s\n"
   461			   "delay_us             %u\n"
   462			   "target_intr_rate     %u\n"
   463			   "hardirq_percent      %u\n"
   464			   "update_ms            %u\n"
   465			   "scale_cpus           %u\n",
   466			   str_yes_no(delay_us > 0),
   467			   delay_us,
   468			   irq_mod_info.target_intr_rate, irq_mod_info.hardirq_percent,
   469			   irq_mod_info.update_ms, irq_mod_info.scale_cpus);
   470	
   471		seq_printf(p,
   472			   "intr_rate            %lu\n"
   473			   "irq_high             %lu\n"
   474			   "my_irq_high          %lu\n"
   475			   "hardirq_percent_high %lu\n"
   476			   "total_interrupts     %u\n"
   477			   "total_cpus           %u\n",
   478			   active_cpus ? global_intr_rate / active_cpus : 0,
   479			   global_irq_high, local_irq_high, hardirq_high,
   480			   READ_ONCE(*((u32 *)&irq_mod_info.total_intrs)),
   481			   READ_ONCE(*((u32 *)&irq_mod_info.total_cpus)));
   482	}
   483	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

