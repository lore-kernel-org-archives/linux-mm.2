Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D578606A31D
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 00:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=JtBmp5hB
Received: by kanga.kvack.org (Postfix)
	id 745AC6B00EF; Sat, 31 Oct 2026 20:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CFB76B05B1; Sat, 31 Oct 2026 20:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 596B26B05B2; Sat, 31 Oct 2026 20:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 258626B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:11:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 983ABA0387
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 00:11:41 +0000 (UTC)
X-FDA: 85384621602.11.F90BA1A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf17.hostedemail.com (Postfix) with ESMTP id 39CA740002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 00:11:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JtBmp5hB;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793491899;
	b=dgOq2uuCHilbYUzDntu/aGsw2oYGx4aUwHM1SnaQhn67xA9Irpq2tBrTQE/qPmUasU4Q7Y
	k/mq3VQQyH6pIovPzyvet1LAjt6WZqOJiUBmx//si/3mVkPbSrp8O+JcAi5BrfpkHWIw26
	QfZTx0SzdBrRvC1/jHRE6J28CrMLEKA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JtBmp5hB;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793491899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2EzAq3F/oZImqHNtfFN7yucFQTKmJ98J6mbsgnQaAnk=;
	b=qhfqlcTqvtM3j51DwicNXKr9maExpQMyH83sFWQfp693FuOWRx2ISCjFakSmeqWhoq8dL6
	pIAepoevkL07l2CCTP3iMXv6O1JlYWid4o14FMXH60wW0YECDKGxOX+agr4cOoY/4/sW6W
	x2dEDW79Ca9PuoHPSoTBOI5GsrMckg4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793491898; x=1825027898;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=JxWINGtEXiE/19oIrBdKjOvxqg4jRzLQd0nxSgU6mLQ=;
  b=JtBmp5hBl2Z6GdEPpCzaBVhO0VcqdWTiXjLSwQNumaAniBgbijsGzmVa
   1Gdm05akxCag1uVS2sIsq1vpVLYwfqXLS1dMUSThqOSauoeZr7B65L/Nt
   lCvekJZk9JdxqQiOWAcoROVbJ0hLa1okWygakvB3x/RPtI/KC1TO8OGrD
   qBjY9EwAeJhhmBtKjsB578kqGcl8xR5L9odl8ga+iATNky7q43Bd8A+ND
   iMYRYW1q59WeEc6k3OLsEmU8PJl+sSTlN0AVLpOypjCCfk/DKENbseCsi
   2wZNAHaE/uVxL4wQwQkSzBE+q1ddTczN+bxXtrTwPJXdOeZqXwBG8UR0m
   w==;
X-CSE-ConnectionGUID: +JbFbtXIS62UNFYyys7dVg==
X-CSE-MsgGUID: jaJ71APXRVeitIPh6yXdSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11952"; a="2108913"
X-IronPort-AV: E=Sophos;i="6.27,188,1787036400"; 
   d="scan'208";a="2108913"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2026 17:11:36 -0700
X-CSE-ConnectionGUID: hWVuwracTrCN1bMAbJ7VaQ==
X-CSE-MsgGUID: 9l+96SLnSdSfe1kZ1buVAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,188,1787036400"; 
   d="scan'208";a="5762544"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 31 Oct 2026 17:11:32 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xNJAW-00000000dIq-1U6v;
	Sun, 01 Nov 2026 00:11:28 +0000
Date: Sun, 1 Nov 2026 08:10:33 +0800
From: kernel test robot <lkp@intel.com>
To: =?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>, willy@infradead.org,
	mathieu.desnoyers@efficios.com,
	David Laight <david.laight.linux@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	akpm@linux-foundation.org, Yafang Shao <laoar.shao@gmail.com>,
	andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com,
	Petr Mladek <pmladek@suse.com>
Cc: oe-kbuild-all@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>,
	kernel-dev@igalia.com, linux-mm@kvack.org,
	linux-api@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>
Subject: Re: [PATCH v8 4/6] sched: Extend task command name with
 TASK_COMM_EXT_LEN
Message-ID: <202611010746.Qs8jUny8-lkp@intel.com>
References: <20261030-tonyk-long_name-v8-4-c9b030332254@igalia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261030-tonyk-long_name-v8-4-c9b030332254@igalia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 39CA740002
X-Stat-Signature: j6kmpqgf5s7fircjr5foehrahhtaaop1
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793491898-82216
X-HE-Meta: U2FsdGVkX1+vuZ+lab7VRQGfDW9kEfIfDfnm/lclUTh94s1wyxEl2XRjPUa0wNzPhQuUxeyNXPxZvpaj1KmOec6FWKNEXy1ynnXFxf+Y06xvNr7Zik1DDpPJ8xZq7oc+jW0doRxKsgpn8yGe1p4JoINB+wP3h5n6vhQRBl6nTPkI7rMWbD+JaFfZz3/Aw5he3b4uZG1mo9i3llPydg8YQpIWjndTvdJOzoAPOfuRJF0Fpx/04Q51yidEZY3eONgaMleDN+rrfWQOF0orwv9b4XNNyUzHndGwTA4QxhV+XCjh+PBb87ai4ZxsBRns5MBepwFprD58wOF+nB+DmVhnZ5rUOhFm766vzfPTxZLRGa/pPV1cMwkU8p/px03EECP7WlZ98gfyhoOwytNudeN+ypsqvjxHiYfNRzeeFpxeXyfs0hx0nB1xY6b4xxgzTyRyk9aUY6zRVfdGjW6cj681jiWKMTtJO2hwOA2pgS62Hw68x5B5I5Ck8dfzJPsrrXl6WXfjNi7fF4K2zuJBTNKFnhCAL7TQZBHduQRqix3gXAiRjLyMQqtIAH5cDsg5ItiOoQmauRhlyPkwGZ5Xd/vPJlTzcNm2edH1xbf1NUgCJewFHU7g7+vSncUBv+rMcf6ral45J53LmNhAw7rkVzNjz5EZQ5xtvvt3HhXC4L65rty9+vM7+pMIQTWB9xupqbX5FWzkUXWhZBCwqE5IRiTnEK+f9P1mI7PvvqXPq1FtzqGeBkKTzpS0nAEfBcYUQb/jHMzYiKFdcJX8ozKImLexaqwTRkgXpcEEYRm9DQa3WDg1GdEUtgE94HUJfWNWlUjOcHCAhyZclgLauJpX8KM3TXxaeKjbnf6XWEitl1oSOJs4u5r62X79zwdffxwYte26JMqc4RuopHKal+xtFXsqI6vdNVR8P6JZG9qmtMyaJbzASOpmPOGWXNdGMUHDBo6vQ32UdiP1YMCDshv6Z2O
 ZBIJfJEF
 RojnMZ62uQUC9MGboGNJcqFrpYoU8OecP5MP36qaO90e11VxbQ0idOCwms7raOBQHJzadL91SX+YVxvFM78QmFANB0uc0wwK4V3i6qWG4clp657A96qyCv+sdItqhWjZuICRjEkrPizevj945y/Yrh2JSmWruNyyGsbr9FztNUb9aJLTb4WrKWUF0GLP5e6+9Iwwyx0ptjC61G8aUER+/yediuKIzstBb6cOkmye0oVk55Ifpzhh3G5CCuC1011CtDQ4YjjTC1L/V2EiIyYSSvu/yDjL76ghHvXkHBhgMBIJ+WMKKS1h8e6ITtUPJG9Vr6CCXxuKTe8kTTsNzqmzHFz1W3AyhKvmN6JtoR5d/4+YpBTOGspEKXSisGfj1l/5NX+i3T/ZYKFmnBI4R4VTq/YMCcEaFjfONw17MCYfHNur4ejj0b4YevkWfaVyIqNs1RBhV7KkHyP4fIDRIFJBNlCMrIAqNSQ0X9FDYEwF/+k/Y1cNYHyY7RaPBwEkV/4t0ozu/MUP5ZHG1T5v0Y1lWHun4tMl4zBnpS+Q+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi André,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 4dd16e31135ea8437a720222df34e8745f385d6d]

url:    https://github.com/intel-lab-lkp/linux/commits/Andr-Almeida/treewide-Get-rid-of-get_task_comm/20261030-183832
base:   4dd16e31135ea8437a720222df34e8745f385d6d
patch link:    https://lore.kernel.org/r/20261030-tonyk-long_name-v8-4-c9b030332254%40igalia.com
patch subject: [PATCH v8 4/6] sched: Extend task command name with TASK_COMM_EXT_LEN
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20261101/202611010746.Qs8jUny8-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261101/202611010746.Qs8jUny8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611010746.Qs8jUny8-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/gpu/drm/nouveau/nouveau_chan.c: In function 'nouveau_channel_ctor':
>> drivers/gpu/drm/nouveau/nouveau_chan.c:343:58: warning: '%s' directive output may be truncated writing up to 63 bytes into a region of size 32 [-Wformat-truncation=]
     343 |         snprintf(args->name, __member_size(args->name), "%s[%d]",
         |                                                          ^~
   drivers/gpu/drm/nouveau/nouveau_chan.c:343:9: note: 'snprintf' output between 4 and 77 bytes into a destination of size 32
     343 |         snprintf(args->name, __member_size(args->name), "%s[%d]",
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     344 |                  current->comm, task_pid_nr(current));
         |                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +343 drivers/gpu/drm/nouveau/nouveau_chan.c

ebb945a94bba2ce Ben Skeggs          2012-07-20  253  
5b8a43aeb9cbf6b Marcin Slusarz      2012-08-19  254  static int
5cca41ac70e5877 Ben Skeggs          2024-07-26  255  nouveau_channel_ctor(struct nouveau_cli *cli, bool priv, u64 runm,
06db7fded6dec88 Ben Skeggs          2022-06-01  256  		     struct nouveau_channel **pchan)
ebb945a94bba2ce Ben Skeggs          2012-07-20  257  {
152be54224de182 Danilo Krummrich    2023-10-02  258  	const struct nvif_mclass hosts[] = {
284ad706ad2f509 Ben Skeggs          2025-02-04  259  		{ BLACKWELL_CHANNEL_GPFIFO_B, 0 },
32cb1cc358ffed2 Ben Skeggs          2024-11-25  260  		{ BLACKWELL_CHANNEL_GPFIFO_A, 0 },
44f93b209e2afde Ben Skeggs          2024-11-25  261  		{    HOPPER_CHANNEL_GPFIFO_A, 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  262  		{    AMPERE_CHANNEL_GPFIFO_B, 0 },
7f4f35ea5b080e6 Ben Skeggs          2022-06-01  263  		{    AMPERE_CHANNEL_GPFIFO_A, 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  264  		{    TURING_CHANNEL_GPFIFO_A, 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  265  		{     VOLTA_CHANNEL_GPFIFO_A, 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  266  		{    PASCAL_CHANNEL_GPFIFO_A, 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  267  		{   MAXWELL_CHANNEL_GPFIFO_A, 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  268  		{    KEPLER_CHANNEL_GPFIFO_B, 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  269  		{    KEPLER_CHANNEL_GPFIFO_A, 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  270  		{     FERMI_CHANNEL_GPFIFO  , 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  271  		{       G82_CHANNEL_GPFIFO  , 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  272  		{      NV50_CHANNEL_GPFIFO  , 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  273  		{      NV40_CHANNEL_DMA     , 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  274  		{      NV17_CHANNEL_DMA     , 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  275  		{      NV10_CHANNEL_DMA     , 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  276  		{      NV03_CHANNEL_DMA     , 0 },
06db7fded6dec88 Ben Skeggs          2022-06-01  277  		{}
06db7fded6dec88 Ben Skeggs          2022-06-01  278  	};
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  279  	DEFINE_RAW_FLEX(struct nvif_chan_v0, args, name, TASK_COMM_LEN + 16);
5cca41ac70e5877 Ben Skeggs          2024-07-26  280  	struct nvif_device *device = &cli->device;
ebb945a94bba2ce Ben Skeggs          2012-07-20  281  	struct nouveau_channel *chan;
06db7fded6dec88 Ben Skeggs          2022-06-01  282  	const u64 plength = 0x10000;
06db7fded6dec88 Ben Skeggs          2022-06-01  283  	const u64 ioffset = plength;
06db7fded6dec88 Ben Skeggs          2022-06-01  284  	const u64 ilength = 0x02000;
06db7fded6dec88 Ben Skeggs          2022-06-01  285  	int cid, ret;
06db7fded6dec88 Ben Skeggs          2022-06-01  286  	u64 size;
06db7fded6dec88 Ben Skeggs          2022-06-01  287  
06db7fded6dec88 Ben Skeggs          2022-06-01  288  	cid = nvif_mclass(&device->object, hosts);
06db7fded6dec88 Ben Skeggs          2022-06-01  289  	if (cid < 0)
06db7fded6dec88 Ben Skeggs          2022-06-01  290  		return cid;
06db7fded6dec88 Ben Skeggs          2022-06-01  291  
06db7fded6dec88 Ben Skeggs          2022-06-01  292  	if (hosts[cid].oclass < NV50_CHANNEL_GPFIFO)
06db7fded6dec88 Ben Skeggs          2022-06-01  293  		size = plength;
06db7fded6dec88 Ben Skeggs          2022-06-01  294  	else
06db7fded6dec88 Ben Skeggs          2022-06-01  295  		size = ioffset + ilength;
ebb945a94bba2ce Ben Skeggs          2012-07-20  296  
ebb945a94bba2ce Ben Skeggs          2012-07-20  297  	/* allocate dma push buffer */
5cca41ac70e5877 Ben Skeggs          2024-07-26  298  	ret = nouveau_channel_prep(cli, size, &chan);
ebb945a94bba2ce Ben Skeggs          2012-07-20  299  	*pchan = chan;
ebb945a94bba2ce Ben Skeggs          2012-07-20  300  	if (ret)
ebb945a94bba2ce Ben Skeggs          2012-07-20  301  		return ret;
ebb945a94bba2ce Ben Skeggs          2012-07-20  302  
ebb945a94bba2ce Ben Skeggs          2012-07-20  303  	/* create channel object */
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  304  	args->version = 0;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  305  	args->namelen = __member_size(args->name);
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  306  	args->runlist = __ffs64(runm);
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  307  	args->runq = 0;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  308  	args->priv = priv;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  309  	args->devm = BIT(0);
06db7fded6dec88 Ben Skeggs          2022-06-01  310  	if (hosts[cid].oclass < NV50_CHANNEL_GPFIFO) {
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  311  		args->vmm = 0;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  312  		args->ctxdma = nvif_handle(&chan->push.ctxdma);
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  313  		args->offset = chan->push.addr;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  314  		args->length = 0;
bbf8906b2cad17c Ben Skeggs          2014-08-10  315  	} else {
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  316  		args->vmm = nvif_handle(&chan->vmm->vmm.object);
06db7fded6dec88 Ben Skeggs          2022-06-01  317  		if (hosts[cid].oclass < FERMI_CHANNEL_GPFIFO)
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  318  			args->ctxdma = nvif_handle(&chan->push.ctxdma);
06db7fded6dec88 Ben Skeggs          2022-06-01  319  		else
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  320  			args->ctxdma = 0;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  321  		args->offset = ioffset + chan->push.addr;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  322  		args->length = ilength;
06db7fded6dec88 Ben Skeggs          2022-06-01  323  	}
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  324  	args->huserd = 0;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  325  	args->ouserd = 0;
06db7fded6dec88 Ben Skeggs          2022-06-01  326  
06db7fded6dec88 Ben Skeggs          2022-06-01  327  	/* allocate userd */
06db7fded6dec88 Ben Skeggs          2022-06-01  328  	if (hosts[cid].oclass >= VOLTA_CHANNEL_GPFIFO_A) {
06db7fded6dec88 Ben Skeggs          2022-06-01  329  		ret = nvif_mem_ctor(&cli->mmu, "abi16ChanUSERD", NVIF_CLASS_MEM_GF100,
06db7fded6dec88 Ben Skeggs          2022-06-01  330  				    NVIF_MEM_VRAM | NVIF_MEM_COHERENT | NVIF_MEM_MAPPABLE,
06db7fded6dec88 Ben Skeggs          2022-06-01  331  				    0, PAGE_SIZE, NULL, 0, &chan->mem_userd);
06db7fded6dec88 Ben Skeggs          2022-06-01  332  		if (ret)
ebb945a94bba2ce Ben Skeggs          2012-07-20  333  			return ret;
ebb945a94bba2ce Ben Skeggs          2012-07-20  334  
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  335  		args->huserd = nvif_handle(&chan->mem_userd.object);
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  336  		args->ouserd = 0;
ebb945a94bba2ce Ben Skeggs          2012-07-20  337  
06db7fded6dec88 Ben Skeggs          2022-06-01  338  		chan->userd = &chan->mem_userd.object;
06db7fded6dec88 Ben Skeggs          2022-06-01  339  	} else {
06db7fded6dec88 Ben Skeggs          2022-06-01  340  		chan->userd = &chan->user;
06db7fded6dec88 Ben Skeggs          2022-06-01  341  	}
ebb945a94bba2ce Ben Skeggs          2012-07-20  342  
e270b3665f8321c Gustavo A. R. Silva 2025-04-16 @343  	snprintf(args->name, __member_size(args->name), "%s[%d]",
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  344  		 current->comm, task_pid_nr(current));
ebb945a94bba2ce Ben Skeggs          2012-07-20  345  
06db7fded6dec88 Ben Skeggs          2022-06-01  346  	ret = nvif_object_ctor(&device->object, "abi16ChanUser", 0, hosts[cid].oclass,
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  347  			       args, __struct_size(args), &chan->user);
06db7fded6dec88 Ben Skeggs          2022-06-01  348  	if (ret) {
06db7fded6dec88 Ben Skeggs          2022-06-01  349  		nouveau_channel_del(pchan);
ebb945a94bba2ce Ben Skeggs          2012-07-20  350  		return ret;
bbf8906b2cad17c Ben Skeggs          2014-08-10  351  	}
ebb945a94bba2ce Ben Skeggs          2012-07-20  352  
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  353  	chan->runlist = args->runlist;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  354  	chan->chid = args->chid;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  355  	chan->inst = args->inst;
e270b3665f8321c Gustavo A. R. Silva 2025-04-16  356  	chan->token = args->token;
06db7fded6dec88 Ben Skeggs          2022-06-01  357  	return 0;
ebb945a94bba2ce Ben Skeggs          2012-07-20  358  }
ebb945a94bba2ce Ben Skeggs          2012-07-20  359  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

