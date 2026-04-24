Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 218EFFED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BD606B008C; Fri, 24 Apr 2026 15:12:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894E56B0092; Fri, 24 Apr 2026 15:12:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AB226B0093; Fri, 24 Apr 2026 15:12:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1896B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:12:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 176CF402DD
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:12:50 +0000 (UTC)
X-FDA: 84694396500.02.F3E2BB0
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010045.outbound.protection.outlook.com [52.101.46.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1EFC21C0002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:12:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="f4/l4ccp";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777057966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfvT9qMO9HLsSIyfsAHGzBznY2dUiW47YQRXzjvATqI=;
	b=meIpb9loLIqez5M6ZEMRjA35jfDKcEyT1b87SZySeekfO5RYvkSUv9voYCdcGNG4spmsPw
	zFcSGgWvUEZU/Lt+9wkvfi96QWCxmFOBNvfjNfn/B7HJrtpKF1maCLgl5qoe7w0ynjgMy2
	n1Ylngc27JxvvckT3/KPkJYSm3t3sdw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777057966; a=rsa-sha256;
	cv=pass;
	b=VIZzz/BCzWYdo0G3XXIqQxDH/w0pz2LhidtE8aheuduyVUjINIG9hPWdHNiV/O1JGvmKQd
	IQwxmsKkzpapSDMu5sIWugDtXeO9u7XIjoTMw5wylFqmppJF3SKmNeFy3bVxkL5H5eb+LW
	YOKR2g6MP1yHx5f7Ct09Fo1Mdohl+KM=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="f4/l4ccp";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rdt2+X5daCYF36zgNTgCpnGfLLdCWO2MzWwm8H2LFCfkWyXzyDen9aLG1AM4Hnztw8EMp296N+RrqhjmElF3FsmDDEjJdqUZgEIG/JXPwXKJXO2k3TvBnGgYOUPjdApGrFMJxhym/++6+vpMBUsOqsy2LkD9FmMNSbj2oZxI/zFhvy8TVe2g79RcUceY8lebSMbuQhUnASn0Qywje66bBCX8/GoZr/Rs/F/xH762nxkh+WZeWzgvO1MxIO2gvoA5q0+1poutinJoIU98YQ6ZExJDWuC9i8QC+8zLh1J36xE5CWHyiJX3qF6m1+VXtW/xPJoPOLJxKjjM35UOS+FECw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfvT9qMO9HLsSIyfsAHGzBznY2dUiW47YQRXzjvATqI=;
 b=yN1j8QUfUttn8J9LZYN/dg9adMzaqKnixjOxsOcoixzPca+vq+xtuRtvM4Mvv33u9qEXgLZde8tP+B9eUxOa907sfvIzojGr0Yo/ffwm1hDdUEB7iTUGu3SMh17ehppfuJljfazKzYFd9nEH1m84CDipQsOr/bG9jLvhfih61EpIeuL6cQxC1QpIiX9xjD3RGp0/zz/DO0xx/K3jwcR9t5n+w8auQmTUQS0SzSgk4yITBCvwremNHUxE5rO/p4scV8XZ6NeMVtKIXzOgj2BUXG+TotziP5gVRLpoJeGWlIk8B8UTTlPUuKFb6lnILYICi0U5TJFL5NQYxcaKvSaTNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfvT9qMO9HLsSIyfsAHGzBznY2dUiW47YQRXzjvATqI=;
 b=f4/l4ccp5I0tFK8WJ0rFHiajHWGteUobdPhrsjMYygzmkhO13KEQItEZI+BncvFlOOoxRmcpu1hDZ27rAibWBMSqlr5DDyjC6T1iroLWtnZ1yV9jpvaeHjVPUF6SZOydTFVA9W7rC8/K4+oGob50kV7dborR36jZIupadh+GjA8ItGe0fYg2c8AVBelQiKuuN/9vDIw8LLM7s0dGxo/MWZAlZlNCf5ybgh1Ib0OYHidahvgohsrp8cMiRXE3lS2LQQ9bwN53I8zUlEGSOurMn99ZwK2mH1AAG2ySqQRWs6rnTjKIT0iAFgtTbCgsZWCQ2lNtO5luHzRlwqMLJ6+pkg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4063.namprd12.prod.outlook.com (2603:10b6:208:1dc::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.22; Fri, 24 Apr 2026 19:12:38 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 19:12:38 +0000
From: Zi Yan <ziy@nvidia.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yosry Ahmed <yosry@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Lance Yang <lance.yang@linux.dev>, dave.hansen@intel.com,
 dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, ljs@kernel.org, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, shy828301@gmail.com, riel@surriel.com,
 jannh@google.com, jgross@suse.com, seanjc@google.com, pbonzini@redhat.com,
 boris.ostrovsky@oracle.com, virtualization@lists.linux.dev,
 kvm@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com, roman.gushchin@linux.dev
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush sent
 them
Date: Fri, 24 Apr 2026 15:12:34 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <E375C69C-557E-44EB-9B3C-618C9F7BA9D8@nvidia.com>
In-Reply-To: <20260424190141.GA3783056@noisy.programming.kicks-ass.net>
References: <20260424062528.71951-1-lance.yang@linux.dev>
 <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
 <aetw4aoABYj3keMh@plex>
 <20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
 <80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
 <20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
 <644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org>
 <CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
 <20260424190141.GA3783056@noisy.programming.kicks-ass.net>
Content-Type: text/plain
X-ClientProxiedBy: MN0PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:208:52d::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4063:EE_
X-MS-Office365-Filtering-Correlation-Id: ff26da72-15cf-4117-3d7d-08dea2357344
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	R50WZZiKmjCxTGYCFGM5Hrxjk41Dvj4iSkHEbBcrXVQFhxvvHDbgX/us4fdK7xUyiXff01qdROxSgvV7TsUl5u/KDgavLOkVywFlavlqWOpoPnt616q4vfQ3gVlfP6tHOiK6mdbO5L9fKJ3Fc2KBzCijg/hbKZMqfpSimcVqieFxsf/drljfxLXQB+1jfMiRsN0V01Y6gFb/3+clxmUFZWftSL6HZPqJrWkw5+Cml7cyrGaPZe/TvEGS38fMdC7LzoA98o0X+wAB/YNtJlTw2wMvrboONt327+j0EPd971Qupn5mR0+UUqfDLkz5NFFnX4eH42pR9vVr2wTah8kUa/yUsJPpDumF0bAQ22ooAri6qd+h2rWYATZ8pqgIPSGC+JGKHKaOXzEYFCTcr7LJVL9ITjq2U05zh1KXlaczCjuSOtVpnoCnHcaSpPi/dTegPS5s3n9ktQCzrbs9wk01CPoTKnd4C8XyOcgQ5lUP+j7tjm3/8KoIrkmFq7GBzFeNzEyGsuRWX17rveZSE6j7B1wZHXxaiuq6K2pcKtUNnC2LUrru4zsWG+M5DTYnVU2AQjVeVkREV//xBUlWIGpqfjtV7u0ommtTp3Rbl2LqjdhxN440hzKBNWdJ4nlpmMbw0rZH6JF3sIAXHZ0IHltCbdkKsSzVYl7HAMtAVplhYHc99eVMywwXdRUQ8+0BaiOuyO2SYWm6+8axwhM/slqRvje4xVatgklUOhvXrtVCV1E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V1xgWr/WKiviu714CBg+egng3lVCnpkmDAc4bIJ7sgzVvNMRK9G+C/Ap8hzd?=
 =?us-ascii?Q?i+10LlZ+X/kFldZFWlJ7Lg332fm9hZFFqg8kW+VcYcDzZXHO5e1PcJf//Iyd?=
 =?us-ascii?Q?VBfZ63lwYMGAtLFatz45rqCfoV4G7J7/IR1cDCeaBWfMlHB3wlBYcAcZNNgJ?=
 =?us-ascii?Q?zIgGDsHQR3LrYPqeGBVefmgtw+KfLC6A+dpdgQ62EIJW5MC7JM7AjdbkOPY9?=
 =?us-ascii?Q?V4L94ea+OEGaM2Ae4LsNZLTyjbxW7rX101yWipn/UxjoZE9cZmnwNnkvLUgW?=
 =?us-ascii?Q?+QxxzPzxqDYKQy6ZOoOntdXV3YeCIf1SfgIV+TviTEFf8OhNrrqD3SwebjYN?=
 =?us-ascii?Q?kBdCLP/BRZVbRgXcqZrGXPS6LGzS5FfyiUpC3R8xw6zM0Nm7wR/KdVt+NaAg?=
 =?us-ascii?Q?2ctmR5e5Qx81VUII2fTu059HV7TjHk9+MbkzzWqlAEsg/buDyVB4EMegwfLh?=
 =?us-ascii?Q?iFs5hqZZayySpc0vlUbp1VCnS5oQbb8BuUMZZI1/E6MVjjmRcNeP1otz3+QF?=
 =?us-ascii?Q?88XpSv3/f87+QQoa/1CW6Kp2cSv2+zBXcsnzrunx3YU0gp08AzQgljFniutr?=
 =?us-ascii?Q?EsGFtb6TCmX0K4ow0Q1gUtk9GZbRj+T7vHt67n0gZuvCmLKmUByxj5zrtP9P?=
 =?us-ascii?Q?/InRiESbI8FlPqnA1cNTzbMRSWdFAwheGAluJD2e68KbyyQzUOTARmw9c2FO?=
 =?us-ascii?Q?guBALq3xbGIQ5slL+hKmt4rWPvlHxDc64StYYtcC011QmL6a4FB+zgighVH4?=
 =?us-ascii?Q?qMVKHlqzbAiDJPwwfOl6S83itewLLBXrEM+dcvJGjOWEu8+aWZgpHrwWWcoT?=
 =?us-ascii?Q?KkPVhPoQh0O6t9Y/aRX01FsjSjw0YwznEyVmluswQql12ywpJXJbIZDO+Mrw?=
 =?us-ascii?Q?m5NzWXoHWaIUDt0tmInJH0dFimHNcmoLkzEFARHIczbkwAfBIC1NVnLNRU49?=
 =?us-ascii?Q?bh206699ne4I6H6yFVdaCC+jwsdv7vsLxr++eGGhRmsRveLGG0pNBptMr8q0?=
 =?us-ascii?Q?PrFXFk67C0H7vlCbhEi2X9xqtJu3cTvZmDNToI/amKHiWT446tqGM/EpUAZv?=
 =?us-ascii?Q?k6/Ph3xBvieCRHh7/XgLAX1+E54JqKM5ZZgIyjHvdYIVhvBWaP/n84tpH/ef?=
 =?us-ascii?Q?B+wRC2ZcEJx68/aI6mWp6TT4PUGDAcpv4gGReieI2DML7eNLZkUb1R403hwK?=
 =?us-ascii?Q?6OhCOe4QyfJPTjs0d6MDVrWt11kS1xzJx4ZzbKz1CoMEfhEbFPKoh7pB/1mq?=
 =?us-ascii?Q?vWwsHfMHuy4ed45z5SF3owBHE7ICAkFAwRXGK5vR3wE5EEx+FFwdeR720Akl?=
 =?us-ascii?Q?7ZNBXRuutuw/PBSDoOCLjWONWkdPhkxguTpfmbDPwltKeSOP1C9se8sXaOVQ?=
 =?us-ascii?Q?FeYUOvNe/9lhMlHJd3a1uNhLauJbazILNk31N6Yzf47BoJveZoQ8fhdDuYw2?=
 =?us-ascii?Q?QrqZeQTZW/DIANctPUk5b3ABQUzMKjXLl8962tuhqxldpAJTC1zDDVRxQ4QR?=
 =?us-ascii?Q?0DXitG7gdLF7HedFloJ0vjV7iH6vB/PJvLGuZpkwt7FvJgP6HLBwjwjAwTpp?=
 =?us-ascii?Q?5i4MmKfu/idgHrqpBvkOkl98sZ7A0VCYvj3fmo5LAaR4BUvCrg73JEkgfcXj?=
 =?us-ascii?Q?ct/DnBaTVq7wRMn0LyPaOuZNEcfcF/6Fxq9kGvUzhJwOD6V19gsuPca5uRkl?=
 =?us-ascii?Q?Yd22oSexuMQat1H6E7LOFuvMmroS52vDlQ67CL99Tus1OUJUTjRhMeoEQzZ4?=
 =?us-ascii?Q?390CyEnJjg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff26da72-15cf-4117-3d7d-08dea2357344
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 19:12:38.4913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VbFAY7QmsOCRkH9hsSXVp3P5P6z/e/M1WKQK6ooSoGEc5/vlSNGvepyqdCziSNEI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4063
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1EFC21C0002
X-Stat-Signature: f4g6w894t5jsabxyio88zueszs9xytmt
X-Rspam-User: 
X-HE-Tag: 1777057965-190873
X-HE-Meta: U2FsdGVkX1/2jCO4Fqhd3VNmyGNfPfowOHyCQF20cgo5wFeFNSZ2YMzjxaggXDx5chNZ9XZGySBt9Fi+A4QIGzKQ9Ukjm5LpXRWG3malgEM4TSeOvH0MviTBkG0pQweyrhs3uYBPzoJgM1G7qaZzYMLPzO5zwuF6UviHNyQ0JFzs9WTqNoEv3nnqWCC+NQ1MHjDCXIZIFb0XofIn0NuMB6Wt7CRxF4Vk6uV8TS+MQh28I3nO5WBYDaWWzodJpKe7iX9MCZY6rWlD3vKGCeD5vg4rgiHH+r3jIlrpkQ9tSzVE3hRB4eY7ZavXovlgk6SNvant/UJBNeUbCTK7uGfZ7WImLOVteuW1a0HVAA4Sf5BWvc6nGw8aAtWfGFYXgMJ5YYobfZQW+qq72JfEvJThtkTt8x6uyniwm9y3ZUPKVMfKeTnKaqwtcywxsF5aqD1CIRmm3VmS5dnChwP6l3mS+xWHUfb+Iu9Xt9xeHXLpidWSHQljVBgKTmp5UjXE+5LNJtafyQmTWIGiyq/rXFzpEstO/UHaI2DwoXR4H9lGA3rSV/8cu3NPo4jTELqYxd5MTmK44OTbbpUOztusHfWZ8t7vmJrOPDcdOPa8G9Fyc79M8stCVNwAOesriu5e2VhqT1E2gTqtVdtHF4gsbgpFFviTmM8LZSkyC6et2WpPmMVu8uvELyzOiaNpF4L9oiLMd7ZIHvBmiuU9uIt6cCd8fnLFlEXYdjcnRbWBiYmMOKf0K6Sn8UD1S4+EXCDXto5wr7kY/CRS+HuiEXjLC3ooGgDmSNHM4MTYgDnSDwPW+QbFgaku2Baf0Tm31KoExsee3dEZagDIEsyn6yQHzaXlU2ggnH/9IP0VOMsJziSnwknPS742okBklzGiX8T29f+cpsC3Sz+PRUqJ1zIzYZouXOde6C3qgyEqnz8510dfj80/MGKs0ZVVxlokcBGY0uHx24ViDi74FKOhx41E6Nx
 Q1I0Pxzc
 8XWkOKQlskK4OnJ8GogyuvE8aU4/dKtmRhoHBIJ4foBzGpwGLYh/f83FFXJwH2dJzIjVAcrLVG1LM7daT9xp6+a3uKQBAk1QrnPgfz9/mLoXdrBHt/MpLsct8oXoKspMNKUNDRMSHBVI6tA93HWPBIkYz7Lc9y6nL9MM9bdEsYjCvwiOCSjauePflYAUa2uOnc/Q5RxshUjookUQdegjxq6Q00N6lyaqwW2SSW9e6Ae7qgxgoBk48zCkYyCveiXz+pftBIR7YD5yvaHmK2nM3CXXTg4Sk8Jylpas08lxirB5VLFngYDf17yVu+dVkerDIKqXEP0lqyv4d0bk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Apr 2026, at 15:01, Peter Zijlstra wrote:

> On Fri, Apr 24, 2026 at 11:50:03AM -0700, Yosry Ahmed wrote:
>
>> But I imagine it's useful for reviewers to see Sashiko's feedback as
>> well (without having to go look on the website).
>
> That's why I have a script; if I press 'S' in mutt on an 0/n email, said
> script goes and does webrequest to sashiko and inserts the review
> comments into my local maildir as properly threaded replies to the
> series at hand.
>
> No looking at website needed.

Do you mind sharing that script? It looks like a great work flow. Thanks.

Best Regards,
Yan, Zi

