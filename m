Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B00D606D811
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 18:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=VUpReYO1
Received: by kanga.kvack.org (Postfix)
	id 2AEBD6B05B0; Sat,  7 Nov 2026 13:45:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25F996B05B1; Sat,  7 Nov 2026 13:45:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1273E6B05B2; Sat,  7 Nov 2026 13:45:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC3516B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:45:08 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 488C216036C
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 18:45:08 +0000 (UTC)
X-FDA: 85409200296.28.D0EB66A
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011061.outbound.protection.outlook.com [52.101.52.61])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6658D1A0007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 18:45:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VUpReYO1;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794077105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FlEc4ChDJiiI91iMFbjjGSGQWuLp/EQ/tbPKsa6pw7I=;
	b=XRQmRocWuoqF6OmYMt0tgy/e4D+LKzpd1+59u6PCrSK2l7usfssrZ2vJofCtVwG1ZxCE/Y
	IyQfhIB5XPIS8EDCaauDWYjbcdzclko4LXmPDsZvXYYEslmezvlgoTfLz7dgjK2WG5fNb5
	of3g4SRXpC9wl7Reco5vx+Xw5f8p+GU=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VUpReYO1;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794077105;
	b=zfD8TOp86/RvR9g8iMXwwDV7VukYjamwAIE8VqoBrST4mx7VxJagrkTG6msKHfbcAj76i6
	ei9/fzFfXE2u0gDcwibevFFYrg3HQ8hatika1eFRtdeaqwtW00PYsGXuMnGE4CSH8is8wk
	YS96La6opVrTljy+hqhb/qGkNFcPd/M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HIEpJ2bLCmaft4Pf/CmSNFLzhlf6cry7yyY//38guuajVzJcM6KhfsOFtQKuE74MaOryvywgl9bTU5PR238ieafYQ/ny7L9DWTD3vmtJn9pcI2idD9+vx8o0noVrSSGTR0eyisRc51AE/p9XSLUJvv0B0d7A05XB9h0vR5S55sbK3D0LlE0S08RIux3gglsGynCUx+hect+CAzJfsOIz5tEgWBtq2L3h1HformPyAubWEqUsntrIf7M4ZE0UU1m+B2jAQrFPkIrk+BgOBVaAOmYBWGNSX1vbLhQ7kgefnovINbl7PJQYtNKfxCrh23XVsPsuXuEYS0tE4iInZ8PRVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FlEc4ChDJiiI91iMFbjjGSGQWuLp/EQ/tbPKsa6pw7I=;
 b=qZuNtibbKQuCD777d5cekuqqzMQM7Yre8CBh69TIaNdRpeIQzZICnn6syTpqfa87aOCIGl17+WcYYy6r498UfZElGQTLV9hzNPyp8CbxqVwTDFyQ3kVQ8XhdhNe8BOfjYQyrR45tp1sn4XwWV1IwuBAahSA7PdjyBUz0eaF9MmcL8ZEVM9Pn322sey1yEd65URl9XvisQJSTM3w9cekr/Q00vkGoKF/tWZDte+y9LsgnLBlMYQ4qUb4S1ikcbe7yBnyvtp0dtipS4aQl6DDXgNaC5wmV7veOAzn/lexY6xb2uu5ZmeIpOKlj9Oh44NUXi1OSXxw4E7jXGPELlPT10A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FlEc4ChDJiiI91iMFbjjGSGQWuLp/EQ/tbPKsa6pw7I=;
 b=VUpReYO12eJMx75iBB7me+FRE5TwSkNVpZc2Rw+yITRyxsQYw7a3LUKRpkf5zu1944yRySdAVTcO4HlvTs8YcNRKPeyn1jpGHiQsDF5tOl5M01XwAs55JwJbSIjKcxnGMArxTUlGNEoiD5+g+tC0/rMSkQcBPxA0eCkSqvcDp5E2wflhnuNACYRhOarkqAkFuTv24tBgGteCUXJZYfORrxL9N4veFLY3ixvhbtpBvIOgE+ziKzSgyiLvhqo7+beeHD+44A9SbZB0oxc0pmvxYbmE9POy7+pH8fSzVI8OJ86tShnub/6mBNQ2dbJgqzhoUOK5/kDsXF5UVV73+t2QqA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB8482.namprd12.prod.outlook.com (2603:10b6:610:15b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 18:45:01 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0592.007; Sat, 7 Nov 2026
 18:45:01 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 07 Nov 2026 13:45:00 -0500
Message-Id: <DMP795RB75PQ.1XIZ1QUJ51Y0H@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm/migrate: fix softlockup in do_pages_move() with huge
 page arrays
Cc: <linux-mm@kvack.org>, <matthew.brost@intel.com>,
 <joshua.hahnjy@gmail.com>, <byungchul@sk.com>, <gourry@gourry.net>,
 <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
 <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
To: <shao.mingyin@zte.com.cn>, <akpm@linux-foundation.org>,
 <david@kernel.org>
X-Mailer: aerc 0.22.0
References: <20261107213856462Jx8pIdgdtLvPLfOFTwV4X@zte.com.cn>
In-Reply-To: <20261107213856462Jx8pIdgdtLvPLfOFTwV4X@zte.com.cn>
X-ClientProxiedBy: YQZPR01CA0046.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB8482:EE_
X-MS-Office365-Filtering-Correlation-Id: b679aa42-227f-4fb5-d1b7-08df3cff3afe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|261026140227099003|5023799004|11063799006|261022075727099003|56012099006|261009223027099003|261022105027099003|261021121427099003|261102123227099003|261026121527099003|261028144727099003|18002099003|22082099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	TaFGBWhhMiYLbQFZ0t5pwZmyc9/CW3jep2275WGTRPWe4Bqg+g3RGQv/z91DRgl5TY5iMCaLSktIGhshV0Xk69jw8/vlKBVZvZf3gnLC9v/32HaRnzdDiuHNG/z+vioYhGTBxQBgAfjCWyOUURk8SP4vPz5NaeOtyZsAYfFYVR71AfxavtP0U3Q5kdnb0WkMB44nGsgjsGPsSgBlmnduMY1mTBufyn0vdEkIeIkK+Q81X7HccPK1b8GvI0kOQXzyIpssisJsJBdh+bjHlSbFeYAC2Ivk4ZLU/LvQk5eeIN+cPPJyadC4Br1/lpImNt+XgtXZGpZJUx53aq+j8km7/QEkucEDIaYrkm3NUscGC/CF72Q1kLzdR9COMQARb3fvaj4gHLgzuMZS8Wyb0AQtR2455KPiwrdbgRST5/Os+LuUhOtaF59bdEvTZZYRaiCZCaUqGEfSI8CH3JCzJuZQWDtsxUIQrpCt5Qeubt5TOKCY3CSA6oo8dd1nvLi0eQFD2U/1Gs5JmxmB0Iz9GGHDJFomz49O4JWLzDWzkUU4mz7FgDdYKpYJN9nXOrhMFangjnN11N9xTUV+hreN1CCBOav+uDJ0IMoluLN5H8a3aaCJZUjirbjEVopSjxbATY8ky50hVeLIFQgnwC6tjoUzavYlL4/XnriD1CJ8PJIEOyM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(261026140227099003)(5023799004)(11063799006)(261022075727099003)(56012099006)(261009223027099003)(261022105027099003)(261021121427099003)(261102123227099003)(261026121527099003)(261028144727099003)(18002099003)(22082099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SmVWZDcrRllSVEZGVjBkQkhrNlRmOWtWamVaeFV6WXAyMjJ6bkhBeWZTdXds?=
 =?utf-8?B?QTgzdzRBVnJyYUx6T1VFM0w3bHM5d3kyQzMvNzRnQVVqWk80MjFKVk9XNEFu?=
 =?utf-8?B?cG1ETWN1YTRObmNVbjBCU1hjUWlxUWVRZHpqcFE1SElwYi9ENHlqTHVIMU04?=
 =?utf-8?B?QWJlYVZid1hkVGx2Z282K1pUbWgxUm04U0ZBQXU3bTlvQko4ekxjK0kvb01B?=
 =?utf-8?B?K2t1Z2dXdDdWbXRNZzJLMHkyMWE0UzZ5OEZsT3JhZk5OZ25QbzZXUURkTmNG?=
 =?utf-8?B?SXNiZkVFYVJPWDY3WXJEZUlVZ2UwTm1VTS9xTnBqOU1rN0dDZ001MDArRk5V?=
 =?utf-8?B?RW1LWHpMTmhRb0E0cU11dzhMSDRiL2FCV3RyRVIrWmtRaDZCSFNjTS9aZE5K?=
 =?utf-8?B?VGhrK294MlFFWGZNNElwc2poMmN2UEhMRU1SSEhvMElCemplVkw3TUNNRmdw?=
 =?utf-8?B?dVlxVllCNVU2WWtGTldvR2dQdkRUM3U3dkJIZHdCSmlDMXd1T2MwaFlYL0RJ?=
 =?utf-8?B?Q1k4U0pXMGxmcUVWanlMYjA1akJyaGhUN0dOMnEvaUtPUW0xUFVMYmRKSWpM?=
 =?utf-8?B?cXlwejdkVkdhS0kyMnNITGZ2dExsNEtUMlBoTWZqRnRiK0JRMmRmNUJGYVpw?=
 =?utf-8?B?eE5JM3JweWh4U0JibnBnMEQyRFpXeC9BaTZrYnlEdEh6QlQycUkrL1VldStr?=
 =?utf-8?B?dnB3alRJNmhSczJ1WVA5UWhtQkdnR0J6VzZpdXVOVGg5eHNSejFuc2h6WUlT?=
 =?utf-8?B?akFiWUVkblFVNE14d2RJbFhZVDZJVkJDWVJGUlFXcmU3UzZ6T2IyOWlOdk5j?=
 =?utf-8?B?SWtDa0hYb253cmwyb2MxRVpqUHdSOE5sdXd2b2xzazd6SFFsYWpQa3U2UUh6?=
 =?utf-8?B?cTJQM3pqanZFQU1KN3V2SDlwTVhRYnY5VUtZaEI1R0UxVkQ0d2hidkxNN0Ev?=
 =?utf-8?B?dGI4ZndmV2t0dm1DZEdkeitSQWpoOHQveS9mWWYvT056VVlFV1V3c1I5UnR1?=
 =?utf-8?B?WDIzWCtob2tUeTN5MWxFWFVSdUZQdXF0SW1sQ2FhSURFVThoNU4rYkhIN2N6?=
 =?utf-8?B?Rm13N1F5cGFFN1ptNUt2KzlQZ3I1T1hxUjRrMU9hSE5KSi9aYTJRTmxvWW95?=
 =?utf-8?B?Y1NzVHFPQ0xDUjBZUTI4dXFUWE9VTDVIZ284N0hOZmttOXZ3dGpQMDkyT1Zu?=
 =?utf-8?B?bWQyVERRTndtaFFkcWQvNmJGaktnMFpVZjV2NEpyRFA2Q29yeEJiYi84dElr?=
 =?utf-8?B?OFZVbkpEYTlqcWtPSGMxSGpHbnJYaWN0NHlCamJtQUpReVdtU1VVYlVhWkRW?=
 =?utf-8?B?eWFka3N0aWNMYS9rVjA4bTF6bGZQSlFGQ3lLbHJKMWNQZE5NbWhRb3dMWU1T?=
 =?utf-8?B?VWdCWjlEeURYTUZQcWo3NzFtbkJLMUNjeE12SEdGeEhHbDF4L2RrUVRmSWx1?=
 =?utf-8?B?U3ZxcTFPODJFKy9OTnhCRk5mWkRtM0lET3Y4V1VhNkxmK0F3V1A0VXN6d0Zq?=
 =?utf-8?B?UEc4UnF3dEtiRis4OFh3MzFsa0RwNzgySWpHZmlZRWFpT0dlZzMwS0dWdW8v?=
 =?utf-8?B?ZUt6ZWkzMHZOSVdYaFM5OGRKN1FqVDIxeGdDdFhCaklUWW1GN21URlZNSGdM?=
 =?utf-8?B?ZDhldWJ5dUR2SjJqUnRxYW9zbXhJbG5wbTJrcy9JM3pHQjRtWUZRQ2hRTjJj?=
 =?utf-8?B?bVdnWm52bjFhbWNWc2dqcFZxRk1wcTIvQ3RycnpaWVVoTDVZTW0wSStTL2Fv?=
 =?utf-8?B?UDVVUm1SM0g3R20wUTdHZTVVdzNvRTBjVkNwM3lnR05KdExiSnYwajB3RWRx?=
 =?utf-8?B?OGIvS3M0NTloNVg2V0tGak55M2xtYng3M1VCUm5hZTBPNHJVODJDZG9DcG90?=
 =?utf-8?B?NS90WnRGWW9KQ1FxSnFmMDJLS2M4amY2RWVsZDBhSGRmZnpZY2JraWYrcE82?=
 =?utf-8?B?czJQNUdLK015bDFWb2lCdUFiNi9OUERwZnVYcXdmb3RMYVR4NERFQlFzd1Fm?=
 =?utf-8?B?SGExT0F1V2lsUnppYkUvN1p2V2RYRStPdnhpUzA3S3FHVzhwa05QZm82L1Fy?=
 =?utf-8?B?UGgvdVVMd0JVZTBsc2JIcFJwUGlveExKRndBSjlJMVZYRDhjVU9EcWg0NWNE?=
 =?utf-8?B?alVET1ErK0c2NU1mL0FxQ2xxZTB6SWpDYUJIcHlWa0lwVjMyMGhZNFJyZkFq?=
 =?utf-8?B?RnVkWVBRTUt2a05GTllrcXNGL1d6TDAxUjRWOFBSSEZTKzdoRzFQQ3RiQVlD?=
 =?utf-8?B?UE5WZGlJYzQyZlZ1Z3JrMWpGNVQ5SzJNKy84Z3ZwMzRubm1PY0hQd1FWN1Iw?=
 =?utf-8?Q?j+6+sUfSYN2lMJxu91?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b679aa42-227f-4fb5-d1b7-08df3cff3afe
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 18:45:01.5134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3dS8nLYk4eO2zQFdwJ5iKR3h9cVB8OtmVj6wJs0yTsP/7glp5CfO4uXNsnamgl0j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8482
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6658D1A0007
X-Stat-Signature: qzfusoc3dhimweid1iq53fxkydr9ow56
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794077105-970320
X-HE-Meta: U2FsdGVkX1+GDcYKsUj/MFG44toDMP5FZA6ClLmxvnldFFrGWjYA0wn0lzk4lwdy3N2CwgotqsM5UTwxSnaoeyy0dMNGfAS04bMrJoSVHrQU/YLBmqxuWRR5d0qGitJD8iXLHTJp9EZI+rUCUviAxbAQbu26rVF1Ha7dsh+P8bLTCvAz6PiDsVAovtEE9p9JqVyb8+yUhOZgutwKqERHPED7621cJmeIW2FiYQM0gp4L114yUK8Nsb3D4QZy9AQAhBiLkmCUrjkOHAfEakolyejVPc6RhHk7y/OcLQU1FgjCH4E1EsCKEdlRg2UMi3vkLauPBIGtmP4xXURWIR+JVDTGw65kWU15Ec8D9s3oprtdW0eyhW62et3EC+A+SGb/VRzVKphyLhO2QwQmiSW6tTJJKFKnN4XtlUaNCDx7o0lx55rBcQ1N1i5qm6TUvwkcozuzF2YVNuGknLSSkr3X8EY51aK/xol47eXXWLMSfA40lx41uCsDN+VA/tojMP9cpUkGpd+pXtG721+NEac8uX7JZblr1gzoobqvFCIwreSDHv2LUr7SfAkN3G8KkAqdBWUNqrQclKtJKkmfGZflCE2w4OtAIqoYKB3etkU/gZAH22SpM+M/w6f7Fb6J/siVgGaOoK242AjFOis5QmPa0SJvudjbdrF8hno+A4zgaJ9H+4nkQ5gsBpzAmHGuOT/StT8dhkCMRcjZWsjhArqPfpRi/xIgjTNvKd/wFTW2OH+qShqt1A1X2tJ45IkVlrZNR3kUVMKCIlY0ciT4wOuEa4sh6dhFTy9m98vVqpZipdxaEKmZpmb9FlJBtbIwVQ0ApFVy7FK2wuVW0HjFIRjM5+HuP5sTg95aLMvOxJUTZ+FaFH48wpQLFB0JHCL9PytEqGc6l+76kD4/Uz1zPxaAj7WLYEujcJuGYEmmvzeg9Lpc6mrlhZ5IePbLibvzE/b3iQCF+DgDkhYe630cKYB
 kvmSF/eq
 bTbXNKRYR36t9bW5/L3zVOUqZV8YwDTZdi8xvMGRGDIMRRXNJaMSiftiMG5zAQu5mtjMhrzgeWSjRKdnaCOZgpsxTywDTU2AzSWwk0pBgOfou8MvgUy3p5VFfdAHutfGVXf9AQXfsWK3LQQmQ6xenBDc+pJaKD4TPrguLqr2tCLByVV+8dmObX/7oGUHEllhzWhnwdDkg793GxYGnJQU2IvYAjTUu2S3UeH61x4fRurm7OMEZLT3FyMr6mNo+WPk6lImrY7kZGad6R7jW/VwYjuA3FDlg74AkTI68pK/ETTbun5JqZO4PF8yRxFsbR+psOz7GtDYzlwdjY9zwZN7o/h1iQ1P4fQrMYoAqwOkck2ryBnVXLcazUeb4UCuI1Q1hNIqWqK3V4993DejrxdPdYj9gCJnEwTgkOEMnyPz1acvScEnGWXzEi6OIcTY5SZBXzL5Cd+c4svW97MGDk9NL3jJMif0YFcvuo6wCGQQrrLaZTIYyk1+z91EI79xgyTfl57zY8xZDwAmllq2xH1Yd7KE0uV3PLBZPcOC238eR05e/TTaInI7/g3iT4ev2ChKL39CGvF0c3Il383e8i6JQjCUoBCk2o2gRo1NW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat Nov 7, 2026 at 8:38 AM EST,  wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>
> mm/migrate: fix softlockup in do_pages_move() with huge page arrays
>
> do_pages_move() walks the user page array one page at a time.  For each
> entry it performs two get_user() calls, an mmap_read_lock()/unlock()
> around a folio walk, and an optional store_status(); none of them has to
> sleep when the arrays stay resident and the rwsem is uncontended.
> move_pages_and_store_status() returns early while the page list is
> empty, so an array whose entries all resolve to the same node can run
> the whole loop without any scheduling point.  nr_pages comes straight
> from move_pages(), so a huge array can hold a CPU past the watchdog
> threshold on a non-preemptible kernel; with KASAN and function tracing
> enabled, ten million entries can exceed it.
>
> Add cond_resched() so that long calls yield periodically.
> do_pages_stat() has the same problem and is being fixed separately.  In
> current mainline only alpha, hexagon and classic m68k can still select
> PREEMPT_NONE, and they cannot enable CONFIG_NUMA, so this mainly
> targets pre-v7.0 stable kernels.

This is probably in the same spirit as the do_pages_stat() patch[1][2].

[1] https://lore.kernel.org/all/20261031033330.3416326-1-xiqi5703@163.com/
[2] https://lore.kernel.org/all/20261103080557.1632382-1-xiqi5703@163.com/

>
> Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
> ---
>  mm/migrate.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 875079464930..3122ecb85270 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2372,6 +2372,8 @@ static int do_pages_move(struct mm_struct *mm, node=
mask_t task_nodes,
>  		const void __user *p;
>  		int node;
> =20
> +		cond_resched();
> +
>  		err =3D -EFAULT;
>  		if (in_compat_syscall()) {
>  			compat_uptr_t cp;


--=20
Best Regards,
Yan, Zi


