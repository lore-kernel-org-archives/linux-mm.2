Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F76ECCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1638E009F; Fri, 17 Oct 2025 10:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851568E003B; Fri, 17 Oct 2025 10:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2CD8E009F; Fri, 17 Oct 2025 10:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 53E828E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:26:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E76CA571FE
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:26:23 +0000 (UTC)
X-FDA: 84007831446.28.DF3971B
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010059.outbound.protection.outlook.com [52.101.193.59])
	by imf27.hostedemail.com (Postfix) with ESMTP id 09E0E4000E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:26:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HbDsnwc4;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760711181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOj0CFRkwMrfLX7DpH5rcOKDmHKYTqz3E3798StwALY=;
	b=8BK7XfdoBi2IvvEEDE7ZOnw9I0DB7qymZnIghnthaM+A0CXhkuoysBxjI3gtcOogbnT2Ni
	rdl+tWQg/ozEeJ64TadN48UX9P3qUJ1YvyB80WSzcp8NxdAv36nMCM/Tq6or/stTWNex+1
	OyNQgPriuEjPB0ALCvZkj1AE+2bm1GI=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HbDsnwc4;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760711181; a=rsa-sha256;
	cv=pass;
	b=Pa/EPFzmN1bY0tQLr0OUq0AYV+Dojoi5j7+BcKovIwQhF1OyWtdaM9CrIxzM2nCrLx+EYL
	wt4L18NCvPmgYLdkI4yHR11Id9IdHSoq7SPlSIvqI57HEZYsA5mb+xPJk74KMIP1hfSTxj
	UGoJslEx4HvWTvxH4eYFWB9NvMrS298=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jrVhwLhY7WUYDSVRSfJ3ijh7fYvskc8VD+U60Ih6zfMGR68MJyXbrURYBC8jo8z0VSFel16KlYsoGJfjprIendu+R36vY+tiUKRt8rMynoaSjJCHup7a5zOC8wXOukwfnbHelcZAhtO0Ghm2+tj4Hwj9LIGH/kz0wMydWvVJbaXa6bm59VheU1h/3CWXGmv3NJAu6ITVTkPSNfKWoYDfCIZ/IiSbiB3d4EEPXgi+5UrOzOpqU7Tom2jxVmMoXMl3bKXgj8u27/BzX3H8SkOzI7t6ofgnxP9xXAvVDYfQpbW8k+Iy2vIHHgVLQIhqoA5yeA7MmIO5ceeP2/GXQQhoag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tOj0CFRkwMrfLX7DpH5rcOKDmHKYTqz3E3798StwALY=;
 b=Wo8h3WYIniPxcoLKfyN05oYsy2NDgOilbW0cvk+gFP2vsMGx1EJsqLnx5PJ8rd4SCHByt06F12dVrB0LI6xXnDE9EPFj92iJhw1mx1yeU56CF9wt6uN9dUBAyUJCi3na8PO8j1Rk3TIIsHhWopw+6qCZeGJdyPAXPZdHTrhLhOLWgrTmpI9WwtpFQXen6hw3xX4+SQ8cJbC2gthJUh3Ughjivv9E+q846J5RDVsOMjRQgbPJ86ijVdUWLVgAC+ybgkNW6YJT1oThy6et7fn9FrNvCeSVxlMYRakigy6VxKcSz28cBjJgFJZzLKqpwaIvjbaf38xGJ61xuv5fhgFeQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOj0CFRkwMrfLX7DpH5rcOKDmHKYTqz3E3798StwALY=;
 b=HbDsnwc46IORpuXLeyOCFNNOeqDpJenKOYnapIpiVabRQs18WR/rq1AJ92fWeGu7qN6v0Zsmuj4VvWNRsOdonJ7n84n4HjlKWZj9MhRmW1xmZX/H3s+pj0gRbqPfofkbh0hgyrpOqkRycCqliooRHvJ2PDL+3cgR+RV9obP6PAS0FdvUnlhVAzGkbZUsjUR4E8wVOgqrvJPcnDF4YBjx/+RxNDKmt78xwNcYNJSSnzCBvmGPz/3YXuPNqRWwOS/h+IqigiVfKYSSIA4H1dKm4ZcaJZjdYj/7p0jYFvY1QoXQJLCYtE8tIQBonuOKIcA7tTm6x97VVylLy8Fwmfe4Iw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW3PR12MB4363.namprd12.prod.outlook.com (2603:10b6:303:56::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.13; Fri, 17 Oct 2025 14:26:16 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Fri, 17 Oct 2025
 14:26:16 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
Date: Fri, 17 Oct 2025 10:26:13 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <154924ED-0CD0-458E-B760-F9F0A92CDC89@nvidia.com>
In-Reply-To: <7ed84d61-0a7b-4961-82eb-fc8d38b77162@lucifer.local>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
 <7ed84d61-0a7b-4961-82eb-fc8d38b77162@lucifer.local>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0223.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW3PR12MB4363:EE_
X-MS-Office365-Filtering-Correlation-Id: f3fbc390-c9b8-408e-5b50-08de0d89218b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Szg5XCjNaRKJWszImtQ97bfBaPjk0GRN57cGGAamLUyWjI8YHLC/8YxwRaLm?=
 =?us-ascii?Q?moqlHIL7WYw1N6dXZPUz1FBv8BXcdf5eb4bdd/M8JHGsGOJGyz3GtEEotFBa?=
 =?us-ascii?Q?rEGprtdD+FtdSWTP2UGQrLsZYezExjX+9KK4w5FEwBNTO9pWN8FfRo3s9h+1?=
 =?us-ascii?Q?mN6rOhW4z/VndTHPBOW0PqiMMsG9MMlsQvHP0RlT2XOQoLY5RL3JIqxFmhpX?=
 =?us-ascii?Q?yTWNnXwIoNRr2WSTJKsmqtB+fJpCJG7ZyyILymOciTiyVqTy0fkmWkMA/rgb?=
 =?us-ascii?Q?poJXOwtouc0CpPV2Bq3S+0E+cBNSTUTCkljOY51Fyy+QOWWqcaoQfK9xP1hm?=
 =?us-ascii?Q?v1jxz2TPrxZ8bY5z1EQcHaNyAp77GsQHYKtBpBz6XNYpLmarZmTSRhDHuYsi?=
 =?us-ascii?Q?Jg2Ytng2QdUMECUlpYgtPKGFgPsLnVVXpNAXoKvQ6Zgxx3FCQOrq0y8jdD5l?=
 =?us-ascii?Q?Eo+SvDe1WL4BQFFkQNxHTC8xYmwlezQ0a8sv3WpRY+xZoinMpS2rvHY0aofQ?=
 =?us-ascii?Q?DWmXztPkViwdP0EM53C5sizcdeJe4tir+nRNjVxIeOe7NbwwXZ7Iun/kU5JC?=
 =?us-ascii?Q?zUBGkUYpGx76Z7e3e9EZgm2X8y6XlvofC77dBG8JIZgm7da4BHpCkeOXFNEM?=
 =?us-ascii?Q?RX9S6jjwY5e0nmly1wTFgCl2ofuZPDEEl0G3KD3Rn6qwCNPyuW429N814qWD?=
 =?us-ascii?Q?oNr9mLV6tJdHZYaZ9Rxf4+TDj2Y2Tz78ylWramCrusca1tHTAxfTg+H/SeBk?=
 =?us-ascii?Q?AdSI7UdCKZuRJ2N59O4v0di9ZngEJpIChdECIj/XBj+itdPAqcQmpaVcnmLX?=
 =?us-ascii?Q?Ckd0hD3MNCPxprdLxhokG8NxvcbakXAJn72hBUl0ZCexGZcc3iVVkCW0QihO?=
 =?us-ascii?Q?SBDmNDtFYm5vYEHfUaRi6TlsC1N0IEzkgOqyTDL3urTUCJE1HAeGiHLNjsmg?=
 =?us-ascii?Q?wVkPFq1TYmI5dctaHXCqj4Zla99IbBscMe5ue+xE52k0dqjmrwj2pgdmsmAG?=
 =?us-ascii?Q?cvkcIuaVm2B6pNx/wrCpJjl+GoDq16x98oNvMKSBskWz7hDgCtuWldvg1pch?=
 =?us-ascii?Q?3ekgqHy51rHCEmOXKwV9OTK3XnU+W6Klo+LltNYdDSVWt1oQS0G1totKwPpP?=
 =?us-ascii?Q?IlZ5Tg4EefusOa7Lx54KFkxXEI0XX0mEd0GB2YLnJUxprAMh+UQRaO3t2SVg?=
 =?us-ascii?Q?2O+RzJLEv2eQfqqH7DQpb4rKJbGmVFhjb3qz8WFp3Sbik++bMkdyMOdbhjSt?=
 =?us-ascii?Q?OcGNrwCaoYI5AeDohGUgmLySkdDP6bU/NayyGCwHvkGmbIRGOZ3sJgkLnen9?=
 =?us-ascii?Q?2bN0ltmgGqGH+52qwXNyl9BmcDdwklh75ldbGIFtRru3IwLdZMRpljFIvVOn?=
 =?us-ascii?Q?ZYO6kJUz9rAP8vMROpzuPqc6SDpFM4BoV4pHAZYBaf+pHUXGcvP7We67hlZH?=
 =?us-ascii?Q?V8XEe0Jry54jUsX+vwzG1z1wbaOQH2OYB/Ezp7u15/05CMH3hIAzxw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mZp1DyfL6znLaesXhE3bn4DYgAPGFlIXvzDz7yY9T8QLAZj0IkdjJDrnE7bG?=
 =?us-ascii?Q?4bLDMbuEuGvVCojIj7qEOouQ3XS/ymGQtB6YLPiYr87wXdk+j3MRDIUnXnEa?=
 =?us-ascii?Q?7W6mfWrq6H9F3yfPMl0RzhtMbCjnkoygk/MQdB+S+0WaYmunSTtwKqzzQcF3?=
 =?us-ascii?Q?nErBp2Y8sAQSL2AgFf5uzHmSNTqlAejUcpaoDoH6ePdVn+QfC98H9isMlF6k?=
 =?us-ascii?Q?vt6QlLA50DY5M1yg02WDJFA/w6KYSgW2/9URyvN1nhzekC3iLH2tI7giJius?=
 =?us-ascii?Q?oOyJKwLO/6zJzoDIWY1W8UGjqNyJ5Qbs8Rs7qJeud45+1snaMirXwfbNLzBq?=
 =?us-ascii?Q?xANwl/554G5ODJ2j0tF8fckJsaNgJOVna8eJGw9b8AqT2LFopACDcSbKwrFB?=
 =?us-ascii?Q?UhJ4rjhEg3STJOB9g/Q60sqEuPqpsXE60aUH44qiOePxIuKU/FDEKWWthTcD?=
 =?us-ascii?Q?10JBd+z1/vo5f2vdbXSQHNLyU3IByhMR/WNuiFGSA8A/Xbc+ZFm1p8NP9Zte?=
 =?us-ascii?Q?cMDr+MGBmHYf1Zbw67B5J0PvbK4lmDJFZyBTR5d6Ym+oGhblTHc9KD6lTSVw?=
 =?us-ascii?Q?Nue0vi++XN/pJyBDVRLvuGs/Zk/oFvFvZIV/HkBDMnW+p1kDD/CaFVeZ9u4i?=
 =?us-ascii?Q?i0T2NSJUQqhR/prHCyUtmwlOGkgIVL2E/agDm7027g0NrbxlVcUU+sA0VrJY?=
 =?us-ascii?Q?XqqVPYDk5/WmLaEA9pO495V+psBWqc6TnqNYUQI4y4FNLRsyCzTbXeqy/rzS?=
 =?us-ascii?Q?aJLmkhhIZZviQu2dUPcM60MFnyhsujlLd2cPGd2ShZqidfZatbMGndoiRV49?=
 =?us-ascii?Q?9FnfbZuAGvPymhrvnBGgaiPeANXB2SkbQtRs4JQRZgEN9HEgWnUyna6Z5o2m?=
 =?us-ascii?Q?tqH1CVgAkS+N7DG8Xd1JCetTFx/vPucrJbaWkwDLrRRw91XxQvtW/xsUjDdA?=
 =?us-ascii?Q?MJiAtwaY/TUIsq5qyOANL+QjO4QumMgz4rvwOFPnCyhR2neetDmjCtGbKmKw?=
 =?us-ascii?Q?xBpKRcOnqOsX62UjtB74Z698WwHsIROFoCk42fo4nMDJbVB5+wXzeAQVvMr7?=
 =?us-ascii?Q?iVEtDFv00iHXo+z2JEgAFxWrWY9uEa9L+f5u+d1qcdToqAJu4CuSh8hZi1lI?=
 =?us-ascii?Q?mC3RXFAIpkRxLoWXwVuNrunZFT2+E0g+tMJdtS7/XtOabhAmue/HpEZSpD56?=
 =?us-ascii?Q?HCQXWmfNqnZs2TZitn8z0l2npP4izWzjiEcof8Yk2CC8/qmdb0YeuSVEa36y?=
 =?us-ascii?Q?ghVtyah2Sm1PltNpBDE+3c2fg5kAnB0/SU9c7eNp4ZeCX9LqVJNourNVMqT9?=
 =?us-ascii?Q?jhwkaW1r52k8mXvhAxnknPuQxcNcfzJWd1uoF+WacWu4u+CtQgX+78KVeq+V?=
 =?us-ascii?Q?CdbNFX5l+ncy2yN1+RTH/R229jKGGaEbg9EH+OOSChfR3iGAMmFWPYT5IVWi?=
 =?us-ascii?Q?0fYyCBbkHdgYOaq1cS+r4phraLVZOIPMU/fbPW9XGN6PeREU//m0jeag41fB?=
 =?us-ascii?Q?uhxLSokifMRAz9mvooKrvoZ9X7jSl5YvuN617A1tqqMGZUvYpeMomFuU04qQ?=
 =?us-ascii?Q?xZha4j2mxwGjnvjDKfqNhHV86GpparcDAHZm3ClW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3fbc390-c9b8-408e-5b50-08de0d89218b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 14:26:15.9895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aWrpbt5WiuCQcE7ZnmUOCaxtW1eBEXTtbQXBRe/FZwkN6Mkf3D1sPOqrtIk98Oob
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4363
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 09E0E4000E
X-Stat-Signature: h43c4cq1ybjhy6zap41qxybdco13hj1o
X-Rspam-User: 
X-HE-Tag: 1760711180-455092
X-HE-Meta: U2FsdGVkX1+6cnL8KPpNs52DXMVyBJ9GT6ZOiMsRYiBBdNjDA5+UnKNmyBiTHMZH+MTIGv6ziQbWELt3sZLmyFNPHVyqEvM3H2vij2QHkQk5Iefvode9xqm+4vOFX0bpJ2SIgimx8sJrqOdHgDnDffyfb0uDsCTQ2dc1CQNLgCrylSu+4iGLbQT3zLFRaL9BG22NJH0Mzwepsjnm11uQ7ezT4CPSBbXFHGw5yTOfS17pC46RkJTx81QFmYzNlSkoSCW5TX//Rsn5yHk3JXPMGOb84ERg/tjOrlnBPsG8MgcTXgqhOX5AA+5hRxR1YaRYLj1FUOnCm15hFm30Cuq2Jcmjs+z/CLXGPumXiPN56N5XnYuRngksqQxMqa47xqL10ZsHSGQjRciSo4u9WjMiAKJD6iXrdB25IXpTdVoIQASH1k536FJViBC1m7jqoccXibabFxQAk0UMmnRdXu5lVYPGWBl3Z9xX/FG+cBGz1p8mQcn56ZO7W/03dpTsrAyELVtsi38Dvp8rS4DzA1zx88I3AnTke+dx/4hf6+br2p9UxYgULVDQH9jU+S4Pg2sGiOyyOTxEtzXK3KkeA0Kwqmx0bv36NewWutrYobkax+0a8LYBSa4SREMxLrkJFCWyMD9NnBdPXkuOSWqmL9X17npofX7tfpV+icYdqKQxPxQ1N6XLZ0tDH4omBw7ziWOCARZD45izCFsZBsQorX+glfbwZkB9HAA6xxLFIfrAd4Ldnx5ZymYAHwrH2ZYc4SJ7BDZ+8OktJi96aPfBus9eBz6GQwkH7sWARO6+8NvEkgo+eRGKFVAZhef2nCPqKg9EF1opdfpxyKfXW2LzIjbFMa2cMXm+kpjOAlKwWADvR8CljtgG4DI5WwHBHXJBOvDv5EPv/Iv3vxnuqq2J8pgxJRPmYssYnQLi3DOUNt0F2AC3UCb4fb0+Ufb1bbQXa3Shv73o5nUNX6+1fpLtTG0
 7d5/T27B
 rq5hyO4Cl1Jf1jTSwdiTUkGf16L6K1SvqQLYo+ThIyx6atv1T0z1Zf/dpL8CRkuAYZwfDs80PcMkbCAOfk3L3tKp3QaHNTfSfyBCCyw/9Cn/Dy/b7BllCaFrgVRfnMzj3iRARZ8EvRjl4eZAZwXuA/WR3AV0yCDSgzuzttOeRRNBbch6CnHpRx3bdmETuln9yJNw7oHIG7UxiDHexdnBScGCaphZWNKN+lUBWJz4/t5apxs0GdQsunHa3xKC+TM3KynqTjTFMGVMc0h50H6lYXdp39sJT6Nvk2Pu2Oj1q/DkJ+IQoLtPLRDxycZ/aT+H9FGVKyjxsZfw+Uu4a8iBs2pzlcyGRiIobi7Yd7AMnvQKzMNFlfvayeTKQRSW8emons3rxXLnAp2bF13csnrnyWD+/G/xesKAs/M1SNW/ltX/+lzMJ1TgkjGcrSJ8mNT+/1XzdHoE0YdLQYOFbQxMUVWJsK6BqXrr4eJ3yoYtVTAKT42LdQtwRarqt4HkoCssoKKeSpdpBi4EVnyiRUvD5j++GdOmgfgleHyve/MCkFQDO5zv27YGrbq/er/HiZNbolt6Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Oct 2025, at 5:44, Lorenzo Stoakes wrote:

> On Thu, Oct 16, 2025 at 12:46:13AM +0000, Wei Yang wrote:
>> Existing __split_unmapped_folio() code splits the given folio and upda=
te
>> stats, but it is complicated to understand.
>>
>> After simplification, __split_unmapped_folio() directly calculate and
>> update the folio statistics upon a successful split:
>>
>> * All resulting folios are @split_order.
>>
>> * The number of new folios are calculated directly from @old_order
>>   and @split_order.
>>
>> * The folio for the next split is identified as the one containing
>>   @split_at.
>>
>> * An xas_try_split() error is returned directly without worrying
>>   about stats updates.
>
> You seem to be doing two things at once, a big refactoring where you mo=
ve stuff
> about AND changing functionality.

No function change is done in this patchset. The wording might be
confusing here, it should be read like:

After simplification, __split_unmapped_folio() directly calculate and
update the folio statistics upon a successful split, so An xas_try_split(=
)
error is returned directly without worrying about stats updates.

David suggested a change[1] to make it clear:
Stats fixup is no longer needed for an xas_try_split() error,
since we now update the stats only after a successful split.


[1] https://lore.kernel.org/linux-mm/518dedb8-d379-47c3-a4c1-f4afc789f1b4=
@redhat.com/

>
> Can we split this out please? It makes review so much harder.

I asked Wei to use a single patch for this change, since the original
code was complicated due to the initial implementation. After my
recent change (first commit 6c7de9c83)[1], __split_unmmaped_folio()
can be simplified like Wei did here.



[1] https://lore.kernel.org/all/20250718023000.4044406-7-ziy@nvidia.com/

>
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>
>> ---
>> v2:
>>   * merge patch 2-5
>>   * retain start_order
>>   * new_folios -> nr_new_folios
>>   * add a comment at the end of the loop
>> ---
>>  mm/huge_memory.c | 66 ++++++++++++++---------------------------------=
-
>>  1 file changed, 19 insertions(+), 47 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 4b2d5a7e5c8e..68e851f5fcb2 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3528,15 +3528,9 @@ static int __split_unmapped_folio(struct folio =
*folio, int new_order,
>>  		struct address_space *mapping, bool uniform_split)
>>  {
>>  	bool is_anon =3D folio_test_anon(folio);
>> -	int order =3D folio_order(folio);
>> -	int start_order =3D uniform_split ? new_order : order - 1;
>> -	bool stop_split =3D false;
>> -	struct folio *next;
>> +	int old_order =3D folio_order(folio);
>> +	int start_order =3D uniform_split ? new_order : old_order - 1;
>>  	int split_order;
>> -	int ret =3D 0;
>> -
>> -	if (is_anon)
>> -		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>>
>>  	folio_clear_has_hwpoisoned(folio);
>>
>> @@ -3545,17 +3539,13 @@ static int __split_unmapped_folio(struct folio=
 *folio, int new_order,
>>  	 * folio is split to new_order directly.
>>  	 */
>>  	for (split_order =3D start_order;
>> -	     split_order >=3D new_order && !stop_split;
>> +	     split_order >=3D new_order;
>>  	     split_order--) {
>> -		struct folio *end_folio =3D folio_next(folio);
>> -		int old_order =3D folio_order(folio);
>> -		struct folio *new_folio;
>> +		int nr_new_folios =3D 1UL << (old_order - split_order);
>>
>>  		/* order-1 anonymous folio is not supported */
>>  		if (is_anon && split_order =3D=3D 1)
>>  			continue;
>> -		if (uniform_split && split_order !=3D new_order)
>> -			continue;
>>
>>  		if (mapping) {
>>  			/*
>> @@ -3568,49 +3558,31 @@ static int __split_unmapped_folio(struct folio=
 *folio, int new_order,
>>  			else {
>>  				xas_set_order(xas, folio->index, split_order);
>>  				xas_try_split(xas, folio, old_order);
>> -				if (xas_error(xas)) {
>> -					ret =3D xas_error(xas);
>> -					stop_split =3D true;
>> -				}
>> +				if (xas_error(xas))
>> +					return xas_error(xas);
>>  			}
>>  		}
>>
>> -		if (!stop_split) {
>> -			folio_split_memcg_refs(folio, old_order, split_order);
>> -			split_page_owner(&folio->page, old_order, split_order);
>> -			pgalloc_tag_split(folio, old_order, split_order);
>> +		folio_split_memcg_refs(folio, old_order, split_order);
>> +		split_page_owner(&folio->page, old_order, split_order);
>> +		pgalloc_tag_split(folio, old_order, split_order);
>> +		__split_folio_to_order(folio, old_order, split_order);
>>
>> -			__split_folio_to_order(folio, old_order, split_order);
>> +		if (is_anon) {
>> +			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
>> +			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
>>  		}
>>
>>  		/*
>> -		 * Iterate through after-split folios and update folio stats.
>> -		 * But in buddy allocator like split, the folio
>> -		 * containing the specified page is skipped until its order
>> -		 * is new_order, since the folio will be worked on in next
>> -		 * iteration.
>> +		 * For uniform split, we have finished the job.
>
> Finsihed what job? This is unclear.
>
>> +		 * For non-uniform split, we assign folio to the one the one
>
> 'To the one the one' you're duplicating that, and I have no idea what '=
the one'
> means?
>
>> +		 * containing @split_at and assign @old_order to @split_order.
>
> Now you're just describing code, and why are you making it kdoc-like in=
 a
> non-kdoc comment?
>
> I mean you're now unconditionally assigning folio to page_folio(split_a=
t) and
> reassigning split-order to old_order so you really need to be clearer a=
bout what
> you mean here, given there is no e.g.:
>
> if (is uniform split)
> 	break;
>
> Something simpler would probably work better here.
>
>>  		 */
>> -		for (new_folio =3D folio; new_folio !=3D end_folio; new_folio =3D n=
ext) {
>> -			next =3D folio_next(new_folio);
>> -			/*
>> -			 * for buddy allocator like split, new_folio containing
>> -			 * @split_at page could be split again, thus do not
>> -			 * change stats yet. Wait until new_folio's order is
>> -			 * @new_order or stop_split is set to true by the above
>> -			 * xas_split() failure.
>> -			 */
>> -			if (new_folio =3D=3D page_folio(split_at)) {
>> -				folio =3D new_folio;
>> -				if (split_order !=3D new_order && !stop_split)
>> -					continue;
>> -			}
>> -			if (is_anon)
>> -				mod_mthp_stat(folio_order(new_folio),
>> -					      MTHP_STAT_NR_ANON, 1);
>> -		}
>> +		folio =3D page_folio(split_at);
>> +		old_order =3D split_order;
>>  	}
>>
>> -	return ret;
>> +	return 0;
>>  }
>>
>>  bool non_uniform_split_supported(struct folio *folio, unsigned int ne=
w_order,
>> --
>> 2.34.1
>>
>>


--
Best Regards,
Yan, Zi

