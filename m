Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97FD9D4662F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 22:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AD2D6B00C9; Thu, 15 Jan 2026 17:10:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F606B00CA; Thu, 15 Jan 2026 17:10:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF0076B00CC; Thu, 15 Jan 2026 17:10:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB75A6B00C9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:10:25 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 751411A04BD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:10:25 +0000 (UTC)
X-FDA: 84335592810.29.4E1571A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf13.hostedemail.com (Postfix) with ESMTP id A9AA620006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:10:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="bzwkmG/N";
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768515023; a=rsa-sha256;
	cv=none;
	b=675ahfVWAzsBlOqqmfP+9VxFDgghdnSlb13azAvlctUOrUojt6R05njEwrokE0VEDNl+v9
	DbsdhLbYycuOOQniEITFh3vkGqYGL2BNWkDbT+vTMYOLF92iHXgvYEjZ67UttSdDnJqd5n
	uYA0U4SXHccLL65oUiSZugV/ESBbcFI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="bzwkmG/N";
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768515023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N0MloDAOxfU4iT8Rpcxo/wx4wZZec0zrOlsnvMmmbto=;
	b=lHg1eVXsGR/X0zvOQbYy4LkgQofU4DJ5tuyo2+Q7vxrnvl8RUsMR3Kp2Az2VbNvWgQ0RPv
	OHfhLRHmVBy14hLkgJOxB98dtflX3cFsjDtVBpTbUrpqiAeje5jaS/1pAg2rg4tLJd3N2z
	BfkGEX2VsBOlQ5CFVJmOsQJKeAEmjgM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768515022; x=1800051022;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=67QSstfnhCc49jDqGuJFBbqmSxSl1QWikTWS958nOcM=;
  b=bzwkmG/NueXU5dAl2/JDAxe/O8R/yeN+vYd8Trd2t4a7kkWKxUIfHu3L
   rMtwq6atp5aa76Sy8J6Jp09m0613TvCNo/1nWb/B85CF+JEGoMiRJCMCz
   ZRl99O2V3dUNbwiN1THISnMlpxaXHmNxTwX62lr3/2oJTW4Zrr/ZPajwx
   KBdd5gpTw3x3xycC2uWURTHsiGjekHyU7W2CGf0nWB2D/WzCvGVtuA8kb
   VSM5ZPIG77khQoIuJFJmr0pHjVoIUN3ZgM6kl+xCef32swF0pvMFJgFFh
   nKwf3y1HlmGUlFcBXjAk8J+24IzwtrsqT391jAdA0iOcTtVjjEP1k48bH
   A==;
X-CSE-ConnectionGUID: 5OBk7kV2T7aEq7f0q7Gy3w==
X-CSE-MsgGUID: JC2YgkiAQvqS/7bV7WRZ6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69881359"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="69881359"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 14:10:21 -0800
X-CSE-ConnectionGUID: lssAxa64RxqD9duhy8zITg==
X-CSE-MsgGUID: gPr46FfxQxim1ER887pVAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="209933526"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 15 Jan 2026 14:10:18 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgVXk-00000000K3U-07Xr;
	Thu, 15 Jan 2026 22:10:16 +0000
Date: Fri, 16 Jan 2026 06:09:35 +0800
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
Message-ID: <202601160504.h8ijlURr-lkp@intel.com>
References: <20260115155942.482137-4-lrizzo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115155942.482137-4-lrizzo@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A9AA620006
X-Stat-Signature: dmdadf7tfu9mnnybi9w8bq46fsgduyc3
X-Rspam-User: 
X-HE-Tag: 1768515022-779614
X-HE-Meta: U2FsdGVkX18R9oW37v+kQj8JCqwjcRaQXlfP2neL/lnmkCBWAee3k4WGnUzMGcQCvRmdFK4wip8z7gvolqEJUWgKpe9Ek7wB37pbrRwVsEMfEt4F2L4AJihe1DFyhdLrOD7lG3Kum0qntaD0T3dvogBPGA1gKl3FQMIb5/4jJrYtO48vELn43yMJ8fpIrZB21Uhll1AoCRLht6WX56YHncdfOZ4Pf0pFFhQkcNf0v6bFmq0vVFz3KWfwgW0kMKEp9QAyWn+hPG7p6Cqn9FJkqjuBf/danQPWOwGIfD/BHgdA/f3ju2PP7GzWp8GyS+5LR3fSvvx2knw/OfhMi++mG+LE1eXQl/M/3Ah7UWnIr+z95VJpbVHzMdFp15/hZ4+0Tn/2Vue7zh78zyWfvWOjr/QJAuZCqMLNE0pY4NI4yw0y68UDnh9tvbmST2ruYDbmf+3exU3xHrqDAt09Mt4V0/h2G7iNJ0PYSPa2OsIFnKl8HLC3Z27Cqk0L5H+uq4GbEEY+GJMezE4S0XdL6xfIfH6rUVvWFSwBgEY8EWsa0/5RkFfGghMRzWxejsbKSXGl9gT2c/M0b/04HByDMixtxfXlT5CYryZlA+ZXmLZw2aPIDHOgKM+cEqgXrsSBH/pP/sXwRXUd317lEHK1Atbni1WhrG5ULqI8TwxDm6VnzTa9mZsJKrpU0q3n4R9QPnS6R1qNrL3HenEjKojdbvG3fpnmKrARsM0Sx9iBLVwkjG4WSm39Sq1roAJfuxoM1gMS4RWbOG85eArGNzihFc686sSnSKzKNUFCmr/Oom611Zy80NXWSyhakur4L3KmAq1jwehsPeKiC5jJIVfUVB0ookFRFfQkrdEDO+S2nFIizn5pz7xTObMBOcMYmf5Fuv3AiLDxvmiN9EZfSFeu4Y6EfSfvsJFr+UnHmLrrJgXcYGdLqNtoLHHSfTiIusmUVHe4DcE/ot10ah42Z0aJKYq
 n2PPOcli
 KW8Hq11nlOGGReNWdU/1nLU0jDJttdwHEJNG5bDJq8t1uI8Lf2jzIW0pWMw/PBuKaCPIwo3Byl64PqMeUU4EsEPaBzR6IIME6JcOqMIXeynYqnBYPVXpLdmzYPu66H/1orOsQ8zj+4zsWAWKYi6p634m51ZMEBRCBAmBtRcRNXkBRaFB2dDrXGA1UG5EvtTi5YdhvhyGjAFLrSw0x2RK46GsIfGltuiVdM8FSZ9esDLJNNUIXSyT0pdmdVHjyJnpFkHnAgjBKetZCybWBHlBoQYfHgvgIw+pFhtW0SLbeOmAJZWyAiotpEadqNwoEG/RZ5cuiEsS8CkTetnawXh9g/VgGUogAWMHG/jLEwC7lXzTJigRxPhEzG+5E3hlOVoE9pFtBcvxxOnuFXDwn/X3cNN4YgsIDhI1c6sfRDt7VlrAlIcoOakA77IuBZ56n/op+J1at
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
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20260116/202601160504.h8ijlURr-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601160504.h8ijlURr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601160504.h8ijlURr-lkp@intel.com/

All warnings (new ones prefixed by >>):

   kernel/irq/irq_moderation.c:409: warning: ignoring '#pragma clang diagnostic' [-Wunknown-pragmas]
     409 | #pragma clang diagnostic error "-Wformat"
   kernel/irq/irq_moderation.c: In function 'rd_stats':
>> kernel/irq/irq_moderation.c:432:54: warning: integer overflow in expression of type 'long int' results in '1410065408' [-Woverflow]
     432 |                 recent = (now - epoch_start_ns) < 10 * NSEC_PER_SEC;
         |                                                      ^


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

