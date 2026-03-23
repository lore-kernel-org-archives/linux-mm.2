Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78E13F483E6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E72046B008A; Mon, 23 Mar 2026 15:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E22FE6B008C; Mon, 23 Mar 2026 15:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC3A96B0092; Mon, 23 Mar 2026 15:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB2CC6B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:07:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71815C3C89
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:07:08 +0000 (UTC)
X-FDA: 84578260536.27.126A589
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012043.outbound.protection.outlook.com [52.101.48.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 88AC04000D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:07:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pFleVGoB;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774292825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8O+f7qd9atNjedwWxjNpgH7Bw9TaVnZDnBEr44WoG0=;
	b=I6p6UXlj83mdzeCDwBKQBgZLNHcDRcAhxxtWLvar6xYelVTj4E+gnp94pztLw14Em7A86P
	XmSVoCnspni5htdu2G6YWv+85aakwlQWS/jBDfp4VKyHirUweWUmPNmPeH+ZdysOJJIfxs
	sfEP8pz3MErJaL0eqaAZJsLOnlMD7Mg=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pFleVGoB;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774292825; a=rsa-sha256;
	cv=pass;
	b=nYBoTV1XdH9me/YdxvDYKMC3RKE4j9w21L5IJpoYiP4Hdd5cQGKkYiyLFeJn4lsZWxbk8I
	e65uLK8HnxMVIiK1ArQrZcqgaiE11Wd7+R8qwo5+aLtmzXxgA9cheDVSAam1nri2ZK/SK7
	87ysU5/mck0FH6itWzv2KIGXlItwiX4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ayvcpbzg40k1GCs/vODnm+loT0IBYPKkBXGlvufIDUw60jfo3TLuDf1hoQ0En8sB/CuIbIW4g3c3XGsATQK/h2YMjNYp0PLU6czop5Pp6Zq/YRD62JRdvgBeNaBf43EcLLDgkJ3rXYwBgAvWSm7IEvAuZKJ0Pra3+brye7MB7BCrgRR4ikA2wXajcWASnQtoAr+beEOi5BNYIDDV1JxaVdCOAiEb/WIc6UBmW95MkMF+iZznoL1sjc/2qhJzQfhUsu+PC/W9XTfclyy9XHxhFxKKOrY7gaAPC2MLThGbAsALyOJqAk4U5RwR3lD//aCqeiJiDYoT+8TTHrJwqkoETg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D8O+f7qd9atNjedwWxjNpgH7Bw9TaVnZDnBEr44WoG0=;
 b=JfNheZFZrYHFE8RfdmyKlb7AHj5DowQqlXcpkx6XXtQ7aS+AmodLypa8TK4OpGydPzjfM/y/Ag+uo9Udttzijekc18g4OJJbLT+P2LcxqO0ob+NEgSQn7Jq7Mm/ld2gCaK+tfQ2ETGbuaw2DJcklaHPwrgRoePbuvC8+qWptge05bDb0xTRRNNVNaRt7nNvVHG6fktgVu+MUZ09MqzKLJYdLHmUt49U81I5KQJD5mHqSr8kY2ZUxXlRGkHHFuF8wEa0RaAcyYq9n30R74jvZXTiLPrJ8KDf/OX2zHeUdGdLHCtGGBRcWlXg6TDGVJ7xPPqSNHHh/XdIjY23HwQr9kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8O+f7qd9atNjedwWxjNpgH7Bw9TaVnZDnBEr44WoG0=;
 b=pFleVGoB83iN0p459utRt4ZfnEIW4iwfQRG+Say6uZZyBT3Z1kqxIb3Mf5lMbzn1TlOIi8Xn+jNl+HPOobXkxOykIAAk7Ghj3ntaDH1o1Y/RUw59fc1TMNwuPh2znV7Iu+Fv0tHAGyoWjPepjU0jLgDqQjye09tX987XBAfcMl273oKXr/C3lpEMkBkGM77pt/SB4Kil8IvCMqtLBo88iv30xHnH1SurGHfA4NJhNBUfR2Yu4Gdcgt3RJhWDLoO2TwcOrUhKWOOsE2w8W01p868axRe+koNToj7Y4PZ3Z5myd01KAfMOWpfVVK0SAHUK4IpeUFljISoeJuhnVVrSUg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7607.namprd12.prod.outlook.com (2603:10b6:8:13f::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Mon, 23 Mar 2026 19:06:58 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 19:06:58 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
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
Subject: [RFC PATCH 07/11] fs: remove nr_thp from struct address_space
Date: Mon, 23 Mar 2026 15:06:40 -0400
Message-ID: <20260323190644.1714379-8-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260323190644.1714379-1-ziy@nvidia.com>
References: <20260323190644.1714379-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0029.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7607:EE_
X-MS-Office365-Filtering-Correlation-Id: 43cd01a4-53c2-4593-96f3-08de890f5b46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LKvJi4Fq9sPqjbXB8bxouSBbZSPccPe5FcUMvg/H10UBg3PLb2P8svDslGw46lp0yCVLqOsPGo53uFa8QZQbM7ClcYlU+mXNAco4560famdHI7/gMKfiON9E3cixZVVR1qf2Ais9SXGez9GS50yqPZ8gg0u3sWVuZjvSTV6HwIzJrf/MyOdzfj3de9wWRB1n6VTkAPrW33lSlm2FbBLj7DAn0tnwfyPcAYi7tu4ideG/kyZRG/5bJzenknUPUoCi5k/RiejWVnFWR4zvFDR5XCrlFeOgVc1LlkmPh5pDFV3NoF9RQOKMSoWWXFhPe7Rj48wyasI/bsEE1zegzhLQAMEQZF+OA4nJiOJ8rgKcRo7VcjgxxvtvC06OGoihvHZAw5DzH+biypulNVdtjIa4Dg9yAih9fXqRa7RfUgygkWj8USTQvBE0sEX+bFWJ5/89n6uSN/Qx0KZ8uZ6REkiNEslmWnSGatEqfeougfnpqFh/xpjtjE9nTLr5kD0IM165uPd8+rGkubsqBnDWuBtrqQufdQpyBtAQFotV5ChUWKXR0YI5U8BrxpOA/GHATnOXbegfUs+eeALTbyQNWL00VTOBZsE5/JVzJg+cx+rhXYIDPV6WDa9z/rtJ05z036AULMVYIEvcd+s27V4ucJzpArLXzjzaWzFM+CWOPqFZKM0MRQvf/Of4WvnZKCM0khQo54CBfyjoU8CHvoxhRNBpkzSfYnV5N5dpSw1VixrPwzM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2SF0zAMBWfIE2QCCMbmkPEXZEhD3oKVrtWrmmZbFeKkLjjLO8ocJpAt+FA3j?=
 =?us-ascii?Q?CEAHKJyD8CAhCs4RLKU8CSI+Jrk48HQtpEzqertf4fMwE4HqyOGp5HQCPYo9?=
 =?us-ascii?Q?7sovMlgGp9taHR+KZ4viS5CSprys3zjE3KrWP/gjFJoIGUU07KEBP9MB9DFA?=
 =?us-ascii?Q?WAamXQ2vg6tsaUC52zcwptXrq3jJx+S4ROo/YL/y6w6nzTUcdcEqVDW90uWN?=
 =?us-ascii?Q?K3xUK/AUKaHvuCRBeB9ytRkvh/BHY+Ns4DOFnPIzp7Sp2P9lC5juVJo/lgdS?=
 =?us-ascii?Q?qviP/9fVoNz2KiFhUzcXC7p1uGz+EPJBvVrSCPTIC12asv89HWqir8NjIWId?=
 =?us-ascii?Q?b+yq4mZNWWZEEzWSfK0H9Osx+sPLrd18KvHsGnAODZ6oN6P+wEHCXFPQy36o?=
 =?us-ascii?Q?CnxRnZDf5uRIgahEaJPJGk1XpGQSAAJsrxG1doPTZ1qkRDBemE+81+xQGJT+?=
 =?us-ascii?Q?Pqc8uG0FunBVhyiCGsvVNR10erd+eMh3yEidpyWpFwAuS3gKRMwuEtc/WFfQ?=
 =?us-ascii?Q?v46ywUqv7fJtLbuOcGaw2shuKLBECGG7QDDargfA5vbOE7LNvhXhiEOEZXC4?=
 =?us-ascii?Q?ZIusCLVZksb9vmnnE5WZNyaTwZhXOy2recJK4yxJuGZAFL+dOLEl3E42RoAt?=
 =?us-ascii?Q?6yHymQ/TBF2UhAiYo5+LdHqyhtKjT2YQ8ZuURvAycfqEgK30mzTOp8B6SFDH?=
 =?us-ascii?Q?D0rFn+y/nJlIfz2Jj7OdkqHVMaEAV4Ud93ZL1e727R5LSr7AwAin/7h1TkpP?=
 =?us-ascii?Q?USA2WL3TVIP3D//KhuGXp06GDE5Yt0RhAdznTM/pZmitp/HJ3u2v2wX9fgWq?=
 =?us-ascii?Q?4lRWL/MksPA0pJKECg+aPa9tvTgVtoRLEBzCKe60PZAmazHWCQ5mGrv8IorR?=
 =?us-ascii?Q?liDij+yuA4Ls1alPtq9+rvIMt0oa++fNd4b5MSJklF3eY8AmgbPwR2qcnsTv?=
 =?us-ascii?Q?AP3aNB/wXDNn1WP8s07ANte+hu76rJvmvyHrPamkL4GjL7mq6uBQt5vAVB7v?=
 =?us-ascii?Q?gFoJEJ5nDXFr4ziZ1j6IAIe5jWN84WJ3CxMstjP6RQnSZv6RojCwzRkV8YE6?=
 =?us-ascii?Q?1xMNuMNjiui0IxydWbb5ohGoxacctuDfig2oSausWSMkJ235YLPFLkvdCCFn?=
 =?us-ascii?Q?4SafarYyoA8P60ymwgfUdeS7cJT98V8FX1DYCIi4FMANW+NxHT2ZPf0RRmqM?=
 =?us-ascii?Q?pBqQl7o/YYTLIMhLH+H6kqM/rcdfhr1oGZ/sUWyhxl5dSSXhhrNWmsqY0GNQ?=
 =?us-ascii?Q?saeivxnwVlHHw6qCxep8O8GxkcwY1bnAP7cmqTsGNnZA2CjgDoTjjZopONVA?=
 =?us-ascii?Q?orbZNWruw2qALv1TQxs8ZXAUp0goeDOpWpKUvo4JQUB0uq4sLy6/8yjFfA8D?=
 =?us-ascii?Q?Z+jZYDjC7mBkI1tr0efpuNCgXaFWjHFZhPx6iiTMFLa4wwOtQhJpmjj3evOp?=
 =?us-ascii?Q?AE8spe9x8UVfrLqhTOtfydMZIR7jvR7JO+sktO0B0M+3ZL3kLzGUtn5dutcf?=
 =?us-ascii?Q?O5G4tE6/Qu+BRurxh3ABFDZHFDf5hzlCx7hs6Dz/2Wk7SmTVL5vddSbvxNT5?=
 =?us-ascii?Q?JhuQ2VjMPH9B5EeITy8pf6feRQ2YKyx7bTz5w9ob2uMN7F0kZQWS1tAxnDej?=
 =?us-ascii?Q?hoa1ZHEqs+5hTdXkJMsWo5QsPpUBzMd0dueW4QacOh0ORwBWuxlrQKMfl78H?=
 =?us-ascii?Q?XZmozuAl6pFZsyZqbw2YPW5gsyJzFXmAM7XivcDtLrz4RzUt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43cd01a4-53c2-4593-96f3-08de890f5b46
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 19:06:58.3231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PLvazqiSA24ZVQ11atMQnscHum1WGeSo0NR+/naBbmY4ZudmlcNelgtDU9xydBBM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7607
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 88AC04000D
X-Stat-Signature: pqsf37krdgrfnqt7dxrideqemcubahqj
X-Rspam-User: 
X-HE-Tag: 1774292825-631072
X-HE-Meta: U2FsdGVkX1+BH4ivdXumu9pgFdkMa3rm9fbwEtf69NWF2aYPZEBsed927d+e202JVv/MroBiQmTi+UNQECE3WO54laHn2lpvR67Fz6l86NwN4LeAsj6e2AX8cF6kI+kFiaVk1+gaGL9xeVXi+EHkBm2F1gt4lkqhzGnbgZXYXYTAHmsWM4YZk83wRF0Fy/y053foO917TdCTy4Gpdh5XB95Iz/s21wcOhGLWHke3hEFAo5EoCubQIAWLMerEcGNJujdcKm+46oBdFBpn3dDf5XwePQS+1c8P9nESbRLJHZHIfFy4Sq/s0x723znlBPRdggIB806dBzlfX07u6ktedioEUZ17Js0HbeApOmVNO0dKYDv2WaXz1PvhQ3ze3MNVr7tiVAEbcNFKbA5lGQTvqR5YHne/sf16RcKX9dIjVkC+AAaZf4Fv+u+t9+3LbyOlwVIozDNiUq/20btP8jN+STSql3JlUo4Z8Ybv7f/B4ScwFSnLDyoG1D5C+ss8r9vgJ4ntAYKJ8bzo2ymGJ51WTtyiWuaJYkE37S/S1pVPwP15+I3J/Ui/ofZKI4Djn0z5B0569tEVm+xnWbByYVMHk8vudmxY+RUVzcc5vdGfuIH/Tv16//72QYJEUkmyGurwXovpbltjv5gNmahPnPaKRchMaMlhbYWaRdsuXPHEy01dKtfTyN972G81z9O5eQ3TH64LfKOr+YmKSeMI84ugKUf2jXL3KSOe4xlEPfNFm8gY0FvltK8fyVS2VK+Lj74X2wxkz3UoaRkHggb2HQ0CTXVH+XCs5aRREsGjSfI51F6fNey7zcnjPG29RuupLA4Tt1wTOyM/7XNrDcNZII0wsShIr1BZjr5KBgOY6RELyK6tDIOGAwlBno2zFnvoKKdDW1D4PO7ELNpNHf9CqurOZLHaJsJZdAb2K+ClApkVC0djqRe5RBp2rF9dqXSD8pL1bjMTb25TTLx0PsBSsSr
 P+RLGd0Y
 9oANSdsieEQXznRhn89Y1PRRKcPTeyVYBROYQ6Dz7yr1eLgF7t7bBYp9ccbBghgzWNscMgn12AnMW4NgmZkc+Tkx0/1xQ+Dk4xNUc20wHxRraHF0h2P5Oy9zPMvcb1QRt/bXr/yOUU59fHOA30F8IvMgc8z3iHPd3PsJwM4ApJEl7aD9Aqk4IfCwjzvL5/AwUN+dYOy3BTvQwRNwrlqP9UoKmK+sSyXSBqR6x1++e71BlGZ2dPRboB+EJgeePZeJuVlU0rLlVHd+Qm/JW8Ax9hZjZ6weQlC3m+tlZCAeDSMSWDV+Hf8F/4NmhkvvE3jDBhtVJo9wyG2FnviIQU063GzAG9hjb00ORfZwceTZIRLuvtbUqORq3IZn1SgxlKB9OcfHQ1VjvSFeM7bC2Qqj+V8sbMyQHLgCjuZMtlGgTERWqGONHCKvG8QX9Hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

READ_ONLY_THP_FOR_FS is removed, the related field is no longer needed.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/inode.c         | 3 ---
 include/linux/fs.h | 5 -----
 2 files changed, 8 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index cc12b68e021b..16ab0a345419 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -280,9 +280,6 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 	mapping->flags = 0;
 	mapping->wb_err = 0;
 	atomic_set(&mapping->i_mmap_writable, 0);
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	atomic_set(&mapping->nr_thps, 0);
-#endif
 	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
 	mapping->i_private_data = NULL;
 	mapping->writeback_index = 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0bdccfa70b44..35875696fb4c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -455,7 +455,6 @@ extern const struct address_space_operations empty_aops;
  *   memory mappings.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
  * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
- * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
  * @nrpages: Number of page entries, protected by the i_pages lock.
@@ -473,10 +472,6 @@ struct address_space {
 	struct rw_semaphore	invalidate_lock;
 	gfp_t			gfp_mask;
 	atomic_t		i_mmap_writable;
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	/* number of thp, only for non-shmem files */
-	atomic_t		nr_thps;
-#endif
 	struct rb_root_cached	i_mmap;
 	unsigned long		nrpages;
 	pgoff_t			writeback_index;
-- 
2.43.0


