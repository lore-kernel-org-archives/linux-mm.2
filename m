Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2459CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 20:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BEA18E0008; Tue,  7 Oct 2025 16:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06F898E0002; Tue,  7 Oct 2025 16:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2A5C8E0008; Tue,  7 Oct 2025 16:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8BA18E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:43:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B02E13A799
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 20:43:38 +0000 (UTC)
X-FDA: 83972494116.23.573DE51
Received: from iad-out-003.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-003.esa.us-east-1.outbound.mail-perimeter.amazon.com [13.216.7.111])
	by imf24.hostedemail.com (Postfix) with ESMTP id 04E5618000C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 20:43:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=DUYvB6nE;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of "prvs=368a8c2a2=farbere@amazon.com" designates 13.216.7.111 as permitted sender) smtp.mailfrom="prvs=368a8c2a2=farbere@amazon.com"
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759869815; a=rsa-sha256;
	cv=pass;
	b=3q8uhHllVPSd4duqkWfBaFUNmg4W6KpYv4iUqtTxGha0agrwUkDLUXY4x6ok8iIS/xULIp
	cS+Tr3dsib5qs6qc2Zp7g9l26uDBjfzna7MgW5ne8qh3fH6yaBinXrBEsbcVUG1R5I7mA8
	TjSJXmjYSL6mcWD1XBRHNViDD3/LUvM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=DUYvB6nE;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of "prvs=368a8c2a2=farbere@amazon.com" designates 13.216.7.111 as permitted sender) smtp.mailfrom="prvs=368a8c2a2=farbere@amazon.com"
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759869815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzDJx3EN5h1FYvNXUNuZK7tlMGXKWxed++/Eo1YPpEM=;
	b=ywe1wY4Y7gK0BRbpz1R4xxGy94IIAvOkYe9gZrrP2GSfyYt/+/mDhHMzZokFIokabh8k4u
	zauFtWSOIq9WIQbZDwAx27Kt3GPevH0AhxFbkjhzxRftTKf5ZeV0DshJ51BU07ppQL3K1Y
	T9Fma/loPdNtY4AqZNdLrIZUY7Soxcs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759869815; x=1791405815;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mzDJx3EN5h1FYvNXUNuZK7tlMGXKWxed++/Eo1YPpEM=;
  b=DUYvB6nEVDdmymGPuXB2vRUAsv4V5ENvF1EHMq253XAQ+CoOKJaLMgUD
   zutUi7hbnlVa7Hq623ndH/NBlTqwTTVccgpgUAmAckd5hSPE4kUEhsBXZ
   a0jmwm5rdmZSijDkda/Os2sKfGktvil6ydPSOkmpoEjH4ojUlGGNja+Jr
   t1GKAj54/jc05xCc1SoYNEl7/RIFOb8U0fGfFQ1WkBqNhgWK4U7hkQnuT
   XRRFCQG0MMbhdSTn4TeEig7UDrXT1EWN7v3inPbtGN72q3XPiRLk/r7BR
   h9tWImk8aVVIgnnxw+NJUo0ORllAQJJlEWdz8eT23hd23THdwK5STzUoA
   g==;
X-CSE-ConnectionGUID: APYWf5c/QOG1WpZRTYhG1w==
X-CSE-MsgGUID: HWRgOvLbRNmNBPl/fIPC7w==
X-IronPort-AV: E=Sophos;i="6.18,259,1751241600"; 
   d="scan'208";a="3922632"
Received: from ip-10-4-7-229.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.7.229])
  by internal-iad-out-003.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2025 20:43:32 +0000
Received: from EX19MTAUEB001.ant.amazon.com [10.0.44.209:49236]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.82.10:2525] with esmtp (Farcaster)
 id 07eba65f-2127-44b0-85e1-7b1e300563a8; Tue, 7 Oct 2025 20:43:31 +0000 (UTC)
X-Farcaster-Flow-ID: 07eba65f-2127-44b0-85e1-7b1e300563a8
Received: from EX19EXOUEB001.ant.amazon.com (10.252.135.46) by
 EX19MTAUEB001.ant.amazon.com (10.252.135.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Tue, 7 Oct 2025 20:43:31 +0000
Received: from DM2PR04CU003.outbound.protection.outlook.com (10.252.135.42) by
 EX19EXOUEB001.ant.amazon.com (10.252.135.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20
 via Frontend Transport; Tue, 7 Oct 2025 20:43:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VijQjuJxeZPrNsWjPUXVvdkqjV+HCGgM8UXz9W8kXxqfhyw4M1V2c3ZZS92ERMTPm3U7yZnIMPjUKluQ5ZKFj2ZkZ7LdTvB+rjp4aWxH2R10jkC3aZ5tpVgBmAdAfzUx6I8FBswHzzr/tUQ16V8CbRlAlCmTCaFjQTrAs5QS07DQbB1jcaXOHW34Vi9DnHza8fUaKy8O2VZ94lb+V6jM8Gzksj975wkVLdr8vMnlZ/zD424IofRWberuPfJn/Ar6o2Ji3APBxJf3QiAPa9QRo3m/l8MUMr8Ys4nGUcyfei09XjmcKuZENU0aNb3seKdTct6VAgZL7iaAP1pwFeAEJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mzDJx3EN5h1FYvNXUNuZK7tlMGXKWxed++/Eo1YPpEM=;
 b=McJ8nyoZcDtMk0olZ1LrFs15jzB0lbAKZq+bVHdVGZEBvaxoxZNiITxfiH6E9qI7s4TomPNQke4IndWtrAAiRJKZWECwjD0qcleTG14xMGFAKgvnhtU0esrFBjFa8dQoic/nU55PfypILaCSZf5Su50Zt0/O7POMpcCzOHs1t031Bt5sUw/U0j0En6wuzaX2mGivO8qLiUCoTWBQX8i8U2gVYkk0T4X5FLjPKkiaHuQXEhRwNtx1C6eKwXMbAZRvn/YRHMa9cRyb+cqxNW/zcAuqXRdEtXZM6Vw6ayCZF9Xub0e21/UnNC9gjHhP61MWZ5q/8mDUWoEmRNxWA77Qkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.com; dmarc=pass action=none header.from=amazon.com;
 dkim=pass header.d=amazon.com; arc=none
Received: from CH0PR18MB5433.namprd18.prod.outlook.com (2603:10b6:610:181::16)
 by SA1PR18MB4710.namprd18.prod.outlook.com (2603:10b6:806:1d9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 20:43:20 +0000
Received: from CH0PR18MB5433.namprd18.prod.outlook.com
 ([fe80::1423:ab6b:11cc:7b0]) by CH0PR18MB5433.namprd18.prod.outlook.com
 ([fe80::1423:ab6b:11cc:7b0%7]) with mapi id 15.20.9203.007; Tue, 7 Oct 2025
 20:43:19 +0000
From: "Farber, Eliav" <farbere@amazon.com>
To: David Laight <david.laight.linux@gmail.com>, Greg KH
	<gregkh@linuxfoundation.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"rric@kernel.org" <rric@kernel.org>, "daniel@ffwll.ch" <daniel@ffwll.ch>,
	"maarten.lankhorst@linux.intel.com" <maarten.lankhorst@linux.intel.com>,
	"mripard@kernel.org" <mripard@kernel.org>, "tzimmermann@suse.de"
	<tzimmermann@suse.de>, "sean@poorly.run" <sean@poorly.run>,
	"jdelvare@suse.com" <jdelvare@suse.com>, "linux@roeck-us.net"
	<linux@roeck-us.net>, "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
	"dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>, "maz@kernel.org"
	<maz@kernel.org>, "wens@csie.org" <wens@csie.org>, "jernej.skrabec@gmail.com"
	<jernej.skrabec@gmail.com>, "agk@redhat.com" <agk@redhat.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>,
	"kuba@kernel.org" <kuba@kernel.org>, "mcoquelin.stm32@gmail.com"
	<mcoquelin.stm32@gmail.com>, "krzysztof.kozlowski@canonical.com"
	<krzysztof.kozlowski@canonical.com>, "malattia@linux.it" <malattia@linux.it>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>, "mgross@linux.intel.com"
	<mgross@linux.intel.com>, "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>, "clm@fb.com"
	<clm@fb.com>, "josef@toxicpanda.com" <josef@toxicpanda.com>,
	"dsterba@suse.com" <dsterba@suse.com>, "jack@suse.com" <jack@suse.com>,
	"tytso@mit.edu" <tytso@mit.edu>, "adilger.kernel@dilger.ca"
	<adilger.kernel@dilger.ca>, "dushistov@mail.ru" <dushistov@mail.ru>,
	"luc.vanoostenryck@gmail.com" <luc.vanoostenryck@gmail.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>, "pmladek@suse.com"
	<pmladek@suse.com>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>, "minchan@kernel.org"
	<minchan@kernel.org>, "ngupta@vflare.org" <ngupta@vflare.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>, "dsahern@kernel.org"
	<dsahern@kernel.org>, "pablo@netfilter.org" <pablo@netfilter.org>,
	"kadlec@netfilter.org" <kadlec@netfilter.org>, "fw@strlen.de" <fw@strlen.de>,
	"jmaloy@redhat.com" <jmaloy@redhat.com>, "ying.xue@windriver.com"
	<ying.xue@windriver.com>, "shuah@kernel.org" <shuah@kernel.org>,
	"willy@infradead.org" <willy@infradead.org>, "sashal@kernel.org"
	<sashal@kernel.org>, "quic_akhilpo@quicinc.com" <quic_akhilpo@quicinc.com>,
	"ruanjinjie@huawei.com" <ruanjinjie@huawei.com>, "David.Laight@aculab.com"
	<David.Laight@aculab.com>, "herve.codina@bootlin.com"
	<herve.codina@bootlin.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-um@lists.infradead.org"
	<linux-um@lists.infradead.org>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "amd-gfx@lists.freedesktop.org"
	<amd-gfx@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org"
	<dri-devel@lists.freedesktop.org>, "linux-arm-msm@vger.kernel.org"
	<linux-arm-msm@vger.kernel.org>, "freedreno@lists.freedesktop.org"
	<freedreno@lists.freedesktop.org>, "linux-hwmon@vger.kernel.org"
	<linux-hwmon@vger.kernel.org>, "linux-input@vger.kernel.org"
	<linux-input@vger.kernel.org>, "linux-sunxi@lists.linux.dev"
	<linux-sunxi@lists.linux.dev>, "linux-media@vger.kernel.org"
	<linux-media@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-stm32@st-md-mailman.stormreply.com"
	<linux-stm32@st-md-mailman.stormreply.com>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "netfilter-devel@vger.kernel.org"
	<netfilter-devel@vger.kernel.org>, "coreteam@netfilter.org"
	<coreteam@netfilter.org>, "tipc-discussion@lists.sourceforge.net"
	<tipc-discussion@lists.sourceforge.net>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: RE: [PATCH v2 07/19 5.15.y] minmax: simplify and clarify
 min_t()/max_t() implementation
Thread-Topic: [PATCH v2 07/19 5.15.y] minmax: simplify and clarify
 min_t()/max_t() implementation
Thread-Index: AQHcN8sDDjKmCck+60iFjHMDIrVxlA==
Date: Tue, 7 Oct 2025 20:43:19 +0000
Message-ID: <CH0PR18MB5433D33DA8E0066EB0FEB5D7C6E0A@CH0PR18MB5433.namprd18.prod.outlook.com>
References: <20251003130006.41681-1-farbere@amazon.com>
	<20251003130006.41681-8-farbere@amazon.com>
	<2025100648-capable-register-101b@gregkh> <20251006213242.3462e746@pumpkin>
In-Reply-To: <20251006213242.3462e746@pumpkin>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR18MB5433:EE_|SA1PR18MB4710:EE_
x-ms-office365-filtering-correlation-id: 64df120c-4827-4694-413f-08de05e2266d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?YmtFRG1LMm5MclBMV2hkQWtCK0RiYTdRRFFsT2syN210WVg3Z0pVV21tcFQ2?=
 =?utf-8?B?eVlpZ0F0c3JsVUdFNGpDRWZsTGFvSUMrNkdEa1cvdUlYWGluaWdkOTFEa2pP?=
 =?utf-8?B?VHI1UGtJRUlqNUNhaytkYkdMNGk3Z2NLdFFCd1NCdmlVSmN3N3ZveU9aNkpN?=
 =?utf-8?B?WjliR2VveWdra01jSEE5K1NDZG4rZEsyQSs5TXVKYUNMSDVFSHJJbEs5MHJX?=
 =?utf-8?B?TTViMlNuTEJYenUzUDBrM3VMclJtRHNaT0E5UnRQZjdXYVAyMDRmeUx6Sks2?=
 =?utf-8?B?WGxkdDBxL0tHbkZGb3JpeDZFbEJDdzU1MnRjb3JyRWFXWG5SSDNUQkpJZHJM?=
 =?utf-8?B?VGwxWUR2czUvbG8wWVJnaWVCTVhpVGtkZzF2NEhrd2Nqa3MwaFpjZXlwQU5K?=
 =?utf-8?B?cldvL1VoOTNMbjdqWGs4TVpPbXIvWEhqV3I4Vm5kVnR4Zm0zSkxabmxoZ1h0?=
 =?utf-8?B?RTBOWVJyOGxkYVJVaUNKaWU3RXJ4ZjZwMUZXQk1lU21mSnY0V2Y2QTdhdmRJ?=
 =?utf-8?B?ZjBweTQybXZlY25mSDhrMXZYOUpLWExINTd6aEtrYi9DQmFnYlptNTFsR0lz?=
 =?utf-8?B?Z1hlbkc5UEx4Wkc4dFdPMno4YU5UdDRzU0VoMTV1RkQ3ZHBnUjhZZnRSWVlp?=
 =?utf-8?B?L1REVHJKZE1iMGxSVWh4Z2NqZlZ0c1VRUVN0WU5tN2EzVXp0ci9jVUp0dXZu?=
 =?utf-8?B?dndOajM0eC9mN1UvcXJUaUpyWTh6em8zajVVUXpoaHpKY3NNWDhIdGs3bDF5?=
 =?utf-8?B?ZG1WZTViZnVjUGdpZHllcjF2RUNsbjRuZm8zMzFEanZaa1haNDcvNTRubkVQ?=
 =?utf-8?B?OG9uS2lDcVc4b0llMlNDdjZEMWtJSmhDVUptbmRycDY3YW1xSFdDOVN2SlJv?=
 =?utf-8?B?anhtT01waXBEclkxNFBIdFBaWmNNNmZsaWZKbnBvNlhEeGFFRlZxa2krQ2k2?=
 =?utf-8?B?cWZvZ2FvOWpMVHZVcVhrN0l2TjQzNHFOUFlBcDJ1SkNZMkRwRmo0VHNFc2h2?=
 =?utf-8?B?WklXMEpCWDdwMnJHOFlFdXNodGV1aUt2bmo2V2dlcnBlVDRFb3p5T1VTcEVk?=
 =?utf-8?B?MFRNb0JMSktRWEhGOUlZWkEzY2dIVmNRbnc5WVNxcTJadTBrMm5ORldXRVpI?=
 =?utf-8?B?STE1TEdCTm81Nm9NVG5Ubk0vcENENmVya2ppcXhidzhnUWtuSGxrVGlhd2dH?=
 =?utf-8?B?dlBHZTlPNjVWdWVGNTJjaWtYcmZPRWJjNFhUSEdGdys3dzkyV0V2RjZuQ3ln?=
 =?utf-8?B?dy9kR1ZyL3FEeld4ZmRzNXN1b1B1QnkvYUV6MUk3SFNQb3ZPY0pnSTNTUm1w?=
 =?utf-8?B?elgweFkwQ0x2TzZDQml2U3JtMDVWQzd1YVFQK1NCeUhEQmFHOHdDZkdqdnBN?=
 =?utf-8?B?T0JqUUp2SlpYK3FFUU9ocERIZWhxNUxtSFJ3OEVITmp4ZmVVUG85NDA1Q3lp?=
 =?utf-8?B?NFQvN0lWaWdtV2I0NFl1aTNhWkoxUDF4blVUcllyOFJ3T1NrcnpSeG9GSDZQ?=
 =?utf-8?B?aTNEUFRLSDU1K08zWWYzRk4wTGtUdk5yYnkvQjhZYnh2cnhvYTFYZlVRTkJJ?=
 =?utf-8?B?dVFEK2YreEZGc1VBZng4Uy9UZ2c3NEJ2Um44YlZpeHRVOHB5Uk0vZ0lGNlBI?=
 =?utf-8?B?NnVMRi9aQ1BhcVlVRUZFTjN2cWZDOVRzaXZzU0QzL1VtbW9ENlpuek5QVEdU?=
 =?utf-8?B?T1dmS014cldFaXR0Wm5FYXpYRmRNVU42L0w2dWdvQjBoL2hSV0FpcHpRaWZk?=
 =?utf-8?B?WjN1alVLOUJWYlROblZqeGp2ekpEUGVhMHhDekFXb3dtM0xkNzNXQjJITVVY?=
 =?utf-8?B?WmpPakhRSGp6TE9PRlhnUjlMQ2gySGd3Z3FtNXhTSklyaFBFb096TGVUazlV?=
 =?utf-8?B?cy9FN3VZVlh3S2s1d1RQYXp6ek9BN0xwNUFYMHMyOGN4bzF5UjhSNkRJMVVU?=
 =?utf-8?B?WHp2YTRobzU0cHdHSlMrUW5CZXU0RTYveTV2MVI0bnJ2ZUZ3UCtmaFVpdktO?=
 =?utf-8?B?U3RQYzc0M0FUSStoT09aU09Mbk1RNDdzamphR2Q5dElJbUYzMjZZbDg0TFcx?=
 =?utf-8?Q?QpKV4i?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR18MB5433.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGlYcmJPbENiYmtPNDUwLzJnT0tDZ254eWNpQzdTdTVFOENLZlBsamU3KzlT?=
 =?utf-8?B?UGpqU0xPb0dnN0VCbStiWkJLS1FlYTMxaC9BRmZUU0lPUzBLNCs5UDEvcE12?=
 =?utf-8?B?anQ3QlBQWEVYakpFcnBSZkc0TnQ3aEUzQ0FWRHJIZEZNbGRuT2tnSks1WTNN?=
 =?utf-8?B?RVJuS0dKdDdIRlNaT216bzF6WEl1Rnh0SjU0L1Q5bnlBa3VIc3RScHo2dkUw?=
 =?utf-8?B?SW9IdEVUeENrUzQwZU90TXAvTW5obVpLMWczSmhyWENLTUZIUFhGb1pWT093?=
 =?utf-8?B?MlhDalU5Szg1QVVrenpmRG1OakI2MnlIYnhUeURIRTRidXpQdUN1YjNYRlYx?=
 =?utf-8?B?SElRYXpPRHB2dzhmWTFndUtjbis5eUMvM0xOb1Eyd0hrd0hLVkNzSCs1cG84?=
 =?utf-8?B?bVZFdzBTQy9qVjlwUHlqUGkvSDBiS2hJNFNMYkhPZUhGTHUwZ3ZDZWpaM1hU?=
 =?utf-8?B?dm96aFdZRU9TMkd1MVA3VHA3U2xCMnNmRXZ3MFdlOUM2bmlHOG8zZmdmNFNZ?=
 =?utf-8?B?d3UvUnFWN3ZHMXcyRzhmNGJ2b3ZkVVFTY2lHYWpIeVJ0UFF2NEJobzYzVlY3?=
 =?utf-8?B?SlFYWEQ4R3JDa21rcHRGV2RmK1cwc1Jmays1WVdpOXF4NXpsYjIzM2VmMWp3?=
 =?utf-8?B?MXN0bm5sTC9HVEF3VjQ1S05DbkQ3SnFBMmloVkhicHhJNFFrMUpRMjJpdHRs?=
 =?utf-8?B?RTlNOHQrMy93Nk8xM3k3Nnk2blRaaDJHUi81bHlxczNQRlFQd0x5UVlMS3dC?=
 =?utf-8?B?dUpyQ1RGWllHM0ZtMHhid0NUbUpkdjFmQmxWMnl0OCsweGpCUHZxSXM3ckRn?=
 =?utf-8?B?UW1UWUpvUjhma2RWVnNZYjNjdSs0eG9YanVTY01pNi9BNGJIUUFJYTltRGNN?=
 =?utf-8?B?OWMvU2JORzQ5cGE3TTYremJ2MHo1WXRwMDJWWEFTdGE2V0Z4bWtJNTlVbmNP?=
 =?utf-8?B?ZkUwL0dXQnhiQ3MxVEVaL3dHdnVBcDJnUW9Iby96eVlHTUd0Yk5IT0FWcXNN?=
 =?utf-8?B?MFAyMkZHT3M4OHVnTUpFVk5jVXVkWGFaOWphT1UxTW5xYlh0eWp1dmdDTW11?=
 =?utf-8?B?U1ExaXl5UmZuSXpvdXZ5TWk4VnlvTGYzZjJGcGtWdzErQmtzb2ZDMjBEOVd4?=
 =?utf-8?B?ZmlvUEZlb2RKMjFIQXIvMXBvTXNIK0ZSZjU3ekJNWFhDTDYwZFRCQTQ4dVJU?=
 =?utf-8?B?RCtvV2kzU0RiTm1tUFh0YzZQZCtpTFVwcFFzRTFBSEw1d1BLRkQ0UWFPLzE2?=
 =?utf-8?B?YmtQTkI2cEZCZ3ZlVDY5d01HWGZjdmViQUlSaXQvVDY3dVNUd3NLU2tIcUNW?=
 =?utf-8?B?Y05ZdGVqMWRyUzJRU2t6QWhEUXlIWk5HMWpoQkg1N0JlMUJUaWMxaFdncWF1?=
 =?utf-8?B?d2hDMkt0Q1pGeUFSUnhabE10ZVJxTGtYSmYvNXlYT0lhTVlFdVo0cXNyMXdH?=
 =?utf-8?B?Y2xtRkFoVDFIcklJRUtXMUdTSFY4UFBjSHBqbjdsRUFBT0l3aDZnTEdlSHVa?=
 =?utf-8?B?UHdYNTkyVXYrcmF0aS9DQVgvdzFFWC8wREtzdCtRZFlJVVdZeTBYSy8vV0h1?=
 =?utf-8?B?Vm84ak9pcGQxYWpJZVI4Wk5FRFJyejNwbTEyYVFtYm5iSGt5YnhlQVpHOEE4?=
 =?utf-8?B?ejU5WmJkNjByV1FWNEdjNjJFN3ZCaWFQdTlGSVhrZnJDU1VkRi90cC9RQjNK?=
 =?utf-8?B?Z1FwK0p2TW16WXVhNG1QS0JRTEo5Y2NwcmZienREV3c3QkJ3b2ZaRGRQL1V4?=
 =?utf-8?B?VUR4U25DUHV5V25ZOUZjRGhVZkVCVWU5Z3IxRDlwR1d1ZmwvVUswRlJXOWRG?=
 =?utf-8?B?WHFmVkxNY3cyNTVYL3NDTEdmczlJL0tqcG0yN1Y3cDhBU1pKV3VoVHBFODJY?=
 =?utf-8?B?NnZPNkhFeXNnWDRjcUptaFRxWGlzeDJ5ZW5VbHFGa0lla2x2cEhxejFsamsy?=
 =?utf-8?B?aDZ3ZlBsQ1A3RGRYVXdwZTBvbWZEaVZhRWo3cHhIT3NSQnVHeGNRRVh2UzFr?=
 =?utf-8?B?dmR0bVBLb3o1YXgyaGNhMVBWM0p5NTR0K2piNkQ3TmpBbC85U1M2UUxlSUNy?=
 =?utf-8?B?WVZVV2NZR0k2bEhEYUZFMHpWdGRlL0JzUGQ0U0k0dlEwbVZPYk4xYmVBY01Q?=
 =?utf-8?Q?tQ+E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR18MB5433.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64df120c-4827-4694-413f-08de05e2266d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2025 20:43:19.8259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BBHPu9esaJvNEXhLA+SVv+gcnqouo/zo2LneNHHm49F5K3/Y6mwkFMuKC65iqSZqkoyf55imWc9yqcDku86saQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR18MB4710
X-OriginatorOrg: amazon.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 04E5618000C
X-Stat-Signature: oyo99umd1oj3154pd3x3c51en6q695q6
X-HE-Tag: 1759869814-147041
X-HE-Meta: U2FsdGVkX1/p6ibsrLRs4KIpIZ5hzfhrs3ndsBknmcxe2b9F+nVXH4LX2zEUW5Fkjb4aFntFIGS45s3TIKa3WZeCwSs5QYSYOiSTx/fM1O6f+opYbhkkMKyyT0fBpVH4Muy+NA+fjbveHOIcw+0RsfAtTqksao13ibNOb03c4Wr4G5uL+I+DUpEldXL5bJRfXq+hVpPsoztq8EsA36PAjgnCdnBBWZtfSPT+tRNWUKr209iXrQ2+1JRrR9SVTTOmfw0xnZ+2xArVaY1cG9xKA5ogH8jAOWYkpJrKzgBYjLZXVrOhtPps3TprDpc7183qm3gXZkd+V1AgzWmj6lGWuJJS6dZbVzVMe6+01l4vNIbG8TtfnxfOj9iUVaG1mYb4qTuAGGOIMpauleQKDy3qKImTOqA9qMZEq3oQuKbHnvJdBTAmd+IpFGMIW3loGea6Il7XwiybwOTwUHG+HhODOEuIrFLT4FtSfS4Td8VCU/VMhPKeK0tjH4NCsmSEUhSCBpM1W9pgNL4cKoiJ1NhT00OF1fzWkShCgWL/h0zbWBMepwMJyK0+vcTfX30EIQTQkVFZvM42ISczaWE2SHKsKE395nDQNZ23q1tj9TMqhpkGwjDLwAc3UivgA621YR0tjVCt89dfczA7+jylz4PkNz6AOyL4kwUQz5dZH+wVb2/QJyrP18XcYAxZV4N2og5AYUIRLmIsw95QzHWhxINSzDzzBugDvHCYpmY6rgDsh9U0396sZCz5M2qW2mSP25bhQlyuJjAGnZiGVprc0XnLQOcgZRZZmP9Vp9VGZR9yjDT8srvQPwPRRQecaMF4hzRj3LrUpGF5QOQRiS29xS6qdJbQCV+0J3LHaIjDLBsBYzMr/jJD7XixK75c3XneXEXQBgXNnx2MVBih2+sMvbvhkuL5Dptr0lcfANkwOiuuZo09WiaCo8FYMW/0NgJ+qGy767JyAqkk1UcX10hBRfB
 8dMY726t
 IrLzKdrJgJ+xktOK5ig9nwn+uiJCWz/Z9yTaJ4ewmrxhLjMsHgmAXwEGolo33AG0/KAPDs69or3jSu71p8VhcRj30VnlcH+reSai8PRZAtYGCxjM+iQpDY36Jst5mJALLvGQoa+K25vHiEgPS4rzqCmye4j/c1Ee0syoGiA1EaCnyO3Djf80NOxA06eP3h4irFckWWJSSZqJzo3PrfNtmUfEn3DyKSQBQz7Uq2wx3Iekr+LWyBIqJwV/27GmWGJEEnTyh4mPOR6Ppaxsdg6XEo9x9hfyPabw9PpIEceRP5/rYLjl3SF+l+JIGdZ8Bm9UkBWt8XwG3zPzA59XRiX7hPl6wwzYACPvp7RarJdoBCOBsmRCk319oaUCDZAamMxiKv9lrEMczlwNKYBUmJbJ/MjFgj7beOjoeMnnIEy+exuR3oRnWNfDifJtx1KZg+/2eR2J0Th26P31XmHdexACzhtNa48UJ+Cmmtm9AbvP/0g+S6Pph57Itq/Ked3aVZ8e0Zhp/U02UUyIxHhTp8YQa4NiEi30xdvBRWzJmBt1i68uLTucMHQiU/7IBDBY+I3pZ5GRQd/8tYsJEUSGb0FbbDvqyPrvLC0a+Cu5e5mahn+ZjNLbwCV27IB65h2dOa4DGD/boiSbMKNhByp919WvmEymv0wDQRybgJ+8OGwl56WqgL3dtcwD7tRApA1u0kfrigdRadLBttn0OReIk9KkK/qUFnhOpzzN01ig1R4FEFuD9NcpnhkdUM2p7AniJ8NKaGXiPQRucdbYGXj2DITL72gufzptitbcFjqcsQP4+XrUuZySN/JhAyqEtch9VyVZ5jroUsQWo75828UXizmVL7il7lzfslbSYnHH60VkHHbES/DRa0/Gcl7Jko9Jcc8DTPqYO5wiNGCZhoXaRTaRCZrRmeU2HdQHByBXa/wl4VssMvRVEzfIYgx3GzzM8kqLujm4Y9p6vDUsI4pXlggRnvFnj7lxT
 LdfVtLuC
 uhSsoupTvcTMcuu8mLcFjuu3lQk0cC/x41ajmy4XBwy4KZcgxaYf0J6xhcqGfp6oDeo33um1vymksePJPv9hOcjY00xuCBIhROQZy5RALT52aQBCurxPfv8Nu5Fs/KHm/R4rnCEnHzUdP/gGZfJvxSLmofwTwlGY7YGN2BU16T89KuWtSGXOYDIBO88AwmrovG4FteWNCc9xrA5gnsepB+OnzxSCWWZ/jzUYpoGiO7A4tEMWi8eoOXOtanUx2wi2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBPbiBNb24sIDYgT2N0IDIwMjUgMTI6NDc6NDUgKzAyMDANCj4gR3JlZyBLSCA8Z3JlZ2toQGxp
bnV4Zm91bmRhdGlvbi5vcmc+IHdyb3RlOg0KPg0KPiAoSSd2ZSBoYWQgdG8gdHJpbSB0aGUgJ1Rv
JyBsaXN0IHRvIHNlbmQgdGhpcy4uLikNCj4NCj4gPiBPbiBGcmksIE9jdCAwMywgMjAyNSBhdCAx
Mjo1OTo1NFBNICswMDAwLCBFbGlhdiBGYXJiZXIgd3JvdGU6DQo+ID4gPiBGcm9tOiBMaW51cyBU
b3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRhdGlvbi5vcmc+DQo+ID4gPg0KPiA+ID4gWyBV
cHN0cmVhbSBjb21taXQgMDE3ZmEzZTg5MTg3ODQ4ZmQwNTZhZjc1Nzc2OWM5ZTY2YWMzZTkzZCBd
DQo+ID4gPg0KPiA+ID4gVGhpcyBzaW1wbGlmaWVzIHRoZSBtaW5fdCgpIGFuZCBtYXhfdCgpIG1h
Y3JvcyBieSBubyBsb25nZXIgbWFraW5nIA0KPiA+ID4gdGhlbSB3b3JrIGluIHRoZSBjb250ZXh0
IG9mIGEgQyBjb25zdGFudCBleHByZXNzaW9uLg0KPiA+ID4NCj4gPiA+IFRoYXQgbWVhbnMgdGhh
dCB5b3UgY2FuIG5vIGxvbmdlciB1c2UgdGhlbSBmb3Igc3RhdGljIGluaXRpYWxpemVycyANCj4g
PiA+IG9yIGZvciBhcnJheSBzaXplcyBpbiB0eXBlIGRlZmluaXRpb25zLCBidXQgdGhlcmUgd2Vy
ZSBvbmx5IGEgY291cGxlIA0KPiA+ID4gb2Ygc3VjaCB1c2VzLCBhbmQgYWxsIG9mIHRoZW0gd2Vy
ZSBjb252ZXJ0ZWQgKGZhbW91cyBsYXN0IHdvcmRzKSB0byANCj4gPiA+IHVzZSBNSU5fVC9NQVhf
VCBpbnN0ZWFkLg0KPiA+ID4NCj4gPiA+IENjOiBEYXZpZCBMYWlnaHQgPERhdmlkLkxhaWdodEBh
Y3VsYWIuY29tPg0KPiA+ID4gQ2M6IExvcmVuem8gU3RvYWtlcyA8bG9yZW56by5zdG9ha2VzQG9y
YWNsZS5jb20+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNA
bGludXgtZm91bmRhdGlvbi5vcmc+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBFbGlhdiBGYXJiZXIg
PGZhcmJlcmVAYW1hem9uLmNvbT4NCj4gPg0KPiA+IEVsaWF2LCB5b3VyIHRlc3RpbmcgaW5mcmFz
dHJ1Y3R1cmUgbmVlZHMgc29tZSB3b3JrLCB0aGlzIHBhdGNoIGJyZWFrcyANCj4gPiB0aGUgYnVp
bGQgb24gdGhpcyBrZXJuZWwgdHJlZToNCj4gPg0KPiA+IEluIGZpbGUgaW5jbHVkZWQgZnJvbSAu
L2luY2x1ZGUvbGludXgva2VybmVsLmg6MTYsDQo+ID4gICAgICAgICAgICAgICAgICBmcm9tIC4v
aW5jbHVkZS9saW51eC9saXN0Lmg6OSwNCj4gPiAgICAgICAgICAgICAgICAgIGZyb20gLi9pbmNs
dWRlL2xpbnV4L3dhaXQuaDo3LA0KPiA+ICAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUv
bGludXgvd2FpdF9iaXQuaDo4LA0KPiA+ICAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUv
bGludXgvZnMuaDo2LA0KPiA+ICAgICAgICAgICAgICAgICAgZnJvbSBmcy9lcm9mcy9pbnRlcm5h
bC5oOjEwLA0KPiA+ICAgICAgICAgICAgICAgICAgZnJvbSBmcy9lcm9mcy96ZGF0YS5oOjksDQo+
ID4gICAgICAgICAgICAgICAgICBmcm9tIGZzL2Vyb2ZzL3pkYXRhLmM6NjoNCj4gPiBmcy9lcm9m
cy96ZGF0YS5jOiBJbiBmdW5jdGlvbiDigJh6X2Vyb2ZzX2RlY29tcHJlc3NfcGNsdXN0ZXLigJk6
DQo+ID4gZnMvZXJvZnMvemRhdGEuaDoxODU6NjE6IGVycm9yOiBJU08gQzkwIGZvcmJpZHMgdmFy
aWFibGUgbGVuZ3RoIGFycmF5IOKAmHBhZ2VzX29uc3RhY2vigJkgWy1XZXJyb3I9dmxhXQ0KPiA+
ICAgMTg1IHwgICAgICAgICBtaW5fdCh1bnNpZ25lZCBpbnQsIFRIUkVBRF9TSVpFIC8gOCAvIHNp
emVvZihzdHJ1Y3QgcGFnZSAqKSwgOTZVKQ0KPiA+ICAgICAgIHwgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXn5+fg0KPg0KPiBUaGF0
IGNvbnN0YW50IHNlZW1zIHRvIGdldCAocmVuYW1lZCBhbmQpIGNoYW5nZWQgdG8gMzIgaW4gYSBs
YXRlciBwYXRjaC4NCj4gSSdtIG5vdCBzdXJlIG9mIHRoZSByYXRpb25hbCBmb3IgdGhlIG1pbigp
IGF0IGFsbC4NCj4gSSB0aGluayBUSFJFQURfU0laRSBpcyB0aGUgc2l6ZSBvZiB0aGUga2VybmVs
IHN0YWNrPyBPciBhdCBsZWFzdCByZWxhdGVkIHRvIGl0Lg0KPiBUaGUgZGVmYXVsdCBzZWVtcyB0
byBiZSA4ayBvbiB4ODYtNjQgYW5kIDRrIG9yIDhrIG9uIGkzODYuDQo+IFNvIGl0IGlzIHByZXR0
eSBtdWNoIGFsd2F5cyBnb2luZyB0byBiZSA5Ni4NCj4NCj4gTGludXMgYWRkZWQgTUlOKCkgdGhh
dCBjYW4gYmUgdXNlZCBmb3IgYXJyYXkgc2l6ZXMuDQo+IEJ1dCBJJ2QgZ3Vlc3MgdGhpcyBjb3Vs
ZCBqdXN0IGJlIGNoYW5nZWQgdG8gMzIgLSBuZWVkIHRvIGFzayB0aGUgZXJvZnMgZ3V5cy4NCg0K
Q2hhbmdpbmcgdGhlIGRlZmluaXRpb24gb2YgWl9FUk9GU19WTUFQX09OU1RBQ0tfUEFHRVMgdG8g
dXNlDQogIE1JTl9UKHVuc2lnbmVkIGludCwgVEhSRUFEX1NJWkUgLyA4IC8gc2l6ZW9mKHN0cnVj
dCBwYWdlICopLCA5NlUpDQppbnN0ZWFkIG9mDQogIG1pbl90KHVuc2lnbmVkIGludCwgVEhSRUFE
X1NJWkUgLyA4IC8gc2l6ZW9mKHN0cnVjdCBwYWdlICopLCA5NlUpLg0KZml4ZXMgdGhlIGJ1aWxk
IGZhaWx1cmUuDQoNClRoaXMgYWxpZ25zIHdpdGggdGhlIGNoYW5nZSBtYWRlIGluIHVwc3RyZWFt
IGNvbW1pdA0KNDQ3N2IzOWMzMmZkKCJtaW5tYXg6IGFkZCBhIGZldyBtb3JlIE1JTl9UL01BWF9U
IHVzZXJzIik6DQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC90b3J2YWxkcy9saW51eC5naXQvY29tbWl0Lz9pZD00NDc3YjM5YzMyZmRjMDMzNjNhZmZlZjRi
MTFkNDgzOTFlNmRjOWZmDQoNCi0tLQ0KUmVnYXJkcywgRWxpYXYNCg==

