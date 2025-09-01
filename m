Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 940A9CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 05:44:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1168E0002; Mon,  1 Sep 2025 01:44:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952788E0001; Mon,  1 Sep 2025 01:44:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8197A8E0002; Mon,  1 Sep 2025 01:44:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DEE78E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 01:44:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C58845A65D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:44:01 +0000 (UTC)
X-FDA: 83839590282.05.0BFA52F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf10.hostedemail.com (Postfix) with ESMTP id 81E84C0005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:43:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CbrG5XEG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756705438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXCNcXKhlhotX0t9Mw6k6FMyfCpukDSCMRR3F0FyjqE=;
	b=3barzh4f4km0s4uOD6hDB2F7l3v0H/rIR9K0vtv4NdKcWmXOrAlo9GOPVhnsKzA+UEGlXO
	vbjFIWdjVeLHluUywV6muNzTsMlevnwXzCoF8wCIEyAZIUx23/x8iC4hiSZnIEehLr4BmY
	BWETU/W1rTTdDIVWSk8CNG9IFKv5bJ4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CbrG5XEG;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756705438; a=rsa-sha256;
	cv=pass;
	b=X7kAbA6SkqTYyLtb084UyWcyCJD9hEc+ZOlJxNUYnMgIFalA72ccy0YSBawQo75PvGxlWG
	57Egy/0meUwkg6hRiibR7sgPNc4NgzDoIKF+RcwGlbDKSB9AWm/FqIu/QwdlqJtyzUidj5
	yOEXZKwOZhqrBnsrbqb9Ezlu+E6a57o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756705438; x=1788241438;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6Xr7Xz/Lz3IlPOaG9aDqq05AMbXhjhfZAFrkEZ4WUJs=;
  b=CbrG5XEGWAIDMxK+ig+zkRlb40MqHZaE5K/j1GSSLshtTZyBf9e1MO1i
   NVsX2+g/awBOudnZiLIUief5w7mbQsE8ajhK8N5setl3g5MZLew3Eo0Yl
   wLNEhfJrOXRaVmcmzgCkQT0zfn/aA6pg/0k36lxwDh+ukUfTTet1ogp7v
   AI720DC1KMeE7Mdm0/fGhMMYOneJcn0f/viUhgCP/U//4kcjqjFmrR9aV
   vJHGF/rmmpl76Ih1ITmOZvq+3fDMLJQA8HH15QyNiFK+Z566tck5TNlDh
   yNdxCXuRE/sjVgE3dO/AaUidarcBvW1w/+pattJHfu/NV9kBOyBLzLM6P
   Q==;
X-CSE-ConnectionGUID: 1vEe9CXpS5yXtiEQBl3qQA==
X-CSE-MsgGUID: Iz2xynyWTnO7eNIcddl0mQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="81484455"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="81484455"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 22:43:56 -0700
X-CSE-ConnectionGUID: b4Ki2514Q9WpJm/ggLZX1Q==
X-CSE-MsgGUID: 7n51i3rxRI+k2SgBdN0klA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="171666683"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2025 22:43:55 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 31 Aug 2025 22:43:55 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Sun, 31 Aug 2025 22:43:55 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.87)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 31 Aug 2025 22:43:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P+mkhtlnfBybhaz/9oKdFqbS71ZLIqG++AKxuCAQLoyeELIgpk8vQKDQW/BllL9yml1Gbcsx0Y2pNabNimRgGj2JJ6/6O+X3nSlCzanPxwc6O+jJIvoaSss7IEZjBt0f47GpKP+YeDER/jFqIwsgqTtzFOuWuYKo4hSr5A/GIYe4G55UYrPJWoiYN6zn+pFGTIxKa2XyXhFunE+RyooB4OX2CcKsxVFsoRy2XwJ/d/3HIV43T0V8T729xEHgXfk+bQ7ZLVME0uMgNTAsU9TEOrupvbfVeIXAdecutYGVoxuz6Ymr+BoX+ric+73cdHRJ/PuUopx+rmbKZUlCsR2v9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iXCNcXKhlhotX0t9Mw6k6FMyfCpukDSCMRR3F0FyjqE=;
 b=XMbDkeFKiq6mtE2zrE0LJIK0V9W513lUMyWZ4LO6Z0lNJsWuOB4sfY80LNOHLm85rk1uGwIe0gjlfGo8ZzJRH3C7VJB8iEYREutpDVAvAv5uFN035xbiyJAGbWsJBfuZn+fq29z0hS6HwoBuY49oe/SRJFo+j07JyuuRChJHYNyoDS8M7yV3GWCfie55hhKgnZkKwFs+3crH7md5fTu/1Vu/xaZFAMk/Eio137303Hu2FnOTsfSvJ0mS9qPCHgvIGQQw2LLY0aHjaUHjunMJNqSJhNUC0Wwv9nri/b0yCYUG9nWu38Yu5GFeLMdxlgrVzAuw5zs/Tk9M3iXtD2VUJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8768.namprd11.prod.outlook.com (2603:10b6:408:211::19)
 by IA3PR11MB9350.namprd11.prod.outlook.com (2603:10b6:208:574::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Mon, 1 Sep
 2025 05:43:53 +0000
Received: from LV3PR11MB8768.namprd11.prod.outlook.com
 ([fe80::154a:b33e:71c0:2308]) by LV3PR11MB8768.namprd11.prod.outlook.com
 ([fe80::154a:b33e:71c0:2308%4]) with mapi id 15.20.9073.021; Mon, 1 Sep 2025
 05:43:53 +0000
From: "Kumar, Kaushlendra" <kaushlendra.kumar@intel.com>
To: SeongJae Park <sj@kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH v2] tools/mm/slabinfo: fix access to null terminator in
 string boundary
Thread-Topic: [PATCH v2] tools/mm/slabinfo: fix access to null terminator in
 string boundary
Thread-Index: AQHcGu/LBgr506cTwk671GD+LyyI7rR9z0Hw
Date: Mon, 1 Sep 2025 05:43:52 +0000
Message-ID: <LV3PR11MB87687785FADA1665042BF83DF507A@LV3PR11MB8768.namprd11.prod.outlook.com>
References: <20250830172022.1927448-1-kaushlendra.kumar@intel.com>
 <20250901032320.59995-1-sj@kernel.org>
In-Reply-To: <20250901032320.59995-1-sj@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR11MB8768:EE_|IA3PR11MB9350:EE_
x-ms-office365-filtering-correlation-id: e9b39597-c5bf-4958-0c0b-08dde91a88cd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?CFaz9621MixPX5wUFL1O1z9AlxFb49AZOdhdkjtJ0vZwJtBnWqgRYhYMtaFw?=
 =?us-ascii?Q?8BwoBIRcI/wXUt+DnbRXEtER2YoU6cT/P/uuR/YwRBKtypFV11m6YH+QdZpi?=
 =?us-ascii?Q?5+DE3REJreLzqL17WUVC+EaGcLSQJo6wsKECup8EtsRrxqHxf7UsuYF0ZUue?=
 =?us-ascii?Q?AjqCM3M0ZydPhnVGd4tq4tuldKvbFjLQsSjTi5yHuO/S4yWKEzs9+LWpiEmr?=
 =?us-ascii?Q?CL5F+1B9F4D7gwX0G3MfeUjYxIX/OoEHK2SPhU/Rds6dC0v+jE1ofDq69KGI?=
 =?us-ascii?Q?TN0pbsAwkBeCJm0DZKZXR9DZW2J4GWwP1qJ1pHf6wuisW8fCAZe40Gia+TyG?=
 =?us-ascii?Q?0NDIhAipHMWSgK4iNlypliHNC8FfCB2jMmpJS64LDenPKa8Np1MiMVhtr+Gz?=
 =?us-ascii?Q?r1Q4LIfCUXotwi4iw5JELyW4esUzzcdxcDuPdRvEdVqf42aNzcJjocFGpYPe?=
 =?us-ascii?Q?FqD/jiJtmgRX3KeFzPRcfjD220YRxXGTXZetZQU4xrR2ZHBtKNkkJglo1mSx?=
 =?us-ascii?Q?QzPJIym9hTBnWCrGkWoTr8ALCt8h/CytNjxa4ipXiwcGxSeHf9t89IuyRBd+?=
 =?us-ascii?Q?m8WMDGsixcN9cyS3mJsGwlrwi/dOyTe7zcGMf8Y9jhTwcPrQJR3k/GZ2DZbj?=
 =?us-ascii?Q?FAXMEdtMpmYh9FVOLZ6jvxfgonlXOOkwiauyc38fMjG2zxpGAledSsB9C5aq?=
 =?us-ascii?Q?8aflbNzrgKuXUl3JSo5HEGSXFV+HCmurWow5bIq9AYrfB3Qi6pJMjg5WWZdQ?=
 =?us-ascii?Q?mPH9DzopoG/rlQZrfLgwigR/4C4JpGotfKfyN9BtU/dFReAP/56XvcexZ5SL?=
 =?us-ascii?Q?fMUurvfVqMlBCNNiB3aleX67mjO8oFcXiC+aY5EXklf22ZIv+07hOt6BR8Om?=
 =?us-ascii?Q?4IRrP3EKwHCW5mM5SgdTqpSLbgEVik8hSixUwBSpZAI+PBA0p648xgcFOlMG?=
 =?us-ascii?Q?b26srqBL6FKOsePfILSHu2lahKfhe2bVTANbW7goFscLprod2HIzQwlE6HmR?=
 =?us-ascii?Q?8zLz8PiuQJAgZ/Ivprx4CEskGmSevP7JIHRuA95tyvWzW9IclMWmYxyenx6O?=
 =?us-ascii?Q?5zuFZLwFrE5pxDW2CzJOHrf2iIb3LxYR1Yz9lTzK6veX/Mfr7doSpbS7Tmuj?=
 =?us-ascii?Q?y/ZT7TORGXlwMC06P5bxZ/l87fTr+r3xELjpKrlPjKNyYBZVOJXIxIV/n31W?=
 =?us-ascii?Q?Kllv/BBFj/sGR5VJZkCI2rBKc9qS/0Lw+TdeDjB8KdK+yHemnegKQzKSPfeP?=
 =?us-ascii?Q?q976DrmXkgWwSxezAJVHJe5SZq+FxkHJLjijEHdQMG+W5seyFNWmZ84emqt3?=
 =?us-ascii?Q?QLKyPxklOV+qwDBrh5rFWBC4nNtL5iHS+rlmawHUGlNiuv/zr8oLngoChOyz?=
 =?us-ascii?Q?jOP38S/fNWwgXaFdNMykM5cKJfBqimperQJi31GJ+DLaFM72dHO34mRFV7nx?=
 =?us-ascii?Q?Fk0mo4rFV9NMJ0xknVLTuatkkQGiZ8fznx+M/GhN9kwSi8O3Nts3uz3PS8TT?=
 =?us-ascii?Q?+ukumpcEj1Np148=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8768.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZOOgaKOYDtE1DruPO7PpdWrFSIrZaoyA63i11QGkzEAhhNAU1J82ewjZHeJJ?=
 =?us-ascii?Q?67EflA16PzE9jP3VfqUnnAEV4OKQPIq3hnVK+x0/3Iit3NtwWt+XFmK69obt?=
 =?us-ascii?Q?PrBUBPdOv8/jEjZ+yRYJS77kuTBSjC8066fUaH9SgftTqt/Ac/428w9yZq1n?=
 =?us-ascii?Q?vEqLPInapw2pf/xXKuqf7Nq0Yzty1ncfvikb0LYKq4S1KN5oiH51i1BZfCGQ?=
 =?us-ascii?Q?M4BwTU6nCAdweJhj4/wg9gCS3xgz1pJeeW06qgn77MQlAgyU3YP7OkOtXw2S?=
 =?us-ascii?Q?JgTEKtdER4nKkTZ4kY1yLC7GWQXOOSbG/kmbPCn2/9NOFayuNjFgYbLC23gk?=
 =?us-ascii?Q?n+FHSzwH8YUY10L2RHGxco3qMOZ7lwryM8vaRMdo3x4XM5BGuwNhqIq1coPZ?=
 =?us-ascii?Q?ixlUKeoN0C6IoFEV/sySSBq/X/R56Mi03xdeZae5/5XLgK8ZWamK0FhAs4bh?=
 =?us-ascii?Q?FMjPdNSHM283P+qfggmZX8RRwaYTZIQkLw5MD+w5T1yDO76B2rbwpfvXn66n?=
 =?us-ascii?Q?kw7q6re0ei7No0XvUwCY3x20An+1bJ2R4/w0B+YaO3ONs4clD5rn+9N810yr?=
 =?us-ascii?Q?6Z07EpOonVOzFnE1IMLHxFFpuy+MqVBOAHXQCpUs+bJmpb3cMgw9gyu/gML0?=
 =?us-ascii?Q?X2GfnVrJ/bMPRdKG6Jo71JCw59/nUmMHil3WhewKWYU139aini0aYQgHqyIe?=
 =?us-ascii?Q?3NnL2nt8E0SuuvHy+L6XyXUqbEHkkzvjDyXJDFBn1amNJf8vt8PROYJ8Rj08?=
 =?us-ascii?Q?iZOnzP1nNyqcW3PfL4FlO8zFcaI3MuihF3r9jOiqjxYpK6hJnk42/vFTfVIE?=
 =?us-ascii?Q?/YELa+Qk1LIdht7cBhZyBCodi/Um8twmFE2mXJ+oDG1AC725HTO7j0DLwSB2?=
 =?us-ascii?Q?12m07nRTRF8NJlUGKaN0D2Zt+lRvUWMlbOJ7abSuZ802f/7gVjEtJx8CblaN?=
 =?us-ascii?Q?QDiYKIMom8gq0Cxbp5bk52RnYmsRy/gVkfShjuskSKmiGRVux313Phb+Xa/f?=
 =?us-ascii?Q?CNytEjPxuwWdO30CvLMjclL5+ZTmRjLwp1tLEv/jscYk/DC0HUV+Q3t7p9Mf?=
 =?us-ascii?Q?1f1qjhdsww0m3h8Id3LD3Iyx+CNWIxj/MRgmAxVNqPreLS/uLRnfIr+DsmhH?=
 =?us-ascii?Q?mdjad3Yi1tmu2tn40PAnhqzQ/VAG2KEH2VYrzN6KHCp3aLwKvO5p4Cel6rpS?=
 =?us-ascii?Q?yCu8XednrBl4okR2zodG1Z5e5iEihZHC0wwCcW43bueEJIyI1mrKy1ncuS7r?=
 =?us-ascii?Q?+HKkGArW6TMFWAgbZPmOLmfDUX6txtuSUYGSbzZBcRISH3rkf5zGVQvcNS7s?=
 =?us-ascii?Q?rfrfZbethZu5EL8VyfLEaldic/mmFemwYi5HDXHzbwTKg2X1uB5WHbJk6B7z?=
 =?us-ascii?Q?qflSUwLXVVwLG5eeF7vC6cOWjZyQG/H5hs8Je9wr8h8RYoi2ARwYECMl58QG?=
 =?us-ascii?Q?kF62mxRyEbIY/keMeDeRsPhRHq4rOfjyiTGTmtHoRuROnwiEyh2RLQ/bMetl?=
 =?us-ascii?Q?uVVd0POzAuPgpiC6uvX/+Zsg+i/agKsCZpGEF6gFs90KmeD1BnreqDYNFAfH?=
 =?us-ascii?Q?LETWtS2eI9zn82WQ7Af0GhcEQ+GbdQMNKCZ0ZBjOl03ZumUfTJPNsJTfbjn9?=
 =?us-ascii?Q?Rg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8768.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b39597-c5bf-4958-0c0b-08dde91a88cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2025 05:43:53.0021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QTc8u5qXiRseETXGQV4L5TWn5M4RD+1IY+3hYEBmrTUqax1IjxXg8csLIiBH9I708ZRMYTbVwetKbgrRj46aeOL5qGY7K+lodG3Zh577lOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9350
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 81E84C0005
X-Stat-Signature: kkb9maqq5m4byd59hrzndt7radqthhgd
X-Rspam-User: 
X-HE-Tag: 1756705437-442429
X-HE-Meta: U2FsdGVkX1/psc3qG59EBSeV3hzlu+NKGTJyQW0P78Yx+4tD58hceKj8cxPCo3+TRNhcUDNBPeqXDzfeGtJxIJqJTp42xg5cWkQ0QWfwPI3dYBBC6nGlcXeRnjvFi+yD3pDmipGyAuI+gg0gdRATOXXqDyM3Ir9SdJK4iYZcteZVXdnBMgtQNAJMCCABE3xddgEcWVyDAS+ccV7oDLFTFG0/SyvdL24fcxnR389FLR1wzxqIv6J+HfnEhT4ZGuHJvdhZVGtNxkdFpP4jtL81rnruMr74BxTYo/ks9BgnSzUzQe5GYp8Jlf0t6v/aTdo4dmZDJt6IshOEk+kl5ePFzkpXRZsEZ4UZ+W8nLKtLPdQX7Uq78bKjZyXg8+WNoaCr09I091IQaNc2pl7tTOS0FUZdfdJS3/DkeaZO02Sxs1Cof8p1/zYD22g2fTUDv4XBN5SV8HO/Vxg4vGK5wFWmKSljV/DoWbKdROIpPtZe9xQI3lG01GKIklDeyTQeouvfCONQjX9VLeg6aGRsOaJYPSR9bt3AepUjE+z5BKDFE76KRbroMjZ0pdshnh3EkpRbOfZoWkfjuYCFBoKzQC5F97KByElUEdZVO3yq2o4facjCX0QwqiilZ+cyo3B+6r0/l/1M7sixP0b+m03Qx6Q22yVCYt/qG6NGjVF9dVjhvm3HSO/Ga1a2XcSc0jnBIFwfqwsSLjUKPGud4+tLhdp52c77HWpb5ry9HJFYjnFt0+Wa3lpLZVmtUF+A0AsOrMzsAm2gfcyDpWaU3om1StmQHV5hOps5XxD49ocvaCylK0QCuATGm63giMkzgeYTIjimkLBeMGa7MV+U+5RP0muiLYle8dhqr62QlPVocMSfC0/FGRnktuImW1ZfBSDNpWtfA+oq2PtA7LJKZPK+dZTd+5S6t6mpxdYXyaP/T0zcR7hsABts4NNZfG9ESoDm7rNgPawikj5rBcp+dEh4bdH
 S+EVgd06
 ND0Sm8fuUHqdtlN5giGT2SMJnlZ0fKamv1t3qTILrrQpq0VYNQQtU2Zk8hvLr+48m2oMpkd7bC9agIKpJt9LnfN1VLLy1wjZIvsXCk259eIX4mzCTNCmIaGdf7iL5tQg3oJs6Naw9wGk2AnM2arSJLMAEV+r/rBwZxQlOiiHDQyKW63wB6katxk5n4hkv7jJsiVFV0ebA7zz2SpKEcq3pz2mLnGOJXukL5mLNAJpaVNyGqjySOBqZQdqwTeo1VztmH47RTYqk4nZbWQ5ir3oUiR4FZ972DcoxlzROAK3G20vAKT8G1igE1zmYqIzKthTpcZFfrlhpAOEViMYLnzujxX0TbZNUX8trHy1upiQZvRAjLjrd6QcGgQSg8HpbcX9lO/CorWeBfvVz+k63v0rQdiRzTLwi/ZNrXyB14TY4oBi9ppuJI+RQvMpJM7XRtJDI6PoJQn+Atfnanxj6h6yLy/pw5wzANtAHu2BhQAIeMRmAx8v9DYRjUlDG0/QmHZt+TYi8z5YwBujpAY7Awz1yQhJAywrYa/mbm+fYGsTYXEqWD9x8gIUTVUFInt55tM4B8G9RO4YcF457rMsx+GfksJI9K8YGEya1BY7Jh3rRQQp+to4+9fztGuxTzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Thank you for making this change.  But, it is conventional to put the abo=
ve changelog on the comment section (after '---' line).
>=20
> [1] https://docs.kernel.org/process/submitting-patches.html#the-canonical=
-patch-format
>=20
> I think the above blank line is not really needed.

Thank you for the feedback! I have incorporated your suggestions and submit=
ted patch V4.
This version fixes an issue that remained unresolved in V3.

BR,
Kaushlendra


