Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A36110AB81D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 20:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 587326B0005; Thu, 26 Mar 2026 16:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 537B26B0089; Thu, 26 Mar 2026 16:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B1606B008A; Thu, 26 Mar 2026 16:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2635C6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:13:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D88E258466
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:13:56 +0000 (UTC)
X-FDA: 84589315272.14.A81F196
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9A68710000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:13:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A5DM8aGB;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf14.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774556033; a=rsa-sha256;
	cv=fail;
	b=E/v2vOnv2Nxa7/XU37xElx8sSdLwzoKa42BL5OStrLjJAtecooZtsVM0XRTt63jEhiv0e3
	hHi4n8Qv1vpzFSb7qHO0lgFrBEyF2xULW5naghfhyx1zhTgCzMBKPgmWjk7/3XZ3cV5stc
	A58uGobt4/5WaorIG/aLbh8e+V8n5UY=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=A5DM8aGB;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf14.hostedemail.com: domain of dan.j.williams@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=dan.j.williams@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774556033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fxr6eSBhTe7cjzwVpA7NaaY0/9dEuis2QgpVLdT0MNY=;
	b=YLrJR+Nzvh/5nwj/4HA+oSTXfeYtJDr4wskUSlumC1tLQYA7Unb7pM2ES2gt3SDTZZb82k
	weAR7tStglj5Sc/77XRO09eLWyOSEM06IjJIV+FQ8/ytl+LqSwT3QdRB8TRHlCMGRd9C+9
	CqLZrG+SFyrfIFdP0BocMKQMVcAZjAY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774556033; x=1806092033;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=cb+SBtpeQlKfa79fagvT5f4udfKUvfqNkpW40Wbvvtw=;
  b=A5DM8aGBCV95a+LssTDRxRPaBP1fbtcRv3j/HhDRal/ouxzkaDo1sa8i
   k6juUR0dUq0NW5QFkRDe2ApC+5fnKF+EpTX1eDMUc/TIu/NqD7pV2HAqh
   oKGTkGDFjDCK/1s76bqbgGJF4v+ePUYW12JojQUr6QKl9Gm/kNuIJN9Z7
   8GIHVQ7bmjtTOFChC0SHioykMJxbZPHP4m3hAgIexJqjSUs1dzDz0tR++
   XhMPuA+FOxHFKlr35TmgsxNbJnwNDpwm7dg5OYzGMGupgQJoFDV21OcuN
   7yJvcteTpBo6yQrp4AdfEWRXlcsQ6rYV/vAm0AEW2mVBoVMiU/IDBKH9Q
   A==;
X-CSE-ConnectionGUID: X72vRs45QiStcy8nuE1sKQ==
X-CSE-MsgGUID: TUPnF2n0Tgmgw0Fy28xmkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="87009746"
X-IronPort-AV: E=Sophos;i="6.23,142,1770624000"; 
   d="scan'208";a="87009746"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 13:13:51 -0700
X-CSE-ConnectionGUID: RTNnGcP2TaureVIcb8qHsA==
X-CSE-MsgGUID: 8+kOP1Z3S5KleScJux6GEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,142,1770624000"; 
   d="scan'208";a="255603788"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 13:13:50 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Mar 2026 13:13:49 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 26 Mar 2026 13:13:49 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.5) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Mar 2026 13:13:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XNa+Cd6D0L5o8x24i9MaeGFCpFV6ZfJ8Eg687rMVJ5y5gwO5zMDMzB9Illei0WUzs0U469tEeUCtinCMWz7NdAF46ZVgaCBUWzQmaPGR5WXPI7r8aABbEh3ZpCq7Ysv3tqGZl+CPUn2GgvLw6MxmJY3sDOSpnh1FJqGRIHWH/pN8yDDrv1TH1P81sWoOvntriPXbkz0UMo886rwZ4N1T4ZhnY/WlLNzHO8ztU0AaGU+aS1rZPG0MYiJCxomMlfhirT167frubs0AM29juEn9n6BaVKQnOimiOxeZKM1O2lBE/y9TLE70dlHC4SUR8o2zqvXZZ51Vsgdcm0Nnt6649Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fxr6eSBhTe7cjzwVpA7NaaY0/9dEuis2QgpVLdT0MNY=;
 b=ELDQjj+wVxhaQWmaYGc0YYxsVYvgqpLSf/sf/WOjcGslSYUSvk80oLFuOQ8riCv18onMbdqk1T/SUuoWemQXWKMTi/cdJMDfJOlneqTc0+F+rBQksSG0w0+rYdUenH39/t1loqDAqrgO9l+azdlMrHMeBxPy50ltHcaFLZQTEvgpH79DQj3D6ZhjJsrv8AwYk8WVRf7HIJ5QYCdoJ1zGWEithXkBwPhphI7xytmjOR1S5IXMkUkNS6YhnD23REWQuvXWlC4TJveUqmefSaJ012tR0wZlx0w/F7NJXScgVdCh9VlVVAZORAS+GQGLEtrgMx6ziW6OZUb8QlhvXA2ehA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA3PR11MB7655.namprd11.prod.outlook.com (2603:10b6:806:307::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Thu, 26 Mar
 2026 20:13:43 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%3]) with mapi id 15.20.9769.006; Thu, 26 Mar 2026
 20:13:43 +0000
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 26 Mar 2026 13:13:40 -0700
To: Rakie Kim <rakie.kim@sk.com>, Jonathan Cameron
	<jonathan.cameron@huawei.com>
CC: <akpm@linux-foundation.org>, <gourry@gourry.net>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
	<ziy@nvidia.com>, <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
	<byungchul@sk.com>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<david@kernel.org>, <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>,
	<vbabka@suse.cz>, <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<dave@stgolabs.net>, <dave.jiang@intel.com>, <alison.schofield@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>,
	<dan.j.williams@intel.com>, <harry.yoo@oracle.com>,
	<lsf-pc@lists.linux-foundation.org>, <kernel_team@skhynix.com>,
	<honggyu.kim@sk.com>, <yunjeong.mun@sk.com>, Keith Busch <kbusch@kernel.org>,
	Rakie Kim <rakie.kim@sk.com>
Message-ID: <69c5937425273_7ee31005f@dwillia2-mobl4.notmuch>
In-Reply-To: <20260324053549.324-1-rakie.kim@sk.com>
References: <20260324053549.324-1-rakie.kim@sk.com>
Subject: Re: [LSF/MM/BPF TOPIC] [RFC PATCH 0/4] mm/mempolicy: introduce
 socket-aware weighted interleave
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0123.namprd04.prod.outlook.com
 (2603:10b6:303:84::8) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA3PR11MB7655:EE_
X-MS-Office365-Filtering-Correlation-Id: e4407161-29c6-4ce8-3898-08de8b742d96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: dgt6nK5VjNgH1/JEiqR7HpiyBJ0KsSw9ZJeLcLA1+CN6ulhZW5uU6py0g66G0QsP0g35osJosFeq0YTmhTxR95Lg3d+dIAaibrKI0Eu6l8qkqEkLRkqO5N5z30HTjYJw4gDw0C2GJKFGFjwNyrWLhvjz0/jrMMvDkZItFSHOOYPdUow1Nietq+f6+/ZOTx0VEcaeEXGpA7/ARYmJbk0FzjFW15ez9CFrZbd5bPJj3jAzh+Lw3424Ydw1A/ee7tbt6hcz+jDO4lu3y2kjyPwjvrpnNAoY6gsz7zFDYm1ElSqLcWIZzFI4DC482zHO4VMgLZbqJ0NjyEmHHA/Q16k/TzSGbOeNQqIf2ZSMASfSim/FueKc+hR9yhPTO3yFIWSGaNMmjw91m8C8yMkeBOzYR4+0jG8S42nfmm6IMRXLQ2X01nvOSutOzIEuzbNYOK81Lv7xKw8pIUbsgBR2G3aOkz/iCnLgn5VmIXQn19+1D0PJ5rLr6B4fT1qg3sb4WNBzd3P87B67WXEuVzJQIbfGm8dGZowTInLndgr2SK4wnvcIhNfoKPoq/5rSPbOKeXKE1dGZW7d0Al2O06egEkHmUJDCPg1841s0CYvlPtPU0se5287lt5yFf9OqUf/FIm8eAWKX1faOulhzBZYeI65E8Ke6dptRVsft2JhzgBqh6NqiiMQvtZhDm2ADL4BqbzccKyot+ivBVaVArgVbxEdaJOXWK1IWAIBkRrtm4kevTq4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDZHeTg5TUI4cEN5VUdrL2pGQ1h2TWNrQk15MXVaWHFTc3Y0Wmc0QzdDQ2dK?=
 =?utf-8?B?aEhYNUNiSGJKWTVFQWhLYVlxQXN4WnN6QlREVXNmTXl6S0hrVkVMNkVSem5C?=
 =?utf-8?B?amxob0hTRmp5bVNSMkpRMzhITVJvMlRxdzF5ampuQWtIZC81YVJxUHpEWTZD?=
 =?utf-8?B?WUJBOVUyU1hkcm5OYmZjRTZ3LzNKUE5BVXRiWkJOT0JtbnQxZnE4dGhPVWVI?=
 =?utf-8?B?bytrYU9vcmVYM2tCOTFiQytlUXFrN0doMEE1YnJJYW90UWFwakFNSWFNSGxV?=
 =?utf-8?B?dFZLT3B4a3hzUHRwYUJxS2JwSzdIcEgvbHAxYnhObjhjYmNpM1lOWUo4RTBO?=
 =?utf-8?B?MUtydXk1Sm5PbGJUdEwvVmlkbURWbXRveUU0Y21JZHMxVzg2WGU3TmFXVEc0?=
 =?utf-8?B?b0wzWG1xMGFhaE9VZVpMOGUvNGRldmxWL2hDNlZ5dVJDZm5kZGxCeHBPKzlJ?=
 =?utf-8?B?c0xPeURGY1NhT0QvbjVVRE93SWtCcHJNTlUyYlRtakNyVUZ2bHdaaDZSOHBD?=
 =?utf-8?B?SG51aEZlWlRSS2RTTWRSTkJKYVBhNWUxbzNjd0hRdHNuZ2lTS1hZcm9QUlJl?=
 =?utf-8?B?MTFDank4TzdqWHMreHhJdlhkaVBncUxQcEVkOXpwcy9OWm9UNXo0SVBVOFRx?=
 =?utf-8?B?a0NsaFhQSDBBR2E4ZzJHakpZQTBjT1FZMXE1M0k3ZFZUWFJpcG1abHBpc3BQ?=
 =?utf-8?B?WTBlaTdPMDNwMFE1NTNZTUpmcmw2L29BQmFIUlV6TkNUcnBjM0hjUkNzZFpn?=
 =?utf-8?B?aFFUaHN0Y3hUZWZzRlZDSUMzOGtsTy96UlJ2MS82Ly9PLzgvcWh3R1l2dVFj?=
 =?utf-8?B?cHhhaGl1NThwMmtzUG0yOHEwZDNSdGRKYmppRkFVQW9XQklZY1ZubzJHRWkz?=
 =?utf-8?B?R1o0eWxubWtpWm01RElpb2JodDZZMm5DWHJLcXBRSVozQVNmUHI1RE9Ka3hq?=
 =?utf-8?B?Vm53ZERkSXZyaHFzd3p1UTJQMkhNYndpYm1kdHNvbUFROWMrYWtoQnV2bFNm?=
 =?utf-8?B?WkhCT0U1ei9VcExDdUlNWThISTA1MGxHQ0w2V2NTUi9LUitIbVBuN3JWNUI4?=
 =?utf-8?B?T1RXWDc5NWRwUXd0SU8yZi8zeHFiK3pwRlFMbGNKWUNEc2JreGtmaXZ5ZlhT?=
 =?utf-8?B?Ulo0U3NsVEw2M3JWTDBSRUFtSkdMSkJoMkhXMmpYcmRpZDMrUkliMi9ieElK?=
 =?utf-8?B?b1d4MFBjc2VTc0RXaGtFT1NicFJoY2NublI0aExDY1pEOW1ueUxBWTRlMHgz?=
 =?utf-8?B?bkZWak5KbGhUYnowdS8rTXFmU0U2S3ZOakFTbWxWVWVVSXVoOXI1VzRFZEw2?=
 =?utf-8?B?UFdqNG1wKzVNbmlWbWF3WmpCMWYvVXh0SWF5ZWg5ZmxmUGNTRUErY2ZuR3hq?=
 =?utf-8?B?b05qeDZObEppOE43Ri9HdWhRSG1ERStkQm5LRzRWaHlpY3dlSGhsa2Y4SHlW?=
 =?utf-8?B?dkF6OGNDK2dDWTgzcytHVmJ5U3lGT294SXRmbnYybERNLzQ0dUFqSDk4Qjk3?=
 =?utf-8?B?U2o2NVNmek96ay93Nm1IdXFNaXdXTzZ4OVREQmQ0ZWl0Y1g1eFU5RTB5dldw?=
 =?utf-8?B?a0dpOFptWnZqakprU0VzbDhKZTltL2oyT0ZlU0Jsa1NrcWdtWlZ5SGVCVmlJ?=
 =?utf-8?B?WHoxZTVUS0JCZ2drbFNJcktnUzNWQkEzT2MyOEpRS08vQ3NpTkJuZzUySUVH?=
 =?utf-8?B?cG9hYkJSUTJaNm50UXlmV3JvS3BpNlRSbWVzM2t2WEMwQ3Y2eVorZFJCekNO?=
 =?utf-8?B?QkdTYzB6N2RIMFBpQWljMFZ2NFAyMEhyckd6czJ2bmRqSGMxbEFPU1B1VFBr?=
 =?utf-8?B?YjFDUUoreGk5aXlQT1E3ckJGOFVvSWpoVWFxSmtUUzYvMXpUNzBqcll1dlN0?=
 =?utf-8?B?SGJINktSY1NPaHd0eVNReWVPUDlxWkUzSm1RaHJRTy9iZitWK1g5WnpiZGRL?=
 =?utf-8?B?UWNBTDhpbFpOa0NNV0tqTHhQU2NBK1VyUURPbDBLcUZBQW5saS8zVWVOUGcw?=
 =?utf-8?B?eWpXOXYrZFRuaElDN2daTWpsdlhuRnJPQ0dRcWQxclV3K1kvdzZ4VFpGK2p6?=
 =?utf-8?B?QUswUWtZVUVJeFF3dDNRYkVVT0U0aGJLWHJzT2E0eklOL1ZJWXowY3dWeXc4?=
 =?utf-8?B?N1NHWmp4TnpnM3VvUlhoRFN4UnduUGlVeUdtWG1jdFpIWThORVVGYkFwSUxa?=
 =?utf-8?B?NVhrc0VVbk01a2tCS1NjNFh3KzZLSm5TSDJLMGRvdHFOdkgvWmpleFlxYWcz?=
 =?utf-8?B?bmVLb2ZnbDVTQ2JpRnhTVzFQT3FFVm8rS21lN1lmTW9hdEV3NFhWdDFqZVRm?=
 =?utf-8?B?Y3AyVk0vS1Z1ZXpYWkpISFA3RmFScXBRUkNSV2xxdE5ic2NVUWRKdWtuUnhz?=
 =?utf-8?Q?GXHNeDOpdRXOzDyA=3D?=
X-Exchange-RoutingPolicyChecked: Ab1irHozw8AOGR6nl52CwcfsKYV9qEUa6y33nxrIWV2SvlIcrlqIs0B+VekUStAnmxYD2UF5d2+lApRPEoDbphSsMSl2cEfOAwgxBQuiULaynHoATzlmR0wdqnrU/7+uCw3luBVxppfZPms3mn/QoUd5qPNCjK4FNjgWYIRGWbTfD3nZ5UkgaWRa1PmGbR+hzqLhJq4Y03XhbjO1rwnjrb9A0aaJUyLR/lgmgHA6gx1l8UEFt3MOWRVnfBzA7luP+vyR4M+uHpQAJAyCyPIbLhgRv/I+rxGl1YiKIJRyHwCONdQwwIK4jQvaXFfLTHV7hT6ItDcLlLkAs3hSt64qNA==
X-MS-Exchange-CrossTenant-Network-Message-Id: e4407161-29c6-4ce8-3898-08de8b742d96
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 20:13:43.2539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J9FOqFXz+RDA4H/hFlZ1Gh/VXJXgxetJ/zm0Kf1DBnZM/5xW6m76cx9p7pRQAtkOl0pK3Zha8lPDhzwXJXBTmgcbZq5JYncou48KPZrOHLQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7655
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 9A68710000A
X-Stat-Signature: 9q4woeczwimdiq583yfawpjuqjpu6zgr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774556032-59634
X-HE-Meta: U2FsdGVkX1/pUH6B2qHcYv+MyLtka9OS0VqDdofsj1UmaredXM7Z+6XrTfieOmiz8Sq/QBiX1EW9EULz7mSMEASVgUEu90x1FofUiYforgMhu9Fy6WDDX/v0CYJs12/Svb0TRh/9ze4sHdAvNHIMoZ6CdYvOSXf2SP7VP4tZ5xzqTNl/vzuANSQ/iPPfNHlqFJAd4r3/cfRW7D3vmwZ1kg36QG/zKQ4p59V81kGwMk+VQvgwVPGpVzo61QzgXBWZyfDPL3HAIRP1PJMCFdj+i4Z4tDbwVZ5lgaQSDQI4d5O1puR6xfS8cl1s6ZDnzYy2C9iBp5HXemYqS+SLq2F+d7R8A+UUk34v4GkbQljURV5HYjum4XKbEQmsKcbVBl9KlCVcTmzxsFuaJne/+FNeR7Tfx0gKC1OMG07K7X8+Zw+er94TtR0NHG4IdZraC11dTqtzNXnXyHTrT7fn3Z1VYCFA2m2dp0P9eCc+3jKafwCJiGm4BOh3zzX0nO70cgNAP4JcGMUWnQYpEcTMt+wTY7I5IsbPndAnsKUgt8vI4ueQ1zVfNnDO4Y21INvJ8hM3tgA2rCyiBCkjQDTAQcFaLNvkcizZMkSy/6CvcazUZho2+x97wEPUGQQfYuvw6732dvmQ3/ZLrVdY3vk355pfMsFHeEuoI3mzqNKV0aTdQRIRlYSleOOvwp1xy5hQhyyhqeJ+rJ0VW4ep8Jj0cVurKOo13e40vAOT5wwE2o7gPylDJsKAVKoBOmV1EM9y7xiW4Qt65mx4aewdj0xKBcNYtpT787352kpuFLDrZV3PKLQo8ziwjGlp2tvqXpXSWUfbIVH/QUHHlPdOIhgNdnbkJGsUt3wMdcMSXpGJw3jzyyHCjvz6Oc/hpZSBFWd4H4BbDadAwDq4zQMoDVM6oKLp2KAjsCmJGXDhDA0dfKmvVlako679cZtdBJzUQo15i9ZvF4U5LthtpQhuzEIAuAa
 RHNZHhw6
 dVIOxOjhjlnVcu1NBdO1mnI8RZIN+1p4Q23KCaocmAi/QXpejst7nT0xylQTfgucGIPKCWPovDuQQS0OnLg3I0EES3Y6WwdWVYFPkVOlzKcURzwdlpFwo3MX1GjS7+WqiOJoyzLb9Zx0GJzTGqdGTnONKH0a6LcAMhsS8+R5bBRRugTJXhBSsxiWlL6n/ynvKFe/2ZEvUx4W8TypG6GVmW7BfuHepp9FO7w3Lq0NFRhz6fhpPn4xArODgBqu62p5RZfTbb6vgVGz95/3W323DdS1G1IPY/KFCIr9x1UIuKutefJGmZJPU1Ma5IeQ1GqMy0xyll0xUzUkpiB+u8kzYm9Vmuy8faj6cbfhhEso9BsK7s1RnU3sUV2YOJenSi4b9MEsVympkffvbSy5oICO/pvypPkmYf+rQwlHP/zq3JaOmWS6wEtqtpeRoNUU4B8hnjFuK687Wshg+hlwtsgvzjjLA5ONmO1VO1AlFJUYQsjsppQBiJXI4NHwwBMxjpDdDl1uRhhV32Zx5enha5h0PsmHT/W/cplquqCorLA93MzT9EjhrJh4pbVxngLZPALTmAzvC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rakie Kim wrote:
[..]
> Hello Jonathan,
> 
> Your insight is incredibly accurate. To clarify the situation, here is
> the actual configuration of my system:
> 
> NODE   Type          PXD
> node0  local memory  0x00
> node1  local memory  0x01
> node2  cxl memory    0x0A
> node3  cxl memory    0x0B
> 
> Physically, the node2 CXL is attached to node0 (Socket 0), and the
> node3 CXL is attached to node1 (Socket 1). However, extracting the
> HMAT.dsl reveals the following:
> 
> - local memory
>   [028h] Flags: 0001 (Processor Proximity Domain Valid = 1)
>          Attached Initiator Proximity Domain: 0x00
>          Memory Proximity Domain: 0x00
>   [050h] Flags: 0001 (Processor Proximity Domain Valid = 1)
>          Attached Initiator Proximity Domain: 0x01
>          Memory Proximity Domain: 0x01
> 
> - cxl memory
>   [078h] Flags: 0000 (Processor Proximity Domain Valid = 0)
>          Attached Initiator Proximity Domain: 0x00
>          Memory Proximity Domain: 0x0A
>   [0A0h] Flags: 0000 (Processor Proximity Domain Valid = 0)
>          Attached Initiator Proximity Domain: 0x00
>          Memory Proximity Domain: 0x0B

This looks good.

Unless the CPU is directly attached to the memory controller then there
is no attached initiator. For example, if you wanted to run an x86
memory controller configuration instruction like PCONFIG you would issue
an IPI to the CPU attached to the target memory controller. There is no
such connection for a CPU to do the same for a CXL proximity domain.

> As you correctly suspected, the flags for the CXL memory are 0000,
> meaning the Processor Proximity Domain is marked as invalid. But when
> checking the sysfs initiator configurations, it shows a different story:
> 
> Node   access0 Initiator  access1 Initiator
> node0  node0              node0
> node1  node1              node1
> node2  node1              node1
> node3  node1              node1

2 comments. HMAT is not a physical topology layout table. The
fallback determination of "best" initiator when "Attached Initiator PXM"
is not set is just a heuristic. That heuristic probably has not been
touched since the initial HMAT support went upstream.

> Although the Attached Initiator is set to 0 in HMAT with an invalid
> flag, sysfs strangely registers node1 as the initiator for both CXL
> nodes. Because both HMAT and sysfs are exposing abnormal values, it was
> impossible for me to determine the true socket connections for CXL
> using this data.

Yeah, this sounds more like a kernel bug report than a firmware bug
report at this point.


> > > Even though the distance map shows node2 is physically closer to
> > > Socket 0 and node3 to Socket 1, the HMAT incorrectly defines the
> > > routing path strictly through Socket 1. Because the HMAT alone made it
> > > difficult to determine the exact physical socket connections on these
> > > systems, I ended up using the current CXL driver-based approach.
> > 
> > Are the HMAT latencies and bandwidths all there?  Or are some missing
> > and you have to use SLIT (which generally is garbage for historical
> > reasons of tuning SLIT to particular OS behaviour).
> > 
> 
> The HMAT latencies and bandwidths are present, but the values seem
> broken. Here is the latency table:
> 
> Init->Target | node0 | node1 | node2 | node3
> node0        | 0x38B | 0x89F | 0x9C4 | 0x3AFC
> node1        | 0x89F | 0x38B | 0x3AFC| 0x4268
> 
> I used the identical type of DRAM and CXL memory for both sockets.
> However, looking at the table, the local CXL access latency from
> node0->node2 (0x9C4) and node1->node3 (0x4268) shows a massive,
> unjustified difference. This asymmetry proves that the table is
> currently unreliable.

...or it is telling the truth. Would need more data.

> > > I wonder if others have experienced similar broken HMAT cases with CXL.
> > > If HMAT information becomes more reliable in the future, we could
> > > build a much more efficient structure.
> > 
> > Given it's being lightly used I suspect there will be many bugs :(
> > I hope we can assume they will get fixed however!
> > 
> > ...
> > 
> 
> The most critical issue caused by this broken initiator setting is that
> topology analysis tools like `hwloc` are completely misled. Currently,
> `hwloc` displays both CXL nodes as being attached to Socket 1.
> 
> I observed this exact same issue on both Sierra Forest and Granite
> Rapids systems. I believe this broken topology exposure is a severe
> problem that must be addressed, though I am not entirely sure what the
> best fix would be yet. I would love to hear your thoughts on this.

Before determining that these numbers are wrong you would need to redo
the calculation from CDAT data to see if you get a different answer.

The driver currently does this calculation as part of determining a QoS
class. It would be reasonable to also use that same calculation to double
check the BIOS firmware numbers for CXL proximity domains established at
boot.

> > > The complex topology cases you presented, such as multi-NUMA per socket,
> > > shared CXL switches, and IO expanders, are very important points.
> > > I clearly understand that the simple package-level grouping does not fully
> > > reflect the 1:1 relationship in these future hardware architectures.
> > > 
> > > I have also thought about the shared CXL switch scenario you mentioned,
> > > and I know the current design falls short in addressing it properly.
> > > While the current implementation starts with a simple socket-local
> > > restriction, I plan to evolve it into a more flexible node aggregation
> > > model to properly reflect all the diverse topologies you suggested.
> > 
> > If we can ensure it fails cleanly when it finds a topology that it can't
> > cope with (and I guess falls back to current) then I'm fine with a partial
> > solution that evolves.
> > 
> 
> I completely agree with ensuring a clean failure. To stabilize this
> partial solution, I am currently considering a few options for the
> next version:
> 
> 1. Enable this feature only when a strict 1:1 topology is detected.
> 2. Provide a sysfs allowing users to enable/disable it.
> 3. Allow users to manually override/configure the topology via sysfs.
> 4. Implement dynamic fallback behaviors depending on the detected
>    topology shape (needs further thought).

The advice is always start as simple as possible but no simpler.

It may be the case that Linux indeed finds that platform firmware comes
to a different result than expected. When that happens the CXL subsystem
can probably emit the mismatch details, or otherwise validate the HMAT.

As for actual physical topology layout determination, that is out of
scope for HMAT, but the CXL CDAT calculations do consider PCI link
details.

> By the way, when I first posted this RFC, I accidentally missed adding
> lsf-pc@lists.linux-foundation.org to the CC list. I am considering
> re-posting it to ensure it reaches the lsf-pc.

They are on the Cc: now, I expect that is sufficient.

