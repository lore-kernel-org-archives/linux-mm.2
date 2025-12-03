Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE5FCD1CDA9
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 22:44:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E292F6B0022; Wed,  3 Dec 2025 17:44:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDA536B0023; Wed,  3 Dec 2025 17:44:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEFC06B0024; Wed,  3 Dec 2025 17:44:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBD996B0022
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 17:44:57 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70871160779
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 22:44:57 +0000 (UTC)
X-FDA: 84179641434.27.6380CE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9A518180008
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 22:44:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=teBeR5Jm;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764801895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/RmJtxbeGi6mWoIUj60Iza+z4p64cnX0BW2tW7vyjyQ=;
	b=6pjchG8mPvve0cwl4w7BPGmTzqaLx0371JD624hHVAHtodsCp6wLpOHwm59iwI+J8rsiak
	/IOjtfCjKB1B80djODCAxaP/PcHDLL0QF/6dWV5NbE8oF4e87cMksYs8VglsqqGhSnJMkX
	DQcx8+5WGmJ8yZMh5q6eyex9EtaueYc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=teBeR5Jm;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764801895; a=rsa-sha256;
	cv=none;
	b=redx+nh5ohwVtHVDDDteSAZi3bur4gEGa3xKvspLf5LNUCb0QtLL3ShU07VymRnxx/Xbrc
	Ii/qhMFZRKX0dAXrV/giLxlviPSFrr2qzDP5oUjvjW/COvxCZWxMnD34VGtH3jSX5anAY9
	ElzZhRCI9eGULTc9h5cxVkW+KF1cNec=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C78543B7E;
	Wed,  3 Dec 2025 22:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415DAC4CEF5;
	Wed,  3 Dec 2025 22:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764801894;
	bh=4Uj9vmf5W51Hq1VXIv7uGJ3HGRMZgiH69aSNHXLBM/A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=teBeR5JmucF/aVSYNvWbrQMxjrj1aDFVSGSjka5MJN9DX0cUY+g95fXVemCkWQs4J
	 WZX7YA1tTnhHEeqTo0FPPHuBnn9BsXt1fON1Xmf/qYeRu98AVU3ZazEGFtzaW39WX2
	 1lw6h+xbEkpLRCsPYdKxugGHQ9rVC3K+9b9NQOW8=
Date: Wed, 3 Dec 2025 14:44:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Feng Tang <feng.tang@linux.alibaba.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, Petr Mladek <pmladek@suse.com>
Subject: Re: [linux-next:master 9966/13055] kernel/watchdog.c:74:22:
 warning: unused variable 'hardlockup_si_mask'
Message-Id: <20251203144453.be34d189c5e6668ce2da06b3@linux-foundation.org>
In-Reply-To: <202512030920.NFKtekA7-lkp@intel.com>
References: <202512030920.NFKtekA7-lkp@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A518180008
X-Rspamd-Server: rspam11
X-Stat-Signature: bfy5amqxkh8podmbqcb1qc7rd8ghggen
X-HE-Tag: 1764801895-760492
X-HE-Meta: U2FsdGVkX1+bUAs3s55B1lTKWSDd1AvtQy+uiy6xV6njMYDDBoB2E9MJtR7uIQRb7Dopv2RyU4/zDgm3cZfaH9f86yr3sBY3j8wnC5w1D+F0amt3ndHqj7VZ8JbAq3qt/1ymMRpGMGZzvNiy1WDPV2wd3/HG4mvdVo+Q0G+yIivstSh1qGTEDeXXzAB61aTfsWDL77QOLC4Xtwk0ad1UQVvniHFHCX7K5A6JRlyiEIBcQBdryH8nuJD1V0luNoEbzaERTL1vY1HCpl8yPFdItu3oSu5cEI+2vBcuHixLuQqYpBq6YE4+kfe3lgSBOs2ak/03ug13vr4qfKCOvra2Uqy84w4bwfhXhVFHNCdHDxsbi1YZAYrOoQIsJbmOuEGO6Xwpn3CPG5NtmZbxbgojYqBUW9iWhqTDoV33iAYcTuMqKGdl5NVh7CMV3SNKginuSKxDBktIT8NRrq1Lu7ajw9GA2FGULiSAbn5sKPgUHCFCOYNS7M46r44Qe3RjIQG/mUCW8mmd+MNhH1q4itdrDursmYwwr/eXV0IUYiK90shFy/xQmVl8n8erhYIhEPWCYPE1uT8tZ97M6oBQ+TEwCajFBcDUDv2l/rxyFGXMs8tCtst0PMZXnUl+4CEy/+TC/P7VmG7zjkCpk7BQlkNl1gY81K0o85qYZX9mv+SNrqkt0m3xJSBMJKNko3AJMMypqjKRPsUWCqBNntJUDMiuq/TsaFNQR1+eghBE2tijviOEANr0iWra0ykFg1aSzfP7T4kE4DyR0lsE9z8hWJJrhMkxGDkUYX0ydhpt+auWABHflleTo+DDGxwc/aOd2uAunOdVvgw29CAtpc2A20M2bjZAzOd4aVWPqOkkZVZuxWiiD4xOL7dDJRZLX4aErXziVAruxiuATwNC1IOs434V6nM7GKnr538w0Z2A+BWSdWXe4N+GOu2+AOHyMKNOeFowl22ZEwCOpoc7U+rA3aj
 nR4RkN5N
 liOPh/h6FKsK5VTcw2dQIWfcR3Y9tFijwVFafJXYbZjdA/62HEbz3Wt872s40uD4wq9SMLkvvqRBCApe1luggXiVmPGfJSlKE9B9kZJPhiy+G30bUs4f6sS0g+h9K6hBkxojikyN0O3N6Swhi2uWn2X3I4h4/k+oP2innAYW/d4IPq4rm34zMyJnU/mUH+DscsFbVau1hgBYJhloMMVLkWBq3FP9D2vDvd7/XlTMJX7uU9IcbnxLeLXaoTbYz04wao+UvSOeI7s8Gk8GQr79KERtXLNB8phOQHu3qDLrkJrubyzkJYUzHSHDmhqVoT6QyJXXLIYMBSmJV+Xcz2fhB0Yg5J/jsKjTRChaaiESk8zOYnFkPYLXV3BYkhrLUjAEV2z0za/O3PHDQqlac1vsd300hBrAjdzfjyuKhBbnumgLxu7oX3EtJdqOFjTKS4Prh5c4egpJSUIkBMJ9eji4OIm4yvt25yinz4u4U13wjZo53f6rirZmEdV40XDMVa2haTcJUzqulzq6u3yvFHLHMD1YChcaJQK+jybaXm67ZGHVH36HgMCkw5/nMElik0PM/1Ovl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Dec 2025 09:05:30 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   47b7b5e32bb7264b51b89186043e1ada4090b558
> commit: a9af76a78760717361cccc884dc649e30db61c8b [9966/13055] watchdog: add sys_info sysctls to dump sys info on system lockup
> config: powerpc64-randconfig-002-20251203 (https://download.01.org/0day-ci/archive/20251203/202512030920.NFKtekA7-lkp@intel.com/config)
> compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 734a912d0f025559fcf76bde9aaaeb0383c1625a)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251203/202512030920.NFKtekA7-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202512030920.NFKtekA7-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> kernel/watchdog.c:74:22: warning: unused variable 'hardlockup_si_mask' [-Wunused-variable]
>       74 | static unsigned long hardlockup_si_mask;
>          |                      ^~~~~~~~~~~~~~~~~~
>    1 warning generated.

I'm testing the appended patch but it needs checking please.

The comment for hardlockup_si_mask says

 * bitmask to control what kinds of system info to be printed when
 * hard lockup is detected, it could be task, memory, lock etc.
 * Refer include/linux/sys_info.h for detailed bit definition.

but the variable depends on "COUNTS_HRTIMER".  The comment doesn't
mention hrtimers and I don't see why it should.  Not sure what's going
on here.



From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/watchdog.c: fix unused var warning
Date: Wed Dec  3 02:34:40 PM PST 2025

>> kernel/watchdog.c:74:22: warning: unused variable 'hardlockup_si_mask' [-Wunused-variable]
      74 | static unsigned long hardlockup_si_mask;
         |                      ^~~~~~~~~~~~~~~~~~
   1 warning generated.

Fixes: a9af76a78760 ("watchdog: add sys_info sysctls to dump sys info on system lockup")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512030920.NFKtekA7-lkp@intel.com/
Link: https://lkml.kernel.org/r/202512030920.NFKtekA7-lkp@intel.com
Cc: Feng Tang <feng.tang@linux.alibaba.com>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/watchdog.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/kernel/watchdog.c~kernel-watchdogc-fix-unused-var-warning
+++ a/kernel/watchdog.c
@@ -66,13 +66,6 @@ int __read_mostly sysctl_hardlockup_all_
 unsigned int __read_mostly hardlockup_panic =
 			IS_ENABLED(CONFIG_BOOTPARAM_HARDLOCKUP_PANIC);
 
-/*
- * bitmasks to control what kinds of system info to be printed when
- * hard lockup is detected, it could be task, memory, lock etc.
- * Refer include/linux/sys_info.h for detailed bit definition.
- */
-static unsigned long hardlockup_si_mask;
-
 #ifdef CONFIG_SYSFS
 
 static unsigned int hardlockup_count;
@@ -135,6 +128,13 @@ __setup("nmi_watchdog=", hardlockup_pani
 
 #if defined(CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER)
 
+/*
+ * bitmask to control what kinds of system info to be printed when
+ * hard lockup is detected, it could be task, memory, lock etc.
+ * Refer include/linux/sys_info.h for detailed bit definition.
+ */
+static unsigned long hardlockup_si_mask;
+
 static DEFINE_PER_CPU(atomic_t, hrtimer_interrupts);
 static DEFINE_PER_CPU(int, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(bool, watchdog_hardlockup_warned);
@@ -1250,6 +1250,7 @@ static const struct ctl_table watchdog_s
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
+#if defined(CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER)
 	{
 		.procname	= "hardlockup_sys_info",
 		.data		= &hardlockup_si_mask,
@@ -1257,6 +1258,7 @@ static const struct ctl_table watchdog_s
 		.mode		= 0644,
 		.proc_handler	= sysctl_sys_info_handler,
 	},
+#endif
 #ifdef CONFIG_SMP
 	{
 		.procname	= "hardlockup_all_cpu_backtrace",
_


