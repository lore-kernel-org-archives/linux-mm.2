Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F5EBEA854A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 00:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5FD6B0005; Sun,  8 Mar 2026 20:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2066B0089; Sun,  8 Mar 2026 20:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681296B008A; Sun,  8 Mar 2026 20:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 506336B0005
	for <linux-mm@kvack.org>; Sun,  8 Mar 2026 20:42:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EDCF61C97B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 00:42:26 +0000 (UTC)
X-FDA: 84524673492.21.0055B49
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4F12040005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 00:42:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="I/jOAG1H";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf01.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773016943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUj3H4MV7IiJRHIs64G/Ez4oBUvC+hi+0I9mlWF52DA=;
	b=yW6PXbFRGzfkvGCF74O5gvMJ6iCW+kCTxutuPiInJi7QDnSKDVLeDnHSs/LXWmEdkOmLkF
	VY+GRnc6n6ML6WJAeNQ/uj3KXiKMzAeIP6nY7cMABFa88OLAoWjGRORo8Dx+Y0uEuLC4Ui
	zlLLGP3bncK+6o0bwmWHUnVtFkRx658=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773016943; a=rsa-sha256;
	cv=fail;
	b=zH5Y6JXYN0YfKxkwA6kcpiYpuvXvRVZ97a5fxU3Chs/kEHjf62zW3KwCCvVYxBu65N0PlV
	JJz7rz9MX8z2mWMTa582lunTNmtNjnyFjCzKi8OekC4U+MYcrKvOpeFUINEVlKkng4z3Xz
	oy33Ez3QJF++Pt0XSMvv8d74ZJRezVI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="I/jOAG1H";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf01.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773016942; x=1804552942;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zi4p9BuaCKJsmdld/i5p6U1g4yDUxV7jBOr3wObEtyI=;
  b=I/jOAG1HLLUKQgIoJEU07pAWfIqPF7+eV9irpgRrnVqAKazx1X1uNhAY
   pmJSdDrGBTRxV4KIJ/Qsqgz8CfkeUM0H6O4L7ykjyGx7n741lIy/59Gyp
   LJQRX3TL4Y8DuUy17Z70Ia5s11XVObKz5euGTGfnvXRpkSjJkfrAv2nlY
   89KhhOC07gFMtpogptzoCXijl0bL2pStqBacq83jiafgd5MPV+cgOw2QJ
   jMGf5Y7SOP9tzAptXlvFSfTqMXqHO2wO6jh8rX63d3BO5sNtT0s9shZvd
   qQkcBrkJobgBsePRcQxTSH/qlDLHr0ojVY41su/N12CKijRZirLgPNDkh
   w==;
X-CSE-ConnectionGUID: hCd91UAjR6CuqGPH1N9RpA==
X-CSE-MsgGUID: D7THZTUoS4iWSKp1A0Nw3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="61609224"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="61609224"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2026 17:42:19 -0700
X-CSE-ConnectionGUID: hM9sMTHlQy6k9VzTH5HvuQ==
X-CSE-MsgGUID: MUDHD9SGR6G6nTqmg4ZJiw==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2026 17:42:19 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 8 Mar 2026 17:42:18 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sun, 8 Mar 2026 17:42:18 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.26) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 8 Mar 2026 17:42:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l3niEbKoNXy0pfSUUojVfumzpBdD5bz1m+3yrtgV7dVfUpLJHRPNvmV/ctB67BlTplLdHwvxR4dJ3gxMblE7QAyI2Kh2ntlYUAN8kz+t9nVLPhUVMvp1OfBxfcqRhhkw6ZWXLYpH4GsoAWj/f5Mt5SmGtzKIJjHheWP9gR+E2+UQSnOdYKTd/L9nbqbXmbsRdtnAUWdVqcKockY345CEb1nTliu5LMah2UDDZvdda3o0m0momT0Uq2k72yoWQ2EFiyxX4qHzCDFklcUfWfXcO2H4eICqSG/rLdXYel+19txnUPTuEcvlASS3yait726m2zWXjL5In40j/KElOB8rhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUj3H4MV7IiJRHIs64G/Ez4oBUvC+hi+0I9mlWF52DA=;
 b=mlPn7hvWmgXBJduRWkB3ymaq8/2iwP2BKwl7KCBWbN6EqUYxvsNMK7Xo2xkWxjNdDaLQ7n+ToedWq+KyQ3X3G22YEEA4vlD0MosNTd11ttqzVOUVnrKE6PzpLQggJNBuKy3kLuQu17VHVIMksB6AocJqC8R/txXahZwPfryq0lDV2WM2OvY7wtO/P8RAzhRrPITQ/I4kEo+xAnYx9exwReBUSpuhGL6ziyhQOGHIAYKAY1r4/c7kKsE7oVPMb018pUOjOdjPJkAhdflsRzI7kVyRW/f728cFpgx/6r9Sr45Jw8YlZupx6VBUVyvXLy3dhGMVGDwnwnsV+utlA2y5Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by DS4PPF6915D992B.namprd11.prod.outlook.com (2603:10b6:f:fc02::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Mon, 9 Mar
 2026 00:42:15 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1%6]) with mapi id 15.20.9700.009; Mon, 9 Mar 2026
 00:42:14 +0000
Message-ID: <24ef67e7-6f0f-4544-a50c-90c4de368c40@intel.com>
Date: Mon, 9 Mar 2026 08:42:06 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
From: "Li, Tianyou" <tianyou.li@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Mike Rapoport
	<rppt@kernel.org>
CC: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
	Michal Hocko <mhocko@suse.com>, <linux-mm@kvack.org>, Yong Hu
	<yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu
	<yuan1.liu@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo
	<qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>, Pan Deng
	<pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	<linux-kernel@vger.kernel.org>
References: <20260130163756.2674225-1-tianyou.li@intel.com>
 <20260130163756.2674225-3-tianyou.li@intel.com>
 <3cb317fa-abe0-4946-9f00-da00bade2def@kernel.org>
 <aYjmcZ4hg9bNbmiY@kernel.org>
 <6ea2dbce-c919-49d6-b2cb-255a565a94e0@kernel.org>
 <2cb55d76-4da7-4ebe-b23b-0abbc4d963f3@kernel.org>
 <aYsaBkMecDG595Xg@kernel.org>
 <b3777d0e-0b25-45bc-b387-e67fe5a0d328@kernel.org>
 <de501b65-6d02-4eeb-b50e-bfe5ab9b8d00@intel.com>
Content-Language: en-US
In-Reply-To: <de501b65-6d02-4eeb-b50e-bfe5ab9b8d00@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0040.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::7) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|DS4PPF6915D992B:EE_
X-MS-Office365-Filtering-Correlation-Id: f2c85cd1-09fd-477e-531a-08de7d74b550
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: jxwCFM0/3ejBGtAcKOf6ANgMt9o9qxOvaS3bqKhiZAtqAd7g+46IrUHUQkn7e7SMdqjhE0/nueLT6UJKd8lTdQnQTWcJH1GC6p5rEy+kOm8jSWQexb5AOrGCYtlHK8+tO05BhtQ8lZbVe4nM7cnj+U8z001bkyxODGcQ7BdGoSr+Lk6NmQadBRHscLCunFo52ym4Mxd05A/CEqMjtj74jt6l2d88XO9R/Y7VtVsSO/H6J8gcM8rLQgg0OQi6xlbYE7imIFGD1flXfBlb6i7wczkFVZ7Hm9nx2fEgnrFu3AggGTKr0gvFPk9LUf5GBqsVKh4PQrpDABnkCf68xk6rSDh2UgnGfoK4VM843/OKAzmHKGV3b6J40Utuum7WVYacR7O4KJuUPFUbNq3AVOGNKtDlOd6gtZdkhHoymY3CHxhEvfD/bS8B4/J59B7mCjLWXTBv4IcZrYZJ3eCY2HkTpXBi3JX3nIgUO45FzvMr0lZjnid4SMngN3koZ6OnLCRHTT21cfJJdcFx+NNxirfr+t6mHJtV4aLb5RR8tGXt7hFQIt1DPFNbT1ayYLnaCz1HjXDnJ/tzHZrm1fGljjzFp6yGyfwPx9Jm3SVpRiAzq6D9i7ZgSN0sRO42yXS5wKxUF/0ju1LO3eKQxSBJ8IdzD1R89yagCdshedg9B/ogBRHTOKP1QcMC8JDHmNG37hgsJnVY6Wl3Xru86/whDkeW4A8xQlpfHFd+MSxcY69j+YQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3JsQVRsYktCR2kxR0FldHVjYVJqWjJNakNBcjZneVZjNVl6NG1yRXNOb2dm?=
 =?utf-8?B?YURvTTAvTzQzSVNmNWg3a2NmZmZVMHVDSngvamc5U0hicFAxQ0MwQ0dzd2l3?=
 =?utf-8?B?bWJJWUgvckEyRW1sWVF0ak9FKzhBZnJJa3pWU0dUcmtQNUp5R3ZqVUN1cmc0?=
 =?utf-8?B?aFk4bzIyWm4wQlpRVVZFekx0UTZoUlIrRjB4KzRSNkZqZDhRcGdLeVJXWVJr?=
 =?utf-8?B?QnZXNFNKdGFEdXUxbGxMejE1ZE00UDFOdUhKOEJpeDZZeTNvd3pkMFpJMDFZ?=
 =?utf-8?B?Mm0yS0dhZkZnTUs1VFg5TElWdXJkbTZIVjN6aGkrdmJYaElHMHVsK0haU0Zs?=
 =?utf-8?B?U3BJYTFrdEN4eE9SMmY5SjFMNUtML3l6QTNoRnU3KzVIMExFaUpQVUVBMElY?=
 =?utf-8?B?bUFBMEF6K0VuQTFuR2FNZ1QrVndHWER6U0M4U0poaTFNYzl2eTMyZXBsWnJR?=
 =?utf-8?B?S0xyQTFROTY4c3F5V1NzQnlRS1RKUlZKZW84aUZBU0lYYkkybDhjRER3TWNJ?=
 =?utf-8?B?NEZIMksyWHZsZXRlNUF1dkRLM0VQYnhTSCtxOWlmZzAxcXhURyt4U01IT2Ns?=
 =?utf-8?B?Qm5LdHVDWG1xbG0yeVdJUmp0dmRzUjJtek1sT1R2a0ttWnp4WWJveXA5cG5Z?=
 =?utf-8?B?UUVSMjhrc2I3VHMzZUszNGRVbjczbk1CWlN0dVRqY0dURHVkTTA0Y2t2OEJh?=
 =?utf-8?B?TzRsRDUrcFlsaVhDTndIQWVSNE43Nk52Tmp0WHdvRllqYy9XTER5RDFzMjE3?=
 =?utf-8?B?Q0Uwak1xSVBSbVkvMzFxZ0ZHSWZScFV2Qm9zbC9BTTZYZkk0UUJCMks4c1g5?=
 =?utf-8?B?RVhiSWNyTkJCZElpdFphSmxsbVNGY2s1ZXdlNWZwRGt1OXNJK2RZaFUyYnBE?=
 =?utf-8?B?YVhTM3ZRZ3ZQSkVEK3IvMXVpUDlNbkdDdVN0YVkyV013K1ZkUm1wK0NwTnlq?=
 =?utf-8?B?RGlENFo3NlQzOXMwRWdodlpyUnZzSlJHQzdIUTM1V05VV3RsQ09WMU52WnZH?=
 =?utf-8?B?a0tTYTlKelVHVHdHbzU0YTBPb1ZhZ0crTXpvcytranNCWHJqZ09TdmMwelVW?=
 =?utf-8?B?czMyUUg1WTk3OE96eUNBd0pZZkRSRGVtZFVNK0FiTzRzNHgzT2JZUWZHT01u?=
 =?utf-8?B?RWpIVlpsS3RlSEtBVm1jay9VTExLMEVRNTlpVkVELzNqa0liRVBpOTRJQnZJ?=
 =?utf-8?B?ak1QUmxuRlJQbzlhektUTUFBaDQ2N3hoVk5BTGZSZXpqTEJtQ3kzTWoyOUxH?=
 =?utf-8?B?VEI0NVFVQ3YvKzVlM1lQSTIxcW1ZNFB4NEQ0dEtMSWQ5UjdNYXJEMVg0VFVj?=
 =?utf-8?B?OUJSN0lEb05nWUJRb3FUTDArMnF4YkdhZ0VVRDRLT2FHQ3dNYm1xQ1FMSzha?=
 =?utf-8?B?RUVGcmRNdFdnR3dmNkJsZHV1UHBOYXM0U0p6ZU1LUHJTTEdpUjVrTkxiU2Zt?=
 =?utf-8?B?V0ZRQUxZejlYVml4Zy8wcXk0d0cwdkVPckhaVldLL2RaYy9PUHFIWUxoRllF?=
 =?utf-8?B?WGxmMXRiVFQ5S05GNHBCL1lQUWRFQS9wckYwUVRxWUkvUVZVeE9aaTRsSVZV?=
 =?utf-8?B?UzZQZGZVR1BJc25EeVkwMHArUmE2OWs4MmZINWVuTGZQT3VXbnJBMm9mSkZH?=
 =?utf-8?B?TlpxYzhQQmg3amZnZHdjTTJMSWdNaE5jM29jdTQ3bUFPVnl4MUZkOGh4L0Fa?=
 =?utf-8?B?aXg4bXYzbXVKMkJsTnFOVUhOcGM3VnAvbVlITlExUmVGeDVvc0VtU09VVDRK?=
 =?utf-8?B?UUp2SjNqZUpna3VmOU04NlZFdDdXSnZ0V2VYR09uM2dnVHArWGk5T2kxczVD?=
 =?utf-8?B?OEszM3hNaFBmQkZVZW5PNTFnSXl3OCtCUi9mVldFaC9WbVpsMVFFaHgzN3Vx?=
 =?utf-8?B?OFRlVXRia1c2LzFIakZLT2ZDM1Q4QTFPQmNnRk44QWw2MFpaZXdONEsraUdn?=
 =?utf-8?B?OS9mU3l3anlzdjQvdVpmUFhSeE5ndzM2dHJsdlhXRi9SaURLeGhRTTNoOUx4?=
 =?utf-8?B?QmtVL0FlYUFsL3FCSVo3czJRcXYzODRRQ25ZZVV4b0pHaWlRZ3gxTW1tdDND?=
 =?utf-8?B?dXIwM1V3ak41cG1ZbE5vTUxISXRjQ3lBazZqd0ZWQXc4WUpza2RoaG5kcnls?=
 =?utf-8?B?NTg0eURlZWIyVzRNMlVvdGlXTzY2YUJkQytWeW96Y2FsL3ZrY0pKMGRvZ29V?=
 =?utf-8?B?Y0ordDAyT1lSZ2wvcG5lVitpakF0YWIwcC9LRkU4SSszSWp3ZjhyaEJ6Qllz?=
 =?utf-8?B?UHluZkRGcmR0Y2tuVm1rVDlyRTE4T1d4ZUM3dkw3czBZdkx1V0RXV1gxdnRO?=
 =?utf-8?B?d0lTU1ViSWZWQWY5NWRHM3lXRmxRMDRkY1VnNlh3UTF3MXRwWjdFQT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c85cd1-09fd-477e-531a-08de7d74b550
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2026 00:42:14.8829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iuGsiDYmeMYOC+J+OQAhsJUCQGp6VDE2/DsxpNRHe4rZ+x7t2CV2A9oUO+5HolvyWg/yfKOdkMx7MW9yAa1KQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF6915D992B
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: pubby6qkeye3jfq8714m9ngu787e7rgr
X-Rspamd-Queue-Id: 4F12040005
X-Rspamd-Server: rspam03
X-HE-Tag: 1773016942-110399
X-HE-Meta: U2FsdGVkX19m7c3gxD3tw+oFgTWBt1TNrunFqie51nrEwlS93mVSdApdQpYquszD9Zc5/PFv9G9/4hpIndFlTa9puaueYBdnCzBwO5s3K/GKXgbZVTCpAF55hFwKFk0XHiEncmX3zhQ1I6aDUWLl9TD6tGdlGnxmAqWJ9CBPVNIQLxweizd6hIuTfawIKnsjDxfAbN1rVhcQ8asKEUip7bwjAucp3F1m8ZO2p7Nfm0Cu/hxUxVTZIs73ziHJnutLywLSCySIa4PAu4mN7n7SJu8Ay/zEcEntyrikQSwmJZdEcABcWKLeIPcVNyizTZA1MLN150uQI84mOkLf5je94zZlHQuzwVgykguGdUdXgewwfieSfVIwYo7ktmvdgSfdS+l9DwuzM9Nb9b07j6eNutNdieDavPjCs/EFhpuaYX4GjXpCvqzaAyFQYkw3p68yImq01sMN3qvRBruealwBoFIcJhY3hvOPyJCKcR9sORuUoihkxlbtFZo1VkR/7ai1KzV3akq/d4WgPZst2jr2OKE7mKnoTdyMMM1D1JyZnJWULQc4rrWJl6C6Kz1Q/7aFLrZUxd6hCcvtw84MU+ZsH7/XP/P6HjZG78UId/e+FiSRTeI9/TVKshV4/tNqVyj1onHqSPsAs+548BHblm11mNpTECFF9vCR/dB5hNqXVn3FHpmjr+1P3U8b2MX4ufFO96WZvxFyv70rG7hMW9+c1s4EXkh/P0od1IGHJt2iYUsW7WNayULPhuM72AesqYhzGe/1ERWSLj2HWZkElV7ozsWlqYLnmOWBSi4134g3Nn9U2FlbE2TQV27JuFazLNiPK28Mq3vOfyfHqMuZIEo+Ukh7YFhV1UcdAc6Ul4c6SJwQVxYljfBbL1MxugXRbTk+M9F90rymXnYzn6thE28PjU44/dFg4uS8Y4Vu/gAEr43YMjXdIh3PYbF2nJ0ErbK/N9VCx/rsvPgP0FCv5mx
 N+2E0blT
 CsPxZvCP0kbzdw+j/IqPkdUZBXa37FysP5qKx1V9V8/Ka7/r2AA6dLah6CpygvlG+bT7hfNY62s+X+YGxFVG/iAvKErVt0+dFQbG96U8MtP24LTB830EEcYABOLk5oixXbkJ2rYgCrBW0dLCwc8oPqg/rLXF+NTOiHjO3Fb8NaqCaUYEZoPxhnG4BI6fRoUwAuxMOnBvws5c96wcFQFYns2DZ7FAWVrC7J01NWIXo0XdcWF0SO9kfd5GrIbqNHjCCps+gBnBjhrV5uSsylm9krv0bfqvi5o244tRSCRsxGCH6ywsKdhCvsBylDAGPrhoS3zaVUlhYkIe6Ns7Qa6w7kuyymd8IZvOcLH5pPNBxfUSMyZNRbzsVWEiKAwNT6A1GdozTDN6X9DD5BlL1XhHCn4hnf5eEiqcJpMy/yLEAYSYY0wj4wt3hd34r0b5bBd1Qtakwpl80L4mTOKiGcw85cGI2KIZ7XzRD77zMDkOIbFGPEN7T1UXqZ120s6ReO5+DieKTJFzMwUTbpHQVlPjlQWJxHLmdJ8vau1/IMEsqfbqv99tV6lc7aP8TKXOMyN9EoqzRhSG5COo1yFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David, Mike & Other maintainers,

Just a quick update: Yuan and I created a new patch based on David and 
Mike's code, updated the documentation as well, performed the 
performance test, double check all the references etc. We observed a 
slightly performance regression, not sure it was caused by the 
environment configuration or we triggered some unexpected behavior. We 
might need a bit more time to investigate. Will send out the patch soon 
once we have confirmed data for the performance regression. Thanks.


Regards,

Tianyou


On 2/24/2026 3:15 PM, Li, Tianyou wrote:
>
> On 2/11/2026 8:19 PM, David Hildenbrand (Arm) wrote:
>>>>        *
>>>> +     * online_pages is pages within the zone that have an online 
>>>> memmap.
>>>> +     * online_pages include present pages and memory holes that 
>>>> have a
>>>> +     * memmap. When spanned_pages == online_pages, pfn_to_page() 
>>>> can be
>>>> +     * performed without further checks on any pfn within the zone 
>>>> span.
>>>
>>> Maybe pages_with_memmap? It would stand off from managed, spanned and
>>> present, but it's clearer than online IMHO.
>>
>> offline pages also have a memmap, but that should not be touched as 
>> it might contain garbage. So it's a bit more tricky :)
>>
>>>
>>>> +     *
>>>>        * So present_pages may be used by memory hotplug or memory 
>>>> power
>>>>        * management logic to figure out unmanaged pages by checking
>>>>        * (present_pages - managed_pages). And managed_pages should 
>>>> be used
>>>> @@ -967,6 +972,7 @@ struct zone {
>>>>       atomic_long_t        managed_pages;
>>>>       unsigned long        spanned_pages;
>>>>       unsigned long        present_pages;
>>>> +    unsigned long        online_pages;
>>>>   #if defined(CONFIG_MEMORY_HOTPLUG)
>>>>       unsigned long        present_early_pages;
>>>>   #endif
>>>> @@ -1051,8 +1057,6 @@ struct zone {
>>>>       bool            compact_blockskip_flush;
>>>>   #endif
>>>> -    bool            contiguous;
>>>> -
>>>>       CACHELINE_PADDING(_pad3_);
>>>>       /* Zone statistics */
>>>>       atomic_long_t        vm_stat[NR_VM_ZONE_STAT_ITEMS];
>>>> @@ -1124,6 +1128,23 @@ static inline bool zone_spans_pfn(const 
>>>> struct zone *zone, unsigned long pfn)
>>>>       return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
>>>>   }
>>>> +/**
>>>> + * zone_is_contiguous - test whether a zone is contiguous
>>>> + * @zone: the zone to test.
>>>> + *
>>>> + * In a contiguous zone, it is valid to call pfn_to_page() on any 
>>>> pfn in the
>>>> + * spanned zone without requiting pfn_valid() or 
>>>> pfn_to_online_page() checks.
>>>> + *
>>>> + * Returns: true if contiguous, otherwise false.
>>>> + */
>>>> +static inline bool zone_is_contiguous(const struct zone *zone)
>>>> +{
>>>> +    return READ_ONCE(zone->spanned_pages) == 
>>>> READ_ONCE(zone->online_pages);
>>>> +}
>>>> +
>>>>   static inline bool zone_is_initialized(const struct zone *zone)
>>>>   {
>>>>       return zone->initialized;
>>>> diff --git a/mm/internal.h b/mm/internal.h
>>>> index f35dbcf99a86..6062f9b8ee62 100644
>>>> --- a/mm/internal.h
>>>> +++ b/mm/internal.h
>>>> @@ -716,21 +716,15 @@ extern struct page 
>>>> *__pageblock_pfn_to_page(unsigned long start_pfn,
>>>>   static inline struct page *pageblock_pfn_to_page(unsigned long 
>>>> start_pfn,
>>>>                   unsigned long end_pfn, struct zone *zone)
>>>>   {
>>>> -    if (zone->contiguous)
>>>> +    if (zone_is_contiguous(zone))
>>>>           return pfn_to_page(start_pfn);
>>>>       return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
>>>>   }
>>>> -void set_zone_contiguous(struct zone *zone);
>>>>   bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>>>>                  unsigned long nr_pages);
>>>> -static inline void clear_zone_contiguous(struct zone *zone)
>>>> -{
>>>> -    zone->contiguous = false;
>>>> -}
>>>> -
>>>>   extern int __isolate_free_page(struct page *page, unsigned int 
>>>> order);
>>>>   extern void __putback_isolated_page(struct page *page, unsigned 
>>>> int order,
>>>>                       int mt);
>>>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>>>> index a63ec679d861..76496c1039a9 100644
>>>> --- a/mm/memory_hotplug.c
>>>> +++ b/mm/memory_hotplug.c
>>>> @@ -492,11 +492,11 @@ static void shrink_zone_span(struct zone 
>>>> *zone, unsigned long start_pfn,
>>>>           pfn = find_smallest_section_pfn(nid, zone, end_pfn,
>>>>                           zone_end_pfn(zone));
>>>>           if (pfn) {
>>>> -            zone->spanned_pages = zone_end_pfn(zone) - pfn;
>>>> +            WRITE_ONCE(zone->spanned_pages, zone_end_pfn(zone) - 
>>>> pfn);
>>>>               zone->zone_start_pfn = pfn;
>>>>           } else {
>>>>               zone->zone_start_pfn = 0;
>>>> -            zone->spanned_pages = 0;
>>>> +            WRITE_ONCE(zone->spanned_pages, 0);
>>>>           }
>>>>       } else if (zone_end_pfn(zone) == end_pfn) {
>>>>           /*
>>>> @@ -508,10 +508,10 @@ static void shrink_zone_span(struct zone 
>>>> *zone, unsigned long start_pfn,
>>>>           pfn = find_biggest_section_pfn(nid, zone, 
>>>> zone->zone_start_pfn,
>>>>                              start_pfn);
>>>>           if (pfn)
>>>> -            zone->spanned_pages = pfn - zone->zone_start_pfn + 1;
>>>> +            WRITE_ONCE(zone->spanned_pages, pfn - 
>>>> zone->zone_start_pfn + 1);
>>>>           else {
>>>>               zone->zone_start_pfn = 0;
>>>> -            zone->spanned_pages = 0;
>>>> +            WRITE_ONCE(zone->spanned_pages, 0);
>>>>           }
>>>>       }
>>>>   }
>>>> @@ -565,18 +565,13 @@ void remove_pfn_range_from_zone(struct zone 
>>>> *zone,
>>>>       /*
>>>>        * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
>>>> -     * we will not try to shrink the zones - which is okay as
>>>> -     * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
>>>> +     * we will not try to shrink the zones.
>>>>        */
>>>>       if (zone_is_zone_device(zone))
>>>>           return;
>>>> -    clear_zone_contiguous(zone);
>>>> -
>>>>       shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
>>>>       update_pgdat_span(pgdat);
>>>> -
>>>> -    set_zone_contiguous(zone);
>>>>   }
>>>>   /**
>>>> @@ -753,8 +748,6 @@ void move_pfn_range_to_zone(struct zone *zone, 
>>>> unsigned long start_pfn,
>>>>       struct pglist_data *pgdat = zone->zone_pgdat;
>>>>       int nid = pgdat->node_id;
>>>> -    clear_zone_contiguous(zone);
>>>> -
>>>>       if (zone_is_empty(zone))
>>>>           init_currently_empty_zone(zone, start_pfn, nr_pages);
>>>>       resize_zone_range(zone, start_pfn, nr_pages);
>>>> @@ -782,8 +775,6 @@ void move_pfn_range_to_zone(struct zone *zone, 
>>>> unsigned long start_pfn,
>>>>       memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
>>>>                MEMINIT_HOTPLUG, altmap, migratetype,
>>>>                isolate_pageblock);
>>>> -
>>>> -    set_zone_contiguous(zone);
>>>>   }
>>>>   struct auto_movable_stats {
>>>> @@ -1079,6 +1070,7 @@ void adjust_present_page_count(struct page 
>>>> *page, struct memory_group *group,
>>>>       if (early_section(__pfn_to_section(page_to_pfn(page))))
>>>>           zone->present_early_pages += nr_pages;
>>>>       zone->present_pages += nr_pages;
>>>> +    WRITE_ONCE(zone->online_pages, zone->online_pages + nr_pages);
>>>>       zone->zone_pgdat->node_present_pages += nr_pages;
>>>>       if (group && movable)
>>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>>> index 2a809cd8e7fa..e33caa6fb6fc 100644
>>>> --- a/mm/mm_init.c
>>>> +++ b/mm/mm_init.c
>>>> @@ -2263,9 +2263,10 @@ void __init init_cma_pageblock(struct page 
>>>> *page)
>>>>   }
>>>>   #endif
>>>> -void set_zone_contiguous(struct zone *zone)
>>>> +static void calc_online_pages(struct zone *zone)
>>>>   {
>>>>       unsigned long block_start_pfn = zone->zone_start_pfn;
>>>> +    unsigned long online_pages = 0;
>>>>       unsigned long block_end_pfn;
>>>>       block_end_pfn = pageblock_end_pfn(block_start_pfn);
>>>> @@ -2277,12 +2278,11 @@ void set_zone_contiguous(struct zone *zone)
>>>>           if (!__pageblock_pfn_to_page(block_start_pfn,
>>>>                            block_end_pfn, zone))
>>>> -            return;
>>>> +            continue;
>>>>           cond_resched();
>>>> +        online_pages += block_end_pfn - block_start_pfn;
>>>
>>> I think we can completely get rid of this with something like this 
>>> untested
>>> patch to calculate zone->online_pages for coldplug:
>>>
>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>> index e33caa6fb6fc..ff2f75e7b49f 100644
>>> --- a/mm/mm_init.c
>>> +++ b/mm/mm_init.c
>>> @@ -845,9 +845,9 @@ overlap_memmap_init(unsigned long zone, unsigned 
>>> long *pfn)
>>>    *   zone/node above the hole except for the trailing pages in the 
>>> last
>>>    *   section that will be appended to the zone/node below.
>>>    */
>>> -static void __init init_unavailable_range(unsigned long spfn,
>>> -                      unsigned long epfn,
>>> -                      int zone, int node)
>>> +static u64 __init init_unavailable_range(unsigned long spfn,
>>> +                     unsigned long epfn,
>>> +                     int zone, int node)
>>>   {
>>>       unsigned long pfn;
>>>       u64 pgcnt = 0;
>>> @@ -861,6 +861,8 @@ static void __init 
>>> init_unavailable_range(unsigned long spfn,
>>>       if (pgcnt)
>>>           pr_info("On node %d, zone %s: %lld pages in unavailable 
>>> ranges\n",
>>>               node, zone_names[zone], pgcnt);
>>> +
>>> +    return pgcnt;
>>>   }
>>>     /*
>>> @@ -959,9 +961,10 @@ static void __init 
>>> memmap_init_zone_range(struct zone *zone,
>>>       memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
>>>                 zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
>>>                 false);
>>> +    zone->online_pages += (end_pfn - start_pfn);
>>>         if (*hole_pfn < start_pfn)
>>> -        init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
>>> +        zone->online_pages += init_unavailable_range(*hole_pfn, 
>>> start_pfn, zone_id, nid);
>>>         *hole_pfn = end_pfn;
>>>   }
>>>
>>
>> Looking at set_zone_contiguous(), __pageblock_pfn_to_page() takes 
>> care of a weird case where the end of a zone falls into the middle of 
>> a pageblock.
>>
>> I am not even sure if that is possible, but we could handle that 
>> easily in pageblock_pfn_to_page() by checking the requested range 
>> against the zone spanned range.
>>
>> Then the semantics "zone->online_pages" would be less weird and more 
>> closely resemble "pages with online memmap".
>>
>> init_unavailable_range() might indeed do the trick!
>>
>> @Tianyou, can you explore that direction? I know, your PTO is coming up.
>>
>
> Hi David,
>
> Sorry for the late response, just come back from CNY holiday. I am 
> willing to explore the new direction. Will sync with Yuan in a day or 
> two to confirm the overall implementation and testing plan. Thanks in 
> advance for your time to review the new patch set once ready.
>
> Regards,
>
> Tianyou
>
>
>
>

