Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35BA5FF60EE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2D0D6B008C; Tue, 31 Mar 2026 05:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DE0C6B0095; Tue, 31 Mar 2026 05:22:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91B376B0096; Tue, 31 Mar 2026 05:22:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 829D76B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:22:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 194028C8A1
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:22:41 +0000 (UTC)
X-FDA: 84605818122.13.B7EA039
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9551040007
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:22:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=F3aJHz+y;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774948959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=x9g1hB4qh9BcsuasyLunx9CoEu2jWdluCWl9ILvIuO4=;
	b=1rSrfN1r5KeFDjoXQ2y5NS78SvGjxbyjxxmGL/iCabknI8z23Ob32Us1JX/Zi6OBbFU+NY
	RDhqs7AJM9f28tvLpwwWw9LOjsjzfm/iiC7XubYStTOeZT0O452qFP96yolfBnhrzKoneK
	+2edmnDULCryMpaAyx8gqRWSROa1XSw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=F3aJHz+y;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774948959; a=rsa-sha256;
	cv=none;
	b=6Lbq4OGJUHNGQ3omvB0ZI8QXydlh1Z6mTR6XGsHJAfy/KyFnwocT6ohFkUeJKpHclCzIPI
	WNj6Pwd53fDsC7gfqLgORlILHMB3kS9VZM7dBSXI5xeZNUbo/pjVL2oNLtK1OE5usDADnn
	L2Sxdpm3Bn6VuKm77fHRi1emH13a3RE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774948958; x=1806484958;
  h=date:from:to:cc:subject:message-id;
  bh=NYW/PgnTXeFfdpQ4jOEdzfB4bwLYS8qx2Tohk7uPTYE=;
  b=F3aJHz+yWKpb0yvTqHzB/0AbApdEJFyfAKHCXAPrGYpFLFcyUcQ5Y6+f
   HbvReeNK6wT5L0KCkNElEnEx5dPJfdDf5kiw2CA6oLJ8UczTgkzVRnO3O
   33mXehIDYjAqRsq5y0hKfqKymv50vsLdH1TbZWcwMjKWT5o/UB26rMH/U
   z9aXfKUSyPFXJ0EmfeYGRHO0rmoBpvjhlp0XvOC3q09zdMqm1Ia1HnQah
   xZIHY/r5EwUsBkpObpHrFD3P+6AQvlE6YizdW5i4+Ckf+8cAfNa89872+
   OhrFJ1nh1WWd+shZSVCXtrInCA4+qT7k2Tn+4/4YR6F2NyKrgpxrKFGFI
   w==;
X-CSE-ConnectionGUID: i+rOdqLNRLWY5UQRLTegRw==
X-CSE-MsgGUID: WDExQ5f2SJKWMAjX9qmRMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="79556600"
X-IronPort-AV: E=Sophos;i="6.23,151,1770624000"; 
   d="scan'208";a="79556600"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 02:22:37 -0700
X-CSE-ConnectionGUID: aPjd+e/3SNmeZMcpBh/5+g==
X-CSE-MsgGUID: 5ghivsf7RHe2m5nX5FA/uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,151,1770624000"; 
   d="scan'208";a="230379274"
Received: from lkp-server01.sh.intel.com (HELO 283bf2e1b94a) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 31 Mar 2026 02:22:35 -0700
Received: from kbuild by 283bf2e1b94a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w7VIu-000000002Sx-2er9;
	Tue, 31 Mar 2026 09:22:32 +0000
Date: Tue, 31 Mar 2026 17:22:10 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-unstable 157/186] error[E0277]: `*const
 kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
Message-ID: <202603311743.uZYPu1Gn-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: gatac96ay8qjxw9gqx1r415penmi4mse
X-Rspamd-Queue-Id: 9551040007
X-Rspamd-Server: rspam09
X-HE-Tag: 1774948958-673810
X-HE-Meta: U2FsdGVkX1/boH15LlExp0JSk8ubCCpUXbPXw0epUBgbBJoFiK0t6cVwwMKKDtEaqqkS73uqu4rHEya08HmgrrsOGLl8/7nzFti5ycFP9UElmZ04FbWn0hkCuspv2cYoEekSkZE3mgkn7Cpcn9GAr+gytkM/XbxR6H/amrOgcBEXzawTI69c1I/6Qz5YL/NPRJ7e1TLR/nSiRne1AUCU+XPnhQMnSSWtR849aRrEY4azAjvzu4ciXTsqwTeAs02oxRVKSjmklC2xWjihysKGhxkBT6btCfJ49seE5ulArEmKbgVCJAxY7H+/7zKIZYQBvCGSKHG412guSQjCP1Frf/uFq/30bEnQxjEZqqHqcZ6sc8LPulqY/YDJKp//1okWsmDG0axMhBetydTCuiHzfOhPmBV9mo6u9TeW72LVy6fn832pDK9BDyq2SrucWfK4nHfhK6GrWHTPvCPD7Vy/bi+FIdhRM+YgneE+NuCwYtJ89+qd4y19O55UFOSiOvjEmFmQ+M06r6vvnTjZHUCu1JPNnZZTnwLTYBE87TpexcSKwcEH76Qdqq/FnxI7ejfKl7BFaWVUCFjTSjf1tCg3hP1eO+gQN4p81pbGPR4dpZ3ubnpgMQhs3QNX17yUAk6hhtV5cH510iPRXNH+2mjuB+tIpL+Gy+coI/JKx+joqbYvBx1Ogd1k3r+qRJ18/BgoCjJOmmvKvcdq9PVuZSF605ZtUHmYs+2Oq0nx5tp2LpYpTk2aQcOuzXaGMxOLV56WPtOcDF/NCrhBCuBQUHj2D6332r5Ts+jNt9sVFgdVtM6N2Cg6u4IdV4UE4EyqHLzuZ61ze+jU7rYQIaAu2sBuk53XbIktg5qk/AkoC0I03TVO3W2xAdSaOOP89CQAFWCo+9rl3r0ROgYyrkHIBz4zvrdTeOS49Hkk39yYr9BPYAKnS7t96eHVgJ0bJJvR2MPcqgJo/AEZxnEmHecHQKN
 urb1++Qg
 H3YAqsBrnUpn5lhw9R0EheZPjGHTIo9unwG9moNwM0vIlUpn0BoDHO7oJR6H/rBkLkM5Jvh6yeAp2Kv8IB0ISxS5cy7wZFR65RxUg07jrwPPiU54rq9LLBLISfdZcYkU6m3AgW0sp04iEjn0WioWy3MkOxZad8YvfpLST8Gm4t6yJ1I+UDKCqgiqKdg0OVMu0CC3dbJtdytyE5zlwRjU4n/6hZHlV5k/8m+xa9dyO9rqxVMO9uNs3Mofo9ui+fvpz1BAl14egpXFE0CqPDY0W1Lp6c3ARuyu9Ga/4JhYW6M1XeWOIWe77jnA9VXxYf7cV4oyG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   24e341657c283c965e3bfee0baa9ed0376127973
commit: d310bb41720b8e81d704444fec89e62c286dc9c7 [157/186] userfaultfd: introduce vm_uffd_ops
config: x86_64-randconfig-r133-20260331 (https://download.01.org/0day-ci/archive/20260331/202603311743.uZYPu1Gn-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260331/202603311743.uZYPu1Gn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603311743.uZYPu1Gn-lkp@intel.com/

All errors (new ones prefixed by >>):

>> error[E0277]: `*const kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
   --> drivers/android/binder/page_range.rs:146:23
   |
   146   | static BINDER_VM_OPS: bindings::vm_operations_struct = pin_init::zeroed();
   |                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `*const kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
   |
   = help: within `kernel::bindings::vm_operations_struct`, the trait `Sync` is not implemented for `*const kernel::bindings::vm_uffd_ops`
   note: required because it appears within the type `kernel::bindings::vm_operations_struct`
   --> rust/bindings/bindings_generated.rs:73862:12
   |
   73862 | pub struct vm_operations_struct {
   |            ^^^^^^^^^^^^^^^^^^^^
   = note: shared static variables must have a type that implements `Sync`

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

