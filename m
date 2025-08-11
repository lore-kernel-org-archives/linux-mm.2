Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B655EC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 11:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7B28E000A; Mon, 11 Aug 2025 07:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57F3C6B0148; Mon, 11 Aug 2025 07:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46E198E000A; Mon, 11 Aug 2025 07:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33B376B0147
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:26:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD67E134705
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:29 +0000 (UTC)
X-FDA: 83764248498.01.4F8E793
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf13.hostedemail.com (Postfix) with ESMTP id A38A220002
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YjJGXcdx;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754911587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTZSSpN7MrXYlk6igjn6y71QsOK6zh9HIQLRCJcrfIs=;
	b=jruErK9g3v0nJ1Jmy4xbU2EZQsHcXKxqNN/tbhDCTjiem+74+JF3TntdYX3rXXBPkuhB0R
	9UDWxJTEUqeJSSVO52Rs0tk3RMSfaIbKnw9L08PvrbAYg0s4WGYvL+X2RnZ9d2UTOQ5gQu
	0FjVwlMxNwlpGDXOLhbD+c1FFXJ74OU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YjJGXcdx;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754911587; a=rsa-sha256;
	cv=none;
	b=PBA3RS2Mygu7D5pfHfIlmJdSImiycWOXAvQFA+0gLiRpwvpKSBsqM4uzCt2a/hcfJNN/CF
	HuHg5WFp7THQYGnyREk4pfwQvH8ZDnh3FPxgl1DvoM8pABOpKUEm75azSCU5Hh0glcXN8Q
	TnGfkFs2s8uijGIeMGWCOtNMze5LqMc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754911587; x=1786447587;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TDDUh3YZA77tPJQoxh3MNl7VnFCf8Gr5sBYtPCwEosw=;
  b=YjJGXcdxL5zQSExJWrtTsNozjS9Hogm3eiXSygXbJXpDjSJ/fgoQJ4o5
   e9mKCucVL5JySP+dwMcgcwV52LRLNbToxlYIy3/tP+vB25U7yIatDxaqx
   E2NUyMVigt/xJ/PZ3W08bHPWj9DHcNPjkmCfDDixmFl4CXf5RZKap7hAe
   Ip1oSA1zAHjjFdF4hhFZxI4yhtm3+ozwIBH9KGTUxT0/x2GNeoIVJOXJ7
   VjKhm5zF6YxzNxfAfzeOrEfwTHDLrKBJMi0KmeyEFqlsKAvFMiAb+Ucjx
   d9VEF0N10HPl2gQ75iLHw/sWw1a7nHuK4U1ZiQjlA4gUVag2gn8SYX5mr
   g==;
X-CSE-ConnectionGUID: VCVXGydIS/ywH4OSIneQTA==
X-CSE-MsgGUID: WSYp2kDATjCEXkumOikMuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="56367445"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="56367445"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 04:26:26 -0700
X-CSE-ConnectionGUID: XMSe7Xf8Rv6ifGt2ii8ehQ==
X-CSE-MsgGUID: GliJBp2qTrqFhVTD6cagFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="166251272"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 11 Aug 2025 04:26:19 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ulQfQ-0005oq-2S;
	Mon, 11 Aug 2025 11:26:16 +0000
Date: Mon, 11 Aug 2025 19:25:40 +0800
From: kernel test robot <lkp@intel.com>
To: Bhupesh <bhupesh@igalia.com>, akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, bhupesh@igalia.com,
	kernel-dev@igalia.com, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	oliver.sang@intel.com, lkp@intel.com, laoar.shao@gmail.com,
	pmladek@suse.com, rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
	alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
	mirq-linux@rere.qmqm.pl, peterz@infradead.org, willy@infradead.org,
	david@redhat.com, viro@zeniv.linux.org.uk, keescook@chromium.org,
	ebiederm@xmission.com, brauner@kernel.org, jack@suse.cz,
	mingo@redhat.com, juri.lelli@redhat.com, bsegall@google.com,
	mgorman@suse.de
Subject: Re: [PATCH v7 3/4] treewide: Replace 'get_task_comm()' with
 'strscpy_pad()'
Message-ID: <202508111835.JFL8DgKY-lkp@intel.com>
References: <20250811064609.918593-4-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811064609.918593-4-bhupesh@igalia.com>
X-Rspamd-Queue-Id: A38A220002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: mu5xad6icutcwns9bfe9sab9u3p6qu8q
X-HE-Tag: 1754911587-161230
X-HE-Meta: U2FsdGVkX19KKTo7HPJf/J7KLBoqX6/F0l+O2VZ98gfoXOACMi7d+4QPTGAWXnRoyue5r1MQqCXhg32tkpXOuNBtaOAK7bDWy6AqUdqLXWVuy0VE0AUe87JiulZoIlCSpwRzipkrI7ck9m3QSbfPRqX6AqMqV7lXRww6sds3mJog2dRjNtW/XV+5Y5qs8QCRrQINI2yGX35V0z48nrXL2EF8J+iT7mlnae40aV7A8HqueOZ398BXrlUtYfMxRMxdQYj4RX3l7zcT5CxV2P9PxM2USk40qOW4OU6VrnI8HspidiQ2WUZKD0ke6ypX2F79ttcfITUw5IjnJ+ucPS90QBI5S+4kqhETeHDUgh88XtOTYi39e2qKcC2AJCaF5/WYz8f09ByobxmtEViSDe0RelrQVPc09EWdLdz09pOWTnwpK33V8sW1S4kCOIVpDTsBPuvCe2VJGSP2IM96v7y0uoTLOBHQJgxjNbpv35wJtiPKpS/XlKcM3WHMqEWxLwbJaKV1g6mRAp9NcqbjQSKeTjORCmBN1orwqq/sjBLsgaWuaL5+sx9W3KzFdOuancxpF/AxlyT8jcBMIz4GSrr8lJ8m0mPqvli8+oVH2jrgRGJqDKnr/rhCG13bEQwUSRRNYnbiNq3sEWzS6MZkOTQpbFKbUyTuM7kNygGQaC92ONhmfLkRw+RKruS9sGQXB0NHCg4K/yOk1chvJztsQUtYL1+mUN8FKM3t2bF+YIGP3F8YRml/VJ/xluOIbpJuN0aPmndrM1vUxB6ZwhOmoVovGLa2wa2TQj5JI1LX1oGjkagpluQR/VPahgY7up+nBZ4UhjQeYNHPytJNpEU0YlJL8fvkD1wyCxs/9zNr3yn6/V/sqCxmHaSeK5BppdXAK6A0gLb8eL8tZVleH3UCgU5ioNeDbiv7IzSjGIFSyRCEqEMVChpjbG0yxJGaBe9nJVmDGyW2f94dsPh2Tdsmb6k
 yRhqDhPd
 WfYumr906IfhPdEhAYTbUE/bBWpSvAHjppoT95FJ5y0dRN1emKWdv7tfP2RcLn3MacPTiojnUhb9BvTf8ydPjj08d9eSOgmxTP3CVWvsHfqmhbb9XS+uS4dc9qS6klW2MAF3ggHsfNnHB12oeHMTyTtZ9gr2g3U8f6kqVM+7FzJhJmXxUWB85Iy07lMytPwqIziyjxzACMCOLMPlFzC6wV4txVO/AGoE4Wzeu9bpYsgwr790tJ/LKfJxJjx7jH/NYBxc5ok67JdUu1sklC6Bro+hi8AVDgI7O/xDYxZ6GlvtqVvxeFEV1PldqZb8CnPkafLxjp6QTyEAZd6D8r5MhznxqNqXNWKb/DFnaQFXXXRtkeGQ21HRzsFu6MnL5TRy0WMkLF3qjrGhvnpRAjOF+yh8eqxUWZruxbMvUrB+e5eom7gjRpgv45qW5GpZOqeHF3BPw5Y7taQuj20vJQNhsGHBHzTOzpE5ZMGyT0PH3eAK+BPk5uk2ijPBQd6o1Huab3KGjGtAuOqNlb/O8J+3VxmKkFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bhupesh,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20250808]
[cannot apply to trace/for-next tip/sched/core brauner-vfs/vfs.all linus/master v6.17-rc1 v6.16 v6.16-rc7 v6.17-rc1]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bhupesh/exec-Remove-obsolete-comments/20250811-144920
base:   next-20250808
patch link:    https://lore.kernel.org/r/20250811064609.918593-4-bhupesh%40igalia.com
patch subject: [PATCH v7 3/4] treewide: Replace 'get_task_comm()' with 'strscpy_pad()'
config: sh-randconfig-002-20250811 (https://download.01.org/0day-ci/archive/20250811/202508111835.JFL8DgKY-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250811/202508111835.JFL8DgKY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508111835.JFL8DgKY-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/bitmap.h:13,
                    from include/linux/cpumask.h:12,
                    from include/linux/smp.h:13,
                    from include/linux/lockdep.h:14,
                    from include/linux/spinlock.h:63,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/umh.h:4,
                    from include/linux/kmod.h:9,
                    from include/linux/module.h:18,
                    from net/netfilter/nf_tables_api.c:8:
   net/netfilter/nf_tables_api.c: In function 'nf_tables_fill_gen_info':
>> include/linux/string.h:116:50: error: passing argument 3 of 'nla_put_string' makes pointer from integer without a cast [-Wint-conversion]
     116 | #define sized_strscpy_pad(dest, src, count)     ({                      \
         |                                                 ~^~~~~~~~~~~~~~~~~~~~~~~~
         |                                                  |
         |                                                  ssize_t {aka int}
     117 |         char *__dst = (dest);                                           \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     118 |         const char *__src = (src);                                      \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     119 |         const size_t __count = (count);                                 \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     120 |         ssize_t __wrote;                                                \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     121 |                                                                         \
         |                                                                         ~
     122 |         __wrote = sized_strscpy(__dst, __src, __count);                 \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     123 |         if (__wrote >= 0 && __wrote < __count)                          \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     124 |                 memset(__dst + __wrote + 1, 0, __count - __wrote - 1);  \
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     125 |         __wrote;                                                        \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     126 | })
         | ~~                                                
   include/linux/string.h:86:9: note: in expansion of macro 'sized_strscpy_pad'
      86 |         sized_strscpy_pad(dst, src, sizeof(dst) + __must_be_array(dst) +        \
         |         ^~~~~~~~~~~~~~~~~
   include/linux/args.h:25:24: note: in expansion of macro '__strscpy_pad0'
      25 | #define __CONCAT(a, b) a ## b
         |                        ^
   include/linux/args.h:26:27: note: in expansion of macro '__CONCAT'
      26 | #define CONCATENATE(a, b) __CONCAT(a, b)
         |                           ^~~~~~~~
   include/linux/string.h:149:9: note: in expansion of macro 'CONCATENATE'
     149 |         CONCATENATE(__strscpy_pad, COUNT_ARGS(__VA_ARGS__))(dst, src, __VA_ARGS__)
         |         ^~~~~~~~~~~
   net/netfilter/nf_tables_api.c:9661:53: note: in expansion of macro 'strscpy_pad'
    9661 |             nla_put_string(skb, NFTA_GEN_PROC_NAME, strscpy_pad(buf, current->comm)))
         |                                                     ^~~~~~~~~~~
   In file included from include/linux/netfilter/nfnetlink.h:7,
                    from net/netfilter/nf_tables_api.c:17:
   include/net/netlink.h:1655:46: note: expected 'const char *' but argument is of type 'ssize_t' {aka 'int'}
    1655 |                                  const char *str)
         |                                  ~~~~~~~~~~~~^~~


vim +/nla_put_string +116 include/linux/string.h

e6584c3964f2ff Kees Cook        2023-09-20   74  
e6584c3964f2ff Kees Cook        2023-09-20   75  /*
e6584c3964f2ff Kees Cook        2023-09-20   76   * The 2 argument style can only be used when dst is an array with a
e6584c3964f2ff Kees Cook        2023-09-20   77   * known size.
e6584c3964f2ff Kees Cook        2023-09-20   78   */
e6584c3964f2ff Kees Cook        2023-09-20   79  #define __strscpy0(dst, src, ...)	\
559048d156ff33 Kees Cook        2024-08-05   80  	sized_strscpy(dst, src, sizeof(dst) + __must_be_array(dst) +	\
559048d156ff33 Kees Cook        2024-08-05   81  				__must_be_cstr(dst) + __must_be_cstr(src))
559048d156ff33 Kees Cook        2024-08-05   82  #define __strscpy1(dst, src, size)	\
559048d156ff33 Kees Cook        2024-08-05   83  	sized_strscpy(dst, src, size + __must_be_cstr(dst) + __must_be_cstr(src))
e6584c3964f2ff Kees Cook        2023-09-20   84  
8366d124ec937c Kees Cook        2024-02-02   85  #define __strscpy_pad0(dst, src, ...)	\
559048d156ff33 Kees Cook        2024-08-05   86  	sized_strscpy_pad(dst, src, sizeof(dst) + __must_be_array(dst) +	\
559048d156ff33 Kees Cook        2024-08-05   87  				    __must_be_cstr(dst) + __must_be_cstr(src))
559048d156ff33 Kees Cook        2024-08-05   88  #define __strscpy_pad1(dst, src, size)	\
559048d156ff33 Kees Cook        2024-08-05   89  	sized_strscpy_pad(dst, src, size + __must_be_cstr(dst) + __must_be_cstr(src))
458a3bf82df4fe Tobin C. Harding 2019-04-05   90  
e6584c3964f2ff Kees Cook        2023-09-20   91  /**
e6584c3964f2ff Kees Cook        2023-09-20   92   * strscpy - Copy a C-string into a sized buffer
e6584c3964f2ff Kees Cook        2023-09-20   93   * @dst: Where to copy the string to
e6584c3964f2ff Kees Cook        2023-09-20   94   * @src: Where to copy the string from
e6584c3964f2ff Kees Cook        2023-09-20   95   * @...: Size of destination buffer (optional)
e6584c3964f2ff Kees Cook        2023-09-20   96   *
e6584c3964f2ff Kees Cook        2023-09-20   97   * Copy the source string @src, or as much of it as fits, into the
e6584c3964f2ff Kees Cook        2023-09-20   98   * destination @dst buffer. The behavior is undefined if the string
e6584c3964f2ff Kees Cook        2023-09-20   99   * buffers overlap. The destination @dst buffer is always NUL terminated,
e6584c3964f2ff Kees Cook        2023-09-20  100   * unless it's zero-sized.
e6584c3964f2ff Kees Cook        2023-09-20  101   *
e6584c3964f2ff Kees Cook        2023-09-20  102   * The size argument @... is only required when @dst is not an array, or
e6584c3964f2ff Kees Cook        2023-09-20  103   * when the copy needs to be smaller than sizeof(@dst).
e6584c3964f2ff Kees Cook        2023-09-20  104   *
e6584c3964f2ff Kees Cook        2023-09-20  105   * Preferred to strncpy() since it always returns a valid string, and
e6584c3964f2ff Kees Cook        2023-09-20  106   * doesn't unnecessarily force the tail of the destination buffer to be
e6584c3964f2ff Kees Cook        2023-09-20  107   * zero padded. If padding is desired please use strscpy_pad().
e6584c3964f2ff Kees Cook        2023-09-20  108   *
e6584c3964f2ff Kees Cook        2023-09-20  109   * Returns the number of characters copied in @dst (not including the
e6584c3964f2ff Kees Cook        2023-09-20  110   * trailing %NUL) or -E2BIG if @size is 0 or the copy from @src was
e6584c3964f2ff Kees Cook        2023-09-20  111   * truncated.
e6584c3964f2ff Kees Cook        2023-09-20  112   */
e6584c3964f2ff Kees Cook        2023-09-20  113  #define strscpy(dst, src, ...)	\
e6584c3964f2ff Kees Cook        2023-09-20  114  	CONCATENATE(__strscpy, COUNT_ARGS(__VA_ARGS__))(dst, src, __VA_ARGS__)
458a3bf82df4fe Tobin C. Harding 2019-04-05  115  
8366d124ec937c Kees Cook        2024-02-02 @116  #define sized_strscpy_pad(dest, src, count)	({			\
8366d124ec937c Kees Cook        2024-02-02  117  	char *__dst = (dest);						\
8366d124ec937c Kees Cook        2024-02-02  118  	const char *__src = (src);					\
8366d124ec937c Kees Cook        2024-02-02  119  	const size_t __count = (count);					\
8366d124ec937c Kees Cook        2024-02-02  120  	ssize_t __wrote;						\
8366d124ec937c Kees Cook        2024-02-02  121  									\
8366d124ec937c Kees Cook        2024-02-02  122  	__wrote = sized_strscpy(__dst, __src, __count);			\
8366d124ec937c Kees Cook        2024-02-02  123  	if (__wrote >= 0 && __wrote < __count)				\
8366d124ec937c Kees Cook        2024-02-02  124  		memset(__dst + __wrote + 1, 0, __count - __wrote - 1);	\
8366d124ec937c Kees Cook        2024-02-02  125  	__wrote;							\
8366d124ec937c Kees Cook        2024-02-02  126  })
8366d124ec937c Kees Cook        2024-02-02  127  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

