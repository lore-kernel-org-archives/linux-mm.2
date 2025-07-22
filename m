Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7085BC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 04:41:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA3F8E0002; Tue, 22 Jul 2025 00:41:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2388E0001; Tue, 22 Jul 2025 00:41:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 979448E0002; Tue, 22 Jul 2025 00:41:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 84DB38E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 00:41:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5A7B12E48D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 04:41:20 +0000 (UTC)
X-FDA: 83690651520.02.461579E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf11.hostedemail.com (Postfix) with ESMTP id C441440002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 04:41:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="iqh/fqDt";
	spf=pass (imf11.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753159277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aS874BCJHKtD2xcXAYohdTfrmdnr4pC6ToeOtGk77PU=;
	b=iudU1J9Wm2XXPKmhmCK7Lx2Jyb153N3Mv3ySGB5BBKxyTlhtwCVyD77nWmP9/VmuMfUaJg
	zGGJK/p4wt5eT1Qy2kEJNPb7yRc7o83ug8hBkLyamJ3hNDzGAxvUdiEcxVMFQ6oxSLK1iB
	MBeaWcop8c043FjyJH13e+3FpiZgud8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="iqh/fqDt";
	spf=pass (imf11.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753159277; a=rsa-sha256;
	cv=fail;
	b=UyJyO4B7q2a6vG7sv54+BdIOjvEXVv2ATFcbfJp05jCgJXpoDk6A2+74sfPHIYwd1NLc2q
	lPCZZgw2oC+4pFNLo2cCcVsz7208aGltC62XG2iiT6Dpex1d//yky33J7anO14iCDNC2E3
	/286EgNsYOVndJVdMdGxW0H5In+9pPk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753159277; x=1784695277;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=lvAgpq0EPqY7xuXxMiGiLcheucSBpC49gVJSi/5UVaQ=;
  b=iqh/fqDt1RzlSq+K3tJrsieVZcifd6oXNvZ5utdUFg8xE98bj0zWSMe0
   WJ/D4OFbyO3RYBCVt8pKQIxzf2VGpScFsPC56PRNeliUEQl+TDgrBs5aF
   XHMKslySZWRZ1HdrVs1H+kAjOmFG7sFnw6yYNXhnXjsZJrDSnMt3eaoro
   ZjmY6satCwDNueX3+k2kmiAA+h87YzLctL9v7JD+yMxBzfO3/TJZpNBQR
   Hi7aHGdZQHHTRhf1LDtVG6hp31O+KelRfSl4tp6rYIm8Qc81qtDGKA/d/
   NoNP1hN71EaQ1B9PwsH+iicOtODCZoovaqgp5s2KFPOkG6QlQT3q9tjHd
   w==;
X-CSE-ConnectionGUID: 7ZYG+NuDQluONKx7TJpo7A==
X-CSE-MsgGUID: IkRVX/FpRxW4dNluOV7B3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="59188884"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="59188884"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 21:41:15 -0700
X-CSE-ConnectionGUID: EeYLAtWvS4SaafhzQHtxrg==
X-CSE-MsgGUID: JN/Ld3x8TgKZENtMqwUkYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="189971990"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 21:41:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 21:41:13 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 21 Jul 2025 21:41:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.53) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 21:41:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xZ/jzSKQjrnFoOsy+yZD7KpeCiC+UOubVRzkkIS1kuprW9Bn/BotMxT1Im+gaAXNcGu+OKIo2uHlEqmePs7l7iiTYj1YGWvi4beLm0WKAtGSKiyUWibPhCw1UX+eVYvgTYcnpFCftGLWJX69Tp5K5wGT4eL/fTjn4BsxaWI72gGSCab8FKGjh5SWScMq1nrrIc93s9Y2yxOBXTGNI9z3l7d59sJzgmN1riIsbmuuxzYxcnkMrTBknFPe+5szkcmE5ebqaZt/Tt28BETdPLaJEEjDVQ+3MCYDT6zzTDlvAjKV2jTegjpijD19J4+Mja7k+bxIoc/L+SxOt6UgOuXeig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aS874BCJHKtD2xcXAYohdTfrmdnr4pC6ToeOtGk77PU=;
 b=nLIt6KRVGHDXU7zng0p+pT3Iqpg5bQHOZ/2k+C04sgEwYjbwghElX7LAaFDg6dmVl3h0iq7l9BUQqOoM5QOoEQP9g+CPXCRPmFOFWNCi3UgHZLsuE6uAJvIQKgaiDbdX2oxsTUdEDFszWcKNp06SyfqjFgnrk507OgRVVHhAibxQ8EO8eX1dhuTCO8DmTcUcHFRCKUdyiBDI6YatVoWyNVC2TzkupMfFq60mcovflb9P+fvUKJujMK/H1Fhseva6bSjk4LhIHCRVBvpGmLmoH4m+7KXZMadaxgsZXsN6jAk/e+9SEHet3TXpZovvBq87/pKwNx12sbnIuZ/D6lbhcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL3PR11MB6508.namprd11.prod.outlook.com (2603:10b6:208:38f::5)
 by CO1PR11MB5090.namprd11.prod.outlook.com (2603:10b6:303:96::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Tue, 22 Jul
 2025 04:40:41 +0000
Received: from BL3PR11MB6508.namprd11.prod.outlook.com
 ([fe80::1a0f:84e3:d6cd:e51]) by BL3PR11MB6508.namprd11.prod.outlook.com
 ([fe80::1a0f:84e3:d6cd:e51%7]) with mapi id 15.20.8943.028; Tue, 22 Jul 2025
 04:40:41 +0000
Date: Mon, 21 Jul 2025 21:42:25 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: <linux-mm@kvack.org>, <akpm@linux-foundation.org>,
	<linux-kernel@vger.kernel.org>, Karol Herbst <kherbst@redhat.com>, Lyude Paul
	<lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, David Airlie
	<airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Shuah Khan
	<shuah@kernel.org>, David Hildenbrand <david@redhat.com>, Barry Song
	<baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>, "Peter
 Xu" <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>, Jane Chu <jane.chu@oracle.com>, Alistair Popple
	<apopple@nvidia.com>, Donet Tom <donettom@linux.ibm.com>
Subject: Re: [v1 resend 03/12] mm/thp: zone_device awareness in THP handling
 code
Message-ID: <aH8WsUIEpr1LrrRu@lstrano-desk.jf.intel.com>
References: <20250703233511.2028395-1-balbirs@nvidia.com>
 <20250703233511.2028395-4-balbirs@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250703233511.2028395-4-balbirs@nvidia.com>
X-ClientProxiedBy: SJ0PR05CA0144.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::29) To BL3PR11MB6508.namprd11.prod.outlook.com
 (2603:10b6:208:38f::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR11MB6508:EE_|CO1PR11MB5090:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f0b8b48-6139-486e-51e3-08ddc8d9e952
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bmJhdHlhaEk3bE0wODhLYitpTjYzamRxV1gxZmVLTFVtOTdvTy94OFdUVWNY?=
 =?utf-8?B?NVNoWndQcEdhN3dzbUFNS05TRDhYMWpCTVFuTjdkUms3dkpoTHhFaUZsWHhD?=
 =?utf-8?B?N25XTWhLcThuUG1Vd0JOdDhmUUZrR000RjFTQTNWY2tDaEczQzEvWjBmWmhv?=
 =?utf-8?B?VkNBYWhuaG41cE9Wa2dFSVBDVG5sQ1hCZmNSZitsMjlSL0dZRmxCemFncjNx?=
 =?utf-8?B?U3d6eGRQSnVLTyt1SDdmMU8vNzVwVUtubVkyeWk4R1NtTlltekxzUm5WamRz?=
 =?utf-8?B?Q3c4aTFucHRvc0cxdUhaSGZCNnZPandTOFlNUGxPQjNWKzlDTU9VT0RFbmxQ?=
 =?utf-8?B?MW9lYTREZXBnWDJrWnVwc1ZiMGJLRXR0ekR2R2txMGRGa2NDR2Q4S2xNVnY1?=
 =?utf-8?B?MTMvT09lbmRUOEtyQ1o5YlVaR1VicVFwSVJIako3eEc3bUdZbDVYRmE4VHJa?=
 =?utf-8?B?ZXBWMEcwL2xZOGVzNmpLNGIxSTZWWVVtWVRZMm9IMDRUMTZ0NmNEaFVJY3Rh?=
 =?utf-8?B?T1BDby9OM0JNeFkwTmFhOGVsUUJBOGtYWitWS0k3ZFJSb0Vsd0VtSkpVWU1C?=
 =?utf-8?B?MkNpWU1Xc1p3NEowdld5MTg3ZWwvK0txTm45RHl4UVRxTGEwREZHZlJ1M1hY?=
 =?utf-8?B?NmZvekM2anpnbWVlTWNPdEc5bHdiM09wY2gyY054OEhRNmJ0c1dLZFJTaEcz?=
 =?utf-8?B?THZRVkloQzUwcEZOMlg5eVZzc1o4ZkJkSkVaZ29TVTBYbkU1UEZTR2dhWHov?=
 =?utf-8?B?eHNjQytOUUNVRUV1eGtvZmIyc0l3QldJNHltMlVPbDY5WldmYlFteGkvR1VV?=
 =?utf-8?B?U3gzUk03eVU5b2lISVlSRWdzUkwzV2czeUZZT0ZzN3ZjRE54bTBFQ3JUU252?=
 =?utf-8?B?akI3dDkwak84UmdKcWtubkk0NEJSU1gyNU42VjBWczNxa2p3Wk9CZlllQ2lD?=
 =?utf-8?B?aS9OanoyTWp3a0l3Z0RuVTF4Mjh0cy9VYXduU2xCZ3V2NGgwY0RXemZUN21p?=
 =?utf-8?B?MllQZi9RZzBYZmZiaTlRRytNUmlTeGcra2plS0p4aTVIdXRUM2VmQ1dFYWdO?=
 =?utf-8?B?MjBYOW95bER2T2s1L2ZObHpNdGZFU1ZpSWxzUE1KNUhxcCtVLy9CdGsxbzlB?=
 =?utf-8?B?bDNZZFdLa3hsVjhWSDdvN0srQWhKZlBWS1ZNcmV0N2h4L1ZCZkNralFyVHB2?=
 =?utf-8?B?d1hBVWVOTjMxQ21ia3lGcG96Z2N2Qk04Z2JlcEU5b2d3Tjd0V1hyN3RHTElT?=
 =?utf-8?B?Zk4yZVg2U2U4ak1QV3Y0Z2lvcEc5aHdHVlZjM3NLMDhtK1IyNVV6eDMraC9w?=
 =?utf-8?B?bWtJQW5TcUI0cWxyKzcrOEZCcUd4Z3pXMnBVT1RxYnlPcEVWK3pnTnlhR1VR?=
 =?utf-8?B?V0l4WjdrZStXOURqSWZpQ1BNYjZqSldVejlsa21MNVd5QkJXWGFxSWFWMk84?=
 =?utf-8?B?SlVXclcrUnNNZDJCczJLQUNTb2dST2lRcis5cHQwNWc0NXMxeG1YWUw0MDVm?=
 =?utf-8?B?UVpTSVdQYnQwNGFJNU9pNWFqTm9CMFlZL0NYSDh6NWRFWEp1Q0tqY3I2QS9X?=
 =?utf-8?B?ektwSjFZNnhUc1NPbW0xbGFFSWpRSHgxWHM0d1JNeW5VNmdPSnVUSTJNOThx?=
 =?utf-8?B?T1JCZGVlTVZCeDJucTBUOVdtRTBBS3V5VGZsbGllelhKWnhoelYrM21rcVcz?=
 =?utf-8?B?TmFyS05UbExEd1lhNERXdHR4eTZmZW1ka0NoS0N1LzUwSW8wZlpBdVJMc2du?=
 =?utf-8?B?cExOK3RSVm5uVllqT05QUTh4WElxV1FIY21pRWNPQ1dqYkUwZnZJNVlxWlFY?=
 =?utf-8?B?dHBrTHY5ZjU4ZmFEeW5xMDltZkRMWUJra1MybGpMTkN0NDA1MzNTT3N6YmFN?=
 =?utf-8?B?NEl2dWNaZk5id1hVMHNIWHh5LzRSTUVJYnNuVVBiV3MydDZ0b1A1bGd1WFlQ?=
 =?utf-8?Q?aZO0G/B1pwY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR11MB6508.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MXBtK3lnTDhkSzVmWG9QcndkSnRnbUhuVUR3SkRxK3RrNWVrSldDMk1NZWxY?=
 =?utf-8?B?YTJyT1ZVblRpTHk5QVZaMU9kdVg3VFdldUJDMWo3MndEZGFmeVJXUi82aW9F?=
 =?utf-8?B?dlFXb2tsMHEzWjBHSVdJYy9VSjVWZ2V4NVladDVGQk8zZ3NYOU9CNEdSaU1a?=
 =?utf-8?B?d2pwUUFpek9ISVJ3MHptZ1kyNS9hUGpjZUZTUWRJRGlRZDhyZjQ1UWg0N0Mw?=
 =?utf-8?B?L2pIVm1MY1krVTBGcHBHcWtWRVRDOWlhTUd3OUlrQVlLUzc5SUVOakI3Sktx?=
 =?utf-8?B?L0ZWdFlDdTRISkg3ekJib25oUjU2ZHl5eW1xem8xOXpwTjZrcDIzNmZFM1ox?=
 =?utf-8?B?cVNCd3ZJWGQ5Rk1SRDFoY0M5STlCeGN4alB3SkVESHU5Z3FtYmhoOEN4TkUv?=
 =?utf-8?B?azQ0NHF2cnhKczVoK3Z3emlvVFZ0UUVwZFBYelVoR290ZldiOWRFTGhLeGhu?=
 =?utf-8?B?THQ1YzZ3aVZVTlZRZHp3cXY3YUZvUnVHUXphSlpQbWxLbU9wT2RFV1hvb1hM?=
 =?utf-8?B?dHlVTFdzYmtzRGN0dEtvUkVNOWRudTlRb2NWR1FvbWkvSHd1L29rSHJtSUpX?=
 =?utf-8?B?eVRYZXB2OGgrMVQ4Z3hpRWtRaGF3OUVFcDFtUElxRzJXNWZvMVBMNmV2NFdL?=
 =?utf-8?B?anJMbGl6NCt5Ymk4UjIxb05hcTNXeHI2TUxrQXBVaVMzcGdDcnNHWEVuNkE2?=
 =?utf-8?B?ZGFyeU9QbXdZbXVTZTh1eVBpUnVlZGkvc2dxOWpaN05ia2xKOG01U0pxVDEv?=
 =?utf-8?B?Si9IOUNabWRqVVl2d2FoRVVpT0x2MytqY1Fvdk9VMzcwNlZma0E1MzdXOEZU?=
 =?utf-8?B?QktyZWg0VUFobS9uTXhjS1VrZHVDczJtYUtXd2NXbWZLZmlFSlJLdSs2czFI?=
 =?utf-8?B?Y1o3eVZCMm9PVlhaOWVFUXE3OFVNVWlGd2xuM0ljZlpCVWRIR0ZiTDRPdVhX?=
 =?utf-8?B?Q21WNnBSeWVDbUlMMVRrUmFOTU5KZzMvQnlnZzhVMHZHZWxIYmZ4REFVNGV1?=
 =?utf-8?B?QklzZnl6U2hWdmNueTczdjdaZzFlc0o4MnZJb0NaOStDVFlCSVJPM2U4NFFx?=
 =?utf-8?B?YkUvMStxOWpzTFBWZmFtK0JXTWJJMWZYU1M3c3Q2OERQL0tsV0g1bTNTdC9Q?=
 =?utf-8?B?cGdQeEZUb2RreW0xUW5tUUJ5ZFpDbDIrVTA4bCtTSU9JbXYwbEg0V0RIaGw0?=
 =?utf-8?B?RFE3Z25ERGh3YVhZNnRaR3c3MmJKQ29RbnpPS2tkSVZSaVU2RFEwaWNGMkxt?=
 =?utf-8?B?OHdmSU5vYUkwcURselBHZ2FpQmNJYjJaeW4yK01XczFneHdPanN5TWowMzNm?=
 =?utf-8?B?QWVvUWVacE1oclROSzZPdXJ3R3dRZkwxRWszYlJtQnRVL2ZzUkVZSDNTSUNT?=
 =?utf-8?B?YlVSSWFvcHR2Vk9kNittaTIvbHJ4ZmFYOHcwcFV6ckZWZFAzaWxZUU5qMTlO?=
 =?utf-8?B?akJYM3ZCS1BhWG5nQXg4eHdVb3RkSW9IdDI0UllPYW90Y243UldJOHRPWVZs?=
 =?utf-8?B?M1VKQ2hpb1d6VURZaTNoRnFrM0pXa0kyK2QvQ1M1U1cvU1prVnhYK0Q0OFFV?=
 =?utf-8?B?L1I4WFowdHhmVlZobkNOM1dQRUxQU0lDaHBKRDVvSWxDdWZaZTlsenpBWmpv?=
 =?utf-8?B?N0RGOXF6ZS9PU3RmeVVsOVdLYXBXTHRValNhUjBObFJ0UVJMbWRxUHhHa0ly?=
 =?utf-8?B?MDlzc0RoaWxKSXlFbTdEMmczZ2VVcHhIM05aMnBpZDZzRy8xMFNKbjlyamZN?=
 =?utf-8?B?MktaQ3ZUSWtsdDllYWVEa1lENDBjY2UwVnBSVEFYeHdEdERxWHYzR2E2cXo2?=
 =?utf-8?B?MzcyUFBiYnA2UWl1QzgydjJZZVRHWVV4aHVOMWg3UW9EWStpUlo4UTE0Q0FI?=
 =?utf-8?B?aTgvdGhHUUxKQmJUWlhaelFadUE1ejdMKzBLWHdGenNYQ2lKdVJIbWdqL3RY?=
 =?utf-8?B?ZWd5OGsvbktJWDdCRXF6UlR5c1F3QzBHRVJrelpPVnpCelo5bmR4SmMyNUpF?=
 =?utf-8?B?THRrUW9vSTVQNzkyYlZ2a3YwTlNSQmplUHRlTHozZDljSmQxZmdQckFwVDYz?=
 =?utf-8?B?b3BrWDl2WnBPRldBZDJlQU5lbS83YmZ2d0JRS1JWNUl3MHRSMUd1cjQrS3Fq?=
 =?utf-8?B?bEdhNEt3eGlUTnVHWVdWVTl4RHd0THVaaWlMZC9tWTF2dWpKNVNFeE9yR29G?=
 =?utf-8?B?dHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f0b8b48-6139-486e-51e3-08ddc8d9e952
X-MS-Exchange-CrossTenant-AuthSource: BL3PR11MB6508.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 04:40:41.2477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gY1wpP5Asijh3jtuJPYxsosCuAVzJmg1xZ7fhkQQ74pto968qkocQsoam1EFQz5VUf405QeprGAjX8ULHGQ5og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5090
X-OriginatorOrg: intel.com
X-Stat-Signature: jgcsp1cg3ydet1huohfryq3idiwer5ha
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C441440002
X-Rspam-User: 
X-HE-Tag: 1753159276-864270
X-HE-Meta: U2FsdGVkX18XDDwlNBQpO3Xnb3vh5wGZA28ZySfDA6ktRceySLNPbuIB+WLPtLXQY1VdYbEUi7t+GEqpqjne2MXRPTDpJTrP+1EUIQGCiw2NpE1lVV9Tp2NB3qg9ikww4Lj3fRUXMxdO6UbwhcIgTwAEZWEP8wBCqRYU0c9Oi69SZcYjhDIgosqP4xnb6pcRKY9mt3D6VrVJH0TZKYljnKq2HdKUo3Tfp/7xHe5DsLVMo4Ywt0TqJoZ2EFaV3YTsoFLen68yvCLai91JePpquQtk34BWyUbkmo2SlQxTeKVfTxyg/flCYiUJo7pP1n+m7VwQv+HkflNElIG5hGxw0/0fi7XnqlzsQtc4vKLiAmAjS2TjEGWfS5NgYJ6ZTjNnPpdYqnPyBodpn1BgLIFUXk4HwIjeA/diTacSbSYfpscRnoPxjY5HNYunkVudrj50Aq6eqrBy6xleMcrKEeomXO97jxLBJLQQB53iaCkHdjur/uAHwDgjJaV5AM3kpNGKQYnSB5xK8dmEQ3iDgfPAqUMsPS8G7YZWwYN3q/u5hSxTT/mBP1ym1AyxnsbpuuZUKSEfJ5lk8QDwyF4yHS6IpjHF7NQjMah1oBhSqC5s75FRDfpgNBeDYnDu9jHmZpMuBzkozsjuLT+vI3akXKDXAByWtjQ9gEKRFjDvizy62ZAWM4D5nDF3UGoG94ytCEdw0JUFGiSCizzhH1ApP3Cl+GKymKjHxgoYpoQBqaxd0vAM9jloDWzIyS+9gJUqOuEP+GhemuSyvccmQeo8ehJgcLGrP7idhYmceH2S4dNrIrZ9Jo5SCGMFbNafBA8yM4oSYruEvvmxxO7tlGWsRgkrxku+CKA+5EgcwgUW4F+G5+vG5E8Id7P2Npz3LnseTUR1MaapHQBKhqkct53oKkUb1CAUaS6a9rI7pDX8idXFnTzx/c4CpV8OAO/rVufTAWh0GbvdE/4ajcnuhvpQyiK
 zaoBSfPZ
 ZHtXeooM0vGDT+HHQEo2RJyv+e0SFq81IAQTnfP0Edf4QRhkC9l3u8RjfBnCDJy4uZppBzz9te60puPZU1X2XqkBItltY6ABZU7CLRbh4uWJuDe3zN3mQnV4s7C5GwfdqmwfyqygsQm0GWHGHiUjXHvFzcrMMdVSOyrkrXLhlsHe40R5cy2YKdcM30VCBPLzlWXxzH3cvxqjvHJVGUAJGOxAIDmGYXz6No8UMCE2eyZOPIjR2ZU3peIziFMXxXu5vxg3UMjuvEYblfbrcdwg0ZSQ+mI++tbR9yWGPommq81kreRNH6JQQ4TOSP61EtPPcrhlxtZsa1mG3IGd9lC7HNPHKOnhbY8+xz5fuTvoVnAWDACmJRPXf0s5W5llSbC/ReOBaXGhpiZ0W00a4VfCRC50ShzNds8BLSOaTiZHL/FbxzUtj3/ntK+1kSBN5fe4BUtaYO9VKMkdLR+8mZC6KXMdnNJGqXTgDmfvQCVU1cvdi8fwnOm1YgDErs4D8xG/uEnvHVrR+rfLf8RNC08CCVOD+KRHurjHaX9qF91qwDFM3T5knLtWo92WMUaLRNEiBMyYRGjOUqGQwaeeMAV5ja1iDr7gRSzTktvoUWLwVwVjzd5ezfbPGmiKGYaBdTN+e5FyRj22sCc4EltVKHFUee8KUN8IJI4gQcGR5tohvxQoIGI9uLmlQy6/KGsb7H2Y6EEwgJVZDYj52p3LbU2DDUizfm0MtqyYGWdUYH+RrLc3z8Mvo+Bt41c1DvggIAmX7FDV1MZh3EIaEr+He3C0o58H32TZcZhgyxj3Q2VhoNZwvw6qfOhnxUQ7Au7xfAmsz0KkYElitaTebofpdo02CPXvUB3861YMpwH5J4QTJV0q3WQpCJFPOQ6LeTkN5/qb6wEab/9DIbYh3wiOGRsQQngg7NS4j26fJjp5GhwDY8HJXUBB0iQW8ib6bJfNKkdPll/xvQ9Vc6rg/H9w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 04, 2025 at 09:35:02AM +1000, Balbir Singh wrote:
> Make THP handling code in the mm subsystem for THP pages
> aware of zone device pages. Although the code is
> designed to be generic when it comes to handling splitting
> of pages, the code is designed to work for THP page sizes
> corresponding to HPAGE_PMD_NR.
> 
> Modify page_vma_mapped_walk() to return true when a zone
> device huge entry is present, enabling try_to_migrate()
> and other code migration paths to appropriately process the
> entry
> 
> pmd_pfn() does not work well with zone device entries, use
> pfn_pmd_entry_to_swap() for checking and comparison as for
> zone device entries.
> 
> try_to_map_to_unused_zeropage() does not apply to zone device
> entries, zone device entries are ignored in the call.
> 
> Cc: Karol Herbst <kherbst@redhat.com>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: "Jérôme Glisse" <jglisse@redhat.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> Cc: Jane Chu <jane.chu@oracle.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Donet Tom <donettom@linux.ibm.com>
> 
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>  mm/huge_memory.c     | 153 +++++++++++++++++++++++++++++++------------
>  mm/migrate.c         |   2 +
>  mm/page_vma_mapped.c |  10 +++
>  mm/pgtable-generic.c |   6 ++
>  mm/rmap.c            |  19 +++++-
>  5 files changed, 146 insertions(+), 44 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ce130225a8e5..e6e390d0308f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1711,7 +1711,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,

As mentioned in a reply to the cover letter [1], this code is crashing for
us (Intel) when we fork and then read device pages. I’ve suggested a fix
in an another reply [2] and will send Nvidia’s stakeholders a complete
patch with the all necessary fixes to stabilize our code — more on that
below.

[1] https://lore.kernel.org/linux-mm/aHmJ+L3fCc0tju7A@lstrano-desk.jf.intel.com/
[2] https://lore.kernel.org/linux-mm/aHrsdvjjliBBdVQm@lstrano-desk.jf.intel.com/#t

>  	if (unlikely(is_swap_pmd(pmd))) {
>  		swp_entry_t entry = pmd_to_swp_entry(pmd);
>  
> -		VM_BUG_ON(!is_pmd_migration_entry(pmd));
> +		VM_BUG_ON(!is_pmd_migration_entry(pmd) &&
> +				!is_device_private_entry(entry));
>  		if (!is_readable_migration_entry(entry)) {
>  			entry = make_readable_migration_entry(
>  							swp_offset(entry));
> @@ -2222,10 +2223,17 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		} else if (thp_migration_supported()) {
>  			swp_entry_t entry;
>  
> -			VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
>  			entry = pmd_to_swp_entry(orig_pmd);
>  			folio = pfn_swap_entry_folio(entry);
>  			flush_needed = 0;
> +
> +			VM_BUG_ON(!is_pmd_migration_entry(*pmd) &&
> +					!folio_is_device_private(folio));
> +
> +			if (folio_is_device_private(folio)) {
> +				folio_remove_rmap_pmd(folio, folio_page(folio, 0), vma);
> +				WARN_ON_ONCE(folio_mapcount(folio) < 0);
> +			}
>  		} else
>  			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
>  
> @@ -2247,6 +2255,15 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  				folio_mark_accessed(folio);
>  		}
>  
> +		/*
> +		 * Do a folio put on zone device private pages after
> +		 * changes to mm_counter, because the folio_put() will
> +		 * clean folio->mapping and the folio_test_anon() check
> +		 * will not be usable.
> +		 */
> +		if (folio_is_device_private(folio))
> +			folio_put(folio);
> +
>  		spin_unlock(ptl);
>  		if (flush_needed)
>  			tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
> @@ -2375,7 +2392,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		struct folio *folio = pfn_swap_entry_folio(entry);
>  		pmd_t newpmd;
>  
> -		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
> +		VM_BUG_ON(!is_pmd_migration_entry(*pmd) &&
> +			  !folio_is_device_private(folio));
>  		if (is_writable_migration_entry(entry)) {
>  			/*
>  			 * A protection check is difficult so
> @@ -2388,9 +2406,11 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  			newpmd = swp_entry_to_pmd(entry);
>  			if (pmd_swp_soft_dirty(*pmd))
>  				newpmd = pmd_swp_mksoft_dirty(newpmd);
> -		} else {
> +		} else if (is_writable_device_private_entry(entry)) {
> +			newpmd = swp_entry_to_pmd(entry);
> +			entry = make_device_exclusive_entry(swp_offset(entry));
> +		} else
>  			newpmd = *pmd;
> -		}
>  
>  		if (uffd_wp)
>  			newpmd = pmd_swp_mkuffd_wp(newpmd);
> @@ -2842,16 +2862,20 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  	struct page *page;
>  	pgtable_t pgtable;
>  	pmd_t old_pmd, _pmd;
> -	bool young, write, soft_dirty, pmd_migration = false, uffd_wp = false;
> -	bool anon_exclusive = false, dirty = false;
> +	bool young, write, soft_dirty, uffd_wp = false;
> +	bool anon_exclusive = false, dirty = false, present = false;
>  	unsigned long addr;
>  	pte_t *pte;
>  	int i;
> +	swp_entry_t swp_entry;
>  
>  	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
>  	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
>  	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
> -	VM_BUG_ON(!is_pmd_migration_entry(*pmd) && !pmd_trans_huge(*pmd));
> +
> +	VM_BUG_ON(!is_pmd_migration_entry(*pmd) && !pmd_trans_huge(*pmd)
> +			&& !(is_swap_pmd(*pmd) &&
> +			is_device_private_entry(pmd_to_swp_entry(*pmd))));
>  
>  	count_vm_event(THP_SPLIT_PMD);
>  
> @@ -2899,20 +2923,25 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  		return __split_huge_zero_page_pmd(vma, haddr, pmd);

This function is causing a crash with the following test case:

- Fault in a 2M GPU page (i.e., an order-9 device folio is in the PMD)
- User space calls munmap on a partial region

A quick explanation of the crash:

- zap_pmd_range() calls __split_huge_pmd()
- zap_nonpresent_ptes() finds multiple PTE swap entries that all point
  to the same large folio; it decrements the refcount multiple times,
  causing a kernel crash

I believe there are likely several other problematic cases in the kernel
as well, but I only deep-dived into the case above.

The solution I came up with is: if a device-private PMD is found, split
the folio. This seems to work.

Rather than include the fix I came up with here, I’ve just sent Nvidia’s
stakeholders a patch titled "mm: Changes for Nvidia's device THP series
to enable device THP in GPU SVM / Xe", which contains all the core MM
changes we made to stabilize our code. Feel free to make that patch
public for discussion or use it however you see fit.

Matt

>  	}
>  
> -	pmd_migration = is_pmd_migration_entry(*pmd);
> -	if (unlikely(pmd_migration)) {
> -		swp_entry_t entry;
>  
> +	present = pmd_present(*pmd);
> +	if (unlikely(!present)) {
> +		swp_entry = pmd_to_swp_entry(*pmd);
>  		old_pmd = *pmd;
> -		entry = pmd_to_swp_entry(old_pmd);
> -		page = pfn_swap_entry_to_page(entry);
> -		write = is_writable_migration_entry(entry);
> +
> +		folio = pfn_swap_entry_folio(swp_entry);
> +		VM_BUG_ON(!is_migration_entry(swp_entry) &&
> +				!is_device_private_entry(swp_entry));
> +		page = pfn_swap_entry_to_page(swp_entry);
> +		write = is_writable_migration_entry(swp_entry);
> +
>  		if (PageAnon(page))
> -			anon_exclusive = is_readable_exclusive_migration_entry(entry);
> -		young = is_migration_entry_young(entry);
> -		dirty = is_migration_entry_dirty(entry);
> +			anon_exclusive =
> +				is_readable_exclusive_migration_entry(swp_entry);
>  		soft_dirty = pmd_swp_soft_dirty(old_pmd);
>  		uffd_wp = pmd_swp_uffd_wp(old_pmd);
> +		young = is_migration_entry_young(swp_entry);
> +		dirty = is_migration_entry_dirty(swp_entry);
>  	} else {
>  		/*
>  		 * Up to this point the pmd is present and huge and userland has
> @@ -2996,30 +3025,45 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  	 * Note that NUMA hinting access restrictions are not transferred to
>  	 * avoid any possibility of altering permissions across VMAs.
>  	 */
> -	if (freeze || pmd_migration) {
> +	if (freeze || !present) {
>  		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
>  			pte_t entry;
> -			swp_entry_t swp_entry;
> -
> -			if (write)
> -				swp_entry = make_writable_migration_entry(
> -							page_to_pfn(page + i));
> -			else if (anon_exclusive)
> -				swp_entry = make_readable_exclusive_migration_entry(
> -							page_to_pfn(page + i));
> -			else
> -				swp_entry = make_readable_migration_entry(
> -							page_to_pfn(page + i));
> -			if (young)
> -				swp_entry = make_migration_entry_young(swp_entry);
> -			if (dirty)
> -				swp_entry = make_migration_entry_dirty(swp_entry);
> -			entry = swp_entry_to_pte(swp_entry);
> -			if (soft_dirty)
> -				entry = pte_swp_mksoft_dirty(entry);
> -			if (uffd_wp)
> -				entry = pte_swp_mkuffd_wp(entry);
> -
> +			if (freeze || is_migration_entry(swp_entry)) {
> +				if (write)
> +					swp_entry = make_writable_migration_entry(
> +								page_to_pfn(page + i));
> +				else if (anon_exclusive)
> +					swp_entry = make_readable_exclusive_migration_entry(
> +								page_to_pfn(page + i));
> +				else
> +					swp_entry = make_readable_migration_entry(
> +								page_to_pfn(page + i));
> +				if (young)
> +					swp_entry = make_migration_entry_young(swp_entry);
> +				if (dirty)
> +					swp_entry = make_migration_entry_dirty(swp_entry);
> +				entry = swp_entry_to_pte(swp_entry);
> +				if (soft_dirty)
> +					entry = pte_swp_mksoft_dirty(entry);
> +				if (uffd_wp)
> +					entry = pte_swp_mkuffd_wp(entry);
> +			} else {
> +				VM_BUG_ON(!is_device_private_entry(swp_entry));
> +				if (write)
> +					swp_entry = make_writable_device_private_entry(
> +								page_to_pfn(page + i));
> +				else if (anon_exclusive)
> +					swp_entry = make_device_exclusive_entry(
> +								page_to_pfn(page + i));
> +				else
> +					swp_entry = make_readable_device_private_entry(
> +								page_to_pfn(page + i));
> +				entry = swp_entry_to_pte(swp_entry);
> +				if (soft_dirty)
> +					entry = pte_swp_mksoft_dirty(entry);
> +				if (uffd_wp)
> +					entry = pte_swp_mkuffd_wp(entry);
> +			}
>  			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>  			set_pte_at(mm, addr, pte + i, entry);
>  		}
> @@ -3046,7 +3090,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  	}
>  	pte_unmap(pte);
>  
> -	if (!pmd_migration)
> +	if (present)
>  		folio_remove_rmap_pmd(folio, page, vma);
>  	if (freeze)
>  		put_page(page);
> @@ -3058,8 +3102,11 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>  void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>  			   pmd_t *pmd, bool freeze)
>  {
> +
>  	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
> -	if (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd))
> +	if (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd) ||
> +			(is_swap_pmd(*pmd) &&
> +			is_device_private_entry(pmd_to_swp_entry(*pmd))))
>  		__split_huge_pmd_locked(vma, pmd, address, freeze);
>  }
>  
> @@ -3238,6 +3285,9 @@ static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
>  	VM_BUG_ON_FOLIO(folio_test_lru(new_folio), folio);
>  	lockdep_assert_held(&lruvec->lru_lock);
>  
> +	if (folio_is_device_private(folio))
> +		return;
> +
>  	if (list) {
>  		/* page reclaim is reclaiming a huge page */
>  		VM_WARN_ON(folio_test_lru(folio));
> @@ -3252,6 +3302,7 @@ static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
>  			list_add_tail(&new_folio->lru, &folio->lru);
>  		folio_set_lru(new_folio);
>  	}
> +
>  }
>  
>  /* Racy check whether the huge page can be split */
> @@ -3543,6 +3594,10 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
>  					((mapping || swap_cache) ?
>  						folio_nr_pages(release) : 0));
>  
> +			if (folio_is_device_private(release))
> +				percpu_ref_get_many(&release->pgmap->ref,
> +							(1 << new_order) - 1);
> +
>  			lru_add_split_folio(origin_folio, release, lruvec,
>  					list);
>  
> @@ -4596,7 +4651,10 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>  		return 0;
>  
>  	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
> -	pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
> +	if (!folio_is_device_private(folio))
> +		pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
> +	else
> +		pmdval = pmdp_huge_clear_flush(vma, address, pvmw->pmd);
>  
>  	/* See folio_try_share_anon_rmap_pmd(): invalidate PMD first. */
>  	anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(page);
> @@ -4646,6 +4704,17 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
>  	entry = pmd_to_swp_entry(*pvmw->pmd);
>  	folio_get(folio);
>  	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
> +
> +	if (unlikely(folio_is_device_private(folio))) {
> +		if (pmd_write(pmde))
> +			entry = make_writable_device_private_entry(
> +							page_to_pfn(new));
> +		else
> +			entry = make_readable_device_private_entry(
> +							page_to_pfn(new));
> +		pmde = swp_entry_to_pmd(entry);
> +	}
> +
>  	if (pmd_swp_soft_dirty(*pvmw->pmd))
>  		pmde = pmd_mksoft_dirty(pmde);
>  	if (is_writable_migration_entry(entry))
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 767f503f0875..0b6ecf559b22 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -200,6 +200,8 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>  
>  	if (PageCompound(page))
>  		return false;
> +	if (folio_is_device_private(folio))
> +		return false;
>  	VM_BUG_ON_PAGE(!PageAnon(page), page);
>  	VM_BUG_ON_PAGE(!PageLocked(page), page);
>  	VM_BUG_ON_PAGE(pte_present(ptep_get(pvmw->pte)), page);
> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> index e981a1a292d2..ff8254e52de5 100644
> --- a/mm/page_vma_mapped.c
> +++ b/mm/page_vma_mapped.c
> @@ -277,6 +277,16 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>  			 * cannot return prematurely, while zap_huge_pmd() has
>  			 * cleared *pmd but not decremented compound_mapcount().
>  			 */
> +			swp_entry_t entry;
> +
> +			if (!thp_migration_supported())
> +				return not_found(pvmw);
> +			entry = pmd_to_swp_entry(pmde);
> +			if (is_device_private_entry(entry)) {
> +				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> +				return true;
> +			}
> +
>  			if ((pvmw->flags & PVMW_SYNC) &&
>  			    thp_vma_suitable_order(vma, pvmw->address,
>  						   PMD_ORDER) &&
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index 567e2d084071..604e8206a2ec 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -292,6 +292,12 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
>  		*pmdvalp = pmdval;
>  	if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
>  		goto nomap;
> +	if (is_swap_pmd(pmdval)) {
> +		swp_entry_t entry = pmd_to_swp_entry(pmdval);
> +
> +		if (is_device_private_entry(entry))
> +			goto nomap;
> +	}
>  	if (unlikely(pmd_trans_huge(pmdval)))
>  		goto nomap;
>  	if (unlikely(pmd_bad(pmdval))) {
> diff --git a/mm/rmap.c b/mm/rmap.c
> index bd83724d14b6..da1e5b03e1fe 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2336,8 +2336,23 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>  				break;
>  			}
>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
> -			subpage = folio_page(folio,
> -				pmd_pfn(*pvmw.pmd) - folio_pfn(folio));
> +			/*
> +			 * Zone device private folios do not work well with
> +			 * pmd_pfn() on some architectures due to pte
> +			 * inversion.
> +			 */
> +			if (folio_is_device_private(folio)) {
> +				swp_entry_t entry = pmd_to_swp_entry(*pvmw.pmd);
> +				unsigned long pfn = swp_offset_pfn(entry);
> +
> +				subpage = folio_page(folio, pfn
> +							- folio_pfn(folio));
> +			} else {
> +				subpage = folio_page(folio,
> +							pmd_pfn(*pvmw.pmd)
> +							- folio_pfn(folio));
> +			}
> +
>  			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
>  					!folio_test_pmd_mappable(folio), folio);
>  
> -- 
> 2.49.0
> 

