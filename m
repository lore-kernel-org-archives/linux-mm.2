Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 622F4C531D0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 02:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B54E6B008A; Mon, 27 Jul 2026 22:23:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C1B6B008C; Mon, 27 Jul 2026 22:23:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17DAD6B0093; Mon, 27 Jul 2026 22:23:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D18526B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:23:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A2268026A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 02:23:25 +0000 (UTC)
X-FDA: 85036588770.11.39E203C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6BF7A20003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 02:23:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CGxocuG9;
	spf=pass (imf31.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785205401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7+L9FYtHq69D0O93ErSC0nPh6F8s0pGmtsamdXFd7U=;
	b=q9zTnvSFvL3z08iQ4OZEX22hWN7xKfZ/xkmj8/6ZqxUhbx63NF0adv2RFmGxu8qNaStuCq
	kZHGl8z2ZKEaanX3xAI8SpbjcdjGYx7+r3WmAiDmURrz+UjFQJSgbon7J7eBbp6MT6IMNN
	AzsYP+wBc386RHMy7hOKHd7Oz2IoCd0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785205401;
	b=VtfIQO9MXRah7sbejbIbSo78NmutWVURJv+d+phSCBksjYWQfmybLOJ1OYHsQBFza/v+IT
	0xKLcdMPRnbZPX+RtASWCcv4f3wHoXGXuIPWhbNgn6yUic36ixJCqe01tSrYeFq64wgVs1
	74qWJVsprKp6NBCGnEab/xQKBRdkcDc=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CGxocuG9;
	spf=pass (imf31.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785205400; x=1816741400;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=KrM4YQyyTFh3+iTMJwae8IMG6gxcbJFDv5ows/tqf6g=;
  b=CGxocuG9Ca+uVtCSA1OLcRRxRKyW9zJl6/skrj8UF1v5Ve9fwDp/JnOu
   70Mkhxi2QUDeOz6Vut83QiL83t3UTI39WbyR4ljrwIVGBzHijx6H2DOkB
   YkuMtc7CDhXZ41S69OUPm2yBXLgLZKtoYKZIcFV57iicFqL6iUrFIbjxK
   6gaEU1kKUf4cziLvBXBusALWOsZ15O+WVX07eeqbAhegDbzmkh2fO8Ei1
   7A/kIam7hgV27uQSi12skGriJqUD9Ag607eHYFgujbjn7VI691tRz7XuY
   GKn6graGHh2/5KV/90acygYo8y0xKL8jfn0JUMCRiuck93UZFi0mITt//
   A==;
X-CSE-ConnectionGUID: dkNpSspcSmOaUXhPu4iRIg==
X-CSE-MsgGUID: aEjWbA+uQriHW+TERRob3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11858"; a="103324571"
X-IronPort-AV: E=Sophos;i="6.25,189,1779174000"; 
   d="scan'208";a="103324571"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 19:23:13 -0700
X-CSE-ConnectionGUID: 2uEWrVhUTlCcnc3Oipb/SQ==
X-CSE-MsgGUID: tWSFGdFWSbqApsB+11V7WA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,189,1779174000"; 
   d="scan'208";a="284110316"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 19:23:13 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 27 Jul 2026 19:23:10 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 27 Jul 2026 19:23:10 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.19) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 27 Jul 2026 19:23:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kOuCOSQaRms1J8PYkAccrsmlqiwhLI+sTswyMh4JI3EeoG3rQcu6pFWt0mG1iRZyL/EqvwMEIsEP3p+f6yrZqNSqb9vm4Nyj86a4fD5+7a4OUzLYm2SkziB/u+k7aQJxmxMXGxwHPiGPSwVQIquE/DdjQYe5aqtlNkiESZ6zKUy0sRhw/gUtAw9pB3fRG78YVC3Hm/+rDTpRaRmG97sM5kQUVTEz0KZv1H03IbVwTy5SDEs7W69AwyMxCF60aeISAG5Sj0hNVCjCoKrbSVlXlFyXoZsoYhZyCjiEk6zddNvXjLgJCSTxyqANaGuj57bYH1FUzrTY2I2xaRtQiydGrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f7+L9FYtHq69D0O93ErSC0nPh6F8s0pGmtsamdXFd7U=;
 b=Zn2Cl+wcBaY2nJSzetxrs0XFkaqywoowuVrOffsNu8WIh5Yr3MjEF4oah029H+/MHh6Xc5IyJeorvVUDJ8ra0EazzGfMKdzcyrw+4Sn0m2x1Y/Jr+o3V7RkqpvT8QXhPoLAqWYbE+U4BWovWY2Y9mx9hu2eLnFzmsiOdtqcXuD6wT2Egykd4eZAF5iuhghin4h0vkQX3o3Sb2314RnZMQgbrfaw38mKf+Q1IO3/UTqIYbCvtM6lP3ByEpLfdA3ACPyo4JWduDXMy4fFW7zwrFUJcpEG+HJF6/XtQx0GWTJUEZe+pnQCxQNRyIG7UglTbZxC2/LrDSDseYLLl7G43Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by MW3PR11MB4650.namprd11.prod.outlook.com (2603:10b6:303:54::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 02:23:07 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0245.012; Tue, 28 Jul 2026
 02:23:07 +0000
Date: Tue, 28 Jul 2026 10:22:56 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Bo Zhang <zhangbo0325@gmail.com>
CC: <jack@suse.cz>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<fmayle@google.com>, <kaleshsingh@google.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>, <ljs@kernel.org>,
	<lkp@intel.com>, <oe-lkp@lists.linux.dev>, <surenb@google.com>,
	<willy@infradead.org>, <baohua@kernel.org>, "oliver.sang@intel.com Bo Zhang"
	<zhangbo56@xiaomi.com>
Subject: Re: [linux-next:master] [mm] 7b32f64bc5:
 pts.svt-av1.Preset13.Bosphorus4K.frames_per_second 45.8% regression
Message-ID: <amgSgM5FlCK7QMFB@xsang-OptiPlex-9020>
References: <ama/sQIK2O0MphL1@xsang-OptiPlex-9020>
 <20260727042022.3503727-1-zhangbo56@xiaomi.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260727042022.3503727-1-zhangbo56@xiaomi.com>
X-ClientProxiedBy: SI2PR06CA0004.apcprd06.prod.outlook.com
 (2603:1096:4:186::20) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|MW3PR11MB4650:EE_
X-MS-Office365-Filtering-Correlation-Id: a8db8854-2695-419a-7cc5-08deec4f2926
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 990e2hBdFMV/wOLMTM2TD6JiLoNC5+4OPXq6UdpGP7rElSH4nTy1/x4J74HulZw5qxuSjBEJCBDNAZ9wUVuh6JdLA78GrQvZb2HxiOPpbkOV4yA7G1gkvur8CQ7sDoZkuaeVPGlx6DmCkHC3/Joh5HyX6vgNHGOuh8tJHO9yg/B4EjNNja20R90hJYH+K+xCcbrYewH3HGPFWVsz1BBRlBCgJFkWgHLw9ORcmg148oXoWhuZrqzS7hKdU3q8U7M/u6jJ1h6X9Y1NjkPnFKRXH7n/HPFL0fN+s2TiyUsctkiicrImjq1d7NkzeKNFQajE7WBjGPQILRH0mlAm9qhQLfRunbXIyPZ81ty7mx0S3SkY7KVgTT5UAlP5Ahi9DH2icq/zCdIUQFaND0SapPsnL9gndMd8TCVGdQA0V6ZXCbzQwvZwByGiQVxYqfcRYezgrKE4FlzShBd9gIOV+meD+8AmesmyADI9ErhShfUZKFQlAhZzK5cUAF7XS349uVJ7lyjLP+ew6ux8NZlfg2qtyk6MSt+6CGJo97+UZWoASoEjT+jemLpyJX0XQh56LCFcXkgZYF/ewF32fbbkkI3y8vEHVI+yKa86kQu5Azhgj7o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q0G64y9nY82PUCgoWyGxFnKKOD4c+uKOAwUyDWdprKlMflRNnjU3qLlzmwDy?=
 =?us-ascii?Q?FQ6tApbTPAC90JIeq9fDqH+g8ynX52/VSFBrQpeJnOF4KVPVOSxksjXxjE1g?=
 =?us-ascii?Q?YSteGdLO4l2sSr2X6zDpKyfmRM+pjGgJVwNcXtwk6kyqqOadKXIIFFpXQmhn?=
 =?us-ascii?Q?xfaXTznCD6CpRs3FdTJN2dlZXLt5//LnLWyIL2Z2518SWD9rKjpv7lsOtmL8?=
 =?us-ascii?Q?6kUpcADYVFiH7w9pzj4SmvtLJlfKegTvecVTSOWhIEigKT1JW6XgINVM1L3B?=
 =?us-ascii?Q?VKWMP1vYD8N4JBSupTKC5rlBgLIYUclMnN343nB0VjQQlrZnvmMHEHvjERJl?=
 =?us-ascii?Q?0LGuDjCGqE8HNnBvCLsH+ClaJ+SLlVUUJ55GZJX9heIJhLGW7LtuGy6p7iQF?=
 =?us-ascii?Q?633zmpjcQIbgkZzraQpQfC5baH188Q2nPpFjT+FAEiHLtBl2H7xb6Efuunao?=
 =?us-ascii?Q?KcYoTXvb+KuJOliIYj/MlsEs4mHanHeo99/TIc+ls5XXrfu2ww/jhJg/e1EJ?=
 =?us-ascii?Q?hMlLhSj5CItD2G+JjjRJEhrc+MxTpNoqtz3t7lrqOfy0HZ22M0RvByEi0XJ+?=
 =?us-ascii?Q?eFHA9RQut0RCSaOJPrDu/MQE6nbMAM++zoS9H8cxg91Rpf+IGPGtS/dFS0YI?=
 =?us-ascii?Q?BgGlU3upB+dFYhQbVZIG1Dv0hW+vULIJIWS/fbh0zXBHKm3mnBw87gtZ8Jlh?=
 =?us-ascii?Q?Yy6YdElYoNbfuLssKjX03ixeDuug4EQoGB+d/BAW+GkVMjRNl8iWdPMwyejv?=
 =?us-ascii?Q?3zDfHfitwIOByN/pNMrVJJztYFNmCaUsUlwI5CsUCfELunuIr5esbEDi+25o?=
 =?us-ascii?Q?Jw85c57GprtczSLau35zONASyX7R03r7JnPCPwLv4L4Alp7Udjg+W1srKA/8?=
 =?us-ascii?Q?lYj3gDsnVYavULl+azbe7cljnumDQz4XbFvCCW6iOThpadmVDJWZfXGbCvPL?=
 =?us-ascii?Q?JV4DrMXVKT8D3Qj/W0FlXHBMCdYs78sRecIlEn0SYYghaNPwSfe3fgp/JNir?=
 =?us-ascii?Q?HtsGW4J/KwOELWaWAcMlOR4uVCaSoGpZC4RZI5g/xSJTEKa37EKgi5U/jcRj?=
 =?us-ascii?Q?XNDtZgy7ErSN2mKUg+ndO7vdvhdoGH02qizg+THi7QhNGpRW8EAqreyWZz/R?=
 =?us-ascii?Q?2UGxmz7wGuzVqX/fYIt8yv89+oG1jZPItSRfbxMNZoDkQCI6tH58JCEnX0A0?=
 =?us-ascii?Q?cSvsky5wU1mH0ixFoFcviVbIswusv9XWBRP6N0eAsrpuaq9bCsDtXswW/tUI?=
 =?us-ascii?Q?u4ASmCoZoNe6Na6mS7sidlDlHR6yyFgnGGcM7paUGJ6sIHIfBwVPVaaspIxc?=
 =?us-ascii?Q?8RpTLYzlV/Zd6CXxwA+ky3DGMioO3dqdNQhy8pGkofon84MIH6SVDwCjXfXG?=
 =?us-ascii?Q?wrbTXIOBWftpItYwKXrZq8v9JuHkHeyCNIquq2Ijb1Si3YymKxFYm1hVBxTv?=
 =?us-ascii?Q?4AnHBsjQyM/tOUPJIJJ67Jl6ytHP6XMZx5f7vqJzKLGyjorxstNV1c8RVM2t?=
 =?us-ascii?Q?4o2JDQ9YnTy+O5TsS/l+nKe55j2rJLOW8Voj4K9BZehFJP6WYO+9cNyFLcso?=
 =?us-ascii?Q?Ao0xoSKtXWc7kr7kMWwleD58fuOJvRnKJ4U2dHBXeGb+AbPJ7apjH4uLnSbU?=
 =?us-ascii?Q?vKxRhL9xSYB877+RjgWwY914zmM7I6NW95q3GE8pGR7dXSZSQSUpoZzK1oPq?=
 =?us-ascii?Q?9r7z6saNGc9VALKQfQuxyKoYJ96RY15xPszv73+s+YQpD4KNa5JxggtDr9bN?=
 =?us-ascii?Q?jXoHdP7FAQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: HyLMNt+rT+qrAhbGbpYlCkNj4GtXG7kIDwlZJWynA2b9dd1A01u35qhEcK/LiLyuQRF/VAQekODaoOtJuhwOUwnz8z7XWqugn9VKnb+Yx+YMLlPMA3lIRPfakPhqGfT60Gi5ntBImA3p57hadouIuRil9Hu4ncOAkJByIj2hAZLDzBx8IEjwqV7H40ntKDDJunoh6EesfFTGnhILqMbPBYY9vmOfR+ElSGolDXbxvCl2c/KpjgDsgVc0k44L4QIXyRUM1F094etVbtZvNplK3oDlGpEn7q//9hIT0kbLSqaAPSisWznGJI4BT4RY2LaaPRergw09+0QMEO9uv9KHnw==
X-MS-Exchange-CrossTenant-Network-Message-Id: a8db8854-2695-419a-7cc5-08deec4f2926
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 02:23:07.1826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NQPU1nfr7uinedBLORFXIFxUkNOW6luABwU8CP1qCBQt6Di3rKeOQU5l6fcbb5Y9X39fjxH21l3eIHjlhbhEBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4650
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6BF7A20003
X-Stat-Signature: axm6guqaaqgpkynzsideuszkpfj4oxc8
X-Rspam-User: 
X-HE-Tag: 1785205400-885813
X-HE-Meta: U2FsdGVkX1/JA1LVU5GnxJ7DXZAjKCB8H3RcIpCRUZB7tFgt6IAz6QxhrfbCvqngc9GKhTlG3EH1qxhLz6ADIJiBS4tcHMbJ01TO1i4RomNwPcrd50ogkYjt/3AvHXFC4eTzL/dVZUodf2bB1cLvBLCwkBY4zvocTd6yX4WXfJS5FZU+5bRdIFGbk5IHIeeyrb1OnH3lMKIe0Iz8jBbh+gtLPydAXz+hOjXye5FCpUbjkMtMlnBRvuOs9Qxjti/Y8LdLSWCbEEglCWjLBQJBP5c+QZvT4uQz5YmsVpCrB2PCo1rZ1Ji+aDrztax4zmd8sTLhqRRJGgBVRehImZ2dnZQzmdtBn6AlJ2DlQorabIFCzJx8rMT28jxuX/m7gaxtgJrCckctmGlbh04Pks7A23tAqF6E53dyEnYVkF6NVyJa6gHYkrS/4Vo9OSxzBq5SkrAF/q/7zpVqlBUKWrWbzHqDH0YvkwUhIav4/wDzWtR+j0PxteNnUUhBhkyc6JxgI1ga2N40Zu+66bGue3gIxJvA2dFqDljdJm1zZwYDU8Rh8kui7eIjTtZsfNW+9HkyoYK87zma7To9G/k3JxisuRuxZycsaqKMwMeNLaGeHh08eGeyVnaPN9bO27X3f1DXoPNl9n1sx+1g2WPzt7D+wRsxHEg29Z79kh0oahvFlsoLavCLoz4CZnkd7B0JDl3kJx6lT6b8/xYNdzwQGRpKKp2m1XGyrdRktuIAY62SxmWjwleJVKHDSka9j5Qp+AVgtyVhaESqT35vVpW5txJAqZG3QVpMP4bGevTG6JvWDC8+3gTT3AdKXya8ujqOBdpvXpaOcHsHSwQM5FLcPm2Ygtg19t9OBI2K6kv9V0oYIiYOP6QzRTxiaglHAW74RJit8P9sZyzn2fv7TMZjaUf5OVFNt41ubgH+Q6nuXg/jfdMMFYQE+b1AWofhuuF7ilnbJ421qxFu/liqKAROKUX
 3MtQaeUL
 1yIOqcsV/1TT0RnpSd8dzPUgtsdk69GDpu8u9bB6WmlbFmwic+9Eg/LzaLqUmWb509o5IOhySKmP+8uIyJLojQeC+LnLQ8Ryl7piPBdtJRZyFTtswiVk47p2V4Vbjxtaagav5X7t8XPLJtGXBQQ6QP3X48PLnkVg6LVVwrVQbLdB1FkZ1uO9kY6SalhcFPs40bO9cEiBTvyseUFSk2j56+T9UNQ3TWhIDhcFgwJ171TTws+GsaHFY47QDkb+T2uU5YUKHsut75+xSv7T4KQIS+GA4m36pZwwVylE11UvpDdLk0JO77tKRWWBdRB7MrC79ED2kcavV76Y2uSjJ2TViDIVS2LgTYifWV7dsNUiCqocWVFnt+ujwV0dZ3P+nXe5VERhpUzkljOVWJpklt3IPYO3/rcXAhA9Mf2wvDXcXqwI0WOT8j292ncl3v7DsSuy0Y/yAsP6014hzsZriInNRIeRWe/KB+KFnnXzguLJ3xs/ZCTfDrL0jjHjJDSp/ydE2M0Wrrsqujk8mpjf6OBSEWhxyfnoGwXcdw1m2U+DeolctYgSU3uqs4Hb5y32QmdzVZ8tMCgPUxv6UJ7EPHBr1tHNP2u6Xg+xRi2cP9LvLa2KAMZGtPLsvf7c32etEsV9M2DDnq4X+t5fu5BE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hi, Bo,

On Mon, Jul 27, 2026 at 12:20:22PM +0800, Bo Zhang wrote:
> On Mon, Jul 27, 2026 at 10:17:21AM +0800, Oliver Sang wrote:
> > quite sorry that we lost the machine we reported this regression, and since
> > pts running need some specific settings in our test framework, we still need
> > some time to setup on other test machines, we cannot start the test soon. will
> > keep you updated.
> 
> Hi Oliver,
> 
> No worries at all, take your time.
> 
> I should mention that my patch may not fully fix the regression reported
> here. It is just based on my analysis of the code path, but I haven't been
> able to reproduce the exact SVT-AV1 workload.
> 
> To better understand the issue, would you please share some information
> about the memory access pattern of the pts.svt-av1 test case? For example:

unfortunately, we just simply integrate "Phoronix Test Suite" [1] into our
test framework, and for now we still keep on 9.4.1 version [2] since we don't
have enough bandwidth to do upgrade recently. and for svt-av1, we now use
2.11.1 version [3]. we don't have enough knowledge to dig deep for your
questions. sorry about this.

[1] http://www.phoronix-test-suite.com/
[2] http://phoronix-test-suite.com/releases/phoronix-test-suite-9.4.1.tar.gz
[3] https://github.com/phoronix-test-suite/phoronix-test-suite/tree/master/ob-cache/test-profiles/pts/svt-av1-2.11.1
> 
>   - Does SVT-AV1 mmap the input video file, or use read()?
>   - If mmap'd, are there multiple VMAs over the same file
>     (e.g., from mprotect or partial mappings)?
>   - What is the typical VMA size relative to the file size?
>   - Is the access pattern sequential, random, or a mix?
> 
> This would help us understand whether the regression comes from the
> async readahead blocking I described in my reply to Frederick, or from
> a different interaction with _max_index.
> 
> Thanks,
> Bo

