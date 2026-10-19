Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79BB0606A322
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 19:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ZwcHYIiP
Received: by kanga.kvack.org (Postfix)
	id E1FEE6B0357; Mon, 19 Oct 2026 15:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1D46B0358; Mon, 19 Oct 2026 15:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBFFE6B0359; Mon, 19 Oct 2026 15:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9048F6B0357
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3D62120816
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:50:54 +0000 (UTC)
X-FDA: 85340418828.04.56AB90D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf18.hostedemail.com (Postfix) with ESMTP id EB2121C0012
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:50:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZwcHYIiP;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792439452;
	b=cDnC97EkaBJVMXPJDg0f/hhYTcp3VcetsLCp12DGaaEPaMKCACZ67KQbxagY/j7yrGwCeH
	Dzb51y91DNMitbZxc7FTdBaFeZ0xtthT4njWsgQ1oH6Qc8tfCCbk9leuQ6AvAW5DhFx6XW
	YN9yCNtBh/55FahNwVpisAUYWD4eIz4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZwcHYIiP;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792439452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQIL6cRyZtwVIh/NjWyixGeu8fpj0ROdrbRqFiXL/B8=;
	b=JKW9iHe4iumAE9VsGGRwAqAZfsKo5VzjKLdVX1AH3njj3wvQ2vMYWeU5auWEdDhM4mV1mZ
	ZWWHcaSOjhRkwmUpFXeZoXttCQ9abrJL1D3+bczfMXJO5y3Y2kcmOdtQT022ReddDPE1Qk
	m9AXdJ5sj6d0psshxyULClrtjZUQ71s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792439452; x=1823975452;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DENo3LTyk9RmB9EFH3XG6IgFZAo7Ve/NCjoyjKnjphI=;
  b=ZwcHYIiPf0OFZ/rVP6kxKVvr4uhhjmEdLlz542N9DZN7M0FNeM0UVlqB
   YMQNa+22GquErkM9yjnZxuTWvLPNHk/msiDPVPNx6N4tG84W29n/lWwy8
   gE47JpDJlcVEmrOpgkPDZKi+qCGnT3y+iEZbA+GXU9yxmsSOLUWcCSXZO
   jVc8fUi+HtLUNfCBjjL0aLP8WMwgMXdMYwm+Q4/wh5QmN9xkSDhC5pdu5
   2W3dFSw9drfEpASZypyIkOESMBq3A08rL4PnH/CQH48fHNGmjubdPOfbK
   TSp14r8tNB8zswrRHDBLN5mPvYgddd6CvYY9zIdx8LDQVM6Txk2v/zCDl
   g==;
X-CSE-ConnectionGUID: Ub6Zxhs7STicIUlSG6sRdQ==
X-CSE-MsgGUID: +m7wks9PTEC6vW5v7O4svw==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1234501"
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="1234501"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 12:50:50 -0700
X-CSE-ConnectionGUID: 81WQDgsmQzmzWnzIVBPqJQ==
X-CSE-MsgGUID: bLLG/m5ATGO0TVoWyQJysw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,167,1787036400"; 
   d="scan'208";a="2620934"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 19 Oct 2026 12:50:47 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xItNc-00000000MJ8-1uPF;
	Mon, 19 Oct 2026 19:50:44 +0000
Date: Tue, 20 Oct 2026 03:50:35 +0800
From: kernel test robot <lkp@intel.com>
To: David Laight <david.laight.linux@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Petr Mladek <pmladek@suse.com>, Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
	bpf@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 14/15] kallsyms: scripts/kallsyms: Reduce the output file
 size
Message-ID: <202610200336.6v4SE96n-lkp@intel.com>
References: <20261018155206.132411-15-david.laight.linux@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261018155206.132411-15-david.laight.linux@gmail.com>
X-Stat-Signature: ntwsb1fznogfomyj4eq93phai3gbdap6
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EB2121C0012
X-Rspam-User: 
X-HE-Tag: 1792439451-240720
X-HE-Meta: U2FsdGVkX1+SqmwGrJmTRTatgANL52sH10kMrV1JHbtG1j62uBGUcBnY2yjSpTpj25p8aTMjD0j+rULmdq7DL0FPuN9nwuod81xkB1W6ltNVAPhyNvordZ/w8trUFdWz7zFJ7vgX6YoWzjZAOAalkDB5sIDWgw2XITv0lMEaZDpYcL3RdrSh/u83OkEDGhQhp3pbA9zhhjxG2Bex16thUMsZcNUB2qn88uBBksmFnUfFEWMuW56ho+hAnN90Q5832JKIzSvfQUeF0Vz8O7jT9B3p1Sw/8pIL7ObbXQ3x2gHZtnTOJrBDCtO3IsDulG9J9cgw1BtP0CtgMyLc9PtP/2NmGbY7NBW/mMLidAbK4F1h8fEaVDXUHR7r3ZrdWY6vPrfB03IYXPb99Yi7o1ycP2Hd10RPXkQTblsGhnRmN+2nbr//tMR/mrw15rH/Ql+9NfieuNJMwyzthZR4J+4HW/unZK+c1uK02dmWTKVnhCYolqt6G456npnrUma1mSIzft3L3Q5FOz50V2WhSetwqAK/2VmskMbgvWt8ThfByGsEAkDsGa2LIGEjh19Nkg17HZC1RSwhQOCQo4wqB50cxz4ubeieZ7GB0ET/LvyN/T0f11IjK8Gmzr9skDWXPzjykrn2GjdIoWpFVXgj1+dqE8NsXkQZhnvw5L6q9h+5yXJybKE6YrLT7ev4Ta8DEtck1fWtDBlXKJ55fPhiSFoauCNm53wu1IZVpVAUUZvDX6a7plw2yppfIV4ZwoGodF1jrUT8OgGJJR8nT9KFNPvsbyVzTVFC1P00pD5Lo++KK8CgZGra5BocCkI1Z4F2L+jpELjwItxyvM9C6QuMNDHuGIJv/BSnJsuYxSNM48vVeev5by17vCEFyfxN6YacpTdl5+P44JTe5BiehwI6CuFE8GrFjXovRsb1lUDJ0AUhFpM0DZr9sMED2fW3AYagShG9Km2tTq002Oj2ho2Rc8k
 NYaQM5aK
 PuZamrmcsPZzHBXoKScyjxdhTBd0LsS1mZCWKyG9QUu4BVQspCFZG2S8e9wFoPGOrP4hgLFRzRi1xoYQfY5KxPFn9ti1uJ6yUsh36wQoLRATRWPuil7XI2lT33DX0/R4c09OYxL2QAdXeTfLTc4KDU1BkpHKsLftxniv+W38oaAMRVFo3ffAWLZXxY6gDwfXs2NMtgpCxekO+LNUqLvwZXB8+tY/tjVB3gGu8LjUvWzJr5+rc2pR5A1m7csyGQaV5LzTPRAw92YPFFvHTTLgA8A1Gh0wy+LWLV8gdYcwQoJfV2YGs2C6vorwY9IA7GV7CWQHERPH9Erhd9WgHWK5RNjkx5PTf2SffEOpux5mEFeE9UuM2pNOM6A7OCxb8djRJ8vqo+CnygbCzK/jNY8d41moLW2AtLN2UzPKbJO/qouihQHr30GwKsN7naXUew64j1C+kcCW4+tW2vag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v7.3]
[cannot apply to next-20261016 next-20261016]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Laight/kallsyms-scripts-kallsyms-c-Avoid-overrunning-on-stack-buffer/20261018-165152
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20261018155206.132411-15-david.laight.linux%40gmail.com
patch subject: [PATCH 14/15] kallsyms: scripts/kallsyms: Reduce the output file size
config: um-allmodconfig (https://download.01.org/0day-ci/archive/20261020/202610200336.6v4SE96n-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
rustc: rustc 1.96.0 (ac68faa20 2026-05-25)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261020/202610200336.6v4SE96n-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610200336.6v4SE96n-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> scripts/kallsyms.c:371:26: warning: adding 'int' to a string does not append to the string [-Wstring-plus-int]
     371 |                         printf("\n\t.short\t" + !i);
         |                                ~~~~~~~~~~~~~~~^~~~
   scripts/kallsyms.c:371:26: note: use array indexing to silence this warning
     371 |                         printf("\n\t.short\t" + !i);
         |                                               ^   
         |                                &              [   ]
>> scripts/kallsyms.c:371:11: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
     371 |                         printf("\n\t.short\t" + !i);
         |                                ^~~~~~~~~~~~~~~~~~~
   scripts/kallsyms.c:371:11: note: treat the string as an argument to avoid this
     371 |                         printf("\n\t.short\t" + !i);
         |                                ^
         |                                "%s", 
   scripts/kallsyms.c:428:25: warning: adding 'int' to a string does not append to the string [-Wstring-plus-int]
     428 |                         printf("\n\t.long\t" + !k);
         |                                ~~~~~~~~~~~~~~^~~~
   scripts/kallsyms.c:428:25: note: use array indexing to silence this warning
     428 |                         printf("\n\t.long\t" + !k);
         |                                              ^   
         |                                &             [   ]
   scripts/kallsyms.c:428:11: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
     428 |                         printf("\n\t.long\t" + !k);
         |                                ^~~~~~~~~~~~~~~~~~
   scripts/kallsyms.c:428:11: note: treat the string as an argument to avoid this
     428 |                         printf("\n\t.long\t" + !k);
         |                                ^
         |                                "%s", 
   4 warnings generated.
--
>> scripts/kallsyms.c:371:26: warning: adding 'int' to a string does not append to the string [-Wstring-plus-int]
     371 |                         printf("\n\t.short\t" + !i);
         |                                ~~~~~~~~~~~~~~~^~~~
   scripts/kallsyms.c:371:26: note: use array indexing to silence this warning
     371 |                         printf("\n\t.short\t" + !i);
         |                                               ^   
         |                                &              [   ]
>> scripts/kallsyms.c:371:11: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
     371 |                         printf("\n\t.short\t" + !i);
         |                                ^~~~~~~~~~~~~~~~~~~
   scripts/kallsyms.c:371:11: note: treat the string as an argument to avoid this
     371 |                         printf("\n\t.short\t" + !i);
         |                                ^
         |                                "%s", 
   scripts/kallsyms.c:428:25: warning: adding 'int' to a string does not append to the string [-Wstring-plus-int]
     428 |                         printf("\n\t.long\t" + !k);
         |                                ~~~~~~~~~~~~~~^~~~
   scripts/kallsyms.c:428:25: note: use array indexing to silence this warning
     428 |                         printf("\n\t.long\t" + !k);
         |                                              ^   
         |                                &             [   ]
   scripts/kallsyms.c:428:11: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
     428 |                         printf("\n\t.long\t" + !k);
         |                                ^~~~~~~~~~~~~~~~~~
   scripts/kallsyms.c:428:11: note: treat the string as an argument to avoid this
     428 |                         printf("\n\t.long\t" + !k);
         |                                ^
         |                                "%s", 
   4 warnings generated.
   In file included from kernel/sched/rq-offsets.c:5:
   In file included from kernel/sched/sched.h:28:
   In file included from include/linux/cgroup_api.h:1:
   In file included from include/linux/cgroup.h:27:
   In file included from include/linux/kernel_stat.h:8:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:24:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:1209:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
    1209 |         return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
         |                                                   ~~~~~~~~~~ ^
   1 warning generated.
   In file included from rust/helpers/helpers.c:48:
   In file included from rust/helpers/blk.c:3:
   In file included from include/linux/blk-mq.h:5:
   In file included from include/linux/blkdev.h:9:
   In file included from include/linux/blk_types.h:10:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:24:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:1209:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
    1209 |         return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
         |                                                   ~~~~~~~~~~ ^
   clang diag: include/asm-generic/io.h:1209:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
   clang diag: include/asm-generic/io.h:1209:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
   clang diag: include/asm-generic/io.h:1209:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
   1 warning generated.


vim +/int +371 scripts/kallsyms.c

   344	
   345	static void write_src(void)
   346	{
   347		unsigned int i, k, off, off_size, table_size;
   348		unsigned int best_idx[256];
   349		char buf[1 + KSYM_NAME_LEN];
   350		struct sym_entry *se;
   351	
   352		printf("\t.section .rodata, \"a\"\n");
   353		printf("\n");
   354	
   355		output_label("kallsyms_token_table");
   356		off = 0;
   357		for (i = 0; i < 256; i++) {
   358			best_idx[i] = off;
   359			off += token_table[i].len + 1;
   360			printf("\t.asciz\t\"%s\"\t/* %u: %u */\n",
   361			       token_table[i].str, i, token_table[i].refs);
   362		}
   363		printf(".size kallsyms_token_table, . - kallsyms_token_table\n");
   364		printf("\n");
   365	
   366		output_label("kallsyms_token_index");
   367		for (i = 0; i < 256; i++) {
   368			if (i & 15)
   369				printf(",");
   370			else
 > 371				printf("\n\t.short\t" + !i);
   372			printf("%u", best_idx[i]);
   373		}
   374		printf("\n");
   375		printf(".size kallsyms_token_index, . - kallsyms_token_index\n");
   376		printf("\n");
   377	
   378		output_value("kallsyms_num_syms", symbol_cnt);
   379	
   380		output_label("kallsyms_names");
   381		off = 0;
   382		for (i = 0; i < symbol_cnt; i++) {
   383			se = symbol[i];
   384			se->seq = off;
   385	
   386			/* The length must be less than that of the original symbol. */
   387			if (!se->len || se->len > KSYM_NAME_LEN)
   388				errx(1, "symbol %d has corrupt compressed length %d\n",
   389				     i, se->len);
   390	
   391			/*
   392			 * Output the number that identifies the symbol at the start
   393			 * of the line so that they line up nicely.
   394			 */
   395			printf("\t/* n:%u */\t.byte\t", off);
   396	
   397			/* Encode length with ULEB128. */
   398			if (se->len <= 0x7F) {
   399				/* Most symbols use a single byte for the length. */
   400				printf("%u", se->len);
   401				off += se->len + 1;
   402			} else {
   403				/* "Big" symbols use two bytes. */
   404				printf("%u,%u", (se->len & 0x7F) | 0x80, (se->len >> 7) & 0x7F);
   405				off += se->len + 2;
   406			}
   407			for (k = 0; k < se->len; k++)
   408				printf(",%u", se->sym[k]);
   409			printf("\n");
   410	
   411			/*
   412			 * Now that we wrote out the compressed symbol name, restore the
   413			 * original name.
   414			 */
   415			se->len = expand_symbol(se->sym, se->len, buf);
   416			memcpy(se->sym, buf, se->len + 1);
   417		}
   418		table_size = off;
   419		printf(".size kallsyms_names, . - kallsyms_names\n");
   420		printf("\n");
   421	
   422		output_value("kallsyms_marker_shift", marker_shift);
   423		output_label("kallsyms_markers");
   424		for (i = 0, k = 0; i < symbol_cnt; i += 1u << marker_shift, k++) {
   425			if (k & 7)
   426				printf(",");
   427			else
   428				printf("\n\t.long\t" + !k);
   429			printf("%u", symbol[i]->seq);
   430		}
   431		printf("\n");
   432		printf(".size kallsyms_markers, . - kallsyms_markers\n");
   433		printf("\n");
   434	
   435		output_label("kallsyms_offsets");
   436	
   437		for (i = 0; i < symbol_cnt; i++) {
   438			se = symbol[i];
   439			if (pc_relative) {
   440				long long offset = se->addr - _text;
   441	
   442				if (offset < INT_MIN || offset > INT_MAX)
   443					errx(1, "relative symbol %s value %#llx out of range\n",
   444						se->sym + 1, se->addr);
   445				printf("\t.long\t_text-.+%d\t/* n:%u %c %s */\n",
   446				       (int)offset, se->seq, se->sym[0], se->sym + 1);
   447			} else {
   448				printf("\t.long\t%#x\t/* n:%u %c %s */\n",
   449				       (unsigned int)se->addr, se->seq, se->sym[0], se->sym + 1);
   450			}
   451		}
   452		printf(".size kallsyms_offsets, . - kallsyms_offsets\n");
   453		printf("\n");
   454	
   455		sort_symbols_by_name();
   456		off_size = table_size < (1u << 23) ? 24 : 32;
   457		output_value("kallsyms_off_size", off_size);
   458		output_label(off_size == 24 ? "kallsyms_off_24_of_names" : "kallsyms_off_32_of_names");
   459		for (i = 0; i < symbol_cnt; i++) {
   460			se = symbol[i];
   461			off = se->seq << 1;
   462			if (i && symbol[i - 1]->len == se->len &&
   463			    !memcmp(symbol[i - 1]->sym + 1, se->sym + 1, se->len - 1))
   464				/* Mark that this is a duplicate of the previous symbol */
   465				off |= 1;
   466			if (off_size == 24) {
   467	#ifdef CONFIG_CPU_BIG_ENDIAN
   468				off = __builtin_bswap32(off) >> 8;
   469	#endif
   470				/* The three spaces before the tab line up the comments */
   471				printf("\t.byte\t%u,%u,%u   \t/* n:%u */\n",
   472					off & 0xff, (off >> 8) & 0xff, off >> 16, se->seq);
   473			} else {
   474				printf("\t.long\t%#04x\t/* n:%u */\n", off, se->seq);
   475			}
   476		}
   477		/* Terminator without the 'duplicate' flag. */
   478		if (off_size == 24)
   479			printf("\t.byte\t0,0,0\n");
   480		else
   481			printf("\t.long\t0\n");
   482		printf(".size kallsyms_off_%d_of_names, . - kallsyms_off_%d_of_names\n", off_size, off_size);
   483	
   484		fflush(stdout);
   485		if (ferror(stdout))
   486			errx(1, "error writing to output file");
   487	}
   488	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

