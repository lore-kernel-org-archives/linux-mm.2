Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8A51CA9EBB
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 01:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79EFB6B008A; Fri,  9 Oct 2026 21:56:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74F406B008C; Fri,  9 Oct 2026 21:56:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 619D96B0095; Fri,  9 Oct 2026 21:56:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5376B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 21:56:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 11540A82C2
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 01:56:27 +0000 (UTC)
X-FDA: 85305052014.26.C830536
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012020.outbound.protection.outlook.com [40.107.209.20])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2F34F20005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 01:56:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LJakdg2j;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791597384;
	b=dvIzymUNeQkmT/y0YUXoz7nRCzYLcLd3sy5YMCz5l41UtDPmCEsW7A1gQJwRGbHd2e1I2P
	B19SkYJJHJrU2J6HJsOZ/3SPDcV97IKQT1gF6dSoEp3JTnqeGSStfyGP0dJ1XaOmjrUoOJ
	ISddRFwrs3xZ74eUlmWagGAZL6mSGfU=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LJakdg2j;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791597384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4DQOGyz3/OCNi5ybmM7HCQHEg6twPdlJuSQhnsN4LV8=;
	b=eJy7n5mDCpwZA+JNmnCerrSo56FDFEmJncH+ERfh1vVNIvGQgOTXP0C8Q0nxtlAABiu42T
	0uGrjQqzsp60aqibi+ea8GiM+Y8PRvV3IIDPnUPGqmvG/IvfsK7OKXXZBN5J8mDWcsUue3
	ZjEpda6jWrRy8Emwt252SBrJub3wXFE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U0vs4imQpz3W6i64wDjRUGIY0V3gw4/S3BhsnnZRAYtDR7wi6g2JhYXt8Ra/O7SrS+OCwhlUX77gI58BDiOkMy8S9C4rJ4BEN9sSF4d4lnMlgRFWHbbK3DLCFwfLB5xb0jX7bJz5C461WWEs72M4RibGbSS2yg7jjxURPOOWBEi0vD6zNeRUoVZZTmOoRq3eP8WJfxUXRvpftdQ2IOAZbd8/81J6dIvHBejFOnojteY9x4/vqeKesTPM8a6NgEcwKHcBmGdA3ZhNweH1uKTBfsib/J5Dq2w5ITEj5wov//aWlH/I9EyW0VRvBDFAtCsMHi9Ni/tH9qwyLGuNi3KI4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4DQOGyz3/OCNi5ybmM7HCQHEg6twPdlJuSQhnsN4LV8=;
 b=Ha+6c0qIVS0ctHl4w808M4CDLBCLQrkKwoodJCik5X4F3lc9+1z2wVX/YlgCqnbmzrbWpAoiIj8I7ATLGuqQPW5IbEbufVF7exkAs18DFeD+i/x6rKDoTTXRuPYX/da8MiXlJzKwH8NsJe7/zHjp3dOu+vF5yFVdbwcLrhnpeOiFY9mFuJ/rVq8yNwq2WdaIqfcgOX7r27eqPoGXWL0NDoFwbF4ywb4TDfNhG8UQ5ZrrmSZdwEmhyc0TJikaAFR2jItZQi3A79e1iFPowMnBwOUShYi3IG589hkNunOIkmavmJJSVJrsOrZw8esdsUTfoOpdUMAzC1kcbCW2D3vXsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DQOGyz3/OCNi5ybmM7HCQHEg6twPdlJuSQhnsN4LV8=;
 b=LJakdg2j7KNocw++LkVBkuW1KL9RLu+Fzm/4F5ZtWBbeA+AyzUETHzLSUl/0dak9KBPA1SpSEYHHMvBTnM8ToVwooTGH0E8DVK3wxrd7OO8aMhEyguFrOm/6kDWzFZnK5bfSn7Dr/u6SkpIhNprbvSdIabuzjurN24KNRVokBffIPp6sSa71ywG3grLpwANU50ZKnaYz3gVBiko+43WUlHvrq0XV631TtNd3vE6ZG7rUC6PO3akrmx02AwHxiJqAk4iC0FoLUxFA9A9jankKPypUmUcBS/dWZ0m1Q3zY+MrZ8bubuS6QKOlEFewZ7zSo3fjop1TvzTax5Kz0SERX3A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.16; Sat, 10 Oct
 2026 01:56:19 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Sat, 10 Oct 2026
 01:56:19 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 09 Oct 2026 21:56:17 -0400
Message-Id: <DM0S9L075B57.1FCNOI7LA1FJW@nvidia.com>
To: "Lance Yang" <lance.yang@linux.dev>, "David Hildenbrand (Arm)"
 <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm/huge_memory: avoid transient none PMDs during
 lazyfree reclaim
Cc: "Kyle Zeng" <kylebot@openai.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>,
 <stable@vger.kernel.org>
X-Mailer: aerc 0.22.0
References: <20261009165214.40212-2-kylebot@openai.com>
 <DM0II2QHWWS1.2RXEJXC8S0101@nvidia.com>
 <8db35dc0-eb06-42e4-90f9-534522e810e1@kernel.org>
 <55765FF3-18D7-424C-984D-81C316F323E1@nvidia.com>
 <d68cb3de-e471-4ce8-8c6d-c7260d79ec1e@kernel.org>
 <0ec81c65-fbf5-405f-948b-0fb1b2e083e8@linux.dev>
In-Reply-To: <0ec81c65-fbf5-405f-948b-0fb1b2e083e8@linux.dev>
X-ClientProxiedBy: BN9PR03CA0140.namprd03.prod.outlook.com
 (2603:10b6:408:fe::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: 907c7684-2d6d-49bc-a7f8-08df2671ad2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|10067099003|56012099006|261009223027099003|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	qo1Nu96tf5HEfEBf1OrsvY/F8vABrkPwEPMpSCIgQs9mtjNlNi7zyVo9LB7W6yfCztEZoZKNHUiJ0WkJUzIK/Ewjh5DTlx5mhJdVPQkiS2HzLB5/0Op/M243cT3UTRmnrkzSttQQUHOmEOkh5SkrPpeksdjrbGOO9r0QacCwQUVPEjOg8RB8oxiicSasmny2/BahOvcv/bJTz1RlCUHj/GoCaxq4JB4Upn+PNZX0JYhmpigsMVPtlSBDaL3oXqa1hak98fvywnOELgualxDV2krnvgkOrgM/dv1Q6XwU1qdl4RiQAZxtJYBas/CRkVMTQS8v832sdDxDSx45CbBJlkoKTy1tVRlftJlwSF0xdKIL8wHXD+jd/Bn7ud7vR8mBdV3dAY7o/VaF3SMm9EtfPUoXCtSBicvp8whJJlyU9CtdZcSIgGtIJUKJrejR3bU6qcLeW8XDPmtOMavSJb1hj8FBRYU0yU5qQ6Hz7LLjBI2ZuXvIsAFZJWepcWOQ7OYj60H7Qm7dWqql0tGW1uCjRkFzc1qMFkuYwFYKOSE8ju0a3/YI5CsT0NJEy5cvyLOb6XU6gpt0arXA7I71PtIgpatII8KZqk8XiRAjEpI5sB4FTbqITK5e9vnd43uIxX6DbFCgrV8ym+qpSgNbFN5iB+rGDSKzcnbqvA7LJ4C9uyw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(10067099003)(56012099006)(261009223027099003)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UUdjVzZaa3JGSkVYY1hROVBLZUw0c3pPczh3RVpLWTErSFFmTVUrZi9aT3hs?=
 =?utf-8?B?Nmgrcy9tSEcwemdsUkFXT3BXeklreFdlL2sveHpWMmNoUWN1VVpPa1B2dnYv?=
 =?utf-8?B?NWdNRUhLSHB6Y1dPWFVNbWx5cy9VZU5oWUhaYll3cGp6QWFEdVVGMEEwQkp1?=
 =?utf-8?B?UWtqT1BuSVR0eHliVXg4YldTSjNjOTVYT1p5K1ZNM091U1VQVFdTb0xhWWZy?=
 =?utf-8?B?WFBjRDBNUUN4NkkzemxKaHNnWTAyYXBEWGtWS0h2UVp4OXRDSHRYNU9wVFhN?=
 =?utf-8?B?UnY1aVF0bGt4YUJSVTNZMmQwZFoxOUpldlZtZkJXRlREdUdQMmx4YlppdHI0?=
 =?utf-8?B?Vm1udnJkejdhUTdQdFpjMUk2d0VLcDVFbTBidlVkQkxXanJ2djRiUklrd2RN?=
 =?utf-8?B?ajB3ak1zUlhlQ1RkS1FzRFc1YThnSHU0bmZvaUtBNFRwVWdndUlWTDV2YmJl?=
 =?utf-8?B?Z1V3T0JMbXJKZnBQSnliS1VpZVlTcitpUTlLdExCaHhQNXhWR3cvVmFqbGw3?=
 =?utf-8?B?WHVWcEdreDJyYnBmNjQyZ0Y1QnlQcmhVUjJHQ3BoZWppTUNUZldsT0tZcDhB?=
 =?utf-8?B?WEFMMU04WW52NXpHKzZLTFh5TVY5V3ErVkpwaEJyM01WL2VWQkg2Q3pWL1hk?=
 =?utf-8?B?YTF2ano2MlNXUmVGZ2VKT2ZQUTlRYU9kTW51WFg1VEJFZTRaSmNPQzF1cHdO?=
 =?utf-8?B?UXdablFoM0FJeDJ0cnkyL2pMZU9ucTArTXZNdWdXWEd5bHBHYktLNkpoQ3FK?=
 =?utf-8?B?OXFZOW0vZ3l3T2hFb0IwTkJBZGZxZzdHckw0L2FSc2xqY2hHTHI5S1VHZEV1?=
 =?utf-8?B?RzhpRzlDcVhmNHRhdGV3RWZucnNBcmQzVUNHNjZxQUJwQ0ROYWM1NkY2RlBl?=
 =?utf-8?B?RFZyVnFwU2FmcDNSTUVaL3ZlWU5ZMGkwbDVEcTF5YmI1c25OWGRTQ2JWTGZY?=
 =?utf-8?B?TnppMCtPSFM0VU1uSk93dHFhZm1mZkhENFNYRDNtcDM2UituY1BFMnFBOVZT?=
 =?utf-8?B?aTIyMFhXQTBPK3VYb1JLTUlYd2hWai9RMlphUVNFcEkxVittWmdHTHlHc2c3?=
 =?utf-8?B?Vk80M0NTQVhqYlJ3N0ZXWjFEc3ZRNUVoVis0NDRZUm9rRHNlWTZpZ2Y0dDNF?=
 =?utf-8?B?Y1grOTBhejMwdEdwcHFadk9jREUwT3QwSlhKK2xxTVY4MDFRUGJzZHd0djU0?=
 =?utf-8?B?Wi9CZGFlQXo5Y09ZY2QwWURDcVJhV2RheUVXSDVWQTZ2dHRoZkoza0VoNHJQ?=
 =?utf-8?B?NGVNL0M3dlN0QXFxVnNkR2VGMEk0UEtwR25nWWpYNmMzSTl4cXZSRFFDYitH?=
 =?utf-8?B?MFhQVTNzZTJ5SnFhVlpzWit0TEJHZyt4NWdPaXR2SUgrOFF6ejk3VWVGZEdm?=
 =?utf-8?B?VnM3MjZZRGlYWUJwSEcrdzRWMjlZM1YrQ2dMbXVFaTFCOFNVdEQvQVFmRW1t?=
 =?utf-8?B?YlR3T1draFlzWkEyaWFCYVhkQjZLZ3hienlnYUl0YXo3bXBSTHQwdTdldGZZ?=
 =?utf-8?B?bDZOMFJDd3pjYWhNaHBtM3RBVmVjUVNPR1hJN25SWmZNbjRXNUwxRkE5cE50?=
 =?utf-8?B?M0pEaHlnOVM3My8rM2F1YTRMbEpmbnU4NEtqMDVnQ2NqZXJpMUlwcG5DZlFQ?=
 =?utf-8?B?anNPQTFkY1RBRGtIeUNwTDRQbVpBU3p1ZkZhQ2JPeWVRTjg0cWxXV1hERzJv?=
 =?utf-8?B?RktKeVFnNmtsWlZBUDVRUW5WMStsWDNiQnZucTFqNFZhTTU2R1hZaldub21E?=
 =?utf-8?B?VHYveXU0dXB6aGN3RnFuR2xRSU90MlNHSVFnOUJsVy9GWXQ2L0wzbVFQRWN6?=
 =?utf-8?B?K05hWjlTSURjNXlIeVc4MmYzVE85MlJxYkVXSkxRZnJWVnZDUjB0Y2FnaVhQ?=
 =?utf-8?B?VlZlU1I0WjhQNGtuNnNBbmpvVitJcCtTRUc2UDI3ZlYwQ0pJN0NKYUFYT1lr?=
 =?utf-8?B?S2RCRUVNQ2VJejQ2ekhqeTIyL2h5dWw4TEw0SEc3bzNnN3VjRmU3bmY5SDV3?=
 =?utf-8?B?T1dpT1BxU2krNHUrdGFZVUxrSFRoV2ZJRitjaGJtbWhxZ3o5bEJTRGM3em5H?=
 =?utf-8?B?eHFYVWtDS0VEa1A5WHB0dTdOdEVPSGJkM0NiN3V3cUo4VC9nYUFzbktNWFlG?=
 =?utf-8?B?RUcwY3ZiNEtXWlFIdVlPQU9MQWZQdkVacmlYYkt4bDJ4ZDltT3JCc2RSZ3hW?=
 =?utf-8?B?dTdVT0J1NGRSdVZZek9JWnZiOVU0UDdJS2VrQnI3NFFXVTFQZVJTeXFiTnlZ?=
 =?utf-8?B?K243RWNVN0lab2RLU2Y3d25UNHdkUEFOUWtaS1ErUnhrbFNvaVRGdnNnd0NN?=
 =?utf-8?Q?y0VwJjeKek2Qc0YwMU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 907c7684-2d6d-49bc-a7f8-08df2671ad2c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2026 01:56:19.0273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gf1vDlh89rVEE3b5FDCdWHUnI6XU6m3usvnvhr9f5V9c00Gr27w2SxLQtiSirZoe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6776
X-Stat-Signature: tg4yzpe6z3piig5oc8f5ofnc1ucdgkfk
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2F34F20005
X-HE-Tag: 1791597384-707491
X-HE-Meta: U2FsdGVkX19UOZxMOK6mas1k8Q6Qn+Kbpg8ZUnmQyK5y4t91+7BUyQP1x9yQi8MuKASVTlK0Kl7yvnpFwUIOkAjVdw3QrV02hFF6WNNjO/ngiea0u+ldhsAKIbcu4NUcBO6ndxufIXbFViFAbqlaG5Bu5Xf1D/Uoljv7TM63TxKG9LJmjtJcr8QNNAdgRMcIVueUBhAx1VUZ9zfd8LZKyZSw5Mdk7q28moOk8nTSa2LxMtICExEfeANyPaTnAIGlvy5f0pvz3cgaU2ZTEohVnzyrXBZM/eWAO8XlrObw1y/5Ya3YZmyeI+JTsUtMpRzhF8UutdlwziGiPRH4J5DNAOm/BXqKVouOht1FKPxKCW3mZ35f431hkEcxtZccJETw1lHxLDpeZxBZy0Cgdff1AWR72kDRgK5+NVdkDFDxOzUA77P87ufKWhOq2GAnu9mEHmLFCbyGtBOl1QyNCiZYfAhhzQg//6dAxA9ViGBcAIFXjbP1aRAThO0pOPtBd9FwIMs3a6Tk/6DV5qAKJPhrkhnfotqr4gWxxAt6PU7/tXY5JzuRyROwUogyNy+TxLDZbmHrs+/aL0x2E0X+sMFVfeAjIPDlqcbdnrUWueiciVcd4FcZ9SaABw/TpQvQU3DTRHbuSHPN4wQhH6LsXSU92FPO5gy4p7SHI+OLi9PIapDd4Mb0r3xe+j9WfSeWrIMrtmQ94eYoudyh9hwgjrpdcUlkiqm5Bu4Ixta6198gxOYP/+2X0FYNahJ8PC2A6mW4fMWdrDmhr+4W5JcoTtD4TT+jwKU2MknFAPwP49gxtMjNprQ9iGKHBZihHfC6+zbBsSNvLpN3JISXS1P3Z4xvjdBBLcdg8UDmz5M64oB2OhV3R+BYRpZDuON5UVhF5XZJDMfroDwJD/Z6FNKwHUKxTR6o+MbDkqi3SzQVRtaLSFQO4bsKegjGJ0x0ZA4BmZ7EdqPeGJJSdv3Zi7/uVyf
 1D0bh9J4
 K5Td1kbQHtDDcAOY7rynTvMSMPR+3dRfjNX/iEaoCLI7h9JdrksC+5jArhIvk59aJ5J9dbKwlv3NanI7XXZAAddYHTs7nSNfUaU7Bh8CvVogrM8nvlSVyUkp4SVo5x2Qmd3a0MY26l08gQzMoHi6/PV2bEi/beVCkVb6vY7DUk04/hMfNTQ2/rcX5HROdoPwFE94hv2vHsv5rYKmDHa5XpyUixkc3zJMydNrsyqRsHXYkPv4lLdXLp1f6hrq4w6MCuRUy/nGM8DeywAWnpqE0ev8N5MXtg6d4bULSHDpPkMfPUxZ91akW+NJAFjqMBchB4nW/1thWrK5cG9IpKkQ6tZ8P1z5yNrmdKytXHKw8RSbFej/XGQyXwfMi1LEF8k8hJSpDlCmtsMEHsOEoGj3rcEdJ+p3iG5lmY9n4xDYYcN8xqZMdfg4Jfa2Fkaoj32+jkXlQCwkYYiYyoHlWHlVQQrNfhIPN1ow5eaavlHkmBVJHeBW2bQawOw3taw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Oct 9, 2026 at 9:12 PM EDT, Lance Yang wrote:
>
>
> On 2026/10/10 04:44, David Hildenbrand (Arm) wrote:
>> On 10/9/26 22:27, Zi Yan wrote:
>>> On 9 Oct 2026, at 16:23, David Hildenbrand (Arm) wrote:
>>>
>>>> On 10/9/26 20:17, Zi Yan wrote:
>>>>>
>>>>> There are some gaps we need to close before getting this fix in:
>>>>>
>>>>> 1. GUP-fast cannot follow the invalidated PMD: riscv and LoongArch ne=
ed
>>>>> pmd_access_permitted() that requires _PAGE_PRESENT; s390's
>>>>> pmdp_invalidate() needs a change.
>>>>
>>>> Ugh. We really need pmdp_invalidate() to have reasonable semantics. Th=
is whole
>>>> PMD locking is a mess :(
>>>>
>>>>>
>>>>> 2. sparc64's thp_pte_count can be imbalanced with this change (based =
on
>>>>> Lance's offlist feedback).
>>>>
>>>> Ack.
>>>>
>>>>>
>>>>> In addition, powerpc has a page table check issue similr to riscv, wh=
ere riscv
>>>>> fixed it with commit 9f4a88b8d01a6. This is not related to this issue
>>>>> but discovered along with the investigation.
>>>>
>>>> Zi, do you have the capacity to take over this patch?
>>>
>>> Yes, I can take over it. My plan is to send a series including
>>> patches for 1 and this patch as is. powerpc fix can be a separate one.
>>>
>>> Best Regards,
>>> Yan, Zi
>>=20
>> If we need a quick stable fix we could temporarily disable the whole thi=
ng until
>> it is fixed, just a thought.
>
> +1 we could do that for now. A quick fix with minimal churn (correctness=
=20
> comes first).

How about the patch below? unmap_huge_pmd_locked() and
__discard_anon_folio_pmd_locked() will be dead code to keep the patch
small. Later, with arch fixes, the function can be re-enabled.


From 2204b9d08530796847a586428b1f782b987d071c Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 9 Oct 2026 21:28:10 -0400
Subject: [PATCH] mm/rmap: don't discard lazyfree THPs at PMD level

__discard_anon_folio_pmd_locked() clears a lazyfree THP PMD before it knows
whether the folio can be discarded, and restores it if the folio was
redirtied or has extra references. A concurrent munmap() or
MREMAP_DONTUNMAP skips the temporary none PMD and unlinks the VMA from its
anon_vma, so the folio stays mapped after the anon_vma is freed and a later
rmap walk uses the freed anon_vma.

Using an invalidated PMD instead of a cleared one requires additional arch
code fixes. Instead, disable the PMD level discard of lazyfree THPs, as
before commit 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during
shrink_folio_list()").

Fixes: 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during shrink_fol=
io_list()")
Reported-by: Kyle Zeng <kylebot@openai.com>
Closes: https://lore.kernel.org/r/20261009165214.40212-2-kylebot@openai.com
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/rmap.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 805db93fe0428..1131b76bbbc28 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2275,17 +2275,6 @@ static bool try_to_unmap_one(struct folio *folio, st=
ruct vm_area_struct *vma,
 		}
=20
 		if (!pvmw.pte) {
-			if (folio_test_lazyfree(folio)) {
-				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
-					goto walk_done;
-				/*
-				 * unmap_huge_pmd_locked has either already marked
-				 * the folio as swap-backed or decided to retain it
-				 * due to GUP or speculative references.
-				 */
-				goto walk_abort;
-			}
-
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				/*
 				 * We temporarily have to drop the PTL and
--=20
2.53.0



--=20
Best Regards,
Yan, Zi


