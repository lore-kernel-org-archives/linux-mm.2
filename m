Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 255D3CD6E57
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 01:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CC786B0005; Wed,  3 Jun 2026 21:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07DE66B0088; Wed,  3 Jun 2026 21:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5B96B008A; Wed,  3 Jun 2026 21:19:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E07646B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:19:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8544F16343A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:19:28 +0000 (UTC)
X-FDA: 84840472416.15.F4B53BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id EC50F20004
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:19:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N5XsDUv2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780535967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OC2aLlOHe9nbxKbN6iiUmt49s8yh8/9Q9SdTr4G6ru4=;
	b=8RL+s0WPDuG1ccFFp6H3hqPUpe2d3mIwMwHJ3ZCjHbaXCcYUNHtrp/YFv6iUrNxKNYN+B/
	i9a5VpvbAdCwL0TZKtBlgwiBKSEFsLYMqwPWFEFLMdFh8XquYwiNQ9/dmhYVziOpTqAWj4
	025zLVrULIJ+GvIrbbxIkqaTsiQTb6o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N5XsDUv2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780535967;
	b=0tUPt3wnxAlJ3Uj15VPWFF1M9ghJr4hrHD+wPChfBVr28tpPTHImKxXKXXxEcONUNpQ5ti
	fXl5vzYTS9xtfE1QPaApXoj7m1xDkeYrLvSuAs0QeTkYwjqutyhR8clnx3ivRNBk8r6hDN
	WKV4jNlRPtZah7Uh5igBedKAPrEJPN0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53AE8601DD;
	Thu,  4 Jun 2026 01:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCE51F00893;
	Thu,  4 Jun 2026 01:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780535966;
	bh=OC2aLlOHe9nbxKbN6iiUmt49s8yh8/9Q9SdTr4G6ru4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N5XsDUv2Kw9VML6g5U88DT7ZNzkDdXLZ3aiuBI5+XlksR3H0zkVI7T6i8FI+L7i1N
	 kDM2b5yqi90rQ99EaQJI3g8XegeKFyG5usithsAxx7AJfs54vfFl2Toklmzv0xqVxQ
	 FTJRYaWolql9UZgyPe0VbRkbDzj/LWeVSGBTMUfSa/Z2ncObNAnZECsbhjZ88aHKUh
	 zoWhcSajOOzMGd7Z5+eTsK4lG6DNI4NbSm5f/TqZ5C62gqAvBmZdkL++TMWylww2kp
	 oK/lABLtuRocYBIaoGFT0j3HDDmMfZuru5jrSJKkeoH+rZjQzy9aJpkzOrZFptM+CL
	 J9pcdu5QNZbAQ==
Date: Wed, 3 Jun 2026 18:19:21 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: Re: [akpm-mm:mm-unstable 274/423] mm/userfaultfd.c:4475:1: warning:
 alias and aliasee have different types 'long (ulong, ulong, ulong, ulong,
 ulong, ulong, ulong)' (aka 'long (unsigned long, unsigned long, unsigned
 long, unsigned long, unsigned long, unsigned long, unsigned long)') and
 'l...
Message-ID: <20260604011921.GA1329739@ax162>
References: <202606031038.1aPfmoCm-lkp@intel.com>
 <ah_BbB_BnjnNh85i@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah_BbB_BnjnNh85i@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EC50F20004
X-Stat-Signature: 7epix1umi6gjhiyisq6r4i8px1gf6u86
X-HE-Tag: 1780535966-843824
X-HE-Meta: U2FsdGVkX1+5hHcYLp8wxUK/D9Q26n7ImgRqa2jRnVRfL6gCgihsrfvgI4tYJ8pkSlyWOKRIlpX141nh6k8qUM8fUJS0Gh3SGiDkMKKKEyPFhmPdgn1OcuyjpDs5/UM5H+bjOWZ5nxLzRJ8Q84nK2jH+pE/Wm+LjGeqS3bHnJ5La4qaCMoQ2clYgcweGjHFWvSUYhpIUtl+8QsQNUWNC3TT26lsu0Xn4Hb8q86Uek5GMj/iehYrYyLDwpQ1GEiOddab/wBTMSMgLE9SXT9RI+AS9R8KxnmvFSUHP2vsIVbkpaGP2CBp68KiBKYuu0XIWdSVkVTjGgrKN4hvoJVlbUe4lG2ry8a7MgfHq67ieVBeHypA1bGdHBNnglG6CLYALXkW6Y/1d1aoQ1BbTSwP1DNbmFXtEY5j3eNT7XcIwqwQG5pv3ONmpEr5OYUwMJ+N0FU5Ek+zH8+tp03u7HMEg28QK6qEZAZ1HaO9RLjOPDTA4FZSGAtKNsan4lwjE9a+DRo1BsG/s8XDlwUovSYdG8K0g62K+pNwku72/5dWemTWdqhXX187qo2keLiZ22qxfX5G/YWKr2qESzazC+07zFbamNiOb8Xnnc9PaCvnTODr3sENFMAcJdvLwNE5wNX0uXPR/35RprZQnePX8V2x0JpNpbV8h71QlrTgSAcacmGv1gXFMNSKQGWWb9XlZ9jY8Yz5c5Cvy1synBLuuol+l0JRTHxX05Em/47yOgBIzIfbV89T2H9VlJJuAQ7kx6CSLHDp3rdImM51ocFyI6tjko7sdSKiMkjoftZ82waTWiinVnp3zNcYgnokd/GB9ZPVf5tOs5/SG4Z7TaIuYFlNNikVC6NXGwJjE39yeeQvZ1m5Q0Be9JYHG51iVWv9acvas+xAk5uFUBUzJiRMKFloC9VRogJ3zOis0LPABbiadFvuslzG3TJ+AvcNXN+giV2ccnq/z+40DvwT94nlpJQa
 ZG+qrfjs
 /psOilipJOiISOuYs5ZjOCf/lDLFuEo3E39vVtIdFL1puXWlu0/vq/F/w5c3Y/ajgQKHUh7Fp78gUE4dMY8jCP3jnVNn06mZWMTz6+k8uoW+TYBo+rz7BKCaCCe17asEzC7wfvKmzAf7bvqbC2dNewX5Oz1qYBWdT3oiyZiy6J++sictZDPQfqUCNIDQNuy5dyeMQsXlWO9U3JmGNs7tzIAW9BUiM+0A1Y5LKpeL1NzTTPfBArtQqMnMFOSrpCCwnuSWkmgVQfJ5EiDBNA9Q0JoItrWfm9A4Mtle9CoC12Hd/oaAesoURYGp4XIfvvj8W5/KedrBJ2XmwBLMK+j2Zr3akQe3sahJrj0zAJ1/KLk5pohuEJ3wyVSzjEHcR9Uotjgrzn1eHxEvir0IbNX9p9WfntTlS9qt9h25i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 08:53:48AM +0300, Mike Rapoport wrote:
> (adding Nathan)
> 
> On Wed, Jun 03, 2026 at 10:29:32AM +0800, kernel test robot wrote:
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> > head:   6bb9014e347a15dfa837cbc52451035466d86ddf
> > commit: 53313230f720eaaf9f1f6d20faafd7e01a9e09b7 [274/423] userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
> > config: riscv-randconfig-r122-20260529 (https://download.01.org/0day-ci/archive/20260603/202606031038.1aPfmoCm-lkp@intel.com/config)
> > compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
> > sparse: v0.6.5-rc1
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260603/202606031038.1aPfmoCm-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202606031038.1aPfmoCm-lkp@intel.com/
> > 
> > All warnings (new ones prefixed by >>):
> 
> Looks the same as https://lore.kernel.org/all/20260528164552.GB1342076@ax162
> Nathan said it's a compiler issue.

Indeed, this should be resolved in Linus's tree with

  175db11786bd ("Disable -Wattribute-alias for clang-23 and newer")

> > >> mm/userfaultfd.c:4475:1: warning: alias and aliasee have different types 'long (ulong, ulong, ulong, ulong, ulong, ulong, ulong)' (aka 'long (unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long, unsigned long)') and 'long (typeof (__builtin_choose_expr((__builtin_types_compatible_p(typeof ((int)0), typeof (0LL)) || __builtin_types_compatible_p(typeof ((int)0), typeof (0ULL))), 0LL, 0L)))' (aka 'long (long)') [-Wattribute-alias]
> >     4475 | SYSCALL_DEFINE1(userfaultfd, int, flags)
> >          | ^
> >    include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
> >      225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
> >          |                                    ^
> >    include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
> >      236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
> >          |         ^
> >    arch/riscv/include/asm/syscall_wrapper.h:82:2: note: expanded from macro '__SYSCALL_DEFINEx'
> >       82 |         __SYSCALL_SE_DEFINEx(x, sys, name, __VA_ARGS__)                         \
> >          |         ^
> >    arch/riscv/include/asm/syscall_wrapper.h:37:19: note: expanded from macro '__SYSCALL_SE_DEFINEx'
> >       37 |                         __attribute__((alias(__stringify(___se_##prefix##name))));      \
> >          |                                        ^
> >    mm/userfaultfd.c:4475:1: note: aliasee is declared here
> >    include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
> >      225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
> >          |                                    ^
> >    include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
> >      236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
> >          |         ^
> >    arch/riscv/include/asm/syscall_wrapper.h:82:2: note: expanded from macro '__SYSCALL_DEFINEx'
> >       82 |         __SYSCALL_SE_DEFINEx(x, sys, name, __VA_ARGS__)                         \
> >          |         ^
> >    arch/riscv/include/asm/syscall_wrapper.h:41:14: note: expanded from macro '__SYSCALL_SE_DEFINEx'
> >       41 |         static long ___se_##prefix##name(__MAP(x,__SC_LONG,__VA_ARGS__))
> >          |                     ^
> >    <scratch space>:148:1: note: expanded from here
> >      148 | ___se_sys_userfaultfd
> >          | ^
> >    1 warning generated.
> > 
> > 
> > vim +4475 mm/userfaultfd.c
> > 
> >   4474	
> > > 4475	SYSCALL_DEFINE1(userfaultfd, int, flags)
> >   4476	{
> >   4477		if (!userfaultfd_syscall_allowed(flags))
> >   4478			return -EPERM;
> >   4479	
> >   4480		return new_userfaultfd(flags);
> >   4481	}
> >   4482	
> > 
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
> 
> -- 
> Sincerely yours,
> Mike.

-- 
Cheers,
Nathan

