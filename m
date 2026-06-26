Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 095C4C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 13:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC1BE6B0088; Fri, 26 Jun 2026 09:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98786B008A; Fri, 26 Jun 2026 09:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89B96B0093; Fri, 26 Jun 2026 09:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 738306B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:24:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EFC441676A2
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:24:17 +0000 (UTC)
X-FDA: 84922132554.30.1001E71
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012052.outbound.protection.outlook.com [52.101.43.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id F394B40013
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:24:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KrDE55vx;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782480255;
	b=P7r0/qpuCttMW3kfdaSEts5NMF7HLGHPKJ4qYm/tgV8Yd3m5VETY0iab1KrT+wWamP9fQc
	nfASGduS157TOdZb1omgMbP2EGwlCvglqk8g6kQDmetVts6xD5D20LS6rh7OO7UP6E/KiL
	udirYCaBR+cSmaisrMh1VQZn5/jieo0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782480255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vzYCDRjyAWKYeHd/9+T3s6QkafS6NdIGSo+ake8xc1M=;
	b=Ih+gOORMyTJUdwUsASaeIb8AubZAtV7pwlRAV4vJyaIh3BGsCCCbZqv+E30uh7GQWR7lX7
	OpnHXTJjwrKV2+LXbF441GKbzP2NiJs49L1mhCylreramlidchgAgCl/vPgTxnxBvYt7fK
	ChaGA4SKuEsnSz3E93oLqJcN2tUFT30=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KrDE55vx;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xsDIbSMAQK0pyTdGnupddFiLBCIsM7s0VOkuXH3C5ss74CcRRl4C6lDj5zJelZ7/ptnGIkkqPhNV2vce3THY+EVFgRoj48ZFUiil7KvE24sPWXgcybWZYrHfqYyY6LLJ7BnxhN45Gr7wei2MYXAYNE+HI4Tr2P0j3DKQTkiXdnoycUlLGN1P5LOaOOkZeKU1tB18gGtYSw7OnnZgRITiHVuUXiUDq7XHxU/f/DWFz0RyRYzbY68oGJcJAEcAn2pROaoq3sG62CYRVDKMySx56gj8L1twJs/oDH65iIb+GYugBWdXeryLigEd1RNkn1EEKe040BIwNJCxF83KjSMEyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vzYCDRjyAWKYeHd/9+T3s6QkafS6NdIGSo+ake8xc1M=;
 b=zN9KFfktGXXxSIGDm+asTxwBCUYaR3vjUt6XBAYie8TS5OMzDh0cAuLZTcnpE3qfwBQ6GQzjVn8Ntcbf8GlkyS9kL2r1VSx077+92H5zP6mKYi6qDm+ZX9NTmq/Jtu9i7jflcque8JLKdcTpoDsd0fj0F3BBZQxmp+qScSTF7OvgqeY9nTmMKwwfVPpohCysv3lSM57DRwgadV7HkaNkm3cetoxcKqxLJ+Hwr4QCIQxBmHrCCMcmcXVSxYrwfIG0xgEHAiVOX1dJPgJchs31tUBkKv4Ui+N4DNFxOhmWvBfCeRpsjD9NyWlyUKcAHtSxNc4hjd12jlwuUfIfU551iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzYCDRjyAWKYeHd/9+T3s6QkafS6NdIGSo+ake8xc1M=;
 b=KrDE55vxhO2I8bSXwnr/RkaeMT7/IuOZatm2OQ+9PTd719PBUIInvFOTNX2D6KHP97QHIqc0/nhDdnwTUP5x5vvOBTnjAGSF8pUzRbm21gzSJBxg/CTvwZpNAVLGbQTNVauqdbcFvykGTlrKYeJzinu2HKoLkDaxCseLO9sKJC2019zNvHPI3/qnVpAIR3VoloCoCpuEUXeIOvRx7m8n3hvEjfC/RkGwVP7CFsgM07ATBsC2R4RqJIfPyFmwmkeMg5+MBC5dZRh2O4ogZHaHWSajQW0m9DP2VEPn3PyPZvIiOwV1cSD2hs76qctigY2z3xHWcrqEPnH53ftUyi8fvw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB6847.namprd12.prod.outlook.com (2603:10b6:806:25e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.16; Fri, 26 Jun
 2026 13:24:08 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Fri, 26 Jun 2026
 13:24:08 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Wei Yang <richard.weiyang@gmail.com>,
 akpm@linux-foundation.org, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, sj@kernel.org,
 balbirs@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private PMD
 handling
Date: Fri, 26 Jun 2026 09:24:06 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <7AB41DDE-42E4-4EDE-87B8-CF47BE0C6DD1@nvidia.com>
In-Reply-To: <f9290e0c-0841-4b02-baf7-8f03c4cf800e@kernel.org>
References: <20260624065353.1622-1-richard.weiyang@gmail.com>
 <d060cadd-34f8-42da-b7f7-c8d295050436@kernel.org> <aj5XVwsQ4rOLTzr5@lucifer>
 <f9290e0c-0841-4b02-baf7-8f03c4cf800e@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR20CA0056.namprd20.prod.outlook.com
 (2603:10b6:208:235::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB6847:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b0d413d-b92f-40ba-5ba3-08ded38633d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	tkTjURyJPo92X69x71oJTyywQgiLOGYLwB8cWScUSk2haSKDPzxDbWG/RPqMfaGaGif/yhuebBgckN6qrcMg16Lsj6bE5cl4UMXXHrqdG7jXYExtoff7yDynojMqJ4hB6QbmTV1Aj4U3SsHHpgG8tueQogRyAuXldLQT+kqupOnND9DaN7CQ8o8heQnEG3z2Qy77lgHyX8a6rjW64OoY4WsFElld+ioNeGN1jz8m1Usyu9VaWKFaXqQF4cgFpVTIbSZWJrv1Zln6lU3mfaryQiP9raWs7kJJDRdVdNhYykmV3sY+cfD3vEFpb2Uo6cGHu0tkDrYZMCAIn/lt20U88DnF2kNBU/nFyHmhoR+uVOi2NmuabJu9ErS+m1bDj6ZGVbbc8OUxsIONoW9d2el3vR9r1/vD/OblNZoH6EelUPa4m1WqNos1Sj70T3VMomH0IfwKSm1+Jzt1q6M07e5orJx8RdIK+zwXvRheqBvrWi+eCA2JcCte+IH/wkAs8xOTG88ocrN+B1R1GR0FVZBa3A4CAURlgUhCasYBOzYqSZabMEDYPnGk5LqmPvTi/KGWBV8r3UaQucildWtHsF46nviA+zxBBqQRBGk9p5R8oBcUaffFLeElUnL5CyVFbZ2W0zq7lCU0JGfkrh0QxxoA1q942g81J/oNzLYncs09ZiY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?60K9/LzbDuZiI9pQj87iAJY6Uu3RAyBrK/ql0kcRpxQDsQf5KFCvGyuOucc7?=
 =?us-ascii?Q?1NAHm7uR+DOH3S6gT7ANRtSjIHSPLwUR636dXvgUZJkeeW9PmzzZ0XwTlKJ/?=
 =?us-ascii?Q?0RFvwPqpc+A/o7fkWCVxiWG31nZTHDoh8QdUFgSshD9/dNDGKVIYQISPQX/c?=
 =?us-ascii?Q?v6sUgDFwWgr5iC/gmrUSHU4LTNUao/eb+r9uXb8xHblJywCBhbakTAKxBnHF?=
 =?us-ascii?Q?Zt+isG1GdWR//PGc4J7eNUj4Le66JKEKRilEsrTKZIh1H816CoZRIA1VYN7d?=
 =?us-ascii?Q?yhtZTfi3nyfjKnET5chp9dQFm28WDc0ozfLrfJf1hsLn66h81AaAOeaqdrDL?=
 =?us-ascii?Q?JI7wPkttxZhy9cdtHq8BUWlgd56lEdjqLOz2+otFDKSn2Be4L9pimrWkCq9t?=
 =?us-ascii?Q?tj6lbwhOesu4nUyZI6GjdBPLe9DlywpX2geJBtwtftXfipkVMlYmpOtVp66W?=
 =?us-ascii?Q?4z7JApUdHX55JkwkgUwxsgE23YULmUrG9SB6woaUNuaMqpBZjHqE3aAtwAzP?=
 =?us-ascii?Q?iskKzFnGr1sh/NxQ7Pm3h1lX/2D0R/mwcwlaKcBgttL6E0U2AYtDD68Z0qCy?=
 =?us-ascii?Q?002mHwXsy66Oh0M3OQiav/jA8nOVCScjofziSmj2JA3LB+IJrtIpq1dIiswP?=
 =?us-ascii?Q?wEyHS6ytWTx/Nd5HJ1kAkBLr0a+tfhWK1U5h2Az0nRS4imF3LFGyqZ1UhLuq?=
 =?us-ascii?Q?0sHtp8tBj13l/r0R02GkaqFrMnxHQ9U9P5RAVlzKE2zejgovYdQ6sB9HNEeJ?=
 =?us-ascii?Q?bq5DH8CxBHXbsocSZja+djWbVAHGTYtxYRkfeCRN4NJqHLChM8cpgRCgbf/t?=
 =?us-ascii?Q?h/y+cl+bt41L19iFnSaubMnJbQRAfvf/7bgMqovElXCl5zUYBpNlHTjJrHk2?=
 =?us-ascii?Q?Xi/aFQhU1ilJP2pP0MhFiXsZn7pKYK64D5jslGY23/DqLKXsQr+OSPYKRqxq?=
 =?us-ascii?Q?7RhHOfbL68oYKLdsvbl9y20x6teSc+ci71wvkAIo0Ovc675AnNBaEYiqKA/Q?=
 =?us-ascii?Q?HPKxUr7WD51ov5vo6rhy5lpRYjCesqT62gDCyrI0db7AMuDMnWGRKd8s0EuD?=
 =?us-ascii?Q?rgY+EH9eP49d1QynDfSy15QeY9EidCXcwed7ICI2UUHWzNF1ohIzaFgBwhnr?=
 =?us-ascii?Q?ADVK6G+82w2TzXjofTv9XzvGTBPZIYpl5oS2LTf9jmLXCpmkCzRv+L++OT38?=
 =?us-ascii?Q?6ECMMDSDnoQsKtCi6vjpGDLOJPcSgfhC9u4k99owcPmEwCytGaTNUPhjeO9q?=
 =?us-ascii?Q?CE4Bv572nM7jYe/BWB5O0oEeJvHvNI9aNmINzOPNe5h2K3tnHqm2H8nvd71m?=
 =?us-ascii?Q?7Gi17vzFWHLwJMW4sePOeJ/xPzQ+P/sRvZyszOfu9JCGNsm0RfUet09DOmqg?=
 =?us-ascii?Q?fqXJch1gonvBE57pkMRSjrKtKs3hJfCUHwQmVy/J+iNlEJ1bGhv9wgOQO7+Q?=
 =?us-ascii?Q?9S8m/uks64iYan9JXe/3dVkP4WqCfhpdtLpPmQG4REHETcvoj7hX9ozT0EPu?=
 =?us-ascii?Q?xAH7IQN8kJy/jW9Q54uXaAo+0ysgt/0zV/ea0neFNpZkAcbas34YtYFWV4EN?=
 =?us-ascii?Q?M4L1ROQ0xrFW0sVQmWj+BuokxtXWzrcUBhvw7N1PnaUxekDyvtl/GVKNFdOW?=
 =?us-ascii?Q?e379o8lQlNG5vAZjuOJeyQ6iba116VYnfY/IgpiQQC9312B5TB9Lj92eqzq3?=
 =?us-ascii?Q?mIoHgne516Z6rP3XAOblDZBSQ6xONW5skxYMjN3AvKl0l8pD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b0d413d-b92f-40ba-5ba3-08ded38633d6
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 13:24:08.3170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4eiSQYLDM6SYLH67s73aoNNajJuYu+BTWvhO0lnY9pxCGw+DTf43dZ6r0nGIjg18
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6847
X-Rspam-User: 
X-Stat-Signature: 8qjifa8nwrskht3x3jnaooqb7frcgfk7
X-Rspamd-Queue-Id: F394B40013
X-Rspamd-Server: rspam06
X-HE-Tag: 1782480254-473519
X-HE-Meta: U2FsdGVkX1/Ula4XeQv/mp4BPOaldOpZfmCf1DHqQRoWZCWiqXbsMW83OqSuWfcvl0zpgABcHpTztxR8RSTXTz8/xqd/TD/1nOCCJGRlFQzvqjxbW+MNzW3SQtdbyDJ2Pp8IsQftYKzhj/5hoiAB+zlgzENp+oF/9zx4c0iqCigO2ipkTFhNNOT+oAJVBrgCOf1bndj0WSQpqGLmA/Pfh0OwesgM+kBpJU7Qttgi+S4ySovNjiaCs5CeIp1FNz0BUgdeAc3m8QTuS/IRRRp24YbHOL4F4omJhk6UecFe8XPpkxTc6ad2u7xe0a4hP3LW8rOf2kTyHy1Z03xQmH/uOK1f3TRX6bfKQ2MjYCWzffBoNpX55bjOtelaDA13hGmzU2sEJuzzOqBqTEZCqqrxnMOr6EWPUOZBo0Iaj+etrJxrNnR/UdpLijOqm4Z28AqevEEFE98ZtqwI+quWvHBvYB7U5OEC/4f8uSEyGjQinnLzu/SQ4I2VLjcyozO0IA2jpxfqVrLw8oy/fqqyMV8mwKqlK2XS+gyH5Kj/MSGXMZFwkhns1n+QUfKPsoD1B9uCI0qIBUUqKrzxg7wSTZ3rVthpimxR/Pq6v+LrDK7n4IQLeO/todjDuUN8go98onRG9ZBp/g2Np8I0XoAwVmNsXi4PpOmy3Xw7bvX7unG1Lfw5fcbw95W92tdkxPBYBFNHkCk/IC6ucROPI4BMZeEcwk1OBYq0Ixl99BAhnQzKZZ8B3KrlVdFpQcLvkYbgMDacGFSWvHy1AcjOoxA5X3de9/+6G5MrrAbxzupKFCbH7rU6LdxJK1lXHpnHx+cBm/gXtsSf36NJoWvW8nYUSX2Y2o1FIdTSEvIOvz7DHxnfAfNh20jRnncfTdR/186zKRuGZ4AhusT08oe3ej7qvkgeWRNNfDx/n0v/276n9hC+jVYCcEpOjxq6J0iHZTPnRm8t6ZcY4vLEbdjjbeKCBk6
 Ykt9y+b8
 VFTK8eWtOf9QWLy3NvIwJct/L1yWhGI3RW+j5azacSgY6Jos8jDAaCaEWWhb768Y02E5kp5SCurk2pU84QG9x9HAVSfBtRP/FlxwP3NLwFX1a9SawSufeEKvJqBd1TPi0r8U5BSOVkxxaSVdJ3ul94KCNPfl0QXU4xavFvJumaOj96r4vbM1z690Sf06WbdLIRJ+rpmbUHCdcVHT8BJrl1ziIQnI8paq9a4ebWlRom9Vrq1uOEuVUe6U/MXhEx9FcuMoHrikHmPlVqpJNZT31iyU/m7CpUKR3UM7Upp7ypBWajQ5/AtjZZ/ebI5v7cZNWdFnEbcpsNcesxu96fdlINmGTy3UBYxyviPY/nuDbY0RDBjoaYj5nkJsxqjlJFuL54p2/ImnXBJwXkRgqpOwmm8zolIS7+fsufCvb78F1hJM1p/8hw4NyKIbHnagu4icSWD0c/REG8yuKyQiioxzJydxLw3q3urlt8U6B4xLdgJjcq+Pye7GudpVs++4CwPXq4Qclx6lbe4ebkid+XFvKUDfG2HhPro50knx0Dx94IeOBP+DpcnWIQhHDFTkkWH0/GiPlk4nTF9hg5DcCa3y0LrJ+tfxDVdUjnDfA6r2MpQd/oeM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26 Jun 2026, at 7:31, David Hildenbrand (Arm) wrote:

> On 6/26/26 12:42, Lorenzo Stoakes wrote:
>> On Fri, Jun 26, 2026 at 12:07:56PM +0200, David Hildenbrand (Arm) wrot=
e:
>>> On 6/24/26 08:53, Wei Yang wrote:
>>>> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
>>>> device-private entries") introduced the concept of device-private
>>>> PMD entries, but did not correctly update the rmap walk code to
>>>> account for them.
>>>>
>>>> As a result, when page_vma_mapped_walk() encounters device-private
>>>> PMD entries, it takes no action other than to acquire the PMD lock
>>>> and exit.
>>>>
>>>> However this is highly problematic for two reasons - firstly,
>>>> device private entries possess a PFN so check_pmd() needs to be
>>>> called to ensure an overlapping PFN range.
>>>>
>>>> Secondly, and more importantly, if PVMW_MIGRATION is set the
>>>> caller assumes the returned entry is a migration entry, resulting
>>>> in memory corruption when the caller tries to interpret the device
>>>> private entry as such.
>>>>
>>>> In addition, commit 146287290023 ("mm/huge_memory: implement
>>>> device-private THP splitting") allowed device private PMDs to be
>>>> split like THP mappings, but again did not update this code path.
>>>>
>>>> As a result, we might race a PMD split prior to acquiring the PMD
>>>> lock.
>>>>
>>>> This patch addresses all of these issues by invoking check_pmd(),
>>>> ensuring PMVW_MIGRATION is not set and checks whether a split raced
>>>> us we do for PMD THP and migration entries.
>>>>
>>>> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support dev=
ice-private entries")
>>>> Cc: <stable@vger.kernel.org>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Suggested-by: David Hildenbrand <david@kernel.org>
>>>> Cc: David Hildenbrand <david@kernel.org>
>>>> Cc: Balbir Singh <balbirs@nvidia.com>
>>>> Cc: SeongJae Park <sj@kernel.org>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: Lorenzo Stoakes <ljs@kernel.org>
>>>> Cc: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> ---
>>>> v4:
>>>>   * refine subject and commit log based on Lorenzo's suggestion
>>>>   * put pmd device-private entry handling in its own if branch,
>>>>     suggested by Lorenzo
>>>>
>>>> v3:
>>>>   * remove cleanup part, only fix the issue for device-private entry=

>>>>   * refine user effect description based on Lorenzo's suggestion
>>>>
>>>> v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiya=
ng@gmail.com/T/#u
>>>>   * specify the possible error case of current code and user visible=
 effect
>>>>   * besides fix, cleanup the pmd entry handling based on David's sug=
gestion
>>>>
>>>> v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.=
weiyang@gmail.com/
>>>> ---
>>>>  mm/page_vma_mapped.c | 20 +++++++++++++++-----
>>>>  1 file changed, 15 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>> index 2ccbabfb2cc1..17dff8aab9f9 100644
>>>> --- a/mm/page_vma_mapped.c
>>>> +++ b/mm/page_vma_mapped.c
>>>> @@ -269,14 +269,24 @@ bool page_vma_mapped_walk(struct page_vma_mapp=
ed_walk *pvmw)
>>>>  			/* THP pmd was split under us: handle on pte level */
>>>>  			spin_unlock(pvmw->ptl);
>>>>  			pvmw->ptl =3D NULL;
>>>> -		} else if (!pmd_present(pmde)) {
>>>> -			const softleaf_t entry =3D softleaf_from_pmd(pmde);
>>>> +		} else if (pmd_is_device_private_entry(pmde)) {
>>>> +			softleaf_t entry;
>>>> +
>>>> +			pvmw->ptl =3D pmd_lock(mm, pvmw->pmd);
>>>> +			pmde =3D *pvmw->pmd;
>>>> +			entry =3D softleaf_from_pmd(pmde);
>>>>
>>>> -			if (softleaf_is_device_private(entry)) {
>>>> -				pvmw->ptl =3D pmd_lock(mm, pvmw->pmd);
>>>> +			if (likely(softleaf_is_device_private(entry))) {
>>>> +				if (pvmw->flags & PVMW_MIGRATION)
>>>> +					return not_found(pvmw);
>>>> +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>>>> +					return not_found(pvmw);
>>>>  				return true;
>>>>  			}
>>>> -
>>>> +			/* device-private pmd was split under us: handle on pte level */=

>>>> +			spin_unlock(pvmw->ptl);
>>>> +			pvmw->ptl =3D NULL;
>>>> +		} else if (!pmd_present(pmde)) {
>>>>  			if ((pvmw->flags & PVMW_SYNC) &&
>>>>  			    thp_vma_suitable_order(vma, pvmw->address,
>>>>  						   PMD_ORDER) &&
>>>
>>> This is extremely hard to review given the existing crap handling her=
e. I'm
>>> really sorry, but it makes my head hurt (I'm not kidding :) ).
>>>
>>> It's completely unclear why we only have to check for a subset of the=
 cases
>>> after taking the lock.
>>>
>>> Could we simply extend the existing migration pmd handling and leave =
the
>>> !pmd_present() case for pmd_none()?
>>>
>>> That leaves no question to "which transitions are actually allowed", =
including
>>> "could we accidentally assume something is a page table when really i=
t isn't".
>>>
>>>
>>> So what about something like the following?
>>>
>>> The "thp_migration_supported()" is not required when checking for
>>> pmd_is_migration_entry(), as that defaults to "false" when not compil=
ed in.
>>>
>>> Untested:
>>>
>>>
>>> From 048ecd33673ec649e168fbbb97749a7c0e344fcd Mon Sep 17 00:00:00 200=
1
>>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>>> Date: Fri, 26 Jun 2026 12:03:40 +0200
>>> Subject: [PATCH] tmp
>>>
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>>  mm/page_vma_mapped.c | 29 +++++++++++++++++------------
>>>  1 file changed, 17 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>> index 2ccbabfb2cc17..ed2a23a90e8dd 100644
>>> --- a/mm/page_vma_mapped.c
>>> +++ b/mm/page_vma_mapped.c
>>> @@ -243,21 +243,31 @@ bool page_vma_mapped_walk(struct page_vma_mappe=
d_walk *pvmw)
>>>  		 */
>>>  		pmde =3D pmdp_get_lockless(pvmw->pmd);
>>>
>>> -		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>>> +		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
>>> +		    pmd_is_device_private_entry(pmde)) {
>>>  			pvmw->ptl =3D pmd_lock(mm, pvmw->pmd);
>>>  			pmde =3D *pvmw->pmd;
>>> -			if (!pmd_present(pmde)) {
>>> +			if (pmd_is_migration_entry(pmde)) {
>>>  				softleaf_t entry;
>>>
>>> -				if (!thp_migration_supported() ||
>>
>> Do we care about this? Or is !tmp_migration_supported() -> implies you=

>> wouldn't see a migration entry here anyway?
>
> Yeah, I noted above
>
> "The "thp_migration_supported()" is not required when checking for
> pmd_is_migration_entry(), as that defaults to "false" when not compiled=
 in."
>
> Given that
>
> tmp_migration_supported() -> IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATIO=
N);$
>
> And
>
> pmd_is_migration_entry() -> softleaf_is_migration(softleaf_from_pmd(pmd=
));
>
> whereby softleaf_from_pmd() only returns something non-none for
> CONFIG_ARCH_ENABLE_THP_MIGRATION.
>
>>
>> Maybe worth a VM_WARN_ON_ONCE()?
>
> I think it was primarily a a hack to slightly optimize code generated f=
or
> !CONFIG_ARCH_ENABLE_THP_MIGRATION, not really something for correctness=
 as it seems.
>
> So I think we can safely drop it. :)

thp_migration_supported() here is legacy code[1] from v4.14 when I added
the THP migration support. IIRC, the purpose was to avoid checking
PMD migration entry if the support is not enabled, but looking at it agai=
n
today, that thp_migration_supported() is unnecessary since
is_migration_entry(pmd_to_swp_entry(*pvmw->pmd)) returns false if
!CONFIG_ARCH_ENABLE_THP_MIGRATION.

[1] https://elixir.bootlin.com/linux/v4.14/source/mm/page_vma_mapped.c#L1=
57

Best Regards,
Yan, Zi

