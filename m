Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE57A606A32F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 06:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PnR1tcQx
Received: by kanga.kvack.org (Postfix)
	id C17286B05B0; Thu,  5 Nov 2026 01:08:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC7ED6B05B1; Thu,  5 Nov 2026 01:08:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8DDB6B05B2; Thu,  5 Nov 2026 01:08:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66BF16B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:08:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B9C42A86D8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:08:58 +0000 (UTC)
X-FDA: 85400037156.13.E83BFEE
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012028.outbound.protection.outlook.com [52.101.53.28])
	by imf23.hostedemail.com (Postfix) with ESMTP id EC705140002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:08:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PnR1tcQx;
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.28 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793858936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M3DrYTcpWup/5cuuiAlGMoyyyySpp9VpFcQP4dOMZyI=;
	b=iohTHAM6RsBXQFmtQnl1J7NYXCZJ1UVkPG3Ym5rj7asg6Lmnqkudb1N6MDQxWGd3IwhrFx
	tCBGkEgR0PV9vWdhO6GWRH6fEXRh/0LJiTPPBMWqiJYg2oCpDswePpsXZ0Ooin9t+GPYCt
	aE0t1X2LTmL2SSqa6OJZLutBiAUCqqU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793858936;
	b=0hD02lq1sXN7Q8fTZpSzPx/W1wfGEltiO5egaH1Gxh2yLf2cPzxJP7byvIAhvzX71Jh6oz
	1WXzI/LwMTJKFDfml4MHqmYDDvvIcIEipg8DdrEbWCViw9zYbwQCg/WL8GSCQm9ZC2p4jb
	bDFMTZBbyb8zKPvkrgX90ZlNN1oYcmA=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PnR1tcQx;
	spf=pass (imf23.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.28 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fRTsL7pm6uKe9+vhJ2LySJYSJQgLpES3PrwGqkcwsYjQf0G2L/pNj3LucgIx7A5RTWI8a9YXVvZZsTYnrJADRN8HK3yauQYOnFDZCuOge44i+ZR/7hguGTe/0sIt+CQ9jF4tUUl6/jNE9lFtr678pxS6wtYNnAsGsYGvjTCD2F9VxHKtcQQ2z0pthrncYXwXUCha+dvgy5SjkXeK3w5KYXQSWmd4SWukb0JC4m9BQShkkfusLtbgtwT8K6RWctA58si+jnsHeYzy4qq0XTNCJSiafEuegc17+PXvbFuS9vgBhihLolPcsTu9TrmPCl3GqsBMEoIFD2ENS+0u9IHu+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M3DrYTcpWup/5cuuiAlGMoyyyySpp9VpFcQP4dOMZyI=;
 b=J5Z7zUfpRQ/FV/ACQLm7zKc15O4J2/87xQMslZItBMudSkwey3BpV4tyOiPww5Vzvs6TrQPZDg4wPJRjXxek23yYtYZ+Sqayu9USxdnWHwruJCMc6rBMZ2tv++VF9fxXMJV+WHUWEduIJl7Gz+G1QGFHrZkP57vuLdDGlszIqisP0d4V6AVEFZ2OXs9M0k44J0ngsr4pgzbid3ZJ16lJIPG7omty3/3E1A95R6+fUeghHLSGZpgxk+DUrhZo5ROp3sIUBDGJ1tQpf+lDvkJszjn11vi+r83CBAQe34i6bJYQXFKTSja+/NhCFaRCrBgI8KJBnw2bP6h8vs7du6uHbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3DrYTcpWup/5cuuiAlGMoyyyySpp9VpFcQP4dOMZyI=;
 b=PnR1tcQxubFDqOvcrrkw2D5sPktkKqogpGMvWnjK+3R8puPCPIsi5WmB9HV6mSqa3p17NNxhojTwmYJpqw5vPqBsMSN02YAKN3u3FTW9zmLoTjatl8/NKj27grN2rg9O2UwVfePfkVyV6rNUdIQuGZBl5J1aIwOAILz6L07HzChj3NOi17CkmIky4ywoV/zm5iDDaOBkURqYK+Ih9qIe3vP72BkmxYY0uVHn2StGX3pinZRM2yJQzc1NC9E/bpDTZ61V4teJLPiyas3a6zjU55po7ysWWF4zgxh5v94MVTdZy/g6tcvxKp0SK2XuXdPVXxy58QUkuyidfhMXgvEHKg==
Received: from CH3PR12MB9730.namprd12.prod.outlook.com (2603:10b6:610:253::9)
 by BL1PR12MB5875.namprd12.prod.outlook.com (2603:10b6:208:397::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Thu, 5 Nov
 2026 06:08:51 +0000
Received: from CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128]) by CH3PR12MB9730.namprd12.prod.outlook.com
 ([fe80::843d:c1f0:b2ed:4128%4]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 06:08:50 +0000
Date: Thu, 5 Nov 2026 17:08:45 +1100
From: Balbir Singh <balbirs@nvidia.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kuniyuki Iwashima <kuniyu@google.com>, Harry Yoo <harry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v8 1/7] mm/memcontrol: flatten try_charge_memcg control
 flow
Message-ID: <auwdbYi9sLaNd1G6@parvat>
References: <20261104233029.3282438-1-joshua.hahnjy@gmail.com>
 <20261104233029.3282438-2-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104233029.3282438-2-joshua.hahnjy@gmail.com>
X-ClientProxiedBy: MEWPR01CA0292.ausprd01.prod.outlook.com
 (2603:10c6:220:1f0::7) To CH3PR12MB9730.namprd12.prod.outlook.com
 (2603:10b6:610:253::9)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9730:EE_|BL1PR12MB5875:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a4bee68-b31f-43ec-4840-08df3b034302
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|10070799003|366016|376014|7416014|1800799024|261028144727099003|261021121427099003|261021123027099003|261022105027099003|261026121527099003|261026140227099003|11063799006|4143699003|10067099003|56012099006|18002099003|22082099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	ir+zadc/kNAQTP0sTd36li/XYAtECMdU1HG1ejijY27usFcrVi1TQuVhGXUlCPepY75B+BUgG5eRfAt1p/ZbZpQGGhLXByf9ghxpt+NvhMmsaKrSMB47Q+gw7SCSCwPl7f7VP8lie67O2foZAxwCVjP3Ji/EZHjAQzJ5k3KXSVG/P7aCZhbxmwz3BkDYQRTMhg5aTbTX4UzOf8bgz/Md2vuulVm0uGfu5eTAdvtZtXqPmjhiOOZ4iDmHryMM2hNANN/tzh3jEFB/Y2sZXhi2TiEKv1gInZOqIN2Op1Oe1ztMso24R38OmNJ2qEfOt9TeFr/netV5RxMjPuwhomcntiKCd+fxq3xWtXueKYIPMAGZuMOcSGbUNCqPVbz2wPtEmhJYsGRsPNSeOCOm9YeQ/5fTi6pcDxSvG6dvr3VydNrkb1LuciZYXqvBd/MysPNZlBRCU6OzFI2F/FsQavYnzYSjjs7Ce7Q+1GJxpUtfmbXTujnx5Rdp/PESYVAEuj5ikHKQPqJCcVjlnLh+LBdJS7FAziFZrR1tYR0m4gmvmnwq3SpjLVYHbBvcN7RDhxU2EcJVw9lLhjJQRkVgFVYvvnbMhnV+bM8PH0928/s9AsNhDj3no95uMPhytV/zOL0ePjfY3/bNdCVkgGWEvVIUVRzQb5Tu0xl8ScOlieI/udY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9730.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(366016)(376014)(7416014)(1800799024)(261028144727099003)(261021121427099003)(261021123027099003)(261022105027099003)(261026121527099003)(261026140227099003)(11063799006)(4143699003)(10067099003)(56012099006)(18002099003)(22082099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+Der5HW/4IBWhAq6NDPXIuVIh2Qpu/cfe/ptZpJV8uIDH9tsKcs1FkSCa5dE?=
 =?us-ascii?Q?vdhvByMHp/ylHEtxxJNtPbOEh54OdfOfnN60xRtoHnOSlL4ArG5zaolz1dFa?=
 =?us-ascii?Q?xY8HAiBdMDvTcy9oJ6kjeN1Na2xZvtMM2yai/gxBUpIPLQv4kLm60PgK+Mzw?=
 =?us-ascii?Q?6dVkw+pG7gsZ9jGWvJxFyK+SPxermsbiFw8Dw0ZzHlHfw1NJT2v9k2bgXvmS?=
 =?us-ascii?Q?vLnQVXbagL8aT9qCbDCnNE7jA+gSrBs70JXPgvHMdFTgtITX59yHhJQnwUdQ?=
 =?us-ascii?Q?mxwVgA+bU+kOkUBX2YhxyJUfn5x+rAJWn9b4cB7T6FWNkaPZBjSA7UE6aEhk?=
 =?us-ascii?Q?rquKS4h2uZ7EUzbOQDVpSgl91AZtUGfWEahzB7y1R7j4GbSvMrP7PeoA5bGK?=
 =?us-ascii?Q?R8U6uPa5i0yDRc/Y0BZ/HPI+B7iR0nBqOoTI9ZiAR2vgewktvTFgcHQc2Rnq?=
 =?us-ascii?Q?iL/MzdRWbygyXAzakGyxXkHoprP7TuEQUIZVeF8uNo0ShuytyZbABBRuvyld?=
 =?us-ascii?Q?ifwLcxShAMvMquzwJ38XxO0L7I9Pe5gTdC9n18grMK+amvZ4w0NRJhb+0vVt?=
 =?us-ascii?Q?DXj/QE1B6rrlabRbTNNmbgNDo+oh821Zzj7E0c1cNpPmVYFrtorJZWXFHy+c?=
 =?us-ascii?Q?jZCRox2aDIk/0XZ2fQP9+TcxKi+Uv0bEHYUwqAxagRauS5+ngR37zTTEDKQm?=
 =?us-ascii?Q?ymQemAy/szfP1TGipd3nAcqZTeSDc+bq6AMNghtXukLfZE22uKhu1ikgT+av?=
 =?us-ascii?Q?K0nffWsbnxOJrdDr9s7tWbdQJGosEeEHizY+pV2XOlkpzkm07QIVBlFXrPQi?=
 =?us-ascii?Q?6G92nh7dZoJW/iywH2iVKJJnfI/LyhBJMnY4sN32Gy2feEGxnTs6J+Cx02MY?=
 =?us-ascii?Q?lIGx0hOG2kk4x3aB4Xk+Q7w/9L7rtt9//J8Lkb3fuhbBvkV/tnYDE/qnPSdl?=
 =?us-ascii?Q?pmbTyMC5yGryUV0iT9OnXCda6C9D6HTne8NoAxuDc4C7v4AIGpz5WNPOmaA2?=
 =?us-ascii?Q?wzhSwlNCkdV+AuiCjSlsqhLT8wZEs9gQL1zv0cnEAA1Ml9F0CXcIxeZDcFVw?=
 =?us-ascii?Q?ZmVxtz990HlkgSFrr9NAxqShxJOiynRsZNylrFtxGcbncCWkPZCxo5EGsFqD?=
 =?us-ascii?Q?cEhLKCWkhfvboEeSqDqTOfWY92IbdrvHQ0deyaHC3OIS/dkQiivFsOTfHrM/?=
 =?us-ascii?Q?tKJJ6dTob3SHLYBwYbiCicN4oPNJWZ31dEFN7W4weQ/iprOYAyixL6fbl/Kf?=
 =?us-ascii?Q?CnmL6OOZuqbyuYznNlvvMSR58faEinHlW40/X5pZbYqyu36gPwuQdFPFLO/y?=
 =?us-ascii?Q?0SgHSVnzOoStgr82aXQYd10aN1l5x+x9ZK5rkC33mEPOdWg09AO81zKdWN2N?=
 =?us-ascii?Q?pvoPOXcR5eyIjBLuUqpAhz+5anHxKY5a+Qgb8TZuaiqwEVDdEPpGxDgZYkP9?=
 =?us-ascii?Q?R0kQLys7rykQxUevoHAYxUXjoH3J/YPlL46NHpjy8UOoMkToeSl5DLdan7d9?=
 =?us-ascii?Q?o+mh15JQSnXzLMWPnj5Nnraw57y2wyLql7miy5VVwnvcNzRkUWP5dXUMaZu/?=
 =?us-ascii?Q?CyZoJzVPQjaCJ4IJpaVPcT6Y3B7jnalH1U5B5OtFsXGb+hxe+3Fy6B0vIaE2?=
 =?us-ascii?Q?zAe0iT+Qa38iXsAAZMRZCC36mgbfkF4MSmfVLFBHFizYCdsnhGK82e0O2O+H?=
 =?us-ascii?Q?4//vb22fBZFpbhxoc3n0JEs0Bd0z+c7pShdDFEEraEB9hNcJ68fIUCiCNXPK?=
 =?us-ascii?Q?aWdMP54e75Jx1raSJ0RO6y5VhAm8MkGLBI9EOd+m3r9rfmBYXtcnW5DhT+T/?=
X-MS-Exchange-AntiSpam-MessageData-1: 4yd5noAtRnNLFg==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a4bee68-b31f-43ec-4840-08df3b034302
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9730.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 06:08:50.6226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ab1IsVeIOdf2z7S6hDtQXxqX6ikh+IXLurjseHlIyz7N76BRL/67WYHHJQ/YLNPqprRG2fRC+qd6Kvd+gBgBdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5875
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EC705140002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ntgjui87sq6gw1sjtqh51xzktx8outyx
X-Rspam-User: 
X-HE-Tag: 1793858935-369639
X-HE-Meta: U2FsdGVkX19Gy+P3OfcFl0RoAQyYDdWs5i/8qI1WnlFVGiYpJ0dpnsHDYEcAgO7qNWTMx35a5vyOyh9b2/ui8TiinUdYrN42Kb90ZbMi/W+7o/WsxAo8wjlBRGMybsMl9bCJkp75gNTUs/1G0lhcvuzztCgt2+40hV6DkvhXPdMQjnEfBoIl9bOzA8XVc5sZMxLJxXZczmOWGN3ktLM2jWCaSeJbJ7qGFzLSoL4eL4TOzqevh+0VSSrrNnj7USaxKeUM3brKty5cyHAgXPkBS3EU0VReJM8ygZ6BvD53GP/ig9drhzAo01hoeVa2hIhgMMlmiHIGudC9BnVJ6jKY3BfNSpaPV9c7vQ5u/Q4iM0bpCwnx3k7vSTc7BL8SNHv+vd0bxuP/bdNWb4RC6xAnacCkxddDoRUCeHti6WDPw04OHiX9VhQU8PN2Btow1oTDvlbYAQoryOL4gA4jh4Z/wusdOdcNoQMabfnChZ3NGqqWAGzaX6MBPizMpB9fjSfYltBLtzCiuT6n2LVAuZnIdTPbMXixpu2w/Nl74al/8hBcdYylkqCarIiyicEXJkEkFYTog6vJZyJv55r/pHUGkrYa79UGww4h6TaME7lROpES5e9hmlrXHOsVxdu8KRSDDqgafMHQ/QhVTMLLOWj0YcBTNsT8yVgepcrZ9o+TaMhzKCziRO8NIzLcz2Aq6s3ZLj2lABr1Iy50s9DcM2PcsiWh0jVQJo1pwfmainOrKwENa9JIMNFhZ9pAUyUn5fIAXn3K/BeQbvIUViBNm4H+mKgrnUTSsfuvuMjsKjPkPfTIGlv7zfiTB9NuFkN4yKd7Zkw0CThVxSJp6Pw6GZ9igNiaK6xuzYWwrz1kuynwaVbGtZQAgDRkO3bN/xkb9Y4h/O/sSqVFMVICJSofRCB9K6Q02ZBXVzB8UVlZ61V9bujX8nIYwLR1N4WRhGTwb3pVSV7YAGTjKAVzs4PC78W
 TNcK8uK9
 x6xlwhytE6DFopCevttbvHj/ju9asqWkIDJ5ulXBiHecUv/EEvMnfkIq36qlc3m1/COYDmr6j/kzvS5P6o/lUSZ+ITiFDx9JreGE13FND/hqLyoYNZroi8wwfC0Tb4Mh8go6rtRU3fsuI48TMUsH4DG8G5YupOKIc8Etrujaj0kgRi9/3+R+XUwbkpr5sR2Ab8UPk89PTZV4MNynlAxICGCdcIVgORS9gBHp/sFxZq2JQHKukh/5vGo0PvV1t6+XdNEbVHn7cYByZbHjFzLIC4uFzjLXhx0Q5fqv709H3DhzV2zpq/YO1JNaW72OllXHpp3/EDPj/gYesYQuCzXLOyAiM4XbHzmF8HBq1E4Bw23z0RVa1VtAb1r7Czxge3JuL/IhnCaFrrMswOd/tGu5oakzUEfg4+vzDW6ESAnyawsi6/fZ9q0ZLSTiYc/HNL837L5yxSEN7P9TD0mLx0Q15oK8lkp40tot0UQ+2qBzxM0DTKywlQWVexquqb8iAmWDAu1e0uwudD4tqzb9wIogdtFHloCdw9/BSD5ItlVr/Fyyfyq1CTR/REuMfjxMQWeEPWnMdlnb60EJRDnvJOGFzioVlbesAa5aCVlqg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 03:30:22PM -0800, Joshua Hahn wrote:
> Refactor try_charge_memcg by flattening the nested memsw/memory
> page_counter operations to separate the logic between the two.
> 
> When page_counter_try_charge is made stock-aware, this flattening makes
> the control flow easier to follow since each page counter now has its
> own success/failure paths.
> 
> No functional changes intended.
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/memcontrol.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ffbcea28a608c..66f38efb800ab 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2811,18 +2811,21 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		batch = nr_pages;
>  
>  	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
> -	if (!do_memsw_account() ||
> -	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
> -		if (page_counter_try_charge(&memcg->memory, batch, &counter))
> -			goto done_restock;
> -		if (do_memsw_account())
> -			page_counter_uncharge(&memcg->memsw, batch);
> -		mem_over_limit = mem_cgroup_from_counter(counter, memory);
> -	} else {
> +	if (do_memsw_account() &&
> +	    !page_counter_try_charge(&memcg->memsw, batch, &counter)) {
>  		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
>  		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
> +		goto reclaim;
>  	}
>  
> +	if (page_counter_try_charge(&memcg->memory, batch, &counter))
> +		goto done_restock;
> +
> +	if (do_memsw_account())
> +		page_counter_uncharge(&memcg->memsw, batch);
> +	mem_over_limit = mem_cgroup_from_counter(counter, memory);
> +
> +reclaim:
>  	if (batch > nr_pages) {
>  		batch = nr_pages;
>  		goto retry;
> 

Acked-by: Balbir Singh <balbirs@nvidia.com>

