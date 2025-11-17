Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB34ACE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 21:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C743E6B0006; Mon, 17 Nov 2025 16:37:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4BB86B0007; Mon, 17 Nov 2025 16:37:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88E86B0008; Mon, 17 Nov 2025 16:37:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A87A46B0006
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:37:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5AD8913A1E0
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:37:03 +0000 (UTC)
X-FDA: 84121409526.11.931B910
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf21.hostedemail.com (Postfix) with ESMTP id 873EA1C0006
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:37:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="jNo7B/ti";
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763415421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAFuTK+bVwfMJm40Q2hI7TDRdxCZ+xiOjEH4voKAFYU=;
	b=a7QdizRgvx9xxUIuCb7CTqtN41ERhSd9nTomzVR4bftQCVpqc5lds79MAohqw2cbP/m+ig
	RbZHE5xT+yY/hd2jADcp65pLsUaYCoo1M16gSOTZd+KfNHwtMIBk8MKo5SF7B8Qs1/+BKC
	Zsq1YAmkvEF2j+TXh+GZtn8xBiQoOJQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763415421; a=rsa-sha256;
	cv=none;
	b=xlaDsxpf7JQAmt0MhEpAkSdLQbiOfJMWp+sKW+AScqLNrAGwquBO1d8PeuiwXbxzkRENip
	HptsFseCPoTdm+/SKl77eDe4BODYRjTpRdLsW5DwoJQsnz9BPjDTz3Kj6J2hCBTlAVTBoT
	6LdpwhQMRDdCUm4kR844ArnBxVtKqac=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="jNo7B/ti";
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763415420; x=1794951420;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bf8UyhqPDQoEyCkoewkf1JAlHPpii8P9/c+ZYX7vczg=;
  b=jNo7B/ti1a2apIKcJWmIgMHVFIiojsVcYjdI5BqyDBmr04kcqC9OlGWB
   KHSh+DQv3mtTsxlkbUAFbxxfiw5UroCYyxAFc2h/HqMAQx8ybLcLSBChy
   zyPXVhmv7Bd1k4Tu5XLfrhaIViQ5B9Ns8kFB4FbvhxiNdkhlg1cdXud4o
   YG5OG/l6LMLbRt5gudjW5egcuPZIy70dSOaz0xesi4DM1P8wx8fPTtQLb
   ndADAzkEM3ops23TjKBREljp/j+GTDbdZVnxFrTO5Cfpzm4EhTWPPlMiL
   KvaFVVY1MI3OzqFIyqvKnviLb9X6H2yOG1lenqQIE3lumKyX7GPTmVBAi
   A==;
X-CSE-ConnectionGUID: H82Bco1XQvKI0wW/mvgCcA==
X-CSE-MsgGUID: yBvHbBNOSWCH+0wDCbeksA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="65360969"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="65360969"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 13:36:58 -0800
X-CSE-ConnectionGUID: VIADsAQyS8avbJCvaT6BvA==
X-CSE-MsgGUID: QNzfJMSHQ9qewTBflfn7gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="191006777"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 17 Nov 2025 13:36:54 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vL6u3-00015R-2h;
	Mon, 17 Nov 2025 21:36:51 +0000
Date: Tue, 18 Nov 2025 05:36:07 +0800
From: kernel test robot <lkp@intel.com>
To: Luigi Rizzo <lrizzo@google.com>, Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>, Luigi Rizzo <rizzo.unipi@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	Bjorn Helgaas <helgaas@kernel.org>,
	Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v2 5/8] x86/irq: soft_moderation: add support for
 posted_msi (intel)
Message-ID: <202511180439.x4dMf653-lkp@intel.com>
References: <20251116182839.939139-6-lrizzo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251116182839.939139-6-lrizzo@google.com>
X-Stat-Signature: dds6stdyaeb1dnro79cracnfipbp18iu
X-Rspam-User: 
X-Rspamd-Queue-Id: 873EA1C0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1763415420-516314
X-HE-Meta: U2FsdGVkX1+hT5yTP9Mw2ZU1QbqzjGjjQ/Vw4ftdnVmUEmY8dk8zXzjZFy2tTkJZiFgfn1eAAwMBooeu9HVMh1ktHyRnjUbwXymnv46zlCzidbEHONKKWaEyHhLpksMeitQ8jiZ/puQCg7213dNzJBconcbt4OXWhsD+GBUPOVyXFvCNbLIioRyX7AbQ6W7LZRbCrQVwLqy8Qp1J/wue6jSjsim7p70+pa8G8Idl3x93v8wcSJkII3Xak6hD3gXCUuJAnI4Cp4CMyMaNH0FuVA9EQv2gamRez7PBGZjgS5V3xKv1l6BmuFfbT1cV45xrSEox6+cif2Y/NqLadtJPC/ya32aCqxYnMaOqvTKDdZv7Ek59rRUEDnjl6EFM5jsZNMstJokIUgmIeqmhnTrBjfJ4mJ0DFCfWZVUlnE1kIP8jj5MQVjzcsHyeRCjd6LeEG8oLkoim3F09AF3n3ilbUcxoyfbQVhNkDg6KsjEEOvgORoCUvDAPdYbisZWecQKh9iXUNLvD+IwYquvt9UpkWyR4WVjtXMaY5dHSjKJozBlWyp0UuW742zp1EMpIrIsx2Ty7WFf53Nj/sgd1+X6PhgZpyC1FS4nU774uaokZCvWIPnK92nNy2mWG0Bss7Ui0TW77ebN1qXqppzXE7xOuFZex33nNj2K8XK7pcSaumyaP/9XiPcA6wD4CdgHmiDHDF5P+MnB/ge/eGkb6qN6p2yiB8dKFKy3kvlDfUlEpA++AvrNAv2v8UZ4Lpovl+uUS7n0SlUIZVGLRUYvpcWBCDNSviJhX/3ijcQDMtod1uwuFz4cscX56dXf4qHwsNVfMkQelDaxt2XFP+sbcH+qGp7rEeNv83bhOpoAlgXBmLQaBzSYimYXQgVa2QF0X94UFLslwl3GVd6WRo6QrxvJCk9S63z7e94GIDTyaLAGAMChtzL1iROPKjy8sW8jD0rBiOsh9VuxSeSjdhr0zmif
 UCXFzsvH
 ZgPiP6Ulu9gARL18b9k2tKtTbJsJ1yMI3oIqi+EPBVWKEAs2994j1T/AzdDinoV3U8HEQpJ7vvOGBeyA5khe0sM/55Mlzq0LucGmgEPicdgBJCQUoF5Gg0NPvgz1ejnp2/AblLOq6gcg8cy2jHo6bKjBpRCg9jDPtasGHFpErTxM0norUlfcRaocMZj+b9qe4Yn8VNpNf+7uZNZvIHpebAq74chPWtBCG6dCnHkyclBGyYtACNHhpMIFBscjzj+CYaIyTCD5npbRKd1yVL3L1BnL4ekpmzjl++n4AtOLgl5Et/iSa8FQtbTyH7B+1kwy4R+h0ntGB1adyekRMUjtEaO53fNq5HUSKxg2AZq6R6eOiOQaGt32G3MUf8t4M9AcrYYlvmDRa8NiYbPfABv2rb4UGm6UfQhiJ9s5yJ7foG1JzwBK2FiJMKGLZUeVmHVFF+FmFC2YAx7JyOmC0uUi2A34kifsuEdJrDJnVgCjmhmcEgHrNjOoRjnPQ8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Luigi,

kernel test robot noticed the following build errors:

[auto build test ERROR on tip/irq/core]
[also build test ERROR on tip/x86/core tip/master linus/master v6.18-rc6 next-20251117]
[cannot apply to tip/auto-latest]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Luigi-Rizzo/genirq-platform-wide-interrupt-moderation-Documentation-Kconfig-irq_desc/20251117-023148
base:   tip/irq/core
patch link:    https://lore.kernel.org/r/20251116182839.939139-6-lrizzo%40google.com
patch subject: [PATCH v2 5/8] x86/irq: soft_moderation: add support for posted_msi (intel)
config: x86_64-buildonly-randconfig-003-20251118 (https://download.01.org/0day-ci/archive/20251118/202511180439.x4dMf653-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251118/202511180439.x4dMf653-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511180439.x4dMf653-lkp@intel.com/

All errors (new ones prefixed by >>):

>> kernel/irq/irq_moderation.c:369:6: error: call to undeclared function 'posted_msi_supported'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     369 |                    posted_msi_supported() ? " (also on posted_msi)" : "",
         |                    ^
   1 error generated.


vim +/posted_msi_supported +369 kernel/irq/irq_moderation.c

   321	
   322		seq_printf(p, HEAD_FMT,
   323			   "# CPU", "irq/s", "my_irq/s", "cpus", "srcs", "delay_ns",
   324			   "irq_hi", "my_irq_hi", "hardirq_hi", "timer_set",
   325			   "disable_irq", "from_msi", "timer_calls", "stray_irq");
   326	
   327		for_each_possible_cpu(j) {
   328			struct irq_mod_state *ms = per_cpu_ptr(&irq_mod_state, j);
   329			u64 age_ms = min((now - ms->last_ns) / NSEC_PER_MSEC, (u64)999999);
   330	
   331			if (age_ms < 10000) {
   332				/* Average irq_rate over recently active CPUs. */
   333				active_cpus++;
   334				irq_rate += ms->irq_rate;
   335			} else {
   336				ms->irq_rate = 0;
   337				ms->my_irq_rate = 0;
   338				ms->scaled_cpu_count = 64;
   339				ms->scaled_src_count = 64;
   340				ms->mod_ns = 0;
   341			}
   342	
   343			irq_high += ms->irq_high;
   344			my_irq_high += ms->my_irq_high;
   345			hardirq_high += ms->hardirq_high;
   346	
   347			seq_printf(p, BODY_FMT,
   348				   j, ms->irq_rate, ms->my_irq_rate,
   349				   (ms->scaled_cpu_count + 128) / 256,
   350				   (ms->scaled_src_count + 128) / 256,
   351				   ms->mod_ns, ms->irq_high, ms->my_irq_high,
   352				   ms->hardirq_high, ms->timer_set, ms->disable_irq,
   353				   ms->from_posted_msi, ms->timer_calls, ms->stray_irq);
   354		}
   355	
   356		seq_printf(p, "\n"
   357			   "enabled              %s%s\n"
   358			   "delay_us             %u\n"
   359			   "timer_rounds         %u\n"
   360			   "target_irq_rate      %u\n"
   361			   "hardirq_percent      %u\n"
   362			   "update_ms            %u\n"
   363			   "scale_cpus           %u\n"
   364			   "count_timer_calls    %s\n"
   365			   "count_msi_calls      %s\n"
   366			   "decay_factor         %u\n"
   367			   "grow_factor          %u\n",
   368			   str_yes_no(delay_us > 0),
 > 369			   posted_msi_supported() ? " (also on posted_msi)" : "",
   370			   delay_us, irq_mod_info.timer_rounds,
   371			   irq_mod_info.target_irq_rate, irq_mod_info.hardirq_percent,
   372			   irq_mod_info.update_ms, irq_mod_info.scale_cpus,
   373			   str_yes_no(irq_mod_info.count_timer_calls),
   374			   str_yes_no(irq_mod_info.count_msi_calls),
   375			   irq_mod_info.decay_factor, irq_mod_info.grow_factor);
   376	
   377		seq_printf(p,
   378			   "irq_rate             %lu\n"
   379			   "irq_high             %lu\n"
   380			   "my_irq_high          %lu\n"
   381			   "hardirq_percent_high %lu\n"
   382			   "total_interrupts     %lu\n"
   383			   "total_cpus           %lu\n",
   384			   active_cpus ? irq_rate / active_cpus : 0,
   385			   irq_high, my_irq_high, hardirq_high,
   386			   READ_ONCE(*((ulong *)&irq_mod_info.total_intrs)),
   387			   READ_ONCE(*((ulong *)&irq_mod_info.total_cpus)));
   388	
   389		return 0;
   390	}
   391	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

