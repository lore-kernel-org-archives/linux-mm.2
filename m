Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37117D262B2
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 05:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 649446B0005; Wed, 21 Jan 2026 00:40:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CCE46B0088; Wed, 21 Jan 2026 00:40:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D88F6B0089; Wed, 21 Jan 2026 00:40:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3B9796B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 00:40:44 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D7C708C483
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:40:43 +0000 (UTC)
X-FDA: 84354871566.08.7D6936F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf08.hostedemail.com (Postfix) with ESMTP id A62AD160005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:40:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Jq1KAf4q;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768974041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFSfRGYOT2F2KENM90G8Mnr/UNeilUT7xrFDt9NZSOA=;
	b=c3i1eW3m4YAhMq/tQH65kJ8EGaqe6cxaX8fnjZFul84QjUVr1sEyiLLlsw8HYnpHWpPaJc
	IgGnsVuwc9rqqcCVVPYapgDZXfK85FO/UkGTz+uWXVw1avmsSNe9f5+lEftLqSgiRo0I45
	+xmSuXE3BxUbUFAb/+OMsTIYnDNVbJA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768974042; a=rsa-sha256;
	cv=none;
	b=h3f/ylL77Jr4TGEPgOfLUmW6E/y9cwf+LtyrbybftRUQcZ4hdZE/zVJNxv8+mWU8kgwhYR
	bs6aaUDamz8mjZN0N62Z5F9sCszeTPlpBhyG/p9NJYUn77MRsxTsKH8wKcZorZ0Yqp93XP
	MOmzHla4iuz5t+gy2yMV4wLjwALwznQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Jq1KAf4q;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768974041; x=1800510041;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Zx+SBvi0ayiSjILiYD+XZDq1nslSNFB+Y/17FI4keB4=;
  b=Jq1KAf4q66IAYsdr/DZ8L0xiOU+NT5aMlkLig9U99TFEOkVopF6Pa/ee
   8VlrCAXon+krdUYTApe2TI3DqI8nLSDk5QshNxHHIkoL5nbIa8vGbFGxA
   K8s1x4y3rvoCEbVjIV+MLxMB6KDI3CDSndisbjagLFb41Tz+ZRJeuFe5y
   fTtHUsNy6r8kmCHmoHc1P7Nw63L81MwmnqXIR6edfCHAgrLKlAsPHsWnK
   0/8YlMLTMwMqcE+JsZuH+fSwF9wzCRoJH+gLGY2Eyc9UCOI906GC0FfWI
   sisOYB60zxbo57k7UR3UyAK55TSDzzVMH8J9C8VkHvzFy5GM024SvClqT
   w==;
X-CSE-ConnectionGUID: +GwjWiX0Rt+NmHXLXRbw4A==
X-CSE-MsgGUID: 24K53ZhvSOq8EZDKRfHvfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="87608250"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="87608250"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 21:40:40 -0800
X-CSE-ConnectionGUID: yIdPUrdgSiybgm4rI91ngg==
X-CSE-MsgGUID: HUtRvEKGQIavCBzlQuTQmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="210796208"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 20 Jan 2026 21:40:34 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1viQxD-00000000Q27-2Z5X;
	Wed, 21 Jan 2026 05:40:31 +0000
Date: Wed, 21 Jan 2026 13:40:30 +0800
From: kernel test robot <lkp@intel.com>
To: Breno Leitao <leitao@debian.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	pmladek@suse.com, john.ogness@linutronix.de
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, asantostc@gmail.com, efault@gmx.de,
	gustavold@gmail.com, calvin@wbinvd.org, jv@jvosburgh.net,
	mpdesouza@suse.com, kernel-team@meta.com
Subject: Re: [PATCH net-next v2 4/5] netconsole: Use printk context for CPU
 and task information
Message-ID: <202601211304.r9ecHy9L-lkp@intel.com>
References: <20260120-nbcon-v2-4-b61f960587a8@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120-nbcon-v2-4-b61f960587a8@debian.org>
X-Stat-Signature: o7fy4ii4uiydwmygyoy1txg15xdiuwpj
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A62AD160005
X-Rspam-User: 
X-HE-Tag: 1768974040-11008
X-HE-Meta: U2FsdGVkX1+/19W+fX5bPxDL1tagXwi1u1/4yguixImGqSUXcT/Tr8sGK9EsskrKzjjwiSBq0kKC3TyvH7pcXkVZAusQFH1JnUpYHwS5bAMIgAgXNU+i0TcmNwv8E3SUmTsoGogVzmiGzKFHU+EE5xOr4mbR2k6x9gV9xh3JjO+XRLpJKnz9t19v3hTzdzEuO5xhv6lWr0HMh5JRrzQo/iSY28fyTEjJQiEEau4jC4TQpok0RfxxS6cm03+PAdzFJFjqEtgN6CP8eEwD1XPyABvAe+wgLvtpuIdinb7BGau1tzqEWDjb2P8RPeparurh4LRt6YXqQJnfl67jIaHMBYWtQLuRnZTwSKZM1CLSfx8tj6OHr3A9UH6Fww+zS+3+KW1FQ7HwqU+d7rOLzr2b20JcnL4l422xj6LGcbudCFrwVu8hvVb1IUJy6OSCiZTafT551rDw3au+uR1n1gXKIFQzovyi6recHFNaKUpTGcwNL0+EJV83WR+qm0RwH9dU3HkFUTs3Q5RcIXIel9A4/OQnEp6ecQT5/T2q5MlkznDvjsqoOZgbVkY78zjIplVl2PuwRsdS4KRxs92Qd5EgfNX7V0VDKo7vbkxMZjo7qEnDhmBS1R1odcd0mUlxWoDyo6sHZake6m92C4iJiDY5kBsvnrlzyhm+sMw/jBJgsNVx10oTlG4BNt4CsYe2LgNVIkjUS+2AGAA9vIdKAyO4qO1O7GbpJ/248kLQ7br3KE0NEXsS5VKj6U1a1M/zpNOLCVA1XOoZ7hxehwtOuuJbjvxDji1RQDMD6PrGsIYdToxrZL2ngKVxKJMB38s8hpsnm+ymJM6YXX/TWL3hMJ/Z8hK3F34Wpg0UNQI4x0Lqxh2AslWpT9Izecc0V7gG6WD7Ygl4nBwZrykkOJv1xKplFgn/KtJR7MbYCRcQPdg0YmomQQPMyhnqx6BS56PiRYH8pvfXs+ioOeJjcFpc+u2
 fEg1d/W7
 17ZvtXKdwNHYHfHsiNDBc58S+g86NfH4bMtC1oNBgWI+6BnWOJsXVRVUW6qgTy+D7j3oUk24rbp6p3A+C/kxnp/AEZdmfaK5RPck9dJVeyxJHrakAOtGd68q5YSN06zzH+/kqrdyi/pNOzOHxxSomHhbJhKfOvNJxiu8u1it2ZOGfJ1thmIlJFZg0iBYDpA6ZFK8og3KbOJf2m4sFFyADNMbiiYQnTjDSfVwvLweeDi9B2cDipBWhga0oTz1warxdgrbuSoyQuZJKlwqGyzPk8JMs0vClvxdNlqeK8KD0Z6EHoCeR4Ta62ato9U8+DLohnNoWqkkdXGxNWVl9s0BLsf1x7UNZVDonBJ2q1WK6JV+LLLLH6f8zue2Pyq9yL+Gl97l9zrsSECb19iQ6t76awcN5peDRavp4Bxxe9vI8foJ7qJI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

kernel test robot noticed the following build errors:

[auto build test ERROR on 956f569c90ab507559342d289f4c923adfbf06f5]

url:    https://github.com/intel-lab-lkp/linux/commits/Breno-Leitao/printk-Add-execution-context-task-name-CPU-to-printk_info/20260121-033457
base:   956f569c90ab507559342d289f4c923adfbf06f5
patch link:    https://lore.kernel.org/r/20260120-nbcon-v2-4-b61f960587a8%40debian.org
patch subject: [PATCH net-next v2 4/5] netconsole: Use printk context for CPU and task information
config: csky-randconfig-r134-20260121 (https://download.01.org/0day-ci/archive/20260121/202601211304.r9ecHy9L-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 13.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260121/202601211304.r9ecHy9L-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601211304.r9ecHy9L-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   drivers/net/netconsole.c: In function 'sysdata_append_cpu_nr':
>> drivers/net/netconsole.c:1365:31: error: 'struct nbcon_write_context' has no member named 'cpu'
    1365 |                          wctxt->cpu);
         |                               ^~
   drivers/net/netconsole.c: In function 'sysdata_append_taskname':
>> drivers/net/netconsole.c:1373:31: error: 'struct nbcon_write_context' has no member named 'comm'
    1373 |                          wctxt->comm);
         |                               ^~
   drivers/net/netconsole.c: In function 'sysdata_append_cpu_nr':
>> drivers/net/netconsole.c:1366:1: warning: control reaches end of non-void function [-Wreturn-type]
    1366 | }
         | ^
   drivers/net/netconsole.c: In function 'sysdata_append_taskname':
   drivers/net/netconsole.c:1374:1: warning: control reaches end of non-void function [-Wreturn-type]
    1374 | }
         | ^


vim +1365 drivers/net/netconsole.c

  1359	
  1360	static int sysdata_append_cpu_nr(struct netconsole_target *nt, int offset,
  1361					 struct nbcon_write_context *wctxt)
  1362	{
  1363		return scnprintf(&nt->sysdata[offset],
  1364				 MAX_EXTRADATA_ENTRY_LEN, " cpu=%u\n",
> 1365				 wctxt->cpu);
> 1366	}
  1367	
  1368	static int sysdata_append_taskname(struct netconsole_target *nt, int offset,
  1369					   struct nbcon_write_context *wctxt)
  1370	{
  1371		return scnprintf(&nt->sysdata[offset],
  1372				 MAX_EXTRADATA_ENTRY_LEN, " taskname=%s\n",
> 1373				 wctxt->comm);
  1374	}
  1375	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

