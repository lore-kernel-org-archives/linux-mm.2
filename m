Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B366CCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 10:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCF8F6B0005; Tue, 19 May 2026 06:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7AD56B0088; Tue, 19 May 2026 06:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C694D6B008C; Tue, 19 May 2026 06:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B66C96B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 06:22:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 613661C0C3E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:22:24 +0000 (UTC)
X-FDA: 84783779808.07.80DDA38
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf26.hostedemail.com (Postfix) with ESMTP id DBE3F140003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:22:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="AZqj/CQw";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779186142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nl4QP/pFSkCBnR0NiIRdiZi8Zdw5ry2aeOZHRW/VND4=;
	b=wcoKp84/496OC739JIVtx3+yqezZc69XujCkZ5/Yc5rByTBNpeNAKT1EOEPfO2XJJQaOq6
	gk57m1tEcxWdgmePk9QtO/PATfAn7i1AAzaMx4IeBtmQ0ATAfkzS8GTEit+GM7NLQLZZku
	e1ds0I6GLKQtFkq7iSWg+UYvcq0KtNc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779186142; a=rsa-sha256;
	cv=none;
	b=OxuzgFjqsMH1GHF/ABeUMfiXOmoN+5mfZ3rH5JVR7DiCtROtZPmB3Ag4nXi97R+3WvrYEi
	9AScW+VIu961Du4A9IJK9GPBtlv5O3+hzSLsvYW5Yo9gQc5COuU4crw6PGq8xCF8J/6Hcb
	XSaRrYvoah+Ct274tMsHIdiUeSFe3xE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="AZqj/CQw";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779186142; x=1810722142;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ewdPDTiQhFrvxbPxw/3DPaoZdfhQjx/FTRinF4ewakw=;
  b=AZqj/CQwk+Bi3Rt07Lx8SJ/vOg1NDDIeqbcPCMZT1eq3ESXez2Mo0ua1
   L4rIwaOSZb7NYDuCwiChbZrCThuKqVZyLnGUAdKp4f2Sr0QlTVLc/X2aZ
   64TaeLQTyxxPPNPfAwvFV2bVIw1+Ru+bvlL/85rGh2Dt8LG/v9FP5Clxs
   RpKOtB6chG2EMmln5T52ZyovztbEXlR+O3lWgei+xPaStKq/bKTfLPVzE
   5lNHP1J75EZRc47TKj9S/hKDOj6YfbzQA9siZzcUtt5A7qB2psH1d9iIm
   lQs2+ZjiI4sAD/ivsT0NeTAHtnj8rxXWLC3v6QJRQshYI/smq6B8XFjSW
   A==;
X-CSE-ConnectionGUID: LYNzbhkDQc25TQSgnOC60w==
X-CSE-MsgGUID: aByAOGq2SDWinH7Q0wQW8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11790"; a="97493556"
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="97493556"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 03:22:20 -0700
X-CSE-ConnectionGUID: P9Y9iyfgQkGfFLA8L0a1QQ==
X-CSE-MsgGUID: QqzttTygREOSCCLLS030/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="237107315"
Received: from igk-lkp-server01.igk.intel.com (HELO bdf09bfdbd5f) ([10.211.93.152])
  by fmviesa008.fm.intel.com with ESMTP; 19 May 2026 03:22:14 -0700
Received: from kbuild by bdf09bfdbd5f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wPHaW-00000000A9l-0SGx;
	Tue, 19 May 2026 10:22:12 +0000
Date: Tue, 19 May 2026 12:21:39 +0200
From: kernel test robot <lkp@intel.com>
To: Leonardo Bras <leobras.c@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v4 4/4] slub: apply new pw_queue_on() interface
Message-ID: <202605191244.2uTAvERx-lkp@intel.com>
References: <20260519012754.240804-5-leobras.c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519012754.240804-5-leobras.c@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DBE3F140003
X-Stat-Signature: xgifo9ubrfxjnne63teu71rkrxatajx3
X-Rspam-User: 
X-HE-Tag: 1779186141-669230
X-HE-Meta: U2FsdGVkX1+X9KwiYVeVa8BX8bVRyXYfzEh8eot/FeSFsIPfRMMqTEx2maIaQLwR3mHSIQwarGCwK/a0C2IGG+1bzjJZ5P21tVS6fUjypdhR/xrXhYlFqyT1v8zDrEFmF3B9qxgYlD6+siCnis/BkUG9ilbBBqPsDxujRQjlYHUM8drOHkzws0H+R8YlRA07JSYLrZ/WT2xR7aOJVsIFEZyH95kS3vmDmEDF4yVRnpS7lRuO24zmUUWiDVCLXdtW+SHfqX5Xpf+5CUatR0ANvONykx2jeqBkIrJ4SZu3OmtdkciokfoSK/EJBZCUPXecvktWRqPKUbb/M0UoBLgQvqWGw26facUlwj/frvv/ssJ4t7GiRnMwEw8jI74UjfboeRbRt31Yb9xeT/Ccn8AIV1smRFPAJq1YRTonOWfgltvpooT+d/3wzT35Jy/eHnNXU8kNjNxLQeDM/5C/wk/eBkdZgZjHC+UlYbt6ho+qAs33Dveij/WwkButYrPU+yautvjLeoQxeTy8u8nNEFsdnv9Q6Fqo6AqnaEzQ3vLbdC1/qRFx0GpDvD+NuZauwbO3wA6WwXun/gxfmTet/XEBpQuJcAj6I//xDbTdFATLqaNJcnrhXTJKVLp0rVNKP3kiA4gUu5/Icrj+GDMYsE3j2R6GemzyoSjF1nvS4qaoEvB04qUxrQOeNoSrFp+ujAP5c4NT/KgtZ09BZMaGmr4ZhgVnKKcHbJw3t8oIIk0+f5eJ3Q8cWask7A4motAI9NhTwdSlYmhJ5TX+AsHv1noqBvnfWMiQrQGvxDxh9O20/Ys32RsgwfeS4PvTCE8pCsOD6I2eGVm/Caa9gp3h5A8C7AARC6xjJ97RTyaIXGr4y0G9V8KfWH+FI122BE6tBPpAkerpBdsFIC/AzVyBUBLOEEUjmxW/EYBMR06FUcDWhg9txirxlhyUyvFuT4p3YMEhItWSdwJp+R69r1cBAv8
 XEASdSVZ
 adupv10oPN0t4XnJDg0hW3UgYmNFVBixpU7hUfnLRjQcjkotK+RiIKA7tDpVTVyk0+Xok3noq0XHcOaVptTWl71CS95grgSd+XQjRlI4ncym3tGspwabPhQrMO37u3Y6CktEt8W+XTeIANuwrY1srULeFBKuH/7/tMoRShh2bowXrANaLougau93+l+angidl/VAimpAMB9tSMnW+tFSyMQStVvR8WwCnAJLsJKId8Ag4zSZ0tVFivV3SV8C3aBJ1zapHeKwi+4W7GfWnAXlVXXxrdyUd0rgElHj8HtRstlD2mZMg1JPdnP0pP/R3JNsR0QFuqKc0JRFNQVS/crUilxwcNRAkwlspMaZWZ8bUawLByCtk03NKDHzfqht74d8LhyAyEeTBRW2zjrnZ4+OcOI8DthDF19aX4tRdeWgs7hZZGdvXaYQPMTsZCv6ESCaJDaNGopYVFc905ovnnhfLSEmBxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Leonardo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 5200f5f493f79f14bbdc349e402a40dfb32f23c8]

url:    https://github.com/intel-lab-lkp/linux/commits/Leonardo-Bras/Introducing-pw_lock-and-per-cpu-queue-flush-work/20260519-112741
base:   5200f5f493f79f14bbdc349e402a40dfb32f23c8
patch link:    https://lore.kernel.org/r/20260519012754.240804-5-leobras.c%40gmail.com
patch subject: [PATCH v4 4/4] slub: apply new pw_queue_on() interface
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
docutils: docutils (Docutils 0.21.2, Python 3.13.5, on linux)
reproduce: (https://download.01.org/0day-ci/archive/20260519/202605191244.2uTAvERx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605191244.2uTAvERx-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Runtime Survivability
   ===================== [docutils]
>> Documentation/locking/pwlocks.rst:3: WARNING: Title overline too short.
--
   Documentation/userspace-api/landlock:550: ./include/uapi/linux/landlock.h:45: ERROR: Unknown target name: "network flags". [docutils]
   Documentation/userspace-api/landlock:550: ./include/uapi/linux/landlock.h:50: ERROR: Unknown target name: "scope flags". [docutils]
   Documentation/userspace-api/landlock:550: ./include/uapi/linux/landlock.h:24: ERROR: Unknown target name: "filesystem flags". [docutils]
   Documentation/userspace-api/landlock:559: ./include/uapi/linux/landlock.h:168: ERROR: Unknown target name: "filesystem flags". [docutils]
   Documentation/userspace-api/landlock:559: ./include/uapi/linux/landlock.h:191: ERROR: Unknown target name: "network flags". [docutils]
>> Documentation/locking/pwlocks.rst: WARNING: document isn't included in any toctree [toc.not_included]
   Documentation/networking/skbuff:36: ./include/linux/skbuff.h:181: WARNING: Failed to create a cross reference. A title or caption not found: 'crc' [ref.ref]


vim +3 Documentation/locking/pwlocks.rst

     2	
   > 3	=========
     4	PW (Per-CPU Work) locks
     5	=========
     6	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

