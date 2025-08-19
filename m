Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13379CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 18:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC4C38E005A; Tue, 19 Aug 2025 14:23:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75538E0003; Tue, 19 Aug 2025 14:23:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2C38E005A; Tue, 19 Aug 2025 14:23:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5F48E0003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:23:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3615A1DA7C6
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:23:32 +0000 (UTC)
X-FDA: 83794329864.28.6E62A85
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf16.hostedemail.com (Postfix) with ESMTP id 68AB318000B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:23:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JtmA0KCH;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755627810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzUmwEYUX2Otvu38EhlbxtKO/chP2XGZHBpqa0NPilk=;
	b=rQ1QzYy8JYDI2FT3dnszTSYHxcfBHY9fvNgKIFFv6ILymy9GLI0yZcb0vVl2ffRgypwZV1
	Mf4mQwspJ8GPHY6c7v6keOQaM6ySCRJcEnyal6iu/Y/yMkyoRc7mU4rj3MTUcBQwMcesoe
	S6o30Fvr+OFFmApu988O6W1mWcEO5R0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JtmA0KCH;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755627810; a=rsa-sha256;
	cv=none;
	b=UC84yDucW/kx+OaY3/7omNo9OgCLq9aVb1yHuEQGTORGOyp+qXqahoqzAO1XcLLuJ9UCng
	Ml3gNSmXroQ9YCSTslJRP/dXILriPaiUsaON5gzg9d3ZpdULU53yGypRZ3RymlULFYoZVf
	fMEnVZWm/+08Cfpy5m5zLrWMsglCGss=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755627809; x=1787163809;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X6TNDKntPbZtJQzM/AErcLByk3qrqJsaEa3eWLo9xcY=;
  b=JtmA0KCHloYIzt8cspH6N8V68MJNmeM54QqX2Ln9VhDph2QQGpXOpTxG
   y951IWFn2Xyt+0FK0Otq41PCy2ew7EhRUMg83FjP1/wso9KYqxm2Sahce
   ndCkuEdWe+6vgDH4HGkMF9b43C3GiFY7JV0z9r4fwaYNfLfl9XXashNMY
   Y2XSbwlNf0bFeAKfUaTkbMYRu80nyRTjL8+HNVuFpdEOMNNeLn6kLh0Zh
   TisjYlpJQg9jGS3cHFV3LwK1zE7kZpmCIsdivDEuq+YVhMCLkND5QF8uF
   9A75rrEig2gMNP9OtAn8rxOa7b0juk6J5W1N82pxVJmz7bbp5CR8dQQiz
   Q==;
X-CSE-ConnectionGUID: 47LX34G0SluSSBadcT0tXA==
X-CSE-MsgGUID: sZcsRzt2Sd2c6vxhUxeTOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57810833"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="57810833"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 11:23:28 -0700
X-CSE-ConnectionGUID: JDvgk7qFQq2x4WO42Pd+VA==
X-CSE-MsgGUID: uvCyzmnMS4WkH1iDNjxp4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="167874532"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 19 Aug 2025 11:23:22 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uoQzP-000HG3-1M;
	Tue, 19 Aug 2025 18:23:19 +0000
Date: Wed, 20 Aug 2025 02:23:12 +0800
From: kernel test robot <lkp@intel.com>
To: Pingfan Liu <piliu@redhat.com>, linux-arm-kernel@lists.infradead.org
Cc: oe-kbuild-all@lists.linux.dev, Pingfan Liu <piliu@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jeremy Linton <jeremy.linton@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Simon Horman <horms@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Philipp Rudo <prudo@redhat.com>, Viktor Malik <vmalik@redhat.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>, Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	kexec@lists.infradead.org, bpf@vger.kernel.org,
	systemd-devel@lists.freedesktop.org
Subject: Re: [PATCHv5 10/12] arm64/kexec: Add PE image format support
Message-ID: <202508200205.qEn1adEu-lkp@intel.com>
References: <20250819012428.6217-11-piliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819012428.6217-11-piliu@redhat.com>
X-Rspamd-Queue-Id: 68AB318000B
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1ynbcroxo5n7yy8wo89fwti87zbicr64
X-HE-Tag: 1755627809-352281
X-HE-Meta: U2FsdGVkX18zIfWpUOKli91pjqW0B3RtVuraPy9d5gOyZ28n/KMV4rMqobD6TWAkTbTgPhCjwgDtcP0jM45g748VcC7IfsBHA/eyP3Bn9vMe5PGRPAwc/fscxokWrznQD5A6dfirOGgxK3ZF7BDRwDw0cS6fc4Xwvih73kmvoLK7umE/kd5CEvaFpV/9GowfvGJKD0XlNpuB5DeYvv8J/cYPuXctujxq6JlZn3lJRyWLlE2seUe8yGo82/0UmrS0X282tmcJFAxkhv/4HoLxAjE7lrklgVBJ12kIRt5Kf8wa2xbLmztCtXsQmj7FOOhU39OlZ56UmLRgwKE8tUidL+/MJAdVL5ljXNdyzrU9CfayQ9OAU0LBZYe2E2w1YAz45At+ue0fnVIGcz4cEJeGXjOONuDu6qBkV3GcuvIKzdbMcoqQBv2ZAOeTmz9gmvsHZl4LmM9xhnq+DadBiPzDbwF3dS54Wyq8CnNMwhmJpqs4nBZxuUyMhO+L0QMoAP+Hy5j/Sk/v+X1LYB5PicyyoNVoXm6gtvi+LEl3z/yBbs9SC7XRkO1nJJ8VgbWbXdoQtWlx/keq3/+jLJAXvmxRlFmNS7w7zphzMu2x3DgFutx6BWZ/Mr+ra4QZuenVsk6637ruZXazl9zz67BeBXDtbe00k7lHncjCb/82Jf6CI2Igj5KOh69ZZa0HuVoo1CezoDZMad7LJzNtmS0dT9MaIi//GRimMC8uDZ52f6iAXXtvu2zOGOhJAtO69Es+3GSIRe8sp2sIs5FRUOsYZAneRdA/ZlYIuBW2C/GW9p/cVWGPvhPuTHve06PxHGnS7day3uWu+lXDOGqHgShXlXc8veiyXcwNZxDEvVW8PS6lmJZgHh4vik+sIrPx92zzRMbJRy5J0XWkBFQ9F1Sn4qUlbsIDMYl3+6z8vX3MeAMnnTz7sLgsoKhzOaetTrRBKY+WetG/iOu2JtGbfaP35N+
 Xu9IiJuY
 Tb23oFdN/M7Zb+SR1nSOP/LSaeD81031p7iD9+IbTHm3ChaQ1zSPAE+LEjBXildZtqMz/jkJqnpTR5D+6irhGSsEcIOH7l+Z7Hzl/tXNqB/u3BBEKtY9t0uE/JaE5wCmm5WVmsKpthwNRYBkBRmKPKHCPPiC4YYEtacxGvbW8zr3EALlFaVbRd3+6ov3U56t083nmIuR1+ZWT1VwN26tXMy2cdo7E1At2mfcVqU3YzDp9oEN2pDfLEMhU/I79SvvIZWgmS8/k2zUjPrdIF1+Ntj9rz4rnvagByEFSR32X6Hz/+Pkb8X4gxcRsgCYz7zUjTSLaB7PxHLz4O0Gu0T9sMLublI3H2tmpd+YC8DgliDumbao1NteMFM2U6mKYkfrZcmyv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pingfan,

kernel test robot noticed the following build errors:

[auto build test ERROR on c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9]

url:    https://github.com/intel-lab-lkp/linux/commits/Pingfan-Liu/kexec_file-Make-kexec_image_load_default-global-visible/20250819-093420
base:   c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9
patch link:    https://lore.kernel.org/r/20250819012428.6217-11-piliu%40redhat.com
patch subject: [PATCHv5 10/12] arm64/kexec: Add PE image format support
config: arm64-randconfig-001-20250819 (https://download.01.org/0day-ci/archive/20250820/202508200205.qEn1adEu-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 14.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250820/202508200205.qEn1adEu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508200205.qEn1adEu-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from kernel/kexec_bpf/kexec_pe_parser_bpf.lskel.h:6,
                    from kernel/kexec_pe_image.c:25:
   tools/lib/bpf/skel_internal.h: In function 'skel_finalize_map_data':
   tools/lib/bpf/skel_internal.h:155:15: error: implicit declaration of function 'bpf_map_get'; did you mean 'bpf_map_put'? [-Wimplicit-function-declaration]
     155 |         map = bpf_map_get(fd);
         |               ^~~~~~~~~~~
         |               bpf_map_put
>> tools/lib/bpf/skel_internal.h:155:13: error: assignment to 'struct bpf_map *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     155 |         map = bpf_map_get(fd);
         |             ^
   kernel/kexec_pe_image.c: In function 'kexec_bpf_prog_run_init':
   kernel/kexec_pe_image.c:267:16: error: implicit declaration of function 'register_btf_fmodret_id_set'; did you mean 'register_btf_kfunc_id_set'? [-Wimplicit-function-declaration]
     267 |         return register_btf_fmodret_id_set(&kexec_modify_return_set);
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                register_btf_kfunc_id_set
   kernel/kexec_pe_image.c: In function 'pe_image_load':
   kernel/kexec_pe_image.c:312:44: warning: variable 'cmdline_sz' set but not used [-Wunused-but-set-variable]
     312 |         unsigned long linux_sz, initrd_sz, cmdline_sz, bpf_sz;
         |                                            ^~~~~~~~~~

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for KEXEC_PE_IMAGE
   Depends on [n]: KEXEC_FILE [=y] && DEBUG_INFO_BTF [=n] && BPF_SYSCALL [=n]
   Selected by [y]:
   - ARCH_SELECTS_KEXEC_FILE [=y] && KEXEC_FILE [=y]


vim +155 tools/lib/bpf/skel_internal.h

67234743736a6a Alexei Starovoitov 2021-05-13  143  
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  144  static inline void *skel_finalize_map_data(__u64 *init_val, size_t mmap_sz, int flags, int fd)
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  145  {
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  146  	struct bpf_map *map;
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  147  	void *addr = NULL;
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  148  
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  149  	kvfree((void *) (long) *init_val);
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  150  	*init_val = ~0ULL;
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  151  
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  152  	/* At this point bpf_load_and_run() finished without error and
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  153  	 * 'fd' is a valid bpf map FD. All sanity checks below should succeed.
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  154  	 */
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09 @155  	map = bpf_map_get(fd);
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  156  	if (IS_ERR(map))
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  157  		return NULL;
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  158  	if (map->map_type != BPF_MAP_TYPE_ARRAY)
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  159  		goto out;
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  160  	addr = ((struct bpf_array *)map)->value;
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  161  	/* the addr stays valid, since FD is not closed */
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  162  out:
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  163  	bpf_map_put(map);
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  164  	return addr;
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  165  }
6fe65f1b4db3ff Alexei Starovoitov 2022-02-09  166  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

