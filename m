Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE41ECA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 18:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DC088E009B; Mon, 11 Aug 2025 14:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68C9C8E0093; Mon, 11 Aug 2025 14:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B368E009B; Mon, 11 Aug 2025 14:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48F9D8E0093
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:57:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA5E2160296
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 18:57:02 +0000 (UTC)
X-FDA: 83765383884.24.0CC1B94
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf19.hostedemail.com (Postfix) with ESMTP id A570D1A000C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 18:56:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TcB8590Z;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754938620; a=rsa-sha256;
	cv=none;
	b=WFcRK246V+nK7HipWfhdueCSvmHu+nPtM5U5cgdv8UhlIeRFvynhhvPd9dhR4Ixh8PPmU4
	8jRA7CPDXFSXRaHCvOo1FMUx+PTNE1PIHZ9JaMKM04KAiZrUiH0fILCnYMbWhodtpNZNxe
	N380rPRrfa6YpFe4FFYvipAPl31FRcw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TcB8590Z;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754938620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOiClcWhRLmnTns2P2I4vv9tEhkfzF4wGYKv5rYROa0=;
	b=eHpKdUapsqixemD1PYdj5rbZS2D9V7cdoZFc3AQw6aPzKvDhFi3zMfgd1zc07PF0h+ixCe
	fRka7fLOFOS4IcLCuSWVrxrW8w5P9U40SMRZJSL+TbGy4KwgkcLWr3TkC0Q/dUVbbplzbf
	E3QRMhEjk6yTNFE0s2t+/3UhhehUq5Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754938620; x=1786474620;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/1h1FXQ8wlbSgFHXbQzagekP6WBsykBAbMExF88232A=;
  b=TcB8590ZQ82jwquStI4N2e2ieOCRdWF6q95KnVM/diEJINRdFVve59/P
   JriBJZz8jFSJmY7wQEkxo/RbkrzR2C8b9ICadNRJNa5cKpOo2AAsVpUwo
   rUrBCv3B2Asi2uobEAr5B8jRS6R6xlflfo6erbCLfdi32/hS0w05kA4Fw
   XWNZ/zLjO8Qr/El4F1gftUQhRRO173DYIfKJUt2RC2jvtkgXMWKlN7EkX
   x9LnUYO9bpP95NtI20GWq38e9AQw6jUoGdAy3DshMFqIIFjVQGUBgvfi6
   faWlZCwUdR6dcY2DhbmFP/tqQI4Fi8tSwhjr85Eq7ilf0UhsZ1z/uWd1C
   g==;
X-CSE-ConnectionGUID: Bsac7tRzQkyxKU/2rbrKxA==
X-CSE-MsgGUID: 12bg9QbZQ4SZyKjub0VqyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57345000"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="57345000"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 11:56:58 -0700
X-CSE-ConnectionGUID: vpWZx5ZjTIuthikuHuwiLg==
X-CSE-MsgGUID: gJZTJWVSR5qvoV1h6E7NgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165192786"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 11 Aug 2025 11:56:53 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ulXhL-00069Y-0y;
	Mon, 11 Aug 2025 18:56:44 +0000
Date: Tue, 12 Aug 2025 02:55:55 +0800
From: kernel test robot <lkp@intel.com>
To: Dominique Martinet via B4 Relay <devnull+asmadeus.codewreck.org@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Maximilian Bosch <maximilian@mbosch.me>,
	Ryan Lahfa <ryan@lahfa.xyz>, Christian Theune <ct@flyingcircus.io>,
	Arnout Engelen <arnout@bzzt.net>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Dominique Martinet <asmadeus@codewreck.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] iov_iter: iterate_folioq: fix handling of offset >=
 folio size
Message-ID: <202508120250.Eooq2ydr-lkp@intel.com>
References: <20250811-iot_iter_folio-v1-1-d9c223adf93c@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811-iot_iter_folio-v1-1-d9c223adf93c@codewreck.org>
X-Stat-Signature: zmqj5w18oms18thb73fq5ihmumw5c99s
X-Rspam-User: 
X-Rspamd-Queue-Id: A570D1A000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1754938619-690211
X-HE-Meta: U2FsdGVkX188Evgo1gymSz1ivHAjIyy7xrCaVraEU8o+gyoAY058PmuFOLii6ClZA9iWD0pK6V2jgMMXtJptdiEs/dua42DNdLg2Z9nTw8KMrbTMQ1fFwoLrW2/wFS8FW+VCKW/DpPWT6+IX7KVvQ2AoPznp3VZKncusuXTcyzrXdP/g+T0Ee3dzAcQ3Wk2CEZBOHTA+MQ0K5OnDEY4bB59fd2ScSY+hEfpNv0yDFw5p6k4r5fPCy2Kan+wRxqqEtmoNnBhlqPCeer94Re6PFUGVnUXAluOS5M9UWo5X8UIzVWgho0PQZK2y75Zc4wqR0sq78YzE1udomNyvkZapEdUfNsA/Ec4PGw96K1Q8g7akGocTtEoD7loBhs5Fty+hIIlwTY+8sPgSgDR5iO1ld66chBEquzWXfxw64ASeTJ+wlkQ2GoYdNmlIoENXjFSfrPU3Z8taaWfoJ3PV+zc8mWIdEDkpNKFSFsEQFsFFOe/+3z2LzY/vbJkBhw7AzOBANrA3VAqRq1OxwyQsMt8hRxvoR2SoTMlxZBk0pUO7QPIVb0Bmdf3faer7YF6swpDtShj77ADsSMeYJhxHEtfwVogsKZiOpum2RnEKAYgqm2Be/umOk1s9kvpDiTkNKmXdxT56hJY/rx0qLRDQ9W7KYnCteETgUk6Lv++zTGBYcb8HuiDiPmG88ten7NlFEA4S1b8XX9mdVpufTV9DLpMEQkyHN9KNuTJJ4CezjI54+GZIY2iHuyMNjl75kjH9lyRE8q2PnvdPPyd6ed4v/HU12XZ1PiaJs8mw4lG9o1u/tlVheCTtyCSkwLoHg3fShtGdw98+a1n2KnhiKDUd6U9O5IanhNhbnS18wHS3eXe4COs/0BRPIwArUxbeoEPgB6/fKW6LiJS25AbU2QpV/W1BDF4ZjfhvbEivftwCSN17tjwGnclZzZ7EnzMmDgYxUAzdITC1hrLJVrAm9XEe6bs
 liS4y81x
 Zp7rBtahPojHYvMG2V3ZWO0QgCq0MTHTbJwmRdmQ+RG0yXPnFdZ0rgtyR3rqpKwk4bQJl2G+GXCmf2r70JiSsonI6YGu+DDSjwatRxsOIotaIrINfP6IR5M0yN0wx9X0EO6t5X2SzLc2ThSJc8pVsLqkoKLTakvCvGIRvxZM2hN8i0cqpEzyMIP63CeoCmPhVRekwOvhg42lUUaae2YM3GfM33TkzFZ6jVvauAC4s6ittZdzic3SCOYPwdrOD7ptQj4fNZNvhJv9FBQxq3IDdvfbnjeE5XiyIZ1wEIEzHlPOV0uOgj8l08/57vKouke8UfLcCpNc6pSFLZw29j6gn7Jsz3/hJKAOxikSTzAgB4sdyAzEH+TOdKn8aDvkdURQoKLI+9BIpHCbLwNwgfI+R1jA9eSz0M/B5wnW+rP+4/9lDxKR8NLK7cVreAOXXcnnYMxEv7vQWeU13ZoBuPzec4ruZCxLpRKKRV2/u0OSXuCxzfycwH7fh7iCiao85n0M+SGLLXno8zkKXAwcRKu0v/JBKczzRk224VT6A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dominique,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 8f5ae30d69d7543eee0d70083daf4de8fe15d585]

url:    https://github.com/intel-lab-lkp/linux/commits/Dominique-Martinet-via-B4-Relay/iov_iter-iterate_folioq-fix-handling-of-offset-folio-size/20250811-154319
base:   8f5ae30d69d7543eee0d70083daf4de8fe15d585
patch link:    https://lore.kernel.org/r/20250811-iot_iter_folio-v1-1-d9c223adf93c%40codewreck.org
patch subject: [PATCH 1/2] iov_iter: iterate_folioq: fix handling of offset >= folio size
config: i386-buildonly-randconfig-002-20250811 (https://download.01.org/0day-ci/archive/20250812/202508120250.Eooq2ydr-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250812/202508120250.Eooq2ydr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508120250.Eooq2ydr-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from lib/iov_iter.c:14:
>> include/linux/iov_iter.h:171:7: warning: variable 'remain' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
     171 |                 if (skip >= fsize)
         |                     ^~~~~~~~~~~~~
   include/linux/iov_iter.h:190:7: note: uninitialized use occurs here
     190 |                 if (remain)
         |                     ^~~~~~
   include/linux/iov_iter.h:171:3: note: remove the 'if' if its condition is always false
     171 |                 if (skip >= fsize)
         |                 ^~~~~~~~~~~~~~~~~~
     172 |                         goto next;
         |                         ~~~~~~~~~
   include/linux/iov_iter.h:163:22: note: initialize the variable 'remain' to silence this warning
     163 |                 size_t part, remain, consumed;
         |                                    ^
         |                                     = 0
   1 warning generated.


vim +171 include/linux/iov_iter.h

   143	
   144	/*
   145	 * Handle ITER_FOLIOQ.
   146	 */
   147	static __always_inline
   148	size_t iterate_folioq(struct iov_iter *iter, size_t len, void *priv, void *priv2,
   149			      iov_step_f step)
   150	{
   151		const struct folio_queue *folioq = iter->folioq;
   152		unsigned int slot = iter->folioq_slot;
   153		size_t progress = 0, skip = iter->iov_offset;
   154	
   155		if (slot == folioq_nr_slots(folioq)) {
   156			/* The iterator may have been extended. */
   157			folioq = folioq->next;
   158			slot = 0;
   159		}
   160	
   161		do {
   162			struct folio *folio = folioq_folio(folioq, slot);
   163			size_t part, remain, consumed;
   164			size_t fsize;
   165			void *base;
   166	
   167			if (!folio)
   168				break;
   169	
   170			fsize = folioq_folio_size(folioq, slot);
 > 171			if (skip >= fsize)
   172				goto next;
   173			base = kmap_local_folio(folio, skip);
   174			part = umin(len, PAGE_SIZE - skip % PAGE_SIZE);
   175			remain = step(base, progress, part, priv, priv2);
   176			kunmap_local(base);
   177			consumed = part - remain;
   178			len -= consumed;
   179			progress += consumed;
   180			skip += consumed;
   181			if (skip >= fsize) {
   182	next:
   183				skip = 0;
   184				slot++;
   185				if (slot == folioq_nr_slots(folioq) && folioq->next) {
   186					folioq = folioq->next;
   187					slot = 0;
   188				}
   189			}
   190			if (remain)
   191				break;
   192		} while (len);
   193	
   194		iter->folioq_slot = slot;
   195		iter->folioq = folioq;
   196		iter->iov_offset = skip;
   197		iter->count -= progress;
   198		return progress;
   199	}
   200	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

