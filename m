Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5C95CCD19A
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 02:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 001C88E003A; Sun, 16 Nov 2025 21:38:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1AF48E0002; Sun, 16 Nov 2025 21:38:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBBB38E003A; Sun, 16 Nov 2025 21:38:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C55E28E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 21:38:20 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80E0812F479
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 02:38:20 +0000 (UTC)
X-FDA: 84118539960.04.3739A22
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf11.hostedemail.com (Postfix) with ESMTP id B3ED34000A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 02:38:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PvRXwauI;
	spf=pass (imf11.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763347097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P0dATMg4hDipuw2W9rRnH7NqzEv0WEOMv0v4S+Uenxs=;
	b=rwVb2lDw5f/UfsEi0I10cwuECbgw7q6jDVA2AFPKNQ3Bb1652gQo/yXI7bof2t236PGojP
	bzrbo2HpKTnDvqeXUHK5EG+CBAiUhEpRmGY2TW9sQH9M5IYXux2tzsxUSQ3H39N4baewsA
	1dBW129Es0vKiL1Pl7Kz5aWRkYqXbx4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763347097; a=rsa-sha256;
	cv=fail;
	b=wplHq0wPcGz+VaX3f/4svHN6cfEBuPyfX6jROMkg9FkBVA2rneTvF8nURPCFjonV5o6I9S
	7VAebt/xtkz7O9bGyI5S1/h9LC+4UnO3r73N98Ot5wuVF2kMCfxsr7so4636Bbv5QZ5dcB
	cY64Azb+fwEA0NQwOfjXYxF5nepsU/M=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PvRXwauI;
	spf=pass (imf11.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347097; x=1794883097;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U3EasD9Q+P85VWyK++IympgPOzJx5hp9qCBv7ddhYgs=;
  b=PvRXwauIUnpO2xG8YBSK+iXg2BsReUKuZ/EY+wy585HEiB15YEXbn1bA
   R3X5pORxGxt3iZ/fYqeazJLHEqfAp3zhaIbtcvDN3g/CpbC/ivr8K/TGL
   RUfeeLxdOHVtTyZQ/Jxrz1gFJIyIRLuS0evTS6Nmlr+Zmfh4BV8mo1Y0+
   l40bIjd5HrVaLtFfFl2zPNI8bvI5zOsES0+K9RDTZJqGjN6uEIf1MGGj/
   UZqiHxxjoXjjcbAMIWz4THRnsfW7QeoK0pRBmAebqlX5hbjWg/IqPWHTO
   gDL9x1dD42P4mUgtj30jsjV5mBys2VtAD1UBSGI8nNzbs+51GCTdV0ZFI
   g==;
X-CSE-ConnectionGUID: zE7sBOTzSeiuQ2uVo94bUQ==
X-CSE-MsgGUID: rwS625LUTiaoBqYdzpeD3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="52910007"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="52910007"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:38:15 -0800
X-CSE-ConnectionGUID: XPGno175RYqtA87CDTOz2w==
X-CSE-MsgGUID: +K/d93iuSv61u7I/1N0NfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="190769198"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:38:15 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 16 Nov 2025 18:38:14 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 16 Nov 2025 18:38:14 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.14) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 16 Nov 2025 18:38:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UEhxmJ/fg5wMeqNbCWM5z9X7eGcfBkvs1SkIczNk/5u5Eiavfhv/HwhCUt6C+8Fq0dkI0uZ2WHfc9gri8Qr5o3lQrXeXpisNKsoEuYxjZccAmdF8nE+uwpmAWDQ5yisqu0FlaWXPUzsoDdrpxe21rAqGkUCGjRfC5aKaoqHeGjpmfUFxZaukEC5Jsd5QeQCs+hNNMgk+ukwhqQXRjhTdzx4q9DAVezEqYEUUmZGHmvfplGf33lDQpGDtdHqbSiPOooydvoOAP4rE1on+pFZ58dyoAcJo7TdKl5ndWi71uZjLDCvQuDkG6V9PICCAhPX1GRkhD6Q2OlDWTCY7KOq9rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P0dATMg4hDipuw2W9rRnH7NqzEv0WEOMv0v4S+Uenxs=;
 b=x9cDudIkDgJTjvZbFpGVKelHxLAyujsE1Nihb3Q6Usw0EQp1sl6ExGKmzsWEsK1dlesGcE4A7tsF3BHgGh9cm+2oDoGBm49YxLy3H2OAdWQoTIsi/Wa7Vf4d0p13euHS2a3GNeWk4z8RnCZZnyKxTNwmp44M6tYK2hO6KM8jPHRxA/n1Wdvt64BNr7bP6ypX9Gjln4xlSKiCSzu/fjYG/Jf+ljlgaqo3RDajrD/fBa+gBLSG1vcfX00F8goOX5lwhCbHUIK0+26ohiEiHU6ZpJUshj8fPPFfGrBwJTnuTccL+CAc4yw5iJdcH0wb0vZ8tivrMtoOgoGla/ZUzpmP3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by SJ5PPF09F392AFF.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::808) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Mon, 17 Nov
 2025 02:38:11 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::d626:a4f8:c029:5022%6]) with mapi id 15.20.9320.019; Mon, 17 Nov 2025
 02:38:11 +0000
Message-ID: <0ae59381-7eec-4838-bf76-21ae547a7778@intel.com>
Date: Mon, 17 Nov 2025 10:38:04 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
To: David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>
CC: <linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20251117033052.371890-1-tianyou.li@intel.com>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <20251117033052.371890-1-tianyou.li@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0124.apcprd02.prod.outlook.com
 (2603:1096:4:188::9) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|SJ5PPF09F392AFF:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fb6b5a9-d012-4b17-8b49-08de25825992
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bnRUV2Ura3ZnZ3Avd01UMmt0T2pBaGxpWk1qSjI1MG1Hc3ZtWnQ4dnRCV2VI?=
 =?utf-8?B?V0ZVdjEwMVZkWnlYVk91d1ZlM1pKc1Q0aDFYenZVQmxaR0NIOXRpOFZVRlh1?=
 =?utf-8?B?dW8vbFhQbjZzczE5SHBNZFd4eVFXRGhpdXRWTjlvNmRYK3RtU2c3NnJqQXR5?=
 =?utf-8?B?WGl3YkNmTjI1N1phZjRDTzUxOUNPZ0l1RmpsTFlOV1daV09LQlUydC9OUUdm?=
 =?utf-8?B?NUhZeU54UVFmM1ZQeUxZWXZTVkhvbCtmK1NyRDJWdVlGa01aOXpPZWUyekto?=
 =?utf-8?B?S01GUmROSTZCWE9qMXNtNTNjUnlHTmhUWTBZQ0EraVZVK1JLQm9qUkNJVG1v?=
 =?utf-8?B?eDhPYmNQWXNUN1YweFcwMXRrZU1VVlBtMi9Xajl0RFBWTUFuT0t0WEtnanQ4?=
 =?utf-8?B?RU9MUm81NGNQeDJIRlVMSEd6R28vMTZiZ1RPZDBPdXJDVE9sZWZST0tLL3p3?=
 =?utf-8?B?eUtZZng2QXZLa2J1eHJwV0xZcjd1WEd0UlJJV1lkU1NXdm9DeGU1Yi9kdENm?=
 =?utf-8?B?UjNUdGQ5SlR3aFBVdDhuVkJFMGhUbkVGNkdSanM3QU1ibjZvbEJnSk0xMG5M?=
 =?utf-8?B?UGZubzBHeUIrZ2R0ZmtnNEkybFNESEhsM3JWb3NHMk9MdTFQM2VtSVlSamZC?=
 =?utf-8?B?dDZQN3Q4amt6NUhDZXN3SHI2ZjE1UUV3ZTh2SUhhd3FCdnYrNUtLTXQ1NjRQ?=
 =?utf-8?B?US9yeHVzMEkxTldtcWUwckp3WFhMN1A4NFFZcFBkN25mVDk0T1hscUVPSUtn?=
 =?utf-8?B?dGJxeDFRcXl6cUR1ZVh2ZDdpS1pkWldQUE5Ua3VqS0U1UG1qVm5WYjN4Z0F1?=
 =?utf-8?B?K09FcWIvUitBT1ArTDdYdTZCRVplb0F6L2dhYmhSS1RQZko5TVYrdlo2c0d1?=
 =?utf-8?B?dklSU0l2dnNUTzhNWExiMnhoQUFGZVNsY25Fb1hsNGxlSWFOYmYwWHlJVjE4?=
 =?utf-8?B?bFdlejdaaFhyMCtydTdpZG1TekVXN245WkY5OVNjbHdJTm5HTlhVbnp6cXpi?=
 =?utf-8?B?czFEY1hTUU5vSWVNYXZYeU83aGdoNHV2YXdValZxdDc2RHlKd1ZYQnoyaTVo?=
 =?utf-8?B?VzUzcUNERTh2dE9KSWJNcThHN1lYbWwxdGRWZis5dGI5VWMycjFaYmIyb1g3?=
 =?utf-8?B?Y0Y2STlPc1pnd3RtcG9lcG1NR3V6R0lmVmdCZHhqN2ZZMWlRd01wRGlOdG5H?=
 =?utf-8?B?Zmd4NXRKb29UWjhwUW5OLzhQSTFFK2RpbWhMZ1RQMWRLVEU0eWxiTkxYK1RL?=
 =?utf-8?B?NDBmZzgzcEpYOUZLWExuSHRrRzFiczRFVUxYNXVOTEFEclI3V29mM1RzK3Y1?=
 =?utf-8?B?K2p6WXBkb3had2hJK2tsemprUFY5MHN0aWxKQWdkRkRrOHlhRW9qYWNZU3dI?=
 =?utf-8?B?L0Y2ZFVXWFBMbnFxYzRUNnVTTGlkenNyUXdwcmxjNXZmdUt0cjJKakRGZkFa?=
 =?utf-8?B?WEdMU1hCZmFjNFFGMGJ4M2hYZWZSNG9TVSttSnlmaC9IcVN0a0ZjSzhHdWQ5?=
 =?utf-8?B?cW9DUkh3S1VhTVVvSUc5OGJXdTkrSlk3UlptUFpxajdMcFpWeDNyTGUxZjRE?=
 =?utf-8?B?b1pQaHpCejdxYjlLWXBFb2ZrU0hZaEFDanNRbW0yQ0gyN0hQTzZNbmVqeEpr?=
 =?utf-8?B?MzhKaDlGbDJ0N1lER3RwNktGcjNOdzhvbms1dnpMeGQ4ajJubmlncWdYTURF?=
 =?utf-8?B?cDdtUXBKT0xldXlxa1NtV0NHemd5MGpjaFFwNTVpUVdiSDRvUWdHUE5leERo?=
 =?utf-8?B?UlRrZmlQajU1RnNkK29qc2lWVzFrVWxmd09Na2VGN3BnOWFQdnY0TElaRFc1?=
 =?utf-8?B?WUgxVE5VZEU3ckJvNWZYSGROTXgwbUY2RVJQamsvSXhCcUxqaUF3VjZrUTFZ?=
 =?utf-8?B?S3BWZ3JJdjNCWDNPVXQyYklhOEJqQ2hBeU9vd1ZjNkhrNFIvUlowcDFlNmVY?=
 =?utf-8?Q?cpr0q101011Fq+V+GBEFPETEUlaxScSW?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmlOTEJKZ0FLWFpjUGt6SGptQ0Z0RG5hOVNiK1FSRFBsdGc1NHhQWGdCN0tZ?=
 =?utf-8?B?S0F3UnhhRGI3akx1QWVRazN5UUpyQ2RjUzczMk13WHhaa2VpcG82RWhPRWNr?=
 =?utf-8?B?bys3UXVzRDB0L1NsdDllM3dQeTd3a2dMWXVuU0xQTkFmZmw0NUQvQTNyUmxu?=
 =?utf-8?B?c0VycjhpRFFpNU80cThYQUZScXZMaFdxRXFzdzRRbG14cC9qT2ttS3F6VkI5?=
 =?utf-8?B?RFZzdHJGb1FrbmRlcU4yZmRaZDFCQjRtZFF3QU1aMFhaWVdPTWd3WFQ5OW1H?=
 =?utf-8?B?VVFseWFwUk9sNjl3eHM2VmhlU1NzYzB3dlo1azFoNHJuODYxejNqeGkzakk0?=
 =?utf-8?B?MVI4ZEtDakJiNDdDQWQrLzZ5bjVrQllQMEtjSXdVT0FaRk5LSUw5M2VyTDYx?=
 =?utf-8?B?dUFzSXJvUjUrZm5WcUlpUXByWVB4TTZ2L01OUmNjSTJ1Sm5JRnRFU2h5RlB6?=
 =?utf-8?B?ZVAxcGxtZVJVL0JUSzMwVnBBZ29tUHNSNXdVK2NlUCs2ZDBrbC9HSk5ldmVN?=
 =?utf-8?B?Z0pVZDdkeE9jSDcvMk5HaWVjVVlDN3NSYlZvMWdvMEN1QzFPVkNPQkhXd3Yr?=
 =?utf-8?B?YTlHdDZCL04rbTZHZVVBbEdOWENDZHFpOWptL0NreFcrd2tJNVRJV3poNmo2?=
 =?utf-8?B?M0dMYUpSUFBVSVJyRFRoODlLbGg1TmZOcE9TdzVzOVIrdXJHamkxQ3p1TVMx?=
 =?utf-8?B?K1lxMzlBdkgvVDZpdEd4bFkvakhQRUpvVm5KeWIzRUJyb3o0dlZMM3JXOHd5?=
 =?utf-8?B?NkxmY21heWtiTSswZzBOU3RPdmh5aFFkL2R0d091cUZ1a0pGVDBCbWYzR0FI?=
 =?utf-8?B?R1RxVnFGRWd2YklVZDR3QUMvTGFVVm5ET0xnMjV6S3hyaWNmYXJPRjYzamxr?=
 =?utf-8?B?dUdmQTVhQmJEQzVXSEw0emZ2Wnk4VG9DN2tvdUdWd1c3WHRNSXBRcEdGNHBO?=
 =?utf-8?B?OGxYNzNaSWI5aXFtNW1tQ0phY2RFMUhKZlVtdC83Q0w0bXRXTFdhRmZvanps?=
 =?utf-8?B?aDdmVjVNMnE4OC9zVHc1VWRNbnBpeGdiSXdYRWtkbVMvVDEySG5Nc2xwcTE0?=
 =?utf-8?B?dEhnOC9XSkZuZk0rRmtyV2JLTS80ekJnN2NBaFIzRHFpTkFQOTZpaG4zVTV2?=
 =?utf-8?B?VHBRa2lSSWo1amtoc3R6WVZYRGJDVk50bHpja0V6ZC9NSFFtdExiM2pEaktr?=
 =?utf-8?B?cWxyTmtpRGdkaVdYL0JxeEJKdEc2Skw0WTgwRitjYU52dkRQcjl5b0ROdDQw?=
 =?utf-8?B?QTR2anErOVdNT1RSdHhwenhUUlF4bk1XR1dUR3Q2Lzc1M0xaS2xWVTBLSXcv?=
 =?utf-8?B?dlo4MVdid2xpUFlwRWRiTzBhTVVWYWNGenVxbFdGOGtCaHE4OEtkczJlb1Ro?=
 =?utf-8?B?NDZyeStrZUltaTdISjNQQzhpVTIxZVlJZ1JrSXBSWnBScG9VTFArMEF5alRu?=
 =?utf-8?B?d1ZPRGN5YjZqMWdwVWl5VW4vYlJsQzdYbmlnR2hQMllDYkRlblI0RjN5R2ln?=
 =?utf-8?B?Q3JFS2J1L2p5KzI2TWhPTXhqQzNTUDRTVktMVjhLYVduNVdoZGJ0cnFHZXBk?=
 =?utf-8?B?bVRTeC9vdjV5ZXY0SXNWbUFXVCtjVDFSdjBtRDRXQjhLbjFFVmdENGhhYkE4?=
 =?utf-8?B?S2xFUFU4cWowYmlQaUIxK3grZVlqdEJlcVNTV2w3QW8rb3JpQVh0cUtIVUk5?=
 =?utf-8?B?d3M2c2UyaFA0dXRmWVgzck5uQ0V0aFBjMUs1a3JrSzhNWGh0L1kxeHdaYmZk?=
 =?utf-8?B?T0JFSjEvVnRyV1d3Rm5uU1IzYjNiRkFNMTNCVFpSb0RnL1l3MmptMzMvb05k?=
 =?utf-8?B?T3pmRFl2dDl6ZlVjL29Tdm9VUTZHbms4ajRENHduMGlBZjhmbis5K0FEbi9Z?=
 =?utf-8?B?ZUppejlrY2lWWnZ6T2ZjTThTREQwTlRWUHMrN1JkQ3paL1ppa1phWWZzSWRJ?=
 =?utf-8?B?Q29sQXdtblBVNVhDck9zRkdmNURkb291bWc5cTd3Z3pOVXJjRzlsOVNiSFFH?=
 =?utf-8?B?TFYxbHVlYlM0blhoMitQd3M5UjBqT1Z4NkVVTkZ4bXVPUkE2OGZKeWx5aS9t?=
 =?utf-8?B?bnNQeGRmbHlZNlZ5ZFpqaTk0Q1BhTytlYTcweDB1aU1rd3F6azdvbVhVWlRx?=
 =?utf-8?Q?1b4z8BowyO9MhQx2Yv+yyMK8I?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb6b5a9-d012-4b17-8b49-08de25825992
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 02:38:11.4624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f3/TjxBZi9PTVb1NSzJriWeQajIOF+FtCaaUucyRKWdwbXFZ9RRDf2NAVZhAWETP4GMB9kU9znmV60W/lrgacg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF09F392AFF
X-OriginatorOrg: intel.com
X-Stat-Signature: zc9d8trn9jcezw4tbcsnamduhh8aq3xu
X-Rspam-User: 
X-Rspamd-Queue-Id: B3ED34000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1763347096-944525
X-HE-Meta: U2FsdGVkX18nN8pw7vz2DdWSB3UwXaht7KCeA8FkLvhQIvy6Fl8LvFMfCBXeTmb8e+j0wn7p5CQWRYzX0UtLhOtAj/KCCtJipDRKeOfc5y9dwBQXGDa45ROy6/IZR1QHACrfMmEJ50jK7jSKHoi2ekjY5ilYUnYquXm3/jNM1rfpcSEmuY1rxUkRe4djrnHWCd4TJYkgWftoco9okv1HO+kYV8Y9Ua5yHoRzTvG+JfvChDkl6Lbk0DmXo/k31Na0ubQNISBKKVGDJAoYVWMb3ntbVIdLV2+ipC0a8i0SRGXI8tmnRR2ikVKOrLvCXyqQlbjsGnxASEnk3ArGqqEPkiJ/vL58LB8rL/hNkOn6yhxiWVeoemxbcQnu+t7BVM8yx33SYOPgEd6WnmhY3b1BHNgC2C72p8LrBF/rv25E7gawo2w/7U2HDPbJKRaE7Lyq1AVuhCvTyYKuEIhUu+q5J7ESKCrkqOcBUKj3N6JiCE7GK7yzmeoR1355BI7mOJVZij1R/eX8JEt2VCMhJXL9ETZqt3JM4mZbd3E7jYs6MNwlcCSFOpItmIb5s0HSxDDaDps9/mNBe1pG+ki+Pc00N4vtlCkDdqoCwcOQRpPW0mgkPUgaf7WX5Zt8dAqDUEjY3sDOQzLqymZdtNAJJ+NlkM1uVUy1Vb9uUTVWBUU/olMWyZBN2RznTAXrI39JYpy0VZONzInVGuTJUfGdaizrAdJIbQ43IWYDVrV86hnN3Jx3XjprL/HQsm0iJ07YTnxV1sYh3cBXe6yuzP/pyqrDFK32pj9NA3d4WCkz4V7GkjqPmbivrSKFz0ld/FcB86RSdwNTV3rYtb2GAqW+tRx3Cv9NFSY9Kg6kNNpfgMnbBOh7XNrqSpzhTqxEMepIUUefYTw52NzASwRU/ejjnty/znndzCaOQHMz7Gqj5LWmQ8d4jxeY1idPTG19FGIxQ2NQ/aeCRs1i+i/BjmjuJPP
 3DghpgbT
 cN/jc4/amkspEv9vg4frW5OeyzHR02XjxvW2PXhwEacIHCs0AFMSWPCwONrwnAcu0CCAva1J26h07vSm8OX5/38pAEkVfS2G4cpje1OTGnVEnw8nK9HaliyhpKKOTKyAy0UGyIxCKQy0149rQJs3ZJZh54665MtKaTIHEuclqAqaR/J9H4FrFlxMuTkJcegYskG3uEVCzand9aHPcv3ee/SdvxuUyVaz1T8ly1RQUiSp41PjlDnsWqmrZPzhUZ39fKSeXeRCL3H/s80RV7pPPE84wKYQ8Od3iFHp98SOMXhHgz0DBkgTmEpQbKhtxipyw/63YHtzVgk1mjc/CnxZxREqcV9ps+GEtrDVPos+12ZuX3DpqsyA96mJ7U8Owv0s4ACtgJZwWK6/cLu7Ze2PR+cMIrA+jHNEJ3V4xBSd+q5hf2Sq6V2PFpPntVm+D5fcogSqnNzRt2hYHr+A6RWcDGsBkBGZ5LKFBm3VJHdDWMMCUAHHJZryvq56cBhaQLclNm+EWAJPkLqR81uD711YjOrpPLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

Rebased with latest master. Add "Reported-by" from customer. Looking 
forward to any comments/suggestions. Thanks.

Regards,

Tianyou


On 11/17/2025 11:30 AM, Tianyou Li wrote:
> When invoke move_pfn_range_to_zone, it will update the zone->contiguous by
> checking the new zone's pfn range from the beginning to the end, regardless
> the previous state of the old zone. When the zone's pfn range is large, the
> cost of traversing the pfn range to update the zone->contiguous could be
> significant.
>
> Add fast paths to quickly detect cases where zone is definitely not
> contiguous without scanning the new zone. The cases are: when the new range
> did not overlap with previous range, the contiguous should be false; if the
> new range adjacent with the previous range, just need to check the new
> range; if the new added pages could not fill the hole of previous zone, the
> contiguous should be false.
>
> The following test cases of memory hotplug for a VM [1], tested in the
> environment [2], show that this optimization can significantly reduce the
> memory hotplug time [3].
>
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Memory Hotplug | 256G |      10s      |      3s      |       70%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      33s      |      8s      |       76%      |
> +----------------+------+---------------+--------------+----------------+
>
> [1] Qemu commands to hotplug 512G memory for a VM:
>      object_add memory-backend-ram,id=hotmem0,size=512G,share=on
>      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>      qom-set vmem1 requested-size 512G
>
> [2] Hardware     : Intel Icelake server
>      Guest Kernel : v6.18-rc2
>      Qemu         : v9.0.0
>
>      Launch VM    :
>      qemu-system-x86_64 -accel kvm -cpu host \
>      -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>      -drive file=./seed.img,format=raw,if=virtio \
>      -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>      -m 2G,slots=10,maxmem=2052472M \
>      -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>      -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>      -nographic -machine q35 \
>      -nic user,hostfwd=tcp::3000-:22
>
>      Guest kernel auto-onlines newly added memory blocks:
>      echo online > /sys/devices/system/memory/auto_online_blocks
>
> [3] The time from typing the QEMU commands in [1] to when the output of
>      'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>      memory is recognized.
>
> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
> Tested-by: Yuan Liu <yuan1.liu@intel.com>
> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
> Reviewed-by: Pan Deng <pan.deng@intel.com>
> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> ---
>   mm/internal.h       |  3 +++
>   mm/memory_hotplug.c | 48 ++++++++++++++++++++++++++++++++++++++++++++-
>   mm/mm_init.c        | 31 ++++++++++++++++++++++-------
>   3 files changed, 74 insertions(+), 8 deletions(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 1561fc2ff5b8..734caae6873c 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -734,6 +734,9 @@ void set_zone_contiguous(struct zone *zone);
>   bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>   			   unsigned long nr_pages);
>   
> +bool check_zone_contiguous(struct zone *zone, unsigned long start_pfn,
> +			   unsigned long nr_pages);
> +
>   static inline void clear_zone_contiguous(struct zone *zone)
>   {
>   	zone->contiguous = false;
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 0be83039c3b5..96c003271b8e 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -723,6 +723,47 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
>   
>   }
>   
> +static void __meminit update_zone_contiguous(struct zone *zone,
> +			bool old_contiguous, unsigned long old_start_pfn,
> +			unsigned long old_nr_pages, unsigned long old_absent_pages,
> +			unsigned long new_start_pfn, unsigned long new_nr_pages)
> +{
> +	unsigned long old_end_pfn = old_start_pfn + old_nr_pages;
> +	unsigned long new_end_pfn = new_start_pfn + new_nr_pages;
> +	unsigned long new_filled_pages = 0;
> +
> +	/*
> +	 * If the moved pfn range does not intersect with the old zone span,
> +	 * the contiguous property is surely false.
> +	 */
> +	if (new_end_pfn < old_start_pfn || new_start_pfn > old_end_pfn)
> +		return;
> +
> +	/*
> +	 * If the moved pfn range is adjacent to the old zone span,
> +	 * check the range to the left or to the right
> +	 */
> +	if (new_end_pfn == old_start_pfn || new_start_pfn == old_end_pfn) {
> +		zone->contiguous = old_contiguous &&
> +			check_zone_contiguous(zone, new_start_pfn, new_nr_pages);
> +		return;
> +	}
> +
> +	/*
> +	 * If old zone's hole larger than the new filled pages, the contiguous
> +	 * property is surely false.
> +	 */
> +	new_filled_pages = new_end_pfn - old_start_pfn;
> +	if (new_start_pfn > old_start_pfn)
> +		new_filled_pages -= new_start_pfn - old_start_pfn;
> +	if (new_end_pfn > old_end_pfn)
> +		new_filled_pages -= new_end_pfn - old_end_pfn;
> +	if (new_filled_pages < old_absent_pages)
> +		return;
> +
> +	set_zone_contiguous(zone);
> +}
> +
>   #ifdef CONFIG_ZONE_DEVICE
>   static void section_taint_zone_device(unsigned long pfn)
>   {
> @@ -752,6 +793,10 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>   {
>   	struct pglist_data *pgdat = zone->zone_pgdat;
>   	int nid = pgdat->node_id;
> +	bool old_contiguous = zone->contiguous;
> +	unsigned long old_start_pfn = zone->zone_start_pfn;
> +	unsigned long old_nr_pages = zone->spanned_pages;
> +	unsigned long old_absent_pages = zone->spanned_pages - zone->present_pages;
>   
>   	clear_zone_contiguous(zone);
>   
> @@ -783,7 +828,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>   			 MEMINIT_HOTPLUG, altmap, migratetype,
>   			 isolate_pageblock);
>   
> -	set_zone_contiguous(zone);
> +	update_zone_contiguous(zone, old_contiguous, old_start_pfn, old_nr_pages,
> +				old_absent_pages, start_pfn, nr_pages);
>   }
>   
>   struct auto_movable_stats {
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 7712d887b696..04fdd949fe49 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2263,26 +2263,43 @@ void __init init_cma_pageblock(struct page *page)
>   }
>   #endif
>   
> -void set_zone_contiguous(struct zone *zone)
> +/*
> + * Check if all pageblocks in the given PFN range belong to the given zone.
> + * The given range is expected to be within the zone's pfn range, otherwise
> + * false is returned.
> + */
> +bool check_zone_contiguous(struct zone *zone, unsigned long start_pfn,
> +			    unsigned long nr_pages)
>   {
> -	unsigned long block_start_pfn = zone->zone_start_pfn;
> +	unsigned long end_pfn = start_pfn + nr_pages;
> +	unsigned long block_start_pfn = start_pfn;
>   	unsigned long block_end_pfn;
>   
> +	if (start_pfn < zone->zone_start_pfn || end_pfn > zone_end_pfn(zone))
> +		return false;
> +
>   	block_end_pfn = pageblock_end_pfn(block_start_pfn);
> -	for (; block_start_pfn < zone_end_pfn(zone);
> +	for (; block_start_pfn < end_pfn;
>   			block_start_pfn = block_end_pfn,
>   			 block_end_pfn += pageblock_nr_pages) {
>   
> -		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
> +		block_end_pfn = min(block_end_pfn, end_pfn);
>   
>   		if (!__pageblock_pfn_to_page(block_start_pfn,
>   					     block_end_pfn, zone))
> -			return;
> +			return false;
>   		cond_resched();
>   	}
>   
> -	/* We confirm that there is no hole */
> -	zone->contiguous = true;
> +	return true;
> +}
> +
> +void set_zone_contiguous(struct zone *zone)
> +{
> +	unsigned long start_pfn = zone->zone_start_pfn;
> +	unsigned long nr_pages = zone->spanned_pages;
> +
> +	zone->contiguous = check_zone_contiguous(zone, start_pfn, nr_pages);
>   }
>   
>   /*

