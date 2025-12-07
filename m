Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34883D2CE17
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 06:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 833DA6B0005; Sun,  7 Dec 2025 01:39:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E3F96B0006; Sun,  7 Dec 2025 01:39:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FA336B0008; Sun,  7 Dec 2025 01:39:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5DDAE6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 01:39:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 030CC13B9ED
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 06:39:35 +0000 (UTC)
X-FDA: 84191723952.14.08E713C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf30.hostedemail.com (Postfix) with ESMTP id EDD9080002
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 06:39:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fnqrjoMj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765089574; a=rsa-sha256;
	cv=none;
	b=xpPwlbkwnw8xtd8YAVPyR00HUw/seBostwkjGAYJmA6zBJ2Nt3mHcwVQFVSWQb+xRMAJYw
	N54+BLbWKXdggWEMN2OL0EANVMnZ9jVjVG3v21g797+nkM9bY5COZdBwEkqUMjkGqTJ/gg
	HVpI1HxfjVCb88j2WTzfjZd2YEIC0qA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fnqrjoMj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765089574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qxfyjz7ZDFnStERhemLCGtg2Zk1HJsyxwmqJIWczdQE=;
	b=Vc3Uf1ZVfBwyGxfaFh23KugLnMSqJgiLNd2NjYOXAc5LDHA3rFLIaMYIBWXE6Kf+lZ20lP
	ubNxr0xsXcsu98VULxr+10FZm1JGea+mjoQlAQIO1fhEqznxb80L/QKid/uiVptqDCyxAU
	sTzfvJstXCCG+oAzN0V9zWLBCsM7gks=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765089573; x=1796625573;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pbE+100Y1YKroKAkTYk/uLmS8PZhwbDp1hFCivCCkvg=;
  b=fnqrjoMjLdj5MzEfXKS0lFLsiOkBW51g7P8VEAHgv7V0Qp3Gtj9hTIUt
   +pmdbQ/exNE1uW95hmxivYj7y/kOqbr9c8JOk9db3mi5StMNhMC77oFbz
   caU5j1LHU/FixSmiQ0dEjArBBfAS+rn0S7oGZtF4qE119ibWRCOoOQWSA
   uKjqvP1AbHLPTufiwyNRUoWnnJQakJW917Pnds4Z7CJ9j2f985MUz3kur
   SWqeygZwM+T0moZur85b+35gWNFufmiYTs0lcWsSi0LBexvrdT+eRSeaU
   xW8Qp1t5JDKCmqxJkLU8k3XwiRTwC64KPDnY2gMHBpQ/X15NX/y9DDV85
   Q==;
X-CSE-ConnectionGUID: UcVKU8utR9i/u1otQC+udQ==
X-CSE-MsgGUID: ODze+8lHQXmelq0LzRRpeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11634"; a="84665662"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="84665662"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2025 22:39:31 -0800
X-CSE-ConnectionGUID: ZwBl5cWrTguiEMdSvIKppQ==
X-CSE-MsgGUID: hkd5k31qTfOs9Ov9tTdBXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="200096334"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 06 Dec 2025 22:39:25 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vS8QU-00000000J37-3Oir;
	Sun, 07 Dec 2025 06:39:22 +0000
Date: Sun, 7 Dec 2025 14:38:27 +0800
From: kernel test robot <lkp@intel.com>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com
Cc: oe-kbuild-all@lists.linux.dev, andreyknvl@gmail.com, andy@kernel.org,
	andy.shevchenko@gmail.com, brauner@kernel.org,
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com,
	dhowells@redhat.com, dvyukov@google.com, elver@google.com,
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
	jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	rmoar@google.com, shuah@kernel.org, sj@kernel.org,
	tarasmadan@google.com, Ethan Graham <ethangraham@google.com>
Subject: Re: [PATCH 05/10] tools: add kfuzztest-bridge utility
Message-ID: <202512071413.502tHWLT-lkp@intel.com>
References: <20251204141250.21114-6-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204141250.21114-6-ethan.w.s.graham@gmail.com>
X-Stat-Signature: rq3xpupsrok8h515dt91zn8e4uxpuuhh
X-Rspam-User: 
X-Rspamd-Queue-Id: EDD9080002
X-Rspamd-Server: rspam01
X-HE-Tag: 1765089572-945457
X-HE-Meta: U2FsdGVkX19XdgSQmhVnYGmReUmyK0fKG8aEaZ7PadOfGy6f6PGSE5HfYw8eCZX2yPDpl8JWIvkcvq/yltxQF5klKSk5QbSgpXe48/XK2kQdMscrpP2YffJux31jm9CjhZJrziTAV9J9KfNJIJW34RIohTWQaHa80/Za0XmHqOv8k02qI8AAYOwUhlqxqGyoUQrbj0aNDT7kDLM3v5JxSrnqBdbhZx+fXSlx5DCjLOBaF4aDxwPJI2U/oy2iXUAqAHs1iM7d7W+G3zdrQNFpXacKP92aOGXHu2juMPWkKdsxfQImDdWe0RBSv2f0GEeN5JQ8JXVEx142G5OuGPJJd2k1loSjuLFmTr4xow0IEUoKJ0DWiEXf7Kf1UcGcfqV+Rt6YmH70ZeSjbFrxZEcQABkipFW9gUUlJ7q2gKpxh0VxvoyYTrONM/8WC9eUT4oY+Ol/fES0+gp8ouUEf9rFC1BqE9XkGR8pVYjvrgJTzxE9e004J5k2ckQkEnwNTGGyJ1IPd2p56zZ0lJhTqkjXbS9ePMZ0jTaFNbwoI64nm6v8FMGwDyRjifpOJcQeGk07LvzXDTkOic7g4jcu+ztsQOb5w5vbAI2dtO9wktngnJQnju9cuJh6DisN4sPyjXhwxPg7qCv6vE6TpctC3ngYdVpeycr9q1Q1XZwhAzduHXaXGoFr1WlY1BMJ54TU9xMMHzVUoSOA2MhYV2srp6lOXaxHQyiZm20u0JfFi4S/gQYBwta3FhQSLuuZ8ehOOahvnwkYRuEY8Qfthuuw/upnj+hYuu8mAuYnal5vDNOCHo5uXcsrHNPzxU9D0ScntmtfyeoJtjsSBQ9Pgj7nZlr9GJ35KlK2ldJ6SHLiPBxGKdIcHdlGIshQRWlVKstKAgSsoLHcCtl/Ngd1ichfjQuK6yczBWVNFYynQ9ZIQv5/rC7MH180z81xo/p/BNZTv9qbBlESgD6G8EqqjEKt+XJ
 tKpiFLpN
 2b2DXiLmwp07tWt7gX5wWFe5vXai2z7GRaDtjKsz9j5hMTvjgayQp+IfWXwqnL/0E7aUEdcFy+R/ZhjzsMDpeMw7TQiDSMHzrgKcypzlC50a+SKEbct0fK5JKjRydrZ4a9Ql/07yUZOzlAO/BHKqlxjqB6t5YgHE+IiqHr8RJyv+VN1FPVlSiKYCl+DC2jmyTBQzfNW6d30pln/v2h3HELLfn5oCJXK4fx1wTAH79trIAPXNUXBVuo/c72+vT3IsjajbtxvE+3RV73taYRU3LDV/q8r/e3eqD7iLBCbVO2VL92RQzhkonosHRLOmtd9/bcttsqHQzM+HrhDfSYDtXa2sUdyb+DH5hdRX293p39AQ8u5zyQasICQbikwiDmZETIsi1VG227k60zF8c5mkr6hfYb5KafgmHlFkDwi7yENjYNz+s39pVwEzhS0Jau0U2t8JC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ethan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.18]
[cannot apply to next-20251205]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/mm-kasan-implement-kasan_poison_range/20251204-222307
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20251204141250.21114-6-ethan.w.s.graham%40gmail.com
patch subject: [PATCH 05/10] tools: add kfuzztest-bridge utility
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20251207/202512071413.502tHWLT-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251207/202512071413.502tHWLT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512071413.502tHWLT-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Documentation/.renames.txt: warning: ignored by one of the .gitignore files
>> tools/testing/kfuzztest-bridge/kfuzztest-bridge: warning: ignored by one of the .gitignore files

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

