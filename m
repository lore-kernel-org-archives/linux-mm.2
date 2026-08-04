Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F77DC55182
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 01:35:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C25E6B0088; Mon,  3 Aug 2026 21:35:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B906B008A; Mon,  3 Aug 2026 21:35:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2EB76B0092; Mon,  3 Aug 2026 21:35:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ADDE56B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 21:35:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1849CA078D
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 01:35:32 +0000 (UTC)
X-FDA: 85061869704.18.C6A52A0
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010027.outbound.protection.outlook.com [52.101.56.27])
	by imf28.hostedemail.com (Postfix) with ESMTP id 46F24C0002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 01:35:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=n4vUlFxF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785807329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8m73iESwJKZfKdLjwe5sqR4ByLkBuzZrNbjrTfTCJHU=;
	b=2czOZgmxLeg7AFiAE7Q61yB5GzuLDzzUp8XcqhS0mRxIW6SUFhxEb7ORnzKmwV1nGExkYN
	lgiZ8EEjEk0Rm5MY6VRQTHSV/YzJivUn5xdMg7ASKTD+ZMvzFPto8+7dQHEEWOpfun8PG3
	w/Rb52b9mopaFNQKY7gKPLo20rBNjTg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=n4vUlFxF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785807329;
	b=Hja3tVDomkYU3RZbfS5XR09swl5rIvdZMfe3BNJBfOMtPzlioaYvm2jxFE/1tPxrL7GpH7
	b8QerKNqjioFJ9mCz4Y4HzyztG2yGSRzbVBq5IGFtfnNezdGxNKv/PHoMws2h0J2d0YNzl
	TNipitb5+DRhkSFvMnrlg3lX/gCkHsY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H7+TdnIgYidlZ+YVE5bG6AhWTVQTcoIdwLH20/uJoh/rSzGK9ISJyCiFv3krE86WDjUZp2l+UnLqgimQ7FGljI3lRWH4mXkaV0nyC5etmWoYK7/EFHDoGradDfZrqleNaBUDWzeT/oS58tVdkie37I0V3ZC9yic6DX/yBgCTDEbcdzg9JXWazTWdIp7xbzp1YKepfopAfAQBx8Ef7HCANuUgo0hsOJHAp566hSpDTQ7CCBNvOVwrzzm1hQyP24413nYS2+4AxlFKm2GRsDPPOCZfSFinBpGp0ONgBdPYjy0RKyJv5Io9cfNrl8ZPefk2wLzhXDlEUNg+nVbgTWH5Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8m73iESwJKZfKdLjwe5sqR4ByLkBuzZrNbjrTfTCJHU=;
 b=G9Cay7+NcvH7rske+V8yLnxHMMOSqcYwjwpLD3RurK1rg4QWNmL0EVCFJ977N6p1TmyPfChwpDdCpk1UD9vaEYgZfFjCO5iGBxxPjRB92uxRLA48Vaf9lSsocqnwUoBccAqlXgGNF3oXrjDt2LhqyOSieXF9kgnVX2H/AdaBGLNP6C4hDI6T50a2agxrkhpthK6KILdHKkHiZvHgS3pWcAIuItt8ykLrWScqJXXQvoJP7q37OT7rTlctqhXyZJittRh+Q77zV98SKiyuMtDfxLADhF7gcQw3yereXCuFaoCyw7XRN21P7QiwtC2eW0fGqADlmg8qd5ZJ7o6ls70WBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8m73iESwJKZfKdLjwe5sqR4ByLkBuzZrNbjrTfTCJHU=;
 b=n4vUlFxFl8KB5AB5lVzYFCVePd5JCJ+VdddJBtsd7AwBAArYPHm+lqY+Qjb6tifW9Yr26ybY7DWgdZUojPPPVVx4+qiMXwx7CQ7JQcDG48Kqnt04z7jZ82d72JripMnvDKZ6aKgoRc3Nmi2czI3jzRzOd0ynVjmFI5b0s6HrJ+H8MZ6TFgNzMQd5YKKjmjUtC4X+Ibt9sVNPqYuyvIHE0sEA9r9QGwCSPpBXRZLTQbZ+9l9DxLQRD7gV6G+Ydq8QDkGJCuL6xOW4BvP0vV8V0ZOLspxGpgkFhxrfV1DG7ZGZ3/vBtpEgkPpzKj1QRHVsCVyyR7PkWjCjSjmbyQ21Yg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4045.namprd12.prod.outlook.com (2603:10b6:208:1d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Tue, 4 Aug
 2026 01:35:25 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.017; Tue, 4 Aug 2026
 01:35:19 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 03 Aug 2026 21:35:17 -0400
Message-Id: <DKFRUZVRDMIZ.Q5GDFVAD25Q5@nvidia.com>
Subject: Re: [PATCH] mm/page_ext: remove pgdat_page_ext_init()
Cc: "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Liam R. Howlett" <liam@infradead.org>,
 <linux-mm@kvack.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Michal Hocko"
 <mhocko@suse.com>, "Suren Baghdasaryan" <surenb@google.com>
To: "Sang-Heon Jeon" <ekffu200098@gmail.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260803134822.2568766-1-ekffu200098@gmail.com>
In-Reply-To: <20260803134822.2568766-1-ekffu200098@gmail.com>
X-ClientProxiedBy: DS7PR03CA0357.namprd03.prod.outlook.com
 (2603:10b6:8:55::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4045:EE_
X-MS-Office365-Filtering-Correlation-Id: 8204f8bb-c1a5-43c3-8a99-08def1c8a4e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|6133799003|10067099003|5023799004|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZLViZzx9nzNiPrYhs83/UyaUCDLuUhFsDUsLJow+LORItx4aof+adJJ3jtmXmyLH2Eh7XS0XcpOpKm3CiIufJGjtj+Dnm5TZzoZTvTUscSWaplrC62Uaw+qrTeaRWDr58Ar4mnrZcVEwC/PyhHxa8HXZQJsckXTkS/0rt+dGGlcNG78P4RzR6DkdfKdYAXfYwqBMc7ZMPha9BUKLEtZxf2xGu71ihARPKO6BDXG47UlWpIIgxkVE2U3LV3J9ENr/SKNK5eqA2eJ9QfW082aG0khOSyLr6miKYwKp4DCPS9kpQLpQ45RP7nFwgosdlqlLFEPegLf3otdh8crVjM/9xg8kSKK//EiteWncQnlygJV92AkLLotvf46uZIkwxAF3vZsoQ177bSBBlbNY1S2w7T1xDTVNU6WD/oxaUmUmt9uzTEQlqB4a/uQ1m4PKdrs6hoZOoB3jDWmE+SwhuvAWxaW+JzNgeoTKA1wEtWykpsvltd1ms3/Zcm4Se/LXVUum4r44+pIA7ZS/9XFy/dSjXm2E8tzP0sYNv7Dg52+Z12lLAqY9D1zMA+PbIe0KL446QITjW5b+pUYQ4KDzTTbx4X9RzyG62t9jHFLN4tv76R7rlybYa5c+1pXJ3WFBGuj/lw4u9xeCcH+P2fRnQ+L1J3rUVZQLPeSTg1jnalmpCqE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(6133799003)(10067099003)(5023799004)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a2hLMmV2Z3ZNaEprN1dZaG1iRGYwR09JbmZ2ekE1QmRTYksxQ1Z2Q2N6NXdP?=
 =?utf-8?B?bGhHckVBaGkyOXB4eFQ3dWEzYjJBekNuWFdyZmJYbnR1T3dZRDlucjJlU2hv?=
 =?utf-8?B?NkVqbVZjcUpVeEt2MllHMjNCU20vNnBMY3RjcGZNdUFCSEc3Vmtzam5hTEJ3?=
 =?utf-8?B?TEFQMEVha2VrU0crVVFJLzhENUk1Tzlhb0xHLzNaL0ZjLzVHTWorUml2alhY?=
 =?utf-8?B?eVVFUEpaRlE2am85WWFKZlZ5ZU02VWN3dXBPM280U3lCQWVzUG16ZzJyc2JI?=
 =?utf-8?B?Y212RHJZUUdUNFowd3RhRUtQbTdCcUVmUUlYYTRpaG5CT29TOW03eDYvK3Vl?=
 =?utf-8?B?dzVYUC9jZ0RseHVjY1UrbTdKUlF0YkhyTG9FRjBwWXdqT28rY1JGcjZyaE5G?=
 =?utf-8?B?VDQ1eTM4VTc0QlhEbVh4aTlJSHlZQ0FMRG9BZTBkdW95ZzQzcWhRQWV4dXNr?=
 =?utf-8?B?MDdYN3E4TTJGYnJzcmE4OTdsMnNwZnF2Z3hTdjRicVNrTFliSVpOVFkvVkNy?=
 =?utf-8?B?cndJL29KYUpVdEJXNFVlRWF4QU9BalZoRCtPaTM4cVExNm5oYVNSall6QUx3?=
 =?utf-8?B?MkUwYkZKUnFpV3BnVWM5WUxoTEk4b0ZxMTY2M2w0UC9RVnZMQ2pGZUgreDhM?=
 =?utf-8?B?bFZhQWpMUnBkRmxCS0xRN2VUSmc2ZXUyT3FRNE5FRUtacGxvYU5jZGtua3Bp?=
 =?utf-8?B?YnMvajdMckFQV0kyTFkycHJZajFqQ3JYd3IzNEtjUUV6dXI1NHVUek80dDJr?=
 =?utf-8?B?Sm02SXhZZHpneDQva2xzSDNlZENxTmhwZURUenU2S1M2ZGdTYThyL3BVbWNT?=
 =?utf-8?B?TlNiQmZpWUVoMktTclpuYjlnYUZKT3FSUTBINUxpcWgxMitTNUhCa0RrU3pQ?=
 =?utf-8?B?TVdQbmlWZVVsRWJ6TVljdWJadTI1STZpOUtIa2xCVjZ5ZUxSQ29wbndES0Ir?=
 =?utf-8?B?aGNML2tLTko1NUNRaHRoV1BSK1JDR2QxcEtQc2lhYnhRQ0JFZ0hXNk5NNVIy?=
 =?utf-8?B?Mml2aHFTZENxd05tS1FPZWk5VXptRGIwY1o4Q2tpd0NmZ0tqUkJMb1JXTllJ?=
 =?utf-8?B?Uk5na1RHeVg3UU9RTW9iM3lLQldPekloVmlGYnhOcWJFSFQxRE54UWw4a203?=
 =?utf-8?B?bEt4aDZBNTVZa0tIYUdGWis2ZXdiejc2aUdXMzNKM1IxalowMmJ0MUY0Z2k2?=
 =?utf-8?B?MmVKOG45QWVsSHR0YXpJK0pZdktreVlLbmpEZkY0Y2pvYWlJdWI5c1BoWVVR?=
 =?utf-8?B?VnQycTNreWMrUzNFUjBkbHNRajVIZk9URkxzVjA3RU9OSGFMSzdNR0x4bDhQ?=
 =?utf-8?B?aEZPN0RVajYyTFYxQ0ZsYUVyb0o1TlNjUUhoYmJWeWdqdWlIVDB3VUMvOHlq?=
 =?utf-8?B?YVVlYkRqdFczMERLZU8yaXBYV0Jpb2JuSkx6bmJtU2NKcmRKQ2FuNWYva0NX?=
 =?utf-8?B?c01oUk5RRExwb3Rmbnk2MGE4dTBIaURyWndPSk0vZFh0dU1PTm41UlU4QmlZ?=
 =?utf-8?B?djU4UWpsdllBSmtWcEJlRTBlMmxhMVNIb1p1eTQ1eVdBVUtuaFVLNEhoWG8v?=
 =?utf-8?B?ZHd1M05TNGtlQTI5T2djNlFpWjJkNEtXV2VXalRRdEZleTZKVGNzOFZPZUVB?=
 =?utf-8?B?Zmt5V3N1cG9FV3NMWUZ0Zm9hVXd5RlBxQjZRd0RMRzdLMzZuSG9EbTQwcmo1?=
 =?utf-8?B?Um5SY3dBbG5lenlhdnhWNjJBaGxlUmJ3dFptOG5LeHFUQXlsdnVPZTdXbjFm?=
 =?utf-8?B?SEFEQzZKU1lvWkZ1SjVuNWV3a0JINndRQ21UT1h1L3VCQSs3Z0cxZzBkQlQ4?=
 =?utf-8?B?UzFKVThWdCttM3lrRlBXV2t6YUluWjJoU1N5SG5ScUk5QW4xZ1AzeGRCZHRT?=
 =?utf-8?B?NVJ0dnJqZWZ0VHRQL3EyV0FVSk0vTkg5OHNvMnY5djdEWEZIVzVjbURkVmhj?=
 =?utf-8?B?MVBZdng5SS9pVkYzcCtSM3ovdTRxZGpRMXFScDJWa0gzaHVBK3IyL0oxZERv?=
 =?utf-8?B?ZlNUd3I4SllZS0c3TUs0VzNXclE0Qk1yZGJhcHpMUmp2eEVsdmFqOHAzOUlQ?=
 =?utf-8?B?Y2RlbkFkb1lsakM5a0w2bjB1V1AxQUtIRysydCthWHlLaEdxcFVvTEJkSnN4?=
 =?utf-8?B?QmRTUUtRREdJczRpRHZxYVJMalp5RGIxOFczaGloZGN5NEpXZEs0OCt3eGNk?=
 =?utf-8?B?RUVDYVllSzJwcWJnQUZ1VnJWTjY0aDFLeGVzQnlpRUMrTm9UZ3k2REJPSDg1?=
 =?utf-8?B?dWFBcXdCdG5TYUw0TWcrKy9iM2RIT2MyODZ4UlJkS2dRdWVMbm0wblQ2OGli?=
 =?utf-8?Q?eWeM+T75taHDWeOGLg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8204f8bb-c1a5-43c3-8a99-08def1c8a4e1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 01:35:19.7063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 83KT5eJAuQccfLG8yvCQrBxZG14tI3Nu4QSgnhNh9sTwkP5BOiBiYjBqqmS6Vxpf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4045
X-Stat-Signature: sjm6m7g5io9snjpjfwtztquhzieis5yx
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 46F24C0002
X-Rspam-User: 
X-HE-Tag: 1785807329-962184
X-HE-Meta: U2FsdGVkX181mDX1ZHhng4nc+42IlTUtYprAnMY0aeyjrrfcp0KqUpR5tqfdiukp9RXphR7kiJu1IGQD/wHS6eX50KE9dTojKiAtLpQF0ZY4pmHmBVdUa0B33nVzzrRgdC++mzdoGO8qBzRC4jWBSzzy3ZYejTGK03EvN/iXbXOGOA1hmq84ZHB3GmDWGhB6X0nrpnz0oIrgXJO4ZMq9p/69RWk1R/TZ+/iJfK67nZ/Ey6hHHAZMBxxtpLS8qEV1NQEvSj3lU2/VcVNX0OInfdSI0O3+Ftj2l5Ox0JIh2oySuvVdvV1CgzCIpU+2/JLiCbxQ2M9vtMJmxNpO4+4CnHpbW/5oR3u+lqGd02BGwl4ZlZqJWblR+71okJOZF/Hjk+Q6/FL7jfY7L2oWOIwz2mtef8uc9ZgHz79Fd2tU/Jyyo8ErMRpTT97PTDwyPH1x4xAbofcbl+Dy2qMyGdCa39KyFeBAal1mFk98tnKg8xB/291Y6MShtQupO7nIL+xi53/H7ZnqFxnoMgUFudPuG6OYtlCuLRjG/jr0yDCrVMVRDD4nj1ZeBIWTSDDRs0bel18TCJOEtA/O0wvIZ5QY9VDuAh2/XuXS/WTVl/NqeSUjwkcZzlTkGXrZyjKwkAQcD43IAROIJF7jQwDYCyxKfdu8IxtmzifCAL8mBVjlt3m7WG+3cFoEai3YC7LWFipSZPWpI7ozxgrvKN6qtYy5XYrDe7/QuQocLxIEXCsA6E1PS/wOkLnAx9V2btsAV/tf/8v5gh2ow3I/I9H2hXRPasUqXAE2fglWT0NN30OPdQMJNR90sArNSeKHhFCdOx5Krx1ohAslIpAQyiP7jz3ikTvelY3Ej2zVGiZhEtl1rs3/DWfaVISTJ2rhFmVmA5O92wddpnZ4r1SeV2MLoDtOBe2k8/1VzhUscfPbWv/XA0gkRhjxGq6AlSfBIjVnyZ8y8sYpKOdOQy/L6nhQGej
 la5dOrny
 RKC+G2t49fkzgWhR88V+pBNhKHKieAqLs/sy6XIPjwNTqTfhJJQVDmZMQ4t0a87q4baEm7dlfDAStjxp6mOujpXb6BZFZxatRbmuO9PfP+Rpq4kl5OqZx4grg3FJqUiHSdGlks4CVcnUmpTdLWgAL4spMY0PotI698U8qOsVEyZmi/gaLmRfB0oYPm87gXNrOlZqkZACRd1zqG/0Od6o9PcfQiHrVt/Th2TRBlvvqTgOF7RGWpCmFnccuwRx18IlnuZB72lwEHqfFOdR3Z981uvyRJvNLh13nCOn8Ddo8lDImVGtxlJVe1qHsFetGf8r5NhOrNp4eYjygh82D8vioZVW6Wfal6Xxq9n+FjakEDGIGIXN6afbeGeRvLKUenGm1xC5jXphYK1hm+CBLixO5pRly8BeHa0mKRzeN3XV03kA+jO2ScuSv2gsUQK1B/e6iXW/d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 3, 2026 at 9:48 AM EDT, Sang-Heon Jeon wrote:
> pgdat_page_ext_init() sets pgdat->node_page_ext to NULL only on
> FLATMEM. FLATMEM depends on !NUMA on every architecture, so the

Should we add "depends on !NUMA" to FLATMEM and FLATMEM_MANUAL to
prevent FLATMEM + NUMA being possible? Otherwise, FLATMEM + NUMA can
have issues with pgdat_page_ext_init() being removed. I understand that
no arch supports FLATMEM + NUMA.

> pgdat is always the zero-initialized contig_page_data and the store
> has no effect.
>
> So remove the call site, the unused function and its declaration.
>
> No functional change.
>
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
>  include/linux/page_ext.h | 5 -----
>  mm/mm_init.c             | 1 -
>  mm/page_ext.c            | 9 ---------
>  3 files changed, 15 deletions(-)
>
> diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
> index f23d4b218da0..79c53ec45dfa 100644
> --- a/include/linux/page_ext.h
> +++ b/include/linux/page_ext.h
> @@ -55,7 +55,6 @@ struct page_ext {
> =20
>  extern bool early_page_ext;
>  extern unsigned long page_ext_size;
> -extern void pgdat_page_ext_init(struct pglist_data *pgdat);
> =20
>  static inline bool early_page_ext_enabled(void)
>  {
> @@ -202,10 +201,6 @@ static inline bool early_page_ext_enabled(void)
>  	return false;
>  }
> =20
> -static inline void pgdat_page_ext_init(struct pglist_data *pgdat)
> -{
> -}
> -
>  static inline void page_ext_init(void)
>  {
>  }
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 711f821f7b3c..e9c4204b73ad 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1394,7 +1394,6 @@ static void __meminit pgdat_init_internals(struct p=
glist_data *pgdat)
>  	for (i =3D 0; i < NR_VMSCAN_THROTTLE; i++)
>  		init_waitqueue_head(&pgdat->reclaim_wait[i]);
> =20
> -	pgdat_page_ext_init(pgdat);
>  	lruvec_init(&pgdat->__lruvec);
>  }
> =20
> diff --git a/mm/page_ext.c b/mm/page_ext.c
> index e2e92bd27ebd..b679a8c1f7d7 100644
> --- a/mm/page_ext.c
> +++ b/mm/page_ext.c
> @@ -164,11 +164,6 @@ void __init page_ext_init_flatmem_late(void)
>  	invoke_init_callbacks();
>  }
> =20
> -void __meminit pgdat_page_ext_init(struct pglist_data *pgdat)
> -{
> -	pgdat->node_page_ext =3D NULL;
> -}
> -
>  static struct page_ext *lookup_page_ext(const struct page *page)
>  {
>  	unsigned long pfn =3D page_to_pfn(page);
> @@ -494,10 +489,6 @@ void __init page_ext_init(void)
>  	panic("Out of memory");
>  }
> =20
> -void __meminit pgdat_page_ext_init(struct pglist_data *pgdat)
> -{
> -}
> -
>  #endif
> =20
>  /**




--=20
Best Regards,
Yan, Zi


