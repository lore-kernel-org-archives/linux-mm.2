Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09915C79FA7
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 17:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1673B6B01AB; Mon,  5 Jan 2026 12:15:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 128936B01B1; Mon,  5 Jan 2026 12:15:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02ADF6B01F0; Mon,  5 Jan 2026 12:15:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E340B6B01AB
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:15:55 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D1DEC1097
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 17:15:55 +0000 (UTC)
X-FDA: 84298562670.27.28A64A9
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012037.outbound.protection.outlook.com [40.107.200.37])
	by imf29.hostedemail.com (Postfix) with ESMTP id B7FD7120013
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 17:15:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eYapqCVR;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767633352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o31WsQvJ6BnVdsTSTWjQGsecOPq3rzEqdeThw2xP/vI=;
	b=VeJ79yqkJrusL1dvTWpjTSd0JKXhzPll00cDw+UOvJySRIuU+m0YsHTjfDOQV9i2rJxene
	ymFkY3AipwoO9ciFvnmFYrVSmtRqBu2EHZyhOLJoIMD3CcGizfNtYaQd8NzZmu+HUoyXzH
	jXL74InQ8UfRNdpecuICG5+9/i/AEBY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eYapqCVR;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767633352; a=rsa-sha256;
	cv=pass;
	b=zs30Bo8HbYbSWZ40CMQ9n7LUixPP9h1wtebgHElSl7urAGdDOrMLeYYzCd3S/Ko+7znihL
	PSaVbcz8D9GiBMfI9j3bR28j4UihZy3/ETWD+J+YgNrF0RgFTRklR5ks3PMyFpNhsS13iq
	4/Fvb1OjVHjeU4ntcISscNgTNZON/JY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pvxwNLVtJ/hmw0r5o2PUuHp75+CDl320pI+HZDvJ9vMgHqnlEF8gKtkLZpY5lOSKuGiJHnsPmk29JUTzync9ggXPYIRpXKAGTD97JQS7V4oDj2ihTurkVKkJQE+oHzCS5l/mYDSxWQMsDXC6REnEqZ1KcjH732RnlGNmDJfroxJ2GrsZV7BE9sRkDiZ8cfBLyEVpv89XDbGBBSL1TnJ6UJmGxsbcv46JrLAxyO4pEh9NR+C4X/NOogqiKtVeF0tRQiMK4P7XRWEcmjklIb4Ma0gKsT2U4rTk6AtuhnY0A2dtRA6etSsQ5t/tn0O4Qy0qRNCEVaOTn1ZhJ/H7IG/4rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o31WsQvJ6BnVdsTSTWjQGsecOPq3rzEqdeThw2xP/vI=;
 b=GAS4zi84yrTv/YRWEjMioajnRjk1xKX/U29/ch/5DDW+v2XWUV0dmCAKEI4cIL1VVllL/1CgRL1YYRycxuS0pdGppW0sGbubD74McE6PajvT0cjw/Oqoy5WvTUi8+p9IHQkNlrYkXsWnefVCC43v/E9uBaSgjocRXm01iWWqI5zWqmRVni6UtOM+AmNC9R1fkP5w2UkP2/tiQaL7/eLcYU3lbOS452Du7iW/ogKylK0O1TtbFTEbENWMsSo3PEYRrsXF8KaE9LBTXx5w/zxrrxBmeOVZcaGSwRdfkTkgRTQwcFOGCrkLEDq4mN1Lo42jPcpwjUclPF1r462P5B4+xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o31WsQvJ6BnVdsTSTWjQGsecOPq3rzEqdeThw2xP/vI=;
 b=eYapqCVR18XWY+Ns16oKgGdjZ3/sxiNnUiiftEI2JJw7N6ooiyhiWLOk9lpIFZEAduTbDnaOr7GBCa9MWXiv3mpr0JzMc9iqt1gaMLcVYRF7BiU7IBusx4FKGPqhK0BJLWChzjaNIbg5pJOTnGWCQmEuv8Mdin4uzu4y2SkXeeGMBcIrBkFtU7LvU9aWZtqGo6V7Z7muT9qZq+YqiHD5fthNMgafoY5XzTBok8/g01PQxLqAueqrEGP2MMNrUVvaA+VWlUsZGUliiIYkc8PcsBtDDILzfjS73V69PnRlJ2KkBThE9dSF53C9B6pDRBqDa/7sxLtWXjwv9RBzrVzYYA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8181.namprd12.prod.outlook.com (2603:10b6:a03:4f6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 17:15:48 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 17:15:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v1 1/2] mm/page_alloc: Optimize free_contig_range()
Date: Mon, 05 Jan 2026 12:15:44 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <A10AC2A5-416C-4820-AF9B-D3B6946E3346@nvidia.com>
In-Reply-To: <20260105161741.3952456-2-ryan.roberts@arm.com>
References: <20260105161741.3952456-1-ryan.roberts@arm.com>
 <20260105161741.3952456-2-ryan.roberts@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR01CA0014.prod.exchangelabs.com (2603:10b6:208:10c::27)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8181:EE_
X-MS-Office365-Filtering-Correlation-Id: 68e2e418-492c-4365-4b37-08de4c7e11be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2FrZnV2OWxqaGRNeWRFRllvVHJidlNkRDRtQStxVktwdzFCRlhlNjFmZjZG?=
 =?utf-8?B?QWUyWTRlTSt6ekRYSVJkQnFoZGxDWkZmOGFjT2VoVHdQNlBKREZXOXZvOUds?=
 =?utf-8?B?dDJyeFJTbEVsdWtadVpOV05MK1R6UzV3c1hlc3h6bTVoUXB3MHdOaXZSYktz?=
 =?utf-8?B?MmQ3cHRlVUdtcUVGSHA3WEpZL1RJYnNiNEJQRXFkcHdYWVpqaElSSEVOZEUy?=
 =?utf-8?B?c3VBdHN3V3Z5UTRZWGg5VklLSW5ES2NoTUFxVWs3MHV0VVFrZk5Ba1daL3pH?=
 =?utf-8?B?K1Q2MEdieVZpMWZ6Q21CeE42UFdKK3BNWC9FZ2JXYmdCNWVDQ3ZCdkgvOWM0?=
 =?utf-8?B?ODQ5bzVFNkx1alppM3NpYTdIOHY4VnJRZCt1cVpFMlZDU0QwVm03amd3QVFw?=
 =?utf-8?B?bXg2VDA1TEZrdEdxN3pxekNwTUhlWHRkT1IydGg0VWJLdzJlLytGV2l0VE9X?=
 =?utf-8?B?cFBHTzZlTjZsRWc5czFVY2Z5Z1U1QVlENlcxVEVtdlFMVzU3eERtZVduZjNI?=
 =?utf-8?B?bXJURGw3cXIydnU1a29iemJqVVowNXhYa2pXcCt4cnFLTHdHRDQxTityNmxT?=
 =?utf-8?B?SmpxRmVZbE00TC94N1pGSHNDcWF4YkdKNURhK0NmL3dWdk9KSTE3ektQV2l5?=
 =?utf-8?B?c2hqSHMvV1UyMmFneU5TR1F0dkRySy9uMnNpTTJiU0QxU0FGajVqazBsSmRi?=
 =?utf-8?B?eGlaNWJCLzF0eWMrdjZVR1lBTUR1TzJ1a1VoR2Z5VUpRR0d0a083VlZIYTJY?=
 =?utf-8?B?T1V4OW5LUmNRNEdFNDZ3Vk1pcjF4em5vekE5NHRLS3ZJR2lXTDF0YjU4aXkz?=
 =?utf-8?B?Zk45Nk5xd1RiQ2FwaEM1SXZBYXR3cGxWSnpFNWhEaktYbkY5bmdTNUphWWpT?=
 =?utf-8?B?T2tOY1hTdHM5eDVISGQ1OHlOWmxaNmIwNjBoYW94MnI0dndMNE1INUgxR3lD?=
 =?utf-8?B?SWFKSU9jK1hKVWFkZVp0UU5mT3NnVGt0RCtodjk4TWFHU3piVVJ0YXJMV2lk?=
 =?utf-8?B?cHd0QU43UHhNYWhoL2pZZjl1aHgzRUhRUFVoU2NONjVqdEVGZWFCVG5rdnpm?=
 =?utf-8?B?SEpMbmRTOFZRNFhQaFY0K1F0TG40bkpVVFE0KysyYWtCZW9jd29vMlpOSGZy?=
 =?utf-8?B?Sy9mWi9KTmwzRDVUamU2UmlFaW5DemJ3OXFPQkVaaGtYcm1yT3F6UkdhV09S?=
 =?utf-8?B?dytEdHlhNUlyd2lnUjBLV0tEN0V4SUkxbnRjQjg5K0hpaGdSNC9mUnJ4eTJv?=
 =?utf-8?B?OXdydmQvUytDemZ3MFlxUUhGSUszU3g4ZDZEdDZjemt4THAwbVFBdHpQQURD?=
 =?utf-8?B?U2pneGlxbitSTUsrbkQ1ZlJ6VHR1TDlPby9DWngyQ1Eza1RpaEZsTHBEeVQx?=
 =?utf-8?B?WVRsRVJ2dXhTMlNyNmwyNzlNb1VWL0M0ZlpxTCsrelp6RkhOWDI0Q2s3UzRs?=
 =?utf-8?B?czU3NWd0bTZ2TldlVUsvcUVlK3FSOGtNOWNJNTJocmduVVJNb01jUjZGK0RO?=
 =?utf-8?B?QzJqditwSHJsbGFFZWdvZEdZajlQZHc0OVE1bHd5dUZDSnVJQ3J3SnMvRlZ2?=
 =?utf-8?B?V2ZtVjRZUllwVkU0VGkrWlRiVWZNVXpRM1B3eTZZZEY2TkQvRFByL3p0clVu?=
 =?utf-8?B?T1pXcTNubnE0V3YzUFQ0OHhueFVscWdFOEJOc0xhYkFDbGlLK3NGcmsrNkZW?=
 =?utf-8?B?bFVPcDhRYlg1VHVZRXJCTmRsaS9IZVlBOHBDMEVPV3FBbVc3NkxPaXZwWm5F?=
 =?utf-8?B?aVY3Z2krd2k0QmhhOXpROFVYQUJ4QXdSWUJFbWhYQWg3QlhnNUhuZzFRRnBW?=
 =?utf-8?B?QXJwQXVSUmozR0EvaURydHNyZDl1WjhSVkRaVklMR01vVUFqcDl0c01vOUtq?=
 =?utf-8?B?bmU5UzRpaVBYcTRWVUtaZmJRYm1SK1RrTmhVeE1DR2w3by9KSDFKczZwWHlU?=
 =?utf-8?B?aGdoZk52MEkyUFRSRC9aK0tFaU1OUjRSRFo4dHNOMkRtUjJhTDBQampPeTEz?=
 =?utf-8?B?K2UzMzlobllnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UEEzMkZnd21tUlFDUmg1SUFwaEJUazNSdTRwYjhGOU42NVFRdExCVnI5S2l4?=
 =?utf-8?B?ck9EQXdHYU8xUXB2YlVEb2NtNHgxZVo0TnVaVHFPbzZ5UXVTcDhqWEdKL2I0?=
 =?utf-8?B?a0ZodjViUkEwa21seWxRYUdmMlVFZ0R2TzFWUjBLQndyS09TOFZ0bmxrenht?=
 =?utf-8?B?d1NvY3FJNW4waWpjaUlKVEFsZElzTTdnU0FvQVZDUEZoUHBpTVhhTGUrSGlJ?=
 =?utf-8?B?UTMyMWJ0dXZnaFFFZXo2eFgyM0ZCeEc2dkxueEtmc0Rma0UzSTg4RlNIMDZD?=
 =?utf-8?B?cmF1cENhU3NFdzEwNldMWUlPS0JqOXA2UE5LSGZRQk9uM0k5ckZucEJNWXJm?=
 =?utf-8?B?OG52VmhuMFNTcU1hNFhYb25ON3RQN1ZiK2RZLyszYXFuUjJ3M2l5OWYzK21l?=
 =?utf-8?B?NWcyVjVaYWNNMmdleThMUDhNbnY3OGNlZXQ4dHJCNnBlRTJWYkYvK3hGcVlm?=
 =?utf-8?B?cEkrRjNncS8wU1RTY1VXVU9yNmJ3Uy83S3RTWjJkbHBLU2FZY09MK3p3c2Yz?=
 =?utf-8?B?RjVldVlFZmIrRzdMckl1N2JpejluR1ZBSWZzbzM2eGNTNCtYQm1ubllBckt2?=
 =?utf-8?B?ZTI1WGhOZUVpRmtRMUUza2RQOTBPZUozaEl6aHNRbUFVdC91SVlzd3BHOVlO?=
 =?utf-8?B?ZGY1d1BjTUg2ZjJIWk5NUlBGeVpvUWdaK3owSWpPQzFPVmMwVnpLeVMrcVZl?=
 =?utf-8?B?Wk1VcWJieFd0QXFQNERZbTF2S2d2Y3VpYlB4VHlQMWxYSVdjb3QwaGtGWEtZ?=
 =?utf-8?B?OCswWThFSHZMQ1VJQ1JyaXBKUlRRL1FKcEpKYUY2WERhcnU0TUtjNU1sUFNU?=
 =?utf-8?B?eWhqcm9HQW90S0xONEFXY3BaRmpiS3FYT0h0YXc5N2hYSHY3WXd0WjZqTHdH?=
 =?utf-8?B?VnhIM0RVVmNnL3pLMy9oTWpyanhseVdNM2psaWoySXVtbENjcU5mY0VYVHhZ?=
 =?utf-8?B?Y3F2dHU0b3ZTRmEzS1V3SjM1ZzhJR3hmL092NndqUXhheTg4OW8rUWcxeVlM?=
 =?utf-8?B?aCtoVjBYLyszVGZzeU5nY0ovUDk5cFAzZXkwWVY3MWh1UVlZaFBCNEw3cG5y?=
 =?utf-8?B?cWp5MHpySVZ1K3dQV2pXbFlJQVV5WEN6UERBUUtUdjhaVTZpZTFzOWZmbXdt?=
 =?utf-8?B?UkxQdGlHbWxKeFNiaUt6UjlyMjE4WktCbG96QXlaMGIxOSt2RUpBZmZJR1hM?=
 =?utf-8?B?dEtSYlVDaFVoVVpTL0txQXlmekFOcTRoSDB5SnpzV1hqRS8rUjBXVG5VbTdB?=
 =?utf-8?B?VGtjVVp4SkNySjlGWHZ2TWl6TEkzSk1PZlVxcHJiNW45Z2wwVDF2Qm1oa3d5?=
 =?utf-8?B?VlRXcG8ybkE1bGhoRjkrR3dHWWpvU1FxdFBQTXNka3NsUzY2dWFrcGw1Y3Zy?=
 =?utf-8?B?VGlIRlBPaXBLalZ3QVpaN0RieS9BWU5UNXZDV2FhYmpMQWRCVUlsVFRKNS9X?=
 =?utf-8?B?SmE5WTVJRXdseUV0WTY4NU1PSWMxUVluRFFxTmpZR3pEUGhOVFFGQkJJZkJi?=
 =?utf-8?B?djBsZUl2a01OSmh6N21XL0gxa0hMRTc0Ry9wR1lRSTVTYW14V0RyUkZOQVVL?=
 =?utf-8?B?VGh3RVQ3SWxtZEF1UGQ5SDVJYUsrVVo3V1F3ZStxdHJpUmtnNFhZY3VxWi8w?=
 =?utf-8?B?R2VrTVZMTzAzNG5qRHhhNFNoWTVldG5aOU1BUGNGbFN4WnpkOTVuTG9MU2Y3?=
 =?utf-8?B?ZmFnSUV4WkVIcXFCMjVENDdlTmVpZ3IvdUl2ZmNHU0hqRFhTTXJPYUxqWGZu?=
 =?utf-8?B?UU5BSUhMUWI0d3dEUmxvb2hFTzVxWVhOdWc1Yjc1VlZSblpZY3lqSW0rSUpj?=
 =?utf-8?B?M1U0R3BBVHpwQzRTRmYrSE1jb1NWNFV5NlBMMytNVGl1WDlCOWE1OWtQRDZJ?=
 =?utf-8?B?TmRJVndDaUV5Z251cndDWVpDbVhBWVc0TXh2NmdTSGVkNHlITkx6VDE1QUV5?=
 =?utf-8?B?bXV3TGtFUTdHVllZUXdvcjBSdC85RWNDUTI5Z3FETVRwajd5UW85ZkxKSHJD?=
 =?utf-8?B?eTk5M0k3RGNqYTRVSDNVdDlPNjh5L3FRdlc1MXVVWEs5elNBZ0dFbjZqeGh6?=
 =?utf-8?B?bm9QMStrVjRhSVN6RHlUU25majhDWFpWdGJGV08zNEMvMWJ5R0xmenhhMk9y?=
 =?utf-8?B?bjRRNWJWWmNuZWF2cEtlSEplejZveUdzUUpTNkZrUSsyZUdsQWtaZ0IrSnp6?=
 =?utf-8?B?aTRUUFlrVDRLM1IvZU03RnVYZTRWdXFzUy9sMEVNSEU1SzNuSXhGTk9YaDEz?=
 =?utf-8?B?SklWQUJlc1h2aEVEVWhmVFJEK0d5dzFWZXVjYTU2T01MaUplTGpDck9wa3pk?=
 =?utf-8?Q?+4YxmTWWmvlMpdm3u1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68e2e418-492c-4365-4b37-08de4c7e11be
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 17:15:48.2517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zRSJlSLTMz8yJ0LicjVDzRDDCOX0g3uxggvxU2QnPIE//lpcM+0p+P+MzehjkGMs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8181
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B7FD7120013
X-Stat-Signature: yo3kn5r7dw9sswh5pg817or87ja17yck
X-HE-Tag: 1767633352-662689
X-HE-Meta: U2FsdGVkX1+wi053xsQDDP1WVm1ts44KzcK+BqaO0h/+CLPM0l+2c7CK4RvYjtSatDYce8PPcyirh1JM0/QjJr/1LR7Cz4Ub7rkCP4gg25PNbnkcIHEfrVjxIjwrPHTh/2Yk605PI6PkfCDYtf+HT0+Dz/Jz0LUWA7UXDRKY9Ht2a41bdSg13dVzYGzlDklywu/H/O5cF3qfrpHKMzMlNHHkWK1J1f9PaA5PgE4pKdODwUn0JCEmnsGwymqNyblPFq2V1GJLii73+85FgjpiXNdG0YOvAq8mYfUssyNmoYMlTPHEZqtOtbivQnEpipcu57nCtjF9g2FrKE1o/HVB5A4SvHORTHEQDizg9bm66/fHBDJMSN/B+fo7uw7Abn1fBt4ABl8bkL1ieD4ImUFPpdAv2K6Y4bavmb1RzFSNMTcrKvtabc9TsbL2qeTrnFw7cYkHispgYSwN9nz6ig+h57iW3bSgagpG61W4GT9ZRjlxS60BjshhOT2LZI0iWE6hfkUdpeCBKt2dD4s6KBWQdUSiDF3bm7OGI+a4I2mKtz6n4d3fpWSr/H7OZRoHHq74L53Q+0ZJzs9v07/UcG6LRdIpDzV8JXsx3Tpvt7IIRuIfItOifl0Kdg+s5IvJM8n+3DrhCWwZkJobR63YeIYiCrIj73uhNaqXL41201FXpCv+XpLqnohGpAgW6sHVQNHOMbVGZkLQhJ8qnHGbvxjCLsYAdTyimc8YlFPITJcZvLDhfvAoBHPpoJE9kKBNE54NGGa2lL3D9FJzCnMjl8GJLpgvkLBuaPKAo8kiKx+4q5CI94Vut567ahwmcg/U1uASSvKVuPBmfoluMI/Vb9uHXqzIgccZgboSUIU1WVk8i08BDSU1v9Qs4FfJJZeCFPn8i4diUQCGaKN5rVRUBWCD1Lzg7vCU8s6oKXxq1MqKDvf34qzygKsOqPaAJnB7JXC744Y/+HR/1PGd/laKjzx
 vNW1u6iF
 QRKgn4Jf/eBq7tgQ0/1UP9WHbDCOGa2UUwgaNmpx4mx4Hr61XPSwzfBbTH+ivQv/PrUzP+bUyhEsVpXcgUfeOFPGI/JG3ppSacDFdIr7fOHeIZMSNhKwhJx/ZQCvw6ySz5pRsTvOPO2oinY9wve2M2QpTWuDKOfksPJxFjI30DYXeZ7JmoM3eit7vKHlpIIsLiN3qXC4egC1g8zwwxGY2ZN/vlB4MVLi5PDV86ckZICe9zrDmbctlyvp3mS43DeBTHwoj+Db5fT6qSMrjotx/KCilpzxYpwCayIE4NtE+RJAEzYA6liQ2dpXeu4iOc0WSHGmfxnM6y/XW/oy4v7EDCxLJVVpDrIAD/X8Mxl+66TzCRTAljjYX9c74RzwPrqjdrs6WTg+HW5+4rYAvfTD4fsO1w83tz8+op5JQxgyTsJy28j8NOSKhVcW5muU5BxCZZVK1RTaIp9VqvfUY6kgwfcb4Iq7s5xWjLDwx2Y4ry53Bvr5AdVifzP2Tmcb8Zmzh4AB7FRH2bugef/AEcuvMNifsdveiu1YAwnuvIecEjlZcxTaSrkSzberjHC+OUu4Pu6SmcTauN4t1ofYgr2ONOYCo8oOFt28s2tQ2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Jan 2026, at 11:17, Ryan Roberts wrote:

> Decompose the range of order-0 pages to be freed into the set of largest
> possible power-of-2 size and aligned chunks and free them to the pcp or
> buddy. This improves on the previous approach which freed each order-0
> page individually in a loop. Testing shows performance to be improved by
> more than 10x in some cases.
>
> Since each page is order-0, we must decrement each page's reference
> count individually and only consider the page for freeing as part of a
> high order chunk if the reference count goes to zero. Additionally
> free_pages_prepare() must be called for each individual order-0 page
> too, so that the struct page state and global accounting state can be
> appropriately managed. But once this is done, the resulting high order
> chunks can be freed as a unit to the pcp or buddy.
>
> This significiantly speeds up the free operation but also has the side
> benefit that high order blocks are added to the pcp instead of each page
> ending up on the pcp order-0 list; memory remains more readily available
> in high orders.
>
> vmalloc will shortly become a user of this new optimized
> free_contig_range() since it agressively allocates high order
> non-compound pages, but then calls split_page() to end up with
> contiguous order-0 pages. These can now be freed much more efficiently.
>
> The execution time of the following function was measured in a VM on an
> Apple M2 system:
>
> static int page_alloc_high_ordr_test(void)
> {
> 	unsigned int order =3D HPAGE_PMD_ORDER;
> 	struct page *page;
> 	int i;
>
> 	for (i =3D 0; i < 100000; i++) {
> 		page =3D alloc_pages(GFP_KERNEL, order);
> 		if (!page)
> 			return -1;
> 		split_page(page, order);
> 		free_contig_range(page_to_pfn(page), 1UL << order);
> 	}
>
> 	return 0;
> }
>
> Execution time before: 1684366 usec
> Execution time after:   136216 usec
>
> Perf trace before:
>
>     60.93%     0.00%  kthreadd     [kernel.kallsyms]      [k] ret_from_fo=
rk
>             |
>             ---ret_from_fork
>                kthread
>                0xffffbba283e63980
>                |
>                |--60.01%--0xffffbba283e636dc
>                |          |
>                |          |--58.57%--free_contig_range
>                |          |          |
>                |          |          |--57.19%--___free_pages
>                |          |          |          |
>                |          |          |          |--46.65%--__free_frozen_=
pages
>                |          |          |          |          |
>                |          |          |          |          |--28.08%--fre=
e_pcppages_bulk
>                |          |          |          |          |
>                |          |          |          |           --12.05%--fre=
e_frozen_page_commit.constprop.0
>                |          |          |          |
>                |          |          |          |--5.10%--__get_pfnblock_=
flags_mask.isra.0
>                |          |          |          |
>                |          |          |          |--1.13%--_raw_spin_unloc=
k
>                |          |          |          |
>                |          |          |          |--0.78%--free_frozen_pag=
e_commit.constprop.0
>                |          |          |          |
>                |          |          |           --0.75%--_raw_spin_trylo=
ck
>                |          |          |
>                |          |           --0.95%--__free_frozen_pages
>                |          |
>                |           --1.44%--___free_pages
>                |
>                 --0.78%--0xffffbba283e636c0
>                           split_page
>
> Perf trace after:
>
>     10.62%     0.00%  kthreadd     [kernel.kallsyms]  [k] ret_from_fork
>             |
>             ---ret_from_fork
>                kthread
>                0xffffbbd55ef74980
>                |
>                |--8.74%--0xffffbbd55ef746dc
>                |          free_contig_range
>                |          |
>                |           --8.72%--__free_contig_range
>                |
>                 --1.56%--0xffffbbd55ef746c0
>                           |
>                            --1.54%--split_page
>
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> ---
>  include/linux/gfp.h |   1 +
>  mm/page_alloc.c     | 116 +++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 106 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index b155929af5b1..3ed0bef34d0c 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -439,6 +439,7 @@ extern struct page *alloc_contig_pages_noprof(unsigne=
d long nr_pages, gfp_t gfp_
>  #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(=
__VA_ARGS__))
>
>  #endif
> +unsigned long __free_contig_range(unsigned long pfn, unsigned long nr_pa=
ges);
>  void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>
>  #ifdef CONFIG_CONTIG_ALLOC
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a045d728ae0f..1015c8edf8a4 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -91,6 +91,9 @@ typedef int __bitwise fpi_t;
>  /* Free the page without taking locks. Rely on trylock only. */
>  #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
>
> +/* free_pages_prepare() has already been called for page(s) being freed.=
 */
> +#define FPI_PREPARED		((__force fpi_t)BIT(3))
> +
>  /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fields=
 */
>  static DEFINE_MUTEX(pcp_batch_high_lock);
>  #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
> @@ -1582,8 +1585,12 @@ static void __free_pages_ok(struct page *page, uns=
igned int order,
>  	unsigned long pfn =3D page_to_pfn(page);
>  	struct zone *zone =3D page_zone(page);
>
> -	if (free_pages_prepare(page, order))
> -		free_one_page(zone, page, pfn, order, fpi_flags);
> +	if (!(fpi_flags & FPI_PREPARED)) {
> +		if (!free_pages_prepare(page, order))
> +			return;
> +	}
> +
> +	free_one_page(zone, page, pfn, order, fpi_flags);
>  }
>
>  void __meminit __free_pages_core(struct page *page, unsigned int order,
> @@ -2943,8 +2950,10 @@ static void __free_frozen_pages(struct page *page,=
 unsigned int order,
>  		return;
>  	}
>
> -	if (!free_pages_prepare(page, order))
> -		return;
> +	if (!(fpi_flags & FPI_PREPARED)) {
> +		if (!free_pages_prepare(page, order))
> +			return;
> +	}
>
>  	/*
>  	 * We only track unmovable, reclaimable and movable on pcp lists.
> @@ -7250,9 +7259,99 @@ struct page *alloc_contig_pages_noprof(unsigned lo=
ng nr_pages, gfp_t gfp_mask,
>  }
>  #endif /* CONFIG_CONTIG_ALLOC */
>
> +static void free_prepared_contig_range(struct page *page,
> +				       unsigned long nr_pages)
> +{
> +	while (nr_pages) {
> +		unsigned int fit_order, align_order, order;
> +		unsigned long pfn;
> +
> +		/*
> +		 * Find the largest aligned power-of-2 number of pages that
> +		 * starts at the current page, does not exceed nr_pages and is
> +		 * less than or equal to pageblock_order.
> +		 */
> +		pfn =3D page_to_pfn(page);
> +		fit_order =3D ilog2(nr_pages);
> +		align_order =3D pfn ? __ffs(pfn) : fit_order;
> +		order =3D min3(fit_order, align_order, pageblock_order);
> +
> +		/*
> +		 * Free the chunk as a single block. Our caller has already
> +		 * called free_pages_prepare() for each order-0 page.
> +		 */
> +		__free_frozen_pages(page, order, FPI_PREPARED);
> +
> +		page +=3D 1UL << order;
> +		nr_pages -=3D 1UL << order;
> +	}
> +}
> +
> +/**
> + * __free_contig_range - Free contiguous range of order-0 pages.
> + * @pfn: Page frame number of the first page in the range.
> + * @nr_pages: Number of pages to free.
> + *
> + * For each order-0 struct page in the physically contiguous range, put =
a
> + * reference. Free any page who's reference count falls to zero. The
> + * implementation is functionally equivalent to, but significantly faste=
r than
> + * calling __free_page() for each struct page in a loop.
> + *
> + * Memory allocated with alloc_pages(order>=3D1) then subsequently split=
 to
> + * order-0 with split_page() is an example of appropriate contiguous pag=
es that
> + * can be freed with this API.
> + *
> + * Returns the number of pages which were not freed, because their refer=
ence
> + * count did not fall to zero.
> + *
> + * Context: May be called in interrupt context or while holding a normal
> + * spinlock, but not in NMI context or while holding a raw spinlock.
> + */
> +unsigned long __free_contig_range(unsigned long pfn, unsigned long nr_pa=
ges)
> +{
> +	struct page *page =3D pfn_to_page(pfn);
> +	unsigned long not_freed =3D 0;
> +	struct page *start =3D NULL;
> +	unsigned long i;
> +	bool can_free;
> +
> +	/*
> +	 * Chunk the range into contiguous runs of pages for which the refcount
> +	 * went to zero and for which free_pages_prepare() succeeded. If
> +	 * free_pages_prepare() fails we consider the page to have been freed
> +	 * deliberately leak it.
> +	 *
> +	 * Code assumes contiguous PFNs have contiguous struct pages, but not
> +	 * vice versa.
> +	 */
> +	for (i =3D 0; i < nr_pages; i++, page++) {
> +		VM_BUG_ON_PAGE(PageHead(page), page);
> +		VM_BUG_ON_PAGE(PageTail(page), page);
> +
> +		can_free =3D put_page_testzero(page);
> +		if (!can_free)
> +			not_freed++;
> +		else if (!free_pages_prepare(page, 0))
> +			can_free =3D false;

I understand you use free_pages_prepare() here to catch early failures.
I wonder if we could let __free_frozen_pages() handle the failure of
non-compound >0 order pages instead of a new FPI flag.

Looking at free_pages_prepare(), three cases would cause failures:
1. PageHWPoison(page): the code excludes >0 order pages, so it needs
   to be fixed. BTW, Jiaqi Yan has a series trying to tackle it[1].

2. uncleared PageNetpp(page): probably need to check every individual
   page of this >0 order page and call bad_page() for any violator.

3. bad free page: probably need to do it for individual page as well.

I think it might be too much effort for you to get the above done.
Can you leave a TODO at FPI_PREPARED? I might try to do it
if Jiaqi=E2=80=99s series can be merged?

Otherwise, the rest of the patch looks good to me.

Thanks.


[1] https://lore.kernel.org/linux-mm/20251219183346.3627510-1-jiaqiyan@goog=
le.com/

> +
> +		if (!can_free && start) {
> +			free_prepared_contig_range(start, page - start);
> +			start =3D NULL;
> +		} else if (can_free && !start) {
> +			start =3D page;
> +		}
> +	}
> +
> +	if (start)
> +		free_prepared_contig_range(start, page - start);
> +
> +	return not_freed;
> +}
> +EXPORT_SYMBOL(__free_contig_range);
> +
>  void free_contig_range(unsigned long pfn, unsigned long nr_pages)
>  {
> -	unsigned long count =3D 0;
> +	unsigned long count;
>  	struct folio *folio =3D pfn_folio(pfn);
>
>  	if (folio_test_large(folio)) {
> @@ -7266,12 +7365,7 @@ void free_contig_range(unsigned long pfn, unsigned=
 long nr_pages)
>  		return;
>  	}
>
> -	for (; nr_pages--; pfn++) {
> -		struct page *page =3D pfn_to_page(pfn);
> -
> -		count +=3D page_count(page) !=3D 1;
> -		__free_page(page);
> -	}
> +	count =3D __free_contig_range(pfn, nr_pages);
>  	WARN(count !=3D 0, "%lu pages are still in use!\n", count);
>  }
>  EXPORT_SYMBOL(free_contig_range);
> --
> 2.43.0


Best Regards,
Yan, Zi

