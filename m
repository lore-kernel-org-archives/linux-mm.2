Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D880C61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 02:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4486B0088; Mon, 31 Aug 2026 22:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 565536B0092; Mon, 31 Aug 2026 22:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42DA46B0095; Mon, 31 Aug 2026 22:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7006B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:17:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8714E1C0F85
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:17:16 +0000 (UTC)
X-FDA: 85163581272.03.CFD9F59
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012016.outbound.protection.outlook.com [52.101.43.16])
	by imf01.hostedemail.com (Postfix) with ESMTP id A5DBD40003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 02:17:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NI+EJDMr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788229033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wF1bxOQbi4a9+s6iNAwgCdnObG2CpbRj32aHiozIBeQ=;
	b=0CvIfgP9wyOBZ7e0Dxc83LYaJJSsiPBAPn3DRSZNRVwySw+sZSLWZCfrPlyNKg4Pm1bzdK
	h5cQkS0TNhiSoLk52iwXGY5OH/QOSzQju8tmAvSkHXZtUlsgnKopSR2osfkk3nH/5W0WnM
	ftOEa/IJN5BrzzhvoeR3uEa+ew3rTWU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NI+EJDMr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788229033;
	b=QnHLc7A3TVaVcSxQQVfmWTd9GLHeCA/W3b6346z2LYqr/I1oxc+nRXsvPFQ97++GwGZ30w
	z3g8g+/rPN+HFwdCli2cEQwovjutZarWt2IaieCPSuxl3deZjE5zRKU6A0JOlAXgwrF5zq
	RMQl6NOVe6dHtAa8jcrnuNNcGPZsHM0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qEB9EYfpM6XrtiJhLQt5BR/K0o4aFCFAi03ASG+07rjpfxxihQ4N95twrPeac+znx4InXCip1juB5zV3DlABCXiYG9MyLfsbf+5UGixHpKrOuzWek++gSQ4x/mnBQGW6xWlYcA/Siar9XDPwX1+ak0P4NRnwAFMFiBkvKveSF66tZeNzvuj/PNdlt285V/tpxDyEp9x/lqgVw/TCDpMyLgq6BA2jm8xtoYIRbxN5rdFARqVYyg7aQ6W2/Ol5/QMC+f3dchG1R6Ygh5tP4s3uzJqfFsiQMbCajoSlHGlvT5T5PKDEAgklkOVG55v89bALDVeNKtDSFeISbxfo2bQzIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wF1bxOQbi4a9+s6iNAwgCdnObG2CpbRj32aHiozIBeQ=;
 b=ecjHZ38brn+uoH3uXL7QyNKEhjqeamUS0S/hvSzm8M2f4XlKqwsUH0/aRwOwZwUe45BDlOoPoWAuXvCH7T3CbuRtSKPATV+1hHbcBEHJU4cJBSXxnza0v68H91mW0bV5g+86fMPTc16iWJFAwiDjpKPKhieulCVnlvThkAgaPQPg7P59EdTo9BCAyEUVnqs6KpoCD3S1T5pObxPH693rjEHFDMkQxhYmxSa/bE2UoF8GZ5apVBOWgN6Lc82yDuwNWUW1SUJHhvU+gp3g0fhPGKSmW9x8sbvSHMuzMvjo9G60C6UXq1rVBgDuSwP2pcigNjrOSs6vS5qzC3jVOxv7OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wF1bxOQbi4a9+s6iNAwgCdnObG2CpbRj32aHiozIBeQ=;
 b=NI+EJDMr/XvrZ3Ls3jiK3reYqTUg9RAXq6VctDq73r7I/ctQCQOHCPIJZdcNu5+h6+qG4z9VnZOjvNNdPumxtqZCfFGKbwM3T03aPA6mv0aX9AYJbOnciih6zSPE1Wo3stfBcAjZEeDQHUsWK8jk9vBtsrQB5KanjNYIYWzCq9sjFrpYdpgWLXRM6YCbTmja8bnc9dLR2AE/5zSjjy/eVlpvB/Hs8iZgV4UdQE3iMCrbTD7GntkDXKABlAbNEIeprOIcxi5wrz/SbiEK734zah0bOeWg7DRx/Uwiqpk331kDawYeTB71wqf41O64n/CCdQtjd/Kp1EgPeCHmtfybgA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH8PR12MB9790.namprd12.prod.outlook.com (2603:10b6:610:274::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Tue, 1 Sep
 2026 02:17:03 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 02:17:03 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 31 Aug 2026 22:17:01 -0400
Message-Id: <DL3MA7GQBXUW.5L0DGZHLFDHW@nvidia.com>
Subject: Re: [PATCH v2 14/14] mm/page-flags: remove PG_private
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Zi Yan"
 <ziy@nvidia.com>, "Baoquan He" <baoquan.he@linux.dev>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Pratyush Yadav" <pratyush@kernel.org>,
 "Jonathan Corbet" <corbet@lwn.net>, "Jan Kara" <jack@suse.cz>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Dave Young" <ruirui.yang@linux.dev>, "Shuah Khan"
 <skhan@linuxfoundation.org>, "Mathieu Desnoyers"
 <mathieu.desnoyers@efficios.com>, <kexec@lists.infradead.org>,
 <linux-doc@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-trace-kernel@vger.kernel.org>
To: "David Hildenbrand" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Kairui
 Song" <kasong@tencent.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
 <20260831-remove-pg_private-v2-14-3668159cd9e8@nvidia.com>
In-Reply-To: <20260831-remove-pg_private-v2-14-3668159cd9e8@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0082.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH8PR12MB9790:EE_
X-MS-Office365-Filtering-Correlation-Id: 9270ab8a-7bd6-4fa8-9de4-08df07cf1c83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|921020|10067099003|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	n+1yViA+lU3IrsW7hn38MZ/T9TMXvgsV92owyTW79g2VRkfzxFLlSUOEldjVvYtQDbB3e+Wp1ZAVN4/6fklwbFVXayirbh4Hb3GCuuvVquUL+uiMCXxnwhY2ICFTIw2+FLK/ddwWDQWX4CZf9zR+HzrzEP9qPEW6Sc0QTnUcIwJ9Zjc5t0CA3+8YfpZTrH197l9nqHheTkD+GsnaZW8NbIsVxPYbWOu3yL4C7sunO1QsNaLS2FacEKdm0ADKQV99Y0GjI7zx+YgcVnkl1aWujZV8Y51uGWfDM6IH3AHcl96ToK/ZVnZVn9VnZkAOjuwCl0TCfljqORh+yd/hWAmjfbln9SJ3729S8ovNCxJT3FBWhoAGIwZWDoBetT68TPZ6vg7HO+FpNLJCTLyprGloRRhUtBQha9u95cn+ONJiZc9ofQJsm+ZohDfnRjB2jV5ZM9vh5tx7Ayq8XIoV2N4vg8vQH0Ws03JsCMWpEteSCzL/BHgF0TPU4HkPZf6crbHPpWGbwEvI3aiR7q88MgxC5MuJ4jacRG5qHK+kZcnENQAMr0knhSjfwJcV2ayZ/3y9lAeoL6K4ZV1NXy3Qj1GIxMEh4mk7G5RsTBMQBqkdbOLFv1l66RhnqBhGlJ9QaQTUpmDpbW1m/BmmCQWLgig/14iCw4PUMWffo0Gpjb/3OnQrVFEx2VNK7RdlcaxohZJuuEo1BCtD2/OPZquyjhZtMA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(921020)(10067099003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VzNOQXZHOWFTWFk3Q3V2QTVjdGN3ZVZ0REdHc2pPNTc0bTJnOFR0K2ZzcU0v?=
 =?utf-8?B?OVFrREZvUUYrdkVXRnBuRktXL1kxQXIyMnR0OXQ4cVhPVktKQXJjMk01ek1u?=
 =?utf-8?B?b1dQQzBvRUl3U1kwVTFoRUVkY0xoOHJOY2cyUTY2L1p1SndUSEJBanBTWkNh?=
 =?utf-8?B?akgxRXJXekFHSHlNMlJ2WnlTaVlGRm1vVm5WYlNtWksyaWJjWWUycCtnVy9w?=
 =?utf-8?B?QWxTVjdSVzlYSUhsVGRDbW5ySGxoTGhkYkxkYjljMk9pNTFqRHBmOUVRNmFH?=
 =?utf-8?B?NkxFbE5nNCtzSmpFZ0h0Q3JaUy9jdStFTnB2RjhmbytvRXdzWklIRU5qaGZm?=
 =?utf-8?B?RkovaGNsdE5zdzI4VGVOVTJnVC9rTHFsL3pPUWFTcXR4czRsYU1mbTVnR21k?=
 =?utf-8?B?cWYwSG5MdzVJZHBWODNtR213ejk2SE9RSHAxMkg5aXI0bTJWS3VyQzRIdTQv?=
 =?utf-8?B?NFE3SzBKdHJ1TnpIS1hvTWtHcDdCR3JISlFyUEhrL1BiMDArZ0JRbkJ6aGZ2?=
 =?utf-8?B?eStTYmFVU0lNN2xUbVYyaHhhOGhwc2orODNNRzlpcnlPaStuU3RFTzF3U0VF?=
 =?utf-8?B?WGJBRS9yL0pBRlBLNTM5eDFFWkJ6MHlSMWlMbTVGY0V5MUJibTRmWmVNWGZn?=
 =?utf-8?B?SnR4aHlHZnhXVVhKcTZMWEtlZU9PeTRLYVVHZHh0MUtDd2svVzI1S21LQkRl?=
 =?utf-8?B?K0E0L3ltQUYvbVdWWHhzNFdRbDlTZEx2MHA5dHdRWHloekVFUm10U1ZUOTdW?=
 =?utf-8?B?ZFEzcm5nZzIvNTBYOUpZbkNXbERFQ01DSXpvbHl1YlVad1d0bFZuY00vOU12?=
 =?utf-8?B?YThsUEhOamZMMEhaR3FkRHI3ODFmRXZ0TXBtem51YTFiR0VwdlFlN3ljOHNz?=
 =?utf-8?B?VWtFcVpZQjgxbDdKR0NWdUV0ZzJRYVJlQm14RGdUV0gxblZJenpDVEYyZXJ3?=
 =?utf-8?B?RFVnNFBtY3VXTjZWREhjUmhQajBOckx4SkJva2o5UDRlbkJkaW8yMjlYRkJI?=
 =?utf-8?B?SHNId1FPTnNqREJIajZtTUwrT2hEZDJuZTZEcC82VTlKNzBPMExTRklTUWo2?=
 =?utf-8?B?WUR2NEJhVnk4bVE3WkZJcHQ1M2lPMHh3bURMVHNhWk50Um9RNVNKT2FiYWU3?=
 =?utf-8?B?V3Fydzh0U01BQnJSd3RaNXdpMWc1U01XSnc3YWR0WnJlYVJKUm50VnczWkZa?=
 =?utf-8?B?UCs4NXJMS2VlV2JnOWoxbnZsRm1sb1haZzB0NkxHeVNuUE83eUMrTnBWNVNV?=
 =?utf-8?B?NlhNdWo0MW1PS0hCeThiN0w4a1RkcG9YUFp6K3FYZUxlUUdjRDBBSUp1ckt0?=
 =?utf-8?B?dk9WMmVXTUM0UkRTZVMxWE1MRG5XTE5lQm16WVZkQ216Z0pZNCsyUW93OTB1?=
 =?utf-8?B?c1pOOEx4OE1jbjU2L3kzbFVHSEY3UlBpcTB2cVRlR0VoNU5pMi9EakxFeC9X?=
 =?utf-8?B?blUyM0d2dnFURzNLZU4zTjQzMURpdGZ0K1JtUnloR1czTk5BVk5XM3NiRE90?=
 =?utf-8?B?Mzc0eFpCZW11R1NoVkF6OFlrb3ROekVJblVaY2xqdlkyQlpMWDFza1BydU42?=
 =?utf-8?B?WWpPS2tpUHlWWnBYaGRnZ2E1Um5ZbXVGZFhyZFYycUI5S2t4QjR3Q3JMN1pv?=
 =?utf-8?B?Tk5Bbm1PeHkwMXp3SHZ4WmFUU3pSNWxCVy80R2hSci9uS21OSFU4N1NsYzlN?=
 =?utf-8?B?MllQRlpvcGpnME5qR0dzU0hyMGFnRHVTNzNmMVBJZlN2a2hrMTUyd0o4L0l1?=
 =?utf-8?B?K3EzRWlaMysrOUV3R3llTUIwdUhHL1FpNGNCZ3NKZVpjVHR6VCtuODRHNzJi?=
 =?utf-8?B?R2tQdWtpcXZEMWNrYnpyMEtaekI0TVJzeEErcDdUbzNzWFRGSDZQWkxGK3N0?=
 =?utf-8?B?T2xKT3JLbFJoWUM1aUE3djRLVGw5R0hMYS9TT0N6Z1IyWkpIQmlKWWpMcmNZ?=
 =?utf-8?B?b01seFhaeTByYmRtUzRMYzJYeThHdWZaVHdmbTlOcmZtMkxtTjg3czYycFB4?=
 =?utf-8?B?cGlNNnBmSmM4VTBYOFg0RzZWQ0R0ZXdsbXdpWCszYjliVFEwSTdsNnFkWmJT?=
 =?utf-8?B?VTRTMUU3bURrQ044ZCtuME4wa1dHVC8zYjd0R0hYRWJMZEZlTGpFSi9QTTR3?=
 =?utf-8?B?YlovajhUaXVzOUlUYXQrVGxlTml3UkV3NjZsUy8vaEJaSUZKQjRaLzJlRDk0?=
 =?utf-8?B?UnJkbUtaNXJ0OXBqSlNWdStxNG0wSXNOTTZWdFRIb1FIUmtDQ3ZKTDdYcGY2?=
 =?utf-8?B?WlBFSUN3ZEdSTVVQekwrYndwb2dHZVhGZ1I3V3BpT0xHc0FSZk5QVGlGV1JH?=
 =?utf-8?Q?TfKvR8mZVZvnWaA7Lh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9270ab8a-7bd6-4fa8-9de4-08df07cf1c83
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 02:17:02.8978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rUXDkbPvoqBcTT6A0UZFNKBDK/GELWsWjC6jEU9RV3xRE6jhvDnmg7WEtbxBgfRz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9790
X-Stat-Signature: yq8hkkdfp37qptjjz7axt11cr75pas7x
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A5DBD40003
X-Rspam-User: 
X-HE-Tag: 1788229033-24671
X-HE-Meta: U2FsdGVkX1/2M+zHoU0KsJVxBt3yOi2F0HSyQjC/5DnsR+VmsVSxGrKpG62fRw5mEJORX724kvk9BEg8VEgLdvWwX1ntN+I9Yrh8ogdQlDBbmweUF9caCKxoR3aYIioQxQ7xHBPzCWRl9WlWMFoHVloNsUt2TdaVmeyVRww2zAXRFodLpyuWl4LCCr01diHNL20G00igO2PZ72zIh5T4Ctmgkp42Nyxw1KwKxC0V/pyIipm31tJrwIg/zaSJ8kymnwbKJKwg2h6iBxOwVAGHd6bqVL3icIkiOqTgIDajRpp+1tEgwuHcAUMAFA0Y1ulD1S5AZzVQlDUQcZC4j/EyblJjSDtQNQUOgzuV4neHTRLAN35u2rMBjidPX5z6v0Z287+vZ8z0UN/TRwHCxIWjwlzcTQE4o6TYfWhUHdPOrpEvBEgr42jn7Mwp/pXvxqfbfVTmuNxX+hSv2EBFUJzVynafSWPJ0hC1EvpyVFhF5iVp8p7qQqcoC+dLbZBtP5+oo7lyGA1decPFyOU6jeixvlLrbqtxn/vDbfvPFgxCeST1lXHPLzVwGT1w0BMBccZ+I7Cyukbrqd18vpoNvcPF2DgGBNnI+qA+dVg+c/sQVJ0VRKSxzCTljnyOU9V+htgxuSzCWAk+tFKLLk/CWfj4iYRQBIqtnV8dT2uzkVCsO2pn5YIKyWqLDB47dH7UQCKa4OMNwYR7kh+EnfTXrXuEAgPj6Sj9hVhIFtdo0eBWs5k+eKdtxVS7tP5eUY8Lgz3flJ2a+G/4Gm7IOkRIE8tS6+tLk6HQXVHdMxowvLrAe0QS5iUb6Hzvg7no1eIF/fnnMcSmgmrRTbHJHaVkejR3f3as4+6Ptjx96wE4u9hD/zcp9+PWoITDLoIzzNStoZc45DjqEs4BxUsw4/ccq45tZAK+a5p56R7DayPmJe6drPYrDZrXBkdzfG3u7m5llX9f7GWf8zaSJjLMNxRR3Aj
 qe1+SB7U
 vUFuY2fplrEZO2uUzbuwHQwmJ+CT9ULIIIwUTnhyeeFdMC22dE74kic6pZbYUYj8jECIBOHJz/LxDhLlGu9c/qNCKhdBZZb0zA1relD9Bue3CK1EpZH8mekbMNzAwpZV7FvqWryla/h+y31JtVyCbnWH+q4zQM+DhPAJrDNmokVmNb2uNtkFzaNxCPQSaFSWvwkSo5LrfbyviTghBk5omu6j/lCux2pTx71YnfvAmWVZFh5sYlnYxGUDRtCt6BWxQj50+sDfRs92PqJuDDs7QSYqw1aq7WjPCm0kqsay7OdhFViXNW7GAcm8OE8IM2AA8EbxrLFlYH7ES7KVdV6bLq7kEWg5JGHN/7Kcd/YhJqkM3UT1KRBhNHvCU+O4+sQ8xSOz2ZBDlfUTgBwYbEQxecjAqurTyQzG93U2IE94V7+AM3MgoO05OlzngO5eYP2O5+Icc5JmMrSGLttTiYU8AdWGhjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 31, 2026 at 3:25 PM EDT, Zi Yan wrote:
> folio->private !=3D NULL indicates a folio carries private data, replacin=
g
> PG_private. All PG_private users are converted. Remove PG_private and
> reserve the space as __PG_folio for future use.
>
> Also update files in Documentation. hugetlbfs_reserv.rst is outdated and
> left unchanged. It should be rewritten.
>
<snip>

> =20
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 9b585e68127a2..eb2961ed61018 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -44,10 +44,6 @@
>   * Consequently, PG_reserved for a page mapped into user space can indic=
ate
>   * the zero page, the vDSO, MMIO pages or device memory.
>   *
> - * The PG_private bitflag is set on pagecache pages if they contain file=
system
> - * specific data (which is normally at page->private). It can be used by
> - * private allocations for its own usage.
> - *
>   * During initiation of disk I/O, PG_locked is set. This bit is set befo=
re I/O
>   * and cleared when writeback _starts_ or when read _completes_. PG_writ=
eback
>   * is set before writeback starts and cleared when it finishes.
> @@ -105,7 +101,7 @@ enum pageflags {
>  	PG_owner_2,		/* Owner use. If pagecache, fs may use */
>  	PG_arch_1,
>  	PG_reserved,
> -	PG_private,		/* If pagecache, has fs-private data */
> +	__PG_folio,		/* Do not use: reserved for folio identification */

Sashiko asked how to detect leaked filesystem private data during page
free time after PG_private is removed.

Answer copied from RFC:

After the conversion, folio/page should have an elevated refcount whenever
->private is set. That would help detect leaked private data. I tried to
enforce ->private needs to be NULL at page free time[1], but that might
cause trouble for certain use cases.

[1] https://lore.kernel.org/all/20260223032641.1859381-1-ziy@nvidia.com/


--=20
Best Regards,
Yan, Zi


