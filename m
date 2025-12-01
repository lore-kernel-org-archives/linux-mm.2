Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E30AD111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 06:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C85D6B0012; Mon,  1 Dec 2025 01:56:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0216B0022; Mon,  1 Dec 2025 01:56:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB2D6B0023; Mon,  1 Dec 2025 01:56:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D64B56B0012
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 01:56:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 897E31A0A0B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 06:56:27 +0000 (UTC)
X-FDA: 84169993614.15.E149868
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 22E31120012
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 06:56:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="I/LXwkIe";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aO4Z7UOz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764572184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=edKHNzsVOCFOpLvUZdbHS47JecPRSdnrjTQfoFaMXMA=;
	b=x3VTOn4ETzLFw3FQZ6Q4eJJjD2tBKCkPCmxcgdFMgohYWCbGLvNy0qg6RGu0aFHWa2iKTV
	5srDsJiFoqrThrYJ/kYZNXGM7smHwWY8TY8lPVTKwj3ysy6/0vqeTJ0RjAC/QIpQtycTal
	ae4068l+H+pxUBq6UluTNzc2+H2fesI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764572184; a=rsa-sha256;
	cv=pass;
	b=npChklgPZLUmfFn/UV+2/P5KapnQv6tlhfikGxW9s4c4V6v0D9SNQUAGNb+JWeYmN2CTRE
	Jv2kctQDNvrPGm8xcStz/n6IscI/ZkJOs1DHdlxPUxr5hfVOjnpRcHMQs0zSGR64uRazb6
	Nfp7JTjOCyHexW8U/t+MaeanKkGSZc8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="I/LXwkIe";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aO4Z7UOz;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B16eWCM1443577;
	Mon, 1 Dec 2025 06:56:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=edKHNzsVOCFOpLvUZd
	bHS47JecPRSdnrjTQfoFaMXMA=; b=I/LXwkIe+MTtkhVcVOxZAVs/UE6rzXqe+K
	PObkZ8D80Rz4NMBqA/t3ob3OfpA0fgQC+m7n1apQsrvGAfoc5zkDzS+wLHTXb/eA
	jhIPAb/qBi/NkigLDAWUx/YG77JJwGgvAT4fyOMf+2Siyvb6OiUWBVlIxbem/Bds
	yNQtxHspttOrLslgR+P4fmzIogYu6mAtYecTHZudGJSOlFV73hfqOXctsqxNBtv+
	eRLk94R4yLb/HxeiXvbK9Z4zo/jvFKid/WBgL9u3CFsQ8qWpnLQzV1uCBfQ6bHb0
	lail1HDaDDcG0Mr+GXu3HiPZpedY0swMb+bkQcORT7JuaHztxVNw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4as5y7g0mn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 06:56:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B152BxH028905;
	Mon, 1 Dec 2025 06:56:09 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010026.outbound.protection.outlook.com [52.101.61.26])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq97n7hc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 01 Dec 2025 06:56:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ogO3JzkAS/PV914NrGcSIujooY7khfo9LrGmRbP6ePbuz0pZDrUMHxvUmrPFMlTx9pzDhrmz8nWe774y0i1Gp1ve+894PF2AeCYMaKLm5WBI5gnGAGTsUONVVTUVpW/p2vezcOprWRb+VaGbFhyigfLFkHAfCWhjHiODjizM2MO90FgQKM/Fj6Megxu6kSw1zAK9aRkTd247bIkaHriPk3PeR/0e5XJWfdmyp5LG155rrbRKn3MndxXwCDVH7ggqMosmZfCHwsu4upVx7X3YKLCGxeOemWf4HkzedpBH2C7URIHLmCdvZd3LHCRH9wz/Z/+Xo52pwlgNE3Cf28K5Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=edKHNzsVOCFOpLvUZdbHS47JecPRSdnrjTQfoFaMXMA=;
 b=nUriYzIpkEU3Ccas/U6Hz8LbWpsu8tMj+OPVTe/POBSo54kmY124ZSexGG4DJ5RmGayxCMmiwa7bSxDqQyTdBxazPBgx0fJseUFwc4KU68vRP2Jw1szz+aupttZwsLvhIjIwKaT2JsHQ45I1mTOPf6WECoEClWmAUg2FIszP5kTUqiAKhZtOgINSYZHz291h7/A5cTSbxhMddiZl6VVWlZZen7QdByH0+YGJNq6bZOrPDF/eugkscdVXNpzGDl2oNBBqHZ584eZEuXz7ph93u/UfjTeq+pq4p+LuaZWySvEDc4Gyj+qMQFa/NgighFqak1cN88uT5XwD9gsi1VIwdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=edKHNzsVOCFOpLvUZdbHS47JecPRSdnrjTQfoFaMXMA=;
 b=aO4Z7UOzj2c1JgqEcSdWmyCmeZjSYemM6PWiwe/dgjTE4gBF0UhTp2PfmSSg++9lYTzVM1S+FJ1ZTE57/1iuGLFLRf8a0YEtZXNTLN/LGJ+tJGdJfgqTRgl0flP6a9GL1cXD+1SrK1ZF6hGokEgXwgNu3BVPQBhnoQTWttmFnHY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH0PR10MB4955.namprd10.prod.outlook.com (2603:10b6:610:c2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 06:56:06 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%6]) with mapi id 15.20.9366.012; Mon, 1 Dec 2025
 06:56:06 +0000
Date: Mon, 1 Dec 2025 15:55:58 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Daniel Gomez <da.gomez@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Uladzislau Rezki <urezki@gmail.com>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
        maple-tree@lists.infradead.org, linux-modules@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Aaron Tomlin <atomlin@atomlin.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching
 kfree_rcu() operations
Message-ID: <aS07_pFAtVCsNIXd@hyeyoo>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <0406562e-2066-4cf8-9902-b2b0616dd742@kernel.org>
 <e988eff6-1287-425e-a06c-805af5bbf262@nvidia.com>
 <aShFKpqPTgqshx3s@hyeyoo>
 <aShIqdKesZqEOELK@hyeyoo>
 <ad9c6f4d-42de-4251-ab10-579feec7e8d1@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad9c6f4d-42de-4251-ab10-579feec7e8d1@nvidia.com>
X-ClientProxiedBy: SEWP216CA0121.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b9::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH0PR10MB4955:EE_
X-MS-Office365-Filtering-Correlation-Id: fee5b121-981f-4a19-c24c-08de30a6b2f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aXnYkmf/91sI/xMW8Jp0598TTlevCC/9Exo5bCpjxmcTIV94/iivrRBNI5na?=
 =?us-ascii?Q?chY/eHrjxg15PbuScMdKG9t/MRQY6EnFlCPpUMFXYUDfOu9M4HoCehnhSPAv?=
 =?us-ascii?Q?tTvCHq4sQa6u6pJighqJ4jHVdzfHP3IfxLJtH1IA1c1kpwoSvRfUjtUqbHed?=
 =?us-ascii?Q?QcvYOgucn77sCbjManDDUjT/sd6d1gsOisklwd6zPzO/ps54b3UCBybIxtgF?=
 =?us-ascii?Q?YuB2s7GtN7RnBGzRA8879UGjzf3uGHN6pGYZraCjdchnDzCN7XLeuR+QuASr?=
 =?us-ascii?Q?Wj6mdk88vGxRHkZIUprnWSkefy5wD9k0vCJINgvFRXhuYB62oaVFmpppDOBW?=
 =?us-ascii?Q?RuFQ/wUlFHt3C2f7BV1urVOcigqf3EteET1aUGjKHXj8NFKamxem82T304KW?=
 =?us-ascii?Q?xtznrV3E5X95MNjn2j77U0y6pfpVAHr+Uko+rf/D72kew3GgMkCA3ygAF/Xs?=
 =?us-ascii?Q?stEVibpRi45sLfZA25eG8Zz/29KILAZLko504LCeDQuwkOEil1fFAnB1cLou?=
 =?us-ascii?Q?JT4pqkACXJg/N5X5MpCxfilGcPSdK+7CjQjxYnIgniDc/8qJ7QbyOGA10Cui?=
 =?us-ascii?Q?enHw/QCEllJZ6B+MoNlI6d13vbXym7QOnlK69gcIbS2/irDXNAEs6gEdbMLU?=
 =?us-ascii?Q?K9DxJO4NNrFITz3Q6WAXO7FdIixGyPXmWPNjKPBqlIXnizW4Vku2Lmt7jlNv?=
 =?us-ascii?Q?rX65Gn5zPB76mvH9UoNKsFw+myWPcDJYkD6qOgj2OvAWjKg6TG6LdF8CgfEZ?=
 =?us-ascii?Q?zQCDPXS9NKLRv3qeJndNwe5H0Sc9UwF5G+qiYly2Fn6A6iBJNRd88BtHGVy9?=
 =?us-ascii?Q?4d3/8Uhwn/Jj56JB0vGZ0MJ3BfviySVpyAVVI8Y/0NQ+EyTRcQIEKcx1czCl?=
 =?us-ascii?Q?k/sq/zlnW3O0qDOrVzKYC33RYUBcVqMYlx/eU+mn8zArQqDnRpQ2OLmYkN+M?=
 =?us-ascii?Q?nM0IgkJQZQuNoHVVQIBa2jax3meY/ajVRvh1t+Lo8MooFc3KYCQmbsBEY1gu?=
 =?us-ascii?Q?48nDw4ZV5mOkbyd65S0zoUt1MezOT40n94/MfeFJhX+zreKsNFByGC9aveDh?=
 =?us-ascii?Q?AoURKI9IC6yu4u0ixfsgwPmHzJfBCRnUlipuKM4vEPt81Kd1taZ3hByyq2sG?=
 =?us-ascii?Q?CfPjbJDqD9vGNRa04wjCMANIHxEV43/Gk5eC4aDfqH0X270RUBeGqRbdEnBF?=
 =?us-ascii?Q?8+o1umTIY5Y4w31GqdfMG7vRmNlUHEok5oAj+oMpNZ2Rexyog/Aiivb3K3/b?=
 =?us-ascii?Q?PYLEEuIKxvuTPRzmRU+4XBhb2ZgYcITy1Mfb4xXLQEF+9smB465jU5savnb0?=
 =?us-ascii?Q?TQ3wU/0PjW9C9aHQJWaDjfft6WsT9KIKxoxLFyEpNWhCLovovsw9hK/x3ejF?=
 =?us-ascii?Q?5emqSd1r6GHhxSO7/K6vxE/+QlMmLnP3IwKbOKjupT73hYPbq0jpKj9SqfD+?=
 =?us-ascii?Q?9HE82kAK3MF/1HKzICisaCXsspqHwZLh78fJybmGvVIq8RMl/3EDFA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q7pqZzpL55wo6HOLg0cC/e5oAG3GDfLOekYcPM0YNiWxVWXh6KOVgFBoy9MG?=
 =?us-ascii?Q?Ca8GVOrygYc0/4mzf//6NlAthbBo/+R06czreId8nMeToqOutebj+CDVpsIM?=
 =?us-ascii?Q?gUsrR71IW4rz0kl62vg074KZuEfUDqUkW/XMtz8IWrn9bkzUYC+kCnUmXaQy?=
 =?us-ascii?Q?EH+iVb9qWl6Q22M89S6lWOVTNbfF//ZW9/uVgbJdwKq4Uqqr3pI2AXeuTz/c?=
 =?us-ascii?Q?AY8sSnUOojsMxfY5JsaQWtzwjs3lKiaL9L5qmDLvI/CoNFUct9O/kX/xi2uj?=
 =?us-ascii?Q?g+ifnyY1kjo9uPNj8wAnRu19CjLbOV4/hhhps6A/XtwR0e4v6G3V9jPyQ7XP?=
 =?us-ascii?Q?HILTmzszfu4ZJuvh7urKyt7mCCvEFotOgdlHVjd1kghcYJ2V8qh6cIgi7S0P?=
 =?us-ascii?Q?q2l4CBVuaIHq0a/x3Kh5CQaBqt0h7vrq8AxqEOXLd4M2kI3shmJ7Qu01YCxP?=
 =?us-ascii?Q?iop/eOMCWhHg2jxz+WdYd1lZpAgEwMBZ4UvXWzcpmSs7/EFWmmQeFWBXOcMz?=
 =?us-ascii?Q?J9F3h4OUulHgsivsu0kLwS3GlL+I9lKUzuWaPek9dqtqyCZC3zx7Q1EdjXds?=
 =?us-ascii?Q?IS94fSnIWEOnCNeYVa14yrZPv7W1YmqVoTdNSp+sLreSJhJAjNtO050YDtI3?=
 =?us-ascii?Q?0h3qIrFtoIQ91FDFsGNiuvc5ZIAtrjF7ELFKHYPWW4Fwia0an8Ig0zU9vxq+?=
 =?us-ascii?Q?00HTIFMTw4ilyjkHRfug8kkuedMLztaBr/13fvoDKiSGI1Zuzpe0IpS31JRN?=
 =?us-ascii?Q?GyAc0LHNNk+3nOCXk/k9/eYBYU0ibyyH4cSH+pbuEh5WQZgIyHGII/ib3Guy?=
 =?us-ascii?Q?Bm2VE95//GXFkIaNY9JdMAbkAT4uWmM10lfk/S1dPsVZbLwjNBvSv8VBdARe?=
 =?us-ascii?Q?usT6grUli3fSsSGFjLyUq+So9Z2wgW6xkeZTdKwfKRW+2oMbQlhCIGrkaeb6?=
 =?us-ascii?Q?2HcKaxbwjmgdaot/TitkEr5gRsBUSUFng25uqNWSD0MjuQmju3kC3vo+k2AM?=
 =?us-ascii?Q?LV7gumQ74KHAehUTg9V8STMsV2KumsZtoEftFRSnARP3Qy+dyRPgWw0Mzy24?=
 =?us-ascii?Q?h1W985WlfadiKy76YJaCHMb01emsDys/5HMCfeuNqjdchaRGwwj61yxZ9vAx?=
 =?us-ascii?Q?74LiQ1FmPefAzyhjFE2XO5uvFvf6zDBVb9WumQ55KZfjVkvZ2vqSe0WNiJ87?=
 =?us-ascii?Q?thHz2L4PjSVHdSbaTi+grVx0ZOLnO9Msb+cA+j8hTbLU0SBvHcWcRtZxSTpX?=
 =?us-ascii?Q?7egVOh2vvtno25PncrhUAeLmCL1o09HuKf/u/hs1vISa4TJXmFLDZwSKACZI?=
 =?us-ascii?Q?wh8K4CFlhOfjHXO0gICALdziOyMi4XZZCPZI6RjX2zG8v7cQFW3vz81A4OMU?=
 =?us-ascii?Q?+uatxyHOTFZVKa+eBNqGRppCMgT4Sf1t04+3MSbzDslZFnPK6dn+GkcAZb77?=
 =?us-ascii?Q?pDE3nWj7pC5vyHSwKtRTSK821rQSda/q9pPReoYJ3yzXmcjxDcpQ8lxTZjrL?=
 =?us-ascii?Q?5Sz0kRj7I4cJUM69Jx/g0GOvJKNOwnKxEO+bSdstUhoFd1DH7/HzMZdPJ/Yu?=
 =?us-ascii?Q?xD/+M2/ab/126Klv1LWfbM8hFnW/5FAvROJjJMyn?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vsH2F5gPpaJSH98uz/8LwWDUyYF6UvUwC3n6fLhTqAnT/DUo2mhTFqsA5M8KMyVOtPtiEcr7YZWNxDnm4T+qXpLP6TFXKGtsYpCaMxzjjA6zmphjSdLb1+bWJIy3lPKxPIbGjbagGOsg/zddFnw4VXCMrcxATWSJzxid+aDmem4+e3EkS7jc7fAeKTFNL6cXYtnW4+XOdWigiXq/zxFNcQvvxceJbpA/aFOPE+t5YzdNRnWGyIdMpqP+lyHONgS0WUiQMUTN+6lXkmRBJ3qa5FQy0Gg1SJlecqfkRUuil9gRw+NUfrZKUT/ZIAyCV/3ZVT3A/yK3e8n0EM4ooIj1v5WkWJonWXTpqmIsKINXugP/NFj30IvKQtAmjlyzWilcDUeHCzx5XHFG4yytjGfoDKRLSBUWsgzd9QIHtwiGFsVdt9j81mVuimwRVCHorODWv72g/rXshIwdoJgmn8u4vyrKdO+fVx9Gg/9wL/m6HEGNPyh/jlIuVUJLDmwbVJ70QuwSEdq2FaVaozE66qkWVlzIJ9tWqb2eTon/4MrVYpw4j6kBKKnV2HD7mszuZTk03da5pIGxF7o8uWandfeqLNpL9Fe6I67Za9hPRCexvpw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fee5b121-981f-4a19-c24c-08de30a6b2f5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 06:56:06.2092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TDzVgv+gB+pznE6OaSnvd9yH5NY2+uf9aVdwfc1x51uMMzel4sektbsEYLx/GFjju3XXKgsgynNPAQ72vqKk7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4955
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512010054
X-Proofpoint-ORIG-GUID: Dhlm2V6zcXlMZLQtfY049XJz_usTGsSX
X-Proofpoint-GUID: Dhlm2V6zcXlMZLQtfY049XJz_usTGsSX
X-Authority-Analysis: v=2.4 cv=Ea3FgfmC c=1 sm=1 tr=0 ts=692d3c0a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=6X7dRrNvz0Kgi32lnkkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAxMDA1NSBTYWx0ZWRfXzo2/FuMt6Las
 ss2PCoCA0udqUwzoUiyfM0OG/or8HuwrXLfIECZuvvAaP3BXU1R+ge883tY5p2fCT8RLyZBd8Tw
 p8pgvGjJKSo/qVW7nrQAc8+39jgskIhFcPRtzzNtXAB/5QUPRHwWvCzssqgCDQokV85m6YJ37Yf
 y9Oox/scjneVRZ8/5/Qm2zCcF6JgFREs8fqkqfmSbr1SEsi83vOX8u02rozU9rmFNVtXbjlHguO
 mW/G9kTFKergDcutNzZlljNZbSJzLfKPEkekUHkJoNAeSJTHKCypigOz6D+SsBQZz3d3lG1gRkd
 VADMxfy5uGR8Akup5zOSJjScyeEqmMhrhKMRmlW/oYtI62TQ6SJW3om+LAEcQTXdR0yJmDclaqS
 L6LZkDO0A7T435WxflJj5b1MzDs1Zw==
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 22E31120012
X-Stat-Signature: h4tdiqkzujfza4p87i8sabh89gzqyxbr
X-HE-Tag: 1764572183-621454
X-HE-Meta: U2FsdGVkX19U4fcQPfgit74DmTVi94uyofnTANy0oN2B7EoanPqQRcOD7G0scUeR2H6vrNwWjZfuOVW0Oy0tkcCdH9vVQ+0mDHKzb/CL9pew2EmjHuOIOONY7TTJkufan1NvfsfwqQ9tiaZiF0Kol68eiMJ7g781XuUkuUs3A8nX5gmBBeSSItQeeoQfVgXYB2+23aOE50ndgXMATwDKK/YsiZ3r0oVdIwPCw07ejcyZ0l61XRbrgZCCgzGB4K7hldIiJGEuYV5VeXTFsmhMXlb+zMBuQgYAfXeAdkvvJcDJQJgC4Laj8HlWIdYuJqZ3cqc9YGyi+sRMxmdG+yo4zqv0qYfDMGQirLXYQ4TaaqLoG2OnFGW7T3WgP0BoBXT5X4indUhlGRDXCKrir3CO0v4uJSK0YhckexkfuVrzf0KxYp8VSfuCfCydC6QK/zxSWn/PQPkBU/cbvAqzJ1ulLuTOxN30ooJNY3lJXa5d1b5/64X2fLnn+8DwB66htIH8Ugz9Cx78z1a1c/eC+k4K1st+jJAa9e4vVp2Le4HhxyAjotGAZrOOGqdem1mK9qh3TjHj0EEnDVBbF9LVRMDZ8oCfxp0mgq69TSOe99oDPgGhebshodHMRNc2Ik4+saBR9qzXcITXMl81u8rRtCbebLjwXrSoPmO20kL+LbRO14CXvpquU427m2RZSBe5b+c/3j2MB2VSHQxPHmsJUgDDDOEl05W6QR8uDrOXsLFZrO4OxKEIinhwHST6mmovxkgJSu/n0r46TOHhFzyjQnkARP7a7NA2AjKUuqgqVORJb1WwTvTG9HX8VGokM94yeueJYDYrBQ/j/tbEbqm65HgLxxZqwlTxNdgB794C2y+NroG5K+J7g39R/ckq1D5yvNMTUgkvfWeiH+35EbN4ACEFS6iJ9o/qM4BHG5LxQLPK6atBtl7t6vtUImsX/febdXPYhajXlkoj/ELvysajgdF
 /RCJhzy4
 l8U/FGSk6J36PGUA5I8VYnSBm6AhgSaxODwJmH6IPRrK2MABv2vgXMxUnulkNkQ1g4ElqWlk7sbPEfLPucCSgOvVzQLA31f5mVk9Hu4Jq2hCYzgWvSevjRmDgJmSyZ31XcclQ0ZN1scEPQVsV4UYWrNbpngADh1oj6EbHPJxiIw6gy/xejfcWyHJR9nOPu0noY4dDFHNbAbwLtklxLONieiD8ZdgHc9Ll6gJRyqyAhm8haACEt6Q/KgmGi68SjTm9kvROkupVgjww8lf7EUQuNa3YQfUpzcNWjCPoeGuKFp7n9swIWvwzH8FS0OfSgpZDynXHUrIlh7Po4NWR7G/d3aPTwAtNPu3AiskD7JwLC4XPGhqSobER++ZqE78izzEKA/vFX7qImbWVMDqehJK5PGGY8NS4Ft+6hWyQYKmVwpQPCRHb4TpaaSCN+Jcjjxu7fdbba/rFXU38LGi2yfQ3XXyCfmaRPuvfgMMX3FiigFDJeR+pI+QKBoguNv0N9Iych0QoQIlY9zbQA2jczrryFi6zevI+1QTbmgk9k/jJF7vi/qg8HtvTGbBEW+DcZ/J2phS/DeWU/1gVvepLJcc/UXi+KgQu6OORPJAJiClZlG+ZFIn0zcD1jBcgwZcL+Dni24NdIEnSuXyk2+EmFCGoN7QdzSF9yTFRTssbz253DtimZ2f4Rjy6PcOCCuIUkokeRcY50pTzqM5qKs2BClZtZNdycBhGvZ6wBDBW/bmLF9Jf36p9Iih9Gayhs4huB5Q75fxnre/byGOyb0tgzjXTeZihV/qhPBDoGX7R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 08:57:28AM +0000, Jon Hunter wrote:
> 
> On 27/11/2025 12:48, Harry Yoo wrote:
> 
> ...
> 
> > > > I have been looking into a regression for Linux v6.18-rc where time taken to
> > > > run some internal graphics tests on our Tegra234 device has increased from
> > > > around 35% causing the tests to timeout. Bisect is pointing to this commit
> > > > and I also see we have CONFIG_KVFREE_RCU_BATCHED=y.
> > > 
> > > Thanks for reporting! Uh, this has been put aside while I was busy working
> > > on other stuff... but now that we have two people complaining about this,
> > > I'll allocate some time to investigate and improve it.
> > > 
> > > It'll take some time though :)
> > 
> > By the way, how many CPUs do you have on your system, and does your
> > kernel have CONFIG_CODE_TAGGING enabled?
> 
> For this device there are 12 CPUs. I don't see CONFIG_CODE_TAGGING enabled.

Thanks! Then it's probably due to kmem_cache_destroy().
Please let me know this patch improves your test execution time.

https://lore.kernel.org/linux-mm/20251128113740.90129-1-harry.yoo@oracle.com/

-- 
Cheers,
Harry / Hyeonggon

