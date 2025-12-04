Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93207D20692
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 13:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEA466B0032; Thu,  4 Dec 2025 08:38:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D74826B0062; Thu,  4 Dec 2025 08:38:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C63466B007B; Thu,  4 Dec 2025 08:38:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFA0B6B0032
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:38:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CF254F9B7
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:38:48 +0000 (UTC)
X-FDA: 84181893936.03.F22B86E
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3CCF82000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:38:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PUUuvYek;
	spf=pass (imf13.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764855526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4YCKnZkbYPllJg8tAyg8KkLXrCsah/wRtrAT01nAWx8=;
	b=e4yx/leT1+egPuj1B3xU0dYtm6o3/yP8zKqSSjX+h1tHLD3HA6HV4/p/RvwY6eFjaZn+tk
	a/4ndwDdvnSoKkj7YB065I8NI9cuTzSU1z7HVlfkEfFlKSEzrhEnRharA4TgjJHSAz60/w
	aifr0Q4DHWOtQpNtxm5XtDQ6O7wDdnA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PUUuvYek;
	spf=pass (imf13.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764855526; a=rsa-sha256;
	cv=none;
	b=ZraebwRpw1qRMW6RNl4s2qmqbTNjRKaT5LOX+v6wlmhR40HOkuI/m7W3bdCghsS2v2Kq/D
	9h469J2KyGWPTNqilkn6O1HRrX4D3fI2RFa8PJY1FKdB5hCWatPtbXiJnrVlhLl8NR/ZcO
	oHv1uUl5Bt8YQIY3OkQ0PNPtvSy7JZo=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4779adb38d3so8617395e9.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 05:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1764855525; x=1765460325; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4YCKnZkbYPllJg8tAyg8KkLXrCsah/wRtrAT01nAWx8=;
        b=PUUuvYekvkfrQZHp6dXB0Cfp2JXdbMTwEra/7Mzsh11zpaP3ybGxPLRM5TMfc0Nt8z
         p8tCvx2/3/2yWkW1b2ZsHVJuVBOMamf5kZHTvT8CltzgnLw4FWNZOJKX9aiOcZ4yTMMf
         m013ZREl8LZHq3W8+nnwfsYfD9KolgIo/JKKZHv4bzIJwGD32OH8nhvuTyZ0934pMpZq
         shkZPh1fynIV1pTGJmE8L83IRXVMSuM/TrJa43D2RxhsZ43+QBoOBZnIpA8U/56n0I65
         1j9WzID8+vh7YoKo/w511u8Zgt96wIQD2f4HmCp3NyNru5VVVQzb73zahSFn/3mkhO/C
         5Chg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764855525; x=1765460325;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4YCKnZkbYPllJg8tAyg8KkLXrCsah/wRtrAT01nAWx8=;
        b=ouIp3Ghz80Xm5OsX3SDb1e72ROAA19jNhPHbHiLm5CzQTUtFrXFBeZO8xeUl8pW+dG
         y3ocRQrqqWGjYPbmcyddhHVb99Ik/gqFKV3J4W6tpPk8LhzXtl7O0RM2WMBT/nWif8mB
         5ekFwpOZ737h7iVqT+BleQ9ytaPlu7zV0H92QW1fOwE2qhW6J99L3nk+b/icTZEEY5Cb
         K6q4ljyDP3ULX2GvcSVIaakqux4bhqHikGfKxIe3zcHfZzPjL7PFhF/pN+BzcJMZzOh2
         E/SJo7seXUcH1ns+29aAjpjgwxTb5dW0ZsZ6LcZ2HJG9AhgETiGfJNnofHn+mYpfJV41
         ZgjA==
X-Forwarded-Encrypted: i=1; AJvYcCWK1dBpaLwfB1ZlbUv7V4e1+tTZ7apikdNZe4gTUVTDBN0vqIIMfwSLvAru/DzwWSgYzSizOhRqNg==@kvack.org
X-Gm-Message-State: AOJu0YyNJ6NcGtPTrnStiWZNSB79x3xlAi2fQ/s9Y6fP/eOJj4Ia+aqb
	gWs8AqBwUGF8ErCLkwh7GqDG/VEKnrW3vfoGexFXJ0QKlyi9eAjNTYmJIvhUEuUapwg=
X-Gm-Gg: ASbGncsi0LhNCp/f6FUJE1NPR76iMcpDPk9vDNC0WfThvLNZgSE53D03N3xMdQBmy/6
	JtZZ+g7Re/F4ZDSTx3TctY0mJCdXVvNCIBaLSu6oSvFClgk0zwYRdM0dtQ2poQM9yNTSk4su3AB
	oDKzz19/xKjfKrWQW03HWFAKigWqgQXC3gQMboq5OVgPFRFGHXTN691jBS5xA/dlpGifheYvq5H
	EeH99PxCH1zXswBptS9xF54UU51uYtWbfgRJZVRmHdzuRa3km+SjO+z5MvYug5qrrnFvQRVvk67
	oFov5oqHeqvVYjHgoDLQxZ1j8EA4WPRdHEErDSG/h2aroOj9E3WLepS9wc17EdHYofwiCmCU2wS
	33CqwF4V7WV7w43rtJopgs3QpItUiQAXrAodXij9jgly2rqio3671Mql6hUGxZ5j7oMj01qr7aS
	T22480vR+olKALDw==
X-Google-Smtp-Source: AGHT+IH9J0bYH9Ls3TTcq6OjNzMt1GmD0xmnELYMfVYz4mP7/YBZ3MocmABVO9zMqGrsr3mVB9H00A==
X-Received: by 2002:a05:600c:4fce:b0:477:7658:572a with SMTP id 5b1f17b1804b1-4792f3861fbmr34011995e9.20.1764855524636;
        Thu, 04 Dec 2025 05:38:44 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47930c7473bsm53396255e9.10.2025.12.04.05.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 05:38:44 -0800 (PST)
Date: Thu, 4 Dec 2025 14:38:42 +0100
From: Petr Mladek <pmladek@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>,
	Feng Tang <feng.tang@linux.alibaba.com>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [linux-next:master 9966/13055] kernel/watchdog.c:74:22: warning:
 unused variable 'hardlockup_si_mask'
Message-ID: <aTGO4iLrQnd4l6fO@pathway.suse.cz>
References: <202512030920.NFKtekA7-lkp@intel.com>
 <20251203144453.be34d189c5e6668ce2da06b3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203144453.be34d189c5e6668ce2da06b3@linux-foundation.org>
X-Stat-Signature: obh19hpq9h1ip7af7kg9he1xc9az3mcq
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CCF82000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1764855526-201136
X-HE-Meta: U2FsdGVkX1+71tcqImw7xkq0l905p2qtx/G4jWF5DfcUOMKrj5xsaKnrxEeLAeN142hJcDBcMiQsq0IlnW4IGiUobdfKNhwixRfoYJmaAX+gh0O0r8AWbyh/ySvjfg8q5N25s2fLmvyZv999wt2YjJVffe3hVLsVQ6468ms6dlJ+XCsvHv1yvJONKQW/YkNL+a1KC7k2KzNJlAvG5V5gpRwRFKuUj+j2FQFkMZW2B39k+6MaZVU8+M+r+SUc30K0En3I0/QEj9FriQwSCPsfa/lwZgESe3zXof2C/zFKLT3dmOZ3mGeT4M57e+WqU1c96mp05eNrGwfWWaNy2Uxax7rCDjeB1q+6ZNGwN0kj08DpKZKxc+Z0MnyV8MxZwQnjzWr/J4S2FSt5WJ8I87d4JM/3Cjnt/sd5rro5SEDjRc17qsGts5hqZvXvSVdwUoWDzsw5I6AtbpjrSkURuQjZdVE6+K81RYEJ7LHTGxc/8eJwuPFIW7oGMFPWU85PwvhNdbZCp1cGl6bUqvL5ZS7dOgykYMNZqXqvuQzh+KH/oBWHwEHRbeMPpnZ3ppP85/6QFKIeGQV9hDACmYOfui4uvsEVHBcfa/jYC1trV+7bP8Z1yorQMvNczFRR03fuxFf/QJjuilvVWVlpQA2fIPtmMIkFVrViKPMqWEdiUZstegwjZwDJt2hrf10x5hdLaN6SpJHGebqu9EsZE8TJGyXLRwIJvdGJimGWIx/YX8CKOIai7R+/PmvyTk3VWp3x8YhTCbRWkVU/biELCfyHmox2L7EP+s+7N91O+A7LxVhk+0DMG1FjUKPCGgXq8OypgYJyYgruDF865HqNTnCVLjhqLHUlGVDJXpjHITztdWtNuWrBWxC8lU5C7CKHBT9FLoiXYOqu+Lir2rpsa8KYjF8oLPnRRWVG+BF40Ns51hoC5Yb/msMz+sEUymY2aZ6jKLp8BKpyOx7K1fch1ZWS+iZ
 w41QI3cW
 DJx/gkdMKmzJH9XKrOR/cTrM//8+yG7xyNQnpInSBNH5oJqWefcSffub5yFFllNwaJozASLubhIYqAw70EYFTmdqVuhWAz9MvIk2iRzxl/WyZGtJLtDlyM2oO1rnvM6354nz/s3KXfrbtgkSnPxb3SohXSey0gPQdnOVcPgbCqvhziugiOZ9n2D+6VhfL6OCDSUYnUwN65xxKMUzYdzluNc5gYRAV18b/QGO0drS6ynHP4364kJBsoiJpnmtTov0hqWoExCqqVHZ5/roovyvy32yCNocUVZMInF18UgMgz4bnOi8PylzGvsHpAcuQkfnXu5//+JVbmCrb7LkAjt8kNnZ3px1m7EgPiLX/znnN8pTMc6mV+HQkS5+2Y4ki9wIYXesh6DTj+RiphmfCSJPHuoYgpy+8dKojGZjJ4AKV+CElXrSY6i9qGnYwio27RWLvQSobFZmzdtO/f8P2twTqAVhgqsGJpO2zvOTgltxOssYSvCVOY4Z/ntuHeBWhxPp/54BeOI6lDZT9iFHFYwaszGipsP5NqbP8rVFgb4wVWgyt3rKXHfNQ8wrDTKwbQsuGbxYy/PFDBHK3P5sqI5lk50QL6QtzY2c0jn7PVfrR3VFnuz/9SsjoLGAxZL3DrzuZA4KS0RoWpswLbTFexE0Pcwwv7bUfUqxYdMLrU5I4xgYwXXzEWMhseeW0lvlpHx6u8u3j6jft5VMepPI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 2025-12-03 14:44:53, Andrew Morton wrote:
> On Wed, 3 Dec 2025 09:05:30 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > head:   47b7b5e32bb7264b51b89186043e1ada4090b558
> > commit: a9af76a78760717361cccc884dc649e30db61c8b [9966/13055] watchdog: add sys_info sysctls to dump sys info on system lockup
> > config: powerpc64-randconfig-002-20251203 (https://download.01.org/0day-ci/archive/20251203/202512030920.NFKtekA7-lkp@intel.com/config)
> > compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 734a912d0f025559fcf76bde9aaaeb0383c1625a)
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251203/202512030920.NFKtekA7-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202512030920.NFKtekA7-lkp@intel.com/
> > 
> > All warnings (new ones prefixed by >>):
> > 
> > >> kernel/watchdog.c:74:22: warning: unused variable 'hardlockup_si_mask' [-Wunused-variable]
> >       74 | static unsigned long hardlockup_si_mask;
> >          |                      ^~~~~~~~~~~~~~~~~~
> >    1 warning generated.
> 
> I'm testing the appended patch but it needs checking please.
> 
> The comment for hardlockup_si_mask says
> 
>  * bitmask to control what kinds of system info to be printed when
>  * hard lockup is detected, it could be task, memory, lock etc.
>  * Refer include/linux/sys_info.h for detailed bit definition.
> 
> but the variable depends on "COUNTS_HRTIMER".  The comment doesn't
> mention hrtimers and I don't see why it should.  Not sure what's going
> on here.

Good point! It took me some time to understand it.

So, powerpc implements its own watchog, see arch/powerpc/kernel/watchdog.c.
The watchdog is supported only by some powerpc platforms, see the
   following line in arch/powerpc/Kconfig:

	select HAVE_HARDLOCKUP_DETECTOR_ARCH	if PPC_BOOK3S_64 && SMP

As a result, the test system could have the following in the config,
see https://download.01.org/0day-ci/archive/20251203/202512030920.NFKtekA7-lkp@intel.com/config

	CONFIG_HARDLOCKUP_DETECTOR=y
	# CONFIG_HARDLOCKUP_DETECTOR_PERF is not set
	# CONFIG_HARDLOCKUP_DETECTOR_BUDDY is not set
	CONFIG_HARDLOCKUP_DETECTOR_ARCH=y

And "COUNTS_HRTIMER" is not defined.


> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: kernel/watchdog.c: fix unused var warning
> Date: Wed Dec  3 02:34:40 PM PST 2025
> 
> >> kernel/watchdog.c:74:22: warning: unused variable 'hardlockup_si_mask' [-Wunused-variable]
>       74 | static unsigned long hardlockup_si_mask;
>          |                      ^~~~~~~~~~~~~~~~~~
>    1 warning generated.
> 
> Fixes: a9af76a78760 ("watchdog: add sys_info sysctls to dump sys info on system lockup")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202512030920.NFKtekA7-lkp@intel.com/
> Link: https://lkml.kernel.org/r/202512030920.NFKtekA7-lkp@intel.com
> Cc: Feng Tang <feng.tang@linux.alibaba.com>
> Cc: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/watchdog.c |   16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> --- a/kernel/watchdog.c~kernel-watchdogc-fix-unused-var-warning
> +++ a/kernel/watchdog.c
> @@ -66,13 +66,6 @@ int __read_mostly sysctl_hardlockup_all_
>  unsigned int __read_mostly hardlockup_panic =
>  			IS_ENABLED(CONFIG_BOOTPARAM_HARDLOCKUP_PANIC);
>  
> -/*
> - * bitmasks to control what kinds of system info to be printed when
> - * hard lockup is detected, it could be task, memory, lock etc.
> - * Refer include/linux/sys_info.h for detailed bit definition.
> - */
> -static unsigned long hardlockup_si_mask;
> -
>  #ifdef CONFIG_SYSFS
>  
>  static unsigned int hardlockup_count;
> @@ -135,6 +128,13 @@ __setup("nmi_watchdog=", hardlockup_pani
>  
>  #if defined(CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER)
>  
> +/*
> + * bitmask to control what kinds of system info to be printed when
> + * hard lockup is detected, it could be task, memory, lock etc.
> + * Refer include/linux/sys_info.h for detailed bit definition.
> + */
> +static unsigned long hardlockup_si_mask;
> +
>  static DEFINE_PER_CPU(atomic_t, hrtimer_interrupts);
>  static DEFINE_PER_CPU(int, hrtimer_interrupts_saved);
>  static DEFINE_PER_CPU(bool, watchdog_hardlockup_warned);
> @@ -1250,6 +1250,7 @@ static const struct ctl_table watchdog_s
>  		.extra1		= SYSCTL_ZERO,
>  		.extra2		= SYSCTL_ONE,
>  	},
> +#if defined(CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER)
>  	{
>  		.procname	= "hardlockup_sys_info",
>  		.data		= &hardlockup_si_mask,
> @@ -1257,6 +1258,7 @@ static const struct ctl_table watchdog_s
>  		.mode		= 0644,
>  		.proc_handler	= sysctl_sys_info_handler,
>  	},
> +#endif
>  #ifdef CONFIG_SMP
>  	{
>  		.procname	= "hardlockup_all_cpu_backtrace",
> _

This patch makes some sense because the arch-specific watchdog does
not support the sys_info interface. And it is better than nothing.
definitely.

A better solution would be export the variable and handle it
in arch/powerpc/kernel/watchdog.c.

It seems that powerpc is the only architecture which could define
HAVE_HARDLOCKUP_DETECTOR_ARCH.

Feng, would you have time to look at it?

Best Regards,
Petr

