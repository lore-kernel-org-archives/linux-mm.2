Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16C9CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 05:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95216B0088; Wed,  3 Jun 2026 01:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46426B008A; Wed,  3 Jun 2026 01:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5BF86B008C; Wed,  3 Jun 2026 01:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A31286B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 01:53:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2DCCE14024B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:53:57 +0000 (UTC)
X-FDA: 84837535314.06.E033B8E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 86ADC8000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:53:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="V5L430g/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780466035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrUERsE4E6cHjoWVt2xzxPe3w/lcberc5ceNmu1nan0=;
	b=JjMwvVh6ZctXA4SLRGbhpJE5g8faI7oxRoBcI/uv1sotokP9RF2y5I545EtwzPenc8Ul4h
	joiu4FXdwd4VLJ5uPOS8IvH7ponsz2BdY4Ot94Sd/r1GWg4PvJiiP7ElpTQrjnRqQS6n8D
	RBnBXhQvOD/CDhu2EEzOXsZgRIYuEsM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="V5L430g/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780466035;
	b=WizhVAxi0tcLKRZzgaLevAbeT6ufNkfj6rI/GCPfdDwnNzOo8c/GmuWSHc9+6TzqZRFzfH
	Z8fDyGc2MD76YcElVOQToD8FPsTAxolpkGXkQ41MiYxv4ySHqeSf50gHFY0R48iy7oTfwU
	Oc2Am5+P9ZKvHsttX1Fr63ycuEYoUjs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B65DA41E40;
	Wed,  3 Jun 2026 05:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25C11F00893;
	Wed,  3 Jun 2026 05:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780466034;
	bh=yrUERsE4E6cHjoWVt2xzxPe3w/lcberc5ceNmu1nan0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V5L430g/kHbBb5bUGWR+PfT613/157tl2xwmV9rged43OJbXaFh5/SFlqoGSsjQSs
	 PNCwyW3BLmTKysOOWPjchVw4B5op168mJllXWz4UccK80oilPmkYxiOgv/n8IwtAFh
	 zf7u5eqUGEJH7HO2RrlSCGukIPcdyxXZdvfKIKJU84TbzAaLoD4Ia4f7msBjx4zpN7
	 bHOKOaJHYCbU10M3bNyx1MZKR6A71La94ZQQvIaPyXYRkD144ybwT38XKxKq7Jha2+
	 IiwI/V1Yf8mX3CuQUT1YBZPms12IqIe74pdmfROU9oVknXpZ3deqPTR21/wPINbeo4
	 eKDTF7IuHkpaQ==
Date: Wed, 3 Jun 2026 08:53:48 +0300
From: Mike Rapoport <rppt@kernel.org>
To: kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: Re: [akpm-mm:mm-unstable 274/423] mm/userfaultfd.c:4475:1: warning:
 alias and aliasee have different types 'long (ulong, ulong, ulong, ulong,
 ulong, ulong, ulong)' (aka 'long (unsigned long, unsigned long, unsigned
 long, unsigned long, unsigned long, unsigned long, unsigned long)') and
 'l...
Message-ID: <ah_BbB_BnjnNh85i@kernel.org>
References: <202606031038.1aPfmoCm-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202606031038.1aPfmoCm-lkp@intel.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 86ADC8000A
X-Stat-Signature: nr6cwmzkf85mwm99r5yb8ohdz4zq8a91
X-Rspam-User: 
X-HE-Tag: 1780466035-100767
X-HE-Meta: U2FsdGVkX19TFe6OmXC3XTNYD2BI/Fp43wCX2xnWaC8qnywNnzwrhVEMXpmNTgQFtLAXFtJIx3wBhnpK3wse5wrVsLUK3d8I4v2qnnRpj6VehI+xIgdRqvNwzWWYyt+HQ09mL6o+c67FYE/UI7w8F1wZCPzDkN1uU2jUPGz07rYxBCueRt1oKTaG3HZ2Qc7rN6lO2MyypqinOIE4iFuFSQYJ3uS+4IPqfSyezaoGpjP0Ls0jlNJrV3c1H5cMAmvEdI5lmmNe8Shc59obrrVdypG2VWH9viGQj3+3QJ47oH/eFuRWgxO2/5S/Zt+KF8BgZ/BlP05mLY1tFx4PToJP3r/LY05rojHEyI6lyHiXy3tCK8qGFi/nPWABinT5/D5txzF7uBJ3rVGLLUpuE4yvRVbP4Pw1tp6jlE74CY/mwpRfPveLAzpTlZUzLmk1/wOG01+kPf5T0QLH1KM9cVYRr3HsaJKVcV7ESNFJW0MQG1x00WXWoHN5nb63GLwUltD1ASOSV60hGv6pLmLmKtN3lMe6KlTm4BvZ7xnrYMFJ1APscJIvurexpyOV2ZlSh1rZAJEMEy+oaXwpci19SBOJvBVk8f5zm6nb1zrVWdsc4c6saUyJH6fGokQ/I5Jgc0f0wZC9Az6F/3SczB0rIrxaJ7lwkxV1fPqiMqZOiG40OAJefcAb/b5T1paO/PW6Sp052KaJQ+zpL0wpb2E9EApatqS+GosIhiDgvx2ATygrtqhr8V5Pmrdxz3pB9dGt0zCYEUCt8Yi/5BRrqHypQlDMOB66XIOUGjxn+J04fMEAKJaIGUJMffIQgVEO2eOGnc99L3iBqM+Nl5B9w2MGTq5CWNLri2xet/hiGTZjhK4hah85TJuNxzpbiy5cJCXp4x257O5wuWJzB7hCETxn0IjO13yfK/21aK8Ip59ozhn0TqsvLQHxxr7A6PAymAU29kvyLQEKvpTqbcuPP7f56rK
 MM3NGSz9
 1KGmi1vQCPuzbCVqoVfFBRezmL6FSS03vJ7pEP/z1pC7wxIAl282wXB04gXau8e/8H98ULpGNn50oGRVfueq1L46CAS9RfQYUy4t2JFPkjjqgMLavq6ofVGNSubR+WMqUaETBJyIDcPrCFIBM+tWF8q+T2e2NjUwIA23gF6YOqYDDnzzO6iz+Tu60G216Q85GXrKKkra6H72TFZsn20t9W318YMquXKGNEqZdHzJkCX76vRtDu7NRPIk+BpAqwrs4/lYrf+t297ws+TiEvWxS3gezdg/I/Vt7fnu/BMMYZd2y7vROttSHfuXWlLHA6u2JRiMQZWIUz/8mu94OxkRxWbn/geMA4HS8FzXG0gDZmlanAZ110Nr3kC5u6CFJa7wcrPvKdpX4VqOIJ2EWCkTbr11q5gnhUhHjjK/v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(adding Nathan)

On Wed, Jun 03, 2026 at 10:29:32AM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   6bb9014e347a15dfa837cbc52451035466d86ddf
> commit: 53313230f720eaaf9f1f6d20faafd7e01a9e09b7 [274/423] userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
> config: riscv-randconfig-r122-20260529 (https://download.01.org/0day-ci/archive/20260603/202606031038.1aPfmoCm-lkp@intel.com/config)
> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
> sparse: v0.6.5-rc1
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260603/202606031038.1aPfmoCm-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202606031038.1aPfmoCm-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):

Looks the same as https://lore.kernel.org/all/20260528164552.GB1342076@ax162
Nathan said it's a compiler issue.
 
> >> mm/userfaultfd.c:4475:1: warning: alias and aliasee have different types 'long (ulong, ulong, ulong, ulong, ulong, ulong, ulong)' (aka 'long (unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long)') and 'long (typeof (__builtin_choose_expr((__builtin_types_compatible_p(typeof ((int)0), typeof (0LL)) || __builtin_types_compatible_p(typeof ((int)0), typeof (0ULL))), 0LL, 0L)))' (aka 'long (long)') [-Wattribute-alias]
>     4475 | SYSCALL_DEFINE1(userfaultfd, int, flags)
>          | ^
>    include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
>      225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
>          |                                    ^
>    include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
>      236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
>          |         ^
>    arch/riscv/include/asm/syscall_wrapper.h:82:2: note: expanded from macro '__SYSCALL_DEFINEx'
>       82 |         __SYSCALL_SE_DEFINEx(x, sys, name, __VA_ARGS__)                         \
>          |         ^
>    arch/riscv/include/asm/syscall_wrapper.h:37:19: note: expanded from macro '__SYSCALL_SE_DEFINEx'
>       37 |                         __attribute__((alias(__stringify(___se_##prefix##name))));      \
>          |                                        ^
>    mm/userfaultfd.c:4475:1: note: aliasee is declared here
>    include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
>      225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
>          |                                    ^
>    include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
>      236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
>          |         ^
>    arch/riscv/include/asm/syscall_wrapper.h:82:2: note: expanded from macro '__SYSCALL_DEFINEx'
>       82 |         __SYSCALL_SE_DEFINEx(x, sys, name, __VA_ARGS__)                         \
>          |         ^
>    arch/riscv/include/asm/syscall_wrapper.h:41:14: note: expanded from macro '__SYSCALL_SE_DEFINEx'
>       41 |         static long ___se_##prefix##name(__MAP(x,__SC_LONG,__VA_ARGS__))
>          |                     ^
>    <scratch space>:148:1: note: expanded from here
>      148 | ___se_sys_userfaultfd
>          | ^
>    1 warning generated.
> 
> 
> vim +4475 mm/userfaultfd.c
> 
>   4474	
> > 4475	SYSCALL_DEFINE1(userfaultfd, int, flags)
>   4476	{
>   4477		if (!userfaultfd_syscall_allowed(flags))
>   4478			return -EPERM;
>   4479	
>   4480		return new_userfaultfd(flags);
>   4481	}
>   4482	
> 
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

-- 
Sincerely yours,
Mike.

