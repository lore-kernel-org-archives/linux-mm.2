Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC498D25032
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 07:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38D686B0088; Mon, 12 Jan 2026 02:46:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365146B0089; Mon, 12 Jan 2026 02:46:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20FBC6B008A; Mon, 12 Jan 2026 02:46:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9146B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:46:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB09BD076A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:46:01 +0000 (UTC)
X-FDA: 84322528122.01.9892F50
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2323E140004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:45:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GCS28Y7D;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf09.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768203958; a=rsa-sha256;
	cv=fail;
	b=b02fwYrmGaZxNnBHV4lTCrWjiVobDLE70o9b3mfIzmC+F05hTicbCBxhherE0aP0D2u9iv
	A7B6k0T0fVLZt7bph/Dv5ZteaDK1sK9v6fRJONbS4+bJMO9HU7JFbPFzdJFXaFzvJptFKB
	yu4EHrO/JxQlUki/7NmdW6SR776vCDY=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GCS28Y7D;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf09.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768203958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZYK85ImgbqzZXsb9Oe7xYt2Nym3+CHjUdtwKX0YFJyc=;
	b=rE/rcqnFiFiYzEfdHj10ZOECdQUdgQZvvmAr1cD2U8blvSh9axuXqvZeosYd5dRjbkksV8
	S9tMXJgrFhUaJspWCZSLUUC8gFiijWy4GVrGOr71Zdu0LP0tLoq+jpkkaNTPUAMhpdsy9J
	oQHwYgdwroUxCT6M9iUCaBb+UcO0rCw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768203958; x=1799739958;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=gedMx/HkyfXExzroefXFr6eaBW3byqS2Eqjr38bA2JE=;
  b=GCS28Y7DnCsNdVGuHCAVPDGkRp5ZrK8hk2OY6NcbCAODtOVotwpNBuDD
   P3JDwNePWeMzsbNfnnWkZOM11938TatAFP/34R6QwlK02f0V3hNBvpvcc
   Iu5jkwOl6ubTCIyF1ijL7L9IKvN6jIcRFRWZKAXpClZpMUKoU88o0bI0o
   TpVmcRsW8Esfo6CXEAyLors7sfKKpi/VO+u0HYr35pugkkqtjqMBQkxeJ
   B+fvQnM2KqX6CLYIdCLeyhZI5eZHi/oiMxO4MUvlu2akSLrqzrlYu+YNN
   5Q1sXmfHxqrM/udMHM+i9+muztmYiAjQPh0Mni/FUwAG4TBwCJuHNUZGH
   g==;
X-CSE-ConnectionGUID: XC9Rr3T2Qze9eZQNKOvr3w==
X-CSE-MsgGUID: iSHuUzksQhiuhHZXquJy8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="73106565"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="73106565"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 23:45:56 -0800
X-CSE-ConnectionGUID: VfXL5m02Taq9W9T7mIEnLg==
X-CSE-MsgGUID: IOV7PqgcQdKsPyZDmQfODQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="203826242"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 23:45:56 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 23:45:55 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 11 Jan 2026 23:45:55 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.62) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 11 Jan 2026 23:45:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zQukPE5m8eF8CY/L4RVumVSUiRQRtPSK9xWVjHwZsiRKrwox2a3UtJszA2BWZGsBs9fZ0Sgt8NoEJlMeOIfMPSsXM3/LSrwh3/xZLAD00HWcwcsEQvG3NRoxnKPb3SRqU5osQkfoVYB1SWetHEK8iW9+ivRW3S4UsB1eMGsdvryNLePaijkaP2A8qJglowm8jEfjfZ+pOypL+eSxAsUHydKD6/jXfFwjWorTNqXyQ/5DB2bSlm3P+3TMpsS0DF3tuTqay/nzWLZRJuFdxhdGqayCFYtmAqhUy6NqObD55MuoA+WM4awQtVfdkRRUB3FBjXgReX7+BakEPK8UC3isuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZYK85ImgbqzZXsb9Oe7xYt2Nym3+CHjUdtwKX0YFJyc=;
 b=xJQjiybJCckP1xBE1nWRFeEJPHSaHHcuUpUOOtA5FQUxLi6oFe5kOz5kQ0yfHZlXqUGXjtAl+bUiNxG/bnmD0OneY2+BoEtzTCriZLXs5hS3SJcA/GHdmTgt0STGhiqRj/ZXK8RKzmwuHQEbebyF37PJDy0XB2kUZE2FAQErKusNhwkkBvEGgrUa/8qQYpFyXDGrZDGx87Eol6yq/4FAtlqwo7rhQWYFlVFI1ehtiNK1oe293+W0TBo3BfweFokn7OtYrPIIv4yfpS/468hBWdkd2C8mbtdBxZolFj9FAYfOdDyxr0rkiw8yLvYulta9RQXyaK3n1XrOfw1ihV1tDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH3PPF37A184CA6.namprd11.prod.outlook.com (2603:10b6:518:1::d15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Mon, 12 Jan
 2026 07:45:47 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 07:45:47 +0000
Date: Mon, 12 Jan 2026 15:45:39 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [vbabka:b4/sheaves-for-all-rebased] [slab]  3c9d05a883:
 BUG_TestSlub_kfree_rcu_wq_destroy
Message-ID: <202601121442.c530bed3-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI2PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:194::17) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH3PPF37A184CA6:EE_
X-MS-Office365-Filtering-Correlation-Id: 637663dc-dff4-4d14-8ce3-08de51ae992d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?xp+IC3sJSBGVPXzpgZoovyalIiWmV8WTCybsKXO9w5MhNUiSw9U7Q7jTgwyk?=
 =?us-ascii?Q?Pq4OtGcJSPHReJNW6lS+8GaRlQokj6ePGEwGNawsSWwSEnXG+DJmztPnipZS?=
 =?us-ascii?Q?SKVQBnEmmuzia1QuovTBrNx07WadAmyVSQczf1w5ta8BAmRvqsRkhQ7Wji0P?=
 =?us-ascii?Q?dmSBGb2ncs5YoAXgnvMYVfkvMue2pXGjZ7yoXAs1Wa6PjF06m2NaYxBR9hPU?=
 =?us-ascii?Q?7W4CejLRc4DTbXtUBglMbHK2ESsgdK+IMFeZKgCSUj/A4stviw+utx0sNI+k?=
 =?us-ascii?Q?J+3U2j8eIkTs/v9OBD4BxaJncOSPQ4gC1QEAtmiDwyaP7IDTtLg1vfJBv6en?=
 =?us-ascii?Q?I1323e5brQfVuv6tKiCOOkrbk94nN7pG27qV09o8D6eOGou1jHSgDAX1Qp5v?=
 =?us-ascii?Q?5QDgQA0dlayX21dc33nHVDUIhZ2bkL6JTC7mM+ajnwWcSZeFEiUUkp9w+Mbz?=
 =?us-ascii?Q?seBg09d1AmreSO+CBoEhXg4xPI45Qnb9C6BriGm7voGCMA70wj4EgiYh2TGi?=
 =?us-ascii?Q?KbhVPU+Br/br3GMHxEQM6sdNQBvMe7kxpkUjsw/3VqJ6bwhRFypzJ3ag/s8Q?=
 =?us-ascii?Q?Q1L8tZQ3TpLU2SouEdPyom3ih9TDRyDmNuMSv2zYk36p3gtwYGDY6Ywy/idb?=
 =?us-ascii?Q?IafoN4yHCEx7wvDjGVpa6QwMPy7aZHfxzUGgwuQrV4PFbikZTUvnGE22tSJ4?=
 =?us-ascii?Q?8kwXRbIMs1KtvlRkhqZlmTVvenjKntmIHBTc0fzhf3IarXSqvTHzvFjjF34w?=
 =?us-ascii?Q?ArAWoOheQcaAYuVxU8xc85vw9bCqshTtiR8flk6hTxG57dxtGXhfIYH5OcCe?=
 =?us-ascii?Q?P35pg4b4qoDJaQFR2/OvmZLOE+J/mLT886IlJmQS3rT3lwkcEqGYK5QAT6xC?=
 =?us-ascii?Q?A/MUvLeEYk+qHvDeYgEt61MmrQyvOSc4k0A7YShiALDxDsHrQIcVDfvL9LMq?=
 =?us-ascii?Q?INhO2rRu+c5hVL/160EbA1VwV0OE/8cl7izxWyDkohmxNyfjFkNqtkPvltHe?=
 =?us-ascii?Q?1Z2ntMWjAa8NAPNocUvNYdBBn8eAu5ZtXN9JYB+2q1PrMIu7PM9NNLx8doww?=
 =?us-ascii?Q?pRM/VkJqovv7biq4K3REBaQuylorSQ9zfB1XbgbkV48MxzKSUX3d/ivpeHKA?=
 =?us-ascii?Q?xZhHZBifSM3cJ4T8w960eMC54w2fLWLOvom2271ZWO6X/ZKAYONQEm/A6xNz?=
 =?us-ascii?Q?jBXiyBRCjtMvuSLYMicJAUMtMtQhm7wG4De3e4UkMgmgVWRYgDRvZAEhvczF?=
 =?us-ascii?Q?PMlc7Qc5xpswFRUxLiINETB7pqcrcJRX6YNya+n6QnLk5WaBibrG8YU69du3?=
 =?us-ascii?Q?ayFOpB3GyOi/DRk1okTTS7UOJy2ut3ahOyLstW8+3N++TbsvP+vdRf2cqpXy?=
 =?us-ascii?Q?CJwYVICKh01kNV7J7F5kz2iQXePOtZ3ED6qoHyexMNbjLic/myXucZO2rcfI?=
 =?us-ascii?Q?OmQ3cfUKWLCoyCOiXnrASO6H295Zh0JLaicy4QHu3nFGQSTYCsgsZQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eiLgoIkKlQHFT4ZnfE2tZJfFLlrmoynfpP9rrGCOpODr5XPskyWUJl39YwyP?=
 =?us-ascii?Q?kQfsVpCdR+t+ePyMV578qmumhQy6ITnfDi48+hst3jpSxWIjjyV8pfakmqNr?=
 =?us-ascii?Q?dSqaGBNW67pq0LO0/0gprjR5IVs8n96PTnGpBMV9MVMt5l3iWF4Gt8b8bDCu?=
 =?us-ascii?Q?YHXsW67XLtFi0rEFjw36rn74iBixaBYB5PbS21Z2BF6uRf/mwv1RKOneY+7B?=
 =?us-ascii?Q?joYo+4mcGb5XpeUwfNYqHICY8yVtRQd0951GRHvCH+mTXDOHPIdftg04lQYY?=
 =?us-ascii?Q?Oz4z2/7VYJgH19VgR11KOzpSCWSX8hgFS3ohOhFJkp6K7+GfoyEW+0/5IImC?=
 =?us-ascii?Q?ourmpWryXodqPBSZ04/UagYQBE4y+8gyG0Qp/2NkVX7IrAljwL/PfqTYmVER?=
 =?us-ascii?Q?hWlSh7cN4AMvvwgsA3l5Seseyy9MwiZQdPq8e0PqQjtzBD7/i2KlmO6de6Wt?=
 =?us-ascii?Q?nhcQuekdNpUZewzMoKPGf3L8nOe3JT/FkUzaD61jEca/Qssr33LIemHelyWF?=
 =?us-ascii?Q?RCkV4eHH/5wFzXoMeilxVgghyT2Fa5GqKyR/8xaYd9reZmNECqIsOCEbdS78?=
 =?us-ascii?Q?H0wy7tH2Te5wLcQLatfjwG7G4NSGXB9MTMtO5uNNgjrM7+c1SsNE4spCOyqw?=
 =?us-ascii?Q?MxCnWY+e8aktkmTeB17AZYUyqhkIr5N4FO/Ddm8dh3d/sPuHsc3sbacf1H5R?=
 =?us-ascii?Q?TY1GOlUznkK7V3Y9cFowXHYv47r7fubv/CEApIgS0xGpGcqXg1S10CDRHq/A?=
 =?us-ascii?Q?/C5MEYWYvw3RMuR0fThq7rIMw9WSbG/iTTUXNPFY/Al9dknJFgTQcjUYivrk?=
 =?us-ascii?Q?lT6kpTP97KdsxS+6Wx+OXKSHQbXau8ryJac6M/McEvTpciyDDen5+BD7g7VX?=
 =?us-ascii?Q?8mNKBcy80AdUHkBmU+bzh8NvUF/AetxdmtQTuN7XXushElkGnHRfjdNGtiLO?=
 =?us-ascii?Q?ohMe62y08BVx2KSkpK1YskyaVI12Ebtswv09lB2W5y32J/O4EPglXHZT0In0?=
 =?us-ascii?Q?+YTK+UqL3oMra0taNoJQRDrvzFpYrqPs33jiVHJu1ohxrp5B65HE2LwVJNXn?=
 =?us-ascii?Q?89qm6pfxs7eIKoJ6UGI8jSc8Z5Pxg2oDBskDFcMytavQZ18kA4UHRJsJAUwk?=
 =?us-ascii?Q?4UQPFUMs71hG7R0lrGcZwd1vK1bq7iDLPwILCDU6XochnrIYYlj5tSKclMxf?=
 =?us-ascii?Q?vaJQyMe52cn41c3MEUxzSD8LqEowBgoPGN5tgTD2YP2X/lY9RwewQnHalQme?=
 =?us-ascii?Q?fnro/7PLnPmgW3wsuak3emXjJgZfdJ619DQWNg2TnzDMkXArfX1WJ6vEuV7J?=
 =?us-ascii?Q?S7/FDZfaLB1sNF+9+s2JKFlH85zvYXAvL+z73kTznRtAsvYVxarVmsOuovUc?=
 =?us-ascii?Q?tu/qo4cyLgBEZt/uqdyLC0JXJNeAsd7MpexBSR7MSGBHXD/mrpy5dm/sLi2Z?=
 =?us-ascii?Q?lvl3IQZTf6kKdy8LJ5P4oQAWBMt/PNt3F24URHKUyLz3W306iR3av815AMBz?=
 =?us-ascii?Q?s9zh0FjZZ13cxXVpnbCwFhUz76Z9j4Ykqb7v9ZyRh0nSuFCv2EgBfXMF+MeK?=
 =?us-ascii?Q?vBOOw0dqqvaRmILkeHzvoPau7CgbjCxym9C0RZPJ0aneXrOMCW25nB9Okfcz?=
 =?us-ascii?Q?YiqEzfSZJEOj7Dg8t0CGXj9AL+6w+dj1K0571IJ8mPDKbjw4+fid90Is5Uc8?=
 =?us-ascii?Q?u79frP5/UCA9y3oLwHiRRuJG65+hY//pZCT7QGc7Rios4zdeqkEdRWUvx0ej?=
 =?us-ascii?Q?LHtJXj4ggA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 637663dc-dff4-4d14-8ce3-08de51ae992d
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 07:45:47.0558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZCBgKbTWd4Syh/onOEJbY4qVGe6aRbChv5FDcDGwNEp3Cjh+PizAtW/BA1n+UyqT4AGbHYYtzDWMEFnsdY288g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF37A184CA6
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2323E140004
X-Stat-Signature: ou3s8pc564uwbb39aubbgo455n58asjd
X-Rspam-User: 
X-HE-Tag: 1768203956-382563
X-HE-Meta: U2FsdGVkX1/NQamURZZ73BrL94HBA/V7kKWhuFuh2xq+BQaYBZPaF14MWVJzcLC+1yp6BFH+ve1XoC3X73wfXK/TXsokWuimGvxzKW+2Zg8uMQSMG25IxckZktDCaENPtHlSZPDzYuubLKd8a7gDt53+OOzvtbYGHmkqMiHefS1/s19CLZNjwRXNmzhZiypAUUWtRK+daUVin10aqdOIwjUERtDXgmbx7A43FhfGjSdLTkKm9TKUZRH2b8R1Q9StfuHL3WhdUwxqrgYij+LquFgvlsenMQw6JgF74gzKTh+7y/u52K9uBs5HYwynDfmSbELlZw1dDX83pKDuJwiDJY/cORTf2qfe6pMRd6Ds7aCHG6hs6nP3QQ5DvitPFT7YBL6V3sDJWjuimPfIG+Yq7Fe4ENeDoscSZ5Ck1PRjq/hgIQPnbV7lBEA1xGCj3/ivF//Y1kNBFn1np1C488eTUB3Iz6vJGbZAVGw/HHH6LoYXvvDqHfr+j9v+Ve+juquY9cb5yUvc9ph8T4dcPEGTYseiTnQ8rlEkKpgagqN7AWoX2a29kMXdFYx7S5JdUDm98im/aQG2iiqASSMUX5P9xdGco+BwQMTTy77ZMlQUgVxjw2cLdwGtaj7ylnl6Ie5KVFfSulu//orRyCidIu2JFI5lLVLXxjCeRWv0qpLrYfb1XwiQuRjfoWaZdHX53oEpNAa/3870uaptfpYHjepDGYCyQLCRbvvHtAYseYkeErUwuQ7k0kgOBxCJaDDKnqgt/8OTFV0KcMJJjC5OO8EeBXENs588iieuZVXy8MEddvufHvuIja/15zBYX1gLBRUxretqElNXa/FQeA24npOSqK/w3UYMHl8+Tg00F2bNXqWnQSjMm5cZ1iYS1UEx4QaAY+L7YWdUSFwRjIz/dq+2k5PUSOOPSfG1GicU8N2S4Aqoq2JdpGgHCmeJn6UWtXNzPAa4zrs6z5FhtwRfY4v
 7cznPwED
 rKjO1UY+894G+oCWvXFj9aDSM64ztwI5NSwzYh8axJHQP5FP7RU/KaGTd0W6WsSwDZ14J6+Sr+tiwZjyhW6NcNxPC8Hhsaj1xFoKHOQCyTGuBVlyH5a38CSPI1LSjX8UX3Pclslhyh8c/3JaBWBLH6APWsFXjvDM/55JPpnD/+ECXwS9FSxD2Z9TxNlA/i1r/JR63yXfpDZ0uN+qECH6jyrVIEMVy+d/A+GX0sIbY9ml2dnP2Pefs6pLKGYDrQ2ChHgFR0Ybd2tjtanQn44GUdg/TY1h8bfxnWEK5wZvZNKCH0DjxdNni3Us4QGMvhjXM1u9gjjebz5rkTh+dZdCHZ6dTWBIoOLaFpWq27ZsINRSneaPlfJFiNpgR07qgP42jYFyv/eMwSOlRWfjgLFi4CAVsQp5yjENyst11zfm6AHhkq/vPBe+tNvJaJiY0+lIgYdLdrilwirvjJQvAlsw+rpn5087Ft7NsguZM4EumlME3+CL9MGNMkU8mty9Q9ALlCC5SrwD8IoQxwC5qXRYeAp08Q3QbB40K+EXW92ZQfWUzeHnuTNLHrMWXL9tKCqNklMygE/CGe1vZdMlYenMZY0jLPh0idlZQw/CntWGXRDBF3pQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "BUG_TestSlub_kfree_rcu_wq_destroy" on:

commit: 3c9d05a88372eb667214035d903b5ea09be4459b ("slab: add sheaves to most caches")
https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git b4/sheaves-for-all-rebased

in testcase: kunit
version: 
with following parameters:

	group: group-00



config: x86_64-rhel-9.4-kunit
compiler: gcc-14
test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz (Haswell) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202601121442.c530bed3-lkp@intel.com



kern  :err   : [  137.071325] [   T4498]     # test_kfree_rcu: EXPECTATION FAILED at lib/tests/slub_kunit.c:182
Expected 0 == slab_errors, but
slab_errors == 2 (0x2)
kern  :info  : [  137.076926] [   T4491]     not ok 4 test_kfree_rcu
kern  :err   : [  137.133204] [   T2648] =============================================================================
kern  :err   : [  137.146570] [   T2648] BUG TestSlub_kfree_rcu_wq_destroy (Tainted: G S  B            N ): Objects remaining on __kmem_cache_shutdown()
kern  :err   : [  137.158349] [   T2648] -----------------------------------------------------------------------------

kern  :err   : [  137.169350] [   T2648] Object 0x00000000b072383a @offset=2240
kern  :err   : [  137.174817] [   T2648] Slab 0x000000005fc4154e objects=128 used=1 fp=0x000000000b8c0d81 flags=0x17ffffc0000200(workingset|node=0|zone=2|lastcpupid=0x1fffff)
kern  :warn  : [  137.188509] [   T2648] ------------[ cut here ]------------
kern  :warn  : [  137.193801] [   T2648] WARNING: mm/slub.c:1248 at __slab_err+0x19/0x20, CPU#1: 0/2648
kern  :warn  : [  137.202990] [   T2648] Modules linked in: slub_kunit linear_ranges binfmt_misc snd_hda_codec_intelhdmi snd_hda_codec_hdmi btrfs intel_rapl_msr intel_rapl_common blake2b x86_pkg_temp_thermal xor snd_hda_codec_alc269 raid6_pq intel_powerclamp snd_hda_scodec_component snd_hda_codec_realtek_lib coretemp i915 snd_hda_codec_generic sd_mod snd_hda_intel kvm_intel sg snd_hda_codec intel_gtt platform_profile snd_hda_core ttm drm_client_lib kvm dell_wmi snd_intel_dspcfg drm_buddy snd_intel_sdw_acpi dell_smbios drm_display_helper snd_hwdep dell_wmi_descriptor irqbypass ahci ghash_clmulni_intel sparse_keymap snd_pcm libahci mei_wdt cec rfkill rapl intel_cstate mei_me snd_timer dcdbas libata i2c_i801 snd drm_kms_helper i2c_smbus intel_uncore mei soundcore pcspkr lpc_ich video wmi fuse drm nfnetlink [last unloaded: mptcp_token_test]
kern  :warn  : [  137.275019] [   T2648] CPU: 1 UID: 0 PID: 2648 Comm: kworker/u33:0 Tainted: G S  B            N  6.19.0-rc1-00005-g3c9d05a88372 #1 PREEMPT(voluntary)
kern  :warn  : [  137.288184] [   T2648] Tainted: [S]=CPU_OUT_OF_SPEC, [B]=BAD_PAGE, [N]=TEST
kern  :warn  : [  137.294860] [   T2648] Hardware name: Dell Inc. OptiPlex 9020/0DNKMN, BIOS A05 12/05/2013
kern  :warn  : [  137.302746] [   T2648] Workqueue: test_kfree_rcu_destroy_wq cache_destroy_workfn [slub_kunit]
kern  :warn  : [  137.310986] [   T2648] RIP: 0010:__slab_err (kbuild/src/consumer/mm/slub.c:1249)
kern  :warn  : [  137.316370] [   T2648] Code: 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 e8 16 fd ff ff be 01 00 00 00 bf 05 00 00 00 e8 07 b8 2e 00 <0f> 0b c3 cc cc cc cc 44 89 e2 be 00 10 00 00 48 c7 c7 c0 12 bc 85
All code
========
   0:	00 90 90 90 90 90    	add    %dl,-0x6f6f6f70(%rax)
   6:	90                   	nop
   7:	90                   	nop
   8:	90                   	nop
   9:	90                   	nop
   a:	90                   	nop
   b:	90                   	nop
   c:	90                   	nop
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  16:	e8 16 fd ff ff       	call   0xfffffffffffffd31
  1b:	be 01 00 00 00       	mov    $0x1,%esi
  20:	bf 05 00 00 00       	mov    $0x5,%edi
  25:	e8 07 b8 2e 00       	call   0x2eb831
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	c3                   	ret
  2d:	cc                   	int3
  2e:	cc                   	int3
  2f:	cc                   	int3
  30:	cc                   	int3
  31:	44 89 e2             	mov    %r12d,%edx
  34:	be 00 10 00 00       	mov    $0x1000,%esi
  39:	48 c7 c7 c0 12 bc 85 	mov    $0xffffffff85bc12c0,%rdi

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	c3                   	ret
   3:	cc                   	int3
   4:	cc                   	int3
   5:	cc                   	int3
   6:	cc                   	int3
   7:	44 89 e2             	mov    %r12d,%edx
   a:	be 00 10 00 00       	mov    $0x1000,%esi
   f:	48 c7 c7 c0 12 bc 85 	mov    $0xffffffff85bc12c0,%rdi
kern  :warn  : [  137.335754] [   T2648] RSP: 0018:ffffc900023cfc30 EFLAGS: 00010046
kern  :warn  : [  137.341652] [   T2648] RAX: 0000000000000000 RBX: ffff888411a3f280 RCX: ffffffff8152ff76
kern  :warn  : [  137.349451] [   T2648] RDX: 0000000000000001 RSI: 0000000000000008 RDI: ffffffff8772f660
kern  :warn  : [  137.357253] [   T2648] RBP: ffffea00041cddc0 R08: 0000000000000001 R09: fffffbfff0ee5ecc
kern  :warn  : [  137.365053] [   T2648] R10: ffffffff8772f667 R11: 0000000000000001 R12: ffff88815d5ef7c0
kern  :warn  : [  137.372853] [   T2648] R13: ffff888107378000 R14: ffff888107377000 R15: ffff888411a3f280
kern  :warn  : [  137.380655] [   T2648] FS:  0000000000000000(0000) GS:ffff88842480b000(0000) knlGS:0000000000000000
kern  :warn  : [  137.389407] [   T2648] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kern  :warn  : [  137.395824] [   T2648] CR2: 00007f0dd03d60ac CR3: 000000041b674002 CR4: 00000000001726f0
kern  :warn  : [  137.403626] [   T2648] DR0: ffffffff87858864 DR1: ffffffff87858869 DR2: ffffffff8785886a
kern  :warn  : [  137.411426] [   T2648] DR3: ffffffff8785886b DR6: 00000000ffff0ff0 DR7: 0000000000000600
kern  :warn  : [  137.419227] [   T2648] Call Trace:
kern  :warn  : [  137.422358] [   T2648]  <TASK>
kern  :warn  : [  137.425143] [   T2648]  __kmem_cache_shutdown.cold (kbuild/src/consumer/include/linux/reciprocal_div.h:36 (discriminator 4) kbuild/src/consumer/mm/slub.c:8072 (discriminator 4) kbuild/src/consumer/mm/slub.c:8093 (discriminator 4) kbuild/src/consumer/mm/slub.c:8131 (discriminator 4))
kern  :warn  : [  137.430441] [   T2648]  kmem_cache_destroy (kbuild/src/consumer/mm/slab_common.c:560 kbuild/src/consumer/mm/slab_common.c:518)
kern  :warn  : [  137.435220] [   T2648]  process_one_work (kbuild/src/consumer/arch/x86/include/asm/jump_label.h:37 kbuild/src/consumer/include/trace/events/workqueue.h:110 kbuild/src/consumer/kernel/workqueue.c:3262)
kern  :warn  : [  137.439915] [   T2648]  worker_thread (kbuild/src/consumer/kernel/workqueue.c:3334 (discriminator 2) kbuild/src/consumer/kernel/workqueue.c:3421 (discriminator 2))


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260112/202601121442.c530bed3-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


