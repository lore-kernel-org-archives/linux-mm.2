Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C2B9CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 22:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DC256B0005; Tue, 19 May 2026 18:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4D36B0088; Tue, 19 May 2026 18:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9FD6B008A; Tue, 19 May 2026 18:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1B76B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:04:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2332140BC7
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:04:48 +0000 (UTC)
X-FDA: 84785549856.27.7E08CE7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf28.hostedemail.com (Postfix) with ESMTP id 11608C0007
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:04:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bgsr2qVZ;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779228287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5nwJPoCvwoW3NeN1edUCtwGoX7ZTpq/+IcjVb51c9bs=;
	b=JKpQ6Xfj2etIhRvkjUI5QQ3nj0cqhVjsHIzbrUVsIwE0GFK8RG4BmGlxtZ9Rqs8KyCb37S
	JPYoNRVPl7ZVEW9TfeDFbBQsIT06BGoZYSx183KzrQGMA7IF1pM+VBK8tkPxYtCCkrjWCM
	qoN0CAaW8BHxYsbvexhVKNTGreAijGc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bgsr2qVZ;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779228287; a=rsa-sha256;
	cv=none;
	b=kG9nJXDht5+GNkrYMKN/xTYfymN8JnoTqFkrd1C77dgeJbWYbeyFFCsoz9SaO+EA3cCMh0
	Dm4+vFpiYbzwNIUg8OyZn4th1SkLkWOBmgQFyMTDR2a0OYuf3oI4SARh9sEfr7gDGRFMaO
	lmUz/RAYeRh9v14HVNYic13H63/XXDk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779228287; x=1810764287;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=g1vLSl5trggIm1zXbVe+RM8Rm+X/YE9INdqu72haORU=;
  b=bgsr2qVZxinXkqkoKw6LjDsd1GtDE/5u3JWg95CSXeBY8aQXoaH7+Vpf
   O46IQeUx+bzewk7gSPSBjdcVivl7S4k144jA04evStRw1BQo0TTqNxXNO
   UFFBCygRoq0qWiUIbFAvhtTij0Lf79jDsarMQPAFhEmxtvPgKnXq0l3lR
   7klitKJ+u5TeCbmAb/F7pEN4F72oUSicd/9r48EYHVG2rX8J97Bn7DznX
   UH19SdRHzDd3rYpD93r7d71ICyHPjCpu3y7XQ0G/TWCG83vDx86qo/n9d
   EMa+AIMqFYb0w1A6wZ+n8qpw/6rXC3U0CkgUA9Y/lS1gUHmENYDj09s2i
   A==;
X-CSE-ConnectionGUID: cYFtDr+NRISBunomUCXZAg==
X-CSE-MsgGUID: TVJg4BZEQiS1nX6kqUz+hQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="91225990"
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="91225990"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 15:04:45 -0700
X-CSE-ConnectionGUID: +qqDDFa0SEOi/J7/yRTUUA==
X-CSE-MsgGUID: xqAAC6yDTN+5o9hFml3plQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="237298787"
Received: from lkp-server02.sh.intel.com (HELO 30e86e9c1927) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 19 May 2026 15:04:40 -0700
Received: from kbuild by 30e86e9c1927 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wPSXz-0000000020H-2LDo;
	Tue, 19 May 2026 22:04:23 +0000
Date: Wed, 20 May 2026 06:03:38 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux trace kernel <linux-trace-kernel@vger.kernel.org>,
	bpf@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Douglas Raillard <douglas.raillard@arm.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ian Rogers <irogers@google.com>, Jiri Olsa <olsajiri@gmail.com>
Subject: Re: [PATCH v5] tracing/eprobes: Allow use of BTF names to
 dereference pointers
Message-ID: <202605200549.zZkT9xWc-lkp@intel.com>
References: <20260519130144.40e71a00@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519130144.40e71a00@fedora>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 11608C0007
X-Rspam-User: 
X-Stat-Signature: sq5pwhb7o8jaeyccyn4jfuy7311mzt5c
X-HE-Tag: 1779228285-590934
X-HE-Meta: U2FsdGVkX1/prcrsGQ8ugCCKiWQFBTTT86iRmYoAa/pxRDUsEbVzkXL/8es2gA9EoCBtniXxSnIJgiRY8Kqt9yMyv6jb01uZfj58TmlLo6aKfp7ha3yLxrPDKX/5G7tosjIipozxL/qJCnXXNv8KKrCAlNkh+eTrFpqH7nYBRaM/pdXqxaZKMXf8CcqmYuzOXP/3XIvaWOEcHzN3oFXTkNlPnCeLXkXWrjeUGvUjqHHOHPYx4FCb+e9V2eo6BoTSRQAB3CPF8/0Ekoq91SytwujBAlQRch4xSkawoPXagv5P+XIgTsM77bvXwtcwUQuTGrDI6Oa5dOYztAkXW5Qxe5EGMk41dNzkkkAVVSxbTmUhC57SvRHSuiJ5cmCApX9Fw8/pTjmp7SDHbBBJg/KxQT5VvalLKS8++pZ+WyaMueBEDt+XZily59xS0URPzCp79l661A/wcAYjpuQH1Q7PkGNZLuC9xClEKyClWymIVcNWj/4qHMaQdhmrUkE49ZY6WAnFMwXf8A6CHcqlccaq0Pz2TcFVC1hdZCsc4R7n2QTYF9Sdw3SzF+nKImJftouAcLQCrMbM6vfWITPmpI/0Jyk0g9LEpZuMuyeYZJxMv1QNOnRSgkIjZph8BcjuuMDtBseDDP38M4AxgWnN0S8iv9/icaqE/cGlqTnkEWvYPMcertkRZWRbW0T0maIQQt6Ub0XWjfBTYRPBYzUx4Nu+c2FyBdjy9pkjuHHW4n+v5mxeMQPGPd1kXCu4xqpdxLPof9ABwjqZ8pXHR5qB9MI/Wud0ctaZeTEotNnnqR3M6aw7dQU4X5+tDKguMdT2uLyoK/n6k8vYc6GlKgGNFvo7iRoc3iJgEbcFTEBh1kn2YI7sh2FH6uUH0xtmzq8aQQkLj7IYPAfQaiTfEHkJ0fnNGqbYzy+lTl87VeYBlRFvETV3pQU1Kz5dUfj3vNLl1WrlYZ6g+2CSNDzM/hlMUJY
 IzD6+nL6
 R+goXJjegCEcHGxLcII5rkA5XQYLkzc8cQUK5lYJWwvr7KiCLyhy/RsXyHGxOxlINEeXaw1R2DRerhmgg/5wVwXKCC5y3Hn29v1Vd0rfupHtoR/z6Ud6J8TmC4WpCOs1SbdnteQQeXIT88q8IibbGyYo2zEdybN+PR9m1CChZqvTSRz8J026P2FBCraUC8E917HPqXGyJzSm2K9JN7Waz2ZtAiRKqLkwR94zzJVSxy949Q2uOW4edLvsSiKHKeUrs4hMtExLV3PmzeIhE5ruycTDiOBQMBNDS66E8vIiOwaJSyeCn6PHaNKQUaha+1ecpQCFhK186m+H3fpK5MYXZzL+1WUiMzE53NRi4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steven,

kernel test robot noticed the following build errors:

[auto build test ERROR on trace/for-next]
[also build test ERROR on linus/master v7.1-rc4 next-20260519]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-eprobes-Allow-use-of-BTF-names-to-dereference-pointers/20260520-011353
base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
patch link:    https://lore.kernel.org/r/20260519130144.40e71a00%40fedora
patch subject: [PATCH v5] tracing/eprobes: Allow use of BTF names to dereference pointers
config: arc-defconfig (https://download.01.org/0day-ci/archive/20260520/202605200549.zZkT9xWc-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260520/202605200549.zZkT9xWc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605200549.zZkT9xWc-lkp@intel.com/

All errors (new ones prefixed by >>):

   kernel/trace/trace_probe.c: In function 'parse_probe_vars':
   kernel/trace/trace_probe.c:1035:21: error: implicit declaration of function 'parse_trace_event'; did you mean 'parse_trace_event_arg'? [-Wimplicit-function-declaration]
    1035 |                 if (parse_trace_event(arg, code, ctx) < 0)
         |                     ^~~~~~~~~~~~~~~~~
         |                     parse_trace_event_arg
   kernel/trace/trace_probe.c: In function 'sprint_nth_btf_arg':
   kernel/trace/trace_probe.c:1803:27: error: implicit declaration of function 'ctx_btf' [-Wimplicit-function-declaration]
    1803 |         struct btf *btf = ctx_btf(ctx);
         |                           ^~~~~~~
>> kernel/trace/trace_probe.c:1803:27: error: initialization of 'struct btf *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
   kernel/trace/trace_probe.c: At top level:
   kernel/trace/trace_probe.c:318:12: warning: 'parse_trace_event_arg' defined but not used [-Wunused-function]
     318 | static int parse_trace_event_arg(char *arg, struct fetch_insn *code,
         |            ^~~~~~~~~~~~~~~~~~~~~


vim +1803 kernel/trace/trace_probe.c

  1797	
  1798	static int sprint_nth_btf_arg(int idx, const char *type,
  1799				      char *buf, int bufsize,
  1800				      struct traceprobe_parse_context *ctx)
  1801	{
  1802		const char *name;
> 1803		struct btf *btf = ctx_btf(ctx);
  1804		int ret;
  1805	
  1806		if (idx >= ctx->nr_params) {
  1807			trace_probe_log_err(0, NO_BTFARG);
  1808			return -ENOENT;
  1809		}
  1810		name = btf_name_by_offset(btf, ctx->params[idx].name_off);
  1811		if (!name) {
  1812			trace_probe_log_err(0, NO_BTF_ENTRY);
  1813			return -ENOENT;
  1814		}
  1815		ret = snprintf(buf, bufsize, "%s%s", name, type);
  1816		if (ret >= bufsize) {
  1817			trace_probe_log_err(0, ARGS_2LONG);
  1818			return -E2BIG;
  1819		}
  1820		return ret;
  1821	}
  1822	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

