Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF9FC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 15:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D8118E0006; Wed,  6 Aug 2025 11:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 788B98E0003; Wed,  6 Aug 2025 11:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677688E0006; Wed,  6 Aug 2025 11:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54C038E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:12:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D1DE5140305
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:12:21 +0000 (UTC)
X-FDA: 83746673682.14.FE1D56B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf16.hostedemail.com (Postfix) with ESMTP id 14085180004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:12:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BnuY2MuY;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754493139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x4Pf4AavquJKc+JGHEHc79V4RatrEBLDzS47637f6Zo=;
	b=2UZP6ANC+wVErIlyDtgMKEgjaIbc4zBxhcSUWbOIGQye9sdc7ooxVbjAfHHt1my6TVs2Ik
	mB2ux2nhiCz/3UZYPRr206aClen/4K52Biukl0p1MG4nGdMt7FLz0IGvWUcq+212Q6KBi1
	nVS8fjgvyef+fgcCFB/6HyVm3k9cXx0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754493139; a=rsa-sha256;
	cv=none;
	b=Sr+JzKqrgKkJ0UUI0cfskq+FhXzaV1LTz69ItGkJZXG3v+1GSronVVHyJ0zJPUjKl8uN6S
	Zv94lSP/jKuisiwPvjGhEHYwhtJcNb6/0ddGYhHSO94ZTaGRc/dLsrhC1e/jLiWKhl4s51
	diT7BX44aPPjQe3osR/dEyZZmUORORg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BnuY2MuY;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754493139; x=1786029139;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=z0GZ2itZ2i6se6vN/uwlmzSn0GLQ1L0gKV7qLJ9Ot0A=;
  b=BnuY2MuY88bwr2i0UY+c5NsLQrskuA7ps1VggbcOEEgwPDR1Oo43y8zm
   ajI5q1QqN6uUeYbuJjfMrouONVMT7GCk1AmdRWI5EgiwEcqS1Uyz6DUUI
   CWCUP2AKGlm1dgiFahuxh1YahaUYVwtL+uWSl+yez4VcWq28BtGqQqJ3C
   bUK00myQhbwNrLmfx5okbyU8liNoRrRp2rd/iYTRMM+qamrAUDBFPbuoA
   VtZDBXgWp6n13wBfjmiFyL2QOZXXuQJVGELZCKMkNPPC5rjYN5q+ux4dT
   A4qArn6nWfubZKvn6amxsKb+mDroQZTSeJPXO5zX5aUWLPJy22JX23f2L
   Q==;
X-CSE-ConnectionGUID: F4MX3JqdR5KKbWXrG3V2bQ==
X-CSE-MsgGUID: nTO54TNKRCeun4G3yIugDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="67510063"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="67510063"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 08:12:17 -0700
X-CSE-ConnectionGUID: BAtTOpw7R7mkNp+FPRptAA==
X-CSE-MsgGUID: ZjHK3kmaSZej6Qvc1WOpVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="201964384"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 06 Aug 2025 08:12:13 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ujfoI-0001oO-2p;
	Wed, 06 Aug 2025 15:12:10 +0000
Date: Wed, 6 Aug 2025 23:12:02 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>, Tom Zanussi <zanussi@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ian Rogers <irogers@google.com>, aahringo@redhat.com,
	Douglas Raillard <douglas.raillard@arm.com>
Subject: Re: [PATCH 5/7] tracing: Display some syscall arrays as strings
Message-ID: <202508062215.aRvDXrBA-lkp@intel.com>
References: <20250805193235.416382557@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805193235.416382557@kernel.org>
X-Rspamd-Queue-Id: 14085180004
X-Stat-Signature: nkjh7mrbib4pkdsh5hx96y3m4znre33k
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754493138-19090
X-HE-Meta: U2FsdGVkX19Mtr5KJ9le9u1PDKDuNeFr4j9ZXWMjhrWOxwgQ2pc3o5jMigyN0XBwDBeLyCaZcGjwfQZMEgqfxmbraEmmN9VzmmQNPkq2mcDqZMzzIr4L+l4UZZes08cKTJF2aCgqDWxDmGT5JDh/bjC4eg44l8h8OxdAdEqq0it5+bK8j3BItm6y2ytWiWG3T0X2w8HoYjSrvtU09+eSErOOuvWlRfXtpX6LMe/SSLeqjrJDkvzymRvUZJNxuIcx5KkIMcU5y5TB5kWGH7HVWGP43SHqUzaFSi+EImLe5phO1Ez3cfRLN4Eg0J6SeGN4d1xUnq4keyBFqamL1the+LW3z/yIPM+17cu+n/0DFNSCpumltQHxCYFnpZF7+YI8Zcih3yF/tXf4jlXhgFut88IK5BERU99HnvrTxjlWiDtaWKrSJ8pmggxUhTj/0dMLzcC4gk8VHtwNbFFRYo7RzAeACnw2sUrC9hsdJVApYQwaoatl8vYWaZUwLwBpuMBnmio81PpXNoh7Sac3/aPr6Pl2T7p3Zsi0g9J1a1j6zFubJG/2Uzo9r04XYFxP7SGJkVKaGr+89FjtBK9HMObP2nKr95GfMhFpkk3M8Exv/YpklyJ0BLpudHmXrj6OPBYkLW2be2oK7LMCKM3rLOgNBIJOoKEzDxznC1TP81b4QRETEWDhg+HY3sEJ0ArmKafB9APe0H2Ux5rZ7czRAlEGQ+o5suyLdPq4k7SYjxN6Z7/MoHnFuyus79aqCPdAtczYCrSpCj+uRQHuxXP8T4FXfGRyLihfEMkcx3Itbof/V6eX8xdQ+Q0rWJvvw8KaLflM50jxcQKIRqIKQq0r3pYfKvh0uQlfw4sRmGSWNFwMWHWHI80/iHaY+AqFy7EF4zfQB5hJ656dPwDsecq0WuSZRy6G/R9jubpCaqE02ND6V2LL1hM+WCjx1sIYTq/6L7627sNEhDZ4DA9hX/QkKYq
 906V0QsD
 g8GqeY+/XAGyiEdzMShqm18CsZce5kT7Ij3hjUuSm+nntX9Z3vIjghXkKOoMlnYn7jlWtPk/+Su5qNYIIYNT3tlTOTUJZszJTesp5nfui3T2zy/Ac7CPdDKgYxIptQKVEDWRz27yEbKDf8ui0M/89VvWtYtzX3mDL5bzfh/Zhq6vakooyNRKaiEcTtatUoJaourMaEX0Jv4u3ksiW2v+s8q0fEXZgIK0t81ua8VHFsyfwXGISj4O2+rRfCu1kXE0Zpd6Mg4RksaG1CFgIzjZLZH9mBPXB1JRiSIqVqPAbE1/LVKWiIUKhkRMFW8TKNzY4GAwupKuDEG3Pw+R2AI6rKqtgRKR7ZhVejpxg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steven,

kernel test robot noticed the following build errors:

[auto build test ERROR on trace/for-next]
[also build test ERROR on linus/master v6.16 next-20250806]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-Replace-syscall-RCU-pointer-assignment-with-READ-WRITE_ONCE/20250806-122312
base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
patch link:    https://lore.kernel.org/r/20250805193235.416382557%40kernel.org
patch subject: [PATCH 5/7] tracing: Display some syscall arrays as strings
config: i386-randconfig-141-20250806 (https://download.01.org/0day-ci/archive/20250806/202508062215.aRvDXrBA-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250806/202508062215.aRvDXrBA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508062215.aRvDXrBA-lkp@intel.com/

All errors (new ones prefixed by >>):

   kernel/trace/trace_syscalls.c: In function 'check_faultable_syscall':
>> kernel/trace/trace_syscalls.c:883:14: error: '__NR_kexec_file_load' undeclared (first use in this function)
     883 |         case __NR_kexec_file_load:
         |              ^~~~~~~~~~~~~~~~~~~~
   kernel/trace/trace_syscalls.c:883:14: note: each undeclared identifier is reported only once for each function it appears in
   kernel/trace/trace_syscalls.c:957:14: error: '__NR_newfstatat' undeclared (first use in this function)
     957 |         case __NR_newfstatat:
         |              ^~~~~~~~~~~~~~~


vim +/__NR_kexec_file_load +883 kernel/trace/trace_syscalls.c

   851	
   852	/*
   853	 * For system calls that reference user space memory that can
   854	 * be recorded into the event, set the system call meta data's user_mask
   855	 * to the "args" index that points to the user space memory to retrieve.
   856	 */
   857	static void check_faultable_syscall(struct trace_event_call *call, int nr)
   858	{
   859		struct syscall_metadata *sys_data = call->data;
   860	
   861		/* Only work on entry */
   862		if (sys_data->enter_event != call)
   863			return;
   864	
   865		sys_data->user_arg_size = -1;
   866	
   867		switch (nr) {
   868		/* user arg 1 with size arg at 2 */
   869		case __NR_write:
   870		case __NR_mq_timedsend:
   871		case __NR_pwrite64:
   872			sys_data->user_mask = BIT(1);
   873			sys_data->user_arg_size = 2;
   874			break;
   875		/* user arg 0 with size arg at 1 as string */
   876		case __NR_setdomainname:
   877		case __NR_sethostname:
   878			sys_data->user_mask = BIT(0);
   879			sys_data->user_arg_size = 1;
   880			sys_data->user_arg_is_str = 1;
   881			break;
   882		/* user arg 4 with size arg at 3 as string */
 > 883		case __NR_kexec_file_load:
   884			sys_data->user_mask = BIT(4);
   885			sys_data->user_arg_size = 3;
   886			sys_data->user_arg_is_str = 1;
   887			break;
   888		/* user arg at position 0 */
   889		case __NR_access:
   890		case __NR_acct:
   891		case __NR_add_key: /* Just _type. TODO add _description */
   892		case __NR_chdir:
   893		case __NR_chown:
   894		case __NR_chmod:
   895		case __NR_chroot:
   896		case __NR_creat:
   897		case __NR_delete_module:
   898		case __NR_execve:
   899		case __NR_fsopen:
   900		case __NR_getxattr: /* Just pathname, TODO add name */
   901		case __NR_lchown:
   902		case __NR_lgetxattr: /* Just pathname, TODO add name */
   903		case __NR_lremovexattr: /* Just pathname, TODO add name */
   904		case __NR_link: /* Just oldname. TODO add newname */
   905		case __NR_listxattr: /* Just pathname, TODO add list */
   906		case __NR_llistxattr: /* Just pathname, TODO add list */
   907		case __NR_lsetxattr: /* Just pathname, TODO add list */
   908		case __NR_open:
   909		case __NR_memfd_create:
   910		case __NR_mount: /* Just dev_name, TODO add dir_name and type */
   911		case __NR_mkdir:
   912		case __NR_mknod:
   913		case __NR_mq_open:
   914		case __NR_mq_unlink:
   915		case __NR_pivot_root: /* Just new_root, TODO add old_root */
   916		case __NR_readlink:
   917		case __NR_removexattr: /* Just pathname, TODO add name */
   918		case __NR_rename: /* Just oldname. TODO add newname */
   919		case __NR_request_key: /* Just _type. TODO add _description */
   920		case __NR_rmdir:
   921		case __NR_setxattr: /* Just pathname, TODO add list */
   922		case __NR_shmdt:
   923		case __NR_statfs:
   924		case __NR_swapon:
   925		case __NR_swapoff:
   926		case __NR_symlink: /* Just oldname. TODO add newname */
   927		case __NR_truncate:
   928		case __NR_unlink:
   929		case __NR_umount2:
   930		case __NR_utime:
   931		case __NR_utimes:
   932			sys_data->user_mask = BIT(0);
   933			break;
   934		/* user arg at position 1 */
   935		case __NR_execveat:
   936		case __NR_faccessat:
   937		case __NR_faccessat2:
   938		case __NR_finit_module:
   939		case __NR_fchmodat:
   940		case __NR_fchmodat2:
   941		case __NR_fchownat:
   942		case __NR_fgetxattr:
   943		case __NR_flistxattr:
   944		case __NR_fsetxattr:
   945		case __NR_fspick:
   946		case __NR_fremovexattr:
   947		case __NR_futimesat:
   948		case __NR_getxattrat: /* Just pathname, TODO add name */
   949		case __NR_inotify_add_watch:
   950		case __NR_linkat: /* Just oldname. TODO add newname */
   951		case __NR_listxattrat: /* Just pathname, TODO add list */
   952		case __NR_mkdirat:
   953		case __NR_mknodat:
   954		case __NR_mount_setattr:
   955		case __NR_move_mount: /* Just from_pathname, TODO add to_pathname */
   956		case __NR_name_to_handle_at:
   957		case __NR_newfstatat:
   958		case __NR_openat:
   959		case __NR_openat2:
   960		case __NR_open_tree:
   961		case __NR_open_tree_attr:
   962		case __NR_readlinkat:
   963		case __NR_renameat: /* Just oldname. TODO add newname */
   964		case __NR_renameat2: /* Just oldname. TODO add newname */
   965		case __NR_removexattrat: /* Just pathname, TODO add name */
   966		case __NR_quotactl:
   967		case __NR_setxattrat: /* Just pathname, TODO add list */
   968		case __NR_syslog:
   969		case __NR_symlinkat: /* Just oldname. TODO add newname */
   970		case __NR_statx:
   971		case __NR_unlinkat:
   972		case __NR_utimensat:
   973			sys_data->user_mask = BIT(1);
   974			break;
   975		/* user arg at position 2 */
   976		case __NR_init_module:
   977		case __NR_fsconfig:
   978			sys_data->user_mask = BIT(2);
   979			break;
   980		/* user arg at position 4 */
   981		case __NR_fanotify_mark:
   982			sys_data->user_mask = BIT(4);
   983			break;
   984		default:
   985			sys_data->user_mask = 0;
   986		}
   987	}
   988	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

