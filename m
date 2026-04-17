Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAC79F8E4A7
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 06:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18D6E6B009B; Fri, 17 Apr 2026 02:35:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13E606B009D; Fri, 17 Apr 2026 02:35:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA1E6B009E; Fri, 17 Apr 2026 02:35:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6BDD6B009B
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:35:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9F30D160B37
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:35:08 +0000 (UTC)
X-FDA: 84667085496.13.23CC453
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6C1FE1C0007
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:35:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U7bPHReg;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf20.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776407705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jUdLlzRyWGLY9SmmFGMnYoOcga5FYKruk25ThL1CatU=;
	b=dpynREeTReHF0BsV0SLo3WPNLVs8MkR2KgWPMeCpJF4M4KakYUsw678uYj0Wze6rM4iKPU
	qLIVzwzfc8fa0VPKB/4GzEe+wW6stsUH9zf4LU+R5a0V3ggvQLEluUh3VFWy/6fxyV029e
	lATRSLogspW2rNMK/gpBj6xpnrtUBe0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776407705; a=rsa-sha256;
	cv=fail;
	b=imkmnGW/U5/CxHSVjmiyuxYhlIKhaXeNlfPXYxTJwqjfVpnenNir+rDWS3qlKLlO8v4KLj
	VSrwXEIkSg9Wh9yst8qLLjVHW+vtU13BxozAf4lsEXmscmC0/U8tv4PMppw8ocTQMxklV5
	DzyrhQMngZETYeoVHETqMZwaEEMdB4k=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U7bPHReg;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf20.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776407703; x=1807943703;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jUdLlzRyWGLY9SmmFGMnYoOcga5FYKruk25ThL1CatU=;
  b=U7bPHRegbN2zY00UqaZ/Cr+bihdX/400jH5jyZaFOGiDxJNoH52208qw
   7d4Q3xKfdKTxYjBqMJHaEZP9l8SWr10j6EBRRNG1OFLbb4gmKgNlKOE4v
   CCYFdWJtrsJyPxWXYAii1bLzerPbdAhFp/FfHaPSFmV6DwDmiT+anBQlK
   CIKzOVZhoKrN+jXCt+PMFC9qYmOcy19YakaKk7QbeMOnSlS/rhZV/DtVz
   SobmR7PlaPkaUBv8XUC/zPgcrliKJWqMvI+nJe6sSm9+Ols0T3VRye1Wm
   tcLLKWcwbok52kKodbv+FpNm10odKI3ZEIIX+cdWs/KSQ9eUygGsc10YB
   Q==;
X-CSE-ConnectionGUID: EbfbgE2FTba3MrH48oSKEA==
X-CSE-MsgGUID: NHNRR6iQRteoS96wSbYsFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11761"; a="77539048"
X-IronPort-AV: E=Sophos;i="6.23,183,1770624000"; 
   d="scan'208";a="77539048"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2026 23:35:02 -0700
X-CSE-ConnectionGUID: lMmxqIsBQFiD1DEnuX+cJw==
X-CSE-MsgGUID: O3lxZZTHROKu8dgDkbWEZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,183,1770624000"; 
   d="scan'208";a="254175636"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2026 23:35:02 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 16 Apr 2026 23:35:01 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 16 Apr 2026 23:35:01 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.63) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 16 Apr 2026 23:34:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EI3tuvBzXK/N8aU5/gJdWy1SbfdeXmC+9yN8Iriodbse2XMJjBd29dTBbxipjEfEVlTPDMD+o6cA6xcKsNY2UOhh25zxae9AYVzks0iLPr2qYgl+SZ4tBUrKsY1v/sejD/MEo0PdLOZi6+e/fSZ/UMA4CUogso/uD1GM90VljlRJjL10KPyh5YAQppC74+lLM3WhfCsU83ZXTTR/b0k++bxLmSxFn8iyF2J/S1OFCQckilcpp/zCKXpS6umnryDTbsoR6E5TSm5ySoh7bTAqWBWQ/6o1t1zH0QNKyu4rx9VTgJkkgtXp+Fc9+KPqLNQN3qZxl8iy5S4tn6vHVJLyFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jUdLlzRyWGLY9SmmFGMnYoOcga5FYKruk25ThL1CatU=;
 b=mhNtZT5k3v/HH6CdeflCoSU5LMN51XxwI+UhViTwRDJlK1hRSOVXVOZ6duGA7Qx9bUFY7ym7WrZNwRonEOhgwsgrvfvbRrCGOwONyLJdmJPV9TbA2FVdOlzTk9ZHO3/kCBRwlhzqJr6mk5qKl0NsrwMHKQmp7qH5Yz71XVOdUVc4qJQUvmTuPf/6Bmngg757egDAfLgrV+xk2tZbI2C+wwKb/Y8Ymok2ph3bHL2utI+0LeYNR8MguH8WuI7UiQmLmsxQaDzjBsFU4tzjVx6PAevojvAO2eb5pKdPWK8z618AH7xw/jfuUbh06BiKbK/8stEsRrNZsVxf/p7zlU4gqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by PH8PR11MB6950.namprd11.prod.outlook.com (2603:10b6:510:226::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Fri, 17 Apr
 2026 06:34:50 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.20.9818.017; Fri, 17 Apr 2026
 06:34:50 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Mike Rapoport
	<rppt@kernel.org>
CC: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>, "Chen
 Zhang" <zhangchen.kidd@jd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Thread-Topic: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Thread-Index: AQHcxwYPPar5wabLkEWQfiO/Xde9s7XUxrUAgAIIwYCAAAfiAIAHUdTQgAAptoCABIITAA==
Date: Fri, 17 Apr 2026 06:34:50 +0000
Message-ID: <MW4PR11MB6936E593C865F4E855CED602A3202@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <17b821b6-0176-43d5-92f7-fe2a0c4f70cf@kernel.org>
 <ade6RVeXxDt7ImP4@kernel.org>
 <e86fee84-08d8-4563-8596-e40d8e196799@kernel.org>
 <MW4PR11MB6936CA77BF02BF498BBEAB1CA3252@MW4PR11MB6936.namprd11.prod.outlook.com>
 <12b8ba83-54b1-454e-b787-2d2e967c9b58@kernel.org>
In-Reply-To: <12b8ba83-54b1-454e-b787-2d2e967c9b58@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|PH8PR11MB6950:EE_
x-ms-office365-filtering-correlation-id: 6aa3125a-68cd-43a7-5a3e-08de9c4b6d79
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003|22082099003|38070700021;
x-microsoft-antispam-message-info: OpKeAf2Uo262ReeF+yH3XNGj4ZrEQiqYjKoAOkllu4CNVlGeYoJLW0ZUtF//93g8yvzsl4oNHeUlAVuj3xltny6/oO3F6u3aFFX0hPHOW5C8euR5rWC7VzYYjWsTluYulzkegqDL04A4XP5c0mRXwi0hE/avtLVEpEbCN5lJrECfe1pkWgl4T3prk2YlcD8e9IO63wWRCdk6jPKblFioo4EMhiaE1TirzlS6YBU2SxzQM80MUs02obDDgg8LGPpeqeg63DIx0jb/7/7I+PkbUU3d4hL5/mNzLNh+6K2nVAu9A/P0d1oSjcGlGGcrhyuRpOe0mw0PAUtlrjS83hhudufENbB+xldIf+qwdpZe7P3np06YoX8dtJMuTr40qTlufT6sDhjfJZrgBjsMeNmE1gjcdVz8N0nfh93YRhqzaGDSgpMX2p9dwnNVK4MC0llGON16GKQ4+BSZSeZnwg2e1hKXTf2qLkCpKRhVBupNnwKri8XPk9G/rITn/Mg3p4NFC9kjMS4HtZEK3b2+cC8T66QrXnkp/4QPb3WNjKIjIcA5R6wNg/YlVhtJEFhVsHblNTKlTaZJZkZ82GrhKqI7kgn0dZ61qL7++0mBOW/Z3o++5gMs97Lhqge1CRk8aBcnxAlJBFXRPn+Bpfno2NgShHHtY2ExPVBAcVS8VEqXN95Du7i8OerNi/SWSKsNWJhgkPWbcAxsN+3IQXN3j3FW1PA2S9s/11R6LQ3xR7WSTCA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TktCd1RiSDZLZFFadXpaUUg0V2tIeUhrR1F2aTNYc01tMkozRE1YeVR1NXJ3?=
 =?utf-8?B?WkkrZjZQUWtDNkxKN1UrQkRWbDVEWWZOQ2RURit6cjZPWWdDZzdmM3VhM0Nu?=
 =?utf-8?B?eHIvaTdRNzJRL0lkVlE5a0xtTEI2ZGxBRXNNeEJ0S2NTNmlkS3p4aDBrYnp4?=
 =?utf-8?B?OURjVmE4OUd1SjNERjQzbFh6Y25UQkpKVDhOK0xhMzhQTHhPRlJUNitjOGFJ?=
 =?utf-8?B?TVhxa0xSdzYrSldGdWlhOXdNbHVJWXpGQ1dieDRraVdjWEVLRksyQVZSZ2h2?=
 =?utf-8?B?N1lGcXdsMzdQNVd6NTBic25ZeS8xZVBXUmpUT1pyTUtyUGc0OTRoOWRMd0lO?=
 =?utf-8?B?WXlZNTRiYjY5QW51ME82NVRVNi9kc1dRb3hjSjdZN0NjWU5aNG9VSmdUNUlp?=
 =?utf-8?B?QUpaOGtzZE83eURqcWRDRm9lYi9vZUxSOW9RVmYzYkIyaVlkVWVQRjJ2TGFw?=
 =?utf-8?B?Zmt0bkhwMDJqbmczQUo2QXQwQ08ya0dqeTZlbStQQWt0YXpvYStqNWpyVk5X?=
 =?utf-8?B?SmZNTzJScm92cExMQlM2cFFySmFBSWFoTU94UUFMOEhqeVpzcnd1TEw5R0s4?=
 =?utf-8?B?Vzl2UmswV0lUcTZ5WDNWM0puVUJpNTljUkxsN0h6ZWhlcnlTalhDMzZUSC9o?=
 =?utf-8?B?V2pkK1Z0RmxhVmtkQW9DbXZzQlp4Rm5MZXlIa2RRMW95bGtEUmI3K1FJTFIr?=
 =?utf-8?B?UUd3d0FKZFFQMDhWZ3kyS2FBRUhhL0R2WDlrdE5hRGNWaFUzMzAvcGJKZlJC?=
 =?utf-8?B?eTUxOFd4SXI4SlhrVDMwRFU0disrOWdTN3BFZW14cXBNc3lORTFyeEpYQm1w?=
 =?utf-8?B?UW5ncStQUUhhdkM5WUlRWDU1ZTNZaW15ZElBemxoYzIzQ2NhQXhtb2FOT3By?=
 =?utf-8?B?MndySGFaRFA0QmVUYndSbkttTUV3WUtkbVdZckpTYkE3YVA0ZHRzSUZqR1RI?=
 =?utf-8?B?TEYvNVdLems4Y0U3ZzUwRzl5TndGWnUzb2hTTkxpeWNTdi83N28rSEk5YlpJ?=
 =?utf-8?B?d1AyN3RtTmNDK3lDYkxWeklqM2h0ZXZjNVFPb2dUNlFwZ0FLZkg3UFVxWkxk?=
 =?utf-8?B?Mkl4dEo2emh3VWE3ODdGOCtsOWQyRlZib01EOG84ZE1PMGZWWks2eFhqam9D?=
 =?utf-8?B?aGd6OEZyVXk4RTdRdnhjaVNTejlVaS9YZnNtQ1BrN3RhZExIZ0R3ditHU0pn?=
 =?utf-8?B?dUxqMkZId3pyVzZvaFM2NkRLc1lkWmgxQlJUVi9pUzFXaHdDbjlCTzhIazFV?=
 =?utf-8?B?eVB1Zy9RSVdPUTRzL1l2RW5KSHEzajJBMGp2Nk5mM21Jcml2UEJBa1B4MWY4?=
 =?utf-8?B?TGVrR2lrL0pkR2FqZUloRWk5bXY1Wk9uQUVkbmFMc1lPUjBnSTJMQVZtdVJz?=
 =?utf-8?B?ZHppSG5WRUhNR3d4NkhDZjMvZFIvMVJZdjBKRlBOT3FIM3B4dUVJZDVBREJq?=
 =?utf-8?B?cEEweGs1cHpadDJSYkpRRXEvaExMdW1FQU5KVEp0alAzeUJDU0JTTXVNODBz?=
 =?utf-8?B?Z1ZqbTVMaXc1TDNYY1ErQzhmS0t4SC9FMkU1MURkVHVSODVFNWZpUk5RVlp5?=
 =?utf-8?B?d3Z5RmMxYUVmY3djejVHZTR3bFNpVDZTaUQwdjBjU3M3UTdMeXFnc0dxcUFo?=
 =?utf-8?B?UXQybExrTy94Sk9XNjV3WVQ2NFByaGl1VDl2V09vS1ZUTWV2aG1wbEdSTEpz?=
 =?utf-8?B?ODlFZHBRZk8vTFJUVm5VYzZONnd3SDVkMzI2K3kwbEh0d3JId3dXMFhmRnho?=
 =?utf-8?B?VVB6L3NGUm1NenZrWnd5TzZQMUVTTWxPTFFBb3FLNUZtcW8xT3NBSkVOYnVt?=
 =?utf-8?B?RUtWVklOeHFxblYzR21LaUFwS0M0aWR4alVGMXZCY3RBZ2FRekxlMDdMeDMx?=
 =?utf-8?B?NmkzYnY3RzM0OEM0MGtGRS9yelJlcTFMVHgvNzRheDc2S1kyTGhRVWZqNzJs?=
 =?utf-8?B?NEZZU3IzbE9BWHpBaW83dGY0OGwzUDNPc091Y2kxdEEzMFFZM00zMitOMVJu?=
 =?utf-8?B?VTVla3dwZkxZaXVFNUR0emlHZ3pscXJndnJ5c0NGd2FHQWFkOWR5MlJuQUR2?=
 =?utf-8?B?ZWdxcWpPQ1o2cjQzOGcrcXBERnpuK3FRY0ViRHZGcjY3MUhrL0NCdUhaNGRl?=
 =?utf-8?B?V0RQSy9FdE45T0lFREpCaDYxSmNpMFRCb1VRRGRaQXhoT2FVWEJwYW9GWWF6?=
 =?utf-8?B?Y1V2cFpoVENEenZFSUUyNEg1WjNZR1VCMFg1VitHTWZjNE5PZVFZbHdYNjFv?=
 =?utf-8?B?OEdrZGNySFc3N1lDazRnSkNIdklRUThHd2lIV21zRlk3WHdIRTYwd3pXLytn?=
 =?utf-8?Q?klkSoojaXlr5bPD4S/?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: WL9ikUQO0Plkmguhr+RAhcMPTimvb1wkOxW2Hx1f5WnlbN66VwI8hkav6gcC7zfC1ZYDMoFBiVbf1Ig5vECyNGdcwzn4vQ+ErwPF/xnU1s2FoM5sEhZEpqjCOsY988HhHtN3QvUHCm77pD+1xIjkMgmfVb0TBwdIRc4CJfauj4ghxNwI6MAlfgM0IkHilhw3VifDtgIHRsRoITSHusfWroFxwazjTLiDJfRI5maGAqA1RVZzTCoIsHQ+4orHET4/5nhAe+5Zrogkt0enUsAwS+ny9DpXfkxTDO5QkvrAkFDAFBo0OKxl9QJ3pZsEcmmDLcDnJQpC5yMqA6b5vf/27g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aa3125a-68cd-43a7-5a3e-08de9c4b6d79
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2026 06:34:50.6006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VRcioXI1AqBG6o4sxAof+45y+lWyr4ruS1dUOHCgN+JaaNXI9XimrJw+ZvUr9DZn1b5oSJWeAUnoIFzW3tR1Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6950
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 6C1FE1C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: gxuqmcp5iukrcedpq314mdyi1si6cbjb
X-Rspam-User: 
X-HE-Tag: 1776407703-711825
X-HE-Meta: U2FsdGVkX19HpqpDkKViobw3EdWmCP83KcOicj6Qk/Qi9/L6dnwqPZvdBtCxtXttlOvcUGQs5LXce1jL3BNdZNVlSUnocDEwu1yT/eMeGdjj386q/ALLhfAffmfeK9KipuZLYVd5HXgvleEnqg0e4x1eESVlfa0jLLTYs8EMCV1fnM2IZERljTIS+6MOZJSGp6UKaLRzjS0V0qM0li3fXin0L7to5YlTT1Js85Df7okWST3jE/PefVgyojS9ldWrKTV6pbNRTcUieDEZdYqnsbxIv/MWEN7Z5ogMSQG5O3MoUk/nmKv4fzNR46JIwYB60f0tp0cx4ZCnQvpLG2DspEp0xQ7UkM6MF1CSKQ5283rzF/a7Qg9jP0KWGfVO2AW/zJhPKLX6wf01gDsoFnUQmG+5vCmWwkQJLh1Y0NS07G4NCfFBNCQxyebjywuOr6b8LNzHFvn/LjIqkVAiuOpJ24lSh517zP6xtNpHk8lj1oIPVkgQJDSeUCqu5El0IOfTUHGkqTlVPZSYGfs/LA90ICRresSRSwOmkeKljX8oGoLQ3KqElOnAaX/l7vGeGkY3O+F/tWnljYGkRvQn4I5936uMgW8tXNOS7llCTkUtSAXXSN08HXPoat/cRtlYazmcZoEnktpsNJEqWWOE3X/rrKWbwIT8z3axC50DxR4jSyN6evSS2N3X35ZTtauUNfGbHqpwzT1mIbuc2qjeQ04OegAzTTNDafgl57wDz4aGQ/TIDoy2ZUMsvKjoIrbXIsgDo+bbDJfbZx5xLqOXFxxAf08DdUNTpdFTXFPmHsD/+WJFqbg06XqTI1YYgEwS71R6fCQ7VnCMDy2UYnb1n4163yMCrDsFMZME+6G+NlIBU8O10xM5cqKrv8URwKd5y/YlXZG0Y0Zbjyo6B/2ZJIP/McIB7YBuHd5E/HRfomnl2aC8iejaM0ekrGca/kYBerNfILm3Lv3N1xSSXIIy8lC
 BbBCXFA+
 0tYFTtwgE2fleIN/8p/nQCzUrd5veDPG3uQMyi+w5xFK3FON5K9n71i1xFIFYHHiNZtPbOZXjpCJuwBNQMQ58uwwH2p8OdsDLuyZdLhbioyWhJDO6wb0vYm+bcD3gjRKzjZpMgKXdVJsjAGwlm3w5PcIEzEUtmZji6Y+oauKId0o8LzGhWqzG9i2F3INeSK3dSOPNf2wub7Hcx6Jnns/vicY/efkhwqs8OkSqeoxa9vYfpWUb7AtncSTbn5v9j/YPgwF4jyjYFqhS5l00fQUtBL6Dz6iwHqp6dYJWk3JtV1ZoyJwl9Y3ETfu7qzdumB3CjNi4tsed9maX41NKwQj9dgs5F98Q7pcYIIfy49s8o9fR4MaYZrR7IghNjg02sogPMWpL1kpSEMi0/UvuoFZol9LpdC1S2BK9/mig8ZkHSGc+DINOW1EmjbchrD1NbDx6jDGgeBD4EecLl9MfDqCEgHToZe/VleRKxQwErtRgTonhRLcYtKYYHgzy7Robb1CfINHiEMV1oiDRFul9+lb0wnTZgtKQnLF654ZkpGamBZiWo2jADHZwpB4xizaFPSa2pdzlq1CmRCGwUUkU4NKBvxl+M3DsUXybF7+HOWlC17/f3Z53sE8dBf5iyGslyYGJjbfVqODEgOcYV9V6o4CKwxiRPxX2VD4EhZQN3VvSI0tUzw7Ic2Qo895b7BDJ7jzGjE0BxyNq+kmUJcM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQo+ID4+PiBzYXNoaWtvIGhhZCBzZXZlcmFsIGNvbW1lbnRzDQo+ID4+PiBodHRwczovL3Nhc2hp
a28uZGV2LyMvcGF0Y2hzZXQvMjAyNjA0MDgwMzE2MTUuMTgzMTkyMi0xLQ0KPiA+PiB5dWFuMS5s
aXUlNDBpbnRlbC5jb20NCj4gPj4+DQo+ID4+PiBJIHNraXBwZWQgdGhlIG9uZXMgcmVsYXRlZCB0
byBob3RwbHVnLCBidXQgaW4gdGhlIG1tX2luaXQgcGFydCB0aGUNCj4gPj4gY29tbWVudA0KPiA+
Pj4gYWJvdXQgem9uZXMgdGhhdCBjYW4gaGF2ZSBvdmVybGFwcGluZyBwaHlzaWNhbCBzcGFucyB3
aGVuIG1pcnJvcmVkDQo+ID4+PiBrZXJuZWxjb3JlIGlzIGVuYWJsZWQgc2VlbXMgdmFsaWQuDQo+
ID4NCj4gPiBIaSBEYXZpZCAmIE1pa2UNCj4gPg0KPiA+IEnigJl2ZSBzcGVudCBzb21lIHRpbWUg
d29ya2luZyB0aHJvdWdoIHRoZXNlIGlzc3VlcyB0byBiZXR0ZXIgdW5kZXJzdGFuZA0KPiB0aGVt
Lg0KPiA+IEZvciB0aGUgb3ZlcmxhcHBpbmcgcGh5c2ljYWwgc3BhbnMobWlycm9yZWQga2VybmVs
Y29yZSksIHNob3VsZCBJIGF2b2lkDQo+IGNvdW50aW5nDQo+ID4gb3ZlcmxhcF9tZW1tYXBfaW5p
dCBpbiBtZW1tYXBfaW5pdF9yYW5nZSBpbiB0aGUgbmV4dCB2ZXJzaW9uPw0KPiA+IEZvciBleGFt
cGxlLCBjaGFuZ2UgaXQgYXMgZm9sbG93czoNCj4gPg0KPiA+ICt1bnNpZ25lZCBsb25nIF9fbWVt
aW5pdA0KPiA+ICttZW1tYXBfaW5pdF9yYW5nZSh1bnNpZ25lZCBsb25nIHNpemUsIGludCBuaWQs
IHVuc2lnbmVkIGxvbmcgem9uZSwNCj4gPiArICAgICAgICAgICAgICAgdW5zaWduZWQgbG9uZyBz
dGFydF9wZm4sDQo+ID4gKyAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgem9uZV9lbmRfcGZu
LA0KPiA+ICAgICAgICAgICAgICAgICBlbnVtIG1lbWluaXRfY29udGV4dCBjb250ZXh0LA0KPiA+
ICAgICAgICAgICAgICAgICBzdHJ1Y3Qgdm1lbV9hbHRtYXAgKmFsdG1hcCwgaW50IG1pZ3JhdGV0
eXBlLA0KPiA+ICAgICAgICAgICAgICAgICBib29sIGlzb2xhdGVfcGFnZWJsb2NrKQ0KPiA+ICB7
DQo+ID4gICAgICAgICB1bnNpZ25lZCBsb25nIHBmbiwgZW5kX3BmbiA9IHN0YXJ0X3BmbiArIHNp
emU7DQo+ID4gKyAgICAgICB1bnNpZ25lZCBsb25nIG5yX2luaXQgPSAwOw0KPiA+ICAgICAgICAg
c3RydWN0IHBhZ2UgKnBhZ2U7DQo+ID4NCj4gPiAgICAgICAgIGlmIChoaWdoZXN0X21lbW1hcF9w
Zm4gPCBlbmRfcGZuIC0gMSkNCj4gPiBAQCAtODkzLDcgKzg5Nyw3IEBAIHZvaWQgX19tZW1pbml0
IG1lbW1hcF9pbml0X3JhbmdlKHVuc2lnbmVkIGxvbmcgc2l6ZSwNCj4gaW50IG5pZCwgdW5zaWdu
ZWQgbG9uZyB6b25lDQo+ID4gICAgICAgICBpZiAoem9uZSA9PSBaT05FX0RFVklDRSkgew0KPiA+
ICAgICAgICAgICAgICAgICBpZiAoIWFsdG1hcCkNCj4gPiAtICAgICAgICAgICAgICAgICAgICAg
ICByZXR1cm47DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIDA7DQo+ID4NCj4g
PiAgICAgICAgICAgICAgICAgaWYgKHN0YXJ0X3BmbiA9PSBhbHRtYXAtPmJhc2VfcGZuKQ0KPiA+
ICAgICAgICAgICAgICAgICAgICAgICAgIHN0YXJ0X3BmbiArPSBhbHRtYXAtPnJlc2VydmU7DQo+
ID4gQEAgLTkxMSw2ICs5MTUsNyBAQCB2b2lkIF9fbWVtaW5pdCBtZW1tYXBfaW5pdF9yYW5nZSh1
bnNpZ25lZCBsb25nIHNpemUsDQo+IGludCBuaWQsIHVuc2lnbmVkIGxvbmcgem9uZQ0KPiA+ICAg
ICAgICAgICAgICAgICAgICAgICAgIGlmIChkZWZlcl9pbml0KG5pZCwgcGZuLCB6b25lX2VuZF9w
Zm4pKSB7DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBkZWZlcnJlZF9zdHJ1
Y3RfcGFnZXMgPSB0cnVlOw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbnJf
aW5pdCArPSBlbmRfcGZuIC0gcGZuOw0KPiANCj4gSXQncyBjb25mdXNpbmcuIENvdWxkIHRoZSBy
ZW1haW5pbmcgcmFuZ2UgYWxzbyBpbmNsdWRlIG92ZXJsYXBwaW5nIGluaXRzPw0KPiANCj4gTWF5
YmUgdGhlIHdob2xlICJza2lwIG92ZXJsYXBwaW5nIGluaXQiIHNob3VsZCBhY3R1YWxseSBiZSBo
YW5kbGVkIG9uIGENCj4gaGlnaGVyIGxldmVsPw0KPiANCj4gSSBndWVzcyB3ZSdkIHdhbnQgdG8g
c2tpcCBhbnkgbWVtYmxvY2tfaXNfbWlycm9yKHIpIHJlZ2lvbnMgZW50aXJlbHkuDQo+IA0KPiBA
TWlrZT8NCg0KSGkgTWlrZQ0KDQpEYXZpZCBzdWdnZXN0ZWQgbW92aW5nIHRoZSBvdmVybGFwIGhh
bmRsaW5nIHRvIGEgaGlnaGVyIGxldmVsIGFuZCANCnNraXBwaW5nIG1lbWJsb2NrX2lzX21pcnJv
cigpIHJlZ2lvbnMgZW50aXJlbHkuIEkgdGhpbmsgdGhpcyBtYWtlcyBzZW5zZS4NCg0KV291bGQg
dGhpcyB3b3JrIGZvciB5b3UsIG9yIGRvIHlvdSBoYXZlIGEgZGlmZmVyZW50IHByZWZlcmVuY2U/
DQoNClNvbWV0aGluZyBsaWtlIHRoaXMNCnN0YXRpYyB2b2lkIF9faW5pdCBtZW1tYXBfaW5pdCh2
b2lkKQ0Kew0KLi4uDQogICAgZm9yX2VhY2hfbWVtX3Bmbl9yYW5nZShpLCBNQVhfTlVNTk9ERVMs
ICZzdGFydF9wZm4sICZlbmRfcGZuLCAmbmlkKSB7DQogICAgICAgIHN0cnVjdCBwZ2xpc3RfZGF0
YSAqbm9kZSA9IE5PREVfREFUQShuaWQpOw0KICAgICAgICBib29sIGlzX21pcnJvciA9IG1pcnJv
cmVkX2tlcm5lbGNvcmUgJiYgDQoJCQkJIG1lbWJsb2NrX2lzX21pcnJvcigmbWVtYmxvY2subWVt
b3J5LnJlZ2lvbnNbaV0pOw0KDQogICAgICAgIGZvciAoaiA9IDA7IGogPCBNQVhfTlJfWk9ORVM7
IGorKykgew0KICAgICAgICAuLi4NCgkgICAgICBpZiAoaXNfbWlycm9yICYmIGogPT0gWk9ORV9N
T1ZBQkxFKQ0KICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KDQogICAgICAgICAgIG1lbW1hcF9p
bml0X3pvbmVfcmFuZ2Uoem9uZSwgc3RhcnRfcGZuLCBlbmRfcGZuLA0KICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICZob2xlX3Bmbik7DQoNCkJlc3QgUmVnYXJkcywNCkxpdSwgWXVh
bjENCg==

