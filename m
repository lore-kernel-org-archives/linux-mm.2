Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D921FB44C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81F3B6B0005; Fri, 24 Apr 2026 03:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CF5A6B008A; Fri, 24 Apr 2026 03:50:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697736B008C; Fri, 24 Apr 2026 03:50:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 54F6B6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:50:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C4CBB1C08E6
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:50:25 +0000 (UTC)
X-FDA: 84692676810.27.760F5D3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf07.hostedemail.com (Postfix) with ESMTP id 70DA240002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:50:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ifmnWXL7;
	spf=pass (imf07.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777017022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCDSlyNym4u1PfjKues09Ory/t7bYxdGytQ08RhdEiM=;
	b=X25jS0hiizIS385PZLd7/Wu+Hq5O2ByKsNaeJZk1RrWQbxIa2jmfq0dDPSSNUJnXg5VSjx
	DRCQXaN0kDlvxYqbamYZB8T69Q+4rkNoqoorBmxVMMJ8I4cxr9PAq+JfbR1vOhGi4KLkM+
	j1lL3twLiEV1zMycHW6W+2VzapRhqjo=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ifmnWXL7;
	spf=pass (imf07.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777017022; a=rsa-sha256;
	cv=fail;
	b=V7y9ApF8F6ldvYcjWaRpYldwCo4v5w93NNyldNaRC/+X9g2GFxDkVxkD9UH54eXSrMYe3x
	GBXPy2Xu4NWEXxBSDgp2RVsVnsyhd7rs1sCXnoRn6OPH4Xh17QhVnY/gQ5C+puTRA4xthi
	5ui4RlDS3prHdWfJC/TU6x1gDrnkVME=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777017022; x=1808553022;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z/jj1UxDQMHKXt2fbX5dYCqTAyhHR16N21XYGc6JMFo=;
  b=ifmnWXL7XMELvQ+uyZb624N55XU3BvXhIx9W//IReJk/gbXKLi9cEQro
   qQYHINxQPGtwEqz95FRQhPudsTUVIrFAHrNvUl929e45VPT20b0NTE1L+
   +/eiVvh1qJn8jhI1WRBpncLBPFwuCREum+/ZGT06XSOUZPx/Dm7mA0jMl
   L9UC3Z/QbBpxAQy9UFt7XAWiJ8BiHKSYjtVCzRD+8sjJ7GdfZpIZLrRSg
   WRnRPnsjyqRwB7EvLLw0WgO8X5humckI6RINam9lYWbScBK4mpGdsowPT
   mVsfQxtAbQdEKnkVB79NbfyXlZJHf+Q+aRal3UVH1NCvhs0/ci9jFNQh9
   w==;
X-CSE-ConnectionGUID: 0nruCRQ2RfOEI5BLBWaCvA==
X-CSE-MsgGUID: alylYrR+SOyX6oLYlZzi6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11765"; a="100646725"
X-IronPort-AV: E=Sophos;i="6.23,196,1770624000"; 
   d="scan'208";a="100646725"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 00:50:09 -0700
X-CSE-ConnectionGUID: eF87NXqAS9ix32R7jpMJ+Q==
X-CSE-MsgGUID: +oiZ1ji2QXWkoCH9PmKNyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,196,1770624000"; 
   d="scan'208";a="230226141"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 00:50:08 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 24 Apr 2026 00:50:07 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 24 Apr 2026 00:50:07 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.47) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 24 Apr 2026 00:50:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=feZBEHY9gqHEENvetI7cJEI6dVvgcjoJ51VEsCjKVfmlhd9rV3a1ikK+/yJ2X0aoEJB7OPH0mv9MRalWZu8J5X+Tltxm7uVZPvo0a20FZrYTmwr/xuC5F8tcZq/rOg2mS04B81oSstMdhjHpUFI0svbp1m9eoZudRacY+38o0bIUO77yC7lhNPOms4mmFj4J2LI61tj2ybWDVg5n72cbqcOuBD441tH4JZ5dY4bqoX41Uu2qtlHYpVu1ttYWx7s2y9Oe791TqdF9BCyG0hlE/bOwLQ5hsJr1A32vs7PCVi9YCuQAGAogJTLthMXZuATddNBTXhc7N5SKCe/v2HOWlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RCDSlyNym4u1PfjKues09Ory/t7bYxdGytQ08RhdEiM=;
 b=lCt19rfEW5acFxTm+2kjpivEDs97BV9RCekrnh8nrSzDM4F+y8zPJFjVXzmcSeF4HFoOY7Wfg54gbMPmTbKqOk7bi9epC3DvVi//ARAXnwqIdICKcVNKwePyuazsm3BEFhEOw9I0cj8ag00cm2urCLkhhs0sRNYnEBWsBbr1EHRng7R7xQ7nc3Quo3056FRrwm6YC6hJW5LnjDmb1x9BzOb57soBnFT3se9K/UelgmUzWhnFLXj0jGkYGd2VhwCIutvg2v6Bwu7wKo53IhgWZeiJrpsglg1HodRQfWASrT/mSN0S5F4pLnpNEILR5drG6USqkQwVI/VUY/IBx/+PDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by BL4PR11MB8799.namprd11.prod.outlook.com (2603:10b6:208:5aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Fri, 24 Apr
 2026 07:49:57 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%6]) with mapi id 15.20.9846.019; Fri, 24 Apr 2026
 07:49:56 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: Wei Yang <richard.weiyang@gmail.com>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Hu, Yong" <yong.hu@intel.com>, "Zou, Nanhai" <nanhai.zou@intel.com>, "Tim
 Chen" <tim.c.chen@linux.intel.com>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
	"Chen, Yu C" <yu.c.chen@intel.com>, "Deng, Pan" <pan.deng@intel.com>, "Li,
 Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 1/2] mm: move overlap memory map init check to
 memmap_init()
Thread-Topic: [PATCH v4 1/2] mm: move overlap memory map init check to
 memmap_init()
Thread-Index: AQHc0Y4h66ZJRC45aEeUdFXXLFyV9bXqRsUAgAAl0ACAAFy7IIACoHyAgABrFpA=
Date: Fri, 24 Apr 2026 07:49:56 +0000
Message-ID: <MW4PR11MB6936DBFB6B75C2B0F19331A5A32B2@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260421125508.2317429-1-yuan1.liu@intel.com>
 <20260421125508.2317429-2-yuan1.liu@intel.com>
 <20260422011126.thu67icgj5qfbecj@master>
 <20260422032646.vtkdoliudlxgtpv3@master>
 <MW4PR11MB6936682EB5EF1993DE7BDAEEA32D2@MW4PR11MB6936.namprd11.prod.outlook.com>
 <20260424010535.54sh5z6nkqt3j6du@master>
In-Reply-To: <20260424010535.54sh5z6nkqt3j6du@master>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|BL4PR11MB8799:EE_
x-ms-office365-filtering-correlation-id: b794d163-adac-4f62-0602-08dea1d6141e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021|56012099003|18002099003|22082099003;
x-microsoft-antispam-message-info: +EYN+TwUguSLHpcjWYHLS1AdJ3htPTFut7YMjwup8P71I/zNgtSqDxhUG+z8wg9Z/xwMeN5OPF5TUYutG3VbOXBisnaQo5GLACG+ba/l9XpdiYkXZud4xfYL2ChcD2QHLy42cN8k4ZbZ2wT/68XyNjf22FcvFfLgDCRNk9r/lWoOTp7mL7vRRgEQOjjeptQHsWBiwxxQnUMalRZjF3nC/H3tUv7p4nrXXspZzjgG2cC+L7AAyxlpHGvJaLr5sTbSSwIAsjl2maYK3UgSZxgDZ4BLY5CVkBQ6Lbb7sFmRjwsEhZGeKPJ3sfZzSfPOe5aCkn1pOWrCnniIcMjnpTJBBMTI0bwL+d6o28Zze0yUnx049zF6IJJzJx+FPf/9f6O4KLlMtgTfJnZVKAEHj7mZ4GGgn0/SD7BQOmUwMd0+5tHOB0aFWpMhpqm3mY4FvbR6DXixg0Da/x1jv4KaivmoUThB9vPKcYc6hY1+IUbgx1HpPVKtCsXvrF/74BQVTw0UfISwR0ZF7Aac2Wn3wRnQSUWkyXRGaohMAI1B4teoRlhA6X0+wwjvdcJ2WPc0J+FEWUNsDSYWalpF6QrDR1xVzXMqDZmO70OtFtgkhcz+339f4riIv/3ercH4jSxDvNTrMa0Ws2TmS8yVK21M5FaYVa9Utw97NH6CslJM/1fsQPh5J7PWuqELlUXf26tXaQJXS9Vo5Or8QCyqGWTk8OuC1oXEUMu6ZXjBLLD2AfJ4qURCqj4hUVXMgtoKBbRMcM/rht7PZwMjdUilMmNCfHX+qtAqsoKkxvMv8D8tC0WEkUI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7gZZ0TkCSzOwV37WU4L9x+GGAoYAqLVgsUdB5SeMNQXJ/l5cTcbEOoQUarXW?=
 =?us-ascii?Q?+P1fFv2FABvq2wICDFgdWKbf5Kiprarj9F96o0Ish9y53s/K3ZzYktnRz47g?=
 =?us-ascii?Q?JNCnbYh4bcjozjPFC6pMoue5jle0ZwYkDmeS3yS83FWFEPlYUfu6vCCbZr8i?=
 =?us-ascii?Q?8TovC5c2KBZmXcuvi9GkORHTcIQlu3fl5bhZQa/ktZo5WvFAZA5XPa6+X+gL?=
 =?us-ascii?Q?QMAbbwGRBtHGYuDNqDpYeiqyG4F6p6ZgZpAFiTNnSHbRiU6b1Iej/fD/eFxe?=
 =?us-ascii?Q?bCzuP3d4VpSQltKCzgPWSSRotNbnscCnntncwYgAHcesAM0fp8moswm39lMl?=
 =?us-ascii?Q?QcvMGoG73mo9eYoFeE8CSHxwJZrAw8DWx2lDr67oDTqDqxGULO9x65SFipKL?=
 =?us-ascii?Q?0r6eU1zkjMg4Fms6FkmNmRoFiOZKZ/sMzYrj8zJag4t8Z8i1fS2spVIUPHCN?=
 =?us-ascii?Q?6wy+UJlrUbojx6BqG16ocODkic5+I7q0IwWeY3Ngt1AvTBvxktljIbdn+aCn?=
 =?us-ascii?Q?AI1PiiFsanxqwQSnXOe7CGSzJCYp6FPrerqkD2QbrzCLOHSpNm9K4twsxARG?=
 =?us-ascii?Q?zrh3vwd3w746awpPxWTbo4HXjLm2uigFHnJEiglcmY94xx4aaTKggFhVjkMg?=
 =?us-ascii?Q?vvcEp/HRDBXR9OPOdPiTr4JZZghtTBiaGahRoJ8htL+RaSrlM91rBtIOjx4/?=
 =?us-ascii?Q?yZvNw+vaA5z62ovKi2NeKkKVftCOJsUTIk8yEorernfkVkOgbNwj8C34KXsJ?=
 =?us-ascii?Q?dxLbnOnbIqjfe9YPJV5FFoalyjivkh7MFKas/7O+MxBzHIn9qgJ3Srr18WNS?=
 =?us-ascii?Q?gDhx5GsIg2CYslBq+VwVxAxfKmDdDum+zrFY3naRzeX9RVS2iGd+03P76DwY?=
 =?us-ascii?Q?x1BIWL6KTPZUKyNI9IbJkzAihjBlC/xE3yp39aQnp2BHqUGgRlB8yGfuVN82?=
 =?us-ascii?Q?BfEf4lx5XDv04i9BtgJJrEAqTC+ARn3EJ97q4MPIsv8O2/ONGTLFg3gegeXs?=
 =?us-ascii?Q?rIR65O5QlSqZYA+we5oFbPil655xkhtBkCj5ejndQgGMhkHY071ZtR9uR/oX?=
 =?us-ascii?Q?+onchwTsIwsoVOBj86nr/6L3yZLe+o/4snNTlHom9aVsQb5u++lMMMU/EYPk?=
 =?us-ascii?Q?sT3yfv0Th10lsJBx/EyIu3QKk+aK+GcbHS5KqpbJ7swsim4IHXkj7AsRV/ys?=
 =?us-ascii?Q?m0kUPwdG041kWSawO6UqF3XVGdDusfZ0F7BiUjyAcVVHwNTyJdyc+lAosodi?=
 =?us-ascii?Q?2PuojwObHYpCBXorhNeFPIVu8Zr004ohXKi7AQWlJT6WrMAsNEkQHA3ojPSD?=
 =?us-ascii?Q?1Mu+q1U+begwgijJace/x1tXCWTEaTgM2H1Ly+mH71vZHz0JkumqOgWfHThM?=
 =?us-ascii?Q?FrNl3JVbXdaEUeRCQ+Z9LCzuOkI+3XZzNSn8iVSVqX2MvfxLwO1dYSTV0rLT?=
 =?us-ascii?Q?w+lya8RDid7jRPKZz5vpqMLCD2gu6PHn/1V/5yZ0kcYi/HIV3jMSHTaQJUJ5?=
 =?us-ascii?Q?9faM7EzQTFcqnW9HvMCpFH8B2sQ777K52Vkw5yOvL0Ilno1CbTq33rSgGSOd?=
 =?us-ascii?Q?QQY0Cyh6eLp9UMAp1FwJaZUFr0Fu2CQOCOGg597hLkc23609TI8zbdA6MSXF?=
 =?us-ascii?Q?uZVauHVE3Z3xYeC11HxsaVhrmIa6R5Kkhe1YB2kqcHlG5HPbAf/TEdmBLRAG?=
 =?us-ascii?Q?TEsCm2qNS3FEm+vRIaZds4wGPunT19GMaENqP0O/htGSIT2u?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: FKVHhis80EZLc2K90c0pPcNb8iUqQNZGVsS211XtguLtmQlhrAmt7pZcdgkN/34FUfWU1iBHNB7X7uZebhAvTGuanLkTLIk2VYXrhdz7Yub6e5oq61TvpaoVFRahdND3yCwW/KChDRovn2qYWj04C/kcsWcnQLmmuEnAv4aNvJbsox00m6BUyC+BX7+eQkFRxnxtHZ4oelkLL66jGf1AgVnhXdJ2O0Kum8h7m03ecWn0V7NwoMPNyAuLFoFhkcSnvPemIM1+RHXUOW8HKkI+/LjhMatHGODePB/tzeG8P7w6GeDj01lKPmedEplqsfpC9meUZvPKDgTgIsYJXKUurw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b794d163-adac-4f62-0602-08dea1d6141e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Apr 2026 07:49:56.5236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b8UyTAAjoSB6NWrlJ+mqFrsLZKTHOZ/l3Rqd2l99Mq4sxuw3sGZQP/MGPEmhSPdNJmX8rHM9hXBN0gHCvxAPgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8799
X-OriginatorOrg: intel.com
X-Stat-Signature: yskm5411r9siooe3ayaxmabf95amk8re
X-Rspamd-Queue-Id: 70DA240002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1777017021-793477
X-HE-Meta: U2FsdGVkX1/4kgO2bF4+OSdWrM7aL+M3k69y8XqG4Ol1MQ6bi9nfOK+Q/T7BQh+cTqcaBMl50OY8lUIR78Cx2G1zAFQHlQyF6W1JC74dn0B8g0nRlHtIQ5EVFd+zRxSLErxlzaYvV0sZC/mLP18+M4mcG8I7rqbYhN3G8wdKtnsAwa5ZLZ/XpFt3t7AQqNKRhleD+f+n2AyZ/43ANoxlcSSlRSecEcxP//Ef3sH+uPZ6MclNz7BfxF2xvUnOAkoEDnjjxiJSgFYAUaDg3TuUBHamGf3gxk+HsUGd8stmiGAu6hwfziY0AmAYxoI0TWOJuHNn3WYsVAd/uwyE4W3/P22Tzw63rToMKUGC2j5Kl34W3C0+8Z3P5o7ibx/C7fJTy3dUUROPP6HuvV9HzVGFYjtTieq3fhvtuInO5w0bKAXvJeoH5ZYxX5vlw9d8oOWN8+tfk+0yzi2gyKrZYV/r3ZuKypKOaX75DV+wl/kDVwkKKELVx8MsN7izc8/P/cjWBhbwR2YeUJ5T5Lb1hf5C3SyEyb9dlnZHHkAUe1w4hyjdFyMmOVyNl3dy8jQjcuAEY66ohdZ87V2DxPYGUzsvujfKblV8GYnrZ7FiMbZ3SRB8Fuv6Q5haRGU0oYZXEj5Ug1rXFJQQ8rxYmIxMR8wltylilr44ie1GOrwfGBnc3PIgUPpMYVTFu4oxpnQCMn7y5fgoctChLvQEyd6tETU2VQcoToOp/6U3N4EZfguQzA/6eEP/e4bCLj/kNLngGNa0wu7cfnzMJS+sdtHuv7LQ6uT33WT24TmXSmO8iYlcaS8l9sSktf/pzIoHL7idIzu7w2Fuh4AKGF0ez76YPxFDNJRIVvtqe3g+5ZWksdjzecyR7U1y1xv4PxwzSU9BiAFe7cYn78WZ3JYT0nEhM+xRG4VtaSKdQ83d91McIp7rf6TT2uZrJ/kKMxxICoQBiwrQ2p9BfHWN6QYfJiP5c3u
 Ilcg3HtT
 uv/f6felDAG9RnBOlvhML36fyNy7d1oAU/bR2Q3dv8eONFrND/Vo+160Va/e63uNV5Nge0Rd5+yK2CW3eRoNgxG10s/tHmdZnyYabw/dYDdbzGd1+hkgzcjizyYL4MQrdNxv4WG2iafkX9hsQfiR8XraIN24qa9P+jPYbZs/CpeEoYhY3tKhz7/IVF/HYNteevP7orzbi2jfDkk/SoznkyZOsn5Gh3hF0zpd7wcZmDYy0VkfXpuk6kLMriixlKzBoj16ydJvdD7m9XkLJ7v2j4oW41umN55BO0aeVBvxGn7pCuoK7j9Ec9/keGh5G0b5TQHvL/ogz214NKQPyldcOF0ZwW35Jc/ixuFuEFvYnQwA3659Rb7hSP27eszMT6PcDxwP0D7zO755YioGSmaBqavyaEqsNYzaMITUOGtyhY8w33OqE7uQ3usLyGZ7yORahrsuBFtDLRLgHxFGwII5tFR/t58fyPmS2dAa0y7Vl9n8/UqJ7MIHAmr8hhI2EPLiihMBYCIwLSStrm5vkJzKxAndrVMmX0TnCpbUdQHuZtHdzOCrLNo6YvlLM2vkaVwCwZWY2pe+NWZjDsReV+rAvrwnRD83GVNeL2KY2Jf5Z6JEL2aEvAbRLD2z2wggIT757BtHObk6Px3+KOO5ZPGPP0bmv4WnKmClNei0z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]
> >> >>diff --git a/mm/mm_init.c b/mm/mm_init.c
> >> >>index df34797691bd..2b5233060504 100644
> >> >>--- a/mm/mm_init.c
> >> >>+++ b/mm/mm_init.c
> >> >>@@ -797,28 +797,6 @@ void __meminit
> reserve_bootmem_region(phys_addr_t
> >> start,
> >> >> 	}
> >> >> }
> >> >>
> >> >>-/* If zone is ZONE_MOVABLE but memory is mirrored, it is an
> overlapped
> >> init */
> >> >>-static bool __meminit
> >> >>-overlap_memmap_init(unsigned long zone, unsigned long *pfn)
> >> >>-{
> >> >>-	static struct memblock_region *r;
> >> >>-
> >> >>-	if (mirrored_kernelcore && zone =3D=3D ZONE_MOVABLE) {
> >> >>-		if (!r || *pfn >=3D memblock_region_memory_end_pfn(r)) {
> >> >>-			for_each_mem_region(r) {
> >> >>-				if (*pfn <
> memblock_region_memory_end_pfn(r))
> >> >>-					break;
> >> >>-			}
> >> >>-		}
> >> >>-		if (*pfn >=3D memblock_region_memory_base_pfn(r) &&
> >> >>-		    memblock_is_mirror(r)) {
> >> >>-			*pfn =3D memblock_region_memory_end_pfn(r);
> >> >>-			return true;
> >> >>-		}
> >> >>-	}
> >> >>-	return false;
> >> >>-}
> >> >>-
> >> >> /*
> >> >>  * Only struct pages that correspond to ranges defined by
> >> memblock.memory
> >> >>  * are zeroed and initialized by going through __init_single_page()
> >> during
> >> >>@@ -905,8 +883,6 @@ void __meminit memmap_init_range(unsigned long
> size,
> >> int nid, unsigned long zone
> >> >> 		 * function.  They do not exist on hotplugged memory.
> >> >> 		 */
> >> >> 		if (context =3D=3D MEMINIT_EARLY) {
> >> >>-			if (overlap_memmap_init(zone, &pfn))
> >> >>-				continue;
> >> >> 			if (defer_init(nid, pfn, zone_end_pfn)) {
> >> >> 				deferred_struct_pages =3D true;
> >> >> 				break;
> >> >>@@ -971,6 +947,7 @@ static void __init memmap_init(void)
> >> >>
> >> >> 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn,
> &nid)
> >> {
> >> >> 		struct pglist_data *node =3D NODE_DATA(nid);
> >> >>+		struct memblock_region *r =3D &memblock.memory.regions[i];
> >> >>
> >> >> 		for (j =3D 0; j < MAX_NR_ZONES; j++) {
> >> >> 			struct zone *zone =3D node->node_zones + j;
> >> >>@@ -978,6 +955,18 @@ static void __init memmap_init(void)
> >> >> 			if (!populated_zone(zone))
> >> >> 				continue;
> >> >>
> >> >>+			if (mirrored_kernelcore) {
> >> >>+				const bool is_mirror =3D
> memblock_is_mirror(r);
> >> >>+				const bool is_movable_zone =3D (j =3D=3D
> ZONE_MOVABLE);
> >> >>+
> >> >>+				if (is_mirror && is_movable_zone)
> >> >>+					continue;
> >> >>+
> >> >>+				if (!is_mirror && !is_movable_zone &&
> >> >>+				    start_pfn >=3D zone_movable_pfn[nid])
> >> >>+					continue;
> >> >
> >> >IIUC, when mirrored_kernelcore is set but !memblock_has_mirror() or
> >> >is_kdump_kernel(), zone_movable_pfn[nid] is kept to be 0.
> >> >
> >> >This means it will skip all memory regions.
> >> >
> >>
> >> Did some tests. When mirrored_kernelcore && !memblock_has_mirror(),
> which
> >> means there is no is_mirror memblock. This will leave
> >> zone_movable_pfn[nid] 0.
> >>
> >> So for all memory regions, the above logic will skip them.
> >>
> >> Adjust the code as below, my local test could pass and kernel bootup a=
s
> >> expected.
> >>
> >> From 6351ac79a17edbfd830510fba2959ddc47b17258 Mon Sep 17 00:00:00 2001
> >> From: Wei Yang <richard.weiyang@gmail.com>
> >> Date: Wed, 22 Apr 2026 09:13:24 +0800
> >> Subject: [PATCH] skip overlap region higher level
> >>
> >> ---
> >>  mm/mm_init.c | 29 ++++++++++++++++++++++-------
> >>  1 file changed, 22 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/mm/mm_init.c b/mm/mm_init.c
> >> index 79f93f2a90cf..7a85ba58e87f 100644
> >> --- a/mm/mm_init.c
> >> +++ b/mm/mm_init.c
> >> @@ -916,8 +916,8 @@ void __meminit memmap_init_range(unsigned long
> size,
> >> int nid, unsigned long zone
> >>  		 * function.  They do not exist on hotplugged memory.
> >>  		 */
> >>  		if (context =3D=3D MEMINIT_EARLY) {
> >> -			if (overlap_memmap_init(zone, &pfn))
> >> -				continue;
> >> +			// if (overlap_memmap_init(zone, &pfn))
> >> +			// 	continue;
> >>  			if (defer_init(nid, pfn, zone_end_pfn)) {
> >>  				deferred_struct_pages =3D true;
> >>  				break;
> >> @@ -974,6 +974,17 @@ static void __init memmap_init_zone_range(struct
> zone
> >> *zone,
> >>  	*hole_pfn =3D end_pfn;
> >>  }
> >>
> >> +static bool __init region_overlapped(struct memblock_region *rgn,
> >> unsigned long zone_type)
> >> +{
> >> +	if (zone_type =3D=3D ZONE_MOVABLE && memblock_is_mirror(rgn))
> >> +		return true;
> >> +
> >> +	if (zone_type =3D=3D ZONE_NORMAL && !memblock_is_mirror(rgn))
> >> +		return true;
> >> +
> >> +	return false;
> >> +}
> >> +
> >>  static void __init memmap_init(void)
> >>  {
> >>  	unsigned long start_pfn, end_pfn;
> >> @@ -985,10 +996,15 @@ static void __init memmap_init(void)
> >>
> >>  		for (j =3D 0; j < MAX_NR_ZONES; j++) {
> >>  			struct zone *zone =3D node->node_zones + j;
> >> +			struct memblock_region *r =3D &memblock.memory.regions[i];
> >>
> >>  			if (!populated_zone(zone))
> >>  				continue;
> >>
> >> +			if (mirrored_kernelcore && zone_movable_pfn[nid] &&
> >> +			    region_overlapped(r, j))
> >> +				continue;
> >> +
> >>  			memmap_init_zone_range(zone, start_pfn, end_pfn,
> >>  					       &hole_pfn);
> >>  			zone_id =3D j;
> >> @@ -1257,13 +1273,12 @@ static unsigned long __init
> >> zone_absent_pages_in_node(int nid,
> >>  			end_pfn =3D clamp(memblock_region_memory_end_pfn(r),
> >>  					zone_start_pfn, zone_end_pfn);
> >>
> >> -			if (zone_type =3D=3D ZONE_MOVABLE &&
> >> -			    memblock_is_mirror(r))
> >> -				nr_absent +=3D end_pfn - start_pfn;
> >> +			if (start_pfn =3D=3D end_pfn)
> >> +				continue;
> >>
> >> -			if (zone_type =3D=3D ZONE_NORMAL &&
> >> -			    !memblock_is_mirror(r))
> >> +			if (region_overlapped(r, zone_type))
> >>  				nr_absent +=3D end_pfn - start_pfn;
> >> +
> >>  		}
> >>  	}
> >
> >Hi Wei Yang
> >
> >I ran some tests based on this patch and didn't observe any issues.
> >Thanks for the patch.
> >
>=20
> You are welcome.
>=20
> Well, maybe we need to do something more. Let me explain what I see.
>=20
> My assumption of the position of mirror memory is:
>=20
>    When there is mirror memory in system, all memory in low zone should b=
e
>    mirror memory. Non-Mirror memory only could be in the range of
> ZONE_NORMAL.
>=20
>    And in the range of ZONE_NORMAL
>=20
>      * there could be no mirror memory
>      * the mirror memory could be at the head or middle in ZONE_NORMAL
>=20
> Take my test machine as an example,
>=20
>     MEMBLOCK configuration:
>      memory size =3D 0x000000017ff7dc00 reserved size =3D 0x0000000005a9a=
9c2
>      memory.cnt  =3D 0x3
>      memory[0x0]     [0x0000000000001000-0x000000000009efff],
> 0x000000000009e000 bytes on node 0 flags: 0x0
>      memory[0x1]     [0x0000000000100000-0x00000000bffdefff],
> 0x00000000bfedf000 bytes on node 0 flags: 0x0
>      memory[0x2]     [0x0000000100000000-0x00000001bfffffff],
> 0x00000000c0000000 bytes on node 1 flags: 0x0
>=20
> The first two memblock region span ZONE_DMA and ZONE_DMA32. The third one
> span
> ZONE_NORMAL.(When kernelcore is not specified).
>=20
> So I did test with below code change:
>=20
> @@ -147,6 +148,14 @@ static int __init numa_register_nodes(void)
>         }
>=20
>         /* Dump memblock with node info and return. */
> +
> +       /* Mark mirror by hand */
> +       for_each_mem_region(r) {
> +               if (i++ < 2)
> +                       memblock_mark_mirror(r->base, r->size);
> +       }
> +
>=20
> This mark the first two memblock region as mirror. And then use
>=20
>         memblock_mark_mirror(0x100000000, 0x40000000);
> or
>         memblock_mark_mirror(0x140000000, 0x40000000);
>=20
> To mark the head 1G or second 1G as mirror in the 3rd memblock region to
> mimic
> the overlap case.
>=20
> So I manually create 3 cases:
>=20
> A: all ZONE_NORMAL is non-mirror
>   memory[0x0]     [0x0000000000001000-0x000000000009efff], node 0 flags:
> 0x2 mirror
>   memory[0x1]     [0x0000000000100000-0x00000000bffdefff], node 0 flags:
> 0x2 mirror
>   memory[0x2]     [0x0000000100000000-0x00000001bfffffff], node 1 flags:
> 0x0 non-mirror
>=20
> B: head 1G of ZONE_NORMAL is mirror
>   memory[0x0]     [0x0000000000001000-0x000000000009efff], node 0 flags:
> 0x2 mirror
>   memory[0x1]     [0x0000000000100000-0x00000000bffdefff], node 0 flags:
> 0x2 mirror
>   memory[0x2]     [0x0000000100000000-0x000000013fffffff], node 1 flags:
> 0x2 mirror
>   memory[0x3]     [0x0000000140000000-0x00000001bfffffff], node 1 flags:
> 0x0 non-mirror
>=20
> C: second 1G of ZONE_NORMAL is mirror
>   memory[0x0]     [0x0000000000001000-0x000000000009efff], node 0 flags:
> 0x2 mirror
>   memory[0x1]     [0x0000000000100000-0x00000000bffdefff], node 0 flags:
> 0x2 mirror
>   memory[0x2]     [0x0000000100000000-0x000000013fffffff], node 1 flags:
> 0x0 non-mirror
>   memory[0x3]     [0x0000000140000000-0x000000017fffffff], node 1 flags:
> 0x2 mirror
>   memory[0x4]     [0x0000000180000000-0x00000001bfffffff], node 1 flags:
> 0x0 non-mirror
>=20
> The change I proposed works fine for A/B, but for C pages in
> [0x140000000-0x17fffffff] is miss placed.
>=20
>     Node 1, zone  Normal
>             spanned  0
>             present  0           <-- missing
>             managed  0
>     Node 1, zone  Movable
>             spanned  786432
>             present  524288
>             managed  773552      <-- but put in here

Thanks for the detailed description. I can reproduce the same issue in a VM=
.

I'm not sure whether the case C occurs in real-world that the overlap happe=
ns at=20
the beginning of ZONE_NORMAL and this issue is also present in v7.0-rc4 w/o=
 this=20
patch-set.

> The reason is in adjust_zone_range_for_zone_movable(), ZONE_NORMAL is
> truncated, since zone_movable_pfn[nid] equals to ZONE_NORMAL's start. So
> this
> range is skipped and then by "accident" it is initialized by
> init_unavailable_range() to ZONE_MOVABLE. And then it is freed to
> ZONE_MOVABLE
> in __free_pages_core().
>=20
> After removing this truncation, the zone stats looks good.
>=20
> Node 1, zone   Normal
>         spanned  786432
>         present  262144
>         managed  249310
> Node 1, zone  Movable
>         spanned  786432
>         present  524288
>         managed  517223
>=20
> @@ -1204,10 +1204,7 @@ static void __init
> adjust_zone_range_for_zone_movable(int nid,
>                         *zone_start_pfn < zone_movable_pfn[nid] &&
>                         *zone_end_pfn > zone_movable_pfn[nid]) {
>                         *zone_end_pfn =3D zone_movable_pfn[nid];
> -
> -               /* Check if this whole range is within ZONE_MOVABLE */
> -               } else if (*zone_start_pfn >=3D zone_movable_pfn[nid])
> -                       *zone_start_pfn =3D *zone_end_pfn;
> +               }
>         }
>  }

Yes, this change can address the issue for case C.
We also need to check mirrored_kernelcore here, I think the issue only occu=
rs=20
in the overlap happens.

> All above analysis is based on my assumption on possible mirror memory
> position in system. If my assumption of mirror memory is not true, this
> may
> not be true.

Yes, I understand your point. If there are no further comments, I will incl=
ude=20
your suggestions in the next version for further review by the community.=20

If you have any further suggestions, please feel free to let me know.

> --
> Wei Yang
> Help you, Help me

