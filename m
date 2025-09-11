Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53E97CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 02:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47AA38E0005; Wed, 10 Sep 2025 22:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 452AE8E0001; Wed, 10 Sep 2025 22:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F828E0005; Wed, 10 Sep 2025 22:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC168E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:13:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3ED11390D2
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:13:10 +0000 (UTC)
X-FDA: 83875346940.22.2D694AA
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf03.hostedemail.com (Postfix) with ESMTP id BCB3620008
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:13:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M1G8t34H;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757556789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5x97LCOYyTXkOfHYlT/QUqsdu9EY9w2HudE5QcAbwMs=;
	b=NRJnaklT39mwp1ss79GWxWtDSrgdMBUHte9Ix7jBPQMM/f9e0G5JDg2MwUgdxP8z1nxPfC
	JCgXj7sP6cXL8/3EC1woLc9kAP/Y81XhygoDnx7hQeomTejHMtnqGKSFjwX3JS8UjpvtSj
	ULapaGFaPFVKyhU8mvPxAeXeA01dDNU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757556789; a=rsa-sha256;
	cv=none;
	b=YBDK2qQlZ9dSOyY0kAw1/bzBJBGpzYwVstI/HvRYX25eKZZeMgarNJHHEBuSujGUlQqUdX
	1gwO4IPNdaLQG+BpJsXCJMR2RcRybib1hgmwL2RFmiOJWaHWTIDEH1+a+M4VpxvzmCfYV9
	cnM4OwMu0WeHmKifEQNoXFzhhpUb47U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M1G8t34H;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <49b70945-7483-4af1-95ba-e128eb9f6d7e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757556786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5x97LCOYyTXkOfHYlT/QUqsdu9EY9w2HudE5QcAbwMs=;
	b=M1G8t34H0j0/s6kKNLbIj/nDQ8gNW61ZSNACRNV2OIl3EYf/+ktW1Iv26EI/RWOojX6wwm
	4SSrTVjmZNyULE2yRObTF4Oi2atDivC4ft5N6eclHcEGgMcWHqB0D+7QD/+C+rl0xOm2zc
	1zLu7Gvq5NRCnb++mS9mooyudDthQkU=
Date: Thu, 11 Sep 2025 10:12:48 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task from
 khugepaged_mm_slot
Content-Language: en-US
To: Yafang Shao <laoar.shao@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, bpf@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 Lance Yang <ioworker0@gmail.com>, akpm@linux-foundation.org,
 gutierrez.asier@huawei-partners.com, rientjes@google.com, andrii@kernel.org,
 david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, ameryhung@gmail.com, ryan.roberts@arm.com,
 lorenzo.stoakes@oracle.com, usamaarif642@gmail.com, willy@infradead.org,
 corbet@lwn.net, npache@redhat.com, dev.jain@arm.com, 21cnbao@gmail.com,
 shakeel.butt@linux.dev, ast@kernel.org, daniel@iogearbox.net,
 hannes@cmpxchg.org, kernel test robot <lkp@intel.com>
References: <20250910024447.64788-2-laoar.shao@gmail.com>
 <202509110109.PSgSHb31-lkp@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <202509110109.PSgSHb31-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: BCB3620008
X-Stat-Signature: k9o6p7hj8obyj4e99dinyob44g3anmaz
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757556788-701582
X-HE-Meta: U2FsdGVkX1/p7DtoDRsT6pl+1b6UO/dBZvo4+B/a+kfgtYblbE7vP4tJxfr69lLrI9k0FalEmN4CyNUj6nDpF+mc5uufKzMxeEuCTTNI96GKKDrUyZwsObFwB6RzDw4EBlCbLvZ8UG6/24UG/JdHUjvV8eeXy9hAFdIfK4h3VgTiBJWm2+tGASh/tnTB1Q95OkkirQmx1eOVQ9g3TD9u349Ezlm8zmAdfJqa9r+yIzdVbVEk23LbUyV9VGDBFGDe2SiASnngpD5ebcELc7/EJNi1shqAP+2MVu02DqTEBvIiPMxsBZFPSXDhAE+fI4UHkPwz/y2esMdxJ6LIoPGncs0Oqf51xxyXDbKxFRYdV7//+JI9ZEdinh9Cvj+k8KQGYt/Qy4oovU6SIj6tx+9M9PG8L/5+3AoY1migXaVqAfD9PpLR0pHNKBo+QvnyjgZ03m+pqgd1GWvJiC+yCZzCAYc3+25n3zu8We6Xc4gGUjA70GbXCyIl4E/b2wUY7Cey5EEBTLCc+sdfHOaSm1i9dFbE/nbHLVprENA0uhJ53dRIK98HeH8hBoqkmo8OeBMeMpiUYG1uXoO8Yxe29wJ/eJov/qhoZ0xryeDYgnLQKet0OwfJOPmdnBNVwb4L7xTy1zTmivjfBfwXhvgMHQ0sGB1Y+5/OR4U40qLDWliSf2A+9J5T0+6jZJbRiFCEESzJSMtYnP6qudT7VnCKv2KrSNVtcRUHmHt26mKpYJAZ5KSpEQQtza0JHhlNlEYkglHMncPlFfnjYn5hF8pIZsCHApuO+/sFkKoo4PFw40J36uuCFapDtyIrktfp1ss2Lg511EZHovtzJsz4w3DvaC9qPCuPmnlOFXfX3KGJmFO5+Xko40pp6PzIVoB62hMCCLZ9sUZyQ4g8cUq8L51X43Rmvr3ehhc4m2k2NvyrEtD/L4+F7GMKraPhrULUbclpFkS4Cu97xBK1WuOOQwcRcdw
 uQR1QSxj
 f1XVy6CWir1hPppCcX4JK2sQYH/TgRtWhTsLK5Wi92OZgUuT3k7RsS2C29GGJkMe/iU7EiKnWnDCV3/8VFAUPvXX90yZN+jyB1NoquwHdiNVwDo4FUyqU9dnvP4zI9NKwOQRHF8Ofs5IdsmbgG262nwD+QwfQc9cmhPYmugcNoMYTIWl/xYTzIGXRDr6pQaU+Z8/2c0F5hluNVAnwwB1gbdxqvbxDOFYPSHnjI6RY9yJD7o1mYULi/Cb98vWf2xKfCNSPcU7GmoA8kvD7MVwgK8otWg2JTATxwuP076QKOJVCIPx8SvB2yP/3B5TJlxxh/zosef30H1HMcLYqExOqopWy6VZW4APh0rLJRhlEVA3UpJSvDpeyaXPESqY0l94InKuhiIDp89dEkZTnxnBCLG3FELZS8hWe0h7mq/8wVFTni0O8vBv/75xza7tg9ThqVTxZVROq+mnDYn4iZrt8VnPqvuWtTfk5HEls
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yafang,

On 2025/9/11 01:27, kernel test robot wrote:
> Hi Yafang,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on akpm-mm/mm-everything]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Yafang-Shao/mm-thp-remove-disabled-task-from-khugepaged_mm_slot/20250910-144850
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20250910024447.64788-2-laoar.shao%40gmail.com
> patch subject: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task from khugepaged_mm_slot
> config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20250911/202509110109.PSgSHb31-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250911/202509110109.PSgSHb31-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202509110109.PSgSHb31-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>>> kernel/sys.c:2500:6: error: call to undeclared function 'hugepage_pmd_enabled'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      2500 |             hugepage_pmd_enabled())
>           |             ^
>>> kernel/sys.c:2501:3: error: call to undeclared function '__khugepaged_enter'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      2501 |                 __khugepaged_enter(mm);
>           |                 ^
>     2 errors generated.

Oops, seems like hugepage_pmd_enabled() and __khugepaged_enter() are only
available when CONFIG_TRANSPARENT_HUGEPAGE is enabled ;)

> 
> 
> vim +/hugepage_pmd_enabled +2500 kernel/sys.c
> 
>    2471	
>    2472	static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
>    2473					 unsigned long arg4, unsigned long arg5)
>    2474	{
>    2475		struct mm_struct *mm = current->mm;
>    2476	
>    2477		if (arg4 || arg5)
>    2478			return -EINVAL;
>    2479	
>    2480		/* Flags are only allowed when disabling. */
>    2481		if ((!thp_disable && flags) || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))
>    2482			return -EINVAL;
>    2483		if (mmap_write_lock_killable(current->mm))
>    2484			return -EINTR;
>    2485		if (thp_disable) {
>    2486			if (flags & PR_THP_DISABLE_EXCEPT_ADVISED) {
>    2487				mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
>    2488				mm_flags_set(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
>    2489			} else {
>    2490				mm_flags_set(MMF_DISABLE_THP_COMPLETELY, mm);
>    2491				mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
>    2492			}
>    2493		} else {
>    2494			mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
>    2495			mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
>    2496		}
>    2497	
>    2498		if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) &&
>    2499		    !mm_flags_test(MMF_VM_HUGEPAGE, mm) &&
>> 2500		    hugepage_pmd_enabled())
>> 2501			__khugepaged_enter(mm);
>    2502		mmap_write_unlock(current->mm);
>    2503		return 0;
>    2504	}
>    2505	

So, let's wrap the new logic in an #ifdef CONFIG_TRANSPARENT_HUGEPAGE block.

diff --git a/kernel/sys.c b/kernel/sys.c
index a1c1e8007f2d..c8600e017933 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2495,10 +2495,13 @@ static int prctl_set_thp_disable(bool 
thp_disable, unsigned long flags,
                 mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
         }

+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
         if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) &&
             !mm_flags_test(MMF_VM_HUGEPAGE, mm) &&
             hugepage_pmd_enabled())
                 __khugepaged_enter(mm);
+#endif
+
         mmap_write_unlock(current->mm);
         return 0;
  }

Cheers,
Lance

