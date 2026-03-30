Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF70B10D149E
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53C3F6B009B; Mon, 30 Mar 2026 07:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EC3C6B009F; Mon, 30 Mar 2026 07:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4F66B00A0; Mon, 30 Mar 2026 07:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C8446B009B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:06:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D36C3140654
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:06:05 +0000 (UTC)
X-FDA: 84602449890.14.BAC0ADA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf04.hostedemail.com (Postfix) with ESMTP id 68C0A40006
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:06:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z+kTQBLS;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774868763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffkCeTQ1jpK1sYQyYKD3OP2iG7cl+afesCTCCvPTTJM=;
	b=5ZpTWef7V3GIhmfhPD4aBEmLB1YPDrKFIDpB8co4SkDhli+ArSMfdQOHqXWJslqikDECXv
	0aXQtxquubo1QwNwr4U3NNzAWEJk/8juv+pF6+UVRrdW+MGX1tGc+qvCa6gpX3SfywBkaf
	cqkcpLlDo+9hcNF6qzBDqj7oM7eLf4A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774868763; a=rsa-sha256;
	cv=none;
	b=693VoJwwTrGX3e/ULv/rqScL17Mfj2tyWsEisNxUQJ2/amQAqYltAUODJsa2jsF/LxkaUT
	3RC5R57rhHxEB0sP7psdI1BXGIpYd4JdruMPj2rfoXnDTaqc8b48vWiqU2Cgzhq9NWg7VB
	to53yypku62NT0QiRUctBHWlCUzaa9M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z+kTQBLS;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774868764; x=1806404764;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hjr5krT4CLrNQ952X9AgvxXKxqnshcoK/ipdZnb83E0=;
  b=Z+kTQBLSdT9ruUmxRe7cOiLH/d1G+5QWyTc9mi9Ino027ziqSAguwH82
   wq8EgLqHwqIcDu9aJFSRik8dh0RTTvy+MeG50EhTJ32oOcA6RSeDlXu6P
   mf0r2KDA8PPDGFfpKwzp2JvW3GX59H9CRghSfkogfwgUu4iC1ZTtmgZoI
   J3sz6LgWAyzMoHguMvLfo5v6aR8LEW2uBfYKGKMOYLPoRapk/w7wuQQh5
   hHfNlc4BdIq4hImAtFVExeTBAGANn2dsF0HHG6G5FHOqK+d+IkjwXkH7O
   IDcJ2m9Xy4GuJE8T8jtbqZkC8CSUTvOjBH7BnfFRcsZH/dhDsC7hui9xA
   g==;
X-CSE-ConnectionGUID: WWpXmzi5Qx20A7AQvkmoTg==
X-CSE-MsgGUID: HmpvAz+6TB+u+tapMXjyZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11743"; a="76049464"
X-IronPort-AV: E=Sophos;i="6.23,149,1770624000"; 
   d="scan'208";a="76049464"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 04:05:59 -0700
X-CSE-ConnectionGUID: GZeg4TcHRhaj56W/PFS1Pg==
X-CSE-MsgGUID: yC4rhwpwS+642v7/11PXNg==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 283bf2e1b94a) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 30 Mar 2026 04:05:55 -0700
Received: from kbuild by 283bf2e1b94a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w7ARN-000000000zu-0701;
	Mon, 30 Mar 2026 11:05:53 +0000
Date: Mon, 30 Mar 2026 19:05:03 +0800
From: kernel test robot <lkp@intel.com>
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH v7 3/6] mm/hmm: do the plumbing for HMM to participate in
 migration
Message-ID: <202603301844.FdEMshbo-lkp@intel.com>
References: <20260330043017.251808-4-mpenttil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330043017.251808-4-mpenttil@redhat.com>
X-Rspamd-Queue-Id: 68C0A40006
X-Stat-Signature: 1mtuyedkf4jy9zq645fkckj3p9z65r1r
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774868763-670260
X-HE-Meta: U2FsdGVkX1/SmMFYfufa+sYT96t3T8YyLgHveI+r3yuBxOsR7L4u02bYJD1guGxQTVliHQsk28PDwxv87giSFUgcDt+KGX+PY4a9geKl8AfRJGMgZhnNpdhMuUVpPVzR1i41+tTZoBfujaKjEOECIcw3kCWQSTiU84heTbITmOeAyqYDtgGlvRlH8Cg3EmkJ/VDEJ0hevpe67YumNPDnlepoJtvvEaPUH9rjHXkywxwwHvMkviGi53knN/G93ht7yRGB+pfKQ/STBzmoMHaZg9QLSMOugQWsZrqFp1nhRKbNf1jnfaXNu3vFgEJpfBCfuTBdSPYfGVcP7hlZvWtNnDL934oiDEQgRTlMNVP39zwPkSk62AjlbSyQQGDq5KQu6tva7v38dAVmey1K17zElUX4qVROYMRy2nbttqrShr7TDub9SeNE2s5AFoz3EgTafAYYRIIVznK+VBVVRa536TrUgQIWyuDRMmzznLyJn+lO0aT41yi0Utx0WGsDnFGGLh3Cd7eAcdzHYATdL9QfgEl0YOkue1/Tnpe6Ig9Fdre6dbo+DrwGqWz0UQPJfFpZ0bJbaVyy70JWlLPPF2nBD3w168F1AdcP3w65jLlCAjdagit6zG0E4JKWtHwX6EtQkskt/HZFwvthU4irOIrX1ElVvwrcuODuhENXakkvObKtpJMZ/+Cxvfs8ABppmlWoZAwxvP4JHaLPhaJoaHbw5XLy0Q/0F8WZMU7sNr+HXIcKV6pWm6AF8sX7TVLJqUU/dRjmXrLjKiUDpK0Y9F/eaH0LiznSP8lZ9J/gJy/E+BtrPxfx9uRnBNU/e9OZChGr/E+PZ8JsMK193G8NLKtWZPvxx10mbLF+HdPdgm63Ji53C55TiDc9/Uuc2TloWylbS1p4OGAvc40MJD156svCy4ufSn93GPn9v5DZtrOHzFKtXPUNhX66WWJ4EMTvtm4ItGZwChO1oGfhUr+oxQn
 pO8TraFu
 dJxWQV/Jk/NRALGXI+/z0iCUwFZgeOv+1onhfPRHmKk7yl5bOfb/d31jCxzrjJrKI1l78BIH8kvrUKYbQn4jAeuuWo9F/foMbCK6lRbT1+2SOc/9pMqtnvuEdBGMxTcdU0NwNEvsSNWyiNRaSmfo9HKZZieJH0pwlNCIUM8jc1HA14YJU81Xc3r25T3h8hdtYUCIjof2SKL226GbWPsJgbTIGcLQHD7cEu5Rs76c2CxDEu7wcQmy38mIKGYuR4r8Om+RsW/rcU9pyYvSzQTn2xlpQWxlwCVwssQhmiarJOdiIFAE+Pr22vv0gLFVMrdsDFsVi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on 7aaa8047eafd0bd628065b15757d9b48c5f9c07d]

url:    https://github.com/intel-lab-lkp/linux/commits/mpenttil-redhat-com/mm-Kconfig-changes-for-migrate-on-fault-for-device-pages/20260330-124915
base:   7aaa8047eafd0bd628065b15757d9b48c5f9c07d
patch link:    https://lore.kernel.org/r/20260330043017.251808-4-mpenttil%40redhat.com
patch subject: [PATCH v7 3/6] mm/hmm: do the plumbing for HMM to participate in migration
config: powerpc-allnoconfig (https://download.01.org/0day-ci/archive/20260330/202603301844.FdEMshbo-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260330/202603301844.FdEMshbo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603301844.FdEMshbo-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   fs/aio.c:702:21: error: assignment to 'struct kioctx_table *' from incompatible pointer type 'struct kioctx_table *' [-Wincompatible-pointer-types]
     702 |                 old = rcu_dereference_raw(mm->ioctx_table);
         |                     ^
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   fs/aio.c:719:13: error: invalid storage class for function 'aio_nr_sub'
     719 | static void aio_nr_sub(unsigned nr)
         |             ^~~~~~~~~~
   fs/aio.c:732:23: error: invalid storage class for function 'ioctx_alloc'
     732 | static struct kioctx *ioctx_alloc(unsigned nr_events)
         |                       ^~~~~~~~~~~
   fs/aio.c:847:12: error: invalid storage class for function 'kill_ioctx'
     847 | static int kill_ioctx(struct mm_struct *mm, struct kioctx *ctx,
         |            ^~~~~~~~~~
   fs/aio.c: In function 'kill_ioctx':
   fs/aio.c:858:15: error: assignment to 'struct kioctx_table *' from incompatible pointer type 'struct kioctx_table *' [-Wincompatible-pointer-types]
     858 |         table = rcu_dereference_raw(mm->ioctx_table);
         |               ^
   fs/aio.c:859:21: warning: comparison of distinct pointer types lacks a cast [-Wcompare-distinct-pointer-types]
     859 |         WARN_ON(ctx != rcu_access_pointer(table->table[ctx->id]));
         |                     ^~
   include/asm-generic/bug.h:110:32: note: in definition of macro 'WARN_ON'
     110 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   In file included from include/linux/rbtree.h:24,
                    from include/linux/mm_types.h:11,
                    from include/linux/mmzone.h:22,
                    from include/linux/gfp.h:7,
                    from include/linux/xarray.h:16,
                    from include/linux/list_lru.h:14,
                    from include/linux/fs/super_types.h:7,
                    from include/linux/fs/super.h:5,
                    from include/linux/fs.h:5:
   fs/aio.c: In function 'exit_aio':
   include/linux/rcupdate.h:526:1: error: initialization of 'struct kioctx_table *' from incompatible pointer type 'struct kioctx_table *' [-Wincompatible-pointer-types]
     526 | ({ \
         | ^
   include/linux/rcupdate.h:531:32: note: in expansion of macro '__rcu_dereference_raw'
     531 | #define rcu_dereference_raw(p) __rcu_dereference_raw(p, __UNIQUE_ID(rcu))
         |                                ^~~~~~~~~~~~~~~~~~~~~
   fs/aio.c:893:38: note: in expansion of macro 'rcu_dereference_raw'
     893 |         struct kioctx_table *table = rcu_dereference_raw(mm->ioctx_table);
         |                                      ^~~~~~~~~~~~~~~~~~~
   include/linux/rcupdate.h:520:1: error: initialization of 'struct kioctx *' from incompatible pointer type 'struct kioctx *' [-Wincompatible-pointer-types]
     520 | ({ \
         | ^
   include/linux/rcupdate.h:743:9: note: in expansion of macro '__rcu_dereference_protected'
     743 |         __rcu_dereference_protected((p), __UNIQUE_ID(rcu), (c), __rcu)
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/aio.c:906:25: note: in expansion of macro 'rcu_dereference_protected'
     906 |                         rcu_dereference_protected(table->table[i], true);
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   fs/aio.c:933:13: error: invalid storage class for function 'put_reqs_available'
     933 | static void put_reqs_available(struct kioctx *ctx, unsigned nr)
         |             ^~~~~~~~~~~~~~~~~~
   fs/aio.c:950:13: error: invalid storage class for function '__get_reqs_available'
     950 | static bool __get_reqs_available(struct kioctx *ctx)
         |             ^~~~~~~~~~~~~~~~~~~~
   fs/aio.c:984:13: error: invalid storage class for function 'refill_reqs_available'
     984 | static void refill_reqs_available(struct kioctx *ctx, unsigned head,
         |             ^~~~~~~~~~~~~~~~~~~~~
   fs/aio.c:1013:13: error: invalid storage class for function 'user_refill_reqs_available'
    1013 | static void user_refill_reqs_available(struct kioctx *ctx)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
   fs/aio.c:1038:13: error: invalid storage class for function 'get_reqs_available'
    1038 | static bool get_reqs_available(struct kioctx *ctx)
         |             ^~~~~~~~~~~~~~~~~~
   fs/aio.c:1053:33: error: invalid storage class for function 'aio_get_req'
    1053 | static inline struct aio_kiocb *aio_get_req(struct kioctx *ctx)
         |                                 ^~~~~~~~~~~
   fs/aio.c:1074:23: error: invalid storage class for function 'lookup_ioctx'
    1074 | static struct kioctx *lookup_ioctx(unsigned long ctx_id)
         |                       ^~~~~~~~~~~~
   fs/aio.c: In function 'lookup_ioctx':
   fs/aio.c:1086:15: error: assignment to 'struct kioctx_table *' from incompatible pointer type 'struct kioctx_table *' [-Wincompatible-pointer-types]
    1086 |         table = rcu_dereference(mm->ioctx_table);
         |               ^
   fs/aio.c:1092:13: error: assignment to 'struct kioctx *' from incompatible pointer type 'struct kioctx *' [-Wincompatible-pointer-types]
    1092 |         ctx = rcu_dereference(table->table[id]);
         |             ^
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   fs/aio.c:1102:20: error: invalid storage class for function 'iocb_destroy'
    1102 | static inline void iocb_destroy(struct aio_kiocb *iocb)
         |                    ^~~~~~~~~~~~
   fs/aio.c:1120:13: error: invalid storage class for function 'aio_complete'
    1120 | static void aio_complete(struct aio_kiocb *iocb)
         |             ^~~~~~~~~~~~
   fs/aio.c:1205:20: error: invalid storage class for function 'iocb_put'
    1205 | static inline void iocb_put(struct aio_kiocb *iocb)
         |                    ^~~~~~~~
   fs/aio.c:1217:13: error: invalid storage class for function 'aio_read_events_ring'
    1217 | static long aio_read_events_ring(struct kioctx *ctx,
         |             ^~~~~~~~~~~~~~~~~~~~
   fs/aio.c:1294:13: error: invalid storage class for function 'aio_read_events'
    1294 | static bool aio_read_events(struct kioctx *ctx, long min_nr, long nr,
         |             ^~~~~~~~~~~~~~~
   fs/aio.c:1311:13: error: invalid storage class for function 'read_events'
    1311 | static long read_events(struct kioctx *ctx, long min_nr, long nr,
         |             ^~~~~~~~~~~
   In file included from include/linux/syscalls.h:105:
>> arch/powerpc/include/asm/syscall_wrapper.h:21:21: error: invalid storage class for function '__se_sys_io_setup'
      21 |         static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__));             \
         |                     ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:226:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     226 | #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:1381:1: note: in expansion of macro 'SYSCALL_DEFINE2'
    1381 | SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
         | ^~~~~~~~~~~~~~~
>> arch/powerpc/include/asm/syscall_wrapper.h:22:28: error: invalid storage class for function '__do_sys_io_setup'
      22 |         static inline long __do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));      \
         |                            ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:226:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     226 | #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:1381:1: note: in expansion of macro 'SYSCALL_DEFINE2'
    1381 | SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
         | ^~~~~~~~~~~~~~~
>> arch/powerpc/include/asm/syscall_wrapper.h:23:14: error: static declaration of 'sys_io_setup' follows non-static declaration
      23 |         long sys##name(const struct pt_regs *regs)                      \
         |              ^~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:226:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     226 | #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:1381:1: note: in expansion of macro 'SYSCALL_DEFINE2'
    1381 | SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
         | ^~~~~~~~~~~~~~~
   arch/powerpc/include/asm/syscall_wrapper.h:19:14: note: previous declaration of 'sys_io_setup' with type 'long int(const struct pt_regs *)'
      19 |         long sys##name(const struct pt_regs *regs);                     \
         |              ^~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:226:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     226 | #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:1381:1: note: in expansion of macro 'SYSCALL_DEFINE2'
    1381 | SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function 'sys_io_setup':
>> arch/powerpc/include/asm/syscall_wrapper.h:25:24: error: implicit declaration of function '__se_sys_io_setup'; did you mean 'sys_io_setup'? [-Wimplicit-function-declaration]
      25 |                 return __se_sys##name(SC_POWERPC_REGS_TO_ARGS(x,__VA_ARGS__));  \
         |                        ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:226:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     226 | #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:1381:1: note: in expansion of macro 'SYSCALL_DEFINE2'
    1381 | SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   arch/powerpc/include/asm/syscall_wrapper.h:27:21: error: invalid storage class for function '__se_sys_io_setup'
      27 |         static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__))              \
         |                     ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:226:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     226 | #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:1381:1: note: in expansion of macro 'SYSCALL_DEFINE2'
    1381 | SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function '__se_sys_io_setup':
>> arch/powerpc/include/asm/syscall_wrapper.h:29:28: error: implicit declaration of function '__do_sys_io_setup'; did you mean '__se_sys_io_setup'? [-Wimplicit-function-declaration]
      29 |                 long ret = __do_sys##name(__MAP(x,__SC_CAST,__VA_ARGS__));      \
         |                            ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:226:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     226 | #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:1381:1: note: in expansion of macro 'SYSCALL_DEFINE2'
    1381 | SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   arch/powerpc/include/asm/syscall_wrapper.h:34:28: error: invalid storage class for function '__do_sys_io_setup'
      34 |         static inline long __do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))
         |                            ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:226:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     226 | #define SYSCALL_DEFINE2(name, ...) SYSCALL_DEFINEx(2, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:1381:1: note: in expansion of macro 'SYSCALL_DEFINE2'
    1381 | SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
         | ^~~~~~~~~~~~~~~
>> arch/powerpc/include/asm/syscall_wrapper.h:21:21: error: invalid storage class for function '__se_sys_io_destroy'
      21 |         static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__));             \
         |                     ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:225:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:1450:1: note: in expansion of macro 'SYSCALL_DEFINE1'
    1450 | SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
         | ^~~~~~~~~~~~~~~
>> arch/powerpc/include/asm/syscall_wrapper.h:22:28: error: invalid storage class for function '__do_sys_io_destroy'
      22 |         static inline long __do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));      \
         |                            ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:225:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:1450:1: note: in expansion of macro 'SYSCALL_DEFINE1'
    1450 | SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
         | ^~~~~~~~~~~~~~~
>> arch/powerpc/include/asm/syscall_wrapper.h:23:14: error: static declaration of 'sys_io_destroy' follows non-static declaration
      23 |         long sys##name(const struct pt_regs *regs)                      \
         |              ^~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:225:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:1450:1: note: in expansion of macro 'SYSCALL_DEFINE1'
    1450 | SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
         | ^~~~~~~~~~~~~~~
   arch/powerpc/include/asm/syscall_wrapper.h:19:14: note: previous declaration of 'sys_io_destroy' with type 'long int(const struct pt_regs *)'
      19 |         long sys##name(const struct pt_regs *regs);                     \
         |              ^~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:225:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:1450:1: note: in expansion of macro 'SYSCALL_DEFINE1'
    1450 | SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function 'sys_io_destroy':
>> arch/powerpc/include/asm/syscall_wrapper.h:25:24: error: implicit declaration of function '__se_sys_io_destroy'; did you mean 'sys_io_destroy'? [-Wimplicit-function-declaration]
      25 |                 return __se_sys##name(SC_POWERPC_REGS_TO_ARGS(x,__VA_ARGS__));  \
         |                        ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:225:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:1450:1: note: in expansion of macro 'SYSCALL_DEFINE1'
    1450 | SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   arch/powerpc/include/asm/syscall_wrapper.h:27:21: error: invalid storage class for function '__se_sys_io_destroy'
      27 |         static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__))              \
         |                     ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:225:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:1450:1: note: in expansion of macro 'SYSCALL_DEFINE1'
    1450 | SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function '__se_sys_io_destroy':
>> arch/powerpc/include/asm/syscall_wrapper.h:29:28: error: implicit declaration of function '__do_sys_io_destroy'; did you mean '__se_sys_io_destroy'? [-Wimplicit-function-declaration]
      29 |                 long ret = __do_sys##name(__MAP(x,__SC_CAST,__VA_ARGS__));      \
         |                            ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:225:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:1450:1: note: in expansion of macro 'SYSCALL_DEFINE1'
    1450 | SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   arch/powerpc/include/asm/syscall_wrapper.h:34:28: error: invalid storage class for function '__do_sys_io_destroy'
      34 |         static inline long __do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))
         |                            ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:225:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:1450:1: note: in expansion of macro 'SYSCALL_DEFINE1'
    1450 | SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
         | ^~~~~~~~~~~~~~~
   fs/aio.c:1480:13: error: invalid storage class for function 'aio_remove_iocb'
    1480 | static void aio_remove_iocb(struct aio_kiocb *iocb)
         |             ^~~~~~~~~~~~~~~
   fs/aio.c:1490:13: error: invalid storage class for function 'aio_complete_rw'
    1490 | static void aio_complete_rw(struct kiocb *kiocb, long res)
         |             ^~~~~~~~~~~~~~~
   fs/aio.c:1509:12: error: invalid storage class for function 'aio_prep_rw'
    1509 | static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb, int rw_type)
         |            ^~~~~~~~~~~
   fs/aio.c:1544:16: error: invalid storage class for function 'aio_setup_rw'
    1544 | static ssize_t aio_setup_rw(int rw, const struct iocb *iocb,
         |                ^~~~~~~~~~~~
   fs/aio.c: In function 'aio_setup_rw':
   fs/aio.c:1552:57: error: passing argument 4 of 'import_ubuf' from incompatible pointer type [-Wincompatible-pointer-types]
    1552 |                 ssize_t ret = import_ubuf(rw, buf, len, iter);
         |                                                         ^~~~
         |                                                         |
         |                                                         struct iov_iter *
   In file included from fs/aio.c:23:
   include/linux/uio.h:370:74: note: expected 'struct iov_iter *' but argument is of type 'struct iov_iter *'
     370 | int import_ubuf(int type, void __user *buf, size_t len, struct iov_iter *i);
         |                                                         ~~~~~~~~~~~~~~~~~^
   fs/aio.c:1557:65: error: passing argument 6 of '__import_iovec' from incompatible pointer type [-Wincompatible-pointer-types]
    1557 |         return __import_iovec(rw, buf, len, UIO_FASTIOV, iovec, iter, compat);
         |                                                                 ^~~~
         |                                                                 |
         |                                                                 struct iov_iter *
   include/linux/uio.h:369:35: note: expected 'struct iov_iter *' but argument is of type 'struct iov_iter *'
     369 |                  struct iov_iter *i, bool compat);
         |                  ~~~~~~~~~~~~~~~~~^
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   fs/aio.c:1560:20: error: invalid storage class for function 'aio_rw_done'
    1560 | static inline void aio_rw_done(struct kiocb *req, ssize_t ret)
         |                    ^~~~~~~~~~~
   fs/aio.c:1580:12: error: invalid storage class for function 'aio_read'
    1580 | static int aio_read(struct kiocb *req, const struct iocb *iocb,
         |            ^~~~~~~~
   fs/aio.c: In function 'aio_read':
   fs/aio.c:1584:25: error: storage size of 'iter' isn't known
    1584 |         struct iov_iter iter;
         |                         ^~~~
   fs/aio.c:1584:25: warning: unused variable 'iter' [-Wunused-variable]
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   fs/aio.c:1607:12: error: invalid storage class for function 'aio_write'
    1607 | static int aio_write(struct kiocb *req, const struct iocb *iocb,
         |            ^~~~~~~~~
   fs/aio.c: In function 'aio_write':
   fs/aio.c:1611:25: error: storage size of 'iter' isn't known
    1611 |         struct iov_iter iter;
         |                         ^~~~
   fs/aio.c:1611:25: warning: unused variable 'iter' [-Wunused-variable]
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   fs/aio.c:1639:13: error: invalid storage class for function 'aio_fsync_work'
    1639 | static void aio_fsync_work(struct work_struct *work)
         |             ^~~~~~~~~~~~~~
   In file included from include/linux/bitmap.h:9,
                    from include/linux/nodemask.h:91,
                    from include/linux/list_lru.h:12:
   fs/aio.c: In function 'aio_fsync_work':
   fs/aio.c:1643:38: error: passing argument 1 of 'class_override_creds_constructor' from incompatible pointer type [-Wincompatible-pointer-types]
    1643 |         scoped_with_creds(iocb->fsync.creds)
         |                           ~~~~~~~~~~~^~~~~~
         |                                      |
         |                                      struct cred *
   include/linux/cleanup.h:306:32: note: in definition of macro '__scoped_class'
     306 |         for (CLASS(_name, var)(args); ; ({ goto _label; })) \
         |                                ^~~~
   include/linux/cred.h:195:9: note: in expansion of macro 'scoped_class'
     195 |         scoped_class(override_creds, __UNIQUE_ID(label), cred)
         |         ^~~~~~~~~~~~
   fs/aio.c:1643:9: note: in expansion of macro 'scoped_with_creds'
    1643 |         scoped_with_creds(iocb->fsync.creds)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/cred.h:192:64: note: expected 'const struct cred *' but argument is of type 'struct cred *'
     192 |              override_creds(override_cred), const struct cred *override_cred)
         |                                             ~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~
   include/linux/cleanup.h:285:58: note: in definition of macro 'DEFINE_CLASS'
     285 | static __always_inline _type class_##_name##_constructor(_init_args)    \
         |                                                          ^~~~~~~~~~
   fs/aio.c:1646:29: error: passing argument 1 of 'put_cred' from incompatible pointer type [-Wincompatible-pointer-types]
    1646 |         put_cred(iocb->fsync.creds);
         |                  ~~~~~~~~~~~^~~~~~
         |                             |
         |                             struct cred *
   In file included from include/linux/sched/signal.h:10,
                    from include/linux/rcuwait.h:6,
                    from include/linux/percpu-rwsem.h:7,
                    from include/linux/fs/super_types.h:13:
   include/linux/cred.h:277:48: note: expected 'const struct cred *' but argument is of type 'struct cred *'
     277 | static inline void put_cred(const struct cred *cred)
         |                             ~~~~~~~~~~~~~~~~~~~^~~~
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   fs/aio.c:1650:12: error: invalid storage class for function 'aio_fsync'
    1650 | static int aio_fsync(struct fsync_iocb *req, const struct iocb *iocb,
         |            ^~~~~~~~~
   fs/aio.c: In function 'aio_fsync':
   fs/aio.c:1660:20: error: assignment to 'struct cred *' from incompatible pointer type 'struct cred *' [-Wincompatible-pointer-types]
    1660 |         req->creds = prepare_creds();
         |                    ^
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   fs/aio.c:1670:13: error: invalid storage class for function 'aio_poll_put_work'
    1670 | static void aio_poll_put_work(struct work_struct *work)
         |             ^~~~~~~~~~~~~~~~~
   fs/aio.c:1686:13: error: invalid storage class for function 'poll_iocb_lock_wq'
    1686 | static bool poll_iocb_lock_wq(struct poll_iocb *req)
         |             ^~~~~~~~~~~~~~~~~
   fs/aio.c:1717:13: error: invalid storage class for function 'poll_iocb_unlock_wq'
    1717 | static void poll_iocb_unlock_wq(struct poll_iocb *req)
         |             ^~~~~~~~~~~~~~~~~~~
   fs/aio.c:1723:13: error: invalid storage class for function 'aio_poll_complete_work'
    1723 | static void aio_poll_complete_work(struct work_struct *work)
         |             ^~~~~~~~~~~~~~~~~~~~~~
   fs/aio.c:1769:12: error: invalid storage class for function 'aio_poll_cancel'
    1769 | static int aio_poll_cancel(struct kiocb *iocb)
         |            ^~~~~~~~~~~~~~~
   fs/aio.c:1786:12: error: invalid storage class for function 'aio_poll_wake'
    1786 | static int aio_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
         |            ^~~~~~~~~~~~~
   fs/aio.c:1876:1: error: invalid storage class for function 'aio_poll_queue_proc'
    1876 | aio_poll_queue_proc(struct file *file, struct wait_queue_head *head,
         | ^~~~~~~~~~~~~~~~~~~
   fs/aio.c:1893:12: error: invalid storage class for function 'aio_poll'
    1893 | static int aio_poll(struct aio_kiocb *aiocb, const struct iocb *iocb)
         |            ^~~~~~~~
   fs/aio.c:1968:12: error: invalid storage class for function '__io_submit_one'
    1968 | static int __io_submit_one(struct kioctx *ctx, const struct iocb *iocb,
         |            ^~~~~~~~~~~~~~~
   fs/aio.c:2022:12: error: invalid storage class for function 'io_submit_one'
    2022 | static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
         |            ^~~~~~~~~~~~~
>> arch/powerpc/include/asm/syscall_wrapper.h:21:21: error: invalid storage class for function '__se_sys_io_submit'
      21 |         static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__));             \
         |                     ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:227:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     227 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2081:1: note: in expansion of macro 'SYSCALL_DEFINE3'
    2081 | SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
         | ^~~~~~~~~~~~~~~
>> arch/powerpc/include/asm/syscall_wrapper.h:22:28: error: invalid storage class for function '__do_sys_io_submit'
      22 |         static inline long __do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));      \
         |                            ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:227:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     227 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2081:1: note: in expansion of macro 'SYSCALL_DEFINE3'
    2081 | SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
         | ^~~~~~~~~~~~~~~
>> arch/powerpc/include/asm/syscall_wrapper.h:23:14: error: static declaration of 'sys_io_submit' follows non-static declaration
      23 |         long sys##name(const struct pt_regs *regs)                      \
         |              ^~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:227:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     227 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2081:1: note: in expansion of macro 'SYSCALL_DEFINE3'
    2081 | SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
         | ^~~~~~~~~~~~~~~
   arch/powerpc/include/asm/syscall_wrapper.h:19:14: note: previous declaration of 'sys_io_submit' with type 'long int(const struct pt_regs *)'
      19 |         long sys##name(const struct pt_regs *regs);                     \
         |              ^~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:227:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     227 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2081:1: note: in expansion of macro 'SYSCALL_DEFINE3'
    2081 | SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function 'sys_io_submit':
>> arch/powerpc/include/asm/syscall_wrapper.h:25:24: error: implicit declaration of function '__se_sys_io_submit'; did you mean 'sys_io_submit'? [-Wimplicit-function-declaration]
      25 |                 return __se_sys##name(SC_POWERPC_REGS_TO_ARGS(x,__VA_ARGS__));  \
         |                        ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:227:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     227 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2081:1: note: in expansion of macro 'SYSCALL_DEFINE3'
    2081 | SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   arch/powerpc/include/asm/syscall_wrapper.h:27:21: error: invalid storage class for function '__se_sys_io_submit'
      27 |         static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__))              \
         |                     ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:227:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     227 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2081:1: note: in expansion of macro 'SYSCALL_DEFINE3'
    2081 | SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function '__se_sys_io_submit':
>> arch/powerpc/include/asm/syscall_wrapper.h:29:28: error: implicit declaration of function '__do_sys_io_submit'; did you mean '__se_sys_io_submit'? [-Wimplicit-function-declaration]
      29 |                 long ret = __do_sys##name(__MAP(x,__SC_CAST,__VA_ARGS__));      \
         |                            ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:227:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     227 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2081:1: note: in expansion of macro 'SYSCALL_DEFINE3'
    2081 | SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   arch/powerpc/include/asm/syscall_wrapper.h:34:28: error: invalid storage class for function '__do_sys_io_submit'
      34 |         static inline long __do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))
         |                            ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:227:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     227 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2081:1: note: in expansion of macro 'SYSCALL_DEFINE3'
    2081 | SYSCALL_DEFINE3(io_submit, aio_context_t, ctx_id, long, nr,
         | ^~~~~~~~~~~~~~~
>> arch/powerpc/include/asm/syscall_wrapper.h:21:21: error: invalid storage class for function '__se_sys_io_cancel'
      21 |         static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__));             \
         |                     ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:227:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     227 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2175:1: note: in expansion of macro 'SYSCALL_DEFINE3'
    2175 | SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
         | ^~~~~~~~~~~~~~~
>> arch/powerpc/include/asm/syscall_wrapper.h:22:28: error: invalid storage class for function '__do_sys_io_cancel'
      22 |         static inline long __do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));      \
         |                            ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:227:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     227 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2175:1: note: in expansion of macro 'SYSCALL_DEFINE3'
    2175 | SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
         | ^~~~~~~~~~~~~~~
>> arch/powerpc/include/asm/syscall_wrapper.h:23:14: error: static declaration of 'sys_io_cancel' follows non-static declaration
      23 |         long sys##name(const struct pt_regs *regs)                      \
         |              ^~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:227:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     227 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2175:1: note: in expansion of macro 'SYSCALL_DEFINE3'
    2175 | SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
         | ^~~~~~~~~~~~~~~
   arch/powerpc/include/asm/syscall_wrapper.h:19:14: note: previous declaration of 'sys_io_cancel' with type 'long int(const struct pt_regs *)'
      19 |         long sys##name(const struct pt_regs *regs);                     \
         |              ^~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:227:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     227 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2175:1: note: in expansion of macro 'SYSCALL_DEFINE3'
    2175 | SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function 'sys_io_cancel':
>> arch/powerpc/include/asm/syscall_wrapper.h:25:24: error: implicit declaration of function '__se_sys_io_cancel'; did you mean 'sys_io_cancel'? [-Wimplicit-function-declaration]
      25 |                 return __se_sys##name(SC_POWERPC_REGS_TO_ARGS(x,__VA_ARGS__));  \
         |                        ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:227:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     227 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2175:1: note: in expansion of macro 'SYSCALL_DEFINE3'
    2175 | SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   arch/powerpc/include/asm/syscall_wrapper.h:27:21: error: invalid storage class for function '__se_sys_io_cancel'
      27 |         static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__))              \
         |                     ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:227:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     227 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2175:1: note: in expansion of macro 'SYSCALL_DEFINE3'
    2175 | SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function '__se_sys_io_cancel':
>> arch/powerpc/include/asm/syscall_wrapper.h:29:28: error: implicit declaration of function '__do_sys_io_cancel'; did you mean '__se_sys_io_cancel'? [-Wimplicit-function-declaration]
      29 |                 long ret = __do_sys##name(__MAP(x,__SC_CAST,__VA_ARGS__));      \
         |                            ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:227:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     227 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2175:1: note: in expansion of macro 'SYSCALL_DEFINE3'
    2175 | SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   arch/powerpc/include/asm/syscall_wrapper.h:34:28: error: invalid storage class for function '__do_sys_io_cancel'
      34 |         static inline long __do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))
         |                            ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:227:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     227 | #define SYSCALL_DEFINE3(name, ...) SYSCALL_DEFINEx(3, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2175:1: note: in expansion of macro 'SYSCALL_DEFINE3'
    2175 | SYSCALL_DEFINE3(io_cancel, aio_context_t, ctx_id, struct iocb __user *, iocb,
         | ^~~~~~~~~~~~~~~
   fs/aio.c:2217:13: error: invalid storage class for function 'do_io_getevents'
    2217 | static long do_io_getevents(aio_context_t ctx_id,
         |             ^~~~~~~~~~~~~~~
   arch/powerpc/include/asm/syscall_wrapper.h:21:21: error: invalid storage class for function '__se_sys_io_pgetevents'
      21 |         static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__));             \
         |                     ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:230:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     230 | #define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2275:1: note: in expansion of macro 'SYSCALL_DEFINE6'
    2275 | SYSCALL_DEFINE6(io_pgetevents,
         | ^~~~~~~~~~~~~~~
   arch/powerpc/include/asm/syscall_wrapper.h:22:28: error: invalid storage class for function '__do_sys_io_pgetevents'
      22 |         static inline long __do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));      \
         |                            ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:230:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     230 | #define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2275:1: note: in expansion of macro 'SYSCALL_DEFINE6'
    2275 | SYSCALL_DEFINE6(io_pgetevents,
         | ^~~~~~~~~~~~~~~
   arch/powerpc/include/asm/syscall_wrapper.h:23:14: error: static declaration of 'sys_io_pgetevents' follows non-static declaration
      23 |         long sys##name(const struct pt_regs *regs)                      \
         |              ^~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:230:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     230 | #define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2275:1: note: in expansion of macro 'SYSCALL_DEFINE6'
    2275 | SYSCALL_DEFINE6(io_pgetevents,
         | ^~~~~~~~~~~~~~~
   arch/powerpc/include/asm/syscall_wrapper.h:19:14: note: previous declaration of 'sys_io_pgetevents' with type 'long int(const struct pt_regs *)'
      19 |         long sys##name(const struct pt_regs *regs);                     \
         |              ^~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:230:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     230 | #define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2275:1: note: in expansion of macro 'SYSCALL_DEFINE6'
    2275 | SYSCALL_DEFINE6(io_pgetevents,
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function 'sys_io_pgetevents':
   arch/powerpc/include/asm/syscall_wrapper.h:25:24: error: implicit declaration of function '__se_sys_io_pgetevents'; did you mean 'sys_io_pgetevents'? [-Wimplicit-function-declaration]
      25 |                 return __se_sys##name(SC_POWERPC_REGS_TO_ARGS(x,__VA_ARGS__));  \
         |                        ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:230:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     230 | #define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2275:1: note: in expansion of macro 'SYSCALL_DEFINE6'
    2275 | SYSCALL_DEFINE6(io_pgetevents,
         | ^~~~~~~~~~~~~~~
   fs/aio.c: In function 'softleaf_entry_wait_on_locked':
   arch/powerpc/include/asm/syscall_wrapper.h:27:21: error: invalid storage class for function '__se_sys_io_pgetevents'
      27 |         static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__))              \
         |                     ^~~~~~~~
   include/linux/syscalls.h:236:9: note: in expansion of macro '__SYSCALL_DEFINEx'
     236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
         |         ^~~~~~~~~~~~~~~~~
   include/linux/syscalls.h:230:36: note: in expansion of macro 'SYSCALL_DEFINEx'
     230 | #define SYSCALL_DEFINE6(name, ...) SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
         |                                    ^~~~~~~~~~~~~~~
   fs/aio.c:2275:1: note: in expansion of macro 'SYSCALL_DEFINE6'
    2275 | SYSCALL_DEFINE6(io_pgetevents,
..


vim +49 arch/powerpc/include/asm/pgalloc.h

0186f47e703fb7 Kumar Gala                     2008-11-19   6  
de3b87611dd1f3 Balbir Singh                   2017-05-02   7  #ifndef MODULE
de3b87611dd1f3 Balbir Singh                   2017-05-02  @8  static inline gfp_t pgtable_gfp_flags(struct mm_struct *mm, gfp_t gfp)
de3b87611dd1f3 Balbir Singh                   2017-05-02   9  {
de3b87611dd1f3 Balbir Singh                   2017-05-02 @10  	if (unlikely(mm == &init_mm))
de3b87611dd1f3 Balbir Singh                   2017-05-02  11  		return gfp;
de3b87611dd1f3 Balbir Singh                   2017-05-02  12  	return gfp | __GFP_ACCOUNT;
de3b87611dd1f3 Balbir Singh                   2017-05-02  13  }
de3b87611dd1f3 Balbir Singh                   2017-05-02  14  #else /* !MODULE */
de3b87611dd1f3 Balbir Singh                   2017-05-02  15  static inline gfp_t pgtable_gfp_flags(struct mm_struct *mm, gfp_t gfp)
de3b87611dd1f3 Balbir Singh                   2017-05-02  16  {
de3b87611dd1f3 Balbir Singh                   2017-05-02  17  	return gfp | __GFP_ACCOUNT;
de3b87611dd1f3 Balbir Singh                   2017-05-02  18  }
de3b87611dd1f3 Balbir Singh                   2017-05-02  19  #endif /* MODULE */
de3b87611dd1f3 Balbir Singh                   2017-05-02  20  
75f296d93bcebc Levin, Alexander (Sasha Levin  2017-11-15  21) #define PGALLOC_GFP (GFP_KERNEL | __GFP_ZERO)
5b6c133e080100 Michael Ellerman               2017-08-15  22  
dc096864ba784c Christophe Leroy               2019-04-26  23  pte_t *pte_fragment_alloc(struct mm_struct *mm, int kernel);
dc096864ba784c Christophe Leroy               2019-04-26  24  
dc096864ba784c Christophe Leroy               2019-04-26 @25  static inline pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
dc096864ba784c Christophe Leroy               2019-04-26  26  {
dc096864ba784c Christophe Leroy               2019-04-26  27  	return (pte_t *)pte_fragment_alloc(mm, 1);
dc096864ba784c Christophe Leroy               2019-04-26  28  }
dc096864ba784c Christophe Leroy               2019-04-26  29  
dc096864ba784c Christophe Leroy               2019-04-26 @30  static inline pgtable_t pte_alloc_one(struct mm_struct *mm)
dc096864ba784c Christophe Leroy               2019-04-26  31  {
dc096864ba784c Christophe Leroy               2019-04-26  32  	return (pgtable_t)pte_fragment_alloc(mm, 0);
dc096864ba784c Christophe Leroy               2019-04-26  33  }
dc096864ba784c Christophe Leroy               2019-04-26  34  
dc096864ba784c Christophe Leroy               2019-04-26  35  void pte_frag_destroy(void *pte_frag);
dc096864ba784c Christophe Leroy               2019-04-26  36  void pte_fragment_free(unsigned long *table, int kernel);
dc096864ba784c Christophe Leroy               2019-04-26  37  
dc096864ba784c Christophe Leroy               2019-04-26 @38  static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
dc096864ba784c Christophe Leroy               2019-04-26  39  {
dc096864ba784c Christophe Leroy               2019-04-26  40  	pte_fragment_free((unsigned long *)pte, 1);
dc096864ba784c Christophe Leroy               2019-04-26  41  }
dc096864ba784c Christophe Leroy               2019-04-26  42  
dc096864ba784c Christophe Leroy               2019-04-26 @43  static inline void pte_free(struct mm_struct *mm, pgtable_t ptepage)
dc096864ba784c Christophe Leroy               2019-04-26  44  {
dc096864ba784c Christophe Leroy               2019-04-26  45  	pte_fragment_free((unsigned long *)ptepage, 0);
dc096864ba784c Christophe Leroy               2019-04-26  46  }
dc096864ba784c Christophe Leroy               2019-04-26  47  
32cc0b7c9d508e Hugh Dickins                   2023-07-11  48  /* arch use pte_free_defer() implementation in arch/powerpc/mm/pgtable-frag.c */
32cc0b7c9d508e Hugh Dickins                   2023-07-11 @49  #define pte_free_defer pte_free_defer
32cc0b7c9d508e Hugh Dickins                   2023-07-11  50  void pte_free_defer(struct mm_struct *mm, pgtable_t pgtable);
32cc0b7c9d508e Hugh Dickins                   2023-07-11  51  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

