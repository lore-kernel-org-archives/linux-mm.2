Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3A4DCCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 06:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2864E8E000A; Thu, 16 Oct 2025 02:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236E18E0002; Thu, 16 Oct 2025 02:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE9C8E000A; Thu, 16 Oct 2025 02:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F0AE38E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 02:03:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B29BC015C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:03:16 +0000 (UTC)
X-FDA: 84002934792.07.F899054
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf27.hostedemail.com (Postfix) with ESMTP id 105304000A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:03:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CWnzVvgt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760594593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Y/m8h171IDB2kFNSydu7A2emxxaJARgFsZS0HwH3Lv8=;
	b=oTVHttAK936TjVzlj1sbwunwAFB38HmiBKfawQtOAZWZNPwNa5vGP/OJouSWLh5n9yo/1S
	9QVZrXUnonN4KzW9PPL/3TLkaNdHE4/tn4ywdIFicj7PAq/AI1MDZ8WbuThnxdRgtPLFeR
	c2ivsSWamyWJzz+zP8UA79Jcd2e/kTs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760594593; a=rsa-sha256;
	cv=fail;
	b=e9Ay1DQq6VyPV21LljoEFJpNuXc68IgVqmNka1cpeL4DYtxwr9dkuyHBfRjnWpxEoPkva7
	DeJmI4xbbKyHEUNCXVkF6W86tYUkj2kSEfcXqCk+GEvTecSyn4+29AS9X6wP+awK3Pn9p1
	zK8t04VBsJBjofCjvIwnGNGmJBSzclA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CWnzVvgt;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760594592; x=1792130592;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=NOSbNkURv39HAEtLtEFxzihts9dKpAVlQJjTVGLEaHE=;
  b=CWnzVvgtYtBjQpp/Ndcl1vxeVSvioAI1mpWXr3oq99cHQ/r+BV/flxEk
   wZzTIM1DfoE0fUKdAUORIKGErqQy+hOl5JNj5UyqqOVkT9t48qo0a/mww
   dZYAyCDXYJmfhtBwhsSxJzbWC+07A4jaJWtz8W2GLgTu3m0RwWn2QaV18
   tVIYMZKytudrbwnKuFtlQ8oz7HRQ6JZuAjIUF97wlZ9A0S0PuGHPtNjHm
   bwfGcimywgRT3sIRNeg0ILykif8J/UrHTyrVp2afcKMMpLea3M66duScj
   ANzzMmyfrBXMaWsn41Fj9yi8UaTZ7F/vVzQvoJfQQrkUhqn4E9SxSyOqy
   g==;
X-CSE-ConnectionGUID: bIUqdi+8TbSkU8cmKCli+w==
X-CSE-MsgGUID: 3USu1ndGRX+7K68uTby23g==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="61985025"
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="61985025"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 23:03:11 -0700
X-CSE-ConnectionGUID: hEXezdn4RW+11tez+aCgGw==
X-CSE-MsgGUID: NT6va9STSZ6lFM5Taj7oiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="182305682"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 23:03:10 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 15 Oct 2025 23:03:09 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 15 Oct 2025 23:03:09 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.8) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 15 Oct 2025 23:03:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F2RdvmndUkcswpur6fCzvKadTABLQ1YjPjsqNMn2zdVvVo46sApgeSpPaDkH8N1lYq6lXSdfZ7TpUSR53Oormnbu30vG3PdULqFgO+i9OLloxmapHX3L86LbL4MTNxokb/ZLm9Om3RqX0Tn6lMAGz0QX/3o/j+Ufs6EwLSXYRiSnIHJ24dc7GubJI7B8mn41fdN4ptGFIoZaR2+/h30sSbRAO0ZCmKOR82pkYRJ1C6vRjG5SZKgax6nTz6IPwBGtCZ9yXZrLNy7AAHbqFr6g74tilp7yGWdB0+P35ZjGag4XjAw4DZhP6bjZRVaJwWW/ESVYdWYWSQ1nr6/19xM3mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y/m8h171IDB2kFNSydu7A2emxxaJARgFsZS0HwH3Lv8=;
 b=CrRqadNCleyRyC42OlM+79/A0DEkbHLbsYdx1FPsdaFMEo1IKYjbJ5gR0x0f4A0qulPv3O3Q/KTsowP6oXn3Tv7ntQMKM6G9OLv/+qtiRXpGptK7I0YPVJdNAOxlx22RLHDjlaWJewkjidoHCLVbvUJybnUTQ5jNPjqFwjQGE4lQCw6AW1CJca0UOuslC9Z5VdrWqLr+cbtQmJMK3VOeG5tPXpxSZWEE1a57zDF/Hviy4vQxg2r38PileZljl/p55e8BschLxFLoVWm7FhbyQnbV/EFI4he9CiTp1bTw+SYQ9g1pm9G5rXJzsnnfjGheom5gNVLOaC4G/ryE31hx2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by IA0PR11MB7752.namprd11.prod.outlook.com (2603:10b6:208:442::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Thu, 16 Oct
 2025 06:03:01 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9228.010; Thu, 16 Oct 2025
 06:03:01 +0000
Date: Thu, 16 Oct 2025 14:02:52 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [vbabka:b4/sheaves-for-all] [slab]  16e7d1ea82:
 BUG:kernel_NULL_pointer_dereference,address
Message-ID: <202510161341.61ccb50f-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: KUZPR01CA0015.apcprd01.prod.exchangelabs.com
 (2603:1096:d10:26::9) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|IA0PR11MB7752:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cb965f7-2dfa-4fdc-14ef-08de0c79a9e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?G2I7LPE0BAPhxYmXiFtR4z3mXZGHq65eu7ZgNLsCbOmJeFFEYSVGTQDXEShq?=
 =?us-ascii?Q?Ebb8pRfs2Wq5mDDfKuxHeZuElFc2zfAHJMn8cZr/Vc0jE9mNrvFSw9Sst3EG?=
 =?us-ascii?Q?Nxy1VdPzWIdYPIxWdO2TGlA2ciEeCzGwdRuSCBmBxjoWu3gfzb8i1CucBDxa?=
 =?us-ascii?Q?Aw4OJSmoTZeD2hdnnbTE6YKm9/2VntD4ArkSCFetD4AdT/r1c0T2ddmUIrF2?=
 =?us-ascii?Q?V/7oOMfeN3crzvLEzU+8BjSkFHglNyZfk3d/oS5XPYsDQWJSkYzvPO0abBZd?=
 =?us-ascii?Q?hpfOJQycxxEYmS9y0/96cff0FMLDGrl9qWqlRmy1nEmfsDcGmhSqFsNo0hoP?=
 =?us-ascii?Q?8ULXAgT5Ljz4J57+qiPBr770jVkN6Ue18zMP9+8xg7liirolUDxcbJSQSpxh?=
 =?us-ascii?Q?KCOK7ilWo6UyxTaYRiktszLjT+XO580A9l6I6p/IDeg8dXSkqsP3y/ghKCb2?=
 =?us-ascii?Q?Qx67VQxzKChezO8Y7r6qce+erLfrAxjo7xMoaoWD37qCty6Ab/3tiwztL/Kk?=
 =?us-ascii?Q?lrqiTsetU+cAhyjp2YHijZ+QaEI5xlIU7cL/Txhb8GCiNMjVKmVJQBdcAnxk?=
 =?us-ascii?Q?tdBl4QYZfIMuFQ5Ww5lC+zCqgx+TDXmXw9Tjuo2Bk1JA8NMAiRPolDmPqNiM?=
 =?us-ascii?Q?BHYm/X2N+b0Nv3K9FAgIJJH+MuMTGNLw5tbs8eZBsxzep8eDx0y2aOGFilpk?=
 =?us-ascii?Q?ihPgkS09Jeo+JGFrAgj0YYMzc3B58G7U6X68fE10ox7eDtTr3Uj2rgKH/nXF?=
 =?us-ascii?Q?ccKZyT5JZQ91Xf2SuwGL30hlTvdEiauLmIlUxMtSGvfzmOybrYZSaqTB5qsf?=
 =?us-ascii?Q?e9yT83yG3ISbESMvHXd3QUVisqHSMM8hs+FyUBsM3ECqYVx89/QKm2VcjxgV?=
 =?us-ascii?Q?X2+ZNI+7UxOd2ki3Nxzv1Rle75TmQC5kzmzYSgjaKQ4+QgDaJvwmRCu8HItk?=
 =?us-ascii?Q?rbPNQPw/6qbmpyWDa4ITNpXHdR/3U1GSfuAZjSpKVZ7FmEdNnW5brdRXNn5h?=
 =?us-ascii?Q?LYfhVlCSX8dAL2n//Qgm6ID4saQGFhVewKXn0UVWl1Gl6rx01sq1RpDPA9Ix?=
 =?us-ascii?Q?YeZJIJqa+6ytaKeRsXDn2hM8//lBRAIl0hzCFMwR2I/AsJ8r2HEd5fStLK7g?=
 =?us-ascii?Q?j7ory9PGuTqSEePVfN90s+jPzVdrcxh+rWZpOZaWBQDM4oj8DG3dFaG57nlo?=
 =?us-ascii?Q?BRvvg16pyOjBImepmHrCF2RheI+qLpOQt2mu/opvZJoe5G5rjSM5MvBR8Wpd?=
 =?us-ascii?Q?7SFTzY1YXLETVekiy9/uEMfKSbu67yVy67w3X7mglD/qmvBsplPd07itll/d?=
 =?us-ascii?Q?muVHm/cbGzSfCSDaJVKc3FSfj8P0FYZjdxjWYZajdiDOb74iaOzGjSB9BLBP?=
 =?us-ascii?Q?YcUcjTaAU2RgFfrouaHVPSCV79ik/XoKh9rNNGRH/g2ZHYwBzQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ugBxiFhIR6WM4YHQgIDRdZG/m3uZXKAtocr+UOGp7NAyhrmuHHW4/D6zzbs6?=
 =?us-ascii?Q?42T/Uy4B3Xv4o2KT/+g8AFmiqOv1Q5vEsy9yiqlYfvWt10UkU6F1iTre4qnr?=
 =?us-ascii?Q?pa80DKXxhQe8aS3yKrZB8f6M7fQI2oJXaUBeJG9/POo3ZWJtS04vx75apuJF?=
 =?us-ascii?Q?Yr0cUG8W/yOySV+Se7v9Lfg2WlHxAS7Yc4lt3tDjoNUV9fq15rUxy2LgW6LN?=
 =?us-ascii?Q?SIiTFhPDMWQXULXf8Dotf4PaieeWfoKcGvgtQttR6pPG7dlZh+dP5IbZzqYf?=
 =?us-ascii?Q?E4W00jUlexDriVkZj0w3ampHZcBiesvoAybxwXvTdI2LtheL6abuf79N4rbt?=
 =?us-ascii?Q?zepWZrlEDkofnacHMUZv/+/bk1l2hFjwAp3p8E+4waF/0hLe8OdxFusZhPN9?=
 =?us-ascii?Q?Tp85yrj4MkGnj6Hi3AYhHjqwWn570u/uswBv62Zg0tcIUShpWsWi09sx5IDL?=
 =?us-ascii?Q?nZQAP2VUreVFTojlMBdYRTOHbGdgf9zzvNzEzGxohSMInbrzudso7IVyC0OF?=
 =?us-ascii?Q?XS5Md518WcUThpgXF/MJhQbEpW2aGbtfZwm8gS9jSyFN33Kt9ii9gUU4BZSQ?=
 =?us-ascii?Q?0dX+bhvsbW20ERCT/JJqNJUAxeApuTOA4kbYjyGhJa6yf74A8+bUCUJZbpdd?=
 =?us-ascii?Q?VjrVvpoDMx+dAoUADe3N4CURuZBjSiGSK90WMLRVh+l6FpcrphO1I+e8WePS?=
 =?us-ascii?Q?25uno4kTkXsx6ZbzWW7jLuWmbnNt8KYDOz+9sahX8AQ+Slz6GFGoQvxV7YEt?=
 =?us-ascii?Q?6tmMY5xInDME/h7aK+wN10aLjos6c/htqk6Ai91tLyMaT1pEa2hmtoLgxI+S?=
 =?us-ascii?Q?wfwnUgDDpkPHbROQES3hSaXSOdKiJ3Tk0CfXPpCfBW/VZEfj3Bs/CKsABgo6?=
 =?us-ascii?Q?ZUf+yETGgrcB1jQac2a0dd5Og1iWE8yCCRm01t3Nq4XsVaz2bnyXr5VGktAd?=
 =?us-ascii?Q?024MP/60EycfcP4fPpfw1BTm6/FumV7MvJ6cGdebSBjnerC1dakLZdYxYWFZ?=
 =?us-ascii?Q?t1U5+xCnX7K/h1BpXV7NfRvht976oet6JFPP7knwaIuwnsgBHVd18LH5/u2X?=
 =?us-ascii?Q?Ak+gknn5j+om8SqwAQifhUGnnlcnnYT9R+mLF3uAuxTPgioJfbgVnsJzye4H?=
 =?us-ascii?Q?gtT6F/1jUXrTcOvSzI4JxikBivCFAwol38uwTJqA6JrJtSyPlmZibtvFh2Wx?=
 =?us-ascii?Q?pOBOQB9/+bEnDyCDzV90EtD6JgRa8NMroIals/MCD8W3Zf+3H93OBss0Uiqk?=
 =?us-ascii?Q?UGWhrZqtl6PZYdaF6WFZmtoVCRXWwkauycoPsNEqm/KdiYdlvS8AUGN1V1Zy?=
 =?us-ascii?Q?i+UXsPsVRVLPIZGmL6rgoaD44RkX9iiNM1Uc+NHRppU8JKT0sZaEDe/C1Hi1?=
 =?us-ascii?Q?83WVxkXQ/KDp9H3BojymmSMlMRkTiCEnlLoMsLUIeXgVSv6oQAzLF/BDsotv?=
 =?us-ascii?Q?BAWh0pNCqaN851I8I/qX6wKXnXWgYXuFNT8JvY+Kg3EyOCMBvglUAgPZqOs+?=
 =?us-ascii?Q?m+nfe1KvFfyJ4l2mMnhVVJLkDUv23azIw1NpMriGgapq15PwMOb/39J9CHJD?=
 =?us-ascii?Q?D/fhCa6bjOc32MsQMvOIy1Iz++5rlynCg8POOaLiOfTdWkJ+q4TSHuOVDBQ4?=
 =?us-ascii?Q?6g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb965f7-2dfa-4fdc-14ef-08de0c79a9e8
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 06:03:01.8263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a0pClfvhGDwRFYabvAvEdpKUeqskAZ3//OCpvofVZXMFISIw2cehUPvq3AbcT6sD85R9UGLp3c8MTDZLG2DZzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7752
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam01
X-Stat-Signature: yi86fobwka46jzhtgushteebizn853mp
X-Rspam-User: 
X-Rspamd-Queue-Id: 105304000A
X-HE-Tag: 1760594591-560775
X-HE-Meta: U2FsdGVkX19JsAmo7YeK1RXovNFsKthJ3Lo1aPlDBWlK8Q0EE52xNpGzwtqrFJZraZGkNfdDSG3OO5l6GEdOolq7Ifq74fiK//hcJ7sdXtQ+5/Xs7LYM1fVaeMgDkdelTLjqmtJuEL4LF6YOB/7dUhTwT6V3s6IPK8wI1COk56Cne1B5K45RW52l7VfAGEdrPSwtCesmGbTKyG8i561U6ManJxA3xYyyHgtB4a/KgXh/RZSTOltY8ZeCmt2YHPjCCMTtwaAhunV04JPeAqcsCtfo5KKzeTKuPRL4gC/os8ha0SyqnHY6rXx4ig3pm1VsagWcxPfVMkg4pKh5srNPhGd/HF/z35Ol+POozG1Tu0f4XSITJOYD0+U7eI4MeyjmLAFgPd7z7rXwDyPcS0Oy/ORzKbRAbItzmepr7wRzxl1RQWguiKYXW6PXjdvgFObLhpTNYT8OekcHDhWa85S0I3tUMR71Ibug4D6ERQejcy+VBM8tME9xe16TN1xBVIj53MHv72hQfXwbZqAykp8+EKLuBDlhHrmXfbVFqOaC9+b7ewBjUSeZ10jzsUGlXi4Xp0UN2MgQgWbaFHfyJcT/V+c9d8jJxPeiTGnatOiaq+en2Fm+T67Q7vFsgfQsKW9ZCKlvRBwMNWH0N0/p8InpSomiVDNfsaVwj3sQ6n/apcMemtv7AQP1ZMSpSwe4rw92IS0UzY0NHSTc3PqtSwIOFSNSEkCbsiBTLh96oOfSGx4ZuRdhBN1/y5m+vjeFlDc8UWEanEopCwtsJos+BbZYyp8IPu0xETQE9/vf/7q0qvBWB8i/ml3TK8io5ApMHPb1w0AxizLZpjfdxcA+GmbKQJwGCAVmac7cemOGTe+BpDmK4ptcToNFvgeMoTx65yFXTzhy1KWk3YoLQa2wU1hVhF7FBp8vVPrrb2mSKDLtrrXcxO0dT3pkH6lRcPOIfYF06c+YOmI2jnyYBy5ZnDo
 ZJL1hqSA
 NoAtFLUSRoFrqzLmraeyt90sBH/Z9Fhk1249w0r++LfEf9LGIaVpb1FEO6rWUv9IFLNEgEIvNlZ5PxolW3cwbLBl0yPVSgcHyVAhxuBn7Dm/wx0kP/QA+MO9oDD1jilJCZbenowaBsCQwg4xgV6Bov31O3aVKePDjTW9DDEzPEmL8nqEgLD9W666Mz3aUExjdeft60L6erzfL7b+ZYHuQ+NJxLzhhwTe/ZxFYTSr611oZnELIGna7aKCeScTHoCWCgCXf8PTVe/Uh5Lpjed8xZh06fHvxtM+Q7FB9td7ygjMfxQ/1m5KzSVB9ptZ6hG5NXFZ4okGvKqvIl1s3P+S6OwMdgJYi3aFaM8EuI8t9ZvTn2oZROEAwPSuGu/K4dMZENEk7HuOtBt5RArFq8x57nUjkjVmSGBGBymqHAwbYN68wSOVOuiI64154+FjYIkYtpfQTEhLuuydPoqoh2yS80YYqg4UZWUWYZT/QyPD+aLZnxES8SBZV2svlPotXafavjx9c30Yv+Zrhtp47sr3vQHlDVNB578uYPun0SWTB4EBGm+TEKEN93vd3Q7upkr82cScTT5yhKiHMJ82slvGx5WfISHsxdpzqe6BFfK1mPPcHhNx+fyW3rq89ggeG6cERt+xsKCIcwaIbfWAQcriUgaPthA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "BUG:kernel_NULL_pointer_dereference,address" on:

commit: 16e7d1ea820782b8335c2a52052e4a0d9ca0d4b0 ("slab: add sheaves to most caches")
https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git b4/sheaves-for-all

in testcase: boot

config: x86_64-randconfig-004-20251015
compiler: clang-20
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202510161341.61ccb50f-lkp@intel.com


[    9.175176][    T0] BUG: kernel NULL pointer dereference, address: 0000000000000030
[    9.175820][    T0] #PF: supervisor read access in kernel mode
[    9.176255][    T0] #PF: error_code(0x0000) - not-present page
[    9.176689][    T0] PGD 0 P4D 0
[    9.176951][    T0] Oops: Oops: 0000 [#1] KASAN
[    9.177296][    T0] CPU: 0 UID: 0 PID: 0 Comm: swapper Tainted: G                T   6.18.0-rc1-00007-g16e7d1ea8207 #1 PREEMPT(undef)
[    9.178200][    T0] Tainted: [T]=RANDSTRUCT
[    9.178512][    T0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    9.179274][    T0] RIP: 0010:__kmalloc_noprof (mm/slub.c:5635)
[    9.179696][    T0] Code: 75 0d 8b 55 d0 48 89 df 31 f6 e8 db 01 73 02 45 89 fc 4c 8b 7d c8 4c 89 ef 48 89 de 4c 89 fa 44 89 e1 e8 d3 b4 05 00 48 89 c3 <45> 8b 45 30 0f 1f 44 00 00 e8 42 c1 bd ff 84 c0 75 0d f6 05 ae f9
All code
========
   0:	75 0d                	jne    0xf
   2:	8b 55 d0             	mov    -0x30(%rbp),%edx
   5:	48 89 df             	mov    %rbx,%rdi
   8:	31 f6                	xor    %esi,%esi
   a:	e8 db 01 73 02       	call   0x27301ea
   f:	45 89 fc             	mov    %r15d,%r12d
  12:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  16:	4c 89 ef             	mov    %r13,%rdi
  19:	48 89 de             	mov    %rbx,%rsi
  1c:	4c 89 fa             	mov    %r15,%rdx
  1f:	44 89 e1             	mov    %r12d,%ecx
  22:	e8 d3 b4 05 00       	call   0x5b4fa
  27:	48 89 c3             	mov    %rax,%rbx
  2a:*	45 8b 45 30          	mov    0x30(%r13),%r8d		<-- trapping instruction
  2e:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  33:	e8 42 c1 bd ff       	call   0xffffffffffbdc17a
  38:	84 c0                	test   %al,%al
  3a:	75 0d                	jne    0x49
  3c:	f6                   	.byte 0xf6
  3d:	05                   	.byte 0x5
  3e:	ae                   	scas   %es:(%rdi),%al
  3f:	f9                   	stc

Code starting with the faulting instruction
===========================================
   0:	45 8b 45 30          	mov    0x30(%r13),%r8d
   4:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   9:	e8 42 c1 bd ff       	call   0xffffffffffbdc150
   e:	84 c0                	test   %al,%al
  10:	75 0d                	jne    0x1f
  12:	f6                   	.byte 0xf6
  13:	05                   	.byte 0x5
  14:	ae                   	scas   %es:(%rdi),%al
  15:	f9                   	stc
[    9.181316][    T0] RSP: 0000:ffffffff84e07dd0 EFLAGS: 00010046
[    9.181986][    T0] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[    9.182866][    T0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[    9.183766][    T0] RBP: ffffffff84e07e10 R08: 0000000000000000 R09: 0000000000000000
[    9.184642][    T0] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000dc0
[    9.185509][    T0] R13: 0000000000000000 R14: 000000000000000c R15: 00000000000003e0
[    9.186381][    T0] FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
[    9.187359][    T0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    9.188105][    T0] CR2: 0000000000000030 CR3: 0000000004ed7000 CR4: 00000000000000b0
[    9.188989][    T0] Call Trace:
[    9.189338][    T0]  <TASK>
[    9.189655][    T0]  ? do_kmem_cache_create (mm/slub.c:2602 mm/slub.c:7637 mm/slub.c:8609)
[    9.190269][    T0]  do_kmem_cache_create (mm/slub.c:2602 mm/slub.c:7637 mm/slub.c:8609)
[    9.190856][    T0]  create_boot_cache (mm/slab_common.c:679)
[    9.191415][    T0]  kmem_cache_init (mm/slub.c:?)
[    9.191935][    T0]  mm_core_init (mm/mm_init.c:2716)
[    9.192406][    T0]  start_kernel (init/main.c:972)
[    9.192926][    T0]  x86_64_start_reservations (??:?)
[    9.193487][    T0]  x86_64_start_kernel (arch/x86/kernel/head64.c:234 (discriminator 2))
[    9.194033][    T0]  common_startup_64 (arch/x86/kernel/head_64.S:419)
[    9.194613][    T0]  </TASK>
[    9.194924][    T0] Modules linked in:
[    9.195327][    T0] CR2: 0000000000000030
[    9.195775][    T0] ---[ end trace 0000000000000000 ]---
[    9.196363][    T0] RIP: 0010:__kmalloc_noprof (mm/slub.c:5635)
[    9.197005][    T0] Code: 75 0d 8b 55 d0 48 89 df 31 f6 e8 db 01 73 02 45 89 fc 4c 8b 7d c8 4c 89 ef 48 89 de 4c 89 fa 44 89 e1 e8 d3 b4 05 00 48 89 c3 <45> 8b 45 30 0f 1f 44 00 00 e8 42 c1 bd ff 84 c0 75 0d f6 05 ae f9
All code
========
   0:	75 0d                	jne    0xf
   2:	8b 55 d0             	mov    -0x30(%rbp),%edx
   5:	48 89 df             	mov    %rbx,%rdi
   8:	31 f6                	xor    %esi,%esi
   a:	e8 db 01 73 02       	call   0x27301ea
   f:	45 89 fc             	mov    %r15d,%r12d
  12:	4c 8b 7d c8          	mov    -0x38(%rbp),%r15
  16:	4c 89 ef             	mov    %r13,%rdi
  19:	48 89 de             	mov    %rbx,%rsi
  1c:	4c 89 fa             	mov    %r15,%rdx
  1f:	44 89 e1             	mov    %r12d,%ecx
  22:	e8 d3 b4 05 00       	call   0x5b4fa
  27:	48 89 c3             	mov    %rax,%rbx
  2a:*	45 8b 45 30          	mov    0x30(%r13),%r8d		<-- trapping instruction
  2e:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  33:	e8 42 c1 bd ff       	call   0xffffffffffbdc17a
  38:	84 c0                	test   %al,%al
  3a:	75 0d                	jne    0x49
  3c:	f6                   	.byte 0xf6
  3d:	05                   	.byte 0x5
  3e:	ae                   	scas   %es:(%rdi),%al
  3f:	f9                   	stc

Code starting with the faulting instruction
===========================================
   0:	45 8b 45 30          	mov    0x30(%r13),%r8d
   4:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   9:	e8 42 c1 bd ff       	call   0xffffffffffbdc150
   e:	84 c0                	test   %al,%al
  10:	75 0d                	jne    0x1f
  12:	f6                   	.byte 0xf6
  13:	05                   	.byte 0x5
  14:	ae                   	scas   %es:(%rdi),%al
  15:	f9                   	stc


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251016/202510161341.61ccb50f-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


