Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE5BFCAC59A
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 02:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142ED8E0006; Sun, 21 Sep 2025 22:40:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F3F98E0001; Sun, 21 Sep 2025 22:40:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00BE8E0006; Sun, 21 Sep 2025 22:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB9B28E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 22:40:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E29958F7D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:40:25 +0000 (UTC)
X-FDA: 83915332410.30.B34C3C5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4E9958000A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:40:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QL01ijlU;
	spf=pass (imf30.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758508822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkBq+0HX3Xfj56cm30NUa1WV8yi2hTp7/3gy07uxboE=;
	b=qpY88FAMRxv1VMlJeXTll3ingyyeEgRKkS678Nynf7ADC33QoRXr0XHSEkcKRQcprS0zyQ
	KP0CexjgJjMqVz6NuYDEW5GboHlxK60VCnmFsMLxHIIcYt9DsvkkOCmBlUK4zCNLVAve4V
	grfTK02xkzNhtFlUysdkBNiaPnrqfd8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QL01ijlU;
	spf=pass (imf30.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758508822; a=rsa-sha256;
	cv=pass;
	b=8OYHvh/6gULPTH4YA2QfgMDYeA+uvGuDClSGuxONidvW5nHcu91Nm4ukRqKV988Pr1KQBE
	TQ5JfW/Lj7GKySrycE2A8CNunif0PK1/hHu8gl/2XKyuv26xttua1qVyXm0kiuINLBcWoj
	w8ZnYnETdUO6PF9TI6euV1OKa4ezihs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758508822; x=1790044822;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wkBq+0HX3Xfj56cm30NUa1WV8yi2hTp7/3gy07uxboE=;
  b=QL01ijlUtyqsRZi0NaELpqd21vaaNH6CGjyKR6/BNGqvGJwGyVdtTUsj
   3qDQuyvxatpAj2q3KXh63FqQnLplPA9vmg3HGoo8KuOGej1wXCGtSVbKz
   4Yr8HiUCqHH338hb0bADuOWilm3asrithO7zyvZFzqOxLg5oX0oHbIsnR
   B9FXr0D2xu0687Fg6Pn9OZhyuDvGsbzTeRYM/UV9YfyL1xeI4XgPDJ6DP
   ejV/dA9eECnS31lpVA6q3TH2abTjT4W8PbzmYNkTpOzDNyP2wVKvT2oUl
   1yphicetWPLmGbbJnJd8CrhvJohhg2HAvmMKZfXkbBijn846St9jrVdSd
   Q==;
X-CSE-ConnectionGUID: 1CrqKEwNSbmYhiqkpTwx8Q==
X-CSE-MsgGUID: 6aj5m8roSKGEu4jEUKtzfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="78206654"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="78206654"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 19:40:20 -0700
X-CSE-ConnectionGUID: 5l8bFEHBSi2oPu0i05DG8w==
X-CSE-MsgGUID: 4GSl+L76RfynG/awd+gXvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="200076336"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2025 19:40:20 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 21 Sep 2025 19:40:19 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 21 Sep 2025 19:40:19 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.53) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 21 Sep 2025 19:40:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xnrWi+KwH3EISNiAsANVc5iKW0PYOFNV1NYGd+XwNzKWXxpvP+gPNAJpdcj6c7OtfyoZWixO7yiHrwdVpERiES5tZul3aEL4nXskrvovEBfR86r+UpDRMYxrkNLb2l75LqOwjMYwHqyVaiSZ2287nLVtnUk3CXPJu1XqRtk4cxKNb6jopOuhFmXbqT8t7AgA4W1E1+DHNKhJc2jMFUpidQdQxeZUWPFQtF7raJHN0qcQ3Tx8tc54IIaelbjV0F5cnPIZsAGQ02lYnRIsfCitPrbb7h0sKjWXAAVaSAYiAr4y+F1U2zcy1wcGn05BrwGLYBCFDkXuRvYu+iwBe2nobQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wkBq+0HX3Xfj56cm30NUa1WV8yi2hTp7/3gy07uxboE=;
 b=yxXIjfMZ01ykayB47iq/x2Kywm2a0NsO6aRbp5351CBFLFeB1M8Bvq63X4z0twOCDCkicqEVVNCg0B9Dos873e7QobF/bs1Di00CyYNB3JvbM5H7+3mcpZ4+8QEICYVDp8x6ZQafXz6NgGR8TZoR7pB1dy5efXl9pchIRqPIR1pCDbNjF3y0cIbbxEUw1VV3Cl2ioCA/17t1tRGc8LmoTFo0cIUmDDDM1G0u1Wbhh08EJqcI9DAsbwd68ild7xnzE+090Cc2OOjjQ6nhZulnh/DHbMdLMgjrHmYxlfw1q4N72dAjyOzBL0jAHokgHhZ45d0BOkEieGCpvtuQ2gVIjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8768.namprd11.prod.outlook.com (2603:10b6:408:211::19)
 by DS0PR11MB6352.namprd11.prod.outlook.com (2603:10b6:8:cb::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.19; Mon, 22 Sep 2025 02:40:11 +0000
Received: from LV3PR11MB8768.namprd11.prod.outlook.com
 ([fe80::154a:b33e:71c0:2308]) by LV3PR11MB8768.namprd11.prod.outlook.com
 ([fe80::154a:b33e:71c0:2308%6]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 02:40:11 +0000
From: "Kumar, Kaushlendra" <kaushlendra.kumar@intel.com>
To: SeongJae Park <sj@kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH] tools/mm/slabinfo: fix buffer overflows in fread
 operations
Thread-Topic: [PATCH] tools/mm/slabinfo: fix buffer overflows in fread
 operations
Thread-Index: AQHcGRYDNNzQ+Pq3zEOhgdNslMFCubSeohnQ
Date: Mon, 22 Sep 2025 02:40:11 +0000
Message-ID: <LV3PR11MB8768BC4A1DF99E07DE49FAD8F512A@LV3PR11MB8768.namprd11.prod.outlook.com>
References: <20250829095947.1828094-1-kaushlendra.kumar@intel.com>
 <20250829185205.60231-1-sj@kernel.org>
In-Reply-To: <20250829185205.60231-1-sj@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR11MB8768:EE_|DS0PR11MB6352:EE_
x-ms-office365-filtering-correlation-id: cb71365d-3c43-4ff1-2283-08ddf9815a37
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?NIxOZproOOhpupP19gtFIR8lri9ZYbwQX+73dWi1Ls8WKJTdfqKnK0dyLdCt?=
 =?us-ascii?Q?BQXzspgS8L+N6DLCHhbrauL5Kqcxr7L8lJDMsie7+bxSmUzvkbVWdsmGQuio?=
 =?us-ascii?Q?VGTNfDIG3RqDQuFKQmPoILSI3H8E8CLPiFTsUG+7FCcbQq0zxCjiqYau8/qz?=
 =?us-ascii?Q?81TdEmiCIAT5ugXvyiIJs3isnyGZzF7fUOJBujwf5DsY8PiXoGPUSpe3SWUm?=
 =?us-ascii?Q?EC1S3bbdJI2lZ5Yvge8fZsBDTVpNIdIT8e53Ft/6tNRdI+Qm7Cxf2T5UnMUL?=
 =?us-ascii?Q?LP2nug03cl7KAL+1ynN4nzDB+wB6GAo2Mam8+GPcTDsxg8TXWmwp5E5EtOLS?=
 =?us-ascii?Q?mLcxk1Eik/7id2P6DYP377afq/2mMVXZum7PUyCWJTU9BWIariXAzp1ryKFL?=
 =?us-ascii?Q?wVcM2oMNjelIKqinoMOfxZiFDOajcOzAohitAM48fTSfCLzBg/I3vkqHvBQZ?=
 =?us-ascii?Q?qjVSeNZwSfKEKu6EcFBGxAti/RlgPLUka7waMXyQRmhUNxpBwE1h8/hjU2hF?=
 =?us-ascii?Q?TM8HgYeDnhEnYPTrlbCJsCeMXaKfhR++KQOeuHojT3+19JbYjKwxiWS21zBv?=
 =?us-ascii?Q?WnRp4HgULrwbd0HERTuIqminawdRj6fw0nlrmRkRv2Qpw5tTAFqxsvDrbT+v?=
 =?us-ascii?Q?V0vhiYfPSKQXZKwuw9lsyg5bSPL8TIFhH+Vji4oWI83pCt15buXyGrWBq88P?=
 =?us-ascii?Q?gG7cFRFnKb3FP9w7vz5UqhcASXtwtpTmmKhiWPC0w5giEdiZ93CgDneJjhZ5?=
 =?us-ascii?Q?BTCj5qu20eEbBwVuiPMlmtFHHBfPVoNAptIWutP8HnsT4FOW3uYMDQeqgPjn?=
 =?us-ascii?Q?qwc1J4jBiy87JzKAj1i0l/rPqDurhxmYR7b6CkI7OMe2liDfvdOJPos6aBWF?=
 =?us-ascii?Q?GVZPCrYXSUfTTzLmD4m9ycF3i8ia58c9jTgNrEsbg/vbhSzLXGWg7/AyokFD?=
 =?us-ascii?Q?ekwJRcrMvT6VnmR4/cpM2WCXtBuL8QT4CpbxJxqvSuYBGIbJsEuui8Qv5bHj?=
 =?us-ascii?Q?qMkTikd/+IRrA6ZTgylS64a7Fj/Wa+rembTMTEYxbX6FebgWgPx3Bq35ccBm?=
 =?us-ascii?Q?0YX0BPWPgeC9lNgFRrVgyjJCBWWEqV4HSm4UGnwQSIGezU5+6gr+FIyAtOhD?=
 =?us-ascii?Q?BmxpzkUNkYe4s848buQAP2NX/a+pmn/3qAN5MsDNief6Lv0EiYu12dzV7zrv?=
 =?us-ascii?Q?Gg9SIwrsn/9YLPdz4bX6LWx7K24grz6zwYf/guNtkifv/FyFDlGwoCBgHi1a?=
 =?us-ascii?Q?4VmLDCjifJjonj6qMVFLSVfCpp5zU8lRrJWlSqhz89EqkAmeWz3ihz9P74lo?=
 =?us-ascii?Q?WI2UJwDeiLDN+dacxsQqWr8qaAdflY9H3p3pgUkpJ8MrrcoYaMwc/W2zFt1z?=
 =?us-ascii?Q?YzRkg5ZjO7axG1xcvAfnGenAvpqbB6s+0WeR29RVAG59WXg6xK4bJTkElEdB?=
 =?us-ascii?Q?WmSSQMINPTrwMow1svzCMO16/SR565LHQLjZebPBwFDPcKDEACRM4w=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8768.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B/ACrB7nKnP4zD2WzansJpqLzBMLNnFdSfdLr3aY45sq+qPVAb+DclaBCm3j?=
 =?us-ascii?Q?2JGPMKuozIjpyiOFhe9xVk4nj48xsj0S8OdGyDV1Tyn+BGQaTDCFo6O3u42b?=
 =?us-ascii?Q?QFIi+ohYRwCcaMUhhktGGYLXCSmIrxVYbhym4dSos/OmNiE5o4C7j4uydikS?=
 =?us-ascii?Q?rjXpeWporIdI3fUV3rIxgfRV5XiLJRL7ymGnvPW/w6wxLlvo6OlOGsJruWBl?=
 =?us-ascii?Q?yMhcIc2JnKS2qOuRU2CwZ9YHZM0Ol+0JTafNXGGww9Va5h3xEfNEBuD3s0KG?=
 =?us-ascii?Q?SWtOr6XnjK+2OCHW7wcvDYwMeKDfeHS8jI39BwJcLo2kuFFyhlQ6wXOvCud9?=
 =?us-ascii?Q?puU/QHP5s8B3tW9Ct0i4Sb93WuBTSt53DcNJMwPv2tlVde6Dwxh3/JsQsSV4?=
 =?us-ascii?Q?1exvHBl56ZBekk14Okl1hzF/Htafj7qqNJp7MEpeTcN18t8mM77v5m465CWX?=
 =?us-ascii?Q?4xMLgdSnlbiGnGAENqdSUq0JiFDqXLdvlkiJn33c4tFtBLadRHuPMl7rOCHo?=
 =?us-ascii?Q?4cdtQt3m681jqF9Ya+OF21lbzt7d2Qvkf2NAYw7kdV7r6evs6A5sb/0aIou+?=
 =?us-ascii?Q?6jjFFKv36tduijNIsmrdWWi47RskaNM04lw3PAp/2YxXk9gwERrBfwlaTs4+?=
 =?us-ascii?Q?+tLc7GSLJGWFxa9NeLYMjauqF8jj/NGiqiCMkn5o9XI5eD4eP8lgaUNuSjTk?=
 =?us-ascii?Q?2bkCbAZSsWItn2uHDCJiIJWQy00WegbhfbzlSq7g8FlzjU/Mf9UePT96y3FE?=
 =?us-ascii?Q?bMqORdmfnbZNW0iJ2F3O/x6nXJJb9K7AA7jvUfuRJ/HCEET0YCkum5pPZhwd?=
 =?us-ascii?Q?AcjbnazaQ0T9V9q4t25/oZKrcFZtvtva4mSqgNEbUxgna+h1bw/fBv6p+aQi?=
 =?us-ascii?Q?vcTpsEsm50+EpO5stlW46an4yPc/STu/cthpdhHOSeW5O5G91H3zrYt9bXMN?=
 =?us-ascii?Q?fPR6t64RI8NqStrInB6zgqVm8jAT84oduuBhVlqdaL60LImI2Gbe64BJS6r3?=
 =?us-ascii?Q?cUCv3V/W/NrQRYBujZwcb5oVeVSuUW4Mf7Yj5hCeMZGj9wQ0bg13o1/UIluc?=
 =?us-ascii?Q?TkkoCC2BaBW51b0lvK4LHoI9oUohetUolG4HMAenkTA79354S5eUZJA3wiQI?=
 =?us-ascii?Q?XHjvTXyv1u21+pRQtqOQypfgJ6tb/1NuxcE0kdC9kuh3XRllLVcVZ051h/yj?=
 =?us-ascii?Q?7Gj/GocNktSvzEShctQ5nZknGeZNVd/3Aj85P9uMJoIiNFJEp00Hp2K8Eb2O?=
 =?us-ascii?Q?7tjRMlcrTiW6zec4eXczSprHZJaD+Z4bMrkKuD+u9+2N2840NQqv0WIucmBt?=
 =?us-ascii?Q?m5P9UFjFgFN42H5Ib4CtFGyFHuwfOG++r8MfmuyC2FyhREFf4kFdD86ZELvP?=
 =?us-ascii?Q?xCnZ/hMYEUX5wHaYPROLxVf7SAQybMT0kXg+oCvFVjz8neTfeU2fggVXas8a?=
 =?us-ascii?Q?JR4lZK8eM89wJ+4j4XGsgO3wYfyvWW4fCdAlWfCMkQipIyUUqYMDm3Zfg5Tc?=
 =?us-ascii?Q?yNgYvpk2u70s9WAAD0OGxVX7IGPR2qsPy1B2JrmtyCKWWnksqXSNNwo+Dbaa?=
 =?us-ascii?Q?TZ0Tf0Vfq62DRTYb+EnxJDfaHFhH3NJu2hOTFpEC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8768.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb71365d-3c43-4ff1-2283-08ddf9815a37
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2025 02:40:11.5515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: roH80ODiJobIX4+5Pu+85GqXTWLcuGSBRAqrdEDyUfgYUVPuwu6d2rtN0MZr7nxYwPhrWFj7yzaPekGYYuGYn9LBawJnw70tnBwmX3zp/1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6352
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 4E9958000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: iqu3u5na1ih5m9jsj4bx3wycqbuno7xg
X-HE-Tag: 1758508821-561949
X-HE-Meta: U2FsdGVkX195TjNg1XYmrIPG/i3AdL1jeJI7x7SHC6ynyYKB72TlIBd2zIbJXSBTZoel4NUnElMhjNbgG9ZtBeH0Em4xLFUEQZdNRsBaSu/dI7zEGmQPmHe2tIU70meHYxPQGLVm0DjXC4x91RJcV9Q0dKRjSPMi7SY51qKBtAUSl/swiE3UDL/ntG+G+CP2AUM7YAUvr4X6ArtahMQirRTKxeyJCWCXL80ayntuKcBjhgZGA71rV6DxBZzeOFXVO5AtirPqlwjH4mrt+JCXwcvQrJWL6FtyyGXvUTvKam0l0F2pfAQ30xFcR5dPh6rEpccpDjyKSfmYnBYNGpDBH0M/7W2rq1FrV8NKXortfWrFKduzLnB7PA2XyDhTty8QgZx5drT8sutE2ROua98Zj5QcTYGEXzkEwwJJunhXPtVVhFqlCXa/TsG/Rpz7Xb2t9ohgkwSkE9NR6mqYwIIXsAb4gK0zZjeZtWo97tEdh3MAQ/wljsPeKyyMkkKHVq72A2psoSFTA2r/8F28G/V7+nOJJxIMc45zNp/fZGXrcYl4igqucUNNAdJv3mhMNEkTTwqbFqq1CdElkqYIE3gIsohdOjLzKRkJEgIZZ7k+rE416pPXZvfEzkBHjWpuhQpZq2+2VShzSxh1BNytnY9/eqOn2oQB8nqm6P2oV3wVfUB9ljgLnycYN5EolqUhakgcyzS1FcAHDNw2E1rbk5Icx6S6PFpGYapTVnje+SBQ4hZsF2Unwe540lxTNEChor6EoaXUzMyAeXUuqRKiPQRm6w+imDxwmlNJvmdP9E2MERNDciu6THBk0B25jPMpPGQsfEYUUj7tT3LIgmRNxio4kHkwHjv8UHhkzoSqpFZ1a5IhZ34omr9V9Z8FlEumU+1I976Fo47QVLYcYfS8d80bG0YGn9zzDYGsav3HShfIcapyDWmGsNr74+RtgDvMko7QX62ZZc0u2mBgsCk1Yvk
 zhyfoZGY
 MUeIdmzx6UgqE++kqjqlrpUlw1N5qWfOxet0FbZiqBHs2zwPdKcX38MWzoumJx2mRiS519gTA52LLNrQYaVFPkPf95eKid7O5ARDu4VmIhCGTvyz4o4D1Jd9NZlUR5FdiMrnsw3xq9+iWSXcwDyM3jQuUGCUd8jHjKVu08rqwomML+85UOtZrEAm6TOWrIAje0kZsX+JUinnChpDgKlREbQYJ3cjLYWSR9M6F0Y5yf0pAlXu/1kGQTbnf27FcAS7rNUaKiYcKVb2IFjPrrFegd09X1BmjZAjZusfQLAWkrOx4bwDCRkXPdr51V/DU7e2HLNBVDHu5t3sXy1+pfdv8W7LVA3ale9pSQZlnbud3tKZKQUANY8AU4hhY9G6qKFVv2GPXisnuS2iTnrvAvtlLWIUzolducy3Yb8bnxpHhn8EiN3ihbhd3tS7pocfGhpJnu/Xav2rLgrhHZkj8FP65P/Hu2kF2m9K0TCgB3H6ZRHUvAtgtM034qBaBIivV0AAz9oqYZSoG0KOyy7M33zzCPd5uqKbuzlVIPCR291IF4LMHGCCFAV3+6OsL+dDuPt6IuufrFaiE7h0srOXCE8TIYgI9kwNLFxW2W07FZRASwHnsenf3o6VJyoEC0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 Aug 2025, SeongJae Park wrote:
> On Fri, 29 Aug 2025 15:29:47 +0530 Kaushlendra Kumar <kaushlendra.kumar@i=
ntel.com> wrote:
>=20
> > The fread() calls in read_slab_obj() and read_debug_slab_obj() can=20
> > read up to sizeof(buffer) bytes, but then unconditionally write a null=
=20
> > terminator at buffer[l]. If fread() returns sizeof(buffer), this=20
> > writes beyond the allocated buffer boundaries.
> >=20
> > Fix by limiting reads to sizeof(buffer) - 1 bytes in both functions,=20
> > ensuring space is always reserved for null termination. This prevents=20
> > buffer overflows while maintaining proper string handling.
> >=20
> > Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
>=20
> Acked-by: SeongJae Park <sj@kernel.org>
>=20
>=20
> Thanks,
> SJ

Hi SeongJae,

Thank you for the Acked-by!=20

Since this patch has received your acknowledgment, are we going to merge th=
is=20
patch? Should I expect it to be picked up for the next kernel release, or=20
are there any additional steps needed from my side?

I appreciate your review and guidance on the merge process.

Best regards,
Kaushlendra

