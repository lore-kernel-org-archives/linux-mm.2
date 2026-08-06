Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11021C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 21:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1C36B0095; Thu,  6 Aug 2026 17:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9734A6B0098; Thu,  6 Aug 2026 17:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861576B009B; Thu,  6 Aug 2026 17:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4030C6B0095
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:51:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C7B8140197
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:51:36 +0000 (UTC)
X-FDA: 85072191792.22.C8493A1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf23.hostedemail.com (Postfix) with ESMTP id 95A1314000F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:51:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g1aIdj30;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786053094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fdNYUN2NKYN/Z1c6wkVpv11hDVgUadb9eUS5kEIFV7Q=;
	b=qJmUR2P4V57WNS5NdWDXMfBY1gFbGcQy7bAfTxzp4q7XVy/Cu5cxIAQP0RVtoN/nt+tdmM
	XclUvbs0JsENf9bh6bRvmlPgHmQatUQFYT2rSX5/I7TNvC0NW/LqjU78SZkUfof1hFkUgZ
	7YT1NUB8DLWMysIaZDv+tWl6CRwHmTk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786053094;
	b=FTgkHAU94nBDite/KijjJmg5KfFmaSre8b1VsCKtiUv/OAtATwyBnPWsvTX883iX/oxds0
	8JSU/kdjtBmwq9ZgAJ2lUO7O5EGqXTN+eO8PFI6olBsXsjD/dBTb/lq6BFWwJ5cu+dN4X6
	d6HvbG0VQU9NBGZEkTMOgGeRzyMbPcA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g1aIdj30;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786053094; x=1817589094;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7YXZzO7rHKj6qKOZ2jDkYVaRVikc1Wt8k9LrXwdPOkI=;
  b=g1aIdj30QfYjTeP5063uMzkZ6DhCRZaheT+da0raPzec5fc631rGypZc
   77KR8ahJkWPoByqQYD/SgzXL+CypJr2UUqAdb9LM+92mg5X/8GR6ZhigQ
   MVOaS19QqE065KX/a+V6pouKinp5KUTidHt3A/PU7xrvxhm+C1ar/yEuc
   0bZpe9adZeyTlmGWl3xLEmKqXcT3drUuRQNNRqe26U7UtLs97A9eWuV8y
   b3DVZDcBkST8aXHqpUuoR8pVuUtQfDU+9P/51FLdTUYFOKkuIRby7rtRE
   MBbXoFkIoLoV5SVS7kZDEAkIGAg6jsEGZS32uJ9sZftDo3mZYrt+R8XfI
   w==;
X-CSE-ConnectionGUID: Kpla0hvMS6usoUvCYB8xGw==
X-CSE-MsgGUID: ZLFEplIHSRySFncYs2ceAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11867"; a="85630874"
X-IronPort-AV: E=Sophos;i="6.25,209,1779174000"; 
   d="scan'208";a="85630874"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 14:51:32 -0700
X-CSE-ConnectionGUID: AB8YyTXOSCSKko1pPJhpvA==
X-CSE-MsgGUID: gfPYtjsYTwuf1P+pMEQQWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,209,1779174000"; 
   d="scan'208";a="285586569"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 06 Aug 2026 14:51:25 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1ws5zl-00000000GKf-1GLg;
	Thu, 06 Aug 2026 21:51:21 +0000
Date: Fri, 7 Aug 2026 05:50:26 +0800
From: kernel test robot <lkp@intel.com>
To: Markus Elfring <Markus.Elfring@web.de>, acpica-devel@lists.linux.dev,
	bpf@vger.kernel.org, coresight@lists.linaro.org,
	kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	mptcp@lists.linux.dev, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, virtualization@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alex Mastro <amastro@fb.com>, Alex Williamson <alex@shazbot.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] tools: Use fputc() calls in some functions
Message-ID: <202608070547.MRKfa3bH-lkp@intel.com>
References: <48f2d61f-d468-49b7-881e-f00777db073f@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48f2d61f-d468-49b7-881e-f00777db073f@web.de>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 1qwaxg1mrtknhf7x4x4p6ecjxrbrcy6w
X-Rspamd-Queue-Id: 95A1314000F
X-HE-Tag: 1786053093-573544
X-HE-Meta: U2FsdGVkX1/qg7sUMqr7gVJsFawXKoPCQ4cc3D1bSzSTIPxoA7G+fV2md/GhHb76v+2Wlt1Nw3fC/zEUzMbMzVBCUl+C061tLKb5xmv8T7B7jns582YaUHacokGYlEsC2wDRNgc9gdV8eNblO+ar2Y2rv/bnW0xGn260xgZQ78cHEYS8u76os4SljSbUhB1jYolx1e67Q215zFy6MVQ1+X4s6oS9NLAFTHJZQ3U3R1DbTrvQGV+g5mi/m/Wpo3YdeiM7+VKOmmLwh1jibVFT1NWLyYKlQE0kKuyS4uH40KVViJIfDZ/GsQSZteKhmMbzcVZXd9LU98Mq1MuID7NI5ducN2fC3lyJbd7Jn7YCljLVooQMOyo+4AZQB3BGkcm9e7KN2Z/6OAVYSHlih1z0dG5UXr9foeB+mUiOVZQ7/33oJWMLxoZG3+SFUZ1UYDwJ2DAA5z7WbEutAUfvUigsMePPaHQXYigKSDnVLjxQetwyynEv7mtS9x79mRWPGUSqT5/OjPSqPhZAUilBAQAdOZiN4rPFCc78/yIkUcGHXw4wlmWAa9IptxqFpvZGGyot6MDPWPkGSfTFTXHWujew9VRlhICfkXGwwE7nsLxUu6N9JTs5MJLxKJxd5JrnPhZuQA7dtMJ9l8V2KWwGug1yjDWrXNiww0UIEKff7gwSF56OSQ0jOg4NG2ichoaKwqj9E8ltBYF7zlUCFcU9Z26wApmzrFVkSX/fvT3iTTDTAHdy3ghrY5HPDyjOw8JX0MSxTu/OCzjNPBBFffJPf6KrTYT0JIHyOJglmAhB0I7R171p8af2BMnmQ44m0hO6r5XIRs8eVvHhc5lSp5H7+RibzQhQ1ujJec7H1YUDXJjORHlWfCVTQZ7GNn9/ydyexsPYlZcPPU2swKVti5I7LuY2eVKipW9EX17qu3JI3MsoSUnsv4n8OLjB2Xw6/emcqbltNng4/blGNJ971hcllpD
 XUGOpy6X
 ZHkdfzQ/9iXlOMms02BhRS4Tow9RIguOZSuQniJ5/SNWkjR7nmEdqTgCfkMntyw0oRYdgtv+iiv62EQfai4bi5jD6Qj1mbOuZklQPks8zegNB+Rc7QpdmRnogdBcjZdNnwGwTGJdqnWc508CGgb30y6Vr+xS1dYd9q5wEU7ousbT1dUv8SBmlVUpCE5AM/jD89mm3haa9bw/sCrGuLWvSF6MySVGtwxC6C5eCVR0SLuuUTYjRZxoX3P31uKZ3P6Ko1m01a52iG29DignMraoFxuJOEYR36L8q/s0EnwXIXArYsdfalJ4y3SjhTFkqO0aGKtts0CB7MAskPyEedEOa7zCafOzflPObO14nT43FLWbCcPPvmXcdnzrlsdHKKjCPCaOaxju0KD1lFAwwoJvj4cam99PivFgeujsSmdTdBon76FucaUHLliYdI83wQZa2NkIzGSWXZGFpO7z8nZQHLms/qtPgrsolcgir34DLSNa0QI8OJnexoEToaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Markus,

kernel test robot noticed the following build errors:

[auto build test ERROR on perf-tools-next/perf-tools-next]
[also build test ERROR on tip/perf/core perf-tools/perf-tools linus/master v7.2-rc6 next-20260806]
[cannot apply to acme/perf/core]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Markus-Elfring/tools-Use-fputc-calls-in-some-functions/20260806-165154
base:   https://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools-next.git perf-tools-next
patch link:    https://lore.kernel.org/r/48f2d61f-d468-49b7-881e-f00777db073f%40web.de
patch subject: [PATCH] tools: Use fputc() calls in some functions
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260807/202608070547.MRKfa3bH-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260807/202608070547.MRKfa3bH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608070547.MRKfa3bH-lkp@intel.com/

All errors (new ones prefixed by >>):

>> builtin-check.c:300:8: error: incompatible pointer to integer conversion passing 'FILE *' (aka 'struct _IO_FILE *') to parameter of type 'int' [-Wint-conversion]
     300 |         fputc(stderr, '\n');
         |               ^~~~~~
   /usr/include/stdio.h:155:16: note: expanded from macro 'stderr'
     155 | #define stderr stderr
         |                ^~~~~~
   /usr/include/stdio.h:611:23: note: passing argument to parameter '__c' here
     611 | extern int fputc (int __c, FILE *__stream) __nonnull ((2));
         |                       ^
>> builtin-check.c:300:16: error: incompatible integer to pointer conversion passing 'int' to parameter of type 'FILE *' (aka 'struct _IO_FILE *') [-Wint-conversion]
     300 |         fputc(stderr, '\n');
         |                       ^~~~
   /usr/include/stdio.h:611:34: note: passing argument to parameter '__stream' here
     611 | extern int fputc (int __c, FILE *__stream) __nonnull ((2));
         |                                  ^
   2 errors generated.
>> disas.c:540:9: error: incompatible pointer to integer conversion passing 'FILE *' (aka 'struct _IO_FILE *') to parameter of type 'int' [-Wint-conversion]
     540 |                 fputc(stream, '\n');
         |                       ^~~~~~
   /usr/include/stdio.h:611:23: note: passing argument to parameter '__c' here
     611 | extern int fputc (int __c, FILE *__stream) __nonnull ((2));
         |                       ^
>> disas.c:540:17: error: incompatible integer to pointer conversion passing 'int' to parameter of type 'FILE *' (aka 'struct _IO_FILE *') [-Wint-conversion]
     540 |                 fputc(stream, '\n');
         |                               ^~~~
   /usr/include/stdio.h:611:34: note: passing argument to parameter '__stream' here
     611 | extern int fputc (int __c, FILE *__stream) __nonnull ((2));
         |                                  ^
   make[5]: *** [tools/build/Makefile.build:96: tools/objtool/builtin-check.o] Error 1
   2 errors generated.
   make[5]: *** [tools/build/Makefile.build:95: tools/objtool/disas.o] Error 1
   make[5]: Target '__build' not remade because of errors.
   make[4]: *** [Makefile:123: tools/objtool/objtool-in.o] Error 2
   make[4]: Target 'all' not remade because of errors.
   make[3]: *** [Makefile:74: objtool] Error 2
   make[2]: *** [Makefile:1587: tools/objtool] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

