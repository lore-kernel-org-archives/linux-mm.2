Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE826C79F8A
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 12:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CC736B0139; Mon,  5 Jan 2026 07:22:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4A56B013B; Mon,  5 Jan 2026 07:22:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051C26B013C; Mon,  5 Jan 2026 07:22:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E711A6B0139
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:22:11 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97D9E13D399
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:22:11 +0000 (UTC)
X-FDA: 84297822462.23.60BBBC4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7B8B2C000B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:22:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=djTr8Rv3;
	spf=pass (imf28.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767615728; a=rsa-sha256;
	cv=fail;
	b=DuMOsksPv2CoodijVD0QWuLaR9vOLj0N3aoNN1HJorY+78J5pjJ9PHnNA2smwM9MChxwjB
	751LKWGui8oFhRCATo19lDizqInH6Dwf4i40YBK2E+1hzg81heZiZ5w5Na49HAmCjKDApg
	PiEvHCOExOAWWalZ1DNYquwPOXMb22s=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=djTr8Rv3;
	spf=pass (imf28.hostedemail.com: domain of tianyou.li@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767615728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rPpNhxSsLhZpT3/7rkPThdNuqzsYQRS2tbN7UxAFVWE=;
	b=0NjwFjEO7X2TOU2Ji+3b3jO0FxlC529vnkuGlG+eSoXI1S5u72Rqx5bFo5yZY8tlixtJvy
	x5aTBJTTZ2udW/+Iost0ZYLkU3VA+y+294hxXiCrg5lvfw+G8K3Ab89FonKFU+sEKswr2I
	dQ2o8Wc1pnzMmMG86GtDI48AwgXUHWc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767615727; x=1799151727;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hnvjP675AHfSkepsEbMsNUuuakp43DNlo22ybxAwoW4=;
  b=djTr8Rv38dBHZJMBvy9lATZN+UluZdJLc0TeUnCA5OOaztfhb/wwMY81
   lyFwmgxtHKSFWq2Br+MlTtDGhG6YIVjR9kIERRb0VKWHuzTArgf3wNviX
   7Zj69oT8kqnn4zolRdsBC9sVg79bJrVJRgSM8TGq4h9QkiXW/+wN10VkS
   lGhoofXGjA/qC2sEvOT8m4JubHhXNVsVWs4l/V+IKtUgu6C63e+YDgCXA
   SndXl/A5nGZa2FvalhqoQJG4wvHAwmFagO+wclniwMg+DPNYG3BXigpRT
   lErlbVMuvBbr/D0cNTbW7bK6fHd0xc/u2ynq68tI56T50/k3ajwuQj2K9
   Q==;
X-CSE-ConnectionGUID: Xfrv1c0RREWf/2OfKij7Cw==
X-CSE-MsgGUID: Ft6yUKoPSWykAlulxAPB3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68911038"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68911038"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 04:22:06 -0800
X-CSE-ConnectionGUID: MIzV9vRFRvSUcA5IcMlQcg==
X-CSE-MsgGUID: JxhfR+QIQzG/D1aduIC+9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,203,1763452800"; 
   d="scan'208";a="202429384"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 04:22:06 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 04:22:05 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 5 Jan 2026 04:22:05 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.1) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 04:22:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KJJO2bJj+myEiln+XRnBALNDm7Qsiz8eQjdV4cTO1PBdJ3QwFhElH3qgBJa+STnLNBisOr1R4r4CH3BUx5P/v8F3TH+N8Mr+js5SNnKF/suL2u5g7MoBKsa+Vt0sh4hTlNmOtg+YHv+Ubp02r5TPZTWNb7OQUVE7UqccE+QIJhQxzQXvbw0ixllfdRIkf/enTzzbFy3pG9bkujjgLQ17jNECZrZZ8ihXrre6kClqZ7j6JpcYXXOvW/ibmkQ8ROYx6I/Av/l8wAnJ6F3vSmNP2tYS0Mu4DD3Ro0jiZyRiXl4zHW8EwBhEGnb5R5WmSi3yyZVscFZbBLyq6MegRWO5uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rPpNhxSsLhZpT3/7rkPThdNuqzsYQRS2tbN7UxAFVWE=;
 b=w3Bf0m2FdaD0/mxmCnyKTwVrZ+QGODokQ/wh3QeAVhIkqQbbo8ywCIqzEnLnnRAuUFG72AkNDKjtGJ9kPCYlpMq9qPFJB/vDYiOCfAdEAtkx1U8pYxA6uyuIdJbqUizLzSRxAS0K11wPP3Xg+glOsLgzE3kG/+e3bQdCilm4RrjGCWelKARMovLKYUvOylsJ9R7c8ObDbc+OXNoZlKWfoJTZVNuFPQ9GDYRiMZjdmVgZXd4HmqgWH7TjRfPV7JLz4mGi67lCH/TgRNiDClydKsjX0M05S8IIlbeMxekv7AUGw5scaFNHf1TOqoO6ikdUk0Jx1xrcYSYZ92lNzdF3dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by DS7PR11MB7860.namprd11.prod.outlook.com (2603:10b6:8:e9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4; Mon, 5 Jan 2026 12:22:03 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 12:22:03 +0000
Message-ID: <011e2691-994f-4038-adf0-02e899eca777@intel.com>
Date: Mon, 5 Jan 2026 20:21:53 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/2] Optimize zone->contiguous update and issue fix
To: David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251222145807.11351-1-tianyou.li@intel.com>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <20251222145807.11351-1-tianyou.li@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KU1PR03CA0019.apcprd03.prod.outlook.com
 (2603:1096:802:18::31) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|DS7PR11MB7860:EE_
X-MS-Office365-Filtering-Correlation-Id: db618b81-c10f-418f-c208-08de4c55083c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OUMxUG9BNmVabGNpcXlOUDYwZUxqbUVvQmREMStvTWhkR0h0QkFzVFhmN3FK?=
 =?utf-8?B?Mjh0aDBJU0tPWDMwdFFEdzYxd1Vwc0UyTnp2bXFFNXZBMFhyV0Njc0J3Vkdr?=
 =?utf-8?B?dHNrdEN0MWR0bjE5ckdJaktPRmZCUEVpc0RXdmJzYzJ3a014RmJSUS9CTmtm?=
 =?utf-8?B?ZmhuUWx2WDJkaWl2clhGTHUrY0ZSNTlKSmRTc3lJcFFlaWEyWDE4QUVjYTdF?=
 =?utf-8?B?bHlGMjhxeUpSZFFtcWh6eWora21KN2dHQTg0NTJjK3NXbWh4MlBTaW94RXN3?=
 =?utf-8?B?aGlvS0haTUdYcmM3TyszeDBmNm5NT1JyNjh5THFvK0Y2S3FONUNNUFpCZyt0?=
 =?utf-8?B?MU1xVDM3bWNGalhMaE5iUk04N1dySm14YTNHQUx5eW1BWDJaYzJrRUpKYk9M?=
 =?utf-8?B?NDhoa3BUL3hZM3lwVWFmdnZ1K2UvalRndTMwWEVPc3c4VmplOXhBaWxDUHU1?=
 =?utf-8?B?NFpsbGgzcE9GSTN0WWZtdmFKUVJOUFBrYmkwVk5Bb1A5WHpSMU54ZUdpRnpj?=
 =?utf-8?B?ZnpTQXVjR0gxdm9jZlNyc2ZIbVJ2N09keHVGTkFNaTduS3ZRdDQvMktoS2xZ?=
 =?utf-8?B?Mzltd2hieEpSRTFXTW8xcWpSdmQ0bTlGT1dOeHhyeXNodjQxSktBSWM4K25i?=
 =?utf-8?B?RmdDVitJdFE0SUxoYXQzb3FTUlJZd28vNHpwVFZNVm9VQmVObWtpSG5iS1hr?=
 =?utf-8?B?Uy8zMVFFb0daVm05K3FjZVh0REtmYUNacFVFc3FlcnRlc0RQbGVscEpXQVF3?=
 =?utf-8?B?SUVLYUVlZTNJbGNlZWhuOWtIS0lFSU5XcGd5M2VxeUhVb0E4elRyLzFoK1g3?=
 =?utf-8?B?MHlQL2NsRWo4ZzdrV1hRbWFoV3FPN2d2c0gweThBSmswa1ZIRElidGlOV3VU?=
 =?utf-8?B?aTVwOFhHM1NLcnB5NXNZWGVqcVdWVzZNZEl0b1NzTjVMTXVyYlNIcG83a2Zm?=
 =?utf-8?B?eitNYjJROG5lQStKNU41dkYzdXp3TUlCZDUrNnR1OGJqaUhZSVlYeW1nZUJB?=
 =?utf-8?B?U1RCa1JJRDQ5cS9wVTQvZFBKOFNBVjZOSEI1WXlEd1BoM05TaUdQc3dXU0lF?=
 =?utf-8?B?UlBDOVJvU3pxWlJpeVBLeGl3Q2V3R3E3R0FzbXp4SGl6SnhoamRtR3dvU2kx?=
 =?utf-8?B?RW5rN25teXV5SlduWVhwUHNGZVAzQzcxNHNPQXV0WW80eEs2SWsvbmVjMGV5?=
 =?utf-8?B?RU5xVnl5SGpyVFpEVFRKckNNbjVUNXpBOG12QmZkdXM2Y2l5UnJrd1QyYmEw?=
 =?utf-8?B?WHRCTGR0amF1dkZmbENpNm9HejJOU2tpR2xidG5XYjNsZmdieklPTEFic3gr?=
 =?utf-8?B?UHNtazNXaWtWMUtkRHE3ZU5tdlpoWFluLzZoYUFkdXhDOUh0R21JTWtXUXpR?=
 =?utf-8?B?ZWI2NjY2TEkwajArS3V3MTUvQXNVUVFqeURnMXRyUndRS2ZhaFR4bEF3Qnkv?=
 =?utf-8?B?a0hydnpIbXZxdXVKTDVHejdjM0ZWQXJLV2ZzUWM2d0hSSmliNkd0Um1qY1J1?=
 =?utf-8?B?RThybE1iU1pwTjlKOExLbThjZzI5OHJsOTdHWTlVN3BWcGRheHppVGJGYzlw?=
 =?utf-8?B?d3dQWndNVzZNSyt1K3d3VTQ5M0V3enBCbGV3MXlGVDd1ZEEwcVlIYVh3RnpZ?=
 =?utf-8?B?VEtBcnpoelVLYTJrRW9hNEdxcWxjb1pGbEVOenk3bGhTR3ZQUmFrNkYvRU9R?=
 =?utf-8?B?TytHelNDTnA4eHpET3BMc3FNWXg4U21PVmEvMVhIZ1o3L215OVFMTDUvdFd2?=
 =?utf-8?B?cUp0dWcvNTRWK1p4ZFhUNCsyY29MU29Vayt6ZXFFMEUwbW8rbENIVmFobXRj?=
 =?utf-8?B?ZTVvRUwrWGJBNE9mb1BFK2JQWTNrR1lxa0FqZXpURWZ0a25TSGQ1V083dXkw?=
 =?utf-8?B?cFFocTc3dFFRa210SloyYXdKS1ZMUUNMbG5mcFVDT3pWa0R5anZuY0IrNUZH?=
 =?utf-8?Q?uFRcgKUcgVmYMizKjUW+XRJMm+jKgOyo?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MG9oSVY4dURybXQ4OG11cGhaQXFoemxHbStTZ1B0KzN5akJZTUs1ZzJMb01U?=
 =?utf-8?B?UytDMDJSK1FxbFNLVlJhZWRlbCt3V0owbDQvNVRmSHZxbTlySVlQOWR2R2Vq?=
 =?utf-8?B?RGpRalVUWjlRUG5Pdy9ISytpRmIwNzIremZxaHY2ZnJnT1ZPUHdNUGRwSUNu?=
 =?utf-8?B?R0lSSFJGb0QxSHZwMmdIUU1ZYlpHT2xtQ3RVTEhzbE9yd1J4QVZCbG1qdUs3?=
 =?utf-8?B?ank4a2pDQ0FDV2NJVUdVNlpmeWwvVGtqWFRGQ0FtM2dOTDhnQkpnMUlzUWxz?=
 =?utf-8?B?NzZEQ1JseHFGN0xEQTJEWFV4SURIQS93dHZ5K1BLd2ZUZzZwdWEzbjl5TjZ0?=
 =?utf-8?B?TjgwOG13U2wzZC91T1diQUN6dVQzWVVweG5wSmdSS3V2QStMSnQ3ZEZ6S3d4?=
 =?utf-8?B?M2ZPNE1qMnY4bVU3TGljRUJxN1RDaXhBVDFnVVI2N3ZFU0N0eFV4bE1hRDFt?=
 =?utf-8?B?T096STduQ2V0UktaSDUwdTFIMlJoM2xzS0N2OHQ5OUxBVGVTdFpyTW5tMldJ?=
 =?utf-8?B?UnBOL01KWVlyRnR4OU9PemM1U29VYjYzS0dodWs4WWJqUmt5ZXNYYjlOTmQ2?=
 =?utf-8?B?N0RETUVzazMrUnVIVjVhWWRoNkVCc0Q1U3E1bzFINFE3MHVJeFl2QUd1SDlF?=
 =?utf-8?B?UUdqY3JnT1o1Qk1Fb2lpSVk3bkwzK2pXNVVmWjhqRk9QTFg0Y0sxeng1dVN3?=
 =?utf-8?B?Q2xyNjNjS2tQaE4yUTNwcHNhUDl2QzFtelJPTmJvTDJDdVNDN3RNZFZpVUpa?=
 =?utf-8?B?VHFZMnRwbkZFNmY3TXk5dW9jYzFVT1VnNFQ1M2puOHdZVG5BNXRNNzU5VGQy?=
 =?utf-8?B?d1dCNnN0RDNCRGc2dW1vakg2ZU9MZ01aVTN2VGFIdDRIdG5jaDA5YXNDOGtP?=
 =?utf-8?B?ZnJLblB0YXBqZ28yM3MrL21iTXhjbnVvSG5DVVlPWXcvZGptWk40b1M3VGZV?=
 =?utf-8?B?bUFDbkE3VFA2Q3Y0U1NGYUFrSFdDcDlKaVE3ellvejFWUUpNcG92b1o1QTBk?=
 =?utf-8?B?SXgyOFQ0NzlacVdaR1VHOVd6NE9oc0FackMyUjg2UFVZZ0I1UnpYZE5uRHRW?=
 =?utf-8?B?Y3J1TGM3ZDlOTFVBb2ZtYkl3UWY5MXFFR2J4MHNnRTlVMWpjMWU2NG92L2U5?=
 =?utf-8?B?eXJuYkVFb1R3UVFHWTlMWFVPL2kzMWdzU3doZDBaaVNKTVMxQW5PRUhqMVNw?=
 =?utf-8?B?WFYwTFE4YmhHb1Z2QVl4Ym5BOW1YNkt0bHZPMzFGQjQvN2dYalNVSSt2cE85?=
 =?utf-8?B?SmlUZTBCUzNOVDY2V0ZTemI5QzA0Rml4RlN5eE5kVSt5S0pZOXQwbXNGUU0x?=
 =?utf-8?B?MS9SVDFOMTZyQUpoRHcrVWVDRGFEK1l6bmFoNkhUUmx0bzdna3lKU3BWd1k4?=
 =?utf-8?B?L3NMRHJiR1VlSGJ6aERQeWNpZVYyVG8vVjFQdUYycFlmMFJrNmU4aC9LQkJD?=
 =?utf-8?B?cDdmMW1sSTZTVVF2bElaT2VrQldmcnQ5Y0ZBbjZwMUd5WldNbHdVamxUWUtN?=
 =?utf-8?B?VVdvQ3MyaW1nc1VFOFduU1gyVUV6ZlF5cTJudlhjT2U1alVyOTYwUGEybzhT?=
 =?utf-8?B?R1hvL3VFbExWOUlxWVpLeWFBMFBNUnNVMDdRV2FKeVdGQ3RDY3BtanVSOXlF?=
 =?utf-8?B?cndzenhlSWE2K2hTZWhuaHVOREo1WHA1dGlqMi8zbWEvT2R5R210UElRVlo3?=
 =?utf-8?B?RE9IZ1AwR3ZHRFBydzdQNTViVXJsTVQ1b1ljRzBSdlVWZUlRY2FyTjVjU2g5?=
 =?utf-8?B?TVU0Q3VaUXlycW9UMjF2WkJEU0NWMzFhTmxET2JORXI4a2o4Z09BSGt0Uis2?=
 =?utf-8?B?SmIrVEFJbkFJbmQ4ZEZyUHFQUzJjMUdlNTVaakJjeWJMSzNIMk83V2lJbTli?=
 =?utf-8?B?cnQvR1hTQ2NWc0pZUk90enphQVZ3cDU3Tk1JSXMvWEl3NXU0QnRYQlQ3cG1w?=
 =?utf-8?B?QVNEL1JNOHB5bytQdmFxbHpyM2JPR0R5MUhiK2kvcS9lRnJ5dldDN2NMd2xX?=
 =?utf-8?B?UFhoOUZHcERteUtTeE04SFFmRTVTcjVlb3FkT2tFc01taHlhNnVvblJXUTJY?=
 =?utf-8?B?N003NEo5VCtiYzhwQlNUM2ozSnNIVG5jN2hRcGpoZmZoSnlTdHJmNGk5ZHZG?=
 =?utf-8?B?TEhIYjdyYzRUUWpwVlpkU2p4MFYvZVRWSU1FdXRjdjdoMVBlQzE2Wk1oZytM?=
 =?utf-8?B?dE1rR2FITUhKVU5xK3diNnJLa3FSNjloNTNoSFE0enNob2FOek5DaDRiQmhE?=
 =?utf-8?B?OHM5bHloTGFuTWtLVis1UWFZU2x4M2dxazNhRXphWFhtWjBEZy9PdHpLVC9Z?=
 =?utf-8?B?VHdpVzVSWWlzOWVUN1ZMcjVWQ2VOWTM5U2tVc3QwZDlhY3pud0ZIUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db618b81-c10f-418f-c208-08de4c55083c
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 12:22:03.0608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EF4IPFniaMoNlzfhP60FHRTywKNDdtZHcrfeJcysQLqgOE6Yl/Pq6eLBq3H05zQxpLzwrQDyYSwr1tVa1zAgbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7860
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B8B2C000B
X-Rspamd-Server: rspam04
X-Stat-Signature: 4hwspk8afqwr7yrhfydp3rowmmm1bet4
X-HE-Tag: 1767615727-920616
X-HE-Meta: U2FsdGVkX19etWiWeGKQovAGwK8Qh5vQZMmqOkLKHehQyrB0X3p9b8UPEr5fI5VrQp5s+UXEsOAlZGR0n9ouNm2IJ2LT6z6Fej7iEL6Yu/N4a4E9BdSOmDZ0jLtg6SPT5qz293KVyqSzw/gy21k3GQ9Kx+ZfmpkV/1E2RFnwTGi3jdanC5LEZo1O9kOTkrhoFce3QTdPBvrNdgsxjsDBYYbUj6QFNWkxEUyCdPebuhEyegb06fukerda2VRzJfTcU9As5oJQOnTv1S5yo0eeTwJ61g6qaqW/z2tjQlcW/yc+ykz0w4lfFgHSvYpAmv0Mgz3lQWsf9JFSWKhBzw/VAiZDwpeSqBA5LSlToTx3uaenZeWtT6QZ4r7AoMkyR0fp8DMNg0GRd5paKHKzbGiy9wBmTFqNm3+ZIeS/swR1/s+irNmlo4v3WS7MN6HccxZx117vZHDEWc6zmj9lmN/a6LF48vlbt9e4lolT8TTjXyhqidXiWHrTFN6SpmZzlOsoSbI6CwR7ZWzAXBbxut2Pw5yzPQz5cF7Ao2sngGUc+TOcn+yjnhb2MXgaQ6Ex9MtMHIVD3+6ExQMF+yZSsxaemg/r/LFkhiPlT9xlqjGsFFaK8qo6PtaUuTOEPT1cmywa/7ecHY/gsEICGdU1fm7vLzYow3MEMszf9Ks6EDHtgBKkQDn3u8ugFcewzkBz16nzJoGLSzYPny2DfLPgvgbC+Kfn87HpkFvnic4aXXRUn8noofeyyya+QwoeEvQJk8pekQ2diyn0MKT5OoOj3hsmixBnLKEhAFiEJukieP+kuhhSYq/9z2CvkU3cdDfd/6A8llLBcPVtVYBOtvVS2P9hk9nhb9eEcQTuIp5WqmjTj9rDPWmo+jp+Gc0kTcOD7mMatC52s+8g+oy0dU9e+2FKMzDip4edoHntHUV1iMEkADmGTNx5jsigCfHC/XfNfGZ4xJClnuGRvVTi183bjKk
 X5WvYGLy
 8jdmRVLFSNZUsuwwQfBGRYqhgZJylAPZPD+RCBABvGY4aiHxAU/YJfd65rrgcJn0n/hZPt/+0OEE3SuW+Amg4u+W0DOJuwiMkZRnqpXIWt5sFkTtXZvxGscFH5nPFd2iWwPS2BsU4EflZ1qdrwg6/Bzmf3u93EQMoxMqV2zlr+R41EN9yYN5IkeDSzX4ZwpDXmGAoTJF6MQ46eAzKTGDuUkUbjPjuaAfJaE5hB8a8lKgbhphsaZUAeW3tYQw0QIBZu9KOPE0rOwo7uX3hEpWMEkU+uTr+lAx2oBnhJeshUZRL8iYqVcDzvUTekYYU2jL5EDfrQ2qBhVxtxu0sQZBJY839Ogwtgohe97AwBUXUfkj+o9UCI/bsPvYyZGi8QLCufVlmZI31aBsZ7kPj9tT04aVTC752k5ev4cv+9YYrlDriCS1tKymsIiXJQNkYmTQAkXj1Q5phsT5pWwlrLbz7/KBUv6714Iz8uVXBD822yh3MKYss8sZbilknP2G74YMIm+j2AtINmK5BUY7qL6eoDUKgNIBqPVRahSzVFXDCGqH1V6U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Happy New Year!

Appreciated for your review and looking forward for the comments. Thanks.

Regards,

Tianyou


On 12/22/2025 10:58 PM, Tianyou Li wrote:
> This series contains 2 patches, the first one fix an issue when check
> the zone->contiguous during zone grows, the second one add a fast path
> to check the zone->contiguous.  The issue fixed by the first patch can
> be found in the original code path without the second patch.
>
> Yuan Liu (1):
>    mm/memory hotplug: fix zone->contiguous always false when hotplug
>
> Tianyou Li (1):
>    mm/memory hotplug/unplug: Optimize zone->contiguous update when
>      changes pfn range
>
>
> Changes History
> ===============
> v2 changes:
>     Add check_zone_contiguous_fast function to check zone contiguity for
>     new  memory PFN ranges.
>
> v3 changes:
>     Add zone contiguity check for empty zones.
>
> v4 changes:
>     1. Improve coding style.
>     2. Add fast path for zone contiguity check in memory unplugged cases,
>        and update test results.
>     3. Refactor set_zone_contiguous: the new set_zone_contiguous updates
>        zone contiguity based on the fast path results.
>
> v5 changes:
>     1. Improve coding style.
>     2. Fix a issue in which zone->contiguous was always false when adding
>        new memory, leveraging the fast path optimization.
>
> v6 changes:
>     1. Improve coding style.
>     2. Add comments.
>
> v7 changes:
>     1. Rebased to 6.19-rc1
>     2. Reorder the patches so that the fix will be the first in the series.
>
> Tianyou Li (2):
>    mm/memory hotplug: fix zone->contiguous always false when hotplug
>    mm/memory hotplug/unplug: Optimize zone->contiguous update when
>      changes pfn range
>
>   mm/internal.h       |  8 ++++-
>   mm/memory_hotplug.c | 75 +++++++++++++++++++++++++++++++++++++++++++--
>   mm/mm_init.c        | 12 ++++++--
>   3 files changed, 89 insertions(+), 6 deletions(-)
>

