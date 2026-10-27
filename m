Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6051B606A336
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JoSCH3b9
Received: by kanga.kvack.org (Postfix)
	id 6B25F6B05B9; Mon, 26 Oct 2026 22:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6896F6B05BB; Mon, 26 Oct 2026 22:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52A496B05BC; Mon, 26 Oct 2026 22:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 203F46B05B9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:19:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDB76A095D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:19:36 +0000 (UTC)
X-FDA: 85366799952.24.8D430A2
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012048.outbound.protection.outlook.com [52.101.48.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id F0301C0004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:19:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JoSCH3b9;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793067574;
	b=E2TWl1REZwNY/YUl6Y0Fn1Y+Mebd+s5woT0UEqAQ4ubV0+62Yw7YOGKsSIxNDbOd0lnNzj
	zK0DlvQZJuTIlqJBPfrwRBdSq2MVUe9TASJKPwsv39QylRZaJsro3t4tb8QoL2cK+IfdlS
	A71o0S1mLFM86XOFxC317dhhwbxUE+E=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JoSCH3b9;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793067574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQqt+yf3lOIwqY3c0HVfgvzGA/lWtCzuq+CM4iPiSKo=;
	b=sRROhIL1cQ8oz7Pc1Gx5ye/no+cbHVIHyalTul4IgL1rGF/Y9xLmITR//HL/AQv0GxoNyD
	VfUiLqO31pnRSJck0O48dyOAfNXZbSK/XjhbBbenFu631AKQXrmE72oz8mkSD92VzRXTz3
	YnYiM7NEmGPOsuI/6k9i9G6nnjJVLcU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fwKcd4qy5wTb/1F/Ycg48kbtFFWQDzkrISm66KEMbWSGDTSljRFhucASj3/6gLeBRS+ivOr8F9C9dBHTsrJ9R20PlpNbpDczjzLMgvFMwhDsQX1Z/5Jn5v6s0/E4cN2GFwvCKNW9uEztXZULC1noESRxJyHbkrxj4OS5k4y5Kip0qbpDOXispIKdkrvKzqGSdgr/O0DC+6x/QoXJbkE5+cw68F9TeZmQ8Dw3b7fvcIsxjVdKdmey6HLAoSjq0P+LsC4NisLOzG7B8J1c+JtpFTHMNDu+c3UdmyTkVBb4jPK4deA5yHnFoaPBEYQz1HvlGlkNAElsTKF7DqcefDAauA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQqt+yf3lOIwqY3c0HVfgvzGA/lWtCzuq+CM4iPiSKo=;
 b=kzptfXt4C9tnazpd90JN0K/qLT20bkmOudTKd1AfWqxpD/KRzxAsA4OPG3b7Mqfz+0DjBCiiG623KQPH66lWtedzpN0YLWH7vmi75JGI94y8zWFknxBWCtRp5LccPuh1O44jJImT1rEF0nAzxqnBiIRDN4OxDocd1Cv0/mmOCXaUhmhrZAbwv+cdOX+qIwPIFkQ181dyiAwBEIOD3rGa0b9veTH2hEbpBsbXOPucuZDJsQGU+3Wx8cRr9RUzjCMNpvXqxQzy9YpOFP+62hsEvb7XOWjM7ZL+P7AU//gEDIjnnsTEJQAK/keK239ATKbUGSdtWCPpfjWH1epYAu7R4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQqt+yf3lOIwqY3c0HVfgvzGA/lWtCzuq+CM4iPiSKo=;
 b=JoSCH3b9DzyEkMK0Y8cLVCK+9UIp0IuZdaSp7HThKTRK5X7D8VVVqmvyP0CJYy9M6p4hobcWrVQISlbqdxCmvxcLQwasQQc09cup/pwoQmpnM6oWGwBz24bWjo1zlxZgckNIWYt34ZWAX26DbkydN8D88+hSvch6m/sxep+ZG7uesyiLJTdqISH3hW7uiplQwlPc4IqQH1z7Z90JnnNN+ElaPZMTjLZypBmdpzu4RPUHe68e0y3rscZjoOStkbOIxTMoMGxViMfZcsoq+8d5lRUrHNX5fp0D8cWIlXExRV8A4CZi0GYDXXXoCAk4HmMizlJnB47UdNRZJfkcLQrcSA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB7737.namprd12.prod.outlook.com (2603:10b6:610:14d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 02:19:28 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 02:19:28 +0000
From: Zi Yan <ziy@nvidia.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, linux-mm@kvack.org,
 Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] mm/migrate: snapshot the source nid before the
 misplaced migration
Date: Mon, 26 Oct 2026 22:19:26 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <A285D1C2-D65F-4645-8A81-7C0B17E2AEA4@nvidia.com>
In-Reply-To: <20261027021721.95781-1-laoar.shao@gmail.com>
References: <20261027021721.95781-1-laoar.shao@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: MN0P221CA0001.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::7) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB7737:EE_
X-MS-Office365-Filtering-Correlation-Id: bb0f2833-ece8-4c57-7fa9-08df33d0ba3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|7416014|1800799024|22082099003|18002099003|261026121527099003|56012099006|11063799006|261021123027099003|261021121427099003|10067099003|261022105027099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	EBzzQ9sjDcDy8mlstBrgkgcoYc2vmfUG7m6VaQnF2tnXz7MIAlgQvBCcTSkVN07uGfNMvvvrCuGVqakE/Y2I0jF2VNGsFSaEfvpsXzr+44ODVyJXPnDyH+NUGIn7dFvbHe1/367PgRmSYxbgi6x9HixHzeLRTM0Gc7XcQydUHFFvYZRdDh6IIkOchBN2jWfRa8vnECIRaVGfKrN4khEpsP2gm98cz+C4en4Y1hpLLY/jaJPOlknnCHpX1677H5YTw4DsMlJwfMEps6Q+vScx+Smgp2YZsOeeouh+5xuRVORspbxUKB6N+RwIjk30DC2Fi/XolqRqQ0hCx7RIBgKeZxeIul6vaxX2p52hy65DQKOGmAU2xrQTnQOZM2Gbv9rftgK6hg40c9Tez1fVWNofZ+LlzrDOiukXbjnRi7qpTu9FRuqLREdcGlCYYUnmMkiipa0zdeoRTeUNul+qs7da6Z9fhMR2Gfqp3yXdqy1+TyKEC9QwlfN2Kzy3qwQc0UDIRZEdvUcmcUwy+81ZiIrocOga8ku+mNRDf+bXxa+GiB6pBHMo5qJMiulCb3ROn1EpzrYKM8vUTwA1TB5eXEm4EcyQwqGvOvpzXDeJgMITz38ecWJ6RRSih+jt562kkf/vDtkRBMLxDZx0EW9kS6dWXmkusNFOKJeaG6qDmO/7mqI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(7416014)(1800799024)(22082099003)(18002099003)(261026121527099003)(56012099006)(11063799006)(261021123027099003)(261021121427099003)(10067099003)(261022105027099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzBaU1Y2c1RCTWhsM1l5bExlZHBIa0NPSTRNZkIvckl3N0w5VTVORm5CWVlv?=
 =?utf-8?B?K05VMDdpZjNEeVBsZzcybXRSU2kxOWpOalVlQW5sdEd4RzQzM3NjZTdJRWhL?=
 =?utf-8?B?RnVPM2JhalRFZWFFVFowd1V0QkE0emdrS1NyWTdwVTA0cFVuYW5NOWxVdS9V?=
 =?utf-8?B?d2lPT0l2YmFuVzdRVTZNa1VOcTZwS2F6Y091R0RIVDFndTNoS1ptVkRFa1FT?=
 =?utf-8?B?dVdrOC80aW93WkhyU1NWUjVXVU1HZnY4em5ha0JFVlQ1dkQwMXJSMllyUlF1?=
 =?utf-8?B?Y2czNi9ZazBRbGpvSThWN1huY3Y1anUzNExRM1V1a2xOVjN0SWpyc3NaR3o1?=
 =?utf-8?B?Y1ZUWjZpWmlJZkdRM3dTc2EvNG5DTjFYcGIzVUVlcE03bEhJYURXT3FEQ0RT?=
 =?utf-8?B?WS8ycnVsSVdJVlFlM2hvbXcvY1NwOXQ5WWIzQ0ZYLzQ5N0wrVG1YTGdrZnlm?=
 =?utf-8?B?eFkyTVdqMkhmQnFPNk1QRmlCZkttYytSU1JFNkl0Q1d4Rm9qRmlReU0rOG5l?=
 =?utf-8?B?eDhoYlBLSDl5UFV5aGtLeitrUUF2b21nVDJCc1hHc0ZxUkdzSjdCck1MdXpQ?=
 =?utf-8?B?Z2VhM0xDREFhMUdkU3NURXd6Qzd6cFpNQm9QeEYyMTNXaFB1N3BwOC9wMWxn?=
 =?utf-8?B?elJiVnJ1TWQ0Lzc4cGFFMXg3ODFNdjdyYXFJMXFTelppMXBOQkplU2hwd2hQ?=
 =?utf-8?B?WU1RVXFpY3NKREFIaFhjcitrZDBycDRrRUZid3lRQ2VZNTJRNW1qdURRSkR3?=
 =?utf-8?B?MnB4aXA1VmFaYWNhdFNCRDVtSG9vQTJ2aWdzcFluWU11Z2xkMWFVdG5OWGFU?=
 =?utf-8?B?VFA2U1M1STBYbmg5QlNaOTZzLzZIVnlvSnl0V1U0OXcxd3pOQndlQktBYUtm?=
 =?utf-8?B?SUNoRXovakxIbHZvcHIzWXVQTnBjRm54RDlnL0pMV3hqZ29mLzVTTTR6YzBt?=
 =?utf-8?B?TkpIcFNPbWlpNUM4ODFCRlQ2aE40UTN4YWNVZXN6T2xjMGs5S1J4N1VSMW4x?=
 =?utf-8?B?TkZ0NkVzWTNqZEd2aVc2TkZZcmdUTDVLN1ZxSDNmblNOM3o0TGx2cGJ5MC9o?=
 =?utf-8?B?VGtwdVJvVDZpR2JlT1lkakZpdVdyY29QNVdObzkxTlgzQ3FVZkl3cmxZNzdv?=
 =?utf-8?B?RHRtcWFyYkpXVTdJZUI3NjhBTldaNGNXeWRqd3BhbGZzdkQwNnp3TnRUTXlV?=
 =?utf-8?B?aGdLM3UzYjJJMFc4N2lDWFVlSTV5U0svWVNhVHVsMGo1ZFRoVjlDcGxuUGJu?=
 =?utf-8?B?SDFiUDNiUmE3RlczbExiY1FMeUlRV0x5bUM5K2ZMOWdyQ2lpZUdFTjJxVGlK?=
 =?utf-8?B?QlJ4WkZEOUxnZVY4aWpvUnRCdzBxTGhmZmxqeStTclArUzN3Vi96YXBMTVZ3?=
 =?utf-8?B?S3V5SDNUZWZ1MndLRjFxOUN0TU1PUTZ3REZ5TEVEZXdqa0pJa01iTzVxSlcv?=
 =?utf-8?B?RzZnck5ySXZMa3BpRC9Zd1IzTU03NUFqYklOVWRwbGdYMFIyclhQbE9ZTE1s?=
 =?utf-8?B?VDBuZks5dVNGK2JVMnlnR3l0eVpMR1Via0dhRXBDWjRBUE1nMVFZUW9qK0FT?=
 =?utf-8?B?ZWtTemdwUS91em5nUVlzWjh4UWd5MkFoRXhlbThBVnRmdlhjVVhuQ0hVUS9k?=
 =?utf-8?B?Z0J5M2VNdGpWQTNsTGQ1dUVZOHJaZlFZaWtLZWQxajNUSC80cEk3UWZZS0xL?=
 =?utf-8?B?SHVPMm91ZHZZbUFXN0lqc2dya2Q2SzAxL2pKQi9kTlo4OE5sUXBjZTVFdWdr?=
 =?utf-8?B?d0Jtc3hYUWd2NWNGWlBBZ0NSdElQM05vdzVFUEtUZkJkNSt1OXE4cWlwUU5D?=
 =?utf-8?B?M1dWWU9kazgyM3gwMVQ1VjQraGV2R1RHTE1GUDlFcUliM0FCdzg4dnRKSzVJ?=
 =?utf-8?B?S2R0Vm9wR054N1JkYWd2NkZNbDNYRWxORGZzODBKYTZIeHByd1U4c2VWVEkv?=
 =?utf-8?B?SHk1YTBLaW5taFZCT1hxSnM4cThsZW9WYzYyMXYyZjVyc0wrTlVRZFFOYktG?=
 =?utf-8?B?L0Q2QnpxaXBFN0xBNWF2cDNrdmhseWVVRTN3Mis3WXI4TjVtQmF2Y2d1RzY3?=
 =?utf-8?B?YStUT0N3NzQyaXRHelJUSnhzZHZIN0E1VVhrSHBoUlBFRHVCQVBkenQ5bkNW?=
 =?utf-8?B?bmRSTWtxM0xiUnB6Z0k0YzdBRVFkS0g4QlNpMFBkYU1QR2tNUDVZQzM3cGgr?=
 =?utf-8?B?bCtWVWlMWmdhcHlaWHU1Z2xrLzBPeHdrRFNrRFR5Wm9xMkxOd3VCbnFLcnlO?=
 =?utf-8?B?OXdyc0xxSzFPVWpiQUZ4ZDQ0cU1YZzRCU3Rmd3Fid1VPNitqem5hM05nRWJL?=
 =?utf-8?B?K2Rmdlliby9KUkQ0eHlidTNhdFg2QnhYK09ROGpuY0h6c2FDMVo0UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb0f2833-ece8-4c57-7fa9-08df33d0ba3c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 02:19:28.1715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sph2/Iw/2uHQ3m1MxjyiAakb9amJe2ZnPBYlgpSu71wnEOurL76oFqudl1nhbCMz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7737
X-Stat-Signature: g5yogccmoargk1ifz43965c1oqmo76mf
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F0301C0004
X-Rspam-User: 
X-HE-Tag: 1793067573-558760
X-HE-Meta: U2FsdGVkX1+n3ZnVl3iI+EDBPjM3j+AmqCU5AWHXPuKnbmJH8iGEwNYCsOWV3nGAoegp/N+pXOaFeBqzDo9R3KR2tBBlHuEpS7UdYAsmb2VbVvKVbv5itN8ogFXclTA9i5XlbDIJbY8M1hODozWboSPs67aKKfmx8STlc2AX90l/m5EphVOwEZqDj4wfUQwf/PeM1R5w55l/n8bFMZpPnzpxoPGiEpAyPCvjKV7uLdY+J/xLU7WM3FYotMUOFoKBfbOsxwe5M5dCE4qbsiCXF1/nee8CJgQMIIQsNdDk0K3JwhNEeeEOceJ5sMVlQaZwcu6iN5jAkUhxwh8RKsBRw6Fjgy1xdUHlzRy3LIfwMf3W9jUiMi7NAOY/IUaVLctvCeOIBOFqpZYS2KacIfjxU6bLjr5uLXMyh8HSgMN8syE3tI9tMpe/LP72/SvoJkm/HA/+VpnA13QEd7zvps9RQ4aN+d4G7wSPYl3ouZYgY1Ert03eG38k62rhmNlQwzqLf6iulXCjr7b2czEMc2hsgqqbW6kyu0tAnvQqeWvuImpSyELKvvEe3ngIJniLIHbJ5ZxOL4wv6dMhNei64818Os7HyzTQ82Zmd9GObgSYIcyas5izYK21DXa3Fhn4zbWrb7ZNXiGrPdDuCtUC6+vlBy3+x2XBgpsjMAM4F3CgHIzWyomLQJrWM5Z4Rfpa+xO25NypqrK02b7dOqYbqNjkHRqJvplr3FwOZY/ScE/gYTtpmnU8U32fkEbMUOR71vtcdRtMOKtcvTj+FGP23FviE8FL7eruoacS2VRl+Hxz6KK/MVQmUhikeyIue4O7ykxEsn1QeojbSN3jpwFoi1c048WV7p0UjNjvy94tQ0A2ZwzWZQ5TgMdulvZvOp52mJDkYO0mz4Y2q+B6p55rAw4K5K24f5FWetIGgWLtGSU+LXNBPlUVEMakri6O2G0rISFERsAOC8GWx17rQpJqwDe
 jr0m99YX
 8j0wTx/zOgSpXCQLdB9Hr6k0RelYGzged+NP8dV7ZXX3hg12297SJzRihSw8OiC4ej85aS7/e3EEpv2Wl+agrL8Swxi+ZNHuszmSAye+cGn6E/ODdprv6MraZQRwI5J//TtR80ew5ap/g/MY1Aa7KokAeF8SGUupQAabj0Opp4xDwYJJVNuSDrU+yTfeUZ4mWOkUdEPW7nkMbwq2XzMrsXdju8RwT1yuAwneHjmkp8CPBPnB5PQhfq9hhdYcJxkkcGd10HjgOViulk19Y9W/gtyrTZrr0Tuxholw/7/UPqMnFxLSORjRkUJ5tY5/+glX7lAN9EJxqiA2Qxu04WZasP8viHQoh0II3/Bh9k3fHYinKiNFKPWDuIGWpXo8L7PiOCeFDsWrIkoeYaBXv0eFONdi4r8LhpVJG2CIebFRED2Lg22Bwz+KtJfaSk0avkrD/Wmul4S6bsDWaO7w/8F5QkVgOGk4Wpn8moYGRn6hB6hIWrO8usuD5aD9XobWcbK1MWvdGV9BAI8qPQzqF+3XbXK5Xtq8natDcqSnGcAecA2xnEiDf4xI8qXh89ERYd7w76MTuP/xEyGYvpfdGwnI7s6a+sQsUna4gJ6RtGsFiMgHlRCC01CKzWkiraJyfKhH22CM9N6HAetQmdAioLcMVqbZ0TiBN2DDMKBRe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26 Oct 2026, at 22:17, Yafang Shao wrote:

> A successful migration frees the source folio before the promotion
> counter update, so the folio_nid() read there operates on a freed
> folio — which may already have been reallocated. It happens to work
> today, as Zi explained:
>
>   : Strictly speaking, it can be seen as a benign UAF. It works, because
>   : 1. folio->flags happens to be the same as page->flags,
>   : 2. folio/page nid is stored in the ->flags and never changed.
>   :
>   : In memdesc world, after a folio is freed, I assume folio->flags would be
>   : zeroed since struct folio is freed and calling folio_nid() on a freed
>   : folio would give a bogus result (yeah, it can be mitigated by not
>   : zeroing node field and each node has its own struct folio pool, but that
>   : makes folio_nid() implementation dependent).
>
> and Matthew explained further:
>
>   : once struct folio is separately allocated, it's a UAF.  It could be
>   : recycled to a different NID or maybe the slab containing the folio could
>   : be freed (assuming we're not holding the RCU read lock at this point in
>   : migration, and I don't see why we would be).
>
> A separate concern is memory hot-removal.  With memory-tiering mode
> enabled, successful migration can release the source before the
> promotion-accounting folio_nid() read.  If the task is preempted there,
> an otherwise-free source block can be offlined and removed first.  On
> the x86 path, removal can unmap the source's vmemmap, so the later read
> can fault.  The snapshot avoids that read.
>
> Fixes: e39bb6be9f2b ("NUMA Balancing: add page promotion counter")
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> ---
>  mm/migrate.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> ---
>
> v1->v2: improve the commit log, thanks to Zi, Matthew and Andrew.
>
LGTM. Thanks.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

