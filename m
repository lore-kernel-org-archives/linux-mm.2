Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49DAFCCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:30:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B584C6B0093; Wed, 29 Apr 2026 11:30:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F9E6B0095; Wed, 29 Apr 2026 11:30:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1E946B0096; Wed, 29 Apr 2026 11:30:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 918656B0093
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:30:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB813A034A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:30:43 +0000 (UTC)
X-FDA: 84711980766.28.FF8FCEE
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011060.outbound.protection.outlook.com [40.107.208.60])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8FD28120013
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:30:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kN6jsFbg;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777476640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wFchUM7QX4VXW89gRfZEkKRr8wffG2akKfynjCS3YMo=;
	b=CQqlhP2x/EsUxVn2DN7WL3tz8vnk0792KRaf9JvVH86FxCTCM4ChTvEtxdWHWzwFdECgBZ
	iCfh2oDeORvnVn0SVAhicOr20D35zIkm4vw/ZTLlb2rNPmwHPB7etP2/Ah2RVh4xwG1Ai7
	sAN+nA6RhFxSasI3ZxL0Ib7bKXEAvQg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kN6jsFbg;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777476640; a=rsa-sha256;
	cv=pass;
	b=iewoRwWa02pyIYrzYv+7aE59mwcllMk8bZa2EWNzxJtsb4l7/WBXc0jaVGVzcBpANpwl/K
	5eRvgN+SPvpZza5gHdyWlYJSZuRZXfNFHLzrsw/+iCVGRqzp+6PUPY7yGm5rGh1JR5lebD
	b0VZaYRh71S5WVakvxel0V4L3NBjGvE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AAylOUSsOaom2NUDzeV4TnOhl23Yv8Sk3XXOvJHZi4MlfMmhg/jLhVdUlKTZwJQqoG7jqCwUy/IXMqxShMu0/cwv/T8ckR8ve1BHi/mgDCu81l/7B713PdeldXBpfQvgdiig8CydgrMWMdh6/pHkGjOvhla9xTSncuXJc9KeJ1bdfY0WhJYZGI6JNyOFeIOYM//3hg/0/bjLUi3FU6zoL5ZJHS210vxosSmhLqzvV4aHCMu4y9s4udRdhUhVi+9VAXk2gDSTx0ka+dWFD2i0o3q6XvZ8Dq/pvA8TR075Pm5t/C+0v5pt/MtdCEmn0WU18Cb2PaHmQaBO/FC0t0vE8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFchUM7QX4VXW89gRfZEkKRr8wffG2akKfynjCS3YMo=;
 b=TtleL1+cwfQtJTcxSf+3pKng3CnZ/VGBndWLh3ZQNZJZ72vmDW792mBDxDggM3PUZGSjUMiITkfGyIushPhr8sK4mZt6UzCCFSF6ANox4uSd8sdkXYChKHhG5fhIVttlSsDvIuHB/F8LPizuKabM+c5w0U2zKbeqrWzX4P6QwJf4EkZE1bUS2t6uAlzTbWzKOvD3MlWl5a6/yfQ3d0apkRbOS4nbzjLyiE+mnSsEiZtYy3HlPi4i6UYPRPNJRzutTYr/fqvxM/FaYhamI8TjYeTVZ0qUumyorO1EZSO+lnpXDOG0DYZBYAL9/6Uqx2wIBv6bRuyKX5es9q+lHFa3OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFchUM7QX4VXW89gRfZEkKRr8wffG2akKfynjCS3YMo=;
 b=kN6jsFbgDkmWTKfl1uAIYPvRRo1Mg+vkVTmvWx/75z1QjP2cyDIb1VT/UXBhjC9nvy1kNbBk4gdsAC+oIMmf05YnNMaA5XXxitNk5cCWP5+Z5jej5pWQxpW64g3xZ398pggwFiIbmCH1C6tmJn6a6oXOEuP8boBRPaLgvnn6bjvs/ZOhEwl9CXNT8ndna+Ff96pAvn4uixPmvK61CqKONwjh12MN0fE+Wet2Eyhf6JGcI9ipU4u6/JXGvRglSGnIK+SqPY3jMG19sA0S7bEYz61B5RZugOunYrfkMuajjGTBDq5QQ9FA1dWkQDDhgZgJFp0YzuIM1SGCofxAPpAqzQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PPF12042BF6F.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bc8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Wed, 29 Apr
 2026 15:30:15 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Wed, 29 Apr 2026
 15:30:15 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v5 03/14] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Wed, 29 Apr 2026 11:29:13 -0400
Message-ID: <20260429152924.727124-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429152924.727124-1-ziy@nvidia.com>
References: <20260429152924.727124-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR07CA0127.namprd07.prod.outlook.com
 (2603:10b6:5:330::28) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PPF12042BF6F:EE_
X-MS-Office365-Filtering-Correlation-Id: dffb3afd-2e47-4a3f-4fdc-08dea604363a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bxMoqum+d0s+JTQT/tFbwo06enrAoWAe7cefJVpaA7c8kJGNWUfoHgb4t9mcbppoXJkr3FE+Man0oHs1PCVBX97X4wg0OsZ1dFkVNdBoaLCGZQIJAt+sfnMByGIK29H4rQWWkoCYEsiX0pZPx4k+rWzNaS0cDKgeUCmi6Arwxbnhyq+anjnKXLs7syRpNDyha8tqObinkNtm6bEnREjjG25GzrfQxpVMA1PBgHkD/hfpKcZiFx4m8sSsblkpgTBIOEn83bIX6pWi60Kgoj+cDYEGeyCwZ4siasaoC4n74gpLpSyYNFq2WxvsbBDq52zr3rq8AhgDoy5u0wE3OQyF9L8LkUA1wF0bfPBtLIEuu9ci0//9hX4CB10Mq4bE49hyRKf4ZdM6FjUecmZV4Uu8MgM3r9TRhrnfznau2rOsKjlxzMG3CBOeIoF0lqeI/LYIDGlv3jNFzdBewThqcds2tsqCh3kgw+1flDKK9nark+dobp3jj4Xj0ctiIuu8jvKQ1n+kWJ58vayl1P3FKgwWN3ARxxCK7uy6tM42dL8+q+KO7fs3cZHcVrjvisYBzPKHtaIYU7ybUtTv+2P4bA5ZlgUYyPdbo7N1UqD3nWLnDt+KqEVINDMIj9JoFOUkuycWjQrp9ZA7H9UMX+GsNUZG9fnNGZPzzDxvobTIxJnytxIETInrjtrTb5CqibsOhlTPGFCFY6fdQamzTTS/4k9mkoWa0P+Ru747GCk4xZV4fkM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bPMNR48vYuMiKpMbJQTkXuIQz0FYdjBi8k2uL6Xv6Us1E+OBPGicKBUJjmD1?=
 =?us-ascii?Q?BnFJclFZXEfwaYJz3C+Py6bCGlRX3x+9V/f2lRIZ9IXfw99PUuSWMJBW3RpN?=
 =?us-ascii?Q?efdLhUlqZAtYX5NjFfZ+8wiHeNGzNEGcLmrSkzjnaTVwKF29hK25mupQeR5h?=
 =?us-ascii?Q?W/Dm5Q8nFuPNSPYFecEYjbyHnkdA7SD1MFgcbw7Odkuvbrd7oxFQVJ8++BzK?=
 =?us-ascii?Q?mHg+AlEJtL5mbfSXpHoeArMz8NXgaWrjFCt59xmLvzCOx3cLdc47fxihejC0?=
 =?us-ascii?Q?uB6Lg1wicxv4Q7s7wACOgh7hyd1ntwvgS3zU9+ydAa8tt0zOJg2rRMjBKdBG?=
 =?us-ascii?Q?/oZpdBdxOUMa7eKmapylEKet0r4xHWL8ZyYpL2ZP6PZNzYXo7ILfGpzyr/bb?=
 =?us-ascii?Q?i5kABhoYi4mkjjsaGDPvsVJfig4fsARcPnD7cbD7d7yt63232ozA7VQbdt9o?=
 =?us-ascii?Q?9c9gdgyHU/mB9DR1TzveyqnS+2ZueSWF74prTeLO6RSFL30exVZIvIFzPo7z?=
 =?us-ascii?Q?cy3GpFdeEYRXEijck37irorCBKeY+zSmRLE1HU3cI8UAysWUi8U0ipm5kPQG?=
 =?us-ascii?Q?yqay6Jw7MWHE/UaK/CTD7NaVPqfaQPxcINeMWn41Y+CCPQ1BNhEu3LM0ZjzH?=
 =?us-ascii?Q?rnxi96ZhTTYsDqm7XfDD5QR0qVpHud5UjNzL3+6kMRv/RIOJNH/wKyLAI/Eo?=
 =?us-ascii?Q?z2/vlOcJlmFLdjJbprhLrs3IeiudopgH0eawHg63zl1qsMPsuh7j4HFfZof4?=
 =?us-ascii?Q?24DSOBWhML/EjWK5MCHodIzM6cMtMKDckRBrGFndJTcN/vEPbIrf0QequZPC?=
 =?us-ascii?Q?X6hq0Sivt6r5Ap5VHBDVIpfGwYhMC1jVmpAOJ1IS61eDbkoPKV28UXTf/FS+?=
 =?us-ascii?Q?5ZK/Kkua/TArGPPvd2CLr1/w5xxB/AsdBaW8BZ8p06+alPumcppJkqEantH2?=
 =?us-ascii?Q?XM25mn1DWpOcBGNeD5emHQSRVTtVYMul0vPRGy4c82ndaU3+R0ohoePuhHLB?=
 =?us-ascii?Q?1nE1BQ8FFjP1zWparfPYdzhcvWEz1hkmIECgHaAyb13aD0yllRs17qILptlt?=
 =?us-ascii?Q?NPTy2Fsbjp3iyNBMJokR5X6qk6Cy3PWP7eBMqRTr1nQ+v8ZoHIIL0vqaOnx8?=
 =?us-ascii?Q?EHTp+dyhz5EAAMioaY8OJMv9u672J/e4A03wzwbpXE0rXU0r1EWDnQc5VoF6?=
 =?us-ascii?Q?5uqDCtAycBmg+r/Jr0HS0Rc2m9geX7FqRgis+oDhYHJDLSTTenvmDiKY0eJL?=
 =?us-ascii?Q?WPhWI+8MFp6TD9EtOZ/X3HkHpNjXuoHS7kuAnyUKWqtEwlL6ktD77l8DG2uD?=
 =?us-ascii?Q?3awYNt50JLTBVEuQS6HOawbi3oNBNR0kueRRW31rJCcvvxe088nqQFccJIj8?=
 =?us-ascii?Q?0U6AX13KnkE0l+Fjj5APGTWvJOxIGcpov8b2Zuq7ccIS9vGGTB5fRIt6oXNG?=
 =?us-ascii?Q?wUvZEEG0x8mFei/mtRTSC8egyzdUdzcuZeWJ8AKXTrSPFBgI2OsM8a3hhBa/?=
 =?us-ascii?Q?A2csHuyuFVCLKEfu3NNkSR6cH5XOLJ6XY9KEdhgBwbeFsfCGRMu5JcRSlVzH?=
 =?us-ascii?Q?zDJToX4bFBCcl4nUyy5VBy3psTpInl0/BAM9N7YdH5xAWPOZ52n0Ng20YjKr?=
 =?us-ascii?Q?Y8aLaCY1imsCWvDY1e1sXq4rB896Tl9Usk7hkGFkur87qI58axs8dtutMKxw?=
 =?us-ascii?Q?o4a9dd9KAu1J5Y7zpWqIic0bl98FdyoVebPbWzUPFBZXD5l6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dffb3afd-2e47-4a3f-4fdc-08dea604363a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2026 15:30:15.4492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DV+eaws54vY0pWPOVcFLqbriDEjNmTlC21omGhCtioc7XgTd/iH4quXlWlMhvile
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF12042BF6F
X-Stat-Signature: 8bttshz6ykwyj5c6c9f9nz9c54adgofh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8FD28120013
X-Rspam-User: 
X-HE-Tag: 1777476640-712375
X-HE-Meta: U2FsdGVkX1/gwwaIoh7lKlMfSlTlQCb8MsUmK6Ca7hWNJtrdhip/H+1vZHyTbFG7lpVvVTtBin+Het3nLPo17B4a6mZrv07pGam6y9Yur2KHjSI2lZRZ8zdk8uzpe1yXluYL4y5QtSIJx1gjLyEuhyZHTRn6V0Ce8dwQBA4UdtLNbtLnZ2VbbNv67GQ8wSUm8HuTz5uzeFCZqy0tNzvYMESM9MVR+EaZfpqGmaLXUCvXg3mkbb4/zt9CNZ+uafY1TX3zUcYudLIypUIIYoDrdpk7gAuMLSJvcbqeEEkgZrJKj4LB8vkMvhwyiyzPgbQwf8/uXlSh7j4KinSoecmAk/BVujFjpqqSHMl1GH3PWSSOgg0tL/M44ROhVBwHzAkBCgBY6xE86VruO/VYGEfR2Ai5YdvkuAGGpEL0Gfz4FAu/uxtbzyvEvi7SiiIRt5QCnFDTqtTUTDXhGiWz1Q70qFy96r3HUKocByid0QF5dKL0FoxIVS28uEKH4mbA1OMerAHfvAvN7SP/xSFF0Dj4MS4VnWDQP8RTq5XDzsx2DOUARLqeggStTncoIr/EEBuCETrVumSvPK1nEPlUM8OUsGTLUzAk8MmV3edSr5UFFR1OzhuYlfzinf4qh5vO2VH8r4QimcEjr6oiXjVxKsvH3UTWdL+KqzGSmryeZpP1YjI/bJmVdMYXkP3PwwCGuRb51BJJKjXdpuJqoURqZaN+8NsTVFYAy6kDRePaddhuE54BP0/XbJsrOfFjeHJ2Vv7JhByaDfKi+F0y3/EtO62ecPQNnTaWaIKdOeU3YdlkTfHUczxucCnGhf/oyviuvG7y8IWuvQfzbC0TOmEflalrJ39CdgLGC/tUqHawPcCmhCMZHqIhTBX1qVVk2qp9zsOB2UQ6Q+riCqv4pw2SReMHnVAsVIeYHTx+8DcvonKw0g7GqYf7gxCRbuayimEt2yurRplCbkg2rtlWdBqPtTn
 5TF8+1Et
 50op6xJyhmmldN8E5dH/hpOe7UfXaxXsZE6q9pCPtJofKIuRvuvJ1rwUWI9B+RAlTG95xBK33fMNZ9aXgJKRsLSvSIO2PoMWTIhm8e6s/V+1cQ2MJyW/al67NYJMMbzmL8SEcZCNo9HcbhJdHR+I8LOJSb0GLijklolHeEoQvNNS0EOE+0b/E11qNifgLreAi2qd/hNdKgoPmS2kej2mPnxwGI3/YAicHnI8oEJqFuy3KVx1pSabZp5lzf2lsJN0W639AILxxHOo6LoAfs2ZwJn9djWVz5H8lOhdU0zCchnctSSSjPq443fNzgSeeGNjmpM9CE3MwXvC85ORSGdkXqys09UPArOy4bKAdF8xqyydjePIJo4pOQv/4yP5vPXQbf+acYnpJCcmNNg36wZbolPrHB5rSi3PxCz3c5omxd84ca+3sCvx9NW9DlJaBjhDZroJKbEUmv7dSKm5TKnK79fEAfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace it with a check on the max folio order of the file's address space
mapping, making sure PMD folio is supported. Keep the inode open-for-write
check, since even if collapse_file() now makes sure all to-be-collapsed
folios are clean and the created PMD file THP can be handled by FSes
properly, the filemap_flush() could perform undesirable write back.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2f3fcb4dd1ef8..3b324f03e9283 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -86,9 +86,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 {
 	struct inode *inode;
 
-	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
-		return false;
-
 	if (!vma->vm_file)
 		return false;
 
@@ -97,6 +94,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 	if (IS_ANON_FILE(inode))
 		return false;
 
+	if (!mapping_pmd_folio_support(vma->vm_file->f_mapping))
+		return false;
+
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
-- 
2.53.0


