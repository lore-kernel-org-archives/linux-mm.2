Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A9A10F92E9
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 18:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47DEB6B0096; Tue, 31 Mar 2026 14:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E876B0098; Tue, 31 Mar 2026 14:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 344046B0099; Tue, 31 Mar 2026 14:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A59D6B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:23:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B90CBC4253
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:23:44 +0000 (UTC)
X-FDA: 84607181568.23.7E49256
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0924B140002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:23:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pNEzS5eG;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774981423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/MelY5xTTNExHRFDS44gD4i/cmIjh7ATfg6XNbiljQ=;
	b=YtfI70kBGAUFs1U+SwI9XtfKwzj9jAnzHBIeucDxOUpoMPRexB8TOk2cXjporTglwsx8Gk
	2YL739SNd94Xv/iHOR0EHyRQNRU3d+qbDaoyK5tgb3DycTKmqUOJhi2Qgva1ArFQzvstX2
	30Rk+6vHox+VYRHW2Q9xZcQ+AGqsStg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pNEzS5eG;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774981423; a=rsa-sha256;
	cv=none;
	b=ZVhGnWcQzsapIPOXo0Yy+fGwuqX0otriQEe4vrpJ2ptQ/woEGYpWyO05C62qdaV3sS1VfN
	1eRwz7PMDunbWSzttvehnn3I4sF34JEP0LO0q89gAj+eG3YpZemV2DSWCs59CDar5zxbkD
	qwrPtt/hWBJfgp/FMlZ4N1/f+YTikr8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 26B2660053;
	Tue, 31 Mar 2026 18:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D742C19423;
	Tue, 31 Mar 2026 18:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774981421;
	bh=H7HU/TLnZ8bVLFZQ0yYOKUzgESrMGNQd+7T8BLdmYFg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pNEzS5eGuBwE8sUdbHNIfqW+JpavK4huAORT2wugb9MXAaIJT8ULhCpJIGj+AfTkB
	 M17cQzNBq8F7AJTWxgmEpWE9lzKrJ+sZcXzP5V0/hFHtmbR6OXUJ/UFpS+lFRyYtB4
	 7+4WTOfTKYGwxZXbHlt54MoBE6T64W8962s6ZqK8=
Date: Tue, 31 Mar 2026 11:23:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Chunyu Hu <chuhu@redhat.com>, oe-kbuild-all@lists.linux.dev, David
 Hildenbrand <david@kernel.org>, Linux Memory Management List
 <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-unstable 121/130]
 tools/testing/selftests/kselftest.h:427:13: error: implicit declaration of
 function 'vasprintf'; did you mean 'vsprintf'?
Message-Id: <20260331112341.83f62d4d4de710457ecb59c1@linux-foundation.org>
In-Reply-To: <202603311105.ysUeYPSZ-lkp@intel.com>
References: <202603311105.ysUeYPSZ-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0924B140002
X-Stat-Signature: 47rmxt5wwiy3xdq4atukjzsppug5zw43
X-Rspamd-Server: rspam06
X-HE-Tag: 1774981422-526981
X-HE-Meta: U2FsdGVkX1+68SmBVTtbxssqM2ruEPF2wlyyYEK02ggElwmPbTziBOZd01x4qzlSjWbtMnv+zdFIJuClPK+9cSBYO7XMRYkiSgYYkXzu5Y6ViFce/gZt0vA+Ae+B0udFXn8Ic/gj7RJ7qLiBCzrSL6LkDggua0waCD06ziCW1FqodHwUwPOS6xzX45XIYXrtrfEqFC4lbe/O44jKEJGhOL736IUfP7OGjq5DtFYaEKRY/wgPLywco0U3jjL4RLDmfatb3z6sRoDdvvyYfN+I+l8MmfBJRQhLmD3SbDPtTikij1BSOR9eJjFGptuS0wdSz62hf9AtzWv+n4w1QzCR1ej56CccZ/2Qu8ugC5ZmF/FddwsZtMOpPgot7NvFWPQn2ps18wqRKBI5H/UNB0sHtAVFTtiIUXrnNkLIdnkFP1BHps0cAYjmslrosxWmeBefpc6AAMaJVzaeUER1uONW/eQAwyPfoeTlT4uNne5UttMzHkHZE7hrHzE3C4jmezwZapbbL6GRw+iuK8R2Pf10uL/FBH3gZF7VorDqbAqi3lClQBsGjjRn/4PJhv5qLJy2kg8NiyYwlSL9AcugZvmZ/bqGbjkB5sCroJivLn7Lx68Kph8Cdd0Nk9nshu7K97Bb2Q5K+BZLmxVX0eXu4Z4RBsORoJUZgxTWbUFzqH2ZvgWLWp93BL3CfCH67lkYZzzj5r782x2HLW0aTCCBW/8iIJARsTQDUxBOm90p1zG72TAKBcwmtaw8TC09pvYf417N5BwVW/CKLYqDkbMaeNle4sDdFwA4Qf3wvaPlm+ZFH5hbL3gWcIHPeweHe+zOqa+aCeLRK62hHFnx9eLMxld4wZVtb4mCvyJiGvV/m6EpC8p4dazTr+wVB7C9waqg9qBt8Y3+ekstHDyetlka2ZcWbEWPsrG1q8qjg6J36x0PjUQLRr3Y7uHYrerkCAiR9+Y+DMbSrZVmE+THS9xcMJv
 eOnsq7gn
 YN/0p8Dp1uI7wyFyULFHc+ac4p3Bt0WGFlsSsV+Ru3mEdwjoZFO74Ufh6lHNV7zlwRRNIhlhcgo0XEZ8QWRKbXMK4gk+nke4x0gBHq+gdYXmWVccdj0WyEeGmuY8foXEUhsDv/uDebkJyLTfe7yaZ+P93SdTqBDEIe73qnNur+kJ40/iKLvrlkN1V4LpzcszI53T0/3xzci5k+NBEhjuxhqWgNy3jAmxT4MpvQkupxuAGzwkhuBidysA24YLpbP8YsUhFiH8Zakre5KvWZFAgSOsNgFdKhAjG6UxOI7nDPOTwG8xYNCauYDGkK0v1v/R8f5mlXS51cXeizzkxysklAythWImC93lRLsHu0TkCK7wAESmeA3LfGolHSwTXRLTwziGuiA6m8CbpQx4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 11:27:20 +0200 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   24e341657c283c965e3bfee0baa9ed0376127973
> commit: cc0b04b10a7b98fd8df2fd539177e94e0f83a5c3 [121/130] selftests: ksft_exit_fail_perror: support printf style arguments
> config: arm64-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260331/202603311105.ysUeYPSZ-lkp@intel.com/config)
> compiler: aarch64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260331/202603311105.ysUeYPSZ-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603311105.ysUeYPSZ-lkp@intel.com/
> 
> Note: the akpm-mm/mm-unstable HEAD 24e341657c283c965e3bfee0baa9ed0376127973 builds fine.
>       It only hurts bisectability.
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from za-fork.c:12:
>    ../../kselftest.h: In function 'ksft_exit_fail_perror':
> >> ../../kselftest.h:427:13: error: implicit declaration of function 'vasprintf'; did you mean 'vsprintf'? [-Wimplicit-function-declaration]
>      427 |         if (vasprintf(&buf, msg, args) == -1) {
>          |             ^~~~~~~~~
>          |             vsprintf

What's going on here.  vasprintf is a GNU thing, but that isn't it. 
kselftest.h includes stdio.h directly so fine.  I don't see anything in
the later patches which could alter this, so the "only hurts
bisectability" is inexplicable.

I was able to reproduce this, once.  Now it's gone away.


And arm64 allnoconfig is a nuisance.  Now my vmlinux build immediately
faceplants with

./arch/arm64/include/asm/atomic_ll_sc.h:298:9: error: unknown type name 'u128'
  298 |         u128 full;

With the latest 15.2.0 kit from https://www.kernel.org/pub/tools/crosstool/.



