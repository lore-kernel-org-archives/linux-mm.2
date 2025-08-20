Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBD1CA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433FC6B008C; Tue, 19 Aug 2025 21:54:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40C2F6B0092; Tue, 19 Aug 2025 21:54:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322058E0011; Tue, 19 Aug 2025 21:54:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FC096B008C
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:54:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3D3AC030F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:54:34 +0000 (UTC)
X-FDA: 83795466468.15.C5A533E
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id CFDDB40007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:54:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pCVNV4T7;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755654873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eahXrLInkrCA7eb/xYG4dx3o/yyl8ef/xSYb6rkODMY=;
	b=XVyA0/hNyiCTt6rwFq+N+g19joYdPEMVpmb6zg6EHM/hVH0t58Ff3TAWLd+pGq69TZ0YGZ
	eW5BxpWsHzYWxIFtX7HPBzfbTOAJSil9IQ3ePDIq3ZEZ5ygVBc1iuc3VmqadLeAU02ojf5
	twMdhD0FD8V7PedtPTgc+PUEu0FIlFY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pCVNV4T7;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755654873; a=rsa-sha256;
	cv=none;
	b=Apw1MIZg+mUvruM/gpqQt2zjDPVEXx6Svr58ewYuv/VsC7OYuc0P8qgCmLUZbgrMMHLpr9
	50HQ12szC/GtaUN6LqWFwffLRnFHgeTMqT/aLHCPDUTU73UOsWuA2PfycFHPwuGQTHf+9a
	/ZGEV+BrOwDhkDIZvz7eqeuY5PccnxE=
Message-ID: <ae9bb2ea-c6e5-4a4b-ae25-aea1d6fe084d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755654866;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eahXrLInkrCA7eb/xYG4dx3o/yyl8ef/xSYb6rkODMY=;
	b=pCVNV4T7NVg27PHyW7dCE6EQ2iYGKoebYGF5nWklRLOs50SrZ29zYiPpwykLNVldlIPPMn
	87ztk76Nit13NdGb9ZWJRSDNYFfWUOZKFw5jZhiBrrruzGrpH1szx7wUByV+Ot4Qwk7vGn
	ocmNnYPAKKPZj4SrKETmiDy4cbdnrV8=
Date: Wed, 20 Aug 2025 09:54:21 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] panic: Clean up message about deprecated 'panic_print'
 parameter
Content-Language: en-US
To: kernel test robot <lkp@intel.com>, Petr Mladek <pmladek@suse.com>,
 Feng Tang <feng.tang@linux.alibaba.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-kernel@vger.kernel.org, paulmck@kernel.org, john.ogness@linutronix.de
References: <aKRJKZHgcxyNF3y7@pathway.suse.cz>
 <202508200907.PsZ3geub-lkp@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <202508200907.PsZ3geub-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CFDDB40007
X-Stat-Signature: z9otkdw4bhmaetjtct1ezkgbdyt7tni4
X-Rspam-User: 
X-HE-Tag: 1755654872-657579
X-HE-Meta: U2FsdGVkX1/9Eaz1x4SlFPwrtnGmkOHqLjQ8Z4JtiAhf6xohkPxgRy+9wiZ150982MCGM43g2JZ4k97+U9RFJEZ2S911FEqTiX9dP8Bhe7JBQWLaIZtrBu1Qq3jz1H8O8L3c80rsml3Kfkpr1rtA5u17j8xd52DnQOO1k1mcCuwcl9oIuqw68+7Ga2b3O24VvkdFm+PYP7cKNjvlUxfIZXkPv7MXC4RjY8t2ex0GCulDZ7crUgS5CxnVtMPXk+fU0uJXd8GGfZnP8mtviUH4GH0n7B0QwGJnGv5tep5ivrGRcByvN1L/H+8E7E/ACE89QTgwV3deDz4TxYTutoHK1TlQ7ufHI9DUEVsjuKPQXhABAp1twtD5hmjli6f9ghTzMb77Gyjr+NLK1U0LkSXYaFco5Px5dmWPJqpaXu+dWfrwdj2lEayiMPPHp0hJHcWOUcbJfgCk6t17o8NSrpq/OYJ3R1MpKM+B4UsUwoPJeKUWeho4+I2ZxtgA46NiyxKueJ4oDb9XGxaU6xTIPEWP4PEl2j18XDzhVwluU4s2EqI2+lQh1tvf2d8zUbM/Yn4l9RL3KgVR3ZDO8jWzvnJhteFFeYkQxJc8vxCx5iZpPfggoYO/8iApoFRKZd3Y01QGVWHyWAPCgNf6o0CC8H2HFhCJODKupCjd4yocEnx71pXoJWRZngUkj3J9PfY97vcJwqjG+Xb83ktsmrbG0qxC9PnyCIW0oWpuTIYn/JCNxMuWyMVXblIortNzzn/CzWHvK2lRHgHKmXDN717bAu5px8XdLweddQvGB6RcKVwo+v5YlIXWwvqMphwQ+SIhNXC/r7YvqBx1wAMjmSNAf5aModQtRaiyJZhp9MGP2yqv9kxVDbv6mw002S6mzj6kbVZIliKooxgevQqdVtwNJ5+DPKLih6q1ZxF+g+dUHkALRoaOdIYwAYOWKa9yba7I0pvLq1yYnnFS93cJotKaN23
 ktgh2FqZ
 0laf7tzK3bx1ElvJlOZcpaNXuUyFMaY1x066Q4B95GZPwIbzF30gZ+aokhH3iQODovmAiuVuJ92OjUZcd6NTQc02jgCKaZFcrFkNuItPuyEZFtrf8rwQ/it6ypt3Fdz7scVUKw0KV5c+v682rg7Zt6lGqBYRwHHl2W4zGjdLUQVTV0jdYehdB+AN4D1//2LxP45Rfm7mig7Hc5JEpd/bMdU5qE/ULRTvMPyUnrpRJGiDXunc4KOaX5TKyHjRmaWydv+oDDDMSJTZzYj1LsLT56sZ6T9c6o258Kw3Zla41F+2/lD1XjIax3VHoXe/Ss4SZFI3+i5lIgsIFbvBYFhKFz4E3HmDjZCo7HH5I1VpCRrWhTRYCi9X1hgrECI9jQ2VyKXoWu3qBQIUztOP0LhsL8KvXj/vVYK94YCOF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/20 09:31, kernel test robot wrote:
> Hi Petr,
> 
> kernel test robot noticed the following build errors:
> 
> 
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/UPDATE-20250819-180717/Feng-Tang/lib-sys_info-handle-sys_info_mask-0-case/20250815-152131
> base:   the 3th patch of https://lore.kernel.org/r/20250815071428.98041-4-feng.tang%40linux.alibaba.com
> patch link:    https://lore.kernel.org/r/aKRJKZHgcxyNF3y7%40pathway.suse.cz
> patch subject: [PATCH] panic: Clean up message about deprecated 'panic_print' parameter
> config: i386-buildonly-randconfig-004-20250820 (https://download.01.org/0day-ci/archive/20250820/202508200907.PsZ3geub-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250820/202508200907.PsZ3geub-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202508200907.PsZ3geub-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>>> kernel/panic.c:952:2: error: call to undeclared function 'panic_print_deprecated'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>       952 |         panic_print_deprecated();
>           |         ^
>     kernel/panic.c:958:2: error: call to undeclared function 'panic_print_deprecated'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>       958 |         panic_print_deprecated();
>           |         ^
>     2 errors generated.


Oops, panic_print_deprecated() is defined within the #ifdef
CONFIG_PROC_SYSCTL block, but it's also called from panic_print_set()
and panic_print_get(), which are outside of that block.

So, we need to move the definition out of the block to a common
scope where all its callers can see it. @Petr wdyt?

Thanks,
Lance

> 
> 
> vim +/panic_print_deprecated +952 kernel/panic.c
> 
>     949	
>     950	static int panic_print_set(const char *val, const struct kernel_param *kp)
>     951	{
>   > 952		panic_print_deprecated();
>     953		return  param_set_ulong(val, kp);
>     954	}
>     955	
> 


