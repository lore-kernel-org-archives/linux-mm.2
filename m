Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB57F606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 07:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kbqBtDtg
Received: by kanga.kvack.org (Postfix)
	id E9F5B6B05B3; Wed, 28 Oct 2026 03:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4EF36B05B4; Wed, 28 Oct 2026 03:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D65826B05B5; Wed, 28 Oct 2026 03:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B12566B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:39:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF81BC0BDF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:29:10 +0000 (UTC)
X-FDA: 85371208860.19.D4B9653
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf31.hostedemail.com (Postfix) with ESMTP id C31F920008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:29:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kbqBtDtg;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793172548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9gBy32Umx1KK8RH0X7KkA8q7a84CegEqG9LxghN33w=;
	b=EBo9f/Z1KvtNTvuElQQDAerxwA+roZrWCgH05x/VHrZVaVDYtlspKY6Nh4dtpCU0Dhw3PW
	38rUC/+sfrSM8Z/5u9yw60DslwVdAcVhFkG8WAAFRorqpXSCGApA/T50bWtzxhoSio1e1N
	sqIFGOt+HFsdame/zUZkdp2FwjEAZuo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kbqBtDtg;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793172548;
	b=PNnESTr1XLYdvRtLuMFX8i+xg6TPjYI8B1TWHg4VG2pRsvtn3F5hgcIckDPi4aucDypYX/
	avyDWTQy5WRi3aOATZi0lOirIGk/W7kwTUAzzRYScZUMy2XUlCHrf7hnj5/LanSuDY6Udl
	1mHrQv65eYbQH2ZPSyMIa+UC3vUwa7c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793172549; x=1824708549;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3rO83+6ZiPbQh0ra3NNYRzFCPQ7QM/wKotP9MQYg5uU=;
  b=kbqBtDtgcRH3FsKFjUVQ6UelGSrO/Xu3qScD4lm+tNe3e7gvK9VOKaDf
   kjWYd62Ny4gylpF712ybuJH47kDlowReqIsnGieLyDMT+Ld3jVhWf6zNE
   4t1XPQgBJxfkx0pfoVvkvqHoScPPCWoYYEw8QiUxAUkpoRYM9wr35G+q1
   jJSzzexbspYQrvt9BmgQ2PVoIU2zN4Qx9uiM5JD6g2Q+s2nVmCqwq+NsO
   gXm65TgemTAgvB3H8YqW0ATjRXHU8XDgF2+av0j9+xPGB86H1A7HDEEtC
   HIPQqh8ZBvJHg0PUGJTsfcJT5KSqOB/Jj/5OWH2x70A+jlVaT2N4Jci2K
   g==;
X-CSE-ConnectionGUID: FceI7vw7TXKjqG8YIz81Cg==
X-CSE-MsgGUID: PrARKlg0SPSNf06MkVqOWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11948"; a="1767481"
X-IronPort-AV: E=Sophos;i="6.27,182,1787036400"; 
   d="scan'208";a="1767481"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2026 00:29:07 -0700
X-CSE-ConnectionGUID: pJBqjxOOQdeCRpcIm+CX0Q==
X-CSE-MsgGUID: /B5GbNDIRyy+HTbdg+QbCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,182,1787036400"; 
   d="scan'208";a="4847384"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 28 Oct 2026 00:29:04 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xLy5k-00000000YRI-1vsi;
	Wed, 28 Oct 2026 07:29:00 +0000
Date: Wed, 28 Oct 2026 15:28:38 +0800
From: kernel test robot <lkp@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	David Howells <dhowells@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	keyrings@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v3 5/6] KEYS: Replace assoc_array with rhashtable
Message-ID: <202610281546.OMDCubFW-lkp@intel.com>
References: <20261025001105.1824178-6-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261025001105.1824178-6-jarkko@kernel.org>
X-Rspamd-Queue-Id: C31F920008
X-Stat-Signature: 6bfp11zesei4t5z3zfakorqcxw51yscx
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793172548-270740
X-HE-Meta: U2FsdGVkX19c4GM4EdD6Gax8nZiqGz8zYD8KXQcFgDrqktsrIL2zVEQchjM+BSQSXHbNGpnJb7N0IXH1UDhpCBSyvZxhPDbvlPP1bZpIOnC+mr0YtITy111VdayIpQq70QN4CRRZlT5mo9edASxiIXwunIFujMSGnePVcZlRw9om6J7j3+tPfRAdGqBegJ4cNUiUUTix9NTXcVFuWfXfKSfzGUsgEqOk5HHF8a5BHHwkxefjPYqZ8v919hbDGYtFbgKu8CT4qP04fmPy9T/tDturqm3/UfwNAUKankN03gnuCeA3bYDU14jADprzWd8CVYaMPM7MEH8zlncjF/Ex3CsMOZM4xFT1sDG8ncZZK6DUe8SYhXfDC489LOU2rokjYxala1LEZlwMlE1YpNrgm8BgIh0lBzB0/PxSid/jF5ahw/5AnOG5KfEy1n5sAjkW4xK9hIBD6lZ9KWVxKXvldrRUzQUslxn33/gx+cKmIBDsFNyB6UsbPQZ1UfGP66ykAKi3wmmBbT8HoFfMy1LAXwNu5V1WvFOvE1W68peb5Y/Fj7lxbGGg78yTbSdpEwRhtyCIGTs0jVCPg5oKBkC0ncq0SpibdeL5JO3sSyO0dF7Sqc2VVgquNYi70cx1JmkqfO3/4Gb0qVOfhPIFJ/H+Gb2VosjvGhnc3GDjvIqohMBTo63zpWCVTBkhQ2iITc6FVdquYyjRdNEjKIRA8/lY4SO+K9f6DS9cScUpSZevJV1Wbqj9D4P+ycqRU4tSZn33+OdvUzV/j7ekpw6x/5jKGLgG9hBY8AzWBpnAOal2CCllKDsfWoJYX8ky2Y3095TputyobQNRxem36mOBpGufVye5Qb7HuOTC1fbThbbKvoufQ5tiouupVdB73PcQK2c5qw8lA1AGFfei0gLzdtG2csqUepioTM11XcZGCefDFpfzQc+84pPANMyMWYNwUOkGS122lu8dEJQstE1gmkf
 wU78NnQn
 yWs7QEEq6SEsGPH3TRGeswS808RVLGRzKdSmxocjZex3z7K2AizX2NEfMczadYDXR0O5ph7DwAtqo0WRO9y+NlyX1ei1Uv3ck3l3JIwL+LBTPbCTnhDNYouh8JYxoiENWV0VIjsvAWo6rcPZHXqAM2OJLAXnqY/nBtDoDl2Ved1rnz3zhmo+LrjksLgc6nVoMwYbx/MhS0lnZZC7JS73jCg9pIjiLs2teFTnED4KNtfz14ro6afRoSt7dd/7ZuBE+31v0ZYc4VL958wQE1ifyoXVGlZHzQ2Z6vkL1DVfTOr0p3KoaSSecgHC1I8KXPjmHlB+xgGU5hOHssLESLszyNXI1mVm/+AV6huGMdi911OjkKoM+0uxEGkW+G3HuIZXejnMDUs5oWDrpG6zA7cSEkVVwKw==
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
[cannot apply to akpm-mm/mm-nonmm-unstable manguebit/cifs-next manguebit/cifs-fixes device-mapper-dm/for-next fsverity/for-next fsverity/for-current shuah-kselftest/next shuah-kselftest/fixes dhowells-fs/fscache-next dhowells-fs/keys-next v7.3 next-20261027]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jarkko-Sakkinen/KEYS-Expand-key-datalen-quotalen-to-unsigned-int/20261025-031009
base:   linus/master
patch link:    https://lore.kernel.org/r/20261025001105.1824178-6-jarkko%40kernel.org
patch subject: [PATCH v3 5/6] KEYS: Replace assoc_array with rhashtable
config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20261028/202610281546.OMDCubFW-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 186e70f4e6a1521991d2340d3d49b23b1beff11f)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261028/202610281546.OMDCubFW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610281546.OMDCubFW-lkp@intel.com/

All errors (new ones prefixed by >>):

>> kernel/bpf/keys.c:32:30: error: no member named 'keys' in 'struct key'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                        ~~~~~~~~~~~  ^
>> kernel/bpf/keys.c:32:30: error: no member named 'keys' in 'struct key'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                        ~~~~~~~~~~~  ^
>> kernel/bpf/keys.c:32:30: error: no member named 'keys' in 'struct key'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                        ~~~~~~~~~~~  ^
>> kernel/bpf/keys.c:32:30: error: no member named 'keys' in 'struct key'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                        ~~~~~~~~~~~  ^
>> kernel/bpf/keys.c:32:30: error: no member named 'keys' in 'struct key'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                        ~~~~~~~~~~~  ^
>> kernel/bpf/keys.c:32:30: error: no member named 'keys' in 'struct key'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                        ~~~~~~~~~~~  ^
>> kernel/bpf/keys.c:32:30: error: no member named 'keys' in 'struct key'
      32 |         if (!READ_ONCE(bpf_keyring->keys.nr_leaves_on_tree) ||
         |                        ~~~~~~~~~~~  ^
   7 errors generated.


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

