Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 902E3CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 06:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7005D8E0121; Wed, 27 Aug 2025 02:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AFCD8E0105; Wed, 27 Aug 2025 02:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571E18E0121; Wed, 27 Aug 2025 02:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF5C8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:09:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C36FC5912A
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:09:12 +0000 (UTC)
X-FDA: 83821509744.27.92724D2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf23.hostedemail.com (Postfix) with ESMTP id 18BB4140005
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:09:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="cqbY/+oj";
	spf=pass (imf23.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756274949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eiaP2/jtL+Ftu8pslhiWWY6fJK7DIV/DVBQAJJBuX6k=;
	b=zOEE7O54ULI/ZvVq3KOirRDDvCKEN0lR6HNlSaMKaXi6POrj8/HygpNIat//M0tHUkudI0
	BUWj0+UORfZSYG5vApNTmR9sMQP0X1p6PvRVmkEOHr/ugwuKu5bjS2aeMzVo5jybjuXO0m
	cu97Ore6co779D1O/VH4CYq0zll+mgc=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="cqbY/+oj";
	spf=pass (imf23.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756274949; a=rsa-sha256;
	cv=fail;
	b=0P1vi3hf6+0R/WPOK0DLtrokoJI9K6rLw7Q324CGGHO/SPPJpwayng/pQ+29DlBxtnBkPN
	r5IFg9aw/dNufetqz4+QPihDwYbrp+0QO2nI4iGlJrBeEqAIU0EPhjC2+i0LV6RdF65Jlo
	XYr5yRW0NSp7sPAfdv4/toToVxKtVRQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756274948; x=1787810948;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=4jpuok04Autft2sL7oaNLA/GwN5pkIklHgHTMHUOGMI=;
  b=cqbY/+ojuYRFjHW9C+YpNQALwdcURsPIm5+5d+lonyuNLBBLnPj1f3w1
   qC1/9mYFetpSv9JScNWsQU3ev0ISuOYXTsgbQ/IBCbfbIjJU2qLX8P0Ub
   +KkD6EFrT3OLgNIqoO5uFMoxaoeC0IaF9EfR89OKwn08rqvwTwAX1yRr4
   3bt2xbYS6X/VVDv4NJzAD3RZwoS0PZ9LuY3RauSNQFfkxStk9CtPTziPx
   zyYrAfjc4LR3EsDOlvhYFo/JPN/Y+9SKHE3D/1JgF9oU3OmVZ06N5hxSR
   Hk/x5JVsHkaphxl1fS6ZilykQ++eQC+iTtrDRxvIz4PZmjljETb7v47yh
   g==;
X-CSE-ConnectionGUID: ZLSAvPOHQ8m+BdhjGfhPXw==
X-CSE-MsgGUID: /f1wk/f7SRmm9ebVYu2+0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11534"; a="57724913"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="57724913"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 23:09:07 -0700
X-CSE-ConnectionGUID: D3iUhNgzQYSP0N31xmhv5w==
X-CSE-MsgGUID: dE9TQyEdSHSZq59mu2qZog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="169369128"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 23:09:06 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 23:09:05 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 26 Aug 2025 23:09:05 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.72)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 23:09:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IJm0ohcOG1soB4TLlEn135MGOrEMqJQuzYItr/pkit+LEdiLKvaA2tf0V4gh45p7dlwMmsA8ZT76WLHqHugyms3Oup7HQxio3HU0SmH1VzUs41VHNnbwyRQc0Yd7pxTijfGk9GjMAnSxQFY/XCNyMvpm9PydhDHaX4EeumkJjoB0TeTdJb7jcJb6GCRIQk3quWBBqnUJta/vuaD0Z7XpBTw4ZWrga9zFOXX++q4NXOntUw9wn+PN94TQWxkrbfPPVsT9rXtFHbVPhUJ5z7TT/+9D933CX836uGLNkOeFGffAux9r9P1pN+2j4V2sQxH9a+2wcKycI/4T0coFyCGQCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DK3HH92O00VpZRiOdtNfl93guRSUK5PuZfDfcXy2YKI=;
 b=NTRhTw/noMzAHptu4zyKpMksFVzGVMIJ02i0/NNoN9NHbYsFFY/cjYsZ2kuH60DmXIbtyzBNrYEbnES4r9wbe+zu8gYaCwfaJ6FhZVCAfOYazdm6ZgniUYs6GseBRVQHdy1zAyJzqIUm8dThXM7WIYQ/e+Rp1n7GwRyAOQqwfirqxgtec5tNV6ZvYFZCNbKiVTBhbqEqJyooGmMsoPxPNWuMUplYxhwtqB/vQgk9g0xQXtQ+Dbr4yNukrLTpGJdsJJ85c79zu4jlMRC7GMIp+aHvmginegdapKPXLvfjxbjW4AKJfROci7BxekjLvit8oa64E8Vy+uYD/ZHix7Olhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3934.namprd11.prod.outlook.com (2603:10b6:208:152::20)
 by IA3PR11MB9349.namprd11.prod.outlook.com (2603:10b6:208:571::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Wed, 27 Aug
 2025 06:09:03 +0000
Received: from MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2]) by MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2%6]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 06:09:03 +0000
Date: Wed, 27 Aug 2025 08:08:30 +0200
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Samuel Holland <samuel.holland@sifive.com>
CC: Dave Hansen <dave.hansen@intel.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-mm@kvack.org>, <llvm@lists.linux.dev>,
	<linux-kbuild@vger.kernel.org>, <kasan-dev@googlegroups.com>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 10/19] x86: LAM compatible non-canonical definition
Message-ID: <gcpw2nrwltvgatdjcu2at6hpse42iudy5dqx7rv5m427dommwg@akooygrdmfvf>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <c1902b7c161632681dac51bc04ab748853e616d0.1756151769.git.maciej.wieczor-retman@intel.com>
 <c68330de-c076-45be-beac-147286f2b628@intel.com>
 <4rkxgsa5zfrvjqtii7cxocdk6g2qel3hif4hcpeboos2exndoe@hp7bok5o2inx>
 <2e9ee035-9a1d-4a7b-b380-6ea1985eb7be@sifive.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2e9ee035-9a1d-4a7b-b380-6ea1985eb7be@sifive.com>
X-ClientProxiedBy: DUZPR01CA0103.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::15) To MN2PR11MB3934.namprd11.prod.outlook.com
 (2603:10b6:208:152::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3934:EE_|IA3PR11MB9349:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f6cc0d5-53d0-4a07-d5f3-08dde53038d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|27256017;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?/OIBpjR6XkYn0b1X5wB13Iy9hW2CBOpikVO/Oj898U+a0FzdbTUvHJLUAT?=
 =?iso-8859-1?Q?IX0Tc/mRuYef1mEzfxzFy1L/x8rkXewbJujnYJZgrdKMJ7okK/2yK6xCGD?=
 =?iso-8859-1?Q?msizSfRvKvkyTkJScMX9IygogMbo0S+cu9vObvFg3AA39AjQ9brLXAGWZe?=
 =?iso-8859-1?Q?3ciGXXY735NoTUjTAx4jCff5FKgXVAuXkBUKTLLDdfiVzKksRslc6TueRK?=
 =?iso-8859-1?Q?jR7Bo+pJ+2c0WH9R/mDvZgCIUMWkAv979G7suCGJu5p4J9biWIuKuYnWUf?=
 =?iso-8859-1?Q?ecjGdBiiCrehvXwj3DoLpNkImBTZXUpaZA0EPbXLz9ra5NP2Xl8erPRaQm?=
 =?iso-8859-1?Q?oUNM2nX+iOjuc6nrmLSasMwgbjpnjsXWezlobF/rqhAq3uGl+5i930VrqF?=
 =?iso-8859-1?Q?iqf6u9hstUThSkYGNkFqk6pHj5+vhqDJnDL/O8gTxoC8Uzwfsae4KOgIiU?=
 =?iso-8859-1?Q?Lv+FQvbeMN53PhhkptAXsCD6ARnTDzz6Lrx60Xwx4eOGphff8GlYldJ1VQ?=
 =?iso-8859-1?Q?h9gqhJLbNLSUfYq/cqsyjwheuylpvEJmCfmcyAy3aV3Ds9cbnFaEb4Vm2m?=
 =?iso-8859-1?Q?OpTz9X9As9+/A6qi2hGkD5GJp3qukToM5S6nNZgk5HtQbfF8V85PksUamO?=
 =?iso-8859-1?Q?Il4IuQlEuIob583/PspRQBpF/7C+iVflrISKtjiGE3UtAiZywxQiTOxppd?=
 =?iso-8859-1?Q?IdPrU+IcPFu0dvd1YdU+DM/v+7oF+26WaPi3gXZvejV/tDVZxgo8YSlE5R?=
 =?iso-8859-1?Q?0pS5UyLLIeXtoviWXbK4jVRpwFVxt1b1HiItZcUlrZPSxFhWYx3bImVSa9?=
 =?iso-8859-1?Q?zoHGoza7v99cGqzKRCKkIzGvYID+y5+ELcJMr4rp49s46bLFCiWgF/FZRU?=
 =?iso-8859-1?Q?8THT8kdeQX77c8zQBk8OzQUDvdchloJ/RyoXnCRX2iYKr07MVWZUm4f1Zk?=
 =?iso-8859-1?Q?8rnrHhOKGwkcO11GIWkamhM1+H6a2QQXq/Hbqlr7tN+Sk1Y5oMIrFqXGrC?=
 =?iso-8859-1?Q?zTGTW4hgZRGYRZIktyoTgmJx3lMyBvvbMXulvOxSmB1XdNM+b1AiDaPmpM?=
 =?iso-8859-1?Q?ciJHJn2JMRVNYIuRq4+x3TL7/+jXLx+ouUAu0eK8b+7uPtbRIo9h7CltgA?=
 =?iso-8859-1?Q?+K6L5PkxMoMZ+goOKCNtLA/NyZQRyjhj0kZdqvaMrp8vhjrBwJ5JcJMgNL?=
 =?iso-8859-1?Q?ZuHKUsaq0Ue9LmNvFCGM3V9wTnB1ZCqVDB+fL4vjDikRSE6I2+RiieRiLk?=
 =?iso-8859-1?Q?7aEP8Slft+bRReSHbWQ7wnJZQZ3nTQmwesFskrSFFQ9l/6oE3ZcJ9cRjIs?=
 =?iso-8859-1?Q?hrEgUHbhx/RYEq48z1NMG3OJMY2g2MtbaVJOleD453QfVGNzDO4PDm1Lpa?=
 =?iso-8859-1?Q?uJV+ZKFd0dtjkq4rxx3wBLFhgt8cjnvs1XbSzZb1Ito+DejrttPEh1tCDP?=
 =?iso-8859-1?Q?/CTh2GSgVl7HcM4vO4fFOob/BlJe8qni2XcCxGfK1zrViK0lsZjLxFHfLT?=
 =?iso-8859-1?Q?QgqX4A6qcrSGvAHRdoMUUW6PTMJRYpPrK8aS9ahl0lxg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3934.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?EwmElDDC2dNIkiL20YXAKgLRZcGLtBE5gKfara5+e1RzY+MKq1ZJLnx9/g?=
 =?iso-8859-1?Q?jc8EKtY/gB/cCykFfAv/huBlmrKA1XvqNQ9vahK8/v17Ww3BHpXX3prAjE?=
 =?iso-8859-1?Q?j32gN0NCEsHdpJqCvpO9/gql/sVS4wKUjt8KBo6KzqD7sWegN7/syk7Fzl?=
 =?iso-8859-1?Q?/ZkT5D9IbaUBmXUwIBmq5zqCpiMRWdtLYS7ySGaGTPn12VgM9gHwGNmqDg?=
 =?iso-8859-1?Q?rNQSBhJTVp5cKavv2i1Tk0zdK21wOww2nLBKWa2BnexUpr/xr8qrZPn/08?=
 =?iso-8859-1?Q?cMKP8GfVzF3FEU4Lzpt/Y2lwRM6dGNcS5KsDezx6zFpxpAQKihT6JoYUNJ?=
 =?iso-8859-1?Q?1TtNd5KMW6N3jW4YSwSJvIzEedVK2RD35/VRx7wtgSVAdAM/I8oxupfCIO?=
 =?iso-8859-1?Q?co9DDOzeYAmpjzDVHvTIAQAyGhVjcBTG4J6sILxcdxoCqZ8Sjzhv7aniNJ?=
 =?iso-8859-1?Q?nC7zjeKvZZYyiPaLJ6+zxIGD+vAu5hkaifB6Yr9Vpvtom4jP72Ls0Eaczk?=
 =?iso-8859-1?Q?L8jbxE5/av8qRQD9x701rtohCNbxBOcte1aMcF/pTdQ5zpM8a4vVx5Z9Az?=
 =?iso-8859-1?Q?nPPoKIxVRZ+yWsSqhn8OOsPJt77u9QkJ3ljoNQmTRxQ87xHaoUMGxnojCu?=
 =?iso-8859-1?Q?dX9A5V/rN0YDRUA6kU1SliKG7LVZunmEa3mFYWWjM2gyC0WMIDA/jxbuPH?=
 =?iso-8859-1?Q?wLs2xkJ8B+Wvv9P9BowmXOJ9r7f7R4dAoSFoNpbXmDK4EE27OF6Sd7e7vE?=
 =?iso-8859-1?Q?xdL/tfeIRxhAgIJZUEgIPctsOdy2VXQDTgfDwXkpPFgbURIMvrFswkm5DB?=
 =?iso-8859-1?Q?DbXfcipzEVnizRU3CJNE01NfCch/XC8vVjVcZ6pJ54b1+Z4Z6pBpaCdcS7?=
 =?iso-8859-1?Q?3S/Z3bsEx5kOGVJ9SxPv/4LzOd57MqOXLmhPclnLkPwDOWVfZzL0xByr8+?=
 =?iso-8859-1?Q?g8qJhX3KPnEdVMmNfk3eDHqdgVlLkY96W+3xhOk8BTqrkge6FEyvuQ83wA?=
 =?iso-8859-1?Q?XAw0kfJdsjR/iSuRU4jLr/QfLhlyA+py+1u1uP9UIJ/OGmv5ZN2VIlXAUa?=
 =?iso-8859-1?Q?Dq+9uUelsf/TFjwKzUmbTUgzAdXDyfAv+0IjiVaveilO4O72R8Ftvt95O7?=
 =?iso-8859-1?Q?O63YhSUITcRp00GgbvFjN/moJN8ZtuTb4iaadqFiJUIXMd0cX5oRwpieZO?=
 =?iso-8859-1?Q?hfjEsrk+cRC7AElhjs6A9k6PCzF1rXzA3RmCsh2SpKIuZHCFgqEAKI5QzK?=
 =?iso-8859-1?Q?D9TK2Cq7s84r6WbbMFkyRj3bfYagXOoBhZwuJx65r7iXub6qZytGH7xgRG?=
 =?iso-8859-1?Q?jLwXeWRnGXTJXLbU+QfuCCYofhT6KVIk+GYgTt9dMRPewwvAFtli2cU6FJ?=
 =?iso-8859-1?Q?0bjygSRJsrXh/xJK7n9lJC3si6pteF/LbZgq+QSGDFhHPsbTnJJ9vsiISQ?=
 =?iso-8859-1?Q?kiCWUVVIyGe4CMiv2fCEwPajaMHeD5iyE5bIOiBQZVjo862RQ2ubFwvLR6?=
 =?iso-8859-1?Q?a8g1whgF7NQCdS1czxa5RDq7x8XloIrrI2K/MRUkCTu00KTM19bmpNivOK?=
 =?iso-8859-1?Q?uVXooMSUhXXdYDHVneuiwHWqsscrpaiEprwZlEbsg/h+dBwIf6FlA7IavC?=
 =?iso-8859-1?Q?+NPXprx7agmhsSrVS0xYRGAC9t9QEp72lA25ggsyWjMs2ICxBLeIuBgqcE?=
 =?iso-8859-1?Q?JVl9oJJY7QjqmT/ExpA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f6cc0d5-53d0-4a07-d5f3-08dde53038d9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3934.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 06:09:03.3838
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aplAYVEN7LwEi94pirUyRYIzoEGo2AMl3KuwfxLMlCOG0TtUZkbNH1ySigp7qy6WWfPtfXJcOiS+Xjz+kJJP0DDjpu5IijidDpCrD7GGfqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9349
X-OriginatorOrg: intel.com
X-Stat-Signature: 96jj5315hmewjy3i1rg3hnpmmi85oz3f
X-Rspam-User: 
X-Rspamd-Queue-Id: 18BB4140005
X-Rspamd-Server: rspam05
X-HE-Tag: 1756274947-599551
X-HE-Meta: U2FsdGVkX18w0kyPzZskexOPLuc6gvV+C/OJm0Kms/Wl3xlzNWgkSHLLvRMxcdycPlACqZlAztJe5KRBeVUHx61OXMKbqihoGFM92E3FN0QtSEq7W2QqBcgjejViPHNjNlh3QdLgzF/MW9ktyhNan8ILltRVjm+INSsl2ZHIniExiGt7gq8xcD/m2uqII1t4knGrVN14D4SB/Fr9iKmmiy+oaAlRiPuXQB5BuxJ50og7fW7WHKWNh4pE1PoJOLbQCJgWP01j1XFsccAGaiFNPbu9I1ppvxSV+G3mVakdqnE1CdEofDuhvnlscPRy26FBy5qo/b0Tk+E8G5b9KB6yP8vLnyrzXcJ3SI7B/loUg9v07xEm/q6z54A8kG1boxQrR34YaSFDQM15htc4bQLV5yEfbc+pAjRRO3uXvNdNav1q/yJCIh5Uymegneqt3XWxie1WJDQyxOzHeceeweIW8aU9KbuzBoN/G1+PAZAtnaoCjCkb8ATSDrDXeNozn2xkS9D0BlG1W/fyK5vGgoTzgjoSXAqo8pWeSDCELbrPOqOX7oun3GXK7yn8E5oOpMMBbLOliEe7kwVjCeOtk4jhPkIZcjyUAOya8D1HD2S5Uh0lJqMZ1SAAa48ysCjqfCtfQ28UEjOUmmZ+2K6ozUC1/xyo0SwuBqw8X51JxHOIfnjWsYt3TELP4xiUb21cZ4luf7QRQzn279x8RUcp07QM9t1eIacd4nmn2jT5KkUuehycCWIDzj0utx6f3rRP07cWFnYnhlS3qf8ujPOquTuZiKrOEEnAYESmVOSbT1xOQficFlqRLQPZ5lMioZK1oCNvS93eQwTWtWqDpt+1Y3fj7SnxF633E2pM/mWculHwMVwhIZ5O0HQchSz/4Y02WP1NcXKCaYfqmM1iU2K0XwEPbwvomnL0Ig9+UMgwENbwgDOl4tITShDohMmn+sMjozJjP7S2Lf76dAdsSQF4zcB
 MZnvGkfo
 bEwuhETXFY8o8SQ/jHUJ1P5CNGBSWnKpNsFf8G4Ytv+V7DKFs5oUF1Gev4Cs/EMkPy8Qd0D3I0q/4hS/9hyeil8XoXDxRzsqJvHKNTMNzV/gXGyUUsuqtmep8HZKUJTpIADTGoEXXh3sEIJ+rQfh8Zyx5UixHzdPeSmKMLsPpgWdBSR6NbDIkk8pJgUOJ6s/ZL0k17oDIWq6+gfYuY8ZVPVKy+16Gv0wPupnmUY6h5ibQzQmiN685pSqSLc+0EyiHJKffmrT2FbXEsVvxGZRuqGapF0lIlwCD+Rp0b/FXo0j82nUFNuSoGEdfCH+VV4KcKqPdPdGIfcySiqQzBa896Ng4f36Iulg4ctvkBvn5q8I2xgoQBD/PP2meU0w5ZolVWIWDf0sCYE9NOZ68/7/gHW5MqjGkgGB++6X+1mSU/RmHWzoDfCmBUfFRIIy6rl5nggYwVqF70A+tIsyEQf3/IT/iqL2/UsKac2rscknCPNuavtMkQdJA5JUbgCxtllfYjAuRrgcKmKJ6W5Q3g9uIwjrX5olqFiMdebBz14TRqyVN5WZ95I9lC/eS/pIlRszTq91FEp0aRtsYkyHc3zaZ9nk8f+WS/Bb7aUuSnKlHjH8GS06ZBpjbrz5YlAmfhEoM72WRJKU4OIeC8cohBACa1U5Fq1H6bbS/f+HlpJhXoULJZV0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-08-26 at 19:46:19 -0500, Samuel Holland wrote:
>Hi Maciej,
>
>On 2025-08-26 3:08 AM, Maciej Wieczor-Retman wrote:
>> On 2025-08-25 at 14:36:35 -0700, Dave Hansen wrote:
>>> On 8/25/25 13:24, Maciej Wieczor-Retman wrote:
>>>> +/*
>>>> + * CONFIG_KASAN_SW_TAGS requires LAM which changes the canonicality checks.
>>>> + */
>>>> +#ifdef CONFIG_KASAN_SW_TAGS
>>>> +static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
>>>> +{
>>>> +	return (vaddr | BIT_ULL(63) | BIT_ULL(vaddr_bits - 1));
>>>> +}
>>>> +#else
>>>>  static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
>>>>  {
>>>>  	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
>>>>  }
>>>> +#endif
>>>
>>> This is the kind of thing that's bound to break. Could we distill it
>>> down to something simpler, perhaps?
>>>
>>> In the end, the canonical enforcement mask is the thing that's changing.
>>> So perhaps it should be all common code except for the mask definition:
>>>
>>> #ifdef CONFIG_KASAN_SW_TAGS
>>> #define CANONICAL_MASK(vaddr_bits) (BIT_ULL(63) | BIT_ULL(vaddr_bits-1))
>>> #else
>>> #define CANONICAL_MASK(vaddr_bits) GENMASK_UL(63, vaddr_bits)
>>> #endif
>>>
>>> (modulo off-by-one bugs ;)
>>>
>>> Then the canonical check itself becomes something like:
>>>
>>> 	unsigned long cmask = CANONICAL_MASK(vaddr_bits);
>>> 	return (vaddr & mask) == mask;
>>>
>>> That, to me, is the most straightforward way to do it.
>> 
>> Thanks, I'll try something like this. I will also have to investigate what
>> Samuel brought up that KVM possibly wants to pass user addresses to this
>> function as well.
>> 
>>>
>>> I don't see it addressed in the cover letter, but what happens when a
>>> CONFIG_KASAN_SW_TAGS=y kernel is booted on non-LAM hardware?
>> 
>> That's a good point, I need to add it to the cover letter. On non-LAM hardware
>> the kernel just doesn't boot. Disabling KASAN in runtime on unsupported hardware
>> isn't that difficult in outline mode, but I'm not sure it can work in inline
>> mode (where checks into shadow memory are just pasted into code by the
>> compiler).
>
>On RISC-V at least, I was able to run inline mode with missing hardware support.
>The shadow memory is still allocated, so the inline tag checks do not fault. And
>with a patch to make kasan_enabled() return false[1], all pointers remain
>canonical (they match the MatchAllTag), so the inline tag checks all succeed.
>
>[1]:
>https://lore.kernel.org/linux-riscv/20241022015913.3524425-3-samuel.holland@sifive.com/

Thanks, that should work :)

I'll test it and apply to the series.

>
>Regards,
>Samuel
>
>> Since for now there is no compiler support for the inline mode anyway, I'll try to
>> disable KASAN on non-LAM hardware in runtime.
>> 
>

-- 
Kind regards
Maciej Wieczór-Retman

