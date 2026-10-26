Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88A64606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 02:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nAWaveJG
Received: by kanga.kvack.org (Postfix)
	id AFA446B05B2; Sun, 25 Oct 2026 22:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0056B05B4; Sun, 25 Oct 2026 22:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999746B05B7; Sun, 25 Oct 2026 22:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 69A106B05B2
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:12:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A92D11206A3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:11:59 +0000 (UTC)
X-FDA: 85363151958.03.FAB3203
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013007.outbound.protection.outlook.com [40.93.196.7])
	by imf07.hostedemail.com (Postfix) with ESMTP id D020D40002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:11:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nAWaveJG;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792980717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M53coe9B6YuXkkXl7H55pVQaweFh8BizigrZS4LvCQE=;
	b=3fzc4vnc9wdNY5vgnd8rH++MB9RzN8G2Er8h8dV6g2FMzOCjampFn5b+INyjPC3MG8qQfN
	/nkfDTM5HH6m4rsLQru8QlgxyppF0nfdVRGv28vl6FqNdcfrEiapDdsv6ouoqTTKJbfaVx
	QbZwaUKLmzYV2dwASm+R8zkBZaSx0vg=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nAWaveJG;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.7 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792980717;
	b=qg2IihtleGU0rMbYww8hJThI1KBQjidKM7UeE4MSUyN+K7rRGxYUh7OKwDp+iTqWkCxYf2
	LKZdzNQ9Yd3UebFPiW7sVKwPpfQckW85HwUZGhbhlBB9qafFlXfzQut9GR2G9+f6CtBUue
	UB43BugvtYqSrioTs4cpy288vHDN4k0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wH6hToDsy4zjVed2fpe1JHEjwR+Du0qswZtrS51LPUGmghbYs/CpOpTNz5z4iBJD3XxhPmgAduH9JpuUMrxmg14ysy+ZVEIVKUzeT8aUdZNyIn6XUmRnfVQoWYJfHaFy6e+IuCx3YUF5j8/oCqnJSVVuml2/tyToRy8WShIzVyVQaa93BomTxfqJSidEwSphhUbxGGi617xcNFnr1EzFjYMFrjCe3hXJCPx1TedC5weEjN0KCakLjcp67dfwi9yX/5RuPO6wiwR2NSrMqcAC6NCCFGFBdhOh0KlUZFuPcM0H41x+VBSlkw1dMwNnpK6p6qo8666P2QXlsG263vM+gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M53coe9B6YuXkkXl7H55pVQaweFh8BizigrZS4LvCQE=;
 b=iSWnXN1reif6ejcGt78zSghmPe0S1lHg29IFpiWIM9Hl87euuWToBQTRL/64Q4I72gS3ocg0zrpYcmvEF1O/woltjNnzloqIEV5fjgrPOzDB028ae4uuOAO4DGXNErGsM0f/x1yvDVGVdoogRXvpzbM0ZQGd6jjROf4kIIMhMZvyh6LgBQOIIeMPyQmz1P9PkeOwwFv8sU35eD25Nybgt9/7QebNskA8sCklNZIK3HlXUx8nuwN9CL7tkqpVvD04Y3CbbYEH6edhQbm6MZuVPVt4bfE8Bozw+nNc6GIsxe7vzC/fKjuxIIN0WkJ+UyIGs3l5Pv2R1tLGGiScKwHC/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M53coe9B6YuXkkXl7H55pVQaweFh8BizigrZS4LvCQE=;
 b=nAWaveJG/tQdsakDXfVXxn/4RRhpMxQcY6xboTKMDMbDd9uBGumOvy/SoHJeTKN+NAlXLRRuZBCpOwzyF7GSZrWkiyowMSsf74Q1ff8jOVs3SqNs1SLmBcrFag0fm/fxQZPhLbjJcgfDir7G25q/wRfFyVk27QnUbXM/KMB/CzX9P3j8Kumtv5M39glCsYmczD04cqVywp46VxWHlG3VuiaEVTJxj6JZQ48TDYho+vqRnBMuvWMM9RYPlp4TENFbS/ZJcN8soh0yvmzI/QNSuVblVQkz3zDZ2+RaxHlajl4QK+yRMgrjUQVRCGR38JyANFE3XsWx5vwOw0rLJwuSWQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV2PR12MB5893.namprd12.prod.outlook.com (2603:10b6:408:175::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 02:11:52 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 02:11:52 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 25 Oct 2026 22:11:50 -0400
Message-Id: <DMEEM7DQBBDI.30501R6X2TSDL@nvidia.com>
To: "Hungyu Lin" <dennylin0707@gmail.com>, <akpm@linux-foundation.org>,
 <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm/migrate: untag addresses when querying page nodes
Cc: <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
 <byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
 <apopple@nvidia.com>, <andreyknvl@gmail.com>, <catalin.marinas@arm.com>,
 <vincenzo.frascino@arm.com>, <khalid.aziz@oracle.com>,
 <odys.yuan@gmail.com>, <sashiko-bot@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
X-Mailer: aerc 0.22.0
References: <20261025223226.33740-1-dennylin0707@gmail.com>
In-Reply-To: <20261025223226.33740-1-dennylin0707@gmail.com>
X-ClientProxiedBy: YQBPR0101CA0219.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:67::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV2PR12MB5893:EE_
X-MS-Office365-Filtering-Correlation-Id: 5877062a-22cd-4475-0c65-08df3306803f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|261021121427099003|261021123027099003|261022105027099003|10067099003|56012099006|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	tx54hQrg1d5p6N9MuJruXqeaeQm3Eqpp+JQcVRgD6hymUZbQVGhFuBqxyiX3C11Ly+OU/yv0ESvErHDPQc41lxkHKiPT020a5G0xGPNQSUhDTlYpGMGDCZT5fjblLPXqeXCRcnfL6+NqsmLTSmqhBmvroRSJFG/wvYbu8FLbzanm3Xyc1ezEjNofcS17FP/wXbEh2Yln0pYPL6ll0blHguEPtRQoXHTKntTcHnSR0qxlf22S4DuIwM1Jcb+IDIDMo5Og9ClTXqIz9l1MUaqkK8hQHO0xkZcefnYbDr4JSplPM8nfNdYeF2h0NGd6/BLi8uHsy6/EyTMxF5P46pNFIi5+wVGIjlkcqeT8heJXOiPsO2z9XB/KAOwPF6WOScL0r7LhOpLiOgJ/2Lxp5hPUsmuM0AeOFLECpGJBjZbmSSeh+5jEc2JnY9A5/RmYpENiOS9H4vLuhBSf4QtNmKC33GyIp5Z80qK9XpWYj6xg/Wn0UH9X66f7fJjDrJRvJW7M4xCvN319lIxbzb3TwZbR75UI0YviUOyTw5xjWXwTAcGsvpPd/1E9NRsLL044bRNO1UhsRNRWrCV5nKUqBQuNyPFNF77u/4cr1Qp1iBGRayzNtJnSh6ey5ffc1SDJ/vwALvEZFNcnkrmZWX9L/gYdV3Seq+Hd6wYC2skUqwIAICA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(261021121427099003)(261021123027099003)(261022105027099003)(10067099003)(56012099006)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlhxSHZYU0Y3NzlHSGUvS2kySTNaVVg0Ylh1bUpDYnhvMkgva3Bsd1ExRFNT?=
 =?utf-8?B?bnRDbVY0dnR6Nk0xN2xiYWFsN3VLNk9oTzNuZFB6Yml3cWN3ZExyL2VOdG1j?=
 =?utf-8?B?c1pSNitRMTNyeWo3VnQ5MlVHbUNFUnBzc0h6amVtZFdoL1h4OXZoK0tjQ1Ro?=
 =?utf-8?B?Y1NOTzhYTHc2NHFZSTh3NG80dDNhenhiMDA5T3o0Q0QvMXM0MWFBTE5sZnlp?=
 =?utf-8?B?cmR5bmN5ZWxZMHVjNGZzSEpTbTU1MWdINXgzN3pjYmhDNWVYUUNKaVBWRFBr?=
 =?utf-8?B?V29zSGxwUFVvYXlyQ3daRk1GNnVnYmhpYXNxV2YvRVZFMXlXaUc5Q2hDNUc4?=
 =?utf-8?B?SDl4OUhhM0NTUjRnUkRXbllnOGJNR3lqekZXVFZLbkFWRjlXejVzbjRZQ0RL?=
 =?utf-8?B?L0xSeE9IeVBXNkdGMWV5TUpzcGlhdWM0dEhncUFPb0FtMjVBZkdiTCs5d1Vy?=
 =?utf-8?B?ejVuaDI0enF4dVFSblpaNHpyam9Fb21WeUlHTU5taVlwT1pGTXF2UzFUbmRm?=
 =?utf-8?B?Ump0L0hpQUhzbjU1SkdQcjlSV0M4Q3ZFb09KdW5nY0NNN3d6eC9IM0k4SzRM?=
 =?utf-8?B?b3prMUczZERWU1JzM0Z2RDVBOE9ncnk5ZU1EQlFEbGJTS0dtR2pxZnV0QStX?=
 =?utf-8?B?STkxbEwweFQ5b01KdE5EN2hGbmRnelB3bEN1T25ndVZvVi9xOGVxSFFJOHhJ?=
 =?utf-8?B?bnU0TzFLN253eWd2QUVNbUhGNFRFT204bVNmbExTdFpWb3NPd0ZhazlPM3ha?=
 =?utf-8?B?R244U0JEZW51cHA1MkVSbWp1L01PNit2aThsc1RLT1BDWjNma3FFUFNKQ1JY?=
 =?utf-8?B?WDVEYTRtNnVJRFN3QWVKbTVjN2NGa0Y5MjdSaVB1L2dzMTRCdW15d2x1Q0dD?=
 =?utf-8?B?S0JucFNWSkVRcWxCVWdFYzRJSTY4cUN0eHV2dG5ibzNBd2pwMWp5V2ozS3lJ?=
 =?utf-8?B?djlWTUYxZHc4UjdmbDQ4MHpLM254QUw4STNoMFB0ZFp2eEhldnNNMFFRSUc5?=
 =?utf-8?B?aTF0OStydDZIcGMycktPa2pYNVllWHhBY1RsN0Y4R0YzcG9HRmJIc3VWd3dG?=
 =?utf-8?B?SVlpWGQrUGpPd3VtQ3dpWUszcytCYkd6UUFNOUk0dWpFc3RaOHM2aXlhbWRk?=
 =?utf-8?B?ejRnbHlqOEpvSk94eG9seE5VNHNLWHd2MDZDekU3L01FTkJUQTczOWRpNXY1?=
 =?utf-8?B?RVk0WFQ0NWo5NUdLSnpmREFDK3pBblJCdEZ5VlRCSTlvYy92UHQxS0xPLzFV?=
 =?utf-8?B?MnhkU3loMHMxYmlQNlg4S2g3YXpXa0pZcW1NV2xqYmNWd0RJbW9pb2lab0Nz?=
 =?utf-8?B?T2FUS3hTVkFyK1daWTkxRXZKTTFhckx5T3g1bHN4RTdsM0NzK2VCb0JiTkhn?=
 =?utf-8?B?ZGhNdXdmZGFmcU95RFhqcldlQVVmMHlUbTV3K2lFU1I5aGhHdnoxV2NXZmJQ?=
 =?utf-8?B?Z0pTZFg4NXBvMFNhd0dIdW1vNEF2WWV2QTU0bUZ2dTNIejBHanRQbzhxUmNF?=
 =?utf-8?B?R3FLeGc2aVFCb1NJemtsdVgva0lZYjVaWUtEVmJDQ2lpb0plZnNqaDE0WGIz?=
 =?utf-8?B?azZzbGd1WC92WTlKVnhySndzQW1paFJFZlhFZUVTSDRBZVljc2kxZGZMY3Z1?=
 =?utf-8?B?TnE2QUlPc2VnT2p3ckpsS0MwRGlkS2UxRmp1MVYrSXZmNlI0YnVFYWthVHVu?=
 =?utf-8?B?S2R4NEhhdno2b1Y4Q0VWR2ZydmJiZng3VUpTZ1FsSzhtS0V1SUdZQURadXVk?=
 =?utf-8?B?T0NiTFM2aEs0eW9MM0IyUmtaUFUyYnFtOWQzTlVXTDdtY3JtdVdJQ3FUOTd3?=
 =?utf-8?B?V0dDZVhmME9LRlRHaStZZ01HZHlyZ2RKOHNuaGpwQ3JGNC9GZ2lQYTlxZEFs?=
 =?utf-8?B?QU9UUWFSZk1MU3lnTHBJTlFTdzFwYVFmVStpajZmK3JVeWZQYnowTlFQaW9h?=
 =?utf-8?B?dERkcFNma0lLMGx4eTNKeU53eEFqdUY4WGlRem9QZFpxZlNMc05YYXhTN3h0?=
 =?utf-8?B?NVhvaTB3THA5dkVBeXpxVFpxdWdoZmROaW10QjVSWnkwZ1R5S1p2aGk3K212?=
 =?utf-8?B?NzRNcUNWdVAralZRandnQ3RYSEtVZVh0Y3RycHM2c1Y1aFdNbEw2UVBwMkJ3?=
 =?utf-8?B?eS9vcDFUTDA5MSt2RXV0V1dCN3RTUEFOd2NNUTFKb2U5UWVPdmxKeXRiTDVm?=
 =?utf-8?B?QndUcGpDWWNLS1ROYzRGRXlLa2VVajNycW1xaGZQR2VOYTJ6WC8yQWgxc2Rm?=
 =?utf-8?B?eURDaGhZeUxvS1pnbXdnb3JiSzNBb3ZWeW91bHFPSzhxMDNtVW15TEtpWlE1?=
 =?utf-8?Q?HKREGuPfQwEibH/zae?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5877062a-22cd-4475-0c65-08df3306803f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 02:11:52.5511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pq0LuGXuEguaYWpGg/G17AzHf/xYJohCyFzCd7yKOS79oIiXAur3WgeTIHLC0WVY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5893
X-Rspamd-Queue-Id: D020D40002
X-Rspam-User: 
X-Stat-Signature: azhdaprsydph1fqw6u33dr9ts8f7x1wo
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792980716-606530
X-HE-Meta: U2FsdGVkX18mX7K7JSUKcxvMYWTcj1UA+5nkq1O6Ach6t/VXkVKbhZCx47L1c7NDnSewuijGv2zC7z0Ybx3kksh367TsgW6LRhzol7m8DGjXy0HkwC/m8LvOfKNShdkrhMTegEladFKQkLPhhqBa+SuzfMSkcdLu8WYdkrdgk8euG1V2Z7iNnxRoNmEqGZRARGS0IDpOAKnv7gdWCpk6G/ShNGPXd9cnApCx1yObK3/YrRjweAWXXpzheKYGlf7C8VqK6rQB1q+YTn99KHKnIxCwAmdhYzqsqfg4tko4+Ab/8usVkOXPgnMhi9OhZDUL9U+kG48tt6TOmx89rpGfXsf+UBmPKGvR2GEz1GGLe/A5szD7+h/FwjcHe+EOjR10ElWdtCkIT5ecd0menrvr8aMozV6coXnJZXdQkqW5gTQso609+JOT8Eb7cKYxXYP7fkL2X8kahJ9fZg6E6As7MFTPmacXzaOpsssOQxYtIy0wyhBwi9/SaWbDQ44GLQyls7ce5/wg8H3uTQbvoDmoH6rxfv8HkIOuMN8c6sOdFkiIBrmCVTZNMJhBTt6mLqa8Uglnxp5cPRkhmR9HwFsrFEunqIXG8C3Y5Lb2QK676EVIj6+6D2MS1OyqRfQutP4RHdPEfnOLW1nLf/lb3D/GMur8c2hQBMgVxoIEZs6nyDF0EEOpoDUmy8SJZsGAup9VgnTwX7HDZS5pH/1Ezd12TufGc0h95usl9Yt17hEf1OOqcxl8N+qzbLbUmpQLaukS/ND+yaNDih0AOmZmbrZ9hD7Zn+G1kvinkt87C17pFb+Vo9rL5UxceMclCwuIp7HD5ckHlxUIaRBHqEaeGnglNM295n9beMYxA+GhePuF6GbCDAXoHMGnE2Gn7tD3vntwpJCMNEc41nHKLRRa3EvH3NpQZ7IDYJCu96bIL/MjIvp3AXFMxuggGe78AJcXB8EXf3PW8RJIXhuIh34hUqT
 Is8dXyHD
 QNHrpKTm89ScK7iI9G4y03rbQypvxMkIPIOfetRoMkZIN0A+IdCsE9ABD9qtUyoG4v+HDU2w7IEaLpnVQeJC4+Hz4WEDFlhLW5rWvTbfSOaFQFnCGk/6ApnAc+pePzqvWN+OCIkP4fIovEOVVCxQlJgTch/hxdmhInZ7W2IU8+ZTCcFPyBv9vgoZOxSqTSO0kd2UsfSYZ6QvbRzlxzJLPv4N2Prbw5FTr61CSvEc3JrPoCjkH+sXrJNKJDxRPFkNjryzqaOvGOaax0kq5h5A/Of796LK8O2wGHDfnbxx7SLivkjnIThji3qoqCQNz38a4tdLEfFn8NadyQna8lhYr+rrcRBnqr5jiQS64X5qHHnrQ5sSMSozccZe3wUjpNs1mFPoapwNeDB6SuQGAl9apxWBWGnvOP5tVIqa0SX3mAlbhWAwaTs1GSQTX5u6JTkM4zzZzTrgPkZVodJgGR4DVgRa3Bn+Or6D+sMziRZirXTWZMlQp92O+cFXUStAPLDNuzreeRkBNHCp0AhE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun Oct 25, 2026 at 6:32 PM EDT, Hungyu Lin wrote:
> When move_pages() is used with nodes =3D=3D NULL, do_pages_stat_array()
> passes each page address directly to vma_lookup(). A valid tagged address
> therefore fails the VMA lookup and gets -EFAULT in its status entry,
> instead of the node reported for the corresponding untagged address.
>
> The tagged address ABI permits these pointers, and the migration path
> already removes their tags. Apply the target mm's untagging rules to
> the query path as well, while holding its mmap read lock.
>
> Fixes: 057d3389108e ("mm: untag user pointers passed to memory syscalls")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://lore.kernel.org/r/20260721183257.706661F000E9@smtp.kernel.o=
rg

It should be "Closes:"

> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
>  mm/migrate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 7e3a81f06974..994c78782a54 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2461,7 +2461,7 @@ static void do_pages_stat_array(struct mm_struct *m=
m, unsigned long nr_pages,
>  	mmap_read_lock(mm);
> =20
>  	for (i =3D 0; i < nr_pages; i++) {
> -		unsigned long addr =3D (unsigned long)(*pages);
> +		unsigned long addr =3D (unsigned long)untagged_addr_remote(mm, *pages)=
;
>  		struct vm_area_struct *vma;
>  		struct folio_walk fw;
>  		struct folio *folio;

LGTM. add_folio_for_migration() does the same thing for user pointer p.

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


