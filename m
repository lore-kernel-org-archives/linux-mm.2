Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A575CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 16:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC6F06B0005; Thu, 28 May 2026 12:45:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77EE6B008A; Thu, 28 May 2026 12:45:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D67266B008C; Thu, 28 May 2026 12:45:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C507F6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:45:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73CF491218
	for <linux-mm@kvack.org>; Thu, 28 May 2026 16:45:59 +0000 (UTC)
X-FDA: 84817405638.15.F50F6E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D36F6C0010
	for <linux-mm@kvack.org>; Thu, 28 May 2026 16:45:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dsrHQpmR;
	spf=pass (imf10.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779986757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uD/DS6x9bXsYcWxd2veAzMu1GEe3GHOeMibHtLaSx4Q=;
	b=CWJU9rqQJzOso1u1TKwuxLzXW3Kp8gcRY4I9bKniLTciBZqdb2du2anQSXJSxkut00XM90
	RFzoJm4jCV28QUc/IwKmardFHoTLVJqkVCVbeA5xFnMM/sTQN2EFi3fsFHQiBg6/QCn8yZ
	/pbtcZH2nEUuqAlB7XzAB3p/eZb57PQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dsrHQpmR;
	spf=pass (imf10.hostedemail.com: domain of nathan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nathan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779986757; a=rsa-sha256;
	cv=none;
	b=vb3QwDUg8Gkk+JlHF/HDAFfvtSKWRMKPu6vd583fQubY9WQcYT5mNjkWZjaalg1f8517zo
	2LGynK0UzCQDI5ttVi1V5GzrK7rtr824RYmIVxczc+/L7zMYFkJI/9pN9qxQkVpfPgWu4m
	0AeD+NTZVg/1WnGsJ8na32XLqtzuiPk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C8AA6014B;
	Thu, 28 May 2026 16:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369EC1F000E9;
	Thu, 28 May 2026 16:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779986756;
	bh=uD/DS6x9bXsYcWxd2veAzMu1GEe3GHOeMibHtLaSx4Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dsrHQpmRu32R77qDus+MtT68nh/wLDtzQgHn0bQ8lrb6rHBhve04WlkL27LzZyhYW
	 yGFQgr7Ykg4+SEPK9/NBKs35kZMmBl9RTGAU+cNNVUss5WZIlXy1c41hEnXQijtvRg
	 A+lVb86uEjpmRfPZHejTCeJ22hmpqlplwwE2FoICWx95xO3Lm6hetRLOVpMu8e3Xqg
	 D4OoKIlrLnBMz0phA6x6ORSbPbbOpgIEYvfXsDyficSjR26WqAqiqE2ItIu8MWHMi5
	 ++W1+fvxlq37OwvBF4PNdJW03RkscFyKqoNaKtA8Xpa3xzBmQkNSsCoEbJrk22qLJX
	 BHnXZfZRDNkug==
Date: Thu, 28 May 2026 09:45:52 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 273/420] mm/userfaultfd.c:4475:1: warning:
 alias and aliasee have different types 'long (int)' and 'long (typeof
 (__builtin_choose_expr((__builtin_types_compatible_p(typeof ((int)0), typeof
 (0LL)) || __builtin_types_compatible_p(typeof ((int)0), typeof (0ULL))),
 0...
Message-ID: <20260528164552.GB1342076@ax162>
References: <202605282311.BlbuvsRF-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202605282311.BlbuvsRF-lkp@intel.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: dsmteg5eyp19sgpquprn45hdso3fpk9f
X-Rspam-User: 
X-Rspamd-Queue-Id: D36F6C0010
X-HE-Tag: 1779986757-489600
X-HE-Meta: U2FsdGVkX1/+JahZvnnvG+/iTpS9spkpkXUmSL23S/AQqGnUuBiG5w6yHunBok0NVMsm6nPRr6XAZS9QuVQiwlviPnv8LGuX8FKCNM6sDfGRtKTuKY1kMM5fn7CegcnizsuNYx9bs17cVJzuQ++e5lDdcvxdSzY1ViXVYD8Bqf0L7PtLpvSm3kY/QYh6Pt4wTT337hmu9Kepi6XSLaq7WVGySsufbbl1ZMC9rPiuVOOmMLbjhiVrAjdIBv3I6EAwi8tF8tYSzdgR1EIPHcUd+NG7VlrNTohE3aiWk5VwnUvXn16yQI6e99CO30fa1KDxnZtVDRG7aEnR3eii7XpiUgSdBG8Ka0y5sznz43MWCthMxNlw4GD6CtvdNmGEwvxFgy3U0He9+xz4WWSOCn7xWpzjpD29IdSVgjyXq9MzioXcRwIw/Q4QSYL2nlJNIUsIDdk2XoZxpGZFrlOs1PYcUseONYnYXKue7u3i7lahJCvbwMIhPCC4c4tbYGPg7rFgd7dwjgdNh5urDuBJFYN1ffMO2d5Tp4fu0WY5eNIHKC/v3tbvOki2ZUOrEAPJPsxy78jdoA4oIhTUZCvDomyjF4NwCrb+qvI3lWE209lvYEGctwFOGnQc8CsoBgA/AGZzmgX+K7lfwABXGzptz2re+pFvuBeW01d1e7gNA+BtIAKngbaeAMOeZhZboG16OBNWGO875OiG2ri9JzXM0CC2AKG3s2PfSGlimqj3zdMZVNFfOzNUKe6kNhfT4FAyQqn74Y7DMUzSHdYqWJIgle4SWfkYHRVAmRxn0WT0Zfsh0umBTEP57m2DAC9O/VMJKlmQkwMIXvSHC+OF1p2yud9re4rxhIoglkIr1oK0DDpWCe70yAXfexoTL/u6npAF895Ut1nXLps00oni7ZTpIeOl5M1A4BYYfcDqH5fERuGW1r6AdwCw6FaApbo98naXjSfxazH0pqYxF33vyVAw1qu
 GhyVI8gr
 whgh0O1Cs6KM7u5VS6Zg7sABJjeeQyHJGgbPrQnv3xpuWlN5kci3KHZTXjbBs+GVqJxpzYZIaetThkny63I1dMvzgzWw7Ce3MdwovDuW1VMFdNWCijNoznUk7bInkVI/obRN1elN47kbkaJasZ9VzAS7cekWC2/NW8k0esGdh1IYDN0l8BR8/8XRdk+661NIIjFdo6HnlVIYWYrdL6LRqkAp+mVjapmLIMbBVITpYvNkGk6dEfUSl9gs62Bb4j9wvqC1x2MIYeRa18rwCYoOYwD8lRUFv/ZyLg+aAqqpgcMGYNf6piLkD6w5bhFL/gPlaXq0/nu+6L6yP87DkI19Wy5H1GBXnqvoDaYj7M15Wcs8xH2pvMw4c4N3HfoaB3r74+5s4vDztCDo/8E9xrCz+/lU6bBFDSACzloiRR0bKQh17Rc2mAbi0kx++QJtkaIeyvjTTHgIJnWz2Q583s4yYncEUvHb7NBuyMrk3ItSSHfJDFo2aN0BdmEAJRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 11:28:25PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   8a74e22643189e0ae339afc91110ddb4cab1941b
> commit: 688eee218159283140c8c4b48429cfe400cb64e4 [273/420] userfaultfd: merge fs/userfaultfd.c into mm/userfaultfd.c
> config: arm-randconfig-003-20260528 (https://download.01.org/0day-ci/archive/20260528/202605282311.BlbuvsRF-lkp@intel.com/config)
> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605282311.BlbuvsRF-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605282311.BlbuvsRF-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> mm/userfaultfd.c:4475:1: warning: alias and aliasee have different types 'long (int)' and 'long (typeof (__builtin_choose_expr((__builtin_types_compatible_p(typeof ((int)0), typeof (0LL)) || __builtin_types_compatible_p(typeof ((int)0), typeof (0ULL))), 0LL, 0L)))' (aka 'long (long)') [-Wattribute-alias]
>     4475 | SYSCALL_DEFINE1(userfaultfd, int, flags)
>          | ^
>    include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
>      225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
>          |                                    ^
>    include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
>      236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
>          |         ^
>    include/linux/syscalls.h:251:18: note: expanded from macro '__SYSCALL_DEFINEx'
>      251 |                 __attribute__((alias(__stringify(__se_sys##name))));    \
>          |                                ^
>    mm/userfaultfd.c:4475:1: note: aliasee is declared here
>    include/linux/syscalls.h:225:36: note: expanded from macro 'SYSCALL_DEFINE1'
>      225 | #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
>          |                                    ^
>    include/linux/syscalls.h:236:2: note: expanded from macro 'SYSCALL_DEFINEx'
>      236 |         __SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
>          |         ^
>    include/linux/syscalls.h:255:18: note: expanded from macro '__SYSCALL_DEFINEx'
>      255 |         asmlinkage long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__))  \
>          |                         ^
>    <scratch space>:46:1: note: expanded from here
>       46 | __se_sys_userfaultfd
>          | ^
>    1 warning generated.

Sorry for the noise, this is from a compiler upgrade, not a fault of
the blamed patch. I plan to submit a fix for this to Linus soon:

  https://git.kernel.org/nathan/c/175db11786bde9061db526bf1ac5107d915f5163

-- 
Cheers,
Nathan

