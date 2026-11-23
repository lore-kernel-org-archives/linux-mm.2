Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 226C6606A33E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=A4PDlRCy
Received: by kanga.kvack.org (Postfix)
	id 3EADC6B05B4; Mon, 23 Nov 2026 12:34:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375086B05B5; Mon, 23 Nov 2026 12:34:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23BF06B05B6; Mon, 23 Nov 2026 12:34:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ECE616B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:34:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93582C09D7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:34:04 +0000 (UTC)
X-FDA: 85467082008.04.D26A5C0
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010016.outbound.protection.outlook.com [52.101.46.16])
	by imf01.hostedemail.com (Postfix) with ESMTP id AF5D04000A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:34:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=A4PDlRCy;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795455242;
	b=3OxPL7UNFVU3Fa7A+pWAchcxArpCsVV0UpaJjQsfH2TlObiEIPqEvCPuDYYSDizr7c6+TV
	SI6mTD8Hd0tGsmtDe1HttoQ29JQe4/6a8S4i1D0NLKzNDfsVM0hmtIKNouoZfvigeJyiMr
	QyIOQ7mFBkmFgQv5JC1+KGTAzQkkZWM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=32ZbtV+0Y05rKT2mVG5RzLg9mrWrgSP0r8A+lptjy94=;
	b=MoE6n2V6srWFx+qCrgXfi24i4hheq8YBk11dkTqg+nBG3lfEueIshKb0zIL5VOHv7aiKvT
	Fn3dNswmRwgcUNegZUZdG4CcoKxQkm85wHH9DgAi2Qk7ibFxtN++uYgoR6nANy8q42H8FQ
	hICNvgeMs3WZ4gSvVK90MIvqrj4XqmQ=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=nvidia.com header.s=selector2 header.b=A4PDlRCy;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.16 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OTcG51FD0Fqhsl/QgVBHtGGyhe0Bn5+D5CMFIcESDKJK95ERnLsfRbBbyqv2hU0zV07JV6G6CV9Kl6hxLrPw8s0cM5lO+XBusQOwZaaEWvNrYYElqi51S8x1+L/xkSX0r5yap+/WTD61cUQQGbqVNbebhlMML2jH6jagUm9b4aoYyrwwn+Onbr167aQH0MO7WZTzZhNmI/kku/bpCDPuS23F8IBCBQuBgwQQVCsRh1ZcJG8hthLnTL2drbtkB2OEY/wDIHu5puKVjpZFSkf2K1HJ1mcAGuMZo7+TFgVbV2mVvmStgEgcX9GBekPg8TTl3hZqzZh4ZGStCMAwuSD9Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=32ZbtV+0Y05rKT2mVG5RzLg9mrWrgSP0r8A+lptjy94=;
 b=oYnXSnMQVpsYzWyeyl8fYF4dMSZUlfEkUAOKU/99u8JQQVGJRszZOUKXPoZxBNfvvRAuNv+jayp8A579AYq+vhx/6ZOiawxU6csBA5PuDRToOV5UNV4VkXxVJf20F97Aw4ScsChMfh/SBZ5wKL5I8Ok7XU1c4SvNRIl4j+qTml+oaooJjVCfWo+ZeamhDlCKDxr/nh6poQtLxuTZS3D1sRHoeNGVM2NaJpxWRPYLO0gdpYO1Ml4wZY4blN6VKzsLMswRLRUcM1P7LqNA6BZmYViIzX2+aiCz3FJmOTbiHoRMoN0IUxKj6WzkvNZ3EPNfLmLn/rb+ySHyMaqvrOg1/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=32ZbtV+0Y05rKT2mVG5RzLg9mrWrgSP0r8A+lptjy94=;
 b=A4PDlRCydA3SWJG9KsdtkIdLOc7kpxOg0/d9vOthlflXNAOW9KeuiMXm7TrXha859tOl5DW5jhfr8aIm6sEv3RhDZa4gOyApW8kDma5II/CiX2UvRk/zVeCBX98x7ZAgQ8Op3/obwtQcBKMxYgcsFxBOTcxorlVoS7vG5HS9PgdwBr60GQ8NGXE18gf2D8noY1oYv5GDlbLHLziRsbudmHOKmANS98+Wwy2ESUZL0BulhxfUJQVT57nSrO0CSOKs5AV3UUKsVXVoqr2drYiT1UZyPG7BVILJ5gLs3wBr2jHFer/XE1/ubf6X4RY+s1h08qsJodOBCxAXqAMU04Ff4Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CYXPR12MB9386.namprd12.prod.outlook.com (2603:10b6:930:de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Mon, 23 Nov
 2026 17:33:56 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0639.012; Mon, 23 Nov 2026
 17:33:55 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org,
 surenb@google.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 kas@kernel.org, hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 kernel-team@meta.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH v3 3/5] fs/proc/task_mmu: read the PMD once in
 smaps_pmd_entry()
Date: Mon, 23 Nov 2026 12:33:53 -0500
X-Mailer: MailMate (3.0r7038)
Message-ID: <DEFCBDD1-3E3F-44AC-8746-9B65779AECD5@nvidia.com>
In-Reply-To: <20261123163301.1568240-4-usama.arif@linux.dev>
References: <20261123163301.1568240-1-usama.arif@linux.dev>
 <20261123163301.1568240-4-usama.arif@linux.dev>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR01CA0057.prod.exchangelabs.com (2603:10b6:208:23f::26)
 To IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CYXPR12MB9386:EE_
X-MS-Office365-Filtering-Correlation-Id: fc3913a9-41a1-42dc-a2ef-08df4987f2fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|18002099003|22082099003|261021123027099003|261021121427099003|261026121527099003|261102123227099003|56012099006|4143699003|10067099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	87qik0Mvzub5flElP9oUx3h774/8alwWz8B1iZhRBOJTolvp3HAx6xSOpugHJjFQdD8sWi6vab4scoPCcXeB3ZIlfSLE7ePflN1o9BQycULRcMj5S3Y9XzOSKRmffZcWjU2b/6/1ElxVIFeQ4KDcQWo1sIB582uf8BjpuoY2NGWvmPdMb00AjM8e3OtOMW+/ZCttz4h1TSEFJtfhW/oaWrHaHktunIVQBm8mS2q/viqx6czC/luGbgf4lpaCiUZ1tctLOO6QDTWiBpVKdY7pDsB8xgF6rSQUE5Id49isILdMmFGTizgIC1y9ciVfERaIWYsoqqq1fycO1eMNtVDBZp9zvAfASIlHlXwS2n2Dq4zcDIBsZ9FFwJGpPeeTo1tV4nv3dA+QClvFI9AI1fLoWbK6sZ9UazDZNKWE/R2t2/jtY64DoYlqW44vY1Up1f4AbcbAdGlGReSHY43Z9bvq7US670V6/LjXW6u69xJk1cUtCHQXd8n8lHYI3v0pQLWW4cHKTFAtmnwF1LazGO/JH5AcQ2qKhV+dZ7ldzZxi14YtBP/01iCRimiBGU7aNYKK6KXh/LnFyZ+ZOSx38AVub5ktfXQ4QSgPNTSnT88fUC3QRt8mpoGsih11w7K0kZR0jdGoRvkADEt+T9GI9ZYaxF/if/6qnsecQuAoRS254QA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(18002099003)(22082099003)(261021123027099003)(261021121427099003)(261026121527099003)(261102123227099003)(56012099006)(4143699003)(10067099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wDo//NHhKmNmg2gIxDE/nsYM1/g0fTxFVOW8N2lDXf3efY+0Xhjpe5CiRi/o?=
 =?us-ascii?Q?VwhW6/EYeOJrS9pK5sx8uxSGvCMRd4yQ9D+XYy+BKu61ZwxXdIidm+KVYfdq?=
 =?us-ascii?Q?MHawgiwM1xuNUr+cqqFjZNPLG7g9OuVhWLBb2GD3/t+tvbWCEF5bT8oiXDqI?=
 =?us-ascii?Q?6ywr2bxkj8o6Jb64tsj3uFc+WGhL9vSHUjLiqZeo+X1a8xm2c36ncJ7q0ROK?=
 =?us-ascii?Q?nDSF8k5xOOwIt9FWnMdg8z0R29Y8vOCtMAurxvfVW3rTc0vXI8jA6sx1ffEO?=
 =?us-ascii?Q?YCGIV7J5Fuu+eqsiNEUKPxeKWVHDnntPvxPofrjVQ01K5CqN8lLSZhhP7hZA?=
 =?us-ascii?Q?ZsTWEzkmfB0QASUXV41Vi9fPeBLoLWChXuUcUlbCTWjcqga0HBzEPpHOD4aV?=
 =?us-ascii?Q?16WXHv/NXeYZ76h3HP2iglhvsA2ELMAqvoCixJzQZ77NI4j4LHo8PX3ZJlkq?=
 =?us-ascii?Q?DPiysrrSco5NT+afCVLuFFk4Tfim86fQg07giUuSDZFAUMCUhUzMMBIL330w?=
 =?us-ascii?Q?NmmDDO9+wseRJxpVIcOBJOVMQUhK3SZ67jn3Y0jVQyLUPINysn6wDULhueqB?=
 =?us-ascii?Q?InXLxF944fd7ruEBlW0D+xFKDBnQvfjzrsCNsJeY1mTKNOShQHXGgF1IERPX?=
 =?us-ascii?Q?XcNTOHY8+LPQeA+r5RZgO1yHbfe5TMjHMnMQX/g/7o1ywU5/30B9+k8WBabl?=
 =?us-ascii?Q?7kfgbteB13rbNq0pBlMW5Cd/Rd3ysJCe5o9X/CBELHqG9X4rfUKNHUFPiSxw?=
 =?us-ascii?Q?2jGcG0+k7HnYHlbYFOdEVv7fA1YbWqORoIskVTlF3WZnCn8vmDqfPggidGus?=
 =?us-ascii?Q?xwg0t40jDid5+3rqKoZX7GAiFPQjnCFH3Qh/X/fPNyvarbrElIgk78HrcBcT?=
 =?us-ascii?Q?rW7/iC76zk15ZqA/nnELdy9GVERVYWZBwL2kPWB0ne4tQ3SCRdCj0g/aXf5D?=
 =?us-ascii?Q?PVn914BdiGhdao6pWSQylDSOQmi6tg6M75hGxrqwqSnPVNcBSpw3RwypUI8C?=
 =?us-ascii?Q?AW5poBqFHKc3HTokg6tXBMJZzjWdjw03jWPl6bUqyK14ijD/Ab26ltxIzZIU?=
 =?us-ascii?Q?Z7GtWJ65ZD2pu4nB/vOE3HUeFS8PURdhTXtjNO0GGIS5JCDdsS8zyzynQ5JH?=
 =?us-ascii?Q?4K5US5t9KHA08mPLghrlX2RWFGOeXVwllaXKg6DYRr9B2nf8HP8sjlyQ+ycr?=
 =?us-ascii?Q?I20hnw1KhPC/ydXzWaVUBzjeYqTRgmJBk+FYZ+wxioytYAAsjYr4OVlvtc8T?=
 =?us-ascii?Q?Gog+59bR3cxWEzjC867GJXfEK9rWhgLeqnvcubFZyVnYT10ake6E02Av0/JK?=
 =?us-ascii?Q?iXspQclHYMSbjHiKfb4fdPpUL/CSkNxZ43Os1gZqU7m4GakYCigjQQF4i7Lo?=
 =?us-ascii?Q?UYtGbZ5HnocBIrIKQvi+BCrBiW4H0CUwxbxVq3B6k+h1e7t20WGklrvpKaBS?=
 =?us-ascii?Q?0MYLUpdB4NadN6GPEO3JC+dL3Re+tfr3zfE4pp1MavZUGcLuICiBdoK1T/3R?=
 =?us-ascii?Q?PnU8NWlQOlCU2ZcdLLXL/Xe/WaUbiESTRXPm8kGPTeap5k6rgCjxe5LnCgZz?=
 =?us-ascii?Q?Rgm7xRCtK3oW7uXBfhoQV60YcFejAchW0Xo0OcbKMFqVTV8uvJX5MEW/Fbqt?=
 =?us-ascii?Q?XX9f9FYCb92t7MBFG4foJTgeuXOIr6iWKC/PAfOE9rRVkirLbmmIfPkH4RbK?=
 =?us-ascii?Q?xIG83vNanxWFHDW4dA0+WPD+/vSM6ANfYaRtOISC+JxWIf0E?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc3913a9-41a1-42dc-a2ef-08df4987f2fd
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2026 17:33:55.7168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VYK/yBrc1HV3BVuv/CRZtbiMkqI4o8nMFXnojy/jzKIvdyysdKFwmx6PZpry6GF5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9386
X-Stat-Signature: 4nioa536gyzfttrd1xkdr7cxy33pa4i9
X-Rspamd-Queue-Id: AF5D04000A
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795455241-977283
X-HE-Meta: U2FsdGVkX1/sUhYFwOE6tLKspvqS7D8Zv7CCioK+qOrkNNREYMosAITxexE89gRjJ9+Xa9kpXXPqyEORdVg9J5bYyQRYgsGTtMIvg5AVFLXcUikrcdv383ENjTHBiHK8Yx24IVkGnmi0FwJQ/usssmFE/RR5oVY+As1DKl6wvxGdpEsnjQIW5f3CFVOqhl8MeLFm7XofcA9Md7/Q0/wzeKp7VZsqmWlUBmE4/V0y3X1kh7JbGa/rzVbrNKZTXD1uJyJ7G31Q1gI0qGK9/CRQvpUK+tqasumD5g8THz7EvP7YvK0a0ORrI653aAzzk88CBXUyrHDwnvzjawjf/kL2zvZfFd7ocaCQea8VyKTdnQfTpedyOxtYxJxbq2Tu4XKfvh8/XsemV9ukG9/LMhnkvlniFh+FvfyB9ReJc5mA/v6grkHMgV5Dtj5rgghtRFa4eFlGKXlFfHgUXI5f/WixI1huPEo9ZLqDiK997870nWEngefbE0/nxOeDhT0jVAwmOf/UNpWsxakPXHfogEBtYtPv3TYIFkrvNUw28wKEb9bEBQbxWkMuxy/kruNDH9xWlj/1DQ+qBU9Y5zeEaAMMi7NfDN1drRj8EQV45HdagQ6hoDHmZwgYAwu/Le6Q6UXLGUXMUg8skW6GJO/AP3yu4lNzSNjrDeDL2WLYuenOz1rVp/UP9XvHr5Nmt86D98/JP7Kj1NpvXV1xEXOr9p96aBy/SyLbkwkC/V20+zHTmSfKGBSmh8eXcIKE/sSbX40k87nXzBG5YCo6L5SwqY3P9gq+gDrmf+2gTme60IexxiIHF2UqL7SWd6+EfaC/8BvkAhNcqCFgefnb0Orvtddl7IAVJ2ZxuOpGMEv3TcTVm388jni1Ca+T7SNpDqA89pWaeUs52fyIkI/8NoSu2mBEYPAcLPV5f+emsJMTwM5wIPE2cy52Ex7HF5YhD+j/6CDyovVd0t/UudxoGLE6MrX
 ddJqFgL3
 L198vnn8rkNcynESOWO2k8SwdMxs5cTOvVpGGbq75wP/2fUfichz6uq2BSroUr5ez5oQW22COLmk33FPU/4d/Vh8RsVrGlTJUXRh6UE8Z/Bf2ddw2SvgdSBDEOU7fPSbfIXA16uEy9EokX/NftQR62bbyK3T9+45WrQGawdEtK5VEHLr9BeoXQZAMs6H634e7dH35IyCXH13ld/yux4FCJ689orW8NksQY7nHgng2WgCRXPdXaev0CT1u0uojYpJX6JZMTiWsHGAiCiHjC1TPiEbxbX/87vy8SQlvWaFSxmPmuIq1EDLDzQkbUg+YInY2Ld6o+k8kiLdlnJvaFPnQYGbmoGhiLdwqMmGOh39HcVIPRR1BeNd4GwXmFIkwb1wHm1ungefN657yBxW9e4ZcvAe1oWKsCCs5fd1XL4i0dew1j19+UZCAt3z8UH+j80rskoBYLv+YhMffMAFpl80eHgHXOrgg9vGp9t0i/aQmvJeFlAvQ8r79jgOaVuVc++rNZQjcc8NpksPxEPZF1eOXhW0K5AVYoDR13yFPqZfG/ofkF/amFZ/o7JU7KAV43/qlhvZCWuH4PwK9SjgFl2No8Vi8aaUjYCGZ35zxYLP4R5Fpn1/dFIxzF38ew6JNNXKOOVlHHzI0le0F6ieW8T9ZBHt07HQsTOQqqW6XnMmB5MI4WPuG6bcqWwr7yh9W6iNtJ5a37sX/0ihAPoltqOxsasRQDHSXXGSmLbLoFkocmJW86AmxqN8f24DTrvjQU+9lOnxpvZAvnf4QxLO6i6V+6m4FRcmT/wk+u18T+pINuxpEpsdierwWPATQ+i+YEbbXs5fIUBizMAcR3D5CS/7IJAz2V2MYddiDRAjS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 23 Nov 2026, at 11:32, Usama Arif wrote:

> smaps_pmd_entry() dereferences the pmd pointer six times. Read it once
> into a local with pmdp_get(), the way smaps_pte_entry() already does
> with ptep_get(), so that every test sees the same value.
>
> No functional change intended.
>
> Suggested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  fs/proc/task_mmu.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
Makes sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

