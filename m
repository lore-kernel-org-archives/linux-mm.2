Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECD99CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 14:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41D518E0001; Thu,  4 Sep 2025 10:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CF326B0011; Thu,  4 Sep 2025 10:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295338E0001; Thu,  4 Sep 2025 10:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 168F06B000E
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 10:42:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7EE614020A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:42:52 +0000 (UTC)
X-FDA: 83851834584.19.ED902E5
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 25AAD100002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:42:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BrKUu5ph;
	spf=pass (imf14.hostedemail.com: domain of jgg@nvidia.com designates 40.107.237.44 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756996970; a=rsa-sha256;
	cv=pass;
	b=QPawxYz0XcrqqCEeRBl8aaSW24Qzz47sHSVbkb7XWXOATUVoQk00No56Ew7li6eK1fBUKI
	wSaoJy035TYhXmEf71V8EqCp4ZThdR+//FdSoF9s1RNQTrZaLpSucrVGmqDYlDovciVdtM
	xKkbA34ykgdj/TAvWI6My9qKUWT9TJQ=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BrKUu5ph;
	spf=pass (imf14.hostedemail.com: domain of jgg@nvidia.com designates 40.107.237.44 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756996970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=95HIFVMZsxTtVfZ4wXiTxxP4q5rcR5Q7RuN+qfMc+ik=;
	b=g1uXTcHSvjz7kHgJwhj14tK9lugfxcrxNUINyJLYkncDWFXTifrl/wjbbkU35HAT0U6wcl
	MW16VyouM+mnY7FxIijNhEoEeNB6wyoAmg61DI+2IPPfjFKlEG/QKSFLFc9sUCJIrE2PD8
	zne4PgsnQn3XSBqga9SVcAabLLmIpEY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EfKVGWnpYXDqXM5ue93v/ZAm8S8ToopZIgCxTIfD9DbI2n1+gsvpc9TLstgZ/5hxAPKkAC9HBniCOwCZCBGZRDLhT4dGORnJV/EMqicO+vx5wXfKCCow+sIBixvzNyWD8HQKZMuGH1iWp9NsQjWtSFS8/GeFiEM5jYjZfPY+x5lGTs1sG8L035/32IQwsbtaBy45FkCJhkmz7WIisJx+MyXvWdzlqqRzyOD2bfV/LTDGN+QrU/JTaIcSkHMk0vSlblGTGjq8jjt/3CjqNDBFSKF5q62qs3Q6cyW/HcMFpaeYkYE5POHUkQYlVIl8pqLB7L1TfHWJZyLw0mT6j2omlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95HIFVMZsxTtVfZ4wXiTxxP4q5rcR5Q7RuN+qfMc+ik=;
 b=xoIwRMosn7gvldAYLbYe5CjgDGMbxxgyCSmFuoNvlXYidPAl6OUhYlV8rGWLuiOlYrM+X4E4euqfWjMu8/RQM6BMBn6vA3f4SW/kPKz8BxFaGE4dfxl7H9FKEvDBgblCsu1EzJm0CUTEEqaXLhSDk5wdbta3oSQQwYcOZdVLm+5qja9cfJsc2SMs2ko1X8JSYfXYgOQPKpIaWx17U0cMMtT35kZhpeYV3cXjPyeKBTU0Qvp8R9hPdmPP+6ZPxoNVFbbVTpi39zO9bRppaNfGti/cN0Jho35+14bC/I5laDASDtdUk0e7jh6tZs66srqU+tZVe+Q2bwRaC1sjH0KSXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95HIFVMZsxTtVfZ4wXiTxxP4q5rcR5Q7RuN+qfMc+ik=;
 b=BrKUu5ph9nPv952HRDLKlPZ5Du5vV+vbN1FFccNVWeKmul4Kfjgszszav5BVj4QAHutMfLDFabxy1J5uQ9JOcwpeqRTndW83IjWRQIYg65O0DOAmcPghRUhwoJCS3Jqmy+vCzh8AxvP2sEoe6qpOC4HjmjdIHqAYkzAMEao6IzOS/1RKu2EFRFEnmL/WNb9/QrbrKdDImVBZ2y615JsTw7dO42cSW7OgYyBuWo9CoYO98OyhkyL7eAGQLID0A+O3UCnO2On93JtY7ah/5zod/KjsJ8+/to4Pi5RCPsElpl4+AsPaihJTM+PeWqjqSas7zzxr05rCzONcsetDb4HL/w==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by MN2PR12MB4423.namprd12.prod.outlook.com (2603:10b6:208:24f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Thu, 4 Sep
 2025 14:42:42 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Thu, 4 Sep 2025
 14:42:42 +0000
Date: Thu, 4 Sep 2025 11:42:40 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, jasonmiu@google.com,
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
Message-ID: <20250904144240.GO470103@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com>
 <20250826162019.GD2130239@nvidia.com>
 <mafs0bjo0yffo.fsf@kernel.org>
 <20250828124320.GB7333@nvidia.com>
 <mafs0h5xmw12a.fsf@kernel.org>
 <20250902134846.GN186519@nvidia.com>
 <mafs0v7lzvd7m.fsf@kernel.org>
 <20250903150157.GH470103@nvidia.com>
 <mafs0a53av0hs.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0a53av0hs.fsf@kernel.org>
X-ClientProxiedBy: YT3PR01CA0146.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::15) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|MN2PR12MB4423:EE_
X-MS-Office365-Filtering-Correlation-Id: 615af996-c534-42d4-c3d7-08ddebc14da3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f/wOnHK7GzwGZVwtR2+VojuO2E0A0UVypW1NTs+IGPqLvQ/cuuPr0Q+Iuvbh?=
 =?us-ascii?Q?XYCQJuN5tYoCySEryCm5TpRQsL2QPQV+kVm0+kbdIPPsY3T3BX+DOuW4bt0Q?=
 =?us-ascii?Q?ZeS2s0DCTKoXEWSLH7WIWXdfWmS6uxeQMKQ9KQfy8jqTiW75gX0i2+hwONPW?=
 =?us-ascii?Q?LyNAU26YxJqSNMj7gN1fhalnIQ0K/C1qy5g/4ZWLYudwmfMb9Qn5E8FyojpZ?=
 =?us-ascii?Q?uESz0hikspGe0pYdzPZdvWDt/SX7RMs+ciOo7ywrRyOvBgBk4Fvez+Jh0uh8?=
 =?us-ascii?Q?Yd5iIZ2IBRMmxmqvjLHtwP8N4zUh+RHLMAQmgps1kK0XEqZqW0xYyVzVrlvD?=
 =?us-ascii?Q?gPiHLMmqlnXwKEGgE+qgkWV61oa0FLs01tQseTAnuxrRybzqaAzYu9ciYUsf?=
 =?us-ascii?Q?mT9gdKuBn0yIzJfIPWuW+hCYo1nLlRP4m/FwncYAAoC/mV+DbMZUj+RXkDTu?=
 =?us-ascii?Q?V+2fpooj3u+m6gsZGYpBqBu7upcaS6TrO2498iBExqsWooPWnFnnnHeWEfVI?=
 =?us-ascii?Q?BBkjJfVK/POXkdcum6DFKzrrcu2eQKPyyzFl2GZIBBi1OCj2sjqaljZ2ORA9?=
 =?us-ascii?Q?7WHjh8WrsPYJE/nm8C2YGpOXDN1cJhnZxAXweQq/850HysqO+9ZaGj+sQyGE?=
 =?us-ascii?Q?krwbMABB4qSrvvO5aXC9qQaHg173wEZfjSXj6YRlBC/5WcOB95PjMkV/ROlI?=
 =?us-ascii?Q?07jrrnHsHl6YHK8umCbHgjSXBdNFxMUuVu70OBS14iJClufAlMJJG07FUx/m?=
 =?us-ascii?Q?KlD+3/Cxv8I2cIUeT0+BLZphKuchq1CyZ4Wg6OuUQCT2JIqUteJWDYmaTycN?=
 =?us-ascii?Q?n4Q16Sb0kvdEM9RsG18+foSYHHXD8RHnF8rfIao3Xb2PccvtNK73y8ykgm9C?=
 =?us-ascii?Q?4OMFlxXe5kyA6fVVgBnVjwrpeQllL10AP7A6481HzMzua3KF0lhMeIkiLiAJ?=
 =?us-ascii?Q?wv7UfvgGlbO0QG+dLTKiE7c4ktKpJjGnUAkuExcziqLbpZsTlyeHTg0u4alF?=
 =?us-ascii?Q?kFawc9NNpgOVU+1nE3O/1aPlhAL8IJRKuhqvJQ8jD61VnfkUk9k/eZN5Nc5H?=
 =?us-ascii?Q?uyPEFO6IgtZiOQjJ2qdahvWitJ3WpZY9x1g7y3GiJ0ahSR9WWkdrkVRCQwc8?=
 =?us-ascii?Q?ODgnj3EBVmyJ1MIxK+wz0nklALeG5yx0WwHb8uzsDLQ+RKU8mo83zlYc1OUU?=
 =?us-ascii?Q?WJx4Kyuy9KR55DY+PIauixzZWgs2qibJ3dWiGtUVIXAt42xlL2BSTELUGXlD?=
 =?us-ascii?Q?bYN1nZnf9U/HJbBc6rYdmhMsgONQAVMYl1mx2kJYFFA8zsKr76LYqz2H8i0g?=
 =?us-ascii?Q?TT1KHFZ5TnmTu/QTFTEIrlqwu+J0wVoPjAwyBBXMPmx25WkY41VNEh332eXS?=
 =?us-ascii?Q?Yb6roTSRNQqWnmtKfDyVtUV2gqm+h1a8s3qyrG5T4tKR6G3IhtReFLGLSSw1?=
 =?us-ascii?Q?wWSnnHAqSxo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pJXBoys3F5nzVVg5W8qW+5N0UV4a4PGyQRpADQp+Q3uE4IY+EYfHp2KI0Aaa?=
 =?us-ascii?Q?x0DQ3EbQE0R/Tmg51MJvQ3lJ4YFTLJxbpF6WRYmWJcOFM11Pd0X9nKKV/3SA?=
 =?us-ascii?Q?GJYl4r6rOV+MwSsHk5J68TDjHfZuJ3/gPq4jX5/tlgvepG7sj5/B2UsrY6nI?=
 =?us-ascii?Q?ucyb8ASIZtzX+Xu1MNv0U24u6VmheXMzdkyD73wfIZuBKwPzz2u6FAC23NoR?=
 =?us-ascii?Q?449Whn1Vu1NslyI7tWDbdBFJTKTE3qA19U+FeFqhH/FSMo86b9gNSmp5YH/N?=
 =?us-ascii?Q?RvrAiMinE6/WStfO5wFO93A5TwOllQb+IgUMce4zvy/zyppwSrQIn3xCkzlD?=
 =?us-ascii?Q?OwWkBNFsNbSOoHRkOZZAfXIUoROmFs9Clze2PDIrxQ+UDWeppUQZ3RTfBjJW?=
 =?us-ascii?Q?sOOo8XvtxgR5CdC1bu0S+PPyTovfWsqecxpAvKxz9aSu6Y5eC0szS8T5R3ax?=
 =?us-ascii?Q?LVr1MQzU0pRxgKMnyrV62Xgtab5udUaOMCVZ7VCKnY/lYIgy31BwGlFz10zf?=
 =?us-ascii?Q?e8FPR6zKFpaHkRKxCzUlXcdgvyO0WFpHboCruRsZX/A+qbk1RV2aWiiDyNBu?=
 =?us-ascii?Q?82upo7m12amg2cUCg9YxkeTYwBcuL/KEruwOqp+mAaoUk3SWo1n8j+ZwCQhl?=
 =?us-ascii?Q?zkuT4Qqr97O1SOUqWwzeihs1PmwMs+qmZnz9mLbB6IJ71Hq3UeB9CoatnCu0?=
 =?us-ascii?Q?IUcmua8AwIuJtHajAX3HEX36xEmp8X99zezEsJ+KINcSCJPssrP3wqFbcnjp?=
 =?us-ascii?Q?fGI+mu1I5OawICiu0SEuy64vrld/g2DotwvUgwn6gPxyqinbg4qLd2sR/60z?=
 =?us-ascii?Q?G48Mma4a9utVNWjqHJN4oE5bf8s8HNaHXl9T9NthFSmdTHOtdSpiBL5j6505?=
 =?us-ascii?Q?WRz7wRSxhqcJeYA1ZpE9gU7tcT6he1dZ6pgRD2y7jdJWaIa8/Czrlfplnr2x?=
 =?us-ascii?Q?6HKXwO/KKWWUJxdiDPiEks4jQsvwVbU2fvG+Ynz0cWDIY6VLDtxwn06wbfXY?=
 =?us-ascii?Q?BhI5KlenVs6GKZcEUjIZlZZrOkH7jdr55RJjmncHnAwKhmB3k+wSzWsJsBX0?=
 =?us-ascii?Q?3QQPpXVzJDIb+miVXMuhKa9g+7sSOPhGRykJ0079fvnQVz58slfSeZDIbBOR?=
 =?us-ascii?Q?38hdePaT3gy7SQy0OJOggnjzm5s4jymYM3g4yqKsu9swLbwsjIYqpowE1NE3?=
 =?us-ascii?Q?2w7Vu0NbP0os2WWY58HUMdzbCo1TFR4VT7GJZXRyp9KeXZd9/NG3Kv1EM2iG?=
 =?us-ascii?Q?tNNYi1CCZSQOb2+LMXDaXb5Wd5xUdppCoeBGWzHilUt5rI0cNcmkhBPMQa3I?=
 =?us-ascii?Q?3ZOyONlE13MT4zCz1rtIKLMt00mwjCkyv9Uva+8IiE1CRArZnMI8y1taKreC?=
 =?us-ascii?Q?iU9X4hmJD4wsqdJfa6CwFqdVH4GOKa5nO3uVaylXt7DquoV3BYyZEXh2LoYG?=
 =?us-ascii?Q?+nXcdqEOAxGA6jQJjL9DStDCmi7Z4KNwV/tkHRQiY0+alYx9LtE3PGlHSfLa?=
 =?us-ascii?Q?v4CrXw7ZJa5LlEVvGpHBUCgcytedDbIznOnqCtS4LlCejpX48fSWD3q0Qyah?=
 =?us-ascii?Q?tfodw4PQYjO+OVDXWHM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 615af996-c534-42d4-c3d7-08ddebc14da3
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 14:42:42.4340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dQiYqYUgAAA1O8JcakAAmRDfyBHecRXoHUNR3bXxeTtF09Bj7KBDq66OfmQLIkK4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4423
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 25AAD100002
X-Stat-Signature: m66y4rdet7ha1xkatdunzjia98j8s91b
X-Rspam-User: 
X-HE-Tag: 1756996969-390890
X-HE-Meta: U2FsdGVkX1+ZzPohZOwMGwFASYlLsDn0SwmW833jHrjZyKmroGjURzQW24X64xFGOlATwjJQtZcI150qWvntqsVm039U4Rk8/W6YXeZUeMAZtlFizy6ob99hHPw7sX2uSlgCiYTTSUViNjh7+cmtzhL5s5U8zhbjLsq+O3wWQrst6dJKnZmSIwHvmFiX+yYOtWQ+eMurudCHuhNSEUcddSXrhlC9SFr8o7hx/cEJmtpifGQppqQj3UxjV1vU6lfPuM5/+K+nVQU64pofe3bUWYLqfFAUSarK7/YiqArQMn5d4Y3ezfNjT8m7SG2yGzWKQF1l2Rdjx3gKfTimNN+orZpqCtTjBabD6gLaaGsHk8i9FJlleJG1REnlnEeOUALOJPV8IZ+3NZl1H2y9kcof9i92BKj+pR1fxGZseMHJu490slJVdJv64lcu0XNMavwE3B4DXRm1MSw5FPAWs7YCOcR5lt0KoSclVkqENGCl97BfOxP0uqEBHeeSVirhc3lUYk6DhEX08ydyENsz4HNyVEVXPGEmwig/Cmn4Ks9o95WJ4CrP7cnuk42n+0iTt4TS35/dueydvcINEHBTauTHooUm1JelpSl2D5+L/nI+VOUM8NOKqn6TWavoH9LRpJIApvKPf8STir9g+eP/FeCffvVeitPJJUtOntuIM15U1OmvkuJczM9c6wepym7lasMCDvONlaTE3jGbzR0yJoPYygVKcJPwJuTvvvSUL+fUh+VLY2PVC40jr9VzrNdSyJdIycFJDcu/n5eyELdO9EySi/KLtmDSVeXdo9UHLcstkaBTSwlKxhpSPF4HDdzX0IxKKBGCawvwwFvRZulfnDOu3Ym4nBtTcPo2OBXn7nQplHzwRORKRUIRXYAbAiY18RK0teD9SvuXLT7Uf3Q0EqjbjtMhcSZI8AulOSh/U7Knrx33Cgk0qgeBduLqwa4r8+uFZAiBcf8lO1cLrj7FLpn
 DV5tNuKI
 kKsPVRi+VD/iv7Aj18u+0WJPMqp3mvsPO0IC0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 02:57:35PM +0200, Pratyush Yadav wrote:

> I don't think it matters if they are preserved or not. The serialization
> and deserialization is independent of that. You can very well create a
> KHO array that you don't KHO-preserve. On next boot, you can still use
> it, you just have to be careful of doing it while scratch-only. Same as
> we do now.

The KHO array machinery itself can't preserve its own memory
either.

> For the _hypervisor_ live update case, sure. Though even there, I have a
> feeling we will start seeing userspace components on the hypervisor use
> memfd for stashing some of their state. 

Sure, but don't make excessively sparse memfds for kexec use, why
should that be hard?

> applications. Think big storage nodes with memory in order of TiB. Those
> can use a memfd to back their caches so on a kernel upgrade the caches
> don't have to be re-fetched. Sparseness is to be expected for such use
> cases.

Oh? I'm surpised you'd have sparseness there. sparseness seems like
such a weird feature to want to rely on :\

> But perhaps it might be a better idea to come up with a mechanism for
> the kernel to discover which formats the "next" kernel speaks so it can
> for one decide whether it can do the live update at all, and for another
> which formats it should use. Maybe we give a way for luod to choose
> formats, and give it the responsibility for doing these checks?

I have felt that we should catalog the formats&versions the kernel can
read/write in some way during kbuild.

Maybe this turns into a sysfs directory of all the data with an
'enable_write' flag that luod could set to 0 to optimize.

And maybe this could be a kbuild report that luod could parse to do
this optimization.

And maybe distro/csps use this information mechanically to check if
version pairs are kexec compatible.

Which re-enforces my feeling that the formats/version should be first
class concepts, every version should be registered and luo should
sequence calling the code for the right version at the right time.

Jason

