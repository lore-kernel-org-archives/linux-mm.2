Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6049D12D75
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 14:59:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15876B0023; Wed,  3 Dec 2025 09:59:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EED406B0026; Wed,  3 Dec 2025 09:59:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2A066B0027; Wed,  3 Dec 2025 09:59:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D23FD6B0023
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:59:04 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 675B98A90F
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 14:59:02 +0000 (UTC)
X-FDA: 84178467324.14.1F476FC
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D58420012
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 14:58:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SNR4Pvra;
	spf=pass (imf03.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764773940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZwfoRnUKDYgiUKWqxSEPC9CBqxWYSLdFbxtbeOENkE0=;
	b=pfIhg9g5YGAI4qiV7bKGPCOFcN2dcQ4Y0Tu2m5vaoUuDk3+4F/mQfkC3n9DQgYw49Ia94Q
	/G9nbkyYUJKA6SWJDKEJCZ/L/c54fn/574G64PEDoNxtoPQEjDdNCU3oubB4GOS3iQHdlb
	ksPIiCq2oHpOzPWpZGoeuRP3DRwpqq4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SNR4Pvra;
	spf=pass (imf03.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764773940; a=rsa-sha256;
	cv=none;
	b=l3reFczl2l7RlO1NFjV69pny85c3pn9/XFTBG9uALGvHyLQDWDLUJaDuiLUuNi8RE+rEQk
	qV9W+rp5MqGNC2n3kbxGnQjAGxtFdClnLxfJQ0UruJv68Iqa1Ev00eCd1RBswmvpquV+2m
	wNzZgpDS/3fEB9wPfnz6KxpWfxEgl1Y=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764773932; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=ZwfoRnUKDYgiUKWqxSEPC9CBqxWYSLdFbxtbeOENkE0=;
	b=SNR4PvraqVNV0muCG5/Qp5mt72bkwh0hHWouxuEzAA17vy4T8jScibisAHExVI2TCbs+WX7TYhfvT0PhXTuWPJBrHJlQKcTn3sdkdwRMX58NNj1bF7VpxKJFPLOI+1aui8y1cvY9muVGQHcgYE4MwebjxYXQkajyQSCqZIqUtQQ=
Received: from localhost(mailfrom:feng.tang@linux.alibaba.com fp:SMTPD_---0Wu.vsSC_1764773929 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 03 Dec 2025 22:58:49 +0800
Date: Wed, 3 Dec 2025 22:58:48 +0800
From: Feng Tang <feng.tang@linux.alibaba.com>
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [linux-next:master 9966/13055] kernel/watchdog.c:74:22: warning:
 unused variable 'hardlockup_si_mask'
Message-ID: <aTBQKNgyip6tOCEf@U-2FWC9VHC-2323.local>
References: <202512030920.NFKtekA7-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202512030920.NFKtekA7-lkp@intel.com>
X-Rspamd-Queue-Id: 2D58420012
X-Rspamd-Server: rspam02
X-Stat-Signature: 6fffeqwcyr8swabrzowmak4xah3krz47
X-Rspam-User: 
X-HE-Tag: 1764773938-520660
X-HE-Meta: U2FsdGVkX19REOS8R692haxkQmfXiwjqXnw+HsV0A6m8CifxynIEgqdkmIdfiZ4ZziMqCMa+9ISsrY8ssmy95uzRp8zMQJ47nrH8rAKtw3jJrL+8yzfEHV8wWj3Dc4Oe3geE4pIBe301zfu/erpW+tVBMaIGHM5NqXsQICwyW/8kPhat+4+OCt2RDVdW53X9gaBkNZMkIGjL/sXJ6WeQs73P93dUUTp2ZqjPf98GM/ZCITPCpKKASwryZSRCcXv+7m+TNAgKZ75fmnC55FumoUdawJ0BhFZaNkKvUxps97l8XgjtfJdWA/Tyoa5Bt1dtUUQGOUKy4nYAYBrZQu0avBTsdTe3/5qLnNMDVaWz1mraFLvLB5MZYLoeLzETCIL18bkmWy1f2VqtrVSPr2nU7OZqA2AAapycJAdq1TQ2s6Pmts1JDBkHQ1OT/eULCvEojuvf0fTT7QcUElw9nM2IA5H18Bi3m8ZRpPo0kc38Nos3QjB/FqxCc6e6v8ZyFzhfvZ0Ln8f/ejLE/oSENgZyhSsdYcgHUJfTj0A4SJ/J11esa0R9h7MqWeE+902TvkpNrlDE/9Yb5UH49ZrEooHjFW9dc0elegJDRZ25aeCW+Zzw6AQ69SmObGMr/MZxbfAyU5Geq2SRsQ2ivgYn/2ayu8R2xIZ36Z1SQSW8WI8BS85xqWz/Q0C5XksooLSi09tWxAIAxqXcpeJU94djb46daVSpYbax64WRen4CgFa86aXLxDmF+jPavOPdLwJseLvLTBu6gFPuA+bQTGan6pBPo3lbe3nmsnsxZemQ2b+YZn/BKe4Kq/S+Ofc5evpLAan9iNwCd1MQJobl/rg4tP4xT3KsIkpFBnoeHbILl03ucihdOzgWbps7zRs0+hPP85Ssd/exzpcF1ug8/pUY/BfkkfSA54dH+DWXFI9TVf4Pu2vuL0lM6sENh9Yo4j5lzH94c1zwbiXp3ebcJBh74SC
 PH0iuHIW
 ilmIWY5JtZL6DoRju+rkELIf9+fYL3GSY7WZkPUFOrv0bv/BhYTJ26bTafOPrUSZEki9qv0vO/SlnD4j2fghPugRhPHxfj5n+/NHy+V0Yj1Wbx8+eWh2bZl82cdAGE43/fZg3sBY0vjtg8nVjuVDH+NQbpFQS2q3suG1friOpnQ5S5TqcS0AWXk1rH6YOO0KQGMFrvVLoisCbryYRGUTe7POYOnN0eRENEDxw7b/jIKZ/e+rl7pHNOam5b2E6p+/6vabD9gtVxhmdNJZHs89D5zzDxzyA0JDN61xwFf5J/M0VSVt6CPbmEkAP+Op+GZf3s5hByHMXfSXgpNPgR5VFUXu+Mm4nMlWQlUEPzerEB1pdtnFnIlcDL13pzZEXPR6ZDhWu1U3/Gr9ZBBL2U63Pdw7NCynF54Q3k3bF+Gganh/J/8s2dheynDEFlFIC+ZQ0imi2lJycg1ylKVMzuQ/q8dnZeXc4drUPzgXggNYMvMiTt6s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Thanks for the reporting! 

On Wed, Dec 03, 2025 at 09:05:30AM +0800, kernel test robot wrote:
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

I can't reproduce it right now as I'm on travel and only have ARM server
to use. (The reproducer need a powerpc64 machine, or have a x86 machine
to use your reproducer script).

Could you help to test the below patch? thank!

- Feng

---
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 1f59b950c475..5e5ac82a01f3 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -66,13 +66,6 @@ int __read_mostly sysctl_hardlockup_all_cpu_backtrace;
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
@@ -141,6 +134,13 @@ static DEFINE_PER_CPU(bool, watchdog_hardlockup_warned);
 static DEFINE_PER_CPU(bool, watchdog_hardlockup_touched);
 static unsigned long hard_lockup_nmi_warn;
 
+/*
+ * bitmasks to control what kinds of system info to be printed when
+ * hard lockup is detected, it could be task, memory, lock etc.
+ * Refer include/linux/sys_info.h for detailed bit definition.
+ */
+static unsigned long hardlockup_si_mask;
+
 notrace void arch_touch_nmi_watchdog(void)
 {
 	/*
@@ -1250,6 +1250,7 @@ static const struct ctl_table watchdog_sysctls[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
+#ifdef CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER
 	{
 		.procname	= "hardlockup_sys_info",
 		.data		= &hardlockup_si_mask,
@@ -1257,6 +1258,7 @@ static const struct ctl_table watchdog_sysctls[] = {
 		.mode		= 0644,
 		.proc_handler	= sysctl_sys_info_handler,
 	},
+#endif
 #ifdef CONFIG_SMP
 	{
 		.procname	= "hardlockup_all_cpu_backtrace",

