Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C32710F3DCA
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 02:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863B26B008C; Fri, 27 Mar 2026 22:55:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE056B0095; Fri, 27 Mar 2026 22:55:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5836B0096; Fri, 27 Mar 2026 22:55:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 556DD6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 22:55:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE5AD1A159F
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:55:56 +0000 (UTC)
X-FDA: 84593957112.24.B16D4E0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9D024A0013
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:55:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FIQ+hw4P;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774666554; a=rsa-sha256;
	cv=none;
	b=QqVmMx84VqznGO6ClI0UPg71nBl3EPn18Nk6YXlxqc7yTyjrBnep2iKS0Ep5iv6n7yN16E
	9ODy6z5UaPAlB6GtEekSY0tJ8pnFww5IYmCSXg3INJcKJ+fyCJLKrcCsK0trU0meTzXpAj
	9Q2+6RikElq4IrTw3sN1LBy4RKTKaoM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FIQ+hw4P;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774666554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wT9/XfxQZW1dh+jGaoK8srC4JVop0FMMFM0yiV//YqE=;
	b=DGbjn0bdPQ7VLogdzRfz1erfWN6FYrevPdqiqwSvXQHXpcJLm3gW8wpeBp3yHsyjyX+Enp
	0gELEcu6e7fLJskpe5urtcSlXGMXE7HrK8Li4ts5XXp5kqGwRl5fSX6+UYTKib+XKx9/bD
	+bt3z42QqIjRvSuZKC4SqG9I0d7JCNY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774666554; x=1806202554;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+nZ4u3MBcRwp9OGWXaCUo2FPTKLyPZrQVTAvSmX15Bk=;
  b=FIQ+hw4PKZiUeAlfYcWDZ7fpCZuKGrMiYOWUJuoUkWaHV+1R8EyarBCk
   De1uyp1vou1mw0I9Pz2XR4zuyFNuWrnyTabEz+zX5PCV6BfcbI4FWDOdM
   fOYa0E3NuDFvUlF24HhLADYTU9FX4q8/KhXNH0Hzgc6UvoED1SdtxhfdB
   00RsoZkxYDe2Rr5o8CAF1CjAz4NZynIWISAQIgwiFMvgqEVULaFqw4KTf
   nA+L4jBjOMeAUE9TlKbicx0uEEIa/Q18XxZce4x/DYp21KNMQhfjEEppO
   cjMKLi5B5VHFVu63GdCfqWGqG0yw8egok9GCAscIrEKCaLE9xqfUCQO+x
   A==;
X-CSE-ConnectionGUID: mScSIkVcT7mAIO/2QzTqCw==
X-CSE-MsgGUID: MOPdrpJeRRyJJiHwmnkr/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75857015"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="75857015"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 19:55:52 -0700
X-CSE-ConnectionGUID: /bKuae7qTwSAoSUlotz+1g==
X-CSE-MsgGUID: peMT7tAZRFGoECNlx4ANoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="224685528"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 27 Mar 2026 19:55:46 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w6Jpv-00000000B0v-1g9H;
	Sat, 28 Mar 2026 02:55:43 +0000
Date: Sat, 28 Mar 2026 10:55:32 +0800
From: kernel test robot <lkp@intel.com>
To: Blaise Boscaccy <bboscaccy@linux.microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>, Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	=?iso-8859-1?Q?G=FCnther?= Noack <gnoack@google.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	James.Bottomley@hansenpartnership.com, dhowells@redhat.com,
	Fan Wu <wufan@kernel.org>, Ryan Foster <foster.ryan.r@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v3 6/9] security: Hornet LSM
Message-ID: <202603281030.AIoqyOy3-lkp@intel.com>
References: <20260326060655.2550595-7-bboscaccy@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326060655.2550595-7-bboscaccy@linux.microsoft.com>
X-Stat-Signature: ike7hiqp7414dwx646tt8b33gd7ju8nz
X-Rspamd-Queue-Id: 9D024A0013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774666553-51369
X-HE-Meta: U2FsdGVkX1+WGFKMokQDA8aqQJQPSDqlnxswPf/qHd7jo9IkSpYc7UIrVLe5mfq+VDX2Zug1y9O5kyU50/aBQdFz+sknAKVLFI9DEh+auZ/cgYK6i+ehPH0ISsWJXmaVbF09XjwZaRn71tBUPgdLEbvmURBvlUxAbIj7iLLkbA0iFst7ot8SB3axYP8/GoaoFdkj1L/ouq3u2RD9J4jIB1/Wj/19uYoG6zGHPT5LmwGwJ5s8m0INdRtWf0nsKMEyFzG6cEtijotYuUdpoaksfCvK6lX1jWFCWQ9MaKrpTMqacVSN4LEG3KooDeKfHiApFJVASS6E+tlO1rJHBBaeSbB0eTf+EvG9dhOTsVsDGD1PvrNV5vJ33ZXSziTh9KQhs5j2JUIgvKohrmtqcZJsB3n64VCLz2UnlBUI9+k21gUJj+mjGf5NQbk29veQZFnOa+nDhi2Y8tqvIj9/zZATsnsuVRHGOaHbssNpdy64Li2QygbirX23aotmB+ICxcS+IWdsjBf5ZgptsSywg52N1I08gTvu4JgaDDal6/vXb+qtd1s0C7CVBG8FwDr3mnhKA+GcG1S0H4Ir8/cMlX6bNGsU6HfYFJrlsUpswb802KrNajeWfsHxwQZouXdMI6i05gmbENGh1uN1M7iHew7zMC7s6iygN3D/M+YLFNqORqfUrr4KLqdlbLgkXKpmXk/3WzC6B5J0s31tHoCdZFMi9sbvVjdBjkwHbSvVTBIi+IG0OZkqRdvrcrItttqgXDSuwQVRkW/y/YFUx0gGXO8HVySiqObiYYzYOTXI97hrPUCPq/lWhVxsdQiFSwcjyMRx9X7+hax81r5vzo1JdKz5d3qyzOTsC9hc27FHrEF5Uk81d503B9h6ogrbLZp4Vo3Ue/SD1WE+EUL6rRu7PpgGV75BeOwiouX7XvizPgx37VZqwAosG7c6dp8YMw+E5j9lHtyAKw46YrUtFWh0ZwC
 jYGkOtAp
 tKg9sSiA7hgpbiccLnes22fO3pjNoSUTNchHXEv7OV5Wr8nL+OfPq06Pkj32atywtozyBPqWcphPBjhZvxYGb0Ex6nYv+lyvC/Q68CGrUGpxecnYNrusteZMpnxsHYamjaAdq6cMZwoYsczcvJy/cMRVTXiUFPsv9OQ+5+9kbBod9RUZh/7OyqPNKcHTn5kRI4xEilxMr8AFPqRoLEcQWK3mnpaC2qAiTnRzbkiqVK8IYByOdEbJciBBP20sL2OoiEFTNUgZ85mD9RwIyyGVCvg436aU9G8TkPu/YU2mZy4Q6gQQeQxZgelCugYyWo0ZqZBAKtew7z3B8F4lp673TznXSOwvn9lujm96gCr0Al5erWUSfUdVDx6x7IBRGql3NmKOW66VLgZLaeNAGZVMdFhohbT5cpSgAaohuNJmMoMux0ZtlSNDuPAI8492txeOEKZJv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Blaise,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master shuah-kselftest/next shuah-kselftest/fixes linus/master v7.0-rc5 next-20260327]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Blaise-Boscaccy/crypto-pkcs7-add-flag-for-validated-trust-on-a-signed-info-block/20260327-145024
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20260326060655.2550595-7-bboscaccy%40linux.microsoft.com
patch subject: [PATCH v3 6/9] security: Hornet LSM
config: x86_64-randconfig-102-20260328 (https://download.01.org/0day-ci/archive/20260328/202603281030.AIoqyOy3-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260328/202603281030.AIoqyOy3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603281030.AIoqyOy3-lkp@intel.com/

All errors (new ones prefixed by >>):

>> security/hornet/hornet_lsm.c:194:6: error: call to undeclared function 'verify_pkcs7_message_sig'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     194 |         if (verify_pkcs7_message_sig(prog->insnsi, prog->len * sizeof(struct bpf_insn), msg,
         |             ^
   1 error generated.


vim +/verify_pkcs7_message_sig +194 security/hornet/hornet_lsm.c

   155	
   156	static int hornet_check_program(struct bpf_prog *prog, union bpf_attr *attr,
   157					struct bpf_token *token, bool is_kernel,
   158					enum lsm_integrity_verdict *verdict)
   159	{
   160		struct hornet_maps maps = {0};
   161		bpfptr_t usig = make_bpfptr(attr->signature, is_kernel);
   162		struct pkcs7_message *msg;
   163		struct hornet_parse_context *ctx;
   164		void *sig;
   165		int err;
   166		const void *authattrs;
   167		size_t authattrs_len;
   168	
   169		if (!attr->signature) {
   170			*verdict = LSM_INT_VERDICT_UNSIGNED;
   171			return 0;
   172		}
   173	
   174		ctx = kzalloc(sizeof(struct hornet_parse_context), GFP_KERNEL);
   175		if (!ctx)
   176			return -ENOMEM;
   177	
   178		maps.fd_array = make_bpfptr(attr->fd_array, is_kernel);
   179		sig = kzalloc(attr->signature_size, GFP_KERNEL);
   180		if (!sig) {
   181			err = -ENOMEM;
   182			goto out;
   183		}
   184		err = copy_from_bpfptr(sig, usig, attr->signature_size);
   185		if (err != 0)
   186			goto cleanup_sig;
   187	
   188		msg = pkcs7_parse_message(sig, attr->signature_size);
   189		if (IS_ERR(msg)) {
   190			err = LSM_INT_VERDICT_BADSIG;
   191			goto cleanup_sig;
   192		}
   193	
 > 194		if (verify_pkcs7_message_sig(prog->insnsi, prog->len * sizeof(struct bpf_insn), msg,
   195					     VERIFY_USE_SECONDARY_KEYRING,
   196					     VERIFYING_BPF_SIGNATURE,
   197					     NULL, NULL)) {
   198			err = LSM_INT_VERDICT_UNKNOWNKEY;
   199			goto cleanup_msg;
   200		}
   201	
   202		if (pkcs7_get_authattr(msg, OID_hornet_data,
   203				       &authattrs, &authattrs_len) == -ENODATA) {
   204			err = LSM_INT_VERDICT_PARTIALSIG;
   205			goto cleanup_msg;
   206		}
   207	
   208		err = asn1_ber_decoder(&hornet_decoder, ctx, authattrs, authattrs_len);
   209		if (err < 0 || authattrs == NULL) {
   210			err = LSM_INT_VERDICT_BADSIG;
   211			goto cleanup_msg;
   212		}
   213	
   214		err = hornet_verify_hashes(&maps, ctx, prog);
   215	
   216	cleanup_msg:
   217		pkcs7_free_message(msg);
   218	cleanup_sig:
   219		kfree(sig);
   220	out:
   221		kfree(ctx);
   222		return err;
   223	}
   224	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

