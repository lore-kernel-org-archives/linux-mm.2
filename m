Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B82FEE4C6
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 05:34:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34966B0005; Sat, 28 Feb 2026 00:34:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0CE46B0088; Sat, 28 Feb 2026 00:34:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B286B0089; Sat, 28 Feb 2026 00:34:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB9486B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 00:34:35 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46C8F1A0AFE
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 05:34:35 +0000 (UTC)
X-FDA: 84492750510.08.C1C16CC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf11.hostedemail.com (Postfix) with ESMTP id C28A140003
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 05:34:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nRjQ8Z2K;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772256873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTZoJlWhljTrhR4AXGt+5N4JDrDXqEc4xHbVb0aNdLE=;
	b=1VqBcoOVJ5/SuqS4CsjwBQZP6pp0gHAUncdiOVJP0R+eC85/1F/pwfig5mrA7Xzz+zJQxI
	y867mr4l98SQqMbdY8SBPsImHxI92yPKTJmK59h8QgMWHuPjnjkW4fO5CvvNf3PnUljXrj
	MuefY7r8rYB3gUo5TxAUH4Px1emwaEU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772256873; a=rsa-sha256;
	cv=none;
	b=kS3C16c6sFRrp9kKvhYfbxdjVWXRmMe/4qPwkhu5yxCBCkiQ9w0ca+3s1XSOZXj7O3iL0Z
	99bay+tjDtRXtUfJNNc5HKOrDxQR1dRNqRfUxeTvy8oU4JQ9kJ3mltR0Csbf4iS9uxr11k
	gVVxURlhzED+P23VlyK/KcY6TTHTTwc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nRjQ8Z2K;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772256873; x=1803792873;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sTo7ttKxW4qkAJ7gPSFGQddJdAolYP33nHR3bLxdvBI=;
  b=nRjQ8Z2K520fVcrW42seNzYGRxGBgb0/LIxlUvN0FlSsV4VvNiCSx+/6
   spRDGWZY/0gjSuiGVevRyRvBHRBBNz3cIQ2Gs1u2nazUKShWWypx+5ZbA
   VN/lTNGqHZOJAbd7fVRwXWumExu8PnDKqTWUKn2+wPirhoMNaUE4x8Pu/
   MfVEshKlWAx+KDOF1rssvbzCcCqK+LDc1zdhBwdSolTP/zt2OCAcjKorQ
   7oM5ApcIQmMD6ignap0m7fCa0e7gqwmWFZYyBBfYdIb18RkQh5OwcqmRE
   MWcCUE1BU0fG17a2aesNsaefqumg1jxJBXdnYAjYJ5A3yYMQK6eWAJwHD
   g==;
X-CSE-ConnectionGUID: 3NRJ1JRlQdusp6QN1vJdsA==
X-CSE-MsgGUID: R3x9mPTaR7mKw89kQs8d5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11714"; a="83675011"
X-IronPort-AV: E=Sophos;i="6.21,315,1763452800"; 
   d="scan'208";a="83675011"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2026 21:34:30 -0800
X-CSE-ConnectionGUID: S5AEptvYTtqF/GCtLPcCFA==
X-CSE-MsgGUID: 9+Qbd53OQ5iLoWIw3O4tNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,315,1763452800"; 
   d="scan'208";a="214881695"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 27 Feb 2026 21:34:25 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vwCy5-00000000BKB-3zAQ;
	Sat, 28 Feb 2026 05:34:21 +0000
Date: Sat, 28 Feb 2026 13:33:38 +0800
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
	linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v2 07/10] security: Hornet LSM
Message-ID: <202602281307.9DVHYnXF-lkp@intel.com>
References: <20260227233930.2418522-8-bboscaccy@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227233930.2418522-8-bboscaccy@linux.microsoft.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C28A140003
X-Stat-Signature: ggdkoz3aoc8fgy7uuan6abyu7jy3b3br
X-Rspam-User: 
X-HE-Tag: 1772256871-994907
X-HE-Meta: U2FsdGVkX1/6Niah0aNj1a1xZP890Aw22UqGj7CJh0ZlVwXXqeGbOJ+2yfUI+FzhM1FoRvO8W/oOUmmswBaSryWPNCh1m8FDUZgfLL6ocaL68dfXqUJGeSBzK4AocwKPVETgaOLqedG5WkkPSdkANxSwzTmMlGYYaO9017XpEvN/ML4jD0/dWQVe13zbc040UlLSQsPWcarQr/Cbn4G94mZNNYGQXbPnqnDmUzvCdNyIGIPJsvisst4EfRVJP20S50GXE3CDlLsGt685geofkk1oPueyTw3GRx0E4Wi3GQlsfKzmTbJJmumwvRGsu/xasilue7BEmH97USInbfnJXMuU8PcPjkwicu/dcm0aRrzK1kjLUtJjq4Tl8Cv5VyvCn4dbFxTNj4Pm0J24QbhqxReA3nQxvapuUx3KNvzDy9ljquH0jnRC0SrOe63onSrS+KaFL1Jy/xf716BGK3oec5I7ZDu9geNu59d5wnc1v/Lw1Kp5jOr7fS95H1W6cHa34mTgNjfo/AWU7M0muEf2dUuOf22otRpco6x1ttP5Or5YBcjhGmmolcYUNFCcKSrOY4K4XyGpgYA/+7oANlhS4j6DIRuow6eS4AC0BZclLjfzsuhsiDZXtvZ0LsnQkCahfhniuVMWWA3RMm4FBW3Kz3KUELxjeaWI/KrCFxyJQzj6RKigJaLVFj/cK5xzA5BPcIJTNWActUxstjkxTiCF3Pzy6QVM85I4j+DXoiiOcZNOc2QrcEcbD+y84gMkwYbV5Gak2Wm3Rb1+7cH8ymSdrzhGqbv1qLvHmmLvwYN1VMevgGx1oJeXcQNnOGCLMh6Z3uaj7yWP2/wdvZ5xNP4RUQE9PXxST6huQkv9S/l3lelYDuCKgN36A6uBpbo6sxUHW9jPQjYZ6Ji4fQA2JoU0nF5hd5dwc6zKettWYsYfwubaIVg7P9zsij6nOnQVZTexNS+Wz1SCT2w9dqdePZ8
 La3DB3EF
 eHXrShJ2Tfrw3/MjfeMYuKkxK67p1ugD53HJ7YqlMsNkDRgC++MPtQeU+B8yx+L9EypqwST85d+CFjDvrhr6k8rpX+KLCWCbeE/4NQYR7cHgF+BFWbrNWOaXqL4Mnjjag8naAVbbrnnadFDajTbjZv/46jXZsW7rTI8FTBd18q0h2+uOLGTM8gWKhHCMEpMZOJc0of2dKpaDBEjM1y7yOcR4dG2gdSImPFl78bpruKys2tgMaG734f+P6tPL/1QUDFaVN1bCmZAl5imvPnVIcYlz3pIDSd7B0FSEJyhd2wRxexbu0tRhOl/kwF9vAMv/qIxncgIIuEITFP3pecFrbAv4jYkEdiQhgLVNnMuLiEiZvJNy9qSFUXFe2Bd2ZkhfDypKehqTnliIfJ681VY228L9Z8+KyUZOg1Nkw31DR1XhY/jP8Vlxk2zTrRzVjdioLoqgb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Blaise,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v7.0-rc1 next-20260227]
[cannot apply to herbert-cryptodev-2.6/master herbert-crypto-2.6/master shuah-kselftest/next shuah-kselftest/fixes]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Blaise-Boscaccy/certs-break-out-pkcs7-check-into-its-own-function/20260228-074528
base:   linus/master
patch link:    https://lore.kernel.org/r/20260227233930.2418522-8-bboscaccy%40linux.microsoft.com
patch subject: [PATCH v2 07/10] security: Hornet LSM
config: csky-randconfig-r071-20260228 (https://download.01.org/0day-ci/archive/20260228/202602281307.9DVHYnXF-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 15.2.0
smatch version: v0.5.0-8994-gd50c5a4c
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260228/202602281307.9DVHYnXF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602281307.9DVHYnXF-lkp@intel.com/

All errors (new ones prefixed by >>):

   security/hornet/hornet_lsm.c: In function 'hornet_check_program':
>> security/hornet/hornet_lsm.c:183:15: error: implicit declaration of function 'verify_pkcs7_signature'; did you mean 'bpf_verify_pkcs7_signature'? [-Wimplicit-function-declaration]
     183 |         err = verify_pkcs7_signature(prog->insnsi, prog->len * sizeof(struct bpf_insn),
         |               ^~~~~~~~~~~~~~~~~~~~~~
         |               bpf_verify_pkcs7_signature
>> security/hornet/hornet_lsm.c:197:13: error: implicit declaration of function 'validate_pkcs7_trust' [-Wimplicit-function-declaration]
     197 |         if (validate_pkcs7_trust(msg, VERIFY_USE_SECONDARY_KEYRING)) {
         |             ^~~~~~~~~~~~~~~~~~~~


vim +183 security/hornet/hornet_lsm.c

   153	
   154	static int hornet_check_program(struct bpf_prog *prog, union bpf_attr *attr,
   155					struct bpf_token *token, bool is_kernel)
   156	{
   157		struct hornet_maps maps = {0};
   158		bpfptr_t usig = make_bpfptr(attr->signature, is_kernel);
   159		struct pkcs7_message *msg;
   160		struct hornet_parse_context *ctx;
   161		void *sig;
   162		int err;
   163		const void *authattrs;
   164		size_t authattrs_len;
   165	
   166		if (!attr->signature)
   167			return LSM_INT_VERDICT_UNSIGNED;
   168	
   169		ctx = kzalloc(sizeof(struct hornet_parse_context), GFP_KERNEL);
   170		if (!ctx)
   171			return -ENOMEM;
   172	
   173		maps.fd_array = make_bpfptr(attr->fd_array, is_kernel);
   174		sig = kzalloc(attr->signature_size, GFP_KERNEL);
   175		if (!sig) {
   176			err = -ENOMEM;
   177			goto out;
   178		}
   179		err = copy_from_bpfptr(sig, usig, attr->signature_size);
   180		if (err != 0)
   181			goto cleanup_sig;
   182	
 > 183		err = verify_pkcs7_signature(prog->insnsi, prog->len * sizeof(struct bpf_insn),
   184					     sig, attr->signature_size, VERIFY_USE_SECONDARY_KEYRING,
   185					     VERIFYING_BPF_SIGNATURE, NULL, NULL);
   186		if (err < 0) {
   187			err = LSM_INT_VERDICT_BADSIG;
   188			goto cleanup_sig;
   189		}
   190	
   191		msg = pkcs7_parse_message(sig, attr->signature_size);
   192		if (IS_ERR(msg)) {
   193			err = LSM_INT_VERDICT_BADSIG;
   194			goto cleanup_sig;
   195		}
   196	
 > 197		if (validate_pkcs7_trust(msg, VERIFY_USE_SECONDARY_KEYRING)) {
   198			err = LSM_INT_VERDICT_PARTIALSIG;
   199			goto cleanup_msg;
   200		}
   201		if (pkcs7_get_authattr(msg, OID_hornet_data,
   202				       &authattrs, &authattrs_len) == -ENODATA) {
   203			err = LSM_INT_VERDICT_PARTIALSIG;
   204			goto cleanup_msg;
   205		}
   206	
   207		err = asn1_ber_decoder(&hornet_decoder, ctx, authattrs, authattrs_len);
   208		if (err < 0 || authattrs == NULL) {
   209			err = LSM_INT_VERDICT_PARTIALSIG;
   210			goto cleanup_msg;
   211		}
   212		err = hornet_verify_hashes(&maps, ctx, prog);
   213	
   214	cleanup_msg:
   215		pkcs7_free_message(msg);
   216	cleanup_sig:
   217		kfree(sig);
   218	out:
   219		kfree(ctx);
   220		return err;
   221	}
   222	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

