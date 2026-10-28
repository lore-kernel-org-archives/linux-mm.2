Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D87606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A8SiLvNr
Received: by kanga.kvack.org (Postfix)
	id 664436B05B4; Wed, 28 Oct 2026 16:13:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EDFC6B05B5; Wed, 28 Oct 2026 16:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B6216B05B6; Wed, 28 Oct 2026 16:13:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 265456B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:13:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A34EE1A01FD
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:13:49 +0000 (UTC)
X-FDA: 85373135778.28.AEE886F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1C7CC160002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:13:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A8SiLvNr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcNCn3o5PHSz7rHDpFBcCfTyitECJ4mMk4mDBTECIc0=;
	b=s3TeDih9Q+UjpA71pIRM04pZPgA4kt+6f4FjHXUebeWXtX2A1rGgze1U3nMV/00JPtND+f
	heWhUnAyH5EwskVEMaeTKYXXNDlfQlURL4cXYeIBJYtJOrkpwnsufbjwRPJNz4mkz5SilM
	XH/lB0xn+OhG+OMDHuHhQYURy9GecwE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A8SiLvNr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218428;
	b=k+Csmnm48ip2fBalLbFm/x2FXIxnyXc8jLdinwNufdds7TGbyxWyYR8ikta4AqrUUpaVF5
	C6jzLIk16fq5mDiS2WCTFpv5v7K4dQQ1qacvnU6BEveCya0HGf2hF6l50meocQAMw/sMAQ
	E2uUjIfGCEpDZzlBlA8YAB5tUG+Ktyo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 18A1C60202;
	Wed, 28 Oct 2026 20:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4688F1F01829;
	Wed, 28 Oct 2026 20:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218426;
	bh=qcNCn3o5PHSz7rHDpFBcCfTyitECJ4mMk4mDBTECIc0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A8SiLvNroTPllgxM7/NlCUN5LPANqhn6UynTAq5ihgbboZkFux6BhBkTBjZm3crr9
	 dZxaHxev/vlaupaACgdv834naSVYBkUmjwfsPLlSW08KoweT/hCn2jJhlFEBBoQp0n
	 ThnwIDRbeospa50sgUHEaLYo5TdohXooPlJll8bGcGX5NMPkLTkwVsUvTplrrSbSTR
	 wFSVjQvIZRMzBWSBYAgQARXpltti5u6bQnimxtIRnQ9pmDCxDHDGY4qvncj2r0M5iP
	 Wy5oqGXTFGtNUiHCP+3VArt+FptWgWlWI612t6R2PoKF6VYZYkHx5SU177/bobDWkp
	 JXow5JGpoMKZQ==
Date: Wed, 28 Oct 2026 22:13:43 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: David Howells <dhowells@redhat.com>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev, keyrings@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v3 5/6] KEYS: Replace assoc_array with rhashtable
Message-ID: <auJXd718ys6ZaTHj@kernel.org>
References: <20261025001105.1824178-6-jarkko@kernel.org>
 <202610281546.OMDCubFW-lkp@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202610281546.OMDCubFW-lkp@intel.com>
X-Rspamd-Queue-Id: 1C7CC160002
X-Stat-Signature: j4f8et6b4i7s3hh4gw81qqbtkdk5fk6o
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793218427-223541
X-HE-Meta: U2FsdGVkX188i+vLKZnBZeybN85rIIbhP0LbKKHheJKVLsOWjw8Qynt+ObiviQEX4GFAj9m7dhJDBn/3R98WZlY8x78zELmC5nxxiyPv9ZizZhNSdSksCsfVbI2xacw5qs3FR/411dOoCyp/Lf6ZjmzCxaHAojAmAaSlx7mJECw5IJ5nPu64aXQHIa6ZuEiCixnWx8vn1liVGkuoJA+3aRg7ho/BvVBlzj6r0Sy7rimhUdKI4zPaKzU+Y2rdTjt2Kk/4kcZNAMG3jc2YMbd+CemcmY7Zwj9yg3FqX3bOwBVdnorthngESiSUhI6UKEsGmMSoGpX2BELfvJ3GK3wnWehCSZzZbzo4oAwPTM2Amkpy2UM1W5rLkntBT//6yW0SN/6pskoWYB5NdURS+HAWZQQDgpproXhiUwrVqrqTrCTmnb+Tw4sVYzuuDXrOmK1+hPaEDIAqJ1mrm70YjwG1ma/p8ITjBflrptBSHyOeIiDbzd3e8gS0I0G/5ALmS/DIp0q6Lpo8u1Q5tnf9bR8oJF8qd0EsSZoSHH8DXuxMrvwWoxgek+osQ0GeGbckPeCXe/U2ygrz5sYit9xWzwvuVSFRLQVxULZy0cy7Iksd/h+HhsVxLhJV5JyMcxaqv7av62QZPytU0d93x3Z/KSrOkCW5TFpx9oQq0uRMk8wq9H9QiFBNCyhmxSDpvjglS6eC+Zd0HXXtziUxukZCaqtQmwQMo+il49kA1LcuIDZYsW5swfKlr9h/Q9+mltXNpueaPfBGzGi/lZwp/3E91wJOCJuwmX1WQiqv7+vmAGjjdC/N55Kf7j7U+inn/VeoYfiEDH+H9wUScPUV+bzctoOLWA/nrfm864RWxn1ux/SRnZTtSJeSSzyrE7LeozWST9XrLcSxJGIj2t3L3Lggif47HMABSpH0fBxr6sGbgjI+Vxzf2pu+irZ5e2ApQwzICYciyhvbmyXJn0HYCuQ6Zf0
 lqn8ftv9
 d/UhI2lGfzzPJnrX7auX/XtKntNPBBwuzqfwg/hRnD1lJJsPy0y+alX04pGt1y8JGT43xpvM0yzB+nDbT9yKbdVjndkrPXe0kMDm6Pc5J7gFrSLEexNM3v7ukfbkiaVcGkU1JtoIJpKLnCTwRc599v5NgGh0+7xsei4URGomyIHda8IiDmW6DKuwQ5pMnVGLZNlFBCZIINMK/lhXmyEsQ7gukZitssMQNhLO4yKhgOC9XOK2LeqgufpiHraeZwK+yYZGY9EOSUcZrMkR/H40Zj7ahCHYfzyvkpJgtHKgOvgW01jlM66wGP32yPqy9seLzql0nb8Wo+0Pb8/g3RyN6yUsPaqNLuzTZUNCODMU2wVZ+lrdm7lHVsnHLVx5It40SL11eiSpNiepbckkVAfYSrmDh48cl1QTu2Ksq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 03:28:38PM +0800, kernel test robot wrote:
> Hi Jarkko,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on linus/master]
> [cannot apply to akpm-mm/mm-nonmm-unstable manguebit/cifs-next manguebit/cifs-fixes device-mapper-dm/for-next fsverity/for-next fsverity/for-current shuah-kselftest/next shuah-kselftest/fixes dhowells-fs/fscache-next dhowells-fs/keys-next v7.3 next-20261027]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Jarkko-Sakkinen/KEYS-Expand-key-datalen-quotalen-to-unsigned-int/20261025-031009
> base:   linus/master
> patch link:    https://lore.kernel.org/r/20261025001105.1824178-6-jarkko%40kernel.org
> patch subject: [PATCH v3 5/6] KEYS: Replace assoc_array with rhashtable
> config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20261028/202610281546.OMDCubFW-lkp@intel.com/config)
> compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 186e70f4e6a1521991d2340d3d49b23b1beff11f)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261028/202610281546.OMDCubFW-lkp@intel.com/reproduce)

This is expected as at the time when I sent the patch set I did not have 
BPF changes yet.

Br, Jarkko

