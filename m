Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6662FE66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:46:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73B86B0088; Fri, 19 Dec 2025 15:46:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C21B46B0089; Fri, 19 Dec 2025 15:46:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF62F6B008A; Fri, 19 Dec 2025 15:46:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CA2C6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48CCD1401E4
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:46:34 +0000 (UTC)
X-FDA: 84237403908.21.350BC50
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010037.outbound.protection.outlook.com [52.101.56.37])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8D6578000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:46:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SdaVyX8a;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766177191; a=rsa-sha256;
	cv=pass;
	b=23wiprNUkDeu3wFfTDuj7iLfD+sxEUEk204fdi/WYES/vaEsSgo6eNT24beOQN8bDZKThB
	2KpxwwgjJ+KfZvP1c06/QhtaP7/x5pdTAW3YnkAdeRFowoocsP2GvzFISyzkzDo7dbrSGX
	LOocmUqZBO0mIJt2ZUeYrMQsHjPf+ps=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SdaVyX8a;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766177191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0SL/40vg/QCjbZovak5zuzJ9feQRa+JaaP/sKtZaffM=;
	b=CpQkm5zQxGRbyaaf5n4fXcGnJx4tXL6zEfg8BQMUTF7YDuMDx5bgaYZZNzOUzDe+tQEhdf
	xAKgo0+81mRBxDccw7WnnVQnqmhS/WxBTwXWtb9wkgHZTdJdl/8mUrYhs0Myu+nuVdaC7n
	Q1dTcyLiZp3At2Uv6+uHH0fRUsMBHok=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nqslAS05UiLP/SxFNPDU84qorE+odeeBK06HOrhno/A5Hho7vf0ugN+3JiEVQYNKNNCwAtE/IFdZgwyNGhC1DZxl67Wu0SQO52cCg1EjOiM0C/h3xIxAvn3inSUbM13bH9G4H/l/HqH8fWnzsBp9iYpN3CSLPnn+idi/ddG8AjVlOaLvHUekpnJxVUYqhYIFrjRT2HeqSFoooddBFWjdi8nGZgpTIe3SN7g7HdfGNh9d03zWvUFgJq6AUq7CxH4alShm5c+0Wu1bNysNU1Rou7EdwB0EYaqk4sGxjLBTyb87mlyPnFnJ+BQ6f7U8OHLM62lxGYMdRnLveJbIXudWFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0SL/40vg/QCjbZovak5zuzJ9feQRa+JaaP/sKtZaffM=;
 b=EQv/xtEnuxTeTn8QzozGTTkgKPXsQhfeZjjuEW3ZdeugN6ceZSXZAFh9Z6E0hQ5Fhnz4xEwv8K14gzu5cd+L4zrdaQy2Cb2XAdZI+wir5Eg/IDtxV2gkvAUN0C1pRjXhTXgCGyKq+U6VQN9tpKWwK2nff902t2k0qtHDJ6QJ/6n8cZYLHNkwA/L24j8dByNkrBNNtBCJxwEy5s+SKLaHyMT9WiyLfXhDZYY47wpncYP8MK/2Uwtj2hJD/s47+oxxDJIB2C+TQyc+4GoFMPtfVVtkQWXsdPzuoQJTncHwlhMZ1A2Mz4KY/bAN1GaF/O5y2hR8fKFmX7t3KQ7Sr6u/xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SL/40vg/QCjbZovak5zuzJ9feQRa+JaaP/sKtZaffM=;
 b=SdaVyX8ay4Zr5eik8NcMQ9YGtHAK/UgZPlwxFoms4ZxD8Xn0arKWNbJHm/B2W6+vtR3vYB2lRjPG4kD1AzMzbywjCaUFBWbMit/uiiBrprmWK4szL8jdSSWWXSIRwhtSE0hH2Wsv+ToqlaSX9Z7fesr+NJPehbutZ1eJb7FrfmWsvEzkWmWlHYrxd35vUVi0jPRYRwKw8DMz7PybzWqMjMmIfrO3wXfA/YmKEWmw8QMnWVCcrsIIAs2oeSi4+1i1nyhZvWx9+M4RydHfskcQdwUCq2RuEOm/mCFbFCldGsv4aBzV2h0GhbDtTNgnd97y+f3EhXbgGa0WtVAl/Gu2+A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6060.namprd12.prod.outlook.com (2603:10b6:930:2f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6; Fri, 19 Dec 2025 20:46:28 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 20:46:28 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, osalvador@suse.de,
 rientjes@google.com, david@redhat.com, joshua.hahnjy@gmail.com,
 fvdl@google.com
Subject: Re: [PATCH v6] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Date: Fri, 19 Dec 2025 15:46:25 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <7EED2D83-AE17-49CB-BDB6-954793EAFDBF@nvidia.com>
In-Reply-To: <aUVgoEiaXj94IBmW@gourry-fedora-PF4VCD3F>
References: <20251218233804.1395835-1-gourry@gourry.net>
 <20251219000800.tnpqzvcdyeqcwryt@master>
 <aUVgoEiaXj94IBmW@gourry-fedora-PF4VCD3F>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0012.namprd08.prod.outlook.com
 (2603:10b6:208:239::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6060:EE_
X-MS-Office365-Filtering-Correlation-Id: 2967a1ba-cba7-45e0-8ca4-08de3f3faeb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WRjdAyKH1bW/ieuBrDu13uvJkPLKP9JWpFF8f1Tfz6XglVYsbCTWdz1Whup1?=
 =?us-ascii?Q?LG+VrotGtk5gaXk6U9IuOevOLPrKyf4KPnbPl/jWvh7WVmd6sDFyZhHkhbny?=
 =?us-ascii?Q?WmiBo2yMEBlfdUuvyqKxKm4q6+kRkU2t1tvwnQXS1LP4mt4z783Js737+J39?=
 =?us-ascii?Q?tE12DELgU7NpURkKoAhQTBP1fJseS0a3VC1D60Pl2FYxCS18Ot7WfuPZstlz?=
 =?us-ascii?Q?xXUt8x4D0PRnruZbukPt8MOu2OyMHcuQk4HyZyWmlI4AT34hXnMN02hD3pHs?=
 =?us-ascii?Q?POzLT9QenT+mmINpnrWJ1OJs9zZp412XIhtNjlq1CZBDDG7h/ZQ2qaO66f01?=
 =?us-ascii?Q?FVl4pjn31GBCdY4LgbTiHzUPKSxknGz9psh4r3XoepHgc23amsfMUJUNoyfH?=
 =?us-ascii?Q?g/03gLBX1elbWckezLZ5uXgA/ShsShXGCtGjTVKh2FLp3aQEvmFtsj6bIBwj?=
 =?us-ascii?Q?t+XSf0hQSnXyEPIEDmL+j5BFx48q5/7mgfBll6Ht470ylrxavCQDj6XqILfr?=
 =?us-ascii?Q?rCzpVrzDQLC05SSPZaQh5XIQH6axDv0PApQLlxhLk6FBcbEgywyUleUI411G?=
 =?us-ascii?Q?YqovxsofjOWfLNoZw6O1wbuKAp7yScXu9tlNHebnfHfbS3sdqbgDJS1WG5JM?=
 =?us-ascii?Q?7rbvOW/APG1YDiBmDy7ojnHgSdLSlJ9tkoy7r+Q0k5R6DH5FA4fHaEQNQtj6?=
 =?us-ascii?Q?SEA5YqW1Zd1S64LNNRsVXzRz5tPHJ4yb0nUj7iTQI+aNyJ9YPMmEfct9gVu/?=
 =?us-ascii?Q?mitc3x0YRyj1okr4wCZ/0/YcB75xxYT1KSwqzGTHHbG6tX4NTv0HUTSR2+6O?=
 =?us-ascii?Q?Bw7/LWDNuwPoDOEZVXWTt+Ivr9IOVcuYMMw27gOejay4WuJOffxY5Rrmu56j?=
 =?us-ascii?Q?s6gYx34gssTRUS4WtfSB5Kj/TxDxxI6UJN9oMhTcXAlZ+ioNog25q1SZkqZB?=
 =?us-ascii?Q?nrhPCrV35j/XZa8aQJNHBWumfdOKIeh0jkau6KDVrq3Ul9iiBLo5Mce8TvOv?=
 =?us-ascii?Q?uSaE8B5N0w/KDyFAv3coUEpVqkdI5MEblBbDugszy8JyRhBCkGxTql8OT0su?=
 =?us-ascii?Q?6quz4+HGUO/HvhrqmFcQfgv9qQ4t/QXOFPoawIWoOeq46MQdHrYKuekaYzdk?=
 =?us-ascii?Q?XB7XCLKnImy9TmVnnXphBsip3HX9uCG9qt54LcZBVivCrmDPGJlzHlQu4Y41?=
 =?us-ascii?Q?EP+XqxUjLeKhpSZt/HIMY9jbgx2ktVUwvOnSRqw/xuQmUULtYgVMl5v36fZD?=
 =?us-ascii?Q?nk6EMUmTcXdcnKmBu9U4c8EptuNu1bThW1/0PbY7uPRvy/49+uA+wAUUKmq/?=
 =?us-ascii?Q?M82FOJtYa5NLqnDLYMqWuHGtw6l8ngBJXeElvo5dl4Y1Axvumt6uH7lPxy3M?=
 =?us-ascii?Q?QvGJQgZJ502Omn9mRUp/iUITmVinl/6F2fd94NbFl+at/VKguKvrx/R7GacX?=
 =?us-ascii?Q?xP3NA0OwI6WWeeBvbgrZF+yWBCAXvrre?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Hgb0jyPt6KS2PlrDKaHqJecWJ7XeuPzPinT8V1qhheaItAXUarQ86atprwHE?=
 =?us-ascii?Q?8hlyFnN9jPtY04jwbu1E6byM94rsg0uY/L72sqZlcfzIUtqnW11QBhq696aH?=
 =?us-ascii?Q?+Tdf+KEESZkZny0jYWzfmpY1djfQM8KI72y1O5uNMP0PFDHnmWVwysu5nbRo?=
 =?us-ascii?Q?tB702t3aqjKADHYlRXu/hnXP8AlUNmMIjO9+WBCdPSauj7APtHaUcwqS531r?=
 =?us-ascii?Q?WSjudz8Hr3N6vJCrN8Oigkqbwr+fTFarydgoFW8cu2g3SiTK7hQGwwV7Y/mx?=
 =?us-ascii?Q?FpBf2rveabz2SFjuCYdPhy6NMHaOQxDI5lJfGUCWT6E3HxeB4kdI5RtDJX2z?=
 =?us-ascii?Q?whlfSwkiRHsIscPhL35ZUxCqVgGw282BZCokNzGN3QJoLLSTMk/H6Q45afzG?=
 =?us-ascii?Q?g4gFKpwXsMZ/Gf3FE20fcfBqe58baFLusI1bVKem/K0110byh+vUZRu7pXB+?=
 =?us-ascii?Q?t76tqGvYyAmY9eXxB+BNEuMfO3xQNgJzpDcXLvhAV117Qmr8RaZqX7tEy/QK?=
 =?us-ascii?Q?tbXQ6RNFydl+Ou5gn3zugm7Ch/725Iv0kHhJpOWnkApB7uEB+de9wcnrOORp?=
 =?us-ascii?Q?WcrEqjLTDpCWbLDn2UGETGioSyeruFCrCkDEWL1IsYnzdMVO6HC9T6XgZacV?=
 =?us-ascii?Q?5avB9rtgenclFk8J8JJHQ/DmSAT8I/064CqGNwiJv8hdej5sqzY8OelrZyz6?=
 =?us-ascii?Q?/1NVjabrXhpcX3CfQ9S3VvmsbkN3BUrdK10qBBaWGf8zU7xPkyG50bizBljZ?=
 =?us-ascii?Q?usTAedskeATvK3VDCaFTUFYGjdCdLqActVgdC4/4FH8wHlLZBCzLlQLjdhUT?=
 =?us-ascii?Q?OY6pl2LYy3iis2rKNHyqisXOws3Kjdw9pru2LNHRPT+kVnbiNGWTKTIa5XMV?=
 =?us-ascii?Q?SDNivsONy30430zsE2+kMddFfusqzyaLIAwoex2S0n7aF/BK4MIPfvIJO8iN?=
 =?us-ascii?Q?ZNBFePMCmYBRxRmfvCrth44e3d2+LotWvw4J2TzDeg0BMCgyw+cOB8goAu2h?=
 =?us-ascii?Q?S39DZ83YJjgcewi+ABeH/DYVJx15TbcQoXqtzEFBu1dkrnIvIzBLF1Vftaho?=
 =?us-ascii?Q?U0CSIiA0V+j/cOahpL+gD/S7Qr9AlqnA7AcDSvLoQC2RUbDCIW40UIFUaohb?=
 =?us-ascii?Q?AN8Ca9CQNX8weBtT0OrnCfIvhRqE0DU9wEYcMIMnALW5dMw/a5vNXkXgtpV6?=
 =?us-ascii?Q?dtIplyOLR38tnGj6fmuJqjuaAgZb8/H6fDq3lYV9f40/REJPMrAqmPwMxX6A?=
 =?us-ascii?Q?Ln0Fnprnaj0lsy/Uob3F0+kf2tTXgjoEtbeZ7Fsecy1EoIT+Q1kO+Qmw1YOe?=
 =?us-ascii?Q?Fjm8hbYPU80FkAvRSB8JM+D7NOvjcjNMHqOTQyUKF9flHrxaBVquok9WacDQ?=
 =?us-ascii?Q?6iv4Hd5pZWr45NxkODxNAne5zAn+b7eHhZ09fyMsAlXNFg56tMzx1NA5u/Jq?=
 =?us-ascii?Q?xDm423abbzUR3da8A4Ch3U12DlkeIFp6lnijMZljnQdRzOLQMETTGm6FWPBe?=
 =?us-ascii?Q?DHYIqLnuY8bF+CxFKeuErZ3C9oJB+PwWC6yn6QYQbWi5L1lPgAzbevlYpbH9?=
 =?us-ascii?Q?r41b/TbUUV5GvKIqaSmf/Dpcw+ER0Dye8th+qESpcom6SqjaIaaaT2QYsrYy?=
 =?us-ascii?Q?6ia37H2cl79QXWc4xSDLQLptvB4KeFd83PNlzJZ27u92IbK+AnP2CVPrNCkW?=
 =?us-ascii?Q?FTNzsxJWkyLKy63q+2gvpAcGhbtY0dB034Rhb7Avu0KPYPCY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2967a1ba-cba7-45e0-8ca4-08de3f3faeb9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 20:46:28.1417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lbBIietcVPt7bkDSI+BpP2Hf2wynf4UxJEz0kh01OwiAS/jheBbH3cLcESqShzSV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6060
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8D6578000B
X-Stat-Signature: k1sbm3o8h89jnwweumxhkwbc9oqcn9it
X-Rspam-User: 
X-HE-Tag: 1766177191-396953
X-HE-Meta: U2FsdGVkX1/M6RVbdnQ/ffAr6ofUqvwnOoUM56W6IYyEpxEZ6JQcR4qJ144I+Q8gkZJBEgTlhYJsEAuTp9PyHY1PfGRpFFWUwS3Ns6zKZASqzeMcCs12jKCoV8g/m0Rx1ZE/xgVCR3ROoWq5d2xB4RisnkiSQAvGv9rAMXKnZZ4vG0vqX+41XJS0ddIbnu8isk3+rc4+g/iZQrdTn5L2rsQHLoMEkFzFEAAqQory/ZOoKhONAMycj+bPJlKYX3Jb0Bme6S8uVU9Dh2yH6YYjxL7jNbATreGi656bGwTf4/LeXF1+ztee++9BVNo2E0cZALpqojjAvKeDhiPdv2S77hUTubMIA2bzedzacXZjvWxcpLWrWl1X905QuTILLBlqyEoqpzdENNWMaVqoYH0uYgJn1Qjb+preepz8+kQttLpnlVAYXPkGpt/3MkudF56302VnWsru/1kqMOia/i/8hJteaAtHhOI4NLGtn0sjfeoQBOXUzf0Tm5VF+cE0iylinDmIAOlzOoAKItjopfOMlL7ZXINJM0mx78tZs7Q64//sYC6HxvBDJDtk6QDaAlxuOWYHZ+FGs89pRxQuBQ3awEAGQAYfVbtRUnP3VX/L5u69qeopr3ipBVV3F39kxUFJuISJ5vvE5HupDfJTAGtdoPEFs4T8zCwSaMjDAbb50ezEJ3Petj5uRI5HEJr2xLVu25p7BDweZR8kiuZHIsD6tX8vpK2+EFvfWgpm9nk/G3MwW79CdEUuGMIXXwolRw+VmMtKMtT31+sDGiQEB2qGXsiL+IaRJ3yuG2c5lhnjFL8B5fkKhdwdrASywXo6LJ0n6e8bUGdpJT+V5jBAtH/iuOvl5CEdol+gz5uTrTxtg5Mg8X0EmfpL91gzpMuQfRVHUTWSz8yiD9Ovs8/8wjc9bk+mPLkqYpbu9IskGDepjSEY9c7hH6ElChVxD0BtA+U3dgF5qq1q8l8nD+7IV1y
 KBEnl3C4
 EZYXgn56eF2/aAb/gyTuA+Wxa2e6Yuofq6IKqiEsDQi0uRA8djELlMtNdeIixY7aVkvcn3M1sQTQ0L+Tu79sA76nTZZ2n9/kFuBQw3/jR8Wv9YdW7QH84F0+mOJChOcxie2V8SLat8IvcmB1zm7zZKyRV3gPZqvkxgdrIuR0kXpl/5wHP3YnmBlxDqmRaJqUEKqcWGLRueFO1ha/gDdI5FMjjEA97XxncWoMztlvcMZDXyUF5iQkRNUrYH50WvAV/SxGi5eKvWMgWaCbv7EqIDTQlXD+UuywuuoH2M58KCi/8tV4gMjVGB5w8U5+zUSlKbtjpFvUO4izV1kNPzN8Ctlpff4F2Y5A3VeLD1Ejzla6AHV2N6LtZSO6HNug1v9Tkz2smmypyjuHUo6jIuBA0cH4TRx0hitcjbqH98qtjVfD9JN2Kmm7wxznP0gcJDZX/X5qN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Dec 2025, at 9:26, Gregory Price wrote:

> On Fri, Dec 19, 2025 at 12:08:00AM +0000, Wei Yang wrote:
>>> +
>>> +			page = compound_head(page);
>>> +			order = compound_order(page);
>>
>> The order is get from head page.
>>
>>> +			if ((order >= MAX_FOLIO_ORDER) ||
>>> +			    (nr_pages <= (1 << order)))
>>> +				return false;
>>> +
>>> +			/* No need to check the pfns for this page */
>>> +			i += (1 << order) - 1;
>>
>> So this advance should based on "head page" instead of original page, right?
>>
>
> hm, I think the thought here was that since we're moving forward from
> start of an aligned chunk, we'd never hit a non-head page - but this
> may not be true.
>
> Will think about this for a bit.

The sole caller of pfn_range_valid_contig(), alloc_contig_pages_noprof(),
scans from the beginning of a zone to the end. pfn_range_valid_contig()
should see head pages all the time, except it scans in the middle of
a 1GB hugetlb when alloc_contig_pages_noprof() is asking for a smaller
nr_pages, like 2MB. But in that case, the if above i += (1 << order) - 1
would return false without reaching it. Basically, to get to
i += ..., pfn_range_valid_contig() needs to search for nr_pages larger
than PageHuge(page) and nr_pages is always power of two based on
alloc_contig_pages_noprof() requirement, but that means
pfn_range_valid_contig() always sees such PageHuge pages as a whole
within nr_pages range, thus cannot see a tail PageHuge page at the
point of i += ....

Best Regards,
Yan, Zi

