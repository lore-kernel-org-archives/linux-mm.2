Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83237C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 838376B00AF; Mon, 21 Sep 2026 11:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80F566B00B9; Mon, 21 Sep 2026 11:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FE1F6B00C5; Mon, 21 Sep 2026 11:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4972D6B00AF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:32:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDDAE80137
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:32:23 +0000 (UTC)
X-FDA: 85238160966.20.1A4EFC9
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010066.outbound.protection.outlook.com [52.101.61.66])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0D82B120002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:32:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="g6vpwVn/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790004741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZjEKgc3Yu8PIEmMN0Z1cauU2nv9v9VMk97Vtp/i5W0=;
	b=dSkVYB5WKtH7nD2/Szzltkjw8yxkau/H3EVCoCtor8Vow6sbalcGJRppj9teCm0Oe6H8YD
	hsdX5JRBWteIxU+bVcx3pF5GpF0JY51/3i2WavQyHtjmmzr4MnnTSfFWmtQEJ1Hfb0eMqm
	8dD8HtCaKUtYvAD3kgeTxsB7hTZDjwo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790004741;
	b=7LKvuMMTu13V74FUSGnREJMq/RBU4ttsjyHqqfT4cbHzr5u15dhImxxiSuUxcFT2hNKfZT
	ZzlLlPeOwDA4UeQzpH8k6yhEGFSjKbutG23FjfgZoKtsQfIpQVAfPPk3nMzxgV0pkJmDBH
	bNjp8i9tDWnY6UQX30n06DVjDmP8ytE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="g6vpwVn/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OT6eL3eHekUNo2dUtwCPh43YouTqjrkflsHvibXPC643Myb6x4214AvnjTw/2/Hu+uVK3/SyhZ9BypMeL62ysGWQzEWvDlEoUMq0z8KzyWUrI76XVasSDWlqo2P0OnSnQdZVmojI8gA4exCEPU/LMi67V5Zb9tmZasb1gTU+8KCxMuST2ol43wMtMSdbQxnlk4O/3AVczhEILcthgCqt4OTtypL6AUNpQYZ0rYUKQdgEfmaYujeLX+gRyZRTqIKz6NT25rEgwwCDVnie4mK0EKobDnzCWfhavq3HFy+meXo9DLkcV6i7FgWTT+p75VSEEpH62gzXfo1zzwT3hqGT0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZjEKgc3Yu8PIEmMN0Z1cauU2nv9v9VMk97Vtp/i5W0=;
 b=mUKgWFvRGNohNaLCVkZE5EuixRzceG5bXt364oMeXncEjfyBpHWjFB4qZbIOH+U2M45WvjytXJQ7wZsm6R2upx3TUL8Yc9/gkGDRbrCyFZeKLA4GawtvYb8JIwEuhDxJh5ig45Gu45Dwxkhh4jqkmK7HDCNTLZAY1mOZSLVj9eAxNPNgYLheNL0dgPlnJe/oA3eRzg/kzUo29qB0i30X0YZdeFxtRF9rEJ05iRniGiKTU2DCMlCrQ3dJKrxUIX5kB6JxPWO7HoYZ+HVZGgdGSaKwkO1eS+9DNTUxnFIRj7YansfNPxHodlK8PFr0QeCYlrcgDh8koN0shRkHUY8cdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZjEKgc3Yu8PIEmMN0Z1cauU2nv9v9VMk97Vtp/i5W0=;
 b=g6vpwVn/BCbqHrCpVZJhnWOH6wh/prjNUk/Lgo6Dd+ThPT40ly5gXH5k+lCXzRxaMyLRslKb5JLoDqhXhAZgXIs4mxr/5B+3HXC+w77CwEUPhNy6j7dDThkHwyCvAE82VkTSjsQatS0STn65HQRAzB0+K2A3289ASW2vEaOdE6eSYXZWMp72D+98OieAEi+EUwFioLwsSfS4HuHMeyznvGEgNEsa2KaRHTuhB08BFDhf/wIfvd1VcNDJNv+JghHMA1CZzs4N8So+AZ9VhvMO2Xuy6GQ7+MIMwO86tGlMaQs6YQSwqcVEoF3L8QwxuWbJ/1pY9WTKl6h2y80skf6ZEA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH9PR12MB995114.namprd12.prod.outlook.com (2603:10b6:510:426::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 15:32:05 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 15:32:04 +0000
From: Zi Yan <ziy@nvidia.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v4 3/3] kselftest: mm: introduce size_to_shift() helper
Date: Mon, 21 Sep 2026 11:32:02 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <7F0BAD51-7A2B-45BE-A773-6C781AB6DCFD@nvidia.com>
In-Reply-To: <20260921-fix_hpage_macro-v4-3-cdea4fc6ce3f@arm.com>
References: <20260921-fix_hpage_macro-v4-0-cdea4fc6ce3f@arm.com>
 <20260921-fix_hpage_macro-v4-3-cdea4fc6ce3f@arm.com>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0131.namprd03.prod.outlook.com
 (2603:10b6:408:fe::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH9PR12MB995114:EE_
X-MS-Office365-Filtering-Correlation-Id: bd0a0ab0-8836-4ba7-13a5-08df17f57d55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|10067099003|6133799003|11063799006|18002099003|22082099003|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	XJMs5O/1WLhXbelYktGH4dCyEfCA/p0UGImZU6hS1o30cAnFWvUhHWqtwwc2BopTVkoHwOLx4X2qwR5cda4+9pO5hJtp0uto69YTR5xyqkkXS71ZLVaJ3SIOtE+v900NWZDtlCy2DX2OGPiebY5zU0xvF1msfOZo+Uz8U6qfmNzNfA/AkW5q6u8WR3nScckHE+KJlnxf1G8cDeyEid0xX3Whm9eyvApoDX5qj5sIBECbyMkwXHuXqcTBKZ1Qml/qEBd8UsHbgniwaPx459bGBmkE+e9vvaa2x9XMwN08cffnpAMJ1GFRbycVwbMHlPfLbYqQTIWRyjXnbwcWRmVWENNMPleXecFx2N1lGw7loTd3Khqlm/1UotzVj/tAIz525LfLcctfuxt4q3wK+1zmK3RQG1fkEVmqdscZTMGqafj2Jh7ROCSucsTx2KKleSdtyoLiOX4RSyBwUC0suyKGLKBCTgRokBSHuNJr1+Z/Eh4pa1z5TQ1i3Xl7jw58fKDkcIE6BEeNMvsriwvDKn99Qb6WaNicmXAcStKvDXZozKPBsaCrCiJeZR0cjl8BpqT12mjN79w69DNTWTwqzbK9Vjiq/EuzcqRcwAWJMs3yHuzDTr6ykDWMCP4rbUWeRApH/+naDlykqVraDfNM6JohJ3QdRfk5VZUB4yR7BId/+zk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(10067099003)(6133799003)(11063799006)(18002099003)(22082099003)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dL8ebBXeJdnxGBsBwVQKeIrKxJayt4R+2drMZbBaMmYA3rfkfNFlutKPttSs?=
 =?us-ascii?Q?IwlE4axiIt8/PGui89S0uCNO3hT10ZLgp7ObE3vC2jyYFezgSmYLQ3+jp+jy?=
 =?us-ascii?Q?GvURKisQsI+EbccYXNFSsysfC5PTVSgRLx3WOeNc9sGR0/Me53srTDdaaW+k?=
 =?us-ascii?Q?NuhTrQAV4rrfRRAqWCapJxBxWhzIBOq3jKQmMIp2FZPoM8OPOzAX3E/jA19P?=
 =?us-ascii?Q?s3Pcq8JhU9OUMjaX4RO8UkS76N7xVTOEpbwe1OoUkWGQvq69VuEpCiwWiic+?=
 =?us-ascii?Q?yIUcfW4RP9hPlxZFWrBLLFMQFzPJXcVSqaMLRJ6kyLkUjvI7H5SWcrGRyY/6?=
 =?us-ascii?Q?OjOKrjW1Wv+10yjysJuUCDPL/GA3vAExj3CAPPLp/eFF59S7wtKaSr5aHz1b?=
 =?us-ascii?Q?+MZoHvKF3u5PEpN0S7fsdiB57JQFjGp6efjToCcxGcBsP0mizRr3e71y5jlV?=
 =?us-ascii?Q?RNB0WvORpa9+uDPZXKv7bDfVAB2tfAhfsuR97x3QodryLgPn/nEo0TH0ogAO?=
 =?us-ascii?Q?wQz+t0MA8rXQD+7WTibnfC/XxKbJDdXouVdrqkeMcRAnafgvCbliYAMMmuNR?=
 =?us-ascii?Q?bLhhEhadWS1y60ukraLG+nR2zbsUhmJ56akAXfFbg8bRp1B1/ro/zhsF2IhL?=
 =?us-ascii?Q?VNTWhSfM+mHid5nM2fSncF7SIYQZR33becfpNPmlWqzfbY/Bm8esMnTc7oAI?=
 =?us-ascii?Q?GGFrvvXXTvE4NSi31fpazt0FZ72alwarpOm8vIPovp9pkcAX+SH+prui54Vc?=
 =?us-ascii?Q?JOUSbq5vA4xYFth5V1E1a9ZUkCr1J51GMU09KQ8GULVcxLkZLJ3T7yUbfEmU?=
 =?us-ascii?Q?TZTJFfK0UEO9cgKUDZeeRaRY6WEkOBYjJZbE48Mx21Ld8miC5iD1ftwF08Vq?=
 =?us-ascii?Q?E+0FRvcCCNe78YKnmwq+nY/Cs37SVpQGlwkj0SLnz7xRmaR0Vn8dtlP3vaKm?=
 =?us-ascii?Q?AtMfuEJEHiBKWv9OlzJZnGh4774gdTJJ6ecEXi/wGzy8s9ORkMAfJGsLX25A?=
 =?us-ascii?Q?dk3uGQbnTtLSpJpj7bGxH0H32+HE1ZUjgJ71l1Wd3gNA6UYXir0vUFbu8X1t?=
 =?us-ascii?Q?wMrgI+GwLcHMxQtY3fd0QOc3YicMkkCPoSGk/UzHOybpoRIH+beJ6Zzi9G2o?=
 =?us-ascii?Q?JKRwen8EleVr3Ach0B35k6Gkmg0xK/7ao0hu82zpbScXma1Q3m2vU+sfB4rM?=
 =?us-ascii?Q?x1DVpl269JWM+emJ/RDPBffTqn4bEBT/oDPn42oILzhjEAop6c1T1gK0ZRPM?=
 =?us-ascii?Q?gq/O10b2pq1H6oIYUDAihDOoC0/tOTvbOqqhzMVz+/nHGHsUeRZxU7ZGzwT5?=
 =?us-ascii?Q?JAS93Lf5xBXMhzetCABDlcRvbgXWS7Hoy7sxPJJHieNf4Q6ildmyxUnnVzPy?=
 =?us-ascii?Q?KwfAHBmp/Yt/hhA8LTwAPxinpX5znwVeLkLUtpLMQ5P+h/90RdtlEjNN6VDL?=
 =?us-ascii?Q?cuyYOiT46bsnRj8S/qT5fuZlP/2JIuIrV5jMTLqUKesZRy6TiutFmYFlJHxW?=
 =?us-ascii?Q?3J6ErL0xP2wUGOmaMnjVgHwJN+7zuZVc8oLYeF5kXN2eb/SesTKjEWBkKWwc?=
 =?us-ascii?Q?8ICAwGWAiNgjlNLyUIqYTdqm0v+yoXp6BLbmHuAGJsUvdSkSAluoDebpowQB?=
 =?us-ascii?Q?C7ami5Zk/KKWwMalJobPSzy6Qb0T3Q/kANHehwpneypivO3bc7I73DDAqh1p?=
 =?us-ascii?Q?esqJFNtionLWjRPeWRgxLpHYzKeOLNFLB2DPMjrL0RvN3/3eyoKnm/fUDgW/?=
 =?us-ascii?Q?HMFnZDvjyQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd0a0ab0-8836-4ba7-13a5-08df17f57d55
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 15:32:04.8496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mV0t6xGcIU2EGt07EL+cHT1CJHSlDaGWqphnCKkkjfs2eYAwVx5Ts3hV9w0AbRco
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH9PR12MB995114
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0D82B120002
X-Stat-Signature: jxuwnjm3mjk8eax7in8h5gcgnwj1scn3
X-HE-Tag: 1790004740-452119
X-HE-Meta: U2FsdGVkX1/caDQxFzA+SrOvaHnYF2xiYX3nR7wRFFPdWoU1kild3oH+mQTRIfhxNCO5cBTCdlBwC7yJW2KBk3F1BZAWB5aGM4eKEx1fGd5zcTePjSwug+OuL2m+yNgNFL6yTsZ6CC3Tc11W9EgS/l2QMitd4ibr9gOebpsvWD4ekL1nDlJxMYIBMM71tj2evWqyD3VrQjy+7tV/GdJEvi+qXb79O2mszuWdWhJIib0sVzFuIiAoH0Sbu5Dph1PuXqfHP4gujO/bke+l7jJ7tvtcXHBC9CKadlF7uZKoa30z8GZ3Us2oXKhtdB4uGkDZwbmlrCXYu1FJAyKjcuGF1Y/qVaZyC9oVlaR3WfnbE3cJihS48O8hMwAplS3a+NQNqcsR+jDW8vcRnq+Z7uaraL3OhGbbyqiirCvvmCDoMgtxJgSgGkNtWURUjaExUPKh9H97RBSvhxn9GM0pxsZc7BLVE4i5jx1ik+K+Qa0VF+uUrItCNo6zOax118hXSqmn27w2N/oFEPsKCTStdFnuC1QYJAK+GQbrNKDCGPBo5HSxvFar5+NGJ47DX95H5XVR0nRseGHksBlwe7dYDeuhhXDDGTOxHUwwEcoGmo20rnXuGVxxnD3d39k7UPy17xcTozkTyYl4RrVNvNHoN1piKqUnfqmAaPTa1xDO1x2eCW/DUKz1hpMhEKL/W3ZAfYg507KmQ9pFjDuQERNOIcHMafqF/lUeX/50h3yyaxVUC+N8m96bcBW08ZpdyVTpXieZP3ctsJEk0sSQahh2YXdlDLbZzynD92CO4bC3DlV8bzUQdVRRfXp83pLenDnNOaPiCdJQK9IRURI6GPwDdKuDJucJETIzFNWkErAUNCSCDe0JCnh6409Azyq5YbX0mLSQCYRJF0BMzLdt/zlV0eUWB+Bt4nsDuXnebQoTw27oeg+i7fvnFULAXqCOcCL6kM1/VnNix1g+ZKf9oUkpRR0
 8dnJpjY8
 KSAtFbT+z4jV0STuwLVt+ceR7PtJDd7Gkf8gcEYTNaHuJd57aRjaR67XwGhu/srx1eIW+w+ND2WVeu5zrCZr5OFy6fsmk3BNwGAYeNUReiwWllCtrkLQ0I0X5zWMoOZ4I0rKc9RieBiWgGh71cyLp6uZfRX9MiTkpMV+VsCYVdk0IGqVLdYfm5NoAwtOxCq3CvOoCKP+m2DExK+6EMOLBibWm9WuQZJxiN0FHOFuqWd9ZMntx9EXO5TarWeKDT2v6PNRJV4cmWp+VVPrbM+mXu37p1ER0PxO9/xnCvG9/a+mVlWIzy6Pf9ofOPH+VJZc9FEBf8sV8yfoJksFzmaZy/Aus3uZ+1DUAdXVq12YulRZAznzUiTLzvI+ci/l1VNB5APAqvdb+2NXpoqluy01o4+ZD5laSsRj66F4R+QTwSM9k8XmQW8R2rLVSCFx50C1tMr1/lkGPrL1IMRn6upW485HkvzGu9vSgOkvehPcaKWyWpopR6Kn1uMgkHml0ihohUVOiokaaNCtIAOE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Sep 2026, at 6:36, Yeoreum Yun wrote:

> Introduce size_to_shift() for future users that need to
> obtain shift of a huge-page which is other than pmd_psize().
>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/vm_util.c |  2 +-
>  tools/testing/selftests/mm/vm_util.h | 12 ++++++++++++
>  2 files changed, 13 insertions(+), 1 deletion(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

