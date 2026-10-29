Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22D4B606A329
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 08:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=J3y0rnz9
Received: by kanga.kvack.org (Postfix)
	id 4159C6B05B3; Thu, 29 Oct 2026 04:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ED5E6B05B4; Thu, 29 Oct 2026 04:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3035D6B05B5; Thu, 29 Oct 2026 04:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 044196B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:44:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D186C02FF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:44:38 +0000 (UTC)
X-FDA: 85375027836.01.D3D0F17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id CF27B140003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:44:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=J3y0rnz9;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793263476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/oWraMZQPV6fMMEjMwIgrElFPlULY+ClRBpUMakebME=;
	b=3XenLGEpaIscxLt+GQIng5tNBwQ8H96LEJL4l88Eodh4vkRIBhQnV+0p4q/+KFzN2sp6fh
	30c3GkuBiwAmoHKXPT+bfo2hnFAp6vn/2vzlqQrR5pPtotnBDJ23q3zBjuS5Go4zoqyzZU
	/1Bpp8ystlVlkFiBQ5M5oP6J5XLPKPs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=J3y0rnz9;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793263476;
	b=xYNdebk4juQXtDQmcPG1iriTFpiZHmFuMNs7jSPN1zn4CR7FBtYG3ZYkuy/oj5wEmnN4uI
	KU0v2jz1xiCcze1+eG3RYnr1ylUVcaLr84bjDMxhAqFX2QWs3ojqvzQoQfccnkbiaJ9K57
	bF5x/d7sR69oOpJTbFr2VtUWf9eWga8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793263476; x=1824799476;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zP6j9o6F/w03axY+MsD6UxM7gNTFpqrQ1pytm/sRx+k=;
  b=J3y0rnz9a6rOWxHPMQbDgpynCboUEiQ7qYn4JP5p3tq7LQRTflylYpUU
   CHE8DyQ8eDuZH7zXoSvYbG06br0KtqTYhzlrNDvmcE3pzWszIR0XQl1mv
   XTmCWBfsLOmfeJndHJLLv7gk6GFwQoepsg+4IQ9B+eTbSeoLAg+YsHwov
   aaL0iqMf01U6YdBoijUY0HMi9R8TJyTOoQ4vn2xdwyWxm43NKGT5vC4xG
   T+pgFj1lxsetgqc57jYe/Y+YoszD4sIhMK/DOn6YlcefB0itdi8p9NfOI
   YyyMV1j8B12sRTggOmmvXUbSyOIrPRJYtjEdeNO5N+VftF1K2CBa7pXsy
   g==;
X-CSE-ConnectionGUID: Y9xreuPsSfudhXVeOu1+VA==
X-CSE-MsgGUID: z2YqpXKsSaiktiSCxp5z3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11949"; a="1883090"
X-IronPort-AV: E=Sophos;i="6.27,184,1787036400"; 
   d="scan'208";a="1883090"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 01:44:34 -0700
X-CSE-ConnectionGUID: 4rCsOan0TAGSv25eri71LQ==
X-CSE-MsgGUID: rzUW03PeSzOCgCTooWn4jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,184,1787036400"; 
   d="scan'208";a="4986244"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 29 Oct 2026 01:44:31 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMLkK-00000000Zqq-0ZYA;
	Thu, 29 Oct 2026 08:44:28 +0000
Date: Thu, 29 Oct 2026 16:43:48 +0800
From: kernel test robot <lkp@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	David Howells <dhowells@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, keyrings@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v3 5/6] KEYS: Replace assoc_array with rhashtable
Message-ID: <202610291634.MckYHsJq-lkp@intel.com>
References: <20261025001105.1824178-6-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261025001105.1824178-6-jarkko@kernel.org>
X-Rspamd-Queue-Id: CF27B140003
X-Stat-Signature: qxw8wfkn9pf395kdtmboe6kw8gbafkej
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793263475-817841
X-HE-Meta: U2FsdGVkX1/FO6Xjopo8HEfNahB/VCay8pEpaQAMDAZ/Z1C2+cyLjHiPo95zKcJ5QDD3OSRAUUgAxGKSV+W0W/z4gS6ONxYWPvHXwJTqrsaTG/ZQZd05afQKAVtEJZnWyGdgmOj5OxtQyq9kTatoBqLWXzy7BtgD8LUyvtv9VI64IMFfdFrEk5XKNxPPvHfwaFc/5rOCylCSDZXagDc7p+2CaTJcCMHlY7wqOUvCEvOJoDHoSlZBxEUMKZv4G1yysqdxAmvgfQflsXo4IAno6a157W6HrLcU82LgDeAvv1pqTjZkmgEjtpW9ibJYfXTRXPCIkZoujBmC/9HU6fTX8NBaIxPHVaOL56020s2RXaInKyvbZYI/8JdTPwHFuYRkwrDlm25hoDghH1wMU0J9A2JfBfhqAW4CAkaBxwp5dc79hACXxRzSxuZjGbm5Mhl6KpuY3RU2PZ/nt5KgBfb/pnBVf69OshcCIfbShwXJWLvwWgo8kONNcMcuqtVmmnxA3nkOWULRlLMfR/YY3ZVW+ry/Xm5xnNfborqECRORRV4Q20BN5vAYmVikcNE9tbsnBMdjoe5873zpIezT01fiXDs/L27dYerWUVsr2kcTUrTAQH0lnCzOm+enwd0jhcMTA3vN44FsQqt5x6wznUsEiWNAt6BgE2qyiFrAeWZm6f6V3A6PdLXsE6TVro/uvstX3v8EQgqK4nreGTUdeFjkad9PVnotLVCq/W6WlhcOL4lnMKje/Tf3pSCPk2YkQUZ/dTQeJ4nIYtuhlxn4FnFf2QrG7dyyG0BcRfjJfW0+6mZz55fuCEBzisOBpeiVOYXoEKeaZOW6lo0bnl7TKZRq2rhvrNMwOQwz5WGij2cMee9GlKtxSFZ1SJX4/uB71uv+CuwjrisZ61oGgdhdzR+Q100DwoWrj7g5141Pqusjx93FJcbWzaclXbYGhBgVz0SNj9/Y/4EG1U3fBcRfNn2
 h1e0RWCo
 9Km5+nhtTUTJVx9wMk6acNUza4SfpQyzg9CYYKkJl6f6B+jNwVac+94jpe1wmQEE824dsf7NBiN77KmJ9vUABSY7Wn7FBNKtoFHauJKGi87DVtscTvJo74iZXl8pY2zsSV9ofYv+1WuRWADLnig26Zlt55yo/qvNXzQyksTMQXIa4yyRBzPpSdSGdhS9EaMCyjS1F2HeN9flBaJCj3z4j03LyYUPlGMO/VF66aK21t85p5gjrsyaGVa9WT8db4R+7ZLsIFT5a5KpwQBISFR+ZHEDScZ8vwViQW7KMueJZs66CCzQVz6kMdGeLO5HJaPXT/+5myarR91Q5IflbS3q6QlzLnlnDnVy1wRX4nfoLnB5BuSDAqkM+dY0wKK/YvAqlUQFgHZ7hWvuRJxWSHzmH+rdL7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Jarkko,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[cannot apply to akpm-mm/mm-nonmm-unstable manguebit/cifs-next manguebit/cifs-fixes device-mapper-dm/for-next fsverity/for-next fsverity/for-current shuah-kselftest/next shuah-kselftest/fixes dhowells-fs/fscache-next dhowells-fs/keys-next v7.3 next-20261028]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jarkko-Sakkinen/KEYS-Expand-key-datalen-quotalen-to-unsigned-int/20261025-031009
base:   linus/master
patch link:    https://lore.kernel.org/r/20261025001105.1824178-6-jarkko%40kernel.org
patch subject: [PATCH v3 5/6] KEYS: Replace assoc_array with rhashtable
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20261029/202610291634.MckYHsJq-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261029/202610291634.MckYHsJq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610291634.MckYHsJq-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   kernel/bpf/keys.c: In function 'bpf_lookup_keyring':
>> kernel/bpf/keys.c:32:35: error: 'struct key' has no member named 'keys'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                                   ^~
   include/linux/compiler_types.h:682:23: note: in definition of macro '__compiletime_assert'
     682 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/keys.c:32:14: note: in expansion of macro 'READ_ONCE'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |              ^~~~~~~~~
>> kernel/bpf/keys.c:32:35: error: 'struct key' has no member named 'keys'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                                   ^~
   include/linux/compiler_types.h:682:23: note: in definition of macro '__compiletime_assert'
     682 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/keys.c:32:14: note: in expansion of macro 'READ_ONCE'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |              ^~~~~~~~~
>> kernel/bpf/keys.c:32:35: error: 'struct key' has no member named 'keys'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                                   ^~
   include/linux/compiler_types.h:682:23: note: in definition of macro '__compiletime_assert'
     682 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/keys.c:32:14: note: in expansion of macro 'READ_ONCE'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |              ^~~~~~~~~
>> kernel/bpf/keys.c:32:35: error: 'struct key' has no member named 'keys'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                                   ^~
   include/linux/compiler_types.h:682:23: note: in definition of macro '__compiletime_assert'
     682 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/keys.c:32:14: note: in expansion of macro 'READ_ONCE'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |              ^~~~~~~~~
>> kernel/bpf/keys.c:32:35: error: 'struct key' has no member named 'keys'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                                   ^~
   include/linux/compiler_types.h:682:23: note: in definition of macro '__compiletime_assert'
     682 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/bpf/keys.c:32:14: note: in expansion of macro 'READ_ONCE'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |              ^~~~~~~~~
>> kernel/bpf/keys.c:32:35: error: 'struct key' has no member named 'keys'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                                   ^~
   include/linux/compiler_types.h:635:53: note: in definition of macro '__unqual_scalar_typeof'
     635 | #define __unqual_scalar_typeof(x) __typeof_unqual__(x)
         |                                                     ^
   include/asm-generic/rwonce.h:50:9: note: in expansion of macro '__READ_ONCE'
      50 |         __READ_ONCE(x);                                                 \
         |         ^~~~~~~~~~~
   kernel/bpf/keys.c:32:14: note: in expansion of macro 'READ_ONCE'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |              ^~~~~~~~~
   In file included from ./arch/x86/include/generated/asm/rwonce.h:1,
                    from include/linux/compiler.h:391,
                    from include/uapi/linux/filter.h:9,
                    from include/linux/bpf.h:8,
                    from kernel/bpf/keys.c:4:
>> kernel/bpf/keys.c:32:35: error: 'struct key' has no member named 'keys'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                                   ^~
   include/asm-generic/rwonce.h:44:73: note: in definition of macro '__READ_ONCE'
      44 | #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
         |                                                                         ^
   kernel/bpf/keys.c:32:14: note: in expansion of macro 'READ_ONCE'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |              ^~~~~~~~~


vim +32 kernel/bpf/keys.c

abaa0835b4f3810 Daniel Borkmann 2026-08-28  25  
264d8fd2794fabe Daniel Borkmann 2026-08-28  26  struct bpf_key *bpf_lookup_keyring(void)
264d8fd2794fabe Daniel Borkmann 2026-08-28  27  {
264d8fd2794fabe Daniel Borkmann 2026-08-28  28  	struct bpf_key *bkey;
264d8fd2794fabe Daniel Borkmann 2026-08-28  29  
264d8fd2794fabe Daniel Borkmann 2026-08-28  30  	if (!bpf_keyring)
264d8fd2794fabe Daniel Borkmann 2026-08-28  31  		return NULL;
264d8fd2794fabe Daniel Borkmann 2026-08-28 @32  	if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
264d8fd2794fabe Daniel Borkmann 2026-08-28  33  	    !READ_ONCE(bpf_keyring->restrict_link))
264d8fd2794fabe Daniel Borkmann 2026-08-28  34  		return NULL;
264d8fd2794fabe Daniel Borkmann 2026-08-28  35  
264d8fd2794fabe Daniel Borkmann 2026-08-28  36  	bkey = kmalloc_obj(*bkey);
264d8fd2794fabe Daniel Borkmann 2026-08-28  37  	if (!bkey)
264d8fd2794fabe Daniel Borkmann 2026-08-28  38  		return NULL;
264d8fd2794fabe Daniel Borkmann 2026-08-28  39  
264d8fd2794fabe Daniel Borkmann 2026-08-28  40  	bkey->key = bpf_keyring;
264d8fd2794fabe Daniel Borkmann 2026-08-28  41  	bkey->has_ref = false;
264d8fd2794fabe Daniel Borkmann 2026-08-28  42  	return bkey;
264d8fd2794fabe Daniel Borkmann 2026-08-28  43  }
264d8fd2794fabe Daniel Borkmann 2026-08-28  44  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

