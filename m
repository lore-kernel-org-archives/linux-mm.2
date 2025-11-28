Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4707CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 04:42:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 013806B0010; Thu, 27 Nov 2025 23:42:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2D1B6B0027; Thu, 27 Nov 2025 23:42:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1CFC6B0029; Thu, 27 Nov 2025 23:42:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBF736B0010
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:42:39 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9BB92B5C8C
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:42:39 +0000 (UTC)
X-FDA: 84158770038.17.1ECA9E8
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013014.outbound.protection.outlook.com [40.107.201.14])
	by imf13.hostedemail.com (Postfix) with ESMTP id E725120004
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:42:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=d08WAEZb;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of jniethe@nvidia.com designates 40.107.201.14 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764304957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBX1MTpys5nf/5TRZ3ME6tM/7FbPstMIoIN2z40U/pQ=;
	b=FxxpUQPDdDgAVKCwBxgD7WVDoUCbWoo2hHJ9biTbnk1ZL3INciNkoND9uZMgsffWyxvkqB
	JkZq6TOfqGwA+1BlPEKxBjjTA0OL5JCr3+KzbS//1ewy71wEE+/525RCB/CBsA78jY4Nmj
	xQSb8BUI6327Ab5XC4oDO+oZ0Cq5c9I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764304957; a=rsa-sha256;
	cv=pass;
	b=DP80v/vEuQ9qn0WDLaBOLvF6DoLiq5fYqIj4H4+juy7gw2BmrU53VJFnTKODE6CVpxzsYO
	EUEeeX3CI8I9puP33E5WFNa7wYZr2/KzbsYqll3mqhbEdkTnDAXZ0bkFSz7s/DYsdaW2aW
	H//z61ZZYEplweBa8l0mHOKTqQ+yMwY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=d08WAEZb;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of jniethe@nvidia.com designates 40.107.201.14 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HbBZ0pxG9zCHLurR/HT7g3urcIp9yKKWf//RPD4uM0tpFnfMZItIJ6QIrAWzC+YYv3kyBh4Cm28PXaHIjD6jojP3QACJ/FVJ4uESDREij/2U2HDwNwiDHCumVuldvKyQHVFc3XxOy+lXt6a+sFLBdMQJImX97mVA81oXs0USiI5JP4EQUa/PYuvY2Mwaq7qTkaS8LmBld0daT7YydjFDl4FDhhk61AohhFsNfa5cMkSl8xIxJ/AhgBM/W2Vm4NEbI/KJU/YuY3DD8Ze6z0F4Vw3ZMrlkNOT4kuC1CvuGwChAzf9SEJd8cnM7e+37yss7u/8155BVJOymsfZWJwIlrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dBX1MTpys5nf/5TRZ3ME6tM/7FbPstMIoIN2z40U/pQ=;
 b=r81r3mWSiSWuQNVcgIKJv9js9ywQ9uIEKa2QHAC4M4DfyDT4e+Ub+P8DuV0JFTTzneLCyE91hARimU1ic2Br0quy3zG9lhGYv3MfSwgOvu5BCk04ITZGTy6pvfWGLLyPgrp+crsdCOK/BDdiWKHdyupAmGuu26X3KQxbcQYTH1UbVChX4XFttZI3HKME0vSiSaTdohevuQaMcF7TKrnRds+ymehMij2mmOhWypm3vExHfiiFAftAr0oRfrEEgDERQw9JY4l7si7Pa0c9A0lQ5XeWorAoQ7UbZFcYqt8jfaDivAPO0i6s0P5g12uKZR+ipbeoK9uRSzSvtvrvmuvYHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dBX1MTpys5nf/5TRZ3ME6tM/7FbPstMIoIN2z40U/pQ=;
 b=d08WAEZbNGckoGFuI74M/ouHRhlsxbCfGjqj4toFXGQOVAwsuxPGEaeyVowSor/v78vy83RV+HFKEN+Vl6xBgQNkbUHTxg2K/Q79Fjr6FIH4bkM+myElX2eDPUTsVgxlzkgFurKrDilHE+OFUEPDNxGxcNjo3btXiniM/cqRBOWapSC1mJStyg14qhVUeNvPnwhNV4lVB11P7tf9YPCBfGQVX0Upqak84kh6wvrvAweq/lyceslpUK3eEluZ7dL/UujvaJLtaCfinvVLcMKcpAyYMsBJkQmZuYwz5SGZca9y8y2ooCwWKMZvBJE0GF5oYIyEGiuA5wTcv/2Df3rFZg==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 MW6PR12MB8735.namprd12.prod.outlook.com (2603:10b6:303:245::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.13; Fri, 28 Nov
 2025 04:42:34 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%3]) with mapi id 15.20.9343.016; Fri, 28 Nov 2025
 04:42:34 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org
Subject: [RFC PATCH 1/6] mm/hmm: Add flag to track device private PFNs
Date: Fri, 28 Nov 2025 15:41:41 +1100
Message-Id: <20251128044146.80050-2-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251128044146.80050-1-jniethe@nvidia.com>
References: <20251128044146.80050-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0201.namprd05.prod.outlook.com
 (2603:10b6:a03:330::26) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|MW6PR12MB8735:EE_
X-MS-Office365-Filtering-Correlation-Id: 9585f612-9544-4157-647c-08de2e388c27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xVt0wE+PNHAFBTB198FOlSFvg4mq/QkBsnzhA1+wYhx6SvodUXqu4p59aUvS?=
 =?us-ascii?Q?MYVGjH1Tfh1Gql2tXR3I7AJ1NVRmnBrL94Ni5g+eVpiAC7r6o8ndol8PbIVs?=
 =?us-ascii?Q?kUEjbB+hhaAJwninsqAWBLvZ2jxTpQ2z8yjE4+LwXYfuL94C0jUeplluxgbz?=
 =?us-ascii?Q?08e2CKkurmM9c7bUomR32FK32gqYR+/savXssc5V1/68dhkMDR+ClLLoY7ld?=
 =?us-ascii?Q?5Sv3Id2ToaWqpNehjom13Ukw/+ZfU/yAYQT094mQg8O9P/EBbN4zjkNEq1xs?=
 =?us-ascii?Q?9GmmIaZe1n+QIFd+WGmJQThF8Axbin1j7vxoU2XV4lpbwYhVifRQs7FsgNDq?=
 =?us-ascii?Q?wRhtDd3LvNR+ZbDRU56RLBe6FsA6OmznvAq+8qoXiO9YgxIeHtplldXsYxHI?=
 =?us-ascii?Q?9HLsdL3G2QV50NoQtesPn7dUfIL5gvJp7e/V766W54PSgvfUsyUDHSiMS+A4?=
 =?us-ascii?Q?PL/ERLppc6HhaEGTbnxQmgslS70CqbS+TuAE2pCDggYuuFl5k1Mysq6grosq?=
 =?us-ascii?Q?0qqIZlJ9odtv1/3VqzFzi0+vP66ZUKBneiMu1mfci1I/b6Wjvn1Mc3MHuSUl?=
 =?us-ascii?Q?NMEUSzJOncPBcp7ABscR1Rlf3jnE8JUMxPLH+4xnTUh7IGYO7mQV5v269fc7?=
 =?us-ascii?Q?tFkjUSQFnwqf/1uBX13KGUYO3rfJ0Yc61VExKNv7zuaJeuL3BuOHv42lacLw?=
 =?us-ascii?Q?GgmzvCzLj0xr1MqeY3f+9v9gKv9OW28oVLvQFc927O+j9LvuBoDtMWhx5eTo?=
 =?us-ascii?Q?dOnVV6utW1hgdGUGQxna2pibEefxt6GjlI4Hm7TfOu9jpihCi4EVu3FVSSPK?=
 =?us-ascii?Q?hjl1BWjWbBoaHm8mP0gBPCGGJPLtNuoB9gMFogoDFDT1lJKnRHMFbENmKoea?=
 =?us-ascii?Q?08BClpiL1DKCUL1p+eHQcX7FxSZ6idc6gKqYTiH1UkiaLNRqN4GkHZhnVHfs?=
 =?us-ascii?Q?VOudTlbjUohJYvoiPChwCaSh+AHbvqCMq697KHPI1slxXYccyb15zF4OPpOU?=
 =?us-ascii?Q?J0gR2AHp94e3FcZFx90B9GmvrDi4vaKSiaGPZov2gSk+P0tD8pgAUxa5oFKK?=
 =?us-ascii?Q?10rQGSmoZ4N6NE97R7EPIacyM1j5qZb0cpgqAitFt0/KQq0ostJrTMIxfVBl?=
 =?us-ascii?Q?vP/uQaV+S8cPvGgSB7a6J7x0SuaM4bBpAE606IMRp0r4piav9ot1MUJzk7Gm?=
 =?us-ascii?Q?u5LCFZiLUmB2satOOYuUzRJArwhfz0pD1a5RbcmrpVbEO2OFW520EYJBACJ7?=
 =?us-ascii?Q?nTonVL2GdMH9Iv2HbuyhRtz1MGjfZFlOT795ZgQmaR+RlEUpX4IxWBXWcaD9?=
 =?us-ascii?Q?2P4Diu2wsK1tvbtiB7vRBuj3uwST2RT7bGZObOSnKjZ2NMehssNifjhTp6np?=
 =?us-ascii?Q?fOfJB4Z9ddjQBsxjfj2QB9LbfmZcV/4i4pJmM3KTfXc5RYH5Qj+Rt04thVA+?=
 =?us-ascii?Q?ISKIQ28qSl7nb68/cPtdeQzbJCKbiYrz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3OJEzoBq1lj1/IJcLMqGR13nfzqOXBjBqyjf2xfes8+3d5td4d4/FM4RlGYy?=
 =?us-ascii?Q?rw/nipcvS04RZ86R74eQ+tCHmK5/tzZrE+SsYzhIQbbOAflV7S9brEKlOR6Q?=
 =?us-ascii?Q?ydCWyzmNN3FSDMW0u+i9CNQByzjkweyJyoZJCowFZMcAAL9ESLUSTBmLVGSp?=
 =?us-ascii?Q?R7c9mmV8GnzKtOYuIsjUnUzQaauORAfYUtJGs6v4SAPj+m/nw8ILTTzOnB/C?=
 =?us-ascii?Q?/yAjaPJRL1HoAefN25r1BQEW78DqIvL53g0dTcaR+7PsgCgNtQD4dJp4tz62?=
 =?us-ascii?Q?resfuu6DWZwZfEjbjmTklx0HiI6TOJ8MOlm7QxGJJ996DY1jpM7j7VoZN69i?=
 =?us-ascii?Q?yVIYKepYEl2Ni0RLRDKsKr547cXsXUtvKhRQxDDSKGh8XnMufx9Pzg4hZeBz?=
 =?us-ascii?Q?WGtTIfWSrGEmYD9EvvovO4ur30gY3RzWySNiOuOuppVUapnXGN9vIljZZCRR?=
 =?us-ascii?Q?RbNJDQGbfwYjfRq23L8M7koLBYvNGMOoWtD7I+3wZG+vc1MkS8XaG5ta1hqT?=
 =?us-ascii?Q?fUhn53pEosYAP9LS2qybZRzRB7j680hyDTLKyrOlYqoKl+WvDdbgYZrXh5jE?=
 =?us-ascii?Q?zFDOLfHeDgaQrnvmU6nF3NXeRcd0YORAOZwuk+NnEjHqnuu6OXwUj5e1C1/X?=
 =?us-ascii?Q?t6YasiYrBFik+pK/OTB8CvabszpyCyQaqbk2Mi7tNLJwBg1XQkkP1Th/nnEd?=
 =?us-ascii?Q?mYCH69tCmZu70EGdR0JXQkh693E5udsaZv2EKlawfnyCZAEaEWsrktFaKOoq?=
 =?us-ascii?Q?ncvEX9C03KK8mmaeISIgWKo7Vf1E+EXkc8bh/h/MVs8Pqpu8dcHBMlNdgQHd?=
 =?us-ascii?Q?hxz7Bnj41mM8z4gJnhverQXxwGY/BEhhs3iS8isJX0BY7te6116B75URZI45?=
 =?us-ascii?Q?CHoueXOBjZ3Xl8Uc63j72foa93zkohqeryrIvXSNLq8uGU8FfnS6l4IboMCJ?=
 =?us-ascii?Q?mLLmgd9oSsl4jvHKin0Db3Hin4HQ5j8qkRFymWDFCfXiRZkGnhNy1F9IEXv0?=
 =?us-ascii?Q?4kJvdZ/X2sXuMuI1kvpOEhSNmlkABNzFa/d9AnCajQ+fF2mZo/Hxxoxc0QwO?=
 =?us-ascii?Q?bVW6KD41S9WWp/t/HwDTPHym+3ZiOvSYqOutXt5/9RJslpYw9Nfob1Oh8/4Y?=
 =?us-ascii?Q?Le3gDxzcm3SfZ8ypnECHe96CtjalCrqcwGjK0womTUY/93AjwatoSymM+0dm?=
 =?us-ascii?Q?Q7CWue7Q321Ly7XSLmtXRj42pFs1b46sABFZRD/JAhRf2SgdK3wMDFFqv7ov?=
 =?us-ascii?Q?kMiOCFVy8G7TtyalUNMaaRvseKxvgd6fpgT1v2NyBkYCP/VjlerHUW9JXxUL?=
 =?us-ascii?Q?UjJdRlI2lWpEqpO9t/xSE1dH+YeySUBA44ngMBocHonjyd3FO/HQL+Lfs+k7?=
 =?us-ascii?Q?xMum8PLkvnVTJmulZNYRB+nrraP7P441Rost0vnsiiFFejaxCn6vJEH5naqC?=
 =?us-ascii?Q?MXhw0CbPL3phyUbjuzvw2v2Fla3JmPYk3Tr/Mg4uZ0xgnkh6FpjFaKjMridD?=
 =?us-ascii?Q?AoQ6ifRTkX3Z8dGaRaSXm1mYdPQjNKIwdNW3fSPPl2kMVz4wmOmHYkA0i4cH?=
 =?us-ascii?Q?dR5OqlCbo8JdkZ7h6uDxqEkFX0Z6hdyagDCradib?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9585f612-9544-4157-647c-08de2e388c27
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 04:42:34.0196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KFPdM1CMcvVVC6loxR9viqlCwSrv0v6b/MOMM3o8nhh+rqJ+bMZstACYCO10KfwDsRUYdDi8isRdJPj+8Hh8ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8735
X-Rspam-User: 
X-Stat-Signature: phenbudi71a9tt7mscbfc5c31rnbjg6r
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E725120004
X-HE-Tag: 1764304956-632678
X-HE-Meta: U2FsdGVkX1+lSqwLuKs7ELjcVZWhBPg+upmPhP73LeO66PGget7fnYnmT9nfFPsPJfGOeKSlgPBUVTOEBR0xQ9OoyLO9Utzl/xJuJI24Ooh/p0kdzYOOYXFUTz6uPhjO3l3bgxrOgOAl8eqE9pwlWeqS8c9OaTxOdDGgeUuOpzGH5dDhFwZTdi68J7VupiACvN/lhKmtGaHxN9wJWH/2fuehthOclBCfdGZIWYTmOOmLlu6qK9dtqmExkV/ZfYGtC5pNwmN6/HSaMS0ULFZcyp9bebaOucS4PFIUIhrdoCus2LZKWj71E5NMRCSybxVJPfPb5YyCVeNDjEqFb14vDns1qLJv0T/tRMWT0MvR6tqaGjd1GX9N2aupVznQeYLfWt7Y4o9gceBJtWn034SJYjxq9U5yVo43ZFIt6+INp1MSAbeTGZloeaRTUwWBTsY7ql9JJxqEFvhBe4EVAfNmZmceyiUn2FAk5MBLk1K9M+rx3mQG2BYIuG3RFw47aZJKky8WW+he3g/ckbTiS7p2MdHBOKrQAV9ir4zkxC5G9EhxWzy18y8+kNSPECHyQxc8T+0sXej8dYulz5okRfaGjSQp2R9WQg3jIVC55NmZgrTluKDRydHhV/797mDsZdzFTz9EVBVaTyVQE0ohwx90XuXM3gKAukyBse8f3ab5/XQM0OA4M3AxPsHyXy0FJJscIsLxbPxKkKDkHKunyQkod/0mrEEBSgSGeYymK53Aj0d5OzUXgHpIgAWu8QRdnEWVzd/CVV5aVNe57jIqipGVQgp9pnqNplbJ48MHA0j0oXLq4jIXQv6/lyEZSayf3VTpbUGk3BYRpsXvgHoPnX8SC4P2/HNCPPNXKZf17dKxYJf2gpbWZ3kPv67orkvcSxuKRbRuPispe+12AXFWXdgicpuIqJ30Tqx1sL7EjjFIXpr68gmhFoKLYh/hpXSNPWvCZrlVShvW5KzGMlbkHh8
 9ag/GBdq
 dClhyDrcekEbuuvU9x67ZiIDEf6u+GQNevC86FFa4HvssPhkVBUB2bXwpdisfrN5DcYQrJPFbqNit+T7rp147FOd5aEBAWmCJePXxYINja2o6uYIN7QtPBWfgj+RHgqO3FPjcAseW4Mo0lt2y6mi3V53RVDXjIDS6wngrUY1TxrIXuE69S4MIMmD7dQwtk8eyPQmzQZ62busrFfZRLCqISCgXgF7YOkKDhfl+k16zcHItNV5knWuT9830NWoUEt3nnn8SDNRHlihYHSHM5ZEbT5B6vnX/2LJha6HdtFlPHT6TeDwol33/uuS8bGs9rQn4Kyud1MBjYkPGoZefjA4V3t+9VevPEUvM2t6R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
normal PFN and must be handled separately.

Prepare for this by adding a HMM_PFN_DEVICE_PRIVATE flag to indicate
that a hmm_pfn contains a PFN for a device private page.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 include/linux/hmm.h | 2 ++
 mm/hmm.c            | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index db75ffc949a7..df571fa75a44 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -23,6 +23,7 @@ struct mmu_interval_notifier;
  * HMM_PFN_WRITE - if the page memory can be written to (requires HMM_PFN_VALID)
  * HMM_PFN_ERROR - accessing the pfn is impossible and the device should
  *                 fail. ie poisoned memory, special pages, no vma, etc
+ * HMM_PFN_DEVICE_PRIVATE - the pfn field contains a DEVICE_PRIVATE pfn.
  * HMM_PFN_P2PDMA - P2P page
  * HMM_PFN_P2PDMA_BUS - Bus mapped P2P transfer
  * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
@@ -40,6 +41,7 @@ enum hmm_pfn_flags {
 	HMM_PFN_VALID = 1UL << (BITS_PER_LONG - 1),
 	HMM_PFN_WRITE = 1UL << (BITS_PER_LONG - 2),
 	HMM_PFN_ERROR = 1UL << (BITS_PER_LONG - 3),
+	HMM_PFN_DEVICE_PRIVATE = 1UL << (BITS_PER_LONG - 7),
 	/*
 	 * Sticky flags, carried from input to output,
 	 * don't forget to update HMM_PFN_INOUT_FLAGS
diff --git a/mm/hmm.c b/mm/hmm.c
index 87562914670a..1cff68ade1d4 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -262,7 +262,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		if (is_device_private_entry(entry) &&
 		    page_pgmap(pfn_swap_entry_to_page(entry))->owner ==
 		    range->dev_private_owner) {
-			cpu_flags = HMM_PFN_VALID;
+			cpu_flags = HMM_PFN_VALID | HMM_PFN_DEVICE_PRIVATE;
 			if (is_writable_device_private_entry(entry))
 				cpu_flags |= HMM_PFN_WRITE;
 			new_pfn_flags = swp_offset_pfn(entry) | cpu_flags;
-- 
2.34.1


