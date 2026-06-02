Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B932BCD6E61
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2528A6B03FC; Tue,  2 Jun 2026 03:37:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A0E6B03FF; Tue,  2 Jun 2026 03:37:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1186D6B0404; Tue,  2 Jun 2026 03:37:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F276B6B03FC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:37:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8AFBA1C217A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:37:19 +0000 (UTC)
X-FDA: 84834166998.19.93D723E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4338BA0002
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:37:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z4xf6C1c;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780385836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rbZWNL2XlLQJ87qSa+MUJruQ9zp7RwzpGcXJ2fl4fw0=;
	b=we0T9tmUi0ggyi6tUAvxXs72K4Iq6z5FM0buMoHu3mj5IKMvagYCZc/krYxdgA/St4DNfC
	IxUS3G/ei3DoU1KFL/cY+NKsTecjjjcgqS2NBEnHlYh4vNXNEEhXf3L6xRVKrpcCFTGgb+
	EQoIDdaYDIpMZrSCNfisxZlUm6yZQFE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z4xf6C1c;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780385836;
	b=mrwBtBMidG8Bw3/O5px3iTff0ZS3F0TxaltnZ8ncTCA4EgiMxLq2AIv9SF3cZDDMxBev0u
	TNuEdZ+ppFFBHq0I0JJUOX+3JTnLcouLmLNRfKOeXr1CIEvIowYijnVDJ26aI9bFT7wTaK
	JkGkD2U4cMwcfWiFL99VUi3w5sWkumg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780385835; x=1811921835;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rkveLs8z0k+a1yqPcjP+cOOmPIUgEa3a5r6f2w9gcJQ=;
  b=Z4xf6C1cq8umShebmPPRXUF4IdShlauZyDUSx2Z8708PCkxcE7XIFOS1
   Zir1fdcPF/t6VJli0hrudStxGxY47tLrukr757/w10KFSGeUD6q/Yhvnc
   vOr4hKzFAbhgOSSFAuzhEGDsEUvZGTg/RLOl8uoeQQDh0lQnFx0tg2Cm4
   8FchGEgRgbTghjFR3YQjATdVae0Ksv7fzNSDUr3WNA3yQiaMivBVkkDAP
   Ourbht4fp0btVE8+0WjcNFVyfDMJTMEwQ9BLKoCOdAaHyXuS40y35xswe
   sLOBZphls7JnTeYnzFtwjB1KpIFhF1j89tD/ajRXxR7LrPoLwwKPvjVz/
   A==;
X-CSE-ConnectionGUID: gpnIZCPcTV+Il+L3MGRIuw==
X-CSE-MsgGUID: jzJEo737RR+6sDXyWcoZ6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="92276327"
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="92276327"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 00:37:14 -0700
X-CSE-ConnectionGUID: yBxuelSeTqqLHOHyFXKN0w==
X-CSE-MsgGUID: ZXEOFC1CTkah0Bk3QV7UEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,182,1774335600"; 
   d="scan'208";a="248916153"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 00:37:14 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 00:37:13 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 2 Jun 2026 00:37:13 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.26) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 2 Jun 2026 00:37:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ix1lHzbZ83ur7LRCl792ZND/CuNJd+a+v99zQ11g8aktWtdhm3udsCARLPiMI7WTqjN/KcSb05I0O/wBKjWa82fddGmdXaKzcx1IY97wJNg52uF0PSA8QK0lcQq6o1lGPznNfs9ViwhGs1Fq7CKOA8hw4Yt+bMbpsGvOjHbfSR4vwh9ntVZeuK9IPTxaghIcMJNUApbDd0KoZB62TD9jADV1CMG3qHXi66dA/MJuZVlPCaED3sYkihZBlsniD2jRoc9ICMN71jCQP6LL/NvNsA1GM2IMq/ZPN6RDtimXPW444GbX85rIi+DwBwaCGSBdMWQtiPA81C0bBGZWpdmrfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbZWNL2XlLQJ87qSa+MUJruQ9zp7RwzpGcXJ2fl4fw0=;
 b=vvxmZ0GxtS2x2lEg0kz+7HaRKMeoqLE+tD3hfCEPQ/avM2gpIjqanHpop0/d1EC1ji/l1ALCAvQ0kEtwq0t4DO1BHRwFyXhaiHr9Jk7kCxRcXe6P26R5krLN+PaS3uTL3emnI/gcu1CGKaeG0itrLnKT1CbC8sBGNrPPGgX21rzGYnLYAZcW6P/9kUjVVjGMZiYduw3zfrHJM/9koMDFXsJoQRe3IY7rn5okgiJ2nkT8r06ZN//ZPSfnBJgfieowtvKZTFbdDyO9z2kZq/yjzcrAzYzz5n6UfD3m+yXGTzkKnyunBYJcet84GhssFYV/33EmTLoqaP/hClrVDmnpow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by PH8PR11MB9746.namprd11.prod.outlook.com (2603:10b6:510:3a4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Tue, 2 Jun 2026
 07:37:09 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%5]) with mapi id 15.21.0071.014; Tue, 2 Jun 2026
 07:37:08 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>, "Zou, Nanhai"
	<nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, "Zhuo, Qiuxu"
	<qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan"
	<pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, "Zeng, Jason" <jason.zeng@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 0/5] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH v5 0/5] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHc6DwLqeZYev05QEaXLGMqbKy1FbYpXRSAgAGXY/A=
Date: Tue, 2 Jun 2026 07:37:08 +0000
Message-ID: <MW4PR11MB6936AE12B7A1655B07A213F8A3122@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260520093457.3719960-1-yuan1.liu@intel.com>
 <ah0yJzgI8znKJlUQ@kernel.org>
In-Reply-To: <ah0yJzgI8znKJlUQ@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|PH8PR11MB9746:EE_
x-ms-office365-filtering-correlation-id: 73cf7a24-2ace-41ca-a22f-08dec079c06c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|6133799003|38070700021|18002099003|22082099003|56012099006|11063799006|4143699003;
x-microsoft-antispam-message-info: W1oN3ANn7sUbizvKoJVdFWNaGvLYpbgDvnCh3X8mE/gkWyn1VuA2WUJ2QytCehsWXq2uJfZBl5wDzEV0xYrN2eNZhfnZ94zbgJSvvC+DogG25bbocYOlnkjKycmkbVO2AtSYAP5hR7N6TYcqxP1QuiBiKtxZ9ib+zz1tXA8GqCS/EEfcBqQ1IujaVz/A8sspTPqcvjS29LMwtUsuU9UcWKstaXV0MwVpG728pc5vi9K/L2d8ICJJEEtvXCxUiWVMWTs4W8yJGrRZICBF4wlKuVHDCFfXong8dlb+SBSAX51Ok/utOVZGrPZ0QL+FryzONKt0EIdf/jgVVWKo80SFnKjdubeM9JJK3mUc+L1nlFEmUw6X9QloO0VAVXFvsiJYdHkdmBlJENJ8TDBlywP51Ub8HvoObZ69tdrHJs6/m/yK8ELZ1R4aWa8s7gA/AC1ke+kf4ICgAZ2c2OledvZ3NGvkg8+RCKB22Foqb+FX/Jm/Qit+k5eV78ons7wOrSUrCDjAySQM7MfpEcABegCuG84WQoYxZ4WuDG7T8DNTdBv11A3+Zr0ATpItjJFaNpSjZf2DOzfdP/xR2MpETQJ6C+ZoqMVDZlfPHIiRB/FT+4mX5sI1r3/xj+47venLUH4aJz+4RN/ph4tLKibwokD67NUnXNSsUH8kvgQ75UtHth+NVp4NONCWVJXoY6D8f7Uq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(6133799003)(38070700021)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dVoamUXB1SUUTYoH1rcxYYXeU9I4Yd9MfuwG/cj590z+hO0fJeqFhSQ1JdX0?=
 =?us-ascii?Q?nej+4VyBlJnBbVWYKk2VE6u3XMjcgbWoyPnDQ9+/4mv92Czv2u3g2pWV0Uqw?=
 =?us-ascii?Q?6l6YBEbb3D+8I80OGOiWpS1OYPRp2QXd9vnVZ3+ua1xeH67HmApTRmaAFPsI?=
 =?us-ascii?Q?PxlzTSA7+15r1SJCqD5ya8El19uLDzlLz3NBme5hyGyb4obPCXJd51NG6+RB?=
 =?us-ascii?Q?UQwSTDiaBtJl7nUw7eMnShZKGu0fmsSOLc2TEFRwW5mJCVnZ/ZCfImXBQIBq?=
 =?us-ascii?Q?Ug3mtVHDGIfN7f+N4odi0UvkvVXUUp6uE0nmSOQK+Pna2al37IvEY2/4X15D?=
 =?us-ascii?Q?QEGx8tdKkdm1eRg2OJtM9oyXk2rOWWwaRUWKuT/4lv1LfZjvJLUf/J6RRAzs?=
 =?us-ascii?Q?llYBnjUuV6RF2brwtxKozuxORn/V7OMfzjW8XrRdn8gDQnRhzVmiXvYA7ozb?=
 =?us-ascii?Q?mHZ2mqH78eFFTBJFYNZbqU+F9AYbWbJ1WOMVv4rXAEp5gPDoY2JZ4ap0t3J+?=
 =?us-ascii?Q?1bmeKYsiFsq1tEL9zrNAPxshLoXGwkvHAvdaPa0dhh90xQ+aJM7LNiL+MMq7?=
 =?us-ascii?Q?5jPdsvH3udQdGI8VPOToazzqEdRXM2HdDr4v8bHxVcwFuwUuKYvqKseUT8gm?=
 =?us-ascii?Q?H6v3ypZNpBsHgdLhNnFcSGi3YvTmmLM3Ns3rsS1C7gvZK3XfEg0bjeFOgA5g?=
 =?us-ascii?Q?KgJiLLUBlhR+5QK1t0ZpEwCKAePIxYleUGu3XODLuJW5ubb84M25SdOtYyOD?=
 =?us-ascii?Q?x78yUrPlqPu/emILNWY7n45UOYuSKzU30cuJJxTeJMYoxgnLET8CPWzsal4Q?=
 =?us-ascii?Q?IltTVCUOjK43MdVuO7yKWIaXAS88JlCZIyJ7sGd7RdRB582bJPTiOTQOrHwI?=
 =?us-ascii?Q?UUwDWQR7BgyeLqAzl7yGnMRTKzaV/4EU0xuNHE9fr4C2JobgZoplnsE7catK?=
 =?us-ascii?Q?m/xi1JO5daJ5iAxVqFvyTgUCJS4zoKvfEFkwGe7pmNeOUz4pJEVzQKNDQmWi?=
 =?us-ascii?Q?Vps0Gff0jyiD6JAmaGS8+kTv1tVbqCq5cGqbWR/f+76dMLcsWbGu1KNcoiMR?=
 =?us-ascii?Q?YRZtK+ODLjMicivA++S/BHpspTx8oQKSD8fTmwExwC41ZwXjXVMaADuyefOv?=
 =?us-ascii?Q?vNK5jAgMFuuXcdBqY8k87zOmTBOWtpA6Eu9GeWLhvruDoGNCcC/NNph4ReE2?=
 =?us-ascii?Q?VcP4cKgxlFogiKMZQFvAnffB1wdLvcxXRamMeNY0TDiS1zIAc9roNrQIWRGz?=
 =?us-ascii?Q?PjZgW233b0mevouuaIezyBpfIMJ23zZmHORQRyB/ktr25KhgIyc23s5TRm1C?=
 =?us-ascii?Q?9ySRLgpGTHWplTNK37wmIJRchRBmoUUewpK5FOW2M7i9QtZYHhyUuygmOK3I?=
 =?us-ascii?Q?AjPFW7d6V1OoHGYDqGsQOmCVbeoejaghE2lQkZ1hEYWTKCxtgFIEduXrD1MF?=
 =?us-ascii?Q?8Pl0enRjm6isR+NIMGDyz247pttfSsyamMEOl8J4kpch3kW2qWAlPgtXerOg?=
 =?us-ascii?Q?FFpuEigcho/Cs+S/oVaE6kPaGyxu2OOt7nzcHvWAasnU9+Xhl6JQGkR3WFRJ?=
 =?us-ascii?Q?8sXCflGRjnlpdDS2HCdYS5HVyLovofST3YNpZQgTW78alVFp9wHZS3GiZXr4?=
 =?us-ascii?Q?vagci6z6opglgogAHpzTCNruQIcbZ2sxjYtC02NsAPfBKHk9lEIlRrvT5P9K?=
 =?us-ascii?Q?gDVvuLRbqSkKpgGQys4sennyl7a4lHScNB+M7ErIznEas3i1?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: T/1BuUFNsRMBZZs1dyFTo3lIGxKvXClbvyhLSal2IqT+wvAaZknwDjwqiVq+aSFBvDp+Gjdsd4fhMkBmO6ZkjWS6MV7/uOrDHRI4VmuGUbdR/EyxMW7LsCZYAxaEy6DuQHlJwa5SfsMFkWt7sntRRJVGr/Q2+SgvmO+sGJfIArmRNfn1JPvgONQrCvGQ2rS8jLqORW1pWzkP3WfzttmMCM9mAMIKZoUEvwCeUn7KleSRvDI6V7sKHX+TEGe6S5JSL+HkTOS+PxTfHXsjjmDYga+UZ+iRPXB860aUNEeTQfWvEjxwxtsDVMON2rjLpPMJsN4/Ga+qYzeJ9MBVfXl3OA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73cf7a24-2ace-41ca-a22f-08dec079c06c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2026 07:37:08.5064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5M5ddJ7wAcAezd3IMDp5MYmpMVjwYiOOQjbQewd3yvFEfbPlpwiCZsDQiQPkmcO4GSSAOy6EMvhpLpcOp8YyGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB9746
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4338BA0002
X-Stat-Signature: 1t9fx65h89jx3cjrzs87nzi1gumm8xw5
X-Rspam-User: 
X-HE-Tag: 1780385835-146915
X-HE-Meta: U2FsdGVkX1/r/lR7kz5NxivqJ9kK4C+Mm6qYxbm8khO603xbi/6jwyfaGpk14q7EotAzzEI4v7/BbYrFjHLTpn1f1rN5HjtATCZdTvTp/73n901Dj3pGfmnO4gRe7D/2zM6v5r0o/xZGYg6rnwr4weJi/np6nNkpVkWZPE0soo7Yg+zhAFOSCEwjgOuVYAmlxmW3fUwuErvWHs9Q3V/mXncButkMLq+3MYxPORLdwdO8Ef1AhM98WssbB49p4TxOFcusiREwEk5vY0Ji7hAlsENthtJF5ig7qj4yOlQ6T1d88a4uRFJKtqo9l2dprMVEmmOGZ2REZUL+Vg4FG7pX+DeCOBwjEzfvpwRVD6gxwEa4KVVa2KK4iiVM4I8DsLTzlIcPKsr/ttGZ9HMHajkcj1IGG3jKjEP4LkBKwY9FABK92Va37WRQLbU9ftzyVXfZNVnin6UoViIf0epmx3ADIp4yiUDoABPiSbryQJxMY+/pka/cJOWdYaB+tgkghpVdlbAvcd1XIr5P7b5LpXWe4AovcjzuMCBEgM78sQxfh6euVDp1iyfGewGDY+JZ9eIo0e91j5N37TXKlVsmTI0zZu9RPCT+DL512BqG0guHTkBkXNhJxHlk0XuhFpKsHeVBpQX+Hi1kn3wd/txTacYn6rbxLkcd+NBr3vGYvKR2M+2EmzyBm+XDEV+JmwRNwIVwwzvxeeDarWwDRi498waNmpt2F7EqzVyA2R0pzKBAx9iLC27YJmASQdu01nOw7MkNg7sCynd0Ou/Qer5ye4p2/H2T8UKmYoXnfNyBBdYxDNI+4LpvOYr6TZM5UNRaUswd7sT0bBkRwX6z5ZmHTsX2JJkx5KVvBMkUvAayOQNasg4DyRLY3W0mMAMiW7XTPOH3SrYhOcW/KCo2yyruR8Ee4o/rnmXXDvqs+gFtSee97Ti+6aHrladYOBUrsuleN25QA3d841SpKje2kohi6eG
 2rWaJHYy
 rMU0osUUDCGDnrWFrbmB4ao+xawx3/tw1O/rYKBSTRvFj1V4nfHOZwdEcOU8UHOjNSU6Y0nEKzRIy/CG1V958wY6J9fzCFouMiQKsztYBLrZX00QKBpFYK6UXZ4vcSc5swKTUltVmcKHkwpMjQBu/ZYyb/XQfkKBtWwpcn5bUtJUqYiW36hU/thd4i7AMnqGd0uUMwMBPmNT+O/XiT+eyluPMBbitr2hOYZiXI3I4A/+e+8V/8yqqn2f7eaH+V0qFkVqSg6aK2cefaVv6oYB5MfmjSCwMyy/CAR/Vyph+a9OGu5ReZUUkuMqda/tmKWfNW0LmopK4oUNXTWYI8c0MLWv0xb2hVvaSDjd4Q0EJHT9ywbThp3vU1VXo04mEbe6I0LblcjU8RpWHGxQHs3Sm6TE+Rg5gY8gKSHyGMGgi0h6rC1COHYlsRXOy1byNgHwwOsTzCccD3jEoboT4aVo+AAvrY6QKogWLFGgknM/XNiah1Hr1tXy7aYInjbeMtGMD6MNNVyExpb5Qe8EfNlR9c3Hr66vi6QKbeZqARWbO34t51xOjOLN2xb6cs3Glc7kN/XPjlm9bZKOS3MfxvCbQDb9LKkOM/JqS4u3ToFvDBPLSQZytEsePnNg9C3+hWcaaG8LfiRBtgJGhpUVcb49vOKJLWV4di5tNdgQiR91TUlgXt4YYH+4VBg13XemTOV3hud5orM71DGqPRH+VqgnOPF7EuOv/KKcFMsh602TWpqSwGB+aciDdjA2D1TYDgJSpGPHX1sWMttN8quG46AuZIQWhE/xm6L+cKF+lyYtBtdaM563x7PCxH6v/7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> -----Original Message-----
> From: Mike Rapoport <rppt@kernel.org>
> Sent: Monday, June 1, 2026 3:18 PM
> To: Liu, Yuan1 <yuan1.liu@intel.com>
> Cc: David Hildenbrand <david@kernel.org>; Oscar Salvador
> <osalvador@suse.de>; Wei Yang <richard.weiyang@gmail.com>; linux-
> mm@kvack.org; Hu, Yong <yong.hu@intel.com>; Zou, Nanhai
> <nanhai.zou@intel.com>; Tim Chen <tim.c.chen@linux.intel.com>; Zhuo, Qiux=
u
> <qiuxu.zhuo@intel.com>; Chen, Yu C <yu.c.chen@intel.com>; Deng, Pan
> <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; Chen Zhang
> <zhangchen.kidd@jd.com>; Zeng, Jason <jason.zeng@intel.com>; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH v5 0/5] mm/memory_hotplug: optimize zone contiguous
> check when changing pfn range
>=20
> Hi,
>=20
> On Wed, May 20, 2026 at 05:34:52AM -0400, Yuan Liu wrote:
> > This series introduces a pages_with_online_memmap member into struct
> zone
> > to avoid pageblock-by-pageblock scans across the entire zone and improv=
e
> > memory hotplug performance.
> >
> > For VM hotplug performance data, please refer to Patch 4.
> > This series also benefits CXL hotplug. Performance results are as
> follows
> > https://lore.kernel.org/all/20260409023552.GA2807@AE/
> >
> > Yuan Liu (5):
> >   mm: move mirrored memory overlap checking to the outer loop
> >   mm: skip non-mirrored ZONE_NORMAL memory map init when
> >     kernelcore=3Dmirror
> >   mm: remove the special early-section handling from pfn_valid() and
> >     for_each_valid_pfn()
> >   mm/memory_hotplug: optimize zone contiguous check when changing pfn
> >     range
> >   mm/memory_hotplug: improve shrink_zone_span() subsection boundary
> >     checks
> >
> >  Documentation/mm/physical_memory.rst | 13 +++++
> >  drivers/base/memory.c                |  6 ++
> >  include/linux/mmzone.h               | 60 +++++++++++++++++---
> >  mm/internal.h                        |  8 +--
> >  mm/memory_hotplug.c                  | 54 +++++++++---------
> >  mm/mm_init.c                         | 83 +++++++++++-----------------
> >  mm/sparse-vmemmap.c                  |  4 +-
> >  7 files changed, 136 insertions(+), 92 deletions(-)
>=20
> Sashiko has a few comments:
> https://sashiko.dev/#/patchset/20260520093457.3719960-3-
> yuan1.liu@intel.com
>=20
> Can you please check them?

Hi Mike

Thanks for the reminder. I will take a closer look at Sashiko's comments.

> --
> Sincerely yours,
> Mike.

