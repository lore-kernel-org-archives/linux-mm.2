Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E5C1C624D6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 03:32:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CE476B009F; Sun, 22 Feb 2026 22:32:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5B86B00A1; Sun, 22 Feb 2026 22:32:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC9B36B00A2; Sun, 22 Feb 2026 22:32:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D75106B009F
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 22:32:55 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91105BB323
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 03:32:55 +0000 (UTC)
X-FDA: 84474299910.01.E92C647
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011010.outbound.protection.outlook.com [52.101.52.10])
	by imf28.hostedemail.com (Postfix) with ESMTP id D8653C0008
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 03:32:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ANA83VYv;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771817572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYPM2tLyINGZe792Zbs2m07SyfLqAzBEOj373lRBzlU=;
	b=bDZFHM0plnQw2RrW/bI1hVuM5eOwjZ5awAIaP+CmAeOqx6IGPOFe+Ptj7NKpV1ruAH5y+X
	ffuyzokcKItl6PQLxtZDeKigRi3YyG/Cy5cpOfKMYy4Md4hth5DYkZJFsPxFozesdA/txw
	vXOO0II67hNTO1U1M+Ng5NcOpdRjeyw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ANA83VYv;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771817572; a=rsa-sha256;
	cv=pass;
	b=OBP/1+FO8JSbJtACs407MtpakIQZxMSvfsuJubgqBCmvK2Zm/rMS6LBZU51sfUTl+yLZBd
	0/L5vvbtYR63moJgUEXiFiHwgi3E91O7ZeKsp7H676s5/Hepst8If4EJboYcjiMQ1dMc/X
	ctD4AqurOhGcL0pN4wqKcBhmhZWvNGI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IO+Vmj9a35GNxume3IkKY9SkvSpC+Iij2HeK3cmY6b/csNpD2yY44W4DLqYNMq8HWch8Wt6xynw8woJkDxhgw3TbF3sEUNW37jINKuuLoW7CuKKvdxrpanSAjrN3FgBixT/vA4l0zaG4kyhcM6Z1sFQP+k+K8nzMbjU3ZjYikQ/KzBApXJnRh8PeoxDgtP29Md5c+Xs9WjEiz+aTRyaX7U01nwVtIUCM3qiYNbFpCI/Jrk1vwBB6gOhOjOEdr3n/CAGAcu2UaICPLZ5zO3kn0A/5+Ykz9ucYhH1EamsMrNOQQRKzCEXP0PJEFt1EaFqzJLKkVKuFxQXyXfvvtDJPsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYPM2tLyINGZe792Zbs2m07SyfLqAzBEOj373lRBzlU=;
 b=W7Z9XO3EVdBYVYs9JlTGHwAyeHGOCyvCoudzhoruVPpEorytJoo+Zt6pozHL8++9qYL6vyNukgTLozo75JhWqb/WZj0VZP13dt9OXUGrZxj4ivmMVF/gkYvb7z7JPG61OqUdsVxIHyyrANk/Czef7JNwLpdm0q6LEeC+V339fN7aFA7JIkEVQ4re5bcfFQ4k6ockskwqvr0Kta3txBkpsTGU0l8YRIo6z0zw22fKXl1eAXB2fBlg9+mlErkRZlBavw5R1aK5xIUP6Za58ZkbfruDrrWHx9sbRodMRbmmLWqYNmWhyOT3jl1McNykCw+4pCaIyz8l7YVNVMwnQ4f4Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYPM2tLyINGZe792Zbs2m07SyfLqAzBEOj373lRBzlU=;
 b=ANA83VYvMzhzDEpHXY/Z5M1/OXiXOInplfS/xy8dk87205BRpgOZavw6YHl5PtquJ5d4UysmwFMbXf6WMmwlMiVhw6teo2QZCSA0+lwK5juZ/hTsCK280IJztm6V/Nm86UfKHrg52G1JDLua3bB9Yqr+vXTJ7pIBfFi4fLmdQseulKx3F8IePOyBK/OXAzxyBihxalq/rwKpKSVA5wjgo4iGKWHK0oX0SWLVBLXyKAGn0+6VIXDkxtq4reAdcyPItd7EIix9SQ/Zuf2X7nXvyoq0hIfehApXhhh2KCVODPnTtPcahxoOCZWxQz0VPGCltekRJQIZzxC5eHysXYOVEw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PR12MB8908.namprd12.prod.outlook.com (2603:10b6:208:48a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.17; Mon, 23 Feb
 2026 03:31:07 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 03:31:07 +0000
From: Zi Yan <ziy@nvidia.com>
To: linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org,
	linux-block@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	Zi Yan <ziy@nvidia.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Subject: [PATCH v1 08/11] percpu: zero page->private when freeing pages
Date: Sun, 22 Feb 2026 22:26:38 -0500
Message-ID: <20260223032641.1859381-9-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223032641.1859381-1-ziy@nvidia.com>
References: <20260223032641.1859381-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0139.namprd02.prod.outlook.com
 (2603:10b6:208:35::44) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PR12MB8908:EE_
X-MS-Office365-Filtering-Correlation-Id: 09aaba9c-b79a-4e15-2051-08de728bfb54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S/Cq0rwX8HsRSpZ5iqKYu643LYk71dtHkWArLA8XreTleNzVnkfQKMzIuj7l?=
 =?us-ascii?Q?0bomxg7ukTUIQ8IMymBym8OlPbIOVJSL1ev3l5P/gMg63BGIIf2IDEggoVMm?=
 =?us-ascii?Q?9IALdGxgTCMVoDoU8mzOiCHBSiiNgQibMRIHSgkOQIYbiLLFOFMjPGFBYcb7?=
 =?us-ascii?Q?dYCmzv5tMCMew3jIeH7WdLw385/w3t9ff4XSRhAYfJhPKKt++msw78UTGrxa?=
 =?us-ascii?Q?oMbJQkFRIVStvsk7ObZUwMOs5RplRV0l2tdFbCqLiZbC1t5D/98YtAlvmtHs?=
 =?us-ascii?Q?iH+0EQxw+98Z9e7U0BUac/44O0Te+u2tPl8OJvMtTHig6fdUqBMVcxEn6Y5h?=
 =?us-ascii?Q?6P1LLeL9SBOJsi60CzLP3ZhtVPq583TuVcedSGq1ElvdRxb96/h/VSd9D0wO?=
 =?us-ascii?Q?RDSt1wLOmdRuZRInhS661dzBdmnYeCHak0PcbjdEJrUClnrxpBBZELkWY79s?=
 =?us-ascii?Q?KIBmdoehnmMIaC0Ly8r6a0PD6EdcgnDDzFJ2WrEEI3ZVc/igx6B1LEheX9TX?=
 =?us-ascii?Q?2WvQJYDw66jmD+F3ypoi66gzwtZbUCYvF91NQWGqB2fG/b69E6Isk8PONFSZ?=
 =?us-ascii?Q?R3Wtx5LDyABG3BYZMapnJr1d6/jYeixjKZ3wmdBxUlfJtsOCASNhQsRY0gfM?=
 =?us-ascii?Q?cP2ak58I/Mohi1vnzhGg14iv+ZBn/yUrlGN/J4s3EB3pzYmwUTqFVY/LGCp6?=
 =?us-ascii?Q?TSwkfbi9SfTZ16OyZmTWjU9sanNAet+ScztzoOq0wJfm7jg0n5oz+rOFCL0p?=
 =?us-ascii?Q?gcRVI8lQ7csEJjFuvHcBFFGK6edzTGsbeTkNTwg0BusYASN5lwxaye1qTI3u?=
 =?us-ascii?Q?9Zxmlh9bo2hjyz9YWLQIGKm62cUgtC17/GMfXvg67BDbo+8wRxIIu4z+CiOw?=
 =?us-ascii?Q?BnNAUWg1QIEIB5UheK4K1P5C6ekPSJad7wVPEoiWdo8v6BzbMSRm9VQJWRQh?=
 =?us-ascii?Q?0924P4TKgTfRwpTD64rgEFuhoN4Cm7SFDS42DfvNyFlWth5A7HUo11LTAYp3?=
 =?us-ascii?Q?pbmYth3UcoF5qeCRjXYTcU3Cz4z/MOxaKWnYVj81TxGm5fKSWZHbsZG5SZ2f?=
 =?us-ascii?Q?mH/zYkaigN0URnFiJSg4K6AHC8Xu6UF8lhMJIsflGtKWdGlqB3WGHz65YnJN?=
 =?us-ascii?Q?Vr0ZN5hFFmqlvheBWfnpk3Nq/FBk/AguWED9vcRywFA225noywou1tEVtMwT?=
 =?us-ascii?Q?6S1xcUlY65iCnv8M1nBX7GEP+C6Fbdmz4TR32JaQgyyKpmFlpgBXy2DJG2Ng?=
 =?us-ascii?Q?63p8J4gVKnQPikmnOhrnNH7aLKRCTcR8e1eK9CtEvZbbht5h+gjw6VUcnP4t?=
 =?us-ascii?Q?6G3ULcwMIFDHCme2o1hIHYez1dCwtEOSe27iHg5AXt0uRCqQXq0AJTqQfewx?=
 =?us-ascii?Q?SIqzs/FiQmDFy70GMcetWHXySzgUkz5ZkR3bXdaJgonEdT01ROD3mkonrT1b?=
 =?us-ascii?Q?fRAdIuTtRxOZvYRdILuoprjindSZ9e8tFucYhBYKxx62Y0jKEMCeyWOxU/wA?=
 =?us-ascii?Q?K1gTbZqA12/dJjR7Z3fbb7MSU7MHGZB2uOTyQrouadiq5G+y+RBnIRGEWkTN?=
 =?us-ascii?Q?hDpsykpn/5uPqdC+7rs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1pOuoTKzM/hWhYyCq8sR0Eeqn3iDiEfokYdOKjqW/UhWKchTtiDxs91942Op?=
 =?us-ascii?Q?HonltLTeBxg3YAO+fcW+SRv4uvX2Djao49MwSX+Yi7kC7QskBz156fGbNzNX?=
 =?us-ascii?Q?kKb6vyfJ31xr1Pwx/9LBYoRM348RxkD27/TdT4mO48mxJNJw3AJAa6As8guA?=
 =?us-ascii?Q?ifzH1Vp/hfTcurS2Jx8Kb7AACdWM5dlJZ9FTHZYBhyKXC8p0gQExdNJcxXh9?=
 =?us-ascii?Q?qGH6B/9i9M58tpfvRk04biBF2MIVpjfFXNEoBaVQOFBV/jG54sjEPyjnRxvf?=
 =?us-ascii?Q?c8WiJ3+wmcf7QkYGq5lUsX6hTd7ZS0kc1QPX7L+uKP7kXkvDqOp+eZtityIj?=
 =?us-ascii?Q?9yOzXl4zlRx6pBiBarOFuoZED/YV80J5mnb0R9Y/JP1cvB5bYEnwRL226y3O?=
 =?us-ascii?Q?s9PPzHvUapPRXRi3x+eresdG2oHCFICYb1BplVJpPdpdpS+PusaJdA366l9K?=
 =?us-ascii?Q?cOnTsjn9jFDRAyCjuvU07OcYhbqRK4KHd1jcwD0mJRVUkiyHRlyBFRltNp12?=
 =?us-ascii?Q?qNRdz5LAbJ2r1DsD0DdLqinkRsoqhB6MDmL+5SkeSHJgrcHNb+Io0rDJPukg?=
 =?us-ascii?Q?zjtKI6qS4R3JuZuA9tzYoBZesOb3uXRNnmOrutqyvd5ZmW65SGdXP5sh7d3W?=
 =?us-ascii?Q?9mS++/y18594w9/15KdXtIiM1caSK9pDe0MU35zpK7is7Ii2DpJIWufYwoxQ?=
 =?us-ascii?Q?oCxKycKFskbU0e9IeFQgMLjMRGXUL1Nol/ilV+N8IFHNRq5n4mgjAni4Z6GA?=
 =?us-ascii?Q?L/3PUioNm4LrCWXXPwOwzL1V5l1S6u17a0msNmKPYEQEvU8NXgKG9XBSx9hZ?=
 =?us-ascii?Q?/4ZUXLNn4cy0zntU6shSNurEWzs69kwFj9AU4ce83mFydzP7gZE5XO64ax7E?=
 =?us-ascii?Q?iv7/b8zqTTc0LnBTiI4uqvNmPjBCt4WRm4YFwpXASvCZXhNqMiMLpZiNQ7EH?=
 =?us-ascii?Q?YtX4ZVnMdMGF0x+NjPrdTXvn/lYxgognWHfBoEdcUPY7X3gb//320j/Ul6Sk?=
 =?us-ascii?Q?BbS4LMSae22/nIQdvjI4X//ns63UmYwTNxuu53hEraZSvBa+YqvLd8yA5LH3?=
 =?us-ascii?Q?LKIIvFBOzQF987JxJNW10j7iYXnuZkdHpJjxng7lCg4UoJk1Qp4zc1OU4JGf?=
 =?us-ascii?Q?UfPdQlyiGsqRf1BgLT+hckmfjCGfTMA8IaVJxJ0ig+6wMpjeGaAbcADHelqH?=
 =?us-ascii?Q?aAceHNqk8svA0AQ/Iiw1jSoMWWbrrE/3m1DwzpfXrazL2FV7DyoxymDQjgFf?=
 =?us-ascii?Q?4RXiYza/7XIiK0tcQF+BgJM6yN/5VlFWvkO+NaGnDXo/xfc5Qup3ER2RThCG?=
 =?us-ascii?Q?lupr9Qy7ohHpxKbzOLledVf+Fx4zZPyeZrENuttHllXbuz8JyfgoJ5pBR0Rv?=
 =?us-ascii?Q?WhBL7+4PGaV//4Rs3PSqMlyvyNGj6TaEGPz8YJ5HHNak2nx8WC9qRgczGwkr?=
 =?us-ascii?Q?+2n0lBul2bPSYBBK8F7gIc7XziZfLiNo05tXcQDT6TGtx4Ze6EjpzWXSKPbZ?=
 =?us-ascii?Q?CldB5bReMz63LqyrrRZKXzNzczm3BTjIP+8khD53/pS+lghMrcpbyPpgSqix?=
 =?us-ascii?Q?TbcBlgamfLEXhIlmK1mECPtylrQ7miKeS6/RYv6H4s5UVEHMQW/SnxOcSSqr?=
 =?us-ascii?Q?X08yL2f0q65MUl/0iTrXa+oqdTO77W0w7C/t94iXD3lyezboRwMliS8VJyZN?=
 =?us-ascii?Q?QRsK2HK/y0cnemY+xDhwG0UUX6HHo/1w+oXGUB2PPFcHl47N?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09aaba9c-b79a-4e15-2051-08de728bfb54
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 03:31:07.6775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /KmmalAKiS+qWaHsd6D/Lh7pTKRqUTkTxc+uTtbVdKv5FyyVO9obo+ko6EhsFjTc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8908
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: D8653C0008
X-Stat-Signature: rsm8a4f5jgxnojk5quwg47jtj3zphwny
X-HE-Tag: 1771817572-404467
X-HE-Meta: U2FsdGVkX19z8dh13XoDdqwKESXvUBSGA6j73x91SL6uPLs5zUIQXpwWxnvFkmwcQMeGtvp3dwnFjtpGK4E0dv7yPPkRDb50/h+7b1CKERXJ/rakdRnLp8+A4k1vGheWdDZQIS/g7SjXeVTGNthUKS5ToW1Q9f2YmtM7il18fzzL+HrbX2CbEdcOGzJa+/glzSPLd7q3HEuxKduotlhXsD5YuUoIDxaz62WP+EQtWHur+Vi/0phf4ZaIUnw2QffSbgpxc6RxUUla5/mSCjQiRAwnxdDS1j/HFV2Fo6EOPwDIy73AAap7K6PIfxpw0PRELd5DgclHNEPZX7ZlU6p1CJyWxle97oqzkpw4PHYJyua1oELypM/ud7yVnjeRq5w2QyOcJDqSldqP3DN01ULqSxY8JH6KVNhc3F05wSCUe/3D9/7ylJ96956dGHRvJRbRWnQ9sqPtrZxw8znrNJFcwHDXGgGATDcwCRXts7l/SUd0wgyE6wE9IFW2g0EZ48ms9qkMVJthjlXbXl43IC5HMUX7cY0fsfAsQAnC7etJnmgQMwFZD7su5ON73GAYkTdUrR64C0VJSBzUH+MVD7E4bVeYWtPTcovB20p+wN/vd9GgvveDYzLaupA3tu/KC01pKK3dqJ1EhyX9mrVSrCTS7X44hA9AVDX/4vvs+i6aw6DRUVepVG3nUOBGJ3jK8HDkIrVw7XoAfzVviEaADB9usS7hxPS7J0hLO13LWst4Qnn81Z6Yk79dRwawQdMRjjgoj/diTLVTvUyk/K+dPLGQq3Tw+Rh1Er7OBpdBF4bV5TYUk+CI44Nu9bLmRzCX9CaxKNCnIVH2Umlv2pVJP6x9kFW4hE5ZBRby1ywugemFJMBUUuhfMqx8Hq5Kv8CtQKxiIEr9A+TcopT6EpDgietCTySvMKWwmhSb4fZxsh+GRcHMQGqzQK1vzNh+zQlFZmg9guCmoi9I+NpOObo7S59
 iXADwMp0
 BKzKly2PcBWIGJ3S2NHoS5Ui1a/D+NduUf/J/xFeWEzBoRg/ZAT53Ry4rskvdeM/eKyKjLtFkybZu9r+Yg706+ft2pMO70ZNyWvcuopo/syp12iV27NAjIyHBesE20k0il2TEcJxQQchHgAhrqgmralidZszO5jtFA5ij0hQUaqYqk5r18jx+szwmeAtmWNmjgs2wvuQLjV9x9LS8pxoXIq/9JSYs88TMIM0u/8ibc6wtHtaQTucoy8XtRfQjJL1LC2yNVHhkv5Bx4XCAOq/hUzw2NcM9CvycJ2k4rmvnmYOEaH3cK86ad5PJa3vhmOyTWpTSSPack91y+VjbZebGkhEU+coEroKTbtkqMxmXzGdntMgp0+wkXN9BtpKKLDQfnlo2Z6S2DykX2NlMVii+gxoiUQoCeQ4uGALpTztbdDd9k9SYB6TORNBFA0gGi0xRZXQZgPpEv4mVDrP+dz+r17Ri+/KwlDcPQvXBr75W8l7U3AycOz7OK96fwIMspEiPLhrIBQufo4QrDzP+QL3nqtLHrx2u9vN8pDeIj7Tpnzmj6x06HAuwTqxy/bdnkrNn88UV6Wvp9tLayTwtELLHQbSP//WP2DNuGDoYIU1h0EHC4v2CoRoA6bpyR1BorV1QPUShTnT6zWmFn1AP9bCPzfj/AA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This prepares for upcoming checks in page freeing path.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: linux-mm@kvack.org
---
 mm/percpu-vm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 4f5937090590..edc8f4448a8e 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -61,8 +61,10 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
 		for (i = page_start; i < page_end; i++) {
 			struct page *page = pages[pcpu_page_idx(cpu, i)];
 
-			if (page)
+			if (page) {
+				set_page_private(page, 0);
 				__free_page(page);
+			}
 		}
 	}
 }
-- 
2.51.0


