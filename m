Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A76CDC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 23:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264196B007B; Tue, 22 Jul 2025 19:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23C346B009C; Tue, 22 Jul 2025 19:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DD156B009E; Tue, 22 Jul 2025 19:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECAA16B009C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:58:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B7DCB9CF0
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 23:58:42 +0000 (UTC)
X-FDA: 83693568084.10.4740867
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf30.hostedemail.com (Postfix) with ESMTP id 61F6A80004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 23:58:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nAy1yudU;
	spf=pass (imf30.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753228719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=asnj/nli+oW3/nuVcP6HqaMFSb/KcKaXLdSbAhXjKy8=;
	b=S/j1k2Wc5UHKCYA8wkhoI8cX2PnSUDJtxvOWwpSnv/sIKMrwbCGx7f01Ez0vjKIYR1oCBA
	7p80P8G5ELUxY1B52G8//FdHJWiyNGriXd/KNrokUknE/sQfj3l3MWOLSZmeWj8bvr/uIn
	cJSww8FNJuqprSetrYe2Np9Ur9xT7CY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nAy1yudU;
	spf=pass (imf30.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753228719; a=rsa-sha256;
	cv=fail;
	b=rZ2uubCzeoQgYm42J24K4zoxOY7nq1RlB4BqVgLhR5PT95kbergLhgUHPkbuvw5Y1Oz0xk
	PNU1BDtlPMDZToYb8nqpGfbUre9gDpwLyBtlNyMosfxbQiaUY8VD9i3cu6vUWRwmAy94tP
	CmjGaD6tPnH1XcCHapuTtwa6/VlXg+I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753228719; x=1784764719;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=0A8GH4aJXR6Yp7VOsS+Q/sgvsvvYn/s6GxYskQtGMKw=;
  b=nAy1yudUytXFiPOzEArAqrdUDe5nmeFaL8Wooh3mY00lmybMNDhtnS49
   YZx+KIayuOjZBt1RVk93Ohxz3VTcwQajmIKbcSQy86j0hWsglSXUWQF9X
   tgC5RDOJsEuaXnRkC6A5cAG1Tg0RQkQTP7rqfITmhjVdD30rjoXLGI5nY
   OuNGE9OV/j5wRzfrU0uk3JsI/uy0gccTB7o8Y8P3tqYb2vBLe3mLDI38B
   4sX/56QkyGOPF5beNPtxkySg0QsICRSkiI8umSoK5wne/Ze6PeVJYx/97
   tBuiIIgpOHuR0Tg3UOBoHSWZG0BPHjnVoaNddbxCwKUhpQ7xkNF+8lNSV
   g==;
X-CSE-ConnectionGUID: 0AkMNRQNRpyrbSCe23CrDg==
X-CSE-MsgGUID: Gvs6CWUXRICb88eTxqnv3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="59156070"
X-IronPort-AV: E=Sophos;i="6.16,332,1744095600"; 
   d="scan'208";a="59156070"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 16:58:34 -0700
X-CSE-ConnectionGUID: GotJI59BSXeH2IpqZHa5SQ==
X-CSE-MsgGUID: l9Syg8PwT/SJDB9DD+fBIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,332,1744095600"; 
   d="scan'208";a="159321269"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 16:58:29 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 16:58:28 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 22 Jul 2025 16:58:28 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.59) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 16:58:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LKZAoWFpM/tFO1r8SpdNcFbIkkr/lcb7Fx5iKvJ9kMInOeMhOA/6s4Lg/j++7Kn1df1KwQrr8cB04ghUou7gEMRt8MnCBvw11MRjCKOQ7zffQCPYidugK0WwcmzV7XvQMqiZHnfKCOwcl+V+01XW5/Kc5AU8ST8UKrqPXcrqyfK8O59SwnwQ3nmdpgP0pZG53DcwKonxOaHSp6GGUS/xjAnkS7DjH8Yfx037Sh4pc1z/eE3EKWeJvnvGVmiIKO5OyNab4ki2/YklHIIO65NT4+bDsEWx15+SVNcofAokCEOQIk+q5oopTs591zeMMVV3uWUNefq0muv8ZnxSxGKmJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=asnj/nli+oW3/nuVcP6HqaMFSb/KcKaXLdSbAhXjKy8=;
 b=BaACS0WlbP+ndbIQJiNswkw4fpgtsHPT5n+ajDVbuMhf0Avo4W9opYE7nwHRl68QqYEeJO9wprNgM1S+V4r6enpaOmtwHHUKopnr5WX5iPpM/hiOIVnxfKKHAeDAA+tIfaYICF9pKJZnRif5cbYUNQDKU9wd56dXTEEwjoLRvWjajRxuTv3G6YW1MXw0qBexpzdYVV72Yu0nR0OFDuf5BXzXffhkzmUyCZUL7+Daqo4LSYCSdJxAqJOHZ+HhukOiWxCnomdSR4Z9+ocXaF2Tefy1RAIdoIS6CHvKtWRvRnj6JHzPDn+MycEPQjJyDRjisz2hlzVLwLao+ulh5Y9uCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL3PR11MB6508.namprd11.prod.outlook.com (2603:10b6:208:38f::5)
 by DM4PR11MB6527.namprd11.prod.outlook.com (2603:10b6:8:8e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Tue, 22 Jul
 2025 23:58:21 +0000
Received: from BL3PR11MB6508.namprd11.prod.outlook.com
 ([fe80::1a0f:84e3:d6cd:e51]) by BL3PR11MB6508.namprd11.prod.outlook.com
 ([fe80::1a0f:84e3:d6cd:e51%7]) with mapi id 15.20.8943.028; Tue, 22 Jul 2025
 23:58:21 +0000
Date: Tue, 22 Jul 2025 17:00:06 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Zi Yan <ziy@nvidia.com>
CC: Balbir Singh <balbirs@nvidia.com>, <linux-mm@kvack.org>,
	<akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>, Karol Herbst
	<kherbst@redhat.com>, Lyude Paul <lyude@redhat.com>, Danilo Krummrich
	<dakr@kernel.org>, David Airlie <airlied@gmail.com>, Simona Vetter
	<simona@ffwll.ch>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@redhat.com>, "Barry
 Song" <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>, "Peter
 Xu" <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jane Chu
	<jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>, Donet Tom
	<donettom@linux.ibm.com>
Subject: Re: [v1 resend 08/12] mm/thp: add split during migration support
Message-ID: <aIAmBv2i2QYJ+vLb@lstrano-desk.jf.intel.com>
References: <aHc5/pmNLf4e9brJ@lstrano-desk.jf.intel.com>
 <1DD0079E-0AF6-49F5-9CB3-E440F36D2D9B@nvidia.com>
 <aHfSTdoi/M9ORrXE@lstrano-desk.jf.intel.com>
 <a7e8485f-e9da-4edb-a809-a014517f26eb@nvidia.com>
 <aHl4IuMlE9D6yaET@lstrano-desk.jf.intel.com>
 <9E024BB0-7365-4A81-81E1-72CB44A07775@nvidia.com>
 <aHmYVkNDRjz5JwNf@lstrano-desk.jf.intel.com>
 <9F4425D6-609F-40C8-BF24-2455F15234A7@nvidia.com>
 <aHnAgjaJeyKM+Osm@lstrano-desk.jf.intel.com>
 <5B36BFD4-DFDE-464F-8B2F-6A846D827331@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5B36BFD4-DFDE-464F-8B2F-6A846D827331@nvidia.com>
X-ClientProxiedBy: MW4PR03CA0359.namprd03.prod.outlook.com
 (2603:10b6:303:dc::34) To BL3PR11MB6508.namprd11.prod.outlook.com
 (2603:10b6:208:38f::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR11MB6508:EE_|DM4PR11MB6527:EE_
X-MS-Office365-Filtering-Correlation-Id: 005887b8-e630-41e0-6c57-08ddc97ba308
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MFpYWnRINlVha3Bab3lZZHBXYmFnME5CcElZT2crOFJmMkNnSHU3aFRKRndu?=
 =?utf-8?B?MWI5anVoWGVLWTJRMndDaGl3bmk1aSt0MTVtM0M3T1VMQ1VGczRxeDc0Q3Fk?=
 =?utf-8?B?MWxGYW5GZTFyajlnQXQyQzJrblpSZ3NXbjZMc2VoWlN6bENoMWd6a0p6a3Y4?=
 =?utf-8?B?WGFwSXJ3SmtOSmlsbGNscjlLRGsydnJyTHFKZTAyRnl4Z0liM3piV2dpZVRo?=
 =?utf-8?B?cWpXWGdaMnJseHFhclFrdDhLNk5IWkRQYmZtUGVrZ1FkcGxzZUlXY0prNXFY?=
 =?utf-8?B?RjJMNWlGdVpoallqc1VGOTlmSnBDRmNKc29LK3hiN0hFc0llT2E4ZXZzbkVK?=
 =?utf-8?B?djZxa3BMdy9mNFhXcFFySDJKS1h6UWlvRGlpS1FqNnNZZ3MxcVZjVkl5NVhE?=
 =?utf-8?B?ai9sSDVZYlNpUnRsaVhhTzd4SUx6SzJKZ3RQTm1Femk1OVkvSy9Ub1dRUlNm?=
 =?utf-8?B?ajFBWGt1Q1dPUG91VTM5Z1J4YTZxTTFhd2xHOUhQUld3SFlZaTdtL3p1Qkkw?=
 =?utf-8?B?S1NPOGF0a2hjNHlyUEdWTnh2RFNhbVRxUkpjWDNRK201cm1qRURqM0haV2pI?=
 =?utf-8?B?aXVKOFh5U21UUzhIWllCWDhlUzlGcUM0OWFkRkFWTWpSU3J6a3o4LytXRVc2?=
 =?utf-8?B?V0pHSUxiMFhqVGF1NCt3cURCelp4MDI5S0tod3Y4VzBqL3dyVHlyL0Rpek5m?=
 =?utf-8?B?OG9wYkJpU21nRkxXMEpoTXRKMVU5ZThIdGxBRE82aHFBZFlBMytEUjNtK1Np?=
 =?utf-8?B?akQ5Ym9GQ2NYVUM0WTE4T2p6YStkT1ZIYjM4UnpZWExQaGlMOHN3SzFqWXJM?=
 =?utf-8?B?eEtZaTZ5Q3N6SkpsWDVKMk1XRjNXdTEwZHpnMGZsVURvTUI0M0h0aFIxTCs5?=
 =?utf-8?B?TnJiWTYrQ3FPRVcydTY0Nlg3Rm0yTG9tYUxnbW1TVmZuR01GRWFSWDgxM3Uy?=
 =?utf-8?B?YXFrZWFiOE9OR2M1WXlkcUN6THcwTUFWZFJmcE9uWkFHOVV4dWVna0lQTCs2?=
 =?utf-8?B?UnNVaWJHSGJNb3BIY0dkcHBteUV4bWRBdm8zRTNqOXRQOEpJZXU4TGRnbXNS?=
 =?utf-8?B?Wk44Z3dWMmxsNEJzRzNmbmV1UVdwekM2N1dVd3FsWnBUV1pOWFlOR1NueVVX?=
 =?utf-8?B?YS84K0REM3FyTTZZd1RzYzNiMlROMy8vUjY3VmgyS254YjRTY3ZmYmZMbzRZ?=
 =?utf-8?B?dEprSzhabEZ0N3JEQTh4b2tYT0VHUjRXcWhWaUx0RFdQWTNiOGxHRlBPdGNL?=
 =?utf-8?B?d2NjanJ0UW9OYXFESGs2TmtBRmJxMlNCdWZNenJiM0F3NllGZXdjczg0TkJx?=
 =?utf-8?B?UUdtNThoTU1SV1lTL0cwcE92cWtBbFEzamJZM0VqbUd0Y2JkVVB6TzlialVP?=
 =?utf-8?B?Q2RhbHNtZDZjRy93Vjh5eFBBQkUvalVyVHBuNGI5MWFrZit4R1dkK1FFek5O?=
 =?utf-8?B?OUx0RlRMOG1LVTg4Q09NWHN5L0UzTnVpY3dhNVc0bWdjWEo0Z2pQTGNoTElS?=
 =?utf-8?B?NTc1eVViYUE0bWlhY09rcVBiR2pkamEyOUV3Yi9vV3VoVjk5UlFhSFdPZ1VV?=
 =?utf-8?B?RFZZaktqSW9rTExBcGlidGtUNVRobFBCbE9UVVhRNW9xbUFESGpBRWNRSkRx?=
 =?utf-8?B?ZnR5OEVXaS9wVXE0R0tETXNvZlc0UTc4dUdkQnZ4OHUwMlhBeVR1bHF1c1A1?=
 =?utf-8?B?SGVENXhXY0tvYW1ZZC92am9lSjZUK2VlREVuWWd4V2RsNktTcFpCL2dUZk5T?=
 =?utf-8?B?c1IwWGZORjlXOVhDTlIxWHhHZTA1Yi9YVkRJWEw3Y1IrUy9VdkdiR08rRDZT?=
 =?utf-8?B?U0FNWWFWMnRtM0lDWXdFdFI4SEcyZVU2N2VPWTB6MTBFbXhmS3ROY2pvdVVX?=
 =?utf-8?B?eTVVSkNQc2NwbGRid3hyVXdlVnZYaDNSbGlkS3BvU2xVWXVmRTQ1aXYwRktm?=
 =?utf-8?Q?74xQbIgna7s=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR11MB6508.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWFsSHBFeGZpVWs5M0ExMGkvNEx3amJEUFYvTDA1UXJobVBmWjV0RDZVMXdH?=
 =?utf-8?B?d2pucHQ4OEJYaU1ja3RSTkgvcVRuZjBLWkMxY2tvZWdHQm5rVXFKckMvY1cv?=
 =?utf-8?B?eTI1TG5qSEhob1FrSnRKVFJRaitlbjRXT2JpTXBpd1pHRjZ1czZtM0tDWEk0?=
 =?utf-8?B?d09FMnltSmZ1VEVZcnU1Qkt1V3V0dy9NdVF2QzBXUzdobWdIYVprZXFySng0?=
 =?utf-8?B?K2dOMDFzL2pkd3dxTStmejFHRHNFQXZFL2p1anFRS1MwRjJXRWJJc3hrNXRC?=
 =?utf-8?B?MndDeXBPY2gyTzE1SFdUOUdVb2w5YXp3SEM0WS9pbjRHTmREeGgzMGg2OFNI?=
 =?utf-8?B?MVM0WlRxUzZGbFF5Z1RhVnd3OExGN1JvVDY2RkFoN3E5SkdvalFicTB0Z0NL?=
 =?utf-8?B?eStBUVczQTNyN3I3SUZnZnk3TnJPQ3lnbG44YlJvait4RFM1MzdWSytSTDIz?=
 =?utf-8?B?OHZKWnJIMkxlVVJnYVJYYm11TThiV1V4Wi95R3IyS1MyNzJ3aWUwdzhVYXlv?=
 =?utf-8?B?VnNzUzZNU3JTQVFRaGxYSVV0bWFxcmpUc1RKd3piS2xMeis0VDVkcnRVNlhU?=
 =?utf-8?B?NlgyWXZQOGVyU0FUU3dZQ1BzY1NaMWc0Wk84bjFHaGgzYlZLQVd5MmhLVURZ?=
 =?utf-8?B?TXVNenVUV0NKK1doMDFZYnpmRytQb3pFMy8rYWhYbHNMVTVkanVkUmtnbWQ5?=
 =?utf-8?B?cjZ3NHhuUWZBR01maUZnTlo1b0lNSzNodUx0clRvUXhuM2l6V2YzSG9WR2dz?=
 =?utf-8?B?Nkxkd25RREpxSUQ0dFlTNGRwektSNFZhcVpCb3QyR0tISEwyOXd3QURsTkc1?=
 =?utf-8?B?TlhDOHN3aTkrT1ordHIzU0dUQXArRlpyWHpoRVZ0SUF1aVVYM1ErMXJEeDFT?=
 =?utf-8?B?MDVIZzBUZHp1b2g0aXBTMXBpYWtMYnJ4ZGRwazFjUmE3aDBHQmhWL3VpeWhM?=
 =?utf-8?B?YmlIS0VKeFN5QTZZMEZkODRUVjBZQnFHb0daVUtwWmtVVkRZWTlRZk8wRjl4?=
 =?utf-8?B?R0ZZTTltcVpUV0gvMHZoS0ZCWklLSUJFb2p2Z3VRVnlJUW5YYnJjc3owRmk5?=
 =?utf-8?B?d3JSQ3p5Wjh1TVI2dndRM0UxbUNmUjN0aDhYZ2VVZHRnV05qTUwvNnBaSjdB?=
 =?utf-8?B?SklkWHIzSVF5dHdGeGRzc1k2Q3BvSFBkYTh0SXlGeXVSazc1WTFlWUZMZmhm?=
 =?utf-8?B?VWZzdFhGMHdZRmpLbDRlNS9JZzhRNUFvblE5bi8rQ1ZzbVF3YjJaUDlsN3Fi?=
 =?utf-8?B?MDIySUNWL1hkRkdCVU9PQXlQNlV5OTZRZFN4aUJiS3VLQ29QZ1IrWlAvRFdp?=
 =?utf-8?B?UXNjYmRZZUg5cU1FTTZ3V1NnMnFEaVl5RTVJRkVrK2VkaEtXcmhvVE5JRzMx?=
 =?utf-8?B?ZjlSelV2Rkp6MjJkTHZKMExKdXJQbmFJMFhOZW5IckVib3pnSmVhRTJHQi9p?=
 =?utf-8?B?Skk5UlV5L2VtdE8zTXFYMnFEYXhxSmQ5SFhtYlg3YjE5MkJ5WDdYcjlLNW14?=
 =?utf-8?B?RGNWanZIeDdIYXd5RXo1MVpWSWdkZW5YNWxhbmhlUUxLbkIyYWsweHJmWGxZ?=
 =?utf-8?B?ektYRXZtc08va3FkMjNqYWFKeXlSK2F1RjRPQ1dLQmFzbGJ5T1IzRjZRS3lR?=
 =?utf-8?B?SWRUeDBxekVVeUlsbUhwSUw0QkhvRnZkUGhDQnE0elZwL1NzUWJzenNXY21R?=
 =?utf-8?B?WTdTSFl0cjlJSVdJUWVzb3VPbVR1eGlRWFQ5ZytIY3JKMnh1ekdaUnBiaWNo?=
 =?utf-8?B?MlhLeHY4SGFJNEtwNExTd3Zkb3JZY1JMYnFKNlFad1dGN3VMbmkxTTFnSFli?=
 =?utf-8?B?VWhSOUI1aU9VTm9DNFoxYW51TUZzWmN3RDd5RU9KcXNEREZCTjZEYjJPTGg3?=
 =?utf-8?B?N2N1cjhtYmo2bGZvNmlQZThrczFoQWZQczdkd01JM01qK1ZiSDIrbGVUS01U?=
 =?utf-8?B?NDNJSWplVjFhVnBCQ1h6WUs5bUhoNDMwSlR3VEs5bDBYUFVoblNLYWF0Nm9I?=
 =?utf-8?B?WCt5MnhXQXFCYWNvWXlWSGZOYk5SdkZRYS9wSTFzY2xLbC9VQS9JdUpoN3U4?=
 =?utf-8?B?K29UTVhxQ1plaHJjZjJrU1AzYVV2RVFTOUgzS3crSVR5RDRQNlc0MXB4eSt0?=
 =?utf-8?B?T0lNd0QzQ3RnQXZHN2dNQ1FIVTZQa1NBZGdYaEVVZ2VrWVEyY2srRGNqTVBR?=
 =?utf-8?B?YlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 005887b8-e630-41e0-6c57-08ddc97ba308
X-MS-Exchange-CrossTenant-AuthSource: BL3PR11MB6508.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 23:58:21.3820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YSiihukNum6/Jp6QepVTnG4SP5PjxpEQzerxmOjXJgkJnA3g1BeacHd+X4HammsHMkUUewsd+NFzU7FfGjeDZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6527
X-OriginatorOrg: intel.com
X-Stat-Signature: 44nsqm4mdaksoxjciryg86j719dquq9u
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 61F6A80004
X-Rspam-User: 
X-HE-Tag: 1753228715-232349
X-HE-Meta: U2FsdGVkX19/aR7wIxutmwLJ+wX/NPF1+oO4WTdIOFqqByGzWaEo/33mqxAwsoIeJkW8uVzNLVQOYMw1Fyn7CBk+X8NXIMqfPOani4fdvaBmYxyYjNdooG65VKUHYnB+m98UQRUVBNVU4uiqZTNofUubE6NSn5etnC3dvwjMxY/ou8cxGq3GGL27tmyYN0xbt2CT4FAwbnQQvTyBi3Rh8F9cFLiJW1FyGWVaIiWhIVv4IGobZjE4XBhAEsdd74Bn9efX4r0kOu4WmY7wnqFdnwS19GJtjzkfm8GBI/izFUlG0VvFhaxivPVoamp8JBbzR0UQFcdqNJx1EeJEFCHONkXIw2HFPuvnTu00TY2BVA35MyTbFThqtH33krfxTagNYN7lphVxjHtxnxOMNDPJk7J9fLe8KFnS4owTK/ptANct8BDXvaEPqwgB/HsbK85Sh6Q57lpnY+JvIbw5KtAxb9xiPL4pjxYg/LZn+Nt8qTtz6HJdxdE4RfhsS2xQ91epCm1YXGFdkWEV2AzUeATiiKjn1FRkTqHELKqQQ3NmGwBMOM2EFLo9JhTBKSzMGWUbKU+7kW21UP3zp8fezGF5/9rvDRp56uLULz0DkHD1UdIcWIU+xF9xatejO/buTdhT+B/6ibCuJWYPVwOHhuekAZVCfJcp2unr/otw8qjqHsnDcDvofjEZzl5glAHJhhqpVFu/CJ+4SFOnfk6ecU67HD7k5P9RGCXY9ROFfWKbQwmvANtC9tVbgqzu6BPS9iM+DdxTUmvJFMr8c4pyVbkxFpnuU8DyQH7zjXwR+k40Gap8VFxcb5J6BxKIvxjG9QSTcm8qoodD1t9vkWcQYCHnBzIR1BEbO8mG+jPgosTVhqfTJ2Oks3rCa0xcpa+CufqGdFYlnCm4vzBv1nI/nKv8VppaeoYkx51kN0ErAPKq7U7dc5MgIfneE35d83AVZ+TYIhQf9+rg7zC+6i6PijZ
 4vMtkrrU
 xZ2Vi68Q8/vWbHd06IJpM8r/3S3Tk04lFW9GizrBFUs3kHztCT4hKh8SgYxPwUJ4neDhPO+ofpDQeEqaJcH+eTfN4FDOmSApw+VfGSL4YMfFTjk/ETQhHayhLq9MZF/GKfN0dKrr4rXvcLkfatSrf5xcYPvl9HFjXsXTfAhlNB62ouYWdb1i5qPtxNBFxDPsQWosk8ZEiVe7H+J3PJrLNP1XSHSZCLFUv3ETuJJs+ynzL3MasuOWCeNr51V9NvAtNq0w97sJHolZeeKx2QzV38ThlA1dutGPSzJIlyYHHQkwLIEY7bIPuwirIQpx0CTbRjhyRuikUMo2aJzBBE1jY2f22KwwabT0a6w9Ex5PTl9uJhAY0p7BcK5mQnBr0jwM/g4uGaV7qytXq8Ymu09qJe4h5NJOYUlpAsxgkW1ucIGDeRqSKayskfUDvDSmut8YzVOz91zD5fchZ0kXnwU/yiUsno43lBKSFtVEIBvF//p57vjHWpiYniE0pRt2W181nkX4a5mAdCN5S65VuT6et0UQzVRFWWSjBaTWyXSJUuiISHiqKxuA/G+hRjOuZEUlGWy260QH2dSi+7CmPtqCOEoLoUm+Kb1So2fu+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 18, 2025 at 11:06:09AM -0400, Zi Yan wrote:
> On 17 Jul 2025, at 23:33, Matthew Brost wrote:
> 
> > On Thu, Jul 17, 2025 at 09:25:02PM -0400, Zi Yan wrote:
> >> On 17 Jul 2025, at 20:41, Matthew Brost wrote:
> >>
> >>> On Thu, Jul 17, 2025 at 07:04:48PM -0400, Zi Yan wrote:
> >>>> On 17 Jul 2025, at 18:24, Matthew Brost wrote:
> >>>>
> >>>>> On Thu, Jul 17, 2025 at 07:53:40AM +1000, Balbir Singh wrote:
> >>>>>> On 7/17/25 02:24, Matthew Brost wrote:
> >>>>>>> On Wed, Jul 16, 2025 at 07:19:10AM -0400, Zi Yan wrote:
> >>>>>>>> On 16 Jul 2025, at 1:34, Matthew Brost wrote:
> >>>>>>>>
> >>>>>>>>> On Sun, Jul 06, 2025 at 11:47:10AM +1000, Balbir Singh wrote:
> >>>>>>>>>> On 7/6/25 11:34, Zi Yan wrote:
> >>>>>>>>>>> On 5 Jul 2025, at 21:15, Balbir Singh wrote:
> >>>>>>>>>>>
> >>>>>>>>>>>> On 7/5/25 11:55, Zi Yan wrote:
> >>>>>>>>>>>>> On 4 Jul 2025, at 20:58, Balbir Singh wrote:
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>> On 7/4/25 21:24, Zi Yan wrote:
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>> s/pages/folio
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> Thanks, will make the changes
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>>> Why name it isolated if the folio is unmapped? Isolated folios often mean
> >>>>>>>>>>>>>>> they are removed from LRU lists. isolated here causes confusion.
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> Ack, will change the name
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>   *
> >>>>>>>>>>>>>>>>   * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
> >>>>>>>>>>>>>>>>   * It is in charge of checking whether the split is supported or not and
> >>>>>>>>>>>>>>>> @@ -3800,7 +3799,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
> >>>>>>>>>>>>>>>>   */
> >>>>>>>>>>>>>>>>  static int __folio_split(struct folio *folio, unsigned int new_order,
> >>>>>>>>>>>>>>>>  		struct page *split_at, struct page *lock_at,
> >>>>>>>>>>>>>>>> -		struct list_head *list, bool uniform_split)
> >>>>>>>>>>>>>>>> +		struct list_head *list, bool uniform_split, bool isolated)
> >>>>>>>>>>>>>>>>  {
> >>>>>>>>>>>>>>>>  	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
> >>>>>>>>>>>>>>>>  	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
> >>>>>>>>>>>>>>>> @@ -3846,14 +3845,16 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> >>>>>>>>>>>>>>>>  		 * is taken to serialise against parallel split or collapse
> >>>>>>>>>>>>>>>>  		 * operations.
> >>>>>>>>>>>>>>>>  		 */
> >>>>>>>>>>>>>>>> -		anon_vma = folio_get_anon_vma(folio);
> >>>>>>>>>>>>>>>> -		if (!anon_vma) {
> >>>>>>>>>>>>>>>> -			ret = -EBUSY;
> >>>>>>>>>>>>>>>> -			goto out;
> >>>>>>>>>>>>>>>> +		if (!isolated) {
> >>>>>>>>>>>>>>>> +			anon_vma = folio_get_anon_vma(folio);
> >>>>>>>>>>>>>>>> +			if (!anon_vma) {
> >>>>>>>>>>>>>>>> +				ret = -EBUSY;
> >>>>>>>>>>>>>>>> +				goto out;
> >>>>>>>>>>>>>>>> +			}
> >>>>>>>>>>>>>>>> +			anon_vma_lock_write(anon_vma);
> >>>>>>>>>>>>>>>>  		}
> >>>>>>>>>>>>>>>>  		end = -1;
> >>>>>>>>>>>>>>>>  		mapping = NULL;
> >>>>>>>>>>>>>>>> -		anon_vma_lock_write(anon_vma);
> >>>>>>>>>>>>>>>>  	} else {
> >>>>>>>>>>>>>>>>  		unsigned int min_order;
> >>>>>>>>>>>>>>>>  		gfp_t gfp;
> >>>>>>>>>>>>>>>> @@ -3920,7 +3921,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> >>>>>>>>>>>>>>>>  		goto out_unlock;
> >>>>>>>>>>>>>>>>  	}
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> -	unmap_folio(folio);
> >>>>>>>>>>>>>>>> +	if (!isolated)
> >>>>>>>>>>>>>>>> +		unmap_folio(folio);
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>  	/* block interrupt reentry in xa_lock and spinlock */
> >>>>>>>>>>>>>>>>  	local_irq_disable();
> >>>>>>>>>>>>>>>> @@ -3973,14 +3975,15 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>  		ret = __split_unmapped_folio(folio, new_order,
> >>>>>>>>>>>>>>>>  				split_at, lock_at, list, end, &xas, mapping,
> >>>>>>>>>>>>>>>> -				uniform_split);
> >>>>>>>>>>>>>>>> +				uniform_split, isolated);
> >>>>>>>>>>>>>>>>  	} else {
> >>>>>>>>>>>>>>>>  		spin_unlock(&ds_queue->split_queue_lock);
> >>>>>>>>>>>>>>>>  fail:
> >>>>>>>>>>>>>>>>  		if (mapping)
> >>>>>>>>>>>>>>>>  			xas_unlock(&xas);
> >>>>>>>>>>>>>>>>  		local_irq_enable();
> >>>>>>>>>>>>>>>> -		remap_page(folio, folio_nr_pages(folio), 0);
> >>>>>>>>>>>>>>>> +		if (!isolated)
> >>>>>>>>>>>>>>>> +			remap_page(folio, folio_nr_pages(folio), 0);
> >>>>>>>>>>>>>>>>  		ret = -EAGAIN;
> >>>>>>>>>>>>>>>>  	}
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>> These "isolated" special handlings does not look good, I wonder if there
> >>>>>>>>>>>>>>> is a way of letting split code handle device private folios more gracefully.
> >>>>>>>>>>>>>>> It also causes confusions, since why does "isolated/unmapped" folios
> >>>>>>>>>>>>>>> not need to unmap_page(), remap_page(), or unlock?
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> There are two reasons for going down the current code path
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> After thinking more, I think adding isolated/unmapped is not the right
> >>>>>>>>>>>>> way, since unmapped folio is a very generic concept. If you add it,
> >>>>>>>>>>>>> one can easily misuse the folio split code by first unmapping a folio
> >>>>>>>>>>>>> and trying to split it with unmapped = true. I do not think that is
> >>>>>>>>>>>>> supported and your patch does not prevent that from happening in the future.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>>> I don't understand the misuse case you mention, I assume you mean someone can
> >>>>>>>>>>>> get the usage wrong? The responsibility is on the caller to do the right thing
> >>>>>>>>>>>> if calling the API with unmapped
> >>>>>>>>>>>
> >>>>>>>>>>> Before your patch, there is no use case of splitting unmapped folios.
> >>>>>>>>>>> Your patch only adds support for device private page split, not any unmapped
> >>>>>>>>>>> folio split. So using a generic isolated/unmapped parameter is not OK.
> >>>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> There is a use for splitting unmapped folios (see below)
> >>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>>>> You should teach different parts of folio split code path to handle
> >>>>>>>>>>>>> device private folios properly. Details are below.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> 1. if the isolated check is not present, folio_get_anon_vma will fail and cause
> >>>>>>>>>>>>>>    the split routine to return with -EBUSY
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> You do something below instead.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> if (!anon_vma && !folio_is_device_private(folio)) {
> >>>>>>>>>>>>> 	ret = -EBUSY;
> >>>>>>>>>>>>> 	goto out;
> >>>>>>>>>>>>> } else if (anon_vma) {
> >>>>>>>>>>>>> 	anon_vma_lock_write(anon_vma);
> >>>>>>>>>>>>> }
> >>>>>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>>> folio_get_anon() cannot be called for unmapped folios. In our case the page has
> >>>>>>>>>>>> already been unmapped. Is there a reason why you mix anon_vma_lock_write with
> >>>>>>>>>>>> the check for device private folios?
> >>>>>>>>>>>
> >>>>>>>>>>> Oh, I did not notice that anon_vma = folio_get_anon_vma(folio) is also
> >>>>>>>>>>> in if (!isolated) branch. In that case, just do
> >>>>>>>>>>>
> >>>>>>>>>>> if (folio_is_device_private(folio) {
> >>>>>>>>>>> ...
> >>>>>>>>>>> } else if (is_anon) {
> >>>>>>>>>>> ...
> >>>>>>>>>>> } else {
> >>>>>>>>>>> ...
> >>>>>>>>>>> }
> >>>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>>>> People can know device private folio split needs a special handling.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> BTW, why a device private folio can also be anonymous? Does it mean
> >>>>>>>>>>>>> if a page cache folio is migrated to device private, kernel also
> >>>>>>>>>>>>> sees it as both device private and file-backed?
> >>>>>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>>> FYI: device private folios only work with anonymous private pages, hence
> >>>>>>>>>>>> the name device private.
> >>>>>>>>>>>
> >>>>>>>>>>> OK.
> >>>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>> 2. Going through unmap_page(), remap_page() causes a full page table walk, which
> >>>>>>>>>>>>>>    the migrate_device API has already just done as a part of the migration. The
> >>>>>>>>>>>>>>    entries under consideration are already migration entries in this case.
> >>>>>>>>>>>>>>    This is wasteful and in some case unexpected.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> unmap_folio() already adds TTU_SPLIT_HUGE_PMD to try to split
> >>>>>>>>>>>>> PMD mapping, which you did in migrate_vma_split_pages(). You probably
> >>>>>>>>>>>>> can teach either try_to_migrate() or try_to_unmap() to just split
> >>>>>>>>>>>>> device private PMD mapping. Or if that is not preferred,
> >>>>>>>>>>>>> you can simply call split_huge_pmd_address() when unmap_folio()
> >>>>>>>>>>>>> sees a device private folio.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> For remap_page(), you can simply return for device private folios
> >>>>>>>>>>>>> like it is currently doing for non anonymous folios.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>>> Doing a full rmap walk does not make sense with unmap_folio() and
> >>>>>>>>>>>> remap_folio(), because
> >>>>>>>>>>>>
> >>>>>>>>>>>> 1. We need to do a page table walk/rmap walk again
> >>>>>>>>>>>> 2. We'll need special handling of migration <-> migration entries
> >>>>>>>>>>>>    in the rmap handling (set/remove migration ptes)
> >>>>>>>>>>>> 3. In this context, the code is already in the middle of migration,
> >>>>>>>>>>>>    so trying to do that again does not make sense.
> >>>>>>>>>>>
> >>>>>>>>>>> Why doing split in the middle of migration? Existing split code
> >>>>>>>>>>> assumes to-be-split folios are mapped.
> >>>>>>>>>>>
> >>>>>>>>>>> What prevents doing split before migration?
> >>>>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> The code does do a split prior to migration if THP selection fails
> >>>>>>>>>>
> >>>>>>>>>> Please see https://lore.kernel.org/lkml/20250703233511.2028395-5-balbirs@nvidia.com/
> >>>>>>>>>> and the fallback part which calls split_folio()
> >>>>>>>>>>
> >>>>>>>>>> But the case under consideration is special since the device needs to allocate
> >>>>>>>>>> corresponding pfn's as well. The changelog mentions it:
> >>>>>>>>>>
> >>>>>>>>>> "The common case that arises is that after setup, during migrate
> >>>>>>>>>> the destination might not be able to allocate MIGRATE_PFN_COMPOUND
> >>>>>>>>>> pages."
> >>>>>>>>>>
> >>>>>>>>>> I can expand on it, because migrate_vma() is a multi-phase operation
> >>>>>>>>>>
> >>>>>>>>>> 1. migrate_vma_setup()
> >>>>>>>>>> 2. migrate_vma_pages()
> >>>>>>>>>> 3. migrate_vma_finalize()
> >>>>>>>>>>
> >>>>>>>>>> It can so happen that when we get the destination pfn's allocated the destination
> >>>>>>>>>> might not be able to allocate a large page, so we do the split in migrate_vma_pages().
> >>>>>>>>>>
> >>>>>>>>>> The pages have been unmapped and collected in migrate_vma_setup()
> >>>>>>>>>>
> >>>>>>>>>> The next patch in the series 9/12 (https://lore.kernel.org/lkml/20250703233511.2028395-10-balbirs@nvidia.com/)
> >>>>>>>>>> tests the split and emulates a failure on the device side to allocate large pages
> >>>>>>>>>> and tests it in 10/12 (https://lore.kernel.org/lkml/20250703233511.2028395-11-balbirs@nvidia.com/)
> >>>>>>>>>>
> >>>>>>>>>
> >>>>>>>>> Another use case I’ve seen is when a previously allocated high-order
> >>>>>>>>> folio, now in the free memory pool, is reallocated as a lower-order
> >>>>>>>>> page. For example, a 2MB fault allocates a folio, the memory is later
> >>>>>>>>
> >>>>>>>> That is different. If the high-order folio is free, it should be split
> >>>>>>>> using split_page() from mm/page_alloc.c.
> >>>>>>>>
> >>>>>>>
> >>>>>>> Ah, ok. Let me see if that works - it would easier.
> >>>>>>>
> >>>>>
> >>>>> This suggestion quickly blows up as PageCompound is true and page_count
> >>>>> here is zero.
> >>>>
> >>>> OK, your folio has PageCompound set. Then you will need __split_unmapped_foio().
> >>>>
> >>>>>
> >>>>>>>>> freed, and then a 4KB fault reuses a page from that previously allocated
> >>>>>>>>> folio. This will be actually quite common in Xe / GPU SVM. In such
> >>>>>>>>> cases, the folio in an unmapped state needs to be split. I’d suggest a
> >>>>>>>>
> >>>>>>>> This folio is unused, so ->flags, ->mapping, and etc. are not set,
> >>>>>>>> __split_unmapped_folio() is not for it, unless you mean free folio
> >>>>>>>> differently.
> >>>>>>>>
> >>>>>>>
> >>>>>>> This is right, those fields should be clear.
> >>>>>>>
> >>>>>>> Thanks for the tip.
> >>>>>>>
> >>>>>> I was hoping to reuse __split_folio_to_order() at some point in the future
> >>>>>> to split the backing pages in the driver, but it is not an immediate priority
> >>>>>>
> >>>>>
> >>>>> I think we need something for the scenario I describe here. I was to
> >>>>> make __split_huge_page_to_list_to_order with a couple of hacks but it
> >>>>> almostly certainig not right as Zi pointed out.
> >>>>>
> >>>>> New to the MM stuff, but play around with this a bit and see if I can
> >>>>> come up with something that will work here.
> >>>>
> >>>> Can you try to write a new split_page function with __split_unmapped_folio()?
> >>>> Since based on your description, your folio is not mapped.
> >>>>
> >>>
> >>> Yes, page->mapping is NULL in this case - that was part of the hacks to
> >>> __split_huge_page_to_list_to_order (more specially __folio_split) I had
> >>> to make in order to get something working for this case.
> >>>
> >>> I can try out something based on __split_unmapped_folio and report back.
> >>
> >> mm-new tree has an updated __split_unmapped_folio() version, it moves
> >> all unmap irrelevant code out of __split_unmaped_folio(). You might find
> >> it easier to reuse.
> >>
> >> See: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/tree/mm/huge_memory.c?h=mm-new#n3430
> >>

I pulled in the new version and it to works for this case.

Matt

> >
> > Will take a look. It is possible some of the issues we are hitting are
> > due to working on drm-tip + pulling in core MM patches in this series on
> > top of that branch then missing some other patches in mm-new. I'll see
> > if ww can figure out a work flow to have the latest and greatest from
> > both drm-tip and the MM branches.
> >
> > Will these changes be in 6.17?
> 
> Hopefully yes. mm patches usually go from mm-new to mm-unstable
> to mm-stable to mainline. If not, we will figure it out. :)
> 
> >
> >> I am about to update the code with v4 patches. I will cc you, so that
> >> you can get the updated __split_unmaped_folio().
> >>
> >> Feel free to ask questions on folio split code.
> >>
> >
> > Thanks.
> >
> > Matt
> >
> >> Best Regards,
> >> Yan, Zi
> 
> 
> Best Regards,
> Yan, Zi

