Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 359B2CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 11:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7130B6B0023; Fri, 29 Aug 2025 07:51:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3D96B0024; Fri, 29 Aug 2025 07:51:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58BB36B0028; Fri, 29 Aug 2025 07:51:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41AE76B0023
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:51:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D9E07BAB0B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:51:38 +0000 (UTC)
X-FDA: 83829630276.28.1D601B1
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 44900A000E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:51:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nqWkX0ZM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="gbXv/8qh";
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756468295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3zhEr/2aqYGjGQpaQPQSW+EjkFpCKRSQXp+MW+xQhMQ=;
	b=GIe5oPRMIlTkx+x+aYzN7uDFCsFg6go8NHcYZMVvitlDDfdbodyaoRyOtOmkFtnd5KREw2
	vrP2lbZ30yDhDGBo2UvY7XjZXnSFGkRUW7YcmVf1yUDVcfhn0vBmdSIkLGAlFHcq6GflkW
	ZCZ3kOOQeKunLZita/KI7s8LEKlEpto=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nqWkX0ZM;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="gbXv/8qh";
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756468295; a=rsa-sha256;
	cv=pass;
	b=tEu+/jw4mUxKaxrj0lA3+Iv/FBMQ1D5PulLpm0APPupSPg+hY1l+VYbsPGdxa/WvSfXqrR
	5wI+zlqmZ+t7mabcwIE3fm4Mb/gLB8Z5DBRnbwzet5fTkzQmAUBvUMStAlpsyVXdrg4pVx
	x8rVsT3bULIdgLhP0bxZDyvFmqTcbK0=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TAY7kN015441;
	Fri, 29 Aug 2025 11:51:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=3zhEr/2aqYGjGQpaQP
	QSW+EjkFpCKRSQXp+MW+xQhMQ=; b=nqWkX0ZMj7z6O/WtM3oto+67TeGMOawZjm
	uTGLTMhUxNx6IE+u67MrSarJKb9KokXGRHAG6UYxQ61yQvMAbpiesI+BzJkPv5mH
	SJQ2qsyf0ZTCdCKsTphM4AeIUu1aUb5cm4or14Mhgi7LdVMoscFzDjkoh+j+YMzQ
	KiZ1gGxzkQbu0T9On8Lhi7fNqTT0vQ0kPIZrCrF8BvYc2BaI0KM9uEb/EunubAUQ
	3axu/J1fnqrqtXzzVGL8os5tgbQX56zOTaURgIUOacNPUiFfTCEl69WBvXoaS2UC
	2GaTZD6u5ztNIDeFEAxvTURZ6VAhUOlzK1hTJGv2CXzisnmvuvhQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5ptah6h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 11:51:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TA0VqP014658;
	Fri, 29 Aug 2025 11:51:31 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012013.outbound.protection.outlook.com [40.107.209.13])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43d1wg0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 11:51:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=unJMZf5JYFqv9BtF1ENg8kcWWBnW30BY29UAlEBVfcPe2sP8N6gKZBR/89YOV276MhTT/2jFFRC1cFB7hHe7kNSHz/JIr/ZEYdxQQogAhN3ynlHJ8MlC6jR8SeoKRuDaHPTDpiKR/JkRDIgISLzsQEEknPo10f0dPt1PdWKkfTNJGazVv6Qb0zQxx79cGYNaJmDuQgtQUMdIoFI8Nj1bWQVE/ZO8aA+7QXggzp1FxjLzC1DJ+cS/j/18I78GHzP2U9JYrX/fHbZAKv4OPJlOMf8v0ASfBaoGhiiUhJBgIbt103TmntCVvQ/tVDs3RX69BK00VccO436dO98TabJXBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zhEr/2aqYGjGQpaQPQSW+EjkFpCKRSQXp+MW+xQhMQ=;
 b=lWF3TCzxquBNNJt79eeavk95QXbth2FzWzSPo+DJOTSkCz3ZLF+ox0/DNK0z3gRduUpDTh134d6+eiWbITup6AYbpIf8fA5qDy0VVQEw5IG8w5SLcK/0oqwEg6U0yXXoGNR3lrcRg7nB6VeanZcgisAlG62Wew4f/+C7Po1WuC8a17ybonPJEBNYNdqEVuHnuHanVTMQD4wG6bzKyqIx3ezjLGYJI21RqHHEuvYKMXbb9CT4vZ+szjpSKHT9iHa4DLJC0F7tgRIhSO45TwhDT9rToZRTqpJAS9axT7rn2r4TeBtpSdGsvcCyF8b4qQZv6Em5kCWzr/5A01EWZOTjRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3zhEr/2aqYGjGQpaQPQSW+EjkFpCKRSQXp+MW+xQhMQ=;
 b=gbXv/8qhnY0/vRFdAE/WGBq1HF+v13VM8URD6PP0P5EEzXbOjs5uroCH0FW2ziG2MsnQ40NTWU4Aa1UGuzy6NlyZqsefS9JvyicqR2XAOrBLNNu/q+o9zNv8/kGtNYOzE1RmGlkGNt5XQcjfPUSsNhGX+Gwki8aB8V01atXhAwU=
Received: from DS0PR10MB7341.namprd10.prod.outlook.com (2603:10b6:8:f8::22) by
 DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9073.13; Fri, 29 Aug 2025 11:51:24 +0000
Received: from DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935]) by DS0PR10MB7341.namprd10.prod.outlook.com
 ([fe80::3d6b:a1ef:44c3:a935%7]) with mapi id 15.20.9073.016; Fri, 29 Aug 2025
 11:51:24 +0000
Date: Fri, 29 Aug 2025 20:51:17 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@suse.cz,
        cl@linux.com, rientjes@google.com, roman.gushchin@linux.dev
Subject: Re: [PATCH] tools/mm/slabinfo: fix buffer overflows in fread
 operations
Message-ID: <aLGUNRIKgRNkgY0v@hyeyoo>
References: <20250829095947.1828094-1-kaushlendra.kumar@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829095947.1828094-1-kaushlendra.kumar@intel.com>
X-ClientProxiedBy: SE2P216CA0075.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:118::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7341:EE_|DM6PR10MB4313:EE_
X-MS-Office365-Filtering-Correlation-Id: 084e1068-ab21-4253-c6b6-08dde6f26033
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7j5JSAMogdK+jVCYD+b3qlgPYl9tlaLpbQuDm4XYzG0sGHgpGp4X12b9wYJe?=
 =?us-ascii?Q?MCoBsGeyf8BHCKlK3FLFmOBJlVtI04fMkQlPGgIF++Uripy49oP0ZsgbblnL?=
 =?us-ascii?Q?q/bylCZ8OLVB7QS68Z4nQBHSO2cNcYzrhZNqHZiivx2trPJaGXTxYUDb3ER1?=
 =?us-ascii?Q?nhLTfnxgd14dtv/RyMi8q1j0xjL0xOMMQpX6KqtlNFROyxQZ7TI6E8mpgETM?=
 =?us-ascii?Q?3Yxdc5dvfvgWDSZal12HPwWzVqgi8zM84/OJeEY7tw2aZILw3CP3OHhtym8S?=
 =?us-ascii?Q?eP8olfdVqgC5A1YDHiiYiMpJZK1fCRnP91xJhmfXV+ju6dt1/iEKgxzJdNTi?=
 =?us-ascii?Q?C5Hx6hkUw3xTxnjLTxm2GygNqsnbhzI1Azagay5savep/IWMV7lJkwJP9cen?=
 =?us-ascii?Q?uLQjZtcJ01GoSMIiPrLWXakTEzgIE+ndRS/4z4UnIPBshpy1B96t6OQD8Maf?=
 =?us-ascii?Q?gRjh/CoTdkUttFkJWl0Y/DVXvjeYF3i3xFnFys/Jbdb9OQZjw3+xA93IWVct?=
 =?us-ascii?Q?LLuoKaytpzhoqdJVXLRfrqv0iH02ok1tx4cVARM3lryddDPWoP9O0P5g621b?=
 =?us-ascii?Q?FHfKMlyQjbWTvtc4jK8QnknZF3tWRHyA3Xz1rWiN5LNzzQW4A8Q/2n+Be45X?=
 =?us-ascii?Q?3AuERl3a1qVM9bzaoXByo4Rbcec3JNcAP7AzejQpHTgDWDr+Ed0fsZpsFNif?=
 =?us-ascii?Q?4ZLKKpaUWKiHSMGkzhV8/9QNpWWRYpMZLH57YYhbtMJwgCUImbaYoJWUPdlI?=
 =?us-ascii?Q?MZ2IRB5IOXZH1wDphRGiLdRSzr6lB1d3ry2ton1UYfE0FUiJvSz0cinv8/ga?=
 =?us-ascii?Q?FWdYZwqGRhN9BFWU6U7mq0hTgQjew1j2qoq3TBMqYGnOygpyJAaH8X5tMvGQ?=
 =?us-ascii?Q?izf8i2uUML72LTjhi67BgVBrUw0uVGaUyn660eQ0euUK5FMJfJEfjOJAwZHI?=
 =?us-ascii?Q?X+KCoJ4iBnFTcqZS99biIVFSoaPfOAmQE2LSQ5NMI2puGnrW4pmls/Zk1+91?=
 =?us-ascii?Q?vw9XCDCR4BzH9AHc6udKQQRuDYyB5sRdlsZZ8l08n7rbHa1GdD4AhRcAKATo?=
 =?us-ascii?Q?1hCCma0prDU7hnJSq0NSh6Ax8T5oXX5BB/mAaocPbXKKAyv+V8ZrSnYbzx+D?=
 =?us-ascii?Q?ZIQ+fv0K+qzwzQFzLXIJv7gKcurqBkLGF61VQRkdQGU28rpJbcg3rTfEbbml?=
 =?us-ascii?Q?j2hWsAILu0d/++DiX5upSiuckCBHja14njtjMoUMuwguWo6TERxaoQwW4Sfm?=
 =?us-ascii?Q?znFQcXxgCL9LYWYuWeCCXSyDEq1UgcoWTxR9uggI6oysfHHm7FOrRE72J07r?=
 =?us-ascii?Q?5jIh/JMRabRVsZWPhDjevlMzQGW28CHNcTO77ljJBc7xSKAqhLWknDvpquTy?=
 =?us-ascii?Q?3LaJym6QhbEMc9STAkhOgCimX4gC46ZMjdm5AcCw0YxlztxB5Z8A55edHD+p?=
 =?us-ascii?Q?jQ4BSlbb/hk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7341.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ISaifa85GWGWZL2kBBJ+B7cspFNfCoZ1tdVbQj1fPXoODiJFTjEcxtGptDad?=
 =?us-ascii?Q?1L20IRuQhB69bqC4R5GY15THeo7BBgIyIDcr1ZgAM2STguUcmVuiKW7AyID1?=
 =?us-ascii?Q?6PSHYdEsEaArnAGMd6gfRuMNJbfvkzPHBZWqIHlY9nJBgqi54bbgHfruIVja?=
 =?us-ascii?Q?Rp2XmKevyeRcMsXMLdHpcjA7oPvYn85MJ/NvhGKmHvZgPprxMe6ZXTtY9v60?=
 =?us-ascii?Q?td24GKanh9qmPaf65EI4GCBQDDic3HCf0uCCDtyI/EkleDlmAQwjo1MW3T68?=
 =?us-ascii?Q?ikUVSVeH24c/I8moYEy40MAkLieE3yEhV4aqHjM6Exnpa3NB7N+b+5KsAQR7?=
 =?us-ascii?Q?Z/1iEHu1g6xSg493flbNyPlvXXEeMO/QV3K1DuP8kaGlkRCzVn9MQOQkX1Qi?=
 =?us-ascii?Q?30Yc9kKhEDx64rKgNCDNsEYZFLx6AR8ZT79XB3lAElt/Z5EI5Wm+FvoM5YlK?=
 =?us-ascii?Q?eB4Wq/6f5DkkIYvp0EaeRg19pngwwqyA8Vsr+w1bVGQguthNmTRFa5dNrsY2?=
 =?us-ascii?Q?EfnTUAPcb86qTNKm0zchnVTs92Aq78ikLl6B1qWiC7LInpTY+fO8V9JICrjI?=
 =?us-ascii?Q?bsa6QFidIDkcDH4/CC9qppW/HQ4yEvvUB3WtMd0FRIGO9w5SGqibbI58TJ11?=
 =?us-ascii?Q?pP3EmCidv3VjJhGqJ+icgBVsmWWVJoKFy/JYnAyApgs3V9r4Qds4GT3YpZtU?=
 =?us-ascii?Q?6G0w7Y9j3ow+PSEyxaWxSmVulqx5vAAPQjT89tY/kCUFgsrgUcWIONeY1T1j?=
 =?us-ascii?Q?1vzFuNQDPOmfqb5bJge9pfNfxLBiQcB0U+5cqV/muxc3aVluEMoD6XX7/Z0a?=
 =?us-ascii?Q?ZBsyhbxqYJ6Djf0NlnNVurxvgn3SIVL/jmmg/2yJ77n4b5TxaFurLrV4MVCy?=
 =?us-ascii?Q?/1BG+r8JJNNDBVhYaUbgAvw7yYBufZt7K8OtuFel8MMPGV666PBHmB80OpA2?=
 =?us-ascii?Q?piACIsnOcmARtLTinZ0Hi4FCA1YnAJ7PlAAR/5udTECBFJhFVf8IgsnUs6S4?=
 =?us-ascii?Q?ForkLKl5N2p+WK7kb31i/ptS5HRW0lTPig3IVH/35lnajDggTG7Sq7CUXCp+?=
 =?us-ascii?Q?B7wQ1hFfUZDNfHaKafBiuYekUtSAc1KfMYS65eAUyQtIb9I2IsBqRrbpdMqB?=
 =?us-ascii?Q?76cFkO4Ftk9RxpJvf2GZKW98Nua0TIhnSW+1S0LQuGvvfxBCgv9Yj9KljLKt?=
 =?us-ascii?Q?zg24jC8TrSjj19Y7b1irTqRLq2UhgVy+XkhRKPr+4WxTE5g3BWBQVn0ISme3?=
 =?us-ascii?Q?suDQoFBeMuZkhUTNPUIbJ9zrvn6motfk0+GtNUpwK3pzQonAELDc31kUfhTE?=
 =?us-ascii?Q?bohtjkMEBtdP1NBe7S0nISzTbpKSE/nG83yc6aM3BikvzUaO3vMtNGlmctj4?=
 =?us-ascii?Q?ChrcI+qQrsA2AI9Aba8CmjkHeLDYlBEhZ9iayCn1ZiWpB2ouqddhRZnovIqO?=
 =?us-ascii?Q?mF3uyxJ8wfxs5rUOeDM/M7uuy4FMdm9dZtwO6F60z4NJeQhLoEYDbznPVYud?=
 =?us-ascii?Q?4YMeLtHsbjZhsVMW4VrjuPDJ8WzC9B0L5g6xFR0I+gwOoHRh/Vij6aKqgclw?=
 =?us-ascii?Q?Ncjas32zupVEH6XUPwrQRa/hNTeG/fW0klLK5ggw?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Xt8ClxxADs2+iH1uvrs2VWJjxOLXpHvwHH50u63KZFCX2k2gCD0DkzhTzqw0Cxur2yATrPTNV8O7bQvs8EcMdZDG8Nf7bYwAlHxGihT0r9P+LxgC+RFaFDrZHnD/rxOJ6yornOK7Adm4paFijYCzXIVJkh9W5y14YaeBHoTUbKq0k0dCmDfSfwQ5fFS6CF6mbJRCBS+sNsBzcH2+otVl3mP3gg0aqUfRE+L+MiG48Ce2bwp8SythToSnO1FgBjEB1RVF32IOxVD1uM6YUVe94qRuAeycL4qxPnBVzry88bXXh48Cf2yFcs8Hh+2ybjFYvMHvV84txe1uZyYxxi4TX4UDZe9R1LoUowIkhtOSCsJ5COWvw7Nti95L87mZYTbC3UBRn7rAYYaykTJHMXO2OCHxxrORCj09t1yQc/eWKnkpURB0K0WoN2ep8Cdz0cd6rOkj9GSLqb2xhpq5YIZeaxC5313ZW8JDpNHBcaGtWutNpmDT1wMWRLY+NS83ocwxdufkozm1h/b2/jdM1CtHbsPv0649IgoTC44JY+qfcNltnJBe881IZ1HkJYJfPHAP4YZTi0DN6LeiA678RM+CArdiC4+Fkae25VZ4UPTgzC4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 084e1068-ab21-4253-c6b6-08dde6f26033
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 11:51:24.0825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g++JOwWxeS4vCRQzp2CEC2Oat8HBErhAQbi3wPjOR/mDQDST85t2/Y+EooPlJE9ZKCUh5SRsUnRfNkg0Ezu/og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4313
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290099
X-Proofpoint-ORIG-GUID: oFAnGqwh0U1dXA3hw8vH0mRkz8oDvk7-
X-Proofpoint-GUID: oFAnGqwh0U1dXA3hw8vH0mRkz8oDvk7-
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68b19443 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8
 a=pY-zbroC21iJxlkdGZAA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13602
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfX90Q2eityL19F
 Y0remB5AUtDC+3jh9C0s1gyKm+0Nd3GtPZOH/Sdvi/ygB0SLa8gx02rgak3iq8XjofBKLFb1Q5q
 KT6j84W+QFOs6N+rWcrZiA8Cv7x7xlBw6PJwKVyXqjUl1EJpPtY8QWvmGanvZt+VZBnzeN8c0/4
 POXAyARoTNNXFjJo1j4rKtrrsNEz/dhuFcB/f+hmzzJa1AZXhFoWgtYkPNXR87DTdNaONYDkXyc
 JwG+8UgM/fpVd7R/fXAymobP1Xh6hOTilKEuErZgxfCxGBHJz7GG7TsYW6+Xz+RcRftFoKTsb+P
 dwWPWKyONfqv+Re21eY5HPfva9AFhcGdtEsf6JRYhP9yZrHF3JhFl5j+2WE0ODsnxw/e/kh40LM
 2x2B24hKUYUeh3AjONPvjPpQiN+u1Q==
X-Stat-Signature: e49zibrp9wxjufqz98jri89dksiginrc
X-Rspam-User: 
X-Rspamd-Queue-Id: 44900A000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1756468295-968520
X-HE-Meta: U2FsdGVkX19mUEtMCraGjCN1IpNY1JTnoZtapwC/NdytZOWATviQpTNtk2xGH1kUZ+ZOW+QH0qzGRwVv/+fU1v+L7J988iq01E1vr2r8YZPRYuSGVuMq/6cKaKqsUEIc9Bx6X2V2v9DsAilrOiJDr0TKDPkBZ8vlgxxj95ga+Oo+xTe9hP84MCTL5eIOyN7jk0XwOyRMxL68q6UMq10XRYYDCr9tmJAJpffroVjQYC3vID9G/2xu9bpKpvsYSFOdHM8CnBilFBy/8ZVIhDDTvk77cPvygXlIDnED411VSj9sn39ZkoXQ7boRNol6YYuvqW/YgiOwvq1I/zZnTpyx6ALqwtGcbScqYNBrFyxnr2e/OdvEAS7X7ZCtvdFY/rpnoBuICPJrBXwRYcbiKSAtc98StXw4CDgnU0oscbvCL1HVmnFe9VEsi6q/rbgXm0QmaNk0GKf8rYvCZ5NEwrHfciIfiBdvYlFtA3P0EyDL1JUqE/S6Iz9zL856IDYKlcZQxAk28xVwyaqPV6Gmn088CdGx7zlvfFKvnsCoRxyVdrsHK6P/65ipcjwT4i9p1HLU21SALW2FcaPN3TvFPEsQzo8ikS2p8HBs2KW1u85l/qXRgkDSEIfFlA9LBNdzepAaoq7TC+n+uTqRtUnZL8E4a2P4/5AeAhHLIeuZ9cLCf5aZYQmsB6wLBr7nIVmfWMWF9g0qpy5L+j4Tgq4xUEgbRjJQffGXOMiRB004QuOpAC9oueOcKTFxWkpV0vMIICa5pf5U/f7kVIxEcaN42nvSAaKXNU+7EznziH0TXJpishCN/3FyTwj43Ps2H6SbbY7lsz/KP7rC4n2hrbAi0rU6/DTUqJc2L8Svmgbt0AV+vWVtyg9p2nUKahSTDgHKPiI1KVd1AfKern8VTPsRkekrCyFceCYuN0Y1Wn2CatW6PbexE38m8HI4V1U23LMOWORzEKehT5V1f8JTA9uz5eo
 3LtslEYI
 NzJK0ahaWkIbIILoHsS1nLfhCsPcdaFPyOE7BsGk2l0iXRn3hLopxU/XNSmEo24IPP6NFxu7DuEK4cCUdgxYX2qUfVkNcD0/v+v5xbJ1QcX1GVkGZiJ6PDrIqfa5odP/AV5DS+A1y3rPcI8ciYEwxsjdjfiAKT33Xe4MB7dklNnWHZZvpkiIXHhKnVK5VgELnIv4KDKBLlxWGY1zNORdhyxVRZG/28ogQLe/JciddfrTeGTsglQ/3oOe6kNhLw2Ou44UJ7CFZPK3ocuw6k5zq7r+xcJ99bhG1aZFbalnzl5gU5+BUDEMkCGwYKQqP5sQ1oAvRpaGnHU0vANHFWLf1FrIhProDH/oVA+i6uIxeAKUsdBlCcsJ3HEacANJQYQLZFrfqvp/PhUY5piY/0WE9dIxhuPmQYp8F+X3NGVS6iMDmlSPPxw/JEIiEt2rKLuyqRBZjVriB742yskrsS7yxmyMpTNYA+DQgpPgUUWs2/7aqcjlkCxMZo1E8u06o9J85lPRorFdWr2OHHkkAE9c65omZGGZb5D7IvxmfYAv0tyFdkXnCtOZs1W5ZmIf4vwXO5ieAnsIDuW0TLgoo227BejezLciUnX4BWlewcbDVYIU6DiWenPX5oUbnEcBdf5bDIf94m8+At/kf87vj0baDQywH3QMllLhFWVtgOt8zt+fbCWv8JwKMGzw3kyD00pFYSk+Tb8HrnYLkWcsNT3hVi6RZI+sL7nvzPKaAjd14iqE8lMA7UJZgy5ZB5RVnPYEjySwOsGXRCRg59wQsQ5l+h9c95PcxfWA3nTugckdGjdLVD/s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 03:29:47PM +0530, Kaushlendra Kumar wrote:
> The fread() calls in read_slab_obj() and read_debug_slab_obj() can read
> up to sizeof(buffer) bytes, but then unconditionally write a null
> terminator at buffer[l]. If fread() returns sizeof(buffer), this writes
> beyond the allocated buffer boundaries.
> 
> Fix by limiting reads to sizeof(buffer) - 1 bytes in both functions,
> ensuring space is always reserved for null termination. This prevents
> buffer overflows while maintaining proper string handling.
> 
> Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
> ---

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

A side question, did you observe this while using the tool?
Perhaps that means we need to make the buffer bigger.

>  tools/mm/slabinfo.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
> index 1433eff99feb..1a7f2874c625 100644
> --- a/tools/mm/slabinfo.c
> +++ b/tools/mm/slabinfo.c
> @@ -228,7 +228,7 @@ static unsigned long read_slab_obj(struct slabinfo *s, const char *name)
>  		buffer[0] = 0;
>  		l = 0;
>  	} else {
> -		l = fread(buffer, 1, sizeof(buffer), f);
> +		l = fread(buffer, 1, sizeof(buffer) - 1, f);
>  		buffer[l] = 0;
>  		fclose(f);
>  	}
> @@ -247,7 +247,7 @@ static unsigned long read_debug_slab_obj(struct slabinfo *s, const char *name)
>  		buffer[0] = 0;
>  		l = 0;
>  	} else {
> -		l = fread(buffer, 1, sizeof(buffer), f);
> +		l = fread(buffer, 1, sizeof(buffer) - 1, f);
>  		buffer[l] = 0;
>  		fclose(f);
>  	}
> -- 
> 2.34.1

-- 
Cheers,
Harry / Hyeonggon

