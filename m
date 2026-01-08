Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95200CF6A83
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 08:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF6D86B0092; Thu,  8 Jan 2026 03:31:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DADBE6B0093; Thu,  8 Jan 2026 03:31:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85FC6B0095; Thu,  8 Jan 2026 03:31:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5CCF6B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:31:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F4141A061C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:31:24 +0000 (UTC)
X-FDA: 84308127288.09.CB1094E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5092216000B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 08:31:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NJvebwLl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767861081; a=rsa-sha256;
	cv=fail;
	b=BFGQRMyNaf2DZgH/zL/9TX+PRwmtM4shIV2DdFR6RCx6pQz4lvqyBV1w+hOt5AhAdEelkQ
	h00xdIiIxm79SJEekYo69AViESloDTaq5/Jz9A9223rIxlaxEhSDPlS5vcPcKEYAetDwI7
	l7kTmnPygU/FIxsRyGtxlbL8cL1IKkY=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NJvebwLl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767861081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yv0eUydkaAXd0JTt6buRsuIguFIbwgwukrcDuJra6G0=;
	b=hh8B7V+qFoDBxxFWH/VQNlhXoAtVReCyxcsDw1g3oSVrTiM0XqpbK2zWcCm4oDZ+XxfTTb
	Biw15j1jUptRDrAt1bd3cicSxZ4/0KmVu320nIvyYiURu7qvMFpyH5jtFsTq4fRrBa+7EC
	k6cCA2n9OMBnZRaS3c3RopgnZ6OQfUo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767861080; x=1799397080;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xk00/tCOfezyo1dX1kldbeouhGFi/PNbtldZp6hx1QQ=;
  b=NJvebwLlDN+4ou0617U/AkzC+kvOX2yaPlQJ3fMr45bT4uo1FbDAXxnH
   9ajM2fucw6Tx9rEMK2l05O0f3Yx5OL6cf6qRAl3NOrlcTmt8z+Pl3uHCU
   TOlFXqbLkF9BU41I22DUS38GhkBpbEBtji+SOdZGxvmO2nhWQkQjs40BZ
   uw876z+NHX5AKfcQ2koaPHZoyGyGBbdOa3hhD30dQvIJxh3WxcpU2NeDe
   HTl3KnoSsnEfYlm+9WGDN7O/XZDwhjNVggW6FqE/pfcQf94Y3gPGkB+28
   HKD/exQwY0x6+pHik5uLOToDNIE2u1Q6XyX8q6SPYl3zrK8YC33eFlsfH
   Q==;
X-CSE-ConnectionGUID: TmzUiLkTSGOE1QGwwkm/7w==
X-CSE-MsgGUID: u1YJ407sT32bZSmSgWIVng==
X-IronPort-AV: E=McAfee;i="6800,10657,11664"; a="69148576"
X-IronPort-AV: E=Sophos;i="6.21,210,1763452800"; 
   d="scan'208";a="69148576"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 00:31:18 -0800
X-CSE-ConnectionGUID: mbPRdoglSHWO5+4MAHTo7Q==
X-CSE-MsgGUID: 4euQhY4gTZuEE1ZIsswwEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,210,1763452800"; 
   d="scan'208";a="208211544"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 00:31:18 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 00:31:17 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 8 Jan 2026 00:31:17 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.17) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 00:31:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eze8CB4htBDdxpFV4nvePsRlDeiGa9gqJ5uhwqdTVH84vnP6nTnQdUx8VCiCSfKYp9uMEozOnveb3zQa/vqep8UQSGmlN214xEBCw/KznxBG84ALjpzjZgyZtECv4P2WvwZou1lssAV7rhqmgJUGyhy+S7v1BbOdX+679FF9T1CdANsMjqS9b6vE/9eqLY0sKP+dlenhynJSDkdVayw27RCRYNbzANokZYt1VpB+Czc5QRzl1FmUeZljuX8Mupnj/KPJh6rZ55Ckiz85B1QdTDoNe84gMrI8GkZe+vT6pZEOpkjKXs04YYiplKJdCwRBFgO/mWSR2cnuggnXViAe/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yv0eUydkaAXd0JTt6buRsuIguFIbwgwukrcDuJra6G0=;
 b=gikDBuiQJc2/3WpcReOrtW6ovY9rFBtOpondLYpFgr9SnncoxD3mm+F4eEePDJoD0OxYzIWQcz3jQ2JVxXmNWcfk+kPGRfBAzLMpNoVYv2p4WrAyc96cq0wXTt/wE9HSw2vSwdj3F52uk64Rx1iGwWcrUJq2K4UYAHpWvZaNmnpwigQjfIDN+bvxtb3Dv3CimWBOjtS1Z0KeiZYMx2k6vlCOAfMj7Wa+6SDbzFOeNQuVXnRs/fCnAqd138AQak1U1vnNgDaIzN8RSPq+8jrc4YvVdXgUdqciQn2fHX63QaP0OOhtnXFdvHhc/PIO0een5Dhbr9FWzLSCIzGw/+xDlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by IA1PR11MB7678.namprd11.prod.outlook.com (2603:10b6:208:3f4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Thu, 8 Jan
 2026 08:31:14 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 08:31:14 +0000
Message-ID: <6d2cda3f-7fe1-4436-9760-fde0622e88ad@intel.com>
Date: Thu, 8 Jan 2026 16:31:05 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251222145807.11351-1-tianyou.li@intel.com>
 <20251222145807.11351-3-tianyou.li@intel.com>
 <e5d0eb99-bd1d-4350-a6f5-367a870b2d5c@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <e5d0eb99-bd1d-4350-a6f5-367a870b2d5c@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KUZPR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:d10:31::8) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|IA1PR11MB7678:EE_
X-MS-Office365-Filtering-Correlation-Id: 81859a8d-628b-4f95-92b0-08de4e90494d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L2NRTEc4K0NEZWZGc2tXNVloYzUrS2dhQ2FmM1ovY1pvZ3lwbVpqVng4SzBU?=
 =?utf-8?B?bm8yUjdZNEt2aUhmaFJuaGJHRjR2L3dhOEtDL0wzRWVmTlFQMnVBZ1JQMHZp?=
 =?utf-8?B?NVo3RXV1ZG9xZ0VPZS9LN0xlK05JUXlVWWRtakM2K2loZnlBNWJWNGFJbDYw?=
 =?utf-8?B?KzhPRVdvb1dQcTZxa1ZtRi9LUHo4eFJNYVNEcFVVb1Era3JWQ2hFT2tIT2ZE?=
 =?utf-8?B?a1pCajVTWk1aNWpzUlIwZGdYMWZiMXg1R21FSFFCQkhLWEYyN2J6Vks3VktS?=
 =?utf-8?B?cWhQTktJWkd6eUtBTXR2TnFOaWY0Q0ROUGt5VGVqMFNzMHI1eXZmZ1JDSmph?=
 =?utf-8?B?blJXUy9ldDBmUCtxa1FnUDlDTFNqNzhaNXE1Yy83REQ3SHRyQXd5bnFldXBj?=
 =?utf-8?B?d2hQU0diTWQvQTlVUkZIQlpzQVNZT3grMSs2eVh1NDhqTXlmaWdJRXpXNnN6?=
 =?utf-8?B?MVA1SXZZenlhc2dRYUViRm1yMGdBQkVnczNkY2UyeUtoZno2L3pFU1ROeTdD?=
 =?utf-8?B?RlhDcERKNkxjb0pEb3NFY3BINTlkVElLSkQwQkplSm1DOUhpcTVxU3VTdXdW?=
 =?utf-8?B?bE83bUozZlJWTUk4dW1zQVNwMlFqSzM0MEh1ZFNvNzNRTEkvdlBJR01pL0pO?=
 =?utf-8?B?Sml2dzlmMTdJUjU0YUE1TjNkdjcvVXBrTllyQmR4R05IT1Y5Zm5iZk13MGpP?=
 =?utf-8?B?STdYcXlXQVJ2ZXNwTk8yMmZiQWdqd2RFZG14MUZOZ0VJODZvd2tCTUIvZERX?=
 =?utf-8?B?WW91bWtpWUQrT2hXTG5tYUZEVCttQ3pQUzZrVlRqamdDL2JMamg3bnZRUTRJ?=
 =?utf-8?B?Wnk0d29ITkJPajZzNi9IUTN1Q25tVjlLQU5uRE8rMmtvTDlCMmhmbG1FeEdS?=
 =?utf-8?B?TWROTXFyM0E4VThWQjFLT0x4RXNpNURra1M5ZVVlcm03Rk0wemtEc0g3TzNi?=
 =?utf-8?B?bWwwTU9YWXB3NmJxaUVpWk5YM29IVE5ReUwvb2loU3ovdGV4NnlNTHJCRGlX?=
 =?utf-8?B?M2JmZ1lSNkhmdjhDYStJS3VvUUdMQmlBa1pBcHlMbzZBWVVXOHdZaEVQNU54?=
 =?utf-8?B?WUZSMkRtbnUyUlBCUHVFQW9GRWZRbWRyRkN2a0NENmtwU0R1cXBOWDB0S2hD?=
 =?utf-8?B?djViWFc0MFlXbC9Ia3o3S3ROTE9GMWxNTGxEQmppVGM3enRXdndtei82SkJK?=
 =?utf-8?B?RDZwTllUQnFMay9hR25pbk5FOHh2eU9WU29BKzg1Uzk5ejJUdERpV3Q2MzdP?=
 =?utf-8?B?aHRpb3ViWUsvQlpRRnJaSWZTYklscnRkNFpkdy9KRjQydzlyVTM2U2gzQnV3?=
 =?utf-8?B?UG14MW1BY2h3U3RkdWNGR3JKd2o3OEcxQjd4Rm9PRmpKU0N1bGJUaHh4VTBU?=
 =?utf-8?B?RmRmRXQyc0sxLy9XRzVPdWpON285UURIbGNESE9nT3JQV3Y2cFdKOHMyd1ly?=
 =?utf-8?B?eFppVzExcGJJQ0pqeSs4SlgxVnRYUkdVSkZvZ2NRZHRoRkpSaHFHMmd1aG1C?=
 =?utf-8?B?NG4vR0REVVVzV1BIaWFOSFFkK3lXS0JlN1YzKy8rVG1LSmw2N2tUdTR5dThu?=
 =?utf-8?B?c2wwYUN3dlZPK3NFenZMWHdKMHd6UmZPRnpLK2Vody9PTXUzQ3B1TVd3RVdZ?=
 =?utf-8?B?Z3Y1YWwvbjZ0N2xnT1VaZGtjOWNKdHJNcU9pSVBCdHhCTGlNcWpJL3U2ZUdH?=
 =?utf-8?B?dEtzS05TcDNSeGYxZ0JhM1RCUGZkWmdQQ2RITVA5M01YQ3o4Z2ZNSUxOaDRX?=
 =?utf-8?B?c0tGUXFrOFYvRk1rTXBMTk9NS3pFZWtQYzRmajJ3MGV4cklHUFkrNE8ycDY3?=
 =?utf-8?B?RmhQWEJOVVJnVHZ1bVdnOU9QL3RHRDFTZW1PL0VXTy9XVG1POGE3MVBMdnNh?=
 =?utf-8?B?YXdUeTloQUpJUFA5NWRoOTJWRWhlSUlpTWRKY1J2eDZvaDQwQlRXT2tsdXNp?=
 =?utf-8?Q?PdcCTZ6IPyVQvqsQA1XueE2e+ewuSRtk?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEp3S3F2TGhzRzZubmppV24yb1hGdldLOXAwNTJJQk1iUW1UR1JtcVFvOEEz?=
 =?utf-8?B?RTVFNWVnRjlQVkpUcG9OMGd6LzZab2RWOC9BeXNSRk9ScjlxalIzb1poU0tM?=
 =?utf-8?B?WmdxSWNHc0ZUck0wZGZrbFZFZ2NhT2k1TFFWT3hmTHVTdGpGYkpoYUk2SVB3?=
 =?utf-8?B?ZngzT1pjemI1R0xsVm5nMmU3bHFsUU9SaXYrVS9UTTd5Zmw2a29ERU52ZE9X?=
 =?utf-8?B?c1krYVVDODIydzJ4dE1ueWFXcjR2cTRkWXVjYlQ0Uk9KSVRnTFJORkJLOWRK?=
 =?utf-8?B?V2N6RWpvb0dKRG44NW1YMFVQaWtqT201M3V2ZkxvSHhGWWFCVDc4V1ZWU2s2?=
 =?utf-8?B?RGRaUFlCZ2ZZL2RWYlYxdjhTNkdKSW50TFV6YUpISDJJM2JDZEV0NjVaZlNr?=
 =?utf-8?B?ZkpubGR4NURPbWk5bTEvYVA0YlE3aVR3SEgzSW4vWCtyTWRQS0UxR0pydDVw?=
 =?utf-8?B?cXloeXpLUTJObVJPYUhBYmx5VFR4QWQxYUIxVVc3OVhzTVVIbDFHVW01d3pj?=
 =?utf-8?B?bzZkM1VhRTJUVWxJMGduT292MEszUFBIbUV4NjNTUWF2RWJjZVB4cWN6SUMz?=
 =?utf-8?B?YlNWZlA5bmQrdzFJT1hHejNtSSt0TjlqT29GT09pam5rWi9tRmtTeS9iT2px?=
 =?utf-8?B?K01EVmVCK0ptM1J4ODJxNVhDdDBWTXFLcGpDeWVkVUNRN0hReitOdFczMnF4?=
 =?utf-8?B?a3FoRzRnR0NXenkrVlJhbHVrM3VuTzZHY0FTSWorR0JFbXhTZ1pDWUlIUnZT?=
 =?utf-8?B?ZDlnRnVNdzRsZlluckwvenFGb1ZMNmdFamFQL29vWkpnai84M3hYbkpVY1pV?=
 =?utf-8?B?RDFwMldYbkZOaTJ0WHBsRmlrdTRoSElWUWwwRVBqRUx6dUNzbVVCV1pzNlVG?=
 =?utf-8?B?UDc2bXdycEc0NlBXQ3lSMktLVjYyMGUwS1YzK0lpR2N4OTFNSmpQWnlCRWdG?=
 =?utf-8?B?M2kvTktOaElFMG5YSng3M0lLZ1B4V2ovTHY1c2UxZmhSaTFsWW9TdDU5L1Vh?=
 =?utf-8?B?RHdvdTNGNytvSUZUMFQrSHJvdTVZdU82MUpCU0lUZ0RBM3duL2VPakxtUk5t?=
 =?utf-8?B?SldoRXEvVnBxNzdHZTVxVWFib0FzY1JoWmNuZEpiVGpRekwrOXJxWFFzQjhU?=
 =?utf-8?B?UjhMaGd4RkpRUWJEcjNIRWJ0UlFHN2Qxdzhtb3dXMmJyaCthV2kzbkdGdzFK?=
 =?utf-8?B?K0syNklHbzcwelBNeVdUVFpCOWdrSExEcHZ3R2UwOVA4VVRTTGg1cm5BOTVz?=
 =?utf-8?B?dzFwNzRoVyswdTRCME0zeHliUDhRVDd3STdaTDVRK083MXlINjFQTDc1WitC?=
 =?utf-8?B?N2lXSldzMDhqeWM2NFpyR0RseEk3bzhUK21PVlFiaGhLWDhXbzZ2cDVSdXFx?=
 =?utf-8?B?L2NnaUU1T3gzTTlET3R5b3BySGJvT1lxRW1FREZSSkVlb0RVRTF2T3hrQUlH?=
 =?utf-8?B?cVFXVy9mNGFQODJ0aHBDeFBYTjNSUFhGQ1pJbjRrN1VmUzBiQ1dSZ0h5blBT?=
 =?utf-8?B?Y3FTU0l6dVlXUkFyL2c1c0Zubkw3LzJ6S2lURGZ0WUhEMzNneTN4VkhRYlh3?=
 =?utf-8?B?Tnh0dDQ3ZCtMSlJtbmlRRWRjMkFBd3Vid0FJM0JTQWhvMEFiS2JmWXEvQnFM?=
 =?utf-8?B?Uk9Cci9CTDVTTlRKNnFXZDQ5WnJsaVFrUWpGQkNpWGJxdXVZM3k0WlJ6cnhy?=
 =?utf-8?B?N005a1BIRyt3S2Q3TlBUQXJnTWRyeWV3TncrSUU5VTJWNTJ3eTNSWlNOdGxo?=
 =?utf-8?B?T0htakF1ckFsTWQxaU9yR205dXdDRXFYUjF2V0xBeFN6VmhZYVA1YUhLemNw?=
 =?utf-8?B?MThlZktyTmRleVBwbjc4T3BsMld5c2hvcmNFSGRET0xCMTJZdkNBSXkwU1lV?=
 =?utf-8?B?Q1h5R010Sm9tU29xUnQ2M3RGNEp4YWRvTDRXNm85ejN6VlpIMlZCWlJpSGpo?=
 =?utf-8?B?VkVzdXozNDhnNGJ1c0VFNlo0VzdLc1RLYm9nMlFJYWpwTi9ETUU1VFV0MnJw?=
 =?utf-8?B?MW5vL3kzaWc2Mit3K2hMbzkyOWIyakM2dG9HVDdMNllXd0R4UEx0d0FHKytj?=
 =?utf-8?B?di9jWUt2NnlpZDRRb0ZpR1Nzbm5kVnRERURrVHdsVlFReHVQYWpWcG5hTmtT?=
 =?utf-8?B?RkFoQzYwdWdnMnNueXVhL0pRQlpJdjVWMTlIM05CVzZWRi9Cd2Nib1hNUlZE?=
 =?utf-8?B?L3RVSklxRzFlY3BPNFp6dGRGb1o1ai9Fc0pqei8rNCsrb0NPUmRLSlVsK0dr?=
 =?utf-8?B?Q0x2NUtSQkkwMWd3RkliWWo2K2dSWVByVis3SEFZZ2MyYm1WTGlhSmRrZkl1?=
 =?utf-8?B?WXYwVTdGSmRVK1VIVG9EUDd3dVA4UStFdVAvd3k5Rm03YmFSbFZ0UT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81859a8d-628b-4f95-92b0-08de4e90494d
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 08:31:14.7758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sNztjaccsvAIxSk4ET/Duum2bTPI55Ed2LUejBddT18i/mEL3VpE3iIFqQ3lo68F3fyXrL/mdgt2EanfNtAVZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7678
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5092216000B
X-Stat-Signature: gwc845wqum5zywue1btpffwuxj3nuha8
X-Rspam-User: 
X-HE-Tag: 1767861080-137017
X-HE-Meta: U2FsdGVkX19kijrkufiTUeSgVhkUeZEPinIQkDgutFfK6eVS5WiAXu7E3Cym1m17/msjRy0+3hRcZz7UwXCgmqz/nzr/Cd8Cg8fx+lkKEAJ66aTm3VnUg8ecN6CkyBzaZy2vqlOm9pbjgXXaMaiHycYEelkhsAjQbd7W4icuGnKScLJFxIZi3DW7/JAQKdJ3XtWTNCSpAhRzluf9Y5T6ADq12B1TK+E0efoBRHyuQBEVfzmL/tZnh9gh6xP/njPXxLGgN3OV4oA/NNtVjt1HldLIrFjYsj7SRNnC3C9BOMTXoMOOGOdp4cLQh8RuT4JnfvtBVjaWA+gPAFaSOv9wDqzZoS6cC7gJEfYWjBmt3hHmX1FZt0X6ihhoy8Iof2THeXMdFwSrCNC7f0em85jFJzkQhHwinPUflqWP0s+H8180rtKunfbyS1+M4GlsLECmCWemPa7q69bVrjyRE69lELEWogNlIIHZAliXFQz0L1mKuIIj1r5K+ILLLRf/de1TvBqMBnxS+xXPGne5+2wDm8ZQ/m8jo7+SMBpmQ+1pXvsjjTS+hpCdtMyierogbz9l2JKtc90VQGfWSjKAE8wJnrkEQRSj5mj9HitsRC4sSGQlOzbvtHuUH/H7SfF9Q8uCVCPSKeVG+7WRK+a6UhbAr+X5G8LbUnTaeGN7dPnq0FlNrtmz6NdLAicPhCvTSJqD7AbxtWNdMJEwGD5MFB2HKU4M+gZTx2w6XFaxWUypv70Uh3PbTipyT9oZSVDwjDGcoC/1NvST/28uk3L6b2Qz/l+K4xixkAmGJX3WZuhTcA99ex/hg8bhA+jttjFW+5JiLpVrMO4pzL6dbP0PlzWG0aCcAF6BtGh1VCwzs+sWLQguHZsNvX2jA5lQkhQM4aS9UDUSPxG3QfsZfiSER3/l2+C3IWoL8sTGGWNvuL2FhGUseBg/d6PfUUENAizz85B2hoBWOlrVV/gQXRXXZaW
 wT4YiCMh
 8FvT4gataTL90yiSQUJfS3LjiMTS+AruDuTrc+zLCwmzpbKiXDlruNb3jLB0D+4MGw59AoH/aY1nEytvpATsg+i+No78nIOOAWNzblN8kNEyiV6WCjIwp9pK8uj0F1o0HocCYj2/pmELMM1wd7w/TeJh9E8uV3ZgaB2HwyQIoqAHzDIt3zCs3mf6+LwK1uMlJ2Xl/yoDPM5aRcdtVSn4HCWShnqSxPKE+WKlJBbv/hKsYFailq6uS2OmmLxoLGMazrLLHE/jtqfhRPK8Kdx0okFoHgRcEu7HRyNM8R+5LY+inOOksq4baGBS18xfRGG/kwMGrlGe1KOvrJr5WT6DBlJs52zi2Nmg7MX2D7S64akA4DqnHCUlrhhRx4OjNDxqMEJAhwu/bQqBz3lnPoOyFSwOqH1sNHIb7hhn2eF8G8IafqWjDh/reLcStpl2a4DYn+0vpnJ/X/OZya53bWqeNW0sGIvbBYMZcCsmZUP6dztmx6jGa2yilzbXMDG+OkDiyjMncIVFENM7ui1xwV4lZD/BTD/sxeWL+ZMDcizMr/66a23IkKpEU1ElAW9mR69HVM48ooWkOhW4ESiE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/7/2026 4:25 AM, David Hildenbrand (Red Hat) wrote:
>
> One more thing, the fact that the clear_zone_contiguous() happens in 
> move_pfn_range_to_zone() is a bit suboptimal.
>
> Maybe we need a comment here like
>
> /*
>  * Calculate the new zone contig state before move_pfn_range_to_zone()
>  * sets the zone temporarily to non-contiguous.
>  */
>
> Or something like that.
>
Will change accordingly. Thanks.


> Alternatively, we have to rework the code a bit that this dependency 
> is a bit clearer.


Agreed, probably we can have this optimization first then explore a more 
explicit approach for the zone contiguous state management.


>
>> +    new_contiguous_state = zone_contig_state_after_growing(zone, 
>> pfn, nr_pages);
>>         /* associate pfn range with the zone */
>>       move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE,
>> @@ -1204,7 +1273,7 @@ int online_pages(unsigned long pfn, unsigned 
>> long nr_pages,
>>       }
>>         online_pages_range(pfn, nr_pages);
>> -    set_zone_contiguous(zone);
>> +    set_zone_contiguous(zone, new_contiguous_state);
>>       adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
>

Regards,

Tianyou


