Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56A09F532C6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 02:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 165EE6B0005; Mon, 23 Mar 2026 22:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117386B0089; Mon, 23 Mar 2026 22:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0057C6B008A; Mon, 23 Mar 2026 22:42:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E516D6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 22:42:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8355F13C15F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 02:42:55 +0000 (UTC)
X-FDA: 84579409110.21.E2380D5
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010006.outbound.protection.outlook.com [40.93.198.6])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9B64B100005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 02:42:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fKXnmC9u;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fKXnmC9u;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774320172; a=rsa-sha256;
	cv=pass;
	b=YVWNQmPAirYuEYscEl+qLx1lVH7uCdtiXakqNcojgHFxYnVsWfCfk5zFeBZWIFR7lGo2oI
	V2s2YjtCkIUoldocdSvUQhEoWAxiuYYY0okKDTt+ba+VQBlVOItAaYXr6FtjKc5Xjhrgsb
	NB/m4CUbx84pAYyzlqsX2qtTYQ8INOw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774320172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IoM3bgdbqVwoZivBcMW54xgrKtT9t+Fu+TmuWVMsVCI=;
	b=DXW5aj+wON/Qtmk/LI5DdyVG2tCjQj2qXKjdYwQL0/QBPqsXLDR4bcvdpq3CGv/jN8PV1D
	QUE2loSSM0wPlRZKYNykRVXoSGKGY1Ge4aYCp2oHPQWA8XDRYpvKWxBeXTPf+KGhgrLYfE
	kHAtAtP39ZCyZWepEPbZbw9Uke+ZkBU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rQI5uk/NPLhyrw8jaeYv5TKe1OKfX7bU9dbaSm7Of1T3lGXadUpi/Rq+LELNjsKFdLXcdlxDJwNLsmswppZhlYToIn+QW+H9GAMQiQsLndkPufP4P31MJq1ImbsAmGPpyn6fW0FOPiemPbUCDL/lHYJEIu+RH463N2wFTmnYFFMn9Z0oxVv0YUHNZOEEE1kqMcLlU6u6cnCZ+XBrhZX+oyKhq9INiJyMAAc5ZI8pOd52eWrnnRmn4ya6921JKePdkA81pNcAXapLxiZ81CdR/KZDpoPkWTfrZ/ZXNLVyH8lid7O1wYpKHZAEnPvrTUQMJYAg5abdrcaSE+YvYhAplg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IoM3bgdbqVwoZivBcMW54xgrKtT9t+Fu+TmuWVMsVCI=;
 b=Akv31rL5nJEuHRELMxxAreJ9FVuViypOkOkbO4FiBs0KE/NkmfLmJMea2Hyi5lq/Ww3zwlY8vZ2b+wbPWAnO53WH6vHN3PIqGcBGURvoydyb0GSO/serGIe+hj6sTKHSapTDMGn4FYh/NfkAH5rBFZfZk5AZrMg9Ywn1XfbQi7eQaeqGSckW25i88enV5k6qSw6i4pJz2ArcgY6TO3gGxFdStakZg/gXeUpqk+NAUOl/t6D6S0r7hK/8s3nghIi8fymJ/jiYeBzqv9blD6CyA71VSdINr92OXcp3aY7n5Iw2MVFzzafw/BW0fDJDpAt8DORAFunWm6+KyKV/Cca4Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoM3bgdbqVwoZivBcMW54xgrKtT9t+Fu+TmuWVMsVCI=;
 b=fKXnmC9ul3ApzyIE3kMNp6wAlXXdaKuxGi4IWIpMIcNt7mRwygVnwLZbx4Xgi6lUlcb904QKYsdL9cC3O6EFddav0oE6Kd4GIBJEtBhIpZhrHsG8y0SzfAncHmDvCx0XtidkrKBZKSRungTdIO60pLzvAlJu/dQ582aMcSq60uQ6VD6OmT+Cupx2piem3N8cgOIRkFcNHOQx3+AeWZQ+QfXvxBtUGBcKyw95ADxuz4LMia8FPwkgfBBORfg1nQ1/tmo83qeUejVLXiFGLwZoV6FgYZf5dd/L6GTtcPfcqx13H7l/e1HWOtDw1caTVCEyWr5M4Dd4INjU1UsyokYNaw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV3PR12MB9233.namprd12.prod.outlook.com (2603:10b6:408:194::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Tue, 24 Mar
 2026 02:42:48 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Tue, 24 Mar 2026
 02:42:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Matthew Wilcox <willy@infradead.org>,
 Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jens Axboe <axboe@kernel.dk>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 0/5] Separate compound page from folio
Date: Mon, 23 Mar 2026 22:42:45 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <3C342301-A8E4-4EC4-BB9E-9C8246F8D6F7@nvidia.com>
In-Reply-To: <c1a2a49b-8141-418f-b239-167ef031451b@kernel.org>
References: <20260130034818.472804-1-ziy@nvidia.com>
 <c1a2a49b-8141-418f-b239-167ef031451b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: IA4P221CA0004.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV3PR12MB9233:EE_
X-MS-Office365-Filtering-Correlation-Id: e3cd2f7e-b073-430c-ef86-08de894f0962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	fq1fq/7na8si+bleahROdoFdKS5zMOJ7IJGPtPH635gDUpmQhVnaK4wpiRzQbyAh3u5HoHg6khbTrgMPNxpUi91FdXynzIAejCUQz8hY/8CJKAGqp8SgATh2OSAdbmuH2wYGTASvWN4i5tG2oCy6S2hrZvrEmZwH1xNgZ89+hpiRLtszAQxmbogj/ilstvuvCRVvZ9yIUtTcdq2pa3V3rwBjL1+8y/3qAsLqZdKZMvDWyyRfG98WH+gaK7pusUipWL8R6LQ6BTe2guWfmYODL+s+8amKoZRouq8BL7syDJBauH/A87PlTG10K//qx3dDm+M72HtT/QDazgLPvmNFV2Iul/EQa8wGEwj2VSX+EwUO0jBhPtLPhkkqFm9Z3qSwkKpNod9lfbd+WzDn9uiUonQBdUHn6KkMCqVQFUZ52tZ6cPLspmXZaSjgwPz3jlnLH1TVEWj2ws7Djxv1ss5GOn+eqchz8ITgFVIYJvmdKPUyF58AVCexeFwgfSwJ12qsTWXEhpBgRuJ9tpNyxXojeTd1txlaprmCN8e0zIzjsDCgYfWI+4YsFnW2xsVIBWUXwuvbSwWOvsUc0i8Aj8PrOnsZ9ZAVdTcffmXwL97DBKKVPOqG0zFBkCKcXZ4fPK7EDQbj93fpd+bZUypYIMX96P5mS9qIoxfWyuHoEtY6Nijjs9vuC6Z6Z5OEtl4e3xApOJECR5dyeamwlMc3t65wiKJ6MpK2ibFLBOxL8v1c1QI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NHAreVFpN25oRHFzKyt5QWhURlJacmp6NFdLN0ZkK0R6WTcvOFZ6WHU3VDdP?=
 =?utf-8?B?Q2hZQXlKQnlYOHhoRExjZXpWbStRRkpwS2M4Ky82V214MWh5SWMvNE5UcGgx?=
 =?utf-8?B?WXZCYTRnRUxhdkE1T3FSSThZYmo2VDdDcTArQ1QxODVHMEVVdWtSRkxvNWFy?=
 =?utf-8?B?VE5ZM0R4UElBREdkQndFbVdjQlNISGlBY2hzVFNRUmE5bkFLQ1pOL0h3SzBx?=
 =?utf-8?B?UkZaaWZLbEtNd1doWDd3NTB3a2Y3NkVsN0RuenNGaWJ4VERBRDNNeHZhSERD?=
 =?utf-8?B?d1FXVW5aTUNoVUpGWDN2MWJjWDFJeFJUaDMwWkhZY3VFMXNDcEE3WU5aUURF?=
 =?utf-8?B?MkQwL1piYno2OGU4aGxCejBRT1pmZmllczJHNlNSMEhXb1lUSkJqTHpDSXFo?=
 =?utf-8?B?S2FjWE82SG5tMTh6bHF0a2tram9ZNjB5azRPaXpXVUVwMXRtZE9LS3hYTGdD?=
 =?utf-8?B?OXoybG1yd3AwM3pyL2YzMUUxWjdTZTArTzVTckVoQklzVG8zWndsd0F5T2hi?=
 =?utf-8?B?RXZ5NnVXa2htelc3MTQxeDNHOC9LZThWK1BSajFXbTR6VWFOV1lBWG5ZdUlM?=
 =?utf-8?B?SGRBR1A1ZTNKYUEybENsVURnSEFEdnNMSUhHaWtHSWFDc0xmY2ljVENUMjlU?=
 =?utf-8?B?RjBWa2xwdkdoRmE2NTB3TDgwS1AvTG9QNmRRZXNac0hJaG5EZXhHbHdaaW4w?=
 =?utf-8?B?aHFUZERXUlRqRDJyK045VDZ3OUR5ejJyZ2pERTRrOU45Ym0wNFYyc1dNa2Rv?=
 =?utf-8?B?Y0l3QVhRbStxYXpoTzhndlJWYmtuU3JzVk01djlFTHlmR3Q3S2NXdVBjQXpj?=
 =?utf-8?B?Y1h3YVFiUnNMaVlISEJ4NEZoQnkrRmYxOElNMWg1d3VBVGJiUTE1dTJTNzJm?=
 =?utf-8?B?STlPMHJ2VGMrZERQaU41T1M3YUhENmpVUTlSdUExWWFYMGtIUXJiNWYyQXRi?=
 =?utf-8?B?K0M3VFY1SkI5YWMyVWhic1FMUEhSQ2FkK01RU2o2NlRvSVllYjBRWFc4N1l6?=
 =?utf-8?B?TnNTZHcwaXJ3aTlKeWd0SEZTUXdWdDlVdENzLzR5Z3ppRlQrdzFsaDVVV2dw?=
 =?utf-8?B?aVFYZGszMnpnS2NNRmdoenFxd1JmVlZlSTBhVlVNSlhQTUw4bUc3WGNWMGp1?=
 =?utf-8?B?dkw1V3RzbE8xVVA4d0I0N0ZNR2NLVnU3aW1sZDlxZ0F0SUwrNTFjMTZzNUJM?=
 =?utf-8?B?M3IxeWd0ckJPaUErWU1yaWw1cnp6RGd5azV5NlFsZjB6UFdDVmthZURBZVA3?=
 =?utf-8?B?NGduZFVYelltVmRSZWo4YTVGdDF2TG13dTU5dXFVaENOVDM3ZVkzaXB0V2RG?=
 =?utf-8?B?bWJKMk5UWjFKUitzMmUwQXd0VlhMNlpOZHBxcHlHakJCQ1NteWZwcFFSQkw0?=
 =?utf-8?B?ZXJvOEU3WTlmRVBBbG81TGV3TlE0WlU5OG9JaW1zdndsQUFzU3I5cVVSMVlE?=
 =?utf-8?B?L3JyVXBQQ2xGZ3BpRzdteXhTKy95bkxhOVZ4Q3EwVkdxMk1EU1d4b2JZM0t1?=
 =?utf-8?B?R2J3UWFJVXNST1d3UjZsZUNNY2M5UExOYnd4M2pnWFBBN3RyVlN6UklKNmJp?=
 =?utf-8?B?UXBNUEJjRTBodFdxeDZIN1FzRUIxVCswVHRDNUZodC9rM1lvbXI0UmExYlcz?=
 =?utf-8?B?V3ZKclRSSUY2N3pKU05SeVJJcThBOXo1WHBSOWc1eUl2YW8ycXJKV2RLeEln?=
 =?utf-8?B?Qmk5UFUrMWFWNjgvTGNadVpSNVFLYTFvbnZXazRVWWVsVEUvTWFVZUU3LzdX?=
 =?utf-8?B?anIveXFOVVdOdzBYb05ieTczWUEwY0ZrTm5BTklLK0JZd0R6L3R4cnhEYVBK?=
 =?utf-8?B?OHVHMnZqbXFWR0ttZG92c1VjNjNsUVJYUG1mRVBYaW5kaWwzbWRwMnI5aFB2?=
 =?utf-8?B?bEFSd0lXcUp6Y1RTY05QTjdOOVRJSVA5amxBelJSWkJSNFZtOEs0RkhxWms3?=
 =?utf-8?B?TTVxVmpGYXpORXEyd2hIZFh0QVFDcFZSUmdTNkxDdmNBZytlVmxSK2JpbU5G?=
 =?utf-8?B?OEdGSFZHaWFHNkNabFFrUllyVWw2TUdZZUNmcFdQZ2V0S25ndkdKQTFSdkJh?=
 =?utf-8?B?ZFUyY2ZZODJjWEwvaVAxbW1sYkdMWVdYK3g3ZVE4cHZIcy9EYnZDUE81UnBB?=
 =?utf-8?B?V0tRRndaQVp1cEl3ZzJldzY3dmNtWm9KczFob2c4TVZWTGc3YzBNMzJldjQv?=
 =?utf-8?B?MHF2dWZOR2JNTGxiYnJQTENrU0psbXMxbVlWSGMyWWRYN3FVdUppdUQ4UmRs?=
 =?utf-8?B?cGhOdnllTTdpOExsWlB2T0xFcjhqVzhzWDNuWHRoQ1JDUk94WFF1TFlzdUZx?=
 =?utf-8?B?QjRnNDc2Tmd4V1NxZTErMVNVNzMxMTR4MWVxeGxwT2RKWXZxR3RiUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3cd2f7e-b073-430c-ef86-08de894f0962
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 02:42:48.7453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 58unpazNI99KwYDZirGiRdBsQrPHrhruDaq+knYN9VojHjilcKEBp/wW15kAcCEX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9233
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9B64B100005
X-Stat-Signature: 89qem5k41rcet41gi9jbyogyq5zihtsw
X-Rspam-User: 
X-HE-Tag: 1774320172-224406
X-HE-Meta: U2FsdGVkX18P5qD+OTTAmnSpganZOO8thITRMkSrapL6HhZPBe+rFOJ79xkWFhQ9rl58xkRt3uOFtsjmjNcfBdQz7atQuDhHuxfBbm9ObmF4dhC4Jden6zq2vkBxXfuBx07OhnmHT5qhNqGCfHCsu0DMqxWODX4DV3zvdtRZfk3P+YNZpM5u06PaPD0mD5QSLe70hb8UGtJ5UFRlU7w5Snu1fdw0mGaWmaGOJ7EC7dW4ZIgrsliCH0Ab0G9DllmgUDRV+zgz8AqQiVE2UJBywgkzNOb/CCyqgjHDqOIKoJ9Q1FWV5GRSYEBpibLr+i/KbYB6NC+jBED7sWHy6IMsVsSW0yIHCRhfKM8XPK5XjnlkcTCOP4lNb9nIQaKFp71CXXXCfT4LpIROncpKnzKcNpj9xNkCt5CtCoTzUuL+VMnk6h3yoYGR8yWBZrlW03kIpwc3d92zPEmf4lLicJrL86kM6xCeF979cVKSUEyJjKwPsyFIg84vdYDBc+4gK6AgXnfA6WUU35itTe29UvvhzNWJ3lH+BXs2RY181FKvh3WaTWlD0S60JGEWgYS5i8gcfpedq2QuN1LEKIwxCV7jQ8G2aEXOCnodXdnDBwb6h/3QAmFCfDj6Z5N5u6rxeDyDdN6GPmlkuDIl/D+bswfSLcihwa6qm6Y5tPm5x8l+r1FoR1hnNMRDvwEZ2Nhvp0bh0huMIPIraTxTo0Osv6tBMUNpPXRqw9zUAZA9QGXs/GEzljaZAWxyCN88v+K4TRPfr3zKcpV4jyp7WV3MLkaMKKR4Y14jxFO3HG6xm8KDA2d4nGuKDbzh8z7Ftu6T77Q/H9r9WeVa3moonRryB4vact0E2qtTSu5Y/Jzd+tOZJzpAn+WYRB3y7bh/9oxoWdBF1HtjYcInkq4F0G3tRmD+MdJY4dYjG0gGvvUy7vG90f1mZ7M5mQ/uaWQcOlXf7mRWAntKiWR8tDrB1bnd9zs
 l7NCyYur
 Dp7bPMKihPwj5tqO/ozbphRGnZmj3aXCFnlH/fJPPgyhfjpof6zmK8uvmXrtZ8U5zrd3tBCy3yUylP3wGLaT/GEWm/8LoEigCTgmf2ovwYH6LroUDy372eMqV4O0OAKb0tyXPGzWz9RWovjA7gk6dPaWtayWqAmM5yiCLNpRmntljV0q28bppe2ueRZijUITU/eT3aOCAyFVLbLpbj+rvPbkIHChq0Gqs09nYUWtgdkQgs3m8jn+FC3R6h3x+Xjc2qrltVBl4U/jMyD9zIGI9JZcGdt/qV8umxDL5MIO2O8sHvt3hwFIuU9jQv8zy79lF0OdA0d8u7KiNeXFzhUWEGiP8J7tKkDL+7ED5471YWKVSuh8X33/W3rhS1WzXSU2v7F4YfDx4X3MHWOSUp2a8WU/Piw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Mar 2026, at 6:21, David Hildenbrand (Arm) wrote:

> On 1/30/26 04:48, Zi Yan wrote:
>> Hi all,
>
> Hi,
>
> sorry for only going over that now.
>
>>
>> Based on my discussion with Jason about device private folio
>> reinitialization[1], I realize that the concepts of compound page and folio
>> are mixed together and confusing, as people think a compound page is equal
>> to a folio. This is not true, since a compound page means a group of
>> pages is managed as a whole and it can be something other than a folio,
>> for example, a slab page. To avoid further confusing people, this
>> patchset separates compound page from folio by moving any folio related
>> code out of compound page functions.
>>
>> The code is on top of mm-new (2026-01-28-20-27) and all mm selftests
>> passed.
>>
>> The key change is that a compound page no longer sets:
>> 1. folio->_nr_pages,
>> 2. folio->_large_mapcount,
>> 3. folio->_nr_pages_mapped,
>> 4. folio->_mm_ids,
>> 5. folio->_mm_id_mapcount,
>> 6. folio->_pincount,
>> 7. folio->_entire_mapcount,
>> 8. folio->_deferred_list.
>
> Noble goal! :)
>
> As discussed, the issue is still that interpret non-folio page
> allocations as folios, which can also be compound pages.
>
> Now, there are PFN walkers that do that, but also page table handling code.
>
> Most prominently, when mapping such pages through vm_insert_pages(), we
> will call into folio_add_file_rmap_pte() and essentially touch mapcount
> related stuff.
>
> Once in the page tables, users can GUP them and modify the pincount.
> Other page table walkers can just similarly find them and look them up.
>
> To stop messing with mapcounts is easy once we can reliably identify
> such pages when mapping/unmapping them.

My current way of doing that is to mark every page “NotRmappable” page_type
in post_alloc_hook() and clear this page_type at page_rmappable_folio().
Any user wants to set their own page_type can overwrite “NotRmappable”.
And folio_test_rmappable() is just !folio_has_type(). One exception
is hugetlb, since it has page_type and is rmappable. Fortunately or
unfortunately, rmap.c has special handling code for hugetlb, so there
should be no problem.

I did some test using io_uring (via nvim), which uses compound page instead of
folio and does vm_insert*(). At least no crash was present.

>
> GUP and other page table walkers are more problematic and need more
> thought (and work :( ).
>
> Essentially, vm_normal_folio() would have to fail on these pages. But
> what to do about vm_normal_page() users? The page_folio() would have to
> fail. But then we must keep some page table walkers working.
>
> And we have to figure out what to do with GUP.

Since _pincount will not be present after my change, GUP cannot be applied
on these pages.

OK, my memory comes back. I think my original proposal of separating
compound page from folio might not be right, since that defeats the
purpose of folio, which is a group of pages managed as a whole.

Basically a compound page should still be regarded as a folio, but rmappable
related fields (e.g., _large_mapcount, _nr_pages_mapped, _mm_ids)
should not be initialized and user is free to use them differently.
In this way, _pincount can be a common folio field to initialize and use.

>
> So compound pages are just the tip of the iceberg :)
>
>
> We could maybe forbid mapping them through vm_insert_pages() in the
> first place, requiring all callers to do order-0 page allocations. Hm.
>
> Then at least they would not end up in user page tables.

Will it kill performance? If only order-0 pages are allowed.

>
> But there is other code where compound pages are interpreted as folios
> and the other way around that must be sorted out.

I think we might want to have some sub-class of folios, like rmappable folios,
not rmappable folios, and others, otherwise, we are going back
to mixing page and folio.


Best Regards,
Yan, Zi

