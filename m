Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB7FDC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 14:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A5AB6B009F; Wed,  6 Aug 2025 10:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656586B00A1; Wed,  6 Aug 2025 10:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56BE16B00A2; Wed,  6 Aug 2025 10:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46E666B009F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:40:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2B961DCF33
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:40:08 +0000 (UTC)
X-FDA: 83746592496.08.57F29F6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf26.hostedemail.com (Postfix) with ESMTP id 18374140010
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:40:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g4s93K1c;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754491206; a=rsa-sha256;
	cv=none;
	b=3fU6TbVFJqOsOsrZRXZzWorrImllDJYibnUbmpVFU9YIMV9zwgovrzshkDrBO0vjI2HaKM
	Un0fVW3+ixtYy0fc8ZHJWUPFAOuftSuF/8f/or8JriI6Aw2pkIfXASfuMg2juC7EbmOmk3
	2ZsssKjii9UIrPsdYGq8lLXi4SDUxQk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g4s93K1c;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754491206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1vyqAXSnHSxa1Yw2TKy41CyM8w43R1YIFxt8Q/JWysc=;
	b=h6kn7XMoiTws2K50J+L04CwDtq0U5g/avY2drIgkVSf4+rw/rKO4kxqSVOmZoaMJURj9J5
	9PZYp1Sn1KQUcxEz5e66psHjzObpsEiP1gN+aOYzxS9d5bm5uoBiD2R40npQzyOLc6K2Kj
	RzU5hBzy6pMG18mzdiUw/3y/uWFfiRc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754491206; x=1786027206;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aLheObBNOVd5wWcfX/UlmeZiWYAW9l+I+b/18Y/UWsk=;
  b=g4s93K1cP4m/P4Kq3Da2f8I0GyKPPcWaukZj2iB+uLQqAtpg279Gm8qf
   spDmxvpC0zZ3s9xm/6IEgxrPEhunYMNSfnyMC14jaiAXxH2stHzjxX58c
   pmWoyfw2j6biPDJQH9gI7HDYoxwnAP7dkUap5s5oNys0HwlBAVbSHvuGT
   0Lfhuu1myaFQ1QTy3T5vCx2GSc7cRLH/3XextAll0ju1yi/KW25Ln0wIO
   t4Zr1tk3UxnKv2gjA27BSX4lIR3sWKXPkF3Wo3njN6WY81yHE+WDPGInC
   EtpAbITwUC/vkw5Lj1c3NrbxJLPvIr+GXcR1GBAdfl666UoiwT3+TRIgJ
   g==;
X-CSE-ConnectionGUID: LsBrV658SqqJRNiros1YIg==
X-CSE-MsgGUID: +gXfu/PyQ5KLVsIfYEpoZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="56889864"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="56889864"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 07:40:04 -0700
X-CSE-ConnectionGUID: 5NGPTsi5QaGcZR7dOLyoKw==
X-CSE-MsgGUID: shcTRVviTBSO32SyPM8lpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="188461741"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 06 Aug 2025 07:40:01 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ujfJ3-0001m2-0O;
	Wed, 06 Aug 2025 14:39:54 +0000
Date: Wed, 6 Aug 2025 22:39:48 +0800
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
Subject: Re: [PATCH 3/7] tracing: Have syscall trace events read user space
 string
Message-ID: <202508062230.puMRaDdE-lkp@intel.com>
References: <20250805193235.080757106@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805193235.080757106@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 18374140010
X-Stat-Signature: m8qazegnri19cmwyrf678q78b6a6jk6b
X-HE-Tag: 1754491205-809461
X-HE-Meta: U2FsdGVkX1/vv0FP6XzvPQgPkv9XfwMKQ7UrjlGoW6oqcAo7Pf/u9QaN0aFiy8mpCP49MwIZGsokhSEbrpv7PiGZ0uIb4N6RiZuhMMDjTs/EWZqmtQ/7O0xf5UndQNMyizVAOf9agnVNua7kcqBiH3m/l3UBxNhE3578zYQuEKCdpEf2rmMbyoOk6FkASMBWwo6S3sL+/W2x1xRLBaGlEilDHzcXtIrlXUSBFpxXz5d7IcbHAtzkxPxMjkjkbJsJdEAkUayY5J2M4vdxAQ1amrlFAWR8/BwiuEINP9q0Tvcq2Legw0sMeLnHN4et1FacF793z+BN6MT/+w6qGtDXpPQoLX8tU57ldLsGaUqfQConE6RFm60+/lbdck+YA1zB36bmiB+qx0YOJlTSMhPZmPaUiEcpnxtcCB1TO2PSyXcOEkhFyBIHe5ZwP8qDqAJqdyjBoLQVFMYNzdLLqPpz86bBGA+3Q28NQlZmmTNSCKxjG5LxOeOdSy0kj0dOsPtcjldnoEoMAGofHs86TfClO7TczP5KngmM8CN4kMF5MjvWnxDxuvY7YMveuKRlegyKiaXZMpNjEhy/1R/WglJHxFuet2pYmiUCRBLopBgja5uWsF0CgT2u7giLh75D4RIt1qK8sdTbYDIlM/lVaBEdZycB6JsI/dUgQoiMbKc2Q/lca3BivtWvRYWfrv+oY2lmPhe5n8ghisplJyEls2twvx9X+53DZH8FdcfiiOXWGRpiRevj8XmxMZDhaf1x6c9hXGCWtQuyavZiOVSGZi0Ph4wlKACWdGPrY1261ThXjPhu+IOMjE7TLBr9vTCzPv+i0l2IVtsNpjY6/MQxZhvtQVHH3Or7niJlcVBTeP8y3tMc1LD1b/iOa3UOFJ7SZyAanGErsEOoaERZlW2lOlo4aJRqKUgk7GxApOn+gQWyfr7hi58zrbyVp+YuDtQOyHnZyajnOKWbuOGeaOrl7/d
 nudh4ojq
 qMqfM457R2xeR1Xyxmp0fLPTFbyGS2VOdD9SgCtjFH2aTdXrqPeGVQLLWT8elElWK0b433dnLLEQL3Ru+l3f6r1QhizvxuhdW7oCeVQp0bf2djKVGZfA/og2sdprftfSNDOzoJgJmDDfGkRclWbgouwnINuP63mYLXMap5ImXBtASaUGwmrz2U5NUh/oCV6yc//8fVdQRngrbchifKdHDtrsW8sTNg6riHnbfmt3lkbcRiwN1V3muKrHI67RnA0z3PBCZZI/e6l0z33IMddBnXYpiGS+1aKomQhkce1UPvWDngtPD3mRRCayy2yp4zFuCdCnPlEkHBjvjhqYoNyCascUM4qdYqYYSaJJ7
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
patch link:    https://lore.kernel.org/r/20250805193235.080757106%40kernel.org
patch subject: [PATCH 3/7] tracing: Have syscall trace events read user space string
config: parisc-randconfig-r071-20250806 (https://download.01.org/0day-ci/archive/20250806/202508062230.puMRaDdE-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250806/202508062230.puMRaDdE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508062230.puMRaDdE-lkp@intel.com/

All errors (new ones prefixed by >>):

   kernel/trace/trace_syscalls.c: In function 'check_faultable_syscall':
>> kernel/trace/trace_syscalls.c:886:14: error: '__NR_newfstatat' undeclared (first use in this function); did you mean 'sys_newfstatat'?
     886 |         case __NR_newfstatat:
         |              ^~~~~~~~~~~~~~~
         |              sys_newfstatat
   kernel/trace/trace_syscalls.c:886:14: note: each undeclared identifier is reported only once for each function it appears in


vim +886 kernel/trace/trace_syscalls.c

   802	
   803	/*
   804	 * For system calls that reference user space memory that can
   805	 * be recorded into the event, set the system call meta data's user_mask
   806	 * to the "args" index that points to the user space memory to retrieve.
   807	 */
   808	static void check_faultable_syscall(struct trace_event_call *call, int nr)
   809	{
   810		struct syscall_metadata *sys_data = call->data;
   811	
   812		/* Only work on entry */
   813		if (sys_data->enter_event != call)
   814			return;
   815	
   816		switch (nr) {
   817		/* user arg at position 0 */
   818		case __NR_access:
   819		case __NR_acct:
   820		case __NR_add_key: /* Just _type. TODO add _description */
   821		case __NR_chdir:
   822		case __NR_chown:
   823		case __NR_chmod:
   824		case __NR_chroot:
   825		case __NR_creat:
   826		case __NR_delete_module:
   827		case __NR_execve:
   828		case __NR_fsopen:
   829		case __NR_getxattr: /* Just pathname, TODO add name */
   830		case __NR_lchown:
   831		case __NR_lgetxattr: /* Just pathname, TODO add name */
   832		case __NR_lremovexattr: /* Just pathname, TODO add name */
   833		case __NR_link: /* Just oldname. TODO add newname */
   834		case __NR_listxattr: /* Just pathname, TODO add list */
   835		case __NR_llistxattr: /* Just pathname, TODO add list */
   836		case __NR_lsetxattr: /* Just pathname, TODO add list */
   837		case __NR_open:
   838		case __NR_memfd_create:
   839		case __NR_mount: /* Just dev_name, TODO add dir_name and type */
   840		case __NR_mkdir:
   841		case __NR_mknod:
   842		case __NR_mq_open:
   843		case __NR_mq_unlink:
   844		case __NR_pivot_root: /* Just new_root, TODO add old_root */
   845		case __NR_readlink:
   846		case __NR_removexattr: /* Just pathname, TODO add name */
   847		case __NR_rename: /* Just oldname. TODO add newname */
   848		case __NR_request_key: /* Just _type. TODO add _description */
   849		case __NR_rmdir:
   850		case __NR_setxattr: /* Just pathname, TODO add list */
   851		case __NR_shmdt:
   852		case __NR_statfs:
   853		case __NR_swapon:
   854		case __NR_swapoff:
   855		case __NR_symlink: /* Just oldname. TODO add newname */
   856		case __NR_truncate:
   857		case __NR_unlink:
   858		case __NR_umount2:
   859		case __NR_utime:
   860		case __NR_utimes:
   861			sys_data->user_mask = BIT(0);
   862			break;
   863		/* user arg at position 1 */
   864		case __NR_execveat:
   865		case __NR_faccessat:
   866		case __NR_faccessat2:
   867		case __NR_finit_module:
   868		case __NR_fchmodat:
   869		case __NR_fchmodat2:
   870		case __NR_fchownat:
   871		case __NR_fgetxattr:
   872		case __NR_flistxattr:
   873		case __NR_fsetxattr:
   874		case __NR_fspick:
   875		case __NR_fremovexattr:
   876		case __NR_futimesat:
   877		case __NR_getxattrat: /* Just pathname, TODO add name */
   878		case __NR_inotify_add_watch:
   879		case __NR_linkat: /* Just oldname. TODO add newname */
   880		case __NR_listxattrat: /* Just pathname, TODO add list */
   881		case __NR_mkdirat:
   882		case __NR_mknodat:
   883		case __NR_mount_setattr:
   884		case __NR_move_mount: /* Just from_pathname, TODO add to_pathname */
   885		case __NR_name_to_handle_at:
 > 886		case __NR_newfstatat:
   887		case __NR_openat:
   888		case __NR_openat2:
   889		case __NR_open_tree:
   890		case __NR_open_tree_attr:
   891		case __NR_readlinkat:
   892		case __NR_renameat: /* Just oldname. TODO add newname */
   893		case __NR_renameat2: /* Just oldname. TODO add newname */
   894		case __NR_removexattrat: /* Just pathname, TODO add name */
   895		case __NR_quotactl:
   896		case __NR_setxattrat: /* Just pathname, TODO add list */
   897		case __NR_syslog:
   898		case __NR_symlinkat: /* Just oldname. TODO add newname */
   899		case __NR_statx:
   900		case __NR_unlinkat:
   901		case __NR_utimensat:
   902			sys_data->user_mask = BIT(1);
   903			break;
   904		/* user arg at position 2 */
   905		case __NR_init_module:
   906		case __NR_fsconfig:
   907			sys_data->user_mask = BIT(2);
   908			break;
   909		/* user arg at position 4 */
   910		case __NR_fanotify_mark:
   911			sys_data->user_mask = BIT(4);
   912			break;
   913		default:
   914			sys_data->user_mask = 0;
   915		}
   916	}
   917	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

